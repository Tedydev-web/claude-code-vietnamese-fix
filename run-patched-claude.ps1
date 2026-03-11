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
    if ($found) {
        $cliJs = $found.FullName
        break
    }
}
if (-not $cliJs -or -not (Test-Path $cliJs)) {
    Write-Host "Khong tim thay cli.js da patch. Chay: python $InstallDir\patcher.py" -ForegroundColor Red
    exit 1
}
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host "Khong tim thay node. Cai Node.js truoc." -ForegroundColor Red
    exit 1
}
& $node.Source $cliJs @args
