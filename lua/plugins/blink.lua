return {
    {
        "Saghen/blink.cmp",
        opts = {
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
