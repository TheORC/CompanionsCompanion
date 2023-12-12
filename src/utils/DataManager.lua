--[[
    This class adds a wrapper around the storage method.
    This helps make saving and getting information easier.
]]

CC_SETTING_OPTIONS = {
    CHAT_NOTIFICATION   = "chat_notification",
    SCREEN_NOTIFICATION = "screen_notification",
    START_NOTIFICATION  = "start_notification",
    RESET_NOTIFICATION  = "reset_notification",
    SHOW_COUNTDOWN      = "show_countdown"
}


local dataVersion    = 1
local storageDefault = {
    ["timers"] = {},
    ["settings"] = {
        [CC_SETTING_OPTIONS.CHAT_NOTIFICATION]   = true,
        [CC_SETTING_OPTIONS.SCREEN_NOTIFICATION] = true,
        [CC_SETTING_OPTIONS.START_NOTIFICATION]  = true,
        [CC_SETTING_OPTIONS.RESET_NOTIFICATION]  = false,
        [CC_SETTING_OPTIONS.SHOW_COUNTDOWN]      = true,
    }
}

local CC_DataManager = ZO_InitializingObject:Subclass()

function CC_DataManager:LoadData()
    self.storage = ZO_SavedVars:NewCharacterIdSettings("CompanionsCompanionVars", dataVersion, nil, storageDefault)
end

--[[
    Return the setting with the given name
]]
function CC_DataManager:GetSetting(settingName)
    return self.storage["settings"][settingName]
end

--[[
    Set the value of a setting
]]
function CC_DataManager:SetSetting(settingName, value)
    self.storage["settings"][settingName] = value
end

--[[
    Get a list of the current active timers
]]
function CC_DataManager:GetTimerList()
    return self.storage["timers"]
end

--[[
    Returns the stored timer with `timerId` or
    nil if it does not exist.
]]
function CC_DataManager:GetTimer(timerId)
    return self.storage["timers"][timerId]
end

--[[
    Add the information of a new timer to the storage
    We store this here to ensure timers are persistant
    between logins.
]]
function CC_DataManager:AddTimer(timerId, timerData)

    local data = {
        eventId     = timerData.eventId,
        companionId = timerData.companionId,
        endTime     = timerData.endTime,
    }

    self.storage["timers"][timerId] = data
end

--[[
    This method reoves the timer with the specified id
]]
function CC_DataManager:RemoveTimer(timerId)
    self.storage["timers"][timerId] = nil
end

CC_DATA_MANAGER = CC_DataManager:New()