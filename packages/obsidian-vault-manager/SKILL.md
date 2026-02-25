---
name: obsidian-vault-manager
description: >
  Obsidian 保管庫維運與個人知識管理顧問。靈活運用 Obsidian CLI 和 Claude Code 工具，
  自動選擇最佳工具來完成任務。支援保管庫健康檢查、筆記搜尋與查詢、標籤整理、
  知識萃取與摘要、建立內容地圖（MOC）、重構資料夾結構、批次修改筆記、
  簡體中文轉繁體中文（zh-CN → zh-TW）等操作。
  使用時機：(1) 使用者提到 Obsidian、保管庫、vault、筆記管理、知識管理，
  (2) 需要搜尋、整理、分類、萃取保管庫中的知識，
  (3) 需要操作 Obsidian CLI 指令（標籤、屬性、連結、外掛等），
  (4) 需要批次處理筆記內容（合併、重新命名、修改 frontmatter 等），
  (5) 保管庫維運（健康檢查、找孤立筆記、清理未解析連結等），
  (6) 需要簡體轉繁體、簡轉繁、zh-CN 轉 zh-TW、OpenCC 轉換。
  中文觸發：Obsidian、筆記、保管庫、知識管理、標籤整理、MOC、每日筆記、反向連結、
  簡轉繁、簡體轉繁體、中文轉換。
---

# Obsidian 保管庫管理員

## 環境設定

Obsidian CLI 路徑：`/Applications/Obsidian.app/Contents/MacOS/Obsidian`

執行 CLI 指令格式：
```bash
/Applications/Obsidian.app/Contents/MacOS/Obsidian <command> [options]
```

指定保管庫：`vault=<name>` 放在指令最前面。

已知保管庫：
- **obsidian_kc_main**（預設）：`/Users/kc/Obsidian Vaults/obsidian_kc_main`
- **TEST**：`/Users/kc/Obsidian Vaults/TEST`

未指定時，預設操作 **obsidian_kc_main**。

## CLI 參考文件

完整 CLI 指令參考：[references/obsidian-cli.md](references/obsidian-cli.md)

更新時機（僅在以下情況才更新參考文件）：
- 使用者明確要求更新 CLI 參考
- CLI 指令執行結果與參考文件不符（如指令不存在或參數有變）
- 使用者提及 Obsidian 有重大版本更新

更新方式：用 WebFetch 從 `https://help.obsidian.md/cli` 取得最新內容，搭配 `obsidian help` 輸出交叉比對後更新。

## 工具選擇策略

選擇原則：
- **CLI**：需要 Obsidian 索引的查詢（連結、標籤、屬性）、外掛/模板管理、附加內容
- **Claude Code**：需要語意理解（分析、萃取、比對）、精確編輯（frontmatter、段落修改）、批次操作
- **腳本**：確定性轉換（如簡繁轉換），不耗 LLM token

典型流程：CLI 查結構資料 → Claude Code 分析 → Claude Code 或 CLI 執行變更。

完整決策矩陣見 [references/knowledge-management.md](references/knowledge-management.md)。

## 簡體中文轉繁體中文（zh-CN → zh-TW）

使用 [scripts/convert_zhcn_to_zhtw.py](scripts/convert_zhcn_to_zhtw.py) 執行轉換。
基於 `opencc-python-reimplemented`（純 Python），跨平台（macOS / Linux / Windows）。
使用 `s2twp` 設定檔（含台灣慣用詞彙轉換，如 软件→軟體、内存→記憶體）。

**前置條件**：自動處理。首次執行時若缺少 `opencc-python-reimplemented` 會自動透過 `uv pip` 或 `pip` 安裝。

### 基本用法

```bash
# 單一檔案（預設會自動建立 .bak 備份）
python3 scripts/convert_zhcn_to_zhtw.py <file.md>

# 整個資料夾（遞迴處理所有 .md）
python3 scripts/convert_zhcn_to_zhtw.py --dir <folder_path>

# 預覽模式（只看差異，不修改）
python3 scripts/convert_zhcn_to_zhtw.py --dry-run <file.md>

# 不建立備份
python3 scripts/convert_zhcn_to_zhtw.py --no-backup <file.md>
```

### 關鍵設計：YAML frontmatter 保護

預設自動偵測並跳過 YAML frontmatter（`---` 區塊），只轉換正文。
原因：frontmatter 中的繁體標籤（如 `類型/剪貼`）若經 `s2twp` 處理會被錯誤轉換。

若確定 frontmatter 也是簡體，加 `--include-frontmatter` 解除保護。

### 工作流程

1. 先用 `--dry-run` 預覽變更範圍
2. 確認無誤後執行轉換（預設會自動建立 `.bak` 備份）
3. 腳本會報告：已轉換、已跳過（無需轉換）、錯誤的檔案數量

### 可用設定檔

| 設定檔 | 說明 | 適用場景 |
|--------|------|----------|
| `s2twp` | 簡體→繁體台灣（含詞彙轉換，預設） | 大多數情境 |
| `s2tw` | 簡體→繁體台灣（僅字元轉換） | 不需詞彙替換時 |
| `s2t` | 簡體→繁體（通用） | 非台灣用語需求 |
| `t2s` | 繁體→簡體 | 反向轉換 |

用 `--config <名稱>` 切換，例如 `--config s2tw`。

## 核心工作流程

詳細策略與模式見 [references/knowledge-management.md](references/knowledge-management.md)。

### 保管庫健康檢查

依序執行 CLI 指令收集資料，再用 Claude Code 分析：
```
obsidian vault
obsidian orphans total
obsidian deadends total
obsidian unresolved total counts
obsidian tags counts sort=count
obsidian properties counts sort=count
```
產出報告含：問題清單、嚴重程度、建議行動。

### 標籤整理

1. CLI `tags counts sort=count` 取得標籤
2. Claude Code 語意分析相似/重複標籤
3. 提出合併建議 → 取得使用者確認
4. Claude Code 批次修改檔案

### 建立內容地圖（MOC）

1. 確認主題範圍
2. CLI `search` + `tags` 找相關筆記
3. Claude Code 讀取分析 → 產生 MOC 筆記（含分類連結與摘要）

### 知識萃取

1. 確認來源筆記
2. Claude Code 讀取完整內容
3. 產出：關鍵概念、跨筆記模式、矛盾點、可行動洞察

## 安全注意事項

傳遞使用者輸入至 Obsidian CLI 時，務必正確引用（quote）參數值，避免 shell 特殊字元（如 `;`、`&&`、`|`、`$`）造成命令注入。例如：
```bash
# 正確：用雙引號包裹含空格或特殊字元的參數
obsidian search query="使用者的搜尋文字"

# 錯誤：未引用的參數可能被 shell 解析
obsidian search query=使用者的搜尋文字
```

## 輸出規範

- 所有輸出使用繁體中文，英文術語保持原文
- 保留筆記原有的 YAML frontmatter 格式
- 批次操作前列出變更清單，取得使用者確認
- 破壞性操作（刪除、大量修改）一律先確認
