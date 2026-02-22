-- Keymaps
-- https://lazyvim.org/configuration/keymaps
-- LazyVim defaults: https://www.lazyvim.org/keymaps

local map = vim.keymap.set

-- ── Quick save / quit ──────────────────────────
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- ── Window navigation ──
-- Handled by vim-tmux-navigator plugin (see plugins/navigation.lua)
-- Ctrl+H/J/K/L works seamlessly between vim splits and tmux panes

-- ── Move lines (like Alt+Up/Down in IntelliJ) ──
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Keep cursor centered when scrolling ──
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- ── Search stays centered ──
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- ── Don't lose selection when indenting ──
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ── Quick buffer close (switches to previous buffer instead of closing window) ──
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Close buffer" })

-- ── File explorer: focus/unfocus (toggle between explorer and file) ──
map("n", "<leader>o", function()
  local cur_buf = vim.api.nvim_get_current_buf()
  -- If already in explorer, jump back to previous window
  if vim.bo[cur_buf].filetype == "snacks_picker_list" then
    vim.cmd("wincmd p")
    return
  end
  -- Otherwise, find the explorer window and focus it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "snacks_picker_list" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  -- Explorer not open, open it
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Focus/unfocus file explorer" })

-- ── Register discipline (ThePrimeagen-style) ──────────────
-- Paste over selection without losing yanked text
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- Delete to void register (don't overwrite yank)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- ── Quickfix navigation ──────────────────────────────────
map("n", "<C-n>", "<cmd>cnext<cr>zz", { desc = "Next quickfix item" })
map("n", "<C-p>", "<cmd>cprev<cr>zz", { desc = "Prev quickfix item" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
