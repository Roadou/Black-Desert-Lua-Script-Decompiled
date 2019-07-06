local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_Potencial_Up:SetShow(false, false)
Panel_Potencial_Up:setGlassBackground(true)
Panel_Potencial_Up:SetSize(getScreenSizeX(), Panel_Potencial_Up:GetSizeY())
Panel_Potencial_Up:ComputePos()
Panel_Potencial_Up:RegisterShowEventFunc(true, "Potencial_UpShowAni()")
Panel_Potencial_Up:RegisterShowEventFunc(false, "Potencial_UpHideAni()")
local Poten_UI = {
  _arcText = UI.getChildControl(Panel_Potencial_Up, "ArchiveText"),
  _titleText = UI.getChildControl(Panel_Potencial_Up, "TitleText"),
  _iconBack = UI.getChildControl(Panel_Potencial_Up, "IconBack"),
  _iconImage = UI.getChildControl(Panel_Potencial_Up, "IconSlot"),
  _iconEtc = UI.getChildControl(Panel_Potencial_Up, "IconEtc"),
  _iconGrade = UI.getChildControl(Panel_Potencial_Up, "IconGrade"),
  _attackSpeedText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_AttackSpeed"),
  _castingSpeedText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_CastingSpeed"),
  _moveSpeedText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_MoveSpeed"),
  _criticalRateText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_CriticalRate"),
  _fishingRateText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_FishingRate"),
  _gatheringRateText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_GatheringRate"),
  _dropItemRateText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_DropItemRate"),
  _potentialSlot = UI.getChildControl(Panel_Potencial_Up, "Static_PotentialSlot"),
  _potentialMinusSlot = UI.getChildControl(Panel_Potencial_Up, "Static_PotentialMinusSlot"),
  _potentialSlotBG = UI.getChildControl(Panel_Potencial_Up, "Static_PotentialSlotBG")
}
function Poten_Resize()
  for _, control in pairs(Poten_UI) do
    control:ComputePos()
  end
end
local Potential_UI = {
  attackspeed_SlotBG = {},
  attackspeed_Slot = {},
  attackspeed_MinusSlot = {},
  castspeed_SlotBG = {},
  castspeed_Slot = {},
  castspeed_MinusSlot = {},
  movespeed_SlotBG = {},
  movespeed_Slot = {},
  movespeed_MinusSlot = {},
  critical_SlotBG = {},
  critical_Slot = {},
  critical_MinusSlot = {},
  fishTime_SlotBG = {},
  fishTime_Slot = {},
  fishTime_MinusSlot = {},
  product_SlotBG = {},
  product_Slot = {},
  product_MinusSlot = {},
  dropChance_SlotBG = {},
  dropChance_Slot = {},
  dropChance_MinusSlot = {}
}
local titleTable = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_1"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_2"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_3"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_4"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_5"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_6"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_7")
}
local currentPotencial = {}
local maxPotencial = {}
local _titleText = {}
local _potenText = {}
local _potenProgress = {}
local currTime = 0
local potenMaxNo = 7
function Potencial_UpShowAni()
  Panel_Potencial_Up:ChangeSpecialTextureInfoName("new_ui_common_forlua/Default/Mask_MidHorizon.dds")
  local FadeMaskAni = Panel_Potencial_Up:addTextureUVAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0, 0)
  FadeMaskAni:SetEndUV(0.6, 0, 0)
  FadeMaskAni:SetStartUV(1, 0, 1)
  FadeMaskAni:SetEndUV(0.4, 0, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0.6, 1, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0.4, 1, 3)
  FadeMaskAni.IsChangeChild = true
end
function Potencial_UpHideAni()
  UIAni.closeAni(Panel_Potencial_Up)
end
function Current_Poten_Update()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local playerGet = player:get()
  local UI_classType = CppEnums.ClassType
  local potentialType = {
    move = 0,
    attack = 1,
    cast = 2,
    levelText = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TEXT_POTENLEVEL")
  }
  local currentAttackSpeedPoint = player:characterStatPointSpeed(potentialType.attack)
  local limitAttackSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.attack)
  if currentAttackSpeedPoint > limitAttackSpeedPoint then
    currentAttackSpeedPoint = limitAttackSpeedPoint
  end
  currentPotencial[0] = currentAttackSpeedPoint - 5
  local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
  local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
  if currentCastingSpeedPoint > limitCastingSpeedPoint then
    currentCastingSpeedPoint = limitCastingSpeedPoint
  end
  currentPotencial[1] = currentCastingSpeedPoint - 5
  local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
  local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
  if currentMoveSpeedPoint > limitMoveSpeedPoint then
    currentMoveSpeedPoint = limitMoveSpeedPoint
  end
  currentPotencial[2] = currentMoveSpeedPoint - 5
  local currentCriticalRatePoint = player:characterStatPointCritical()
  local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
  if currentCriticalRatePoint > limitCriticalRatePoint then
    currentCriticalRatePoint = limitCriticalRatePoint
  end
  currentPotencial[3] = currentCriticalRatePoint
  local currentFishingRatePoint = player:getCharacterStatPointFishing()
  local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
  if currentFishingRatePoint > limitFishingRatePoint then
    currentFishingRatePoint = limitFishingRatePoint
  end
  currentPotencial[4] = currentFishingRatePoint
  local currentProductRatePoint = player:getCharacterStatPointCollection()
  local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
  if currentProductRatePoint > limitProductRatePoint then
    currentProductRatePoint = limitProductRatePoint
  end
  currentPotencial[5] = currentProductRatePoint
  local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
  local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
  if currentDropItemRatePoint > limitDropItemRatePoint then
    currentDropItemRatePoint = limitDropItemRatePoint
  end
  currentPotencial[6] = currentDropItemRatePoint
  Compare_Potencial(currentPotencial)
end
function Compare_Potencial(currentPotencial)
  local potenCheck = false
  for i = 0, #currentPotencial do
    if currentPotencial[i] > maxPotencial[i] then
      potenCheck = true
    end
  end
  if true == potenCheck then
    Potencial_Init()
  end
  local potenCount = 0
  local title
  local gap = 60
  local potentialType = {
    move = 0,
    attack = 1,
    cast = 2
  }
  for i = 0, #currentPotencial do
    if tonumber(currentPotencial[i]) > tonumber(maxPotencial[i]) then
      local potenUpgrade = tonumber(currentPotencial[i]) - tonumber(maxPotencial[i])
      maxPotencial[i] = currentPotencial[i]
      if 0 == i then
        Poten_UI._attackSpeedText:SetShow(true)
        Poten_UI._attackSpeedText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._attackSpeedText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.attackspeed_SlotBG[Idx]:SetPosY(Poten_UI._attackSpeedText:GetPosY() + 28)
          Potential_UI.attackspeed_Slot[Idx]:SetPosY(Poten_UI._attackSpeedText:GetPosY() + 29)
          Potential_UI.attackspeed_MinusSlot[Idx]:SetPosY(Poten_UI._attackSpeedText:GetPosY() + 29)
        end
        local maxAttackSpeedPoint = getSelfPlayer():characterStatPointLimitedSpeed(potentialType.attack) - 5
        for bg_Idx = 0, maxAttackSpeedPoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedAttackSpeedPoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedAttackSpeedPoint - 1 do
          end
        end
      elseif 1 == i then
        Poten_UI._castingSpeedText:SetShow(true)
        Poten_UI._castingSpeedText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._castingSpeedText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.castspeed_SlotBG[Idx]:SetPosY(Poten_UI._castingSpeedText:GetPosY() + 28)
          Potential_UI.castspeed_Slot[Idx]:SetPosY(Poten_UI._castingSpeedText:GetPosY() + 29)
          Potential_UI.castspeed_MinusSlot[Idx]:SetPosY(Poten_UI._castingSpeedText:GetPosY() + 29)
        end
        local maxCastingSpeedPoint = getSelfPlayer():characterStatPointLimitedSpeed(potentialType.cast) - 5
        for bg_Idx = 0, maxCastingSpeedPoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedCastingSpeedPoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedCastingSpeedPoint - 1 do
          end
        end
      elseif 2 == i then
        Poten_UI._moveSpeedText:SetShow(true)
        Poten_UI._moveSpeedText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._moveSpeedText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.movespeed_SlotBG[Idx]:SetPosY(Poten_UI._moveSpeedText:GetPosY() + 28)
          Potential_UI.movespeed_Slot[Idx]:SetPosY(Poten_UI._moveSpeedText:GetPosY() + 29)
          Potential_UI.movespeed_MinusSlot[Idx]:SetPosY(Poten_UI._moveSpeedText:GetPosY() + 29)
        end
        local maxMoveSpeedPoint = getSelfPlayer():characterStatPointLimitedSpeed(potentialType.move) - 5
        for bg_Idx = 0, maxMoveSpeedPoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedMoveSpeedPoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedMoveSpeedPoint - 1 do
          end
        end
      elseif 3 == i then
        Poten_UI._criticalRateText:SetShow(true)
        Poten_UI._criticalRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._criticalRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.critical_SlotBG[Idx]:SetPosY(Poten_UI._criticalRateText:GetPosY() + 28)
          Potential_UI.critical_Slot[Idx]:SetPosY(Poten_UI._criticalRateText:GetPosY() + 29)
          Potential_UI.critical_MinusSlot[Idx]:SetPosY(Poten_UI._criticalRateText:GetPosY() + 29)
        end
        local maxCriticalRatePoint = getSelfPlayer():characterStatPointLimitedCritical()
        for bg_Idx = 0, maxCriticalRatePoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedCriticalRatePoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedCriticalRatePoint - 1 do
          end
        end
      elseif 4 == i then
        Poten_UI._fishingRateText:SetShow(true)
        Poten_UI._fishingRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._fishingRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.fishTime_SlotBG[Idx]:SetPosY(Poten_UI._fishingRateText:GetPosY() + 28)
          Potential_UI.fishTime_Slot[Idx]:SetPosY(Poten_UI._fishingRateText:GetPosY() + 29)
          Potential_UI.fishTime_MinusSlot[Idx]:SetPosY(Poten_UI._fishingRateText:GetPosY() + 29)
        end
        local maxFishingRatePoint = getSelfPlayer():getCharacterStatPointLimitedFishing()
        for bg_Idx = 0, maxFishingRatePoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedFishingRatePoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedFishingRatePoint - 1 do
          end
        end
      elseif 5 == i then
        Poten_UI._gatheringRateText:SetShow(true)
        Poten_UI._gatheringRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._gatheringRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.product_SlotBG[Idx]:SetPosY(Poten_UI._gatheringRateText:GetPosY() + 28)
          Potential_UI.product_Slot[Idx]:SetPosY(Poten_UI._gatheringRateText:GetPosY() + 29)
          Potential_UI.product_MinusSlot[Idx]:SetPosY(Poten_UI._gatheringRateText:GetPosY() + 29)
        end
        local maxProductRatePoint = getSelfPlayer():getCharacterStatPointLimitedCollection()
        for bg_Idx = 0, maxProductRatePoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedProductRatePoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedProductRatePoint - 1 do
          end
        end
      elseif 6 == i then
        Poten_UI._dropItemRateText:SetShow(true)
        Poten_UI._dropItemRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._dropItemRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
        for Idx = 0, potenMaxNo - 1 do
          Potential_UI.dropChance_SlotBG[Idx]:SetPosY(Poten_UI._dropItemRateText:GetPosY() + 28)
          Potential_UI.dropChance_Slot[Idx]:SetPosY(Poten_UI._dropItemRateText:GetPosY() + 29)
          Potential_UI.dropChance_MinusSlot[Idx]:SetPosY(Poten_UI._dropItemRateText:GetPosY() + 29)
        end
        local maxDropItemRatePoint = getSelfPlayer():getCharacterStatPointLimitedDropItem()
        for bg_Idx = 0, maxDropItemRatePoint - 1 do
        end
        if maxPotencial[i] > 0 then
          for slot_Idx = 0, maxPotencial[i] - 1 do
          end
        else
          local minus_equipedDropItemRatePoint = -maxPotencial[i]
          for slot_Idx = 0, minus_equipedDropItemRatePoint - 1 do
          end
        end
      end
      if nil ~= title then
        title = tostring(title .. " / " .. titleTable[i])
      else
        title = titleTable[i]
      end
      potenCount = potenCount + 1
    end
  end
  if potenCount > 0 then
    Panel_Potencial_Up:SetShow(true, true)
    Poten_UI._arcText:SetText(title)
    Poten_UI._arcText:SetShow(true)
    Poten_UI._titleText:SetShow(true)
    Poten_UI._iconBack:SetShow(true)
    Poten_UI._iconImage:SetShow(true)
    Poten_UI._iconEtc:SetShow(true)
    Poten_UI._iconGrade:SetShow(true)
    currTime = 0
  end
  Max_Potencial()
end
local potenLimit = {}
function Max_Potencial()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local potentialType = {
    move = 0,
    attack = 1,
    cast = 2
  }
  local currentAttackSpeedPoint = player:characterStatPointSpeed(potentialType.attack)
  local limitAttackSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.attack)
  if currentAttackSpeedPoint > limitAttackSpeedPoint then
    currentAttackSpeedPoint = limitAttackSpeedPoint
  end
  local equipedAttackSpeedPoint = currentAttackSpeedPoint - 5
  local maxAttackSpeedPoint = limitAttackSpeedPoint - 5
  maxPotencial[0] = equipedAttackSpeedPoint
  potenLimit[0] = maxAttackSpeedPoint
  local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
  local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
  if currentCastingSpeedPoint > limitCastingSpeedPoint then
    currentCastingSpeedPoint = limitCastingSpeedPoint
  end
  local equipedCastingSpeedPoint = currentCastingSpeedPoint - 5
  local maxCastingSpeedPoint = limitCastingSpeedPoint - 5
  maxPotencial[1] = equipedCastingSpeedPoint
  potenLimit[1] = maxCastingSpeedPoint
  local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
  local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
  if currentMoveSpeedPoint > limitMoveSpeedPoint then
    currentMoveSpeedPoint = limitMoveSpeedPoint
  end
  local equipedMoveSpeedPoint = currentMoveSpeedPoint - 5
  local maxMoveSpeedPoint = limitMoveSpeedPoint - 5
  maxPotencial[2] = equipedMoveSpeedPoint
  potenLimit[2] = maxMoveSpeedPoint
  local currentCriticalRatePoint = player:characterStatPointCritical()
  local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
  if currentCriticalRatePoint > limitCriticalRatePoint then
    currentCriticalRatePoint = limitCriticalRatePoint
  end
  local equipedCriticalRatePoint = currentCriticalRatePoint
  local maxCriticalRatePoint = limitCriticalRatePoint
  maxPotencial[3] = equipedCriticalRatePoint
  potenLimit[3] = maxCriticalRatePoint
  local currentFishingRatePoint = player:getCharacterStatPointFishing()
  local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
  if currentFishingRatePoint > limitFishingRatePoint then
    currentFishingRatePoint = limitFishingRatePoint
  end
  local equipedFishingRatePoint = currentFishingRatePoint
  local maxFishingRatePoint = limitFishingRatePoint
  maxPotencial[4] = equipedFishingRatePoint
  potenLimit[4] = maxFishingRatePoint
  local currentProductRatePoint = player:getCharacterStatPointCollection()
  local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
  if currentProductRatePoint > limitProductRatePoint then
    currentProductRatePoint = limitProductRatePoint
  end
  local equipedProductRatePoint = currentProductRatePoint
  local maxProductRatePoint = limitProductRatePoint
  maxPotencial[5] = equipedProductRatePoint
  potenLimit[5] = maxProductRatePoint
  local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
  local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
  if currentDropItemRatePoint > limitDropItemRatePoint then
    currentDropItemRatePoint = limitDropItemRatePoint
  end
  local equipedDropItemRatePoint = currentDropItemRatePoint
  local maxDropItemRatePoint = limitDropItemRatePoint
  maxPotencial[6] = equipedDropItemRatePoint
  potenLimit[6] = maxDropItemRatePoint
end
function Potencial_Init()
  Panel_Potencial_Up:SetShow(false, false)
  for _, control in pairs(Poten_UI) do
    control:SetShow(false)
  end
  for index = 0, potenMaxNo - 1 do
    Potential_UI.attackspeed_SlotBG[index]:SetShow(false)
    Potential_UI.attackspeed_Slot[index]:SetShow(false)
    Potential_UI.attackspeed_MinusSlot[index]:SetShow(false)
    Potential_UI.castspeed_SlotBG[index]:SetShow(false)
    Potential_UI.castspeed_Slot[index]:SetShow(false)
    Potential_UI.castspeed_MinusSlot[index]:SetShow(false)
    Potential_UI.movespeed_SlotBG[index]:SetShow(false)
    Potential_UI.movespeed_Slot[index]:SetShow(false)
    Potential_UI.movespeed_MinusSlot[index]:SetShow(false)
    Potential_UI.critical_SlotBG[index]:SetShow(false)
    Potential_UI.critical_Slot[index]:SetShow(false)
    Potential_UI.critical_MinusSlot[index]:SetShow(false)
    Potential_UI.fishTime_SlotBG[index]:SetShow(false)
    Potential_UI.fishTime_Slot[index]:SetShow(false)
    Potential_UI.fishTime_MinusSlot[index]:SetShow(false)
    Potential_UI.product_SlotBG[index]:SetShow(false)
    Potential_UI.product_Slot[index]:SetShow(false)
    Potential_UI.product_MinusSlot[index]:SetShow(false)
    Potential_UI.dropChance_SlotBG[index]:SetShow(false)
    Potential_UI.dropChance_Slot[index]:SetShow(false)
    Potential_UI.dropChance_MinusSlot[index]:SetShow(false)
  end
end
function Potential_UI:Init()
  Poten_UI._potentialSlotBG:SetSize(34, Poten_UI._potentialSlotBG:GetSizeY())
  Poten_UI._potentialSlot:SetSize(32, Poten_UI._potentialSlot:GetSizeY())
  for idx = 0, potenMaxNo - 1 do
    Potential_UI.attackspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._attackSpeedText, "attackSpeed_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.attackspeed_SlotBG[idx])
    Potential_UI.attackspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.attackspeed_SlotBG[idx]:SetPosX((Panel_Potencial_Up:GetSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.attackspeed_SlotBG[idx]:SetPosX(Potential_UI.attackspeed_SlotBG[idx - 1]:GetPosX() + Potential_UI.attackspeed_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.attackspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._attackSpeedText, "attackSpeed_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.attackspeed_Slot[idx])
    Potential_UI.attackspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.attackspeed_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.attackspeed_Slot[idx]:SetPosX(Potential_UI.attackspeed_Slot[idx - 1]:GetPosX() + Potential_UI.attackspeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.attackspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._attackSpeedText, "attackSpeed_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.attackspeed_MinusSlot[idx])
    Potential_UI.attackspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.attackspeed_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.attackspeed_MinusSlot[idx]:SetPosX(Potential_UI.attackspeed_MinusSlot[idx - 1]:GetPosX() + Potential_UI.attackspeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.castspeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._castingSpeedText, "castspeed_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.castspeed_SlotBG[idx])
    Potential_UI.castspeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.castspeed_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.castspeed_SlotBG[idx]:SetPosX(Potential_UI.castspeed_SlotBG[idx - 1]:GetPosX() + Potential_UI.castspeed_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.castspeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._castingSpeedText, "castspeed_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.castspeed_Slot[idx])
    Potential_UI.castspeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.castspeed_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.castspeed_Slot[idx]:SetPosX(Potential_UI.castspeed_Slot[idx - 1]:GetPosX() + Potential_UI.castspeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.castspeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._castingSpeedText, "castspeed_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.castspeed_MinusSlot[idx])
    Potential_UI.castspeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.castspeed_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.castspeed_MinusSlot[idx]:SetPosX(Potential_UI.castspeed_MinusSlot[idx - 1]:GetPosX() + Potential_UI.castspeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.movespeed_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._moveSpeedText, "movespeed_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.movespeed_SlotBG[idx])
    Potential_UI.movespeed_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.movespeed_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.movespeed_SlotBG[idx]:SetPosX(Potential_UI.movespeed_SlotBG[idx - 1]:GetPosX() + Potential_UI.movespeed_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.movespeed_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._moveSpeedText, "movespeed_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.movespeed_Slot[idx])
    Potential_UI.movespeed_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.movespeed_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.movespeed_Slot[idx]:SetPosX(Potential_UI.movespeed_Slot[idx - 1]:GetPosX() + Potential_UI.movespeed_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.movespeed_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._moveSpeedText, "movespeed_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.movespeed_MinusSlot[idx])
    Potential_UI.movespeed_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.movespeed_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.movespeed_MinusSlot[idx]:SetPosX(Potential_UI.movespeed_MinusSlot[idx - 1]:GetPosX() + Potential_UI.movespeed_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.critical_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._criticalRateText, "critical_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.critical_SlotBG[idx])
    Potential_UI.critical_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.critical_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.critical_SlotBG[idx]:SetPosX(Potential_UI.critical_SlotBG[idx - 1]:GetPosX() + Potential_UI.critical_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.critical_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._criticalRateText, "critical_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.critical_Slot[idx])
    Potential_UI.critical_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.critical_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.critical_Slot[idx]:SetPosX(Potential_UI.critical_Slot[idx - 1]:GetPosX() + Potential_UI.critical_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.critical_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._criticalRateText, "critical_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.critical_MinusSlot[idx])
    Potential_UI.critical_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.critical_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.critical_MinusSlot[idx]:SetPosX(Potential_UI.critical_MinusSlot[idx - 1]:GetPosX() + Potential_UI.critical_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.fishTime_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._fishingRateText, "fishTime_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.fishTime_SlotBG[idx])
    Potential_UI.fishTime_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.fishTime_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.fishTime_SlotBG[idx]:SetPosX(Potential_UI.fishTime_SlotBG[idx - 1]:GetPosX() + Potential_UI.fishTime_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.fishTime_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._fishingRateText, "fishTime_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.fishTime_Slot[idx])
    Potential_UI.fishTime_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.fishTime_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.fishTime_Slot[idx]:SetPosX(Potential_UI.fishTime_Slot[idx - 1]:GetPosX() + Potential_UI.fishTime_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.fishTime_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._fishingRateText, "fishTime_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.fishTime_MinusSlot[idx])
    Potential_UI.fishTime_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.fishTime_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.fishTime_MinusSlot[idx]:SetPosX(Potential_UI.fishTime_MinusSlot[idx - 1]:GetPosX() + Potential_UI.fishTime_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.fishTime_MinusSlot[idx]:SetPosY(18)
    Potential_UI.product_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._gatheringRateText, "product_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.product_SlotBG[idx])
    Potential_UI.product_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.product_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.product_SlotBG[idx]:SetPosX(Potential_UI.product_SlotBG[idx - 1]:GetPosX() + Potential_UI.product_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.product_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._gatheringRateText, "product_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.product_Slot[idx])
    Potential_UI.product_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.product_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.product_Slot[idx]:SetPosX(Potential_UI.product_Slot[idx - 1]:GetPosX() + Potential_UI.product_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.product_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._gatheringRateText, "product_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.product_MinusSlot[idx])
    Potential_UI.product_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.product_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.product_MinusSlot[idx]:SetPosX(Potential_UI.product_MinusSlot[idx - 1]:GetPosX() + Potential_UI.product_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.dropChance_SlotBG[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._dropItemRateText, "dropChance_SlotBG_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlotBG, Potential_UI.dropChance_SlotBG[idx])
    Potential_UI.dropChance_SlotBG[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.dropChance_SlotBG[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2)
    else
      Potential_UI.dropChance_SlotBG[idx]:SetPosX(Potential_UI.dropChance_SlotBG[idx - 1]:GetPosX() + Potential_UI.dropChance_SlotBG[idx - 1]:GetSizeX())
    end
    Potential_UI.dropChance_Slot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._dropItemRateText, "dropChance_Slot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialSlot, Potential_UI.dropChance_Slot[idx])
    Potential_UI.dropChance_Slot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.dropChance_Slot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.dropChance_Slot[idx]:SetPosX(Potential_UI.dropChance_Slot[idx - 1]:GetPosX() + Potential_UI.dropChance_Slot[idx - 1]:GetSizeX() + 2)
    end
    Potential_UI.dropChance_MinusSlot[idx] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Poten_UI._dropItemRateText, "dropChance_MinusSlot_" .. idx)
    CopyBaseProperty(Poten_UI._potentialMinusSlot, Potential_UI.dropChance_MinusSlot[idx])
    Potential_UI.dropChance_MinusSlot[idx]:SetShow(false)
    if 0 == idx then
      Potential_UI.dropChance_MinusSlot[idx]:SetPosX((getScreenSizeX() - Poten_UI._potentialSlotBG:GetSizeX() * potenMaxNo) / 2 + 1)
    else
      Potential_UI.dropChance_MinusSlot[idx]:SetPosX(Potential_UI.dropChance_MinusSlot[idx - 1]:GetPosX() + Potential_UI.dropChance_MinusSlot[idx - 1]:GetSizeX() + 2)
    end
  end
end
function Potencial_Up_Update_ShowFunction(deltaTime)
  if Panel_Acquire:IsShow() then
    Panel_Potencial_Up:SetShow(false, false)
  else
    currTime = currTime + deltaTime
  end
  if currTime > 3.5 and Panel_Potencial_Up:IsShow() == true then
    currTime = 0
    local Panel_Potencial_Up_Hide = UIAni.AlphaAnimation(0, Panel_Potencial_Up, 0, 0.3)
    Panel_Potencial_Up_Hide:SetHideAtEnd(true)
  end
end
Poten_Resize()
Potential_UI:Init()
Max_Potencial()
Panel_Potencial_Up:RegisterUpdateFunc("Potencial_Up_Update_ShowFunction")
registerEvent("FromClient_UpdateSelfPlayerStatPoint", "Current_Poten_Update")
