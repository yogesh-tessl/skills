# AI, Control Systems & Digital Twins Reference

## Table of Contents

1. [Physics-Informed Neural Networks (PINNs)](#physics-informed-neural-networks-pinns)
2. [Time-Series Foundation Models](#time-series-foundation-models)
3. [Graph Neural Networks for Water Networks](#graph-neural-networks-for-water-networks)
4. [Virtual Metrology](#virtual-metrology)
5. [Control Architecture Patterns](#control-architecture-patterns)
6. [Edge Deployment](#edge-deployment)
7. [Digital Twin Integration](#digital-twin-integration)
8. [Agentic AI for Water Operations](#agentic-ai-for-water-operations)
9. [Model Validation & Monitoring](#model-validation--monitoring)

## Physics-Informed Neural Networks (PINNs)

### Core Concept

Embed governing PDEs directly into the neural network loss function:

```
L_total = L_data + λ_physics * L_PDE + λ_BC * L_boundary + λ_IC * L_initial
```

Where `L_PDE` penalizes violations of the governing equation (e.g., advection-diffusion, reaction kinetics).

### Water Treatment Applications

| Application | Governing Equation | Benefit |
|------------|-------------------|---------|
| Clarifier settling | Kynch sedimentation theory | Predict sludge blanket with sparse data |
| RO membrane transport | Solution-diffusion model | Predict flux/rejection under novel conditions |
| Bioreactor kinetics | Monod + mass balance ODEs | Extrapolate beyond training data range |
| Pipe network hydraulics | Darcy-Weisbach + continuity | Real-time pressure/flow estimation |
| Chemical dosing | Reaction rate equations | Optimize dosing with minimal lab data |
| Contaminant transport | Advection-dispersion equation | Predict plume migration in groundwater |

### Implementation Guidelines

- Start with well-established PDEs; use PINNs to learn unknown parameters (e.g., reaction rate constants)
- Use automatic differentiation (PyTorch/JAX) for computing PDE residuals
- Balance data loss vs. physics loss with adaptive weighting (e.g., learning rate annealing, NTK-based)
- Validate: model must satisfy known analytical solutions before deploying on real data
- Data-scarce regime (< 100 labeled points): PINNs significantly outperform pure data-driven models

### Neural Operators

| Architecture | Use Case | Advantage |
|-------------|----------|-----------|
| DeepONet | Operator learning (input function → output function) | Flexible input/output mapping |
| FNO (Fourier Neural Operator) | Turbulent flow, mixing simulation | Spectral efficiency for periodic domains |
| U-Net variants | Spatial field prediction (concentration maps) | Good for image-like sensor grids |

## Time-Series Foundation Models

### Model Comparison for Water Treatment

| Model | Architecture | Params | Context Length | Strengths | Limitations |
|-------|-------------|--------|---------------|-----------|-------------|
| **TTM** (Tiny Time Mixers) | MLP-Mixer | 1-5M | 512-1024 | 8-709x smaller than Chronos, outperforms by 17-32%; ideal for edge/OT deployment | Newer ecosystem, fewer integrations |
| PatchTST | Patched Transformer | ~1M | 512-1024 | Channel-independent, efficient; strong with sufficient data (≥80% training) | Single-scale patches |
| **TFT** (Temporal Fusion Transformer) | Multi-horizon attention + variable selection | ~5-10M | Variable | Interpretable attention weights & variable importance; R² > 0.98 for RO membrane prediction | Slower training, complex architecture |
| MOIRAI | Masked encoder | ~300M | Variable | Zero-shot transfer, any-variate | Requires large pretraining corpus |
| TimesFM | Decoder-only | ~200M | 512 | Google-scale pretraining, zero-shot | Limited fine-tuning flexibility |
| Chronos | T5-based tokenization | ~20-710M | 512 | Probabilistic, pre-trained; validated for N forecasting under data scarcity | Univariate focus, large for edge |
| **Lag-Llama** | Decoder-only, lag covariates | ~1-5M | Variable | Probabilistic, lag-based features (similar to ARIMA intuition); uncertainty quantification | Newer, limited water domain evidence |
| **N-HiTS** | Hierarchical interpolation | ~1-5M | Long | Multi-scale decomposition, interpretable; used in wastewater CSO research | Less community adoption than PatchTST |
| TiDE | MLP-based | ~1M | Long | Fast inference, long horizon | Less expressive than Transformers |
| Traditional LSTM | Recurrent | ~100K | 50-200 | Simple, well-understood | Vanishing gradients, short memory |

### Recommended Selection

- **Quick baseline**: LSTM or TiDE — fast to train, reasonable accuracy
- **Production forecasting**: PatchTST with domain fine-tuning — best accuracy/speed trade-off when data is sufficient
- **Zero-shot / new plant / data-scarce**: Chronos fine-tuned — outperforms benchmarks with <60% training data; MOIRAI or TimesFM for zero-shot
- **Edge / OT deployment**: TTM — 1-5M params fits on industrial PCs; 8-709x smaller than Chronos with comparable or better accuracy
- **Interpretability required**: TFT — attention weights and variable importance scores help operators understand predictions
- **Uncertainty quantification**: Chronos or Lag-Llama — native probabilistic outputs for risk-aware decision making
- **Anomaly detection**: Reconstruction-based (autoencoder) or forecasting residual analysis

### Water Treatment Validation Evidence

| Model | Application | Key Finding | Source |
|-------|------------|-------------|--------|
| Chronos (fine-tuned) | Nitrogen forecasting in WWTP | Outperforms baselines under data scarcity (<60% training data); PatchTST/LSTM win with ≥80% data | ScienceDirect 2025 |
| TFT | RO membrane differential pressure | R² > 0.9813, beating LSTM (R² > 0.9364); interpretable variable importance | ScienceDirect Jan 2025 |
| TST + TFT | Multi-stage water quality monitoring | Combined transformer approach for sequential treatment stages | Nature Scientific Reports 2025 |
| TTM | General time-series benchmarks | 17-32% improvement over Chronos at 1/8-1/709 model size (NeurIPS 2024) | IBM Research / NeurIPS 2024 |

**Key insight**: Foundation models provide the most value in data-scarce scenarios (new plants, new sensors, limited historical data). When abundant site-specific data is available, fine-tuned PatchTST or TFT often outperform larger foundation models.

### Feature Engineering for Water Systems

Critical lagged features:
- Flow rate: 1h, 6h, 24h rolling stats
- pH, turbidity, conductivity: 15min, 1h, 4h windows
- Temperature: 24h sinusoidal encoding for diurnal patterns
- Chemical dosing: cumulative dose over HRT window
- Seasonal: day-of-year encoding for source water variation
- Graph features (for GNN-based models): adjacency matrix, node degree, pipe diameter/age/material, hydraulic distance

## Graph Neural Networks for Water Networks

Water distribution and collection networks are inherently graph-structured — nodes (junctions, tanks, reservoirs) connected by edges (pipes, pumps, valves). GNNs exploit this topology directly.

### Applications

| Application | Architecture | Performance | Source |
|------------|-------------|-------------|--------|
| Leak detection | GCN / GAT on pressure signals | 90-99% accuracy | MDPI, EUSIPCO 2025 |
| Sensor placement optimization | GNN + topology-aware clustering | Optimal coverage with minimal sensors | Various 2024-2025 |
| Explainable leak localization | Fuzzy GNN | F1 0.889 detection, 0.814 localization | 2025 |
| Contaminant source identification | Message-passing GNN | Rapid backtracking from sensor observations | 2024 |
| Demand forecasting (spatial) | Spatio-temporal GNN | Captures inter-node flow dependencies | 2024-2025 |

### Implementation Approach

1. **Graph construction**: Build from GIS/EPANET network model — nodes = junctions/tanks, edges = pipes
2. **Node features**: pressure, flow, water quality, demand, elevation
3. **Edge features**: pipe diameter, length, roughness (Hazen-Williams C), material, age
4. **Architecture**: GCN or GAT layers → readout → prediction head (classification for leak/no-leak, regression for flow/pressure)
5. **Training**: Label from SCADA historian + known leak/event records; augment with EPANET hydraulic simulations

### Key Considerations

- **Explainability**: Use attention-based GNNs (GAT) or Fuzzy GNN for interpretable edge/node importance — critical for utility engineers
- **Scale**: Large networks (10K+ nodes) may need graph partitioning or sampling strategies
- **Dynamic topology**: Valve open/close changes graph structure — use dynamic adjacency or edge masking
- **Complementary to time-series**: GNNs handle spatial dependencies; combine with temporal models (e.g., spatio-temporal GNN or GNN + LSTM/Transformer) for full coverage

## Virtual Metrology

Predict parameters that cannot be measured in real-time from available online sensors.

| Target (Offline) | Typical Inputs (Online) | Model Type | Update Frequency |
|------------------|------------------------|------------|-----------------|
| BOD₅ | DO, pH, turbidity, NH₃, flow, MLSS | Ensemble (XGBoost + NN) | Hourly |
| COD | UV254, turbidity, conductivity, TOC-online | Linear + calibration | 15 min |
| Total coliform | Turbidity, chlorine residual, UV dose, flow | Classification/regression | 30 min |
| Sludge settleability (SVI) | MLSS, DO, SRT, microscopy image | CNN + tabular | Daily |
| Membrane integrity | TMP, flux, permeate turbidity, particle count | Anomaly detection | Continuous |
| Metal concentrations | pH, ORP, conductivity, flow | PINN with precipitation model | Hourly |

### Calibration Strategy

- Retrain/update on every new lab result (online learning or periodic batch)
- Maintain bias correction layer: `y_corrected = model_output + bias(t)`
- Alert when prediction confidence interval exceeds threshold

## Control Architecture Patterns

### Hierarchical Control Stack

```
┌─────────────────────────────────────────┐
│  Layer 4: AI Supervisor (minutes-hours) │  Optimal setpoint planning
│  - Demand forecasting                    │  Energy optimization
│  - Process optimization                  │  Predictive scheduling
├─────────────────────────────────────────┤
│  Layer 3: MPC (seconds-minutes)         │  Multi-variable optimization
│  - Constraint handling                   │  with hard safety bounds
│  - Disturbance rejection                │
├─────────────────────────────────────────┤
│  Layer 2: PID (milliseconds-seconds)    │  Fast, reliable,
│  - Regulatory control                    │  proven stability
│  - Safety interlocks                    │
├─────────────────────────────────────────┤
│  Layer 1: Sensors & Actuators           │  Physical layer
│  - Valves, pumps, dosing systems        │
└─────────────────────────────────────────┘
```

### Key Rules

- AI NEVER directly commands actuators; always through MPC/PID layer
- Safety interlocks operate independently at PID/PLC level — AI cannot override
- Fallback: if AI layer fails, MPC holds last-known-good setpoints; if MPC fails, PID maintains stability
- Rate limiting: AI setpoint changes bounded by max ramp rate (prevent hydraulic shock)

### MPC for Water Treatment

Common controlled variables (CV) and manipulated variables (MV):

| Process | CVs | MVs | Disturbances |
|---------|-----|-----|-------------|
| Coagulation | Settled turbidity, pH | Coagulant dose, acid/base | Raw water turbidity, flow |
| Activated sludge | DO, NH₃-N effluent | Blower speed, RAS rate | Influent load, temperature |
| RO system | Permeate quality, recovery | Feed pressure, concentrate valve | Temperature, feed TDS |
| Disinfection | Residual Cl₂, CT | Chlorine dose, contact time | Flow, demand |
| pH control | pH | Acid/base dose | Flow, alkalinity variation |

### PID Tuning with AI

- Use Bayesian Optimization or Reinforcement Learning to tune Kp, Ki, Kd
- Objective: minimize ISE (integral squared error) while constraining overshoot
- Retune when process dynamics shift (seasonal, membrane aging, biofilm growth)

## Edge Deployment

### Model Optimization Pipeline

```
Training (Cloud/GPU) → Quantization (INT8/FP16) → ONNX Export → Runtime (Edge)
```

| Runtime | Target Hardware | Latency | Notes |
|---------|---------------|---------|-------|
| ONNX Runtime | x86/ARM CPU | 1-50 ms | Universal, well-supported |
| TFLite | ARM (Raspberry Pi, Jetson) | 1-20 ms | Mobile/embedded optimized |
| OpenVINO | Intel CPU/VPU | 1-10 ms | Intel hardware optimized |
| TensorRT | NVIDIA GPU | <1 ms | GPU inference, batch capable |
| Wasm (WASI-NN) | Any (browser, PLC, gateway) | 5-100 ms | Portable, sandboxed, emerging |

### Edge Architecture

```
Sensors → PLC/RTU → Edge Gateway → [Model Inference + Local DB] → SCADA/Cloud
                                 ↓
                         Local control actions (via OPC UA to PLC)
```

- **K3s**: Lightweight Kubernetes for edge; manage model containers on industrial PCs
- **MQTT Sparkplug B**: Standardized topic namespace for sensor data; birth/death certificates for device lifecycle
- **OPC UA**: Secure, structured read/write to PLC tags; pub/sub mode for real-time

### Deployment Checklist

- [ ] Model validated against physics-based baseline
- [ ] Quantization accuracy loss < 1% vs. full-precision
- [ ] Inference latency within control loop requirement
- [ ] Fallback behavior defined (last-good-output, safe default)
- [ ] Model versioning and rollback mechanism
- [ ] Monitoring: input drift detection, prediction confidence tracking
- [ ] Secure boot and signed model artifacts

## Digital Twin Integration

### Architecture

```
Physical Plant → Sensors → Data Platform → Digital Twin Engine
                                              ├── Physics Model (EPANET, PHREEQC, GPS-X)
                                              ├── AI Model (trained on historical + physics)
                                              └── Visualization (3D/dashboard)
                                                      ↓
                                              What-if Scenarios / Optimization → Control Actions
```

### Simulation Tools

| Tool | Domain | Integration Pattern |
|------|--------|-------------------|
| EPANET | Pipe network hydraulics & water quality | Python API (wntr), real-time calibration with sensor data |
| PHREEQC | Geochemistry, speciation, precipitation | Python wrapper (phreeqpy), validate scaling/precipitation predictions |
| GPS-X / BioWin | Biological process (ASM1/2d/3) | Co-simulation via API, calibrate with MLSS/NH₃/NO₃ data |
| WEST | Wastewater process modeling | Similar to GPS-X, Modelica-based |
| OpenFOAM | CFD (mixing, settling) | Offline validation of PINN/Neural Operator models |

### Calibration Loop

1. Collect sensor data (flow, quality, energy) at 1-15 min intervals
2. Run physics model with measured inputs
3. Compare predicted vs. measured outputs
4. Adjust model parameters (auto-calibration via optimization)
5. Flag when residual exceeds threshold (model or sensor fault)

## Agentic AI for Water Operations

### Agent Architecture

```
User / Alert / Schedule
        ↓
   Orchestrator Agent
        ├── Data Agent (query TSDB, SCADA historian)
        ├── Diagnosis Agent (root cause analysis, CoT reasoning)
        ├── Optimization Agent (run digital twin scenarios)
        ├── Compliance Agent (check regulatory limits, generate reports)
        └── Action Agent (generate work orders, adjust setpoints via MPC)
```

### RAG for Field Maintenance

- Index equipment manuals, P&IDs, SOPs, historical incident reports
- Retrieval: embed query → vector search → rerank → context injection
- Use case: field operator asks "Pump P-301 is cavitating, what should I check?"
- Response synthesizes from manual + historical fixes + process data context

### Agent Safety Boundaries

| Authorization Level | Allowed Actions |
|--------------------|----------------|
| Read-only | Query data, generate reports, send alerts |
| Advisory | Above + recommend setpoint changes (human approves) |
| Supervised auto | Above + auto-execute within pre-defined bounds (human monitors) |
| Full auto | Above + autonomous operation (emergency override always available) |

Default to Advisory level; escalate only with explicit organizational approval and safety review.

## Model Validation & Monitoring

### Pre-Deployment Validation

| Check | Method | Pass Criteria |
|-------|--------|--------------|
| Physical consistency | Mass balance on predictions | < 2% imbalance |
| Boundary behavior | Test at extremes of input range | Monotonic where expected |
| Interpolation accuracy | K-fold cross-validation | R² > 0.9 or domain-specific metric |
| Extrapolation safety | Test outside training range | Graceful degradation, no wild predictions |
| Temporal stability | Test on different time periods | Consistent performance across seasons |

### Production Monitoring

| Metric | Detection Method | Response |
|--------|-----------------|----------|
| Input drift | KL divergence, PSI on feature distributions | Alert, investigate source change |
| Concept drift | Prediction error trending up | Retrain with recent data |
| Prediction confidence | Ensemble disagreement or MC dropout | Flag low-confidence predictions |
| Latency degradation | P95 inference time tracking | Optimize or scale resources |
| Stale model | Days since last retraining | Trigger retraining pipeline |

---

## Related References

- [delivery-and-ops.md](delivery-and-ops.md) — IaC deployment patterns, GitOps/ArgoCD workflows for model delivery, observability stack, knowledge graph for RAG
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — AI agent identity (SPIFFE/SPIRE), OT network security for edge deployment, MLOps pipeline security
- [troubleshooting.md](troubleshooting.md) — Diagnostic frameworks that integrate with AI-driven root cause analysis
- [technologies.md](technologies.md) — Process fundamentals for physics-informed models (EPANET, PHREEQC, GPS-X)
