# Perfil aplicado em 2026-10-02

Este perfil registra as adaptações efetivamente instaladas no Pi 1.0.0. O instalador histórico na raiz ainda usa a seleção anterior de plugins; ele não aplica este perfil automaticamente.

## Código personalizado

| Componente | Versão | Alterações |
|---|---|---|
| [Subagentes](https://github.com/rodrigojager/pi-subagent) | 0.12.4-rodrigo.1 | Numeração por execução, tarefa visível e atividade da ferramenta. |
| [Sidebar](https://github.com/rodrigojager/pi-sidebar-tui) | 1.7.5-rodrigo.3 | Tasks/subject/activeForm/owner/blockedBy do rpiv-todo, largura, replay e integração local Pi Goal. |
| [Todo](https://github.com/rodrigojager/rpiv-todo) | 2.12.0-rodrigo.1 | Migração em memória de listas official-todo, preservando IDs e conclusão. |
| [Herdr](https://github.com/rodrigojager/pi-herdr-status) | 0.2.1-rodrigo.1 | Metadata do modelo; ciclo de vida permanece na integração oficial. |

O código do rpiv-i18n 2.12.0 não foi alterado. Sua preferência de idioma é registrada abaixo.

## Configurações personalizadas

- `~/.config/rpiv-todo/config.json`: `{"maxWidgetLines":8,"collapseKey":"alt+t"}`.
- `~/.config/rpiv-i18n/locale.json`: `{"locale":"pt-BR"}`.
- `~/.pi/agent/settings.json`: excluir `!extensions/official-todo.ts`; substituir a fonte do subagent npm pelo fork. Manter uma única fonte de cada plugin.
- Herdr `config.toml`: acrescentar a linha `["$model_info"]` em `[ui.sidebar.agents.rows_by_agent]`, somente para `pi`. As linhas existentes foram preservadas; ver `herdrPiRows` em [profile.json](profile.json).
- A sidebar mantém **Ctrl+Shift+T**; o painel do todo usa **Alt+T**.

As cópias todo/Herdr foram instaladas como pacotes locais para preservar suas adaptações. Publicá-las não mudou a fonte da instalação nem recarregou a sessão. Para migrar depois às URLs GitHub, desative cada fonte local correspondente antes de habilitar a nova e termine o trabalho em andamento primeiro. O rpiv-i18n original pode ser instalado pelo npm.

## Evidência

139 testes da sidebar e 4 testes de compatibilidade passaram. Cinco extensões carregaram juntas no Pi 1.0.0 sem duplicação de ferramentas, comandos ou atalhos. O Pi instalado respondeu em RPC isolado com todos os comandos esperados; nenhuma chamada ao modelo foi feita. A configuração do Herdr foi validada e aplicada sem diagnósticos.

Nenhuma credencial, conta, sessão, node_modules ou configuração completa da máquina faz parte deste perfil.
