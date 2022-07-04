local api = vim.api
local util = require("jp_utils")

local out_buf_name = "jpath_output"
local expr_buf_name = "jpath_expr"

local function get_out_win()
  local outwin
  local currwin = api.nvim_get_current_win()
  for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
    local currbuf = api.nvim_win_get_buf(w)
    local bufname = api.nvim_buf_get_name(currbuf)
    if bufname:match(out_buf_name) ~= nil then outwin = w end
  end

  if outwin == nil then
    -- outwin not present, create one
    local split = util.get_opt("jpath_split")
    local cmd = "belowright vsplit "
    if split == "horizontal" then cmd = "belowright split " end
    api.nvim_command(cmd..out_buf_name)
    outwin = api.nvim_get_current_win()
    api.nvim_command("set ft=json")
    api.nvim_command("set wrap")
    api.nvim_set_current_win(currwin)
  end

  return outwin
end

local function print_out(output)
  if output == nil or output == "" then return end
  local currwin = api.nvim_get_current_win()
  local switch = (util.get_opt("jpath_switch_to_output_window") == "false")

  local outwin = get_out_win()
  api.nvim_set_current_win(outwin)
  api.nvim_command("%d")
  api.nvim_paste(output, true, -1)

  if switch then api.nvim_set_current_win(currwin) end
end

local function popup_window()
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_height = math.ceil(height * 0.4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = math.ceil(width / 3),
    height = 1,
    row = row,
    col = col,
    anchor = "NW",
    border = "double"
  }

  local win = api.nvim_open_win(buf, true, opts)
  api.nvim_win_set_option(win, 'cursorline', true)
  local width = api.nvim_win_get_width(0)
  api.nvim_buf_set_lines(buf, 0, -1, false, {})
  api.nvim_buf_add_highlight(buf, -1, 'JPath', 0, 0, -1)

  -- make buf insertable and escapeable
  local closing_keys = {'<Esc>', '<Leader>'}
  for _, k in ipairs(closing_keys) do
    api.nvim_buf_set_keymap(buf, 'i', k, '<Esc>:close<CR>', {silent = true, nowait = true, noremap = true})
    api.nvim_buf_set_keymap(buf, 'n', k, ':close<CR>', {silent = true, nowait = true, noremap = true})
  end

  api.nvim_buf_set_keymap(buf, 'i', '<CR>', '<Esc>:lua require("jpath").capture_expr()<CR>', {silent = true, nowait = true, noremap = true})
  api.nvim_buf_set_keymap(buf, 'n', '<CR>', ':lua require("jpath").capture_expr()<CR>', {silent = true, nowait = true, noremap = true})
  api.nvim_command("startinsert")
end

return {
  get_out_buf       = get_out_buf,
  print_out         = print_out,
  popup_window      = popup_window,
}
