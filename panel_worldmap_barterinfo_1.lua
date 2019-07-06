function PaGlobal_WorldMapBarterInfo:initialize()
  if true == PaGlobal_WorldMapBarterInfo._initialize then
    return
  end
  PaGlobal_WorldMapBarterInfo:registEventHandler()
  PaGlobal_WorldMapBarterInfo:validate()
  Panel_Worldmap_BarterInfo:SetShow(false)
  PaGlobal_WorldMapBarterInfo._initialize = true
end
function PaGlobal_WorldMapBarterInfo:registEventHandler()
  if nil == Panel_Worldmap_BarterInfo then
    return
  end
  registerEvent("FromClient_InitBarterInfo", "FromClient_InitBarterInfo")
end
function PaGlobal_WorldMapBarterInfo:update(nodeBtn)
  if nil == Panel_Worldmap_BarterInfo then
    return
  end
end
function PaGlobal_WorldMapBarterInfo:validate()
  if nil == Panel_Worldmap_BarterInfo then
    return
  end
end
function PaGlobal_WorldMapBarterInfo:createSlot(parent, index)
  if nil == Panel_Worldmap_BarterInfo then
    return
  end
  local slot = {}
  SlotItem.new(slot, "itemIcon", index, parent, PaGlobal_WorldMapBarterInfo._slotConfig)
  slot:createChild()
  slot.icon:SetPosX(0)
  slot.icon:SetPosY(0)
  slot.icon:SetShow(true)
  return slot
end
