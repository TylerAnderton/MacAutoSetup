---
name: write-jira-tickets
description: Use when the user asks to write, create, or generate Jira tickets for a feature, bug fix, or refactor. Covers the full process: codebase exploration, collaborative clarification, ticket decomposition, dependency mapping, and iterative one-at-a-time ticket writing with the user reviewing each before proceeding.
---

<objective>
Break feature into Epic + numbered implementation tickets, one at a time with user review. Goal: tickets detailed enough another Claude instance implements with minimal input.
</objective>

<essential_principles>
**Rules:**
1. Never write tickets before reading code
2. Present full breakdown before writing any ticket
3. Write one at a time — no batching
</essential_principles>

<intake>
The user wants Jira tickets written for a feature, bug fix, or refactor.
</intake>

<routing>
- Always route to workflows/ticket-process.md for full process
</routing>
