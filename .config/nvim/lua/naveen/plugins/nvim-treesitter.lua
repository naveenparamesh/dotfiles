return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter").setup()

      -- Enable treesitter-based syntax highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Install parsers (replaces ensure_installed)
      local parsers = {
        "json",
        "javascript",
        "typescript",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "luadoc",
        "luap",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
      }

      -- Auto-install missing parsers
      local installed = require("nvim-treesitter").get_installed()
      local installed_set = {}
      for _, lang in ipairs(installed) do
        installed_set[lang] = true
      end
      local to_install = {}
      for _, lang in ipairs(parsers) do
        if not installed_set[lang] then
          to_install[#to_install + 1] = lang
        end
      end
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- Incremental selection keymaps
      vim.keymap.set("n", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").init()
      end, { desc = "Init treesitter selection" })
      vim.keymap.set("x", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").node_incremental()
      end, { desc = "Increment treesitter selection" })
      vim.keymap.set("x", "<bs>", function()
        require("nvim-treesitter.incremental_selection").node_decremental()
      end, { desc = "Decrement treesitter selection" })
    end,
  },
}
