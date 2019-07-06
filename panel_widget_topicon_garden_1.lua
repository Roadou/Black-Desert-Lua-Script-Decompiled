function PaGlobal_TopIcon_Garden:initialize()
  if true == PaGlobal_TopIcon_Garden._initialize then
    return
  end
  PaGlobal_TopIcon_Garden._ui.static_GardenIcon_Template = UI.getChildControl(Panel_Widget_GardenIcon_Renew, "Static_GardenIcon_Template")
  PaGlobal_TopIcon_Garden:registEventHandler()
  PaGlobal_TopIcon_Garden:onScreenResize()
  PaGlobal_TopIcon_Garden._initialize = true
end
function PaGlobal_TopIcon_Garden:registEventHandler()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  registerEvent("FromClient_SetSelfTent", "PaGlobal_TopIcon_Garden:update()")
  registerEvent("FromClient_InterActionHarvest", "PaGlobal_TopIcon_Garden:update()")
  registerEvent("FromClient_InteractionSeedHarvest", "PaGlobal_TopIcon_Garden:update()")
  registerEvent("FromClient_RenderModeChangeState", "PaGlobal_TopIcon_Garden:update()")
end
function PaGlobal_Template:prepareOpen()
  PaGlobal_TopIcon_Garden:update()
end
function PaGlobal_TopIcon_Garden:open()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  PaGlobal_TopIcon_Garden:prepareOpen()
  Panel_Widget_GardenIcon_Renew:SetShow(true)
end
function PaGlobal_TopIcon_Garden:prepareClose()
  PaGlobal_TopIcon_Garden._harvestEffectOn = false
  PaGlobal_TopIcon_Garden._ui.static_GardenIcon_Template:EraseAllEffect()
end
function PaGlobal_TopIcon_Garden:close()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  PaGlobal_TopIcon_Garden:prepareOpen()
  Panel_Widget_GardenIcon_Renew:SetShow(false)
end
function PaGlobal_TopIcon_Garden:update()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  if isFlushedUI() then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper then
    return
  end
  local gardenCount = temporaryWrapper:getSelfTentCount()
  if gardenCount <= 0 then
    PaGlobalFunc_TopIcon_Exit(TopWidgetIconType.Garden)
    return
  end
  PaGlobalFunc_TopIcon_Show(TopWidgetIconType.Garden)
  PaGlobal_TopIcon_Garden:updateHarvestStatus(gardenCount)
end
function PaGlobal_TopIcon_Garden:validate()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  PaGlobal_TopIcon_Garden._ui.static_GardenIcon_Template:isValidate()
end
function PaGlobal_TopIcon_Garden:onScreenResize()
  local posY = Panel_SelfPlayerExpGage:GetPosY() + Panel_SelfPlayerExpGage:GetSizeY() + 4
  Panel_Widget_GardenIcon_Renew:SetPosY(posY)
end
function PaGlobal_TopIcon_Garden:updateHarvestStatus(gardenCount)
  if isFlushedUI() or false == Panel_Widget_GardenIcon_Renew:GetShow() then
    return
  end
  local isReadyToHarvested = false
  local temporaryWrapper = getTemporaryInformationWrapper()
  for index = 0, gardenCount - 1 do
    local householdDataWithInstallationWrapper = temporaryWrapper:getSelfTentWrapperByIndex(index)
    local cropCount = householdDataWithInstallationWrapper:getSelfHarvestCount()
    for ii = 1, cropCount do
      local percent = math.min(householdDataWithInstallationWrapper:getSelfHarvestCompleteRate(ii) * 100, 200)
      if percent >= 100 then
        isReadyToHarvested = true
        break
      end
    end
  end
  if true == isReadyToHarvested then
    if false == PaGlobal_TopIcon_Garden._harvestEffectOn then
      PaGlobal_TopIcon_Garden._ui.static_GardenIcon_Template:AddEffect(PaGlobal_TopIcon_Garden._harvestEffect, true, 0, -2)
      PaGlobal_TopIcon_Garden._harvestEffectOn = true
    end
  else
    PaGlobal_TopIcon_Garden._ui.static_GardenIcon_Template:EraseAllEffect()
    PaGlobal_TopIcon_Garden._harvestEffectOn = false
  end
end
