---
name: write-spec
description: Specify requirements before planning — the problem, exact testable requirements, acceptance criteria, scope and non-goals. Use when defining what to build, capturing requirements, or writing a spec/PRD before design.
disable-model-invocation: true
---

# Spec

Specify WHAT to build and WHY — never HOW. The spec is the input to planning; keep it implementation-free.

1. **Quiz me first.** Before specifying, ask focused scoping questions to narrow the field — the problem, who it's for, success criteria, constraints, and what's out of scope. Ask one at a time or as a short batch, each with your recommended default. Don't start writing until the answers are clear.
2. **Survey the field.** Once scoped, research prior art and existing solutions (web search — or, for a deeper dive, follow the `research` skill by reading its `SKILL.md`, since it's explicit-only and can't be called with the Skill tool) to ground the requirements and surface constraints you'd otherwise miss.
3. **State the problem.** The problem and desired outcome from the user's perspective, then prioritized, independently-testable user stories ("As an <actor>, I want <feature>, so that <benefit>") — any single P1 story should be a viable MVP.
4. **Make every requirement testable.** Exact, unambiguous, MUST-style requirements with stable IDs. Think like a tester: a requirement you can't verify is a defect.
5. **Define acceptance criteria.** Measurable, technology-agnostic done conditions (Given/When/Then, "checkout in under 3 minutes" — not "API < 200ms").
6. **Bound scope.** An explicit Out-of-Scope / non-goals section; YAGNI — cut anything not needed. If it spans multiple independent subsystems, split into separate specs.
7. **Flag ambiguities, don't over-ask.** Make informed-default guesses and record them under Assumptions; reserve explicit `[NEEDS CLARIFICATION]` markers for the few decisions that truly affect scope, security, or UX.
8. **No file paths or code — specs rot.** Keep constraints (perf, security, compatibility, dependencies) at the architectural level ("OAuth 2.0 library", not a pinned version). Self-review before handing off: no placeholders, no contradictions, nothing readable two ways.
