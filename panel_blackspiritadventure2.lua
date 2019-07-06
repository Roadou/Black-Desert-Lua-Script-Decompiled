Panel_Window_BlackSpiritAdventure_2:SetShow(false)
Panel_Window_BlackSpiritAdventure_2:setMaskingChild(true)
Panel_Window_BlackSpiritAdventure_2:setGlassBackground(true)
Panel_Window_BlackSpiritAdventure_2:SetDragAll(true)
Panel_Window_BlackSpiritAdventure_2:RegisterShowEventFunc(true, "BlackSpiritAdventure2_ShowAni()")
Panel_Window_BlackSpiritAdventure_2:RegisterShowEventFunc(false, "BlackSpiritAdventure2_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local isBlackSpiritAdventure = ToClient_IsContentsGroupOpen("277")
function BlackSpiritAdventure2_ShowAni()
  audioPostEvent_SystemUi(0, 22)
  _AudioPostEvent_SystemUiForXBOX(0, 22)
  UIAni.fadeInSCR_Down(Panel_Window_BlackSpiritAdventure_2)
  local aniInfo1 = Panel_Window_BlackSpiritAdventure_2:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_Window_BlackSpiritAdventure_2:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_BlackSpiritAdventure_2:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_BlackSpiritAdventure_2:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_BlackSpiritAdventure_2:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_BlackSpiritAdventure_2:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function BlackSpiritAdventure2_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_BlackSpiritAdventure_2:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_BlackSpiritAdventure_2, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local btnClose = UI.getChildControl(Panel_Window_BlackSpiritAdventure_2, "Button_Win_Close")
btnClose:addInputEvent("Mouse_LUp", "BlackSpirit2_Hide()")
local btnQuestion = UI.getChildControl(Panel_Window_BlackSpiritAdventure_2, "Button_Question")
btnQuestion:SetShow(false)
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_Window_BlackSpiritAdventure_2, "WebControl_EventNotify_WebLink")
_Web:SetShow(true)
_Web:SetPosX(11)
_Web:SetPosY(50)
_Web:SetSize(1220, 628)
_Web:ResetUrl()
function BlackSpirit2_Show()
  if isBlackSpiritAdventure then
    Panel_Window_BlackSpiritAdventure_2:SetShow(true, true)
    Panel_Window_BlackSpiritAdventure_2:SetPosX(getScreenSizeX() / 2 - Panel_Window_BlackSpiritAdventure_2:GetSizeX() / 2)
    Panel_Window_BlackSpiritAdventure_2:SetPosY(getScreenSizeY() / 2 - Panel_Window_BlackSpiritAdventure_2:GetSizeY() / 2)
  else
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  local serverNo = curChannelData._worldNo
  local myUserNo = selfPlayer:get():getUserNo()
  local cryptKey = selfPlayer:get():getWebAuthenticKeyCryptString()
  local characterNo_64 = selfPlayer:getCharacterNo_64()
  local characterName = selfPlayer:getOriginalName()
  local userNickName = selfPlayer:getUserNickname()
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
    local url = bAdventureWebUrl .. "/BlackSpiritAdventure?userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&serverNo=" .. tostring(serverNo) .. "?userId=" .. tostring(userNickName) .. "&characterName=" .. tostring(characterName) .. "&characterNo=" .. tostring(characterNo_64) .. "&nationCode=" .. tostring(isNationType)
    _Web:SetUrl(1220, 628, url, false, true)
  end
end
function BlackSpirit2_Hide()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_Window_BlackSpiritAdventure_2:SetShow(false, false)
  _Web:ResetUrl()
end
function FGlobal_BlackSpiritAdventure2_Open()
  BlackSpirit2_Show()
end
function BlackSpirit_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
  else
    TooltipSimple_Hide()
  end
end
