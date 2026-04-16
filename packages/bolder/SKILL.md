---
name: bolder
description: "Amplifies safe or boring UI designs with bolder typography, stronger color contrast, dramatic spatial scale, intentional visual effects, and entrance animations. Use when the user says a design looks too plain, boring, bland, generic, or asks to make it pop, more exciting, more dramatic, spice it up, or make it visually memorable."
metadata:
  user-invocable: true
  args:
    - name: target
      description: The feature or component to make bolder (optional)
      required: false
---

Increase visual impact and personality in designs that are too safe, generic, or visually underwhelming.

## Mandatory Preparation

### Context Gathering

Gather from the current thread or codebase: target audience, desired use-cases, brand personality/tone, and constraints.

1. If inferring from existing design, STOP and call AskUserQuestionTool to confirm assumptions.
2. If confidence is medium or lower, STOP and call AskUserQuestionTool to clarify before proceeding.

### Use frontend-design skill

Load the [frontend-design](../frontend-design/SKILL.md) skill for design principles and anti-patterns. Review ALL the DON'T guidelines before proceeding.

---

## Assess Current State

Identify what makes the design feel too safe:

- **Generic choices**: System fonts, basic colors, standard layouts
- **Timid scale**: Everything medium-sized with no drama
- **Low contrast**: Everything has similar visual weight
- **Static**: No motion, no energy
- **Predictable**: Standard patterns with no surprises
- **Flat hierarchy**: Nothing commands attention

**CRITICAL — AI Slop Trap**: When making things "bolder," AI defaults to the same tired tricks: cyan/purple gradients, glassmorphism, neon accents on dark backgrounds, gradient text on metrics. These are the OPPOSITE of bold — they are generic. Bold means distinctive, not "more effects." If the result looks like every other AI-generated design, start over.

## Plan Amplification

- **Focal point**: What should be the hero moment? Pick ONE, make it amazing.
- **Personality direction**: Maximalist chaos? Elegant drama? Playful energy? Dark moody? Choose a lane.
- **Risk budget**: How experimental can we be within constraints?
- **Hierarchy amplification**: Make big things BIGGER, small things smaller.

## Amplify the Design

### Typography

```css
/* Dramatic scale: 3-5x jumps, not 1.5x */
.hero-heading {
  font-size: clamp(3rem, 8vw, 6rem);
  font-weight: 900;
  letter-spacing: -0.03em;
  line-height: 0.95;
}
.body-text {
  font-size: 1rem;
  font-weight: 300;
  line-height: 1.6;
}
```

- Replace system fonts with distinctive choices (variable, display, or condensed fonts)
- Pair 900 weights with 200 weights, not 600 with 400
- Use monospace as intentional accent, not lazy default

### Color

```css
/* Dominant color strategy: one bold color owns 60% */
:root {
  --dominant: oklch(55% 0.25 30);    /* rich saturated primary */
  --accent: oklch(75% 0.2 150);      /* high-contrast complement */
  --neutral: oklch(95% 0.01 30);     /* tinted gray, not pure gray */
  --dark: oklch(20% 0.02 30);        /* tinted near-black */
}
```

- Increase saturation — vibrant, not neon
- Bold unexpected combinations, not purple-to-blue gradients
- Sharp accent colors that pop
- Rich intentional multi-stop gradients

### Spatial Drama
- 3-5x scale jumps for important elements
- Let hero elements break the grid and escape containers
- Asymmetric layouts with intentional tension
- Generous white space (100-200px gaps)
- Overlapping layers for depth

### Visual Effects
- Large, soft shadows for elevation (not generic drop shadows on rounded rectangles)
- Mesh patterns, noise textures, geometric backgrounds
- Grain, halftone, duotone — NOT glassmorphism
- Thick borders, decorative frames, custom shapes
- Custom illustrative elements reinforcing brand

### Motion

```css
/* Entrance choreography with stagger */
.card { animation: fadeSlideIn 0.6s ease-out both; }
.card:nth-child(1) { animation-delay: 0ms; }
.card:nth-child(2) { animation-delay: 75ms; }
.card:nth-child(3) { animation-delay: 150ms; }

@keyframes fadeSlideIn {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: translateY(0); }
}
```

- Scroll-triggered reveals and parallax
- Satisfying hover effects with ease-out-quart/quint/expo (not bounce or elastic)
- Full-bleed viewport elements for impact

**NEVER**: Add effects randomly, sacrifice readability, make everything bold (contrast requires restraint), ignore accessibility, overwhelm with motion, or copy trendy aesthetics blindly.

## Verify

- **Not AI slop**: Would someone immediately say "AI made this bolder"? If yes, redo it.
- **Still functional**: Users can accomplish tasks without distraction
- **Coherent**: Everything feels intentional and unified
- **Memorable**: Users would remember this experience
- **Performant**: All effects run smoothly at 60fps
- **Accessible**: Meets WCAG contrast and motion standards
