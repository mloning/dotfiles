---
name: review-pr
description: Review a remote pull request — its change set plus the PR description, conversation, and linked resources like Jira tickets. The remote counterpart to `review-local`. Use when reviewing a GitHub PR, a teammate's PR, or a PR by number/URL.
disable-model-invocation: true
---

# Review PR

The remote counterpart to `review-local`: review only what the PR introduces against `main` — not pre-existing code — plus the context it carries (description, conversation, linked tickets). High signal over volume. Verify independently; don't trust the PR's own framing of what it does.

> **Tooling — prefer MCP.** For every GitHub operation (resolving the PR, fetching the diff/description/conversation, posting review comments), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_get_pr`, `ghe_pr_diff`, `ghe_pr_all_feedback`, `ghe_add_review_comment` if present. Fall back to `gh` only when no MCP tool is available (e.g. `gh pr checkout`, which has no MCP equivalent).

## Usage

```
/review-pr [pr]
```

`[pr]` is an optional PR number or URL. With no argument, review the PR linked to the **current branch** (GitHub MCP `ghe_my_prs`, else `gh pr view` with no arg); if the branch has no open PR, say so and stop.

1. **Resolve & fetch the PR.** Resolve the target (the arg, or the current branch's PR). Fetch the change set, description, and conversation — GitHub MCP, or `gh pr view <pr>` / `gh pr diff <pr>`. Check out the branch (`gh pr checkout <pr>`) so the diff is local. Pull any linked Jira tickets and referenced docs/PRs.
2. **Build & test first.** Run the project's build/tests/linters (check README/CLAUDE.md/CI for the commands). If they fail, say so — and don't claim they pass without running them. Do this once, up front, before launching either review.
3. **Launch both reviews in parallel.** Run two independent reviews concurrently against the checklist in steps 4–8, then combine at the end (step 9) — don't run them sequentially:
   - **You** review the diff yourself against steps 4–8.
   - **The other agent** runs the same checklist as a headless cross-reviewer in the background. Run it the reliable way — **hand over the scope and disable exploration**, don't plead in prose (the loose-in-the-repo reviewer ignores "use ≤15 tool calls / don't read skill files," spirals, and gets hard-killed before emitting anything). Give it the **full diff plus the PR/ticket context inlined in the prompt**, run it **with exploration structurally disabled** and **stdin closed** (`codex exec` hangs reading an open stdin), and make it **write schema-validated findings to a file**. Run the block below — `3a` if you are Claude (spawn Codex), `3b` if you are Codex (spawn Claude):

   ```bash
   # 0. Per-run temp dir, keyed off the branch — reconstructible in later steps without shell state,
   #    and won't clobber a concurrent review on another branch. Recompute this same line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"

   # 1. Capture the exact PR change set — this IS the scope; the reviewer never rediscovers it.
   git diff main...HEAD > $RD/diff.txt

   # 2. Capture the PR context the reviewer must check the diff against (fill these in from step 1).
   {
     echo "PR DESCRIPTION:"; echo "<paste the PR description>"
     echo "LINKED TICKET ACCEPTANCE CRITERIA:"; echo "<paste, or none>"
     echo "UNRESOLVED REVIEW COMMENTS:"; echo "<paste open threads, or none>"
   } > $RD/context.txt

   # 3. Write the findings schema once (single line — safe regardless of indentation).
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["critical","important","minor"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json

   # 4. Inline the review criteria (the substance of steps 4–8) — never reference this skill or step numbers.
   CRITERIA="You are a strict PR reviewer. Below are the PR CONTEXT and the COMPLETE diff (after the ===DIFF=== marker). Review ONLY this text — do NOT run shell commands, read files, or explore the repo, CLIs, docs, or skill files; everything you need is here. Check: does the diff fully implement the PR description and satisfy the linked ticket's acceptance criteria (flag drift, missing/partial requirements, scope creep beyond the ticket); leaked secrets/keys/tokens; correctness bugs (edge cases, null/empty, off-by-one, error handling); leftover debug code or TODOs; whether tests cover the change; and whether the unresolved review comments are actually addressed by the diff. High signal only — skip style a linter handles, pre-existing issues, and anything you cannot confirm from the diff."

   # 3a. FROM CLAUDE → spawn the Codex reviewer (read-only sandbox, no user config/rules, stdin closed, schema enforced to a file):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
       --output-schema $RD/schema.json -o $RD/other.json \
       "$CRITERIA

   === PR CONTEXT ===
   $(cat $RD/context.txt)

   ===DIFF===
   $(cat $RD/diff.txt)" < /dev/null) > $RD/other.log 2>&1 &

   # 3b. FROM CODEX → spawn the Claude reviewer (all tools disabled, stdin closed, JSON envelope):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     claude -p "$CRITERIA Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"critical|important|minor\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   === PR CONTEXT ===
   $(cat $RD/context.txt)

   ===DIFF===
   $(cat $RD/diff.txt)" \
       --tools "" --output-format json --no-session-persistence < /dev/null) > $RD/other.json 2>&1 &
   ```

   Inlining via `"$(cat …)"` is safe — command-substitution output is not re-evaluated. The reviewer finishes well under the timeout; the `perl alarm` is only a backstop. Keep doing your own review while it runs, then `wait`.
4. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base). Only flag issues this PR introduces.
5. **Does it do what it claims?** Check the diff fully implements the PR *description* and satisfies the linked *Jira ticket's* acceptance criteria; flag drift between stated intent and actual change, missing/partial requirements, and scope creep beyond the ticket.
6. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
7. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
8. **Check the conversation.** Are unresolved review comments and prior reviewer concerns actually addressed by the current diff? Flag anything raised and left open.
9. **Combine results.** Once your own review is done, `wait` for the background reviewer and read `$RD/other.json` (recompute `RD` with the same line from the block above if your shell no longer has it set):
   - **From Claude** (Codex reviewer): the file *is* the findings object (`{findings, verdict}`) — read it directly.
   - **From Codex** (Claude reviewer): the file is an envelope — extract the payload with `jq -r '.result'`, then parse that as the findings JSON.

   If the file is missing, empty, or not valid JSON (e.g. the reviewer was hard-killed by the timeout), state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own review alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the diff.
10. **Report by severity + verdict.** One **numbered** list grouped **Critical / Important / Minor** (number findings continuously `1..N` so they're easy to refer back to), each with `file:line`, what's wrong, why it matters, and the fix; note where the two agents disagreed. End with a verdict: **approve / request changes / comment**. If it's clean, say so — don't invent issues. If asked, post the findings as PR review comments (GitHub MCP or `gh pr review`); otherwise just report.
