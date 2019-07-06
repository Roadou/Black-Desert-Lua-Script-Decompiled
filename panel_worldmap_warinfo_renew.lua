local _panel = Panel_WorldMap_WarInfo_Renew
local WarInfoUIPool = {}
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local WorldMap_WarInfo = {
  _ui = {
    stc_contentBg = UI.getChildControl(_panel, "Static_ContentBG"),
    stc_statusTemplate = nil,
    txt_territoryName = nil,
    txt_findCount = nil,
    txt_destroyCount = nil,
    txt_allCount = nil
  },
  line_gap = 5
}
local self = WorldMap_WarInfo
function WorldMap_WarInfo:init()
  _panel:SetShow(false)
  self._ui.stc_statusTemplate = UI.getChildControl(self._ui.stc_contentBg, "Static_StatusTemplate")
  self._ui.txt_territoryName = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_Territory_Name")
  self._ui.txt_findCount = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_Territory_FindCount")
  self._ui.txt_destroyCount = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_Territory_DestroyCount")
  self._ui.txt_allCount = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_Territory_AllCount")
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx)
    if toInt64(0, 5) ~= territoryKey then
      local territoryName = getTerritoryNameByKey(territoryKey)
      if nil ~= territoryKey then
        local territoryDATA = {}
        local statusTemplate = UI.cloneControl(self._ui.stc_statusTemplate, self._ui.stc_contentBg, "Static_StatusTemplate_" .. territory_idx)
        local templatePosY_Value = (self._ui.stc_statusTemplate:GetSizeY() + self.line_gap) * territory_idx
        statusTemplate:SetPosY(templatePosY_Value)
        territoryDATA.Name = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Territory_Name_" .. territory_idx)
        CopyBaseProperty(self._ui.txt_territoryName, territoryDATA.Name)
        territoryDATA.Name:SetShow(true)
        territoryDATA.Name:SetText(territoryName)
        territoryDATA.FindCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Territory_FindCount_" .. territory_idx)
        CopyBaseProperty(self._ui.txt_findCount, territoryDATA.FindCount)
        territoryDATA.FindCount:SetShow(true)
        territoryDATA.DestroyCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Territory_DestroyCount_" .. territory_idx)
        CopyBaseProperty(self._ui.txt_destroyCount, territoryDATA.DestroyCount)
        territoryDATA.DestroyCount:SetShow(true)
        territoryDATA.AllCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_Territory_AllCount_" .. territory_idx)
        CopyBaseProperty(self._ui.txt_allCount, territoryDATA.AllCount)
        territoryDATA.AllCount:SetShow(true)
        WarInfoUIPool[territory_idx] = territoryDATA
      end
    end
  end
  self:registEventHandler()
  PaGlobal_Worldmap_WarInfo_RePosition()
end
function WorldMap_WarInfo:registEventHandler()
  registerEvent("FromClient_KingOrLordTentCountUpdate", "FromClient_WorldMap_WarInfoCountUpdate")
  registerEvent("onScreenResize", "PaGlobal_Worldmap_WarInfo_RePosition")
end
function WorldMap_WarInfo:open()
  if _panel:GetShow() then
    return
  end
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  local isSiegeBeing_chk = false
  local nodeWarInfo = Panel_Worldmap_NodeWarInfo_Renew
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx)
    if toInt64(0, 5) ~= territoryKey then
      local isSiegeBeing_Value = isSiegeBeing(territory_idx)
      if isSiegeBeing_Value then
        isSiegeBeing_chk = true
      end
    end
  end
  if isSiegeBeing_chk then
    _panel:SetShow(true)
    nodeWarInfo:SetShow(false)
    self:InfoUpdate()
  else
    PaGlobalFunc_WorldMap_WarInfo_Close()
  end
end
function WorldMap_WarInfo:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_WorldMap_WarInfo_Initialize()
  local self = WorldMap_WarInfo
  self:init()
end
function PaGlobalFunc_WorldMap_WarInfo_Open()
  local self = WorldMap_WarInfo
  self:open()
end
function PaGlobalFunc_WorldMap_WarInfo_Close()
  local self = WorldMap_WarInfo
  self:close()
end
function WorldMap_WarInfo:InfoUpdate()
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  local isSiegeBeing_World = false
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx)
    if toInt64(0, 5) ~= territoryKey then
      local territoryDATA = WarInfoUIPool[territory_idx]
      local count_FindBuildingTent = getCurrentBuildingKingOrLordTentCount(territory_idx)
      if nil == count_FindBuildingTent then
        count_FindBuildingTent = 0
      end
      local count_FindCompleteTent = getCurrentCompleteKingOrLordTentCount(territory_idx)
      if nil == count_FindCompleteTent then
        count_FindCompleteTent = 0
      end
      local count_BuildingTent = getBuildingKingOrLordTentCount(territory_idx)
      local count_CompleteTent = ToClient_GetLeftSiegeGuildCount(territory_idx)
      local isSiegeBeing_Value = isSiegeBeing(territory_idx)
      isSiegeBeing_World = isSiegeBeing_World or isSiegeBeing_Value
      if true == isSiegeBeing_Value then
        territoryDATA.Name:SetFontColor(UI_color.C_FFEEEEEE)
        territoryDATA.Name:SetColor(UI_color.C_FFEEEEEE)
        territoryDATA.FindCount:SetFontColor(UI_color.C_FFEEEEEE)
        territoryDATA.AllCount:SetFontColor(UI_color.C_FFEEEEEE)
        territoryDATA.FindCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_FINDCOUNT1", "count", count_FindCompleteTent))
        territoryDATA.AllCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_ALLCOUNT1", "count", count_CompleteTent))
      else
        territoryDATA.Name:SetFontColor(UI_color.C_FF626262)
        territoryDATA.FindCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_FINDCOUNT2"))
        territoryDATA.AllCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_WARINFO_TEXT_ALLCOUNT2"))
      end
    end
  end
  if not isSiegeBeing_World then
    PaGlobalFunc_WorldMap_WarInfo_Close()
  end
end
function FromClient_WorldMap_WarInfoCountUpdate()
  local self = WorldMap_WarInfo
  self:InfoUpdate()
end
function PaGlobal_Worldmap_WarInfo_RePosition()
  _panel:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_WorldMap_WarInfo_Initialize")
