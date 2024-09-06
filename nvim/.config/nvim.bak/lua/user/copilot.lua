local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
    return
end

-- disable suggestion as we use cmp instead
copilot.setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})
