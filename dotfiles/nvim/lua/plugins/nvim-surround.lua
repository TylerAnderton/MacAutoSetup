-- return {
--   "kylechui/nvim-surround",
--   opts = {
--     keymaps = {
--       normal = false,
--       normal_cur = false,
--       normal_line = false,
--       visual = "S",
--     },
--   },
-- }
-- migration from v3 to v4 removed keymaps dict
return {
  "kylechui/nvim-surround",
  init = function()
    vim.g.nvim_surround_no_normal_mappings = true
  end,
}
