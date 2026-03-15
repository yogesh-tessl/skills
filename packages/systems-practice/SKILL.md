---
name: systems-practice
description: "Structured problem analysis protocol for messy, multi-stakeholder situations using Critical Pluralist Systems Practice. Combines Soft Systems Methodology (SSM), Critical Systems Heuristics (CSH), and System Dynamics into a 6-stage thinking process that produces actionable artifacts (role maps, CATWOE tables, boundary critiques, causal loop hypotheses, intervention options). Use this skill when users face organizational transformation, AI adoption challenges, multi-stakeholder policy design, complex product strategy, consulting diagnosis, or any situation where stakeholders disagree on what the problem even is. Triggers: \"help me structure this problem\", \"stakeholder analysis\", \"who benefits and who decides\", \"boundary critique\", \"systems thinking for this situation\", \"messy problem\", \"wicked problem\", \"多方利害關係人\", \"系統思考分析\", \"問題結構化\", \"邊界批判\", \"利害關係人分析\", \"組織變革分析\"."
license: MIT
metadata:
  version: "1.0.0"
---

# Systems Practice

A stage-based problem structuring protocol grounded in Critical Pluralist Systems Practice. The purpose is not to generate answers but to surface better questions, expose blind spots, and produce structured artifacts (boundary objects) for collaborative action.

## When to Use vs. When Not To

| Situation | Action |
|-----------|--------|
| Messy, contested, multi-stakeholder | Run full 6-stage protocol |
| Moderately complex, 2-3 stakeholders | Run Stages 1-3, offer to continue |
| Well-defined technical problem | Suggest lighter tools (model-thinking, decision matrix), exit gracefully |
| Simple execution task | Decline — this protocol adds overhead without value |

## The 6-Stage Protocol

Run one stage at a time. Always display the stage number and name as a header. At the end of each stage, present the output artifact and ask: **"Does this reflect your understanding? Anything to correct before we continue?"**

Never skip Stage 4 (Boundary Critique) — it is the most commonly omitted step in practice, and its absence is the single biggest source of blind spots.

If the user wants to jump ahead, acknowledge the request, state what will be missing, and let them decide.

### Stage 1 — Problem Classification

**Goal**: Determine whether this problem warrants the full protocol.

1. Ask the user to describe the situation in plain language
2. Listen for signals of messiness:
   - Multiple actors with different goals?
   - Disagreement about what the problem actually is?
   - No single "owner" of the problem?
   - Technical and social dimensions intertwined?
   - History of failed interventions?
3. Classify the problem:
   - **Structured** (clear goal, known method, single decision-maker) → suggest lighter tools, exit
   - **Messy** (contested framing, multiple stakeholders, no agreed solution path) → proceed to Stage 2

**Output artifact**: Problem type verdict + 2-3 sentence rationale explaining why this qualifies as messy (or doesn't).

### Stage 2 — Role & Stakeholder Abstraction

**Goal**: Map who is involved and what positions they occupy in the system — not by name, but by function.

1. Extract actors from the user's description
2. Abstract each into a functional role:

| Role Type | Definition |
|-----------|------------|
| Decision-maker | Has authority to approve, fund, or block |
| Executor | Carries out the work on the ground |
| Knowledge-holder | Possesses expertise or data others depend on |
| Affected party | Experiences consequences but may lack voice |
| Excluded party | Impacted but not currently represented |

3. For each role, identify:
   - **Goal**: What they want from this situation
   - **Incentive**: What drives their behavior (may differ from stated goal)
   - **Power level**: High / Medium / Low — ability to influence outcomes
   - **Information access**: What they know that others don't, and what they lack

**Output artifact**: Role map as a structured table. See [references/templates.md](references/templates.md) for the template.

### Stage 3 — Worldview & Problem Framing

**Goal**: Surface how different roles frame the problem differently, using Soft Systems Methodology's CATWOE analysis.

1. For each major role (typically 2-4), articulate their worldview: "From this role's perspective, the problem is..."
2. Build 1-3 Root Definitions using CATWOE:

| Element | Question |
|---------|----------|
| **C**ustomers | Who benefits or suffers from the transformation? |
| **A**ctors | Who performs the transformation? |
| **T**ransformation | What is the input → output change? |
| **W**orldview | What belief makes this transformation meaningful? |
| **O**wner | Who can stop or authorize this? |
| **E**nvironment | What constraints are taken as given? |

3. Identify where worldviews conflict — where one role's "obvious solution" is another role's "core problem"

**Output artifact**: CATWOE table (one per Root Definition) + worldview conflict summary. See [references/ssm-guide.md](references/ssm-guide.md) for detailed guidance.

### Stage 4 — Boundary Critique

**Goal**: Expose whose interests, knowledge, and values are included in the current framing — and whose are excluded. This is based on Critical Systems Heuristics (CSH).

This stage is non-negotiable. Skipping it means accepting the current power structure's framing uncritically.

For each major stakeholder group, ask the four boundary questions in two modes:

| Dimension | IS (current reality) | OUGHT (what should be) |
|-----------|---------------------|----------------------|
| **Motivation** | Who currently benefits? | Who should benefit? |
| **Power** | Who currently decides? | Who should have a say? |
| **Knowledge** | Whose expertise currently counts? | Whose knowledge is missing? |
| **Legitimacy** | Who is currently affected but has no voice? | How should they be represented? |

Then surface:
- **Hidden assumptions**: What is being taken for granted that could be questioned?
- **Structural exclusions**: Who has been systematically left out of the conversation?
- **IS/OUGHT gaps**: Where is the biggest disconnect between current reality and what should be?

**Output artifact**: Boundary checklist table + assumptions log + excluded stakeholders list. See [references/csh-guide.md](references/csh-guide.md) for the 12 CSH boundary questions in full.

### Stage 5 — Dynamic Hypothesis

**Goal**: Identify how key variables interact over time, using System Dynamics thinking to draft causal loop hypotheses.

1. From Stages 2-4, identify 4-8 key variables that change over time (e.g., trust, funding, workload, compliance pressure, adoption rate)
2. Draft 1-2 causal loop hypotheses:
   - **Reinforcing loops** (R): Variable A increases → Variable B increases → Variable A increases further (virtuous or vicious cycle)
   - **Balancing loops** (B): Variable A increases → Variable B increases → Variable A decreases (self-correcting)
3. Identify:
   - **Delays**: Where does it take time for an effect to materialize? (delays are the #1 source of policy resistance)
   - **Dominant loops**: Which loop is currently "winning"?
   - **Leverage points**: Where could a small intervention shift which loop dominates?

**Output artifact**: Verbal CLD (Causal Loop Diagram) description + variable list + leverage point candidates. See [references/dynamics-guide.md](references/dynamics-guide.md) for notation and examples.

### Stage 6 — Intervention Options & Risk Check

**Goal**: Generate actionable options, each tied to a different leverage point, with explicit assumptions and failure modes.

1. Based on all previous stages, generate 2-4 intervention options
2. For each option, fill out:

| Field | Content |
|-------|---------|
| **Option** | What to do |
| **Leverage point** | Which loop or variable it targets |
| **Key assumptions** | What must be true for this to work |
| **Short-term effect** | What happens in weeks/months |
| **Long-term effect** | What happens in years |
| **Who benefits** | Which roles gain |
| **Who resists** | Which roles may push back, and why |
| **Policy resistance risk** | What happens if this fails or backfires |
| **Who needs to act** | Which roles must be mobilized |

3. For each option, perform a pre-mortem: "It's one year later and this intervention failed. What went wrong?"

**Output artifact**: Intervention options table. See [references/templates.md](references/templates.md) for the full template.

## Interaction Principles

- **One stage at a time.** Resist the urge to rush. Each stage builds on the previous one.
- **Artifacts are boundary objects.** Format outputs (tables, structured lists) so users can copy-paste them into real documents for stakeholder workshops, strategy memos, or consulting deliverables.
- **Reflect, don't prescribe.** The protocol's job is to help users think more rigorously, not to tell them what to do. Present options and trade-offs; let the user decide.
- **Name the uncertainty.** When an inference is speculative (e.g., a stakeholder's likely incentive), say so explicitly. Use "likely", "hypothesized", or "needs validation" rather than stating assumptions as facts.
- **Respond in the user's language.** Match the language of the user's input.

## Reference Files

| File | When to Read |
|------|-------------|
| [references/ssm-guide.md](references/ssm-guide.md) | During Stage 3 — for CATWOE construction guidance and rich picture concepts |
| [references/csh-guide.md](references/csh-guide.md) | During Stage 4 — for the full 12 CSH boundary questions and IS/OUGHT analysis |
| [references/dynamics-guide.md](references/dynamics-guide.md) | During Stage 5 — for CLD notation, archetype patterns, and leverage point typology |
| [references/templates.md](references/templates.md) | Any stage — for copy-paste-ready output templates |

## Relationship to Other Skills

- **model-thinking**: Complements this skill. Model Thinking provides individual mental models; Systems Practice provides the structured process for applying them to multi-stakeholder situations. If the user's problem is messy, start here. If it's complex but well-bounded, model-thinking may suffice.
- **planning-with-files**: After completing the 6-stage protocol, users may want to turn interventions into implementation plans. Hand off to planning-with-files for that.
