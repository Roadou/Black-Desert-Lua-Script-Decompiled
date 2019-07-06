if true == _ContentsGroup_RenewUI_Main then
  Panel_UIMain:SetShow(false, false)
end
Panel_DailyStamp_Alert:SetShow(false)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local VCK = CppEnums.VirtualKeyCode
local UI_IT = CppEnums.UiInputType
local UIMode = Defines.UIMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local animationEndTime = 0.15
local elapsedTime = 0
local newQuestDeltaTime = 0
local isOn = false
local checkNewQuestForEffect = false
local blackMsgShowTime = 10
local btn_totalSizeTmp = 0
local btn_totalSize = 0
local _fold_UIMain = true
local _use_ForSimpleUI = true
local _badgeFriend
local _badges = {
  Count = 0,
  Quest = false,
  BlackSpirit = false,
  Skill = false,
  Item = false,
  Knowledge = false,
  FriendList = false
}
local isCouponOpen = _ContentsGroup_isConsoleTest
local _badgeWidget = UI.getChildControl(Panel_UIMain, "StaticText_Number")
local _gameExitButton = false
Panel_UIMain:RegisterShowEventFunc(true, "Panel_UIMain_ShowAni()")
Panel_UIMain:RegisterShowEventFunc(false, "Panel_UIMain_HideAni()")
Panel_UIMain:SetIgnore(true)
function Panel_UIMain_ShowAni()
end
function Panel_UIMain_HideAni()
end
local MenuButtonId = {
  Btn_GameExit = 1,
  Btn_Setting = 2,
  Btn_Menu = 3,
  Btn_Beauty = 4,
  Btn_CashShop = 5,
  Btn_Mail = 6,
  Btn_FriendList = 7,
  Btn_BlackStone = 8,
  Btn_Guild = 9
}
local contry = {
  kr = 0,
  jp = 1,
  ru = 2,
  cn = 3,
  tw = 4
}
local cashIconTexture = {
  [0] = {
    83,
    161,
    123,
    201
  },
  {
    165,
    202,
    205,
    242
  },
  {
    83,
    161,
    123,
    201
  },
  {
    83,
    161,
    123,
    201
  },
  {
    83,
    161,
    123,
    201
  }
}
local function cashIcon_UiMainchangeButtonTexture(control, contry)
  local x1, y1, x2, y2 = setTextureUV_Func(control, cashIconTexture[contry][1], cashIconTexture[contry][2], cashIconTexture[contry][3], cashIconTexture[contry][4])
  return x1, y1, x2, y2
end
local MenuButtons = Array.new()
local showedMenuButtonList = Array.new()
local _bubbleNotice = UI.getChildControl(Panel_UIMain, "StaticText_Notice")
Panel_UIMain:SetChildIndex(_bubbleNotice, 9999)
local blackQuestIcon = UI.getChildControl(Panel_NewQuest_Alarm, "Static_BlackIcon")
local blackQuestCall = UI.getChildControl(Panel_NewQuest_Alarm, "StaticText_CallingYou")
local blackSpritCall = UI.getChildControl(Panel_UIMain, "StaticText_BlackSpritCall")
blackSpritCall:SetShow(false)
local challengeIcon = UI.getChildControl(Panel_ChallengeReward_Alert, "Static_Icon")
local dailyStampAlert = UI.getChildControl(Panel_DailyStamp_Alert, "Static_Icon")
local couponIcon = UI.getChildControl(Panel_Coupon_Alert, "Static_Icon")
local couponCount = UI.getChildControl(Panel_Coupon_Alert, "StaticText_Number")
if nil ~= ToClient_GetAttendanceInfoWrapper(0) then
  dailyStampAlert:addInputEvent("Mouse_LUp", "UIMain_DailyStmp_SetAttendanceAll()")
  dailyStampAlert:addInputEvent("Mouse_On", "ShowTooltip_DailyStampIcon( true )")
  dailyStampAlert:addInputEvent("Mouse_Out", "ShowTooltip_DailyStampIcon()")
end
local itemMarketIcon = UI.getChildControl(Panel_ItemMarket_Alert, "Static_Icon")
local itemMarketAlarmCount = UI.getChildControl(Panel_ItemMarket_Alert, "StaticText_Number")
itemMarketIcon:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketAlarmList_New_Open()")
itemMarketIcon:AddEffect("fUI_ItemMarket_Alert_01A", true, 0, 0)
function UIMain_DailyStmp_SetAttendanceAll()
  FGlobal_DailyStamp_SetAttendanceAll()
  TooltipSimple_Hide()
  Panel_DailyStamp_Alert:SetShow(false)
end
function ShowTooltip_DailyStampIcon(isShow)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local uiControl = dailyStampAlert
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_DAILYSTAMP_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_DAILYSTAMP_DESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function FGlobal_DailyStamp_CheckAttendance(isShow)
  if Panel_DailyStamp_Alert:GetShow() ~= isShow then
    Panel_DailyStamp_Alert:SetShow(isShow)
    if isShow then
      UIMain_DailyStmp_SetAttendanceAll()
    end
  end
  if isShow then
    FGlobal_DailyStmpIcon_SetPos()
  end
end
function FGlobal_DailyStmpIcon_SetPos()
  if Panel_NewEventProduct_Alarm:GetShow() then
    Panel_DailyStamp_Alert:SetPosX(Panel_NewEventProduct_Alarm:GetPosX() - Panel_DailyStamp_Alert:GetSizeX() - 10)
  elseif Panel_ChallengeReward_Alert:GetShow() then
    Panel_DailyStamp_Alert:SetPosX(Panel_ChallengeReward_Alert:GetPosX() - Panel_DailyStamp_Alert:GetSizeX() - 20)
  elseif Panel_Coupon_Alert:GetShow() then
    Panel_DailyStamp_Alert:SetPosX(Panel_ChallengeReward_Alert:GetPosX() - Panel_DailyStamp_Alert:GetSizeX() - 30)
  else
    Panel_DailyStamp_Alert:SetPosX(getScreenSizeX() - Panel_DailyStamp_Alert:GetSizeX() - 10)
  end
  Panel_DailyStamp_Alert:SetPosY(Panel_ChallengeReward_Alert:GetPosY() - 10)
end
local buttonAni = UI.getChildControl(Panel_UIMain, "Static_NewEffect_Ani")
local function MenuButton_CheckEnAble(buttonType)
  local returnValue = false
  if buttonType == MenuButtonId.Btn_CashShop or buttonType == MenuButtonId.Btn_Beauty then
    if isGameTypeGT() then
      returnValue = false
    else
      returnValue = true
    end
  else
    returnValue = true
  end
  return returnValue
end
function initMenuButtons()
  local MenuButtonControlId = {
    [MenuButtonId.Btn_GameExit] = "Button_GameExit",
    [MenuButtonId.Btn_Setting] = "Button_Setting",
    [MenuButtonId.Btn_Menu] = "Button_Menu",
    [MenuButtonId.Btn_BlackStone] = "Button_BlackStone",
    [MenuButtonId.Btn_Beauty] = "Button_Beauty",
    [MenuButtonId.Btn_CashShop] = "Button_CashShop",
    [MenuButtonId.Btn_Mail] = "Button_Mail",
    [MenuButtonId.Btn_FriendList] = "Button_FriendList",
    [MenuButtonId.Btn_Guild] = "Button_Guild"
  }
  local MenuButtonEventFunction = {
    [MenuButtonId.Btn_GameExit] = "GameExitShowToggle(false)",
    [MenuButtonId.Btn_Setting] = "showGameOption()",
    [MenuButtonId.Btn_Menu] = "Panel_Menu_ShowToggle()",
    [MenuButtonId.Btn_BlackStone] = "GlobalKeyBinder_MouseKeyMap(" .. UI_IT.UiInputType_BlackSpirit .. ")",
    [MenuButtonId.Btn_Beauty] = "IngameCustomize_Show()",
    [MenuButtonId.Btn_CashShop] = "GlobalKeyBinder_MouseKeyMap(" .. UI_IT.UiInputType_CashShop .. ")",
    [MenuButtonId.Btn_Mail] = "GlobalKeyBinder_MouseKeyMap(" .. UI_IT.UiInputType_Mail .. ")",
    [MenuButtonId.Btn_FriendList] = "GlobalKeyBinder_MouseKeyMap(" .. UI_IT.UiInputType_FriendList .. ")",
    [MenuButtonId.Btn_Guild] = "GlobalKeyBinder_MouseKeyMap(" .. UI_IT.UiInputType_Guild .. ")"
  }
  MenuButtons:resize(#MenuButtonId, nil)
  local panel = Panel_UIMain
  for idx, controlId in ipairs(MenuButtonControlId) do
    local button = UI.getChildControl(panel, controlId)
    button:addInputEvent("Mouse_On", "UIMain_MouseOverEvent(" .. idx .. ")")
    button:addInputEvent("Mouse_Out", "UIMain_MouseOutEvent(" .. idx .. ")")
    button:ActiveMouseEventEffect(true)
    local eventFunction = MenuButtonEventFunction[idx]
    if nil ~= eventFunction then
      button:addInputEvent("Mouse_LUp", eventFunction)
    end
    if MenuButtonId.Btn_CashShop == idx then
      button:ChangeTextureInfoName("New_UI_Common_forLua/Widget/UIControl/UI_Control_00.dds")
      local x1, y1, x2, y2 = 0, 0, 0, 0
      if isGameTypeKorea() then
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.kr)
      elseif isGameTypeJapan() then
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.jp)
      elseif isGameTypeRussia() then
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.ru)
      elseif isGameTypeKR2() then
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.cn)
      elseif isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.tw)
      else
        x1, y1, x2, y2 = cashIcon_UiMainchangeButtonTexture(button, contry.kr)
      end
      button:getBaseTexture():setUV(x1, y1, x2, y2)
      button:setRenderTexture(button:getBaseTexture())
    end
    buttonAni[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, button, "Static_ButtonAni" .. idx)
    CopyBaseProperty(buttonAni, buttonAni[idx])
    buttonAni[idx]:SetPosX(button[idx]:GetPosX() - 2)
    buttonAni[idx]:SetPosY(button:GetPosY())
    buttonAni[idx]:SetShow(false)
    if MenuButton_CheckEnAble(idx) then
      button:SetShow(true)
    else
      button:SetShow(false)
    end
    MenuButtons[idx] = button
  end
end
function Panel_UIMain_CheckBtnVisibility()
  local selfPlayerWrapper = getSelfPlayer()
  local guildShow = nil ~= selfPlayerWrapper and selfPlayerWrapper:get():isGuildMember()
  MenuButtons[MenuButtonId.Btn_Guild]:SetShow(guildShow)
  showedMenuButtonList = Array.new()
  for idx, button in ipairs(MenuButtons) do
    if button:GetShow() and MenuButton_CheckEnAble(idx) then
      showedMenuButtonList:push_back(button)
    end
  end
end
function Panel_UIMain_SetScreenSize()
  local ScrX = getScreenSizeX()
  local btn_Count = 10
  Panel_UIMain:SetSize(MenuButtons[MenuButtonId.Btn_GameExit]:GetSizeX() * btn_Count, 38)
  Panel_UIMain:ComputePos()
  local count = showedMenuButtonList:length()
  if 0 == count then
    return
  end
  local _styleInfo = UI.getChildControl(Panel_UIMain, "Button_PlayerInfo")
  local startPos_FirstRaw = Panel_UIMain:GetSizeX() - _styleInfo:GetSizeX()
  local gapPos = -(_styleInfo:GetSizeX() + _styleInfo:GetSizeX() * 0.1)
  local buttonSpanY = 0
  for key, button in ipairs(showedMenuButtonList) do
    button:SetScale(1, 1)
    button:SetVerticalBottom()
    button:SetPosX(startPos_FirstRaw)
    button:SetSpanSize(button:GetSpanSize().x, 0)
    btn_totalSizeTmp = btn_totalSizeTmp + button:GetSizeX()
  end
  btn_totalSize = btn_totalSizeTmp
  btn_totalSizeTmp = 0
  local SpanY = Panel_UIMain:GetSizeY()
  Panel_NewQuest_Alarm:SetSpanSize(-33, SpanY)
end
local bubbleNoticeData = {
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_GAMEEND")
  },
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_OPTION")
  },
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_GAMEMENU")
  },
  {
    _x = 115,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_BEAUTY")
  },
  {
    _x = 115,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_CASHSHOP")
  },
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_MAIL")
  },
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_FRIEND")
  },
  {
    _x = 115,
    _y = 50,
    _text = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_BLACKSTONE", "getKey", keyCustom_GetString_UiKey(UI_IT.UiInputType_BlackSpirit))
  },
  {
    _x = 70,
    _y = 50,
    _text = PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_NOTICE_GUILD")
  }
}
function UIMain_MouseOverEvent(index)
  audioPostEvent_SystemUi(0, 13)
  _AudioPostEvent_SystemUiForXBOX(0, 13)
  elapsedTime = 0
  isOn = true
  local button = MenuButtons[index]
  button:SetAlpha(1)
  button:ResetVertexAni()
  button:SetVertexAniRun("Ani_Color_UIMain_Bright", true)
  if nil ~= bubbleNoticeData[index] then
    _bubbleNotice:SetText(bubbleNoticeData[index]._text)
  else
    _bubbleNotice:SetText(bubbleNoticeData[1]._text)
  end
  _bubbleNotice:SetSize(_bubbleNotice:GetTextSizeX() + 10, _bubbleNotice:GetSizeY())
  _bubbleNotice:SetPosX(button:GetPosX() - _bubbleNotice:GetSizeX())
  if index < 16 then
    _bubbleNotice:SetPosY(-45)
  else
    _bubbleNotice:SetPosY(-90)
  end
  _bubbleNotice:ComputePos()
  _bubbleNotice:SetShow(true)
end
function UIMain_MouseOutEvent(index)
  elapsedTime = 0
  isOn = false
  local button = MenuButtons[index]
  button:ResetVertexAni()
  _bubbleNotice:SetShow(false)
  MenuButtons_SetAlpha()
end
function MenuButtons_SetAlpha()
  for idx, button in ipairs(MenuButtons) do
    button:SetAlpha(0.55)
  end
end
function UIMain_FriendsUpdate()
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 0 == isColorBlindMode then
    MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
    MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01A", true, -0.5, 0)
  elseif 1 == isColorBlindMode then
    MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
    MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01B", true, -0.5, 0)
  elseif 2 == isColorBlindMode then
    MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
    MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01B", true, -0.5, 0)
  end
end
function FGlobal_ChangeEffectCheck()
  checkNewQuestForEffect = false
end
local deltaTime = 0
function UIMain_QuestUpdate()
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if getSelfPlayer():get():getLevel() < 11 then
    blackMsgShowTime = 5
  elseif 5 == getGameServiceType() or 6 == getGameServiceType() or 7 == getGameServiceType() or 8 == getGameServiceType() then
    blackMsgShowTime = 5
  else
    blackMsgShowTime = 10
  end
  if questList_doHaveNewQuest() and checkNewQuestForEffect == false then
    Panel_NewQuest_Alarm:SetShow(false)
    FGlobal_MessageHistory_InputMSG(0, PAGetString(Defines.StringSheet_GAME, "LUA_UIMAIN_MESSAGEHISTORY_NEWSPRITQUEST"))
    FGlobal_NewMainQuest_Alarm_Open()
    buttonAni[MenuButtonId.Btn_BlackStone]:SetShow(false)
    if 0 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSprit_Summon", false, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon", true, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura01", true, 0, 0)
    elseif 1 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon_A", true, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura02", true, 0, 0)
    elseif 2 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_DarkSprit_Summon", false, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("UI_DarkSpirit_RedAura_Icon_A", true, 0, 0)
      MenuButtons[MenuButtonId.Btn_BlackStone]:AddEffect("fUI_BlackSoul_Aura02", true, 0, 0)
    end
    blackSpritCall:SetShow(true)
    blackSpritCall:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_UIMAIN_BLACKSPIRIT_TOOLTIP", "getKey", keyCustom_GetString_UiKey(UI_IT.UiInputType_BlackSpirit)))
    blackSpritCall:SetPosX(-67)
    if isGameTypeGT() then
      blackSpritCall:SetPosX(-20)
    end
    blackSpritCall:SetPosY(-15)
    checkNewQuestForEffect = true
  elseif true == ToClient_isConsole() and questList_doHaveNewQuest() == false and checkNewQuestForEffect == true then
    MenuButtons[MenuButtonId.Btn_BlackStone]:EraseAllEffect()
    buttonAni[MenuButtonId.Btn_BlackStone]:SetShow(false)
    blackSpritCall:SetShow(false)
    Panel_NewQuest_Alarm:SetShow(false)
    blackQuestIcon:EraseAllEffect()
    checkNewQuestForEffect = false
  end
end
function UIMain_ChallengeUpdate()
  challengeIcon:SetEnableArea(0, 0, challengeIcon:GetSizeX(), challengeIcon:GetSizeY())
  challengeIcon:addInputEvent("Mouse_LUp", "_challengeCall_byNewChallengeAlarm()")
end
local isBlackSpiritClicked = false
function _blackSpritCall_byNewQuestAlarm()
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
    return
  end
  if PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  audioPostEvent_SystemUi(0, 5)
  ToClient_AddBlackSpiritFlush()
end
function _challengeCall_byNewChallengeAlarm()
  audioPostEvent_SystemUi(0, 5)
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return
  end
  if nil ~= PaGlobal_CharacterInfoPanel_GetShowPanelStatus and false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true)
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      FGlobal_CharInfoStatusShowAni()
    else
      PaGlobal_CharacterInfo:showAni()
    end
    audioPostEvent_SystemUi(1, 34)
    _AudioPostEvent_SystemUiForXBOX(1, 34)
  end
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    HandleClicked_CharacterInfo_Tab(3)
  else
    PaGlobal_CharacterInfo:showWindow(3)
  end
  HandleClickedTapButton(5)
end
initMenuButtons()
Panel_UIMain_CheckBtnVisibility()
Panel_UIMain_SetScreenSize()
function Tutorial_InventoryOpen()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerLevel = selfPlayer:get():getLevel()
  if not (playerLevel <= 3) or false == Panel_Window_Inventory:GetShow() then
  end
end
local function setAlphaAll(alpha)
  _bubbleNotice:SetFontAlpha(alpha)
  _bubbleNotice:SetAlpha(alpha)
end
function uiMainUpdate(updateTime)
  elapsedTime = elapsedTime + updateTime
  if _bubbleNotice:GetShow() == true then
    if isOn == false then
      local temp = animationEndTime - elapsedTime
      if temp < 0 then
        temp = 0
        _bubbleNotice:SetShow(false)
      end
      setAlphaAll(temp / animationEndTime)
    else
      local temp = elapsedTime / animationEndTime
      if temp > 1 then
        temp = 1
      end
      setAlphaAll(temp)
    end
  end
  if blackSpritCall:GetShow() then
    if Panel_RaceTimeAttack:GetShow() then
      Panel_NewQuest:SetShow(false)
      return
    end
    newQuestDeltaTime = newQuestDeltaTime + updateTime
    if blackMsgShowTime <= newQuestDeltaTime then
      FGlobal_NewMainQuest_Alarm_Open()
      newQuestDeltaTime = 0
    end
  end
end
function ResetPos_WidgetButton()
  local ScrX = getScreenSizeX()
  local btn_Count = 7
  Panel_UIMain:SetSize(MenuButtons[MenuButtonId.Btn_GameExit]:GetSizeX() * btn_Count, 38)
  Panel_UIMain:ComputePos()
  local count = showedMenuButtonList:length()
  if 0 == count then
    return
  end
  local _styleInfo = UI.getChildControl(Panel_UIMain, "Button_PlayerInfo")
  local startPos_FirstRaw = Panel_UIMain:GetSizeX() - _styleInfo:GetSizeX()
  local gapPos = -(_styleInfo:GetSizeX() + _styleInfo:GetSizeX() * 0.1)
  local buttonSpanY = 0
  for key, button in ipairs(showedMenuButtonList) do
    button:SetScale(1, 1)
    button:SetVerticalBottom()
    button:SetPosX(startPos_FirstRaw)
    button:SetSpanSize(button:GetSpanSize().x, 0)
    startPos_FirstRaw = startPos_FirstRaw + gapPos
    btn_totalSizeTmp = btn_totalSizeTmp + button:GetSizeX()
  end
end
function FromClient_NewFriendAlert(param)
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if 1 == param then
    if 0 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01A", true, 0, 0)
    elseif 1 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01B", true, 0, 0)
    elseif 2 == isColorBlindMode then
      MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
      MenuButtons[MenuButtonId.Btn_FriendList]:AddEffect("fUI_Friend_01B", true, 0, 0)
    end
    _badgeFriend = badgeWidgetMake(MenuButtons[MenuButtonId.Btn_FriendList], "StaticText_Number_Friend", "N")
    local sendMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_FRIEND_ALERT"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(sendMsg, 3, 3)
  else
    local sendMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_FRIEND_COMPLETE"),
      sub = "",
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(sendMsg, 3, 3)
  end
end
function badgeWidgetMake(parentControl, controlName, text)
  local _badgeWidgetChild = UI.createAndCopyBasePropertyControl(Panel_UIMain, "StaticText_Number", parentControl, controlName)
  _badgeWidgetChild:SetPosX(15)
  _badgeWidgetChild:SetPosY(parentControl:GetPosY() - 2)
  _badgeWidgetChild:SetText(text)
  _badgeWidgetChild:SetShow(true)
  return _badgeWidgetChild
end
function FGlobal_NewFriendAlertOff()
  if nil == _badgeFriend then
    return
  end
  if true == _badgeFriend:GetShow() then
    MenuButtons[MenuButtonId.Btn_FriendList]:EraseAllEffect()
    _badgeFriend:SetShow(false)
  end
end
function FromClient_RegisterCoupon()
  local count = ToClient_GetCouponInfoUsableCount()
  Panel_Coupon_Alert:SetShow(false)
  local iconPosX = 60
  Panel_Coupon_Alert:SetSpanSize(0, 10)
  if Panel_ChallengeReward_Alert:GetShow() then
    Panel_Coupon_Alert:SetSpanSize(iconPosX, 10)
    iconPosX = iconPosX + Panel_Coupon_Alert:GetSpanSize().x + 5
  end
  if Panel_NewEventProduct_Alarm:GetShow() then
    Panel_Coupon_Alert:SetSpanSize(iconPosX, 10)
    iconPosX = iconPosX + Panel_Coupon_Alert:GetSpanSize().x + 5
  end
  couponIcon:EraseAllEffect()
  if count > 0 then
    Panel_Coupon_Alert:SetShow(isCouponOpen and not ToClient_isConsole())
    couponIcon:addInputEvent("Mouse_LUp", "IngameCashShopCoupon_Open()")
    couponCount:SetText(count)
    couponIcon:AddEffect("fUI_Coupon_01A", true, 2, 2)
  end
  if Panel_ItemMarket_Alert:GetShow() then
    Panel_ItemMarket_Alert:SetSpanSize(iconPosX, 10)
    iconPosX = iconPosX + Panel_Coupon_Alert:GetSpanSize().x + 5
  end
end
function FGlobal_ItemMarket_AlarmIcon_Show()
  Panel_ItemMarket_Alert:SetShow(true)
  FGlobal_ItemMarket_SetCount()
  FromClient_RegisterCoupon()
end
function FGlobal_ItemMarket_SetCount()
  local alarmCount = FGlobal_ItemMarketAlarm_UnreadCount()
  itemMarketAlarmCount:SetText(alarmCount)
  itemMarketAlarmCount:SetShow(alarmCount > 0)
  itemMarketIcon:EraseAllEffect()
  if alarmCount > 0 then
    itemMarketIcon:AddEffect("fUI_ItemMarket_Alert_01A", true, 0, 0)
  end
end
function FGlobal_RightBottomIconReposition()
  FromClient_RegisterCoupon()
end
function PaGlobalFunc_UiMain_LuaLoadComplete()
  PaGlobalFunc_UiMain_SetShow(true)
  FromClient_RegisterCoupon()
end
function PaGlobalFunc_UiMain_SetShow(isShow)
  if true == isShow then
    if -1 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_UIMenu, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
      Panel_UIMain:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_UIMenu, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
    else
      Panel_UIMain:SetShow(true, false)
    end
  else
    Panel_UIMain:SetShow(false)
  end
end
UIMain_QuestUpdate()
UIMain_ChallengeUpdate()
MenuButtons_SetAlpha()
FromClient_RegisterCoupon()
Panel_UIMain:RegisterUpdateFunc("uiMainUpdate")
registerEvent("FromClient_UpdateQuestList", "UIMain_QuestUpdate")
registerEvent("onScreenResize", "ResetPos_WidgetButton")
registerEvent("FromClient_NewFriend", "FromClient_NewFriendAlert")
registerEvent("FromClient_RegisterCoupon", "FromClient_RegisterCoupon")
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_UiMain_LuaLoadComplete")
