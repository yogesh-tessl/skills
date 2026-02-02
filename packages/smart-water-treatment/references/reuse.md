# Reclaimed & Recycled Water Reference

## Table of Contents

1. [Reuse Categories](#1-reuse-categories)
2. [Treatment Building Blocks (Unit Operations)](#2-treatment-building-blocks-unit-operations)
3. [Pathway A: Municipal Reclaimed Water → Industrial Supply](#3-pathway-a-municipal-reclaimed-water--industrial-supply)
4. [Pathway B: On-Site Industrial Water Reuse](#4-pathway-b-on-site-industrial-water-reuse)
5. [Pathway C: Potable Reuse (IPR / DPR)](#5-pathway-c-potable-reuse-ipr--dpr)
6. [End-Use Water Quality Requirements](#6-end-use-water-quality-requirements)
7. [Multi-Barrier Design Principles](#7-multi-barrier-design-principles)
8. [Monitoring & Compliance](#8-monitoring--compliance)
9. [Energy & Cost Benchmarking](#9-energy--cost-benchmarking)
10. [Taiwan Reclaimed Water Infrastructure](#10-taiwan-reclaimed-water-infrastructure)

---

## 1. Reuse Categories

Two primary paradigms define water reuse practice:

### Systemic Reclaimed Water (市政再生水)

Municipal WWTP effluent undergoes advanced treatment and is delivered via dedicated (purple) pipeline to industrial users. The source is mixed municipal sewage — high in BOD, pathogens, and variable in composition. Biological treatment is always required upstream.

### On-Site Industrial Reuse (廠內回收再利用)

Factory process wastewater is treated in-plant and returned to process or utility use. The source is typically low-BOD, chemically defined wastewater. Biological treatment is usually unnecessary; the challenge is targeted removal of specific contaminants (HF, Cu, CMP slurry, solvents).

### Category Comparison

| Attribute | Systemic Reclaimed Water | On-Site Industrial Reuse |
|---|---|---|
| Source | Municipal WWTP secondary effluent | Factory process/rinse wastewater |
| Treatment level | Tertiary + advanced (MBR/UF → RO → UV/AOP) | Chemical + membrane (coag → UF → RO → EDI) |
| Biological treatment | Required (high BOD, pathogens) | Rarely needed |
| Typical end-use | Cooling tower makeup, industrial process water | UPW feed, CMP rinse, cooling, scrubber |
| Examples | 永康/安平 → 南科; 鳳山 → 中鋼; Singapore NEWater | TSMC fab water recycling ("一滴水用3.5次") |
| Recovery target | 75-85% (single-pass RO); 90-95% with concentrate treatment | 85-95% depending on stream segregation |

---

## 2. Treatment Building Blocks (Unit Operations)

Water reuse trains are assembled from a shared set of building blocks — the same "Lego pieces" recombined for different scenarios. Understanding the modules matters more than memorizing specific trains.

### Three Core Modules

1. **Solid-Liquid Separation** — Remove suspended/colloidal matter to protect downstream membranes
2. **Desalting & Molecular Separation** — Remove dissolved salts, organics, and micropollutants
3. **Disinfection & Oxidation** — Inactivate pathogens and destroy trace organics

### Unit Operation Reference

| Unit Operation | Module | Function | Typical Position | Key Design Parameter |
|---|---|---|---|---|
| Multi-media filtration (MMF) | 1 | Bulk TSS removal | Pre-treatment | Loading rate (m³/m²·h), backwash frequency |
| Ultrafiltration (UF) | 1 | Particle/bacteria barrier (0.01-0.1 µm) | Pre-RO or standalone | Flux (LMH), TMP, fiber integrity (PDT) |
| Microfiltration (MF) | 1 | Particle barrier (0.1-0.45 µm) | Pre-RO | Flux (LMH), TMP |
| MBR | 1 | Combined biological + UF | Replaces secondary clarifier + UF | MLSS, SRT, flux |
| Reverse osmosis (RO) | 2 | Salt/organic rejection (>95-99.5%) | After UF/MF | Recovery, flux, feed pressure, dP, CIP frequency |
| Electrodialysis reversal (EDR) | 2 | Selective ion removal | After UF; alternative to RO | Current density, recovery, scaling potential |
| Ion exchange (IX) | 2 | Targeted ion removal or polishing | After RO or standalone | Resin type, regeneration cycle, leakage |
| EDI | 2 | Continuous deionization (no chemicals) | After RO (polishing) | Product resistivity, feed conductivity limit |
| UV disinfection | 3 | Pathogen inactivation (254 nm) | Post-RO or post-filtration | Dose (mJ/cm²), UVT, lamp age |
| UV/AOP (UV + H₂O₂) | 3 | Micropollutant destruction | After RO (potable reuse) | OH• exposure, H₂O₂ dose, EEO |
| Ozone | 3 | Oxidation + disinfection | Pre-filtration or post-RO | Ct value, dose (mg/L), bromate formation |
| Chlorination | 3 | Residual disinfection | Final step before distribution | Ct, residual (mg/L), DBP formation |

Cross-reference: [technologies.md](technologies.md) for detailed design parameters per technology.

---

## 3. Pathway A: Municipal Reclaimed Water → Industrial Supply

### Typical Treatment Train

```
Municipal WWTP Secondary Effluent
  → MBR or Conventional AS + UF
    → RO (single or two-pass)
      → UV/AOP (if potable reuse or stringent specs)
        → Stabilization / remineralization
          → Dedicated pipeline → Industrial user
```

### Key Characteristics

- **Biological treatment is mandatory** — source water has high BOD (100-300 mg/L in raw sewage), TSS, pathogens
- MBR increasingly preferred over conventional activated sludge + tertiary filtration (smaller footprint, better UF permeate quality for RO feed)
- **Recovery targets**: 75-85% single-pass RO; 90-95% achievable with concentrate treatment (HERO, EDR, or ZLD)
- RO concentrate management is the primary cost and environmental constraint

### Reference Facilities

See [Section 10 (Taiwan Reclaimed Water Infrastructure)](#10-taiwan-reclaimed-water-infrastructure) for the full facility table including capacity, treatment trains, and status. Key international reference: Singapore NEWater (780,000+ CMD, MF/UF → RO → UV, industrial + indirect potable reuse).

Cross-reference: [municipal.md](municipal.md) for WWTP effluent standards; [industrial.md](industrial.md) for industrial intake specs.

---

## 4. Pathway B: On-Site Industrial Water Reuse

### Typical Treatment Train

```
Segregated Factory Wastewater Streams
  → Stream-specific pretreatment (chemical precipitation, pH adjustment, F⁻ removal)
    → Equalization
      → Coagulation/Flocculation (if needed)
        → UF
          → RO (single or two-pass)
            → EDI or Mixed-Bed IX (for UPW-grade)
              → Return to process
```

### Key Characteristics

- **No biological treatment** — industrial wastewater (especially semiconductor) is typically low-BOD
- **Stream segregation is critical**: different waste streams require different pretreatment
  - CMP slurry waste → coagulation + sedimentation (high TSS, abrasive particles)
  - HF-containing waste → CaF₂ precipitation
  - Acid/alkali waste → neutralization
  - Organic solvent waste → separate treatment or off-site disposal
  - Dilute rinse water → direct to UF/RO (best candidate for reuse)
- **"一滴水用3.5次"** (one drop of water used 3.5 times) — the reuse multiplier concept: total water used in process ÷ fresh water intake. Achieved through cascading reuse and high-recovery recycling.
- Target: reduce municipal water dependency and minimize discharge

### Semiconductor Water Balance Example

```
Fresh UPW intake: 1.0 unit
  → Process use: 3.5 units (through recycling)
  → Discharge: ~0.3-0.5 units
  → Evaporative/consumptive losses: ~0.15 units
  → Overall recovery: 70-85%
```

Cross-reference: [semiconductor.md](semiconductor.md) for UPW specifications and fab water system design.

---

## 5. Pathway C: Potable Reuse (IPR / DPR)

### Indirect Potable Reuse (IPR)

Advanced-treated water passes through an **environmental buffer** before entering the drinking water supply:
- Groundwater recharge (spreading basins or injection wells) — months of subsurface travel
- Reservoir augmentation — blending with surface water source

### Direct Potable Reuse (DPR)

Advanced-treated water enters the drinking water treatment plant inlet or distribution system **without** an environmental buffer. Requires the highest treatment rigor and real-time monitoring.

### Full Advanced Treatment (FAT) — The Standard Barrier Sequence

```
WWTP Secondary/Tertiary Effluent
  → MF or UF (particle/pathogen barrier)
    → RO (dissolved contaminant barrier)
      → UV/AOP (micropollutant destruction + final disinfection)
        → Stabilization (lime, CO₂ for corrosion control)
```

### Reference Facilities

| Facility | Type | Capacity (CMD) | Buffer | Treatment |
|---|---|---|---|---|
| Orange County GWRS (CA) | IPR | 378,500 | Groundwater injection/spreading | MF → RO → UV/AOP |
| Big Spring, TX | DPR | 7,600 | None (blended at WTP inlet) | MF → RO → UV/AOP |
| Windhoek, Namibia | DPR | 21,000 | None | Pre-ozone → DAF → sand → GAC → UF → chlorination |
| Singapore NEWater | IPR (reservoir) | 780,000+ | Reservoir blending | MF/UF → RO → UV |

### IPR vs DPR Comparison

| Attribute | IPR | DPR |
|---|---|---|
| Environmental buffer | Required (months) | None |
| Public acceptance | Generally higher | Lower — requires extensive outreach |
| Treatment stringency | FAT standard | FAT + additional monitoring/redundancy |
| Regulatory status | Established (CA Title 22, TX) | Emerging (fewer regulations) |
| Response time for failure | Buffer provides time | Must detect and respond in real-time |

---

## 6. End-Use Water Quality Requirements

| End Use | Key Parameters | Typical Limits |
|---|---|---|
| Landscape irrigation | BOD, TSS, total coliform | BOD <30, TSS <30 mg/L, coliform <200 MPN/100mL |
| Toilet flushing | BOD, TSS, turbidity, coliform | BOD <30, TSS <30, turbidity <5 NTU |
| Cooling tower makeup | TDS, silica, hardness, Cl⁻, biological | TDS <500-1500, SiO₂ <150 mg/L (varies by CoC) |
| Boiler feedwater | TDS, hardness, silica, dissolved O₂ | TDS <10-500 (pressure-dependent), hardness ~0 |
| Industrial process water | Application-specific | See specific industry references |
| Groundwater recharge (IPR) | TOC, TN, pathogen indicators, CECs | TOC <0.5 mg/L, TN <10, ND for pathogens |
| Indirect potable (IPR) | Full drinking water standards + TOC | Meets SDWA + TOC <0.5, NDMA <10 ng/L |
| Direct potable (DPR) | Full drinking water standards + real-time monitoring | Meets SDWA + continuous online surrogates |
| Semiconductor UPW feed | Resistivity, TOC, particles, metals, silica | Resistivity >18.0 MΩ·cm, TOC <1-5 µg/L |

Cross-reference: [semiconductor.md](semiconductor.md) for SEMI F63 UPW specs; [municipal.md](municipal.md) for drinking water standards.

California Title 22 and Taiwan 再生水水質標準 provide the primary regulatory frameworks for non-potable reuse categories.

---

## 7. Multi-Barrier Design Principles

### Concept

No single treatment step is relied upon for public health protection. Multiple independent barriers ensure that failure of any one barrier does not result in inadequate treatment. This principle is foundational for potable reuse but applies to all reuse scenarios.

### Log Removal Credits by Barrier

| Barrier | Virus | Cryptosporidium | Giardia |
|---|---|---|---|
| MF/UF (intact) | 0 (nominal) | 4.0 | 4.0 |
| RO (intact) | 2.0 | 2.0 | 2.0 |
| UV (40 mJ/cm²) | 6.0 | 4.0 | 4.0 |
| UV/AOP | 6.0 | 6.0 | 6.0 |
| Ozone (Ct-based) | 6.0 | 1.0 | 3.0 |
| Chlorination (Ct-based) | 4.0-6.0 | 0 | 3.0 |
| Soil aquifer treatment (IPR) | 1.0 | 1.0 | 1.0 |
| **Typical FAT total** | **14+** | **10+** | **10+** |

Target: 12-log virus, 10-log Crypto, 10-log Giardia (California DPR framework).

### Critical Control Points (CCPs) per Barrier

| Barrier | CCP Parameter | Action Limit | Response |
|---|---|---|---|
| MF/UF | Pressure decay test (PDT) | >threshold kPa/min | Isolate rack, integrity repair |
| RO | Conductivity rejection | <95% rejection | Investigate/replace elements |
| UV | UV dose / UVT | <required mJ/cm² | Divert flow, replace lamps |
| AOP | H₂O₂ residual | Below setpoint | Adjust dosing, divert |
| Chlorination | Cl₂ residual × contact time | Below Ct target | Increase dose, extend contact |

### Failure Mode Response

- **Single barrier failure**: divert to waste or reduce flow while maintaining other barriers — system remains protective
- **Multiple barrier failure**: automatic shutdown and operator notification
- **Design principle**: each barrier must be independently monitored and controllable

---

## 8. Monitoring & Compliance

### Real-Time Surrogate Parameters

| Surrogate | What It Indicates | Typical Instrument | Monitoring Frequency |
|---|---|---|---|
| Turbidity | Particle breakthrough (UF/MF integrity) | Nephelometer | Continuous (every 15 sec) |
| UV transmittance (UVT) | Organic load, UV dose adequacy | Online UVT analyzer | Continuous |
| Conductivity / TDS | Salt rejection (RO integrity) | Conductivity probe | Continuous |
| TOC | Organic contamination | Online TOC analyzer | Every 5-15 min |
| Particle counts | Membrane integrity | Laser particle counter | Continuous |
| Dissolved O₂ | Biological activity indicator | DO probe | Continuous |

### Emerging Contaminants of Concern

| Contaminant | Concern | Typical Limit | Treatment |
|---|---|---|---|
| NDMA | Carcinogenic DBP; passes RO | 10 ng/L (CA notification) | UV photolysis (>1000 mJ/cm²) |
| 1,4-Dioxane | Solvent stabilizer; passes RO | 1 µg/L (CA notification) | UV/AOP |
| PFAS (PFOA/PFOS) | Persistent; bioaccumulative | 4 ng/L each (US EPA MCL) | RO rejection + GAC/IX for concentrate |
| CECs (pharmaceuticals, EDCs) | Ecological/human health risk | Varies by compound | UV/AOP, ozone, GAC |

### Monitoring Frequency by Reuse Class

| Parameter | Non-Potable (irrigation/cooling) | IPR | DPR |
|---|---|---|---|
| Turbidity | Daily | Continuous | Continuous |
| TOC | Weekly | Continuous | Continuous |
| Conductivity | Daily | Continuous | Continuous |
| Pathogens (coliform) | Weekly | Daily | Daily + online surrogates |
| Regulated CECs | Quarterly | Monthly | Monthly + online TOC/UVT |
| NDMA, 1,4-dioxane | — | Quarterly | Monthly |
| PFAS | — | Quarterly | Quarterly |

---

## 9. Energy & Cost Benchmarking

| Water Source | Energy (kWh/m³) | Typical Cost (USD/m³) | Notes |
|---|---|---|---|
| Conventional surface water (WTP) | 0.2-0.5 | 0.3-0.8 | Baseline reference |
| Reclaimed — non-potable (UF + disinfection) | 0.5-1.0 | 0.5-1.2 | Tertiary treatment only |
| Reclaimed — industrial (UF + RO) | 1.0-2.0 | 1.0-2.5 | Including RO energy |
| Reclaimed — potable (FAT: MF/UF + RO + UV/AOP) | 1.5-2.5 | 1.5-3.0 | Full advanced treatment |
| Seawater desalination (SWRO) | 3.0-4.5 | 1.5-3.5 | With energy recovery devices |
| ZLD (evaporator + crystallizer) | 20-40 | 10-25 | Concentrate management endpoint |

### Carbon Footprint Comparison

| Source | kgCO₂/m³ |
|---|---|
| Conventional surface water | 0.1-0.3 |
| Reclaimed (non-potable) | 0.2-0.5 |
| Reclaimed (potable) | 0.5-1.0 |
| Seawater desalination | 1.0-2.5 |
| ZLD | 8-20 |

Energy and carbon values are highly dependent on local grid carbon intensity, facility scale, and energy recovery. Values represent typical ranges for planning purposes.

---

## 10. Taiwan Reclaimed Water Infrastructure

### Regulatory Framework

- **再生水資源發展條例** (Reclaimed Water Resources Development Act) — requires designated industrial parks to use reclaimed water when available
- Water Corporation and industrial park authorities negotiate offtake agreements
- Dedicated distribution pipelines (equivalent to "purple pipe" systems) required — no cross-connection with potable supply

### Active and Planned Facilities

| Facility | Source WWTP | Capacity (CMD) | End User | Treatment Train | Status |
|---|---|---|---|---|---|
| 鳳山再生水廠 | 鳳山溪 WWTP | 45,000 | 中鋼 (CSC) | MBR → RO | Operational |
| 臨海再生水廠 | 臨海 WWTP | 33,000 | 臨海工業區 | MBR → RO | Operational |
| 永康再生水廠 | 永康 WWTP | 15,500 | 南科 (STSP) | MBR → RO → UV | Operational |
| 安平再生水廠 | 安平 WWTP | 37,500 | 南科 (STSP) | MBR → RO | Under construction |
| 豐原再生水廠 | 豐原 WWTP | 6,800 | 中科 (CTSP) | MBR → RO | Planning |
| 福田再生水廠 | 福田 WWTP | 6,500 | 中科 (CTSP) | MBR → RO | Planning |
| 前鎮再生水廠 | 前鎮 WWTP | 3,300 | 前鎮加工區 | MBR → RO | Planning |

### Key Design Considerations for Taiwan Context

- **Typhoon season** impacts WWTP influent quality (dilution + combined sewer overflow) — reclaimed water plants must handle variable feed
- **Earthquake resilience** for dedicated pipelines — seismic design per local codes
- Industrial parks (science parks) are primary demand drivers — semiconductor fabs require consistent quality and quantity
- Water rights and pricing: reclaimed water typically priced at 50-70% of tap water to incentivize industrial adoption

Cross-reference: [industrial.md](industrial.md) for ZLD and industrial water treatment; [municipal.md](municipal.md) for WWTP effluent quality.
