-- Languages LazyVim has no extra for (D4): Bash (bashls, shellcheck, shfmt), HTML/CSS (html,
-- cssls, emmet) and YAML linting (yamllint). Everything else comes from the extras in lazyvim.json.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
        html = {},
        cssls = {},
        emmet_language_server = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "shellcheck", "shfmt", "yamllint" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { sh = { "shellcheck" }, yaml = { "yamllint" } } },
  },
}
