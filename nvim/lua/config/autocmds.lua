-- Autocmds
-- https://lazyvim.org/configuration/autocmds

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- ── Auto-reload files changed by Claude Code ──
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup("auto_reload", { clear = true }),
  command = "checktime",
  desc = "Reload files changed outside of Neovim (Claude Code)",
})

-- ── Go: use tabs, not spaces ──
autocmd("FileType", {
  group = augroup("go_tabs", { clear = true }),
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ── Highlight on yank ──
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ── Auto-resize splits when terminal is resized ──
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
