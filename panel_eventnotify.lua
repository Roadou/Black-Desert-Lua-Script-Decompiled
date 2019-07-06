local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_EventNotify:SetShow(false)
Panel_EventNotify:setGlassBackground(true)
Panel_EventNotify:ActiveMouseEventEffect(true)
Panel_EventNotify:RegisterShowEventFunc(true, "Panel_EventNotify_ShowAni()")
Panel_EventNotify:RegisterShowEventFunc(false, "Panel_EventNotify_HideAni()")
btnClose = UI.getChildControl(Panel_EventNotify, "Button_Close")
titleBar = UI.getChildControl(Panel_EventNotify, "StaticText_Title")
btnClose:addInputEvent("Mouse_LUp", "HandleClicked_EventNotify_Close()")
function Panel_EventNotify_ShowAni()
  UIAni.fadeInSCR_Down(Panel_EventNotify)
  local aniInfo1 = Panel_EventNotify:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_EventNotify:GetSizeX() / 2
  aniInfo1.AxisY = Panel_EventNotify:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_EventNotify:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_EventNotify:GetSizeX() / 2
  aniInfo2.AxisY = Panel_EventNotify:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_EventNotify_HideAni()
  Panel_EventNotify:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_EventNotify, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function Panel_EventNotify_Initialize()
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_EventNotify, "WebControl_EventNotify_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(32)
  _Web:SetPosY(83)
  _Web:SetSize(636, 494)
  _Web:ResetUrl()
end
Panel_EventNotify_Initialize()
function EventNotify_Open(isDo, isMenu)
  if not ToClient_IsPopUpToggle() then
    return
  end
  if isGameTypeKR2() then
    return
  end
  local tempWrapper = getTemporaryInformationWrapper()
  if tempWrapper:isEventBeforeShow() and nil == isDo then
    PaGlobal_MainQuestWidget_TopQuestGuide_Open()
    return
  end
  if not TutorialQuestCompleteCheck() and not isMenu then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  if true == isGameTypeEnglish() then
    titleBar:SetSize(840, 54)
    Panel_EventNotify:SetSize(850, 806)
    _Web:SetPosX(20)
    _Web:SetPosY(65)
  else
    titleBar:SetSize(690, 54)
    Panel_EventNotify:SetSize(700, 609)
    _Web:SetPosX(32)
    _Web:SetPosY(83)
  end
  Panel_EventNotify:SetPosX(getScreenSizeX() / 2 - Panel_EventNotify:GetSizeX() / 2)
  Panel_EventNotify:SetPosY(getScreenSizeY() / 2 - Panel_EventNotify:GetSizeY() / 2)
  Panel_EventNotify:SetShow(true, true)
  local url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL")
  if isGameTypeKorea() then
    if CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_DEV_URL")
    elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL")
    end
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TW_ALPHA")
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TW")
    end
  elseif isGameTypeSA() then
    if CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_SA_ALPHA")
    elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_SA")
    end
  elseif isGameTypeTR() then
    if CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TR_ALPHA")
    elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TR")
    end
  elseif isGameTypeTH() then
    if CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TH_ALPHA")
    elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_TH")
    end
  elseif isGameTypeID() then
    if CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_ID_ALPHA")
    elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
      url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_ID")
    end
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_RUS_ALPHA")
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL_RUS")
  else
    url = PAGetString(Defines.StringSheet_GAME, "LUA_EVENTNOTIFY_URL")
  end
  local sizePartX, sizePartY
  if true == isGameTypeEnglish() then
    sizePartX = 810
    sizePartY = 719
    Panel_EventNotify:SetSize(850, 806)
  else
    sizePartX = 636
    sizePartY = 494
    Panel_EventNotify:SetSize(700, 609)
  end
  _Web:SetSize(sizePartX, sizePartY)
  _Web:SetUrl(sizePartX, sizePartY, url, false, true)
end
function EventNotify_Close()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_EventNotify:SetShow(false, false)
  _Web:ResetUrl()
  FGlobal_LevelupGuide_Open()
  local tempWrapper = getTemporaryInformationWrapper()
  if not tempWrapper:isEventBeforeShow() then
    PaGlobal_MainQuestWidget_TopQuestGuide_Open()
    tempWrapper:setEventBeforeShow(true)
  end
end
function FGlobal_EventNotifyClose()
  EventNotify_Close()
end
function HandleClicked_EventNotify_Close()
  EventNotify_Close()
end
function HandleClicked_EventNotify_Next()
  EventNotify_Close()
end
