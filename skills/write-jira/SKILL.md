---
name: write-jira
description: Create a Jira ticket — clear title, problem statement, acceptance criteria, assigned to the most relevant epic. Use when filing a bug, writing a story or task, or creating any Jira issue.
disable-model-invocation: true
---

# Write Jira

A ticket is a contract between reporter and assignee. Every field must be actionable.

1. **Determine issue type.** Story (user-facing value), Task (technical work with no direct user value), Bug (broken behavior), Spike (time-boxed investigation). Choose the type that matches the work.
2. **Write a precise title.** `[Verb] [object]` — e.g. "Add rate limiting to the login endpoint", "Fix null pointer in cart checkout when items is empty". No vague titles ("Improve performance", "Fix bug").
3. **State the problem.** Bugs: actual behavior, expected behavior, steps to reproduce, environment. Stories/tasks: the problem being solved and why it matters now. One paragraph max.
4. **Write testable acceptance criteria.** Given/When/Then format. Every criterion must be independently verifiable. At least one per requirement. Use "must" not "should" or "might".
5. **Assign to the most relevant epic.** Search existing epics by keyword; pick the closest match. If no epic fits, note it and ask — don't leave it empty.
6. **Set a priority.** Default to Medium. High if blocking another team or affecting users now. Critical only for production incidents. Don't inflate priority.
7. **Link related issues.** Any PRs, design docs, dependent or blocking tickets. Add a `Closes <KEY>` reference if there's an existing tracking issue.
8. **Create the ticket.** Use the Jira MCP tool if available; otherwise provide the full ticket content formatted for the user to paste. Report the created issue key.
