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

Then restart your terminal. See [Manual Post-Install Steps](#manual-post-install-steps) below for anything that can't be automated.

## What Gets Installed

### Packages (via Homebrew)
- **Neovim** — editor
- **Ghostty** — GPU-accelerated terminal with native splits
- **Go** + gopls, delve, gofumpt, goimports, golangci-lint
- **Java** (OpenJDK 21) + Maven, Gradle — for Quarkus work
- **C# / .NET** — for Unity scripting (OmniSharp)
- **Python 3.12**
- **Node.js** + pnpm — required by some Neovim LSPs and Next.js
- **lazygit** — git TUI (used inside Neovim)
- **ripgrep**, **fd** — fast search (used by Telescope)
- **starship** — fast shell prompt
- **zoxide** — smart `cd` replacement (`z` command)
- **eza** — modern `ls` with icons
- **bat** — `cat` with syntax highlighting
- **fzf** — fuzzy finder
- **FiraMono Nerd Font** — terminal/editor font with icons

### Neovim (LazyVim)
- **Go language support** — gopls, semantic tokens, formatting, linting
- **Java language support** — jdtls for Quarkus work
- **C# language support** — OmniSharp for Unity
- **TypeScript/JavaScript** — vtsls, ESLint, Prettier, Tailwind CSS
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
    ├── .gitconfig
    └── .gitignore_global
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

## Manual Post-Install Steps

These steps require manual action and can't be fully automated by `install.sh`.

### Java symlink (requires sudo)

The install script will prompt for your password, but if it fails or you skipped it:

```bash
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
```

Verify: `java --version` should show OpenJDK 21.

### Caps Lock → Escape (recommended for vim)

System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys → Set Caps Lock to Escape.

### Set Ghostty as default terminal (optional)

System Settings → Desktop & Dock → Default terminal application → Ghostty.

### Neovim first launch

On first `nvim` launch, Lazy.nvim will auto-install all plugins (takes 1-3 minutes). After that:

1. Run `:Mason` to verify LSP servers are installed (gopls, jdtls, omnisharp, vtsls, json-lsp, tailwindcss-language-server, eslint-lsp, prettier)
2. Run `:checkhealth` to verify everything is working

### Create GitHub repo

```bash
cd ~/.dotfiles
git init
git add -A
git commit -m "initial dotfiles: neovim + ghostty + zsh + go/java/csharp/ts"
git remote add origin git@github.com:YOUR_USERNAME/dotfiles.git
git push -u origin main
```
