local ActorProxyType = {isOtherPlayer = 4}
local actorProxyBufferSize = {
  [ActorProxyType.isOtherPlayer] = 300
}
local actorProxyCapacitySize = {
  [ActorProxyType.isOtherPlayer] = 50
}
local basePanel = {
  [ActorProxyType.isOtherPlayer] = Instance_Actor_NameTag_OtherPlayer
}
local function init()
  for _, value in pairs(ActorProxyType) do
    if basePanel[value] then
      ToClient_SetNameTagPanel(value, basePanel[value])
      if nil ~= actorProxyBufferSize[value] and nil ~= actorProxyCapacitySize[value] then
        ToClient_InitializeOverHeadPanelPool(value, actorProxyBufferSize[value], actorProxyCapacitySize[value])
      end
    end
  end
end
init()
local settingTitle = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local actorProxy = actorProxyWrapper:get()
  if false == actorProxy:isPlayer() then
    return
  end
  local nickName = UI.getChildControl(targetPanel, "CharacterTitle")
  if nil == nickName then
    return
  end
  nickName:SetShow(false)
  if false == ToClient_IsPrivateRoomObserver() and false == Requestparty_isPartyPlayer(actorKeyRaw) then
    return
  end
  if actorProxy:isPlayer() then
    local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
    if nil == playerActorProxyWrapper then
      return
    end
    local militiaTeamNo = actorProxy:getVolunteerTeamNoForLua()
    local isMilitia = playerActorProxyWrapper:get():isVolunteer()
    if militiaTeamNo > 0 and true == isMilitia then
      nickName:SetShow(false)
      return
    end
    local vectorC = {
      x,
      y,
      z,
      w
    }
    vectorC = playerActorProxyWrapper:getAllyPlayerColor()
    local allyColor = 4278190080 + math.floor(16711680 * vectorC.x) + math.floor(65280 * vectorC.y) + math.floor(255 * vectorC.z)
    local userName = playerActorProxyWrapper:getUserNickname()
    if 0 < string.len(userName) then
      if 0 < vectorC.w then
        nickName:SetFontColor(4293914607)
        nickName:useGlowFont(false)
        nickName:useGlowFont(true, "BaseFont_10_Glow", allyColor)
      else
        nickName:SetFontColor(4293914607)
        nickName:useGlowFont(false)
        nickName:useGlowFont(true, "BaseFont_10_Glow", 4278190080)
      end
      nickName:SetText(userName)
      nickName:SetShow(true)
    end
  elseif 0 < string.len(actorProxyWrapper:getCharacterTitle()) then
    nickName:SetText(actorProxyWrapper:getCharacterTitle())
    nickName:SetSpanSize(0, 20)
    nickName:SetShow(true)
    nickName:useGlowFont(false)
  end
end
local TypeByLoadData = {
  [ActorProxyType.isOtherPlayer] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
  end
}
function EventActorCreated_NameTag(actorKeyRaw, targetPanel, actorProxyType, actorProxyWrapper)
  if nil ~= TypeByLoadData[actorProxyType] then
    TypeByLoadData[actorProxyType](actorKeyRaw, targetPanel, actorProxyWrapper)
  end
end
function EventPlayerNicknameUpdate(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingTitle(actorKeyRaw, panel, actorProxyWrapper)
end
registerEvent("EventActorCreated", "EventActorCreated_NameTag")
registerEvent("EventPlayerNicknameUpdate", "EventPlayerNicknameUpdate")
registerEvent("ResponseParty_RemovePatyNameTag", "EventPlayerNicknameUpdate")
