--[[
  This file handles setting menu behaviour and functionality.
]]

local LAM2 = LibAddonMenu2

local optionsData = {
  {
    type = "header",
    name = GetString(CC_SETTINGS_TITLE),
  },
  {
    type  = "description",
    text  = GetString(CC_SETTINGS_MENU_DESCRIPTION),
    width = "full",
  },
  {
    type = "header",
    name = GetString(CC_SETTINGS_NOTIFICATION_SECTION),
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_CHAT_REMINDER_NAME),
    tooltip = GetString(CC_SETTINGS_CHAT_REMINDER_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_NOTIFICATION_NAME),
    tooltip = GetString(CC_SETTINGS_NOTIFICATION_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION, value) end,
  },
  {
    type = "header",
    name = GetString(CC_SETTINGS_OTHER_SECTION),
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_OTHER_TIMER_S_NAME),
    tooltip = GetString(CC_SETTINGS_OTHER_TIMER_S_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_OTHER_TIMER_R_NAME),
    tooltip = GetString(CC_SETTINGS_OTHER_TIMER_R_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION, value) end,
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_OTHER_COUNTDOWN_NAME),
    tooltip = GetString(CC_SETTINGS_OTHER_COUNTDOWN_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.SHOW_COUNTDOWN) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.SHOW_COUNTDOWN, value) end,
  },
  {
    type    = "checkbox",
    name    = GetString(CC_SETTINGS_OTHER_RAPPORT_IN_CHAT_NAME),
    tooltip = GetString(CC_SETTINGS_OTHER_RAPPORT_IN_CHAT_TOOLTIP),
    getFunc = function() return CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.RAPPORT_IN_CHAT) end,
    setFunc = function(value) CC_STORAGE_MANAGER:SetSetting(CC_SETTING_OPTIONS.RAPPORT_IN_CHAT, value) end,
  },
}

---Creates the menu to display the addons settings.
function CC_CreateAddonMenu()
  local panelData = {
    type    = "panel",
    name    = CC_SETTINGS.DISPLAY_NAME,
    author  = CC_SETTINGS.AUTHOR,
    version = CC_SETTINGS.VERSION,
  }

  LAM2:RegisterAddonPanel("CompanionsCompacionsOptions", panelData)
  LAM2:RegisterOptionControls("CompanionsCompacionsOptions", optionsData)
end
