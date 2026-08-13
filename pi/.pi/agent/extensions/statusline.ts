/**
 * Statusline extension — replicates Claude's statusline.sh for pi.
 * Shows: [CAVEMAN] model ██░░░░░░░░ 20% $1.23
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
  let cavemanBadge = "";

  // Detect caveman from loaded skills before each agent run
  pi.on("before_agent_start", async (event, _ctx) => {
    cavemanBadge = "";
    const skills = event.systemPromptOptions?.skills;
    if (!skills) return;
    for (const skill of skills) {
      const name = (skill.name ?? skill.path ?? "").toLowerCase();
      if (name.includes("caveman")) {
        // Try to extract mode from skill name (e.g. "caveman-review", "caveman")
        const match = name.match(/caveman(?:[/-](\w+))?/);
        const mode = match?.[1];
        const suffix = mode && mode !== "full" ? `:${mode.toUpperCase()}` : "";
        cavemanBadge = `[CAVEMAN${suffix}] `;
        break;
      }
    }
  });

  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsub,
        invalidate() {},
        render(width: number): string[] {
          // Walk the branch to compute cost and find the last assistant usage
          let cost = 0;
          let lastUsage: { input: number; output: number; cacheRead: number; cacheWrite: number; totalTokens: number } | null = null;
          for (const e of ctx.sessionManager.getBranch()) {
            if (e.type === "message" && e.message.role === "assistant") {
              const m = e.message as AssistantMessage;
              cost += m.usage.cost.total;
              lastUsage = m.usage;
            }
          }

          // Context percentage from last assistant message's usage
          // totalTokens = input + output + cacheRead + cacheWrite (full context window consumption)
          const contextWindow = ctx.model?.contextWindow ?? 200000;
          const contextTokens = lastUsage
            ? (lastUsage.totalTokens || lastUsage.input + lastUsage.output + lastUsage.cacheRead + lastUsage.cacheWrite)
            : 0;
          const pct = Math.min(100, (contextTokens / contextWindow) * 100);

          // Progress bar
          const filled = Math.floor(pct / 10);
          const empty = 10 - filled;
          const barColor = pct >= 90 ? "error" : pct >= 70 ? "warning" : "success";
          const bar = theme.fg(barColor, "█".repeat(filled) + "░".repeat(empty));

          // Model name
          const model = ctx.model?.id ?? "no-model";

          // Cost
          const costFmt = `$${cost.toFixed(2)}`;

          // Badge
          const badge = cavemanBadge ? theme.fg("warning", cavemanBadge) : "";

          const pctFmt = Math.round(pct).toString();

          const line = `${badge}${theme.fg("accent", model)} ${bar} ${pctFmt}% ${theme.fg("success", theme.bold(costFmt))}`;

          return [truncateToWidth(line, width)];
        },
      };
    });


  });
}
