local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

telescope.setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
        },
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },
        mappings = {
            i = {
                ["<Down>"] = actions.cycle_history_next,
                ["<Up>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-t>"] = trouble.smart_open_with_trouble,
            },
            n = {
                ["<Down>"] = actions.cycle_history_next,
                ["<Up>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-t>"] = trouble.smart_open_with_trouble,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case",
        },
    },
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function
require("telescope").load_extension("fzf")
