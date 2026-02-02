# Troubleshooting Reference

## Table of Contents

1. [Diagnostic Framework](#diagnostic-framework)
2. [RO System Troubleshooting](#ro-system-troubleshooting)
3. [EDI Troubleshooting](#edi-troubleshooting)
4. [Ion Exchange Troubleshooting](#ion-exchange-troubleshooting)
5. [Cooling Water Troubleshooting](#cooling-water-troubleshooting)
6. [Biological Treatment Troubleshooting](#biological-treatment-troubleshooting)
7. [UPW System Troubleshooting](#upw-system-troubleshooting)

## Diagnostic Framework

### Step 1: Define the Problem

- What parameter is out of spec? By how much?
- When did it start? Sudden or gradual?
- What changed recently? (maintenance, chemical, seasonal, operational)
- Is it continuous or intermittent?

### Step 2: Gather Data

- Trend the affected parameter over time (hours, days, weeks)
- Compare with related parameters (e.g., conductivity + flow + pressure + temperature)
- Check upstream and downstream systems
- Review maintenance and chemical logs

### Step 3: Hypothesize and Test

- List possible causes ranked by likelihood
- For each hypothesis, identify confirming/disconfirming evidence
- Test the most likely cause first (least invasive test preferred)
- Avoid shotgun approaches (changing multiple variables simultaneously)

### Step 4: Implement and Verify

- Make one change at a time when possible
- Monitor the affected parameter after each change
- Confirm the root cause is addressed, not just the symptom
- Document findings for future reference

## RO System Troubleshooting

### Normalized Data Interpretation

Always normalize before diagnosing. Compare against baseline (first 48h of operation with new membranes).

| Observation (Normalized) | Likely Cause | Confirm With |
|--------------------------|-------------|--------------|
| Flux ↓, ΔP ↑, SP → | Colloidal/particulate fouling | SDI test, element autopsy |
| Flux ↓, ΔP ↑ (lead), SP → | Biofouling | Biofilm check, ATP test |
| Flux ↓, ΔP →, SP ↑ | Organic fouling | TOC trend, element weight |
| Flux ↓, ΔP ↑ (tail), SP ↑ | Mineral scaling | LSI/S&DSI calc, tail element inspection |
| Flux →, ΔP →, SP ↑ | Membrane degradation | Chlorine exposure check, probing test |
| Flux →, ΔP →, SP ↑ (sudden) | O-ring leak, telescope damage | Probing test, visual inspection |

SP = Salt Passage; ΔP = Differential Pressure

### Common RO Issues

**High salt passage (gradual)**:
- Membrane oxidation (chlorine, ozone exposure)
- Membrane hydrolysis (pH excursion >12 or <2)
- Organic fouling compacting rejection layer
- Action: Check ORP logs, pH logs, clean, test individual elements

**High salt passage (sudden)**:
- O-ring failure or misalignment
- Telescoping (excessive ΔP)
- Membrane tear
- Action: Probing test to identify failed position, inspect and replace

**Permeate conductivity rising after cleaning**:
- Aggressive cleaning damaged membranes
- Incomplete rinsing (cleaning chemical residual)
- Biofilm removal exposed degraded membrane beneath
- Action: Extended flush, retest, element autopsy if persistent

**Rapid ΔP increase**:
- Check pretreatment (cartridge filter ΔP, coagulation upset)
- Biofouling (especially in warm water >25°C)
- Particulate fouling from upstream upset
- Action: Clean, investigate and fix pretreatment

### CIP Effectiveness

Post-CIP targets (compared to baseline):
- Normalized flux: recover to >90% of baseline
- Normalized ΔP: within 15% of baseline
- Normalized SP: within 10% of baseline
- If not met after 2 CIP cycles, consider membrane replacement or alternative cleaning chemistry

## EDI Troubleshooting

| Symptom | Possible Cause | Action |
|---------|---------------|--------|
| Product quality declining | Hardness in feed, resin exhaustion | Check feed hardness (<0.01 ppm), verify current |
| High ΔP across stack | Particulate fouling, scaling | Inspect prefilter, check feed quality |
| Low current/high voltage | Scaling (silica, carbonate) | CIP with acid or alkali |
| High current/low voltage | Short circuit, damaged membranes | Inspect stack, check for leaks |
| Module leaking | Gasket failure, cracked endplate | Inspect, retorque or replace gaskets |

Feed water requirements:
- Conductivity <20 µS/cm (ideally <10)
- Hardness <0.01 mg/L as CaCO₃
- CO₂ <5 ppm (ideally <3)
- Silica <0.5 ppm
- TOC <0.5 ppm
- Temperature 5-40°C
- pH 5-9 (ideally 6-8)

## Ion Exchange Troubleshooting

| Symptom | Possible Cause | Action |
|---------|---------------|--------|
| Short run length | Resin fouling, poor regeneration, channeling | Check regen dose, inspect bed, test resin |
| High leakage | Co-current regen, exhausted resin, channeling | Switch to counter-current, replace resin |
| Resin fines in effluent | Osmotic shock, oxidation, attrition | Check for chlorine, reduce backwash velocity |
| High ΔP | Resin fouling (Fe, organics), compaction | Backwash, chemical clean, check for fines accumulation |
| Poor silica removal (SBA) | Low regenerant temperature, insufficient NaOH | Regen at 40-50°C, increase NaOH dose |

### Resin Testing

- Visual inspection: color change, cracking, fines
- Capacity test: total and salt-splitting capacity
- Kinetics: rinse volume, breakthrough curve shape
- Fouling tests: iron, organic loading

## Cooling Water Troubleshooting

| Problem | Diagnosis | Action |
|---------|----------|--------|
| White scale on heat exchangers | CaCO₃ — check LSI >0, Ca and alkalinity | Increase acid feed, lower CoC, add scale inhibitor |
| Hard glassy deposits | Silica scale — check SiO₂ >150 mg/L | Lower CoC, add silica dispersant |
| Orange/brown deposits | Iron fouling or corrosion products | Check Fe source (makeup vs. system), add dispersant |
| Slime/biofilm | Inadequate biocide, warm stagnant areas | Slug dose biocide, clean towers, increase program |
| Pitting corrosion (copper) | High chloride, low pH, MIC | Review chemistry, add corrosion inhibitor, check biocontrol |
| White rust (galvanized) | Passivation failure, high pH | Maintain pH <8.5 for new galvanized, ensure chromate/phosphate program |

### Corrosion Monitoring

- Corrosion coupons: mild steel <3 mpy, copper <0.1 mpy targets
- LPR (linear polarization resistance): online, real-time trend
- Water analysis: Fe, Cu levels in circulating water
- Visual inspection: heat exchanger tubes, tower fill

## Biological Treatment Troubleshooting

### Activated Sludge

| Problem | Likely Causes | Diagnostics |
|---------|--------------|-------------|
| Bulking sludge (SVI >150) | Filamentous organisms, low DO, low F/M, nutrient deficiency | Microscopy, SVI, DO profile, N:P check |
| Rising sludge in clarifier | Denitrification in clarifier, septic sludge | NO₃ test in clarifier, reduce SRT, increase RAS |
| Foaming (brown, viscous) | Nocardia/Microthrix, long SRT, fats/oils | Microscopy, reduce SRT, spray water, wasting |
| Pin floc/dispersed growth | Low SRT, toxicity, low nutrients | Increase SRT, check for toxics, verify N and P |
| Poor nitrification | Low DO (<2 mg/L), low SRT, inhibition, cold temp | DO profile, check alkalinity (7.1 mg CaCO₃/mg NH₄-N), temperature |
| Effluent TSS high | Clarifier overload, short-circuiting, sludge bulking | Check SLR, flow distribution, SVI |

### Microscopy Quick Reference

| Organism/Structure | Indicates |
|-------------------|-----------|
| Diverse protozoa (stalked ciliates, rotifers) | Healthy, well-settling sludge |
| Free-swimming ciliates dominant | Young sludge, low SRT |
| Filaments (Thiothrix, Type 021N) | Low DO or sulfide present |
| Filaments (Microthrix parvicella) | Low F/M, fats/oils |
| Filaments (Type 0041, 0675) | Low F/M, extended aeration |
| Nematodes | Old sludge, very long SRT |
| Ameoba dominant | Startup or upset conditions |

## UPW System Troubleshooting

### Resistivity Drop at POU

| Severity | Possible Source | Investigation |
|----------|---------------|---------------|
| 18.2 → 17-18 MΩ·cm | CO₂ ingress, trace ion leakage | Check degasifier performance, MB resin, EDI |
| 18.2 → 14-16 MΩ·cm | Significant ionic contamination | Check RO rejection, EDI performance, resin exhaustion |
| 18.2 → <10 MΩ·cm | Major system upset | Check for chemical contamination, valve failure, cross-connection |
| Intermittent drops | Dead legs, stagnant zones, instrument drift | Flow verification, instrument calibration, system mapping |

### TOC Excursion

| Source | Investigation | Fix |
|--------|-------------|-----|
| Makeup water | Check RO permeate TOC, source water change | Optimize RO, add pre-treatment |
| System materials | New piping, gaskets, or fittings | Extended flush, material qualification |
| Biofilm | ATP test, microbiological sampling | UV dose increase, hot water sanitization, ozone treatment |
| UV lamp degradation | Check 185nm output, lamp hours | Replace lamp, check quartz sleeve fouling |
| Chemical contamination | Trace to specific time/event | Identify source, isolate, flush |

### Particle Excursion

| Source | Investigation | Fix |
|--------|-------------|-----|
| UF fiber break | Integrity test (PDT, particle spike) | Replace module, check for root cause |
| Resin fines | Check post-MB filter, backwash history | Improve resin retention, add fine filter |
| Construction debris | Recent maintenance work | Extended flush, filter check |
| Biofilm sloughing | Microbiological sampling | Sanitization, review sanitization frequency |
| Precipitation | Check for silica, metals at saturation | Review chemistry, temperature changes |

### Dissolved Oxygen Excursion

| Source | Investigation | Fix |
|--------|-------------|-----|
| Membrane contactor degradation | Check N₂ sweep pressure, fiber condition | Replace contactor, increase N₂ flow |
| Air ingress at fittings | Pressurize system, check connections | Retighten, replace gaskets |
| Tank headspace | Check N₂ blanket, vent configuration | Verify N₂ pressure, seal integrity |
| Pump cavitation | Check NPSH, listen for noise | Fix suction conditions, replace seals |

---

## Related References

**Technology fundamentals:**
- [technologies.md](technologies.md) — RO membrane types, fouling mechanisms, IX resin properties, biological process parameters
- [desalination.md](desalination.md) — SWRO-specific fouling, CIP protocols, scaling risks by recovery

**Application context:**
- [semiconductor.md](semiconductor.md) — UPW specifications and system architecture for Section 7 diagnostics
- [industrial.md](industrial.md) — Cooling water chemistry for Section 5, boiler water fundamentals
- [municipal.md](municipal.md) — Activated sludge process variants for Section 6 biological diagnostics

**Knowledge capture:**
- [delivery-and-ops.md](delivery-and-ops.md) — Knowledge graph construction for capturing troubleshooting history and institutional knowledge
