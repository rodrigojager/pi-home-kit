$ErrorActionPreference = "Stop"

function Check([bool]$Condition, [string]$Ok, [string]$Fail) {
    if ($Condition) { Write-Host "[OK] $Ok" -ForegroundColor Green }
    else { Write-Host "[FALHA] $Fail" -ForegroundColor Red; $script:failed = $true }
}

$failed = $false
Check ($null -ne (Get-Command pi -ErrorAction SilentlyContinue)) "Pi encontrado" "Pi nao esta no PATH"
if (-not (Get-Command pi -ErrorAction SilentlyContinue)) { exit 1 }

$list = (& pi list 2>&1 | Out-String)
$requiredPackages = @(
    "pi-codex-account-pool",
    "pi-check-agent-quota",
    "pi-opencode-direct",
    "opencode-pi",
    "pi-guardian",
    "pi-sidebar-tui",
    "pi-opencode-theme"
)
foreach ($name in $requiredPackages) {
    Check ($list -match [regex]::Escape($name)) "$name instalado" "$name ausente"
}

$models = (& pi --list-models 2>&1 | Out-String)
foreach ($provider in @("codex-account-pool", "openai-codex", "opencode-direct", "opencode-cli")) {
    Check ($models -match "(?m)^$([regex]::Escape($provider))\s") "Provider $provider disponivel" "Provider $provider sem modelos"
}
Check ($models -match "gpt-5\.6-sol") "gpt-5.6-sol catalogado" "gpt-5.6-sol ausente"
Check ($models -match "gpt-6-astra") "gpt-6-astra catalogado" "gpt-6-astra ausente"
Check ($models -match "muse-spark-1\.3-contributor-free") "Muse Spark Responses catalogado" "Muse Spark ausente"

$agentDir = Join-Path $HOME ".pi\agent"
Check (Test-Path (Join-Path $agentDir "extensions\official-todo.ts")) "Todo oficial instalado" "Todo oficial ausente"
$guardianPath = Join-Path $agentDir "pi-guardian.json"
if (Test-Path $guardianPath) {
    try {
        $guardianEnabled = [bool]((Get-Content -Raw $guardianPath | ConvertFrom-Json).enabled)
        Write-Host "[INFO] Guardian configurado como: $(if ($guardianEnabled) { 'ON' } else { 'OFF' })" -ForegroundColor Yellow
    } catch {
        Write-Host "[AVISO] Configuracao do Guardian nao pode ser lida." -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] Guardian ainda usa o padrao ON; consulte CONFIGURACAO.md." -ForegroundColor Yellow
}

if ($failed) { exit 1 }
Write-Host "`nTudo pronto. Credenciais nao sao verificadas por este script." -ForegroundColor Cyan
