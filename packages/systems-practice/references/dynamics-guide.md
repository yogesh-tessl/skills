# System Dynamics Guide

Reference for Stage 5 — Dynamic Hypothesis.

## Table of Contents

1. [Core Idea](#core-idea)
2. [Causal Loop Diagram Notation](#causal-loop-diagram-notation)
3. [System Archetypes](#system-archetypes)
4. [Leverage Points](#leverage-points)
5. [Building a Dynamic Hypothesis](#building-a-dynamic-hypothesis)
6. [Common Pitfalls](#common-pitfalls)

## Core Idea

System Dynamics, pioneered by Jay Forrester, models how variables in a system change over time and influence each other through feedback loops. The core insight: **behavior in complex systems is driven by structure (feedback loops and delays), not by individual events or actors.**

In Systems Practice, we use System Dynamics not to build simulation models, but to draft **dynamic hypotheses** — testable stories about which feedback loops are driving the behavior we observe. A dynamic hypothesis says: "The reason we see [this pattern] is because [these loops] are dominant, and [these delays] are masking [these effects]."

## Causal Loop Diagram Notation

Since we work in text, use this notation for causal relationships:

### Arrow Types

| Notation | Meaning | Example |
|----------|---------|---------|
| A →(+) B | A and B move in the same direction | Trust →(+) Collaboration |
| A →(−) B | A and B move in opposite directions | Workload →(−) Quality |
| A →(+, delay) B | Same direction, with time delay | Training →(+, delay) Competence |
| A →(−, delay) B | Opposite direction, with delay | Pollution →(−, delay) Health |

### Loop Types

**Reinforcing loop (R)**: All arrows multiply to give a positive net effect. The loop amplifies change — things get better and better, or worse and worse.

```
R: Trust →(+) Collaboration →(+) Results →(+) Trust
```

"More trust leads to more collaboration, which produces better results, which builds more trust." (Or in reverse: less trust → less collaboration → worse results → even less trust.)

**Balancing loop (B)**: The net effect is negative — the loop resists change and seeks equilibrium.

```
B: Workload →(+) Errors →(+) Rework →(+) Workload
   Workload →(+) Hiring pressure →(+, delay) New staff →(−) Workload per person
```

"As workload increases, errors increase, creating more rework, which adds to workload. Meanwhile, high workload creates hiring pressure, but new staff take time to onboard (delay), eventually reducing workload per person."

### Writing CLD Descriptions

For each loop, provide:

1. **The loop as arrows** (using notation above)
2. **A narrative** in plain language (2-3 sentences)
3. **Current state**: Is this loop currently dominant? Is it virtuous or vicious?
4. **Key delay**: Where does the effect take time to materialize?

## System Archetypes

Recurring structural patterns that appear across many different systems. When you recognize an archetype, you can anticipate behavior and identify leverage points faster.

### Fixes That Fail

**Structure**: A quick fix alleviates a symptom, but creates a side effect (with delay) that makes the original problem worse.

```
Problem →(+) Quick fix →(−) Symptom
Quick fix →(+, delay) Side effect →(+) Problem
```

**Example**: Overtime fixes the delivery deadline (symptom), but causes burnout (side effect, delayed), which reduces productivity and makes future deadlines harder to meet.

**Leverage**: Address the root cause instead of the symptom. If you must use the quick fix, pair it with monitoring for the side effect.

### Shifting the Burden

**Structure**: A symptomatic solution competes with a fundamental solution. The symptomatic solution is faster, so it gets used, which atrophies the capacity for the fundamental solution.

```
Problem →(+) Symptomatic solution →(−) Symptom
Problem →(+) Fundamental solution →(−, delay) Problem
Symptomatic solution →(−, delay) Capacity for fundamental solution
```

**Example**: A team relies on a senior engineer to fix every production issue (symptomatic). The fundamental solution is training junior engineers, but every time the senior fixes it, juniors learn less, making the team more dependent on the senior.

**Leverage**: Invest in the fundamental solution even when the symptomatic one is available. Deliberately limit access to the quick fix.

### Limits to Growth

**Structure**: A reinforcing loop drives growth, but eventually encounters a constraint (balancing loop) that slows or stops it.

```
R: Effort →(+) Results →(+) Investment →(+) Effort
B: Results →(+) Constraint activation →(−) Results
```

**Example**: A startup grows through word-of-mouth (R), but growth increases support load, which degrades service quality, which reduces referrals (B).

**Leverage**: Anticipate the constraint and invest in removing it before growth stalls. Don't push harder on the reinforcing loop — invest in the constraint.

### Tragedy of the Commons

**Structure**: Multiple actors draw from a shared resource. Each benefits individually from using more, but collective overuse depletes the resource.

```
Actor A activity →(+) Actor A gain
Actor A activity →(+) Total resource use →(−, delay) Resource availability →(−) Actor A gain
(Same for Actor B, C, ...)
```

**Example**: Multiple teams share a data platform. Each team runs heavy queries for their own analytics, collectively degrading platform performance for everyone.

**Leverage**: Make the shared resource's condition visible to all actors. Create governance mechanisms (quotas, pricing, shared monitoring).

### Accidental Adversaries

**Structure**: Two partners each take actions that unintentionally undermine the other, creating a vicious cycle of retaliation.

```
A's action →(+) A's results, →(−) B's results
B's response →(+) B's results, →(−) A's results
```

**Example**: Engineering optimizes for deployment speed (breaking APIs), which disrupts customer-facing teams. Customer teams add governance processes, which slows engineering. Each sees the other as obstructive.

**Leverage**: Create shared visibility into how each party's actions affect the other. Design joint metrics.

## Leverage Points

Donella Meadows' hierarchy of leverage points, ordered from weakest to strongest:

| Rank | Leverage Point | Example | Power |
|------|---------------|---------|-------|
| 12 | Numbers (parameters, subsidies, taxes) | Adjusting a budget line item | Weakest |
| 11 | Buffer sizes | Increasing inventory to absorb demand spikes | Low |
| 10 | Stock-and-flow structure | Redesigning a physical workflow | Low-Med |
| 9 | Delays | Shortening feedback delay in a quality loop | Medium |
| 8 | Balancing loop strength | Adding monitoring to catch errors earlier | Medium |
| 7 | Reinforcing loop strength | Creating a word-of-mouth referral program | Medium |
| 6 | Information flows | Making performance data visible to those affected | Med-High |
| 5 | Rules (incentives, punishments, constraints) | Changing who gets rewarded for what | High |
| 4 | Self-organization | Allowing teams to restructure themselves | High |
| 3 | Goals | Redefining what the system is trying to achieve | Very High |
| 2 | Paradigm (mindset) | Changing the underlying belief about how things work | Very High |
| 1 | Transcending paradigms | Recognizing that no paradigm is "true" | Strongest |

**Practical note**: Most interventions target levels 10-12 (parameters and structures). The higher leverage points (1-5) are more powerful but harder to implement because they challenge existing power structures and beliefs — which is exactly why Stage 4 (Boundary Critique) matters. You can't shift paradigms without understanding whose paradigm currently dominates and why.

## Building a Dynamic Hypothesis

### Step-by-Step Process

1. **List key variables** from Stages 2-4:
   - Anything that stakeholders care about and that changes over time
   - Include both "hard" variables (budget, headcount, adoption rate) and "soft" variables (trust, morale, legitimacy)
   - Aim for 4-8 variables — enough to capture important dynamics, few enough to reason about

2. **Identify causal relationships**:
   - For each pair of variables, ask: "If A increases, does B increase (+) or decrease (−)? Is there a delay?"
   - Only include relationships you can explain — don't draw arrows just because two things correlate

3. **Find the loops**:
   - Trace paths through the variables that return to their starting point
   - Classify each as Reinforcing (R) or Balancing (B)
   - Name each loop descriptively (e.g., "Trust spiral," "Burnout trap," "Compliance ratchet")

4. **Identify the dominant loop**:
   - Which loop best explains the current behavior?
   - Is the system growing, declining, oscillating, or stuck? The dominant loop type should match.

5. **Spot the delays**:
   - Where does it take time for effects to propagate?
   - Delays are the #1 source of policy resistance — people give up on interventions before the effect materializes

6. **Propose leverage points**:
   - Which variable or loop, if shifted, would change the overall behavior?
   - Prefer higher-leverage interventions (information flows, rules, goals) over parameter tweaks

### Quality Checks

- **Does the hypothesis explain the observed behavior?** If the system is stagnating, your hypothesis should contain a dominant balancing loop.
- **Is each arrow defensible?** Can you explain why A affects B, not just assert it?
- **Are delays explicit?** If your model has no delays, you're probably missing important dynamics.
- **Is there at least one reinforcing and one balancing loop?** Real systems always have both.

## Common Pitfalls

1. **Too many variables.** A CLD with 15+ variables is impossible to reason about. Aggregate related variables and focus on the ones that matter most for the intervention question.

2. **Confusing correlation with causation.** Draw arrows only for causal relationships you can explain mechanistically. "Both increased last year" is not a causal relationship.

3. **Ignoring soft variables.** Trust, morale, legitimacy, and political will are real system variables. They are harder to measure but often drive the dynamics that hard variables cannot explain.

4. **Linear thinking in a nonlinear system.** "If we double training, we'll double competence." Feedback loops mean effects are rarely proportional. A small increase in trust might unlock a reinforcing loop that produces large effects; a large budget increase might hit a balancing loop and produce nothing.

5. **Forgetting that loops change dominance.** The reinforcing loop that drives early adoption may be overwhelmed by a balancing loop (capacity constraints) later. Your hypothesis should identify conditions under which loop dominance might shift.
