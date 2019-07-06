local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
Panel_Widget_PotenGradeInfo:SetShow(false)
Panel_Widget_PotenGradeInfo:SetPosX(15)
Panel_Widget_PotenGradeInfo:SetPosY(Panel_Widget_CraftLevInfo:GetPosY() - Panel_Widget_PotenGradeInfo:GetSizeY() + 10)
Panel_Widget_PotenGradeInfo:SetDragAll(true)
Panel_Widget_PotenGradeInfo:setMaskingChild(true)
Panel_Widget_PotenGradeInfo:SetDragAll(false)
Panel_Widget_PotenGradeInfo:RegisterShowEventFunc(true, "PotenGradeInfo_ShowAni()")
Panel_Widget_PotenGradeInfo:RegisterShowEventFunc(false, "PotenGradeInfo_HideAni()")
local PotenGradeInfo = {
  attackSpeed_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_AttackSpeed"),
  castingSpeed_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_CastingSpeed"),
  moveSpeed_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_MoveSpeed"),
  criticalRate_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_CriticalRate"),
  fishingRate_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_FishingRate"),
  gatheringRate_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_GatheringRate"),
  dropRate_Icon = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Static_Icon_DropRate"),
  attackSpeed_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_AttackSpeed_Gauge"),
  castingSpeed_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_CastingSpeed_Gauge"),
  moveSpeed_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_MoveSpeed_Gauge"),
  criticalRate_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_CriticalRate_Gauge"),
  fishingRate_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_FishingRate_Gauge"),
  gatheringRate_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_GatheringRate_Gauge"),
  dropRate_Progress = UI.getChildControl(Panel_Widget_PotenGradeInfo, "Progress2_DropRate_Gauge"),
  attackSpeed_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_AttackSpeed_Value"),
  castingSpeed_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_CastingSpeed_Value"),
  moveSpeed_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_MoveSpeed_Value"),
  criticalRate_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_CriticalRate_Value"),
  fishingRate_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_FishingRate_Value"),
  gatheringRate_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_GatheringRate_Value"),
  dropRate_Text = UI.getChildControl(Panel_Widget_PotenGradeInfo, "StaticText_DropRate_Value")
}
local potenType = {
  attackSpeed = 0,
  castingSpeed = 1,
  moveSpeed = 2,
  criticalRate = 3,
  fishingRate = 4,
  gatheringRate = 5,
  dropRate = 6,
  gradeText = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_UP_2")
}
function PotenGradeInfo:registEventHandler()
end
function PotenGradeInfo:registMessageHandler()
  registerEvent("onScreenResize", "FromClient_PotenGradeInfo_OnScreenResize")
end
local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local tooltipBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_1")
local helpWidget = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, Panel_Widget_PotenGradeInfo, "HelpWindow_For_PotenGradeInfo")
CopyBaseProperty(tooltipBase, helpWidget)
helpWidget:SetColor(UI_color.C_FFFFFFFF)
helpWidget:SetAlpha(1)
helpWidget:SetFontColor(UI_color.C_FFC4BEBE)
helpWidget:SetAutoResize(true)
helpWidget:SetShow(false)
helpWidget:SetTextHorizonCenter()
Panel_Widget_PotenGradeInfo:SetChildIndex(helpWidget, 9999)
local function PotenGradeInfo_Initialize()
  local self = PotenGradeInfo
  self.attackSpeed_Icon:SetIgnore(false)
  self.castingSpeed_Icon:SetIgnore(false)
  self.moveSpeed_Icon:SetIgnore(false)
  self.criticalRate_Icon:SetIgnore(false)
  self.fishingRate_Icon:SetIgnore(false)
  self.gatheringRate_Icon:SetIgnore(false)
  self.dropRate_Icon:SetIgnore(false)
  self.attackSpeed_Progress:SetIgnore(true)
  self.castingSpeed_Progress:SetIgnore(true)
  self.moveSpeed_Progress:SetIgnore(true)
  self.criticalRate_Progress:SetIgnore(true)
  self.fishingRate_Progress:SetIgnore(true)
  self.gatheringRate_Progress:SetIgnore(true)
  self.dropRate_Progress:SetIgnore(true)
end
function PotenGradeInfo_ShowAni()
  Panel_Widget_PotenGradeInfo:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo = Panel_Widget_PotenGradeInfo:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Panel_Widget_PotenGradeInfo:addScaleAnimation(0, 0.12, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0)
  aniInfo1:SetEndScale(1.3)
  aniInfo1.AxisX = Panel_Widget_PotenGradeInfo:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Widget_PotenGradeInfo:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Widget_PotenGradeInfo:addScaleAnimation(0.12, 0.18, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.3)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Widget_PotenGradeInfo:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Widget_PotenGradeInfo:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function PotenGradeInfo_HideAni()
  Panel_Widget_PotenGradeInfo:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo3 = Panel_Widget_PotenGradeInfo:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  aniInfo3:SetHideAtEnd(true)
  aniInfo3:SetDisableWhileAni(true)
end
function PotenGradeInfo:Update()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
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
  local equipedAttackSpeedPoint = currentAttackSpeedPoint - 5
  local maxAttackSpeedPoint = limitAttackSpeedPoint - 5
  local attackSpeedPointRate = equipedAttackSpeedPoint / maxAttackSpeedPoint * 100
  self.attackSpeed_Text:SetText(tostring(equipedAttackSpeedPoint) .. " " .. potentialType.levelText)
  self.attackSpeed_Progress:SetProgressRate(attackSpeedPointRate)
  self.attackSpeed_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.attackSpeed .. " )")
  self.attackSpeed_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.attackSpeed_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.attackSpeed .. " )")
  self.attackSpeed_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.attackSpeed_Icon:SetEnableArea(0, 0, self.attackSpeed_Icon:GetSizeX() + self.attackSpeed_Progress:GetSizeX() + 2, self.attackSpeed_Icon:GetSizeY() + 3)
  local currentCastingSpeedPoint = player:characterStatPointSpeed(potentialType.cast)
  local limitCastingSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.cast)
  if currentCastingSpeedPoint > limitCastingSpeedPoint then
    currentCastingSpeedPoint = limitCastingSpeedPoint
  end
  local equipedCastingSpeedPoint = currentCastingSpeedPoint - 5
  local maxCastingSpeedPoint = limitCastingSpeedPoint - 5
  local castingSpeedPointRate = equipedCastingSpeedPoint / maxCastingSpeedPoint * 100
  self.castingSpeed_Text:SetText(tostring(equipedCastingSpeedPoint) .. " " .. potentialType.levelText)
  self.castingSpeed_Progress:SetProgressRate(castingSpeedPointRate)
  self.castingSpeed_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.castingSpeed .. " )")
  self.castingSpeed_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.castingSpeed_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.castingSpeed .. " )")
  self.castingSpeed_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.castingSpeed_Icon:SetEnableArea(0, 0, self.castingSpeed_Icon:GetSizeX() + self.castingSpeed_Progress:GetSizeX() + 2, self.attackSpeed_Icon:GetSizeY() + 3)
  local currentMoveSpeedPoint = player:characterStatPointSpeed(potentialType.move)
  local limitMoveSpeedPoint = player:characterStatPointLimitedSpeed(potentialType.move)
  if currentMoveSpeedPoint > limitMoveSpeedPoint then
    currentMoveSpeedPoint = limitMoveSpeedPoint
  end
  local equipedMoveSpeedPoint = currentMoveSpeedPoint - 5
  local maxMoveSpeedPoint = limitMoveSpeedPoint - 5
  local moveSpeedPointRate = equipedMoveSpeedPoint / maxMoveSpeedPoint * 100
  self.moveSpeed_Text:SetText(tostring(equipedMoveSpeedPoint) .. " " .. potentialType.levelText)
  self.moveSpeed_Progress:SetProgressRate(moveSpeedPointRate)
  self.moveSpeed_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.moveSpeed .. " )")
  self.moveSpeed_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.moveSpeed_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.moveSpeed .. " )")
  self.moveSpeed_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.moveSpeed_Icon:SetEnableArea(0, 0, self.moveSpeed_Icon:GetSizeX() + self.moveSpeed_Progress:GetSizeX() + 2, self.moveSpeed_Icon:GetSizeY() + 3)
  local currentCriticalRatePoint = player:characterStatPointCritical()
  local limitCriticalRatePoint = player:characterStatPointLimitedCritical()
  if currentCriticalRatePoint > limitCriticalRatePoint then
    currentCriticalRatePoint = limitCriticalRatePoint
  end
  local equipedCriticalRatePoint = currentCriticalRatePoint
  local maxCriticalRatePoint = limitCriticalRatePoint
  local criticalRatePointRate = equipedCriticalRatePoint / maxCriticalRatePoint * 100
  self.criticalRate_Text:SetText(tostring(equipedCriticalRatePoint) .. " " .. potentialType.levelText)
  self.criticalRate_Progress:SetProgressRate(criticalRatePointRate)
  self.criticalRate_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.criticalRate .. " )")
  self.criticalRate_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.criticalRate_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.criticalRate .. " )")
  self.criticalRate_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.criticalRate_Icon:SetEnableArea(0, 0, self.criticalRate_Icon:GetSizeX() + self.criticalRate_Progress:GetSizeX() + 2, self.criticalRate_Icon:GetSizeY() + 3)
  local currentFishingRatePoint = player:getCharacterStatPointFishing()
  local limitFishingRatePoint = player:getCharacterStatPointLimitedFishing()
  if currentFishingRatePoint > limitFishingRatePoint then
    currentFishingRatePoint = limitFishingRatePoint
  end
  local equipedFishingRatePoint = currentFishingRatePoint
  local maxFishingRatePoint = limitFishingRatePoint
  local fishingRatePointRate = equipedFishingRatePoint / maxFishingRatePoint * 100
  self.fishingRate_Text:SetText(tostring(equipedFishingRatePoint) .. " " .. potentialType.levelText)
  self.fishingRate_Progress:SetProgressRate(fishingRatePointRate)
  self.fishingRate_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.fishingRate .. " )")
  self.fishingRate_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.fishingRate_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.fishingRate .. " )")
  self.fishingRate_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.fishingRate_Icon:SetEnableArea(0, 0, self.fishingRate_Icon:GetSizeX() + self.fishingRate_Progress:GetSizeX() + 2, self.fishingRate_Icon:GetSizeY() + 3)
  local currentProductRatePoint = player:getCharacterStatPointCollection()
  local limitProductRatePoint = player:getCharacterStatPointLimitedCollection()
  if currentProductRatePoint > limitProductRatePoint then
    currentProductRatePoint = limitProductRatePoint
  end
  local equipedProductRatePoint = currentProductRatePoint
  local maxProductRatePoint = limitProductRatePoint
  local ProductRatePointRate = equipedProductRatePoint / maxProductRatePoint * 100
  self.gatheringRate_Text:SetText(tostring(equipedProductRatePoint) .. " " .. potentialType.levelText)
  self.gatheringRate_Progress:SetProgressRate(ProductRatePointRate)
  self.gatheringRate_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.gatheringRate .. " )")
  self.gatheringRate_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.gatheringRate_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.gatheringRate .. " )")
  self.gatheringRate_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.gatheringRate_Icon:SetEnableArea(0, 0, self.gatheringRate_Icon:GetSizeX() + self.gatheringRate_Progress:GetSizeX() + 2, self.gatheringRate_Icon:GetSizeY() + 3)
  local currentDropItemRatePoint = player:getCharacterStatPointDropItem()
  local limitDropItemRatePoint = player:getCharacterStatPointLimitedDropItem()
  if currentDropItemRatePoint > limitDropItemRatePoint then
    currentDropItemRatePoint = limitDropItemRatePoint
  end
  local equipedDropItemRatePoint = currentDropItemRatePoint
  local maxDropItemRatePoint = limitDropItemRatePoint
  local DropItemRatePointRate = equipedDropItemRatePoint / maxDropItemRatePoint * 100
  self.dropRate_Text:SetText(tostring(equipedDropItemRatePoint) .. " " .. potentialType.levelText)
  self.dropRate_Progress:SetProgressRate(DropItemRatePointRate)
  self.dropRate_Icon:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.dropRate .. " )")
  self.dropRate_Icon:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.dropRate_Progress:addInputEvent("Mouse_On", "PotenGradeInfo_MouseOver( true, " .. potenType.dropRate .. " )")
  self.dropRate_Progress:addInputEvent("Mouse_Out", "PotenGradeInfo_MouseOver( false )")
  self.dropRate_Icon:SetEnableArea(0, 0, self.dropRate_Icon:GetSizeX() + self.dropRate_Progress:GetSizeX() + 2, self.dropRate_Icon:GetSizeY() + 3)
end
function PotenGradeInfoUpdate()
  local self = PotenGradeInfo
  self:Update()
end
function PotenGradeInfo_MouseOver(isShow, _potenType)
  local self = PotenGradeInfo
  local text, posX, posY
  if true == isShow then
    if potenType.attackSpeed == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_1") .. " " .. self.attackSpeed_Text:GetText()
      posX = self.attackSpeed_Icon:GetPosX()
      posY = self.attackSpeed_Icon:GetPosY()
    elseif potenType.castingSpeed == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_2") .. " " .. self.castingSpeed_Text:GetText()
      posX = self.castingSpeed_Icon:GetPosX()
      posY = self.castingSpeed_Icon:GetPosY()
    elseif potenType.moveSpeed == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_3") .. " " .. self.moveSpeed_Text:GetText()
      posX = self.moveSpeed_Icon:GetPosX()
      posY = self.moveSpeed_Icon:GetPosY()
    elseif potenType.criticalRate == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_4") .. " " .. self.criticalRate_Text:GetText()
      posX = self.criticalRate_Icon:GetPosX()
      posY = self.criticalRate_Icon:GetPosY()
    elseif potenType.fishingRate == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_5") .. " " .. self.fishingRate_Text:GetText()
      posX = self.fishingRate_Icon:GetPosX()
      posY = self.fishingRate_Icon:GetPosY()
    elseif potenType.gatheringRate == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_6") .. " " .. self.gatheringRate_Text:GetText()
      posX = self.gatheringRate_Icon:GetPosX()
      posY = self.gatheringRate_Icon:GetPosY()
    elseif potenType.dropRate == _potenType then
      text = PAGetString(Defines.StringSheet_GAME, "LUA_POTENCIAL_KIND_7") .. " " .. self.dropRate_Text:GetText()
      posX = self.dropRate_Icon:GetPosX()
      posY = self.dropRate_Icon:GetPosY()
    end
    helpWidget:SetText(text)
    helpWidget:SetSize(helpWidget:GetTextSizeX() + 20, helpWidget:GetSizeY())
    helpWidget:SetPosX(self.attackSpeed_Text:GetPosX())
    helpWidget:SetPosY(self.attackSpeed_Text:GetPosY() - 3)
    helpWidget:SetShow(true)
  else
    helpWidget:SetShow(false)
  end
end
function FromClient_PotenGradeInfo_OnScreenResize()
  Panel_Widget_PotenGradeInfo:SetPosX(15)
  Panel_Widget_PotenGradeInfo:SetPosY(Panel_Widget_CraftLevInfo:GetPosY() - Panel_Widget_PotenGradeInfo:GetSizeY() + 10)
end
function PotenGradeInfo_ShowToggle()
  if Panel_Widget_PotenGradeInfo:IsShow() then
  else
  end
end
function PotenGradeInfo_Show()
  if not Panel_Widget_PotenGradeInfo:GetShow() then
  end
end
function PotenGradeInfo_Hide()
  if Panel_Widget_PotenGradeInfo:GetShow() then
  end
end
PotenGradeInfo_Initialize()
PotenGradeInfo:registEventHandler()
PotenGradeInfo:registMessageHandler()
PotenGradeInfoUpdate()
registerEvent("FromClient_UpdateSelfPlayerStatPoint", "PotenGradeInfoUpdate")
Panel_Widget_PotenGradeInfo:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
