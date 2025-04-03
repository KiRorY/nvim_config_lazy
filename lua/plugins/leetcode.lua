if vim.g.os == "Windows" then
    HOME_PATH = "D:\\Code\\kirory_leetcode"
else
    HOME_PATH = "~/Workspace/code/kirory_leetcode"
end

return {
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        cmd = "Leet",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- optional
            "nvim-treesitter/nvim-treesitter",
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            ---@type string
            arg = "leetcode.nvim",

            ---@type lc.storage
            storage = {
                home = HOME_PATH,
                cache = vim.fn.stdpath("cache") .. "/leetcode",
            },
        },
    },
}
