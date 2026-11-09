import { Action, ActionPanel, Icon, List } from "@raycast/api";
import { showFailureToast, usePromise } from "@raycast/utils";
import { basename } from "node:path";
import { rows, show, tilde, vm } from "./vm";

async function open(target: string) {
  try {
    await show(await vm("open", target));
  } catch (e) {
    await showFailureToast(e, { title: "Could not open it" });
  }
}

export default function Command() {
  const { data, isLoading } = usePromise(async () => rows(await vm("sessions")));
  return (
    <List isLoading={isLoading} searchBarPlaceholder="Session or repo">
      {data?.map(([kind, name, windows, attached, path]) =>
        kind === "session" ? (
          <List.Item
            key={`s:${name}`}
            title={name}
            subtitle={tilde(path)}
            icon={Icon.Terminal}
            accessories={[...(attached !== "0" ? [{ tag: "attached" }] : []), { text: `${windows} windows` }]}
            actions={
              <ActionPanel>
                <Action title="Open Session" icon={Icon.Terminal} onAction={() => open(name)} />
              </ActionPanel>
            }
          />
        ) : (
          <List.Item
            key={`r:${path}`}
            title={basename(path)}
            subtitle={tilde(path)}
            icon={Icon.Folder}
            accessories={[{ text: "new session" }]}
            actions={
              <ActionPanel>
                <Action title="Start Session" icon={Icon.Plus} onAction={() => open(path)} />
              </ActionPanel>
            }
          />
        ),
      )}
    </List>
  );
}
