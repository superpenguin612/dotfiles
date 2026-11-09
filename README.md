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
