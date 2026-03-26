return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "pittcat/claude-fzf.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "coder/claudecode.nvim"
    },
    opts = {
      auto_context = true,
      batch_size = 10,
      -- 可选：配置键位映射（默认为空，不会占用任何按键）
      keymaps = {
        files = "<leader>cf",
        grep = "<leader>cg",
        buffers = "<leader>cb",
        git_files = "<leader>cgf",
        directory_files = "<leader>cd",
      },
    },
    cmd = { "ClaudeFzf", "ClaudeFzfFiles", "ClaudeFzfGrep", "ClaudeFzfBuffers", "ClaudeFzfGitFiles", "ClaudeFzfDirectory" },
    -- 或者使用 lazy.nvim 的 keys 配置（二选一）
    keys = {
      { "<leader>cf", "<cmd>ClaudeFzfFiles<cr>", desc = "Claude: Add files" },
      { "<leader>cg", "<cmd>ClaudeFzfGrep<cr>", desc = "Claude: Search and add" },
      { "<leader>cb", "<cmd>ClaudeFzfBuffers<cr>", desc = "Claude: Add buffers" },
      { "<leader>cgf", "<cmd>ClaudeFzfGitFiles<cr>", desc = "Claude: Add Git files" },
      { "<leader>cd", "<cmd>ClaudeFzfDirectory<cr>", desc = "Claude: Add directory files" },
    },
    build = false,
  },
  {
    'pittcat/claude-fzf-history.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    config = function()
      require('claude-fzf-history').setup()
    end,
    cmd = { 'ClaudeHistory', 'ClaudeHistoryDebug' },
    keys = {
      { "<leader>ch", "<cmd>ClaudeHistory<cr>", desc = "Claude: Open chat history" },
    },
  },
}
