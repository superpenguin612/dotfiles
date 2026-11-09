-- hardtime.nvim (D9): hints about better motions without blocking any keys; mouse allowed.
return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    restriction_mode = "hint",
    disable_mouse = false,
    -- hardtime maps Ctrl-N by default, which would shadow multicursor's Ctrl-N.
    restricted_keys = { ["<C-N>"] = false },
  },
}
