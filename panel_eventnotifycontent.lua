local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_EventNotifyContent:SetShow(false)
Panel_EventNotifyContent:setGlassBackground(true)
Panel_EventNotifyContent:ActiveMouseEventEffect(true)
Panel_EventNotifyContent:RegisterShowEventFunc(true, "Panel_EventNotifyContent_ShowAni()")
Panel_EventNotifyContent:RegisterShowEventFunc(false, "Panel_EventNotifyContent_HideAni()")
local isBeforeShow = false
function Panel_EventNotifyContent_ShowAni()
  UIAni.fadeInSCR_Down(Panel_EventNotifyContent)
  local aniInfo1 = Panel_EventNotifyContent:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_EventNotifyContent:GetSizeX() / 2
  aniInfo1.AxisY = Panel_EventNotifyContent:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_EventNotifyContent:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_EventNotifyContent:GetSizeX() / 2
  aniInfo2.AxisY = Panel_EventNotifyContent:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_EventNotifyContent_HideAni()
  Panel_EventNotifyContent:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_EventNotifyContent, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_EventNotifyContent, "Button_Close")
local _Web
local isShowEventNotifyContent = false
function Panel_EventNotifyContent_Initialize()
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_EventNotifyContent, "WebControl_EventNotifyContent_WebLink")
  _Web:SetShow(true)
  _Web:SetPosX(43)
  _Web:SetPosY(63)
  _Web:SetSize(817, 600)
  _Web:ResetUrl()
  Panel_EventNotifyContent:SetSize(905, 700)
end
Panel_EventNotifyContent_Initialize()
function FGlobal_EventNotifyContent_Open(eventIndex)
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  local url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL", "index", eventIndex)
  if isGameTypeKorea() then
    if CppEnums.CountryType.KOR_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_DEV_URL", "index", eventIndex)
    elseif CppEnums.CountryType.KOR_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL", "index", eventIndex)
    end
  elseif isGameTypeTaiwan() then
    if CppEnums.CountryType.TW_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TW_ALPHA", "index", eventIndex)
    elseif CppEnums.CountryType.TW_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TW", "index", eventIndex)
    end
  elseif isGameTypeSA() then
    if CppEnums.CountryType.SA_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_SA_ALPHA", "index", eventIndex)
    elseif CppEnums.CountryType.SA_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_SA", "index", eventIndex)
    end
  elseif isGameTypeTR() then
    if CppEnums.CountryType.TR_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TR_ALPHA", "index", eventIndex)
    elseif CppEnums.CountryType.TR_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TR", "index", eventIndex)
    end
  elseif isGameTypeTH() then
    if CppEnums.CountryType.TH_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TH_ALPHA", "index", eventIndex)
    elseif CppEnums.CountryType.TH_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_TH", "index", eventIndex)
    end
  elseif isGameTypeID() then
    if CppEnums.CountryType.ID_ALPHA == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_ID_ALPHA", "index", eventIndex)
    elseif CppEnums.CountryType.ID_REAL == getGameServiceType() then
      url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_ID", "index", eventIndex)
    end
  elseif CppEnums.CountryType.RUS_ALPHA == getGameServiceType() then
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_RUS_ALPHA", "index", eventIndex)
  elseif CppEnums.CountryType.RUS_REAL == getGameServiceType() then
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL_RUS", "index", eventIndex)
  else
    url = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EVENTCONTENT_URL", "index", eventIndex)
  end
  local isType = false
  if isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() or isGameTypeRussia() then
    isType = true
  else
    isType = false
  end
  _Web:SetSize(817, 600)
  _Web:SetUrl(817, 600, url, false, isType)
  Panel_EventNotifyContent:SetPosX(getScreenSizeX() / 2 - Panel_EventNotifyContent:GetSizeX() / 2)
  Panel_EventNotifyContent:SetPosY(getScreenSizeY() / 2 - Panel_EventNotifyContent:GetSizeY() / 2)
  Panel_EventNotifyContent:SetShow(true, true)
  SetUIMode(Defines.UIMode.eUIMode_EventNotify)
end
function FGlobal_EventNotifyContent_OpenByUrl(urlValue)
  if nil == urlValue then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  local isType = false
  if isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() or isGameTypeRussia() then
    isType = true
  else
    isType = false
  end
  _Web:SetSize(817, 600)
  _Web:SetUrl(817, 600, urlValue, false, false)
  Panel_EventNotifyContent:SetPosX(getScreenSizeX() / 2 - Panel_EventNotifyContent:GetSizeX() / 2)
  Panel_EventNotifyContent:SetPosY(getScreenSizeY() / 2 - Panel_EventNotifyContent:GetSizeY() / 2)
  Panel_EventNotifyContent:SetShow(true, true)
  SetUIMode(Defines.UIMode.eUIMode_EventNotify)
end
function EventNotifyContent_Close()
  _Web:ResetUrl()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_EventNotifyContent:SetShow(false, false)
end
function HandleClicked_EventNotifyContent_Close()
  EventNotifyContent_Close()
  SetUIMode(Defines.UIMode.eUIMode_Default)
end
registerEvent("FromWeb_ExecuteLuaFuncByEvent", "FGlobal_EventNotifyContent_Open")
_btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_EventNotifyContent_Close()")
