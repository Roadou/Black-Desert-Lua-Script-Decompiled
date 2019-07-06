local radarText = UI.getChildControl(Panel_Radar, "StaticText_radarText")
local radar_Background = UI.getChildControl(Panel_Radar, "radar_Background")
local radar_SizeSlider = UI.getChildControl(Panel_Radar, "Slider_MapSize")
local radar_SizeBtn = UI.getChildControl(radar_SizeSlider, "Slider_MapSize_Btn")
local radar_AlphaScrl = UI.getChildControl(Panel_Radar, "Slider_RadarAlpha")
local radar_AlphaBtn = UI.getChildControl(radar_AlphaScrl, "RadarAlpha_CtrlBtn")
local radar_OverName = UI.getChildControl(Panel_Radar, "Static_OverName")
local radar_MiniMapScl = UI.getChildControl(Panel_Radar, "Button_SizeControl")
radar_Background:SetShowAALineList(true)
ToClient_setColorShowAALineList(float4(1, 1, 1, 1))
radarMap = {
  config = {
    constMapRadius = 60,
    mapRadius = 60,
    mapRadiusByPixel = 80
  },
  controls = {
    radar_Background = UI.getChildControl(Panel_Radar, "radar_Background"),
    icon_SelfPlayer = UI.getChildControl(Panel_Radar, "icon_selfPlayer"),
    timeNum = UI.getChildControl(Panel_TimeBarNumber, "timeNum"),
    radar_Plus,
    radar_Minus,
    radar_AlphaPlus = UI.getChildControl(radar_AlphaScrl, "Button_AlphaPlus"),
    radar_AlphaMinus = UI.getChildControl(radar_AlphaScrl, "Button_AlphaMinus"),
    radar_Reset = UI.getChildControl(Panel_Radar, "Button_RadarViewModeReset"),
    radar_NpcFind_Toggle = UI.getChildControl(Panel_Radar, "Button_NpcFind_Toggle"),
    radar_Close = UI.getChildControl(Panel_Radar, "Button_Win_Close")
  },
  template = {
    icon_Player = UI.getChildControl(Panel_Radar, "icon_player"),
    icon_Party = UI.getChildControl(Panel_Radar, "icon_partyMember"),
    icon_Guild = UI.getChildControl(Panel_Radar, "icon_guildMember"),
    icon_Wind = UI.getChildControl(Panel_Radar, "icon_wind"),
    icon_Horse = UI.getChildControl(Panel_Radar, "icon_horse"),
    icon_DeadBody = UI.getChildControl(Panel_Radar, "icon_deadbody"),
    icon_Monster_general_normal = UI.getChildControl(Panel_Radar, "icon_monsterGeneral_normal"),
    icon_Monster_general_quest = UI.getChildControl(Panel_Radar, "icon_monsterGeneral_quest"),
    icon_Monster_named_normal = UI.getChildControl(Panel_Radar, "icon_monsterNamed_normal"),
    icon_Monster_named_quest = UI.getChildControl(Panel_Radar, "icon_monsterNamed_quest"),
    icon_Monster_boss_normal = UI.getChildControl(Panel_Radar, "icon_monsterBoss_normal"),
    icon_Monster_boss_quest = UI.getChildControl(Panel_Radar, "icon_monsterBoss_quest"),
    icon_Quest_acceptable = UI.getChildControl(Panel_Radar, "icon_quest_accept"),
    icon_Quest_cleared = UI.getChildControl(Panel_Radar, "icon_quest_clear"),
    icon_NPC_lordManager = UI.getChildControl(Panel_Radar, "icon_npc_lordManager"),
    icon_NPC_trainner = UI.getChildControl(Panel_Radar, "icon_npc_skillTrainner"),
    radarType_tradeMerchantNpc = UI.getChildControl(Panel_Radar, "icon_npc_trader"),
    radarType_nodeManager = UI.getChildControl(Panel_Radar, "icon_npc_nodeManager"),
    icon_NPC_talkable = UI.getChildControl(Panel_Radar, "icon_npc_general"),
    icon_NPC_garage = UI.getChildControl(Panel_Radar, "icon_npc_warehouse"),
    icon_NPC_liquidStore = UI.getChildControl(Panel_Radar, "icon_npc_potion"),
    icon_NPC_weaponStore = UI.getChildControl(Panel_Radar, "icon_npc_storeArmor"),
    icon_NPC_armorStore = UI.getChildControl(Panel_Radar, "icon_npc_storeArmor"),
    icon_NPC_horseStable = UI.getChildControl(Panel_Radar, "icon_npc_horse"),
    radarType_workerNpc = UI.getChildControl(Panel_Radar, "icon_npc_worker"),
    radarType_jewelNpc = UI.getChildControl(Panel_Radar, "icon_npc_jewel"),
    radarType_furnitureNpc = UI.getChildControl(Panel_Radar, "icon_npc_furniture"),
    icon_NPC_product = UI.getChildControl(Panel_Radar, "icon_npc_collect"),
    radarType_shipNpc = UI.getChildControl(Panel_Radar, "icon_npc_ship"),
    radarType_alchemyNpc = UI.getChildControl(Panel_Radar, "icon_npc_alchemy"),
    radarType_fishNpc = UI.getChildControl(Panel_Radar, "icon_npc_fish"),
    icon_NPC_itemRepairer = UI.getChildControl(Panel_Radar, "icon_npc_repairer"),
    icon_NPC_unknown = UI.getChildControl(Panel_Radar, "icon_npc_unknown"),
    icon_PIN_Party = UI.getChildControl(Panel_Radar, "icon_pin_Party"),
    icon_PIN_PartyMine = UI.getChildControl(Panel_Radar, "icon_pin_PartyMine"),
    icon_PIN_Guild = UI.getChildControl(Panel_Radar, "icon_pin_Guild"),
    icon_PIN_GuildMine = UI.getChildControl(Panel_Radar, "icon_pin_GuildMine"),
    icon_PIN_GuildMaster = UI.getChildControl(Panel_Radar, "icon_pin_GuildMaster"),
    pin_guideArrow = UI.getChildControl(Panel_Radar, "pin_area_guided"),
    area_quest = UI.getChildControl(Panel_Radar, "quest_area"),
    area_quest_guideArrow = UI.getChildControl(Panel_Radar, "quest_area_guided"),
    area_siegeAttackHit = UI.getChildControl(Panel_Radar, "Static_RedCircle")
  },
  pcInfo = {
    position = {
      x = 0,
      y = 0,
      z = 0
    },
    s64_teamNo = Defines.s64_const.s64_m1
  },
  worldDistanceToPixelRate = 1,
  pcPosBaseControl = {x = 0, y = 0},
  actorIcons = {},
  monsterIcons = {},
  iconPool = Array.new(),
  iconCreateCount = 0,
  areaQuests = {},
  questIconPool = Array.new(),
  questCreateCount = 0,
  iconWindCreateCount = 0,
  iconWind = {},
  iconWindArrow = {},
  regionTypeValue = CppEnums.RegionType.eRegionType_MinorTown,
  scaleRateWidth = 1,
  scaleRateHeight = 1,
  isRotateMode = ToClient_getGameOptionControllerWrapper():getRadarRotateMode()
}
if true == _ContentsGroup_RemasterUI_Radar then
  radarMap.controls.radar_Plus = UI.getChildControl(Panel_Radar, "Button_SizeUp")
  radarMap.controls.radar_Minus = UI.getChildControl(Panel_Radar, "Button_SizeDown")
else
  radarMap.controls.radar_Plus = UI.getChildControl(radar_SizeSlider, "Button_RadarViewModePlus")
  radarMap.controls.radar_Minus = UI.getChildControl(radar_SizeSlider, "Button_RadarViewModeMinus")
end
function FGlobal_Panel_Radar_Show_AddEffect()
  Panel_Radar:SetShow(true)
  radar_Background:AddEffect("UI_Tuto_MiniMap_1", false, 0, 0)
  radar_Background:AddEffect("fUI_Tuto_MiniMap_01A", false, 0, 0)
end
function FGlobal_Panel_Radar_Show(isShow, withAni)
  if false == _ContentsGroup_3DMiniMapOpen or nil == Panel_WorldMiniMap then
    Panel_Radar:SetShow(isShow)
    return
  end
  local worldMiniMapState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  if worldMiniMapState then
    Panel_WorldMiniMap:SetShow(isShow)
  elseif nil ~= withAni then
    Panel_Radar:SetShow(isShow, withAni)
  else
    Panel_Radar:SetShow(isShow)
  end
end
function FGlobal_Panel_Radar_GetShow()
  return Panel_Radar:GetShow()
end
function FGlobal_Panel_Radar_GetSizeX()
  if nil == Panel_WorldMiniMap then
    return Panel_Radar:GetSizeX()
  end
  local sizeX = 0
  local worldMiniMapState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  if worldMiniMapState then
    sizeX = FGlobal_Panel_WorldMiniMapSizeX() + 22
  else
    sizeX = Panel_Radar:GetSizeX()
  end
  return sizeX
end
function FGlobal_Panel_Radar_GetSizeY()
  if nil == Panel_WorldMiniMap then
    return Panel_Radar:GetSizeY()
  end
  local worldMiniMapState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  if worldMiniMapState then
    return FGlobal_Panel_WorldMiniMapSizeY() + 8.5
  else
    return Panel_Radar:GetSizeY()
  end
end
function FGlobal_Panel_Radar_GetSpanSizeX()
  return Panel_Radar:GetSpanSize().x
end
function FGlobal_Panel_Radar_GetSpanSizeY()
  return Panel_Radar:GetSpanSize().y
end
function FGlobal_Panel_Radar_GetPosX()
  if nil == Panel_WorldMiniMap then
    return Panel_Radar:GetPosX()
  end
  local posX = 0
  local worldMiniMapState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  if worldMiniMapState then
    posX = FGlobal_Panel_WorldMiniMapPosX() - 8.5
  else
    posX = Panel_Radar:GetPosX()
  end
  return posX
end
function FGlobal_Panel_Radar_GetPosY()
  if nil == Panel_WorldMiniMap then
    return Panel_Radar:GetPosY()
  end
  local posY = 0
  local worldMiniMapState = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  if worldMiniMapState then
    posY = FGlobal_Panel_WorldMiniMapPosY()
  else
    posY = Panel_Radar:GetPosY()
  end
  return posY
end
function FGlobal_Panel_Radar_Movable_UI()
  local radarText = UI.getChildControl(Panel_Radar, "StaticText_radarText")
  radarText:SetShow(false)
  Panel_Radar:SetIgnore(false)
  Panel_Radar:SetDragEnable(true)
  Panel_Radar:ChangeTextureInfoName("New_UI_Common_forLua/Default/window_sample_isWidget.dds")
  RadarMap_SetDragMode(true)
end
function FGlobal_Panel_Radar_Movable_UI_Cancel()
  local radarText = UI.getChildControl(Panel_Radar, "StaticText_radarText")
  radarText:SetShow(false)
  Panel_Radar:SetIgnore(true)
  Panel_Radar:SetDragEnable(false)
  Panel_Radar:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(Panel_Radar, 102, 60, 110, 68)
  Panel_Radar:getBaseTexture():setUV(x1, y1, x2, y2)
  Panel_Radar:setRenderTexture(Panel_Radar:getBaseTexture())
  RadarMap_SetDragMode(false)
end
