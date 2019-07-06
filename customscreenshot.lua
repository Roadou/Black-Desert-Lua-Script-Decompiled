Panel_Widget_ScreenShotFrame:SetShow(false)
Panel_Widget_ScreenShotFrame:ActiveMouseEventEffect(true)
Panel_Widget_ScreenShotFrame:setGlassBackground(true)
local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_customScreenShot
}, false)
local KeyCode_ESCAPE = 27
local KeyCode_SPACE = 32
local KeyCode_RETURN = 13
local KeyCode_ADD = 107
local KeyCode_SUBTRACT = 109
local frameArea = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Static_Frame")
local btnIncrease = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Button_Increase")
local btnDecrease = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Button_Decrease")
local btnScreenShot = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Button_ScreenShot")
local ScreenShotFramedesc = UI.getChildControl(Panel_Widget_ScreenShotFrame, "StaticText_Desc")
local photoFilter = {
  _bg = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Static_SelectTerritoryBg"),
  _title = UI.getChildControl(Panel_Widget_ScreenShotFrame, "StaticText_FilterTitle"),
  _name = UI.getChildControl(Panel_Widget_ScreenShotFrame, "StaticText_FilterValue"),
  _btnLeft = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Button_Left"),
  _btnRight = UI.getChildControl(Panel_Widget_ScreenShotFrame, "Button_Right")
}
local desc1 = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_DESC_1")
local desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_DESC_2")
local basePosX = getScreenSizeX() / 2 - Panel_Widget_ScreenShotFrame:GetSizeX() / 2
local basePosY = getScreenSizeY() / 2 - Panel_Widget_ScreenShotFrame:GetSizeY() / 2
local baseWidth = frameArea:GetSizeX()
local baseHeight = frameArea:GetSizeY()
local increaseSizeX = 100
local increaseSizeY = 110
local posX, posY, width, height
local subNameString = ""
local meanunglessNumber = -1
local prevUiMode
local CheckUIModebyCustomScreenShot = function()
  if ToClient_isGamePlayProcessor() == false then
    return false
  end
  if Defines.UIMode.eUIMode_Default ~= GetUIMode() and Defines.UIMode.eUIMode_InGameCustomize ~= GetUIMode() then
    ToClient_cancelRequestAddToFile()
    return true
  end
  return false
end
function FromClient_OpenExplorer_CustomizingCharacter(title, defaultName, paramList)
  local paramCount = 0
  local subNameStringBDC = ""
  for key, value in pairs(paramList) do
    if ".bdcp" == string.sub(value, 1, 5) or ".bdc" ~= string.sub(value, 1, 4) then
      return
    end
    subNameStringBDC = string.sub(value, 5, -2)
    if "" == subNameStringBDC then
      subNameStringBDC = "_"
    end
    paramCount = paramCount + 1
    if paramCount > 1 then
      return
    end
  end
  if 1 ~= paramCount or "" ~= title then
    return
  end
  if false == _ContentsGroup_RenewUI_Customization then
    ToClient_UploadWebCustomizingCharacter(false == Panel_CustomizationMain:GetShow(), subNameStringBDC)
  else
    ToClient_UploadWebCustomizingCharacter(false == PaGlobalFunc_Customization_GetShow(), subNameStringBDC)
  end
end
function FromClient_OpenExplorer_CustomSizeScreenShot(title, defaultName, paramList)
  local paramCount = 0
  for key, value in pairs(paramList) do
    if ".bds" ~= string.sub(value, 1, 4) then
      return
    end
    subNameString = string.sub(value, 5, -2)
    if "" == subNameString then
      subNameString = "_"
    end
    paramCount = paramCount + 1
    if paramCount > 1 then
      return
    end
  end
  if 1 ~= paramCount or "" ~= title then
    return
  end
  if CheckUIModebyCustomScreenShot() then
    return
  end
  subNameString = subNameString .. "_BeautyAlbum"
  ScreenShotFrame_Show()
end
local currentLUT
function ScreenshotFrame_PhotoFilterShow()
  for _, control in pairs(photoFilter) do
    control:SetShow(true)
    control:ComputePos()
  end
  currentLUT = FGlobal_GetCurrentLUT()
  local filterName = getCameraLUTFilterName(currentLUT)
  photoFilter._name:SetText(filterName)
  setCameraLUTFilter(currentLUT)
end
function ScreenshotFrame_PhotoFilterHide()
  for _, control in pairs(photoFilter) do
    control:SetShow(false)
  end
end
function ScreenshotFrame_SetFilter(LUT)
  currentLUT = LUT
  local filterName = getCameraLUTFilterName(LUT)
  photoFilter._name:SetText(filterName)
  setCameraLUTFilter(LUT)
end
function ScreenshotFrame_LUTIncrease()
  ScreenshotFrame_SetFilter(currentLUT + 1)
end
function ScreenshotFrame_LUTDecrease()
  ScreenshotFrame_SetFilter(currentLUT - 1)
end
photoFilter._btnLeft:addInputEvent("Mouse_LUp", "ScreenshotFrame_LUTDecrease()")
photoFilter._btnRight:addInputEvent("Mouse_LUp", "ScreenshotFrame_LUTIncrease()")
function FromClient_OpenExplorer_FullScreenSizeScreenShot(title, defaultName, paramList)
  local paramCount = 0
  for key, value in pairs(paramList) do
    if ".bdf" ~= string.sub(value, 1, 4) then
      return
    end
    subNameString = string.sub(value, 5, -2)
    if "" == subNameString then
      subNameString = "_"
    end
    paramCount = paramCount + 1
    if paramCount > 1 then
      return
    end
  end
  if 1 ~= paramCount or "" ~= title then
    return
  end
  if CheckUIModebyCustomScreenShot() then
    return
  end
  meanunglessNumber = meanunglessNumber + 1
  subNameString = subNameString .. "_PhotoGallery_" .. tostring(meanunglessNumber)
  FullScreenShotFrame_Show()
end
local isFullScreenShotMode = false
function FullScreenShotFrame_Show()
  isFullScreenShotMode = true
  prevUiMode = GetUIMode()
  SetUIMode(Defines.UIMode.eUIMode_ScreenShotMode)
  setRenderCrossHair(false)
  renderMode:set()
  local gameoptionController = ToClient_getGameOptionControllerWrapper()
  if gameoptionController:getCropModeEnable() == false then
    Panel_Widget_ScreenShotFrame:SetShow(true)
    Panel_Widget_ScreenShotFrame:SetSize(getScreenSizeX(), getScreenSizeY())
    Panel_Widget_ScreenShotFrame:SetPosX(0)
    Panel_Widget_ScreenShotFrame:SetPosY(0)
    frameArea:SetSize(getScreenSizeX(), getScreenSizeY())
    width = getResolutionSizeX()
    height = getResolutionSizeY()
  else
    Panel_Widget_ScreenShotFrame:SetShow(true)
    Panel_Widget_ScreenShotFrame:SetSize(getScreenSizeX(), getScreenSizeY())
    Panel_Widget_ScreenShotFrame:SetPosX(0)
    Panel_Widget_ScreenShotFrame:SetPosY(0)
    frameArea:SetSize(getScreenSizeX() * gameoptionController:getCropModeScaleX(), getScreenSizeY() * gameoptionController:getCropModeScaleY())
    width = getResolutionSizeX() * gameoptionController:getCropModeScaleX()
    height = getResolutionSizeY() * gameoptionController:getCropModeScaleY()
  end
  frameArea:ComputePos()
  btnIncrease:SetShow(false)
  btnDecrease:SetShow(false)
  btnScreenShot:SetSpanSize(0, 60)
  btnScreenShot:ComputePos()
  ScreenShotFramedesc:SetSpanSize(0, 30)
  ScreenShotFramedesc:ComputePos()
  ScreenshotFrame_PhotoFilterShow()
  Panel_Widget_ScreenShotFrame:SetIgnore(true)
  ToClient_setScreenShotModeState(true)
end
function ScreenShotFrame_Show()
  isFullScreenShotMode = false
  if ToClient_isLobbyProcessor() then
    if not isShowCustomizationMain() then
      Proc_ShowMessage_Ack_WithOut_ChattingMessage("\237\152\132\236\158\172 \235\139\168\234\179\132\236\151\144\236\132\156\235\138\148 \236\138\164\237\129\172\235\166\176\236\131\183\236\157\132 \236\176\141\236\157\132 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    FGlobal_CustomizingAlbum_Close()
    FGlobal_Customization_UiClose()
    ScreenShotFramedesc:SetText(desc2)
  elseif Defines.UIMode.eUIMode_InGameCustomize == GetUIMode() then
    if not isShowCustomizationMain() then
      Proc_ShowMessage_Ack_WithOut_ChattingMessage("\237\152\132\236\158\172 \235\139\168\234\179\132\236\151\144\236\132\156\235\138\148 \236\138\164\237\129\172\235\166\176\236\131\183\236\157\132 \236\176\141\236\157\132 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    FGlobal_CustomizingAlbum_Close()
    FGlobal_Customization_UiClose()
    ScreenShotFramedesc:SetText(desc2)
  else
    prevUiMode = GetUIMode()
    SetUIMode(Defines.UIMode.eUIMode_ScreenShotMode)
    setRenderCrossHair(false)
    renderMode:set()
    ScreenShotFramedesc:SetText(desc1)
  end
  Panel_Widget_ScreenShotFrame:SetShow(true)
  Panel_Widget_ScreenShotFrame:SetSize(baseWidth, baseHeight)
  Panel_Widget_ScreenShotFrame:SetPosX(basePosX)
  Panel_Widget_ScreenShotFrame:SetPosY(basePosY)
  frameArea:SetSize(baseWidth, baseHeight)
  frameArea:ComputePos()
  btnIncrease:ComputePos()
  btnDecrease:ComputePos()
  btnScreenShot:SetSpanSize(60, -60)
  ScreenShotFramedesc:SetSpanSize(0, -90)
  btnScreenShot:ComputePos()
  ScreenShotFramedesc:ComputePos()
  width = baseWidth
  height = baseHeight
  btnIncrease:SetShow(true)
  btnDecrease:SetShow(true)
  btnIncrease:addInputEvent("Mouse_LUp", "ScreenShotFrameSize_Increase()")
  btnDecrease:addInputEvent("Mouse_LUp", "ScreenShotFrameSize_Decrease()")
  ScreenshotFrame_PhotoFilterHide()
  ToClient_setScreenShotModeState(true)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_CUSTOMSCREENSHOT")
end
function ScreenShotFrameSize_Increase()
  if isFullScreenShotMode then
    return
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelPosX = Panel_Widget_ScreenShotFrame:GetPosX()
  local panelPosY = Panel_Widget_ScreenShotFrame:GetPosY()
  if panelPosX + frameArea:GetPosX() - increaseSizeX / 2 < 0 or scrSizeX < panelPosX + frameArea:GetPosX() + width + increaseSizeX / 2 then
    return
  end
  if panelPosY + frameArea:GetPosY() - increaseSizeY < 0 then
    return
  end
  width = width + increaseSizeX
  height = height + increaseSizeY
  Panel_Widget_ScreenShotFrame:SetSize(width, height)
  Panel_Widget_ScreenShotFrame:SetPosX(panelPosX - increaseSizeX / 2)
  Panel_Widget_ScreenShotFrame:SetPosY(panelPosY - increaseSizeY)
  Panel_Widget_ScreenShotFrame:SetDragEnable(true)
  Panel_Widget_ScreenShotFrame:SetDragAll(true)
  frameArea:SetSize(width, height)
  frameArea:ComputePos()
  btnIncrease:ComputePos()
  btnDecrease:ComputePos()
  btnScreenShot:ComputePos()
  ScreenShotFramedesc:ComputePos()
end
function ScreenShotFrameSize_Decrease()
  if isFullScreenShotMode then
    return
  end
  if width - increaseSizeX < baseWidth or height - increaseSizeY < baseHeight then
    return
  end
  width = width - increaseSizeX
  height = height - increaseSizeY
  Panel_Widget_ScreenShotFrame:SetSize(width, height)
  Panel_Widget_ScreenShotFrame:SetPosX(Panel_Widget_ScreenShotFrame:GetPosX() + increaseSizeX / 2)
  Panel_Widget_ScreenShotFrame:SetPosY(Panel_Widget_ScreenShotFrame:GetPosY() + increaseSizeY)
  Panel_Widget_ScreenShotFrame:SetDragEnable(true)
  Panel_Widget_ScreenShotFrame:SetDragAll(true)
  frameArea:SetSize(width, height)
  frameArea:ComputePos()
  btnIncrease:ComputePos()
  btnDecrease:ComputePos()
  btnScreenShot:ComputePos()
  ScreenShotFramedesc:ComputePos()
end
function ScreenShotSave_ForWeb()
  local currentUiScale = ToClient_getGameOptionControllerWrapper():getUIScale()
  posX = Panel_Widget_ScreenShotFrame:GetPosX() * currentUiScale
  posY = Panel_Widget_ScreenShotFrame:GetPosY() * currentUiScale
  Panel_Widget_ScreenShotFrame:SetShow(false)
  local gameoptionController = ToClient_getGameOptionControllerWrapper()
  if isFullScreenShotMode then
    if gameoptionController:getCropModeEnable() == false then
      posX = Panel_Widget_ScreenShotFrame:GetPosX()
      posY = Panel_Widget_ScreenShotFrame:GetPosY()
    else
      posX = frameArea:GetPosX() * currentUiScale
      posY = frameArea:GetPosY() * currentUiScale
    end
  else
    width = width * currentUiScale
    height = height * currentUiScale
  end
  ToClient_ProgressCapture(posX, posY, width, height, subNameString)
end
function FromClient_CustomizedCaptureComplete()
  ScreenShotFrame_Close()
end
function ScreenShotFrame_Close()
  Panel_Widget_ScreenShotFrame:SetShow(false)
  ToClient_cancelRequestAddToFile()
  if ToClient_isLobbyProcessor() then
    FGlobal_Customization_UiShow()
    FGlobal_CustomizingAlbum_ShowByScreenShotFrame()
  elseif Defines.UIMode.eUIMode_ScreenShotMode ~= GetUIMode() then
    FGlobal_Customization_UiShow()
    FGlobal_CustomizingAlbum_ShowByScreenShotFrame()
  else
    SetUIMode(prevUiMode)
    setRenderCrossHair(true)
    renderMode:reset()
  end
  if isFullScreenShotMode then
    setCameraLUTFilter(FGlobal_GetCurrentLUT())
  end
  Panel_Widget_ScreenShotFrame:SetIgnore(false)
  ToClient_setScreenShotModeState(false)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function FGlobal_ScreenShotFrame_Close()
  ScreenShotFrame_Close()
end
function FGlobal_TakeAScreenShot()
  ScreenShotSave_ForWeb()
end
function ScreenShotFrame_RePos()
  if ToClient_isLobbyProcessor() then
    if isKeyDown_Once(KeyCode_ESCAPE) then
      local screenShotFrame_Close = function()
        FGlobal_ScreenShotFrame_Close()
      end
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_MSGBOX_CONTENT")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_SCREENSHOTFRAME_MSGBOX_TITLE"),
        content = messageBoxMemo,
        functionYes = screenShotFrame_Close,
        functionNo = MessageBox_Empty_function,
        exitButton = true,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    elseif isKeyDown_Once(KeyCode_SPACE) or isKeyDown_Once(KeyCode_RETURN) then
      FGlobal_TakeAScreenShot()
    elseif isKeyDown_Once(KeyCode_ADD) then
      ScreenShotFrameSize_Increase()
    elseif isKeyDown_Once(KeyCode_SUBTRACT) then
      ScreenShotFrameSize_Decrease()
    end
  end
  if isFullScreenShotMode then
    return
  end
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  local posX = Panel_Widget_ScreenShotFrame:GetPosX()
  local posY = Panel_Widget_ScreenShotFrame:GetPosY()
  local sizeX = Panel_Widget_ScreenShotFrame:GetSizeX()
  local sizeY = Panel_Widget_ScreenShotFrame:GetSizeY()
  if posX < 10 then
    Panel_Widget_ScreenShotFrame:SetPosX(10)
  end
  if scrX - 10 < posX + sizeX then
    Panel_Widget_ScreenShotFrame:SetPosX(scrX - sizeX - 10)
  end
  if posY < 10 then
    Panel_Widget_ScreenShotFrame:SetPosY(10)
  end
  if ToClient_isLobbyProcessor() then
    if scrY - 90 < posY + sizeY then
      Panel_Widget_ScreenShotFrame:SetPosY(scrY - sizeY - 90)
    end
  elseif Defines.UIMode.eUIMode_ScreenShotMode == GetUIMode() then
    if scrY - 100 < posY + sizeY then
      Panel_Widget_ScreenShotFrame:SetPosY(scrY - sizeY - 100)
    end
  elseif scrY - 90 < posY + sizeY then
    Panel_Widget_ScreenShotFrame:SetPosY(scrY - sizeY - 90)
  end
end
btnScreenShot:addInputEvent("Mouse_LUp", "ScreenShotSave_ForWeb()")
Panel_Widget_ScreenShotFrame:RegisterUpdateFunc("ScreenShotFrame_RePos")
registerEvent("FromClient_OpenExplorer", "FromClient_OpenExplorer_FullScreenSizeScreenShot")
registerEvent("FromClient_OpenExplorer", "FromClient_OpenExplorer_CustomSizeScreenShot")
registerEvent("FromClient_OpenExplorer", "FromClient_OpenExplorer_CustomizingCharacter")
registerEvent("FromClient_CustomizedCaptureComplete", "FromClient_CustomizedCaptureComplete")
renderMode:setClosefunctor(renderMode, FGlobal_ScreenShotFrame_Close)
