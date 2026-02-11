# 市政給水與污水處理參考（Municipal Water Treatment Reference）

## 目錄

1. [飲用水水質標準](#飲用水水質標準)
2. [污水排放標準](#污水排放標準)
3. [飲用水處理程序](#飲用水處理程序)
4. [污水處理程序](#污水處理程序)
5. [污泥管理](#污泥管理)
6. [新興污染物](#新興污染物)

## 飲用水水質標準（Drinking Water Standards）

### 美國環保署飲用水標準（US EPA National Primary Drinking Water Regulations，節選）

下表列出美國環保署規範的主要飲用水污染物及其最大容許濃度。最大污染物濃度（Maximum Contaminant Level, MCL）是法定強制標準，最大污染物濃度目標（MCL Goal, MCLG）則是基於健康考量的理想值（不一定能在技術上達成）。處理技術（Treatment Technique, TT）適用於無法以濃度直接管制的項目。

| 污染物（Contaminant） | MCL (mg/L) | MCLG | 處理方式（Treatment） |
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

MCL = 最大污染物濃度（Maximum Contaminant Level）；MCLG = 最大污染物濃度目標（MCL Goal）；TT = 處理技術規範（Treatment Technique）；AL = 行動水準（Action Level）

> 💡 **小知識：全氟/多氟烷基物質（PFAS）**
> 美國環保署在 2024 年將全氟辛酸（PFOA）和全氟辛烷磺酸（PFOS）的標準訂為 4 ppt（萬億分之四），這是目前飲用水中最嚴格的管制濃度之一。這類物質因為化學鍵極穩定，在環境中幾乎無法自然分解，被稱為「永久化學物質（forever chemicals）」。

### 世界衛生組織準則（WHO Guidelines，節選）

世衛準則為各國訂定飲用水標準的參考基準，非法規強制值。

| 參數（Parameter） | 準則值（Guideline Value） | 備註（Notes） |
|-----------|----------------|-------|
| E. coli | Not detectable in 100mL | Indicator organism |
| Arsenic | 0.01 mg/L | Provisional |
| Fluoride | 1.5 mg/L | |
| Nitrate (as NO₃) | 50 mg/L | ~11.3 mg/L as N |
| Lead | 0.01 mg/L | |
| Turbidity | <1 NTU (ideally <0.1) | For effective disinfection |

### 台灣環保署飲用水水質標準（節選）

台灣標準大致參照世衛及美國標準，部分項目略有不同。全氟化物採合併管制（PFOA + PFOS 合計 70 ppt），比美國寬鬆但已屬先進水準。

| 參數（Parameter） | 標準值（Standard） | 備註（Notes） |
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

## 污水排放標準（Wastewater Discharge Standards）

### 市政污水處理廠典型放流水限值

下表整理不同處理等級的放流水品質要求。二級處理（Secondary）為基本要求；三級/回收水等級（Tertiary/Reuse）適用於放流水再利用場景；高級處理（Advanced）則對應間接飲用水再利用等高標準需求。

| 參數（Parameter） | 二級處理（Secondary） | 三級/回收（Tertiary/Reuse） | 高級處理（Advanced） |
|-----------|-----------|----------------|----------|
| BOD₅ (mg/L) | ≤30 | ≤10 | ≤5 |
| TSS (mg/L) | ≤30 | ≤10 | ≤5 |
| NH₃-N (mg/L) | Monitor | ≤2 | ≤1 |
| TN (mg/L) | Monitor | ≤10 | ≤3 |
| TP (mg/L) | Monitor | ≤1 | ≤0.1 |
| Turbidity (NTU) | — | ≤2 | ≤0.5 |
| E. coli (CFU/100mL) | ≤200 | ≤2.2 | ND |
| Residual Cl₂ (mg/L) | — | 0.5-1.0 | — |

### 台灣環保署放流水標準（節選）

| 參數（Parameter） | 標準值（Standard） |
|-----------|----------|
| BOD₅ | ≤30 mg/L |
| COD | ≤100 mg/L |
| TSS | ≤30 mg/L |
| NH₃-N | ≤10 mg/L |
| TN | — (monitoring) |
| TP | ≤4 mg/L |
| True color | ≤550 (Pt-Co) |

## 飲用水處理程序（Drinking Water Treatment Processes）

### 傳統處理流程（Conventional Treatment Train）

從取水到配水的標準處理流程，適用於大部分地表水源：

```
取水（Intake）→ 攔污（Screening）→ 混凝/膠凝（Coagulation/Flocculation）→ 沉澱（Sedimentation）→ 過濾（Filtration）→ 消毒（Disinfection）→ 清水池（Storage）→ 配水（Distribution）
```

### 高級處理選項（Advanced Treatment Options）

當傳統處理無法滿足特定水質目標時，可依需求加裝以下單元。例如活性碳吸附可處理異味與全氟化物，薄膜過濾可取代或強化傳統處理。

| 程序（Process） | 去除目標（Target） | 典型應用（Typical Application） |
|---------|--------|---------------------|
| GAC adsorption | Organics, taste/odor, PFAS | After filtration |
| Ozone | Disinfection, taste/odor, micropollutants | Pre- or intermediate ozonation |
| UV | Crypto/Giardia inactivation | Post-filtration |
| Membrane filtration (MF/UF) | Particles, pathogens | Replace or supplement conventional |
| NF/RO | TDS, hardness, micropollutants | Desalination, softening |
| IX (anion) | Nitrate, PFAS, arsenic | Targeted contaminant removal |

### 消毒方式比較（Disinfection）

下表比較各種消毒方式對梨形鞭毛蟲（Giardia）達到三對數去除（3-log，即 99.9% 去除率）所需的接觸劑量時間乘積（Ct 值）。Ct 值越低代表消毒效率越高，但每種方法各有其優缺點需權衡。

| 方式（Method） | 梨形鞭毛蟲 3-log Ct 值 (mg·min/L) | 優點（Pros） | 缺點（Cons） |
|--------|----------------------------------|------|------|
| Free chlorine | ~45 (pH 7, 15°C) | Residual, inexpensive | DBP formation, taste |
| Chloramine | ~750 | Stable residual, low DBPs | Weaker oxidant, nitrification |
| Ozone | ~0.5 | Strong oxidant, no residual | Bromate formation, cost |
| UV | 40 mJ/cm² (dose, not CT) | No chemicals, effective for Crypto | No residual, lamp maintenance |
| ClO₂ | ~15 | Effective, low THMs | Chlorite/chlorate byproducts |

## 污水處理程序（Wastewater Treatment Processes）

### 活性污泥法變體（Activated Sludge Variants）

活性污泥法是市政污水處理的核心技術。下表列出常見變體及其特點，選型取決於出水水質要求、用地面積、與營養鹽去除需求。

| 程序（Process） | 配置（Configuration） | 優勢（Strengths） |
|---------|--------------|-----------|
| Conventional AS | Aeration basin + secondary clarifier | Reliable BOD/TSS removal |
| A²O (Anaerobic-Anoxic-Oxic) | Three-zone BNR | N and P removal |
| Bardenpho (5-stage) | A-Anox-O-Anox-O | Enhanced N removal |
| SBR | Fill-react-settle-decant cycles | Flexible, small footprint |
| MBR | Aeration + submerged membranes | Excellent effluent, small footprint |
| MBBR | Biofilm carriers in aeration | Compact, retrofit-friendly |
| Oxidation ditch | Extended aeration loop | Simple, low sludge |

### 營養鹽去除（Nutrient Removal）

**氮的去除（Nitrogen removal）**：先在好氧區經硝化反應（Nitrification）將銨氮（NH₄⁺）氧化為硝酸鹽（NO₃⁻），由硝化菌（Nitrosomonas/Nitrobacter）執行；再於缺氧區經脫氮反應（Denitrification）將硝酸鹽還原為氮氣（N₂），此步驟需要碳源。

**磷的去除（Phosphorus removal）**：
- 生物除磷（Biological）：強化生物除磷程序（Enhanced Biological Phosphorus Removal, EBPR）透過厭氧/好氧交替環境，讓聚磷菌（PAOs）大量累積磷
- 化學除磷（Chemical）：投加明礬（Alum）、氯化鐵（Ferric chloride）或硫酸鐵沉澱磷酸鹽，典型莫耳比為 1.5-2.0 mol Fe/mol P

### 三級處理（Tertiary Treatment）

| 程序（Process） | 用途（Purpose） |
|---------|---------|
| Dual media filtration | TSS polishing |
| Cloth disk filter | TSS polishing, low head loss |
| UV disinfection | Pathogen inactivation |
| Chlorination/dechlorination | Disinfection with residual |
| GAC/BAC | Organics, micropollutants |
| Ozone + BAC | Advanced micropollutant removal |

## 污泥管理（Sludge Management）

### 典型污泥產量

- 初沉污泥（Primary sludge）：每立方公尺原水產生 150-350 克乾固體
- 廢棄活性污泥（Waste Activated Sludge, WAS）：70-150 g DS/m³，含固率 0.5-1.5%
- 合計：通常 200-400 g DS/m³

### 處理流程

```
濃縮（Thickening, 3-6% DS）→ 消化（Digestion, anaerobic, 15-20 day HRT）→ 脫水（Dewatering, 20-30% DS）→ 處置/再利用（Disposal/Reuse）
```

## 新興污染物（Emerging Contaminants）

### 全氟/多氟烷基物質（PFAS, Per- and Polyfluoroalkyl Substances）

- 美國環保署最大容許濃度（2024 年）：PFOA 4 ppt、PFOS 4 ppt
- 處理方式：粒狀活性碳（GAC，空床接觸時間 10-20 分鐘，需頻繁更換）、一次性離子交換樹脂（IX，選擇性樹脂）、逆滲透/奈米過濾（RO/NF，阻擋率 >95%）
- 挑戰：短鏈全氟化物更難去除；破壞性技術（電化學法、超臨界水氧化法）仍在發展中

### 微塑膠（Microplastics）

- 目前尚無法規限值；微過濾/超過濾（MF/UF）可有效去除 >90%
- 傳統處理（混凝 + 過濾）約可去除 70-80%

### 藥品及個人護理產品（PPCPs, Pharmaceuticals and Personal Care Products）

- 臭氧 + 生物活性碳（Ozone + BAC）：最有效的廣譜去除組合
- 粒狀活性碳（GAC）：有效但需頻繁更換
- 傳統處理：效果不一，視化合物特性而定

---

## 相關參考文件

- [technologies.md](technologies.md) — 活性碳、臭氧、紫外線、薄膜、離子交換、混凝、生物處理等技術詳細規格
- [reuse.md](reuse.md) — 三級放流水作為再利用水源：飲用水再利用路徑、多重屏障設計、再利用水中的全氟化物議題
- [troubleshooting.md](troubleshooting.md) — 生物處理診斷（活性污泥、絲狀菌、營養鹽去除問題排查）
- [desalination.md](desalination.md) — 飲用水薄膜程序（奈米過濾/逆滲透處理溶解固體、硬度、微量污染物）
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — 水務事業的環境社會治理報告、碳足跡計算、法規遵循自動化
