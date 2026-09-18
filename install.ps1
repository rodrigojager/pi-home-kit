param(
    [switch]$CoreOnly,
    [switch]$SkipOpenCodeCli
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Require-Command([string]$Name, [string]$Hint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Comando '$Name' não encontrado. $Hint"
    }
}

function Run-Native([string]$Command, [string[]]$Arguments) {
    Write-Host "`n> $Command $($Arguments -join ' ')" -ForegroundColor Cyan
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ($LASTEXITCODE): $Command $($Arguments -join ' ')"
    }
}

Require-Command node "Instale Node.js 24+ (recomendado via nvm-windows)."
Require-Command npm "O npm deve acompanhar o Node.js."
Require-Command git "Instale Git for Windows."

if (-not (Get-Command pi -ErrorAction SilentlyContinue)) {
    Run-Native npm @("install", "-g", "@earendil-works/pi-coding-agent")
}
Require-Command pi "Reabra o terminal depois de instalar o Pi."

if (-not $SkipOpenCodeCli -and -not (Get-Command opencode -ErrorAction SilentlyContinue)) {
    Run-Native npm @("install", "-g", "opencode-ai")
}

$corePackages = @(
    "https://github.com/rodrigojager/pi-codex-account-pool",
    "https://github.com/rodrigojager/pi-check-agent-quota",
    "https://github.com/rodrigojager/pi-opencode-direct",
    "https://github.com/rodrigojager/opencode-pi",
    "https://github.com/rodrigojager/pi-guardian",
    "npm:pi-sidebar-tui",
    "npm:pi-opencode-theme"
)

$extraPackages = @(
    "npm:@mystilleef/pi-subagent",
    "npm:@narumitw/pi-goal",
    "npm:@plannotator/pi-extension",
    "https://github.com/gchigoo/pi-session-recall",
    "https://github.com/nicobailon/pi-web-access"
)

$packages = if ($CoreOnly) { $corePackages } else { $corePackages + $extraPackages }
foreach ($package in $packages) {
    Run-Native pi @("install", $package)
}

$agentDir = Join-Path $HOME ".pi\agent"
$extensionsDir = Join-Path $agentDir "extensions"
New-Item -ItemType Directory -Force -Path $extensionsDir | Out-Null
Copy-Item -Force (Join-Path $PSScriptRoot "extensions\official-todo.ts") (Join-Path $extensionsDir "official-todo.ts")

Run-Native pi @("update", "--models")

Write-Host "`nInstalação concluída." -ForegroundColor Green
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "  1. Abra: pi"
Write-Host "  2. Adicione suas contas com /codex-account-add (repita para cada conta)."
Write-Host "  3. Rode /reload após os logins."
Write-Host "  4. Selecione modelos em /model."
Write-Host "  5. Configure o handoff em /codex-handoff-config."
Write-Host "  6. Siga CONFIGURACAO.md para tema, Guardian, contas e preferências."
Write-Host "  7. Rode .\verify.ps1 para conferir a instalação."
