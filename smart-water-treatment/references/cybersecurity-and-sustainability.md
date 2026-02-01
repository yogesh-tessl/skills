# Cybersecurity & Sustainability Reference

## Table of Contents

1. [IEC 62443 Industrial Cybersecurity](#iec-62443-industrial-cybersecurity)
2. [SEMI E187 Semiconductor Fab Security](#semi-e187-semiconductor-fab-security)
3. [Zero Trust for Water Infrastructure](#zero-trust-for-water-infrastructure)
4. [AI Agent Identity & Access](#ai-agent-identity--access)
5. [OT Network Architecture](#ot-network-architecture)
6. [MLOps & Software Architecture](#mlops--software-architecture)
7. [ESG & Carbon Accounting](#esg--carbon-accounting)
8. [Water Footprint & LCA](#water-footprint--lca)
9. [Regulatory Compliance Automation](#regulatory-compliance-automation)

## IEC 62443 Industrial Cybersecurity

### Security Levels (SL)

| Level | Description | Example Application |
|-------|------------|-------------------|
| SL 1 | Prevent casual/unintentional violation | Small municipal plant, low risk |
| SL 2 | Prevent intentional violation with simple means | Standard industrial, most WWTPs |
| SL 3 | Prevent intentional violation with sophisticated means | Critical infrastructure, large utilities |
| SL 4 | Prevent state-sponsored attack | National security-related water systems |

### Zone and Conduit Model

```
┌──────────────────────────────────────────────────┐
│  Enterprise Zone (IT)                             │
│  ERP, email, business apps                        │
├──────── DMZ (data diode / firewall) ─────────────┤
│  Operations Zone (Level 3)                        │
│  Historian, HMI server, engineering workstation   │
├──────── Firewall (ICS-specific rules) ───────────┤
│  Control Zone (Level 2)                           │
│  SCADA server, OPC UA server, MPC controller      │
├──────── Unidirectional gateway ──────────────────┤
│  Field Zone (Level 0-1)                           │
│  PLCs, RTUs, sensors, actuators                   │
└──────────────────────────────────────────────────┘
```

### Key Requirements for Water Systems

- Network segmentation between IT and OT (mandatory)
- Patch management program for PLCs and HMIs (risk-based, test before deploy)
- Account management: no shared credentials, MFA for remote access
- Backup and recovery: tested restoration procedure for PLC programs and SCADA configs
- Incident response plan specific to OT environments
- Annual security assessment and penetration testing

## SEMI E187 Semiconductor Fab Security

### Scope

Applies to fab equipment including water treatment subsystems (UPW, WWT, chemical delivery).

### Key Requirements

- **OS hardening**: Remove unnecessary services, disable USB ports, whitelist applications
- **Network security**: Equipment must support network segmentation; no default passwords
- **Malware protection**: Application whitelisting preferred over antivirus (performance)
- **Access control**: Role-based access, audit logging for all configuration changes
- **Vulnerability management**: Equipment suppliers must provide security patches within defined SLA

### Impact on Water Systems in Fabs

- UPW and WWT control systems must comply as fab sub-equipment
- SCADA/HMI for water systems must meet same hardening standards as process tools
- Network traffic from water systems to fab network must be filtered and monitored
- Remote access for water system vendors requires jump server + MFA + session recording

## Zero Trust for Water Infrastructure

### Principles Applied to OT

| Principle | Implementation |
|-----------|---------------|
| Never trust, always verify | Every device/user/agent authenticates per session |
| Least privilege | PLC access limited to specific tags needed for function |
| Assume breach | Monitor all east-west traffic within OT network |
| Micro-segmentation | Separate networks per process unit (UPW, WWT, cooling) |
| Continuous verification | Re-authenticate on context change (location, time, behavior) |

### Architecture Components

- **Identity provider**: Active Directory + RADIUS/TACACS+ for OT devices
- **Network access control**: 802.1X for wired; WPA3-Enterprise for wireless
- **Software-defined perimeter**: Overlay network for OT micro-segmentation
- **Data diodes**: Unidirectional gateways at critical OT-to-IT boundaries
- **SIEM/SOAR**: Centralized logging with OT-specific detection rules

## AI Agent Identity & Access

### SPIFFE/SPIRE Framework

- Every AI agent workload receives a SPIFFE ID (e.g., `spiffe://water-plant/agent/optimizer`)
- Short-lived X.509 certificates (SVIDs) rotated automatically
- No static API keys or long-lived tokens for agent-to-system communication

### Authorization Model

```
Agent → Request → Policy Engine (OPA/Cedar) → Allow/Deny
                      ↓
         Context: agent identity, time, process state, safety mode
```

| Agent Role | Read Data | Write Setpoint | Emergency Stop | Direct Actuator |
|-----------|-----------|---------------|---------------|----------------|
| Monitor | Yes | No | No | No |
| Advisor | Yes | Propose only | No | No |
| Optimizer | Yes | Within bounds | No | No |
| Controller | Yes | Yes (bounded) | Trigger only | No |
| Emergency | Yes | Override to safe | Yes | Via PLC safety |

### Audit Requirements

- All agent actions logged with: timestamp, agent ID, action, target, old value, new value, justification
- Anomaly detection on agent behavior: unexpected setpoint changes, unusual query patterns
- Human review required for any authorization level escalation

## OT Network Architecture

### Protocol Stack for Water Systems

| Layer | Protocol | Use Case | Security |
|-------|----------|----------|----------|
| Field | Modbus RTU (serial) | Legacy PLCs, simple sensors | None (isolate physically) |
| Field | Modbus TCP | Standard PLC communication | TLS wrapper or VPN |
| Control | OPC UA | Structured data, pub/sub, security built-in | X.509 certificates, encryption |
| Integration | MQTT Sparkplug B | Edge-to-cloud, UNS architecture | TLS, RBAC on topics |
| Enterprise | REST/gRPC | Application APIs, dashboards | OAuth 2.0, mTLS |

### Unified Namespace (UNS)

Topic structure for water treatment:

```
plant/
├── intake/
│   ├── flow_rate
│   ├── turbidity
│   └── pH
├── pretreatment/
│   ├── coagulant_dose
│   └── settled_turbidity
├── ro_system/
│   ├── train_1/
│   │   ├── feed_pressure
│   │   ├── permeate_conductivity
│   │   └── normalized_flux
│   └── train_2/...
├── distribution/
│   ├── residual_chlorine
│   └── pressure
└── ai/
    ├── predictions/
    ├── alerts/
    └── setpoint_recommendations/
```

## MLOps & Software Architecture

### ML Pipeline

```
Data Ingestion → Feature Store → Training → Validation → Registry → Deployment → Monitoring
     ↑                                                                              │
     └──────────────────── Retraining Trigger ←─────────────────────────────────────┘
```

### Key Components

| Component | Recommended Tools | Purpose |
|-----------|------------------|---------|
| Feature store | Feast, Tecton | Consistent features across training and serving |
| Experiment tracking | MLflow, Weights & Biases | Hyperparameter tracking, model comparison |
| Model registry | MLflow Registry, Vertex AI | Versioning, approval workflow, lineage |
| Serving | Seldon, KServe, ONNX Runtime | Model API, A/B testing, canary deployment |
| Monitoring | Evidently, NannyML | Drift detection, performance tracking |
| Orchestration | Airflow, Prefect, Dagster | Pipeline scheduling, dependency management |

### Drift Detection

| Drift Type | Detection | Action |
|-----------|-----------|--------|
| Data drift (input distribution shift) | PSI > 0.2 or KS test p < 0.05 | Investigate source, consider retraining |
| Concept drift (input-output relationship shift) | Error rate increase, ADWIN | Retrain with recent data |
| Model staleness | Calendar-based (>30 days) | Scheduled retraining |
| Prediction anomaly | Output outside expected range | Alert, fallback to physics model |

### Time-Series Database Selection

| Database | Strengths | Best For |
|----------|----------|---------|
| InfluxDB | Purpose-built TSDB, Flux query language | Sensor data, monitoring |
| TimescaleDB | PostgreSQL extension, SQL compatible | When SQL ecosystem needed |
| QuestDB | High ingestion throughput, SQL | Very high-frequency data |
| Apache IoTDB | Designed for IoT, lightweight | Edge/resource-constrained |

## ESG & Carbon Accounting

### Scope Definitions for Water Treatment

| Scope | Sources | Example |
|-------|---------|---------|
| Scope 1 | Direct emissions from owned operations | Biogas combustion, generator fuel, CH₄/N₂O from treatment |
| Scope 2 | Purchased electricity and heat | Electricity for pumps, blowers, UV, ozone generators |
| Scope 3 | Value chain emissions | Chemical production and transport, sludge disposal, construction |

### Carbon Emission Factors (Water Treatment)

| Source | Emission Factor | Notes |
|--------|----------------|-------|
| Electricity (grid average) | 0.3-0.8 kg CO₂e/kWh | Region dependent |
| Aeration energy | 0.2-0.4 kWh/m³ treated | Largest energy consumer in WWTP |
| N₂O from nitrification | 0.005-0.035 kg N₂O-N/kg TN | GWP = 298× CO₂; highly variable |
| CH₄ from anaerobic zones | 0.001-0.02 kg CH₄/m³ | GWP = 25× CO₂ |
| Chemical (FeCl₃) | ~0.3 kg CO₂e/kg FeCl₃ | Includes production and transport |
| Chemical (NaOH 50%) | ~1.0 kg CO₂e/kg NaOH | Energy-intensive production |
| Chemical (polymer) | ~2.5 kg CO₂e/kg polymer | Petroleum-derived |
| Sludge transport | ~0.1 kg CO₂e/tonne-km | Truck transport |
| Biogas credit | -0.2 kg CO₂e/kWh generated | Offsets Scope 2 |

### Automated Carbon Calculation

```
Total CO₂e = Σ(energy × grid_factor) + Σ(chemical × chemical_factor)
           + Σ(process_emissions) + Σ(transport) - Σ(energy_recovery_credits)
```

Automate by connecting to:
- SCADA (energy meters, flow meters, chemical feed rates)
- Chemical inventory system (delivery quantities)
- Grid carbon intensity API (real-time or monthly average)
- Sludge hauling records (weight, distance)

## Water Footprint & LCA

### Water Footprint Components (ISO 14046)

| Component | Definition | Application |
|-----------|-----------|-------------|
| Blue water | Consumption of surface/groundwater | Makeup water, evaporative losses |
| Green water | Consumption of rainwater (soil moisture) | Relevant for agriculture reuse |
| Grey water | Volume needed to dilute pollutants to standards | Discharge impact quantification |

### LCA Methodology for Water Systems (ISO 14040/44)

**Functional unit**: 1 m³ of treated water meeting specified quality

**System boundary**: Include raw water abstraction, treatment, distribution, collection, wastewater treatment, discharge/reuse

**Impact categories**:
- Climate change (kg CO₂e)
- Eutrophication (kg PO₄e or kg Ne)
- Acidification (kg SO₂e)
- Freshwater ecotoxicity
- Human toxicity
- Resource depletion (water, energy, materials)

### Decision Support

When comparing treatment alternatives, present LCA results as:

```
| Option | CAPEX | OPEX/yr | kgCO₂e/m³ | kWh/m³ | Chemical kg/m³ | Water Recovery |
```

Include sensitivity analysis on key assumptions (energy price, grid carbon intensity, chemical costs).

## Regulatory Compliance Automation

### Compliance Monitoring Pipeline

```
Sensor Data → Real-time Limit Check → Alert (if approaching limit)
                                    → Violation Report (if exceeded)
                                    → Regulatory Report Generation (scheduled)
```

### Key Frameworks

| Framework | Scope | Automation Opportunity |
|-----------|-------|----------------------|
| ISO 14001 | Environmental management system | Auto-generate nonconformance reports, track corrective actions |
| ISO 50001 | Energy management | Real-time energy KPI dashboards, automatic EnPI calculation |
| EU CSRD/ESRS | Corporate sustainability reporting | Automated data collection for E1-E5 water/pollution disclosures |
| EPA NPDES | US discharge permits | Automated DMR (Discharge Monitoring Report) preparation |
| Taiwan EPA | Effluent standards | Real-time compliance dashboard, automated monthly reports |
| SEMI S23 | Conservation of energy, utilities, materials | Track UPW consumption per wafer, benchmark against targets |

### Blockchain for ESG Attestation

- Immutable timestamped records of: emissions data, water quality results, chemical usage
- Smart contracts for automatic compliance verification
- Audit trail: from sensor reading → data pipeline → reported value (full lineage)
- Technologies: Hyperledger Fabric (permissioned), Ethereum L2 (public attestation)

---

## Related References

- [ai-and-control.md](ai-and-control.md) — AI agent architectures secured by SPIFFE/SPIRE, edge deployment patterns, model validation
- [delivery-and-ops.md](delivery-and-ops.md) — GitOps deployment pipelines, IaC for network segmentation, observability/SRE practices
- [desalination.md](desalination.md) — Energy/cost benchmarking and carbon footprint data for desalination
- [reuse.md](reuse.md) — Energy and carbon footprint comparison across water sources
- [semiconductor.md](semiconductor.md) — SEMI E187 context: fab equipment security requirements for water subsystems
- [industrial.md](industrial.md) — Industrial water systems requiring ESG carbon accounting
