# Changelog

本文件記錄此技能倉庫的所有重要變更。

格式基於 [Keep a Changelog](https://keepachangelog.com/zh-TW/1.1.0/)。

---

## [Unreleased]

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
