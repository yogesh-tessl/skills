---
name: distill
description: "Simplifies UI designs by reducing visual clutter, consolidating redundant elements, removing decorative noise, flattening component trees, and streamlining information architecture. Use when the user asks to simplify a layout, reduce design complexity, clean up a cluttered interface, minimize visual noise, remove unnecessary elements, or strip a page down to its essential components."
metadata:
  user-invocable: true
  args:
    - name: target
      description: The feature or component to distill (optional)
      required: false
---

Remove unnecessary complexity from designs, revealing essential elements and creating clarity through systematic simplification.

## Mandatory Preparation

### Context Gathering

Gather from the current thread or codebase: target audience, desired use-cases, and what is essential vs nice-to-have.

1. If inferring from existing design, STOP and call AskUserQuestionTool to confirm assumptions.
2. If confidence is medium or lower, STOP and call AskUserQuestionTool to clarify before proceeding.

### Use frontend-design skill

Load the frontend-design skill for design principles and anti-patterns before proceeding.

---

## Assess Current State

Identify complexity sources:

- **Too many elements**: Competing buttons, redundant information, visual clutter
- **Excessive variation**: Too many colors, fonts, sizes without purpose
- **Information overload**: Everything visible at once, no progressive disclosure
- **Visual noise**: Unnecessary borders, shadows, decorations
- **Confusing hierarchy**: Unclear what matters most

Find the essence:
- What is the ONE primary user goal?
- What is necessary vs nice-to-have?
- What 20% delivers 80% of value?

If unclear, STOP and call AskUserQuestionTool.

## Simplify the Design

### Information Architecture
- Remove secondary actions and redundant information
- Hide complexity behind clear entry points (accordions, modals, step-through flows)
- Merge similar buttons, consolidate forms, group related content
- ONE primary action, few secondary, everything else tertiary or hidden

### Visual
- 1-2 colors plus neutrals, not 5-7
- One font family, 3-4 sizes max, 2-3 weights
- Remove decorative borders, shadows, backgrounds that do not serve hierarchy
- Remove unnecessary cards — use spacing and alignment instead
- One spacing scale throughout

### Layout
- Replace complex grids with simple vertical flow where possible
- Move secondary content inline or hide sidebars
- Consistent alignment — pick left or center, stick with it
- Generous white space

### Interaction
- Fewer buttons, fewer options, clearer path forward
- Smart defaults — only ask when necessary
- Inline editing over modal flows where possible
- ONE obvious next step per view

### Content
- Cut every sentence in half, then cut again
- Active voice, plain language, no jargon
- Short paragraphs, bullet points, clear headings
- Say it once — no repeated explanations

### Code
- Remove dead CSS, unused components, orphaned files
- Flatten component trees, reduce nesting depth
- Consolidate similar styles, reduce variant count

**NEVER**: Remove necessary functionality, sacrifice accessibility, make things unclear, remove information users need for decisions, or oversimplify complex domains.

## Verify Simplification

Concrete checks:
- Count interactive elements before/after — aim for 30-50% reduction
- Measure component nesting depth — target max 3 levels
- Verify all necessary features remain accessible
- Confirm primary action is immediately obvious
- Check page weight decreased (fewer elements → faster load)

## Document Changes

If features or options were removed:
- Document why they were removed
- Note alternative access points if needed
- Flag any user feedback to monitor
