<!--
  Source URLs:
    - https://docs.iotechsys.com/edge-xrt22/installation/installation.html
    - https://docs.iotechsys.com/edge-xrt22/installation/systemd.html
    - https://docs.iotechsys.com/edge-xrt22/docker-container/introduction.html
  Synced: 2026-03-07
-->

<!-- 同步時間: 2026-03-07 -->

# Edge Connect 2.2 安裝指南

## 目錄

- [支援的系統與架構](#支援的系統與架構)
- [Debian/Ubuntu 安裝](#debianubuntu-安裝)
  - [先決條件](#先決條件)
  - [新增 IOTech 套件庫金鑰](#新增-iotech-套件庫金鑰)
  - [註冊套件庫](#註冊套件庫)
  - [安裝套件](#安裝套件)
- [Fedora 安裝](#fedora-安裝)
- [OpenSUSE 安裝](#opensuse-安裝)
- [Alpine Linux 安裝](#alpine-linux-安裝)
- [Windows Subsystem for Linux 安裝](#windows-subsystem-for-linux-安裝)
- [Zephyr RTOS](#zephyr-rtos)
- [授權檔安裝](#授權檔安裝)
- [安裝驗證](#安裝驗證)
- [Systemd 服務設定](#systemd-服務設定)
  - [服務管理指令](#服務管理指令)
  - [必要檔案與預設路徑](#必要檔案與預設路徑)
  - [啟動腳本](#啟動腳本)
  - [服務行為](#服務行為)
- [Docker 容器化部署](#docker-容器化部署)
  - [Docker 映像檔](#docker-映像檔)
  - [容器執行](#容器執行)
  - [組態需求](#組態需求)
  - [容器授權設定](#容器授權設定)

---

## 支援的系統與架構

| 系統 | AMD64 | ARM64 | ARM32 | X86 |
|------|-------|-------|-------|-----|
| Debian 10 | Yes | Yes | Yes | Yes |
| Debian 11 | Yes | Yes | Yes | Yes |
| Debian 12 | Yes | Yes | Yes | Yes |
| Alpine 3.16 | Yes | Yes | Yes | Yes |
| Alpine 3.17 | Yes | Yes | Yes | Yes |
| Alpine 3.18 | Yes | Yes | Yes | Yes |
| Alpine 3.19 | Yes | Yes | Yes | Yes |
| Ubuntu 20.04 | Yes | Yes | Yes | No |
| Ubuntu 22.04 | Yes | Yes | Yes | No |
| Ubuntu 24.04 | Yes | Yes | Yes | No |
| Fedora 40 | Yes | Yes | No | No |
| OpenSUSE Leap 15.5 | Yes | Yes | Yes | No |
| ClearLinux | Yes | No | No | No |
| Windows Subsystem for Linux | Yes | No | No | No |
| Zephyr 2.3 | Yes | Yes | Yes | No |

**重要提醒：**
- IOTech 建議所有安裝以 root 身份執行
- 核心框架需要標準 C 程式庫與 POSIX API 支援
- 並非所有元件在所有平台上都可用
- 套件管理員會盡可能處理相依套件

## Debian/Ubuntu 安裝

### 先決條件

```bash
sudo apt-get install lsb-release apt-transport-https curl gnupg
```

### 新增 IOTech 套件庫金鑰

**適用於 Debian 11、12、Ubuntu 22.04、24.04：**

```bash
curl -fsSL https://iotech.jfrog.io/artifactory/api/gpg/key/public | \
  sudo gpg --dearmor -o /usr/share/keyrings/iotech.gpg
```

**適用於其他版本（Debian 10、Ubuntu 20.04）：**

```bash
curl -fsSL https://iotech.jfrog.io/artifactory/api/gpg/key/public | \
  sudo apt-key add -
```

### 註冊套件庫

**適用於 Debian 11、12、Ubuntu 22.04、24.04：**

```bash
echo "deb [signed-by=/usr/share/keyrings/iotech.gpg] \
  https://iotech.jfrog.io/iotech/debian-release $(lsb_release -cs) main" | \
  sudo tee -a /etc/apt/sources.list.d/iotech.list
```

**適用於其他版本（Debian 10、Ubuntu 20.04）：**

```bash
echo "deb https://iotech.jfrog.io/iotech/debian-release $(lsb_release -cs) main" | \
  sudo tee -a /etc/apt/sources.list.d/iotech.list
```

### 安裝套件

```bash
sudo apt-get update
sudo apt-get install iotech-xrt-2.2
```

## Fedora 安裝

**適用於 Fedora 40：**

```bash
cat > /etc/yum.repos.d/iotech.repo << "EOF"
[iotech]
name=IOTech Repository (Non-OSS)
baseurl=https://iotech.jfrog.io/iotech/rpm-fedora-40-release/
enabled=1
gpgcheck=0
EOF

yum makecache
yum install iotech-xrt-2.2
```

## OpenSUSE 安裝

**適用於 OpenSUSE Leap 15.5：**

```bash
zypper addrepo --name "IOTech Repository (Non-OSS)" \
  https://iotech.jfrog.io/artifactory/rpm-opensuse-15.5-release \
  repo-iotech-non-oss

zypper --gpg-auto-import-keys refresh repo-iotech-non-oss
zypper install iotech-xrt-2.2
```

## Alpine Linux 安裝

**適用於 Alpine 3.16 至 3.19：**

```bash
wget https://iotech.jfrog.io/artifactory/api/security/keypair/public/repositories/alpine-release \
  -O /etc/apk/keys/alpine.dev.rsa.pub

echo "https://iotech.jfrog.io/artifactory/alpine-release/v3.16/main" \
  >> /etc/apk/repositories
apk update
apk add iotech-xrt-2.2
```

> **注意：** 請將 `v3.16` 替換為實際使用的 Alpine 版本號（如 `v3.17`、`v3.18`、`v3.19`）。

## Windows Subsystem for Linux 安裝

1. 安裝 Windows Subsystem for Linux (WSL)
2. 在 WSL 終端機中，依照 Ubuntu 22.04 的安裝步驟操作

## Zephyr RTOS

Zephyr RTOS 平台需要針對目標硬體進行自訂編譯。IOTech 支援以下評估用建置環境：

- QEMU（模擬器）
- ACRN
- ARM NXP FRDM-K64F 開發板

## 授權檔安裝

授權檔 `Xrt_license.lic` 需向 IOTech 支援團隊取得。提供三種設定方式：

### 方式一：環境變數

```bash
export XRT_LICENSE_FILE=<path>/Xrt_license.lic
```

### 方式二：放置於組態目錄

將 `Xrt_license.lic` 複製到組態目錄（config directory）並重新命名為 `license.json`。

### 方式三：預設安裝位置

將授權檔放置於 `/opt/iotech/xrt` 目錄並重新命名為 `license.json`。

> **注意：** Azure Sphere 部署不需要另外安裝授權檔。

## 安裝驗證

安裝完成後，可透過以下步驟驗證：

1. **複製範例程式碼：**

```bash
git clone https://github.com/IOTechSystems/xrt-examples/tree/v2.2-branch
```

2. **載入環境變數：**

```bash
source /opt/iotech/xrt/<ver>/bin/env.sh
```

其中 `<ver>` 為安裝的版本號。

3. **執行應用程式：**

```bash
xrt <config> [<time_in_seconds>]
```

範例：

```bash
xrt deployment/config 5
```

> **注意：** 執行時需從包含 `config` 資料夾的目錄發起。

---

## Systemd 服務設定

Edge Connect 可作為 systemd 服務執行。透過套件管理員安裝時，服務會自動安裝但預設為停用狀態。

### 服務管理指令

```bash
# 啟動服務
sudo systemctl start xrt

# 停止服務
sudo systemctl stop xrt

# 重新啟動服務
sudo systemctl restart xrt

# 查看服務狀態
systemctl status xrt
```

### 必要檔案與預設路徑

服務正常運作需要以下三個檔案：

1. 授權檔（License file）
2. 組態檔（Configuration files）
3. 環境變數腳本（env.sh）

預設路徑：

| 項目 | 路徑 |
|------|------|
| 安裝目錄 | `/opt/iotech/xrt/<ver>` |
| 授權檔 | `${XRT_INSTALL_DIR}/license.json` |
| 組態檔 | `${XRT_INSTALL_DIR}/deployment/config` |
| 環境變數腳本 | `${XRT_INSTALL_DIR}/deployment/config/env.sh` |

其中 `${XRT_INSTALL_DIR}` 預設為 `/opt/iotech/xrt/<ver>`。

### 啟動腳本

systemd 服務使用位於 `${XRT_INSTALL_DIR}/systemd` 目錄的 `xrt-start.sh` 腳本來設定必要的環境變數。

### 服務行為

- 服務在發生錯誤時會自動重新啟動
- 移除套件時會同步移除 systemd 服務
- 若系統未安裝 systemd，安裝程式會通知使用者並跳過服務安裝

---

## Docker 容器化部署

Edge Connect 提供 Docker 容器映像檔，可用於元件探索與開發。

### Docker 映像檔

- **基礎映像檔：** Alpine 3.18
- **映像檔倉庫：** `iotechsys/xrt`

拉取映像檔：

```bash
docker pull iotechsys/xrt:<version>
```

拉取 2.2 版本：

```bash
docker pull iotechsys/xrt:2.2
```

### 初始元件

Docker 映像檔啟動時僅載入以下核心元件：

- Bus
- Logger
- Scheduler
- ThreadPool

其他元件需透過在組態檔中指定工廠名稱（factory name）與程式庫名稱（library name）來動態載入。

### 容器執行

執行指令格式：

```bash
docker run --rm \
  -v <path_to_deployment_folder>/deployment:/opt/iotech/xrt/2.2/deployment \
  iotechsys/xrt:<version> [timeout_in_secs]
```

參數說明：

| 參數 | 說明 |
|------|------|
| `--rm` | 容器停止後自動移除 |
| `-v` | 綁定掛載（Bind Mount）部署資料夾 |
| 掛載來源 | `<path_to_deployment_folder>/deployment`（主機端路徑） |
| 掛載目標 | `/opt/iotech/xrt/2.2/deployment`（容器內路徑） |
| `timeout_in_secs` | 選填，執行逾時秒數；預設為無限（infinity） |

停止方式：按下 `Ctrl + C`。

### 組態需求

- 根組態檔必須命名為 `main.json`
- 部署資料夾必須透過綁定掛載提供
- 容器內掛載路徑：`/opt/iotech/xrt/2.2/deployment`

### 容器授權設定

啟動容器前，必須將授權檔放置於組態目錄中：

1. 取得授權檔 `Xrt_license.lic`（由 IOTech 支援團隊提供）
2. 將檔案重新命名為 `license.json`
3. 放置於部署資料夾的 config 目錄內

### 裝置服務 Docker 設定

各裝置服務元件（Device Service）有各自的 Docker 設定文件，請參閱對應元件的文件以取得容器化部署的詳細設定。
