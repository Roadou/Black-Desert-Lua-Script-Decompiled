local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local preUIMode = Defines.UIMode.eUIMode_Default
local IM = CppEnums.EProcessorInputMode
Panel_ProductNote:SetShow(false, false)
Panel_ProductNote:ActiveMouseEventEffect(true)
Panel_ProductNote:setGlassBackground(true)
Panel_ProductNote:RegisterShowEventFunc(true, "Panel_ProductNote_ShowAni()")
Panel_ProductNote:RegisterShowEventFunc(false, "Panel_ProductNote_HideAni()")
function Panel_ProductNote_ShowAni()
  UIAni.fadeInSCR_Down(Panel_ProductNote)
  local aniInfo1 = Panel_ProductNote:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_ProductNote:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ProductNote:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ProductNote:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ProductNote:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ProductNote:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ProductNote_HideAni()
  Panel_ProductNote:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_ProductNote, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_ProductNote, "Button_Close")
local _btn_PopUp = UI.getChildControl(Panel_ProductNote, "CheckButton_PopUp")
local _titleBar = UI.getChildControl(Panel_ProductNote, "Static_TitleBg")
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
_btn_PopUp:SetShow(isPopUpContentsEnable)
_btn_PopUp:addInputEvent("Mouse_LUp", "HandleClicked_ProductNote_PopUp()")
_btn_PopUp:addInputEvent("Mouse_On", "ProductNote_PopUp_ShowIconToolTip( true )")
_btn_PopUp:addInputEvent("Mouse_Out", "ProductNote_PopUp_ShowIconToolTip( false )")
local _buttonQuestion = UI.getChildControl(Panel_ProductNote, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ProductNote\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"ProductNote\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"ProductNote\", \"false\")")
local _productWeb, sizeX, sizeY, panelSizeX, panelSizeY, titleBarSizeX
function Panel_ProductNote_Initialize()
  _productWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_ProductNote, "WebControl_ProductNote")
  _productWeb:SetShow(true)
  _productWeb:SetHorizonCenter()
  _productWeb:SetVerticalTop()
  _productWeb:SetSpanSize(0, 62)
  _productWeb:SetSize(700, 558)
  _productWeb:ResetUrl()
end
Panel_ProductNote_Initialize()
function Panel_ProductNote_ShowToggle()
  local isShow = Panel_ProductNote:IsShow()
  if ToClient_IsConferenceMode() then
    return
  end
  if isShow == true then
    FGlobal_ClearCandidate()
    _productWeb:ResetUrl()
    audioPostEvent_SystemUi(13, 5)
    Panel_ProductNote:SetShow(false, false)
    ClearFocusEdit()
    _btn_PopUp:SetCheck(false)
    if Panel_ProductNote:IsUISubApp() then
      Panel_ProductNote:CloseUISubApp()
    end
    return false
  else
    audioPostEvent_SystemUi(13, 6)
    Panel_ProductNote:SetShow(true, true)
    FGlobal_SetCandidate()
    _productWeb:SetUrl(sizeX, sizeY, "coui://UI_Data/UI_Html/Window/ProductNote/ProductNote_CategoryItemList.html?nodeProduct")
    _productWeb:SetIME(true)
    return true
  end
  return true
end
function Panel_ProductNoteClose()
end
function ProductNote_Item_ShowToggle(itemKey)
  if ToClient_IsConferenceMode() then
    return
  end
  if isShow == true then
    FGlobal_ClearCandidate()
    _productWeb:ResetUrl()
    audioPostEvent_SystemUi(13, 5)
    Panel_ProductNote:SetShow(false, false)
    if false == CheckChattingInput() then
      ClearFocusEdit()
    end
    _btn_PopUp:SetCheck(false)
    if Panel_ProductNote:IsUISubApp() then
      Panel_ProductNote:CloseUISubApp()
    end
  else
    audioPostEvent_SystemUi(13, 6)
    Panel_ProductNote:SetShow(true, true)
    FGlobal_SetCandidate()
    _productWeb:SetUrl(sizeX, sizeY, "coui://UI_Data/UI_Html/Window/ProductNote/ProductNote_CategoryItemList.html?manufacture&" .. itemKey)
    _productWeb:SetIME(true)
  end
end
function ProductNote_onScreenResize()
  local screenSizeX = getScreenSizeX()
  if screenSizeX < 1900 then
    sizeX = 700
    sizeY = 558
    panelSizeX = 740
    panelSizeY = 647
    titleBarSizeX = 739
  elseif screenSizeX >= 1900 and screenSizeX < 3800 then
    sizeX = 1050
    sizeY = 837
    panelSizeX = 1090
    panelSizeY = 928
    titleBarSizeX = 1089
  else
    sizeX = 1400
    sizeY = 1116
    panelSizeX = 1440
    panelSizeY = 1205
    titleBarSizeX = 1439
  end
  Panel_ProductNote:SetSize(panelSizeX, panelSizeY)
  _titleBar:SetSize(panelSizeX - 8, _titleBar:GetSizeY())
  _productWeb:SetSize(sizeX, sizeY)
  _productWeb:SetHorizonCenter()
  _productWeb:SetVerticalTop()
  _productWeb:SetSpanSize(0, 72)
  Panel_ProductNote:SetPosX(math.floor((getScreenSizeX() - Panel_ProductNote:GetSizeX()) / 2))
  Panel_ProductNote:SetPosY(math.floor((getScreenSizeY() - Panel_ProductNote:GetSizeY()) / 2))
end
function HandleClicked_ProductNote_PopUp()
  if _btn_PopUp:IsCheck() then
    Panel_ProductNote:OpenUISubApp()
  else
    Panel_ProductNote:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function ProductNote_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if _btn_PopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(_btn_PopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
_btn_Close:addInputEvent("Mouse_LUp", "Panel_ProductNote_ShowToggle()")
registerEvent("onScreenResize", "ProductNote_onScreenResize")
