local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local function on_attach_custom(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "l", api.node.open.edit, opts("open"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("open"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("open"))
    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("close directory"))
    vim.keymap.set("n", "v", api.node.open.vertical, opts("open: vertical split"))
end

nvim_tree.setup({
    on_attach = on_attach_custom,
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    renderer = {
        root_folder_modifier = ":t",
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "",
                    staged = "S",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "U",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    view = {
        width = 30,
        side = "left",
    },
})
