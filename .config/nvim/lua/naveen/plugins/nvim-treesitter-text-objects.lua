return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = true,
  config = function()
    local select = require("nvim-treesitter-textobjects.select")
    local swap = require("nvim-treesitter-textobjects.swap")
    local move = require("nvim-treesitter-textobjects.move")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    -- Select keymaps
    local select_keymaps = {
      ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
      ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
      ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
      ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
      ["a:"] = { query = "@property.outer", desc = "Select outer part of an object property" },
      ["i:"] = { query = "@property.inner", desc = "Select inner part of an object property" },
      ["l:"] = { query = "@property.lhs", desc = "Select left part of an object property" },
      ["r:"] = { query = "@property.rhs", desc = "Select right part of an object property" },
      ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
      ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
      ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
      ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
      ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
      ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
      ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
      ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
      ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
      ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
      ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
      ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
    }
    for key, mapping in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(mapping.query)
      end, { desc = mapping.desc })
    end

    -- Swap keymaps
    local swap_next = {
      ["<leader>na"] = "@parameter.inner",
      ["<leader>n:"] = "@property.outer",
      ["<leader>nm"] = "@function.outer",
    }
    local swap_prev = {
      ["<leader>pa"] = "@parameter.inner",
      ["<leader>p:"] = "@property.outer",
      ["<leader>pm"] = "@function.outer",
    }
    for key, query in pairs(swap_next) do
      vim.keymap.set("n", key, function()
        swap.swap_next(query)
      end, { desc = "Swap next " .. query })
    end
    for key, query in pairs(swap_prev) do
      vim.keymap.set("n", key, function()
        swap.swap_previous(query)
      end, { desc = "Swap prev " .. query })
    end

    -- Move keymaps
    local move_maps = {
      ["]f"] = { fn = move.goto_next_start, query = "@call.outer", desc = "Next function call start" },
      ["]m"] = { fn = move.goto_next_start, query = "@function.outer", desc = "Next method/function def start" },
      ["]c"] = { fn = move.goto_next_start, query = "@class.outer", desc = "Next class start" },
      ["]i"] = { fn = move.goto_next_start, query = "@conditional.outer", desc = "Next conditional start" },
      ["]l"] = { fn = move.goto_next_start, query = "@loop.outer", desc = "Next loop start" },
      ["]s"] = { fn = move.goto_next_start, query = "@scope", group = "locals", desc = "Next scope" },
      ["]z"] = { fn = move.goto_next_start, query = "@fold", group = "folds", desc = "Next fold" },
      ["]F"] = { fn = move.goto_next_end, query = "@call.outer", desc = "Next function call end" },
      ["]M"] = { fn = move.goto_next_end, query = "@function.outer", desc = "Next method/function def end" },
      ["]C"] = { fn = move.goto_next_end, query = "@class.outer", desc = "Next class end" },
      ["]I"] = { fn = move.goto_next_end, query = "@conditional.outer", desc = "Next conditional end" },
      ["]L"] = { fn = move.goto_next_end, query = "@loop.outer", desc = "Next loop end" },
      ["[f"] = { fn = move.goto_previous_start, query = "@call.outer", desc = "Prev function call start" },
      ["[m"] = { fn = move.goto_previous_start, query = "@function.outer", desc = "Prev method/function def start" },
      ["[c"] = { fn = move.goto_previous_start, query = "@class.outer", desc = "Prev class start" },
      ["[i"] = { fn = move.goto_previous_start, query = "@conditional.outer", desc = "Prev conditional start" },
      ["[l"] = { fn = move.goto_previous_start, query = "@loop.outer", desc = "Prev loop start" },
      ["[F"] = { fn = move.goto_previous_end, query = "@call.outer", desc = "Prev function call end" },
      ["[M"] = { fn = move.goto_previous_end, query = "@function.outer", desc = "Prev method/function def end" },
      ["[C"] = { fn = move.goto_previous_end, query = "@class.outer", desc = "Prev class end" },
      ["[I"] = { fn = move.goto_previous_end, query = "@conditional.outer", desc = "Prev conditional end" },
      ["[L"] = { fn = move.goto_previous_end, query = "@loop.outer", desc = "Prev loop end" },
    }
    for key, mapping in pairs(move_maps) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        mapping.fn(mapping.query, mapping.group)
      end, { desc = mapping.desc })
    end

    -- Repeatable moves with ; and ,
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
  end,
}
