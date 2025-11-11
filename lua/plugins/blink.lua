return {
    {
        "Saghen/blink.cmp",
        dependencies = {
            "Kaiser-Yang/blink-cmp-avante",
        },
        opts = {
            sources = {
                -- Add 'avante' to the list
                default = { "avante", "lsp", "path", "buffer" },
                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {
                            -- options for blink-cmp-avante
                        },
                    },
                },
            },
            keymap = {
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            },
            completion = {
                list = {
                    selection = {
                        auto_insert = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = {
                        border = "rounded",
                    },
                },
                menu = {
                    border = "rounded",
                    draw = { gap = 2 },
                },
            },
        },
    },
}
