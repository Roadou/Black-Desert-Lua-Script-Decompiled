local _panel = Panel_Window_Achievement
local TAB_TYPE = {FAMILY = 1, CHARACTER = 2}
local Achievement = {
  _ui = {
    btn_close = UI.getChildControl(_panel, "Button_Win_Close"),
    _stc_bottomArea = UI.getChildControl(_panel, "Static_BottomArea"),
    _stc_addEffect = UI.getChildControl(_panel, "Static_addEffect"),
    _stc_mainBG = nil,
    _txt_desc = nil,
    _btn_reward = nil,
    _stc_mainBG2 = nil,
    _txt_desc_2 = nil,
    _txt_desc2_2 = nil,
    _btn_reward2 = nil,
    _stc_stamp = nil,
    _stc_stamp2 = nil
  },
  _nextPageXSize = 0,
  _isBookType = 748,
  _descText = {},
  _descText2 = {},
  _questInfo = {},
  _currentIndex = 1,
  _questInfoCount = 0,
  _nationKoreaCheck = true,
  _gapSize = 22
}
function FromClient_luaLoadComplete_Achievement()
  Achievement:initialize()
end
function Achievement:initialize()
  self._ui._btn_bottomArea_Previous = UI.getChildControl(self._ui._stc_bottomArea, "Button_Previous")
  self._ui._btn_bottomArea_Preview = UI.getChildControl(self._ui._stc_bottomArea, "Button_Preview")
  self._ui._stc_mainBG = UI.getChildControl(_panel, "Static_Template_ListBG")
  self._ui._stc_leftBg = UI.getChildControl(self._ui._stc_mainBG, "Static_LeftBg")
  if false == self._nationKoreaCheck then
    self._ui._frm_frame = UI.getChildControl(self._ui._stc_leftBg, "Frame_1")
    self._ui._frm_frameContent = self._ui._frm_frame:GetFrameContent()
    self._ui._frm_vScroll = self._ui._frm_frame:GetVScroll()
    self._ui._txt_frameText = UI.getChildControl(self._ui._frm_frameContent, "StaticText_1")
    self._ui._txt_descTitle_Date = UI.getChildControl(self._ui._frm_frameContent, "StaticText_DescTitle_Date")
  else
    self._ui._txt_descTitle_Date = UI.getChildControl(self._ui._stc_mainBG, "StaticText_DescTitle_Date")
  end
  self._ui._txt_desc = UI.getChildControl(self._ui._stc_mainBG, "StaticText_AchievementDesc")
  self._ui._txt_desc2 = UI.getChildControl(self._ui._stc_mainBG, "StaticText_AchievementDesc2")
  self._ui._stc_rightBG = UI.getChildControl(self._ui._stc_mainBG, "Static_RightBg")
  self._ui._btn_reward = UI.getChildControl(self._ui._stc_rightBG, "Button_Reward")
  self._ui._txt_reward = UI.getChildControl(self._ui._stc_rightBG, "StaticText_RewardText")
  self._ui._stc_stamp = UI.getChildControl(self._ui._btn_reward, "Static_Stamp")
  self._ui._stc_questImage = UI.getChildControl(self._ui._stc_rightBG, "Static_Image")
  self._ui._stc_objectiveBG = UI.getChildControl(self._ui._stc_rightBG, "Static_ObjectiveBG")
  self._ui._stc_leftWing = UI.getChildControl(self._ui._stc_rightBG, "Static_Right")
  self._ui._stc_rightWing = UI.getChildControl(self._ui._stc_rightBG, "Static_Left")
  self._ui._txt_objective = UI.getChildControl(self._ui._stc_objectiveBG, "StaticText_Objective")
  self._ui._txt_objectiveCheckIcon = UI.getChildControl(self._ui._stc_objectiveBG, "Static_ObjectiveCheckIcon")
  self._ui._stc_mainBG2 = UI.getChildControl(_panel, "Static_Template_ListBG2")
  self._ui._stc_leftBg2 = UI.getChildControl(self._ui._stc_mainBG2, "Static_LeftBg")
  if false == self._nationKoreaCheck then
    self._ui._frm_frame2 = UI.getChildControl(self._ui._stc_leftBg2, "Frame_1")
    self._ui._frm_frameContent2 = self._ui._frm_frame2:GetFrameContent()
    self._ui._frm_vScroll2 = self._ui._frm_frame2:GetVScroll()
    self._ui._txt_frameText2 = UI.getChildControl(self._ui._frm_frameContent2, "StaticText_1")
    self._ui._txt_descTitle_Date2 = UI.getChildControl(self._ui._frm_frameContent2, "StaticText_DescTitle_Date")
  else
    self._ui._txt_descTitle_Date2 = UI.getChildControl(self._ui._stc_mainBG2, "StaticText_DescTitle_Date")
  end
  self._ui._txt_desc_2 = UI.getChildControl(self._ui._stc_mainBG2, "StaticText_AchievementDesc")
  self._ui._txt_desc2_2 = UI.getChildControl(self._ui._stc_mainBG2, "StaticText_AchievementDesc2")
  self._ui._stc_rightBG2 = UI.getChildControl(self._ui._stc_mainBG2, "Static_RightBg")
  self._ui._btn_reward2 = UI.getChildControl(self._ui._stc_rightBG2, "Button_Reward")
  self._ui._txt_reward2 = UI.getChildControl(self._ui._stc_rightBG2, "StaticText_RewardText")
  self._ui._stc_stamp2 = UI.getChildControl(self._ui._btn_reward2, "Static_Stamp")
  self._ui._stc_questImage2 = UI.getChildControl(self._ui._stc_rightBG2, "Static_Image")
  self._ui._stc_objectiveBG2 = UI.getChildControl(self._ui._stc_rightBG2, "Static_ObjectiveBG")
  self._ui._txt_objective2 = UI.getChildControl(self._ui._stc_objectiveBG2, "StaticText_Objective")
  self._ui._txt_objectiveCheckIcon2 = UI.getChildControl(self._ui._stc_objectiveBG, "Static_ObjectiveCheckIcon")
  self._ui._txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_desc2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_desc_2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_desc2_2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._btn_reward:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._btn_reward2:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._txt_reward:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._txt_reward2:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._txt_objective:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._txt_objective2:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  self._ui._btn_reward:setLineCountByLimitAutoWrap(2)
  self._ui._btn_reward2:setLineCountByLimitAutoWrap(2)
  self._ui._txt_reward:setLineCountByLimitAutoWrap(2)
  self._ui._txt_reward2:setLineCountByLimitAutoWrap(2)
  self._ui._txt_objective:setLineCountByLimitAutoWrap(2)
  self._ui._txt_objective2:setLineCountByLimitAutoWrap(2)
  if false == self._nationKoreaCheck then
    self._ui._txt_frameText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._txt_frameText2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  end
  self._ui._stc_mainBG:SetShow(true)
  self._ui._stc_mainBG2:SetShow(true)
  self._ui._stc_mainBG:SetRectClipOnArea(float2(0, 0), float2(913, 621))
  self._ui._btn_bottomArea_Previous:addInputEvent("Mouse_LUp", "input_Achievement_LUp_PageChange(false)")
  self._ui._btn_bottomArea_Preview:addInputEvent("Mouse_LUp", "input_Achievement_LUp_PageChange(true)")
  Panel_Window_Achievement:addInputEvent("Mouse_UpScroll", "input_Achievement_LUp_PageChange(false)")
  Panel_Window_Achievement:addInputEvent("Mouse_DownScroll", "input_Achievement_LUp_PageChange(true)")
  self._ui._btn_reward:addInputEvent("Mouse_UpScroll", "input_Achievement_LUp_PageChange(false)")
  self._ui._btn_reward:addInputEvent("Mouse_DownScroll", "input_Achievement_LUp_PageChange(true)")
  self._ui._btn_reward2:addInputEvent("Mouse_UpScroll", "input_Achievement_LUp_PageChange(false)")
  self._ui._btn_reward2:addInputEvent("Mouse_DownScroll", "input_Achievement_LUp_PageChange(true)")
  self:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Achievement")
function Achievement:questSetting(groupNo)
  self._questInfo = {}
  self._currentIndex = 1
  self._otherIndex = 1
  self._questInfoCount = 0
  local localIndex = 1
  local specialCount = ToClient_SpecialQuestCount()
  for index = 0, specialCount - 1 do
    local questWrapper = ToClient_GetSpecialQuest(index)
    if nil ~= questWrapper then
      local questNo = questWrapper:getQuestNo()
      if groupNo == questNo._group then
        if 1 ~= self._currentIndex and true == ToClient_isProgressingQuest(questNo._group, questNo._quest) then
          self._currentIndex = localIndex
        end
        local info = {}
        info.questNo = questNo
        info.totalIndex = index
        self._questInfo[localIndex] = info
        localIndex = localIndex + 1
        self._questInfoCount = self._questInfoCount + 1
      end
    end
  end
  local sort = function(a, b)
    return a.questNo._quest < b.questNo._quest
  end
  table.sort(self._questInfo, sort)
end
function Achievement:findQuestIndex(groupNo, questNo)
  local _questNo
  for i = 1, #self._questInfo do
    _questNo = self._questInfo[i].questNo
    if _questNo._group == groupNo and _questNo._quest == questNo then
      return i
    end
  end
  return -1
end
function input_Achievement_LUp_PageChange(isNext)
  local questListInfo = ToClient_GetQuestList()
  if nil == questListInfo then
    return
  end
  if nil == isNext then
    return
  end
  local self = Achievement
  local newIndex = 0
  if true == isNext then
    newIndex = self._currentIndex + 1
    if newIndex > self._questInfoCount then
      return
    end
  else
    newIndex = self._currentIndex - 1
    if newIndex <= 0 then
      return
    end
  end
  if newIndex > self._currentIndex then
    self:setOtherPage(1)
    PaGlobal_Achievement_NextPage()
  elseif newIndex < self._currentIndex then
    self:setOtherPage(-1)
    PaGlobal_Achievement_BackPage()
  end
  self._currentIndex = newIndex
  self._ui._btn_reward:EraseAllEffect()
  self._ui._btn_reward2:EraseAllEffect()
  audioPostEvent_SystemUi(1, 47)
end
local bbb = 0
local _speedSizeUp = 0
local speed = 2400
function Achievement_ShowAni(deltaTime)
  local self = Achievement
  _speedSizeUp = _speedSizeUp + speed * deltaTime
  local _moveSizeX = self._nextPageXSize - _speedSizeUp
  self._ui._stc_mainBG:SetRectClipOnArea(float2(0, 0), float2(_moveSizeX, self._ui._stc_mainBG:GetSizeY()))
  if _moveSizeX <= 0 then
    _panel:ClearUpdateLuaFunc()
    self:hideOtherPage()
    self:setCurrentPage()
    self:ScrollUpdate()
    _speedSizeUp = 0
    self._nextPageXSize = Achievement._ui._stc_mainBG:GetSizeX()
  end
end
function PaGlobal_Achievement_PageChangeAni(deltaTime)
  Achievement_ShowAni(deltaTime)
end
function PaGlobal_Achievement_NextPage(second)
  local self = Achievement
  self._ui._stc_addEffect:AddEffect("UI_Book_01A", false, 0, 0)
  _panel:RegisterUpdateFunc("PaGlobal_Achievement_PageChangeAni")
end
local _backPageXSize = 0
local _speedSizeUpBack = 0
local speed2 = 2400
function Achievement_ShowAni_Back(deltaTime)
  local self = Achievement
  _speedSizeUpBack = _speedSizeUpBack + speed2 * deltaTime
  local _moveSizeX = _backPageXSize + _speedSizeUpBack
  self._ui._stc_mainBG:SetRectClipOnArea(float2(_moveSizeX, 0), float2(913, 621))
  if _moveSizeX >= self._ui._stc_mainBG:GetSizeX() then
    _panel:ClearUpdateLuaFunc()
    self:hideOtherPage()
    self:setCurrentPage()
    self:ScrollUpdate()
    _speedSizeUpBack = 0
    _backPageXSize = 0
  end
end
function PaGlobal_Achievement_BackPageChangeAni(deltaTime)
  Achievement_ShowAni_Back(deltaTime)
end
function PaGlobal_Achievement_BackPage()
  local self = Achievement
  self._ui._stc_addEffect:AddEffect("UI_Book_01B", false, 0, 0)
  _panel:RegisterUpdateFunc("PaGlobal_Achievement_BackPageChangeAni")
end
function Achievement:ScrollUpdate()
  if false == self._nationKoreaCheck then
    self._ui._frm_vScroll:SetControlTop()
    self._ui._frm_frame:UpdateContentPos()
    self._ui._frm_frame:UpdateContentScroll()
    self._ui._frm_vScroll2:SetControlTop()
    self._ui._frm_frame2:UpdateContentPos()
    self._ui._frm_frame2:UpdateContentScroll()
  end
end
function Achievement:registEventHandler()
  self._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_Achievement_Close()")
  registerEvent("FromClient_notifyUpdateSpecialQuest", "FromClient_notifyUpdateSpecialQuest_Achievement")
  registerEvent("EventQuestUpdateNotify", "FromClient_EventQuestUpdateNotify_Achievement")
  registerEvent("FromClient_FamilySpeicalInfoChange", "FromClient_FamilySpeicalInfoChange_Achievement")
  registerEvent("FromClient_CharacterSpeicalInfoChange", "FromClient_CharacterSpeicalInfoChange_Achievement")
  registerEvent("FromClient_FamilySpeicalInfoPointChange", "FromClient_FamilySpeicalInfoPointChange_Achievement")
end
function PaGlobalFunc_Achievement_Open(bookType)
  if nil == bookType then
    return
  end
  if false == _ContentsGroup_AchievementQuest then
    return
  end
  Achievement:open(bookType)
end
function PaGlobalFunc_Achievement_Open_From_BookShelf(questGroup)
  if nil == questGroup then
    return
  end
  if false == _ContentsGroup_AchievementQuest then
    return
  end
  Achievement:open_from_bookShelf(questGroup)
end
function PaGlobalFunc_Achievement_OpenBookShelfQuest(questGroup, questNo)
  UI.ASSERT_NAME(nil ~= questGroup, "PaGlobalFunc_Achievement_OpenBookShelfQuest questGroup nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= questNo, "PaGlobalFunc_Achievement_OpenBookShelfQuest questNo nil", "\236\178\156\235\167\140\234\184\176")
  if false == _ContentsGroup_AchievementQuest then
    return
  end
  _panel:SetShow(true)
  Achievement:clear()
  Achievement._isBookType = questGroup
  Achievement:questSetting(questGroup)
  Achievement._currentIndex = Achievement:findQuestIndex(questGroup, questNo)
  Achievement:update()
end
function Achievement:open_from_bookShelf(questGroup)
  if nil == questGroup then
    return
  end
  _panel:SetShow(true)
  self:clear()
  self._isBookType = questGroup
  self:questSetting(self._isBookType)
  self:update()
end
function Achievement:open(bookType)
  if nil == bookType then
    return
  end
  _panel:SetShow(true)
  self:clear()
  if 1 == bookType then
    self._isBookType = 748
  elseif 2 == bookType then
    self._isBookType = 749
  elseif 3 == bookType then
    self._isBookType = 750
  elseif 4 == bookType then
    self._isBookType = 752
  elseif 5 == bookType then
    self._isBookType = 753
  elseif 6 == bookType then
    self._isBookType = 754
  elseif 7 == bookType then
    self._isBookType = 755
  elseif 8 == bookType then
    self._isBookType = 756
  elseif 9 == bookType then
    self._isBookType = 781
  elseif 10 == bookType then
    self._isBookType = 782
  elseif 11 == bookType then
    self._isBookType = 790
  elseif 12 == bookType then
    self._isBookType = 785
  elseif 13 == bookType then
    self._isBookType = 786
  end
  self:questSetting(self._isBookType)
  self:update()
end
function PaGlobalFunc_Achievement_Close()
  Achievement:close()
end
function Achievement:close()
  _panel:SetShow(false)
end
function Achievement:clear()
  self._ui._stc_mainBG:SetShow(false)
  self._ui._txt_desc:SetShow(false)
  self._ui._txt_desc2:SetShow(false)
  self._ui._btn_reward:SetShow(false)
  self._ui._txt_reward:SetShow(false)
  if false == self._nationKoreaCheck then
    self._ui._txt_frameText:SetShow(false)
    self._ui._txt_frameText2:SetShow(false)
  end
end
function FromClient_FamilySpeicalInfoChange_Achievement()
  if false == _panel:GetShow() then
    return
  end
end
function FromClient_CharacterSpeicalInfoChange_Achievement()
  if false == _panel:GetShow() then
    return
  end
end
function FromClient_FamilySpeicalInfoPointChange_Achievement()
end
function FromClient_notifyUpdateSpecialQuest_Achievement(questNoRaw)
  local self = Achievement
  if true == _panel:GetShow() then
    local questInfoWrapper = questList_getQuestInfo(questNoRaw)
    if nil == questInfoWrapper then
      return
    end
    local questNo = questInfoWrapper:getQuestNo()
    if nil == self._questInfo[self._currentIndex] then
      return
    end
    local currentQuestNo = self._questInfo[self._currentIndex].questNo
    local currentGroup = currentQuestNo._group
    local currentQuest = currentQuestNo._quest
    if questNo._group == currentGroup and questNo._quest == currentQuest then
      self:update()
    end
  end
end
function FromClient_EventQuestUpdateNotify_Achievement(isAccept, questNoRaw)
  if true == _panel:GetShow() then
    local self = Achievement
    local questInfoWrapper = questList_getQuestInfo(questNoRaw)
    if nil == questInfoWrapper then
      return
    end
    if false == isAccept then
      local questNo = questInfoWrapper:getQuestNo()
      local specialQuestStaticStatus = questList_getQuestStatic(questNo._group, questNo._quest)
      local baseReward = specialQuestStaticStatus:getQuestBaseRewardAt(0)
      local _reward_str = tostring(Achievement:getRewardText(baseReward))
      local msg = {
        main = _reward_str,
        sub = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_GET_REWARD_MSG"),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 3)
      if nil == self._questInfo[self._currentIndex] then
        return
      end
      local currentQuestNo = self._questInfo[self._currentIndex].questNo
      local currentGroup = currentQuestNo._group
      local currentQuest = currentQuestNo._quest
      if questNo._group == currentGroup and questNo._quest == currentQuest then
        self:update()
      end
    end
  end
end
function Achievement:setCurrentPage()
  local currentQuestNo = self._questInfo[self._currentIndex].questNo
  local currentGroup = currentQuestNo._group
  local currentQuest = currentQuestNo._quest
  local specialQuestInfo
  local isSatisfied = false
  local isCleared = questList_isClearQuest(currentQuestNo._group, currentQuestNo._quest)
  local _reward_str = ""
  local baseReward
  local isProgressingQuest = ToClient_isProgressingQuest(currentQuestNo._group, currentQuestNo._quest)
  local specialQuestStaticStatus = questList_getQuestStatic(currentGroup, currentQuest)
  if nil ~= specialQuestStaticStatus then
    baseReward = specialQuestStaticStatus:getQuestBaseRewardAt(0)
    _reward_str = tostring(Achievement:getRewardText(baseReward))
  end
  if true == isProgressingQuest then
    specialQuestInfo = ToClient_GetQuestInfo(currentGroup, currentQuest)
    if nil ~= specialQuestInfo then
      isSatisfied = specialQuestInfo:isSatisfied()
    end
  else
    specialQuestInfo = questList_getQuestStatic(currentGroup, currentQuest)
  end
  if nil == specialQuestInfo then
    return
  end
  self._ui._stc_mainBG:SetRectClipOnArea(float2(0, 0), float2(913, 621))
  local demandInfo = specialQuestInfo:getDemandAt(0)
  local specialQuestImagePath = specialQuestInfo:getIconPath()
  if nil == demandInfo then
    return
  end
  local currentCount = demandInfo._currentCount
  local destCount = demandInfo._destCount
  local questConditionDesc = demandInfo._desc
  local stringList = string.split(specialQuestInfo:getDesc(), [[


]])
  local targetLeftControlSizeY = 0
  local targetRightControlSizeY = 0
  if nil ~= self._descText[0] then
    for index = 0, #self._descText do
      self._descText[index]:SetShow(false)
    end
  end
  for index = 0, #stringList - 1 do
    if nil == self._descText[index] then
      if true == self._nationKoreaCheck then
        self._descText[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._stc_mainBG, "StaticText_OnebyOne_Desc_" .. index)
        CopyBaseProperty(self._ui._txt_desc, self._descText[index])
      else
        self._descText[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._frm_frameContent, "StaticText_OnebyOne_Desc_" .. index)
        CopyBaseProperty(self._ui._txt_frameText, self._descText[index])
      end
    end
    self._descText[index]:SetTextVerticalTop()
    self._descText[index]:SetTextHorizonLeft()
    self._descText[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    if 0 == index then
      self._ui._txt_descTitle_Date:SetText(tostring(stringList[index + 1]))
    else
      self._descText[index]:SetText(tostring(stringList[index + 1]))
    end
    self._descText[index]:SetSize(380, self._descText[index]:GetTextSizeY())
    self._descText[index]:SetShow(true)
    self._ui._stc_questImage:ChangeTextureInfoNameDefault(specialQuestImagePath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_questImage, 0, 0, 350, 220)
    self._ui._stc_questImage:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._stc_questImage:setRenderTexture(self._ui._stc_questImage:getBaseTexture())
    if true == self._nationKoreaCheck then
      if targetLeftControlSizeY + self._descText[index]:GetTextSizeY() + self._ui._txt_descTitle_Date:GetSizeY() + self._ui._txt_descTitle_Date:GetTextSizeY() + Achievement._gapSize < self._ui._stc_leftBg:GetSizeY() then
        self._descText[index]:SetPosY(70 + (self._ui._txt_descTitle_Date:GetSizeY() + 10) + self._ui._txt_descTitle_Date:GetTextSizeY() + targetLeftControlSizeY)
        self._descText[index]:SetPosX(50)
        targetLeftControlSizeY = targetLeftControlSizeY + self._descText[index]:GetTextSizeY() + 10
        self._ui._stc_questImage:SetShow(true)
      else
        self._descText[index]:SetPosY(300 + targetRightControlSizeY)
        self._descText[index]:SetPosX(480)
        targetRightControlSizeY = targetRightControlSizeY + self._descText[index]:GetTextSizeY() + 10
        self._ui._stc_questImage:SetShow(true)
        self._ui._stc_questImage2:SetShow(true)
      end
    else
      self._descText[index]:SetPosX(10)
      self._descText[index]:SetPosY(self._ui._txt_descTitle_Date:GetSizeY() + 10 + self._ui._txt_descTitle_Date:GetTextSizeY() + targetLeftControlSizeY)
      self._ui._frm_frameContent:SetSize(416, self._ui._txt_descTitle_Date:GetSizeY() + 10 + self._ui._txt_descTitle_Date:GetTextSizeY() + targetLeftControlSizeY)
      self._ui._stc_questImage:SetShow(true)
      targetLeftControlSizeY = targetLeftControlSizeY + self._descText[index]:GetTextSizeY() + 10
      self._ui._stc_questImage:ChangeTextureInfoName(specialQuestImagePath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_questImage, 0, 0, 350, 220)
      self._ui._stc_questImage:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui._stc_questImage:setRenderTexture(self._ui._stc_questImage:getBaseTexture())
      self._ui._frm_frame:UpdateContentPos()
      if self._ui._txt_descTitle_Date:GetSizeY() + 10 + self._ui._txt_descTitle_Date:GetTextSizeY() + targetLeftControlSizeY > 500 then
        self._ui._frm_vScroll:SetShow(true)
      else
        self._ui._frm_vScroll:SetShow(false)
      end
    end
  end
  self._ui._btn_reward:SetShow(true)
  self._ui._txt_reward:SetShow(true)
  self._ui._btn_reward:SetMonoTone(true)
  self._ui._txt_reward:SetMonoTone(true)
  self._ui._btn_reward:SetIgnore(false)
  self._ui._txt_objectiveCheckIcon:SetShow(false)
  self._ui._txt_objectiveCheckIcon:EraseAllEffect()
  self._ui._stc_stamp:SetShow(false)
  if true == isSatisfied then
    self._ui._txt_objectiveCheckIcon:SetShow(true)
    self._ui._txt_objectiveCheckIcon:AddEffect("fUI_Console_Rudder_02B", true, 0, 0)
    self._ui._txt_objectiveCheckIcon:AddEffect("UI_Check_01A", false, 0, 0)
    self._ui._btn_reward:SetMonoTone(false)
    self._ui._txt_reward:SetMonoTone(false)
    self._ui._btn_reward:SetIgnore(false)
    PaGlobal_Achievement_RewardButtonEffect(1)
  end
  if true == isCleared then
    self._ui._txt_objectiveCheckIcon:SetShow(true)
    self._ui._txt_objectiveCheckIcon:AddEffect("fUI_Console_Rudder_02B", true, 0, 0)
    self._ui._txt_objectiveCheckIcon:AddEffect("UI_Check_01A", false, 0, 0)
    self._ui._stc_stamp:SetShow(true)
    self._ui._btn_reward:SetMonoTone(false)
    self._ui._txt_reward:SetMonoTone(false)
    self._ui._btn_reward:SetIgnore(false)
  end
  self._ui._txt_reward:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_TARGET_TIME_BTN", "reward", tostring(_reward_str)))
  self._ui._txt_objective:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_TARGET_TXT", "condition", questConditionDesc))
  if isGameTypeKorea() or isGameTypeJapan() or isGameTypeTaiwan() then
    self._ui._stc_objectiveBG:SetIgnore(true)
  else
    self._ui._stc_objectiveBG:SetIgnore(false)
  end
  self._ui._stc_objectiveBG:addInputEvent("Mouse_On", "input_Achievement_Objective_Tooltip(true, 0)")
  self._ui._stc_objectiveBG:addInputEvent("Mouse_Out", "input_Achievement_Objective_Tooltip(false)")
  self._ui._btn_reward:addInputEvent("Mouse_On", "input_Achievement_Objective_Tooltip(true, 1)")
  self._ui._btn_reward:addInputEvent("Mouse_Out", "input_Achievement_Objective_Tooltip(false)")
  if true == isSatisfied then
    PaGlobal_Achievement_ChangeRewardButton(false)
    self._ui._btn_reward:addInputEvent("Mouse_LUp", "input_Achievement_ReceiveReward(" .. self._currentIndex .. ")")
  else
    PaGlobal_Achievement_ChangeRewardButton(true)
    self._ui._btn_reward:addInputEvent("Mouse_LUp", "")
  end
  if self._currentIndex == 1 then
    self._ui._btn_bottomArea_Previous:SetShow(false)
  else
    self._ui._btn_bottomArea_Previous:SetShow(true)
  end
  if self._questInfoCount <= self._currentIndex then
    self._ui._btn_bottomArea_Preview:SetShow(false)
  else
    self._ui._btn_bottomArea_Preview:SetShow(true)
  end
end
function input_Achievement_Objective_Tooltip(isShow, tipType)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = Achievement
  local currentQuestNo = self._questInfo[self._currentIndex].questNo
  local currentGroup = currentQuestNo._group
  local currentQuest = currentQuestNo._quest
  local specialQuestStaticStatus = questList_getQuestStatic(currentGroup, currentQuest)
  local _reward_str = ""
  if nil ~= specialQuestStaticStatus then
    local baseReward = specialQuestStaticStatus:getQuestBaseRewardAt(0)
    _reward_str = tostring(Achievement:getRewardText(baseReward))
  end
  local isProgressingQuest = ToClient_isProgressingQuest(currentQuestNo._group, currentQuestNo._quest)
  if true == isProgressingQuest then
    specialQuestInfo = ToClient_GetQuestInfo(currentGroup, currentQuest)
  else
    specialQuestInfo = questList_getQuestStatic(currentGroup, currentQuest)
  end
  if nil == specialQuestInfo then
    return
  end
  local demandInfo = specialQuestInfo:getDemandAt(0)
  if nil == demandInfo then
    return
  end
  local questConditionDesc = demandInfo._desc
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_TOOLTIP_OBJECTIVE_NAME")
    desc = tostring(questConditionDesc)
    control = self._ui._stc_objectiveBG
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_QUEST_COMPLETEREWARD_TITLE")
    desc = tostring(_reward_str)
    control = self._ui._btn_reward
  end
  TooltipSimple_Show(control, name, desc)
end
function Achievement:hideOtherPage()
  if true == self._nationKoreaCheck then
    self._ui._stc_mainBG2:SetShow(false)
  else
    self._ui._frm_frameContent2:SetShow(false)
  end
end
function Achievement:setOtherPage(isNext)
  if true == self._nationKoreaCheck then
    self._ui._stc_mainBG2:SetShow(true)
  else
  end
  local isHaveOther = true
  local addValue = 0
  if 1 == isNext then
    addValue = 1
    if self._questInfoCount < self._currentIndex + addValue then
      isHaveOther = false
    end
  elseif -1 == isNext then
    addValue = -1
    if 0 >= self._currentIndex + addValue then
      isHaveOther = false
    end
  end
  if false == isHaveOther then
    return
  end
  self._ui._stc_mainBG:SetRectClipOnArea(float2(0, 0), float2(913, 621))
  local otherIndex = self._currentIndex + addValue
  local otherQuestNo = self._questInfo[otherIndex].questNo
  local otherGroup = otherQuestNo._group
  local otherQuest = otherQuestNo._quest
  local otherQuestInfo
  local otherQuestSatisfied = false
  local otherQuestCleared = questList_isClearQuest(otherQuestNo._group, otherQuestNo._quest)
  local _otherReward_str = ""
  local isProgressingQuest = ToClient_isProgressingQuest(otherGroup, otherQuest)
  local specialQuestStaticStatus = questList_getQuestStatic(otherGroup, otherQuest)
  if nil ~= specialQuestStaticStatus then
    local baseReward = specialQuestStaticStatus:getQuestBaseRewardAt(0)
    _otherReward_str = tostring(Achievement:getRewardText(baseReward))
  end
  if true == isProgressingQuest then
    otherQuestInfo = ToClient_GetQuestInfo(otherGroup, otherQuest)
    if nil ~= otherQuestInfo then
      otherQuestSatisfied = otherQuestInfo:isSatisfied()
    end
  else
    otherQuestInfo = questList_getQuestStatic(otherGroup, otherQuest)
  end
  if nil == otherQuestInfo then
    return
  end
  local demandInfo = otherQuestInfo:getDemandAt(0)
  local specialQuestImagePath = otherQuestInfo:getIconPath()
  if nil == demandInfo then
    return
  end
  local currentCount = demandInfo._currentCount
  local destCount = demandInfo._destCount
  local questConditionDesc = demandInfo._desc
  local stringList2 = string.split(otherQuestInfo:getDesc(), [[


]])
  local targetLeftControlSizeY2 = 0
  local targetRightControlSizeY2 = 0
  if nil ~= self._descText2[0] then
    for index = 0, #self._descText2 do
      self._descText2[index]:SetShow(false)
    end
  end
  for index = 0, #stringList2 - 1 do
    if nil == self._descText2[index] then
      if true == self._nationKoreaCheck then
        self._descText2[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._stc_mainBG2, "StaticText_OnebyOne_Desc2_" .. index)
        CopyBaseProperty(self._ui._txt_desc_2, self._descText2[index])
      else
        self._descText2[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._frm_frameContent2, "StaticText_OnebyOne_Desc2_" .. index)
        CopyBaseProperty(self._ui._txt_frameText2, self._descText2[index])
      end
    end
    self._descText2[index]:SetTextVerticalTop()
    self._descText2[index]:SetTextHorizonLeft()
    self._descText2[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    if 0 == index then
      self._ui._txt_descTitle_Date2:SetText(tostring(stringList2[index + 1]))
    else
      self._descText2[index]:SetText(tostring(stringList2[index + 1]))
    end
    self._descText2[index]:SetSize(380, self._descText2[index]:GetTextSizeY())
    self._descText2[index]:SetShow(true)
    self._ui._stc_questImage2:ChangeTextureInfoName(specialQuestImagePath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_questImage2, 0, 0, 350, 220)
    self._ui._stc_questImage2:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._stc_questImage2:setRenderTexture(self._ui._stc_questImage2:getBaseTexture())
    if true == self._nationKoreaCheck then
      if targetLeftControlSizeY2 + self._descText2[index]:GetTextSizeY() + self._ui._txt_descTitle_Date2:GetSizeY() + self._ui._txt_descTitle_Date2:GetTextSizeY() + Achievement._gapSize < self._ui._stc_leftBg2:GetSizeY() then
        self._descText2[index]:SetPosY(70 + (self._ui._txt_descTitle_Date2:GetSizeY() + 10) + self._ui._txt_descTitle_Date2:GetTextSizeY() + targetLeftControlSizeY2)
        self._descText2[index]:SetPosX(50)
        targetLeftControlSizeY2 = targetLeftControlSizeY2 + self._descText2[index]:GetTextSizeY() + 10
        self._ui._stc_questImage2:SetShow(true)
      else
        self._descText2[index]:SetPosY(300 + targetRightControlSizeY2)
        self._descText2[index]:SetPosX(480)
        targetRightControlSizeY2 = targetRightControlSizeY2 + self._descText2[index]:GetTextSizeY() + 10
        self._ui._stc_questImage:SetShow(true)
        self._ui._stc_questImage2:SetShow(true)
      end
    else
      self._descText2[index]:SetPosX(10)
      self._descText2[index]:SetPosY(self._ui._txt_descTitle_Date2:GetSizeY() + 10 + self._ui._txt_descTitle_Date2:GetTextSizeY() + targetLeftControlSizeY2)
      self._ui._frm_frameContent2:SetSize(416, self._ui._txt_descTitle_Date2:GetSizeY() + 10 + self._ui._txt_descTitle_Date2:GetTextSizeY() + targetLeftControlSizeY2)
      targetLeftControlSizeY2 = targetLeftControlSizeY2 + self._descText2[index]:GetTextSizeY() + 10
      self._ui._stc_questImage2:SetShow(true)
      self._ui._stc_questImage2:ChangeTextureInfoName(specialQuestImagePath)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_questImage2, 0, 0, 350, 220)
      self._ui._stc_questImage2:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui._stc_questImage2:setRenderTexture(self._ui._stc_questImage2:getBaseTexture())
      self._ui._frm_frame2:UpdateContentPos()
      if self._ui._txt_descTitle_Date2:GetSizeY() + 10 + self._ui._txt_descTitle_Date2:GetTextSizeY() + targetLeftControlSizeY2 > 500 then
        self._ui._frm_vScroll2:SetShow(true)
      else
        self._ui._frm_vScroll2:SetShow(false)
      end
    end
  end
  self._ui._btn_reward2:SetShow(true)
  self._ui._txt_reward2:SetShow(true)
  self._ui._btn_reward2:SetMonoTone(true)
  self._ui._txt_reward2:SetMonoTone(true)
  self._ui._btn_reward2:SetIgnore(false)
  self._ui._txt_objectiveCheckIcon2:SetShow(false)
  self._ui._txt_objectiveCheckIcon2:EraseAllEffect()
  self._ui._btn_reward:EraseAllEffect()
  self._ui._btn_reward2:EraseAllEffect()
  self._ui._stc_stamp2:SetShow(false)
  if true == otherQuestSatisfied then
    self._ui._txt_objectiveCheckIcon2:SetShow(true)
    self._ui._txt_objectiveCheckIcon2:AddEffect("fUI_Console_Rudder_02B", true, 0, 0)
    self._ui._txt_objectiveCheckIcon2:AddEffect("UI_Check_01A", false, 0, 0)
    self._ui._btn_reward2:SetMonoTone(false)
    self._ui._txt_reward2:SetMonoTone(false)
    self._ui._btn_reward2:SetIgnore(false)
    PaGlobal_Achievement_RewardButtonEffect(2)
  end
  if true == otherQuestCleared then
    self._ui._btn_reward2:EraseAllEffect()
    self._ui._txt_objectiveCheckIcon2:SetShow(true)
    self._ui._txt_objectiveCheckIcon2:AddEffect("fUI_Console_Rudder_02B", true, 0, 0)
    self._ui._txt_objectiveCheckIcon2:AddEffect("UI_Check_01A", false, 0, 0)
    self._ui._btn_reward2:SetMonoTone(false)
    self._ui._txt_reward2:SetMonoTone(false)
    self._ui._btn_reward2:SetIgnore(false)
    self._ui._stc_stamp2:SetShow(true)
  end
  self._ui._txt_reward2:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_TARGET_TIME_BTN", "reward", tostring(_otherReward_str)))
  self._ui._txt_objective2:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_TARGET_TXT", "condition", questConditionDesc))
  if isGameTypeKorea() or isGameTypeJapan() or isGameTypeTaiwan() then
    self._ui._stc_objectiveBG2:SetIgnore(true)
  else
    self._ui._stc_objectiveBG2:SetIgnore(false)
  end
  self._ui._stc_objectiveBG2:addInputEvent("Mouse_On", "input_Achievement_Objective_Tooltip(true, 0)")
  self._ui._stc_objectiveBG2:addInputEvent("Mouse_Out", "input_Achievement_Objective_Tooltip(false)")
  self._ui._btn_reward2:addInputEvent("Mouse_On", "input_Achievement_Objective_Tooltip(true, 1)")
  self._ui._btn_reward2:addInputEvent("Mouse_Out", "input_Achievement_Objective_Tooltip(false)")
  if true == otherQuestSatisfied then
    PaGlobal_Achievement_ChangeRewardButton(false)
    self._ui._btn_reward2:addInputEvent("Mouse_LUp", "input_Achievement_ReceiveReward(" .. otherIndex .. ")")
  else
    PaGlobal_Achievement_ChangeRewardButton(true)
    self._ui._btn_reward2:addInputEvent("Mouse_LUp", "")
  end
end
function Achievement:update()
  self:clear()
  if nil == self._questInfo[self._currentIndex] then
    return
  end
  self._ui._stc_mainBG:SetShow(true)
  self._ui._txt_desc:SetShow(false)
  self._ui._txt_desc2:SetShow(true)
  self._ui._btn_reward:SetShow(true)
  self._ui._txt_reward:SetShow(true)
  self._ui._stc_objectiveBG:SetShow(true)
  self._ui._stc_objectiveBG2:SetShow(true)
  self._ui._txt_descTitle_Date:SetShow(true)
  self._ui._txt_descTitle_Date2:SetShow(true)
  self._ui._stc_leftWing:SetShow(true)
  self._ui._stc_rightWing:SetShow(true)
  self._ui._stc_questImage:SetShow(true)
  self._ui._stc_questImage2:SetShow(true)
  if false == self._nationKoreaCheck then
    self._ui._frm_frame:SetShow(true)
    self._ui._frm_frameContent:SetShow(true)
    self._ui._txt_frameText:SetShow(false)
    self._ui._frm_frame2:SetShow(true)
    self._ui._frm_frameContent2:SetShow(true)
    self._ui._txt_frameText2:SetShow(false)
  end
  self._ui._stc_mainBG:SetRectClipOnArea(float2(0, 0), float2(913, 621))
  self:setCurrentPage()
end
function PaGlobal_Achievement_ChangeRewardButton(isIgnore)
  local self = Achievement
  if false == isIgnore then
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._btn_reward, 1, 81, 175, 128)
    self._ui._btn_reward:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getBaseTexture())
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._ui._btn_reward, 1, 129, 175, 176)
    self._ui._btn_reward:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getOnTexture())
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self._ui._btn_reward, 1, 177, 175, 224)
    self._ui._btn_reward:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getClickTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxx1, yyyy1, xxxx2, yyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 81, 175, 128)
    self._ui._btn_reward2:getBaseTexture():setUV(xxxx1, yyyy1, xxxx2, yyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getBaseTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxxx1, yyyyy1, xxxxx2, yyyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 129, 175, 176)
    self._ui._btn_reward2:getOnTexture():setUV(xxxxx1, yyyyy1, xxxxx2, yyyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getOnTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxxxx1, yyyyyyy1, xxxxxx2, yyyyyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 177, 175, 224)
    self._ui._btn_reward2:getClickTexture():setUV(xxxxxx1, yyyyyyy1, xxxxxx2, yyyyyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getClickTexture())
  else
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._btn_reward, 1, 81, 175, 128)
    self._ui._btn_reward:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getBaseTexture())
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._ui._btn_reward, 1, 129, 175, 176)
    self._ui._btn_reward:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getOnTexture())
    self._ui._btn_reward:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self._ui._btn_reward, 1, 129, 175, 176)
    self._ui._btn_reward:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
    self._ui._btn_reward:setRenderTexture(self._ui._btn_reward:getClickTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxx1, yyyy1, xxxx2, yyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 81, 175, 128)
    self._ui._btn_reward2:getBaseTexture():setUV(xxxx1, yyyy1, xxxx2, yyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getBaseTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxxx1, yyyyy1, xxxxx2, yyyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 129, 175, 176)
    self._ui._btn_reward2:getOnTexture():setUV(xxxxx1, yyyyy1, xxxxx2, yyyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getOnTexture())
    self._ui._btn_reward2:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Adventurebook_01.dds")
    local xxxxxx1, yyyyyyy1, xxxxxx2, yyyyyyy2 = setTextureUV_Func(self._ui._btn_reward2, 1, 129, 175, 176)
    self._ui._btn_reward2:getClickTexture():setUV(xxxxxx1, yyyyyyy1, xxxxxx2, yyyyyyy2)
    self._ui._btn_reward2:setRenderTexture(self._ui._btn_reward2:getClickTexture())
  end
end
function Achievement:getRewardText(baseReward)
  local rewardType = baseReward:getType()
  local str = ""
  if __eRewardFamilyStat == rewardType then
    local statType = baseReward:getFamilyStatType()
    if __eFamilySpecialInfoPointType_Offence == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_ATTACK", "value", baseReward:getFamilyStatOffencePoint())
    elseif __eFamilySpecialInfoPointType_Defence == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_DEFENCE", "val", baseReward:getFamilyStatDefencePoint())
    elseif __eFamilySpecialInfoPointType_Hp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HP", "value", baseReward:getFamilyStatHp())
    elseif __eFamilySpecialInfoPointType_Mp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_MP", "value", baseReward:getFamilyStatMp())
    elseif __eFamilySpecialInfoPointType_Sp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_SP", "val", baseReward:getFamilyStatSp())
    elseif __eFamilySpecialInfoPointType_Weight == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_WEIGHT", "val", math.floor(baseReward:getFamilyStatWeight() / 10000 + 0.5))
    elseif __eFamilySpecialInfoPointType_InvenCount == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_INVEN_SLOT", "val", baseReward:getFamilyStatInventory())
    elseif __eFamilySpecialInfoPointType_Hit == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_HIT", "val", baseReward:getFamilyStatHit())
    elseif __eFamilySpecialInfoPointType_Dv == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_DV", "val", baseReward:getFamilyStatDv())
    elseif __eFamilySpecialInfoPointType_Stack == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_STACK", "val", baseReward:getFamilyStatStack())
    elseif __eFamilySpecialInfoPointType_ValksLimitExceed == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_VALKSLIMITEXCEED", "val", baseReward:getFamilyStatValksLimitExceed())
    elseif __eFamilySpecialInfoPointType_StackLimitExceed == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_STACKLIMITEXCEED", "val", baseReward:getFamilyStatStackLimitExceed())
    end
    if "" ~= str then
      str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_FAMILY")
    end
  elseif __eRewardCharacterStat == rewardType then
    local statType = baseReward:getCharacterStatType()
    if __eFamilySpecialInfoPointType_Offence == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_ATTACK", "value", baseReward:getCharacterStatOffencePoint())
    elseif __eFamilySpecialInfoPointType_Defence == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_DEFENCE", "val", baseReward:getCharacterStatDefencePoint())
    elseif __eFamilySpecialInfoPointType_Hp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HP", "value", baseReward:getCharacterStatHp())
    elseif __eFamilySpecialInfoPointType_Mp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_MP", "value", baseReward:getCharacterStatMp())
    elseif __eFamilySpecialInfoPointType_Sp == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_SP", "val", baseReward:getCharacterStatSp())
    elseif __eFamilySpecialInfoPointType_Weight == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_WEIGHT", "val", math.floor(baseReward:getCharacterStatWeight() / 10000 + 0.5))
    elseif __eFamilySpecialInfoPointType_InvenCount == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_INVEN_SLOT", "val", baseReward:getCharacterStatInventory())
    elseif __eFamilySpecialInfoPointType_Hit == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_HIT", "val", baseReward:getCharacterStatHit())
    elseif __eFamilySpecialInfoPointType_Dv == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_DV", "val", baseReward:getCharacterStatDv())
    elseif __eFamilySpecialInfoPointType_Stack == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_STACK", "val", baseReward:getCharacterStatStack())
    elseif __eFamilySpecialInfoPointType_ValksLimitExceed == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_VALKSLIMITEXCEED", "val", baseReward:getCharacterStatValksLimitExceed())
    elseif __eFamilySpecialInfoPointType_StackLimitExceed == statType then
      str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACHIEVEMENT_REWARD_TYPE_STACKLIMITEXCEED", "val", baseReward:getCharacterStatStackLimitExceed())
    end
  elseif __eRewardItem == rewardType then
    local itemEnchantKey = ItemEnchantKey(baseReward:getItemEnchantKey())
    local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
    if nil ~= itemStatic then
      str = itemStatic:getName()
    end
  end
  return str
end
function input_Achievement_ReceiveReward(index)
  if nil == index then
    return
  end
  local self = Achievement
  local function requestCompleteRefresh()
    if nil == self._questInfo[index] then
      return
    end
    local questNo = self._questInfo[index].questNo
    local questListInfo = ToClient_GetQuestList()
    if nil == questListInfo then
      return
    end
    local specialQuestCount = questListInfo:getSpecialQuestCount()
    for i = 0, specialQuestCount - 1 do
      local specialQuestNo = questListInfo:getSpecialQuestAt(i)
      if nil ~= specialQuestNo then
        if questNo._group == specialQuestNo._group and questNo._quest == specialQuestNo._quest then
          ToClient_RequestCompleteSpecialQuest(i)
        else
          _PA_LOG("mingu", "\236\153\132\235\163\140 \236\154\148\236\178\173\234\179\188 \236\157\188\236\185\152\237\149\152\235\138\148 \237\128\152\236\138\164\237\138\184\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
        end
      end
    end
  end
  if true == self._ui._btn_reward:GetShow() then
    self._ui._btn_reward:EraseAllEffect()
    self._ui._btn_reward:AddEffect("fUI_Stamp_01A", true, 160, -25)
    PaGlobal_Achievement_RewardButtonEffect(4)
  end
  if true == self._ui._btn_reward2:GetShow() then
    self._ui._btn_reward2:EraseAllEffect()
    self._ui._btn_reward2:AddEffect("fUI_Stamp_01A", true, 160, -25)
  end
  audioPostEvent_SystemUi(0, 25)
  requestCompleteRefresh()
end
function PaGlobal_Achievement_RewardButtonEffect(controlType)
  local self = Achievement
  local currentQuestNo = self._questInfo[self._currentIndex].questNo
  local currentGroup = currentQuestNo._group
  local currentQuest = currentQuestNo._quest
  local specialQuestStaticStatus = questList_getQuestStatic(currentGroup, currentQuest)
  if nil == specialQuestStaticStatus then
    return
  end
  local baseReward = specialQuestStaticStatus:getQuestBaseRewardAt(0)
  local rewardType = baseReward:getType()
  local effectName = ""
  local effectName2 = ""
  local edgeEffectName = ""
  local completeRewardEffectName = ""
  if __eRewardFamilyStat == rewardType then
    local statType = baseReward:getFamilyStatType()
    if __eFamilySpecialInfoPointType_Offence == statType then
      effectName = "fUI_Book_Box_01A"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03A"
      completeRewardEffectName = "fUI_Book_Box_02A"
    elseif __eFamilySpecialInfoPointType_Defence == statType then
      effectName = "fUI_Book_Box_01B"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03B"
      completeRewardEffectName = "fUI_Book_Box_02B"
    elseif __eFamilySpecialInfoPointType_Hp == statType then
      effectName = "fUI_Book_Box_01C"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03C"
      completeRewardEffectName = "fUI_Book_Box_02C"
    elseif __eFamilySpecialInfoPointType_Mp == statType then
      effectName = "fUI_Book_Box_01D"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03D"
      completeRewardEffectName = "fUI_Book_Box_02D"
    elseif __eFamilySpecialInfoPointType_Sp == statType then
      effectName = "fUI_Book_Box_01E"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03E"
      completeRewardEffectName = "fUI_Book_Box_02E"
    elseif __eFamilySpecialInfoPointType_Weight == statType or __eFamilySpecialInfoPointType_Stack == statType then
      effectName = "fUI_Book_Box_01F"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03F"
      completeRewardEffectName = "fUI_Book_Box_02F"
    elseif __eFamilySpecialInfoPointType_InvenCount == statType then
      effectName = "fUI_Book_Box_01F"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03F"
      completeRewardEffectName = "fUI_Book_Box_02F"
    elseif __eFamilySpecialInfoPointType_Hit == statType then
      effectName = "fUI_Book_Box_01G"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03G"
      completeRewardEffectName = "fUI_Book_Box_02G"
    elseif __eFamilySpecialInfoPointType_Dv == statType then
      effectName = "fUI_Book_Box_01H"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03H"
      completeRewardEffectName = "fUI_Book_Box_02H"
    else
      effectName = "fUI_Book_Box_01E"
      effectName2 = "UI_Book_Box_01A"
      edgeEffectName = "fUI_Book_Box_03E"
      completeRewardEffectName = "fUI_Book_Box_02E"
    end
  else
    effectName = "fUI_Book_Box_01E"
    effectName2 = "UI_Book_Box_01A"
    edgeEffectName = "fUI_Book_Box_03E"
    completeRewardEffectName = "fUI_Book_Box_02E"
  end
  if 1 == controlType then
    self._ui._btn_reward:EraseAllEffect()
    self._ui._btn_reward:AddEffect(effectName, true, 0, 0)
    self._ui._btn_reward:AddEffect(effectName2, true, 0, 0)
  end
  if 2 == controlType then
    self._ui._btn_reward2:EraseAllEffect()
    self._ui._btn_reward2:AddEffect(effectName, true, 0, 0)
    self._ui._btn_reward2:AddEffect(effectName2, true, 0, 0)
  end
  if 3 == controlType then
  end
  if 4 == controlType then
    self._ui._txt_reward:EraseAllEffect()
    self._ui._stc_addEffect:EraseAllEffect()
    self._ui._stc_addEffect:AddEffect(edgeEffectName, false, 0, 0)
    self._ui._txt_reward:AddEffect(completeRewardEffectName, false, 0, 0)
  end
end
