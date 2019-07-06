Panel_WatchingMode:SetDragAll(true)
Panel_WatchingMode:SetIgnore(true)
local watchingMode = {
  skillCommandBg = UI.getChildControl(Panel_WatchingMode, "Static_CommandBG"),
  key_W = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_W"),
  key_A = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_A"),
  key_S = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_S"),
  key_D = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_D"),
  key_Q = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_Q"),
  key_E = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_E"),
  key_R = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_R"),
  key_Low = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_SpeedLow"),
  key_Fast = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_SpeedFast"),
  key_Shift = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_Shift"),
  key_Caps = UI.getChildControl(Panel_WatchingMode, "StaticText_Key_Caps"),
  forward = UI.getChildControl(Panel_WatchingMode, "StaticText_Forward"),
  left = UI.getChildControl(Panel_WatchingMode, "StaticText_Left"),
  back = UI.getChildControl(Panel_WatchingMode, "StaticText_Back"),
  right = UI.getChildControl(Panel_WatchingMode, "StaticText_Right"),
  small = UI.getChildControl(Panel_WatchingMode, "StaticText_Small"),
  big = UI.getChildControl(Panel_WatchingMode, "StaticText_Big"),
  exit = UI.getChildControl(Panel_WatchingMode, "StaticText_Exit"),
  speedLow = UI.getChildControl(Panel_WatchingMode, "StaticText_CameraSpeedLow"),
  speedFast = UI.getChildControl(Panel_WatchingMode, "StaticText_CameraSpeedFast"),
  speed = UI.getChildControl(Panel_WatchingMode, "StaticText_Speed"),
  caps = UI.getChildControl(Panel_WatchingMode, "StaticText_Caps")
}
local showToogleBtn = UI.getChildControl(Panel_WatchingMode, "Button_ShowCommand")
local remainTime = UI.getChildControl(Panel_WatchingMode, "StaticText_RemainTime")
local resurrectionTime
local onShip = false
function WatchingModeInt()
  local self = watchingMode
  self.skillCommandBg:SetIgnore(false)
  self.skillCommandBg:AddChild(self.key_W)
  self.skillCommandBg:AddChild(self.key_A)
  self.skillCommandBg:AddChild(self.key_S)
  self.skillCommandBg:AddChild(self.key_D)
  self.skillCommandBg:AddChild(self.key_Q)
  self.skillCommandBg:AddChild(self.key_E)
  self.skillCommandBg:AddChild(self.key_R)
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
  Panel_WatchingMode:RemoveControl(self.key_W)
  Panel_WatchingMode:RemoveControl(self.key_A)
  Panel_WatchingMode:RemoveControl(self.key_S)
  Panel_WatchingMode:RemoveControl(self.key_D)
  Panel_WatchingMode:RemoveControl(self.key_Q)
  Panel_WatchingMode:RemoveControl(self.key_E)
  Panel_WatchingMode:RemoveControl(self.key_R)
  Panel_WatchingMode:RemoveControl(self.key_Low)
  Panel_WatchingMode:RemoveControl(self.key_Fast)
  Panel_WatchingMode:RemoveControl(self.key_Shift)
  Panel_WatchingMode:RemoveControl(self.key_Caps)
  Panel_WatchingMode:RemoveControl(self.forward)
  Panel_WatchingMode:RemoveControl(self.left)
  Panel_WatchingMode:RemoveControl(self.back)
  Panel_WatchingMode:RemoveControl(self.right)
  Panel_WatchingMode:RemoveControl(self.small)
  Panel_WatchingMode:RemoveControl(self.big)
  Panel_WatchingMode:RemoveControl(self.exit)
  Panel_WatchingMode:RemoveControl(self.speedLow)
  Panel_WatchingMode:RemoveControl(self.speedFast)
  Panel_WatchingMode:RemoveControl(self.speed)
  Panel_WatchingMode:RemoveControl(self.caps)
  showToogleBtn:addInputEvent("Mouse_LUp", "ShowCommandFunc()")
end
function ShowCommandFunc(respawnTime, isMast)
  if true == _ContentsGroup_RenewUI_WatchMode then
    return
  end
  local self = watchingMode
  local checkToggleBtn = showToogleBtn:IsCheck()
  Panel_WatchingMode:SetShow(true)
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
  if nil ~= respawnTime or nil ~= resurrectionTime then
    if nil ~= respawnTime then
      resurrectionTime = respawnTime
    end
    remainTime:SetShow(true)
    self.key_R:SetShow(false)
    self.exit:SetShow(false)
    self.key_Shift:SetPosY(250)
    self.speed:SetPosY(251)
    self.key_Low:SetPosY(190)
    self.speedLow:SetPosY(191)
    self.key_Fast:SetPosY(220)
    self.speedFast:SetPosY(221)
    self.key_Caps:SetPosY(280)
    self.caps:SetPosY(281)
  elseif isMast or onShip then
    remainTime:SetShow(false)
    self.key_R:SetShow(false)
    self.exit:SetShow(false)
    self.key_Shift:SetPosY(250)
    self.speed:SetPosY(251)
    self.key_Low:SetPosY(190)
    self.speedLow:SetPosY(191)
    self.key_Fast:SetPosY(220)
    self.speedFast:SetPosY(221)
    self.key_Caps:SetPosY(280)
    self.caps:SetPosY(281)
    onShip = true
  else
    remainTime:SetShow(false)
    self.key_R:SetShow(true)
    self.exit:SetShow(true)
    self.key_Shift:SetPosY(280)
    self.speed:SetPosY(281)
    self.key_Low:SetPosY(220)
    self.speedLow:SetPosY(221)
    self.key_Fast:SetPosY(250)
    self.speedFast:SetPosY(251)
    self.key_Caps:SetPosY(310)
    self.caps:SetPosY(311)
  end
  if Panel_ActionMessage:GetShow() then
    ActionMessageHide()
  end
end
function FromClient_NotifyObserverModeEnd_ReturnTime()
  if true == _ContentsGroup_RenewUI_WatchMode then
    PaGlobal_ConsoleQuickMenu:widgetOpen()
    local actor = interaction_getInteractable()
    if actor ~= nil then
      Interaction_Show(actor)
    end
  else
    deadMessage_ResurrectionTimeReturn(resurrectionTime)
    resurrectionTime = nil
    onShip = false
  end
end
function WatchingMode_UpdatePerFrame(deltaTime)
  if nil ~= resurrectionTime then
    if resurrectionTime > 0 then
      resurrectionTime = resurrectionTime - deltaTime
      local regenTime = tostring(string.format("%.0f", resurrectionTime))
      remainTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "WATCHINGMODE_TEXT_RESPAWN_TIME", "regenTime", tostring(regenTime)))
    else
      local regenTime = "0"
      remainTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "WATCHINGMODE_TEXT_RESPAWN_TIME", "regenTime", tostring(regenTime)))
      resurrectionTime = 0
      if true == ContentOption_OneLife and true == ToClient_IsAnySiegeBeingOfMyChannel() then
      else
        observerCameraModeStop()
      end
    end
  end
end
function isDeadInWatchingMode()
  local selfPlayer = getSelfPlayer()
  local isDead = false
  if nil ~= selfPlayer then
    isDead = selfPlayer:isDead()
  end
  return (nil == resurrectionTime or not Panel_WatchingMode:GetShow()) and Panel_GuildBattleWatchingMode:GetShow() and true == isDead
end
function FromClient_WatchModeCloseByKingOrLordTentDestroy()
  if isDeadInWatchingMode() then
    resurrectionTime = 0
    GuildManager:Hide()
    observerCameraModeStop()
  end
end
function FromClient_FrameEventCallBack_Observer()
  if true == isObserverMode() then
    ShowCommandFunc(nil, true)
  end
end
function PaGlobal_StartObserverMode()
  if true == _ContentsGroup_RenewUI_WatchMode and true == isObserverMode() then
    PaGlobal_ConsoleQuickMenu:widgetClose()
  end
end
Panel_WatchingMode:RegisterUpdateFunc("WatchingMode_UpdatePerFrame")
registerEvent("FromClient_NotifyObserverModeEnd", "FromClient_NotifyObserverModeEnd_ReturnTime")
registerEvent("FromClient_FrameEventCallBack_Observer", "FromClient_FrameEventCallBack_Observer")
registerEvent("FromClient_NotifyObserverModeStart", "PaGlobal_StartObserverMode")
WatchingModeInt()
