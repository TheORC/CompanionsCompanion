--[[
    Defines useful library functions which are needed
    in other classes.
]]
CC_Libs = {}

--[[

]]
function CC_Libs.is_array(t)
    if t == 0 or type(t) == "number" then return false end

    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

--[[
    Method used for outputting messages to the chat
]]
function CC_Libs.m(value, chatColor)
    local output = {}

    table.insert(output, CC_SETTINGS.CHAT_PREFIX)
    table.insert(output, chatColor)
    table.insert(output, value)
    table.insert(output, CC_SETTINGS.CHAT_SUFFIX)

    d(table.concat(output, ""))
end

--- Gets the current active companions id, or 0 if none are summoned.
---@return integer
function CC_Libs.GetCompanionId()
    local activeId = GetActiveCompanionDefId()
    return GetCompanionCollectibleId(activeId)
end

--- Returns the name of the comapnion with the provided id
---@param companionId integer
---@return string|nil
function CC_Libs.GetCompanionName(companionId)
    local companionData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(companionId)
    if companionData == nil then return nil end
    return companionData:GetFormattedName()
end

--[[
    Converts seconds in to text friedly format
]]
function CC_Libs.SecondsToReadibleFormat(seconds)
    local timeMinutes = seconds / 60
    local timeHours   = timeMinutes / 60
    local isMinutes   = timeMinutes < 50

    local abbString   = ZO_AbbreviateAndLocalizeNumber(isMinutes and timeMinutes or timeHours, 0, false)
    local timeUnit    = GetString(isMinutes and CC_TIME_MINUTES or CC_TIME_HOURS)

    return zo_strformat(CC_TIME_STRING, abbString, timeUnit)
end

----------------------------------
-- Timer text second data
---------------------------------
local CC_TIME_TABLE = {
    [CC_2_MINUTES]                         = 120,
    [CC_3_MINUTES]                         = 180,
    [CC_5_MINUTES]                         = 300,
    [CC_10_MINUTES]                        = 600,
    [CC_15_MINUTES]                        = 900,
    [CC_30_MINUTES]                        = 1800,
    [CC_1_HOUR]                            = 3600,
    [CC_2_HOURS]                           = 7200,
    [CC_20_HOURS]                          = 72000,
    [CC_FIRST_TIME]                        = 0,
    [CC_OTHER_TIMES]                       = 0,
    [CC_NO_COOLDOWN]                       = 0,
    [CC_OFF_COOLDOWN]                      = 0,
    [CC_DURING_COOLDOWN]                   = 0,
    [CC_SHARED_COOLDOWN]                   = 0,
    [CC_ONCE_PER_PERSONAL_QUEST]           = 0,
    [CC_SHARED_ISOBEL_EMBER_QUEST_RAPPORT] = 0,
    [CC_SHARED_BASTIAN_MIRRI]              = 0,
    [CC_UNKNOWN_TIME]                      = 0,
}

--[[
    TODO: Remove this from here.
    Returns the number of seconds
]]
function CC_Libs.CC_ConvertStringToSeconds(timerId)
    return CC_TIME_TABLE[timerId]
end
