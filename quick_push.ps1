# quick_push.ps1 - 快速提交並推送 my-skills 變更到 GitHub
# 用途：修改完 skills 後，一鍵提交並推送到遠端倉庫

$ErrorActionPreference = "Stop"

$RepoPath = "C:\my-skills"
Set-Location $RepoPath

Write-Host ""
Write-Host "=== My-Skills Quick Push ===" -ForegroundColor Cyan
Write-Host ""

# 檢查是否為 git 倉庫
if (-not (Test-Path ".git")) {
    Write-Host "❌ 不是 git 倉庫: $RepoPath" -ForegroundColor Red
    exit 1
}

# 加入所有變更
Write-Host "📦 正在加入變更..." -ForegroundColor Green
git add -A | Out-Null

# 檢查是否有變更
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ 沒有變更需要提交" -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# 顯示變更的檔案
$changedFiles = @(git diff --cached --name-only)
Write-Host "變更的檔案:" -ForegroundColor Cyan
$changedFiles | ForEach-Object { Write-Host "  ✓ $_" -ForegroundColor White }
Write-Host ""

# 詢問 commit 訊息
Write-Host "請選擇提交方式:" -ForegroundColor Yellow
Write-Host "  [1] 快速提交 (自動訊息 + 時間戳記)"
Write-Host "  [2] 自訂訊息"
Write-Host "  [C] 取消"
Write-Host ""

$choice = Read-Host "您的選擇 (1/2/C)"

$commitMsg = $null

if ($choice -eq "1") {
    # 自動生成訊息
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    $commitMsg = "Update skills ($timestamp)"
    Write-Host ""
    Write-Host "使用訊息: $commitMsg" -ForegroundColor Green
}
elseif ($choice -eq "2") {
    # 自訂訊息
    Write-Host ""
    $commitMsg = Read-Host "請輸入 commit 訊息"
    
    # 確保不是空白
    while ([string]::IsNullOrWhiteSpace($commitMsg)) {
        Write-Host "訊息不能為空，請重新輸入:" -ForegroundColor Yellow
        $commitMsg = Read-Host "請輸入 commit 訊息"
    }
}
elseif ($choice -match '^[Cc]$') {
    Write-Host ""
    Write-Host "已取消操作" -ForegroundColor Gray
    exit 0
}
else {
    Write-Host ""
    Write-Host "無效的選擇，已取消操作" -ForegroundColor Red
    exit 1
}

# 執行 commit
Write-Host ""
Write-Host "📝 正在提交變更..." -ForegroundColor Green
git commit -m $commitMsg | Out-Host

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ 提交失敗" -ForegroundColor Red
    exit 1
}

# 執行 push
Write-Host ""
Write-Host "🚀 正在推送到 GitHub..." -ForegroundColor Green
git push | Out-Host

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ 推送失敗" -ForegroundColor Red
    Write-Host "提示: 如果遠端有更新，請先執行 'git pull' 後再推送" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "✅ 完成！變更已推送到 GitHub" -ForegroundColor Green
Write-Host ""
Write-Host "接下來的步驟:" -ForegroundColor Cyan
Write-Host "  若要同步到 C:\subtool\skills，請執行:" -ForegroundColor White
Write-Host "    cd C:\subtool" -ForegroundColor Gray
Write-Host "    .\sync_pull.ps1" -ForegroundColor Gray
Write-Host ""
