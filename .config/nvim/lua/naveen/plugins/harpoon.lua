return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    local tabline = require("harpoon.tabline")

    vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
    vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
    vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=white")
    -- vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
    vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=grey")
    vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")
    harpoon.setup({
      save_on_toggle = false,
      save_on_change = true,
      enter_on_sendcmd = false,
      tmux_autoclose_windows = false,
      excluded_filetypes = { "harpoon" },
      mark_branch = true,
      tabline = true,
      tabline_prefix = "   ",
      tabline_suffix = "   ",
    })
    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local tabline_toggle = false

    keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon mark file" })
    keymap.set("n", "<leader>hl", ui.toggle_quick_menu, { desc = "Harpoon list files" })

    -- Keybindings to jump to Harpoon marks 1 to 5
    keymap.set("n", "<leader>1", function()
      ui.nav_file(1)
    end, { desc = "Harpoon to file 1" })
    keymap.set("n", "<leader>2", function()
      ui.nav_file(2)
    end, { desc = "Harpoon to file 2" })
    keymap.set("n", "<leader>3", function()
      ui.nav_file(3)
    end, { desc = "Harpoon to file 3" })
    keymap.set("n", "<leader>4", function()
      ui.nav_file(4)
    end, { desc = "Harpoon to file 4" })
    keymap.set("n", "<leader>5", function()
      ui.nav_file(5)
    end, { desc = "Harpoon to file 5" })
    keymap.set("n", "<leader>6", function()
      ui.nav_file(6)
    end, { desc = "Harpoon to file 6" })
    keymap.set("n", "<leader>7", function()
      ui.nav_file(7)
    end, { desc = "Harpoon to file 7" })
    keymap.set("n", "<leader>8", function()
      ui.nav_file(8)
    end, { desc = "Harpoon to file 8" })
    keymap.set("n", "<leader>9", function()
      ui.nav_file(9)
    end, { desc = "Harpoon to file 9" })

    -- Keymap to toggle Harpoon tabline
    keymap.set("n", "<leader>ht", function()
      tabline_toggle = not tabline_toggle
      if tabline_toggle then
        vim.cmd("set showtabline=2")
      else
        vim.cmd("set showtabline=1")
      end
    end, { desc = "Toggle Harpoon tabline" })
  end,
}
