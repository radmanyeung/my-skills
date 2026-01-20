# 快速開始指南

## 📚 你現在有什麼？

### 自訂 Skills（4 個）
- `git-workflow.md` - Git 和 GitHub 工作流程
- `powershell-common.md` - PowerShell 常用指令
- `troubleshooting.md` - 常見問題排解
- `cursor-tips.md` - Cursor AI 使用技巧

### 外部 Skills（217 個檔案，來自 5 個 repos）
1. **awesome-claude-skills** (56 files) - ComposioHQ 官方收藏
2. **awesome-claude-skills-2** (0 files) - BehiSecc 收藏
3. **claude-code-infrastructure** (47 files) - 生產環境基礎設施
4. **superpowers** (50 files) - Agentic skills 框架
5. **skill-seekers** (64 files) - 文檔轉 skills 工具

---

## 🔄 如何更新外部 Skills

### 方法 1：手動執行（推薦）

```powershell
cd C:\my-skills
.\sync_external_skills.ps1
```

**時間：** 約 15-30 秒

**結果：**
- 更新所有 5 個 repos 的最新內容
- 自動複製 skills 到 `external-skills/`
- 生成更新的索引檔案

### 方法 2：查看當前內容

```powershell
# 查看索引
cat C:\my-skills\external-skills\INDEX.md

# 瀏覽 superpowers skills
ls C:\my-skills\external-skills\superpowers\skills\

# 瀏覽 awesome-claude-skills
ls C:\my-skills\external-skills\awesome-claude-skills\
```

---

## 📖 如何在 Cursor 中使用

### 引用自訂 Skills

```
@skills/git-workflow.md
@skills/powershell-common.md
@skills/troubleshooting.md
```

### 引用外部 Skills

```
@skills/external-skills/superpowers/skills/test-driven-development/SKILL.md
@skills/external-skills/awesome-claude-skills/mcp-builder/SKILL.md
@skills/external-skills/claude-code-infrastructure/.claude/skills/backend-dev-guidelines/SKILL.md
```

---

## 🎯 推薦的外部 Skills

### 開發流程
- `superpowers/skills/brainstorming/SKILL.md` - 設計討論
- `superpowers/skills/test-driven-development/SKILL.md` - TDD 開發
- `superpowers/skills/systematic-debugging/SKILL.md` - 系統化除錯
- `superpowers/skills/writing-plans/SKILL.md` - 撰寫實作計劃

### Claude Code 基礎設施
- `claude-code-infrastructure/.claude/skills/backend-dev-guidelines/SKILL.md` - 後端開發指南
- `claude-code-infrastructure/.claude/skills/frontend-dev-guidelines/SKILL.md` - 前端開發指南
- `claude-code-infrastructure/.claude/agents/code-architecture-reviewer.md` - 架構審查

### 文檔和工具
- `awesome-claude-skills/mcp-builder/SKILL.md` - 建立 MCP servers
- `awesome-claude-skills/skill-creator/SKILL.md` - 建立新 skills
- `awesome-claude-skills/document-skills/` - 處理 Word/PDF/Excel

---

## 🔧 建議的工作流程

### 每週更新（建議）

```powershell
# 1. 更新 my-skills
cd C:\my-skills
git pull

# 2. 同步外部 skills
.\sync_external_skills.ps1

# 3. 提交更新（如果有變化）
git add external-skills/
git commit -m "Update external skills ($(Get-Date -Format 'yyyy-MM-dd'))"
git push

# 4. 更新 subtool 專案的 submodule（如果使用）
cd C:\subtool
git submodule update --remote
```

**時間：** 1-2 分鐘

---

## 💡 常見使用情境

### 情境 1：開始新功能開發

```
在 Cursor 中：
"使用 @skills/external-skills/superpowers/skills/brainstorming/SKILL.md 
幫我設計一個新的用戶認證功能"
```

### 情境 2：除錯問題

```
在 Cursor 中：
"根據 @skills/external-skills/superpowers/skills/systematic-debugging/SKILL.md
幫我系統化地找出這個 bug 的根本原因"
```

### 情境 3：程式碼審查

```
在 Cursor 中：
"使用 @skills/external-skills/claude-code-infrastructure/.claude/agents/code-architecture-reviewer.md
審查這段程式碼的架構"
```

---

## 📊 統計資訊

- **自訂 Skills:** 4 個
- **外部來源:** 5 個 GitHub repositories
- **外部 Skills:** 217 個檔案
- **總大小:** 約 50-100 MB
- **上次同步:** 查看 `external-skills/INDEX.md`

---

## 🆘 需要幫助？

### 問題 1：同步失敗

```powershell
# 檢查網路連接
ping github.com

# 重新同步（會強制更新）
.\sync_external_skills.ps1
```

### 問題 2：找不到某個 skill

```powershell
# 搜尋 skill
Get-ChildItem -Path C:\my-skills\external-skills -Recurse -Filter "*test-driven*"
```

### 問題 3：Cursor 沒有顯示 skills

- 確保 my-skills 是 subtool 的 submodule
- 重啟 Cursor
- 檢查路徑是否正確

---

## 🔗 資源連結

- **GitHub Repo:** https://github.com/radmanyeung/my-skills
- **完整文檔:** `README.md`
- **外部 Skills 索引:** `external-skills/INDEX.md`

---

**建立日期:** 2026-01-20
**上次更新:** 2026-01-20
