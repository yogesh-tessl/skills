<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/available-device-service-components.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/device-profiles.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/device-provisioning.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/device-service-component-configuration.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/schedule-the-publication-of-readings.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/run-device-service-components.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/run-multiple-device-service-components.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — Device Service Components

本文件彙整 Edge Connect (Edge Xrt 2.2) 的 Device Service 元件通用文件，涵蓋可用元件清單、Device Profile 格式、裝置佈建（Device Provisioning）、組態參數、讀取排程、單一與多實例運行、以及 Docker 部署。

---

## 目錄

- [1. 可用的 Device Service 元件](#1-可用的-device-service-元件)
- [2. Device Profiles（裝置描述檔）](#2-device-profiles裝置描述檔)
  - [2.1 Profile 識別資訊](#21-profile-識別資訊)
  - [2.2 Device Resources](#22-device-resources)
  - [2.3 Device Commands](#23-device-commands)
  - [2.4 載入 Profiles](#24-載入-profiles)
  - [2.5 完整 Profile 範例](#25-完整-profile-範例)
- [3. Device Provisioning（裝置佈建）](#3-device-provisioning裝置佈建)
  - [3.1 Devices 組態結構](#31-devices-組態結構)
  - [3.2 Device Profile 格式](#32-device-profile-格式)
- [4. Device Service 元件組態參數](#4-device-service-元件組態參數)
  - [4.1 核心參數](#41-核心參數)
  - [4.2 Topic 組態](#42-topic-組態)
  - [4.3 佇列與計時](#43-佇列與計時)
  - [4.4 資料發布](#44-資料發布)
  - [4.5 裝置管理](#45-裝置管理)
  - [4.6 檔案與目錄組態](#46-檔案與目錄組態)
  - [4.7 效能與批次處理](#47-效能與批次處理)
  - [4.8 資料處理](#48-資料處理)
  - [4.9 元件參照](#49-元件參照)
  - [4.10 遙測與計時](#410-遙測與計時)
- [5. 讀取排程設定（Schedule）](#5-讀取排程設定schedule)
  - [5.1 排程參數](#51-排程參數)
  - [5.2 排程組態範例](#52-排程組態範例)
- [6. 運行 Device Service 元件](#6-運行-device-service-元件)
  - [6.1 命令列獨立運行](#61-命令列獨立運行)
  - [6.2 環境變數](#62-環境變數)
- [7. 運行多個 Device Service 元件](#7-運行多個-device-service-元件)
  - [7.1 前置條件](#71-前置條件)
  - [7.2 主組態檔（main.json）](#72-主組態檔mainjson)
  - [7.3 建議目錄結構](#73-建議目錄結構)
  - [7.4 本機執行](#74-本機執行)
  - [7.5 Docker 容器執行（多服務）](#75-docker-容器執行多服務)
- [8. Docker 部署設定](#8-docker-部署設定)
  - [8.1 支援 Docker 部署的 Device Service](#81-支援-docker-部署的-device-service)
  - [8.2 Docker 運行範例](#82-docker-運行範例)

---

## 1. 可用的 Device Service 元件

Device Service 元件透過原生協定與實體或模擬裝置（感測器、致動器及其他物聯網物件）進行通訊。Edge Connect 2.2 提供以下 12 種 Device Service 元件：

| # | 元件名稱 | 協定 / 用途 |
|---|----------|-------------|
| 1 | **BACnet** | 建築自動化控制網路協定（Building Automation and Control Network） |
| 2 | **BLE** | 低功耗藍牙無線技術（Bluetooth Low Energy） |
| 3 | **CANbus** | 控制器區域網路匯流排通訊（Controller Area Network） |
| 4 | **EtherCAT** | 工業乙太網協定（Ethernet for Control Automation Technology） |
| 5 | **EtherNet/IP** | 乙太網工業協定（Ethernet Industrial Protocol） |
| 6 | **GPS** | 全球定位系統（Global Positioning System） |
| 7 | **Modbus** | 串列通訊協定（Serial Communication Protocol） |
| 8 | **OPC UA** | 開放式平台通訊統一架構（Open Platform Communications Unified Architecture） |
| 9 | **PROFINET** | 過程現場網路工業乙太網（Process Field Network） |
| 10 | **S7** | 西門子 S7 通訊協定（Siemens S7 Communication） |
| 11 | **Virtual** | 模擬裝置服務（Simulated Device Service） |
| 12 | **Zigbee** | 無線網狀網路協定（Wireless Mesh Networking） |

> IOTech 持續開發新的 Device Service，如需擴展協定支援，可透過官方網站聯繫。

---

## 2. Device Profiles（裝置描述檔）

Device Profile 描述 Edge Xrt 中的裝置類型，使用 `deviceResources` 定義支援的操作，並使用 `deviceCommands` 將多個資源分組。每個裝置服務中的裝置都有一個關聯的 JSON Profile，多個裝置可共用同一個 Profile。

### 2.1 Profile 識別資訊

| 欄位 | 說明 | 必填 |
|------|------|------|
| `name` | 必須與 Profile 檔案的基礎檔名一致 | Y |
| `apiVersion` | Profile 所使用的 API 版本 | Y |
| `manufacturer` | 裝置製造商名稱 | N |
| `model` | 裝置型號 | N |
| `description` | Profile 說明 | N |
| `labels` | 可搜尋標籤列表 | N |

### 2.2 Device Resources

Device Resource 定義可讀取或寫入的個別裝置值。

| 參數 | 說明 | 必填 |
|------|------|------|
| `name` | 資源識別符 | Y |
| `description` | 資源詳細說明 | N |
| `attributes` | Device Service 特定設定（因協定而異） | Y |
| `properties.valueType` | 資源的資料型別 | Y |
| `properties.readWrite` | 讀寫權限（`R`、`W` 或 `RW`） | Y |
| `properties.minimum` | 允許的最小值 | N |
| `properties.maximum` | 允許的最大值 | N |
| `tags` | 關聯標籤 | N |

### 2.3 Device Commands

Device Command 將多個資源組合為單一操作。

| 參數 | 說明 | 必填 |
|------|------|------|
| `name` | 命令識別符 | Y |
| `readWrite` | 權限：`R`、`W` 或 `RW` | Y |
| `resourceOperations` | 分組的 Device Resource 列表 | Y |
| `tags` | 關聯標籤 | N |

**讀取命令範例：**

```json
"deviceCommands": [
  {
    "name": "BinaryInputs",
    "readWrite": "R",
    "resourceOperations": [
      {"deviceResource": "BinaryInput1"},
      {"deviceResource": "BinaryInput2"}
    ]
  }
]
```

### 2.4 載入 Profiles

Device Service 需要一個 `profiles.json` 檔案，列出要從指定 `ProfileDir` 載入的 Profile 基礎檔名（不含 `.json` 副檔名）：

```json
["profile-1", "profile-2", "profile-3", "profile-4"]
```

### 2.5 完整 Profile 範例

以下為一個 BACnet Profile 結構示例，包含識別資訊、Device Resource（含 attributes 和 properties）以及將資源分組的 Command：

```json
{
  "name": "bacnet-example-profile",
  "apiVersion": "v2",
  "manufacturer": "IOTech",
  "model": "BACnet Simulator",
  "description": "Example BACnet device profile",
  "labels": ["bacnet", "example"],
  "deviceResources": [
    {
      "name": "BinaryInput1",
      "description": "Binary input register 1",
      "attributes": {
        "type": "BinaryInput",
        "instance": 1
      },
      "properties": {
        "valueType": "Bool",
        "readWrite": "R"
      }
    },
    {
      "name": "BinaryInput2",
      "description": "Binary input register 2",
      "attributes": {
        "type": "BinaryInput",
        "instance": 2
      },
      "properties": {
        "valueType": "Bool",
        "readWrite": "R"
      }
    }
  ],
  "deviceCommands": [
    {
      "name": "BinaryInputs",
      "readWrite": "R",
      "resourceOperations": [
        {"deviceResource": "BinaryInput1"},
        {"deviceResource": "BinaryInput2"}
      ]
    }
  ]
}
```

---

## 3. Device Provisioning（裝置佈建）

### 3.1 Devices 組態結構

裝置以 JSON 結構定義在 `devices.json` 檔案中：

```json
{
  "<Device Name>": {
    "profile": "<Profile Name>",
    "enabled": true,
    "protocols": {
      "<Protocol Name>": {
        "<Protocol Key>": "<Protocol Value>",
        "<Protocol Key>": "<Protocol Value>"
      }
    }
  }
}
```

| 欄位 | 說明 | 備註 |
|------|------|------|
| `<Device Name>` | 裝置識別名稱 | 作為 JSON 物件的 key |
| `profile` | 關聯的 Device Profile 名稱 | 必須對應已載入的 Profile |
| `enabled` | 是否啟用裝置 | 預設 `true`；設為 `false` 時阻擋所有讀寫操作 |
| `protocols` | 協定特定組態 | 包含協定名稱及其鍵值對參數 |

### 3.2 Device Profile 格式

```json
{
  "name": "<Profile Name>",
  "manufacturer": "<device manufacturer name>",
  "model": "<model number>",
  "description": "<device profile description>",
  "labels": ["<device profile labels>"],
  "deviceResources": []
}
```

每個 Profile 包含製造商資訊、型號、說明文字、組織標籤，以及針對各實作的 Device Resource 定義。

---

## 4. Device Service 元件組態參數

以下為 Device Service 元件的完整組態參數。除標記為「必填」者外，其餘均為選填。

### 4.1 核心參數

| 參數 | 說明 | 預設值 | 必填 |
|------|------|--------|------|
| `Library` | 實作 Device Service 的共享函式庫，例如 `libxrt-{protocol}-device-service.so` | — | 動態連結時必填 |
| `Factory` | 元件實例化的 C 函式名稱，例如 `xrt_{protocol}_device_service_factory` | — | 動態連結時必填 |
| `Name` | Device Service 名稱 | — | Y |

### 4.2 Topic 組態

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `TelemetryTopic` | 發布來自服務、排程事件及值變化的資料的主題 | — |
| `NotificationTopic` | 裝置通知主題 | — |
| `RequestTopic` | 接收 Bus 請求的主題 | — |
| `ReplyTopic` | 請求回覆主題 | — |
| `DiscoveryTopic` | 裝置探索請求主題 | — |
| `StatusTopic` | 運行狀態變更事件主題 | — |

### 4.3 佇列與計時

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `RequestQueueMax` | 請求佇列最大容量 | `4` |
| `DiscoveryInterval` | 裝置探索觸發間隔（秒） | `0` |
| `ScheduleDeadBand` | 減少排程啟動時間範圍（毫秒） | `0` |

### 4.4 資料發布

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `Timestamp` | 是否在讀值中包含時間戳記 | `false` |
| `PublishAttributes` | 是否在讀值中包含屬性資訊 | `false` |
| `PublishRegisteredDevices` | 啟動時是否發布預註冊裝置詳細資訊 | `false` |
| `PublishTags` | 是否在發布訊息中包含標籤 | `true` |
| `SyncPostData` | 同步（`true`）或非同步（`false`）訊息發布 | `false` |

### 4.5 裝置管理

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `AutoRegister` | 是否自動新增已探索到的裝置 | `false` |
| `PreloadCache` | 初始化時載入資源元資料，或按需載入 | `false` |
| `AllowedFails` | 將裝置標記為非運作狀態前允許的連續失敗請求次數（`0` = 停用） | `0` |
| `DeviceDownTimeout` | 裝置重新啟用的等待時間（秒）（`0` = 停用） | `0` |
| `EnableDiscovery` | 啟用裝置探索功能 | `false` |

### 4.6 檔案與目錄組態

| 參數 | 說明 | 預設值 | 必填 |
|------|------|--------|------|
| `ProfileDir` | Device Profile 目錄的完整路徑 | — | Y |
| `ProfileListFile` | 包含 Profile 清單的 JSON 檔名（不含 `.json`） | `profiles` | N |
| `DevicesFile` | 包含裝置清單的 JSON 檔名（不含 `.json`） | `devices` | N |
| `SchedulesFile` | 包含排程清單的 JSON 檔名（不含 `.json`） | `schedules` | N |
| `StateDir` | 裝置和排程目錄的完整路徑 | — | Y |

### 4.7 效能與批次處理

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `AutoBatchSize` | 連續排程讀取群組的最大數量（`0` = 停用） | `0` |
| `AutoBatchTimeout` | 批次處理時間限制（毫秒） | `250` |
| `SchedulesThreadPool` | 排程專用執行緒池 | — |
| `RequestsThreadPool` | put/get 操作專用執行緒池 | — |

### 4.8 資料處理

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `ZeroNullReadings` | 將空值讀取轉換為零值 | `false` |
| `DiscardUnchangedReadings` | 在 `on_change` 排程中僅發布已變更的資源 | `true` |
| `EdgeXCompat` | 回傳 EdgeX 相容格式的讀值 | `false` |
| `DiscoverInitialValues` | 在 Profile 中包含初始探索到的值 | `false` |
| `ValidateProfilesOnStart` | 啟動時驗證 Profile | `true` |

### 4.9 元件參照

| 參數 | 說明 | 必填 |
|------|------|------|
| `Scheduler` | Scheduler 元件名稱 | Y |
| `ThreadPool` | ThreadPool 元件名稱 | Y |
| `Bus` | Bus 元件名稱 | Y |
| `Logger` | Logger 元件名稱 | N |

### 4.10 遙測與計時

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `TelemetryTags` | 訊息的鍵值標籤對 | — |
| `EnableTimingTelemetry` | 在排程遙測中包含計時資訊（get 和 delta） | `false` |
| `EnableProtocolTiming` | 發布平均請求時間並記錄個別請求計時 | `false` |

---

## 5. 讀取排程設定（Schedule）

排程控制 Device Service 自動讀取並發布裝置資料的行為。排程定義在 `schedules.json` 檔案中。

### 5.1 排程參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| `device` | String | 提供讀值的裝置名稱，須與 Devices 組態中的名稱一致 | 有效的裝置名稱 | Y |
| `resource` | String | 要發布的 Device Resource 名稱，須與 Devices 組態一致 | 單一資源：`"resource-name"`；多資源：`"resource-1","resource-2"`；萬用字元（wildcard）：`".*"`, `"resource-.*"` | Y |
| `interval` | Unsigned Integer | 每次讀值發布之間的間隔（微秒，microseconds） | 正整數 | Y |
| `tags` | Object | 隨排程讀值一起發布的標籤 | 鍵值對，代表標籤名稱與值 | N |
| `on_change` | Boolean | 設為 `true` 時僅發布已變更的資源 | 預設 `false` | N |
| `bounds` | Object | 鍵值對，每對代表資源名稱和閾值。僅在讀值與上次記錄值的絕對差異超過閾值時才發布 | 例如 `"bounds":{".*": 1}` 表示變化超過 1 個單位才發布 | N |

### 5.2 排程組態範例

```json
{
  "apiVersion": "v2",
  "schedules": [
    {
      "device": "bacnet-ip-sim",
      "interval": 3000000,
      "name": "schedule1",
      "resource": [
        ".*"
      ],
      "on_change": true,
      "bounds": {".*": 1},
      "tags": {
        "tag_name": "tag_value"
      }
    }
  ]
}
```

**說明：**

- `interval` 單位為微秒。上例中 `3000000` 微秒 = 3 秒。
- `resource` 使用 `".*"` 萬用字元表示讀取該裝置所有資源。
- `on_change` 為 `true` 時，僅在值發生變化時才發布。
- `bounds` 設定死區（deadband），`{".*": 1}` 代表所有資源的變化量必須超過 1 才發布。

---

## 6. 運行 Device Service 元件

### 6.1 命令列獨立運行

以命令列方式獨立運行 Device Service 的步驟：

1. **準備組態檔案**：確認相關的 `[device_service_name]_device_service.json` 檔案及所需組態檔（如 Device Profile）已放置於 config 資料夾中。

2. **設定環境變數**（見下方 6.2）。

3. **執行 Edge Xrt**：

```bash
xrt <config_directory> [time_in_seconds]
```

| 參數 | 說明 |
|------|------|
| `<config_directory>` | 組態資料夾的路徑 |
| `[time_in_seconds]` | （選填）運行持續時間（秒）；未指定時持續運行 |

### 6.2 環境變數

Edge Xrt 運行需要設定以下三個環境變數：

| 環境變數 | 說明 |
|----------|------|
| `XRT_PROFILE_DIR` | 包含可用 Device Profile 的目錄 |
| `XRT_STATE_DIR` | 包含狀態資料（排程、裝置）的目錄 |
| `XRT_LICENSE_FILE` | `license.json` 授權檔案的路徑 |

---

## 7. 運行多個 Device Service 元件

Edge Xrt 支援在單一實例中同時運行多個 Device Service 元件。

### 7.1 前置條件

- 所需服務的組態檔案
- Edge Xrt 安裝
- 有效的授權檔案（license file）

### 7.2 主組態檔（main.json）

主組態檔必須包含所有要運行的服務。以下為同時運行 BACnet/IP、Modbus-TCP 和 OPC UA 的範例：

```json
{
  "xrt": "XRT::Config",
  "logger": "IOT::Logger",
  "pool": "IOT::ThreadPool",
  "sched": "IOT::Scheduler",
  "bus": "XRT::Bus",
  "bacnet_ip": "XRT::BACnetIPDeviceService",
  "modbus": "XRT::ModbusDeviceService",
  "opc_ua": "XRT::OPCUADeviceService",
  "mqtt_bridge": "XRT::MQTTBridge"
}
```

此組態需要對應的服務組態檔案：`bacnet_ip.json`、`opc_ua.json`、`modbus.json`。每個服務組態檔案必須指定 Profile 目錄和狀態目錄的路徑。

### 7.3 建議目錄結構

```
multi-config/
├── bacnet/
│   ├── profiles/
│   │   ├── bacnet-example-profile.json
│   │   └── profiles.json
│   └── state/
│       ├── devices.json
│       └── schedules.json
├── bacnet_ip.json
├── modbus/
│   ├── profiles/
│   │   ├── modbus-example-profile.json
│   │   └── profiles.json
│   └── state/
│       ├── devices.json
│       └── schedules.json
├── modbus.json
├── opc-ua/
│   ├── profiles/
│   │   ├── opc-ua-example-profile.json
│   │   └── profiles.json
│   └── state/
│       ├── devices.json
│       └── schedules.json
├── opc_ua.json
├── mqtt_bridge.json
├── bus.json
├── logger.json
├── main.json
├── pool.json
├── sched.json
└── xrt.json
```

每個 Device Service 有獨立的 `profiles/` 和 `state/` 子目錄，分別存放該服務的 Device Profile 和狀態檔案（devices、schedules）。

### 7.4 本機執行

```bash
xrt multi-config/
```

### 7.5 Docker 容器執行（多服務）

將組態目錄掛載至容器內的標準部署路徑：

```bash
docker run --rm \
  --network=<network-name> \
  --name <container-name> \
  -v multi-config/:/opt/iotech/xrt/2.2/deployment/config \
  iotechsys/xrt:2.2 [time_in_seconds]
```

| 參數 | 說明 |
|------|------|
| `--network=<network-name>` | Docker 網路名稱 |
| `--name <container-name>` | 容器名稱 |
| `-v multi-config/:/opt/iotech/xrt/2.2/deployment/config` | 將本機組態目錄掛載至容器內的部署路徑 |
| `[time_in_seconds]` | （選填）運行持續時間（秒） |

---

## 8. Docker 部署設定

### 8.1 支援 Docker 部署的 Device Service

Edge Xrt 提供以下 Device Service 的 Docker 部署指引：

| Device Service | Docker 映像檔基礎名稱 |
|----------------|----------------------|
| BACnet/IP | `iotechsys/xrt:2.2` |
| BACnet/MSTP | `iotechsys/xrt:2.2` |
| BLE | `iotechsys/xrt:2.2` |
| EtherNet/IP | `iotechsys/xrt:2.2` |
| GPS | `iotechsys/xrt:2.2` |
| Modbus | `iotechsys/xrt:2.2` |
| OPC UA | `iotechsys/xrt:2.2` |
| PROFINET | `iotechsys/xrt:2.2` |
| S7 | `iotechsys/xrt:2.2` |
| Virtual | `iotechsys/xrt:2.2` |
| Zigbee | `iotechsys/xrt:2.2` |

> 各協定的 Docker 部署可能有特定的額外需求（如網路模式、裝置掛載等），請參閱各協定的專屬 Docker 文件。

### 8.2 Docker 運行範例

**基本單一服務運行：**

```bash
docker run --rm \
  --network=host \
  --name xrt-bacnet \
  -v $(pwd)/config/:/opt/iotech/xrt/2.2/deployment/config \
  -e XRT_PROFILE_DIR=/opt/iotech/xrt/2.2/deployment/config/profiles \
  -e XRT_STATE_DIR=/opt/iotech/xrt/2.2/deployment/config/state \
  -e XRT_LICENSE_FILE=/opt/iotech/xrt/2.2/deployment/config/license.json \
  iotechsys/xrt:2.2
```

**關鍵注意事項：**

- 容器內的標準部署路徑為 `/opt/iotech/xrt/2.2/deployment/config`
- 需透過 `-e` 設定環境變數 `XRT_PROFILE_DIR`、`XRT_STATE_DIR`、`XRT_LICENSE_FILE`
- 某些協定（如 BACnet/IP）可能需要 `--network=host` 模式以存取本機網路介面
- 使用序列埠通訊的協定（如 BACnet/MSTP、Zigbee）需額外掛載裝置：`--device=/dev/ttyUSB0`
- BLE 服務需要存取藍牙硬體：`--privileged` 或 `--device` 掛載

---

## 附錄：組態檔案總覽

| 檔案 | 說明 | 位置 |
|------|------|------|
| `main.json` | 主組態，定義要載入的元件 | config 根目錄 |
| `xrt.json` | Edge Xrt 核心組態 | config 根目錄 |
| `logger.json` | Logger 元件組態 | config 根目錄 |
| `pool.json` | ThreadPool 元件組態 | config 根目錄 |
| `sched.json` | Scheduler 元件組態 | config 根目錄 |
| `bus.json` | Bus 元件組態 | config 根目錄 |
| `[service].json` | 各 Device Service 元件組態 | config 根目錄 |
| `profiles.json` | Profile 清單檔案 | `profiles/` 子目錄 |
| `[profile-name].json` | 個別 Device Profile | `profiles/` 子目錄 |
| `devices.json` | 裝置佈建清單 | `state/` 子目錄 |
| `schedules.json` | 讀取排程定義 | `state/` 子目錄 |
| `license.json` | 授權檔案 | 由 `XRT_LICENSE_FILE` 指定 |
