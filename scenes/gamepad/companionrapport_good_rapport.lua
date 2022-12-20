CC_CompanionRapportGood_Gamepad = ZO_Gamepad_ParametricList_Screen:Subclass()

function CC_CompanionRapportGood_Gamepad:Initialize(control)
    COMPANION_RAPPORT_GOOD_GAMEPAD_FRAGMENT = ZO_FadeSceneFragment:New(control)

    COMPANION__RAPPORT_GOOD_GAMEPAD_SCENE = ZO_InteractScene:New("companionRapportGoodGamepad", SCENE_MANAGER, ZO_COMPANION_MANAGER:GetInteraction())
    COMPANION__RAPPORT_GOOD_GAMEPAD_SCENE:AddFragment(COMPANION_RAPPORT_GOOD_GAMEPAD_FRAGMENT)

    local DONT_ACTIVATE_ON_SHOW = false
    ZO_Gamepad_ParametricList_Screen.Initialize(self, control, ZO_GAMEPAD_HEADER_TABBAR_DONT_CREATE, DONT_ACTIVATE_ON_SHOW, COMPANION_RAPPORT_GAMEPAD_SCENE)
end

function CC_CompanionRapportGood_Gamepad:OnDeferredInitialize()
    self:InitializeHeader()
    self:InitializeFooter()
    self:InitializeSkillLinesList()
    self:InitializeSkillsList()
    self:SetListsUseTriggerKeybinds(true)
    self:InitializeQuickMenu()
    self:ResetSkillLineNewStatus()
    self:RegisterForEvents()
end


function CC_CompanionGoodRapport_Gamepad_OnInitialize(control)
    COMPANION_GOOD_RAPPORT_GAMEPAD = CC_CompanionRapportGood_Gamepad:New(control)
end