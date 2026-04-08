return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    -- 1. DEFINE HARPOON V1 COLORS (mimicking the original highlights)
    -- We define these here to ensure they exist for the statusline to use
    vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
    vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white gui=bold")
    vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7 gui=bold")
    vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#63698c")

    -- 2. HARPOON COMPONENT (With raw highlight codes)
    local function harpoon_component()
      local harpoon = require("harpoon")
      local list = harpoon:list()
      local total_items = list:length()

      if total_items == 0 then
        return ""
      end

      local current_file_path = vim.fn.expand("%:p:.")
      local contents = {}

      for i = 1, total_items do
        local item = list:get(i)
        if item then
          local value = item.value
          local filename = vim.fn.fnamemodify(value, ":t") -- Filename only

          if value == current_file_path then
            -- Active File: White text, Blue number, Bold
            table.insert(contents, "%#HarpoonNumberActive#" .. i .. ". %#HarpoonActive#" .. filename .. "%*")
          else
            -- Inactive File: Grey text, Grey number
            table.insert(contents, "%#HarpoonNumberInactive#" .. i .. ". %#HarpoonInactive#" .. filename .. "%*")
          end
        end
      end

      return table.concat(contents, "   ") -- 3 spaces between items (classic spacing)
    end

    -- Worktree component: only shows when inside a git worktree (not the main checkout)
    local function worktree_component()
      local handle = io.popen("git rev-parse --git-common-dir 2>/dev/null")
      if not handle then
        return ""
      end
      local common_dir = handle:read("*a"):gsub("%s+$", "")
      handle:close()

      local handle2 = io.popen("git rev-parse --git-dir 2>/dev/null")
      if not handle2 then
        return ""
      end
      local git_dir = handle2:read("*a"):gsub("%s+$", "")
      handle2:close()

      -- In a worktree, git-dir differs from git-common-dir
      -- In a normal repo, they're the same (both .git)
      if common_dir == "" or git_dir == "" or common_dir == git_dir then
        return ""
      end

      -- Extract worktree name from the current working directory
      local cwd = vim.fn.getcwd()
      local wt_name = vim.fn.fnamemodify(cwd, ":t")
      return "🌳 " .. wt_name
    end

    local sonokai_theme = require("lualine.themes.sonokai")
    local normal_bg = sonokai_theme.normal.a.bg
    local normal_fg = sonokai_theme.normal.a.fg
    local insert_bg = sonokai_theme.insert.a.bg
    local insert_fg = sonokai_theme.insert.a.fg
    sonokai_theme.normal.a.bg = insert_bg
    sonokai_theme.normal.a.fg = insert_fg
    sonokai_theme.insert.a.bg = "#76cce0"
    sonokai_theme.insert.a.fg = "#2d2a2e"

    lualine.setup({
      options = {
        theme = sonokai_theme,
      },
      tabline = {
        lualine_a = {
          {
            harpoon_component,
            padding = { left = 2, right = 2 },
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_b = {
          { "branch" },
          {
            worktree_component,
            color = { fg = "#a9dc76", gui = "bold" },
          },
        },
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
