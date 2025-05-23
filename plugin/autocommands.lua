-- sets the type of .env files (like .env.production etc) to sh
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '.env*',
  callback = function()
    vim.bo.filetype = 'sh'
  end,
})

-- Toggling the terminal

local term_win = nil

function OpenFloatingTerminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  term_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.fn.termopen(cmd or vim.o.shell)
end

function OpenTempFloatingTerminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  term_win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.fn.termopen(cmd or vim.o.shell)
  -- Keymap to close window with <Esc>, scoped to buffer
  vim.keymap.set('n', '<Esc>', function()
    if vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_close(term_win, true)
    end
  end, { buffer = buf, noremap = true, silent = true })
end

vim.keymap.set('n', '<leader>TB', function()
  OpenTempFloatingTerminal 'npm run build'
end, { desc = 'Open [T]erminal and [B]uild' })

vim.keymap.set('n', '<leader>TF', function()
  OpenFloatingTerminal()
end, { desc = 'Open [T]erminal Floating' })

vim.keymap.set('n', '<leader>TP', function()
  vim.ui.input({ prompt = 'Run in terminal: ' }, function(input)
    OpenTempFloatingTerminal(input)
  end)
end, { desc = 'Open [T]erminal with [P]rompt' })

vim.keymap.set('n', '<leader>TC', function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  end
end, { desc = 'Floating [T]erminal [C]lose' })

-- Undo
vim.keymap.set('n', '<C-z>', 'u', { desc = 'Undo' })
vim.keymap.set('i', '<C-z>', '<Esc>u', { desc = 'Undo' })
-- Select All
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- Wrap table contents with <tbody></tbody> --------------------------------------------------------
vim.keymap.set('n', '<leader>lc', function()
  ---@diagnostic disable-next-line
  local ok = pcall(vim.cmd, [[ %s/<table class="\zs[^"]\+">/&\r<tbody>/g ]])
  ---@diagnostic disable-next-line
  local ok2 = pcall(vim.cmd, [[ %s/<\/table>/<\/tbody>\r<\/table>/g ]])
  vim.lsp.buf.format()
  if not ok and not ok2 then
    vim.notify 'Found nothing to wrap'
  end
end, { desc = 'Table has class: Wrap orphan <tr> in <tbody>' })

-- Wrap table contents with <tbody></tbody> --------------------------------------------------------
vim.keymap.set('n', '<leader>lt', function()
  local ok = pcall(vim.cmd, [[ %s/<table>/&\r<tbody>/g ]])
  local ok2 = pcall(vim.cmd, [[ %s/<\/table>/<\/tbody>\r<\/table>/g ]])
  vim.lsp.buf.format()
  if not ok and not ok2 then
    vim.notify 'Found nothing to wrap'
  end
end, { desc = 'Table with no class Wrap orphan <tr> in <tbody>' })

-- refactoring vue2 => vue3
vim.keymap.set('n', '<leader>lv', [[:%s/\<this\.value\>/this.modelValue/g<CR>]], { desc = 'Replace this.value → this.modelValue' })
vim.keymap.set('n', '<leader>ll', [[:s/\<let\>/const/<CR>]], { desc = 'Replace first let with const on line' })

-- shortcuts to ciw
-- in normal mode, press Ctr l to change inner word
vim.keymap.set('n', '<C-l>', 'ciw', { noremap = true, silent = true, desc = 'ciw on Ctrl+l' })

-- in insert mode, Cmd+l will exit to normal and ciw
vim.keymap.set('i', '<C-l>', '<Esc>ciw', { noremap = true, silent = true, desc = 'ciw from insert' })

-- leader paste word
vim.keymap.set('n', '<leader>pw', 'vaw"_dP', { desc = '[p]aste replacing current [w]ord' })
-- leader paste selection
vim.keymap.set('v', '<leader>ps', '"_dP', { desc = '[p]aste replacing [s]election' })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  pattern = '*.vue',
  callback = function()
    if vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        '<template>',
        '<div></div>',
        '</template>',
        '<script setup>',
        '',
        '</script>',
        '<style scoped>',
        '',
        '</style>',
      })
    end
  end,
})

-- Reload my autocommands
vim.api.nvim_create_user_command('ReloadAutoCmds', function()
  dofile(vim.fn.stdpath 'config' .. '/plugin/autocommands.lua')
end, {})
