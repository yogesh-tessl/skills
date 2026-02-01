# Municipal Water Treatment Reference

## Table of Contents

1. [Drinking Water Standards](#drinking-water-standards)
2. [Wastewater Discharge Standards](#wastewater-discharge-standards)
3. [Drinking Water Treatment Processes](#drinking-water-treatment-processes)
4. [Wastewater Treatment Processes](#wastewater-treatment-processes)
5. [Sludge Management](#sludge-management)
6. [Emerging Contaminants](#emerging-contaminants)

## Drinking Water Standards

### US EPA National Primary Drinking Water Regulations (Selected)

| Contaminant | MCL (mg/L) | MCLG | Treatment |
|-------------|-----------|------|-----------|
| Arsenic | 0.010 | 0 | Coagulation, IX, adsorption |
| Lead | TT (0.015 AL) | 0 | Corrosion control, LSL replacement |
| Copper | TT (1.3 AL) | 1.3 | Corrosion control, pH adjustment |
| Nitrate (as N) | 10 | 10 | IX, biological denitrification, RO |
| Fluoride | 4.0 | 4.0 | Activated alumina, RO |
| THMs (total) | 0.080 | N/A | Precursor removal, alternative disinfection |
| HAA5 | 0.060 | N/A | Precursor removal, GAC |
| Turbidity | TT (0.3 NTU 95%) | N/A | Filtration |
| Total coliform | <5% positive | 0 | Disinfection |
| Cryptosporidium | TT | 0 | Filtration (≥2-log), UV |
| Giardia | TT | 0 | Filtration (≥3-log), disinfection |
| PFOA/PFOS | 0.000004 | 0 | GAC, IX, RO, nanofiltration |

MCL = Maximum Contaminant Level; MCLG = MCL Goal; TT = Treatment Technique; AL = Action Level

### WHO Guidelines (Selected)

| Parameter | Guideline Value | Notes |
|-----------|----------------|-------|
| E. coli | Not detectable in 100mL | Indicator organism |
| Arsenic | 0.01 mg/L | Provisional |
| Fluoride | 1.5 mg/L | |
| Nitrate (as NO₃) | 50 mg/L | ~11.3 mg/L as N |
| Lead | 0.01 mg/L | |
| Turbidity | <1 NTU (ideally <0.1) | For effective disinfection |

### Taiwan EPA Drinking Water Standards (Selected)

| Parameter | Standard | Notes |
|-----------|----------|-------|
| Turbidity | ≤2 NTU | |
| Total coliform | ≤6 CFU/100mL | |
| pH | 6.0-8.5 | |
| TDS | ≤800 mg/L | |
| Hardness (CaCO₃) | ≤400 mg/L | |
| Arsenic | ≤0.01 mg/L | |
| Lead | ≤0.01 mg/L | |
| PFOA + PFOS | ≤0.00007 mg/L | 70 ppt combined |
| THMs | ≤0.08 mg/L | |

## Wastewater Discharge Standards

### Typical Municipal WWTP Effluent Limits

| Parameter | Secondary | Tertiary/Reuse | Advanced |
|-----------|-----------|----------------|----------|
| BOD₅ (mg/L) | ≤30 | ≤10 | ≤5 |
| TSS (mg/L) | ≤30 | ≤10 | ≤5 |
| NH₃-N (mg/L) | Monitor | ≤2 | ≤1 |
| TN (mg/L) | Monitor | ≤10 | ≤3 |
| TP (mg/L) | Monitor | ≤1 | ≤0.1 |
| Turbidity (NTU) | — | ≤2 | ≤0.5 |
| E. coli (CFU/100mL) | ≤200 | ≤2.2 | ND |
| Residual Cl₂ (mg/L) | — | 0.5-1.0 | — |

### Taiwan EPA Effluent Standards (Selected)

| Parameter | Standard |
|-----------|----------|
| BOD₅ | ≤30 mg/L |
| COD | ≤100 mg/L |
| TSS | ≤30 mg/L |
| NH₃-N | ≤10 mg/L |
| TN | — (monitoring) |
| TP | ≤4 mg/L |
| True color | ≤550 (Pt-Co) |

## Drinking Water Treatment Processes

### Conventional Treatment Train

```
Intake → Screening → Coagulation/Flocculation → Sedimentation → Filtration → Disinfection → Storage → Distribution
```

### Advanced Treatment Options

| Process | Target | Typical Application |
|---------|--------|---------------------|
| GAC adsorption | Organics, taste/odor, PFAS | After filtration |
| Ozone | Disinfection, taste/odor, micropollutants | Pre- or intermediate ozonation |
| UV | Crypto/Giardia inactivation | Post-filtration |
| Membrane filtration (MF/UF) | Particles, pathogens | Replace or supplement conventional |
| NF/RO | TDS, hardness, micropollutants | Desalination, softening |
| IX (anion) | Nitrate, PFAS, arsenic | Targeted contaminant removal |

### Disinfection

| Method | CT for 3-log Giardia (mg·min/L) | Pros | Cons |
|--------|----------------------------------|------|------|
| Free chlorine | ~45 (pH 7, 15°C) | Residual, inexpensive | DBP formation, taste |
| Chloramine | ~750 | Stable residual, low DBPs | Weaker oxidant, nitrification |
| Ozone | ~0.5 | Strong oxidant, no residual | Bromate formation, cost |
| UV | 40 mJ/cm² (dose, not CT) | No chemicals, effective for Crypto | No residual, lamp maintenance |
| ClO₂ | ~15 | Effective, low THMs | Chlorite/chlorate byproducts |

## Wastewater Treatment Processes

### Activated Sludge Variants

| Process | Configuration | Strengths |
|---------|--------------|-----------|
| Conventional AS | Aeration basin + secondary clarifier | Reliable BOD/TSS removal |
| A²O (Anaerobic-Anoxic-Oxic) | Three-zone BNR | N and P removal |
| Bardenpho (5-stage) | A-Anox-O-Anox-O | Enhanced N removal |
| SBR | Fill-react-settle-decant cycles | Flexible, small footprint |
| MBR | Aeration + submerged membranes | Excellent effluent, small footprint |
| MBBR | Biofilm carriers in aeration | Compact, retrofit-friendly |
| Oxidation ditch | Extended aeration loop | Simple, low sludge |

### Nutrient Removal

**Nitrogen removal**: Nitrification (NH₄⁺ → NO₃⁻, aerobic, Nitrosomonas/Nitrobacter) followed by denitrification (NO₃⁻ → N₂, anoxic, carbon source required).

**Phosphorus removal**:
- Biological: Enhanced biological phosphorus removal (EBPR) — anaerobic/aerobic cycling, PAOs accumulate poly-P
- Chemical: Alum, ferric chloride, or ferric sulfate precipitation; typically 1.5-2.0 mol Fe/mol P

### Tertiary Treatment

| Process | Purpose |
|---------|---------|
| Dual media filtration | TSS polishing |
| Cloth disk filter | TSS polishing, low head loss |
| UV disinfection | Pathogen inactivation |
| Chlorination/dechlorination | Disinfection with residual |
| GAC/BAC | Organics, micropollutants |
| Ozone + BAC | Advanced micropollutant removal |

## Sludge Management

### Typical Sludge Quantities

- Primary sludge: 150-350 g dry solids/m³ raw wastewater
- WAS (waste activated sludge): 70-150 g DS/m³ at 0.5-1.5% solids
- Combined: typically 200-400 g DS/m³

### Treatment Train

```
Thickening (3-6% DS) → Digestion (anaerobic, 15-20 day HRT) → Dewatering (20-30% DS) → Disposal/Reuse
```

## Emerging Contaminants

### PFAS (Per- and Polyfluoroalkyl Substances)

- EPA MCL (2024): PFOA 4 ppt, PFOS 4 ppt
- Treatment: GAC (EBCT 10-20 min, frequent replacement), single-use IX (selective resins), RO/NF (>95% rejection)
- Challenge: short-chain PFAS harder to remove; destruction technologies emerging (electrochemical, supercritical water)

### Microplastics

- No regulatory limit yet; MF/UF effectively removes >90%
- Conventional treatment (coagulation + filtration) removes 70-80%

### Pharmaceuticals and Personal Care Products (PPCPs)

- Ozone + BAC: most effective broad-spectrum removal
- GAC: effective but requires frequent replacement
- Conventional treatment: variable, compound-dependent

---

## Related References

- [technologies.md](technologies.md) — Detailed technology specs for GAC, ozone, UV, membranes, IX, coagulation, biological treatment
- [reuse.md](reuse.md) — Tertiary effluent as reuse source: potable reuse pathways, multi-barrier design, PFAS in reuse
- [troubleshooting.md](troubleshooting.md) — Biological treatment diagnostics (activated sludge, filamentous organisms, nutrient removal)
- [desalination.md](desalination.md) — Membrane processes for drinking water (NF/RO for TDS, hardness, micropollutants)
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — ESG reporting, carbon accounting for water utilities, regulatory compliance automation
