---
name: Haiku-first orchestrator with specialized agents
description: Cost-optimized agent architecture: claude-haiku-4.5 as primary orchestrator, claude-sonnet-4.6 for architect/heavy-weight tasks, minimax-m2.7 for light/commodity tasks, gemini-3-flash for research
type: project
---

## Architecture

**claude-haiku-4.5 (Orchestrator)**: Primary model for user interaction, task routing, decision-making. 100k context. Does NOT perform tasks with dedicated agents.

**Specialized agents:**
- **Architect** (claude-sonnet-4.6): Designs large multi-component tasks, produces design docs (hands to orchestrator)
- **Light-Code-Writer** (minimax-m2.7): Implements specs, single features, mechanical refactors
- **Heavy-Code-Writer** (claude-sonnet-4.6): Complex cross-component reasoning (escalated from light)
- **Tester** (minimax-m2.7): Full TDD—write failing tests pre-impl, verify pass post-impl
- **Light-Bug-Fixer** (minimax-m2.7): Single-file bugs with clear error signals
- **Heavy-Bug-Fixer** (claude-sonnet-4.6): Architectural bugs (escalated from light)
- **Research** (gemini-3-flash): Extract/summarize docs, logs, code artifacts. 1M context window.

## Agent Decision Tree

Do NOT handle tasks yourself where dedicated agents exist. Follow tree carefully.

**For new features / refactors / design:**
- Multi-component design spanning 3+ files or architectural decisions? → **Architect** (produces design doc)
  - Then dispatch chunks to **Light-Code-Writer** or **Heavy-Code-Writer** by complexity
- Single feature/refactor with clear spec? → **Light-Code-Writer**
- Implementation needs cross-component tradeoff reasoning spec doesn't cover? → **Heavy-Code-Writer** (escalated)

**For testing:**
- Start: → **Tester** (write failing tests, verify fail)
- After code-writers finish: → **Tester** (run tests, verify pass)

**For bugs:**
- Clear error message/test failure in single file? → **Light-Bug-Fixer**
- Obviously architectural (spans modules, interface changes)? → **Heavy-Bug-Fixer** (direct)
- Light-bug-fixer hits blocker (architectural issue, unclear root cause)? → **Heavy-Bug-Fixer** (escalated with context)

**For info gathering:**
- Extract/summarize docs, logs, code artifacts? → **Research** (1M context, cheap)
- Explore codebase for patterns/conventions? → Glob/Grep directly (targeted), or **Research** if complex

## Why

claude-sonnet-4.6 (1M context, higher reasoning) too expensive as primary orchestrator, even with delegation. claude-haiku-4.5 sufficient for routing + decision-making, reserves sonnet for truly complex tasks. minimax-m2.7 handles commodity work, gemini-3-flash does large-context summarization. Drastically cuts token spend, maintains quality.

## How to apply

Use decision tree in CLAUDE.md. Always route through orchestrator (claude-haiku-4.5) first—applies heuristics to pick right agent.
