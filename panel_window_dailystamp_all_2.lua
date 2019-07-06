function PaGlobalFunc_DailyStamp_All_Open()
  PaGlobal_DailyStamp_All:prepareOpen()
end
function PaGlobalFunc_DailyStamp_All_Close()
  PaGlobal_DailyStamp_All:prepareClose()
end
function HandleEventLUp_DailyStamp_All_TabClicked(tabIndex)
  if nil == tabIndex then
    UI.ASSERT_NAME(nil ~= tabIndex, "HandleEventLUp_DailyStamp_All_TabClicked tabIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  PaGlobal_DailyStamp_All:selectTab(tabIndex)
  PaGlobal_DailyStamp_All:setData(tabIndex)
end
function PadEventLBRB_DailyStamp_All_SelectTab(addIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local tabIndex = PaGlobal_DailyStamp_All._tabIndex + addIndex
  if tabIndex < 1 then
    PaGlobal_DailyStamp_All._tabIndex = PaGlobal_DailyStamp_All._dailyStampCount
  elseif tabIndex > PaGlobal_DailyStamp_All._tabIndex then
    PaGlobal_DailyStamp_All._tabIndex = PaGlobal_DailyStamp_All._firstTabIndex
  else
    PaGlobal_DailyStamp_All._tabIndex = tabIndex
  end
  PaGlobal_DailyStamp_All:selectTab(PaGlobal_DailyStamp_All._tabIndex)
  PaGlobal_DailyStamp_All:setData(PaGlobal_DailyStamp_All._tabIndex)
end
function HandleEventOnOut_DailyStamp_All_ItemTooltip(index, rewardIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == index or nil == rewardIndex then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemWrapper = PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:getRewardItem(index)
  local itemSSW = itemWrapper:getStaticStatus()
  local uiBase = PaGlobal_DailyStamp_All._dayControl[index].slot.icon
  Panel_Tooltip_Item_Show(itemSSW, uiBase, true, false)
end
function PadEventXUp_DailyStamp_All_ItemToolTipShow(isShow, slotIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if false == isShow then
    return
  end
  local itemWrapper = PaGlobal_DailyStamp_All._dailyStampKeys[PaGlobal_DailyStamp_All._tabIndex][1]:getRewardItem(slotIndex - 1)
  local itemSSW = itemWrapper:getStaticStatus()
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item)
end
function HandleEventOnOut_DailyStamp_All_TodayAttendanceTooltipShow(index)
  if nil == index then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local uiControl = PaGlobal_DailyStamp_All._dayControl[index]._dayControl
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAYATTENDANCE_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_TODAYATTENDANCE_DESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function HandleEventOnOut_DailyStamp_All_Attendance_TooltipShow(index, isPossible)
  if nil == index then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local uiControl = PaGlobal_DailyStamp_All._dayControl[index]._dayControl
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_DAILYCHECK_POSSIBLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MOUSE_CLICKSTAMP")
  if nil == isPossible then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_DAILYCHECK_IMPOSSIBLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_CHECK_THIRTYMINUTE_POSSIBLE")
  end
  TooltipSimple_Show(uiControl, name, desc)
end
function HandleEventOnOut_DailyStamp_All_AcceptReward_TooltipShow(index)
  if nil == index then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  local uiControl = PaGlobal_DailyStamp_All._dayControl[index]._dayControl
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_RECEIVEPOSSIBLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MOUSE_CLICKRECEIVE")
  TooltipSimple_Show(uiControl, name, desc)
end
function HandleEventUp_DailyStamp_All_AcceptReward(rewardIndex)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == rewardIndex then
    UI.ASSERT_NAME(nil ~= rewardIndex, "HandleEventUp_DailyStamp_All_AcceptReward rewardIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  local attendanceKey = PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:getKey()
  local function recieveReward()
    ToClient_takeRewardItem(attendanceKey)
  end
  local myAttendanceCount = ToClient_getAttendanceCount(attendanceKey)
  local receiveItemIndex = ToClient_getReceivedRewardCount(attendanceKey)
  if myAttendanceCount <= receiveItemIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_NOTHING_REWARD"))
    return
  end
  if 0 == receiveItemIndex then
    receiveItemIndex = 0
  end
  local title = PAGetString(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MSGTITLE")
  local itemWrapper = PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:getRewardItem(receiveItemIndex)
  local content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_MSGCONTENT", "name", tostring(itemWrapper:getStaticStatus():getName()))
  messageBoxData = {
    title = title,
    content = content,
    functionYes = recieveReward,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleEventUp_DailyStamp_All_SetAttendance(rewardIndex)
  if nil == rewardIndex then
    UI.ASSERT_NAME(nil ~= rewardIndex, "HandleEventUp_DailyStamp_All_SetAttendance rewardIndex nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  if not PaGlobal_DailyStamp_All:isPossibleAttandanceCheck() then
    local waitingTime = -1
    if PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:isPossibleAttendance() then
      waitingTime = ToClient_getWaitingTimeForAttendance()
    end
    if PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:isPossibleOverlapAttendance() then
      waitingTime = ToClient_getWaitingTimeForNextAttendance(PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:getKey())
    end
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DAILYSTAMP_STILL_CHECK_IMPOSSIBLE_REMAINTIME", "remainTime", Util.Time.timeFormatting_Minute(waitingTime)))
    return false
  end
  local attendanceKey = PaGlobal_DailyStamp_All._dailyStampKeys[rewardIndex][1]:getKey()
  ToClient_onAttendance(attendanceKey)
  return true
end
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
function FromClient_DailyStamp_All_onScreenResize()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  PaGlobal_DailyStamp_All:resize()
end
function FromClient_DailyStamp_All_AttendanceUpdate(attendanceKey)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == attendanceKey then
    UI.ASSERT_NAME(nil ~= attendanceKey, "FromClient_DailyStamp_All_AttendanceUpdate attendanceKey nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  if nil == getSelfPlayer() then
    return
  end
  if getSelfPlayer():get():getLevel() < 6 then
    return
  end
  for index = 1, PaGlobal_DailyStamp_All._dailyStampCount do
    local dailyKey = PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:getKey()
    if dailyKey:get() == attendanceKey:get() then
      PaGlobal_DailyStamp_All:acceptRewardAll(index)
      PaGlobal_DailyStamp_All:setData(index)
      PaGlobal_DailyStamp_All._dailyStampKeys[index][3] = false
      if nil ~= PaGlobal_DailyStamp_All._dailyStampKeys[index][1] and false == PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:isPossibleOverlapAttendance() and false == PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:isPossibleAttendance() then
        PaGlobal_DailyStamp_All._dailyStampKeys[index][3] = true
      end
      break
    end
  end
  if true == PaGlobal_DailyStamp_All._nextDayShow or true == PaGlobal_DailyStamp_All._secondAttendanceCheck then
    local seflPlayer = getSelfPlayer()
    if nil == seflPlayer then
      return
    end
    local regionInfo = getRegionInfoByPosition(seflPlayer:get():getPosition())
    local isSafeZone = regionInfo:get():isSafeZone()
    if false == isSafeZone then
      return
    end
    PaGlobal_DailyStamp_All._nextDayShow = false
  end
  if false == Panel_Window_DailyStamp_All:GetShow() then
    PaGlobal_DailyStamp_All._isDailyChallengeShow = true
    PaGlobalFunc_DailyStamp_All_Open()
  end
end
function FromClient_DailyStamp_All_AttendanceUpdateAll(isNextDay)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == isNextDay then
    UI.ASSERT_NAME(nil ~= isNextDay, "FromClient_DailyStamp_All_AttendanceUpdateAll isNextDay nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  if true == isNextDay then
    PaGlobal_DailyStamp_All._nextDayShow = isNextDay
  end
  PaGlobal_DailyStamp_All._dailyStampCount = ToClient_GetAttendanceInfoCount()
  PaGlobal_DailyStamp_All._dailyStampKeys = Array.new()
  for index = 1, PaGlobal_DailyStamp_All._dailyStampCount do
    local attendaceSS = ToClient_GetAttendanceInfoWrapper(index - 1)
    PaGlobal_DailyStamp_All._dailyStampKeys[index] = {
      attendaceSS,
      attendaceSS:getDisplayOrder(),
      false
    }
  end
  table.sort(PaGlobal_DailyStamp_All._dailyStampKeys, PaGlobalFunc_DailyStamp_All_TabSort)
  PaGlobal_DailyStamp_All:tabInit()
end
function FromClient_DailyStamp_All_receiveAttendanceReward(attendanceKey)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == attendanceKey then
    UI.ASSERT_NAME(nil ~= attendanceKey, "FromClient_DailyStamp_All_receiveAttendanceReward attendanceKey nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  for index = 1, PaGlobal_DailyStamp_All._dailyStampCount do
    local dailyKey = PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:getKey()
    if dailyKey:get() == attendanceKey:get() then
      PaGlobal_DailyStamp_All:setData(index)
      return
    end
  end
end
function FromClient_DailyStamp_All_AttendanceTimer()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == getSelfPlayer() then
    return
  end
  if getSelfPlayer():get():getLevel() < 6 then
    return
  end
  local waitingTime = -1
  for index = 1, PaGlobal_DailyStamp_All._dailyStampCount do
    if nil ~= PaGlobal_DailyStamp_All._dailyStampKeys[index][1] and PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:isPossibleAttendance() then
      waitingTime = ToClient_getWaitingTimeForAttendance()
      if 0 == waitingTime then
        local attendanceKey = PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:getKey()
        ToClient_onAttendance(attendanceKey)
      end
    end
  end
  waitingTime = -1
  for index = 1, PaGlobal_DailyStamp_All._dailyStampCount do
    if nil ~= PaGlobal_DailyStamp_All._dailyStampKeys[index][1] and PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:isPossibleOverlapAttendance() then
      waitingTime = ToClient_getWaitingTimeForNextAttendance(PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:getKey())
      if 0 == waitingTime then
        local attendanceKey = PaGlobal_DailyStamp_All._dailyStampKeys[index][1]:getKey()
        ToClient_onAttendance(attendanceKey)
      end
    end
  end
end
function FromClient_DailyStamp_All_regionCheck(regionData)
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  if nil == regionData then
    UI.ASSERT_NAME(nil ~= regionData, "FromClient_DailyStamp_All_regionCheck regionData nil", "\236\160\149\236\167\128\237\152\156")
    return
  end
  if true == PaGlobal_DailyStamp_All._nextDayShow then
    local isSafeZone = regionData:get():isSafeZone()
    if true == isSafeZone and false == Panel_Window_DailyStamp_All:GetShow() then
      PaGlobal_DailyStamp_All._nextDayShow = false
      PaGlobalFunc_DailyStamp_All_Open()
      return
    end
  end
  if true == PaGlobal_DailyStamp_All._secondAttendanceCheck then
    local isSafeZone = regionData:get():isSafeZone()
    if true == isSafeZone and false == Panel_Window_DailyStamp_All:GetShow() then
      PaGlobal_DailyStamp_All._secondAttendanceCheck = false
      PaGlobalFunc_DailyStamp_All_Open()
      return
    end
  end
end
function PaGlobalFunc_DailyStamp_All_ShowAni()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  audioPostEvent_SystemUi(13, 6)
  _AudioPostEvent_SystemUiForXBOX(13, 6)
  Panel_Window_DailyStamp_All:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_Window_DailyStamp_All:addTextureUVAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
  PaGlobal_DailyStamp_All._animationTime = 0
end
function PaGlobalFunc_DailyStamp_All_HideAni()
  if nil == Panel_Window_DailyStamp_All then
    return
  end
  audioPostEvent_SystemUi(13, 5)
  _AudioPostEvent_SystemUiForXBOX(13, 5)
  Panel_Window_DailyStamp_All:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_DailyStamp_All, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function PaGlobalFunc_DailyStamp_All_GetIsSecondAttendance()
  return PaGlobal_DailyStamp_All._secondAttendanceCheck
end
function PaGlobalFunc_DailyStamp_All_IsDailyChallengeShow()
  if nil == Panel_Window_DailyStamp_All then
    return false
  end
  local result = PaGlobal_DailyStamp_All._isDailyChallengeShow
  PaGlobal_DailyStamp_All._isDailyChallengeShow = false
  return result
end
function PaGlobalFunc_DailyStamp_All_GetDailyStampKeys()
  return PaGlobal_DailyStamp_All._dailyStampKeys
end
