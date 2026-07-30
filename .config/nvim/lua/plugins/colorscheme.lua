return {
    -- Auto dark/light mode switching based on macOS appearance
    {
        "f-person/auto-dark-mode.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            set_dark_mode = function()
                vim.cmd.colorscheme("catppuccin-macchiato")
            end,
            set_light_mode = function()
                vim.cmd.colorscheme("catppuccin-latte")
            end,
        },
    },
}
