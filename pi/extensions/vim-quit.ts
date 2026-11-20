/**
 * Vim-style quit: typing `:q`, `:q!`, `:qa`, `:wq`, or `:x` at the prompt exits pi.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const QUIT = new Set([":q", ":q!", ":qa", ":qa!", ":wq", ":x"]);

export default function (pi: ExtensionAPI) {
	pi.on("input", async (event, ctx) => {
		if (event.source !== "interactive") return { action: "continue" };
		if (!QUIT.has(event.text.trim())) return { action: "continue" };
		ctx.shutdown();
		return { action: "handled" };
	});
}
