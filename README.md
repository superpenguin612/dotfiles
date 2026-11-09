# dotfiles

My shell, tmux, Neovim and tool configs, managed with [chezmoi](https://chezmoi.io).

## Install

Full profile (configs, CLI tools through mise, system packages through apt or Homebrew):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply superpenguin612
```

It asks for the profile once. Light profile (config files only, for lab boxes; installs nothing
and removes chezmoi, its source and its config afterwards):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /tmp init --one-shot --purge-binary --promptChoice profile=light superpenguin612
```

Both need `curl` and `git`. On a box without them, copy the files by hand.

## Profiles

- `full`: everything. The tool list is `dot_config/mise/config.toml.tmpl`; apt (Linux) or
  `Brewfile` (Mac) adds only what mise can't install. Without sudo, the apt step is skipped.
- `light`: zsh, vim, git and tmux configs only. No Neovim config, plugins or tools.

If `~/src/agents/dotfiles` exists, chezmoi uses it as the source, so `chezmoi diff` and
`chezmoi apply` work on that clone.

## Local overrides

Machine-specific settings go in these files, created empty if missing and never overwritten:

- `~/.zshenv.local`, `~/.zshrc.local` (sourced last)
- `~/.gitconfig.local` (included last: signing key, hooks)
- `~/.config/tmux/local.conf` (sourced last)

Aliases and the zoxide `cd` load only in interactive shells that aren't run by an agent
(`CLAUDECODE`, `CODEX_THREAD_ID`, `PI_CODING_AGENT`, `OMPCODE` or `AI_AGENT` set).

## Mac: iTerm2 setup

iTerm2 overwrites its settings when it quits, so these are done by hand once after the install:

1. Settings → Profiles: select **dotfiles**, then Other Actions → Set as Default. Open a new window.
2. Settings → General → Magic: turn on **Enable Python API**.
3. Scripts → Manage → **Install Python Runtime**, then restart iTerm2. The AutoLaunch script
   `agent_ping.py` starts with iTerm2 from then on.
4. System Settings → Notifications: allow notifications for iTerm2 and for alerter (it asks the
   first time it posts).

`agent_ping.py` turns pings from
[agent-ping](https://github.com/superpenguin612/llms/tree/main/contrib/agent-ping) on the dev
machine into macOS notifications with a title and sound, through `alerter`. Clicking one brings
that iTerm2 window forward.

## Mac: Raycast

Raycast is the launcher and clipboard manager, opened with ⌥Space (Spotlight keeps ⌘Space). The
right ⌘ key is a Hyper key (⌃⌥⇧⌘, set in `dot_config/karabiner/karabiner.json`), which no app uses
for its own shortcuts. Raycast keeps its hotkeys in its own settings, so they are set by hand in
Settings → Extensions:

| Hyper + | Opens | Hyper + | Runs |
|---|---|---|---|
| T | iTerm | V | Clipboard History |
| B | Firefox | E | Search Emoji & Symbols |
| O | Obsidian | X | Search Snippets |
| D | Discord | Space | Search Files |
| S | Slack | K | Waiting Agents |
| G | Signal | J | Sessions |
| A | Claude | Q | New Claude Task |
| P | Bitwarden | | |
| F | Finder | | |
| R | Zotero | | |

Window management uses Hyper with the arrow keys for halves, Return to maximize, C to center,
`[` and `]` for the left and right thirds, `\` for two thirds, N to move to the next display, and
Z to restore. Clipboard History should keep its history for 3 months, which is the longest the free
plan allows.

From the Raycast Store: GitHub, Tailscale, Kill Process, Homebrew, Color Picker, Port Manager and
Docker.

### The devserver extension

`raycast/devserver` is a private extension that reaches the dev machine over SSH (host
`devserver`, which can be changed in the extension's preferences). Its commands are Sessions,
Waiting Agents, New Claude Task, VM Status, Repos on GitHub, Copy from VM, Send to VM and Open VM
Port. The work on the dev machine is done by `~/.local/bin/raycast-vm`, so that side must have
these dotfiles applied as well. To install the extension, run the following once in the chezmoi
source and stop it with Ctrl-C after Raycast shows the commands:

```sh
cd raycast/devserver && npm install && npm run dev
```

### Snippets, quicklinks and the settings backup

`raycast/snippets.json` and `raycast/quicklinks.json` hold generic snippets (dates, a code block
from the clipboard, a few commands) and search quicklinks; import them with Raycast's Import
Snippets and Import Quicklinks commands. Personal snippets, such as an email address or a postal
address, are added in Raycast directly and are never committed here.

`raycast-export` turns a Raycast export (Settings → Advanced → Export) into
`raycast/settings.json`, a readable copy with the clipboard and notes removed and with snippet
text, links, extension preferences and anything resembling a token replaced by `<redacted>`. It
also copies the original file to iCloud Drive under `Raycast/`, which is the copy to import when
restoring. **Read the diff before committing `raycast/settings.json`**, since the redaction works
by pattern and the export format is not documented.

## Mac: menu bar, borders and the look

The Brewfile installs SketchyBar and JankyBorders and starts both at login. SketchyBar replaces
the menu bar on every display with Tokyo Night pills: the Spaces with their apps' icons and the
front app on the left, and the agents waiting on the dev machine, the next calendar event, CPU and
memory, volume, Wi-Fi, battery and the clock on the right. The `⋯` item opens a row containing
every other menu bar app. JankyBorders draws a blue-to-purple border around the focused window.

After `chezmoi apply` on a Mac, these steps are done once:

1. Run `mac-defaults`, which sets the Dock to hide automatically, hides the native menu bar,
   keeps Spaces in a fixed order and turns on dark mode. The accent and highlight colors are set
   in System Settings → Appearance.
2. In System Settings → Keyboard → Keyboard Shortcuts → Mission Control, turn on "Switch to
   Desktop 1" through "Switch to Desktop 9" (⌃1 to ⌃9); clicking a Space in SketchyBar uses them.
3. In System Settings → Privacy & Security, give SketchyBar Screen Recording (for the `⋯` row)
   and allow Calendar access when icalBuddy asks for it.
4. Quit Logi Options+ and uninstall it before starting OpenLogi, since both take control of the
   mouse and keyboard; then give OpenLogi Accessibility and Input Monitoring. The MX Brio needs
   no Logitech software; CameraController adjusts its zoom, focus and exposure, though it has not
   been updated since 2025 and may not work on macOS 26.
5. Apply Tokyo Night themes in the apps that keep their own: Firefox, Obsidian, BetterDiscord,
   Slack (sidebar colors) and Raycast.

If clicking an icon in the `⋯` row doesn't open that app's menu, install Hidden Bar
(`brew install --cask hiddenbar`) and use it in the native menu bar instead.

`fastfetch` prints a system summary in the same colors when run.

## Python

mise installs every tool, Python ones included; uv handles Python projects and scripts.

- Command-line tool: add `"pipx:<pkg>" = "latest"` to `dot_config/mise/config.toml.tmpl` (mise
  installs it in its own env through uv), or `mise use -g pipx:<pkg>` to try one.
- Project: `uv init`, `uv add <pkg>`, `uv run <cmd>` (a `.venv` in the repo).
- One-off script: `uv run --with pandas python script.py` (nothing to keep around).

`PIP_REQUIRE_VIRTUALENV` is set, so `pip install` refuses to run outside a venv.

Cleaning up an older Mac setup (Miniconda, pipx, Homebrew Pythons), once:

```sh
conda env list                       # anything worth keeping? export it first
brew uninstall --cask miniconda
rm -rf ~/.conda ~/.condarc           # and delete the "conda initialize" block in ~/.bash_profile
brew uninstall pipx
brew uninstall python@3.12 python@3.13 python@3.15   # brew refuses any that something still needs
ls ~/Library/Python 2>/dev/null      # old `pip install --user` packages; delete once the uv tools work
```

Apple's `/usr/bin/python3` stays; nothing else should use it.

## Mac SSH

In the Mac's own `~/.ssh/config` (not tracked here):

```
Host devserver
  LocalForward 8090 127.0.0.1:8090   # Neovim Markdown preview
  ControlMaster auto
  ControlPath ~/.ssh/cm-%r@%h:%p
  ControlPersist 10m
```

`dev` (Mac only) SSHes to `$DEV_HOST` (default `devserver`; set it in `~/.zshrc.local`) and
attaches the `main` tmux session.

## Credits

The Tokyo Night colors (`dot_config/bat/themes/tokyonight_night.tmTheme`, `dot_config/yazi/theme.toml`,
`dot_config/zsh/fzf-tokyonight.zsh` and the iTerm2 profile's
colors) come from [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim), MIT License,
Copyright (c) 2021 Folke Lemaitre.
