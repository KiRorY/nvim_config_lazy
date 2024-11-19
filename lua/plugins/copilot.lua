return {
    {
        "zbirenbaum/copilot.lua",
        opts = {
            suggestion = {
                enabled = true,
                keymap = {
                    accept = "<C-y>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = false,
                help = true,
            },
        },
    },
}
