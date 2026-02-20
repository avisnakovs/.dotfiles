-- TypeScript / Next.js / Node.js development
-- LazyVim's typescript extra handles vtsls LSP, eslint, and prettier.
-- This file adds project-specific tweaks.
return {
  -- ── Tailwind CSS colorizer (shows color swatches inline) ──
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
        css = true,
      },
    },
  },

  -- ── Package.json info (show latest versions inline) ──
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    opts = {},
    keys = {
      { "<leader>cps", function() require("package-info").show() end, desc = "Show package versions", ft = "json" },
      { "<leader>cpu", function() require("package-info").update() end, desc = "Update package", ft = "json" },
      { "<leader>cpd", function() require("package-info").delete() end, desc = "Delete package", ft = "json" },
      { "<leader>cpi", function() require("package-info").install() end, desc = "Install package", ft = "json" },
      { "<leader>cpc", function() require("package-info").change_version() end, desc = "Change version", ft = "json" },
    },
  },

  -- ── Ensure Treesitter parsers for web dev ──
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "scss",
        "tsx",
        "typescript",
        "yaml",
        "prisma",
        "graphql",
      },
    },
  },
}
