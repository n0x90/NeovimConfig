local map = vim.keymap.set

map("i", "jj", "<Esc>")
map("t", "jj", [[<C-\><C-n>]])

map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("t", "<Esc>", [[<C-\><C-n>]])

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
map("v", "K", ":m '<-2<cr>gv=gv", { silent = true })

map("v", "<", "<gv")
map("v", ">", ">gv")

-- TODO: Check if the following plays nice with other buf types
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader>x", "<cmd>x<cr>")

map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
map("t", "<C-l>", [[<C-\><C-n><C-w>l]])

map({"t", "n"}, "<C-x>", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("hide")
  end
end, { desc = "Hide terminal" })

map("n", "<leader>bd", "<cmd>bd<cr>")
map("n", "<leader>bn", "<cmd>bnext<cr>")
map("n", "<leader>bp", "<cmd>bprevious<cr>")