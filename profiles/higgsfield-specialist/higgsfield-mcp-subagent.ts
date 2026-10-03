import { createMcpExtension, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Explicit child extensions disable Pi's built-in extension discovery. Restore
// the native MCP factory for this child; main conversations already have it.
export default function higgsfieldSubagentMcp(pi: ExtensionAPI) {
  if (Number(process.env.PI_SUBAGENT_DEPTH ?? "0") > 0) {
    return createMcpExtension()(pi);
  }
}
