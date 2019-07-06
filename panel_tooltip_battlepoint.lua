PaGlobal_Tooltip_BattlePoint = {
  _ui = {
    _battlePoint = {
      _title = UI.getChildControl(Panel_Tooltip_BattlePoint, "StaticText_BattleGradeTitle"),
      _partLine = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_PartLine"),
      _staticBG_TierTotal = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_TierTotal"),
      _staticBG_CurrentTier = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_CurrentTierBg"),
      _staticBG_BonusStat = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_BonusStatBg"),
      _staticText_Desc = UI.getChildControl(Panel_Tooltip_BattlePoint, "StaticText_Desc"),
      _staticText_Desc2 = UI.getChildControl(Panel_Tooltip_BattlePoint, "StaticText_Desc2")
    },
    _equipPoint = {
      _equipTitle = UI.getChildControl(Panel_Tooltip_BattlePoint, "StaticText_EquipBonusTitle"),
      _equipLine = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_EquipLine"),
      _equip_BonusStat = UI.getChildControl(Panel_Tooltip_BattlePoint, "Static_EquipBonusStatBg")
    }
  },
  _panel = Panel_Tooltip_BattlePoint,
  _isDetail = false,
  _icon = nil,
  _isInit = false
}
PaGlobal_Tooltip_BattlePoint._ui._battlePoint._staticText_Desc2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
local CT = CppEnums.ClassType
local awakenWeapon = {
  [CT.ClassType_Warrior] = ToClient_IsContentsGroupOpen("901"),
  [CT.ClassType_Ranger] = ToClient_IsContentsGroupOpen("902"),
  [CT.ClassType_Sorcerer] = ToClient_IsContentsGroupOpen("903"),
  [CT.ClassType_Giant] = ToClient_IsContentsGroupOpen("904"),
  [CT.ClassType_Tamer] = ToClient_IsContentsGroupOpen("905"),
  [CT.ClassType_BladeMaster] = ToClient_IsContentsGroupOpen("906"),
  [CT.ClassType_BladeMasterWomen] = ToClient_IsContentsGroupOpen("907"),
  [CT.ClassType_Valkyrie] = ToClient_IsContentsGroupOpen("908"),
  [CT.ClassType_Wizard] = ToClient_IsContentsGroupOpen("909"),
  [CT.ClassType_WizardWomen] = ToClient_IsContentsGroupOpen("910"),
  [CT.ClassType_NinjaMan] = ToClient_IsContentsGroupOpen("911"),
  [CT.ClassType_NinjaWomen] = ToClient_IsContentsGroupOpen("912"),
  [CT.ClassType_DarkElf] = ToClient_IsContentsGroupOpen("913"),
  [CT.ClassType_Combattant] = ToClient_IsContentsGroupOpen("914"),
  [CT.ClassType_CombattantWomen] = ToClient_IsContentsGroupOpen("918"),
  [CT.ClassType_Lahn] = ToClient_IsContentsGroupOpen("916"),
  [CT.ClassType_Orange] = ToClient_IsContentsGroupOpen("942"),
  [__eClassType_ShyWaman] = ToClient_IsContentsGroupOpen("1366")
}
local classType = getSelfPlayer():getClassType()
local awakenWeaponContentsOpen = awakenWeapon[classType]
local alignCurrentTierBg = function(currentTierBg, targetControl)
  currentTierBg:SetPosX(targetControl:GetPosX())
  local posY = (targetControl:GetSizeY() - currentTierBg:GetSizeY()) * 0.5
  currentTierBg:SetPosY(targetControl:GetPosY() + posY)
end
local setTierIcon = function(iconControl, textureName, iconIdx, leftX, topY, xCount, iconSize)
  iconControl:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Etc_04.dds")
  iconControl:SetShow(true)
  local x1, y1, x2, y2
  x1 = leftX + (iconSize + 1) * (iconIdx % xCount)
  y1 = topY + (iconSize + 1) * math.floor(iconIdx / xCount)
  x2 = x1 + iconSize
  y2 = y1 + iconSize
  x1, y1, x2, y2 = setTextureUV_Func(iconControl, x1, y1, x2, y2)
  iconControl:getBaseTexture():setUV(x1, y1, x2, y2)
  iconControl:setRenderTexture(iconControl:getBaseTexture())
end
function PaGlobal_Tooltip_BattlePoint:initWithIcon(icon)
  if not icon then
    return false
  end
  icon:addInputEvent("Mouse_On", "PaGlobal_Tooltip_BattlePoint:show(true)")
  icon:addInputEvent("Mouse_Out", "PaGlobal_Tooltip_BattlePoint:show(false)")
  icon:addInputEvent("Mouse_LUp", "PaGlobal_Tooltip_BattlePoint:toggleDetail()")
  self._icon = icon
  return true
end
function PaGlobal_Tooltip_BattlePoint:SetPos()
  if true == _ContentsGroup_RenewUI then
    return
  end
  local posX = Panel_Equipment:GetPosX() - self._panel:GetSizeX()
  if posX < 0 then
    posX = Panel_Equipment:GetPosX() + Panel_Equipment:GetSizeX()
  end
  local posY = Panel_Equipment:GetPosY() + Panel_Equipment:GetSizeY() - self._panel:GetSizeY() - 10
  if posY < 0 then
    posY = 0
  elseif getScreenSizeY() < posY + self._panel:GetSizeY() then
    posY = getScreenSizeY() - self._panel:GetSizeY()
  end
  self._panel:SetPosX(posX)
  self._panel:SetPosY(posY)
end
function PaGlobal_Tooltip_BattlePoint:updateUIPos()
  for _, control in pairs(self._ui._equipPoint) do
    control:SetShow(false)
  end
  if self._isDetail then
    self._ui._battlePoint._title:SetShow(true)
    self._ui._battlePoint._partLine:SetShow(true)
    self._ui._battlePoint._staticBG_TierTotal:SetShow(true)
    self._ui._battlePoint._staticBG_CurrentTier:SetShow(true)
    self._ui._battlePoint._staticBG_BonusStat:SetShow(true)
    self._ui._battlePoint._staticText_Desc:SetShow(false)
    self._ui._battlePoint._staticText_Desc2:SetShow(false)
    self._icon:addInputEvent("Mouse_Out", "PaGlobal_Tooltip_BattlePoint:show(true)")
  else
    self._ui._battlePoint._title:SetShow(true)
    self._ui._battlePoint._partLine:SetShow(true)
    self._ui._battlePoint._staticBG_TierTotal:SetShow(false)
    self._ui._battlePoint._staticBG_CurrentTier:SetShow(true)
    self._ui._battlePoint._staticBG_BonusStat:SetShow(true)
    self._ui._battlePoint._staticText_Desc:SetShow(true)
    self._ui._battlePoint._staticText_Desc2:SetShow(false)
    self._icon:addInputEvent("Mouse_Out", "PaGlobal_Tooltip_BattlePoint:show(false)")
  end
  local posY = 40
  local sizeY = 0
  if true == self._ui._battlePoint._staticBG_TierTotal:GetShow() then
    self._ui._battlePoint._staticBG_TierTotal:SetPosY(posY)
    sizeY = self._ui._battlePoint._staticBG_TierTotal:GetSizeY()
    posY = posY + sizeY + 10
  end
  if true == self._ui._battlePoint._staticBG_CurrentTier:GetShow() then
    self._ui._battlePoint._staticBG_CurrentTier:SetPosY(posY)
    sizeY = self._ui._battlePoint._staticBG_CurrentTier:GetSizeY()
    posY = posY + sizeY + 5
  end
  if true == self._ui._battlePoint._staticBG_BonusStat:GetShow() then
    self._ui._battlePoint._staticBG_BonusStat:SetPosY(posY)
    sizeY = self._ui._battlePoint._staticBG_BonusStat:GetSizeY()
    posY = posY + sizeY + 5
  end
  self._ui._battlePoint._staticText_Desc2:SetPosY(posY + 5)
  self._ui._battlePoint._staticText_Desc2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEPOINT_DESC2"))
  posY = posY + self._ui._battlePoint._staticText_Desc2:GetTextSizeY()
  if true == self._ui._battlePoint._staticText_Desc:GetShow() then
    self._ui._battlePoint._staticText_Desc:SetPosY(posY + 5)
    sizeY = self._ui._battlePoint._staticText_Desc:GetSizeY()
    posY = posY + sizeY
  end
  self._panel:SetSize(self._panel:GetSizeX(), posY + 10)
  self:SetPos()
end
function PaGlobal_Tooltip_BattlePoint:equipPointUIPos()
  self._ui._battlePoint._title:SetShow(false)
  self._ui._battlePoint._partLine:SetShow(false)
  self._ui._battlePoint._staticBG_TierTotal:SetShow(false)
  self._ui._battlePoint._staticBG_CurrentTier:SetShow(false)
  self._ui._battlePoint._staticBG_BonusStat:SetShow(false)
  self._ui._battlePoint._staticText_Desc:SetShow(false)
  self._ui._battlePoint._staticText_Desc2:SetShow(true)
  for _, control in pairs(self._ui._equipPoint) do
    control:SetShow(true)
  end
  if false == awakenWeaponContentsOpen then
    self._ui._battlePoint._staticText_AwakenAttackTitle:SetShow(false)
    self._ui._battlePoint._staticText_AwakenAttackValue:SetShow(false)
    self._ui._equipPoint._staticText_EquipAwakenAttackValue:SetShow(false)
    self._ui._equipPoint._staticText_EquipAwakenAttackTitle:SetShow(false)
  end
  local posY = 5
  self._ui._equipPoint._equipTitle:SetPosY(posY)
  self._ui._equipPoint._equipLine:SetPosY(posY + 25)
  posY = posY + 45
  if true == self._ui._equipPoint._equip_BonusStat:GetShow() then
    self._ui._equipPoint._equip_BonusStat:SetPosY(posY)
    sizeY = self._ui._equipPoint._equip_BonusStat:GetSizeY()
    posY = posY + sizeY + 5
  end
  self._ui._battlePoint._staticText_Desc2:SetPosY(posY + 5)
  self._ui._battlePoint._staticText_Desc2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_EQUIPTOOLTIP"))
  posY = posY + self._ui._battlePoint._staticText_Desc2:GetTextSizeY()
  self._panel:SetSize(self._panel:GetSizeX(), posY + 10)
  self:SetPos()
end
function PaGlobal_Tooltip_BattlePoint:updateData()
  local ui = PaGlobal_Tooltip_BattlePoint._ui
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local totalStat = math.floor(selfPlayer:get():getTotalStatValue())
  local offenceValue = ToClient_getOffence()
  local defenceValue = ToClient_getDefence()
  local awakenOffenceValue = ToClient_getAwakenOffence()
  local addedOffence = ToClient_GetAddedOffenceFromStat(totalStat)
  local addedAwakenOffence = ToClient_GetAddedOffenceFromStat(totalStat)
  local addedDefenceRate = math.floor(ToClient_GetAddedDefenceRateFromDefencePoint(defenceValue) / 10000)
  local equipAddOffence = ToClient_GetDDBonus(offenceValue)
  local equipAddedAwakenOffence = ToClient_GetDDBonus(awakenOffenceValue)
  local addedDefence = ToClient_GetAddedDefenceFromStat(totalStat)
  local isSetAwakenWeapon = ToClient_getEquipmentItem(CppEnums.EquipSlotNo.awakenWeapon)
  if nil == isSetAwakenWeapon then
    addedAwakenOffence = 0
  end
  ui._battlePoint._staticText_AttackValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_OFFENCE_VALUE", "value", addedOffence))
  ui._battlePoint._staticText_AwakenAttackValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_AWAKENOFFENCE_VALUE", "value", addedAwakenOffence))
  ui._battlePoint._staticText_DefenceValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_DEFENCE_VALUE", "value", addedDefence))
  ui._equipPoint._staticText_EquipAttackValue:SetText(offenceValue .. " (" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_OFFENCE_VALUE", "value", equipAddOffence) .. ")")
  ui._equipPoint._staticText_EquipAwakenAttackValue:SetText(awakenOffenceValue .. " (" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_AWAKENOFFENCE_VALUE", "value", equipAddedAwakenOffence) .. ")")
  ui._equipPoint._staticText_EquipReduceRateValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ADDED_DEFENCERATE_VALUE", "value", addedDefenceRate))
  ui._equipPoint._staticText_EquipHitValue:SetText(ToClient_getHit())
  ui._equipPoint._staticText_EquipHDVValue:SetText(PaGlobal_EquipHDV())
  ui._equipPoint._staticText_EquipHPVValue:SetText(PaGlobal_EquipHPV())
end
local EquipNoMin = CppEnums.EquipSlotNo.rightHand
local EquipNoMax = CppEnums.EquipSlotNo.equipSlotNoCount
function PaGlobal_EquipHDV()
  local totalDv, totalHdv, valueString = 0, 0, nil
  for equipNo = EquipNoMin, EquipNoMax do
    local itemWrapper = ToClient_getEquipmentItem(equipNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local item_type = itemSSW:getItemType()
      local dv, hdv = 0, 0
      if 1 == item_type then
        for idx = 0, 2 do
          local currnetDv = itemSSW:ToClient_getDV(idx)
          if dv < currnetDv then
            dv = currnetDv
          end
          local currentHDV = itemSSW:ToClient_getHDV(idx)
          if hdv < currentHDV then
            hdv = currentHDV
          end
        end
      end
      local cronKey = itemSSW:getCronKey()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local gradeCount = ToClient_GetCronEnchnatInfoCount(cronKey, enchantLevel)
      local lastCount = 0
      local currentGrade = 0
      local lastIndex = gradeCount - 1
      local currentEnchantFailCount = itemWrapper:getCronEnchantFailCount()
      if currentEnchantFailCount > 0 and gradeCount > 0 then
        local itemaddedDV = itemWrapper:getAddedDV()
        local itemaddedHDV = itemWrapper:getCronHDV()
        dv = dv + itemaddedDV
        hdv = hdv + itemaddedHDV
      end
      totalDv = totalDv + dv
      totalHdv = totalHdv + hdv
    end
  end
  valueString = ToClient_getDv()
  if totalHdv > 0 then
    valueString = valueString .. " (+" .. totalHdv .. ")"
  end
  return valueString
end
function PaGlobal_EquipHPV()
  local totalPv, totalHpv, valueString = 0, 0, nil
  for equipNo = EquipNoMin, EquipNoMax do
    local itemWrapper = ToClient_getEquipmentItem(equipNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local item_type = itemSSW:getItemType()
      local pv, hpv = 0, 0
      if 1 == item_type then
        for idx = 0, 2 do
          local currnetPv = itemSSW:ToClient_getPV(idx)
          if pv < currnetPv then
            pv = currnetPv
          end
          local currentHPV = itemSSW:ToClient_getHPV(idx)
          if hpv < currentHPV then
            hpv = currentHPV
          end
        end
      end
      local cronKey = itemSSW:getCronKey()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local gradeCount = ToClient_GetCronEnchnatInfoCount(cronKey, enchantLevel)
      local lastCount = 0
      local currentGrade = 0
      local lastIndex = gradeCount - 1
      local currentEnchantFailCount = itemWrapper:getCronEnchantFailCount()
      if currentEnchantFailCount > 0 and gradeCount > 0 then
        local itemaddedPV = itemWrapper:getAddedPV()
        local itemaddedHPV = itemWrapper:getCronHPV()
        pv = pv + itemaddedPV
        hpv = hpv + itemaddedHPV
      end
      totalPv = totalPv + pv
      totalHpv = totalHpv + hpv
    end
  end
  valueString = ToClient_getPv()
  if totalHpv > 0 then
    valueString = valueString .. " (+" .. totalHpv .. ")"
  end
  return valueString
end
function PaGlobal_Tooltip_BattlePoint:show(showFlag)
  if self._panel:GetShow() == showFlag then
    return false
  end
  self._panel:SetShow(showFlag, showFlag)
  if showFlag then
    self._isDetail = false
    self:updateUIPos()
    self:updateData()
    self:updateCurrnetTier()
  end
  return true
end
function PaGlobal_Tooltip_BattlePoint:toggleDetail()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._isDetail = not self._isDetail
  self:updateUIPos()
  self:updateData()
  self:updateCurrnetTier()
end
function FGlobal_EquipmentEffectTooltip(isShow)
  local self = PaGlobal_Tooltip_BattlePoint
  self._panel:SetShow(isShow)
  if not isShow then
    return
  end
  self:equipPointUIPos()
  self:updateData()
end
function Fglobal_Init_Tooltip_BattlePoint()
  local ui = PaGlobal_Tooltip_BattlePoint._ui
  Panel_Tooltip_BattlePoint:SetShow(false, false)
  local highTierTitle = {
    "StaticText_IconTitle1",
    "StaticText_IconTitle2",
    "StaticText_IconTitle3"
  }
  ui._battlePoint._highTierTitles = {}
  for idx, ctrlName in ipairs(highTierTitle) do
    local control = UI.getChildControl(ui._battlePoint._staticBG_TierTotal, ctrlName)
    if nil ~= control then
      ui._battlePoint._highTierTitles[idx] = control
    end
  end
  local highTierDesc = {
    "StaticText_DescTitle1",
    "StaticText_DescTitle2",
    "StaticText_DescTitle3"
  }
  local max = 0
  local min = 0
  ui._battlePoint._highTierDesces = {}
  for idx, ctrlName in ipairs(highTierDesc) do
    local control = UI.getChildControl(ui._battlePoint._staticBG_TierTotal, ctrlName)
    if nil ~= control then
      ui._battlePoint._highTierDesces[idx] = control
      min = ToClient_GetMinTotalStatByHighTier(idx)
      local txtStatRange = ""
      if 1 == idx then
        txtStatRange = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER1", "minStat", min)
      else
        max = ToClient_GetMinTotalStatByHighTier(idx - 1) - 1
        txtStatRange = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
      end
      control:SetText(txtStatRange)
    end
  end
  local tierTitle = {
    "StaticText_IconTier1",
    "StaticText_IconTier2",
    "StaticText_IconTier3",
    "StaticText_IconTier4",
    "StaticText_IconTier5",
    "StaticText_IconTier6",
    "StaticText_IconTier7",
    "StaticText_IconTier8"
  }
  ui._battlePoint._tierTitles = {}
  for idx, ctrlName in ipairs(tierTitle) do
    local control = UI.getChildControl(ui._battlePoint._staticBG_TierTotal, ctrlName)
    if nil ~= control then
      ui._battlePoint._tierTitles[idx] = control
    end
  end
  local tierDesc = {
    "StaticText_DescTier1",
    "StaticText_DescTier2",
    "StaticText_DescTier3",
    "StaticText_DescTier4",
    "StaticText_DescTier5",
    "StaticText_DescTier6",
    "StaticText_DescTier7",
    "StaticText_DescTier8"
  }
  ui._battlePoint._tierDesces = {}
  local tierRangeText = ""
  for idx, ctrlName in ipairs(tierDesc) do
    local control = UI.getChildControl(ui._battlePoint._staticBG_TierTotal, ctrlName)
    if nil ~= control then
      ui._battlePoint._tierDesces[idx] = control
      min = ToClient_GetMinTotalStatByTier(idx)
      if true == _ContentsGroup_StatTierIcon then
        if 1 == idx then
          max = ToClient_GetMinTotalStatByHighTier(ToClient_GetHighTierCount()) - 1
        else
          max = ToClient_GetMinTotalStatByTier(idx - 1) - 1
        end
        tierRangeText = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
      elseif 1 == idx then
        tierRangeText = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER1", "minStat", min)
      else
        max = ToClient_GetMinTotalStatByTier(idx - 1) - 1
        tierRangeText = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
      end
      control:SetText(tierRangeText)
    end
  end
  ui._battlePoint._currentGradeBg = UI.getChildControl(ui._battlePoint._staticBG_TierTotal, "Static_CurrentGradeBg")
  ui._battlePoint._staticBG_TierTotal:SetSize(ui._battlePoint._staticBG_TierTotal:GetSizeX(), ui._battlePoint._staticBG_TierTotal:GetSizeY() - 50)
  ui._battlePoint._staticIcon_CurrentTier = UI.getChildControl(ui._battlePoint._staticBG_CurrentTier, "StaticText_IconTitle")
  ui._battlePoint._staticText_CurrentTier = UI.getChildControl(ui._battlePoint._staticBG_CurrentTier, "StaticText_DescTitle")
  ui._battlePoint._staticText_AttackValue = UI.getChildControl(ui._battlePoint._staticBG_BonusStat, "StaticText_AttackValue")
  ui._battlePoint._staticText_AwakenAttackValue = UI.getChildControl(ui._battlePoint._staticBG_BonusStat, "StaticText_AwakenAttackValue")
  ui._battlePoint._staticText_DefenceValue = UI.getChildControl(ui._battlePoint._staticBG_BonusStat, "StaticText_DefenceValue")
  ui._battlePoint._staticText_AwakenAttackTitle = UI.getChildControl(ui._battlePoint._staticBG_BonusStat, "StaticText_AwakenAttackTitle")
  ui._battlePoint._staticText_DefenceTitle = UI.getChildControl(ui._battlePoint._staticBG_BonusStat, "StaticText_DefenceTitle")
  ui._equipPoint._staticText_EquipAttackValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_AttackValue")
  ui._equipPoint._staticText_EquipAwakenAttackValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_AwakenAttackValue")
  ui._equipPoint._staticText_EquipHitValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HitValue")
  ui._equipPoint._staticText_EquipHDVValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HDVValue")
  ui._equipPoint._staticText_EquipHPVValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HPVValue")
  ui._equipPoint._staticText_EquipReduceRateValue = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_ReduceValue")
  ui._equipPoint._staticText_EquipAwakenAttackTitle = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_AwakenAttackTitle")
  ui._equipPoint._staticText_EquipHitTitle = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HitTitle")
  ui._equipPoint._staticText_EquipHDVTitle = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HDVTitle")
  ui._equipPoint._staticText_EquipHPVTitle = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_HPVTitle")
  ui._equipPoint._staticText_EquipReduceTitle = UI.getChildControl(ui._equipPoint._equip_BonusStat, "StaticText_ReduceTitle")
  if false == _ContentsGroup_StatTierIcon then
    for _, control in ipairs(ui._battlePoint._highTierTitles) do
      control:SetShow(false)
    end
    for _, control in ipairs(ui._battlePoint._highTierDesces) do
      control:SetShow(false)
    end
    for _, control in ipairs(ui._battlePoint._tierTitles) do
      control:SetPosY(control:GetPosY() - 80)
    end
    for _, control in ipairs(ui._battlePoint._tierDesces) do
      control:SetPosY(control:GetPosY() - 80)
    end
    ui._battlePoint._staticBG_TierTotal:SetSize(ui._battlePoint._staticBG_TierTotal:GetSizeX(), ui._battlePoint._staticBG_TierTotal:GetSizeY() - 80)
  end
  if false == awakenWeaponContentsOpen then
    ui._battlePoint._staticText_AwakenAttackTitle:SetShow(false)
    ui._battlePoint._staticText_AwakenAttackValue:SetShow(false)
    ui._battlePoint._staticText_DefenceTitle:SetPosY(ui._battlePoint._staticText_DefenceTitle:GetPosY() - 20)
    ui._battlePoint._staticText_DefenceValue:SetPosY(ui._battlePoint._staticText_DefenceValue:GetPosY() - 20)
    ui._equipPoint._staticText_EquipAwakenAttackValue:SetShow(false)
    ui._equipPoint._staticText_EquipAwakenAttackTitle:SetShow(false)
    ui._equipPoint._staticText_EquipHitTitle:SetPosY(ui._equipPoint._staticText_EquipHitTitle:GetPosY() - 20)
    ui._equipPoint._staticText_EquipHitValue:SetPosY(ui._equipPoint._staticText_EquipHitValue:GetPosY() - 20)
    ui._equipPoint._staticText_EquipHDVTitle:SetPosY(ui._equipPoint._staticText_EquipHDVTitle:GetPosY() - 20)
    ui._equipPoint._staticText_EquipHDVValue:SetPosY(ui._equipPoint._staticText_EquipHDVValue:GetPosY() - 20)
    ui._equipPoint._staticText_EquipHPVTitle:SetPosY(ui._equipPoint._staticText_EquipHPVTitle:GetPosY() - 20)
    ui._equipPoint._staticText_EquipHPVValue:SetPosY(ui._equipPoint._staticText_EquipHPVValue:GetPosY() - 20)
    ui._equipPoint._staticText_EquipReduceTitle:SetPosY(ui._equipPoint._staticText_EquipReduceTitle:GetPosY() - 20)
    ui._equipPoint._staticText_EquipReduceRateValue:SetPosY(ui._equipPoint._staticText_EquipReduceRateValue:GetPosY() - 20)
    ui._equipPoint._equip_BonusStat:SetSize(ui._equipPoint._equip_BonusStat:GetSizeX(), 120)
  end
  PaGlobal_Tooltip_BattlePoint._isInit = true
end
function PaGlobal_Tooltip_BattlePoint:updateCurrnetTier()
  local selfPlayer = getSelfPlayer()
  local tierRangeText = ""
  if nil == selfPlayer then
    return
  end
  local totalStatValue = math.floor(selfPlayer:getTotalStatValue())
  if true == _ContentsGroup_StatTierIcon then
    local highTier = ToClient_GetHighTierByTotalStat(totalStatValue)
    if highTier >= 1 and highTier <= ToClient_GetHighTierCount() then
      self:updateCurrentHighTier(highTier, totalStatValue)
      return
    end
  end
  local tier = ToClient_GetTier(totalStatValue)
  if -1 == tier then
    _PA_ASSERT(false, "Panel_Tooltip_BattlePoint.lua : \237\139\176\236\150\180 \236\160\149\235\179\180\234\176\128 \236\158\152\235\170\187 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. \234\176\128\236\158\165 \235\130\174\236\157\128 \237\139\176\236\150\180\235\161\156 \235\179\128\237\153\152\237\149\169\235\139\136\235\139\164.")
    tier = 8
  end
  local tierName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOTALSTAT_TIERNAME_" .. tier, "totalStat", totalStatValue)
  self._ui._battlePoint._staticIcon_CurrentTier:SetText(tierName)
  setTierIcon(self._ui._battlePoint._staticIcon_CurrentTier, "new_ui_common_forlua/default/Default_Etc_04.dds", 8 - tier, 354, 99, 4, 24)
  local min = ToClient_GetMinTotalStatByTier(tier)
  local max = 0
  if true == _ContentsGroup_StatTierIcon then
    if 1 == tier then
      max = ToClient_GetMinTotalStatByHighTier(ToClient_GetHighTierCount()) - 1
    else
      max = ToClient_GetMinTotalStatByTier(tier - 1) - 1
    end
    tierRangeText = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
  elseif 1 == tier then
    tierRangeText = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER1", "minStat", min)
  else
    max = ToClient_GetMinTotalStatByTier(tier - 1) - 1
    tierRangeText = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
  end
  self._ui._battlePoint._staticText_CurrentTier:SetText(tierRangeText)
  alignCurrentTierBg(self._ui._battlePoint._currentGradeBg, self._ui._battlePoint._tierTitles[tier])
end
function PaGlobal_Tooltip_BattlePoint:updateCurrentHighTier(highTier, totalStatValue)
  local tierName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOTALSTAT_HIGHTIERNAME_" .. highTier, "totalStat", totalStatValue)
  self._ui._battlePoint._staticIcon_CurrentTier:SetText(tierName)
  setTierIcon(self._ui._battlePoint._staticIcon_CurrentTier, "new_ui_common_forlua/default/Default_Etc_04.dds", 3 - highTier, 225, 142, 3, 42)
  local tierRangeText = ""
  local min = ToClient_GetMinTotalStatByHighTier(highTier)
  if 1 == highTier then
    tierRangeText = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER1", "minStat", min)
  else
    local max = ToClient_GetMinTotalStatByHighTier(highTier - 1) - 1
    tierRangeText = PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_BATTLEPOINT_TIER", "minStat", min, "maxStat", max)
  end
  self._ui._battlePoint._staticText_CurrentTier:SetText(tierRangeText)
  alignCurrentTierBg(self._ui._battlePoint._currentGradeBg, self._ui._battlePoint._highTierTitles[highTier])
end
function FGlobal_EquipmentUpdate()
  if false == PaGlobal_Tooltip_BattlePoint._isInit then
    _PA_ASSERT(false, "Panel_Tooltip_BattlePoint.lua : \236\180\136\234\184\176\237\153\148 \236\160\132\236\151\144 \236\151\133\235\141\176\236\157\180\237\138\184\235\165\188 \237\152\184\236\182\156\237\150\136\236\138\181\235\139\136\235\139\164. \235\172\180\236\139\156\237\149\169\235\139\136\235\139\164.")
    return
  end
  PaGlobal_Tooltip_BattlePoint:updateCurrnetTier()
  PaGlobal_Tooltip_BattlePoint:updateData()
end
registerEvent("FromClient_luaLoadComplete", "Fglobal_Init_Tooltip_BattlePoint")
registerEvent("EventEquipmentUpdate", "FGlobal_EquipmentUpdate")
