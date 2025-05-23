return {
  {
    -- Local plugin: no Git URL needed
    dir = vim.fn.stdpath("config") .. "/lua/plugins/luawindow",
    name = "luawindow",
    config = function()
      require("plugins.luawindow").setup()
    end,
    lazy = false
  }
}