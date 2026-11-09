import { Action, ActionPanel, Color, Icon, List } from "@raycast/api";
import { showFailureToast, usePromise } from "@raycast/utils";
import { rows, show, vm } from "./vm";

const look: Record<string, { icon: Icon; tint: Color }> = {
  ask: { icon: Icon.QuestionMarkCircle, tint: Color.Red },
  permission: { icon: Icon.Lock, tint: Color.Yellow },
  done: { icon: Icon.CheckCircle, tint: Color.Blue },
  idle: { icon: Icon.Circle, tint: Color.SecondaryText },
};

const age = (s: number) => (s < 60 ? `${s}s` : s < 3600 ? `${Math.floor(s / 60)}m` : `${Math.floor(s / 3600)}h`);

async function go(window: string) {
  try {
    await show(await vm("go", window));
  } catch (e) {
    await showFailureToast(e, { title: "Could not open the window" });
  }
}

export default function Command() {
  const { data, isLoading, revalidate } = usePromise(async () => rows(await vm("agents")));
  return (
    <List isLoading={isLoading} searchBarPlaceholder="Waiting agents">
      <List.EmptyView icon={Icon.CheckCircle} title="No agent is waiting" />
      {data?.map(([id, where, name, why, secs, text]) => (
        <List.Item
          key={id}
          title={text || name}
          subtitle={`${where} ${name}`}
          icon={{ source: look[why]?.icon ?? Icon.Circle, tintColor: look[why]?.tint }}
          accessories={[{ tag: why }, { text: age(Number(secs)) }]}
          actions={
            <ActionPanel>
              <Action title="Go to Window" icon={Icon.Terminal} onAction={() => go(id)} />
              <Action title="Refresh" icon={Icon.ArrowClockwise} shortcut={{ modifiers: ["cmd"], key: "r" }} onAction={revalidate} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
