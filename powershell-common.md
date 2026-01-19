# PowerShell Common Skills

## 📁 檔案與資料夾操作

### 基本操作
```powershell
# 列出檔案
Get-ChildItem
ls  # 別名

# 遞迴列出所有檔案
Get-ChildItem -Recurse

# 過濾特定副檔名
Get-ChildItem -Filter "*.ps1"
Get-ChildItem -Include "*.md","*.txt" -Recurse

# 建立資料夾
New-Item -ItemType Directory -Path "C:\NewFolder"
mkdir "C:\NewFolder"  # 別名

# 建立檔案
New-Item -ItemType File -Path "C:\file.txt"

# 複製
Copy-Item "source.txt" "destination.txt"
Copy-Item "C:\Folder" "C:\NewFolder" -Recurse

# 移動
Move-Item "source.txt" "destination.txt"

# 刪除
Remove-Item "file.txt"
Remove-Item "C:\Folder" -Recurse -Force

# 檢查是否存在
Test-Path "C:\file.txt"
```

### 檔案內容操作
```powershell
# 讀取檔案
Get-Content "file.txt"
cat "file.txt"  # 別名

# 讀取為單一字串
Get-Content "file.txt" -Raw

# 寫入檔案（覆蓋）
"Hello World" | Out-File "file.txt"
Set-Content "file.txt" "Hello World"

# 附加到檔案
"New Line" | Add-Content "file.txt"

# 搜尋檔案內容
Get-Content "file.txt" | Select-String "pattern"
```

---

## 🔍 搜尋與過濾

### 搜尋檔案
```powershell
# 搜尋檔名
Get-ChildItem -Recurse -Filter "*keyword*"

# 搜尋檔案內容
Get-ChildItem -Recurse -Include "*.txt" | Select-String "pattern"

# 只顯示檔案名稱
Get-ChildItem -Recurse | Where-Object {$_.Name -like "*keyword*"} | Select-Object Name
```

### Where-Object 過濾
```powershell
# 過濾大於 1MB 的檔案
Get-ChildItem | Where-Object {$_.Length -gt 1MB}

# 過濾最近 7 天修改的檔案
$cutoff = (Get-Date).AddDays(-7)
Get-ChildItem | Where-Object {$_.LastWriteTime -ge $cutoff}

# 只顯示資料夾
Get-ChildItem | Where-Object {$_.PSIsContainer}

# 只顯示檔案
Get-ChildItem | Where-Object {-not $_.PSIsContainer}
```

---

## 🔤 字串處理

### 基本操作
```powershell
# 取代
$text = "Hello World"
$text -replace "World", "PowerShell"  # Hello PowerShell

# 分割
$text = "a,b,c,d"
$parts = $text -split ","
$parts[0]  # a

# 結合
$parts = @("a", "b", "c")
$joined = $parts -join ","  # a,b,c

# 大小寫轉換
"hello".ToUpper()  # HELLO
"HELLO".ToLower()  # hello

# 去除空白
"  text  ".Trim()  # text
"  text  ".TrimStart()  # text  
"  text  ".TrimEnd()  #   text

# 檢查包含
"Hello World" -like "*World*"  # True
"Hello World" -match "World"   # True

# 長度
"Hello".Length  # 5
```

### 路徑處理
```powershell
# 取得檔名
[IO.Path]::GetFileName("C:\folder\file.txt")  # file.txt

# 取得不含副檔名的檔名
[IO.Path]::GetFileNameWithoutExtension("C:\folder\file.txt")  # file

# 取得副檔名
[IO.Path]::GetExtension("C:\folder\file.txt")  # .txt

# 取得目錄
[IO.Path]::GetDirectoryName("C:\folder\file.txt")  # C:\folder
Split-Path -Parent "C:\folder\file.txt"  # C:\folder

# 組合路徑
Join-Path "C:\folder" "file.txt"  # C:\folder\file.txt

# 變更副檔名
[IO.Path]::ChangeExtension("file.txt", ".md")  # file.md
```

---

## 🔄 迴圈與條件

### ForEach 迴圈
```powershell
# 方法 1：ForEach-Object
Get-ChildItem | ForEach-Object {
    Write-Host $_.Name
}

# 方法 2：foreach 語句
$files = Get-ChildItem
foreach($file in $files) {
    Write-Host $file.Name
}

# 方法 3：簡寫
Get-ChildItem | % { Write-Host $_.Name }
```

### If 條件判斷
```powershell
# 基本 if
if($value -gt 10) {
    Write-Host "大於 10"
}

# if-else
if(Test-Path "file.txt") {
    Write-Host "檔案存在"
} else {
    Write-Host "檔案不存在"
}

# if-elseif-else
if($value -eq 1) {
    Write-Host "是 1"
} elseif($value -eq 2) {
    Write-Host "是 2"
} else {
    Write-Host "其他"
}

# 比較運算子
-eq   # 等於
-ne   # 不等於
-gt   # 大於
-lt   # 小於
-ge   # 大於等於
-le   # 小於等於
-like # 模糊比對
-match # 正規表達式比對
```

---

## 📊 變數與資料類型

### 變數
```powershell
# 宣告變數
$name = "John"
$age = 30
$isActive = $true

# 陣列
$array = @(1, 2, 3, 4, 5)
$array[0]  # 1
$array.Count  # 5
$array += 6  # 新增元素

# 雜湊表（字典）
$hash = @{
    Name = "John"
    Age = 30
    City = "Taipei"
}
$hash["Name"]  # John
$hash.Age  # 30
$hash["Country"] = "Taiwan"  # 新增

# 列出所有變數
Get-Variable
```

### 類型轉換
```powershell
# 字串轉數字
[int]"123"
[double]"123.45"

# 數字轉字串
[string]123

# 檢查類型
$value = 123
$value.GetType()
```

---

## ⚙️ 系統操作

### 環境變數
```powershell
# 讀取
$env:PATH
$env:USERPROFILE

# 設定（當前 session）
$env:MY_VAR = "value"

# 永久設定（需要管理員權限）
[Environment]::SetEnvironmentVariable("MY_VAR", "value", "User")
```

### 執行外部程式
```powershell
# 方法 1：直接執行
ffmpeg -i input.mp4 output.mp4

# 方法 2：使用 & 運算子
& "C:\Program Files\app.exe" -param value

# 方法 3：Start-Process
Start-Process "notepad.exe" -ArgumentList "file.txt"

# 等待程式完成
$process = Start-Process "app.exe" -PassThru -Wait
$process.ExitCode
```

### 日期時間
```powershell
# 目前時間
Get-Date

# 格式化
Get-Date -Format "yyyy-MM-dd"
Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# 計算
(Get-Date).AddDays(7)   # 7天後
(Get-Date).AddDays(-7)  # 7天前
(Get-Date).AddHours(2)  # 2小時後
```

---

## 🐛 錯誤處理

### Try-Catch
```powershell
try {
    # 可能會出錯的程式碼
    Get-Content "nonexistent.txt"
} catch {
    # 錯誤處理
    Write-Host "發生錯誤: $_" -ForegroundColor Red
}

# 帶 Finally
try {
    # ...
} catch {
    # ...
} finally {
    # 無論如何都會執行
    Write-Host "清理完成"
}
```

### 錯誤處理偏好
```powershell
# 停止執行
$ErrorActionPreference = "Stop"

# 繼續執行
$ErrorActionPreference = "Continue"

# 靜默錯誤
$ErrorActionPreference = "SilentlyContinue"
```

---

## 🎨 輸出與格式化

### 輸出顏色
```powershell
Write-Host "成功" -ForegroundColor Green
Write-Host "警告" -ForegroundColor Yellow
Write-Host "錯誤" -ForegroundColor Red
Write-Host "資訊" -ForegroundColor Cyan
```

### 格式化輸出
```powershell
# 表格
Get-Process | Format-Table Name, CPU, Memory

# 列表
Get-Process | Format-List

# 只選擇特定欄位
Get-Process | Select-Object Name, CPU | Format-Table
```

---

## 📝 常見問題

### Q: PowerShell 執行策略限制
```powershell
# 查看目前策略
Get-ExecutionPolicy

# 設定為允許執行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Q: 中文亂碼
```powershell
# 讀取檔案時指定編碼
Get-Content "file.txt" -Encoding UTF8

# 寫入檔案時指定編碼
"內容" | Out-File "file.txt" -Encoding UTF8
```

### Q: 管道（Pipeline）
```powershell
# 管道傳遞物件
Get-ChildItem | Where-Object {$_.Length -gt 1MB} | Select-Object Name, Length

# $_ 代表目前物件
1..10 | ForEach-Object { $_ * 2 }  # 2, 4, 6, ..., 20
```

---

## 🔗 相關資源

- [PowerShell 官方文檔](https://docs.microsoft.com/powershell/)
- [PowerShell Gallery](https://www.powershellgallery.com/)
- [SS64 PowerShell 參考](https://ss64.com/ps/)
