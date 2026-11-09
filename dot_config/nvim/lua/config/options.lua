-- Options on top of LazyVim's defaults (lazyvim/config/options.lua).

-- OSC 52 clipboard (D24): yanks reach the Mac clipboard through the terminal and tmux.
-- Paste reads the unnamed register; pasting from the Mac is the terminal's Cmd+V, since
-- OSC 52 reads are off in iTerm2. LazyVim leaves clipboard empty over SSH; this turns it on.
local osc52 = require("vim.ui.clipboard.osc52")
local function paste()
  return { vim.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = { ["+"] = paste, ["*"] = paste },
}
vim.opt.clipboard = "unnamedplus"
