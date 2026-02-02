# Industrial Water Treatment Reference

## Table of Contents

1. [Cooling Water](#cooling-water)
2. [Boiler Water](#boiler-water)
3. [Process Water](#process-water)
4. [Water Reuse and Zero Liquid Discharge](#water-reuse-and-zero-liquid-discharge)

## Cooling Water

### Open Recirculating (Cooling Tower) Systems

#### Makeup Water Quality Guidelines

| Parameter | Typical Limit | Notes |
|-----------|--------------|-------|
| TDS | <1500 mg/L | Depends on cycles of concentration |
| Hardness (CaCO₃) | <500 mg/L | Scale control dependent |
| Alkalinity (CaCO₃) | <500 mg/L | |
| Silica | <150 mg/L | Limit in circulating water |
| TSS | <25 mg/L | Fouling prevention |
| pH | 7.0-9.0 | Treatment program dependent |

#### Cycles of Concentration (CoC)

```
CoC = Circulating water TDS / Makeup TDS
    = Makeup flow / Blowdown flow

Makeup = Evaporation + Blowdown + Drift + Leaks
Blowdown = Evaporation / (CoC - 1)
```

Typical CoC: 3-7 (higher = less water waste, but higher scaling/corrosion risk).

#### Common Problems and Indicators

| Problem | Indicators | Common Causes |
|---------|-----------|---------------|
| Scaling (CaCO₃) | Reduced heat transfer, deposits on fill | High hardness, high pH, high CoC |
| Silica scaling | Hard glassy deposits | Silica >150 mg/L in circ water |
| Biofouling | Slime, Legionella risk, MIC | Inadequate biocide, warm temperatures |
| Corrosion | Metal loss, red/brown deposits | Low pH, high chlorides, MIC |
| Fouling | TSS accumulation, reduced efficiency | Poor filtration, airborne debris |

#### Chemical Treatment Programs

| Program | Components | Application |
|---------|-----------|-------------|
| Phosphate-based | Orthophosphate + polymer + biocide | General corrosion/scale inhibition |
| All-organic | Phosphonates + polymers + azoles | Low-P discharge areas |
| Stabilized phosphate | Polyphosphate + zinc + polymer | Mild to moderate conditions |
| Silica-based | Silicate + polymer | Potable water systems |

Biocide programs: Oxidizing (chlorine, bromine, ClO₂) + non-oxidizing (isothiazolone, glutaraldehyde, DBNPA) on alternating schedule.

### Legionella Risk Management

- Maintain circulating water temperature <20°C or >60°C where possible
- Free chlorine residual 0.5-1.0 mg/L or equivalent oxidant
- Monitor for Legionella: action level typically >1000 CFU/L
- Drift eliminators: reduce aerosol emissions to <0.001% of circulating flow

## Boiler Water

### ASME/ABMA Guidelines by Pressure

| Parameter | 0-20 bar | 20-40 bar | 40-60 bar | >60 bar |
|-----------|----------|-----------|-----------|---------|
| Feedwater TDS (mg/L) | <700 | <300 | <50 | <0.05 |
| Feedwater Hardness | <1 mg/L | <0.1 mg/L | ND | ND |
| Feedwater DO (mg/L) | <0.04 | <0.007 | <0.007 | <0.005 |
| Feedwater Fe (mg/L) | <0.1 | <0.05 | <0.02 | <0.01 |
| Boiler water TDS | <3500 | <2500 | <1500 | <0.5 |
| Boiler water silica | <150 | <90 | <10 | <0.02 |
| Boiler water pH | 10.0-11.5 | 10.0-11.0 | 9.5-10.5 | 9.0-9.6 |

ND = Non-detectable

### Feedwater Treatment Train

```
Low Pressure:  Softening → Deaeration → Chemical treatment
Medium:        Softening → RO → Deaeration → Chemical treatment
High Pressure: RO → EDI/MB-IX → Deaeration → Minimal chemical
```

### Common Boiler Problems

| Problem | Cause | Prevention |
|---------|-------|------------|
| Scale (CaCO₃, CaSO₄) | Hardness in feedwater | Softening, phosphate treatment |
| Silica scale/carryover | High silica, high pH | Silica monitoring, blowdown control |
| Oxygen corrosion | Dissolved O₂ in feedwater | Deaeration, chemical scavenger (sulfite, DEHA) |
| Caustic embrittlement | High NaOH concentration | Coordinated phosphate program |
| Carryover | High TDS, mechanical issues | Blowdown, antifoam, drum internals |
| Return line corrosion | CO₂ in condensate | Neutralizing amines, filming amines |

### Condensate Return

- Pure condensate: TDS <10 µS/cm, near-zero hardness
- Contamination indicators: sudden conductivity rise, hardness, pH drop
- Treatment: polishing with MB-IX, filming amines for corrosion protection
- Typical return rate target: >80% of steam produced

## Process Water

### Food & Beverage

| Application | Typical Requirement |
|-------------|-------------------|
| Ingredient water | Potable + specific mineral profile |
| CIP rinse | Low TDS (<50 mg/L), no chlorine |
| Boiler feed | Softened or RO permeate |
| Cooling | Standard cooling tower treatment |
| Bottle rinse | Ozonated RO permeate |

### Pharmaceutical (USP Purified Water / WFI)

| Parameter | USP Purified Water | WFI |
|-----------|-------------------|-----|
| Conductivity (25°C) | ≤1.3 µS/cm (Stage 1) | ≤1.3 µS/cm |
| TOC | ≤500 ppb | ≤500 ppb |
| Bacteria | ≤100 CFU/mL | ≤10 CFU/100mL |
| Endotoxin | — | ≤0.25 EU/mL |
| Distribution | Ambient or cold | Hot (>70°C) or ozonated loop |

### Power Generation

| System | Water Quality | Treatment |
|--------|--------------|-----------|
| Cooling (once-through) | Surface water with screening | Chlorination, debris filter |
| Cooling tower | See cooling water section | Full chemical program |
| High-pressure boiler | <0.1 µS/cm, <3 ppb silica | RO + MB-IX + deaeration |
| FGD (flue gas desat.) | Process water, high TDS tolerant | pH control, gypsum management |

## Water Reuse and Zero Liquid Discharge

### Treatment for Reuse

```
Secondary Effluent → MF/UF → RO → UV/AOP → Reuse
```

Recovery: 75-85% for single-pass RO, 90-95% with concentrate treatment.

### ZLD Train

```
Wastewater → Pretreatment → RO (75-85%) → Brine Concentrator (95-98%) → Crystallizer → Solid Waste
```

| Stage | Technology | Concentrate Factor | Energy (kWh/m³ feed) |
|-------|-----------|-------------------|---------------------|
| Primary RO | Membrane | 4-6× | 1-3 |
| High-recovery RO | CCRO, OARO | 10-20× | 3-6 |
| Brine concentrator | MVR evaporator | 50-100× | 20-40 |
| Crystallizer | Forced circulation | To solids | 50-80 |
| Evaporation pond | Solar | To solids | ~0 (land cost) |

### Key Design Considerations

- Antiscalant selection critical for high-recovery RO (silica, CaSO₄, BaSO₄ limiting)
- Seed precipitation or softening between RO stages
- MVR brine concentrators: stainless/titanium construction, 20-25% DS output
- Crystallizer: mixed salt disposal or selective salt recovery
- Total ZLD cost: 5-15× conventional discharge treatment

---

## Related References

- [technologies.md](technologies.md) — RO, EDI, IX, UF fundamentals and design parameters
- [reuse.md](reuse.md) — Broader water reuse context: municipal-to-industrial, potable reuse, treatment building blocks
- [desalination.md](desalination.md) — SWRO/BWRO design, concentrate management, thermal desalination
- [semiconductor.md](semiconductor.md) — UPW specifications (compare with pharmaceutical WFI requirements)
- [troubleshooting.md](troubleshooting.md) — Cooling water, RO, and boiler system diagnostics
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — ESG carbon accounting for industrial water systems, LCA methodology
