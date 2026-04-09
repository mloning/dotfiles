---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    handlers = {
      -- disable pyrefly and ty, use basedpyright instead
      pyrefly = false,
      ty = false,
    },
  },
}
