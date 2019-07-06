local UI_Color = Defines.Color
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local _needCollectTool = UI.getChildControl(LobbyInstance_Interaction, "Static_Cant")
local _background = UI.getChildControl(LobbyInstance_Interaction, "Static_Background")
_background:setGlassBackground(true)
local _globalGuide = UI.getChildControl(LobbyInstance_Interaction, "StaticText_Purpose")
local _circularProgressBarInteraction = UI.getChildControl(LobbyInstance_Interaction, "CircularProgress_Press")
local _circularProgressBarStaticbgInteraction = UI.getChildControl(LobbyInstance_Interaction, "Static_CircleProgress_PressBG")
LobbyInstance_Interaction:RegisterShowEventFunc(true, "Panel_Interaction_ShowAni()")
LobbyInstance_Interaction:RegisterShowEventFunc(false, "Panel_Interaction_HideAni()")
local pcExchangeDisableTime = 60
function Panel_Interaction_ShowAni()
end
function Panel_Interaction_HideAni()
end
local eInteractionTypeMax = CppEnums.InteractionType.InteractionType_Count
local preUIMode
local DESC_TEXT = {}
for ii = 0, eInteractionTypeMax - 1 do
  DESC_TEXT[ii] = PAGetString(Defines.StringSheet_GAME, "INTERACTION_TEXT" .. tostring(ii))
end
INETRACTION_BUTTON_TEXT = {}
for ii = 0, eInteractionTypeMax - 1 do
  INETRACTION_BUTTON_TEXT[ii] = PAGetString(Defines.StringSheet_GAME, "INTERACTION_MENU" .. tostring(ii))
end
local BUTTON_ID = {
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
local UI_BUTTON = {}
for ii = 0, #BUTTON_ID do
  UI_BUTTON[ii] = UI.getChildControl(LobbyInstance_Interaction, BUTTON_ID[ii])
  UI_BUTTON[ii]:addInputEvent("Mouse_LUp", "Interaction_ButtonPushed(" .. ii .. ")")
  UI_BUTTON[ii]:addInputEvent("Mouse_On", "Interaction_ButtonOver(" .. ii .. ", true)")
  UI_BUTTON[ii]:addInputEvent("Mouse_Out", "Interaction_ButtonOver(" .. ii .. ", false)")
  UI_BUTTON[ii]:SetText(INETRACTION_BUTTON_TEXT[ii])
  UI_BUTTON[ii]:SetFontAlpha(1)
  UI_BUTTON[ii]:SetShow(false)
end
local function getDefaultButtonInfo(actor, index)
  return UI_BUTTON[index], INETRACTION_BUTTON_TEXT[index]
end
local interactionTargetUIList = {}
local interactionTargetTextList = {}
local otherUIList = {
  [CppEnums.InteractionType.InteractionType_HavestLop] = UI.getChildControl(LobbyInstance_Interaction, "Button_KillBugs"),
  [CppEnums.InteractionType.InteractionType_HavestKillBug] = UI.getChildControl(LobbyInstance_Interaction, "Button_Feeding"),
  [CppEnums.InteractionType.InteractionType_HarvestInformation] = UI.getChildControl(LobbyInstance_Interaction, "Button_DomesticAnimalInfo")
}
otherUIList[32]:addInputEvent("Mouse_LUp", "Interaction_ButtonPushed(" .. 32 .. ")")
otherUIList[32]:addInputEvent("Mouse_On", "Interaction_ButtonOver(" .. 32 .. ", true)")
otherUIList[32]:addInputEvent("Mouse_Out", "Interaction_ButtonOver(" .. 32 .. ", false)")
otherUIList[32]:SetShow(false)
otherUIList[33]:addInputEvent("Mouse_LUp", "Interaction_ButtonPushed(" .. 33 .. ")")
otherUIList[33]:addInputEvent("Mouse_On", "Interaction_ButtonOver(" .. 33 .. ", true)")
otherUIList[33]:addInputEvent("Mouse_Out", "Interaction_ButtonOver(" .. 33 .. ", false)")
otherUIList[33]:SetShow(false)
otherUIList[37]:addInputEvent("Mouse_LUp", "Interaction_ButtonPushed(" .. 37 .. ")")
otherUIList[37]:addInputEvent("Mouse_On", "Interaction_ButtonOver(" .. 37 .. ", true)")
otherUIList[37]:addInputEvent("Mouse_Out", "Interaction_ButtonOver(" .. 37 .. ", false)")
otherUIList[37]:SetShow(false)
local otherTextList = {
  [CppEnums.InteractionType.InteractionType_HavestLop] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_4"),
  [CppEnums.InteractionType.InteractionType_HavestKillBug] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_5"),
  [CppEnums.InteractionType.InteractionType_HarvestInformation] = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTIONBUTTON_NAME_DOMESTICANIMALINFO")
}
local otherFunctionList = {
  [32] = function(actor, index)
    if nil == actor then
      return getDefaultButtonInfo(actor, index)
    end
    local installationActorWrapper = getInstallationActorByProxy(actor:get())
    if nil == installationActorWrapper then
      return getDefaultButtonInfo(actor, index)
    end
    local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
    if CppEnums.InstallationType.eType_LivestockHarvest ~= installationType then
      return getDefaultButtonInfo(actor, index)
    end
    if nil == otherUIList[index] or nil == otherTextList[index] then
      return getDefaultButtonInfo(actor, index)
    end
    return otherUIList[CppEnums.InteractionType.InteractionType_HavestLop], otherTextList[CppEnums.InteractionType.InteractionType_HavestLop]
  end,
  [33] = function(actor, index)
    if nil == actor then
      return getDefaultButtonInfo(actor, index)
    end
    local installationActorWrapper = getInstallationActorByProxy(actor:get())
    if nil == installationActorWrapper then
      return getDefaultButtonInfo(actor, index)
    end
    local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
    if CppEnums.InstallationType.eType_LivestockHarvest ~= installationType then
      return getDefaultButtonInfo(actor, index)
    end
    if nil == otherUIList[index] or nil == otherTextList[index] then
      return getDefaultButtonInfo(actor, index)
    end
    return otherUIList[CppEnums.InteractionType.InteractionType_HavestKillBug], otherTextList[CppEnums.InteractionType.InteractionType_HavestKillBug]
  end,
  [37] = function(actor, index)
    if nil == actor then
      return getDefaultButtonInfo(actor, index)
    end
    local installationActorWrapper = getInstallationActorByProxy(actor:get())
    if nil == installationActorWrapper then
      return getDefaultButtonInfo(actor, index)
    end
    local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
    if CppEnums.InstallationType.eType_LivestockHarvest ~= installationType then
      return getDefaultButtonInfo(actor, index)
    end
    if nil == otherUIList[index] or nil == otherTextList[index] then
      return getDefaultButtonInfo(actor, index)
    end
    return otherUIList[CppEnums.InteractionType.InteractionType_HarvestInformation], otherTextList[CppEnums.InteractionType.InteractionType_HarvestInformation]
  end
}
local function getButtonInfo(actor, index)
  if nil ~= otherFunctionList[index] then
    return otherFunctionList[index](actor, index)
  end
  return getDefaultButtonInfo(actor, index)
end
local function updateButtonList(actor)
  for key, value in pairs(interactionTargetUIList) do
    value:SetShow(false)
  end
  interactionTargetUIList = {}
  interactionTargetTextList = {}
  interactionTargetUIList[3], interactionTargetTextList[3] = getButtonInfo(actor, 3)
end
UI.getChildControl(LobbyInstance_Interaction, "Button_Hunting"):SetShow(false)
UI.getChildControl(LobbyInstance_Interaction, "Button_VehicleTraining"):SetShow(false)
local UI_NAME = UI.getChildControl(LobbyInstance_Interaction, "Static_Text_CharacterName")
local UI_DESC = UI.getChildControl(LobbyInstance_Interaction, "Static_Icon_Font")
local INTERACTABLE_ACTOR_KEY = 0
local INTERACTABLE_FRAG = 0
local SHOW_BUTTON_COUNT = 0
local ANIMATING_BUTTON = false
local BUTTON_UPDATE_TIME = 0
local basicInteractionType = 0
local focusInteractionType = 0
local isFocusInteractionType = false
local isTargetNpc = false
local interactionShowableCheck = function(actor)
  if nil == actor then
    return false
  else
    return interaction_showableCheck(actor:get())
  end
end
local interactionTutorial = true
function Interaction_Update(deltaTime)
  local selfPlayer = getSelfPlayer()
  if selfPlayer == nil or selfPlayer:isDead() or Instance_Looting:GetShow() or Defines.UIMode.eUIMode_Default ~= GetUIMode() then
    Interaction_Close()
    return
  end
  local actor = interaction_getInteractable()
  local actorKey = 0
  local interactableFrag
  if actor ~= nil then
    actorKey = actor:getActorKey()
    interactableFrag = actor:getInteractableFrag()
  end
  if actorKey ~= INTERACTABLE_ACTOR_KEY or interactableFrag ~= INTERACTABLE_FRAG then
    INTERACTABLE_ACTOR_KEY = actorKey
    INTERACTABLE_FRAG = interactableFrag
    if interactionShowableCheck(actor) then
      Interaction_Show(actor)
    else
      Interaction_Close()
      return
    end
  end
  if nil ~= actor then
    Interaction_PositionUpdate(actor)
    if LobbyInstance_Interaction:GetShow() and ANIMATING_BUTTON then
      Interaction_ButtonPositionUpdate(deltaTime)
    end
  end
  Interaction_UpdatePerFrame_Desc()
end
function interaction_Forceed()
  local actor = interaction_getInteractable()
  local actorKey = 0
  local interactableFrag = 0
  if nil ~= actor then
    actorKey = actor:getActorKey()
    interactableFrag = actor:getInteractableFrag()
    INTERACTABLE_ACTOR_KEY = actorKey
    INTERACTABLE_FRAG = interactableFrag
    if interactionShowableCheck(actor) then
      Interaction_Show(actor)
    else
      Interaction_Close()
    end
    Interaction_PositionUpdate(actor)
    Interaction_ButtonPositionUpdate(0)
  else
    return
  end
end
local GetBottomPos = function(control)
  if nil == control then
    UI.ASSERT(false, "GetBottomPos(control) , control nil")
    return
  end
  return control:GetPosY() + control:GetSizeY()
end
local YSize = 0
local linkButtonAction = {}
function Interaction_Show(actor)
  audioPostEvent_SystemUi(1, 5)
  firstInteractionType = 3
  basicInteractionType = firstInteractionType
  focusInteractionType = firstInteractionType
  if DESC_TEXT[firstInteractionType] == nil then
    return
  end
  if false == actor:get():isPlayer() then
    return
  end
  LobbyInstance_Interaction:SetShow(true)
  local actorName = actor:getName()
  UI_NAME:SetSize(100, UI_NAME:GetSizeY())
  UI_NAME:SetPosX(-56)
  UI_NAME:SetTextHorizonCenter()
  UI_NAME:SetTextVerticalTop()
  UI_NAME:SetAutoResize(true)
  UI_NAME:SetText(actorName)
  UI_DESC:SetText(DESC_TEXT[firstInteractionType])
  updateButtonList(actor)
  SHOW_BUTTON_COUNT = 0
  for ii, v in pairs(interactionTargetUIList) do
    local isShow = actor:isSetInteracatbleFrag(ii)
    interactionTargetUIList[ii]:SetShow(isShow)
    if isShow then
      if CppEnums.InteractionType.InteractionType_ExchangeItem == ii then
        interactionTargetUIList[ii]:SetAutoDisableTime(pcExchangeDisableTime)
      end
      local shortcuts = SHOW_BUTTON_COUNT
      if 0 == SHOW_BUTTON_COUNT then
        if CppEnums.InteractionType.InteractionType_InvitedParty == ii or CppEnums.InteractionType.InteractionType_GuildInvite == ii or CppEnums.InteractionType.InteractionType_ExchangeItem == ii then
          interactionTargetUIList[ii]:SetText(interactionTargetTextList[ii])
        elseif CppEnums.InteractionType.InteractionType_Talk == ii and actor:getCharacterStaticStatusWrapper():get():isSummonedCharacterBySiegeObject() then
          if true == _ContentsGroup_RenewUI then
            interactionTargetUIList[ii]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_USE"))
          else
            interactionTargetUIList[ii]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_USE") .. " <PAColor0xFFFFD543>(" .. keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction) .. ")<PAOldColor>")
          end
        elseif true == _ContentsGroup_RenewUI then
          interactionTargetUIList[ii]:SetText(interactionTargetTextList[ii])
        else
          interactionTargetUIList[ii]:SetText(interactionTargetTextList[ii] .. " <PAColor0xFFFFD543>(" .. keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction) .. ")<PAOldColor>")
        end
        interactionTargetUIList[ii]:SetFontColor(UI_Color.C_FFEFEFEF)
      else
        local _string = Interaction_ChangeString(SHOW_BUTTON_COUNT)
        if true == _ContentsGroup_RenewUI then
          interactionTargetUIList[ii]:SetText(interactionTargetTextList[ii])
        else
          interactionTargetUIList[ii]:SetText(interactionTargetTextList[ii] .. " <PAColor0xFFFFD543>(" .. _string .. ")<PAOldColor>")
        end
        interactionTargetUIList[ii]:SetFontColor(UI_Color.C_FF999999)
      end
      linkButtonAction[SHOW_BUTTON_COUNT] = ii
      SHOW_BUTTON_COUNT = SHOW_BUTTON_COUNT + 1
    end
  end
  _globalGuide:SetPosX(60)
  _globalGuide:SetPosY(LobbyInstance_Interaction:GetSizeY() * 0.5 - _globalGuide:GetSizeY() * 0.5)
  _needCollectTool:SetShow(false)
  Interaction_UpdateDesc(firstInteractionType)
  ANIMATING_BUTTON = true
  BUTTON_UPDATE_TIME = 0
  Interaction_ButtonPositionUpdate(0)
  isReloadState = false
  FGlobal_Interaction_ClearSelectIndex()
  _circularProgressBarInteraction:SetProgressRate(0)
end
function Interaction_ChangeString(index)
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
function FGlobal_InteractionButtonCount()
  return SHOW_BUTTON_COUNT
end
function FGlobal_InteractionButtonActionRun(keyIdx)
  Interaction_ButtonPushed(linkButtonAction[keyIdx])
end
function Panel_Interaction_GetGlobalGuidePosX()
  return LobbyInstance_Interaction:GetPosX() + _globalGuide:GetPosX()
end
function Panel_Interaction_GetGlobalGuidePosY()
  return LobbyInstance_Interaction:GetPosY() + _globalGuide:GetPosY()
end
function Interaction_Close()
  if LobbyInstance_Interaction:IsShow() then
    LobbyInstance_Interaction:SetShow(false)
    INTERACTABLE_ACTOR_KEY = 0
    INTERACTABLE_FRAG = 0
    _globalGuide:SetShow(false)
  end
end
function Interaction_PositionUpdate(actor)
  local pos2d = actor:get2DPosForInterAction()
  if pos2d.x < 0 and 0 > pos2d.y then
    LobbyInstance_Interaction:SetPosX(-1000)
    LobbyInstance_Interaction:SetPosY(-1000)
  else
    LobbyInstance_Interaction:SetPosX(pos2d.x + 0)
    LobbyInstance_Interaction:SetPosY(pos2d.y - 100)
  end
end
function Interaction_ButtonPositionUpdate(deltaTime)
  local ANIMATION_TIME = 0.35
  local BUTTON_OFFSET_X = 0
  local BUTTON_OFFSET_Y = 0
  local CIRCLE_RADIUS = 0
  if isTargetNpc then
    _background:SetSize(140, 140)
    BUTTON_OFFSET_X = -18
    BUTTON_OFFSET_Y = 42
    CIRCLE_RADIUS = 60
  else
    _background:SetSize(128, 128)
    BUTTON_OFFSET_X = -25
    BUTTON_OFFSET_Y = 35
    CIRCLE_RADIUS = 50
  end
  _circularProgressBarInteraction:SetPosX(BUTTON_OFFSET_X - 10)
  _circularProgressBarInteraction:SetPosY(BUTTON_OFFSET_Y - 7)
  _circularProgressBarStaticbgInteraction:SetPosX(BUTTON_OFFSET_X - 10)
  _circularProgressBarStaticbgInteraction:SetPosY(BUTTON_OFFSET_Y - 7)
  UI_NAME:SetPosY(_background:GetPosY() + _background:GetSizeY() / 2 - UI_NAME:GetSizeY() * 0.5)
  local ANGLE_OFFSET = math.pi * -0.5
  if ANIMATION_TIME < BUTTON_UPDATE_TIME then
    ANIMATING_BUTTON = false
  else
    BUTTON_UPDATE_TIME = BUTTON_UPDATE_TIME + deltaTime
    local aniRate = BUTTON_UPDATE_TIME / ANIMATION_TIME
    if aniRate > 1 then
      aniRate = 1
    end
    local actor = interaction_getInteractable()
    local jj = 0
    for ii, v in pairs(interactionTargetUIList) do
      local isShow = actor:isSetInteracatbleFrag(ii)
      if isShow then
        local div = jj / SHOW_BUTTON_COUNT
        local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * aniRate * math.cos(math.pi * 2 * div * aniRate + ANGLE_OFFSET)
        local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * aniRate * math.sin(math.pi * 2 * div * aniRate + ANGLE_OFFSET)
        interactionTargetUIList[ii]:SetPosX(buttonPosX)
        interactionTargetUIList[ii]:SetPosY(buttonPosY)
        interactionTargetUIList[ii]:SetAlpha(aniRate)
        _needCollectTool:SetPosX(buttonPosX + 2)
        _needCollectTool:SetPosY(buttonPosY + 2)
        local verticalSize = interactionTargetUIList[ii]:GetSizeY()
        if BUTTON_OFFSET_Y > buttonPosY then
          verticalSize = verticalSize * -0.5
        end
        interactionTargetUIList[ii]:SetTextSpan(0, verticalSize)
        if math.floor(buttonPosX) == math.floor(BUTTON_OFFSET_X) then
          interactionTargetUIList[ii]:SetTextHorizonCenter()
        elseif BUTTON_OFFSET_X > buttonPosX then
          interactionTargetUIList[ii]:SetTextHorizonRight()
        elseif BUTTON_OFFSET_X < buttonPosX then
          interactionTargetUIList[ii]:SetTextHorizonLeft()
        end
        jj = jj + 1
      end
    end
  end
end
function Interaction_Reset()
  INTERACTABLE_ACTOR_KEY = 0
end
function Interaction_ButtonPushed(interactionType)
  preUIMode = GetUIMode()
  local isTakedownCannon = false
  local function isTakedownCannonFuncPass()
    interaction_processInteraction(interactionType)
  end
  if CppEnums.InteractionType.InteractionType_TakedownCannon == interactionType then
    isTakedownCannon = true
  elseif CppEnums.InteractionType.InteractionType_Talk == interactionType then
    SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  elseif CppEnums.InteractionType.InteractionType_InvitedParty == interactionType then
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
  elseif CppEnums.InteractionType.InteractionType_ExchangeItem == interactionType then
    interactionTargetUIList[interactionType]:SetMonoTone(true)
  end
  if isTakedownCannon then
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
function FromClient_InteractionFail()
  if nil == preUIMode then
    return
  end
  SetUIMode(preUIMode)
end
function Interaction_ButtonOver(interactionType, isOver)
  local button = interactionTargetUIList[interactionType]
  button:ResetVertexAni()
  button:SetColor(UI_Color.C_FFFFFFFF)
  if nil == button then
    return
  end
  if isOver then
    audioPostEvent_SystemUi(0, 13)
    button:SetVertexAniRun("Ani_Color_Light", true)
    button:SetFontAlpha(1)
  else
    button:ResetVertexAni()
    button:SetFontAlpha(1)
  end
  isFocusInteractionType = isOver
  if isOver then
    focusInteractionType = interactionType
    Interaction_UpdateDesc(interactionType)
  else
    focusInteractionType = basicInteractionType
    Interaction_UpdateDesc(focusInteractionType)
  end
end
function Interaction_UpdatePerFrame_Desc()
  if focusInteractionType == CppEnums.InteractionType.InteractionType_Sympathetic then
    Interaction_UpdateDesc(focusInteractionType)
  elseif focusInteractionType == CppEnums.InteractionType.InteractionType_Observer then
    Interaction_UpdateDesc(focusInteractionType)
  end
  local actor = interaction_getInteractable()
  if actor == nil then
    return
  end
  if nil == interactionTargetUIList[CppEnums.InteractionType.InteractionType_Sympathetic] then
    return
  end
  if actor:isSetInteracatbleFrag(CppEnums.InteractionType.InteractionType_Sympathetic) then
    local vehicleWrapper = getVehicleActor(actor:get():getActorKeyRaw())
    if vehicleWrapper ~= nil then
      isSympatheticEnable = vehicleWrapper:checkUsableSympathetic()
      interactionTargetUIList[CppEnums.InteractionType.InteractionType_Sympathetic]:SetMonoTone(not isSympatheticEnable)
      if false == isFocusInteractionType then
        if not isSympatheticEnable then
          if focusInteractionType == basicInteractionType then
            focusInteractionType = CppEnums.InteractionType.InteractionType_Sympathetic
          end
        else
          focusInteractionType = basicInteractionType
        end
      end
    end
  end
end
function Interaction_UpdateDesc(indteractionType)
  local actor = interaction_getInteractable()
  if actor == nil then
    return
  end
  if not actor:isSetInteracatbleFrag(indteractionType) then
    return
  end
  local interactionDesc
  if indteractionType == basicInteractionType and (not actor:get():isPlayer() or actor:get():isSelfPlayer()) then
    if 61 ~= indteractionType then
      interactionDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_0", "interactionkey", keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction), "interaction", interactionTargetTextList[indteractionType])
    else
      interactionDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_2", "interactionkey", keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction), "interaction", interactionTargetTextList[indteractionType])
    end
  else
    interactionDesc = DESC_TEXT[indteractionType]
  end
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
        _needCollectTool:SetShow(true)
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
        interactionTargetUIList[CppEnums.InteractionType.InteractionType_Sympathetic]:SetMonoTone(not isSympatheticEnable)
        if not isSympatheticEnable then
          local sympatheticCooltime = math.ceil(vehicleWrapper:getSympatheticCoolTime() / 1000) * 1000
          interactionDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SYMPATHETIC_COOLTIME_DESC", "cooltime", convertStringFromMillisecondtime(toUint64(0, sympatheticCooltime)))
        else
          interactionDesc = PAGetString(Defines.StringSheet_GAME, "LUA_SYMPATHETIC_DESC")
        end
      end
    end
  elseif indteractionType == CppEnums.InteractionType.InteractionType_Observer and isObserverMode() then
    if indteractionType == basicInteractionType then
      interactionDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INTERACTION_PURPOSE_1", "interactionkey", keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction), "interaction", interactionTargetTextList[indteractionType])
    else
      interactionDesc = DESC_TEXT[indteractionType]
    end
    ShowCommandFunc()
  end
  _globalGuide:SetText(interactionDesc)
  _globalGuide:SetShow(true)
  if _ContentsGroup_RenewUI then
    if SHOW_BUTTON_COUNT > 1 then
      _globalGuide:SetSize(250, 50)
      _globalGuide:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_INTERACTION_XBOXGUIDE"))
    else
      _globalGuide:SetSize(250, 23)
      _globalGuide:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_INTERACTION_XBOXGUIDE"))
    end
  end
end
function FromClient_NotifyObserverModeEnd()
  if false == _ContentsGroup_RenewUI_WatchMode then
    Instance_WatchingMode:SetShow(false)
  end
  local selfPlayer = getSelfPlayer()
  if selfPlayer:isDead() then
    Instance_DeadMessage:SetShow(true, true)
  end
end
function FromClient_ConfirmInstallationBuff(currentEndurance)
  if MessageBox.isPopUp() then
    return
  end
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_MEMO_BUFF", "currentEndurance", tostring(currentEndurance))
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_MSGBOX_DATA_TITLE"),
    content = messageBoxMemo,
    functionYes = Interaction_InstallationBuff,
    functionNo = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Interaction_InstallationBuff()
  toClient_RequestInstallationBuff()
end
function FromClient_EnablePCExChangeButton()
  local exchagneButton = interactionTargetUIList[CppEnums.InteractionType.InteractionType_ExchangeItem]
  if nil ~= exchagneButton then
    exchagneButton:ClearDisableTime()
    exchagneButton:SetAutoDisableTime(pcExchangeDisableTime)
    exchagneButton:SetMonoTone(false)
  end
end
registerEvent("FromClient_InterAction_UpdatePerFrame", "Interaction_Update")
registerEvent("FromClient_ConfirmInstallationBuff", "FromClient_ConfirmInstallationBuff")
registerEvent("FromClient_InteractionFail", "FromClient_InteractionFail")
registerEvent("FromClient_NotifyObserverModeEnd", "FromClient_NotifyObserverModeEnd")
registerEvent("FromClient_EnablePCExChangeButton", "FromClient_EnablePCExChangeButton")
local isReloadState = true
local function interactionReload()
  if false == isReloadState then
    Interaction_Close()
    return
  end
  local actor = interaction_getInteractable()
  if nil == actor then
    Interaction_Close()
    return
  end
  if actor:get():isHouseHold() then
    LobbyInstance_Interaction:SetShow(false)
    INTERACTABLE_ACTOR_KEY = 0
    INTERACTABLE_FRAG = 0
    _globalGuide:SetShow(false)
    if interactionShowableCheck(actor) then
      Interaction_Show(actor)
    else
      Interaction_Close()
    end
  end
end
function renderModeChange_interactionReload(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  interactionReload()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_interactionReload")
function Interaction_SetReloadState()
  isReloadState = true
  if false == isFlushedUI() then
    interactionReload()
  end
end
function FromClient_InteractionHarvest()
  interaction_setInteractingState(CppEnums.InteractionType.InteractionType_Havest)
end
function FromClient_InteractionSeedHarvest()
  interaction_setInteractingState(CppEnums.InteractionType.InteractionType_SeedHavest)
end
local _buildingUpgradeActoKeyRaw = 0
function FromClient_InteractionBuildingUpgrade(actorKeyRaw)
  local actorProxy = getActor(actorKeyRaw)
  if nil == actorProxy then
    return
  end
  local upgradeStaticWrapper = actorProxy:getCharacterStaticStatusWrapper():getBuildingUpgradeStaticStatus()
  if nil == upgradeStaticWrapper then
    _PA_ASSERT(false, "FromClient_InteractionBuildingUpgrade --- upgradeStaticWrapper\236\157\180 \235\185\132\236\150\180\236\158\136\236\138\181\235\139\136\235\139\164. ")
    return
  end
  if nil == upgradeStaticWrapper:getTargetCharacter() then
    _PA_ASSERT(false, "FromClient_InteractionBuildingUpgrade --- upgradeStaticWrapper:getTargetCharacter()\236\157\180 \235\185\132\236\150\180\236\158\136\236\138\181\235\139\136\235\139\164. ")
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
  _buildingUpgradeActoKeyRaw = actorKeyRaw
  local messageBoxMemo = strNeedItems .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_UPGRADE_BARRICADE_NEEDITEMS", "strNeedItems", tempStr)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_UPGRADE_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = InteractionBuildingUpgrade_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function InteractionBuildingUpgrade_Confirm()
  toClient_RequestBuildingUpgrade(_buildingUpgradeActoKeyRaw)
end
function FromClient_InteractionSiegeObject(actorKeyRaw, funcState)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local actorProxy = actorProxyWrapper:get()
  _buildingUpgradeActoKeyRaw = actorKeyRaw
  if 0 == funcState then
    local price = Int64toInt32(actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():getUsingPrice())
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_DESC2", "price", makeDotMoney(price))
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = InteractSiegeObjectControlStart_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isElephantBarn() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_ELEPHANTBARN_MEMO_DESC")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = InteractSiegeObjectControlFinish_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_DESC")
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_INTERACTION_WARBUILDING_MEMO_TITLE"),
      content = messageBoxMemo,
      functionYes = InteractSiegeObjectControlFinish_Confirm,
      functionNo = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function InteractSiegeObjectControlStart_Confirm()
  toClient_RequestSiegeObjectControlStart(_buildingUpgradeActoKeyRaw)
end
function InteractSiegeObjectControlFinish_Confirm()
  toClient_RequestSiegeObjectControlFinish(_buildingUpgradeActoKeyRaw)
end
function InteractionTooltipResize_ByFontSize()
  if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    _globalGuide:SetSize(_globalGuide:GetSizeX(), 30)
  else
    _globalGuide:SetSize(_globalGuide:GetSizeX(), 23)
  end
end
function PaGlobal_Interaction_GetShow()
  return LobbyInstance_Interaction:GetShow()
end
registerEvent("FromClient_ReceiveBuyHouse", "Interaction_SetReloadState")
registerEvent("FromClient_ReceiveChangeUseType", "Interaction_SetReloadState")
registerEvent("FromClient_ReceiveReturnHouse", "Interaction_SetReloadState")
registerEvent("FromClient_ReceiveSetMyHouse", "Interaction_SetReloadState")
registerEvent("FromClient_InteractionHarvest", "FromClient_InteractionHarvest")
registerEvent("FromClient_InteractionSeedHarvest", "FromClient_InteractionSeedHarvest")
registerEvent("FromClient_InteractionBuildingUpgrade", "FromClient_InteractionBuildingUpgrade")
registerEvent("FromClient_InteractionSiegeObject", "FromClient_InteractionSiegeObject")
registerEvent("FromClient_luaLoadComplete", "InteractionTooltipResize_ByFontSize")
local houseInit = function()
end
function Panel_Interaction_House_HelpDesc_Func(contribute, isOn)
end
local InteractionCheck = function(interactionType)
  if interactionType == CppEnums.InteractionType.InteractionType_ExchangeItem or interactionType == CppEnums.InteractionType.InteractionType_InvitedParty or interactionType == CppEnums.InteractionType.InteractionType_GuildInvite then
    return true
  end
  return false
end
function Interaction_ExecuteByKeyMapping(keycode)
  _circularProgressBarInteraction:SetProgressRate(0)
  local buttonCount = FGlobal_InteractionButtonCount()
  DragManager:clearInfo()
  if keycode ~= CppEnums.ActionInputType.ActionInputType_Interaction then
    setUiInputProcessed(keycode)
  end
  if keycode == CppEnums.ActionInputType.ActionInputType_Interaction then
    local camBlur = getCameraBlur()
    local interactableActor = interaction_getInteractable()
    if interactableActor ~= nil and (not interactableActor:get():isPlayer() or interactableActor:get():isSelfPlayer()) and camBlur <= 0 then
      local interactionType = interactableActor:getSettedFirstInteractionType()
      if InteractionCheck(interactionType) then
        return
      end
      Interaction_ButtonPushed(interactionType)
      return
    elseif interactableActor ~= nil and interactableActor:get():isPlayer() and camBlur <= 0 then
      local interactionType = interactableActor:getSettedFirstInteractionType()
      if InteractionCheck(interactionType) then
        return
      end
      Interaction_ButtonPushed(interactionType)
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
local currentInteractionSelectIndex = 0
local currentInteractionKeyPressedTime = 0
local xboxInteractionAvailable = false
local _isInteractionRolling = false
function FGlobal_Interaction_CheckAndGetPressedKeyCode_Xbox(deltaTime)
  FGlobal_Interaction_UpdatePressedInteractionKey(currentInteractionKeyPressedTime)
  if keyCustom_IsDownOnce_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    currentInteractionKeyPressedTime = 0
    xboxInteractionAvailable = true
  elseif keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    currentInteractionKeyPressedTime = currentInteractionKeyPressedTime + deltaTime
    if currentInteractionKeyPressedTime > 0.5 then
      if false == xboxInteractionAvailable then
        return nil
      end
      xboxInteractionAvailable = false
      local keyCodeTable = {
        [0] = CppEnums.ActionInputType.ActionInputType_Interaction,
        [1] = CppEnums.UiInputType.UiInputType_Interaction_1,
        [2] = CppEnums.UiInputType.UiInputType_Interaction_2,
        [3] = CppEnums.UiInputType.UiInputType_Interaction_3,
        [4] = CppEnums.UiInputType.UiInputType_Interaction_4,
        [5] = CppEnums.UiInputType.UiInputType_Interaction_5,
        [6] = CppEnums.VirtualKeyCode.KeyCode_F10
      }
      local keycode = keyCodeTable[currentInteractionSelectIndex]
      FGlobal_Interaction_ClearSelectIndex()
      return keycode
    end
  elseif keyCustom_IsUp_Action(CppEnums.ActionInputType.ActionInputType_Interaction) then
    if currentInteractionKeyPressedTime < 0.5 and SHOW_BUTTON_COUNT > 1 then
      _isInteractionRolling = true
    end
    currentInteractionKeyPressedTime = 0
    xboxInteractionAvailable = false
  end
  if true == _isInteractionRolling then
    currentInteractionKeyPressedTime = 0
    FGlobal_Interaction_RollingAnimation(deltaTime)
  end
  return nil
end
function FGlobal_Interaction_CheckAndGetPressedKeyCode()
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
local _roleCheckTimeAcc = 0
local _rollingTime = 0.5
function FGlobal_Interaction_RollingAnimation(deltaTime)
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  _roleCheckTimeAcc = _roleCheckTimeAcc + deltaTime
  local CIRCLE_RADIUS = 0
  if isTargetNpc then
    _background:SetSize(140, 140)
    BUTTON_OFFSET_X = -18
    BUTTON_OFFSET_Y = 42
    CIRCLE_RADIUS = 60
  else
    _background:SetSize(128, 128)
    BUTTON_OFFSET_X = -25
    BUTTON_OFFSET_Y = 35
    CIRCLE_RADIUS = 50
  end
  local div = 1 / SHOW_BUTTON_COUNT
  local btnIdx = -currentInteractionSelectIndex % SHOW_BUTTON_COUNT
  for ii = 0, #interactionTargetUIList do
    local isShow = actor:isSetInteracatbleFrag(ii)
    if isShow then
      local ANGLE_OFFSET = math.pi * (2 * btnIdx / SHOW_BUTTON_COUNT - 0.5)
      local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * math.cos(math.pi * 2 * div * -(_roleCheckTimeAcc / _rollingTime) + ANGLE_OFFSET)
      local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * math.sin(math.pi * 2 * div * -(_roleCheckTimeAcc / _rollingTime) + ANGLE_OFFSET)
      interactionTargetUIList[ii]:SetPosX(buttonPosX)
      interactionTargetUIList[ii]:SetPosY(buttonPosY)
      _needCollectTool:SetPosX(buttonPosX + 2)
      _needCollectTool:SetPosY(buttonPosY + 2)
      btnIdx = (btnIdx + 1) % SHOW_BUTTON_COUNT
    end
  end
  if _rollingTime < _roleCheckTimeAcc then
    _roleCheckTimeAcc = 0
    FGlobal_Interaction_IncreaseSelectIndex()
    _isInteractionRolling = false
  end
end
function FGlobal_Interaction_IncreaseSelectIndex()
  currentInteractionSelectIndex = (currentInteractionSelectIndex + 1) % SHOW_BUTTON_COUNT
  local CIRCLE_RADIUS = 0
  local actor = interaction_getInteractable()
  if nil == actor then
    return
  end
  if isTargetNpc then
    _background:SetSize(140, 140)
    BUTTON_OFFSET_X = -18
    BUTTON_OFFSET_Y = 42
    CIRCLE_RADIUS = 60
  else
    _background:SetSize(128, 128)
    BUTTON_OFFSET_X = -25
    BUTTON_OFFSET_Y = 35
    CIRCLE_RADIUS = 50
  end
  local ANGLE_OFFSET = math.pi * -0.5
  local jj = -currentInteractionSelectIndex % SHOW_BUTTON_COUNT
  for ii = 0, #interactionTargetUIList do
    local isShow = actor:isSetInteracatbleFrag(ii)
    if isShow then
      local div = jj / SHOW_BUTTON_COUNT
      local buttonPosX = BUTTON_OFFSET_X + CIRCLE_RADIUS * math.cos(math.pi * 2 * div + ANGLE_OFFSET)
      local buttonPosY = BUTTON_OFFSET_Y + CIRCLE_RADIUS * math.sin(math.pi * 2 * div + ANGLE_OFFSET)
      interactionTargetUIList[ii]:SetPosX(buttonPosX)
      interactionTargetUIList[ii]:SetPosY(buttonPosY)
      _needCollectTool:SetPosX(buttonPosX + 2)
      _needCollectTool:SetPosY(buttonPosY + 2)
      local verticalSize = interactionTargetUIList[ii]:GetSizeY()
      if buttonPosY < BUTTON_OFFSET_Y then
        verticalSize = verticalSize * -0.5
      end
      interactionTargetUIList[ii]:SetTextSpan(0, verticalSize)
      if math.floor(buttonPosX) == math.floor(BUTTON_OFFSET_X) then
        interactionTargetUIList[ii]:SetTextHorizonCenter()
      elseif buttonPosX < BUTTON_OFFSET_X then
        interactionTargetUIList[ii]:SetTextHorizonRight()
      elseif buttonPosX > BUTTON_OFFSET_X then
        interactionTargetUIList[ii]:SetTextHorizonLeft()
      end
      jj = (jj + 1) % SHOW_BUTTON_COUNT
    end
  end
end
function FGlobal_Interaction_ClearSelectIndex()
  currentInteractionSelectIndex = 0
  xboxInteractionAvailable = false
end
function FGlobal_Interaction_UpdatePressedInteractionKey(time)
  if xboxInteractionAvailable then
    if time < 0.2 then
      return
    end
    _circularProgressBarInteraction:SetShow(true)
    _circularProgressBarStaticbgInteraction:SetShow(true)
    UI_NAME:SetShow(false)
  else
    _circularProgressBarInteraction:SetShow(false)
    _circularProgressBarStaticbgInteraction:SetShow(false)
    UI_NAME:SetShow(true)
  end
  _circularProgressBarInteraction:SetProgressRate(time * 200)
end
houseInit()
