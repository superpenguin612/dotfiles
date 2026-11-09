-- Previews (D8). The VM is headless, so:
-- - markdown-preview serves on 127.0.0.1:8090 and echoes the URL; the Mac reaches it through
--   an SSH LocalForward. render-markdown (in the lang.markdown extra) renders in the buffer.
-- - vimtex compiles with latexmk and shows the PDF with pdfpane in a tmux pane beside nvim.
return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "8090"
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browser = "true" -- no browser on the VM; open the echoed URL on the Mac
    end,
  },
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = "pdfpane"
    end,
  },
}
