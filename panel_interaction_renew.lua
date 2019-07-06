local _panel = Panel_Widget_PanelInteraction_Renew
Panel_Widget_PanelInteraction_Renew:SetOffsetIgnorePanel(true)
local UI_Color = Defines.Color
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local PanelInteraction = {
  _ui = {
    stc_TextBg = UI.getChildControl(_panel, "Static_TextBg"),
    stc_Bg = UI.getChildControl(_panel, "Static_Bg"),
    stc_progressBg = UI.getChildControl(_panel, "Static_CircleProgress_PressBG"),
    progress_Circle = UI.getChildControl(_panel, "CircularProgress_Press"),
    txt_SelectedTitle = UI.getChildControl(_panel, "StaticText_SelectedTitle"),
    stc_Guide = UI.getChildControl(_panel, "Static_Guide"),
    stc_Key = UI.getChildControl(_panel, "Static_InteractionKey"),
    txt_HoldToInteract = UI.getChildControl(_panel, "StaticText_InteractionKey"),
    btn_Template = UI.getChildControl(_panel, "Button_Interaction_Template"),
    needCollectTool = UI.getChildControl(_panel, "Static_Cant"),
    stc_QuestComplete = UI.getChildControl(_panel, "Static_QuestCompleate")
  },
  _preUIMode = nil,
  _isReloadState = true,
  _isButtonAnimating = false,
  _basicInteractionType = 0,
  _focusInteractionType = 0,
  _buildingUpgradeActoKeyRaw = 0,
  _INTERACTABLE_ACTOR_KEY = 0,
  _INTERACTABLE_FRAG = 0,
  _SHOW_BUTTON_COUNT = 0,
  _buttonTimeAcc = 0,
  _keyguideIsMonotone = false,
  _isCanInteraction = true,
  _firstTextBGSizeX = 0,
  _firstTargetNameSizeX = 0
}
local _button_ID = {
  [0] = "Button_GamePlay",
  "Button_CharInfo",
  "Button_Exchange",
  "Button_Party_Invite",
  "Button_Dialog",
  "Button_Ride",
  "Button_Control",
  "Button_Looting",
  "Button_Collect",
  "Button_OpenDoor",
  "Button_OpenWarehouseInTent",
  "Button_ReBuildTent",
  "Button_InstallationMode",
  "Button_ViewHouseInfo",
  "Button_Havest",
  "Button_ParkingHorse",
  "Button_EquipInstallation",
  "Button_UnequipInstallation",
  "Button_OpenInventory",
  "Button_HorseInfo",
  "Button_Bussiness",
  "Button_Guild_Invite",
  "Button_Guild_Alliance_Invite",
  "Button_UseItem",
  "Button_UnbuildPersonalTent",
  "Button_Manufacture",
  "Button_Greet",
  "Button_Steal",
  "Button_Lottery",
  "Button_HarvestSeed",
  "Button_TopHouse",
  "Button_HouseRank",
  "Button_Lop",
  "Button_KillBug",
  "Button_UninstallTrap",
  "Button_Sympathetic",
  "Button_Observe",
  "Button_HarvestInformation",
  "Button_Clan_Invite",
  "Button_SiegeGateOpen",
  "Button_UnbuildKingOrLordTent",
  "Button_Eavesdrop",
  "Button_WaitComment",
  "Button_TakedownCannon",
  "Button_OpenWindow",
  "Button_ChangeLook",
  "Button_ChangeName",
  "Button_RepairKingOrLordTent",
  "Button_UserIntroduction",
  "Button_FollowActor",
  "Button_BuildingUpgrade",
  "Button_PvPBattle",
  "Button_SiegeObjectStart",
  "Button_SiegeObjectFinish",
  "Button_GateOpen",
  "Button_GateClose",
  "Button_UninstallBarricade",
  "Button_ServantRepair",
  "Button_LanternOn",
  "Button_LanternOff",
  "Button_Escape",
  "Button_Awake",
  "Button_Diving",
  "Button_GuildTeamBattle",
  "Button_Bungalow"
}
local _button_TextureUV = {
  [0] = {
    x1 = 2,
    y1 = 13,
    x2 = 32,
    y2 = 43
  },
  {
    x1 = 64,
    y1 = 13,
    x2 = 94,
    y2 = 43
  },
  {
    x1 = 95,
    y1 = 44,
    x2 = 125,
    y2 = 74
  },
  {
    x1 = 281,
    y1 = 44,
    x2 = 311,
    y2 = 74
  },
  {
    x1 = 2,
    y1 = 13,
    x2 = 32,
    y2 = 43
  },
  {
    x1 = 33,
    y1 = 13,
    x2 = 63,
    y2 = 43
  },
  {
    x1 = 64,
    y1 = 44,
    x2 = 94,
    y2 = 74
  },
  {
    x1 = 281,
    y1 = 106,
    x2 = 311,
    y2 = 136
  },
  {
    x1 = 95,
    y1 = 13,
    x2 = 125,
    y2 = 43
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 126,
    y1 = 13,
    x2 = 156,
    y2 = 43
  },
  {
    x1 = 95,
    y1 = 137,
    x2 = 125,
    y2 = 167
  },
  {
    x1 = 95,
    y1 = 137,
    x2 = 125,
    y2 = 167
  },
  {
    x1 = 157,
    y1 = 75,
    x2 = 187,
    y2 = 105
  },
  {
    x1 = 312,
    y1 = 13,
    x2 = 342,
    y2 = 43
  },
  {
    x1 = 33,
    y1 = 75,
    x2 = 63,
    y2 = 105
  },
  {
    x1 = 95,
    y1 = 106,
    x2 = 125,
    y2 = 136
  },
  {
    x1 = 126,
    y1 = 106,
    x2 = 156,
    y2 = 136
  },
  {
    x1 = 188,
    y1 = 75,
    x2 = 218,
    y2 = 105
  },
  {
    x1 = 64,
    y1 = 13,
    x2 = 94,
    y2 = 43
  },
  {
    x1 = 188,
    y1 = 75,
    x2 = 218,
    y2 = 105
  },
  {
    x1 = 312,
    y1 = 75,
    x2 = 342,
    y2 = 105
  },
  {
    x1 = 312,
    y1 = 75,
    x2 = 342,
    y2 = 105
  },
  {
    x1 = 281,
    y1 = 106,
    x2 = 311,
    y2 = 136
  },
  {
    x1 = 219,
    y1 = 13,
    x2 = 249,
    y2 = 43
  },
  {
    x1 = 2,
    y1 = 106,
    x2 = 32,
    y2 = 136
  },
  {
    x1 = 2,
    y1 = 44,
    x2 = 32,
    y2 = 74
  },
  {
    x1 = 33,
    y1 = 44,
    x2 = 63,
    y2 = 74
  },
  {
    x1 = 2,
    y1 = 44,
    x2 = 32,
    y2 = 74
  },
  {
    x1 = 250,
    y1 = 13,
    x2 = 280,
    y2 = 43
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 219,
    y1 = 75,
    x2 = 249,
    y2 = 105
  },
  {
    x1 = 157,
    y1 = 44,
    x2 = 187,
    y2 = 74
  },
  {
    x1 = 126,
    y1 = 44,
    x2 = 156,
    y2 = 74
  },
  {
    x1 = 126,
    y1 = 106,
    x2 = 156,
    y2 = 136
  },
  {
    x1 = 126,
    y1 = 75,
    x2 = 156,
    y2 = 105
  },
  {
    x1 = 188,
    y1 = 44,
    x2 = 218,
    y2 = 74
  },
  {
    x1 = 219,
    y1 = 44,
    x2 = 249,
    y2 = 74
  },
  {
    x1 = 312,
    y1 = 75,
    x2 = 342,
    y2 = 105
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 64,
    y1 = 137,
    x2 = 94,
    y2 = 167
  },
  {
    x1 = 188,
    y1 = 106,
    x2 = 218,
    y2 = 136
  },
  {
    x1 = 250,
    y1 = 44,
    x2 = 280,
    y2 = 74
  },
  {
    x1 = 33,
    y1 = 106,
    x2 = 63,
    y2 = 136
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 33,
    y1 = 139,
    x2 = 63,
    y2 = 167
  },
  {
    x1 = 250,
    y1 = 44,
    x2 = 280,
    y2 = 74
  },
  {
    x1 = 281,
    y1 = 75,
    x2 = 311,
    y2 = 105
  },
  {
    x1 = 64,
    y1 = 13,
    x2 = 94,
    y2 = 43
  },
  {
    x1 = 312,
    y1 = 44,
    x2 = 342,
    y2 = 74
  },
  {
    x1 = 250,
    y1 = 106,
    x2 = 280,
    y2 = 136
  },
  {
    x1 = 281,
    y1 = 13,
    x2 = 311,
    y2 = 43
  },
  {
    x1 = 64,
    y1 = 44,
    x2 = 94,
    y2 = 74
  },
  {
    x1 = 64,
    y1 = 106,
    x2 = 94,
    y2 = 136
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 157,
    y1 = 13,
    x2 = 187,
    y2 = 43
  },
  {
    x1 = 64,
    y1 = 137,
    x2 = 94,
    y2 = 167
  },
  {
    x1 = 281,
    y1 = 75,
    x2 = 311,
    y2 = 105
  },
  {
    x1 = 95,
    y1 = 106,
    x2 = 125,
    y2 = 136
  },
  {
    x1 = 126,
    y1 = 106,
    x2 = 156,
    y2 = 136
  },
  {
    x1 = 126,
    y1 = 137,
    x2 = 156,
    y2 = 167
  },
  {
    x1 = 0,
    y1 = 0,
    x2 = 0,
    y2 = 0
  },
  {
    x1 = 219,
    y1 = 106,
    x2 = 249,
    y2 = 136
  },
  {
    x1 = 281,
    y1 = 13,
    x2 = 311,
    y2 = 43
  },
  {
    x1 = 157,
    y1 = 106,
    x2 = 187,
    y2 = 136
  }
}
local _desc_Text = {}
local _interaction_Button_Text = {}
local _interactionTargetUIList = {}
local _interactionTargetTextList = {}
local _linkButtonAction = {}
function PanelInteraction:init()
  local eInteractionTypeMax = CppEnums.InteractionType.InteractionType_Count
  for ii = 0, eInteractionTypeMax - 1 do
    _desc_Text[ii] = PAGetString(Defines.StringSheet_GAME, "INTERACTION_TEXT" .. tostring(ii))
  end
  for ii = 0, eInteractionTypeMax - 1 do
    _interaction_Button_Text[ii] = PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU" .. tostring(ii))
  end
  _interactionTargetUIList = {}
  for ii = 0, #_button_TextureUV do
    _interactionTargetUIList[ii] = UI.createAndCopyBasePropertyControl(_panel, "Button_Interaction_Template", _panel, "Button_Interaction_" .. ii)
    self:getButtonIcon(_interactionTargetUIList[ii], ii)
  end
  self._ui.txt_TargetDesc = UI.getChildControl(self._ui.stc_TextBg, "StaticText_Desc")
  self._ui.txt_TargetType = UI.getChildControl(self._ui.stc_TextBg, "StaticText_Type")
  self._ui.txt_TargetName = UI.getChildControl(self._ui.stc_TextBg, "StaticText_Name")
  self._ui.txt_TargetName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  _panel:SetChildIndex(self._ui.needCollectTool, _panel:getChildControlCount() + 1)
  self:registEvent()
  self:tooltipResize_ByFontSize()
  self._firstTextBGSizeX = self._ui.stc_TextBg:GetSizeX()
  self._firstTargetNameSizeX = self._ui.txt_TargetName:GetSizeX()
  PaGlobalFunc_PanelInteraction_RefreshGuideIcon()
end
function PanelInteraction:show(actor)
  local firstInteractionType = actor:getSettedFirstInteractionType()
  self._basicInteractionType = firstInteractionType
  self._focusInteractionType = firstInteractionType
  if nil == _desc_Text[firstInteractionType] then
    return
  end
  _panel:SetShow(true)
  local actor = interaction_getInteractable()
  local actorKey = 0
  local interactableFrag = 0
  local actorName = actor:getName()
  self._ui.stc_TextBg:SetSize(self._firstTextBGSizeX, self._ui.stc_TextBg:GetSizeY())
  self._ui.txt_TargetName:SetSize(self._firstTargetNameSizeX, self._ui.txt_TargetName:GetSizeY())
  self._ui.txt_TargetName:SetSpanSize(self._ui.txt_TargetName:GetSpanSize().x, 20)
  self._ui.txt_TargetType:SetShow(false)
  if actor:get():isInstallationActor() or actor:get():isDeadBody() or actor:get():isCollect() then
    if not actor:get():isMonster() then
      actorName = actor:get():getStaticStatusName()
    end
    isTargetNpc = false
  elseif actor:get():isNpc() then
    local npcTitle = actor:getCharacterTitle()
    if nil ~= npcTitle and "" ~= npcTitle then
      self._ui.txt_TargetType:SetText(npcTitle)
      self._ui.txt_TargetType:SetShow(true)
      self._ui.txt_TargetName:SetSpanSize(self._ui.txt_TargetName:GetSpanSize().x, 30)
    end
    actorName = actor:getName()
    isTargetNpc = true
  elseif actor:get():isHouseHold() then
    if actor:getCharacterStaticStatusWrapper():getObjectStaticStatus():isPersonalTent() then
      actorName = actor:getCharacterStaticStatusWrapper():getName()
    else
      actorName = actor:getAddress()
    end
    isTargetNpc = false
  end
  if nil == actorName then
    UI.ASSERT(false, "panel_interaction_renew : actorName \236\157\180 nil \236\158\133\235\139\136\235\139\164!")
  end
  self._ui.txt_TargetName:SetText(actorName)
  if 2 < self._ui.txt_TargetName:GetLineCount() then
    self._ui.stc_TextBg:SetSize(self._firstTextBGSizeX + 120, self._ui.stc_TextBg:GetSizeY())
    self._ui.txt_TargetName:SetSize(self._firstTargetNameSizeX + 120, self._ui.txt_TargetName:GetSizeY())
    self._ui.txt_TargetName:SetText(actorName)
  end
  if 80 < self._ui.txt_TargetName:GetTextSizeY() then
    self._ui.txt_TargetType:SetPosY(5)
  else
    self._ui.txt_TargetType:SetPosY(20)
  end
  self:updateButtonList(actor)
  self._SHOW_BUTTON_COUNT = 0
  for ii = 0, #_interactionTargetUIList do
    local isShow = actor:isSetInteracatbleFrag(ii)
    if true == ToClient_isConsole() and (CppEnums.InteractionType.InteractionType_PvPBattle == ii or CppEnums.InteractionType.InteractionType_WaitComment == ii) then
      isShow = false
    end
    if true == PaGlobalFunc_InstallationMode_PlantInfo_GetShow() then
      isShow = false
    end
    _interactionTargetUIList[ii]:SetShow(isShow)
    if isShow then
      if CppEnums.InteractionType.InteractionType_Observer == ii then
        local isLean = "LEAN_BACK_ING"
        if ToClient_SelfPlayerCheckAction(isLean) then
          FGlobal_Tutorial_RequestLean()
        end
        local isSitDown = "SIT_DOWN_ING"
        if ToClient_SelfPlayerCheckAction(isSitDown) then
          FGlobal_Tutorial_RequestSitDown()
        end
      end
      if 0 == self._SHOW_BUTTON_COUNT then
        if CppEnums.InteractionType.InteractionType_InvitedParty == ii or CppEnums.InteractionType.InteractionType_GuildInvite == ii or CppEnums.InteractionType.InteractionType_ExchangeItem == ii then
        elseif CppEnums.InteractionType.InteractionType_Talk == ii and actor:getCharacterStaticStatusWrapper():get():isSummonedCharacterBySiegeObject() then
          if true == _ContentsGroup_RenewUI then
          else
          end
        else
          if true == _ContentsGroup_RenewUI then
          else
          end
        end
      else
        local _string = PaGlobalFunc_PanelInteraction_ChangeString(self._SHOW_BUTTON_COUNT)
        if true == _ContentsGroup_RenewUI then
        else
        end
      end
      _linkButtonAction[self._SHOW_BUTTON_COUNT] = ii
      self._SHOW_BUTTON_COUNT = self._SHOW_BUTTON_COUNT + 1
    end
  end
  self._ui.stc_QuestComplete:SetShow(false)
  local npcActorProxyWrapper = getNpcActor(actor:getActorKey())
  if nil ~= npcActorProxyWrapper then
    local currentType = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
    if true == actor:isSetInteracatbleFrag(4) and 3 == currentType then
      self._ui.stc_QuestComplete:SetShow(true)
    end
  end
  self._ui.needCollectTool:SetShow(false)
  self:updateDesc(firstInteractionType)
  self._isButtonAnimating = true
  self._buttonTimeAcc = 0
  PaGlobalFunc_PanelInteraction_ButtonPosUpdate(0)
  self._isReloadState = false
  RemoteControl_Interaction_ShowToggloe()
  FGlobal_Interaction_ClearSelectIndex()
  self._ui.progress_Circle:SetProgressRate(0)
  if 0 == self._SHOW_BUTTON_COUNT then
    self:close()
  else
    _AudioPostEvent_SystemUiForXBOX(53, 5)
  end
end
function PanelInteraction:close()
  if _panel:IsShow() or Panel_Interaction_House:IsShow() then
    _panel:SetShow(false)
    Panel_Interaction_House:SetShow(false)
    self._INTERACTABLE_ACTOR_KEY = 0
    self._INTERACTABLE_FRAG = 0
    Panel_Interaction_HouseRanke_Close()
    PaGlobalFunc_Interaction_HouseList_Close()
    RemoteControl_Interaction_ShowToggloe()
  end
end
function PanelInteraction:updateButtonList(actor)
  for key, value in pairs(_interactionTargetUIList) do
    value:SetShow(false)
  end
end
function PanelInteraction:getButtonInfo(actor, index)
  if nil ~= otherFunctionList[index] then
    return otherFunctionList[index](actor, index)
  end
  return self:getDefaultButtonInfo(actor, index)
end
function PanelInteraction:getDefaultButtonInfo(actor, index)
  return UI_BUTTON[index], self._interaction_Button_Text[index]
end
function PanelInteraction:getButtonIcon(control, index)
  if nil == _button_TextureUV[index] then
    UI.ASSERT(false, "panel_interaction_renew : \237\149\180\235\139\185 \236\157\184\235\141\177\236\138\164\236\157\152 \237\133\141\236\138\164\236\179\144\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164! " .. index)
    return
  end
  local x1, y1, x2, y2 = setTextureUV_Func(control, _button_TextureUV[index].x1, _button_TextureUV[index].y1, _button_TextureUV[index].x2, _button_TextureUV[index].y2)
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function PanelInteraction:tooltipResize_ByFontSize()
end
function PanelInteraction:reload()
  if false == self._isReloadState then
    self:close()
    return
  end
  local actor = interaction_getInteractable()
  if nil == actor then
    self:close()
    return
  end
  if actor:get():isHouseHold() then
    _panel:SetShow(false)
    Panel_Interaction_House:SetShow(false)
    self._INTERACTABLE_ACTOR_KEY = 0
    self._INTERACTABLE_FRAG = 0
    if PaGlobalFunc_PanelInteraction_isShowAble(actor) then
      self:show(actor)
    else
      self:close()
    end
  end
end
function PanelInteraction:updatePerFrame(deltaTime)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer or selfPlayer:isDead() or true == Panel_Window_Exchange:GetShow() or Defines.UIMode.eUIMode_Default ~= GetUIMode() then
    self:close()
    return
  end
  local actor = interaction_getInteractable()
  local actorKey = 0
  local interactableFrag
  if actor ~= nil then
    actorKey = actor:getActorKey()
    interactableFrag = actor:getInteractableFrag()
  end
  if actorKey ~= self._INTERACTABLE_ACTOR_KEY or interactableFrag ~= self._INTERACTABLE_FRAG then
    self._INTERACTABLE_ACTOR_KEY = actorKey
    self._INTERACTABLE_FRAG = interactableFrag
    if PaGlobalFunc_PanelInteraction_isShowAble(actor) then
      self:show(actor)
    else
      self:close()
      return
    end
  end
  if nil ~= actor then
    PaGlobalFunc_PanelInteraction_PositionUpdate(actor)
    if true == _panel:GetShow() and self._isButtonAnimating then
      PaGlobalFunc_PanelInteraction_ButtonPosUpdate(deltaTime)
    end
  end
  self:updatePerFrame_Desc()
end
function PanelInteraction:updatePerFrame_Desc()
  if self._focusInteractionType == CppEnums.InteractionType.InteractionType_Sympathetic then
    self:updateDesc(self._focusInteractionType)
  end
  local actor = interaction_getInteractable()
  if actor == nil then
    return
  end
end
function PanelInteraction:updateDesc(indteractionType)
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  if false == actor:isSetInteracatbleFrag(indteractionType) then
    return
  end
  self._isCanInteraction = true
  local interactionDesc
  if indteractionType == CppEnums.InteractionType.InteractionType_Collect then
    if actor:get():isCollect() or actor:get():isDeadBody() then
      local collectWrapper = getCollectActor(actor:getActorKey())
      if nil == collectWrapper then
        collectWrapper = getMonsterActor(actor:getActorKey())
        if nil == collectWrapper then
          collectWrapper = getDeadBodyActor(actor:getActorKey())
          if nil == collectWrapper then
            _PA_ASSERT(false, "\236\177\132\236\167\145\236\157\184\237\132\176\235\158\153\236\133\152\236\157\132 \236\136\152\237\150\137\236\164\145\236\157\184\235\141\176 \235\140\128\236\131\129\236\157\180 \236\177\132\236\167\145\235\172\188\236\157\180 \236\149\132\235\139\153\235\139\136\235\139\164. \235\185\132\236\160\149\236\131\129\236\158\132")
            return
          end
        end
      end
      if collectWrapper:isCollectable() and false == collectWrapper:isCollectableUsingMyCollectTool() then
        self._ui.needCollectTool:SetShow(true)
        self._isCanInteraction = false
        interactionDesc = ""
        for loop = 0, CppEnums.CollectToolType.TypeCount do
          local isAble = collectWrapper:getCharacterStaticStatusWrapper():isCollectableToolType(loop)
          if isAble then
            if 0 < string.len(interactionDesc) then
              interactionDesc = "<PAColor0xFFFFD649>'" .. interactionDesc .. "'<PAOldColor>, <PAColor0xFFFFD649>'" .. CppEnums.CollectToolTypeName[loop] .. "'<PAOldColor>"
            else
              interactionDesc = "<PAColor0xFFFFD649>'" .. CppEnums.CollectToolTypeName[loop] .. "'<PAOldColor>"
            end
          end
        end
        interactionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_TEXT_NEEDGUIDE", "interactionDesc", interactionDesc)
      end
    end
  elseif indteractionType == CppEnums.InteractionType.InteractionType_Sympathetic then
    local isSympathetic = actor:isSetInteracatbleFrag(CppEnums.InteractionType.InteractionType_Sympathetic)
    if isSympathetic then
      local vehicleWrapper = getVehicleActor(actor:get():getActorKeyRaw())
      if vehicleWrapper ~= nil then
        isSympatheticEnable = vehicleWrapper:checkUsableSympathetic()
        _interactionTargetUIList[CppEnums.InteractionType.InteractionType_Sympathetic]:SetMonoTone(not isSympatheticEnable)
        if not isSympatheticEnable then
          local sympatheticCooltime = math.ceil(vehicleWrapper:getSympatheticCoolTime() / 1000) * 1000
          interactionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SYMPATHETIC_COOLTIME_DESC", "cooltime", convertStringFromMillisecondtime(toUint64(0, sympatheticCooltime)))
        else
          interactionDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SYMPATHETIC_DESC")
        end
      end
    end
  elseif indteractionType == CppEnums.InteractionType.InteractionType_Observer and isObserverMode() then
    if false == _ContentsGroup_RenewUI_WatchMode then
      if indteractionType == basicInteractionType then
        interactionDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_1", "interactionkey", keyCustom_GetWSymbol_ActionPad(CppEnums.ActionInputType.ActionInputType_Interaction), "interaction", interactionTargetTextList[indteractionType])
      else
        interactionDesc = _desc_Text[indteractionType]
      end
      ShowCommandFunc()
    else
      _panel:SetShow(false)
    end
  end
  if nil == interactionDesc or "" == interactionDesc then
    self._ui.txt_TargetDesc:SetShow(false)
  else
    if 80 < self._ui.txt_TargetName:GetTextSizeY() then
      self._ui.txt_TargetDesc:SetPosY(5)
    else
      self._ui.txt_TargetDesc:SetPosY(20)
    end
    self._ui.txt_TargetName:SetSpanSize(self._ui.txt_TargetName:GetSpanSize().x, 30)
    self._ui.txt_TargetDesc:SetText(interactionDesc)
    self._ui.txt_TargetDesc:SetShow(true)
  end
  self._ui.txt_SelectedTitle:SetText(_interaction_Button_Text[indteractionType])
end
function PanelInteraction:registEvent()
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_PanelInteraction_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_PanelInteraction_HideAni()")
  registerEvent("FromClient_InterAction_UpdatePerFrame", "FromClient_PanelInteraction_Update")
  registerEvent("FromClient_InteractionFail", "FromClient_PanelInteraction_Fail")
  registerEvent("FromClient_ReceiveBuyHouse", "PaGlobalFunc_PanelInteraction_SetReloadState")
  registerEvent("FromClient_ReceiveChangeUseType", "PaGlobalFunc_PanelInteraction_SetReloadState")
  registerEvent("FromClient_ReceiveReturnHouse", "PaGlobalFunc_PanelInteraction_SetReloadState")
  registerEvent("FromClient_ReceiveSetMyHouse", "PaGlobalFunc_PanelInteraction_SetReloadState")
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_PanelInteraction")
  registerEvent("FromClient_InteractionHarvest", "FromClient_PanelInteraction_Harvest")
  registerEvent("FromClient_InteractionSeedHarvest", "FromClient_PanelInteraction_SeedHarvest")
  registerEvent("FromClient_InteractionBuildingUpgrade", "FromClient_PanelInteraction_BuildingUpgrade")
  registerEvent("FromClient_InteractionSiegeObject", "FromClient_PanelInteraction_SiegeObject")
  registerEvent("FromClient_ConfirmInstallationBuff", "FromClient_PanelInteraction_InstallationBuff")
  registerEvent("EventEquipmentUpdate", "interaction_Forceed")
end
function PaGlobalFunc_PanelInteraction_Init()
  local self = PanelInteraction
  self:init()
end
function PaGlobalFunc_PanelInteraction_isShowAble(actor)
  if nil == actor then
    return false
  else
    return interaction_showableCheck(actor:get())
  end
end
function PaGlobalFunc_PanelInteraction_PositionUpdate(actor)
  local pos2d = actor:get2DPosForInterAction()
  if pos2d.x < 0 and 0 > pos2d.y then
    if Panel_Interaction_House:IsShow() then
      Panel_Interaction_House:SetPosX(-1000)
      Panel_Interaction_House:SetPosY(-1000)
    end
    _panel:SetPosX(-1000)
    _panel:SetPosY(-1000)
  else
    if Panel_Interaction_House:IsShow() then
      Panel_Interaction_House:SetPosX(pos2d.x - Panel_Interaction_House:GetSizeX() / 2)
      Panel_Interaction_House:SetPosY(pos2d.y + 100)
    end
    _panel:SetPosX(pos2d.x + 0)
    _panel:SetPosY(pos2d.y - 150)
  end
end
function PaGlobalFunc_PanelInteraction_ButtonPosUpdate(deltaTime)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  local ANIMATION_TIME = 0.35
  local BUTTON_OFFSET_X = 75
  local BUTTON_OFFSET_Y = 75
  local CIRCLE_RADIUS = 65
  local ANGLE_OFFSET = math.pi * -0.5
  if ANIMATION_TIME < self._buttonTimeAcc then
    self._isButtonAnimating = false
  else
    self._buttonTimeAcc = self._buttonTimeAcc + deltaTime
    local aniRate = self._buttonTimeAcc / ANIMATION_TIME
    if aniRate > 1 then
      aniRate = 1
    end
    local actor = interaction_getInteractable()
    local jj = 0
    for ii = 0, #_interactionTargetUIList do
      local isShow = actor:isSetInteracatbleFrag(ii)
      if true == isShow then
        local div = jj / self._SHOW_BUTTON_COUNT
        local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * aniRate * math.cos(math.pi * 2 * div * aniRate + ANGLE_OFFSET)
        local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * aniRate * math.sin(math.pi * 2 * div * aniRate + ANGLE_OFFSET)
        _interactionTargetUIList[ii]:SetPosX(buttonPosX)
        _interactionTargetUIList[ii]:SetPosY(buttonPosY)
        _interactionTargetUIList[ii]:SetAlpha(aniRate)
        self._ui.needCollectTool:SetPosX(buttonPosX + 2)
        self._ui.needCollectTool:SetPosY(buttonPosY + 2)
        jj = jj + 1
      end
    end
  end
end
function PaGlobalFunc_PanelInteraction_ButtonPushed(interactionType)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  if true == FGlobal_GetIsCutScenePlay() then
    return
  end
  self._preUIMode = GetUIMode()
  local isTakedownCannon = false
  if CppEnums.InteractionType.InteractionType_TakedownCannon == interactionType then
    isTakedownCannon = true
  elseif CppEnums.InteractionType.InteractionType_Talk == interactionType then
    SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  elseif CppEnums.InteractionType.InteractionType_InvitedParty == interactionType then
    if false == ToClient_isCommunicationAllowed() then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
        content = messageBoxMemo,
        functionYes = MessageBox_Empty_function,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      ToClient_showPrivilegeError()
      return
    end
    local actor = interaction_getInteractable()
    if nil == actor then
      return
    else
      local targetName = actor:getName()
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_ACK_INVITE", "targetName", targetName))
    end
  elseif CppEnums.InteractionType.InteractionType_UseItem == interactionType and true == isCurrentPositionInWater() then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_USEITEM_INTERACTION_IN_WATER"))
    return
  elseif CppEnums.InteractionType.InteractionType_PvPBattle == interactionType then
    if true == ToClient_isConsole() then
      return
    end
    local actor = interaction_getInteractable()
    if nil == actor then
      return
    elseif true == ToClient_doExistWorldBossMonster() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoPVPMatchCantBossMonster"))
    else
      local targetCharacterName = actor:getOriginalName()
      PaGlobal_PvPBattle:notifyRequest(targetCharacterName)
    end
  elseif CppEnums.InteractionType.InteractionType_InstallationMode == interactionType then
    if getInputMode() == CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOT_ENTER_HOUSINGMODE_CHATMODE"))
      return
    end
  elseif CppEnums.InteractionType.InteractionType_Collect == interactionType then
    local actorWrapper = interaction_getInteractable()
    if nil ~= actorWrapper then
      local charWrapper = actorWrapper:getCharacterStaticStatusWrapper()
      if nil ~= charWrapper and true == charWrapper:isAttrSet(__eHoeMiniGameCharacter) and nil ~= getSelfPlayer() then
        local playerWp = getSelfPlayer():getWp()
        local needWp = ToClient_CheckMiniGameFindWp(charWrapper:getCharacterKey())
        if playerWp < needWp then
          local charName = charWrapper:getName()
          local failMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_WPHELP", "name", charName)
          Proc_ShowMessage_Ack(failMsg)
          return
        end
        if __eWeightLevel3 <= getWeightLevel() then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoItemIsTooHeavy"))
          return
        end
      end
    end
  elseif CppEnums.InteractionType.InteractionType_GuildInvite == interactionType or CppEnums.InteractionType.InteractionType_ClanInvite == interactionType then
    local guildInfo = ToClient_GetMyGuildInfoWrapper()
    if guildInfo:getJoinableMemberCount() <= guildInfo:getMemberCount() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_GUILDINVITE_CANNOTJOINNOMORE"))
      return
    end
  end
  local function isTakedownCannonFuncPass()
    interaction_processInteraction(interactionType)
  end
  if true == isTakedownCannon then
    local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "INTERACTION_TEXT_TAKEDOWN_CANNON")
    local messageBoxData = {
      title = messageTitle,
      content = messageBoxMemo,
      functionYes = isTakedownCannonFuncPass,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    interaction_processInteraction(interactionType)
  end
end
function Interaction_Close()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self:close()
end
function Interaction_Show(actor)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self:show(actor)
end
function Interaction_Reset()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self._INTERACTABLE_ACTOR_KEY = 0
end
function interaction_Forceed()
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  if false == _panel:GetShow() then
    return
  end
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  local actorKey = actor:getActorKey()
  local interactableFrag = actor:getInteractableFrag()
  self._INTERACTABLE_ACTOR_KEY = actorKey
  self._INTERACTABLE_FRAG = interactableFrag
  if PaGlobalFunc_PanelInteraction_isShowAble(actor) then
    self:show(actor)
  else
    self:close()
  end
  PaGlobalFunc_PanelInteraction_PositionUpdate(actor)
  PaGlobalFunc_PanelInteraction_ButtonPosUpdate(0)
end
function FGlobal_InteractionButtonActionRun(keyIdx)
  PaGlobalFunc_PanelInteraction_ButtonPushed(_linkButtonAction[keyIdx])
end
function PaGlobalFunc_PanelInteraction_ChangeString(index)
  local _string = "F6"
  if 1 == index then
    _string = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Interaction_1)
  elseif 2 == index then
    _string = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Interaction_2)
  elseif 3 == index then
    _string = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Interaction_3)
  elseif 4 == index then
    _string = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Interaction_4)
  elseif 5 == index then
    _string = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Interaction_5)
  end
  return _string
end
function PaGlobalFunc_PanelInteraction_TypeCheck(interactionType)
  if interactionType == CppEnums.InteractionType.InteractionType_ExchangeItem or interactionType == CppEnums.InteractionType.InteractionType_InvitedParty or interactionType == CppEnums.InteractionType.InteractionType_GuildInvite then
    if true == ToClient_isConsole() then
      return false
    else
      return true
    end
  end
  return false
end
function PaGlobal_Interaction_GetShow()
  return _panel:GetShow()
end
function FGlobal_Interaction_CheckAndGetPressedKeyCode()
  if true == ToClient_isConsole() then
    return
  end
  local keyCode = CppEnums.ActionInputType.ActionInputType_Interaction
  if keyCustom_IsDownOnce_Action(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.UiInputType.UiInputType_Interaction_1
  if GlobalKeyBinder_CheckCustomKeyPressed(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.UiInputType.UiInputType_Interaction_2
  if GlobalKeyBinder_CheckCustomKeyPressed(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.UiInputType.UiInputType_Interaction_3
  if GlobalKeyBinder_CheckCustomKeyPressed(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.UiInputType.UiInputType_Interaction_4
  if GlobalKeyBinder_CheckCustomKeyPressed(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.UiInputType.UiInputType_Interaction_5
  if GlobalKeyBinder_CheckCustomKeyPressed(keyCode) then
    return keyCode
  end
  keyCode = CppEnums.VirtualKeyCode.KeyCode_F10
  if GlobalKeyBinder_CheckKeyPressed(CppEnums.VirtualKeyCode.KeyCode_F10) then
    return keyCode
  end
  return nil
end
function Interaction_ExecuteByKeyMapping(keycode)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self._ui.progress_Circle:SetProgressRate(0)
  local buttonCount = self._SHOW_BUTTON_COUNT
  DragManager:clearInfo()
  if keycode ~= CppEnums.ActionInputType.ActionInputType_Interaction then
    setUiInputProcessed(keycode)
  end
  if keycode == CppEnums.ActionInputType.ActionInputType_Interaction then
    local camBlur = getCameraBlur()
    local interactableActor = interaction_getInteractable()
    if interactableActor ~= nil and (not interactableActor:get():isPlayer() or interactableActor:get():isSelfPlayer()) and camBlur <= 0 then
      local interactionType = interactableActor:getSettedFirstInteractionType()
      if true == PaGlobalFunc_PanelInteraction_TypeCheck(interactionType) then
        return
      end
      PaGlobalFunc_PanelInteraction_ButtonPushed(interactionType)
      return
    elseif interactableActor ~= nil and interactableActor:get():isPlayer() and camBlur <= 0 then
      local interactionType = interactableActor:getSettedFirstInteractionType()
      if true == PaGlobalFunc_PanelInteraction_TypeCheck(interactionType) then
        return
      end
      PaGlobalFunc_PanelInteraction_ButtonPushed(interactionType)
      return
    end
  elseif keycode == CppEnums.UiInputType.UiInputType_Interaction_1 then
    if buttonCount >= 2 then
      FGlobal_InteractionButtonActionRun(1)
      return
    end
  elseif keycode == CppEnums.UiInputType.UiInputType_Interaction_2 then
    if buttonCount >= 3 then
      FGlobal_InteractionButtonActionRun(2)
      return
    end
  elseif keycode == CppEnums.UiInputType.UiInputType_Interaction_3 then
    if buttonCount >= 4 then
      FGlobal_InteractionButtonActionRun(3)
      return
    end
  elseif keycode == CppEnums.UiInputType.UiInputType_Interaction_4 then
    if buttonCount >= 5 then
      FGlobal_InteractionButtonActionRun(4)
      return
    end
  elseif keycode == CppEnums.UiInputType.UiInputType_Interaction_5 then
    if buttonCount >= 6 then
      FGlobal_InteractionButtonActionRun(5)
      return
    end
  elseif keycode == CppEnums.VirtualKeyCode.KeyCode_F10 and buttonCount >= 7 then
    FGlobal_InteractionButtonActionRun(6)
    return
  end
end
function Interaction_ButtonPushed(interactionType)
  PaGlobalFunc_PanelInteraction_ButtonPushed(interactionType)
end
function FromClient_PanelInteraction_Update(deltaTime)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self:updatePerFrame(deltaTime)
end
function FromClient_PanelInteraction_Fail()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  if Defines.UIMode.eUIMode_DeadMessage == GetUIMode() then
    sself._preUIMode = nil
    return
  end
  if nil == self._preUIMode then
    return
  end
  SetUIMode(self._preUIMode)
end
function FromClient_PanelInteraction_Harvest()
  interaction_setInteractingState(CppEnums.InteractionType.InteractionType_Havest)
end
function FromClient_PanelInteraction_SeedHarvest()
  interaction_setInteractingState(CppEnums.InteractionType.InteractionType_SeedHavest)
end
function FromClient_PanelInteraction_BuildingUpgrade(actorKeyRaw)
  local actorProxy = getActor(actorKeyRaw)
  if nil == actorProxy then
    return
  end
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  local upgradeStaticWrapper = actorProxy:getCharacterStaticStatusWrapper():getBuildingUpgradeStaticStatus()
  if nil == upgradeStaticWrapper then
    _PA_ASSERT(false, "FromClient_PanelInteraction_BuildingUpgrade : upgradeStaticWrapper\236\157\180 \235\185\132\236\150\180\236\158\136\236\138\181\235\139\136\235\139\164. ")
    return
  end
  if nil == upgradeStaticWrapper:getTargetCharacter() then
    _PA_ASSERT(false, "FromClient_PanelInteraction_BuildingUpgrade : upgradeStaticWrapper:getTargetCharacter()\236\157\180 \235\185\132\236\150\180\236\158\136\236\138\181\235\139\136\235\139\164. ")
    return
  end
  local strNeedItems = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_UPGRADE_BARRICADE", "getName", upgradeStaticWrapper:getTargetCharacter():getName())
  local tempStr = ""
  local sourceItemCount = upgradeStaticWrapper:getSourceItemCount()
  for index = 0, sourceItemCount - 1 do
    local iessw = upgradeStaticWrapper:getSourceItemEnchantStaticStatus(index)
    if nil ~= iessw then
      local itemNeedCount = upgradeStaticWrapper:getSourceItemNeedCount(index)
      local itemName = iessw:getName()
      local territoryComma = ", "
      if "" == tempStr then
        territoryComma = ""
      end
      tempStr = tempStr .. " " .. territoryComma .. "[<PAColor0xFFE49800>" .. itemName .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIVEMENT_ITEMCOUNT", "count", tostring(itemNeedCount)) .. "<PAOldColor>]"
    end
  end
  self._buildingUpgradeActoKeyRaw = actorKeyRaw
  local messageBoxMemo = strNeedItems .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_UPGRADE_BARRICADE_NEEDITEMS", "strNeedItems", tempStr)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_UPGRADE_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_PanelInteraction_BuildingUpgrade_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function renderModeChange_PanelInteraction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self:reload()
end
function PaGlobalFunc_PanelInteraction_BuildingUpgrade_Confirm()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  toClient_RequestBuildingUpgrade(self._buildingUpgradeActoKeyRaw)
end
function FromClient_PanelInteraction_SiegeObject(actorKeyRaw, funcState)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  local actorProxy = actorProxyWrapper:get()
  self._buildingUpgradeActoKeyRaw = actorKeyRaw
  if 0 == funcState then
    local price = Int64toInt32(actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():getUsingPrice())
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_DESC2", "price", makeDotMoney(price))
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_PanelInteraction_SiegeObjectControlStart_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isElephantBarn() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_ELEPHANTBARN_MEMO_DESC")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_PanelInteraction_SiegeObjectControlFinish_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_DESC")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = PaGlobalFunc_PanelInteraction_SiegeObjectControlFinish_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function PaGlobalFunc_PanelInteraction_SiegeObjectControlStart_Confirm()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  toClient_RequestSiegeObjectControlStart(self._buildingUpgradeActoKeyRaw)
end
function PaGlobalFunc_PanelInteraction_SiegeObjectControlFinish_Confirm()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  toClient_RequestSiegeObjectControlFinish(self._buildingUpgradeActoKeyRaw)
end
function FromClient_PanelInteraction_InstallationBuff(currentEndurance)
  if MessageBox.isPopUp() then
    return
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_MEMO_BUFF", "currentEndurance", tostring(currentEndurance))
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_DATA_TITLE"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_Interaction_InstallationBuffConfirm,
    functionNo = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_Interaction_InstallationBuffConfirm()
  toClient_RequestInstallationBuff()
end
function PaGlobalFunc_PanelInteraction_SetReloadState()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return
  end
  self._isReloadState = true
  if false == isFlushedUI() then
    self:reload()
  end
end
function PaGlobalFunc_PanelInteraction_ShowAni()
end
function PaGlobalFunc_PanelInteraction_HideAni()
end
local _currentInteractionSelectIndex = 0
local _currentInteractionKeyPressedTime = 0
local _xboxInteractionAvailable = false
local _isInteractionRolling = false
local _roleCheckTimeAcc = 0
local _isPressingY = false
local _rollingTime = 0.2
function FGlobal_Interaction_CheckAndGetPressedKeyCode_Xbox(deltaTime)
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return nil
  end
  if false == PaGlobalFunc_Fishing_GetFishingMiniGame_3() then
    return
  end
  self._ui.stc_Key:SetMonoTone(false)
  local isLean = "LEAN_BACK_ING"
  if true == ToClient_SelfPlayerCheckAction(isLean) and true == FGlobal_ConsoleQuickMenu_IsShow() then
    self._ui.stc_Key:SetMonoTone(true)
    _xboxInteractionAvailable = false
    self:updatePressedInteractionKey(0)
    self._ui.txt_HoldToInteract:SetShow(true)
    return
  end
  if getInputMode() ~= CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode or false == self._isCanInteraction then
    self._ui.stc_Key:SetMonoTone(true)
    return nil
  end
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    self:updatePressedInteractionKey(0)
    _currentInteractionKeyPressedTime = 0
    _xboxInteractionAvailable = true
    if deltaTime > 0.01 then
      _AudioPostEvent_SystemUiForXBOX(50, 0)
      _isPressingY = true
    end
    self._ui.txt_HoldToInteract:SetShow(false)
  elseif keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    _currentInteractionKeyPressedTime = _currentInteractionKeyPressedTime + deltaTime
    if _currentInteractionKeyPressedTime > 0.5 then
      if false == _xboxInteractionAvailable then
        return nil
      end
      _xboxInteractionAvailable = false
      local keyCodeTable = {
        [0] = CppEnums.ActionInputType.ActionInputType_Interaction,
        [1] = CppEnums.UiInputType.UiInputType_Interaction_1,
        [2] = CppEnums.UiInputType.UiInputType_Interaction_2,
        [3] = CppEnums.UiInputType.UiInputType_Interaction_3,
        [4] = CppEnums.UiInputType.UiInputType_Interaction_4,
        [5] = CppEnums.UiInputType.UiInputType_Interaction_5,
        [6] = CppEnums.VirtualKeyCode.KeyCode_F10
      }
      local keycode = keyCodeTable[_currentInteractionSelectIndex]
      self:updatePressedInteractionKey(0)
      self._ui.txt_HoldToInteract:SetShow(true)
      return keycode
    else
      self:updatePressedInteractionKey(_currentInteractionKeyPressedTime)
    end
  elseif keyCustom_IsUp_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    if _currentInteractionKeyPressedTime < 0.1 and 1 < self._SHOW_BUTTON_COUNT and false == self._isButtonAnimating then
      _isInteractionRolling = true
    end
    _currentInteractionKeyPressedTime = 0
    _xboxInteractionAvailable = false
    self:updatePressedInteractionKey(0)
    self._ui.txt_HoldToInteract:SetShow(true)
  end
  if true == _isInteractionRolling then
    _AudioPostEvent_SystemUiForXBOX(50, 4)
    _currentInteractionKeyPressedTime = 0
    PanelInteraction:RollingAnimation(deltaTime)
  end
  return nil
end
function PanelInteraction:RollingAnimation(deltaTime)
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  _roleCheckTimeAcc = _roleCheckTimeAcc + deltaTime
  local BUTTON_OFFSET_X = 75
  local BUTTON_OFFSET_Y = 75
  local CIRCLE_RADIUS = 65
  local ANGLE_OFFSET = math.pi * -0.5
  local div = 1 / self._SHOW_BUTTON_COUNT
  local btnIdx = -_currentInteractionSelectIndex % self._SHOW_BUTTON_COUNT
  for ii = 0, #_interactionTargetUIList do
    local isShow = _interactionTargetUIList[ii]:GetShow()
    if isShow then
      local ANGLE_OFFSET = math.pi * (2 * btnIdx / self._SHOW_BUTTON_COUNT - 0.5)
      local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * math.cos(math.pi * 2 * div * -(_roleCheckTimeAcc / _rollingTime) + ANGLE_OFFSET)
      local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * math.sin(math.pi * 2 * div * -(_roleCheckTimeAcc / _rollingTime) + ANGLE_OFFSET)
      _interactionTargetUIList[ii]:SetPosX(buttonPosX)
      _interactionTargetUIList[ii]:SetPosY(buttonPosY)
      self._ui.needCollectTool:SetPosX(buttonPosX + 2)
      self._ui.needCollectTool:SetPosY(buttonPosY + 2)
      btnIdx = (btnIdx + 1) % self._SHOW_BUTTON_COUNT
    end
  end
  if _rollingTime < _roleCheckTimeAcc then
    _roleCheckTimeAcc = 0
    self:IncreaseSelectIndex()
    _isInteractionRolling = false
  end
end
function PanelInteraction:IncreaseSelectIndex()
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  _currentInteractionSelectIndex = (_currentInteractionSelectIndex + 1) % self._SHOW_BUTTON_COUNT
  local BUTTON_OFFSET_X = 75
  local BUTTON_OFFSET_Y = 75
  local CIRCLE_RADIUS = 65
  local ANGLE_OFFSET = math.pi * -0.5
  local jj = -_currentInteractionSelectIndex % self._SHOW_BUTTON_COUNT
  for ii = 0, #_interactionTargetUIList do
    local isShow = _interactionTargetUIList[ii]:GetShow()
    if isShow then
      local div = jj / self._SHOW_BUTTON_COUNT
      local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * math.cos(math.pi * 2 * div + ANGLE_OFFSET)
      local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * math.sin(math.pi * 2 * div + ANGLE_OFFSET)
      _interactionTargetUIList[ii]:SetPosX(buttonPosX)
      _interactionTargetUIList[ii]:SetPosY(buttonPosY)
      self._ui.needCollectTool:SetPosX(buttonPosX + 2)
      self._ui.needCollectTool:SetPosY(buttonPosY + 2)
      if 0 == div then
        self:updateDesc(ii)
      end
      jj = (jj + 1) % self._SHOW_BUTTON_COUNT
    end
  end
end
function FGlobal_Interaction_ClearSelectIndex()
  _currentInteractionSelectIndex = 0
  _xboxInteractionAvailable = false
end
function PanelInteraction:updatePressedInteractionKey(time)
  if true == _xboxInteractionAvailable then
    if time < 0.2 then
      self._ui.progress_Circle:SetShow(false)
      return
    end
    self._ui.progress_Circle:SetShow(true)
  else
    self._ui.progress_Circle:SetShow(false)
  end
  self._ui.progress_Circle:SetProgressRate((time - 0.2) * 333)
end
function PaGlobalFunc_PanelInteraction_RefreshGuideIcon()
  local self = PanelInteraction
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : PanelInteraction")
    return nil
  end
  PaGlobalFunc_ConsoleKeyGuide_SetControlIconWithActionType(self._ui.stc_Key, CppEnums.ActionInputType.ActionInputType_Interaction)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_PanelInteraction_Init")
