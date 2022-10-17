local status_ok, c = pcall(require, "Comment")
if not status_ok then return end

local status_comment, cmt = pcall(require, "ts_context_commentstring")

pre_hook = nil

if status_comment then pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() end

c.setup{
  pre_hook = pre_hook
}
