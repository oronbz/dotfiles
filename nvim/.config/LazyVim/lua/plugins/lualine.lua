local function xcodebuild_device()
    if vim.g.xcodebuild_platform == "macOS" then
        return " macOS"
    end

    local deviceIcon = ""
    if vim.g.xcodebuild_platform:match("watch") then
        deviceIcon = "􀟤"
    elseif vim.g.xcodebuild_platform:match("tv") then
        deviceIcon = "􀡴 "
    elseif vim.g.xcodebuild_platform:match("vision") then
        deviceIcon = "􁎖 "
    end

    if vim.g.xcodebuild_os then
        return deviceIcon .. " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
    end

    return deviceIcon .. " " .. vim.g.xcodebuild_device_name
end

local function folder_exists(path)
  -- vim.loop.fs_stat returns (stats, err)
  local stats = vim.loop.fs_stat(path)
  -- If stats is not nil, the path exists. We then check if it's a directory.
  if stats and stats.type == 'directory' then
    return true
  end
  return false
end

-- local is_configured = require('xcodebuild.project.config').is_configured()
local nvim_folder_exists = folder_exists(".nvim/xcodebuild")

-- vim.notify(nvim_folder_exists)
-- vim.notify(is_configured)
if nvim_folder_exists == false then return {} end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        sections = {
            lualine_x = {
                { "' ' .. vim.g.xcodebuild_last_status", color = { fg = "Gray" } },
                { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
                { "'  ' .. vim.g.xcodebuild_scheme", color = { fg ="#f9e2af", bg = "#161622", }},
                { xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
            }
        }
    }
}

