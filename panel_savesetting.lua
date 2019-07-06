Panel_SaveSetting:SetShow(false)
Panel_SaveSetting:setMaskingChild(true)
Panel_SaveSetting:setGlassBackground(true)
Panel_SaveSetting:SetDragAll(true)
Panel_SaveSetting:RegisterShowEventFunc(true, "PaGlobal_Panel_SaveSetting_ShowAni()")
Panel_SaveSetting:RegisterShowEventFunc(false, "PaGlobal_Panel_SaveSetting_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function PaGlobal_Panel_SaveSetting_ShowAni()
  UIAni.fadeInSCR_Down(Panel_SaveSetting)
  local aniInfo1 = Panel_SaveSetting:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_SaveSetting:GetSizeX() / 2
  aniInfo1.AxisY = Panel_SaveSetting:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_SaveSetting:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_SaveSetting:GetSizeX() / 2
  aniInfo2.AxisY = Panel_SaveSetting:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PaGlobal_Panel_SaveSetting_HideAni()
  Panel_SaveSetting:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_SaveSetting, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local btnClose = UI.getChildControl(Panel_SaveSetting, "Button_Win_Close")
btnClose:addInputEvent("Mouse_LUp", "PaGlobal_Panel_SaveSetting_Hide()")
local btnQuestion = UI.getChildControl(Panel_SaveSetting, "Button_Question")
btnQuestion:SetShow(false)
local checkPopUp = UI.getChildControl(Panel_SaveSetting, "CheckButton_PopUp")
checkPopUp:SetShow(false)
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_SaveSetting, "WebControl_SaveSetting")
_Web:SetShow(true)
_Web:SetHorizonCenter()
_Web:SetPosY(68)
_Web:SetSize(322, 407)
_Web:ResetUrl()
function PaGlobal_Panel_SaveSetting_Show(ignoreRollBack)
  Panel_SaveSetting:SetShow(true, true)
  Panel_SaveSetting:SetPosX(getScreenSizeX() / 2 - Panel_SaveSetting:GetSizeX() / 2)
  Panel_SaveSetting:SetPosY(getScreenSizeY() / 2 - Panel_SaveSetting:GetSizeY() / 2)
  if false == ignoreRollBack then
    GameOption_Cancel()
  end
  local myUserNo = getSelfPlayer():get():getUserNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local url = PaGlobal_URL_Check(worldNo)
  local fileName = "UserCachePack" .. getFamilyName() .. ".bdcp"
  if nil ~= url then
    local realUrl = url .. "/SaveSettings?userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&fileName=" .. tostring(fileName)
    _Web:SetIME(false)
    _Web:SetUrl(322, 407, realUrl, false, true)
  end
end
function PaGlobal_Panel_SaveSetting_PopUp()
  if checkPopUp:IsCheck() then
    Panel_SaveSetting:OpenUISubApp()
  else
    Panel_SaveSetting:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobal_Panel_SaveSetting_Hide()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_SaveSetting:SetShow(false, false)
  _Web:ResetUrl()
end
function PaGlobal_Panel_SaveSetting_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Panel_SaveSetting_WebCall_CheckSafetyzone()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local regionInfo = getRegionInfoByPosition(selfPlayer:get():getPosition())
  local isSafeZone = regionInfo:get():isSafeZone()
  return isSafeZone
end
function FromClient_OpenExplorer_SaveGameOption(title, defaultName, paramList)
  local paramCount = 0
  local subNameStringBDC = ""
  for key, value in pairs(paramList) do
    if ".bdcp" ~= string.sub(value, 1, 5) then
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
  ToClient_cacheToPackFile(_Web, getFamilyName())
end
function FromClient_OnDownloadFromWeb_loadGameOption(path, filename)
  if nil == string.find(filename, ".bdcp", -5) then
    return
  end
  path = path .. filename
  ToClient_packFileToCache(path)
end
function FromClient_applyGameOptionEnd()
  chatting_sendMessage("", PAGetString(Defines.StringSheet_GAME, "LUA_SAVESETTING_APPLYCOMPLETE"), CppEnums.ChatType.System)
  UiSet_update()
end
function FromClient_NotifyMessageAboutSaveSetting()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_ISOPTIONVARIABLEACTION_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
registerEvent("FromClient_OpenExplorer", "FromClient_OpenExplorer_SaveGameOption")
registerEvent("FromClient_OnDownloadFromWeb", "FromClient_OnDownloadFromWeb_loadGameOption")
registerEvent("FromClient_applyGameOptionEnd", "FromClient_applyGameOptionEnd")
registerEvent("FromClient_NotifyMessageAboutSaveSetting", "FromClient_NotifyMessageAboutSaveSetting")
