-- Keymaps
-- https://lazyvim.org/configuration/keymaps
-- LazyVim defaults: https://www.lazyvim.org/keymaps

local map = vim.keymap.set

-- ── Quick save / quit ──────────────────────────
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- ── Window navigation (also works in terminal mode) ──
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

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

-- ── Quick buffer close (like Ctrl+W in IntelliJ tabs) ──
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
