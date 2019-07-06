PaGlobalPlayerEnduranceList = {
  panel = Panel_Endurance,
  enduranceTypeCount = 13,
  enduranceInfo = {},
  effectBG = UI.getChildControl(Panel_Endurance, "Static_Effect"),
  noticeEndurance = UI.getChildControl(Panel_Endurance, "StaticText_NoticeEndurance"),
  isEffectSound = false,
  repair_AutoNavi = UI.getChildControl(Panel_Endurance, "CheckButton_Repair_AutoNavi"),
  repair_Navi = UI.getChildControl(Panel_Endurance, "Checkbox_Repair_Navi"),
  radarSizeX = 0
}
function PaGlobalPlayerEnduranceList:initialize()
  for index = 0, CppEnums.EquipSlotNo.equipSlotNoCount - 1 do
    self.enduranceInfo[index] = {}
    if 0 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_WeaponR")
    elseif 1 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_WeaponL")
    elseif 2 == index then
      self.enduranceInfo[index].control = nil
    elseif 3 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Armor")
    elseif 4 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Glove")
    elseif 5 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Boots")
    elseif 6 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Helm")
    elseif 7 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Necklace")
    elseif 8 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ring1")
    elseif 9 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Ring2")
    elseif 10 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Earing1")
    elseif 11 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Earing2")
    elseif 12 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_Belt")
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
      self.enduranceInfo[index].control = nil
    elseif 26 == index then
      self.enduranceInfo[index].control = nil
    elseif 27 == index then
      self.enduranceInfo[index].control = nil
    elseif 28 == index then
      self.enduranceInfo[index].control = nil
    elseif 29 == index then
      self.enduranceInfo[index].control = UI.getChildControl(self.panel, "Static_AwakenWeapon")
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
  self.effectBG:addInputEvent("Mouse_On", "HandleMEnduranceNotice(CppEnums.EnduranceType.eEnduranceType_Player, true)")
  self.effectBG:addInputEvent("Mouse_Out", "HandleMEnduranceNotice(CppEnums.EnduranceType.eEnduranceType_Player, false)")
  self.repair_AutoNavi:addInputEvent("Mouse_LUp", "HandleMLUpRepairNavi(CppEnums.EnduranceType.eEnduranceType_Player, true)")
  self.repair_Navi:addInputEvent("Mouse_LUp", "HandleMLUpRepairNavi(CppEnums.EnduranceType.eEnduranceType_Player, false)")
  self.radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  self._isInit = true
end
function PaGlobalPlayerEnduranceList:checkInit()
  return self._isInit == true
end
function HandleMEnduranceNotice(enduranceType, isShow)
  local self = PaGlobalPlayerEnduranceList
  if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
    self = PaGlobalPlayerEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
    self = PaGlobalHorseEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
    self = PaGlobalCarriageEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
    self = PaGlobalShipEnduranceList
  end
  self.noticeEndurance:SetShow(isShow)
end
function HandleMLUpRepairNavi(enduranceType, isAuto)
  local self = PaGlobalPlayerEnduranceList
  if enduranceType == CppEnums.EnduranceType.eEnduranceType_Player then
    self = PaGlobalPlayerEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Horse then
    self = PaGlobalHorseEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Carriage then
    self = PaGlobalCarriageEnduranceList
  elseif enduranceType == CppEnums.EnduranceType.eEnduranceType_Ship then
    self = PaGlobalShipEnduranceList
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  if ToClient_IsShowNaviGuideGroup(0) then
    if true == isAuto and true == self.repair_AutoNavi:IsCheck() then
      self.repair_Navi:SetCheck(true)
      self.repair_AutoNavi:SetCheck(true)
    else
      self.repair_Navi:SetCheck(false)
      self.repair_AutoNavi:SetCheck(false)
      audioPostEvent_SystemUi(0, 15)
      return
    end
  elseif true == isAuto then
    self.repair_Navi:SetCheck(true)
    self.repair_AutoNavi:SetCheck(true)
  else
    self.repair_Navi:SetCheck(true)
    self.repair_AutoNavi:SetCheck(false)
  end
  local position = player:get3DPos()
  local spawnType = CppEnums.SpawnType.eSpawnType_ItemRepairer
  local nearNpcInfo = getNearNpcInfoByType(spawnType, position)
  if nil ~= nearNpcInfo then
    local pos = nearNpcInfo:getPosition()
    local repairNaviKey = ToClient_WorldMapNaviStart(pos, NavigationGuideParam(), isAuto, true)
    audioPostEvent_SystemUi(0, 14)
    local selfPlayer = getSelfPlayer():get()
    selfPlayer:setNavigationMovePath(repairNaviKey)
    selfPlayer:checkNaviPathUI(repairNaviKey)
  end
end
function Panel_PlayerEndurance_Position()
  local self = PaGlobalPlayerEnduranceList
  self.radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  self.panel:SetPosX(getScreenSizeX() - self.radarSizeX - self.panel:GetSizeX() - 15)
  self.panel:SetPosY(FGlobal_Panel_Radar_GetPosY())
  if Panel_Widget_TownNpcNavi:GetShow() then
    self.panel:SetPosY(Panel_Widget_TownNpcNavi:GetSizeY() + Panel_Widget_TownNpcNavi:GetPosY() + 10)
  end
  if true == ToClient_isConsole() then
    local gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
    self.panel:SetPosX(getOriginScreenSizeX() - self.radarSizeX - self.panel:GetSizeX() - 15 - gapX)
    self.panel:SetPosY(Panel_NewEquip:GetSizeY() + Panel_NewEquip:GetPosY() + 10)
  end
end
function renderModeChange_Panel_PlayerEndurance_Position(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  Panel_PlayerEndurance_Position()
end
function PaGlobalPlayerEnduranceList_Init()
  PaGlobalPlayerEnduranceList:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalPlayerEnduranceList_Init")
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_PlayerEndurance_Position")
registerEvent("onScreenResize", "Panel_PlayerEndurance_Position")
