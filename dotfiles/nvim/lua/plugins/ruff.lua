return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config('ruff', {
      cmd = { 'ruff', 'server' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
      init_options = {
        settings = {
          logLevel = "info",
          showSyntaxErrors = true,
          fixAll = true,
          organizeImports = true,
          lint = {
            enable = true,
          },
          format = {
            backend = "internal",
          },
          codeAction = {
            disableRuleComment = { enable = true },
            fixViolation = { enable = true },
          },
        }
      }
    })

    vim.lsp.enable('ruff')

    -- Disable Ruff hover when using alongside Pyright
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
          return
        end
        if client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
        end
      end,
      desc = 'LSP: Disable hover capability from Ruff',
    })
  end
}
