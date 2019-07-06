Panel_PartyRecruite:SetShow(false, false)
Panel_PartyRecruite:setGlassBackground(true)
Panel_PartyRecruite:SetDragAll(true)
Panel_PartyRecruite:RegisterShowEventFunc(true, "Panel_PartyRecruite_ShowAni()")
Panel_PartyRecruite:RegisterShowEventFunc(false, "Panel_PartyRecruite_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
function Panel_PartyRecruite_ShowAni()
  UIAni.fadeInSCR_Down(Panel_PartyRecruite)
  local aniInfo1 = Panel_PartyRecruite:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_PartyRecruite:GetSizeX() / 2
  aniInfo1.AxisY = Panel_PartyRecruite:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_PartyRecruite:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_PartyRecruite:GetSizeX() / 2
  aniInfo2.AxisY = Panel_PartyRecruite:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_PartyRecruite_HideAni()
  Panel_PartyRecruite:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_PartyRecruite:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local partyListRecruite = {
  control = {
    _btnClose = UI.getChildControl(Panel_PartyRecruite, "Button_Close"),
    _editText = UI.getChildControl(Panel_PartyRecruite, "MultilineEdit_Recruite"),
    _levelText = UI.getChildControl(Panel_PartyRecruite, "StaticText_LimitLevel"),
    _btnLvChange = UI.getChildControl(Panel_PartyRecruite, "Button_LevelChange"),
    _btnAdmin = UI.getChildControl(Panel_PartyRecruite, "Button_Admin"),
    _stcMessageBG = UI.getChildControl(Panel_PartyRecruite, "Static_MessageBG")
  },
  _selectLevel = 0,
  _maxLevel = toInt64(0, 60)
}
function partyListRecruite:Show()
  Panel_PartyRecruite:SetShow(true, true)
  self:Init()
end
function partyListRecruite:Hide()
  Panel_PartyRecruite:SetShow(false, false)
  ClearFocusEdit()
  FGlobal_PartyListClearFocusEdit()
end
function FGlobal_PartyListRecruite_Show()
  partyListRecruite:Show()
end
function PartyListRecruite_Close()
  partyListRecruite:Hide()
end
function PartyListRecruite_TextSet()
  local self = partyListRecruite
  local msg = self.control._editText:GetEditText()
  local baseText = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_DEFALUTTEXT")
  if baseText == msg then
    self.control._editText:SetEditText("")
  end
  SetFocusEdit(self.control._editText)
  self.control._editText:SetEditText(self.control._editText:GetEditText(), true)
end
function PartyListRecruite_LevelChange()
  local self = partyListRecruite
  local function setLevel(inputNum)
    self.control._levelText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_MINLEVEL", "level", tostring(inputNum)))
    self._selectLevel = Int64toInt32(inputNum)
  end
  Panel_NumberPad_Show(true, self._maxLevel, 0, setLevel)
end
function PartyListRecruite_Request()
  local self = partyListRecruite
  local msg = self.control._editText:GetEditText()
  local baseText = PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_DEFALUTTEXT")
  if "" == msg or baseText == msg then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_REGISTALERT"))
    return
  end
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantDoingAlterOfBlood"))
    return
  end
  ToClient_RequestPartyRecruitment(msg, self._selectLevel, 5)
  partyListRecruite:Hide()
end
function FGlobal_CheckPartyListRecruiteUiEdit(targetUI)
  return nil ~= targetUI and targetUI:GetKey() == partyListRecruite.control._editText:GetKey()
end
function partyListRecruite:Init()
  self.control._editText:SetMaxEditLine(2)
  self.control._editText:SetMaxInput(30)
  self.control._editText:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_DEFALUTTEXT"))
  self.control._editText:addInputEvent("Mouse_LUp", "PartyListRecruite_TextSet()")
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local minLevel = 1
  self._selectLevel = minLevel
  self.control._levelText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PARTYLISTRECRUITE_MINLEVEL", "level", minLevel))
  self.control._btnLvChange:addInputEvent("Mouse_LUp", "PartyListRecruite_LevelChange()")
  self.control._btnAdmin:addInputEvent("Mouse_LUp", "PartyListRecruite_Request()")
  self.control._btnClose:addInputEvent("Mouse_LUp", "PartyListRecruite_Close()")
  self.control._txtMessage = UI.getChildControl(self.control._stcMessageBG, "StaticText_Message")
  self.control._txtMessage:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.control._txtMessage:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_GUIDE_RULE_9"))
  Panel_PartyRecruite:SetPosX(getScreenSizeX() / 2 - Panel_PartyList:GetSizeX() / 2 - Panel_PartyRecruite:GetSizeX() / 2)
  Panel_PartyRecruite:SetPosY(getScreenSizeY() / 2 - Panel_PartyList:GetSizeY() / 2 - 100)
end
partyListRecruite:Init()
