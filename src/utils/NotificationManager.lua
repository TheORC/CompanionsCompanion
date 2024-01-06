CC_SCA_NOTIFICATION = {
    CC_TIMER_FINISHED = "CC_TIMER_FINISHED",
    CC_TIMER_START    = "CC_TIMER_START",
}

---Register our custom announcements.
local function HookScreenNotifications()
    -- CENTER_SCREEN_ANNOUNCE
    for _, value in pairs(CC_SCA_NOTIFICATION) do
        ZO_CenterScreenAnnounce_SetPriority(value)
    end
end

local NotificationManager = ZO_InitializingObject:Subclass()

function NotificationManager:Initialize()
    HookScreenNotifications()
end

---Create and queue a new timer finished notification.  The notification is added to the queue and
---will display at the next free time.
---@param companionName string
---@param output string
function NotificationManager:CreateTimerFinishedNotification(companionName, output)
    local primaryMessage   = zo_strformat(CC_NOTIFICATION_TIMER_FINISH_MAIN, companionName)
    local secondaryMessage = zo_strformat(CC_NOTIFICATION_TIMER_FINISH_SECOND, output)
    local params           = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)

    params:SetCSAType(CC_SCA_NOTIFICATION.CC_TIMER_FINISHED)
    params:SetSound(SOUNDS.JUSTICE_NO_LONGER_KOS)
    params:SetText(primaryMessage, secondaryMessage)

    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(params)
end

---Create and queue a new timer started notification.  The notification is added to the queue and
---will display at the next free time.
---@param primaryMessage any
---@param secondaryMessage any
function NotificationManager:CreateTimerStartedNotification(primaryMessage, secondaryMessage)
    local params = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
    params:SetCSAType(CC_SCA_NOTIFICATION.CC_TIMER_FINISHED)
end

CC_NOTIFICATION_MANAGER = NotificationManager:New()
