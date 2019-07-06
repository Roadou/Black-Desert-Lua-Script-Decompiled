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
  _dropItemRateText = UI.getChildControl(Panel_Potencial_Up, "StaticText_Potencial_DropItemRate")
}
function Poten_Resize()
  for _, control in pairs(Poten_UI) do
    control:ComputePos()
  end
end
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
      elseif 1 == i then
        Poten_UI._castingSpeedText:SetShow(true)
        Poten_UI._castingSpeedText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._castingSpeedText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
      elseif 2 == i then
        Poten_UI._moveSpeedText:SetShow(true)
        Poten_UI._moveSpeedText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._moveSpeedText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
      elseif 3 == i then
        Poten_UI._criticalRateText:SetShow(true)
        Poten_UI._criticalRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._criticalRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
      elseif 4 == i then
        Poten_UI._fishingRateText:SetShow(true)
        Poten_UI._fishingRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._fishingRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
      elseif 5 == i then
        Poten_UI._gatheringRateText:SetShow(true)
        Poten_UI._gatheringRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._gatheringRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
      elseif 6 == i then
        Poten_UI._dropItemRateText:SetShow(true)
        Poten_UI._dropItemRateText:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_FULL_MSG", "title", titleTable[i], "potenStep", potenUpgrade, "maxPoten", maxPotencial[i]))
        Poten_UI._dropItemRateText:SetPosY(Poten_UI._attackSpeedText:GetPosY() + gap * potenCount)
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
Max_Potencial()
Panel_Potencial_Up:RegisterUpdateFunc("Potencial_Up_Update_ShowFunction")
registerEvent("FromClient_UpdateSelfPlayerStatPoint", "Current_Poten_Update")
