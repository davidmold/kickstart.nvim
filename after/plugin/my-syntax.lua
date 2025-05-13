-- you can add extras here that load after everything else
local diff_win = nil

function CloseDiffWindow()
  if diff_win and vim.api.nvim_win_is_valid(diff_win) then
    vim.api.nvim_win_close(diff_win, true)
    diff_win = nil
  end
end

function ShowUnsavedDiff()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.fn.systemlist('diff -u ' .. vim.fn.expand('%') .. ' -')
  if #lines == 0 then
    table.insert(lines, 'No changes')
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  diff_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>lua CloseDiffWindow()<CR>', { noremap = true, silent = true })
end

vim.keymap.set('n', '<leader>ud', ShowUnsavedDiff, { desc = 'Show unsaved diff in float' })



vim.keymap.set('n', '<leader>vc', function()
  vim.fn.system('rm -rf node_modules/.vite dist')
end, { desc = 'Clear [v]ite [c]cache' })

vim.api.nvim_set_hl(0, '@keyword', { fg = "#5599ee", italic = false, bold = true })
vim.api.nvim_set_hl(0, 'Keyword', { fg = "#ee9955", italic = false, bold = true })


