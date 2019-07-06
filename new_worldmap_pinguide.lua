local VCK = CppEnums.VirtualKeyCode
function FromClient_AddFlickerPin(uiControl, position, isForGuild)
  uiControl:EraseAllEffect()
  local guideParam = NavigationGuideParam()
  if isForGuild then
    uiControl:AddEffect("UI_WorldMap_Ping01", false, 0, 0)
    guideParam._color = float4(1, 0.8, 0.6, 1)
    guideParam._bgColor = float4(0.6, 0.2, 0.2, 0.3)
    guideParam._beamColor = float4(0.4, 0.15, 0.15, 1)
  else
    uiControl:AddEffect("UI_WorldMap_Ping02", false, 0, 0)
    guideParam._color = float4(1, 0.8, 0.6, 1)
    guideParam._bgColor = float4(0.6, 0.2, 0.2, 0.3)
    guideParam._beamColor = float4(0.4, 0.15, 0.15, 1)
  end
  worldmap_addNavigationBeam(position, guideParam, true)
end
function FromClient_LDownWorldMapPanel()
  if isKeyPressed(VCK.KeyCode_CONTROL) then
    ToClient_requestWordmapPin(true, false, false)
  elseif isKeyPressed(VCK.KeyCode_SHIFT) then
    ToClient_requestWordmapPin(false, false, false)
  elseif isKeyPressed(VCK.KeyCode_SPACE) then
    ToClient_requestWordmapPin(true, false, true)
  end
end
function FromClient_LDoubleClickWorldMapPanel()
  if isKeyPressed(VCK.KeyCode_CONTROL) then
    ToClient_requestWordmapPin(true, true, false)
  elseif isKeyPressed(VCK.KeyCode_SHIFT) then
    ToClient_requestWordmapPin(false, true, false)
  elseif isKeyPressed(VCK.KeyCode_SPACE) then
    ToClient_requestWordmapPin(true, true, true)
  end
end
function FromClient_LClickPin(actorKey, isForGuild)
  if isKeyPressed(VCK.KeyCode_CONTROL) and true == isForGuild then
    ToClient_RequestDeletePositionGuide(actorKey, isForGuild)
  elseif isKeyPressed(VCK.KeyCode_SHIFT) and false == isForGuild then
    ToClient_RequestDeletePositionGuide(actorKey, isForGuild)
  end
end
registerEvent("FromClient_AddFlickerPin", "FromClient_AddFlickerPin")
registerEvent("FromClient_LDownWorldMapPanel", "FromClient_LDownWorldMapPanel")
registerEvent("FromClient_LDoubleClickWorldMapPanel", "FromClient_LDoubleClickWorldMapPanel")
registerEvent("FromClient_LClickPin", "FromClient_LClickPin")
