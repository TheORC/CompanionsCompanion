---This class contains information regarding the cooldown of different rapport timers
---@class CC_TimerManager
local CC_TimerManager = ZO_InitializingObject:Subclass()

---Initialize the timer manager state
function CC_TimerManager:Initialize()
  self.m_timers = {}
  self.m_running = false
end

---Start all the timers
function CC_TimerManager:Start()
  if self.m_running ~= false then return end
  EVENT_MANAGER:RegisterForUpdate("CC_Timer_Loop_Update", 1000, function() self:UpdateTimers() end)
end

---Stop all the timers
function CC_TimerManager:Stop()
  if self.m_running ~= true then return end
  EVENT_MANAGER:UnregisterForUpdate("CC_Timer_Loop_Update", 1000, function() self:UpdateTimers() end)
end

---This method allows you to restore a timer that may have been saved to storage.
---@param timerId number
---@param timerData table custom data to associate with this timer
---@return CC_Timer
function CC_TimerManager:RestoreTimer(timerId, timerData)
  -- Create the timer
  local newTimer = CC_Timer:New(timerId, timerData)

  -- Add timer to manager
  self.m_timers[timerId] = newTimer

  -- Check to see if there are any timers.
  if self.m_running == false then
    self:Start()
  end

  return newTimer
end

---Method for creating a new timer instance
---@param timerData table custom data to associate with this timer
---@return CC_Timer
function CC_TimerManager:CreateNewTimer(timerData)
  -- Create timer
  local timerId          = self:GetNewId()
  local newTimer         = CC_Timer:New(timerId, timerData)

  -- Add timer to manager
  self.m_timers[timerId] = newTimer

  -- Check to see if there are any timers.
  if self.m_running == false then
    self:Start()
  end

  return newTimer
end

---This method is called with a timer id and is used when a timer should be removed
---@param timerId number
function CC_TimerManager:StopTimer(timerId)
  if self.m_timers[timerId] == nil then return end
  self:CleanUpTimer(timerId)
end

--- This method is called every second and updates all the existing timers.
function CC_TimerManager:UpdateTimers()
  for _, timer in pairs(self.m_timers) do
    -- Update timer
    timer:UpdateTimer()

    -- Check if it has finsihed
    if timer:HasFinished() then
      self:CleanUpTimer(timer:GetId())
      return
    end

    timer:OnTick()
  end
end

---This method takes a timer id and if it exists, removes it.
---@param timerId number
function CC_TimerManager:CleanUpTimer(timerId)
  if self.m_timers[timerId] == nil then return end
  self.m_timers[timerId] = nil

  -- We have no more running timers, stop the clock
  if #self.m_timers == 0 then
    self:Stop()
  end
end

---Returns an unsued timer id
---@return integer
function CC_TimerManager:GetNewId()
  local id = 1

  -- Loop through the stored ids until we get a free slot
  while self.m_timers[id] ~= nil do id = id + 1 end
  return id
end

---Returns a timer object from it's id
---@param timerId number
---@return CC_Timer
function CC_TimerManager:GetTimer(timerId)
  return self.m_timers[timerId];
end

---Returns the list of all timers.
---@return table
function CC_TimerManager:GetTimerList()
  return self.m_timers
end

-- Create an instance of our manager
CC_TIMER_MANAGER = CC_TimerManager:New()
