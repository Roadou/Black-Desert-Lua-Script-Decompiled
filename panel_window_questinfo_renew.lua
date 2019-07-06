local Window_QuestInfo = {
  _ui = {
    _questTitle = {},
    _questDetail = {},
    _static_RadioGroup = UI.getChildControl(Panel_Window_QuestInfo, "Static_RadioGroup"),
    _list2_Quest = UI.getChildControl(Panel_Window_QuestInfo, "List2_Quest"),
    _stc_FilterGroup = UI.getChildControl(Panel_Window_QuestInfo, "Static_FilterGroup"),
    _staticText_RadioButtonTooltip = UI.getChildControl(Panel_Window_QuestInfo, "StaticText_RadioButtonTooltip"),
    _static_KeyGuideBg = UI.getChildControl(Panel_Window_QuestInfo, "Static_KeyGuideBg"),
    _static_Title = UI.getChildControl(Panel_Window_QuestInfo, "Static_Title"),
    _baseRewardSlot = {},
    _baseRewardControl = {},
    _selectRewardSlot = {},
    _selectRewardControl = {},
    _questDetailBg = UI.getChildControl(Panel_Window_QuestInfo, "Static_QuestDetailBg"),
    _staticText_ConditionList = {},
    _expToolTip
  },
  _config = {
    _title = {
      _progress = 0,
      _main = 1,
      _recommend = 2,
      _repeat = 3
    },
    _selectRewardMax = 8,
    _baseRewardMax = 8,
    _questRewardSlotConfig = {
      _createIcon = true,
      _createBorder = true,
      _createCount = true,
      _createClassEquipBG = true,
      _createCash = true
    },
    _regionCount = CppEnums.QuestRegionType.eQuestRegionType_Count,
    _defaultRaidoButtonTooltipSizeX = 0,
    _defaultRaidoButtonTooltipSizeY = 0
  },
  _questInfo = {},
  _qusetUI = {},
  _currentTitleType = 0,
  _currentQuestIndex = 0,
  _progressTable = {},
  _recommendTable = {},
  _mainTable = {},
  _repetitionTable = {},
  _treeIndexMap = {},
  _currentTabIndex = 0,
  _giveUpQuestIndex = 0,
  _findingQuest = {_groupId = 0, _qusetId = 0},
  _currentQuestCount = 0,
  _isSortByType = true
}
local questRegion = {
  [CppEnums.QuestRegionType.eQuestRegionType_None] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_99"),
  [CppEnums.QuestRegionType.eQuestRegionType_Balenos] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_1"),
  [CppEnums.QuestRegionType.eQuestRegionType_Serendia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_2"),
  [CppEnums.QuestRegionType.eQuestRegionType_NorthCalpheon] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_3"),
  [CppEnums.QuestRegionType.eQuestRegionType_CalpheonBigCity] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_4"),
  [CppEnums.QuestRegionType.eQuestRegionType_Keplan] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_5"),
  [CppEnums.QuestRegionType.eQuestRegionType_SouthWestCalpheon] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_6"),
  [CppEnums.QuestRegionType.eQuestRegionType_Media] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_7"),
  [CppEnums.QuestRegionType.eQuestRegionType_Valencia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_8"),
  [CppEnums.QuestRegionType.eQuestRegionType_Kamasylvia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_9"),
  [CppEnums.QuestRegionType.eQuestRegionType_Drigan] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_10")
}
local _questTypeTable = {
  black = 0,
  story = 1,
  town = 2,
  adv = 3,
  trade = 4,
  craft = 5,
  rep = 6,
  count = 7
}
local _questTypeString = {
  [CppEnums.QuestType.eQuestType_BlackSpirit] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_1"),
  [CppEnums.QuestType.eQuestType_Story] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_2"),
  [CppEnums.QuestType.eQuestType_Town] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_3"),
  [CppEnums.QuestType.eQuestType_Adventure] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_4"),
  [CppEnums.QuestType.eQuestType_Trade] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_5"),
  [CppEnums.QuestType.eQuestType_Craft] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_6"),
  [CppEnums.QuestType.eQuestType_Repetition] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_7")
}
function PaGlobalFunc_Quest_RClickWorldmapQuest(groupId, questId)
  PaGlobalFunc_Quest_UpdateFindingQuestInfo(groupId, questId, true)
end
function PaGlobalFunc_Quest_DeleteNavigation()
  PaGlobalFunc_Quest_UpdateFindingQuestInfo()
end
function Window_QuestInfo:RefreshList()
  for index = 0, self._currentQuestCount - 1 do
    self._ui._list2_Quest:requestUpdateByKey(toInt64(0, index))
  end
end
function PaGlobalFunc_Quest_UpdateFindingQuestInfo(groupId, questId, isFinding)
  local self = Window_QuestInfo
  if true == isFinding and nil ~= groupId and nil ~= questId then
    self._findingQuest._groupId = groupId
    self._findingQuest._questId = questId
  else
    self._findingQuest._groupId = 0
    self._findingQuest._questId = 0
  end
  self:RefreshList()
end
function PaGlobalFunc_Quest_IsFindingQuest(groupId, qusetId)
  local self = Window_QuestInfo
  return groupId == self._findingQuest._groupId and qusetId == self._findingQuest._questId
end
function PaGlobalFunc_Quest_SelectTitleButton(value)
  local self = Window_QuestInfo
  self._currentTitleType = self._currentTitleType + value
  if self._currentTitleType < self._config._title._progress then
    self._currentTitleType = self._config._title._recommend
  end
  if self._config._title._recommend < self._currentTitleType then
    self._currentTitleType = self._config._title._progress
  end
  PaGlobalFunc_Quest_SelectQuestTitle(self._currentTitleType)
end
function PaGlobalFunc_Quest_SelectQuestTitle(questType)
  local self = Window_QuestInfo
  self._currentQuestIndex = -1
  ToClient_padSnapResetControl()
  self._currentTitleType = questType
  if self._config._title._progress == self._currentTitleType then
    self._ui._stc_FilterGroup:SetShow(true)
    self._ui._radioBtn_FilterType:SetCheck(self._isSortByType)
    self._ui._radioBtn_AreaType:SetCheck(not self._isSortByType)
    Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_Quest_ChangeType()")
    self._ui._radioButton_autoFindWay:SetShow(true)
    self._ui._radioButton_QuestGiveUp:SetShow(true)
    self._ui._questTitle._progress:SetCheck(true)
    self._ui._questTitle._main:SetCheck(false)
    self._ui._questTitle._recommend:SetCheck(false)
    titleType = self._config._title._progress
    self._ui._staticText_RadioButtonTooltip:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_TAB_PROGRESS"))
    if self._ui._staticText_RadioButtonTooltip:GetTextSizeX() > self._config._defaultRaidoButtonTooltipSizeX then
      self._ui._staticText_RadioButtonTooltip:SetSize(self._ui._staticText_RadioButtonTooltip:GetTextSizeX() + 10, self._config._defaultRaidoButtonTooltipSizeY)
    else
      self._ui._staticText_RadioButtonTooltip:SetSize(self._config._defaultRaidoButtonTooltipSizeX, self._config._defaultRaidoButtonTooltipSizeY)
    end
    self._ui._staticText_RadioButtonTooltip:SetPosX(self._ui._questTitle._progress:GetPosX() - self._ui._questTitle._progress:GetSizeX() / 2)
    self:ShowListByGroup(self._progressTable)
  elseif self._config._title._main == self._currentTitleType then
    Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
    self._ui._stc_FilterGroup:SetShow(false)
    self._ui._radioButton_autoFindWay:SetShow(true)
    self._ui._radioButton_QuestGiveUp:SetShow(false)
    self._ui._questTitle._progress:SetCheck(false)
    self._ui._questTitle._main:SetCheck(true)
    self._ui._questTitle._recommend:SetCheck(false)
    titleType = self._config._title._main
    self._ui._staticText_RadioButtonTooltip:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_QUEST_MAIN"))
    if self._ui._staticText_RadioButtonTooltip:GetTextSizeX() > self._config._defaultRaidoButtonTooltipSizeX then
      self._ui._staticText_RadioButtonTooltip:SetSize(self._ui._staticText_RadioButtonTooltip:GetTextSizeX() + 10, self._config._defaultRaidoButtonTooltipSizeY)
    else
      self._ui._staticText_RadioButtonTooltip:SetSize(self._config._defaultRaidoButtonTooltipSizeX, self._config._defaultRaidoButtonTooltipSizeY)
    end
    self._ui._staticText_RadioButtonTooltip:SetPosX(self._ui._questTitle._main:GetPosX() - self._ui._questTitle._main:GetSizeX() / 2)
    self:ShowListByGroup(self._mainTable)
  elseif self._config._title._recommend == self._currentTitleType then
    titleType = self._config._title._recommend
    self._ui._staticText_RadioButtonTooltip:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_TAB_RECOMMAND"))
    if self._ui._staticText_RadioButtonTooltip:GetTextSizeX() > self._config._defaultRaidoButtonTooltipSizeX then
      self._ui._staticText_RadioButtonTooltip:SetSize(self._ui._staticText_RadioButtonTooltip:GetTextSizeX() + 10, self._config._defaultRaidoButtonTooltipSizeY)
    else
      self._ui._staticText_RadioButtonTooltip:SetSize(self._config._defaultRaidoButtonTooltipSizeX, self._config._defaultRaidoButtonTooltipSizeY)
    end
    self._ui._staticText_RadioButtonTooltip:SetPosX(self._ui._questTitle._recommend:GetPosX() - self._ui._questTitle._recommend:GetSizeX() / 2)
    self:ShowListByGroup(self._recommendTable)
    self._ui._questTitle._progress:SetCheck(false)
    self._ui._questTitle._main:SetCheck(false)
    self._ui._questTitle._recommend:SetCheck(true)
  elseif self._config._title._repeat == self._currentTitleType then
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\160\156\235\170\169\236\157\180 \236\158\152\235\170\187 \235\144\172\236\138\181\235\139\136\235\139\164.")
  end
end
function Window_QuestInfo:GetQuestGroupByTitle(titleType)
  local questGroupList = {}
  local selfPlayerQuestInfo = ToClient_GetQuestList()
  if nil == selfPlayerQuestInfo then
    return
  end
  local questGroupCount = self:GetQuestGroupCount(titleType, selfPlayerQuestInfo)
  if -1 == questGroupCount then
    return
  end
  for groupIndex = 0, questGroupCount - 1 do
    local questGroup = self:GetQuestGroupByIndex(titleType, groupIndex, selfPlayerQuestInfo)
    if nil == questGroup then
      return
    end
    questGroupList[groupIndex] = questGroup
  end
  if self._config._title._progress == titleType then
    return self:SetProgressGroupData(questGroupCount, questGroupList)
  else
    return self:SetGroupData(questGroupCount, questGroupList)
  end
end
function Window_QuestInfo:ShowListByGroup(groupTable)
  self:DetailClear()
  self:SlotClear()
  self._questInfo = {}
  self._ui._list2_Quest:getElementManager():clearKey()
  local list2Index = 0
  local mainElement = self._ui._list2_Quest:getElementManager():getMainElement()
  if nil ~= groupTable then
    for index = 0, #groupTable do
      if nil ~= groupTable[index] and 0 ~= groupTable[index]._count and nil ~= groupTable[index]._count then
        self._questInfo[list2Index] = self:CreateGroupData(groupTable[index])
        local treeElement = mainElement:createChild(toInt64(0, list2Index))
        if self._config._title._main == self._currentTitleType or self._config._title._recommend == self._currentTitleType then
          treeElement:setIsOpen(false)
        else
          treeElement:setIsOpen(true)
        end
        list2Index = list2Index + 1
        for questIndex = 0, groupTable[index]._count - 1 do
          self._questInfo[list2Index] = groupTable[index]._questTable[questIndex]
          local subTreeElement = treeElement:createChild(toInt64(0, list2Index))
          list2Index = list2Index + 1
        end
      end
    end
  end
  self._currentQuestCount = list2Index
  self._ui._list2_Quest:getElementManager():refillKeyList()
end
function Window_QuestInfo:SetProgressGroupData(questGroupCount, questGroupList)
  local table = {}
  if true == self._isSortByType then
    for groupIndex = 0, _questTypeTable.count - 1 do
      local info = {
        _isClicked = false,
        _isGroup = true,
        _name = _questTypeString[groupIndex],
        _groupType = _questTypeString[groupIndex],
        _count = 0,
        _questTable = {}
      }
      table[groupIndex] = info
    end
  else
    for groupIndex = 0, self._config._regionCount - 1 do
      local info = {
        _isClicked = false,
        _isGroup = true,
        _name = questRegion[groupIndex],
        _groupType = questRegion[groupIndex],
        _count = 0,
        _questTable = {}
      }
      table[groupIndex] = info
    end
  end
  for groupIndex = 0, questGroupCount - 1 do
    local questGroup = questGroupList[groupIndex]
    if nil == questGroup then
      return
    end
    local questCount = questGroup:getQuestCount()
    for questIndex = 0, questCount - 1 do
      local uiQuestInfo = questGroup:getQuestAt(questIndex)
      if nil == uiQuestInfo then
        return
      end
      if false == uiQuestInfo._isCleared and false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
        local questInfo = self:SetQuestData(uiQuestInfo)
        local groupInfo
        if true == self._isSortByType then
          groupInfo = table[questInfo._questType]
        else
          groupInfo = table[questInfo._regionType]
        end
        groupInfo._questTable[groupInfo._count] = questInfo
        groupInfo._count = groupInfo._count + 1
      end
    end
  end
  if true == self._isSortByType then
    for groupIndex = 0, _questTypeTable.count - 1 do
      local groupInfo = table[groupIndex]
      groupInfo._name = groupInfo._name
    end
  else
    for groupIndex = 0, self._config._regionCount - 1 do
      local groupInfo = table[groupIndex]
      groupInfo._name = groupInfo._name
    end
  end
  return table
end
function Window_QuestInfo:SetGroupData(questGroupCount, questGroupList)
  local table = {}
  local tableIndex = 0
  for groupIndex = 0, questGroupCount - 1 do
    local clearedQuestCount = 0
    local questGroup = questGroupList[groupIndex]
    if nil == questGroup then
      return
    end
    local info = {
      _isClicked = false,
      _isGroup = true,
      _name = questGroup:getTitle(),
      _groupType = questGroup:getTitle(),
      _count = 0,
      _questTable = {},
      _clearedQuestCount = 0
    }
    local questCount = questGroup:getQuestCount()
    for questIndex = 0, questCount - 1 do
      local uiQuestInfo = questGroup:getQuestAt(questIndex)
      if nil == uiQuestInfo then
        _PA_LOG("\236\157\180\237\152\184\236\132\156", "uiQuestInfo \234\176\128 \236\151\134\235\139\164 ")
        return
      end
      if true == uiQuestInfo._isCleared then
        clearedQuestCount = clearedQuestCount + 1
      end
      if false == uiQuestInfo._isCleared and false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
        local questInfo = self:SetQuestData(uiQuestInfo)
        info._questTable[info._count] = questInfo
        info._count = info._count + 1
      end
    end
    local countBase = tostring(clearedQuestCount) .. "/" .. tostring(info._count)
    info._name = questGroup:getTitle()
    info._clearedQuestCount = clearedQuestCount
    if 0 ~= info._count then
      table[tableIndex] = info
      tableIndex = tableIndex + 1
    end
  end
  return table
end
function Window_QuestInfo:SetQuestData(uiQuestInfo)
  local questListInfo = ToClient_GetQuestList()
  if nil == questListInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "questListInfo \234\176\128 \236\151\134\235\139\164 ")
    return
  end
  local questInfo = {
    _uiQuestInfo = uiQuestInfo,
    _isCleared = uiQuestInfo._isCleared,
    _isProgressing = uiQuestInfo._isProgressing,
    _isContinueQuest = false,
    _continueQuestName = nil,
    _continueQuestDetail = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_NORMAL_TITLE"),
    _totalProgressCount = nil,
    _currentProgressCount = nil,
    _questType = uiQuestInfo:getQuestType(),
    _questNo = uiQuestInfo:getQuestNo(),
    _questName = uiQuestInfo:getTitle(),
    _completeNpc = uiQuestInfo:getCompleteDisplay(),
    _questCondition = {},
    _desc = ToClient_getReplaceDialog(uiQuestInfo:getDesc()),
    _isSatisfied = uiQuestInfo:isSatisfied(),
    _regionType = uiQuestInfo:getQuestRegion(),
    _groupType = "",
    _isGroup = false
  }
  local questNo = questInfo._questNo
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  if nil ~= uiQuestGroupInfo then
    questInfo._totalProgressCount = uiQuestGroupInfo:getTotalQuestCount()
    questInfo._currentProgressCount = questNo._quest
    questInfo._continueQuestName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", uiQuestInfo:getTitle())
    questInfo._isContinueQuest = true
    questInfo._questName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_COUNTQUEST", "count", uiQuestInfo:getTitle())
    if false == uiQuestInfo._isProgressing then
      questInfo._questName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_NOTACCEPTTITLE", "title", uiQuestInfo:getTitle())
    end
    local groupTitleDetail = uiQuestGroupInfo:getTitle() .. " (" .. questNo._quest .. "/" .. uiQuestGroupInfo:getTotalQuestCount() .. ")"
    questInfo._continueQuestDetail = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_GROUP_TITLE", "value", groupTitleDetail)
  end
  local questCondition = PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", questInfo._completeNpc)
  local demand = 0
  local demandCount = uiQuestInfo:getDemandCount()
  for demandIndex = 0, demandCount - 1 do
    demand = uiQuestInfo:getDemandAt(demandIndex)
    questInfo._questCondition[demandCount] = demand
  end
  return questInfo
end
function Window_QuestInfo:CreateGroupData(groupTable)
  local questInfo = {
    _isCleared = nil,
    _isProgressing = nil,
    _isContinueQuest = nil,
    _continueQuestName = nil,
    _continueQuestDetail = nil,
    _totalProgressCount = groupTable._count,
    _currentProgressCount = groupTable._clearedQuestCount,
    _questType = nil,
    _questNo = nil,
    _questName = groupTable._name,
    _groupType = groupTable._groupType,
    _completeNpc = nil,
    _questCondition = nil,
    _desc = nil,
    _isSatisfied = nil,
    _regionType = nil,
    _isGroup = true
  }
  return questInfo
end
function Window_QuestInfo:InitInputEvent()
  self._ui._questTitle._progress:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectQuestTitle(" .. self._config._title._progress .. ")")
  self._ui._questTitle._main:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectQuestTitle(" .. self._config._title._main .. ")")
  self._ui._questTitle._recommend:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectQuestTitle(" .. self._config._title._recommend .. ")")
  self._ui._questTitle._repeat:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectQuestTitle(" .. self._config._title._repeat .. ")")
  self._ui._questTitle._buttonLB:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectTitleButton(-1)")
  self._ui._questTitle._buttonRB:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SelectTitleButton(1)")
  self._ui._list2_Quest:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Quest_List2EventControlCreate")
  self._ui._list2_Quest:createChildContent(CppEnums.PAUIList2ElementManagerType.tree)
  for index = 0, self._config._baseRewardMax - 1 do
    Panel_Tooltip_Item_SetPosition(index, self._ui._baseRewardSlot[index], "QuestReward_Base")
  end
  for index = 0, self._config._selectRewardMax - 1 do
    Panel_Tooltip_Item_SetPosition(index, self._ui._selectRewardSlot[index], "QuestReward_Select")
  end
  self._ui._radioButton_SetQuestType:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_SetQuestType()")
  self._ui._radioButton_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_Close()")
  Panel_Window_QuestInfo:RegisterShowEventFunc(true, "PaGlobalFunc_Quest_ShowAni()")
  Panel_Window_QuestInfo:RegisterShowEventFunc(false, "PaGlobalFunc_Quest_HideAni()")
end
function PaGlobalFunc_Quest_List2EventControlCreate(list_content, key)
  local self = Window_QuestInfo
  local id = Int64toInt32(key)
  local questInfo = self._questInfo[id]
  if nil == questInfo then
    return
  end
  local questUI = {
    _button_QuestBg = UI.getChildControl(list_content, "Button_QuestBg"),
    _static_QuesetTypeIcon = UI.getChildControl(list_content, "Static_QuestTypeIcon"),
    _staticText_QuestName = UI.getChildControl(list_content, "StaticText_QuestName"),
    _staticText_ProgressCount = UI.getChildControl(list_content, "StaticText_ProgressCount"),
    _static_PathIcon = UI.getChildControl(list_content, "Static_QuestIsPathIcon"),
    _static_StateIcon = UI.getChildControl(list_content, "Static_QuestStateIcon")
  }
  questUI._staticText_QuestName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  questUI._staticText_QuestName:ComputePos()
  questUI._static_QuesetTypeIcon:ComputePos()
  questUI._staticText_ProgressCount:SetText("")
  questUI._button_QuestBg:addInputEvent("Mouse_LUp", "")
  questUI._button_QuestBg:addInputEvent("Mouse_On", "")
  questUI._static_PathIcon:SetShow(false)
  questUI._static_StateIcon:SetShow(false)
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "questInfo._questName : " .. questInfo._questName)
  if true == questInfo._isGroup then
    questUI._static_QuesetTypeIcon:SetShow(false)
    questUI._staticText_QuestName:SetSize(questUI._button_QuestBg:GetSizeX() - 100, questUI._staticText_QuestName:GetSizeY())
    questUI._staticText_QuestName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    questUI._staticText_QuestName:SetText(questInfo._questName)
    questUI._staticText_QuestName:SetFontColor(Defines.Color.C_FFC4A68A)
    questUI._staticText_QuestName:ComputePos()
    if nil == questInfo._currentProgressCount then
      questUI._staticText_ProgressCount:SetText(questInfo._totalProgressCount)
    else
      questUI._staticText_ProgressCount:SetText(questInfo._currentProgressCount .. "/" .. questInfo._totalProgressCount)
    end
    questUI._staticText_ProgressCount:SetSpanSize(35, questUI._staticText_ProgressCount:GetSpanSize().y)
    questUI._staticText_ProgressCount:ComputePos()
    questUI._button_QuestBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_FindWay(" .. id .. ",false)")
  else
    questUI._static_QuesetTypeIcon:SetShow(true)
    questUI._static_QuesetTypeIcon:SetPosX(60)
    questUI._staticText_QuestName:SetSize(questUI._button_QuestBg:GetSizeX() - 180, questUI._staticText_QuestName:GetSizeY())
    questUI._staticText_QuestName:SetPosX(90)
    if true == questInfo._isContinueQuest then
      FGlobal_ChangeOnTextureForConsoleDialogQuestIcon(questUI._static_QuesetTypeIcon, questInfo._questType)
      questUI._staticText_QuestName:SetText(questInfo._continueQuestName)
      questUI._staticText_ProgressCount:SetText(questInfo._currentProgressCount .. "/" .. questInfo._totalProgressCount)
      questUI._staticText_ProgressCount:SetSpanSize(55, questUI._staticText_ProgressCount:GetSpanSize().y)
    else
      FGlobal_ChangeOnTextureForConsoleDialogQuestIcon(questUI._static_QuesetTypeIcon, questInfo._questType)
      questUI._staticText_QuestName:SetText(questInfo._questName)
    end
    questUI._staticText_QuestName:SetFontColor(Defines.Color.C_FFEEEEEE)
    questUI._button_QuestBg:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SelectQuest(" .. id .. ")")
    questUI._button_QuestBg:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SelectQuestClear(" .. id .. ")")
    questUI._button_QuestBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_Quest_FindWay(" .. id .. ",false)")
    local isNext = not questInfo._isCleared and not questInfo._isProgressing
    local stateIconPosX = questUI._staticText_QuestName:GetPosX() + questUI._staticText_QuestName:GetTextSizeX() + 10
    questUI._static_StateIcon:SetPosX(stateIconPosX)
    if true == questInfo._isSatisfied then
      questUI._static_StateIcon:SetShow(true)
      questUI._static_StateIcon:SetColor(Defines.Color.C_FFF55839)
    elseif false ~= questInfo._isCleared or true == isNext then
    else
      questUI._static_StateIcon:SetShow(true)
      questUI._static_StateIcon:SetColor(Defines.Color.C_FFEEEEEE)
    end
    local groupNo = questInfo._questNo._group
    local questNo = questInfo._questNo._quest
    if true == PaGlobalFunc_Quest_IsFindingQuest(groupNo, questNo) then
      questUI._static_PathIcon:SetShow(true)
    end
  end
  self._qusetUI[id] = questUI
end
function PaGlobalFunc_Quest_SelectQuestClear(index)
  local self = Window_QuestInfo
  local prevIndex = self._currentQuestIndex
  self._currentQuestIndex = -1
  self._ui._list2_Quest:requestUpdateByKey(toInt64(0, prevIndex))
  self:DetailClear()
  PaGlobalFunc_Quest_Detail_Close()
end
function PaGlobalFunc_Quest_SimpleToolTipShow(id)
  local self = Window_QuestInfo
  local questUI = self._qusetUI[id]
  if nil == questUI then
    return
  end
  local qusetInfo = self._questInfo[id]
  if nil == qusetInfo then
    return
  end
  if false == questUI._staticText_QuestName:IsLimitText() then
    return
  end
  TooltipSimple_Show(questUI._button_QuestBg, qusetInfo._questName)
end
function Window_QuestInfo:GetTableByTitleType(titleType)
  if self._config._title._progress == titleType then
    return self._progressTable
  elseif self._config._title._main == titleType then
    return self._mainTable
  elseif self._config._title._recommend == titleType then
    return self._recommendTable
  elseif self._config._title._repeat == titleType then
    return self._repetitionTable
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\160\156\235\170\169\236\157\180 \236\158\152\235\170\187 \235\144\172\236\138\181\235\139\136\235\139\164.")
  end
end
function Window_QuestInfo:UpdateTableByTitleType(table, titleType)
  if self._config._title._progress == titleType then
    self._progressTable = table
  elseif self._config._title._main == titleType then
    self._mainTable = table
  elseif self._config._title._recommend == titleType then
    self._recommendTable = table
  elseif self._config._title._repeat == titleType then
    self._repetitionTable = table
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\160\156\235\170\169\236\157\180 \236\158\152\235\170\187 \235\144\172\236\138\181\235\139\136\235\139\164.")
  end
end
function PaGlobalFunc_Quest_GroupToggle(id)
  local self = Window_QuestInfo
  self._ui._list2_Quest:getElementManager():toggle(toInt64(0, id))
  self:DetailClear()
end
function FromClient_luaLoadComplete()
  local self = Window_QuestInfo
  self._ui._staticText_TopTitle = UI.getChildControl(self._ui._static_Title, "StaticText_Title")
  self._ui._static_TopTitleIcon = UI.getChildControl(self._ui._static_Title, "Static_TitleIcon")
  self._ui._questTitle._progress = UI.getChildControl(self._ui._static_RadioGroup, "RadioButton_Progress")
  self._ui._questTitle._main = UI.getChildControl(self._ui._static_RadioGroup, "RadioButton_Main")
  self._ui._questTitle._recommend = UI.getChildControl(self._ui._static_RadioGroup, "RadioButton_recommend")
  self._ui._questTitle._repeat = UI.getChildControl(self._ui._static_RadioGroup, "RadioButton_Repeat")
  self._ui._questTitle._buttonLB = UI.getChildControl(self._ui._static_RadioGroup, "Button_LB")
  self._ui._questTitle._buttonRB = UI.getChildControl(self._ui._static_RadioGroup, "Button_RB")
  self._config._defaultRaidoButtonTooltipSizeX = self._ui._staticText_RadioButtonTooltip:GetSizeX()
  self._config._defaultRaidoButtonTooltipSizeY = self._ui._staticText_RadioButtonTooltip:GetSizeY()
  self._ui._radioBtn_FilterType = UI.getChildControl(self._ui._stc_FilterGroup, "RadioButton_FilterToggle1")
  self._ui._radioBtn_AreaType = UI.getChildControl(self._ui._stc_FilterGroup, "RadioButton_FilterToggle2")
  self._ui._questDetail_Title = UI.getChildControl(self._ui._questDetailBg, "StaticText_QuestNameLine")
  self._ui._frame_Detail = UI.getChildControl(self._ui._questDetailBg, "Frame_Detail")
  self._ui._static_BaseReward = UI.getChildControl(self._ui._questDetailBg, "Static_BaseReward")
  self._ui._static_SelectReward = UI.getChildControl(self._ui._questDetailBg, "Static_SelectReward")
  self._ui._frameContent_1_Content = UI.getChildControl(self._ui._frame_Detail, "Frame_1_Content")
  self._ui._scroll_FrameVertical = UI.getChildControl(self._ui._frame_Detail, "Frame_1_VerticalScroll")
  self._ui._questDetail._staticText_Type = UI.getChildControl(self._ui._frameContent_1_Content, "StaticText_Type")
  self._ui._questDetail._staticText_Desc = UI.getChildControl(self._ui._frameContent_1_Content, "StaticText_Desc")
  self._ui._questDetail._staticText_ConditionTemplate = UI.getChildControl(self._ui._frameContent_1_Content, "StaticText_ConditionTemplate")
  self._ui._questDetail._staticText_ConditionTemplate:SetShow(false)
  self._ui._frameContent_1_Content:SetIgnore(false)
  self._ui._questDetail._staticText_Desc:SetIgnore(false)
  self._ui._questDetail._staticText_ConditionTemplate:SetIgnore(false)
  for index = 0, self._config._baseRewardMax - 1 do
    local control = UI.getChildControl(self._ui._static_BaseReward, "Static_Item0" .. index)
    local slot = {}
    SlotItem.new(slot, "Static_BaseReward_" .. index, index, control, self._config._questRewardSlotConfig)
    slot:createChild()
    self._ui._baseRewardSlot[index] = slot
    self._ui._baseRewardControl[index] = control
  end
  self._ui._static_BaseToolTip = UI.getChildControl(self._ui._static_BaseReward, "StaticText_BaseToolTip")
  self._ui._static_BaseToolTip:SetTextHorizonCenter()
  self._ui._static_BaseToolTip:SetTextVerticalCenter()
  for index = 0, self._config._selectRewardMax - 1 do
    local control = UI.getChildControl(self._ui._static_SelectReward, "Static_Item0" .. index)
    local slot = {}
    SlotItem.new(slot, "Static_SelectReward_" .. index, index, control, self._config._questRewardSlotConfig)
    slot:createChild()
    self._ui._selectRewardSlot[index] = slot
    self._ui._selectRewardControl[index] = control
  end
  self._ui._static_SelectToolTip = UI.getChildControl(self._ui._static_SelectReward, "StaticText_SelectToolTip")
  self._ui._static_SelectToolTip:SetTextHorizonCenter()
  self._ui._static_SelectToolTip:SetTextVerticalCenter()
  self._ui._radioButton_autoFindWay = UI.getChildControl(self._ui._static_KeyGuideBg, "Radiobutton_autoFindWay")
  self._ui._radioButton_QuestGiveUp = UI.getChildControl(self._ui._static_KeyGuideBg, "Radiobutton_QuestGiveUp")
  self._ui._radioButton_SetQuestType = UI.getChildControl(self._ui._static_KeyGuideBg, "Radiobutton_SetQuestType")
  self._ui._radioButton_Close = UI.getChildControl(self._ui._static_KeyGuideBg, "Radiobutton_Close")
  local keyGuides = {
    self._ui._radioButton_QuestGiveUp,
    self._ui._radioButton_autoFindWay,
    self._ui._radioButton_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui._static_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, 44, 15)
  self:InitInputEvent()
  self:InitRegisterEvent()
  PaGlobalFunc_Quest_UpdateList()
end
function Window_QuestInfo:InitRegisterEvent()
  registerEvent("EventQuestListChanged", "PaGlobalFunc_Quest_UpdateList")
  registerEvent("FromClient_DeleteNavigation", "PaGlobalFunc_Quest_DeleteNavigation")
  registerEvent("FromClient_RClickWorldmapQuest", "PaGlobalFunc_Quest_RClickWorldmapQuest")
end
function PaGlobalFunc_Quest_SelectQuest(index)
  local self = Window_QuestInfo
  self:DetailClear()
  local questInfo = self._questInfo[index]
  if nil == questInfo then
    PaGlobalFunc_Quest_Detail_Close()
    return
  end
  if true == questInfo._isGroup then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\157\180\234\178\131\236\157\128 \234\183\184\235\163\185\236\157\180\235\139\164")
    PaGlobalFunc_Quest_Detail_Close()
    return
  end
  local prevIndex = self._currentQuestIndex
  self._currentQuestIndex = index
  PaGlobalFunc_Quest_Detail_Open()
  local title = self._ui._questDetail_Title
  title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  title:SetText(questInfo._questName)
  local questType = self._ui._questDetail._staticText_Type
  questType:SetText(questInfo._continueQuestDetail)
  local desc = self._ui._questDetail._staticText_Desc
  desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  desc:SetAutoResize(true)
  desc:SetPosY(questType:GetPosY() + questType:GetSizeY() + 5)
  desc:SetText(questInfo._desc)
  self._ui._scroll_FrameVertical:SetControlPos(0)
  self._ui._frame_Detail:UpdateContentPos()
  self._ui._frame_Detail:UpdateContentScroll()
  self._ui._frame_Detail:ComputePos()
  local conditionStartPosY = self._ui._questDetail._staticText_Desc:GetPosY() + self._ui._questDetail._staticText_Desc:GetSizeY() + 5
  local demandCount = questInfo._uiQuestInfo:getDemandCount()
  for index = 0, demandCount - 1 do
    local conditionUI = self._ui._staticText_ConditionList[index]
    if nil == conditionUI then
      conditionUI = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._frameContent_1_Content, "staticText_questCondition_" .. index)
      CopyBaseProperty(self._ui._questDetail._staticText_ConditionTemplate, conditionUI)
    end
    conditionUI:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    conditionUI:SetAutoResize(true)
    conditionUI:SetFontColor(Defines.Color.C_FFC4BEBE)
    local conditionInfo = questInfo._uiQuestInfo:getDemandAt(index)
    local conditionText
    if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
      conditionText = "- " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
      conditionUI:SetText(ToClient_getReplaceDialog(conditionText))
      conditionUI:SetLineRender(true)
      conditionUI:SetFontColor(Defines.Color.C_FF626262)
    elseif 1 == conditionInfo._destCount then
      conditionText = "- " .. conditionInfo._desc
      conditionUI:SetText(ToClient_getReplaceDialog(conditionText))
      conditionUI:SetLineRender(false)
    else
      conditionText = "- " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
      conditionUI:SetText(ToClient_getReplaceDialog(conditionText))
      conditionUI:SetLineRender(false)
    end
    if 0 == index then
      conditionUI:SetPosY(conditionStartPosY)
    else
      local prevUI = self._ui._staticText_ConditionList[index - 1]
      conditionUI:SetPosY(prevUI:GetPosY() + prevUI:GetSizeY() + 5)
    end
    conditionUI:SetShow(true)
    self._ui._staticText_ConditionList[index] = conditionUI
  end
  self._ui._frameContent_1_Content:SetSize(self._ui._frameContent_1_Content:GetSizeX(), self._ui._frameContent_1_Content:GetPosY() + title:GetSizeY() + questType:GetSizeY() + desc:GetSizeY() + self._ui._staticText_ConditionList[0]:GetSizeY() * #questInfo._questCondition)
  if self._ui._frame_Detail:GetSizeY() < self._ui._frameContent_1_Content:GetSizeY() then
    self._ui._scroll_FrameVertical:SetShow(true)
  else
    self._ui._scroll_FrameVertical:SetShow(false)
  end
  self._ui._frame_Detail:UpdateContentPos()
  self._ui._radioButton_autoFindWay:SetShow(true)
  Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  if self._config._title._progress == self._currentTitleType and true == self._questInfo[index]._isProgressing then
    self._ui._radioButton_QuestGiveUp:SetShow(true)
    Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_Quest_GiveUp(" .. index .. ")")
  end
  self._ui._list2_Quest:requestUpdateByKey(toInt64(0, prevIndex))
  self._ui._list2_Quest:requestUpdateByKey(toInt64(0, index))
  self:SetReward(questInfo._questNo._group, questInfo._questNo._quest)
end
function Window_QuestInfo:SetReward(groupID, questID)
  self:SlotClear()
  local questInfo = questList_getQuestStatic(groupID, questID)
  if nil == questInfo then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "questInfo nil")
    return
  end
  local baseRewardCount = questInfo:getQuestBaseRewardCount()
  local selectRewardCount = questInfo:getQuestSelectRewardCount()
  for baseIndex = 0, baseRewardCount - 1 do
    local baseReward = questInfo:getQuestBaseRewardAt(baseIndex)
    if nil == baseReward then
      return
    end
    self:SetRewardIcon(self._ui._baseRewardSlot[baseIndex], baseReward, baseIndex, "base")
  end
  for selectIndex = 0, selectRewardCount - 1 do
    local selectReward = questInfo:getQuestSelectRewardAt(selectIndex)
    if nil == selectReward then
      return
    end
    self:SetRewardIcon(self._ui._selectRewardSlot[selectIndex], selectReward, selectIndex, "select")
  end
end
function Window_QuestInfo:SetRewardIcon(slot, reward, index, rewardStr)
  local rewardType = reward:getType()
  if nil == rewardType then
    return
  end
  slot._type = rewardType
  if __eRewardExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"Exp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"Exp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"SkillExp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"SkillExp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"ExpGrade\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"ExpGrade\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"SkillExpGrade\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"SkillExpGrade\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardLifeExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"ProductExp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"ProductExp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardItem == rewardType then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward:getItemEnchantKey()))
    if nil == itemStatic then
      return
    end
    slot.icon:SetShow(true)
    if 0 ~= reward:getItemCount() and nil == slot.count then
      slot.count = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.icon, "StaticText_" .. slot.id .. "_Count")
    end
    slot:setItemByStaticStatus(itemStatic, reward:getItemCount())
    slot._item = reward:getItemEnchantKey()
    if "base" == rewardStr then
      slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",true)")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",false)")
    end
    if "select" == rewardStr then
      slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Select\",true)")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Select\",false)")
    end
    slot.count:SetSize(42, 21)
    slot.count:SetPosY(slot.count:GetPosY() + slot.count:GetSizeY())
    slot.count:SetTextHorizonRight()
    slot.count:SetVerticalBottom()
  elseif __eRewardIntimacy == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"Intimacy\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"Intimacy\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardKnowledge == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Quest_SetTooltip( \"Knowledge\", true,\"" .. rewardStr .. "\"," .. index .. "," .. reward:getMentalCardKey() .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Quest_SetTooltip( \"Knowledge\", false,\"" .. rewardStr .. "\"," .. index .. "," .. reward:getMentalCardKey() .. " )")
    slot.icon:SetShow(true)
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "rewardType\236\157\180 \236\158\152\235\170\187 \235\147\164\236\150\180\236\153\148\235\139\164.")
  end
end
function PaGlobalFunc_Quest_FindWay(index, isAuto)
  local self = Window_QuestInfo
  local questInfo = self._questInfo[index]
  if nil == questInfo then
    return
  end
  if true == questInfo._isGroup then
    self._ui._list2_Quest:getElementManager():toggle(toInt64(0, index))
    return
  end
  local groupNo = questInfo._questNo._group
  local questNo = questInfo._questNo._quest
  local questStatic = questList_getQuestStatic(groupNo, questNo)
  if nil == questStatic then
    return
  end
  local questCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
  local isNext = not questInfo._isCleared and not questInfo._isProgressing
  if true == questInfo._isSatisfied then
    questCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
  elseif false == questInfo._isCleared then
    if true == isNext then
      questCondition = QuestConditionCheckType.eQuestConditionCheckType_NotAccept
    else
      questCondition = QuestConditionCheckType.eQuestConditionCheckType_Progress
    end
  end
  if QuestConditionCheckType.eQuestConditionCheckType_Complete == questCondition then
    if true == questStatic:isCompleteBlackSpirit() then
      HandleClicked_CallBlackSpirit()
    else
      HandleClicked_QuestWidget_FindTarget(groupNo, questNo, questCondition, isAuto)
    end
  elseif QuestConditionCheckType.eQuestConditionCheckType_NotAccept == questCondition then
    if 0 == questStatic:getAccecptNpc():get() then
      HandleClicked_CallBlackSpirit()
    else
      HandleClicked_QuestWidget_FindTarget(groupNo, questNo, questCondition, isAuto)
    end
  else
    HandleClicked_QuestWidget_FindTarget(groupNo, questNo, questCondition, isAuto)
  end
end
function PaGlobalFunc_Quest_GiveUp(index)
  local self = Window_QuestInfo
  local questInfo = self._questInfo[index]
  if nil == questInfo then
    return
  end
  self._giveUpQuestIndex = index
  if true == PaGlobal_TutorialManager:isBeginnerTutorialQuest(questInfo._questNo._group, questInfo._questNo._quest) and true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  local messageBoxtitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxContent = PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_REAL_GIVEUP_QUESTION")
  local messageboxData = {
    title = messageBoxtitle,
    content = messageboxContent,
    functionYes = PaGlobalFunc_Quest_GiveUpConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_Quest_GiveUpConfirm()
  local self = Window_QuestInfo
  local questInfo = self._questInfo[self._giveUpQuestIndex]
  if nil == questInfo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_GiveupQuest(questInfo._questNo._group, questInfo._questNo._quest)
end
function PaGlobalFunc_Quest_SetQuestType()
  FGlobal_CheckedQuestOptionOpen()
end
function PaGlobalFunc_Quest_SetTooltip(questType, show, rewardStr, index, mentalCardKey)
  local self = Window_QuestInfo
  local str
  if true == show then
    if "Exp" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP")
    elseif "SkillExp" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP")
    elseif "ExpGrade" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP_GRADE")
    elseif "SkillExpGrade" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP_GRADE")
    elseif "ProductExp" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP")
    elseif "Intimacy" == questType then
      str = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY")
    elseif "Knowledge" == questType then
      local mentalCardSSW = ToClinet_getMentalCardStaticStatus(mentalCardKey)
      if nil == mentalCardSSW then
        return
      end
      local mentalCardName = mentalCardSSW:getName()
      local mentalCardDesc = mentalCardSSW:getDesc()
      str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_REWARD_TOOLTIP_KNOWLEDGE", "mentalCardName", mentalCardName, "mentalCardName2", mentalCardName)
    end
    if "base" == rewardStr then
      self._ui._static_BaseToolTip:SetText(str)
      self._ui._static_BaseToolTip:SetPosX(self._ui._baseRewardControl[index]:GetPosX() - self._ui._baseRewardControl[index]:GetSizeX() / 2 - 5)
      self._ui._static_BaseToolTip:SetPosY(self._ui._baseRewardControl[index]:GetPosY() - self._ui._static_BaseToolTip:GetSizeY())
      self._ui._static_BaseToolTip:SetShow(true)
    elseif "select" == rewardStr then
      self._ui._static_SelectToolTip:SetText(str)
      self._ui._static_SelectToolTip:SetPosX(self._ui._selectRewardControl[index]:GetPosX() - self._ui._selectRewardControl[index]:GetSizeX() / 2 - 5)
      self._ui._static_SelectToolTip:SetPosY(self._ui._selectRewardControl[index]:GetPosY() - self._ui._static_SelectToolTip:GetSizeY())
      self._ui._static_SelectToolTip:SetShow(true)
    end
  else
    self._ui._static_BaseToolTip:SetShow(false)
    self._ui._static_SelectToolTip:SetShow(false)
  end
end
function Window_QuestInfo:SlotClear()
  for index = 0, self._config._baseRewardMax - 1 do
    self._ui._baseRewardSlot[index].icon:SetShow(false)
    if nil ~= self._ui._baseRewardSlot[index].count then
      self._ui._baseRewardSlot[index].count:SetShow(false)
      self._ui._baseRewardSlot[index]._item = 0
    end
  end
  for index = 0, self._config._selectRewardMax - 1 do
    self._ui._selectRewardSlot[index].icon:SetShow(false)
    if nil ~= self._ui._selectRewardSlot[index].count then
      self._ui._selectRewardSlot[index].count:SetShow(false)
      self._ui._selectRewardSlot[index]._item = 0
    end
  end
end
function Window_QuestInfo:DetailClear()
  self._ui._questDetail._staticText_Desc:SetAutoResize(true)
  self._ui._questDetail._staticText_Type:SetAutoResize(true)
  self._ui._questDetail._staticText_Desc:SetText("")
  self._ui._questDetail._staticText_Type:SetText("")
  self._ui._questDetail._staticText_Desc:SetPosY(0)
  self._ui._questDetail._staticText_Type:SetPosY(0)
  for _, control in pairs(self._ui._staticText_ConditionList) do
    if nil ~= control then
      control:SetAutoResize(true)
      control:SetText("")
      control:SetPosY(0)
    end
  end
  self._ui._radioButton_autoFindWay:SetShow(false)
  self._ui._radioButton_QuestGiveUp:SetShow(false)
  Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  self._ui._frameContent_1_Content:SetSize(self._ui._frameContent_1_Content:GetSizeX(), 10)
  self._ui._frame_Detail:UpdateContentPos()
  self:SlotClear()
end
function PaGlobalFunc_Quest_OpenDetail(questGroupId, questId, titleType)
  local self = Window_QuestInfo
  local table = self:GetTableByTitleType(titleType)
  if nil == table then
    return
  end
  if false == PaGlobalFunc_Quest_GetShow() then
    PaGlobalFunc_Quest_SetShow(true)
  end
  PaGlobalFunc_Quest_UpdateList()
  for groupIndex = 0, #table do
    for questIndex = 0, table[groupIndex]._count - 1 do
      local questInfo = table[groupIndex]._questTable[questIndex]
      if nil == questInfo then
        return
      end
      if questGroupId == questInfo._questNo._group and questId == questInfo._questNo._quest then
        table[groupIndex]._isClicked = true
        self:UpdateTableByTitleType(table, titleType)
        break
      end
    end
  end
  PaGlobalFunc_Quest_SelectQuestTitle(titleType)
  for index = 0, #self._questInfo - 1 do
    local questInfo = self._questInfo[index]
    if false == questInfo._isGroup and questGroupId == questInfo._questNo._group and questId == questInfo._questNo._quest then
      PaGlobalFunc_Quest_SelectQuest(index)
      break
    end
  end
end
function Window_QuestInfo:GetQuestGroupCount(titleType, selfPlayerQuestInfo)
  local count = -1
  if self._config._title._progress == titleType then
    count = selfPlayerQuestInfo:getQuestGroupCount()
  elseif self._config._title._main == titleType then
    count = selfPlayerQuestInfo:getMainQuestGroupCount()
  elseif self._config._title._recommend == titleType then
    count = selfPlayerQuestInfo:getRecommendationQuestGroupCount()
  elseif self._config._title._repeat == titleType then
    count = selfPlayerQuestInfo:getRepetitionQuestGroupCount()
  else
    count = -1
  end
  return count
end
function Window_QuestInfo:GetQuestGroupByIndex(titleType, questListIndex, selfPlayerQuestInfo)
  local questGroup
  if self._config._title._progress == titleType then
    questGroup = selfPlayerQuestInfo:getQuestGroupAt(questListIndex)
  elseif self._config._title._main == titleType then
    questGroup = selfPlayerQuestInfo:getMainQuestGroupAt(questListIndex)
  elseif self._config._title._recommend == titleType then
    questGroup = selfPlayerQuestInfo:getRecommendationQuestGroupAt(questListIndex)
  elseif self._config._title._repeat == titleType then
    questGroup = selfPlayerQuestInfo:getRepetitionQuestGroupAt(questListIndex)
  else
    questGroup = nil
  end
  return questGroup
end
function PaGlobalFunc_Quest_ShowAni()
  local self = Window_QuestInfo
  local panel = Panel_Window_QuestInfo
  self._currentTabIndex = 0
  panel:ResetVertexAni()
  local aniInfo = panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartPosition(getScreenSizeX(), 0)
  aniInfo:SetEndPosition(getScreenSizeX() - panel:GetSizeX() + 2, 0)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(false)
  aniInfo:SetDisableWhileAni(true)
  aniInfo:SetIgnoreUpdateSnapping(true)
  self._ui._staticText_TopTitle:ComputePos()
  self._ui._staticText_TopTitle:ResetVertexAni()
  self._ui._staticText_TopTitle:SetVertexAniRun("Ani_Move_Pos_Show", true)
  self._ui._static_TopTitleIcon:ComputePos()
  self._ui._static_TopTitleIcon:ResetVertexAni()
  self._ui._static_TopTitleIcon:SetVertexAniRun("Ani_Move_Pos_Show", true)
  FGlobal_SetUrl_Tooltip_SkillForLearning()
end
function PaGlobalFunc_Quest_HideAni()
  local self = Window_QuestInfo
  local panel = Panel_Window_QuestInfo
  panel:ResetVertexAni()
  local aniInfo = panel:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo:SetStartPosition(panel:GetPosX(), 0)
  aniInfo:SetEndPosition(panel:GetPosX() + 600, 0)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(true)
  aniInfo:SetDisableWhileAni(true)
  aniInfo:SetIgnoreUpdateSnapping(true)
  FGlobal_ResetUrl_Tooltip_SkillForLearning()
end
function PaGlobalFunc_Quest_Close()
  Panel_Window_QuestInfo:SetShow(false, false)
end
function PaGlobalFunc_Quest_Detail_Open()
  local self = Window_QuestInfo
  self._ui._questDetailBg:SetShow(true, false)
end
function PaGlobalFunc_Quest_Detail_Close()
  local self = Window_QuestInfo
  self._ui._questDetailBg:SetShow(false, false)
end
function PaGlobalFunc_Quest_SetShow(value)
  local self = Window_QuestInfo
  Panel_Window_QuestInfo:SetShow(value, false)
  if true == value then
    _AudioPostEvent_SystemUiForXBOX(1, 29)
  end
  self._currentQuestCount = 0
  if true == value then
    if true == PaGlobalFunc_InventoryInfo_GetShow() then
      PaGlobalFunc_InventoryInfo_Close()
    else
      FGlobal_Panel_Radar_Show(false, true)
      Panel_TimeBar:SetShow(false, true)
      FGlobal_QuestWidget_Close()
    end
    PaGlobalFunc_Quest_UpdateList()
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_QUEST")
  else
    if false == PaGlobalFunc_InventoryInfo_GetShow() then
      FGlobal_Panel_Radar_Show(true, true)
      Panel_TimeBar:SetShow(true, true)
      FGlobal_QuestWidget_Open()
    end
    PaGlobalFunc_Quest_Detail_Close()
    ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  end
  PaGlobal_TutorialManager:handleShowQuestNewWindow(value)
end
function PaGlobalFunc_Quest_GetShow()
  return Panel_Window_QuestInfo:GetShow()
end
function PaGlobalFunc_Quest_Toggle()
  Panel_Window_QuestInfo:SetShow(not Panel_Window_QuestInfo:GetShow())
end
function Toggle_QuestTab_forPadEventFunc(value)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  local self = Window_QuestInfo
  self._currentTabIndex = self._currentTabIndex + value
  if self._currentTabIndex < 0 then
    self._currentTabIndex = 2
  elseif self._currentTabIndex > 2 then
    self._currentTabIndex = 0
  end
  if 0 == self._currentTabIndex then
    PaGlobalFunc_Quest_SelectQuestTitle(self._config._title._progress)
  elseif 1 == self._currentTabIndex then
    PaGlobalFunc_Quest_SelectQuestTitle(self._config._title._main)
  elseif 2 == self._currentTabIndex then
    PaGlobalFunc_Quest_SelectQuestTitle(self._config._title._recommend)
  end
end
Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_LB, "Toggle_QuestTab_forPadEventFunc(-1)")
Panel_Window_QuestInfo:registerPadEvent(__eConsoleUIPadEvent_RB, "Toggle_QuestTab_forPadEventFunc(1)")
function Window_QuestInfo:Resize()
  Panel_Window_QuestInfo:SetSize(Panel_Window_QuestInfo:GetSizeX(), getScreenSizeY())
  self._ui._static_Title:ComputePos()
  self._ui._list2_Quest:ComputePos()
  self._ui._frame_Detail:ComputePos()
  self._ui._static_BaseReward:ComputePos()
  self._ui._static_SelectReward:ComputePos()
  self._ui._static_KeyGuideBg:ComputePos()
  self._ui._frameContent_1_Content:ComputePos()
  self._ui._frame_Detail:SetSize(self._ui._frame_Detail:GetSizeX(), self._ui._static_BaseReward:GetPosY() - self._ui._frame_Detail:GetPosY())
end
function PaGlobalFunc_Quest_Resize()
  Window_QuestInfo:Resize()
end
function Window_QuestInfo:Clear()
  local titleType = -1
  self:DetailClear()
  self:SlotClear()
  self._ui._list2_Quest:getElementManager():clearKey()
  self._progressTable = {}
  self._recommendTable = {}
  self._mainTable = {}
  self._repetitionTable = {}
end
function PaGlobalFunc_Quest_UpdateList()
  local self = Window_QuestInfo
  self:Clear()
  self._progressTable = self:GetQuestGroupByTitle(self._config._title._progress)
  self._recommendTable = self:GetQuestGroupByTitle(self._config._title._recommend)
  self._mainTable = self:GetQuestGroupByTitle(self._config._title._main)
  self._repetitionTable = self:GetQuestGroupByTitle(self._config._title._repeat)
  PaGlobalFunc_Quest_SelectQuestTitle(self._currentTitleType)
end
function PaGlobalFunc_Quest_ChangeType()
  local self = Window_QuestInfo
  self._isSortByType = not self._isSortByType
  PaGlobalFunc_Quest_UpdateList()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete")
