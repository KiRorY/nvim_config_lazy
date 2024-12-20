return {
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- optional
            "nvim-treesitter/nvim-treesitter",
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = "Leet",
        opts = {
            ---@type string
            arg = "leetcode.nvim",

            ---@type lc.storage
            storage = {
                home = "~/Documents/code/kirory_leetcode/",
                cache = vim.fn.stdpath("cache") .. "/leetcode",
            },
            plugins = {
                non_standalone = true,
            },
        },
    },
}
