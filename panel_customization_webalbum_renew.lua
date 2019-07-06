local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_CustomizingAlbum:SetShow(false, false)
Panel_CustomizingAlbum:ActiveMouseEventEffect(true)
Panel_CustomizingAlbum:setGlassBackground(true)
Panel_CustomizingAlbum:RegisterShowEventFunc(true, "Panel_CustomizingAlbum_ShowAni()")
Panel_CustomizingAlbum:RegisterShowEventFunc(false, "Panel_CustomizingAlbum_HideAni()")
function Panel_CustomizingAlbum_ShowAni()
  UIAni.fadeInSCR_Down(Panel_CustomizingAlbum)
  local aniInfo1 = Panel_CustomizingAlbum:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_CustomizingAlbum:GetSizeX() / 2
  aniInfo1.AxisY = Panel_CustomizingAlbum:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_CustomizingAlbum:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_CustomizingAlbum:GetSizeX() / 2
  aniInfo2.AxisY = Panel_CustomizingAlbum:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_CustomizingAlbum_HideAni()
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_CustomizingAlbum:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_CustomizingAlbum, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local _titleBar = UI.getChildControl(Panel_CustomizingAlbum, "StaticText_TitleBg")
local _static_KeyguideBG = UI.getChildControl(Panel_CustomizingAlbum, "Static_KeyguideBG")
local _customizingAlbumWeb, sizeX, sizeY, panelSizeX, panelSizeY, urlSizeX, urlSizeY
local isCanShowXBProfile = false
local _isMainView = true
function PaGlobal_WebAlbum_Resize()
  sizeX = panelSizeX - 30
  sizeY = panelSizeY - 30 - _titleBar:GetSizeY()
  urlSizeX = sizeX
  urlSizeY = sizeY
  local startPosX = 15
  local startPosY = 90
  Panel_CustomizingAlbum:SetSize(panelSizeX, panelSizeY)
  isCanShowXBProfile = false
  _customizingAlbumWeb:SetShow(true)
  _customizingAlbumWeb:SetPosX(startPosX)
  _customizingAlbumWeb:SetPosY(startPosY)
  _customizingAlbumWeb:SetSize(sizeX, sizeY)
  _static_KeyguideBG:ComputePos()
  local keyGuideText = UI.getChildControl(_static_KeyguideBG, "StaticText_B_ConsoleUI")
  if 80 < keyGuideText:GetTextSizeX() then
    _static_KeyguideBG:SetSpanSize(-keyGuideText:GetTextSizeX(), 5)
  end
end
function Panel_CustomizingAlbum_Initialize()
  _customizingAlbumWeb = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_CustomizingAlbum, "WebControl_CustomizingAlbum")
  panelSizeX = Panel_CustomizingAlbum:GetSizeX()
  panelSizeY = Panel_CustomizingAlbum:GetSizeY()
  PaGlobal_WebAlbum_Resize()
  _customizingAlbumWeb:ResetUrl()
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_WebAlbum_ToWebBanner(\"LB\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_WebAlbum_ToWebBanner(\"RB\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_A, "Input_WebAlbum_ToWebBanner(\"A\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_Y, "Input_WebAlbum_ToWebBanner(\"Y\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_WebAlbum_ToWebBanner(\"LT\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_WebAlbum_ToWebBanner(\"RT\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "Input_WebAlbum_ToWebBanner(\"D_LEFT\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "Input_WebAlbum_ToWebBanner(\"D_RIGHT\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "Input_WebAlbum_ToWebBanner(\"D_UP\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "Input_WebAlbum_ToWebBanner(\"D_DOWN\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_LSClick, "Input_WebAlbum_ToWebBanner(\"LS_CLICK\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_RSClick, "Input_WebAlbum_ToWebBanner(\"RS_CLICK\")")
  Panel_CustomizingAlbum:registerPadEvent(__eConsoleUIPadEvent_Up_X, "showXboxUserProfile()")
end
Panel_CustomizingAlbum_Initialize()
local isCustomizationMode
function CustomizingAlbum_Open(isCTMode, isSceneState)
  if false == _ContentsGroup_RenewUI_BeautyAlbum then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_CustomizingAlbum:SetShow(true, true)
  FGlobal_SetCandidate()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  local userNo = 0
  local userNickName = ""
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local classType = getSelfPlayer():getClassType()
  local isGm = ToClient_SelfPlayerIsGM()
  if ToClient_isLobbyProcessor() then
    userNickName = getFamilyName()
    userNo = getUserNoByLobby()
  else
    userNickName = getSelfPlayer():getUserNickname()
    userNo = getSelfPlayer():get():getUserNo()
  end
  url = url .. "/customizing?userNo=" .. tostring(userNo) .. "&userNickname=" .. tostring(userNickName) .. "&certKey=" .. tostring(cryptKey) .. "&classType=" .. tostring(classType) .. "&isCustomizationMode=" .. tostring(true == isCTMode)
  if true == isGm then
    url = url .. "&isGm=" .. tostring(isGm)
  end
  url = url .. "&isEveryone=" .. tostring(true == ToClient_isUserCreateContentsAllowed())
  isCanShowXBProfile = false
  _customizingAlbumWeb:SetUrl(urlSizeX, urlSizeY, url, false, true)
  _customizingAlbumWeb:SetIME(true)
  isCustomizationMode = isCTMode
  Panel_CustomizingAlbum:SetPosX(getOriginScreenSizeX() / 2 - Panel_CustomizingAlbum:GetSizeX() / 2)
  Panel_CustomizingAlbum:SetPosY(getOriginScreenSizeY() / 2 - Panel_CustomizingAlbum:GetSizeY() / 2)
  _isMainView = true
end
function CustomizingAlbum_Close(isAllClose)
  if not isAllClose and false == _isMainView then
    Input_WebAlbum_ToWebBanner("B")
    return
  end
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  FGlobal_ClearCandidate()
  _customizingAlbumWeb:ResetUrl()
  Panel_CustomizingAlbum:SetShow(false, false)
  _isMainView = true
end
function FGlobal_CustomizingAlbum_Show(isCTMode, isSceneState)
  CustomizingAlbum_Open(isCTMode, isSceneState)
end
function FGlobal_CustomizingAlbum_ShowByScreenShotFrame()
  if false == _ContentsGroup_RenewUI_BeautyAlbum then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_CustomizingAlbum:SetShow(true, true)
end
function FGlobal_CustomizingAlbum_Close()
  Panel_CustomizingAlbum:SetShow(false, false)
end
function FGlobal_CustomizingAlbum_GetShow()
  return Panel_CustomizingAlbum:GetShow()
end
function FromClient_LeaveDetailCustomView()
  isCanShowXBProfile = false
end
function FromClient_EnterDetailCustomView()
  local xuid = ToClient_getXboxCustomAuthorXuid()
  if nil ~= xuid and xuid ~= "" then
  else
    isCanShowXBProfile = false
  end
  isCanShowXBProfile = true
end
function Input_WebAlbum_ToWebBanner(key)
  if false == Panel_Widget_ScreenShotFrame:GetShow() then
    _customizingAlbumWeb:TriggerEvent("FromClient_GamePadInputForWebBanner", key)
  end
end
function FromClient_ErrorDoNotHaveEveryonePrivilege()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE_FOR_BEAUTY")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  ToClient_showPrivilegeError(true)
end
function showXboxUserProfile()
  if true ~= isCanShowXBProfile or true == _isMainView then
    Input_WebAlbum_ToWebBanner("X")
    return
  end
  local xuid = ToClient_getXboxCustomAuthorXuid()
  if nil ~= xuid and xuid ~= "" then
    ToClient_showXboxFriendProfile(xuid)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "HTML_PRODUCTNOTE_MESSAGE_EMPTY_SEARCHRESULT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobalFunc_CustomizationAlbum_Escape()
  return _isMainView
end
function FromClient_CustomizationAlbum_IsMainView(isMainView)
  _isMainView = isMainView
end
function FromClient_CustomizationAlbum_SetPhotoModeOn()
  CustomizingAlbum_Close(true)
end
registerEvent("FromClient_LeaveDetailCustomView", "FromClient_LeaveDetailCustomView")
registerEvent("FromClient_EnterDetailCustomView", "FromClient_EnterDetailCustomView")
registerEvent("FromClient_CustomizationAlbum_IsMainView", "FromClient_CustomizationAlbum_IsMainView")
registerEvent("FromClient_ErrorDoNotHaveEveryonePrivilege", "FromClient_ErrorDoNotHaveEveryonePrivilege")
registerEvent("FromClient_SetPhotoModeOn", "FromClient_CustomizationAlbum_SetPhotoModeOn")
registerEvent("onScreenResize", "PaGlobal_WebAlbum_Resize")
