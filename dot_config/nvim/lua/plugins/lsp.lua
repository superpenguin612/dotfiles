-- Languages LazyVim has no extra for (D4): HTML/CSS (html, cssls, emmet) and YAML linting
-- (yamllint). Bash needs nothing here: util.dot brings bashls (which runs shellcheck) and
-- LazyVim core formats sh with shfmt. Everything else comes from the extras in lazyvim.json.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        emmet_language_server = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "yamllint" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { yaml = { "yamllint" } } },
  },
}
