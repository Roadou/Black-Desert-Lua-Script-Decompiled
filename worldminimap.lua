PaGlobal_WorldMiniMap = {
  _ui = {},
  _panelSizeScale = false,
  _isRotate = false,
  _nodeWarRegionName = nil,
  _initialize = false,
  _isAlphaOver = false,
  _alphaMinUnit = 0.05
}
local swapRadar = function(radarType)
  if radarType == true then
    ToClient_setRadorUIPanel(Panel_WorldMiniMap)
    ToClient_updateCameraWorldMiniMap()
    setChangeUiSettingRadarUI(Panel_WorldMiniMap, CppEnums.PAGameUIType.PAGameUIPanel_WorldMiniMap)
  else
    ToClient_setRadorUIPanel(Panel_Radar)
    setChangeUiSettingRadarUI(Panel_Radar, CppEnums.PAGameUIType.PAGameUIPanel_RadarMap)
  end
  ToClient_setRadarType(radarType)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eRadarSwap, radarType, CppEnums.VariableStorageType.eVariableStorageType_User)
  local isShowMap = true
  if true == radarType then
    Panel_WorldMiniMap:SetShow(isShowMap)
    Panel_Radar:SetShow(false)
    FromClient_SetRotateMode(radarMap.isRotateMode)
    FromClient_reSizeWorldMiniMap()
  else
    Panel_WorldMiniMap:SetShow(false)
    Panel_Radar:SetShow(isShowMap)
    setRotateRadarMode(radarMap.isRotateMode)
    Panel_Radar:ComputePos()
  end
  local self = PaGlobal_WorldMiniMap
  self._panelSizeScale = true
  self:changePanelSize()
end
function PaGlobal_changeRadarUI()
  GLOBAL_CHECK_WORLDMINIMAP = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  GLOBAL_CHECK_WORLDMINIMAP = not GLOBAL_CHECK_WORLDMINIMAP
  swapRadar(GLOBAL_CHECK_WORLDMINIMAP)
  PaGlobalFunc_AccesoryQuest_OnScreenResize()
  PaGlobalFunc_BetterEquipment_OnScreenResize()
  PaGlobal_Panel_LocalwarByBalanceServer_Position()
  Panel_PlayerEndurance_Position()
  PaGlobal_BossCamera_Repos()
  FGlobal_ResetRadarUI(false)
end
function FromClient_SetRotateMode(isRotate)
  local self = PaGlobal_WorldMiniMap
  local camRot = getCameraRotation()
  local rot = 0
  if false == isRotate then
    rot = 0
  else
    resetRadarActorListRotateValue()
    rot = math.pi
  end
  self._isRotate = isRotate
  self._ui.static_selfPlayerArrow:SetRotate(rot)
  FGlobal_WorldMiniMap_GuildPinRotateMode(isRotate)
end
function PaGlobal_WorldMiniMap:resetPanelSize()
  local miniMap = ToClient_getWorldMiniMapPanel()
  local iconPath = "new_ui_common_forlua/Widget/Rader/Minimap_01.dds"
  miniMap:SetSize(300, 260)
  Panel_WorldMiniMap:SetSize(300, 260)
  Panel_WorldMiniMap:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - 18)
  self._ui.btn_changeScale:ChangeTextureInfoName(iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 157, 54, 182, 79)
  self._ui.btn_changeScale:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.btn_changeScale:setRenderTexture(self._ui.btn_changeScale:getBaseTexture())
  self._ui.btn_changeScale:ChangeOnTextureInfoName(iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 184, 54, 208, 79)
  self._ui.btn_changeScale:getOnTexture():setUV(x1, y1, x2, y2)
  self._ui.btn_changeScale:ChangeClickTextureInfoName(iconPath)
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 209, 54, 234, 79)
  self._ui.btn_changeScale:getClickTexture():setUV(x1, y1, x2, y2)
  self._ui.btn_changeScale:ComputePos()
  self._ui.static_selfPlayerArrow:ComputePos()
  PaGlobal_WorldMiniMap:setPositionRegionNameList()
  self._panelSizeScale = false
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  else
    FromClient_Widget_FunctionButton_Resize()
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_PlayerEndurance_Position()
    Panel_HorseEndurance_Position()
    Panel_ShipEndurance_Position()
    Panel_CarriageEndurance_Position()
    PaGlobal_Panel_LocalwarByBalanceServer_Position()
  end
end
function PaGlobal_WorldMiniMap:changePanelSize()
  local miniMap = ToClient_getWorldMiniMapPanel()
  if false == Panel_WorldMiniMap:GetShow() then
    return
  end
  local iconPath = "new_ui_common_forlua/Widget/Rader/Minimap_01.dds"
  if true == self._panelSizeScale then
    miniMap:SetSize(302, 263)
    Panel_WorldMiniMap:SetSize(302, 263)
    Panel_WorldMiniMap:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - 18)
    self._ui.btn_changeScale:ChangeTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 157, 54, 182, 79)
    self._ui.btn_changeScale:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.btn_changeScale:setRenderTexture(self._ui.btn_changeScale:getBaseTexture())
    self._ui.btn_changeScale:ChangeOnTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 184, 54, 208, 79)
    self._ui.btn_changeScale:getOnTexture():setUV(x1, y1, x2, y2)
    self._ui.btn_changeScale:ChangeClickTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 209, 54, 234, 79)
    self._ui.btn_changeScale:getClickTexture():setUV(x1, y1, x2, y2)
  else
    miniMap:SetSize(500, 460)
    Panel_WorldMiniMap:SetSize(500, 460)
    Panel_WorldMiniMap:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - 18)
    self._ui.btn_changeScale:ChangeTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 79, 54, 104, 79)
    self._ui.btn_changeScale:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.btn_changeScale:setRenderTexture(self._ui.btn_changeScale:getBaseTexture())
    self._ui.btn_changeScale:ChangeOnTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 105, 54, 130, 79)
    self._ui.btn_changeScale:getOnTexture():setUV(x1, y1, x2, y2)
    self._ui.btn_changeScale:ChangeClickTextureInfoName(iconPath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.btn_changeScale, 131, 54, 156, 79)
    self._ui.btn_changeScale:getClickTexture():setUV(x1, y1, x2, y2)
  end
  self._ui.btn_changeScale:ComputePos()
  self._ui.btn_changeAlphaPlus:ComputePos()
  self._ui.btn_changeAlphaMinus:ComputePos()
  self._ui.static_selfPlayerArrow:ComputePos()
  PaGlobal_WorldMiniMap:setPositionRegionNameList()
  self._panelSizeScale = not self._panelSizeScale
  if false == _ContentsGroup_RemasterUI_Main_RightTop then
    FGlobal_PersonalIcon_ButtonPosUpdate()
  else
    FromClient_Widget_FunctionButton_Resize()
  end
  Panel_PlayerEndurance_Position()
  Panel_HorseEndurance_Position()
  Panel_ShipEndurance_Position()
  Panel_CarriageEndurance_Position()
  PaGlobal_Panel_LocalwarByBalanceServer_Position()
  FromClient_MainQuestWidget_ResetPosition()
  if false == _ContentsGroup_RemasterUI_QuestWidget then
    PaGlobalFunc_Quest_UpdatePosition()
  end
  self:setTimebarSize()
  PaGlobalFunc_BetterEquipment_OnScreenResize()
  PaGlobal_BossCamera_Repos()
  PaGlobalFunc_AccesoryQuest_OnScreenResize()
end
function PaGlobal_WorldMiniMap:setTimebarSize()
  if false == GLOBAL_CHECK_WORLDMINIMAP or false == Panel_WorldMiniMap:GetShow() then
    FGlobal_ResetTimeBar()
  else
    Panel_TimeBar:SetSize(Panel_WorldMiniMap:GetSizeX() + 10, Panel_WorldMiniMap:GetSizeY() + 31)
    Panel_TimeBar:SetPosX(Panel_WorldMiniMap:GetPosX() - 5)
  end
end
function PaGlobal_WorldMiniMap:changePanelAlpha(isIncrease)
  local currentAlphaValue = ToClient_get3DMiniMapAlpha()
  if isIncrease then
    currentAlphaValue = currentAlphaValue + self._alphaMinUnit
  else
    currentAlphaValue = currentAlphaValue - self._alphaMinUnit
  end
  ToClient_set3DMiniMapAlpha(currentAlphaValue)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eRadarAlpha, currentAlphaValue * 100, CppEnums.VariableStorageType.eVariableStorageType_User)
end
function PaGlobal_WorldMiniMap:handleOnEvent(isOver)
  self._ui.sequenceAni:SetShow(isOver)
  self._ui.btn_changeAlphaPlus:SetShow(isOver or self._isAlphaOver)
  self._ui.btn_changeAlphaMinus:SetShow(isOver or self._isAlphaOver)
end
function PaGlobal_WorldMiniMap:alphaBtnOverEvent(isOver)
  self._isAlphaOver = isOver
  self._ui.btn_changeAlphaPlus:SetShow(isOver)
  self._ui.btn_changeAlphaMinus:SetShow(isOver)
  if isOver then
    TooltipSimple_Show(self._ui.btn_changeAlphaPlus, PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMINIMAP_ALPHABUTTON_TOOLTIP"))
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_WorldMiniMap_luaLoadComplete()
  local self = PaGlobal_WorldMiniMap
  if true == _ContentsGroup_3DMiniMapOpen then
    PaGlobal_WorldMiniMap:InitWorldMiniMap()
  else
    self._initialize = false
    return
  end
end
function worldMiniMap_updateRegion(regionData)
  local self = PaGlobal_WorldMiniMap
  self._ui.regionName:SetAutoResize(true)
  self._ui.regionName:SetNotAbleMasking(true)
  local isArenaZone = regionData:get():isArenaZone()
  local isSafetyZone = regionData:get():isSafeZone()
  self._ui.regionName:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui.regionName:useGlowFont(false)
  self._ui.regionNodeName:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui.regionNodeName:useGlowFont(false)
  self._ui.regionWarName:SetFontColor(Defines.Color.C_FFEFEFEF)
  self._ui.regionWarName:useGlowFont(false)
  if isSafetyZone then
    self._ui.regionName:SetFontColor(4292276981)
    self._ui.regionName:useGlowFont(true, "BaseFont_12_Glow", 4281961144)
    self._ui.regionNodeName:SetFontColor(4292276981)
    self._ui.regionNodeName:useGlowFont(true, "BaseFont_8_Glow", 4281961144)
    self._ui.regionWarName:SetFontColor(4292276981)
    self._ui.regionWarName:useGlowFont(true, "BaseFont_8_Glow", 4281961144)
  elseif isArenaZone then
    self._ui.regionName:SetFontColor(4294495693)
    self._ui.regionName:useGlowFont(true, "BaseFont_12_Glow", 4286580487)
    self._ui.regionNodeName:SetFontColor(4294495693)
    self._ui.regionNodeName:useGlowFont(true, "BaseFont_8_Glow", 4286580487)
    self._ui.regionWarName:SetFontColor(4294495693)
    self._ui.regionWarName:useGlowFont(true, "BaseFont_8_Glow", 4286580487)
  else
    self._ui.regionName:SetFontColor(4294495693)
    self._ui.regionName:useGlowFont(true, "BaseFont_12_Glow", 4286580487)
    self._ui.regionNodeName:SetFontColor(4294495693)
    self._ui.regionNodeName:useGlowFont(true, "BaseFont_8_Glow", 4286580487)
    self._ui.regionWarName:SetFontColor(4294495693)
    self._ui.regionWarName:useGlowFont(true, "BaseFont_8_Glow", 4286580487)
  end
  self._ui.regionName:SetText(regionData:getAreaName())
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayerPos = selfPlayerWrapper:get3DPos()
  local linkSiegeWrapper = ToClient_getInstallableVillageSiegeRegionInfoWrapper(selfPlayerPos)
  self._nodeWarRegionName = ""
  if nil ~= linkSiegeWrapper then
    local villageWarZone = linkSiegeWrapper:get():isVillageWarZone()
    if true == villageWarZone then
      self._nodeWarRegionName = linkSiegeWrapper:getvillageSiegeName()
    end
    self._ui.regionName:SetText(regionData:getAreaName())
  end
end
function worldMiniMap_NodeLevelRegionNameShow(wayPointKey)
  local self = PaGlobal_WorldMiniMap
  local nodeName = ToClient_GetNodeNameByWaypointKey(wayPointKey)
  if "" == nodeName or nil == nodeName then
    self._ui.regionNodeName:SetShow(false)
  else
    self._ui.regionNodeName:SetShow(true)
    self._ui.regionNodeName:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RADER_REGIONNODENAME", "getName", nodeName))
    self._ui.regionNodeName:SetSize(self._ui.regionNodeName:GetTextSizeX(), self._ui.regionNodeName:GetSizeY())
    self._ui.regionNodeName:SetPosX(Panel_WorldMiniMap:GetSizeX() - self._ui.regionNodeName:GetSizeX())
    self._ui.regionNodeName:SetPosY(Panel_WorldMiniMap:GetSizeY() - self._ui.regionNodeName:GetSizeY())
    self._ui.regionNodeName:ComputePos()
  end
  if "" == self._nodeWarRegionName or nil == self._nodeWarRegionName then
    self._ui.regionWarName:SetShow(false)
  else
    self._ui.regionWarName:SetShow(true)
    self._ui.regionWarName:SetText(self._nodeWarRegionName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TOOLTIP_VILLAGEWARABLE_NAME"))
    self._ui.regionWarName:SetSize(self._ui.regionWarName:GetTextSizeX(), self._ui.regionWarName:GetSizeY())
    self._ui.regionWarName:SetPosX(Panel_WorldMiniMap:GetSizeX() - self._ui.regionWarName:GetSizeX())
    self._ui.regionWarName:SetPosY(Panel_WorldMiniMap:GetSizeY() - self._ui.regionWarName:GetSizeY())
    self._ui.regionWarName:ComputePos()
  end
end
function PaGlobal_WorldMiniMap:setPositionRegionNameList()
  self._ui.regionName:SetPosX(5)
  self._ui.regionName:SetPosY(5)
  self._ui.regionName:SetSize(self._ui.regionName:GetTextSizeX() + 40, self._ui.regionName:GetSizeY())
  self._ui.regionName:ComputePos()
  self._ui.regionNodeName:SetPosX(Panel_WorldMiniMap:GetSizeX() - self._ui.regionNodeName:GetSizeX())
  self._ui.regionNodeName:SetPosY(Panel_WorldMiniMap:GetSizeY() - self._ui.regionNodeName:GetSizeY())
  self._ui.regionNodeName:ComputePos()
  self._ui.regionWarName:SetPosX(Panel_WorldMiniMap:GetSizeX() - self._ui.regionWarName:GetSizeX())
  self._ui.regionWarName:SetPosY(Panel_WorldMiniMap:GetSizeY() - self._ui.regionWarName:GetSizeY())
  self._ui.regionWarName:ComputePos()
end
function Panel_WorldMiniMap_UpdatePerFrame(deltaTime)
  local self = PaGlobal_WorldMiniMap
  if false == self._isRotate then
    self._ui.static_selfPlayerArrow:SetRotate(getCameraRotation())
  else
  end
  FGlobal_WorldMiniMap_UpdateRadarPin()
  RadarMap_UpdateTerrainInfo()
end
function FromClient_RClickedWorldMiniMap(position, clickActor)
  local self = PaGlobal_WorldMiniMap
  if ToClient_IsShowNaviGuideGroup(0) then
    ToClient_DeleteNaviGuideByGroup(0)
  elseif true == clickActor then
    FromClient_RClickWorldmapPanel(position, true, false)
  else
    if 0 ~= ToClient_GetMyTeamNoLocalWar() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_LOCALWAR_CANTNAVI_ACK"))
      return
    end
    if true == PaGlobal_TutorialManager:isDoingTutorial() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK"))
      FGlobal_QuestWidget_UpdateList()
      return
    end
    ToClient_WorldMapNaviStart(position, NavigationGuideParam(), false, true)
    audioPostEvent_SystemUi(0, 14)
    _AudioPostEvent_SystemUiForXBOX(0, 14)
  end
end
function FromClient_worldMiniMapSetNameOfMouseOverIcon(actorProxyWrapper, targetUI, targetUIposX, targetUIposY)
  local actorName = ""
  if actorProxyWrapper:get():isNpc() then
    if "" ~= actorProxyWrapper:getCharacterTitle() then
      actorName = actorProxyWrapper:getName() .. " " .. actorProxyWrapper:getCharacterTitle()
    else
      actorName = actorProxyWrapper:getName()
    end
  elseif actorProxyWrapper:get():isHouseHold() then
    actorName = getHouseHoldName(actorProxyWrapper:get())
  else
    if actorProxyWrapper:get():isPlayer() then
      local playerActorProxyWrapper = getPlayerActor(actorProxyWrapper:getActorKey())
      if nil ~= playerActorProxyWrapper and playerActorProxyWrapper:get():isVolunteer() then
        return
      end
    end
    actorName = actorProxyWrapper:getName()
  end
  local self = PaGlobal_WorldMiniMap
  targetUIposX = targetUI:GetPosX()
  targetUIposY = targetUI:GetPosY()
  self._ui.static_overName:SetShow(true)
  self._ui.static_overName:SetText(actorName)
  self._ui.static_overName:SetSize(self._ui.static_overName:GetTextSizeX() + 15, self._ui.static_overName:GetTextSizeY() + self._ui.static_overName:GetSpanSize().y)
  Panel_WorldMiniMap:SetChildIndex(self._ui.static_overName, 9999)
  calcPosUseToTextUI(targetUIposX, targetUIposY, self._ui.static_overName)
  self._ui.static_overName:SetDepth(-1000)
end
function calcPosUseToTextUI(targetUIposX, targetUIposY, textUI)
  if Panel_WorldMiniMap:GetSizeX() < targetUIposX + textUI:GetTextSizeX() then
    textUI:SetPosX(Panel_WorldMiniMap:GetSizeX() - textUI:GetTextSizeX())
  else
    textUI:SetPosX(targetUIposX)
  end
  if Panel_WorldMiniMap:GetPosY() > targetUIposY - textUI:GetTextSizeY() then
    textUI:SetPosY(Panel_WorldMiniMap:GetPosY())
  else
    textUI:SetPosY(targetUIposY - textUI:GetTextSizeY())
  end
end
function FromClient_worldMiniMapNameOff()
  local self = PaGlobal_WorldMiniMap
  if nil == self._ui.static_overName then
    return
  end
  if self._ui.static_overName:GetShow() then
    self._ui.static_overName:SetShow(false)
  end
end
function PaGlobal_WorldMiniMap:InitWorldMiniMap()
  ToClient_initializeWorldMiniMap()
  if Panel_WorldMiniMap ~= nil then
    Panel_WorldMiniMap:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - 18)
    Panel_WorldMiniMap:SetPosY(30)
    Panel_WorldMiniMap:SetShow(false)
  end
  self._ui.regionName = UI.getChildControl(Panel_WorldMiniMap, "StaticText_RegionName")
  self._ui.regionName:SetShow(true)
  self._ui.regionNodeName = UI.getChildControl(Panel_WorldMiniMap, "StaticText_RegionNodeName")
  self._ui.regionNodeName:SetShow(true)
  self._ui.regionWarName = UI.getChildControl(Panel_WorldMiniMap, "StaticText_RegionWarName")
  self._ui.regionWarName:SetShow(true)
  PaGlobal_WorldMiniMap:setPositionRegionNameList()
  self._ui.btn_changeScale = UI.getChildControl(Panel_WorldMiniMap, "Button_changeScale")
  self._ui.btn_changeScale:SetShow(true)
  self._ui.btn_changeRadar = UI.getChildControl(Panel_WorldMiniMap, "Button_changeRadar")
  self._ui.btn_changeRadar:SetShow(true)
  self._ui.sequenceAni = UI.getChildControl(Panel_WorldMiniMap, "Static_SequenceAni")
  self._ui.sequenceAni:SetShow(false)
  self._ui.btn_changeAlphaPlus = UI.getChildControl(Panel_WorldMiniMap, "Button_AlphaPlus")
  self._ui.btn_changeAlphaPlus:SetShow(false)
  self._ui.btn_changeAlphaMinus = UI.getChildControl(Panel_WorldMiniMap, "Button_AlphaMinus")
  self._ui.btn_changeAlphaMinus:SetShow(false)
  self._ui.minimap = ToClient_getWorldMiniMapPanel()
  if nil ~= self._ui.minimap then
    self._ui.minimap:addInputEvent("Mouse_On", "PaGlobal_WorldMiniMap:handleOnEvent(true)")
    self._ui.minimap:addInputEvent("Mouse_Out", "PaGlobal_WorldMiniMap:handleOnEvent(false)")
  end
  self._ui.btn_changeScale:addInputEvent("Mouse_LUp", "PaGlobal_WorldMiniMap:changePanelSize()")
  self._ui.btn_changeRadar:addInputEvent("Mouse_LUp", "PaGlobal_changeRadarUI()")
  self._ui.btn_changeAlphaPlus:addInputEvent("Mouse_On", "PaGlobal_WorldMiniMap:alphaBtnOverEvent(true)")
  self._ui.btn_changeAlphaPlus:addInputEvent("Mouse_Out", "PaGlobal_WorldMiniMap:alphaBtnOverEvent(false)")
  self._ui.btn_changeAlphaPlus:addInputEvent("Mouse_LUp", "PaGlobal_WorldMiniMap:changePanelAlpha(true)")
  self._ui.btn_changeAlphaMinus:addInputEvent("Mouse_On", "PaGlobal_WorldMiniMap:alphaBtnOverEvent(true)")
  self._ui.btn_changeAlphaMinus:addInputEvent("Mouse_Out", "PaGlobal_WorldMiniMap:alphaBtnOverEvent(false)")
  self._ui.btn_changeAlphaMinus:addInputEvent("Mouse_LUp", "PaGlobal_WorldMiniMap:changePanelAlpha(false)")
  self._ui.static_selfPlayerArrow = UI.getChildControl(Panel_WorldMiniMap, "Static_SelfPlayerArrow")
  self._ui.static_selfPlayerArrow:SetShow(true)
  self._ui.static_selfPlayerArrow:SetSize(25, 21)
  self._ui.static_selfPlayerArrow:SetPosX()
  Panel_WorldMiniMap:SetChildIndex(self._ui.static_selfPlayerArrow, 9998)
  self._ui.static_selfPlayerArrow:SetDepth(-1000)
  self._ui.static_selfPlayerArrow:ComputePos()
  self._ui.static_overName = UI.getChildControl(Panel_WorldMiniMap, "Static_OverName")
  GLOBAL_CHECK_WORLDMINIMAP = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eRadarSwap)
  local isShow = true
  if false == GLOBAL_CHECK_WORLDMINIMAP then
    if 0 == ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_RadarMap, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
      isShow = false
    end
  elseif 0 == ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_WorldMiniMap, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    isShow = false
  end
  local selfPlayer = getSelfPlayer():get()
  if ToClient_getTutorialLimitLevel() < selfPlayer:getLevel() then
    swapRadar(GLOBAL_CHECK_WORLDMINIMAP)
    FGlobal_Panel_Radar_Show(isShow)
  else
    GLOBAL_CHECK_WORLDMINIMAP = false
    ToClient_setRadorUIPanel(Panel_Radar)
    setChangeUiSettingRadarUI(Panel_Radar, CppEnums.PAGameUIType.PAGameUIPanel_RadarMap)
    ToClient_setRadarType(GLOBAL_CHECK_WORLDMINIMAP)
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eRadarSwap, GLOBAL_CHECK_WORLDMINIMAP, CppEnums.VariableStorageType.eVariableStorageType_User)
    FGlobal_Panel_Radar_Show(isShow)
    ToClient_SaveUiInfo(false)
  end
  PaGlobal_WorldMiniMap:setTimebarSize()
  local radarAlphaValue = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eRadarAlpha)
  if radarAlphaValue > 0 then
    ToClient_set3DMiniMapAlpha(radarAlphaValue / 100)
  end
  Panel_WorldMiniMap:RegisterUpdateFunc("Panel_WorldMiniMap_UpdatePerFrame")
  registerEvent("selfPlayer_regionChanged", "worldMiniMap_updateRegion")
  registerEvent("FromClint_EventChangedExplorationNode", "worldMiniMap_NodeLevelRegionNameShow")
  registerEvent("FromClient_RClickedWorldMiniMap", "FromClient_RClickedWorldMiniMap")
  registerEvent("FromClient_ChangeRadarRotateMode", "FromClient_SetRotateMode")
  PaGlobal_WorldMiniMap._initialize = true
  FromClient_reSizeWorldMiniMap()
end
function FromClient_reSizeWorldMiniMap()
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    if nil ~= Panel_WorldMiniMap then
      Panel_WorldMiniMap:SetShow(false, false)
    end
    if nil ~= Panel_TimeBar then
      Panel_TimeBar:SetShow(false, false)
    end
    if nil ~= Panel_Radar then
      Panel_Radar:SetShow(false, false)
    end
    return
  end
  if true == PaGlobal_WorldMiniMap._initialize and Panel_WorldMiniMap:GetShow() then
    Panel_WorldMiniMap:SetPosX(getScreenSizeX() - Panel_WorldMiniMap:GetSizeX() - 18)
    Panel_WorldMiniMap:ComputePos()
    PaGlobalFunc_BetterEquipment_OnScreenResize()
    PaGlobal_Panel_LocalwarByBalanceServer_Position()
    Panel_PlayerEndurance_Position()
    PaGlobal_BossCamera_Repos()
  end
end
function FGlobal_Panel_WorldMiniMapPosX()
  return Panel_WorldMiniMap:GetPosX()
end
function FGlobal_Panel_WorldMiniMapPosY()
  return Panel_WorldMiniMap:GetPosY()
end
function FGlobal_Panel_WorldMiniMapSizeX()
  return Panel_WorldMiniMap:GetSizeX()
end
function FGlobal_Panel_WorldMiniMapSizeY()
  return Panel_WorldMiniMap:GetSizeY()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_WorldMiniMap_luaLoadComplete")
registerEvent("FromClient_worldMiniMapNameOff", "FromClient_worldMiniMapNameOff")
registerEvent("FromClient_worldMiniMapSetNameOfMouseOverIcon", "FromClient_worldMiniMapSetNameOfMouseOverIcon")
registerEvent("onScreenResize", "FromClient_reSizeWorldMiniMap")
