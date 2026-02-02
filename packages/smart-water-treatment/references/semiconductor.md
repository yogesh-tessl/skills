# Semiconductor Ultrapure Water (UPW) Reference

## Table of Contents

1. [SEMI Standards Overview](#semi-standards-overview)
2. [UPW Quality Specifications](#upw-quality-specifications)
3. [Typical UPW System Architecture](#typical-upw-system-architecture)
4. [Critical Parameters by Node](#critical-parameters-by-node)
5. [Advanced Node Requirements](#advanced-node-requirements)
6. [Common UPW Subsystems](#common-upw-subsystems)

## SEMI Standards Overview

### SEMI F63 — UPW Quality Guide

The primary industry standard for semiconductor-grade ultrapure water. Key parameters at point of use (POU):

| Parameter | SEMI F63 (Advanced) | Leading-Edge Target |
|-----------|---------------------|---------------------|
| Resistivity | ≥18.18 MΩ·cm | ≥18.2 MΩ·cm |
| TOC | <1 ppb | <0.5 ppb |
| Particles ≥0.05 µm | <1 /mL | <0.1 /mL |
| Dissolved O₂ | <1 ppb | <0.5 ppb |
| Dissolved N₂ | <50 ppb | <20 ppb |
| Silica (total) | <0.5 ppb | <0.1 ppb |
| Metals (each) | <1 ppt | <0.1 ppt |
| Anions (each) | <10 ppt | <1 ppt |
| Bacteria | <0.001 CFU/mL | <0.0001 CFU/mL |
| Endotoxin | <0.001 EU/mL | <0.0005 EU/mL |

### Related SEMI Standards

- **SEMI F61**: Guide for ultrapure water system design
- **SEMI F57**: Specification for polymer materials used in UPW systems
- **SEMI C79**: Guide for chemical reagent purity
- **SEMI F40**: Practice for UPW quality monitoring

## UPW Quality Specifications

### By Technology Node

| Parameter | ≥28nm | 14-7nm | 5-3nm | ≤2nm |
|-----------|-------|--------|-------|------|
| Resistivity (MΩ·cm) | ≥18.18 | ≥18.18 | ≥18.2 | ≥18.2 |
| TOC (ppb) | <2 | <1 | <0.5 | <0.3 |
| Particles ≥50nm (/mL) | <3 | <1 | <0.3 | <0.1 |
| DO (ppb) | <3 | <1 | <0.5 | <0.3 |
| Total silica (ppb) | <1 | <0.5 | <0.1 | <0.05 |
| Metals total (ppt) | <100 | <10 | <5 | <1 |
| Boron (ppt) | <50 | <10 | <5 | <1 |

## Typical UPW System Architecture

### Pretreatment

```
Raw Water → Multimedia Filter → Activated Carbon → Softener/Antiscalant → Cartridge Filter
```

Purpose: Protect downstream membranes, remove bulk contaminants (turbidity, chlorine, hardness).

### Primary (Makeup) System

```
Cartridge Filter → 1st Pass RO → Degasifier → 2nd Pass RO → EDI → Primary Storage Tank
```

Purpose: Bulk ion removal, TOC reduction, dissolved gas removal.

### Polishing Loop

```
Primary Tank → UV (185nm TOC) → Mixed Bed Polish → Membrane Degasifier → UV (254nm) → UF (0.01µm) → POU
```

Purpose: Final polishing to meet POU specs; continuous recirculation.

### Reclaim/Recycle

```
Drain Water → Collection → Quality Segregation → Treatment → Return to Makeup or Polishing
```

Purpose: Maximize water recovery (target >90%); typical fab uses 8,000-15,000 m³/day.

## Critical Parameters by Node

### Resistivity
- Theoretical max at 25°C: 18.248 MΩ·cm (only H⁺ and OH⁻ present)
- Temperature compensated to 25°C
- Affected by: dissolved CO₂, trace ions, organics
- Measurement: inline, compensated, dual-cell for verification

### TOC
- Sources: system materials (PVDF, PE), biofilm, atmospheric ingress, chemical contamination
- Measurement: UV oxidation with conductivity detection or membrane conductometry
- Critical for: gate oxide integrity, photoresist adhesion

### Particles
- Sources: resin fines, membrane shedding, biofilm, precipitates, construction debris
- Counting: online laser particle counters (LPC) at ≥50nm or ≥30nm
- Critical for: defect density, yield

### Dissolved Oxygen
- Sources: air ingress at fittings, tank headspace, permeation through polymers
- Removal: vacuum degasifier, membrane degasifier (contactor), N₂ sparging
- Critical for: native oxide growth on Si wafers, Cu corrosion

### Metals (Boron, Silica, Fe, Cu, Zn, Na, K, etc.)
- Boron: difficult to remove by RO (small, uncharged at neutral pH); use high-pH 2nd pass RO or boron-selective resin
- Silica: colloidal silica passes RO; use UF + high-pH operation
- Measurement: ICP-MS for ppt-level detection

## Common UPW Subsystems

### Reverse Osmosis (RO)
- 1st pass: 75-80% recovery, rejects 95-99% of ions
- 2nd pass: pH elevated to 9-10 for boron/silica rejection, 85-90% recovery
- Membrane types: low-energy polyamide TFC
- Key concerns: biofouling, scaling (CaCO₃, silica), chlorine damage

### Electrodeionization (EDI)
- Combines IX resins with ion-selective membranes and DC current
- Produces 16-18+ MΩ·cm water continuously without chemical regeneration
- Feed: RO permeate with conductivity <20 µS/cm, CO₂ <5 ppm
- Concerns: hardness scaling, silica fouling, organic fouling

### Mixed-Bed Ion Exchange (MB-IX)
- Nuclear-grade resin, H⁺/OH⁻ form
- Polishes to >18.2 MΩ·cm
- Regenerated offsite (service DI) or in-situ
- Concerns: resin fines release, organic leaching, channeling

### UV Systems
- 185nm: TOC destruction (generates OH radicals)
- 254nm: Bacterial disinfection
- Sizing: dose in mJ/cm², flow-dependent
- Concerns: lamp aging, sleeve fouling, byproduct formation

### Ultrafiltration (UF)
- Final particle/bacteria barrier, 0.01-0.05 µm MWCO
- Hollow fiber, typically PVDF or PES
- Integrity tested by pressure decay or bubble point
- Concerns: organic fouling, fiber breakage

### Degasification
- Vacuum tower: bulk CO₂ and O₂ removal from makeup
- Membrane contactor: dissolved O₂ removal in polishing loop (N₂ sweep)
- Target: <1 ppb DO in polishing loop

---

## Related References

- [technologies.md](technologies.md) — RO, EDI, IX, UF fundamentals and membrane fouling types
- [reuse.md](reuse.md) — On-site industrial reuse (Pathway B): stream segregation, "一滴水用3.5次" concept
- [industrial.md](industrial.md) — Pharmaceutical WFI comparison, boiler/cooling water in fab utilities
- [troubleshooting.md](troubleshooting.md) — UPW system diagnostics (Section 7): resistivity drop, TOC/particle/DO excursions
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — SEMI E187 fab security requirements for water subsystems
