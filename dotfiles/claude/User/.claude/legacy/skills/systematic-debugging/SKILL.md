---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

<objective>
Debug any technical issue systematically. Find root cause BEFORE attempting fixes. Random fixes waste time and create new bugs.
</objective>

<essential_principles>
**IRON LAW (inline):** NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST

- Haven't completed Phase 1? Cannot propose fixes.
- Symptom fixes fail. Always fix root cause, not symptoms.
- Violating this process violates the spirit of debugging.
- Systematic debugging is FASTER than guess-and-check thrashing.
</essential_principles>

<intake>
<trigger>
  <when>
    - Test failures
    - Bugs in production
    - Unexpected behavior
    - Performance problems
    - Build failures
    - Integration issues
  </when>
  <especially_when>
    - Under time pressure (emergencies tempt guessing)
    - "One quick fix" seems obvious
    - Already tried multiple fixes that failed
    - Previous fix didn't work
    - Don't fully understand the issue
  </especially_when>
  <dont_skip_when>
    - Issue seems simple (simple bugs have root causes)
    - In a hurry (rushing guarantees rework)
    - Manager wants it fixed NOW (systematic is faster)
  </dont_skip_when>
</trigger>
</intake>

<routing>
<phase route="1">
  <name>Root Cause Investigation</name>
  <workflow>workflows/phase-1-root-cause.md</workflow>
  <success>Understand WHAT broke and WHY</success>
</phase>

<phase route="2">
  <name>Pattern Analysis</name>
  <workflow>workflows/phase-2-4-fix.md</workflow>
  <success>Identify differences between working and broken</success>
</phase>

<phase route="3">
  <name>Hypothesis and Testing</name>
  <workflow>workflows/phase-2-4-fix.md</workflow>
  <success>Single hypothesis confirmed or rejected</success>
</phase>

<phase route="4">
  <name>Implementation</name>
  <workflow>workflows/phase-2-4-fix.md</workflow>
  <success>Bug resolved, tests pass</success>
</phase>
</routing>

<red_flags>
<reference>references/red-flags.md</reference>
<stop_signals>
  - "Quick fix for now, investigate later"
  - "Try changing X see if it works"
  - "Add multiple changes, run tests"
  - "Skip test, manually verify"
  - "Probably X, fix that"
  - "Don't understand but might work"
  - "Pattern says X but adapt differently"
  - Proposing solutions before tracing data flow
  - "One more fix attempt" (tried 2+)
  - Each fix reveals new problem elsewhere
</stop_signals>
<if_three_plus_failures>
  Question architecture. See workflows/phase-2-4-fix.md Phase 4.5.
</if_three_plus_failures>
</red_flags>

<quick_reference>
<phase_summary>
  - **1. Root Cause:** Read errors, reproduce, check changes, gather evidence
  - **2. Pattern:** Find working examples, compare, identify differences
  - **3. Hypothesis:** Form theory, test minimally, verify before continuing
  - **4. Implementation:** Create test, fix root cause, verify
</phase_summary>

<supporting_techniques>
- `root-cause-tracing.md` - Trace bugs backward through call stack
- `defense-in-depth.md` - Add validation at multiple layers
- `condition-based-waiting.md` - Replace arbitrary timeouts with condition polling
</supporting_techniques>

<related_skills>
- `test-driven-development` - For creating failing test case
- `verification-before-completion` - Verify fix worked before claiming success
</related_skills>
</quick_reference>
