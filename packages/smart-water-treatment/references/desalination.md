# 海水淡化參考（Desalination Reference）

## 目錄

1. [原水分類](#1-原水分類)
2. [海淡技術選擇](#2-海淡技術選擇)
3. [海水逆滲透系統設計](#3-海水逆滲透系統設計)
4. [苦鹹水逆滲透系統設計](#4-苦鹹水逆滲透系統設計)
5. [取水與前處理](#5-取水與前處理)
6. [能量回收與最佳化](#6-能量回收與最佳化)
7. [後處理與穩定化](#7-後處理與穩定化)
8. [濃縮液管理](#8-濃縮液管理)
9. [積垢、結垢與化學清洗](#9-積垢結垢與化學清洗)
10. [熱法海水淡化](#10-熱法海水淡化)
11. [新興技術](#11-新興技術)
12. [能耗與成本基準](#12-能耗與成本基準)
13. [環境考量](#13-環境考量)
14. [全球重要設施](#14-全球重要設施)

---

## 1. 原水分類（Source Water Classification）

下表依原水鹽度分類，並列出各類水源的關鍵挑戰。鹽度直接決定所需的操作壓力與能耗——阿拉伯灣海水鹽度可達 48,000 mg/L，比開放大洋高出 30% 以上，設計時需特別考量。

| 水源（Source） | 溶解固體範圍 (TDS, mg/L) | 典型溫度（Typical Temperature） | 關鍵挑戰（Key Challenges） |
|---|---|---|---|
| Seawater (open ocean) | 33,000-37,000 | 15-30°C (regional) | High osmotic pressure, boron, biofouling |
| Seawater (Arabian Gulf) | 40,000-48,000 | 20-35°C | Very high TDS, high temperature, high turbidity |
| Brackish groundwater | 1,000-10,000 | 15-25°C (stable) | Silica, iron/manganese, scaling (CaSO₄, BaSO₄) |
| Brackish surface water | 1,000-10,000 | Variable | Turbidity, organics, biofouling |
| High-salinity industrial | 5,000-70,000 | Variable | Application-specific contaminants |

### 設計用關鍵水質參數

下表列出影響系統設計的主要水質參數。每個參數都直接關聯到特定的設計決策——例如淤泥密度指數（SDI）決定前處理方案，硼濃度決定是否需要二段逆滲透。

| 參數（Parameter） | 影響（Impact） | 設計考量（Design Concern） |
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

## 2. 海淡技術選擇（Desalination Technology Selection）

下表比較主流海淡技術的適用條件。薄膜法（逆滲透）是目前主流，熱法僅在有廢熱可利用時具經濟優勢。

| 技術（Technology） | 進水鹽度 (Feed TDS) | 能耗 (kWh/m³) | 回收率（Recovery） | 最佳應用（Best Application） |
|---|---|---|---|---|
| SWRO | 30,000-45,000 | 2.5-4.5 | 40-55% | Seawater — dominant technology |
| BWRO | 1,000-10,000 | 0.5-2.5 | 75-90% | Brackish ground/surface water |
| EDR | 500-5,000 | 0.5-2.0 | 85-95% | Brackish, selective ion removal |
| MSF | 30,000-50,000 | 10-15 (thermal) | 25-35% | Co-located with power plant (waste heat) |
| MED | 30,000-50,000 | 6-10 (thermal) | 25-40% | Lower-temperature waste heat available |
| MVC | 5,000-50,000 | 8-15 | 90-98% | ZLD concentrate treatment |
| FO | Variable | 0.5-1.0 (+ draw regeneration) | Variable | Niche: high-fouling feed, osmotic dilution |

### 技術選擇決策樹

```
進水鹽度（Feed TDS）？
├── <10,000 mg/L（苦鹹水 brackish）
│   ├── 需要選擇性離子去除？ → 電透析反轉（EDR）
│   └── 整體脫鹽 → 苦鹹水逆滲透（BWRO）
├── 10,000-30,000 mg/L（高鹽度苦鹹水）
│   └── 苦鹹水逆滲透（低回收率）或海水逆滲透膜元件（降壓操作）
└── >30,000 mg/L（海水）
    ├── 有廢熱可用？ → 多效蒸餾（MED）或多級閃蒸（MSF）
    └── 無廢熱 → 海水逆滲透（SWRO）
```

---

## 3. 海水逆滲透系統設計（SWRO System Design）

### 典型處理流程

```
海水取水（Seawater Intake）
  → 攔污（Screening：coarse + fine, 100-500 µm）
    → 前處理（Pretreatment：DAF or UF or MMF + cartridge filter）
      → 高壓泵 + 能量回收裝置（High-Pressure Pump + Energy Recovery Device）
        → 第一段海水逆滲透（SWRO 1st Pass, 40-50% recovery）
          → 選配：第二段逆滲透（2nd Pass, 85-90% recovery, for boron）
            → 後處理（Post-Treatment：remineralization, disinfection）
              → 產水儲槽 → 配水（Product Water Storage → Distribution）
```

### 第一段海水逆滲透設計參數

| 參數（Parameter） | 典型範圍（Typical Range） | 備註（Notes） |
|---|---|---|
| Feed pressure | 55-70 bar | Depends on TDS, temperature, recovery |
| Recovery | 40-50% (open ocean), 35-42% (Gulf) | Limited by osmotic pressure + scaling |
| Flux | 12-17 LMH | Conservative for fouling control |
| Salt rejection | 99.5-99.8% (system) | Single element: 99.7-99.85% |
| Permeate TDS | 200-500 mg/L | Before 2nd pass |
| Array | 7:1 or 8:1 (single stage) | 8" elements, 7-8 elements per vessel |
| Membrane type | SW (seawater) TFC polyamide | High rejection, high pressure rated |

### 第二段（硼去除/精煉）（2nd Pass — Boron Removal / Polishing）

當硼限值 <1.0 mg/L 時需要第二段（世衛準則 2.4 mg/L；較嚴格地區 0.5 mg/L）。

| 參數（Parameter） | 典型範圍（Typical Range） | 備註（Notes） |
|---|---|---|
| Feed | 1st pass permeate | TDS 200-500 mg/L |
| pH adjustment | Raise to pH 10-11 | Converts boric acid → borate ion (higher rejection) |
| Recovery | 85-90% | |
| Permeate boron | <0.3 mg/L | Achievable at pH >10 |
| Concentrate | Return to 1st pass feed | Improves overall recovery |

### 硼的化學特性（Boron Chemistry）

硼在海水中主要以硼酸形式存在。硼酸為小分子不帶電荷，能輕易穿透逆滲透膜。提高酸鹼值至 10 以上可使其轉變為帶電荷的硼酸鹽離子，大幅提升阻擋率。

```
B(OH)₃ (boric acid) ⇌ B(OH)₄⁻ (borate ion) + H⁺     pKa = 9.2

At pH 7: >99% as B(OH)₃ (uncharged, small — passes RO membrane)
At pH 10: >85% as B(OH)₄⁻ (charged — rejected by RO)
```

---

## 4. 苦鹹水逆滲透系統設計（BWRO System Design）

### 典型處理流程

```
苦鹹水井水或地表水取水（Brackish Well or Surface Intake）
  → 前處理（Pretreatment：oxidation/filtration for Fe/Mn, antiscalant dosing）
    → 保安過濾器（Cartridge Filter, 5 µm）
      → 高壓泵（High-Pressure Pump，通常不需能量回收裝置——壓力較低）
        → 苦鹹水逆滲透（BWRO, 75-90% recovery, multi-stage）
          → 後處理（Post-Treatment：pH adjustment, disinfection）
            → 產水（Product Water）
```

### 苦鹹水逆滲透設計參數

| 參數（Parameter） | 典型範圍（Typical Range） | 備註（Notes） |
|---|---|---|
| Feed pressure | 10-25 bar | Much lower than SWRO |
| Recovery | 75-85% (standard), 90% (with antiscalant + intermediate treatment) | Limited by scaling, not osmotic pressure |
| Flux | 20-30 LMH | Higher flux achievable vs. SWRO |
| Array | 2:1 or 3:2:1 (multi-stage) | Concentrate staging for high recovery |
| Membrane type | BW (brackish water) TFC | Lower pressure rated, higher flux |
| Permeate TDS | 10-50 mg/L | |

### 各回收率下的結垢風險

下表列出苦鹹水逆滲透中常見的結垢類型。與海水逆滲透不同，苦鹹水的回收率主要受結垢（而非滲透壓）限制。硫酸鋇（BaSO₄）溶解度極低，即使在低回收率下也可能結垢，是最需警惕的垢種之一。

| 垢種（Scale） | 溶度積（Solubility Product） | 風險起始點（Risk Onset） | 防治措施（Mitigation） |
|---|---|---|---|
| CaCO₃ (calcite) | LSI >0 | >70% recovery | Acid dosing (LSI <0), antiscalant |
| CaSO₄ (gypsum) | Ksp = 3.1×10⁻⁵ | >80% recovery | Antiscalant, limit recovery |
| BaSO₄ (barite) | Ksp = 1.1×10⁻¹⁰ | Even at low recovery if Ba present | Antiscalant critical; very low solubility |
| SrSO₄ (celestite) | Ksp = 3.4×10⁻⁷ | >75% recovery | Antiscalant |
| SiO₂ (silica) | ~120-150 mg/L (reactive) | Concentrate >120 mg/L | Limit recovery, pH control, antiscalant |
| CaF₂ (fluorite) | Ksp = 3.5×10⁻¹¹ | If fluoride present | Antiscalant, pretreatment removal |

---

## 5. 取水與前處理（Intake & Pretreatment）

### 取水方式

| 類型（Type） | 說明（Description） | 優點（Pros） | 缺點（Cons） |
|---|---|---|---|
| Open ocean (surface) | Intake pipe 500-2000m offshore, submerged | High capacity, proven | Algae, jellyfish, marine growth, higher SDI |
| Subsurface (beach well / gallery) | Seabed or beach filtration | Natural prefiltration (low SDI) | Limited capacity, site-dependent geology |
| Onshore well (brackish) | Vertical or horizontal wells | Consistent quality, low turbidity | Aquifer sustainability, Fe/Mn possible |

### 前處理方案

下表列出主要的前處理方案及其出水淤泥密度指數（SDI）。前處理品質直接影響逆滲透膜的壽命與清洗頻率，是海水淡化廠最容易被低估的環節。

| 方式（Method） | 去除對象（Removes） | 典型應用（Typical Application） | 出水 SDI（Product SDI） |
|---|---|---|---|
| Conventional (coag + MMF) | TSS, colloids, some organics | Standard SWRO pretreatment | 3-4 |
| DAF + MMF | Algae, oil & grease, light particles | Algae-prone intakes (Red Sea, Gulf) | 2-3 |
| UF (immersed or pressurized) | Particles >0.01 µm, bacteria | Challenging/variable feed quality | <2 (often <1) |
| Cartridge filter (5 µm) | Last-chance particle guard | Always — final barrier before HP pump | — |

### 前處理選擇指引

```
進水品質（Feed Quality）？
├── 乾淨穩定（beach well, SDI <2）→ 僅保安過濾器（rare, low risk）
├── 中等（SDI 2-4, low algae）→ 傳統前處理（coag + MMF + cartridge）
├── 變異/挑戰性（SDI >4, algae blooms）→ 溶氣浮除 + 多層過濾或超過濾（DAF + MMF or UF）
└── 嚴峻（HABs, high organics, oil risk）→ 溶氣浮除 + 超過濾（DAF + UF，雙重屏障）
```

### 有害藻華應對（Harmful Algal Bloom, HAB Response）

有害藻華是海水逆滲透廠最具挑戰性的操作事件：

| 嚴重度（Severity） | 指標（Indicator） | 應對措施（Response） |
|---|---|---|
| Advisory | Chlorophyll-a >5 µg/L, algae cell count rising | Increase coagulant dose, monitor SDI hourly |
| Moderate | SDI >4, UF flux decline, increased ΔP | Reduce plant capacity 25-50%, increased CEB frequency |
| Severe | SDI >5, algal toxins detected, UF integrity risk | Consider plant shutdown; protect membranes |

---

## 6. 能量回收與最佳化（Energy Recovery & Optimization）

### 能量回收裝置（Energy Recovery Devices, ERDs）

海水逆滲透的高壓濃縮液含有約 95% 的輸入能量。能量回收裝置將此能量回收以降低單位產水能耗（Specific Energy Consumption, SEC）。

| 能量回收裝置類型（ERD Type） | 機制（Mechanism） | 效率（Efficiency） | 應用（Application） |
|---|---|---|---|
| Pelton turbine | Kinetic → shaft power | 85-90% | Older plants, smaller capacity |
| Turbocharger | Brine drives turbine → boosts feed | 80-85% | Mid-range, compact |
| Pressure exchanger (PX) | Direct pressure transfer (isobaric) | 95-98% | Modern SWRO standard — lowest SEC |
| Dual work exchanger (DWEER) | Piston-based pressure transfer | 95-97% | Large plants |

> 💡 **小知識：壓力交換器（Pressure Exchanger, PX）**
> 壓力交換器透過等壓方式直接將高壓濃縮液的壓力傳遞給低壓進水，效率高達 95-98%。這項技術讓現代海水逆滲透廠的能耗從每立方公尺 6-8 度電降至 2.5-3.5 度電，是近二十年來海淡成本大幅下降的最關鍵因素之一。

### 單位產水能耗（Specific Energy Consumption, SEC）

| 系統配置（System Configuration） | SEC (kWh/m³) | 備註（Notes） |
|---|---|---|
| SWRO without ERD | 6-8 | Obsolete — no new plants built this way |
| SWRO + Pelton turbine | 4-5 | Legacy plants |
| SWRO + PX (pressure exchanger) | 2.5-3.5 | Current best practice |
| SWRO + PX + optimized design | 2.0-2.5 | Near thermodynamic minimum at 50% recovery |
| Thermodynamic minimum (seawater, 50%) | ~1.1 | Theoretical limit — cannot be achieved in practice |
| BWRO (no ERD needed) | 0.5-2.0 | Low feed pressure → ERD not cost-effective |

### 能耗最佳化策略

| 策略（Strategy） | 節能幅度（Savings） | 實施方式（Implementation） |
|---|---|---|
| Modern ERD (PX type) | 30-50% vs. no ERD | Capital investment; standard for new SWRO |
| Variable frequency drives (VFDs) | 10-20% | Adjust HP pump to actual demand |
| Interstage booster | 5-10% | Equalize flux distribution in pressure vessels |
| Seasonal setpoint optimization | 5-15% | Lower pressure in winter (lower T → lower osmotic P) |
| AI-driven pressure optimization | 3-8% | Real-time setpoint adjustment based on feed conditions |

交叉參考：[ai-and-control.md](ai-and-control.md) 提供人工智慧驅動的能耗最佳化模式。

---

## 7. 後處理與穩定化（Post-Treatment & Stabilization）

逆滲透透過水具有侵蝕性（低溶解固體、低鹼度、低酸鹼值），若不經穩定化處理，會腐蝕配水管線基礎設施。

### 再礦化方式（Remineralization Methods）

| 方式（Method） | 添加成分（Adds） | 典型應用（Typical Application） | 優點（Pros） | 缺點（Cons） |
|---|---|---|---|---|
| Lime + CO₂ | Ca²⁺, alkalinity | Large SWRO plants | Low cost, proven | Requires lime handling, sludge |
| Calcite contactor | Ca²⁺, alkalinity | Small-medium plants | Simple operation | Slow dissolution, limited capacity |
| CaCl₂ + NaHCO₃ dosing | Ca²⁺, alkalinity independently | Precise control needed | Precise, no sludge | Chemical cost |
| Blending with source water | All minerals | Where source is potable-grade | Zero chemical cost | Quality dependent on blend ratio |

### 飲用水目標透過水水質（Target Permeate Quality）

| 參數（Parameter） | 目標值（Target） | 理由（Rationale） |
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

## 8. 濃縮液管理（Concentrate Management）

濃縮液（鹵水）處置往往是海水淡化中限制最多且成本最高的環節。

### 處置方式

| 方式（Method） | 適用性（Applicability） | 環境疑慮（Environmental Concern） | 相對成本（Relative Cost） |
|---|---|---|---|
| Ocean outfall (diffuser) | Coastal SWRO | Salinity impact on marine life | Low |
| Deep well injection | Inland BWRO | Aquifer contamination risk | Medium |
| Evaporation ponds | Arid inland, small plants | Land use, wildlife (hypersaline) | Medium (land) |
| Sewer discharge | Small BWRO, where permitted | WWTP loading, TDS pass-through | Low |
| ZLD (brine concentrator + crystallizer) | Zero discharge mandate | Energy-intensive; solid waste disposal | Very high |
| Beneficial use (salt harvesting) | Suitable brine composition | Market-dependent | Variable |

### 海水逆滲透濃縮液特性（SWRO Concentrate Characteristics）

以 35,000 mg/L 海水、45% 回收率為例：

| 參數（Parameter） | 典型值（Typical） |
|---|---|
| TDS | ~63,000 mg/L |
| Temperature | Feed temp + 1-2°C |
| Dissolved oxygen | Near saturation (if not deaerated) |
| Antiscalant | Present (passed through) |
| pH | Feed pH (or slightly lower if acid-dosed) |
| Flow | ~55% of feed flow |
| Pressure (after ERD) | ~1-2 bar (energy recovered) |

### 海洋混合區設計（Environmental Mixing Zone Design）

海洋放流管搭配擴散器之設計要求：
- 近場稀釋目標：50-100 公尺內達到 20:1 至 40:1 稀釋倍數
- 混合區邊界鹽度：不超過環境鹽度 1 ppt
- 多口擴散器搭配傾斜噴嘴以加速混合
- 使用計算流體力學（CFD）或近場模型（CORMIX, UM3, Visual Plumes）進行設計驗證

交叉參考：[industrial.md](industrial.md) 提供零液體排放處理流程設計細節。

---

## 9. 積垢、結垢與化學清洗（Fouling, Scaling & CIP）

### 積垢診斷（Fouling Diagnosis）

下表為逆滲透膜積垢的快速診斷指引。透過觀察壓差（ΔP）、通量（Flux）和鹽透過率（Salt Passage, SP）的變化趨勢，可初步判斷積垢類型並採取對應措施。

| 症狀（Symptom） | 可能積垢類型（Likely Fouling Type） | 受影響膜元件（Affected Elements） | 診斷方式（Diagnostic） |
|---|---|---|---|
| ΔP↑, flux↓, SP→ | Particulate/colloidal | Lead elements | SDI test; element autopsy |
| ΔP↑↑, flux↓, SP→ | Biofouling | Lead elements | ATP test; biofilm probe; smell (H₂S) |
| Flux↓, SP↑ | Organic fouling | Throughout | TOC of feed; element autopsy (FTIR) |
| Flux↓, SP↑ | Mineral scale | Tail elements | Concentrate saturation indices; acid test |
| SP↑↑ | Oxidation damage (irreversible) | Throughout | ORP check; chlorine test on feed |

### 化學清洗程序（CIP, Clean-in-Place Protocols）

| 積垢類型（Fouling Type） | 清洗藥劑（Cleaning Chemical） | pH | 溫度（Temperature） | 時間（Duration） |
|---|---|---|---|---|
| Biofouling | NaOH + EDTA (or SDS surfactant) | 11-12 | 35-40°C | 4-6 hr soak |
| Organic | NaOH + Na-SDS | 11-12 | 35-40°C | 4-6 hr soak |
| CaCO₃ scale | HCl or citric acid | 2-3 | 25-35°C | 2-4 hr soak |
| Sulfate scale (CaSO₄) | Specialty sulfate cleaner (EDTA-based) | 11-12 | 35-40°C | 6-12 hr |
| Silica scale | NaOH at high pH + warm | 12-13 | 40°C | 6-8 hr |
| Metal oxides (Fe, Mn) | Citric acid or sodium hydrosulfite | 2-4 | 25°C | 2-4 hr |

### 化學清洗頻率建議

| 狀況（Condition） | 行動（Action） |
|---|---|
| Normalized flux decline >10% | Schedule CIP |
| Normalized ΔP increase >15% | Schedule CIP (likely biofouling/particulate) |
| Normalized salt passage increase >10% | Schedule CIP (likely scale or organic) |
| Routine preventive | Every 1-3 months (site-dependent) |

### 標準化（Normalization）

在診斷積垢前，務必先將操作數據標準化至參考條件：
- 參考溫度（通常 25°C）— 溫度校正因子（TCF）修正
- 參考壓力（淨驅動壓力）
- 參考回收率與流量

交叉參考：[technologies.md](technologies.md) 提供薄膜基礎知識；[troubleshooting.md](troubleshooting.md) 提供診斷架構。

---

## 10. 熱法海水淡化（Thermal Desalination）

當有廢熱可利用（與發電廠共站、工業場址）或處理超高鹽度水源時，熱法仍具適用價值。

### 多級閃蒸（Multi-Stage Flash, MSF）

| 參數（Parameter） | 典型範圍（Typical Range） |
|---|---|
| Stages | 15-25 |
| Top brine temperature | 90-110°C |
| GOR (Gain Output Ratio) | 8-12 kg distillate / kg steam |
| Recovery | 25-35% |
| Product TDS | <10 mg/L |
| SEC (thermal + electrical) | 10-15 kWh/m³ equivalent |

### 多效蒸餾（Multi-Effect Distillation, MED）

| 參數（Parameter） | 典型範圍（Typical Range） |
|---|---|
| Effects | 8-16 |
| Top brine temperature | 65-70°C |
| GOR | 8-15 |
| Recovery | 25-40% |
| Product TDS | <10 mg/L |
| SEC (thermal + electrical) | 6-10 kWh/m³ equivalent |
| Advantage over MSF | Lower top brine temperature → less scaling, can use lower-grade heat |

### 多效蒸餾搭配熱蒸氣壓縮（MED-TVC）

加裝蒸汽噴射器可將造水比（GOR）提升至 12-16。常見於波斯灣國家與發電廠共站設施。

### 熱法與薄膜法混合系統（Hybrid Thermal-Membrane）

```
海水 → 多級閃蒸或多效蒸餾（產出極低鹽度蒸餾水）
     ↘ 冷卻水排放（溫度較高、略為濃縮）
        → 海水逆滲透（較高溫度下通量提升）
          → 混合蒸餾水 + 逆滲透透過水
```

效益：提高整體回收率、降低混合能耗成本，且熱法天然能處理硼。

---

## 11. 新興技術（Emerging Technologies）

| 技術（Technology） | 原理（Principle） | 發展階段（Status） | 潛在優勢（Potential Advantage） |
|---|---|---|---|
| Closed-circuit RO (CCRO) | Batch/semi-batch RO with concentrate recirculation | Commercial | Higher recovery from seawater (60-65%) |
| Osmotically assisted RO (OARO) | Osmotic assist on permeate side | Pilot | Desalination of high-TDS brines (up to 100,000+) |
| Membrane distillation (MD) | Vapor transport through hydrophobic membrane | Pilot-commercial | Utilizes low-grade heat; handles high TDS |
| Capacitive deionization (CDI) | Electrosorption on carbon electrodes | Early commercial | Low-TDS brackish; low energy |
| Solvent extraction (SED) | Amine-based directional solvent extraction | Lab-pilot | Potential for low-energy seawater desal |
| Electrodialysis metathesis (EDM) | Converts scaling ions to non-scaling salts | Pilot | Enables high BWRO recovery without antiscalant |
| Forward osmosis + RO | FO as pretreatment / osmotic dilution | Pilot-commercial | Reduced SWRO energy (diluted feed) |

---

## 12. 能耗與成本基準（Energy & Cost Benchmarking）

### 建設成本範圍（CAPEX Ranges）

| 系統（System） | 規模（Capacity） | 建設成本 (USD/m³/day capacity) |
|---|---|---|
| Small SWRO (<5,000 m³/d) | Containerized | 1,500-3,000 |
| Medium SWRO (5,000-50,000) | Custom-built | 1,000-2,000 |
| Large SWRO (>50,000) | Mega-plant | 700-1,500 |
| BWRO | Any | 300-800 |
| Thermal (MSF/MED) | Large, co-located | 1,200-2,500 |

### 操作成本分項（OPEX Breakdown，大型海水逆滲透廠）

| 項目（Component） | 佔比 (% of Total OPEX) | 成本 (USD/m³) |
|---|---|---|
| Energy | 35-50% | 0.3-0.6 |
| Chemicals (pretreatment, CIP, post) | 10-15% | 0.05-0.15 |
| Membrane replacement | 8-12% | 0.05-0.10 |
| Labor | 10-15% | 0.05-0.15 |
| Maintenance & spares | 8-12% | 0.05-0.10 |
| Concentrate disposal | 5-15% | 0.03-0.10 |
| **Total OPEX** | **100%** | **0.5-1.2** |

### 平準化水成本（Levelized Cost of Water, LCOW）

下表為各技術的平準化水成本範圍。大型海水逆滲透廠的水成本已可低至每立方公尺 0.5 美元，但實際成本高度受能源價格與規模經濟影響。

| 技術（Technology） | LCOW (USD/m³) | 關鍵敏感因子（Key Sensitivity） |
|---|---|---|
| Large SWRO (>100,000 m³/d) | 0.5-1.0 | Energy price, recovery |
| Medium SWRO | 0.8-1.5 | Scale, energy |
| BWRO | 0.2-0.6 | Feed TDS, recovery |
| Thermal (with waste heat) | 0.8-1.5 | Heat cost allocation |
| Thermal (standalone) | 1.5-3.0 | Fuel cost |

---

## 13. 環境考量（Environmental Considerations）

### 海洋影響評估（Marine Impact Assessment）

| 影響（Impact） | 成因（Cause） | 減緩措施（Mitigation） |
|---|---|---|
| Hypersaline plume | Concentrate discharge | Diffuser design; mixing zone modeling |
| Impingement | Intake screens trapping organisms | Low-velocity intake (<0.15 m/s); wedgewire screens |
| Entrainment | Small organisms drawn into intake | Subsurface intake where feasible; intake location/depth |
| Chemical residuals | Antiscalant, biocide in concentrate | Minimize dosing; select biodegradable chemicals |
| Thermal discharge | Elevated brine temperature | Blend with cooling water; seasonal limits |

### 碳足跡減量策略（Carbon Footprint Reduction Strategies）

| 策略（Strategy） | 碳減量潛力（CO₂ Reduction Potential） |
|---|---|
| Renewable energy (solar PV / wind) | 50-100% of operational carbon |
| Energy recovery (PX) | 30-50% energy reduction |
| Green hydrogen for off-grid plants | Eliminates fossil fuel dependency |
| Optimized operation (AI-driven) | 5-15% energy reduction |
| Low-carbon materials / construction | 10-20% of embodied carbon |

### 各地區法規架構（Regulatory Frameworks）

| 地區（Region） | 主要法規（Key Regulation） | 重點（Focus） |
|---|---|---|
| California | Ocean Plan Amendment | Concentrate salinity limits, intake requirements |
| Australia | EPA guidelines per state | Brine dilution, marine monitoring |
| Middle East | AGEDI / local EPA | Less restrictive; evolving |
| EU | Water Framework Directive | Environmental quality standards |
| Taiwan | 海洋放流水標準 | Discharge quality limits |

---

## 14. 全球重要設施（Major Global Facilities）

| 設施（Facility） | 地點（Location） | 處理量 (m³/d) | 技術（Technology） | 特色（Notable Feature） |
|---|---|---|---|---|
| Ras Al Khair | Saudi Arabia | 1,036,000 | MSF + SWRO hybrid | Largest desalination plant globally |
| Sorek B | Israel | 548,000 | SWRO | Among lowest LCOW (~$0.41/m³, contract price, 不含土地及取水權等外部成本) |
| Taweelah | UAE | 909,000 | SWRO | Largest single SWRO plant |
| Carlsbad | California, USA | 189,000 | SWRO + UF pretreatment | US West Coast benchmark |
| Perth (Southern Seawater) | Australia | 274,000 | SWRO | 100% renewable energy powered |
| Jebel Ali | UAE | 636,000+ | MSF + MED | Co-located with power station |
| Barcelona | Spain | 200,000 | SWRO | Built in response to 2008 drought |

交叉參考：[technologies.md](technologies.md) 提供逆滲透膜基礎知識；[industrial.md](industrial.md) 提供零液體排放與濃縮液處理；[reuse.md](reuse.md) 提供各水源的能耗/成本比較。
