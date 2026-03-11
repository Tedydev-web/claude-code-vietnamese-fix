@echo off
set "FIX_DIR=%~dp0"
set "NODE_EXE=node"
where node >nul 2>&1 || (echo Khong tim thay node. Cai Node.js truoc. & exit /b 1)
set "CLI_JS="
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-ChildItem -Path \"%LOCALAPPDATA%\npm-cache\_npx\" -Recurse -Filter cli.js -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match '@anthropic-ai\\claude-code\\cli\.js$' } | Select-Object -First 1 -ExpandProperty FullName"') do set "CLI_JS=%%i"
if not defined CLI_JS (
  echo Khong tim thay cli.js da patch. Chay: python "%FIX_DIR%patcher.py"
  exit /b 1
)
"%NODE_EXE%" "%CLI_JS%" %*
