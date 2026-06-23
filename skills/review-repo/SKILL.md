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
   - **The other agent** runs the same checklist headless in the background and lists findings with `file:line`. **Build it a self-contained prompt:** inline the actual review criteria (the substance of steps 4–8) directly — never say "follow this skill" or cite step numbers, because the headless agent has no skill loaded and will burn its entire budget hunting through skill files to reconstruct them (this is the usual cause of an empty `FINDINGS_JSON`). Also tell it not to spawn its own second reviewer (no recursion). `perl -e 'alarm shift; exec @ARGV' 300` is a portable 5-minute hard-kill (macOS ships no `timeout`/`gtimeout`). From Claude: `(perl -e 'alarm shift; exec @ARGV' 300 codex exec "<prompt>") > /tmp/review-repo-other.log 2>&1 &`; from Codex: `(perl -e 'alarm shift; exec @ARGV' 300 claude -p "<prompt>" --output-format stream-json --include-partial-messages --verbose --no-session-persistence) > /tmp/review-repo-other.log 2>&1 &`. Add these three constraints verbatim to its prompt: (1) **"Use at most 15 tool calls total — spend them on the code, never on reading skill or doc files."** (2) **"Do not open, read, or follow any skill files (`SKILL.md` or `references/`); everything you need is already in this prompt."** (3) **"The last thing you output must be a fenced JSON block opened with the line `FINDINGS_JSON` containing your findings array and a verdict string."** Keep reviewing while it runs. The 5-minute timeout hard-kills it if it hasn't finished.
4. **Coupling & interfaces.** Where are modules tightly coupled? Are interfaces minimal and stable? Flag god objects, circular dependencies, and modules that always change together.
5. **Naming & consistency.** Inconsistent naming across modules; domain terms used differently in different places; implementation details leaking into public names.
6. **Tech debt & complexity.** Deep nesting, long functions, dead code, commented-out code, TODOs older than a sprint, overengineered abstractions with no payoff.
7. **Test coverage & quality.** Which modules lack tests? Tests that verify implementation details (mocks on internals) instead of behavior? Flaky or skipped tests?
8. **Stale docs & comments.** READMEs that no longer match the code, comments describing old behavior, outdated decision records.
9. **Combine results.** Once your review is done, wait for the background process (`wait`) then read `/tmp/review-repo-other.log` and look for the `FINDINGS_JSON` block. If the log is empty, has no `FINDINGS_JSON` block, or the process was killed by the 5-minute timeout, state that explicitly ("second reviewer did not produce usable output — single-reviewer findings below") and proceed with your own review alone. Never produce a vacuous "no disagreements" summary when the second reviewer failed. If both produced results, keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the code.
10. **Report by priority.** Group findings **High / Medium / Low** — each with file(s), what's wrong, why it matters, and a concrete improvement. End with a top-3 recommended starting points. If the codebase is healthy, say so clearly.
