---
name: Haiku-first orchestrator with specialized agents
description: Cost-optimized agent architecture: claude-haiku-4.5 as primary orchestrator, claude-sonnet-4.6 for architect/heavy-weight tasks, minimax-m2.7 for light/commodity tasks, gemini-3-flash for research
type: project
---

## Architecture

**claude-haiku-4.5 (Orchestrator)**: Primary model for user interaction, task routing, and decision-making. 100k context. Does *NOT* perform any of the tasks for which specialized agents exist.

**Specialized agents:**
- **Architect** (claude-sonnet-4.6): Designs large multi-component tasks, produces design docs (hands to orchestrator, never implements)
- **Light-Code-Writer** (minimax-m2.7): Implements specs, single features, mechanical refactors
- **Heavy-Code-Writer** (claude-sonnet-4.6): Complex cross-component reasoning (escalated from light)
- **Tester** (minimax-m2.7): Full TDD workflow—writes failing tests pre-impl, verifies pass post-impl
- **Light-Bug-Fixer** (minimax-m2.7): Single-file bugs with clear error signals
- **Heavy-Bug-Fixer** (claude-sonnet-4.6): Architectural bugs (escalated from light)
- **Research** (gemini-3-flash): Docs/logs/code artifact extraction with 1M context window

## Agent Decision Tree

Do *NOT* handle tasks yourself for which agents have been established. Follow this decision tree carefully.

**For new features / refactors / design tasks:**
- Is this a multi-component design spanning 3+ files or requiring architectural decisions? → **Architect** (produces design doc)
  - Then dispatch design chunks to **Light-Code-Writer** or **Heavy-Code-Writer** based on complexity
- Is this a single feature/refactor with a clear spec? → **Light-Code-Writer**
- Does implementation require reasoning about cross-component tradeoffs that the spec doesn't resolve? → **Heavy-Code-Writer** (escalated)

**For testing:**
- Start of task: → **Tester** (write failing tests, verify they fail)
- After code-writers finish: → **Tester** (run tests, verify they pass)

**For bugs:**
- Clear error message/test failure in a single file? → **Light-Bug-Fixer**
- Obviously architectural (spans modules, requires interface changes)? → **Heavy-Bug-Fixer** (direct)
- Light-bug-fixer hits a blocker (architectural issue, unclear root cause)? → **Heavy-Bug-Fixer** (escalated with context)

**For information gathering:**
- Need to extract/summarize docs, logs, or large code artifacts? → **Research** (1M context, cheap)
- Need to explore codebase for patterns/conventions? → Use Glob/Grep directly (targeted), or **Research** if complex

## Why:** claude-sonnet-4.6 (1M context, higher reasoning) is too expensive as the primary orchestrator, even with delegation. claude-haiku-4.5 is sufficient for routing and decision-making, reserves claude-sonnet-4.6 for truly complex tasks. minimax-m2.7 for commodity work, gemini-3-flash for large-context summarization. Drastically reduces token spend while maintaining quality.

## How to apply:** Use decision tree in CLAUDE.md. Always route through orchestrator (claude-haiku-4.5) first, which applies heuristics to pick the right agent.
