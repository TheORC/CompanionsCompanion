
--[[
  This file handles setting menu behaviour and functionality.
]]

local LAM2 = LibAddonMenu2

local panelData = {
    type    = "panel",
    name    = CC_SETTINGS.DISPLAY_NAME,
    author  = CC_SETTINGS.AUTHOR,
    version = CC_SETTINGS.VERSION,
}

local optionsData = {
  {
    type = "header",
    name = "About",
  },
  {
    type = "description",
    text = "This addon adds rapport information to the companion overview screen.  It also adds notification timers which when set will notify you after the allotted time.\n\nThanks to @NextTuesday for help with the English translation.  PM me if you would like to see this addon support your own language.",
    width = "full",
  },
  {
    type = "header",
    name = "Notification Options",
  },
  {
    type    = "checkbox",
    name    = "Send reminder to chat",
    tooltip = "Should the reminder be sent to your chat box?",
    getFunc = function() return CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION) end,
    setFunc = function(value)   CC_DATA_MANAGER:SetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = "Send reminder to screen",
    tooltip = "Should the reminder popup on your screen?",
    getFunc = function() return CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION) end,
    setFunc = function(value)   CC_DATA_MANAGER:SetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION, value) end,
  },
  {
    type = "header",
    name = "Other Options",
  },
  {
    type    = "checkbox",
    name    = "Notify on timer start",
    tooltip = "When you start a timer, should a message be sent to your chat?",
    getFunc = function() return CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION) end,
    setFunc = function(value)   CC_DATA_MANAGER:SetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = "Notify on timer reset",
    tooltip = "When you reset a timer, should a message be sent to your chat?",
    getFunc = function() return CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION) end,
    setFunc = function(value)   CC_DATA_MANAGER:SetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = "Show countdowns",
    tooltip = "Shows the time remaining before a notification.",
    getFunc = function() return CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.SHOW_COUNTDOWN) end,
    setFunc = function(value)   CC_DATA_MANAGER:SetSetting(CC_SETTING_OPTIONS.SHOW_COUNTDOWN, value) end,
  },
}

function CC_CreateAddonMenu()
  LAM2:RegisterAddonPanel("CompanionsCompacionsOptions", panelData)
  LAM2:RegisterOptionControls("CompanionsCompacionsOptions", optionsData)
end