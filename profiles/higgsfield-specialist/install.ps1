param([string]$AgentDir = (Join-Path $HOME '.pi/agent'), [string]$SkillRoot = (Join-Path $HOME '.agents/skills/higgsfield'))

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if (-not (Test-Path -LiteralPath (Join-Path $SkillRoot 'SKILL.md'))) { throw "Shared Higgsfield library missing: $SkillRoot" }
if (-not (Test-Path -LiteralPath (Join-Path $SkillRoot 'skills'))) { throw 'Nested Higgsfield skill directory missing.' }
$profile = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'agent.md') -Raw
$skillNames = (($profile -split '\r?\n' | Where-Object { $_ -like 'skills: *' }) -replace '^skills: ', '') -split ',\s*'
$skillFiles = @((Join-Path $SkillRoot 'SKILL.md')) + @(Get-ChildItem -LiteralPath (Join-Path $SkillRoot 'skills') -Recurse -Filter SKILL.md -File | ForEach-Object { $_.FullName })
$available = @($skillFiles | ForEach-Object {
    $nameLine = Get-Content -LiteralPath $_ | Where-Object { $_ -match '^name:\s*' } | Select-Object -First 1
    $nameLine -replace '^name:\s*', ''
})
foreach ($name in $skillNames) { if ($name -notin $available) { throw "Missing profile skill: $name" } }

$backupDir = Join-Path $AgentDir ("backups/higgsfield-specialist-" + [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ'))
function Backup-Existing([string]$Path, [string]$Name) {
    if (Test-Path -LiteralPath $Path) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        Copy-Item -LiteralPath $Path -Destination (Join-Path $backupDir $Name)
    }
}
function Write-Json([string]$Path, $Value) {
    $Value | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $Path -Encoding utf8NoBOM
}
$settingsPath = Join-Path $AgentDir 'settings.json'
$mcpPath = Join-Path $AgentDir 'mcp.json'
$settings = if (Test-Path -LiteralPath $settingsPath) { Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json -AsHashtable } else { @{} }
$mcp = if (Test-Path -LiteralPath $mcpPath) { Get-Content -LiteralPath $mcpPath -Raw | ConvertFrom-Json -AsHashtable } else { @{} }
$nestedPath = (Join-Path $SkillRoot 'skills').Replace('\', '/')
$settings['skills'] = @(@($settings['skills']) + $nestedPath | Where-Object { $_ } | Select-Object -Unique)
if (-not $mcp.ContainsKey('mcpServers')) { $mcp['mcpServers'] = @{} }
$entry = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'mcp.json') -Raw | ConvertFrom-Json -AsHashtable
$mcp['mcpServers']['higgsfield'] = $entry['mcpServers']['higgsfield']

New-Item -ItemType Directory -Path (Join-Path $AgentDir 'agents'), (Join-Path $AgentDir 'extensions') -Force | Out-Null
$agentPath = Join-Path $AgentDir 'agents/higgsfield-specialist.md'
$extensionPath = Join-Path $AgentDir 'extensions/higgsfield-mcp-subagent.ts'
Backup-Existing $settingsPath 'settings.json'
Backup-Existing $mcpPath 'mcp.json'
Backup-Existing $agentPath 'higgsfield-specialist.md'
Backup-Existing $extensionPath 'higgsfield-mcp-subagent.ts'
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'agent.md') -Destination $agentPath -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'higgsfield-mcp-subagent.ts') -Destination $extensionPath -Force
Write-Json $settingsPath $settings
Write-Json $mcpPath $mcp
Write-Output "Installed higgsfield-specialist with $($skillNames.Count) shared skills. Backups: $backupDir"
Write-Output 'After active work finishes: /reload, then /mcp login higgsfield and Alt+A.'
