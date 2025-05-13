return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
    -- or use "nvim-tree/nvim-web-devicons"
  },
  lazy = false,
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.keymap.set("n", "q", ":bd<CR>", { buffer = true, silent = true })
      end,
    })
  end
}