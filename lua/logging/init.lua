---@mod logging logging.nvim
---
---@brief [[
---
---Logging library for Neovim plugins, slightly inspired by rmagatti/logger.nvim
---and extracted from `rest.nvim`.
---
---------------------------------------------------------------------------------
---
---Usage:
---
---```lua
---local logger = require("logging"):new({
---  level = "debug",
---  plugin = "rest.nvim",
---})
---
---logger:set_log_level("info")
---
---logger:info("This is an info log")
--- -- [rest.nvim] INFO: This is an info log
---```
---
---@brief ]]

---@class Logging
---@field _VERSION string logging.nvim version constant
local logging = {}

logging._VERSION = "1.1.0"

-- NOTE: vim.loop has been renamed to vim.uv in Neovim >= 0.10 and will be removed later
local uv = vim.uv or vim.loop

---@class LoggingLevels
---@field trace number Equivalent of `vim.log.levels.TRACE`
---@field debug number Equivalent of `vim.log.levels.DEBUG`
---@field info number Equivalent of `vim.log.levels.INFO`
---@field warn number Equivalent of `vim.log.levels.WARN`
---@field error number Equivalent of `vim.log.levels.ERROR`
---@see vim.log.levels
local levels = {
  trace = vim.log.levels.TRACE,
  debug = vim.log.levels.DEBUG,
  info = vim.log.levels.INFO,
  warn = vim.log.levels.WARN,
  error = vim.log.levels.ERROR,
}

---@class LoggingConfig
---@field level_name? string Logging level name. Default is `"info"`
---@field plugin_name string Plugin name. Default is `""`
---@field save_logs? boolean Whether to save log messages into a `.log` file. Default is `true`
local default_config = {
  level_name = "info",
  plugin_name = "",
  save_logs = true,
}

---Store the logger output in a file at `vim.fn.stdpath("log")`
---@see vim.fn.stdpath
---@param plugin_name string The plugin name
---@param msg string Logger message to be saved
local function store_log(plugin_name, msg)
  local date = os.date("%F %r") -- 2024-01-26 01:25:05 PM
  local log_msg = date .. " | " .. msg .. "\n"
  local log_path = table.concat({ vim.fn.stdpath("log"), plugin_name .. ".log" }, "/")

  -- 644 sets read and write permissions for the owner, and it sets read-only
  -- mode for the group and others
  ---@diagnostic disable-next-line param-type-mismatch
  uv.fs_open(log_path, "a+", tonumber(644, 8), function(err, file)
    if file and not err then
      local file_pipe = uv.new_pipe(false)
      ---@cast file_pipe uv_pipe_t
      uv.pipe_open(file_pipe, file)
      uv.write(file_pipe, log_msg)
      uv.fs_close(file)
    end
  end)
end

---Create a new logger instance
---@param opts LoggingConfig Logger configuration
---@return Logging
function logging:new(opts)
  opts = opts or {}
  local conf = vim.tbl_deep_extend("force", default_config, opts)
  self.level = levels[conf.level_name]
  self.plugin = conf.plugin_name
  self.save_logs = conf.save_logs

  self.__index = function(_, index)
    if type(self[index]) == "function" then
      return function(...)
        -- Make any logger function call with "." access result in the syntactic sugar ":" access
        self[index](self, ...)
      end
    else
      return self[index]
    end
  end
  setmetatable(opts, self)

  return self
end

---Set the log level for the logger
---@param level string New logging level
---@see vim.log.levels
function logging:set_log_level(level)
  self.level = levels[level]
end

---Log a trace message
---@param msg string Log message
function logging:trace(msg)
  msg = self.plugin .. " TRACE: " .. msg
  if self.level == vim.log.levels.TRACE then
    vim.notify(msg, levels.trace)
  end

  if self.save_logs then
    store_log(self.plugin, msg)
  end
end

---Log a debug message
---@param data any Log message data. If it is a table, it will be converted into a readable representation
function logging:debug(data)
  local msg = self.plugin .. " DEBUG: " .. vim.inspect(data)
  if self.level == vim.log.levels.DEBUG then
    vim.notify(msg, levels.debug)
  end

  if self.save_logs then
    store_log(self.plugin, msg)
  end
end

---Log an info message
---@param msg string Log message
function logging:info(msg)
  msg = self.plugin .. " INFO: " .. msg
  local valid_levels = { vim.log.levels.INFO, vim.log.levels.DEBUG }
  if vim.tbl_contains(valid_levels, self.level) then
    vim.notify(msg, levels.info)
  end

  if self.save_logs then
    store_log(self.plugin, msg)
  end
end

---Log a warning message
---@param msg string Log message
function logging:warn(msg)
  msg = self.plugin .. " WARN: " .. msg
  local valid_levels = { vim.log.levels.INFO, vim.log.levels.DEBUG, vim.log.levels.WARN }
  if vim.tbl_contains(valid_levels, self.level) then
    vim.notify(msg, levels.warn)
  end

  if self.save_logs then
    store_log(self.plugin, msg)
  end
end

---Log an error message
---@param msg string Log message
function logging:error(msg)
  msg = self.plugin .. " ERROR: " .. msg
  vim.notify(msg, levels.error)

  if self.save_logs then
    store_log(self.plugin, msg)
  end
end

return logging
