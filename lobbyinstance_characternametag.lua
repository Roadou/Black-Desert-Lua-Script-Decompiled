local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_classType = CppEnums.ClassType
local ActorProxyType = {isOtherPlayer = 4}
local actorProxyBufferSize = {
  [ActorProxyType.isOtherPlayer] = 300
}
local actorProxyCapacitySize = {
  [ActorProxyType.isOtherPlayer] = 50
}
local basePanel = {
  [ActorProxyType.isOtherPlayer] = LobbyInstance_Actor_NameTag_OtherPlayer
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
local guildMarkInit = function(guildMark)
  guildMark:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Buttons.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(guildMark, 183, 1, 188, 6)
  guildMark:getBaseTexture():setUV(x1, y1, x2, y2)
  guildMark:setRenderTexture(guildMark:getBaseTexture())
end
local myMilitiaTeamNo = function()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return -1
  end
  local selfProxy = selfPlayer:get()
  local myTeamNo = selfProxy:getVolunteerTeamNoForLua()
  if myTeamNo >= 1000 then
    return 1
  elseif myTeamNo >= 100 then
    return 0
  else
    return -1
  end
end
local function settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
  local nameTag
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  if actorProxy:isKingOrLordTent() then
    nameTag = UI.getChildControl(targetPanel, "KingsCharacterName")
  elseif actorProxy:isLargeHpBarCharacter() then
    return
  else
    nameTag = UI.getChildControl(targetPanel, "CharacterName")
  end
  if nil == nameTag then
    return
  end
  local characterActorProxyWrapper = getCharacterActor(actorKeyRaw)
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  local isShowForAlli = false
  if actorProxy:isPlayer() and true == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
    isShowForAlli = true
  end
  if actorProxy:isPlayer() and characterActorProxyWrapper:get():isClientAI() or actorProxy:isHiddenName() and false == actorProxy:isVehicle() and false == actorProxy:isFlashBanged() or true == isShowForAlli then
    nameTag:SetShow(false)
    return
  end
  if actorProxy:isPlayer() then
    local militiaIcon = UI.getChildControl(targetPanel, "Static_MilitiaIcon")
    local militiaTeamNo = actorProxy:getVolunteerTeamNoForLua()
    if militiaTeamNo >= 1000 then
      if nil ~= playerActorProxyWrapper then
        local isMilitia = playerActorProxyWrapper:get():isVolunteer()
        if isMilitia then
          militiaIcon:SetShow(true)
          militiaIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Window/PvP/Militia_01.dds")
          if 0 == myMilitiaTeamNo() then
            local x1, y1, x2, y2 = setTextureUV_Func(militiaIcon, 160, 193, 195, 235)
            militiaIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          else
            local x1, y1, x2, y2 = setTextureUV_Func(militiaIcon, 88, 193, 123, 235)
            militiaIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          end
          militiaIcon:setRenderTexture(militiaIcon:getBaseTexture())
          nameTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_MILITIADEFFENCE"))
          nameTag:SetShow(true)
          return
        end
      end
    elseif militiaTeamNo >= 100 then
      if nil ~= playerActorProxyWrapper then
        local isMilitia = playerActorProxyWrapper:get():isVolunteer()
        if isMilitia then
          militiaIcon:SetShow(true)
          militiaIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Window/PvP/Militia_01.dds")
          if 0 == myMilitiaTeamNo() then
            local x1, y1, x2, y2 = setTextureUV_Func(militiaIcon, 196, 193, 231, 235)
            militiaIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          else
            local x1, y1, x2, y2 = setTextureUV_Func(militiaIcon, 124, 193, 159, 235)
            militiaIcon:getBaseTexture():setUV(x1, y1, x2, y2)
          end
          militiaIcon:setRenderTexture(militiaIcon:getBaseTexture())
          nameTag:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_MILITIAATTACK"))
          nameTag:SetShow(true)
          return
        end
      end
    else
      militiaIcon:SetShow(false)
    end
  end
  if actorProxy:isHouseHold() then
    local houseActorWarpper = getHouseHoldActor(actorKeyRaw)
    local isMine = houseActorWarpper:get():isOwnedBySelfPlayer()
    local isMyGuild = houseActorWarpper:get():isOwnedBySelfPlayerGuild()
    local isPersonalTent = houseActorWarpper:get():isPersonalTent()
    local isSiegeTent = houseActorWarpper:get():isKingOrLordTent()
    if isMine and isPersonalTent then
      local tentWrapper = getTemporaryInformationWrapper():getSelfTentWrapperByActorKeyRaw(actorKeyRaw)
      if nil ~= tentWrapper then
        local expireTime = tentWrapper:getSelfTentExpiredTime_s64()
        local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
        textName = getHouseHoldName(actorProxy)
        targetPanel:Set3DRotationY(actorProxy:getRotation())
      end
    elseif isMyGuild and isSiegeTent then
      local expireTime = houseActorWarpper:get():getExpiredTime()
      local lefttimeText = convertStringFromDatetime(getLeftSecond_TTime64(expireTime))
      textName = getHouseHoldName(actorProxy)
      targetPanel:Set3DRotationY(actorProxy:getRotation())
    else
      textName = getHouseHoldName(actorProxy)
      targetPanel:Set3DRotationY(actorProxy:getRotation())
    end
  elseif actorProxy:isInstallationActor() then
    textName = actorProxy:getStaticStatusName()
    local installationActorWrapper = getInstallationActor(actorKeyRaw)
    if toInt64(0, 0) ~= installationActorWrapper:getOwnerHouseholdNo_s64() and installationActorWrapper:isHavestInstallation() then
      local rate = installationActorWrapper:getHarvestTotalGrowRate() * 100
      if rate < 0 then
        rate = 0
      end
      textName = installationActorWrapper:get():getStaticStatusName() .. " - (<PAColor0xFFffd429>" .. tostring(math.floor(rate)) .. "%<PAOldColor>)"
    end
  elseif isNpcWorker(actorProxy) then
    textName = getNpcWorkerOwnerName(actorProxy)
  elseif actorProxy:isSelfPlayer() then
    local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
    if false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
      nameTag:SetMonoTone(true)
    elseif false == playerActorProxyWrapper:get():isFlashBanged() and true == playerActorProxyWrapper:get():isConcealCharacter() then
      nameTag:SetMonoTone(true)
    else
      nameTag:SetMonoTone(false)
    end
    local level = playerActorProxyWrapper:get():getLevel()
    textName = playerActorProxyWrapper:getName()
  elseif actorProxy:isPlayer() then
    local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
    if false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
      nameTag:SetMonoTone(true)
    elseif false == playerActorProxyWrapper:get():isFlashBanged() and true == playerActorProxyWrapper:get():isConcealCharacter() then
      nameTag:SetMonoTone(true)
    else
      nameTag:SetMonoTone(false)
    end
    local level = playerActorProxyWrapper:get():getLevel()
    if nil == getSelfPlayer() then
      return
    end
    local selfPlayerLevel = getSelfPlayer():get():getLevel()
    textName = actorProxyWrapper:getName()
  elseif actorProxy:isInstanceObject() then
    if actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isTrap() then
      nameTag:SetShow(false)
      return
    end
    textName = actorProxyWrapper:getName()
  elseif actorProxy:isNpc() then
    textName = actorProxyWrapper:getName()
    local isFusionCore = actorProxy:getCharacterStaticStatus():isFusionCore()
    if true == isFusionCore then
      local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
      if npcActorProxyWrapper:getTeamNo_s64() == getSelfPlayer():getTeamNo_s64() then
        textName = textName
      else
        textName = ""
      end
    end
  elseif actorProxy:isVehicle() then
    textName = actorProxyWrapper:getName()
  else
    textName = actorProxyWrapper:getName()
  end
  nameTag:SetText(textName)
  nameTag:SetShow(true)
end
local settingAlias = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local aliasInfo = UI.getChildControl(targetPanel, "CharacterAlias")
  if nil == aliasInfo then
    return
  end
  local actorProxy = playerActorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  if actorProxy:isPlayer() then
    local militiaTeamNo = actorProxy:getVolunteerTeamNoForLua()
    local isMilitia = actorProxy:isVolunteer()
    if militiaTeamNo > 0 and true == isMilitia then
      aliasInfo:SetShow(false)
      return
    end
  end
  if actorProxy:isPlayer() then
    if playerActorProxyWrapper:checkToTitleKey() then
      aliasInfo:SetText(playerActorProxyWrapper:getTitleName())
      if false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
        aliasInfo:SetMonoTone(true)
      elseif false == playerActorProxyWrapper:get():isFlashBanged() and true == playerActorProxyWrapper:get():isConcealCharacter() then
        aliasInfo:SetMonoTone(true)
      else
        aliasInfo:SetMonoTone(false)
      end
      local isShowForAlli = false
      if true == actorProxy:isHideCharacterName() and true == actorProxy:isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
        isShowForAlli = true
      end
      if actorProxy:isHideCharacterName() and false == actorProxy:isFlashBanged() or true == isShowForAlli then
        aliasInfo:SetShow(false)
      else
        local titleColor = 4282695908
        if playerActorProxyWrapper:isExistTitleColor() then
          titleColor = playerActorProxyWrapper:getTitleColorValue()
        end
        aliasInfo:SetShow(true)
        aliasInfo:SetFontColor(titleColor)
        aliasInfo:useGlowFont(true, "BaseFont_10_Glow", 4278456421)
      end
    else
      aliasInfo:SetShow(false)
    end
  else
    aliasInfo:SetShow(false)
  end
end
local settingTitle = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local actorProxy = actorProxyWrapper:get()
  if false == actorProxy:isPlayer() and false == actorProxy:isMonster() and false == actorProxy:isNpc() then
    return
  end
  local nickName = UI.getChildControl(targetPanel, "CharacterTitle")
  if nil == nickName then
    return
  end
  nickName:SetShow(false)
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
    if false == playerActorProxyWrapper:get():isFlashBanged() and false == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
      nickName:SetMonoTone(true)
    elseif false == playerActorProxyWrapper:get():isFlashBanged() and true == playerActorProxyWrapper:get():isConcealCharacter() then
      nickName:SetMonoTone(true)
    else
      nickName:SetMonoTone(false)
    end
    local isShowForAlli = false
    if true == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
      isShowForAlli = true
    end
    if playerActorProxyWrapper:get():isHideCharacterName() and false == playerActorProxyWrapper:get():isFlashBanged() or true == isShowForAlli then
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
    if 0 < string.len(playerActorProxyWrapper:getUserNickname()) then
      if 0 < vectorC.w then
        nickName:SetFontColor(4293914607)
        nickName:useGlowFont(false)
        nickName:useGlowFont(true, "BaseFont_10_Glow", allyColor)
      else
        nickName:SetFontColor(4293914607)
        nickName:useGlowFont(false)
        nickName:useGlowFont(true, "BaseFont_10_Glow", 4278190080)
      end
      nickName:SetText(playerActorProxyWrapper:getUserNickname())
      nickName:SetShow(true)
    end
  elseif 0 < string.len(actorProxyWrapper:getCharacterTitle()) then
    nickName:SetText(actorProxyWrapper:getCharacterTitle())
    nickName:SetSpanSize(0, 20)
    nickName:SetShow(true)
    nickName:useGlowFont(false)
  end
end
local settingFirstTalk = function(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  local firstTalk = UI.getChildControl(targetPanel, "Static_FirstTalk")
  if nil == firstTalk then
    return
  end
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  if nil == npcActorProxyWrapper then
    return
  end
  firstTalk:SetShow(npcActorProxyWrapper:get():getFirstTalkable())
  insertedArray:push_back(firstTalk)
end
local settingImportantTalk = function(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  local importantTalk = UI.getChildControl(targetPanel, "Static_ImportantTalk")
  if nil == importantTalk then
    return
  end
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  if nil == npcActorProxyWrapper then
    return
  end
  local isShow = npcActorProxyWrapper:get():getImportantTalk()
  importantTalk:SetShow(isShow)
  if isShow then
    insertedArray:push_back(importantTalk)
  end
end
local settingOtherHeadIcon = function(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  local characterKeyRaw = actorProxyWrapper:getCharacterKeyRaw()
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  if nil == npcActorProxyWrapper then
    return
  end
  local npcData = getNpcInfoByCharacterKeyRaw(characterKeyRaw, npcActorProxyWrapper:get():getDialogIndex())
  if nil ~= npcData then
    for index = 0, CppEnums.SpawnType.eSpawnType_Count - 1 do
      local aControl = getControlProperty(targetPanel, index)
      local isOn = npcData:hasSpawnType(index)
      if nil ~= aControl then
        aControl:SetShow(false)
        if isOn then
          aControl:SetShow(true)
          insertedArray:push_back(aControl)
        end
      end
    end
  end
end
local guildTendencyColor = function(tendency)
  local r, g, b = 0, 0, 0
  local upValue = 300000
  local downValue = -1000000
  if tendency > 0 then
    local percents = tendency / upValue
    r = math.floor(255 - 255 * percents)
    g = math.floor(255 - 171 * percents)
    b = 255
  else
    local percents = tendency / downValue
    r = 255
    g = math.floor(255 - 255 * percents)
    b = math.floor(255 - 255 * percents)
  end
  local sumColorValue = 4278190080 + 65536 * r + 256 * g + b
  return sumColorValue
end
local nameTendencyColor = function(tendency)
  local r, g, b = 0, 0, 0
  local upValue = 300000
  local downValue = -1000000
  if tendency > 0 then
    local percents = tendency / upValue
    r = math.floor(203 - 203 * percents)
    g = math.floor(203 - 203 * percents)
    b = math.floor(203 + 52 * percents)
  else
    local percents = tendency / downValue
    r = math.floor(203 + 52 * percents)
    g = math.floor(203 - 203 * percents)
    b = math.floor(203 - 203 * percents)
  end
  local sumColorValue = 4278190080 + 65536 * r + 256 * g + b
  return sumColorValue
end
local setTierIcon = function(iconControl, textureName, iconIdx, leftX, topY, xCount, iconSize)
  iconControl:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Etc_04.dds")
  iconControl:SetShow(true)
  local x1, y1, x2, y2
  x1 = leftX + (iconSize + 1) * (iconIdx % xCount)
  y1 = topY + (iconSize + 1) * math.floor(iconIdx / xCount)
  x2 = x1 + iconSize
  y2 = y1 + iconSize
  x1, y1, x2, y2 = setTextureUV_Func(iconControl, x1, y1, x2, y2)
  iconControl:getBaseTexture():setUV(x1, y1, x2, y2)
  iconControl:setRenderTexture(iconControl:getBaseTexture())
end
local function settingStatTierIcon(actorKeyRaw, targetPanel, actorProxyWrapper)
  local tierIcon = UI.getChildControl(targetPanel, "Static_BPIcon")
  if nil == tierIcon then
    return
  end
  if false == _ContentsGroup_StatTierIcon then
    tierIcon:SetShow(false)
    return
  end
  actorProxyWrapper = getPlayerActor(actorKeyRaw)
  tierIcon:SetShow(false)
  if nil == actorProxyWrapper then
    return
  end
  local militiaTeamNo = actorProxyWrapper:get():getVolunteerTeamNoForLua()
  local isMilitia = actorProxyWrapper:get():isVolunteer()
  if militiaTeamNo > 0 and true == isMilitia then
    return
  end
  local totalStatValue = actorProxyWrapper:get():getTotalStatValue()
  local tier = ToClient_GetHighTierByTotalStat(totalStatValue)
  if tier < 1 or tier > ToClient_GetHighTierCount() then
    return
  end
  if false == actorProxyWrapper:get():isSelfPlayer() then
    local isShowForAlli = false
    if false == actorProxyWrapper:get():getShowTotalStatTier() then
      return
    end
    if true == actorProxyWrapper:get():isHideCharacterName() and true == actorProxyWrapper:get():isShowNameWhenCamouflage() then
      isShowForAlli = true
      return
    end
    if actorProxyWrapper:get():isHideCharacterName() and false == actorProxyWrapper:get():isFlashBanged() or true == isShowForAlli then
      return
    end
  end
  if false == actorProxyWrapper:get():isFlashBanged() and false == actorProxyWrapper:get():isHideCharacterName() and true == actorProxyWrapper:get():isEquipCamouflage() and actorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
    tierIcon:SetMonoTone(true)
  elseif false == actorProxyWrapper:get():isFlashBanged() and true == actorProxyWrapper:get():isConcealCharacter() then
    tierIcon:SetMonoTone(true)
  else
    tierIcon:SetMonoTone(false)
  end
  setTierIcon(tierIcon, "new_ui_common_forlua/default/Default_Etc_04.dds", 3 - tier, 225, 142, 3, 42)
  tierIcon:SetShow(true)
end
local function settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
  if nil == targetPanel then
    return
  end
  if false == actorProxyWrapper:get():isPlayer() then
    return
  end
  local guildName = UI.getChildControl(targetPanel, "CharacterGuild")
  local guildMark = UI.getChildControl(targetPanel, "Static_GuildMark")
  local guildOccupyIcon = UI.getChildControl(targetPanel, "Static_Icon_GuildMaster")
  local guildBack = UI.getChildControl(targetPanel, "Static_GuildBackGround")
  local guildMarkXBOXBg = UI.getChildControl(targetPanel, "Static_XBOXGuildMarkBg")
  local guildMarkXBOXIcon = UI.getChildControl(targetPanel, "Static_XBOXGuildMarkIcon")
  if nil == guildName or nil == guildMark or nil == guildOccupyIcon or nil == guildBack or nil == guildMarkXBOXBg or nil == guildMarkXBOXIcon then
    return
  end
  guildOccupyIcon:SetIgnore(true)
  guildOccupyIcon:SetShow(false)
  local guildSpan = guildMark:GetSpanSize()
  guildOccupyIcon:SetSpanSize(guildSpan.x - guildOccupyIcon:GetSizeX() / 2, 40)
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  if nil == playerActorProxy then
    return
  end
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  if actorProxy:isPlayer() then
    local militiaTeamNo = actorProxy:getVolunteerTeamNoForLua()
    local isMilitia = playerActorProxy:isVolunteer()
    if militiaTeamNo > 0 and true == isMilitia then
      guildName:SetShow(false)
      guildMark:SetShow(false)
      guildBack:SetShow(false)
      guildMarkXBOXBg:SetShow(false)
      guildMarkXBOXIcon:SetShow(false)
      return
    end
  end
  local hasGuild = playerActorProxy:isGuildMember() and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged())
  if false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
    guildName:SetMonoTone(true)
    guildMark:SetMonoTone(true)
    guildBack:SetMonoTone(true)
    guildMarkXBOXBg:SetMonoTone(true)
    guildMarkXBOXIcon:SetMonoTone(true)
  elseif false == playerActorProxy:isFlashBanged() and true == playerActorProxy:isConcealCharacter() then
    guildName:SetMonoTone(true)
    guildMark:SetMonoTone(true)
    guildBack:SetMonoTone(true)
    guildMarkXBOXBg:SetMonoTone(true)
    guildMarkXBOXIcon:SetMonoTone(true)
  else
    guildName:SetMonoTone(false)
    guildMark:SetMonoTone(false)
    guildBack:SetMonoTone(false)
    guildMarkXBOXBg:SetMonoTone(false)
    guildMarkXBOXIcon:SetMonoTone(false)
  end
  local isShowForAlli = false
  if true == playerActorProxyWrapper:get():isHideCharacterName() and true == playerActorProxyWrapper:get():isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
    isShowForAlli = true
  end
  if false == hasGuild or true == isShowForAlli then
    guildName:SetShow(false)
    guildMark:SetShow(false)
    guildBack:SetShow(false)
    guildMarkXBOXBg:SetShow(false)
    guildMarkXBOXIcon:SetShow(false)
    return
  else
    guildName:SetShow(hasGuild)
    guildMark:SetShow(hasGuild)
    guildBack:SetShow(hasGuild)
    guildMarkXBOXBg:SetShow(hasGuild)
    guildMarkXBOXIcon:SetShow(hasGuild)
  end
  if hasGuild then
    local isAllianceMember = playerActorProxy:isGuildAllianceMember()
    local isSiegeBeingChannel = ToClient_IsAnySiegeBeingOfMyChannel()
    local isGuildTeamBattleAttend = playerActorProxy:isGuildTeamBattleAttend()
    local guildNameText = ""
    if true == isAllianceMember and (true == isSiegeBeingChannel or true == isGuildTeamBattleAttend) then
      guildNameText = playerActorProxyWrapper:getGuildAllianceName()
      if "" == guildNameText then
        guildNameText = playerActorProxyWrapper:getGuildName()
      end
    else
      guildNameText = playerActorProxyWrapper:getGuildName()
    end
    guildName:useGlowFont(false)
    guildName:SetFontColor(4293914607)
    guildName:useGlowFont(true, "BaseFont_10_Glow", 4279004349)
    local guildNo = 0
    if true == isAllianceMember and (true == isSiegeBeingChannel or true == isGuildTeamBattleAttend) then
      guildNo = playerActorProxyWrapper:getGuildAllianceNo_s64()
    else
      guildNo = playerActorProxyWrapper:getGuildNo_s64()
    end
    local guildGrade = ToClient_getGuildGrade(guildNo)
    local isbadGuildName = playerActorProxyWrapper:isBadNameFlag(guildNo)
    if CppEnums.GuildGrade.GuildGrade_Clan == guildGrade then
      guildMark:SetShow(false)
      guildBack:SetShow(false)
      guildMarkXBOXBg:SetShow(false)
      guildMarkXBOXIcon:SetShow(false)
    else
    end
    if false == isbadGuildName then
      guildName:SetText("<" .. guildNameText .. ">")
    else
      guildName:SetText("<" .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_IMPROPERGUILDNAME") .. ">")
    end
    local hasOccupyTerritory = playerActorProxy:isOccupyTerritory()
    if hasOccupyTerritory then
      guildOccupyIcon:SetShow(true)
      guildOccupyIcon:SetMonoTone(false)
    else
      local allianceCache = 0
      if true == isAllianceMember then
        allianceCache = playerActorProxyWrapper:getGuildAllianceNo_s64()
      else
        allianceCache = playerActorProxyWrapper:getGuildNo_s64()
      end
      local hasSiege = ToClient_hasOccupyingMajorSiege(allianceCache)
      if true == hasSiege then
        guildOccupyIcon:SetShow(true)
        guildOccupyIcon:SetMonoTone(true)
      else
        guildOccupyIcon:SetShow(false)
        guildOccupyIcon:SetMonoTone(false)
      end
    end
    if true == _ContentsGroup_RenewUI_Guild and true == ToClient_isConsole() then
      PaGlobalFunc_GuildMark_SetGuildMarkControl(guildMarkXBOXBg, guildMarkXBOXIcon, actorKeyRaw)
      guildBack:SetShow(false)
      guildMark:SetShow(false)
    else
      local isSet = setGuildTexture(actorKeyRaw, guildMark)
      if false == isSet then
        guildMarkInit(guildMark)
      else
        guildMark:getBaseTexture():setUV(0, 0, 1, 1)
        guildMark:setRenderTexture(guildMark:getBaseTexture())
      end
      if playerActorProxy:isGuildAllianceChair() then
        guildBack:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Etc_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(guildBack, 1, 1, 43, 43)
        guildBack:getBaseTexture():setUV(x1, y1, x2, y2)
        guildBack:setRenderTexture(guildBack:getBaseTexture())
      elseif playerActorProxy:isGuildMaster() then
        guildBack:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Etc_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(guildBack, 87, 1, 129, 43)
        guildBack:getBaseTexture():setUV(x1, y1, x2, y2)
        guildBack:setRenderTexture(guildBack:getBaseTexture())
      elseif playerActorProxy:isGuildSubMaster() then
        guildBack:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Etc_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(guildBack, 44, 1, 86, 43)
        guildBack:getBaseTexture():setUV(x1, y1, x2, y2)
        guildBack:setRenderTexture(guildBack:getBaseTexture())
      else
        guildBack:ChangeTextureInfoNameAsync("")
      end
      guildMarkXBOXBg:SetShow(false)
      guildMarkXBOXIcon:SetShow(false)
    end
  else
    guildOccupyIcon:SetShow(false)
    guildMarkInit(guildMark)
  end
end
local settingMonsterName = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local nameTag = UI.getChildControl(targetPanel, "CharacterName")
  if nil == nameTag then
    return
  end
  local monsterActorProxyWrapper = getMonsterActor(actorKeyRaw)
  if nil == monsterActorProxyWrapper then
    return
  end
  local selfPlayerActorProxyWrapper = getSelfPlayer()
  if nil == selfPlayerActorProxyWrapper then
    return
  end
  if true == ToClient_IsDevelopment() then
    local selfPlayerAttackAwakenValue = ToClient_getAwakenOffence()
    local selfPlayerAttackOffenceValue = ToClient_getOffence()
    local selfPlayerOffence
    if selfPlayerAttackAwakenValue > selfPlayerAttackOffenceValue then
      selfPlayerOffence = selfPlayerAttackAwakenValue
    else
      selfPlayerOffence = selfPlayerAttackOffenceValue
    end
    local monsterDeffence = monsterActorProxyWrapper:getDeffence(selfPlayerActorProxyWrapper:getMainAttckType())
    setMonsterNameColor_Stat(selfPlayerOffence, monsterDeffence, nameTag, monsterActorProxyWrapper:get():isDarkSpiritMonster())
  else
    local monsterLevel = monsterActorProxyWrapper:get():getCharacterStaticStatus().level
    local selfPlayerLevel = selfPlayerActorProxyWrapper:get():getLevel()
    setMonsterNameColor_Level(selfPlayerLevel, monsterLevel, nameTag, monsterActorProxyWrapper:get():isDarkSpiritMonster())
  end
end
local function settingPlayerName(actorKeyRaw, targetPanel, actorProxyWrapper)
  local nameTag = UI.getChildControl(targetPanel, "CharacterName")
  if nil == nameTag then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  local playerTendency = playerActorProxy:getTendency()
  if playerActorProxy:isPvpEnable() then
    nameTag:useGlowFont(false)
    nameTag:SetFontColor(4293914607)
    nameTag:useGlowFont(true, "BaseFont_10_Glow", nameTendencyColor(playerTendency))
  else
    nameTag:useGlowFont(false)
    nameTag:SetFontColor(4294574047)
    nameTag:useGlowFont(true, "BaseFont_10_Glow", 4283917312)
  end
end
function isShowInstallationEnduranceType(installationType)
  if installationType == CppEnums.InstallationType.eType_Mortar or installationType == CppEnums.InstallationType.eType_Anvil or installationType == CppEnums.InstallationType.eType_Stump or installationType == CppEnums.InstallationType.eType_FireBowl or installationType == CppEnums.InstallationType.eType_Buff or installationType == CppEnums.InstallationType.eType_Alchemy or installationType == CppEnums.InstallationType.eType_Havest or installationType == CppEnums.InstallationType.eType_Bookcase or installationType == CppEnums.InstallationType.eType_Cooking or installationType == CppEnums.InstallationType.eType_Bed or installationType == CppEnums.InstallationType.eType_LivestockHarvest then
    return true
  else
    return false
  end
end
local isFourty = false
local isTwenty = false
local furnitureCheck = false
function ShowUseTab_Func()
  if nil == getSelfPlayer() then
    return
  end
  local myLevel = getSelfPlayer():get():getLevel()
  if myLevel > 30 then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobalFunc_UseTab_Show(0, IsChecked_WeaponOut, PAGetString(Defines.StringSheet_RESOURCE, "UI_ACTOR_NAMETAG_USETAB"))
  if true == ToClient_isConsole() then
    PaGlobalFunc_UseTab_Show(0, false)
  end
end
function HideUseTab_Func()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local targetPanel = selfPlayer:get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobalFunc_UseTab_Show(0, false)
end
function FGlobal_ShowUseLantern(param)
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local lanternIdx = 1
  if true == ToClient_isConsole() then
    lanternIdx = 2
  end
  PaGlobalFunc_UseTab_Show(lanternIdx, param)
end
local beforeMaxHp = {}
local rulerControl = {}
function checkAndCreateRular(rularCount, targetPanel, actorKeyRaw)
  if nil == rulerControl[actorKeyRaw] then
    rulerControl[actorKeyRaw] = {}
    rulerControl[actorKeyRaw].createRulerCount = 0
    if nil ~= targetPanel then
      rulerControl[actorKeyRaw].panel = targetPanel:GetID()
    end
  end
  if rularCount == rulerControl[actorKeyRaw].createRulerCount then
    return false
  end
  rulerControl[actorKeyRaw].rularParent = UI.getChildControl(targetPanel, "Static_Rular")
  for index = 0, rularCount - 1 do
    if index >= rulerControl[actorKeyRaw].createRulerCount then
      if 9 == index % 10 then
        rulerControl[actorKeyRaw][index] = UI.createAndCopyBasePropertyControl(targetPanel, "Static_1000Stick", rulerControl[actorKeyRaw].rularParent, "RulerControl_" .. index)
      else
        rulerControl[actorKeyRaw][index] = UI.createAndCopyBasePropertyControl(targetPanel, "Static_100Stick", rulerControl[actorKeyRaw].rularParent, "RulerControl_" .. index)
      end
    end
  end
  for index = 0, rulerControl[actorKeyRaw].createRulerCount - 1 do
    rulerControl[actorKeyRaw][index]:SetShow(false)
  end
  rulerControl[actorKeyRaw].createRulerCount = rularCount
  return true
end
function checkAvailableRular(index, rularCount)
  if rularCount > 1000 then
    return false
  elseif rularCount >= 100 then
    if 9 == index % 10 then
      return true
    end
  elseif rularCount >= 40 then
    if 1 == index % 2 then
      return true
    end
  else
    return true
  end
  return false
end
function checkChagnedNameTagPanel(actorKeyRaw, targetPanel, hpMain, rularParent)
  if nil == beforeMaxHp[actorKeyRaw] then
    return false
  end
  if nil == rulerControl[actorKeyRaw] then
    return false
  end
  if nil == rulerControl[actorKeyRaw].panel or nil == targetPanel then
    return false
  end
  if rulerControl[actorKeyRaw].panel ~= targetPanel:GetID() then
    rularParent:MoveChilds(rularParent:GetID(), rulerControl[actorKeyRaw].rularParent)
    rularParent:SetPosX(hpMain:GetPosX())
    rularParent:SetPosY(hpMain:GetPosY())
    rularParent:SetShow(hpMain:GetShow())
    rulerControl[actorKeyRaw].panel = targetPanel:GetID()
    rulerControl[actorKeyRaw].rularParent = rularParent
    rulerControl[actorKeyRaw].hpMain = hpMain
    return false
  end
  return false
end
function GameOptionApply_CharacterNameTag_Ruler(isShow)
  if nil == rulerControl then
    return
  end
  for _, control in pairs(rulerControl) do
    if false == isShow then
      if nil ~= control.rularParent then
        control.rularParent:SetShow(isShow)
      end
    elseif nil ~= control.hpMain and nil ~= control.rularParent then
      control.rularParent:SetShow(control.hpMain:GetShow())
    end
  end
end
function GameOptionApply_CharacterNameTag_StackHpBar(isShow)
  if nil == _characterHpBarContainer then
    return isShow
  end
  for _, hpBarData in pairs(_characterHpBarContainer) do
    if nil ~= hpBarData.stackHpBar then
      hpBarData.stackHpBar:SetShow(false)
      hpBarData.stackHpBarBackColor:SetShow(false)
      hpBarData.hpBack:SetShow(false)
      hpBarData.hpPointer:SetShow(false)
    end
  end
  _characterHpBarContainer = {}
  return isShow
end
local CharacterNameTag_SetRuler = function(maxHp, targetPanel, actorKeyRaw)
end
local settingGuildMarkAndPreemptiveStrike = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  if nil == targetPanel then
    return
  end
  if false == actorProxyWrapper:get():isPlayer() then
    return
  end
  if actorProxyWrapper:get():isPetProxy() or actorProxyWrapper:get():isHouseHold() then
    return
  end
  local preemptiveStrikeBeing = UI.getChildControl(targetPanel, "Static_PreemptiveStrikeBeing")
  local murdererMark = UI.getChildControl(targetPanel, "Static_MurdererMark")
  local guildBack = UI.getChildControl(targetPanel, "Static_GuildBackGround")
  local guildMark = UI.getChildControl(targetPanel, "Static_GuildMark")
  local guildMaster = UI.getChildControl(targetPanel, "Static_Icon_GuildMaster")
  local tierIcon = UI.getChildControl(targetPanel, "Static_BPIcon")
  local guildName = UI.getChildControl(targetPanel, "CharacterGuild")
  local nameTag = UI.getChildControl(targetPanel, "CharacterName")
  local title = UI.getChildControl(targetPanel, "CharacterTitle")
  local alias = UI.getChildControl(targetPanel, "CharacterAlias")
  if nil == guildName or nil == guildBack or nil == guildMark or nil == nameTag or nil == title or nil == preemptiveStrikeBeing or nil == murdererMark or nil == actorProxyWrapper or nil == alias then
    return
  end
  local scaleBuffer = guildMark:GetScale()
  preemptiveStrikeBeing:SetScale(1, 1)
  murdererMark:SetScale(1, 1)
  guildMark:SetScale(1, 1)
  guildBack:SetScale(1, 1)
  guildMaster:SetScale(1, 1)
  tierIcon:SetScale(1, 1)
  guildName:SetScale(1, 1)
  nameTag:SetScale(1, 1)
  title:SetScale(1, 1)
  alias:SetScale(1, 1)
  local widthMax = guildName:GetTextSizeX()
  widthMax = math.max(widthMax, nameTag:GetTextSizeX())
  widthMax = math.max(widthMax, title:GetTextSizeX())
  if alias:GetShow() then
    widthMax = math.max(widthMax, alias:GetTextSizeX())
  end
  local sizeMax = math.max(guildMark:GetSizeX(), guildBack:GetSizeX())
  sizeMax = math.max(sizeMax, tierIcon:GetSizeX())
  sizeMax = sizeMax * 0.5
  guildMark:SetSpanSize(-widthMax / 2 - sizeMax, guildMark:GetSpanSize().y)
  guildBack:SetSpanSize(-widthMax / 2 - sizeMax, guildBack:GetSpanSize().y)
  guildMaster:SetSpanSize(-widthMax / 2 - sizeMax, guildMaster:GetSpanSize().y)
  tierIcon:SetSpanSize(widthMax / 2 + sizeMax, tierIcon:GetSpanSize().y)
  preemptiveStrikeBeing:SetSpanSize(widthMax / 2 + preemptiveStrikeBeing:GetSizeX() / 2 + 5, preemptiveStrikeBeing:GetSpanSize().y)
  local actorProxyWrapper = getActor(actorKeyRaw)
  local name = actorProxyWrapper:getName()
  if preemptiveStrikeBeing:GetShow() then
    if "" ~= name then
      murdererMark:SetSpanSize(widthMax / 2 + murdererMark:GetSizeX() + preemptiveStrikeBeing:GetSizeX() / 2 - 10, murdererMark:GetSpanSize().y)
    else
      murdererMark:SetSpanSize(widthMax / 2 - murdererMark:GetSizeX() / 2, murdererMark:GetSpanSize().y)
    end
  elseif "" ~= name then
    murdererMark:SetSpanSize(widthMax / 2 + murdererMark:GetSizeX() / 2 + 5, murdererMark:GetSpanSize().y)
  else
    murdererMark:SetSpanSize(widthMax / 2 - murdererMark:GetSizeX(), murdererMark:GetSpanSize().y)
  end
  preemptiveStrikeBeing:SetScale(scaleBuffer.x, scaleBuffer.y)
  murdererMark:SetScale(scaleBuffer.x, scaleBuffer.y)
  guildMark:SetScale(scaleBuffer.x, scaleBuffer.y)
  tierIcon:SetScale(scaleBuffer.x, scaleBuffer.y)
  guildBack:SetScale(scaleBuffer.x, scaleBuffer.y)
  guildMaster:SetScale(scaleBuffer.x, scaleBuffer.y)
  guildName:SetScale(scaleBuffer.x, scaleBuffer.y)
  nameTag:SetScale(scaleBuffer.x, scaleBuffer.y)
  title:SetScale(scaleBuffer.x, scaleBuffer.y)
  alias:SetScale(scaleBuffer.x, scaleBuffer.y)
end
local pvpIconTexture = {
  [0] = {
    x1 = 4,
    y1 = 426,
    x2 = 36,
    y2 = 458
  },
  [1] = {
    x1 = 37,
    y1 = 426,
    x2 = 69,
    y2 = 458
  },
  [2] = {
    x1 = 70,
    y1 = 426,
    x2 = 102,
    y2 = 458
  },
  [3] = {
    x1 = 103,
    y1 = 426,
    x2 = 135,
    y2 = 458
  }
}
local preemptiveIconTexture = {
  [0] = {
    x1 = 4,
    y1 = 391,
    x2 = 36,
    y2 = 423
  },
  [1] = {
    x1 = 37,
    y1 = 391,
    x2 = 69,
    y2 = 423
  },
  [2] = {
    x1 = 70,
    y1 = 391,
    x2 = 102,
    y2 = 423
  },
  [3] = {
    x1 = 103,
    y1 = 391,
    x2 = 135,
    y2 = 423
  }
}
if ToClient_isConsole() then
  pvpIconTexture = {
    [0] = {
      x1 = 34,
      y1 = 141,
      x2 = 66,
      y2 = 185
    },
    [1] = {
      x1 = 34,
      y1 = 96,
      x2 = 66,
      y2 = 140
    },
    [2] = {
      x1 = 1,
      y1 = 141,
      x2 = 33,
      y2 = 185
    },
    [3] = {
      x1 = 1,
      y1 = 96,
      x2 = 33,
      y2 = 140
    }
  }
  preemptiveIconTexture = {
    [0] = {
      x1 = 67,
      y1 = 101,
      x2 = 105,
      y2 = 136
    },
    [1] = {
      x1 = 106,
      y1 = 101,
      x2 = 144,
      y2 = 136
    },
    [2] = {
      x1 = 67,
      y1 = 137,
      x2 = 105,
      y2 = 172
    },
    [3] = {
      x1 = 106,
      y1 = 137,
      x2 = 144,
      y2 = 172
    }
  }
end
local settingGuildTextForAlias = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  if nil == targetPanel then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  local guildName = UI.getChildControl(targetPanel, "CharacterGuild")
  local alias = UI.getChildControl(targetPanel, "CharacterAlias")
  if nil == guildName or nil == alias or nil == playerActorProxyWrapper then
    return
  end
  local scaleBuffer = alias:GetScale()
  guildName:SetScale(1, 1)
  alias:SetScale(1, 1)
  local spanY = alias:GetSpanSize().y
  if playerActorProxyWrapper:checkToTitleKey() then
    spanY = spanY + alias:GetSizeY()
  end
  guildName:SetSpanSize(guildName:GetSpanSize().x, spanY)
  if playerActorProxyWrapper:get():isGuildMember() and (false == playerActorProxyWrapper:get():isHideGuildName() or playerActorProxyWrapper:get():isFlashBanged()) then
    spanY = spanY + guildName:GetSizeY()
  end
  guildName:SetScale(scaleBuffer.x, scaleBuffer.y)
  alias:SetScale(scaleBuffer.x, scaleBuffer.y)
end
local TypeByLoadData = {
  [ActorProxyType.isOtherPlayer] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    local insertedArray = Array.new()
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPlayerName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildTextForAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
  end
}
function EventActorCreated_NameTag(actorKeyRaw, targetPanel, actorProxyType, actorProxyWrapper)
  if nil ~= TypeByLoadData[actorProxyType] then
    TypeByLoadData[actorProxyType](actorKeyRaw, targetPanel, actorProxyWrapper)
  end
end
function FromClient_NameTag_TendencyChanged(actorKeyRaw, tendencyValue)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingPlayerName(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
end
function EventActorFirsttalk(actorKeyRaw, isFirsttalkOn)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingQuestUI(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingFirstTalk(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingImportantTalk(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingOtherHeadIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  sortCenterX(insertedArray)
end
function EventActorImportantTalk(actorKeyRaw, isImportantTalk)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingQuestUI(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingFirstTalk(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingImportantTalk(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingOtherHeadIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  sortCenterX(insertedArray)
end
function EventActorChangeGuildInfo(actorKeyRaw, guildName)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildTextForAlias(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_EventActorChangeGuildInfo_HaveLand(actorProxyWrapper, Panel, isoccupyTerritory)
  local targetPanel = Panel
  if nil == actorProxyWrapper or nil == isoccupyTerritory then
    return
  end
  local actorKeyRaw = actorProxyWrapper:get():getActorKeyRaw()
  settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
end
function EventActorChangeLevel(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  if actorProxyWrapper:get():isMonster() then
    settingMonsterName(actorKeyRaw, panel, actorProxyWrapper)
  elseif actorProxyWrapper:get():isPlayer() then
    settingPlayerName(actorKeyRaw, panel, actorProxyWrapper)
  end
end
function EventChangeCharacterName(actorKeyRaw, characterName)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingName(actorKeyRaw, panel, actorProxyWrapper)
  settingAlias(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  if actorProxyWrapper:get():isPlayer() then
    settingPlayerName(actorKeyRaw, panel, actorProxyWrapper)
  end
end
function FromClient_GuildMemberGradeChanged(actorKeyRaw, panel, actorProxyWrapper, guildGrade)
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
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
function FromClient_NameTag_SelfPlayerLevelUp()
  local actorProxyWrapper = getSelfPlayer()
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingName(actorProxyWrapper:getActorKey(), panel, actorProxyWrapper)
end
function FromClient_NotifyChangeGuildTendency(actorKeyRaw, panel, actorProxyWrapper)
  if nil == panel then
    return
  end
  if nil == actorProxyWrapper then
    return
  end
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_ShowPlayerInfo_GuildTeamBattle(actorProxyWrapper, panel)
  if nil == actorProxyWrapper or nil == panel then
    return
  end
  local actorKeyRaw = actorProxyWrapper:get():getActorKeyRaw()
  local insertedArray = Array.new()
  settingName(actorKeyRaw, panel, actorProxyWrapper)
  settingTitle(actorKeyRaw, panel, actorProxyWrapper)
  settingAlias(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
end
registerEvent("EventActorCreated", "EventActorCreated_NameTag")
registerEvent("FromClient_TendencyChanged", "FromClient_NameTag_TendencyChanged")
registerEvent("EventFirstTalk", "EventActorFirsttalk")
registerEvent("EventChangeGuildInfo", "EventActorChangeGuildInfo")
registerEvent("EventMonsterLevelColorChanged", "EventActorChangeLevel")
registerEvent("EventPlayerPvPAbleChanged", "EventActorChangeLevel")
registerEvent("EventChangeCharacterName", "EventChangeCharacterName")
registerEvent("FromClient_GuildMemberGradeChanged", "FromClient_GuildMemberGradeChanged")
registerEvent("EventPlayerNicknameUpdate", "EventPlayerNicknameUpdate")
registerEvent("EventSelfPlayerLevelUp", "FromClient_NameTag_SelfPlayerLevelUp")
registerEvent("FromClient_NotifyChangeGuildTendency", "FromClient_NotifyChangeGuildTendency")
registerEvent("FromClient_ChangeOccupyTerritoryState", "FromClient_EventActorChangeGuildInfo_HaveLand")
registerEvent("FromClient_GuildTeamBattle_UpdateAttendOverHeadUI", "FromClient_ShowPlayerInfo_GuildTeamBattle")
