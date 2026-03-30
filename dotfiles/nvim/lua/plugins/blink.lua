return {
  "Saghen/blink.cmp",
  opts_extend = { "sources.default" },
  opts = {
    keymap = {
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    sources = {
      default = { "minuet" },
      providers = {
        minuet = {
          name = "minuet",
          module = "minuet.blink",
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    },
    completion = {
      trigger = { prefetch_on_insert = false },
    },
  },
}
