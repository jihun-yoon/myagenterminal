return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = { render_modes = false },
    keys = {
      {
        "<leader>mp",
        function()
          require("render-markdown").preview()
        end,
        desc = "Markdown preview",
      },
    },
  },
}
