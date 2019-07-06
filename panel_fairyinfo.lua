local FairyMessageType = {eTurnOnLantern = 0}
Panel_FairyInfo:SetShow(false)
local UI_classType = CppEnums.ClassType
local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local eFairyMaxEquipSkill = 30
local FairyInfo = {
  _skillKey = {},
  _fairyNo = nil,
  _isUnseal = nil,
  _learnPotionSkill = false,
  _iconPath = nil,
  _fairyName = nil,
  _skillTooltipDesc = {},
  _fairyLevel = 0,
  _isFairyMaxLevel = false,
  currentLevel = 0,
  _fairyTier = 0,
  _fairyTierMax = 3,
  _UI = {
    _fairyBigIcon = UI.getChildControl(Panel_FairyInfo, "Static_FairyBigIcon"),
    _levelPosition = UI.getChildControl(Panel_FairyInfo, "Static_LevelPosition"),
    _namePosition = UI.getChildControl(Panel_FairyInfo, "Static_NamePosition"),
    _question = UI.getChildControl(Panel_FairyInfo, "Button_Question"),
    _desc = UI.getChildControl(Panel_FairyInfo, "StaticText_Desc"),
    _potionPositionBG = UI.getChildControl(Panel_FairyInfo, "Static_PotionPositionBG"),
    _skillBG = UI.getChildControl(Panel_FairyInfo, "Static_SkillBG"),
    _buttonPosition = UI.getChildControl(Panel_FairyInfo, "Static_ButtonPosition"),
    _potionPositionLockBG = UI.getChildControl(Panel_FairyInfo, "Static_PotionPositionLockBG"),
    _button_Win_Close = UI.getChildControl(Panel_FairyInfo, "Button_Win_Close"),
    _button_setFree = UI.getChildControl(Panel_FairyInfo, "Button_FairyBTN"),
    _button_Lanter = UI.getChildControl(Panel_FairyInfo, "CheckButton_Lantern"),
    _fairyTierUpgradeButton = UI.getChildControl(Panel_FairyInfo, "Button_FairyUpgradeBTN")
  },
  _currentHpKey = nil,
  _currentMpKey = nil,
  _isAnimate = false,
  _const_Ani_Time = 8.5,
  _timeStamp = 0,
  _fromWhereType = 0,
  _fromSlotNo = 0,
  _currentExpRate = 0
}
function PaGloblFunc_FairyInfo_GetFairySkillCount()
  return eFairyMaxEquipSkill
end
function PaGlobal_FairyInfo_GetFairyNo()
  return FairyInfo._fairyNo
end
function PaGlobal_FairyInfo_GetFairyName()
  return FairyInfo._fairyName
end
function PaGlobal_FairyInfo_GetIconPath()
  return FairyInfo._iconPath
end
function PaGlobal_FairyInfo_GetLevel()
  return FairyInfo._fairyLevel
end
function PaGlobal_FairyInfo_isUnseal()
  return FairyInfo._isUnseal
end
function PaGlobal_FairyInfo_getUpgradeStack()
  return FairyInfo._fairyUpgradeStack
end
function PaGlobal_FairyInfo_isMaxTier()
  if FairyInfo._fairyTierMax <= FairyInfo._fairyTier then
    return true
  else
    return false
  end
end
function FairyInfo:Update()
  local isUnseal = false
  local pcFairyData
  local sealCount = ToClient_getFairySealedList()
  local unSealCount = ToClient_getFairyUnsealedList()
  local allCount = sealCount + unSealCount
  if allCount < 1 then
    return PaGlobal_FairyInfo_Close()
  end
  if unSealCount > 0 then
    isUnseal = true
  end
  if true == isUnseal then
    pcFairyData = ToClient_getFairyUnsealedDataByIndex(0)
  else
    pcFairyData = ToClient_getFairySealedDataByIndex(0)
  end
  self._isUnseal = isUnseal
  if nil == pcFairyData then
    return PaGlobal_FairyInfo_Close()
  end
  local fairyStaticStatus, iconPath, fairyNo_s64, fairyName, fairyLevel, fairyLovely, fairyhungry, fairyMaxLevel, fairyMaxHungry, fairyRace, fairyTier, fairyState, skillType, isPassive, tempIndex, fairyExp, MaxExp, fairyAttr
  if true == isUnseal then
    fairyStaticStatus = pcFairyData:getPetStaticStatus()
    self._iconPath = pcFairyData:getIconPath()
    fairyNo_s64 = pcFairyData:getPcPetNo()
    self._fairyNo = fairyNo_s64
    fairyName = pcFairyData:getName()
    self._fairyName = fairyName
    fairyTier = fairyStaticStatus:getPetTier()
    fairyLevel = pcFairyData:getLevel()
    fairyExp = Int64toInt32(pcFairyData:getExperience())
    MaxExp = Int64toInt32(fairyStaticStatus:getTotalExp(fairyLevel))
    fairyAttr = fairyStaticStatus:getPetKind()
  else
    fairyStaticStatus = pcFairyData:getPetStaticStatus()
    self._iconPath = pcFairyData:getIconPath()
    fairyNo_s64 = pcFairyData._petNo
    self._fairyNo = fairyNo_s64
    fairyName = pcFairyData:getName()
    self._fairyName = fairyName
    fairyTier = fairyStaticStatus:getPetTier()
    fairyLevel = pcFairyData._level
    fairyExp = Int64toInt32(pcFairyData:getExperience())
    MaxExp = Int64toInt32(fairyStaticStatus:getTotalExp(fairyLevel))
    fairyAttr = fairyStaticStatus:getPetKind()
  end
  self._fairyLevel = fairyLevel
  if fairyLevel >= (fairyTier + 1) * 10 then
    self._isFairyMaxLevel = true
  end
  self._fairyUpgradeStack = pcFairyData:getUpgradeStackCount()
  if self._isFairyMaxLevel then
    self._UI._button_Growth:SetEnable(false)
    self._UI._button_Growth:SetMonoTone(true)
  else
    self._UI._button_Growth:SetEnable(true)
    self._UI._button_Growth:SetMonoTone(false)
  end
  self._fairyTier = fairyTier
  if _ContentsGroup_FairyTierUpgradeAndRebirth then
    if 0 < self._fairyUpgradeStack and self._isFairyMaxLevel and not PaGlobal_FairyInfo_isMaxTier() then
      self._UI._fairyTierUpgradeButton:SetShow(true)
      if isUnseal then
        self._UI._fairyTierUpgradeButton:SetMonoTone(true)
      else
        self._UI._fairyTierUpgradeButton:SetMonoTone(false)
      end
    else
      self._UI._fairyTierUpgradeButton:SetShow(false)
    end
  else
    self._UI._fairyTierUpgradeButton:SetShow(false)
  end
  local remainTime = 0
  for ii = eFairyMaxEquipSkill - 2, 0, -1 do
    if true == pcFairyData:isFairyEquipSkillLearned(ii) then
      self._skillKey[ii] = true
    end
  end
  local uiRow = 0
  local skillSSW = ToClient_Fairy_EquipSkillWrraper(eFairyMaxEquipSkill - 1)
  if nil ~= skillSSW then
    local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
    if nil ~= skillTypeSSW then
      self._UI._skillIconBg[uiRow]:SetShow(true)
      self._UI._skillIcon[uiRow]:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
      self._UI._skillIcon[uiRow]:SetShow(true)
      self._UI._skillDesc[uiRow]:SetText(skillTypeSSW:getDescription())
      self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName())
      self._UI._skillName[uiRow]:SetShow(true)
      self._UI._skillName[uiRow]:SetMonoTone(false)
      self._skillTooltipDesc[uiRow] = skillTypeSSW:getDescription()
      self._UI._skillIcon[uiRow]:addInputEvent("Mouse_On", "FairyInfo_SkillTooltip( true, " .. tostring(uiRow) .. ")")
      self._UI._skillIcon[uiRow]:addInputEvent("Mouse_Out", "FairyInfo_SkillTooltip( false, " .. tostring(uiRow) .. ")")
    end
  end
  uiRow = 1
  if nil ~= self._skillKey then
    for key, value in pairs(self._skillKey) do
      local skillSSW = ToClient_Fairy_EquipSkillWrraper(key)
      if nil ~= skillSSW then
        local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
        if nil ~= skillTypeSSW then
          self._UI._skillIconBg[uiRow]:SetShow(true)
          self._UI._skillIcon[uiRow]:ChangeTextureInfoName("Icon/" .. skillTypeSSW:getIconPath())
          self._UI._skillIcon[uiRow]:SetShow(true)
          self._UI._skillDesc[uiRow]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
          self._UI._skillDesc[uiRow]:SetText(skillTypeSSW:getDescription())
          if key >= 10 and key <= 13 and true == isUnseal then
            local remainTime = ToClient_getFairyRemainTime()
            if remainTime > 0 then
              remainTime = tostring(convertSecondsToClockTime(remainTime))
              self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName() .. "  ( " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FAIRYINFO_RESPAWNTIME", "time", remainTime) .. " )")
              self._UI._skillIcon[uiRow]:SetMonoTone(true)
            else
              self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName())
            end
          elseif key >= 14 and key <= 18 and true == isUnseal then
            local remainTime = ToClient_getFairyDesertRemainTime()
            if remainTime > 0 then
              remainTime = tostring(convertSecondsToClockTime(remainTime))
              self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName() .. "  ( " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FAIRYINFO_RESPAWNTIME", "time", remainTime) .. " )")
              self._UI._skillIcon[uiRow]:SetMonoTone(true)
            else
              self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName())
            end
          else
            self._UI._skillName[uiRow]:SetText(skillTypeSSW:getName())
          end
          self._UI._skillName[uiRow]:SetShow(true)
          self._UI._skillName[uiRow]:SetMonoTone(false)
          self._skillTooltipDesc[uiRow] = skillTypeSSW:getDescription()
          self._UI._skillIcon[uiRow]:addInputEvent("Mouse_On", "FairyInfo_SkillTooltip( true, " .. tostring(uiRow) .. ")")
          self._UI._skillIcon[uiRow]:addInputEvent("Mouse_Out", "FairyInfo_SkillTooltip( false, " .. tostring(uiRow) .. ")")
          if key >= 20 then
            self._learnPotionSkill = true
          end
          if true == isUnseal and 19 == key then
            self._UI._button_Lanter:SetShow(true)
            self._UI._button_Lanter:SetCheck(ToClient_isFairyLanternOnOff())
            self._UI._button_Lanter:SetPosY(340 + uiRow * 50)
            self._UI._button_Lanter:SetPosX(self._UI._skillName[uiRow]:GetSizeX() + self._UI._skillName[uiRow]:GetTextSizeX() + 40)
          end
          uiRow = uiRow + 1
        end
      end
    end
  end
  if uiRow < 5 then
    if true == self._isFairyMaxLevel then
      self._UI._skillIconBg[uiRow]:SetShow(false)
      self._UI._skillName[uiRow]:SetShow(false)
      self._UI._skillIcon[uiRow]:SetShow(false)
    else
    end
    for index = uiRow + 1, 4 do
      self._UI._skillIconBg[index]:SetShow(false)
      self._UI._skillName[index]:SetShow(false)
      self._UI._skillIcon[index]:SetShow(false)
    end
  end
  local SettingData = ToClient_getFairySettingData(fairyNo_s64)
  if nil ~= SettingData and true == self._learnPotionSkill then
    local ItemSSW = getItemEnchantStaticStatus(SettingData._hpItemKey)
    self._currentHpKey = SettingData._hpItemKey
    if nil ~= ItemSSW then
      self._UI._hpIcon:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
      self._UI._hpIcon:SetShow(true)
      if 100 == SettingData._hpMinRate then
        self._UI._hpSetText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ALWAYS_HPUSE"))
      elseif 0 < SettingData._hpMinRate then
        self._UI._hpSetText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FAIRYINFO_HPPERCENT", "percent", SettingData._hpMinRate))
      end
    else
      self._UI._hpIcon:SetShow(false)
    end
    ItemSSW = getItemEnchantStaticStatus(SettingData._mpItemKey)
    self._currentMpKey = SettingData._mpItemKey
    if nil ~= ItemSSW then
      self._UI._mpIcon:ChangeTextureInfoName("Icon/" .. ItemSSW:getIconPath())
      self._UI._mpIcon:SetShow(true)
      if 100 == SettingData._mpMinRate then
        self._UI._mpSetText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ALWAYS_MPUSE"))
      elseif 0 < SettingData._mpMinRate then
        self._UI._mpSetText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FAIRYINFO_MPPERCENT", "percent", SettingData._mpMinRate))
      end
    else
      self._UI._mpIcon:SetShow(false)
    end
  else
    self._UI._mpIcon:SetShow(false)
    self._UI._hpIcon:SetShow(false)
  end
  if true == self._learnPotionSkill then
    self._UI._potionPositionLockBG:SetShow(false)
    self._UI._lockedIcon:SetShow(false)
    self._UI._potionPositionBG:SetShow(true)
  else
    self._UI._potionPositionLockBG:SetShow(true)
    self._UI._lockedIcon:SetShow(true)
    self._UI._potionPositionBG:SetShow(false)
  end
  self._UI._button_PotionSet:addInputEvent("Mouse_LUp", "")
  self._UI._button_PotionSet:addInputEvent("Mouse_LUp", "PaGlobal_FairySetting_Open(" .. "\"" .. tostring(fairyNo_s64) .. "\"" .. ")")
  self._UI._button_PotionSet:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 1)")
  self._UI._button_PotionSet:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._fairyTier:SetText(self._GenerationStr[fairyTier])
  self._UI._fairyAttr:SetText(self._fairyAttrStr[fairyAttr])
  self._UI._fairyName:SetText(fairyName)
  self._UI._fairyName:SetPosX(self._UI._fairyAttr:GetTextSizeX() + 10)
  self._UI._level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(fairyLevel))
  self._currentExpRate = fairyExp / MaxExp * 100
  self._UI._levelExp:SetText(string.format("%.2f", self._currentExpRate) .. "%")
  self._UI._levelGauge:SetProgressRate(self._currentExpRate)
  self._UI._levelGauge:SetCurrentProgressRate(self._currentExpRate)
  self._UI._desc:SetText(self._InfoDescStr[fairyTier])
  self._UI._button_UnSummon:SetShow(false)
  self._UI._button_Summon:SetShow(false)
  if true == isUnseal then
    self._UI._button_UnSummon:SetShow(true)
    self._UI._button_Summon:SetShow(false)
    self._UI._button_Summon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_UNSUMMON"))
  else
    self._UI._button_UnSummon:SetShow(false)
    self._UI._button_Summon:SetShow(true)
    self._UI._button_Summon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_SUMMON"))
  end
end
function PaGlobal_FairyInfo_FairyTier()
  return FairyInfo._fairyTier
end
function PaGlobal_FairyInfo_CurrentExpRate()
  return FairyInfo._currentExpRate
end
function PaGlobal_FairyInfo_isMaxLevel()
  return FairyInfo._isFairyMaxLevel
end
function PaGlobal_FairyInfo_Update()
  local self = FairyInfo
  self:Update()
end
function PaGlobal_ClickSummonButton()
  local self = FairyInfo
  audioPostEvent_SystemUi(1, 40)
  _AudioPostEvent_SystemUiForXBOX(1, 40)
  if nil == self._fairyNo then
    return
  end
  PaGlobalFunc_fairySkill_Close()
  if true == self._isUnseal then
    ToClient_requestPetSeal(self._fairyNo)
    if Panel_Window_FairyUpgrade:GetShow() then
      PaGlobal_FairyUpgrade_Close()
    end
  else
    ToClient_requestPetUnseal(self._fairyNo)
    if true == _ContentsGroup_FairyTierUpgradeAndRebirth and Panel_Window_FairyTierUpgrade:GetShow() then
      PaGlobal_FairyTierUpgrade_Close()
    end
  end
end
function PaGlobal_FairyInfo_Open(noSetPos)
  local self = FairyInfo
  if Panel_FairyInfo:GetShow() and false == noSetPos then
    PaGlobal_FairyInfo_Close()
    return
  end
  self:Clear()
  Panel_FairyInfo:SetShow(true)
  self:Update()
  if false == noSetPos then
    self:SetPos()
  end
end
function PaGlobal_FairyInfo_Close()
  Panel_FairyInfo:SetShow(false)
  if true == Panel_Window_FairySetting:GetShow() then
    PaGlobal_FairySetting_Close()
  end
  if true == Panel_Window_FairyUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_Close()
  end
  if _ContentsGroup_FairyTierUpgradeAndRebirth and true == Panel_Window_FairyTierUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_Close()
  end
  if true == Panel_Window_FairyChoiseTheReset:GetShow() then
    PaGlobal_FairyChoice:Close()
  end
  if true == PaGlobalFunc_fairySkill_GetShow() then
    PaGlobalFunc_fairySkill_Close()
  end
end
function FairyInfo:Clear()
  for _, value in pairs(self._UI._skillIconBg) do
    value:SetShow(true)
  end
  for _, value in pairs(self._UI._skillIcon) do
    value:SetShow(false)
    value:SetMonoTone(false)
  end
  for _, value in pairs(self._UI._skillName) do
    value:SetShow(true)
    value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_NOSKILL"))
    value:SetMonoTone(true)
  end
  for _, value in pairs(self._UI._skillDesc) do
    value:SetShow(true)
    value:SetText(" ")
    value:SetMonoTone(true)
  end
  self._UI._potionPositionLockBG:SetShow(true)
  self._fairyNo = nil
  self._fairyName = nil
  self._iconPath = nil
  self._skillKey = {}
  self._learnPotionSkill = false
  self._skillTooltipDesc = {}
  self._currentHpKey = nil
  self._currentMpKey = nil
  self._UI._hpSetText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_HPNONE"))
  self._UI._mpSetText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_MPNONE"))
  self._UI._button_Lanter:SetShow(false)
  self._UI._button_Rebirth:SetIgnore(false)
  self._UI._button_Rebirth:SetMonoTone(false)
  self._fairyLevel = 0
  self._isFairyMaxLevel = false
  self._currentExpRate = 0
end
function FairyInfo:SetPos()
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_FairyInfo:GetSizeX()
  Panel_FairyInfo:SetPosX(screenX / 2 - Panel_FairyInfo:GetSizeX() / 2)
  Panel_FairyInfo:SetPosY(screenY / 2 - Panel_FairyInfo:GetSizeY() / 2)
  Panel_FairyInfo:ComputePos()
end
function PaGlobal_FairyInfo_RequestRebirth()
  PaGlobalFunc_fairySkill_Close()
  local function FunctionYes()
    local self = FairyInfo
    if nil == self._fairyNo then
      return
    end
    if self._fairyLevel < 10 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrCantRebirthLessLevel"))
      return
    end
    ToClient_FairyRebirth(self._fairyNo, true, false)
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
  local _contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_REBIRTH_ALERT")
  local messageBoxData = {
    title = _title,
    content = _contenet,
    functionYes = FunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_FairyInfo_RequestFreedom()
  local function FunctionYes()
    local self = FairyInfo
    if nil == self._fairyNo then
      return
    end
    ToClient_FairyFreedom(self._fairyNo)
  end
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
  local _contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_FREEDOM_ALERT")
  local messageBoxData = {
    title = _title,
    content = _contenet,
    functionYes = FunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FairyInfo_SkillTooltip(isShow, index)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = FairyInfo
  local uiControl, name, desc
  uiControl = self._UI._skillIcon[index]
  name = self._UI._skillName[index]:GetText()
  desc = self._skillTooltipDesc[index]
  TooltipSimple_Show(uiControl, name, desc)
end
function FairyInfo:Initialize()
  self._UI._fairyTier = UI.getChildControl(self._UI._namePosition, "StaticText_FairyTier")
  self._UI._fairyName = UI.getChildControl(self._UI._namePosition, "StaticText_FairyName")
  self._UI._fairyAttr = UI.getChildControl(self._UI._namePosition, "StaticText_FairyAttr")
  self._UI._fairyHelp = UI.getChildControl(self._UI._fairyBigIcon, "Static_Help")
  self._UI._fairyHelp:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 6)")
  self._UI._fairyHelp:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._level = UI.getChildControl(self._UI._levelPosition, "StaticText_Level")
  self._UI._levelExp = UI.getChildControl(self._UI._levelPosition, "StaticText_LevelExp")
  self._UI._levelGaugeBG = UI.getChildControl(self._UI._levelPosition, "Static_LevelGaugeBG")
  self._UI._levelGauge = UI.getChildControl(self._UI._levelPosition, "Progress2_LevelGauge")
  self._UI._button_Rebirth = UI.getChildControl(self._UI._buttonPosition, "Button_Rebirth")
  if true == _ContentsGroup_FairyTierUpgradeAndRebirth then
    self._UI._button_Rebirth:addInputEvent("Mouse_LUp", "PaGlobal_FairyChoice:Open()")
  else
    self._UI._button_Rebirth:addInputEvent("Mouse_LUp", "PaGlobal_FairyInfo_RequestRebirth()")
  end
  self._UI._button_Rebirth:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 2)")
  self._UI._button_Rebirth:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._button_Growth = UI.getChildControl(self._UI._buttonPosition, "Button_Growth")
  self._UI._button_Growth:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_Open(true)")
  self._UI._button_Growth:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 3)")
  self._UI._button_Growth:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._button_Summon = UI.getChildControl(self._UI._buttonPosition, "Button_Summon")
  self._UI._button_UnSummon = UI.getChildControl(self._UI._buttonPosition, "Button_UnSummon")
  self._UI._button_Summon:addInputEvent("Mouse_LUp", "PaGlobal_ClickSummonButton()")
  self._UI._button_UnSummon:addInputEvent("Mouse_LUp", "PaGlobal_ClickSummonButton()")
  self._UI._button_Summon:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 4)")
  self._UI._button_Summon:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._button_UnSummon:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 5)")
  self._UI._button_UnSummon:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._lockedIcon = UI.getChildControl(self._UI._potionPositionLockBG, "StaticText_LockIcon")
  self._UI._skillIconBg = {
    [0] = UI.getChildControl(self._UI._skillBG, "Static_SkillIconBG1"),
    [1] = UI.getChildControl(self._UI._skillBG, "Static_SkillIconBG2"),
    [2] = UI.getChildControl(self._UI._skillBG, "Static_SkillIconBG3"),
    [3] = UI.getChildControl(self._UI._skillBG, "Static_SkillIconBG4"),
    [4] = UI.getChildControl(self._UI._skillBG, "Static_SkillIconBG5")
  }
  self._UI._skillIcon = {
    [0] = UI.getChildControl(self._UI._skillBG, "Static_SkillIcon1"),
    [1] = UI.getChildControl(self._UI._skillBG, "Static_SkillIcon2"),
    [2] = UI.getChildControl(self._UI._skillBG, "Static_SkillIcon3"),
    [3] = UI.getChildControl(self._UI._skillBG, "Static_SkillIcon4"),
    [4] = UI.getChildControl(self._UI._skillBG, "Static_SkillIcon5")
  }
  self._UI._skillName = {
    [0] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillName1"),
    [1] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillName2"),
    [2] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillName3"),
    [3] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillName4"),
    [4] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillName5")
  }
  self._UI._skillDesc = {
    [0] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillDesc1"),
    [1] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillDesc2"),
    [2] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillDesc3"),
    [3] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillDesc4"),
    [4] = UI.getChildControl(self._UI._skillBG, "StaticText_SkillDesc5")
  }
  self._UI._button_LearnableSkill = UI.getChildControl(self._UI._skillBG, "Button_LearnableSkill")
  self._UI._button_LearnableSkill:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._UI._button_LearnableSkill:SetText(self._UI._button_LearnableSkill:GetText())
  self._fairyAttrStr = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ATTR_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ATTR_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ATTR_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ATTR_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_ATTR_5")
  }
  self._UI._hpIconBG = UI.getChildControl(self._UI._potionPositionBG, "Static_HpBG")
  self._UI._mpIconBG = UI.getChildControl(self._UI._potionPositionBG, "Static_MpBG")
  self._UI._hpIcon = UI.getChildControl(self._UI._hpIconBG, "Static_HpIcon")
  self._UI._mpIcon = UI.getChildControl(self._UI._mpIconBG, "Static_MpIcon")
  self._UI._hpIcon:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_ShowToolTip(true, true)")
  self._UI._mpIcon:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_ShowToolTip(false, true)")
  self._UI._hpIcon:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_ShowToolTip(true, false)")
  self._UI._mpIcon:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_ShowToolTip(false, false)")
  self._UI._button_PotionSet = UI.getChildControl(self._UI._potionPositionBG, "Button_PotionSet")
  self._UI._button_Win_Close:addInputEvent("Mouse_LUp", "PaGlobal_FairyInfo_Close()")
  registerEvent("FromClient_PetAddSealedList", "FromClient_addSealedList_FiaryInfoOpen")
  registerEvent("FromClient_PetDelSealedList", "FromClient_delSealedList_FiaryInfoOpen")
  registerEvent("FromClient_PetDelList", "FromClient_delList_FiaryInfoOpen")
  registerEvent("FromClient_InputFairyName", "FromClient_InputFairyNameStart")
  registerEvent("FromClient_Fairy_Update", "FromClient_Fairy_Update")
  self._GenerationStr = {
    [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_GENERATION_1"),
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_GENERATION_2"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_GENERATION_3"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_GENERATION_4")
  }
  self._InfoDescStr = {
    [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_DESC"),
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_DESC_2"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_DESC_3"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_INFO_DESC_4")
  }
  self._buttonName = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_FREEDOM_NAME"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_TIERUPGRADE_NAME")
  }
  self._UI._button_setFree:SetText(self._buttonName[0])
  self._UI._button_setFree:addInputEvent("Mouse_LUp", "PaGlobal_FairyInfo_RequestFreedom()")
  self._UI._button_setFree:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 0)")
  self._UI._button_setFree:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._button_LearnableSkill:addInputEvent("Mouse_LUp", "PaGlobalFunc_fairySkill_Open()")
  self._UI._button_LearnableSkill:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 9)")
  self._UI._button_LearnableSkill:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._hpSetText = UI.getChildControl(self._UI._potionPositionBG, "StaticText_HpSet")
  self._UI._mpSetText = UI.getChildControl(self._UI._potionPositionBG, "StaticText_MpSet")
  self._UI._button_Lanter:addInputEvent("Mouse_LUp", "PaGlobal_FairyInfo_LanterOnOff()")
  self._UI._button_Lanter:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 7)")
  self._UI._button_Lanter:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
  self._UI._question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle(\"Fairy\")")
  self._UI._question:SetShow(false)
  self._UI._fairyTierUpgradeButton:SetText(self._buttonName[1])
  self._UI._fairyTierUpgradeButton:addInputEvent("Mouse_LUp", "PaGlobal_FairyTierUpgrade_Open(true)")
  self._UI._fairyTierUpgradeButton:addInputEvent("Mouse_On", "PaGlobal_FairyInfo_SimpleTooltip(true, 8)")
  self._UI._fairyTierUpgradeButton:addInputEvent("Mouse_Out", "PaGlobal_FairyInfo_SimpleTooltip(false)")
end
local isFairyByPetNo = function(petNo)
  local countUnsealed = ToClient_getFairyUnsealedList()
  local countSealed = ToClient_getFairySealedList()
  local fairyData
  if countUnsealed < countSealed then
    fairyData = ToClient_getFairySealedDataByIndex(0)
    if nil == fairyData then
      return false
    end
    if petNo == fairyData._petNo then
      return true
    end
  else
    fairyData = ToClient_getFairyUnsealedDataByIndex(0)
    if nil == fairyData then
      return false
    end
    if petNo == fairyData:getPcPetNo() then
      return true
    end
  end
  return false
end
function FromClient_addSealedList_FiaryInfoOpen(petNo, reason, petType)
  local self = FairyInfo
  if false == isFairyByPetNo(petNo) then
    return
  end
  if nil == reason then
    return
  end
  if __ePetType_Fairy == petType then
    if false == Panel_FairyInfo:GetShow() then
      self:Clear()
      self:Update()
    else
      self:Clear()
      self:Update()
    end
  end
end
function FromClient_Fairy_Update()
  local self = FairyInfo
  self:Clear()
  self:Update()
end
function FromClient_delSealedList_FiaryInfoOpen(petNo)
  local self = FairyInfo
  if false == isFairyByPetNo(petNo) and self._fairyNo ~= petNo then
    return
  end
  self:Clear()
  self:Update()
  PaGlobal_Fairy_SetPosIcon()
  if true == Panel_Window_FairyUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_OnlyUpdate()
  end
end
function FromClient_delList_FiaryInfoOpen(petNo)
  if false == isFairyByPetNo(petNo) then
    return
  end
  PaGlobal_FairyInfo_Open(true)
end
function PaGlobal_FairyInfo_ShowToolTip(isHp, isShow)
  local self = FairyInfo
  local itemSSW
  local index = 0
  local control
  if true == isHp then
    itemSSW = getItemEnchantStaticStatus(self._currentHpKey)
    index = 0
    control = self._UI._hpIcon
  else
    itemSSW = getItemEnchantStaticStatus(self._currentMpKey)
    index = 1
    control = self._UI._mpIcon
  end
  if nil == itemSSW then
    return
  end
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(index, control, "fairyList")
    Panel_Tooltip_Item_Show(itemSSW, Panel_FairyInfo, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FromClient_InputFairyNameStart(fromWhereType, fromSlotNo)
  local self = FairyInfo
  local selfPlayer = getSelfPlayer()
  local rotation = selfPlayer:get():getRotation()
  self._isAnimate = true
  self._fromWhereType = fromWhereType
  self._fromSlotNo = fromSlotNo
  self._timeStamp = 0
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrAppearFairy"))
  HandleClicked_InventoryWindow_Close()
end
function UpdateFunc_FairyRegisterAni(deltaTime)
  local self = FairyInfo
  if false == self._isAnimate then
    return
  end
  self._timeStamp = self._timeStamp + deltaTime
  if self._const_Ani_Time <= self._timeStamp then
    self._isAnimate = false
    self._timeStamp = 0
    FromClient_InputFairyName(self._fromWhereType, self._fromSlotNo)
    self._fromWhereType = 0
    self._fromSlotNo = 0
  end
end
function PaGlobal_FairyInfo_SimpleTooltip(isShow, tipType)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = FairyInfo
  local control, name, desc
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_FREEDOM_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_FREEDOM_DESC")
    control = self._UI._button_setFree
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_POTIONSETTING_TOOLTIP_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_POTIONSETTING_TOOLTIP_DESC")
    control = self._UI._button_PotionSet
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_REBIRTH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_REBIRTH_DESC")
    control = self._UI._button_Rebirth
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_GROWTH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_GROWTH_DESC")
    control = self._UI._button_Growth
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_SUMMON_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_SUMMON_DESC")
    control = self._UI._button_Summon
  elseif 5 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_UNSUMMON_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_UNSUMMON_DESC")
    control = self._UI._button_UnSummon
  elseif 6 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_INFO_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_INFO_DESC")
    control = self._UI._fairyHelp
  elseif 7 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_LANTERN_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYINFO_TOOLTIP_LANTERN_DESC")
    control = self._UI._button_Lanter
  elseif 8 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_TIERUPGRADE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_TIERUPGRADE_DESC")
    control = self._UI._fairyTierUpgradeButton
  elseif 9 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_SHOW_SKILL_LIST")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_SHOW_SKILL_LIST_DESC")
    control = self._UI._button_LearnableSkill
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_FairyInfo_LanterOnOff()
  ToClient_RequestFairyLanterOnOff()
  PaGlobal_FairyInfo_Open(true)
end
registerEvent("FromClient_luaLoadComplete", "LuaLoadComplete")
function LuaLoadComplete()
  FairyInfo:Initialize()
  Panel_FairyInfo:SetShow(false)
end
