# SOP：跨機設定檔同步維運手冊

> 適用範圍：主力機（M4 Mac Pro）與備用機（M1 MacBook Pro）之間的殼層環境、AI 工具設定、Claude Code 插件同步。
> 最後更新：2026-03-22

---

## 一、架構概述

```
主力機（M4）              ──單向推送──>              備用機（M1）
~/.zshrc                                           ~/.zshrc（覆寫）
~/.claude/settings.json                            ~/.claude/settings.json（覆寫）
~/.claude/plugins/                                 ~/.claude/plugins/（rsync 增量）
...                                                ~/.zshrc.local（不動，M1 專屬）
                                                   ~/.env（不動，M1 專屬）
                                                   ~/.openclaw/（不動，M1 專屬）
```

**核心原則**：
- 主力機是唯一事實來源，同步永遠是單向的（主力機 → 遠端）
- 機器專屬設定隔離在 `.local` 檔案和 `.env` 中，同步腳本永遠不碰
- 同步腳本整合在 `~/Downloads/Codebase/playground/skills/sync.sh`

---

## 二、日常操作

### 2.1 同步設定檔（最常用）

```bash
cd ~/Downloads/Codebase/playground/skills
./sync.sh --dotfiles m1
```

這會執行：
1. 驗證 SSH 連線
2. 在 M1 建立時間戳備份（`~/shell-backup-YYYYMMDD-HHMMSS/`）
3. 複製 16 個設定檔（scp）
4. 推送 SSH config 並驗證語法（失敗自動還原）
5. 同步 3 個目錄（rsync 增量，不刪除遠端多出的檔案）
6. 合併 1 個 JSON（Claude plugins，保留 M1 獨有插件）

### 2.2 預覽（不實際執行）

```bash
./sync.sh --dotfiles m1 --dry-run
```

### 2.3 含套件補裝

```bash
./sync.sh --dotfiles m1 --with-packages
```

額外在 M1 補裝缺少的 Homebrew 套件（git-lfs、tree、tmux、pyenv、neovim、powershell）、Homebrew cask（copilot-cli）、npm 全域套件（codex、gemini-cli）。

### 2.4 同步 skills（獨立指令）

```bash
./sync.sh          # 完整同步：git pull + push + 分發到所有 Agent
./sync.sh --pull   # 只拉取遠端
./sync.sh --local  # 只分發到本機 Agent
```

---

## 三、同步項目清單

完整清單定義在 `dotfiles/manifest.yaml`，修改此檔案即可增減同步項目。

### 3.1 直接覆寫（copy）

| 類別 | 檔案 |
|------|------|
| 殼層 | `~/.zshrc`、`~/.zprofile`、`~/.zshenv`、`~/.p10k.zsh` |
| Git | `~/.gitconfig` |
| Claude Code | `~/.claude/settings.json`、`~/.claude/CLAUDE.md`、`~/.claude/LEARNINGS.md` |
| AI 工具 | `~/.codex/config.toml`、`~/.codex/AGENTS.md`、`~/.gemini/settings.json` |
| Espanso | `~/Library/Application Support/espanso/config/default.yml`、`~/Library/Application Support/espanso/match/base.yml` |
| GitHub CLI | `~/.config/gh/config.yml`、`~/.config/gh/hosts.yml` |

### 3.2 高風險覆寫（copy_verify_ssh）

| 檔案 | 驗證方式 |
|------|---------|
| `~/.ssh/config` | 推送後在遠端執行 `ssh -G localhost` 驗證語法。失敗時自動從備份還原。 |

### 3.3 目錄同步（rsync）

| 目錄 | 說明 |
|------|------|
| `~/.claude/plugins/cache/` | Claude Code 插件快取 |
| `~/.claude/plugins/marketplaces/` | 插件市場 Git 複本 |
| `~/.config/ghostty/` | Ghostty 終端設定 |

### 3.4 JSON 合併（merge_json）

| 檔案 | 邏輯 |
|------|------|
| `~/.claude/plugins/installed_plugins.json` | 主力機全部插件 + M1 獨有的插件（如 `ralph-skills`）保留 |

### 3.5 永遠不同步

| 檔案 | 原因 |
|------|------|
| `~/.zshrc.local` | M1 專屬（OpenClaw 補全、brew shellenv） |
| `~/.claude/settings.local.json` | 機器專屬覆寫 |
| `~/.env` | 密鑰各機獨立 |
| `~/.openclaw/` | OpenClaw 完整安裝，不干涉 |

---

## 四、新增同步項目

編輯 `dotfiles/manifest.yaml`：

```yaml
# 新增一個檔案到 copy 區塊
copy:
  - ~/.new-config-file    # 新增這行

# 新增一個目錄到 rsync 區塊
rsync:
  - ~/.config/new-tool/   # 尾部斜線必須有
```

修改後直接執行 `./sync.sh --dotfiles m1 --dry-run` 確認清單正確。

---

## 五、新增目標機器

腳本的 `<host>` 參數對應 SSH 主機名稱（定義在 `~/.ssh/config`）。

新增步驟：
1. 確保新機器可透過 SSH 連線（加入 `~/.ssh/config`）
2. 在新機器建立 `~/.zshrc.local`（機器專屬設定）
3. 在新機器建立 `~/.env`（機器專屬密鑰）
4. 執行：`./sync.sh --dotfiles <new-host> --with-packages`

---

## 六、M1 機器專屬設定

M1 有兩個專屬檔案，同步腳本永遠不會碰它們。如需修改，必須 SSH 到 M1 手動編輯。

### `~/.zshrc.local`

```bash
# Homebrew（M1 的 .zprofile 沒有 brew shellenv）
eval "$(/opt/homebrew/bin/brew shellenv)"

# npm 全域路徑
export PATH="$PATH:$(npm prefix -g)/bin"

# OpenClaw 自動補全
[[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]] && \
  source "$HOME/.openclaw/completions/openclaw.zsh"

# OpenClaw 包裝函式
openclaw() {
  command openclaw "$@"
  local cmd="$1"
  if [[ "$cmd" == "update" || "$cmd" == "onboard" ]]; then
    ~/.openclaw/scripts/sanitize-config.sh
  fi
}
```

### `~/.env`

M1 專屬的 API 密鑰（OPENCLAW_AUTH_TOKEN、TELEGRAM_BOT_TOKEN、AWS 憑證等），格式為 `export KEY=value`。

---

## 七、故障排除

### 同步後 M1 殼層異常

```bash
# 從主力機 SSH 進 M1，強制用 bash 繞過 zsh 問題
ssh m1 'bash'

# 從備份還原
cp ~/shell-backup-YYYYMMDD-HHMMSS/.zshrc ~/.zshrc
exec zsh -l
```

### SSH config 推壞導致 SSH 連不上

不會發生——腳本推送後會用 `ssh -G localhost` 驗證語法，失敗時自動還原。如果真的連不上（例如網路問題），可以用 Tailscale 管理面板或實體操作 M1。

### 特定檔案同步失敗

腳本不會因單一檔案失敗而中斷，會繼續處理其餘項目。失敗項目會在最終摘要報告中列出：

```
⚠️  失敗項目：
  - ~/.codex/AGENTS.md（本機不存在）
```

### scp 含空格路徑失敗

Espanso 設定路徑含空格（`~/Library/Application Support/...`）。如果失敗，確認 manifest.yaml 中路徑沒有被引號包住（yq 會自動處理）。

---

## 八、已知限制

1. **密鑰不同步**：兩台機器的 `~/.env` 各自管理，新增 API 密鑰時需手動同步
2. **Claude Code plugins 的 `enabledPlugins` 欄位**：M1 的 `settings.json` 被主力機版本覆寫後，可能需要在 M1 重新啟用特定插件（如 `ralph-skills`）
3. **cmux 不在 M1 上**：`.zshrc` 中的 `cmux-claude` 函式在 M1 會靜默失敗（有路徑檢查）
4. **同日多次執行**：每次都會建立新備份目錄，長期會累積。建議定期清理 M1 上的 `~/shell-backup-*`

---

## 九、定期維護

| 週期 | 動作 |
|------|------|
| 每週 | `./sync.sh --dotfiles m1`（保持設定一致） |
| 每月 | `./sync.sh --dotfiles m1 --with-packages`（補裝新套件） |
| 每季 | 清理 M1 上的舊備份：`ssh m1 "ls -d ~/shell-backup-* \| head -n -5 \| xargs rm -rf"` |
| 需要時 | 編輯 `dotfiles/manifest.yaml` 增減同步項目 |
