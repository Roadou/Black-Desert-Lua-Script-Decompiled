PIN_TYPE = {
  PIN_PARTY = 0,
  PIN_PARTYMINE = 1,
  PIN_GUILD = 2,
  PIN_GUILDMINE = 3,
  PIN_GUILDMASTER = 4,
  PIN_LAST = 5
}
local _listPing = {}
local _listGuild = {}
local _listParty = {}
local _listGuide = {}
local _listPingIdx = 0
local _listGuildIdx = 0
local _listPartyIdx = 0
local _listGuideIdx = 0
local _listPingMax = 80
local _listGuildMax = 40
local _listPartyMax = 4
local _listGuideMax = 46
local Radar_Mine, Pin_Party, Pin_Party_Mine, Pin_Guild, Pin_Guild_Mine, Pin_Guild_Master, SelfPlayer, Pin_GuideArrow, Ping_Effect
local Pin_FindWay = UI.getChildControl(Instance_Radar, "icon_pin_Findway")
local Pin_FindWay_Arrow = UI.getChildControl(Instance_Radar, "pin_area_Findway")
local RadarSizeX = 0
local RadarSizeY = 0
local SelfPosX = 0
local SelfPosZ = 0
local RadarPixelRate = 0
local FindWay_Info = {findWay_Position = nil, isShow = false}
local function CalcRadarPostionToWorldPostion()
  local posX = getMousePosX() - Instance_Radar:GetPosX()
  local posY = getMousePosY() - Instance_Radar:GetPosY()
  local intervalX = posX - (Radar_Mine:GetPosX() + Radar_Mine:GetSizeX() / 2)
  local intervalZ = Radar_Mine:GetPosY() + Radar_Mine:GetSizeY() / 2 - posY
  intervalX = intervalX * (100 / (radarMap.worldDistanceToPixelRate * 2))
  intervalZ = intervalZ * (100 / (radarMap.worldDistanceToPixelRate * 2))
  local float3Pos = float3(SelfPlayer:getPositionX() + intervalX, 0, SelfPlayer:getPositionZ() + intervalZ)
  return float3Pos
end
function SendPingInfo_ToClient(isAlways)
  if isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_CONTROL) then
    local WorldPos = CalcRadarPostionToWorldPostion()
    ToClient_RequestSendPositionGuide(true, isAlways, true, WorldPos)
  elseif isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_MENU) then
    local WorldPos = CalcRadarPostionToWorldPostion()
    ToClient_RequestSendPositionGuide(false, isAlways, true, WorldPos)
  end
end
function InitPinInRadar()
  Radar_Mine = radarMap.controls.icon_SelfPlayer
  Pin_Party = radarMap.template.icon_PIN_Party
  Pin_Party_Mine = radarMap.template.icon_PIN_PartyMine
  Pin_Guild = radarMap.template.icon_PIN_Guild
  Pin_Guild_Mine = radarMap.template.icon_PIN_GuildMine
  Pin_Guild_Master = radarMap.template.icon_PIN_GuildMaster
  Pin_GuideArrow = radarMap.template.pin_guideArrow
  Ping_Effect = UI.getChildControl(Instance_Radar, "Static_GetthePoint")
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  for i = 0, _listPingMax do
    _listPing[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Ping_Effect" .. tostring(i))
    CopyBaseProperty(Ping_Effect, _listPing[i])
  end
  for i = 0, _listGuildMax do
    _listGuild[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Radar_Guild_" .. tostring(i))
    CopyBaseProperty(Pin_Guild, _listGuild[i])
  end
  for i = 0, _listPartyMax do
    _listParty[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Radar_Party_" .. tostring(i))
    CopyBaseProperty(Pin_Party, _listParty[i])
  end
  for i = 0, _listGuideMax do
    _listGuide[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Instance_Radar, "Radar_Guide_" .. tostring(i))
    CopyBaseProperty(Pin_GuideArrow, _listGuide[i])
  end
end
local function GetPingEffect()
  if _listPingMax < _listPingIdx then
    _listPingIdx = 0
  end
  local control = _listPing[_listPingIdx]
  _listPingIdx = _listPingIdx + 1
  return control
end
local function GetPartyPin()
  if _listPartyMax < _listPartyIdx then
    _listPartyIdx = 0
  end
  local control = _listParty[_listPartyIdx]
  _listPartyIdx = _listPartyIdx + 1
  return control
end
local function GetGuildPin()
  if _listGuildMax < _listGuildIdx then
    _listGuildIdx = 0
  end
  local control = _listGuild[_listGuildIdx]
  _listGuildIdx = _listGuildIdx + 1
  return control
end
local function GetGuideArrow()
  if _listGuideMax < _listGuideIdx then
    _listGuideIdx = 0
  end
  local control = _listGuide[_listGuideIdx]
  _listGuideIdx = _listGuideIdx + 1
  return control
end
local listActorPingParty = {}
local listActorPingGuild = {}
function FromClient_ResponseSendPositionGuideToRadar(PinInfo)
  local SelfPlayerWrapper = getSelfPlayer()
  local SelfPlayer = SelfPlayerWrapper:get()
  if PinInfo._isPermanent == false then
    local controlUI = GetPingEffect()
    controlUI:EraseAllEffect()
    local RadarSizeX = Instance_Radar:GetSizeX()
    local RadarSizeY = Instance_Radar:GetSizeY()
    local pixelRate = RadarMap_GetDistanceToPixelRate() / 100 * 2
    local selfPlayerPosX = SelfPlayer:getPositionX()
    local selfPlayerPosZ = SelfPlayer:getPositionZ()
    local position = PinInfo._position
    local intervalX = (position.x - selfPlayerPosX) * pixelRate
    local intervalZ = (selfPlayerPosZ - position.z) * pixelRate
    local pinPosX = intervalX + RadarSizeX / 2
    local pinPosY = intervalZ + RadarSizeY / 2
    if pinPosX < 0 or pinPosX > RadarSizeX * 0.93 or pinPosY < 0 or pinPosY > RadarSizeY * 0.93 then
      return
    else
      local guideParam = NavigationGuideParam()
      if PinInfo._isForGuild then
        controlUI:AddEffect("UI_WorldMap_Ping01", false, 0, 0)
        guideParam._color = float4(1, 0.8, 0.6, 1)
        guideParam._bgColor = float4(0.6, 0.2, 0.2, 0.3)
        guideParam._beamColor = float4(0.4, 0.15, 0.15, 1)
        if listActorPingParty[PinInfo:getActorKeyRaw()] ~= nil then
          ToClient_DeleteNaviGuide(listActorPingParty[PinInfo:getActorKeyRaw()])
        end
        listActorPingParty[PinInfo:getActorKeyRaw()] = ToClient_AddNavigationBeam(position, guideParam, PinInfo._isTopPicking)
      else
        controlUI:AddEffect("UI_WorldMap_Ping02", false, 0, 0)
        guideParam._color = float4(1, 0.8, 0.6, 1)
        guideParam._bgColor = float4(0.6, 0.2, 0.2, 0.3)
        guideParam._beamColor = float4(0.4, 0.15, 0.15, 1)
        if listActorPingGuild[PinInfo:getActorKeyRaw()] ~= nil then
          ToClient_DeleteNaviGuide(listActorPingGuild[PinInfo:getActorKeyRaw()])
        end
        listActorPingGuild[PinInfo:getActorKeyRaw()] = ToClient_AddNavigationBeam(position, guideParam, PinInfo._isTopPicking)
      end
      controlUI:ResetVertexAni()
      controlUI:SetShow(true)
      controlUI:SetPosX(pinPosX - controlUI:GetSizeX() * 0.5)
      controlUI:SetPosY(pinPosY - controlUI:GetSizeY() * 0.5)
    end
  end
end
function FromClient_PinDelete(deletePathKey)
  for actorKeyRaw, pathKey in pairs(listActorPingParty) do
    if deletePathKey == pathKey then
      listActorPingParty[actorKeyRaw] = nil
      break
    end
  end
  for actorKeyRaw, pathKey in pairs(listActorPingGuild) do
    if deletePathKey == pathKey then
      listActorPingGuild[actorKeyRaw] = nil
      break
    end
  end
end
function FromeClient_RadarPINCreate(PinInfo, control, pinGuideControl, isMine)
  if PinInfo._positionGuideActorType == CppEnums.PositionGuideActorType.ePositionGuideActorType_isGuildMember then
    CopyBaseProperty(Pin_Guild, control)
  elseif PinInfo._positionGuideActorType == CppEnums.PositionGuideActorType.ePositionGuideActorType_isGuildLeader then
    CopyBaseProperty(Pin_Guild_Master, control)
  elseif PinInfo._positionGuideActorType == CppEnums.PositionGuideActorType.ePositionGuideActorType_isGuildMine then
    CopyBaseProperty(Pin_Guild_Mine, control)
  elseif PinInfo._positionGuideActorType == CppEnums.PositionGuideActorType.ePositionGuideActorType_isPartyMember then
    CopyBaseProperty(Pin_Party, control)
  elseif PinInfo._positionGuideActorType == CppEnums.PositionGuideActorType.ePositionGuideActorType_isPartyMine then
    CopyBaseProperty(Pin_Party_Mine, control)
  end
  CopyBaseProperty(Pin_GuideArrow, pinGuideControl)
  local posX = Instance_Radar:GetSizeX() - pinGuideControl:GetSizeX()
  local posY = Instance_Radar:GetSizeY() - pinGuideControl:GetSizeY()
  posX = posX / 2
  posY = posY / 2
  pinGuideControl:SetPosX(posX)
  pinGuideControl:SetPosY(posY)
  ToClient_SetRadarCenterPos(float2(radarMap.pcPosBaseControl.x, radarMap.pcPosBaseControl.y))
end
local PinNaviKey
function FGlobal_ShowFindWayPin(key, pos3D)
  PinNaviKey = key
  FindWay_Info.findWay_Position = float3(pos3D.x, pos3D.y, pos3D.z)
  FindWay_Info.isShow = true
end
function FGlobal_DeleteNaviCheckFindWayPin(key)
  if PinNaviKey == key then
    FGlobal_HideFindWayPin()
  end
end
function FGlobal_HideFindWayPin()
  PinNaviKey = nil
  FindWay_Info.findWay_Position = nil
  FindWay_Info.isShow = false
  Pin_FindWay:SetShow(false)
  Pin_FindWay_Arrow:SetShow(false)
end
function PositionGuideClear()
  _listPartyIdx = 0
  _listGuildIdx = 0
  _listGuideIdx = 0
  Pin_Guild_Master:SetShow(false)
  Pin_Guild_Mine:SetShow(false)
  Pin_Party_Mine:SetShow(false)
  for index = _listPartyIdx, _listPartyMax do
    _listParty[index]:SetShow(false)
  end
  for index = _listGuildIdx, _listGuildMax do
    _listGuild[index]:SetShow(false)
  end
  for index = _listGuideIdx, _listGuideMax do
    _listGuide[index]:SetShow(false)
  end
end
function FGlobal_PositionGuideSetAlpha(alpha)
  if nil == Pin_Guild_Master then
    return
  end
  Pin_Guild_Master:SetAlpha(alpha)
  Pin_Guild_Mine:SetAlpha(alpha)
  Pin_Party_Mine:SetAlpha(alpha)
  for index = _listPartyIdx, _listPartyMax do
    _listParty[index]:SetAlpha(alpha)
  end
  for index = _listGuildIdx, _listGuildMax do
    _listGuild[index]:SetAlpha(alpha)
  end
  for index = _listGuideIdx, _listGuideMax do
    _listGuide[index]:SetAlpha(alpha)
  end
end
function FromClient_PositionGuildDeleteToRadar(pinInfo)
  PositionGuideClear()
end
function FGlobal_CommonPinUpdate(pos3D, pinControl, arrowControl, center)
  local pcInfo = radarMap.pcInfo
  local selfPlayerPos = float3(pcInfo.position.x, pcInfo.position.y, pcInfo.position.z)
  local intervalX = (pos3D.x - SelfPosX) * RadarPixelRate
  local intervalZ = (SelfPosZ - pos3D.z) * RadarPixelRate
  local pinPosX = intervalX + RadarSizeX / 2
  local pinPosY = intervalZ + RadarSizeY / 2
  if pinPosX < 0 or pinPosX + pinControl:GetSizeX() > RadarSizeX * 0.93 or pinPosY < 0 or pinPosY > RadarSizeY * 0.93 then
    pinControl:SetShow(false)
    local dx = SelfPosX - pos3D.x
    local dy = SelfPosZ - pos3D.z
    local radian = math.atan2(dx, dy)
    local guidePosX = RadarSizeX - arrowControl:GetSizeX()
    local guidePosY = RadarSizeY - arrowControl:GetSizeY()
    arrowControl:SetPosX(guidePosX / 2)
    arrowControl:SetPosY(guidePosY / 2)
    arrowControl:SetShow(true)
    arrowControl:SetRotate(radian)
    pinControl:SetShow(false)
    if false == ToClient_IsViewSelfPlayer(selfPlayerPos) then
      arrowControl:SetShow(false)
    end
  else
    if center then
      pinControl:SetPosX(pinPosX - pinControl:GetSizeX() / 2)
    else
      pinControl:SetPosX(pinPosX)
    end
    pinControl:SetPosY(pinPosY - pinControl:GetSizeY())
    pinControl:SetShow(true)
    arrowControl:SetShow(false)
  end
end
function FGlobal_updateFindWayPin()
  if FindWay_Info.findWay_Position == nil or FindWay_Info.isShow == false then
    return
  end
  FGlobal_CommonPinUpdate(FindWay_Info.findWay_Position, Pin_FindWay, Pin_FindWay_Arrow, true)
  if radarMap.isRotateMode then
    Pin_FindWay:SetRotate(getCameraRotation() + math.pi)
  end
end
local PGAT = CppEnums.PositionGuideActorType
function FGlobal_UpdateGuildnPartyPin()
  local positionGuideCount = ToClient_RequestGetPositionGuideCount()
  if positionGuideCount < 1 then
    return
  end
  PositionGuideClear()
  local positionGuide, pinUI, pinGuideUI
  local camRot = getCameraRotation()
  for idx = 0, positionGuideCount - 1 do
    positionGuide = ToClient_GetPositionGuideAtIndex(idx)
    if nil == positionGuide then
      return
    end
    if positionGuide._positionGuideActorType == PGAT.ePositionGuideActorType_isGuildMember then
      pinUI = GetGuildPin()
    elseif positionGuide._positionGuideActorType == PGAT.ePositionGuideActorType_isGuildMaster then
      pinUI = Pin_Guild_Master
    elseif positionGuide._positionGuideActorType == PGAT.ePositionGuideActorType_isGuildMine then
      pinUI = Pin_Guild_Mine
    elseif positionGuide._positionGuideActorType == PGAT.ePositionGuideActorType_isPartyMine then
      pinUI = Pin_Party_Mine
    elseif positionGuide._positionGuideActorType == PGAT.ePositionGuideActorType_isPartyMember then
      pinUI = GetPartyPin()
    end
    pinGuideUI = GetGuideArrow()
    local position = positionGuide._position
    FGlobal_CommonPinUpdate(position, pinUI, pinGuideUI, false)
    if radarMap.isRotateMode then
      pinUI:SetRotate(camRot + math.pi)
    end
  end
end
function FGlobal_GuildPinRotateMode(isRotateMode)
  GetGuildPin():SetParentRotCalc(isRotateMode)
  GetPartyPin():SetParentRotCalc(isRotateMode)
  Pin_Party_Mine:SetParentRotCalc(isRotateMode)
  Pin_Guild_Master:SetParentRotCalc(isRotateMode)
  Pin_Guild_Mine:SetParentRotCalc(isRotateMode)
end
function FGlobal_UpdateRadarPin()
  SelfPlayerWrapper = getSelfPlayer()
  if nil == SelfPlayerWrapper then
    return
  end
  SelfPlayer = SelfPlayerWrapper:get()
  RadarSizeX = Instance_Radar:GetSizeX()
  RadarSizeY = Instance_Radar:GetSizeY()
  RadarPixelRate = RadarMap_GetDistanceToPixelRate() / 100 * 2
  SelfPosX = SelfPlayer:getPositionX()
  SelfPosZ = SelfPlayer:getPositionZ()
  FGlobal_UpdateGuildnPartyPin()
  FGlobal_updateFindWayPin()
end
function resetPinRotate()
  Pin_FindWay:SetRotate(0)
  Pin_FindWay_Arrow:SetRotate(0)
end
function FGlobal_PinRotateMode(isRotateMode)
  Pin_FindWay:SetParentRotCalc(isRotateMode)
  Pin_FindWay_Arrow:SetParentRotCalc(isRotateMode)
end
InitPinInRadar()
registerEvent("FromClient_ResponseSendPositionGuide", "FromClient_ResponseSendPositionGuideToRadar")
registerEvent("FromeClient_RadarPINCreate", "FromeClient_RadarPINCreate")
registerEvent("FromClient_PositionGuildDelete", "FromClient_PositionGuildDeleteToRadar")
registerEvent("FromClient_StartNavigationGuide", "FGlobal_ShowFindWayPin")
registerEvent("FromClient_DeleteNavigationGuide", "FGlobal_DeleteNaviCheckFindWayPin")
registerEvent("FromClient_DeleteNavigationGuide", "FromClient_PinDelete")
registerEvent("FromClient_ClearNavigationGuide", "FGlobal_HideFindWayPin")
