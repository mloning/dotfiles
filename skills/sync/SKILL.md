---
name: sync
description: Sync the current branch with main — fetch, rebase or merge, resolve any conflicts, then push. Use when syncing with upstream, pulling in latest main, or preparing to open a PR.
disable-model-invocation: true
---

# Sync

Sync cleanly. Never discard work without confirmation. Resolve conflicts at the source, not by accepting one side blindly.

1. **Check working tree.** `git status` — if there are uncommitted changes, stash them first (`git stash push -m "sync-wip"`) and note it.
2. **Fetch upstream.** `git fetch origin` to get the latest refs without changing HEAD.
3. **Choose strategy.** Default to rebase (`git rebase origin/main`) for feature branches — keeps history linear. Use merge only if the branch is shared or public. State which you're doing.
4. **Handle conflicts.** If conflicts arise:
   a. List every conflicted file: `git diff --name-only --diff-filter=U`.
   b. Resolve each file — prefer the incoming change for infra/config; prefer local for feature code; when genuinely ambiguous, **stop and ask** before guessing.
   c. After each file: `git add <file>`, then `git rebase --continue` or finalize the merge.
   d. Run build/tests after all conflicts resolved — a clean merge can still break things.
5. **Restore stash.** If you stashed in step 1, pop it (`git stash pop`) and verify no new conflicts.
6. **Push.** Use `git push --force-with-lease` after a rebase (NEVER `--force`); plain `git push` after a merge. Confirm before pushing if the branch has an open PR.
7. **Report.** State: branch synced to which commit of main, number of conflicts resolved (or none), whether tests passed.
