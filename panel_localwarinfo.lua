local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
Panel_LocalWarInfo:SetShow(false, false)
Panel_LocalWarInfo:RegisterShowEventFunc(true, "LocalWarInfoShowAni()")
Panel_LocalWarInfo:RegisterShowEventFunc(false, "LocalWarInfoHideAni()")
function LocalWarInfoShowAni()
  audioPostEvent_SystemUi(1, 6)
  Panel_LocalWarInfo:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_LocalWarInfo, 0, 0.3)
end
function LocalWarInfoHideAni()
  audioPostEvent_SystemUi(1, 1)
  local ani1 = UIAni.AlphaAnimation(0, Panel_LocalWarInfo, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
local localWarInfo = {
  _blackBG = UI.getChildControl(Panel_LocalWarInfo, "Static_BlackBG"),
  _titleBg = UI.getChildControl(Panel_LocalWarInfo, "Static_TitleBG"),
  _listBg = UI.getChildControl(Panel_LocalWarInfo, "Static_LocalWarListBG"),
  _scroll = UI.getChildControl(Panel_LocalWarInfo, "Scroll_LocalWarList"),
  _btnInmy = UI.getChildControl(Panel_LocalWarInfo, "Button_InmyChannel"),
  _txt_M_Level = UI.getChildControl(Panel_LocalWarInfo, "StaticText_Limit_Level"),
  _txt_M_Ap = UI.getChildControl(Panel_LocalWarInfo, "StaticText_Limit_AP"),
  _txt_M_Dp = UI.getChildControl(Panel_LocalWarInfo, "StaticText_Limit_DP"),
  _txt_M_ADSum = UI.getChildControl(Panel_LocalWarInfo, "StaticText_Limit_ADSum"),
  _icon_Level = UI.getChildControl(Panel_LocalWarInfo, "Static_M_Limit_Level"),
  _icon_AP = UI.getChildControl(Panel_LocalWarInfo, "Static_M_Limit_AP"),
  _icon_DP = UI.getChildControl(Panel_LocalWarInfo, "Static_M_Limit_DP"),
  _icon_AD = UI.getChildControl(Panel_LocalWarInfo, "Static_M_Limit_AD"),
  _frame = UI.getChildControl(Panel_LocalWarInfo, "Frame_Description"),
  _createListCount = 14,
  _startIndex = 0,
  _listPool = {},
  _openDesc = -1,
  _maxDescRuleSize = 40,
  _maxDescRewardSize = 20,
  _maxDescExplanationSize = 30,
  _posConfig = {
    _listStartPosY = 5,
    _iconStartPosY = 88,
    _listPosYGap = 45
  }
}
local localWarServerCountLimit = 0
local isGrouthLocalwar = ToClient_IsContentsGroupOpen("338")
function LocalWarInfo_Initionalize()
  local self = localWarInfo
  self._frame_Content = self._frame:GetFrameContent()
  self._frame_VScroll = self._frame:GetVScroll()
  self._txtRule = UI.getChildControl(self._frame_Content, "StaticText_RuleContent")
  self._txtReward = UI.getChildControl(self._frame_Content, "StaticText_RewardContent")
  self._txtInfo = UI.getChildControl(self._frame_Content, "StaticText_InfoContent")
  self._desc_Rule_Title = UI.getChildControl(self._frame_Content, "StaticText_LocalWar_Rule")
  self._desc_rule = UI.getChildControl(self._frame_Content, "Static_BG_1")
  self.desc_Rule = {
    [0] = UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_1"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_2"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_3"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_4"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_5"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_6"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_7"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_8"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_9"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_10"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_11"),
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_12")
  }
  self.desc_RuleText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_5"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_6"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_7"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_8"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_9"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_10"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_RULETEXT_12")
  }
  self._desc_Reward_Title = UI.getChildControl(self._frame_Content, "StaticText_LocalWar_Reward")
  self._desc_Reward = UI.getChildControl(self._frame_Content, "Static_BG_2")
  self.desc_Reward = {
    [0] = UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_1"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_2"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_3")
  }
  self.desc_RewardText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_REWARD_3")
  }
  self._rewardCount = 2
  self._desc_Explanation_Title = UI.getChildControl(self._frame_Content, "StaticText_LocalWar_Explanation")
  self._desc_Explanation = UI.getChildControl(self._frame_Content, "Static_BG_3")
  self.desc_Explanation = {
    [0] = UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_1"),
    UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_2"),
    UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_3"),
    UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_4"),
    UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_5")
  }
  self.desc_ExplanationText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DESC_EXPLANATION_5")
  }
  self._btnClose = UI.getChildControl(self._titleBg, "Button_Win_Close")
  self._btnHelp = UI.getChildControl(self._titleBg, "Button_Question")
  for listIdx = 0, self._createListCount - 1 do
    local localWar = {}
    localWar.BG = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_ListBG", self._listBg, "LocalWarInfo_BG_" .. listIdx)
    localWar.BG:SetPosX(0)
    localWar.BG:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    localWar.level = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Limit_Level", localWar.BG, "localWarInfo_Level_" .. listIdx)
    localWar.level:SetPosX(25)
    localWar.level:SetPosY(0)
    localWar.ap = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Limit_AP", localWar.BG, "localWarInfo_AP_" .. listIdx)
    localWar.ap:SetPosX(65)
    localWar.ap:SetPosY(0)
    localWar.dp = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Limit_DP", localWar.BG, "localWarInfo_DP_" .. listIdx)
    localWar.dp:SetPosX(105)
    localWar.dp:SetPosY(0)
    localWar.adSum = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Limit_ADSum", localWar.BG, "localWarInfo_ADSum_" .. listIdx)
    localWar.adSum:SetPosX(145)
    localWar.adSum:SetPosY(0)
    localWar.unLimit = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Limit_Unlimit", localWar.BG, "localWarInfo_Unlimit_" .. listIdx)
    localWar.unLimit:SetPosX(65)
    localWar.unLimit:SetPosY(0)
    localWar.channel = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_Channel", localWar.BG, "localWarInfo_Channel_" .. listIdx)
    localWar.channel:SetPosX(215)
    localWar.channel:SetPosY(0)
    localWar.joinMember = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_JoinMemberCount", localWar.BG, "localWarInfo_JoinMember_" .. listIdx)
    localWar.joinMember:SetPosX(361)
    localWar.joinMember:SetPosY(0)
    localWar.remainTime = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "StaticText_RemainTime", localWar.BG, "localWarInfo_RemainTime_" .. listIdx)
    localWar.remainTime:SetPosX(463)
    localWar.remainTime:SetPosY(0)
    localWar.join = UI.createAndCopyBasePropertyControl(Panel_LocalWarInfo, "Button_Join", localWar.BG, "localWarInfo_Join_" .. listIdx)
    localWar.join:SetPosX(570)
    localWar.join:SetPosY(4)
    self._listPool[listIdx] = localWar
    localWar.BG:addInputEvent("Mouse_UpScroll", "LocalWarInfo_ScrollEvent( true )")
    localWar.BG:addInputEvent("Mouse_DownScroll", "LocalWarInfo_ScrollEvent( false )")
    localWar.channel:addInputEvent("Mouse_UpScroll", "LocalWarInfo_ScrollEvent( true )")
    localWar.channel:addInputEvent("Mouse_DownScroll", "LocalWarInfo_ScrollEvent( false )")
    localWar.joinMember:addInputEvent("Mouse_UpScroll", "LocalWarInfo_ScrollEvent( true )")
    localWar.joinMember:addInputEvent("Mouse_DownScroll", "LocalWarInfo_ScrollEvent( false )")
    localWar.remainTime:addInputEvent("Mouse_UpScroll", "LocalWarInfo_ScrollEvent( true )")
    localWar.remainTime:addInputEvent("Mouse_DownScroll", "LocalWarInfo_ScrollEvent( false )")
    UIScroll.InputEventByControl(localWar.BG, "LocalWarInfo_ScrollEvent")
    UIScroll.InputEventByControl(localWar.channel, "LocalWarInfo_ScrollEvent")
    UIScroll.InputEventByControl(localWar.joinMember, "LocalWarInfo_ScrollEvent")
    UIScroll.InputEventByControl(localWar.remainTime, "LocalWarInfo_ScrollEvent")
  end
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_LocalWarInfo:SetPosX((screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2)
  Panel_LocalWarInfo:SetPosY((screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2)
  self._icon_Level:addInputEvent("Mouse_On", "LocalWarInfo_SimpleTooltip( true, 0 )")
  self._icon_Level:addInputEvent("Mouse_Out", "LocalWarInfo_SimpleTooltip( false, 0 )")
  self._icon_AP:addInputEvent("Mouse_On", "LocalWarInfo_SimpleTooltip( true, 1 )")
  self._icon_AP:addInputEvent("Mouse_Out", "LocalWarInfo_SimpleTooltip( false, 1 )")
  self._icon_DP:addInputEvent("Mouse_On", "LocalWarInfo_SimpleTooltip( true, 2 )")
  self._icon_DP:addInputEvent("Mouse_Out", "LocalWarInfo_SimpleTooltip( false, 2 )")
  self._icon_AD:addInputEvent("Mouse_On", "LocalWarInfo_SimpleTooltip( true, 3 )")
  self._icon_AD:addInputEvent("Mouse_Out", "LocalWarInfo_SimpleTooltip( false, 3 )")
  self._icon_Level:setTooltipEventRegistFunc("LocalWarInfo_SimpleTooltip( true, 0 )")
  self._icon_AP:setTooltipEventRegistFunc("LocalWarInfo_SimpleTooltip( true, 1 )")
  self._icon_DP:setTooltipEventRegistFunc("LocalWarInfo_SimpleTooltip( true, 2 )")
  self._icon_AD:setTooltipEventRegistFunc("LocalWarInfo_SimpleTooltip( true, 3 )")
  if isGrouthLocalwar then
    localWarInfo._rewardCount = 3
  else
    localWarInfo.desc_Reward[2]:SetShow(false)
    localWarInfo._rewardCount = 2
  end
  self._txtRule:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txtReward:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._txtInfo:SetTextMode(UI_TM.eTextMode_AutoWrap)
  for _, control in pairs(self.desc_Rule) do
    control:SetTextMode(UI_TM.eTextMode_AutoWrap)
    control:SetAutoResize(true)
  end
  for index = 0, #self.desc_RuleText do
    self.desc_Rule[index]:SetText(self.desc_RuleText[index])
    self._maxDescRuleSize = self._maxDescRuleSize + self.desc_Rule[index]:GetTextSizeY()
  end
  for _, control in pairs(self.desc_Reward) do
    control:SetTextMode(UI_TM.eTextMode_AutoWrap)
    control:SetAutoResize(true)
  end
  for index = 0, self._rewardCount - 1 do
    self.desc_Reward[index]:SetText(self.desc_RewardText[index])
    self._maxDescRewardSize = self._maxDescRewardSize + self.desc_Reward[index]:GetTextSizeY()
  end
  for _, control in pairs(self.desc_Explanation) do
    control:SetTextMode(UI_TM.eTextMode_AutoWrap)
    control:SetAutoResize(true)
  end
  for index = 0, #self.desc_ExplanationText do
    self.desc_Explanation[index]:SetText(self.desc_ExplanationText[index])
    self._maxDescExplanationSize = self._maxDescExplanationSize + self.desc_Explanation[index]:GetTextSizeY()
  end
  self._txtRule:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_RULE"))
  self._txtReward:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_REWARD"))
  self._txtInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_INFO"))
  self._desc_Reward_Title:SetPosY(85)
  self._desc_Explanation_Title:SetPosY(110)
  for index = 0, #self.desc_RuleText do
    self.desc_Rule[index]:SetPosX(5)
  end
  self.desc_Rule[0]:SetPosY(5)
  self.desc_Rule[1]:SetPosY(self.desc_Rule[0]:GetPosY() + self.desc_Rule[0]:GetTextSizeY() + 2)
  self.desc_Rule[2]:SetPosY(self.desc_Rule[1]:GetPosY() + self.desc_Rule[1]:GetTextSizeY() + 2)
  self.desc_Rule[3]:SetPosY(self.desc_Rule[2]:GetPosY() + self.desc_Rule[2]:GetTextSizeY() + 2)
  self.desc_Rule[4]:SetPosY(self.desc_Rule[3]:GetPosY() + self.desc_Rule[3]:GetTextSizeY() + 2)
  self.desc_Rule[5]:SetPosY(self.desc_Rule[4]:GetPosY() + self.desc_Rule[4]:GetTextSizeY() + 2)
  self.desc_Rule[6]:SetPosY(self.desc_Rule[5]:GetPosY() + self.desc_Rule[5]:GetTextSizeY() + 2)
  self.desc_Rule[7]:SetPosY(self.desc_Rule[6]:GetPosY() + self.desc_Rule[6]:GetTextSizeY() + 2)
  self.desc_Rule[8]:SetPosY(self.desc_Rule[7]:GetPosY() + self.desc_Rule[7]:GetTextSizeY() + 2)
  self.desc_Rule[9]:SetPosY(self.desc_Rule[8]:GetPosY() + self.desc_Rule[8]:GetTextSizeY() + 2)
  self.desc_Rule[10]:SetPosY(self.desc_Rule[9]:GetPosY() + self.desc_Rule[9]:GetTextSizeY() + 2)
  self.desc_Rule[11]:SetPosY(self.desc_Rule[10]:GetPosY() + self.desc_Rule[10]:GetTextSizeY() + 2)
  for index = 0, self._rewardCount - 1 do
    self.desc_Reward[index]:SetPosX(5)
  end
  self.desc_Reward[0]:SetPosY(5)
  self.desc_Reward[1]:SetPosY(self.desc_Reward[0]:GetPosY() + self.desc_Reward[0]:GetTextSizeY() + 2)
  if isGrouthLocalwar then
    self.desc_Reward[2]:SetPosY(self.desc_Reward[1]:GetPosY() + self.desc_Reward[1]:GetTextSizeY() + 2)
  end
  for index = 0, #self.desc_ExplanationText do
    self.desc_Explanation[index]:SetPosX(5)
  end
  self.desc_Explanation[0]:SetPosY(5)
  self.desc_Explanation[1]:SetPosY(self.desc_Explanation[0]:GetPosY() + self.desc_Explanation[0]:GetTextSizeY() + 2)
  self.desc_Explanation[2]:SetPosY(self.desc_Explanation[1]:GetPosY() + self.desc_Explanation[1]:GetTextSizeY() + 2)
  self.desc_Explanation[3]:SetPosY(self.desc_Explanation[2]:GetPosY() + self.desc_Explanation[2]:GetTextSizeY() + 2)
  self.desc_Explanation[4]:SetPosY(self.desc_Explanation[3]:GetPosY() + self.desc_Explanation[3]:GetTextSizeY() + 2)
  self._txtRule:SetPosX(5)
  self._txtRule:SetPosY(5)
  self._blackBG:SetSize(getScreenSizeX() + 250, getScreenSizeY() + 250)
  self._blackBG:SetHorizonCenter()
  self._blackBG:SetVerticalMiddle()
  if isGameTypeKorea() or isGameTypeJapan() or isGameTypeRussia() or isGameTypeEnglish() then
    self._icon_Level:SetShow(true)
    self._icon_Level:SetSpanSize(40, 70)
    self._icon_AP:SetSpanSize(80, 70)
    self._icon_DP:SetSpanSize(120, 70)
    self._icon_AD:SetSpanSize(160, 70)
  else
    self._icon_Level:SetShow(false)
    self._icon_AP:SetSpanSize(40, 70)
    self._icon_DP:SetSpanSize(80, 70)
    self._icon_AD:SetSpanSize(120, 70)
  end
  self._scroll:SetControlTop()
end
function localWarInfo:Update()
  for listIdx = 0, self._createListCount - 1 do
    local list = self._listPool[listIdx]
    list.BG:SetShow(false)
    list.channel:SetShow(false)
    list.joinMember:SetShow(false)
    list.remainTime:SetShow(false)
    list.join:SetShow(false)
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local localWarServerCount = ToClient_GetLocalwarStatusCount()
  if localWarServerCount > 6 then
    localWarServerCountLimit = 6
  else
    localWarServerCountLimit = ToClient_GetLocalwarStatusCount()
  end
  local count = 0
  for listIdx = self._startIndex, self._createListCount - 1 do
    if count >= self._createListCount then
      break
    end
    if count >= localWarServerCountLimit then
      break
    end
    local localWarStatusData = ToClient_GetLocalwarStatusData(listIdx)
    local getServerNo = localWarStatusData:getServerNo()
    local getJoinMemberCount = localWarStatusData:getTotalJoinCount()
    local getCurrentState = localWarStatusData:getState()
    local getRemainTime = localWarStatusData:getRemainTime()
    local warTimeMinute = math.floor(Int64toInt32(getRemainTime / toInt64(0, 60)))
    local warTimeSecond = Int64toInt32(getRemainTime) % 60
    local channelName = getChannelName(curChannelData._worldNo, getServerNo)
    local isLimitLocalWar = localWarStatusData:isLimitedLocalWar()
    if nil ~= channelName then
      if getJoinMemberCount < 0 then
        getJoinMemberCount = 0
      end
      local list = self._listPool[count]
      if isGameTypeKorea() or isGameTypeJapan() then
        list.level:SetShow(true)
        list.level:SetPosX(25)
        list.ap:SetPosX(65)
        list.dp:SetPosX(105)
        list.adSum:SetPosX(145)
      else
        list.level:SetShow(false)
        list.ap:SetPosX(25)
        list.dp:SetPosX(65)
        list.adSum:SetPosX(105)
      end
      if isLimitLocalWar then
        list.unLimit:SetShow(false)
        list.level:SetText(ToClient_GetLevelForLimitedLocalWar() - 1)
        list.ap:SetText(ToClient_GetAttackForLimitedLocalWar() - 1)
        list.dp:SetText(ToClient_GetDefenseForLimitedLocalWar() - 1)
        list.adSum:SetText(ToClient_GetADSummaryForLimitedLocalWar() - 1)
      else
        list.unLimit:SetShow(true)
        list.level:SetText("")
        list.ap:SetText("")
        list.dp:SetText("")
        list.adSum:SetText("")
      end
      if 0 == getCurrentState then
        isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN_WAITING")
        isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING")
        list.join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN"))
        list.join:SetIgnore(false)
      elseif 1 == getCurrentState then
        isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ING")
        isWarTime = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond))
        if warTimeMinute >= 10 then
          list.join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN"))
          list.join:SetIgnore(false)
        else
          list.join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN"))
          list.join:SetIgnore(true)
        end
      elseif 2 == getCurrentState then
        isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_SOONFINISH")
        isWarTime = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", warTimeMinute, "warTimeSecond", Int64toInt32(warTimeSecond))
        list.join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN"))
        list.join:SetIgnore(true)
      elseif 3 == getCurrentState then
        isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
        isWarTime = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
        list.join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN"))
        list.join:SetIgnore(true)
      end
      list.BG:SetShow(true)
      list.channel:SetShow(true)
      list.joinMember:SetShow(true)
      list.remainTime:SetShow(true)
      list.join:SetShow(true)
      list.channel:SetText(channelName)
      list.joinMember:SetText(getJoinMemberCount)
      list.remainTime:SetText(isWarTime)
      list.join:addInputEvent("Mouse_LUp", "LocalWawrInfo_ClickedJoinLocalWar( " .. listIdx .. "," .. tostring(isLimitLocalWar) .. " )")
      count = count + 1
    end
  end
  local inMyChannelInfo = ToClient_GetLocalwarStatusDataToServer(curChannelData._serverNo)
  if nil == inMyChannelInfo then
    self._btnInmy:SetFontColor(UI_color.C_FFF26A6A)
    self._btnInmy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOTOPENWAR"))
    self._btnInmy:SetEnable(false)
    self._btnInmy:addInputEvent("Mouse_LUp", "")
  else
    local inMyJoinCount = inMyChannelInfo:getTotalJoinCount()
    local inMyJoinState = inMyChannelInfo:getState()
    local inMyRemainTime = inMyChannelInfo:getRemainTime()
    local inMyRemainTimeMinute = math.floor(Int64toInt32(inMyRemainTime / toInt64(0, 60)))
    local inMyRemainTimeSecond = Int64toInt32(inMyRemainTime) % 60
    local inMyChannelName = getChannelName(curChannelData._worldNo, curChannelData._serverNo)
    if 0 == inMyJoinState then
      isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITING")
    elseif 1 == inMyJoinState then
      isMyChannelState = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond))
    elseif 2 == inMyJoinState then
      isMyChannelState = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_TIME", "warTimeMinute", inMyRemainTimeMinute, "warTimeSecond", Int64toInt32(inMyRemainTimeSecond))
    elseif 3 == inMyJoinState then
      isMyChannelState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
    end
    self._btnInmy:SetFontColor(UI_color.C_FF00C0D7)
    self._btnInmy:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_OPENWAR_INMYCHANNEL", "inMyChannelName", inMyChannelName, "inMyJoinCount", inMyJoinCount, "isMyChannelState", isMyChannelState))
    self._btnInmy:SetEnable(true)
    self._btnInmy:addInputEvent("Mouse_LUp", "HandleClicked_InMyChannelJoin()")
  end
  UIScroll.SetButtonSize(self._scroll, self._createListCount, localWarServerCountLimit)
end
function FGlobal_LocalWarInfo_Open()
  if false == ToClient_IsGrowStepOpen(__eGrowStep_localWar) then
    return
  end
  local self = localWarInfo
  ToClient_RequestLocalwarStatus()
  if Panel_LocalWarInfo:GetShow() then
    Panel_LocalWarInfo:SetShow(false, true)
  else
    Panel_LocalWarInfo:SetShow(true, true)
  end
  self._desc_Rule_Title:SetCheck(true)
  self._desc_Reward_Title:SetCheck(false)
  self._desc_Explanation_Title:SetCheck(false)
  self._desc_rule:SetShow(false)
  self._desc_Reward:SetShow(false)
  self._desc_Explanation:SetShow(false)
  self._desc_rule:SetSize(self._desc_rule:GetSizeX(), 1)
  self._desc_Reward:SetSize(self._desc_Reward:GetSizeX(), 1)
  self._desc_Explanation:SetSize(self._desc_Explanation:GetSizeX(), 1)
  self._startIndex = 0
  self._scroll:SetControlTop()
  self:Update()
end
function FGlobal_LocalWarInfo_Close()
  local self = localWarInfo
  self._openDesc = -1
  self._desc_Rule_Title:SetCheck(false)
  self._desc_Reward_Title:SetCheck(false)
  self._desc_Explanation_Title:SetCheck(false)
  self._desc_rule:SetShow(false)
  self._desc_Reward:SetShow(false)
  self._desc_Explanation:SetShow(false)
  self._desc_rule:SetSize(self._desc_rule:GetSizeX(), 1)
  self._desc_Reward:SetSize(self._desc_Reward:GetSizeX(), 1)
  self._desc_Explanation:SetSize(self._desc_Explanation:GetSizeX(), 1)
  Panel_LocalWarInfo:SetShow(false, true)
  TooltipSimple_Hide()
end
function FGlobal_LocalWarInfo_GetOut()
  if IsSelfPlayerWaitAction() then
    ToClient_UnJoinLocalWar()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_WAITPOSITION_POSSIBLE"))
  end
end
function LocalWarInfo_Repos()
  local self = localWarInfo
  local screenSizeX = getOriginScreenSizeX()
  local screenSizeY = getOriginScreenSizeY()
  Panel_LocalWarInfo:SetPosX((screenSizeX - Panel_LocalWarInfo:GetSizeX()) / 2)
  Panel_LocalWarInfo:SetPosY((screenSizeY - Panel_LocalWarInfo:GetSizeY()) / 2)
  Panel_LocalWarInfo:ComputePos()
  self._blackBG:SetSize(getScreenSizeX() + 250, getScreenSizeY() + 250)
  self._blackBG:SetHorizonCenter()
  self._blackBG:SetVerticalMiddle()
end
function LocalWarInfo_ScrollEvent(isScrollUp)
  local self = localWarInfo
  local localWarServerCount = ToClient_GetLocalwarStatusCount()
  if localWarServerCount > 6 then
    localWarServerCountLimit = 6
  else
    localWarServerCountLimit = ToClient_GetLocalwarStatusCount()
  end
  self._startIndex = UIScroll.ScrollEvent(self._scroll, isScrollUp, self._createListCount, localWarServerCountLimit, self._startIndex, 1)
  self:Update()
end
function LocalWawrInfo_ClickedJoinLocalWar(index, isLimitLocalWar)
  local curChannelData = getCurrentChannelServerData()
  local getLevel = getSelfPlayer():get():getLevel()
  if nil == curChannelData then
    return
  end
  local litmitLevel = ToClient_GetLevelForLimitedLocalWar()
  local limitAttack = ToClient_GetAttackForLimitedLocalWar()
  local limitDefence = ToClient_GetDefenseForLimitedLocalWar()
  local limitADSum = ToClient_GetADSummaryForLimitedLocalWar()
  local isMineADSum = ToClient_getOffence() + ToClient_getDefence()
  if not isLimitLocalWar and getLevel < 50 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT"))
    return
  end
  if isLimitLocalWar then
    if getLevel >= litmitLevel then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVEL_LIMIT"))
    elseif limitAttack <= ToClient_getOffence() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ATTACK_LIMIT"))
    elseif limitDefence <= ToClient_getDefence() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_DEFENCE_LIMIT"))
    elseif limitADSum <= isMineADSum then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ADSUM_LIMIT"))
    end
  end
  local localWarStatusData = ToClient_GetLocalwarStatusData(index)
  local getServerNo = localWarStatusData:getServerNo()
  local channelName = getChannelName(curChannelData._worldNo, getServerNo)
  local isGameMaster = ToClient_SelfPlayerIsGM()
  local channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName)
  local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, index)
  local function joinLocalWar()
    local playerWrapper = getSelfPlayer()
    local player = playerWrapper:get()
    local hp = player:getHp()
    local maxHp = player:getMaxHp()
    if player:doRideMyVehicle() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_NOT_RIDEHORSE"))
    elseif ToClient_IsMyselfInArena() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCompetitionAlreadyIn"))
      return
    end
    if IsSelfPlayerWaitAction() then
      if hp == maxHp or isGameMaster then
        if getServerNo == curChannelData._serverNo then
          ToClient_JoinLocalWar()
        else
          ToClient_RequestLocalwarJoinToAnotherChannel(getServerNo)
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
      end
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_LOCALWARINFO"))
    end
  end
  if getServerNo == curChannelData._serverNo then
    channelMemo = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CURRENTCHANNELJOIN")
  else
    channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName)
  end
  local changeChannelTime = getChannelMoveableRemainTime(curChannelData._worldNo)
  local changeRealChannelTime = convertStringFromDatetime(changeChannelTime)
  if changeChannelTime > toInt64(0, 0) and getServerNo ~= curChannelData._serverNo then
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANGECHANNEL_PENALTY", "changeRealChannelTime", changeRealChannelTime)
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHANNELMOVE_TITLE_MSG"),
      content = channelMemo,
      functionYes = joinLocalWar,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function FromClient_UpdateLocalWarStatus()
  local self = localWarInfo
  self:Update()
end
function HandleClicked_InMyChannelJoin()
  local playerWrapper = getSelfPlayer()
  if nil == playerWrapper then
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if nil == curChannelData then
    return
  end
  local player = playerWrapper:get()
  local hp = player:getHp()
  local maxHp = player:getMaxHp()
  local isGameMaster = ToClient_SelfPlayerIsGM()
  local getLevel = playerWrapper:get():getLevel()
  local inMyChannelInfo = ToClient_GetLocalwarStatusDataToServer(curChannelData._serverNo)
  local isLimitLocalWar = inMyChannelInfo:isLimitedLocalWar()
  if not isLimitLocalWar and getLevel < 50 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LEVELLIMIT"))
    return
  end
  if hp == maxHp or isGameMaster then
    ToClient_JoinLocalWar()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
  end
end
function LocalWarInfo_SimpleTooltip(isShow, tipType)
  local self = localWarInfo
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_LEVEL_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_LEVEL_DESC")
    control = self._icon_Level
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_AP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_AP_DESC")
    control = self._icon_AP
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_DP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_DP_DESC")
    control = self._icon_DP
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_ADSUM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_LIMIT_TOOLTIP_ADSUM_DESC")
    control = self._icon_AD
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function LocalWarInfo_RegistEventHandler()
  local self = localWarInfo
  self._btnClose:addInputEvent("Mouse_LUp", "FGlobal_LocalWarInfo_Close()")
  self._listBg:addInputEvent("Mouse_UpScroll", "LocalWarInfo_ScrollEvent( true )")
  self._listBg:addInputEvent("Mouse_DownScroll", "LocalWarInfo_ScrollEvent( false )")
  self._desc_Rule_Title:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(0)")
  self._desc_Reward_Title:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(1)")
  self._desc_Explanation_Title:addInputEvent("Mouse_LUp", "LocalWarInfo_DescriptionCheck(2)")
  UIScroll.InputEvent(self._scroll, "LocalWarInfo_ScrollEvent")
  localWarInfo._btnHelp:SetShow(false)
end
function LocalWarInfo_DescriptionCheck(descType)
  local self = localWarInfo
  self._frame_VScroll:SetControlTop()
  self._frame:UpdateContentScroll()
  self._frame:UpdateContentPos()
  if 0 == descType then
    self._openDesc = descType
    self._desc_rule:SetShow(true)
  elseif 1 == descType then
    self._openDesc = descType
    self._desc_Reward:SetShow(true)
  elseif 2 == descType then
    self._openDesc = descType
    self._desc_Explanation:SetShow(true)
  else
    self._openDesc = -1
  end
end
local rule_ani_SpeedTime = 5
local _desc_Rule_TitleSize = 0
function LocalWarInfo_InformationOpen(deltaTime)
  local self = localWarInfo
  if self._desc_Rule_Title:IsCheck() then
    local value = self._desc_rule:GetSizeY() + (self._maxDescRuleSize - self._desc_rule:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 130)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 130)
    self._desc_rule:SetSize(self._desc_rule:GetSizeX(), value)
    self._desc_rule:SetShow(true)
  else
    local value = self._desc_rule:GetSizeY() - (self._maxDescRuleSize + self._desc_rule:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._desc_rule:SetSize(self._desc_rule:GetSizeX(), value)
    if self._desc_rule:GetSizeY() <= 10 then
      self._desc_rule:SetShow(false)
    end
  end
  if self._desc_Reward_Title:IsCheck() then
    local value = self._desc_Reward:GetSizeY() + (self._maxDescRewardSize - self._desc_Reward:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 130)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 130)
    self._desc_Reward:SetSize(self._desc_Reward:GetSizeX(), value)
    self._desc_Reward:SetShow(true)
  else
    local value = self._desc_Reward:GetSizeY() - (self._maxDescRewardSize + self._desc_Reward:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._desc_Reward:SetSize(self._desc_Reward:GetSizeX(), value)
    if 10 >= self._desc_Reward:GetSizeY() then
      self._desc_Reward:SetShow(false)
    end
  end
  if self._desc_Explanation_Title:IsCheck() then
    local value = self._desc_Explanation:GetSizeY() + (self._maxDescExplanationSize - self._desc_Explanation:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 130)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 130)
    self._desc_Explanation:SetSize(self._desc_Explanation:GetSizeX(), value)
    self._desc_Explanation:SetShow(true)
  else
    local value = self._desc_Explanation:GetSizeY() - (self._maxDescExplanationSize + self._desc_Explanation:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._desc_Explanation:SetSize(self._desc_Explanation:GetSizeX(), value)
    if 10 >= self._desc_Explanation:GetSizeY() then
      self._desc_Explanation:SetShow(false)
    end
  end
  self._desc_rule:SetPosY(self._desc_Rule_Title:GetPosY() + self._desc_Rule_Title:GetSizeY())
  if self._desc_rule:GetShow() then
    self._desc_Reward_Title:SetPosY(self._desc_rule:GetPosY() + self._desc_rule:GetSizeY() + 10)
  else
    self._desc_Reward_Title:SetPosY(self._desc_Rule_Title:GetPosY() + self._desc_Rule_Title:GetSizeY() + 5)
  end
  self._desc_Reward:SetPosY(self._desc_Reward_Title:GetPosY() + self._desc_Reward_Title:GetSizeY())
  if self._desc_Reward:GetShow() then
    self._desc_Explanation_Title:SetPosY(self._desc_Reward:GetPosY() + self._desc_Reward:GetSizeY() + 10)
  else
    self._desc_Explanation_Title:SetPosY(self._desc_Reward_Title:GetPosY() + self._desc_Reward_Title:GetSizeY() + 5)
  end
  self._desc_Explanation:SetPosY(self._desc_Explanation_Title:GetPosY() + self._desc_Explanation_Title:GetSizeY())
  for _, control in pairs(self.desc_Rule) do
    control:SetShow(control:GetPosY() + control:GetSizeY() < self._desc_rule:GetSizeY())
  end
  for _, control in pairs(self.desc_Reward) do
    control:SetShow(control:GetPosY() + control:GetSizeY() < self._desc_Reward:GetSizeY())
  end
  for _, control in pairs(self.desc_Explanation) do
    control:SetShow(control:GetPosY() + control:GetSizeY() < self._desc_Explanation:GetSizeY())
  end
end
function LocalWarInfo_RegistMessageHandler()
  registerEvent("onScreenResize", "LocalWarInfo_Repos")
  registerEvent("FromClient_UpdateLocalWarStatus", "FromClient_UpdateLocalWarStatus")
  Panel_LocalWarInfo:RegisterUpdateFunc("LocalWarInfo_InformationOpen")
end
LocalWarInfo_Initionalize()
LocalWarInfo_RegistEventHandler()
LocalWarInfo_RegistMessageHandler()
