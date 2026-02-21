-- Colorscheme: Catppuccin Mocha (vibrant + excellent semantic token support)
-- Other options to try: "dracula", "cyberdream", "tokyonight-storm"
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      term_colors = true,
      styles = {
        comments = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
        types = { "bold" },
      },
      integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        gitsigns = true,
        lazygit = true,
        mason = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotree = true,
        notify = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },

  -- Also install alternatives so you can switch with :colorscheme <name>
  { "Mofiqul/dracula.nvim" },
  { "scottmckendry/cyberdream.nvim" },
}
