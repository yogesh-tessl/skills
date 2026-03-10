<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/bacnet-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/device-service-component-details/bacnet-device-service-component-details.html
    - https://docs.iotechsys.com/edge-xrt22/simulators/bacnet/overview.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — BACnet Device Service 完整指南

## 目錄

- [1. 概述](#1-概述)
- [2. BACnet/IP 驅動選項](#2-bacnetip-驅動選項)
- [3. BACnet/MSTP 驅動選項](#3-bacnetmstp-驅動選項)
- [4. 裝置描述檔屬性](#4-裝置描述檔屬性)
- [5. 支援的資料型別](#5-支援的資料型別)
- [6. 裝置佈建範例](#6-裝置佈建範例)
  - [6.1 BACnet/IP](#61-bacnetip)
  - [6.2 BACnet/MSTP](#62-bacnetmstp)
- [7. 優先等級寫入](#7-優先等級寫入)
- [8. 值變化訂閱（COV）](#8-值變化訂閱cov)
- [9. 裝置探索](#9-裝置探索)
  - [9.1 探索選項](#91-探索選項)
  - [9.2 探索回應屬性](#92-探索回應屬性)
- [10. BACnet 物件清單與目的地](#10-bacnet-物件清單與目的地)
  - [10.1 接收者清單欄位](#101-接收者清單欄位)
  - [10.2 接收者位址選項](#102-接收者位址選項)
- [11. BACnet 事件](#11-bacnet-事件)
  - [11.1 事件欄位](#111-事件欄位)
  - [11.2 事件資料類型](#112-事件資料類型)
- [12. Docker 部署 — BACnet/IP](#12-docker-部署--bacnetip)
  - [12.1 Host 網路模式](#121-host-網路模式)
  - [12.2 Macvlan 網路模式](#122-macvlan-網路模式)
  - [12.3 搭配模擬器使用](#123-搭配模擬器使用)
- [13. Docker 部署 — BACnet/MSTP](#13-docker-部署--bacnetmstp)
- [14. BACnet 模擬器](#14-bacnet-模擬器)
  - [14.1 環境變數與選項](#141-環境變數與選項)
  - [14.2 Docker 指令](#142-docker-指令)
  - [14.3 支援的 BACnet 物件類型](#143-支援的-bacnet-物件類型)
  - [14.4 網路組態](#144-網路組態)

---

## 1. 概述

BACnet Device Service 元件整合 BACnet 協定與 Edge Xrt，提供兩個變體：

- **BACnet/IP**：透過乙太網路通訊
- **BACnet/MSTP**：透過 RS-485 序列通訊

核心功能包含：裝置探索、值變化訂閱（Change of Value, COV）、屬性讀寫操作、批次操作。

---

## 2. BACnet/IP 驅動選項

| 參數 | 型別 | 說明 | 預設值 |
|------|------|------|--------|
| DeviceObject.InstanceID | UInt32 | BACnet 裝置實例 ID | 0 |
| DeviceObject.ObjectName | String | 裝置名稱 | "IOTech Edge Xrt BACnet Device Service Component" |
| DeviceObject.VendorID | UInt16 | 廠商識別碼 | 1313 |
| NetworkInterface | String | 通訊用網路介面 | 主要介面 |
| Port | UInt16 | 通訊埠 | 47808 |
| APDUTimeout | UInt32 | 已確認請求逾時（毫秒） | 3000 |
| APDURetries | UInt8 | 最大重試次數 | 3 |
| MultiBatchSize | UInt8 | 每次多重讀寫的最大屬性數 | 20 |
| MultiRead | Bool | 啟用多重屬性讀取 | true |
| MultiWrite | Bool | 啟用多重屬性寫入 | true |
| BBMDAddress | String | 外部裝置註冊位址 | 無 |
| BBMDPort | UInt16 | BBMD 註冊埠 | 47808 |
| BBMDTimeToLive | UInt16 | 註冊持續時間（秒） | 65535 |
| DiscoverMode | String | 屬性探索範圍 | "All" |
| DiscoveryDuration | UInt16 | Who-Is 廣播間隔（毫秒） | 3000 |
| DiscoveryRetries | UInt8 | 額外 Who-Is 廣播次數 | 1 |
| IAmBroadcastInterval | UInt16 | I-Am 廣播頻率（分鐘） | 30 |

---

## 3. BACnet/MSTP 驅動選項

BACnet/MSTP 與 BACnet/IP 共用大部分參數，主要差異如下：

| 參數 | 說明 | 預設值 |
|------|------|--------|
| SerialInterface | RS-485 連線路徑（**必填**） | 無 |
| APDUTimeout | 已確認請求逾時（毫秒） | **60000**（較 IP 長） |
| DiscoveryDuration | Who-Is 廣播間隔（毫秒） | **10000**（較 IP 長） |

---

## 4. 裝置描述檔屬性

| 屬性 | 是否必要 | 說明 | 有效值 |
|------|----------|------|--------|
| type | 是 | BACnet 物件類型 | UInt32 列舉 |
| instance | 是 | 物件實例編號 | UInt32 |
| property | 是 | BACnet 屬性類型 | UInt32 列舉 |
| index | 否 | 陣列索引 | UInt32 |
| raw | 否 | 讀寫完整 APDU | `true` / `false` |

---

## 5. 支援的資料型別

| BACnet 型別 | Xrt 型別 | 存取模式 |
|-------------|----------|----------|
| Boolean | Bool | RW |
| Unsigned Int | UInt64 | RW |
| Signed Int | Int32 | RW |
| Real | Float32 | RW |
| Double | Float64 | RW |
| Enumerated | UInt32 | RW |
| Character String | String | RW |
| Date | String | R（僅讀） |
| Bit String | UInt8Array | R（僅讀） |

---

## 6. 裝置佈建範例

### 6.1 BACnet/IP

```json
{
  "BacnetSimulator": {
    "name": "BacnetSimulator",
    "profileName": "bacnet-simulator",
    "protocols": {
      "BACnet-IP": {
        "DeviceInstance": 1234
      }
    }
  }
}
```

### 6.2 BACnet/MSTP

```json
{
  "BacnetSimulator": {
    "name": "BacnetSimulator",
    "profileName": "bacnet-simulator",
    "protocols": {
      "BACnet-MSTP": {
        "DeviceInstance": 1234
      }
    }
  }
}
```

---

## 7. 優先等級寫入

寫入操作支援優先等級指派（1–16）。範例：

```json
{
  "op": "device:put",
  "device": "BacnetSimulator",
  "values": {
    "analog_output_0:present-value": 33.0
  },
  "options": {
    "Priority": 2
  }
}
```

---

## 8. 值變化訂閱（COV）

靜態 COV 訂閱組態範例：

```json
{
  "cov0": {
    "name": "cov0",
    "device": "BacnetSimulator",
    "resource": ["analog_value_0:present-value"],
    "options": {
      "COV": {
        "Confirmed": false,
        "Lifetime": 600
      }
    }
  }
}
```

COV 選項說明：
- **Confirmed**：是否使用已確認通知（`true` / `false`）
- **Lifetime**：訂閱持續時間（秒）

---

## 9. 裝置探索

### 9.1 探索選項

| 參數 | 型別 | 說明 |
|------|------|------|
| DiscoveryDuration | UInt16 | 覆寫 Who-Is 廣播間隔 |
| DiscoveryRetries | UInt8 | 覆寫額外廣播次數 |
| DiscoveryDeviceRange | List[2] | 裝置實例範圍篩選 |
| Address | String | 直接 IP 探索（僅 BACnet/IP） |
| Port | UInt16 | 直接探索的裝置埠 |

### 9.2 探索回應屬性

探索回應中包含的屬性：

| 屬性 | 適用範圍 |
|------|----------|
| InstanceID | 全部 |
| Contactable | 全部 |
| DeviceType | 全部 |
| ApplicationSoftware | 全部 |
| Firmware | 全部 |
| ModelName | 全部 |
| ObjectName | 全部 |
| VendorID | 全部 |
| VendorName | 全部 |
| IP | 僅 BACnet/IP |
| Port | 僅 BACnet/IP |

---

## 10. BACnet 物件清單與目的地

### 10.1 接收者清單欄位

透過 `valueType: ObjectArray` 支援接收者清單（Recipient List）屬性（property 102）。

| 欄位 | 型別 | 預設值 | 說明 |
|------|------|--------|------|
| confirmed_notify | Bool | `false` | 是否使用已確認通知 |
| process_identifier | UInt32 | `0` | 流程識別碼 |
| recipient | Object | 無（必填） | 裝置識別碼、IP 位址或路由位址 |
| from_time | Object | 00:00:00.00 | 開始時間窗口 |
| to_time | Object | 23:59:59.00 | 結束時間窗口 |
| transitions | List | 全部 | 選項：`TO_OFFNORMAL`、`TO_FAULT`、`TO_NORMAL` |
| valid_days | List | 一週七天 | 有效星期 |

### 10.2 接收者位址選項

#### 裝置識別碼

```json
{"device_identifier": 101}
```

#### IP 位址

```json
{"address": {"ip": "192.168.1.128", "port": 47808}}
```

#### 路由位址

```json
{"address": {"routed": {"network_number": 242, "mac": "aa:bb:cc:dd:ee:ff"}}}
```

---

## 11. BACnet 事件

事件透過合成資源 `_EVENT`（`valueType: object`）發佈到 `TelemetryTopic`。

### 11.1 事件欄位

| 欄位 | 型別 | 說明 |
|------|------|------|
| initiating_object_identifier | Object | 發送事件的裝置物件 |
| event_object_identifier | Object | 發起事件的物件 |
| time_stamp | Object | 序號、時間或日期時間 |
| from_state | UInt8 | 轉換前狀態 |
| to_state | UInt8 | 轉換後狀態 |
| notify_type | UInt8 | 通知類型 |
| notification_class | UInt32 | 通知類別實例編號 |
| ack_required | Bool | 是否需要確認 |
| message_text | String | 事件描述 |
| priority | UInt8 | 優先等級 |
| process_identifier | UInt32 | 接收者流程處理碼 |
| event_data | Object | 事件特定資料（見下方） |

#### 狀態列舉值

| 值 | 常數 |
|------|------|
| 0 | EVENT_STATE_NORMAL |
| 1 | EVENT_STATE_FAULT |
| 2 | EVENT_STATE_OFFNORMAL |
| 3 | EVENT_STATE_HIGH_LIMIT |
| 4 | EVENT_STATE_LOW_LIMIT |

#### 通知類型列舉值

| 值 | 常數 |
|------|------|
| 0 | NOTIFY_ALARM |
| 1 | NOTIFY_EVENT |
| 2 | NOTIFY_ACK_NOTIFICATION |

### 11.2 事件資料類型

#### CHANGE_OF_BITSTRING

```json
{
  "change_of_bitstring": {
    "referenced_bitstring": "1010101101001",
    "status_flags": ["FAULT"]
  }
}
```

#### CHANGE_OF_STATE

```json
{
  "change_of_state": {
    "new_state": {"boolean_value": true},
    "status_flags": ["IN_ALARM"]
  }
}
```

#### CHANGE_OF_VALUE

```json
{
  "change_of_value": {
    "new_value": {"changed_value": 1.23},
    "status_flags": ["IN_ALARM"]
  }
}
```

#### COMMAND_FAILURE

```json
{
  "command_failure": {
    "command_value": {"unsigned_value": 448},
    "feedback_value": {"unsigned_value": 20},
    "status_flags": ["OUT_OF_SERVICE"]
  }
}
```

#### FLOATING_LIMIT / OUT_OF_RANGE / UNSIGNED_RANGE / DOUBLE_OUT_OF_RANGE / SIGNED_OUT_OF_RANGE / UNSIGNED_OUT_OF_RANGE

均包含數值閾值和狀態旗標。

#### CHANGE_OF_LIFE_SAFETY

```json
{
  "change_of_life_safety": {
    "new_mode": 5,
    "new_state": 2,
    "operation_expected": 4,
    "status_flags": ["OVERRIDDEN"]
  }
}
```

#### BUFFER_READY

包含緩衝區屬性識別碼和通知計數器。

#### ACCESS_EVENT

包含憑證、事件類型、時間和驗證因子（base64 編碼）。

#### CHANGE_OF_CHARACTERSTRING

```json
{
  "change_of_characterstring": {
    "alarm_value": "text",
    "changed_value": "text",
    "status_flags": ["OVERRIDDEN"]
  }
}
```

#### CHANGE_OF_TIMER

包含逾時值、狀態轉換和日期時間資訊。

#### 目前不支援的事件類型

`EXTENDED`、`CHANGE_OF_STATUS_FLAGS`、`CHANGE_OF_RELIABILITY`、`CHANGE_OF_DISCRETE_VALUE`

---

## 12. Docker 部署 — BACnet/IP

映像檔：`iotechsys/xrt:2.2`

### 12.1 Host 網路模式

```bash
docker run --rm --name xrt-bacnet-ip \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network host \
  iotechsys/xrt:2.2 [time_in_seconds]
```

Host 模式允許 BACnet/IP Device Service 看到與主機相同子網路上的本地 BACnet 裝置。

### 12.2 Macvlan 網路模式

當需要在 Bridge 網路中使用 BACnet/IP 時，需建立 macvlan 網路：

#### 步驟 1：取得網路介面資訊

```bash
ifconfig eno1
# 輸出範例：
# eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
#        inet 192.168.1.91 netmask 255.255.255.0 broadcast 192.168.1.255
```

#### 步驟 2：建立 macvlan 網路

```bash
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  -o parent=eno1 xrt_macvlan
```

#### 步驟 3：更新組態

容器介面依字母順序映射（`xrt_bridge` → `eth0`、`xrt_macvlan` → `eth1`）。更新 `bacnet_ip_device.json`：

```json
{
  "Bus": "bus",
  "Driver": {
    "NetworkInterface": "eth1"
  }
}
```

#### 步驟 4–6：建立並啟動容器

```bash
# 建立容器
docker create --rm --name xrt-bacnet-ip \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network xrt_bridge -it \
  iotechsys/xrt:2.2 [timeout_in_secs]

# 連接 macvlan 網路
docker network connect xrt_macvlan xrt-bacnet-ip

# 啟動容器
docker start xrt-bacnet-ip
```

### 12.3 搭配模擬器使用

```bash
# 步驟 1：建立網路
docker network create bacnet

# 步驟 2：啟動模擬器
docker run -it --rm --name=bacnet-server \
  -e RUN_MODE=IP \
  --network bacnet \
  -v /opt/iotech/xrt/examples/device-bacnet-c/bacnet-simulator/:/docker-lua-script/ \
  iotechsys/bacnet-sim:2.2 \
  --script /docker-lua-script/example.lua --instance 1234

# 步驟 3：啟動 Edge Xrt
docker run -it \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network bacnet \
  iotechsys/xrt:2.2 5
```

---

## 13. Docker 部署 — BACnet/MSTP

映像檔：`iotechsys/xrt:2.2`

BACnet/MSTP 需要透過 `--device` 旗標提供主機序列裝置的存取權限。

```bash
docker run --rm --name xrt-bacnet-mstp \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --device /dev/tty/USB0 \
  iotechsys/xrt:2.2 [time_in_seconds]
```

參數說明：
- `--device /dev/tty/USB0`：提供序列介面存取（實際路徑依主機系統而定）
- 組態檔中的 `SerialInterface` 驅動選項需對應 `--device` 旗標的裝置路徑

---

## 14. BACnet 模擬器

映像檔：`iotechsys/bacnet-sim:2.2`

模擬器可在 IP 或 MSTP 模式運行，透過 Lua 腳本配置。

### 14.1 環境變數與選項

#### 環境變數

| 變數 | 值 | 說明 |
|------|------|------|
| RUN_MODE | `IP` / `MSTP` | 模擬器運行模式（預設：`IP`） |

#### 伺服器選項

| 選項 | 參數 | 說明 | 預設值 |
|------|------|------|--------|
| `--instance` | instance ID | 設定 BACnet 裝置實例 ID | 1234 |
| `--name` | device name | 設定裝置物件名稱 | SimpleServer |
| `--script` | lua script path | 載入 Lua 組態腳本 | 每種物件類型 1 個實例 |
| `--profile` | profile file path | 載入裝置描述檔組態 | 全部描述檔物件類型 |
| `--populate` | instance count | 建立 n 個各物件類型實例 | 每種物件類型 1 個實例 |
| `--no-cov` | 無 | 停用值變化（COV）處理 | COV 啟用 |

> `--populate`、`--script` 和 `--profile` 為互斥選項。

### 14.2 Docker 指令

```bash
# 下載映像檔
docker pull iotechsys/bacnet-sim:2.2

# 基本執行
docker run --rm --name bacnet-sim iotechsys/bacnet-sim:2.2

# 使用 Lua 腳本
docker run --rm --name bacnet-sim \
  -e RUN_MODE=IP \
  iotechsys/bacnet-sim:2.2 \
  --instance 1234 --name BACnetSimulator \
  --script /example-scripts/device-service-example.lua

# 使用 populate
docker run --rm --name bacnet-sim \
  -e RUN_MODE=IP \
  iotechsys/bacnet-sim:2.2 \
  --instance 1234 --name BACnetSimulator --populate 100

# 使用裝置描述檔
docker run --rm --name=bacnet-sim \
  -v /example_profiles/:/profiles \
  iotechsys/bacnet-sim:2.2 \
  --profile /profiles/bacnet-sim-profile.json
```

### 14.3 支援的 BACnet 物件類型

| 物件類型 | 編號 |
|----------|------|
| Analog Output | 1 |
| Analog Value | 2 |
| Binary Input | 3 |
| Binary Output | 4 |
| Binary Value | 5 |
| Command | 7 |
| File | 10 |
| Multi State Input | 13 |
| Multi State Output | 14 |
| Notification Class | 15 |
| Schedule | 17 |
| Multi State Value | 19 |
| Trend Log | 20 |
| Life Safety Point | 21 |
| Accumulator | 23 |
| Load Control | 28 |
| Characterstring Value | 40 |
| Integer Value | 45 |
| Octetstring Value | 47 |
| Positive Integer Value | 48 |
| Lighting Output | 54 |
| Channel | 53 |
| Network Port | 56 |

### 14.4 網路組態

#### IP 模式 — 不同主機

```bash
docker run --rm --name bacnet-sim --network=host iotechsys/bacnet-sim:2.2
```

#### IP 模式 — 同一主機

取得容器 IP：

```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-sim
```

#### MSTP 模式

使用 `socat` 建立虛擬序列埠：

```bash
socat pty,link=/tmp/virtualport,raw,echo=0 tcp:<IP_of_container>:55000
```
