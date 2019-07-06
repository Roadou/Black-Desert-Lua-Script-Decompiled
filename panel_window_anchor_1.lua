function PaGlobal_Anchor:initialize()
  if true == PaGlobal_Anchor._initialize then
    return
  end
  PaGlobal_Anchor._ui._btn_anchor = UI.getChildControl(Panel_Widget_ServantButton, "Button_Servant")
  PaGlobal_Anchor._ui._btn_barter = UI.getChildControl(Panel_Window_Anchor, "Button_Templete")
  PaGlobal_Anchor:registEventHandler()
  PaGlobal_Anchor:validate()
  PaGlobal_Anchor._initialize = true
end
function PaGlobal_Anchor:registEventHandler()
  if nil == Panel_Window_Anchor then
    return
  end
  registerEvent("FromClient_UpdateNearBarterNPC", "FromClient_UpdateNearBarterNPC")
  registerEvent("EventSelfPlayerRideOff", "PaGlobal_Anchor_FromClient_RideOff")
  PaGlobal_Anchor._ui._btn_anchor:addInputEvent("Mouse_LUp", "PaGlobal_Anchor:prepareOpen()")
  PaGlobal_Anchor._ui._btn_barter:addInputEvent("Mouse_LUp", "HandleEventLUp_Anchor_SelectType(" .. PaGlobal_Anchor._eSelectButtonType.barter .. ")")
end
function PaGlobal_Anchor:prepareOpen()
  if nil == Panel_Window_Anchor then
    return
  end
  PaGlobal_Anchor:initData()
  PaGlobal_Anchor:open()
  if nil ~= PaGlobal_Anchor._ui._btn_anchor then
    PaGlobal_Anchor._ui._btn_anchor:SetShow(true)
  end
end
function PaGlobal_Anchor:open()
  if nil == Panel_Window_Anchor then
    return
  end
  Panel_Window_Anchor:SetShow(true)
end
function PaGlobal_Anchor:prepareClose()
  if nil == Panel_Window_Anchor then
    return
  end
  PaGlobal_Anchor:clearData()
  PaGlobal_Anchor:close()
end
function PaGlobal_Anchor:close()
  if nil == Panel_Window_Anchor then
    return
  end
  Panel_Window_Anchor:SetShow(false)
end
function PaGlobal_Anchor:update()
  if nil == Panel_Window_Anchor then
    return
  end
end
function PaGlobal_Anchor:validate()
  if nil == Panel_Window_Anchor then
    return
  end
  PaGlobal_Anchor._ui._btn_anchor:isValidate()
  PaGlobal_Anchor._ui._btn_barter:isValidate()
end
function PaGlobal_Anchor:initData()
  if nil == Panel_Window_Anchor then
    return
  end
end
function PaGlobal_Anchor:clearData()
  if nil == Panel_Window_Anchor then
    return
  end
  PaGlobal_Barter._actorKey = nil
  PaGlobal_Barter_regionKey = RegionKey(0)
  PaGlobal_Barter._itemWhereType = nil
end
