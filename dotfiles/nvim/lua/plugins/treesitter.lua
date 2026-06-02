-- Treesitter config for AstroNvim v6
-- nvim-treesitter only handles parser installation; all other config lives in astrocore

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = {
      },
    },
  },
}
