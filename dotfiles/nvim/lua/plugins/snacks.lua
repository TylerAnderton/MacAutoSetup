return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- any snacks config overrides can go here
  end,
  init = function()
    vim.api.nvim_create_user_command("Notifications", function()
      Snacks.notifier.show_history()
    end, {})
  end,
}
