local map = vim.keymap.set

-- Navigate to normal mode
map("i", "jj", "<Esc>")
map("t", "jj", [[<C-\><C-n>]])
map("t", "<Esc>", [[<C-\><C-n>]])

-- Clear search
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Navigate windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Move code
map("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { silent = true })

-- Keep highlight after indent in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Quick write/quit
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- Terminal navigation
vim.keymap.set("t", "jj", [[<C-\><C-n>]])
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
vim.keymap.set({ "t", "n" }, "<C-x>", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("hide")
  end
end, { desc = "Hide terminal" })


-- Buffer managment
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>")
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>")
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>")