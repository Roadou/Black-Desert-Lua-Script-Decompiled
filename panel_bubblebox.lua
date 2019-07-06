Panel_Copy_BubbleBox:SetPosX(-1000)
Panel_Copy_BubbleBox:SetPosY(-1000)
ToClient_SetBubbleBoxPanel(Panel_Copy_BubbleBox)
ToClient_InitializeBubbleBoxPanelPool(500)
function EventBubbleBoxCreated(actorKeyRaw, targetPanel, actorType, actorProxyWrapper)
  local bubbleBox = UI.getChildControl(targetPanel, "StaticText_BubbleBox")
  if nil ~= bubbleBox then
    bubbleBox:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    bubbleBox:SetAutoResize(true)
  end
end
registerEvent("EventBubbleBoxCreated", "EventBubbleBoxCreated")
