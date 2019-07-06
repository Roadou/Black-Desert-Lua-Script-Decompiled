local PIN_TYPE = {
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
local RadarSizeX = 0
local RadarSizeY = 0
local SelfPosX = 0
local SelfPosZ = 0
local RadarPixelRate = 0
local FindWay_Info = {findWay_Position = nil, isShow = false}
function FGlobal_WorldMiniMap_InitPinInRadar()
  Pin_Guild = UI.getChildControl(Panel_WorldMiniMap, "icon_pin_Guild")
  Pin_Guild_Mine = UI.getChildControl(Panel_WorldMiniMap, "icon_pin_GuildMine")
  Pin_Guild_Master = UI.getChildControl(Panel_WorldMiniMap, "icon_pin_GuildMaster")
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  for i = 0, _listGuildMax do
    _listGuild[i] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_WorldMiniMap, "Radar_Guild_" .. tostring(i))
    CopyBaseProperty(Pin_Guild, _listGuild[i])
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
function FromClient_WorldMiniMap_ResponseSendPositionGuideToRadar(PinInfo)
end
local PinNaviKey
function WorldMiniMap_PositionGuideClear()
  _listGuildIdx = 0
  Pin_Guild_Master:SetShow(false)
  Pin_Guild_Mine:SetShow(false)
  for index = _listGuildIdx, _listGuildMax do
    _listGuild[index]:SetShow(false)
  end
end
function FromClient_WorldMiniMap_PositionGuildDeleteToRadar(pinInfo)
  WorldMiniMap_PositionGuideClear()
end
local PGAT = CppEnums.PositionGuideActorType
function FGlobal_WorldMiniMap_UpdateGuildnPartyPin()
  local positionGuideCount = ToClient_RequestGetPositionGuideCount()
  if positionGuideCount < 1 then
    return
  end
  WorldMiniMap_PositionGuideClear()
  local positionGuide, pinUI
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
    end
    if nil ~= pinUI then
      pinUI:SetShow(true)
      Panel_WorldMiniMap:SetChildIndex(pinUI, 9999)
      ToClient_WorldminimapPinUpdatePosition(pinUI, positionGuide._position)
    end
  end
end
function FGlobal_WorldMiniMap_GuildPinRotateMode(isRotateMode)
  if nil == GetGuildPin() then
    return
  end
  GetGuildPin():SetParentRotCalc(isRotateMode)
  Pin_Guild_Master:SetParentRotCalc(isRotateMode)
  Pin_Guild_Mine:SetParentRotCalc(isRotateMode)
end
function FGlobal_WorldMiniMap_UpdateRadarPin()
  FGlobal_WorldMiniMap_UpdateGuildnPartyPin()
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_WorldMiniMap_InitPinInRadar")
registerEvent("FromClient_ResponseSendPositionGuide", "FromClient_WorldMiniMap_ResponseSendPositionGuideToRadar")
registerEvent("FromClient_PositionGuildDelete", "FromClient_WorldMiniMap_PositionGuildDeleteToRadar")
