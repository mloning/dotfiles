---
name: submit-pr
description: Use when opening a pull request (PR) for the current branch. Open a PR that explains why the change was made and why this way, following the repo's PR template, plus any non-obvious way to test it. Optionally links a Jira/GitHub issue.
---

# Submit PR

The title says what changed. The body says **why** — and nothing a reviewer can read off the diff.

Two separate concerns, don't mix them up:

- **Structure comes from the repo's PR template.** Its sections are the contract — never add, drop, rename, or reorder them.
- **Altitude comes from this skill, and it wins.** Whatever section you're filling, and whatever its prompt says, write intent, not a changelog. A sentence or bullet that restates a file, function, or edit is too low — merge it into the intent it serves.

## Usage

```
/submit-pr [issue-link]
```

`[issue-link]` is optional: the Jira/GitHub issue to link via `Closes`. It **MUST** be a **full link** (e.g. `https://jira.sc-corp.net/browse/<JIRA-KEY>`), not a bare key — a bare key won't trigger the GHE/Jira integration. If omitted, leave the issue reference empty and **do not** prompt, interrupt, or ask for one.

> **Tooling — prefer MCP.** For every GitHub operation (create, edit, mark ready, comment), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_create_pr`, `ghe_pr_edit`, `ghe_pr_ready` if present. Fall back to `gh` only when no MCP tool is available.

1. **Pre-flight.** Never open a PR from `main` — branch first. Ensure all changes are committed.
2. **Scope the change set.** Read `git diff main...HEAD` (three-dot, vs merge-base). Write from the diff — what the PR genuinely does — not from memory of the task.
3. **Read `.github/PULL_REQUEST_TEMPLATE.md` and obey it.** That is the only path it lives at — if the file isn't there, the repo has no template, so use the default below. If it is, you **MUST** reproduce its sections verbatim — same headings, same order, nothing added, nothing dropped. Follow its inline instructions, then delete the HTML comments — but they govern structure, not altitude: where one asks you to list the changes, comply at intent level (~2–5 bullets grouped by purpose, never one per file or commit). Tick checklist boxes only for work you actually did.
4. **Write the why, not the what.** In whichever section asks for a description, summary, or changes: **≤3 sentences** on the problem or goal that made this change necessary. Prose by default; bullets only when the PR carries two or three genuinely independent whys — one bullet per why, never one per change. Name a component when it _is_ the subject (e.g. "move the token store off Redis"), but never enumerate the files, functions, or modules you touched. If a sentence could be derived by reading the diff, cut it.
5. **Explain the approach only if a reviewer would ask "why this way?"** 1–2 sentences — the alternative you rejected, the constraint that forced the design, the tradeoff you took. Skip it when the implementation is the obvious one. With no dedicated section, it goes at the end of the description.
6. **Give test commands only when they aren't guessable.** A repro script, the specific failing case, a required flag or env var, a manual check to click through. Never restate the repo's standard commands (`pytest`, `npm test`, `make`) — the reviewer knows them. If the template has a testing section and you have nothing non-obvious, close it out in one line — "Covered by the existing test suite; no manual steps." — and don't pad it. With no such section, add nothing.
7. **Link the issue — only if one was passed.** Include it verbatim as `Closes <full link>`; a bare key won't trigger the GHE/Jira integration. If no argument was given, omit the line entirely — do **not** infer one from the branch or commits, and do **not** ask. The linked issue is the reviewer's single entry point, so don't also reference its epic, parent, or siblings; add a related PR or doc only when it genuinely isn't reachable from there.
8. **Write the title — it carries the _what_.** The body never states it, so the title must: one imperative line, ~70 chars, no trailing period. Match the repo's convention before inventing one — check `git log --oneline -20 main` for a Conventional Commits prefix, a `[JIRA-123]` tag, or whatever is there.
9. **Create the PR as a draft.** Default to a **draft** PR unless told otherwise (MCP `ghe_create_pr` with `draft: true`; else `gh pr create --draft`). Target the correct base (`main` unless told otherwise). Report the PR URL.

## Filling someone else's template

| Section it asks for | What you put there |
| --- | --- |
| Description, Summary, What, Changes | the **why** (step 4) — a `Changes` heading is not permission to write a changelog; if it explicitly asks for a list, keep the bullets at intent level |
| Motivation, Context, Background, Why | the why, then the approach (step 5) |
| Testing, How has this been tested?, Validation | step 6 only — one line if nothing is non-obvious |
| Type of change, checklists | tick honestly; leave the rest unticked |
| Screenshots, Demo | only when the change is user-visible; otherwise `N/A` |
| Anything you have no content for | one line or `N/A` — never invented filler, never delete the heading |

## Default description template

Only when the repo has no template. There is deliberately no changes list — the title and the
diff cover *what*. Unlike a repo's template, nothing here is a contract: `Approach` and
`Testing` are optional, and an empty section is worse than no section — delete the heading too.

```markdown
## Why

<≤3 sentences: the problem or goal. Name a component only when it is the subject.>

## Approach

<1–2 sentences — delete this heading unless a reviewer would ask "why this way?">

## Testing

<the non-obvious command or manual check — delete this heading if there isn't one>

Closes <full issue link> # only if an issue arg was passed. One ticket, no epic alongside it.
```

## Example

A PR adding frequency-domain metrics to an aligner benchmark, into a repo whose template
has `## Description`, `## How Has This Been Tested?`, and a checklist:

```markdown
## Description

RMSE scored the interpolators as near-equivalent when they aren't — energy smeared into
interpolation sidebands barely moves a time-domain error. The benchmark now scores
frequency-domain distortion directly, so the ranking reflects real quality.

## How Has This Been Tested?

`uv run benchmark --metrics sar_db` — SAR must rank cubic > linear > nearest.

## Checklist

- [x] Tests added
- [ ] Docs updated
```

Everything else in that diff stays out of the body: the new DSP module, its wiring into
the benchmark, the deepcopy fix, promoting scipy to a core dependency, the new test file.
All of it is diff-level detail the reviewer reads in the diff.
