Panel_Window_Mercenary:SetShow(false)
local mercenary = {
  _control = {
    _btnClose = UI.getChildControl(Panel_Window_Mercenary, "Button_Close"),
    _topGuideText = UI.getChildControl(Panel_Window_Mercenary, "StaticText_TopGuide"),
    _btnCancel = UI.getChildControl(Panel_Window_Mercenary, "Button_Cancel"),
    _btnGuideIcon = UI.getChildControl(Panel_Window_Mercenary, "Static_GuideIcon"),
    _territoryBg = {},
    _territoryControl = {}
  },
  _isAttack = true,
  _territoryCount = 0,
  _maxTerritoryCount = 3
}
function mercenary:Init()
  local isCalpheonOpen = ToClient_IsContentsGroupOpen("2")
  local isMediaOpen = ToClient_IsContentsGroupOpen("3")
  local isValenciaOpen = ToClient_IsContentsGroupOpen("4")
  if isCalpheonOpen then
    self._territoryCount = self._territoryCount + 1
  end
  if isMediaOpen then
    self._territoryCount = self._territoryCount + 1
  end
  if isValenciaOpen then
    self._territoryCount = self._territoryCount + 1
  end
  self._control._territoryBg[0] = UI.getChildControl(Panel_Window_Mercenary, "Static_CapheonBg")
  self._control._territoryBg[1] = UI.getChildControl(Panel_Window_Mercenary, "Static_MediaBg")
  self._control._territoryBg[2] = UI.getChildControl(Panel_Window_Mercenary, "Static_ValenciaBg")
  for index = 0, self._maxTerritoryCount - 1 do
    local temp = {}
    local parent = self._control._territoryBg[index]
    temp._btnAttack = UI.getChildControl(parent, "Button_Attack")
    temp._btnDeffence = UI.getChildControl(parent, "Button_Deffence")
    temp._StaticAttackIcon = UI.getChildControl(parent, "Static_AttackIcon")
    temp._StaticDeffenceIcon = UI.getChildControl(parent, "Static_DeffenceIcon")
    temp._occupyGuild = UI.getChildControl(parent, "StaticText_OccupyGuild")
    temp._territoryName = UI.getChildControl(parent, "StaticText_TerritoryName")
    temp._freeDesc = UI.getChildControl(parent, "StaticText_Free")
    temp._freeDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    temp._freeDesc:SetText(temp._freeDesc:GetText())
    temp._btnAttack:addInputEvent("Mouse_LUp", "Mercenary_Request(true)")
    temp._btnDeffence:addInputEvent("Mouse_LUp", "Mercenary_Request(false)")
    if index >= self._territoryCount then
      parent:SetShow(false)
    end
    self._control._territoryControl[index] = temp
  end
  self._control._topGuideText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._control._topGuideText:SetText(self._control._topGuideText:GetText())
end
function Mercenary_Request(isAttack)
  local currentSiegeTerrytoryKey = ToClient_GetStartSiegeTerritoryKey()
  local function doRequest_Militia()
    ToClient_VolunteerEnterReq(currentSiegeTerrytoryKey, isAttack)
  end
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA__REQUESTTITLE")
  local content = ""
  if isAttack then
    content = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA__REQUESCONTENT_ATTACK")
  else
    content = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA__REQUESCONTENT_DEFFENCE")
  end
  local messageBoxData = {
    title = title,
    content = content,
    functionYes = doRequest_Militia,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Mercenary_Cancel()
  local cancelMercenary = function()
    ToClient_VolunteerLeaveReq()
  end
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_MSGTITLE")
  local content = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_MSGDESC")
  local messageBoxData = {
    title = title,
    content = content,
    functionYes = cancelMercenary,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function mercenary:Update()
  local currentSiegeTerrytoryKey = ToClient_GetStartSiegeTerritoryKey()
  for index = 0, self._maxTerritoryCount - 1 do
    local territoryKey = index + 2
    local occupyGuildWrapper = ToClient_GetOccupyGuildWrapper(territoryKey)
    if nil ~= occupyGuildWrapper then
      local guildName = ""
      if "" == occupyGuildWrapper:getAllianceName() then
        guildName = occupyGuildWrapper:getName()
      else
        guildName = occupyGuildWrapper:getAllianceName()
      end
      self._control._territoryControl[index]._occupyGuild:SetText(guildName)
      self._control._territoryControl[index]._occupyGuild:SetShow(true)
      self._control._territoryControl[index]._freeDesc:SetShow(false)
      if territoryKey == currentSiegeTerrytoryKey then
        if currentSiegeTerrytoryKey >= 2 then
          self:SetButton(index, true)
        else
          self:SetButton(index, false)
        end
      else
        self:SetButton(index, false)
      end
    else
      self._control._territoryControl[index]._occupyGuild:SetShow(false)
      self._control._territoryControl[index]._freeDesc:SetShow(true)
      self:SetButton(index, false)
    end
  end
end
function mercenary:SetButton(index, isEnable)
  self._control._territoryControl[index]._btnAttack:SetMonoTone(not isEnable)
  self._control._territoryControl[index]._btnAttack:SetIgnore(not isEnable)
  self._control._territoryControl[index]._btnDeffence:SetMonoTone(not isEnable)
  self._control._territoryControl[index]._btnDeffence:SetIgnore(not isEnable)
  self._control._territoryControl[index]._StaticAttackIcon:SetMonoTone(not isEnable)
  self._control._territoryControl[index]._StaticDeffenceIcon:SetMonoTone(not isEnable)
end
function FGlobal_MercenaryOpen()
  if Panel_Window_Mercenary:GetShow() then
    FGlobal_MercenaryClose()
  else
    audioPostEvent_SystemUi(1, 18)
    _AudioPostEvent_SystemUiForXBOX(1, 18)
    mercenary:Update()
    Panel_Window_Mercenary:SetShow(true)
    Panel_Mercenary_Repos()
    FGlobal_MercenaryDesc_Open()
  end
end
function FGlobal_MercenaryClose()
  audioPostEvent_SystemUi(1, 17)
  _AudioPostEvent_SystemUiForXBOX(1, 7)
  Panel_Window_Mercenary:SetShow(false)
  FGlobal_MercenaryDesc_Close()
  TooltipSimple_Hide()
end
function MercenaryDesc_GuideIcon_TooltipShow()
  TooltipSimple_Show(mercenary._control._btnGuideIcon, PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_TOOLTIPDESC"))
end
function MercenaryDesc_GuideIcon_TooltipHide()
  TooltipSimple_Hide()
end
function Panel_Mercenary_Repos()
  Panel_Window_Mercenary:SetPosX(getScreenSizeX() / 2 - Panel_Window_Mercenary:GetSizeX() / 2 + 100)
  Panel_Window_Mercenary:SetPosY(getScreenSizeY() / 2 - Panel_Window_Mercenary:GetSizeY() / 2)
end
function FromClient_ResponseVolunteerRecruit()
  if ToClient_IsContentsGroupOpen("245") then
    local msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_RECRUITSTART"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 75)
  end
end
function FromClient_ResponseMilitiaStart()
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_STARTTEXT"),
    sub = "",
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 76)
end
function FromClient_ResponseMilitiaEnd()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_ENDTEXT"))
end
function FromClient_ResponseMilitiaEnter()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_RESPONSE_JOIN"))
end
function FromClient_ResponseMilitiaLeave()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MILITIA_RESPONSE_CANCEL"))
end
function mercenary:registerEvent()
  registerEvent("FromClient_ResponseVolunteerRecruit", "FromClient_ResponseVolunteerRecruit")
  registerEvent("FromClient_ResponseVolunteerStart", "FromClient_ResponseMilitiaStart")
  registerEvent("FromClient_ResponseVolunteerEnd", "FromClient_ResponseMilitiaEnd")
  registerEvent("FromClient_ResponseVolunteerEnter", "FromClient_ResponseMilitiaEnter")
  registerEvent("FromClient_ResponseVolunteerLeave", "FromClient_ResponseMilitiaLeave")
  registerEvent("onScreenResize", "Panel_Mercenary_Repos")
  self._control._btnCancel:addInputEvent("Mouse_LUp", "Mercenary_Cancel()")
  self._control._btnGuideIcon:addInputEvent("Mouse_LUp", "FGlobal_MercenaryDesc_ShowToggle()")
  self._control._btnGuideIcon:addInputEvent("Mouse_On", "MercenaryDesc_GuideIcon_TooltipShow()")
  self._control._btnGuideIcon:addInputEvent("Mouse_Out", "MercenaryDesc_GuideIcon_TooltipHide()")
  self._control._btnClose:addInputEvent("Mouse_LUp", "FGlobal_MercenaryClose()")
end
mercenary:Init()
mercenary:registerEvent()
