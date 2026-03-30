-- TODO: reduce latency
return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    config = function()
      require("minuet").setup {
        notify = "warn",
        -- context
        context_window = 16000,
        context_ratio = 0.5,
        -- throttling
        throttle = 250, -- timer after last request (ms)
        debounce = 50, -- timer after last keystroke (ms)
        request_timeout = 3,
        n_completions = 1,
        -- provider
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            end_point = "https://llm-proxy.int.tractian.com/v1/chat/completions",
            api_key = "TRACTIAN_LLM_API_KEY",
            -- model = "glm-5", -- TODO: turn off glm-5 reasoning
            model = "qwen25-coder-7b",
            name = "tractian",
            stream = true,
            optional = {
              max_tokens = 64,
              -- thinking = { type = "disabled" },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "python", "lua", "rust" },
          show_on_completion_menu = true,
          keymap = {
            accept = "<Tab>",
            accept_line = "<S-Tab>",
            dismiss = "<C-e>",
          },
        },
      }
    end,
  },
}
