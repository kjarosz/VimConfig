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
  if Window_ID ~= nil and vim.api.nvim_win_is_valid(Window_ID) then
    M._log.debug("Buffer popup exists. Closing.")
    close_menu()
  end

  ParentWindow_ID = vim.fn.win_getid()
  CurrentBuffer_ID = vim.api.nvim_win_get_buf(ParentWindow_ID)

  local buffers = get_listed_buffers()
  local content = {}
  local active_idx = 0
  for idx = 1, #buffers do
    local buffer_name = vim.fn.bufname(buffers[idx])
    if buffers[idx] == CurrentBuffer_ID then
      active_idx = idx
      table.insert(content, string.format("a%i - %s", buffers[idx], buffer_name)) 
    else
      table.insert(content, string.format(" %i - %s", buffers[idx], buffer_name)) 
    end
  end
  if active_idx == 0 then
    print("No buffers available to show")
    return
  end
  M._log.debug(vim.inspect(content))

  Window_ID = popup.create(content, {
    title = "Buffers",
    border = true,
    padding = { 0, 1, 0, 1 },
  })
  Buffer_ID = vim.api.nvim_win_get_buf(Window_ID)

  vim.api.nvim_win_set_cursor(Window_ID, { active_idx, 0 })

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
  vim.api.nvim_buf_set_keymap(Buffer_ID, "n", "dd", "", {
    callback = function() 
      local cursor_position = vim.api.nvim_win_get_cursor(Window_ID)
      M._log.debug(string.format("Selected line %i", cursor_position[1]))
      if cursor_position[1] ~= active_idx then
        local buffer_number = buffers[cursor_position[1]]
        M._log.debug(string.format("Deleting buffer %i", buffer_number, ParentWindow_ID))
        vim.api.nvim_buf_delete(buffer_number, {})
        table.remove(buffers, cursor_position[1])
        vim.api.nvim_buf_set_lines(Buffer_ID, cursor_position[1], cursor_position[1] + 1, true, {})
      else
        print("Can't delete active buffer. The world will explode")
      end
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
