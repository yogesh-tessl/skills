<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/mqtt-management/mqtt-management.html
    - https://docs.iotechsys.com/edge-xrt22/migration/2.1-2.2.html
    - https://docs.iotechsys.com/edge-xrt22/releasenotes/changelog.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — Management API、遷移指南、Release Notes

## 目錄

- [1. MQTT Management API](#1-mqtt-management-api)
  - [1.1 MQTT Topic 組態](#11-mqtt-topic-組態)
  - [1.2 通用請求/回應格式](#12-通用請求回應格式)
  - [1.3 狀態碼](#13-狀態碼)
  - [1.4 遙測格式（Telemetry）](#14-遙測格式telemetry)
  - [1.5 通知格式（Notification）](#15-通知格式notification)
  - [1.6 裝置格式（Device）](#16-裝置格式device)
  - [1.7 排程格式（Schedule）](#17-排程格式schedule)
  - [1.8 裝置探索格式（Device Discovery）](#18-裝置探索格式device-discovery)
  - [1.9 讀數格式與資料型別（Reading）](#19-讀數格式與資料型別reading)
  - [1.10 元件管理操作（Component）](#110-元件管理操作component)
  - [1.11 裝置管理操作（Device）](#111-裝置管理操作device)
  - [1.12 裝置服務管理操作（Service）](#112-裝置服務管理操作service)
  - [1.13 設定檔管理操作（Profile）](#113-設定檔管理操作profile)
  - [1.14 排程管理操作（Schedule）](#114-排程管理操作schedule)
  - [1.15 探索管理操作（Discovery）](#115-探索管理操作discovery)
- [2. 遷移指南](#2-遷移指南)
  - [2.1 V1.x 到 V2.x 遷移](#21-v1x-到-v2x-遷移)
  - [2.2 V2.0 到 V2.1 遷移](#22-v20-到-v21-遷移)
  - [2.3 V2.1 到 V2.2 遷移](#23-v21-到-v22-遷移)
- [3. Release Notes](#3-release-notes)
  - [3.1 Version 2.2](#31-version-22)
  - [3.2 Version 2.1](#32-version-21)
  - [3.3 Version 2.0](#33-version-20)
  - [3.4 Version 1.1](#34-version-11)

---

## 1. MQTT Management API

### 1.1 MQTT Topic 組態

| 組態 | 用途 | 範例 | 必填 |
|------|------|------|------|
| RequestTopic | 向裝置服務傳送操作請求 | xrt/devices/bacnet/request | Y |
| ReplyTopic | 裝置服務傳回操作回應 | xrt/devices/bacnet/reply | Y |
| TelemetryTopic | 傳送產生的遙測資料（裝置讀數） | xrt/devices/bacnet/telemetry | N |
| NotificationTopic | 傳送裝置狀態變更通知 | xrt/devices/notification | N |
| DiscoveryTopic | 傳送探索到的裝置設定檔 | xrt/devices/bacnet/discovery | N |

---

### 1.2 通用請求/回應格式

#### 請求格式

```json
{
  "client": "client1",
  "request_id": "fa7cdd1a-c0ee-4578-b33b-444d777f2301",
  "op": "device:list",
  "type": "xrt.request:1.0"
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| request_id | String | Y | 唯一請求識別碼 |
| op | String | Y | 操作名稱，格式為 `object:operation` |
| client | String | N | 客戶端身分 |
| type | String | N | 訊息類型與版本 |

#### 回應格式

```json
{
  "client": "client1",
  "request_id": "94178bb8-a0ba-465f-ab31-77f1ba81537f",
  "result": {
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| request_id | String | Y | 對應請求的識別碼 |
| type | String | Y | 訊息類型與版本（`xrt.reply:1.0`） |
| result | Object | Y | 請求結果，包含 status 與可選的 error |
| client | String | N | 來自請求的客戶端身分 |

---

### 1.3 狀態碼

| 值 | 錯誤狀態 | 列舉名稱 |
|----|----------|----------|
| 0 | 成功 | XRT_OPS_STATUS_OK |
| 1 | 未找到 | XRT_OPS_STATUS_NOT_FOUND |
| 2 | 不支援 | XRT_OPS_STATUS_NOT_SUPPORTED |
| 3 | 無效操作 | XRT_OPS_STATUS_INVALID_OPERATION |
| 4 | 寫入失敗 | XRT_OPS_STATUS_WRITE_FAILED |
| 5 | 讀取失敗 | XRT_OPS_STATUS_READ_FAILED |
| 6 | 資料遺失 | XRT_OPS_STATUS_MISSING_DATA |
| 7 | 已存在 | XRT_OPS_STATUS_ALREADY_EXISTS |
| 8 | 儲存失敗 | XRT_OPS_STATUS_STORE_FAILED |
| 9 | 載入失敗 | XRT_OPS_STATUS_LOAD_FAILED |
| 10 | 建立失敗 | XRT_OPS_STATUS_CREATE_FAILED |
| 11 | 使用中 | XRT_OPS_STATUS_IN_USE |
| 12 | 已停用 | XRT_OPS_STATUS_DISABLED |
| 13 | 無效資料 | XRT_OPS_STATUS_INVALID_DATA |
| 14 | 更新失敗 | XRT_OPS_STATUS_UPDATE_FAILED |
| 15 | 逾時 | XRT_OPS_STATUS_TIMEOUT |

---

### 1.4 遙測格式（Telemetry）

```json
{
  "device": "SimpleServer",
  "readings": {
    "analog_input_0:object-type": {
      "type": "uint32",
      "value": 0,
      "tags": {"Meta": true}
    },
    "analog_input_0:present-value": {
      "type": "float32",
      "value": 1550.0
    }
  },
  "tags": {"User": "Skye"},
  "type": "xrt.telemetry:1.0"
}
```

| 欄位 | 型別 | 說明 |
|------|------|------|
| device | String | 產生遙測的裝置名稱 |
| readings | Object | 資源名稱對應值與可選標籤 |
| sourceName | String | 排程讀取的資源名稱 |
| type | String | `xrt.telemetry:1.0` |
| tags | Object | 使用者可設定的標籤 |

**標籤來源：**

| 來源 | 範圍 |
|------|------|
| Profile Resource | 資源 |
| Profile Command | 訊息 |
| Device Service Configuration | 訊息 |
| Schedule Configuration | 訊息 |
| Device Configuration | 訊息 |

---

### 1.5 通知格式（Notification）

```json
{
  "component": "profinet",
  "timestamp": 1663341779217648,
  "device_name": "netHAT",
  "severity": "Debug",
  "event": "PNIO_CBE_DEV_ACT_CONF",
  "message": "Device has been activated",
  "details": {
    "result": 0
  }
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| component | String | Y | 產生通知的元件名稱 |
| timestamp | Integer | Y | 產生時間（奈秒） |
| device_name | String | N | 相關裝置名稱 |
| severity | String | Y | ERROR、WARN、Info、Debug、Trace |
| event | String | Y | 簡短事件名稱 |
| message | String | Y | 事件描述 |
| details | Object | N | 附加資訊 |

**通用事件：**

- `XRT_LOG`：Bus Logger 元件通知
- `XRT_OPSTATE`：裝置運作狀態變更（例：`{"state": "up"}`）

---

### 1.6 裝置格式（Device）

```json
{
  "name": "3befe158-ed46-4afc-b838-7bcf96b4e414",
  "profileName": "modbus-sim",
  "protocols": {
    "modbus-rtu": {
      "Address": "/tmp/virtualport",
      "BaudRate": 19200,
      "DataBits": 8,
      "Parity": "N",
      "StopBits": 1,
      "UnitID": 3
    }
  },
  "properties": {
    "vendor": "IOTech"
  },
  "scheduleDeadBand": 1000,
  "tags": {
    "tag_name": "tag_value"
  }
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| name | String | Y | 裝置名稱 |
| profileName | String | 條件式 | 關聯的設定檔名稱 |
| protocols | Object | Y | 協定組態 |
| properties | Object | N | 裝置屬性 |
| scheduleDeadBand | Integer | N | 死區（毫秒） |
| tags | Object | N | 裝置標籤 |

---

### 1.7 排程格式（Schedule）

```json
{
  "name": "1c28183b-837f-466d-84c5-42a6bcfcf428",
  "device": "15d6b69e-2d9a-48a3-a433-cb6e42929804",
  "resource": ["Universal Input 2:present-value", "Universal Input 2:units"],
  "interval": 5000000,
  "tags": {"Group": "Input2"},
  "options": {
    "COV": {
      "Confirmed": true,
      "Lifetime": 360
    }
  }
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| name | String | Y | 排程名稱 |
| device | String | Y | 裝置名稱 |
| resource | String 或 Array | Y | 資源名稱或正規表示式模式 |
| interval | Integer | N | 輪詢間隔（微秒） |
| on_change | Boolean | N | 僅發布變更值（預設：false） |
| tags | Object | N | 遙測標籤 |
| units | Boolean | N | 從設定檔發布資源單位 |
| options | Object | N | 協定特定選項 |

---

### 1.8 裝置探索格式（Device Discovery）

```json
{
  "type": "xrt.device.discovery:1.0",
  "devices": {
    "SimpleServer": {
      "properties": {
        "ApplicationSoftware": "1.0",
        "Contactable": true,
        "DeviceType": "BACnet-IP",
        "Firmware": "1.0.0",
        "IP": "192.168.4.18",
        "InstanceID": 2345,
        "ModelName": "IOTech SIM",
        "ObjectName": "SimpleServer",
        "Port": 47808,
        "VendorID": 1313,
        "VendorName": "IOTech"
      },
      "protocols": {
        "BACnet-IP": {
          "DeviceInstance": 2345
        }
      }
    }
  }
}
```

| 欄位 | 型別 | 說明 |
|------|------|------|
| type | String | `xrt.device.discovery:1.0` |
| devices | Object | 裝置中繼資料，以裝置名稱為鍵 |

---

### 1.9 讀數格式與資料型別（Reading）

```json
{
  "BinaryInput1": {
    "origin": 1611161894180636200,
    "type": "bool",
    "value": true,
    "tags": {"tag_name": "tag_value"}
  },
  "AnalogInput1": {
    "origin": 1611161894180636220,
    "type": "uint32",
    "value": 3423
  },
  "Status": {
    "origin": 1611161894180636240,
    "type": "stringarray",
    "value": ["disabled", "active"]
  }
}
```

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| type | String | Y | 資料型別字串 |
| value | 依型別而定 | Y | 資料值 |
| origin | Integer | N | 時間戳記（奈秒） |
| tags | Object | N | 來自設定檔的資源標籤 |
| units | String | N | 來自設定檔的資源單位 |

#### 支援的資料型別

| 名稱 | 型別 | JSON 範例 |
|------|------|-----------|
| bool | Boolean | true |
| int8 | 有號 8 位元 | -12 |
| uint8 | 無號 8 位元 | 123 |
| int16 | 有號 16 位元 | -1234 |
| uint16 | 無號 16 位元 | 1234 |
| int32 | 有號 32 位元 | -1234567 |
| uint32 | 無號 32 位元 | 1234567 |
| int64 | 有號 64 位元 | -1234567890123 |
| uint64 | 無號 64 位元 | 1234567890123 |
| float32 | 32 位元浮點數 | 1550.0 |
| float64 | 64 位元浮點數 | 1550.123456789 |
| boolarray | Boolean 陣列 | [true, false, true] |
| int8array | int8 陣列 | [-128, 0, 127] |
| uint8array | uint8 陣列 | [0, 1, 2] |
| int16array | int16 陣列 | [-32768, 0, 32767] |
| uint16array | uint16 陣列 | [0, 1, 2, 65535] |
| int32array | int32 陣列 | [-2147483648, 0, 2147483647] |
| uint32array | uint32 陣列 | [0, 1, 2, 4294967295] |
| int64array | int64 陣列 | [-9223372036854775808, 0, 9223372036854775807] |
| uint64array | uint64 陣列 | [0, 1, 2, 18446744073709551615] |
| string | String | "an example string" |
| stringarray | String 陣列 | ["string1", "string2", "string3"] |
| binary | Base64 編碼 | "ASNFZw==" |
| object | 組合物件 | {"value": {"example": 1234}} |
| objectarray | 物件陣列 | [{"value1": 1234}, {"value2": 5678}] |

支援多維陣列：`[[1, 2, 3], [4, 5, 6]]`

---

### 1.10 元件管理操作（Component）

#### component:list — 列出元件

**請求：**

```json
{
  "client": "client0",
  "request_id": "0eb23c34-b38a-4e46-96ac-d1fb2b8c5597",
  "op": "component:list",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client0",
  "request_id": "0eb23c34-b38a-4e46-96ac-d1fb2b8c5597",
  "result": {
    "components": ["bus", "logger", "pool", "sched", "bacnet", "mqtt_bridge"],
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### component:read — 讀取元件

**請求參數：** `component`（String）— 元件名稱

```json
{
  "client": "client0",
  "request_id": "462cd4fe-caf7-4f2b-83b3-f32084866087",
  "op": "component:read",
  "component": "logger",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client0",
  "request_id": "462cd4fe-caf7-4f2b-83b3-f32084866087",
  "result": {
    "component": {
      "name": "logger",
      "state": "Running",
      "type": "IOT::Logger",
      "category": "IOT::Core",
      "config": {"Level": "Debug", "Name": "console"}
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### component:update — 更新元件

**請求參數：** `component`（String）— 元件名稱；`config`（Object）— 組態更新

```json
{
  "client": "client0",
  "request_id": "33aab1e3-44d0-4e01-9487-fe9e9cd51a9e",
  "op": "component:update",
  "component": "logger",
  "config": {"Level": "info"},
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client0",
  "request_id": "33aab1e3-44d0-4e01-9487-fe9e9cd51a9e",
  "result": {"status": 0},
  "type": "xrt.reply:1.0"
}
```

#### component:discover — 探索元件

**請求參數：** `category`（String，選填）— 依元件類別篩選

```json
{
  "client": "client2",
  "request_id": "929950d5-2323-4b6f-a102-9ee423c2ecac",
  "op": "component:discover",
  "category": "IOT::Core",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client2",
  "request_id": "929950d5-2323-4b6f-a102-9ee423c2ecac",
  "result": {
    "components": [
      {
        "category": "IOT::Core",
        "config": {"Logger": "logger"},
        "name": "sched",
        "state": "Running",
        "type": "IOT::Scheduler"
      },
      {
        "category": "IOT::Core",
        "config": {"Level": "info", "Name": "logger"},
        "name": "logger",
        "state": "Running",
        "type": "IOT::Logger"
      }
    ],
    "status": 0,
    "node_id": "azathoth",
    "server_id": "bacnet-ip-server"
  },
  "type": "xrt.reply:1.0"
}
```

#### discovery:discover — 跨所有 Xrt 實例探索元件

```json
{
  "client": "client2",
  "op": "discovery:discover",
  "type": "xrt.request:1.0"
}
```

**回應（可能收到多則訊息）：**

```json
{
  "client": "client2",
  "components": [
    {
      "category": "XRT::Core",
      "config": {"ServerId": "xrt-instance-1"},
      "name": "xrt",
      "state": "Running",
      "type": "XRT::Config"
    },
    {
      "category": "IOT::Core",
      "config": {"Logger": "logger", "Threads": 5},
      "name": "pool",
      "state": "Running",
      "type": "IOT::ThreadPool"
    }
  ],
  "node_id": "",
  "server_id": "xrt-instance-1",
  "type": "xrt.discovery:1.0"
}
```

#### component:exit — 關閉元件

**請求參數：** `server_id`（String）— 伺服器識別碼或 `"*"` 代表全部；`delay`（Integer，選填）— 關閉延遲毫秒（預設：1000）

```json
{
  "client": "manager",
  "request_id": "963b8fd1-4bd5-42cb-b10f-adf20ff0b461",
  "op": "component:exit",
  "server_id": "*",
  "delay": 5000,
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "manager",
  "request_id": "963b8fd1-4bd5-42cb-b10f-adf20ff0b461",
  "result": {"status": 0},
  "type": "xrt.reply:1.0"
}
```

---

### 1.11 裝置管理操作（Device）

#### device:list — 列出裝置

```json
{
  "client": "client1",
  "request_id": "fa7cdd1a-c0ee-4578-b33b-444d777f2301",
  "op": "device:list",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "fa7cdd1a-c0ee-4578-b33b-444d777f2301",
  "result": {
    "devices": [
      "a18342fe-5c53-451e-829e-2b7063397caf",
      "c73cee57-05cd-4fac-9d8b-987026831927",
      "4bf7d20f-5a4d-42ab-a939-bfbabdf17500"
    ],
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### device:add — 新增裝置

**請求參數：** `device`（String）— 裝置名稱；`device_info`（Object）— 裝置中繼資料

```json
{
  "client": "client1",
  "request_id": "404be6e3-e171-4547-bacb-151dfe0ae483",
  "op": "device:add",
  "device": "3befe158-ed46-4afc-b838-7bcf96b4e414",
  "device_info": {
    "profileName": "opc-ua-sim-profile",
    "protocols": {
      "OPC-UA": {
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  },
  "type": "xrt.request:1.0"
}
```

#### device:scan — 掃描裝置

**請求參數：** `device`（String，必填）— 裝置名稱；`profile`（String，選填）— 產生的設定檔名稱；`options`（Object，選填）— 掃描選項

```json
{
  "client": "client1",
  "request_id": "f07be237-8928-429c-b236-6fa1c59da216",
  "op": "device:scan",
  "device": "f02f87c9-6248-45e6-ac0f-1d74e20049ba",
  "profile": "NewProfile",
  "type": "xrt.request:1.0"
}
```

**BACnet 掃描範例（含選項）：**

```json
{
  "client": "client1",
  "request_id": "f07be237-8928-429c-b236-6fa1c59da216",
  "op": "device:scan",
  "device": "bacnet-ip-sim1",
  "options": {
    "DiscoverInitialValues": false,
    "DiscoverProperties": [75, 36, 28, 81, 85, 103, 117, 87],
    "DiscoverObjects": [8, 0, 1, 2, 3, 4, 5, 13, 14, 19]
  },
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "f07be237-8928-429c-b236-6fa1c59da216",
  "result": {
    "profile": "a3269a76-fc83-44ac-b3ca-2ecb7a7c4965",
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### device:read — 讀取裝置資訊

**請求參數：** `device`（String）— 裝置名稱

```json
{
  "client": "client1",
  "request_id": "73450fca-abdc-44af-be7d-65ca9fe3ffc1",
  "op": "device:read",
  "device": "3befe158-ed46-4afc-b838-7bcf96b4e414",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "73450fca-abdc-44af-be7d-65ca9fe3ffc1",
  "result": {
    "device": {
      "name": "3befe158-ed46-4afc-b838-7bcf96b4e414",
      "profileName": "AI 4xU/I 2-wire ST_1",
      "protocols": {
        "Profinet": {
          "I-base": "0",
          "Q-base": "0"
        }
      },
      "properties": {
        "name": "AI 4xU/I 2-wire ST",
        "description": "Analog input module AI4 x U/I 2-wire ST",
        "vendor": "SIEMENS"
      }
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### device:update — 更新裝置資訊

**請求參數：** `device`（String）— 裝置名稱；`device_info`（Object）— 可更新欄位：profileName、protocols、properties、operational、enabled

```json
{
  "client": "client1",
  "request_id": "815cf17b-1c19-4d66-b0fa-ff217dbca97e",
  "op": "device:update",
  "device": "3befe158-ed46-4afc-b838-7bcf96b4e414",
  "device_info": {
    "profileName": "AI 4xU/I 2-wire ST_2"
  },
  "type": "xrt.request:1.0"
}
```

#### device:delete — 刪除裝置

**請求參數：** `device`（String）— 裝置名稱

```json
{
  "client": "client1",
  "request_id": "ae813a79-c11c-459b-bf27-874699774025",
  "op": "device:delete",
  "device": "bacnet-ip-sim1",
  "type": "xrt.request:1.0"
}
```

#### device:get — 讀取裝置資源

**請求參數：** `device`（String）— 裝置名稱；`resource`（String 或 Array）— 資源名稱或正規表示式

```json
{
  "client": "client1",
  "request_id": "94178bb8-a0ba-465f-ab31-77f1ba81537f",
  "op": "device:get",
  "device": "damocles-0002b503c1ec",
  "resource": "BinaryInput1:present-value",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "94178bb8-a0ba-465f-ab31-77f1ba81537f",
  "result": {
    "readings": {
      "BinaryInput1": {
        "origin": 1611161894180636200,
        "value": true,
        "type": "bool"
      }
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### device:put — 寫入裝置資源

**請求參數：** `device`（String）— 裝置名稱；`values`（Object）— 資源名稱與值；`options`（Object，選填）— 協定特定寫入選項

```json
{
  "client": "client1",
  "request_id": "37d6faf3-8e0b-4f52-b02c-cdd833cbb528",
  "op": "device:put",
  "device": "damocles-0002b503c1ec",
  "values": {
    "BinaryOutput2:present-value": false,
    "BinaryOutput1:present-value": true
  },
  "options": {"Priority": 5},
  "type": "xrt.request:1.0"
}
```

---

### 1.12 裝置服務管理操作（Service）

#### service:read — 讀取參數

```json
{
  "client": "client1",
  "request_id": "566fd8e8-c681-49b7-8c71-d5f6bf42fd40",
  "op": "service:read",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "566fd8e8-c681-49b7-8c71-d5f6bf42fd40",
  "result": {
    "parameters": {
      "State": "SAFE_OP"
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### service:update — 更新參數

**請求參數：** `parameters`（Object）— 參數名稱與新值

```json
{
  "client": "client1",
  "request_id": "ad8b9ab0-69c5-4c48-95d9-951774463781",
  "op": "service:update",
  "parameters": {
    "State": "OP"
  },
  "type": "xrt.request:1.0"
}
```

---

### 1.13 設定檔管理操作（Profile）

#### profile:list — 列出設定檔

```json
{
  "client": "client1",
  "request_id": "4fe9d670-eba7-474a-9f2a-8f22b695d32a",
  "op": "profile:list",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "4fe9d670-eba7-474a-9f2a-8f22b695d32a",
  "result": {
    "profiles": [
      "fe04cd4b-1330-460e-bae9-eb75c8c0d556",
      "dd609c4d-a170-4289-a7f1-4ea0957423a3"
    ],
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### profile:add — 新增設定檔

**請求參數：** `profile`（Object）— 設定檔定義

```json
{
  "client": "client1",
  "request_id": "66961ca5-d962-44d6-92d9-3f6c76ffc63a",
  "op": "profile:add",
  "profile": {
    "description": "Settings for Originator to Target Implicit Data Exchange",
    "labels": [],
    "deviceResources": [
      {
        "name": "Implicit O2T Settings",
        "attributes": {
          "type": "O2TSettings",
          "assemblyID": 112,
          "size": 496,
          "includeHeader32bit": true
        },
        "properties": {
          "valueType": "String",
          "readWrite": "R"
        }
      }
    ],
    "name": "6c52903d-e942-4275-8f48-e8d927f3d2a6",
    "model": "DI 8x24VDC ST V1.0"
  },
  "type": "xrt.request:1.0"
}
```

#### profile:read — 讀取設定檔

**請求參數：** `profile`（String）— 設定檔名稱

```json
{
  "client": "client1",
  "request_id": "ae87de5c-3dd8-45c6-9101-2e0f7a92e402",
  "op": "profile:read",
  "profile": "6c52903d-e942-4275-8f48-e8d927f3d2a6",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "ae87de5c-3dd8-45c6-9101-2e0f7a92e402",
  "result": {
    "profile": {
      "description": "Digital input module DI8 x 24VDC ST",
      "labels": [],
      "deviceResources": [
        {
          "description": "Inputs",
          "properties": {
            "valueType": "uint8",
            "readWrite": "R"
          },
          "name": "Inputs",
          "attributes": {
            "I-offset": "0"
          }
        }
      ],
      "name": "6c52903d-e942-4275-8f48-e8d927f3d2a6",
      "model": "DI 8x24VDC ST V1.0"
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### profile:update — 更新設定檔

**請求參數：** `profile`（Object）— 更新的設定檔定義

```json
{
  "client": "client1",
  "request_id": "7502b4e0-178d-4adc-961a-a312d28f1b0c",
  "op": "profile:update",
  "profile": {
    "name": "bacnet-ip-sim-profile",
    "description": "Profile for IOTech BACnet Simulator",
    "model": "IOTech BACnet Simulator",
    "labels": [],
    "deviceResources": [
      {
        "attributes": {
          "instance": 1,
          "property": 85,
          "type": 1
        },
        "name": "analog_output_1:present-value",
        "properties": {
          "readWrite": "RW",
          "valueType": "float32"
        }
      }
    ]
  },
  "type": "xrt.request:1.0"
}
```

#### profile:delete — 刪除設定檔

**請求參數：** `profile`（String）— 設定檔名稱

```json
{
  "client": "client1",
  "request_id": "bddf5eba-db8c-442b-bd68-c7b505e8095c",
  "op": "profile:delete",
  "profile": "6c52903d-e942-4275-8f48-e8d927f3d2a6",
  "type": "xrt.request:1.0"
}
```

---

### 1.14 排程管理操作（Schedule）

#### schedule:list — 列出排程

```json
{
  "client": "client1",
  "request_id": "1e92b97e-47b0-4cc0-a4d1-5f927c2d87d9",
  "op": "schedule:list",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "1e92b97e-47b0-4cc0-a4d1-5f927c2d87d9",
  "result": {
    "schedules": [
      "5d9e8fbd-6e02-49fa-9d87-7ecfefc6f564",
      "b7883904-fe0c-4352-9e93-9c4225dc3daa"
    ],
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### schedule:add — 新增排程

**請求參數：** `schedule`（Object）— 排程定義

```json
{
  "client": "client1",
  "request_id": "a5755ee5-d937-4043-ba2b-39ac6bef3418",
  "op": "schedule:add",
  "schedule": {
    "name": "1c28183b-837f-466d-84c5-42a6bcfcf428",
    "device": "15d6b69e-2d9a-48a3-a433-cb6e42929804",
    "resource": ["Universal Input 2:present-value", "Universal Input 2:units"],
    "interval": 5000000,
    "options": {
      "COV": {
        "Confirmed": true,
        "Lifetime": 360
      }
    }
  },
  "type": "xrt.request:1.0"
}
```

#### schedule:read — 讀取排程

**請求參數：** `schedule`（String）— 排程名稱

```json
{
  "client": "client1",
  "request_id": "a5755ee5-d937-4043-ba2b-39ac6bef3418",
  "op": "schedule:read",
  "schedule": "a5755ee5-d937-4043-ba2b-39ac6bef3418",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "a5755ee5-d937-4043-ba2b-39ac6bef3418",
  "result": {
    "schedule": {
      "id": "a5755ee5-d937-4043-ba2b-39ac6bef3418",
      "device": "15d6b69e-2d9a-48a3-a433-cb6e42929804",
      "resource": ["BinaryInput1:present-value", "BinaryInput2:present-value"],
      "interval": 5000000
    },
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### schedule:update — 更新排程

**請求參數：** `schedule`（Object）— 更新的排程定義

```json
{
  "client": "client1",
  "request_id": "99baccaf-2fbc-4377-80da-56bc16555cb9",
  "op": "schedule:update",
  "schedule": {
    "name": "1c28183b-837f-466d-84c5-42a6bcfcf428",
    "device": "15d6b69e-2d9a-48a3-a433-cb6e42929804",
    "resource": "BinaryInput1:present-value",
    "interval": 5000000,
    "on_change": true
  },
  "type": "xrt.request:1.0"
}
```

#### schedule:delete — 刪除排程

**請求參數：** `schedule`（String）— 排程名稱

```json
{
  "client": "client1",
  "request_id": "f7ad39e4-5b39-4293-b4ba-723c46872469",
  "op": "schedule:delete",
  "schedule": "1c28183b-837f-466d-84c5-42a6bcfcf428",
  "type": "xrt.request:1.0"
}
```

---

### 1.15 探索管理操作（Discovery）

#### discovery:read — 讀取探索選項

```json
{
  "client": "client1",
  "request_id": "abb2fa4f-68b8-4129-9df9-801c63e1d05f",
  "op": "discovery:read",
  "type": "xrt.request:1.0"
}
```

**回應：**

```json
{
  "client": "client1",
  "request_id": "abb2fa4f-68b8-4129-9df9-801c63e1d05f",
  "result": {
    "mode": "enabled",
    "interval": 0,
    "status": 0
  },
  "type": "xrt.reply:1.0"
}
```

#### discovery:update — 更新探索選項

**請求參數：** `enable`（Boolean）— 啟用/停用探索；`interval`（Integer）— 探索輪詢間隔（秒）

```json
{
  "client": "client1",
  "request_id": "b2d4710e-a6dc-4102-a9f7-e67cdfbb9c27",
  "op": "discovery:update",
  "enable": true,
  "interval": 3600,
  "type": "xrt.request:1.0"
}
```

#### discovery:trigger — 觸發探索

**請求參數：** `options`（Object，選填）— 協定特定探索選項

```json
{
  "client": "client1",
  "request_id": "a40c10f6-8489-401a-ac5f-5bd9942e995c",
  "op": "discovery:trigger",
  "options": {
    "DiscoveryDuration": 5000,
    "DiscoveryRetries": 2,
    "DiscoveryDeviceRange": [0, 999]
  },
  "type": "xrt.request:1.0"
}
```

---

## 2. 遷移指南

### 2.1 V1.x 到 V2.x 遷移

#### 2.1.1 裝置設定檔變更

**deviceResources 的 properties 結構改變：**

V1.x — `properties` 包含 `value` 與 `units` 兩個巢狀物件：

```json
{
  "properties": {
    "value": {
      "type": "Int32",
      "readWrite": "RW"
    },
    "units": {
      "type": "String",
      "readWrite": "R",
      "defaultValue": "degrees/sec"
    }
  }
}
```

V2.x — `properties` 扁平化，`units` 變成單一字串：

```json
{
  "properties": {
    "valueType": "Int32",
    "readWrite": "RW",
    "units": "degrees/sec"
  }
}
```

**deviceCommands 結構改變：**

V1.x — 使用 `get` 與 `set` 陣列，含 `index` 欄位：

```json
{
  "name": "Rotation",
  "get": [
    {"index": "0", "operation": "get", "deviceResource": "Xrotation"},
    {"index": "1", "operation": "get", "deviceResource": "Yrotation"}
  ],
  "set": [
    {"index": "0", "operation": "set", "deviceResource": "Xrotation"},
    {"index": "1", "operation": "set", "deviceResource": "Yrotation"}
  ]
}
```

V2.x — 合併為 `readWrite` 與 `resourceOperations`：

```json
{
  "name": "Rotation",
  "readWrite": "RW",
  "resourceOperations": [
    {"deviceResource": "Xrotation"},
    {"deviceResource": "Yrotation"}
  ]
}
```

#### 2.1.2 各裝置服務的重要變更

**OPC UA：**
- `nsIndex`：從 String 改為 Integer
- `monitored`：從 String 改為 Boolean
- `publishInterval`：從 String 改為 Double
- 協定參數 `RequestedSessionTimeout`、`BrowseDepth`、`BrowsePublishInterval`、`ConnectionReadingPostDelay` 皆從 String 改為數值型別

**BACnet：**
- `NetworkID` 替換為 `DeviceObject` 物件（包含 InstanceID、ObjectName、VendorName 等）
- 布林邏輯反轉：`DisableMultiRead` 改為 `MultiRead`（true/false 反轉）
- `DefaultDiscoveryMode` 改名為 `DiscoverMode`
- 資源屬性 `property`、`type`、`instance`、`index` 從 String 改為 Integer
- Binary 資料型別改為 `uint8array`
- Recipient List 從 Map 改為直接陣列
- 協定 `DeviceInstance` 從 String 改為 Integer

**S7：**
- 資源屬性鍵名大寫改小寫：`Type` → `type`、`Operation` → `operation`、`Start` → `start`、`Size` → `size`
- 屬性值大寫改小寫：`State` → `state`、`Job_res` → `job_res`
- 數值型別從 String 改為 Integer

**GPS：**
- Driver 選項遷移至協定屬性
- 新增 `data` 屬性決定回傳資料類型
- 新增 `GpsdConnTimeout`、`GpsdRequestTimeout`、`GpsdRetries`

**EtherNet/IP：**
- 所有數值從 String 改為字面值型別
- 不再支援十六進位值（0x 前綴）
- 移除 `readOnChange` 欄位
- 新增 `ConnectionTimeout` Driver 選項

**EtherCAT：**
- `CycleTime_us` 從 String 改為 Unsigned Integer
- 資源屬性 `index`、`subIndex`、`byteLength` 等從 String 改為 Unsigned Integer
- PDO 配置必須使用十進位整數陣列

**PROFINET：**
- `Q-offset`、`I-offset`、`byteLength` 從 String 改為 Unsigned Integer
- 新增 `I-offset-bits` 屬性用於布林值（取代 `"5.2"` 格式）

#### 2.1.3 Azure Sphere 變更

- 支援 SDK 22.04 與 API 12
- 裝置從 Map 改為 Array（`"Devices": {...}` → `"Devices": [...]`）
- 排程的 `resource` 從 String 改為 Array
- 所有裝置服務的型別變更同樣適用於 Device Twin 組態

---

### 2.2 V2.0 到 V2.1 遷移

#### 2.2.1 OPC UA 破壞性變更

- **裝置資源定義完全改變**：允許讀寫所有節點屬性後，資源定義方式已根本改變。**舊版設定檔將無法使用**，建議使用設定檔產生功能重新產生。
- **移除的協定參數**：`BrowseSubFilter`、`BrowseDepth`、`BrowsePublishInterval`

#### 2.2.2 Management API 變更

- 元件組態更新現在會持久化到儲存區
- 新增 `component:update` 指令操作
- 新增裝置時 profileName 變為選填
- 排程可附帶標籤，標籤自動加入遙測資料

---

### 2.3 V2.1 到 V2.2 遷移

#### 2.3.1 OPC UA 裝置服務變更

- 新增 `ClientIterateInterval` 裝置屬性
- **移除的資源屬性**：`browseStartNodeId`、`browsePathNamespaceIndex`
- `browsePath` 屬性改為接受 `BrowsePath` 結構
- **使用舊屬性的設定檔將無法使用**，必須更新
- 增強所有 OPC UA 資料型別支援，影響讀寫值格式
- 設定檔產生的組態選項已變更

**OPC UA 事件的兩種實作方式：**

1. **Extension Component**：OPC UA Event Registration Component 擴展裝置服務 API
2. **Auto Events**：透過 OPC-UA Subscriptions 建立，可精細控制

#### 2.3.2 OPC UA Server 破壞性變更

- **舊的 JSON 節點模型組態檔不再支援**
- 自訂資訊模型必須使用 OPC Foundation 規範的 Information Model XML Schema（Nodeset）格式
- 必須搭配 `mappings` 組態檔載入

---

## 3. Release Notes

### 3.1 Version 2.2

**新功能：**

- 新增 Redis Bridge 元件
- 新增將 Xrt 實例聯合至 OPC UA Server 的支援
- 新增 OPC UA Nodeset 到資源的對映支援
- 新增 OPC UA Alarms 支援
- 新增 BACnet 裝置重啟後的 COV 重新整理支援
- 新增 EtherCAT 裝置服務直接處理循環資料的能力
- 更新 MQTT Management API，加入 `discovery:discover` 指令操作
- 新增 Zigbee 裝置服務元件
- 新增 Modbus Discovery 支援
- 新增 Virtual Device Service 與 S7 Device Service 的陣列支援
- 新增 EtherCAT 裝置服務的 CoE-CA 功能與 Station Alias 定址
- 新增裝置服務管理 API 的讀取與更新操作
- 更新 S7 裝置服務，加入 Marker、Timer 與 Counter

**移除與棄用：**

- 移除 MQTT Bridge 的 Google IoT Core 匯出支援
- 移除 Photon 4.0 支援
- 移除 SSLv2、SSLv3、TLS 1.0 與 TLS 1.1 加密支援
- 移除 Ubuntu 24.04 的 Redis Exporter 支援

**平台支援變更：**

- 新增 Debian 12 支援
- 新增 OpenSUSE Leap 15.5，移除 15.4
- 新增 Fedora 40，移除 Fedora 36
- 新增 Alpine Linux 3.17、3.18、3.19

---

### 3.2 Version 2.1

**新功能：**

- 新增 EtherNet/IP 裝置服務的裝置探索與設定檔產生
- 新增 OPC UA Server 元件
- 新增 MQTT Bridge 的 MaxBufferedMessages 組態
- 新增 MQTT Bridge 的 MinRetryInterval 與 MaxRetryInterval 組態
- 新增裝置的 OperationalState 與 AdminState 支援，可發布裝置狀態變更
- 新增 InfluxDB v2.x 資料匯出支援
- 新增資源、排程與命令標籤支援
- 新增 CANbus 裝置服務
- 新增 WSL 支援

**平台支援變更：**

- 新增 Alpine Linux 3.16，移除 3.14
- 新增 Fedora 36，移除 35
- 新增 AzureSphere 21.10 SDK 與 API 11
- 新增 OpenSUSE Leap 15.4，移除 15.3
- 更新 Xrt 容器使用 Alpine v3.16
- 新增 RISC-V 處理器支援

---

### 3.3 Version 2.0

**新裝置服務：**

- 新增 S7 裝置服務元件
- 新增 GPS 裝置服務元件
- 新增 BLE 裝置服務元件

**重大變更：**

- 更新 MQTT Management API
- 所有產品範例移至 IOTech GitHub 儲存庫
- 更新至 Azure Sphere 21.10 SDK 與 API 11、22.02 SDK 與 API 12
- 更新至 IOT C Utils 1.3 版
- 更新 Paho MQTT 套件至 v1.3.10
- Bus 發布者與訂閱者配置函式新增額外引數
- Bus 訂閱者回呼函式提供 const 資料元素
- 新增回傳 Bus 發布者主題名稱與訂閱者訂閱模式的函式
- 新增排程的 `on_change`、`publish`、`units` 選項
- 新增 Command 元件支援動態元件組態

**平台支援變更：**

- 新增 Fedora 35、OpenSUSE 15.3、Ubuntu 22.04、Photon Linux 4.0、Debian 11
- 新增 Alpine 3.14 與 3.15，移除 3.12 與 3.13
- 移除 CentOS 8、Zephyr 1.14、Debian 9

---

### 3.4 Version 1.1

**新裝置服務與元件：**

- 新增 Modbus、BACnet、OPC UA、EtherNet/IP、PROFINET 裝置服務元件
- 新增 Azure Exporter、AWS SiteWise Exporter 元件
- 新增 Ring Buffer、Batch Transform 元件

**增強功能：**

- 新增 InfluxDB、REST、MQTT Exporters 的重連與批次處理支援
- 更新 Paho MQTT 套件至 v1.3.6
- 新增 Azure Sphere 裝置支援（MT360 Device、AzureSphere Exporter、Lua 建置支援）
- 支援的 Azure Sphere 裝置服務：Modbus、BACnet、EtherNet/IP、Virtual
- 透過 Device Twin 進行 Xrt 組態

**移除：**

- 移除 File Device、Virtual Device、Virtual Device Lua 元件
