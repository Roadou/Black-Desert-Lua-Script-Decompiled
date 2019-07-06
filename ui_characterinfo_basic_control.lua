local UI_Class = CppEnums.ClassType
local CombatType = CppEnums.CombatResourceType
local BattleSpeed = CppEnums.BattleSpeedType
local Class_BattleSpeed = CppEnums.ClassType_BattleSpeed
local UI_DefaultFaceTexture = CppEnums.ClassType_DefaultFaceTexture
local IM = CppEnums.EProcessorInputMode
local UI_LifeType = CppEnums.LifeExperienceType
local UI_LifeToolTip = CppEnums.LifeExperienceTooltip
local UI_LifeString = CppEnums.LifeExperienceString
function FromClient_UI_CharacterInfo_Basic_TendencyChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local tendency = self._playerGet:getTendency()
  self._ui._staticTextTendency_Value:SetText(tostring(tendency))
end
function FromClient_UI_CharacterInfo_Basic_MentalChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local mental = self._player:getWp()
  local maxMental = self._player:getMaxWp()
  self._ui._staticTextMental_Value:SetText(tostring(mental) .. " / " .. tostring(maxMental))
end
function FromClient_UI_CharacterInfo_Basic_ContributionChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local contribution = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  local remainContribution = contribution:getRemainedPoint()
  local aquiredContribution = contribution:getAquiredPoint()
  self._ui._staticTextContribution_Value:SetText(tostring(remainContribution) .. " / " .. tostring(aquiredContribution))
end
function FromClient_UI_CharacterInfo_Basic_LevelChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local ChaLevel = self._playerGet:getLevel()
  self._ui._staticClassSymbol:SetText("Lv " .. tostring(ChaLevel))
end
function FromClient_UI_CharacterInfo_Basic_HpChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local hp = self._playerGet:getHp()
  local maxHp = self._playerGet:getMaxHp()
  local hpRate = hp / maxHp * 100
  self._ui._staticStatus_Value[self._status._health]:SetText(tostring(hp) .. " / " .. tostring(maxHp))
  self._ui._progress2Status[self._status._health]:SetProgressRate(hpRate)
end
function FromClient_UI_CharacterInfo_Basic_MpChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local mp = self._playerGet:getMp()
  local maxMp = self._playerGet:getMaxMp()
  local MpRate = mp / maxMp * 100
  self._ui._staticStatus_Value[self._status._mental]:SetText(tostring(mp) .. " / " .. tostring(maxMp))
  self._ui._progress2Status[self._status._mental]:SetProgressRate(MpRate)
end
function FromClient_UI_CharacterInfo_Basic_WeightChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local _const = Defines.s64_const
  local self = PaGlobal_CharacterInfoBasic
  local s64_moneyWeight = self._playerGet:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = self._playerGet:getEquipment():getWeight_s64()
  local s64_allWeight = self._playerGet:getCurrentWeight_s64()
  local s64_maxWeight = self._playerGet:getPossessableWeight_s64()
  local s64_allWeight_div = s64_allWeight / _const.s64_100
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100)
  if s64_allWeight_div <= s64_maxWeight_div then
    self._ui._progress2WeightMoney:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_maxWeight_div))
    self._ui._progress2WeightEquip:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div))
    self._ui._progress2Status[self._status._weight]:SetProgressRate(Int64toInt32(s64_allWeight / s64_maxWeight_div))
  else
    self._ui._progress2WeightMoney:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_allWeight_div))
    self._ui._progress2WeightEquip:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div))
    self._ui._progress2Status[self._status._weight]:SetProgressRate(Int64toInt32(s64_allWeight / s64_allWeight_div))
  end
  self._ui._staticStatus_Value[self._status._weight]:SetText(tostring(str_AllWeight) .. " / " .. tostring(str_MaxWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function FromClient_UI_CharacterInfo_Basic_AttackChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  ToClient_updateAttackStat()
  local self = PaGlobal_CharacterInfoBasic
  local chaAttack = ToClient_getOffence()
  self._ui._staticTextAttack_Value:SetText(tostring(chaAttack))
  local isShow = 0 == ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eCharacterInfo)
  local isSetAwakenWeapon = ToClient_getEquipmentItem(CppEnums.EquipSlotNo.awakenWeapon)
  self._ui._staticTextDefence_Title:SetVerticalTop()
  self._ui._staticTextStamina_Title:SetVerticalTop()
  if nil ~= isSetAwakenWeapon then
    local chaAwakenAttack = ToClient_getAwakenOffence()
    self._ui._staticTextAwakenAttack_Title:SetShow(isShow)
    self._ui._staticTextAwakenAttack_Value:SetText(tostring(chaAwakenAttack))
    self._ui._staticTextDefence_Title:SetSpanSize(207, 169)
    self._ui._staticTextStamina_Title:SetSpanSize(207, 195)
  else
    self._ui._staticTextAwakenAttack_Title:SetShow(false)
    self._ui._staticTextDefence_Title:SetSpanSize(207, 143)
    self._ui._staticTextStamina_Title:SetSpanSize(207, 169)
  end
  local chaDefence = ToClient_getDefence()
  self._ui._staticTextDefence_Value:SetText(tostring(chaDefence))
end
function FromClient_UI_CharacterInfo_Basic_StaminaChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local maxStamina = self._playerGet:getStamina():getMaxSp()
  self._ui._staticTextStamina_Value:SetText(tostring(maxStamina))
end
function FromClient_UI_CharacterInfo_Basic_SkillPointChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local skillPointInfo = ToClient_getSkillPointInfo(0)
  if nil ~= skillPointInfo then
    self._ui._staticTextSkillPoint_Value:SetText(tostring(skillPointInfo._remainPoint .. " / " .. skillPointInfo._acquirePoint))
  end
end
function FromClient_UI_CharacterInfo_Basic_FamilyPointsChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local battleFP = self._playerGet:getBattleFamilyPoint()
  local lifeFP = self._playerGet:getLifeFamilyPoint()
  local etcFP = self._playerGet:getEtcFamilyPoint()
  local sumFP = battleFP + lifeFP + etcFP
  local controls = self._ui._staticTextFamilyPoints
  local iconControls = self._ui._staticTextFamilyPointsWithIcon
  controls[self._familyPoint._family]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FAMILYPOINT_TITLE", "familyPoint", tostring(sumFP)))
  controls[self._familyPoint._combat]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARINFO_BATTLEPOINT", "value", tostring(battleFP)))
  controls[self._familyPoint._life]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARINFO_LIFEPOINT", "value", tostring(lifeFP)))
  controls[self._familyPoint._etc]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARINFO_ETCPOINT", "value", tostring(etcFP)))
  iconControls[self._familyPoint._combat]:SetText(tostring(battleFP))
  iconControls[self._familyPoint._life]:SetText(tostring(lifeFP))
  iconControls[self._familyPoint._etc]:SetText(tostring(etcFP))
  local useIcon = not isGameTypeKorea() and not isGameTypeTaiwan() and not isGameTypeJapan()
  for ii = 1, 3 do
    if useIcon then
      controls[ii]:SetShow(false)
      iconControls[ii]:SetShow(true)
    else
      iconControls[ii]:SetShow(false)
      controls[ii]:SetShow(true)
      controls[ii]:SetSize(controls[ii]:GetTextSizeX(), controls[ii]:GetSizeY())
    end
  end
  local gap = 40
  local parent = controls[self._familyPoint._etc]:getParent()
  if useIcon then
    iconControls[self._familyPoint._etc]:SetSpanSize(parent:GetSizeX() - iconControls[self._familyPoint._etc]:GetTextSizeX() - 15 - 30)
    iconControls[self._familyPoint._life]:SetSpanSize(iconControls[self._familyPoint._etc]:GetPosX() - iconControls[self._familyPoint._life]:GetTextSizeX() - gap - 30)
    iconControls[self._familyPoint._combat]:SetSpanSize(iconControls[self._familyPoint._life]:GetPosX() - iconControls[self._familyPoint._combat]:GetTextSizeX() - gap - 30)
  else
    controls[self._familyPoint._etc]:SetSpanSize(parent:GetSizeX() - controls[self._familyPoint._etc]:GetSizeX() - 15)
    controls[self._familyPoint._life]:SetSpanSize(controls[self._familyPoint._etc]:GetPosX() - controls[self._familyPoint._life]:GetSizeX() - gap)
    controls[self._familyPoint._combat]:SetSpanSize(controls[self._familyPoint._life]:GetPosX() - controls[self._familyPoint._combat]:GetSizeX() - gap)
  end
end
function FromClient_UI_CharacterInfo_Basic_ResistChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local data = {
    [self._regist._sturn] = self._player:getStunResistance(),
    [self._regist._down] = self._player:getKnockdownResistance(),
    [self._regist._capture] = self._player:getCatchResistance(),
    [self._regist._knockBack] = self._player:getKnockbackResistance()
  }
  for key, index in pairs(self._regist) do
    self._ui._progress2Resist[index]:SetProgressRate(math.floor(data[index] / 10000))
    self._ui._staticTextResist_Percent[index]:SetText(math.floor(data[index] / 10000) .. "%")
  end
end
function FromClient_UI_CharacterInfo_Basic_CraftLevelChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  for index = 1, 10 do
    local craftType = index - 1
    if nil ~= self._ui._lifeInfo[index]._level then
      self._ui._lifeInfo[index]._level:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(self._playerGet:getLifeExperienceLevel(craftType)))
      self._ui._lifeInfo[index]._level:SetFontColor(FGlobal_UI_CharacterInfo_Basic_Global_CraftColorReplace(self._playerGet:getLifeExperienceLevel(craftType)))
      self._ui._lifeInfo[index]._title:SetText(UI_LifeString[craftType])
      local currentExp64 = self._playerGet:getCurrLifeExperiencePoint(craftType)
      local needExp64 = self._playerGet:getDemandLifeExperiencePoint(craftType)
      local currentExpRate64 = currentExp64 * toInt64(0, 10000) / needExp64
      local currentExpRate = Int64toInt32(currentExpRate64)
      currentExpRate = currentExpRate / 100
      local currentExpRateString = string.format("%.2f", currentExpRate)
      self._ui._lifeInfo[index]._progress:SetProgressRate(currentExpRate)
      self._ui._lifeInfo[index]._percent:SetText(currentExpRateString .. "%")
    end
  end
end
function FromClient_UI_CharacterInfo_Basic_RankChanged()
  local self = PaGlobal_CharacterInfoBasic
  if self._requestRank == false then
    return
  end
  self._requestRank = false
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local bestRank = ToClient_GetLifeMyRank()
  if bestRank > 0 and bestRank < 31 then
    local bestTitle = UI_LifeString[self._sortCraftTable[1]._type] .. "( " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LIFERANKING_RANK", "listIdx", bestRank) .. " )"
    self._ui._staticTextCraft_Title[0]:SetText(bestTitle)
  end
end
function FromClient_UI_CharacterInfo_Basic_PotentialChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
  local classType = self._player:getClassType()
  local currentData = {
    [self._potential._moveSpeed] = self._player:characterStatPointSpeed(self._potential._moveSpeed),
    [self._potential._attackSpeed] = self._player:characterStatPointSpeed(self._potential._attackSpeed + Class_BattleSpeed[classType]),
    [self._potential._critical] = self._player:characterStatPointCritical(),
    [self._potential._fishTime] = self._player:getCharacterStatPointFishing(),
    [self._potential._product] = self._player:getCharacterStatPointCollection(),
    [self._potential._dropChance] = self._player:getCharacterStatPointDropItem()
  }
  local limitData = {
    [self._potential._moveSpeed] = self._player:characterStatPointLimitedSpeed(self._potential._moveSpeed),
    [self._potential._attackSpeed] = self._player:characterStatPointLimitedSpeed(self._potential._attackSpeed + Class_BattleSpeed[classType]),
    [self._potential._critical] = self._player:characterStatPointLimitedCritical(),
    [self._potential._fishTime] = self._player:getCharacterStatPointLimitedFishing(),
    [self._potential._product] = self._player:getCharacterStatPointLimitedCollection(),
    [self._potential._dropChance] = self._player:getCharacterStatPointLimitedDropItem()
  }
  for key, index in pairs(self._potential) do
    if limitData[index] < currentData[index] then
      currentData[index] = limitData[index]
    end
    if index < 2 then
      self._ui._staticTextPotential_Value[index]:SetText(tostring(currentData[index] - 5) .. " " .. levelText)
      for slotIndex = 0, 4 do
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetShow(slotIndex < currentData[index] - 5)
      end
    else
      self._ui._staticTextPotential_Value[index]:SetText(tostring(currentData[index]) .. " " .. levelText)
      for slotIndex = 0, 4 do
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetShow(slotIndex < currentData[index])
      end
    end
    if isGameTypeKorea() or isGameTypeTaiwan() then
      self._ui._staticTextPotential_Value[index]:SetShow(true)
      self._ui._staticTextPotential_Title[index]:SetSize(80, 20)
      self._ui._staticTextPotential_Title[index]:SetText(self._ui._staticTextPotential_Title[index]:GetText())
      for slotIndex = 0, 4 do
        self._ui._staticPotencialGradeBg[index][slotIndex]:SetPosX(90 + slotIndex * 33)
        self._ui._staticPotencialGradeBg[index][slotIndex]:SetPosY(11)
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetPosX(90 + slotIndex * 33)
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetPosY(11)
        self._ui._staticPotencialMinusGrade[index][slotIndex]:SetPosX(90 + slotIndex * 33)
        self._ui._staticPotencialMinusGrade[index][slotIndex]:SetPosY(11)
      end
    else
      self._ui._staticTextPotential_Value[index]:SetShow(false)
      self._ui._staticTextPotential_Title[index]:SetSize(145, 20)
      self._ui._staticTextPotential_Title[index]:SetText(self._ui._staticTextPotential_Title[index]:GetText())
      for slotIndex = 0, 4 do
        self._ui._staticPotencialGradeBg[index][slotIndex]:SetPosX(150 + slotIndex * 33)
        self._ui._staticPotencialGradeBg[index][slotIndex]:SetPosY(11)
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetPosX(150 + slotIndex * 33)
        self._ui._staticPotencialPlusGrade[index][slotIndex]:SetPosY(11)
        self._ui._staticPotencialMinusGrade[index][slotIndex]:SetPosX(150 + slotIndex * 33)
        self._ui._staticPotencialMinusGrade[index][slotIndex]:SetPosY(11)
      end
    end
  end
end
function FromClient_UI_CharacterInfo_Basic_FitnessChanged(addSp, addWeight, addHp, addMp)
  local self = PaGlobal_CharacterInfoBasic
  self._player = getSelfPlayer()
  self._playerGet = self._player:get()
  local _mentalType = self._player:getCombatResourceType()
  local _mpName = {
    [CombatType.CombatType_MP] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MP"),
    [CombatType.CombatType_FP] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FP_NEW"),
    [CombatType.CombatType_EP] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EP"),
    [CombatType.CombatType_BP] = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_BP")
  }
  self._mpTypeName = _mpName[_mentalType]
  if addSp > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness._stamina)
  elseif addWeight > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness._strength)
  elseif addHp > 0 or addMp > 0 then
    FGlobal_FitnessLevelUp(addSp, addWeight, addHp, addMp, self._fitness._health)
  end
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local titleString = {
    [self._fitness._stamina] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE"),
    [self._fitness._strength] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE"),
    [self._fitness._health] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE")
  }
  if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
    titleString = {
      [self._fitness._stamina] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE"),
      [self._fitness._strength] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE"),
      [self._fitness._health] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE")
    }
  else
    titleString = {
      [self._fitness._stamina] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE_ONE"),
      [self._fitness._strength] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE_ONE"),
      [self._fitness._health] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE_ONE")
    }
  end
  for key, index in pairs(self._fitness) do
    local current = Int64toInt32(self._playerGet:getCurrFitnessExperiencePoint(index))
    local max = Int64toInt32(self._playerGet:getDemandFItnessExperiencePoint(index))
    local rate = current / max * 100
    local level = self._playerGet:getFitnessLevel(index)
    local _hpIncrease = tostring(ToClient_GetFitnessLevelStatus(index, 0))
    local _mpIncrease = tostring(ToClient_GetFitnessLevelStatus(index, 1))
    local _heathInfo
    self._ui._progress2Fitness[index]:SetProgressRate(rate)
    self._ui._staticTextFitness_Level[index]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_CRAFTLEVEL") .. tostring(level))
    if index ~= self._fitness._strength then
      if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
        if self._fitness._health == index then
          _heathInfo = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTHINFO_NEW", "hpIncrease", _hpIncrease, "mpTypeName", self._mpTypeName, "mpIncrease", _mpIncrease)
        else
          _heathInfo = titleString[index] .. tostring(ToClient_GetFitnessLevelStatus(index, 0))
        end
        self._ui._staticTextFitness_Title[index]:SetText(_heathInfo)
      else
        self._ui._staticTextFitness_Title[index]:SetText(titleString[index])
      end
    elseif isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
      self._ui._staticTextFitness_Title[index]:SetText(titleString[index] .. tostring(ToClient_GetFitnessLevelStatus(index, 0) / 10000))
    else
      self._ui._staticTextFitness_Title[index]:SetText(titleString[index])
    end
  end
end
function FromClient_UI_CharacterInfo_Basic_NormalStackChanged()
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  local self = PaGlobal_CharacterInfoBasic
  local defaultCount = self._playerGet:getEnchantFailCount()
  local valksCount = self._playerGet:getEnchantValuePackCount()
  local familyCount = getEnchantInformation():ToClient_getBonusStackCount()
  if ToClient_IsReceivedEnchantFailCount() then
    self._ui._staticTextNormalStack:SetText(defaultCount + valksCount + familyCount)
  else
    self._ui._staticTextNormalStack:SetText("-")
  end
  self._ui._staticTextNormalStack:addInputEvent("Mouse_On", "PaGlobal_CharacterInfoBasic:handleMouseOver_NormalStack( true, " .. defaultCount .. "," .. valksCount .. ", " .. familyCount .. " )")
  self._ui._staticTextNormalStack:addInputEvent("Mouse_Out", "PaGlobal_CharacterInfoBasic:handleMouseOver_NormalStack( false, " .. defaultCount .. "," .. valksCount .. ", " .. familyCount .. " )")
end
function FromClient_UI_CharacterInfo_Basic_ScreenResize()
  if nil == Panel_Window_CharInfo_Status then
    PaGlobal_CharacterInfo._isResize = true
    return
  end
  Panel_Window_CharInfo_Status:SetPosX(5)
  Panel_Window_CharInfo_Status:SetPosY(getScreenSizeY() / 2 - Panel_Window_CharInfo_Status:GetSizeY() / 2)
  PaGlobal_CharacterInfo._isResize = false
end
function PaGlobal_CharacterInfoBasic:handleClicked_FacePhotoButton()
  self:handleMouseOver_FacePhotoButton(false)
  FGlobal_InGameCustomize_SetCharacterInfo(true)
  IngameCustomize_Show()
end
function PaGlobal_CharacterInfoBasic:handleClicked_Introduce()
  SetFocusEdit(self._ui._multilineEdit)
  self._ui._multilineEdit:SetEditText(self._ui._multilineEdit:GetEditText(), true)
end
function PaGlobal_CharacterInfoBasic:handleClicked_SetIntroduce()
  local msg = self._ui._multilineEdit:GetEditText()
  ToClient_RequestSetUserIntroduction(msg)
  local oneLineMsg = string.gsub(msg, "\n", " ")
  self._ui._multilineEditIntroduce:SetEditText(oneLineMsg)
  ClearFocusEdit()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_MYINTRODUCE_REGIST"))
  self:showIntroduce(false)
end
function PaGlobal_CharacterInfoBasic:handleClicked_ResetIntroduce()
  local msg = ""
  self._ui._multilineEdit:SetEditText(msg)
  ToClient_RequestSetUserIntroduction(msg)
  local oneLineMsg = string.gsub(msg, "\n", " ")
  self._ui._multilineEditIntroduce:SetEditText(oneLineMsg)
  ClearFocusEdit()
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_FacePhotoButton(isShow)
  if self:checkToolTip(isShow) == false then
    return
  end
  local control, name, desc
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_FACEPHOTO_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_FACEPHOTO_TOOLTIP_DESC")
  control = self._ui._buttonFacePhoto
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_FamilyPoints(isShow, tipType)
  if nil == Panel_Window_CharInfo_BasicStatus then
    return
  end
  if self:checkToolTip(isShow) == false then
    return
  end
  local string = {
    [self._familyPoint._family] = {
      "LUA_FAMILYPOINTS_SUM_TOOLTIP_TITLE",
      "LUA_FAMILYPOINTS_SUM_TOOLTIP_DESC"
    },
    [self._familyPoint._combat] = {
      "LUA_FAMILYPOINTS_COMBAT_TOOLTIP_TITLE",
      "LUA_FAMILYPOINTS_COMBAT_TOOLTIP_DESC"
    },
    [self._familyPoint._life] = {
      "LUA_FAMILYPOINTS_LIFE_TOOLTIP_TITLE",
      "LUA_FAMILYPOINTS_LIFE_TOOLTIP_DESC"
    },
    [self._familyPoint._etc] = {
      "LUA_FAMILYPOINTS_ETC_TOOLTIP_TITLE",
      "LUA_FAMILYPOINTS_ETC_TOOLTIP_DESC"
    }
  }
  local name = PAGetString(Defines.StringSheet_GAME, string[tipType][1])
  local desc = PAGetString(Defines.StringSheet_GAME, string[tipType][2])
  local control = self._ui._staticTextFamilyPoints[tipType]
  TooltipSimple_Show(control, name, desc)
  if 1 == tipType then
    local _panel = Panel_Window_CharInfo_Status
    local tooltipPanel = Panel_Tooltip_SimpleText
    local tooltipSizeX = tooltipPanel:GetSizeX()
    local tooltipSizeY = tooltipPanel:GetSizeY()
    local isGapX = getScreenSizeX() - (_panel:GetPosX() + _panel:GetSizeX() + tooltipSizeX) > 0
    local isGapY = getScreenSizeY() - (_panel:GetPosY() + tooltipSizeY)
    local posX = 0
    local posY = 0
    if true == isGapX then
      posX = _panel:GetPosX() + _panel:GetSizeX()
    else
      posX = _panel:GetPosX() - tooltipSizeX
    end
    if isGapY > 0 then
      if 0 > _panel:GetPosY() then
        posY = math.abs(_panel:GetPosY())
      else
        posY = _panel:GetPosY()
      end
    else
      posY = _panel:GetPosY() + isGapY
    end
    TooltipSimple_Common_Pos(posX, posY)
  end
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_NormalStack(isShow, defaultCount, valksCount, familyCount)
  if self:checkToolTip(isShow) == false then
    return
  end
  local control, name, desc, isValksItemCheck
  local isValksItem = ToClient_IsContentsGroupOpen("47")
  if isValksItem == false then
    isValksItemCheck = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENCHANTCOUNT_TOOLTIP_ADDCOUNT_NONE", "defaultCount", tostring(defaultCount))
  else
    isValksItemCheck = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_GAMEEXIT_ENCHANTCOUNT_TOOLTIP", "defaultCount", tostring(defaultCount), "valksCount", tostring(valksCount), "familyCount", tostring(familyCount))
  end
  name = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_NORMALSTACK_TOOLTIP_DESC") .. isValksItemCheck
  control = self._ui._staticTextNormalStack
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_Regist(isShow, tipType)
  if self:checkToolTip(isShow) == false then
    return
  end
  local string = {
    [self._regist._sturn] = {
      "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_NAME",
      "LUA_CHARACTERINFO_TXT_REGIST_STUN_TOOLTIP_DESC"
    },
    [self._regist._down] = {
      "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_NAME",
      "LUA_CHARACTERINFO_TXT_REGIST_DOWN_TOOLTIP_DESC"
    },
    [self._regist._capture] = {
      "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_NAME",
      "LUA_CHARACTERINFO_TXT_REGIST_CAPTURE_TOOLTIP_DESC"
    },
    [self._regist._knockBack] = {
      "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_NAME",
      "LUA_CHARACTERINFO_TXT_REGIST_KNOCKBACK_TOOLTIP_DESC"
    }
  }
  local control, name, desc
  name = PAGetString(Defines.StringSheet_GAME, string[tipType][1])
  desc = PAGetString(Defines.StringSheet_GAME, string[tipType][2])
  control = self._ui._staticTextResist_Title[tipType]
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_Fitness(isShow, _tipType)
  if self:checkToolTip(isShow) == false then
    return
  end
  local control, name, desc
  if self._fitness._stamina == _tipType then
    control = self._ui._staticTextFitness_Title[self._fitness._stamina]
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STAMINA_TITLE_ONE")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STAMINA_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_tipType)))
  elseif self._fitness._strength == _tipType then
    control = self._ui._staticTextFitness_Title[self._fitness._strength]
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_STRENGTH_TITLE_ONE")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_STRENGTH_MSG", "type", tostring(ToClient_GetFitnessLevelStatus(_tipType) / 10000))
  elseif self._fitness._health == _tipType then
    control = self._ui._staticTextFitness_Title[self._fitness._health]
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_TITLE_ONE")
    local _hpIncrease = tostring(ToClient_GetFitnessLevelStatus(_tipType, 0))
    local _mpIncrease = tostring(ToClient_GetFitnessLevelStatus(_tipType, 1))
    if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeJapan() then
      desc = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_FITNESS_HEALTH_MSG_NEW", "hpIncrease", _hpIncrease, "mpTypeName", self._mpTypeName, "mpIncrease", _mpIncrease)
    else
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFCHARACTERINFO_FITNESS_HEALTH_MSG", "type", _hpIncrease)
    end
  else
    return
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_Potential(isShow, _tipType)
  if self:checkToolTip(isShow) == false then
    return
  end
  local classType = self._player:getClassType()
  local string = {
    [self._potential._attackSpeed] = "LUA_CHARACTERINFO_TXT_DESC_" .. Class_BattleSpeed[classType],
    [self._potential._moveSpeed] = "LUA_CHARACTERINFO_TXT_DESC_2",
    [self._potential._critical] = "LUA_CHARACTERINFO_TXT_DESC_3",
    [self._potential._fishTime] = "LUA_CHARACTERINFO_TXT_DESC_4",
    [self._potential._product] = "LUA_CHARACTERINFO_TXT_DESC_5",
    [self._potential._dropChance] = "LUA_CHARACTERINFO_TXT_DESC_6"
  }
  local control, name, desc
  control = self._ui._staticTextPotential_Title[_tipType]
  name = self._ui._staticTextPotential_Title[_tipType]:GetText()
  desc = PAGetString(Defines.StringSheet_GAME, string[_tipType])
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_CharInfomation(isShow, _tipType)
  if self:checkToolTip(isShow) == false then
    return
  end
  local control, name, desc
  control = self._ui._staticStatus_Title[_tipType]
  if self._status._health == _tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_HPREGEN") .. " : " .. tostring(self._playerGet:getRegenHp())
  elseif self._status._mental == _tipType then
    local mentalType = self._player:getCombatResourceType()
    if CombatType.CombatType_MP == mentalType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_MPREGEN") .. " : " .. tostring(self._playerGet:getRegenMp())
    elseif CombatType.CombatType_FP == mentalType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_FPREGEN") .. " : " .. tostring(self._playerGet:getRegenMp())
    elseif CombatType.CombatType_EP == mentalType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_EPREGEN") .. " : " .. tostring(self._playerGet:getRegenMp())
    elseif CombatType.CombatType_BP == mentalType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_BPREGEN") .. " : " .. tostring(self._playerGet:getRegenMp())
    end
  elseif self._status._weight == _tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHARACTERINFO_WEIGHT_TOOLTIP")
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_Craft(isShow, _slotNo)
  if self:checkToolTip(isShow) == false then
    return
  end
  if 0 == _slotNo then
    return
  end
  local tableNo = _slotNo + 1
  local control, name, desc
  local expRate = self._craftTable[_slotNo]._exp * toInt64(0, 100) / self._craftTable[_slotNo]._maxExp
  name = UI_LifeString[self._craftTable[_slotNo]._type]
  desc = UI_LifeToolTip[self._craftTable[_slotNo]._type] .. [[

<PAColor0xFFFFF3AF>]] .. PAGetString(Defines.StringSheet_RESOURCE, "SERVANT_INFO_TEXT_EXP") .. " : " .. tostring(expRate) .. "%<PAOldColor>"
  control = self._ui._staticTextCraft_Title[_slotNo]
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:handleMouseOver_Tooltip(isShow, tipType, controlIndex)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == tipType then
    TooltipSimple_Hide()
    return
  end
  if nil == controlIndex then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = UI_LifeString[tipType]
  control = self._ui._staticCraftIcon[controlIndex]
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_CharacterInfoBasic:showWindow()
  self:showIntroduce(false)
  self:update()
end
function PaGlobal_CharacterInfoBasic:hideWindow()
  TooltipSimple_Hide()
  self._toolTipCount = 0
end
function PaGlobal_CharacterInfoBasic:showIntroduce(isShow)
  self._ui._staticIntroduceBG:SetShow(isShow)
  if not isShow then
    UI.ClearFocusEdit()
    return
  end
  local msg = ToClient_GetUserIntroduction()
  self._ui._multilineEdit:SetEditText(msg)
end
function PaGlobal_CharacterInfoBasic:checkToolTip(isShow)
  if false == isShow then
    self._toolTipCount = self._toolTipCount - 1
    if self._toolTipCount < 1 then
      self._toolTipCount = 0
      TooltipSimple_Hide()
    end
    return false
  else
    self._toolTipCount = self._toolTipCount + 1
    return true
  end
end
function PaGlobal_CharacterInfoBasic:updateFacePhoto()
  local classType = self._player:getClassType()
  local TextureName = ToClient_GetCharacterFaceTexturePath(self._player:getCharacterNo_64())
  local isCaptureExist = self._ui._staticCharSlot:ChangeTextureInfoNameNotDDS(TextureName, classType, true)
  if isCaptureExist == true then
    self._ui._staticCharSlot:getBaseTexture():setUV(0, 0, 1, 1)
  else
    local DefaultFace = UI_DefaultFaceTexture[classType]
    self._ui._staticCharSlot:ChangeTextureInfoName(DefaultFace[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._staticCharSlot, DefaultFace[2], DefaultFace[3], DefaultFace[4], DefaultFace[5])
    self._ui._staticCharSlot:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  self._ui._staticCharSlot:setRenderTexture(self._ui._staticCharSlot:getBaseTexture())
end
PaGlobal_Char_LifeInfo = {
  _lifeInfo = {},
  _lifeType_Panel_Name = {
    [__ePlayerLifeStatType_Collecting] = "Static_Bg_Gathering",
    [__ePlayerLifeStatType_Fishing] = "Static_Bg_Fishing",
    [__ePlayerLifeStatType_Hunting] = "Static_Bg_Hunting",
    [__ePlayerLifeStatType_Cooking] = "Static_Bg_Cook",
    [__ePlayerLifeStatType_Alchemy] = "Static_Bg_Alchemy",
    [__ePlayerLifeStatType_Manufacture] = "Static_Bg_Manufacture",
    [__ePlayerLifeStatType_Training] = "Static_Bg_TrainingHorse",
    [__ePlayerLifeStatType_Trade] = "Static_Bg_Trade",
    [__ePlayerLifeStatType_Harvest] = "Static_Bg_Gardening",
    [__ePlayerLifeStatType_Sail] = "Static_Bg_Sailing"
  },
  _lifeSubTypeCount = {
    [__ePlayerLifeStatType_Collecting] = __eCollectToolType_Count,
    [__ePlayerLifeStatType_Fishing] = __eFishingStatType_Count,
    [__ePlayerLifeStatType_Hunting] = __eHuntingStatType_Count,
    [__ePlayerLifeStatType_Cooking] = __eCookingStatType_Count,
    [__ePlayerLifeStatType_Alchemy] = __eAlchemyStatType_Count,
    [__ePlayerLifeStatType_Manufacture] = __eManufacturingStatType_Count,
    [__ePlayerLifeStatType_Training] = __eTrainingStatType_Count,
    [__ePlayerLifeStatType_Trade] = __eTradeStatType_Count,
    [__ePlayerLifeStatType_Harvest] = __eFarmingStatType_Count,
    [__ePlayerLifeStatType_Sail] = __eSailStatType_Count
  }
}
function PaGlobal_Char_LifeInfo:Init()
  if nil == Panel_Window_CharInfo_LifeInfo then
    return
  end
  for key, value in pairs(self._lifeType_Panel_Name) do
    self._lifeInfo[key] = {}
    self._lifeInfo[key]._ui = {}
    self._lifeInfo[key]._ui._subCategoryTitle = {}
    self._lifeInfo[key]._ui._subCategoryPoint = {}
    self._lifeInfo[key]._ui._parent = UI.getChildControl(Panel_Window_CharInfo_LifeInfo, value)
    self._lifeInfo[key]._ui._commonPoint = UI.getChildControl(self._lifeInfo[key]._ui._parent, "StaticText_LifePoint")
    self._lifeInfo[key]._ui._progressBar = UI.getChildControl(self._lifeInfo[key]._ui._parent, "Progress2_Exp")
    self._lifeInfo[key]._ui._expText = UI.getChildControl(self._lifeInfo[key]._ui._parent, "StaticText_Percent")
    self._lifeInfo[key]._ui._levelText = UI.getChildControl(self._lifeInfo[key]._ui._parent, "StaticText_Level")
    self._lifeInfo[key]._ui._progressBG = UI.getChildControl(self._lifeInfo[key]._ui._parent, "Static_ProgressBg")
    local count = 0
    if __ePlayerLifeStatType_Collecting == key then
      count = 7
    elseif __ePlayerLifeStatType_Manufacture == key then
      count = self._lifeSubTypeCount[key] - 1
    end
    for ii = 1, count do
      if nil == self._lifeInfo[key] then
      else
        local titleControlName = "StaticText_SubCetegoryTitle" .. tostring(ii)
        local pointControlName = "StaticText_SubCategoryValue" .. tostring(ii)
        self._lifeInfo[key]._ui._subCategoryTitle[ii] = UI.getChildControl(self._lifeInfo[key]._ui._parent, titleControlName)
        self._lifeInfo[key]._ui._subCategoryPoint[ii] = UI.getChildControl(self._lifeInfo[key]._ui._parent, pointControlName)
      end
    end
    if 1 == key or 2 == key or 9 == key or 4 == key or 6 == key or 3 == key then
      self._lifeInfo[key]._ui._progressBG:addInputEvent("Mouse_On", "PaGlobal_Char_LifeInfo:LifePower_MouseOverEvent(true," .. key .. ")")
      self._lifeInfo[key]._ui._progressBG:addInputEvent("Mouse_Out", "PaGlobal_Char_LifeInfo:LifePower_MouseOverEvent(false," .. key .. ")")
    else
      self._lifeInfo[key]._ui._progressBG:addInputEvent("Mouse_On", "PaGlobal_Char_LifeInfo:Life_MouseOverEvent(" .. key .. ",true)")
      self._lifeInfo[key]._ui._progressBG:addInputEvent("Mouse_Out", "PaGlobal_Char_LifeInfo:Life_MouseOverEvent(" .. key .. ",false)")
    end
  end
end
function FromClient_UI_CharacterInfo_Basic_LifeLevelChangeNew()
  if nil == Panel_Window_CharInfo_LifeInfo then
    return
  end
  FromClient_UI_CharacterInfo_Basic_CraftLevelChanged()
  local isSailOpen = ToClient_IsContentsGroupOpen("83")
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  for key, value in pairs(PaGlobal_Char_LifeInfo._lifeType_Panel_Name) do
    local currentLevel = selfPlayer:get():getLifeExperienceLevel(key)
    local currentExp64 = selfPlayer:get():getCurrLifeExperiencePoint(key)
    local needExp64 = selfPlayer:get():getDemandLifeExperiencePoint(key)
    local currentExpRate64 = currentExp64 * toInt64(0, 10000) / needExp64
    local currentExpRate = Int64toInt32(currentExpRate64)
    currentExpRate = currentExpRate / 100
    local currentExpRateString = string.format("%.2f", currentExpRate)
    PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._progressBar:SetProgressRate(currentExpRate)
    PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._expText:SetText(currentExpRateString .. "%")
    PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._levelText:SetText(FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(currentLevel))
    PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._levelText:SetFontColor(FGlobal_UI_CharacterInfo_Basic_Global_CraftColorReplace(currentLevel))
    PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._levelText:SetPosX(PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._expText:GetPosX() - PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._levelText:GetTextSizeX() - 15)
    if key == __ePlayerLifeStatType_Collecting or key == __ePlayerLifeStatType_Manufacture then
      local commonPoint = ToClient_GetCommonLifeStat(key)
      local commonPointString = PAGetString(Defines.StringSheet_GAME, "LUA_CHARINFO_COMMONLIFESTAT") .. " " .. tostring(commonPoint)
      PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._commonPoint:SetText(commonPointString)
    else
      local subPoint = selfPlayer:get():getLifeStat(key, 1)
      local commonPointString = PAGetString(Defines.StringSheet_GAME, "LUA_CHARINFO_COMMONLIFESTAT") .. " " .. tostring(subPoint)
      PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._commonPoint:SetText(commonPointString)
      PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._commonPoint:SetIgnore(true)
    end
    for ii = 1, PaGlobal_Char_LifeInfo._lifeSubTypeCount[key] - 1 do
      if nil ~= PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._subCategoryPoint[ii] then
        local subPoint = selfPlayer:get():getLifeStat(key, ii)
        PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._subCategoryPoint[ii]:SetText(tostring(subPoint))
        PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._subCategoryTitle[ii]:addInputEvent("Mouse_On", "PaGlobal_Char_LifeInfo:LifePower_MouseOverEvent(true," .. key .. "," .. ii .. ")")
        PaGlobal_Char_LifeInfo._lifeInfo[key]._ui._subCategoryTitle[ii]:addInputEvent("Mouse_Out", "PaGlobal_Char_LifeInfo:LifePower_MouseOverEvent(false," .. key .. "," .. ii .. ")")
      end
    end
  end
end
function PaGlobal_Char_LifeInfo:Life_MouseOverEvent(sourceType, isOn)
  if not isOn then
    TooltipSimple_Hide()
    return
  end
  if true == isOn then
    local name, desc, control
    if 0 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE0")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_1")
    elseif 1 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE1")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_5")
    elseif 2 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE2")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_6")
    elseif 3 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE3")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2")
    elseif 4 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE4")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2")
    elseif 5 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE5")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_2")
    elseif 6 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE6")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_3")
    elseif 7 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE7")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_4")
    elseif 8 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE8")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_7")
    elseif 9 == sourceType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE9")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_CRAFT_DESC_8")
    end
    control = self._lifeInfo[sourceType]._ui._progressBG
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Char_LifeInfo:LifePower_MouseOverEvent(isShow, mainType, subType)
  if nil == Panel_Window_CharInfo_LifeInfo then
    return
  end
  if false == isShow then
    TooltipSimple_Hide()
  else
    local name, desc, control
    if __ePlayerLifeStatType_Manufacture == mainType then
      local countRate = ToClient_getManufacturingStatCountRate(subType)
      name = self._lifeInfo[mainType]._ui._subCategoryTitle[subType]:GetText()
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MANUFACTURING_POWER_TOOLTIP_DESC", "data2", tostring(countRate))
      control = self._lifeInfo[mainType]._ui._subCategoryTitle[subType]
    elseif __ePlayerLifeStatType_Collecting == mainType then
      if false == _ContentsGroup_EnhanceCollect then
        return
      end
      local characterCollectRate = ToClient_getSelfPlayerCollectRate()
      local count = ToClient_LoadCollectingStatData(subType)
      local tempString = {}
      for ii = 0, count - 2 do
        local dropRate = ToClient_getCollectingStatAddDropRate(ii)
        local dropCountRate = ToClient_getCollectingStatAddDropCountRate(ii)
        if characterCollectRate >= 800000 then
          dropRate = 0
        end
        dropRate = dropRate / 1000
        dropRate = math.floor(dropRate) / 10
        dropCountRate = dropCountRate / 1000
        dropCountRate = math.floor(dropCountRate) / 10
        local stringFormatKey = string.format("LUA_COLLECTING_POWER_DESC_%d", ii + 1)
        tempString[ii] = PAGetStringParam2(Defines.StringSheet_GAME, stringFormatKey, "rate1", tostring(dropRate), "rate2", tostring(dropCountRate))
      end
      characterCollectRate = characterCollectRate / 1000
      characterCollectRate = math.floor(characterCollectRate) / 10
      local subStringName = string.format("LUA_COLLECTING_POWER_DESC_SUB_%d", subType)
      desc = string.format([[
%s
%s%s%s
%s

%s]], PAGetString(Defines.StringSheet_GAME, "LUA_COLLECTING_POWER_DESC_MAIN"), tempString[0], tempString[1], tempString[2], PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COLLECTING_POWER_DESC_4", "charRate", tostring(characterCollectRate)), PAGetString(Defines.StringSheet_GAME, tostring(subStringName)))
      name = self._lifeInfo[mainType]._ui._subCategoryTitle[subType]:GetText()
      control = self._lifeInfo[mainType]._ui._subCategoryTitle[subType]
    elseif __ePlayerLifeStatType_Hunting == mainType then
      if false == _ContentsGroup_EnhanceHunt then
        return
      end
      local dropRate = ToClient_getHuntingRate()
      if dropRate > 0 then
        dropRate = dropRate / 1000
        dropRate = math.floor(dropRate) / 10
      end
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_HUNTING_DESC", "rate", dropRate)
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE2")
      control = self._lifeInfo[mainType]._ui._commonPoint
    elseif __ePlayerLifeStatType_Alchemy == mainType then
      if false == _ContentsGroup_EnhanceAlchemy then
        return
      end
      local alchemySSW = ToClient_getAlchemyStatStaticStatus()
      if nil == alchemySSW then
        local tempdesc1 = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_ALCHEMY_DESC_1", "rate1", 0, "rate2", 0, "rate3", 0, "rate4", 0)
        local tempdesc2 = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_ALCHEMY_DESC_2", "rate1", 0)
        desc = string.format([[
%s
%s]], tempdesc1, tempdesc2)
      else
        local rate1 = string.format("%.1f", alchemySSW._basicMaxDropRate / 10000)
        local eventDropRate = alchemySSW._eventDropRate / 1000000
        local dropRate1 = alchemySSW:getEventDropRateForTooltip(0) / 1000000
        local dropRate2 = alchemySSW:getEventDropRateForTooltip(1) / 1000000
        local dropRate3 = alchemySSW:getEventDropRateForTooltip(2) / 1000000
        local basicRate = eventDropRate * (1 - dropRate3) * (1 - dropRate2)
        local specialRate = eventDropRate * (1 - dropRate3) * dropRate2
        local uniqueRate = eventDropRate * dropRate3
        local tempdesc1 = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_ALCHEMY_DESC_1", "rate1", rate1, "rate2", string.format("%.2f", basicRate * 100), "rate3", string.format("%.2f", specialRate * 100), "rate4", string.format("%.2f", uniqueRate * 100))
        local royalBonus = string.format("%.1f", alchemySSW._addRoyalTradeBonus / 10000)
        local tempdesc2 = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_ALCHEMY_DESC_2", "rate1", royalBonus)
        desc = string.format([[
%s
%s]], tempdesc1, tempdesc2)
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE4")
      control = self._lifeInfo[mainType]._ui._commonPoint
    elseif __ePlayerLifeStatType_Sail == mainType then
      if false == _ContentsGroup_EnhanceSail then
        return
      end
      local sailStatStaticStatus = ToClient_getSailStatStaticStatus()
      local pv = 0
      local acc = 0
      local spd = 0
      local cor = 0
      local brk = 0
      if nil ~= sailStatStaticStatus then
        acc = string.format("%.1f", sailStatStaticStatus:getVariedStatByIndex(0) / 10000)
        spd = string.format("%.1f", sailStatStaticStatus:getVariedStatByIndex(1) / 10000)
        cor = string.format("%.1f", sailStatStaticStatus:getVariedStatByIndex(2) / 10000)
        brk = string.format("%.1f", sailStatStaticStatus:getVariedStatByIndex(3) / 10000)
      end
      local desc1 = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_SAILSTAT_DESC_1", "rate2", tostring(acc))
      local desc2 = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_SAILSTAT_DESC_2", "rate1", tostring(spd), "rate2", tostring(cor), "rate3", tostring(brk))
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE9")
      desc = string.format([[
%s
%s]], desc1, desc2)
      control = self._lifeInfo[mainType]._ui._commonPoint
    elseif __ePlayerLifeStatType_Fishing == mainType then
      if false == _ContentsGroup_EnhanceFishing then
        return
      end
      local fishingStatStaticStatus = ToClient_getFishingStatStaticStatus()
      local addRate = 0
      if nil ~= fishingStatStaticStatus then
        addRate = string.format("%.1f", fishingStatStaticStatus._rate / 10000)
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE1")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_FISHINGSTAT_DESC", "rate", tostring(addRate))
      control = self._lifeInfo[mainType]._ui._commonPoint
    elseif __ePlayerLifeStatType_Cooking == mainType then
      if false == _ContentsGroup_EnhanceCooking then
        return
      end
      local cookingStatStaticStatus = ToClient_getCookingStatStaticStatus()
      local speedCookRate = 0
      local basicMaxDropRate = 0
      local addCriticalDropRate = 0
      local addCriticalMaxDropRate = 0
      local addRoyalTradeBonus = 0
      if nil ~= cookingStatStaticStatus then
        speedCookRate = string.format("%.1f", cookingStatStaticStatus._speedCookRate / 10000)
        basicMaxDropRate = string.format("%.1f", cookingStatStaticStatus._basicMaxDropRate / 10000)
        addCriticalDropRate = string.format("%.1f", cookingStatStaticStatus._addCriticalDropRate / 10000)
        addCriticalMaxDropRate = string.format("%.1f", cookingStatStaticStatus._addCriticalMaxDropRate / 10000)
        addRoyalTradeBonus = string.format("%.1f", cookingStatStaticStatus._addRoyalTradeBonus / 10000)
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE3")
      desc = string.format("%s%s", PAGetStringParam4(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_COOK_DESC_1", "rate1", tostring(speedCookRate), "rate2", tostring(basicMaxDropRate), "rate3", tostring(addCriticalDropRate), "rate4", tostring(addCriticalMaxDropRate)), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_COOK_DESC_2", "rate1", tostring(addRoyalTradeBonus)))
      control = self._lifeInfo[mainType]._ui._commonPoint
    elseif __ePlayerLifeStatType_Training == mainType then
      if false == _ContentsGroup_EnhanceTraining then
        return
      end
      local trainingStatStaticStatus = ToClient_getTrainingStatStaticStatus()
      local captureRate = 0
      local expRate = 0
      local matingRate = 0
      if nil ~= trainingStatStaticStatus then
        captureRate = string.format("%.1f", trainingStatStaticStatus._addHorseCaptureRate / 10000)
        expRate = string.format("%.1f", trainingStatStaticStatus._addVehicleExperienceRate / 10000)
        matingRate = string.format("%.1f", trainingStatStaticStatus._addMatingRate / 10000)
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE6")
      desc = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_LIFE_TRAINING_DESC_1", "rate1", tostring(captureRate), "rate2", tostring(expRate), "rate3", tostring(matingRate))
      control = self._lifeInfo[mainType]._ui._commonPoint
    else
      return
    end
    TooltipSimple_Show(control, name, desc)
  end
end
function FromClient_CharacterInfoLife_Init()
  PaGlobal_Char_LifeInfo:Init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoLife_Init")
