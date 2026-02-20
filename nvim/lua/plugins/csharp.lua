-- C# / Unity development
-- LazyVim's dotnet extra handles omnisharp LSP setup.
-- This file adds Unity-specific tweaks and the semantic token fix.
return {
  -- ── Fix OmniSharp semantic tokens (known LSP non-conformance) ──
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        omnisharp = function(_, opts)
          -- OmniSharp sends non-standard semantic token names with spaces
          -- This patches them to use underscores so Neovim doesn't error
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "omnisharp" then
              local caps = client.server_capabilities
              if caps and caps.semanticTokensProvider then
                local tokenTypes = caps.semanticTokensProvider.legend.tokenTypes
                for i, v in ipairs(tokenTypes) do
                  tokenTypes[i] = v:gsub(" ", "_")
                end
                local tokenModifiers = caps.semanticTokensProvider.legend.tokenModifiers
                for i, v in ipairs(tokenModifiers) do
                  tokenModifiers[i] = v:gsub(" ", "_")
                end
              end
            end
          end)
        end,
      },
    },
  },

  -- ── Unity: associate .meta and .asmdef files ──
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Treat Unity-specific files properly
      vim.filetype.add({
        extension = {
          asmdef = "json",
          asmref = "json",
          meta = "yaml",
        },
        pattern = {
          -- Unity shader files
          [".*%.shader"] = "hlsl",
          [".*%.cginc"] = "hlsl",
          [".*%.hlsl"] = "hlsl",
        },
      })
    end,
  },

  -- ── Extended goto definition (decompile BCL classes) ──
  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    lazy = true,
    keys = {
      {
        "gd",
        function()
          require("omnisharp_extended").lsp_definition()
        end,
        desc = "Goto Definition (C# extended)",
        ft = "cs",
      },
      {
        "gr",
        function()
          require("omnisharp_extended").lsp_references()
        end,
        desc = "Find References (C# extended)",
        ft = "cs",
      },
      {
        "gI",
        function()
          require("omnisharp_extended").lsp_implementation()
        end,
        desc = "Goto Implementation (C# extended)",
        ft = "cs",
      },
    },
  },
}
