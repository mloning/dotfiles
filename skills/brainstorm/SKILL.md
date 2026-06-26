---
name: brainstorm
description: Explore approaches and capture the decision as a testable spec doc — quiz for scope, web-search prior art, weigh 2–3 approaches, converge, then write the spec to the repo and cross-agent review it. Use when ideating, evaluating options, or capturing requirements before planning.
disable-model-invocation: true
---

# Brainstorm

Explore before committing, then capture the decision as a spec. The goal is the best approach, not the first — and a spec that says WHAT to build and WHY, never HOW. No code: this skill ends at an approved spec doc that feeds into `plan`.

1. **Explore, then quiz me — one question at a time.** Read the relevant code, docs, and recent commits to ground the work and answer what you can without asking. Then ask focused scoping questions — what problem are we solving, who's it for, what does success look like, what constraints exist, what's ruled out — one at a time, each with your recommended default, restating the question precisely before moving on. If the request spans multiple independent subsystems, flag it and help decompose into separate specs before going deeper.
2. **Search for prior art.** Web-search for existing solutions, libraries, patterns, and documented trade-offs; prefer primary sources (official docs, papers, changelogs). For a deeper dive, follow the `research` skill (read its `SKILL.md` — it's explicit-only and can't be called with the Skill tool). Summarize what exists before generating ideas — don't reinvent what's solved.
3. **Generate 3 distinct approaches.** Make them genuinely different — not variations of one idea. For each: a one-line description, how it works, and the key trade-off.
4. **Weigh trade-offs explicitly.** For each approach state complexity to build and maintain, performance characteristics, fit with the existing codebase, and what it forecloses in future.
5. **Converge on a direction.** Narrow the field one decision question at a time (each with your recommended answer); present the design in sections scaled to their complexity and confirm each before moving on. Recommend one approach with a one-paragraph rationale, stating explicitly what you're trading away and why that's acceptable.
6. **Write the spec doc.** Save the agreed design to `specs/<feature-slug>.md` (descriptive kebab-case; user preferences for spec location override this). It must specify WHAT and WHY, never HOW:
   - **Problem & outcome** from the user's perspective, then prioritized, independently-testable user stories ("As an <actor>, I want <feature>, so that <benefit>") — any single P1 story is a viable MVP.
   - **Testable requirements** — exact, unambiguous, MUST-style, with stable IDs. A requirement you can't verify is a defect.
   - **Acceptance criteria** — measurable, technology-agnostic done conditions (Given/When/Then; "checkout in under 3 minutes", not "API < 200ms").
   - **Scope & non-goals** — an explicit out-of-scope section; YAGNI, cut anything not needed.
   - **Assumptions** — record informed-default guesses; reserve `[NEEDS CLARIFICATION]` markers for the few decisions that truly affect scope, security, or UX.
   - No file paths or code (specs rot); keep constraints architectural ("OAuth 2.0 library", not a pinned version).
7. **Cross-agent self-review of the spec.** Review the written spec yourself AND have the other agent review it independently in parallel, then combine — don't run them sequentially. Checklist for both: (a) no placeholders ("TBD"/"TODO"/incomplete sections); (b) internally consistent — no section contradicts another, architecture matches the requirements; (c) every requirement testable and readable only one way; (d) scope focused enough for a single plan, else decompose; (e) no HOW — no code, file paths, or pinned implementation choices.
   - **You** check the spec against (a)–(e).
   - **The other agent** reviews the spec independently as a headless cross-reviewer. Run it the reliable way — **hand over the spec and disable exploration**, don't plead in prose (a reviewer loose in the repo ignores "use ≤15 tool calls / don't read skill files," spirals, and gets hard-killed before emitting anything). Inline the **full spec text in the prompt**, run it **with exploration structurally disabled**, and make it **write schema-validated findings to a file**. Run the block below — `7a` if you are Claude (spawn Codex), `7b` if you are Codex (spawn Claude):

   ```bash
   SPEC_FILE="specs/<feature-slug>.md"   # the spec you just wrote
   # Per-run temp dir, keyed off the branch — reconstructible later without shell state; recompute this line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["critical","important","minor"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json
   CRITERIA="You are a spec reviewer. The COMPLETE spec is below the ===SPEC=== marker. Review ONLY that text — do NOT run shell commands, read files, or explore the repo/CLIs/docs/skill files; everything you need is in the spec. Flag: (a) placeholders (TBD/TODO/incomplete sections); (b) internal inconsistency — a section contradicting another, or architecture not matching the requirements; (c) any requirement that is not testable or is readable more than one way; (d) scope too broad for a single plan (should be decomposed); (e) any HOW — code, file paths, or pinned implementation choices that don't belong in a spec. Cite the spec section in 'location'."

   # 7a. FROM CLAUDE → spawn the Codex reviewer (stdin closed so codex can't hang reading it):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
       --output-schema $RD/schema.json -o $RD/other.json \
       "$CRITERIA

   ===SPEC===
   $(cat "$SPEC_FILE")" < /dev/null) > $RD/other.log 2>&1 &

   # 7b. FROM CODEX → spawn the Claude reviewer (stdin closed):
   (perl -e 'alarm shift; exec @ARGV' 180 \
     claude -p "$CRITERIA Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"critical|important|minor\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   ===SPEC===
   $(cat "$SPEC_FILE")" \
       --tools "" --output-format json --no-session-persistence < /dev/null) > $RD/other.json 2>&1 &
   ```
   - **Combine.** Once your own review is done, `wait` for the background reviewer and read `$RD/other.json` (recompute `RD` with the same line from the block above if your shell no longer has it set) — **from Claude** it *is* the findings object (`{findings, verdict}`); **from Codex** extract the payload with `jq -r '.result'`, then parse that JSON. If the file is missing, empty, or not valid JSON (e.g. hard-killed by the timeout), say so explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with yours alone. Otherwise keep findings both confirm, investigate disagreements, drop anything neither can substantiate. Fix all issues inline in the spec.
8. **User review gate, then hand off.** Tell the user: "Spec written to `<path>` — please review it and let me know if you want changes before we plan." If they request changes, make them and re-run step 7. Once approved, the spec feeds into `plan` — do not write code or invoke any other skill.
