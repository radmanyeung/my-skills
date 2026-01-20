# sync_external_skills.ps1 - Sync external Claude Skills from GitHub
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$SkillsRoot = "C:\my-skills"
$CacheDir = Join-Path $SkillsRoot ".cache"
$ExternalDir = Join-Path $SkillsRoot "external-skills"
$SourcesFile = Join-Path $SkillsRoot ".sources.json"

# Read sources
$sources = @(
    @{name="awesome-claude-skills"; repo="https://github.com/ComposioHQ/awesome-claude-skills.git"},
    @{name="awesome-claude-skills-2"; repo="https://github.com/BehiSecc/awesome-claude-skills.git"},
    @{name="claude-code-infrastructure"; repo="https://github.com/diet103/claude-code-infrastructure-showcase.git"},
    @{name="superpowers"; repo="https://github.com/obra/superpowers.git"},
    @{name="skill-seekers"; repo="https://github.com/yusufkaraaslan/Skill_Seekers.git"}
)

Write-Host "`n=== Sync External Skills ===" -ForegroundColor Cyan
Write-Host ""

# Create directories
if (-not (Test-Path $CacheDir)) {
    New-Item -ItemType Directory -Path $CacheDir | Out-Null
}
if (-not (Test-Path $ExternalDir)) {
    New-Item -ItemType Directory -Path $ExternalDir | Out-Null
}

$totalFiles = 0

foreach ($source in $sources) {
    $name = $source.name
    $repo = $source.repo
    $cacheRepo = Join-Path $CacheDir $name
    $targetDir = Join-Path $ExternalDir $name
    
    Write-Host ">>> $name" -ForegroundColor Yellow
    Write-Host "    Source: $repo" -ForegroundColor Gray
    
    # Clone or update
    if (-not (Test-Path $cacheRepo)) {
        Write-Host "    Cloning..." -ForegroundColor Gray
        git clone --depth 1 --quiet $repo $cacheRepo 2>&1 | Out-Null
    }
    else {
        Write-Host "    Updating..." -ForegroundColor Gray
        Push-Location $cacheRepo
        try {
            git fetch origin --quiet 2>&1 | Out-Null
            # Get default branch
            $defaultBranch = git symbolic-ref refs/remotes/origin/HEAD 2>&1 | ForEach-Object { $_ -replace 'refs/remotes/origin/', '' }
            if ($defaultBranch) {
                git reset --hard "origin/$defaultBranch" --quiet 2>&1 | Out-Null
            } else {
                # Fallback: try main, then master, then development
                $branches = @("main", "master", "development", "dev")
                foreach ($br in $branches) {
                    git reset --hard "origin/$br" --quiet 2>&1 | Out-Null
                    if ($LASTEXITCODE -eq 0) { break }
                }
            }
        }
        finally {
            Pop-Location
        }
    }
    
    # Clean target
    if (Test-Path $targetDir) {
        Remove-Item -Recurse -Force $targetDir
    }
    New-Item -ItemType Directory -Path $targetDir | Out-Null
    
    # Copy files
    $patterns = @("*.md", "**/*.md")
    $exclude = @("README.md", "CONTRIBUTING.md", "LICENSE", "CHANGELOG.md")
    $copiedCount = 0
    
    foreach ($pattern in $patterns) {
        $files = Get-ChildItem -Path $cacheRepo -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            $shouldExclude = $false
            foreach ($ex in $exclude) {
                if ($file.Name -eq $ex) {
                    $shouldExclude = $true
                    break
                }
            }
            
            if ($shouldExclude) { continue }
            
            $relativePath = $file.FullName.Substring($cacheRepo.Length + 1)
            $targetFile = Join-Path $targetDir $relativePath
            $targetFileDir = Split-Path $targetFile -Parent
            
            if (-not (Test-Path $targetFileDir)) {
                New-Item -ItemType Directory -Path $targetFileDir -Force | Out-Null
            }
            
            Copy-Item -Path $file.FullName -Destination $targetFile -Force
            $copiedCount++
        }
    }
    
    Write-Host "    Copied: $copiedCount files" -ForegroundColor Green
    $totalFiles += $copiedCount
    Write-Host ""
}

# Create INDEX.md
$indexFile = Join-Path $ExternalDir "INDEX.md"
$indexContent = @"
# External Claude Skills Index

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Sources

"@

foreach ($source in $sources) {
    $name = $source.name
    $repo = $source.repo
    $targetDir = Join-Path $ExternalDir $name
    
    if (Test-Path $targetDir) {
        $fileCount = (Get-ChildItem -Path $targetDir -Recurse -File | Measure-Object).Count
        $indexContent += "`n### $name`n`n"
        $indexContent += "- **Repository:** $repo`n"
        $indexContent += "- **Files:** $fileCount`n"
        $indexContent += "- **Path:** ``external-skills/$name/```n"
    }
}

$indexContent += @"

---

## How to Update

````powershell
cd C:\my-skills
.\sync_external_skills.ps1
````

## Usage in Cursor

````
@skills/external-skills/awesome-claude-skills/some-skill.md
@skills/external-skills/superpowers/skills/test-driven-development/SKILL.md
````

---

**Last synced:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Set-Content -Path $indexFile -Value $indexContent -Encoding UTF8

# Generate ALL_SKILLS_INDEX.md
Write-Host "`n=== Generating ALL_SKILLS_INDEX.md ===" -ForegroundColor Cyan

$allSkillsIndex = Join-Path $SkillsRoot "ALL_SKILLS_INDEX.md"

# Scan for all SKILL.md files
$externalSkills = Get-ChildItem -Path $ExternalDir -Filter "SKILL.md" -Recurse -File | 
    ForEach-Object { 
        $relativePath = $_.FullName.Replace("$ExternalDir\", "").Replace("\", "/")
        @{
            Path = "external-skills/$relativePath"
            Name = $_.Directory.Name
            Source = $_.FullName.Replace("$ExternalDir\", "").Split("\")[0]
            FullPath = $_.FullName
        }
    } | Sort-Object Source, Name

# Count by source
$sourceStats = $externalSkills | Group-Object Source | ForEach-Object {
    @{Name = $_.Name; Count = $_.Count}
}

# Custom skills in root
$customSkills = Get-ChildItem -Path $SkillsRoot -Filter "*.md" -File | 
    Where-Object { $_.Name -notmatch "README|QUICK_START|INDEX|ALL_SKILLS" } |
    ForEach-Object { $_.Name }

# Generate content
$content = @"
# 所有 Skills 完整索引

> **自動生成於:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
> **用途:** 在 Cursor 中引用 ``@skills/ALL_SKILLS_INDEX.md``，AI 會看到所有可用的 skills 並推薦最適合的。

---

## 📊 統計資訊

| 類別 | 數量 |
|------|------|
| **自訂 Skills** | $($customSkills.Count) 個 |
"@

foreach ($stat in $sourceStats) {
    $content += "| **$($stat.Name)** | $($stat.Count) 個 |`n"
}

$totalSkills = $customSkills.Count + ($sourceStats | Measure-Object -Property Count -Sum).Sum
$content += "| **總計** | $totalSkills 個 |`n`n"

$content += @"
---

## 📁 自訂 Skills（根目錄）

"@

foreach ($skill in $customSkills) {
    $content += "- ``$skill```n"
}

$content += @"

---

## 🌟 外部 Skills（按來源分類）

"@

foreach ($stat in $sourceStats) {
    $sourceName = $stat.Name
    $sourceCount = $stat.Count
    
    $content += "`n### $sourceName ($sourceCount 個)`n`n"
    
    $sourceSkills = $externalSkills | Where-Object { $_.Source -eq $sourceName }
    foreach ($skill in $sourceSkills) {
        $content += "- ``$($skill.Path)```n"
    }
}

$content += @"

---

## 🎯 快速選擇指南

### 情境 1：開始新專案
**推薦順序：**
1. ``external-skills/superpowers/skills/brainstorming/SKILL.md`` - 設計討論
2. ``external-skills/superpowers/skills/writing-plans/SKILL.md`` - 規劃任務
3. ``external-skills/superpowers/skills/using-git-worktrees/SKILL.md`` - 建立工作環境

### 情境 2：開發後端 API
**推薦：**
- ``external-skills/claude-code-infrastructure/.claude/skills/backend-dev-guidelines/SKILL.md``
- ``external-skills/superpowers/skills/test-driven-development/SKILL.md``
- ``git-workflow.md``

### 情境 3：開發前端功能
**推薦：**
- ``external-skills/claude-code-infrastructure/.claude/skills/frontend-dev-guidelines/SKILL.md``
- ``external-skills/awesome-claude-skills/artifacts-builder/SKILL.md``
- ``external-skills/awesome-claude-skills/theme-factory/SKILL.md``

### 情境 4：除錯問題
**推薦：**
- ``external-skills/superpowers/skills/systematic-debugging/SKILL.md``
- ``troubleshooting.md``
- ``external-skills/claude-code-infrastructure/.claude/skills/error-tracking/SKILL.md``

### 情境 5：處理文檔
**推薦：**
- ``external-skills/awesome-claude-skills/document-skills/docx/SKILL.md``
- ``external-skills/awesome-claude-skills/document-skills/pdf/SKILL.md``
- ``external-skills/awesome-claude-skills/document-skills/xlsx/SKILL.md``

### 情境 6：Git 與自動化
**推薦：**
- ``git-workflow.md``
- ``powershell-common.md``
- ``external-skills/superpowers/skills/finishing-a-development-branch/SKILL.md``

### 情境 7：建立 Claude Skills/Tools
**推薦：**
- ``external-skills/awesome-claude-skills/mcp-builder/SKILL.md``
- ``external-skills/claude-code-infrastructure/.claude/skills/skill-developer/SKILL.md``
- ``external-skills/awesome-claude-skills/skill-creator/SKILL.md``

### 情境 8：內容創作
**推薦：**
- ``external-skills/awesome-claude-skills/content-research-writer/SKILL.md``
- ``external-skills/awesome-claude-skills/changelog-generator/SKILL.md``

---

## 🎯 如何在 Cursor 中使用

### 方法 1：引用整個索引（推薦）
````
@skills/ALL_SKILLS_INDEX.md

"我需要開發一個新的用戶認證功能，哪些 skills 適合我？"
````

### 方法 2：直接引用特定 skill
````
@skills/external-skills/superpowers/skills/test-driven-development/SKILL.md

"使用 TDD 方法幫我開發登入功能"
````

### 方法 3：引用多個相關 skills
````
@skills/external-skills/superpowers/skills/brainstorming/SKILL.md
@skills/external-skills/superpowers/skills/writing-plans/SKILL.md

"幫我設計並規劃一個新功能"
````

---

## 🔄 更新此索引

此索引會在每次執行同步腳本時自動更新：

````powershell
cd C:\my-skills
.\sync_external_skills.ps1
````

---

## 📚 完整文檔

- **快速開始：** ``QUICK_START.md``
- **完整說明：** ``README.md``
- **外部 Skills 索引：** ``external-skills/INDEX.md``

---

**上次更新：** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**總 Skills 數量：** $totalSkills 個  
**自動生成：** ✅ 由 sync_external_skills.ps1 產生
"@

Set-Content -Path $allSkillsIndex -Value $content -Encoding UTF8
Write-Host "✅ ALL_SKILLS_INDEX.md generated" -ForegroundColor Green
Write-Host "   Location: $allSkillsIndex" -ForegroundColor Gray

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Total repos synced: $($sources.Count)" -ForegroundColor Green
Write-Host "Total files copied: $totalFiles" -ForegroundColor Green
Write-Host "Total skills indexed: $totalSkills" -ForegroundColor Green
Write-Host "Output: $ExternalDir" -ForegroundColor Green
Write-Host "`nIndexes created:" -ForegroundColor Yellow
Write-Host "  - external-skills/INDEX.md (external skills only)" -ForegroundColor Gray
Write-Host "  - ALL_SKILLS_INDEX.md (complete index)" -ForegroundColor Gray
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Review: cat ALL_SKILLS_INDEX.md"
Write-Host "  2. Commit: git add . && git commit -m 'Sync external skills + update index'"
Write-Host "  3. Push: git push"
Write-Host ""
