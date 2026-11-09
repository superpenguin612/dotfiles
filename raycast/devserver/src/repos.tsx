import { Action, ActionPanel, Icon, List } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { basename } from "node:path";
import { rows, tilde, vm } from "./vm";

export default function Command() {
  const { data, isLoading } = usePromise(async () => rows(await vm("repos")));
  return (
    <List isLoading={isLoading} searchBarPlaceholder="Repo">
      {data?.map(([path, url]) => (
        <List.Item
          key={path}
          title={basename(path)}
          subtitle={url.replace("https://github.com/", "")}
          accessories={[{ text: tilde(path) }]}
          icon={Icon.Code}
          actions={
            <ActionPanel>
              <Action.OpenInBrowser url={url} />
              <Action.CopyToClipboard title="Copy URL" content={url} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
