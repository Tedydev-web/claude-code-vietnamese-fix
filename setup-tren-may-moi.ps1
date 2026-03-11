# =============================================================================
# Cai dat Claude Code Vietnamese IME Fix + alias "claude" (--dangerously-skip-permissions)
# Chay script nay 1 lan tren may Windows moi de dong bo voi may hien tai.
#
# Cach chay (PowerShell, chay as User):
#   irm https://raw.githubusercontent.com/manhit96/claude-code-vietnamese-fix/main/install.ps1 | iex
#   # Sau do chay tiep doan ben duoi (Profile) hoac chay ca script nay neu ban copy file.
#
# Hoac copy file nay vao may moi roi:  .\setup-tren-may-moi.ps1
# =============================================================================

$ErrorActionPreference = "Stop"
$InstallDir = Join-Path $env:USERPROFILE ".claude-vn-fix"
$RepoUrl = "https://github.com/manhit96/claude-code-vietnamese-fix.git"

Write-Host ""
Write-Host "=== Dong bo: Claude Code Vietnamese IME Fix + alias claude ===" -ForegroundColor Cyan
Write-Host ""

# --- 1. Git + Python ---
$gitExists = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitExists) {
    Write-Host "[ERROR] Chua cai Git. Cai: https://git-scm.com/downloads" -ForegroundColor Red
    exit 1
}
$PythonCmd = $null
foreach ($cmd in @("python3", "python", "py")) {
    try { $null = & $cmd --version 2>&1; $PythonCmd = $cmd; break } catch {}
}
if (-not $PythonCmd) {
    Write-Host "[ERROR] Chua cai Python. Cai: https://python.org/downloads" -ForegroundColor Red
    exit 1
}

# --- 2. Clone/update .claude-vn-fix ---
Write-Host "-> Thu muc: $InstallDir"
if (Test-Path $InstallDir) {
    Push-Location $InstallDir
    try { git pull origin main 2>&1 | Out-Null } catch {}
    Pop-Location
} else {
    git clone --depth 1 $RepoUrl $InstallDir
}
Write-Host "   Done."

# --- 2b. Tao run-patched-claude.ps1 neu chua co (upstream chua co file nay) ---
$launcherPath = Join-Path $InstallDir "run-patched-claude.ps1"
if (-not (Test-Path $launcherPath)) {
    @'
# Run Claude Code CLI with Vietnamese IME fix (uses patched cli.js)
$ErrorActionPreference = "Stop"
$InstallDir = $PSScriptRoot
$cliJs = $null
foreach ($d in @(
    "$env:LOCALAPPDATA\npm-cache\_npx",
    "$env:APPDATA\npm\node_modules"
)) {
    if (-not (Test-Path $d)) { continue }
    $found = Get-ChildItem -Path $d -Recurse -Filter "cli.js" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match "@anthropic-ai\\claude-code\\cli\.js$" } |
        Select-Object -First 1
    if ($found) { $cliJs = $found.FullName; break }
}
if (-not $cliJs -or -not (Test-Path $cliJs)) {
    Write-Host "Khong tim thay cli.js da patch. Chay: python $InstallDir\patcher.py" -ForegroundColor Red
    exit 1
}
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { Write-Host "Khong tim thay node. Cai Node.js truoc." -ForegroundColor Red; exit 1 }
& $node.Source $cliJs @args
'@ | Set-Content -Path $launcherPath -Encoding UTF8
    Write-Host "-> Tao run-patched-claude.ps1"
}

# --- 3. Patch cli.js ---
Write-Host "-> Chay patcher..."
$env:PYTHONIOENCODING = "utf-8"
Push-Location $InstallDir
& $PythonCmd patcher.py --all
Pop-Location
Write-Host "   Done."

# --- 4. Them function claude vao PowerShell profile ---
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
$claudeBlock = @"
# Claude Code - ban da patch (go tieng Viet) + --dangerously-skip-permissions
function claude { & "$InstallDir\run-patched-claude.ps1" --dangerously-skip-permissions @args }
"@
$content = $null
if (Test-Path $PROFILE) {
    $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
}
if ($content -and ($content -match "function claude\s")) {
    Write-Host "-> Profile da co 'function claude', bo qua."
} else {
    Add-Content -Path $PROFILE -Value $claudeBlock -Encoding UTF8
    Write-Host "-> Da them 'function claude' vao profile: $PROFILE"
}
Write-Host ""
Write-Host "=== Xong. Mo lai PowerShell va go: claude ===" -ForegroundColor Green
Write-Host ""
