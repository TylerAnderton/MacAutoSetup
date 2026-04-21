---
name: systematic-debugging-phases-2-4
description: Pattern analysis, hypothesis testing, and implementation phases
---

# Phase 2: Pattern Analysis

**Find pattern before fixing.**

## Step 1: Find Working Examples

- Locate similar working code in same codebase
- What works similar to what's broken?

## Step 2: Compare Against References

- Implementing pattern? Read reference COMPLETELY
- Don't skim - read every line
- Understand pattern fully before applying

## Step 3: Identify Differences

- What's different between working and broken?
- List every difference, however small
- Don't assume "that can't matter"

## Step 4: Understand Dependencies

- What components are needed?
- What settings, config, environment?
- What assumptions were made?

---

# Phase 3: Hypothesis and Testing

**Scientific method applied.**

## Step 1: Form Single Hypothesis

- State clearly: "I think X root cause because Y"
- Write it down
- Be specific, not vague

## Step 2: Test Minimally

- Make SMALLEST change to test hypothesis
- One variable at a time
- Don't fix multiple things at once

## Step 3: Verify Before Continuing

- Worked? Proceed to Phase 4
- Didn't work? Form NEW hypothesis
- **DON'T add more fixes on top**

## Step 4: When You Don't Know

- Say "I don't understand X"
- Don't pretend to know
- Ask for help
- Research more

---

# Phase 4: Implementation

**Fix root cause, not symptom.**

## Step 1: Create Failing Test Case

- Simplest possible reproduction
- Automated test if possible
- One-off test script if no framework
- **MUST have before fixing**
- Use `test-driven-development` skill for proper failing tests

## Step 2: Implement Single Fix

- Address root cause identified in Phase 1
- ONE change at a time
- No "while I'm here" improvements
- No bundled refactoring

## Step 3: Verify Fix

- Test passes now?
- No other tests broken?
- Issue resolved?

## Step 4: If Fix Doesn't Work

- **STOP**
- Count: How many fixes tried?
- If < 3: Return to Phase 1, re-analyze with new information
- **If 3 or more: Proceed to Step 5 below**
- **DON'T attempt Fix #4 without architectural discussion**

## Step 5: If 3+ Fixes Failed - Question Architecture

**Pattern indicating architectural problem:**
- Each fix reveals new shared state/coupling/problem elsewhere
- Fixes require "massive refactoring" to implement
- Each fix creates new symptoms elsewhere

**STOP and question fundamentals:**
- Is the pattern fundamentally sound?
- Are we "sticking with it through sheer inertia"?
- Should we refactor architecture vs. continue fixing symptoms?

**Discuss with human partner before more fixes.**

This is NOT a failed hypothesis - it means wrong architecture.

---

# When Process Reveals "No Root Cause"

If systematic investigation reveals issue truly environmental, timing-dependent, or external:

1. Completed process properly
2. Document what was investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

---

# Real-World Impact

From debugging sessions:
- Systematic approach: 15-30 minutes to fix
- Random fixes approach: 2-3 hours thrashing
- First-time fix rate: 95% vs 40%
- New bugs introduced: Near zero vs common
