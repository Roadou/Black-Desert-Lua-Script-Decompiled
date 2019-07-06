function PaGlobalFunc_GardenIcon_UpdatePerFrameFunc(deltatime)
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  PaGlobal_TopIcon_Garden:update()
end
function FromClient_TopIcon_Garden_Resize()
  if nil == Panel_Widget_GardenIcon_Renew then
    return
  end
  PaGlobal_TopIcon_Garden:onScreenResize()
end
registerEvent("onScreenResize", "FromClient_TopIcon_Garden_Resize")
