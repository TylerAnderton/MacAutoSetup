---
name: get-open-pr-comments
description: "Fetch non-resolved PR review comments from GitHub. Use when user asks about PR feedback/comments. Trigger: 'code review', 'unresolved', 'non-resolved', 'open comments', 'feedback', 'address comments', PR review comment mentions."
---
## Fetch Only OPEN PR Review Comments
- **Primary Source:** Use `~/.claude/skills/get-open-pr-comments/get_open_pr_comments.sh <PR_NUMBER>` to retrieve non-resolved comments.
- **Ignore Fallbacks:** Script returns data → never run manual `gh api` calls to `pulls/.../comments`.
- **Context Handling:** Script provides `context` field (diff hunk) and `line`/`original_line`. Use to locate code. Need more context? Use `read_file` on specified file/line; don't fetch comments again.
- **Truth Source:** Comment not in script output? It's **RESOLVED**. Don't seek resolved comments.
