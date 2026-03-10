<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/device-service-components/modbus-device-service-component.html
    - https://docs.iotechsys.com/edge-xrt22/simulators/modbus/overview.html
  Synced: 2026-03-07
-->

# Edge Connect 2.2 — Modbus Device Service 完整指南

## 目錄

- [1. 概述](#1-概述)
- [2. 支援功能](#2-支援功能)
- [3. 元件組態範本](#3-元件組態範本)
- [4. 驅動選項](#4-驅動選項)
- [5. 裝置資源屬性](#5-裝置資源屬性)
  - [5.1 必要屬性](#51-必要屬性)
  - [5.2 選用屬性](#52-選用屬性)
- [6. 支援的資料型別](#6-支援的資料型別)
- [7. 協定參數](#7-協定參數)
- [8. 裝置佈建範例](#8-裝置佈建範例)
  - [8.1 Modbus TCP 裝置](#81-modbus-tcp-裝置)
  - [8.2 Modbus RTU 裝置](#82-modbus-rtu-裝置)
- [9. 裝置資源定義範例](#9-裝置資源定義範例)
- [10. 裝置探索](#10-裝置探索)
  - [10.1 TCP 探索選項](#101-tcp-探索選項)
  - [10.2 RTU 探索選項](#102-rtu-探索選項)
- [11. Docker 部署](#11-docker-部署)
  - [11.1 Host 網路模式](#111-host-網路模式)
  - [11.2 Bridge 網路模式](#112-bridge-網路模式)
- [12. Pymodbus 模擬器](#12-pymodbus-模擬器)
  - [12.1 基本啟動](#121-基本啟動)
  - [12.2 組態參數](#122-組態參數)
  - [12.3 腳本介面](#123-腳本介面)
  - [12.4 序列埠連線](#124-序列埠連線)

---

## 1. 概述

Modbus Device Service 元件讓 Edge Connect 能透過 RS-485 序列（RTU）或乙太網路（TCP/IP）連線與 Modbus 裝置通訊。服務會自動將連續暫存器分組為批次請求，減少通訊次數。

---

## 2. 支援功能

### 讀取操作

| 功能碼 | 說明 |
|--------|------|
| FC 1 | 讀取線圈（Coils） |
| FC 2 | 讀取離散輸入（Discrete Inputs） |
| FC 3 | 讀取保持暫存器（Holding Registers） |
| FC 4 | 讀取輸入暫存器（Input Registers） |

### 寫入操作

| 功能碼 | 說明 |
|--------|------|
| FC 5 | 寫入單一線圈（Single Coil） |
| FC 6 | 寫入單一暫存器（Single Register） |
| FC 15 | 寫入多個線圈（Multiple Coils） |
| FC 16 | 寫入多個保持暫存器（Multiple Holding Registers） |

### 連線類型

- **Modbus RTU**：透過 RS-485 序列通訊
- **Modbus TCP/IP**：透過乙太網路通訊

### 請求批次化（Request Batching）

服務會自動將連續暫存器分組，最大批次大小可透過協定屬性控制（如 `ReadMaxHoldingRegisters`）。

---

## 3. 元件組態範本

```json
{
  "Library": "libxrt-modbus-device-service.so",
  "Factory": "xrt_modbus_device_service_factory",
  "Name": "modbus",
  "TelemetryTopic": "xrt/devices/modbus/telemetry",
  "RequestTopic": "xrt/devices/modbus/request",
  "ReplyTopic": "xrt/devices/modbus/reply",
  "StateDir": "./deployment/state",
  "ProfileDir": "./deployment/profiles",
  "Scheduler": "sched",
  "Logger": "logger",
  "ThreadPool": "pool",
  "Bus": "bus"
}
```

---

## 4. 驅動選項

| 參數 | 型別 | 說明 | 預設值 |
|------|------|------|--------|
| DefaultRequestTimeout | UInt32 | 等待裝置回應的毫秒數 | 500 |

---

## 5. 裝置資源屬性

### 5.1 必要屬性

| 屬性 | 說明 | 有效值 |
|------|------|--------|
| primaryTable | 指定主要資料表 | `HOLDING_REGISTERS`、`INPUT_REGISTERS`、`COILS`、`DISCRETE_INPUTS` |
| startingAddress | 暫存器的零基底位址（zero-based） | 任何 UInt16 值 |

### 5.2 選用屬性

| 屬性 | 說明 | 有效值 |
|------|------|--------|
| rawType | 二進位資料型別描述符 | `Int8`、`UInt8`、`Int16`、`UInt16`、`Int32`、`UInt32`、`Int64`、`UInt64` |
| isByteSwap | 將小端序轉換為大端序 | `true`、`false` |
| isWordSwap | 重新排序 16 位元字組序列 | `true`、`false` |
| boolIndex | 布林值的位元位置 | 0–15（暫存器）、0（線圈/離散輸入） |
| stringEncoding | 字串編碼格式 | `UTF8`、`ASCII`（預設：`UTF8`） |
| stringRegisterSize | 字串的暫存器容量 | 1–123（預設：1） |
| scale | 讀取時的乘數因子；寫入時的除數因子 | 任何正數值 |
| scaleType | 何時套用縮放 | `R`、`W`、`RW`（預設：`RW`） |
| additive | 讀取時加上的值；寫入時減去的值 | 在 valueType 範圍內 |
| additiveReadWrite | 何時套用加法 | `R`、`W`、`RW`（預設：`RW`） |
| scaleAddress | 包含縮放因子的暫存器位址 | 同一資料表中的有效位址 |

---

## 6. 支援的資料型別

| Modbus 型別 | Xrt 型別 | 存取模式 | 暫存器數量 |
|-------------|----------|----------|------------|
| Bit | Bool | RW | 1 |
| String | String | RW | 可變 |
| Signed 8-bit Int | Int8 | RW | 1 |
| Unsigned 8-bit Int | UInt8 | RW | 1 |
| Signed 16-bit Int | Int16 | RW | 1 |
| Unsigned 16-bit Int | UInt16 | RW | 1 |
| Signed 32-bit Int | Int32 | RW | 2 |
| Unsigned 32-bit Int | UInt32 | RW | 2 |
| 32-bit Float | Float32 | RW | 2 |
| Signed 64-bit Int | Int64 | RW | 4 |
| Unsigned 64-bit Int | UInt64 | RW | 4 |
| 64-bit Double | Float64 | RW | 4 |

---

## 7. 協定參數

| 參數 | 說明 | 有效值 | 是否必要 |
|------|------|--------|----------|
| UnitID | 站台識別碼 | RTU: 1–247；TCP: 1–247 或 255 | RTU: 是；TCP: 否（預設 255） |
| Address | IP/主機名稱（TCP）或序列埠路徑（RTU） | 有效 IP 或序列埠位址 | 是 |
| Port | TCP 埠（僅 TCP） | 有效埠號 | 是（僅 TCP） |
| BaudRate | 序列鮑率（僅 RTU） | 無號整數 | 是（僅 RTU） |
| DataBits | 資料位元（僅 RTU） | 7、8 | 是（僅 RTU） |
| StopBits | 停止位元（僅 RTU） | 1、2 | 是（僅 RTU） |
| Parity | 同位檢查（僅 RTU） | `N`（無）、`E`（偶數）、`O`（奇數） | 是（僅 RTU） |
| ReadMaxHoldingRegisters | 每次讀取的最大保持暫存器數 | 任何 UInt16 | 否（預設：125） |
| ReadMaxInputRegisters | 每次讀取的最大輸入暫存器數 | 任何 UInt16 | 否（預設：125） |
| ReadMaxBitsCoils | 每次讀取的最大線圈位元數 | 任何 UInt16 | 否（預設：2000） |
| ReadMaxBitsDiscreteInputs | 每次讀取的最大離散輸入位元數 | 任何 UInt16 | 否（預設：2000） |
| WriteMaxHoldingRegisters | 每次寫入的最大保持暫存器數 | 任何 UInt16 | 否（預設：123） |
| WriteMaxBitsCoils | 每次寫入的最大線圈位元數 | 任何 UInt16 | 否（預設：1968） |
| RequestTimeout | 等待回應時間（毫秒） | 任何 UInt32 | 否（預設：500） |
| LinkRecovery | 逾時時啟用連線復原 | Boolean | 否（預設：false） |

---

## 8. 裝置佈建範例

### 8.1 Modbus TCP 裝置

```json
{
  "modbus-sim": {
    "profileName": "modbus-sim-profile",
    "protocols": {
      "modbus-tcp": {
        "Address": "127.0.0.1",
        "Port": 502,
        "UnitID": 1,
        "WriteMaxHoldingRegisters": 1
      }
    },
    "name": "modbus-sim"
  }
}
```

### 8.2 Modbus RTU 裝置

```json
{
  "modbus-sim": {
    "profileName": "modbus-sim-profile",
    "protocols": {
      "modbus-rtu": {
        "Address": "/tmp/slave",
        "UnitID": 1,
        "BaudRate": 9600,
        "DataBits": 8,
        "StopBits": 1,
        "Parity": "N",
        "ReadMaxHoldingRegisters": 5
      }
    },
    "name": "modbus-sim"
  }
}
```

---

## 9. 裝置資源定義範例

### UInt16 暫存器

```json
{
  "name": "Current",
  "description": "Average current of all phases",
  "attributes": {
    "primaryTable": "HOLDING_REGISTERS",
    "startingAddress": 9
  },
  "properties": {
    "valueType": "UInt16",
    "readWrite": "RW"
  }
}
```

### Float32 暫存器

```json
{
  "name": "Energy",
  "description": "System Total True Energy",
  "attributes": {
    "primaryTable": "HOLDING_REGISTERS",
    "startingAddress": 4001
  },
  "properties": {
    "valueType": "Float32",
    "readWrite": "RW"
  }
}
```

### 布林線圈

```json
{
  "name": "IsRunning",
  "description": "Boolean value indicating whether system is running.",
  "attributes": {
    "primaryTable": "COILS",
    "startingAddress": 1,
    "boolIndex": 0
  },
  "properties": {
    "valueType": "Bool",
    "readWrite": "RW"
  }
}
```

### 縮放轉換（Int16 → Float32）

```json
{
  "name": "FanSpeedAvg",
  "description": "Average fan speed for the system.",
  "attributes": {
    "primaryTable": "HOLDING_REGISTERS",
    "startingAddress": 1000,
    "rawType": "INT16",
    "scale": 0.01,
    "scaleType": "RW"
  },
  "properties": {
    "valueType": "Float32",
    "readWrite": "RW"
  }
}
```

---

## 10. 裝置探索

### 10.1 TCP 探索選項

| 參數 | 型別 | 說明 |
|------|------|------|
| Port | UInt16 | 目標 Modbus TCP 埠 |
| StartAddress | String | 掃描起始 IP |
| EndAddress | String | 掃描結束 IP |

### 10.2 RTU 探索選項

| 參數 | 型別 | 說明 |
|------|------|------|
| Device | String | 序列埠路徑 |
| StartUnit | UInt16 | 起始 Modbus 單元 ID |
| EndUnit | UInt16 | 結束 Modbus 單元 ID |
| Baud | UInt32 | 序列鮑率 |
| Bits | String | 格式：`data-parity-stop`（預設：`8-N-1`） |

---

## 11. Docker 部署

映像檔：`iotechsys/xrt:2.2`

### 11.1 Host 網路模式

```bash
docker run --rm --network=host --name xrt-modbus \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  iotechsys/xrt:2.2 [time_in_seconds]
```

參數說明：
- `--network=host`：使用主機網路介面
- `--name xrt-modbus`：容器識別名稱
- `-v`：掛載包含 config、state、profiles 的部署目錄
- `[time_in_seconds]`：選用的執行時間限制

### 11.2 Bridge 網路模式

```bash
docker run --rm --name xrt-modbus \
  --port <modbus_port>:<device_port> \
  -v <deployment_directory>/deployment:/opt/iotech/xrt/2.2/deployment \
  --network <docker_bridge_network> \
  iotechsys/xrt:2.2 [time_in_seconds]
```

參數說明：
- `--port`：當連線外部 Modbus 裝置時需要的埠映射
- `--network`：指定自訂 Bridge 網路；省略時使用預設 Bridge 網路

---

## 12. Pymodbus 模擬器

映像檔：`iotechsys/pymodbus-sim:1.0`

### 12.1 基本啟動

```bash
docker run -d --rm --name pymodbus-sim iotechsys/pymodbus-sim:1.0
```

預設行為：所有主要資料表的暫存器初始化為 0，使用 TCP 協定，監聽埠 5020。

### 12.2 組態參數

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `--profile` | 掛載 Xrt 裝置描述檔以初始化特定暫存器並限制讀寫操作 | 無 |
| `--comm` | 傳輸協定選擇（`tcp` 或 `serial`） | `tcp` |
| `--port` | 監聽埠（TCP 預設 5020；序列模式必填） | 5020 |
| `--script` | 指定包含 `set_initial()` 和/或 `update_values()` 的 Python 腳本（需搭配 `--profile`） | 無 |
| `--delay` | `update_values()` 呼叫間隔（秒） | 1 |
| `--log` | 記錄等級：`critical`、`error`、`warning`、`info`、`debug` | `info` |

#### 使用裝置描述檔

```bash
docker run -d --rm \
  -v host_dir_with_profile:/sim_files \
  --name pymodbus-sim iotechsys/pymodbus-sim:1.0 \
  --profile /sim_files/modbus_device_profile.json
```

### 12.3 腳本介面

模擬器腳本支援兩個函式：

- **`set_initial(resources)`**：接收以資源名稱為鍵的 resources 字典，包含 Resource 物件。值會以 `rawType`（如果存在）寫入，否則以 `valueType` 寫入。字串資源接受直接字串值。
- **`update_values(resources)`**：支援相同的 resources 字典格式，可透過 `get_value()` 取得先前的值以進行增量更新。

### 12.4 序列埠連線

序列連線需要 `socat` 工具。

#### 啟動模擬器（序列模式）

```bash
docker run -d --rm \
  -v host_dir_with_profile:/sim_files \
  --network=host --name pymodbus-sim \
  iotechsys/pymodbus-sim:1.0 \
  --profile /sim_files/modbus_device_profile.json \
  --comm serial --serial_over_tcp_port 50103
```

#### 建立虛擬序列埠

```bash
socat pty,link=/tmp/virtualport,raw,echo=0 tcp:localhost:50103
```

裝置組態中使用的序列埠路徑：`"/tmp/virtualport"`
