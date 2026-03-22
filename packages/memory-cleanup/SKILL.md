---
name: memory-cleanup
description: >
  Monthly memory maintenance: scan all auto-memory files across projects,
  identify stale/expired entries, propose consolidation, execute after human approval.
  Use when: user says "/memory-cleanup", "整理記憶", "清理記憶", "記憶維護",
  "memory maintenance", or when memory files exceed capacity limits.
---

# Memory Cleanup — 記憶新陳代謝

月度記憶維護工具。掃描所有記憶檔，標記過期與閒置條目，提出整併建議，經人工核准後執行。

## 執行流程

### 第一步：掃描所有專案的記憶目錄

```bash
find ~/.claude/projects/*/memory -name "*.md" -not -name "MEMORY.md" -type f
```

統計每個專案的記憶檔數量和總大小。

### 第二步：逐檔檢查健康狀態

對每個記憶檔，讀取 frontmatter 和內容，評估：

1. **過期檢查**（依 CLAUDE.md §10 規則）：
   - 工具/版本相關：建立超過 **90 天** → 標為 `⏰ 待確認`
   - 架構/設計 pattern：建立超過 **180 天** → 標為 `⏰ 待確認`
   - 使用者偏好/慣例：建立超過 **365 天** → 標為 `⏰ 待確認`

2. **閒置檢查**：
   - 檔案最後修改時間超過 **60 天** → 標為 `stale`
   - 注意：`reference_physical_intuition.md` 等標註「永久有效」的檔案豁免

3. **容量檢查**：
   - 每個專案的 MEMORY.md 是否接近 200 行上限
   - 每個專案的記憶檔是否超過 40 個

4. **品質檢查**：
   - frontmatter 是否完整（name, description, type）
   - description 是否足夠具體（用於搜尋相關性判斷）
   - 內容是否具體可執行（非空泛的「不要用 X」）

### 第三步：產出健康報告

格式：

```markdown
## 記憶健康報告 — YYYY-MM-DD

### 總覽
| 專案 | 記憶檔數 | 健康 | ⏰ 待確認 | stale | 容量 |
|------|---------|------|----------|-------|------|

### 需要處理的條目

#### ⏰ 過期待確認
| 檔案 | 專案 | 建立日 | 類型 | 建議 |
|------|------|--------|------|------|
（列出所有過期檔案，建議：保留/更新/淘汰/合併）

#### stale（60 天未修改）
（同上格式）

#### 容量警告
（列出接近上限的專案）

#### 品質問題
（列出 frontmatter 不完整或 description 不夠具體的檔案）

### 整併建議
（列出可以合併的相近主題，說明理由）
```

### 第四步：等待人工核准

**絕對不要自動執行任何修改。** 產出報告後，等待使用者逐條確認：
- ✅ 同意淘汰 → 移到 `memory/archive/` 目錄
- ✅ 同意合併 → 合併內容，刪除來源檔，更新 MEMORY.md 索引
- ✅ 同意更新 → 標記為已確認，更新 frontmatter 的 description
- ❌ 保留不動 → 跳過

### 第五步：執行核准的變更

依人工核准的決定執行：
1. 淘汰的檔案移到 `memory/archive/`（不刪除，保留可追溯性）
2. 合併的檔案寫入新檔，刪除來源，更新 MEMORY.md
3. 更新的檔案修改 frontmatter
4. 最後再次統計，確認變更後的健康狀態

## 注意事項

- 這是 **月度** 任務，不需要每次 session 都執行
- 「有用」的定義只有使用者自己知道——不要替使用者決定
- 標為 stale 不代表要刪除，可能只是穩定的知識不需要更新
- `reference_` 前綴的檔案通常壽命較長，不要輕易標為過期
- `feedback_` 前綴的檔案是使用者偏好，除非使用者明確說變了，否則保留
