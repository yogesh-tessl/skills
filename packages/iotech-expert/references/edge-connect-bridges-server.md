<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/bridge-components/mqtt-bridge-component.html
    - https://docs.iotechsys.com/edge-xrt22/bridge-components/redis-bridge-component.html
    - https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html
    - https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-information-modelling.html
    - https://docs.iotechsys.com/edge-xrt22/transform-components/lua-transform-component.html
    - https://docs.iotechsys.com/edge-xrt22/core-components/bus-component.html
    - https://docs.iotechsys.com/edge-xrt22/core-components/logger-component.html
    - https://docs.iotechsys.com/edge-xrt22/core-components/scheduler-component.html
    - https://docs.iotechsys.com/edge-xrt22/core-components/config-component.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — Bridge、Server、Transform、Core 元件參考

## 目錄

- [1. Bridge 元件](#1-bridge-元件)
  - [1.1 MQTT Bridge](#11-mqtt-bridge)
  - [1.2 Redis Bridge](#12-redis-bridge)
- [2. Server 元件](#2-server-元件)
  - [2.1 OPC UA Server 元件總覽](#21-opc-ua-server-元件總覽)
  - [2.2 OPC UA Server 資訊模型（Information Modelling）](#22-opc-ua-server-資訊模型information-modelling)
  - [2.3 OPC UA Server 組態參考（Configuration Reference）](#23-opc-ua-server-組態參考configuration-reference)
- [3. Transform 元件](#3-transform-元件)
  - [3.1 Lua Transform](#31-lua-transform)
- [4. Core 元件](#4-core-元件)
  - [4.1 Bus](#41-bus)
  - [4.2 Logger](#42-logger)
  - [4.3 Scheduler](#43-scheduler)
  - [4.4 ThreadPool](#44-threadpool)
  - [4.5 Config](#45-config)

---

## 1. Bridge 元件

Bridge 元件的功能是將 Bus 延伸到多個節點之間，透過外部訊息中介（MQTT 或 Redis）實現跨節點的發布/訂閱。

### 1.1 MQTT Bridge

MQTT Bridge 將本地 Bus 上訂閱的主題透過 MQTT 客戶端重新發布到另一個節點的 Bus，實現跨節點通訊。

#### 1.1.1 MQTT Bridge 組態參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Bus | String | Bus 元件名稱 | 既有的 Bus 元件名稱 | Y |
| Logger | String | Logger 元件名稱 | 既有的 Logger 元件名稱 | N |
| QueueSize | Unsigned Integer | 訂閱者訊息佇列大小 | 預設：4 | N |
| Cookie | Integer | 訂閱者 Cookie 值 | 有效的 Cookie | N |
| Patterns | Array of Strings | Bus 訂閱模式 | 主題匹配模式 | Y |
| MQTTPatterns | Array of Strings | MQTT 訂閱模式 | 主題匹配模式 | Y |
| Compress | Array of Objects | MQTT 主題壓縮設定 | 僅支援 `gzip` | N |
| MQTTConfig | Object | MQTT 連線組態 | 見下方 MQTT 組態表 | Y |

#### 1.1.2 MQTT 連線組態（MQTTConfig）

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| ServerURI | String | MQTT 伺服器 URI | MQTT 伺服器位址 | Y |
| ClientID | String | MQTT 客戶端識別名稱 | 客戶端識別碼 | Y |
| QoS | Unsigned Integer | 服務品質等級 | 0（預設）、1、2 | N |
| ClientConfig | Object | 客戶端組態 | 見下方客戶端組態表 | N |

#### 1.1.3 MQTT 客戶端組態（ClientConfig）

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| KeepAliveInterval | Unsigned Integer | 最大閒置時間（秒） | 預設：60 | N |
| CleanSession | Boolean | 斷線時捨棄狀態 | true、false（預設） | N |
| Username | String | 認證使用者名稱 | 有效的使用者名稱 | N |
| Password | String | 認證密碼 | 有效的密碼 | N |
| ConnectTimeout | Unsigned Integer | 連線逾時（秒） | 預設：0（永不逾時） | N |
| DisconnectTimeout | Unsigned Integer | 斷線逾時（毫秒） | 預設：0 | N |
| MQTTVersion | Unsigned Integer | MQTT 協定版本 | 0（預設）、4、5 | N |
| SSLConfig | Object | SSL 組態 | 見下方 SSL 組態表 | N |
| CleanStart | Boolean | 啟動時清除會話狀態（僅 v5） | 預設：false | N |
| SessionExpiry | Unsigned Integer | 會話過期時間（秒，僅 v5） | 預設：0 | N |
| RetryInterval | Unsigned Integer | 發布重試間隔（秒） | 預設：0 | N |
| MinRetryInterval | Unsigned Integer | 最小重連重試間隔（秒），每次失敗加倍 | 預設：1 | N |
| MaxRetryInterval | Unsigned Integer | 最大重連重試間隔（秒） | 預設：60 | N |
| MaxBufferedMessages | Unsigned Integer | 最大緩衝訊息數，必須大於 0 | 預設：10 | N |

#### 1.1.4 MQTT SSL 組態（SSLConfig）

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| SSLVersion | Unsigned Integer | SSL/TLS 版本 | 3（TLS 1.2，預設） | N |
| EnableServerCertAuth | Boolean | 驗證伺服器憑證 | true（預設）、false | N |
| TrustStore | String | 受信任 CA 憑證（PEM 格式） | 有效的 PEM 憑證路徑 | N |
| KeyStore | String | 客戶端憑證鏈（PEM 格式） | 有效的 PEM 憑證鏈路徑 | N |
| PrivateKey | String | 客戶端私鑰（PEM 格式） | 有效的 PEM 私鑰路徑 | N |
| PrivateKeyPasswd | String | 私鑰密碼 | 有效的密碼 | N |
| EnabledCipherSuites | String | SSL 握手的加密套件 | 預設：ALL（見 OpenSSL 加密列表） | N |

> **注意**：僅支援 TLS v1.2。SSLv2、SSLv3、TLS 1.0 與 TLS 1.1 已在 v2.2 移除。

#### 1.1.5 AWS 匯出組態範例

```json
{
  "MQTTConfig": {
    "ServerURI": "ssl://apuyluiqj895v-ats.iot.us-east-1.amazonaws.com:8883",
    "ClientID": "c-sdk-client-id",
    "MQTTInstance": 0,
    "QoS": 1,
    "ClientConfig": {
      "KeepAliveInterval": 10,
      "MQTTVersion": 4,
      "Reliable": true,
      "ConnectTimeout": 30,
      "CleanSession": 1,
      "SSLConfig": {
        "EnableServerCertAuth": true,
        "SSLVersion": 3,
        "TrustStore": "/xrt/examples/Exporters/mqtt/aws/rootCA1.pem",
        "KeyStore": "/xrt/examples/Exporters/mqtt/aws/34aa6e6a89-certificate.pem.crt",
        "PrivateKey": "/xrt/examples/Exporters/mqtt/aws/34aa6e6a89-private.pem.key",
        "EnabledCipherSuites": "ALL"
      }
    }
  }
}
```

#### 1.1.6 Azure 匯出組態範例

MQTT 組態：

- **ServerURI**：`ssl://<hubname>.azure-devices.net:8883`
- **ClientID**：裝置 ID（例：`test-azure-device`）

客戶端組態：

- **Username**：`<iot_hub>.azure-devices.net/<device-id>`
- **Password**：SAS 權杖（`SharedAccessSignature sr=<SAS>`）
- **MQTTVersion**：4

SSL 組態：

- **TrustStore**：`root.pem` 路徑（DigiCert Baltimore CyberTrust Root）

Bridge 組態：

- **Patterns**：`devices/<device-id>/messages/events/readpipe`
- **MQTTPatterns**：`devices/<device_id>/messages/devicebound/#`

#### 1.1.7 完整組態範例

```json
{
  "Patterns": [
    "xrt/devices/bacnet_ip/telemetry",
    "xrt/devices/bacnet_ip/reply",
    "xrt/devices/bacnet_ip/discovery"
  ],
  "MQTTPatterns": ["xrt/devices/bacnet_ip/request"],
  "Compress": [{"xrt/devices/bacnet_ip/telemetry": "gzip"}],
  "MQTTConfig": {
    "ServerURI": "tcp://127.0.0.1:1883",
    "ClientID": "mqtt_bridge",
    "MQTTInstance": 0,
    "QoS": 1,
    "ClientConfig": {
      "KeepAliveInterval": 0,
      "Reliable": true,
      "Username": "test",
      "Password": "test",
      "ConnectTimeout": 0,
      "MQTTVersion": 5,
      "SSLConfig": {
        "EnableServerCertAuth": true,
        "SSLVersion": 3,
        "TrustStore": "roots.pem",
        "KeyStore": "public_key.pem",
        "PrivateKey": "PEM format - private_key.pem",
        "EnabledCipherSuites": "ALL",
        "PrivateKeyPasswd": " "
      }
    }
  }
}
```

---

### 1.2 Redis Bridge

Redis Bridge 實現雙向資料流：將 Bus 上訂閱的主題發布到 Redis 伺服器，同時將 Redis 上的主題匯入回 Bus，允許與其他 Redis 應用程式交換資料。

#### 1.2.1 Redis Bridge 組態參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Bus | String | Bus 元件名稱 | 既有的 Bus 元件名稱 | Y |
| Logger | String | Logger 元件名稱 | 既有的 Logger 元件名稱 | N |
| QueueSize | Unsigned Integer | Bus 訂閱者佇列大小 | 預設：4 | N |
| Cookie | Integer | 訂閱者 Cookie 值 | 有效的 Cookie | N |
| RetryCount | Unsigned Integer | 最大重連嘗試次數 | 預設：5 | N |
| RetryInterval | Unsigned Integer | 重連間隔（秒） | 預設：1 | N |
| Patterns | Array of Strings | 要發布到 Redis 的 Bus 主題模式 | 主題匹配模式 | Y |
| RedisPatterns | Array of Strings | Redis 訂閱主題模式 | 主題匹配模式 | N |
| RedisConfig | Object | Redis 連線組態 | 見下方 Redis 組態表 | Y |

#### 1.2.2 Redis 連線組態（RedisConfig）

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| ServerAddress | String | Redis 伺服器位址 | 作用中的 Redis 伺服器位址 | Y |
| Port | Unsigned Integer | Redis 伺服器連接埠 | 預設：6379 | N |
| Username | String | 認證使用者名稱 | 預設：`default` | N |
| Password | String | 認證密碼 | 指定使用者的有效密碼 | N |

#### 1.2.3 Redis Bridge 組態範例

```json
{
  "Patterns": ["xrt/devices/test/data"],
  "RedisPatterns": ["xrt/devices/bridge/*"],
  "RedisConfig": {
    "ServerAddress": "127.0.0.1",
    "Port": 6379,
    "Username": "default",
    "Password": "foobared"
  }
}
```

此組態將匹配 `xrt/devices/test/data` 的 Bus 資料發布到 Redis，並訂閱 Redis 上匹配 `xrt/devices/bridge/*` 的主題匯入至 Bus。

---

## 2. Server 元件

### 2.1 OPC UA Server 元件總覽

OPC UA Server 元件作為裝置與感測器資料的統一存取點，整合 Xrt 裝置服務元件（如 Modbus），自動在伺服器命名空間中填充裝置資源的表示。

#### 2.1.1 支援的部署架構

1. **共置部署（Co-located）**：Server 與裝置服務在同一個 Xrt 實例中
2. **聯合部署（Federated）**：Server 在獨立的 Xrt 實例中，透過 MQTT 與多個裝置服務實例通訊

> 使用多個 Xrt 實例時，每個服務的主題名稱必須唯一。建議模式：`xrt/<node id>/<server id>/devices/<device service>/...`

#### 2.1.2 服務集（Service Set）支援

- Discovery
- SecureChannel
- Session
- NodeManagement
- View
- Attribute
- Method
- MonitoredItem
- Subscription

#### 2.1.3 安全策略（Security Policies）

- None
- Basic256
- Basic128Rsa15
- Basic256Sha256
- Aes128Sha256RsaOaep

#### 2.1.4 使用者認證方式

- 匿名（Anonymous）
- 使用者名稱/密碼（Username/Password）
- X.509 憑證（X.509 Certificate）

#### 2.1.5 元件功能

- **OPC UA Nodeset 載入器**：透過 XML Nodeset 定義自訂位址空間
- **資訊對映（Information Mapping）**：將節點值對映至裝置服務資源
- **PubSub 支援**：可透過元件組態啟用
- **遙測監控**：利用裝置服務遙測主題最佳化讀取請求；當 Server 從遙測訊息收到資源值更新時，會在設定時間內使用此值回應後續讀取請求

#### 2.1.6 裝置服務組態參數

這些參數設定在裝置服務的組態檔中，而非 OPC UA Server 組態中。

| 欄位 | 型別 | 說明 | 必填 | 預設 |
|------|------|------|------|------|
| OPCUAServerRequestTimeout | UInt32 | 請求逾時（毫秒） | N | 3000 |
| OPCUAServerUseTelemetryValues | Boolean | 啟用遙測值讀取 | N | True |
| OPCUAServerStaleTelemetryValueTime | UInt64 | 遙測值有效期（毫秒） | N | 15000 |
| OPCUAServerTopicMiddlewarePrefix | String | 訂閱/發布的主題前綴 | N | — |
| OPCUAServerUseMiddlewarePrefixRequest | Boolean | 為 Request 主題加前綴 | N | True |
| OPCUAServerUseMiddlewarePrefixReply | Boolean | 為 Reply 主題加前綴 | N | True |
| OPCUAServerUseMiddlewarePrefixTelemetry | Boolean | 為 Telemetry 主題加前綴 | N | True |
| OPCUAServerUseMiddlewarePrefixEvent | Boolean | 為 Event 主題加前綴 | N | True |
| OPCUAServerUseMiddlewarePrefixEdgeXEvent | Boolean | 為 EdgeX Event 主題加前綴 | N | True |
| OPCUAServerEdgeXEventTopicBase | String | EdgeX Event 主題基底 | N | edgex |

#### 2.1.7 聯合部署的 MQTT 需求

**Server 實例需要：**

- 發布：裝置服務與 Command 元件的 Request 主題
- 接收：Command 元件的 Reply/Discovery 主題、裝置服務的 Reply/Telemetry/Event 主題

**裝置服務實例需要：**

- 接收：裝置服務與 Command 元件的 Request 主題
- 發布：Command 元件的 Reply/Discovery 主題、裝置服務的 Reply/Telemetry/Event 主題

所有實例都需要 Command 元件與 MQTT Bridge 元件，且主題組態必須對齊。

#### 2.1.8 預設連接埠

4840（OPC UA 標準埠）

#### 2.1.9 伺服器結構

Xrt 實例組織在伺服器根目錄的 `XRTInstances` 物件資料夾下，階層為：Instance → DeviceServices → Devices → Resources。

---

### 2.2 OPC UA Server 資訊模型（Information Modelling）

OPC UA Server 支援透過 OPC Foundation 規範的 Information Model XML Schema（Nodeset）建立自訂位址空間，並透過 JSON 對映檔將節點值對映至 Xrt 資源。

#### 2.2.1 節點對映檔格式

| 屬性 | 型別 | 說明 |
|------|------|------|
| mappings | Array | 節點對映物件列表 |
| nodeIdentifier | String 或 Object | 使用 NodeId 或 BrowsePath 識別 OPC UA 節點 |
| valueMapping | Object | 將節點對映至 Xrt 資源 |
| namespaceUris | Array | 命名空間 URI 列表 |

#### 2.2.2 ValueMapping 屬性

| 屬性 | 型別 | 說明 |
|------|------|------|
| serverId | String | 伺服器識別碼 |
| deviceService | String | 裝置服務名稱 |
| device | String | 裝置識別碼 |
| resource | String | 資源名稱 |

#### 2.2.3 節點識別碼格式

**格式 1 — NodeId 字串：**

```json
{
  "nodeIdentifier": "s=Temperature"
}
```

**格式 2 — BrowsePath 物件：**

```json
{
  "nodeIdentifier": {
    "StartingNode": "i=85",
    "RelativePath": "/0:Temperature"
  }
}
```

> `nodeIdentifier` 的命名空間索引參考 `namespaceUris` 欄位，使用從 1 開始的索引。索引 0 保留給 OPC UA 基礎命名空間。

#### 2.2.4 Nodeset XML 範例

```xml
<?xml version="1.0" encoding="utf-8" ?>
<UANodeSet xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           LastModified="2019-05-01T00:00:00Z"
           xmlns="http://opcfoundation.org/UA/2011/03/UANodeSet.xsd">
  <NamespaceUris>
    <Uri>http://opcfoundation.org/UA/</Uri>
  </NamespaceUris>
  <Aliases>
    <Alias Alias="UInt32">i=7</Alias>
    <Alias Alias="Organizes">i=35</Alias>
    <Alias Alias="HasTypeDefinition">i=40</Alias>
  </Aliases>
  <UAVariable NodeId="s=Temperature" BrowseName="Temperature"
              ParentNodeId="i=85" DataType="UInt32">
    <References>
      <Reference ReferenceType="HasTypeDefinition">i=63</Reference>
      <Reference ReferenceType="Organizes" IsForward="false">i=85</Reference>
    </References>
  </UAVariable>
</UANodeSet>
```

此範例在 Server 的 Objects 節點（`i=85`）下建立一個 UInt32 型別的變數節點（`s=Temperature`）。

#### 2.2.5 完整對映組態範例

```json
{
  "mappings": [
    {
      "nodeIdentifier": "s=Temperature",
      "valueMapping": {
        "serverId": "example-server",
        "deviceService": "virtual",
        "device": "example-device",
        "resource": "Temperature"
      }
    }
  ],
  "namespaceUris": [
    "http://sample.com/ExampleNamespace"
  ]
}
```

載入 Nodeset 與對映檔到 Server 後，對該節點的請求會直接對映至指定資源。

---

### 2.3 OPC UA Server 組態參考（Configuration Reference）

#### 2.3.1 OPCUAServerConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| Library | String | 動態連結共享函式庫，限定為 `libxrt-opc-ua-server.so` | N |
| Factory | String | 元件實例化 C 函式，限定為 `xrt_opc_ua_server_factory` | N |
| ApplicationUri | String | 伺服器全域唯一識別碼（預設：`urn:iotechsys:xrt`） | N |
| ApplicationName | String | 應用程式名稱 | N |
| Port | UInt16 | 伺服器連接埠（預設：4840） | N |
| SecurityPolicies | OPCUAServerSecurityPolicy[] | 安全策略組態，預設為 None | N |
| Endpoints | OPCUAServerEndpoint[] | 端點組態，預設為單一 None 策略 | N |
| AccessControl | OPCUAServerAccessControl | 會話認證與存取權限組態 | N |
| CertificateVerification | OPCUAServerCertificateVerification | X509 憑證驗證設定 | N |
| PubSub | OPCUAServerPubSubConfig | 發布/訂閱模組組態 | N |
| NodesetPaths | String[] | OPC UA Nodeset XML 檔案路徑 | N |
| MappingPaths | String[] | 節點對映 JSON 檔案路徑 | N |
| Bus | String | Bus 元件名稱 | Y |
| Logger | String | Logger 元件名稱 | N |
| ThreadPool | String | ThreadPool 元件名稱 | Y |

#### 2.3.2 OPCUAServerAccessControl

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| AllowAnonymous | Boolean | 允許匿名登入 | N |
| EnableX509 | Boolean | 啟用 X509 憑證認證 | N |
| AccessControlUserPassList | Map\<String\> | 使用者名稱:密碼存取控制清單 | N |

#### 2.3.3 OPCUAServerCertificateVerification

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| TrustList | String[] | 用於信任判定的憑證 | N |
| IssuerList | String[] | 用於鏈驗證的 CA 憑證 | N |
| RevocationList | String[] | 已撤銷的憑證 | N |

#### 2.3.4 OPCUAServerEndpoint

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| SecurityPolicy | OPCUASecurityPolicyType | 端點安全策略（必須存在於組態中） | Y |
| DiscoveryOnly | Boolean | 限制為僅探索服務，僅適用於 None 策略（預設：false） | N |
| MessageSecurityModes | OPCUAMessageSecurityMode[] | 支援的安全模式（預設為 None） | N |
| X509SecurityPolicy | OPCUASecurityPolicyType | 覆寫 X509 憑證認證的策略 | N |
| UserPassSecurityPolicy | OPCUASecurityPolicyType | 覆寫使用者名稱/密碼認證的策略 | N |

#### 2.3.5 OPCUAMessageSecurityMode

支援值：`None`、`Sign`、`SignEncrypt`

#### 2.3.6 OPCUAServerSecurityPolicy

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| SecurityPolicy | OPCUASecurityPolicyType | 設定的策略名稱 | Y |
| Certificate | String | 憑證路徑（非 None 策略必填） | N |
| PrivateKey | String | 對應私鑰路徑（非 None 策略必填） | N |

#### 2.3.7 OPCUASecurityPolicyType

支援值：`None`、`Basic256`、`Basic128Rsa15`、`Basic256Sha256`、`Aes128Sha256RsaOaep`

#### 2.3.8 OPCUAServerNodeMappingsConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| mappings | OPCUAServerNodeMappingDescription[] | 資源到節點的對映列表 | Y |
| namespaceUris | String[] | 參考的命名空間 URI | N |

#### 2.3.9 OPCUAServerNodeMappingDescription

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| nodeIdentifier | NodeId 或 BrowsePath | 目標節點識別碼 | Y |
| valueMapping | OPCUAServerNodeValueMapping | 值對映描述 | Y |

#### 2.3.10 OPCUAServerNodeValueMapping

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| serverId | String | Xrt 實例識別碼 | Y |
| deviceService | String | 裝置服務名稱 | Y |
| device | String | 服務中的裝置名稱 | Y |
| resource | String | Xrt 資源名稱 | Y |

#### 2.3.11 OPCUAServerPubSubConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| TransportLayers | OPCUAServerPubSubTransportLayer[] | 傳輸層列表 | Y |
| Connections | OPCUAServerPubSubConnection[] | 連線組態 | Y |
| WriterGroupsFilePath | String | WriterGroups 組態檔路徑 | N |
| DataSetWritersFilePath | String | DataSetWriters 組態檔路徑 | N |
| DataSetsFilePath | String | DataSets 組態檔路徑 | N |

#### 2.3.12 OPCUAServerPubSubConnection

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| Name | String | 連線名稱 | Y |
| TransportProfileType | OPCUAServerPubSubTransportLayer | 使用的傳輸層 | Y |
| Address | String | 連線位址 | Y |
| PublisherId | UInt32 | 發布者識別碼 | Y |
| Interface | String | 網路介面（Ethernet 傳輸必填） | N |

#### 2.3.13 OPCUAServerPubSubTransportLayer

支援值：`UDP`、`Ethernet`

#### 2.3.14 OPCUAServerPubSubDatasetConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| datasets | OPCUAServerPubSubDataset[] | 資料集組態列表 | Y |

#### 2.3.15 OPCUAServerPubSubDataset

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| name | String | 資料集名稱 | Y |
| fields | OPCUAServerPubSubDatasetField[] | 欄位組態列表 | Y |

#### 2.3.16 OPCUAServerPubSubDatasetField

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| name | String | 資料集欄位名稱 | N |
| identifier | NodeId 或 BrowsePath | OPC UA 節點識別 | N |

#### 2.3.17 OPCUAServerPubSubDatasetWritersConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| datasetWriters | OPCUAServerPubSubDatasetWriter[] | DatasetWriter 組態列表 | Y |

#### 2.3.18 OPCUAServerPubSubDatasetWriter

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| name | String | DatasetWriter 名稱 | Y |
| id | UInt16 | 唯一 DatasetWriter 識別碼 | Y |
| writerGroup | String | 附屬的 WriterGroup 名稱 | N |
| dataset | String | 發布的 DataSet 名稱 | N |

#### 2.3.19 OPCUAServerPubSubWriterGroupsConfig

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| writerGroups | OPCUAServerPubSubWriterGroup[] | WriterGroup 組態列表 | Y |

#### 2.3.20 OPCUAServerPubSubWriterGroup

| 欄位 | 型別 | 說明 | 必填 |
|------|------|------|------|
| name | String | WriterGroup 名稱 | Y |
| id | UInt16 | 唯一 WriterGroup 識別碼 | Y |
| encodingType | OPCUAServerPubSubEncodingType | 訊息編碼格式 | Y |
| connection | String | 附屬的連線名稱 | Y |
| publishingInterval | Float64 | 發布間隔（毫秒） | N |

#### 2.3.21 OPCUAServerPubSubEncodingType

支援值：`json`、`uadp`

> **重要提示**：多個端點可共用單一 SecurityPolicy 搭配不同的 MessageSecurityModes。Certificate 與 PrivateKey 路徑對所有非 None 安全策略為必填。Bus 與 ThreadPool 為必填參數。

---

## 3. Transform 元件

### 3.1 Lua Transform

Lua Transform 元件提供嵌入式 Lua 指令碼引擎，具備 Edge Xrt 專用函式，可用於資料轉換、發布與排程。

#### 3.1.1 組態參數

| 參數 | 型別 | 必填 | 說明 |
|------|------|------|------|
| Bus | String | Y | Bus 元件名稱 |
| Scheduler | String | Y | Scheduler 元件名稱 |
| ThreadPool | String | Y | ThreadPool 元件名稱 |
| Logger | String | N | Logger 元件名稱 |
| ScriptFile | String | N | Lua 指令碼檔案路徑 |
| Script | Base64 String | N | Base64 編碼的 Lua 指令碼 |
| ForceGC | Boolean | N | 回呼後觸發 Lua 垃圾回收；預設：Azure Sphere 為 true，其他為 false |

> `ScriptFile` 與 `Script` 擇一設定。若兩者皆設定，`Script` 優先。若兩者皆未設定，元件啟動但不執行任何操作，直到重新設定。

#### 3.1.2 Xrt 專用 Lua 函式

**pub_alloc(Bus, topic)**

| 參數 | 說明 |
|------|------|
| Bus | Bus 元件參考（全域變數 `iot_bus`） |
| topic | 發布主題字串 |
| 回傳值 | 代表發布者的 Lua 物件 |

**sub_alloc(Bus, callback, match)**

| 參數 | 說明 |
|------|------|
| Bus | Bus 元件參考（全域變數 `iot_bus`） |
| callback | 匹配資料發布時呼叫的 Lua 函式，接收事件資料表與匹配主題字串 |
| match | 事件主題匹配模式字串 |
| 回傳值 | 代表訂閱者的 Lua 物件 |

**pub_free(pub)**：釋放 `pub_alloc` 建立的發布者物件

**sub_free(sub)**：釋放 `sub_alloc` 建立的訂閱者物件

**publish(pub, data)**

| 參數 | 說明 |
|------|------|
| pub | `pub_alloc` 建立的發布者物件 |
| data | 要發布的 Lua 值 |

**schedule_create(scheduler, callback, arg, period, delay, repeat_counter)**

| 參數 | 必填 | 說明 |
|------|------|------|
| scheduler | Y | Scheduler 元件參考（全域變數 `xrt_lua`） |
| callback | Y | 排程觸發時呼叫的函式 |
| arg | Y | 傳遞給回呼函式的引數 |
| period | Y | 排程週期（毫秒） |
| delay | N | 首次觸發前延遲（毫秒），預設：0 |
| repeat | N | 重複次數，預設：0（無限） |

**schedule_free(sch)**：釋放 `schedule_create` 建立的排程物件

#### 3.1.3 組態範例

```json
{
  "Bus": "bus",
  "Scheduler": "sched",
  "ThreadPool": "pool",
  "Logger": "logger",
  "ScriptFile": "deployment/config/script.lua"
}
```

#### 3.1.4 Lua 指令碼範例

```lua
local local_data = {}

function sub_callback (data)
  data.readings.Comment = {}
  data.readings.Comment.value = "Sample Lua Value Injection"
  data.readings.Comment.type = "string"
  publish (pub, data)
end

function sch_callback (data_cb)
  print ("In sch_callback:", data_cb, local_data)
end

sub = sub or sub_alloc (iot_bus, sub_callback, "xrt/devices/bacnet/data")
pub = pub or pub_alloc (iot_bus, "xrt/devices/bacnet/data2")
sch = sch or schedule_create (xrt_lua, sch_callback, local_data, 1000, 500, 6)
```

此範例訂閱 BACnet 遙測資料，注入合成讀數，重新發布到不同主題，並建立排程回呼。

---

## 4. Core 元件

### 4.1 Bus

Bus 元件是 Edge Xrt 框架的核心，實作主題式發布/訂閱機制，用於解耦資料發布者與訂閱者。主題命名遵循 MQTT 命名與匹配慣例。

#### 4.1.1 主要功能

- **主題式訊息傳遞**：使用 MQTT 命名慣例的具名主題
- **執行緒池關聯**：主題可連結至執行緒池，支援執行緒優先順序與處理器親和性
- **資料保留**：主題可透過組態保存最後發布的值
- **訂閱者彈性**：支援同步輪詢、回呼函式註冊、最大佇列長度設定
- **啟用/停用**：發布者與訂閱者可暫時停用

#### 4.1.2 Bus 組態參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Logger | String | Logger 元件名稱 | 既有的 Logger 元件名稱 | N |
| Scheduler | String | Scheduler 元件名稱 | 既有的 Scheduler 元件名稱 | 同步模式 N；非同步模式 Y |
| Topics | Array | 初始化時建立的主題參數 | 見下方主題參數表 | N |

#### 4.1.3 主題參數（Topics）

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Topic | String | 主題名稱 | 有效的 MQTT 主題名稱 | Y |
| Priority | Integer | 主題優先順序 | 系統相依（Linux：1-100，1 最低，100 最高）；預設：IOT_THREAD_NO_PRIORITY | N |
| Retain | Boolean | 保留主題最後一個值 | true、false（預設） | N |
| ThreadPool | String | ThreadPool 元件名稱 | 既有的 ThreadPool 元件名稱 | N |
| Sync | Boolean | 所有發布均為同步 | true、false（預設） | N |
| FilterDuplicates | Boolean | 過濾連續重複值（啟用 Retain） | true、false（預設） | N |

---

### 4.2 Logger

Logger 元件管理應用程式日誌，支援多個日誌等級與輸出目的地，可將日誌導向主控台、檔案或 UDP 通訊端。

#### 4.2.1 日誌等級

| 等級 | 用途 |
|------|------|
| Error | 需要調查的應用程式中斷事件 |
| Warning | 潛在有害、非預期的事件（預設） |
| Information | 正常運作中的高階進度事件 |
| Debug | 用於疑難排解的細粒度診斷資訊 |
| Trace | Debug 仍不足時的更精細詳情 |

#### 4.2.2 Logger 組態參數

| 參數 | 型別 | 必填 | 預設 | 有效值 | 說明 |
|------|------|------|------|--------|------|
| Name | String | Y | — | 任意字串 | 元件識別碼 |
| Level | String | N | Warn | Error、Warn、Info、Debug、Trace | 日誌閾值等級 |
| To | String | N | console | `console`、`file:<filename>`、`udp:<host>:<port>`、`udp:<port>`（廣播） | 日誌輸出目的地 |
| Next | String | N | — | Logger 或 Bus Logger 元件名稱 | 串接至另一個 Logger 元件 |
| Start | Boolean | N | true | true、false | 是否在配置時初始化 |

#### 4.2.3 Logger 組態範例

```json
{
  "Name": "file",
  "To": "file:./errors.log",
  "Level": "Warn"
}
```

> IOTech 建議將 `Start` 設為 `true` 以擷取初始化事件。可透過 `Next` 參數串接多個 Logger。UDP 廣播只需指定連接埠，不需主機。

---

### 4.3 Scheduler

Scheduler 元件管理排程工作，支援：指定開始時間、指定重複次數（預設無限重複）、指定重複間隔、選擇性設定優先順序。

專用排程執行緒負責處理排程。設定優先順序或處理器親和性時，元件使用 FIFO 排程策略的即時執行緒。

#### 4.3.1 Scheduler 組態參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Logger | String | Logger 元件名稱 | 既有的 Logger 元件名稱 | N |
| Priority | Integer | 排程執行緒優先順序 | 系統相依（Linux：1-100，1 最低，100 最高） | N |
| Affinity | Integer | 排程執行緒處理器親和性 | CPU 編號：0 到 n | N |

所有組態參數皆為選填。

#### 4.3.2 Scheduler 組態範例

```json
{
  "Affinity": 11,
  "Priority": 99,
  "Logger": "logger"
}
```

---

### 4.4 ThreadPool

ThreadPool 元件管理執行緒池，用於處理提交的工作。工作以佇列排隊處理，可設定上限。佇列達上限時，額外工作可被阻擋或以錯誤回傳拒絕。

#### 4.4.1 ThreadPool 組態參數

| 參數 | 型別 | 說明 | 有效值 | 必填 |
|------|------|------|--------|------|
| Logger | String | Logger 元件名稱 | 既有的 Logger 元件名稱 | N |
| Threads | Unsigned Integer | 池中執行緒數 | 預設：2 | N |
| MaxJobs | Unsigned Integer | 最大排隊工作數 | 預設：0（無限） | N |
| Priority | Integer | 執行緒優先順序 | 系統相依（Linux：1-100，1 最低，100 最高） | N |
| Affinity | Integer | CPU 處理器指定 | 0 到 n（CPU 編號） | N |
| ShutdownDelay | Unsigned Integer | 等待執行緒完成的最大時間（毫秒） | 預設：200 | N |

所有組態參數皆為選填。

#### 4.4.2 ThreadPool 組態範例

```json
{
  "Threads": 1,
  "MaxJobs": 10,
  "Affinity": 11,
  "Priority": 99,
  "Logger": "logger",
  "ShutdownDelay": 2000
}
```

---

### 4.5 Config

Config 元件支援 Xrt 實例的全域或共享組態變數，可透過直接組態或環境變數設定。

#### 4.5.1 Config 組態參數

| 參數 | 型別 | 說明 | 有效值 | 環境變數 | 必填 |
|------|------|------|--------|----------|------|
| ServerId | String | 實例識別碼 | 未指定時預設為自動產生的 UUID | XRT_SERVER_ID | N |
| NodeId | String | 節點識別碼 | 未設定時預設為空字串 | XRT_NODE_ID | N |
| Timeout | Unsigned Integer | 伺服器逾時（秒，關機前倒數） | 預設：0（持續運作） | XRT_SERVER_TIMEOUT | N |

所有參數皆為選填，具有合理預設值。

#### 4.5.2 Config 組態範例

```json
{
  "ServerId": "bacnet-ip-server",
  "NodeId": "linux-1",
  "Timeout": 4
}
```
