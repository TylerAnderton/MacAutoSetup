---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time, create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes fail.

**Violating letter of this process violates spirit of debugging.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

Haven't completed Phase 1? Cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use ESPECIALLY when:**
- Under time pressure (emergencies tempt guessing)
- "One quick fix" seems obvious
- Already tried multiple fixes
- Previous fix didn't work
- Don't fully understand issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes)
- In hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic faster than thrashing)

## The Four Phases

MUST complete each phase before proceeding to next.

### Phase 1: Root Cause Investigation

**BEFORE ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Often contain exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Trigger reliably?
   - What exact steps?
   - Happens every time?
   - Not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - What changed?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

5. **Trace Data Flow**

   **WHEN error deep in call stack:**

   See `root-cause-tracing.md` in this directory for complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until source found
   - Fix at source, not symptom

### Phase 2: Pattern Analysis

**Find pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works similar to what's broken?

2. **Compare Against References**
   - Implementing pattern? Read reference COMPLETELY
   - Don't skim - read every line
   - Understand pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What components needed?
   - What settings, config, environment?
   - What assumptions made?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X root cause because Y"
   - Write down
   - Be specific, not vague

2. **Test Minimally**
   - Make SMALLEST change to test hypothesis
   - One variable at time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Worked? → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend know
   - Ask help
   - Research more

### Phase 4: Implementation

**Fix root cause, not symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use `test-driven-development` skill for proper failing tests

2. **Implement Single Fix**
   - Address root cause identified
   - ONE change at time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue resolved?

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP question architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem elsewhere
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP question fundamentals:**
   - Pattern fundamentally sound?
   - "Sticking with it through sheer inertia"?
   - Should refactor architecture vs. continue fixing symptoms?

   **Discuss with human partner before more fixes**

   NOT failed hypothesis - wrong architecture.

## Red Flags - STOP Follow Process

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

**If 3+ fixes failed:** Question architecture (see Phase 4.5)

## Human Partner's Signals You're Doing It Wrong

**Watch for redirections:**
- "Is that not happening?" - Assumed without verifying
- "Will it show us...?" - Should have added evidence gathering
- "Stop guessing" - Proposing fixes without understanding
- "Ultrathink this" - Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) - Approach not working

**When see these:** STOP. Return to Phase 1.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue simple, don't need process" | Simple bugs have root causes. Process fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging FASTER than guess-and-check thrashing. |
| "Try this first, then investigate" | First fix sets pattern. Do right from start. |
| "Write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, adapt pattern" | Partial understanding guarantees bugs. Read completely. |
| "See problem, fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+) | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

If systematic investigation reveals issue truly environmental, timing-dependent, or external:

1. Completed process
2. Document what investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Supporting Techniques

Techniques part of systematic debugging, available in this directory:

- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
- **`defense-in-depth.md`** - Add validation at multiple layers after finding root cause
- **`condition-based-waiting.md`** - Replace arbitrary timeouts with condition polling

**Related skills:**
- **test-driven-development** - For creating failing test case (Phase 4, Step 1)
- **verification-before-completion** - Verify fix worked before claiming success

## Real-World Impact

From debugging sessions:
- Systematic approach: 15-30 minutes to fix
- Random fixes approach: 2-3 hours thrashing
- First-time fix rate: 95% vs 40%
- New bugs introduced: Near zero vs common