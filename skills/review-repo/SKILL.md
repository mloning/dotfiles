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
   - **The other agent** runs the same checklist headless in the background (steps 4–8 only — skip this parallel step) and lists findings with `file:line`. From Claude: `codex exec "<prompt>" > /tmp/review-repo-other.log 2>&1 &`; from Codex: `claude -p "<prompt>" --output-format stream-json --include-partial-messages --verbose --no-session-persistence > /tmp/review-repo-other.log 2>&1 &`. Keep reviewing while it runs.
4. **Coupling & interfaces.** Where are modules tightly coupled? Are interfaces minimal and stable? Flag god objects, circular dependencies, and modules that always change together.
5. **Naming & consistency.** Inconsistent naming across modules; domain terms used differently in different places; implementation details leaking into public names.
6. **Tech debt & complexity.** Deep nesting, long functions, dead code, commented-out code, TODOs older than a sprint, overengineered abstractions with no payoff.
7. **Test coverage & quality.** Which modules lack tests? Tests that verify implementation details (mocks on internals) instead of behavior? Flaky or skipped tests?
8. **Stale docs & comments.** READMEs that no longer match the code, comments describing old behavior, outdated decision records.
9. **Combine results.** Once your review is done and the other agent's process has exited, reconcile the two lists: keep findings both confirm (high confidence), investigate disagreements, drop anything neither can substantiate from the code.
10. **Report by priority.** Group findings **High / Medium / Low** — each with file(s), what's wrong, why it matters, and a concrete improvement. End with a top-3 recommended starting points. If the codebase is healthy, say so clearly.
