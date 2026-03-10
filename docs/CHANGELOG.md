# Changelog

本文件記錄此技能倉庫的所有重要變更。

格式基於 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/)。

---

## [Unreleased]

_無待發佈項目_

---

## 2026-03-10 — Impeccable 設計技能、Google Workspace 整合、IOTech 專家

### 新增
- **Impeccable 設計技能群組**（來源：github.com/pbakaus/impeccable，Apache 2.0）
  - `frontend-design` — 重新改寫，整合 Impeccable 反 AI 美學泛化（anti-slop）設計哲學
  - 17 個指令型技能：`adapt`、`animate`、`audit`、`bolder`、`clarify`、`colorize`、`critique`、`delight`、`distill`、`extract`、`harden`、`normalize`、`onboard`、`optimize`、`polish`、`quieter`、`teach-impeccable`
  - 7 份參考文件：typography、color-and-contrast、spatial-design、motion-design、interaction-design、responsive-design、ux-writing
- **Google Workspace 技能群組**（gws-*，共 11 個）
  - 基礎服務：`gws-calendar`、`gws-docs`、`gws-drive`、`gws-gmail`、`gws-sheets`、`gws-shared`
  - 跨服務工作流：`gws-workflow`、`gws-workflow-email-to-task`、`gws-workflow-file-announce`、`gws-workflow-meeting-prep`、`gws-workflow-standup-report`、`gws-workflow-weekly-digest`
- **iotech-expert** — IOTech Edge Central 4.0 平台專家技能
  - 涵蓋 Edge Central 4.0（主要）、Edge Connect 2.2、Edge Manager 3.1
  - 27 份參考文件（約 11,800 行、440KB），含 API、設備服務、安全、CLI 等
  - `sync-docs.sh` 腳本搭配 `.url-map.json`，從 docs.iotechsys.com 同步文件
  - `.last-sync` 追蹤文件新鮮度（14 天提醒）
- **youtube-to-mp4** — 使用 yt-dlp + ffmpeg 下載 YouTube 影片並轉為 MP4
- **podcastfy** — 將網頁內容、文字或主題轉為 Podcast MP3 音檔
- **transcribe** — 語音轉文字，自動選擇本機 MLX Whisper 或 Groq 雲端後端
- **pptx** — PowerPoint 簡報建立與編輯
- **obsidian-vault-manager** — Obsidian 保管庫維運與知識管理

### 更新
- **skill-creator** — 升級至 Anthropic 最新評估驅動（eval-driven）版本
- **docx** / **xlsx** — 同步更新至上游最新版
- **clawpilot** — 同步更新至最新版

### 修正
- **sync.sh** — 排除 submodule 避免意外提交子模組
- **sync.sh** — 修正無套件變更時 pipefail 錯誤退出的問題
- **sync.sh** — 限制萬用字元語法僅適用於明確列出的 Agent
- **install.sh** — 建立 symlink 前先移除已存在的實體目錄
- Shell 腳本可執行權限修復（多次）

---

## 2026-03-02 — smart-water-treatment 文件擴充

### 更新
- **smart-water-treatment** — 擴充半導體超純水（UPW）、AI 控制策略、故障排除等參考文件

---

## 2026-02-23 — OpenClaw 技能與系統工具

### 修正
- **crisp-reading** — 修正手機版 HTML 閱讀報告內容貼邊/截斷問題
  - 根本原因：`.book-intro`、`.tips-scores`、`.toolbar`、`.section` 的 `padding` 簡寫覆蓋了 `.page` 的水平內距，全部改為 `padding-top`/`padding-bottom` 長寫形式
  - `.header` 移除多餘水平 padding（內部 `.page` 已處理）
  - 移除 `.book-intro__text` 冗餘的 `max-width`（父元素 `.page` 已限制）
  - 手機版 `.page` 內距從 1.5rem 微調為 1.25rem，改善小螢幕比例
  - 移除 `.tab-nav` 的 `mask-image`（會裁切第一個標籤文字），改用隱藏捲軸方案
  - 新增 `safe-area-inset` 支援，適配瀏海/動態島裝置
  - `.relations` 手機版 padding 縮減為 1rem
  - 列印樣式同步改用長寫 padding 保持一致性

### 新增
- **openclaw 技能** — 自託管 AI 閘道器（OpenClaw）專家技能
  - 支援 14 個聊天平台（WhatsApp、Telegram、Discord、Slack、iMessage、Signal、LINE、Matrix、Teams、Google Chat、Mattermost、BlueBubbles、Feishu、Zalo）
  - 4 個安全稽核腳本：`security_audit.sh`、`config_inspector.sh`、`prompt_checker.sh`、`session_scanner.sh`
  - 4 份參考文件：configuration、security、cloud-deployment、multi-agent
- **系統工具** (`packages/.system/`)
  - `skill-creator` — Codex 技能建立指南
  - `skill-installer` — 從策展清單安裝技能

### 更新
- **openclaw 技能升級至 v2026.2.9**
  - 新增 CVE 追蹤：CVE-2026-25253（CVSS 8.8 Token 外洩）、CVE-2026-24763（命令注入）、CVE-2026-25157（命令注入鏈）
  - 安全稽核腳本對應 OWASP Agentic Top 10（ASI01-ASI10）與 NIST CSF
  - 新增技能供應鏈安全掃描（偵測惡意技能：資料外洩、反向 Shell、混淆執行）
  - 新增 Control UI 安全檢查與反向代理設定驗證
  - `security_audit.sh` 擴展至 14 項檢查（原 10 項）
  - `session_scanner.sh` 改用平行陣列取代關聯陣列（bash 3 相容）
  - `prompt_checker.sh` 修正 grep 返回碼處理
  - 新增 BlueBubbles 頻道設定文件
  - 新增 xAI (Grok) 和百度千帆模型供應商
  - 新增 `OPENCLAW_HOME` 環境變數支援
  - 新增 iOS alpha 節點配對支援
  - 描述加入負面觸發條件（排除非 OpenClaw 的通用問題）
- **CLAUDE.md** — 更新 Repository Structure，反映所有目前的 packages
- **README.md** — 新增 openclaw 技能說明（英文與中文雙語）

---

## 2025-02-10 — 初始版本

### 包含技能
- aipoint-brand-guide — AIPoint 品牌規範
- docx — Word 文件處理
- document-to-markdown — 文件轉 Markdown
- excalidraw — 專業圖表視覺化
- frontend-design — 前端介面設計
- model-thinking — 心智模型工具
- pdf — PDF 操作工具
- planning-with-files — 檔案式規劃系統
- quality-check — 程式碼品質驗證
- remotion-best-practices — Remotion 影片製作最佳實踐
- skill-creator — 技能建立指南
- smart-water-treatment — 水處理系統架構
- theme-factory — 主題套用工具
- ui-ux-pro-max — UI/UX 設計智慧
- vscode-extension-uiux — VS Code 擴充功能開發
- web-design-guidelines — 網頁設計規範審查
- xlsx — 試算表處理
