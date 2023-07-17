local M = {}

function M.setup()
  -- Set a magic flag to get coq to shut up on startup
  vim.g.coq_settings = { auto_start = 'shut-up' }
  local coq = require "coq"
  coq.Now() -- Start coq

  -- 3party sources
  require "coq_3p" {
    { src = "bc", short_name = "MATH", precision = 6, trigger = "!bc"}, -- Calculator
    { src = "cow", trigger = "!cow" }, -- cow command
    { src = "figlet", trigger = "!big" }, -- figlet command
  }
end

return M
