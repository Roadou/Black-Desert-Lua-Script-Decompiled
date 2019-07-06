local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_PcRoomNotify:SetShow(false)
Panel_PcRoomNotify:setGlassBackground(true)
Panel_PcRoomNotify:ActiveMouseEventEffect(true)
Panel_PcRoomNotify:RegisterShowEventFunc(true, "Panel_PcRoomNotify_ShowAni()")
Panel_PcRoomNotify:RegisterShowEventFunc(false, "Panel_PcRoomNotify_HideAni()")
local isBeforeShow = false
local _noEvent = false
function Panel_PcRoomNotify_ShowAni()
  UIAni.fadeInSCR_Down(Panel_PcRoomNotify)
  local aniInfo1 = Panel_PcRoomNotify:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_PcRoomNotify:GetSizeX() / 2
  aniInfo1.AxisY = Panel_PcRoomNotify:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_PcRoomNotify:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_PcRoomNotify:GetSizeX() / 2
  aniInfo2.AxisY = Panel_PcRoomNotify:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_PcRoomNotify_HideAni()
  Panel_PcRoomNotify:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_PcRoomNotify, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _btn_Close = UI.getChildControl(Panel_PcRoomNotify, "Button_Close")
local _btn_Close2 = UI.getChildControl(Panel_PcRoomNotify, "Button_Agree")
local _Web
local isShowPcRoomNotify = false
function Panel_PcRoomNotify_Initialize()
  _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_PcRoomNotify, "WebControl_PcRoomNotify_WebLink")
  _Web:SetShow(true)
  _Web:SetPosY(68)
  _Web:SetSize(870, 600)
  _Web:SetHorizonCenter()
  _Web:ResetUrl()
end
Panel_PcRoomNotify_Initialize()
function PcRoomNotify_FirstUsePearl_Open()
  local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
  local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  local isSvc = getGameServiceType()
  local url
  if isSvc == 1 or isSvc == 2 or isSvc == 4 then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_PCROOMNOTIFY_DEV_URL")
  elseif isSvc == 3 then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_PCROOMNOTIFY_URL")
  elseif 5 == isSvc or 6 == isSvc then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_PCROOMNOTIFY_URL")
  else
    EventNotify_Open()
    return
  end
  _noEvent = false
  _Web:SetSize(870, 600)
  _Web:SetUrl(870, 600, url)
  Panel_PcRoomNotify:SetPosX(getScreenSizeX() / 2 - Panel_PcRoomNotify:GetSizeX() / 2)
  Panel_PcRoomNotify:SetPosY(getScreenSizeY() / 2 - Panel_PcRoomNotify:GetSizeY() / 2)
  Panel_PcRoomNotify:SetShow(true, false)
  temporaryPCRoomWrapper:setPcRoomBeforeShow(true)
end
function PaGlobal_PcRoomNotify_JustClickOpen(noEvent)
  local isSvc = getGameServiceType()
  local url
  if true == isGameTypeKorea() then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_PCROOMNOTIFY_URL")
  elseif isSvc == 3 then
    url = PAGetString(Defines.StringSheet_GAME, "LUA_PCROOMNOTIFY_URL")
  else
    return
  end
  _noEvent = noEvent
  _Web:SetSize(870, 600)
  _Web:SetUrl(870, 600, url)
  Panel_PcRoomNotify:SetPosX(getScreenSizeX() / 2 - Panel_PcRoomNotify:GetSizeX() / 2)
  Panel_PcRoomNotify:SetPosY(getScreenSizeY() / 2 - Panel_PcRoomNotify:GetSizeY() / 2)
  Panel_PcRoomNotify:SetShow(true, false)
end
function PcRoomNotify_Close()
  _Web:ResetUrl()
  audioPostEvent_SystemUi(13, 5)
  Panel_PcRoomNotify:SetShow(false, false)
  if false == _noEvent then
    EventNotify_Open()
  end
end
function FGlobal_PcRoomNotifyClose()
  PcRoomNotify_Close()
end
function HandleClicked_PcRoomNotify_Close()
  PcRoomNotify_Close()
end
function HandleClicked_PcRoomNotify_Next()
  PcRoomNotify_Close()
end
function FromClient_IsPcRoomPlayer()
  if not isShowPcRoomNotify then
    PcRoomNotify_FirstUsePearl_Open()
    isShowPcRoomNotify = false
  end
end
_btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_PcRoomNotify_Close()")
_btn_Close2:addInputEvent("Mouse_LUp", "HandleClicked_PcRoomNotify_Close()")
