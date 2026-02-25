# 知識管理模式與策略

## 保管庫健康檢查清單

執行保管庫維運時，依序檢查以下項目：

### 1. 結構健康度

- **孤立筆記**（orphans）：沒有任何筆記連結到的檔案 → `obsidian orphans`
- **死胡同筆記**（deadends）：沒有連結到其他筆記的檔案 → `obsidian deadends`
- **未解析連結**（unresolved links）：`[[連結]]` 指向不存在的筆記 → `obsidian unresolved`
- **空資料夾**：使用 Claude Code 的 Glob + Bash 檢查
- **重複或相似筆記**：使用 Claude Code 讀取內容比對

### 2. 後設資料一致性

- **標籤統一性**：是否有相同概念但不同寫法的標籤（如 #專案 vs #project）→ `obsidian tags counts sort=count`
- **屬性完整性**：重要筆記是否缺少關鍵屬性（如 date、tags、status）→ `obsidian properties counts sort=count`
- **別名覆蓋率**：關鍵概念是否有設定別名方便搜尋 → `obsidian aliases`

### 3. 知識連結密度

- 反向連結數量分佈 → `obsidian backlinks counts` 搭配 Claude Code 分析
- 識別「樞紐筆記」（hub notes）：被大量連結的核心概念

## 知識整理工作流程

### 整理標籤（Tag Cleanup）

1. 用 `obsidian tags counts sort=count` 取得所有標籤及使用次數
2. 用 Claude Code 分析標籤，找出：
   - 相似或重複的標籤（語意分析）
   - 使用頻率極低的標籤（可能是打字錯誤）
   - 階層不一致的標籤（如 #工作/專案A vs #專案/工作）
3. 提出合併或重新命名建議
4. 經使用者確認後，用 Claude Code 批次修改檔案

### 建立內容地圖（MOC, Map of Content）

1. 選定主題範圍
2. 用 `obsidian search` + `obsidian tags` 找出相關筆記
3. 用 Claude Code 讀取筆記內容，分析主題關聯
4. 產生 MOC 筆記，包含：
   - 主題簡介
   - 分類整理的筆記連結
   - 各筆記的一句話摘要
5. 用 `obsidian create` 或 Claude Code 建立 MOC 檔案

### 萃取知識摘要

1. 指定來源筆記（單篇或多篇）
2. 用 Claude Code 讀取完整內容
3. 分析並產出：
   - 關鍵概念萃取
   - 跨筆記的共通模式
   - 矛盾或需要釐清的觀點
   - 可行動的洞察（actionable insights）
4. 輸出格式配合使用者的模板風格

### 週期性回顧

1. 用 `obsidian recents` 查看最近修改的筆記
2. 用 `obsidian tasks todo` 列出未完成任務
3. 用 Claude Code 分析筆記趨勢：
   - 最近關注的主題
   - 長期未更新但重要的筆記
   - 需要拆分或合併的筆記

## 工具選擇決策矩陣

根據任務類型自動選擇最適合的工具：

| 任務 | 最佳工具 | 原因 |
|------|----------|------|
| 查詢反向連結、孤立筆記、未解析連結 | Obsidian CLI | 需要 Obsidian 的連結索引 |
| 列出/搜尋標籤和屬性 | Obsidian CLI | 使用 Obsidian 內建索引，速度快 |
| 管理外掛、模板、佈景主題 | Obsidian CLI | 只有 CLI 能操作 Obsidian 功能 |
| 讀取單一筆記內容 | 皆可，偏好 Claude Code | Read 工具更穩定，不需 Obsidian 運行 |
| 批次修改筆記內容 | Claude Code | Edit 工具支援精確的文字替換 |
| 分析筆記語意、萃取重點 | Claude Code | 需要語意理解能力 |
| 重構資料夾結構 | Claude Code + Obsidian CLI | 用 CLI 查資訊，用 Claude Code 執行搬移 |
| 建立新筆記（含模板） | Obsidian CLI | `create template=<name>` 支援模板展開 |
| 建立新筆記（含 AI 內容） | Claude Code | 需要產生內容再寫入 |
| 快速附加內容到現有筆記 | Obsidian CLI | `append` / `prepend` 最簡潔 |
| 修改筆記中間某段內容 | Claude Code | Edit 工具支援精確定位 |
| 字數統計 | Obsidian CLI | `wordcount` 直接取得 |
| 檔案大綱 | Obsidian CLI | `outline` 直接取得標題結構 |
