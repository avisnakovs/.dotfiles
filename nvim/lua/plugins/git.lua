-- Git: Diffview (code review, stash viewer) + gitsigns enhancements
return {
  -- ── Diffview: side-by-side diffs & stash viewer ──
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: working changes" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
      -- Stash viewer
      {
        "<leader>gs",
        function()
          vim.ui.input({ prompt = "Stash ref (default stash@{0}): " }, function(ref)
            if ref == nil then return end
            if ref == "" then ref = "stash@{0}" end
            vim.cmd("DiffviewOpen " .. ref)
          end)
        end,
        desc = "Diffview: view stash",
      },
      -- Compare current branch vs main
      { "<leader>gm", "<cmd>DiffviewOpen main<cr>", desc = "Diffview: diff vs main" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 35 },
      },
    },
  },

  -- ── gitsigns: inline blame & hunk navigation ──
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = false, -- Toggle with <leader>gb
      current_line_blame_opts = {
        delay = 300,
      },
    },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle line blame" },
    },
  },
}
