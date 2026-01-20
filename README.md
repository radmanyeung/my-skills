# My Cursor Skills

這是一個共用的 Cursor Agent Skills 資料庫，包含自訂 skills 和從優秀開源專案同步的 skills。

---

## 📁 檔案結構

```
my-skills/
├── git-workflow.md              # Git 和 GitHub 工作流程
├── powershell-common.md         # PowerShell 常用指令和技巧
├── troubleshooting.md           # 常見問題排解
├── cursor-tips.md               # Cursor AI 使用技巧
├── external-skills/             # 外部來源的 skills（自動同步）
│   ├── awesome-claude-skills/   # ComposioHQ 官方收藏
│   ├── awesome-claude-skills-2/ # BehiSecc 收藏
│   ├── claude-code-infrastructure/
│   ├── superpowers/
│   ├── skill-seekers/
│   └── INDEX.md                 # 外部 skills 索引
├── .sources.json                # 外部來源配置
└── sync_external_skills.ps1     # 同步腳本
```

---

## 🌟 Skills 來源

### 自訂 Skills（4 個）
這些是專門為你的工作流程建立的：
- `git-workflow.md` - Git 操作、Tag、Release、Submodule
- `powershell-common.md` - 檔案操作、迴圈、變數、系統操作
- `troubleshooting.md` - Git、Python、FFmpeg、GPU 問題排解
- `cursor-tips.md` - Cursor AI 使用技巧和最佳實踐

### 外部 Skills（5 個來源）
從優秀的開源專案同步：
1. **ComposioHQ/awesome-claude-skills** - 官方 awesome skills 集合
2. **BehiSecc/awesome-claude-skills** - 社群精選 skills
3. **diet103/claude-code-infrastructure** - 生產環境實戰基礎設施
4. **obra/superpowers** - Agentic skills 框架和開發方法論
5. **yusufkaraaslan/Skill_Seekers** - 從文檔自動生成 skills 的工具

---

## 🔄 如何在專案中使用

### 方法 1：Git Submodule（推薦）

在任何專案中加入這個 skills 資料庫：

```powershell
cd <你的專案路徑>
git submodule add git@github.com:radmanyeung/my-skills.git skills
git submodule init
git submodule update
```

### 方法 2：直接 Clone

```powershell
git clone git@github.com:radmanyeung/my-skills.git C:\my-skills
```

---

## 📥 同步外部 Skills

### 手動執行同步

```powershell
cd C:\my-skills
.\sync_external_skills.ps1
```

**這個腳本會：**
1. ✅ 從 5 個 GitHub repos 克隆/更新最新內容
2. ✅ 複製相關的 skill 檔案到 `external-skills/`
3. ✅ 為每個檔案標記來源和同步時間
4. ✅ 生成索引檔案 `external-skills/INDEX.md`

### 何時執行同步？

建議每 1-2 週執行一次，或當你需要最新的 skills 時。

```powershell
# 快速檢查是否有更新
cd C:\my-skills
git status external-skills/

# 同步外部 skills
.\sync_external_skills.ps1

# 提交更新
git add .
git commit -m "Update external skills ($(Get-Date -Format 'yyyy-MM-dd'))"
git push
```

---

## 📝 更新 Skills

### 更新自訂 Skills

當你修改了 `git-workflow.md`、`powershell-common.md` 等檔案：

```powershell
cd C:\my-skills
git add git-workflow.md powershell-common.md
git commit -m "Update custom skills"
git push
```

### 更新外部 Skills

執行同步腳本即可：

```powershell
.\sync_external_skills.ps1
git add external-skills/
git commit -m "Sync external skills"
git push
```

---

## 🎯 在 Cursor 中使用

### 引用自訂 Skills

```
@skills/git-workflow.md
@skills/powershell-common.md
```

### 引用外部 Skills

```
@skills/external-skills/awesome-claude-skills/some-skill.md
@skills/external-skills/superpowers/skills/test-driven-development/SKILL.md
```

### 在 Subtool 專案中使用（my-skills 作為 submodule）

```
# Cursor 會自動找到 skills
@skills/git-workflow.md
@skills/external-skills/superpowers/skills/brainstorming/SKILL.md
```

---

## 📖 查看可用的 Skills

### 查看自訂 Skills

```powershell
ls C:\my-skills\*.md
```

### 查看外部 Skills

```powershell
# 查看索引
cat C:\my-skills\external-skills\INDEX.md

# 查看特定來源
ls C:\my-skills\external-skills\superpowers\skills\
ls C:\my-skills\external-skills\awesome-claude-skills\
```

---

## ⚙️ 設定檔

### `.sources.json`

記錄 5 個外部 repos 的來源資訊：
- Repository URL
- 要同步的檔案路徑
- 排除的檔案
- 上次同步時間

如果你想修改同步邏輯，編輯這個檔案。

---

## 🚀 快速開始（第一次使用）

```powershell
# 1. Clone my-skills
git clone git@github.com:radmanyeung/my-skills.git C:\my-skills
cd C:\my-skills

# 2. 同步外部 skills（首次約 2-3 分鐘）
.\sync_external_skills.ps1

# 3. 檢查結果
cat external-skills\INDEX.md
ls external-skills\

# 4. 在你的專案中使用（例如 subtool）
cd C:\subtool
git submodule add git@github.com:radmanyeung/my-skills.git skills
git add .
git commit -m "Add my-skills submodule with external skills"
git push
```

---

## 🔗 外部來源連結

- [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
- [BehiSecc/awesome-claude-skills](https://github.com/BehiSecc/awesome-claude-skills)
- [diet103/claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase)
- [obra/superpowers](https://github.com/obra/superpowers)
- [yusufkaraaslan/Skill_Seekers](https://github.com/yusufkaraaslan/Skill_Seekers)

---

## ⚠️ 注意事項

### 自訂 Skills
- ✅ 可以隨時編輯
- ✅ 修改後 commit 並 push
- ✅ 其他專案會自動同步

### 外部 Skills
- ⚠️ **請勿直接編輯** - 會在下次同步時被覆蓋
- ✅ 所有檔案都標記了來源和同步時間
- ✅ 如果想保留修改，請複製到自訂 skills 或另存為新檔案

---

## 📊 統計

- **自訂 Skills:** 4 個
- **外部來源:** 5 個 GitHub repositories
- **外部 Skills:** 執行 `.\sync_external_skills.ps1` 後查看具體數量

---

**上次更新:** 2026-01-20
