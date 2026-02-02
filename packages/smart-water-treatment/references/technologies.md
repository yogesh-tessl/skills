# Water Treatment Technologies Reference

## Table of Contents

1. [Membrane Processes](#membrane-processes)
2. [Ion Exchange](#ion-exchange)
3. [Electrochemical Processes](#electrochemical-processes)
4. [Adsorption](#adsorption)
5. [Chemical Treatment](#chemical-treatment)
6. [Biological Treatment](#biological-treatment)
7. [Advanced Oxidation Processes](#advanced-oxidation-processes)
8. [Disinfection](#disinfection)
9. [Solids Separation](#solids-separation)

## Membrane Processes

### Comparison Matrix

| Technology | Pore/MWCO | Driving Force | Rejects | Typical Flux | Operating Pressure |
|-----------|-----------|---------------|---------|-------------|-------------------|
| MF | 0.1-10 µm | Pressure | Particles, bacteria | 50-150 LMH | 0.1-2 bar |
| UF | 1-100 kDa | Pressure | Colloids, viruses, proteins | 30-100 LMH | 0.5-5 bar |
| NF | 200-1000 Da | Pressure | Divalent ions, organics >200 Da | 20-40 LMH | 5-15 bar |
| RO | ~100 Da | Pressure | >95% of all dissolved solids | 15-30 LMH | 10-70 bar |
| FO | N/A | Osmotic gradient | Similar to RO | 5-15 LMH | ~0 (hydraulic) |
| ED/EDR | N/A | Electrical | Ions only | N/A | N/A |

LMH = L/m²/h

### Reverse Osmosis (RO)

**Membrane types**: Thin-film composite (TFC) polyamide — spiral wound (most common), hollow fiber, tubular.

**Key design parameters**:
- Recovery: 50-85% (application dependent)
- Flux: 15-25 LMH (brackish), 12-18 LMH (seawater)
- Salt rejection: 99.0-99.8% (single element)
- Feed SDI: <5 (ideally <3)
- Feed turbidity: <1 NTU
- Free chlorine: 0 mg/L (polyamide membranes)

**Fouling types and indicators**:

| Fouling Type | Indicators | Location | Cleaning |
|-------------|-----------|----------|----------|
| Biofouling | ΔP increase (lead element), flux decline | Lead elements | High-pH + biocide |
| Colloidal/particulate | ΔP increase, flux decline | Lead elements | High-pH alkaline |
| Organic | Flux decline, salt passage increase | Throughout | High-pH + surfactant |
| Mineral scale (CaCO₃) | Salt passage increase, flux decline | Tail elements | Low-pH acid (HCl, citric) |
| Silica scale | ΔP increase, flux decline | Tail elements | High-pH (pH>11) + warm |
| Metal oxide (Fe, Mn) | Color, ΔP increase | Lead elements | Low-pH + reducing agent |

**Normalization**: Always normalize flux, ΔP, and salt passage to reference conditions (temperature, pressure, recovery) before trending. A 10-15% decline from baseline warrants investigation.

### Ultrafiltration (UF)

**Configurations**: Outside-in hollow fiber (most common for water), inside-out, submerged.

**Operating modes**: Dead-end (most MF/UF), crossflow (high-solids).

**Backwash**: Every 15-60 min, 1-3× forward flux, 15-60 seconds.

**CEB/CIP**: Chemically enhanced backwash (daily-weekly), full CIP (monthly-quarterly). Typically NaOCl + NaOH (organic/bio) or citric acid (inorganic).

**Integrity testing**: Pressure decay test (PDT), bubble point, particle counting post-membrane.

## Ion Exchange

### Resin Types

| Type | Functional Group | Capacity (eq/L) | Application |
|------|-----------------|-----------------|-------------|
| SAC (Strong Acid Cation) | -SO₃H | 1.8-2.2 | Softening, demineralization |
| WAC (Weak Acid Cation) | -COOH | 3.5-4.5 | Dealkalization, partial softening |
| SBA (Strong Base Anion) | -N(CH₃)₃OH | 1.0-1.4 | Demineralization, silica removal |
| WBA (Weak Base Anion) | -NH₂, -NHR | 1.5-2.0 | Acid absorption (after SAC) |
| Mixed Bed | SAC + SBA | — | Polishing to >18 MΩ·cm |
| Chelating | Iminodiacetic | 0.6-1.0 | Selective heavy metal removal |
| Boron-selective | N-methyl-D-glucamine | 0.5-0.7 | Boron removal |
| PFAS-selective | Quaternary amine (gel) | — | PFAS removal (single-use) |

### Regeneration

- SAC: HCl or H₂SO₄ (H-form) or NaCl (Na-form for softening)
- SBA: NaOH (warm, 40-50°C for best silica elution)
- Co-current vs. counter-current: counter-current gives lower leakage
- Regenerant dosage: 1.5-3× stoichiometric for good efficiency

### Key Design Parameters

- Bed depth: minimum 800mm, typical 1000-1500mm
- Flow rate: 10-40 BV/h (service), 2-5 BV/h (regeneration)
- Rinse: slow rinse (1-2 BV) + fast rinse (3-6 BV)

## Electrochemical Processes

### EDI (Electrodeionization)

- Combines IX resin, ion-selective membranes, and DC current
- Continuous production of high-purity water without chemical regeneration
- Feed requirements: <20 µS/cm, <1 ppm CO₂, <0.01 ppm hardness, <0.5 ppm silica, <0.5 ppm TOC
- Product: 0.055-16+ MΩ·cm
- Power: 0.1-0.3 kWh/m³

### ED/EDR (Electrodialysis/Reversal)

- Selective ion removal using ion-exchange membranes and DC field
- Reversal (EDR): periodic polarity switch reduces scaling
- Best for: brackish water desalination (TDS 1000-5000 mg/L), selective removal
- Does NOT remove uncharged species (silica, organics, bacteria)
- Energy proportional to TDS removed (more efficient than RO at low TDS removal)

## Adsorption

### Granular Activated Carbon (GAC)

- Applications: NOM, taste/odor (geosmin, MIB), micropollutants, PFAS
- EBCT: 5-20 minutes (longer for PFAS)
- Reactivation: thermal (kiln at 800-900°C) or replace
- Capacity highly compound-dependent; isotherm testing recommended

### Powdered Activated Carbon (PAC)

- Dosed directly into treatment process (0.5-50 mg/L)
- Advantages: flexible dosing, no separate contactor
- Disadvantages: single-use, interference with coagulation, sludge increase

## Chemical Treatment

### Coagulation/Flocculation

| Coagulant | Typical Dose | pH Range | Notes |
|-----------|-------------|----------|-------|
| Alum (Al₂(SO₄)₃) | 10-50 mg/L | 5.5-7.5 | Most common, consumes alkalinity |
| Ferric chloride (FeCl₃) | 10-40 mg/L | 4.0-9.0 | Wider pH range, good for NOM |
| Ferric sulfate | 10-40 mg/L | 4.0-9.0 | Similar to FeCl₃ |
| PACl | 5-30 mg/L | 5.0-8.0 | Pre-hydrolyzed, less pH impact |
| Polymer (cationic) | 0.5-5 mg/L | — | Coagulant aid, charge neutralization |
| Polymer (anionic) | 0.1-1 mg/L | — | Flocculant aid, bridging |

**Jar testing**: Essential for dose optimization. Test at multiple doses, measure settled turbidity, residual coagulant, and NOM removal (UV254).

### pH Adjustment

| Chemical | Form | Adjustment | Notes |
|----------|------|------------|-------|
| NaOH | 50% liquid, pellets | Raise pH | Strong base, rapid |
| Ca(OH)₂ | Slurry (lime) | Raise pH | Less expensive, adds hardness |
| Na₂CO₃ | Powder, solution | Raise pH | Adds alkalinity |
| H₂SO₄ | 93-98% | Lower pH | Most common acid |
| HCl | 31-37% | Lower pH | Adds chloride |
| CO₂ | Gas | Lower pH | Mild, adds carbonate alkalinity |

### Precipitation

- **Softening**: Lime-soda (Ca(OH)₂ + Na₂CO₃) removes Ca and Mg hardness
- **Heavy metals**: Hydroxide precipitation (pH 8-11), sulfide precipitation (lower solubility)
- **Fluoride**: CaCl₂ or lime precipitation, followed by alum coagulation
- **Phosphorus**: FeCl₃ or alum at 1.5-2.0 molar ratio metal:P

## Biological Treatment

### Aerobic Processes

| Process | SRT (days) | F/M (kg BOD/kg MLSS/d) | MLSS (mg/L) | Application |
|---------|-----------|------------------------|-------------|-------------|
| Conventional AS | 5-15 | 0.2-0.5 | 1500-3000 | BOD removal |
| Extended aeration | 15-30 | 0.04-0.1 | 3000-6000 | BOD + nitrification |
| MBR | 10-25 | 0.05-0.2 | 8000-15000 | High-quality effluent |
| MBBR | 5-15 | — | — (biofilm) | Compact, retrofit |

### Anaerobic Processes

| Process | HRT | OLR (kg COD/m³/d) | Application |
|---------|-----|-------------------|-------------|
| UASB | 4-12 h | 5-15 | High-strength industrial |
| IC reactor | 2-6 h | 15-35 | Very high-strength |
| Anaerobic MBR | 12-48 h | 2-10 | Moderate strength |
| CSTR | 15-30 d | 1-5 | Sludge digestion |

Biogas production: ~0.35 m³ CH₄/kg COD removed (theoretical).

## Advanced Oxidation Processes

### AOP Comparison

| Process | OH• Generation | Typical Application | Energy |
|---------|---------------|-------------------|--------|
| O₃/H₂O₂ | O₃ + H₂O₂ → OH• | Micropollutants in drinking water | Moderate |
| UV/H₂O₂ | H₂O₂ + UV → 2 OH• | Groundwater remediation, 1,4-dioxane | High UV dose |
| UV/O₃ | O₃ + UV → O• + O₂ → OH• | Advanced treatment | High |
| Fenton | Fe²⁺ + H₂O₂ → OH• + Fe³⁺ | Industrial WW, low pH required | Low energy, high chemical |
| Photo-Fenton | Fe²⁺ + H₂O₂ + UV | Enhanced Fenton | Moderate |
| UV/TiO₂ | TiO₂ + UV → e⁻/h⁺ → OH• | Emerging, research stage | |
| UV/chlorine | HOCl + UV → OH• + Cl• | Potable reuse | Moderate |

### Design Considerations

- Scavenging: alkalinity, NOM compete for OH•; higher scavenging = higher dose needed
- Contact time: typically seconds to minutes
- H₂O₂ residual: must be quenched (GAC or enzymatic) before biological treatment or distribution
- Bromate: concern with ozone-based AOPs when bromide >50 µg/L

## Disinfection

See municipal.md for detailed disinfection comparison. Key technologies:

- Chlorination (gas, hypochlorite, on-site generation)
- UV (low-pressure LP, medium-pressure MP, LP amalgam)
- Ozone
- Chloramine
- Chlorine dioxide

## Solids Separation

### Clarification

| Technology | Surface Loading (m/h) | Application |
|-----------|----------------------|-------------|
| Conventional sedimentation | 1-2.5 | General |
| Lamella/plate settler | 3-6 (based on projected area) | Compact |
| DAF (dissolved air flotation) | 5-15 | Low-density floc, algae |
| Ballasted floc (Actiflo) | 20-40 | High-rate, compact |
| Contact clarification | 5-10 | Upflow through sludge blanket |

### Filtration

| Technology | Rate (m/h) | Media | Application |
|-----------|-----------|-------|-------------|
| Rapid gravity filter | 5-15 | Sand, anthracite, GAC | Conventional WTP |
| Pressure filter | 5-20 | Sand, multimedia | Industrial, small systems |
| Greensand filter | 5-10 | Manganese greensand | Fe/Mn removal |
| Slow sand filter | 0.1-0.3 | Fine sand + biofilm | Small/rural systems |
| Cloth/disk filter | 5-15 | Woven polyester | Tertiary polishing |

---

## Related References

**Application-specific design and sizing:**
- [desalination.md](desalination.md) — SWRO/BWRO system design, pretreatment selection, CIP protocols, energy recovery
- [semiconductor.md](semiconductor.md) — UPW-grade RO, EDI, MB-IX, UF polishing specifications
- [municipal.md](municipal.md) — Coagulation in drinking water, biological treatment variants, disinfection CT values
- [industrial.md](industrial.md) — Cooling/boiler water treatment, ZLD trains
- [reuse.md](reuse.md) — Treatment building blocks for reuse: UF→RO→UV/AOP pathways

**Diagnostics and troubleshooting:**
- [troubleshooting.md](troubleshooting.md) — RO fouling diagnosis, EDI/IX troubleshooting, biological treatment problems
