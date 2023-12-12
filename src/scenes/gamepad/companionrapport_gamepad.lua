-----------------------------
-- Companion Collection Book
-----------------------------

local GAMEPAD_COMPANION_RAPPORT_DIALOG_NAME = "GAMEPAD_COMPANION_RAPPORT_ACTIONS_DIALOG"
local CC_CompanionRapport_Gamepad = ZO_Gamepad_ParametricList_Screen:Subclass()

function CC_CompanionRapport_Gamepad:Initialize(control)

    self.control = control

    COMPANION_RAPPORT_GAMEPAD_FRAGMENT = ZO_FadeSceneFragment:New(control)

    COMPANION_RAPPORT_GAMEPAD_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_FRAGMENT_SHOWING then
            local list = self:GetMainList()
            self:RefreshList()
        end
    end)

    COMPANION_RAPPORT_GAMEPAD_SCENE = ZO_InteractScene:New("companionRapportGamepad", SCENE_MANAGER, ZO_COMPANION_MANAGER:GetInteraction())
    COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(COMPANION_RAPPORT_GAMEPAD_FRAGMENT)

    local ACTIVATE_ON_SHOW = true
    ZO_Gamepad_ParametricList_Screen.Initialize(self, control, ZO_GAMEPAD_HEADER_TABBAR_DONT_CREATE, ACTIVATE_ON_SHOW, COMPANION_RAPPORT_GAMEPAD_SCENE)

    local list = self:GetMainList()
    list:AddDataTemplate("ZO_GamepadNewMenuEntryTemplate", ZO_SharedGamepadEntry_OnSetup, ZO_GamepadMenuEntryTemplateParametricListFunction)

    SYSTEMS:RegisterGamepadObject(ZO_COLLECTIONS_SYSTEM_NAME, self)
end

function CC_CompanionRapport_Gamepad:OnDeferredInitialize()
    self:InitializeHeader()
    self:InitializeList()
    self:SetListsUseTriggerKeybinds(true)
end

function CC_CompanionRapport_Gamepad:PerformUpdate()
    self.dirty = false
 end

function CC_CompanionRapport_Gamepad:InitializeHeader()
    self.headerData =
    {
        titleText = GetString(CC_UI_RAPPORT_TITLE),
    }
    ZO_GamepadGenericHeader_Refresh(self.header, self.headerData)
end

function CC_CompanionRapport_Gamepad:InitializeKeybindStripDescriptors()
    self.keybindStripDescriptor =
    {
        -- Select mode.
        {
            keybind = "UI_SHORTCUT_PRIMARY",
            alignment = KEYBIND_STRIP_ALIGN_LEFT,

            name = function()
                return GetString(SI_GAMEPAD_SELECT_OPTION)
            end,
            visible = function()
                return true
            end,
            callback = function()
                local list       = self:GetMainList()
                local targetData = list:GetTargetData()
                SCENE_MANAGER:Push(targetData.sceneName)
            end,
        },
    }

    ZO_Gamepad_AddBackNavigationKeybindDescriptors(self.keybindStripDescriptor, GAME_NAVIGATION_TYPE_BUTTON)
end

function CC_CompanionRapport_Gamepad:InitializeList()
    self.menuData =
    {
        {
            icon = "EsoUI/Art/Companion/Gamepad/gp_companion_icon_overview.dds",
            name = CC_TEXT_GOOD_RAPPORT,
            scene = "companionRapportGoodGamepad",
        },
        {
            icon = "EsoUI/Art/Companion/Gamepad/gp_companion_icon_inventory.dds",
            name = CC_TEXT_BAD_RAPPORT,
            scene = "companionEquipmentGamepad",
        },
    }

    self:RefreshList()
end

function CC_CompanionRapport_Gamepad:RefreshList()
    local list = self:GetMainList()
    list:Clear()

    for _, data in ipairs(self.menuData) do
        local entryData             = ZO_GamepadEntryData:New(GetString(data.name), data.icon, nil, nil, data.isNewCallback)
        entryData.sceneName         = data.scene
        entryData.tooltipFunction   = data.tooltipFunction
        entryData.tooltipHeaderData = data.tooltipHeaderData
        entryData:SetIconTintOnSelection(true)
        entryData:SetIconDisabledTintOnSelection(true)
        list:AddEntry("ZO_GamepadNewMenuEntryTemplate", entryData)
    end

    list:Commit()
end

-----------------------------
-- Global XML Functions
-----------------------------

function CC_CompanionRapport_Gamepad_OnInitialize(control)
    zo_callLater(function ()
        COMPANION_RAPPORT_GAMEPAD = CC_CompanionRapport_Gamepad:New(control)

        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragmentGroup(FRAGMENT_GROUP.GAMEPAD_DRIVEN_UI_WINDOW)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(FRAME_INTERACTION_QUADRANT_3_GAMEPAD_FRAGMENT)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(FRAME_TARGET_BLUR_QUADRANT_3_GAMEPAD_FRAGMENT)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(GAMEPAD_NAV_QUADRANT_1_BACKGROUND_FRAGMENT)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(MINIMIZE_CHAT_FRAGMENT)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(GAMEPAD_MENU_SOUND_FRAGMENT)
        COMPANION_RAPPORT_GAMEPAD_SCENE:AddFragment(COMPANION_FOOTER_GAMEPAD_FRAGMENT)

    end, 2000)
end