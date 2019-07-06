Panel_ReturnUser_BlackSpirit:SetShow(false)
local UI_TM = CppEnums.TextMode
local Panel_ReturnUser_BlackSpirit_info = {
  _ui = {
    _effectButton = nil,
    _descBg = nil,
    _desc = nil
  }
}
function Panel_ReturnUser_BlackSpirit_info:init()
  if nil == getSelfPlayer() then
    return
  end
  local playername = getSelfPlayer():getOriginalName()
  self:childControl()
  self._ui._desc:SetAutoResize(true)
  self._ui._desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RETURNUSER_BLACKSPIRIT_DESC", "playerName", playername))
  self:setPosSize()
  self._ui._effectButton:EraseAllEffect()
  self._ui._effectButton:AddEffect("fN_DarkSpirit_Gage_01C", true, 0, 0)
end
function Panel_ReturnUser_BlackSpirit_info:childControl()
  self._ui._effectButton = UI.getChildControl(Panel_ReturnUser_BlackSpirit, "Button_BlackSpirit")
  self._ui._descBg = UI.getChildControl(self._ui._effectButton, "Button_DescBg")
  self._ui._desc = UI.getChildControl(self._ui._descBg, "StaticText_Desc2")
end
function Panel_ReturnUser_BlackSpirit_info:setPosSize()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  self._ui._effectButton:SetSpanSize(scrX / 5 * -1, scrY / 5.5 * -1)
  self._ui._descBg:SetSize(self._ui._desc:GetTextSizeX() + 50, self._ui._desc:GetTextSizeY() + 50)
  self._ui._descBg:SetHorizonLeft()
  self._ui._descBg:SetVerticalBottom()
  self._ui._desc:SetHorizonCenter()
end
function Panel_ReturnUser_BlackSpirit_info:registEventHandler()
  self._ui._effectButton:addInputEvent("Mouse_On", "Panel_ReturnUser_BlackSpirit_info_ChangeEffect()")
  self._ui._effectButton:addInputEvent("Mouse_Out", "Panel_ReturnUser_BlackSpirit_info_ResetEffect()")
  self._ui._effectButton:addInputEvent("Mouse_LUp", "Panel_ReturnUser_BlackSpirit_info_OpenBlackSpirit()")
  self._ui._descBg:addInputEvent("Mouse_On", "Panel_ReturnUser_BlackSpirit_info_ChangeEffect()")
  self._ui._descBg:addInputEvent("Mouse_Out", "Panel_ReturnUser_BlackSpirit_info_ResetEffect()")
  self._ui._descBg:addInputEvent("Mouse_LUp", "Panel_ReturnUser_BlackSpirit_info_OpenBlackSpirit()")
end
function Panel_ReturnUser_BlackSpirit_info:setShow(isShow)
  do return end
  Panel_ReturnUser_BlackSpirit:SetShow(isShow)
end
function Panel_ReturnUser_BlackSpirit_info_ChangeEffect()
  Panel_ReturnUser_BlackSpirit_info._ui._effectButton:EraseAllEffect()
  Panel_ReturnUser_BlackSpirit_info._ui._effectButton:AddEffect("fN_DarkSpirit_Gage_01B", true, 0, 0)
end
function Panel_ReturnUser_BlackSpirit_info_ResetEffect()
  Panel_ReturnUser_BlackSpirit_info:init()
end
function Panel_ReturnUser_BlackSpirit_info_OpenBlackSpirit()
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
    return
  end
  FGlobal_TentTooltipHide()
  ToClient_AddBlackSpiritFlush()
end
function FromClient_luaLoadComplete_ReturnUser_BlackSpirit()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local userType = temporaryWrapper:getMyAdmissionToSpeedServer()
  if 1 ~= userType then
    return
  else
    Panel_ReturnUser_BlackSpirit_info:checkQuest()
  end
end
function Panel_ReturnUser_BlackSpirit_info:checkUpdate()
  registerEvent("updateProgressQuestList", "FromClient_updateQuestList_ReturnUser_BlackSpirit")
  registerEvent("FromClient_UpdateQuestList", "FromClient_updateQuestList_ReturnUser_BlackSpirit")
end
function FromClient_updateQuestList_ReturnUser_BlackSpirit()
  Panel_ReturnUser_BlackSpirit_info:checkQuest()
end
function Panel_ReturnUser_BlackSpirit_info:checkQuest()
  if not questList_isClearQuest(650, 3) and not questList_isClearQuest(21001, 6) and not questList_isClearQuest(21117, 3) then
    self:setShow(false)
  elseif questList_hasProgressQuest(1600, 9) or questList_isClearQuest(1600, 9) then
    self:setShow(false)
  else
    self:init()
    self:registEventHandler()
    self:setShow(true)
  end
  self:checkUpdate()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ReturnUser_BlackSpirit")
