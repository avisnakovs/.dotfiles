-- Editor enhancements
return {
  -- ── Surround: quickly add/change/delete brackets, quotes, tags ──
  -- cs"' → change surrounding " to '
  -- ds"  → delete surrounding "
  -- ysiw" → surround word with "
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- ── Autopairs: auto-close brackets and quotes ──
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- ── Todo comments: highlight TODO, FIXME, HACK, etc ──
  {
    "folke/todo-comments.nvim",
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
    },
  },

  -- ── Trouble: better diagnostics list ──
  -- Already in LazyVim, but adding keybinding reminder
  -- <leader>xx → toggle diagnostics
  -- <leader>xX → buffer diagnostics
}
