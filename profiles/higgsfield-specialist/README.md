# Higgsfield specialist

An English agent profile that plans and executes Higgsfield service deliveries using Pi's native MCP integration. It works as the main profile and as a delegated child. Defaults: `openai-codex/gpt-6.1-sol`, `high` thinking.

The reduced English [Higgsfield runtime library](https://github.com/rodrigojager/higgsfield-skill-runtime) lives in `~/.agents/skills/higgsfield`, shared across agents. Its 35 nested skills also need `~/.agents/skills/higgsfield/skills` in Pi's `settings.json` `skills` array; automatic discovery stops at the parent `SKILL.md`. The profile advertises only the library's 36 skill names and reads task-relevant bodies on demand. The runtime copy retains production references, templates, cached schemas, memory, and delivery preflight helpers; skill-development tests, CI, Claude-specific configuration, PDF tooling, and maintenance archives are excluded. Its changes from upstream are documented in the library repository.

The checked-in profile and child MCP entry point are local additions. They do not modify the Higgsfield service or native Pi MCP implementation. The reduced skill library is published separately with upstream attribution. Credentials are never included here.

With the shared skill library already installed, run in PowerShell 7:

```powershell
./install.ps1
```

This merges only the Higgsfield MCP entry and nested skill path, and installs the profile and child entry point. Existing MCP servers and other settings remain. Each changed existing configuration file is backed up. It does not install/move the skill library, replace switcher packages, reload Pi, stop jobs, or initiate paid generation.

Use Pi 1.0.0 or later, [Rodrigo's agent switcher](https://github.com/rodrigojager/pi-agent-switcher) `v0.3.0-rodrigo.2` or later, and [Rodrigo's subagent runtime](https://github.com/rodrigojager/pi-subagent) `v0.12.4-rodrigo.2` or later. Activate after current work finishes with `/reload`.

- `Alt+A`: select `higgsfield-specialist`.
- `/model`: select another available, authenticated model (including `gpt-6-astra`); `Shift+Tab`: change thinking. Manual choices persist per main profile on the current session branch.
- `@higgsfield-specialist <task>`: delegate a separate task. Children use the definition's defaults; main-profile overrides do not propagate to children.
- `/mcp login higgsfield`: complete OAuth sign-in in the browser. Main conversations and delegated children use Pi's local MCP credential store.

Tools use `deferred` exposure: the agent discovers actual schemas with `tool_search` instead of loading the whole media tool catalog into every prompt. A connection requiring sign-in is not proof of authenticated execution. Confirm account access before requesting production; estimates and tool schemas must be checked before spending credits.

Official service documentation: [Higgsfield MCP](https://higgsfield.ai/creator-hub/help-center/integrations/what-is-higgsfield-mcp).
