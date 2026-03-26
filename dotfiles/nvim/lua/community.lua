-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
if vim.g.vscode then
  return {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.recipes.vscode" },
  }
else
  return {}
end
