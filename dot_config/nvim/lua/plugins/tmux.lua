-- vim-tmux-navigator (D14): Ctrl-h/j/k/l moves across Neovim splits and tmux panes alike.
-- The tmux half is in tmux.conf.local.
return {
  "christoomey/vim-tmux-navigator",
  cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left split/pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower split/pane" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper split/pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right split/pane" },
  },
}
