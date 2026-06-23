---
name: reply-pr
description: Verify and address open review comments on the current PR — fetch unresolved comments, check each against the codebase, fix what's correct, push back with justification where needed. Use when responding to PR review feedback or addressing review comments.
disable-model-invocation: true
---

# Reply PR

Verify before implementing. Ask before assuming. Technical correctness over social comfort.

> **Tooling — prefer MCP.** For every GitHub operation (fetching comments, replying, resolving threads, re-requesting review), use an available GitHub MCP server's tools in preference to the `gh` CLI — e.g. `ghe_pr_unresolved_threads`, `ghe_pr_comments`, `ghe_reply_review_comment` if present. Fall back to `gh` only when no MCP tool is available.

1. **Fetch open comments.** Get all unresolved review comments for the current branch's PR — GitHub MCP (e.g. `ghe_pr_unresolved_threads`), else `gh pr view --comments`. Note the PR number and each reviewer.
2. **Read completely before acting.** Read every comment in full before touching any code. Group them: (a) clearly correct, (b) needs clarification, (c) disagree / would break something.
3. **Verify each comment against the code.** Check the actual code at the referenced location. Restate what the comment is asking. Don't assume the reviewer is right; don't assume they're wrong.
4. **Implement correct fixes.** For group (a): make the change, run build/tests to confirm nothing breaks. Smallest change that addresses the comment — don't refactor while fixing.
5. **Clarify before acting on ambiguous comments.** For group (b): post a reply asking exactly what you need to know. Don't guess.
6. **Push back with evidence on incorrect comments.** For group (c): reply with the specific technical reason ("This would break X because Y — see `file:line`"). No hedging, no "Great point, but..." — just state the constraint.
7. **Reply format.** For each addressed comment: "Fixed. [One sentence: what changed and where]." No more. For pushbacks: state the constraint, the file/line, and what breaks.
8. **Commit and push.** Stage only changes that address review comments. Commit with a message referencing the review (e.g. `address review comments`). Push to the same branch.
9. **Re-request review.** After pushing, mark addressed comments as resolved and re-request review from the original reviewers.
