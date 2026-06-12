---
name: review-local
description: Self-review your local change set against `main` before pushing or opening a PR — correctness, security, tests, scope. Use when reviewing local uncommitted/committed changes, doing a pre-PR check, or reviewing a branch's diff against main.
---

# Review Local

Review only what this change introduces against `main` — not pre-existing code. High signal over volume.

1. **Build & test first.** Run the project's build/tests/linters (check README/CLAUDE.md/CI for the commands). If they fail, fix that before reviewing — and don't claim they pass without running them.
2. **Scope the diff.** `git diff main...HEAD` (three-dot, vs merge-base) plus `git diff HEAD` for uncommitted work. Only flag issues this change introduces.
3. **Does it do what it claims?** Check the diff fully implements the intent; flag missing/partial requirements and scope creep (behaviour that wasn't asked for).
4. **Hunt high-value misses.** Correctness (edge cases, null/empty, off-by-one, error handling), security (secrets/keys, injection, authz), leftover debug code/TODOs, and whether tests actually cover the change.
5. **Skip the noise.** Don't flag style a linter handles, pre-existing issues, or anything you can't confirm from the diff — if unsure it's real, don't flag it.
6. **Cross-check with the other agent.** Run this same review in the other harness headless and reconcile — from Claude: `codex exec "<prompt>"`; from Codex: `claude -p "<prompt>"`. Ask it for steps 1–5 only (skip this cross-check, so it doesn't recurse) and to list findings with `file:line`. Keep findings both agents confirm (high confidence), investigate disagreements, and drop anything neither can substantiate from the diff.
7. **Report by severity + verdict.** Merge into one list grouped as **Critical / Important / Minor**, each with `file:line`, what's wrong, why it matters, and the fix; note where the two agents disagreed. End with: ready to push? (yes / no / with fixes). If it's clean, say so — don't invent issues.
