Panel_Window_DailyChallenge:SetShow(false)
local dailyChallenge = {
  _ui = {
    _button_Win_Close = UI.getChildControl(Panel_Window_DailyChallenge, "Button_Win_Close"),
    _staticText_Title = UI.getChildControl(Panel_Window_DailyChallenge, "StaticText_Title"),
    _staticText_RewardCount = UI.getChildControl(Panel_Window_DailyChallenge, "StaticText_RewardCount"),
    _staticText_UncollectedRewardCount = UI.getChildControl(Panel_Window_DailyChallenge, "StaticText_UncollectedRewardCount"),
    _static_ListBg = UI.getChildControl(Panel_Window_DailyChallenge, "Static_ListBg")
  },
  _config = {
    _maxShowChallengeCount = 6,
    _maxItemSlotCount = 4,
    _maxSelectItemSlotCount = 6,
    _slotConfig = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createClassEquipBG = true,
      createCash = true
    },
    _challengeType = {
      benefit = -4,
      reward = -3,
      completed = -2,
      optionalCompleted = -1
    },
    _slotPos = {
      startPosX,
      startPosY,
      gapX = 10,
      gapY = 10
    }
  },
  _dataList = {},
  _completeGroupKeyList = {},
  _doneDataList = {},
  _selectItemData = {},
  _static_ItemSlotBg = {},
  _challengeList = {},
  _static_SelectRewardBg = {},
  _isInitialized = false,
  _dataIndex = 0
}
function dailyChallenge:initialize()
  dailyChallenge:resetData()
  dailyChallenge:initControl()
  dailyChallenge:addInputEvent()
  self._isInitialized = true
end
function dailyChallenge:initControl()
  local slotSizeX = self._ui._static_ListBg:GetSizeX()
  local slotSizeY = self._ui._static_ListBg:GetSizeY()
  self._config._slotPos.startPosX = self._ui._static_ListBg:GetPosX()
  self._config._slotPos.startPosY = self._ui._static_ListBg:GetPosY()
  self._ui._static_ListBg:SetShow(false)
  for slotIndex = 0, self._config._maxShowChallengeCount - 1 do
    local slotInfo = {}
    slotInfo.slotBG = UI.cloneControl(self._ui._static_ListBg, Panel_Window_DailyChallenge, "ChallengeSlot_" .. slotIndex)
    slotInfo.rewardBG = UI.getChildControl(slotInfo.slotBG, "Static_RewardBg")
    slotInfo.emptyIcon = UI.getChildControl(slotInfo.slotBG, "Static_EmptyIcon")
    slotInfo.slotBG:SetPosX(self._config._slotPos.startPosX + (slotSizeX + self._config._slotPos.gapX) * (slotIndex % 2))
    slotInfo.slotBG:SetPosY(self._config._slotPos.startPosY + (slotSizeY + self._config._slotPos.gapY) * math.floor(slotIndex / 2))
    slotInfo.slotBG:SetShow(true)
    self._challengeList[slotIndex] = slotInfo
  end
  for slotIndex = 0, self._config._maxShowChallengeCount - 1 do
    self._static_ItemSlotBg[slotIndex] = {}
    self._static_SelectRewardBg[slotIndex] = {}
    local itemSlotBG = self._static_ItemSlotBg[slotIndex]
    local selectItemSlotBG = self._static_SelectRewardBg[slotIndex]
    for index = 0, self._config._maxItemSlotCount - 1 do
      if nil == itemSlotBG[index] then
        local info = {}
        info.slotBG = UI.getChildControl(self._challengeList[slotIndex].rewardBG, "Static_ItemSlotBg" .. index)
        info.slotBG:SetShow(true)
        local slot = {}
        SlotItem.new(slot, "BaseReward_" .. slotIndex .. "_" .. index, index, info.slotBG, self._config._slotConfig)
        slot:createChild()
        slot.icon:SetSize(info.slotBG:GetSizeX(), info.slotBG:GetSizeY())
        slot.border:SetSize(info.slotBG:GetSizeX() + 1, info.slotBG:GetSizeY() + 1)
        slot.count:SetPosX(slot.count:GetPosX() + 3)
        slot.count:SetPosY(slot.count:GetPosY() + 2)
        info.slot = slot
        itemSlotBG[index] = info
      end
    end
    local _template_Static_SlotSelectBG = UI.getChildControl(self._challengeList[slotIndex].rewardBG, "Template_Static_SlotSelectBG")
    for index = 0, self._config._maxSelectItemSlotCount - 1 do
      if nil == selectItemSlotBG[index] then
        local info = {}
        info.slotBG = UI.getChildControl(self._challengeList[slotIndex].rewardBG, "Static_SelectRewardBg" .. index)
        info.slotBG:SetShow(true)
        local slot = {}
        SlotItem.new(slot, "SelectReward_" .. slotIndex .. "_" .. index, index, info.slotBG, self._config._slotConfig)
        slot:createChild()
        slot.icon:SetSize(info.slotBG:GetSizeX(), info.slotBG:GetSizeY())
        slot.border:SetSize(info.slotBG:GetSizeX(), info.slotBG:GetSizeY())
        slot.count:SetPosX(-10)
        slot.count:SetPosY(8)
        info.selectedSatic = UI.cloneControl(_template_Static_SlotSelectBG, info.slotBG, "SelectedSlot_" .. slotIndex .. "_" .. index)
        info.selectedSatic:SetShow(false)
        info.selectedSatic:SetIgnore(false)
        info.selectedSatic:SetPosX(-1)
        info.selectedSatic:SetPosY(-1)
        info.selectedSatic:SetSize(info.slotBG:GetSizeX(), info.slotBG:GetSizeY())
        info.slot = slot
        selectItemSlotBG[index] = info
      end
      selectItemSlotBG[index].selectedSatic:SetShow(false)
    end
  end
end
function dailyChallenge:addInputEvent()
  self._ui._button_Win_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_DailyChallenge_Close()")
end
function PaGlobalFunc_DailyChallenge_GetShow()
  return dailyChallenge:GetShow()
end
function dailyChallenge:GetShow()
  return Panel_Window_DailyChallenge:GetShow()
end
function FromClient_luaLoadComplete_DailyChallenge()
  dailyChallenge:initialize()
end
function dailyChallenge:resetData()
  self._selectItemData = {}
  self._doneDataList = {}
  self._dataList = {}
  self._completeGroupKeyList = {}
  self._dataIndex = 0
end
function PaGlobalFunc_DailyChallenge_Open()
  if true == _ContentsGroup_RenewUI then
    return
  end
  dailyChallenge:resetData()
  dailyChallenge:open()
end
function dailyChallenge:open()
  if true == Panel_Window_DailyChallenge:GetShow() then
    return
  end
  if true == _ContentsGroup_RenewUI then
    return
  end
  Panel_Window_DailyChallenge:SetShow(true)
  self:update()
end
function PaGlobalFunc_DailyChallenge_Close()
  dailyChallenge:close()
end
function dailyChallenge:close()
  Panel_Window_DailyChallenge:SetShow(false)
  if true == _ContentsGroup_NewUI_DailyStamp_All then
    PaGlobalFunc_DailyStamp_All_Open()
  else
    DailyStamp_ShowToggle()
  end
end
function dailyChallenge:pushDataList(challengeType, Index, optionalType, challengeKey)
  local challengeInfo = {}
  challengeInfo.challengeType = challengeType
  challengeInfo.dataIndex = Index
  challengeInfo.optionalType = optionalType
  challengeInfo.key = challengeKey
  table.insert(self._dataList, challengeInfo)
  self._completeGroupKeyList[optionalType] = true
end
function dailyChallenge:setCheckIconTexture(control, challnegeType)
  local eChallengeType = self._config._challengeType
  local x1, y1, x2, y2
  control:ChangeTextureInfoName("renewal/etc/console_etc_01.dds")
  if eChallengeType.optionalCompleted == challnegeType or eChallengeType.completed == challnegeType or eChallengeType.benefit == challnegeType then
    x1, y1, x2, y2 = setTextureUV_Func(control, 341, 1, 411, 71)
  elseif eChallengeType.reward == challnegeType then
    x1, y1, x2, y2 = setTextureUV_Func(control, 199, 1, 269, 71)
  else
    x1, y1, x2, y2 = setTextureUV_Func(control, 270, 1, 340, 71)
  end
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
  control:SetShow(true)
end
function dailyChallenge:setButtonState(control, challnegeType, dataIndex, existRewardCount)
  local eChallengeType = self._config._challengeType
  local challengeInfo = self._dataList[dataIndex]
  control:SetShow(true)
  control:SetEnable(false)
  control:SetMonoTone(false)
  control:SetFontColor(Defines.Color.C_FFEEEEEE)
  if eChallengeType.optionalCompleted == challnegeType then
    control:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_CHALLENGE_ACHIVED"))
  elseif eChallengeType.completed == challnegeType then
    control:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_CHALLENGE_ACHIVED"))
  elseif eChallengeType.benefit == challnegeType then
    control:SetEnable(true)
    control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_BTNGETREWARD", "existRewardCount", existRewardCount))
    control:addInputEvent("Mouse_LUp", "PaGlobalFunc_DailyChallenge_ReceiveReward(" .. dataIndex .. ")")
  elseif eChallengeType.reward == challnegeType then
    control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_BTNGETREWARD", "existRewardCount", existRewardCount))
    control:addInputEvent("Mouse_LUp", "PaGlobalFunc_DailyChallenge_ReceiveReward(" .. dataIndex .. ")")
    local isDone = false
    for _, data in pairs(self._doneDataList) do
      if data == tostring(challengeInfo.key) then
        isDone = true
      end
    end
    if false == isDone then
      control:SetEnable(true)
    else
      control:SetMonoTone(true)
    end
  else
    control:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_CHALLENGE_NOTACHIVED"))
    control:SetFontColor(Defines.Color.C_FFD20000)
    control:SetMonoTone(true)
  end
end
local tempTable
function dailyChallenge:update()
  local eChallengeType = self._config._challengeType
  local dataIndex = 0
  self._dataList = {}
  self._completeGroupKeyList = {}
  local totalCompleteCount = ToClient_GetCompletedChallengeCount()
  local rewardCompleteCount = ToClient_GetChallengeRewardInfoCount()
  local totalProgressCount = ToClient_GetProgressChallengeCount(1) + ToClient_GetProgressChallengeCount(2) + ToClient_GetProgressChallengeCount(3)
  self._ui._staticText_RewardCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_CHALLENGE_CLEARCOUNTTEXT") .. " : " .. totalCompleteCount .. " / " .. totalCompleteCount + totalProgressCount)
  local remainRewardCount = ToClient_GetChallengeRewardInfoCount()
  if remainRewardCount <= 0 then
    self._ui._staticText_UncollectedRewardCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_EMPTY"))
  else
    self._ui._staticText_UncollectedRewardCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_REWARDCOUNTVALUE_HAVE", "remainRewardCount", remainRewardCount))
  end
  local prevGroup = -1
  local rewardCompleteCount = ToClient_GetChallengeRewardInfoCount()
  for index = 0, rewardCompleteCount - 1 do
    local rewardWrapper = ToClient_GetChallengeRewardInfoWrapper(index)
    if nil ~= rewardWrapper and 0 < rewardWrapper:getOptionalType() and prevGroup ~= rewardWrapper:getOptionalType() then
      self:pushDataList(eChallengeType.reward, index, rewardWrapper:getOptionalType(), rewardWrapper:getKey():get())
      prevGroup = rewardWrapper:getOptionalType()
    end
  end
  prevGroup = -1
  for challengeType = 0, CppEnums.ChallengeType.eChallengeType_Count - 1 do
    if challengeType == CppEnums.ChallengeType.eChallengeType_Coupon then
    elseif isGameTypeRussia() and challengeType == 4 then
    elseif not isGameTypeRussia() and challengeType == 7 then
    else
      local controlValueCount = ToClient_GetProgressChallengeCount(challengeType)
      for index = 0, controlValueCount - 1 do
        local progressInfo = ToClient_GetProgressChallengeAt(challengeType, index)
        if nil ~= progressInfo and 0 < progressInfo:getOptionalType() and prevGroup ~= progressInfo:getOptionalType() then
          self:pushDataList(challengeType, index, progressInfo:getOptionalType(), progressInfo:getKey():get())
          prevGroup = progressInfo:getOptionalType()
        end
      end
    end
  end
  local completedCount = ToClient_GetCompletedChallengeCount()
  prevGroup = -1
  for index = 0, completedCount - 1 do
    local completedInfo = ToClient_GetCompletedChallengeAt(index)
    if nil ~= completedInfo and true ~= self._completeGroupKeyList[completedInfo:getOptionalType()] and 0 < completedInfo:getOptionalType() and prevGroup ~= completedInfo:getOptionalType() then
      self:pushDataList(eChallengeType.completed, index, completedInfo:getOptionalType(), completedInfo:getKey():get())
      prevGroup = completedInfo:getOptionalType()
    end
  end
  local optionalCompletedCount = ToClient_GetOptionalCompletedChallengeCount()
  prevGroup = -1
  for index = optionalCompletedCount - 1, 0, -1 do
    local completedInfo = ToClient_GetOptionalCompletedChallengeAt(index)
    if nil ~= completedInfo and true ~= self._completeGroupKeyList[completedInfo:getOptionalType()] and 0 < completedInfo:getOptionalType() and prevGroup ~= completedInfo:getOptionalType() then
      self:pushDataList(eChallengeType.optionalCompleted, index, completedInfo:getOptionalType(), completedInfo:getKey():get())
      prevGroup = completedInfo:getOptionalType()
    end
  end
  if 0 >= table.getn(self._dataList) then
    self:close()
    return
  end
  local sortByKeyFunction = function(a, b)
    return a.key < b.key
  end
  table.sort(self._dataList, sortByKeyFunction)
  local sortFunction = function(a, b)
    return a.optionalType > b.optionalType
  end
  table.sort(self._dataList, sortFunction)
  local UiIndex = 0
  tempTable = {}
  for index = 1, self._config._maxShowChallengeCount do
    self._challengeList[UiIndex].slotBG:SetShow(true)
    if nil == self._dataList[index] then
      self._challengeList[UiIndex].emptyIcon:SetShow(true)
      self._challengeList[UiIndex].rewardBG:SetShow(false)
    else
      self._challengeList[UiIndex].emptyIcon:SetShow(false)
      self._challengeList[UiIndex].rewardBG:SetShow(true)
    end
    self:createList(UiIndex, index)
    UiIndex = UiIndex + 1
  end
end
function dailyChallenge:createList(UiIndex, dataIndex)
  local control = self._challengeList[UiIndex].rewardBG
  local eChallengeType = self._config._challengeType
  local _staticText_RewardTitle = UI.getChildControl(control, "StaticText_RewardTitle")
  local _staticText_RewardDesc = UI.getChildControl(control, "StaticText_RewardDesc")
  local _static_Check = UI.getChildControl(control, "Static_Check")
  local _button_Receive = UI.getChildControl(control, "Button_Receive")
  local _template_Static_SlotSelectBG = UI.getChildControl(control, "Template_Static_SlotSelectBG")
  local challengeInfo = self._dataList[dataIndex]
  if nil == challengeInfo then
    return
  end
  local rewardInfo
  local rewardCount = 0
  if eChallengeType.optionalCompleted == challengeInfo.challengeType then
    rewardInfo = ToClient_GetOptionalCompletedChallengeAt(challengeInfo.dataIndex)
  elseif eChallengeType.completed == challengeInfo.challengeType then
    rewardInfo = ToClient_GetCompletedChallengeAt(challengeInfo.dataIndex)
  elseif eChallengeType.benefit == challengeInfo.challengeType then
    rewardInfo = ToClient_GetBenefitRewardInfoWrapper(challengeInfo.dataIndex)
    rewardCount = ToClient_GetBenefitRewardCountByOptionalType(rewardInfo:getOptionalType())
  elseif eChallengeType.reward == challengeInfo.challengeType then
    rewardInfo = ToClient_GetChallengeRewardInfoWrapper(challengeInfo.dataIndex)
    rewardCount = ToClient_GetChallengeRewardCountByOptionalType(rewardInfo:getOptionalType())
  else
    rewardInfo = ToClient_GetProgressChallengeAt(challengeInfo.challengeType, challengeInfo.dataIndex)
  end
  self:setCheckIconTexture(_static_Check, challengeInfo.challengeType)
  self:setButtonState(_button_Receive, challengeInfo.challengeType, dataIndex, rewardCount)
  local baseCount = rewardInfo:getBaseRewardCount()
  local selectCount = rewardInfo:getSelectRewardCount()
  _staticText_RewardTitle:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  _staticText_RewardTitle:SetText(rewardInfo:getName())
  if _staticText_RewardTitle:IsLimitText() then
    _staticText_RewardTitle:SetIgnore(false)
    tempTable[UiIndex] = {}
    tempTable[UiIndex].control = _static_Check
    tempTable[UiIndex].name = rewardInfo:getName()
    tempTable[UiIndex].desc = nil
    _staticText_RewardTitle:addInputEvent("Mouse_On", "PaGlobalFunc_DailyChallenge_RewardTooltipLimitedText(" .. UiIndex .. ", true)")
    _staticText_RewardTitle:addInputEvent("Mouse_Out", "PaGlobalFunc_DailyChallenge_RewardTooltipLimitedText(" .. UiIndex .. ", false)")
  else
    _staticText_RewardDesc:SetIgnore(true)
  end
  _staticText_RewardDesc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  _staticText_RewardDesc:setLineCountByLimitAutoWrap(3)
  _staticText_RewardDesc:SetText(rewardInfo:getDesc())
  _staticText_RewardDesc:SetTextSpan(_staticText_RewardDesc:GetTextSpan().x, (_staticText_RewardDesc:GetSizeY() - _staticText_RewardDesc:GetTextSizeY()) * 0.5)
  if _staticText_RewardDesc:IsLimitText() then
    _staticText_RewardDesc:SetIgnore(false)
    tempTable[UiIndex] = {}
    tempTable[UiIndex].control = _static_Check
    tempTable[UiIndex].name = rewardInfo:getName()
    tempTable[UiIndex].desc = rewardInfo:getDesc()
    _staticText_RewardDesc:addInputEvent("Mouse_On", "PaGlobalFunc_DailyChallenge_RewardTooltipLimitedText(" .. UiIndex .. ", true)")
    _staticText_RewardDesc:addInputEvent("Mouse_Out", "PaGlobalFunc_DailyChallenge_RewardTooltipLimitedText(" .. UiIndex .. ", false)")
  else
    _staticText_RewardDesc:SetIgnore(true)
  end
  local itemSlotBG = self._static_ItemSlotBg[UiIndex]
  for index = 0, self._config._maxItemSlotCount - 1 do
    if baseCount > index then
      local baseReward = rewardInfo:getBaseRewardAt(index)
      self:setSlotData(baseReward, itemSlotBG[index], dataIndex, index, true)
      itemSlotBG[index].slot.icon:SetShow(true)
    else
      itemSlotBG[index].slot.icon:SetShow(false)
    end
  end
  local selectItemSlotBG = self._static_SelectRewardBg[UiIndex]
  for index = 0, self._config._maxSelectItemSlotCount - 1 do
    local isSelectItem = self._selectItemData._dataIndex == dataIndex and self._selectItemData._slotIndex == index
    selectItemSlotBG[index].slot:clearItem()
    if selectCount > index then
      local selectReward = rewardInfo:getSelectRewardAt(index)
      selectItemSlotBG[index].slot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_DailyChallenge_SelectRewardItem(" .. dataIndex .. "," .. index .. ")")
      selectItemSlotBG[index].selectedSatic:SetShow(isSelectItem)
      self:setSlotData(selectReward, selectItemSlotBG[index], dataIndex, index, false)
    else
      selectItemSlotBG[index].slot.icon:addInputEvent("Mouse_LUp", "")
    end
  end
end
function PaGlobalFunc_DailyChallenge_RewardTooltipLimitedText(UiIndex, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == tempTable or nil == UiIndex or nil == tempTable[UiIndex] then
    return
  end
  TooltipSimple_Show(tempTable[UiIndex].control, tempTable[UiIndex].name, tempTable[UiIndex].desc)
end
function PaGlobalFunc_DailyChallenge_RewardTooltip()
  dailyChallenge:showTooltip()
end
function dailyChallenge:showTooltip()
  registTooltipControl(control, Panel_Tooltip_SimpleText)
end
function dailyChallenge:setSlotData(reward, slotControl, dataIndex, uiIndex, isbase)
  local uiSlot = slotControl.slot
  slotControl.slotBG:EraseAllEffect()
  uiSlot.icon:SetShow(true)
  if __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward:getItemEnchantKey()))
    uiSlot:setItemByStaticStatus(itemStatic, reward._itemCount)
    uiSlot._item = reward:getItemEnchantKey()
    uiSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_DailyChallenge_RewardTooltipShow( true, " .. dataIndex .. ", " .. uiIndex .. "," .. tostring(isbase) .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_DailyChallenge_RewardTooltipShow( false, " .. dataIndex .. ", " .. uiIndex .. "," .. tostring(isbase) .. " )")
    uiSlot.icon:setTooltipEventRegistFunc("PaGlobalFunc_DailyChallenge_RewardTooltipShow( true, " .. dataIndex .. ", " .. uiIndex .. "," .. tostring(isbase) .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
end
function PaGlobalFunc_DailyChallenge_SelectRewardItem(dataIndex, slotIndex)
  dailyChallenge:selectRewardItem(dataIndex, slotIndex)
  dailyChallenge:update()
end
function dailyChallenge:selectRewardItem(dataIndex, slotIndex)
  self._selectItemData = {}
  self._selectItemData._dataIndex = dataIndex
  self._selectItemData._slotIndex = slotIndex
end
function PaGlobalFunc_DailyChallenge_RewardTooltipShow(isShow, dataIndex, uiIndex, isBase)
  dailyChallenge:showRewardItemTooltip(isShow, dataIndex, uiIndex, isBase)
end
function dailyChallenge:showRewardItemTooltip(isShow, dataIndex, uiIndex, isBase)
  local rewardInfo = self._dataList[dataIndex]
  if nil == rewardInfo then
    return
  end
  local uiSlot
  local rewardType = "Dialog_QuestReward_Base"
  if true == isBase then
    uiSlot = self._static_ItemSlotBg[dataIndex - 1]
  else
    rewardType = "Dialog_QuestReward_Select"
    uiSlot = self._static_SelectRewardBg[dataIndex - 1]
  end
  if nil == uiSlot then
    return
  end
  Panel_Tooltip_Item_SetPosition(uiIndex, uiSlot[uiIndex].slot, rewardType)
  if true == isShow then
    Panel_Tooltip_Item_Show_GeneralStatic(uiIndex, rewardType, true)
  elseif false == isShow then
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobalFunc_DailyChallenge_ReceiveReward(dataIndex)
  dailyChallenge:receiveReward(dataIndex)
end
function dailyChallenge:receiveReward(dataIndex)
  local eChallengeType = self._config._challengeType
  local challengeInfo = self._dataList[dataIndex]
  if eChallengeType.reward ~= challengeInfo.challengeType and eChallengeType.benefit ~= challengeInfo.challengeType then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGINFOCHALLENGE"))
    return
  end
  local challengeWrapper
  if eChallengeType.reward == challengeInfo.challengeType then
    challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(challengeInfo.dataIndex)
  else
    challengeWrapper = ToClient_GetBenefitRewardInfoWrapper(challengeInfo.dataIndex)
  end
  local selectRewardCount = challengeWrapper:getSelectRewardCount()
  if 0 ~= selectRewardCount and (nil == self._selectItemData._dataIndex or nil == self._selectItemData._slotIndex) then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_YOUCANSELECTITEM"))
    return
  end
  if nil == challengeWrapper then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGINFOCHALLENGE"))
    return
  end
  if 0 ~= selectRewardCount and selectRewardCount - 1 < self._selectItemData._slotIndex then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE"))
    return
  end
  if nil == self._selectItemData._slotIndex then
    self._selectItemData._slotIndex = 0
  end
  local challengeKey = challengeWrapper:getKey()
  ToClient_AcceptReward_ButtonClicked(challengeKey, self._selectItemData._slotIndex)
  if 1 >= challengeWrapper:getRewardCount() then
    table.insert(self._doneDataList, tostring(challengeKey:get()))
  end
  self._selectItemData = {}
  self:update()
end
function FromClient_DailyChallenge_UpdateText()
  if false == dailyChallenge._isInitialized then
    return
  end
  if false == Panel_Window_DailyChallenge:GetShow() then
    return
  end
  dailyChallenge:update()
end
function FromClient_DailyChallenge_Update()
  if false == dailyChallenge._isInitialized then
    return
  end
  if nil ~= PaGlobalFunc_DailyStamp_GetShowPanel and PaGlobalFunc_DailyStamp_GetShowPanel() then
    PaGlobalFunc_DailyStamp_SetShowPanel(false, false)
  end
  if false == ToClient_isConsole() and nil ~= PaGlobalFunc_IsDailyChallengeShow and false == PaGlobalFunc_IsDailyChallengeShow() then
    return
  end
  if true == ToClient_isConsole() and false == PaGlobalFunc_DailyStamp_IsDailyChallengeShow() then
    return
  end
  dailyChallenge:open()
end
function FromClient_DailyChallengeAll_Update()
  if false == dailyChallenge._isInitialized then
    return
  end
  if nil ~= PaGlobalFunc_DailyStamp_GetShow and true == PaGlobalFunc_DailyStamp_GetShow() then
    PaGlobalFunc_DailyStamp_Close()
  end
  if nil ~= PaGlobalFunc_IsDailyChallengeShow and false == PaGlobalFunc_IsDailyChallengeShow() then
    return
  end
  if nil ~= PaGlobalFunc_DailyStamp_IsDailyChallengeShow and false == PaGlobalFunc_DailyStamp_IsDailyChallengeShow() then
    return
  end
  dailyChallenge:open()
end
function dailyChallenge:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DailyChallenge")
  registerEvent("FromClient_ChallengeReward_UpdateText", "FromClient_DailyChallenge_UpdateText")
  registerEvent("FromClient_AttendanceUpdate", "FromClient_DailyChallenge_Update")
  registerEvent("FromClient_AttendanceUpdateAll", "FromClient_DailyChallengeAll_Update")
end
dailyChallenge:registEventHandler()
