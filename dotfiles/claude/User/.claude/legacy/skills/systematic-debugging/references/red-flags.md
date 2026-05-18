---
name: systematic-debugging-red-flags
description: Red flags, rationalizations, and human partner signals for systematic debugging
---

# Red Flags - STOP and Return to Phase 1

Catch yourself thinking:

- "Quick fix for now, investigate later"
- "Try changing X see if it works"
- "Add multiple changes, run tests"
- "Skip test, manually verify"
- "Probably X, fix that"
- "Don't understand but might work"
- "Pattern says X but adapt differently"
- "Main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (tried 2+)**
- **Each fix reveals new problem elsewhere**

**ALL mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question architecture (see Phase 4.5 in workflows/phase-2-4-fix.md)

---

# Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue simple, don't need process" | Simple bugs have root causes. Process fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging FASTER than guess-and-check thrashing. |
| "Try this first, then investigate" | First fix sets pattern. Do it right from the start. |
| "Write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, adapt pattern" | Partial understanding guarantees bugs. Read completely. |
| "See problem, fix it" | Seeing symptoms does not equal understanding root cause. |
| "One more fix attempt" (after 2+) | 3+ failures = architectural problem. Question pattern, don't fix again. |

---

# Human Partner's Signals You're Doing It Wrong

**Watch for redirections:**

| Signal | Meaning |
|--------|---------|
| "Is that not happening?" | Assumed something without verifying |
| "Will it show us...?" | Should have added evidence gathering first |
| "Stop guessing" | Proposing fixes without understanding |
| "Ultrathink this" | Question fundamentals, not just symptoms |
| "We're stuck?" (frustrated) | Approach not working |

**When you see these:** STOP. Return to Phase 1.

---

# Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |
