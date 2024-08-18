require('neo-tree').setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = true,
    },
    window = {
      width = 40,
      mappings = {
        ["<space>"] = "toggle_node",
        ["<CR>"] = "open",
      },
    },
  },
  -- Additional configurations

})
