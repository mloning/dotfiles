---
name: brainstorm
description: Explore approaches to a problem before planning — web search for prior art, generate alternatives, weigh trade-offs, converge on a direction. Use when ideating before a plan, evaluating options, or thinking through a design decision.
disable-model-invocation: true
---

# Brainstorm

Explore before committing. The goal is the best approach, not the first approach. No code until a direction is agreed.

1. **Quiz me first.** Ask focused scoping questions: what problem are we solving, what constraints exist, what does success look like, what have we already ruled out? Ask one at a time, each with your recommended default. Restate the question precisely before moving on.
2. **Search for prior art.** Web-search for existing solutions, libraries, patterns, and documented trade-offs. Prefer primary sources (official docs, papers, changelogs). Summarize what exists before generating ideas — don't reinvent what's already solved.
3. **Generate 3 distinct approaches.** Make them genuinely different — not variations of the same idea. For each: a one-line description, how it works, and the key trade-off.
4. **Weigh trade-offs explicitly.** For each approach state: complexity to build and maintain, performance characteristics, fit with the existing codebase, and what it forecloses in future.
5. **One question at a time.** Narrow the field iteratively — one clarifying or decision question at a time, each with your recommended answer. Don't present all open questions at once.
6. **Converge on a direction.** Once options are explored, recommend one approach with a one-paragraph rationale. State explicitly what you're trading away and why that's acceptable.
7. **No code.** This skill ends at a direction decision — the output feeds into `plan`. Do not start implementing.
