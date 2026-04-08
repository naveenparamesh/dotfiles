-- Only apply inside the monorepo (optional)
local cwd = vim.loop.cwd()
if cwd:match("cthulhu") then
  -- Set GOFLAGS so gopls sees it on startup
  vim.fn.setenv("GOFLAGS", "-mod=vendor -tags=ceph,guestfs,integration,sandbox,smoke")
end

require("naveen.core")
require("naveen.lazy")
-- For VSCode-Neovim
-- if vim.g.vscode then
--   vim.o.cmdheight = 1
--   vim.g.mapleader = " "
--   vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { silent = true })
--   -- Setup hop.nvim keymaps here:
--   local hop = require("hop")
--   local directions = require("hop.hint").HintDirection
--
--   vim.keymap.set("n", "<leader>ha", function()
--     hop.hint_anywhere()
--   end, { desc = "Hop Anywhere" })
--   vim.keymap.set("n", "<leader>hw", function()
--     hop.hint_words()
--   end, { desc = "Hop Word" })
--   vim.keymap.set("n", "<leader>hpt", function()
--     hop.hint_patterns()
--   end, { desc = "Hop Pattern" })
--
--   return
-- end
