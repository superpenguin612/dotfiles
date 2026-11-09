import { LaunchProps, showToast, Toast } from "@raycast/api";
import { showFailureToast } from "@raycast/utils";
import { basename } from "node:path";
import { host, hud, local, run } from "./vm";

export default async function Command(props: LaunchProps<{ arguments: { path: string } }>) {
  const path = props.arguments.path.trim().replace(/\/+$/, "");
  const dest = local("~/Downloads");
  const toast = await showToast({ style: Toast.Style.Animated, title: `Copying ${basename(path)}` });
  try {
    await run("/usr/bin/scp", ["-r", "-o", "BatchMode=yes", `${host()}:${path}`, `${dest}/`], 600000);
    await run("/usr/bin/open", ["-R", `${dest}/${basename(path)}`]);
    await toast.hide();
    await hud(`Copied ${basename(path)} to Downloads`);
  } catch (e) {
    await showFailureToast(e, { title: "Copy failed" });
  }
}
