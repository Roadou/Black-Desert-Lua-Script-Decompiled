local _panel = Panel_Worldmap_NodeWarInfo_Renew
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local nodeWarInfoUIPool = {}
local Worldmap_NodeWarInfo = {
  _ui = {
    stc_topMenuBg = UI.getChildControl(_panel, "Static_TopMenuBg"),
    stc_contentBg = UI.getChildControl(_panel, "Static_ContentBG"),
    stc_statusTemplate = nil,
    txt_territoryName = nil,
    txt_ingCount = nil,
    txt_endCount = nil,
    txt_ingIcon = nil
  },
  line_gap = 5
}
local self = Worldmap_NodeWarInfo
function Worldmap_NodeWarInfo:init()
  _panel:SetShow(false)
  self._ui.stc_statusTemplate = UI.getChildControl(self._ui.stc_contentBg, "Static_StatusTemplate")
  self._ui.txt_territoryName = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_NodeWar_Name")
  self._ui.txt_ingCount = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_NodeWar_IngCount")
  self._ui.txt_endCount = UI.getChildControl(self._ui.stc_statusTemplate, "StaticText_NodeWar_EndCount")
  self._ui.txt_ingIcon = UI.getChildControl(self._ui.stc_statusTemplate, "Static_NodeWar_Ing_Icon")
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx)
    local territoryName = getTerritoryNameByKey(territoryKey)
    if nil ~= territoryKey then
      local territoryDATA = {}
      local statusTemplate = UI.cloneControl(self._ui.stc_statusTemplate, self._ui.stc_contentBg, "Static_StatusTemplate_" .. territory_idx)
      local templatePosY_Value = (self._ui.stc_statusTemplate:GetSizeY() + self.line_gap) * territory_idx
      statusTemplate:SetPosY(templatePosY_Value)
      territoryDATA.Name = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_NodeWar_Name_" .. territory_idx)
      CopyBaseProperty(self._ui.txt_territoryName, territoryDATA.Name)
      territoryDATA.Name:SetShow(true)
      territoryDATA.Name:SetText(territoryName)
      territoryDATA.IngCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_NodeWar_IngCount_" .. territory_idx)
      CopyBaseProperty(self._ui.txt_ingCount, territoryDATA.IngCount)
      territoryDATA.IngCount:SetShow(true)
      territoryDATA.EndCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, statusTemplate, "StaticText_NodeWar_EndCount_" .. territory_idx)
      CopyBaseProperty(self._ui.txt_endCount, territoryDATA.EndCount)
      territoryDATA.EndCount:SetShow(true)
      territoryDATA.IngIcon = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, statusTemplate, "Static_NodeWar_Ing_Icon_" .. territory_idx)
      CopyBaseProperty(self._ui.txt_ingIcon, territoryDATA.IngIcon)
      territoryDATA.IngIcon:SetShow(true)
      nodeWarInfoUIPool[territory_idx] = territoryDATA
    end
  end
  self:registEventHandler()
  PaGlobal_Worldmap_NodeWarInfo_RePosition()
end
function Worldmap_NodeWarInfo:registEventHandler()
  registerEvent("FromClient_KingOrLordTentCountUpdate", "FromClient_NodeWarInfoTentCount_Update")
  registerEvent("onScreenResize", "PaGlobal_Worldmap_NodeWarInfo_RePosition")
end
function Worldmap_NodeWarInfo:open()
  if _panel:GetShow() then
    return
  end
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  local isSiegeBeing_chk = false
  local warInfoPanel = Panel_WorldMap_WarInfo_Renew
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx):get()
    local nowBeingMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)
    if nowBeingMinor > 0 then
      isSiegeBeing_chk = true
    end
  end
  if isSiegeBeing_chk then
    warInfoPanel:SetShow(false)
    _panel:SetShow(true)
    self:infoUpdate()
  end
end
function Worldmap_NodeWarInfo:close()
  _panel:SetShow(false)
end
function Worldmap_NodeWarInfo:infoUpdate()
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  for territory_idx = 0, territoryCount - 1 do
    local territoryDATA = nodeWarInfoUIPool[territory_idx]
    local territoryKey = getTerritoryByIndex(territory_idx):get()
    local nowBeingMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)
    local nowFinishMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, false)
    if nowBeingMinor > 0 then
      territoryDATA.IngCount:SetText("<PAColor0xfff5ba3a>" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWBEINGMINOR", "nowBeingMinor", tostring(nowBeingMinor)) .. "<PAOldColor>")
      territoryDATA.EndCount:SetText("<PAColor0xffeeeeee>" .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWENDMINOR", "nowFinishMinor", tostring(nowFinishMinor)) .. "<PAOldColor>")
      territoryDATA.Name:SetFontColor(UI_color.C_FFEEEEEE)
      territoryDATA.IngIcon:SetColor(UI_color.C_FFEEEEEE)
    else
      territoryDATA.IngCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_ING"))
      territoryDATA.EndCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_END"))
    end
  end
end
function FromClient_NodeWarInfoTentCount_Update()
  local self = Worldmap_NodeWarInfo
  self.infoUpdate()
end
function PaGlobal_Worldmap_NodeWarInfo_Initialize()
  local self = Worldmap_NodeWarInfo
  self:init()
end
function PaGlobalFunc_WorldMap_NodeWarInfo_Open()
  local self = Worldmap_NodeWarInfo
  self:open()
end
function PaGlobalFunc_WorldMap_NodeWarInfo_Close()
  local self = Worldmap_NodeWarInfo
  self:close()
end
function PaGlobal_Worldmap_NodeWarInfo_RePosition()
  _panel:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Worldmap_NodeWarInfo_Initialize")
