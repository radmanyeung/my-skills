# Git Workflow Skills

## 🔄 基本 Git 操作

### 查看狀態
```powershell
git status
git log --oneline -10
git diff
```

### Commit 和 Push
```powershell
# 查看變更
git status
git diff

# 加入 staging
git add .
# 或指定檔案
git add README.md

# Commit
git commit -m "更新說明"

# Push
git push
```

---

## 🏷️ Tag 和 Release

### Tag 是什麼？
- Git 的版本標記（bookmark）
- 只是一個版本號（例如 v1.0.0）
- 存在 Git 歷史中

### Release 是什麼？
- GitHub 的發布版本
- 基於 tag 建立
- 包含說明、附件檔案、原始碼下載

### 建立 Tag
```powershell
# 建立 tag
git tag v1.0.0

# Push tag
git push --tags

# 查看所有 tags
git tag -l

# 刪除 tag（本機）
git tag -d v1.0.0

# 刪除 tag（遠端）
git push --delete origin v1.0.0
```

### 建立 Release（方法 1：GitHub CLI）
```powershell
# 先確認已 push
git push

# 建立 tag
git tag v1.0.0

# Push tag
git push --tags

# 建立 Release
gh release create v1.0.0 --title "版本 1.0.0" --notes "更新說明"
```

### 建立 Release（方法 2：GitHub 網頁）
1. 前往 GitHub repo
2. 點選「Releases」→「Create a new release」
3. 填寫 Tag version（例如 v1.0.0）
4. 填寫 Release title 和說明
5. 點選「Publish release」

---

## 🔄 Git Submodule

### 加入 Submodule
```powershell
cd <專案路徑>
git submodule add <repo_url> <資料夾名稱>

# 例如
git submodule add https://github.com/username/my-skills.git skills
```

### 更新 Submodule
```powershell
# 拉取最新版本
git submodule update --remote

# 或進入 submodule 資料夾
cd skills
git pull
```

### Clone 包含 Submodule 的專案
```powershell
# 方法 1：Clone 時一起下載
git clone --recurse-submodules <repo_url>

# 方法 2：Clone 後再下載
git clone <repo_url>
cd <repo_path>
git submodule init
git submodule update
```

---

## 💻 多台電腦同步

### 第一次設定（Clone）
```powershell
# 先確認已安裝 Git
git --version

# 如果未安裝
winget install --id Git.Git -e --source winget

# Clone 專案
git clone <repo_url> <target_path>

# 如果包含 submodule
git clone --recurse-submodules <repo_url> <target_path>
```

### 更新到最新版本（Pull）
```powershell
cd <專案路徑>

# 拉取最新變更
git pull

# 如果有 submodule，也要更新
git submodule update --remote
```

### 取得 Repo URL
```powershell
cd <專案路徑>
git remote -v

# 輸出類似：
# origin  https://github.com/username/repo.git (fetch)
# origin  https://github.com/username/repo.git (push)
```

---

## 🐛 常見問題

### Q: sync_push.ps1 後 GitHub 看不到 Release
```
原因：sync_push.ps1 只做 commit + push，不會建立 tag 或 Release
解法：需要手動建立 tag 和 release（見上方步驟）
```

### Q: 第二部電腦 git 無法辨識
```powershell
# 安裝 Git
winget install --id Git.Git -e --source winget

# 重開 PowerShell
```

### Q: Push 時要求輸入帳號密碼
```
原因：GitHub 已不支援密碼驗證
解法：使用 Personal Access Token 或 SSH Key
```

### Q: 衝突（Conflict）
```powershell
# 查看衝突檔案
git status

# 編輯衝突檔案，解決衝突

# 標記為已解決
git add <衝突檔案>

# 完成 merge
git commit
```

---

## 📋 Git 最佳實踐

### Commit Message 格式
```
類型: 簡短說明（50字以內）

詳細說明（可選）

常用類型：
- feat: 新增功能
- fix: 修復 bug
- docs: 文檔更新
- style: 格式調整
- refactor: 重構
- test: 測試
- chore: 其他雜項
```

### Branch 策略
```powershell
# 建立新 branch
git checkout -b feature/new-feature

# 切換 branch
git checkout main

# 合併 branch
git checkout main
git merge feature/new-feature

# 刪除 branch
git branch -d feature/new-feature
```

---

## 🔗 相關資源

- [GitHub CLI 文檔](https://cli.github.com/)
- [Git Submodule 教學](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Git 官方文檔](https://git-scm.com/doc)
