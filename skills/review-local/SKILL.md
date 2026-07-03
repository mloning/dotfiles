---
name: review-local
description: Self-review your local change set against `main` before pushing or opening a PR — correctness, security, tests, scope. Use when reviewing local uncommitted/committed changes, doing a pre-PR check, or reviewing a branch's diff against main.
disable-model-invocation: true
---

# Review Local

Review only what this change introduces against `main` — not pre-existing code. High signal over volume.

1. **Build & test first.** Run the project's build/tests/linters (check README/CLAUDE.md/CI for the commands). If they fail, fix that before reviewing — and don't claim they pass without running them. Do this once, up front, before launching the reviews.
2. **Launch your review + a focused cross-review fleet in parallel.** Run these concurrently, then combine at the end (step 7) — don't run them sequentially:
   - **You** do a holistic self-review of the diff against steps 3–6. Read the diff once; only crawl the repo to chase a *specific named risk* (e.g. confirm a changed function's callers are updated) — don't re-explore the whole tree.
   - **Four focused headless cross-reviewers** run in the background, one narrow aspect each: **correctness, security, spec & requirements, test coverage**. One lens per reviewer goes deeper than a single generalist running the whole checklist. Run them the reliable way — **hand over the scope and disable exploration**, don't plead in prose. Past failures came from launching a reviewer loose inside the repo and asking it nicely to "use ≤15 tool calls / not read skill files": it ignores that, spirals into an unbounded verify-and-explore loop, and gets hard-killed by the timeout before emitting anything. Instead, give each reviewer the **full diff inlined in the prompt** (nothing to discover), run it **with exploration structurally disabled** and **stdin closed** (`codex exec` hangs reading an open stdin — the usual cause of an intermittent freeze), and make it **write schema-validated findings to its own file** (output survives; you read one file per lens). Define the `reviewer()` function for your agent — `4a` if you are Claude (spawn Codex), `4b` if you are Codex (spawn Claude) — then run the four spawn calls in `5`:

   ```bash
   # 0. Per-run temp dir, keyed off the branch — reconstructible in later steps without shell state,
   #    and won't clobber a concurrent review on another branch. Recompute this same line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"

   # 1. Capture the exact change set — this IS the scope; the reviewers never rediscover it.
   git diff main...HEAD > $RD/diff.txt
   git diff HEAD >> $RD/diff.txt   # include uncommitted work too

   # 2. Write the findings schema once (single line — safe regardless of indentation).
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["critical","important","minor"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json

   # 3. Shared preamble — the constant scope + constraints; only the per-lens ASPECT varies.
   PREAMBLE="You are a strict code reviewer assigned ONE aspect only. The COMPLETE diff to review is below the ===DIFF=== marker. Review ONLY that text — do NOT run shell commands, read files, or explore the repo, CLIs, docs, or skill files; everything you need is in the diff. Report only issues within your assigned aspect. High signal only — skip style a linter handles, pre-existing issues, and anything you cannot confirm from the diff."

   # 4a. FROM CLAUDE → define reviewer() to spawn one focused Codex reviewer per aspect
   #     (read-only sandbox, no user config/rules, stdin closed, schema enforced to a per-lens file):
   reviewer() {   # $1 = aspect slug, $2 = aspect focus
     (perl -e 'alarm shift; exec @ARGV' 600 \
       codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
         --output-schema $RD/schema.json -o "$RD/lens-$1.json" \
         "$PREAMBLE
   YOUR ASPECT: $2

   ===DIFF===
   $(cat $RD/diff.txt)" < /dev/null) > "$RD/lens-$1.log" 2>&1 &
   }

   # 4b. FROM CODEX → define reviewer() to spawn one focused Claude reviewer per aspect
   #     (all tools disabled, stdin closed, JSON envelope written to a per-lens file):
   reviewer() {   # $1 = aspect slug, $2 = aspect focus
     (perl -e 'alarm shift; exec @ARGV' 600 \
       claude -p "$PREAMBLE
   YOUR ASPECT: $2
   Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"critical|important|minor\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   ===DIFF===
   $(cat $RD/diff.txt)" \
         --tools "" --output-format json --no-session-persistence < /dev/null) > "$RD/lens-$1.json" 2>&1 &
   }

   # 5. Spawn all four focused reviewers (identical for both agents once reviewer() is defined).
   reviewer correctness "correctness bugs — wrong logic, unhandled edge cases (null/empty/boundary), off-by-one, missing or incorrect error handling, race conditions, resource leaks."
   reviewer security    "security — leaked secrets/keys/tokens, injection (SQL/command/path/template), missing authz/authn checks, unsafe handling of untrusted input, unsafe deserialization."
   reviewer spec        "spec & requirements — does the diff fully implement its apparent intent; flag drift between intent and actual change, missing or partial requirements, and scope creep (behaviour that wasn't asked for)."
   reviewer tests       "test coverage — do the tests actually exercise the new/changed behaviour (not just assert on mocks); missing tests for new code paths and edge cases; skipped tests, leftover debug code, or TODOs."
   ```

   Inlining the diff via `"$(cat …)"` is safe — command-substitution output is not re-evaluated, so diff content can't run as shell. Each reviewer finishes well under the timeout (≈20–60s for a typical diff); the `perl alarm` is only a backstop that scales with diff size. The four run concurrently, so wall-clock ≈ the slowest lens, not the sum. Keep doing your own review while they run, then `wait`.
3. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base) plus `git diff HEAD` for uncommitted work. Only flag issues this change introduces.
4. **Does it do what it claims?** Check the diff fully implements the intent; flag missing/partial requirements and scope creep (behaviour that wasn't asked for).
5. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
6. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
7. **Combine results.** Once your own review is done, `wait` for the background reviewers, then read the four `$RD/lens-*.json` files (recompute `RD` with the same line from the block if your shell no longer has it set):
   - **From Claude** (Codex reviewers): each file *is* the findings object (`{findings, verdict}`) — read it directly.
   - **From Codex** (Claude reviewers): each file is an envelope — extract the payload with `jq -r '.result'`, then parse that as the findings JSON.

   For any lens whose file is missing, empty, or not valid JSON (e.g. hard-killed by the timeout), say so explicitly and move on — don't fabricate its findings. Take the **union** of your own findings and all lens findings, **dedup** (same `file:line` + same issue), then **confirm each survivor against the diff yourself** and drop anything you can't substantiate. Never produce a vacuous "no issues" summary when reviewers failed to run.
8. **Report by severity + verdict.** Merge into one **numbered** list grouped as **Critical / Important / Minor** (number findings continuously `1..N` so they're easy to refer back to), each with `file:line`, what's wrong, why it matters, and the fix. Evidence before claims: don't state the change is clean, or that build/tests pass, unless you actually ran them in step 1 — and drop hedge words ("should" / "probably" / "seems to") from the verdict; if you can't confirm something, verify it or say so. End with: ready to push? (yes / no / with fixes). If it's clean, say so — don't invent issues.
