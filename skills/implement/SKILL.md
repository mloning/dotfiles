---
name: implement
description: Build an approved plan or a tracked issue end-to-end into a draft PR — implement each slice test-first, commit small and green, cross-review, then open the PR. Use when you have an agreed plan or spec (typically after `brainstorm`/`plan`), or an issue/ticket clear enough to build from, and want it built with minimal interruption — or when asked to "implement the plan", "implement this ticket", "fix this issue", "build it", or "code this up and open a PR".
disable-model-invocation: true
---

# Implement

Turn an approved plan — or a ticket clear enough to build from — into a review-ready draft PR. Build slice by slice, test-first, committing small and green. Ask only at a scope/architecture decision or when genuinely stuck. Use maximum effort.

## Usage

```
/implement [plan-path | issue-link]
```

Both optional: the path to the plan, or a **full link** to the issue/ticket (e.g. `https://jira.sc-corp.net/browse/<JIRA-KEY>`). If omitted, work from whatever plan or ticket was agreed in context.

> **Definition of done — non-negotiable.** The run is complete only when *both* hold: (a) cross-review has run and every Critical/Important finding is fixed (step 5), and (b) a draft PR is open with its URL reported (step 6). Green slices are **not** the finish line — implementing the code is the middle of the job, not the end. Do not report the work done, hand back, or fall silent while review or the PR is still outstanding. The only legitimate early stop is a genuine block or a scope/architecture decision (step 7): that *pauses for input*, it does not end the run.

> **How to run the sub-skills below.** Each phase reuses a sibling skill. They're explicit-only (`disable-model-invocation: true`), so you **cannot** call them with the Skill tool from here — it will be refused. Instead **Read** the sibling's `SKILL.md` and follow its numbered steps inline, as a phase of this cycle. The sub-skills live in the same skills directory as this file (`~/.claude/skills/<name>/SKILL.md` on Claude Code, `~/.agents/skills/<name>/SKILL.md` on Codex). If you don't know the path, locate it with `find ~/.claude/skills ~/.agents/skills -maxdepth 2 -path '*/<name>/SKILL.md'`.

1. **Establish the brief, and track the whole cycle.** The brief is whatever defines the change — a plan, a spec, or a ticket. Get it in front of you before touching code:
   - **From a plan or spec** (`plans/<feature-slug>.md`, or the direction agreed in context): re-read it so the slices, success criteria, and non-goals are fresh.
   - **From an issue/ticket:** fetch and read it in full — description, acceptance criteria, comments, linked issues and PRs (prefer an available MCP tool, e.g. `ghe_issue_view` / `jira_get_issue`; fall back to `gh issue view`). Ground it in the actual code, then restate in a few lines the goal, the acceptance criteria you'll verify against, the non-goals, and the slices you'll build. That short statement *is* your brief — no plan doc required. Keep the issue link; step 6 needs it.

   **When to plan first instead.** A ticket is enough on its own when the goal is unambiguous, self-contained, and you can name its slices and success criteria from the ticket plus the codebase. If it's vague, spans independent subsystems, or the approach needs a real design decision, stop and plan first (`brainstorm`/`plan`) — don't improvise a design under cover of "implementing". Same when there's neither plan nor ticket: say so and plan first.

   Then write a checklist of every phase in this cycle — each slice, then cross-review (step 5), then the draft PR (step 6) — and keep it updated as you work. The review and PR items stay on the list until actually done; a green slice never removes them.
2. **Never work on `main`.** If on main, branch first. Never commit directly to main.
3. **Implement slice by slice.** Work through the brief's slices in dependency order. For each:
   a. Follow `write-tests` first (test-first for new behavior) or alongside (for changes to existing code).
   b. Follow `code` for the implementation — minimal, correct, well-named, consistent with the surrounding code.
   c. Run the slice's success criteria plus the project's build/tests/linters. Never declare a slice done on red.
   d. Commit the slice — small, self-contained, passing. Never commit red.
4. **Keep the brief honest.** After each slice, track what's done and what remains. If reality diverges — a slice is wrong, a prerequisite was missed, scope shifted — update the brief to match rather than silently improvising around it: edit the plan if there is one, or correct your slice list and state the divergence. When it changes what the ticket promises, say so explicitly (a ticket comment, or in your report).
5. **Cross-agent review (required gate).** Once all slices are done, follow `review-local` (you plus the other agent in parallel), and verify the brief's acceptance criteria are actually met. Fix all Critical and Important findings before submitting. This step is not optional — reaching it is half of "done".
6. **Submit (required gate).** Follow `submit-pr` to open a draft PR — pass it the issue link if you're working from a ticket, so the PR closes it — then report the URL. The run is not finished until this PR exists. Only after the URL is reported may you consider the cycle complete.
7. **When to stop and ask.**
   - Blocked after two attempts on the same issue
   - A decision would materially change scope or architecture
   - Build/tests are red and the cause isn't clear after investigation
   - The brief is ambiguous in a way that affects correctness, or its acceptance criteria can't be verified as written

   Never guess on scope or architecture — ask and wait.
