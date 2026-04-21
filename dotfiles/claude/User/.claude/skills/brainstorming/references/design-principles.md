# Design Principles

Visual companion guidance and design clarity principles.

## Visual Companion

Browser companion for mockups, diagrams, visuals during brainstorming.

### Offering Companion

Anticipate visual content (mockups, layouts, diagrams)? Offer once for consent:

> "Some might be easier shown in browser. Can put mockups, diagrams, comparisons, visuals as we go. Still new, token-intensive. Try it? (Requires local URL)"

Offer MUST be own message. Only offer, nothing else. Wait for response. Decline? Proceed text-only.

### Per-Question Decision

Even after accept, decide FOR EACH QUESTION whether browser or terminal. Test: **understand better seeing or reading?**

- **Use browser** for visual content — mockups, wireframes, layout comparisons, architecture diagrams, side-by-side designs
- **Use terminal** for text content — requirements questions, conceptual choices, tradeoff lists, A/B/C/D options, scope decisions

UI topic ≠ automatic visual. "What does personality mean?" = conceptual — use terminal. "Which wizard layout works?" = visual — use browser.

## Design Isolation and Clarity

Break system into units:
- One clear purpose
- Well-defined interfaces
- Understood and tested independently

Per unit: what does it do, how use it, what depends on?

Someone can understand unit without reading internals. Change internals without breaking consumers. If not, boundaries need work.

Smaller units = easier reasoning. Hold in context at once. Edits more reliable. Files focused. Large file = often doing too much.

## YAGNI

YAGNI ruthlessly. Remove unnecessary from designs. Simple projects = where unexamined assumptions waste work. Design can be short, but MUST present and get approval.

## Only Invoke writing-plans After Approval

NOT other implementation skills. writing-plans = only valid next step after brainstorming design approval.
