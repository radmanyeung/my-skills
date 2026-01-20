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
            git reset --hard origin/main --quiet 2>&1 | Out-Null
            if ($LASTEXITCODE -ne 0) {
                git reset --hard origin/master --quiet 2>&1 | Out-Null
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

# Summary
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Total repos synced: $($sources.Count)" -ForegroundColor Green
Write-Host "Total files copied: $totalFiles" -ForegroundColor Green
Write-Host "Output: $ExternalDir" -ForegroundColor Green
Write-Host "`nIndex created: external-skills/INDEX.md" -ForegroundColor Yellow
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Review: cat external-skills\INDEX.md"
Write-Host "  2. Commit: git add . && git commit -m 'Sync external skills'"
Write-Host "  3. Push: git push"
Write-Host ""
