---
name: delight
description: "Adds micro-interactions, hover animations, loading state personality, success celebrations, confetti effects, Easter eggs, and playful transitions to UI components. Use when the user asks for animations, micro-interactions, delightful UI touches, Easter eggs, playful loading states, satisfying feedback, celebration moments, or wants to make an interface feel more polished and engaging."
metadata:
  user-invocable: true
  args:
    - name: target
      description: The feature or area to add delight to (optional)
      required: false
---

Add moments of joy and personality that transform functional interfaces into memorable experiences.

## Mandatory Preparation

### Context Gathering

Gather from the current thread or codebase: target audience, desired use-cases, brand personality (playful vs professional vs quirky vs elegant), and what is appropriate for the domain.

1. If inferring from existing design, STOP and call AskUserQuestionTool to confirm assumptions.
2. If confidence is medium or lower, STOP and call AskUserQuestionTool to clarify before proceeding.

### Use frontend-design skill

Load the frontend-design skill for design principles and anti-patterns before proceeding.

---

## Assess Delight Opportunities

Identify where delight enhances (not distracts from) the experience:

| Moment | Examples |
|--------|----------|
| Success states | Save, send, publish confirmations |
| Empty states | First-time experiences, onboarding |
| Loading states | Waiting periods that could be engaging |
| Achievements | Milestones, streaks, completions |
| Interactions | Hover, click, drag feedback |
| Errors | Softening frustrating moments |
| Easter eggs | Hidden discoveries for curious users |

Define strategy: subtle sophistication (luxury), playful personality (consumer), helpful surprises (productivity), or sensory richness (creative tools).

## Delight Principles

- **Amplifies, never blocks**: Keep moments under 1 second, never delay core functionality, make everything skippable
- **Surprise and discovery**: Hide details for users to find, reward exploration, vary responses
- **Context-appropriate**: Celebrate success, empathize with errors, match brand personality
- **Compounds over time**: Remain fresh with repeated use, reveal deeper layers gradually

## Delight Techniques

### Micro-interactions

```css
/* Satisfying button press with lift on hover */
.button {
  transition: transform 0.15s ease-out, box-shadow 0.15s ease-out;
}
.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
.button:active {
  transform: translateY(1px);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}
```

```jsx
// Success celebration with confetti (canvas-confetti)
import confetti from 'canvas-confetti';

function onMajorSuccess() {
  confetti({ particleCount: 100, spread: 70, origin: { y: 0.6 } });
}
```

```css
/* Checkbox bounce on check */
@keyframes checkBounce {
  0% { transform: scale(0); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}
.checkbox:checked + .checkmark {
  animation: checkBounce 0.3s cubic-bezier(0.25, 1, 0.5, 1);
}
```

### Personality in Copy

| Context | Generic | Delightful |
|---------|---------|------------|
| 404 page | "Page not found" | "This page is playing hide and seek (and winning)" |
| Empty inbox | "No messages" | "Inbox zero! You're crushing it today." |
| Loading | "Loading..." | "Waking up the servers..." / "Teaching robots to dance..." |
| Connection error | "Connection failed" | "The internet took a coffee break. Retry?" |

Match copy personality to brand — banks can be warm without being wacky.

### Success Celebrations

- Animated checkmark draw for task completion
- Confetti burst for major milestones
- Gentle scale + fade for standard confirmations
- Personalized messages at milestones ("You published your 10th article!")
- Streak tracking with celebratory visuals

### Easter Eggs

- Konami code unlocks special theme
- Console messages for developers ("Like what you see? We're hiring!")
- Alt text jokes on illustrations
- Time-of-day variations in greetings or themes
- Randomized loading messages that rotate

## Implementation

Recommended libraries: Framer Motion (React), GSAP (universal), Lottie (After Effects), canvas-confetti (celebrations), Howler.js (audio), React Spring (physics).

**NEVER**: Delay core functionality for delight, force users through animations, use delight to hide poor UX, ignore `prefers-reduced-motion`, sacrifice performance, or make every interaction delightful (special moments should stay special).

## Verify

- Still pleasant after the 100th time?
- Can users skip or opt out?
- No jank or slowdown?
- Works with reduced motion and screen readers?
- Matches brand personality and context?
