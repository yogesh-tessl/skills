# AI 與控制系統及數位分身參考手冊（AI, Control Systems & Digital Twins Reference）

## 目錄

1. [物理資訊神經網路（Physics-Informed Neural Networks, PINNs）](#物理資訊神經網路physics-informed-neural-networks-pinns)
2. [時序基礎模型（Time-Series Foundation Models）](#時序基礎模型time-series-foundation-models)
3. [圖神經網路應用於供水管網（Graph Neural Networks for Water Networks）](#圖神經網路應用於供水管網graph-neural-networks-for-water-networks)
4. [虛擬量測（Virtual Metrology）](#虛擬量測virtual-metrology)
5. [控制架構模式（Control Architecture Patterns）](#控制架構模式control-architecture-patterns)
6. [邊緣部署（Edge Deployment）](#邊緣部署edge-deployment)
7. [數位分身整合（Digital Twin Integration）](#數位分身整合digital-twin-integration)
8. [自主式 AI 水務操作（Agentic AI for Water Operations）](#自主式-ai-水務操作agentic-ai-for-water-operations)
9. [模型驗證與監控（Model Validation & Monitoring）](#模型驗證與監控model-validation--monitoring)

## 物理資訊神經網路（Physics-Informed Neural Networks, PINNs）

### 核心概念

將控制方程式（governing PDEs）直接嵌入神經網路的損失函數中：

```
L_total = L_data + λ_physics * L_PDE + λ_BC * L_boundary + λ_IC * L_initial
```

其中 `L_PDE` 用來懲罰違反控制方程式（如對流擴散方程式、反應動力學）的情況。

> 💡 **小知識：物理資訊神經網路（PINNs）**
> 傳統機器學習只從數據學規律，如果數據不夠就容易「亂猜」。物理資訊神經網路則是在訓練過程中同時要求模型遵守物理定律，就像考試時除了答對還要「寫出合理的計算過程」，因此在數據稀少時（少於 100 筆標記數據）表現遠優於純數據驅動模型。

### 水處理應用場景

下表列出物理資訊神經網路在水處理各環節的對應方程式與優勢，用於評估哪些場景適合導入此技術。

| 應用場景（Application） | 控制方程式（Governing Equation） | 效益（Benefit） |
|------------|-------------------|---------|
| 沉澱池污泥層預測 | Kynch sedimentation theory | 稀少數據即可預測污泥毯位 |
| 逆滲透膜傳輸 | Solution-diffusion model | 預測新操作條件下的通量與截留率 |
| 生物反應槽動力學 | Monod + mass balance ODEs | 可外推至訓練數據範圍之外 |
| 管網水力模擬 | Darcy-Weisbach + continuity | 即時壓力與流量估算 |
| 化學加藥優化 | Reaction rate equations | 以最少實驗數據優化加藥量 |
| 污染物傳輸 | Advection-dispersion equation | 預測地下水污染羽流遷移 |

### 實作指引

- 從已建立的偏微分方程式著手，用物理資訊神經網路學習未知參數（如反應速率常數）
- 使用自動微分（automatic differentiation，PyTorch/JAX）計算偏微分方程式殘差
- 透過自適應加權（如學習率退火、基於神經正切核（Neural Tangent Kernel, NTK）的方法）平衡數據損失與物理損失
- 驗證要求：模型必須先通過已知解析解的驗證，才能部署到真實數據
- 數據稀缺情境（標記數據 < 100 筆）：物理資訊神經網路顯著優於純數據驅動模型

### 神經運算子（Neural Operators）

下表比較三種主要神經運算子架構，用於選擇適合不同水處理模擬需求的方案。

| 架構（Architecture） | 使用場景（Use Case） | 優勢（Advantage） |
|-------------|----------|-----------|
| DeepONet | 運算子學習（輸入函數 → 輸出函數） | 彈性的輸入/輸出映射 |
| FNO（Fourier Neural Operator） | 紊流流場、混合模擬 | 週期性場域的頻譜效率高 |
| U-Net 變體 | 空間場預測（濃度分布圖） | 適合類影像的感測器網格 |

## 時序基礎模型（Time-Series Foundation Models）

### 水處理領域模型比較

下表為目前主要時序基礎模型的特性比較。選擇依據為：部署環境（雲端或邊緣）、數據量多寡、以及是否需要可解釋性。粗體標示為水處理場域已有驗證證據的模型。

| 模型（Model） | 架構（Architecture） | 參數量（Params） | 上下文長度（Context） | 優勢（Strengths） | 限制（Limitations） |
|-------|-------------|--------|---------------|-----------|-------------|
| **TTM**（Tiny Time Mixers） | MLP-Mixer | 1-5M | 512-1024 | 比 Chronos 小 8-709 倍且準確度高 17-32%；適合邊緣/操作技術環境部署 | 生態系較新，整合工具較少 |
| PatchTST | Patched Transformer | ~1M | 512-1024 | 通道獨立、高效率；充足數據（訓練集 ≥80%）時表現強 | 單尺度分割 |
| **TFT**（Temporal Fusion Transformer） | 多時距注意力 + 變數選擇 | ~5-10M | 可變 | 可解釋的注意力權重與變數重要性；逆滲透膜預測 R² > 0.98 | 訓練較慢、架構複雜 |
| MOIRAI | 遮罩式編碼器（Masked encoder） | ~300M | 可變 | 零樣本遷移學習（zero-shot），支援任意變數 | 需要大量預訓練語料 |
| TimesFM | 僅解碼器（Decoder-only） | ~200M | 512 | Google 規模預訓練，零樣本能力 | 微調彈性有限 |
| Chronos | T5 分詞架構 | ~20-710M | 512 | 機率式輸出、已預訓練；在氮預測（data scarcity）場景驗證有效 | 僅支援單變數、邊緣部署體積大 |
| **Lag-Llama** | 僅解碼器 + 滯後共變數 | ~1-5M | 可變 | 機率式輸出、基於滯後特徵（類似 ARIMA 概念）；不確定性量化 | 較新，水處理領域驗證有限 |
| **N-HiTS** | 階層式內插（Hierarchical interpolation） | ~1-5M | 長 | 多尺度分解、可解釋；已用於廢水合流溢排（CSO）研究 | 社群採用度低於 PatchTST |
| TiDE | 多層感知器架構（MLP-based） | ~1M | 長 | 推論快、長期預測 | 表達力低於 Transformer |
| 傳統 LSTM | 遞迴架構（Recurrent） | ~100K | 50-200 | 簡單、成熟 | 梯度消失、記憶短 |

### 建議選擇策略

- **快速基線**：LSTM 或 TiDE — 訓練快速、準確度尚可
- **生產環境預測**：PatchTST 搭配領域微調 — 數據充足時最佳準確度/速度平衡
- **零樣本 / 新建廠 / 數據稀缺**：微調過的 Chronos — 訓練數據 <60% 時優於基線；MOIRAI 或 TimesFM 可零樣本使用
- **邊緣/操作技術環境部署**：TTM — 1-5M 參數可部署於工業電腦；比 Chronos 小 8-709 倍，準確度相當或更佳
- **需要可解釋性**：TFT — 注意力權重與變數重要性評分協助操作人員理解預測
- **不確定性量化**：Chronos 或 Lag-Llama — 原生機率式輸出，適用於風險評估決策
- **異常偵測**：基於重建的方法（自編碼器（autoencoder））或預測殘差分析

### 水處理領域驗證證據

下表彙整已發表研究中，時序基礎模型在水處理場景的實測結果，作為模型選型參考。

| 模型（Model） | 應用場景 | 關鍵發現 | 來源 |
|-------|------------|-------------|--------|
| Chronos（微調） | 污水處理廠氮預測 | 數據稀缺（訓練集 <60%）時優於基線；PatchTST/LSTM 在 ≥80% 數據時勝出 | ScienceDirect 2025 |
| TFT | 逆滲透膜壓差預測 | R² > 0.9813，勝過 LSTM（R² > 0.9364）；可解釋的變數重要性 | ScienceDirect Jan 2025 |
| TST + TFT | 多段水質監測 | 組合式 Transformer 方法用於序列處理階段 | Nature Scientific Reports 2025 |
| TTM | 通用時序基準測試 | 比 Chronos 小 1/8 至 1/709 倍的模型量體下，準確度提升 17-32%（NeurIPS 2024） | IBM Research / NeurIPS 2024 |

**關鍵結論**：基礎模型在數據稀缺場景（新建廠、新感測器、歷史數據有限）價值最大。當有充足的場域數據時，微調過的 PatchTST 或 TFT 通常優於更大的基礎模型。

### 水處理系統的特徵工程（Feature Engineering）

關鍵滯後特徵設計：
- 流量：1 小時、6 小時、24 小時滾動統計
- 酸鹼值（pH）、濁度、導電度：15 分鐘、1 小時、4 小時窗口
- 溫度：24 小時正弦編碼以捕捉日夜週期
- 化學加藥：以水力停留時間（Hydraulic Retention Time, HRT）窗口計算累積劑量
- 季節性：年度日期編碼以反映原水水質變化
- 圖特徵（用於圖神經網路模型）：鄰接矩陣、節點度、管徑/管齡/材質、水力距離

## 圖神經網路應用於供水管網（Graph Neural Networks for Water Networks）

供水配水與收集管網本質上是圖結構 — 節點（接合點、水塔、蓄水池）透過邊（管線、泵浦、閥門）連接。圖神經網路（Graph Neural Network, GNN）直接利用這種拓撲結構。

### 應用場景

下表彙整圖神經網路在供水管網的主要應用與其效能表現。

| 應用場景 | 架構（Architecture） | 表現（Performance） | 來源（Source） |
|------------|-------------|-------------|--------|
| 漏水偵測 | GCN / GAT 分析壓力訊號 | 準確度 90-99% | MDPI, EUSIPCO 2025 |
| 感測器佈點優化 | 圖神經網路 + 拓撲感知聚類 | 最少感測器達最佳覆蓋 | Various 2024-2025 |
| 可解釋漏水定位 | 模糊圖神經網路（Fuzzy GNN） | 偵測 F1=0.889、定位 F1=0.814 | 2025 |
| 污染源鑑定 | 訊息傳遞圖神經網路（Message-passing GNN） | 從感測器觀測快速回溯 | 2024 |
| 空間用水需求預測 | 時空圖神經網路（Spatio-temporal GNN） | 捕捉節點間流量相依性 | 2024-2025 |

### 實作步驟

1. **建構圖結構**：從地理資訊系統（GIS）/ EPANET 管網模型建立 — 節點 = 接合點/水塔、邊 = 管線
2. **節點特徵**：壓力、流量、水質、用水需求、高程
3. **邊特徵**：管徑、管長、粗糙度（Hazen-Williams C 值）、材質、管齡
4. **架構選擇**：GCN 或 GAT 層 → 讀出層 → 預測頭（分類用於漏水偵測、迴歸用於流量/壓力預測）
5. **訓練數據**：從 SCADA 歷史資料庫取標記數據加上已知漏水/事件紀錄；以 EPANET 水力模擬擴增數據

### 關鍵考量

- **可解釋性**：使用注意力機制的圖神經網路（GAT）或模糊圖神經網路（Fuzzy GNN）可呈現邊/節點重要性 — 對水務工程師至關重要
- **規模擴展**：大型管網（10K+ 節點）可能需要圖分割或抽樣策略
- **動態拓撲**：閥門開關會改變圖結構 — 使用動態鄰接矩陣或邊遮罩處理
- **與時序模型互補**：圖神經網路處理空間相依性；結合時序模型（如時空圖神經網路或 GNN + LSTM/Transformer）達到完整覆蓋

## 虛擬量測（Virtual Metrology）

透過線上即時感測器推估無法即時量測的水質參數。

下表列出常見的離線參數虛擬量測方案，包含輸入感測器組合、模型類型與更新頻率。

| 目標參數（離線） | 典型輸入（線上感測器） | 模型類型 | 更新頻率 |
|------------------|------------------------|------------|-----------------|
| 五日生化需氧量（BOD₅） | DO, pH, 濁度, NH₃, 流量, MLSS | 整合模型（XGBoost + NN） | 每小時 |
| 化學需氧量（COD） | UV254, 濁度, 導電度, TOC（線上） | 線性迴歸 + 校正 | 15 分鐘 |
| 總大腸桿菌群 | 濁度, 餘氯, UV 劑量, 流量 | 分類/迴歸 | 30 分鐘 |
| 污泥沉降性（SVI） | MLSS, DO, SRT, 顯微鏡影像 | CNN + 表格數據 | 每日 |
| 薄膜完整性 | TMP, 通量, 透過水濁度, 粒子計數 | 異常偵測 | 連續 |
| 金屬濃度 | pH, ORP, 導電度, 流量 | 物理資訊神經網路 + 沉澱模型 | 每小時 |

### 校正策略

- 每收到新的實驗室結果即重新訓練或更新模型（線上學習（online learning）或定期批次更新）
- 維護偏差校正層：`y_corrected = model_output + bias(t)`
- 當預測信賴區間超過閾值時發出警報

## 控制架構模式（Control Architecture Patterns）

### 階層式控制堆疊（Hierarchical Control Stack）

```
┌─────────────────────────────────────────┐
│  第四層：AI 監督層（分鐘至小時級）       │  最佳設定值規劃
│  - 需求預測                              │  能源優化
│  - 程序優化                              │  預測性排程
├─────────────────────────────────────────┤
│  第三層：模型預測控制（MPC，秒至分鐘級） │  多變數最佳化
│  - 約束處理                              │  具有硬性安全邊界
│  - 干擾抑制                             │
├─────────────────────────────────────────┤
│  第二層：PID 控制（毫秒至秒級）          │  快速、可靠、
│  - 調節控制                              │  穩定性經過驗證
│  - 安全聯鎖                             │
├─────────────────────────────────────────┤
│  第一層：感測器與致動器                  │  實體層
│  - 閥門、泵浦、加藥系統                 │
└─────────────────────────────────────────┘
```

### 關鍵規則

- AI 絕不直接控制致動器；必須透過模型預測控制（MPC）/ PID 層下達指令
- 安全聯鎖（safety interlocks）在 PID/PLC 層獨立運作 — AI 無法覆寫
- 降級機制：AI 層故障時，MPC 維持上一組良好設定值；MPC 故障時，PID 維持穩定
- 速率限制：AI 設定值變更受最大爬升率約束（防止水力衝擊（hydraulic shock））

> 💡 **小知識：為什麼 AI 不能直接控制閥門？**
> 水處理系統就像人體的血液循環，突然大幅改變流量就像血壓驟變一樣危險。因此 AI 只能「建議」設定值，實際控制仍由經過驗證的 PID/MPC 層執行，就像醫生開處方但護理師依標準流程給藥。

### 水處理系統的模型預測控制（MPC）

下表列出常見製程的控制變數（CV）、操作變數（MV）與干擾因子。

| 製程（Process） | 控制變數（CVs） | 操作變數（MVs） | 干擾因子（Disturbances） |
|---------|-----|-----|-------------|
| 混凝（Coagulation） | 沉後濁度, pH | 混凝劑劑量, 酸/鹼 | 原水濁度, 流量 |
| 活性污泥法 | DO, 放流水 NH₃-N | 鼓風機轉速, 迴流污泥率 | 進流負荷, 溫度 |
| 逆滲透系統 | 透過水水質, 回收率 | 進料壓力, 濃縮液閥 | 溫度, 進料 TDS |
| 消毒 | 餘氯, CT 值 | 氯劑量, 接觸時間 | 流量, 氯需求量 |
| 酸鹼值控制 | pH | 酸/鹼劑量 | 流量, 鹼度變化 |

### AI 輔助 PID 調參

- 使用貝葉斯最佳化（Bayesian Optimization）或強化學習（Reinforcement Learning）調整 Kp、Ki、Kd
- 目標：最小化誤差積分平方值（ISE, integral squared error）並約束超調量（overshoot）
- 當製程動態改變時重新調參（季節變化、膜老化、生物膜增長）

## 邊緣部署（Edge Deployment）

### 模型優化流程

```
訓練（雲端/GPU） → 量化（INT8/FP16） → ONNX 匯出 → 邊緣推論引擎
```

下表比較各邊緣推論引擎的目標硬體與延遲，用於依現場設備選擇合適的部署方案。

| 執行環境（Runtime） | 目標硬體 | 延遲（Latency） | 備註 |
|---------|---------------|---------|-------|
| ONNX Runtime | x86/ARM CPU | 1-50 ms | 通用性佳、支援度高 |
| TFLite | ARM（Raspberry Pi, Jetson） | 1-20 ms | 行動/嵌入式最佳化 |
| OpenVINO | Intel CPU/VPU | 1-10 ms | Intel 硬體最佳化 |
| TensorRT | NVIDIA GPU | <1 ms | GPU 推論，支援批次處理 |
| Wasm（WASI-NN） | 任意平台（瀏覽器, PLC, 閘道器） | 5-100 ms | 可攜式、沙盒隔離、新興技術 |

### 邊緣架構

```
感測器 → PLC/RTU → 邊緣閘道器 → [模型推論 + 本地資料庫] → SCADA/雲端
                                 ↓
                         本地控制指令（透過 OPC UA 對 PLC）
```

- **K3s**：輕量級 Kubernetes，用於在工業電腦上管理模型容器
- **MQTT Sparkplug B**：標準化主題命名空間用於感測器數據；具有裝置上下線（birth/death）憑證機制
- **OPC UA**：安全且結構化的 PLC 標籤讀寫；支援發布/訂閱（pub/sub）模式的即時通訊

### 部署檢核清單

- [ ] 模型已對照物理模型基線完成驗證
- [ ] 量化後準確度損失 < 1%（對比全精度模型）
- [ ] 推論延遲在控制迴路要求範圍內
- [ ] 已定義降級行為（使用上一次良好輸出或安全預設值）
- [ ] 模型版本控制與回滾機制已就位
- [ ] 監控機制：輸入漂移偵測、預測信心度追蹤
- [ ] 安全開機（secure boot）與簽章模型封裝

## 數位分身整合（Digital Twin Integration）

### 架構

```
實體廠區 → 感測器 → 數據平台 → 數位分身引擎
                                  ├── 物理模型（EPANET, PHREEQC, GPS-X）
                                  ├── AI 模型（以歷史數據 + 物理模型訓練）
                                  └── 視覺化（3D/儀表板）
                                          ↓
                                  假設情境分析 / 最佳化 → 控制指令
```

### 模擬工具

下表列出水處理領域常用的數位分身模擬工具與其整合方式。

| 工具（Tool） | 適用領域 | 整合模式 |
|------|--------|-------------------|
| EPANET | 管網水力與水質模擬 | Python API（wntr），以感測器數據即時校正 |
| PHREEQC | 地球化學、化學形態、沉澱預測 | Python 介面（phreeqpy），驗證結垢/沉澱預測 |
| GPS-X / BioWin | 生物處理程序（ASM1/2d/3） | 透過 API 共模擬，以 MLSS/NH₃/NO₃ 數據校正 |
| WEST | 廢水程序模擬 | 類似 GPS-X，基於 Modelica |
| OpenFOAM | 計算流體力學（CFD，混合、沉降模擬） | 離線驗證物理資訊神經網路/神經運算子模型 |

### 校正迴路

1. 以 1-15 分鐘間隔收集感測器數據（流量、水質、能耗）
2. 以量測輸入執行物理模型
3. 比較預測值與實測值
4. 調整模型參數（透過最佳化演算法自動校正）
5. 殘差超過閾值時標記警示（判斷為模型故障或感測器故障）

## 自主式 AI 水務操作（Agentic AI for Water Operations）

### 代理架構（Agent Architecture）

```
使用者 / 告警 / 排程
        ↓
   協調代理（Orchestrator Agent）
        ├── 數據代理（查詢時序資料庫（TSDB）、SCADA 歷史庫）
        ├── 診斷代理（根因分析，思維鏈（Chain-of-Thought）推理）
        ├── 最佳化代理（執行數位分身情境模擬）
        ├── 合規代理（檢查法規限值、生成報表）
        └── 行動代理（產生工單、透過 MPC 調整設定值）
```

### 檢索增強生成用於現場維護（RAG for Field Maintenance）

- 建立索引：設備手冊、管線儀表圖（P&IDs）、標準作業程序（SOPs）、歷史事件報告
- 檢索流程：嵌入查詢 → 向量搜尋 → 重排序 → 上下文注入
- 使用情境：現場操作人員詢問「三號泵浦（P-301）出現氣蝕（cavitation）現象，該檢查什麼？」
- 回應將從手冊、歷史修復紀錄、與製程數據上下文中綜合產出

### 代理安全層級

下表定義各授權層級的允許操作，預設採用「建議型」層級。

| 授權層級（Authorization Level） | 允許操作（Allowed Actions） |
|--------------------|----------------|
| 唯讀（Read-only） | 查詢數據、產生報表、發送告警 |
| 建議型（Advisory） | 以上全部 + 建議設定值變更（人員核准後執行） |
| 有監督自動化（Supervised auto） | 以上全部 + 在預定義範圍內自動執行（人員監控） |
| 全自動化（Full auto） | 以上全部 + 自主運作（緊急覆寫永遠可用） |

預設採用「建議型」層級；僅在組織明確核准並完成安全審查後才升級。

## 模型驗證與監控（Model Validation & Monitoring）

### 部署前驗證

下表列出模型上線前必須通過的五項檢核，確保模型在物理一致性、邊界行為、準確度等方面達標。

| 檢核項目（Check） | 方法（Method） | 通過標準（Pass Criteria） |
|-------|--------|--------------|
| 物理一致性 | 預測結果質量平衡 | 不平衡量 < 2% |
| 邊界行為 | 測試輸入範圍極端值 | 預期應單調之處呈現單調 |
| 內插準確度 | K 折交叉驗證（K-fold cross-validation） | R² > 0.9 或領域特定指標 |
| 外推安全性 | 測試訓練範圍之外的數據 | 優雅降級，無異常預測值 |
| 時序穩定性 | 在不同時間段測試 | 跨季節表現一致 |

### 生產環境監控

下表定義上線後持續監控的指標與對應處置方式，用於及時發現模型退化。

| 監控指標（Metric） | 偵測方法（Detection Method） | 處置方式（Response） |
|--------|-----------------|----------|
| 輸入漂移（Input drift） | KL 散度（KL divergence）、特徵分布的 PSI 指標 | 告警，調查水源變化 |
| 概念漂移（Concept drift） | 預測誤差呈上升趨勢 | 以最新數據重新訓練 |
| 預測信心度 | 整合模型歧見度（ensemble disagreement）或蒙地卡羅丟棄法（MC dropout） | 標記低信心度預測 |
| 延遲退化 | P95 推論時間追蹤 | 優化模型或擴展運算資源 |
| 模型過期 | 上次訓練至今天數 | 觸發重新訓練管線 |

---

## 相關參考文件

- [delivery-and-ops.md](delivery-and-ops.md) — 基礎設施即程式碼部署模式、GitOps/ArgoCD 工作流程、可觀測性堆疊、知識圖譜用於檢索增強生成
- [cybersecurity-and-sustainability.md](cybersecurity-and-sustainability.md) — AI 代理身分識別（SPIFFE/SPIRE）、操作技術網路安全、機器學習維運管線安全
- [troubleshooting.md](troubleshooting.md) — 與 AI 驅動根因分析整合的診斷框架
- [technologies.md](technologies.md) — 物理資訊模型的製程基礎知識（EPANET, PHREEQC, GPS-X）
