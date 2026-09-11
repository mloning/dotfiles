---
name: git-sync
description: Sync the current branch with its base branch by merging — resolve the base (the open PR's base, which in a stacked PR is the parent branch, not main), fetch it, merge it in, resolve any conflicts, commit and push, then refresh the PR description if the merge changed scope. Use when merging the latest base branch into a feature branch or keeping an open PR up to date.
disable-model-invocation: true
---

# Git Sync

Merge the latest base branch into the current branch and keep its PR current. The base is whatever this branch actually targets — for a stacked PR that's the parent feature branch, **not** `main`. Runs end to end without prompting — stop only for a genuine judgment call (an ambiguous conflict or work that would be discarded). Merge, never rebase, so the branch history and any open PR keep their commit shas.

> **Tooling — prefer MCP.** For every GitHub operation (finding the branch's PR, reading its base branch, editing the description), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_my_prs`, `ghe_get_pr`, `ghe_pr_edit` if present. Git operations stay local (`git fetch` / `merge` / `push`); only the PR lookups go through MCP. Fall back to `gh` only when no MCP tool is available.

1. **Pre-flight.** Confirm you're on a feature branch (`git rev-parse --abbrev-ref HEAD`) — never run on the repo's default branch. Capture the pre-merge tip: `git rev-parse HEAD`.
2. **Resolve the base branch.** In order, first hit wins:
   a. An explicit base passed as an argument to this skill.
   b. The base of the open PR for this branch — GitHub MCP (`ghe_my_prs` / `ghe_get_pr`, reading the PR's base ref), else `gh pr view --json baseRefName -q .baseRefName`. This is the authoritative answer for a stacked PR.
   c. The tracked upstream, if it isn't this branch's own remote copy: `git rev-parse --abbrev-ref '@{upstream}'`.
   d. The repo default branch — GitHub MCP repo lookup, else `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, else `git symbolic-ref --short refs/remotes/origin/HEAD`.
   Set `BASE` to the resolved name and state it in the report. If the resolved base equals the current branch, stop — nothing to sync.
3. **Check the working tree.** `git status`. If there are uncommitted changes, stash them (`git stash push -m "sync-git-wip"`) and note it; don't discard anything.
4. **Fetch the base.** `git fetch origin "$BASE"` — get the latest ref without touching HEAD.
5. **Merge.** `git merge "origin/$BASE"` into the current branch. If already up to date, skip to step 9 and report "already current".
6. **Resolve conflicts.** If the merge stops on conflicts:
   a. List them: `git diff --name-only --diff-filter=U`.
   b. Resolve each at the source — prefer the incoming base for infra/config, prefer local for this branch's feature code; when genuinely ambiguous, **stop and ask** rather than guess.
   c. `git add <file>` each resolved file, then `git commit --no-edit` to finalize the merge commit.
   d. To bail out entirely: `git merge --abort`.
7. **Verify.** Run the project's build/tests after resolving — a clean merge can still break the build. Report failures; don't push over a broken build without saying so.
8. **Restore stash.** If you stashed in step 3, `git stash pop` and re-resolve any conflicts it surfaces.
9. **Push.** `git push` (a merge needs no force). If the push is rejected because the remote moved, `git fetch` and merge again — never `--force`.
10. **Refresh the PR description — only where necessary.** Check for an open PR on the branch (GitHub MCP, else `gh pr view`) — reuse what step 2 already fetched rather than querying twice. Compare `git diff <pre-merge-tip>...HEAD` against what the PR body claims: a routine sync merge changes nothing the reviewer cares about, so **leave the description alone**. Update it only when the merge genuinely altered the branch's scope (e.g. conflict resolution changed behaviour, or the base's changes reshaped what this branch now does). When it does need updating, invoke the `submit-pr` skill to rewrite the description at the altitude of intent, then edit the existing PR (don't open a new one).
11. **Report.** State: which base branch was used and how it was resolved, the base commit merged in, conflicts resolved (or none), build/test result, pushed or not, and whether the PR description was updated (and why).

## Stacked PRs

Sync only against the immediate base. Don't reach past it to `main` — that pulls commits the parent branch hasn't taken yet and makes this branch's diff misrepresent the stack. If the parent is itself stale, say so in the report and let the user sync the stack bottom-up (run this skill on each branch from the base of the stack upward); don't do it unasked.
