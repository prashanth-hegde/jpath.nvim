local api = vim.api

local function println(output)
  if output == nil or output == "" then return end
  local txt = ""
  if type(output) == "table" then
    for _, v in ipairs(table) do
      if v ~= nil then txt = txt .. v end
    end
  elseif type(output) == "string" then
    txt = output
  end

  api.nvim_out_write(txt..'\n')
end

local function get_opt(opt)
  local defaults = {
    ["jpath_switch_to_output_window"]   = "false",
    ["jpath_split"]                     = "horizontal",
    ["jpath_flags"]                     = "-u",
    ["jpath_expr"]                      = "",
  }
  local o, err = pcall(function() api.nvim_get_var(opt) end)
  if not o then
    o = defaults[opt]
  else
    o = api.nvim_get_var(opt)
  end
  return tostring(o)
end

local function print_out(out)
end

return {
  println           = println,
  get_opt           = get_opt,
  print_out         = print_out,
}
