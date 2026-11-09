import { Clipboard, getSelectedFinderItems, showToast, Toast } from "@raycast/api";
import { showFailureToast } from "@raycast/utils";
import { basename } from "node:path";
import { host, hud, run, ssh } from "./vm";

// D62: files land in ~/docs/inbox on the VM; their paths go on the clipboard for a prompt.
export default async function Command() {
  let items: string[];
  try {
    items = (await getSelectedFinderItems()).map((i) => i.path);
  } catch {
    items = [];
  }
  if (!items.length) {
    await showToast({ style: Toast.Style.Failure, title: "Select files in Finder first" });
    return;
  }
  const toast = await showToast({ style: Toast.Style.Animated, title: `Sending ${items.length} item(s)` });
  try {
    await ssh("mkdir -p ~/docs/inbox");
    await run("/usr/bin/scp", ["-r", "-o", "BatchMode=yes", ...items, `${host()}:docs/inbox/`], 600000);
    const paths = items.map((p) => `~/docs/inbox/${basename(p)}`).join(" ");
    await Clipboard.copy(paths);
    await toast.hide();
    await hud(`Sent; copied ${paths}`);
  } catch (e) {
    await showFailureToast(e, { title: "Send failed" });
  }
}
