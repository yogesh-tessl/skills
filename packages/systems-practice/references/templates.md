# Output Templates

Copy-paste-ready templates for each stage's output artifact.

## Stage 1 — Problem Classification Output

```markdown
### Problem Classification

**Verdict**: Messy / Structured

**Rationale**: [2-3 sentences explaining why. Reference specific signals: number of stakeholders, degree of goal conflict, whether the problem definition itself is contested, history of failed interventions.]

**Recommendation**: [Proceed to Stage 2 / Suggest lighter tools and exit]
```

## Stage 2 — Role Map

```markdown
### Role Map

| Role | Type | Goal | Incentive | Power | Info Access |
|------|------|------|-----------|-------|-------------|
| [Role A] | Decision-maker | [What they want] | [What drives behavior] | High | [What they know / lack] |
| [Role B] | Executor | ... | ... | Medium | ... |
| [Role C] | Affected party | ... | ... | Low | ... |
| [Role D] | Excluded party | ... | ... | None | ... |

**Key tensions**: [1-2 sentences on where goals or incentives conflict between roles]
```

### Role Type Definitions

| Type | Definition | Typical Power |
|------|------------|---------------|
| Decision-maker | Authority to approve, fund, or block | High |
| Executor | Carries out the work | Medium |
| Knowledge-holder | Possesses expertise others depend on | Varies |
| Affected party | Experiences consequences, may lack voice | Low-Medium |
| Excluded party | Impacted but not represented | None-Low |

## Stage 3 — CATWOE Table

```markdown
### Root Definition [N]: [Name]

"A system owned by [O] in which [A] perform [T] for [C], based on the belief that [W], subject to [E]."

| Element | Content |
|---------|---------|
| **C** — Customers | [Who benefits or suffers] |
| **A** — Actors | [Who performs the transformation] |
| **T** — Transformation | [Input] → [Output] |
| **W** — Worldview | [Underlying belief that makes T meaningful] |
| **O** — Owner | [Who can stop or authorize] |
| **E** — Environment | [Constraints taken as given] |

### Worldview Conflict Summary

| Role A's framing | Role B's framing | Conflict |
|------------------|------------------|----------|
| "The problem is..." | "The problem is..." | [Why these are incompatible] |
```

## Stage 4 — Boundary Critique

```markdown
### Boundary Critique

#### Boundary Checklist

| Dimension | IS (current reality) | OUGHT (what should be) | Gap |
|-----------|---------------------|----------------------|-----|
| **Motivation** — Who benefits? | [Current beneficiaries] | [Who should benefit] | [Description of gap] |
| **Power** — Who decides? | [Current decision-makers] | [Who should have a say] | ... |
| **Knowledge** — Whose expertise counts? | [Currently valued expertise] | [Missing knowledge] | ... |
| **Legitimacy** — Who is affected but voiceless? | [Currently excluded] | [How they should be represented] | ... |

#### Assumptions Log

| # | Assumption | Held by | Evidence | Risk if wrong |
|---|-----------|---------|----------|---------------|
| 1 | [What is taken for granted] | [Which role(s)] | [Strong/Weak/None] | [What breaks] |
| 2 | ... | ... | ... | ... |

#### Excluded Stakeholders

| Stakeholder | Why excluded | Impact of exclusion | How to include |
|-------------|-------------|-------------------|----------------|
| [Group] | [Structural reason] | [What is missed] | [Concrete action] |
```

## Stage 5 — Dynamic Hypothesis

```markdown
### Dynamic Hypothesis

#### Key Variables

| Variable | Currently | Trend | Influenced by |
|----------|-----------|-------|---------------|
| [e.g., Trust between teams] | Low | Declining | [Other variables] |
| [e.g., Compliance pressure] | High | Stable | [External regulation] |

#### Causal Loop: [Name]

**Type**: Reinforcing (R) / Balancing (B)

[Variable A] →(+) [Variable B] →(+) [Variable C] →(+) [Variable A]

**Narrative**: [2-3 sentences describing the loop in plain language. "As A increases, B increases because... This in turn causes C to..., which feeds back into A."]

**Current state**: [Which loop is dominant and why]

**Delay**: [Where effects take time to materialize]

#### Leverage Point Candidates

| Leverage point | Target variable/loop | Why it matters | Feasibility |
|---------------|---------------------|----------------|-------------|
| [Intervention idea] | [Which loop it disrupts/enables] | [Expected effect] | High/Med/Low |
```

#### CLD Arrow Notation

- →(+) : Same direction (A increases → B increases; A decreases → B decreases)
- →(−) : Opposite direction (A increases → B decreases)
- →(+, delay) : Same direction, with time delay

## Stage 6 — Intervention Options Table

```markdown
### Intervention Options

| | Option 1 | Option 2 | Option 3 |
|---|----------|----------|----------|
| **What to do** | ... | ... | ... |
| **Leverage point** | ... | ... | ... |
| **Key assumptions** | ... | ... | ... |
| **Short-term effect** | ... | ... | ... |
| **Long-term effect** | ... | ... | ... |
| **Who benefits** | ... | ... | ... |
| **Who resists** | ... | ... | ... |
| **Policy resistance risk** | ... | ... | ... |
| **Who needs to act** | ... | ... | ... |

### Pre-mortem

For each option: "It's one year later and this intervention failed. What went wrong?"

- **Option 1**: [Failure scenario]
- **Option 2**: [Failure scenario]
- **Option 3**: [Failure scenario]
```

## Full Session Summary Template

Use this at the end of a complete 6-stage run to consolidate all artifacts:

```markdown
# Systems Practice Summary: [Problem Title]

## Problem Classification
[Stage 1 verdict]

## Role Map
[Stage 2 table]

## Worldview Analysis
[Stage 3 CATWOE + conflicts]

## Boundary Critique
[Stage 4 checklist + assumptions + exclusions]

## Dynamic Hypothesis
[Stage 5 variables + loops + leverage points]

## Intervention Options
[Stage 6 table + pre-mortem]

## Open Questions
- [Questions that emerged but were not resolved]
- [Data needed for validation]
- [Stakeholders to consult next]
```
