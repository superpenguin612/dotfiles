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
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot --purge-binary --promptChoice profile=light superpenguin612
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

Aliases and the zoxide `cd` load only in interactive shells that aren't run by an agent
(`CLAUDECODE`, `CODEX_THREAD_ID`, `PI_CODING_AGENT`, `OMPCODE` or `AI_AGENT` set).

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
