function PaGlobal_GardenInformation_UpdateGardenInfo(deltaTime)
  if nil == Panel_Window_GardenInformation then
    return
  end
  if nil == PaGlobal_GardenInformation._householdIndex or nil == Panel_Window_GardenInformation:GetShow() then
    return
  end
  PaGlobal_GardenInformation:updatePerFrame(deltaTime)
end
function FromClient_GardenInformation_OnScreenResize()
  if nil == Panel_Window_GardenInformation then
    return
  end
  PaGlobal_GardenInformation:resize()
end
registerEvent("onScreenResize", "FromClient_GardenInformation_OnScreenResize")
Panel_Window_GardenInformation:RegisterUpdateFunc("PaGlobal_GardenInformation_UpdateGardenInfo")
