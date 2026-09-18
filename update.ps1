$ErrorActionPreference = "Stop"

$packages = @(
    "https://github.com/rodrigojager/pi-codex-account-pool",
    "https://github.com/rodrigojager/pi-check-agent-quota",
    "https://github.com/rodrigojager/pi-opencode-direct",
    "https://github.com/rodrigojager/opencode-pi",
    "https://github.com/rodrigojager/pi-guardian",
    "npm:pi-sidebar-tui",
    "npm:pi-opencode-theme",
    "npm:@mystilleef/pi-subagent",
    "npm:@narumitw/pi-goal",
    "npm:@plannotator/pi-extension",
    "https://github.com/gchigoo/pi-session-recall",
    "https://github.com/nicobailon/pi-web-access"
)

foreach ($package in $packages) {
    Write-Host "`nAtualizando $package" -ForegroundColor Cyan
    & pi update $package
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Nao foi possivel atualizar $package (talvez nao esteja instalado)."
    }
}

& pi update --models
if ($LASTEXITCODE -ne 0) { throw "Falha ao atualizar catalogos." }
Write-Host "`nAtualizacao concluida. Execute /reload dentro do Pi." -ForegroundColor Green
