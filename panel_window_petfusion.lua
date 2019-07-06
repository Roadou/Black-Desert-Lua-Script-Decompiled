local PetFusion = {
  _ui = {
    _static_fusionBg = UI.getChildControl(Panel_Window_PetFusion, "Static_ComposeBg"),
    _static_completeBg = UI.getChildControl(Panel_Window_PetFusion, "Static_ComposeDoneBg"),
    _button_Question = UI.getChildControl(Panel_Window_PetFusion, "Button_Question"),
    _static_subBG = UI.getChildControl(Panel_Window_PetFusion, "Static_subBG"),
    _static_SelectLookBg = UI.getChildControl(Panel_Window_PetFusion, "Static_PetSkinListBg"),
    _static_SelectSkillBg = UI.getChildControl(Panel_Window_PetFusion, "Static_PetSkillListBg"),
    _static_slotTemplete = {},
    _skillSlotList = {},
    _skillRandomSlotList = {},
    _completeSkillTableList = {},
    _staticText_SelectSkillIDesc = {},
    _selectSkillList = {}
  },
  _config = {
    _subPetMaxTableCount = 4,
    _skillSlotMaxCount = 3,
    _petMaxTableCount = 5,
    _defaultName = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_NAME"),
    _infoTextsizeGap = 0
  },
  _gradeColorConfig = {
    [0] = Defines.Color.C_FFEFEFEF,
    [1] = Defines.Color.C_FFB5FF6D,
    [2] = Defines.Color.C_FF008AFF,
    [3] = Defines.Color.C_FFFFCE22
  },
  _tierProgressTextureConfig = {
    ["_texture"] = "Renewal/PcRemaster/Remaster_Pet_00.dds",
    [0] = {
      125,
      167,
      157,
      183
    },
    [1] = {
      125,
      184,
      157,
      200
    },
    [2] = {
      158,
      167,
      190,
      183
    },
    [3] = {
      125,
      218,
      157,
      234
    }
  },
  _tierEfectConfig = {
    [0] = "fUI_PetGlow_01A",
    [1] = "fUI_PetGlow_Success_02A_Green",
    [2] = "fUI_PetGlow_Success_02A_Blue",
    [3] = "fUI_PetGlow_Success_02A_Yellow"
  },
  _tierBottomEfectConfig = {
    [0] = "fUI_PetGlow_Bot",
    [1] = "fUI_PetGlow_Bot_Green",
    [2] = "fUI_PetGlow_Bot_Blue",
    [3] = "fUI_PetGlow_Bot_Yellow"
  },
  _completeTierTextureConfig = {
    ["_texture"] = "renewal/pcremaster/remaster_pet_00.dds",
    [0] = {
      157,
      102,
      189,
      134
    },
    [1] = {
      124,
      102,
      156,
      134
    },
    [2] = {
      157,
      69,
      189,
      101
    },
    [3] = {
      124,
      69,
      156,
      101
    }
  },
  _gradeStrConfig = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_CLASSIC_TITLE"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_LIMITED_TITLE"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_PREMIUM_TITLE"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_EVENT_TITLE"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_SPECIAL_TITLE"),
    [5] = "",
    [6] = "",
    [7] = "",
    [8] = "",
    [9] = ""
  },
  _mainPetSlotTable = {},
  _subPetSlotTableList = {},
  _petNoList = {},
  _sealPetIndexList = {},
  _isFourTier = false,
  _mainPetTier = -1,
  _mainRace = nil,
  _mainIsJokerPetUse = false,
  _currentSkillIndex = -1,
  _currentLookIndex = 0,
  _isFusionAble = false,
  _lookDataTableList = {},
  _skillDataTableList = {},
  _completeDataTable = {},
  _currentRate = 0,
  _isFusion = false,
  _completeDelayTime = 0,
  _isFusionStart = false,
  _fusionStartDelayTime = 0,
  _isComplete = false,
  _petName = nil
}
function PaGlobalFunc_PetFusion_GetRate()
  local self = PetFusion
  return self._currentRate
end
function PaGlobalFunc_PetFusion_GetIsJokerPetUse()
  local self = PetFusion
  return self._mainIsJokerPetUse
end
function PaGlobalFunc_PetFusion_GetRace()
  local self = PetFusion
  return self._mainRace
end
function PaGlobalFunc_PetFusion_GetIsJokerPetUse()
  local self = PetFusion
  return self._mainIsJokerPetUse
end
function PaGlobalFunc_PetFusion_IsFull()
  local self = PetFusion
  return 5 <= self:getPetNoCount()
end
function PaGlobalFunc_PetFusion_IsEmpty()
  local self = PetFusion
  return 0 == self:getPetNoCount()
end
function PaGlobalFunc_PetFusion_IsMainPetSet()
  local self = PetFusion
  return self._mainPetSlotTable._isSet
end
function PaGlobalFunc_PetFusion_GetMainPetTier()
  local self = PetFusion
  if true == PaGlobalFunc_PetFusion_IsEmpty() then
    return -1
  end
  return self._mainPetTier + 1
end
function PaGlobalFunc_PetFusion_IsExist(petNo)
  local self = PetFusion
  for _, number in pairs(self._petNoList) do
    if petNo == number then
      return true
    end
  end
  return false
end
function FGlobal_PetCompose_GetPetEditName()
  local self = PetFusion
  return self._ui._edit_Naming
end
function FGlobal_EscapeEditBox_PetCompose(bool)
  local self = PetFusion
  ClearFocusEdit(self._ui._edit_Naming)
end
function PaGlobalFunc_PetFusion_LookSelect(petNoStr)
  local self = PetFusion
  local petNo = tonumber64(petNoStr)
  local function confirm_look()
    self._currentLookIndex = self:findPetIndex(petNo) + 1
    self:updateLookSlot()
    PaGlobalFunc_PetFusion_CloseLook()
  end
  if nil == petNoStr then
    self._currentLookIndex = 0
    self:updateLookSlot()
    PaGlobalFunc_PetFusion_CloseLook()
  else
    local mainPetStaticStatus = self:getStaticStatusByPetNo(self._petNoList[0])
    local subPetStaticStatus = self:getStaticStatusByPetNo(petNo)
    if nil == mainPetStaticStatus or nil == subPetStaticStatus then
      return
    end
    if mainPetStaticStatus:getPetRace() ~= subPetStaticStatus:getPetRace() then
      local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PETFUSION_CAUTION_MESSAGE_DESC")
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "PANEL_SERVANTMIX_TITLE"),
        content = messageBoxMemo,
        functionYes = confirm_look,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    else
      confirm_look()
    end
  end
end
function PaGlobalFunc_PetFusion_SkillSelect(index)
  local self = PetFusion
  self._currentSkillIndex = index
  self:updateSkillSlot()
  PaGlobalFunc_PetFusion_CloseSkill()
end
function PaGlobalFunc_PetFusion_OpenLook()
  local self = PetFusion
  if true == PaGlobalFunc_PetFusion_IsEmpty() then
    self._ui._radioButton_SelectLook:SetCheck(false)
    return
  end
  self:loadLookData()
  self:createLookSlot()
  PaGlobalFunc_PetFusion_CloseSkill()
  self._ui._static_SelectLookBg:SetShow(true)
end
function PaGlobalFunc_PetFusion_OpenSkill()
  local self = PetFusion
  if true == PaGlobalFunc_PetFusion_IsEmpty() then
    self._ui._radioButton_SelectSkill:SetCheck(false)
    return
  end
  self:loadSkillData()
  self:createSkillSlot()
  PaGlobalFunc_PetFusion_CloseLook()
  self._ui._static_SelectSkillBg:SetShow(true)
end
function PaGlobalFunc_PetFusion_CloseLook()
  local self = PetFusion
  self._ui._radioButton_SelectLook:SetCheck(false)
  self._ui._static_SelectLookBg:SetShow(false)
end
function PaGlobalFunc_PetFusion_CloseSkill()
  local self = PetFusion
  self._ui._radioButton_SelectSkill:SetCheck(false)
  self._ui._static_SelectSkillBg:SetShow(false)
  PetList_HideSkillToolTip()
end
function PetFusion:loadLookData()
  self._lookDataTableList = {}
  self._lookDataTableList[0] = {}
  local count = 1
  for index = 0, self._config._petMaxTableCount - 1 do
    if -1 ~= self._petNoList[index] then
      for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
        local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
        local staticStatus = petData:getPetStaticStatus()
        local _petNo = petData._petNo
        if self._petNoList[index] == _petNo and 99 ~= staticStatus:getPetRace() then
          local iconPath = petData:getIconPath()
          self._lookDataTableList[count] = {}
          self._lookDataTableList[count]._iconPath = iconPath
          self._lookDataTableList[count]._petNo = self._petNoList[index]
          count = count + 1
        end
      end
    end
  end
end
function PetFusion:loadSkillData()
  self._skillDataTableList = {}
  self._skillDataTableList[0] = {}
  local count = 1
  for index = 0, self._config._petMaxTableCount - 1 do
    if -1 ~= self._petNoList[index] then
      for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
        local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
        local _petNo = petData._petNo
        if self._petNoList[index] == _petNo then
          local skillLearnCount = 0
          local skillMaxCount = ToClient_getPetEquipSkillMax()
          local petSkillCheck = {}
          self._skillDataTableList[count] = {}
          self._skillDataTableList[count]._iconPath = {}
          self._skillDataTableList[count]._skillIndex = {}
          for skill_idx = 0, skillMaxCount - 1 do
            local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
            local isLearn = petData:isPetEquipSkillLearned(skill_idx)
            if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
              petSkillCheck[skill_idx] = true
              local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
              if nil ~= skillTypeStaticWrapper and skillLearnCount < self._config._skillSlotMaxCount then
                self._skillDataTableList[count]._iconPath[skillLearnCount] = "Icon/" .. skillTypeStaticWrapper:getIconPath()
                self._skillDataTableList[count]._skillIndex[skillLearnCount] = skill_idx
                skillLearnCount = skillLearnCount + 1
              end
            end
          end
          count = count + 1
        end
      end
    end
  end
end
function PetFusion:createLookSlot()
  self._ui._list2_Look:getElementManager():clearKey()
  for index = 0, #self._lookDataTableList / 2 do
    self._ui._list2_Look:getElementManager():pushKey(toInt64(0, index))
    self._ui._list2_Look:requestUpdateByKey(toInt64(0, index))
  end
end
function PetFusion:createSkillSlot()
  self._ui._list2_Skill:getElementManager():clearKey()
  for index = 0, #self._skillDataTableList do
    self._ui._list2_Skill:getElementManager():pushKey(toInt64(0, index))
    self._ui._list2_Skill:requestUpdateByKey(toInt64(0, index))
  end
end
function PaGlobalFunc_PetFusion_CreateLookList(content, key)
  local self = PetFusion
  local key = Int64toInt32(key)
  local leftKey = key * 2
  local rightKey = key * 2 + 1
  local leftData = self._lookDataTableList[leftKey]
  local rightData = self._lookDataTableList[rightKey]
  local leftIcon = UI.getChildControl(content, "Static_PetIconLeft")
  local rightIcon = UI.getChildControl(content, "Static_PetIconRight")
  local randomIcon = UI.getChildControl(content, "Static_RandomIcon")
  local leftIconBg = UI.getChildControl(content, "Static_PetIconBgLeft")
  local rightIconBg = UI.getChildControl(content, "Static_PetIconBgRight")
  if 0 == leftKey then
    leftIcon:SetShow(false)
    randomIcon:SetShow(true)
    leftIconBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_LookSelect()")
  else
    if nil == leftData then
      self._ui._list2_Look:getElementManager():removeKey(toInt64(0, key))
      return
    end
    randomIcon:SetShow(false)
    leftIcon:SetShow(true)
    leftIcon:ChangeTextureInfoName(leftData._iconPath)
    leftIconBg:SetShow(true)
    leftIconBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_LookSelect( \"" .. tostring(leftData._petNo) .. "\")")
  end
  rightIconBg:SetShow(false)
  rightIcon:SetShow(false)
  if nil ~= rightData then
    rightIcon:SetShow(true)
    rightIcon:ChangeTextureInfoName(rightData._iconPath)
    rightIconBg:SetShow(true)
    rightIconBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_LookSelect( \"" .. tostring(rightData._petNo) .. "\")")
  end
end
function PaGlobalFunc_PetFusion_CreateSkillList(content, key)
  local self = PetFusion
  local key = Int64toInt32(key)
  local skillData = self._skillDataTableList[key]
  local skillIcon = {}
  local skillIconBg = {}
  local randomIcon = {}
  local skillBg = UI.getChildControl(content, "Static_SelectSkillIconsBg")
  self._ui._selectSkillList[key] = UI.getChildControl(content, "Static_SkillSlot_Select")
  for index = 0, 2 do
    skillIcon[index] = UI.getChildControl(content, "Static_SelectSkillIcon_" .. index + 1)
    skillIconBg[index] = UI.getChildControl(content, "Static_SkillIconBg_" .. index + 1)
    randomIcon[index] = UI.getChildControl(content, "Static_SkillRandomIcon_" .. index + 1)
    skillIcon[index]:ChangeTextureInfoName("")
    skillIconBg[index]:SetShow(true)
    randomIcon[index]:SetShow(false)
    skillIcon[index]:addInputEvent("Mouse_LUp", "")
    skillIcon[index]:addInputEvent("Mouse_On", "")
    skillIcon[index]:addInputEvent("Mouse_Out", "")
  end
  local skillCount = 0
  for index = 0, 2 do
    if 0 == key then
      skillIcon[index]:SetShow(false)
      skillIconBg[index]:SetShow(false)
      randomIcon[index]:SetShow(true)
      randomIcon[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_SkillSelect( " .. key .. " )")
      randomIcon[index]:addInputEvent("Mouse_On", "PaGlobalFunc_PetFusion_SkillSelectOn( " .. key .. " )")
      randomIcon[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_PetFusion_SkillSelectOff( " .. key .. " )")
    else
      if nil ~= skillData._iconPath[index] then
        skillIcon[index]:ChangeTextureInfoName(skillData._iconPath[index])
        skillIcon[index]:setRenderTexture(skillIcon[index]:getBaseTexture())
        skillIcon[index]:SetShow(true)
        skillIconBg[index]:SetIgnore(false)
        skillIconBg[index]:addInputEvent("Mouse_On", "PetList_ShowSkillToolTip( " .. skillData._skillIndex[index] .. ", \"petFusion_Slot_" .. key .. "\" , " .. key .. "  )")
        skillIconBg[index]:addInputEvent("Mouse_Out", "PetList_HideSkillToolTip(" .. key .. ")")
        local str = "petFusion_Slot_" .. key
        local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skillData._skillIndex[index])
        Panel_SkillTooltip_SetPosition(skillStaticStatus:getSkillNo(), skillIcon[index], str)
        skillCount = skillCount + 1
      else
        skillIconBg[index]:SetIgnore(true)
      end
      skillIconBg[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_SkillSelect( " .. key .. " )")
    end
  end
  skillBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_SkillSelect( " .. key .. " )")
  if 0 == skillCount and 0 ~= key then
    self._ui._list2_Skill:getElementManager():removeKey(toInt64(0, key))
  end
end
function PaGlobalFunc_PetFusion_SkillSelectOn(key)
  local self = PetFusion
  self._ui._selectSkillList[key]:SetShow(true)
end
function PaGlobalFunc_PetFusion_SkillSelectOff(key)
  local self = PetFusion
  self._ui._selectSkillList[key]:SetShow(false)
end
function PaGlobalFunc_PetFusion_CompleteOpen()
  local self = PetFusion
  local tier = self._completeDataTable._tier
  self._ui._static_CompleteEffectBg:EraseAllEffect()
  self._ui._static_CompleteIcon:ChangeTextureInfoName(self._completeDataTable._iconPath)
  self._ui._static_Effect:EraseAllEffect()
  self._ui._static_Effect_Bottom:EraseAllEffect()
  self._ui._static_Effect_Bottom:AddEffect(self._tierBottomEfectConfig[tier - 1], true, 0, 0)
  self._ui._staticText_CompleteTier:SetShow(true)
  self._ui._staticText_CompleteTier:ChangeTextureInfoName(self._completeTierTextureConfig._texture)
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._staticText_CompleteTier, self._completeTierTextureConfig[tier - 1][1], self._completeTierTextureConfig[tier - 1][2], self._completeTierTextureConfig[tier - 1][3], self._completeTierTextureConfig[tier - 1][4])
  self._ui._staticText_CompleteTier:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._staticText_CompleteTier:ChangeTextureInfoName(self._completeTierTextureConfig._texture)
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._staticText_CompleteTier, self._completeTierTextureConfig[tier - 1][1], self._completeTierTextureConfig[tier - 1][2], self._completeTierTextureConfig[tier - 1][3], self._completeTierTextureConfig[tier - 1][4])
  self._ui._staticText_CompleteTier:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._staticText_CompleteTier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", tier))
  self._ui._staticText_PetNameLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(self._completeDataTable._level) .. " " .. self._completeDataTable._name)
  self._ui._staticText_SpecialSkill:SetText(self._completeDataTable._specialSkill)
  self._ui._static_Grade:SetColor(self._gradeColorConfig[tier - 1])
  for index = 0, self._config._skillSlotMaxCount - 1 do
    self._ui._completeSkillTableList[index]._icon:ChangeTextureInfoName(self._completeDataTable._skillIconPathList[index])
    self._ui._completeSkillTableList[index]._desc:SetText(self._completeDataTable._skillDescList[index])
  end
  self._ui._staticText_CompleteTierChange:SetShow(false)
  if true == self._isComplete then
    local _message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_NEXTTIER_CHECK_TEXT", "BeforePetTier", self._mainPetTier + 1, "NextPetTier", tier)
    self._ui._staticText_CompleteTierChange:SetShow(true)
    self._ui._staticText_CompleteTierChange:EraseAllEffect()
    self._ui._staticText_CompleteTierChange:AddEffect("fUI_PetGlow_Success_02A_Green", true, 0, 0)
    self._ui._staticText_CompleteTierChange:SetText(_message)
    self._ui._static_Effect:AddEffect(self._tierEfectConfig[tier - 1], true, 0, 0)
    audioPostEvent_SystemUi(3, 22)
    self._isComplete = false
  else
    audioPostEvent_SystemUi(3, 23)
  end
  self:loadCompleteData(petNo)
  self._ui._button_Close:SetShow(true)
end
function PetFusion:loadCompleteData(petNo)
  local newPetData
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if nil ~= _petNo and petNo == _petNo then
      newPetData = petData
      break
    end
  end
  if nil == newPetData then
    return
  end
  local staticStatus = newPetData:getPetStaticStatus()
  if nil == staticStatus then
    return
  end
  if nil ~= newPetData:getSkillParam(1) then
    skillType = newPetData:getSkillParam(1)._type
    isPassive = newPetData:getSkillParam(1):isPassiveSkill()
  end
  self._completeDataTable._name = newPetData:getName()
  self._completeDataTable._level = newPetData._level
  self._completeDataTable._tier = staticStatus:getPetTier() + 1
  self._completeDataTable._iconPath = newPetData:getIconPath()
  self._completeDataTable._specialSkill = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PETINFO_SPECIALSKILL", "paramText", PetList_SkillTypeString(skillType))
  self._completeDataTable._skillDescList = {}
  self._completeDataTable._skillIconPathList = {}
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  local uiIndex = 0
  for skill_idx = 0, skillMaxCount - 1 do
    local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
    local isLearn = newPetData:isPetEquipSkillLearned(skill_idx)
    if true == isLearn and nil ~= skillStaticStatus then
      local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeStaticWrapper then
        local skillNo = skillStaticStatus:getSkillNo()
        self._completeDataTable._skillIconPathList[uiIndex] = "Icon/" .. skillTypeStaticWrapper:getIconPath()
        self._completeDataTable._skillDescList[uiIndex] = skillTypeStaticWrapper:getDescription()
        uiIndex = uiIndex + 1
      end
    end
  end
end
function PetFusion:fusionStartEffect()
  self._ui._static_fusionBg:SetShow(false)
  self._ui._static_completeBg:SetShow(true)
  self._ui._static_CompleteEffectBg:SetAlpha(1)
  self._ui._static_CompleteEffectBg:SetShow(true)
  self._ui._static_CompleteEffectBg:AddEffect("fUI_PetFusion_GreatSuccess", false, 0, -120)
  audioPostEvent_SystemUi(3, 21)
  self._ui._static_CompleteEffectMessage:SetShow(true)
end
function PetFusion:setComplete()
  local targetTier = self:setTargetTier(self._mainPetTier + 1)
  local tier = self._completeDataTable._tier
  self._isComplete = false
  if tier > self._mainPetTier + 1 then
    self._isComplete = true
  else
    self._isComplete = false
  end
  self._isFusion = true
  Panel_Window_PetFusion:RegisterUpdateFunc("PaGlobal_SetCompleteDelay_PerFrameUpdate")
end
function PetFusion:getPetNoCount()
  local count = 0
  for index = 0, self._config._petMaxTableCount - 1 do
    if -1 ~= self._petNoList[index] then
      count = count + 1
    end
  end
  return count
end
function PetFusion:listClear()
  for index = 0, self._config._petMaxTableCount - 1 do
    self._petNoList[index] = -1
    self._sealPetIndexList[index] = -1
  end
end
function PetFusion:findNextPetNoIndex()
  for index = 0, self._config._petMaxTableCount - 1 do
    if -1 == self._petNoList[index] then
      return index
    end
  end
  return -1
end
function PetFusion:findNextSealPetIndex()
  for index = 0, self._config._petMaxTableCount - 1 do
    if -1 == self._sealPetIndexList[index] then
      return index
    end
  end
  return -1
end
function PetFusion:findPetNo(index)
  local count = 0
  for i = 0, self._config._petMaxTableCount - 1 do
    if -1 ~= self._petNoList[i] then
      count = count + 1
    end
    if count == index then
      return self._petNoList[i]
    end
  end
end
function PetFusion:findPetIndex(petNo)
  for i = 0, self._config._petMaxTableCount - 1 do
    if petNo == self._petNoList[i] then
      return i
    end
  end
  return -1
end
function PetFusion:updateSkillSlot()
  self:skillSlotClear()
  if 0 == self._currentSkillIndex then
    return
  end
  local selectPetNo = self:findPetNo(self._currentSkillIndex)
  if -1 == selectPetNo then
    return
  end
  for index = 0, self._config._skillSlotMaxCount - 1 do
    self._ui._skillRandomSlotList[index]:SetShow(false)
  end
  local skillLearnCount = 0
  local skillMaxCount = ToClient_getPetEquipSkillMax()
  local petSkillCheck = {}
  for ii = 0, 2 do
    self._ui._staticText_SelectSkillIDesc[ii]:SetText("")
  end
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if nil ~= _petNo and selectPetNo == _petNo then
      for skill_idx = 0, skillMaxCount - 1 do
        local skillStaticStatus = ToClient_getPetEquipSkillStaticStatus(skill_idx)
        local isLearn = petData:isPetEquipSkillLearned(skill_idx)
        if true == isLearn and nil ~= skillStaticStatus and true ~= petSkillCheck[skill_idx] then
          petSkillCheck[skill_idx] = true
          local skillTypeStaticWrapper = skillStaticStatus:getSkillTypeStaticStatusWrapper()
          if nil ~= skillTypeStaticWrapper and skillLearnCount < self._config._skillSlotMaxCount then
            local skillNo = skillStaticStatus:getSkillNo()
            self._ui._skillSlotList[skillLearnCount]:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
            self._ui._skillSlotList[skillLearnCount]:setRenderTexture(self._ui._skillSlotList[skillLearnCount]:getBaseTexture())
            self._ui._staticText_SelectSkillIDesc[skillLearnCount]:SetText(skillTypeStaticWrapper:getDescription())
            self._ui._skillSlotList[skillLearnCount]:SetShow(true)
            Panel_SkillTooltip_SetPosition(skillNo, self._ui._skillSlotList[skillLearnCount], "petFusionSelect")
            skillLearnCount = skillLearnCount + 1
          end
        end
      end
    end
  end
end
function PetFusion:updateLookSlot()
  self._ui._static_SelectIcon:SetShow(false)
  self._ui._static_SelectMark:SetShow(true)
  if 0 == self._currentLookIndex then
    return
  end
  local selectPetNo = self:findPetNo(self._currentLookIndex)
  if -1 == selectPetNo then
    return
  end
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if nil ~= _petNo and selectPetNo == _petNo then
      local petSS = petData:getPetStaticStatus()
      local iconPath = petData:getIconPath()
      self._ui._static_SelectIcon:ChangeTextureInfoName(iconPath)
      self._ui._static_SelectIcon:SetShow(true)
      self._ui._static_SelectMark:SetShow(false)
      return
    end
  end
end
function PaGlobalFunc_PetFusion_ClearEdit()
  local self = PetFusion
  self._ui._edit_Naming:SetMaxInput(getGameServiceTypePetNameLength())
  SetFocusEdit(self._ui._edit_Naming)
  self._ui._edit_Naming:SetEditText("", true)
end
function PetFusion:skillSlotClear()
  for _, control in pairs(self._ui._skillSlotList) do
    control:SetShow(false)
  end
  for _, control in pairs(self._ui._skillRandomSlotList) do
    control:SetShow(true)
  end
  for _, control in pairs(self._ui._staticText_SelectSkillIDesc) do
    control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PET_RANDOM_SELECT_TITLE"))
  end
end
function petListNew_Compose_Set(petNoStr, petRace, petTier, sealPetIndex, isJokerPetUse)
  local self = PetFusion
  if Panel_Window_PetFusion:GetShow() then
    self:PetFusionInitControlSetting(false)
  end
  if true == PaGlobalFunc_PetFusion_IsFull() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETFUSION_FULL_TEXT"))
    return
  end
  if false == self:checkSetAble(tonumber64(petNoStr), petRace, sealPetIndex, petTier) then
    return
  end
  if false == PaGlobalFunc_PetFusion_IsMainPetSet() then
    self._mainRace = petRace
    self._mainIsJokerPetUse = isJokerPetUse
    self._mainPetTier = petTier - 1
    self:setMainSlot(tonumber64(petNoStr), sealPetIndex)
  else
    self:setSubSlot(tonumber64(petNoStr), sealPetIndex)
  end
  local nextPetNoIndex = self:findNextPetNoIndex()
  self._petNoList[nextPetNoIndex] = tonumber64(petNoStr)
  local nextSealPetIndex = self:findNextSealPetIndex()
  self._sealPetIndexList[nextSealPetIndex] = sealPetIndex
  self._isFusionAble = 1 < self:getPetNoCount() and true == PaGlobalFunc_PetFusion_IsMainPetSet()
  FGlobal_PetList_Set(true)
  self:setRate()
  if true == self._ui._static_SelectLookBg:GetShow() then
    PaGlobalFunc_PetFusion_OpenLook()
  end
  if true == self._ui._static_SelectSkillBg:GetShow() then
    PaGlobalFunc_PetFusion_OpenSkill()
  end
end
function PetFusion:checkSetAble(petNo, petRace, sealPetIndex, petTier)
  if true == PaGlobalFunc_PetFusion_IsExist(petNo) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETFUSION_SAME_PET_WARNING_TEXT"))
    return false
  end
  if false == PaGlobalFunc_PetList_CheckFusionButtonPcRoomPet(petNo) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETLIST_PCROOM_FUSION"))
    return false
  end
  if 100 <= PaGlobalFunc_PetFusion_GetRate() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETFUSION_100PERCENT_TEXT"))
    return false
  end
  if true == PaGlobalFunc_PetFusion_IsMainPetSet() and petTier > PaGlobalFunc_PetFusion_GetMainPetTier() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_RENEWAL_PETLIST_TEMP_3"))
    return false
  end
  if true == PaGlobalFunc_PetFusion_IsMainPetSet() and 99 == petRace and false == PaGlobalFunc_PetFusion_GetIsJokerPetUse() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_RENEWAL_PETLIST_TEMP_8"))
    return false
  end
  if true == PaGlobalFunc_PetFusion_IsMainPetSet() then
    local mainPetStaticStatus = self:getStaticStatusByPetNo(self._petNoList[0])
    local subPetStaticStatus = self:getStaticStatusByPetNo(petNo)
    local mainGrade = ToClient_getGrade(mainPetStaticStatus:getPetRace(), mainPetStaticStatus:getPetKind())
    local subGrade = ToClient_getGrade(subPetStaticStatus:getPetRace(), subPetStaticStatus:getPetKind())
    if 99 ~= petRace and mainGrade ~= subGrade then
      local message = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_PETCOMPOSE_SAME_GRADETYPE_WARNING_TEXT", "gradeType1", self._gradeStrConfig[mainGrade - 1], "gradeType2", self._gradeStrConfig[mainGrade - 1])
      Proc_ShowMessage_Ack(message)
      return false
    end
  end
  if false == PaGlobalFunc_PetFusion_IsMainPetSet() and 99 == petRace then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_RENEWAL_PETLIST_TEMP_9"))
    return false
  end
  return true
end
function PaGlobalFunc_PetFusion_SetAbleByGrade(petNo)
  local self = PetFusion
  if false == PaGlobalFunc_PetFusion_IsMainPetSet() then
    return true
  end
  local mainPetStaticStatus = self:getStaticStatusByPetNo(self._petNoList[0])
  local subPetStaticStatus = self:getStaticStatusByPetNo(petNo)
  if nil == mainPetStaticStatus or nil == subPetStaticStatus then
    return
  end
  local mainGrade = ToClient_getGrade(mainPetStaticStatus:getPetRace(), mainPetStaticStatus:getPetKind())
  local subGrade = ToClient_getGrade(subPetStaticStatus:getPetRace(), subPetStaticStatus:getPetKind())
  if mainGrade == subGrade then
    return true
  else
    return false
  end
end
function PaGlobalFunc_PetFusion_SetAbleByTier(tier)
  if false == PaGlobalFunc_PetFusion_IsMainPetSet() then
    return true
  end
  if tier > PaGlobalFunc_PetFusion_GetMainPetTier() then
    return false
  else
    return true
  end
end
function PetFusion:getStaticStatusByPetNo(petNo)
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      return petData:getPetStaticStatus()
    end
  end
  return nil
end
function petListNew_Compose_UnSet(petNoStr, sealPetIndex)
  local self = PetFusion
  local unSetPetNo = tonumber64(petNoStr)
  for index = 0, self._config._petMaxTableCount - 1 do
    if unSetPetNo == self._petNoList[index] then
      self._petNoList[index] = -1
      break
    end
  end
  for index = 0, self._config._petMaxTableCount - 1 do
    if sealPetIndex == self._sealPetIndexList[index] then
      self._sealPetIndexList[index] = -1
      break
    end
  end
  self:unSetSlot(unSetPetNo)
  self._isFusionAble = 1 < self:getPetNoCount() and true == PaGlobalFunc_PetFusion_IsMainPetSet()
  FGlobal_PetList_Set(true)
  self:setRate()
  if true == self._ui._static_SelectLookBg:GetShow() then
    PaGlobalFunc_PetFusion_OpenLook()
  end
  if true == self._ui._static_SelectSkillBg:GetShow() then
    PaGlobalFunc_PetFusion_OpenSkill()
  end
  self._currentLookIndex = 0
  self:updateLookSlot()
  self._currentSkillIndex = 0
  self:updateSkillSlot()
end
function PetFusion:unSetSlot(unSetPetNo)
  if unSetPetNo == self._mainPetSlotTable._petNo then
    self:clear()
    return
  end
  for index = 0, self._config._subPetMaxTableCount - 1 do
    if unSetPetNo == self._subPetSlotTableList[index]._petNo then
      self._subPetSlotTableList[index]._icon:SetShow(false)
      self._subPetSlotTableList[index]._grade:SetShow(false)
      self._subPetSlotTableList[index]._tier:SetShow(false)
      self._subPetSlotTableList[index]._isSet = false
      self._subPetSlotTableList[index]._petNo = -1
    end
  end
end
function PetFusion:setRate()
  if false == self._isFusionAble then
    self:rateClear()
    return
  end
  local mainStaticStatus = self:getStaticStatusByPetNo(self._petNoList[0])
  if nil == mainStaticStatus then
    return
  end
  self._mainPetTier = mainStaticStatus:getPetTier()
  local targetTier = self:setTargetTier(self._mainPetTier + 1)
  local mainRate = Int64toInt32(ToClient_getMainFusionRate(self._mainPetTier)) / 10000
  local addRate = 0
  for index = 1, self._config._petMaxTableCount - 1 do
    if -1 ~= self._sealPetIndexList[index] then
      local subPetData = ToClient_getPetSealedDataByIndex(self._sealPetIndexList[index])
      if nil ~= subPetData then
        local subStaticStatus = subPetData:getPetStaticStatus()
        if nil ~= subStaticStatus then
          local subTier = subStaticStatus:getPetTier()
          local subRace = subStaticStatus:getPetRace()
          addRate = addRate + Int64toInt32(ToClient_getAddFusionRate(self._mainPetTier, subTier, subRace)) / 10000
        end
      end
    end
  end
  local totalRate = math.min(100, mainRate + addRate)
  totalRate = math.floor(totalRate + 0.5)
  self._currentRate = totalRate
  self._ui._staticText_N1Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", targetTier))
  self._ui._staticText_N2Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", targetTier - 1))
  self._ui._staticText_N1Value:SetText(totalRate .. "%")
  self._ui._staticText_N2Value:SetText(100 - totalRate .. "%")
  self._ui._progress2_N1:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Pet_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._progress2_N1, self._tierProgressTextureConfig[targetTier - 1][1], self._tierProgressTextureConfig[targetTier - 1][2], self._tierProgressTextureConfig[targetTier - 1][3], self._tierProgressTextureConfig[targetTier - 1][4])
  self._ui._progress2_N1:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._progress2_N1:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Pet_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._progress2_N1, self._tierProgressTextureConfig[targetTier - 1][1], self._tierProgressTextureConfig[targetTier - 1][2], self._tierProgressTextureConfig[targetTier - 1][3], self._tierProgressTextureConfig[targetTier - 1][4])
  self._ui._progress2_N1:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._progress2_N2:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Pet_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._progress2_N2, self._tierProgressTextureConfig[targetTier - 2][1], self._tierProgressTextureConfig[targetTier - 2][2], self._tierProgressTextureConfig[targetTier - 2][3], self._tierProgressTextureConfig[targetTier - 2][4])
  self._ui._progress2_N2:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._progress2_N2:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Pet_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._progress2_N2, self._tierProgressTextureConfig[targetTier - 2][1], self._tierProgressTextureConfig[targetTier - 2][2], self._tierProgressTextureConfig[targetTier - 2][3], self._tierProgressTextureConfig[targetTier - 2][4])
  self._ui._progress2_N2:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._progress2_N1:SetProgressRate(totalRate)
  self._ui._progress2_N2:SetProgressRate(100 - totalRate)
  self._ui._staticText_N1Title:SetFontColor(self._gradeColorConfig[targetTier - 1])
  self._ui._staticText_N2Title:SetFontColor(self._gradeColorConfig[targetTier - 2])
  self._ui._progress2_N1:SetColor(self._gradeColorConfig[targetTier - 1])
  self._ui._progress2_N2:SetColor(self._gradeColorConfig[targetTier - 2])
  self._ui._staticText_N2Title:SetShow(not self._isFourTier)
  self._ui._staticText_N2Value:SetShow(not self._isFourTier)
  self._ui._progress2_N2:SetShow(not self._isFourTier)
  self._ui._progress2_N2Bg:SetShow(not self._isFourTier)
end
function PetFusion:setTargetTier(mainFusionPetTier)
  if 4 == mainFusionPetTier then
    self._isFourTier = true
  end
  if mainFusionPetTier < 3 then
    return 3
  else
    return 4
  end
end
function PetFusion:setSubSlot(petNo, sealPetIndex)
  local slot = self:findNextSlot()
  if nil == slot then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\138\172\235\161\175\236\157\180 \234\176\128\235\147\157 \236\176\188\236\138\181\235\139\136\235\139\164.")
    return
  end
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      local petSS = petData:getPetStaticStatus()
      local iconPath = petData:getIconPath()
      slot._tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petSS:getPetTier() + 1))
      slot._tier:SetShow(true)
      slot._grade:SetColor(self._gradeColorConfig[petSS:getPetTier()])
      slot._grade:SetShow(true)
      slot._icon:ChangeTextureInfoName(iconPath)
      slot._icon:SetShow(true)
      slot._isSet = true
      slot._petNo = petNo
      slot._icon:addInputEvent("Mouse_RUp", "petListNew_Compose_UnSet(\"" .. tostring(petNo) .. "\"," .. sealPetIndex .. " )")
      return
    end
  end
end
function PetFusion:findNextSlot()
  for index = 0, #self._subPetSlotTableList do
    if false == self._subPetSlotTableList[index]._isSet then
      return self._subPetSlotTableList[index]
    end
  end
  return nil
end
function PetFusion:setMainSlot(petNo, sealPetIndex)
  local slot = self._mainPetSlotTable
  for sealPetIndex = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(sealPetIndex)
    local _petNo = petData._petNo
    if petNo == _petNo then
      local petSS = petData:getPetStaticStatus()
      local iconPath = petData:getIconPath()
      slot._icon:ChangeTextureInfoName(iconPath)
      slot._icon:SetShow(true)
      slot._tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", petSS:getPetTier() + 1))
      slot._tier:SetShow(true)
      slot._level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(petData._level))
      slot._level:SetShow(true)
      slot._grade:SetColor(self._gradeColorConfig[petSS:getPetTier()])
      slot._grade:SetShow(true)
      slot._mark:SetShow(false)
      slot._petNo = petNo
      slot._isSet = true
      self._ui._staticText_SelectPetLevel:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PET_COMPOSE_FACTORIAL_LV_TITLE", "level", tostring(petData._level)))
      slot._icon:addInputEvent("Mouse_RUp", "petListNew_Compose_UnSet(\"" .. tostring(petNo) .. "\"," .. sealPetIndex .. " )")
      return
    end
  end
end
function PetFusion:clear()
  self._mainPetSlotTable._grade:SetShow(false)
  self._mainPetSlotTable._icon:SetShow(false)
  self._mainPetSlotTable._tier:SetShow(false)
  self._mainPetSlotTable._level:SetShow(false)
  self._mainPetSlotTable._mark:SetShow(true)
  self._mainPetSlotTable._petNo = -1
  self._mainPetSlotTable._isSet = false
  for _, slot in pairs(self._subPetSlotTableList) do
    slot._grade:SetShow(false)
    slot._icon:SetShow(false)
    slot._tier:SetShow(false)
    slot._isSet = false
    slot._petNo = -1
  end
  for _, control in pairs(self._ui._staticText_SelectSkillIDesc) do
    control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_PET_COMPOSE_SKILLSELECT_NEW_DESC"))
  end
  self._isFourTier = false
  self._mainPetTier = -1
  self._mainRace = nil
  self._mainIsJokerPetUse = false
  self._isFusionAble = false
  self._currentLookIndex = 0
  self._currentSkillIndex = 0
  self:listClear()
  self:rateClear()
  self._ui._static_SelectIcon:SetShow(false)
  self._ui._static_SelectMark:SetShow(true)
  for _, control in pairs(self._ui._skillSlotList) do
    control:SetShow(false)
  end
  self._ui._edit_Naming:SetEditText("", true)
  self._ui._edit_Naming:SetText(self._config._defaultName)
  self._ui._staticText_SelectPetLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(0))
  self._ui._static_fusionBg:SetShow(true)
  self._ui._static_completeBg:SetShow(false)
  PaGlobalFunc_PetFusion_CloseSkill()
  PaGlobalFunc_PetFusion_CloseLook()
  self._fusionStartDelayTime = 0
  self._isFusionStart = false
  self._completeDelayTime = 0
  self._isFusion = false
  self._ui._staticText_CompleteTier:SetText("")
  self._ui._staticText_PetNameLevel:SetText("")
  self._ui._staticText_SpecialSkill:SetText("")
  for index = 0, self._config._skillSlotMaxCount - 1 do
    self._ui._completeSkillTableList[index]._icon:ChangeTextureInfoName("")
    self._ui._completeSkillTableList[index]._desc:SetText("")
  end
  self._ui._static_CompleteEffectBg:EraseAllEffect()
  self._ui._static_CompleteIcon:ChangeTextureInfoName("")
  self._ui._static_Effect:EraseAllEffect()
  self._ui._static_Effect_Bottom:EraseAllEffect()
  self._ui._staticText_CompleteTier:ChangeTextureInfoName("")
  self._ui._staticText_CompleteTierChange:EraseAllEffect()
  self._ui._staticText_CompleteTierChange:SetText("")
  self._ui._static_CompleteEffectBg:SetAlpha(1)
  self._ui._static_CompleteEffectBg:SetShow(true)
end
function PetFusion:rateClear()
  self._ui._staticText_N1Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", 0))
  self._ui._staticText_N2Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", 0))
  self._ui._staticText_N1Title:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui._staticText_N2Title:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui._staticText_N1Value:SetText(0 .. "%")
  self._ui._staticText_N2Value:SetText(0 .. "%")
  self._ui._progress2_N1:SetProgressRate(0)
  self._ui._progress2_N2:SetProgressRate(0)
  self._currentRate = 0
end
function PaGlobalFunc_PetFusion_SetPos()
  Panel_Window_PetFusion:SetPosX(Panel_Window_PetListNew:GetPosX() + Panel_Window_PetListNew:GetSizeX() + 5)
  Panel_Window_PetFusion:SetPosY(Panel_Window_PetListNew:GetPosY())
end
function PaGlobalFunc_PetFusion_GetPanelSizeX()
  return Panel_Window_PetFusion:GetSizeX()
end
function PetFusion:initialize()
  self:createControl()
  self:initEvent()
end
function PetFusion:createControl()
  self._ui._static_SelectBg = UI.getChildControl(self._ui._static_fusionBg, "Static_SelectBg")
  self._ui._static_SelectDescBg = UI.getChildControl(self._ui._static_fusionBg, "Static_SelectDescBg")
  self._ui._staticText_SelectDesc = UI.getChildControl(self._ui._static_SelectDescBg, "StaticText_SelectDesc")
  self._ui._staticText_SelectDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_SelectDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_PETFUSION_FIRSTSELECT_INFO_DESC"))
  self._mainPetSlotTable._bg = UI.getChildControl(self._ui._static_fusionBg, "Static_Leader_PetIconBg")
  self._ui._staticText_SelectSkillIDesc = {
    [0] = UI.getChildControl(self._ui._static_SelectBg, "StaticText_SelectSkillIDesc_1"),
    [1] = UI.getChildControl(self._ui._static_SelectBg, "StaticText_SelectSkillIDesc_2"),
    [2] = UI.getChildControl(self._ui._static_SelectBg, "StaticText_SelectSkillIDesc_3")
  }
  self._mainPetSlotTable._grade = UI.getChildControl(self._mainPetSlotTable._bg, "Static_LeaderGradeLine")
  self._mainPetSlotTable._mark = UI.getChildControl(self._mainPetSlotTable._bg, "Static_PetMarkBg")
  self._mainPetSlotTable._icon = UI.getChildControl(self._mainPetSlotTable._bg, "Static_Leader_PetIcon")
  self._mainPetSlotTable._tier = UI.getChildControl(self._mainPetSlotTable._bg, "StaticText_Tier")
  self._mainPetSlotTable._level = UI.getChildControl(self._mainPetSlotTable._bg, "StaticText_Level")
  self._ui._static_CompleteEffectBg = UI.getChildControl(self._ui._static_completeBg, "Static_CompleteEffectBg")
  self._ui._static_CompleteEffectMessage = UI.getChildControl(self._ui._static_CompleteEffectBg, "StaticText_CompleteMessage")
  self._ui._static_slotTemplete._bg = UI.getChildControl(self._ui._static_fusionBg, "Static_PetIconBg_Template")
  self._ui._static_slotTemplete._grade = UI.getChildControl(self._ui._static_slotTemplete._bg, "Static_GradeLine_Template")
  self._ui._static_slotTemplete._icon = UI.getChildControl(self._ui._static_slotTemplete._bg, "Static_PetIcon")
  self._ui._static_slotTemplete._tier = UI.getChildControl(self._ui._static_slotTemplete._bg, "StaticText_Tier")
  for ii = 0, self._config._subPetMaxTableCount - 1 do
    local bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._static_fusionBg, "Static_PetIconBg_" .. ii)
    CopyBaseProperty(self._ui._static_slotTemplete._bg, bg)
    local grade = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, bg, "Static_GradeLine_" .. ii)
    CopyBaseProperty(self._ui._static_slotTemplete._grade, grade)
    local icon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, bg, "Static_PetIcon_" .. ii)
    CopyBaseProperty(self._ui._static_slotTemplete._icon, icon)
    local tier = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, bg, "StaticText_Tier_" .. ii)
    CopyBaseProperty(self._ui._static_slotTemplete._tier, tier)
    bg:SetPosX(bg:GetPosX() + (bg:GetSizeX() + 10) * ii)
    self._subPetSlotTableList[ii] = {}
    self._subPetSlotTableList[ii]._bg = bg
    self._subPetSlotTableList[ii]._grade = grade
    self._subPetSlotTableList[ii]._icon = icon
    self._subPetSlotTableList[ii]._tier = tier
    self._subPetSlotTableList[ii]._isSet = false
    self._subPetSlotTableList[ii]._petNo = -1
  end
  for _, control in pairs(self._ui._static_slotTemplete) do
    control:SetShow(false)
    UI.deleteControl(control)
  end
  self._ui._staticText_N1Title = UI.getChildControl(self._ui._static_SelectBg, "StaticText_N1Title")
  self._ui._staticText_N2Title = UI.getChildControl(self._ui._static_SelectBg, "StaticText_N2Title")
  self._ui._staticText_N1Value = UI.getChildControl(self._ui._static_SelectBg, "StaticText_N1Value")
  self._ui._staticText_N2Value = UI.getChildControl(self._ui._static_SelectBg, "StaticText_N2Value")
  self._ui._progress2_N1 = UI.getChildControl(self._ui._static_SelectBg, "Static_N1_Progress_Value")
  self._ui._progress2_N2 = UI.getChildControl(self._ui._static_SelectBg, "Static_N2_Progress_Value")
  self._ui._progress2_N2Bg = UI.getChildControl(self._ui._static_SelectBg, "Static_N2_Progress_Hungry_BG")
  self._ui._static_SelectIcon = UI.getChildControl(self._ui._static_SelectBg, "Static_SelectLookIcon")
  self._ui._static_SelectMark = UI.getChildControl(self._ui._static_SelectBg, "StaticText_QuestionMark")
  self._ui._staticText_SelectPetLevel = UI.getChildControl(self._ui._static_SelectBg, "StaticText_SelectPetLv")
  for index = 0, self._config._skillSlotMaxCount - 1 do
    self._ui._skillSlotList[index] = UI.getChildControl(self._ui._static_SelectBg, "Static_SkillPetSlot_" .. index + 1)
    self._ui._skillRandomSlotList[index] = UI.getChildControl(self._ui._static_SelectBg, "Static_SelectSkillRandomIcon_" .. index + 1)
  end
  self._ui._edit_Naming = UI.getChildControl(self._ui._static_fusionBg, "Edit_Naming")
  self._ui._edit_Naming:SetMaxInput(getGameServiceTypePetNameLength())
  self._ui._radioButton_SelectLook = UI.getChildControl(self._ui._static_SelectBg, "RadioButton_SelectLook")
  self._ui._radioButton_SelectSkill = UI.getChildControl(self._ui._static_SelectBg, "RadioButton_SelectSkill")
  self._ui._button_yes = UI.getChildControl(self._ui._static_fusionBg, "Button_Yes")
  self._ui._button_no = UI.getChildControl(self._ui._static_fusionBg, "Button_No")
  self._ui._button_Close = UI.getChildControl(Panel_Window_PetFusion, "Button_Close")
  self._ui._button_SkillClose = UI.getChildControl(self._ui._static_SelectSkillBg, "Button_PetSkillListClose")
  self._ui._button_LookClose = UI.getChildControl(self._ui._static_SelectLookBg, "Button_PetSkinListClose")
  self._ui._list2_Skill = UI.getChildControl(self._ui._static_SelectSkillBg, "List2_PetSkillList")
  self._ui._list2_Look = UI.getChildControl(self._ui._static_SelectLookBg, "List2_PetSkinList")
  self._ui._static_CompleteIcon = UI.getChildControl(self._ui._static_completeBg, "Static_ComposePetIcon")
  self._ui._staticText_CompleteTierChange = UI.getChildControl(self._ui._static_completeBg, "StaticText_CompleteTierChange")
  self._ui._static_Effect = UI.getChildControl(self._ui._static_completeBg, "Static_Effect")
  self._ui._static_Effect_Bottom = UI.getChildControl(self._ui._static_completeBg, "Static_Effect_Bottom")
  self._ui._staticText_CompleteTier = UI.getChildControl(self._ui._static_completeBg, "StaticText_Grade")
  self._ui._staticText_PetNameLevel = UI.getChildControl(self._ui._static_completeBg, "StaticText_PetNameLevel")
  self._ui._staticText_SpecialSkill = UI.getChildControl(self._ui._static_completeBg, "StaticText_SpecialSkill")
  self._ui._button_CompleteComfirm = UI.getChildControl(self._ui._static_completeBg, "Button_Confirm")
  self._ui._static_Grade = UI.getChildControl(self._ui._static_completeBg, "Static_GradeLine")
  self._ui._completeSkillTableList = {}
  for index = 0, self._config._skillSlotMaxCount - 1 do
    self._ui._completeSkillTableList[index] = {}
    self._ui._completeSkillTableList[index]._iconBg = UI.getChildControl(self._ui._static_completeBg, "Static_SkillBg_" .. index + 1)
    self._ui._completeSkillTableList[index]._icon = UI.getChildControl(self._ui._static_completeBg, "Static_SkillIcon_" .. index + 1)
    self._ui._completeSkillTableList[index]._desc = UI.getChildControl(self._ui._static_completeBg, "StaticText_SkillDesc_" .. index + 1)
  end
  self._ui._static_FusionDesc = UI.getChildControl(self._ui._static_fusionBg, "StaticText_Desc")
  self._ui._static_FusionDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._static_FusionDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_DESC"))
  self._config._infoTextsizeGap = self._ui._static_FusionDesc:GetTextSizeY() - self._ui._static_FusionDesc:GetSizeY()
  if 0 < self._config._infoTextsizeGap then
    Panel_Window_PetFusion:SetSize(Panel_Window_PetFusion:GetSizeX(), Panel_Window_PetFusion:GetSizeY() + self._config._infoTextsizeGap)
    self._ui._static_subBG:SetSize(self._ui._static_subBG:GetSizeX(), self._ui._static_subBG:GetSizeY() + self._config._infoTextsizeGap)
    self._ui._static_fusionBg:SetSize(self._ui._static_fusionBg:GetSizeX(), self._ui._static_fusionBg:GetSizeY() + self._config._infoTextsizeGap)
    self._ui._static_completeBg:SetSize(self._ui._static_completeBg:GetSizeX(), self._ui._static_completeBg:GetSizeY() + self._config._infoTextsizeGap)
    self._ui._static_CompleteEffectBg:SetSize(self._ui._static_CompleteEffectBg:GetSizeX(), self._ui._static_CompleteEffectBg:GetSizeY() + self._config._infoTextsizeGap)
    self._ui._static_subBG:ComputePos()
    self._ui._button_yes:ComputePos()
    self._ui._button_no:ComputePos()
    self._ui._button_CompleteComfirm:ComputePos()
  end
end
function PetFusion:initEvent()
  self._ui._button_yes:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_Fusion()")
  self._ui._button_no:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_Close()")
  self._ui._button_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_Close()")
  self._ui._button_CompleteComfirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_Close()")
  self._ui._edit_Naming:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_ClearEdit()")
  self._ui._radioButton_SelectLook:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_OpenLook()")
  self._ui._radioButton_SelectSkill:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_OpenSkill()")
  self._ui._button_LookClose:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_CloseLook()")
  self._ui._button_SkillClose:addInputEvent("Mouse_LUp", "PaGlobalFunc_PetFusion_CloseSkill()")
  self._ui._list2_Skill:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PetFusion_CreateSkillList")
  self._ui._list2_Skill:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2_Look:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PetFusion_CreateLookList")
  self._ui._list2_Look:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobalFunc_PetFusion_Fusion()
  local self = PetFusion
  ClearFocusEdit(self._ui._edit_Naming)
  PaGlobalFunc_PetFusion_CloseSkill()
  PaGlobalFunc_PetFusion_CloseLook()
  self._petName = self._ui._edit_Naming:GetEditText()
  if "" == self._petName or self._config._defaultName == self._petName then
    Proc_ShowMessage_Ack(self._config._defaultName)
    return
  end
  if true == self._isFusionAble then
    local function confirm_compose()
      local count = 0
      for index = 0, self._config._petMaxTableCount - 1 do
        if -1 ~= self._petNoList[index] then
          ToClient_pushFusionPetList(self._petNoList[index], count)
          count = count + 1
        end
        self._ui._button_Close:SetShow(false)
      end
      self:fusionStartEffect()
      self._isFusionStart = true
      Panel_Window_PetFusion:RegisterUpdateFunc("PaGlobal_FusionStartDelay_PerFrameUpdate")
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_MSGCONTENT")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "PANEL_SERVANTMIX_TITLE"),
      content = messageBoxMemo,
      functionYes = confirm_compose,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_PETLIST_PETCOMPOSE_REGIST"))
  end
end
function PaGlobal_FusionStartDelay_PerFrameUpdate(deltaTime)
  local self = PetFusion
  if false == self._isFusionStart then
    return
  end
  self._fusionStartDelayTime = self._fusionStartDelayTime + deltaTime
  if self._fusionStartDelayTime >= 2.5 then
    self._isFusionStart = false
    self._fusionStartDelayTime = 0
    ToClient_requestPetFusion(self._petName, self._currentSkillIndex - 1, self._currentLookIndex - 1)
    return
  end
end
function PaGlobalFunc_PetFusion_GetShow()
  local self = PetFusion
  return Panel_Window_PetFusion:GetShow() and true == self._ui._static_fusionBg:GetShow()
end
function PaGlobalFunc_PetFusion_GetPanelShow()
  local self = PetFusion
  return Panel_Window_PetFusion:GetShow()
end
function PaGlobalFunc_PetFusion_SetShow(isShow, isAni)
  Panel_Window_PetFusion:SetShow(isShow, isAni)
end
function PaGlobalFunc_PetFusion_Open()
  local self = PetFusion
  self:clear()
  PaGlobalFunc_PetFusion_SetPos()
  self:PetFusionInitControlSetting(true)
  PaGlobalFunc_PetFusion_SetShow(true, false)
end
function PetFusion:PetFusionInitControlSetting(isOn)
  self._ui._static_SelectDescBg:SetShow(isOn)
  self._ui._static_SelectBg:SetShow(not isOn)
  self._ui._edit_Naming:SetShow(not isOn)
  self._ui._button_yes:SetShow(not isOn)
  self._ui._button_no:SetShow(not isOn)
  self._ui._static_FusionDesc:SetShow(not isOn)
end
function PaGlobalFunc_PetFusion_Close()
  local self = PetFusion
  if self._isFusionStart then
  end
  self:clear()
  self._ui._button_Close:SetShow(true)
  self._ui._staticText_CompleteTier:SetShow(false)
  FGlobal_PetList_Set(false)
  PetList_HideSkillToolTip()
  self._ui._static_CompleteEffectBg:SetAlpha(1)
  self._ui._static_CompleteEffectMessage:SetAlpha(1)
  self._ui._static_CompleteEffectMessage:SetShow(true)
  self._ui._static_CompleteEffectBg:SetShow(true)
  PaGlobalFunc_PetFusion_CloseSkill()
  PaGlobalFunc_PetFusion_CloseLook()
  PetListNew_IgnoreAllSealButton(false)
  PaGlobalFunc_PetFusion_SetShow(false, false)
end
function FromClient_FusionComplete(petNo)
  local self = PetFusion
  self._ui._static_CompleteEffectBg:SetShow(false)
  self:loadCompleteData(petNo)
  self:setComplete()
  PaGlobalFunc_PetFusion_CompleteOpen()
end
function FromClient_PetFusionResult(rv)
  if 0 ~= rv then
    PaGlobalFunc_PetFusion_Close()
    local str = PAGetStringSymNo(rv)
    Proc_ShowMessage_Ack(str)
  end
end
function PaGlobal_SetCompleteDelay_PerFrameUpdate(deltaTime)
  local self = PetFusion
  if false == self._isFusion then
    return
  else
    self._completeDelayTime = self._completeDelayTime + deltaTime
  end
  if self._completeDelayTime >= 0.5 then
    self._completeDelayTime = 0
    self._isFusion = false
  end
end
function FromClient_luaLoadComplete_PetFusion()
  PetFusion:initialize()
end
registerEvent("FromClient_PetFusionResult", "FromClient_PetFusionResult")
registerEvent("FromClient_FusionComplete", "FromClient_FusionComplete")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PetFusion")
