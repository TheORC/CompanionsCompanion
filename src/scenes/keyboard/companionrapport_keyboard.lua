local TIME_COLOR    = "(|cded123%s|r): "
local GOOD_COLOR    = "|c008000+%d|r"
local BAD_COLOR     = "|ccc0000-%d|r"
local RAPPORT_STATS = {
    GOOD = 1,
    BAD  = 2,
}

-----------------------------
-- Rapport Object
-----------------------------

---Class containing information about an indevidaul rapport entry.
---@class CC_RapportObject
CC_RapportObject    = ZO_InitializingObject:Subclass()

function CC_RapportObject:Initialize(control)
    control.rapport = self
    self.control    = control

    self.title      = control:GetNamedChild("Title")
    self.icon       = control:GetNamedChild("Icon")
    self.points     = control:GetNamedChild("Points")
    self.timer      = control:GetNamedChild("Countdown")
    self.timerBtn   = control:GetNamedChild("ReminderBtn")

    self.bulletList = ZO_BulletList:New(control:GetNamedChild("BulletList"))
end

---Displays the rapport object.
function CC_RapportObject:Show()
    self.control:SetHidden(false)
end

---Assings data to the rapport object.
---@param rapportData table
function CC_RapportObject:SetData(rapportData)
    self.rapportStatus = rapportData.status ~= nil and rapportData.status or RAPPORT_STATS.GOOD
    self.titleText     = rapportData.title ~= nil and rapportData.title or "None"
    self.rapportAmount = rapportData.raportAmount ~= nil and rapportData.raportAmount or {}
    self.timerAmount   = rapportData.timerAmount ~= nil and rapportData.timerAmount or {}
    self.resetCallback = rapportData.restCallback ~= nil and rapportData.restCallback or nil

    self:Build()
    self:Show()
end

---Updates the rapport ui object with the rapport data
function CC_RapportObject:Build()
    self:SetTitle(self.titleText)

    if self.resetCallback then
        self.timerBtn:SetHandler("OnClicked", function()
            self.resetCallback()
        end)
    end

    self:SetTimeRapportList(self.rapportAmount, self.timerAmount)
    self:SetTimerButtonText(GetString(CC_REMINDER_BTN))

    if self.rapportStatus == RAPPORT_STATS.GOOD then
        self.icon:SetTexture("EsoUI/Art/HUD/lootHistory_icon_rapportIncrease_generic.dds")
    elseif self.rapportStatus == RAPPORT_STATS.BAD then
        self.icon:SetTexture("EsoUI/Art/HUD/lootHistory_icon_rapportDecrease_generic.dds")
    end
end

---Sets the ui rapport title
---@param value string
function CC_RapportObject:SetTitle(value)
    self.title:SetText(value)
end

---Builds a list of different rapport times.
---A companion can sometimes can different amounts of rapport for the same activity.  For instance,
---sometimes you might gain 5 rapport every 10 minutes but 1 rapport for each minute.  Because of
-- this we need to construct a list containing each of the different time and rapport value pairs.
---@param rapportList table
---@param timerList table
function CC_RapportObject:SetTimeRapportList(rapportList, timerList)
    -- These need to be the same length
    if #(rapportList) ~= #(timerList) then
        return
    end

    self.bulletList:Clear()

    -- Loop through each of the different rapport gain amounts and construct a list entry for it.
    for i, item in ipairs(rapportList) do
        local listEntry    = {}
        local timerValue   = timerList[i]
        local rapportValue = rapportList[i]

        table.insert(listEntry, string.format(TIME_COLOR, timerValue))

        if self.rapportStatus == RAPPORT_STATS.GOOD then
            table.insert(listEntry, string.format(GOOD_COLOR, rapportValue))
        elseif self.rapportStatus == RAPPORT_STATS.BAD then
            table.insert(listEntry, string.format(BAD_COLOR, rapportValue))
        end

        self.bulletList:AddLine(table.concat(listEntry, ""))
    end
end

---Updates the timer text for this rapport ui object.
---@param value string The remaining timer time
function CC_RapportObject:SetTimer(value)
    self.timer:SetText(value)
    self.timer:SetHidden(false)
end

---Anchors this rapport ui object to the `previous` object provided.
---@param previous table
function CC_RapportObject:SetAnchoredToRapport(previous)
    self.control:ClearAnchors()

    if previous then
        self.control:SetAnchor(TOP, previous:GetControl(), BOTTOM, 0, 0)
    else
        self.control:SetAnchor(TOPLEFT, nil, TOPLEFT)
    end
end

---Updates the text inside of timer start/cancel button.
---@param value string The new text to display.
function CC_RapportObject:SetTimerButtonText(value)
    self.timerBtn:SetText(value)
end

---Dislay the timer start/cancel button.
function CC_RapportObject:ShowTimerButton()
    self.timerBtn:SetHidden(false)
end

---Hide the timer start/cancel button.
function CC_RapportObject:HideTimerButton()
    self.timerBtn:SetHidden(true)
end

---Get this rapport ui objects control element.
---@return table
function CC_RapportObject:GetControl()
    return self.control
end

---Reset the rapport ui object so it can be used again.
function CC_RapportObject:Reset()
    self.control:SetHidden(true)
    self:SetTimer("")
    self:ShowTimerButton()
    self:SetTimerButtonText(GetString(CC_REMINDER_BTN))
end

-----------------------------
-- Companion Rapport Scene
-----------------------------

CC_CompanionRapport_Keyboard = ZO_InitializingObject:Subclass()

function CC_CompanionRapport_Keyboard:Initialize(control)
    self.control                   = control
    self.differedInitiate          = true

    self.rapportSelectedStatus     = RAPPORT_STATS.GOOD

    -- Store information on good/bad selected
    self.currentNavigationFragment = nil
    self.categoryNodes             = {}
    self.rapportObjects            = {}

    self:InitalizeControllers()
    self:InitializeNavigationTree()
    self:InitializeRapportPool()

    local function HandleTimerTick(timer)
        self:TimerUpdate(timer)
    end

    self.scene = ZO_InteractScene:New("companionRapportKeyboard", SCENE_MANAGER, ZO_COMPANION_MANAGER:GetInteraction())

    self.scene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            if self.differedInitiate then
                self.differedInitiate = false;
                self:DifferedInitialize()
            end

            self:BuildNavigationTree()
        elseif newState == SCENE_HIDDEN then
            CC_COMPANION_CALLBACK_MANAGER:UnregisterCallback(CC_TIMER_EVENTS.CC_TIMER_TICK, HandleTimerTick)
        end
    end)

    COMPANION_RAPPORT_KEYBOARD_SCENE    = self.scene
    COMPANION_RAPPORT_KEYBOARD_FRAGMENT = ZO_FadeSceneFragment:New(self.control)
    COMPANION_RAPPORT_KEYBOARD_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_FRAGMENT_SHOWING then
            if HasActiveCompanion() then
                self:RefreshCompanionRapport()
                self:BuildRapportList()

                CC_COMPANION_CALLBACK_MANAGER:RegisterCallback(CC_TIMER_EVENTS.CC_TIMER_TICK, HandleTimerTick)
            end
        end
    end)
end

---We need to perform some intiazation the first time this element is viewed.
function CC_CompanionRapport_Keyboard:DifferedInitialize()
    ---This method is called after a timer is canceled, or it has expired.
    ---This is used by the ui to hide the current timer countdown as well as to change the
    ---start/cancel button.
    ---@param interactionId any
    ---@param companionId any
    local function HandleTimerStop(interactionId, companionId)
        local rapportObject = self.rapportObjects[interactionId]
        if rapportObject ~= nil then
            rapportObject:SetTimer("")
            rapportObject:SetTimerButtonText(GetString(CC_REMINDER_BTN))
        end
    end

    -- Listen for timer endings
    CC_COMPANION_CALLBACK_MANAGER:RegisterCallback(CC_TIMER_EVENTS.CC_TIMER_FINISHED, HandleTimerStop)
    CC_COMPANION_CALLBACK_MANAGER:RegisterCallback(CC_TIMER_EVENTS.CC_TIMER_CANCELED, HandleTimerStop)
end

---Initialize the rapport information frame.
function CC_CompanionRapport_Keyboard:InitalizeControllers()
    local rightContainer          = self.control:GetNamedChild("RightContainer")

    -- Rapport status information
    local rapportContainer        = rightContainer:GetNamedChild("RapportContainer")

    self.rapportBarControl        = rapportContainer:GetNamedChild("ProgressBar")
    self.rapportStatusLabel       = rapportContainer:GetNamedChild("StatusValue")
    self.rapportDescriptionLabel  = rapportContainer:GetNamedChild("Description")

    local RAPPORT_GRADIENT_START  = ZO_ColorDef:New("722323") --Red
    local RAPPORT_GRADIENT_END    = ZO_ColorDef:New("009966") --Green
    local RAPPORT_GRADIENT_MIDDLE = ZO_ColorDef:New("9D840D") --Yellow

    self.rapportBar               = ZO_SlidingStatusBar:New(self.rapportBarControl)
    self.rapportBar:SetGradientColors(RAPPORT_GRADIENT_START, RAPPORT_GRADIENT_END, RAPPORT_GRADIENT_MIDDLE)
    self.rapportBar:SetMinMax(GetMinimumRapport(), GetMaximumRapport())

    -- Raport List information
    self.contentList            = rightContainer:GetNamedChild("RapportPanelList")
    self.contentListScrollChild = self.contentList:GetNamedChild("ScrollChild")
end

---Initialize the left side navigation tree.
function CC_CompanionRapport_Keyboard:InitializeNavigationTree()
    local DEFAULT_INDENT = 60
    local DEFAULT_SPACING = -10

    self.navigationTree = ZO_Tree:New(self.control:GetNamedChild("NavigationContainer"), DEFAULT_INDENT, DEFAULT_SPACING,
        ZO_COMPANION_CHARACTER_KEYBOARD_TREE_WIDTH)
    self.navigationTree:SetExclusive(true)
    self.navigationTree:SetOpenAnimation("ZO_TreeOpenAnimation")

    local function TreeCategoryEntrySetup(node, control, entryData, open)
        control.text:SetText(entryData.name)

        local iconTexture = open and entryData.pressedIcon or entryData.normalIcon
        control.icon:SetTexture(iconTexture)

        local mouseoverTexture = entryData.mouseoverTexture
        control.iconHighlight:SetTexture(mouseoverTexture)

        ZO_IconHeader_Setup(control, open, entryData.unlocked)
    end

    local function OnTreeCategorySelected(control, entryData, selected, reselectingDuringRebuild)
        control.icon:SetTexture(selected and entryData.pressedIcon or entryData.normalIcon)
        ZO_IconHeader_Setup(control, selected)

        if selected then
            self.rapportSelectedStatus = entryData.status
            self:BuildRapportList()
        end
    end

    self.navigationTree:AddTemplate("CC_CompanionRapport_Keyboard_TreeCategory", TreeCategoryEntrySetup,
        OnTreeCategorySelected)
end

---Initialize a pool for rapport ui objets.  This pool lets us recyle rapport ui objects instead of
--having to create and destroy them.  This is better for efficeny.
function CC_CompanionRapport_Keyboard:InitializeRapportPool()
    local function CreateNewRapport(objectPool)
        local rapport = ZO_ObjectPool_CreateControl("CC_RapportPanelTemplate", objectPool, self.contentListScrollChild)
        rapport.owner = self
        ---@diagnostic disable-next-line: undefined-field
        return CC_RapportObject:New(rapport)
    end

    self.rapportPool = ZO_ObjectPool:New(CreateNewRapport, ZO_ObjectPool_DefaultResetObject)
end

---Creates the left side navigation tree.  This lets you select between the good and rapport types
---and see them seperetly.
function CC_CompanionRapport_Keyboard:BuildNavigationTree()
    local function TreeIconSetup(control, data)
        local mouseoverTexture = data.mouseoverIcon or ZO_NO_TEXTURE_FILE
        local iconHighlight    = control:GetNamedChild("IconHighlight")

        iconHighlight:SetTexture(mouseoverTexture)
    end

    self.navigationTree:Reset()

    ZO_ClearTable(self.categoryNodes)

    local NAVIGATION_ENTRY_DATA =
    {
        {
            name          = GetString(CC_TEXT_GOOD_RAPPORT),
            status        = RAPPORT_STATS.GOOD,
            normalIcon    = "EsoUI/Art/Companion/Keyboard/companion_overview_up.dds",
            pressedIcon   = "EsoUI/Art/Companion/Keyboard/companion_overview_down.dds",
            mouseoverIcon = "EsoUI/Art/Companion/Keyboard/companion_overview_over.dds",
        },
        {
            name          = GetString(CC_TEXT_BAD_RAPPORT),
            status        = RAPPORT_STATS.BAD,
            normalIcon    = "esoui/art/companion/keyboard/companion_skills_up.dds",
            pressedIcon   = "esoui/art/companion/keyboard/companion_skills_down.dds",
            mouseoverIcon = "esoui/art/companion/keyboard/companion_skills_down.dds",
        },
    }

    for _, entryData in ipairs(NAVIGATION_ENTRY_DATA) do
        local treeNode = self.navigationTree:AddNode("CC_CompanionRapport_Keyboard_TreeCategory", entryData)
        self.categoryNodes[entryData] = treeNode

        TreeIconSetup(treeNode:GetControl(), entryData)
    end

    self.navigationTree:Commit()
end

---Builds the rapport list for the current active companion.
function CC_CompanionRapport_Keyboard:BuildRapportList()
    --Somehow we are building the list but should not be
    if not HasActiveCompanion() or not COMPANION_RAPPORT_KEYBOARD_FRAGMENT:IsShowing() then
        return
    end

    self.rapportPool:ReleaseAllObjects()

    ZO_Scroll_ResetToTop(self.contentList)
    ZO_ClearTable(self.rapportObjects)

    -- Get the id of the current active compaion
    local companionId = CC_Libs.GetCompanionId()

    -- Get the good/bad rapport depending on what is being viewed
    local companionRapportList
    if self.rapportSelectedStatus == RAPPORT_STATS.GOOD then
        companionRapportList = CC_COMPANION_DATA_MANAGER:GetCompanionGoodRaport(companionId)
    else
        companionRapportList = CC_COMPANION_DATA_MANAGER:GetCompanionBadRaport(companionId)
    end

    -- Do nothing if the companion data can't be found
    if companionRapportList == nil then
        return
    end

    local previous
    for _, rapportData in ipairs(companionRapportList) do
        local poolObject             = self.rapportPool:AcquireObject()
        local interactionId          = rapportData.id

        -- Get a list of rapport items and their respective timers
        local rapportList, timerList = CC_COMPANION_DATA_MANAGER:GetRapportTimeComponents(interactionId)
        local interactionData        = {
            status       = self.rapportSelectedStatus,
            title        = string.format("%s", GetString(rapportData.text)),
            raportAmount = rapportList,
            timerAmount  = timerList,
            rapportKey   = rapportData,
            restCallback = function()
                local timerId = CC_GetTimerId(interactionId)

                -- Check for an existing timer
                if timerId ~= nil then
                    ZO_Dialogs_ShowDialog("CC_RESET_TIMER_DIALOG", {
                        interactionId = interactionId,
                        timerId = timerId,
                    })

                    -- No timer
                else
                    CC_StartRapportTimer(interactionId)
                    poolObject:SetTimerButtonText(GetString(CC_CANCEL_BTN))
                end
            end
        }
        poolObject:SetData(interactionData)

        -- Check if there is an interaction cooldown
        local rapportTime = CC_GetRapportTime(interactionId)
        if rapportTime == nil or rapportTime == 0 then
            poolObject:HideTimerButton()
        else
            poolObject:ShowTimerButton()
        end

        -- Check to see if there is an active cooldown
        local timerId = CC_GetTimerId(interactionId)
        if timerId ~= nil then
            poolObject:SetTimerButtonText(GetString(CC_CANCEL_BTN))
        end

        -- Store the rapport element based on it's interactionId
        self.rapportObjects[interactionId] = poolObject;

        poolObject:SetAnchoredToRapport(previous)
        previous = poolObject
    end
end

---Refreshes the companions rapport bar with the companions current rapport information.
function CC_CompanionRapport_Keyboard:RefreshCompanionRapport()
    if HasActiveCompanion() and COMPANION_RAPPORT_KEYBOARD_FRAGMENT:IsShowing() then
        --Grab the rapport value, level, and description for the active companion
        local rapportValue       = GetActiveCompanionRapport()
        local rapportLevel       = GetActiveCompanionRapportLevel()
        local rapportDescription = GetActiveCompanionRapportLevelDescription(rapportLevel)
        local maxRapport         = GetMaximumRapport()

        self.rapportBar:SetValue(rapportValue)
        self.rapportStatusLabel:SetText(string.format("%s (%d/%d)", GetString("SI_COMPANIONRAPPORTLEVEL", rapportLevel),
            rapportValue, maxRapport))
        self.rapportDescriptionLabel:SetText(rapportDescription)
    end
end

---Called each time a timer is updated.
---This method is responsible for updating the count down timer text.
---@param timer CC_Timer
function CC_CompanionRapport_Keyboard:TimerUpdate(timer)
    -- We don't do any timer display if the user has disabled this setting
    if not CC_STORAGE_MANAGER:GetSetting(CC_SETTING_OPTIONS.SHOW_COUNTDOWN) then
        return
    end

    local timerData     = timer:GetData()
    local rapportObject = self.rapportObjects[timerData.interactionId]

    if rapportObject ~= nil then
        local timerString = CC_Libs.SecondsToReadibleFormat(timer:GetRemainingTime())
        rapportObject:SetTimerButtonText(GetString(CC_CANCEL_BTN))
        rapportObject:SetTimer(timerString)
    end
end

function CC_CompanionRapport_Keyboard_OnInitialize(control)
    COMPANION_RAPPORT_KEYBOARD = CC_CompanionRapport_Keyboard:New(control)
end
