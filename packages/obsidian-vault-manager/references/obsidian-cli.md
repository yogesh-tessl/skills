# Obsidian CLI 指令參考

> **更新日期**：2026-02-12
> **來源**：https://help.obsidian.md/cli
> **更新規則**：若距離上次更新超過 2 週，使用 WebFetch 從上述網址重新取得最新指令列表並更新此檔案。

## 執行方式

```bash
/Applications/Obsidian.app/Contents/MacOS/Obsidian <command> [options]
```

建議在 shell 設定別名：`alias obsidian='/Applications/Obsidian.app/Contents/MacOS/Obsidian'`

## 全域選項

| 選項 | 說明 |
|------|------|
| `vault=<name>` | 指定目標保管庫名稱（必須是第一個參數） |

## 指令分類

### 保管庫資訊

| 指令 | 說明 |
|------|------|
| `vault [info=name\|path\|files\|folders\|size]` | 顯示保管庫資訊 |
| `vaults [total] [verbose]` | 列出所有已知保管庫 |
| `version` | 顯示 Obsidian 版本 |
| `reload` | 重新載入保管庫 |
| `restart` | 重新啟動應用程式 |

### 檔案操作

| 指令 | 說明 |
|------|------|
| `file [file=<name>] [path=<path>]` | 顯示檔案資訊 |
| `files [folder=<path>] [ext=<extension>] [total]` | 列出保管庫檔案 |
| `folder path=<path> [info=files\|folders\|size]` | 顯示資料夾資訊 |
| `folders [folder=<path>] [total]` | 列出資料夾 |
| `create [name=<name>] [path=<path>] [content=<text>] [template=<name>] [overwrite] [silent] [newtab]` | 建立新檔案 |
| `read [file=<name>] [path=<path>]` | 讀取檔案內容 |
| `append [file=<name>] [path=<path>] content=<text> [inline]` | 附加內容到檔案末尾 |
| `prepend [file=<name>] [path=<path>] content=<text> [inline]` | 插入內容到檔案開頭 |
| `move [file=<name>] [path=<path>] to=<path>` | 移動或重新命名檔案 |
| `delete [file=<name>] [path=<path>] [permanent]` | 刪除檔案 |
| `open [file=<name>] [path=<path>] [newtab]` | 在 Obsidian 中開啟檔案 |

### 搜尋

| 指令 | 說明 |
|------|------|
| `search query=<text> [path=<folder>] [limit=<n>] [total] [matches] [case] [format=text\|json]` | 搜尋保管庫內容 |
| `search:open [query=<text>]` | 在 Obsidian 中開啟搜尋檢視 |

### 連結與圖譜

| 指令 | 說明 |
|------|------|
| `backlinks [file=<name>] [path=<path>] [counts] [total]` | 列出指向某檔案的反向連結 |
| `links [file=<name>] [path=<path>] [total]` | 列出檔案中的外連結 |
| `unresolved [total] [counts] [verbose]` | 列出保管庫中未解析的連結 |
| `orphans [total] [all]` | 列出沒有被連結的孤立筆記 |
| `deadends [total] [all]` | 列出沒有外連結的死胡同筆記 |

### 標籤與屬性（Properties）

| 指令 | 說明 |
|------|------|
| `tags [all] [file=<name>] [path=<path>] [total] [counts] [sort=count]` | 列出標籤 |
| `tag name=<tag> [total] [verbose]` | 取得標籤詳細資訊 |
| `properties [all] [file=<name>] [path=<path>] [name=<name>] [total] [sort=count] [counts] [format=yaml\|tsv]` | 列出屬性 |
| `property:read name=<name> [file=<name>] [path=<path>]` | 讀取屬性值 |
| `property:set name=<name> value=<value> [type=...] [file=<name>] [path=<path>]` | 設定屬性 |
| `property:remove name=<name> [file=<name>] [path=<path>]` | 移除屬性 |
| `aliases [all] [file=<name>] [path=<path>] [total] [verbose]` | 列出別名 |

### 任務管理

| 指令 | 說明 |
|------|------|
| `tasks [all] [daily] [file=<name>] [path=<path>] [total] [done] [todo] [status="<char>"] [verbose]` | 列出任務 |
| `task [ref=<path:line>] [file=<name>] [path=<path>] [line=<n>] [toggle] [done] [todo] [daily] [status="<char>"]` | 顯示或更新任務 |

### 模板

| 指令 | 說明 |
|------|------|
| `templates [total]` | 列出模板 |
| `template:read name=<template> [resolve] [title=<title>]` | 讀取模板內容 |
| `template:insert name=<template>` | 在目前檔案插入模板 |

### 外掛管理

| 指令 | 說明 |
|------|------|
| `plugins [filter=core\|community] [versions]` | 列出已安裝外掛 |
| `plugins:enabled [filter=core\|community] [versions]` | 列出已啟用外掛 |
| `plugin id=<plugin-id>` | 取得外掛資訊 |
| `plugin:enable id=<id> [filter=core\|community]` | 啟用外掛 |
| `plugin:disable id=<id> [filter=core\|community]` | 停用外掛 |
| `plugin:install id=<id> [enable]` | 安裝社群外掛 |
| `plugin:uninstall id=<id>` | 移除社群外掛 |
| `plugin:reload id=<id>` | 重新載入外掛 |
| `plugins:restrict [on] [off]` | 切換限制模式 |

### 大綱與字數

| 指令 | 說明 |
|------|------|
| `outline [file=<name>] [path=<path>] [format=tree\|md] [total]` | 顯示標題大綱 |
| `wordcount [file=<name>] [path=<path>] [words] [characters]` | 統計字數 |

### 書籤

| 指令 | 說明 |
|------|------|
| `bookmarks [total] [verbose]` | 列出書籤 |
| `bookmark [file=<path>] [subpath=<subpath>] [folder=<path>] [search=<query>] [url=<url>] [title=<title>]` | 新增書籤 |

### 每日筆記（需透過 command 執行）

```bash
obsidian command id=daily-notes
```

### 版本歷史

| 指令 | 說明 |
|------|------|
| `history [file=<name>] [path=<path>]` | 列出檔案歷史版本 |
| `history:list` | 列出有歷史紀錄的檔案 |
| `history:read [file=<name>] [path=<path>] [version=<n>]` | 讀取歷史版本 |
| `history:restore [file=<name>] [path=<path>] version=<n>` | 還原歷史版本 |
| `diff [file=<name>] [path=<path>] [from=<n>] [to=<n>] [filter=local\|sync]` | 比對版本差異 |

### Bases（資料庫檢視）

| 指令 | 說明 |
|------|------|
| `bases` | 列出所有 base 檔案 |
| `base:views` | 列出目前 base 的檢視 |
| `base:create [name=<name>] [content=<text>] [silent] [newtab]` | 建立新項目 |
| `base:query [file=<name>] [path=<path>] [view=<name>] [format=json\|csv\|tsv\|md\|paths]` | 查詢 base |

### 工作區與分頁

| 指令 | 說明 |
|------|------|
| `workspace [ids]` | 顯示工作區樹狀結構 |
| `tabs [ids]` | 列出開啟的分頁 |
| `tab:open [group=<id>] [file=<path>] [view=<type>]` | 開啟新分頁 |
| `recents [total]` | 列出最近開啟的檔案 |

### 佈景主題與 CSS

| 指令 | 說明 |
|------|------|
| `themes [versions]` | 列出已安裝佈景主題 |
| `theme [name=<name>]` | 顯示或查詢佈景主題 |
| `theme:set name=<name>` | 設定佈景主題 |
| `theme:install name=<name> [enable]` | 安裝佈景主題 |
| `theme:uninstall name=<name>` | 移除佈景主題 |
| `snippets` | 列出 CSS 片段 |
| `snippets:enabled` | 列出已啟用 CSS 片段 |
| `snippet:enable name=<name>` | 啟用 CSS 片段 |
| `snippet:disable name=<name>` | 停用 CSS 片段 |

### 開發者工具

| 指令 | 說明 |
|------|------|
| `devtools` | 切換開發者工具 |
| `dev:debug [on] [off]` | 啟用/停用除錯器 |
| `dev:cdp method=<CDP.method> [params=<json>]` | 執行 Chrome DevTools Protocol 指令 |
| `dev:console [clear] [limit=<n>] [level=...]` | 顯示主控台訊息 |
| `dev:errors [clear]` | 顯示錯誤 |
| `dev:screenshot [path=<filename>]` | 截圖 |
| `dev:css selector=<css> [prop=<name>]` | 檢查 CSS |
| `dev:dom selector=<css> [total] [text] [inner] [all] [attr=<name>] [css=<prop>]` | 查詢 DOM |
| `dev:mobile [on] [off]` | 切換行動裝置模擬 |
| `eval code=<javascript>` | 執行 JavaScript |
