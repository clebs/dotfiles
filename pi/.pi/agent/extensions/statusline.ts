/**
 * Statusline extension — replicates Claude's statusline.sh for pi.
 * Shows: [CAVEMAN] model ██░░░░░░░░ 20% $1.23
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

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
          // Token stats
          let input = 0, output = 0, cost = 0;
          for (const e of ctx.sessionManager.getBranch()) {
            if (e.type === "message" && e.message.role === "assistant") {
              const m = e.message as AssistantMessage;
              input += m.usage.input;
              output += m.usage.output;
              cost += m.usage.cost.total;
            }
          }

          // Context percentage — estimate from input tokens vs context window
          const contextWindow = ctx.model?.contextWindow ?? 200000;
          const pct = Math.min(100, Math.round((input / contextWindow) * 100));

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

          const line = `${badge}${theme.fg("accent", model)} ${bar} ${pct}% ${theme.fg("dim", costFmt)}`;

          return [truncateToWidth(line, width)];
        },
      };
    });
  });
}
