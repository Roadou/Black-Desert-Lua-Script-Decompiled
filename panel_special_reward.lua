local reward = {currentBenefitReward = -1, currentRewardCount = -1}
local pcRoomGift_icon = UI.getChildControl(Panel_NewEventProduct_Alarm, "Static_Icon")
local pcRoomGift_Text = UI.getChildControl(Panel_NewEventProduct_Alarm, "StaticText_SumText")
Panel_NewEventProduct_Alarm:SetShow(false)
local nextPcRoomGiftRewardTime = toInt64(0, 0)
local messagePosition = function()
  Panel_NewEventProduct_Alarm:SetSpanSize(70, 10)
end
local isNewbie = function()
  return questList_hasProgressQuest(118, 1) or questList_hasProgressQuest(138, 1) or questList_hasProgressQuest(120, 1) or questList_hasProgressQuest(121, 1) or questList_hasProgressQuest(161, 1) or questList_hasProgressQuest(160, 1)
end
function completeBenefitReward_ShowMessage()
  local self = reward
  if -1 == self.currentBenefitReward then
    return
  end
  local rewardWrapper = ToClient_GetBenefitRewardInfoWrapper(self.currentBenefitReward)
  if nil ~= rewardWrapper and 0 == rewardWrapper:getType() then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_BENEFITREWARD_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ARCHIVEMENT", "specialRewardName", rewardWrapper:getName())
    }
    Proc_ShowBigMessage_Ack_WithOut_ChattingMessage(message)
  end
end
function FromClient_CompleteBenefitReward()
  if isFlushedUI() then
    return
  end
  local self = reward
  local rewardCount = ToClient_GetBenefitRewardInfoCount()
  if 0 == rewardCount or nil == rewardCount then
    self.currentBenefitReward = -1
    return
  end
  self.currentBenefitReward = rewardCount - 1
  if isNewbie() or 5 < getSelfPlayer():get():getLevel() then
    Panel_SpecialReward_Alert:SetShow(true)
    completeBenefitReward_ShowMessage()
    FromClient_SpecialReward_UpdateText()
  end
  messagePosition()
end
function check_BenefitRewardAlert_Hide(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderMode(prevRenderModeList, currentRenderMode) == false then
    return
  end
  if 1 < getSelfPlayer():get():getLevel() then
    return
  end
  Panel_SpecialReward_Alert:SetShow(false)
  TooltipSimple_Hide()
end
registerEvent("FromClient_RenderModeChangeState", "check_BenefitRewardAlert_Hide")
function check_BenefitRewardAlert_PostEvent(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = reward
  if (isNewbie() or 5 < getSelfPlayer():get():getLevel()) and self.currentBenefitReward == ToClient_GetBenefitRewardInfoCount() - 1 then
    return
  end
  FromClient_CompleteBenefitReward()
end
registerEvent("FromClient_RenderModeChangeState", "check_BenefitRewardAlert_PostEvent")
function completeChallengeReward_ShowMessage()
  local self = reward
  if -1 == self.currentRewardCount then
    return
  end
  local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(self.currentRewardCount)
  if nil ~= rewardWrapper then
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_CHALLENGEREWARD_MAIN"),
      sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARD_ARCHIVEMENT", "challengeName", rewardWrapper:getName())
    }
    Proc_ShowBigMessage_Ack_WithOut_ChattingMessage(message)
  end
end
function FromClient_CompleteChallengeReward()
  if isFlushedUI() then
    return
  end
  local self = reward
  local rewardCount = ToClient_GetChallengeRewardInfoCount()
  self.currentRewardCount = rewardCount - 1
  if isNewbie() or 5 < getSelfPlayer():get():getLevel() then
    Panel_ChallengeReward_Alert:SetShow(false)
    completeChallengeReward_ShowMessage()
    if true == _ContentsGroup_RenewUI then
      PaGlobalFunc_CharacterChallengeInfo_UpdateData()
    else
      FromClient_ChallengeReward_UpdateText()
    end
    if false == _ContentsGroup_RemasterUI_Main_Alert and false == ToClient_isConsole() then
      FGlobal_RightBottomIconReposition()
    end
    PcRoomGift_TimeCheck()
    PackageIconPosition()
    FromClient_PackageIconUpdate()
  end
  messagePosition()
end
function check_CompleteChallengeRewardAlert_Hide(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderMode(prevRenderModeList, currentRenderMode) == false then
    return
  end
  if 1 < getSelfPlayer():get():getLevel() then
    return
  end
end
registerEvent("FromClient_RenderModeChangeState", "check_CompleteChallengeRewardAlert_Hide")
function check_CompleteChallengeRewardAlert_PostEvent(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  local self = reward
  if (isNewbie() or 1 < getSelfPlayer():get():getLevel()) and self.currentRewardCount == ToClient_GetChallengeRewardInfoCount() - 1 then
    return
  end
  FromClient_CompleteChallengeReward()
end
registerEvent("FromClient_RenderModeChangeState", "check_CompleteChallengeRewardAlert_PostEvent")
function PcRoomGift_TimeCheck()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local temporaryPCRoomWrapper = getTemporaryInformationWrapper()
  local isPremiumPcRoom = temporaryPCRoomWrapper:isPremiumPcRoom()
  local isRussiaPremiumPack = false
  if isGameTypeRussia() then
    isRussiaPremiumPack = selfPlayer:get():isApplyChargeSkill(9)
  end
  local nowPlayedTime = 0
  local challengeType = 4
  if isPremiumPcRoom then
    nowPlayedTime = ToClient_GetPcRoomPlayTime()
    challengeType = 4
  end
  if isRussiaPremiumPack then
    nowPlayedTime = ToClient_GetUserPlayTimePerDay()
    challengeType = 7
  end
  local checkCount = ToClient_GetProgressChallengeCount(challengeType)
  if 0 == checkCount then
    nextPcRoomGiftRewardTime = toInt64(0, 0)
    Panel_NewEventProduct_Alarm:SetShow(false)
    return
  end
  for checkIdx = 0, checkCount - 1 do
    local progressInfo = ToClient_GetProgressChallengeAt(challengeType, checkIdx)
    local remainedTime = toInt64(0, 0)
    if isPremiumPcRoom then
      remainedTime = toInt64(0, progressInfo:getNeedTimeForPcRoom() * 60) - nowPlayedTime
    end
    if isRussiaPremiumPack then
      remainedTime = toInt64(0, progressInfo:getNeedTimeForDay() * 60) - nowPlayedTime
    end
    if toInt64(0, 0) == nextPcRoomGiftRewardTime then
      nextPcRoomGiftRewardTime = remainedTime
    elseif remainedTime < nextPcRoomGiftRewardTime then
      nextPcRoomGiftRewardTime = remainedTime
    end
  end
  if (isPremiumPcRoom or isRussiaPremiumPack) and not Panel_NewEventProduct_Alarm:GetShow() and 0 ~= checkCount then
    Panel_NewEventProduct_Alarm:SetShow(true)
    messagePosition()
    if false == _ContentsGroup_RemasterUI_Main_Alert then
      FGlobal_RightBottomIconReposition()
    end
  end
end
function renderModeChange_PcRoomGift_TimeCheck(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  PcRoomGift_TimeCheck()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_PcRoomGift_TimeCheck")
PcRoomGift_TimeCheck()
local tempTime = 0
function PcRoomGiftPanel_UpdatePerFrame(deltaTime)
  tempTime = tempTime + deltaTime
  if tempTime > 1 then
    nextPcRoomGiftRewardTime = nextPcRoomGiftRewardTime - toInt64(0, tempTime)
    pcRoomGift_Text:SetText(convertStringFromDatetime(nextPcRoomGiftRewardTime))
    tempTime = 0
  end
  if nextPcRoomGiftRewardTime <= toInt64(0, 0) then
    nextPcRoomGiftRewardTime = toInt64(0, 0)
    PcRoomGift_TimeCheck()
  end
end
function HandleClicked_PcRoomJackPotBox()
  if nil ~= PaGlobal_CharacterInfoPanel_GetShowPanelStatus and false == PaGlobal_CharacterInfoPanel_GetShowPanelStatus() then
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      FGlobal_CharInfoStatusShowAni()
    else
      PaGlobal_CharacterInfo:showAni()
    end
    PaGlobal_CharacterInfoPanel_SetShowPanelStatus(true)
  end
  if _ContentsGroup_isUsedNewCharacterInfo == false then
    HandleClicked_CharacterInfo_Tab(3)
  else
    PaGlobal_CharacterInfo:showWindow(3)
  end
  HandleClickedTapButton(5)
end
function AlarmIcon_SimpleTooltips(isShow)
  name = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ALARMICON_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPECIAL_REWARD_ALARMICON_TOOLTIP_DESC")
  uiControl = pcRoomGift_icon
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function SpecialReward_registEventHandler()
  registerEvent("FromClient_CompleteBenefitReward", "FromClient_CompleteBenefitReward")
  registerEvent("FromClient_CompleteChallengeReward", "FromClient_CompleteChallengeReward")
  registerEvent("FromClient_LoadCompleteMsg", "PcRoomGift_TimeCheck")
end
function SpecialReward_registMessageHandler()
  pcRoomGift_icon:addInputEvent("Mouse_On", "AlarmIcon_SimpleTooltips( true )")
  pcRoomGift_icon:addInputEvent("Mouse_Out", "AlarmIcon_SimpleTooltips( false )")
  pcRoomGift_icon:addInputEvent("Mouse_LUp", "HandleClicked_PcRoomJackPotBox()")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Special_Reward")
if _ContentsGroup_RemasterUI_Main_Alert then
  function AlarmIcon_SetPos()
    local spanPosX = 60
    if Panel_NewEventProduct_Alarm:GetShow() then
      spanPosX = spanPosX + 60
    end
    Panel_ItemMarket_Alert:SetSpanSize(spanPosX, 0)
  end
  do
    local itemMarketIcon = UI.getChildControl(Panel_ItemMarket_Alert, "Static_Icon")
    local itemMarketAlarmCount = UI.getChildControl(Panel_ItemMarket_Alert, "StaticText_Number")
    itemMarketIcon:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketAlarmList_New_Open()")
    itemMarketIcon:AddEffect("fUI_ItemMarket_Alert_01A", true, 0, 0)
    function FGlobal_ItemMarket_AlarmIcon_Show()
      Panel_ItemMarket_Alert:SetShow(true)
      FGlobal_ItemMarket_SetCount()
      AlarmIcon_SetPos()
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
    Panel_Widget_ItemMarketPlace:SetShow(true)
    Panel_Widget_ItemMarketPlace:ComputePos()
    local cashShopIcon = UI.getChildControl(Panel_Widget_ItemMarketPlace, "Static_Icon")
    cashShopIcon:addInputEvent("Mouse_LUp", "GlobalKeyBinder_MouseKeyMap(18)")
  end
end
function FromClient_luaLoadComplete_Special_Reward()
  FromClient_CompleteBenefitReward()
  FromClient_CompleteChallengeReward()
  SpecialReward_registEventHandler()
  SpecialReward_registMessageHandler()
end
Panel_NewEventProduct_Alarm:RegisterUpdateFunc("PcRoomGiftPanel_UpdatePerFrame")
