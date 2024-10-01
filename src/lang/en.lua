local englishStrings = {

    --[[
        UI Gamepad
    ]]
    CC_UI_RAPPORT_TITLE = "Rapport",

    --[[
        General
    ]]
    CC_TEXT_GOOD_RAPPORT       = "Good Rapport", -- Title
    CC_TEXT_BAD_RAPPORT        = "Bad Rapport",  -- Title
    CC_REMINDER_BTN            = "Remind",       -- Remind btn text
    CC_CANCEL_BTN              = "Cancel",       -- Cancel btn text
    CC_ERROR_START_TIMER       = "Failed to start the timer",
    CC_RESET_MODAL_TITLE       = "Reset Timer",
    CC_RESET_MODAL_DESCRIPTION = "Are you sure you want to reset the timer for this event?",

    --[[
        Notifications
    ]]
    CC_NOTIFICATION_TIMER_FINISH_MAIN   = "<<1>> Rapport", -- Screen top notification
    CC_NOTIFICATION_TIMER_FINISH_SECOND = "<<1>>",         -- Screen bottom notification
    CC_CHAT_TIMER_FINISH                = "You can now perform \"<<1>>\" with <<2>>.",
    CC_CHAT_TIMER_START                 = "Reminder for \"<<1>>\" set in <<2>>.",
    CC_CHAT_TIMER_CANCEL                = "You have cancelled the \"<<1>>\" reminder.",

    --[[
        Time
    ]]
    CC_TIME_STRING                       = "Reminder in <<1>> <<2>> <<3>> <<4>>", -- Format of time strings e.g. 2 hours
    CC_TIME_SECONDS                      = "seconds",
    CC_TIME_MINUTES                      = "minutes",
    CC_TIME_HOURS                        = "hours",
    CC_TIME_DAYS                         = "days",

    CC_UNKNOWN_TIME                      = "unknown",
    CC_1_MINUTES                         = "1 minute",
    CC_2_MINUTES                         = "2 minutes",
    CC_3_MINUTES                         = "3 minutes",
    CC_5_MINUTES                         = "5 minutes",
    CC_10_MINUTES                        = "10 minutes",
    CC_15_MINUTES                        = "15 minutes",
    CC_30_MINUTES                        = "30 minutes",
    CC_1_HOUR                            = "1 hour",
    CC_2_HOURS                           = "2 hours",
    CC_20_HOURS                          = "20 hours",
    CC_FIRST_TIME                        = "first time",
    CC_OTHER_TIMES                       = "other times",
    CC_NO_COOLDOWN                       = "no cooldown",
    CC_OFF_COOLDOWN                      = "off cooldown",
    CC_DURING_COOLDOWN                   = "during cooldown",
    CC_SHARED_COOLDOWN                   = "shared cooldown",
    CC_SHARED_BASTIAN_MIRRI              = "at 1500 and 2800 rapport",
    CC_ONCE_PER_PERSONAL_QUEST           = "once per personal quest",
    CC_SHARED_ISOBEL_EMBER_QUEST_RAPPORT = "at 1500, 2750, and 4000 rapport",

    --[[
        Shared
    ]]
    CC_SHARED_COMPLETE_PERSONAL_QUEST  = "Complete a personal quest",
    CC_SHARED_DARK_BROTHERHOOD         = "Enter the Dark Brotherhood Sanctuary in the Gold Coast",
    CC_SHARED_USE_BLADE_OF_WOE_NPC     = "Use the Blade of Woe on any NPC",
    CC_SHARED_COMPLETE_MAGES_DAILY     = "Complete a daily Mages Guild quest",
    CC_SHARED_COMPLETE_ASHLANDER_DAILY = "Complete a daily Ashlander hunt quest",
    CC_SHARED_LOOTING_PSIJIC_PORTAL    = "Loot a Psijic portal",

    --[[
        Isobel
    ]]
    -- Good
    CC_GOOD_ISOBEL_TEXT_2  = "Complete a daily Undaunted quest for Bolgrul",
    CC_GOOD_ISOBEL_TEXT_3  = "Complete a daily High Isle world boss quest",
    CC_GOOD_ISOBEL_TEXT_4  = "Kill a world boss",
    CC_GOOD_ISOBEL_TEXT_6  = "Kill a boss-type Daedra (e.g. Harvester)",
    CC_GOOD_ISOBEL_TEXT_7  = "Kill Daedra",
    CC_GOOD_ISOBEL_TEXT_8  = "Craft sweet food (e.g. grape preserves)",
    CC_GOOD_ISOBEL_TEXT_9  = "Craft anything at a blacksmithing station",
    CC_GOOD_ISOBEL_TEXT_10 = "Complete a Volcanic Vent in High Isle",
    CC_GOOD_ISOBEL_TEXT_11 = "Visit an Undaunted Enclave",
    CC_GOOD_ISOBEL_TEXT_12 = "Talk to Dagerfall Covenant leader King Emeric",
    CC_GOOD_ISOBEL_TEXT_13 = "Talk to Aldmeri Dominion leader Queen Ayrenn",
    CC_GOOD_ISOBEL_TEXT_14 = "Talk to Ebonheart Pact leader King Jorunn",
    CC_GOOD_ISOBEL_TEXT_15 = "Talk to Lyris Titanborn", -- 6:00 -- 7:00
    CC_GOOD_ISOBEL_TEXT_16 = "Use a repair kit",
    CC_GOOD_ISOBEL_TEXT_17 = "Accept an invitation to a duel from another player",
    CC_GOOD_ISOBEL_TEXT_18 = "Summon the Druadach Mountain Dog or Bravil Retriever non-combat pets",

    -- Bad
    CC_BAD_ISOBEL_TEXT_1   = "Kill an innocent NPC",
    CC_BAD_ISOBEL_TEXT_2   = "Steal, loot a Thieves Trove, or loot the corpse of an innocent NPC",
    CC_BAD_ISOBEL_TEXT_3   = "Enter an Outlaws Refuge or the Abah's Landing Thieves Den",


    --[[
        Bastian
    ]]
    -- Good
    CC_GOOD_BASTIAN_TEXT_2 = "Enter a Mages Guild hall that could contain a portal to Eyevea",
    CC_GOOD_BASTIAN_TEXT_3 = "Visit Eyevea or Artaeum",
    CC_GOOD_BASTIAN_TEXT_4 = "Complete a random encounter that helps people (e.g. overwhelmed summoners)",
    CC_GOOD_BASTIAN_TEXT_6 = "Scry for an antiquity",
    CC_GOOD_BASTIAN_TEXT_7 = "Visit a crafting station",
    CC_GOOD_BASTIAN_TEXT_8 = "Read any book",
    CC_GOOD_BASTIAN_TEXT_9 = "Kill a Worm Cultist",
    CC_GOOD_BASTIAN_TEXT_10 = "Kill a bandit",
    CC_GOOD_BASTIAN_TEXT_12 = "Kill a cultist",

    -- Bad
    CC_BAD_BASTIAN_TEXT_3 = "Pickpocket",
    CC_BAD_BASTIAN_TEXT_4 = "Steal or loot the corpse of an innocent NPC",
    CC_BAD_BASTIAN_TEXT_5 = "Kill critters (e.g. frogs)",
    CC_BAD_BASTIAN_TEXT_6 = "Loot a Thieves Trove",
    CC_BAD_BASTIAN_TEXT_7 = "Choose the flee option when accosted by a guard",
    CC_BAD_BASTIAN_TEXT_8 = "Craft food using cheese",
    CC_BAD_BASTIAN_TEXT_9 = "Attack innocent NPCs",
    CC_BAD_BASTIAN_TEXT_10 = "Murder innocent NPCs", -- >1 hour


    --[[
        Mirri
    ]]
    -- Good
    CC_GOOD_MIRRI_TEXT_1 = "Complete a daily Ashlander Quest for Numani-Rasi",
    CC_GOOD_MIRRI_TEXT_2 = "Complete a daily Fighters Guild quest",
    CC_GOOD_MIRRI_TEXT_3 = "Enter the Library of Vivec in Vivec City containing a completed model of Vvardenfell",
    CC_GOOD_MIRRI_TEXT_4 = "Enter the Thieves Den in Abah's Landing containing items from Kari's Hit List",
    CC_GOOD_MIRRI_TEXT_5 = "Enter a Daedric-themed delve or public dungeon",
    CC_GOOD_MIRRI_TEXT_6 = "Visit the Clockwork City (except Brass Fortress unless through front gate)",
    CC_GOOD_MIRRI_TEXT_7 = "Excavate an Antiquity",
    CC_GOOD_MIRRI_TEXT_9 = "View a completed Khajiit of the Moons in Senchal",
    CC_GOOD_MIRRI_TEXT_10 = "View a completed Rithana-di-Renada in Riverhold",
    CC_GOOD_MIRRI_TEXT_11 = "View a completed House of Orsimer Glories in Orsinium",
    CC_GOOD_MIRRI_TEXT_12 = "View a completed Vault of Moawita on Artaeum",
    CC_GOOD_MIRRI_TEXT_14 = "Kill a goblin",
    CC_GOOD_MIRRI_TEXT_15 = "Kill a snake (including critters)",
    CC_GOOD_MIRRI_TEXT_16 = "Craft an alcoholic beverage",
    CC_GOOD_MIRRI_TEXT_17 = "Read a book from a bookshelf",             -- 5:34pm -6:36 -7:36 -9:44 >2hour
    CC_GOOD_MIRRI_TEXT_18 = "Summon the Daemon Chicken non-combat pet", -- TODO

    -- Bad
    CC_BAD_MIRRI_TEXT_1 = "Complete a Dark Brotherhood Black Sacrament quest",
    CC_BAD_MIRRI_TEXT_2 = "Collect a torchbug or butterfly",

    --[[
        Ember
    ]]
    --
    -- Good
    CC_GOOD_EMBER_TEXT_1  = "Complete a non-perfect Thieves Guild Heist quest",
    CC_GOOD_EMBER_TEXT_2  = "Complete a daily High Isle delve quest",
    CC_GOOD_EMBER_TEXT_3  = "Sell a stolen purple-quality item to a Fence",
    CC_GOOD_EMBER_TEXT_4  = "Choose the flee option when accosted by a guard", -- TODO
    CC_GOOD_EMBER_TEXT_5  =
    "Choose the Clemency option when accosted by a guard (requires Thieves Guild skill line passive)",
    CC_GOOD_EMBER_TEXT_6  = "Win a Tales of Tribute match",
    CC_GOOD_EMBER_TEXT_7  = "Pickpocket a guard",
    CC_GOOD_EMBER_TEXT_8  = "Loot a safebox or Thieves Trove", --10:35 -10:47 - 11:35 > 10
    CC_GOOD_EMBER_TEXT_9  = "Complete a quest from the Tip Board in the Abah's Landing Thieves Den",
    CC_GOOD_EMBER_TEXT_10 = "Use a counterfeit pardon edict",  -- 2:44 4:53 ( <2 hours )   4:53 - 5:41 (>1 hour) (Probs 2 hours)
    CC_GOOD_EMBER_TEXT_11 = "Harvest a runestone",
    CC_GOOD_EMBER_TEXT_12 = "Kill wolves",
    CC_GOOD_EMBER_TEXT_13 = "Kill werewolves",
    CC_GOOD_EMBER_TEXT_14 = "Successfully escape after choosing the flee option when accosted by a guard", -- TODO
    CC_GOOD_EMBER_TEXT_15 = "Sell a purple-quality item to any NPC vendor",                                -- TODO
    CC_GOOD_EMBER_TEXT_16 = "Enter an Outlaws Refuge or the Abah's Landing Thieves Den",
    CC_GOOD_EMBER_TEXT_17 = "Tresspass in a restricted area",                                              -- TODO
    CC_GOOD_EMBER_TEXT_18 = "Summon the Big-Eared Ginger Kitten non-combat pet",

    -- Bad
    CC_BAD_EMBER_TEXT_1   = "Get caught stealing, pickpocketing, or murdering/attacking an innocent NPC",
    CC_BAD_EMBER_TEXT_2   = "Willingly pay a bounty when accosted by a guard",
    CC_BAD_EMBER_TEXT_3   = "Get caught trespassing",
    CC_BAD_EMBER_TEXT_4   = "Get killed by a guard",
    CC_BAD_EMBER_TEXT_5   = "Start fishing",

    --[[
        Sharp-As-Night
    ]]

    -- Good
    CC_GOOD_SHARP_TEXT_1 = "Loot a heavy sack",
    CC_GOOD_SHARP_TEXT_2 = "Repair gear (including recharging weapon)", -- > 20 ?
    CC_GOOD_SHARP_TEXT_3 = "Harvest an alchemy material",
    CC_GOOD_SHARP_TEXT_4 = "Start fishing",
    CC_GOOD_SHARP_TEXT_5 = "Catch a non-common fish",
    CC_GOOD_SHARP_TEXT_9 = "Complete a daily quest for Ordinator Neyln in Necrom",
    CC_GOOD_SHARP_TEXT_10 = "Kill a ghost",
    CC_GOOD_SHART_TEXT_11 = "Visit any hist tree",
    CC_GOOD_SHART_TEXT_12 = "Talking to M'aiq the Liar",
    CC_GOOD_SHART_TEXT_13 = "Eat a meal",
    CC_GOOD_SHART_TEXT_14 = "Craft a poison",
    CC_GOOD_SHARP_TEXT_15 = "Kill a Fabricant or Dwarven construct",
    CC_GOOD_SHARP_TEXT_16 = "Find a treasure map chest",
    CC_GOOD_SHARP_TEXT_17 = "Obtain a monster trophy",

    -- Bad
    CC_BAD_SHARP_TEXT_1 = "Visit an outfit station",
    CC_BAD_SHARP_TEXT_2 = "Willingly pay a bounty when accosted by a guard",
    CC_BAD_SHARP_TEXT_3 = "Pickpocket a begger",               -- > 20
    CC_BAD_SHARP_TEXT_4 = "Destorying an item from inventory", -- > 20
    CC_BAD_SHARP_TEXT_5 = "Let your gear break",

    --[[
        Azandar Al-Cybiades
    ]]

    -- Good
    CC_GOOD_AZANDAR_TEXT_1                    = "Complete a daily enchanting master writ quest",
    CC_GOOD_AZANDAR_TEXT_16                   = "Complete a daily quest for Ordinator Tilena in Necrom",
    CC_GOOD_AZANDAR_TEXT_2                    = "Visit any mundus stone",
    CC_GOOD_AZANDAR_TEXT_3                    = "Scry for an antiquity",
    CC_GOOD_AZANDAR_TEXT_4                    = "Find a lead",
    CC_GOOD_AZANDAR_TEXT_5                    = "Find a new lorebook",
    CC_GOOD_AZANDAR_TEXT_6                    = "Activating an Ayleid well",
    CC_GOOD_AZANDAR_TEXT_7                    = "Read any mages guild book",
    CC_GOOD_AZANDAR_TEXT_8                    = "Craft any tea",
    CC_GOOD_AZANDAR_TEXT_9                    = "Kill mudcrabs, dreughs, chaurus, ogres, trolls, harpies, nix-oxen, or dunerippers",
    CC_GOOD_AZANDAR_TEXT_18                   = "Visit the Brass Fortress, The Hollow City, or Fargrave City District",
    CC_GOOD_AZANDAR_TEXT_19                   = "Complete an Oblivion Portal",
    CC_GOOD_AZANDAR_TEXT_20                   = "Conseume any tea type beverages",

    -- Bad
    CC_BAD_AZANDAR_TEXT_1                     = "Visting Artaeum or Eyevea",
    CC_BAD_AZANDAR_TEXT_2                     = "Crafting any coffee", -- > 4
    CC_BAD_AZANDAR_TEXT_3                     = "Harvesting any mushroom",
    CC_BAD_AZANDAR_TEXT_4                     = "Play Tales of Tribute",

    ------------------------
    -- Settings Menu Text --
    ------------------------

    CC_SETTINGS_TITLE                         = "About",
    CC_SETTINGS_MENU_DESCRIPTION              =
    "This addon adds rapport information to the companion overview screen.  It also adds notification timers which when set will notify you after the allotted time.\n\nThanks to @NextTuesday for help with the English translation.\nThanks to @Baryzard for the French translation.\nThanks to @Neverlands for the German translation.\n\nPM me if you would like to see this addon support your own language.",
    CC_SETTINGS_NOTIFICATION_SECTION          = "Notification Options",
    CC_SETTINGS_CHAT_REMINDER_NAME            = "Send reminder to chat",
    CC_SETTINGS_CHAT_REMINDER_TOOLTIP         = "Should the reminder be sent to your chat box?",
    CC_SETTINGS_NOTIFICATION_NAME             = "Send reminder to screen",
    CC_SETTINGS_NOTIFICATION_TOOLTIP          = "Should the reminder popup on your screen?",
    CC_SETTINGS_OTHER_SECTION                 = "Other Options",
    CC_SETTINGS_OTHER_TIMER_S_NAME            = "Notify on timer start",
    CC_SETTINGS_OTHER_TIMER_S_TOOLTIP         = "When you start a timer, should a message be sent to your chat?",
    CC_SETTINGS_OTHER_TIMER_R_NAME            = "Notify on timer reset",
    CC_SETTINGS_OTHER_TIMER_R_TOOLTIP         = "When you reset a timer, should a message be sent to your chat?",
    CC_SETTINGS_OTHER_COUNTDOWN_NAME          = "Show countdowns",
    CC_SETTINGS_OTHER_COUNTDOWN_TOOLTIP       = "Shows the time remaining before a notification.",

    CC_SETTINGS_OTHER_RAPPORT_IN_CHAT_NAME    = "Show rapport in chat",
    CC_SETTINGS_OTHER_RAPPORT_IN_CHAT_TOOLTIP =
    "Should a message be sent to the chat everytime your characters rapport changes?",

    ------------------------
    --   Chat Messages    --
    ------------------------
    CC_CHAT_GAINED_RAPPORT                    = "<<1>> has gained <<2>> rapport.",
    CC_CHAT_LOST_RAPPORT                      = "<<1>> has lost <<2>> rapport."

}

-- Load all the english words in as default
for index, value in pairs(englishStrings) do
    ZO_CreateStringId(index, value)
    SafeAddVersion(index, 1)
end
