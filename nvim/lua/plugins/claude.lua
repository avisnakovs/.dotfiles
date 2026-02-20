-- Claude Code integration
-- Provides WebSocket bridge so Claude Code CLI can see your editor context
return {
  {
    "coder/claudecode.nvim",
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>ao", "<cmd>ClaudeCodeOpen<cr>", desc = "Open Claude Code" },
    },
    opts = {
      terminal = {
        split_side = "left",
        split_width_percentage = 0.4,
      },
    },
  },
}
