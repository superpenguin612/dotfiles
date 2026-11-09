import { LaunchProps, open, showToast, Toast } from "@raycast/api";
import { showFailureToast } from "@raycast/utils";
import { connect } from "node:net";
import { host, hud, run } from "./vm";

const listening = (port: number) =>
  new Promise<boolean>((resolve) => {
    const s = connect(port, "127.0.0.1");
    s.once("connect", () => (s.destroy(), resolve(true)));
    s.once("error", () => resolve(false));
  });

// A forward of its own (no ControlMaster), so it lives on after Raycast's command ends.
export default async function Command(props: LaunchProps<{ arguments: { port: string } }>) {
  const port = Number(props.arguments.port.trim());
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    await showToast({ style: Toast.Style.Failure, title: "Not a port number" });
    return;
  }
  try {
    if (!(await listening(port))) {
      await run("/usr/bin/ssh", [
        "-f", "-N",
        "-o", "ExitOnForwardFailure=yes",
        "-o", "BatchMode=yes",
        "-o", "ControlMaster=no",
        "-o", "ControlPath=none",
        "-L", `${port}:127.0.0.1:${port}`,
        host(),
      ]);
    }
    await open(`http://localhost:${port}`);
    await hud(`localhost:${port} → ${host()}:${port}`);
  } catch (e) {
    await showFailureToast(e, { title: "Forward failed" });
  }
}
