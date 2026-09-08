return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        provider = "cursor",
        mode = "agentic", -- Enables automatic tool usage like Cursor
        -- Cursor-like: auto-approve reads; confirm file edits and shell commands
        -- Docs: https://github.com/yetone/avante.nvim#behaviour
        behaviour = {
            auto_approve_tool_permissions = { "read", "search", "think", "fetch" },
            confirmation_ui_style = "inline_buttons",
            auto_apply_diff_after_generation = false,
            acp_follow_agent_locations = true,
        },
        acp_providers = {
            cursor = {
                command = os.getenv("HOME") .. "/.local/bin/agent", -- Path to your cursor/acp agent binary
                args = { "acp" },
                auth_method = "cursor_login",
                env = {
                    HOME = os.getenv("HOME"),
                    PATH = os.getenv("PATH"),
                },
            },
        },
    },
    config = function(_, opts)
        require("avante").setup(opts)
        local Utils = require("avante.utils")

        local function sidebar_ui_ready(sidebar)
            return sidebar
                and sidebar.is_open
                and sidebar:is_open()
                and sidebar.containers
                and sidebar.containers.result
                and sidebar.containers.result.bufnr
        end

        -- ACP selector calls handle_submit before the sidebar result pane exists
        local acp_selector = require("avante.acp_config_selector")
        local orig_acp_open = acp_selector.open
        acp_selector.open = function(category, prompt_label)
            local avante = require("avante")
            local sidebar = avante.get(false)

            if sidebar_ui_ready(sidebar) then
                return orig_acp_open(category, prompt_label)
            end

            avante.open_sidebar({})
            Utils.info("Starting Cursor ACP session, model list will open when ready")

            local attempts = 0
            local timer = vim.uv.new_timer()
            if not timer then return end
            timer:start(
                200,
                200,
                vim.schedule_wrap(function()
                    attempts = attempts + 1
                    local sb = avante.get(false)
                    if sidebar_ui_ready(sb) and sb.acp_client and sb.acp_client.config_options then
                        timer:stop()
                        timer:close()
                        orig_acp_open(category, prompt_label)
                    elseif
                        sidebar_ui_ready(sb)
                        and sb.acp_client
                        and sb.acp_client.is_ready
                        and sb.acp_client:is_ready()
                        and sb.chat_history
                        and sb.chat_history.acp_session_id
                        and not sb.acp_client.config_options
                    then
                        timer:stop()
                        timer:close()
                        Utils.warn(
                            "Current ACP agent has no "
                                .. (category or "model")
                                .. " options"
                        )
                    elseif attempts > 50 then
                        timer:stop()
                        timer:close()
                        Utils.warn("Timed out waiting for ACP session; open the Avante sidebar first")
                    end
                end)
            )
        end

        -- cursor is ACP-only; the default LLM selector errors with Failed to find provider
        local selector = require("avante.model_selector")
        local orig_open = selector.open
        selector.open = function(all, timeout)
            local Config = require("avante.config")
            if not all and Config.acp_providers[Config.provider] then
                acp_selector.open("model", "ACP Agent Models> ")
                return
            end
            return orig_open(all, timeout)
        end

        -- Default <leader>ar only rebinds the sidebar to another code file and
        -- no-ops when the sidebar itself is focused. <leader>aS only fires
        -- AvanteLLMEscape; ACP cancel is not registered until session/prompt.
        local api = require("avante.api")

        local function current_sidebar()
            return require("avante").get(false)
        end

        local function sidebar_focused(sidebar)
            if not sidebar_ui_ready(sidebar) then return false end
            local curbuf = vim.api.nvim_get_current_buf()
            local input = sidebar.containers.input
            return sidebar.containers.result.bufnr == curbuf
                or (input and input.bufnr == curbuf)
        end

        local function acp_request_active(sidebar)
            if not sidebar then return false end
            local state = sidebar.current_state
            return state == "generating"
                or state == "tool calling"
                or state == "thinking"
                or state == "compacting"
                or state == "initializing"
                or state == "searching"
        end

        local orig_refresh = api.refresh
        api.refresh = function(refresh_opts)
            local sidebar = current_sidebar()
            if sidebar and sidebar.is_open and sidebar:is_open() and sidebar_focused(sidebar) then
                if sidebar.update_content_with_history then
                    sidebar:update_content_with_history()
                end
                Utils.info("Avante sidebar refreshed")
                return
            end
            if not sidebar or not sidebar.is_open or not sidebar:is_open() then
                Utils.warn("Open Avante first (<leader>aa), then refresh from a code file")
                return
            end
            orig_refresh(refresh_opts)
        end

        local orig_stop = api.stop
        api.stop = function()
            local sidebar = current_sidebar()
            local was_active = acp_request_active(sidebar)

            orig_stop()

            if sidebar and sidebar.acp_client then
                local session_id = sidebar.chat_history and sidebar.chat_history.acp_session_id
                if session_id then
                    pcall(function() sidebar.acp_client:cancel_session(session_id) end)
                end
            end

            if was_active then
                Utils.info("Stopped Avante request")
            else
                Utils.warn("No Avante request in progress")
            end
        end

        -- Lowercase alias: default <leader>as toggles unused suggestions
        vim.keymap.set("n", "<leader>as", function()
            require("avante.api").stop()
        end, { desc = "avante: stop", silent = true })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
