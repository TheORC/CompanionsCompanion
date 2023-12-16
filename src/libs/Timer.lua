---Class contraining a timer structure to keep track of a
---target time in the future.
---@class CC_Timer
CC_Timer = ZO_InitializingObject:Subclass()

---A timer is initialised with a data object containing information
---used during its running
---
---data = {
---    endTime: 100,
---    endCallback: function() end
---    tickCallback: function(timer) end
---}
function CC_Timer:Initialize(id, data)
    self.m_id = id
    self.m_data = data
    self.m_remainingTime = 10 -- We set to some time in the future
end

---Is called to update the timer
function CC_Timer:UpdateTimer()
    -- We only care if this has not finished
    if self:HasFinished() == true then return end

    local currentTime = GetTimeStamp()
    self.m_remainingTime = GetDiffBetweenTimeStamps(self.m_data.endTime, currentTime)

    -- Check to see if time is up
    if self.m_remainingTime <= 0 then
        self:OnFinished()
    end
end

---Is called when the timer has finished
function CC_Timer:OnFinished()
    if self.m_data.endCallback ~= nil then
        self.m_data.endCallback()
    end
end

---Is called when the timer is ticked
function CC_Timer:OnTick()
    if self.m_data.tickCallback ~= nil then
        self.m_data.tickCallback(self)
    end
end

---Returns the remaining time of the timer
function CC_Timer:GetRemainingTime()
    return self.m_remainingTime
end

---Returns if the timer has finsihed
function CC_Timer:HasFinished()
    return self.m_remainingTime <= 0
end

---Returns this timers id
function CC_Timer:GetId()
    return self.m_id
end

---Returns the stored data on this timer
function CC_Timer:GetData()
    return self.m_data
end
