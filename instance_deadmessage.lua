local _panel = Instance_DeadMessage
_panel:setIgnoreFlashPanel(true)
local DeadMessage = {
  ui = {
    stc_BlackHole = UI.getChildControl(_panel, "deadBlackHole"),
    stc_DeadText = UI.getChildControl(_panel, "Static_DeadText"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    btn_ObserverMode = UI.getChildControl(_panel, "Button_ObserverMode"),
    btn_Leave = UI.getChildControl(_panel, "Button_Leave")
  },
  _myRank
}
DeadMessage.ui.rankText = UI.getChildControl(DeadMessage.ui.stc_CenterBg, "StaticText_Rank")
DeadMessage.ui.rankText:SetShow(false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local closePanel = {
  Instance_Widget_RemainTime,
  Instance_Widget_MainStatus_User_Bar,
  Instance_ClassResource,
  Instance_Widget_Leave,
  Instance_Widget_Monster_Bar,
  Instance_QuickSlot,
  Instance_Widget_ItemSlot,
  Instance_Region,
  Instance_Widget_BetterEquipment,
  Instance_Widget_KillLog,
  Instance_Radar,
  Instance_Widget_Party,
  Instance_Window_Inventory,
  Instance_Window_Equipment,
  Instance_Widget_EquipmentList
}
local openPanel = {
  Instance_Widget_RemainTime,
  Instance_Widget_KillLog,
  Instance_Widget_Leave,
  Instance_Widget_Party,
  Instance_Radar
}
function DeadMessage:initialize()
  self.ui.stc_DeadText:SetShow(false)
  self.ui.btn_ObserverMode:SetShow(false)
  self.ui.btn_Leave:SetShow(false)
end
function DeadMessage:registerEventHandler()
  self.ui.btn_ObserverMode:addInputEvent("Mouse_LUp", "deadMessage_buttonPushed_ObserverMode()")
  self.ui.btn_Leave:addInputEvent("Mouse_LUp", "deadMessage_battleRoyal_Leave()")
  registerEvent("EventSelfPlayerDead", "deadMessage_Show")
  registerEvent("onScreenResize", "deadMessage_Resize")
  registerEvent("FromClient_NotifySiegeShowWatchPanel", "FromClient_DeadMessage_NotifySiegeShowWatchPanel")
end
function PaGlobal_deadMessage_otherPanelShow(isShow)
  for index = 1, #closePanel do
    if nil ~= closePanel[index] then
      closePanel[index]:SetShow(isShow)
    end
  end
end
function PaGlobal_deadMessage_openPanelShow()
  for index = 1, #openPanel do
    if nil ~= openPanel[index] then
      openPanel[index]:SetShow(true)
    end
  end
end
function deadMessage_Show()
  if Instance_Window_Result:GetShow() then
    return
  end
  local self = DeadMessage
  deadMessage_Resize()
  PaGlobal_deadMessage_otherPanelShow(false)
  self.ui.stc_DeadText:SetShow(true)
  self.ui.btn_ObserverMode:SetShow(true)
  self.ui.btn_Leave:SetShow(true)
  _panel:SetShow(true)
  local currentPlayerCount = ToClient_BattleRoyaleRemainPlayerCount()
  self._myRank = currentPlayerCount + 1
end
function PaGlobal_BattleRoyal_MyRank()
  return DeadMessage._myRank
end
function deadMessage_Resize()
  local self = DeadMessage
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  _panel:SetSize(screenX, screenY)
  self.ui.stc_CenterBg:SetSize(self.ui.stc_CenterBg:GetSizeX(), self.ui.stc_CenterBg:GetSizeY())
  _panel:ComputePos()
  self.ui.stc_CenterBg:ComputePos()
  self.ui.stc_DeadText:ComputePos()
  self.ui.stc_BlackHole:ComputePos()
  self.ui.btn_ObserverMode:ComputePos()
  self.ui.btn_Leave:ComputePos()
end
function DeadMessage:animation()
  Instance_DeadMessage:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniBlackhole1 = self.ui.stc_BlackHole:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniBlackhole1:SetStartColor(UI_color.C_00FFFFFF)
  aniBlackhole1:SetEndColor(UI_color.C_FFFFFFFF)
  aniBlackhole1.IsChangeChild = false
  local aniBlackhole2 = self.ui.stc_BlackHole:addScaleAnimation(3, 15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR_2)
  aniBlackhole2:SetStartScale(1)
  aniBlackhole2:SetEndScale(1.5)
  aniBlackhole2.AxisX = 128
  aniBlackhole2.AxisY = 128
  aniBlackhole2.IsChangeChild = false
  local aniObserverMode = self.ui.btn_ObserverMode:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniObserverMode:SetStartColor(UI_color.C_00FFFFFF)
  aniObserverMode:SetEndColor(UI_color.C_00FFFFFF)
  aniObserverMode.IsChangeChild = true
  aniObserverMode:SetDisableWhileAni(true)
  aniObserverMode = self.ui.btn_ObserverMode:addColorAnimation(3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniObserverMode:SetStartColor(UI_color.C_00FFFFFF)
  aniObserverMode:SetEndColor(UI_color.C_FFFFFFFF)
  aniObserverMode.IsChangeChild = true
  aniObserverMode:SetDisableWhileAni(true)
  local aniLeave = self.ui.btn_Leave:addColorAnimation(0, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniLeave:SetStartColor(UI_color.C_00FFFFFF)
  aniLeave:SetEndColor(UI_color.C_00FFFFFF)
  aniLeave.IsChangeChild = true
  aniLeave:SetDisableWhileAni(true)
  aniLeave = self.ui.btn_Leave:addColorAnimation(3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniLeave:SetStartColor(UI_color.C_00FFFFFF)
  aniLeave:SetEndColor(UI_color.C_FFFFFFFF)
  aniLeave.IsChangeChild = true
  aniLeave:SetDisableWhileAni(true)
end
function DeadMessage:notifySiegeShowWatchPanel(isShow)
  if nil == PaGlobalFunc_InstanceWatchMode_SetControlShow then
    return
  end
  PaGlobalFunc_InstanceWatchMode_SetControlShow(isShow)
  ToClient_ShowBattleRoyaleCam(isShow)
  if false == isShow then
    deadMessage_Show()
  end
end
function DeadMessage:sendNotifySiegeShowWatchPanel(isShow)
  ToClient_ShowBattleRoyaleCam(isShow)
end
function deadMessage_buttonPushed_ObserverMode()
  if _panel:GetShow() then
    _panel:SetShow(false)
  end
  local self = DeadMessage
  local partyCount = RequestParty_getPartyMemberCount()
  if partyCount > 1 then
    self:sendNotifySiegeShowWatchPanel(true)
  else
    deadMessage_Revival(__eRespanwType_BattleRoyale, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
    self:sendNotifySiegeShowWatchPanel(false)
  end
  PaGlobal_deadMessage_openPanelShow()
end
function deadMessage_battleRoyal_Leave()
  ToClient_ExitBattleRoyale()
end
function FromClient_DeadMessage_NotifySiegeShowWatchPanel(isShow)
  local self = DeadMessage
  self:notifySiegeShowWatchPanel(isShow)
end
function FromClient_DeadMessage_luaLoadComplete()
  local self = DeadMessage
  self:initialize()
  self:registerEventHandler()
end
function deadMessage_updatePerFrame()
end
_panel:RegisterUpdateFunc("deadMessage_updatePerFrame")
registerEvent("FromClient_luaLoadComplete", "FromClient_DeadMessage_luaLoadComplete")
