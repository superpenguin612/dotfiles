import { Action, ActionPanel, Form, Icon } from "@raycast/api";
import { showFailureToast, usePromise } from "@raycast/utils";
import { basename } from "node:path";
import { rows, show, tilde, vm } from "./vm";

export default function Command() {
  const { data, isLoading } = usePromise(async () => rows(await vm("sessions")));

  async function submit(v: { target: string; task: string }) {
    if (!v.task.trim()) return;
    try {
      await show(await vm("task", v.target, v.task));
    } catch (e) {
      await showFailureToast(e, { title: "Could not start the task" });
    }
  }

  return (
    <Form
      isLoading={isLoading}
      actions={
        <ActionPanel>
          <Action.SubmitForm title="Start Claude" icon={Icon.Play} onSubmit={submit} />
        </ActionPanel>
      }
    >
      <Form.Dropdown id="target" title="Project">
        {data?.map(([kind, name, , , path]) =>
          kind === "session" ? (
            <Form.Dropdown.Item key={`s:${name}`} value={name} title={name} icon={Icon.Terminal} />
          ) : (
            <Form.Dropdown.Item key={`r:${path}`} value={path} title={`${basename(path)} (${tilde(path)})`} icon={Icon.Folder} />
          ),
        )}
      </Form.Dropdown>
      <Form.TextArea id="task" title="Task" placeholder="What should Claude do?" />
    </Form>
  );
}
