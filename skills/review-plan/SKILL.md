---
name: review-plan
description: Critique an implementation or design plan before any code is written — gaps, hidden complexity, scope creep, missing edge cases, wrong approach. Use when reviewing, stress-testing, or critiquing a plan or design doc.
disable-model-invocation: true
---

# Review Plan

Critique before any code is written. Verify independently — read the actual code and spec; don't trust the plan's own framing of what it covers.

1. **Launch both critiques in parallel.** Run two independent critiques concurrently against the checklist in steps 2–6, then combine at the end (step 7) — don't run them sequentially:
   - **You** critique the plan yourself against steps 2–6.
   - **The other agent** runs the same checklist as a headless cross-critic in the background. Run it the reliable way — **hand over the plan and disable exploration**, don't plead in prose (a critic loose in the repo ignores "use ≤15 tool calls / don't read skill files," spirals into exploration, and gets hard-killed before emitting anything). Inline the **full plan text in the prompt**, run it **with exploration structurally disabled** and **stdin closed** (`codex exec` hangs reading an open stdin), and make it **write schema-validated findings to a file**. Run the block below — `1a` if you are Claude (spawn Codex), `1b` if you are Codex (spawn Claude):

   ```bash
   # 0. Per-run temp dir, keyed off the branch — reconstructible in later steps without shell state,
   #    and won't clobber a concurrent review on another branch. Recompute this same line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"

   # 1. Point at the plan/spec file under review.
   PLAN_FILE="<path to the plan/design doc>"

   # 2. Write the findings schema once (single line — safe regardless of indentation).
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["critical","important","minor"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json

   # 3. Inline the critique criteria (the substance of steps 2–6) — never reference this skill or step numbers.
   CRITERIA="You are a sharp plan critic. The COMPLETE plan to critique is below the ===PLAN=== marker. Critique ONLY that text — do NOT run shell commands, read files, or explore the repo, CLIs, docs, or skill files; everything you need is in the plan. Check: does it actually solve the stated problem (map each requirement to a step; flag 'right feature, wrong problem'); scope creep / over-engineering / speculative nice-to-haves (YAGNI); unstated assumptions, fuzzy or overloaded terms, anything readable two ways; sequencing and buildability (each step independently buildable and verifiable, right order, no missing prerequisites, no naming/type inconsistencies across steps); and missing tests, edge cases, error paths, and failure modes (a step with no verification is a gap). Only flag what would cause real problems — not wording or style. For 'location', cite the plan section/step. If the approach is fundamentally wrong, say so in the verdict (re-plan, don't patch)."

   # 1a. FROM CLAUDE → spawn the Codex critic (read-only sandbox, no user config/rules, stdin closed, schema enforced to a file):
   (perl -e 'alarm shift; exec @ARGV' 600 \
     codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
       --output-schema $RD/schema.json -o $RD/other.json \
       "$CRITERIA

   ===PLAN===
   $(cat "$PLAN_FILE")" < /dev/null) > $RD/other.log 2>&1 &

   # 1b. FROM CODEX → spawn the Claude critic (all tools disabled, stdin closed, JSON envelope):
   (perl -e 'alarm shift; exec @ARGV' 600 \
     claude -p "$CRITERIA Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"critical|important|minor\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   ===PLAN===
   $(cat "$PLAN_FILE")" \
       --tools "" --output-format json --no-session-persistence < /dev/null) > $RD/other.json 2>&1 &
   ```

   Inlining via `"$(cat …)"` is safe — command-substitution output is not re-evaluated. The critic finishes well under the timeout; the `perl alarm` is only a backstop. Keep critiquing while it runs, then `wait`.
2. **Does it solve the problem?** Map each requirement to a step; list anything with no corresponding task. Catch "right feature, wrong problem" misunderstandings.
3. **Scope & over-engineering.** Flag work that wasn't asked for, speculative "nice-to-haves," and unnecessary complexity — the simpler thing is usually right (YAGNI).
4. **Assumptions & ambiguity.** Surface unstated assumptions, fuzzy/overloaded terms, and anything readable two ways; flag claims that contradict the actual code.
5. **Sequencing & buildability.** Is each step independently buildable and verifiable, in the right order, with no missing prerequisites? Could an engineer follow it without getting stuck? Watch for naming/type inconsistencies across steps.
6. **Tests & failure modes.** Where are the test seams? What edge cases, error paths, and "what could go wrong" are missing? A step with no verification is a gap.
7. **Combine results.** Once your own critique is done, `wait` for the background critic and read `$RD/other.json` (recompute `RD` with the same line from the block above if your shell no longer has it set):
   - **From Claude** (Codex critic): the file *is* the findings object (`{findings, verdict}`) — read it directly.
   - **From Codex** (Claude critic): the file is an envelope — extract the payload with `jq -r '.result'`, then parse that as the findings JSON.

   If the file is missing, empty, or not valid JSON (e.g. the critic was hard-killed by the timeout), state that explicitly ("second critic did not produce usable output — single-critic findings below") and proceed with your own critique alone. Never produce a vacuous "no disagreements" summary when the second critic failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate.
8. **Report by severity + verdict.** Merge into one **numbered** list grouped **Critical / Important / Minor** (number findings continuously `1..N` so they're easy to refer back to) — only flag what would cause real problems, not wording or style; note where the two agents disagreed. If the approach is fundamentally wrong, say so: re-plan, don't patch. End with: ready to build? (yes / no / with changes).
