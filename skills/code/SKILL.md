---
name: code
description: Write production code to best practices — correct, minimal, well-named, consistent with the existing codebase. Use when implementing a feature, adding to existing code, or writing code from a plan or spec.
disable-model-invocation: true
---

# Code

Write the simplest correct code. No speculative features, no premature abstractions, no unnecessary comments.

1. **Read before writing.** Read the relevant existing code, naming conventions, and patterns first. Match the style of the surrounding code — don't introduce a new pattern unless the old one is clearly broken.
2. **Start from the interface.** Define the public interface (function signature, type, API surface) before the implementation. If you can't describe what it does in one sentence, the interface is wrong.
3. **Write the minimal implementation.** Make it work for the actual requirements — YAGNI. Three similar lines are better than a premature abstraction. No feature flags, no backwards-compat shims, no "we might need this later."
4. **Name things precisely.** Names should describe what something IS or DOES, not how it works internally. Name functions with a leading verb for the action they perform (e.g. `fetchUser`, `computeTotal`). Prefer domain vocabulary over technical jargon. If a name needs a comment to explain it, rename it.
5. **No defensive programming for the impossible.** Don't add error handling, fallbacks, or validation for inputs that can't reach this code. Only validate at system boundaries (user input, external APIs, network responses).
6. **No comments that describe what the code does.** Only add a comment when the WHY is non-obvious: a hidden constraint, a workaround for a specific bug, an invariant that would surprise a careful reader.
7. **Run build and tests.** After writing, run build/linters/tests (check README/CLAUDE.md/CI for the commands). Fix anything that fails — don't declare done on red.
8. **Self-review the diff.** `git diff main...HEAD` — read it as a reviewer. Is every line earned? Does anything look surprising or out of place? Fix before moving on.
