<<<<<<< HEAD
# My Cursor Skills

這是一個共用的 Cursor Agent Skills 資料庫，可以在不同專案中使用。

## 📁 檔案列表

- `git-workflow.md` - Git 和 GitHub 工作流程
- `powershell-common.md` - PowerShell 常用指令和技巧
- `troubleshooting.md` - 常見問題排解
- `cursor-tips.md` - Cursor AI 使用技巧

## 🔄 如何在專案中使用

### 方法 1：Git Submodule（推薦）

在任何專案中加入這個 skills 資料庫：

```powershell
cd <你的專案路徑>
git submodule add https://github.com/<你的用戶名>/my-skills.git skills
```

### 方法 2：直接 Clone

```powershell
git clone https://github.com/<你的用戶名>/my-skills.git C:\my-skills
```

## 📝 更新 Skills

當你在任何專案中更新了 skills 內容：

```powershell
cd C:\my-skills
git add .
git commit -m "Update skills"
git push
```

其他使用這個 skills 的專案會在下次更新時自動拉取新內容。

## 🎯 使用說明

這些 skill 檔案會被 Cursor AI 自動讀取，幫助 AI 更好地理解你的工作流程和常用指令。

當你在 Cursor 中問問題時，AI 會參考這些檔案提供更精準的答案。
=======
# my-skills
skills
>>>>>>> b046b068f6554b4d3f6a630aab434fad26284607
