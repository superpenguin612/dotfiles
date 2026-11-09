-- claudecode.nvim (D6), on top of the ai.claudecode extra, which already maps <leader>ac
-- (toggle), <leader>as (send selection), <leader>aa (accept diff) and <leader>ad (deny diff).
-- Here: Claude's edits open as a vertical-split diff.
return {
  "coder/claudecode.nvim",
  opts = { diff_opts = { layout = "vertical" } },
}
