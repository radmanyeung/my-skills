# SubTool Agent Skill

這是 SubTool 專案的 Agent Skill 檔案，幫助 AI 更好地協助你處理常見任務。

---

## 🎯 專案概述

SubTool 是一套影片字幕自動化處理工具，主要包含：
- 語音轉文字（Whisper）
- PDF 詞彙表生成
- 字幕品質檢查
- Git 版本管理

---

## 📋 常見任務快速參考

### 1. 處理單個影片

```powershell
# 基本用法
.\split_whisper_merge_v13.ps1 -In "video.mp4"

# 中文影片
.\split_whisper_merge_v13.ps1 -In "video.mp4" -Lang zh

# 高品質模式
.\split_whisper_merge_v13.ps1 -In "video.mp4" -UseJsonAlign -SnapToSilence
```

### 2. 批次處理資料夾

```powershell
# 處理整個資料夾
.\split_whisper_merge_v13.ps1 -Folder "C:\videos"

# 選單選項：
#   [2] 跳過已有 SRT 的檔案（最常用）
#   [3] 只處理有 glossary 的檔案
```

### 3. 從 PDF 生成詞彙表

```powershell
# 單個 PDF
.\make_gloss_from_pdf_v5.ps1 -File "lecture.pdf"

# 批次處理（跳過已處理）
.\make_gloss_from_pdf_v5.ps1 -Folder "C:\course" -DaysBack 7 -SkipExisting
```

### 4. 每週自動處理

```powershell
# 最常用：手動確認模式
.\weekly_process.ps1 -SkipExisting

# 完全自動化（適合排程）
.\weekly_process.ps1 -AutoTranscribe -SkipExisting
```

### 5. 字幕品質檢查

```powershell
# 使用 PowerShell 7+
pwsh .\QC-Srt.ps1 -Srt "video.srt"
```

---

## 🔄 Git 工作流程

### 推送變更到 GitHub

```powershell
# 互動式 commit + push
.\sync_push.ps1

# 選項說明：
#   [Y] 使用建議的 commit 訊息
#   [E] 自訂 commit 訊息
#   [N] WIP 自動同步
```

### 建立 Release（重要！）

⚠️ `sync_push.ps1` 不會建立 Release，需要手動建立：

```powershell
# 1. 確認已 push
git push

# 2. 建立 tag
git tag v1.0.0

# 3. Push tag
git push --tags

# 4. 建立 Release
gh release create v1.0.0 --title "版本 1.0.0" --notes "更新說明"
```

### 第二部電腦同步

```powershell
# 第一次（需要 repo URL）
git clone <repo_url> C:\subtool

# 已有資料夾（更新）
cd C:\subtool
git pull
```

---

## 🛠️ 常見問題快速解決

### Git 相關

**Q: 第二部電腦 git 無法辨識**
```powershell
# 安裝 Git
winget install --id Git.Git -e --source winget
# 重開 PowerShell
```

**Q: 取得 repo URL**
```powershell
cd C:\subtool
git remote -v
```

**Q: GitHub 看不到 Release**
```
原因：sync_push.ps1 只做 commit + push，不建立 Release
解法：手動建立 tag 和 release（見上方「建立 Release」）
```

### 工具相關

**Q: 找不到 FFmpeg**
```powershell
winget install -e --id Gyan.FFmpeg
```

**Q: GPU 記憶體不足**
```powershell
# 減少 worker 數量
.\split_whisper_merge_v13.ps1 -In "video.mp4" -WorkersMap "0=1"
```

**Q: pdftotext 找不到**
```
1. 下載 Xpdf tools
2. 指定完整路徑：-PdfToText "C:\Tools\xpdf\pdftotext.exe"
```

---

## 📁 檔案結構

```
C:\subtool\
├── split_whisper_merge_v13.ps1    # 語音轉文字（主要工具）
├── make_gloss_from_pdf_v5.ps1     # PDF 詞彙表生成
├── weekly_process.ps1             # 每週自動處理
├── QC-Srt.ps1                     # 字幕品質檢查
├── sync_push.ps1                  # Git 推送
├── srt_postprocess.py             # SRT 後處理
├── translate_and_format.py        # 雙語字幕處理
├── README.md                      # 完整文檔
├── README_v12_and_glossary.md     # v12 詳細說明
├── WEEKLY_USAGE.md                # 每週處理指南
└── CHANGES_SUMMARY.md             # 更新摘要
```

---

## 🔍 檢查當前狀態

### 查看 Git 狀態
```powershell
cd C:\subtool
git status
```

### 查看檔案清單
```powershell
Get-ChildItem C:\subtool
```

### 查看 Git remote
```powershell
git remote -v
```

### 查看 GPU 狀態
```powershell
nvidia-smi
```

---

## 💡 最佳實踐

### 處理新課程影片的完整流程

```powershell
# Step 1: 生成詞彙表
.\make_gloss_from_pdf_v5.ps1 -Folder "C:\Course\Week1"

# Step 2: 生成字幕
.\split_whisper_merge_v13.ps1 -Folder "C:\Course\Week1"
# 選擇 [3] 只處理有 TXT 的檔案

# Step 3: 品質檢查
pwsh .\QC-Srt.ps1 -Srt "C:\Course\Week1\Lesson1.srt"

# Step 4: 推送到 GitHub
.\sync_push.ps1
```

### 每週例行作業

```powershell
# 每週一執行，自動處理新檔案
.\weekly_process.ps1 -SkipExisting
```

### GPU 最佳配置

```powershell
# 單 GPU (8GB+)
-WorkersMap "0=2"

# 雙 GPU
-WorkersMap "0=2,1=2"

# 記憶體不足時
-WorkersMap "0=1,1=1"
```

---

## 🎯 AI Assistant 指引

當用戶詢問相關問題時：

1. **關於 Git/Release**：提醒 sync_push.ps1 不會建立 Release，需要手動建立 tag
2. **第二部電腦同步**：先確認是否已安裝 Git，再提供 clone 或 pull 指令
3. **處理影片**：優先詢問是單檔還是批次、是否需要詞彙表
4. **記憶體問題**：建議減少 WorkersMap 或使用較小模型
5. **修改檔案前**：一定要先說明原因和影響，獲得同意後才修改

---

## 📝 版本資訊

- **當前版本**：v13 (split_whisper_merge), v5 (make_gloss_from_pdf)
- **最後更新**：2025-01-19
- **主要工具數量**：8 個

---

## 🔗 相關資源

- GitHub Release 教學：見 README.md「Git 同步與版本管理」章節
- 詳細參數說明：見 README.md
- 每週處理指南：見 WEEKLY_USAGE.md
- 版本變更：見 CHANGES_SUMMARY.md
