local map = vim.keymap.set

local function smart_bufdelete(bufnr)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local job = vim.b[bufnr].terminal_job_id
  if vim.bo[bufnr].buftype == "terminal" and job and vim.fn.jobwait({ job }, 0)[1] == -1 then
    local choice = vim.fn.confirm("Close the running terminal?", "&Close\n&Cancel", 2)
    if choice ~= 1 then
      return
    end
  end

  require("snacks").bufdelete(bufnr)
end

local function toggle_buffer_autoformat()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify(
    "Buffer format on save " .. (vim.b.disable_autoformat and "disabled" or "enabled"),
    vim.log.levels.INFO
  )
end

local function toggle_global_autoformat()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify(
    "Global format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
    vim.log.levels.INFO
  )
end

local function inlay_hints_enabled(bufnr)
  local ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
  if ok then
    return enabled
  end

  ok, enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
  return ok and enabled or false
end

local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local supported = false

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method("textDocument/inlayHint") then
      supported = true
      break
    end
  end

  if not supported then
    vim.notify("No attached LSP client provides inlay hints", vim.log.levels.WARN)
    return
  end

  local enabled = inlay_hints_enabled(bufnr)
  pcall(vim.lsp.inlay_hint.enable, not enabled, { bufnr = bufnr })
  vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
end

local function toggle_spell()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell checking " .. (vim.wo.spell and "enabled" or "disabled"), vim.log.levels.INFO)
end

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

map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")
map("n", "<leader>x", "<cmd>x<cr>")
map("n", "<leader>l", "<cmd>e<cr>")

map("t", "<C-j>", [[<C-\><C-n><C-w>j]])
map("t", "<C-h>", [[<C-\><C-n><C-w>h]])
map("t", "<C-k>", [[<C-\><C-n><C-w>k]])
map("t", "<C-l>", [[<C-\><C-n><C-w>l]])

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("user_terminal_keymaps", { clear = true }),
  callback = function(args)
    map({ "t", "n" }, "<C-x>", function()
      vim.cmd("hide")
    end, { buffer = args.buf, desc = "Hide terminal" })
  end,
})

map("n", "<leader>bd", function()
  smart_bufdelete(0)
end, { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>")
map("n", "<leader>bp", "<cmd>bprevious<cr>")
map("n", "<leader>tf", toggle_buffer_autoformat, { desc = "Toggle buffer format on save" })
map("n", "<leader>tF", toggle_global_autoformat, { desc = "Toggle global format on save" })
map("n", "<leader>th", toggle_inlay_hints, { desc = "Toggle inlay hints" })
map("n", "<leader>ts", toggle_spell, { desc = "Toggle spell checking" })
