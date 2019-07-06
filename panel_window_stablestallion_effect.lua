Panel_Window_StableStallion_Effect:SetShow(false)
local horseToehold = UI.getChildControl(Panel_Window_StableStallion_Effect, "Static_HorseToehold")
local awakenSuccess = UI.getChildControl(Panel_Window_StableStallion_Effect, "Static_AwakenSuccess")
local awakenFail = UI.getChildControl(Panel_Window_StableStallion_Effect, "Static_AwakenFail")
local effectControl = {}
local controlCount = 0
function StableStallion_AwakenEffect(isAwaken, servantKey)
  if 0 == isAwaken then
    StableStallion_Effect(Panel_Window_StableStallion_Effect, 6, 0, 220, servantKey)
    return
  elseif true == isAwaken then
    horseToehold:SetShow(true)
    awakenFail:SetShow(false)
    horseToehold:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_AWAKENSUCCESS"))
    StableStallion_Effect(Panel_Window_StableStallion_Effect, 7, 0, 220, servantKey)
  else
    horseToehold:SetShow(true)
    awakenSuccess:SetShow(false)
    horseToehold:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_AWAKENFAIL"))
    StableStallion_Effect(Panel_Window_StableStallion_Effect, 12, 0, 220, servantKey)
  end
end
function StableStallion_doAwakenEffect()
  StableStallion_Effect(Panel_Window_StableStallion_Effect, 13, 0, -190)
end
function StableStallion_Effect(control, index, posX, posY, servantKey)
  if 0 == index then
    control:AddEffect("fUI_Alchemy_UpgradeStart01", false, posX, posY)
  elseif 1 == index then
  elseif 2 == index then
    control:AddEffect("fCO_Egg_Random_01B", false, posX, posY)
  elseif 3 == index then
    control:AddEffect("UI_NewSkill01", false, posX, posY)
    control:AddEffect("fUI_Horse_Upgrade_02A", false, posX, posY)
  elseif 4 == index then
    control:AddEffect("fUI_Horse_Upgrade_03A", false, posX, posY)
  elseif 5 == index then
    control:AddEffect("fUI_Horse_Upgrade_04A", false, posX, posY)
  elseif 6 == index then
    control:AddEffect("fUI_Horse_Upgrade_05B", false, posX, posY)
  elseif 7 == index then
    if 9989 == servantKey or 9889 == servantKey then
      control:AddEffect("fUI_Horse_Upgrade_06B", false, posX, posY)
    elseif 9988 == servantKey or 9888 == servantKey then
      control:AddEffect("fUI_Horse_Upgrade_06C", false, posX, posY)
    elseif 9987 == servantKey or 9887 == servantKey then
      control:AddEffect("fUI_Horse_Upgrade_06D", false, posX, posY)
    end
  elseif 8 == index then
  elseif 9 == index then
    control:AddEffect("fUI_Horse_Upgrade_01A", false, posX, posY)
    control:AddEffect("CO_UI_Horse_Upgrade_01A", false, posX, posY)
  elseif 10 == index then
    control:AddEffect("fUI_Horse_Upgrade_01B", false, posX, posY)
    control:AddEffect("CO_UI_Horse_Upgrade_01B", false, posX, posY)
  elseif 11 == index then
    control:AddEffect("fUI_Horse_Upgrade_01C", false, posX, posY)
    control:AddEffect("CO_UI_Horse_Upgrade_01C", false, posX, posY)
  elseif 12 == index then
    control:AddEffect("fUI_Horse_Upgrade_06A", false, posX, posY)
  elseif 13 == index then
    control:AddEffect("fUI_Horse_Upgrade_05A", false, posX, posY)
  end
  effectControl[controlCount] = control
  controlCount = controlCount + 1
end
function StableStallion_EffectErase()
  for i = 0, controlCount - 1 do
    effectControl[i]:EraseAllEffect()
  end
end
function StableStallion_EffectClose()
  Panel_Window_StableStallion_Effect:SetShow(false)
  awakenFail:SetShow(false)
  awakenSuccess:SetShow(false)
  horseToehold:SetShow(false)
  limitEffect = false
end
