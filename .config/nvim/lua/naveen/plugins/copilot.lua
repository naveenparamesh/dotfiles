-- lua/plugins/copilot.lua
return {
  -- Plugin for GitHub Copilot completions
  {
    "github/copilot.vim",
    version = "*",
    event = "InsertEnter",
    config = function()
      -- Example keymap to toggle Copilot on/off
      vim.keymap.set("n", "<leader>ct", function()
        if vim.g.copilot_enabled == 1 then
          vim.cmd.Copilot("disable")
          print("Copilot disabled")
        else
          vim.cmd.Copilot("enable")
          print("Copilot enabled")
        end
      end, { desc = "[C]opilot [T]oggle Completions" })
    end,
  },

}
