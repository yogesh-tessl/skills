<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/exporter-components/rest-exporter-component.html
    - https://docs.iotechsys.com/edge-xrt22/exporter-components/influxdb-exporter-component.html
    - https://docs.iotechsys.com/edge-xrt22/exporter-components/azure-exporter-component.html
    - https://docs.iotechsys.com/edge-xrt22/exporter-components/aws-sitewise-exporter-component.html
    - https://docs.iotechsys.com/edge-xrt22/exporter-components/log-exporter-component.html
  Synced: 2026-03-07
-->

# Edge Connect 匯出元件（Exporter Components）

## 目錄

- [REST 匯出元件](#rest-匯出元件)
- [InfluxDB 匯出元件](#influxdb-匯出元件)
- [Azure 匯出元件](#azure-匯出元件)
- [AWS SiteWise 匯出元件](#aws-sitewise-匯出元件)
- [Log 匯出元件](#log-匯出元件)

---

## REST 匯出元件

### 功能說明

REST 匯出元件訂閱匯流排（Bus），將符合訂閱模式的資料匯出至可設定的 REST 端點。支援自訂 HTTP 標頭與 SSL/TLS 加密傳輸。

### 組態參數表格

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Bus | String | — | 是 | 訂閱的匯流排元件名稱 |
| Pattern | String | `#` | 是 | 匯流排訊息的訂閱過濾模式 |
| Endpoint | String | — | 是 | 目標 REST URL |
| Logger | String | — | 否 | 關聯的記錄器元件名稱 |
| QueueSize | UInt | 4 | 否 | 訂閱者訊息佇列容量 |
| ConnectTimeout | UInt | 1000 | 否 | 連線建立逾時（毫秒） |
| Timeout | UInt | 0（無限制） | 否 | 資料傳輸逾時（毫秒） |
| Headers | String Array | — | 否 | 自訂 HTTP 標頭 |
| SSLConfig | Object | — | 否 | TLS 安全連線設定 |

### 連線設定 — SSL 組態

| 參數 | 型別 | 說明 |
|------|------|------|
| CAPath | String | CA 憑證目錄路徑 |
| CAFile | String | CA 憑證檔名 |
| SSLCert | String | 客戶端 SSL 憑證檔 |
| SSLKey | String | 憑證對應的私鑰檔 |

### 範例

```json
{
  "Endpoint": "https://example.com/api/data",
  "Pattern": "data/#",
  "Headers": [
    "Content-Type: application/json",
    "Authorization: Bearer <token>"
  ],
  "SSLConfig": {
    "CAPath": "/etc/ssl/certs"
  },
  "Bus": "bus",
  "QueueSize": 2,
  "Logger": "logger"
}
```

---

## InfluxDB 匯出元件

### 功能說明

InfluxDB 匯出元件訂閱匯流排，將符合訂閱模式的資料匯出至 InfluxDB 時序資料庫。同時支援 InfluxDB 1.x 和 2.x 版本，並提供批次寫入功能以最佳化效能。

### 組態參數表格 — 共用參數

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| InfluxVersion | UInt | 1 | 否 | 資料庫版本（1 或 2） |
| ServerURI | String | — | 是 | InfluxDB 伺服器位址 |
| Bus | String | — | 是 | 匯流排元件名稱 |
| Logger | String | — | 否 | 記錄器元件名稱 |
| SelectData | Array | — | 是 | 資料選擇條件 |
| QueueSize | UInt | 4 | 否 | 訂閱者訊息佇列大小 |
| ConnectTimeout | UInt | 1000 | 否 | 連線逾時（毫秒） |
| Timeout | UInt | 0 | 否 | 傳輸逾時（毫秒） |
| BatchConfig | Object | — | 否 | 批次設定 |

### InfluxDB 1.x 專用參數

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| DBName | String | — | 是 | 資料庫名稱 |
| AuthEnabled | Bool | false | 否 | 啟用使用者驗證 |
| UserName | String | — | 否 | 驗證用戶名 |
| Password | String | — | 否 | 驗證密碼 |

### InfluxDB 2.x 專用參數

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Bucket | String | — | 是 | 儲存桶名稱 |
| Org | String | — | 是 | 組織名稱 |
| Token | String | — | 是 | 存取權杖 |
| Measurement | String | DeviceName | 否 | 量測類型：DeviceName / ScheduleName / DeviceCommand / ResourceName |
| Tags | String Array | — | 否 | 標籤：TagDeviceName / TagScheduleName |

### 資料選擇組態（SelectData）

| 參數 | 型別 | 必填 | 說明 |
|------|------|------|------|
| Format | Enum | 否 | JSON 編碼格式：Device 或 Raw |
| Pattern | String | 是 | 匯流排訂閱模式 |
| Scope | String | 否 | Raw 格式的量測名稱 |

### 批次組態（BatchConfig）

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| BatchSize | UInt | 0 | 否 | 累積多少筆訊息後發送 |
| BatchTimeout | UInt | 0 | 否 | 批次間隔（毫秒） |
| Scheduler | String | — | 是 | 排程器元件名稱 |
| ThreadPool | String | — | 是 | 執行緒池元件名稱 |
| Priority | Int | — | 否 | 排程器執行緒優先順序 |

### 範例 — InfluxDB 1.x

```json
{
  "Library": "libxrt-influxdb-exporter.so",
  "Factory": "xrt_influxdb_exporter_factory",
  "ServerURI": "http://127.0.0.1:8086",
  "DBName": "influxdb_test",
  "AuthEnabled": true,
  "UserName": "admin",
  "Password": "admin",
  "SelectData": [
    { "Pattern": "device/data", "Format": "Device" }
  ],
  "BatchConfig": {
    "BatchSize": 5,
    "BatchTimeout": 5000,
    "Scheduler": "sched",
    "ThreadPool": "pool"
  },
  "Bus": "bus",
  "Logger": "logger",
  "ConnectTimeout": 750,
  "Timeout": 1500
}
```

### 範例 — InfluxDB 2.x

```json
{
  "Library": "libxrt-influxdb-exporter.so",
  "Factory": "xrt_influxdb_exporter_factory",
  "InfluxVersion": 2,
  "ServerURI": "http://127.0.0.1:8086",
  "Bucket": "test_bucket",
  "Org": "IoTechSys",
  "Token": "abcdef==",
  "SelectData": [
    { "Pattern": "device/#", "Format": "Device" }
  ],
  "Measurement": "DeviceCommand",
  "Tags": ["TagScheduleName", "TagDeviceName"],
  "BatchConfig": {
    "BatchSize": 5,
    "BatchTimeout": 5000,
    "Scheduler": "sched",
    "ThreadPool": "pool"
  },
  "Bus": "bus",
  "Logger": "logger_debug",
  "ConnectTimeout": 4000,
  "Timeout": 1500
}
```

### 連線設定注意事項

- 裝置服務端需啟用 `TimeStamp: true` 以保留來源時間戳（批次寫入的必要條件）
- 使用 DeviceCommand 量測類型時需設定 `PublishSource: true`
- 使用 ScheduleName 標籤時需在 schedules.json 中設定 `{"ScheduleName":"<name>"}`

---

## Azure 匯出元件

### 功能說明

Azure 匯出元件使用 azure-iot-sdk-c 函式庫，將裝置佈建並連接至 Azure IoT Hub，實現雙向資料通訊。支援 Azure IoT Hub 和數位分身（Digital Twins）的資料匯出與接收，提供多主題匯流排訂閱與發布功能。

### 前置準備

1. 在 Azure 入口網站建立 IoT Hub
2. 建立裝置佈建服務（Device Provisioning Service, DPS）
3. 將 IoT Hub 與 DPS 連結
4. 產生 X.509 憑證鏈（根 CA、中繼憑證、葉憑證）
5. 上傳根 CA 至 DPS 並驗證所有權
6. 使用中繼憑證建立群組註冊（Group Enrollment）

### 組態參數表格

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Bus | String | — | 是 | 匯流排元件名稱 |
| Logger | String | — | 否 | 記錄器元件名稱 |
| WorkPeriod | UInt | 100 | 否 | Azure 雲端輪詢間隔（毫秒） |
| ConnectionType | Enum | DPS | 否 | 連線機制：`DPS` 或 `DAA`（直接存取） |
| HostName | String | — | 是 | Azure IoT Hub 主機名稱 |
| DeviceID | String | — | 是 | 裝置識別碼 |
| ScopeID | String | — | 是 | DPS 範圍識別碼 |
| Certificate | String | — | 是 | 裝置完整憑證鏈（PEM 格式） |
| Key | String | — | 是 | 裝置私鑰（PEM 格式） |
| Devices | Array | — | 是 | 裝置組態陣列 |

### 裝置組態（Devices 陣列項目）

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Name | String | — | 是 | 裝置名稱 |
| Topic | String | — | 是 | 裝置資料發布的匯流排主題 |
| Pattern | String | — | 是 | 接收裝置更新的匯流排模式 |
| Format | Enum | Raw | 否 | 資料編碼：`Device` 或 `Raw` |
| TwinID | String | Name 值 | 否 | 數位分身識別碼映射 |

### 連線設定

- **建議方式**：裝置佈建服務（DPS）連線類型，提供安全的裝置佈建與管理
- **替代方式**：直接 Azure 存取（DAA），但 IOTech 建議優先使用 DPS
- 憑證檔路徑：完整憑證鏈 `./certs/<device>-full-chain.cert.pem`，私鑰 `private/<device>.key.pem`

### 範例

```json
{
  "Bus": "bus",
  "Logger": "logger",
  "WorkPeriod": 100,
  "ConnectionType": "DPS",
  "HostName": "<IoT Hub hostname>",
  "DeviceID": "<device-id>",
  "ScopeID": "<DPS scope ID>",
  "Certificate": "<path/to/full-chain.cert.pem>",
  "Key": "<path/to/private.key.pem>",
  "Devices": [
    {
      "Name": "device-virtual",
      "Topic": "azure/publish/device-virtual",
      "Pattern": "azure/subscribe/device-virtual",
      "Format": "Raw",
      "TwinID": "<twin-id>"
    }
  ]
}
```

---

## AWS SiteWise 匯出元件

### 功能說明

AWS SiteWise 匯出元件訂閱匯流排，透過 REST API 將匹配的資料傳送至 AWS SiteWise，使用 BatchPutAssetPropertyValue 動作。驗證機制採用 AWS 簽章第 4 版（Signature Version 4），基於 IAM 存取金鑰產生簽章標頭。

### 資產屬性別名格式

資料映射使用屬性別名（Property Alias），格式為：`AliasStem/DeviceName/ResourceName`

- **AliasStem**：組態定義的唯一資產屬性識別碼
- **DeviceName**：Edge Xrt 裝置識別碼
- **ResourceName**：Edge Xrt 裝置資源識別碼

### 組態參數表格

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Bus | String | — | 是 | 匯流排元件名稱 |
| Logger | String | — | 否 | 記錄器元件名稱 |
| QueueSize | UInt | 4 | 否 | 訊息佇列容量 |
| Pattern | String | `#` | 否 | 匯流排訂閱模式 |
| AliasStem | String | — | 否 | 資產屬性唯一識別碼 |
| AccessKey | String | — | 是 | IAM 使用者存取金鑰 |
| SecretAccessKey | String | — | 是 | IAM 使用者密鑰 |
| Region | String | — | 是 | AWS 區域（如 us-east-1, eu-central-1） |
| ProfileDirs | String Array | — | 否 | Profile 目錄；若資產模型不存在則自動建立 |
| StateDirs | String Array | — | 否 | 裝置目錄；若資產不存在則自動建立 |

### 連線設定

- 驗證方式：AWS IAM 憑證（AccessKey + SecretAccessKey），依 AWS Signature Version 4 規範產生簽章
- 支援的區域：所有已啟用 SiteWise 服務的 AWS 區域

### 範例

```json
{
  "Bus": "bus",
  "Logger": "logger",
  "Pattern": "device/#",
  "AliasStem": "/plant1/line1",
  "AccessKey": "AKIAIOSFODNN7EXAMPLE",
  "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
  "Region": "us-east-1",
  "ProfileDirs": ["./deployment/profiles"],
  "StateDirs": ["./deployment/state"],
  "QueueSize": 8
}
```

### 特殊注意事項

- 設定 ProfileDirs 和 StateDirs 後，匯出元件會自動在 SiteWise 中建立對應的資產模型（Asset Model）和資產（Asset），並設定適當的屬性別名
- 屬性別名的完整路徑為 `AliasStem/DeviceName/ResourceName`，需確保在 SiteWise 中唯一

---

## Log 匯出元件

### 功能說明

Log 匯出元件訂閱匯流排，將所有收到的發布訊息以 Info 等級記錄至記錄器（Logger）。輸出目標取決於 Logger 元件的設定，可能包括主控台、檔案或匯流排追蹤資料流。主要用於開發除錯與資料流監控。

### 組態參數表格

| 參數 | 型別 | 預設值 | 必填 | 說明 |
|------|------|--------|------|------|
| Bus | String | — | 是 | 要訂閱的匯流排元件名稱 |
| Logger | String | — | 否 | 輸出用的記錄器元件名稱 |
| Cookie | Int | — | 否 | 識別訂閱者的 Cookie 值 |
| Pattern | String | `#` | 否 | 匯流排訂閱過濾模式 |

### 範例

```json
{
  "Bus": "bus",
  "Logger": "logger",
  "Cookie": 12345,
  "Pattern": "device/+/readings"
}
```

### 特殊注意事項

- 所有訊息一律以 Info 等級記錄，無法調整記錄等級
- 適合用於開發階段的資料流除錯與驗證
- Pattern 支援 MQTT 風格的萬用字元（`#` 匹配多層、`+` 匹配單層）
