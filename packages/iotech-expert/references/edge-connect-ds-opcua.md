<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/opc-ua-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/simulators/opc-ua/overview.html
    - https://docs.iotechsys.com/edge-xrt22/simulators/opc-ua/lua-scripting.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — OPC UA Device Service 完整指南

## 目錄

- [1. 概述](#1-概述)
- [2. 元件組態範本](#2-元件組態範本)
- [3. 驅動選項](#3-驅動選項)
- [4. 裝置描述檔屬性](#4-裝置描述檔屬性)
  - [4.1 必要屬性](#41-必要屬性)
  - [4.2 節點屬性（依節點類別分類）](#42-節點屬性依節點類別分類)
- [5. 協定參數](#5-協定參數)
- [6. 裝置佈建範例](#6-裝置佈建範例)
- [7. 安全組態](#7-安全組態)
- [8. 方法操作](#8-方法操作)
- [9. 訂閱與事件監控](#9-訂閱與事件監控)
  - [9.1 基礎事件欄位](#91-基礎事件欄位)
  - [9.2 事件篩選子句](#92-事件篩選子句)
- [10. 描述檔產生（Profile Generation）](#10-描述檔產生profile-generation)
- [11. Docker 部署](#11-docker-部署)
  - [11.1 Host 網路模式](#111-host-網路模式)
  - [11.2 Bridge 網路模式](#112-bridge-網路模式)
- [12. OPC UA 模擬器](#12-opc-ua-模擬器)
  - [12.1 基本啟動與選項](#121-基本啟動與選項)
  - [12.2 環境變數](#122-環境變數)
  - [12.3 安全模式](#123-安全模式)
- [13. Lua 腳本 API](#13-lua-腳本-api)
  - [13.1 Update 回呼函式](#131-update-回呼函式)
  - [13.2 Server 物件](#132-server-物件)
  - [13.3 NodeId 物件](#133-nodeid-物件)
  - [13.4 Variant 物件](#134-variant-物件)
  - [13.5 ObjectNode 物件](#135-objectnode-物件)
  - [13.6 VariableNode 物件](#136-variablenode-物件)
  - [13.7 ObjectTypeNode 物件](#137-objecttypenode-物件)
  - [13.8 MethodNode 物件](#138-methodnode-物件)
  - [13.9 Argument 物件](#139-argument-物件)
  - [13.10 列舉型別](#1310-列舉型別)

---

## 1. 概述

OPC UA Device Service 元件讓 Edge Connect 能與 OPC UA 伺服器通訊，支援讀寫節點值、方法呼叫、訂閱、事件監控以及裝置探索。服務使用 `libxrt-device-service.so` 函式庫和 `xrt_opcua_device_service_factory` 工廠。

---

## 2. 元件組態範本

```json
{
  "Library": "libxrt-device-service.so",
  "Factory": "xrt_opcua_device_service_factory",
  "Name": "opcua",
  "TelemetryTopic": "xrt/devices/opcua/telemetry",
  "RequestTopic": "xrt/devices/opcua/request",
  "ReplyTopic": "xrt/devices/opcua/reply",
  "DiscoveryTopic": "xrt/devices/opcua/discovery",
  "StateDir": "./deployment/state",
  "ProfileDir": "./deployment/profiles",
  "Scheduler": "sched",
  "Logger": "logger",
  "ThreadPool": "pool",
  "Bus": "bus"
}
```

---

## 3. 驅動選項

| 參數 | 型別 | 說明 | 預設值 |
|------|------|------|--------|
| LDSName | String | 本地探索伺服器（Local Discovery Server）的裝置名稱，以分號分隔 | 空 |

---

## 4. 裝置描述檔屬性

### 4.1 必要屬性

| 屬性 | 型別 | 條件 | 說明 |
|------|------|------|------|
| nodeAttribute | String | 必要 | 參考節點屬性：`value`、`description`、`browseName`、`displayName` 等 |
| nodeId | NodeId | 條件式必要 | 伺服器節點識別碼；除非指定 `browsePath`，否則必填 |
| dataTypeId | NodeId | 條件式必要 | 當 `nodeAttribute` 為 `value` 時必填 |
| browsePath | BrowsePath | 選用 | 替代的節點參考方式 |

### 4.2 節點屬性（依節點類別分類）

#### 通用屬性（適用所有節點類型）

`nodeId`、`nodeClass`、`browseName`、`displayName`、`description`、`writeMask`、`userWriteMask`、`references`

#### Variable 節點類別

`value`、`dataType`、`valueRank`、`arrayDimensions`、`accessLevel`、`userAccessLevel`、`minimumSamplingInterval`、`historizing`

#### Object 節點類別

`event`、`eventNotifier`

#### Method 節點類別

`executable`、`userExecutable`、`method`

---

## 5. 協定參數

協定指定必須使用 `"OPC-UA"` 作為鍵，`Address` 格式為 `<serverAddress>:<port><endpointPath>`。

| 參數 | 型別 | 是否必要 | 預設值 | 說明 |
|------|------|----------|--------|------|
| Address | String | 是 | 無 | OPC UA 伺服器 URI |
| SecurityPolicy | String | 否 | None | 選項：`Basic256`、`Basic128Rsa15`、`Basic256Sha256`、`Aes128Sha256RsaOaep` |
| SecurityMode | String | 否 | None | 選項：`Sign`、`SignEncrypt` |
| Username | String | 否 | 無 | 連線憑證（使用者名稱） |
| Password | String | 否 | 無 | 連線憑證（密碼） |
| Certificate | String | 否 | 無 | DER 格式憑證檔名 |
| PrivateKey | String | 否 | 無 | DER 格式私鑰檔名 |
| RequestedSessionTimeout | UInt32 | 否 | 1200000 | 會話逾時（毫秒） |
| Timeout | UInt32 | 否 | 5000 | 請求逾時（毫秒） |
| SessionKeepAliveInterval | Float64 | 否 | 1000 | 保活間隔（毫秒） |
| RootNode | NodeId | 否 | 伺服器根資料夾 | 瀏覽路徑起始點 |
| ConnectionReadingPostDelay | UInt64 | 否 | 0 | 連線後讀取延遲（毫秒） |
| ClientIterateInterval | UInt32 | 否 | 100000 | 用戶端迭代間隔（奈秒） |

---

## 6. 裝置佈建範例

```json
{
  "opcua-sim": {
    "profileName": "opcua-sim-profile",
    "protocols": {
      "OPC-UA": {
        "Address": "opc.tcp://127.0.0.1:49947"
      }
    },
    "name": "opcua-sim"
  }
}
```

### 帶安全組態的範例

```json
{
  "opcua-secure": {
    "profileName": "opcua-secure-profile",
    "protocols": {
      "OPC-UA": {
        "Address": "opc.tcp://192.168.1.100:4840",
        "SecurityPolicy": "Basic256Sha256",
        "SecurityMode": "SignEncrypt",
        "Certificate": "client-cert.der",
        "PrivateKey": "client-key.der"
      }
    },
    "name": "opcua-secure"
  }
}
```

### 帳密驗證範例

```json
{
  "opcua-auth": {
    "profileName": "opcua-auth-profile",
    "protocols": {
      "OPC-UA": {
        "Address": "opc.tcp://192.168.1.100:4840",
        "Username": "admin",
        "Password": "password123"
      }
    },
    "name": "opcua-auth"
  }
}
```

---

## 7. 安全組態

支援的安全政策（Security Policy）：

| 政策名稱 | 說明 |
|----------|------|
| None | 無安全性（預設） |
| Basic128Rsa15 | 基本加密 |
| Basic256 | 256 位元加密 |
| Basic256Sha256 | 256 位元加密含 SHA-256 雜湊 |
| Aes128Sha256RsaOaep | AES-128 加密含 RSA-OAEP 填充 |

支援的安全模式（Security Mode）：

| 模式 | 說明 |
|------|------|
| None | 無簽章/加密（預設） |
| Sign | 僅簽章 |
| SignEncrypt | 簽章並加密 |

---

## 8. 方法操作

支援的 ConditionType 方法：

`Enable`、`Disable`、`AddComment`、`Acknowledge`、`Confirm`、`Reset`、`Silence`、`Suppress`、`Unsuppress`、`RemoveFromService`、`PlaceInService`

---

## 9. 訂閱與事件監控

監控項目透過自動事件（auto events）配置，可選用 `MonitoredItemConfig`。

### 9.1 基礎事件欄位

`EventId`、`EventType`、`LocalTime`、`Message`、`ReceiveTime`、`Severity`、`SourceName`、`SourceNode`、`Time`

### 9.2 事件篩選子句

使用 `EventFilterSelectClauses` 配置 `SimpleAttributeOperand`，依據 OPC UA Part 4 規範。

---

## 10. 描述檔產生（Profile Generation）

透過 `device:scan` 操作支援自動產生裝置描述檔，可用以下篩選器：

| 篩選器 | 說明 |
|--------|------|
| nodeAttributeWhiteList | 選擇要納入的特定屬性 |
| nodeClassWhiteList | 依節點類別篩選：`object`、`variable`、`method`、`objectType`、`variableType`、`referenceType`、`dataType`、`view` |
| TypeDefinitionFilter | 排除特定節點類型，可選包含子類型 |
| browseStartNodeId | 定義瀏覽起始點 |

---

## 11. Docker 部署

映像檔：`iotechsys/xrt:2.2`

### 11.1 Host 網路模式

```bash
docker run --rm --name xrt-opcua \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network host \
  iotechsys/xrt:2.2 [time_in_seconds]
```

Host 網路模式允許 OPC UA Device Service 探索與主機相同子網路上的 OPC UA 伺服器。

### 11.2 Bridge 網路模式

```bash
docker run --rm --name xrt-opcua \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network <docker_bridge_network> \
  iotechsys/xrt:2.2 [time_in_seconds]
```

省略 `--network` 時使用預設 Bridge 網路。

---

## 12. OPC UA 模擬器

映像檔：`iotechsys/opc-ua-sim:1.4`

OPC UA 模擬器是一個可透過 Lua 腳本配置和修改的 OPC UA 伺服器。

### 12.1 基本啟動與選項

```bash
# 下載映像檔
docker pull iotechsys/opc-ua-sim:1.4

# 基本執行
docker run --rm --name opc-ua-sim -p 49947:49947 iotechsys/opc-ua-sim:1.4

# 使用 Lua 腳本
docker run --rm --name opc-ua-sim -p 49947:49947 \
  iotechsys/opc-ua-sim:1.4 -l /example-scripts/simulation.lua

# 使用自訂腳本（掛載卷）
docker run --rm --name opc-ua-sim -p 49947:49947 \
  -v {path-to-scripts}:{mounted-path} \
  iotechsys/opc-ua-sim:1.4 --lua-script {mounted-path}/custom-script.lua

# 啟用 LDS
docker run --rm --name opc-ua-sim -p 49947:49947 -p 4840:4840 \
  -e RUN_LDS=true iotechsys/opc-ua-sim:1.4
```

#### 伺服器選項

| 選項 | 縮寫 | 參數 | 說明 |
|------|------|------|------|
| `--discovery-url` | `-d` | url | 向本地探索伺服器（LDS）註冊模擬器 |
| `--certificate` | `-c` | path | 伺服器憑證路徑 |
| `--private-key` | `-p` | path | LDS 私鑰路徑 |
| `--lua-script` | `-l` | path | Lua 腳本檔案位置 |
| `--security-policy` | `-s` | `None` / `Basic128Rsa15` / `Basic256Sha256` | 伺服器安全政策（預設：None） |
| `--security-mode` | `-m` | `None` / `Sign` / `SignEncrypt` | 安全模式（預設：None） |

### 12.2 環境變數

| 變數 | 值 | 說明 |
|------|------|------|
| RUN_LDS | `true` / `false` | 啟用本地探索伺服器（埠 4840） |

### 12.3 安全模式

使用範例：`--security-policy=Basic256Sha256`

---

## 13. Lua 腳本 API

### 13.1 Update 回呼函式

模擬器每 **100 毫秒**呼叫一次 `Update` 回呼函式，用於在伺服器執行期間更新節點值。

```lua
function Update()
  -- 每 100ms 被呼叫一次
  -- 在此更新節點值
end
```

### 13.2 Server 物件

| 方法 | 參數 | 回傳值 | 說明 |
|------|------|--------|------|
| `Server.addObjectNode(node)` | `node`: ObjectNode | `bool` | 新增物件節點 |
| `Server.addVariableNode(node)` | `node`: VariableNode | `bool` | 新增變數節點 |
| `Server.addObjectTypeNode(node)` | `node`: ObjectTypeNode | `bool` | 新增物件類型節點 |
| `Server.addMethodNode(node)` | `node`: MethodNode | `bool` | 新增方法節點 |
| `Server.addNamespace(namespace_name)` | `namespace_name`: string | `number`（命名空間索引） | 建立新的命名空間 |
| `Server.triggerEvent(...)` | 見下方 | `bool` | 觸發事件 |
| `Server.callMethodNode(method_node, inputs)` | `method_node`: MethodNode, `inputs`: Variant[] | `Variant[]` | 呼叫方法節點 |

#### `Server.triggerEvent` 參數

| 參數 | 型別 | 說明 |
|------|------|------|
| event_type_node | ObjectTypeNode | 事件類型 |
| event_origin_node | Node | 事件來源節點 |
| severity | number | 緊急程度 1–1000（1 最低、1000 最高） |
| event_msg | string | 事件描述 |
| event_src | string | 來源描述 |

### 13.3 NodeId 物件

用於唯一識別 OPC UA 伺服器位址空間中的節點。

| 建構函式 | 參數 | 說明 |
|----------|------|------|
| `NodeId.newString(identifier_string, namespace)` | string, number | 建立字串型 NodeId |
| `NodeId.newNumeric(identifier, namespace)` | number, number | 建立數值型 NodeId |
| `NodeId.newGUID(guid_identifier, namespace)` | string, number | 建立 GUID 型 NodeId |
| `NodeId.newBytestring(bytestring_identifier, namespace)` | string, number | 建立位元組串型 NodeId |

> 非預設命名空間需先透過 `Server.addNamespace()` 建立。

### 13.4 Variant 物件

Variant 是 OPC UA 內建資料型別的容器，用於方法節點的輸入和輸出值。

#### 建構函式

```lua
local v = Variant.new(DataType.INT32)
```

#### 方法

| 方法 | 參數 | 回傳值 | 說明 |
|------|------|--------|------|
| `Variant:isEmpty()` | 無 | boolean | 檢查是否無值 |
| `Variant:isScalar()` | 無 | boolean | 檢查是否為純量值 |
| `Variant:hasScalarType(type)` | DataType | boolean | 檢查是否為指定型別的純量值 |
| `Variant:hasArrayType(type)` | DataType | boolean | 檢查是否為指定型別的陣列 |
| `Variant:setScalar(value)` | string/number/boolean | 無 | 設定純量值 |
| `Variant:setArray(value, shape)` | 陣列, number[]（選用） | 無 | 設定陣列值；`shape` 省略時為一維 |
| `Variant:getScalar()` | 無 | string/number/boolean | 取得純量值 |
| `Variant:getArray()` | 無 | 陣列 | 取得陣列值 |
| `Variant:getArrayShape()` | 無 | number[] 或 nil | 取得陣列維度 |

### 13.5 ObjectNode 物件

| 函式 | 參數 | 回傳值 | 說明 |
|------|------|--------|------|
| `ObjectNode.newFolder(node_name, namespace, parent_node)` | string, number, NodeId | ObjectNode | 建立資料夾型物件節點 |
| `ObjectNode.newRootFolder(node_name, namespace)` | string, number | ObjectNode | 建立根資料夾型物件節點（父節點為 Objects 資料夾） |

#### 方法

| 方法 | 參數 | 說明 |
|------|------|------|
| `ObjectNode:setEventNotifier(is_event_notifier)` | boolean | 設為 `true` 以啟用事件產生 |

### 13.6 VariableNode 物件

#### 建構函式

```lua
local vn = VariableNode.new(node_id, node_name, parent_node, value, access_level)
```

| 參數 | 型別 | 說明 |
|------|------|------|
| node_id | NodeId | 變數節點的 NodeId |
| node_name | string | 節點名稱 |
| parent_node | NodeId | 父節點的 NodeId |
| value | Variant | 定義節點值和資料型別的 Variant 物件 |
| access_level | number | 存取層級（見 AccessLevel 列舉） |

#### 方法

| 方法 | 參數 | 回傳值 | 說明 |
|------|------|--------|------|
| `VariableNode:setValue(variant)` | Variant | boolean | 更新節點值 |
| `VariableNode:getValue()` | 無 | Variant | 從 OPC UA 伺服器取得節點值 |

### 13.7 ObjectTypeNode 物件

```lua
local otn = ObjectTypeNode.new(node_id, node_name, parent_node)
```

| 參數 | 型別 | 說明 |
|------|------|------|
| node_id | NodeId | 物件類型節點的 NodeId |
| node_name | string | 節點名稱 |
| parent_node | NodeId | 父節點的 NodeId |

### 13.8 MethodNode 物件

#### 建構函式

```lua
local mn = MethodNode.new(node_name, namespace, parent_node, method_callback, method_inputs, method_outputs)
```

| 參數 | 型別 | 說明 |
|------|------|------|
| node_name | string | 節點名稱 |
| namespace | number | 命名空間 |
| parent_node | NodeId | 父節點的 NodeId |
| method_callback | function | 方法被呼叫時執行的回呼函式 |
| method_inputs | Argument[] | 描述輸入參數的陣列 |
| method_outputs | Argument[] | 描述輸出參數的陣列 |

#### 回呼函式簽章

```lua
function callbackMethod(inputs, outputs)
  -- inputs: Variant[] — 輸入變體陣列
  -- outputs: Variant[] — 輸出變體陣列
end
```

### 13.9 Argument 物件

用於定義方法節點的輸入和輸出參數。

| 建構函式 | 參數 | 說明 |
|----------|------|------|
| `Argument.new(name, data_type_node_id, value_rank, array_dimensions)` | string, NodeId, number, number[] | 使用自訂資料型別建立 |
| `Argument.newStandardType(name, data_type, value_rank, array_dimensions)` | string, DataType, number, number[] | 使用內建 OPC UA 資料型別建立 |

`array_dimensions` 可為空陣列或 nil。

### 13.10 列舉型別

#### DataType

| 值 | 說明 |
|------|------|
| `DataType.BOOL` | 布林 |
| `DataType.SBYTE` | 有號位元組 |
| `DataType.BYTE` | 無號位元組 |
| `DataType.INT16` | 16 位元有號整數 |
| `DataType.UINT16` | 16 位元無號整數 |
| `DataType.INT32` | 32 位元有號整數 |
| `DataType.UINT32` | 32 位元無號整數 |
| `DataType.INT64` | 64 位元有號整數 |
| `DataType.UINT64` | 64 位元無號整數 |
| `DataType.FLOAT` | 單精度浮點數 |
| `DataType.DOUBLE` | 雙精度浮點數 |
| `DataType.STRING` | 文字字串 |
| `DataType.DATETIME` | 日期時間 |

#### AccessLevel

值可透過位元或運算（`|`）組合。

| 值 | 說明 |
|------|------|
| `AccessLevel.READ` | 允許讀取 |
| `AccessLevel.WRITE` | 允許寫入 |
| `AccessLevel.HISTORYREAD` | 允許讀取歷史資料 |
| `AccessLevel.HISTORYWRITE` | 允許寫入歷史資料 |
| `AccessLevel.SEMANTICCHANGE` | 允許語意變更通知 |
| `AccessLevel.STATUSWRITE` | 允許寫入狀態 |
| `AccessLevel.TIMESTAMPWRITE` | 允許寫入時間戳記 |

#### ValueRank

| 值 | 說明 |
|------|------|
| `ValueRank.SCALAR_OR_ONE_DIMENSION` | 純量或一維 |
| `ValueRank.ANY` | 任意 |
| `ValueRank.SCALAR` | 純量 |
| `ValueRank.ONE_OR_MORE_DIMENSIONS` | 一維或多維 |
| `ValueRank.ONE_DIMENSION` | 一維 |
| `ValueRank.TWO_DIMENSIONS` | 二維 |
| `ValueRank.THREE_DIMENSIONS` | 三維 |
