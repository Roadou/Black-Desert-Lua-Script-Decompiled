local raceContentsEnable = ToClient_IsContentsGroupOpen("41")
local millitiaContentsEnable = ToClient_IsContentsGroupOpen("245")
local voiceChatContentsEnable = ToClient_IsContentsGroupOpen("75")
local millitiaContentsOpenEnable = false
Widget_Function_Type = {
  FindNPC = 0,
  MovieToolTip = 1,
  SetVoice = 2,
  SiegeArea = 3,
  HorseRace = 4,
  Militia = 5,
  BusterCall = 6,
  SiegeWarCall = 7,
  PartySummon = 8,
  ReturnTown = 9,
  SummonElephant = 10,
  NationWar = 11,
  BattleRoyal = 12,
  Count = 13
}
local Panel_Widget_FunctionButton_info = {
  _ui = {
    Button_FindNavi = nil,
    Button_MovieTooltip = nil,
    Button_SetState = nil,
    Button_VillageSiegeArea = nil,
    Button_HorseRace = nil,
    Button_Militia = nil,
    Button_BusterCall = nil,
    Button_SiegeWarCall = nil,
    Button_PartySummon = nil,
    Button_ReturnTown = nil,
    Button_SummonElephant = nil,
    Button_NationWar = nil,
    Button_BattleRoyal = nil
  },
  _pos = {buttonSpaceX = 8, buttonSizeX = 0},
  _button = {
    [Widget_Function_Type.FindNPC] = nil,
    [Widget_Function_Type.MovieToolTip] = nil,
    [Widget_Function_Type.SetVoice] = nil,
    [Widget_Function_Type.SiegeArea] = nil,
    [Widget_Function_Type.HorseRace] = nil,
    [Widget_Function_Type.Militia] = nil,
    [Widget_Function_Type.BusterCall] = nil,
    [Widget_Function_Type.SiegeWarCall] = nil,
    [Widget_Function_Type.PartySummon] = nil,
    [Widget_Function_Type.ReturnTown] = nil,
    [Widget_Function_Type.SummonElephant] = nil,
    [Widget_Function_Type.NationWar] = nil,
    [Widget_Function_Type.BattleRoyal] = nil
  },
  _buttonShow = {
    [Widget_Function_Type.FindNPC] = false,
    [Widget_Function_Type.MovieToolTip] = false,
    [Widget_Function_Type.SetVoice] = false,
    [Widget_Function_Type.SiegeArea] = false,
    [Widget_Function_Type.HorseRace] = false,
    [Widget_Function_Type.Militia] = false,
    [Widget_Function_Type.BusterCall] = false,
    [Widget_Function_Type.SiegeWarCall] = false,
    [Widget_Function_Type.PartySummon] = false,
    [Widget_Function_Type.ReturnTown] = false,
    [Widget_Function_Type.SummonElephant] = false,
    [Widget_Function_Type.NationWar] = false,
    [Widget_Function_Type.BattleRoyal] = false
  },
  _isLeftTime = {
    [Widget_Function_Type.BusterCall] = false,
    [Widget_Function_Type.SiegeWarCall] = false,
    [Widget_Function_Type.PartySummon] = false,
    [Widget_Function_Type.ReturnTown] = false
  },
  _tooltip = {
    _name = {
      [Widget_Function_Type.BusterCall] = "",
      [Widget_Function_Type.SiegeWarCall] = "",
      [Widget_Function_Type.PartySummon] = "",
      [Widget_Function_Type.ReturnTown] = "",
      [Widget_Function_Type.SummonElephant] = "",
      [Widget_Function_Type.BattleRoyal] = ""
    },
    _desc = {
      [Widget_Function_Type.BusterCall] = "",
      [Widget_Function_Type.SiegeWarCall] = "",
      [Widget_Function_Type.PartySummon] = "",
      [Widget_Function_Type.ReturnTown] = "",
      [Widget_Function_Type.SummonElephant] = "",
      [Widget_Function_Type.BattleRoyal] = ""
    }
  },
  _battleRoyalIsOpen = false,
  _returnTownTimerKey = nil,
  _busterCallTimerKey = nil,
  _siegeWarCallTimerKey = nil,
  _partySummonTimerKey = nil
}
local elephantActorKey
local ToggleSiege = false
function Panel_Widget_FunctionButton_info:registEventHandler()
  for index = 0, Widget_Function_Type.Count - 1 do
    self._button[index]:addInputEvent("Mouse_On", "PaGlobalFunc_Widget_FunctionButton_HandleOver(" .. index .. ")")
    self._button[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_Widget_FunctionButton_HandleOut(" .. index .. ")")
    self._button[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_Widget_FunctionButton_HandleLClick(" .. index .. ")")
    self._button[index]:addInputEvent("Mouse_RUp", "PaGlobalFunc_Widget_FunctionButton_HandleRClick(" .. index .. ")")
  end
  self._ui.Button_FindNavi:setButtonShortcuts("PANEL_SIMPLESHORTCUT_FIND_NPC")
end
function Panel_Widget_FunctionButton_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_Widget_FunctionButton_Resize")
end
function Panel_Widget_FunctionButton_info:initialize()
  self:childControl()
  self:setButton()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_FunctionButton_info:initValue()
  millitiaContentsOpenEnable = ToClient_IsGrowStepOpen(__eGrowStep_militia)
end
function Panel_Widget_FunctionButton_info:resize()
  local SizeX = Panel_Widget_Function:GetSizeX()
  local RadarPosX = FGlobal_Panel_Radar_GetPosX()
  local screenSizeY = getScreenSizeY()
  local screenSizeX = getScreenSizeX()
  Panel_Widget_Function:SetPosX(RadarPosX - SizeX)
  Panel_Widget_Function:SetPosY(0)
end
function Panel_Widget_FunctionButton_info:childControl()
  self._ui.Button_FindNavi = UI.getChildControl(Panel_Widget_Function, "Button_FindNavi")
  self._ui.Button_MovieTooltip = UI.getChildControl(Panel_Widget_Function, "Button_MovieTooltip")
  self._ui.Button_SetState = UI.getChildControl(Panel_Widget_Function, "Button_SetState")
  self._ui.Button_VillageSiegeArea = UI.getChildControl(Panel_Widget_Function, "Button_VillageSiegeArea")
  self._ui.Button_HorseRace = UI.getChildControl(Panel_Widget_Function, "Button_HorseRace")
  self._ui.Button_Militia = UI.getChildControl(Panel_Widget_Function, "Button_Militia")
  self._ui.Button_BusterCall = UI.getChildControl(Panel_Widget_Function, "Button_BusterCall")
  self._ui.Button_SiegeWarCall = UI.getChildControl(Panel_Widget_Function, "Button_SiegeWarCall")
  self._ui.Button_PartySummon = UI.getChildControl(Panel_Widget_Function, "Button_PartySummon")
  self._ui.Button_ReturnTown = UI.getChildControl(Panel_Widget_Function, "Button_ReturnTown")
  self._ui.Button_SummonElephant = UI.getChildControl(Panel_Widget_Function, "Button_SummonElephant")
  self._ui.Button_NationWar = UI.getChildControl(Panel_Widget_Function, "Button_NationWar")
  self._ui.Button_BattleRoyal = UI.getChildControl(Panel_Widget_Function, "Button_BattleRoyal")
  self._pos.buttonSizeX = self._ui.Button_FindNavi:GetSizeX()
end
function Panel_Widget_FunctionButton_info:setButton()
  self._button[Widget_Function_Type.FindNPC] = self._ui.Button_FindNavi
  self._button[Widget_Function_Type.MovieToolTip] = self._ui.Button_MovieTooltip
  self._button[Widget_Function_Type.SetVoice] = self._ui.Button_SetState
  self._button[Widget_Function_Type.SiegeArea] = self._ui.Button_VillageSiegeArea
  self._button[Widget_Function_Type.HorseRace] = self._ui.Button_HorseRace
  self._button[Widget_Function_Type.Militia] = self._ui.Button_Militia
  self._button[Widget_Function_Type.BusterCall] = self._ui.Button_BusterCall
  self._button[Widget_Function_Type.SiegeWarCall] = self._ui.Button_SiegeWarCall
  self._button[Widget_Function_Type.PartySummon] = self._ui.Button_PartySummon
  self._button[Widget_Function_Type.ReturnTown] = self._ui.Button_ReturnTown
  self._button[Widget_Function_Type.SummonElephant] = self._ui.Button_SummonElephant
  self._button[Widget_Function_Type.NationWar] = self._ui.Button_NationWar
  self._button[Widget_Function_Type.BattleRoyal] = self._ui.Button_BattleRoyal
end
function Panel_Widget_FunctionButton_info:updateAllButton()
  for index = 0, Widget_Function_Type.Count - 1 do
    self:checkButton(index)
  end
  local spanPosX = 0
  for index = 0, Widget_Function_Type.Count - 1 do
    if nil ~= self._buttonShow[index] then
      self._button[index]:SetShow(self._buttonShow[index])
      if true == self._buttonShow[index] then
        self._button[index]:SetSpanSize(spanPosX, 0)
        spanPosX = spanPosX + 40
        self:updateButton(index)
      end
    end
  end
end
function Panel_Widget_FunctionButton_info:updateAllButtonPos()
  local basePosXRight = Panel_Widget_Function:GetSizeX() - self._pos.buttonSizeX - self._pos.buttonSpaceX
  for index = 0, Widget_Function_Type.Count - 1 do
    if nil ~= self._buttonShow[index] and true == self._buttonShow[index] then
      self._button[index]:SetPosX(basePosXRight)
      basePosXRight = basePosXRight - self._pos.buttonSizeX - self._pos.buttonSpaceX
    end
  end
end
function Panel_Widget_FunctionButton_info:checkButton(functionType)
  if functionType == Widget_Function_Type.FindNPC then
    self._buttonShow[functionType] = true
  elseif functionType == Widget_Function_Type.MovieToolTip then
    self._buttonShow[functionType] = true
  elseif functionType == Widget_Function_Type.SetVoice then
    self._buttonShow[functionType] = voiceChatContentsEnable
  elseif functionType == Widget_Function_Type.SiegeArea then
    self._buttonShow[functionType] = true
  elseif functionType == Widget_Function_Type.HorseRace then
    self._buttonShow[functionType] = raceContentsEnable
  elseif functionType == Widget_Function_Type.Militia then
    self._buttonShow[functionType] = true == millitiaContentsOpenEnable and true == millitiaContentsEnable
  elseif functionType == Widget_Function_Type.BusterCall then
    self._buttonShow[functionType] = self._isLeftTime[functionType]
  elseif functionType == Widget_Function_Type.SiegeWarCall then
    self._buttonShow[functionType] = self._isLeftTime[functionType]
  elseif functionType == Widget_Function_Type.PartySummon then
    self._buttonShow[functionType] = self._isLeftTime[functionType]
  elseif functionType == Widget_Function_Type.ReturnTown then
    self._buttonShow[functionType] = self._isLeftTime[functionType]
  elseif functionType == Widget_Function_Type.SummonElephant then
    self._buttonShow[functionType] = nil ~= elephantActorKey
  elseif functionType == Widget_Function_Type.NationWar then
    self._buttonShow[functionType] = _ContentsGroup_NationSiege
  elseif functionType == Widget_Function_Type.BattleRoyal then
    self._buttonShow[functionType] = self._battleRoyalIsOpen
  end
end
function Panel_Widget_FunctionButton_info:updateButton(functionType)
  if functionType == Widget_Function_Type.FindNPC then
  elseif functionType == Widget_Function_Type.MovieToolTip then
  elseif functionType == Widget_Function_Type.SetVoice then
    local isMicOn = ToClient_isVoiceChatMic()
    local isHeadphoneOn = ToClient_isVoiceChatListen()
    local voiceControl = self._button[functionType]
    local mic = UI.getChildControl(voiceControl, "Static_Mic")
    local headphone = UI.getChildControl(voiceControl, "Static_Headphone")
    if nil ~= mic and nil ~= headphone then
      if isMicOn then
        mic:SetShow(true)
      else
        mic:SetShow(false)
      end
      if isHeadphoneOn then
        headphone:SetShow(true)
      else
        headphone:SetShow(false)
      end
    end
  elseif functionType == Widget_Function_Type.SiegeArea then
  elseif functionType == Widget_Function_Type.HorseRace then
  elseif functionType == Widget_Function_Type.Militia then
  elseif functionType == Widget_Function_Type.BusterCall then
  elseif functionType == Widget_Function_Type.SiegeWarCall then
  elseif functionType == Widget_Function_Type.PartySummon then
  elseif functionType == Widget_Function_Type.ReturnTown then
  elseif functionType == Widget_Function_Type.SummonElephant then
  end
end
function Panel_Widget_FunctionButton_info:handleLClick(functionType)
  if functionType == Widget_Function_Type.FindNPC then
    NpcNavi_ShowToggle()
  elseif functionType == Widget_Function_Type.MovieToolTip then
    PaGlobal_MovieGuide_Web:Open()
  elseif functionType == Widget_Function_Type.SetVoice then
    FGlobal_SetVoiceChat_Toggle()
  elseif functionType == Widget_Function_Type.SiegeArea then
    ToggleSiege = not ToggleSiege
    ToClient_toggleVillageSiegeArea(ToggleSiege)
    self._button[functionType]:EraseAllEffect()
    if ToggleSiege then
      self._button[functionType]:AddEffect("UI_VillageSiegeArea_01A", true, 0, 0)
    end
  elseif functionType == Widget_Function_Type.HorseRace then
    PaGlobalFunc_RaceInfo_Toggle()
  elseif functionType == Widget_Function_Type.Militia then
    FGlobal_MercenaryOpen()
  elseif functionType == Widget_Function_Type.BusterCall then
    ToClient_RequestTeleportGuildBustCall()
  elseif functionType == Widget_Function_Type.SiegeWarCall then
    ToClient_RequestTeleportToSiegeTentCall()
  elseif functionType == Widget_Function_Type.PartySummon then
    local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
    local playerActorKey = getSelfPlayer():getActorKey()
    if partyActorKey == playerActorKey then
      return
    end
    local remainTime_s64 = ToClient_GetLeftUsableTeleportCompassTime()
    local remainTime = Int64toInt32(remainTime_s64)
    if remainTime > 0 then
      if IsSelfPlayerWaitAction() then
        ToClient_RequestTeleportPosUseCompass()
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALERTAREA_NOTUSEALERT"))
      end
    end
  elseif functionType == Widget_Function_Type.ReturnTown then
    local remainTime_s64 = ToClient_GetLeftReturnStoneTime()
    local remainTime = Int64toInt32(remainTime_s64)
    local returnPos3D = ToClient_GetPosUseReturnStone()
    local regionInfo = getRegionInfoByPosition(returnPos3D)
    if remainTime > 0 then
      if IsSelfPlayerWaitAction() then
        ToClient_RequestTeleportPosUseReturnStone()
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALERTAREA_NOTUSEALERT"))
      end
    end
  elseif functionType == Widget_Function_Type.SummonElephant then
    if nil == elephantActorKey then
      return
    end
    ToClient_RequestSummonElephantFromSiegeBuilding(elephantActorKey)
  elseif functionType == Widget_Function_Type.NationWar then
    PaGlobal_Panel_Window_NationSiege_ShowToggle()
  elseif functionType == Widget_Function_Type.BattleRoyal then
    local messageBoxTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_ENTERLOBBY")
    local messageBoxContent = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MESSAGEBOX_BEFORE_LOBBY")
    local messageBoxFunctionYes = function()
      if false == IsSelfPlayerWaitAction() then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_WAITACTION_ALERT"))
        return
      end
      ToClient_RequestBattleRoyaleJoinToAnotherChannel()
      if true == ToClient_IsBattleRoyaleOpenState() and nil ~= PaGlobal_FadeOutOpen then
        PaGlobal_FadeOutOpen()
      end
    end
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxContent,
      functionYes = messageBoxFunctionYes,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function Panel_Widget_FunctionButton_info:handleRClick(functionType)
  if functionType == Widget_Function_Type.FindNPC then
  elseif functionType == Widget_Function_Type.MovieToolTip then
  elseif functionType == Widget_Function_Type.SetVoice then
  elseif functionType == Widget_Function_Type.SiegeArea then
  elseif functionType == Widget_Function_Type.HorseRace then
  elseif functionType == Widget_Function_Type.Militia then
  elseif functionType == Widget_Function_Type.BusterCall then
  elseif functionType == Widget_Function_Type.SiegeWarCall then
  elseif functionType == Widget_Function_Type.PartySummon then
  elseif functionType == Widget_Function_Type.ReturnTown then
  elseif functionType == Widget_Function_Type.SummonElephant then
  elseif functionType == Widget_Function_Type.NationWar then
    PaGlobal_NationSiegeBoard_Open()
  end
end
function Panel_Widget_FunctionButton_info:handleOver(functionType)
  local name = ""
  local desc = ""
  local uiControl = self._button[functionType]
  local showToolTip = false
  if functionType == Widget_Function_Type.FindNPC then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPCNAVI_NPCNAVITEXT")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CAMP_REMOTE_BUTTON_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
  elseif functionType == Widget_Function_Type.MovieToolTip then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MOVIEGUIDE_TITLE")
    desc = ""
  elseif functionType == Widget_Function_Type.SetVoice then
    showToolTip = true
    local changeString = function(isOn)
      local returnValue = ""
      if true == isOn then
        returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_ISON")
      else
        returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_ISOFF")
      end
      return returnValue
    end
    local isMicOn = changeString(ToClient_isVoiceChatMic())
    local isHeadphoneOn = changeString(ToClient_isVoiceChatListen())
    name = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_TITLE")
    desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_DESC", "mic", isMicOn, "speaker", isHeadphoneOn)
  elseif functionType == Widget_Function_Type.SiegeArea then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGESEIGE_AREABUTTON")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGESEIGE_AREABUTTON_DESC")
  elseif functionType == Widget_Function_Type.HorseRace then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANTRACE_INFO")
    desc = ""
  elseif functionType == Widget_Function_Type.Militia then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MERCENARY_TITLE")
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MERCENARY_TOPDESC")
  elseif functionType == Widget_Function_Type.BusterCall then
    PaGlobalFunc_Widget_FunctionButton_Check_GuildBusterCall()
    showToolTip = true
    name = self._tooltip._name[Widget_Function_Type.BusterCall]
    desc = self._tooltip._desc[Widget_Function_Type.BusterCall]
  elseif functionType == Widget_Function_Type.SiegeWarCall then
    PaGlobalFunc_Widget_FunctionButton_Check_SiegeWarCall()
    showToolTip = true
    name = self._tooltip._name[Widget_Function_Type.SiegeWarCall]
    desc = self._tooltip._desc[Widget_Function_Type.SiegeWarCall]
  elseif functionType == Widget_Function_Type.PartySummon then
    PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
    showToolTip = true
    name = self._tooltip._name[Widget_Function_Type.PartySummon]
    desc = self._tooltip._desc[Widget_Function_Type.PartySummon]
  elseif functionType == Widget_Function_Type.ReturnTown then
    PaGlobalFunc_Widget_FunctionButton_Check_ReturnTown()
    showToolTip = true
    name = self._tooltip._name[Widget_Function_Type.ReturnTown]
    desc = self._tooltip._desc[Widget_Function_Type.ReturnTown]
  elseif functionType == Widget_Function_Type.SummonElephant then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_SUMMONELEPHANT_TOOLTIP_DESC")
  elseif functionType == Widget_Function_Type.NationWar then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_ICON_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_ICON_TOOLTIP_DESC")
    if true == ToClient_isBeingNationSiege() then
      desc = desc .. PAGetString(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_ICON_TOOLTIP_DESC_RCLICK")
    end
  elseif functionType == Widget_Function_Type.BattleRoyal then
    showToolTip = true
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEROYAL")
    desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIDGET_BATTLEROYAL_FUNCTIONBUTTON_DESC")
  end
  if true == showToolTip and nil ~= uiControl then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function Panel_Widget_FunctionButton_info:open()
  Panel_Widget_Function:SetShow(true)
  if 0 <= ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_WidgetFunction, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    Panel_Widget_Function:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_WidgetFunction, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  end
end
function Panel_Widget_FunctionButton_info:close()
  if 0 <= ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_WidgetFunction, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    local isNowShow = 0 ~= ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_WidgetFunction, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow)
    Panel_Widget_Function:SetShow(isNowShow)
  end
end
function PaGlobalFunc_Widget_FunctionButton_GetShow()
  return Panel_Widget_Function:GetShow()
end
function PaGlobalFunc_Widget_FunctionButton_Open()
  local self = Panel_Widget_FunctionButton_info
  self:open()
end
function PaGlobalFunc_Widget_FunctionButton_Close()
  local self = Panel_Widget_FunctionButton_info
  self:close()
end
function PaGlobalFunc_Widget_FunctionButton_Show()
  local self = Panel_Widget_FunctionButton_info
  self:updateAllButton()
  self:open()
end
function PaGlobalFunc_Widget_FunctionButton_Exit()
  local self = Panel_Widget_FunctionButton_info
  self:close()
end
function PaGlobalFunc_Widget_FunctionButton_HandleOver(functionType)
  local self = Panel_Widget_FunctionButton_info
  self:handleOver(functionType)
end
function PaGlobalFunc_Widget_FunctionButton_HandleLClick(functionType)
  local self = Panel_Widget_FunctionButton_info
  self:handleLClick(functionType)
end
function PaGlobalFunc_Widget_FunctionButton_HandleRClick(functionType)
  local self = Panel_Widget_FunctionButton_info
  self:handleRClick(functionType)
end
function PaGlobalFunc_Widget_FunctionButton_HandleUpdate(functionType)
  local self = Panel_Widget_FunctionButton_info
  self:updateButton(functionType)
end
function PaGlobalFunc_Widget_FunctionButton_HandleOut()
  TooltipSimple_Hide()
end
function PaGlobalFunc_Widget_FunctionButton_Control(functionType)
  local self = Panel_Widget_FunctionButton_info
  if nil ~= self._button[functionType] then
    return self._button[functionType]
  end
end
function FGlobal_GetPersonalIconPosX()
  return Panel_Widget_Function:GetPosX()
end
function FGlobal_GetPersonalIconPosY()
  return Panel_Widget_Function:GetPosY()
end
function FGlobal_GetPersonalIconSizeX()
  return Panel_Widget_Function:GetSizeX()
end
function FGlobal_GetPersonalIconSizeY()
  return Panel_Widget_Function:GetSizeY()
end
function FromClient_Widget_FunctionButton_Init()
  local self = Panel_Widget_FunctionButton_info
  self:initialize()
  PaGlobalFunc_Widget_FunctionButton_Show()
  PaGlobalFunc_Widget_FunctionButton_Check_GuildBusterCall()
  PaGlobalFunc_Widget_FunctionButton_Check_SiegeWarCall()
  PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
  PaGlobalFunc_Widget_FunctionButton_Check_ReturnTown()
  PaGlobalFunc_Widget_FunctionButton_BattleRoyale_ReloadOpen()
end
function FromClient_Widget_FunctionButton_Resize()
  local self = Panel_Widget_FunctionButton_info
  self:resize()
end
function FromClient_Widget_FunctionButton_ResponseBustCall(sendType)
  local self = Panel_Widget_FunctionButton_info
  if 0 == sendType then
    self._isLeftTime[Widget_Function_Type.BusterCall] = true
    self._busterCallTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall, 600000, false, 0)
  else
    self._isLeftTime[Widget_Function_Type.BusterCall] = false
  end
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall()
  local self = Panel_Widget_FunctionButton_info
  self._isLeftTime[Widget_Function_Type.BusterCall] = false
  self._busterCallTimerKey = nil
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_GuildBusterCall()
  local self = Panel_Widget_FunctionButton_info
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetGuildBustCallPos())
  if nil == regionInfoWrapper then
    self._isLeftTime[Widget_Function_Type.BusterCall] = false
    self:updateAllButton()
    return
  end
  local leftTime = Int64toInt32(getLeftSecond_TTime64(ToClient_GetGuildBustCallTime()))
  if leftTime > 0 then
    if nil == self._busterCallTimerKey then
      self._busterCallTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_GuildBusterCall, leftTime * 1000, false, 0)
    end
    self._isLeftTime[Widget_Function_Type.BusterCall] = true
    self:updateAllButton()
  else
    self._isLeftTime[Widget_Function_Type.BusterCall] = false
    self:updateAllButton()
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetGuildBustCallTime()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_NAME")
  local desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
  self._tooltip._name[Widget_Function_Type.BusterCall] = name
  self._tooltip._desc[Widget_Function_Type.BusterCall] = desc
end
function FromClient_Widget_FunctionButton_BattleRoyale_IsOpen(isOn)
  if false == _ContentsGroup_RedDesert then
    return
  end
  local self = Panel_Widget_FunctionButton_info
  local bool = isOn
  self._battleRoyalIsOpen = bool
  self:updateAllButton()
  if true == isOn then
    PaGlobal_BottomBanner_Open()
  end
end
function PaGlobalFunc_Widget_FunctionButton_BattleRoyale_ReloadOpen()
  if false == _ContentsGroup_RedDesert then
    return
  end
  local self = Panel_Widget_FunctionButton_info
  local isBattleRoyaleOpen = ToClient_IsBattleRoyaleOpenState()
  self._battleRoyalIsOpen = isBattleRoyaleOpen
  self:updateAllButton()
end
function FromClient_Widget_FunctionButton_ResponseTeleportToSiegeTent(sendType, isVolunteer)
  local self = Panel_Widget_FunctionButton_info
  if 0 == sendType then
    self._isLeftTime[Widget_Function_Type.SiegeWarCall] = true
    self._siegeWarCallTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall, 600000, false, 0)
  else
    self._isLeftTime[Widget_Function_Type.SiegeWarCall] = false
  end
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall()
  local self = Panel_Widget_FunctionButton_info
  self._isLeftTime[Widget_Function_Type.SiegeWarCall] = false
  self._siegeWarCallTimerKey = nil
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_SiegeWarCall()
  local self = Panel_Widget_FunctionButton_info
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(ToClient_GetTeleportToSiegeTentPos())
  if nil == regionInfoWrapper then
    self._isLeftTime[Widget_Function_Type.SiegeWarCall] = false
    self:updateAllButton()
    return
  end
  local areaName = regionInfoWrapper:getAreaName()
  local usableTime64 = ToClient_GetTeleportToSiegeTentTime()
  local leftTime = 0
  if nil ~= usableTime64 then
    leftTime = Int64toInt32(getLeftSecond_TTime64(usableTime64))
  end
  if leftTime > 0 then
    if nil == self._siegeWarCallTimerKey then
      self._siegeWarCallTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_SiegeWarCall, leftTime * 1000, false, 0)
    end
    self._isLeftTime[Widget_Function_Type.SiegeWarCall] = true
    self:updateAllButton()
  else
    self._isLeftTime[Widget_Function_Type.SiegeWarCall] = false
    self:updateAllButton()
    return
  end
  local selfProxy = getSelfPlayer()
  if nil ~= selfProxy then
    if selfProxy:get():isVolunteer() then
      descStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC2", "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
    else
      descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MOVIEGUIDE_BUSTERCALL_TOOLTIP_DESC", "areaName", areaName, "time", convertStringFromDatetime(getLeftSecond_TTime64(usableTime64)))
    end
  end
  local name, desc = PAGetString(Defines.StringSheet_GAME, "LUA_WARCALL_TOOLTIP_NAME"), descStr
  self._tooltip._name[Widget_Function_Type.SiegeWarCall] = name
  self._tooltip._desc[Widget_Function_Type.SiegeWarCall] = desc
end
function FromClient_Widget_FunctionButton_ResponseUseCompass()
  _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\157\180\235\178\164\237\138\184\234\176\128 \235\147\164\236\150\180\236\152\164\234\179\160 \236\158\136\235\138\148 \234\178\131\236\157\184\234\176\128\236\154\148????????")
  local self = Panel_Widget_FunctionButton_info
  self._isLeftTime[Widget_Function_Type.PartySummon] = false
  PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
  self:updateAllButton()
  local partyName = ""
  partyName = ToClient_GetCharacterNameUseCompass()
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local msg = ""
  if partyActorKey == playerActorKey then
    msg = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_1")
  else
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_MESSAGE_2", "partyName", partyName)
  end
  Proc_ShowMessage_Ack(msg)
  self._partySummonTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_PartySummon, 600000, false, 0)
end
function PaGlobalFunc_Widget_FunctionButton_Close_PartySummon()
  local self = Panel_Widget_FunctionButton_info
  self._isLeftTime[Widget_Function_Type.PartySummon] = false
  self._partySummonTimerKey = nil
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_PartySummon()
  local self = Panel_Widget_FunctionButton_info
  local partyName = ToClient_GetCharacterNameUseCompass()
  local partyActorKey = ToClient_GetCharacterActorKeyRawUseCompass()
  local playerActorKey = getSelfPlayer():getActorKey()
  local descStr = ""
  local usableTime64 = ToClient_GetLeftUsableTeleportCompassTime()
  local remainTime = Int64toInt32(usableTime64)
  if remainTime > 0 then
    if nil == self._partySummonTimerKey then
      self._partySummonTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_PartySummon, remainTime * 1000, false, 0)
    end
    self._isLeftTime[Widget_Function_Type.PartySummon] = true
    self:updateAllButton()
  else
    self._isLeftTime[Widget_Function_Type.PartySummon] = false
    self:updateAllButton()
    return
  end
  if partyActorKey == playerActorKey then
    descStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPASS_DESC_1", "remainTime", convertStringFromDatetime(usableTime64))
  else
    descStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_COMPASS_DESC_2", "partyName", partyName, "partyName1", partyName, "remainTime", convertStringFromDatetime(usableTime64))
  end
  local name, desc = PAGetString(Defines.StringSheet_GAME, "LUA_COMPASS_NAME"), descStr
  self._tooltip._name[Widget_Function_Type.PartySummon] = name
  self._tooltip._desc[Widget_Function_Type.PartySummon] = desc
end
function FromClient_Widget_FunctionButton_ResponseUseReturnStone()
  local self = Panel_Widget_FunctionButton_info
  local pos3D = ToClient_GetPosUseReturnStone()
  ToClient_DeleteNaviGuideByGroup(0)
  worldmapNavigatorStart(pos3D, NavigationGuideParam(), false, false)
  PaGlobalFunc_Widget_FunctionButton_Check_ReturnTown()
  self:updateAllButton()
  self._returnTownTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_ReturnTown, 1800000, false, 0)
end
function PaGlobalFunc_Widget_FunctionButton_Close_ReturnTown()
  local self = Panel_Widget_FunctionButton_info
  self._isLeftTime[Widget_Function_Type.ReturnTown] = false
  self._returnTownTimerKey = nil
  self:updateAllButton()
end
function PaGlobalFunc_Widget_FunctionButton_Check_ReturnTown()
  local self = Panel_Widget_FunctionButton_info
  local returnPos3D = ToClient_GetPosUseReturnStone()
  local regionInfo = getRegionInfoByPosition(returnPos3D)
  local regionName = ""
  if nil ~= regionInfo then
    regionName = regionInfo:getAreaName()
  end
  local returnTownRegionKey = ToClient_GetReturnStoneTownRegionKey()
  local usableTime64 = ToClient_GetLeftReturnStoneTime()
  local remainTime = Int64toInt32(usableTime64)
  if remainTime > 0 then
    if nil == self._returnTownTimerKey then
      self._returnTownTimerKey = luaTimer_AddEvent(PaGlobalFunc_Widget_FunctionButton_Close_ReturnTown, remainTime * 1000, false, 0)
    end
    self._isLeftTime[Widget_Function_Type.ReturnTown] = true
    self:updateAllButton()
  else
    self._isLeftTime[Widget_Function_Type.ReturnTown] = false
    self:updateAllButton()
    return
  end
  local descStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_RETURNSTONE_DESC", "regionName", regionName, "remainTime", convertStringFromDatetime(usableTime64))
  local name, desc = PAGetString(Defines.StringSheet_GAME, "LUA_RETURNSTONE_NAME"), descStr
  self._tooltip._name[Widget_Function_Type.ReturnTown] = name
  self._tooltip._desc[Widget_Function_Type.ReturnTown] = desc
end
function FromClient_ShowElephantBarn(actorKey)
  local self = Panel_Widget_FunctionButton_info
  elephantActorKey = actorKey
  self:updateAllButton()
end
function FromClient_HideElephantBarn()
  local self = Panel_Widget_FunctionButton_info
  elephantActorKey = nil
  self:updateAllButton()
end
function FGlobal_FunctionButton_NationSiegeIcon_StartAni()
  local self = Panel_Widget_FunctionButton_info
  if nil ~= self._ui.Button_NationWar then
    self._ui.Button_NationWar:SetVertexAniRun("Ani_Color_New", true)
  end
end
function FGlobal_FunctionButton_NationSiegeIcon_StopAni()
  local self = Panel_Widget_FunctionButton_info
  if nil ~= self._ui.Button_NationWar then
    self._ui.Button_NationWar:SetVertexAniRun("Ani_Color_New", false)
    self._ui.Button_NationWar:SetColor(Defines.Color.C_FFFFFFFF)
  end
end
local summonPartyCheck = function()
  local leftTime = Int64toInt32(ToClient_GetLeftUsableTeleportCompassTime())
  if leftTime <= 0 then
    PaGlobalFunc_Widget_FunctionButton_Close_PartySummon()
  end
end
function FGlobal_SummonPartyCheck()
  summonPartyCheck()
end
local returnStoneCheck = function()
  local leftTime = Int64toInt32(ToClient_GetLeftReturnStoneTime())
  if leftTime <= 0 then
    PaGlobalFunc_Widget_FunctionButton_Close_ReturnTown()
  end
end
function FGlobal_ReturnStoneCheck()
  returnStoneCheck()
end
registerEvent("FromClient_ResponseBustCall", "FromClient_Widget_FunctionButton_ResponseBustCall")
registerEvent("FromClient_ResponseTeleportToSiegeTent", "FromClient_Widget_FunctionButton_ResponseTeleportToSiegeTent")
registerEvent("FromClient_BattleRoyaleIsOpen", "FromClient_Widget_FunctionButton_BattleRoyale_IsOpen")
registerEvent("FromClient_ResponseUseCompass", "FromClient_Widget_FunctionButton_ResponseUseCompass")
registerEvent("FromClient_ResponseUseReturnStone", "FromClient_Widget_FunctionButton_ResponseUseReturnStone")
registerEvent("FromClient_ShowElephantBarn", "FromClient_ShowElephantBarn")
registerEvent("FromClient_HideElephantBarn", "FromClient_HideElephantBarn")
registerEvent("FromClient_luaLoadComplete", "FromClient_Widget_FunctionButton_Init")
