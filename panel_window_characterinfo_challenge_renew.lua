local _mainPanel = Panel_Window_CharacterInfo_Renew
local _panel = Panel_Window_CharacterInfo_Challenge_Renew
local CHALLENGE_TYPE = CppEnums.ChallengeType
local CATEGORY_TYPE = {
  SHORT = 1,
  DAILY = 2,
  EVENT = 3,
  COMPLETE = 4,
  COMPLETE_GETITEM = 5
}
local CATEGORY_TO_CHALLENGE_TYPE = {
  [CATEGORY_TYPE.SHORT] = CHALLENGE_TYPE.eChallengeType_Event,
  [CATEGORY_TYPE.DAILY] = CHALLENGE_TYPE.eChallengeType_ShortTerm,
  [CATEGORY_TYPE.EVENT] = CHALLENGE_TYPE.eChallengeType_LongTerm,
  [CATEGORY_TYPE.COMPLETE] = nil,
  [CATEGORY_TYPE.COMPLETE_GETITEM] = nil
}
local CharacterChallengeInfo = {
  _ui = {
    stc_CategoryTap = UI.getChildControl(_panel, "Static_Category_Tap"),
    list2 = UI.getChildControl(_panel, "List2_Challenges"),
    list2_Scroll = nil
  },
  _slotsGroup = {},
  _currentCategoryType = CATEGORY_TYPE.SHORT,
  _currentListKey = nil,
  _currentRewardItem = 1,
  _maxCategoryType = nil,
  _baseRewardSlotGap = 75,
  _selectRewardSlotGap = 51,
  _rewardTable = {},
  _baseRewardSlotCount = 5,
  _selectRewardSlotCount = 7
}
local challengeRewardSlotConfig = {
  createIcon = false,
  createBorder = false,
  createCount = false,
  createClassEquipBG = false,
  createCash = false
}
local self = CharacterChallengeInfo
function CharacterChallengeInfo:init()
  self._ui.stc_LT = UI.getChildControl(self._ui.stc_CategoryTap, "Static_LT_ConsoleUI")
  self._ui.stc_LT:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterChallengeInfo_ShowLeftNextTab()")
  self._ui.stc_RT = UI.getChildControl(self._ui.stc_CategoryTap, "Static_RT_ConsoleUI")
  self._ui.stc_RT:addInputEvent("Mouse_LUp", "PaGlobalFunc_CharacterChallengeInfo_ShowRightNextTab()")
  self._ui.list2_Scroll = UI.getChildControl(self._ui.list2, "List2_1_VerticalScroll")
  self._ui.rdo_tabs = {}
  local rdo = self._ui.rdo_tabs
  rdo[CATEGORY_TYPE.SHORT] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Object")
  rdo[CATEGORY_TYPE.SHORT]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_SHORT"))
  rdo[CATEGORY_TYPE.DAILY] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Time")
  rdo[CATEGORY_TYPE.DAILY]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_DAILY"))
  rdo[CATEGORY_TYPE.EVENT] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Event")
  rdo[CATEGORY_TYPE.EVENT]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_EVENT"))
  rdo[CATEGORY_TYPE.COMPLETE] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Pre_Complete")
  rdo[CATEGORY_TYPE.COMPLETE]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_COMPLETE"))
  rdo[CATEGORY_TYPE.COMPLETE_GETITEM] = UI.getChildControl(self._ui.stc_CategoryTap, "RadioButton_Complete")
  rdo[CATEGORY_TYPE.COMPLETE_GETITEM]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_TAPMENU_COMPLETEGETITEM"))
  self._maxCategoryType = #rdo
  for ii = 1, self._maxCategoryType do
    rdo[ii]:addInputEvent("Mouse_LUp", "InputMLUp_CharacterChallengeInfo_TapToOpen(" .. ii .. ")")
    rdo[ii]:SetShow(true)
    rdo[ii]:SetPosX(200 + (ii - 1) * 170)
  end
  self._ui.static_bottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.static_bottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.static_bottomBg, "StaticText_X_ConsoleUI")
  self._ui.txt_keyGuideB = PaGlobalFunc_CharacterInfo_GetKeyGuideB()
  self.keyGuideBtnGroup = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideX,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, self._ui.static_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_CharacterChallengeInfo_ListContent")
  self._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
local _slotInitialized = false
function CharacterChallengeInfo:updateData(categoryReq)
  if nil ~= categoryReq then
    self._currentCategoryType = categoryReq
  end
  for ii = 1, #self._ui.rdo_tabs do
    self._ui.rdo_tabs[ii]:SetFontColor(Defines.Color.C_FF9397A7)
  end
  self._ui.rdo_tabs[self._currentCategoryType]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.list2:getElementManager():clearKey()
  self:updateDataInCurrentChallengeList()
end
function CharacterChallengeInfo:updateDataInCurrentChallengeList()
  local count
  local challengeType = CATEGORY_TO_CHALLENGE_TYPE[self._currentCategoryType]
  if CATEGORY_TYPE.COMPLETE == self._currentCategoryType then
    count = ToClient_GetCompletedChallengeCount()
  elseif CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType then
    count = ToClient_GetChallengeRewardInfoCount()
  else
    count = ToClient_GetProgressChallengeCount(challengeType)
  end
  if count < 1 then
    _PA_LOG("\235\176\149\235\178\148\236\164\128", "updateDataInCurrentChallengeList, count : " .. count .. " at " .. self._currentCategoryType)
    return
  end
  for ii = 1, count do
    local challengeWrapper
    if CATEGORY_TYPE.COMPLETE == self._currentCategoryType then
      challengeWrapper = ToClient_GetCompletedChallengeAt(ii - 1)
    elseif CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType then
      challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(ii - 1)
    else
      challengeWrapper = ToClient_GetProgressChallengeAt(challengeType, ii - 1)
    end
    if nil ~= challengeWrapper then
      self._ui.list2:getElementManager():pushKey(toInt64(0, ii))
    end
  end
end
function PaGlobalFunc_CharacterChallengeInfo_ListContent(content, key)
  local key32 = Int64toInt32(key)
  local stc_BG = UI.getChildControl(content, "Static_Reward_BG")
  local txt_title = UI.getChildControl(stc_BG, "StaticText_Title")
  local txt_desc = UI.getChildControl(stc_BG, "StaticText_Desc")
  _originalSpanSizeY = 20
  txt_title:SetTextMode(CppEnums.TextMode.eTextMode_None)
  txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  txt_desc:setLineCountByLimitAutoWrap(3)
  local stc_btnGroup = UI.getChildControl(stc_BG, "Static_ButtonGroup")
  local btn_receive = UI.getChildControl(stc_btnGroup, "Button_Receive")
  stc_btnGroup:SetShow(CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType)
  btn_receive:addInputEvent("Mouse_LUp", "InputMLUp_CharacterChallengeInfo_ReceiveBtn(" .. key32 .. ")")
  btn_receive:addInputEvent("Mouse_On", "InputMOn_CharacterChallengeInfo_ReceiveBtn()")
  local stc_rewardArea = UI.getChildControl(stc_BG, "Static_RewardArea")
  local stc_baseSlotBG = {}
  for ii = 1, self._baseRewardSlotCount do
    stc_baseSlotBG[ii] = UI.getChildControl(stc_rewardArea, "Static_Basic_Item" .. ii - 1)
    stc_baseSlotBG[ii]:SetPosX((ii - 1) * 50)
  end
  local stc_selectSlotBG = {}
  for ii = 1, self._selectRewardSlotCount do
    stc_selectSlotBG[ii] = UI.getChildControl(stc_rewardArea, "Static_Select_Item" .. ii - 1)
    stc_selectSlotBG[ii]:SetPosX((ii - 1) * 50)
  end
  local index
  local id = content:GetID()
  local tailStart = math.max(string.len(id) - 8, 6)
  local tail = string.sub(id, tailStart, string.len(id))
  local numStart, numEnd = string.find(tail, "%d+")
  if nil ~= numStart then
    index = tonumber(string.sub(tail, numStart, numEnd))
  end
  for ii = 1, #stc_baseSlotBG do
    if nil == self._slotsGroup[index] then
      self._slotsGroup[index] = {}
    end
    if nil == self._slotsGroup[index][ii] then
      self._slotsGroup[index][ii] = {}
      self._slotsGroup[index][ii].icon = UI.getChildControl(stc_baseSlotBG[ii], "Static_Icon")
      self._slotsGroup[index][ii].border = UI.getChildControl(self._slotsGroup[index][ii].icon, "Static_Border")
      self._slotsGroup[index][ii].count = UI.getChildControl(self._slotsGroup[index][ii].icon, "StaticText_Count")
      self._slotsGroup[index][ii].classEquipBG = UI.getChildControl(self._slotsGroup[index][ii].icon, "Static_ClassEquipBG")
      self._slotsGroup[index][ii].isCash = UI.getChildControl(self._slotsGroup[index][ii].icon, "Static_Cash")
      SlotItem.new(self._slotsGroup[index][ii], "Slot_BaseReward_" .. index .. "_" .. ii, nil, stc_baseSlotBG[ii], challengeRewardSlotConfig)
    end
    self._slotsGroup[index][ii]:clearItem()
  end
  for ii = 1, #stc_selectSlotBG do
    if nil == self._slotsGroup[index] then
      self._slotsGroup[index] = {}
    end
    local alterii = ii + self._baseRewardSlotCount
    if nil == self._slotsGroup[index][alterii] then
      self._slotsGroup[index][alterii] = {}
      self._slotsGroup[index][alterii].icon = UI.getChildControl(stc_selectSlotBG[ii], "Static_Icon")
      self._slotsGroup[index][alterii].border = UI.getChildControl(self._slotsGroup[index][alterii].icon, "Static_Border")
      self._slotsGroup[index][alterii].count = UI.getChildControl(self._slotsGroup[index][alterii].icon, "StaticText_Count")
      self._slotsGroup[index][alterii].classEquipBG = UI.getChildControl(self._slotsGroup[index][alterii].icon, "Static_ClassEquipBG")
      self._slotsGroup[index][alterii].isCash = UI.getChildControl(self._slotsGroup[index][alterii].icon, "Static_Cash")
      SlotItem.new(self._slotsGroup[index][alterii], "Slot_SelectReward_" .. index .. "_" .. alterii, nil, stc_selectSlotBG[ii], challengeRewardSlotConfig)
      self._slotsGroup[index][alterii].icon:SetSize(self._slotsGroup[index][alterii].icon:GetSizeX() - 4, self._slotsGroup[index][alterii].icon:GetSizeY() - 4)
    end
    self._slotsGroup[index][alterii]:clearItem()
  end
  self._rewardTable[key32] = {}
  local challengeWrapper
  if CATEGORY_TYPE.COMPLETE == self._currentCategoryType then
    challengeWrapper = ToClient_GetCompletedChallengeAt(key32 - 1)
  elseif CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType then
    challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(key32 - 1)
  else
    local challengeType = CATEGORY_TO_CHALLENGE_TYPE[self._currentCategoryType]
    challengeWrapper = ToClient_GetProgressChallengeAt(challengeType, key32 - 1)
  end
  if nil ~= challengeWrapper then
    if CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType then
      local existRewardCount = 0
      if 0 == challengeWrapper:getOptionalType() then
        existRewardCount = challengeWrapper:getRewardCount()
      else
        existRewardCount = ToClient_GetChallengeRewardCountByOptionalType(challengeWrapper:getOptionalType())
      end
      local receiveText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGE_BTNGETREWARD", "existRewardCount", existRewardCount)
      if 1 == existRewardCount then
        local posToCut = string.find(receiveText, "1") - 2
        receiveText = string.sub(receiveText, 1, posToCut)
      end
      btn_receive:SetText(receiveText)
    end
    txt_desc:SetText(challengeWrapper:getDesc())
    txt_title:SetText(challengeWrapper:getName())
    if txt_title:GetSizeX() < txt_title:GetTextSizeX() then
      txt_title:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      txt_title:setLineCountByLimitAutoWrap(2)
      txt_title:SetSpanSize(txt_title:GetSpanSize().x, _originalSpanSizeY + 15)
    else
      txt_title:SetTextMode(CppEnums.TextMode.eTextMode_None)
      txt_title:SetSpanSize(txt_title:GetSpanSize().x, _originalSpanSizeY)
    end
    txt_title:SetText(challengeWrapper:getName())
    local baseRewardCount = challengeWrapper:getBaseRewardCount()
    for ii = 1, #stc_baseSlotBG do
      stc_baseSlotBG[ii]:addInputEvent("Mouse_On", "InputMOn_CharacterChallengeInfo_SelectItem(" .. key32 .. "," .. ii .. ")")
      stc_baseSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
      stc_baseSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
      local slot = self._slotsGroup[index][ii]
      slot:clearItem()
      if ii <= baseRewardCount then
        local baseReward = challengeWrapper:getBaseRewardAt(ii - 1)
        if nil ~= baseReward then
          self._rewardTable[key32][ii] = {}
          local bData = self._rewardTable[key32][ii]
          bData._type = baseReward._type
          if __eRewardExp == baseReward._type then
            bData._exp = baseReward._experience
          elseif __eRewardSkillExp == baseReward._type then
            bData._exp = baseReward._skillExperience
          elseif __eRewardLifeExp == baseReward._type then
            bData._exp = baseReward._productExperience
          elseif __eRewardItem == baseReward._type then
            bData._item = baseReward:getItemEnchantKey()
            bData._count = baseReward._itemCount
            local selfPlayer = getSelfPlayer()
            if nil ~= selfPlayer then
              local classType = selfPlayer:getClassType()
              bData._isEquipable = baseReward:isEquipable(classType)
            end
          elseif __eRewardIntimacy == baseReward._type then
            bData._character = baseReward:getIntimacyCharacter()
            bData._value = baseReward._intimacyValue
          end
          stc_baseSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputPadX_CharacterChallengeInfo_ShowTooltip(" .. key32 .. "," .. ii .. ")")
          self:setChallengeRewardShow(slot, bData, index, ii)
        end
      end
    end
    local selectRewardCount = challengeWrapper:getSelectRewardCount()
    for ii = 1, #stc_selectSlotBG do
      local alterii = ii + #stc_baseSlotBG
      stc_selectSlotBG[ii]:addInputEvent("Mouse_On", "InputMOn_CharacterChallengeInfo_SelectItem(" .. key32 .. "," .. alterii .. ")")
      stc_selectSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
      stc_selectSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
      local slot = self._slotsGroup[index][alterii]
      slot:clearItem()
      if ii <= selectRewardCount then
        local selectReward = challengeWrapper:getSelectRewardAt(ii - 1)
        if nil ~= selectReward then
          self._rewardTable[key32][alterii] = {}
          local sData = self._rewardTable[key32][alterii]
          sData._type = selectReward._type
          if __eRewardExp == selectReward._type then
            sData._exp = selectReward._experience
          elseif __eRewardSkillExp == selectReward._type then
            sData._exp = selectReward._skillExperience
          elseif __eRewardLifeExp == selectReward._type then
            sData._exp = selectReward._productExperience
          elseif __eRewardItem == selectReward._type then
            sData._item = selectReward:getItemEnchantKey()
            sData._count = selectReward._itemCount
            local selfPlayer = getSelfPlayer()
            if nil ~= selfPlayer then
              local classType = selfPlayer:getClassType()
              sData._isEquipable = selectReward:isEquipable(classType)
            end
          elseif __eRewardIntimacy == selectReward._type then
            sData._character = selectReward:getIntimacyCharacter()
            sData._value = selectReward._intimacyValue
          end
          stc_selectSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputPadX_CharacterChallengeInfo_ShowTooltip(" .. key32 .. "," .. alterii .. ")")
          stc_selectSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputPadA_CharacterChallengeInfo_SelectItem(" .. key32 .. "," .. alterii .. ")")
          self:setChallengeRewardShow(slot, sData, index, alterii)
        end
      end
    end
  end
  local stc_selectHighlight = UI.getChildControl(stc_rewardArea, "Static_SelectHighlight")
  stc_selectHighlight:SetShow(false)
  if key32 == self._currentListKey and nil ~= self._currentRewardItem and self._baseRewardSlotCount < self._currentRewardItem then
    stc_selectHighlight:SetShow(true)
    stc_selectHighlight:SetPosX(self._slotsGroup[index][self._currentRewardItem].icon:getParent():GetPosX())
    stc_selectHighlight:SetPosY(self._slotsGroup[index][self._currentRewardItem].icon:getParent():GetPosY())
  end
end
function InputMOn_CharacterChallengeInfo_SelectList(key32)
end
function InputMOn_CharacterChallengeInfo_SelectItem(key32, itemIndex)
  local self = CharacterChallengeInfo
  local prevIndex = self._currentListKey
  self._currentListKey = key32
  if nil ~= prevIndex then
    if prevIndex ~= self._currentListKey then
      self._currentRewardItem = nil
    end
    self._ui.list2:requestUpdateByKey(toInt64(0, prevIndex))
  end
  self._ui.list2:requestUpdateByKey(toInt64(0, self._currentListKey))
  if itemIndex > self._baseRewardSlotCount then
    self._ui.txt_keyGuideA:SetShow(true)
  else
    self._ui.txt_keyGuideA:SetShow(false)
  end
  if nil == self._rewardTable[key32] or nil == self._rewardTable[key32][itemIndex] or nil == self._rewardTable[key32][itemIndex]._type or __eRewardItem ~= self._rewardTable[key32][itemIndex]._type then
    self._ui.txt_keyGuideX:SetShow(false)
  else
    self._ui.txt_keyGuideX:SetShow(true)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, self._ui.static_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function InputPadX_CharacterChallengeInfo_ShowTooltip(key32, itemIndex)
  local self = CharacterChallengeInfo
  if nil == self._rewardTable[key32] or nil == self._rewardTable[key32][itemIndex] then
    return
  end
  local slot = self._rewardTable[key32][itemIndex]
  if __eRewardExp == slot._type then
  elseif __eRewardSkillExp == slot._type then
  elseif __eRewardLifeExp == slot._type then
  elseif __eRewardIntimacy == slot._type then
  elseif __eRewardItem == slot._type then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(slot._item))
    if nil ~= itemSSW then
      PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemWithoutCompare, 0)
    end
  end
end
function InputPadA_CharacterChallengeInfo_SelectItem(key32, itemIndex)
  local self = CharacterChallengeInfo
  self._currentRewardItem = itemIndex
  self._currentListKey = key32
  self._ui.list2:requestUpdateByKey(toInt64(0, key32))
  self:setScroll()
end
function CharacterChallengeInfo:setScroll(isSelected)
  local self = CharacterChallengeInfo
  local toIndex = 0
  local scrollvalue = 0
  toIndex = self._ui.list2:getCurrenttoIndex()
  if isSelected then
    toIndex = math.floor(toIndex)
  end
  if false == self._ui.list2:IsIgnoreVerticalScroll() then
    scrollvalue = self._ui.list2_Scroll:GetControlPos()
  end
  self:updateData()
  self._ui.list2:setCurrenttoIndex(toIndex)
  if false == self._ui.list2:IsIgnoreVerticalScroll() then
    self._ui.list2_Scroll:SetControlPos(scrollvalue)
  end
end
function InputMLUp_CharacterChallengeInfo_ReceiveBtn(key32)
  local self = CharacterChallengeInfo
  local choosenRewardIndex
  if nil ~= self._currentRewardItem then
    choosenRewardIndex = self._currentRewardItem - self._baseRewardSlotCount - 1
  end
  local challengeWrapper = ToClient_GetChallengeRewardInfoWrapper(key32 - 1)
  local selectRewardCount = challengeWrapper:getSelectRewardCount()
  if 0 ~= selectRewardCount and nil == choosenRewardIndex then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_YOUCANSELECTITEM"))
    return
  end
  if nil == challengeWrapper then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGINFOCHALLENGE"))
    return
  end
  if 0 ~= selectRewardCount and choosenRewardIndex > selectRewardCount then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE"))
    return
  end
  if self._currentListKey ~= key32 and 0 ~= selectRewardCount then
    Proc_ShowMessage_Ack_WithOut_ChattingMessage(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_WRONGSELECTVALUE"))
    return
  end
  if 0 == selectRewardCount or nil == choosenRewardIndex then
    choosenRewardIndex = selectRewardCount
  end
  local challengeKey = challengeWrapper:getKey()
  ToClient_AcceptReward_ButtonClicked(challengeKey, choosenRewardIndex)
end
function InputMOn_CharacterChallengeInfo_ReceiveBtn()
  local self = CharacterChallengeInfo
  self._ui.txt_keyGuideA:SetShow(true)
  self._ui.txt_keyGuideX:SetShow(false)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self.keyGuideBtnGroup, self._ui.static_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function CharacterChallengeInfo:setChallengeRewardShow(uiSlot, reward, uiIdx, index)
  uiSlot._type = reward._type
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    if nil ~= itemStatic then
      uiSlot:setItemByStaticStatus(itemStatic, reward._count)
      uiSlot._item = reward._item
    else
      _PA_LOG("\235\176\149\235\178\148\236\164\128", "item SSW is nil at uiIdx " .. uiIdx .. ", index " .. index .. ", reward._item : " .. reward._item)
    end
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  return false
end
function CharacterChallengeInfo:showTooltip(type, show, questtype, index, uiIdx)
  if true == show then
    local text = ""
    if __eRewardExp == slot._type then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP")
    elseif __eRewardSkillExp == slot._type then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP")
    elseif __eRewardLifeExp == slot._type then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP")
    else
      if __eRewardIntimacy == slot._type then
        text = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY")
      else
      end
    end
  else
  end
end
function Challenge_RewardItemTooltipShow_Renew(isShow, uiIdx, slotNo, rewardType)
end
function InputMLUp_CharacterChallengeInfo_TapToOpen(index)
  local self = CharacterChallengeInfo
  self._currentCategoryType = index
  self:updateData()
end
function PaGlobalFunc_SetCharacterChallengeInfoReward()
  if nil == CharacterChallengeInfo then
    return
  end
  local self = CharacterChallengeInfo
  self._currentCategoryType = CATEGORY_TYPE.COMPLETE_GETITEM
  self:updateData()
end
function PaGlobalFunc_CharacterChallengeInfo_UpdateData()
  if nil == CharacterChallengeInfo then
    return
  end
  local self = CharacterChallengeInfo
  self._currentRewardItem = nil
  self:setScroll(true)
end
function CharacterChallengeInfo:registEvent()
  registerEvent("FromClient_ChallengeReward_UpdateText", "PaGlobalFunc_CharacterChallengeInfo_UpdateData")
end
function FromClient_luaLoadComplete_Panel_Window_Character_ChallengeInfo()
  local self = CharacterChallengeInfo
  self:init()
  self.defaultFrameBG_CharacterInfo_Challenge = UI.getChildControl(_mainPanel, "Static_ChallengeInfoBg")
  self.defaultFrameBG_CharacterInfo_Challenge:SetShow(false)
  self.defaultFrameBG_CharacterInfo_Challenge:MoveChilds(self.defaultFrameBG_CharacterInfo_Challenge:GetID(), _panel)
  deletePanel(_panel:GetID())
  self:registEvent()
  self:updateData(CATEGORY_TYPE.SHORT)
end
function PaGlobalFunc_CharacterChallengeInfo_ShowRightNextTab()
  local self = CharacterChallengeInfo
  self:ShowNextTab(false)
end
function PaGlobalFunc_CharacterChallengeInfo_ShowLeftNextTab()
  local self = CharacterChallengeInfo
  self:ShowNextTab(true)
end
function CharacterChallengeInfo:ShowNextTab(isLeft)
  if true == isLeft then
    if 1 == self._currentCategoryType then
      self._currentCategoryType = self._maxCategoryType
    else
      self._currentCategoryType = self._currentCategoryType - 1
    end
  elseif self._maxCategoryType == self._currentCategoryType then
    self._currentCategoryType = 1
  else
    self._currentCategoryType = self._currentCategoryType + 1
  end
  self._currentRewardItem = nil
  self._ui.txt_keyGuideA:SetShow(CATEGORY_TYPE.COMPLETE_GETITEM == self._currentCategoryType)
  PaGlobalFunc_TooltipInfo_Close()
  self:updateData()
end
function PaGlobalFunc_CharacterChallengeInfoTab_PadControl(index)
  self = CharacterChallengeInfo
  if 0 == index then
    self:ShowNextTab(true)
  else
    self:ShowNextTab(false)
  end
  ToClient_padSnapResetControl()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_Character_ChallengeInfo")
