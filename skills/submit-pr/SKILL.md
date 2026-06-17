---
name: submit-pr
description: Open a pull request with a minimal, reviewer-ready description — one bullet per change, linked Jira issue. Use when submitting/opening a PR, raising a PR for the current branch, or after finishing a change set.
disable-model-invocation: true
---

# Submit PR

Open a PR a reviewer can act on without asking questions. Describe what actually changed, not what you intended — minimal, every change justified.

1. **Pre-flight.** Never open a PR from `main` — branch first. Ensure all changes are committed.
2. **Scope the change set.** `git diff main...HEAD` (three-dot, vs merge-base). Write the description from the diff — what the PR genuinely does — not from memory of the task.
3. **Use the repo's template.** If `.github/` has a `PULL_REQUEST_TEMPLATE.md` (or `pull_request_template.md`), follow its sections; otherwise use the default below.
4. **Keep the bullets terse.** One bullet per change, a few words each — _what_ changed and _why_, no more. Bullets are a scannable index, not prose. Push every elaboration (context, trade-offs, mechanism, follow-ups) into `## Notes`, where detail is welcome.
5. **Don't summarize Markdown/docs changes.** For `.md` files (READMEs, docs), the rendered diff is directly readable — don't restate their contents. A single bullet naming the file is enough (e.g. "Update README — document `link-skills`"). Only when the change is large does it warrant a _very short_ summary.
6. **Link the Jira issue.** Find the issue key (branch name, commit messages, or ask) and link it in the description; add any related PRs or docs.
7. **Create the PR as a draft.** Default to a **draft** PR unless told otherwise — `gh pr create --draft`, or the GitHub MCP tool's `draft: true`. Prefer the MCP tool; otherwise `gh pr create`. Target the correct base (`main` unless told otherwise). Report the PR URL.

## Default description template

```markdown
## Changes

- <what> — <why>   # a few words; e.g. "Cache token lookups — cut auth latency"
- <what> — <why>

## Notes

<optional, and only when a bullet needs it: the fuller story — context, trade-offs,
mechanism, alternatives considered, follow-ups. Full sentences are fine here.>

Closes <JIRA-KEY>
```
