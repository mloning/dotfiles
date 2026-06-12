---
name: debug
description: Systematically debug a failure — reproduce it, find the root cause, test hypotheses, then fix. Use when investigating a bug, a failing test, an error, or why something is broken.
---

# Debug

Find the root cause before changing anything — patching a symptom is failure. Fix where the bad value originates, not where it surfaces.

1. **Reproduce.** Build the fastest deterministic pass/fail check you can re-run. Can't reproduce? Gather more data — don't guess.
2. **Read the evidence.** Read the full error and stack trace (it often names the cause); check what recently changed (`git diff`).
3. **Hypothesize.** Write 2–3 falsifiable guesses ("X because Y; if X, then Z") and test the cheapest first.
4. **Instrument one thing.** Probe a single hypothesis, one variable at a time — prefer a breakpoint over scattered logs; tag temporary logs `[DEBUG]` and remove them after.
5. **Stuck after ~3 tries?** Stop — your mental model is wrong. Re-examine assumptions instead of attempting fix #4.
6. **Lock it in.** Add a regression test, then confirm the original repro passes.
