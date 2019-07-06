local UIMode = Defines.UIMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_SkillCoolTimeSlot:SetShow(false)
Panel_SkillCoolTimeSlot:ActiveMouseEventEffect(true)
Panel_SkillCoolTimeSlot:setGlassBackground(true)
Panel_SkillCoolTimeSlot:SetDragAll(true)
PaGlobal_Window_Skill_CoolTimeSlot = {
  _frameBG = UI.getChildControl(Panel_SkillCoolTimeSlot, "Static_FrameBG"),
  _slide = UI.getChildControl(Panel_SkillCoolTimeSlot, "VerticalScroll"),
  _slideBtn = nil,
  _copyUI = {
    _base_SkillBG = UI.getChildControl(Panel_SkillCoolTimeSlot, "Static_C_SkillBG"),
    _base_SkillIcon = UI.getChildControl(Panel_SkillCoolTimeSlot, "Static_C_SkillIcon"),
    _base_SkillName = UI.getChildControl(Panel_SkillCoolTimeSlot, "StaticText_C_SkillName"),
    _base_ComboBox = UI.getChildControl(Panel_SkillCoolTimeSlot, "Combobox_Sort")
  },
  _copyString = {
    _base_StringName = UI.getChildControl(Panel_SkillCoolTimeSlot, "StaticText_C_SkillName")
  },
  _comboBoxString = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_NOT"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_5"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_6"),
    [7] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_7"),
    [8] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_8"),
    [9] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_9"),
    [10] = PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_SKILLCOLLTIMEQUICKSLOT_10")
  },
  _editSearch = {
    _editSearchText = UI.getChildControl(Panel_SkillCoolTimeSlot, "EditSearchText"),
    _editSearchButton = UI.getChildControl(Panel_SkillCoolTimeSlot, "BtnSearch")
  },
  _initButton = UI.getChildControl(Panel_SkillCoolTimeSlot, "BtnInit"),
  _uiSettingButton = UI.getChildControl(Panel_SkillCoolTimeSlot, "Button_UISetting"),
  _desc = UI.getChildControl(Panel_SkillCoolTimeSlot, "StaticText_BottomDesc"),
  _skillCoolTimeSlotList_MaxCount = 7,
  _uiData = {},
  _slideIndex = 0,
  _panel_SkillCoolTimeSlot_Value_elementCount = 1,
  _usableSkillTable = {},
  _usableSkillCount = 1
}
function PaGlobal_Window_Skill_CoolTimeSlot:setPosition()
  Panel_SkillCoolTimeSlot:SetPosX(Panel_Window_Skill:GetPosX() + Panel_Window_Skill:GetSizeX())
  Panel_SkillCoolTimeSlot:SetPosY(Panel_Window_Skill:GetPosY())
end
local sortSkillCoolTime = function(table1, table2)
  local arg1 = table1._coolTimeIndex
  local arg2 = table2._coolTimeIndex
  if arg1 < 0 then
    arg1 = PaGlobal_Window_Skill_CoolTimeSlot._usableSkillCount
  end
  if arg2 < 0 then
    arg2 = PaGlobal_Window_Skill_CoolTimeSlot._usableSkillCount
  end
  if arg1 < arg2 or arg1 == arg2 and table1._insertNo < table2._insertNo then
    return true
  end
end
function PaGlobal_Window_Skill_CoolTimeSlot:update()
  local self = PaGlobal_Window_Skill_CoolTimeSlot
  local skillInfo = {}
  for ii = 0, #skillInfo do
    skillInfo = {
      _skillNo = nil,
      _skillName = nil,
      _coolTimeIndex = nil,
      _insertNo = nil
    }
  end
  skillInfo, self._panel_SkillCoolTimeSlot_Value_elementCount = self:searchSkill_Setting()
  if self._panel_SkillCoolTimeSlot_Value_elementCount <= self._skillCoolTimeSlotList_MaxCount then
    self._slide:SetShow(false)
  else
    self._slide:SetShow(true)
  end
  table.sort(skillInfo, sortSkillCoolTime)
  for index = 1, self._skillCoolTimeSlotList_MaxCount do
    if self._slideIndex + index < self._panel_SkillCoolTimeSlot_Value_elementCount then
      local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillInfo[self._slideIndex + index]._skillNo)
      if skillTypeStaticWrapper:isValidLocalizing() then
        self._uiData[index]:SetData(skillTypeStaticWrapper, skillInfo[self._slideIndex + index]._skillNo, skillInfo[self._slideIndex + index]._skillName, index)
        self._uiData[index]._IconBG:SetShow(true)
        self._uiData[index]._skillIcon:SetShow(true)
        self._uiData[index]._skillName:SetShow(true)
        self._uiData[index]._ComboBox:SetShow(true)
        self._uiData[index]._ComboBox:SetSelectItemIndex(skillInfo[self._slideIndex + index]._coolTimeIndex + 1)
      else
        self._uiData[index]._IconBG:SetShow(false)
        self._uiData[index]._skillIcon:SetShow(false)
        self._uiData[index]._skillName:SetShow(false)
        self._uiData[index]._ComboBox:SetShow(false)
      end
    else
      self._uiData[index]._IconBG:SetShow(false)
      self._uiData[index]._skillIcon:SetShow(false)
      self._uiData[index]._skillName:SetShow(false)
      self._uiData[index]._ComboBox:SetShow(false)
    end
  end
  UIScroll.SetButtonSize(self._slide, self._skillCoolTimeSlotList_MaxCount, self._panel_SkillCoolTimeSlot_Value_elementCount - 1)
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_MakeControl(index)
  local ui = {}
  index = index - 1
  ui._IconBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_SkillCoolTimeSlot, "Static_SkillBG_" .. index)
  CopyBaseProperty(self._copyUI._base_SkillBG, ui._IconBG)
  ui._IconBG:SetShow(false)
  ui._IconBG:SetIgnore(false)
  ui._IconBG:SetPosY(118 + index * (ui._IconBG:GetSizeY() + 9))
  ui._skillIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_SkillCoolTimeSlot, "Static_SkillIcon_" .. index)
  CopyBaseProperty(self._copyUI._base_SkillIcon, ui._skillIcon)
  ui._skillIcon:SetShow(false)
  ui._skillIcon:SetPosY(130 + index * (ui._IconBG:GetSizeY() + 9))
  ui._skillName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_SkillCoolTimeSlot, "StaticText_SkillName_" .. index)
  CopyBaseProperty(self._copyUI._base_SkillName, ui._skillName)
  ui._skillName:SetShow(false)
  ui._skillName:SetIgnore(true)
  ui._skillName:SetPosY(139 + index * (ui._IconBG:GetSizeY() + 9))
  ui._ComboBox = UI.createControl(UI_PUCT.PA_UI_CONTROL_COMBOBOX, Panel_SkillCoolTimeSlot, "Combobox_SkillCoolTimeQuickSlot_" .. index)
  CopyBaseProperty(self._copyUI._base_ComboBox, ui._ComboBox)
  ui._ComboBox:setListTextHorizonCenter()
  ui._ComboBox:SetShow(false)
  ui._ComboBox:SetPosY(132 + index * (ui._IconBG:GetSizeY() + 9))
  for comboindex = 0, #self._comboBoxString do
    ui._ComboBox:AddItem(self._comboBoxString[comboindex])
  end
  ui._ComboBox:SetSelectItemIndex(0)
  function ui:SetData(skillTypeSSW, skillNo, skillName, index)
    self._skillIcon:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
    self._skillName:SetText(skillName)
    self._skillIcon:addInputEvent("Mouse_On", "PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_OverEvent(" .. skillNo .. ",false, \"MainStatusSkill\")")
    self._skillIcon:addInputEvent("Mouse_Out", "PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_OverEventHide(" .. skillNo .. ",\"MainStatusSkill\")")
    Panel_SkillTooltip_SetPosition(skillNo, self._skillIcon, "MainStatusSkill")
    self._ComboBox:addInputEvent("Mouse_LUp", "PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlotComboBox_Show(" .. index .. " )")
    self._ComboBox:GetListControl():addInputEvent("Mouse_LUp", "PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlotComboBox_Set(" .. index .. ", " .. skillNo .. ")")
  end
  ui._IconBG:addInputEvent("Mouse_UpScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( true )")
  ui._IconBG:addInputEvent("Mouse_DownScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( false )")
  ui._skillIcon:addInputEvent("Mouse_UpScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( true )")
  ui._skillIcon:addInputEvent("Mouse_DownScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( false )")
  return ui
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlotComboBox_Show(index)
  self._uiData[index]._ComboBox:ToggleListbox()
  Panel_SkillCoolTimeSlot:SetChildIndex(self._uiData[index]._ComboBox, 9998)
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlotComboBox_Set(index, skillNo)
  local slotNo = self._uiData[index]._ComboBox:GetSelectIndex() - 1
  self._uiData[index]._ComboBox:ToggleListbox()
  if slotNo >= 0 then
    ToClient_setSkillCoolTimeSlot(slotNo, skillNo)
  else
    ToClient_clearSkillCoolTimeSlot(skillNo)
  end
  PaGlobal_SkillCoolTimeQuickSlot:updateQuickSlot()
  self:update()
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_OverEvent(skillNo, isShowNextLevel, SlotType)
  if skillNoCache == skillNo and slotTypeCache == SlotType then
    tooltipcacheCount = tooltipcacheCount + 1
  else
    skillNoCache = skillNo
    slotTypeCache = SlotType
    tooltipcacheCount = 1
  end
  Panel_SkillTooltip_Show(skillNo, false, SlotType)
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_OverEventHide(skillNo, SlotType)
  if skillNoCache == skillNo and slotTypeCache == SlotType then
    tooltipcacheCount = tooltipcacheCount - 1
  else
    tooltipcacheCount = 0
  end
  if tooltipcacheCount <= 0 then
    Panel_SkillTooltip_Hide()
  end
end
local stringMatching = function(filterText, editSkillName)
  return (stringSearch(filterText, editSkillName))
end
function PaGlobal_Window_Skill_CoolTimeSlot:searchSkill_Setting()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local filterText = self._editSearch._editSearchText:GetEditText()
  local skillTable = {}
  local editSkillCount = 1
  local isPush = false
  for ii = 1, self._usableSkillCount - 1 do
    if nil == filterText or 0 == filterText:len() then
      isPush = true
    elseif true == stringMatching(self._usableSkillTable[ii]._skillName, filterText) then
      isPush = true
    else
      isPush = false
    end
    if true == isPush then
      local coolTimeIndex = ToClient_getSkillCoolTimeSlotIndex(self._usableSkillTable[ii]._skillNo)
      skillTable[editSkillCount] = {
        _skillNo = self._usableSkillTable[ii]._skillNo,
        _skillName = self._usableSkillTable[ii]._skillName,
        _coolTimeIndex = coolTimeIndex,
        _insertNo = self._usableSkillTable[ii]._insertNo
      }
      editSkillCount = editSkillCount + 1
    end
  end
  return skillTable, editSkillCount
end
function PaGlobal_Window_Skill_CoolTimeSlot:usableskillTableInit(nums)
  self._usableSkillTable = {}
  for i = 1, nums do
    self._usableSkillTable[i] = {
      _skillName = nil,
      _skillNo = nil,
      _insertNo = nil
    }
  end
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillCoolTimeSlot_Setting()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local skillTable = {}
  local cellTable = {
    [0] = nil,
    [1] = nil
  }
  self:usableskillTableInit(self._usableSkillCount)
  local usableSkillCount = 1
  local classType = selfPlayer:getClassType()
  if classType >= 0 then
    cellTable[0] = getCombatSkillTree(classType)
    cellTable[1] = getAwakeningWeaponSkillTree(classType)
  else
    return
  end
  for iii = 0, 1 do
    if nil == cellTable[iii] then
      return
    end
    local cols = cellTable[iii]:capacityX()
    local rows = cellTable[iii]:capacityY()
    for row = 0, rows - 1 do
      for col = 0, cols - 1 do
        local cell = cellTable[iii]:atPointer(col, row)
        local skillNo = cell._skillNo
        if cell:isSkillType() then
          local skillLevelInfo = getSkillLevelInfo(skillNo)
          local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
          local skillType = getSkillTypeStaticStatus(skillNo)
          if true == skillType:isValidLocalizing() and false == skillLevelInfo._learnable and true == skillLevelInfo._usable and 0 < skillStaticWrapper:get()._reuseCycle then
            self._usableSkillTable[usableSkillCount] = {
              _skillName = skillStaticWrapper:getName(),
              _skillNo = skillNo,
              _insertNo = usableSkillCount
            }
            usableSkillCount = usableSkillCount + 1
          end
        end
      end
    end
  end
  local isLearnFusionSkill = ToClient_isLearnFusionSkillLevel() and ToClient_getFusionSkillListCount(0) ~= 0
  if true == isLearnFusionSkill then
    local cellTable2 = getFusionSkillTree()
    local cols = cellTable2:capacityX()
    local rows = cellTable2:capacityY()
    local index = 0
    for row = 0, rows - 1 do
      for col = 0, cols - 1 do
        local cell = cellTable2:atPointer(col, row)
        if cell:isSkillType() then
          local skillNo = ToClient_getFusionLearnSkillNo(index)
          index = index + 1
          if 0 ~= skillNo and true == ToClient_isLearnedSkill(skillNo) then
            local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
            local skillType = getSkillTypeStaticStatus(skillNo)
            if true == skillType:isValidLocalizing() then
              self._usableSkillTable[usableSkillCount] = {
                _skillName = skillStaticWrapper:getName(),
                _skillNo = skillNo,
                _insertNo = usableSkillCount
              }
              usableSkillCount = usableSkillCount + 1
            end
          end
        end
      end
    end
  end
  self._usableSkillCount = usableSkillCount
end
function PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate(isUp)
  local self = PaGlobal_Window_Skill_CoolTimeSlot
  self._slideIndex = UIScroll.ScrollEvent(self._slide, isUp, self._skillCoolTimeSlotList_MaxCount, self._panel_SkillCoolTimeSlot_Value_elementCount - 1, self._slideIndex, 1)
  self:update()
end
function PaGlobal_Window_Skill_CoolTimeSlot:showFunc()
  if Panel_Window_Skill:IsShow() == true then
    Panel_SkillCoolTimeSlot:SetShow(true, true)
    self._slide:SetControlPos(0)
    self._slideIndex = 0
    self:skillCoolTimeSlot_Setting()
    ClearFocusEdit()
    self:setPosition()
  else
    Panel_SkillCoolTimeSlot:SetShow(false, true)
  end
  self._editSearch._editSearchText:SetEditText("", false)
  self:update()
end
function PaGlobal_Window_Skill_CoolTimeSlot:closeFunc()
  Panel_SkillCoolTimeSlot:SetShow(false, true)
  self._editSearch._editSearchText:SetEditText("", false)
end
function PaGlobal_Window_Skill_CoolTimeSlot:init()
  self._slideBtn = UI.getChildControl(self._slide, "VerticalScroll_CtrlButton")
  for index = 1, self._skillCoolTimeSlotList_MaxCount do
    self._uiData[index] = self:skillCoolTimeSlot_MakeControl(index)
  end
  if isGameTypeKorea() then
    self._editSearch._editSearchText:SetMaxInput(20)
  else
    self._editSearch._editSearchText:SetMaxInput(40)
  end
  self._editSearch._editSearchText:SetShow(true)
  self._editSearch._editSearchButton:SetShow(true)
  Panel_SkillCoolTimeSlot:RemoveControl(self._copyUI._base_SkillBG)
  self._copyUI._base_SkillBG = nil
  Panel_SkillCoolTimeSlot:RemoveControl(self._copyUI._base_SkillIcon)
  self._copyUI._base_SkillIcon = nil
  Panel_SkillCoolTimeSlot:RemoveControl(self._copyUI._base_SkillName)
  self._copyUI._base_SkillName = nil
  Panel_SkillCoolTimeSlot:RemoveControl(self._copyUI._base_ComboBox)
  self._copyUI._base_ComboBox = nil
  UIScroll.InputEvent(self._slide, "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate")
  self._editSearch._editSearchButton:addInputEvent("Mouse_LUp", "PaGlobal_Window_Skill_CoolTimeSlot:searchbuttonClick()")
  self._editSearch._editSearchText:addInputEvent("Mouse_LDown", "PaGlobal_Window_Skill_CoolTimeSlot:searchText_Click()")
  self._editSearch._editSearchText:addInputEvent("Mouse_LUp", "PaGlobal_Window_Skill_CoolTimeSlot:searchText_Click()")
  self._editSearch._editSearchText:RegistReturnKeyEvent("PaGlobal_Window_Skill_CoolTimeSlot:searchbuttonClick()")
  self._frameBG:addInputEvent("Mouse_UpScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( true )")
  self._frameBG:addInputEvent("Mouse_DownScroll", "PaGlobal_Window_Skill_CoolTimeSlot:scrollUpdate( false )")
  self._initButton:addInputEvent("Mouse_LUp", "PaGlobal_Window_Skill_CoolTimeSlot:allSkillClear()")
  self._uiSettingButton:addInputEvent("Mouse_LUp", "FGlobal_UiSet_Open(false)")
  self:bottomDesc_Setting()
  self:skillCoolTimeSlot_Setting()
  self:update()
end
function PaGlobal_Window_Skill_CoolTimeSlot:bottomDesc_Setting()
  self._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._desc:SetText(self._desc:GetText())
end
function PaGlobal_Window_Skill_CoolTimeSlot:searchbuttonClick()
  local self = PaGlobal_Window_Skill_CoolTimeSlot
  if false == CheckChattingInput() then
    ClearFocusEdit()
  end
  self._slideIndex = 0
  self:update()
end
function PaGlobal_Window_Skill_CoolTimeSlot:searchText_Click()
  SetFocusEdit(self._editSearch._editSearchText)
  self._editSearch._editSearchText:SetEditText("", false)
end
function PaGlobal_Window_Skill_CoolTimeSlot:allSkillClear()
  ToClient_allClearSkillCoolTimeSlot()
  self._editSearch._editSearchText:SetEditText("", false)
  self:update()
  PaGlobal_SkillCoolTimeQuickSlot:updateQuickSlot()
end
function PaGlobal_Window_Skill_CoolTimeSlot:skillUpdate()
  self._editSearch._editSearchText:SetEditText("", false)
  self:skillCoolTimeSlot_Setting()
  self:update()
  PaGlobal_SkillCoolTimeQuickSlot:updateQuickSlot()
end
function FromClient_SkillCoolTimeSlotUpdate()
  PaGlobal_Window_Skill_CoolTimeSlot:skillUpdate()
end
function PaGlobal_Window_Skill_CoolTimeSlot:registMessageHandler()
  registerEvent("FromClient_SkillCoolTimeSlotUpdate", "FromClient_SkillCoolTimeSlotUpdate")
end
PaGlobal_Window_Skill_CoolTimeSlot:init()
PaGlobal_Window_Skill_CoolTimeSlot:registMessageHandler()
