---
name: review-local
description: Self-review your local change set against `main` before pushing or opening a PR — correctness, security, tests, scope. Use when reviewing local uncommitted/committed changes, doing a pre-PR check, or reviewing a branch's diff against main.
disable-model-invocation: true
---

# Review Local

Review only what this change introduces against `main` — not pre-existing code. High signal over volume.

1. **Build & test first.** Run the project's build/tests/linters (check README/CLAUDE.md/CI for the commands). If they fail, fix that before reviewing — and don't claim they pass without running them. Do this once, up front, before launching either review.
2. **Launch both reviews in parallel.** Run two independent reviews concurrently against the checklist in steps 3–6, then combine at the end (step 7) — don't run them sequentially:
   - **You** review the diff yourself against steps 3–6.
   - **The other agent** runs the same checklist as a headless cross-reviewer in the background. The reliable way to run it is to **hand over the scope and disable exploration** — not to plead with it in prose. Past failures came from launching the reviewer loose inside the repo and asking it nicely to "use ≤15 tool calls / not read skill files": it ignores that, falls into an unbounded verify-and-explore spiral, and gets hard-killed by the timeout before emitting anything. Instead, give it the **full diff inlined in the prompt** (so there is nothing to discover), run it **with exploration structurally disabled** and **stdin closed** (`codex exec` hangs reading stdin if it's left open — the usual cause of an intermittent freeze), and make it **write schema-validated findings to a file** (so output survives and you read one file, not a log). Run the block below — `3a` if you are Claude (spawn Codex), `3b` if you are Codex (spawn Claude):

   ```bash
   # 0. Per-run temp dir, keyed off the branch — reconstructible in later steps without shell state,
   #    and won't clobber a concurrent review on another branch. Recompute this same line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"

   # 1. Capture the exact change set — this IS the scope; the reviewer never rediscovers it.
   git diff main...HEAD > $RD/diff.txt
   git diff HEAD >> $RD/diff.txt   # include uncommitted work too

   # 2. Write the findings schema once (single line — safe regardless of indentation).
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["critical","important","minor"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json

   # 3. Inline the review criteria (the substance of steps 3–6) — never reference this skill or step numbers.
   CRITERIA="You are a strict code reviewer. The COMPLETE diff to review is below the ===DIFF=== marker. Review ONLY that text — do NOT run shell commands, read files, or explore the repo, CLIs, docs, or skill files; everything you need is in the diff. Find: leaked secrets/keys/tokens; correctness bugs (edge cases, null/empty, off-by-one, error handling); behaviour that does not match the change's apparent intent, and missing/partial requirements; scope creep; leftover debug code or TODOs; and whether tests actually cover the change. High signal only — skip style a linter handles, pre-existing issues, and anything you cannot confirm from the diff."

   # 3a. FROM CLAUDE → spawn the Codex reviewer (read-only sandbox, no user config/rules, stdin closed, schema enforced to a file):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
       --output-schema $RD/schema.json -o $RD/other.json \
       "$CRITERIA

   ===DIFF===
   $(cat $RD/diff.txt)" < /dev/null) > $RD/other.log 2>&1 &

   # 3b. FROM CODEX → spawn the Claude reviewer (all tools disabled, stdin closed, JSON envelope):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     claude -p "$CRITERIA Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"critical|important|minor\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   ===DIFF===
   $(cat $RD/diff.txt)" \
       --tools "" --output-format json --no-session-persistence < /dev/null) > $RD/other.json 2>&1 &
   ```

   Inlining the diff via `"$(cat …)"` is safe — command-substitution output is not re-evaluated, so diff content can't run as shell. The reviewer finishes well under the timeout (≈20–60s for a typical diff); the `perl alarm` is only a backstop that scales with diff size. Keep doing your own review while it runs, then `wait`.
3. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base) plus `git diff HEAD` for uncommitted work. Only flag issues this change introduces.
4. **Does it do what it claims?** Check the diff fully implements the intent; flag missing/partial requirements and scope creep (behaviour that wasn't asked for).
5. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
6. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
7. **Combine results.** Once your own review is done, `wait` for the background reviewer and read `$RD/other.json` (recompute `RD` with the same line from the block above if your shell no longer has it set):
   - **From Claude** (Codex reviewer): the file *is* the findings object (`{findings, verdict}`) — read it directly.
   - **From Codex** (Claude reviewer): the file is an envelope — extract the payload with `jq -r '.result'`, then parse that as the findings JSON.

   If the file is missing, empty, or not valid JSON (e.g. the reviewer was hard-killed by the timeout), state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own review alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the diff.
8. **Report by severity + verdict.** Merge into one **numbered** list grouped as **Critical / Important / Minor** (number findings continuously `1..N` so they're easy to refer back to), each with `file:line`, what's wrong, why it matters, and the fix; note where the two agents disagreed. End with: ready to push? (yes / no / with fixes). If it's clean, say so — don't invent issues.
