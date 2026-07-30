---
name: write-docs
description: Write documentation and in-code comments from the actual code — concise, verb-first, no weasel words, each thing explained once where it matters. Use when writing or updating docs, READMEs, tutorials, instructions, summaries, architecture overviews, docstrings or API docs, and when adding or editing code comments.
---

# Write Docs

Document what the code actually does, not what you wish it did. Write for a reader who can't ask questions, and explain each thing exactly once — in the one place they will look for it.

## Docs — READMEs, guides, tutorials, docstrings, API and architecture docs

1. **Read the code first.** Read the actual implementation before writing anything. Document from the code — it may differ from the task description.
2. **Identify the audience.** User guide (what to do), API reference (what it accepts/returns), or architecture doc (why it's structured this way)? Different audiences need different content — don't mix them in one doc.
3. **Lead with verbs.** Start headings and descriptions with action verbs: "Configure", "Install", "Returns", "Raises". Avoid noun phrases that bury the action ("Configuration of", "Installation process for").
4. **No weasel words.** Cut: "simply", "just", "easily", "obviously", "basically", "straightforward". If something needs a warning, state exactly what goes wrong and when.
5. **State inputs, outputs, and errors explicitly.** For any function/API: what it accepts (types, constraints), what it returns (type, shape), what it raises (conditions). Don't make the reader read the source to find out.
6. **One example over three paragraphs.** A minimal, runnable example beats prose every time. Make examples copy-pasteable and complete — don't omit imports or setup.
7. **Document the WHY for non-obvious decisions.** Implementation rationale, known limitations, and sharp edges belong in docs. Don't document what the code obviously does.
8. **Keep docs next to the code.** Inline docstrings for functions/classes; README at the module root. Avoid standalone doc files that drift from reality.
9. **Self-check before finishing.** Read the doc as a newcomer: can they complete the task with only this doc? Is anything ambiguous? Is anything false? Fix both.

## In-code comments

1. **Explain why, never what.** A comment that restates the code is noise — delete it. Comment the reason: the constraint, the trade-off, the bug it works around, the invariant that isn't visible locally. If code needs a comment to be readable at all, rename or restructure it instead.
2. **One canonical explanation per concept.** Before writing, check whether a docstring, module header, or nearby comment already explains it. If it does, don't restate it — reference the concept by its established name. Duplicated explanations drift apart, and every copy is another place to update.
3. **Comment where it matters, and disclose progressively.** Name the concept at the highest level (docstring: "retries on connection timeout"); explain the mechanism only at the single place it's implemented (how the timeout is derived and applied); everywhere else — call sites, helpers, tests — refer to the high-level concept and stop. Readers descend into detail when they need it; don't push implementation details up or sideways.
4. **Delete what the code has outgrown.** When you change code, fix or delete the comment describing the old behavior — a stale comment is worse than none, because readers trust it. Same for commented-out code (delete it; git remembers) and bare `TODO`s (state what and why, or drop it).
5. **Re-read your comments in the diff.** For each one: does it restate the code? Is it already explained upstream? Is this the most relevant place for it? Cut or move accordingly.
