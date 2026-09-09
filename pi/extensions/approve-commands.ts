/**
 * Approve Commands Extension
 *
 * Prompts for confirmation before every bash command pi runs. Gates the
 * `bash` tool only — file reads, edits, writes, and searches run without
 * prompting.
 *
 * Per-prompt choices:
 *   - Yes                              run this one command
 *   - No                              block this command
 *   - Yes, allow all for this session  switch to auto mode until you flip back
 *
 * Runtime toggle:
 *   /approve         toggle between approve mode and auto mode
 *   /approve on      require approval for every bash command
 *   /approve off     auto mode — run bash commands without prompting
 *   /approve status  report the current mode
 *
 * A footer status shows the current mode. In non-interactive mode (no UI)
 * commands are blocked while approval is on, since there is no way to approve.
 *
 * Global extension: applies to every project. Hot-reload after edits with
 * /reload. State resets to "approve on" each session.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	// true  = prompt before every bash command (default)
	// false = auto mode, run without prompting
	let approvalOn = true;

	const showStatus = (ctx: { ui: { setStatus: (id: string, text: string) => void } }) => {
		ctx.ui.setStatus("approve-commands", approvalOn ? "commands: approve" : "commands: AUTO");
	};

	pi.on("session_start", (_event, ctx) => {
		approvalOn = true;
		showStatus(ctx);
	});

	pi.registerCommand("approve", {
		description: "Toggle bash-command approval (on | off | status)",
		handler: async (args, ctx) => {
			const arg = (args || "").trim().toLowerCase();
			if (arg === "on") approvalOn = true;
			else if (arg === "off") approvalOn = false;
			else if (arg === "status") {
				ctx.ui.notify(`Command approval is ${approvalOn ? "ON" : "OFF (auto mode)"}`, "info");
				showStatus(ctx);
				return;
			} else approvalOn = !approvalOn; // bare /approve toggles

			showStatus(ctx);
			ctx.ui.notify(
				approvalOn
					? "Command approval ON — you'll be asked before each bash command."
					: "Command approval OFF — bash commands run automatically.",
				"info",
			);
		},
	});

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;
		if (!approvalOn) return undefined;

		const command = (event.input.command as string) ?? "";

		if (!ctx.hasUI) {
			return { block: true, reason: "Bash command blocked (no UI to approve it)" };
		}

		const choice = await ctx.ui.select(
			`Run this command?\n\n  ${command}`,
			["Yes", "No", "Yes, allow all for this session"],
		);

		if (choice === "Yes, allow all for this session") {
			approvalOn = false;
			showStatus(ctx);
			return undefined;
		}

		if (choice !== "Yes") {
			return { block: true, reason: "Blocked by user" };
		}

		return undefined;
	});
}
