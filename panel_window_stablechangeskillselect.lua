local UI_TM = CppEnums.TextMode
local _panel = Panel_Window_Stable_ChangeSkillSelect
local Panel_Window_StableChangeSkillSelect_info = {
  _ui = {
    staticText_TitleName = UI.getChildControl(_panel, "StaticText_TitleName"),
    static_TopBg = UI.getChildControl(_panel, "Static_TopBg"),
    static_SkillListBg = UI.getChildControl(_panel, "Static_SkillListBg"),
    staticText_SkillStack = UI.getChildControl(_panel, "StaticText_SkillStack"),
    static_SkillChangeGuideBg = UI.getChildControl(_panel, "Static_SkillChangeGuideBg"),
    static_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _current_skillNo = nil,
  _current_servantInfo = nil,
  _selected_hopeSkillNo = nil,
  _nowShowHopeSkill = 0,
  _oriText_skillStack = "",
  _unlearned_skill_List = {},
  _skillIcon_List = {},
  _maxVisibleCnt = 8
}
function Panel_Window_StableChangeSkillSelect_info:init()
  self._ui.static_SkillBg1 = UI.getChildControl(self._ui.static_TopBg, "Static_SkillBg1")
  self._ui.static_SkillBg2 = UI.getChildControl(self._ui.static_TopBg, "Static_SkillBg2")
  self._ui.staticText_SelectSkillDesc1 = UI.getChildControl(self._ui.static_TopBg, "StaticText_SelectSkillDesc1")
  self._ui.staticText_SelectSkillDesc2 = UI.getChildControl(self._ui.static_TopBg, "StaticText_SelectSkillDesc2")
  self._ui.static_SkillIcon1 = UI.getChildControl(self._ui.static_SkillBg1, "Static_SKillIcon1")
  self._ui.static_SkillCircleProgress1 = UI.getChildControl(self._ui.static_SkillIcon1, "CircularProgress_Train")
  self._ui.staticText_SkillName1 = UI.getChildControl(self._ui.static_SkillBg1, "StaticText_SkillName1")
  self._ui.static_SkillIcon2 = UI.getChildControl(self._ui.static_SkillBg2, "Static_SKillIcon2")
  self._ui.staticText_SkillName2 = UI.getChildControl(self._ui.static_SkillBg2, "StaticText_SkillName2")
  self._ui.staticText_SkillChangeDesc = UI.getChildControl(self._ui.static_TopBg, "StaticText_SkillChangeDesc")
  self._ui.staticText_SkillChangeDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.staticText_SkillChangeDesc:SetText(self._ui.staticText_SkillChangeDesc:GetText())
  self._ui.staticText_SkillName3 = UI.getChildControl(self._ui.static_SkillListBg, "StaticText_SkillName3")
  self._ui.static_SkillIcon_Group = UI.getChildControl(self._ui.static_SkillListBg, "Static_SkillIcon_Group")
  self._ui.static_SkillIconBg = UI.getChildControl(self._ui.static_SkillIcon_Group, "Static_SkillIconBg")
  self._ui.staticText_GuideDesc = UI.getChildControl(self._ui.static_SkillChangeGuideBg, "StaticText_GuideDesc")
  self._ui.staticText_GuideDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.staticText_GuideDesc:SetText(self._ui.staticText_GuideDesc:GetText())
  self._ui._button_B = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Cancel_ConsoleUI")
  self._ui._button_Y = UI.getChildControl(self._ui.static_BottomBg, "StaticText_ChangeSkill")
  self._ui._button_A = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Hope")
  local tempBtnGroup = {
    self._ui._button_B,
    self._ui._button_A,
    self._ui._button_Y
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._oriText_skillStack = self._ui.staticText_SkillStack:GetText()
  self:registerEvent()
end
function Panel_Window_StableChangeSkillSelect_info:registerEvent()
  _panel:ignorePadSnapMoveToOtherPanel()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Y, "Input_StableChangeSkillSelect_PadButtonDown_Y()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_A, "Input_StableChangeSkillSelect_PadButtonDown_A()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_StableChangeSkillSelect_PressedLT()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_StableChangeSkillSelect_PressedRT()")
  registerEvent("FromClient_ServantChangeSkill", "FromClient_StableChangeSkil_ChangeSkillSelect_Complete")
end
function PaGlobalFunc_StableChangeSkillSelect_GetShow()
  return _panel:GetShow()
end
function Panel_Window_StableChangeSkillSelect_info:open()
  if 1 > #self._unlearned_skill_List then
    return
  end
  if nil == self._selected_hopeSkillNo then
    self:changeTargetHopeSkill(1)
    self:changeHopeSkill(1)
  end
  self:update()
  _panel:SetShow(true)
  PaGlobalFunc_StableChangeSkill_RePosition()
  ToClient_padSnapResetControl()
end
function Panel_Window_StableChangeSkillSelect_info:setData(skillKey)
  if nil == skillKey then
    return
  end
  self._current_servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  if nil == self._current_servantInfo then
    return
  end
  self._current_skillNo = skillKey
  self._unlearned_skill_List = {}
  local skillCount = self._current_servantInfo:getSkillCount()
  for ii = 1, skillCount - 1 do
    local skillWrapper = self._current_servantInfo:getSkillXXX(ii)
    if nil ~= skillWrapper and self._current_servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining and false == skillWrapper:isTrainingSkill() then
      self._unlearned_skill_List[#self._unlearned_skill_List + 1] = ii
      if nil == self._skillIcon_List[#self._unlearned_skill_List] then
        self._skillIcon_List[#self._unlearned_skill_List] = {}
        self._skillIcon_List[#self._unlearned_skill_List].skillBg = UI.cloneControl(self._ui.static_SkillIconBg, self._ui.static_SkillIcon_Group, "HopeSkillIcon_" .. #self._unlearned_skill_List)
        self._skillIcon_List[#self._unlearned_skill_List].skillBox = UI.getChildControl(self._skillIcon_List[#self._unlearned_skill_List].skillBg, "Static_SelectBox")
        self._skillIcon_List[#self._unlearned_skill_List].skillCheckIcon = UI.getChildControl(self._skillIcon_List[#self._unlearned_skill_List].skillBg, "Static_HopeSKillIcon")
        self._skillIcon_List[#self._unlearned_skill_List].skillIcon = UI.getChildControl(self._skillIcon_List[#self._unlearned_skill_List].skillBg, "Static_SelectSKill")
        self._skillIcon_List[#self._unlearned_skill_List].skillIcon:SetMonoTone(true)
      end
      self._skillIcon_List[#self._unlearned_skill_List].skillName = skillWrapper:getName()
      self._skillIcon_List[#self._unlearned_skill_List].skillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
    end
  end
  self._ui.static_SkillIcon_Group:SetRectClipOnArea(float2(0, 0), float2(self._ui.static_SkillIcon_Group:GetSizeX(), self._ui.static_SkillIcon_Group:GetSizeY()))
end
function Panel_Window_StableChangeSkillSelect_info:selectHopeSkill(index)
  self._skillIcon_List[self._nowShowHopeSkill].skillBox:SetShow(false)
  self._skillIcon_List[index].skillBox:SetShow(true)
  self._ui.staticText_SkillName3:SetText(self._skillIcon_List[index].skillName)
  self._nowShowHopeSkill = index
end
function Panel_Window_StableChangeSkillSelect_info:changeHopeSkill(changeValue)
  local tabIndex = self._nowShowHopeSkill + changeValue
  if tabIndex <= 0 then
    tabIndex = #self._unlearned_skill_List
  elseif tabIndex > #self._unlearned_skill_List then
    tabIndex = 1
  end
  if self._nowShowHopeSkill > 0 then
    self._skillIcon_List[self._nowShowHopeSkill].skillBox:SetShow(false)
  end
  self._skillIcon_List[tabIndex].skillBox:SetShow(true)
  self._ui.staticText_SkillName3:SetText(self._skillIcon_List[tabIndex].skillName)
  self._nowShowHopeSkill = tabIndex
  self:setSkillIconAllReposition(tabIndex)
end
function Input_StableChangeSkillSelect_PressedLT()
  local self = Panel_Window_StableChangeSkillSelect_info
  if 1 > #self._unlearned_skill_List then
    return
  end
  self:changeHopeSkill(-1)
end
function Input_StableChangeSkillSelect_PressedRT()
  local self = Panel_Window_StableChangeSkillSelect_info
  if 1 > #self._unlearned_skill_List then
    return
  end
  self:changeHopeSkill(1)
end
function Panel_Window_StableChangeSkillSelect_info:changeTargetHopeSkill(index)
  if nil == self._unlearned_skill_List[index] then
    return
  end
  local servantInfo = self._current_servantInfo
  if nil == servantInfo then
    return
  end
  if not servantInfo:isLearnSkill(self._unlearned_skill_List[index]) then
    return
  end
  local skillWrapper = servantInfo:getSkillXXX(self._unlearned_skill_List[index])
  if nil == skillWrapper then
    return
  end
  if nil ~= self._selected_hopeSkillNo then
    self._skillIcon_List[self._selected_hopeSkillNo].skillCheckIcon:SetShow(false)
  end
  self._skillIcon_List[index].skillCheckIcon:SetShow(true)
  self._ui.static_SkillIcon2:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  self._ui.staticText_SkillName2:SetText(skillWrapper:getName())
  self._selected_hopeSkillNo = index
end
function Input_StableChangeSkillSelect_PadButtonDown_A()
  local self = Panel_Window_StableChangeSkillSelect_info
  self:changeTargetHopeSkill(self._nowShowHopeSkill)
end
function Input_StableChangeSkillSelect_PadButtonDown_Y()
  PaGlobalFunc_StableChangeSkillSelect_SelectSkillChange()
end
function PaGlobalFunc_StableChangeSkillSelect_SelectSkillChange()
  if nil == PaGlobalFunc_StableList_SelectSlotNo() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_STABLE_ALERT"))
    return
  end
  local self = Panel_Window_StableChangeSkillSelect_info
  local servantInfo = self._current_servantInfo
  if nil == servantInfo then
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  if CppEnums.ServantStateType.Type_StallionTraining == servantInfo:getStateType() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_CONDITION_STALLIONDESC"))
    return
  end
  local skillWrapper = servantInfo:getSkill(self._current_skillNo)
  if nil == skillWrapper then
    return
  end
  if nil == self._selected_hopeSkillNo then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_CHANGESKILL_BTN")
    local messageboxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SKILLCHANGE_MSG", "skillname", skillWrapper:getName())
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = PaGlobalFunc_StableChangeSkillSelect_SkillChangeXXX,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_StableChangeSkillSelect_SkillChangeXXX()
  audioPostEvent_SystemUi(3, 19)
  local self = Panel_Window_StableChangeSkillSelect_info
  stable_changeSkill(PaGlobalFunc_StableList_SelectSlotNo(), self._current_skillNo, self._unlearned_skill_List[self._selected_hopeSkillNo])
end
function FromClient_StableChangeSkil_ChangeSkillSelect_Complete(oldSkillKey, newSkillKey)
  local self = Panel_Window_StableChangeSkillSelect_info
  local servantInfo = stable_getServant(PaGlobalFunc_StableList_SelectSlotNo())
  local skillWrapper = servantInfo:getSkill(newSkillKey)
  local oldSkillWrapper = servantInfo:getSkillXXX(oldSkillKey)
  local beforHopeSkill = self._unlearned_skill_List[self._selected_hopeSkillNo]
  if nil == servantInfo then
    return
  end
  self._current_servantInfo = servantInfo
  self._current_skillNo = newSkillkey
  if nil == skillWrapper or nil == oldSkillWrapper then
    return
  end
  local msg = {
    main = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_STABLE_CHANGESKILL_MSG_MAIN_CHANGESKILL", "oldSkill", oldSkillWrapper:getName(), "newSkill", skillWrapper:getName()),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_STABLE_CHANGESKILL_MSG_SUB_CONGRATULATION")
  }
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, 6, 32)
  if beforHopeSkill ~= newSkillKey then
    self:setData(newSkillKey)
    self:setSkillIconAllReposition()
    self:update()
    local tempShowIndex = 1
    for ii = 1, #self._unlearned_skill_List do
      if nil ~= self._unlearned_skill_List[ii] and self._unlearned_skill_List[ii] == beforHopeSkill then
        tempShowIndex = ii
        break
      end
    end
    self:changeTargetHopeSkill(tempShowIndex)
    self:selectHopeSkill(tempShowIndex)
  else
    self:close()
  end
end
function Panel_Window_StableChangeSkillSelect_info:close()
  self._current_skillNo = nil
  self._current_servantInfo = nil
  self._selected_hopeSkillNo = nil
  self._nowShowHopeSkill = 0
  for ii = 1, #self._skillIcon_List do
    if nil ~= self._skillIcon_List[ii] and true == self._skillIcon_List[ii].skillBg:GetShow() then
      self._skillIcon_List[ii].skillBg:SetShow(false)
      self._skillIcon_List[ii].skillCheckIcon:SetShow(false)
      self._skillIcon_List[ii].skillBox:SetShow(false)
    end
  end
  _panel:SetShow(false)
  PaGlobalFunc_StableChangeSkill_RePosition()
  ToClient_padSnapResetControl()
end
function Panel_Window_StableChangeSkillSelect_info:update()
  local servantInfo = self._current_servantInfo
  if nil == self._current_skillNo and nil == servantInfo then
    return
  end
  local skillWrapper = servantInfo:getSkill(self._current_skillNo)
  if nil == skillWrapper then
    return
  end
  self._ui.static_SkillIcon1:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  self._ui.static_SkillCircleProgress1:SetProgressRate(servantInfo:getSkillExp(self._current_skillNo) / (skillWrapper:getMaxExp() / 100))
  self._ui.staticText_SkillName1:SetText(skillWrapper:getName())
  self._ui.staticText_SkillStack:SetText(self._oriText_skillStack .. " : " .. servantInfo:getSkillFailedCount())
end
function PaGlobalFunc_StableChangeSkill_RePosition()
  local defaultPosX = getOriginScreenSizeX() / 2 - Panel_Window_Stable_ChangeSkill:GetSizeX() / 2
  if true == _panel:GetShow() then
    defaultPosX = defaultPosX - Panel_Window_Stable_ChangeSkill:GetSizeX() / 2
    Panel_Window_Stable_ChangeSkill:SetPosX(defaultPosX)
    _panel:SetPosX(Panel_Window_Stable_ChangeSkill:GetPosX() + Panel_Window_Stable_ChangeSkill:GetSizeX())
  else
    Panel_Window_Stable_ChangeSkill:SetPosX(defaultPosX)
  end
end
function PaGlobalFunc_StableChangeSkillSelect_Open(skillKey)
  if nil == skillKey then
    return
  end
  local self = Panel_Window_StableChangeSkillSelect_info
  self:setData(skillKey)
  self:setSkillIconAllReposition()
  self:open()
end
function Panel_Window_StableChangeSkillSelect_info:setSkillIconAllReposition(tabIndex)
  local sizeX = 0
  local spanX = 10
  local tempList = {}
  for ii = 1, #self._skillIcon_List do
    if ii > #self._unlearned_skill_List then
      if nil ~= self._skillIcon_List[ii] then
        self._skillIcon_List[ii].skillBg:SetShow(false)
      end
    elseif nil ~= self._skillIcon_List[ii] then
      self._skillIcon_List[ii].skillBg:SetShow(true)
      sizeX = sizeX + self._skillIcon_List[ii].skillBg:GetSizeX() + spanX
      tempList[#tempList + 1] = ii
    end
  end
  local nextPosX = (self._ui.static_SkillIcon_Group:GetSizeX() - sizeX) / 2
  if nil == tabIndex then
    if self._maxVisibleCnt < #tempList then
      nextPosX = 0
    end
    for ii = 1, #tempList do
      if nil ~= self._skillIcon_List[ii] then
        self._skillIcon_List[ii].skillBg:SetPosX(nextPosX)
        nextPosX = nextPosX + self._ui.static_SkillIconBg:GetSizeX() + spanX
      end
    end
  else
    if self._maxVisibleCnt > #tempList then
      return
    end
    if tabIndex <= self._maxVisibleCnt then
      nextPosX = 0
    else
      local tempIndex = tabIndex - self._maxVisibleCnt
      local tempSizeX = self._ui.static_SkillIconBg:GetSizeX() / 2
      nextPosX = -(tempSizeX + (self._ui.static_SkillIconBg:GetSizeX() + spanX) * tempIndex)
    end
    for ii = 1, #tempList do
      if nil ~= self._skillIcon_List[ii] then
        self._skillIcon_List[ii].skillBg:SetPosX(nextPosX)
        nextPosX = nextPosX + self._ui.static_SkillIconBg:GetSizeX() + spanX
      end
    end
  end
end
function PaGlobalFunc_StableChangeSkillSelect_Exit()
  local self = Panel_Window_StableChangeSkillSelect_info
  self:close()
end
function PaGlobalFunc_StableChangeSkillSelect_Close()
  local self = Panel_Window_StableChangeSkillSelect_info
  self:close()
end
function FromClient_StableChangeSkilSelect_luaLoadComplete()
  local self = Panel_Window_StableChangeSkillSelect_info
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableChangeSkilSelect_luaLoadComplete")
