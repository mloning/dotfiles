---
name: debug
description: Systematically debug a failure — reproduce it, isolate the root cause, test hypotheses one at a time, then fix the cause and lock it in with a test. Use when investigating a bug, a crash, a failing or flaky test, an error or stack trace, a regression, or unexpected output — any time something is broken and you don't yet know why.
disable-model-invocation: true
---

# Debug

Find the root cause before you change anything. A fix that hides the symptom instead of removing the cause is a failure — the bug resurfaces. **You cannot fix what you don't understand**, so investigate until you can explain the failure, then fix where the bad value originates, not where it surfaces.

Work the phases in order. Don't skip ahead to a fix because the bug "looks obvious" — the obvious cause is often a symptom of the real one.

1. **Reproduce it reliably.** Build the fastest deterministic pass/fail check you can re-run on demand — a failing test, a one-line command, a script — and pin the exact conditions (inputs, env, state, timing) that trigger it. If it's intermittent, run it in a loop until it fails on command; a bug you can't reproduce is one you can't prove you fixed. Can't reproduce it at all? Gather more data (full logs, a clean env, the reporter's exact steps) — don't guess.
2. **Read the evidence completely.** Read the whole error and stack trace top to bottom — it often names the file, line, and cause outright — and follow it to the first frame in your own code. Check what recently changed (`git diff`, `git log`; `git bisect` to pin a regression). Look across boundaries (caller, callee, config, data): the crash site is rarely the origin.
3. **Compare against known-good.** Find working code that does nearly the same thing — a passing sibling test, an analogous call site, the same function on a good input — and diff it against the failing path line by line. The delta is your prime suspect. Note the dependencies (config, state, versions, ordering) the working path relies on that the broken one may be missing.
4. **Form falsifiable hypotheses.** Write 2–3 concrete guesses as "X because Y; if X is true then Z", each disprovable by a single cheap observation. Rank by likelihood × cheapness and test the top one first. No hypothesis means you're guessing, not debugging.
5. **Test one variable at a time.** Probe or change exactly one thing per iteration; never stack fixes or you won't know which one worked. Prefer a debugger/breakpoint to inspect real state over scattered prints; when you do add logs, tag them `[DEBUG]` and remove them after. Confirm or kill each hypothesis before starting the next.
6. **After ~3 failed attempts, STOP.** Repeated failure means your mental model is wrong — the answer is not fix #4. Re-read the evidence from scratch, challenge an assumption you've been treating as fact, explain the problem aloud (rubber-duck), and ask whether the architecture itself makes this bug likely. Widen, don't dig.
7. **Fix the cause, then lock it in.** Fix at the origin, not the symptom. Add a regression test that fails before the fix and passes after. Re-run the original repro *fresh* and confirm it passes — show it works, don't assert "should work". Then scan nearby code for the same latent bug and remove any `[DEBUG]` instrumentation.

## Red flags — stop and restart the phases

- Proposing or writing a fix before you can reproduce the failure and explain its cause.
- Changing more than one thing at once, or "trying things" to see what sticks.
- Saying "should be fixed now" without re-running the repro on the real failing condition.
- Adding a `try/catch`, retry, sleep, null-check, or `|| default` that swallows the symptom instead of removing the cause.
- Editing code you don't yet understand.

## Rationalizations — what you tell yourself vs. the reality

| You think | Reality |
| --- | --- |
| "No time to investigate, just patch it." | Guessing thrashes; the systematic path is faster to green. |
| "It's a trivial bug, no need to reproduce it." | If you can't reproduce it, you can't prove you fixed it. |
| "I mostly see how the working code differs." | Partial understanding ships the next bug — compare fully. |
| "The stack-trace line is the bug." | It's usually a symptom; the cause is upstream. |
| "Tests pass locally, good enough." | Only a fresh run in the real failing condition counts. |
