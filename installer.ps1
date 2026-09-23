# Requires PowerShell 5.1+
$ErrorActionPreference = 'Stop'

function Write-Info ($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Err  ($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red }
function Write-Ok   ($msg) { Write-Host "[SUCCESS] $msg" -ForegroundColor Green }

# 1. Determine Target Directory ($HOME\bin or $HOME\AppData\Local\Microsoft\WindowsApps)
$InstallDir = Join-Path $HOME "bin"
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# 2. Detect Architecture
$Arch = $env:PROCESSOR_ARCHITECTURE
switch ($Arch) {
    "AMD64" { $Target = "windows";     $BinName = "i18n-amd64.exe" }
    "ARM64" { $Target = "windows-arm"; $BinName = "i18n-arm64.exe" }
    Default {
        Write-Err "Unsupported architecture: $Arch"
        exit 1
    }
}

Write-Info "Detected Windows Arch: $Arch"
Write-Info "Building target: $Target"

# 3. Verify 'make' or 'mingw32-make' availability
$MakeCmd = Get-Command "make" -ErrorAction SilentlyContinue
if (-not $MakeCmd) {
    $MakeCmd = Get-Command "mingw32-make" -ErrorAction SilentlyContinue
}

if (-not $MakeCmd) {
    Write-Err "'make' or 'mingw32-make' not found in PATH. Please install command-line build tools (e.g., via Chocolatey, MSYS2, or wsl)."
    exit 1
}

# 4. Clean previous artifact
$SrcBin = Join-Path "bin" $BinName
if (Test-Path $SrcBin) {
    Remove-Item -Path $SrcBin -Force
}

# 5. Build
& $MakeCmd.Name $Target
if ($LASTEXITCODE -ne 0) {
    Write-Err "Build failed."
    exit 1
}

if (-not (Test-Path $SrcBin)) {
    Write-Err "Compiled binary not found at $SrcBin"
    exit 1
}

# 6. Copy binary securely
$DestBin = Join-Path $InstallDir "i18n.exe"
try {
    Copy-Item -Path $SrcBin -Destination $DestBin -Force
} catch {
    Write-Err "Failed to copy binary to $DestBin. Is $DestBin currently running?"
    exit 1
}

Write-Ok "Binary installed to $DestBin"

# 7. PATH Check & Verification
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    Write-Info "Adding $InstallDir to your User PATH variable..."
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    $env:Path += ";$InstallDir"
}

if (Get-Command "i18n" -ErrorAction SilentlyContinue) {
    Write-Info "Verifying installation:"
    & i18n -v
} else {
    Write-Info "Restart your terminal window to reload your PATH environment variable."
}

Write-Ok "Installed successfully! ✅"
