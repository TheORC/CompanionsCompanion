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
  Each rapport event requires a unique id
]]
local CC_RAPPORT_EVENTS = {
  [CC_SHARED_COMPLETE_PERSONAL_QUEST]    = 1,
  [CC_SHARED_DARK_BROTHERHOOD]           = 2,
  [CC_SHARED_USE_BLADE_OF_WOE_NPC]       = 3,
  [CC_SHARED_COMPLETE_MAGES_DAILY]       = 4,
  [CC_SHARED_LOOTING_PSIJIC_PORTAL]      = 5,
  [CC_GOOD_ISOBEL_TEXT_2]                = 6,
  [CC_GOOD_ISOBEL_TEXT_3]                = 7,
  [CC_GOOD_ISOBEL_TEXT_4]                = 8,
  [CC_GOOD_ISOBEL_TEXT_6]                = 9,
  [CC_GOOD_ISOBEL_TEXT_7]                = 10,
  [CC_GOOD_ISOBEL_TEXT_8]                = 11,
  [CC_GOOD_ISOBEL_TEXT_9]                = 12,
  [CC_GOOD_ISOBEL_TEXT_10]               = 13,
  [CC_GOOD_ISOBEL_TEXT_11]               = 14,
  [CC_GOOD_ISOBEL_TEXT_12]               = 15,
  [CC_GOOD_ISOBEL_TEXT_13]               = 16,
  [CC_GOOD_ISOBEL_TEXT_14]               = 17,
  [CC_GOOD_ISOBEL_TEXT_15]               = 18, -- 6:00 -- 7:00
  [CC_GOOD_ISOBEL_TEXT_16]               = 19,
  [CC_GOOD_ISOBEL_TEXT_17]               = 20,
  [CC_GOOD_ISOBEL_TEXT_18]               = 21,
  [CC_BAD_ISOBEL_TEXT_1]                 = 22,
  [CC_BAD_ISOBEL_TEXT_2]                 = 23,
  [CC_BAD_ISOBEL_TEXT_3]                 = 24,
  [CC_GOOD_BASTIAN_TEXT_2]               = 25,
  [CC_GOOD_BASTIAN_TEXT_3]               = 26,
  [CC_GOOD_BASTIAN_TEXT_4]               = 27,
  [CC_GOOD_BASTIAN_TEXT_6]               = 28,
  [CC_GOOD_BASTIAN_TEXT_7]               = 29,
  [CC_GOOD_BASTIAN_TEXT_8]               = 30,
  [CC_GOOD_BASTIAN_TEXT_9]               = 31,
  [CC_GOOD_BASTIAN_TEXT_10]              = 32,
  [CC_GOOD_BASTIAN_TEXT_12]              = 33,
  [CC_BAD_BASTIAN_TEXT_3]                = 34,
  [CC_BAD_BASTIAN_TEXT_4]                = 35,
  [CC_BAD_BASTIAN_TEXT_5]                = 36,
  [CC_BAD_BASTIAN_TEXT_6]                = 37,
  [CC_BAD_BASTIAN_TEXT_7]                = 38,
  [CC_BAD_BASTIAN_TEXT_8]                = 39,
  [CC_BAD_BASTIAN_TEXT_9]                = 40,
  [CC_BAD_BASTIAN_TEXT_10]               = 41, -- >1 hour
  [CC_GOOD_MIRRI_TEXT_1]                 = 42,
  [CC_GOOD_MIRRI_TEXT_2]                 = 43,
  [CC_GOOD_MIRRI_TEXT_3]                 = 44,
  [CC_GOOD_MIRRI_TEXT_4]                 = 45,
  [CC_GOOD_MIRRI_TEXT_5]                 = 46,
  [CC_GOOD_MIRRI_TEXT_6]                 = 47,
  [CC_GOOD_MIRRI_TEXT_7]                 = 48,
  [CC_GOOD_MIRRI_TEXT_9]                 = 49,
  [CC_GOOD_MIRRI_TEXT_10]                = 50,
  [CC_GOOD_MIRRI_TEXT_11]                = 51,
  [CC_GOOD_MIRRI_TEXT_12]                = 52, -- Removed 53 as it was a dup
  [CC_GOOD_MIRRI_TEXT_14]                = 54,
  [CC_GOOD_MIRRI_TEXT_15]                = 55,
  [CC_GOOD_MIRRI_TEXT_16]                = 56,
  [CC_GOOD_MIRRI_TEXT_17]                = 57, -- 5:34pm -6:36 -7:36 -9:44 >2hour
  [CC_GOOD_MIRRI_TEXT_18]                = 58, -- TODO
  [CC_BAD_MIRRI_TEXT_1]                  = 59,
  [CC_BAD_MIRRI_TEXT_2]                  = 60,
  [CC_GOOD_EMBER_TEXT_1]                 = 61,
  [CC_GOOD_EMBER_TEXT_2]                 = 62,
  [CC_GOOD_EMBER_TEXT_3]                 = 63,
  [CC_GOOD_EMBER_TEXT_4]                 = 64, -- TODO
  [CC_GOOD_EMBER_TEXT_5]                 = 65,
  [CC_GOOD_EMBER_TEXT_6]                 = 66,
  [CC_GOOD_EMBER_TEXT_7]                 = 67,
  [CC_GOOD_EMBER_TEXT_8]                 = 68, --10:35 -10:47 - 11:35 > 10
  [CC_GOOD_EMBER_TEXT_9]                 = 69,
  [CC_GOOD_EMBER_TEXT_10]                = 70, -- 2:44 4:53 ( <2 hours )   4:53 - 5:41 (>1 hour) (Probs 2 hours)
  [CC_GOOD_EMBER_TEXT_11]                = 71,
  [CC_GOOD_EMBER_TEXT_12]                = 72,
  [CC_GOOD_EMBER_TEXT_13]                = 73,
  [CC_GOOD_EMBER_TEXT_14]                = 74, -- TODO
  [CC_GOOD_EMBER_TEXT_15]                = 75, -- TODO
  [CC_GOOD_EMBER_TEXT_16]                = 76,
  [CC_GOOD_EMBER_TEXT_17]                = 77, -- TODO
  [CC_GOOD_EMBER_TEXT_18]                = 78,
  [CC_BAD_EMBER_TEXT_1]                  = 79,
  [CC_BAD_EMBER_TEXT_2]                  = 80,
  [CC_BAD_EMBER_TEXT_3]                  = 81,
  [CC_BAD_EMBER_TEXT_4]                  = 82,
  [CC_BAD_EMBER_TEXT_5]                  = 83,
}

--[[
  Get the string id from the event id
]]
function CC_RapportEventName(eventId)
  for stringId, id in pairs(CC_RAPPORT_EVENTS) do
      if id == eventId then
          return stringId
      end
  end
  return 0
end

--- Get the event id of the provided rapport object
---@param rapport table
---@return integer
function CC_GetRapportEventID(rapport)
  local eventId = CC_RAPPORT_EVENTS[rapport.text]
  eventId = eventId ~= nil and eventId or 0
  return eventId
end

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
