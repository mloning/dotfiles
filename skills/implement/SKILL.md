---
name: implement
description: Build an approved plan end-to-end into a draft PR — implement each slice test-first, commit small and green, cross-review, then open the PR. Use when you have an agreed or approved plan (typically after `brainstorm`/`plan`) and want it built with minimal interruption, or when asked to "implement the plan", "build it", or "code this up and open a PR".
disable-model-invocation: true
---

# Implement

Turn an approved plan into a review-ready draft PR. Build slice by slice, test-first, committing small and green. Ask only at a scope/architecture decision or when genuinely stuck. Use maximum effort.

> **Definition of done — non-negotiable.** The run is complete only when *both* hold: (a) cross-review has run and every Critical/Important finding is fixed (step 5), and (b) a draft PR is open with its URL reported (step 6). Green slices are **not** the finish line — implementing the code is the middle of the job, not the end. Do not report the work done, hand back, or fall silent while review or the PR is still outstanding. The only legitimate early stop is a genuine block or a scope/architecture decision (step 7): that *pauses for input*, it does not end the run.

> **How to run the sub-skills below.** Each phase reuses a sibling skill. They're explicit-only (`disable-model-invocation: true`), so you **cannot** call them with the Skill tool from here — it will be refused. Instead **Read** the sibling's `SKILL.md` and follow its numbered steps inline, as a phase of this cycle. The sub-skills live in the same skills directory as this file (`~/.claude/skills/<name>/SKILL.md` on Claude Code, `~/.agents/skills/<name>/SKILL.md` on Codex). If you don't know the path, locate it with `find ~/.claude/skills ~/.agents/skills -maxdepth 2 -path '*/<name>/SKILL.md'`.

1. **Start from the approved plan, and track the whole cycle.** Work from the plan at `plans/<feature-slug>.md` (or the direction agreed in context). Re-read it so the slices, success criteria, and non-goals are fresh. If there's no approved plan yet, stop and say so — brainstorm and plan first; don't improvise one here. Before touching code, write a checklist of every phase in this cycle — each slice, then cross-review (step 5), then the draft PR (step 6) — and keep it updated as you work. The review and PR items stay on the list until actually done; a green slice never removes them.
2. **Never work on `main`.** If on main, branch first. Never commit directly to main.
3. **Implement slice by slice.** Work through the plan's slices in dependency order. For each:
   a. Follow `write-tests` first (test-first for new behavior) or alongside (for changes to existing code).
   b. Follow `code` for the implementation — minimal, correct, well-named, consistent with the surrounding code.
   c. Run the slice's success criteria plus the project's build/tests/linters. Never declare a slice done on red.
   d. Commit the slice — small, self-contained, passing. Never commit red.
4. **Keep the plan honest.** After each slice, track what's done and what remains. If reality diverges — a slice is wrong, a prerequisite was missed, scope shifted — update the plan to match rather than silently improvising around it.
5. **Cross-agent review (required gate).** Once all slices are done, follow `review-local` (you plus the other agent in parallel). Fix all Critical and Important findings before submitting. This step is not optional — reaching it is half of "done".
6. **Submit (required gate).** Follow `submit-pr` to open a draft PR, then report its URL. The run is not finished until this PR exists. Only after the URL is reported may you consider the cycle complete.
7. **When to stop and ask.**
   - Blocked after two attempts on the same issue
   - A decision would materially change scope or architecture
   - Build/tests are red and the cause isn't clear after investigation
   - A plan step is ambiguous in a way that affects correctness

   Never guess on scope or architecture — ask and wait.
