local M = {}

function M.open_lua_eval_buffer()
  -- Create a floating window
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.5)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.bo[buf].filetype = 'lua'
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false

  vim.keymap.set('n', '<leader>rl', function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local chunk, err = load(table.concat(lines, '\n'), 'eval', 't', _G)
    if chunk then
      local ok, result = pcall(chunk)
      print(ok and vim.inspect(result) or 'error: ' .. result)
    else
      print('compile error: ' .. err)
    end
  end, { buffer = buf, desc = 'Run all Lua lines' })

  vim.keymap.set('n', '<leader>q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, desc = 'Close luawindow' })
end

function M.setup()
  vim.api.nvim_create_user_command('LuaScratch', function()
    M.open_lua_eval_buffer()
  end, { desc = 'Open luawindow' })
end

return M

