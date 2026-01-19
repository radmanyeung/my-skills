# Troubleshooting Skills

## 🔧 Git 相關問題

### Git 無法辨識
**現象：** 執行 `git` 指令顯示「無法辨識」

**原因：** 未安裝 Git 或未加入 PATH

**解法：**
```powershell
# 檢查是否已安裝
git --version

# 安裝 Git
winget install --id Git.Git -e --source winget

# 重開 PowerShell 後確認
git --version
```

---

### Push 後 GitHub 看不到 Release
**現象：** 執行 `git push` 後，GitHub Releases 頁面沒有新版本

**原因：** `git push` 只推送 commits，不會建立 Release

**解法：**
```powershell
# 1. 建立 tag
git tag v1.0.0

# 2. Push tag
git push --tags

# 3. 建立 Release（方法 A：GitHub CLI）
gh release create v1.0.0 --title "版本 1.0.0" --notes "更新說明"

# 或（方法 B：GitHub 網頁）
# 前往 GitHub → Releases → Create a new release
```

---

### Clone 時 Submodule 是空的
**現象：** Clone 專案後，submodule 資料夾是空的

**原因：** 預設 clone 不會下載 submodule

**解法：**
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

### Push 時要求帳號密碼
**現象：** Push 時要求輸入帳號密碼，但密碼無法使用

**原因：** GitHub 已不支援密碼驗證

**解法 1：使用 GitHub CLI**
```powershell
# 安裝 GitHub CLI
winget install --id GitHub.cli

# 登入
gh auth login
```

**解法 2：使用 Personal Access Token**
1. 前往 GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token（給予 repo 權限）
3. 複製 token
4. 使用 token 取代密碼

---

## 🐍 Python 相關問題

### Python 無法辨識
**現象：** 執行 `python` 指令顯示「無法辨識」

**解法：**
```powershell
# 檢查是否已安裝
python --version

# 安裝 Python（使用 winget）
winget search python
winget install Python.Python.3.12

# 重開 PowerShell 後確認
python --version
```

---

### pip 安裝套件失敗
**現象：** `pip install` 時出錯

**解法：**
```powershell
# 升級 pip
python -m pip install --upgrade pip

# 使用特定來源
pip install package --index-url https://pypi.org/simple

# 使用代理
pip install package --proxy http://proxy:port
```

---

### 虛擬環境無法啟動
**現象：** 執行 `venv\Scripts\activate` 時出錯

**原因：** PowerShell 執行策略限制

**解法：**
```powershell
# 設定執行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 啟動虛擬環境
C:\venvs\sub312\Scripts\activate
```

---

## 🎬 FFmpeg 相關問題

### FFmpeg 無法辨識
**現象：** 執行 `ffmpeg` 指令顯示「無法辨識」

**解法：**
```powershell
# 安裝 FFmpeg
winget install -e --id Gyan.FFmpeg

# 重開 PowerShell 後確認
ffmpeg -version
```

---

## 🖥️ GPU 相關問題

### GPU 未被使用
**現象：** 轉錄影片時 GPU 使用率為 0

**解法：**
```powershell
# 1. 確認 GPU 可用
nvidia-smi

# 2. 檢查 CUDA 版本
nvidia-smi | Select-String "CUDA"

# 3. 確認 PyTorch 支援 CUDA
python -c "import torch; print(torch.cuda.is_available())"

# 4. 如果為 False，重新安裝 PyTorch
pip uninstall torch
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

---

### GPU 記憶體不足
**現象：** 轉錄時出現 "CUDA out of memory"

**解法：**
```powershell
# 方法 1：減少 worker 數量
.\split_whisper_merge_v13.ps1 -In "video.mp4" -WorkersMap "0=1"

# 方法 2：使用較小的模型
.\split_whisper_merge_v13.ps1 -In "video.mp4" -Model medium

# 方法 3：增加分段數量
.\split_whisper_merge_v13.ps1 -In "video.mp4" -SegParts 10
```

---

## 📄 PDF 相關問題

### pdftotext 無法辨識
**現象：** 執行 PDF 處理時找不到 pdftotext

**解法：**
```powershell
# 1. 下載 Xpdf tools
# 前往：https://www.xpdfreader.com/download.html

# 2. 解壓到固定位置
# 例如：C:\Tools\xpdf

# 3. 指定完整路徑
.\make_gloss_from_pdf_v5.ps1 -Folder "C:\Course" `
  -PdfToText "C:\Tools\xpdf\pdftotext.exe"

# 4. 或加入 PATH（永久）
$env:PATH += ";C:\Tools\xpdf"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
```

---

## ⚙️ PowerShell 相關問題

### 執行策略限制
**現象：** 執行 .ps1 檔案時顯示「無法載入，因為執行原則限制」

**解法：**
```powershell
# 查看目前策略
Get-ExecutionPolicy

# 設定為允許執行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 確認
Get-ExecutionPolicy
```

---

### 中文亂碼
**現象：** 檔案內容顯示亂碼

**解法：**
```powershell
# 讀取時指定 UTF-8
Get-Content "file.txt" -Encoding UTF8

# 寫入時指定 UTF-8
"內容" | Out-File "file.txt" -Encoding UTF8

# 在腳本開頭加入
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## 🌐 網路相關問題

### 下載速度慢
**現象：** pip、git clone 速度很慢

**解法：**
```powershell
# pip 使用鏡像站
pip install package -i https://pypi.tuna.tsinghua.edu.cn/simple

# git clone 使用代理
git config --global http.proxy http://proxy:port

# 或使用 SSH 而非 HTTPS
git clone git@github.com:username/repo.git
```

---

## 🔍 診斷指令

### 檢查系統資訊
```powershell
# Windows 版本
Get-ComputerInfo | Select-Object WindowsVersion, OsVersion

# PowerShell 版本
$PSVersionTable

# GPU 資訊
nvidia-smi

# 磁碟空間
Get-PSDrive

# 記憶體使用
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
```

### 檢查路徑和環境
```powershell
# 查看 PATH
$env:PATH -split ';'

# 檢查指令位置
Get-Command python
Get-Command git

# 測試網路連線
Test-NetConnection github.com -Port 443
```

---

## 💡 一般疑難排解流程

### 步驟 1：確認問題
```powershell
# 記錄完整錯誤訊息
# 記錄執行的指令
# 記錄環境資訊（OS、PowerShell 版本等）
```

### 步驟 2：檢查基本環境
```powershell
# 確認工具已安裝
git --version
python --version
ffmpeg -version

# 確認路徑正確
Test-Path "C:\subtool"
```

### 步驟 3：查看日誌
```powershell
# 執行時使用 -Verbose 或 -Debug
.\script.ps1 -Verbose

# 查看 Windows 事件日誌
Get-EventLog -LogName Application -Newest 10
```

### 步驟 4：隔離問題
```powershell
# 使用最簡單的參數測試
.\script.ps1 -In "test.mp4"

# 逐步增加參數
.\script.ps1 -In "test.mp4" -Model medium
```

---

## 🔗 常用資源

- [Stack Overflow](https://stackoverflow.com/)
- [GitHub Issues](https://github.com/)
- [PowerShell 文檔](https://docs.microsoft.com/powershell/)
- [Python 文檔](https://docs.python.org/)
- [FFmpeg 文檔](https://ffmpeg.org/documentation.html)
