---
name: submit-pr
description: Use when opening a pull request (PR) for the current branch. Open a PR whose body says why the change was made, reports what changed at intent level, states test status, and stays under 250 words, following the repo's PR template. Optionally links a Jira/GitHub issue.
---

# Submit PR

The title says what changed. The body says **why it had to** — then reports what changed at intent
level, and nothing else a reviewer can read off the diff. Report; don't explain, and don't persuade.

Three separate concerns, don't mix them up:

- **Structure comes from the repo's PR template.** Its sections are the contract — never add, drop, rename, or reorder them.
- **Altitude comes from this skill, and it wins.** Whatever section you're filling, and whatever its prompt says, write intent, not a changelog. A sentence or bullet that restates a file, function, or edit is too low — merge it into the intent it serves.
- **Length is a hard constraint, not a preference.** See the budget below. A body that has to be trimmed by hand after posting was written wrong.

## Cut before you post

Budget the **whole body at 150–250 words**, whatever the size of the diff — 35 files and a thousand
changed lines still fit in 250. Past ~300 you are explaining rather than reporting, and the fix is
never a gentler edit: cut a third. What goes, in order:

- **The design essay.** The alternative you rejected, what you picked it over, why the README that says otherwise is out of date.
- **Emphasis and reviewer-coaching.** Bold text; "that is the gap a reviewer should weigh".
- **Second-order verification detail.** One clause for what you checked — not the temp prefix you installed into and the file modes it reproduced.
- **Background notes.** Keep a closing note only when a reviewer or the next person acts on it: a dead feature that had no users, a stale build tree to delete. Cut naming history and anything that is merely interesting.
- **Nested sub-clauses.** Semicolon chains that explain the explanation, and defensive asides ("rather than just tidiness"). Three plain facts in a row beat one sentence carrying all three.

## Never hard-wrap the body

**One paragraph or bullet = one unbroken line, however long.** GitHub renders a single newline as a
line break, so wrapping to a column width shows up as ragged mid-sentence breaks. Newlines only
separate blocks — paragraphs, bullets, fenced code.

## Usage

```
/submit-pr [issue-link]
```

`[issue-link]` is optional: the Jira/GitHub issue to link via `Closes`. It **MUST** be a **full link** (e.g. `https://jira.sc-corp.net/browse/<JIRA-KEY>`), not a bare key — a bare key won't trigger the GHE/Jira integration. If omitted, leave the issue reference empty and **do not** prompt, interrupt, or ask for one.

> **Tooling — prefer MCP.** For every GitHub operation (create, edit, mark ready, comment), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_create_pr`, `ghe_pr_edit`, `ghe_pr_ready` if present. Fall back to `gh` only when no MCP tool is available.

1. **Pre-flight.** Never open a PR from `main` — branch first. Ensure all changes are committed.
2. **Scope the change set.** Read `git diff main...HEAD` (three-dot, vs merge-base). Write from the diff — what the PR genuinely does — not from memory of the task.
3. **Read `.github/PULL_REQUEST_TEMPLATE.md` and obey it.** That is the only path it lives at — if the file isn't there, the repo has no template, so use the default below. If it is, you **MUST** reproduce its sections verbatim — same headings, same order, nothing added, nothing dropped. Follow its inline instructions, then delete the HTML comments — but they govern structure, not altitude: where one asks you to list the changes, comply at the altitude and length step 4 sets. Tick checklist boxes only for work you actually did.
4. **Write the why, then what changed.** Two blocks, in whichever section asks for a description, summary, or changes:
   - **Why** — 2–3 sentences on the problem that made this necessary and what it actually cost. Concrete failures, not abstractions: "the hand-maintained ship list never included `set-wifi`, and a macOS configure silently installed nothing at all" beats "the directory's contract held for some of its contents and not others".
   - **What changed** — 3–6 bullets when the PR does several separable things; none at all when it does one, because then the title and diff already cover it. One bullet per change at intent level, each one rendered line, carrying at most one clause of purpose. Never one bullet per file or commit, and never enumerate the functions or modules you touched.
5. **Justify the approach in a clause, not a paragraph.** Only where a reviewer would otherwise block on "why this way?", and then inside the bullet it belongs to. No alternatives-considered section, no narrating the decision ("I chose this over…", "this deliberately overrides…"), no arguing with the repo's own docs. A design that needs a paragraph to defend it belongs in a doc the PR links to.
6. **State test status in one or two plain sentences.** What you ran, and flatly what you did not: "Not run on glasses. Verified off-device: both build trees re-configure, and every script runs against a stubbed `adb`." No bold, and never tell the reviewer what to weigh or focus on — that is their call. Commands only when they aren't guessable: a repro, the specific failing case, a required flag or env var. Never restate the repo's standard commands (`pytest`, `npm test`, `make`) — the reviewer knows them. Nothing non-obvious and a section to fill? One line — "Covered by the existing test suite; no manual steps." — and no padding. No such section, add nothing.
7. **Link the issue — only if one was passed.** Include it verbatim as `Closes <full link>`; a bare key won't trigger the GHE/Jira integration. If no argument was given, write `N/A` where a section asks for the reference and otherwise omit the line entirely — do **not** infer one from the branch or commits, and do **not** ask. The linked issue is the reviewer's single entry point, so don't also reference its epic, parent, or siblings; add a related PR or doc only when it genuinely isn't reachable from there.
8. **Write the title — it carries the _what_.** The body only reports the pieces, so the title has to state the change whole: one imperative line, ~70 chars, no trailing period. Match the repo's convention before inventing one — check `git log --oneline -20 main` for a Conventional Commits prefix, a `[JIRA-123]` tag, or whatever is there.
9. **Create the PR as a draft.** Default to a **draft** PR unless told otherwise (MCP `ghe_create_pr` with `draft: true`; else `gh pr create --draft`). Target the correct base (`main` unless told otherwise). Report the PR URL.

## Filling someone else's template

| Section it asks for | What you put there |
| --- | --- |
| Description, Summary, What, Changes, What does this PR change? | the why, then the bullets (step 4) — a `Changes` heading is not permission to write a changelog, and it is not an invitation to argue the design either |
| Motivation, Context, Background, Why | the why only; the approach stays a clause inside a bullet (step 5) |
| Testing, How has this been tested?, Validation | step 6 only — one line if nothing is non-obvious |
| Type of change, checklists | tick honestly; leave the rest unticked |
| Screenshots, Demo | only when the change is user-visible; otherwise `N/A` |
| Anything you have no content for | one line or `N/A` — never invented filler, never delete the heading |

## Default description template

Only when the repo has no template. Use both headings, verbatim and in this order — `N/A` under the
first when no issue was passed, rather than deleting it. There is deliberately no `Approach`
heading; a design that needs its own section belongs in a doc this PR links to.

```markdown
#### Reference issues/PRs

Closes <full issue link> # only if an issue arg was passed; one ticket, no epic alongside it. Otherwise `N/A`.

#### What does this PR change?

<2–3 sentences: the problem, and what it cost in practice. Name a component only when it is the subject.>

<3–6 bullets, one line each, only if the PR does several separable things — omit entirely if it does one>

<test status in one or two plain sentences: what you ran, what you did not, and the non-obvious command — omit if there is nothing>
```

## Example

35 files, +267/−743, written against the default template above. 250 words, and note
what each block is doing: two sentences of concrete cost, bullets that report rather
than defend, a flat test status, and one note the reader can act on.

```markdown
#### Reference issues/PRs

N/A

#### What does this PR change?

`libnm/spectacles/bin/` is the staging source of the release bundle's `bin/`, but it also held three scripts that never shipped and only served development. That mixed contract cost real things: the hand-maintained ship list never included `set-wifi`, a macOS configure silently installed nothing at all, and the dev scripts built into a second build tree under an unpinned Python.

- Separate the dev tools from the release tools: `snapos-install`, `snapos-build` and `start_gdb` become the `just` recipes `push-specs`, `install-specs`, `install-specs-log` and `gdb-specs`, all building in the one tree `just configure` sets up
- Install the whole directory instead of a list of names, so a new script ships without being remembered into `bin/CMakeLists.txt`; this also fixes the `HAWAII` guard and starts shipping `set-wifi`
- Put each script's own directory on `PATH`, so any of them runs by path out of a checkout and not only from a bundle where `setup_release.sh` has exported it
- Resolve the app SoC in `nm-install-release` with `adb-serial` instead of a third copy of that search
- Repoint the three on-device harnesses at the new recipes

Not run on glasses. Verified off-device: both build trees re-configure (Hawaii installs all 22 scripts, macOS none), and every script and recipe runs against a stubbed `adb` with `bin/` kept off `PATH`.

Two notes: `snapos-build -s asan|tsan|ubsan` had no users, and `nlo/profiles/asan` stays in tree, so a `sanitizer=` variable can bring it back. A stale `build/hawaii/` tree from `snapos-build` can be deleted.
```

A single-purpose PR drops the bullets and is three sentences long. Either way the rest of
the diff stays out of the body — the new module, the wiring, the incidental fix, the new
dependency, the test file. That is all diff-level detail, and the reviewer is reading the diff.
