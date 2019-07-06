local _panel = Instance_WatchingMode
_panel:SetDragAll(true)
_panel:SetIgnore(true)
local watchingMode = {
  skillCommandBg = UI.getChildControl(_panel, "Static_CommandBG"),
  key_W = UI.getChildControl(_panel, "StaticText_Key_W"),
  key_A = UI.getChildControl(_panel, "StaticText_Key_A"),
  key_S = UI.getChildControl(_panel, "StaticText_Key_S"),
  key_D = UI.getChildControl(_panel, "StaticText_Key_D"),
  key_Q = UI.getChildControl(_panel, "StaticText_Key_Q"),
  key_E = UI.getChildControl(_panel, "StaticText_Key_E"),
  key_ESC = UI.getChildControl(_panel, "StaticText_Key_ESC"),
  key_Low = UI.getChildControl(_panel, "StaticText_Key_SpeedLow"),
  key_Fast = UI.getChildControl(_panel, "StaticText_Key_SpeedFast"),
  key_Shift = UI.getChildControl(_panel, "StaticText_Key_Shift"),
  key_Caps = UI.getChildControl(_panel, "StaticText_Key_Caps"),
  forward = UI.getChildControl(_panel, "StaticText_Forward"),
  left = UI.getChildControl(_panel, "StaticText_Left"),
  back = UI.getChildControl(_panel, "StaticText_Back"),
  right = UI.getChildControl(_panel, "StaticText_Right"),
  small = UI.getChildControl(_panel, "StaticText_Small"),
  big = UI.getChildControl(_panel, "StaticText_Big"),
  exit = UI.getChildControl(_panel, "StaticText_Exit"),
  speedLow = UI.getChildControl(_panel, "StaticText_CameraSpeedLow"),
  speedFast = UI.getChildControl(_panel, "StaticText_CameraSpeedFast"),
  speed = UI.getChildControl(_panel, "StaticText_Speed"),
  caps = UI.getChildControl(_panel, "StaticText_Caps")
}
local showToogleBtn = UI.getChildControl(_panel, "Button_ShowCommand")
function FromClient_StartObserverMode()
  _PA_LOG("\236\160\149\236\167\128\237\152\156", "FromClient_StartObserverMode")
  local self = watchingMode
  self.skillCommandBg:SetIgnore(false)
  self.skillCommandBg:AddChild(self.key_W)
  self.skillCommandBg:AddChild(self.key_A)
  self.skillCommandBg:AddChild(self.key_S)
  self.skillCommandBg:AddChild(self.key_D)
  self.skillCommandBg:AddChild(self.key_Q)
  self.skillCommandBg:AddChild(self.key_E)
  self.skillCommandBg:AddChild(self.key_ESC)
  self.skillCommandBg:AddChild(self.key_Low)
  self.skillCommandBg:AddChild(self.key_Fast)
  self.skillCommandBg:AddChild(self.key_Shift)
  self.skillCommandBg:AddChild(self.key_Caps)
  self.skillCommandBg:AddChild(self.forward)
  self.skillCommandBg:AddChild(self.left)
  self.skillCommandBg:AddChild(self.back)
  self.skillCommandBg:AddChild(self.right)
  self.skillCommandBg:AddChild(self.small)
  self.skillCommandBg:AddChild(self.big)
  self.skillCommandBg:AddChild(self.exit)
  self.skillCommandBg:AddChild(self.speedLow)
  self.skillCommandBg:AddChild(self.speedFast)
  self.skillCommandBg:AddChild(self.speed)
  self.skillCommandBg:AddChild(self.caps)
  _panel:RemoveControl(self.key_W)
  _panel:RemoveControl(self.key_A)
  _panel:RemoveControl(self.key_S)
  _panel:RemoveControl(self.key_D)
  _panel:RemoveControl(self.key_Q)
  _panel:RemoveControl(self.key_E)
  _panel:RemoveControl(self.key_ESC)
  _panel:RemoveControl(self.key_Low)
  _panel:RemoveControl(self.key_Fast)
  _panel:RemoveControl(self.key_Shift)
  _panel:RemoveControl(self.key_Caps)
  _panel:RemoveControl(self.forward)
  _panel:RemoveControl(self.left)
  _panel:RemoveControl(self.back)
  _panel:RemoveControl(self.right)
  _panel:RemoveControl(self.small)
  _panel:RemoveControl(self.big)
  _panel:RemoveControl(self.exit)
  _panel:RemoveControl(self.speedLow)
  _panel:RemoveControl(self.speedFast)
  _panel:RemoveControl(self.speed)
  _panel:RemoveControl(self.caps)
  showToogleBtn:addInputEvent("Mouse_LUp", "ShowCommandFunc()")
  _panel:SetShow(true)
end
function ShowCommandFunc()
  _PA_LOG("\236\160\149\236\167\128\237\152\156", "ShowCommandFunc")
  if true == _ContentsGroup_RenewUI_WatchMode then
    return
  end
  local self = watchingMode
  local checkToggleBtn = showToogleBtn:IsCheck()
  _panel:SetShow(true)
  if checkToggleBtn then
    self.skillCommandBg:SetShow(false)
  else
    self.skillCommandBg:SetShow(true)
  end
  self.key_W:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveFront))
  self.key_S:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveBack))
  self.key_A:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveLeft))
  self.key_D:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveRight))
  self.key_Q:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_CrouchOrSkill))
  self.key_E:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_GrabOrGuard))
  self.key_R:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction))
  self.key_Low:SetText(keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_CameraSpeedDown))
  self.key_Fast:SetText(keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_CameraSpeedUp))
  self.key_Shift:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Dash))
  self.key_Low:SetSize(self.key_Low:GetTextSizeX() + 10, self.key_Low:GetSizeY())
  self.key_Fast:SetSize(self.key_Fast:GetTextSizeX() + 10, self.key_Fast:GetSizeY())
  if Instance_ActionMessage:GetShow() then
    ActionMessageHide()
  end
end
function FromClient_NotifyObserverModeEnd_ReturnTime()
  _PA_LOG("\236\160\149\236\167\128\237\152\156", "FromClient_NotifyObserverModeEnd_ReturnTime")
end
function isDeadInWatchingMode()
  local selfPlayer = getSelfPlayer()
  local isDead = false
  if nil ~= selfPlayer then
    isDead = selfPlayer:isDead()
  end
  return _panel:GetShow() or true == isDead
end
registerEvent("FromClient_NotifyObserverModeEnd", "FromClient_NotifyObserverModeEnd_ReturnTime")
registerEvent("FromClient_NotifyObserverModeStart", "FromClient_StartObserverMode")
