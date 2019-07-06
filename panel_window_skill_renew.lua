local Window_SkillInfo = {
  _ui = {
    _body = {},
    _right = {},
    _static_BodyBg = UI.getChildControl(Panel_Window_Skill, "Static_BodyBg"),
    _static_RightBg = UI.getChildControl(Panel_Window_Skill, "Static_RightBg"),
    _static_IconEffect = UI.getChildControl(Panel_Window_Skill, "Static_Icon_Skill_Effect")
  },
  _config = {_title_Basic = 0, _title_Awaken = 1},
  _combatSkill = {},
  _awakenSkill = {},
  _fusionSkill = {},
  _combatTable = {
    _skillCount = 0,
    _skillTable = {}
  },
  _awakenTable = {
    _skillCount = 0,
    _skillTable = {}
  },
  _currentSkillListInfo = {},
  _currentSkillListUI = {},
  _currentSkillIndex = 0,
  _lastSelectedUI = nil,
  _currentTitle = 0,
  _renderMode,
  _isLDown = false,
  _isRDown = false,
  _movePosX = 0,
  _movePosY = 0,
  _needMantalString,
  _mantalString,
  _defaultDividerPosY,
  _currentTabIndex = 0,
  _maxTabIndex = 0,
  _remainSkillPoint,
  _selfPlayerLevel,
  _isDialog = false,
  _isBlackSkillDesc = false,
  _prevScrollIndex = 0,
  _isAllSkillShow = false,
  _learnSync = true,
  _indexToLearn = nil
}
local RequiredDescString = {
  _level = PAGetString(Defines.StringSheet_GAME, "LUA_CONSOLE_SKILL_REQUIRED_LEVEL_TITLE"),
  _skillPoint = PAGetString(Defines.StringSheet_GAME, "LUA_CONSOLE_SKILL_REQUIRED_SKILL_POINTS_TITLE"),
  _reuseCycle = PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_SKILL_TXT_REUSECYCLE")
}
function Window_SkillInfo:GetFusionSkillFromCell(cellTable)
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  local index = 0
  local skillIndex = 0
  local table = {}
  for row = 0, rows - 1 do
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      if true == cell:isSkillType() then
        local maxFusionSkill = ToClient_getFusionSkillListCount(index)
        for fusionIndex = 0, maxFusionSkill - 1 do
          local fusionSkillNo = ToClient_getFusionSkillNo(index, fusionIndex)
          local fusionMainNo = ToClient_getFusionMainSkillNo(index, fusionIndex)
          local fusionSubNo = ToClient_getFusionSubSkillNo(index, fusionIndex)
          table[skillIndex] = self:SetSkillInfo(fusionSkillNo)
          local skillTypeStaticWrapper = getSkillTypeStaticStatus(fusionMainNo)
          if nil == skillTypeStaticWrapper then
            return
          end
          local skillLearndLevel = getLearnedSkillLevel(skillTypeStaticWrapper)
          table[skillIndex]._learndLevelMainSkill = skillLearndLevel
          skillTypeStaticWrapper = getSkillTypeStaticStatus(fusionSubNo)
          if nil == skillTypeStaticWrapper then
            return
          end
          skillLearndLevel = getLearnedSkillLevel(skillTypeStaticWrapper)
          table[skillIndex]._learndLevelSubSkill = skillLearndLevel
          if 1 == table[skillIndex]._learndLevelMainSkill and 1 == table[skillIndex]._learndLevelSubSkill then
            table[skillIndex]._learnable = true
          else
            table[skillIndex]._learnable = false
          end
          skillIndex = skillIndex + 1
        end
        index = index + 1
      end
    end
  end
  return table
end
function Window_SkillInfo:GetSkillFromCell(cellTable)
  local cols = cellTable:capacityX()
  local rows = cellTable:capacityY()
  local index = 0
  local table = {}
  for row = 0, rows - 1 do
    for col = 0, cols - 1 do
      local cell = cellTable:atPointer(col, row)
      local skillNo = cell._skillNo
      if true == cell:isSkillType() and false == PaGlobalFunc_Skill_IsBlockByConsoleSkill(skillNo) then
        local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
        if 90 ~= skillNo and true == skillTypeStaticWrapper:isValidLocalizing() then
          table[index] = self:SetSkillInfo(skillNo)
          index = index + 1
        end
      end
    end
  end
  return table
end
function Window_SkillInfo:SetSkillInfo(skillNo)
  local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillNo)
  if nil == skillTypeStaticWrapper then
    return
  end
  local skillTypeStatic = skillTypeStaticWrapper:get()
  if nil == skillTypeStatic then
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillNo)
  local skillLearndLevel = getLearnedSkillLevel(skillTypeStaticWrapper)
  local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
  if nil == skillStaticWrapper then
    return
  end
  local skillStatic = skillStaticWrapper:get()
  if nil == skillStatic then
    return
  end
  local havePrevActionHashKey = ToClient_LearnSkillCameraHavePrevActionHashKey(skillStatic)
  local skillAwakenStr = ""
  local activeSkillSS
  local isAwakeningData = false
  if true == skillStaticWrapper:isActiveSkillHas() and false == skillStaticWrapper:isFusionSkill() then
    activeSkillSS = getActiveSkillStatus(skillStaticWrapper)
    if nil ~= activeSkillSS then
      local awakeInfo = ""
      local awakeningDataCount = activeSkillSS:getSkillAwakenInfoCount() - 1
      local realCount = 0
      for idx = 0, awakeningDataCount do
        local skillInfo = activeSkillSS:getSkillAwakenInfo(idx)
        if "" ~= skillInfo then
          awakeInfo = awakeInfo .. "\n" .. skillInfo
          realCount = realCount + 1
        end
      end
      skillAwakenStr = awakeInfo
      isAwakeningData = realCount > 0
    end
  end
  local skillAwakenTitleStr = PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_SKILL_TXT_AWAKEN")
  local buffStr = skillStaticWrapper:getDescription()
  if true == skillLevelInfo._usable and true == isAwakeningData then
    buffStr = buffStr .. [[


]] .. skillAwakenTitleStr .. skillAwakenStr
  end
  local skillInfo = {
    _no = skillNo,
    _name = skillTypeStaticWrapper:getName(),
    _learndLevel = skillLearndLevel,
    _learnable = skillLevelInfo._learnable,
    _usable = skillLevelInfo._usable,
    _command = skillTypeStaticWrapper:getCommand(),
    _mainCommand = skillTypeStaticWrapper:getSimpleCommand(),
    _iconPath = skillTypeStaticWrapper:getIconPath(),
    _desc = skillTypeStaticWrapper:getDescription(),
    _buffDesc = buffStr,
    _requireHp = skillStatic._requireHp,
    _requireMp = skillStatic._requireMp,
    _requireSp = skillStatic._requireSp,
    _reuseCycle = skillStatic._reuseCycle,
    _needCharacterLevel = skillStatic._needCharacterLevelForLearning,
    _needSkillPoint = skillStatic._needSkillPointForLearning,
    _blackSkillNo = skillStaticWrapper:getlinkBlackSkillNo(),
    _isCommand = skillTypeStaticWrapper:isSkillCommandCheck(),
    _isLock = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey),
    _learndLevelMainSkill = 0,
    _learndLevelSubSkill = 0,
    _havePrevActionHashKey = havePrevActionHashKey
  }
  if false == skillInfo._usable or false == skillInfo._isCommand then
    skillInfo._isLock = false
  end
  return skillInfo
end
function PaGlobalFunc_Skill_LockButton()
  local self = Window_SkillInfo
  local skillInfo = self._currentSkillListInfo[self._currentSkillIndex]
  if nil == skillInfo then
    return
  end
  if false == skillInfo._isCommand then
    return
  end
  local skillLevelInfo = getSkillLevelInfo(skillInfo._no)
  if nil == skillLevelInfo then
    return
  end
  if false == skillLevelInfo._usable then
    if false == skillInfo._isCommand then
      skillInfo._isLock = false
    end
    return
  end
  if true == skillLevelInfo._learnable then
    return
  end
  local isBlockSkill = ToClient_isBlockSkillCommand(skillLevelInfo._skillKey)
  if true == isBlockSkill then
    ToClient_enableSkillCommand(skillLevelInfo._skillKey)
    skillInfo._isLock = false
  else
    ToClient_blockSkillCommand(skillLevelInfo._skillKey)
    skillInfo._isLock = true
  end
  self._currentSkillListInfo[self._currentSkillIndex] = skillInfo
  self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, self._currentSkillIndex))
end
function PaGlobalFunc_Skill_ToggleSkillDesc()
  local self = Window_SkillInfo
  local skillInfo = self._currentSkillListInfo[self._currentSkillIndex]
  if nil == skillInfo then
    return
  end
  if 0 == skillInfo._blackSkillNo then
    return
  end
  self._isBlackSkillDesc = not self._isBlackSkillDesc
  PaGlobalFunc_Skill_SelectSkill(self._currentSkillIndex, self._isBlackSkillDesc)
end
function PaGlobalFunc_Skill_LearnButton(skillIndex)
  local self = Window_SkillInfo
  if nil == skillIndex then
    return
  end
  if false == self._learnSync then
    return
  end
  local skillInfo = self._currentSkillListInfo[skillIndex]
  if nil == skillInfo then
    return
  end
  if false == skillInfo._learnable then
    return
  end
  self._indexToLearn = skillIndex
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
  local messageboxContent = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_RECRUITMENT_SKILLSTUDY")
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxContent,
    functionYes = PaGlobalFunc_Skill_LearnConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_Skill_LearnConfirm()
  local self = Window_SkillInfo
  if nil == self._indexToLearn then
    return
  end
  local skillInfo = self._currentSkillListInfo[self._indexToLearn]
  if nil == skillInfo then
    return
  end
  local isSuccess = skillWindow_DoLearn(skillInfo._no)
  if true == isSuccess then
    _AudioPostEvent_SystemUiForXBOX(4, 2)
    self._learnSync = false
    self._indexToLearn = nil
  end
end
function PaGlobalFunc_Skill_ResetButton()
  local strTemp1 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_TITLE")
  local strTemp2 = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SKILL_CLEAR_COMBAT_SKILL_MESSAGE")
  local messageboxData = {
    title = strTemp1,
    content = strTemp2,
    functionYes = PaGlobalFunc_Skill_ResetConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_Skill_ResetConfirm()
  local self = Window_SkillInfo
  skillWindow_ClearSkill()
  PaGlobalFunc_Skill_SelectTitle(self._currentTitle)
end
function PaGlobalFunc_Skill_SelectTitle(titleType)
  local self = Window_SkillInfo
  local allSkill = self._ui._right._radioButton_AllSkill
  local learnSkill = self._ui._right._radioButton_LearnSkill
  local basicSkill = self._ui._right._radioButton_SkillBasic
  local awakenSkill = self._ui._right._radioButton_SkillAwaken
  self._currentTabIndex = titleType
  self:Clear()
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_LSClick, "")
  self._ui._right._static_SellectLeft:SetShow(false)
  self._ui._right._static_SellectRight:SetShow(false)
  if false == self._isAllSkillShow then
    learnSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
    if self._config._title_Basic == titleType then
      basicSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
    else
      awakenSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
    end
    self._ui._right._radioButton_learnSkillKey:SetShow(true)
    self._ui._right._radiobutton_ResetSkillKey:SetShow(false)
    self._ui._right._radioButton_SkillDemo:SetShow(false)
    self._ui._right._txt_SkillLock:SetShow(false)
    self:SetLearnableSkillList()
  else
    allSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
    if self._config._title_Basic == titleType then
      self._ui._right._radioButton_learnSkillKey:SetShow(false)
      self._ui._right._radiobutton_ResetSkillKey:SetShow(true)
      self._ui._right._staticText_LearnableEmpty:SetShow(false)
      self._ui._right._radioButton_SkillDemo:SetShow(true)
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Skill_SkillAction()")
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Skill_ResetButton()")
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_LSClick, "PaGlobalFunc_Skill_LockButton()")
      basicSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
      self:SetSkillList(self._combatTable)
    elseif self._config._title_Awaken == titleType then
      self._ui._right._radioButton_learnSkillKey:SetShow(false)
      self._ui._right._radiobutton_ResetSkillKey:SetShow(true)
      self._ui._right._staticText_LearnableEmpty:SetShow(false)
      self._ui._right._radioButton_SkillDemo:SetShow(true)
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Skill_SkillAction()")
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Skill_ResetButton()")
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_LSClick, "PaGlobalFunc_Skill_LockButton()")
      awakenSkill:SetFontColor(Defines.Color.C_FFEEEEEE)
      self:SetSkillList(self._awakenTable)
    end
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup, self._ui._right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup2, self._ui._right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
end
function Window_SkillInfo:SetLearnableSkillList()
  local index = 0
  local body = self._ui._body
  self._ui._right._list2_Skill:getElementManager():clearKey()
  if self._config._title_Basic == self._currentTabIndex then
    for tableIndex = 0, #self._combatTable do
      local skillCount = self._combatTable[tableIndex]._skillCount
      local skillTable = self._combatTable[tableIndex]._skillTable
      if nil == skillTable then
        return
      end
      for skillIndex = 0, skillCount - 1 do
        local skillInfo = skillTable[skillIndex]
        if nil == skillInfo then
          return
        end
        if true == skillInfo._learnable then
          self._currentSkillListInfo[index] = skillInfo
          self._ui._right._list2_Skill:getElementManager():pushKey(toInt64(0, index))
          self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, index))
          index = index + 1
        end
      end
    end
  else
    for tableIndex = 0, #self._awakenTable do
      local skillCount = self._awakenTable[tableIndex]._skillCount
      local skillTable = self._awakenTable[tableIndex]._skillTable
      if nil == skillTable then
        return
      end
      for skillIndex = 0, skillCount - 1 do
        local skillInfo = skillTable[skillIndex]
        if nil == skillInfo then
          return
        end
        if true == skillInfo._learnable then
          self._currentSkillListInfo[index] = skillInfo
          self._ui._right._list2_Skill:getElementManager():pushKey(toInt64(0, index))
          self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, index))
          index = index + 1
        end
      end
    end
  end
  self._ui._right._staticText_LearnableEmpty:SetShow(0 == index)
  if 0 == index then
    body._staticText_RequireLevelInfo:SetText("")
    body._staticText_RequireSkillPointsInfo:SetText("")
    body._staticText_ReuseCycle:SetText("")
  end
  self._ui._right._radioButton_learnSkillKey:SetShow(0 ~= index)
end
function Window_SkillInfo:SetSkillList(table)
  local index = 0
  self._ui._right._list2_Skill:getElementManager():clearKey()
  local isNext = false
  for tableIndex = 0, #table do
    local skillCount = table[tableIndex]._skillCount
    local skillTable = table[tableIndex]._skillTable
    if nil == skillTable then
      return
    end
    isNext = false
    for skillIndex = 0, skillCount - 1 do
      local skillInfo = skillTable[skillIndex]
      if nil == skillInfo then
        return
      end
      if true == isNext then
        skillIndex = skillCount
      else
        if 0 == skillIndex and 0 == skillInfo._learndLevel then
          self._currentSkillListInfo[index] = skillInfo
          self._ui._right._list2_Skill:getElementManager():pushKey(toInt64(0, index))
          self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, index))
          index = index + 1
          isNext = true
        end
        if 1 == skillInfo._learndLevel then
          self._currentSkillListInfo[index] = skillInfo
          self._ui._right._list2_Skill:getElementManager():pushKey(toInt64(0, index))
          self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, index))
          index = index + 1
          isNext = true
        end
      end
    end
  end
end
function PaGlobalFunc_Skill_List2EventControlCreate(list_content, key)
  local self = Window_SkillInfo
  local id = Int64toInt32(key)
  local skillInfo = self._currentSkillListInfo[id]
  local right = self._ui._right
  if nil == skillInfo then
    self._ui._right._list2_Skill:getElementManager():removeKey(toInt64(0, id))
    return
  end
  local uiInfo = {
    _content = list_content,
    _radioButton_SkillBg = UI.getChildControl(list_content, "Radio_SkillBg"),
    _static_SelectedSkillBg = UI.getChildControl(list_content, "Static_SelectedSkillBg"),
    _static_SkillIcon = UI.getChildControl(list_content, "Static_Skill_Box2"),
    _staticText_Name = UI.getChildControl(list_content, "StaticText_Skill_Name"),
    _staticText_RequireLevel = UI.getChildControl(list_content, "StaticText_Skill_Require_Level"),
    _static_LockIcon = UI.getChildControl(list_content, "Static_Skill_Lock_Icon"),
    _progress2_ProgressBar = UI.getChildControl(list_content, "Progress2_1"),
    _static_mainCommand = UI.getChildControl(list_content, "StaticText_SkillCommand")
  }
  local rate = 100 * self._remainSkillPoint / skillInfo._needSkillPoint
  if 1 == skillInfo._learndLevel then
    rate = 100
  end
  uiInfo._static_LockIcon:SetShow(skillInfo._isLock)
  self._ui._right._txt_SkillLock:SetShow(true == skillInfo._isCommand and false == skillInfo._learnable and true == skillInfo._usable)
  local blackSkillTypeSS = getSkillTypeStaticStatus(skillInfo._blackSkillNo)
  if 0 ~= skillInfo._blackSkillNo and nil ~= blackSkillTypeSS and blackSkillTypeSS:isValidLocalizing() then
    self._ui._body._txt_toggleBlackSkillDesc:SetShow(true)
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_RSClick, "PaGlobalFunc_Skill_ToggleSkillDesc()")
  else
    self._ui._body._txt_toggleBlackSkillDesc:SetShow(false)
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_RSClick, "")
  end
  uiInfo._progress2_ProgressBar:SetProgressRate(rate)
  uiInfo._static_SelectedSkillBg:SetShow(self._currentSkillIndex == id)
  if nil ~= skillInfo._mainCommand then
    uiInfo._static_mainCommand:SetText(skillInfo._mainCommand)
    uiInfo._static_mainCommand:SetShow(true)
  else
    uiInfo._static_mainCommand:SetText("")
    uiInfo._static_mainCommand:SetShow(false)
  end
  uiInfo._static_SkillIcon:SetShow(true)
  uiInfo._static_SkillIcon:ChangeTextureInfoNameAsync("icon/" .. skillInfo._iconPath)
  uiInfo._staticText_Name:SetText(skillInfo._name)
  local requireDesc = self:GetRequireDesc(uiInfo._static_SelectedSkillBg, uiInfo._staticText_RequireLevel, id)
  uiInfo._staticText_RequireLevel:SetShow("" ~= requireDesc)
  uiInfo._staticText_RequireLevel:SetText(requireDesc)
  self._currentSkillListUI[id] = uiInfo
  if false == self._isAllSkillShow or self._currentSkillIndex ~= id then
    uiInfo._progress2_ProgressBar:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_LearnButton(" .. id .. ")")
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "")
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "")
  else
    uiInfo._progress2_ProgressBar:addInputEvent("Mouse_LUp", "")
    if _ContentsGroup_isConsolePadControl then
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_Skill_SkillHandle(" .. tostring(id) .. ",-1)")
      Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_Skill_SkillHandle(" .. tostring(id) .. ",1)")
    end
  end
  if _ContentsGroup_isConsolePadControl then
    uiInfo._progress2_ProgressBar:addInputEvent("Mouse_On", "PaGlobalFunc_Skill_SelectSkill(" .. id .. "," .. "false" .. ")")
    uiInfo._progress2_ProgressBar:addInputEvent("Mouse_Out", "PaGlobalFunc_Skill_MouseOutSkill()")
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup, self._ui._right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup2, self._ui._right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
end
function Window_SkillInfo:GetRequireDesc(selectControl, descControl, id)
  local skillInfo = self._currentSkillListInfo[id]
  local body = self._ui._body
  local desc = ""
  if nil == skillInfo then
    return desc
  end
  body._staticText_RequireLevelInfo:SetText("")
  body._staticText_RequireSkillPointsInfo:SetText("")
  body._staticText_ReuseCycle:SetText("")
  if 1 == skillInfo._learndLevel then
  elseif true == skillInfo._learnable then
  elseif 0 ~= skillInfo._needCharacterLevel and self._selfPlayerLevel < skillInfo._needCharacterLevel then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(skillInfo._needCharacterLevel)
  end
  if self._selfPlayerLevel >= skillInfo._needCharacterLevel then
    body._staticText_RequireLevelInfo:SetFontColor(Defines.Color.C_FFEEEEEE)
  else
    body._staticText_RequireLevelInfo:SetFontColor(Defines.Color.C_FFDDA309)
  end
  if self._remainSkillPoint >= skillInfo._needSkillPoint then
    body._staticText_RequireSkillPointsInfo:SetFontColor(Defines.Color.C_FFEEEEEE)
  else
    body._staticText_RequireSkillPointsInfo:SetFontColor(Defines.Color.C_FFDDA309)
  end
  body._staticText_RequireLevelInfo:SetText(RequiredDescString._level .. ": " .. skillInfo._needCharacterLevel)
  body._staticText_RequireSkillPointsInfo:SetText(RequiredDescString._skillPoint .. " " .. skillInfo._needSkillPoint)
  body._staticText_ReuseCycle:SetText(RequiredDescString._reuseCycle .. " " .. skillInfo._reuseCycle / 1000)
  return desc
end
function Window_SkillInfo:FindSkillCount(skillInfo)
  if self._config._title_Basic == self._currentTitle then
    for tableIndex = 0, #self._combatTable do
      local combatTable = self._combatTable[tableIndex]
      if nil ~= combatTable then
        local skillCount = combatTable._skillCount
        local skillTable = combatTable._skillTable
        if nil == skillTable then
          return
        end
        for skillIndex = 0, skillCount - 1 do
          if skillTable[skillIndex] == skillInfo then
            return skillCount
          end
        end
      end
    end
  else
    for tableIndex = 0, #self._awakenTable do
      local awakenTable = self._awakenTable[tableIndex]
      if nil ~= awakenTable then
        local skillCount = awakenTable._skillCount
        local skillTable = awakenTable._skillTable
        if nil == skillTable then
          return
        end
        for skillIndex = 0, skillCount - 1 do
          if skillTable[skillIndex] == skillInfo then
            return skillCount
          end
        end
      end
    end
  end
  return 1
end
function PaGlobalFunc_Skill_SkillHandle(id, direction)
  local self = Window_SkillInfo
  local skillInfo = self._currentSkillListInfo[id]
  local findTableIndex = -1
  local findSkillIndex = -1
  if nil == skillInfo then
    return
  end
  if self._config._title_Basic == self._currentTitle then
    for tableIndex = 0, #self._combatTable do
      local skillCount = self._combatTable[tableIndex]._skillCount
      local skillTable = self._combatTable[tableIndex]._skillTable
      if nil == skillTable then
        return
      end
      for skillIndex = 0, skillCount - 1 do
        if skillTable[skillIndex] == skillInfo then
          findTableIndex = tableIndex
          findSkillIndex = skillIndex
          break
        end
      end
    end
  else
    for tableIndex = 0, #self._awakenTable do
      local skillCount = self._awakenTable[tableIndex]._skillCount
      local skillTable = self._awakenTable[tableIndex]._skillTable
      if nil == skillTable then
        return
      end
      for skillIndex = 0, skillCount - 1 do
        if skillTable[skillIndex] == skillInfo then
          findTableIndex = tableIndex
          findSkillIndex = skillIndex
          break
        end
      end
    end
  end
  if -1 == findTableIndex or -1 == findSkillIndex then
    return
  end
  local newSkillInfo
  if self._config._title_Basic == self._currentTitle then
    newSkillInfo = self._combatTable[findTableIndex]._skillTable[findSkillIndex + direction]
  else
    newSkillInfo = self._awakenTable[findTableIndex]._skillTable[findSkillIndex + direction]
  end
  if nil == newSkillInfo then
    return
  end
  self._currentSkillListInfo[id] = newSkillInfo
  self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, id))
  PaGlobalFunc_Skill_SelectSkill(id)
  _AudioPostEvent_SystemUiForXBOX(51, 4)
end
function PaGlobalFunc_Skill_MouseOutSkill()
  local self = Window_SkillInfo
  self._isBlackSkillDesc = false
end
function PaGlobalFunc_Skill_SelectSkill(id, isBlackSkillDesc)
  local self = Window_SkillInfo
  local body = self._ui._body
  local right = self._ui._right
  self:SkillDetailClear()
  local skillInfo = self._currentSkillListInfo[id]
  if true == isBlackSkillDesc then
    local blackSkillTypeSS = getSkillTypeStaticStatus(skillInfo._blackSkillNo)
    if nil ~= blackSkillTypeSS and blackSkillTypeSS:isValidLocalizing() then
      skillInfo = self:SetSkillInfo(skillInfo._blackSkillNo)
    end
  end
  if nil == skillInfo then
    return
  end
  local skillUI = self._currentSkillListUI[id]
  if nil == skillUI then
    return
  end
  if nil ~= self._lastSelectedUI then
    self._lastSelectedUI._static_SelectedSkillBg:SetShow(false)
  end
  skillUI._static_SelectedSkillBg:SetShow(true)
  body._staticText_EffectTitle:SetShow(true)
  body._staticText_Name:SetText(skillInfo._name)
  body._staticText_Desc:SetText(skillInfo._desc)
  body._staticText_EffectDesc:SetText(skillInfo._buffDesc)
  body._staticText_EffectTitle:SetPosY(body._staticText_EffectDesc:GetPosY() - body._staticText_EffectDesc:GetTextSizeY() + body._staticText_EffectDesc:GetSizeY() - body._staticText_EffectTitle:GetSizeY() - 5)
  local needResource = ""
  local haveResource = false
  if 1 < skillInfo._requireHp then
    needResource = needResource .. PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_SKILL_TXT_NEEDHP") .. " " .. skillInfo._requireHp .. "\n"
    haveResource = true
  end
  if 1 < skillInfo._requireMp then
    needResource = needResource .. self._needMantalString .. " " .. skillInfo._requireMp .. "\n"
    haveResource = true
  end
  if 1 < skillInfo._requireSp then
    needResource = needResource .. PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_SKILL_TXT_NEEDSP") .. " " .. skillInfo._requireSp .. "\n"
    haveResource = true
  end
  body._staticText_NeedResource:SetText(needResource)
  body._staticText_NeedResource:SetSize(body._staticText_NeedResource:GetSizeX(), body._staticText_NeedResource:GetTextSizeY())
  if body._staticText_NeedResource:GetTextSizeY() > 60 then
    body._staticText_NeedResource:SetPosY(body._staticText_RequireLevelInfo:GetPosY() - body._staticText_NeedResource:GetTextSizeY() + 27)
  else
    body._staticText_NeedResource:SetPosY(body._staticText_RequireLevelInfo:GetPosY() - 25)
  end
  body._staticText_skillCommand:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._staticText_skillCommand:SetText(skillInfo._command)
  body._staticText_skillCommand:SetPosY(body._staticText_Desc:GetPosY() + body._staticText_Desc:GetTextSizeY() + 10)
  local dividerCenterSizeY = (body._static_Divider2:GetPosY() - body._static_Divider1:GetPosY()) / 2
  local yGap = 0
  if 90 <= body._staticText_Command:GetSizeY() then
    yGap = (body._staticText_Command:GetTextSizeY() - 90) / 2
  end
  body._staticText_Command:SetText("")
  body._staticText_Command:SetPosY(body._static_Divider1:GetPosY() + dividerCenterSizeY - body._staticText_Command:GetSizeY() / 2 + yGap)
  local resourcePosY
  if true == haveResource then
    resourcePosY = body._staticText_NeedResource:GetPosY() + body._staticText_NeedResource:GetSizeY() + 10
  else
    resourcePosY = body._staticText_Desc:GetPosY() + body._staticText_Desc:GetSizeY() + 10
  end
  local commendPosY = body._staticText_Command:GetPosY() + body._staticText_Command:GetSizeY() + 10
  local needResourcePosY = math.max(resourcePosY, commendPosY)
  local dividerPosY = body._static_Divider2:GetPosY()
  self._lastSelectedUI = skillUI
  local prevIndex = self._currentSkillIndex
  self._currentSkillIndex = id
  if true == skillInfo._havePrevActionHashKey then
    self._ui._right._radioButton_SkillDemo:SetShow(true)
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Skill_SkillAction()")
  else
    self._ui._right._radioButton_SkillDemo:SetShow(false)
    Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  end
  local skillLinkedCount = self:FindSkillCount(skillInfo)
  local arrowShowAble = true == self._isAllSkillShow and skillLinkedCount > 1 and self._currentSkillIndex == id
  right._static_SellectLeft:SetShow(arrowShowAble)
  right._static_SellectRight:SetShow(arrowShowAble)
  right._static_SellectLeft:SetPosY(skillUI._content:GetPosY() + (right._list2_Skill:GetPosY() - self._ui._static_RightBg:GetPosY()))
  right._static_SellectRight:SetPosY(skillUI._content:GetPosY() + (right._list2_Skill:GetPosY() - self._ui._static_RightBg:GetPosY()))
  self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, prevIndex))
  self._ui._right._list2_Skill:requestUpdateByKey(toInt64(0, id))
end
function Window_SkillInfo:SkillDetailClear()
  local body = self._ui._body
  body._staticText_Name:SetText("")
  body._staticText_Desc:SetText("")
  body._staticText_EffectTitle:SetShow(false)
  body._staticText_EffectDesc:SetText("")
  body._staticText_NeedResource:SetText("")
  body._staticText_skillCommand:SetText("")
  body._staticText_Command:SetText("")
end
function Window_SkillInfo:UpdateSkillData()
  local selfPlayerActorProxyWrapper = getSelfPlayer()
  if nil == selfPlayerActorProxyWrapper then
    return
  end
  local classType = selfPlayerActorProxyWrapper:getClassType()
  if classType < 0 then
    return
  end
  local cellTable = getCombatSkillTree(classType)
  if nil == cellTable then
    return
  end
  self._combatSkill = {}
  self._combatSkill = self:GetSkillFromCell(cellTable)
  cellTable = nil
  cellTable = getAwakeningWeaponSkillTree(classType)
  if nil == cellTable then
    return
  end
  self._awakenSkill = {}
  self._awakenSkill = self:GetSkillFromCell(cellTable)
  cellTable = nil
  cellTable = getFusionSkillTree()
  if nil == cellTable then
    return
  end
  self._fusionSkill = {}
  self._fusionSkill = self:GetFusionSkillFromCell(cellTable)
  cellTable = nil
  for index = 0, #self._fusionSkill do
    self._combatSkill[#self._combatSkill + 1] = self._fusionSkill[index]
  end
end
function Window_SkillInfo:InitResisterEvent()
  registerEvent("EventSelfPlayerPreDead", "PaGlobalFunc_FromClient_Skill_HideByDead")
  registerEvent("EventSkillWindowUpdate", "PaGlobalFunc_FromClient_Skill_WindowUpdate")
  registerEvent("EventSkillWindowClearSkillAll", "PaGlobalFunc_FromClient_Skill_WindowUpdate")
  registerEvent("FromClient_UseSkillAskFromOtherPlayer", "FromClient_Skill_UseSkillAskFromOtherPlayer")
  registerEvent("onScreenResize", "PaGlobalFunc_Skill_Resize")
end
function PaGlobalFunc_FromClient_Skill_HideByDead()
  local self = Window_SkillInfo
  if false == PaGlobalFunc_Skill_GetShow() then
    return
  end
  PaGlobalFunc_Skill_Close()
end
function Window_SkillInfo:Initialize()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local characterActorProxyWrapper = getCharacterActor(selfPlayer:get():getActorKeyRaw())
  if nil == characterActorProxyWrapper then
    return
  end
  local mentalType = characterActorProxyWrapper:getCombatResourceType()
  if CppEnums.CombatResourceType.CombatType_MP == mentalType then
    self._needMantalString = PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedMP")
    self._mantalString = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP")
  elseif CppEnums.CombatResourceType.CombatType_FP == mentalType then
    self._needMantalString = PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedFP")
    self._mantalString = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FP")
  elseif CppEnums.CombatResourceType.CombatType_EP == mentalType then
    self._needMantalString = PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedEP")
    self._mantalString = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EP")
  elseif CppEnums.CombatResourceType.CombatType_BP == mentalType then
    self._needMantalString = PAGetString(Defines.StringSheet_GAME, "Lua_TooltipSkill_NeedBP")
    self._mantalString = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_BP")
  end
  self._renderMode = RenderModeWrapper.new(100, {
    Defines.RenderMode.eRenderMode_SkillWindow
  }, false)
  self._renderMode:setPrefunctor(self._renderMode, PaGlobalFunc_Skill_PreRenderMode)
  self._renderMode:setClosefunctor(self._renderMode, PaGlobalFunc_Skill_CloseRenderMode)
  local endPos = string.len(RequiredDescString._reuseCycle)
  RequiredDescString._reuseCycle = string.sub(RequiredDescString._reuseCycle, 3, endPos)
  self:InitControl()
  self:InitEvent()
  self:InitResisterEvent()
end
function PaGlobalFunc_Skill_PreRenderMode()
end
function PaGlobalFunc_Skill_CloseRenderMode()
  local self = Window_SkillInfo
  PaGlobalFunc_Skill_Close()
end
function Window_SkillInfo:Clear()
  self._currentSkillListInfo = {}
  self._currentSkillListUI = {}
  self:SkillDetailClear()
  self._currentSkillIndex = 0
  self._learnSync = true
  self._ui._right._radioButton_AllSkill:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui._right._radioButton_LearnSkill:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui._right._radioButton_SkillBasic:SetFontColor(Defines.Color.C_FF525B6D)
  self._ui._right._radioButton_SkillAwaken:SetFontColor(Defines.Color.C_FF525B6D)
end
function Window_SkillInfo:Update()
  self:UpdateStat()
  self:UpdateSkillData()
  self._combatTable = {}
  self._awakenTable = {}
  self:LinkSkillTable(self._combatSkill, self._combatTable)
  self:LinkSkillTable(self._awakenSkill, self._awakenTable)
  self:tableSort()
end
function Window_SkillInfo:tableSort()
  local sort = function(a, b)
    return a._needCharacterLevel < b._needCharacterLevel
  end
  for tableIndex = 0, #self._combatTable do
    local combatTable = self._combatTable[tableIndex]
    if nil ~= combatTable then
      local skillTable = combatTable._skillTable
      if nil ~= skillTable then
        table.sort(skillTable, sort)
      end
    end
  end
  for tableIndex = 0, #self._awakenTable do
    local awakenTable = self._awakenTable[tableIndex]
    if nil ~= awakenTable then
      local skillTable = awakenTable._skillTable
      if nil ~= skillTable then
        table.sort(skillTable, sort)
      end
    end
  end
end
function Window_SkillInfo:LinkSkillTable(oldTable, newTable)
  local index = 0
  local skillName = ""
  local oldSkillTable = {}
  local oldSkillIndex = 0
  local insertable = false
  local currentOldIndex = 0
  for skillIndex = 0, #oldTable do
    local skillInfo = oldTable[skillIndex]
    if nil == skillInfo then
      return
    end
    skillName = string.gsub(skillInfo._name, "I", "")
    skillName = string.gsub(skillName, "V", "")
    skillName = string.gsub(skillName, "X", "")
    skillName = string.gsub(skillName, ":", "")
    skillName = string.gsub(skillName, " ", "")
    skillName = string.gsub(skillName, "\194\160", "")
    currentOldIndex = #oldSkillTable
    for oldIndex = 0, #oldSkillTable do
      if oldSkillTable[oldIndex] == skillName then
        insertable = true
        currentOldIndex = oldIndex
        break
      end
    end
    if true == insertable then
      local skillCount = newTable[currentOldIndex]._skillCount
      newTable[currentOldIndex]._skillTable[skillCount] = skillInfo
      newTable[currentOldIndex]._skillCount = skillCount + 1
    else
      oldSkillTable[oldSkillIndex] = skillName
      oldSkillIndex = oldSkillIndex + 1
      newTable[index] = {
        _skillCount = 0,
        _skillTable = {}
      }
      newTable[index]._skillTable[0] = skillInfo
      newTable[index]._skillCount = 1
      index = index + 1
    end
    insertable = false
  end
end
function Window_SkillInfo:UpdateStat()
  local selfPlayerActorProxy = getSelfPlayer():get()
  if nil == selfPlayerActorProxy then
    return
  end
  local skillPointInfo = ToClient_getSkillPointInfo(0)
  if -1 == skillPointInfo then
    return
  end
  self._selfPlayerLevel = selfPlayerActorProxy:getLevel()
  self._remainSkillPoint = skillPointInfo._remainPoint
  local skillPoint = PAGetString(Defines.StringSheet_RESOURCE, "SKILL_TEXT_POINT") .. "  " .. tostring("<PAColor0xFFf5ba3a>" .. skillPointInfo._remainPoint) .. " / " .. tostring(skillPointInfo._acquirePoint .. "<PAOldColor>")
  self._ui._body._staticText_SkillPoint:SetText(skillPoint)
  self._ui._body._staticText_SkillPoint:SetSpanSize(self._ui._body._staticText_SkillPoint:GetSizeX() + self._ui._body._staticText_SkillPoint:GetTextSizeX() + 80, 60)
end
function Window_SkillInfo:InitControl()
  local body = self._ui._body
  local right = self._ui._right
  local ui = self._ui
  body._staticText_SkillPoint = UI.getChildControl(ui._static_BodyBg, "StaticText_SkillPoint")
  body._stc_skillDescBG = UI.getChildControl(ui._static_BodyBg, "Static_NormalDescBG")
  body._static_KeyGuide = UI.getChildControl(ui._static_BodyBg, "Static_Key_Guide")
  body._staticText_Name = UI.getChildControl(body._stc_skillDescBG, "StaticText_SkillName")
  body._staticText_Desc = UI.getChildControl(body._stc_skillDescBG, "StaticText_SkillDesc")
  body._staticText_skillCommand = UI.getChildControl(body._stc_skillDescBG, "StaticText_Skill_CommandDesc")
  body._staticText_Desc:SetAutoResize(true)
  body._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._staticText_EffectTitle = UI.getChildControl(body._stc_skillDescBG, "StaticText_Skill_Effect_Title")
  body._staticText_EffectDesc = UI.getChildControl(body._stc_skillDescBG, "StaticText_Skill_EffectDesc")
  body._staticText_EffectDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._staticText_NeedResource = UI.getChildControl(body._stc_skillDescBG, "StaticText_NeedMp")
  body._staticText_RequireLevelInfo = UI.getChildControl(body._stc_skillDescBG, "StaticText_RequiredLevel")
  body._staticText_RequireSkillPointsInfo = UI.getChildControl(body._stc_skillDescBG, "StaticText_RequiredSkillPoint")
  body._staticText_ReuseCycle = UI.getChildControl(body._stc_skillDescBG, "StaticText_ReuseCycle")
  body._staticText_NeedResource:SetAutoResize(true)
  body._txt_toggleBlackSkillDesc = UI.getChildControl(body._static_KeyGuide, "StaticText_ToggleDesc_Key")
  body._staticText_CameraRotation = UI.getChildControl(body._static_KeyGuide, "StaticText_Camera_Key")
  body._static_Divider1 = UI.getChildControl(ui._static_BodyBg, "Static_Divider1")
  body._static_Divider2 = UI.getChildControl(ui._static_BodyBg, "Static_Divider2")
  self._defaultDividerPosY = body._static_Divider2:GetPosY()
  body._staticText_Command = UI.getChildControl(ui._static_BodyBg, "StaticText_KeyGuide_Basic")
  body._staticText_Command:SetAutoResize(true)
  body._staticText_Command:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  right._staticText_LearnableEmpty = UI.getChildControl(ui._static_RightBg, "StaticText_LearnableEmpty")
  right._staticText_LearnableEmpty:SetShow(false)
  right._radioButton_AllSkill = UI.getChildControl(ui._static_RightBg, "RadioButton_AllSkill")
  right._radioButton_LearnSkill = UI.getChildControl(ui._static_RightBg, "RadioButton_LearnSkill")
  right._radioButton_SkillBasic = UI.getChildControl(ui._static_RightBg, "RadioButton_SkillBasic")
  right._radioButton_SkillAwaken = UI.getChildControl(ui._static_RightBg, "RadioButton_SkillAwaken")
  right._stc_LB = UI.getChildControl(ui._static_RightBg, "Static_LB")
  right._stc_RB = UI.getChildControl(ui._static_RightBg, "Static_RB")
  right._radioButton_LearnSkill:SetText(PAGetString(Defines.StringSheet_RESOURCE, "LUA_SKILL_TAB_LEARNABLE"))
  right._list2_Skill = UI.getChildControl(ui._static_RightBg, "List2_Skill")
  local skillContentTitle = UI.getChildControl(UI.getChildControl(right._list2_Skill, "List2_1_Content"), "StaticText_Skill_Name")
  skillContentTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  right._static_KeyGuide = UI.getChildControl(ui._static_RightBg, "Static_KeyGuide")
  right._radioButton_learnSkillKey = UI.getChildControl(right._static_KeyGuide, "Radiobutton_Learn_Skill_Key")
  right._radiobutton_ResetSkillKey = UI.getChildControl(right._static_KeyGuide, "Radiobutton_SkillPoint_Reset_Key")
  right._radioButton_SkillDemo = UI.getChildControl(right._static_KeyGuide, "Radiobutton_Demo_Key")
  right._radioButton_Close = UI.getChildControl(right._static_KeyGuide, "Radiobutton_SkillPoint_Close_Key")
  right._txt_SkillLock = UI.getChildControl(right._static_KeyGuide, "StaticText_Lock_Key")
  right._static_SellectRight = UI.getChildControl(ui._static_RightBg, "Static_SkillRightBg")
  right._static_SellectLeft = UI.getChildControl(ui._static_RightBg, "Static_SkillLeftBg")
  self._bodyKeyGuideBtnGroup = {
    body._staticText_CameraRotation
  }
  self._rightKeyGuideBtnGroup = {
    right._radiobutton_ResetSkillKey,
    right._radioButton_learnSkillKey,
    right._radioButton_Close
  }
  self._rightKeyGuideBtnGroup2 = {
    right._radioButton_SkillDemo,
    right._txt_SkillLock
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._bodyKeyGuideBtnGroup, body._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT, 104)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup, right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._rightKeyGuideBtnGroup2, right._static_KeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT)
  isAwakenWeaponContentsOpen = {
    [CppEnums.ClassType.ClassType_Warrior] = ToClient_IsContentsGroupOpen("901"),
    [CppEnums.ClassType.ClassType_Ranger] = ToClient_IsContentsGroupOpen("902"),
    [CppEnums.ClassType.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("903"),
    [CppEnums.ClassType.ClassType_Giant] = ToClient_IsContentsGroupOpen("904"),
    [CppEnums.ClassType.ClassType_Tamer] = ToClient_IsContentsGroupOpen("905"),
    [CppEnums.ClassType.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("906"),
    [CppEnums.ClassType.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("907"),
    [CppEnums.ClassType.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("908"),
    [CppEnums.ClassType.ClassType_Wizard] = ToClient_IsContentsGroupOpen("909"),
    [CppEnums.ClassType.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("910"),
    [CppEnums.ClassType.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("911"),
    [CppEnums.ClassType.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("912"),
    [CppEnums.ClassType.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("913"),
    [CppEnums.ClassType.ClassType_Combattant] = ToClient_IsContentsGroupOpen("914"),
    [CppEnums.ClassType.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("918"),
    [CppEnums.ClassType.ClassType_Lahn] = ToClient_IsContentsGroupOpen("916"),
    [CppEnums.ClassType.ClassType_Orange] = ToClient_IsContentsGroupOpen("942"),
    [CppEnums.ClassType.ClassType_ShyWomen] = ToClient_IsContentsGroupOpen("1366")
  }
  if false == isAwakenWeaponContentsOpen[getSelfPlayer():getClassType()] then
    self._maxTabIndex = 0
    right._radioButton_SkillAwaken:SetShow(false)
    right._stc_LB:SetShow(false)
    right._stc_RB:SetShow(false)
    right._radioButton_SkillBasic:SetPosX(right._radioButton_SkillBasic:GetPosX() + 100)
  else
    self._maxTabIndex = 1
  end
end
function Window_SkillInfo:InitEvent()
  local right = self._ui._right
  local body = self._ui._body
  self._ui._static_BodyBg:addInputEvent("Mouse_LDown", "PaGlobalFunc_Skill_SetPanelViewStart(true)")
  self._ui._static_BodyBg:addInputEvent("Mouse_RDown", "PaGlobalFunc_Skill_SetPanelViewStart(false)")
  self._ui._static_BodyBg:addInputEvent("Mouse_Out", "PaGlobalFunc_Skill_SetPanelViewEnd()")
  self._ui._static_BodyBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_SetPanelViewEnd(true)")
  self._ui._static_BodyBg:addInputEvent("Mouse_RUp", "PaGlobalFunc_Skill_SetPanelViewEnd(false)")
  self._ui._static_BodyBg:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_Skill_SetCameraZoom(true)")
  self._ui._static_BodyBg:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_Skill_SetCameraZoom(false)")
  right._radioButton_SkillBasic:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_SelectTitle(" .. self._config._title_Basic .. ")")
  right._radioButton_SkillAwaken:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_SelectTitle(" .. self._config._title_Awaken .. ")")
  right._radioButton_learnSkillKey:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_LearnButton()")
  right._radiobutton_ResetSkillKey:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_ResetButton()")
  right._list2_Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Skill_List2EventControlCreate")
  right._list2_Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  right._radioButton_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_Close()")
  right._radioButton_SkillDemo:addInputEvent("Mouse_LUp", "PaGlobalFunc_Skill_SkillAction()")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_LB, "Toggle_SkillTab_forPadEventFunc(-1)")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_RB, "Toggle_SkillTab_forPadEventFunc(1)")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_LT, "Toggle_ShowSkillType_forPadEventFunc()")
  Panel_Window_Skill:registerPadEvent(__eConsoleUIPadEvent_RT, "Toggle_ShowSkillType_forPadEventFunc()")
end
function PaGlobalFunc_Skill_SetPanelViewStart(isLButton)
  local self = Window_SkillInfo
  if true == isLButton then
    self._isLDown = true
  else
    self._isRDown = true
  end
  self._movePosX = getMousePosX()
  self._movePosY = getMousePosY()
end
function PaGlobalFunc_Skill_SetPanelViewEnd(isLButton)
  local self = Window_SkillInfo
  if nil == isLButton then
    self._isLDown = false
    self._isRDown = false
  elseif true == isLButton then
    self._isLDown = false
  else
    self._isRDown = false
  end
end
function PaGlobalFunc_Skill_SetCameraZoom(scrollValue)
  local upValue = 35
  if true == scrollValue then
    upValue = -upValue
  end
  ToClient_LearnSkillCameraSetZoom(upValue)
end
function PaGlobalFunc_Skill_SkillAction()
  local self = Window_SkillInfo
  local skillInfo = self._currentSkillListInfo[self._currentSkillIndex]
  if nil == skillInfo then
    return
  end
  local skillStaticStatusWrapper = getSkillStaticStatus(skillInfo._no, 1)
  ToClient_LearnSkillCameraStartSkillAction(skillStaticStatusWrapper:get())
end
function PaGlobalFunc_Skill_Open(isDialog)
  local self = Window_SkillInfo
  if true == PaGlobalFunc_Skill_GetShow() then
    return false
  end
  if nil == isDialog then
    self._isDialog = false
  else
    self._isDialog = isDialog
  end
  if true == isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLOPENALERT_INDEAD"))
    return false
  end
  if true == ToClient_getJoinGuildBattle() then
    return false
  end
  ToClient_SaveUiInfo(false)
  if true == ToClient_LearnSkillCameraIsShow() then
    return false
  end
  if false == ToClient_LearnSkillCameraIsShowable() then
    return false
  end
  if false == IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SKILLOPENALERT_INDEAD"))
    if true == self._isDialog then
      PaGlobalFunc_MainDialog_ReOpen()
    end
    return false
  end
  if true == selfPlayerIsInCompetitionArea() then
    return false
  end
  if true == ToClient_SniperGame_IsPlaying() then
    return false
  end
  if true == Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  _AudioPostEvent_SystemUiForXBOX(1, 18)
  Panel_Window_Skill:SetShow(true)
  ToClient_LearnSkillCameraShow()
  ToClient_LearnSkillCameraLoadCharcterAndCamera()
  SetUIMode(Defines.UIMode.eUIMode_SkillWindow)
  self._renderMode:set()
  self:SkillDetailClear()
  self:Update()
  ToClient_LearnSkillCameraSetRotation(-0.5, 0)
  PaGlobalFunc_Skill_SelectTitle(self._currentTitle)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_SKILL")
  return true
end
function PaGlobalFunc_Skill_Close()
  local self = Window_SkillInfo
  if false == PaGlobalFunc_Skill_GetShow() then
    return
  end
  self._currentTabIndex = 0
  if false == ToClient_LearnSkillCameraHide() then
    return
  end
  self._renderMode:reset()
  Panel_Window_Skill:SetShow(false)
  if true == self._isDialog then
    PaGlobalFunc_MainDialog_ReOpen()
  else
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function PaGlobalFunc_Skill_GetShow()
  return Panel_Window_Skill:GetShow()
end
function PaGlobalFunc_FromClient_Skill_luaLoadComplete()
  local self = Window_SkillInfo
  self:Initialize()
  self:Resize()
end
function PaGlobalFunc_FromClient_Skill_WindowUpdate()
  local self = Window_SkillInfo
  if false == PaGlobalFunc_Skill_GetShow() then
    return
  end
  self._prevScrollIndex = self._ui._right._list2_Skill:getCurrenttoIndex()
  self:Update()
  PaGlobalFunc_Skill_SelectTitle(self._currentTitle)
  self._ui._right._list2_Skill:moveIndex(self._prevScrollIndex)
  self._learnSync = true
end
function FromClient_Skill_UseSkillAskFromOtherPlayer(fromName)
  local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ANSWERSKILL_QUESTTION", "from_name", fromName)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_ANSWERSKILL_MESSAGEBOX_TITLE"),
    content = messageboxMemo,
    functionYes = PaGlobalFunc_Skill_UseSkillFromOtherYes,
    functionCancel = PaGlobalFunc_Skill_UseSkillFromOtherNo,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_Skill_UseSkillFromOtherYes()
  ToClient_AnswerUseSkill(true)
end
function PaGlobalFunc_Skill_UseSkillFromOtherNo()
  ToClient_AnswerUseSkill(false)
end
function PaGlobalFunc_Skill_IsBlockByConsoleSkill(skillNo)
  if 892 == skillNo or 890 == skillNo or 891 == skillNo then
    return true
  end
  return false
end
function Toggle_SkillTab_forPadEventFunc(value)
  local self = Window_SkillInfo
  self._currentTabIndex = self._currentTabIndex + value
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if self._currentTabIndex < 0 then
    self._currentTabIndex = self._maxTabIndex
  elseif self._maxTabIndex < self._currentTabIndex then
    self._currentTabIndex = 0
  end
  if 0 == self._currentTabIndex then
    self._currentTitle = self._config._title_Basic
    PaGlobalFunc_Skill_SelectTitle(self._config._title_Basic)
  elseif 1 == self._currentTabIndex then
    self._currentTitle = self._config._title_Awaken
    PaGlobalFunc_Skill_SelectTitle(self._config._title_Awaken)
  end
  ToClient_padSnapResetPanelControl(Panel_Window_Skill)
end
function Toggle_ShowSkillType_forPadEventFunc()
  local self = Window_SkillInfo
  self._isAllSkillShow = not self._isAllSkillShow
  PaGlobalFunc_Skill_SelectTitle(self._currentTabIndex)
  ToClient_padSnapResetPanelControl(Panel_Window_Skill)
end
function Window_SkillInfo:Resize()
end
function PaGlobalFunc_Skill_GetEffectControl()
  local self = Window_SkillInfo
  return self._ui._static_IconEffect
end
function PaGlobalFunc_Skill_GetPanel()
  return Panel_Window_Skill
end
function PaGlobalFunc_Skill_Resize()
  Window_SkillInfo:Resize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_Skill_luaLoadComplete")
