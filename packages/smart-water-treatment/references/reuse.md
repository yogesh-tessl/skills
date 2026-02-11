# 再生水與回收水參考（Reclaimed & Recycled Water Reference）

## 目錄

1. [再利用分類](#1-再利用分類)
2. [處理單元組合（積木模組）](#2-處理單元組合)
3. [路徑 A：市政再生水供應工業用水](#3-路徑-a市政再生水供應工業用水)
4. [路徑 B：廠內工業水回收](#4-路徑-b廠內工業水回收)
5. [路徑 C：飲用水再利用（IPR / DPR）](#5-路徑-c飲用水再利用)
6. [各用途水質要求](#6-各用途水質要求)
7. [多重屏障設計原則](#7-多重屏障設計原則)
8. [監測與法規遵循](#8-監測與法規遵循)
9. [能耗與成本基準](#9-能耗與成本基準)
10. [台灣再生水基礎設施](#10-台灣再生水基礎設施)

---

## 1. 再利用分類（Reuse Categories）

水再利用實務有兩大範式：

### 系統性再生水（Systemic Reclaimed Water，市政再生水）

市政污水處理廠放流水經高級處理後，透過專用管線（紫色管線）送至工業用戶。水源為混合市政污水，生化需氧量（BOD）高、含病原體、水質變異大，上游必須經過生物處理。

### 廠內回收再利用（On-Site Industrial Reuse）

工廠製程廢水在廠內處理後回到製程或公用設施使用。水源通常為低生化需氧量、化學成分明確的廢水，不需要生物處理；挑戰在於針對性去除特定污染物（如氫氟酸、銅、化學機械研磨漿料、溶劑）。

### 分類比較

下表對比兩種再利用範式的關鍵差異，有助於判斷特定場景適用哪種路徑。

| 屬性（Attribute） | 系統性再生水（Systemic） | 廠內回收（On-Site Industrial） |
|---|---|---|
| 水源（Source） | Municipal WWTP secondary effluent | Factory process/rinse wastewater |
| 處理等級（Treatment level） | Tertiary + advanced (MBR/UF → RO → UV/AOP) | Chemical + membrane (coag → UF → RO → EDI) |
| 生物處理（Biological treatment） | Required (high BOD, pathogens) | Rarely needed |
| 典型用途（Typical end-use） | Cooling tower makeup, industrial process water | UPW feed, CMP rinse, cooling, scrubber |
| 實例（Examples） | 永康/安平 → 南科; 鳳山 → 中鋼; Singapore NEWater | TSMC fab water recycling ("一滴水用3.5次") |
| 回收率目標（Recovery target） | 75-85% (single-pass RO); 90-95% with concentrate treatment | 85-95% depending on stream segregation |

---

## 2. 處理單元組合（Treatment Building Blocks）

水再利用處理系統由一組共用的積木模組組裝而成，如同樂高積木般依不同場景重新組合。理解每個模組的功能比記住特定處理串列更重要。

### 三大核心模組

1. **固液分離（Solid-Liquid Separation）** — 去除懸浮/膠體物質以保護下游薄膜
2. **脫鹽與分子分離（Desalting & Molecular Separation）** — 去除溶解鹽類、有機物、微量污染物
3. **消毒與氧化（Disinfection & Oxidation）** — 滅活病原體並破壞微量有機物

### 單元操作參考表

下表整理所有常用處理單元及其在三大模組中的歸屬。設計時從模組一到模組三依序選擇，確保每個模組至少有一道屏障。

| 單元操作（Unit Operation） | 模組 | 功能（Function） | 典型位置（Typical Position） | 關鍵設計參數（Key Design Parameter） |
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
| UV/AOP (UV + H₂O₂) | 3 | Micropollutant destruction | After RO (potable reuse) | OH· exposure, H₂O₂ dose, EEO |
| Ozone | 3 | Oxidation + disinfection | Pre-filtration or post-RO | Ct value, dose (mg/L), bromate formation |
| Chlorination | 3 | Residual disinfection | Final step before distribution | Ct, residual (mg/L), DBP formation |

交叉參考：[technologies.md](technologies.md) 提供各技術的詳細設計參數。

---

## 3. 路徑 A：市政再生水供應工業用水（Municipal Reclaimed Water → Industrial Supply）

### 典型處理流程

```
市政污水處理廠二級放流水（Municipal WWTP Secondary Effluent）
  → 薄膜生物反應器或傳統活性污泥 + 超過濾（MBR or Conventional AS + UF）
    → 逆滲透（RO, single or two-pass）
      → 紫外線/高級氧化（UV/AOP，若為飲用水再利用或嚴格規格）
        → 穩定化/再礦化（Stabilization / remineralization）
          → 專用管線 → 工業用戶
```

### 關鍵特徵

- **必須經過生物處理** — 原水生化需氧量高（原污水 100-300 mg/L）、含懸浮固體與病原體
- 薄膜生物反應器（MBR）因佔地小且出水品質佳，越來越受青睞，可取代傳統活性污泥法加三級過濾的組合
- **回收率目標**：單段逆滲透 75-85%；搭配濃縮液處理（高效能逆滲透 HERO、電透析反轉 EDR、或零液體排放 ZLD）可達 90-95%
- 逆滲透濃縮液管理是主要的成本與環境限制因素

### 參考設施

詳見[第 10 節（台灣再生水基礎設施）](#10-台灣再生水基礎設施)的完整設施表。國際標竿：新加坡新生水（NEWater，日產 78 萬噸以上，MF/UF → RO → UV，供工業及間接飲用水再利用）。

交叉參考：[municipal.md](municipal.md) 提供污水處理廠放流水標準；[industrial.md](industrial.md) 提供工業取水規格。

---

## 4. 路徑 B：廠內工業水回收（On-Site Industrial Water Reuse）

### 典型處理流程

```
分流收集之工廠廢水（Segregated Factory Wastewater Streams）
  → 各流別前處理（Stream-specific pretreatment：chemical precipitation, pH adjustment, F⁻ removal）
    → 均化（Equalization）
      → 混凝/膠凝（Coagulation/Flocculation，if needed）
        → 超過濾（UF）
          → 逆滲透（RO, single or two-pass）
            → 電去離子或混床離子交換（EDI or Mixed-Bed IX，for UPW-grade）
              → 回到製程使用
```

### 關鍵特徵

- **不需生物處理** — 工業廢水（尤其半導體業）通常為低生化需氧量
- **廢水分流是關鍵**：不同廢水流別需要不同的前處理方式
  - 化學機械研磨（CMP）漿料廢水 → 混凝 + 沉澱（高懸浮固體、研磨顆粒）
  - 含氫氟酸（HF）廢水 → 氟化鈣（CaF₂）沉澱
  - 酸鹼廢水 → 中和處理
  - 有機溶劑廢水 → 分別處理或委外處置
  - 稀薄沖洗水 → 直接送超過濾/逆滲透（最佳回收候選流別）
- **「一滴水用 3.5 次」** — 水回收倍數的概念：製程用水總量除以新鮮水取水量，透過串級回收與高回收率再利用達成
- 目標：降低自來水依賴、最小化排放量

### 半導體廠水平衡範例

```
Fresh UPW intake: 1.0 unit
  → Process use: 3.5 units (through recycling)
  → Discharge: ~0.3-0.5 units
  → Evaporative/consumptive losses: ~0.15 units
  → Overall recovery: 70-85%
```

交叉參考：[semiconductor.md](semiconductor.md) 提供超純水規格與晶圓廠水系統設計。

---

## 5. 路徑 C：飲用水再利用（Potable Reuse, IPR / DPR）

### 間接飲用水再利用（Indirect Potable Reuse, IPR）

經高級處理的水先通過**環境緩衝區**再進入飲用水供水系統：
- 地下水補注（Groundwater recharge）：透過入滲池或注入井，經數月地下層傳輸
- 水庫補注（Reservoir augmentation）：與地表水源混合

### 直接飲用水再利用（Direct Potable Reuse, DPR）

經高級處理的水**不經環境緩衝區**，直接進入淨水廠進水端或配水系統。需要最嚴格的處理標準與即時監測。

### 完全高級處理（Full Advanced Treatment, FAT）— 標準屏障序列

```
污水處理廠二級/三級放流水（WWTP Secondary/Tertiary Effluent）
  → 微過濾或超過濾（MF or UF，粒子/病原體屏障）
    → 逆滲透（RO，溶解性污染物屏障）
      → 紫外線/高級氧化（UV/AOP，微量污染物破壞 + 最終消毒）
        → 穩定化處理（Stabilization：lime, CO₂ for corrosion control）
```

### 參考設施

| 設施（Facility） | 類型（Type） | 處理量 (CMD) | 緩衝區（Buffer） | 處理流程（Treatment） |
|---|---|---|---|---|
| Orange County GWRS (CA) | IPR | 378,500 | Groundwater injection/spreading | MF → RO → UV/AOP |
| Big Spring, TX | DPR | 7,600 | None (blended at WTP inlet) | MF → RO → UV/AOP |
| Windhoek, Namibia | DPR | 21,000 | None | Pre-ozone → DAF → sand → GAC → UF → chlorination |
| Singapore NEWater | IPR (reservoir) | 780,000+ | Reservoir blending | MF/UF → RO → UV |

### 間接再利用與直接再利用比較

| 屬性（Attribute） | 間接飲用水再利用（IPR） | 直接飲用水再利用（DPR） |
|---|---|---|
| 環境緩衝區（Environmental buffer） | Required (months) | None |
| 公眾接受度（Public acceptance） | Generally higher | Lower — requires extensive outreach |
| 處理嚴格度（Treatment stringency） | FAT standard | FAT + additional monitoring/redundancy |
| 法規狀態（Regulatory status） | Established (CA Title 22, TX) | Emerging (fewer regulations) |
| 失效回應時間（Response time for failure） | Buffer provides time | Must detect and respond in real-time |

> 💡 **小知識：環境緩衝區（Environmental Buffer）**
> 間接飲用水再利用中的地下水補注，讓處理後的水在地下含水層中停留數月。這段時間就像一道天然的安全防線：地層過濾能進一步去除殘留污染物，也提供了充裕的水質監測與應變時間。直接再利用省去了這道防線，因此必須用更密集的即時監測來彌補。

---

## 6. 各用途水質要求（End-Use Water Quality Requirements）

下表整理各種再利用用途的關鍵水質參數與典型限值。不同用途的要求差異極大——從景觀灌溉到半導體超純水進料，水質跨越數個數量級。

| 用途（End Use） | 關鍵參數（Key Parameters） | 典型限值（Typical Limits） |
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

交叉參考：[semiconductor.md](semiconductor.md) 提供 SEMI F63 超純水規格；[municipal.md](municipal.md) 提供飲用水標準。

加州第 22 條法規（California Title 22）與台灣再生水水質標準是非飲用水再利用類別的主要法規架構。

---

## 7. 多重屏障設計原則（Multi-Barrier Design Principles）

### 核心概念

不依賴單一處理步驟來保護公眾健康。多重獨立屏障確保任何一道屏障失效時，系統仍能提供足夠的處理效果。此原則是飲用水再利用的基石，但適用於所有再利用場景。

### 各屏障的對數去除能力（Log Removal Credits）

下表列出各處理屏障對三類指標病原體的認證去除能力。完全高級處理（FAT）的組合可達到病毒 14 對數以上、隱孢子蟲和梨形鞭毛蟲各 10 對數以上的去除率。

| 屏障（Barrier） | 病毒（Virus） | 隱孢子蟲（Cryptosporidium） | 梨形鞭毛蟲（Giardia） |
|---|---|---|---|
| MF/UF (intact) | 0 (nominal) | 4.0 | 4.0 |
| RO (intact) | 2.0 | 2.0 | 2.0 |
| UV (40 mJ/cm²) | 6.0 | 4.0 | 4.0 |
| UV/AOP | 6.0 | 6.0 | 6.0 |
| Ozone (Ct-based) | 6.0 | 1.0 | 3.0 |
| Chlorination (Ct-based) | 4.0-6.0 | 0 | 3.0 |
| Soil aquifer treatment (IPR) | 1.0 | 1.0 | 1.0 |
| **典型 FAT 合計** | **14+** | **10+** | **10+** |

目標值：病毒 12 對數、隱孢子蟲 10 對數、梨形鞭毛蟲 10 對數（加州直接飲用水再利用架構）。

### 各屏障的關鍵控制點（Critical Control Points, CCPs）

| 屏障（Barrier） | 關鍵控制參數（CCP Parameter） | 行動限值（Action Limit） | 應變措施（Response） |
|---|---|---|---|
| MF/UF | Pressure decay test (PDT) | >threshold kPa/min | Isolate rack, integrity repair |
| RO | Conductivity rejection | <95% rejection | Investigate/replace elements |
| UV | UV dose / UVT | <required mJ/cm² | Divert flow, replace lamps |
| AOP | H₂O₂ residual | Below setpoint | Adjust dosing, divert |
| Chlorination | Cl₂ residual × contact time | Below Ct target | Increase dose, extend contact |

### 失效模式應對

- **單一屏障失效**：將水轉至廢水端或降低流量，同時維持其他屏障運作——系統仍具保護能力
- **多重屏障失效**：自動停機並通知操作人員
- **設計原則**：每道屏障必須能獨立監測與控制

---

## 8. 監測與法規遵循（Monitoring & Compliance）

### 即時替代參數（Real-Time Surrogate Parameters）

下表列出用於即時監控水質的替代參數。這些參數無法直接量測特定污染物，但能反映處理單元的運作狀態，提供早期預警。

| 替代參數（Surrogate） | 代表意義（What It Indicates） | 典型儀器（Typical Instrument） | 監測頻率（Monitoring Frequency） |
|---|---|---|---|
| Turbidity | Particle breakthrough (UF/MF integrity) | Nephelometer | Continuous (every 15 sec) |
| UV transmittance (UVT) | Organic load, UV dose adequacy | Online UVT analyzer | Continuous |
| Conductivity / TDS | Salt rejection (RO integrity) | Conductivity probe | Continuous |
| TOC | Organic contamination | Online TOC analyzer | Every 5-15 min |
| Particle counts | Membrane integrity | Laser particle counter | Continuous |
| Dissolved O₂ | Biological activity indicator | DO probe | Continuous |

### 新興關注污染物（Emerging Contaminants of Concern）

| 污染物（Contaminant） | 關注原因（Concern） | 典型限值（Typical Limit） | 處理方式（Treatment） |
|---|---|---|---|
| NDMA | Carcinogenic DBP; passes RO | 10 ng/L (CA notification) | UV photolysis (>1000 mJ/cm²) |
| 1,4-Dioxane | Solvent stabilizer; passes RO | 1 µg/L (CA notification) | UV/AOP |
| PFAS (PFOA/PFOS) | Persistent; bioaccumulative | 4 ng/L each (US EPA MCL) | RO rejection + GAC/IX for concentrate |
| CECs (pharmaceuticals, EDCs) | Ecological/human health risk | Varies by compound | UV/AOP, ozone, GAC |

> 💡 **小知識：亞硝基二甲胺（NDMA）**
> 這種致癌性消毒副產物分子量很小且不帶電荷，能穿透逆滲透膜，因此單靠逆滲透無法有效去除。必須在逆滲透之後加裝高劑量紫外線（>1000 mJ/cm²）進行光解，這也是飲用水再利用為何需要紫外線/高級氧化作為最後一道屏障的原因之一。

### 依再利用等級之監測頻率

| 參數（Parameter） | 非飲用水（Non-Potable） | 間接飲用水（IPR） | 直接飲用水（DPR） |
|---|---|---|---|
| Turbidity | Daily | Continuous | Continuous |
| TOC | Weekly | Continuous | Continuous |
| Conductivity | Daily | Continuous | Continuous |
| Pathogens (coliform) | Weekly | Daily | Daily + online surrogates |
| Regulated CECs | Quarterly | Monthly | Monthly + online TOC/UVT |
| NDMA, 1,4-dioxane | — | Quarterly | Monthly |
| PFAS | — | Quarterly | Quarterly |

---

## 9. 能耗與成本基準（Energy & Cost Benchmarking）

下表提供不同水源的能耗與成本比較。再生水的成本介於傳統地表水與海水淡化之間，是缺水地區重要的替代水源。零液體排放因為蒸發濃縮能耗極高，僅在特殊情境下採用。

| 水源（Water Source） | 能耗 (kWh/m³) | 典型成本 (USD/m³) | 備註（Notes） |
|---|---|---|---|
| Conventional surface water (WTP) | 0.2-0.5 | 0.3-0.8 | Baseline reference |
| Reclaimed — non-potable (UF + disinfection) | 0.5-1.0 | 0.5-1.2 | Tertiary treatment only |
| Reclaimed — industrial (UF + RO) | 1.0-2.0 | 1.0-2.5 | Including RO energy |
| Reclaimed — potable (FAT: MF/UF + RO + UV/AOP) | 1.5-2.5 | 1.5-3.0 | Full advanced treatment |
| Seawater desalination (SWRO) | 3.0-4.5 | 1.5-3.5 | With energy recovery devices |
| ZLD (evaporator + crystallizer) | 20-40 | 10-25 | Concentrate management endpoint |

### 碳足跡比較（Carbon Footprint Comparison）

| 水源（Source） | kgCO₂/m³ |
|---|---|
| Conventional surface water | 0.1-0.3 |
| Reclaimed (non-potable) | 0.2-0.5 |
| Reclaimed (potable) | 0.5-1.0 |
| Seawater desalination | 1.0-2.5 |
| ZLD | 8-20 |

能耗與碳排放值高度取決於當地電網碳排放強度、設施規模與能量回收程度。以上數值為規劃用途之典型範圍。

---

## 10. 台灣再生水基礎設施（Taiwan Reclaimed Water Infrastructure）

### 法規架構

- **再生水資源發展條例**（Reclaimed Water Resources Development Act）— 規定指定工業園區在再生水可供應時須使用再生水
- 台灣自來水公司與工業園區管理機構協商購水協議
- 需建設專用配水管線（等同於國際上的「紫色管線」系統），不得與自來水管線交叉連接

### 營運中與規劃中設施

| 設施（Facility） | 水源污水廠（Source WWTP） | 處理量 (CMD) | 供應對象（End User） | 處理流程（Treatment Train） | 狀態（Status） |
|---|---|---|---|---|---|
| 鳳山再生水廠 | 鳳山溪 WWTP | 45,000 | 中鋼 (CSC) | MBR → RO | Operational |
| 臨海再生水廠 | 臨海 WWTP | 33,000 | 臨海工業區 | MBR → RO | Operational |
| 永康再生水廠 | 永康 WWTP | 15,500 | 南科 (STSP) | MBR → RO → UV | Operational |
| 安平再生水廠 | 安平 WWTP | 37,500 | 南科 (STSP) | MBR → RO | Under construction |
| 豐原再生水廠 | 豐原 WWTP | 6,800 | 中科 (CTSP) | MBR → RO | Planning |
| 福田再生水廠 | 福田 WWTP | 6,500 | 中科 (CTSP) | MBR → RO | Planning |
| 前鎮再生水廠 | 前鎮 WWTP | 3,300 | 前鎮加工區 | MBR → RO | Planning |

### 台灣情境之關鍵設計考量

- **颱風季**影響污水處理廠進水水質（稀釋效應與合流式下水道溢流），再生水廠須能處理變異進水
- **耐震設計**：專用管線須依在地法規進行耐震設計
- 工業園區（科學園區）為主要需求驅動者——半導體晶圓廠需要穩定的水質與水量
- 水權與定價：再生水通常定價為自來水的 50-70%，以激勵工業採用

交叉參考：[industrial.md](industrial.md) 提供零液體排放與工業水處理；[municipal.md](municipal.md) 提供污水處理廠放流水水質。
