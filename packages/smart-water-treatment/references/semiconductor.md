# 半導體超純水參考手冊（Semiconductor Ultrapure Water, UPW）

## 目錄

1. [SEMI 標準總覽](#semi-標準總覽)
2. [超純水水質規格](#超純水水質規格)
3. [典型超純水系統架構](#典型超純水系統架構)
4. [各製程節點關鍵參數](#各製程節點關鍵參數)
5. [先進製程節點要求](#先進製程節點要求)
6. [常見超純水子系統](#常見超純水子系統)
7. [CMP/CuCMP 廢水處理](#cmpcucmp-廢水處理)

## SEMI 標準總覽

### SEMI F63 — 超純水品質指南（UPW Quality Guide）

這是半導體等級超純水的核心工業標準。以下為使用點（Point of Use, POU）的關鍵參數規格。

> ⚠️ SEMI F63 為產業付費標準文件，以下數值為業界廣泛引用的代表性規格。實際設計時應以購買取得的正式標準文件為準。

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
- 進水要求：電導度 <20 µS/cm、二氧化碳 <5 ppm（理想 <3 ppm）、硬度 <0.01 ppm、矽 <0.5 ppm（完整規格見 [technologies.md](technologies.md) 電去離子章節）
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

## CMP/CuCMP 廢水處理

### CMP 廢水組成

化學機械研磨（Chemical Mechanical Polishing, CMP）廢水的主要成分：
- **研磨漿料粒子**：漿料原液含 5-10% 奈米級粒子（二氧化矽 SiO₂、氧化鈰 CeO₂、氧化鋁 Al₂O₃），廢水經稀釋後固含量通常在 0.1-1% 量級
- **氧化劑**：過氧化氫（H₂O₂），濃度可達 500-1500 ppm
- **pH 緩衝劑**：氫氧化鉀（KOH）、氫氧化銨（NH₄OH）
- **界面活性劑**（surfactants）

銅製程化學機械研磨（CuCMP）廢水額外含有：
- 銅離子濃度 5-100 mg/L
- 螯合劑：甘胺酸（glycine）、檸檬酸（citric acid），會干擾銅離子沉澱

> 💡 **小知識：為什麼 CuCMP 廢水這麼難處理？**
> CMP 漿料裡的螯合劑會「抓住」銅離子不放，讓傳統的化學沉澱法（加鹼讓銅變成固體沉下去）效果大打折扣。就像用保鮮膜包住髒東西，讓清潔劑碰不到——必須先「解開」螯合劑，才能有效去除銅。

**來源**：
- [PMC12510042](https://pmc.ncbi.nlm.nih.gov/articles/PMC12510042/) — CMP 廢水組成與處理技術綜述
- [ElectraMet Application Note](https://electramet.com/app-note/copper-removal-recovery-from-cmp-wastewater-slurry/) — CuCMP 廢水銅濃度與過氧化氫數據

### 銅離子去除的 pH 依賴性

銅的去除主要靠氫氧化銅（Cu(OH)₂）沉澱，其溶解度積常數（Ksp）因晶型而異：結晶態約 2.2 × 10⁻²⁰，無定形態（amorphous）約 1.6 × 10⁻¹⁹。新生成的沉澱物多為無定形態，溶解度約為結晶態的 7 倍。以下計算以結晶態 Ksp = 2.2 × 10⁻²⁰ 為基準，實際殘留銅可能更高。

**理論計算 vs 實際觀測的差異**：

由 Ksp 推導的理論平衡溶解度遠低於實際廢水中的觀測值。以 pH 7.0 為例：
- 理論值：Cu(OH)₂ ⇌ Cu²⁺ + 2OH⁻，[Cu²⁺] = Ksp / [OH⁻]² = 2.2 × 10⁻²⁰ / (10⁻⁷)² = 2.2 × 10⁻⁶ M ≈ **0.14 mg/L**
- 實際觀測值：CuCMP 廢水中因螯合劑（甘胺酸、檸檬酸）絡合銅離子，有效游離銅濃度偏低，加上膠體態銅（colloidal Cu）和微粒態銅的存在，實測殘留銅通常比理論值**高 10-100 倍**

> 下表分為兩欄：理論平衡溶解度（純化學體系，無螯合劑）與 CuCMP 廢水的實測近似值。判讀重點：理論值反映化學極限，實測值反映工程現實。設計時應以實測值為依據，理論值作為「最佳可能」參考。

| pH 值 | 理論平衡溶解度（純 Cu(OH)₂） | CuCMP 廢水實測近似值 ⚙️ | 操作意義 |
|--------|-------------------------------|----------------------|----------|
| 6.0 | ~14 mg/L | ~20-50 mg/L | 高風險：銅幾乎不沉澱，遠超法規限值 |
| 7.0 | ~0.14 mg/L | ~1-5 mg/L | 邊界風險：接近或超過法規限值（1 mg/L） |
| 8.0 | ~0.0014 mg/L | ~0.05-0.5 mg/L | 有效沉澱區：多數情況可達標 |
| 9.0-10.3 | ~10⁻⁵ mg/L 量級 | ~0.01-0.1 mg/L | 最低溶解度區：最佳操作範圍 |
| >10.3 | 逐漸升高 | 逐漸升高 | 兩性特性：銅酸根離子（Cu(OH)₄²⁻）生成，溶解度回升 |

> ⚙️ 實測近似值欄位為業界工程經驗值（engineering estimates），受螯合劑種類、濃度、膠體態銅比例等因素影響，非精確量測數據。設計時應以現場瓶杯試驗（jar test）結果為準。

> ⚠️ **理論值與實測值差距的主因**：CuCMP 漿料中的螯合劑（甘胺酸、檸檬酸）會與銅離子形成穩定錯合物，降低游離 Cu²⁺ 濃度從而抑制沉澱反應。此外膠體態銅和微粒態銅無法用 Ksp 預測。設計時不可直接以 Ksp 理論值作為出水保證。

關鍵操作指引：
- 理論最低溶解度出現在 pH 9.0-10.3 區間（非 8.1），此區間 Cu(OH)₂ 沉澱最完全
- 實務操作範圍通常設在 pH 8.5-9.5，兼顧沉澱效率與下游混凝效能
- pH 低於 7.0 時銅溶解度急劇上升，是最常見的超標風險區
- 台灣放流水銅排放標準 < 1 mg/L，pH 6-9（注意：pH 上限 9.0 為法規約束，設計需同時滿足銅去除與 pH 合規）

**來源**：
- [Water Specialists](https://waterspecialists.biz/info-bulletins/precipitation-by-ph/) — 金屬沉澱與 pH 關係數據
- [Wikipedia — Copper(II) hydroxide](https://en.wikipedia.org/wiki/Copper(II)_hydroxide) — Ksp 數據

### PAC 混凝劑化學

聚合氯化鋁（Polyaluminium Chloride, PAC）是水處理中最常用的無機混凝劑之一。

**化學特性**：
- 通式：(Alₙ(OH)ₘCl₍₃ₙ₋ₘ₎)ₓ，為預水解鋁鹽
- 含有高效能的鋁十三聚體（Al₁₃），又稱凱金結構（Keggin structure）
- 鹼化度（basicity）= m/(3n) × 100%，決定水解時產酸量

**鹼化度與產酸量的關係**：
- 高鹼化度 PAC（~80%）：產酸量為明礬（alum, Al₂(SO₄)₃）的 1/3～1/2
- 低鹼化度 PAC（~30-40%）：產酸量接近明礬

PAC 水解產酸的簡化反應（以低鹼化度為例）：
```
Al³⁺ + 3H₂O → Al(OH)₃↓ + 3H⁺
```

> 💡 **小知識：為什麼 PAC 會讓水變酸？**
> PAC 溶入水中後，鋁離子與水反應生成氫氧化鋁沉澱（這是我們要的絮凝效果），但同時會釋放出氫離子（H⁺），讓水的 pH 下降。鹼化度越高的 PAC，預先中和掉的氫離子越多，加入水中後產酸量就越少。

**有效 pH 範圍**：5.0-8.0（比明礬更寬，是 PAC 的主要優勢之一）

**來源**：
- [Ataman Chemicals](https://www.atamanchemicals.com/polyaluminium-chloride_u25738/) — PAC 化學結構與特性
- [PubMed 16447443](https://pubmed.ncbi.nlm.nih.gov/16447443/) — Al₁₃ 凱金結構研究
- [Australian Drinking Water Guidelines](https://guidelines.nhmrc.gov.au/australian-drinking-water-guidelines/part-5/treatment-chemicals/polyaluminium-chloride) — PAC 與明礬產酸量比較
- [IWA Publishing](https://iwaponline.com/wpt/article/16/4/1215/83042/) — PAC 有效 pH 範圍

### 典型處理流程

CuCMP 廢水的典型處理串聯流程：

```
收集槽 → 粗 pH 調整（安全網） → 精 pH 調整 → 混凝（PAC + Polymer） → 沉澱 → 放流監測
```

各單元功能說明：
- **收集槽**：匯集不同來源的廢水，均勻化水質
- **粗 pH 調整**：處理極端酸鹼值（如蝕刻廢液混入），通常用硫酸（H₂SO₄）/ 氫氧化鈉（NaOH），精度要求低
- **精 pH 調整**：微調至銅沉澱最佳 pH，精度要求 ±0.2 pH
- **混凝**：PAC 負責電荷中和，高分子絮凝劑（Polymer）負責架橋絮凝
- **沉澱**：重力沉降，停留時間影響出水品質
- **放流監測**：即時監測 pH、銅濃度、濁度等放流水指標

**精 pH 調整槽的雙 PID 控制邏輯**（常見配置）：
- PID1：驅動硫酸（H₂SO₄），降低 pH
- PID2：驅動氫氧化鈉（NaOH），升高 pH
- 物理互斥：同一時刻只應有一側加藥（酸鹼同時投加等於浪費）
- 加藥方式通常為脈衝式（pulse dosing）：`加藥秒數 = PID 輸出% × 週期秒數 / 100`

**PAC 同槽投加造成的內部對沖迴路**：
- PAC 持續水解產酸 → pH 下降 → PID 偵測偏差 → 投加 NaOH → pH 回升 → PAC 繼續水解 → 循環
- 當 PAC 與 NaOH 在同一槽投加時，pH 可能以分鐘級頻率穿越設定值，形成高頻振盪
- 這是系統結構性問題，非 PID 調參問題
- 解決方向：前饋補償（用 PAC 流量預估酸化量，提前投加鹼）或將 PAC 投加點移至下游

### 跨槽水力停留時間（HRT）

多槽串聯系統中，水力停留時間（Hydraulic Retention Time, HRT）決定了上下游信號的延遲：

```
HRT = 槽體有效容積 / 進水流量
```

這個延遲是「免費的預測窗口」——當上游出現異常時，下游有一段等於 HRT 的時間可以提前準備。

然而，在閉迴路系統中，中間槽的 PID 控制器會吸收上游信號：
- PID 的設計目標是消除偏差 → 上游傳來的可預測信號被修正 → 只剩不可預測的殘差傳往下游
- 結果：跨槽水質相關性通常遠低於水力連通性所暗示的水準

實務建議：監控中間槽的 PID 輸出變化率（而非水質值本身），以保留上游異常的信號痕跡。

### SCADA 感測器資料處理實務

工業 SCADA 系統常見的資料整合問題與建議處理方式：

| 問題類型 | 說明 | 建議處理方式 |
|---------|------|-------------|
| 雙時期欄位（PV/RL） | SCADA 同一感測器在不同時期可能使用不同欄位名稱（PV = 主要值、RL = 量程受限值） | 合併為單一欄位，否則會大幅低估資料可用率 |
| 雙設備輪替運轉 | 某些系統有兩台泵浦（或其他設備），同時段只一台運轉，另一台待機值為零 | 合併方式：`flow_total = flow_pump1.fillna(0) + flow_pump2.fillna(0)`，勿誤判為備援模式 |
| 停機期間缺失 | 設備停機時感測器無輸出 | 可填零（代表無運轉） |
| 運轉中缺失 | 設備運轉中但感測器暫時失聯 | 應用前向填充（forward-fill）或內插法，不可一律填零 |

---

## 相關參考文件

- [technologies.md](technologies.md) — 逆滲透、電去離子、離子交換、超過濾的基礎原理與薄膜積垢類型
- [reuse.md](reuse.md) — 廠內工業回收再利用（路徑 B）：水流分級、「一滴水用 3.5 次」概念
- [industrial.md](industrial.md) — 藥用注射用水（WFI）比較、晶圓廠公用設施鍋爐與冷卻水
- [troubleshooting.md](troubleshooting.md) — 超純水系統故障診斷（第七節）：電阻率下降、總有機碳/粒子/溶氧異常
- [troubleshooting.md](troubleshooting.md) — 化學加藥系統故障排除（第八節）：PAC 酸化、跨槽延遲鏈、工況變化導致 AI 模型失效
- [ai-and-control.md](ai-and-control.md) — 閉迴路系統 AI 預測實戰教訓（第十節）：PID 信號吸收、處方型模型、漸進式部署
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — SEMI E187 晶圓廠資安要求（含水處理子系統）
