# Cheat sheet

Space is `<leader>` in Neovim. Press it and wait: which-key shows what comes next.
In tmux the prefix is `Ctrl-Space`; `Ctrl-b` still works. "prefix + x" means press the prefix, release, then press x.

## Day one

| Do this | Why |
|---|---|
| `:Tutor` | The built-in 30-minute Vim lesson. Do it first. |
| `<leader>` then wait | which-key lists every key under it. |
| `<leader>sk` | Search all keymaps (LazyVim default). |
| Watch for hardtime hints | They suggest a better motion (for example when you press `j` ten times). They never block a key, and the mouse works. |
| `:LazyExtras`, `:Lazy`, `:Mason` | Extras, plugins, language servers. |
| `:q` / `:w` / `:wq` / `Ctrl-S` | Quit, save, both. `Ctrl-S` saves in LazyVim. |

## Vim moves worth learning first

| Keys | Does |
|---|---|
| `h j k l` | Left, down, up, right. |
| `w` / `b` / `e` | Next word, previous word, end of word. |
| `0` / `^` / `$` | Line start, first character, line end. |
| `gg` / `G` | File start, file end. |
| `{` / `}` | Previous, next blank line (paragraph). |
| `%` | Jump to the matching bracket. |
| `f<c>` / `t<c>`, then `;` | Jump to (or before) a character on the line; `;` repeats. |
| `i` `a` `o` `O` | Insert before, after, on a new line below, above. |
| `Esc` | Back to normal mode. |
| `x` `dd` `yy` `p` | Delete character, delete line, copy line, paste. |
| `d{motion}` `c{motion}` `y{motion}` | Operator plus motion: `dw`, `c$`, `yap`. |
| `ciw` `ci"` `dap` | Change word, change inside quotes, delete paragraph. Text objects: `i` is inside, `a` is around. |
| `.` | Repeat the last change. |
| `u` / `Ctrl-R` | Undo, redo. |
| `v` / `V` / `Ctrl-V` | Select by character, line, block. |
| `/text`, `n`, `N` | Search, next, previous. |
| `*` | Search the word under the cursor. |
| `Ctrl-O` / `Ctrl-I` | Jump back, forward through your position history. |

## VS Code to Neovim

Keys marked (LazyVim) are LazyVim defaults. Check unfamiliar ones with which-key.

| VS Code | Neovim |
|---|---|
| Ctrl-P, open file | `<leader>ff` (LazyVim, snacks picker) |
| Ctrl-Shift-F, search in files | `<leader>sg` (live grep) |
| Find and replace in project | `<leader>sr` (grug-far; ast-grep is installed for code-shape patterns) |
| F12, go to definition | `gd` |
| Find references | `gr` |
| Hover docs | `K` |
| F2, rename symbol | `<leader>cr` |
| Quick fix, code action | `<leader>ca` |
| Cmd+D, next match | `Ctrl-N` (see Multiple cursors) |
| Ctrl-/, comment | `gcc` (line), `gc` + motion or on a selection |
| Format on save | On by default (LazyVim). Format by hand: `<leader>cf`. |
| File explorer | `<leader>e` |
| Git panel | `<leader>gg` opens lazygit. Also `lg` in the shell and prefix + g in tmux. |
| Debugger | `<leader>db` toggle breakpoint, `<leader>dc` continue (dap extra is on). Press `<leader>d` for the rest. |
| Terminal | tmux window 3, or prefix + c for a new one. |

### Markdown and LaTeX preview

| Task | How |
|---|---|
| Markdown in the buffer | Rendered automatically (render-markdown). |
| Markdown in a browser | `:MarkdownPreview`. It serves on `127.0.0.1:8090` and prints the URL. Open it on the Mac. |
| Mac side | `LocalForward 8090 127.0.0.1:8090` in the Mac's `~/.ssh/config` (see README). Without it the URL does not load. |
| LaTeX | vimtex compiles with latexmk. `\ll` starts continuous compile, `\lv` views. The PDF opens with `pdfpane` in a tmux pane. |

## Multiple cursors

Use the lightest one that does the job.

| Layer | Keys | Use for |
|---|---|---|
| LSP rename | `<leader>cr` | Renaming a variable or function. Understands scope. |
| Search and repeat | `*`, then `cgn`, type the new text, `Esc`, then `.` per match | Quick edits of one word. `.` applies to the next match; `n` skips one. |
| multicursor.nvim | `Ctrl-N` | Add a cursor at the next match of the word or selection (Cmd+D). |
| | `<leader>ms` | Skip this match, add the next. |
| | `<leader>mA` | Cursors at all matches. |
| | `<leader>mj` / `<leader>mk` | Add a cursor below / above. |
| | `Esc` | Clear the extra cursors (only while there are several). |

## Claude in Neovim

| Keys | Does |
|---|---|
| `<leader>ac` | Toggle the Claude split. |
| `<leader>as` | Send the selection to Claude (visual mode). |
| `<leader>aa` / `<leader>ad` | Accept / deny a diff Claude proposes. |

Claude's edits open as a vertical-split diff. No inline completions are set up on purpose.

To connect a Claude already running in another tmux window (window 2 of a project session), run `/ide` inside it and pick Neovim.

## tmux beyond `C-b w`

| Keys | Does |
|---|---|
| `t` (shell) or prefix + T | Project picker: git repos under `~/src`, project folders, open sessions, zoxide history. Picking a new one starts a session with window 1 nvim, window 2 claude, window 3 shell. Picking an open one attaches. |
| prefix + s | Tree of all sessions and windows. |
| prefix + L | Back to the last session. |
| prefix + w | Window list (names show Claude's conversation topic, so they differ). |
| prefix + 1, 2, 3 | Go to that window. |
| prefix + c | New window. |
| prefix + z | Zoom the current pane; again to restore. |
| prefix + `-` or `_` | Split (oh-my-tmux: `-` splits horizontally, `_` vertically). |
| prefix + % / " | Stock splits, if the oh-my-tmux ones differ. |
| `Ctrl-h/j/k/l` | Move between tmux panes and Neovim splits, no prefix. |
| prefix + C-l | Clear the screen and scrollback (plain `Ctrl-l` belongs to the navigator). |
| prefix + g | lazygit in a popup, in the current folder. |
| prefix + a | Claude in a popup, in the current folder. |
| prefix + [ | Copy mode (vi keys). `v` select, `y` yank, `q` quit. Yanks reach the Mac clipboard (OSC 52). Mouse scroll also enters it. |
| prefix + d | Detach. |

### Agents waiting on you

| Keys | Does |
|---|---|
| ● in the status bar | N agents are waiting (permission prompt, question, or finished turn). |
| prefix + W | List windows with a waiting agent. |
| prefix + N | Jump to the oldest waiting window. |

Sending a prompt clears the marker. A Mac notification also appears.

### After a reboot

tmux-resurrect and continuum restore sessions on their own. Claude and Codex panes run `claude --resume <id>` / `codex resume <id>` for you. Manual save is prefix + Ctrl-s, restore prefix + Ctrl-r.

## Parallel agents

| Command | Does |
|---|---|
| `claude -w <task> --tmux=classic` | New git worktree plus its own tmux session. The picker and the waiting markers work with it. |
| `claude --remote-control` | Lets you answer the session from your phone or claude.ai. |

## Shell aliases and tools

Aliases load in interactive human shells only, not in agent shells.

| Command | Does |
|---|---|
| `v` | nvim |
| `lg` | lazygit |
| `t` | Project picker (same as prefix + T) |
| `cl`, `cluade` | claude |
| `ls` `ll` `la` `lt` | eza: plain, long with git, all, tree (2 levels) |
| `cat` | bat without paging |
| `gs` `gd` `gc` `gp` | git status, diff, commit, push |
| `gl` | Git log graph |
| `gco [branch]` | Checkout; with no argument, pick a branch with fzf |
| `..` `...` | Up one or two folders |
| `mkcd <dir>` | Make a folder and enter it |
| `ports` | Listening ports |
| `myip` | Public IP |
| `reload` | Restart zsh |
| `dots` | Open the dotfiles source in nvim |
| `z <part>` | zoxide: jump to a folder you've been in |
| `zi` | zoxide with an fzf picker |
| `Ctrl-T` | fzf: insert a file path |
| `Alt-C` | fzf: cd into a folder |
| `Ctrl-R` | atuin: search shell history (up arrow is untouched) |
| `f` | pay-respects: fix the last failed command |
| `yazi` | Terminal file manager |
| `tldr <cmd>` | Short examples for a command |

## Mac

| Item | Does |
|---|---|
| `dev` | SSH to the VM and attach (or create) the tmux session `main`. Host comes from `$DEV_HOST` in `~/.zshrc.local`, default `devserver`. |
| Caps Lock | Tap for Esc, hold for Ctrl (Karabiner-Elements, `~/.config/karabiner/karabiner.json`). |
| Paste from the Mac | The terminal's Cmd+V. Yanks in nvim and tmux go the other way by OSC 52. |
