return {
  {
    "mrpbennett/orbit.nvim",
    config = function()
      require("orbit").setup({
        winbar = false,
        schema_width = 40,

        -- keymaps
        keymaps = {
          workspace = "<leader>D",
          execute = "<leader>E",
          cancel = "<leader>X",
          select_profile = "<leader>P",
          browse = "<leader>B",
        },
      })
    end,
  },
}
