# Delivery & Operations Reference

Industrial UI/UX, system deployment, and knowledge engineering for water treatment AI systems.

## Table of Contents

1. [Industrial HMI & UI/UX Standards](#1-industrial-hmi--uiux-standards)
2. [XAI Visualization Patterns](#2-xai-visualization-patterns)
3. [Operator Workflow Design](#3-operator-workflow-design)
4. [Infrastructure as Code (IaC)](#4-infrastructure-as-code-iac)
5. [GitOps & Continuous Delivery](#5-gitops--continuous-delivery)
6. [Hybrid Cloud Architecture](#6-hybrid-cloud-architecture)
7. [Observability & SRE Practices](#7-observability--sre-practices)
8. [Knowledge Engineering](#8-knowledge-engineering)
9. [Documentation as Code](#9-documentation-as-code)

---

## 1. Industrial HMI & UI/UX Standards

### ISA-101 High-Performance HMI

ISA-101 (Human Machine Interfaces for Process Automation Systems) defines principles for effective operator interfaces. Key tenets:

| Principle | Implementation | Anti-Pattern |
|---|---|---|
| Grey/dark base palette | Background: neutral grey (#404040–#606060); equipment outlines in subtle tones | Bright colored backgrounds, gradient fills on vessels |
| Color = information | Reserve saturated colors exclusively for abnormal states and alarms | Color-coding normal process states (green pipes, blue tanks) |
| Analog indication | Bar graphs, trend sparklines, analog gauges for continuous variables | Numeric-only displays requiring mental comparison |
| Situational awareness | Level 1 overview → Level 2 unit area → Level 3 detail (Endsley model) | Flat screens with no navigation hierarchy |
| Consistent alarm colors | Red = critical, Yellow = high, Cyan/blue = advisory (per site standard) | Inconsistent color meanings across screens |

### ISA-18.2 Alarm Management

Alarm floods are the primary reason operators lose trust in automated systems. ISA-18.2 lifecycle:

```
Identification → Rationalization → Design → Implementation
  → Monitoring → Maintenance → Audit
```

**Key Metrics:**

| Metric | Target | Alarm Flood Indicator |
|---|---|---|
| Alarm rate (steady state) | ≤6 alarms / operator / hour | >12 alarms/hr sustained |
| Alarm rate (upset) | ≤12 alarms / operator / 10 min | >30 alarms/10 min |
| Standing alarms | <5 per operator | >10 persistent |
| Chattering alarms | 0% of configured alarms | Any alarm activating >5x in 1 min |
| Priority distribution | ~80% low, ~15% high, ~5% critical | Inverted pyramid (most alarms = critical) |

**Alarm Rationalization for AI Systems:**
- AI-generated alerts must pass through the same rationalization process as traditional alarms
- AI confidence scores should map to alarm priority (not generate new alert categories)
- Suppress AI alerts when the operator is already handling a related manual alarm
- Every AI alarm must have a defined response procedure — no "informational-only" alarms in the control room

### Color Palette Reference (ISA-101 Compliant)

| Element | Normal State | Abnormal / Alarm |
|---|---|---|
| Background | #4A4A4A (neutral grey) | — |
| Equipment outline | #808080 (mid grey) | — |
| Pipe (flowing) | #707070 (slightly lighter) | — |
| Pipe (stopped) | #505050 (darker) | — |
| High alarm | — | #FF0000 (red) |
| High-high alarm | — | #FF0000 (red, flashing) |
| Low alarm | — | #FFFF00 (yellow) |
| Advisory | — | #00BFFF (cyan) |
| Setpoint deviation | — | #FFA500 (orange) |
| AI recommendation | — | #00CED1 (teal, distinct from alarms) |

---

## 2. XAI Visualization Patterns

### SHAP/LIME to Operator Language

AI feature importance must be translated from data science format to operator-actionable format:

**Data Science Output:**
```
SHAP values: NH4_influent=+0.42, rainfall_forecast=+0.31, pH=-0.15, ...
```

**Operator Display:**
```
┌─────────────────────────────────────────────────┐
│ AI 建議：增加 PAC 加藥量至 35 mg/L              │
│                                                  │
│ 主要原因：                                       │
│ ██████████████░░░  進流氨氮上升 (42%)            │
│ ██████████░░░░░░░  暴雨預警 — 預期稀釋 (31%)     │
│ █████░░░░░░░░░░░░  pH 偏低 (15%)                │
│                                                  │
│ 信心水準：●●●●○ 高 (87%)                         │
│ 歷史相似情境：3 次 / 近 6 個月，建議採納率 100%   │
└─────────────────────────────────────────────────┘
```

### Visualization Principles

| Principle | Rationale |
|---|---|
| Horizontal bar charts for feature importance | Instantly scannable; no legend needed |
| Natural language reason labels (not variable names) | "進流氨氮上升" not "NH4_influent" |
| Confidence indicator (dot scale or gauge) | Operators calibrate trust to AI certainty |
| Historical track record | "AI was right 3/3 times in similar conditions" builds trust |
| Single recommended action (not options) | Operators need a decision, not a decision tree |
| Override button always visible | Trust requires control — operator is always final authority |

### Trend + Prediction Overlay

For time-series predictions, overlay historical actual vs. AI prediction with confidence band:

```
Value
  │      ╭─actual──╮
  │  ───╯          ╰──╮    ╭── AI prediction (solid)
  │                    ╰──╯
  │                        ╱ ── confidence band (shaded)
  │                      ╱
  ├──────────────┼──────────→ Time
              NOW
```

- Solid line = historical actual
- Dashed/colored line = AI prediction
- Shaded band = 90% confidence interval
- Vertical "NOW" marker clearly separates past from forecast

---

## 3. Operator Workflow Design

### User Journey: Alert → Resolution

```
1. DETECT (0-5 sec)
   │ Alarm triggers → notification (visual + audible)
   │ Screen: Overview dashboard highlights affected unit
   │
2. ASSESS (5-30 sec)
   │ Operator clicks affected unit → detail view
   │ AI shows: what happened, why, severity, recommended action
   │ Critical: ≤3 clicks from alarm to action screen
   │
3. DECIDE (30-120 sec)
   │ Operator reviews AI recommendation + supporting evidence
   │ Options: Accept AI suggestion │ Modify │ Override │ Escalate
   │
4. ACT (immediate)
   │ One-click to execute accepted action
   │ System confirms action taken + expected response time
   │
5. VERIFY (minutes to hours)
   │ Trend display shows process response to action
   │ AI confirms "responding as expected" or flags if not
   │
6. CLOSE (when stable)
   │ Operator acknowledges resolution
   │ System logs full timeline for audit and learning
```

### Click-Count Budget

| Scenario | Maximum Clicks | Rationale |
|---|---|---|
| Acknowledge alarm | 1 | ISA-18.2 requirement |
| View AI explanation | 2 (alarm → detail) | Assessment must be fast |
| Execute recommended action | 3 (alarm → detail → confirm) | Emergency response window |
| Override AI recommendation | 3 | Must be equally accessible as acceptance |
| View historical context | 3 | Supports experienced operator judgment |

### Shift Handover Dashboard

Design a dedicated handover screen showing:
- Active alarms and open work orders
- AI predictions for next 4-8 hours (trend + confidence)
- Actions taken during current shift (with outcomes)
- Items requiring attention from incoming shift

---

## 4. Infrastructure as Code (IaC)

### Terraform Pattern for Water Treatment Edge Deployment

```
Environment Structure:
├── modules/
│   ├── edge-node/        # K3s cluster, GPU allocation, model runtime
│   ├── data-pipeline/    # MQTT broker, time-series DB, ETL
│   ├── monitoring/       # Prometheus, Grafana, alerting
│   └── networking/       # VPN, firewall rules, OT/IT segmentation
├── environments/
│   ├── fab-a/            # Site-specific variables
│   ├── fab-b/            # Same modules, different parameters
│   └── staging/          # Pre-production validation
└── shared/
    └── state/            # Remote state backend (S3/Azure Blob)
```

### Key IaC Principles for Water Systems

| Principle | Implementation | Why It Matters |
|---|---|---|
| Reproducibility | Same Terraform modules deploy to any site | Fab A and Fab B get identical environments |
| Immutable infrastructure | Replace, don't patch — new container image for updates | Eliminates configuration drift over 10+ year lifecycle |
| State management | Remote state with locking (S3 + DynamoDB) | Multi-team coordination without conflicts |
| Secret management | HashiCorp Vault or cloud KMS — never in code | OT credentials require strict access control |
| Network segmentation | Terraform manages firewall rules per IEC 62443 zones | Security policy as code, auditable |

### Ansible for OT-Specific Configuration

Terraform manages infrastructure; Ansible handles configuration of OT-adjacent systems:
- PLC communication gateway setup
- OPC UA server certificate deployment
- Edge node OS hardening (CIS benchmarks)
- Time synchronization (NTP/PTP) critical for water treatment data correlation

---

## 5. GitOps & Continuous Delivery

### ArgoCD + Kubernetes Workflow

```
Developer / Data Scientist
  │
  ├── Code change or model update
  │     → Git push to feature branch
  │       → CI pipeline (build, test, scan)
  │         → Merge to main
  │           → ArgoCD detects change
  │             → Sync to cluster
  │
  │   Deployment Strategy:
  │   ┌─────────────────────────────────────────┐
  │   │ Stage 1: Canary (5% traffic)            │
  │   │   → Non-critical loop (e.g., monitoring │
  │   │     dashboard, advisory alerts)         │
  │   │   → Validate: prediction accuracy,      │
  │   │     latency, error rate                 │
  │   │   → Duration: 2-4 hours minimum         │
  │   │                                         │
  │   │ Stage 2: Progressive rollout (25→50→100)│
  │   │   → Expand to more control loops        │
  │   │   → Automatic rollback on SLO violation │
  │   │                                         │
  │   │ Stage 3: Full deployment                │
  │   │   → All loops, all sites                │
  │   └─────────────────────────────────────────┘
```

### AI Model Update Pipeline

| Stage | Gate Criteria | Rollback Trigger |
|---|---|---|
| Model training (cloud) | Validation loss < threshold; no data drift | — |
| Shadow mode (edge) | Predictions compared to actual; MAE within bounds | MAE > 2× baseline |
| Canary (5% advisory) | Operator feedback; no false alarm increase | False alarm rate > 1.5× |
| Progressive rollout | SLO compliance across all metrics | Any SLO violation |
| Full deployment | 24h stable operation | — |

### Zero-Downtime Deployment for 24/7 Water Systems

- Blue-green deployments for stateless services (API, dashboard)
- Rolling updates for stateful services (time-series DB) with readiness probes
- Database migrations: expand-contract pattern (never breaking changes)
- Rollback strategy: keep previous model version warm for instant failback

---

## 6. Hybrid Cloud Architecture

### Train in Cloud, Infer at Edge

```
┌─ Cloud (AWS/Azure/GCP) ──────────────────────┐
│                                                │
│  ┌──────────┐  ┌──────────┐  ┌──────────────┐│
│  │ Data Lake │→│ Training  │→│ Model        ││
│  │ (anonymized│ │ Pipeline  │  │ Registry     ││
│  │  /aggregated)│(GPU/TPU) │  │ (versioned)  ││
│  └──────────┘  └──────────┘  └──────┬───────┘│
│                                      │        │
└──────────────────────────────────────┼────────┘
                                       │ Secure model pull
                                       │ (signed artifacts)
┌─ Plant Edge ─────────────────────────┼────────┐
│                                      ↓        │
│  ┌──────────────┐  ┌──────────┐  ┌────────┐  │
│  │ MQTT/OPC UA  │→│ Inference │→│ Control │  │
│  │ (real-time   │  │ Engine   │  │ System  │  │
│  │  sensor data)│  │ (K3s/Wasm)│ │ (PLC)  │  │
│  └──────────────┘  └──────────┘  └────────┘  │
│                                               │
│  Data stays on-site (數據不出廠)               │
│  Only anonymized/aggregated data sent to cloud │
└───────────────────────────────────────────────┘
```

### Data Sovereignty Patterns

| Pattern | What Leaves Plant | What Stays | Use Case |
|---|---|---|---|
| Federated Learning | Model gradients only | Raw sensor data | Multi-site model improvement |
| Aggregated Telemetry | Daily/hourly summaries | Sub-second data | Cloud dashboarding, benchmarking |
| Edge-Only | Nothing | Everything | Maximum security (military, critical infra) |
| Anonymized Sync | De-identified datasets | PII, site identifiers | Cross-plant analytics |

### Edge Hardware Sizing Guide

| Workload | CPU | RAM | GPU | Storage | Example |
|---|---|---|---|---|---|
| Rule-based + simple ML | 4 cores | 8 GB | None | 128 GB SSD | NVIDIA Jetson Nano |
| Time-series forecasting | 8 cores | 16 GB | Optional | 256 GB SSD | Intel NUC / Jetson Xavier NX |
| Vision (camera-based monitoring) | 8+ cores | 32 GB | Required (4+ GB VRAM) | 512 GB SSD | Jetson AGX Orin |
| Full LLM inference (RAG) | 16+ cores | 64 GB | Required (16+ GB VRAM) | 1 TB NVMe | Industrial GPU server |

---

## 7. Observability & SRE Practices

### Three Pillars for Water Treatment AI

| Pillar | Tool Stack | What to Monitor |
|---|---|---|
| Metrics | Prometheus → Grafana | Model latency, prediction accuracy, sensor health, pipeline lag |
| Logs | Loki / ELK | Inference errors, data quality issues, operator actions, audit trail |
| Traces | Jaeger / Tempo | End-to-end request flow: sensor → ingestion → inference → display |

### SLO Definitions for Water AI Systems

| Service | SLI | SLO | Error Budget |
|---|---|---|---|
| Real-time inference | Latency p99 | <500 ms | 0.1% requests >500 ms/month |
| Prediction availability | Uptime | 99.9% | 43 min downtime/month |
| Data pipeline freshness | Lag from sensor to DB | <5 sec | 99th percentile <10 sec |
| Dashboard availability | Page load time | <3 sec (p95) | 99.5% uptime |
| Model accuracy | MAE vs. actual | Within ±10% of baseline | Retrain trigger if exceeded 3 consecutive days |

### Incident Response Levels

| Level | Trigger | Response | Escalation |
|---|---|---|---|
| L1 — Degraded | Single metric SLO violation | Auto-alert on-call; investigate | 30 min to L2 |
| L2 — Impaired | Multiple SLO violations or model rollback triggered | Active incident; war room | 1 hr to L3 |
| L3 — Critical | AI system offline or providing incorrect control outputs | Fallback to manual operation; all hands | Immediate to plant management |

---

## 8. Knowledge Engineering

### Graph RAG Architecture for Plant Knowledge

```
Source Documents                    Knowledge Graph              AI Agent
┌──────────────┐                  ┌──────────────┐            ┌──────────┐
│ Maintenance   │                 │ Equipment    │            │          │
│ logs          │──extract──→     │ nodes        │            │ "上次3號 │
│               │                 │   ↕          │──query──→  │  泵浦軸承│
│ SOPs          │──extract──→     │ Failure      │            │  過熱怎麼│
│               │                 │ patterns     │  ←─answer──│  解決的？"│
│ Equipment     │──extract──→     │   ↕          │            │          │
│ manuals       │                 │ Solutions    │            └──────────┘
│               │                 │   ↕          │
│ Operator      │──extract──→     │ Operating    │
│ shift notes   │                 │ conditions   │
└──────────────┘                  └──────────────┘
                                    Neo4j /
                                    Property Graph
```

### Knowledge Graph Schema for Water Treatment

| Node Type | Properties | Relationships |
|---|---|---|
| Equipment | ID, type, manufacturer, install date, location | HAS_COMPONENT, CONNECTED_TO |
| Failure Event | date, symptom, root cause, severity | OCCURRED_ON (equipment), RESOLVED_BY |
| Solution | action taken, parts used, duration, outcome | APPLIED_TO (failure), PERFORMED_BY |
| SOP | ID, version, applicable equipment, steps | GOVERNS (equipment), REFERENCES (solution) |
| Operating Condition | parameter ranges, process context | PRECEDED (failure), ASSOCIATED_WITH |

### Entity Extraction Pipeline

1. **Ingest**: OCR scanned documents; parse structured logs (CSV, JSON)
2. **Extract**: NER for equipment IDs, failure modes, chemical names, parameter values
3. **Link**: Entity resolution (same pump may appear as "P-301", "3號泵浦", "RO feed pump")
4. **Validate**: Subject matter expert review of extracted relationships
5. **Update**: Continuous ingestion from new maintenance records and shift logs

---

## 9. Documentation as Code

### Repository Structure

```
project-root/
├── docs/                        # MkDocs source
│   ├── architecture/
│   │   ├── system-overview.md   # Mermaid diagrams
│   │   ├── data-flow.md
│   │   └── decisions/           # ADRs (Architecture Decision Records)
│   │       ├── 001-edge-inference.md
│   │       ├── 002-timeseries-db.md
│   │       └── template.md
│   ├── operations/
│   │   ├── runbooks/            # Incident response procedures
│   │   ├── deployment.md
│   │   └── monitoring.md
│   ├── api/                     # Auto-generated from OpenAPI spec
│   └── user-guide/              # Operator-facing documentation
├── mkdocs.yml                   # Site configuration
└── .github/workflows/
    └── docs.yml                 # CI: build + deploy docs on merge
```

### Architecture Decision Record (ADR) Template

```markdown
# ADR-NNN: [Title]

## Status: [Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Context
What is the issue that we're seeing that is motivating this decision?

## Decision
What is the change that we're proposing and/or doing?

## Consequences
What becomes easier or more difficult to do because of this change?

## Alternatives Considered
What other approaches were evaluated and why were they rejected?
```

### Mermaid Diagram Standards

Use Mermaid.js for diagrams that live alongside code:

- **System architecture**: C4 model (Context → Container → Component)
- **Data flow**: flowchart LR for pipeline diagrams
- **Sequence**: sequenceDiagram for API interactions and control flows
- **State machines**: stateDiagram-v2 for equipment and process states

All diagrams render automatically in MkDocs, GitHub, and most modern documentation platforms.

### Documentation Lifecycle

| Event | Documentation Action |
|---|---|
| New feature / system change | Update architecture docs + ADR if architectural |
| Incident | Post-mortem → update runbook → update knowledge graph |
| Model retrain | Update model card (metrics, training data, limitations) |
| Staff onboarding | Review and refresh user guides |
| Annual review | Audit all docs for accuracy; archive obsolete content |

## Related References

- [ai-and-control.md](ai-and-control.md) — Model deployment patterns, edge inference, AI agent architecture
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — OT network security (IaC for IEC 62443 zones), security architecture documentation
- [troubleshooting.md](troubleshooting.md) — Diagnostic knowledge for knowledge graph construction and runbook content
