---
name: plan
description: Produce an implementation plan for a coding task — ask detailed clarifying questions first, then write a PR-sliced plan. Use when planning a feature or non-trivial change, scoping work, or when asked to plan before coding.
disable-model-invocation: true
---

# Plan

Resolve ambiguity before planning. If you could describe the diff in one sentence, skip the plan and just do it.

1. **Explore first.** Read the relevant code and docs (CONTEXT.md, decision records, conventions) to ground the plan. Answer questions from the codebase instead of asking whenever you can.
2. **Interview me.** Ask detailed clarifying questions about purpose, constraints, and success criteria — one at a time, multiple-choice where possible, each with your recommended answer. Pin down anything that could be read two ways.
3. **Weigh approaches.** Propose 2–3 options with trade-offs and a recommendation before committing. Spike a throwaway prototype if the right approach is genuinely unknown.
4. **Define scope.** State the goal, success criteria, and explicit non-goals. If the work spans multiple independent subsystems, split into separate plans — each shippable on its own.
5. **Slice it.** Break into PR-sized vertical slices (each end-to-end through all layers, independently demoable/verifiable), with dependencies/blockers and test seams named. Prefer many thin slices over few thick ones; YAGNI — cut anything not needed. No placeholders ("TBD", "handle edge cases", "add tests" without specifics are plan failures).
6. **Write & self-review.** Save the plan to `plans/<feature-slug>.md` (descriptive kebab-case). Then check it yourself: every requirement maps to a step, no placeholders, consistent naming. Get approval before writing code.
