local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
Panel_Win_Worldmap_NodeWarInfo:SetShow(false)
local nodeWarInfoUIPool = {}
local toolTip = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_Help")
local ing
local duringWarTitle = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_DuringTheWar")
local endTheWarTitle = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_EndTheWar")
local closeBTN = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "Button_Win_Close")
toolTip:SetShow(false)
toolTip:SetAutoResize(true)
toolTip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
duringWarTitle:addInputEvent("Mouse_On", "NodeWarScoreIconToolTip( true, \"find\")")
duringWarTitle:addInputEvent("Mouse_Out", "NodeWarScoreIconToolTip( false )")
endTheWarTitle:addInputEvent("Mouse_On", "NodeWarScoreIconToolTip( true, \"all\" )")
endTheWarTitle:addInputEvent("Mouse_Out", "NodeWarScoreIconToolTip( false )")
local _buttonQuestion = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"WarInfo\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"WarInfo\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"WarInfo\", \"false\")")
function NodeWarScoreIconToolTip(show, value)
  if true == show then
    if "find" == value then
      toolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_TOOLTIP_ING"))
      toolTip:SetPosX(duringWarTitle:GetPosX() - toolTip:GetTextSizeX())
      toolTip:SetPosY(duringWarTitle:GetPosY() - toolTip:GetSizeY())
      toolTip:SetShow(true)
    else
      toolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_TOOLTIP_END"))
      toolTip:SetPosX(endTheWarTitle:GetPosX() - toolTip:GetTextSizeX())
      toolTip:SetPosY(endTheWarTitle:GetPosY() - toolTip:GetSizeY())
      toolTip:SetShow(true)
    end
  else
    toolTip:SetShow(false)
  end
end
local Templete = {
  nodeWar_Name = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_Name"),
  nodeWar_IngCount = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_IngCount"),
  nodeWar_EndCount = UI.getChildControl(Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_EndCount")
}
local nodeWar_NamePosY = Templete.nodeWar_Name:GetPosY()
local nodeWar_CountPosY = Templete.nodeWar_EndCount:GetPosY()
local siegeIcon = {
  [0] = {
    19,
    170,
    51,
    202
  },
  [1] = {
    154,
    219,
    185,
    250
  }
}
local function chanege_SiegeIcon(control, isBattle)
  if 0 == isBattle then
    control:ChangeTextureInfoName("new_ui_common_forlua/default/default_etc_01.dds")
  else
    control:ChangeTextureInfoName("new_ui_common_forlua/default/default_etc_00.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(control, siegeIcon[isBattle][1], siegeIcon[isBattle][2], siegeIcon[isBattle][3], siegeIcon[isBattle][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local function NodeWarInfo_Init()
  local line_gap = 5
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
      territoryDATA.Name = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_Name_" .. territory_idx)
      CopyBaseProperty(Templete.nodeWar_Name, territoryDATA.Name)
      territoryDATA.Name:SetShow(true)
      territoryDATA.Name:SetPosY(nodeWar_NamePosY)
      territoryDATA.Name:SetText(territoryName)
      chanege_SiegeIcon(territoryDATA.Name, 0)
      territoryDATA.IngCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_IngCount_" .. territory_idx)
      CopyBaseProperty(Templete.nodeWar_IngCount, territoryDATA.IngCount)
      territoryDATA.IngCount:SetShow(true)
      territoryDATA.IngCount:SetPosY(nodeWar_CountPosY)
      territoryDATA.EndCount = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, Panel_Win_Worldmap_NodeWarInfo, "StaticText_NodeWar_EndCount_" .. territory_idx)
      CopyBaseProperty(Templete.nodeWar_EndCount, territoryDATA.EndCount)
      territoryDATA.EndCount:SetShow(true)
      territoryDATA.EndCount:SetPosY(nodeWar_CountPosY)
      nodeWar_NamePosY = nodeWar_NamePosY + territoryDATA.Name:GetSizeY() + 5 + line_gap
      nodeWar_CountPosY = nodeWar_CountPosY + territoryDATA.IngCount:GetSizeY() + 5 + line_gap
      nodeWarInfoUIPool[territory_idx] = territoryDATA
    end
  end
end
function FromClient_NodeWarInfoTentCountUpdate()
  NodeWar_Info_Update()
end
registerEvent("FromClient_KingOrLordTentCountUpdate", "FromClient_NodeWarInfoTentCountUpdate")
function NodeWar_Info_Update()
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
      chanege_SiegeIcon(territoryDATA.Name, 1)
      territoryDATA.Name:SetFontColor(UI_color.C_FFE7E7E7)
      territoryDATA.IngCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWBEINGMINOR", "nowBeingMinor", tostring(nowBeingMinor)))
      territoryDATA.IngCount:SetFontColor(UI_color.C_FF40D7FD)
      territoryDATA.EndCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_NOWENDMINOR", "nowFinishMinor", tostring(nowFinishMinor)))
      territoryDATA.EndCount:SetFontColor(UI_color.C_FFFF4B4B)
    else
      chanege_SiegeIcon(territoryDATA.Name, 0)
      territoryDATA.Name:SetFontColor(UI_color.C_FF626262)
      territoryDATA.IngCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_ING"))
      territoryDATA.IngCount:SetFontColor(UI_color.C_FF626262)
      territoryDATA.EndCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_NODEWARINFO_END"))
      territoryDATA.EndCount:SetFontColor(UI_color.C_FF626262)
    end
  end
end
function FGlobal_NodeWarInfo_Open()
  if Panel_Win_Worldmap_NodeWarInfo:GetShow() then
    return
  end
  Panel_Win_Worldmap_NodeWarInfo:SetSpanSize(5, 75)
  local territoryCount = getTerritoryListByAll()
  if nil == territoryCount then
    return
  end
  territoryCount = math.min(territoryCount, 5)
  local isSiegeBeing_chk = false
  for territory_idx = 0, territoryCount - 1 do
    local territoryKey = getTerritoryByIndex(territory_idx):get()
    local nowBeingMinor = ToClient_GetVillageSiegeCountByTerritory(territoryKey, true)
    if nowBeingMinor > 0 then
      isSiegeBeing_chk = true
    end
  end
  if isSiegeBeing_chk then
    Panel_Win_Worldmap_NodeWarInfo:SetShow(true)
    Panel_Win_Worldmap_WarInfo:SetShow(false)
    NodeWar_Info_Update()
  end
end
function FGlobal_NodeWarInfo_Close()
  if not Panel_Win_Worldmap_NodeWarInfo:GetShow() then
    return
  end
  NodeWarScoreIconToolTip(false)
  Panel_Win_Worldmap_NodeWarInfo:SetShow(false)
end
NodeWarInfo_Init()
