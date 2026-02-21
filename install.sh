#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ─────────────────────────────────────────────
# 1. Homebrew
# ─────────────────────────────────────────────
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
}

# ─────────────────────────────────────────────
# 2. Brew packages
# ─────────────────────────────────────────────
install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  success "Packages installed"
}

# ─────────────────────────────────────────────
# 3. Go tools
# ─────────────────────────────────────────────
install_go_tools() {
  if command -v go &>/dev/null; then
    info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install mvdan.cc/gofumpt@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    success "Go tools installed"
  else
    warn "Go not found, skipping Go tools (will be available after shell restart)"
  fi
}

# ─────────────────────────────────────────────
# 3b. Java setup
# ─────────────────────────────────────────────
setup_java() {
  # Symlink OpenJDK so system java wrappers find it
  # Requires sudo — will prompt for password
  local jdk_path="/opt/homebrew/opt/openjdk@21"
  if [[ -d "$jdk_path" ]]; then
    if [[ -L /Library/Java/JavaVirtualMachines/openjdk-21.jdk ]]; then
      success "Java 21 already linked"
    else
      info "Linking OpenJDK 21 (requires sudo)..."
      if sudo ln -sfn "$jdk_path/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-21.jdk; then
        success "Java 21 linked"
      else
        warn "Could not link Java 21. Run manually after install:"
        warn "  sudo ln -sfn $jdk_path/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk"
      fi
    fi
  fi
}

# ─────────────────────────────────────────────
# 4. Symlinks
# ─────────────────────────────────────────────
link_file() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      success "Already linked: $dst"
      return
    fi
    warn "Backing up existing: $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  success "Linked: $dst → $src"
}

create_symlinks() {
  info "Creating symlinks..."

  # Neovim
  link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

  # Ghostty
  link_file "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"

  # Zsh
  link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

  # Git
  link_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  link_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

  # Starship prompt
  link_file "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

  success "Symlinks created"
}

# ─────────────────────────────────────────────
# 5. Zinit (zsh plugin manager)
# ─────────────────────────────────────────────
install_zinit() {
  # Remove dangling ~/.local symlink if it exists (left over from old dotfiles)
  if [[ -L "$HOME/.local" && ! -e "$HOME/.local" ]]; then
    warn "Removing dangling symlink: ~/.local → $(readlink "$HOME/.local")"
    rm "$HOME/.local"
  fi

  # Ensure ~/.local/share exists for zinit
  mkdir -p "$HOME/.local/share"

  if [[ ! -d "$HOME/.local/share/zinit" ]]; then
    info "Installing zinit..."
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" -- --no-edit-zshrc
    success "Zinit installed"
  else
    success "Zinit already installed"
  fi
}

# ─────────────────────────────────────────────
# 5b. Neovim providers (Python, Ruby, Node)
# ─────────────────────────────────────────────
install_neovim_providers() {
  info "Installing Neovim providers..."

  # Python provider (uses dedicated venv to avoid PEP 668 conflicts)
  local python_venv="$HOME/.local/share/nvim/python-venv"
  if [[ ! -d "$python_venv" ]]; then
    /opt/homebrew/bin/python3.12 -m venv "$python_venv"
  fi
  "$python_venv/bin/pip" install -q pynvim
  success "Python provider installed"

  # Node provider
  if command -v npm &>/dev/null; then
    npm install -g neovim --silent 2>/dev/null
    success "Node provider installed"
  fi

  # Ruby provider (requires Homebrew Ruby, not system Ruby)
  if [[ -x /opt/homebrew/opt/ruby/bin/gem ]]; then
    /opt/homebrew/opt/ruby/bin/gem install neovim --silent 2>/dev/null
    success "Ruby provider installed"
  fi
}

# ─────────────────────────────────────────────
# 6. Neovim setup
# ─────────────────────────────────────────────
setup_neovim() {
  info "Setting up Neovim (plugins will install on first launch)..."

  # Install the LazyVim extras config
  if command -v nvim &>/dev/null; then
    # Headless plugin install
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    success "Neovim plugins synced"
  else
    warn "Neovim not found yet, plugins will install on first launch"
  fi
}

# ─────────────────────────────────────────────
# 7. macOS defaults
# ─────────────────────────────────────────────
set_macos_defaults() {
  info "Setting macOS defaults..."

  # Fast key repeat (essential for vim)
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15

  # Disable press-and-hold for accent characters (enables key repeat everywhere)
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Dock: autohide
  defaults write com.apple.dock autohide -bool true

  # Dock: hide recent applications
  defaults write com.apple.dock show-recents -bool false

  # Apply dock changes
  killall Dock 2>/dev/null || true

  success "macOS defaults set (restart apps for key repeat changes)"
}

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────
main() {
  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║     Dotfiles Setup - macOS           ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
  echo ""

  install_homebrew
  install_packages
  install_zinit
  create_symlinks
  install_go_tools
  setup_java
  install_neovim_providers
  setup_neovim
  set_macos_defaults

  echo ""
  echo -e "${GREEN}══════════════════════════════════════${NC}"
  echo -e "${GREEN}  Setup complete!${NC}"
  echo -e "${GREEN}══════════════════════════════════════${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Restart your terminal (or run: source ~/.zshrc)"
  echo "  2. Open Ghostty and run: nvim"
  echo "  3. Inside nvim, run: :LazyExtras and enable lang.go and dap.core"
  echo "  4. Install Go tools if skipped: run install.sh again after shell restart"
  echo ""
  echo "Layout tip: In Ghostty use Cmd+D to split right, Cmd+Shift+D to split down"
  echo "  Left pane: claude      Right pane: nvim      Bottom: terminal"
  echo ""
}

main "$@"
