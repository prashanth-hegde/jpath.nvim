local api = vim.api
local util = require("jp_utils")
local windows = require("jp_windows")

local function apply_filter(expr)
  local flags = util.get_opt("jpath_flags")
  local json_t = api.nvim_buf_get_lines(0, 0, -1, false)
  local json = ""
  for _, l in ipairs(json_t) do
    json = json .. l
  end

  local cmd = string.format("jpath %s '%s' '%s'", flags, expr, json)
  local filtered = vim.fn.system(cmd)
  windows.print_out(filtered)
end

local function capture_expr()
  local expr = api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if #expr < 1 then util.println("no expression found") return end
  api.nvim_buf_delete(0, {})
  api.nvim_set_var("jpath_expr", expr)
  apply_filter(expr)
end

local function filter()
  if api.nvim_buf_get_option(0, "filetype") ~= "json" then
    util.println("filetype is not json, cannot execute jpath")
    return
  end
  windows.popup_window()
end

local function format()
  local flags = util.get_opt("jpath_flags")
  local json_t = api.nvim_buf_get_lines(0, 0, -1, false)
  local json = ""
  for _, l in ipairs(json_t) do
    json = json .. l
  end

  local cmd = string.format("jpath %s . '%s'", flags, json)
  local formatted = vim.fn.system(cmd)
  api.nvim_command("%d")
  api.nvim_put(formatted, true, -1)
end

return {
  format        = format,
  filter        = filter,
  capture_expr  = capture_expr,
}
