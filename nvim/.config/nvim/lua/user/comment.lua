local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end
comment.setup()

-- fix terraform and hcl comment string
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
    callback = function(ev)
        vim.bo[ev.buf].commentstring = "# %s"
    end,
    pattern = { "terraform", "hcl" },
})
