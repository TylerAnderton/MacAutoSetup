---
name: systematic-debugging-phase-1
description: Root cause investigation phase for systematic debugging
---

# Phase 1: Root Cause Investigation

**BEFORE ANY fix — MUST complete before Phase 2.**

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

## Step 1: Read Error Messages Carefully

- Don't skip past errors or warnings
- Often contain exact solution
- Read stack traces completely
- Note line numbers, file paths, error codes

## Step 2: Reproduce Consistently

- Can you trigger it reliably?
- What exact steps?
- Does it happen every time?
- **Not reproducible?** Gather more data, don't guess

## Step 3: Check Recent Changes

- What changed recently?
- Git diff, recent commits
- New dependencies, config changes
- Environmental differences

## Step 4: Gather Evidence in Multi-Component Systems

**WHEN system has multiple components (CI -> build -> signing, API -> service -> database):**

**BEFORE proposing fixes, add diagnostic instrumentation at each component boundary:**

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

### Example (multi-layer system):

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

**This reveals:** Which layer fails (secrets -> workflow OK, workflow -> build FAIL)

## Step 5: Trace Data Flow

**WHEN error deep in call stack:**

See `root-cause-tracing.md` in this directory for complete backward tracing technique.

**Quick version:**
- Where does bad value originate?
- What called this with bad value?
- Keep tracing up until source found
- Fix at source, not symptom

## Success Criteria

You have completed Phase 1 when you can answer:
- **WHAT** broke? (specific failure point)
- **WHY** it broke? (root cause mechanism)
- **WHERE** it broke? (which component/layer)

If you cannot answer these three questions clearly, return to Phase 1 and gather more evidence.

## Common "Not Done Yet" Signals

- Only know symptoms, not mechanisms
- Can't pinpoint which component is failing
- Haven't reproduced the issue consistently
- Error messages not fully read
- Recent changes not examined

## Transition to Phase 2

Once you understand WHAT and WHY, proceed to **Phase 2: Pattern Analysis** to compare against working examples and identify differences.
