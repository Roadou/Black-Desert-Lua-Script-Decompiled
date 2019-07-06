local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
local isOpenReservation = true
Panel_SavageDefenceInfo:SetShow(false)
Panel_SavageDefenceInfo:setMaskingChild(true)
Panel_SavageDefenceInfo:ActiveMouseEventEffect(true)
Panel_SavageDefenceInfo:setGlassBackground(true)
local PaGlobal_SavegeDefenceInfo = {
  _blackBG = UI.getChildControl(Panel_SavageDefenceInfo, "Static_BlackBG"),
  _txtTitle = UI.getChildControl(Panel_SavageDefenceInfo, "StaticText_Title"),
  _btnClose = UI.getChildControl(Panel_SavageDefenceInfo, "Button_Win_Close"),
  _btnHelp = UI.getChildControl(Panel_SavageDefenceInfo, "Button_Question"),
  _listBg = UI.getChildControl(Panel_SavageDefenceInfo, "Static_SavageDefenceListBG"),
  _btnInmy = UI.getChildControl(Panel_SavageDefenceInfo, "Button_InmyChannel"),
  _list2 = UI.getChildControl(Panel_SavageDefenceInfo, "List2_SavageDefenceList"),
  _frame = UI.getChildControl(Panel_SavageDefenceInfo, "Frame_Description"),
  _createListCount = 14,
  _startIndex = 0,
  _listPool = {},
  _openDesc = -1,
  _maxDescRuleSize = 40,
  _maxDescRewardSize = 20,
  _maxDescExplanationSize = 30,
  _posConfig = {
    _listStartPosY = 25,
    _iconStartPosY = 88,
    _listPosYGap = 31
  }
}
function FGlobal_SavegeDefenceInfo_Initionalize()
  local self = PaGlobal_SavegeDefenceInfo
  self._frame_Content = self._frame:GetFrameContent()
  self._frame_VScroll = self._frame:GetVScroll()
  self._desc_Rule_Title = UI.getChildControl(self._frame_Content, "StaticText_SavageDefence_Rule")
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
    UI.getChildControl(self._desc_rule, "StaticText_Desc_Rule_10")
  }
  self.desc_RuleText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_5"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_6"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_7"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_8"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_9"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_RULETEXT_10")
  }
  self._desc_Reward_Title = UI.getChildControl(self._frame_Content, "StaticText_SavageDefence_Reward")
  self._desc_Reward = UI.getChildControl(self._frame_Content, "Static_BG_2")
  self.desc_Reward = {
    [0] = UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_1"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_2"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_3"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_4"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_5"),
    UI.getChildControl(self._desc_Reward, "StaticText_Desc_Reward_6")
  }
  self.desc_RewardText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_5"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_REWARD_6")
  }
  self._desc_Explanation_Title = UI.getChildControl(self._frame_Content, "StaticText_SavageDefence_Explanation")
  self._desc_Explanation = UI.getChildControl(self._frame_Content, "Static_BG_3")
  self.desc_Explanation = {
    [0] = UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_1"),
    UI.getChildControl(self._desc_Explanation, "StaticText_Desc_Explanation_2")
  }
  self.desc_ExplanationText = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_EXPLANATION_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_DESC_EXPLANATION_2")
  }
  self._list2:changeAnimationSpeed(10)
  self._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_SavegeDefenceInfo_ListUpdate")
  self._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
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
  for index = 0, #self.desc_RewardText do
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
  for index = 0, #self.desc_RewardText do
    self.desc_Reward[index]:SetPosX(5)
  end
  self.desc_Reward[0]:SetPosY(5)
  self.desc_Reward[1]:SetPosY(self.desc_Reward[0]:GetPosY() + self.desc_Reward[0]:GetTextSizeY() + 2)
  self.desc_Reward[2]:SetPosY(self.desc_Reward[1]:GetPosY() + self.desc_Reward[1]:GetTextSizeY() + 2)
  self.desc_Reward[3]:SetPosY(self.desc_Reward[2]:GetPosY() + self.desc_Reward[2]:GetTextSizeY() + 2)
  self.desc_Reward[4]:SetPosY(self.desc_Reward[3]:GetPosY() + self.desc_Reward[3]:GetTextSizeY() + 2)
  self.desc_Reward[5]:SetPosY(self.desc_Reward[4]:GetPosY() + self.desc_Reward[4]:GetTextSizeY() + 2)
  for index = 0, #self.desc_ExplanationText do
    self.desc_Explanation[index]:SetPosX(5)
  end
  self.desc_Explanation[0]:SetPosY(5)
  self.desc_Explanation[1]:SetPosY(self.desc_Explanation[0]:GetPosY() + self.desc_Explanation[0]:GetTextSizeY() + 2)
  self._blackBG:SetSize(getScreenSizeX() + 250, getScreenSizeY() + 250)
  self._blackBG:SetHorizonCenter()
  self._blackBG:SetVerticalMiddle()
  self._btnInmy:SetShow(false)
  self._btnClose:addInputEvent("Mouse_LUp", "FGlobal_SavageDefenceInfo_Close()")
  self._desc_Rule_Title:addInputEvent("Mouse_LUp", "SavageDefenceInfo_DescriptionCheck(0)")
  self._desc_Reward_Title:addInputEvent("Mouse_LUp", "SavageDefenceInfo_DescriptionCheck(1)")
  self._desc_Explanation_Title:addInputEvent("Mouse_LUp", "SavageDefenceInfo_DescriptionCheck(2)")
end
function SavageDefenceInfo_DescriptionCheck(descType)
  local self = PaGlobal_SavegeDefenceInfo
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
function FGlobal_SavegeDefenceInfo_ListUpdate(contents, key)
  local self = PaGlobal_SavegeDefenceInfo
  local idx = Int64toInt32(key)
  local savageDefenceListBG = UI.getChildControl(contents, "StaticText_ListBG")
  savageDefenceListBG:SetShow(true)
  local savageDefenceListServer = UI.getChildControl(contents, "StaticText_Channel")
  savageDefenceListServer:SetShow(true)
  local savageDefenceListJoinMember = UI.getChildControl(contents, "StaticText_JoinMemberCount")
  savageDefenceListJoinMember:SetShow(true)
  local savageDefenceListStatus = UI.getChildControl(contents, "StaticText_DefenceStatus")
  savageDefenceListStatus:SetShow(true)
  local savageDefenceListWave = UI.getChildControl(contents, "StaticText_DefenceWave")
  savageDefenceListWave:SetShow(true)
  local savageDefenceListJoinBtn = UI.getChildControl(contents, "Button_Join")
  savageDefenceListJoinBtn:SetShow(true)
  local savageDefenceListReserveBtn = UI.getChildControl(contents, "Button_Reserve")
  local curChannelData = getCurrentChannelServerData()
  local worldServerData = getGameWorldServerDataByWorldNo(curChannelData._worldNo)
  local restrictedServerNo = worldServerData._restrictedServerNo
  local isAdmission = true
  if restrictedServerNo ~= 0 then
    if restrictedServerNo == curChannelData._serverNo then
      isAdmission = true
    elseif toInt64(0, 0) < changeChannelTime then
      isAdmission = false
    else
      isAdmission = true
    end
  end
  if nil ~= curChannelData then
    local savageDefenceStatusData = ToClient_getSavageDefenceStatusData(idx)
    local getServerNo = savageDefenceStatusData:getServerNo()
    local getJoinMemberCount = savageDefenceStatusData:getTotalJoinCount()
    local getCurrentState = savageDefenceStatusData:getState()
    local getWave = savageDefenceStatusData:getWave()
    local channelName = getChannelName(curChannelData._worldNo, getServerNo)
    local getIsStopByGM = savageDefenceStatusData:getIsStopByGM()
    if getJoinMemberCount < 0 then
      getJoinMemberCount = 0
    end
    if true == getIsStopByGM then
      getCurrentState = 4
    end
    if 0 == getCurrentState then
      isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN_WAITING")
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_JOIN"))
      savageDefenceListJoinBtn:SetIgnore(false)
      getWave = 0
    elseif 1 == getCurrentState then
      isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_ING")
      savageDefenceListJoinBtn:SetFontColor(Defines.Color.C_FFF0EF9D)
      savageDefenceListJoinBtn:SetOverFontColor(Defines.Color.C_FFF0EF9D)
      savageDefenceListJoinBtn:SetClickFontColor(Defines.Color.C_FFF0EF9D)
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_GAMING"))
      savageDefenceListJoinBtn:SetIgnore(false)
    elseif 2 == getCurrentState then
      isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_SOONFINISH")
      savageDefenceListJoinBtn:SetFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetOverFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetClickFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_GAMING"))
      savageDefenceListJoinBtn:SetIgnore(true)
    elseif 3 == getCurrentState then
      isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
      savageDefenceListJoinBtn:SetFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetOverFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetClickFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN"))
      savageDefenceListJoinBtn:SetIgnore(true)
      getWave = 0
    elseif 4 == getCurrentState then
      isCurrentState = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH")
      savageDefenceListJoinBtn:SetFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetOverFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetClickFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CANTJOIN"))
      savageDefenceListJoinBtn:SetIgnore(true)
      getWave = 0
    end
    if not isAdmission then
      savageDefenceListJoinBtn:SetFontColor(Defines.Color.C_FFF26A6A)
      savageDefenceListJoinBtn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVERSELECT_ISADMISSION_LIMIT"))
      savageDefenceListJoinBtn:SetIgnore(true)
    end
    if getServerNo ~= curChannelData._serverNo or false == isOpenReservation then
      savageDefenceListReserveBtn:SetShow(false)
    else
      savageDefenceListReserveBtn:SetShow(true)
    end
    savageDefenceListServer:SetText(channelName)
    savageDefenceListJoinMember:SetText(getJoinMemberCount)
    savageDefenceListStatus:SetText(isCurrentState)
    savageDefenceListWave:SetText(getWave)
    savageDefenceListJoinBtn:addInputEvent("Mouse_LUp", "FGlobal_SavegeDefenceInfo_join(" .. idx .. ")")
    savageDefenceListReserveBtn:addInputEvent("Mouse_LUp", "FGlobal_SavegeDefenceInfo_Reserve(" .. idx .. ")")
  end
end
function PaGlobal_SavegeDefenceInfo:update()
  local serverCount = ToClient_SavageDefenceStatusCount()
  self._list2:getElementManager():clearKey()
  for idx = 0, serverCount - 1 do
    self._list2:getElementManager():pushKey(toInt64(0, idx))
  end
end
function FGlobal_SavegeDefenceInfo_join(idx)
  local curChannelData = getCurrentChannelServerData()
  if nil == getSelfPlayer() then
    return
  end
  local getLevel = getSelfPlayer():get():getLevel()
  if nil == curChannelData then
    return
  end
  if ToClient_hasInventorySavageDefenceItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEMEMBER_JOIN_FAIL_ITEM"))
    return
  end
  local savageDefenceStatusData = ToClient_getSavageDefenceStatusData(idx)
  local getServerNo = savageDefenceStatusData:getServerNo()
  local channelName = getChannelName(curChannelData._worldNo, getServerNo)
  local isGameMaster = ToClient_SelfPlayerIsGM()
  local channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_CHANNELMOVE", "channelName", channelName)
  local tempChannel = getGameChannelServerDataByWorldNo(curChannelData._worldNo, idx)
  local isBalanceServer = tempChannel._isBalanceChannel
  local function joinSavageDefence()
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
          ToClient_SavageDefenceJoin(idx)
        else
          ToClient_RequestSavageDefenceJoinToAnotherChannel(getServerNo)
        end
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
      end
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SAVAGEDEFENCEINFO"))
    end
  end
  if getServerNo == curChannelData._serverNo then
    channelMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_CURRENTCHANNELJOIN")
  else
    channelMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_CHANNELMOVE", "channelName", channelName)
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
      functionYes = joinSavageDefence,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function FGlobal_SavegeDefenceInfo_Reserve(idx)
  if nil == getSelfPlayer() then
    return
  end
  local getLevel = getSelfPlayer():get():getLevel()
  if getLevel >= 56 then
    ToClient_SavageDefenceReserve()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantJoinUserLevelIsTooLow"))
  end
end
function FGlobal_SavegeDefenceInfo_tossCoin(index, coin)
  ToClient_SavageDefenceCoinToss(index, coin)
end
function FGlobal_SavegeDefenceInfo_unjoin()
  local SavageUnJoin = function()
    ToClient_SavageDefenceUnJoin()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_GETOUT_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = SavageUnJoin,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_SavageDefenceInfo_Open()
  if false == ToClient_IsGrowStepOpen(__eGrowStep_savageDefence) then
    return
  end
  audioPostEvent_SystemUi(1, 18)
  _AudioPostEvent_SystemUiForXBOX(1, 18)
  ToClient_SavageDefenceStatusRefreshReq()
end
function FGlobal_SavageDefenceInfo_Close()
  audioPostEvent_SystemUi(1, 17)
  _AudioPostEvent_SystemUiForXBOX(1, 17)
  local self = PaGlobal_SavegeDefenceInfo
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
  Panel_SavageDefenceInfo:SetShow(false)
  TooltipSimple_Hide()
end
function FGlobal_SavageDefenceInfo_Repos()
  local self = PaGlobal_SavegeDefenceInfo
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_SavageDefenceInfo:SetPosX((screenSizeX - Panel_SavageDefenceInfo:GetSizeX()) / 2)
  Panel_SavageDefenceInfo:SetPosY((screenSizeY - Panel_SavageDefenceInfo:GetSizeY()) / 2)
  Panel_SavageDefenceInfo:ComputePos()
  self._blackBG:SetSize(getScreenSizeX() + 250, getScreenSizeY() + 250)
  self._blackBG:SetHorizonCenter()
  self._blackBG:SetVerticalMiddle()
end
local rule_ani_SpeedTime = 5
local _desc_Rule_TitleSize = 0
function FGlobal_SavegeDefenceInfo_InformationOpen(deltaTime)
  local self = PaGlobal_SavegeDefenceInfo
  if self._desc_Rule_Title:IsCheck() then
    self._desc_Rule_Title:SetCheck(true)
    local value = self._desc_rule:GetSizeY() + (self._maxDescRuleSize - self._desc_rule:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 120)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 120)
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
    self._desc_Reward_Title:SetCheck(true)
    local value = self._desc_Reward:GetSizeY() + (self._maxDescRewardSize - self._desc_Reward:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 120)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 120)
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
    self._desc_Explanation_Title:SetCheck(true)
    local value = self._desc_Explanation:GetSizeY() + (self._maxDescExplanationSize - self._desc_Explanation:GetSizeY()) * deltaTime * rule_ani_SpeedTime
    if value < 10 then
      value = 10
    end
    self._frame_VScroll:SetShow(self._frame:GetSizeY() < value + 120)
    self._frame_Content:SetSize(self._frame_Content:GetSizeX(), value + 120)
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
function FromClient_UpdateSavageDefenceStatus()
  local self = PaGlobal_SavegeDefenceInfo
  Panel_SavageDefenceInfo:SetShow(true)
  self._desc_Rule_Title:SetCheck(true)
  self._desc_Reward_Title:SetCheck(false)
  self._desc_Explanation_Title:SetCheck(false)
  self._desc_rule:SetShow(false)
  self._desc_Reward:SetShow(false)
  self._desc_Explanation:SetShow(false)
  self._desc_rule:SetSize(self._desc_rule:GetSizeX(), 1)
  self._desc_Reward:SetSize(self._desc_Reward:GetSizeX(), 1)
  self._desc_Explanation:SetSize(self._desc_Explanation:GetSizeX(), 1)
  self:update()
end
function FromClient_luaLoadComplete_SavageDefence()
  FGlobal_SavegeDefenceInfo_Initionalize()
end
function FromClient_ReserveComplete()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_RESERVECOMPLETE"))
end
function FromClient_ReserveInvite()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SAVAGEDEFENCEINFO_RESERVEINVITE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = ReserveInvite_OK,
    functionNo = ReserveInvite_Cancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function ReserveInvite_OK()
  ToClient_SavageDefenceJoin()
end
function ReserveInvite_Cancel()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SavageDefence")
registerEvent("FromClient_UpdateSavageDefenceStatus", "FromClient_UpdateSavageDefenceStatus")
registerEvent("FromClient_refreshSavageDefencePlayer", "FromClient_refreshSavageDefencePlayer")
registerEvent("FromClient_ReserveComplete", "FromClient_ReserveComplete")
registerEvent("FromClient_ReserveInvite", "FromClient_ReserveInvite")
Panel_SavageDefenceInfo:RegisterUpdateFunc("FGlobal_SavegeDefenceInfo_InformationOpen")
