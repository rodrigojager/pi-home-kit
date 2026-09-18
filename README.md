# Pi Home Kit

Kit reproduzível para instalar no PC de casa o ambiente Pi usado por Rodrigo.

## O que é transportado

- Forks publicados no GitHub, instalados diretamente por URL.
- Extensão `todo` oficial do Pi em `extensions/official-todo.ts`.
- Instalador PowerShell idempotente.
- Verificador de pacotes, providers e modelos.
- Manifesto com os commits auditados.

### Plugins incluídos no modo completo

- `pi-codex-account-pool`
- `pi-check-agent-quota`
- `pi-opencode-direct`
- `opencode-pi`
- `pi-guardian`
- `pi-sidebar-tui`
- `pi-opencode-theme`
- `@mystilleef/pi-subagent`
- `@narumitw/pi-goal`
- `@plannotator/pi-extension`
- `pi-session-recall`
- `pi-web-access`
- extensão `todo` oficial do Pi

## O que não é transportado

- OAuth tokens, API keys, `auth.json` ou contas do pool.
- Conta ativa, modelo padrão e preferências pessoais.
- Cache de quota e handoffs privados.
- Skills globais compartilhadas com Codex e outros agentes (`find-skills`, `last30days`, `understand-*`), intencionalmente fora deste pack.

Essas opções estão descritas em [CONFIGURACAO.md](CONFIGURACAO.md).

## Instalação mais fácil

### Opção A — baixar o Release

1. Abra a página **Releases** deste repositório.
2. Baixe `pi-home-kit.zip`.
3. Extraia o ZIP.
4. Abra PowerShell dentro da pasta extraída.
5. Execute:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
.\verify.ps1
```

### Opção B — clonar

```powershell
git clone https://github.com/rodrigojager/pi-home-kit.git
cd pi-home-kit
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1
.\verify.ps1
```

Por padrão, o instalador reproduz o conjunto completo. Para instalar apenas provider pool, quota, OpenCode, Guardian, sidebar e tema:

```powershell
.\install.ps1 -CoreOnly
```

Se não quiser instalar o OpenCode CLI usado pelo provider de fallback:

```powershell
.\install.ps1 -SkipOpenCodeCli
```

## Componentes principais

| Componente | Função |
|---|---|
| `pi-codex-account-pool` | Pool OAuth multi-conta, failover e handoff configurável |
| `pi-check-agent-quota` | Quota da conta atualmente ativa |
| `pi-opencode-direct` | OpenCode Zen gratuito por HTTP direto, inclusive Responses |
| `opencode-pi` | Fallback via CLI oficial do OpenCode |
| `pi-guardian` | Revisão automática opcional; fork com persistência e correção Windows |
| `pi-sidebar-tui` | Sidebar inspirada no OpenCode |
| `official-todo.ts` | Tool `todo` oficial que alimenta o painel Todos da sidebar |
| `pi-opencode-theme` | Tema inspirado no OpenCode |

## Atualização

Execute:

```powershell
.\update.ps1
```

Depois, dentro do Pi:

```text
/reload
```

## Segurança

O repositório é público e não contém credenciais. Nunca copie para ele:

```text
~/.pi/agent/auth.json
~/.pi/agent/codex-account-pool/accounts.json
```
