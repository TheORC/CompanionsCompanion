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
    VERSION      = "v2.3.0",
    AUTHOR       = "AnotherORC",
    CHAT_PREFIX  = "|cB759FF[CC]: |r",
    CHAT_VALUE   = "|cFFFFFF",
    CHAT_SUFFIX  = "|r",
}

---List of interactionId maped to their timerIds.
local INTERACTION_TIMERS = {}

---Gets the id of an active timer from it's registered event id.
---This method returns nil if no active timer is found.
---@param interactionId integer
---@return integer|nil
function CC_GetTimerId(interactionId)
    return INTERACTION_TIMERS[interactionId]
end

---Get the cooldown time of a rapport object from it's id in seconds.
---@param interactionId number
---@return number|nil
function CC_GetRapportTime(interactionId)
    -- Get the rapport data
    local interactionData = CC_COMPANION_DATA_MANAGER:GetRapportData(interactionId)

    -- Check we have data
    if interactionData == nil then return nil end

    -- Get the rapport time string
    local timeString = CC_Libs.is_array(interactionData.time) and interactionData.time[1] or interactionData.time

    -- Return the string converted to seconds
    return CC_Libs.CC_ConvertStringToSeconds(timeString)
end

--- This method starts a new timer for the rapport object with the provided id.
---@param interactionId number
function CC_StartRapportTimer(interactionId)
    -- Get seconds from lookup table
    local timeSeconds = CC_GetRapportTime(interactionId)
    local rapportData = CC_COMPANION_DATA_MANAGER:GetRapportData(interactionId)

    -- Chech that we have data
    if rapportData == nil or timeSeconds == nil then
        CC_Libs.m(GetString(CC_ERROR_START_TIMER), CC_SETTINGS.CHAT_VALUE)
        return
    end

    -- Get the current active companion
    local companionId = CC_Libs.GetCompanionId()

    -- Create data for a timer
    local timerData   = {
        interactionId = interactionId,
        companionId   = companionId,
        endTime       = timeSeconds + GetTimeStamp(),
        endCallback   = function()
            CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_FINISHED, interactionId, companionId)
        end,
        tickCallback  = function(timer)
            -- Still runing, tick
            CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_TICK, timer)
        end
    }

    -- Create the new timer test
    local timer       = CC_TIMER_MANAGER:CreateNewTimer(timerData)
    CC_STORAGE_MANAGER:AddTimer(timer:GetId(), timer:GetData())
    INTERACTION_TIMERS[interactionId] = timer:GetId()

    -- Send the start information to the chat
    if CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.START_NOTIFICATION) then
        -- Get the rapport description
        local rapportText = GetString(rapportData.text)

        -- Get the rapport time string
        local timeText    = CC_Libs.is_array(rapportData.time) and GetString(rapportData.time[1]) or
            GetString(rapportData.time)

        -- Send the message to the chat
        CC_Libs.m(zo_strformat(CC_CHAT_TIMER_START, rapportText, timeText), CC_SETTINGS.CHAT_VALUE)
    end
end

---Removes the timer object for the interaction id.
---@param interactionId any
function CC_RemoveInteractionTimer(interactionId)
    local timerId = INTERACTION_TIMERS[interactionId]
    CC_STORAGE_MANAGER:RemoveTimer(timerId)
    INTERACTION_TIMERS[interactionId] = nil
end

---Method called called when a companions rapport changes.
---@param _ nil
---@param companionId number
---@param previousRapport number
---@param currentRapport number
---@param adjustmentAmountType number
local function OnRapportUpdate(_, companionId, previousRapport, currentRapport, adjustmentAmountType)
    local isIncrease = currentRapport > previousRapport

    if CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.RAPPORT_IN_CHAT) then
        local message
        if isIncrease then
            message = GetString(CC_CHAT_GAINED_RAPPORT)
        else
            message = GetString(CC_CHAT_LOST_RAPPORT)
        end

        -- Calculate the change in rapport
        local rapportChange = math.abs(currentRapport - previousRapport)
        CC_Libs.m(zo_strformat(message, GetCompanionName(companionId), rapportChange), "|c959695")
    end
end

---This method is called when a timer finishes
---@param interactionId integer Id of the event which just finsihed
---@param companionId integer Id of companion whos rapport event this is
local function OnTimerFinished(interactionId, companionId)
    -- Get the event name from it's id
    local rapportData        = CC_COMPANION_DATA_MANAGER:GetRapportData(interactionId)
    local rapportDescription = GetString(rapportData.text)

    -- Get the name of the companion this event is for
    local name               = CC_Libs.GetCompanionName(companionId)
    if name == nil then return end

    -- Send a notification to the chat
    if CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.CHAT_NOTIFICATION) then
        CC_Libs.m(zo_strformat(CC_CHAT_TIMER_FINISH, rapportDescription, name), CC_SETTINGS.CHAT_VALUE)
    end

    -- Send a notification to the screen
    if CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.SCREEN_NOTIFICATION) then
        CC_NOTIFICATION_MANAGER:CreateTimerFinishedNotification(name, rapportDescription)
    end

    -- Make sure we remove the timer from storage
    CC_RemoveInteractionTimer(interactionId)
end

---This method initates and creates a dialog popup box which can be used to
---cancel timers.
local function CreateTimerResetDialog()
    -- Cancel accepted
    local function CommitReset(interactionId, timerId)
        local interactionText = CC_COMPANION_DATA_MANAGER:GetInteractionName(interactionId)

        -- Stop the timer
        CC_TIMER_MANAGER:StopTimer(timerId)

        -- Fire any events which are listening
        CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_CANCELED, interactionId)

        -- Output the cancel message to the chat
        if CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.RESET_NOTIFICATION) then
            CC_Libs.m(zo_strformat(CC_CHAT_TIMER_CANCEL, GetString(interactionText)), CC_SETTINGS.CHAT_VALUE)
        end

        -- Make sure we remove the timer from storage
        CC_RemoveInteractionTimer(interactionId)
    end

    local control = WINDOW_MANAGER:GetControlByName("CCResetDialog")
    ZO_Dialogs_RegisterCustomDialog("CC_RESET_TIMER_DIALOG",
        {
            customControl = control,
            title         = { text = GetString(CC_RESET_MODAL_TITLE) },
            buttons       =
            {
                {
                    control = GetControl(control, "Accept"),
                    text = SI_DIALOG_ACCEPT,
                    keybind = "DIALOG_PRIMARY",
                    callback = function(dialog)
                        local data = dialog.data
                        CommitReset(data.interactionId, data.timerId)
                    end,
                },
                {
                    control = GetControl(control, "Cancel"),
                    text = SI_DIALOG_CANCEL,
                    keybind = "DIALOG_NEGATIVE",
                    callback = function() end,
                },
            },
        })
end

---Creates and inserts the companion data frame.
local function CreateCompanionDataFrame()
    local companionKeyboard = COMPANION_KEYBOARD

    table.insert(companionKeyboard.iconData, {
        categoryName = CC_UI_RAPPORT_TITLE,
        descriptor   = "companionRapportKeyboard",
        normal       = "esoui/art/companion/keyboard/category_u30_rapport_up.dds",
        pressed      = "esoui/art/companion/keyboard/category_u30_rapport_down.dds",
        disabled     = "esoui/art/companion/keyboard/category_u30_rapport_up.dds",
        highlight    = "esoui/art/companion/keyboard/category_u30_rapport_over.dds",
        statusIcon   = function()
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

---Loads all stored timers and adds them to the timer manager.
local function LoadTimersFromStorage()
    local timers = CC_STORAGE_MANAGER:GetTimerList()

    for timerId, timerData in pairs(timers) do
        -- This is an old event.  We will need to remove it gracefully.
        if timerData.eventId ~= nil then
            CC_STORAGE_MANAGER:RemoveTimer(timerId)
        else
            local timer = {
                interactionId = timerData.interactionId,
                companionId   = timerData.companionId,
                endTime       = timerData.endTime,
                endCallBack   = function()
                    CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_FINISHED,
                        timerData.interactionId,
                        timerData.companionId)
                end,
                tickCallback  = function(timer)
                    -- Still runing, tick
                    CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_TICK, timer)
                end
            }

            -- Load the timer
            local restoredTimer = CC_TIMER_MANAGER:RestoreTimer(timerId, timer)
            INTERACTION_TIMERS[timerData.interactionId] = restoredTimer:GetId()
        end
    end
end

---This method os called when the addon is loadded for the first time
---@param _ nil
---@param name string
local function OnAddonLoad(_, name)
    -- Check if this is our addon
    if name ~= CC_SETTINGS.NAME then return end
    EVENT_MANAGER:UnregisterForEvent(CC_SETTINGS.NAME, EVENT_ADD_ON_LOADED)

    CC_STORAGE_MANAGER:LoadData() -- Load the stored data

    LoadTimersFromStorage()       -- Load the stored timers
    CC_CreateAddonMenu()          -- Add the settings menu
    CreateTimerResetDialog()      -- Creates the dialog presented when a timer is canceled
    CreateCompanionDataFrame()    -- Create PC companion data frame

    -- Register a listener for rapport timer finishing
    CC_COMPANION_CALLBACK_MANAGER:RegisterCallback(CC_TIMER_EVENTS.CC_TIMER_FINISHED, OnTimerFinished)
    EVENT_MANAGER:RegisterForEvent(CC_SETTINGS.NAME, EVENT_COMPANION_RAPPORT_UPDATE, OnRapportUpdate)
end

EVENT_MANAGER:RegisterForEvent(CC_SETTINGS.NAME, EVENT_ADD_ON_LOADED, OnAddonLoad)
