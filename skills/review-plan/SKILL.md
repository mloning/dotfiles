---
name: review-plan
description: Critique an implementation or design plan before any code is written — gaps, hidden complexity, scope creep, missing edge cases, wrong approach. Use when reviewing, stress-testing, or critiquing a plan or design doc.
---

# Review Plan

Critique before any code is written. Verify independently — read the actual code and spec; don't trust the plan's own framing of what it covers.

1. **Does it solve the problem?** Map each requirement to a step; list anything with no corresponding task. Catch "right feature, wrong problem" misunderstandings.
2. **Scope & over-engineering.** Flag work that wasn't asked for, speculative "nice-to-haves," and unnecessary complexity — the simpler thing is usually right (YAGNI).
3. **Assumptions & ambiguity.** Surface unstated assumptions, fuzzy/overloaded terms, and anything readable two ways; flag claims that contradict the actual code.
4. **Sequencing & buildability.** Is each step independently buildable and verifiable, in the right order, with no missing prerequisites? Could an engineer follow it without getting stuck? Watch for naming/type inconsistencies across steps.
5. **Tests & failure modes.** Where are the test seams? What edge cases, error paths, and "what could go wrong" are missing? A step with no verification is a gap.
6. **Cross-check with the other agent.** Run this same critique in the other harness headless and reconcile — from Claude: `codex exec "<prompt>"`; from Codex: `claude -p "<prompt>"`. Ask it for steps 1–5 only (skip this cross-check, so it doesn't recurse). Keep findings both agents confirm (high confidence), investigate disagreements, and drop anything neither can substantiate against the plan or code.
7. **Report by severity + verdict.** Merge into one list grouped **Critical / Important / Minor** — only flag what would cause real problems, not wording or style; note where the two agents disagreed. If the approach is fundamentally wrong, say so: re-plan, don't patch. End with: ready to build? (yes / no / with changes).
