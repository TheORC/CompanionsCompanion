--[[
    This class adds a wrapper around the storage method.
    This helps make saving and getting information easier.
]]

CC_SETTING_OPTIONS = {
    CHAT_NOTIFICATION   = "chat_notification",
    SCREEN_NOTIFICATION = "screen_notification",
    START_NOTIFICATION  = "start_notification",
    RESET_NOTIFICATION  = "reset_notification",
    SHOW_COUNTDOWN      = "show_countdown",
    RAPPORT_IN_CHAT     = "show_rapport_in_chat"
}


local dataVersion       = 1
local storageDefault    = {
    ["timers"] = {},
    ["settings"] = {
        [CC_SETTING_OPTIONS.CHAT_NOTIFICATION]   = true,
        [CC_SETTING_OPTIONS.SCREEN_NOTIFICATION] = true,
        [CC_SETTING_OPTIONS.START_NOTIFICATION]  = true,
        [CC_SETTING_OPTIONS.RESET_NOTIFICATION]  = false,
        [CC_SETTING_OPTIONS.SHOW_COUNTDOWN]      = true,
        [CC_SETTING_OPTIONS.RAPPORT_IN_CHAT]     = true,
    }
}

local CC_StorageManager = ZO_InitializingObject:Subclass()

---Load any stored data from the disk.
function CC_StorageManager:LoadData()
    self.storage = ZO_SavedVars:NewCharacterIdSettings("CompanionsCompanionVars", dataVersion, nil, storageDefault)
end

---Return the setting with the given name
---@param settingName string
---@return any
function CC_StorageManager:GetSetting(settingName)
    return self.storage["settings"][settingName]
end

---Set the value of a setting
---@param settingName string
---@param value any
function CC_StorageManager:SetSetting(settingName, value)
    self.storage["settings"][settingName] = value
end

---Get a list of the current active timers
---@return table
function CC_StorageManager:GetTimerList()
    return self.storage["timers"]
end

---Returns the stored timer with `timerId` or nil if it does not exist.
---@param timerId number
---@return table
function CC_StorageManager:GetTimer(timerId)
    return self.storage["timers"][timerId]
end

---Add the information of a new timer to the storage.  We store this here to ensure timers are
---persistant between logins.
---@param timerId number
---@param timerData table
function CC_StorageManager:AddTimer(timerId, timerData)
    local data = {
        interactionId = timerData.interactionId,
        companionId   = timerData.companionId,
        endTime       = timerData.endTime,
    }

    self.storage["timers"][timerId] = data
end

---This method reoves the timer with the specified id
---@param timerId number
function CC_StorageManager:RemoveTimer(timerId)
    self.storage["timers"][timerId] = nil
end

CC_STORAGE_MANAGER = CC_StorageManager:New()
