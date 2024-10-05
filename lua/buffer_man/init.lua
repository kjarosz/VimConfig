local popup = require("plenary.popup")

local M = {
}


ParentWindow_ID = nil
Window_ID = nil
Buffer_ID = nil

local function get_listed_buffers()
  local buffers = {}

  for buffer = 1, vim.fn.bufnr('$') do
    if vim.fn.buflisted(buffer) == 1 then
      table.insert(buffers, buffer)
    end
  end
  return buffers
end

local function close_menu()
  vim.api.nvim_win_close(Window_ID, true)
  Window_ID = nil
  Buffer_ID = nil
  ParentWindow_ID = nil
  return
end
 
function M.toggle_buffers_menu()
  if Window_ID ~= nil then
    M._log.debug("Buffer popup exists. Closing.")
    close_menu()
  end

  local buffers = get_listed_buffers()
  local content = {}
  for idx = 1, #buffers do
    local buffer_name = vim.fn.bufname(buffers[idx])
    table.insert(content, string.format("%i - %s", buffers[idx], buffer_name)) 
  end
  M._log.debug(vim.inspect(content))

  ParentWindow_ID = vim.fn.win_getid()
  Window_ID = popup.create(content, {
    title = "Buffers",
    border = true,
    padding = { 0, 1, 0, 1 },
  })
  Buffer_ID = vim.api.nvim_win_get_buf(Window_ID)

  vim.api.nvim_buf_set_keymap(Buffer_ID, "n", "q", ":q<CR>", {})
  vim.api.nvim_buf_set_keymap(Buffer_ID, "n", "<ESC>", ":q<CR>", {})
  vim.api.nvim_buf_set_keymap(Buffer_ID, "n", "<CR>", "", {
    callback = function()
      local cursor_position = vim.api.nvim_win_get_cursor(Window_ID)
      M._log.debug(string.format("Selected line %i", cursor_position[1]))
      local buffer_number = buffers[cursor_position[1]]
      M._log.debug(string.format("Setting buffer %i for window %i", buffer_number, ParentWindow_ID))
      vim.api.nvim_win_set_buf(ParentWindow_ID, buffer_number)
      close_menu()
    end
  })
end


function M.setup(opts)
  M._log = require("plenary.log").new({
    plugin = "buffer_man",
    level = opts.log_level or "warn",
  })
  vim.keymap.set("n", "<leader>br", 
    function() 
      require("plenary.reload").reload_module("buffer_man")
      require("buffer_man").setup({ log_level = "debug" })
      print("Buffer man, now reloaded!!!")
    end,
    { desc = "[B]uffer_man [R]eload - When in doubt, try again" })
  vim.keymap.set("n", "<leader>bb", function() M.toggle_buffers_menu() end, { desc = "Show menu with currently listed buffers" })
end

return M
