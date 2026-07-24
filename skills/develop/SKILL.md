---
name: develop
description: Run a full autonomous development cycle — brainstorm + spec, plan, implement, review, submit PR. Use when asked to build something end-to-end with minimal interruption, or for a fully autonomous implementation from idea to PR.
disable-model-invocation: true
---

# Develop

Iterate: brainstorm → spec → plan → code → review → PR. Ask only when genuinely stuck or at a scope/architecture decision point. Use maximum effort.

> **Definition of done — non-negotiable.** The run is complete only when `implement` (step 4) has carried the plan all the way through: cross-review done, every Critical/Important finding fixed, and a draft PR open with its URL reported. Writing the code is the middle of the job, not the end — do not report done, hand back, or fall silent after coding while review or the PR is still outstanding. Track every phase (brainstorm → spec → plan → critique → build → review → draft PR) as a checklist and keep it updated; the review and PR items stay on it until actually done. The only legitimate early stop is a genuine block or a scope/architecture decision — that pauses for input, it does not end the run.

> **How to run the sub-skills below.** Each phase reuses a sibling skill. They're explicit-only (`disable-model-invocation: true`), so you **cannot** call them with the Skill tool from here — it will be refused. Instead **Read** the sibling's `SKILL.md` and follow its numbered steps inline, as a phase of this cycle. The sub-skills live in the same skills directory as this file (`~/.claude/skills/<name>/SKILL.md` on Claude Code, `~/.agents/skills/<name>/SKILL.md` on Codex). If you don't know the path, locate it with `find ~/.claude/skills ~/.agents/skills -maxdepth 2 -path '*/<name>/SKILL.md'`.

1. **Brainstorm & specify** — follow `brainstorm`. Explore approaches, weigh trade-offs, converge on a direction, and capture it as a testable spec doc (problem, requirements, acceptance criteria, non-goals). Don't skip the exploration; the obvious approach isn't always right. Get the spec approved before planning.
2. **Plan** — follow `plan`. Produce a PR-sliced implementation plan with explicit success criteria per slice, derived from the spec. Get approval before writing any code.
3. **Critique the plan** — follow `review-plan` to stress-test the plan. Fix all Critical findings before proceeding; note Important ones so they don't become surprises mid-implementation.
4. **Build it** — follow `implement`. It carries the plan through to a draft PR: implement each slice test-first (`write-tests` + `code`), commit small and green, cross-review (`review-local`), then submit (`submit-pr`). It also owns the when-to-stop-and-ask and never-work-on-`main` guardrails, so honor those throughout. Do not end the cycle until that draft PR exists and you have reported its URL — `implement`'s own definition-of-done applies here too.
