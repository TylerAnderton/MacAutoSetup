return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      width = 40,
      -- Set system clipboard as default when copying file/directory names from explorer
      mappings = {
        ["y"] = function(state)
          local node = state.tree:get_node()
          vim.fn.setreg("+", node.name)
          vim.notify("Copied: " .. node.name)
        end,
        ["Y"] = function(state)
          local node = state.tree:get_node()
          vim.fn.setreg("+", node.path)
          vim.notify("Copied: " .. node.path)
        end,
      },
    },
  },
}
