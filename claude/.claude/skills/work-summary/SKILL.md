---
name: work-summary
description: Generate an activity summary for a team member covering GitHub PRs and Jira tickets over a given time horizon. Use when the user asks for a work summary, weekly summary, activity report, or wants to review what a team member has been working on. Accepts a username and optional number of days to look back (default 7).
---

# Work Summary

Generate an activity summary for a team member, covering GitHub PRs and Jira tickets.

## Usage

```
/work-summary <username> [days]
```

- `<username>`: GitHub/Jira username (e.g. `croyen`)
- `[days]`: Optional. Number of days to look back (default: `7`). Examples: `7`, `30`, `90`.

## Instructions

Given a username and optional time horizon (default 7 days), compute the start date as `today - days` and run the following steps.

### 1. GitHub PRs

Run these two searches in parallel:

- All PRs authored by the user created since the start date: `author:<username> created:>=<start_date>`
- All PRs authored by the user merged since the start date: `author:<username> is:merged merged:>=<start_date>`

Use `perPage: 50`.

Combine the results into a single deduplicated list. For each PR determine:

- **Repo**: the repository name only (not the full URL, e.g. `nm-wave`)
- **Title**: PR title
- **Status**: `Merged`, `Open`, or `Closed` (closed without merge)
- **Created**: date only (e.g. `Mar 18`)
- **Duration**:
  - If merged or closed: time from created_at to closed_at. Show in minutes if < 1h, hours if < 24h, days if >= 24h.
  - If still open: time from created_at to today, suffixed with `(ongoing)`.

Present as a single table sorted by created date ascending:

| Repo | Title | Status | Created | Duration |
| ---- | ----- | ------ | ------- | -------- |

### 2. Jira Tickets

Run these queries in parallel:

- Created this period: `reporter = <username> AND created >= "<start_date>"`
- Completed this period: `assignee = <username> AND status = Done AND updated >= "<start_date>"`
- Active (assigned, not done, updated this period): `assignee = <username> AND updated >= "<start_date>" AND status != Done`

Fields to request: `summary,status,issuetype,created,updated,priority,assignee`

Combine the results into a single deduplicated list. For each PR determine:

- **Issue**: the name only (not the full URL)
- **Action**: Created, completed, active
- **Summary**: Issue summary based on title and description
- **Status**

Present as a single table sorted by created data ascending:

| Issue | Action | Summary | Status |
| ----- | ------ | ------- | ------ |

If a section is empty, write "None."

### 3. TL;DR

End with a 2–3 sentence plain-English summary of the highlights: number of PRs merged, key themes across the work, and any notable Jira progress.
