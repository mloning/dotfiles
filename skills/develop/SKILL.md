---
name: develop
description: Run a full autonomous development cycle — brainstorm + spec, plan, implement, review, submit PR. Use when asked to build something end-to-end with minimal interruption, or for a fully autonomous implementation from idea to PR.
disable-model-invocation: true
---

# Develop

Iterate: brainstorm → spec → plan → code → review → PR. Ask only when genuinely stuck or at a scope/architecture decision point. Use maximum effort.

> **How to run the sub-skills below.** Each phase reuses a sibling skill. They're explicit-only (`disable-model-invocation: true`), so you **cannot** call them with the Skill tool from here — it will be refused. Instead **Read** the sibling's `SKILL.md` and follow its numbered steps inline, as a phase of this cycle. The sub-skills live in the same skills directory as this file (`~/.claude/skills/<name>/SKILL.md` on Claude Code, `~/.agents/skills/<name>/SKILL.md` on Codex). If you don't know the path, locate it with `find ~/.claude/skills ~/.agents/skills -maxdepth 2 -path '*/<name>/SKILL.md'`.

1. **Brainstorm & specify** — follow `brainstorm`. Explore approaches, weigh trade-offs, converge on a direction, and capture it as a testable spec doc (problem, requirements, acceptance criteria, non-goals). Don't skip the exploration; the obvious approach isn't always right. Get the spec approved before planning.
2. **Plan** — follow `plan`. Produce a PR-sliced implementation plan with explicit success criteria per slice, derived from the spec. Get approval before writing any code.
3. **Critique the plan** — follow `review-plan` to stress-test the plan. Fix all Critical findings before proceeding; note Important ones so they don't become surprises mid-implementation.
4. **Implement slice by slice.** Work through each slice from the plan:
   a. Follow `write-tests` first (test-first for new behavior) or alongside (for modifications to existing code).
   b. Follow `code` for the implementation — minimal, correct, well-named.
   c. Commit each slice as you go — small, passing commits. Never commit red.
5. **Cross-agent review** — follow `review-local` (you plus the other agent in parallel) before submitting. Fix all Critical and Important findings.
6. **Submit** — follow `submit-pr` to open a draft PR.
7. **When to stop and ask.**
   - Blocked after two attempts on the same issue
   - A decision would materially change scope or architecture
   - Build/tests are red and the cause isn't clear after investigation
   - A plan step is ambiguous in a way that affects correctness
   Never guess on scope or architecture — ask and wait.
8. **Never work on `main`.** If on main, branch first. Never commit directly to main.
