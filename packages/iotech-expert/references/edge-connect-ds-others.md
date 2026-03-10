<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/s7-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/ethercat-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/profinet-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/ethernet-ip-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/ble-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/virtual-device-service-component.html
  Synced: 2026-03-07
-->

# Edge Connect 裝置服務元件（其他協定）

## 目錄

- [S7（西門子 PLC）](#s7西門子-plc)
- [EtherCAT](#ethercat)
- [EtherNet/IP](#ethernetip)
- [PROFINET](#profinet)
- [BLE（藍牙低功耗）](#ble藍牙低功耗)
- [Virtual（虛擬裝置）](#virtual虛擬裝置)

---

## S7（西門子 PLC）

### 功能概述

S7 裝置服務透過 S7 協定與西門子 S7 系列可程式邏輯控制器（PLC）進行資料交換。支援資料區塊（Data Block, DB）讀寫、程序輸入/輸出映像區存取、位元級讀寫、計時器與計數器操作，以及多重讀寫批次操作以最佳化通訊效率。

### Profile 屬性表格

| 屬性 | 必要性 | 說明 | 有效值 |
|------|--------|------|--------|
| `type` | 必填 | S7 請求類型 | DB, IPU, IPI, Marker, Timer, IEC_Timer, IEC_Counter, Counter, PLC, MISC |
| `DB_number` | 條件式 | 資料區塊索引 | 非負整數 |
| `start` | 條件式 | 起始位元組偏移（從 0 起算） | 非負整數 |
| `size` | 條件式 | 最大字串長度 | 非負整數 |
| `array_size` | 條件式 | 陣列元素數量 | 非負整數 |
| `operation` | 條件式 | PLC/MISC 類型的操作動作 | state, conn_state, err_text, job_res |
| `bitIndex` | 選填 | Bool 類型的位元位置 | 0–7（預設 0） |
| `timeBase` | 選填 | 計時器時間基底 | "s", "10s", "10ms", "100ms" |
| `counterType` | 條件式 | IEC 計數器資料型別 | "uint8", "uint16", "uint32", "int8", "int16", "int32" |

### 各資源類型支援的資料型別

| 類型 | 資料型別 | 讀/寫 |
|------|----------|-------|
| DB, IPU, IPI, Marker | Bool, Int8/16/32/64, UInt8/16/32/64, Float32/64, Array, String | 讀寫 + 多重讀寫 |
| Timer, Counter | UInt16, UInt16 Array | 讀寫 + 多重讀寫 |
| IEC_Timer, IEC_Counter | Object | 讀寫 + 多重讀寫 |
| PLC (state) | String | 唯讀 |
| MISC (conn_state) | String | 唯讀 |
| MISC (err_text) | Int8/16/32/64 | 唯寫 |

### 協定參數

| 參數 | 型別 | 必填 | 說明 |
|------|------|------|------|
| IP | String | 是 | PLC 的 IP 位址 |
| Rack | UInt8 | 是 | PLC 機架編號 |
| Slot | UInt8 | 是 | PLC 插槽編號 |
| LittleEndian | Bool | 否 | 位元組順序，預設 False（大端序） |

### 特殊注意事項

- 使用 String 型別進行 DB/IPU/IPI 請求時，S7 字串標頭會額外佔用 2 個位元組（超出 `size` 屬性設定值）
- 位元存取透過 `bitIndex`（0–7）指定位元組內的位元位置
- PLC/MISC 操作不可包含在裝置命令（Device Command）中，必須單獨操作
- IEC Timer 物件包含 PT（預設時間）、ET（經過時間）、IN（輸入）、Q（輸出）欄位
- IEC Counter 物件包含 PV、CV、CU、CD、R、LD、QU、QD 欄位

---

## EtherCAT

### 功能概述

EtherCAT 裝置服務作為 EtherCAT 主站（Master），與 EtherCAT 從站（Slave）進行工業通訊。支援單/雙網路介面（冗餘配置）、可設定 250 微秒至 50 毫秒的循環時間、分散式時鐘（Distributed Clock, DC）同步、服務資料物件（SDO）及程序資料物件（PDO）讀寫、以及 CANopen over EtherCAT（CoE）協定。

### 系統需求

- 需要低階網路存取權限：`sudo setcap cap_net_admin,cap_net_raw=eip /opt/iotech/xrt/2.2/bin/xrt`
- 動態連結器設定：`/etc/ld.so.conf.d/xrt.conf`

### Profile 屬性表格

| 資源類型 | 用途 | 關鍵屬性 |
|----------|------|----------|
| State | 讀取/變更裝置狀態 | 無額外屬性 |
| SDO | 服務資料物件讀寫 | index, subIndex |
| RxPDO | 接收程序資料物件 | offsetBytes, offsetBits |
| TxPDO | 傳送程序資料物件 | offsetBytes, offsetBits |
| InitialSDO | 啟動時的 SDO 寫入 | index, subIndex, byteLength, value |
| AssignPDO | PDO 映射組態 | RxPDO[], TxPDO[] 陣列 |

支援的純量型別：Bool, Int8/16/32/64, UInt8/16/32/64, Float32/64, String, BIT#

SDO 額外支援陣列型別：Int8/16/32/64Array, UInt8/16/32/64Array, Float32/64Array

### 協定參數

**裝置識別**（需擇一）：

| 參數 | 型別 | 說明 |
|------|------|------|
| SerialNumber | UInt32 | 序號（CoE 或 EEPROM 查詢） |
| StationAlias | UInt16 | 次要從站位址 |
| NetworkIndex | UInt16 | 連線位置（1, 2, 3...） |

**同步模式**：

| 模式 | 說明 | 必要參數 |
|------|------|----------|
| 1 (SM Sync) | SM2/3 事件觸發 | SyncMode=1 |
| 2 (DC Sync0) | 分散式時鐘 Sync0 | SyncMode=2, Sync0Cycle (1–80) |
| 3 (DC Sync1) | 分散式時鐘 Sync1 | SyncMode=3, Sync1Cycle (1–80), Sync01Cycle |

選填：SyncShift（-2,000,000 至 +2,000,000 微秒）

**驅動組態**：

| 參數 | 型別 | 說明 |
|------|------|------|
| NetworkInterface1 | String | 主要網路介面（必填） |
| NetworkInterface2 | String | 次要冗餘介面（選填） |
| CycleTime_us | UInt (50–50000) | 循環更新間隔，微秒（必填） |
| FinalState | String | 初始化目標狀態：SAFE_OP 或 OP（必填） |

### 特殊注意事項

- 序號在不同裝置間可能不唯一
- 不相容的裝置需透過 `"CoE-CA": false` 明確停用完整存取（Complete Access）
- 狀態控制使用 `service:update` 操作搭配 State 參數（PRE_OP, SAFE_OP, OP）

---

## EtherNet/IP

### 功能概述

EtherNet/IP 裝置服務同時作為掃描器（Scanner）和轉接器（Adapter），用於資料擷取和裝置控制。支援最多 16 個轉接器裝置連線，提供三種主要通訊模式：隱式通訊（Implicit）、顯式通訊（Explicit）及 Logix 標籤（Tag）存取。額外支援裝置探索（Discovery）與電子鑰匙（Electronic Keying）驗證。

### Profile 屬性表格

**隱式通訊資源**：

| 屬性 | 說明 | 有效值 |
|------|------|--------|
| type | 資源識別 | O2TSettings, T2OSettings, T2O, O2T |
| assemblyID | 組件 ID | 0–65536 |
| includeHeader32bit | 32 位元標頭 | true/false |
| size | 資料大小 | 0–2000 位元組 |
| offsetBytes | 位元組偏移 | 0–2000 |
| offsetBits | 位元偏移 | 0–7 |
| bitLength | 資料位元長度 | 1–2000 |

**顯式通訊資源**：

| 屬性 | 說明 | 必填 |
|------|------|------|
| objClass | CIP 物件類別 | 是 |
| instID | 實例 ID | 是 |
| attrID | 屬性 ID | 否 |

**Logix 標籤資源**：

| 屬性 | 說明 |
|------|------|
| type | 固定值 "logixTag" |
| tagName | PLC 標籤名稱 |
| arraySize | 陣列大小（0–200） |

### 協定參數

| 參數 | 型別 | 說明 |
|------|------|------|
| Address | String | 裝置 IP 位址（必填） |
| NetworkInterface | String | 網路介面名稱 |
| ConnectionTimeout | UInt32 | 連線逾時（毫秒） |
| DiscoveryDuration | UInt32 | 探索等待時間（毫秒） |
| DiscoveryRetries | UInt8 | 廣播重試次數 |
| DirectedBroadcastDiscovery | Bool | 定向廣播方法 |

**隱式通訊連線屬性**：

| 參數 | 有效值 |
|------|--------|
| ConnectionType | p2p, mcast |
| RPI | 封包間隔（毫秒） |
| Priority | low, high, scheduled, urgent |
| Ownership | exclusive, inputonly, listenonly |

**電子鑰匙屬性**：

| 參數 | 說明 |
|------|------|
| Method | compatibility 或 exact |
| VendorID | 製造商 ID（UInt16） |
| DeviceType | 裝置類型（UInt16） |
| ProductCode | 產品代碼（UInt16） |
| MajorRevision | 主版本（0–127） |
| MinorRevision | 次版本（UInt8） |

支援的資料型別：Bool, UInt8, UInt16, UInt32, Int16, Float32, String, UInt8Array

### 特殊注意事項

- 隱式通訊最大資料量為每裝置 2000 位元組
- 最多同時連線 16 個轉接器裝置
- O2T/T2O 設定資源為唯讀組態資源
- 支援 Allen Bradley PLC 的 Logix 標籤直接讀寫（含陣列元素）

---

## PROFINET

### 功能概述

PROFINET 裝置服務作為 IO 控制器（IO Controller），透過 PROFINET 即時通訊（PN-RT）與 IO 裝置通訊。可以兩種模式部署：作為連接到現有 IO 控制器的 I-device，或直接連接 IO 裝置。IOTech 建議使用現有 IO 控制器連接 IO 裝置。支援接收和記錄警報、讀取輸入模組資料、寫入輸出模組資料。

### Profile 屬性表格

**輸入資源（I 資料，唯讀）**：

| 屬性 | 說明 |
|------|------|
| `I-offset` | 輸入資料區內的位元組偏移 |
| `I-offset-bits` | Bool 資源的位元位址（選填） |

**輸出資源（Q 資料，唯寫）**：

| 屬性 | 說明 |
|------|------|
| `Q-offset` | 輸出資料區內的位元組偏移 |

支援的資料型別：Int8/16/32/64, UInt8/16/32/64, Float32/64, Bool（僅輸入，需搭配位元定址）

### 協定參數

| 參數 | 說明 |
|------|------|
| NetworkInterface | PROFINET 通訊專用網路介面名稱 |
| ProfinetConfigurationFile | TIA Portal V16 匯出的 XML 硬體組態檔路徑 |
| I-base | 輸入資料基底位址（由 XML 定義） |
| Q-base | 輸出資料基底位址（由 XML 定義） |

### 特殊注意事項

- 必須使用 TIA Portal V16 產生硬體組態 XML 檔案
- 需安裝 PN Driver V2.2（HSP0307）支援套件
- 需要專用網路介面（必須停用 DHCP 和 ARP）
- 原生執行時需要 raw socket 權限
- IOTech 建議透過現有 IO 控制器連接 IO 裝置，而非直接連線

---

## BLE（藍牙低功耗）

### 功能概述

BLE 裝置服務透過藍牙低功耗（Bluetooth Low Energy）協定與 BLE 裝置通訊，支援標準 GATT 特徵值讀寫、BLE 通知（Notification）、製造商廣播封包（Advertisement）處理及裝置探索功能。

### 前置需求

- D-Bus 服務必須運行（用於裝置服務與 BlueZ 之間的通訊）
- BlueZ（Linux 藍牙模組）必須已安裝且運行中

### Profile 屬性表格

| 屬性 | 必要性 | 型別 | 說明 |
|------|--------|------|------|
| characteristicUuid | 條件式 | String | 裝置特徵值 UUID（非 Advertisement/Notification 時必填） |
| serviceUuid | 選填 | String | 父服務 UUID |
| isAdvertisement | 選填 | Bool | 標記為廣播封包資源 |
| isNotification | 選填 | Bool | 標記為通知控制資源 |
| deviceResource | 條件式 | String | 參照的既有資源（isNotification=true 時必填） |
| startByte | 選填 | UInt | 讀取值的位元組偏移 |
| conversionFunction | 選填 | String | 套用的轉換函式名稱 |
| rawType | 條件式 | String | 資料解析型別（定義 conversionFunction 時必填） |

支援的資料型別：Bool, Int8/16/32/64, UInt8/16/32/64, Float32/64, String, Byte Array

### 協定參數

| 參數 | 型別 | 必填 | 說明 |
|------|------|------|------|
| MAC | String | 是 | 裝置 MAC 位址（格式：AA:BB:CC:DD:EE:FF） |
| Alias | String | 否 | 裝置別名 |
| Name | String | 否 | 裝置名稱 |

**驅動組態**：

| 參數 | 型別 | 預設值 | 說明 |
|------|------|--------|------|
| BLE_Interface | String | 必填 | 藍牙介面（如 hci0, hci1） |
| BLE_DiscoveryDuration | UInt | 10 | 每次探索週期的持續時間 |
| BLE_DiscoveryInterval | UInt | 0 | 探索週期之間的間隔 |
| BLE_AdvertisementEnabled | Bool | True | 啟用廣播封包處理 |

### 特殊注意事項

- 內建多種感測器專用轉換函式，支援 TI CC2650、STM LSM9DS1、TDK ICM-20602、Bosch BME680、Silicon Labs Si7021、STM VL53L0X 等晶片
- 轉換函式涵蓋溫度、濕度、氣壓、光學、陀螺儀、加速度計、磁力計、距離等感測資料
- 裝置操作（讀寫、通知、探索）透過 MQTT API 動態管理

---

## Virtual（虛擬裝置）

### 功能概述

虛擬裝置服務用於模擬各種裝置類型與生成讀數，適用於開發測試與展示情境。支援設定與讀取固定值、在指定範圍內產生隨機值、生成波形序列、遞增/遞減序列，以及基於腳本的固定值序列。

### Profile 屬性表格

#### 1. 算術序列（Arithmetic）

`sequenceType: "arithmetic"` — 每次讀取後依差值遞增或遞減。

| 屬性 | 說明 | 預設值 |
|------|------|--------|
| firstValue | 初始值 | 0 |
| difference | 遞增/遞減量 | 1 |

支援型別：Int8/16/32/64, UInt8/16/32/64, Float32/64

#### 2. 隨機值（Random）

`sequenceType: "random"` — 在指定範圍內產生隨機值。

| 屬性 | 說明 | 預設值 |
|------|------|--------|
| minimum | 下限 | 型別最小值 |
| maximum | 上限 | 型別最大值 |
| arrayLength | 陣列長度（陣列型別時必填） | — |

支援型別：Bool, 所有整數/浮點型別及對應陣列型別

#### 3. 腳本序列（Script）

`sequenceType: "script"` — 依序迭代預定義的值序列。

| 屬性 | 說明 |
|------|------|
| script | 值映射向量，每項包含 `value`（必填）和 `repeat`（選填，UInt32） |

支援型別：Int8/16/32/64, UInt8/16/32/64, Float32/64

#### 4. 波形（Waveform）

`sequenceType: "waveform"` — 產生數學波形。

| 屬性 | 說明 | 預設值 |
|------|------|--------|
| shape | 波形形狀 | "sinewave" |
| period | 每個完整週期的讀取次數 | 必填 |
| amplitude | 峰對谷高度 | 必填 |
| phase | 讀取偏移提前量 | 0 |
| offset | 值偏移 | 0.0 |
| arrayLength | 陣列長度 | 0 |

可選波形：sinewave, sawtooth, triangle, square

支援型別：所有整數/浮點型別及對應陣列型別

#### 5. 無序列資源

未指定 `sequenceType` 時為標準讀寫資源，可設定初始值（`firstValue`）和陣列長度（`arrayLength`）。

支援型別：String, Bool, 所有數值型別及陣列型別

### 協定參數

虛擬裝置服務無特定協定參數，僅需標準裝置服務組態。

### 特殊注意事項

- 波形值以雙精度浮點數計算後轉型至目標型別，超出型別範圍會產生錯誤
- 適合用於開發測試與 Edge Xrt 功能展示
- 可透過 MQTT API 進行動態操作（讀寫、排程）
