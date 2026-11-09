-- multicursor.nvim (D3): the third layer after LSP rename (<leader>cr) and * + cgn + .
-- Ctrl-N adds a cursor at the next match (VS Code's Cmd+D); Esc clears the cursors.
local function mc(fn, ...)
  local args = { ... }
  return function()
    require("multicursor-nvim")[fn](unpack(args))
  end
end

return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  keys = {
    { "<C-n>", mc("matchAddCursor", 1), mode = { "n", "x" }, desc = "Add cursor at next match" },
    { "<leader>m", "", desc = "+multicursor", mode = { "n", "x" } },
    { "<leader>ms", mc("matchSkipCursor", 1), mode = { "n", "x" }, desc = "Skip match, add next" },
    { "<leader>mA", mc("matchAllAddCursors"), mode = { "n", "x" }, desc = "Add cursors at all matches" },
    { "<leader>mj", mc("lineAddCursor", 1), mode = { "n", "x" }, desc = "Add cursor below" },
    { "<leader>mk", mc("lineAddCursor", -1), mode = { "n", "x" }, desc = "Add cursor above" },
  },
  config = function()
    local m = require("multicursor-nvim")
    m.setup()
    -- Only active while there are several cursors, so Esc keeps its normal meaning otherwise.
    m.addKeymapLayer(function(set)
      set("n", "<esc>", m.clearCursors)
    end)
  end,
}
