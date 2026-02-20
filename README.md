# Dotfiles

One command to set up a complete macOS development environment:
Neovim (LazyVim) + Go + Claude Code + Ghostty terminal.

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

Then restart your terminal.

## What Gets Installed

### Packages (via Homebrew)
- **Neovim** — editor
- **Ghostty** — GPU-accelerated terminal with native splits
- **Go** + gopls, delve, gofumpt, goimports, golangci-lint
- **Node.js** — required by some Neovim LSPs
- **lazygit** — git TUI (used inside Neovim)
- **ripgrep**, **fd** — fast search (used by Telescope)
- **starship** — fast shell prompt
- **zoxide** — smart `cd` replacement (`z` command)
- **eza** — modern `ls` with icons
- **bat** — `cat` with syntax highlighting
- **fzf** — fuzzy finder
- **JetBrains Mono Nerd Font** — terminal/editor font

### Neovim (LazyVim)
- **Go language support** — gopls, semantic tokens, formatting, linting
- **Java language support** — for Quarkus work
- **Debugging** — DAP + delve (breakpoints, variable inspection)
- **diffview.nvim** — side-by-side diff review + stash viewer
- **Claude Code integration** — WebSocket bridge
- **catppuccin** theme — vibrant colors with LSP semantic token support
- Alternative themes: cyberdream, dracula

### Shell (zsh + zinit)
- **zinit** — fast plugin manager (replaces oh-my-zsh)
- Loads only the oh-my-zsh plugins you need: git, history, completions
- **zsh-autosuggestions** — fish-like suggestions
- **zsh-syntax-highlighting** — command highlighting
- **starship** prompt — shows git branch, Go version, etc.

## Key Workflows

### Reviewing Claude Code changes
```
<leader>gd    → Open Diffview (all uncommitted changes)
Tab/S-Tab     → Cycle through changed files
<leader>gD    → Close Diffview
```

### Git stash (view example code)
```
<leader>gs    → View a stash in Diffview (without applying)
<leader>gg    → Open LazyGit (stash tab for full management)
```

### Debugging Go
```
<leader>db    → Toggle breakpoint
<leader>dc    → Start/continue debugging
F10           → Step over
F11           → Step into
<leader>du    → Toggle debug UI
```

### Navigation
```
gd            → Go to definition
gI            → Go to implementation
gr            → Find references
<leader>ff    → Find files
<leader>sg    → Search in files (grep)
<leader>e     → Toggle file tree
```

## Structure

```
dotfiles/
├── install.sh              # One-command setup script
├── Brewfile                # Homebrew packages
├── nvim/                   # Neovim config (LazyVim)
│   ├── init.lua
│   └── lua/
│       ├── config/
│       │   ├── options.lua
│       │   ├── keymaps.lua
│       │   └── autocmds.lua
│       └── plugins/
│           ├── colorscheme.lua
│           ├── git.lua
│           ├── claude.lua
│           └── editor.lua
├── ghostty/
│   └── config
├── zsh/
│   └── .zshrc
├── starship/
│   └── starship.toml
└── git/
    └── .gitconfig
```

## Customizing

- **Change theme:** Edit `nvim/lua/plugins/colorscheme.lua`
- **Add plugins:** Create new files in `nvim/lua/plugins/`
- **Add brew packages:** Edit `Brewfile`, then run `brew bundle`
- **Shell aliases:** Edit `zsh/.zshrc`

## Terminal Layout (Ghostty)

```
┌─────────────────┬──────────────────┐
│                 │                  │
│   Claude Code   │     Neovim       │
│                 │                  │
│   Cmd+D split   │                  │
│                 ├──────────────────┤
│                 │   Terminal       │
│                 │   Cmd+Shift+D    │
└─────────────────┴──────────────────┘

Navigate: Ctrl+H/J/K/L (vim-style)
```
# .dotfiles
