---
name: explain
description: Explain code clearly — data flow, call sequence, a minimal example. Use when asked how code works, what a module does, or to understand an unfamiliar part of the codebase.
disable-model-invocation: true
---

# Explain

Start broad, then drill. Use the project's own vocabulary. Stop when the question is answered.

1. **Read the code first.** Read the actual implementation before explaining — don't explain from type signatures or memory alone.
2. **Match the question's altitude.** "What does this do?" → one-paragraph summary. "How does this work?" → data flow + call sequence. "Why is it built this way?" → design rationale + trade-offs. Start at the level asked; go deeper only if needed.
3. **Use the project's vocabulary.** Use domain terms from CONTEXT.md and the codebase, not generic CS terms when the project has its own names. Say "Workspace" not "container object" if that's what the code calls it.
4. **Describe data flow first.** For non-trivial code: where does data enter, what transforms it, where does it go? Data flow is usually faster to grasp than control flow.
5. **Walk the call sequence for execution questions.** List the key function calls in order (`a() → b() → c()`), one sentence per step. Omit utility/boilerplate calls that don't affect understanding.
6. **Give a minimal example.** A concrete input → output trace beats paragraphs of prose. Use the smallest example that demonstrates the behavior — not a real-world one that needs context.
7. **State what it doesn't do.** Boundaries and non-behaviors are often what the reader really needs. "This does not handle X — that's done in Y."
8. **Be concise.** If the explanation is longer than the code, it's probably wrong. Cut anything the reader doesn't need to act on the explanation.
9. **Check understanding last.** After explaining, always end by asking the user to describe the concept back in their own words. Then verify: confirm what they got right, correct misconceptions directly, and fill any gaps they missed. Don't just say "correct" — point to the specific part that was right or wrong. This is the final step every time; do not skip it.
