return {
  {
    -- Local plugin: no Git URL needed
    dir = vim.fn.stdpath("config") .. "/lua/plugins",
    name = "lua_repl",
    config = function()
      vim.api.nvim_create_user_command("LuaScratch", function()
        require("lua_repl").open_lua_eval_buffer()
      end, { desc = "Open Lua REPL window" })
    end,
    lazy = false
  }
}