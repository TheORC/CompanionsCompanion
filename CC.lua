---
--- @author: AnotherORC
---
--- Companion's Companion provides addintional information about your companions.
--- This is provided through an extra tab avaliable in the companion overview
--- screen.
---     Features:
---         - Rapport information (good/bad)
---         - Alert reminders
---

local CC = {}

CC_SETTINGS = {
    NAME         = "CompanionsCompanion",
    DISPLAY_NAME = "Companions Companion",
    VERSION      = "v2.1.1",
    AUTHOR       = "AnotherORC",
    CHAT_PREFIX  = "|cB759FF[CC]: |cFFFFFF",
    CHAT_SUFFIX  = "|r",
}

--- Get the cooldown time of a rapport object from it's id in seconds.
---@param rapportId number
---@return number|nil
function CC_GetRapportTime(rapportId)
    -- Get the rapport data
    local companionData = CC_GetRapportFromId(rapportId)

    -- Check we have data
    if companionData == nil then return nil end

    -- Get the rapport time string
    local timeString = CC_Libs.is_array(companionData.time) and companionData.time[1] or companionData.time

    -- Return the string converted to seconds
    return CC_Libs.CC_ConvertStringToSeconds(timeString)
end

--- This method starts a new timer for the rapport object with the provided id.
---@param rapportId number
function CC_StartRapportTimer(rapportId)

    -- Get seconds from lookup table
    local timeSeconds = CC_GetRapportTime(rapportId)
    local rapportData = CC_GetRapportFromId(rapportId)

    -- Chech that we have data
    if rapportData == nil or timeSeconds == nil then
        CC_Libs.m(GetString(CC_ERROR_START_TIMER))
        return
    end

    -- We will use the id of the string for the event id
    local eventId     = CC_GetRapportEventID(rapportData)
    local companionId = CC_Libs.GetCompanionId()

    -- Create data for a timer
    local timerData = {
        eventId     = eventId,
        companionId = companionId,
        endTime     = timeSeconds +  GetTimeStamp(),
        endCallBack = function()
            CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_FINISHED, eventId, companionId)
        end,
    }

    -- Create the new timer test
    CC_TIME_MANAGER:CreateNewTimer(timerData)

    -- Send the start information to the chat
    if CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION) then

        -- Get the rapport description
        local rapportText = GetString(rapportData.text)

        -- Get the rapport time string
        local timeText    = CC_Libs.is_array(rapportData.time) and GetString(rapportData.time[1]) or GetString(rapportData.time)

        -- Send the message to the chat
        CC_Libs.m(zo_strformat(CC_CHAT_TIMER_START, rapportText, timeText))
    end
end


---Gets the id of an active timer from it's registered event id.
---This method returns nil if no active timer is found.
---@param eventId integer
---@return integer|nil
function CC_GetTimerId(eventId)

    -- Loop through all the active timers
    for timerId, timer in pairs(CC_TIME_MANAGER:GetTimerList()) do

        -- Check to see if this timer is for the provided event
        if timer:GetData().eventId == eventId then

            -- Return the timer
            return timerId
        end
    end
    return nil
end

--- This method is called when a timer finishes
---@param eventId integer Id of the event which just finsihed
---@param companionId integer Id of companion whos rapport event this is
function CC.OnTimerFinished(eventId, companionId)

    -- Get the event name from it's id
    local eventName          = CC_RapportEventName(eventId)
    local rapportDescription = GetString(eventName)
    
    -- Get the name of the companion this event is for
    local name = CC_Libs.GetCompanionName(companionId)
    if name == nil then return end

    -- Send a notification to the chat
    if CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION) then
        CC_Libs.m(zo_strformat(CC_CHAT_TIMER_FINISH, rapportDescription, name))
    end

    -- Send a notification to the screen
    if CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION) then
        CC_NOTIFICATION_MANAGER:CreateTimerFinished(name, rapportDescription)
    end
end

--- This method initates and creates a dialog popup box which can be used to 
-- cancel timers.
function CC.InitResetDialog()

    -- Cancel accepted
    local function CommitReset(eventId, timerId)

        -- Get the timer data
        local timer     = CC_DATA_MANAGER:GetTimer(timerId)
        local eventName = CC_RapportEventName(timer.eventId)

        -- Stop the timer
        CC_TIME_MANAGER:StopTimer(timerId)

        -- Fire any events which are listening
        CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_CANCELED, eventId)

        -- Output the cancel message to the chat
        if CC_DATA_MANAGER:GetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION) then
            CC_Libs.m(zo_strformat(CC_CHAT_TIMER_CANCEL, GetString(eventName)))
        end
    end

    local control = WINDOW_MANAGER:GetControlByName("CCResetDialog")
    ZO_Dialogs_RegisterCustomDialog("CC_RESET_TIMER_DIALOG",
    {
      customControl  = control,
      title = { text = GetString(CC_RESET_MODAL_TITLE) },
      buttons =
      {
          {
            control =   GetControl(control, "Accept"),
            text =      SI_DIALOG_ACCEPT,
            keybind =   "DIALOG_PRIMARY",
            callback =  function(dialog)
                local data = dialog.data
                CommitReset(data.eventId, data.timerId)
            end,
          },
          {
              control =   GetControl(control, "Cancel"),
              text =      SI_DIALOG_CANCEL,
              keybind =   "DIALOG_NEGATIVE",
              callback =  function() end,
          },
        },
    })
end

--- This method is called to create the information panel in the
--- companion overview window.
function CC.InitiateAddon()

    local companionKeyboard = COMPANION_KEYBOARD

    table.insert(companionKeyboard.iconData, {
        categoryName = CC_UI_RAPPORT_TITLE,
        descriptor   = "companionRapportKeyboard",
        normal       = "esoui/art/companion/keyboard/category_u30_rapport_up.dds",
        pressed      = "esoui/art/companion/keyboard/category_u30_rapport_down.dds",
        disabled     = "esoui/art/companion/keyboard/category_u30_rapport_up.dds",
        highlight    = "esoui/art/companion/keyboard/category_u30_rapport_over.dds",
        statusIcon = function()
            return false
        end,
    })

    companionKeyboard.tabs:CreateSceneGroup("companionSceneGroup", companionKeyboard.iconData)

    -- Companion rapport scene/fragment
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(COMPANION_PROGRESS_BAR_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(FRAME_INTERACTION_STANDARD_RIGHT_PANEL_MEDIUM_LEFT_PANEL_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(TREE_UNDERLAY_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(TITLE_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(COMPANION_MENU_PREVIEW_OPTIONS_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(ITEM_PREVIEW_KEYBOARD:GetFragment())
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(COMPANION_TITLE_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(COMPANION_KEYBOARD_FRAGMENT)
    COMPANION_RAPPORT_KEYBOARD_SCENE:AddFragment(COMPANION_RAPPORT_KEYBOARD_FRAGMENT)
end

--- This method os called when the addon is loadded for the first time
---@param _ nil
---@param name string
function CC.OnAddonLoad(_, name)

    -- Check if this is our addon
    if name ~= CC_SETTINGS.NAME then return end
    EVENT_MANAGER:UnregisterForEvent(CC_SETTINGS.NAME, EVENT_ADD_ON_LOADED) -- Stop listening

    -- Load the required data
    CC_DATA_MANAGER:LoadData()
    CC_TIME_MANAGER:LoadTimersFromStorage()

    CC_NOTIFICATION_MANAGER:Hook()

    -- Setup the addon panels
    CC.InitResetDialog()
    CC.InitiateAddon()

    -- Add the settings menu
    CC_CreateAddonMenu()
end

EVENT_MANAGER:RegisterForEvent(CC_SETTINGS.NAME, EVENT_ADD_ON_LOADED, CC.OnAddonLoad)
CC_COMPANION_CALLBACK_MANAGER:RegisterCallback(CC_TIMER_EVENTS.CC_TIMER_FINISHED, CC.OnTimerFinished)
