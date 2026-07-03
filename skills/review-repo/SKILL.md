---
name: review-repo
description: Review an entire repository for architecture quality — coupling, interfaces, naming, tech debt, test coverage, stale docs. Use when doing an architecture review, identifying refactor opportunities, or assessing overall code health.
disable-model-invocation: true
---

# Review Repo

Read widely before judging. Flag only issues that impede maintainability, not style. Verify findings against the actual code — don't trust summaries.

1. **Orient first.** Read CONTEXT.md, decision records, README, and CI config. Understand the stated architecture and domain language before forming opinions.
2. **Map the codebase.** Walk the directory tree; identify modules, their responsibilities, and key dependencies. Note the language/framework idioms in use.
3. **Launch both reviews in parallel.** Run two independent reviews against steps 4–8 and combine at the end (step 9):
   - **You** review against steps 4–8.
   - **The other agent** runs the same checklist as a headless cross-reviewer in the background. Unlike the diff-based review skills, an architecture review must *roam* the code, so the reviewer keeps **read-only tool access** — but bound it the reliable way: **hand over a focused scope** (the specific modules/dirs you identified in step 2, not "the whole repo"), run it **read-only with config/rules/skills disabled and stdin closed** (so it can't auto-load skill files, mutate anything, or hang reading stdin), and make it **write schema-validated findings to a file**. Run the block below — `3a` if you are Claude (spawn Codex), `3b` if you are Codex (spawn Claude):

   ```bash
   # 0. Per-run temp dir, keyed off the branch — reconstructible in later steps without shell state,
   #    and won't clobber a concurrent review on another branch. Recompute this same line wherever you need $RD.
   RD="${TMPDIR:-/tmp}/review-$(git rev-parse --abbrev-ref HEAD | tr -c 'A-Za-z0-9._-' '-')"; mkdir -p "$RD"

   # 1. Hand over a FOCUSED scope — the modules/dirs from step 2, not the whole tree. This is what keeps it bounded.
   FOCUS="<comma- or space-separated dirs/modules to review, e.g. src/api src/db>"

   # 2. Write the findings schema once (single line — safe regardless of indentation; architecture review uses high/medium/low).
   printf '%s' '{"type":"object","additionalProperties":false,"required":["findings","verdict"],"properties":{"findings":{"type":"array","items":{"type":"object","additionalProperties":false,"required":["severity","location","issue","why","fix"],"properties":{"severity":{"type":"string","enum":["high","medium","low"]},"location":{"type":"string"},"issue":{"type":"string"},"why":{"type":"string"},"fix":{"type":"string"}}}},"verdict":{"type":"string"}}}' > $RD/schema.json

   # 3. Inline the review criteria (the substance of steps 4–8) — never reference this skill or step numbers.
   CRITERIA="You are an architecture reviewer. Review ONLY the modules/dirs named in SCOPE below, reading just the code under them. Do NOT read skill files (SKILL.md or references/) or wander outside SCOPE. Assess: coupling & interfaces (god objects, circular deps, modules that always change together, non-minimal/unstable interfaces); naming & consistency (domain terms used differently across modules, impl details leaking into public names); tech debt & complexity (deep nesting, long functions, dead/commented-out code, stale TODOs, overengineered abstractions with no payoff); test coverage & quality (modules lacking tests, tests asserting on internals instead of behaviour, flaky/skipped tests); and stale docs/comments (READMEs and comments that no longer match the code). Flag only issues that impede maintainability, not style. Cite file(s) in 'location'. Use severity high/medium/low. End with an overall health read in the verdict."

   # 3a. FROM CLAUDE → spawn the Codex reviewer (read-only sandbox, no user config/rules, stdin closed, schema enforced to a file):
   (perl -e 'alarm shift; exec @ARGV' 720 \
     codex exec --ignore-user-config --ignore-rules --ephemeral -s read-only \
       --output-schema $RD/schema.json -o $RD/other.json \
       "$CRITERIA

   SCOPE: $FOCUS" < /dev/null) > $RD/other.log 2>&1 &

   # 3b. FROM CODEX → spawn the Claude reviewer (read-only tool whitelist, stdin closed, JSON envelope):
   (perl -e 'alarm shift; exec @ARGV' 720 \
     claude -p "$CRITERIA Output ONLY a JSON object (no prose, no markdown fence) of shape {\"findings\":[{\"severity\":\"high|medium|low\",\"location\":\"\",\"issue\":\"\",\"why\":\"\",\"fix\":\"\"}],\"verdict\":\"\"}.

   SCOPE: $FOCUS" \
       --allowedTools "Read" "Grep" "Glob" --disallowedTools "Bash" "Edit" "Write" "Task" "WebFetch" "WebSearch" \
       --output-format json --no-session-persistence < /dev/null) > $RD/other.json 2>&1 &
   ```

   The reviewer roams, so it can run longer than the diff-based skills — the 720s `perl alarm` is a backstop. Because roaming is open-ended, the kill can still lose output; the focused SCOPE is what keeps it finishing in time. Keep reviewing while it runs, then `wait`.
4. **Coupling & interfaces.** Where are modules tightly coupled? Are interfaces minimal and stable? Flag god objects, circular dependencies, and modules that always change together.
5. **Naming & consistency.** Inconsistent naming across modules; domain terms used differently in different places; implementation details leaking into public names.
6. **Tech debt & complexity.** Deep nesting, long functions, dead code, commented-out code, TODOs older than a sprint, overengineered abstractions with no payoff.
7. **Test coverage & quality.** Which modules lack tests? Tests that verify implementation details (mocks on internals) instead of behavior? Flaky or skipped tests?
8. **Stale docs & comments.** READMEs that no longer match the code, comments describing old behavior, outdated decision records.
9. **Combine results.** Once your review is done, `wait` for the background reviewer and read `$RD/other.json` (recompute `RD` with the same line from the block above if your shell no longer has it set):
   - **From Claude** (Codex reviewer): the file *is* the findings object (`{findings, verdict}`) — read it directly.
   - **From Codex** (Claude reviewer): the file is an envelope — extract the payload with `jq -r '.result'`, then parse that as the findings JSON.

   If the file is missing, empty, or not valid JSON (e.g. the reviewer was hard-killed by the timeout), state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own review alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the code.
10. **Report by priority.** Group findings into a **numbered** list by priority **High / Medium / Low** (number findings continuously `1..N` so they're easy to refer back to) — each with file(s), what's wrong, why it matters, and a concrete improvement. End with a top-3 recommended starting points. If the codebase is healthy, say so clearly.
