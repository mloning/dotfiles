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
        },
      },
    },
  },
}
