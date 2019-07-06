Panel_Window_BlackSpiritAdventure:SetShow(false)
Panel_Window_BlackSpiritAdventure:setMaskingChild(true)
Panel_Window_BlackSpiritAdventure:setGlassBackground(true)
Panel_Window_BlackSpiritAdventure:SetDragAll(true)
Panel_Window_BlackSpiritAdventure:RegisterShowEventFunc(true, "BlackSpiritAdventure_ShowAni()")
Panel_Window_BlackSpiritAdventure:RegisterShowEventFunc(false, "BlackSpiritAdventure_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local isBlackSpiritAdventure = ToClient_IsContentsGroupOpen("1015")
function BlackSpiritAdventure_ShowAni()
  audioPostEvent_SystemUi(0, 22)
  _AudioPostEvent_SystemUiForXBOX(0, 22)
  UIAni.fadeInSCR_Down(Panel_Window_BlackSpiritAdventure)
  local aniInfo1 = Panel_Window_BlackSpiritAdventure:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_Window_BlackSpiritAdventure:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_BlackSpiritAdventure:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_BlackSpiritAdventure:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_BlackSpiritAdventure:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_BlackSpiritAdventure:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function BlackSpiritAdventure_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_BlackSpiritAdventure:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_BlackSpiritAdventure, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local btnClose = UI.getChildControl(Panel_Window_BlackSpiritAdventure, "Button_Win_Close")
btnClose:addInputEvent("Mouse_LUp", "BlackSpiritAd_Hide()")
local btnQuestion = UI.getChildControl(Panel_Window_BlackSpiritAdventure, "Button_Question")
btnQuestion:SetShow(false)
local checkPopUp = UI.getChildControl(Panel_Window_BlackSpiritAdventure, "CheckButton_PopUp")
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
checkPopUp:SetShow(isPopUpContentsEnable)
checkPopUp:addInputEvent("Mouse_LUp", "HandleClicked_BlackSpiritAdventure_PopUp()")
checkPopUp:addInputEvent("Mouse_On", "BlackSpirit_PopUp_ShowIconToolTip( true )")
checkPopUp:addInputEvent("Mouse_Out", "BlackSpirit_PopUp_ShowIconToolTip( false )")
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_BlackSpiritAdventure, "WebControl_EventNotify_WebLink")
_Web:SetShow(true)
_Web:SetPosX(11)
_Web:SetPosY(64)
_Web:SetSize(918, 658)
_Web:ResetUrl()
function BlackSpiritAd_Show(cooltimeOff)
  if isBlackSpiritAdventure then
    Panel_Window_BlackSpiritAdventure:SetShow(true, true)
    Panel_Window_BlackSpiritAdventure:SetPosX(getScreenSizeX() / 2 - Panel_Window_BlackSpiritAdventure:GetSizeX() / 2)
    Panel_Window_BlackSpiritAdventure:SetPosY(getScreenSizeY() / 2 - Panel_Window_BlackSpiritAdventure:GetSizeY() / 2)
  else
    return
  end
  local myUserNo = getSelfPlayer():get():getUserNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  local bAdventureWebUrl = PaGlobal_URL_Check(worldNo)
  local isNationType = "KR"
  if isGameTypeKorea() then
    isNationType = "KR"
  elseif isGameTypeJapan() then
    isNationType = "JP"
  elseif isGameTypeRussia() then
    isNationType = "RU"
  elseif isGameTypeEnglish() then
    isNationType = "EN"
  elseif isGameTypeTaiwan() then
    isNationType = "TW"
  elseif isGameTypeSA() then
    isNationType = "SA"
  elseif isGameTypeTR() then
    isNationType = "TR"
  elseif isGameTypeTH() then
    isNationType = "TH"
  elseif isGameTypeID() then
    isNationType = "ID"
  else
    _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\131\136\235\161\156\236\154\180 \234\181\173\234\176\128 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128\235\144\152\236\151\136\236\156\188\235\139\136 \236\157\180 \235\161\156\234\183\184\235\165\188 \235\176\156\234\178\172\237\149\152\235\169\180 \237\149\180\235\139\185 \235\139\180\235\139\185\236\158\144\236\151\144\234\178\140 \236\149\140\235\160\164\236\163\188\236\132\184\236\154\148 \234\188\173!!!")
    isNationType = "KR"
  end
  if nil ~= bAdventureWebUrl then
    local url = bAdventureWebUrl .. "/BoardGame?userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&nationCode=" .. tostring(isNationType) .. "&cooltimeOff=" .. tostring(cooltimeOff)
    _PA_LOG("\234\180\145\236\154\180", "url : " .. tostring(url))
    _Web:SetUrl(918, 655, url)
  end
end
function HandleClicked_BlackSpiritAdventure_PopUp()
  if checkPopUp:IsCheck() then
    Panel_Window_BlackSpiritAdventure:OpenUISubApp()
  else
    Panel_Window_BlackSpiritAdventure:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function BlackSpiritAd_Hide()
  if nil == Panel_Window_BlackSpiritAdventure then
    return
  end
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_BlackSpiritAdventure:SetShow(false, false)
  Panel_Window_BlackSpiritAdventure:CloseUISubApp()
  checkPopUp:SetCheck(false)
  _Web:ResetUrl()
end
function FGlobal_BlackSpiritAdventure_Open()
  BlackSpiritAd_Show(false)
end
function BlackSpirit_PopUp_ShowIconToolTip(isShow)
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
function Web_BlackSpirit_DiceSound()
  audioPostEvent_SystemUi(11, 16)
  _AudioPostEvent_SystemUiForXBOX(11, 16)
end
function FromClient_openDiceGamebyNpcTalk()
  BlackSpiritAd_Show(true)
end
registerEvent("FromClient_openDiceGamebyNpcTalk", "FromClient_openDiceGamebyNpcTalk")
