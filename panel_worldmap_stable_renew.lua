local Window_WorldMap_StableInfo = {
  _ui = {
    _list2_Stable = UI.getChildControl(Panel_Worldmap_Stable, "List2_Title_List")
  },
  _currentNodeInfo = nil,
  _horseInfoList = {}
}
function PaGlobalFunc_WorldMap_Stable_SetCurrentNodeInfo(nodeInfo)
  local self = Window_WorldMap_StableInfo
  self._currentNodeInfo = nodeInfo
end
function Window_WorldMap_StableInfo:SetStable()
  local waypointKey = self._currentNodeInfo:getPlantKey():getWaypointKey()
  local nodeServantCount = stable_countFromWaypointKey(waypointKey)
  self._ui._list2_Stable:getElementManager():clearKey()
  self._horseInfoList = {}
  for servantIdx = 0, nodeServantCount - 1 do
    self._horseInfoList[servantIdx] = {}
    local servantInfo = stable_getServantFromWaypointKey(waypointKey, servantIdx)
    if nil ~= servantInfo then
      local isLinkedHorse = servantInfo:isLink() and CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType()
      self._horseInfoList[servantIdx]._name = servantInfo:getName()
      self._horseInfoList[servantIdx]._icon = servantInfo:getIconPath1()
      if true == servantInfo:doMating() then
        self._horseInfoList[servantIdx]._isMale = servantInfo:isMale()
      end
      if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Camel or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Donkey or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
        self._horseInfoList[servantIdx]._isMale = nil
      end
      if CppEnums.VehicleType.Type_Horse == servantInfo:getVehicleType() then
        if 9 == servantInfo:getTier() and ToClient_IsContentsGroupOpen("243") then
          self._horseInfoList[servantIdx]._tier = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9")
        else
          self._horseInfoList[servantIdx]._tier = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier())
          if ToClient_IsContentsGroupOpen("243") then
            self._horseInfoList[servantIdx]._isStallion = servantInfo:isStallion()
          end
        end
      else
        self._horseInfoList[servantIdx]._tier = nil
      end
      self._ui._list2_Stable:getElementManager():pushKey(toInt64(0, servantIdx))
      self._ui._list2_Stable:requestUpdateByKey(toInt64(0, servantIdx))
    end
  end
end
function Window_WorldMap_StableInfo:InitControl()
  self._ui._list2_Stable:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_Stable_List2EventControlCreate")
  self._ui._list2_Stable:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Window_WorldMap_StableInfo:InitEvent()
end
function Window_WorldMap_StableInfo:InitRegister()
end
function Window_WorldMap_StableInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMap_Stable_List2EventControlCreate(list_content, key)
  local self = Window_WorldMap_StableInfo
  local id = Int64toInt32(key)
  local info = self._horseInfoList[id]
  if nil == info then
    return
  end
  local static_Image = UI.getChildControl(list_content, "Static_Image")
  local static_Sex = UI.getChildControl(list_content, "Static_SexIcon")
  local staticText_Tier = UI.getChildControl(list_content, "StaticText_Tier")
  local staticText_Name = UI.getChildControl(list_content, "StaticText_Name")
  local staticText_Location = UI.getChildControl(list_content, "StaticText_Location")
  local static_Swift = UI.getChildControl(list_content, "Static_SwiftIcon")
  static_Image:ChangeTextureInfoName(info._icon)
  staticText_Name:SetText(info._name)
  staticText_Tier:SetText(info._tier)
  if true == ToClient_IsContentsGroupOpen("243") then
    static_Swift:SetShow(true)
    static_Swift:SetMonoTone(not info._isStallion)
  else
    static_Swift:SetShow(false)
  end
  static_Sex:ChangeTextureInfoName("renewal/ui_icon/console_icon_01.dds")
  if true == info._isMale then
    static_Sex:getBaseTexture():setUV(setTextureUV_Func(static_Sex, 82, 1, 101, 20))
  else
    static_Sex:getBaseTexture():setUV(setTextureUV_Func(static_Sex, 62, 1, 81, 20))
  end
  static_Sex:setRenderTexture(static_Sex:getBaseTexture())
  staticText_Location:SetText(getExploreNodeName(self._currentNodeInfo:getStaticStatus()))
end
function PaGlobalFunc_WorldMap_Stable_GetShow()
  return Panel_Worldmap_Stable:GetShow()
end
function PaGlobalFunc_WorldMap_Stable_SetShow(isShow, isAni)
  Panel_Worldmap_Stable:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_Stable_Open()
  local self = Window_WorldMap_StableInfo
  if true == PaGlobalFunc_WorldMap_Stable_GetShow() then
    return
  end
  local waypointKey = self._currentNodeInfo:getPlantKey():getWaypointKey()
  local nodeServantCount = stable_countFromWaypointKey(waypointKey)
  if nodeServantCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_STABLE_NOTHAVEVIHICLE"))
    return
  else
    self:SetStable()
    PaGlobalFunc_WorldMap_TopMenu_Close()
    PaGlobalFunc_WorldMap_RightMenu_Close()
    PaGlobalFunc_WorldMap_RingMenu_Close()
  end
  PaGlobalFunc_WorldMap_Stable_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_Stable_Close()
  if false == PaGlobalFunc_WorldMap_Stable_GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_Stable_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_Stable_luaLoadComplete()
  local self = Window_WorldMap_StableInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_Stable_luaLoadComplete")
