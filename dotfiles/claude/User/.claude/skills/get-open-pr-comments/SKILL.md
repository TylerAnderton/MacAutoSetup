---
name: get-open-pr-comments
description: "Fetch non-resolved PR review comments from GitHub. Use when user asks about PR feedback, unresolved comments, or code review feedback."
---

<objective>
Retrieve non-resolved PR review comments from GitHub for code review feedback.
</objective>

<process>
Use `~/.claude/skills/get-open-pr-comments/get_open_pr_comments.sh <PR_NUMBER>` as the primary source for retrieving non-resolved comments.

The script provides a `context` field (diff hunk) and line numbers to locate code in the repository. If you need more context around a comment, use `read_file` on the specified file and line — do not fetch comments again.
</process>

<rules>
- **Script is authoritative.** If the script returns data, never run manual `gh api` calls to `pulls/.../comments`.
- **Context field usage.** The `context` field provides the diff hunk. Use it to locate the relevant code. Need more surrounding context? Use `read_file`, not additional API calls.
- **Resolved = not in output.** If a comment does not appear in the script output, it is RESOLVED. Do not seek resolved comments.
</rules>

<success_criteria>
- All non-resolved comments are retrieved via the shell script
- No manual `gh api` calls when script returns data
- Resolved comments are not fetched or discussed
- Code locations are identified using the `context` field
</success_criteria>
