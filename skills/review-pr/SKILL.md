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
3. **Launch both reviews in parallel.** Run two independent reviews concurrently against the checklist in steps 4–7, then combine at the end (step 9) — don't run them sequentially:
   - **You** review the diff yourself against steps 4–7.
   - **The other agent**, headless and in the background, runs the same checklist. `perl -e 'alarm shift; exec @ARGV' 300` is a portable 5-minute hard-kill (macOS ships no `timeout`/`gtimeout`). From Claude: `(perl -e 'alarm shift; exec @ARGV' 300 codex exec "<prompt>") > /tmp/review-pr-other.log 2>&1 &`; from Codex: `(perl -e 'alarm shift; exec @ARGV' 300 claude -p "<prompt>" --output-format stream-json --include-partial-messages --verbose --no-session-persistence) > /tmp/review-pr-other.log 2>&1 &`. **Build it a self-contained prompt:** give it the PR diff, description, and linked ticket, and inline the actual review criteria (the substance of steps 4–7) directly — never say "follow this skill" or cite step numbers, because the headless agent has no skill loaded and will burn its entire budget hunting through skill files to reconstruct them (this is the usual cause of an empty `FINDINGS_JSON`). Also tell it to skip step 2's build/tests (you've run them), not to spawn its own second reviewer (no recursion), and to list findings with `file:line`. Add these three constraints verbatim to its prompt: (1) **"Use at most 15 tool calls total — spend them on the diff and the files it touches, never on reading skill or doc files."** (2) **"Do not open, read, or follow any skill files (`SKILL.md` or `references/`); everything you need is already in this prompt."** (3) **"The last thing you output must be a fenced JSON block opened with the line `FINDINGS_JSON` containing your findings array and a verdict string."** Kick it off in the background and keep doing your own review — the 5-minute timeout hard-kills it if it hasn't finished.
4. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base). Only flag issues this PR introduces.
5. **Does it do what it claims?** Check the diff fully implements the PR *description* and satisfies the linked *Jira ticket's* acceptance criteria; flag drift between stated intent and actual change, missing/partial requirements, and scope creep beyond the ticket.
6. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
7. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
8. **Check the conversation.** Are unresolved review comments and prior reviewer concerns actually addressed by the current diff? Flag anything raised and left open.
9. **Combine results.** Once your own review is done, wait for the background process (`wait`) then read `/tmp/review-pr-other.log` and look for the `FINDINGS_JSON` block. If the log is empty, has no `FINDINGS_JSON` block, or the process was killed by the 5-minute timeout, state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own review alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the diff.
10. **Report by severity + verdict.** One list grouped **Critical / Important / Minor**, each with `file:line`, what's wrong, why it matters, and the fix; note where the two agents disagreed. End with a verdict: **approve / request changes / comment**. If it's clean, say so — don't invent issues. If asked, post the findings as PR review comments (GitHub MCP or `gh pr review`); otherwise just report.
