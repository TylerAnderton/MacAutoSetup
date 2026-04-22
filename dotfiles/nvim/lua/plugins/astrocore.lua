-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
      autoformat = false,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap

        -- sets system clipboard as default
        -- this is the default behavior for AstroNvim,
        -- but it's good to define explicitly for clarity
        clipboard = "unnamedplus",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        -- Claude Code key mappings
        -- Set here explicitly, as Astronvim isn't getting them from claudecode.lua
        ["<leader>a"]  = { desc = "AI/Claude Code" },
        ["<leader>ac"] = { "<cmd>ClaudeCode<cr>",           desc = "Toggle Claude" },
        ["<C-'>"] = { "<cmd>ClaudeCode<cr>", desc = "Toggle Claude (bypass <leader> in prompt)" },
        ["<leader>af"] = { "<cmd>ClaudeCodeFocus<cr>",      desc = "Focus Claude" },
        ["<leader>ar"] = { "<cmd>ClaudeCode --resume<cr>",  desc = "Resume Claude" },
        ["<leader>aC"] = { "<cmd>ClaudeCode --continue<cr>",desc = "Continue Claude" },
        ["<leader>am"] = { "<cmd>ClaudeCodeSelectModel<cr>",desc = "Select model" },
        ["<leader>ab"] = { "<cmd>ClaudeCodeAdd %<cr>",      desc = "Add buffer" },
        ["<leader>aa"] = { "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        ["<leader>ad"] = { "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
      },
      v = {
        -- Claude Code key mappings
        -- Set here explicitly, as Astronvim isn't getting them from claudecode.lua
        ["<leader>as"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude" },
      },
      t = {
        ["<C-'>"] = { "<C-\\><C-n><cmd>ClaudeCode<cr>", desc = "Toggle Claude (bypass <leader> in prompt)" },
      },
    },
    autocmds = {
      -- Claude Code key mappings
      -- Set here explicitly, as Astronvim isn't getting them from claudecode.lua
      -- Need to set an autocmd since Astrocore doesn't track mappings
      -- in the file explorer
      claudecode_tree_maps = {
        {
          event = "FileType",
          pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
          callback = function(args)
            vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
              { desc = "Add file", buffer = args.buf, silent = true })
          end,
        },
      },
    },
  },
}
