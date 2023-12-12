--[[
    This class contains information regarding the cooldown of
    different rapport timers
]]

local CC_TimeManager = ZO_InitializingObject:Subclass()

function CC_TimeManager:Initialize()
    self.m_timers = {}
    self.m_running = false
end

--[[
    Calling this method will setup the timer manager
    It will load timers from storage and then start them
]]
function CC_TimeManager:LoadManager()
    self.m_timers = {}
    self.m_running = false

    self:LoadTimersFromStorage()
    self:Start()
end

--[[
    Start our listener
]]
function CC_TimeManager:Start()
    if self.m_running ~= false then return end
    EVENT_MANAGER:RegisterForUpdate("CC_Timer_Loop_Update", 1000,  function() self:UpdateTimers() end)
end

--[[
    Stop our listener
]]
function CC_TimeManager:Stop()
    if self.m_running ~= true then return end
    EVENT_MANAGER:UnregisterForUpdate("CC_Timer_Loop_Update", 1000,  function() self:UpdateTimers() end)
end

function CC_TimeManager:LoadTimersFromStorage()
   local timers = CC_DATA_MANAGER:GetTimerList()

    for timerId, timer in pairs(timers) do
        local timerData = {
            eventId     =  timer.eventId,
            companionId = timer.companionId,
            endTime     = timer.endTime,
            endCallBack = function()
                CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_FINISHED, timer.eventId, timer.companionId)
            end,
        }

        -- Load the timer
        self:LoadTimer(timerId, timerData)
    end
end

--[[
    This method loads and starts a timer which was in stored data
]]
function CC_TimeManager:LoadTimer(timerId, timerData)
    
    -- Create the timer
    local newTimer = CC_Timer:New(timerId, timerData)

    -- Add timer to manager
    self.m_timers[timerId] = newTimer

    -- Check to see if there are any timers.
    if self.m_running == false then
        self:Start()
    end
end

--[[
    Method for creating a new timer instance
]]
function CC_TimeManager:CreateNewTimer(timerData)

    -- Create timer
    local timerId  = self:GetNewId()
    local newTimer = CC_Timer:New(timerId, timerData)

    -- Add timer to manager
    self.m_timers[timerId] = newTimer

    -- Store timer
    CC_DATA_MANAGER:AddTimer(timerId, timerData)

    -- Check to see if there are any timers.
    if self.m_running == false then
        self:Start()
    end
end

--[[
    This method is called with a timer id and is used
    when a timer should be removed
]]
function CC_TimeManager:StopTimer(timerId)
    if self.m_timers[timerId] == nil then return end
    self:CleanUpTimer(timerId)
end

--[[
    This method is called every second and updates all the existing
    timers.
]]
function CC_TimeManager:UpdateTimers()
    for _, timer in pairs(self.m_timers) do
    
        -- Update timer
        timer:UpdateTimer()

        -- Check if it has finsihed
        if timer:HasFinished() then
            self:CleanUpTimer(timer:GetId())
            return
        end

        -- Still runing, tick
        CC_COMPANION_CALLBACK_MANAGER:FireCallbacks(CC_TIMER_EVENTS.CC_TIMER_TICK, timer)
    end
end

--[[
    This method takes a timer id and if it exists,
    removes it.
]]
function CC_TimeManager:CleanUpTimer(timerId)
    if self.m_timers[timerId] == nil then return end

    self.m_timers[timerId] = nil
    CC_DATA_MANAGER:RemoveTimer(timerId)

    -- We have no more running timers, stop the clock
    if #self.m_timers == 0 then
        self:Stop()
    end
end

--[[
    Returns an unsued timer id
]]
function CC_TimeManager:GetNewId()
    local id = 1

    -- Loop through the stored ids until we get a free slot
    while CC_DATA_MANAGER:GetTimer(id) ~= nil do id = id + 1 end
    return id
end

--[[
    Returns a timer object from it's id
]]
function CC_TimeManager:GetTimer(timerId)
    return self.m_timers[timerId];
end

function CC_TimeManager:GetTimerList()
    return self.m_timers
end

-- Create an instance of our manager
CC_TIME_MANAGER = CC_TimeManager:New()