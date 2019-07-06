function PaGlobal_VolunteerRankWeb:initialize()
  if true == PaGlobal_VolunteerRankWeb._initialize then
    return
  end
  PaGlobal_VolunteerRankWeb._ui.stc_titleBG = UI.getChildControl(Panel_Window_VolunteerRankWeb, "Static_TitleBG")
  PaGlobal_VolunteerRankWeb._ui.btn_Close = UI.getChildControl(PaGlobal_VolunteerRankWeb._ui.stc_titleBG, "Button_Win_Close")
  PaGlobal_VolunteerRankWeb._webControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_VolunteerRankWeb, "WebControl_VolunteerRank_WebLink")
  PaGlobal_VolunteerRankWeb._webControl:SetShow(true)
  PaGlobal_VolunteerRankWeb._webControl:SetPosY(50)
  PaGlobal_VolunteerRankWeb._webControl:SetHorizonCenter()
  PaGlobal_VolunteerRankWeb._webControl:SetSize(PaGlobal_VolunteerRankWeb._config._WEBSIZEX, PaGlobal_VolunteerRankWeb._config._WEBSIZEY)
  PaGlobal_VolunteerRankWeb._webControl:ResetUrl()
  PaGlobal_VolunteerRankWeb._webControl:ComputePos()
  Panel_Window_VolunteerRankWeb:SetShow(false)
  Panel_Window_VolunteerRankWeb:setGlassBackground(true)
  Panel_Window_VolunteerRankWeb:ActiveMouseEventEffect(true)
  PaGlobal_VolunteerRankWeb:registEventHandler()
  PaGlobal_VolunteerRankWeb:validate()
  PaGlobal_VolunteerRankWeb._initialize = true
end
function PaGlobal_VolunteerRankWeb:registEventHandler()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  PaGlobal_VolunteerRankWeb._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_VolunteerRankWeb_Close()")
  Panel_Window_VolunteerRankWeb:RegisterShowEventFunc(true, "PaGlobal_VolunteerRankWeb_ShowAni()")
  Panel_Window_VolunteerRankWeb:RegisterShowEventFunc(false, "PaGlobal_VolunteerRankWeb_HideAni()")
end
function PaGlobal_VolunteerRankWeb:prepareOpen()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  PaGlobal_VolunteerRankWeb:update()
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
end
function PaGlobal_VolunteerRankWeb:open()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  Panel_Window_VolunteerRankWeb:SetShow(true, true)
end
function PaGlobal_VolunteerRankWeb:prepareClose()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  FGlobal_ClearCandidate()
  PaGlobal_VolunteerRankWeb._webControl:ResetUrl()
  ClearFocusEdit()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
end
function PaGlobal_VolunteerRankWeb:close()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  Panel_Window_VolunteerRankWeb:SetShow(false, true)
end
function PaGlobal_VolunteerRankWeb:showAni()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  UIAni.fadeInSCR_Down(Panel_Window_VolunteerRankWeb)
  local aniInfo1 = Panel_Window_VolunteerRankWeb:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Window_VolunteerRankWeb:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_VolunteerRankWeb:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_VolunteerRankWeb:addScaleAnimation(0.08, 0.15, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_VolunteerRankWeb:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_VolunteerRankWeb:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_VolunteerRankWeb:hideAni()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
  Panel_Window_VolunteerRankWeb:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_VolunteerRankWeb, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobal_VolunteerRankWeb:update()
  if nil == Panel_Window_VolunteerRankWeb then
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
  url = url .. "/BattleHero?userNo=" .. tostring(userNo)
  url = url .. "&certKey=" .. tostring(certKey)
  FGlobal_SetCandidate()
  PaGlobal_VolunteerRankWeb._webControl:SetSize(PaGlobal_VolunteerRankWeb._config._WEBSIZEX, PaGlobal_VolunteerRankWeb._config._WEBSIZEY)
  PaGlobal_VolunteerRankWeb._webControl:SetUrl(PaGlobal_VolunteerRankWeb._config._WEBSIZEX, PaGlobal_VolunteerRankWeb._config._WEBSIZEY, url, false, true)
  PaGlobal_VolunteerRankWeb._webControl:SetIME(true)
  Panel_Window_VolunteerRankWeb:SetPosX(getScreenSizeX() / 2 - Panel_Window_VolunteerRankWeb:GetSizeX() / 2)
  Panel_Window_VolunteerRankWeb:SetPosY(getScreenSizeY() / 2 - Panel_Window_VolunteerRankWeb:GetSizeY() / 2)
end
function PaGlobal_VolunteerRankWeb:validate()
  if nil == Panel_Window_VolunteerRankWeb then
    return
  end
end
