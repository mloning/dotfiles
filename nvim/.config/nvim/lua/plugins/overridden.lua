return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = { -- extend the plugin options
      diagnostics = {
        -- disable diagnostics virtual text
        virtual_text = false,
      },
      mappings = {
        n = {
          ["<S-l>"] = { cmd = ":bnext<CR>", desc = "Next buffer" },
          ["<S-h>"] = { cmd = ":bprevious<CR>", desc = "Previous buffer" },
          ["n"] = { cmd = "nzz", desc = "Next search result with centering" },
          ["N"] = { cmd = "Nzz", desc = "Previous search result with centering" },
          -- Use Trouble for LSP results directly, bypassing quickfix race condition
          ["gr"] = { function() require("trouble").open("lsp_references") end, desc = "LSP references (Trouble)" },
          ["gd"] = { function() require("trouble").open("lsp_definitions") end, desc = "LSP definitions (Trouble)" },
          ["gI"] = { function() require("trouble").open("lsp_implementations") end, desc = "LSP implementations (Trouble)" },
        },
      },
      autocmds = {
        -- Redirect quickfix/location list to Trouble
        trouble_qf = {
          {
            event = "FileType",
            pattern = "qf",
            desc = "Redirect quickfix and location lists to Trouble",
            callback = function()
              local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
              local win = vim.api.nvim_get_current_win()
              vim.schedule(function()
                if is_loclist then
                  require("trouble").open("loclist")
                else
                  require("trouble").open("qflist")
                end
                if vim.api.nvim_win_is_valid(win) then
                  pcall(vim.api.nvim_win_close, win, false)
                end
              end)
            end,
          },
        },
      },
    },
  },
}
