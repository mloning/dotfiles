---
name: git-sync
description: Sync the current branch with main by merging — fetch main, merge it into the branch, resolve any conflicts, commit and push, then refresh the PR description if the merge changed scope. Use when merging latest main into a feature branch or keeping an open PR up to date with main.
disable-model-invocation: true
---

# Git Sync

Merge the latest `main` into the current branch and keep its PR current. Runs end to end without prompting — stop only for a genuine judgment call (an ambiguous conflict or work that would be discarded). Merge, never rebase, so the branch history and any open PR keep their commit shas.

1. **Pre-flight.** Never run on `main` itself — confirm you're on a feature branch (`git rev-parse --abbrev-ref HEAD`). Capture the pre-merge tip: `git rev-parse HEAD`.
2. **Check the working tree.** `git status`. If there are uncommitted changes, stash them (`git stash push -m "sync-git-wip"`) and note it; don't discard anything.
3. **Fetch main.** `git fetch origin main` — get the latest ref without touching HEAD.
4. **Merge.** `git merge origin/main` into the current branch. If already up to date, skip to step 8 and report "already current".
5. **Resolve conflicts.** If the merge stops on conflicts:
   a. List them: `git diff --name-only --diff-filter=U`.
   b. Resolve each at the source — prefer incoming `main` for infra/config, prefer local for this branch's feature code; when genuinely ambiguous, **stop and ask** rather than guess.
   c. `git add <file>` each resolved file, then `git commit --no-edit` to finalize the merge commit.
   d. To bail out entirely: `git merge --abort`.
6. **Verify.** Run the project's build/tests after resolving — a clean merge can still break the build. Report failures; don't push over a broken build without saying so.
7. **Restore stash.** If you stashed in step 2, `git stash pop` and re-resolve any conflicts it surfaces.
8. **Push.** `git push` (a merge needs no force). If the push is rejected because the remote moved, `git fetch` and merge again — never `--force`.
9. **Refresh the PR description — only where necessary.** Check for an open PR on the branch. Compare `git diff <pre-merge-tip>...HEAD` against what the PR body claims: a routine sync merge changes nothing the reviewer cares about, so **leave the description alone**. Update it only when the merge genuinely altered the branch's scope (e.g. conflict resolution changed behaviour, or main's changes reshaped what this branch now does). When it does need updating, invoke the `submit-pr` skill to rewrite the description at the altitude of intent, then edit the existing PR (don't open a new one).
10. **Report.** State: branch merged to which commit of `main`, conflicts resolved (or none), build/test result, pushed or not, and whether the PR description was updated (and why).
