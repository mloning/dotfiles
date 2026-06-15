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
   - **The other agent**, headless and in the background, runs the same checklist — from Claude: `codex exec "<prompt>"`; from Codex: `claude -p "<prompt>"`. Tell it to do steps 3–6 only (skip this parallel step so it doesn't recurse, and skip the build/tests/linters from step 1 since you've already run them — only one agent needs to) and to list findings with `file:line`. Kick it off in the background and keep doing your own review — don't block waiting on it.
3. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base) plus `git diff HEAD` for uncommitted work. Only flag issues this change introduces.
4. **Does it do what it claims?** Check the diff fully implements the intent; flag missing/partial requirements and scope creep (behaviour that wasn't asked for).
5. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
6. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
7. **Combine results.** Once your own review is done and the other agent has returned, reconcile the two into one list: keep findings both agents confirm (high confidence), investigate disagreements, and drop anything neither can substantiate from the diff.
8. **Report by severity + verdict.** Merge into one list grouped as **Critical / Important / Minor**, each with `file:line`, what's wrong, why it matters, and the fix; note where the two agents disagreed. End with: ready to push? (yes / no / with fixes). If it's clean, say so — don't invent issues.
