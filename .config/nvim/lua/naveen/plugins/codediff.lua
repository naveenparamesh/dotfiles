return {
  "esmuellert/codediff.nvim",
  cmd = { "CodeDiff" },
  keys = {
    { "<leader>gdo", "<cmd>CodeDiff<cr>", desc = "Open code diff explorer" },
    { "<leader>gdh", "<cmd>CodeDiff history<cr>", desc = "Code diff commit history" },
  },
  opts = {
    diff = {
      layout = "side-by-side",
      jump_to_first_change = true,
      cycle_next_file = true,
    },
    explorer = {
      position = "left",
      width = 35,
      view_mode = "tree",
      flatten_dirs = true,
      initial_focus = "modified",
      focus_on_select = true,
    },
    keymaps = {
      view = {
        next_hunk = "]d",
        prev_hunk = "[d",
        next_file = "<Tab>",
        prev_file = "<S-Tab>",
        toggle_explorer = "<leader>ef",
        focus_explorer = "<leader>ee",
      },
    },
  },
  config = function(_, opts)
    require("codediff").setup(opts)

    -- When inside a codediff tab, override gd/gD/gi/gt to open in a new tab
    -- so navigation escapes the diff session instead of snapping back.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("CodeDiffLspNav", {}),
      callback = function(ev)
        local buf = ev.buf
        local bufname = vim.api.nvim_buf_get_name(buf)

        -- Only apply to codediff virtual buffers or buffers in a codediff window
        local in_codediff = bufname:match("^codediff://")
          or vim.w[vim.api.nvim_get_current_win()].codediff_restore == 1

        if not in_codediff then
          return
        end

        local kopts = { buffer = buf, silent = true }

        kopts.desc = "Go to definition (new tab, escapes diff)"
        vim.keymap.set("n", "gd", function()
          vim.cmd("tab split")
          vim.lsp.buf.definition()
        end, kopts)

        kopts.desc = "Go to declaration (new tab, escapes diff)"
        vim.keymap.set("n", "gD", function()
          vim.cmd("tab split")
          vim.lsp.buf.declaration()
        end, kopts)

        kopts.desc = "Go to implementation (new tab, escapes diff)"
        vim.keymap.set("n", "gi", function()
          vim.cmd("tab split")
          vim.lsp.buf.implementation()
        end, kopts)

        kopts.desc = "Go to type definition (new tab, escapes diff)"
        vim.keymap.set("n", "gt", function()
          vim.cmd("tab split")
          vim.lsp.buf.type_definition()
        end, kopts)

        kopts.desc = "Show LSP references (new tab, escapes diff)"
        vim.keymap.set("n", "gR", function()
          vim.cmd("tab split")
          require("telescope.builtin").lsp_references({ initial_mode = "normal" })
        end, kopts)
      end,
    })
  end,
}
