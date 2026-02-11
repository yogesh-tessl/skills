# 半導體超純水參考手冊（Semiconductor Ultrapure Water, UPW）

## 目錄

1. [SEMI 標準總覽](#semi-標準總覽)
2. [超純水水質規格](#超純水水質規格)
3. [典型超純水系統架構](#典型超純水系統架構)
4. [各製程節點關鍵參數](#各製程節點關鍵參數)
5. [先進製程節點要求](#先進製程節點要求)
6. [常見超純水子系統](#常見超純水子系統)

## SEMI 標準總覽

### SEMI F63 — 超純水品質指南（UPW Quality Guide）

這是半導體等級超純水的核心工業標準。以下為使用點（Point of Use, POU）的關鍵參數規格。

> 下表列出 SEMI F63 先進等級與前沿製程的目標值。數值愈嚴格，代表製程節點愈小，對水質純度的容忍度愈低。判讀重點：先進目標已非常嚴格，前沿目標再收緊一到二倍，代表量測技術與製程控制都需同步升級。

| 參數（Parameter） | SEMI F63 先進等級 | 前沿製程目標（Leading-Edge） |
|-----------|---------------------|---------------------|
| 電阻率（Resistivity） | ≥18.18 MΩ·cm | ≥18.2 MΩ·cm |
| 總有機碳（TOC） | <1 ppb | <0.5 ppb |
| 粒子 ≥0.05 µm（Particles） | <1 /mL | <0.1 /mL |
| 溶氧（Dissolved O₂, DO） | <1 ppb | <0.5 ppb |
| 溶氮（Dissolved N₂） | <50 ppb | <20 ppb |
| 矽（Silica, total） | <0.5 ppb | <0.1 ppb |
| 金屬（Metals, each） | <1 ppt | <0.1 ppt |
| 陰離子（Anions, each） | <10 ppt | <1 ppt |
| 細菌（Bacteria） | <0.001 CFU/mL | <0.0001 CFU/mL |
| 內毒素（Endotoxin） | <0.001 EU/mL | <0.0005 EU/mL |

> 💡 **小知識：ppt 與 ppb 的差異**
> ppb 是十億分之一，ppt 是兆分之一（比 ppb 再小一千倍）。前沿製程對金屬要求 <0.1 ppt，相當於在一座奧運泳池中偵測到不到一滴墨水——這需要感應耦合電漿質譜儀（ICP-MS）等級的檢測設備。

### 相關 SEMI 標準

- **SEMI F61**：超純水系統設計指南
- **SEMI F57**：超純水系統用高分子材料規範
- **SEMI C79**：化學試劑純度指南
- **SEMI F40**：超純水品質監測實務

## 超純水水質規格

### 依製程節點分級（By Technology Node）

> 下表呈現不同製程節點對超純水的品質要求。節點愈小（數字愈小），要求愈嚴格。判讀方式：同一列向右看，可觀察該參數隨製程微縮而收緊的幅度。

| 參數（Parameter） | ≥28nm | 14-7nm | 5-3nm | ≤2nm |
|-----------|-------|--------|-------|------|
| 電阻率（MΩ·cm） | ≥18.18 | ≥18.18 | ≥18.2 | ≥18.2 |
| 總有機碳 TOC（ppb） | <2 | <1 | <0.5 | <0.3 |
| 粒子 ≥50nm（/mL） | <3 | <1 | <0.3 | <0.1 |
| 溶氧 DO（ppb） | <3 | <1 | <0.5 | <0.3 |
| 總矽 Total Silica（ppb） | <1 | <0.5 | <0.1 | <0.05 |
| 金屬總量 Metals total（ppt） | <100 | <10 | <5 | <1 |
| 硼 Boron（ppt） | <50 | <10 | <5 | <1 |

## 典型超純水系統架構

### 前處理（Pretreatment）

```
原水 → 多介質過濾器 → 活性碳 → 軟化器/阻垢劑 → 保安過濾器
Raw Water → Multimedia Filter → Activated Carbon → Softener/Antiscalant → Cartridge Filter
```

目的：保護下游薄膜元件，去除大宗污染物（濁度、餘氯、硬度）。

### 一次製水系統（Primary / Makeup System）

```
保安過濾器 → 第一段逆滲透 → 脫氣塔 → 第二段逆滲透 → 電去離子裝置 → 一次儲水槽
Cartridge Filter → 1st Pass RO → Degasifier → 2nd Pass RO → EDI → Primary Storage Tank
```

目的：大量去除離子、降低總有機碳、去除溶解氣體。

### 拋光迴路（Polishing Loop）

```
一次水槽 → 紫外線185nm → 混床拋光 → 膜式脫氣 → 紫外線254nm → 超過濾0.01µm → 使用點
Primary Tank → UV (185nm TOC) → Mixed Bed Polish → Membrane Degasifier → UV (254nm) → UF (0.01µm) → POU
```

目的：最終拋光以滿足使用點規格；系統採連續迴路循環運作。

### 回收再利用（Reclaim/Recycle）

```
排放水 → 收集 → 品質分流 → 處理 → 回送至一次製水或拋光系統
Drain Water → Collection → Quality Segregation → Treatment → Return to Makeup or Polishing
```

目的：提高水回收率（目標 >90%）。一座典型晶圓廠每日用水量約 8,000-15,000 m³。

## 各製程節點關鍵參數

### 電阻率（Resistivity）
- 在 25°C 的理論最大值為 18.248 MΩ·cm（僅含氫離子 H⁺ 與氫氧根離子 OH⁻）
- 需溫度補償至 25°C 標準條件
- 影響因子：溶解二氧化碳（CO₂）、微量離子、有機物
- 量測方式：線上量測、溫度補償、雙電極槽交叉驗證

### 總有機碳（TOC, Total Organic Carbon）
- 來源：系統材料（聚偏二氟乙烯 PVDF、聚乙烯 PE）、生物膜、大氣滲入、化學污染
- 量測方式：紫外線氧化搭配電導度偵測，或薄膜電導度法（Membrane Conductometry）
- 關鍵影響：閘極氧化層完整性（Gate Oxide Integrity）、光阻附著力

### 粒子（Particles）
- 來源：樹脂碎屑、薄膜脫落物、生物膜、沉澱物、施工殘留
- 計數方式：線上雷射粒子計數器（Laser Particle Counter, LPC），偵測 ≥50nm 或 ≥30nm
- 關鍵影響：缺陷密度（Defect Density）與良率

### 溶氧（Dissolved Oxygen, DO）
- 來源：接頭處空氣滲入、水槽頂部空間、高分子材料滲透
- 去除方式：真空脫氣塔、膜式脫氣接觸器（Membrane Contactor，以氮氣掃除）、氮氣曝氣
- 關鍵影響：矽晶圓表面原生氧化層（Native Oxide）生長、銅腐蝕

### 金屬（Metals）：硼、矽、鐵、銅、鋅、鈉、鉀等
- 硼（Boron）：在中性酸鹼值下體積小且不帶電，逆滲透難以有效去除；需採用高酸鹼值（High-pH）第二段逆滲透或硼選擇性樹脂
- 矽（Silica）：膠體矽可穿透逆滲透膜；需搭配超過濾（UF）與高酸鹼值操作
- 量測方式：感應耦合電漿質譜儀（Inductively Coupled Plasma Mass Spectrometry, ICP-MS），可偵測至 ppt 等級

## 常見超純水子系統

### 逆滲透（Reverse Osmosis, RO）
- 第一段：回收率 75-80%，離子去除率 95-99%
- 第二段：提高酸鹼值至 9-10 以加強硼和矽的去除率，回收率 85-90%
- 薄膜類型：低能耗聚醯胺薄膜複合膜（Low-Energy Polyamide TFC）
- 主要風險：生物積垢（Biofouling）、結垢（Scaling，碳酸鈣 CaCO₃ 與矽垢）、氯損害

### 電去離子裝置（Electrodeionization, EDI）
- 結合離子交換樹脂、離子選擇性薄膜與直流電場
- 可連續產出 16-18+ MΩ·cm 的高純度水，無需化學再生
- 進水要求：電導度 <20 µS/cm、二氧化碳 <5 ppm
- 主要風險：硬度結垢、矽積垢、有機物積垢

### 混床離子交換（Mixed-Bed Ion Exchange, MB-IX）
- 使用核級樹脂，氫型（H⁺）與氫氧根型（OH⁻）
- 可拋光至 >18.2 MΩ·cm
- 再生方式：場外再生（委外服務）或就地再生
- 主要風險：樹脂碎屑釋出、有機物溶出、偏流（Channeling）

### 紫外線系統（UV Systems）
- 185nm：分解總有機碳（產生氫氧自由基 OH·）
- 254nm：殺菌消毒
- 設計依據：劑量以 mJ/cm² 計算，依流量調整
- 主要風險：燈管老化、石英套管積垢、副產物生成

### 超過濾（Ultrafiltration, UF）
- 作為最終粒子與細菌屏障，孔徑 0.01-0.05 µm
- 中空纖維型，材質通常為聚偏二氟乙烯（PVDF）或聚醚碸（PES）
- 完整性測試：壓力衰減測試（Pressure Decay Test, PDT）或泡點測試（Bubble Point）
- 主要風險：有機物積垢、纖維斷裂

### 脫氣系統（Degasification）
- 真空脫氣塔：用於一次製水系統，大量去除二氧化碳與氧氣
- 膜式脫氣接觸器（Membrane Contactor）：用於拋光迴路，以氮氣掃除溶氧
- 目標：拋光迴路中溶氧 <1 ppb

---

## 相關參考文件

- [technologies.md](technologies.md) — 逆滲透、電去離子、離子交換、超過濾的基礎原理與薄膜積垢類型
- [reuse.md](reuse.md) — 廠內工業回收再利用（路徑 B）：水流分級、「一滴水用 3.5 次」概念
- [industrial.md](industrial.md) — 藥用注射用水（WFI）比較、晶圓廠公用設施鍋爐與冷卻水
- [troubleshooting.md](troubleshooting.md) — 超純水系統故障診斷（第七節）：電阻率下降、總有機碳/粒子/溶氧異常
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — SEMI E187 晶圓廠資安要求（含水處理子系統）
