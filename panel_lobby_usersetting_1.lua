function PaGlobal_LobbyUserSetting:initialize()
  if true == PaGlobal_LobbyUserSetting._initialize then
    return
  end
  PaGlobal_LobbyUserSetting._ui.stc_offsetGroup = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_mainBG, "Static_OffsetButtonGroup")
  PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_mainBG, "Static_HDRSliderGroup")
  PaGlobal_LobbyUserSetting._ui.txt_keyGuideA = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_bottomBg, "StaticText_A_ConsoleUI")
  PaGlobal_LobbyUserSetting._ui.txt_keyGuideB = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_bottomBg, "StaticText_B_ConsoleUI")
  PaGlobal_LobbyUserSetting._ui.txt_offsetTitle = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_offsetGroup, "StaticText_Title")
  PaGlobal_LobbyUserSetting._ui.txt_offsetDesc = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_offsetGroup, "StaticText_Desc")
  PaGlobal_LobbyUserSetting._ui.txt_HDRSliderTitle = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup, "StaticText_Title")
  PaGlobal_LobbyUserSetting._ui.txt_HDRSliderDesc = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup, "StaticText_Desc")
  PaGlobal_LobbyUserSetting._ui._HDRSlider = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup, "Slider_Template")
  PaGlobal_LobbyUserSetting._ui._HDRSliderButton = UI.getChildControl(PaGlobal_LobbyUserSetting._ui._HDRSlider, "Slider_Button")
  PaGlobal_LobbyUserSetting._ui._HDRProgress = UI.getChildControl(PaGlobal_LobbyUserSetting._ui._HDRSlider, "Progress2_1")
  PaGlobal_LobbyUserSetting._ui._slider_DisplayButton = UI.getChildControl(PaGlobal_LobbyUserSetting._ui._HDRSlider, "Slider_DisplayButton")
  PaGlobal_LobbyUserSetting._ui.txt_setLater = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_mainBG, "StaticText_SetLater")
  PaGlobal_LobbyUserSetting._ui.stc_HDRImage = UI.getChildControl(PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup, "Static_HDR_Image")
  PaGlobal_LobbyUserSetting._ui.txt_offsetDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LobbyUserSetting._ui.txt_offsetDesc:SetText(PaGlobal_LobbyUserSetting._ui.txt_offsetDesc:GetText())
  if true == getHdrDiplayEnable() then
    PaGlobal_LobbyUserSetting._ui.txt_HDRSliderTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GAMEOPTION_HDR_GAMMA_TITLE"))
  else
    PaGlobal_LobbyUserSetting._ui.txt_HDRSliderTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_GammaValue"))
  end
  PaGlobal_LobbyUserSetting._ui.txt_HDRSliderDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LobbyUserSetting._ui.txt_HDRSliderDesc:SetText(PaGlobal_LobbyUserSetting._ui.txt_HDRSliderDesc:GetText())
  PaGlobal_LobbyUserSetting._ui.txt_setLater:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_LobbyUserSetting._ui.txt_setLater:SetText(PaGlobal_LobbyUserSetting._ui.txt_setLater:GetText())
  PaGlobal_LobbyUserSetting._ui._HDRSlider:SetControlPos(50)
  PaGlobal_LobbyUserSetting:setSlider()
  local tempKeyGroup = {
    PaGlobal_LobbyUserSetting._ui.txt_keyGuideA,
    PaGlobal_LobbyUserSetting._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempKeyGroup, PaGlobal_LobbyUserSetting._ui.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_LobbyUserSetting:registEventHandler()
  PaGlobal_LobbyUserSetting:validate()
  PaGlobal_LobbyUserSetting._initialize = true
end
function PaGlobal_LobbyUserSetting:registEventHandler()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  local _panel = Panel_Lobby_UserSetting
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_LobbyUserSetting_DoStep()")
  PaGlobal_LobbyUserSetting._ui._HDRSlider:addInputEvent("Mouse_LPress", "PaGlobal_LobbyUserSetting_SetGamma()")
end
function PaGlobal_LobbyUserSetting:prepareOpen()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  PaGlobal_LobbyUserSetting:doStep()
  PaGlobal_LobbyUserSetting:open()
end
function PaGlobal_LobbyUserSetting:open()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  Panel_Lobby_UserSetting:SetShow(true)
end
function PaGlobal_LobbyUserSetting:prepareClose()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  PaGlobal_LobbyUserSetting._currentStep = 1
  PaGlobal_LobbyUserSetting:close()
end
function PaGlobal_LobbyUserSetting:close()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  Panel_Lobby_UserSetting:SetShow(false)
end
function PaGlobal_LobbyUserSetting:reposition()
  if nil == PaGlobal_LobbyUserSetting then
    return
  end
  local panelResizeY = 0
  local currentStep = PaGlobal_LobbyUserSetting._currentStep
  if PaGlobal_LobbyUserSetting._configStep.HDR == currentStep then
    panelResizeY = PaGlobal_LobbyUserSetting._ui.txt_HDRSliderTitle:GetTextSizeY() + PaGlobal_LobbyUserSetting._ui.txt_HDRSliderDesc:GetTextSizeY() + PaGlobal_LobbyUserSetting._ui.stc_bottomBg:GetSizeY() + PaGlobal_LobbyUserSetting._ui.stc_mainBG:GetSpanSize().y + PaGlobal_LobbyUserSetting._ui.txt_setLater:GetTextSizeY() + PaGlobal_LobbyUserSetting._ui.stc_HDRImage:GetSizeY() + PaGlobal_LobbyUserSetting._ui.stc_HDRImage:GetSpanSize().y + 50
  else
    return
  end
  Panel_Lobby_UserSetting:SetSize(Panel_Lobby_UserSetting:GetSizeX(), panelResizeY)
  PaGlobal_LobbyUserSetting._ui.stc_mainBG:SetSize(PaGlobal_LobbyUserSetting._ui.stc_mainBG:GetSizeX(), Panel_Lobby_UserSetting:GetSizeY() - (PaGlobal_LobbyUserSetting._ui.stc_mainBG:GetSpanSize().y + 60))
  PaGlobal_LobbyUserSetting._ui.stc_bottomBg:ComputePos()
  PaGlobal_LobbyUserSetting._ui.txt_setLater:ComputePos()
  Panel_Lobby_UserSetting:ComputePos()
end
function PaGlobal_LobbyUserSetting:doStep()
  if nil == PaGlobal_LobbyUserSetting then
    return
  end
  local tempKeyGroup = {}
  local currentStep = PaGlobal_LobbyUserSetting._currentStep
  if PaGlobal_LobbyUserSetting._configStep.HDR == currentStep then
    PaGlobal_LobbyUserSetting._ui.stc_offsetGroup:SetShow(false)
    PaGlobal_LobbyUserSetting._ui.stc_HDRSliderGroup:SetShow(true)
    tempKeyGroup = {
      PaGlobal_LobbyUserSetting._ui.txt_keyGuideA,
      PaGlobal_LobbyUserSetting._ui.txt_keyGuideB
    }
  else
    PaGlobalFunc_UserSetting_ShowPolicy()
    PaGlobalFunc_UserSetting_Close()
    return
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempKeyGroup, PaGlobal_LobbyUserSetting._ui.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_LobbyUserSetting:reposition()
  PaGlobal_LobbyUserSetting._currentStep = PaGlobal_LobbyUserSetting._currentStep + 1
end
function PaGlobal_LobbyUserSetting:validate()
  if nil == Panel_Lobby_UserSetting then
    return
  end
  PaGlobal_LobbyUserSetting._ui.stc_mainBG:isValidate()
  PaGlobal_LobbyUserSetting._ui.stc_bottomBg:isValidate()
end
function PaGlobal_LobbyUserSetting:setSlider()
  if nil == PaGlobal_LobbyUserSetting then
    return
  end
  local value = PaGlobal_LobbyUserSetting._ui._HDRSlider:GetControlPos()
  local realValue = math.floor(PaGlobal_LobbyUserSetting:FromSliderValueToRealValue(value, PaGlobal_LobbyUserSetting._sliderValueMin, PaGlobal_LobbyUserSetting._sliderValueMax))
  PaGlobal_LobbyUserSetting._ui._HDRProgress:SetProgressRate(value * 100)
  PaGlobal_LobbyUserSetting._ui._slider_DisplayButton:SetText(tostring(realValue))
  PaGlobal_LobbyUserSetting._ui._slider_DisplayButton:SetPosX(PaGlobal_LobbyUserSetting._ui._HDRSliderButton:GetPosX())
  PaGlobal_LobbyUserSetting:setGamma(value)
end
function PaGlobal_LobbyUserSetting:setGamma(value)
  if nil == PaGlobal_LobbyUserSetting then
    return
  end
  value = PaGlobal_LobbyUserSetting:FromSliderValueToRealValue(value, PaGlobal_LobbyUserSetting._sliderValueMin, PaGlobal_LobbyUserSetting._sliderValueMax)
  value = value * 0.01
  setHdrDisplayGamma(value)
end
function PaGlobal_LobbyUserSetting:FromSliderValueToRealValue(value, min, max)
  if nil == PaGlobal_LobbyUserSetting then
    return
  end
  function clamp(value, lower, upper)
    if upper < lower then
      lower, upper = upper, lower
    end
    return math.max(lower, math.min(upper, value))
  end
  value = clamp(value, 0, 1)
  local offset = max - min
  value = value * offset
  value = value + min
  return value
end
