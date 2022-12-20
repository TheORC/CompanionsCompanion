CC_SCA_NOTIFICATION = {
    CC_TIMER_FINISHED = "CC_TIMER_FINISHED",
    CC_TIMER_START    = "CC_TIMER_START",
}

local NotificationManager = ZO_InitializingObject:Subclass()

function NotificationManager:Initialize()

end

function NotificationManager:Hook()
    -- CENTER_SCREEN_ANNOUNCE
    for _, value in pairs(CC_SCA_NOTIFICATION) do
        ZO_CenterScreenAnnounce_SetPriority(value)
    end
end

function NotificationManager:CreateTimerFinished(companionName, output)

    local primaryMessage   = zo_strformat(CC_NOTIFICATION_TIMER_FINISH_MAIN, companionName)
    local secondaryMessage = zo_strformat(CC_NOTIFICATION_TIMER_FINISH_SECOND, output)

    local params = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
    params:SetCSAType(CC_SCA_NOTIFICATION.CC_TIMER_FINISHED)
    params:SetSound(SOUNDS.JUSTICE_NO_LONGER_KOS)
    params:SetText(primaryMessage, secondaryMessage)
    CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(params)
end

function NotificationManager:CreateTimerStarted(primaryMessage, secondaryMessage)
    local params = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT)
    params:SetCSAType(CC_SCA_NOTIFICATION.CC_TIMER_FINISHED)
end

CC_NOTIFICATION_MANAGER = NotificationManager:New()