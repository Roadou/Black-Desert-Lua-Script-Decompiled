function PaGlobal_AreaOfHadum:initialize()
  if true == PaGlobal_AreaOfHadum._initialize then
    return
  end
  self._ui._createTotemButton = UI.getChildControl(Panel_Widget_AreaOfHadum, "CheckButton_Start")
  self._ui._openAndCloseButton = UI.getChildControl(Panel_Widget_AreaOfHadum, "Button_Show")
  self._ui._pointProgressBar = UI.getChildControl(Panel_Widget_AreaOfHadum, "Progress2_HadumExp")
  self._ui._pointTextBox = UI.getChildControl(Panel_Widget_AreaOfHadum, "StaticText_Point")
  self._ui._hadumIcon = UI.getChildControl(Panel_Widget_AreaOfHadum, "Static_HadumIcon")
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_AreaOfHadum:registEventHandler()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  self._ui._createTotemButton:addInputEvent("Mouse_LUp", "HandleEventMouseLup_AreaOfHadum_CreateTotem()")
  self._ui._openAndCloseButton:addInputEvent("Mouse_LUp", "HandleEventMouseLup_AreaOfHadum_ChangeOpenState()")
  self._ui._hadumIcon:addInputEvent("Mouse_On", "HandleEventMouseOn_AreaOfHadum_ShowTooltip(true)")
  self._ui._hadumIcon:addInputEvent("Mouse_Out", "HandleEventMouseOn_AreaOfHadum_ShowTooltip(false)")
  registerEvent("FromClient_UpdateAreaOfHadumPoint", "FromClient_UpdateAreaOfHadumPoint")
  registerEvent("FromClient_SpawnTotemUpdated", "FromClient_SpawnTotemUpdated")
  registerEvent("onScreenResize", "PaGlobalFunc_AreaOfHadum_updatePanelPosition")
end
function PaGlobal_AreaOfHadum:prepareOpen()
  if nil == Panel_Widget_AreaOfHadum or false == self._initialize then
    return
  end
  PaGlobal_AreaOfHadum:updatePanelPosition()
  self:OpenAnimation()
  self:OpenAndCloseButtonChangeToCloseIcon()
  FromClient_UpdateAreaOfHadumPoint()
  self._ui._isOpen = true
  self:open()
  PaGlobalFunc_PartyWidget_SetScreenSize()
end
function PaGlobal_AreaOfHadum:open()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  Panel_Widget_AreaOfHadum:SetShow(true)
end
function PaGlobal_AreaOfHadum:prepareClose()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  self._ui._isOpen = false
  self._ui._initialize = false
  self:close()
  PaGlobalFunc_PartyWidget_SetScreenSize()
end
function PaGlobal_AreaOfHadum:close()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  Panel_Widget_AreaOfHadum:SetShow(false)
end
function PaGlobal_AreaOfHadum:update()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
end
function PaGlobal_AreaOfHadum:validate()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  self._ui._createTotemButton:isValidate()
  self._ui._openAndCloseButton:isValidate()
  self._ui._pointProgressBar:isValidate()
  self._ui._pointTextBox:isValidate()
  self._ui._hadumIcon:isValidate()
end
function PaGlobal_AreaOfHadum:OpenAnimation()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local showAnimationControl = Panel_Widget_AreaOfHadum:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAnimationControl:SetStartPosition(-Panel_Widget_AreaOfHadum:GetSizeX(), Panel_Widget_AreaOfHadum:GetPosY())
  showAnimationControl:SetEndPosition(0, Panel_Widget_AreaOfHadum:GetPosY())
  showAnimationControl.IsChangeChild = true
  Panel_Widget_AreaOfHadum:CalcUIAniPos(showAnimationControl)
  showAnimationControl:SetDisableWhileAni(true)
end
function PaGlobal_AreaOfHadum:CloseAnimation()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  local hideAnimationControl = Panel_Widget_AreaOfHadum:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  hideAnimationControl:SetStartPosition(0, Panel_Widget_AreaOfHadum:GetPosY())
  hideAnimationControl.IsChangeChild = true
  hideAnimationControl:SetEndPosition(-Panel_Widget_AreaOfHadum:GetSizeX() + 100, Panel_Widget_AreaOfHadum:GetPosY())
  Panel_Widget_AreaOfHadum:CalcUIAniPos(hideAnimationControl)
  hideAnimationControl:SetDisableWhileAni(true)
end
function PaGlobal_AreaOfHadum:CreateTotemButtonChangeToCreateIcon()
  if nil == Panel_Widget_AreaOfHadum or false == self._initialize then
    return
  end
  local creatTotemButton = self._ui._createTotemButton
  local texturePath = "renewal/pcremaster/remaster_hadum_01.dds"
  creatTotemButton:ChangeTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 1, 99, 49, 147)
  creatTotemButton:getBaseTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeOnTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 50, 99, 98, 147)
  creatTotemButton:getOnTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeClickTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 99, 99, 147, 147)
  creatTotemButton:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_AreaOfHadum:CreateTotemButtonChangeToClearIcon()
  if nil == Panel_Widget_AreaOfHadum or false == self._initialize then
    return
  end
  local creatTotemButton = self._ui._createTotemButton
  local texturePath = "renewal/pcremaster/remaster_hadum_01.dds"
  creatTotemButton:ChangeTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 1, 50, 49, 98)
  creatTotemButton:getBaseTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeOnTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 50, 50, 98, 98)
  creatTotemButton:getOnTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeClickTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 99, 50, 147, 98)
  creatTotemButton:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_AreaOfHadum:OpenAndCloseButtonChangeToOpenIcon()
  if nil == Panel_Widget_AreaOfHadum or false == self._initialize then
    return
  end
  local creatTotemButton = self._ui._openAndCloseButton
  local texturePath = "renewal/pcremaster/remaster_hadum_01.dds"
  creatTotemButton:ChangeTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 73, 6, 93, 27)
  creatTotemButton:getBaseTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeOnTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 94, 6, 114, 27)
  creatTotemButton:getOnTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeClickTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 115, 6, 135, 27)
  creatTotemButton:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobal_AreaOfHadum:OpenAndCloseButtonChangeToCloseIcon()
  if nil == Panel_Widget_AreaOfHadum or false == self._initialize then
    return
  end
  local creatTotemButton = self._ui._openAndCloseButton
  local texturePath = "renewal/pcremaster/remaster_hadum_01.dds"
  creatTotemButton:ChangeTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 115, 28, 135, 49)
  creatTotemButton:getBaseTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeOnTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 94, 28, 114, 49)
  creatTotemButton:getOnTexture():setUV(x1, y1, x2, y2)
  creatTotemButton:ChangeClickTextureInfoName(texturePath)
  x1, y1, x2, y2 = setTextureUV_Func(creatTotemButton, 115, 28, 135, 49)
  creatTotemButton:getClickTexture():setUV(x1, y1, x2, y2)
end
function PaGlobalFunc_AreaOfHadum_updatePanelPosition()
  PaGlobal_AreaOfHadum:updatePanelPosition()
end
function PaGlobal_AreaOfHadum:updatePanelPosition()
  if nil == Panel_Widget_AreaOfHadum then
    return
  end
  Panel_Widget_AreaOfHadum:ComputePos()
  local initPosX = Panel_Widget_AreaOfHadum:GetPosX()
  local initPosY = Panel_MainStatus_Remaster:GetSizeY() + 5
  if -1 == Panel_Widget_AreaOfHadum:GetRelativePosX() or -1 == Panel_Widget_AreaOfHadum:GetRelativePosY() then
    changePositionBySever(Panel_Widget_AreaOfHadum, CppEnums.PAGameUIType.PAGameUIPanel_AreaOfHadum, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_Widget_AreaOfHadum, initPosX, initPosY)
  elseif Panel_Widget_AreaOfHadum:GetRelativePosX() == 0 or Panel_Widget_AreaOfHadum:GetRelativePosY() == 0 then
    Panel_Widget_AreaOfHadum:SetPosX(initPosX)
    Panel_Widget_AreaOfHadum:SetPosY(initPosY)
  else
    Panel_Widget_AreaOfHadum:SetPosX(getScreenSizeX() * Panel_Widget_AreaOfHadum:GetRelativePosX() - Panel_Widget_AreaOfHadum:GetSizeX() / 2)
    Panel_Widget_AreaOfHadum:SetPosY(getScreenSizeY() * Panel_Widget_AreaOfHadum:GetRelativePosY() - Panel_Widget_AreaOfHadum:GetSizeY() / 2)
  end
end
function PaGlobal_AreaOfHadum_IsDefaultPos()
  if nil == Panel_Widget_AreaOfHadum then
    return false
  end
  return 0 == Panel_Widget_AreaOfHadum:GetRelativePosX() or 0 == Panel_Widget_AreaOfHadum:GetRelativePosY()
end
