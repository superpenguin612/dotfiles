// Talks to the VM over SSH; the VM side is ~/.local/bin/raycast-vm from the same dotfiles.
import { closeMainWindow, getPreferenceValues, showHUD } from "@raycast/api";
import { runAppleScript } from "@raycast/utils";
import { execFile } from "node:child_process";
import { homedir } from "node:os";
import { promisify } from "node:util";

const exec = promisify(execFile);

export const host = () => getPreferenceValues<{ host: string }>().host || "devserver";

// Single-quotes a word for the VM's shell.
export const quote = (s: string) => `'${s.replace(/'/g, `'\\''`)}'`;

export async function run(cmd: string, args: string[], timeout = 20000) {
  return (await exec(cmd, args, { timeout })).stdout;
}

export async function ssh(remote: string) {
  return run("/usr/bin/ssh", ["-o", "BatchMode=yes", "-o", "ConnectTimeout=5", host(), remote]);
}

export async function vm(...args: string[]) {
  return ssh(["~/.local/bin/raycast-vm", ...args.map(quote)].join(" "));
}

export const rows = (out: string) =>
  out
    .split("\n")
    .filter(Boolean)
    .map((l) => l.split("\t"));

export const tilde = (p: string) => p.replace(/^\/home\/[^/]+|^\/Users\/[^/]+/, "~");
export const local = (p: string) => p.replace(/^~/, homedir());

// Brings the result of `raycast-vm open|go|task` forward: an attached client already moved, so
// raise iTerm2; otherwise open an iTerm2 tab attached to that session.
export async function show(reply: string) {
  const m = reply.trim().match(/^attach (.+)$/);
  const cmd = m ? `/usr/bin/ssh -t ${host()} tmux new -A -s ${m[1]}` : "";
  await runAppleScript(
    m
      ? `tell application "iTerm"
  activate
  if (count of windows) = 0 then
    create window with default profile command "${cmd.replace(/["\\]/g, "\\$&")}"
  else
    tell current window to create tab with default profile command "${cmd.replace(/["\\]/g, "\\$&")}"
  end if
end tell`
      : `tell application "iTerm" to activate`,
  );
  await closeMainWindow();
}

export const hud = showHUD;
