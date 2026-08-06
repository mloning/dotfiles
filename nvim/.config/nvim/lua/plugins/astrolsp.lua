-- clangd reports code excluded by the preprocessor as `comment` semantic tokens
-- unless the client opts into its `inactiveRegions` extension. Neovim draws
-- semantic tokens above Treesitter, so the body of an `#ifdef` whose macro the
-- compilation database doesn't define renders as one grey comment block. Opting
-- in makes clangd report those regions separately, leaving syntax highlighting
-- intact, and we tint them below Treesitter's priority so the colours survive.
local inactive_ns = vim.api.nvim_create_namespace "clangd_inactive_regions"

-- a link rather than a copied colour, so it resolves at draw time and doesn't
-- depend on this file running after the colorscheme
local function set_inactive_hl()
  vim.api.nvim_set_hl(0, "ClangdInactiveRegion", { link = "CursorLine", default = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Keep ClangdInactiveRegion in sync with the colorscheme",
  callback = set_inactive_hl,
})
set_inactive_hl()

---@param result { textDocument: lsp.TextDocumentIdentifier, regions: lsp.Range[] }?
local function inactive_regions(_, result)
  if not result or not result.regions then return end
  local bufnr = vim.uri_to_bufnr(result.textDocument.uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then return end
  vim.api.nvim_buf_clear_namespace(bufnr, inactive_ns, 0, -1)
  for _, range in ipairs(result.regions) do
    vim.hl.range(
      bufnr,
      inactive_ns,
      "ClangdInactiveRegion",
      { range.start.line, range.start.character },
      { range["end"].line, range["end"].character },
      -- Treesitter highlights at priority 100; stay under it so this only
      -- contributes a background and never overrides syntax colours
      { priority = 90 }
    )
  end
end

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
    config = {
      clangd = {
        capabilities = {
          textDocument = { inactiveRegionsCapabilities = { inactiveRegions = true } },
        },
        handlers = { ["textDocument/inactiveRegions"] = inactive_regions },
      },
    },
  },
}
