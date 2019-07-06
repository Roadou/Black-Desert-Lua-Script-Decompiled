local _panel = Instance_Window_Map
local BR_MiniMap = {
  isShow = false,
  eIndexType = {
    backMapPanel = 1,
    blackBackImage = 2,
    mapPanel = 3,
    iconPlayer = 5,
    mapLineNext = 7,
    mapLineCurrent = 8
  },
  eResizeState = {
    non = 0,
    zone100 = 1,
    zone50 = 2,
    zone25 = 3
  },
  _config = {
    strCurrentLine = {
      "renewal/PcRemaster/Remaster_BattleRoyal_KillZone100.dds",
      "renewal/PcRemaster/Remaster_BattleRoyal_KillZone50.dds",
      "renewal/PcRemaster/Remaster_BattleRoyal_KillZone25.dds"
    },
    strNextLine = {
      "renewal/PcRemaster/Remaster_BattleRoyal_SafeZone100.dds",
      "renewal/PcRemaster/Remaster_BattleRoyal_SafeZone50.dds",
      "renewal/PcRemaster/Remaster_BattleRoyal_SafeZone25.dds"
    },
    uvLine = {
      {
        x1 = 0,
        x2 = 256,
        y1 = 0,
        y2 = 256
      },
      {
        x1 = 0,
        x2 = 600,
        y1 = 0,
        y2 = 600
      },
      {
        x1 = 0,
        x2 = 326,
        y1 = 0,
        y2 = 326
      },
      {
        x1 = 0,
        x2 = 101,
        y1 = 0,
        y2 = 101
      }
    },
    currentLineOffset = 0.04,
    nextLineOffset = 0.05
  },
  _ui = {
    stc_mapImage = {},
    stc_backMapImage = {},
    stc_mapLineCurrent = UI.getChildControl(_panel, "static_mapLine_current"),
    stc_mapLineNext = UI.getChildControl(_panel, "static_mapLine_next"),
    stc_iconPlayer = UI.getChildControl(_panel, "static_icon_selfPlayer"),
    stc_iconPartyMember = {},
    stc_textMemberName = {}
  },
  _maxMapWcount = 10,
  _maxMapHcount = 10,
  _minimapSize = int2(0, 0),
  _resizeMinimapSize = int2(0, 0),
  _miniSectorSize = int2(0, 0),
  _playerIconBasePos = int2(0, 0),
  _sectorIndex = {},
  _sectorStartPos = {},
  _beforePlayerPos = int3(0, 0, 0),
  _beforeSector = int3(0, 0, 0),
  _beforeSectorIndex = 0,
  _beforeRotate = 0,
  _beforeSector_LB = int2(0, 0),
  _beforeSector_RT = int2(0, 0),
  _ratio = {x = 0, y = 0},
  _lostRegionInfo = {
    currentPos = float2(0, 0),
    currentRadius = 9999999,
    nextPos = float2(0, 0),
    nextRadius = 9999999,
    isCallNextRegion = false
  },
  _partyMemberInfo = {
    count = 0,
    maxCount = 3,
    _beforeSector = {},
    _beforeSectorIndex = 0,
    _beforeMemberPos = {}
  },
  _calculateSectorSize = 128,
  _sectorRatio = 0.01,
  _clientSectorSize = 12800,
  _offsetX = 5,
  _offsetY = 5,
  _lostRegionDeltaTime = 0,
  _lostRegionRefreshTime = 1,
  _radar_type_boos = 5,
  _sizeScale = 1,
  _eResizeState = 0
}
local Ping = {
  _listPingMax = 80,
  _listPingIdx = 0,
  _listPing = {}
}
function Ping:initialize()
  local Ping_Effect = UI.getChildControl(Instance_Window_Map, "Static_GetthePoint")
  for i = 0, self._listPingMax do
    self._listPing[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Window_Map, "Ping_Effect" .. i)
    CopyBaseProperty(Ping_Effect, self._listPing[i])
  end
end
function Ping:getPingEffect()
  if self._listPingMax < self._listPingIdx then
    self._listPingIdx = 0
  end
  local control = self._listPing[self._listPingIdx]
  self._listPingIdx = self._listPingIdx + 1
  return control
end
function Ping:addPing(pinPosX, pinPosY)
  local controlUI = self:getPingEffect()
  controlUI:EraseAllEffect()
  controlUI:AddEffect("UI_WorldMap_Ping02", false, 0, 0)
  controlUI:ResetVertexAni()
  controlUI:SetShow(true)
  controlUI:SetPosX(pinPosX - controlUI:GetSizeX() * 0.5)
  controlUI:SetPosY(pinPosY - controlUI:GetSizeY() * 0.5)
end
function BR_MiniMap:initialize()
  self._ui.stc_backImg = UI.getChildControl(_panel, "static_radar_Background")
  self._minimapSize.x = self._ui.stc_backImg:GetSizeX()
  self._minimapSize.y = self._ui.stc_backImg:GetSizeY()
  self._ui.stc_backMapImagePanel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_backImg, "Static_minimap_BackImagePanel")
  self._ui.stc_BackBlackBG = UI.getChildControl(_panel, "Static_BackBlackBg")
  self._ui.stc_backImg:AddChild(self._ui.stc_BackBlackBG)
  _panel:RemoveControl(self._ui.stc_BackBlackBG)
  self._ui.stc_mapImagePanel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_backImg, "Static_minimap_ImagePanel")
  self:createMinimap()
  self:resizeMinimap(self:getSizeScale())
  self._ui.stc_mapLineCurrent:SetShow(false)
  self._ui.stc_mapLineNext:SetShow(false)
  self._ui.stc_backImg:AddChild(self._ui.stc_mapLineNext)
  self._ui.stc_backImg:AddChild(self._ui.stc_mapLineCurrent)
  self._ui.stc_backImg:AddChild(self._ui.stc_iconPlayer)
  _panel:RemoveControl(self._ui.stc_mapLineNext)
  _panel:RemoveControl(self._ui.stc_mapLineCurrent)
  _panel:RemoveControl(self._ui.stc_iconPlayer)
  for i = 0, self._partyMemberInfo.maxCount do
    local partyMemeber = UI.getChildControl(_panel, "Static_icon_PartyMember_" .. i)
    self._ui.stc_backImg:AddChild(partyMemeber)
    _panel:RemoveControl(partyMemeber)
    partyMemeber:SetShow(false)
    self._ui.stc_iconPartyMember[i] = partyMemeber
    self._ui.stc_textMemberName[i] = UI.getChildControl(partyMemeber, "StaticText_Name_" .. i)
  end
  _panel:SetChildIndex(self._ui.stc_backImg, 10)
  self._ui.stc_backImg:SetRectClipOnArea(float2(0, 0), float2(self._minimapSize.x, self._minimapSize.y))
  Ping:initialize()
  self:registEventHandler()
end
function BR_MiniMap:registEventHandler()
  _panel:RegisterUpdateFunc("PaGlobalFunc_BR_MiniMap_UpdatePerFrame")
  registerEvent("FromClinet_LostRegionInfo", "FromClinet_BR_MiniMap_LostRegionInfo")
  registerEvent("FromClient_ResponseSendPositionGuide", "FromClient_BR_MiniMap_ResponseSendPositionGuide")
end
function BR_MiniMap:open()
  if _panel:GetShow() == true then
    self:close()
    return
  end
  self:refreshLostRegionInfo()
  _panel:SetShow(true)
  self.isShow = true
  audioPostEvent_SystemUi(1, 21)
  _AudioPostEvent_SystemUiForXBOX(1, 21)
end
function BR_MiniMap:close()
  _panel:SetShow(false)
  self.isShow = false
  audioPostEvent_SystemUi(1, 22)
  _AudioPostEvent_SystemUiForXBOX(1, 22)
end
function BR_MiniMap:update()
end
function BR_MiniMap:setDefaultInfo(mapImage, indexX, indexY)
  mapImage:SetIgnore(false)
  mapImage:SetColor(Defines.Color.C_FFFFFFFF)
  mapImage:SetAlpha(0.78)
  mapImage:SetSize(self._miniSectorSize.x, self._miniSectorSize.y)
  self:setImagePos(mapImage, indexX, indexY, 0, 0)
end
function BR_MiniMap:updatePlayerPos(deltaTime, isUpdateNow)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local playerPos = selfPlayer:get():getPosition()
  local cameraRot = getCameraRotation()
  if false == isUpdateNow and playerPos.x == self._beforePlayerPos.x and playerPos.z == self._beforePlayerPos.z and cameraRot == self._beforeRotate then
    return
  end
  local sector = convertPosToSector(playerPos)
  if sector.x ~= self._beforeSector.x or sector.z ~= self._beforeSector.z then
    if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
      return
    end
    self._beforeSector = sector
    self._beforeSectorIndex = self._sectorIndex[sector.x][sector.z]
  end
  self._beforePlayerPos = playerPos
  self._beforeRotate = cameraRot
  local inSectorPos = convertPosToInSectorPos(playerPos)
  local pos = self:getMinimapPos(self.eIndexType.iconPlayer, self._beforeSectorIndex, inSectorPos)
  if nil == pos then
    return
  end
  self._ui.stc_iconPlayer:SetPosXY(pos.x, pos.y)
  self._ui.stc_iconPlayer:SetRotate(cameraRot)
end
function BR_MiniMap:createMinimap()
  local sectorNo_LB = ToClient_GetInstanceSectorNo(0)
  local sectorNo_RT = ToClient_GetInstanceSectorNo(1)
  if self._beforeSector_LB.x == sectorNo_LB.x and self._beforeSector_LB.y == sectorNo_LB.y and self._beforeSector_RT.x == sectorNo_RT.x and self._beforeSector_RT.y == sectorNo_RT.y then
    return
  end
  self._beforeSector_LB = sectorNo_LB
  self._beforeSector_RT = sectorNo_RT
  local startX = sectorNo_LB.x
  local startY = sectorNo_RT.y
  local heightIndex = 0
  local imageIndex = 0
  local widthSize = 0
  local heightSize = 0
  local i = 0
  local j = 0
  local radarPath = ToClient_getRadarPath() .. "Rader_"
  while startX <= sectorNo_RT.x do
    heightIndex = i * heightSize
    heightSize = 0
    startY = sectorNo_RT.y
    j = 0
    self._sectorIndex[startX] = {}
    while startY >= sectorNo_LB.y do
      imageIndex = heightIndex + j
      if nil == self._ui.stc_mapImage[imageIndex] then
        self._ui.stc_mapImage[imageIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_mapImagePanel, "Static_minimap_Image_" .. imageIndex)
      end
      if nil == self._ui.stc_backMapImage[imageIndex] then
        self._ui.stc_backMapImage[imageIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_backMapImagePanel, "Static_minimap_BackImage" .. imageIndex)
      end
      local minimap = radarPath .. startX .. "_" .. startY .. ".dds"
      self._ui.stc_mapImage[imageIndex]:ChangeTextureInfoNameForRadarBackground(minimap)
      self._ui.stc_backMapImage[imageIndex]:ChangeTextureInfoNameForRadarBackground(minimap)
      self._sectorIndex[startX][startY] = imageIndex
      heightSize = heightSize + 1
      j = j + 1
      startY = startY - 1
    end
    widthSize = widthSize + 1
    startX = startX + 1
    i = i + 1
  end
  self._maxMapWcount = widthSize
  self._maxMapHcount = heightSize
end
function BR_MiniMap:updateCurrentLostRegionInfo(deltaTime, idUpdateNow)
  if nil == self._ui.stc_mapImagePanel or nil == self._ui.stc_mapLineCurrent then
    return
  end
  self._lostRegionDeltaTime = self._lostRegionDeltaTime + deltaTime
  if self._lostRegionDeltaTime < self._lostRegionRefreshTime then
    return
  end
  self._lostRegionDeltaTime = 0
  local pos = ToClient_GetCurrentRegionCenter()
  local radius = ToClient_GetCurrentRegionRadius()
  if false == idUpdateNow and pos.x == self._lostRegionInfo.currentPos.x and pos.y == self._lostRegionInfo.currentPos.y and radius == self._lostRegionInfo.currentRadius then
    return
  end
  self._lostRegionInfo.currentPos = pos
  self._lostRegionInfo.currentRadius = radius
  local regionCenter = float3(pos.x, 0, pos.y)
  local sector = convertPosToSector(regionCenter)
  if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
    return
  end
  local sectorIndex = self._sectorIndex[sector.x][sector.z]
  local inSectorPos = convertPosToInSectorPos(regionCenter)
  local mapPanelCenter = self:getMinimapPos(self.eIndexType.mapPanel, sectorIndex, inSectorPos)
  local calRadius = self:getCalculateRadius(radius)
  if nil == mapPanelCenter then
    return
  end
  self._ui.stc_mapImagePanel:SetCircularClipOnArea(mapPanelCenter, calRadius)
  local calculate = self:getMinimapPos(self.eIndexType.mapPanel, sectorIndex, inSectorPos)
  if nil == calculate then
    return
  end
  calRadius = calRadius + calRadius * self._config.currentLineOffset
  local mapLinePos = float2(calculate.x - calRadius, calculate.y - calRadius)
  if false == self._lostRegionInfo.isCallNextRegion then
    self._ui.stc_mapLineNext:SetShow(true)
    self._ui.stc_mapLineCurrent:SetShow(false)
    self._ui.stc_mapLineNext:SetPosXY(mapLinePos.x, mapLinePos.y)
    self._ui.stc_mapLineNext:SetSize(calRadius * 2, calRadius * 2)
    return
  end
  self._ui.stc_mapLineCurrent:SetShow(true)
  self._ui.stc_mapLineCurrent:SetPosXY(mapLinePos.x, mapLinePos.y)
  self._ui.stc_mapLineCurrent:SetSize(calRadius * 2, calRadius * 2)
end
function BR_MiniMap:updateNextLostRegionInfo(idUpdateNow)
  if false == self._lostRegionInfo.isCallNextRegion then
    return
  end
  local pos = ToClient_GetNextRegionCenter()
  local radius = ToClient_GetNextRegionRadius()
  if false == idUpdateNow and pos.x == self._lostRegionInfo.nextPos.x and pos.y == self._lostRegionInfo.nextPos.y and radius == self._lostRegionInfo.nextRadius then
    return
  end
  self._lostRegionInfo.nextPos = pos
  self._lostRegionInfo.nextRadius = radius
  local regionCenter = float3(pos.x, 0, pos.y)
  local sector = convertPosToSector(regionCenter)
  if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
    return
  end
  local sectorIndex = self._sectorIndex[sector.x][sector.z]
  local inSectorPos = convertPosToInSectorPos(regionCenter)
  local calculate = self:getMinimapPos(self.eIndexType.mapPanel, sectorIndex, inSectorPos)
  local calRadius = self:getCalculateRadius(radius)
  if nil == calculate then
    return
  end
  calRadius = calRadius + calRadius * self._config.nextLineOffset
  self._ui.stc_mapLineNext:SetShow(true)
  self._ui.stc_mapLineNext:SetPosXY(calculate.x - calRadius, calculate.y - calRadius)
  self._ui.stc_mapLineNext:SetSize(calRadius * 2, calRadius * 2)
end
function BR_MiniMap:updatePartyMember(deltaTime)
  local memberInfo = self._partyMemberInfo
  local count = FGlobal_PartyMemberCount() - 1
  if count ~= memberInfo.count then
    for i = 0, self._partyMemberInfo.maxCount do
      self._ui.stc_iconPartyMember[i]:SetShow(false)
    end
    memberInfo.count = count
  end
  for i = 0, count do
    if false == RequestParty_isSelfPlayer(i) then
      local memberData = RequestParty_getPartyMemberAt(i)
      if nil ~= memberData then
        local memberPos = float3(memberData:getPositionX(), memberData:getPositionY(), memberData:getPositionZ())
        local sector = convertPosToSector(memberPos)
        if sector.x ~= memberInfo._beforeSector.x or sector.z ~= memberInfo._beforeSector.z then
          if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
            _PA_LOG("\236\178\156\235\167\140\234\184\176", "\235\176\176\237\139\128\235\161\156\236\150\132\236\151\144\236\132\156 \236\130\172\236\154\169\237\149\152\236\167\128 \236\149\138\235\138\148 \236\132\185\237\132\176\236\158\133\235\139\136\235\139\164.")
            return
          end
          memberInfo._beforeSector = sector
          memberInfo._beforeSectorIndex = self._sectorIndex[sector.x][sector.z]
        end
        memberInfo._beforeMemberPos[i] = memberPos
        local inSectorPos = convertPosToInSectorPos(memberPos)
        local pos = self:getMinimapPos(self.eIndexType.iconPlayer, memberInfo._beforeSectorIndex, inSectorPos)
        if nil == pos then
          return
        end
        self._ui.stc_iconPartyMember[i]:SetShow(true)
        self._ui.stc_iconPartyMember[i]:SetPosXY(pos.x, pos.y)
        self._ui.stc_textMemberName[i]:SetText(memberData:name())
      end
    end
  end
end
function BR_MiniMap:getMinimapPos(eIndexType, sectorIndex, inSectorPos)
  if nil == self._sectorStartPos[sectorIndex] then
    return nil
  end
  local pos
  if self.eIndexType.iconPlayer == eIndexType then
    pos = float2(self._sectorStartPos[sectorIndex].x + (self._playerIconBasePos.x + inSectorPos.x * self._sectorRatio * self._ratio.x), self._sectorStartPos[sectorIndex].y + (self._playerIconBasePos.y - inSectorPos.z * self._sectorRatio * self._ratio.y) - self._offsetY * 2)
  elseif self.eIndexType.mapPanel == eIndexType then
    pos = float2(self._sectorStartPos[sectorIndex].x + inSectorPos.x * self._sectorRatio * self._ratio.x, self._sectorStartPos[sectorIndex].y + (self._resizeMinimapSize.y - inSectorPos.z * self._sectorRatio * self._ratio.y) - self._offsetY * 2)
  end
  return pos
end
function BR_MiniMap:getCalculateRadius(regionRadius)
  local radius = regionRadius * self._sectorRatio * self._miniSectorSize.x / self._calculateSectorSize
  return radius + radius * 0.021
end
function BR_MiniMap:refreshLostRegionInfo()
  self:updateCurrentLostRegionInfo(self._lostRegionRefreshTime, true)
  self:updateNextLostRegionInfo(true)
  self:updatePlayerPos(0, true)
end
function BR_MiniMap:resizeMinimap(scale)
  self._sizeScale = scale
  self._resizeMinimapSize.x = self._minimapSize.x * scale
  self._resizeMinimapSize.y = self._minimapSize.y * scale
  self._miniSectorSize.x = self._resizeMinimapSize.x / self._maxMapWcount
  self._miniSectorSize.y = self._resizeMinimapSize.y / self._maxMapHcount
  local widthCount = self._maxMapWcount - 1
  local heightCount = self._maxMapHcount - 1
  for i = 0, widthCount do
    local widthIndex = i * self._maxMapWcount
    for j = 0, heightCount do
      local imageIndex = widthIndex + j
      self:setDefaultInfo(self._ui.stc_mapImage[imageIndex], i, j)
      self:setDefaultInfo(self._ui.stc_backMapImage[imageIndex], i, j)
      self:setSectorStartPos(imageIndex, i, j, 0, 0)
    end
  end
  self._ratio.x = self._miniSectorSize.x / self._calculateSectorSize
  self._ratio.y = self._miniSectorSize.y / self._calculateSectorSize
  local halfSizeX = self._ui.stc_iconPlayer:GetSizeX() * 0.5
  local halfSizeY = self._ui.stc_iconPlayer:GetSizeY() * 0.5
  self._playerIconBasePos.x = -halfSizeX
  self._playerIconBasePos.y = self._resizeMinimapSize.y - halfSizeY
  self:reposition()
end
function BR_MiniMap:reposition()
  local pos = ToClient_GetCurrentRegionCenter()
  local regionCenter = float3(pos.x, 0, pos.y)
  local sector = convertPosToSector(regionCenter)
  if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
    return
  end
  local sectorIndex = self._sectorIndex[sector.x][sector.z]
  local inSectorPos = convertPosToInSectorPos(regionCenter)
  local targetPos = self:getMinimapPos(self.eIndexType.mapPanel, sectorIndex, inSectorPos)
  if nil == targetPos then
    return
  end
  local startPos = self:getStartPos(targetPos)
  local widthCount = self._maxMapWcount - 1
  local heightCount = self._maxMapHcount - 1
  for i = 0, widthCount do
    local widthIndex = i * self._maxMapWcount
    for j = 0, heightCount do
      local imageIndex = widthIndex + j
      self:setImagePos(self._ui.stc_mapImage[imageIndex], i, j, startPos.x, startPos.y)
      self:setImagePos(self._ui.stc_backMapImage[imageIndex], i, j, startPos.x, startPos.y)
      self:setSectorStartPos(imageIndex, i, j, startPos.x, startPos.y)
    end
  end
end
function BR_MiniMap:setImagePos(image, indexX, indexY, startX, startY)
  image:SetPosXY(startX + indexX * self._miniSectorSize.x + self._offsetX, startY + indexY * self._miniSectorSize.y + self._offsetY)
end
function BR_MiniMap:setSectorStartPos(imageIndex, indexX, indexY, startX, startY)
  if nil == self._sectorStartPos[imageIndex] then
    self._sectorStartPos[imageIndex] = {}
  end
  self._sectorStartPos[imageIndex].x = startX + indexX * self._miniSectorSize.x + self._offsetX
  self._sectorStartPos[imageIndex].y = startY - (self._maxMapHcount - indexY) * self._miniSectorSize.y + self._miniSectorSize.y + self._offsetY
end
function BR_MiniMap:getStartPos(pos)
  local maxPos = int2(-(self._resizeMinimapSize.x - self._minimapSize.x), -(self._resizeMinimapSize.y - self._minimapSize.y))
  local ratio = float2(pos.x / self._resizeMinimapSize.x, pos.y / self._resizeMinimapSize.y)
  local value = float2(maxPos.x * ratio.x, maxPos.y * ratio.y)
  return value
end
function BR_MiniMap:getSizeScale()
  local radius = ToClient_GetCurrentRegionRadius()
  local calRadius = self:getCalculateRadius(radius) * 2
  if calRadius > 0 then
    if calRadius < self._minimapSize.x * 0.1 then
      self:setResizeState(self.eResizeState.zone25)
      return 2.3
    elseif calRadius < self._minimapSize.x * 0.25 then
      self:setResizeState(self.eResizeState.zone25)
      return 1.8
    elseif calRadius < self._minimapSize.x * 0.5 then
      self:setResizeState(self.eResizeState.zone50)
      return 1.3
    elseif calRadius < self._minimapSize.x * 0.7 then
      self:setResizeState(self.eResizeState.zone100)
      return 1.1
    end
  end
  self:setResizeState(self.eResizeState.zone100)
  return 1
end
function BR_MiniMap:setResizeState(eState)
  if eState == self._eResizeState then
    return
  end
  self._eResizeState = eState
  self:updateMapLine()
end
function BR_MiniMap:updateMapLine()
  if self.eResizeState.non == self._eResizeState then
    return
  end
  self:setChangeMapLineTexture(self._ui.stc_mapLineCurrent, self._config.strCurrentLine[self._eResizeState], self._config.uvLine[self._eResizeState])
  self:setChangeMapLineTexture(self._ui.stc_mapLineNext, self._config.strNextLine[self._eResizeState], self._config.uvLine[self._eResizeState])
end
function BR_MiniMap:setChangeMapLineTexture(control, texturePath, uvLine)
  if nil == control or nil == texturePath or nil == uvLine then
    return
  end
  control:ChangeTextureInfoName(texturePath)
  control:setRenderTexture(control:getBaseTexture())
end
function BR_MiniMap:addPing(worldPos)
  local sector = convertPosToSector(worldPos)
  if nil == self._sectorIndex[sector.x] or nil == self._sectorIndex[sector.x][sector.z] then
    return
  end
  local sectorIndex = self._sectorIndex[sector.x][sector.z]
  local inSectorPos = convertPosToInSectorPos(worldPos)
  local pos = self:getMinimapPos(self.eIndexType.mapPanel, sectorIndex, inSectorPos)
  if nil == pos then
    return
  end
  Ping:addPing(pos.x, pos.y)
end
function FromClient_BR_MiniMap_Init()
  local self = BR_MiniMap
  self:initialize()
end
function PaGlobalFunc_BR_MiniMap_Open()
  local self = BR_MiniMap
  self:open()
end
function PaGlobalFunc_BR_MiniMap_Close()
  local self = BR_MiniMap
  self:close()
end
function PaGlobalFunc_BR_MiniMap_UpdatePerFrame(deltaTime)
  local self = BR_MiniMap
  self:updatePlayerPos(deltaTime, false)
  self:updateCurrentLostRegionInfo(deltaTime, false)
  self:updatePartyMember(deltaTime)
end
function FromClinet_BR_MiniMap_LostRegionInfo()
  local self = BR_MiniMap
  self._lostRegionInfo.isCallNextRegion = true
  self:resizeMinimap(self:getSizeScale())
  self:updateCurrentLostRegionInfo(self._lostRegionRefreshTime, true)
  self:updateNextLostRegionInfo(false)
end
function FromClient_BR_MiniMap_ResponseSendPositionGuide(PinInfo)
  if true == PinInfo._isPermanent then
    return
  end
  local self = BR_MiniMap
  if false == self.isShow then
    return
  end
  self:addPing(PinInfo._position)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_BR_MiniMap_Init")
