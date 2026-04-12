vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.spelllang = { "en_us" }
vim.opt.spelloptions:append("camel")

vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.updatetime = 250
vim.opt.cursorline = true
vim.opt.confirm = true
vim.opt.inccommand = "split"
vim.opt.timeoutlen = 300
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local spell_group = vim.api.nvim_create_augroup("user_spell", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = { "gitcommit", "markdown", "text", "plaintex", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
