---
name: submit-pr
description: Open a pull request with a minimal, reviewer-ready description — one bullet per change, optional linked Jira/GitHub issue. Takes an optional full-link issue argument. Use when submitting/opening a PR, raising a PR for the current branch, or after finishing a change set.
disable-model-invocation: true
---

# Submit PR

Open a PR a reviewer can act on without asking questions. Describe what actually changed, not what you intended — minimal, every change justified.

> **Input (optional).** The skill takes one optional argument: the Jira/GitHub issue to link. It **MUST** be a **full link** (e.g. `https://jira.sc-corp.net/browse/<JIRA-KEY>`), not a bare key — a bare key won't trigger the GHE/Jira integration. If no argument is given, leave the issue reference empty and **do not** prompt, interrupt, or ask for one.

> **Tooling — prefer MCP.** For every GitHub operation (create, edit, mark ready, comment), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_create_pr`, `ghe_pr_edit`, `ghe_pr_ready` if present. Fall back to `gh` only when no MCP tool is available.

1. **Pre-flight.** Never open a PR from `main` — branch first. Ensure all changes are committed.
2. **Scope the change set.** `git diff main...HEAD` (three-dot, vs merge-base). Write the description from the diff — what the PR genuinely does — not from memory of the task.
3. **Use the repo's template.** If `.github/` has a `PULL_REQUEST_TEMPLATE.md` (or `pull_request_template.md`), you **MUST** follow its sections; only when none exists, use the default below.
4. **Keep the bullets terse.** One bullet per change, a few words each — _what_ changed and _why_, no more. Bullets are a scannable index, not prose. Push every elaboration (context, trade-offs, mechanism, follow-ups) into `## Notes`, where detail is welcome.
5. **Don't summarize Markdown/docs changes.** For `.md` files (READMEs, docs), the rendered diff is directly readable — don't restate their contents. A single bullet naming the file is enough (e.g. "Update README — document `link-skills`"). Only when the change is large does it warrant a _very short_ summary.
6. **Link the issue — only if one was passed.** If the skill was given an issue argument, include it verbatim as a `Closes <link>` line; it **MUST** be a **full link** (not a bare key) for the GHE/Jira integration to pick it up. If no argument was given, omit the issue line entirely — do **not** infer one from the branch/commits, and do **not** ask. Add any related PRs or docs.
7. **Create the PR as a draft.** Default to a **draft** PR unless told otherwise (MCP `ghe_create_pr` with `draft: true`; else `gh pr create --draft`). Target the correct base (`main` unless told otherwise). Report the PR URL.

## Default description template

```markdown
## Changes

- <what> — <why>   # a few words; e.g. "Cache token lookups — cut auth latency"
- <what> — <why>

## Notes

<optional, and only when a bullet needs it: the fuller story — context, trade-offs,
mechanism, alternatives considered, follow-ups. Full sentences are fine here.>

Closes <full issue link>   # only if an issue arg was passed; full link MUST be used for GHE/Jira integration. Omit this line entirely otherwise.
```
