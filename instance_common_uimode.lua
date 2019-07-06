local isMovableMode = false
function FromClient_SetGameUIMode()
  SetUIMode(Defines.UIMode.eUIMode_Default)
end
function checkAndSetPosInScreen(panel)
  local posX = panel:GetPosX()
  local posY = panel:GetPosY()
  local sizeX = panel:GetSizeX()
  local sizeY = panel:GetSizeY()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if posX < 0 then
    panel:SetPosX(0)
  elseif posX > screenSizeX - sizeX then
    panel:SetPosX(screenSizeX - sizeX)
  end
  if posY < 0 then
    panel:SetPosY(0)
  elseif posY > screenSizeY - sizeY then
    panel:SetPosY(screenSizeY - sizeY)
  end
end
function changePositionBySever(panel, panelId, isShow, isChangePosition, isChangeSize)
  if 0 < ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    if isShow then
      panel:SetShow(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
    end
    if isChangePosition then
      panel:SetPosX(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_PositionX))
      panel:SetPosY(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_PositionY))
      local relativePosX = ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionX)
      local relativePosY = ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_RelativePositionY)
      panel:SetRelativePosX(relativePosX)
      panel:SetRelativePosY(relativePosY)
    end
    if isChangeSize then
      panel:SetSize(ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_SizeX), ToClient_GetUiInfo(panelId, 0, CppEnums.PanelSaveType.PanelSaveType_SizeY))
    end
    if isChangePosition or isChangeSize then
      checkAndSetPosInScreen(panel)
    end
    return true
  end
  return false
end
function FGlobal_PanelMove(panel, isOnlyMovableMode)
  panel:addInputEvent("Mouse_LPress", "FGlobal_SaveUiInfo(" .. tostring(isOnlyMovableMode) .. ")")
end
function FGlobal_SaveUiInfo(isOnlyMovableMode)
  if not isOnlyMovableMode or isMovableMode then
    ToClient_SaveUiInfo(false)
  end
end
function FGlobal_SetMovableMode(isMovable)
  isMovableMode = isMovable
end
function FGlobal_IsCommercialService()
  if getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial then
    return true
  else
    return false
  end
end
function FGlobal_PanelMoveIntoScreen(panel)
  if panel:GetPosX() < 0 then
    panel:SetPosX(0)
  elseif getScreenSizeX() <= panel:GetPosX() + panel:GetSizeX() then
    panel:SetPosX(getScreenSizeX() - panel:GetSizeX())
  end
  if 0 > panel:GetPosY() then
    panel:SetPosY(0)
  elseif getScreenSizeY() <= panel:GetPosY() + panel:GetSizeY() then
    panel:SetPosY(getScreenSizeY() - panel:GetSizeY())
  end
end
function FGlobal_InitPanelRelativePos(panel, initPosX, initPosY)
  if initPosX == panel:GetPosX() and initPosY == panel:GetPosY() then
    panel:SetRelativePosX(0)
    panel:SetRelativePosY(0)
  else
    panel:SetRelativePosX((panel:GetPosX() + panel:GetSizeX() / 2) / getScreenSizeX())
    panel:SetRelativePosY((panel:GetPosY() + panel:GetSizeY() / 2) / getScreenSizeY())
  end
end
function FGlobal_PanelRepostionbyScreenOut(panel)
  local posX = panel:GetPosX()
  local posY = panel:GetPosY()
  local sizeX = panel:GetSizeX()
  local sizeY = panel:GetSizeY()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  if screenSizeX < posX + sizeX then
    panel:SetPosX(screenSizeX - panel:GetSizeX())
  elseif posX < 0 then
    panel:SetPosX(1)
  end
  if screenSizeY < posY + sizeY then
    panel:SetPosY(screenSizeY - panel:GetSizeY())
  elseif posY < 0 then
    panel:SetPosY(1)
  end
end
registerEvent("FromClient_SetGameUIMode", "FromClient_SetGameUIMode")
