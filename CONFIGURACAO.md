# Configuração no PC de casa

Execute primeiro `install.ps1`. Esta página contém apenas escolhas e credenciais pessoais.

## 1. Contas Codex

Abra o Pi:

```powershell
pi
```

Adicione cada conta separadamente:

```text
/codex-account-add
```

Repita para todas as contas. Depois confira e selecione a conta Pro:

```text
/codex-accounts
```

Não copie `auth.json` ou `accounts.json` para o GitHub. Se optar por transferência privada entre suas próprias máquinas, trate esses arquivos como senhas.

## 2. Atualizar catálogos

No PowerShell:

```powershell
pi update --models
```

Depois, no Pi:

```text
/reload
```

Devem aparecer providers separados:

```text
openai-codex/*
codex-account-pool/*
opencode-direct/*
opencode-cli/*
opencode-go/*
```

Entre os modelos Codex esperados estão `gpt-5.6-sol` e `gpt-6-astra`.

## 3. Tema e TUI

No arquivo `~/.pi/agent/settings.json`, use:

```json
{
  "theme": "opencode",
  "tuiMode": "fullscreen"
}
```

Preserve as demais propriedades existentes. O comando `pi install` já registra os pacotes na lista `packages`.

Controle da sidebar:

```text
/sidebar-tui on
/sidebar-tui width 45
/sidebar-tui todos 10
```

## 4. Todos da sidebar

O painel **Todos** não analisa texto comum do chat. Ele atualiza quando o agente chama o tool oficial:

```text
todo({ action: "add", text: "Minha etapa" })
todo({ action: "toggle", id: 1 })
```

Eventos observados pela sidebar:

```text
tool_call / tool_result
toolName: todo
details.todos: [{ id, text, done }]
```

Para testar, peça ao agente:

```text
Use o tool todo para adicionar uma tarefa chamada "Testar sidebar".
```

## 5. Guardian

O fork corrige o caminho `C:\C:\...` no Windows e faz `/guardian off` persistir entre reloads.

Para deixá-lo desligado:

```text
/guardian off
```

Para ativar:

```text
/guardian on
```

Estado persistido em:

```text
~/.pi/agent/pi-guardian.json
```

## 6. Handoff

Configure em:

```text
/codex-handoff-config
```

O seletor lista dinamicamente todos os providers. É possível escolher `opencode-direct/*` como primary e outro provider como fallback.

Opções por modelo disponíveis:

- reasoning (`auto`, `off`, `minimal`, `low`, `medium`, `high`, `xhigh`, `max`)
- máximo de tokens
- temperature
- timeout
- sampling params JSON
- limite de caracteres de entrada

Gerar handoff:

```text
/codex-handoff
```

## 7. OpenCode gratuito

Preferencial, sem CLI:

```text
opencode-direct/mimo-v2.5-free
opencode-direct/muse-spark-1.3-contributor-free
```

Fallback mais resiliente, usando o executável oficial:

```text
opencode-cli/opencode/mimo-v2.5-free
```

## 8. Diagnóstico

No diretório do kit:

```powershell
.\verify.ps1
```

Se um provider não aparecer:

```powershell
pi update --models
pi list
pi --list-models
```

Depois execute `/reload` dentro do Pi.
