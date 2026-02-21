-- Options
-- https://lazyvim.org/configuration/general

local opt = vim.opt

opt.relativenumber = true    -- Relative line numbers (faster vim motions)
opt.number = true            -- Show current line number
opt.scrolloff = 8            -- Keep 8 lines visible above/below cursor
opt.tabstop = 4              -- Tab width (Go standard)
opt.shiftwidth = 4           -- Indent width
opt.softtabstop = 4
opt.expandtab = false        -- Use tabs in Go files (gofumpt handles this)
opt.cursorline = true        -- Highlight current line
opt.termguicolors = true     -- True color support
opt.signcolumn = "yes"       -- Always show sign column (git, breakpoints)
opt.updatetime = 100         -- Faster CursorHold (helps with auto-reload)
opt.swapfile = false         -- No swap files
opt.undofile = true          -- Persistent undo history
opt.clipboard = "unnamedplus" -- System clipboard integration

-- Auto-reload files changed externally (by Claude Code)
opt.autoread = true

-- Neovim providers
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim/python-venv/bin/python3")
vim.g.ruby_host_prog = "/opt/homebrew/opt/ruby/bin/ruby"
