PaGlobalShipEnduranceList = {
  panel = Panel_ShipEndurance,
  enduranceTypeCount = 4,
  enduranceInfo = {},
  effectBG = UI.getChildControl(Panel_ShipEndurance, "Static_ShipEffect"),
  noticeEndurance = UI.getChildControl(Panel_ShipEndurance, "StaticText_NoticeEndurance"),
  repair_AutoNavi = UI.getChildControl(Panel_ShipEndurance, "CheckButton_Repair_AutoNavi"),
  repair_Navi = UI.getChildControl(Panel_ShipEndurance, "Checkbox_Repair_Navi"),
  radarSizeX = 0
}
function PaGlobalShipEnduranceList:initialize()
  for index = 0, CppEnums.EquipSlotNo.equipSlotNoCount - 1 do
    self.enduranceInfo[index] = {}
    if 0 == index then
      self.enduranceInfo[index].control = nil
    elseif 1 == index then
      self.enduranceInfo[index].control = nil
    elseif 2 == index then
      self.enduranceInfo[index].control = nil
    elseif 3 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ship_Main")
    elseif 4 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ship_Head")
    elseif 5 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ship_Goods")
    elseif 6 == index then
      self.enduranceInfo[index].control = nil
    elseif 7 == index then
      self.enduranceInfo[index].control = nil
    elseif 8 == index then
      self.enduranceInfo[index].control = nil
    elseif 9 == index then
      self.enduranceInfo[index].control = nil
    elseif 10 == index then
      self.enduranceInfo[index].control = nil
    elseif 11 == index then
      self.enduranceInfo[index].control = nil
    elseif 12 == index then
      self.enduranceInfo[index].control = nil
    elseif 13 == index then
      self.enduranceInfo[index].control = nil
    elseif 14 == index then
      self.enduranceInfo[index].control = nil
    elseif 15 == index then
      self.enduranceInfo[index].control = nil
    elseif 16 == index then
      self.enduranceInfo[index].control = nil
    elseif 17 == index then
      self.enduranceInfo[index].control = nil
    elseif 18 == index then
      self.enduranceInfo[index].control = nil
    elseif 19 == index then
      self.enduranceInfo[index].control = nil
    elseif 20 == index then
      self.enduranceInfo[index].control = nil
    elseif 21 == index then
      self.enduranceInfo[index].control = nil
    elseif 22 == index then
      self.enduranceInfo[index].control = nil
    elseif 23 == index then
      self.enduranceInfo[index].control = nil
    elseif 24 == index then
      self.enduranceInfo[index].control = nil
    elseif 25 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ship_Deco")
    elseif 26 == index then
      self.enduranceInfo[index].control = nil
    elseif 27 == index then
      self.enduranceInfo[index].control = nil
    elseif 28 == index then
      self.enduranceInfo[index].control = nil
    elseif 29 == index then
      self.enduranceInfo[index].control = nil
    elseif 30 == index then
      self.enduranceInfo[index].control = nil
    elseif 31 == index then
      self.enduranceInfo[index].control = nil
    end
    if nil ~= self.enduranceInfo[index].control then
      self.enduranceInfo[index].control:SetShow(false)
      self.enduranceInfo[index].color = Defines.Color.C_FF000000
      self.enduranceInfo[index].itemEquiped = false
      self.enduranceInfo[index].isBroken = false
    end
  end
  self.noticeEndurance:SetShow(false)
  self.repair_AutoNavi:SetShow(false)
  self.repair_Navi:SetShow(false)
  self.panel:SetShow(true)
  if not self.repair_Navi:GetShow() then
    self.effectBG:EraseAllEffect()
  end
  self.effectBG:addInputEvent("Mouse_On", "HandleMEnduranceNotice(CppEnums.EnduranceType.eEnduranceType_Ship, true)")
  self.effectBG:addInputEvent("Mouse_Out", "HandleMEnduranceNotice(CppEnums.EnduranceType.eEnduranceType_Ship, false)")
  self.repair_AutoNavi:addInputEvent("Mouse_LUp", "HandleMLUpRepairNavi(CppEnums.EnduranceType.eEnduranceType_Ship, true)")
  self.repair_Navi:addInputEvent("Mouse_LUp", "HandleMLUpRepairNavi(CppEnums.EnduranceType.eEnduranceType_Ship, false)")
  self.radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  Panel_ShipEndurance_Position()
  self._isInit = true
end
function PaGlobalShipEnduranceList:checkInit()
  return self._isInit == true
end
function Panel_ShipEndurance_Position()
  local self = PaGlobalShipEnduranceList
  self.radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  if PaGlobalHorseEnduranceList.panel:GetShow() or PaGlobalCarriageEnduranceList.panel:GetShow() then
    self.panel:SetPosX(getScreenSizeX() - self.radarSizeX - self.panel:GetSizeX() * 3.1)
  else
    self.panel:SetPosX(getScreenSizeX() - self.radarSizeX - self.panel:GetSizeX() * 1.9)
  end
  self.panel:SetPosY(FGlobal_Panel_Radar_GetPosY() - FGlobal_Panel_Radar_GetSizeY() / 1.4)
  if Panel_Widget_TownNpcNavi:GetShow() then
    self.panel:SetPosY(Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 15)
  end
end
function renderModeChange_Panel_ShipEndurance_Position(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  Panel_ShipEndurance_Position()
end
function PaGlobalShipEnduranceList_Init()
  PaGlobalShipEnduranceList:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalShipEnduranceList_Init")
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_ShipEndurance_Position")
registerEvent("onScreenResize", "Panel_ShipEndurance_Position")
