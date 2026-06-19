---
name: review-plan
description: Critique an implementation or design plan before any code is written — gaps, hidden complexity, scope creep, missing edge cases, wrong approach. Use when reviewing, stress-testing, or critiquing a plan or design doc.
disable-model-invocation: true
---

# Review Plan

Critique before any code is written. Verify independently — read the actual code and spec; don't trust the plan's own framing of what it covers.

1. **Launch both critiques in parallel.** Run two independent critiques concurrently against the checklist in steps 2–6, then combine at the end (step 7) — don't run them sequentially:
   - **You** critique the plan yourself against steps 2–6.
   - **The other agent** runs the same checklist headless in the background (steps 2–6 only — tell it to skip this parallel step so it doesn't recurse) and lists its findings. Background it to a log and **stream** so you can see it's alive — from Claude: `(timeout 300 codex exec "<prompt>") > /tmp/review-plan-other.log 2>&1 &`; from Codex: `(timeout 300 claude -p "<prompt>" --output-format stream-json --include-partial-messages --verbose --no-session-persistence) > /tmp/review-plan-other.log 2>&1 &` (plain `claude -p` buffers all output until the final answer, so it looks frozen for minutes while it's actually reading files and running tools). Add these two constraints verbatim to its prompt: (1) **"Use at most 15 tool calls total."** (2) **"The last thing you output must be a fenced JSON block opened with the line `FINDINGS_JSON` containing your findings array and a verdict string."** Keep critiquing while it runs. **Silence ≠ stalled** — judge it done by the process exiting (tail the log for liveness), not by output gaps. The `timeout 300` hard-kills it after 5 minutes.
2. **Does it solve the problem?** Map each requirement to a step; list anything with no corresponding task. Catch "right feature, wrong problem" misunderstandings.
3. **Scope & over-engineering.** Flag work that wasn't asked for, speculative "nice-to-haves," and unnecessary complexity — the simpler thing is usually right (YAGNI).
4. **Assumptions & ambiguity.** Surface unstated assumptions, fuzzy/overloaded terms, and anything readable two ways; flag claims that contradict the actual code.
5. **Sequencing & buildability.** Is each step independently buildable and verifiable, in the right order, with no missing prerequisites? Could an engineer follow it without getting stuck? Watch for naming/type inconsistencies across steps.
6. **Tests & failure modes.** Where are the test seams? What edge cases, error paths, and "what could go wrong" are missing? A step with no verification is a gap.
7. **Combine results.** Once your own critique is done, wait for the background process (`wait`) then read `/tmp/review-plan-other.log` and look for the `FINDINGS_JSON` block. If the log is empty, has no `FINDINGS_JSON` block, or the process was killed by the 5-minute timeout, state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own critique alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate.
8. **Report by severity + verdict.** Merge into one list grouped **Critical / Important / Minor** — only flag what would cause real problems, not wording or style; note where the two agents disagreed. If the approach is fundamentally wrong, say so: re-plan, don't patch. End with: ready to build? (yes / no / with changes).
