<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/introduction/introduction.html
    - https://docs.iotechsys.com/edge-xrt22/getting-started/getting-started.html
    - https://docs.iotechsys.com/edge-xrt22/components/available-components.html
  Synced: 2026-03-07
-->

<!-- 同步時間: 2026-03-07 -->

# Edge Connect 2.2 概覽

## 目錄

- [產品定位與核心特性](#產品定位與核心特性)
- [與 Edge Central 的差異](#與-edge-central-的差異)
- [架構設計](#架構設計)
- [元件分類與完整清單](#元件分類與完整清單)
  - [核心元件 (Core Components)](#核心元件-core-components)
  - [裝置服務元件 (Device Service Components)](#裝置服務元件-device-service-components)
  - [匯出元件 (Exporter Components)](#匯出元件-exporter-components)
  - [橋接元件 (Bridge Components)](#橋接元件-bridge-components)
  - [裝置元件 (Device Components)](#裝置元件-device-components)
  - [轉換元件 (Transform Components)](#轉換元件-transform-components)
  - [伺服器元件 (Server Components)](#伺服器元件-server-components)
  - [擴充元件 (Extension Components)](#擴充元件-extension-components)
- [Getting Started 流程](#getting-started-流程)
  - [典型應用架構](#典型應用架構)
  - [實作步驟](#實作步驟)
  - [快速開始工作流程](#快速開始工作流程)

---

## 產品定位與核心特性

IOTech Edge Connect（前稱 Edge Xrt）是一套用於開發連網即時邊緣軟體應用的平台，目標是加速工業 4.0（Industry 4.0）解決方案的上市時間。

核心特性：

- **模組化、元件導向設計**：應用程式透過組裝標準元件並加以設定來建構，無需從頭撰寫程式碼。
- **程序內資料匯流排（Process-local Databus）**：所有元件透過基於主題的發布／訂閱模式（Topic-based Publish and Subscribe）在同一位址空間（Single Address Space）內通訊，確保極低延遲與高效率。
- **C 語言實作**：以 C 語言撰寫，針對資源受限的嵌入式裝置與即時運算場景最佳化。
- **超低延遲（Ultra-low Latency）**：單一位址空間部署，元件間通訊不經過網路堆疊，適合對延遲敏感的工業控制場景。
- **嵌入式優先（Embedded-first）**：支援從完整 Linux 發行版到 Zephyr RTOS 等多種平台，可部署於極小型硬體。

## 與 Edge Central 的差異

| 面向 | Edge Connect (Xrt) | Edge Central |
|------|-------------------|--------------|
| 程式語言 | C 語言 | Go 語言 |
| 部署模式 | 單一程序、單一位址空間 | 微服務架構、多程序 |
| 延遲特性 | 超低延遲（程序內通訊） | 一般延遲（程序間通訊） |
| 目標硬體 | 嵌入式裝置、資源受限環境、RTOS | 邊緣伺服器、閘道器 |
| 元件通訊 | 程序內資料匯流排（Pub/Sub） | 訊息匯流排（Message Bus） |
| 作業系統支援 | Linux、Alpine、Zephyr RTOS、WSL | Linux（主要）、Docker |
| 適用情境 | 即時控制、嵌入式閘道、低功耗裝置 | 邊緣平台管理、裝置管理、規則引擎 |

Edge Connect 的定位是「輕量、即時、嵌入式優先」的邊緣連接層，而 Edge Central 則是功能更完整的邊緣平台管理層。兩者可搭配使用：Edge Connect 負責前端裝置通訊與即時處理，Edge Central 負責後端管理、編排與企業整合。

## 架構設計

Edge Connect 採用元件組裝式架構，一個典型的連網邊緣應用包含以下層次：

1. **核心層**：Bus、Scheduler、ThreadPool、Logger 四個必要元件，提供元件間通訊、排程、執行緒管理與日誌功能。
2. **裝置通訊層**：裝置服務元件（Device Service Components），透過工業協定（如 Modbus、OPC UA、BACnet 等）與現場設備通訊。
3. **資料匯出層**：匯出元件（Exporter Components），將裝置資料傳送至雲端或 IT 端點（如 AWS IoT Core、Azure IoT Hub、InfluxDB）。
4. **橋接層**：橋接元件（Bridge Components），透過 MQTT、Redis 等協定與外部系統整合。
5. **轉換層**：Lua 腳本元件，支援本地分析、資料轉換與過濾。
6. **伺服器層**：OPC UA Server 元件，可對外提供 OPC UA 資訊模型。

所有元件在同一程序內透過資料匯流排通訊，部署為單一執行檔。

## 元件分類與完整清單

### 核心元件 (Core Components)

| 元件名稱 | 說明 |
|----------|------|
| Bus | 程序內資料匯流排，負責元件間的 Pub/Sub 通訊 |
| Logger | 日誌元件 |
| Bus Logger | 匯流排日誌元件 |
| Scheduler | 排程元件，管理定時任務 |
| ThreadPool | 執行緒池管理 |
| Config | 組態管理元件 |

### 裝置服務元件 (Device Service Components)

支援多種工業通訊協定：

| 元件名稱 | 支援協定 |
|----------|----------|
| BACnet Device Service | BACnet |
| BLE Device Service | 低功耗藍牙（Bluetooth Low Energy） |
| CANbus Device Service | CANbus |
| EtherCAT Device Service | EtherCAT |
| EtherNet/IP Device Service | EtherNet/IP |
| GPS Device Service | GPS |
| Modbus Device Service | Modbus TCP/RTU |
| OPC UA Device Service | OPC UA |
| PROFINET Device Service | PROFINET |
| S7 Device Service | Siemens S7 |
| Virtual Device Service | 虛擬裝置（模擬測試用） |
| Zigbee Device Service | Zigbee |

每個裝置服務元件均支援 Docker 容器化部署，並提供對應的模擬器環境供開發測試。

### 匯出元件 (Exporter Components)

| 元件名稱 | 匯出目標 |
|----------|----------|
| REST Exporter | REST API 端點 |
| InfluxDB Exporter | InfluxDB 時序資料庫 |
| Azure Exporter | Azure IoT Hub |
| AzureSphere Exporter | Azure Sphere |
| AWS SiteWise Exporter | AWS IoT SiteWise |
| Log Exporter | 日誌檔案 |
| Ring Buffer Exporter | 環形緩衝區 |

### 橋接元件 (Bridge Components)

| 元件名稱 | 橋接協定 |
|----------|----------|
| MQTT Bridge | MQTT |
| Redis Bridge | Redis |
| Thrift RPC Bridge | Apache Thrift RPC |

### 裝置元件 (Device Components)

| 元件名稱 | 目標平台 |
|----------|----------|
| MT3620 Device | Azure Sphere MT3620 |
| Linux Device | Linux 系統 |

### 轉換元件 (Transform Components)

| 元件名稱 | 說明 |
|----------|------|
| Lua Transform | Lua 腳本引擎，支援本地資料轉換、過濾與分析 |

### 伺服器元件 (Server Components)

| 元件名稱 | 說明 |
|----------|------|
| OPC UA Server | OPC UA 伺服器，支援資訊模型建構（Information Modelling） |

### 擴充元件 (Extension Components)

| 元件名稱 | 說明 |
|----------|------|
| BACnet Event Registration | BACnet 事件註冊 |
| OPC UA Event Registration | OPC UA 事件註冊 |

## Getting Started 流程

### 典型應用架構

一個標準的 Edge Connect 應用包含以下組成：

- **Xrt 核心**：Bus、Scheduler、ThreadPool、Logger 元件
- **裝置服務元件**：透過工業協定（如 Modbus）與現場設備通訊
- **匯出元件**：將裝置資料傳送至雲端端點（如 AWS IoT Core）
- **選配 Lua 腳本**：支援本地分析、資料轉換與過濾

### 實作步驟

1. **裝置建模（Device Modeling）**

   使用 IOTech 的裝置組態工具（Device Configuration Tool）建立協定專屬的組態檔（裝置描述檔，Device Profile）。此工具同時可產生第三方檔案，例如：
   - Azure 數位孿生（Digital Twins）的 DTDL 檔案
   - AWS SiteWise 的資產模型（Asset Model）檔案

2. **描述檔設定（Profile Configuration）**

   將裝置描述檔放置於目標檔案系統上，並設定對應的裝置服務 JSON 檔案以參照這些描述檔。

3. **主組態檔設定（Main Configuration）**

   建立 `main.json` 檔案，列出應用中包含的所有元件。

4. **元件組態檔設定（Component Configuration）**

   為 `main.json` 中指定的每個元件產生對應的組態檔，常見檔案包括：
   - `bus.json` — 匯流排設定
   - `logger.json` — 日誌設定
   - `pool.json` — 執行緒池設定
   - `schedules.json` — 排程設定
   - `log_exporter.json` — 日誌匯出設定
   - `modbus_device_service.json` — Modbus 裝置服務設定
   - `devices.json` — 裝置清單
   - `export_aws.json` — AWS 匯出設定

5. **部署與執行（Application Deployment）**

   設定完成後，執行 Xrt 應用程式。

### 快速開始工作流程

1. 觀看 Getting Started 影片
2. 從 [Xrt Example Code](https://github.com/IOTechSystems/xrt-examples/tree/v2.2-branch) 下載範例程式碼
3. 修改 `main.json` 以新增或移除元件
4. 對應更新各元件的組態檔

### 管理介面

Edge Connect 提供透過 MQTT 的管理 API（Management API），可用於：
- 執行階段元件管理
- 組態查詢與更新
- 狀態監控

### 版本遷移

IOTech 提供從 1.x 到 2.2 版本的遷移指南（Migration Guide），涵蓋組態格式變更與 API 差異。
