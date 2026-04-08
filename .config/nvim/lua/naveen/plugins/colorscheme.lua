return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "macchiato", -- options: latte, frappe, macchiato, mocha
  --       transparent_background = true,
  --       show_end_of_buffer = false, -- hide ~ at end of buffer
  --       term_colors = true,
  --       styles = {
  --         comments = { "italic" },
  --         conditionals = {},
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       integrations = {
  --         treesitter = true,
  --         native_lsp = {
  --           enabled = true,
  --           virtual_text = {
  --             errors = false,
  --             hints = false,
  --             warnings = false,
  --             information = false,
  --           },
  --           underlines = {
  --             errors = { "undercurl" },
  --             hints = { "undercurl" },
  --             warnings = { "undercurl" },
  --             information = { "undercurl" },
  --           },
  --         },
  --         cmp = true,
  --         gitsigns = true,
  --         telescope = {
  --           enabled = true,
  --           style = "nvchad",
  --         },
  --         which_key = true,
  --         indent_blankline = {
  --           enabled = true,
  --           scope_color = "sapphire",
  --           colored_indent_levels = false,
  --         },
  --         nvimtree = {
  --           enabled = true,
  --           show_root = true,
  --           transparent_panel = true,
  --         },
  --         harpoon = true,
  --         mason = true,
  --         notify = true,
  --         noice = true,
  --         mini = false,
  --       },
  --       highlight_overrides = {
  --         mocha = function(C)
  --           return {
  --             NvimTreeNormal = { bg = "NONE" },
  --             NormalFloat = { bg = "NONE" },
  --             FloatBorder = { fg = C.blue },
  --             LineNr = { fg = C.surface2 },
  --           }
  --         end,
  --       },
  --     })
  --
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       transparent_mode = true, -- ⬅️ enables transparent background
  --       terminal_colors = true,
  --       undercurl = true,
  --       bold = true,
  --       italic = {
  --         strings = false,
  --         emphasis = false,
  --         comments = false,
  --         operators = false,
  --         folds = true,
  --       },
  --     })
  --     vim.opt.background = "dark" -- or "light", depending on your variant
  --     vim.cmd([[colorscheme gruvbox]])
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha", -- latte, frappe, macchiato, mocha
  --       transparent_background = true,
  --       integrations = {
  --         treesitter = true,
  --         native_lsp = {
  --           enabled = true,
  --         },
  --         cmp = true,
  --         gitsigns = true,
  --         telescope = true,
  --         which_key = true,
  --         indent_blankline = {
  --           enabled = true,
  --           scope_color = "sapphire", -- or any other color
  --           colored_indent_levels = false,
  --         },
  --       },
  --     })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
  {
    "sainnhe/sonokai",
    version = "*",
    priority = 1000,
    config = function()
      -- Basic settings
      vim.g.sonokai_style = "espresso" -- other options: 'default', 'atlantis', 'shusia', 'maia', 'espresso'
      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_enable_italic = 0
      vim.g.sonokai_disable_italic_comment = 0
      vim.g.sonokai_enable_bold = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      vim.g.sonokai_diagnostic_line_highlight = 1
      vim.g.sonokai_diagnostic_virtual_text = "colored" -- or "grey"

      -- Apply colorscheme
      vim.cmd.colorscheme("sonokai")

      -- Optional custom highlight overrides
      local override_highlights = {
        Normal = { bg = "NONE" },
        NormalNC = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        VertSplit = { bg = "NONE", fg = "#5c6370" },
        StatusLine = { bg = "NONE", fg = "#5c6370" },
        LineNr = { fg = "#5c6370", bg = "NONE" },
        CursorLineNr = { fg = "#ffffff", bold = true, bg = "NONE" },
        Pmenu = { bg = "NONE", fg = "#c0caf5" },
        FloatBorder = { bg = "NONE", fg = "#5c6370" },
        -- NvimTree specific
        NvimTreeNormal = { bg = "NONE" },
        NvimTreeNormalNC = { bg = "NONE" },
        NvimTreeEndOfBuffer = { bg = "NONE", fg = "NONE" },
      }

      for group, opts in pairs(override_highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end

      -- 2. THE BOLDIFIER (Makes text thicker while keeping colors)
      -- Add any group you want to be thicker here
      local bold_groups = {
        "Comment", -- Comments
        "Constant", -- Numbers, Booleans
        "Function", -- Function names
        "Identifier", -- Variable names
        "Keyword", -- if, else, for, return
        "Operator", -- =, +, -, *
        "PreProc", -- #include, import
        "Special", -- Special symbols
        "Statement", -- Statements
        "String", -- Strings (optional, remove if you don't like bold strings)
        "Type", -- int, bool, void, class names
      }

      for _, group in ipairs(bold_groups) do
        -- Get the current highlight properties (color, etc.)
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        -- Force bold
        hl.bold = true
        -- Re-apply with the new bold attribute
        vim.api.nvim_set_hl(0, group, hl)
      end
    end,
  },
  -- {
  --   "sainnhe/gruvbox-material",
  --   name = "gruvbox-material",
  --   priority = 1000,
  --   config = function()
  --     vim.g.gruvbox_material_better_performance = 1
  --     -- Fonts
  --     vim.g.gruvbox_material_disable_italic_comment = 0
  --     vim.g.gruvbox_material_enable_italic = 0
  --     vim.g.gruvbox_material_enable_bold = 0
  --     vim.g.gruvbox_material_transparent_background = 1
  --     -- Themes
  --     vim.g.gruvbox_material_foreground = "mix"
  --     vim.g.gruvbox_material_background = "hard"
  --     vim.g.gruvbox_material_ui_contrast = "high" -- The contrast of line numbers, indent lines, etc.
  --     vim.g.gruvbox_material_float_style = "dim" -- Background of floating windows
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme gruvbox-material]])
  --   end,
  -- },
  -- {
  --   "bluz71/vim-nightfly-guicolors",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme nightfly]])
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     local bg = "#011628"
  --     local bg_dark = "#011423"
  --     local bg_highlight = "#143652"
  --     local bg_search = "#0A64AC"
  --     local bg_visual = "#275378"
  --     local fg = "#CBE0F0"
  --     local fg_dark = "#B4D0E9"
  --     local fg_gutter = "#627E97"
  --     local border = "#547998"
  --
  --     require("tokyonight").setup({
  --       style = "night",
  --       transparent = false,
  --       styles = {
  --         comments = { italic = true },
  --         keywords = { italic = false },
  --         functions = {},
  --         variables = {},
  --         sidebars = "dark",
  --         floats = "dark",
  --       },
  --       on_colors = function(colors)
  --         colors.bg = bg
  --         colors.bg_dark = bg_dark
  --         colors.bg_float = bg_dark
  --         colors.bg_highlight = bg_highlight
  --         colors.bg_popup = bg_dark
  --         colors.bg_search = bg_search
  --         colors.bg_sidebar = bg_dark
  --         colors.bg_statusline = bg_dark
  --         colors.bg_visual = bg_visual
  --         colors.border = border
  --         colors.fg = fg
  --         colors.fg_dark = fg_dark
  --         colors.fg_float = fg
  --         colors.fg_gutter = fg_gutter
  --         colors.fg_sidebar = fg_dark
  --       end,
  --     })
  --     -- load the colorscheme here
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
}
