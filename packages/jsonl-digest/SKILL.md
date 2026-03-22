---
name: jsonl-digest
description: >
  Extract knowledge from new Claude Code JSONL conversation logs and write to auto-memory.
  Auto mode (default): high-confidence memories written directly, medium/low silently skipped.
  Manual mode (--review): interactive review of each candidate.
  Use when: SessionStart hook reports [JSONL-DIGEST], or user says "/jsonl-digest",
  "萃取知識", "知識萃取", "extract knowledge", "digest conversations".
---

# JSONL Digest — 對話知識萃取

從新增的 Claude Code 對話紀錄中萃取知識，寫入 auto-memory。

## 模式

| 模式 | 觸發 | 行為 |
|------|------|------|
| **自排（預設）** | hook 輸出 `[JSONL-DIGEST]` 或使用者下 `/jsonl-digest` | 高信心直接寫入，中低信心跳過，輸出摘要 |
| **手排** | 使用者下 `/jsonl-digest --review` | 列出所有候選記憶，逐條等待確認 |

## 執行流程

### 第一步：定位新增對話

```bash
MARKER="$HOME/.claude/.last-jsonl-extraction"
find "$HOME/.claude/projects" -maxdepth 3 -name "*.jsonl" \
  -not -path "*/subagents/*" -newer "$MARKER" -type f 2>/dev/null
```

如果 marker 不存在或指令帶 `--all`，則掃描全部主對話（排除 subagents）。

按專案目錄分組，統計各專案新增對話數。如果沒有新增對話，輸出「無新增」後結束。

### 第二步：提取 AI 回應文字

對每個有新增對話的專案，用提取工具濃縮 JSONL：

```bash
# 只處理 marker 之後的新檔案
find <project-dir> -name "*.jsonl" -not -path "*/subagents/*" \
  -newer "$MARKER" -type f -exec \
  python3 ~/Downloads/Codebase/playground/claude-memory-ops/extract_ai_text.py {} + \
  > /tmp/jsonl-digest-<project-name>.txt 2>/dev/null
```

這一步把 JSONL（99.7% 元資料）濃縮成純 AI 回應文字（壓縮比約 300:1）。

### 第三步：評估知識價值 + 記憶健康檢查

讀取每個專案的提取文字，**同時**對現有記憶做健康檢查（邊際成本為零，因為已經在讀了）。

**3a. 新穎性檢查（最重要）**
- 讀取該專案 `~/.claude/projects/<encoded-path>/memory/` 下所有 .md 檔
- 如果已有實質相同的記憶 → **跳過**（寧可漏記也不要重複）

**3b. 價值分類**
- `user` — 使用者角色、偏好、知識水平、工作習慣
- `feedback` — 使用者對工作方式的糾正或肯定
- `project` — 專案脈絡、架構決策、進展、截止日期
- `reference` — 外部資源位置（文件、儀表板、工單系統）

**3c. 信心評分**
- **高信心**：使用者明確糾正的做法、有具體情境的踩坑經驗、附理由鏈的架構決策
- **中信心**：合理推論但缺乏使用者直接確認
- **低信心**：模糊、可能已過時、或推測性內容

**3d. 順手健康檢查（讀到每個記憶檔時順便做）**

既然已經把所有記憶檔讀進來了，順手檢查三件事：

1. **過期檢查**（依 frontmatter 和檔案日期）：
   - 工具/版本相關（`reference_tech_*`）：建立超過 90 天 → 標為 `⏰ 待確認`
   - 架構/設計 pattern（`project_*`）：建立超過 180 天 → 標為 `⏰ 待確認`
   - 使用者偏好/慣例（`user_*`, `feedback_*`）：建立超過 365 天 → 標為 `⏰ 待確認`

2. **閒置檢查**：最後修改超過 60 天 → 標為 `stale`
   - 豁免：description 中標註「永久有效」的檔案

3. **品質檢查**：frontmatter 缺 name/description/type 任一欄位 → 標為 `⚠️ 不完整`

**不自動刪除或修改任何既有記憶。** 只收集發現，在摘要中報告。

### 第四步：寫入記憶

**自排模式（預設）**：
- 只寫入**高信心**的記憶
- 每條記憶寫為獨立 .md 檔，格式：

```markdown
---
name: {{記憶名稱}}
description: {{一行描述，具體到足以判斷相關性}}
type: {{user|feedback|project|reference}}
---

{{記憶內容。feedback/project 類型需附 **Why:** 和 **How to apply:** 行}}
```

- 檔案命名：`<type>_<topic>.md`（如 `feedback_testing_strategy.md`）
- 更新該專案 `memory/MEMORY.md` 索引（新增指向新檔的連結）
- 中低信心 → 靜默跳過

**手排模式**（`--review`）：
- 列出**所有**候選記憶（含高/中/低信心）
- 每條顯示：分類、信心、來源 session、內容預覽
- 等待使用者逐條決定：✅ 寫入 / ❌ 跳過 / ✏️ 修改後寫入
- 確認後才寫入

### 第五步：收尾

```bash
touch ~/.claude/.last-jsonl-extraction
```

輸出摘要：

```
萃取完成：掃描 N 個新對話（M 個專案）
  - 寫入 X 條新記憶（高信心）
  - 跳過 Y 條（中低信心 / 已存在）
  - 專案分佈：ProjectA +3, ProjectB +1

記憶健康：檢查了 Z 個既有記憶檔
  - ⏰ 過期待確認：A 條
  - stale（60 天未修改）：B 條
  - ⚠️ frontmatter 不完整：C 條
  → 執行 /memory-cleanup 可處理這些項目
```

如果健康檢查全部通過，只輸出一行「記憶健康：Z 個檔案全部正常」。
有問題時才展開細節——零噪音原則。

## 平行處理

- **2 個以上專案**有新對話時：為每個專案派一個背景代理（Agent tool, run_in_background: true），平行處理
- 每個代理的指令模板：

```
你是知識萃取代理。任務：
1. 讀取 /tmp/jsonl-digest-<project>.txt
2. 讀取 ~/.claude/projects/<encoded-path>/memory/ 下所有 .md 檔
3. 找出提取文字中尚未被記憶捕捉的高價值知識
4. 評估新穎性、分類、信心
5. [自排] 高信心的直接寫入 auto-memory；[手排] 回傳候選列表
6. 順手檢查每個既有記憶檔的健康狀態（過期/閒置/frontmatter 不完整）
7. 回傳摘要：新增幾條、跳過幾條、健康問題幾條
```

- **1 個專案**：直接在主 session 中處理，不派代理

## 自動觸發

SessionStart hook（`~/.claude/scripts/check-new-jsonl.sh`）偵測新 JSONL 後輸出 `[JSONL-DIGEST]` 標籤。全域 CLAUDE.md 中的指令讓 Claude 看到標籤時自動以背景代理執行此技能，不阻塞使用者的主要工作。

## 安全規則

- **禁止記錄**：憑證、金鑰、內部網址、個人資料
- **重複檢查優先**：寧可漏記也不要重複寫入
- **記憶格式**：嚴格遵循 auto-memory frontmatter 規範
- **不修改既有記憶**：只新增，不覆寫
- **marker 必須更新**：萃取完成後務必 touch marker 檔，否則下次會重複處理
