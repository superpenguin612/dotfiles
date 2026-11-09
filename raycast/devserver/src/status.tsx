import { Action, ActionPanel, Detail, Icon } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { host, rows, vm } from "./vm";

export default function Command() {
  const { data, isLoading, revalidate } = usePromise(async () => Object.fromEntries(rows(await vm("status"))));
  const s = data ?? {};
  const md = data
    ? `# ${host()}

| | |
|---|---|
| Load (1, 5, 15 min) | ${s.load} |
| Memory | ${s.memory} |
| Disk / | ${s.disk} |
| Agents asking | ${s.asking || 0} |
| Agents waiting | ${s.waiting || 0} |`
    : "";
  return (
    <Detail
      isLoading={isLoading}
      markdown={md}
      actions={
        <ActionPanel>
          <Action title="Refresh" icon={Icon.ArrowClockwise} onAction={revalidate} />
        </ActionPanel>
      }
    />
  );
}
