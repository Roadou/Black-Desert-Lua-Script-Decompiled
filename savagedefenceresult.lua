Panel_SavageDefence_Result:SetShow(false)
Panel_SavageDefence_Result:setMaskingChild(true)
Panel_SavageDefence_Result:ActiveMouseEventEffect(true)
Panel_SavageDefence_Result:setGlassBackground(true)
local PaGlobal_SavegeDefenceResult = {
  _list2 = UI.getChildControl(Panel_SavageDefence_Result, "List2_Result"),
  _buttonExit = UI.getChildControl(Panel_SavageDefence_Result, "Button_Exit"),
  _buttonClose = UI.getChildControl(Panel_SavageDefence_Result, "Button_Win_Close"),
  _descBg = UI.getChildControl(Panel_SavageDefence_Result, "Static_DescBg"),
  _centerBg = UI.getChildControl(Panel_SavageDefence_Result, "Static_InsideBg")
}
function PaGlobal_SavegeDefenceResult:initialize()
  self._desc = UI.getChildControl(self._descBg, "StaticText_Desc")
  self._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._desc:SetText(self._desc:GetText())
  local descSizeY = self._desc:GetTextSizeY()
  Panel_SavageDefence_Result:SetSize(Panel_SavageDefence_Result:GetSizeX(), 535 + descSizeY)
  self._centerBg:SetSize(self._centerBg:GetSizeX(), 421 + descSizeY)
  self._descBg:SetSize(self._descBg:GetSizeX(), descSizeY + 5)
  self._descBg:ComputePos()
  self._desc:ComputePos()
  self._buttonExit:ComputePos()
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_SavegeDefenceResult_ListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._buttonExit:addInputEvent("Mouse_LUp", "FGlobal_SavageDefenceExitbyResult()")
  self._buttonClose:addInputEvent("Mouse_LUp", "FGlobal_SavageDefenceResultClose()")
end
function FGlobal_SavegeDefenceResult_ListUpdate(contents, key)
  local self = PaGlobal_SavegeDefenceResult
  local idx = Int64toInt32(key)
  local characterName = UI.getChildControl(contents, "StaticText_CharacterName")
  local contributionPoint = UI.getChildControl(contents, "StaticText_ContributionPoint")
  local reportButton = UI.getChildControl(contents, "Button_Report")
  local contributionInfo = ToClient_getSavageDefenceContributionInfo(idx)
  if nil == contributionInfo then
    return
  end
  characterName:SetText(contributionInfo:getName())
  contributionPoint:SetText(tostring(contributionInfo._point))
  reportButton:addInputEvent("Mouse_LUp", "FGlobal_SavageDefenceReportTroll(" .. idx .. ")")
  characterName:SetShow(true)
  contributionPoint:SetShow(true)
  reportButton:SetShow(true)
end
function FGlobal_SavageDefenceReportTroll(idx)
  local function _report()
    ToClient_SavageDefenceReportTroll(idx, false)
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCERESULT_ALERTTITLE")
  local _content = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCERESULT_ALERTDESC")
  local messageBoxData = {
    title = _title,
    content = _content,
    functionYes = _report,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_SavageDefenceExitbyResult()
  ToClient_SavageDefenceUnJoin()
end
function FGlobal_SavageDefenceResultClose()
  Panel_SavageDefence_Result:SetShow(false)
end
function FromClient_luaLoadComplete_SavageDefenceResult()
  local self = PaGlobal_SavegeDefenceResult
  self:initialize()
end
function FromClient_SavageDefenceResult()
  local self = PaGlobal_SavegeDefenceResult
  local serverCount = ToClient_getSavageDefenceResultCount()
  self._list2:getElementManager():clearKey()
  for idx = 0, serverCount - 1 do
    self._list2:getElementManager():pushKey(toInt64(0, idx))
  end
  Panel_SavageDefence_Result:SetShow(true)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SavageDefenceResult")
registerEvent("FromClient_SavageDefenceResult", "FromClient_SavageDefenceResult")
