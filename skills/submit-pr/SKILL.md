---
name: submit-pr
description: Use when opening a pull request (PR) for the current branch. Open a PR with a concise, reviewer-ready description pitched at the level of intent — what the PR accomplishes and why. Optionally links a Jira/GitHub issue.
---

# Submit PR

Open a PR a reviewer can act on without asking questions. Describe what actually changed, not what you intended.

**Write at the altitude of intent, not a changelog.** The description exists to orient a reviewer — what the PR accomplishes and why — so they can then read the diff for the line-level detail. It is _not_ a transcript of the diff. If a bullet just restates a file, function, or edit, you're too low: merge it into the intent it serves.

## Usage

```
/submit-pr [issue-link]
```

`[issue-link]` is optional: the Jira/GitHub issue to link via `Closes`. It **MUST** be a **full link** (e.g. `https://jira.sc-corp.net/browse/<JIRA-KEY>`), not a bare key — a bare key won't trigger the GHE/Jira integration. If omitted, leave the issue reference empty and **do not** prompt, interrupt, or ask for one.

> **Tooling — prefer MCP.** For every GitHub operation (create, edit, mark ready, comment), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_create_pr`, `ghe_pr_edit`, `ghe_pr_ready` if present. Fall back to `gh` only when no MCP tool is available.

1. **Pre-flight.** Never open a PR from `main` — branch first. Ensure all changes are committed.
2. **Scope the change set.** `git diff main...HEAD` (three-dot, vs merge-base). Write the description from the diff — what the PR genuinely does — not from memory of the task.
3. **Use the repo's template.** If `.github/` has a `PULL_REQUEST_TEMPLATE.md` (or `pull_request_template.md`), you **MUST** follow its sections; only when none exists, use the default below.
4. **Group by intent — aim for ~2–5 bullets, never one per file/function/commit.** Each bullet is one conceptual change the reviewer must grasp, a few words each — _what_ shifted and _why_. Fold every edit that serves the same purpose into a single bullet (new module + its wiring + its tests = one bullet, not four). The line-by-line detail is in the diff; don't mirror it here. If you catch yourself writing a bullet per file, per function, or per commit — or narrating _how_ the code works — you're too low; zoom out. See the altitude example below.
5. **Don't summarize Markdown/docs changes.** For `.md` files (READMEs, docs), the rendered diff is directly readable — don't restate their contents. A single bullet naming the file is enough (e.g. "Update README — document `link-skills`"). Only when the change is large does it warrant a _very short_ summary.
6. **Link the issue — only if one was passed.** If the skill was given an issue argument, include it verbatim as a `Closes <link>` line; it **MUST** be a **full link** (not a bare key) for the GHE/Jira integration to pick it up. If no argument was given, omit the issue line entirely — do **not** infer one from the branch/commits, and do **not** ask. Add any related PRs or docs.
7. **Create the PR as a draft.** Default to a **draft** PR unless told otherwise (MCP `ghe_create_pr` with `draft: true`; else `gh pr create --draft`). Target the correct base (`main` unless told otherwise). Report the PR URL.

## Default description template

```markdown
## Changes

- <what> — <why> # a few words; e.g. "Cache token lookups — cut auth latency"
- <what> — <why>

## Notes

<optional — only what the reviewer CAN'T get from the diff: a non-obvious rationale,
a risk, a decision made, a follow-up. Not a mechanism walkthrough, not a restatement
of the changes. A line or two, not an essay.>

Closes <full issue link> # only if an issue arg was passed; full link MUST be used for GHE/Jira integration. Omit this line entirely otherwise.
```

## Altitude — an example

The same PR (add frequency-domain metrics to an aligner benchmark), written two ways.

**Too low — a changelog (don't do this):**

```markdown
- Add nma.utils.spectral — pure DSP helpers (periodogram, band power, gain, SAR)
- Add SpectralGainError + SignalToArtifactRatio in nma.metrics on a Spectrum dataclass
- Wire both metrics into benchmark_experiments (spectral_gain_error, sar_db)
- Harden benchmark.py — deepcopy error_metrics per run; assert update_align returns a list
- Promote scipy from the [plots] extra to a core dependency
- Drop keyword-only markers; update AGENTS.md; add plan; add test_spectral.py; extend tests
```

**Right altitude — intent (do this):**

```markdown
## Changes

- Add spectral-domain benchmark metrics (gain error + signal-to-artifact ratio) so the benchmark catches frequency-domain distortion that RMSE misses
- Promote scipy to a core dependency — metrics now run outside the plotting path

## Notes

- SAR = signal-band / spurious-band power (dB); grades energy smeared into interpolation sidebands, ranking nearest < linear < cubic.
```

Six mechanical bullets collapse to two intent bullets: the new module, its wiring, and
its tests are all "add spectral metrics." The deepcopy fix, dropped markers, AGENTS.md,
plan, and test files are diff-level detail the reviewer reads in the diff, not the PR body.
