return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- 1. DEFINE A CACHE FOR VIEWS
    -- This table will store the exact scroll position for every buffer you visit.
    local view_cache = {}

    -- 2. SETUP HARPOON WITH MANUAL VIEW MANAGEMENT
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      default = {
        select = function(list_item, list, option)
          -- A. SAVE THE VIEW OF THE CURRENT BUFFER (Before we leave)
          local current_buf = vim.api.nvim_get_current_buf()
          -- winsaveview() captures cursor AND scroll position (topline)
          view_cache[current_buf] = vim.fn.winsaveview()

          -- B. PREPARE THE TARGET BUFFER
          local bufnr = vim.fn.bufnr(list_item.value)
          local created_new_buffer = false

          if bufnr == -1 then
            created_new_buffer = true
            bufnr = vim.fn.bufadd(list_item.value)
          end

          if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
            vim.api.nvim_set_option_value("buflisted", true, { buf = bufnr })
          end

          -- C. SWITCH TO THE TARGET BUFFER
          vim.api.nvim_set_current_buf(bufnr)

          -- D. RESTORE THE VIEW (The Magic Fix)
          if view_cache[bufnr] then
            -- If we have a cached view, restore it exactly (cursor + scroll)
            vim.fn.winrestview(view_cache[bufnr])
          elseif created_new_buffer and list_item.context then
            -- If it's a brand new buffer, use Harpoon's saved row/col
            vim.api.nvim_win_set_cursor(0, {
              list_item.context.row or 1,
              list_item.context.col or 0,
            })
          end
        end,
      },
    })

    -- 3. HIGHLIGHTS
    vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
    vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
    vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=white")
    vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=grey")

    -- 4. KEYMAPS
    local keymap = vim.keymap

    -- Add file
    keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon mark file" })

    -- Toggle Menu
    keymap.set("n", "<leader>hl", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon list files" })

    -- Navigation Keys
    keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon to file 1" })
    keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon to file 2" })
    keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon to file 3" })
    keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon to file 4" })
    keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon to file 5" })
    keymap.set("n", "<leader>6", function()
      harpoon:list():select(6)
    end, { desc = "Harpoon to file 6" })
    keymap.set("n", "<leader>7", function()
      harpoon:list():select(7)
    end, { desc = "Harpoon to file 7" })
    keymap.set("n", "<leader>8", function()
      harpoon:list():select(8)
    end, { desc = "Harpoon to file 8" })
    keymap.set("n", "<leader>9", function()
      harpoon:list():select(9)
    end, { desc = "Harpoon to file 9" })
  end,
}
