# 工業水處理參考（Industrial Water Treatment Reference）

## 目錄

1. [冷卻水系統](#冷卻水系統)
2. [鍋爐用水](#鍋爐用水)
3. [製程用水](#製程用水)
4. [水回收與零液體排放](#水回收與零液體排放)

## 冷卻水系統（Cooling Water）

### 開放式循環系統（冷卻水塔）（Open Recirculating / Cooling Tower Systems）

#### 補充水水質建議

下表列出冷卻水塔補充水的典型水質限值。這些限值會隨濃縮倍數（Cycles of Concentration, CoC）和化學處理方案而調整，目的是防止結垢、腐蝕與生物污染。

| 參數（Parameter） | 典型限值（Typical Limit） | 備註（Notes） |
|-----------|--------------|-------|
| TDS | <1500 mg/L | Depends on cycles of concentration |
| Hardness (CaCO₃) | <500 mg/L | Scale control dependent |
| Alkalinity (CaCO₃) | <500 mg/L | |
| Silica | <150 mg/L | Limit in circulating water |
| TSS | <25 mg/L | Fouling prevention |
| pH | 7.0-9.0 | Treatment program dependent |

#### 濃縮倍數（Cycles of Concentration, CoC）

濃縮倍數是循環水溶解固體濃度與補充水的比值，反映系統的用水效率。倍數越高越省水，但結垢與腐蝕風險也隨之升高。

```
CoC = Circulating water TDS / Makeup TDS
    = Makeup flow / Blowdown flow

Makeup = Evaporation + Blowdown + Drift + Leaks
Blowdown = Evaporation / (CoC - 1)
```

典型濃縮倍數：3-7 倍（越高越省水，但結垢與腐蝕風險隨之增加）。

#### 常見問題與判斷指標

下表整理冷卻水系統五大問題類型。實務上，同一系統可能同時存在多種問題（例如高氯離子既促進腐蝕，結垢又會加速局部腐蝕），需綜合診斷。

| 問題（Problem） | 指標（Indicators） | 常見原因（Common Causes） |
|---------|-----------|---------------|
| Scaling (CaCO₃) | Reduced heat transfer, deposits on fill | High hardness, high pH, high CoC |
| Silica scaling | Hard glassy deposits | Silica >150 mg/L in circ water |
| Biofouling | Slime, Legionella risk, MIC | Inadequate biocide, warm temperatures |
| Corrosion | Metal loss, red/brown deposits | Low pH, high chlorides, MIC |
| Fouling | TSS accumulation, reduced efficiency | Poor filtration, airborne debris |

#### 化學處理方案（Chemical Treatment Programs）

| 方案（Program） | 組成（Components） | 適用場景（Application） |
|---------|-----------|-------------|
| Phosphate-based | Orthophosphate + polymer + biocide | General corrosion/scale inhibition |
| All-organic | Phosphonates + polymers + azoles | Low-P discharge areas |
| Stabilized phosphate | Polyphosphate + zinc + polymer | Mild to moderate conditions |
| Silica-based | Silicate + polymer | Potable water systems |

殺菌方案（Biocide programs）：以氧化性殺菌劑（Oxidizing，如氯、溴、二氧化氯）與非氧化性殺菌劑（Non-oxidizing，如異噻唑啉酮、戊二醛、DBNPA）交替使用。

### 退伍軍人症桿菌風險管理（Legionella Risk Management）

- 循環水溫度維持低於 20°C 或高於 60°C（可行範圍內）
- 游離餘氯維持 0.5-1.0 mg/L 或等效氧化劑濃度
- 定期監測退伍軍人症桿菌（Legionella），行動水準通常為 >1000 CFU/L
- 飛沫消除器（Drift eliminators）：將氣溶膠排放降至循環流量的 <0.001%

> 💡 **小知識：退伍軍人症桿菌（Legionella）**
> 這種細菌在 25-42°C 的溫水中繁殖最快，冷卻水塔是典型的滋生環境。人體吸入含菌氣溶膠後可能導致嚴重肺炎（退伍軍人症），因此冷卻水塔的殺菌與飛沫控制至關重要。

## 鍋爐用水（Boiler Water）

### 美國機械工程師學會/鍋爐製造商協會建議值（ASME/ABMA Guidelines）

下表依鍋爐操作壓力分級列出給水與爐水的水質要求。壓力越高，水質要求越嚴格，因為高壓下即使微量雜質也會造成結垢、腐蝕或蒸汽品質下降。超高壓鍋爐（>60 bar）的給水品質接近超純水等級。

| 參數（Parameter） | 0-20 bar | 20-40 bar | 40-60 bar | >60 bar |
|-----------|----------|-----------|-----------|---------|
| Feedwater TDS (mg/L) | <700 | <300 | <50 | <0.05 |
| Feedwater Hardness | <1 mg/L | <0.1 mg/L | ND | ND |
| Feedwater DO (mg/L) | <0.04 | <0.007 | <0.007 | <0.005 |
| Feedwater Fe (mg/L) | <0.1 | <0.05 | <0.02 | <0.01 |
| Boiler water TDS | <3500 | <2500 | <1500 | <0.5 |
| Boiler water silica | <150 | <90 | <10 | <0.02 |
| Boiler water pH | 10.0-11.5 | 10.0-11.0 | 9.5-10.5 | 9.0-9.6 |

ND = 不可檢出（Non-detectable）

### 給水處理流程（Feedwater Treatment Train）

依鍋爐壓力等級選擇對應的處理組合：

```
低壓（Low Pressure）：  軟化（Softening）→ 除氣（Deaeration）→ 化學處理（Chemical treatment）
中壓（Medium）：        軟化 → 逆滲透（RO）→ 除氣 → 化學處理
高壓（High Pressure）： 逆滲透 → 電去離子/混床離子交換（EDI/MB-IX）→ 除氣 → 最少化學藥劑
```

### 常見鍋爐問題（Common Boiler Problems）

| 問題（Problem） | 原因（Cause） | 預防措施（Prevention） |
|---------|-------|------------|
| Scale (CaCO₃, CaSO₄) | Hardness in feedwater | Softening, phosphate treatment |
| Silica scale/carryover | High silica, high pH | Silica monitoring, blowdown control |
| Oxygen corrosion | Dissolved O₂ in feedwater | Deaeration, chemical scavenger (sulfite, DEHA) |
| Caustic embrittlement | High NaOH concentration | Coordinated phosphate program |
| Carryover | High TDS, mechanical issues | Blowdown, antifoam, drum internals |
| Return line corrosion | CO₂ in condensate | Neutralizing amines, filming amines |

### 冷凝水回收（Condensate Return）

- 純淨冷凝水：導電度 <10 µS/cm，硬度接近零
- 污染指標：導電度突然升高、出現硬度、酸鹼值下降
- 處理方式：混床離子交換（MB-IX）拋光、皮膜型緩蝕劑保護管路
- 典型回收率目標：>80%（佔蒸汽產量）

## 製程用水（Process Water）

### 食品與飲料業（Food & Beverage）

| 用途（Application） | 典型要求（Typical Requirement） |
|-------------|-------------------|
| Ingredient water | Potable + specific mineral profile |
| CIP rinse | Low TDS (<50 mg/L), no chlorine |
| Boiler feed | Softened or RO permeate |
| Cooling | Standard cooling tower treatment |
| Bottle rinse | Ozonated RO permeate |

### 製藥業（Pharmaceutical，美國藥典純化水/注射用水）

下表為美國藥典（USP）對純化水（Purified Water）及注射用水（Water for Injection, WFI）的品質要求。注射用水的微生物與內毒素標準遠嚴格於純化水，且配送系統須維持高溫循環或臭氧化以抑制微生物。

| 參數（Parameter） | 純化水（USP Purified Water） | 注射用水（WFI） |
|-----------|-------------------|-----|
| Conductivity (25°C) | ≤1.3 µS/cm (Stage 1) | ≤1.3 µS/cm |
| TOC | ≤500 ppb | ≤500 ppb |
| Bacteria | ≤100 CFU/mL | ≤10 CFU/100mL |
| Endotoxin | — | ≤0.25 EU/mL |
| Distribution | Ambient or cold | Hot (>70°C) or ozonated loop |

### 電力產業（Power Generation）

| 系統（System） | 水質（Water Quality） | 處理方式（Treatment） |
|--------|--------------|-----------|
| Cooling (once-through) | Surface water with screening | Chlorination, debris filter |
| Cooling tower | See cooling water section | Full chemical program |
| High-pressure boiler | <0.1 µS/cm, <3 ppb silica | RO + MB-IX + deaeration |
| FGD (flue gas desat.) | Process water, high TDS tolerant | pH control, gypsum management |

## 水回收與零液體排放（Water Reuse and Zero Liquid Discharge）

### 回收水處理流程

```
二級放流水（Secondary Effluent）→ 微過濾/超過濾（MF/UF）→ 逆滲透（RO）→ 紫外線/高級氧化（UV/AOP）→ 再利用（Reuse）
```

回收率：單段逆滲透 75-85%，搭配濃縮液處理可達 90-95%。

### 零液體排放流程（ZLD Train）

零液體排放（Zero Liquid Discharge, ZLD）是將所有廢水轉化為可回用水與固體廢棄物，不排放任何液態廢水。成本約為傳統排放處理的 5-15 倍，僅在法規要求或水資源極度稀缺時採用。

```
廢水（Wastewater）→ 前處理（Pretreatment）→ 逆滲透（RO, 75-85%）→ 鹵水濃縮機（Brine Concentrator, 95-98%）→ 結晶器（Crystallizer）→ 固體廢棄物（Solid Waste）
```

| 階段（Stage） | 技術（Technology） | 濃縮倍數（Concentrate Factor） | 能耗（Energy, kWh/m³ feed） |
|-------|-----------|-------------------|---------------------|
| Primary RO | Membrane | 4-6× | 1-3 |
| High-recovery RO | CCRO, OARO | 10-20× | 3-6 |
| Brine concentrator | MVR evaporator | 50-100× | 20-40 |
| Crystallizer | Forced circulation | To solids | 50-80 |
| Evaporation pond | Solar | To solids | ~0 (land cost) |

### 關鍵設計考量

- 高回收率逆滲透的阻垢劑選擇至關重要（矽垢、硫酸鈣垢、硫酸鋇垢為限制因素）
- 逆滲透段間需設置種晶沉澱或軟化程序
- 機械蒸氣再壓縮（MVR）鹵水濃縮機：不鏽鋼/鈦合金構造，出水含固率 20-25%
- 結晶器：混合鹽處置或選擇性鹽回收
- 零液體排放總成本：為傳統排放處理的 5-15 倍

---

## 相關參考文件

- [technologies.md](technologies.md) — 逆滲透、電去離子、離子交換、超過濾等基礎技術與設計參數
- [reuse.md](reuse.md) — 更廣泛的水再利用脈絡：市政對工業供水、飲用水再利用、處理單元組合
- [desalination.md](desalination.md) — 海水/苦鹹水逆滲透設計、濃縮液管理、熱法海淡
- [semiconductor.md](semiconductor.md) — 超純水規格（可與製藥業注射用水要求對比）
- [troubleshooting.md](troubleshooting.md) — 冷卻水、逆滲透、鍋爐系統問題診斷
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — 工業水系統的環境社會治理碳足跡計算、生命週期評估方法
