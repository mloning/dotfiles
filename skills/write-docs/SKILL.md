---
name: write-docs
description: Write documentation from the actual code — concise, verb-first, no weasel words. Use when writing or updating docs, READMEs, docstrings, API docs, or usage guides.
---

# Write Docs

Document what the code actually does, not what you wish it did. Write for a reader who can't ask questions.

1. **Read the code first.** Read the actual implementation before writing anything. Document from the code — they may differ from the task description.
2. **Identify the audience.** User guide (what to do), API reference (what it accepts/returns), or architecture doc (why it's structured this way)? Different audiences need different content — don't mix them in one doc.
3. **Lead with verbs.** Start headings and descriptions with action verbs: "Configure", "Install", "Returns", "Raises". Avoid noun phrases that bury the action ("Configuration of", "Installation process for").
4. **No weasel words.** Cut: "simply", "just", "easily", "obviously", "basically", "straightforward". If something needs a warning, state exactly what goes wrong and when.
5. **State inputs, outputs, and errors explicitly.** For any function/API: what it accepts (types, constraints), what it returns (type, shape), what it raises (conditions). Don't make the reader read the source to find out.
6. **One example over three paragraphs.** A minimal, runnable example beats prose every time. Make examples copy-pasteable and complete — don't omit imports or setup.
7. **Document the WHY for non-obvious decisions.** Implementation rationale, known limitations, and sharp edges belong in docs. Don't document what the code obviously does.
8. **Keep docs next to the code.** Inline docstrings for functions/classes; README at the module root. Avoid standalone doc files that drift from reality.
9. **Self-check before finishing.** Read the doc as a newcomer: can they complete the task with only this doc? Is anything ambiguous? Is anything false? Fix both.
