# Multi-Model Combinations

Strategies and examples for combining mental models across domains to triangulate on complex problems.

## Contents
- [Combination Principles](#combination-principles)
- [Scenario 1: Product Launch Decision](#scenario-1-product-launch-decision)
- [Scenario 2: Organizational Dysfunction Diagnosis](#scenario-2-organizational-dysfunction-diagnosis)
- [Scenario 3: Personal Investment Strategy](#scenario-3-personal-investment-strategy)
- [Scenario 4: Hiring a Key Role](#scenario-4-hiring-a-key-role)
- [Scenario 5: Entering a New Market](#scenario-5-entering-a-new-market)
- [Cross-Domain Pairing Matrix](#cross-domain-pairing-matrix)
- [Combination Anti-Patterns](#combination-anti-patterns)
- [Combination Heuristics](#combination-heuristics)

---

## Combination Principles

### Why Combine Models?

Single models reveal one dimension. Combining 2-3 models from **different domains** creates depth:

- **Agreement across models** → High confidence in the conclusion
- **Disagreement across models** → Hidden complexity worth exploring before deciding
- **Blind spots revealed** → Each model's weakness is covered by another's strength

### Selection Heuristic

1. Pick a **primary model** that matches the core problem type
2. Add a **complementary model** from a different domain for a second angle
3. Add a **check model** to stress-test the conclusion (often Inversion or Base Rates)

---

## Scenario 1: Product Launch Decision

**Problem**: Should we launch a new SaaS product targeting SMBs this quarter?

| Model | Domain | Insight |
|-------|--------|---------|
| **Pre-Mortem** (decisions) | Primary | "It's 6 months later and launch failed. Why?" → Team identifies: no channel-market fit, underpriced, support overwhelmed |
| **Reinforcing Feedback Loops** (systems) | Complementary | Early adopters → reviews → more adopters. But also: early bugs → bad reviews → churn spiral. Which loop wins depends on launch quality |
| **Opportunity Cost** (decisions) | Check | Engineering on new product = not improving core product. Core product churn is 8%/month — could fixing that yield more revenue? |

**Synthesis**: Pre-Mortem reveals execution risks, systems thinking shows the launch is a race between positive and negative feedback loops, and opportunity cost questions whether launching is even the best use of resources right now. **Decision**: Delay launch by one quarter to fix core product churn first, then launch with higher quality to ensure the positive loop dominates.

---

## Scenario 2: Organizational Dysfunction Diagnosis

**Problem**: A team consistently misses deadlines despite adequate staffing.

| Model | Domain | Insight |
|-------|--------|---------|
| **Shifting the Burden** (systems) | Primary | Quick fixes (overtime, scope cuts) mask the real issue. Each crisis is "solved" without addressing root cause, making the team dependent on heroics |
| **Incentives** (economics) | Complementary | What gets rewarded? If shipping fast is rewarded but quality isn't, rational actors will cut corners. If estimates are punished, people pad them |
| **Hanlon's Razor** (decisions) | Check | Before blaming individuals, consider: are the processes set up to fail? Bad tooling, unclear specs, or unrealistic scoping may be the true cause |

**Synthesis**: Systems view shows a dependency on heroic fixes. Economic lens reveals misaligned incentives. Hanlon's Razor shifts blame from people to process. **Recommendation**: Restructure incentives to reward realistic estimation and process improvement, not just delivery speed.

---

## Scenario 3: Personal Investment Strategy

**Problem**: How should I allocate savings across assets given economic uncertainty?

| Model | Domain | Insight |
|-------|--------|---------|
| **Margin of Safety** (risk) | Primary | Never invest where a single wrong assumption wipes you out. Build buffers: emergency fund first, then diversify |
| **Barbell Strategy** (risk) | Complementary | 85-90% in extremely safe assets (bonds, cash) + 10-15% in high-upside bets (startups, crypto). Avoid the mushy middle |
| **Base Rates** (statistics) | Check | Historically, diversified index funds return ~7-10% annually. Most active strategies underperform this baseline. Am I likely to beat it? |

**Synthesis**: Margin of Safety demands buffers. Barbell gives a concrete structure. Base Rates ground the plan in reality — most people are best served by simple index investing plus a small speculative allocation. **Decision**: 6-month emergency fund → 85% index funds → 15% speculative bets with money you can lose entirely.

---

## Scenario 4: Hiring a Key Role

**Problem**: Choosing between two strong candidates for engineering lead.

| Model | Domain | Insight |
|-------|--------|---------|
| **Reversibility (Two-Way Door)** (decisions) | Primary | Hiring is a one-way door — difficult to undo. This warrants thorough analysis, not speed |
| **Second-Order Thinking** (decisions) | Complementary | Candidate A: strong technically → team relies on them → single point of failure. Candidate B: strong mentor → team grows → resilience. Second-order favors B |
| **Circle of Competence** (decisions) | Check | Am I qualified to evaluate deep technical skill? If not, bring in a technical evaluator. Assess candidates within my competence (leadership, culture fit) and delegate the rest |

**Synthesis**: One-way door nature demands rigor. Second-order analysis favors the candidate who builds team capability, not just personal output. Circle of Competence reminds us to get expert help for areas outside our judgment. **Decision**: Bring in a technical co-evaluator, weight mentorship and team-building ability heavily.

---

## Scenario 5: Entering a New Market

**Problem**: Should a mid-sized B2B SaaS company expand into Southeast Asian markets before competitors do?

| Model | Domain | Insight |
|-------|--------|---------|
| **Game Theory — First Mover** (strategy) | Primary | Few localized competitors in this vertical. First mover can lock in enterprise relationships and shape buyer expectations. But: first mover also bears localization and education costs |
| **Network Effects** (networks) | Complementary | Each successful deployment → reference customer → easier next sale. The network of references compounds. But network is geography-bounded — must build in-region presence |
| **Fat Tails** (risk) | Check | Regulatory shifts, currency risk, and political instability are fat-tailed. A single policy change could invalidate the entire investment. Size the bet so ruin is impossible |

**Synthesis**: Strategy says move first. Network effects say each win compounds. Risk analysis says size the bet carefully — don't bet the company. **Decision**: Enter with a local partnership (limits downside) targeting one country first, build reference customers, then expand.

---

## Cross-Domain Pairing Matrix

Common high-value model pairings for recurring problem types:

| Problem Type | Model A (Primary) | Model B (Complementary) | Model C (Check) |
|-------------|-------------------|------------------------|-----------------|
| Go/No-Go decision | Pre-Mortem | Opportunity Cost | Base Rates |
| System not working | Feedback Loops | Incentives | Leverage Points |
| Risk assessment | Fat Tails / Margin of Safety | Second-Order Thinking | Inversion |
| Competitive move | Game Theory | Network Effects | Circle of Competence |
| Resource allocation | Opportunity Cost | Explore/Exploit | Satisficing |
| Behavior change | Incentives | Commitment Devices | Hanlon's Razor |
| Long-term planning | Regret Minimization | Compounding | Map vs Territory |
| Negotiation | BATNA | Asymmetric Information | Reciprocity |
| Career decision | Regret Minimization | Explore/Exploit | Opportunity Cost |
| Technology selection | Two-Way vs One-Way Door | Path Dependence | Second-Order Thinking |
| Team/culture issues | Incentives | Fundamental Attribution Error | Shifting the Burden |
| Product pivot | Disruptive Innovation | Reinforcing Feedback Loops | Sunk Cost Fallacy |
| Crisis management | Inversion | Cascade Failures | Precautionary Principle |
| Learning/growth | T-Shaped Knowledge | Compounding Knowledge | Deliberate Practice |
| Persuasion | Framing Effects | Commitment and Consistency | Signaling |
| Scaling challenges | Limits to Growth | Dunbar's Number | Unintended Consequences |
| Partnership/M&A | Information Asymmetry | Repeated Games | Survivorship Bias |
| Innovation vs stability | Barbell Strategy | Red Queen Effect | Small Bets |
| Pricing strategy | Price Elasticity | Price Discrimination | Anchoring |
| Talent development | Zone of Proximal Development | Deliberate Practice | Principal-Agent Problem |

---

## Combination Anti-Patterns

Common mistakes when combining models — and how to fix them:

| Anti-Pattern | Problem | Fix |
|---|---|---|
| Three models from the same domain | Confirmation bias — no fresh perspective | Draw from at least 2 different domains |
| Stacking optimization models on irreversible decisions | Ignores path dependence; optimizes the wrong target | Apply a reversibility check first (Two-Way Door) |
| Pre-Mortem + Inversion used together | Both invert toward failure — redundant overlap | Use one; fill the third slot with a systems or statistical model |
| Base Rates without Selection Bias check | Wrong reference class makes rigorous-looking analysis misleading | Pair with Map vs Territory to validate the reference class |

---

## Combination Heuristics

When you spot these signals, reach for these models first:

| Signal | Start With | Then Add |
|---|---|---|
| Same fix keeps being applied but the problem keeps returning | Shifting the Burden | Incentives |
| Decision feels urgent AND irreversible | Two-Way Door (is it really?) | Pre-Mortem |
| Everyone agrees and no one dissents | Devil's Advocate | Falsifiability |
| Potential payoff is huge but fuzzy | Base Rates | Fat Tails |
| What used to work no longer does | Path Dependence | Second-Order Thinking |
| Must act fast or miss the window | Explore/Exploit | Opportunity Cost |
| The other party knows more than you do | Information Asymmetry | Signaling |
| Growing fast but everything is starting to break | Limits to Growth | Dunbar's Number |
