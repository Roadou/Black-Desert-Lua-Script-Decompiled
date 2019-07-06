function PaGlobal_AltarRankWeb:initialize()
  if true == PaGlobal_AltarRankWeb._initialize then
    return
  end
  PaGlobal_AltarRankWeb._ui.stc_titleBG = UI.getChildControl(Panel_AltarRank_Web, "Static_TitleBG")
  PaGlobal_AltarRankWeb._ui.btn_Close = UI.getChildControl(PaGlobal_AltarRankWeb._ui.stc_titleBG, "Button_Win_Close")
  PaGlobal_AltarRankWeb._webControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_AltarRank_Web, "WebControl_AltarRank_WebLink")
  PaGlobal_AltarRankWeb._webControl:SetShow(true)
  PaGlobal_AltarRankWeb._webControl:SetPosY(50)
  PaGlobal_AltarRankWeb._webControl:SetHorizonCenter()
  PaGlobal_AltarRankWeb._webControl:SetSize(PaGlobal_AltarRankWeb._config._WEBSIZEX, PaGlobal_AltarRankWeb._config._WEBSIZEY)
  PaGlobal_AltarRankWeb._webControl:ResetUrl()
  PaGlobal_AltarRankWeb._webControl:ComputePos()
  Panel_AltarRank_Web:SetShow(false)
  Panel_AltarRank_Web:setGlassBackground(true)
  Panel_AltarRank_Web:ActiveMouseEventEffect(true)
  PaGlobal_AltarRankWeb:registEventHandler()
  PaGlobal_AltarRankWeb:validate()
  PaGlobal_AltarRankWeb._initialize = true
end
function PaGlobal_AltarRankWeb:registEventHandler()
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_AltarRankWeb_Close()")
  Panel_AltarRank_Web:RegisterShowEventFunc(true, "PaGlobal_AltarRankWeb_ShowAni()")
  Panel_AltarRank_Web:RegisterShowEventFunc(false, "PaGlobal_AltarRankWeb_HideAni()")
end
function PaGlobal_AltarRankWeb:prepareOpen()
  if nil == Panel_AltarRank_Web then
    return
  end
  PaGlobal_AltarRankWeb:update()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
end
function PaGlobal_AltarRankWeb:open()
  if nil == Panel_AltarRank_Web then
    return
  end
  Panel_AltarRank_Web:SetShow(true, true)
end
function PaGlobal_AltarRankWeb:prepareClose()
  if nil == Panel_AltarRank_Web then
    return
  end
  FGlobal_ClearCandidate()
  PaGlobal_AltarRankWeb._webControl:ResetUrl()
  ClearFocusEdit()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
end
function PaGlobal_AltarRankWeb:close()
  if nil == Panel_AltarRank_Web then
    return
  end
  Panel_AltarRank_Web:SetShow(false, true)
end
function PaGlobal_AltarRankWeb:showAni()
  if nil == Panel_AltarRank_Web then
    return
  end
  UIAni.fadeInSCR_Down(Panel_AltarRank_Web)
  local aniInfo1 = Panel_AltarRank_Web:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_AltarRank_Web:GetSizeX() / 2
  aniInfo1.AxisY = Panel_AltarRank_Web:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_AltarRank_Web:addScaleAnimation(0.08, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_AltarRank_Web:GetSizeX() / 2
  aniInfo2.AxisY = Panel_AltarRank_Web:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_AltarRankWeb:hideAni()
  if nil == Panel_AltarRank_Web then
    return
  end
  Panel_AltarRank_Web:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_AltarRank_Web, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobal_AltarRankWeb:update()
  if nil == Panel_AltarRank_Web then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local userNo = selfPlayer:get():getUserNo()
  local certKey = selfPlayer:get():getWebAuthenticKeyCryptString()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  if nil == url then
    return
  end
  url = url .. "/AltarOfBlood?stage=1&certKey=" .. tostring(certKey)
  FGlobal_SetCandidate()
  PaGlobal_AltarRankWeb._webControl:SetSize(PaGlobal_AltarRankWeb._config._WEBSIZEX, PaGlobal_AltarRankWeb._config._WEBSIZEY)
  PaGlobal_AltarRankWeb._webControl:SetUrl(PaGlobal_AltarRankWeb._config._WEBSIZEX, PaGlobal_AltarRankWeb._config._WEBSIZEY, url, false, true)
  PaGlobal_AltarRankWeb._webControl:SetIME(true)
  Panel_AltarRank_Web:SetPosX(getScreenSizeX() / 2 - Panel_AltarRank_Web:GetSizeX() / 2)
  Panel_AltarRank_Web:SetPosY(getScreenSizeY() / 2 - Panel_AltarRank_Web:GetSizeY() / 2)
end
function PaGlobal_AltarRankWeb:validate()
  if nil == Panel_AltarRank_Web then
    return
  end
end
