# Desalination Reference

## Table of Contents

1. [Source Water Classification](#1-source-water-classification)
2. [Desalination Technology Selection](#2-desalination-technology-selection)
3. [SWRO System Design](#3-swro-system-design)
4. [BWRO System Design](#4-bwro-system-design)
5. [Intake & Pretreatment](#5-intake--pretreatment)
6. [Energy Recovery & Optimization](#6-energy-recovery--optimization)
7. [Post-Treatment & Stabilization](#7-post-treatment--stabilization)
8. [Concentrate Management](#8-concentrate-management)
9. [Fouling, Scaling & CIP](#9-fouling-scaling--cip)
10. [Thermal Desalination](#10-thermal-desalination)
11. [Emerging Technologies](#11-emerging-technologies)
12. [Energy & Cost Benchmarking](#12-energy--cost-benchmarking)
13. [Environmental Considerations](#13-environmental-considerations)
14. [Major Global Facilities](#14-major-global-facilities)

---

## 1. Source Water Classification

| Source | TDS Range (mg/L) | Typical Temperature | Key Challenges |
|---|---|---|---|
| Seawater (open ocean) | 33,000-37,000 | 15-30°C (regional) | High osmotic pressure, boron, biofouling |
| Seawater (Arabian Gulf) | 40,000-48,000 | 20-35°C | Very high TDS, high temperature, high turbidity |
| Brackish groundwater | 1,000-10,000 | 15-25°C (stable) | Silica, iron/manganese, scaling (CaSO₄, BaSO₄) |
| Brackish surface water | 1,000-10,000 | Variable | Turbidity, organics, biofouling |
| High-salinity industrial | 5,000-70,000 | Variable | Application-specific contaminants |

### Key Water Quality Parameters for Design

| Parameter | Impact | Design Concern |
|---|---|---|
| TDS / conductivity | Osmotic pressure → energy | Determines operating pressure and recovery |
| Temperature | Viscosity, flux, salt passage | Higher T → higher flux but higher salt passage |
| SDI (Silt Density Index) | Membrane fouling potential | SDI <3 for SWRO feed; <5 acceptable for BWRO |
| Turbidity | Particulate fouling | <1 NTU for RO feed; <0.5 NTU preferred |
| TOC | Organic fouling | <2 mg/L for RO feed |
| Boron | Regulatory compliance | Seawater: 4-6 mg/L; drinking water limit: 0.5-2.4 mg/L |
| Silica (SiO₂) | Scale formation | Reactive silica <120 mg/L in concentrate (pH-dependent) |
| Barium, strontium | BaSO₄/SrSO₄ scale | Low solubility — scale even at low concentration |
| Iron / manganese | Oxidation → fouling | Must be <0.05 mg/L in RO feed (remove in pretreatment) |
| Free chlorine | Membrane damage | 0 mg/L for polyamide — dechlorinate with SBS/SMBS |
| H₂S | Odor, corrosion, membrane damage | Strip or oxidize in pretreatment |

---

## 2. Desalination Technology Selection

| Technology | Feed TDS | Energy (kWh/m³) | Recovery | Best Application |
|---|---|---|---|---|
| SWRO | 30,000-45,000 | 2.5-4.5 | 40-55% | Seawater — dominant technology |
| BWRO | 1,000-10,000 | 0.5-2.5 | 75-90% | Brackish ground/surface water |
| EDR | 500-5,000 | 0.5-2.0 | 85-95% | Brackish, selective ion removal |
| MSF | 30,000-50,000 | 10-15 (thermal) | 25-35% | Co-located with power plant (waste heat) |
| MED | 30,000-50,000 | 6-10 (thermal) | 25-40% | Lower-temperature waste heat available |
| MVC | 5,000-50,000 | 8-15 | 90-98% | ZLD concentrate treatment |
| FO | Variable | 0.5-1.0 (+ draw regeneration) | Variable | Niche: high-fouling feed, osmotic dilution |

### Decision Tree

```
Feed TDS?
├── <10,000 mg/L (brackish)
│   ├── Selective removal needed? → EDR
│   └── Bulk desalting → BWRO
├── 10,000-30,000 mg/L (high brackish)
│   └── BWRO (low recovery) or SWRO elements at reduced pressure
└── >30,000 mg/L (seawater)
    ├── Waste heat available? → MED or MSF (thermal)
    └── No waste heat → SWRO (membrane)
```

---

## 3. SWRO System Design

### Typical Treatment Train

```
Seawater Intake
  → Screening (coarse + fine: 100-500 µm)
    → Pretreatment (DAF or UF or MMF + cartridge filter)
      → High-Pressure Pump + Energy Recovery Device
        → SWRO 1st Pass (40-50% recovery)
          → Optional: SWRO 2nd Pass (85-90% recovery, for boron)
            → Post-Treatment (remineralization, disinfection)
              → Product Water Storage → Distribution
```

### 1st Pass SWRO Design Parameters

| Parameter | Typical Range | Notes |
|---|---|---|
| Feed pressure | 55-70 bar | Depends on TDS, temperature, recovery |
| Recovery | 40-50% (open ocean), 35-42% (Gulf) | Limited by osmotic pressure + scaling |
| Flux | 12-17 LMH | Conservative for fouling control |
| Salt rejection | 99.5-99.8% (system) | Single element: 99.7-99.85% |
| Permeate TDS | 200-500 mg/L | Before 2nd pass |
| Array | 7:1 or 8:1 (single stage) | 8" elements, 7-8 elements per vessel |
| Membrane type | SW (seawater) TFC polyamide | High rejection, high pressure rated |

### 2nd Pass (Boron Removal / Polishing)

Required when: boron limit <1.0 mg/L (WHO guideline: 2.4 mg/L; stricter: 0.5 mg/L)

| Parameter | Typical Range | Notes |
|---|---|---|
| Feed | 1st pass permeate | TDS 200-500 mg/L |
| pH adjustment | Raise to pH 10-11 | Converts boric acid → borate ion (higher rejection) |
| Recovery | 85-90% | |
| Permeate boron | <0.3 mg/L | Achievable at pH >10 |
| Concentrate | Return to 1st pass feed | Improves overall recovery |

### Boron Chemistry

```
B(OH)₃ (boric acid) ⇌ B(OH)₄⁻ (borate ion) + H⁺     pKa = 9.2

At pH 7: >99% as B(OH)₃ (uncharged, small — passes RO membrane)
At pH 10: >85% as B(OH)₄⁻ (charged — rejected by RO)
```

---

## 4. BWRO System Design

### Typical Treatment Train

```
Brackish Well or Surface Intake
  → Pretreatment (oxidation/filtration for Fe/Mn, antiscalant dosing)
    → Cartridge Filter (5 µm)
      → High-Pressure Pump (no ERD typically — lower pressure)
        → BWRO (75-90% recovery, multi-stage)
          → Post-Treatment (pH adjustment, disinfection)
            → Product Water
```

### BWRO Design Parameters

| Parameter | Typical Range | Notes |
|---|---|---|
| Feed pressure | 10-25 bar | Much lower than SWRO |
| Recovery | 75-85% (standard), 90% (with antiscalant + intermediate treatment) | Limited by scaling, not osmotic pressure |
| Flux | 20-30 LMH | Higher flux achievable vs. SWRO |
| Array | 2:1 or 3:2:1 (multi-stage) | Concentrate staging for high recovery |
| Membrane type | BW (brackish water) TFC | Lower pressure rated, higher flux |
| Permeate TDS | 10-50 mg/L | |

### Scaling Risks by Recovery

| Scale | Solubility Product | Risk Onset | Mitigation |
|---|---|---|---|
| CaCO₃ (calcite) | LSI >0 | >70% recovery | Acid dosing (LSI <0), antiscalant |
| CaSO₄ (gypsum) | Ksp = 3.1×10⁻⁵ | >80% recovery | Antiscalant, limit recovery |
| BaSO₄ (barite) | Ksp = 1.1×10⁻¹⁰ | Even at low recovery if Ba present | Antiscalant critical; very low solubility |
| SrSO₄ (celestite) | Ksp = 3.4×10⁻⁷ | >75% recovery | Antiscalant |
| SiO₂ (silica) | ~120-150 mg/L (reactive) | Concentrate >120 mg/L | Limit recovery, pH control, antiscalant |
| CaF₂ (fluorite) | Ksp = 3.5×10⁻¹¹ | If fluoride present | Antiscalant, pretreatment removal |

---

## 5. Intake & Pretreatment

### Intake Types

| Type | Description | Pros | Cons |
|---|---|---|---|
| Open ocean (surface) | Intake pipe 500-2000m offshore, submerged | High capacity, proven | Algae, jellyfish, marine growth, higher SDI |
| Subsurface (beach well / gallery) | Seabed or beach filtration | Natural prefiltration (low SDI) | Limited capacity, site-dependent geology |
| Onshore well (brackish) | Vertical or horizontal wells | Consistent quality, low turbidity | Aquifer sustainability, Fe/Mn possible |

### Pretreatment Options

| Method | Removes | Typical Application | Product SDI |
|---|---|---|---|
| Conventional (coag + MMF) | TSS, colloids, some organics | Standard SWRO pretreatment | 3-4 |
| DAF + MMF | Algae, oil & grease, light particles | Algae-prone intakes (Red Sea, Gulf) | 2-3 |
| UF (immersed or pressurized) | Particles >0.01 µm, bacteria | Challenging/variable feed quality | <2 (often <1) |
| Cartridge filter (5 µm) | Last-chance particle guard | Always — final barrier before HP pump | — |

### Pretreatment Selection Guide

```
Feed Quality?
├── Clean, stable (beach well, SDI <2) → Cartridge filter only (rare, low risk)
├── Moderate (SDI 2-4, low algae) → Conventional (coag + MMF + cartridge)
├── Variable/challenging (SDI >4, algae blooms) → DAF + MMF or UF
└── Severe (HABs, high organics, oil risk) → DAF + UF (dual barrier)
```

### Harmful Algal Bloom (HAB) Response

HABs are the most challenging operational event for SWRO plants:

| Severity | Indicator | Response |
|---|---|---|
| Advisory | Chlorophyll-a >5 µg/L, algae cell count rising | Increase coagulant dose, monitor SDI hourly |
| Moderate | SDI >4, UF flux decline, increased ΔP | Reduce plant capacity 25-50%, increased CEB frequency |
| Severe | SDI >5, algal toxins detected, UF integrity risk | Consider plant shutdown; protect membranes |

---

## 6. Energy Recovery & Optimization

### Energy Recovery Devices (ERDs)

The high-pressure brine from SWRO contains ~95% of the energy input. ERDs recover this energy to reduce SEC (Specific Energy Consumption).

| ERD Type | Mechanism | Efficiency | Application |
|---|---|---|---|
| Pelton turbine | Kinetic → shaft power | 85-90% | Older plants, smaller capacity |
| Turbocharger | Brine drives turbine → boosts feed | 80-85% | Mid-range, compact |
| Pressure exchanger (PX) | Direct pressure transfer (isobaric) | 95-98% | Modern SWRO standard — lowest SEC |
| Dual work exchanger (DWEER) | Piston-based pressure transfer | 95-97% | Large plants |

### Specific Energy Consumption (SEC)

| System Configuration | SEC (kWh/m³) | Notes |
|---|---|---|
| SWRO without ERD | 6-8 | Obsolete — no new plants built this way |
| SWRO + Pelton turbine | 4-5 | Legacy plants |
| SWRO + PX (pressure exchanger) | 2.5-3.5 | Current best practice |
| SWRO + PX + optimized design | 2.0-2.5 | Near thermodynamic minimum at 50% recovery |
| Thermodynamic minimum (seawater, 50%) | ~1.1 | Theoretical limit — cannot be achieved in practice |
| BWRO (no ERD needed) | 0.5-2.0 | Low feed pressure → ERD not cost-effective |

### Energy Optimization Strategies

| Strategy | Savings | Implementation |
|---|---|---|
| Modern ERD (PX type) | 30-50% vs. no ERD | Capital investment; standard for new SWRO |
| Variable frequency drives (VFDs) | 10-20% | Adjust HP pump to actual demand |
| Interstage booster | 5-10% | Equalize flux distribution in pressure vessels |
| Seasonal setpoint optimization | 5-15% | Lower pressure in winter (lower T → lower osmotic P) |
| AI-driven pressure optimization | 3-8% | Real-time setpoint adjustment based on feed conditions |

Cross-reference: [ai-and-control.md](ai-and-control.md) for AI-driven energy optimization patterns.

---

## 7. Post-Treatment & Stabilization

RO permeate is aggressive (low TDS, low alkalinity, low pH) and will corrode distribution infrastructure without stabilization.

### Remineralization Methods

| Method | Adds | Typical Application | Pros | Cons |
|---|---|---|---|---|
| Lime + CO₂ | Ca²⁺, alkalinity | Large SWRO plants | Low cost, proven | Requires lime handling, sludge |
| Calcite contactor | Ca²⁺, alkalinity | Small-medium plants | Simple operation | Slow dissolution, limited capacity |
| CaCl₂ + NaHCO₃ dosing | Ca²⁺, alkalinity independently | Precise control needed | Precise, no sludge | Chemical cost |
| Blending with source water | All minerals | Where source is potable-grade | Zero chemical cost | Quality dependent on blend ratio |

### Target Permeate Quality (Drinking Water)

| Parameter | Target | Rationale |
|---|---|---|
| pH | 7.5-8.5 | Corrosion control |
| Alkalinity | 60-120 mg/L as CaCO₃ | Buffer capacity |
| Calcium hardness | 40-80 mg/L as CaCO₃ | Protective CaCO₃ film |
| LSI (Langelier Saturation Index) | +0.2 to +0.5 | Slightly scale-forming for pipe protection |
| CCPP | 4-10 mg/L as CaCO₃ | Calcium carbonate precipitation potential |
| Cl₂ residual | 0.2-0.5 mg/L (free) | Distribution system disinfection |
| Boron | <0.5-2.4 mg/L | WHO: 2.4; stricter jurisdictions: 0.5 |
| Fluoride | 0.7-1.5 mg/L (if added) | Dental health (jurisdiction-dependent) |

---

## 8. Concentrate Management

Concentrate (brine) disposal is often the most constrained and costly aspect of desalination.

### Disposal Options

| Method | Applicability | Environmental Concern | Relative Cost |
|---|---|---|---|
| Ocean outfall (diffuser) | Coastal SWRO | Salinity impact on marine life | Low |
| Deep well injection | Inland BWRO | Aquifer contamination risk | Medium |
| Evaporation ponds | Arid inland, small plants | Land use, wildlife (hypersaline) | Medium (land) |
| Sewer discharge | Small BWRO, where permitted | WWTP loading, TDS pass-through | Low |
| ZLD (brine concentrator + crystallizer) | Zero discharge mandate | Energy-intensive; solid waste disposal | Very high |
| Beneficial use (salt harvesting) | Suitable brine composition | Market-dependent | Variable |

### SWRO Concentrate Characteristics

| Parameter | Typical (at 45% recovery from 35,000 mg/L SW) |
|---|---|
| TDS | ~63,000 mg/L |
| Temperature | Feed temp + 1-2°C |
| Dissolved oxygen | Near saturation (if not deaerated) |
| Antiscalant | Present (passed through) |
| pH | Feed pH (or slightly lower if acid-dosed) |
| Flow | ~55% of feed flow |
| Pressure (after ERD) | ~1-2 bar (energy recovered) |

### Environmental Mixing Zone Design

For ocean outfall with diffuser:
- Near-field dilution target: 20:1 to 40:1 within 50-100m
- Salinity at mixing zone boundary: <1 ppt above ambient
- Multiport diffusers with angled nozzles for rapid mixing
- CFD or near-field models (CORMIX, UM3, Visual Plumes) for design validation

Cross-reference: [industrial.md](industrial.md) for ZLD train design details.

---

## 9. Fouling, Scaling & CIP

### Fouling Diagnosis

| Symptom | Likely Fouling Type | Affected Elements | Diagnostic |
|---|---|---|---|
| ΔP↑, flux↓, SP→ | Particulate/colloidal | Lead elements | SDI test; element autopsy |
| ΔP↑↑, flux↓, SP→ | Biofouling | Lead elements | ATP test; biofilm probe; smell (H₂S) |
| Flux↓, SP↑ | Organic fouling | Throughout | TOC of feed; element autopsy (FTIR) |
| Flux↓, SP↑ | Mineral scale | Tail elements | Concentrate saturation indices; acid test |
| SP↑↑ | Oxidation damage (irreversible) | Throughout | ORP check; chlorine test on feed |

### CIP (Clean-in-Place) Protocols

| Fouling Type | Cleaning Chemical | pH | Temperature | Duration |
|---|---|---|---|---|
| Biofouling | NaOH + EDTA (or SDS surfactant) | 11-12 | 35-40°C | 4-6 hr soak |
| Organic | NaOH + Na-SDS | 11-12 | 35-40°C | 4-6 hr soak |
| CaCO₃ scale | HCl or citric acid | 2-3 | 25-35°C | 2-4 hr soak |
| Sulfate scale (CaSO₄) | Specialty sulfate cleaner (EDTA-based) | 11-12 | 35-40°C | 6-12 hr |
| Silica scale | NaOH at high pH + warm | 12-13 | 40°C | 6-8 hr |
| Metal oxides (Fe, Mn) | Citric acid or sodium hydrosulfite | 2-4 | 25°C | 2-4 hr |

### CIP Frequency Guidelines

| Condition | Action |
|---|---|
| Normalized flux decline >10% | Schedule CIP |
| Normalized ΔP increase >15% | Schedule CIP (likely biofouling/particulate) |
| Normalized salt passage increase >10% | Schedule CIP (likely scale or organic) |
| Routine preventive | Every 1-3 months (site-dependent) |

### Normalization

Always normalize operating data to reference conditions before diagnosing fouling:
- Reference temperature (typically 25°C) — TCF correction
- Reference pressure (net driving pressure)
- Reference recovery and flow

Cross-reference: [technologies.md](technologies.md) for membrane fundamentals; [troubleshooting.md](troubleshooting.md) for diagnostic frameworks.

---

## 10. Thermal Desalination

Still relevant where waste heat is available (co-located power plants, industrial sites) or for very high TDS water.

### MSF (Multi-Stage Flash)

| Parameter | Typical Range |
|---|---|
| Stages | 15-25 |
| Top brine temperature | 90-110°C |
| GOR (Gain Output Ratio) | 8-12 kg distillate / kg steam |
| Recovery | 25-35% |
| Product TDS | <10 mg/L |
| SEC (thermal + electrical) | 10-15 kWh/m³ equivalent |

### MED (Multi-Effect Distillation)

| Parameter | Typical Range |
|---|---|
| Effects | 8-16 |
| Top brine temperature | 65-70°C |
| GOR | 8-15 |
| Recovery | 25-40% |
| Product TDS | <10 mg/L |
| SEC (thermal + electrical) | 6-10 kWh/m³ equivalent |
| Advantage over MSF | Lower top brine temperature → less scaling, can use lower-grade heat |

### MED-TVC (with Thermal Vapor Compression)

Adds motive steam ejector to improve GOR to 12-16. Common in Gulf states co-located with power generation.

### Hybrid Thermal-Membrane

```
Seawater → MSF or MED (produces very low TDS distillate)
         ↘ Cooling water reject (warm, slightly concentrated)
            → SWRO (higher flux at elevated temperature)
              → Blend MSF/MED distillate + RO permeate
```

Benefits: improved overall recovery, lower blended energy cost, thermal handles boron natively.

---

## 11. Emerging Technologies

| Technology | Principle | Status | Potential Advantage |
|---|---|---|---|
| Closed-circuit RO (CCRO) | Batch/semi-batch RO with concentrate recirculation | Commercial | Higher recovery from seawater (60-65%) |
| Osmotically assisted RO (OARO) | Osmotic assist on permeate side | Pilot | Desalination of high-TDS brines (up to 100,000+) |
| Membrane distillation (MD) | Vapor transport through hydrophobic membrane | Pilot-commercial | Utilizes low-grade heat; handles high TDS |
| Capacitive deionization (CDI) | Electrosorption on carbon electrodes | Early commercial | Low-TDS brackish; low energy |
| Solvent extraction (SED) | Amine-based directional solvent extraction | Lab-pilot | Potential for low-energy seawater desal |
| Electrodialysis metathesis (EDM) | Converts scaling ions to non-scaling salts | Pilot | Enables high BWRO recovery without antiscalant |
| Forward osmosis + RO | FO as pretreatment / osmotic dilution | Pilot-commercial | Reduced SWRO energy (diluted feed) |

---

## 12. Energy & Cost Benchmarking

### CAPEX Ranges

| System | Capacity | CAPEX (USD/m³/day capacity) |
|---|---|---|
| Small SWRO (<5,000 m³/d) | Containerized | 1,500-3,000 |
| Medium SWRO (5,000-50,000) | Custom-built | 1,000-2,000 |
| Large SWRO (>50,000) | Mega-plant | 700-1,500 |
| BWRO | Any | 300-800 |
| Thermal (MSF/MED) | Large, co-located | 1,200-2,500 |

### OPEX Breakdown (Large SWRO)

| Component | % of Total OPEX | USD/m³ |
|---|---|---|
| Energy | 35-50% | 0.3-0.6 |
| Chemicals (pretreatment, CIP, post) | 10-15% | 0.05-0.15 |
| Membrane replacement | 8-12% | 0.05-0.10 |
| Labor | 10-15% | 0.05-0.15 |
| Maintenance & spares | 8-12% | 0.05-0.10 |
| Concentrate disposal | 5-15% | 0.03-0.10 |
| **Total OPEX** | **100%** | **0.5-1.2** |

### Levelized Cost of Water (LCOW)

| Technology | LCOW (USD/m³) | Key Sensitivity |
|---|---|---|
| Large SWRO (>100,000 m³/d) | 0.5-1.0 | Energy price, recovery |
| Medium SWRO | 0.8-1.5 | Scale, energy |
| BWRO | 0.2-0.6 | Feed TDS, recovery |
| Thermal (with waste heat) | 0.8-1.5 | Heat cost allocation |
| Thermal (standalone) | 1.5-3.0 | Fuel cost |

---

## 13. Environmental Considerations

### Marine Impact Assessment

| Impact | Cause | Mitigation |
|---|---|---|
| Hypersaline plume | Concentrate discharge | Diffuser design; mixing zone modeling |
| Impingement | Intake screens trapping organisms | Low-velocity intake (<0.15 m/s); wedgewire screens |
| Entrainment | Small organisms drawn into intake | Subsurface intake where feasible; intake location/depth |
| Chemical residuals | Antiscalant, biocide in concentrate | Minimize dosing; select biodegradable chemicals |
| Thermal discharge | Elevated brine temperature | Blend with cooling water; seasonal limits |

### Carbon Footprint Reduction Strategies

| Strategy | CO₂ Reduction Potential |
|---|---|
| Renewable energy (solar PV / wind) | 50-100% of operational carbon |
| Energy recovery (PX) | 30-50% energy reduction |
| Green hydrogen for off-grid plants | Eliminates fossil fuel dependency |
| Optimized operation (AI-driven) | 5-15% energy reduction |
| Low-carbon materials / construction | 10-20% of embodied carbon |

### Regulatory Frameworks

| Region | Key Regulation | Focus |
|---|---|---|
| California | Ocean Plan Amendment | Concentrate salinity limits, intake requirements |
| Australia | EPA guidelines per state | Brine dilution, marine monitoring |
| Middle East | AGEDI / local EPA | Less restrictive; evolving |
| EU | Water Framework Directive | Environmental quality standards |
| Taiwan | 海洋放流水標準 | Discharge quality limits |

---

## 14. Major Global Facilities

| Facility | Location | Capacity (m³/d) | Technology | Notable Feature |
|---|---|---|---|---|
| Ras Al Khair | Saudi Arabia | 1,036,000 | MSF + SWRO hybrid | Largest desalination plant globally |
| Sorek B | Israel | 548,000 | SWRO | Among lowest LCOW (~$0.41/m³) |
| Taweelah | UAE | 909,000 | SWRO | Largest single SWRO plant |
| Carlsbad | California, USA | 189,000 | SWRO + UF pretreatment | US West Coast benchmark |
| Perth (Southern Seawater) | Australia | 274,000 | SWRO | 100% renewable energy powered |
| Jebel Ali | UAE | 636,000+ | MSF + MED | Co-located with power station |
| Barcelona | Spain | 200,000 | SWRO | Built in response to 2008 drought |

Cross-reference: [technologies.md](technologies.md) for RO membrane fundamentals; [industrial.md](industrial.md) for ZLD and concentrate treatment; [reuse.md](reuse.md) for energy/cost comparison across water sources.
