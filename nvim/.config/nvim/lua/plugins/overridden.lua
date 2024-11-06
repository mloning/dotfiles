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
    },
  },
}
