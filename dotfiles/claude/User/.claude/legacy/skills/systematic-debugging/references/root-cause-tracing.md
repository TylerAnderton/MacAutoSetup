---
name: root-cause-tracing
description: Trace bugs backward through call stack to find original trigger
---

# Root Cause Tracing

**Technique for tracing bugs backward through call stack.**

## When to Use

When error occurs deep in call stack and direct cause is unclear.

## The Technique

1. **Start at the failure point**
   - Identify exact line/component that fails
   - Note the bad value or state being used

2. **Trace backward one level**
   - Who called this?
   - What did they pass?
   - Was the value wrong when passed, or corrupted later?

3. **Repeat until source found**
   - Continue tracing up call stack
   - Each level: was value correct at entry?

4. **Fix at the source**
   - Root cause is where bad value originated
   - Don't fix symptom at downstream point
   - Fix at the source

## Example

```
Error: "Cannot read property 'name' of undefined"
  at processUser (user.js:42)
    at handleRequest (server.js:88)
      at router (index.js:21)

Tracing:
1. user.js:42 - user.name accessed, user is undefined
2. user.js:42 <- user was passed from handleRequest
3. handleRequest (server.js:88) - user comes from lookupUser()
4. lookupUser() - returns undefined when userId not found
5. ROOT CAUSE: lookupUser() returns undefined for missing userId

Fix: Validate userId exists before calling lookupUser(), or handle
     missing userId at lookupUser() level.
```

## Key Principle

**Fix at source, not symptom.**

Don't add null checks downstream if you can fix the source that produces null.
