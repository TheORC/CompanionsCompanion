--[[
    This class contains a list of events and their respective id's
    This is used to store timers as the string id is not the same
    after a ui reload or a log out and in.
]]

--[[
    Keep track of different event types
]]
CC_TIMER_EVENTS = {
  CC_TIMER_FINISHED = "CC_TIMER_FINISHED",
  CC_TIMER_TICK     = "CC_TIMER_TICK",
  CC_TIMER_CANCELED = "CC_TIMER_CANCELED",
}

--[[
  Create a callback object

  This will be used for calling the timer on end events
]]
local CCEventManager = ZO_CallbackObject:Subclass()

function CCEventManager:New(...)
  local eventManager = ZO_CallbackObject.New(self)
  eventManager:Initialize(...)
  return eventManager
end

function CCEventManager:Initialize()
  self.updateEvents = {}
end

-- Create an event manager for us
CC_COMPANION_CALLBACK_MANAGER = CCEventManager:New()
