---
name: jira-tickets
description: Use when the user wants to fill in a detailed description for an existing Jira ticket or create new tickets. Runs a front-loaded interview, follows the conventions of parent and sibling tickets, reviews each draft in Plannotator, saves an approved copy to the user's Obsidian Tickets folder, then updates or creates the ticket through the Atlassian MCP.
---

# Jira Tickets

## Rules

- Do not switch to Plan mode. It blocks the Plannotator CLI.
- Jira site, cloud ID, and project keys come from the Atlassian MCP connector configuration. Never hardcode them here.
- Plannotator approval of a draft is the gate for writing that ticket to Jira. No second confirmation is needed.

## Steps

1. **Interview first.** Spend more time discussing than seems necessary; front-loaded effort saves time later. Ask about:
   - which tickets to fill in or create, and for new ones the project, type, and parent;
   - the goal, scope, acceptance criteria, and anything out of scope for each;
   - the full path of the Obsidian `Tickets/` folder to save copies to. Always ask; it changes each time;
   - anything unclear. Keep asking until the requirements are settled.

2. **Learn the conventions.** Fetch the parent and sibling tickets through the Atlassian MCP. Follow their Jira, git, and formatting conventions: title style, section headings, label and field use, branch naming, and markup. Use the MCP's content format guide for the description format.

3. **Draft.** Write each ticket as its own `.md` file in the platform's tmp plans location (Cursor: `~/.cursor/plans/`; Claude Code: `~/.claude/plans/`).

4. **Review each draft** in Plannotator and iterate until approved:
   - **Claude Code:** use the `plannotator-annotate` skill on the draft.
   - **Cursor:** run `plannotator annotate --gate --json <draft-file>`.

5. **After each approval,** in this order:
   1. Save a copy to the chosen Obsidian `Tickets/` folder.
   2. Update the existing ticket's description, or create the new ticket, through the Atlassian MCP.
   3. Report the ticket key and link.
