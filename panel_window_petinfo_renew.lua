Panel_Window_PetInfo_Renew:SetShow(false)
Panel_Window_PetInfo_Renew:ignorePadSnapMoveToOtherPanel()
local petInfo = {
  _ui = {
    _static_topBG = UI.getChildControl(Panel_Window_PetInfo_Renew, "Static_TopBG"),
    _static_bottomLeftBG = UI.getChildControl(Panel_Window_PetInfo_Renew, "Static_BottomLeftBG"),
    _static_bottomRightBG = UI.getChildControl(Panel_Window_PetInfo_Renew, "Static_BottomRightBG"),
    _static_bottomKeyBG = UI.getChildControl(Panel_Window_PetInfo_Renew, "Static_BottomKeyBG"),
    _stc_skillFocus = UI.getChildControl(Panel_Window_PetInfo_Renew, "Static_SkillFocus"),
    _scroll_actionList = nil,
    _scrollBtn_actionList = nil,
    _petInfoFrame = {
      _radioBtn_Skills = Array.new(),
      _radioBtn_Actions = Array.new()
    }
  },
  _config = {
    _skillType_Default = 0,
    _skillType_Special = 1,
    _skillType_Max = 2,
    _skill_MaxCount = 4,
    _action_MaxCount = 5,
    _action_HasCount = 0,
    _skillBtn = {
      _startX = 20,
      _startY = 60,
      _gapY = 66
    },
    _actionBtn = {
      _startX = 20,
      _startY = 60,
      _gapX = 105,
      _gapY = 52,
      _action_lineMaxCount = 5
    },
    _tierColorTable = {
      [1] = Defines.Color.C_FF686868,
      [2] = Defines.Color.C_FF6F6D10,
      [3] = Defines.Color.C_FF3B6491,
      [4] = Defines.Color.C_FFB68827,
      [5] = Defines.Color.C_FFC95A40
    },
    _gradeColorTable = {
      [1] = Defines.Color.C_FFB1B118,
      [2] = Defines.Color.C_FF65AED6,
      [3] = Defines.Color.C_FFCC9AD5,
      [4] = Defines.Color.C_FFB68827,
      [5] = Defines.Color.C_FFD56045
    },
    _gradeTextTable = {
      [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_CLASSIC_TITLE"),
      [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_LIMITED_TITLE"),
      [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_PREMIUM_TITLE"),
      [4] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_EVENT_TITLE"),
      [5] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_SPECIAL_TITLE")
    }
  },
  _petNo = 0,
  _currentPetLv = {},
  _keyGuideAlign = {},
  _isActionScrollDown = false
}
function petInfo:initialize()
  self:initControl()
  self:createButton()
  self:setPosition()
end
function petInfo:open()
  self._ui._stc_skillFocus:SetShow(false)
  self._isActionScrollDown = false
  self:setPosition()
  self:update()
end
function petInfo:close(closeAll)
  if Panel_Window_PetInfo_Renew:GetShow() then
    Panel_Window_PetInfo_Renew:SetShow(false)
  end
  if false == closeAll then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  PaGlobalFunc_Petlist_TemporaryOpen()
end
function petInfo:update()
  local PcPetData
  local petCount = 0
  local isSet = false
  petCount = ToClient_getPetUnsealedList()
  for index = 0, petCount - 1 do
    PcPetData = ToClient_getPetUnsealedDataByIndex(index)
    if nil ~= PcPetData and self._petNo == PcPetData:getPcPetNo() then
      isSet = true
      break
    end
  end
  if false == isSet then
    return
  end
  local petStaticStatus = PcPetData:getPetStaticStatus()
  local petName = PcPetData:getName()
  local petNum_s64 = PcPetData:getPcPetNo()
  local petNum_S32 = Int64toInt32(petNum_s64)
  local petLevel = PcPetData:getLevel()
  local iconPath = PcPetData:getIconPath()
  local petTier = petStaticStatus:getPetTier() + 1
  local petRace = petStaticStatus:getPetRace()
  local petKind = petStaticStatus:getPetKind()
  local petGrade = ToClient_getGrade(petRace, petKind)
  for idx = 0, self._config._skillType_Max - 1 do
    self:setAbilityInfoByType(PcPetData, idx)
  end
  local _descPosY = self._ui._petInfoFrame._static_specialSkill:GetPosY() + self._ui._petInfoFrame._static_specialSkill:GetTextSizeY() + 5
  self._ui._petInfoFrame._static_defaultSkill:SetPosY(_descPosY)
  local actionBtn = self._ui._petInfoFrame._radioBtn_Actions
  local petActionCount = ToClient_getPetActionMax()
  for idx = 0, self._config._action_MaxCount - 1 do
    actionBtn[idx]._slot:SetShow(true)
    actionBtn[idx]._icon:SetShow(false)
    actionBtn[idx]._name:SetShow(false)
  end
  local uiIdx = 0
  for idx = 0, petActionCount - 1 do
    local actionStaticStatus = ToClient_getPetActionStaticStatus(idx)
    local isLearn = PcPetData:isPetActionLearned(idx)
    if true == isLearn then
      actionBtn[uiIdx]._icon:ChangeTextureInfoNameAsync("Icon/" .. actionStaticStatus:getIconPath())
      actionBtn[uiIdx]._name:SetText(actionStaticStatus:getName())
      actionBtn[uiIdx]._icon:SetShow(true)
      actionBtn[uiIdx]._name:SetShow(true)
      uiIdx = uiIdx + 1
    end
    if uiIdx >= self._config._action_MaxCount then
      if true == self._isActionScrollDown then
        for ii = 0, self._config._action_MaxCount - 1 do
          actionBtn[ii]._icon:SetShow(false)
          actionBtn[ii]._name:SetShow(false)
        end
        uiIdx = 0
      else
        break
      end
    end
  end
  local hasCount = 0
  for idx = 0, petActionCount - 1 do
    local isLearn = PcPetData:isPetActionLearned(idx)
    if true == isLearn then
      hasCount = hasCount + 1
    end
  end
  self._action_HasCount = hasCount
  if self._action_HasCount > self._config._action_MaxCount then
    self._ui._scroll_actionList:SetShow(true)
    if true == self._isActionScrollDown then
      self._ui._scrollBtn_actionList:SetPosY(self._ui._scroll_actionList:GetSizeY() - self._ui._scrollBtn_actionList:GetSizeY())
    else
      self._ui._scrollBtn_actionList:SetPosY(0)
    end
  else
    self._ui._scroll_actionList:SetShow(false)
  end
  local skillBtn = self._ui._petInfoFrame._radioBtn_Skills
  for idx = 0, self._config._skill_MaxCount - 1 do
    skillBtn[idx]._slot:SetShow(true)
    skillBtn[idx]._icon:SetShow(false)
    skillBtn[idx]._name:SetShow(false)
    skillBtn[idx]._index = nil
  end
  uiIdx = 0
  local baseSkillIndex = PcPetData:getPetBaseSkillIndex()
  local skillStaticStatus = ToClient_getPetBaseSkillStaticStatus(baseSkillIndex)
  if nil ~= skillStaticStatus then
    local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
    if nil ~= skillTypeStaticWrapper then
      local skillNo = skillStaticStatus:getSkillNo()
      skillBtn[uiIdx]._icon:ChangeTextureInfoNameAsync("Icon/" .. skillTypeStaticWrapper:getIconPath())
      skillBtn[uiIdx]._name:SetText(skillStaticStatus:getName())
      skillBtn[uiIdx]._name:SetShow(true)
      skillBtn[uiIdx]._icon:SetShow(true)
      skillBtn[uiIdx]._index = baseSkillIndex
    end
  end
  uiIdx = uiIdx + 1
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  for index = 0, skillMaxCount - 1 do
    local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(index)
    local isLearn = PcPetData:isPetEquipSkillLearned(index)
    if true == isLearn and nil ~= skillStaticStatus then
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper then
        local skillNo = skillStaticStatus:getSkillNo()
        skillBtn[uiIdx]._icon:ChangeTextureInfoNameAsync("Icon/" .. skillTypeStaticWrapper:getIconPath())
        skillBtn[uiIdx]._name:SetText(skillStaticStatus:getName())
        skillBtn[uiIdx]._name:SetShow(true)
        skillBtn[uiIdx]._icon:SetShow(true)
        skillBtn[uiIdx]._index = index
        uiIdx = uiIdx + 1
      end
      if uiIdx >= self._config._skill_MaxCount then
        break
      end
    end
  end
  local petExp_s64 = PcPetData:getExperience()
  local petExp_s32 = Int64toInt32(petExp_s64)
  local petMaxExp_s64 = PcPetData:getMaxExperience()
  local petMaxExp_s32 = Int64toInt32(petMaxExp_s64)
  local petExpPercent = petExp_s32 / petMaxExp_s32 * 100
  local petInfoUI = self._ui._petInfoFrame
  petInfoUI._static_petName:SetText(petName)
  petInfoUI._static_petIcon:ChangeTextureInfoNameAsync(iconPath)
  petInfoUI._static_petIconTierInfo:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PET_TIER", "tier", petTier))
  petInfoUI._static_petIconTierInfo:SetColor(self._config._tierColorTable[petTier])
  petInfoUI._static_petIconGradeInfo:SetText(self._config._gradeTextTable[petGrade])
  petInfoUI._static_petIconGradeInfo:SetFontColor(self._config._gradeColorTable[petGrade])
  petInfoUI._progress_level:SetProgressRate(petExpPercent)
  petInfoUI._static_petLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. petLevel)
  petInfoUI._static_petExp:SetText(string.format("%.1f", petExpPercent) .. "%")
  if nil == self._currentPetLv[petNum_S32] then
    self._currentPetLv[petNum_S32] = petLevel
  end
  if self._currentPetLv[petNum_S32] ~= petLevel then
    if petLevel > 1 and 1 < self._currentPetLv[petNum_S32] then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_PETLEVELUP_ACK", "petName", petName))
    end
    self._currentPetLv[petNum_S32] = petLevel
  end
end
function petInfo:setPosition()
  local scrSizeX = getOriginScreenSizeX()
  local scrSizeY = getOriginScreenSizeY()
  local panelSizeX = Panel_Window_PetInfo_Renew:GetSizeX()
  local panelSizeY = Panel_Window_PetInfo_Renew:GetSizeY()
  Panel_Window_PetInfo_Renew:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_Window_PetInfo_Renew:SetPosY(scrSizeY / 2 - panelSizeY / 2)
end
function petInfo:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_PetInfo_luaLoadComplete")
  Panel_Window_PetInfo_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickUp, "HandleEvent_PetInfo_ActionScroll()")
  Panel_Window_PetInfo_Renew:registerPadEvent(__eConsoleUIPadEvent_RStickDown, "HandleEvent_PetInfo_ActionScroll()")
end
function FromClient_PetInfo_luaLoadComplete()
  petInfo:initialize()
end
function petInfo:initControl()
  local petInfoUI = self._ui
  petInfoUI._petInfoFrame._static_petName = UI.getChildControl(petInfoUI._static_topBG, "StaticText_PetName")
  petInfoUI._petInfoFrame._static_petIconSlot = UI.getChildControl(petInfoUI._static_topBG, "Static_PetIconSlot")
  petInfoUI._petInfoFrame._static_petIcon = UI.getChildControl(petInfoUI._petInfoFrame._static_petIconSlot, "Static_PetIcon")
  petInfoUI._petInfoFrame._static_petIconTierInfo = UI.getChildControl(petInfoUI._petInfoFrame._static_petIconSlot, "StaticText_Tier")
  petInfoUI._petInfoFrame._static_petIconGradeInfo = UI.getChildControl(petInfoUI._petInfoFrame._static_petIconSlot, "StaticText_Grade")
  petInfoUI._petInfoFrame._static_specialSkill = UI.getChildControl(petInfoUI._static_topBG, "StaticText_SpecialSkill")
  petInfoUI._petInfoFrame._static_defaultSkill = UI.getChildControl(petInfoUI._static_topBG, "StaticText_DefaultSkill")
  petInfoUI._petInfoFrame._static_petLevel = UI.getChildControl(petInfoUI._static_topBG, "StaticText_Level")
  petInfoUI._petInfoFrame._static_petExp = UI.getChildControl(petInfoUI._static_topBG, "StaticText_Exp")
  petInfoUI._petInfoFrame._progress_level = UI.getChildControl(petInfoUI._static_topBG, "Progress2_Level")
  petInfoUI._petInfoFrame._static_Exit = UI.getChildControl(petInfoUI._static_bottomKeyBG, "StaticText_Close_ConsoleUI")
  petInfoUI._scroll_actionList = UI.getChildControl(petInfoUI._static_bottomRightBG, "VerticalScroll")
  petInfoUI._scrollBtn_actionList = UI.getChildControl(petInfoUI._scroll_actionList, "VerticalScroll_CtrlButton")
  self._keyGuideAlign = {
    petInfoUI._petInfoFrame._static_Exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, petInfoUI._static_bottomKeyBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function petInfo:createButton()
  local UCT = CppEnums.PA_UI_CONTROL_TYPE
  local _skillBtn = UI.getChildControl(self._ui._static_bottomLeftBG, "RadioButton_SkillBG")
  local _skillName = UI.getChildControl(_skillBtn, "StaticText_SkillName")
  _skillBtn:SetShow(false)
  local skillBtn = self._ui._petInfoFrame._radioBtn_Skills
  for idx = 0, self._config._skill_MaxCount - 1 do
    local info = {}
    info._slot = UI.cloneControl(_skillBtn, self._ui._static_bottomLeftBG, "SkillSlot_" .. idx)
    info._icon = UI.getChildControl(info._slot, "Static_SkillIcon")
    info._name = UI.getChildControl(info._slot, "StaticText_SkillName")
    info._index = nil
    info._name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    info._slot:SetPosY(self._config._skillBtn._startY + self._config._skillBtn._gapY * idx)
    info._slot:addInputEvent("Mouse_On", "PaGlobalFunc_PetInfo_OnSkillSlot(" .. idx .. ")")
    skillBtn[idx] = info
  end
  local _actionBtn = UI.getChildControl(self._ui._static_bottomRightBG, "RadioButton_BehaviorBG")
  _actionBtn:SetShow(false)
  local actionBtn = self._ui._petInfoFrame._radioBtn_Actions
  for idx = 0, self._config._action_MaxCount - 1 do
    local info = {}
    info._slot = UI.cloneControl(_actionBtn, self._ui._static_bottomRightBG, "BehaviorSlot_" .. idx)
    info._icon = UI.getChildControl(info._slot, "Static_BehaviorIcon")
    info._name = UI.getChildControl(info._slot, "StaticText_BehaviorName")
    info._slot:SetPosY(self._config._actionBtn._startY + self._config._actionBtn._gapY * idx)
    actionBtn[idx] = info
  end
end
function HandleEvent_PetInfo_ActionScroll()
  if true == petInfo._isActionScrollDown then
    petInfo._isActionScrollDown = false
  else
    petInfo._isActionScrollDown = true
  end
  petInfo:update()
end
function petInfo:setAbilityInfoByType(PcPetData, skillNo)
  local paramText = PaGlobalFunc_PetInfo_SetPetSkillTextByType(PcPetData, skillNo)
  if self._config._skillType_Default == skillNo then
    self._ui._petInfoFrame._static_defaultSkill:SetShow(true)
    self._ui._petInfoFrame._static_defaultSkill:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._petInfoFrame._static_defaultSkill:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_BASESKILL", "paramText", paramText))
  elseif self._config._skillType_Special == skillNo then
    self._ui._petInfoFrame._static_specialSkill:SetShow(true)
    self._ui._petInfoFrame._static_specialSkill:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._petInfoFrame._static_specialSkill:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_SPECIALSKILL", "paramText", paramText))
  end
end
function PaGlobalFunc_PetInfo_Open(petNo)
  local self = petInfo
  self._petNo = tonumber64(petNo)
  self:open()
  Panel_Window_PetInfo_Renew:SetShow(true)
end
function PaGlobalFunc_PetInfo_Close(closeAll)
  petInfo:close(closeAll)
end
function PaGlobalFunc_PetInfo_OnSkillSlot(buttonIndex)
  local self = petInfo
  local skillIndex = self._ui._petInfoFrame._radioBtn_Skills[buttonIndex]._index
  if nil ~= skillIndex then
    local skillStaticStatus
    if 0 == buttonIndex then
      skillStaticStatus = ToClient_getPetBaseSkillStaticStatus(skillIndex)
    else
      skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skillIndex)
    end
    if nil ~= skillStaticStatus then
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper then
        local skillData = {}
        skillData.name = skillTypeStaticWrapper:getName()
        skillData.desc = skillTypeStaticWrapper:getDescription()
        PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.CashBuffData, skillData, Defines.TooltipTargetType.CashBuff, self._ui._petInfoFrame._radioBtn_Skills[buttonIndex]._slot)
      end
    end
  end
  local slot = self._ui._petInfoFrame._radioBtn_Skills[buttonIndex]._slot
  self._ui._stc_skillFocus:SetShow(true)
  self._ui._stc_skillFocus:ActiveMouseEventEffect(true)
  self._ui._stc_skillFocus:SetPosX(slot:GetPosX() + self._ui._static_bottomLeftBG:GetPosX())
  self._ui._stc_skillFocus:SetPosY(slot:GetPosY() + self._ui._static_bottomLeftBG:GetPosY())
end
function PaGlobalFunc_PetInfo_SetPetSkillTextByType(PcPetData, skillNo)
  local skillParam = PcPetData:getSkillParam(skillNo)
  local paramText = ""
  if CppEnums.PetSkillType.Looting == skillParam._type then
    local petLootingType = PcPetData:getPetLootingType()
    local variableCount = skillParam:getParam(0)
    if CppEnums.PetLootingType.Precision == petLootingType then
      variableCount = variableCount + variableCount * (CppDefine.e1Percent * 10 / CppDefine.e100Percent)
    elseif CppEnums.PetLootingType.Celerity == petLootingType then
      variableCount = variableCount - variableCount * (CppDefine.e1Percent * 10 / CppDefine.e100Percent)
    end
    paramText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_ITEMGETTIME", "itemGetTime", string.format("%.1f", variableCount / 1000))
  elseif CppEnums.PetSkillType.AlertCollect == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDGATHER")
  elseif CppEnums.PetSkillType.AlertMurderer == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPK")
  elseif CppEnums.PetSkillType.DetectPosition == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDPLACE")
  elseif CppEnums.PetSkillType.Aggro == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_MOBAGGRO")
  elseif CppEnums.PetSkillType.FindNamedMonster == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_FINDRAREMONSTER")
  elseif CppEnums.PetSkillType.ReduceAutoFishingTime == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REDUCEAUTOFISHINGTIME")
  elseif CppEnums.PetSkillType.RegistForRegionSkill == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_REGISTILL")
  elseif CppEnums.PetSkillType.Collecting == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_AUTOGETHERING")
  elseif CppEnums.PetSkillType.CollectingBoost == skillParam._type then
    paramText = PAGetString(Defines.StringSheet_GAME, "LUA_PETINFO_PETSKILLTYPE_GETHERINGINCREASE")
  else
    return nil
  end
  return paramText
end
petInfo:registEventHandler()
