# 資安與永續發展參考手冊（Cybersecurity & Sustainability Reference）

## 目錄

1. [IEC 62443 工業資安標準（Industrial Cybersecurity）](#iec-62443-工業資安標準industrial-cybersecurity)
2. [SEMI E187 半導體廠資安（Semiconductor Fab Security）](#semi-e187-半導體廠資安semiconductor-fab-security)
3. [水務基礎設施的零信任架構（Zero Trust for Water Infrastructure）](#水務基礎設施的零信任架構zero-trust-for-water-infrastructure)
4. [AI 代理身分識別與存取控制（AI Agent Identity & Access）](#ai-代理身分識別與存取控制ai-agent-identity--access)
5. [操作技術網路架構（OT Network Architecture）](#操作技術網路架構ot-network-architecture)
6. [機器學習維運與軟體架構（MLOps & Software Architecture）](#機器學習維運與軟體架構mlops--software-architecture)
7. [ESG 與碳排會計（ESG & Carbon Accounting）](#esg-與碳排會計esg--carbon-accounting)
8. [水足跡與生命週期評估（Water Footprint & LCA）](#水足跡與生命週期評估water-footprint--lca)
9. [法規合規自動化（Regulatory Compliance Automation）](#法規合規自動化regulatory-compliance-automation)

## IEC 62443 工業資安標準（Industrial Cybersecurity）

### 安全等級（Security Levels, SL）

下表定義四個安全等級，用於依場域風險評估決定適用的防護強度。等級越高，防護要求與成本也越高。

| 等級 | 說明（Description） | 應用範例（Example） |
|-------|------------|-------------------|
| SL 1 | 防範非蓄意的偶發性違規 | 小型市政淨水廠，風險較低 |
| SL 2 | 防範使用簡單手段的蓄意入侵 | 標準工業場域，多數污水處理廠 |
| SL 3 | 防範使用精密手段的蓄意入侵 | 關鍵基礎設施，大型公用事業 |
| SL 4 | 防範國家級攻擊 | 涉及國安的供水系統 |

### 區域與通道模型（Zone and Conduit Model）

```
┌──────────────────────────────────────────────────┐
│  企業區（Enterprise Zone, IT）                    │
│  ERP、電子郵件、商業應用                           │
├──────── 非軍事區（DMZ，資料二極體/防火牆）─────────┤
│  營運區（Operations Zone, Level 3）               │
│  歷史資料庫、HMI 伺服器、工程工作站               │
├──────── 防火牆（ICS 專用規則）────────────────────┤
│  控制區（Control Zone, Level 2）                  │
│  SCADA 伺服器、OPC UA 伺服器、MPC 控制器          │
├──────── 單向閘道器（Unidirectional gateway）──────┤
│  現場區（Field Zone, Level 0-1）                  │
│  PLC、RTU、感測器、致動器                         │
└──────────────────────────────────────────────────┘
```

### 水務系統的關鍵要求

- 資訊技術（IT）與操作技術（OT）之間必須實施網路分段（mandatory）
- PLC 與 HMI 的修補管理計畫（基於風險評估，部署前須測試）
- 帳號管理：禁止共用帳號、遠端存取必須啟用多因素驗證（MFA）
- 備份與復原：PLC 程式與 SCADA 組態須有經過測試的還原程序
- 針對操作技術環境的專屬事件應變計畫
- 每年執行安全評估與滲透測試

## SEMI E187 半導體廠資安（Semiconductor Fab Security）

### 適用範圍

適用於晶圓廠設備，包含水處理子系統（超純水（UPW）、廢水處理（WWT）、化學品供應）。

### 關鍵要求

- **作業系統強化（OS hardening）**：移除不必要的服務、停用 USB 埠、啟用應用程式白名單
- **網路安全**：設備必須支援網路分段；禁止使用預設密碼
- **惡意程式防護**：優先採用應用程式白名單而非防毒軟體（基於效能考量）
- **存取控制**：角色型存取控制（RBAC），所有組態變更須有稽核日誌
- **弱點管理**：設備供應商須在約定的服務等級協議（SLA）內提供安全修補

### 對晶圓廠水系統的影響

- 超純水與廢水處理控制系統必須符合晶圓廠子設備標準
- 水系統的 SCADA/HMI 須達到與製程設備相同的強化標準
- 水系統往晶圓廠網路的流量須經過過濾與監控
- 水系統供應商的遠端存取須使用跳板伺服器（jump server）+ 多因素驗證 + 連線錄影

## 水務基礎設施的零信任架構（Zero Trust for Water Infrastructure）

### 應用於操作技術的零信任原則

下表將零信任五大原則對應到操作技術環境的具體實作方式。

| 原則（Principle） | 實作方式（Implementation） |
|-----------|---------------|
| 永不信任，持續驗證（Never trust, always verify） | 每個裝置/使用者/代理每次連線都須驗證身分 |
| 最小權限（Least privilege） | PLC 存取限制在特定功能所需的標籤 |
| 假設已被入侵（Assume breach） | 監控操作技術網路內的所有東西向流量 |
| 微分段（Micro-segmentation） | 依製程單元分設獨立網路（超純水、廢水、冷卻） |
| 持續驗證（Continuous verification） | 情境改變（位置、時間、行為）時重新驗證 |

### 架構元件

- **身分提供者（Identity provider）**：Active Directory + RADIUS/TACACS+ 用於操作技術裝置
- **網路存取控制（Network access control）**：有線使用 802.1X；無線使用 WPA3-Enterprise
- **軟體定義邊界（Software-defined perimeter）**：覆蓋網路用於操作技術微分段
- **資料二極體（Data diodes）**：關鍵操作技術對資訊技術邊界的單向閘道器
- **SIEM/SOAR**：集中式日誌管理，搭配操作技術專用偵測規則

## AI 代理身分識別與存取控制（AI Agent Identity & Access）

### SPIFFE/SPIRE 框架

- 每個 AI 代理工作負載都會收到一個 SPIFFE 識別碼（如 `spiffe://water-plant/agent/optimizer`）
- 短效 X.509 憑證（SVIDs）自動輪替
- 代理對系統的通訊不使用靜態 API 金鑰或長效權杖（token）

> 💡 **小知識：為什麼 AI 代理需要身分識別？**
> 就像每位進入水廠的工作人員都要刷門禁卡一樣，AI 代理也需要「數位門禁卡」（SPIFFE 識別碼），而且這張卡會自動過期並換新，避免被盜用。這比傳統的固定密碼安全得多。

### 授權模型

```
代理 → 請求 → 政策引擎（OPA/Cedar） → 允許/拒絕
                      ↓
         上下文：代理身分、時間、製程狀態、安全模式
```

下表定義各代理角色的操作權限，從唯讀到緊急應變逐級升高。

| 代理角色（Agent Role） | 讀取數據 | 寫入設定值 | 緊急停機 | 直接控制致動器 |
|-----------|-----------|---------------|---------------|----------------|
| 監控型（Monitor） | 是 | 否 | 否 | 否 |
| 建議型（Advisor） | 是 | 僅提出建議 | 否 | 否 |
| 最佳化型（Optimizer） | 是 | 在限定範圍內 | 否 | 否 |
| 控制型（Controller） | 是 | 是（有邊界） | 僅觸發 | 否 |
| 緊急型（Emergency） | 是 | 覆寫至安全狀態 | 是 | 透過 PLC 安全迴路 |

### 稽核要求

- 所有代理行為須記錄：時間戳、代理識別碼、操作行為、目標、舊值、新值、變更理由
- 對代理行為進行異常偵測：非預期的設定值變更、異常查詢模式
- 任何授權層級提升皆須人工審查

## 操作技術網路架構（OT Network Architecture）

### 水務系統的通訊協定堆疊

下表由現場層到企業層列出各通訊協定的適用場景與安全機制，用於設計合規的網路架構。

| 層級（Layer） | 通訊協定（Protocol） | 使用場景 | 安全機制（Security） |
|-------|----------|----------|----------|
| 現場層（Field） | Modbus RTU（序列） | 舊式 PLC、簡單感測器 | 無（須以實體隔離） |
| 現場層（Field） | Modbus TCP | 標準 PLC 通訊 | TLS 封裝或 VPN |
| 控制層（Control） | OPC UA | 結構化數據、發布/訂閱、內建安全 | X.509 憑證、加密 |
| 整合層（Integration） | MQTT Sparkplug B | 邊緣對雲端、統一命名空間架構 | TLS, 基於角色的主題存取控制（RBAC） |
| 企業層（Enterprise） | REST/gRPC | 應用程式 API、儀表板 | OAuth 2.0, mTLS |

### 統一命名空間（Unified Namespace, UNS）

水處理系統的主題結構範例：

```
plant/
├── intake/
│   ├── flow_rate
│   ├── turbidity
│   └── pH
├── pretreatment/
│   ├── coagulant_dose
│   └── settled_turbidity
├── ro_system/
│   ├── train_1/
│   │   ├── feed_pressure
│   │   ├── permeate_conductivity
│   │   └── normalized_flux
│   └── train_2/...
├── distribution/
│   ├── residual_chlorine
│   └── pressure
└── ai/
    ├── predictions/
    ├── alerts/
    └── setpoint_recommendations/
```

## 機器學習維運與軟體架構（MLOps & Software Architecture）

### 機器學習管線（ML Pipeline）

```
數據攝取 → 特徵倉庫 → 訓練 → 驗證 → 模型註冊庫 → 部署 → 監控
     ↑                                                        │
     └──────────────────── 重新訓練觸發 ←──────────────────────┘
```

### 關鍵元件

下表列出機器學習維運管線各元件的推薦工具與用途。

| 元件（Component） | 推薦工具 | 用途（Purpose） |
|-----------|------------------|---------|
| 特徵倉庫（Feature store） | Feast, Tecton | 確保訓練與推論使用一致的特徵 |
| 實驗追蹤（Experiment tracking） | MLflow, Weights & Biases | 超參數追蹤、模型比較 |
| 模型註冊庫（Model registry） | MLflow Registry, Vertex AI | 版本管理、核准流程、血統追蹤 |
| 推論服務（Serving） | Seldon, KServe, ONNX Runtime | 模型 API、A/B 測試、金絲雀部署 |
| 監控（Monitoring） | Evidently, NannyML | 漂移偵測、效能追蹤 |
| 編排調度（Orchestration） | Airflow, Prefect, Dagster | 管線排程、相依性管理 |

### 漂移偵測（Drift Detection）

下表定義四種模型漂移類型與對應的偵測方法及處置方式。當偵測指標超標時，代表模型可能不再可靠。

| 漂移類型（Drift Type） | 偵測方法（Detection） | 處置方式（Action） |
|-----------|-----------|--------|
| 數據漂移（輸入分布偏移） | PSI > 0.2 或 KS 檢定 p < 0.05 | 調查來源變化、考慮重新訓練 |
| 概念漂移（輸入與輸出關係改變） | 錯誤率上升、ADWIN 演算法 | 以最新數據重新訓練 |
| 模型過期 | 基於日曆（超過 30 天） | 排程重新訓練 |
| 預測異常 | 輸出超出預期範圍 | 告警，降級至物理模型 |

### 時序資料庫選型（Time-Series Database Selection）

下表比較四種時序資料庫的特性，用於依場域需求選擇合適方案。

| 資料庫（Database） | 優勢（Strengths） | 最適場景（Best For） |
|----------|----------|---------|
| InfluxDB | 專用時序資料庫，Flux 查詢語言 | 感測器數據、監控 |
| TimescaleDB | PostgreSQL 擴充，支援 SQL | 需要 SQL 生態系時 |
| QuestDB | 極高寫入吞吐量，支援 SQL | 超高頻率數據 |
| Apache IoTDB | 為物聯網設計，輕量級 | 邊緣/資源受限環境 |

## ESG 與碳排會計（ESG & Carbon Accounting）

### 水處理的碳排範疇定義（Scope Definitions）

下表依據溫室氣體盤查議定書（GHG Protocol）的三個範疇分類水處理廠的碳排來源。

| 範疇（Scope） | 排放來源 | 範例（Example） |
|-------|---------|---------|
| 範疇一（Scope 1） | 自有營運的直接排放 | 沼氣燃燒、發電機燃料、處理過程的 CH₄/N₂O |
| 範疇二（Scope 2） | 外購電力與熱能 | 泵浦、鼓風機、紫外線消毒、臭氧產生器用電 |
| 範疇三（Scope 3） | 價值鏈排放 | 化學品生產與運輸、污泥處置、工程施工 |

### 水處理碳排放因子（Carbon Emission Factors）

下表彙整水處理相關的碳排放因子。氧化亞氮（N₂O）的全球暖化潛勢是二氧化碳的 273 倍（IPCC AR6, 2021），是廢水處理廠最需關注的直接排放源。

| 排放源（Source） | 排放因子（Emission Factor） | 備註（Notes） |
|--------|----------------|-------|
| 電力（電網平均） | 0.3-0.8 kg CO₂e/kWh | 因地區而異 |
| 曝氣能耗 | 0.2-0.4 kWh/m³ treated | 污水處理廠最大能耗來源 |
| 硝化過程的 N₂O | 0.005-0.035 kg N₂O-N/kg TN | 全球暖化潛勢（GWP₁₀₀）= 273 倍 CO₂（IPCC AR6, 2021）；變異極大 |
| 厭氧區的 CH₄ | 0.001-0.02 kg CH₄/m³ | GWP₁₀₀ = 27.9 倍 CO₂（含氣候碳回饋；IPCC AR6, 2021）|
| 化學品（三氯化鐵 FeCl₃） | ~0.3 kg CO₂e/kg FeCl₃ | 含生產與運輸 |
| 化學品（氫氧化鈉 NaOH 50%） | ~1.0 kg CO₂e/kg NaOH | 生產過程能耗密集 |
| 化學品（高分子絮凝劑） | ~2.5 kg CO₂e/kg polymer | 石油衍生物 |
| 污泥運輸 | ~0.1 kg CO₂e/tonne-km | 卡車運輸 |
| 沼氣發電抵減 | -0.2 kg CO₂e/kWh generated | 抵減範疇二排放 |

### 自動碳排計算

```
Total CO₂e = Σ(energy × grid_factor) + Σ(chemical × chemical_factor)
           + Σ(process_emissions) + Σ(transport) - Σ(energy_recovery_credits)
```

透過以下系統串接實現自動化：
- SCADA（電力表、流量計、化學品加藥率）
- 化學品庫存管理系統（到貨數量）
- 電網碳排強度 API（即時或月平均）
- 污泥清運紀錄（重量、距離）

## 水足跡與生命週期評估（Water Footprint & LCA）

### 水足跡組成（ISO 14046）

下表定義水足跡的三個組成部分，用於全面評估水處理系統的水資源衝擊。

| 組成（Component） | 定義（Definition） | 應用場景（Application） |
|-----------|-----------|-------------|
| 藍水（Blue water） | 地表水/地下水的消耗 | 補充水、蒸發損失 |
| 綠水（Green water） | 雨水（土壤水分）的消耗 | 與農業再利用相關 |
| 灰水（Grey water） | 將污染物稀釋至標準所需的水量 | 排放衝擊量化 |

### 水系統生命週期評估方法論（ISO 14040/44）

**功能單位（Functional unit）**：1 立方公尺達到指定水質標準的處理水

**系統邊界（System boundary）**：包含原水取水、處理、配水、收集、廢水處理、排放/回用

**衝擊類別（Impact categories）**：
- 氣候變遷（kg CO₂e）
- 優養化（kg PO₄e 或 kg Ne）
- 酸化（kg SO₂e）
- 淡水生態毒性
- 人體毒性
- 資源耗竭（水、能源、材料）

### 決策支援

比較處理方案時，以下列格式呈現生命週期評估結果：

```
| 方案 | 資本支出（CAPEX） | 年營運支出（OPEX/yr） | kgCO₂e/m³ | kWh/m³ | 化學品 kg/m³ | 水回收率 |
```

須納入關鍵假設的敏感度分析（能源價格、電網碳排強度、化學品成本）。

## 法規合規自動化（Regulatory Compliance Automation）

### 合規監測管線

```
感測器數據 → 即時限值檢查 → 告警（接近限值時）
                          → 違規報告（超標時）
                          → 法規報表產生（定期排程）
```

### 主要法規框架

下表列出水處理相關的法規框架與對應的自動化機會。

| 框架（Framework） | 範圍（Scope） | 自動化機會（Automation Opportunity） |
|-----------|-------|----------------------|
| ISO 14001 | 環境管理系統 | 自動產生不符合報告、追蹤矯正措施 |
| ISO 50001 | 能源管理 | 即時能源關鍵績效指標（KPI）儀表板、自動計算能源績效指標（EnPI） |
| EU CSRD/ESRS | 企業永續報告 | 自動收集 E1-E5 水資源/污染揭露數據 |
| EPA NPDES | 美國排放許可 | 自動化排放監測報告（DMR）準備 |
| Taiwan EPA | 放流水標準 | 即時合規儀表板、自動產生月報表 |
| SEMI S23 | 能源、水與材料節約 | 追蹤每片晶圓的超純水消耗量、對比目標基準 |

### 區塊鏈用於 ESG 認證（Blockchain for ESG Attestation）

- 不可竄改的時間戳紀錄：碳排數據、水質結果、化學品使用量
- 智慧合約用於自動合規驗證
- 稽核軌跡：從感測器讀值 → 數據管線 → 報告數值（完整血統）
- 技術選項：Hyperledger Fabric（許可制）、Ethereum L2（公開認證）

---

## 相關參考文件

- [ai-and-control.md](ai-and-control.md) — 由 SPIFFE/SPIRE 保護的 AI 代理架構、邊緣部署模式、模型驗證
- [delivery-and-ops.md](delivery-and-ops.md) — GitOps 部署管線、基礎設施即程式碼用於網路分段、可觀測性與網站可靠性工程
- [desalination.md](desalination.md) — 海水淡化的能耗/成本基準與碳足跡數據
- [reuse.md](reuse.md) — 各水源的能耗與碳足跡比較
- [semiconductor.md](semiconductor.md) — SEMI E187 背景：晶圓廠水處理子系統的設備資安要求
- [industrial.md](industrial.md) — 需要 ESG 碳排會計的工業水系統
