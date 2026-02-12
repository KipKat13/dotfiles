return {
  name = "pandoc-convert",
  dir = vim.fn.stdpath("config"),
  ft = { "markdown", "pandoc" },
  config = function()
    -- Disable vim-pandoc folding if it's installed elsewhere
    vim.g["pandoc#folding#enabled"] = 0
    
    vim.api.nvim_create_user_command("PandocPDF", function()  -- Changed name to avoid conflict
      local ft = vim.bo.filetype
      if ft ~= "markdown" and ft ~= "pandoc" then
        vim.notify("Not a markdown/pandoc file", vim.log.levels.WARN)
        return
      end
      local input = vim.fn.expand("%:p")
      local output = vim.fn.expand("%:p:r") .. ".md.pdf"
      vim.cmd("write")
      local cmd = {
        "pandoc",
        input,
        "-o",
        output,
        "--template",
        "eisvogel",
        "--listings",
        "--pdf-engine",
        "tectonic",
      }
      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Pandoc OK → " .. output)
          else
            vim.notify("Pandoc failed", vim.log.levels.ERROR)
          end
        end,
      })
    end, {})
    
    vim.keymap.set("n", "<leader>mp", ":PandocPDF<CR>", { desc = "Pandoc → PDF" })
  end,
}
