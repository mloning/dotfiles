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
              vim.schedule(function()
                vim.cmd("close")
                if is_loclist then
                  require("trouble").open("loclist")
                else
                  require("trouble").open("qflist")
                end
              end)
            end,
          },
        },
      },
    },
  },
}
