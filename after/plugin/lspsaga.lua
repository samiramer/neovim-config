local status_ok, saga = pcall(require, "lspsaga")
if (not status_ok) then return end

local has_catppuccin, catppuccin = pcall(require, "catppuccin")

if (not has_catppuccin) then
    saga.setup {
        request_timeout = 10000,
        ui = {
            border = 'rounded'
        }
    }
else
    saga.setup {
        request_timeout = 10000,
        ui = {
            border = 'rounded',
            colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
            kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        }
    }
end
