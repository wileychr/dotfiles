local M = {}

function M.setup()
  -- Set a magic flag to get coq to shut up on startup
  vim.g.coq_settings = { auto_start = 'shut-up' }
  local coq = require "coq"
  coq.Now() -- Start coq
end

return M
