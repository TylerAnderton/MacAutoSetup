---
name: defense-in-depth
description: Add validation at multiple layers after finding root cause
---

# Defense in Depth

**Add validation at multiple layers after finding root cause.**

## Purpose

After root cause found, prevent similar bugs by adding validation at multiple checkpoints.

## The Technique

1. **Identify the root cause** (from Phase 1)
2. **Find all entry points** where bad data could enter system
3. **Add validation at each layer**
   - Input boundaries
   - Component interfaces
   - State transitions

## Example

If root cause was "null userId passed to lookupUser()":

```
Layer 1: API endpoint - validate userId required and non-empty
Layer 2: Service layer - validate userId is valid format
Layer 3: Repository - validate userId exists in database
Layer 4: Business logic - handle missing userId gracefully
```

## Key Principle

**Multiple safety nets.**

Single validation fails. Multiple layers catch failures that slip through.
