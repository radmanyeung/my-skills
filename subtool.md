# SubTool 專案 Skills

這是 SubTool 專案特定的 skill 檔案，包含常用指令和工作流程。

---

## 🎯 專案概述

SubTool 是一套影片字幕自動化處理工具，主要包含：
- 語音轉文字（Whisper）
- PDF 詞彙表生成
- 字幕品質檢查
- Git 版本管理

---

## 🖥️ 圖形界面（GUI）⭐ 新功能

### 啟動 GUI

```powershell
# 啟動圖形界面（推薦新手使用）
.\split_whisper_merge_GUI.ps1
```

**GUI 優勢：**
- ✅ 友善的視覺化界面
- ✅ FCCI 最佳參數一鍵套用
- ✅ 即時指令預覽
- ✅ 參數提示說明
- ✅ 不需記憶 66 個參數

**詳細說明：** 查看 `GUI_使用指南.md`

---

## 📋 常見任務快速參考

### 1. 處理單個影片

```powershell
# 方法 1：使用 GUI（推薦）⭐
.\split_whisper_merge_GUI.ps1

# 方法 2：指令列
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

## ⚙️ 常用參數組合

### FCCI 專案最佳參數（最常用）⭐

```powershell
.\split_whisper_merge_v13.ps1 `
  -Folder "C:\Users\user\Documents\FCCI" `
  -SegParts 6 `
  -Beam 10 `
  -CarryInitialPrompt `
  -UseJsonAlign `
  -SegOverlapSec 3.0 `
  -SnapToSilence `
  -ShowContext `
  -ShowGpuSummary `
  -LiveLogs `
  -MaxCueSec 6 `
  -MaxLineChars 55 `
  -MaxLines 2
```

**參數說明：**
- `SegParts 6` - 分成 6 段處理
- `Beam 10` - 使用較高的 beam size（更準確）
- `CarryInitialPrompt` - 將詞彙表傳遞到所有片段
- `UseJsonAlign` - 使用 JSON 字級對齊（更精確）
- `SegOverlapSec 3.0` - 片段重疊 3 秒（去重）
- `SnapToSilence` - 對齊到靜音點
- `ShowContext` - 顯示使用的詞彙表
- `ShowGpuSummary` - 顯示 GPU 使用摘要
- `LiveLogs` - 即時顯示處理日誌
- `MaxCueSec 6` - 每條字幕最長 6 秒
- `MaxLineChars 55` - 每行最多 55 字元
- `MaxLines 2` - 每條字幕最多 2 行

**適用情境：**
- ✅ FCCI 課程影片
- ✅ 需要高品質字幕
- ✅ 有配對的 PDF 詞彙表

---

### 快速處理模式（較低品質但更快）

```powershell
.\split_whisper_merge_v13.ps1 `
  -Folder "C:\Videos" `
  -SegParts 4 `
  -Beam 5 `
  -Model medium `
  -MaxCueSec 6 `
  -MaxLineChars 42 `
  -MaxLines 2
```

**適用情境：**
- ✅ 測試或預覽
- ✅ 不需要最高品質
- ✅ 想要快速完成

---

### 單檔高品質模式

```powershell
.\split_whisper_merge_v13.ps1 `
  -In "important_video.mp4" `
  -SegParts 8 `
  -Beam 15 `
  -UseJsonAlign `
  -SnapToSilence `
  -CarryInitialPrompt `
  -ShowContext
```

**適用情境：**
- ✅ 重要影片
- ✅ 需要最高品質
- ✅ 不在乎處理時間

---

## 🔄 Git 工作流程

### 推送變更到 GitHub

```powershell
# 互動式 commit + push（會自動處理 skills）
.\sync_push.ps1

# 選項說明：
#   [Y] 使用建議的 commit 訊息
#   [E] 自訂 commit 訊息
#   [N] WIP 自動同步
#   [T] 建立 Release tag（在 Y/E 之後）
```

### 拉取最新變更

```powershell
# Pull 主專案和 skills
.\sync_pull.ps1
```

### 建立 Release

```powershell
# 使用 sync_push.ps1 的 tag 功能
.\sync_push.ps1
# 選擇 [Y] 或 [E]
# 然後選擇 [T] 建立 tag
# 選擇版本類型：[P]atch / [M]inor / [J]major / [C]ustom
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

**Q: 第二部電腦同步專案**
```powershell
# 第一次（包含 submodule）
git clone --recurse-submodules git@github.com:radmanyeung/subtool.git C:\subtool

# 或已有資料夾
cd C:\subtool
git pull
git submodule update --remote
```

**Q: PowerShell 執行策略限制**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### 工具相關

**Q: 找不到 FFmpeg**
```powershell
winget install -e --id Gyan.FFmpeg
```

**Q: GPU 記憶體不足**
```powershell
# 減少 worker 數量
.\split_whisper_merge_v13.ps1 -In "video.mp4" -WorkersMap "0=1"

# 或使用較小模型
.\split_whisper_merge_v13.ps1 -In "video.mp4" -Model medium
```

**Q: pdftotext 找不到**
```
1. 下載 Xpdf tools (https://www.xpdfreader.com/download.html)
2. 指定完整路徑：-PdfToText "C:\Tools\xpdf\pdftotext.exe"
```

---

## 💡 最佳實踐

### 處理新課程影片的完整流程

```powershell
# Step 1: 生成詞彙表
.\make_gloss_from_pdf_v5.ps1 -Folder "C:\Users\user\Documents\FCCI"

# Step 2: 生成字幕（使用 FCCI 最佳參數）
.\split_whisper_merge_v13.ps1 `
  -Folder "C:\Users\user\Documents\FCCI" `
  -SegParts 6 -Beam 10 `
  -CarryInitialPrompt -UseJsonAlign `
  -SegOverlapSec 3.0 -SnapToSilence `
  -ShowContext -ShowGpuSummary -LiveLogs `
  -MaxCueSec 6 -MaxLineChars 55 -MaxLines 2

# 選擇 [3] 只處理有 TXT 的檔案

# Step 3: 品質檢查
pwsh .\QC-Srt.ps1 -Srt "C:\Users\user\Documents\FCCI\Lesson1.srt"

# Step 4: 推送到 GitHub
.\sync_push.ps1
```

---

## 📁 檔案結構

```
C:\subtool\
├── split_whisper_merge_v13.ps1    # 語音轉文字（主要工具）
├── split_whisper_merge_GUI.ps1    # 圖形界面（新增）⭐
├── GUI_使用指南.md                # GUI 完整使用說明（新增）⭐
├── make_gloss_from_pdf_v5.ps1     # PDF 詞彙表生成
├── weekly_process.ps1             # 每週自動處理
├── QC-Srt.ps1                     # 字幕品質檢查
├── sync_push.ps1                  # Git 推送（含 skills）
├── sync_pull.ps1                  # Git 拉取（含 skills）
├── srt_postprocess.py             # SRT 後處理
├── translate_and_format.py        # 雙語字幕處理
├── README.md                      # 完整文檔
├── WEEKLY_USAGE.md                # 每週處理指南
└── skills\                        # Skills submodule
    ├── git-workflow.md            # Git 工作流程（通用）
    ├── powershell-common.md       # PowerShell 技巧（通用）
    ├── troubleshooting.md         # 疑難排解（通用）
    ├── cursor-tips.md             # Cursor 技巧（通用）
    └── subtool.md                 # SubTool 專案特定（本檔案）
```

---

## 🎯 AI Assistant 指引

當用戶詢問相關問題時：

1. **FCCI 影片處理**：使用上方「FCCI 專案最佳參數」
2. **快速測試**：使用「快速處理模式」
3. **Git 同步**：提醒使用 `sync_push.ps1` 和 `sync_pull.ps1`
4. **第二部電腦**：先確認已安裝 Git 和設定執行策略
5. **修改檔案前**：說明原因和影響，獲得同意後才修改

---

## 📝 版本資訊

- **當前版本**：v13 (split_whisper_merge), v5 (make_gloss_from_pdf), v1.0 (GUI)
- **最後更新**：2026-01-20
- **主要工具數量**：10 個（新增 GUI + 使用指南）
- **Skills 組織**：使用 Git Submodule（my-skills repo）
- **新功能**：圖形界面（split_whisper_merge_GUI.ps1）⭐

---

## 🔗 相關資源

- **GUI 使用指南**：`GUI_使用指南.md` ⭐ 新增
- 完整文檔：`README.md`
- 每週處理指南：`WEEKLY_USAGE.md`
- Git 工作流程：`skills/git-workflow.md`
- 疑難排解：`skills/troubleshooting.md`
- Cursor 技巧：`skills/cursor-tips.md`
