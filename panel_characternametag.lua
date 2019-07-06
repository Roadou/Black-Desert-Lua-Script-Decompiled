local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_classType = CppEnums.ClassType
local questFrameUV = {
  [0] = "renewal/PcRemaster/Remaster_InGameQuest_00.dds",
  [1] = {
    {
      303,
      0,
      405,
      102
    },
    {
      303,
      101,
      405,
      203
    },
    {
      303,
      303,
      405,
      405
    },
    {
      303,
      202,
      405,
      304
    }
  },
  [2] = {
    {
      202,
      0,
      304,
      102
    },
    {
      202,
      101,
      304,
      203
    },
    {
      202,
      303,
      304,
      405
    },
    {
      202,
      202,
      304,
      304
    }
  },
  [3] = {
    {
      101,
      0,
      203,
      102
    },
    {
      101,
      101,
      203,
      203
    },
    {
      101,
      303,
      203,
      405
    },
    {
      101,
      202,
      203,
      304
    }
  },
  [4] = {
    {
      0,
      0,
      102,
      102
    },
    {
      0,
      101,
      102,
      203
    },
    {
      0,
      303,
      102,
      405
    },
    {
      0,
      202,
      102,
      304
    }
  }
}
local ActorProxyType = {
  isActorProxy = 0,
  isCharacter = 1,
  isPlayer = 2,
  isSelfPlayer = 3,
  isOtherPlayer = 4,
  isAlterego = 5,
  isMonster = 6,
  isNpc = 7,
  isDeadBody = 8,
  isVehicle = 9,
  isGate = 10,
  isHouseHold = 11,
  isInstallationActor = 12,
  isCollect = 13,
  isInstanceObject = 14
}
local actorProxyBufferSize = {
  [ActorProxyType.isSelfPlayer] = 1,
  [ActorProxyType.isOtherPlayer] = 300,
  [ActorProxyType.isMonster] = 150,
  [ActorProxyType.isNpc] = 100,
  [ActorProxyType.isVehicle] = 50,
  [ActorProxyType.isHouseHold] = 30,
  [ActorProxyType.isInstallationActor] = 25,
  [ActorProxyType.isInstanceObject] = 50
}
local actorProxyCapacitySize = {
  [ActorProxyType.isSelfPlayer] = 1,
  [ActorProxyType.isOtherPlayer] = 50,
  [ActorProxyType.isMonster] = 25,
  [ActorProxyType.isNpc] = 25,
  [ActorProxyType.isVehicle] = 20,
  [ActorProxyType.isHouseHold] = 5,
  [ActorProxyType.isInstallationActor] = 2,
  [ActorProxyType.isInstanceObject] = 4
}
local basePanel = {
  [ActorProxyType.isSelfPlayer] = Panel_Copy_SelfPlayer,
  [ActorProxyType.isOtherPlayer] = Panel_Copy_OtherPlayer,
  [ActorProxyType.isMonster] = Panel_Copy_Monster,
  [ActorProxyType.isNpc] = Panel_Copy_Npc,
  [ActorProxyType.isVehicle] = Panel_Copy_Vehicle,
  [ActorProxyType.isHouseHold] = Panel_Copy_HouseHold,
  [ActorProxyType.isInstallationActor] = Panel_Copy_Installation,
  [ActorProxyType.isInstanceObject] = Panel_Copy_Installation
}
local lifeContentCount = 14
if ToClient_IsConferenceMode() then
  lifeContentCount = 0
else
  lifeContentCount = 14
end
local lifeContent = {
  gathering = 0,
  fishing = 1,
  hunting = 2,
  cook = 3,
  alchemy = 4,
  manufacture = 5,
  horse = 6,
  trade = 7,
  growth = 8,
  sail = 9,
  combat = 10,
  money = 11,
  battleField = 12,
  match = 13
}
local lifeRankSetTexture = {}
for i = 0, lifeContentCount - 1 do
  lifeRankSetTexture[i] = {}
end
if lifeContentCount > 0 then
  for index = 0, lifeContentCount - 1 do
    for rankIndex = 1, 5 do
      lifeRankSetTexture[index][rankIndex] = {
        x1,
        y1,
        x2,
        y2
      }
      lifeRankSetTexture[index][rankIndex].x1 = 2 + index * 38
      lifeRankSetTexture[index][rankIndex].y1 = 2 + (rankIndex - 1) * 34
      lifeRankSetTexture[index][rankIndex].x2 = 39 + index * 38
      lifeRankSetTexture[index][rankIndex].y2 = 35 + (rankIndex - 1) * 34
    end
  end
end
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
local _stackHpBarColor = {
  [-1] = Defines.Color.C_FF000000,
  [0] = 4291035148,
  [1] = 4294934576,
  [2] = 4294953029,
  [3] = 4287220554,
  [4] = 4281445845,
  [5] = 4278220233,
  [6] = 4289076667
}
local _normalHpBarColor = {
  defaultColor = Defines.Color.C_FFD20000,
  blindMode_Red = Defines.Color.C_FFFFCE22,
  blindMode_Blue = Defines.Color.C_FFFFCE22,
  partyMemeberColor = Defines.Color.C_FF008AFF
}
local _mpBarColor = {
  ep_Character = Defines.Color.C_FF81CE1C,
  fp_Character = Defines.Color.C_FFF0D147,
  bp_Character = Defines.Color.C_FFBFBFB7,
  darkelf = Defines.Color.C_FF8B4DFF,
  mp_Character = Defines.Color.C_FF367CFE
}
local _defaultUsePotionPosY
local _characterHpBarContainer = {}
local _maxHpCount = 1000
local _maxHpBarColorCount = 7
local _isStackOvered = false
local function CharacterNameTag_SetHpBarContainer(actorKeyRaw, actorProxy, targetPanel)
  local hpRate = actorProxy:getHp() % _maxHpCount / _maxHpCount * 100
  local modifiedHpIdx = math.floor(actorProxy:getHp() / _maxHpCount)
  local hpRatePerMaxHP = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
  local stackHpBack = UI.getChildControl(targetPanel, "ProgressBack")
  local stackHpBackColor = UI.getChildControl(targetPanel, "Progress2_StackHpBackColor")
  local stackHpbar = UI.getChildControl(targetPanel, "CharacterHPGageProgress")
  local hpPointer = UI.getChildControl(targetPanel, "StaticText_HP")
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if nil == _characterHpBarContainer[actorKeyRaw] then
    local hpBarData = {}
    hpBarData.stackHpBar = stackHpbar
    hpBarData.stackHpBarBackColor = stackHpBackColor
    hpBarData.hpPointer = hpPointer
    local colorValue = modifiedHpIdx % _maxHpBarColorCount
    local backColorValue = colorValue - 1
    if modifiedHpIdx <= 0 then
      backColorValue = -1
    elseif backColorValue < 0 then
      backColorValue = _maxHpBarColorCount - 1
    end
    if modifiedHpIdx > _maxHpBarColorCount * 2 then
      hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
      hpBarData.stackHpBar:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
    else
      hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[backColorValue])
      hpBarData.stackHpBar:SetColor(_stackHpBarColor[colorValue])
    end
    hpBarData.stackHpBar:SetAniSpeed(0)
    hpBarData.stackHpBar:SetProgressRate(hpRate)
    hpBarData.stackHpBarBackColor:SetAniSpeed(0)
    hpBarData.stackHpBarBackColor:SetProgressRate(100)
    hpBarData.targetHpIdx = modifiedHpIdx
    hpBarData.currentHpIdx = modifiedHpIdx
    hpBarData.currentHpRate = hpRate
    hpBarData.hpBack = stackHpBack
    _characterHpBarContainer[actorKeyRaw] = hpBarData
  else
    _characterHpBarContainer[actorKeyRaw].stackHpBar = stackHpbar
    _characterHpBarContainer[actorKeyRaw].stackHpBarBackColor = stackHpBackColor
    _characterHpBarContainer[actorKeyRaw].targetHpIdx = modifiedHpIdx
    _characterHpBarContainer[actorKeyRaw].currentHpRate = hpRate
    _characterHpBarContainer[actorKeyRaw].hpPointer = hpPointer
  end
  if modifiedHpIdx == _characterHpBarContainer[actorKeyRaw].currentHpIdx then
    _characterHpBarContainer[actorKeyRaw].stackHpBar:SetProgressRate(hpRate)
  end
end
local function CharacterNameTag_FreeHpBarContainer(actorKeyRaw)
  _characterHpBarContainer[actorKeyRaw] = nil
end
local getControlProperty = function(panel, index)
  if index == CppEnums.SpawnType.eSpawnType_SkillTrainer then
    return UI.getChildControl(panel, "Static_Skill")
  elseif index == CppEnums.SpawnType.eSpawnType_ShopMerchant then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Potion then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Weapon then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Jewel then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Furniture then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Collect then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Fish then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Worker then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Alchemy then
    return UI.getChildControl(panel, "Static_Store")
  elseif index == CppEnums.SpawnType.eSpawnType_Stable then
    return UI.getChildControl(panel, "Static_Stable")
  elseif index == CppEnums.SpawnType.eSpawnType_WareHouse then
    return UI.getChildControl(panel, "Static_WareHouse")
  elseif index == CppEnums.SpawnType.eSpawnType_auction then
    return UI.getChildControl(panel, "Static_Auction")
  elseif index == CppEnums.SpawnType.eSpawnType_inn then
    return UI.getChildControl(panel, "Static_Inn")
  elseif index == CppEnums.SpawnType.eSpawnType_guild then
    return UI.getChildControl(panel, "Static_Guild")
  elseif index == CppEnums.SpawnType.eSpawnType_intimacy then
    return UI.getChildControl(panel, "Static_Intimacy")
  else
    return nil
  end
end
local sortCenterX = function(insertedArray)
  local size = {}
  local fullSize = 0
  local scaleBuffer
  for key, value in pairs(insertedArray) do
    if value:GetShow() then
      scaleBuffer = value:GetScale()
      value:SetScale(1, 1)
      local aSize = value:GetSizeX()
      size[key] = aSize
      fullSize = fullSize + aSize
    end
  end
  local leftSize = -fullSize / 2
  for key, value in pairs(insertedArray) do
    if value:GetShow() then
      leftSize = leftSize + size[key] / 2
      value:SetSpanSize(leftSize, value:GetSpanSize().y)
      value:SetScale(scaleBuffer.x, scaleBuffer.y)
      leftSize = leftSize + size[key] / 2
    end
  end
end
local guildMarkInit = function(guildMark)
  guildMark:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Buttons.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(guildMark, 183, 1, 188, 6)
  guildMark:getBaseTexture():setUV(x1, y1, x2, y2)
  guildMark:setRenderTexture(guildMark:getBaseTexture())
end
local monsterLevelNameColor = {
  4287993237,
  4285643008,
  4287816466,
  4290966896,
  4292540333,
  4294967295,
  4294954702,
  4294943137,
  4294927717,
  4294901760,
  4287579626
}
local monsterLevelNameColorText = {
  "FF959595",
  "FF71B900",
  "FF92E312",
  "FFC2F570",
  "FFDAF7AD",
  "FFFFFFFF",
  "FFFFCECE",
  "FFFFA1A1",
  "FFFF6565",
  "FFFF0000",
  "FF8F45EA"
}
local playerlevelColor = {
  "FFC8FFC8",
  "FFC8FFC8",
  "FFFFFFFF",
  "FFFFE8BB",
  "FFFFC960",
  "FFFFAD10",
  "FFFF8A00",
  "FFFF6C00",
  "FFFF4E00",
  "FFE10000"
}
local function getColorBySelfPlayerLevel(level)
  if level < 0 then
    return playerlevelColor[1]
  elseif level >= 100 then
    return playerlevelColor[10]
  else
    return playerlevelColor[math.floor(level / 10) + 1]
  end
end
local function getColorByMonsterLevel(playerLevel, monsterLevel)
  local levelDiff = monsterLevel - playerLevel + 6
  levelDiff = math.max(levelDiff, 1)
  levelDiff = math.min(levelDiff, 11)
  return monsterLevelNameColorText[levelDiff]
end
local function setMonsterNameColor_Level(playerLevel, monsterLevel, nameStatic, isDarkSpiritMonster)
  if isDarkSpiritMonster then
    nameStatic:SetFontColor(Defines.Color.C_FF6A0000)
    return
  end
  local levelDiff = monsterLevel - playerLevel + 6
  levelDiff = math.max(levelDiff, 1)
  levelDiff = math.min(levelDiff, 11)
  nameStatic:SetFontColor(monsterLevelNameColor[levelDiff])
end
function setMonsterNameColor_Stat(playerOffence, monsterDeffence, nameStatic, isDarkSpiritMonster)
  if isDarkSpiritMonster then
    nameStatic:SetFontColor(Defines.Color.C_FF6A0000)
    return
  end
  local rate = 5
  local statDiff = math.floor((monsterDeffence - playerOffence) / rate + 6)
  statDiff = math.max(statDiff, 1)
  statDiff = math.min(statDiff, 11)
  nameStatic:SetFontColor(monsterLevelNameColor[statDiff])
end
local hideTimeType = {
  overHeadUI = 0,
  preemptiveStrike = 1,
  bubbleBox = 2,
  murdererEnd = 3
}
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
local function settingOtherHeadIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
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
      local nationMark = UI.getChildControl(targetPanel, "Static_NationMark")
      nationMark:SetShow(false)
      if false == isSet then
        guildMarkInit(guildMark)
      else
        guildMark:getBaseTexture():setUV(0, 0, 1, 1)
        guildMark:setRenderTexture(guildMark:getBaseTexture())
        if true == ToClient_isBeingNationSiege() then
          guildMark:SetShow(false)
          nationMark:SetShow(true)
          local participantNation = ToClient_getEnteredNationSiegeKey(guildNo)
          if 2 == participantNation then
            nationMark:ChangeTextureInfoNameAsync("renewal/PcRemaster/Remaster_NationWar_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(nationMark, 215, 1, 235, 21)
            nationMark:getBaseTexture():setUV(x1, y1, x2, y2)
            nationMark:setRenderTexture(nationMark:getBaseTexture())
          elseif 4 == participantNation then
            nationMark:ChangeTextureInfoNameAsync("renewal/PcRemaster/Remaster_NationWar_00.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(nationMark, 194, 1, 214, 21)
            nationMark:getBaseTexture():setUV(x1, y1, x2, y2)
            nationMark:setRenderTexture(nationMark:getBaseTexture())
          end
        end
      end
      if true == ToClient_isBeingNationSiege() then
        guildBack:SetShow(false)
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
      elseif __eGuildMemberGradeVolunteer == playerActorProxyWrapper:getGuildMemberGrade() then
        guildBack:ChangeTextureInfoNameAsync("renewal/PcRemaster/Remaster_ETC_Guild.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(guildBack, 184, 1, 226, 43)
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
local function settingMonsterName(actorKeyRaw, targetPanel, actorProxyWrapper)
  local nameTag = UI.getChildControl(targetPanel, "CharacterName")
  if false == ToClient_isConsole() and true == ToClient_isNationSiegeBoss(actorProxyWrapper:getCharacterKeyRaw()) then
    nameTag = UI.getChildControl(targetPanel, "KingsCharacterName")
  end
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
  local monsterLevel = monsterActorProxyWrapper:get():getCharacterStaticStatus().level
  local selfPlayerLevel = selfPlayerActorProxyWrapper:get():getLevel()
  setMonsterNameColor_Level(selfPlayerLevel, monsterLevel, nameTag, monsterActorProxyWrapper:get():isDarkSpiritMonster())
end
local function settingLifeRankIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  if false == actorProxyWrapper:get():isPlayer() then
    return
  end
  if lifeContentCount <= 0 then
    return
  end
  if 0 < ToClient_GetMyTeamNoLocalWar() or true == ToClient_IsMyselfInEntryUser() then
    return
  end
  local isRankShow = ToClient_getLifeRankNameTag()
  local lifeRankIcon = {}
  for i = 0, lifeContentCount - 1 do
    lifeRankIcon[i] = nil
    lifeRankIcon[i] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_" .. i)
    if nil == lifeRankIcon[i] then
      return
    end
    lifeRankIcon[i]:SetShow(false)
  end
  local iconSizeX = lifeRankIcon[0]:GetSizeX()
  local iconGap = 5
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
      return
    end
  end
  for lifeContentIndex = 0, lifeContent.match do
    lifeContent[lifeContentIndex] = {}
  end
  local hasContentRank = 0
  for lifeContentIndex = 0, lifeContent.sail do
    local hasRank = FromClient_GetTopRankListForNameTag():hasRank(lifeContentIndex, actorKeyRaw)
    local rankNumer = 0
    if nil ~= FGlobal_LifeRanking_CheckEnAble and FGlobal_LifeRanking_CheckEnAble(lifeContentIndex) and true == hasRank and lifeContentIndex < 10 then
      local rankNumer = FromClient_GetTopRankListForNameTag():getRank(lifeContentIndex, actorKeyRaw) + 1
      lifeContent[lifeContentIndex][rankNumer] = rankNumer
      lifeRankIcon[lifeContentIndex]:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/RankingIcon_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(lifeRankIcon[lifeContentIndex], lifeRankSetTexture[lifeContentIndex][rankNumer].x1, lifeRankSetTexture[lifeContentIndex][rankNumer].y1, lifeRankSetTexture[lifeContentIndex][rankNumer].x2, lifeRankSetTexture[lifeContentIndex][rankNumer].y2)
      lifeRankIcon[lifeContentIndex]:getBaseTexture():setUV(x1, y1, x2, y2)
      lifeRankIcon[lifeContentIndex]:setRenderTexture(lifeRankIcon[lifeContentIndex]:getBaseTexture())
      if false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
        lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
      elseif false == playerActorProxy:isFlashBanged() and true == playerActorProxy:isConcealCharacter() then
        lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
      else
        lifeRankIcon[lifeContentIndex]:SetMonoTone(false)
      end
      local isShowForAlli = false
      if true == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
        isShowForAlli = true
      end
      if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
        lifeRankIcon[lifeContentIndex]:SetShow(false)
      else
        lifeRankIcon[lifeContentIndex]:SetShow(isRankShow)
      end
      insertedArray:push_back(lifeRankIcon[lifeContentIndex])
    end
  end
  local rankerType = 0
  for lifeContentIndex = lifeContent.combat, lifeContent.battleField do
    hasContentRank = FromClient_GetTopRankListForNameTag():hasContentsRank(rankerType, actorKeyRaw)
    if nil ~= FGlobal_LifeRanking_CheckEnAble and FGlobal_LifeRanking_CheckEnAble(lifeContentIndex) and true == hasContentRank and lifeContentIndex >= 10 then
      local rankNumer = FromClient_GetTopRankListForNameTag():getContentsRank(rankerType, actorKeyRaw) + 1
      lifeContent[lifeContentIndex][rankNumer] = rankNumer
      lifeRankIcon[lifeContentIndex]:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/RankingIcon_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(lifeRankIcon[lifeContentIndex], lifeRankSetTexture[lifeContentIndex][rankNumer].x1, lifeRankSetTexture[lifeContentIndex][rankNumer].y1, lifeRankSetTexture[lifeContentIndex][rankNumer].x2, lifeRankSetTexture[lifeContentIndex][rankNumer].y2)
      lifeRankIcon[lifeContentIndex]:getBaseTexture():setUV(x1, y1, x2, y2)
      lifeRankIcon[lifeContentIndex]:setRenderTexture(lifeRankIcon[lifeContentIndex]:getBaseTexture())
      if false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
        lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
      elseif false == playerActorProxy:isFlashBanged() and true == playerActorProxy:isConcealCharacter() then
        lifeRankIcon[lifeContentIndex]:SetMonoTone(true)
      else
        lifeRankIcon[lifeContentIndex]:SetMonoTone(false)
      end
      local isShowForAlli = false
      if true == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
        isShowForAlli = true
      end
      if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
        lifeRankIcon[lifeContentIndex]:SetShow(false)
      else
        lifeRankIcon[lifeContentIndex]:SetShow(isRankShow)
      end
      insertedArray:push_back(lifeRankIcon[lifeContentIndex])
    end
    rankerType = rankerType + 1
  end
  local matchType = 0
  local hasMatchRank = 0
  local isEnableContentsPvP = ToClient_IsContentsGroupOpen("38")
  hasMatchRank = FromClient_GetTopRankListForNameTag():hasMatchRank(matchType, actorKeyRaw)
  if true == hasMatchRank and isEnableContentsPvP then
    local rankNumer = FromClient_GetTopRankListForNameTag():getMatchRank(matchType, actorKeyRaw) + 1
    lifeContent[lifeContent.match][rankNumer] = rankNumer
    lifeRankIcon[lifeContent.match]:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/RankingIcon_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(lifeRankIcon[lifeContent.match], lifeRankSetTexture[lifeContent.match][rankNumer].x1, lifeRankSetTexture[lifeContent.match][rankNumer].y1, lifeRankSetTexture[lifeContent.match][rankNumer].x2, lifeRankSetTexture[lifeContent.match][rankNumer].y2)
    lifeRankIcon[lifeContent.match]:getBaseTexture():setUV(x1, y1, x2, y2)
    lifeRankIcon[lifeContent.match]:setRenderTexture(lifeRankIcon[lifeContent.match]:getBaseTexture())
    if false == playerActorProxy:isFlashBanged() and false == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isEquipCamouflage() and playerActorProxyWrapper:getGuildNo_s64() == getSelfPlayer():getGuildNo_s64() then
      lifeRankIcon[lifeContent.match]:SetMonoTone(true)
    elseif false == playerActorProxy:isFlashBanged() and true == playerActorProxy:isConcealCharacter() then
      lifeRankIcon[lifeContent.match]:SetMonoTone(true)
    else
      lifeRankIcon[lifeContent.match]:SetMonoTone(false)
    end
    local isShowForAlli = false
    if true == playerActorProxy:isHideCharacterName() and true == playerActorProxy:isShowNameWhenCamouflage() and getSelfPlayer():getActorKey() ~= playerActorProxyWrapper:getActorKey() then
      isShowForAlli = true
    end
    if playerActorProxy:isPlayer() and playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() or true == isShowForAlli then
      lifeRankIcon[lifeContent.match]:SetShow(false)
    else
      lifeRankIcon[lifeContent.match]:SetShow(isRankShow)
    end
    insertedArray:push_back(lifeRankIcon[lifeContent.match])
  end
  local spanSizeY = 40
  local hasGuild = playerActorProxy:isGuildMember() and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged())
  if hasGuild then
    spanSizeY = spanSizeY + 20
  end
  if playerActorProxy:isPlayer() and playerActorProxyWrapper:checkToTitleKey() then
    spanSizeY = spanSizeY + 20
  end
  sortCenterX(insertedArray)
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
function FromClient_PlayerTotalStat_Changed_Handler(actorKey, totalStatValue)
  local actorProxyWrapper = getActor(actorKey)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingStatTierIcon(actorKey, panel, actorProxyWrapper)
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
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  local isLevel = getSelfPlayer():get():getLevel()
  if nil == targetPanel then
    return
  end
  local lanternIdx = 1
  if true == ToClient_isConsole() then
    lanternIdx = 2
  end
  if isLevel < 16 then
    return
  end
  PaGlobalFunc_UseTab_Show(lanternIdx, param)
end
local function settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  local hpBack, hpLater, hpMain
  if actorProxy:isKingOrLordTent() then
    hpBack = UI.getChildControl(targetPanel, "KingOrLordTentProgressBack")
    hpLater = UI.getChildControl(targetPanel, "KingOrLordTentProgress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "KingOrLordTentHPGageProgress")
  elseif actorProxy:isLargeHpBarCharacter() then
    hpBack = UI.getChildControl(targetPanel, "KingOrLordTentProgressBack")
    hpLater = UI.getChildControl(targetPanel, "KingOrLordTentProgress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "KingOrLordTentHPGageProgress")
  else
    hpBack = UI.getChildControl(targetPanel, "ProgressBack")
    hpLater = UI.getChildControl(targetPanel, "Progress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "CharacterHPGageProgress")
  end
  local characterStaticStatus = actorProxy:getCharacterStaticStatus()
  if nil == hpBack or nil == hpLater or nil == hpMain or nil == characterStaticStatus then
    return
  end
  hpMain:ResetVertexAni(true)
  hpLater:ResetVertexAni(true)
  hpMain:SetAlpha(1)
  hpLater:SetAlpha(1)
  if actorProxy:isSelfPlayer() then
    local usePotion = UI.getChildControl(targetPanel, "StaticText_UsePotion")
    usePotion:SetShow(false)
  elseif true == actorProxy:isPlayer() then
    CharacterNameTag_SetHpBarContainer(actorKeyRaw, actorProxy, targetPanel)
  end
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
local function settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  if false == (actorProxy:isInstallationActor() or actorProxy:isMonster() or actorProxy:isSelfPlayer() or actorProxy:isPlayer() or actorProxy:isNpc() or actorProxy:isHouseHold() or actorProxy:isVehicle() or actorProxy:isInstanceObject()) then
    return
  end
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  local hpBack, hpLater, hpMain, hpName
  if actorProxy:isKingOrLordTent() then
    hpBack = UI.getChildControl(targetPanel, "KingOrLordTentProgressBack")
    hpLater = UI.getChildControl(targetPanel, "KingOrLordTentProgress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "KingOrLordTentHPGageProgress")
  elseif actorProxy:isLargeHpBarCharacter() then
    hpBack = UI.getChildControl(targetPanel, "KingOrLordTentProgressBack")
    hpLater = UI.getChildControl(targetPanel, "KingOrLordTentProgress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "KingOrLordTentHPGageProgress")
  else
    hpBack = UI.getChildControl(targetPanel, "ProgressBack")
    hpLater = UI.getChildControl(targetPanel, "Progress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "CharacterHPGageProgress")
  end
  if false == ToClient_isConsole() and true == ToClient_isNationSiegeBoss(actorProxyWrapper:getCharacterKeyRaw()) then
    hpBack = UI.getChildControl(targetPanel, "KingOrLordTentProgressBack")
    hpLater = UI.getChildControl(targetPanel, "KingOrLordTentProgress2_HpLater")
    hpMain = UI.getChildControl(targetPanel, "KingOrLordTentHPGageProgress")
  end
  local characterStaticStatus = actorProxy:getCharacterStaticStatus()
  if nil == hpBack or nil == hpLater or nil == hpMain or nil == characterStaticStatus then
    return
  end
  if characterStaticStatus._isHiddenHp and not actorProxy:isInstallationActor() then
    hpBack:SetShow(false)
    hpLater:SetShow(false)
    hpMain:SetShow(false)
    return
  end
  if actorProxy:isInstallationActor() then
    local installationActorWrapper = getInstallationActor(actorKeyRaw)
    hpBack:SetShow(false)
    hpLater:SetShow(false)
    hpMain:SetShow(false)
    if Panel_Housing:IsShow() then
      return
    end
    local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
    if false == isShowInstallationEnduranceType(installationType) then
      return
    end
    if toInt64(0, 0) ~= installationActorWrapper:getOwnerHouseholdNo_s64() then
      if installationActorWrapper:isHavestInstallation() then
        local prevRate = hpMain:GetProgressRate()
        local rate = installationActorWrapper:getHarvestTotalGrowRate()
        if rate > 1 then
          rate = 1
        elseif rate < 0 then
          rate = 0
        end
        rate = rate * 100
        local progressingInfo = installationActorWrapper:get():getInstallationProgressingInfo()
        local isWarning = false
        if nil ~= progressingInfo then
          isWarning = progressingInfo:getNeedLop() or progressingInfo:getNeedPestControl()
        end
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        local x1, y1, x2, y2
        if isWarning then
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
        else
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 96, 255, 99)
        end
        hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
        hpMain:setRenderTexture(hpMain:getBaseTexture())
        hpMain:SetProgressRate(rate)
        hpLater:SetProgressRate(rate)
        hpMain:SetCurrentProgressRate(rate)
        hpLater:SetCurrentProgressRate(rate)
        hpBack:SetShow(true)
        hpLater:SetShow(true)
        hpMain:SetShow(true)
      else
        local curEndurance = installationActorWrapper:getEndurance()
        local maxEndurance = installationActorWrapper:getMaxEndurance()
        local prevRate = hpMain:GetProgressRate()
        local rate = curEndurance / maxEndurance * 100
        if prevRate > rate then
          hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
          hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
        elseif prevRate < rate then
          hpMain:ResetVertexAni(true)
          hpLater:ResetVertexAni(true)
          hpMain:SetAlpha(1)
          hpLater:SetAlpha(1)
        end
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        if rate < 5 then
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
        else
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 96, 255, 99)
        end
        hpMain:SetProgressRate(rate)
        hpLater:SetProgressRate(rate)
        if housing_isInstallMode() or true == furnitureCheck then
          hpBack:SetShow(true)
          hpLater:SetShow(true)
          hpMain:SetShow(true)
          local hpName = UI.getChildControl(targetPanel, "CharacterName")
          hpName:SetText(actorProxy:getStaticStatusName() .. " (" .. tostring(curEndurance) .. "/" .. tostring(maxEndurance) .. ")")
        else
          hpBack:SetShow(false)
          hpLater:SetShow(false)
          hpMain:SetShow(false)
        end
      end
    end
  elseif actorProxy:isLargeHpBarCharacter() then
    local prevRate = hpMain:GetProgressRate()
    local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
    if hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() then
      hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
      hpMain:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
    end
    if prevRate > hpRate then
      hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
      hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
    elseif prevRate < hpRate then
      hpMain:ResetVertexAni(true)
      hpLater:ResetVertexAni(true)
      hpMain:SetAlpha(1)
      hpLater:SetAlpha(1)
    end
    hpMain:SetProgressRate(hpRate)
    hpLater:SetProgressRate(hpRate)
    hpBack:SetShow(true)
    hpLater:SetShow(true)
    hpMain:SetShow(true)
  elseif actorProxy:isMonster() then
    local prevRate = hpMain:GetProgressRate()
    local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
    local characterActorProxyWrapper = getCharacterActor(actorKeyRaw)
    hpBack:SetShow(true)
    hpLater:SetShow(true)
    hpMain:SetShow(true)
    if checkActiveCondition(characterActorProxyWrapper:getCharacterKey()) == true then
      hpMain:SetProgressRate(hpRate)
      hpLater:SetProgressRate(hpRate)
      if prevRate > hpRate then
        hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
        hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
      elseif prevRate < hpRate then
        if hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() then
          hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
        end
        hpMain:ResetVertexAni(true)
        hpLater:ResetVertexAni(true)
        hpMain:SetAlpha(1)
        hpLater:SetAlpha(1)
      end
      hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 96, 255, 99)
      if false == ToClient_isConsole() and true == ToClient_isNationSiegeBoss(actorProxyWrapper:getCharacterKeyRaw()) then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      hpMain:setRenderTexture(hpMain:getBaseTexture())
    else
      local x1, y1, x2, y2
      hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
      if hpRate > 75 then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 96, 255, 99)
      elseif hpRate > 50 then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 100, 255, 103)
      elseif hpRate > 25 then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 104, 255, 107)
      elseif hpRate > 10 then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 108, 255, 111)
      elseif hpRate > 5 then
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      else
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      hpMain:setRenderTexture(hpMain:getBaseTexture())
      hpMain:SetProgressRate(100)
      hpLater:SetProgressRate(100)
      hpMain:SetCurrentProgressRate(100)
      hpLater:SetCurrentProgressRate(100)
    end
  elseif actorProxy:isSelfPlayer() then
    local hpAlert = UI.getChildControl(targetPanel, "Static_nameTagGaugeAlert")
    local usePotion = UI.getChildControl(targetPanel, "StaticText_UsePotion")
    if nil == _defaultUsePotionPosY then
      _defaultUsePotionPosY = usePotion:GetPosY()
    end
    hpBack:SetShow(true)
    hpLater:SetShow(true)
    hpMain:SetShow(true)
    local x1, y1, x2, y2
    if 0 < RequestParty_getPartyMemberCount() then
      hpMain:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Gauges.dds")
      x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 63, 233, 69)
    elseif 0 == isColorBlindMode then
      hpMain:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/Default_Gauges.dds")
      x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 96, 255, 99)
    elseif 1 == isColorBlindMode then
      hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
      x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
    elseif 2 == isColorBlindMode then
      hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
      x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
    end
    hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
    local injuryHpBar = UI.getChildControl(targetPanel, "CharacterInjuryHPGageProgress")
    local injuryHp = math.floor(actorProxy:getInjuryHp())
    if injuryHp > 0 then
      if false == injuryHpBar:GetShow() then
        injuryHpBar:SetShow(true)
      end
    else
      injuryHpBar:SetShow(false)
    end
    if true == _ContentsGroup_InjuryPercent then
      local maxHp = math.floor(actorProxy:getMaxHp())
      injuryHpBar:SetProgressRate(injuryHp / maxHp * 100)
    end
    local selfPlayerLevel = getSelfPlayer():get():getLevel()
    local prevRate = hpMain:GetProgressRate()
    local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
    if prevRate > hpRate then
      hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
      hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
    elseif prevRate < hpRate then
      hpMain:ResetVertexAni(true)
      hpLater:ResetVertexAni(true)
      hpMain:SetAlpha(1)
      hpLater:SetAlpha(1)
    end
    hpMain:SetProgressRate(hpRate)
    hpLater:SetProgressRate(hpRate)
    hpAlert:ResetVertexAni(true)
    local x1, y1, x2, y2
    if hpRate >= 40 then
      if 0 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      elseif 1 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      elseif 2 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      usePotion:SetShow(false)
      hpMain:ResetVertexAni(true)
      hpMain:SetAlpha(1)
      hpAlert:SetShow(false)
    elseif hpRate >= 20 then
      if 0 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      elseif 1 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      elseif 2 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      if selfPlayerLevel <= 15 then
        usePotion:SetShow(true)
      end
      hpMain:SetVertexAniRun("Ani_Color_Damage_40", true)
      hpAlert:SetShow(true)
      hpAlert:SetVertexAniRun("Ani_Color_nameTagAlertGauge0", true)
    else
      if 0 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
      elseif 1 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      elseif 2 == isColorBlindMode then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      if selfPlayerLevel <= 15 then
        usePotion:SetShow(true)
      end
      hpMain:SetVertexAniRun("Ani_Color_Damage_20", true)
      hpAlert:SetShow(true)
      hpAlert:SetVertexAniRun("Ani_Color_nameTagAlertGauge1", true)
    end
    if __eClassType_ShyWaman == getSelfPlayer():getClassType() then
      usePotion:SetPosY(_defaultUsePotionPosY - 50)
    end
    hpMain:setRenderTexture(hpMain:getBaseTexture())
  elseif actorProxy:isPlayer() then
    if false == _ContentsGroup_StackingHpBar then
      local prevRate = hpMain:GetProgressRate()
      local isParty = Requestparty_isPartyPlayer(actorKeyRaw)
      local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
      local isArenaAreaOrZone = playerActorProxyWrapper:get():isArenaAreaRegion() or playerActorProxyWrapper:get():isArenaZoneRegion() or playerActorProxyWrapper:get():isCompetitionDefined() or playerActorProxyWrapper:get():isGuildTeamBattleAttend()
      local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
      if prevRate > hpRate then
        hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
        hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
      elseif prevRate < hpRate then
        hpMain:ResetVertexAni(true)
        hpLater:ResetVertexAni(true)
        hpMain:SetAlpha(1)
        hpLater:SetAlpha(1)
      end
      hpMain:SetProgressRate(hpRate)
      hpLater:SetProgressRate(hpRate)
      local isShow = false == actorProxy:isHideTimeOver(hideTimeType.overHeadUI) or isParty or isArenaAreaOrZone
      hpMain:SetShow(true)
      hpBack:SetShow(isShow)
      hpLater:SetShow(isShow)
      hpMain:SetShow(isShow)
      local x1, y1, x2, y2
      if isParty then
        hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
        x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 63, 233, 69)
      else
        if 0 == isColorBlindMode then
          hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/default_gauges.dds")
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 206, 112, 255, 115)
        elseif 1 == isColorBlindMode then
          hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
        elseif 2 == isColorBlindMode then
          hpMain:ChangeTextureInfoNameAsync("new_ui_common_forlua/default/Default_Gauges_01.dds")
          x1, y1, x2, y2 = setTextureUV_Func(hpMain, 1, 247, 255, 250)
        end
        hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      end
      hpMain:getBaseTexture():setUV(x1, y1, x2, y2)
      hpMain:setRenderTexture(hpMain:getBaseTexture())
      CharacterNameTag_SetRuler(actorProxy:getMaxHp(), targetPanel, actorKeyRaw)
    else
      local isParty = Requestparty_isPartyPlayer(actorKeyRaw)
      local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
      local isArenaAreaOrZone = playerActorProxyWrapper:get():isArenaAreaRegion() or playerActorProxyWrapper:get():isArenaZoneRegion() or playerActorProxyWrapper:get():isCompetitionDefined() or playerActorProxyWrapper:get():isGuildTeamBattleAttend()
      local isShow = false == actorProxy:isHideTimeOver(hideTimeType.overHeadUI) or isParty or isArenaAreaOrZone
      local hpPointer = UI.getChildControl(targetPanel, "StaticText_HP")
      local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
      if true == GameOption_GetShowStackHp() and true == _ContentsGroup_StackingHpBar then
        hpBack = UI.getChildControl(targetPanel, "ProgressBack")
        hpMain = UI.getChildControl(targetPanel, "Progress2_StackHpBackColor")
        hpLater = UI.getChildControl(targetPanel, "CharacterHPGageProgress")
        hpBack:SetShow(isShow)
        hpLater:SetShow(isShow)
        hpMain:SetShow(isShow)
        hpPointer:SetShow(isShow)
        local pointerHalfSize = hpPointer:GetSizeX() * 0.5
        hpPointer:SetPosX(hpBack:GetPosX() + 0.01 * hpRate * hpBack:GetSizeX() - pointerHalfSize)
        if true == isShow then
          CharacterNameTag_SetHpBarContainer(actorKeyRaw, actorProxy, targetPanel)
          targetPanel:RegisterUpdateFunc("PaGlobal_WaitUntilHpBarChange_UpdateFunc")
        else
          CharacterNameTag_FreeHpBarContainer(actorKeyRaw)
        end
      else
        local prevRate = hpMain:GetProgressRate()
        hpBack:SetShow(isShow)
        hpLater:SetShow(isShow)
        hpMain:SetShow(isShow)
        hpPointer:SetShow(false)
        if true == isParty then
          hpMain:SetColor(_normalHpBarColor.partyMemeberColor)
        elseif 0 == isColorBlindMode then
          hpMain:SetColor(_normalHpBarColor.defaultColor)
        elseif 1 == isColorBlindMode then
          hpMain:SetColor(_normalHpBarColor.blindMode_Red)
        elseif 2 == isColorBlindMode then
          hpMain:SetColor(_normalHpBarColor.blindMode_Blue)
        end
        hpMain:SetAniSpeed(0)
        hpMain:SetProgressRate(hpRate)
        if true == _ContentsGroup_StackingHpBar then
          local data = {}
          data.stackHpBar = hpMain
          data.stackHpBarBackColor = hpLater
          data.hpBack = hpBack
          data.hpPointer = hpPointer
          _characterHpBarContainer[actorKeyRaw] = data
        end
      end
    end
  elseif actorProxy:isNpc() then
    local isShow = false
    local isFusionCore = actorProxy:getCharacterStaticStatus():isFusionCore()
    if true == isFusionCore then
      local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
      if npcActorProxyWrapper:getTeamNo_s64() == getSelfPlayer():getTeamNo_s64() then
        isShow = true
      end
    end
    if isShow then
      local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
      local prevRate = hpMain:GetProgressRate()
      if hpRate < prevRate then
        hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
        hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
      elseif hpRate > prevRate then
        hpMain:ResetVertexAni(true)
        hpLater:ResetVertexAni(true)
        hpMain:SetAlpha(1)
        hpLater:SetAlpha(1)
      end
      hpMain:SetProgressRate(hpRate)
      hpLater:SetProgressRate(hpRate)
    end
    hpBack:SetShow(isShow)
    hpLater:SetShow(isShow)
    hpMain:SetShow(isShow)
  elseif actorProxy:isHouseHold() then
    houseHoldActorWrapper = getHouseHoldActor(actorKeyRaw)
    if nil == houseHoldActorWrapper then
      return
    end
    if false == (houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isBarricade() or houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isKingOrLordTent() or houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isAdvancedBase()) then
      return
    end
    local prevRate = hpMain:GetProgressRate()
    local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
    if hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() then
      hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
      hpMain:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
    end
    if prevRate > hpRate then
      hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
      hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
    elseif prevRate < hpRate then
      hpMain:ResetVertexAni(true)
      hpLater:ResetVertexAni(true)
      hpMain:SetAlpha(1)
      hpLater:SetAlpha(1)
    end
    hpMain:SetProgressRate(hpRate)
    hpLater:SetProgressRate(hpRate)
    hpBack:SetShow(true)
    hpLater:SetShow(true)
    hpMain:SetShow(true)
    if houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isKingOrLordTent() and _ContetnsGroup_SiegeResource then
      local isMyGuild = houseHoldActorWrapper:get():isOwnedBySelfPlayerGuild()
      if isMyGuild then
        local resourceBack = UI.getChildControl(targetPanel, "Static_SiegeResourcesStackBg")
        local resourceMain = UI.getChildControl(targetPanel, "Progress2_SiegeResourcesStack")
        local prevResources = resourceMain:GetProgressRate()
        local resourceRate = ToClient_GetMyGuildAllianceSiegeResource() * 100 / ToClient_GetSiegeMaxResources()
        resourceMain:SetProgressRate(resourceRate)
        resourceBack:SetShow(true)
        resourceMain:SetShow(true)
      end
    end
  elseif actorProxy:isInstanceObject() then
    if actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isBarricade() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isHealingTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isObservatory() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isElephantBarn() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isRepairingTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isMineFactory() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isBombFactory() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isDistributor() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isSiegeTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isLargeSiegeTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isDefenceTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isSiegeTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isLargeSiegeTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isAdvancedBaseTower() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isTankFactory() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isSavageDefenceObject() or actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isBallistaFactory() then
      local prevRate = hpMain:GetProgressRate()
      local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
      hpMain:SetProgressRate(hpRate)
      hpLater:SetProgressRate(hpRate)
      if prevRate > hpRate then
        hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
        hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
      elseif prevRate < hpRate then
        if hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() then
          hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
        end
        hpMain:ResetVertexAni(true)
        hpLater:ResetVertexAni(true)
        hpMain:SetAlpha(1)
        hpLater:SetAlpha(1)
      end
      hpBack:SetShow(true)
      hpLater:SetShow(true)
      hpMain:SetShow(true)
    elseif actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus():isTrap() then
      hpBack:SetShow(false)
      hpLater:SetShow(false)
      hpMain:SetShow(false)
    end
  else
    if actorProxy:isVehicle() then
      local vehicleActorWrapper = getVehicleActorByProxy(actorProxy)
      if nil ~= vehicleActorWrapper and (CppEnums.VehicleType.Type_ThrowStone == vehicleActorWrapper:get():getVehicleType() or CppEnums.VehicleType.Type_ThrowFire == vehicleActorWrapper:get():getVehicleType() or CppEnums.VehicleType.Type_WoodenFence == vehicleActorWrapper:get():getVehicleType()) then
        local prevRate = hpMain:GetProgressRate()
        local hpRate = actorProxy:getHp() * 100 / actorProxy:getMaxHp()
        hpMain:SetProgressRate(hpRate)
        hpLater:SetProgressRate(hpRate)
        if prevRate > hpRate then
          hpMain:SetVertexAniRun("Ani_Color_Damage_0", true)
          hpLater:SetVertexAniRun("Ani_Color_Damage_White", true)
        elseif prevRate < hpRate then
          if hpLater:GetCurrentProgressRate() < hpMain:GetCurrentProgressRate() then
            hpLater:SetCurrentProgressRate(hpMain:GetCurrentProgressRate())
          end
          hpMain:ResetVertexAni(true)
          hpLater:ResetVertexAni(true)
          hpMain:SetAlpha(1)
          hpLater:SetAlpha(1)
        end
        hpBack:SetShow(true)
        hpLater:SetShow(true)
        hpMain:SetShow(true)
      else
        hpBack:SetShow(false)
        hpLater:SetShow(false)
        hpMain:SetShow(false)
      end
    else
    end
  end
end
local function CharacterNameTag_HpBarUpdateCheck()
  for _, hpBarData in pairs(_characterHpBarContainer) do
    if nil ~= hpBarData then
      if hpBarData.currentHpIdx ~= hpBarData.targetHpIdx then
        hpBarData.stackHpBar:SetAniSpeed(1 / (math.abs(hpBarData.currentHpIdx - hpBarData.targetHpIdx) + 1))
        if hpBarData.currentHpIdx < hpBarData.targetHpIdx then
          hpBarData.stackHpBar:SetProgressRate(100)
        elseif hpBarData.targetHpIdx < hpBarData.currentHpIdx then
          hpBarData.stackHpBar:SetProgressRate(0)
        end
      end
      if hpBarData.currentHpIdx == hpBarData.targetHpIdx then
        hpBarData.stackHpBar:SetProgressRate(hpBarData.currentHpRate)
      elseif 100 <= hpBarData.stackHpBar:GetCurrentProgressRate() then
        hpBarData.currentHpIdx = hpBarData.currentHpIdx + 1
        if hpBarData.currentHpIdx >= _maxHpBarColorCount * 2 then
          hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
          hpBarData.stackHpBar:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
        else
          local colorValue = hpBarData.currentHpIdx % _maxHpBarColorCount
          local backColorValue = colorValue - 1
          if hpBarData.currentHpIdx <= 0 then
            backColorValue = -1
          elseif backColorValue < 0 then
            backColorValue = _maxHpBarColorCount - 1
          end
          hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[backColorValue])
          hpBarData.stackHpBar:SetColor(_stackHpBarColor[colorValue])
        end
        hpBarData.stackHpBar:SetProgressRate(0)
      elseif 0 >= hpBarData.stackHpBar:GetCurrentProgressRate() then
        hpBarData.currentHpIdx = hpBarData.currentHpIdx - 1
        hpBarData.stackHpBar:SetProgressRate(100)
        if hpBarData.currentHpIdx >= _maxHpBarColorCount * 2 then
          hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
          hpBarData.stackHpBar:SetColor(_stackHpBarColor[_maxHpBarColorCount - 1])
        else
          local colorValue = hpBarData.currentHpIdx % _maxHpBarColorCount
          local backColorValue = colorValue - 1
          if hpBarData.currentHpIdx <= 0 then
            backColorValue = -1
          elseif backColorValue < 0 then
            backColorValue = _maxHpBarColorCount - 1
          end
          hpBarData.stackHpBarBackColor:SetColor(_stackHpBarColor[backColorValue])
          hpBarData.stackHpBar:SetColor(_stackHpBarColor[colorValue])
        end
      end
    end
  end
end
function PaGlobal_WaitUntilHpBarChange_UpdateFunc()
  if true == GameOption_GetShowStackHp() and true == _ContentsGroup_StackingHpBar then
    CharacterNameTag_HpBarUpdateCheck()
  end
end
local function settingMpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  local mpBack = UI.getChildControl(targetPanel, "ProgressBack_ManaResource")
  local mpMain = UI.getChildControl(targetPanel, "Character_ManaResource")
  if nil == mpBack or nil == mpMain then
    return
  end
  local instanceObject = actorProxyWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus()
  if actorProxy:isSelfPlayer() then
    local playerWrapper = getSelfPlayer()
    local mp = playerWrapper:get():getMp()
    local maxMp = playerWrapper:get():getMaxMp()
    local mpRate = mp * 100 / maxMp
    mpMain:SetProgressRate(mpRate)
    mpMain:SetCurrentProgressRate(mpRate)
    local isEP_Character = __eClassType_ElfRanger == playerWrapper:getClassType() or __eClassType_RangerMan == playerWrapper:getClassType() or __eClassType_ShyWaman == playerWrapper:getClassType()
    local isFP_Character = __eClassType_Warrior == playerWrapper:getClassType() or __eClassType_Giant == playerWrapper:getClassType() or __eClassType_BladeMaster == playerWrapper:getClassType() or __eClassType_BladeMasterWoman == playerWrapper:getClassType() or __eClassType_Kunoichi == playerWrapper:getClassType() or __eClassType_NinjaMan == playerWrapper:getClassType() or __eClassType_Combattant == playerWrapper:getClassType() or __eClassType_Mystic == playerWrapper:getClassType() or __eClassType_Lhan == playerWrapper:getClassType()
    local isBP_Character = __eClassType_Valkyrie == playerWrapper:getClassType()
    local isOnlyDarkelf = __eClassType_DarkElf == playerWrapper:getClassType()
    local isMP_Character = not isEP_Character and not isFP_Character and not isBP_Character and not isOnlyDarkelf
    if isEP_Character then
      mpMain:SetColor(_mpBarColor.ep_Character)
    elseif isFP_Character then
      mpMain:SetColor(_mpBarColor.fp_Character)
    elseif isBP_Character then
      mpMain:SetColor(_mpBarColor.bp_Character)
    elseif isOnlyDarkelf then
      mpMain:SetColor(_mpBarColor.darkelf)
    elseif isMP_Character then
      mpMain:SetColor(_mpBarColor.mp_Character)
    end
    if 0 ~= isColorBlindMode then
      mpMain:SetColor(Defines.Color.C_FFEE9900)
    end
    mpBack:SetShow(true)
    mpMain:SetShow(true)
  elseif actorProxy:isInstanceObject() then
    if instanceObject:isBarricade() or instanceObject:isHealingTower() or instanceObject:isObservatory() or instanceObject:isElephantBarn() or instanceObject:isRepairingTower() or instanceObject:isMineFactory() or instanceObject:isBombFactory() or instanceObject:isDistributor() or instanceObject:isSiegeTower() or instanceObject:isLargeSiegeTower() or instanceObject:isDefenceTower() or instanceObject:isAdvancedBaseTower() or instanceObject:isTankFactory() or instanceObject:isSavageDefenceObject() or instanceObject:isBallistaFactory() then
      local isShowMp = false
      local instanceObjectActorWrapper = getInstanceObjectActor(actorKeyRaw)
      if nil ~= instanceObjectActorWrapper then
        local objectSS = instanceObjectActorWrapper:getCharacterStaticStatusWrapper():getObjectStaticStatus()
        if instanceObjectActorWrapper:isActionType_BuildingStart() then
          isShowMp = true
        elseif objectSS:isElephantBarn() or objectSS:isObservatory() or objectSS:isSiegeTower() or objectSS:isLargeSiegeTower() or objectSS:isAdvancedBaseTower() or objectSS:isTankFactory() or objectSS:isBallistaFactory() then
          isShowMp = true
        end
      end
      if true == isShowMp then
        local mp = actorProxyWrapper:get():getMp()
        local maxMp = actorProxyWrapper:get():getMaxMp()
        local mpRate = mp * 100 / maxMp
        mpMain:SetProgressRate(mpRate)
        mpMain:SetCurrentProgressRate(mpRate)
        mpMain:SetColor(Defines.Color.C_FFA3EF00)
        mpBack:SetShow(true)
        mpMain:SetShow(true)
      else
        mpBack:SetShow(false)
        mpMain:SetShow(false)
      end
    else
      mpBack:SetShow(false)
      mpMain:SetShow(false)
    end
  elseif actorProxy:isVehicle() then
    if actorProxy:getCharacterStaticStatus():isSiegeBastille() or actorProxy:getCharacterStaticStatus():isSiegeFrameTower() or actorProxy:getCharacterStaticStatus():isWoodenFence() then
      local isShowMp = true
      local vehicleActorWrapper = getVehicleActorByProxy(actorProxy)
      if nil ~= vehicleActorWrapper then
        if vehicleActorWrapper:isActionType_BuildingStart() then
          isShowMp = true
        else
          isShowMp = false
        end
      end
      if true == isShowMp then
        local mp = actorProxyWrapper:get():getMp()
        local maxMp = actorProxyWrapper:get():getMaxMp()
        local mpRate = mp * 100 / maxMp
        mpMain:SetProgressRate(mpRate)
        mpMain:SetCurrentProgressRate(mpRate)
        mpMain:SetColor(Defines.Color.C_FFA3EF00)
        mpBack:SetShow(true)
        mpMain:SetShow(true)
      else
        mpBack:SetShow(false)
        mpMain:SetShow(false)
      end
    else
      mpBack:SetShow(false)
      mpMain:SetShow(false)
    end
  else
    mpBack:SetShow(false)
    mpMain:SetShow(false)
  end
end
local function settingLocalWarCombatPoint(actorKeyRaw, targetPanel, actorProxyWrapper)
  if nil == actorProxyWrapper then
    return
  end
  local actorProxy = actorProxyWrapper:get()
  if nil == actorProxy then
    return
  end
  if false == actorProxy:isPlayer() then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  if nil == playerActorProxy then
    return
  end
  local txt_WarPoint = UI.getChildControl(targetPanel, "CharacterWarPoint")
  local lifeIcon = {
    [0] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_0"),
    [1] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_1"),
    [2] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_2"),
    [3] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_3"),
    [4] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_4"),
    [5] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_5"),
    [6] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_6"),
    [7] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_7"),
    [8] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_8"),
    [9] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_9"),
    [10] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_10"),
    [11] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_11"),
    [12] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_12"),
    [13] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_13")
  }
  local competitionTeamNo = playerActorProxyWrapper:getCompetitionTeamNo()
  local warCombatPoint = playerActorProxyWrapper:getLocalWarCombatPoint()
  if warCombatPoint > 0 then
    local hasTitle = false
    if playerActorProxyWrapper:checkToTitleKey() then
      if playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() then
        hasTitle = false
      else
        hasTitle = true
      end
    else
      hasTitle = false
    end
    local hasGuild = playerActorProxy:isGuildMember() and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged())
    local warPointPos = 0
    if true == hasTitle and true == hasGuild then
      warPointPos = 80
    elseif hasTitle ~= hasGuild then
      warPointPos = 60
    else
      warPointPos = 40
    end
    local nameColor
    if warCombatPoint < 50 then
      nameColor = UI_color.C_FFA1A1A1
    elseif warCombatPoint < 100 then
      nameColor = UI_color.C_FFFFFFFF
    elseif warCombatPoint < 150 then
      nameColor = UI_color.C_FFFFE050
    elseif warCombatPoint < 200 then
      nameColor = UI_color.C_FF75FF50
    elseif warCombatPoint < 250 then
      nameColor = UI_color.C_FF00FFD8
    elseif warCombatPoint < 300 then
      nameColor = UI_color.C_FFFF00D8
    elseif warCombatPoint < 350 then
      nameColor = UI_color.C_FFFF7200
    else
      nameColor = UI_color.C_FFFF0000
    end
    local scaleBuffer = txt_WarPoint:GetScale()
    txt_WarPoint:SetScale(1, 1)
    txt_WarPoint:SetFontColor(nameColor)
    txt_WarPoint:SetText("+" .. warCombatPoint)
    txt_WarPoint:SetShow(true)
    txt_WarPoint:SetSpanSize(txt_WarPoint:GetSpanSize().x, warPointPos)
    txt_WarPoint:SetScale(scaleBuffer.x, scaleBuffer.y)
    txt_WarPoint:ComputePos()
    for idx = 0, 13 do
      lifeIcon[idx]:SetShow(false)
    end
  elseif competitionTeamNo >= 0 then
    local hasTitle = false
    if playerActorProxyWrapper:checkToTitleKey() then
      if playerActorProxy:isHideCharacterName() and false == playerActorProxy:isFlashBanged() then
        hasTitle = false
      else
        hasTitle = true
      end
    else
      hasTitle = false
    end
    local hasGuild = playerActorProxy:isGuildMember() and (false == playerActorProxy:isHideGuildName() or playerActorProxy:isFlashBanged())
    local warPointPos = 0
    if true == hasTitle and true == hasGuild then
      warPointPos = 80
    elseif hasTitle ~= hasGuild then
      warPointPos = 60
    else
      warPointPos = 40
    end
    local nameColor = FGlobal_TeamColorList(competitionTeamNo - 1)
    local scaleBuffer = txt_WarPoint:GetScale()
    txt_WarPoint:SetScale(1, 1)
    txt_WarPoint:SetFontColor(nameColor)
    txt_WarPoint:SetShow(true)
    txt_WarPoint:SetSpanSize(txt_WarPoint:GetSpanSize().x, warPointPos)
    txt_WarPoint:SetScale(scaleBuffer.x, scaleBuffer.y)
    txt_WarPoint:ComputePos()
    txt_WarPoint:SetText("")
    local needOverHeadNameTag = 0 == ToClient_CompetitionMatchType() or 2 == ToClient_CompetitionMatchType()
    if true == needOverHeadNameTag and 0 ~= competitionTeamNo then
      local teamA_Info, teamB_Info
      if 0 == ToClient_CompetitionMatchType() then
        teamA_Info = ToClient_GetTeamListAt(0)
        teamB_Info = ToClient_GetTeamListAt(1)
      elseif 2 == ToClient_CompetitionMatchType() then
        teamA_Info = ToClient_GetArshaTeamInfo(1)
        teamB_Info = ToClient_GetArshaTeamInfo(2)
      end
      local teamA_Name = ""
      local teamB_Name = ""
      if nil ~= teamA_Info and nil ~= teamB_Info then
        teamA_Name = teamA_Info:getTeamName()
        teamB_Name = teamB_Info:getTeamName()
      end
      if "" ~= teamA_Name and "" ~= teamB_Name then
        if 1 == competitionTeamNo then
          txt_WarPoint:SetText("[ " .. teamA_Name .. " ]")
        elseif 2 == competitionTeamNo then
          txt_WarPoint:SetText("[ " .. teamB_Name .. " ]")
        end
      elseif 1 == competitionTeamNo then
        txt_WarPoint:SetText("[ " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_A") .. " ]")
      elseif 2 == competitionTeamNo then
        txt_WarPoint:SetText("[ " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMPETITION_TEAM_B") .. " ]")
      end
    elseif 1 == ToClient_CompetitionMatchType() and 0 ~= competitionTeamNo then
      local leaderInfo = ToClient_GetTeamLeaderInfo(competitionTeamNo)
      if nil ~= leaderInfo then
        txt_WarPoint:SetText("[ " .. leaderInfo:getCharacterName() .. " ]")
      end
    end
    for idx = 0, 13 do
      lifeIcon[idx]:SetShow(false)
    end
  else
    txt_WarPoint:SetText(0)
    txt_WarPoint:SetShow(false)
    local insertedArray = Array.new()
    settingLifeRankIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  end
end
function FGlobal_SettingMpBarTemp()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if nil == selfPlayer:get():getUIPanel() then
    return
  end
  settingMpBar(selfPlayer:get():getActorKeyRaw(), selfPlayer:get():getUIPanel(), selfPlayer)
end
local settingStun = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local stunBack = UI.getChildControl(targetPanel, "ProgressBack_Stun")
  local stunProgress = UI.getChildControl(targetPanel, "CharacterStunGageProgress")
  stunBack:SetShow(false)
  stunProgress:SetShow(false)
  if nil == stunBack or nil == stunProgress then
    return
  end
  local characterActorProxyWrapper = getCharacterActor(actorKeyRaw)
  if nil == characterActorProxyWrapper then
    return
  end
  local characterActorProxy = characterActorProxyWrapper:get()
  if characterActorProxy:hasStun() then
    local stun = characterActorProxy:getStun()
    local maxStun = characterActorProxy:getMaxStun()
    if 0 ~= stun then
      stunProgress:SetProgressRate(stun / maxStun * 100)
      stunProgress:SetShow(true)
    else
      stunBack:SetShow(false)
      stunProgress:SetShow(false)
    end
  else
    stunBack:SetShow(false)
    stunProgress:SetShow(false)
  end
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
local function settingPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
  local preemptiveStrikeBeing
  if false == ToClient_isConsole() then
    preemptiveStrikeBeing = UI.getChildControl(targetPanel, "Static_PreemptiveStrikeBeing")
  else
    preemptiveStrikeBeing = UI.getChildControl(targetPanel, "Static_PreemptiveStrikeBeingXbox")
  end
  if nil == preemptiveStrikeBeing then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  local isPvpModeOn = playerActorProxy:isPvPMode()
  local isShowPvpIcon = playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike) or isPvpModeOn
  preemptiveStrikeBeing:SetShow(isShowPvpIcon)
  local tendencyColor = PvpIconColorByTendency(actorKeyRaw)
  if playerActorProxy:isPreemptiveStrikeBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.preemptiveStrike) then
    preemptiveStrikeBeing:ChangeTextureInfoNameAsync("New_UI_Common_ForLua/Default/Default_Buttons_02.dds")
    if ToClient_isConsole() then
      preemptiveStrikeBeing:ChangeTextureInfoNameAsync("renewal/Button/Console_Toggle_00.dds")
    end
    local x1, y1, x2, y2 = setTextureUV_Func(preemptiveStrikeBeing, preemptiveIconTexture[tendencyColor].x1, preemptiveIconTexture[tendencyColor].y1, preemptiveIconTexture[tendencyColor].x2, preemptiveIconTexture[tendencyColor].y2)
    preemptiveStrikeBeing:getBaseTexture():setUV(x1, y1, x2, y2)
    preemptiveStrikeBeing:setRenderTexture(preemptiveStrikeBeing:getBaseTexture())
  else
    preemptiveStrikeBeing:ChangeTextureInfoNameAsync("New_UI_Common_ForLua/Default/Default_Buttons_02.dds")
    if ToClient_isConsole() then
      preemptiveStrikeBeing:ChangeTextureInfoNameAsync("renewal/Button/Console_Toggle_00.dds")
    end
    local x1, y1, x2, y2 = setTextureUV_Func(preemptiveStrikeBeing, pvpIconTexture[tendencyColor].x1, pvpIconTexture[tendencyColor].y1, pvpIconTexture[tendencyColor].x2, pvpIconTexture[tendencyColor].y2)
    preemptiveStrikeBeing:getBaseTexture():setUV(x1, y1, x2, y2)
    preemptiveStrikeBeing:setRenderTexture(preemptiveStrikeBeing:getBaseTexture())
  end
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
end
function PvpIconColorByTendency(actorKeyRaw)
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  local tendency = playerActorProxy:getTendency()
  if tendency >= 150000 then
    tendencyColor = 0
  elseif tendency >= 0 and tendency < 150000 then
    tendencyColor = 1
  elseif tendency >= -5000 and tendency < 0 then
    tendencyColor = 2
  else
    tendencyColor = 3
  end
  return tendencyColor
end
local function settingMurderer(actorKeyRaw, targetPanel, actorProxyWrapper)
  local murdererMark = UI.getChildControl(targetPanel, "Static_MurdererMark")
  if nil == murdererMark then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxyWrapper then
    return
  end
  local playerActorProxy = playerActorProxyWrapper:get()
  murdererMark:SetShow(playerActorProxy:isMurdererStateBeing() and false == playerActorProxy:isHideTimeOver(hideTimeType.murdererEnd))
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
end
local function settingGuildTextForAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
  if nil == targetPanel then
    return
  end
  if 3 ~= targetPanel:getActorProxyTypeForNameTag() and 4 ~= targetPanel:getActorProxyTypeForNameTag() then
    return
  end
  local playerActorProxyWrapper = getPlayerActor(actorKeyRaw)
  local guildName = UI.getChildControl(targetPanel, "CharacterGuild")
  local alias = UI.getChildControl(targetPanel, "CharacterAlias")
  local lifeRankIcon = {}
  local actorProxy = actorProxyWrapper:get()
  if actorProxy:isPlayer() then
    for i = 0, lifeContentCount - 1 do
      lifeRankIcon[i] = UI.getChildControl(targetPanel, "Static_LifeRankIcon_" .. i)
      if nil == lifeRankIcon[i] then
        return
      end
    end
  end
  if nil == guildName or nil == alias or nil == playerActorProxyWrapper then
    return
  end
  for i = 0, lifeContentCount - 1 do
    if nil == lifeRankIcon[i] then
      return
    end
  end
  local scaleBuffer = alias:GetScale()
  guildName:SetScale(1, 1)
  alias:SetScale(1, 1)
  for i = 0, lifeContentCount - 1 do
    lifeRankIcon[i]:SetScale(1, 1)
  end
  local spanY = alias:GetSpanSize().y
  if playerActorProxyWrapper:checkToTitleKey() then
    spanY = spanY + alias:GetSizeY()
  end
  guildName:SetSpanSize(guildName:GetSpanSize().x, spanY)
  if playerActorProxyWrapper:get():isGuildMember() and (false == playerActorProxyWrapper:get():isHideGuildName() or playerActorProxyWrapper:get():isFlashBanged()) then
    spanY = spanY + guildName:GetSizeY()
  end
  for i = 0, lifeContentCount - 1 do
    lifeRankIcon[i]:SetSpanSize(lifeRankIcon[i]:GetSpanSize().x, spanY)
  end
  guildName:SetScale(scaleBuffer.x, scaleBuffer.y)
  alias:SetScale(scaleBuffer.x, scaleBuffer.y)
  for i = 0, lifeContentCount - 1 do
    lifeRankIcon[i]:SetScale(scaleBuffer.x, scaleBuffer.y)
  end
end
local settingQuestMark = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  local questMark = UI.getChildControl(targetPanel, "Static_Quest_Mark")
  if nil == questMark then
    return
  end
  if isQuestMonsterByKey(actorKeyRaw) then
    questMark:SetShow(true)
  else
    questMark:SetShow(false)
  end
end
local settingQuestMarkForce = function(isShow, targetPanel, actorProxyWrapper)
  local questMark = UI.getChildControl(targetPanel, "Static_Quest_Mark")
  if nil == questMark then
    return
  end
  questMark:SetShow(isShow)
end
function questIconOverTooltip(show, actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  local panel = actorProxyWrapper:get():getUIPanel()
  local questStaticStatusWrapper = npcActorProxyWrapper:getQuestStatisStatusWrapper()
  if nil == questStaticStatusWrapper then
    return
  end
  local questTitle = questStaticStatusWrapper:getTitle()
  local questTitleTooltip = UI.getChildControl(panel, "StaticText_QuestTooltip")
  local questIcon = UI.getChildControl(panel, "Static_QuestIcon")
  if true == show then
    local prevScale = questIcon:GetScale()
    questTitleTooltip:SetScale(1, 1)
    questTitleTooltip:SetShow(true)
    questTitleTooltip:SetText(questTitle)
    questTitleTooltip:SetSize(questTitleTooltip:GetTextSizeX() + 20, questTitleTooltip:GetSizeY())
    questTitleTooltip:SetSpanSize(questIcon:GetSpanSize().x, questTitleTooltip:GetSpanSize().y - 20)
    questTitleTooltip:SetAlpha(1)
    questTitleTooltip:SetFontAlpha(1)
  else
    questTitleTooltip:SetShow(false)
  end
end
local currentTypeChangeCheck = {}
local function settingQuestUI(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
  local questIcon = UI.getChildControl(targetPanel, "Static_QuestIcon")
  local questBorder = UI.getChildControl(targetPanel, "Static_QuestIconBorder")
  local questClear = UI.getChildControl(targetPanel, "Static_QuestClear")
  local lookAtMe = UI.getChildControl(targetPanel, "Static_LookAtMe")
  local lookAtMe2 = UI.getChildControl(targetPanel, "Static_LookAtMe2")
  local questType = UI.getChildControl(targetPanel, "Static_QuestType")
  local npcActorProxyWrapper = getNpcActor(actorKeyRaw)
  if nil == questIcon or nil == questBorder or nil == questClear or nil == lookAtMe or nil == lookAtMe2 or nil == npcActorProxyWrapper then
    return
  end
  local questStaticStatusWrapper = npcActorProxyWrapper:getQuestStatisStatusWrapper()
  if nil == questStaticStatusWrapper then
    questIcon:SetShow(false)
    questBorder:SetShow(false)
    questClear:SetShow(false)
    lookAtMe:SetShow(false)
    lookAtMe2:SetShow(false)
    questType:SetShow(false)
    return
  end
  local currentType = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
  local isShow = 0 ~= currentType
  questIcon:addInputEvent("Mouse_On", "questIconOverTooltip( true,\t" .. actorKeyRaw .. " )")
  questIcon:addInputEvent("Mouse_Out", "questIconOverTooltip( false,\t" .. actorKeyRaw .. " )")
  questIcon:ChangeTextureInfoNameAsync(questStaticStatusWrapper:getIconPath())
  questIcon:SetAlpha(1)
  questBorder:SetAlpha(1)
  questClear:SetAlpha(1)
  lookAtMe:SetAlpha(1)
  lookAtMe2:SetAlpha(1)
  questType:SetAlpha(1)
  questIcon:SetAlphaIgnore(true)
  questBorder:SetAlphaIgnore(true)
  questClear:SetAlphaIgnore(true)
  lookAtMe:SetAlphaIgnore(true)
  lookAtMe2:SetAlphaIgnore(true)
  questType:SetAlphaIgnore(true)
  questIcon:SetScaleMinimum(0.5)
  questBorder:SetScaleMinimum(0.5)
  questClear:SetScaleMinimum(0.5)
  lookAtMe:SetScaleMinimum(0.5)
  lookAtMe2:SetScaleMinimum(0.5)
  questType:SetScaleMinimum(0.5)
  questIcon:SetShow(isShow)
  questBorder:SetShow(isShow)
  questClear:SetShow(3 == currentType)
  lookAtMe:SetShow(isShow)
  lookAtMe2:SetShow(isShow)
  questType:SetShow(isShow)
  if isShow then
    local prevAlpha = questBorder:GetAlpha()
    questType:SetShow(false)
    if 3 == currentType then
      lookAtMe:SetColor(Defines.Color.C_FFF26A6A)
      lookAtMe2:SetColor(Defines.Color.C_FFF26A6A)
      if true == PaGlobal_Interaction_GetShow() and true ~= currentTypeChangeCheck[actorKeyRaw] then
        Interaction_Close()
      end
      currentTypeChangeCheck[actorKeyRaw] = true
    elseif 2 == currentType then
      lookAtMe:SetShow(true)
      lookAtMe:SetColor(Defines.Color.C_FF6DC6FF)
      lookAtMe2:SetShow(true)
      lookAtMe2:SetColor(Defines.Color.C_FF6DC6FF)
      currentTypeChangeCheck[actorKeyRaw] = false
    elseif 1 == currentType then
      lookAtMe:SetShow(true)
      lookAtMe:SetColor(Defines.Color.C_FFFFEEA0)
      lookAtMe2:SetShow(true)
      lookAtMe2:SetColor(Defines.Color.C_FFFFEEA0)
      currentTypeChangeCheck[actorKeyRaw] = false
    end
    questBorder:SetAlpha(prevAlpha)
    local aControl = {
      questIcon = questIcon,
      questBorder = questBorder,
      questClear = questClear,
      lookAtMe = lookAtMe,
      lookAtMe2 = lookAtMe2,
      questType = questType,
      GetSizeX = function()
        return questBorder:GetSizeX()
      end,
      SetScale = function(self, x, y)
        questBorder:SetScale(x, y)
        questIcon:SetScale(x, y)
        questClear:SetScale(x, y)
        lookAtMe:SetScale(x, y)
        lookAtMe2:SetScale(x, y)
        questType:SetScale(x, y)
      end,
      SetSpanSize = function(self, x, y)
        questBorder:SetSpanSize(x + 8, y)
        questIcon:SetSpanSize(x + 8, y + 18)
        questClear:SetSpanSize(x + 8, y + 16)
        lookAtMe:SetSpanSize(x + 8, y + 14)
        lookAtMe2:SetSpanSize(x + 8, y + 10)
        questType:SetSpanSize(x + 8, y + 46)
      end,
      GetSpanSize = function()
        return questBorder:GetSpanSize()
      end,
      GetScale = function()
        return questBorder:GetScale()
      end,
      GetShow = function()
        return questBorder:GetShow()
      end
    }
    questBorder:SetColor(Defines.Color.C_FFFFFFFF)
    questClear:SetShow(false)
    questBorder:ChangeTextureInfoName(questFrameUV[0])
    local x1, y1, x2, y2 = 0, nil, nil, nil
    local questTypeNo = questStaticStatusWrapper:getQuestType()
    local questCurrentStatus = npcActorProxyWrapper:get():getOverHeadQuestInfoType()
    local questTypeIdx = 3
    local questSelectTypeNo = questStaticStatusWrapper:getSelectType()
    if (2 == questSelectTypeNo or 5 == questTypeNo) and 1 == questCurrentStatus then
      questCurrentStatus = 4
      lookAtMe:SetColor(Defines.Color.C_FF88DF00)
      lookAtMe2:SetColor(Defines.Color.C_FF88DF00)
    end
    if 0 == questTypeNo then
      questTypeIdx = 2
    elseif 1 == questTypeNo then
      questTypeIdx = 1
    elseif 6 == questTypeNo then
      questTypeIdx = 4
    else
      questTypeIdx = 3
    end
    x1, y1, x2, y2 = setTextureUV_Func(questBorder, questFrameUV[questTypeIdx][questCurrentStatus][1], questFrameUV[questTypeIdx][questCurrentStatus][2], questFrameUV[questTypeIdx][questCurrentStatus][3], questFrameUV[questTypeIdx][questCurrentStatus][4])
    questBorder:getBaseTexture():setUV(x1, y1, x2, y2)
    questBorder:setRenderTexture(questBorder:getBaseTexture())
    insertedArray:push_back(aControl)
  end
end
local settingBillBoardMode = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  houseHoldActorWrapper = getHouseHoldActor(actorKeyRaw)
  if nil ~= houseHoldActorWrapper and false == houseHoldActorWrapper:get():isTent() and false == houseHoldActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():isBarricade() then
    targetPanel:Set3DRenderType(2)
    targetPanel:Set3DOffsetZ(40)
  end
end
local function settingBubbleBox(actorKeyRaw, targetPanel, actorProxyWrapper, message)
  local targetStatic = UI.getChildControl(targetPanel, "StaticText_BubbleBox")
  local targetStaticBG = UI.getChildControl(targetPanel, "Static_BubbleBox")
  bubbleBox.lastShowDeltaTime = 0
  targetStatic:SetScale(1, 1)
  targetStaticBG:SetScale(1, 1)
  targetStatic:SetSize(210, 10)
  if true == ToClient_IsDevelopment() or true == isGameServiceTypeTurkey() then
    targetStatic:SetUseHarfBuzz(true)
  else
    targetStatic:SetUseHarfBuzz(false)
  end
  targetStatic:SetText(message)
  local initSizeY = targetStatic:GetSizeY()
  local sizeY = initSizeY + 40
  if 210 < targetStatic:GetTextSizeX() then
    targetStatic:SetSize(targetStatic:GetSizeX(), sizeY)
    targetStaticBG:SetSize(targetStatic:GetSizeX() + 18, sizeY)
  else
    targetStatic:SetSize(targetStatic:GetTextSizeX(), sizeY)
    targetStaticBG:SetSize(targetStatic:GetTextSizeX() + 27, sizeY)
  end
  if true == targetStatic:IsApplyHarfBuzz() then
    local fontHeight = targetStatic:GetFontHeight() + 2
    local lineCount = initSizeY / fontHeight - 1
    targetStatic:SetSpanSize(targetStaticBG:GetSpanSize().x - 10, targetStaticBG:GetSpanSize().y - lineCount * fontHeight)
  else
    targetStatic:SetSpanSize(targetStaticBG:GetSpanSize().x - 10, targetStaticBG:GetSpanSize().y)
  end
  local time
  if #message < 5 then
    time = 2.22
  elseif #message < 10 then
    time = 2.72
  elseif #message < 15 then
    time = 3.22
  elseif #message < 20 then
    time = 3.72
  elseif #message < 25 then
    time = 4.22
  elseif #message < 30 then
    time = 4.72
  else
    time = 5.22
  end
  ActorInsertShowTime(actorKeyRaw, hideTimeType.bubbleBox, time * 1000)
end
local settingBubbleBoxShow = function(actorKeyRaw, targetPanel, actorProxyWrapper, isShow)
  local targetStatic = UI.getChildControl(targetPanel, "StaticText_BubbleBox")
  local targetStaticBG = UI.getChildControl(targetPanel, "Static_BubbleBox")
  targetStatic:SetShow(isShow)
  targetStaticBG:SetShow(isShow)
end
local settingWaitCommentLaunch = function(isShow)
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local panel = selfPlayer:getWaitCommentPanel()
  if nil == panel then
    return
  end
  local targetBoard = UI.getChildControl(panel, "Static_Board")
  local targetPaper = UI.getChildControl(panel, "Static_Paper")
  local targetEditComment = UI.getChildControl(panel, "Edit_Txt")
  local targetPin_1 = UI.getChildControl(panel, "Static_Pin_1")
  local targetPin_2 = UI.getChildControl(panel, "Static_Pin_2")
  local targetPin_3 = UI.getChildControl(panel, "Static_Pin_3")
  local targetPin_4 = UI.getChildControl(panel, "Static_Pin_4")
  local targetRoll_L = UI.getChildControl(panel, "Static_Roll_L")
  local targetRoll_R = UI.getChildControl(panel, "Static_Roll_R")
  local targetPlayerID = UI.getChildControl(panel, "StaticText_ID")
  if isShow then
    local scaleBuffer = targetBoard:GetScale()
    targetBoard:SetScale(1, 1)
    targetEditComment:SetScale(1, 1)
    targetPaper:SetScale(1, 1)
    targetBoard:SetSize(100, 110)
    targetEditComment:SetSize(45, 56)
    targetPaper:SetSize(75, 56)
    targetBoard:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetEditComment:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetPaper:SetScale(scaleBuffer.x, scaleBuffer.y)
    local paperSizeX = targetPaper:GetSizeX()
    local paperPosX = targetPaper:GetPosX()
    targetEditComment:SetEditText("", false)
    targetEditComment:SetMaxInput(20)
    targetRoll_L:SetShow(true)
    targetRoll_R:SetShow(true)
    targetPaper:SetShow(true)
    targetEditComment:SetShow(true)
    targetPaper:SetIgnore(false)
    targetRoll_L:SetSpanSize(-paperSizeX / 2, targetRoll_L:GetSpanSize().y)
    targetRoll_R:SetSpanSize(paperSizeX / 2, targetRoll_R:GetSpanSize().y)
    targetPaper:addInputEvent("Mouse_LUp", "settingWaitCommentReady()")
  else
    targetRoll_L:SetShow(false)
    targetRoll_R:SetShow(false)
    targetPaper:SetShow(false)
    targetEditComment:SetShow(false)
  end
  targetBoard:SetShow(false)
  targetPlayerID:SetShow(false)
  targetPin_1:SetShow(false)
  targetPin_2:SetShow(false)
  targetPin_3:SetShow(false)
  targetPin_4:SetShow(false)
  targetEditComment:SetIgnore(true)
end
function settingWaitCommentReady()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local panel = selfPlayer:getWaitCommentPanel()
  if nil == panel then
    return
  end
  local targetBoard = UI.getChildControl(panel, "Static_Board")
  local targetPaper = UI.getChildControl(panel, "Static_Paper")
  local targetEditComment = UI.getChildControl(panel, "Edit_Txt")
  local targetPin_1 = UI.getChildControl(panel, "Static_Pin_1")
  local targetPin_2 = UI.getChildControl(panel, "Static_Pin_2")
  local targetPin_3 = UI.getChildControl(panel, "Static_Pin_3")
  local targetPin_4 = UI.getChildControl(panel, "Static_Pin_4")
  local targetRoll_L = UI.getChildControl(panel, "Static_Roll_L")
  local targetRoll_R = UI.getChildControl(panel, "Static_Roll_R")
  local targetPlayerID = UI.getChildControl(panel, "StaticText_ID")
  local scaleBuffer = targetEditComment:GetScale()
  targetEditComment:SetScale(1, 1)
  targetPaper:SetScale(1, 1)
  targetEditComment:SetSize(256, 56)
  targetPaper:SetSize(281, 56)
  targetEditComment:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetPaper:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetEditComment:ComputePos()
  targetPaper:ComputePos()
  local paperSizeX = targetPaper:GetSizeX()
  local paperPosX = targetPaper:GetPosX()
  targetRoll_L:SetSpanSize(-paperSizeX / 2, targetRoll_L:GetSpanSize().y)
  targetRoll_R:SetSpanSize(paperSizeX / 2, targetRoll_R:GetSpanSize().y)
  SetFocusEdit(targetEditComment)
  targetBoard:SetShow(false)
  targetPaper:SetShow(true)
  targetEditComment:SetShow(true)
  targetRoll_L:SetShow(true)
  targetRoll_R:SetShow(true)
  targetPlayerID:SetShow(false)
  targetPin_1:SetShow(false)
  targetPin_2:SetShow(false)
  targetPin_3:SetShow(false)
  targetPin_4:SetShow(false)
end
function settingWaitCommentConfirmReload()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  if false == selfPlayer:isShowWaitComment() then
    return
  end
  local panel = selfPlayer:getWaitCommentPanel()
  if nil == panel then
    return
  end
  local targetEditComment = UI.getChildControl(panel, "Edit_Txt")
  targetEditComment:SetEditText(selfPlayer:getWaitComment(), true)
  settingWaitCommentConfirm()
end
function settingWaitCommentConfirm()
  ClearFocusEdit()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local panel = selfPlayer:getWaitCommentPanel()
  if nil == panel then
    return
  end
  local targetBoard = UI.getChildControl(panel, "Static_Board")
  local targetPaper = UI.getChildControl(panel, "Static_Paper")
  local targetEditComment = UI.getChildControl(panel, "Edit_Txt")
  local targetPin_1 = UI.getChildControl(panel, "Static_Pin_1")
  local targetPin_2 = UI.getChildControl(panel, "Static_Pin_2")
  local targetPin_3 = UI.getChildControl(panel, "Static_Pin_3")
  local targetPin_4 = UI.getChildControl(panel, "Static_Pin_4")
  local targetRoll_L = UI.getChildControl(panel, "Static_Roll_L")
  local targetRoll_R = UI.getChildControl(panel, "Static_Roll_R")
  local targetPlayerID = UI.getChildControl(panel, "StaticText_ID")
  targetPlayerID:SetText("[" .. selfPlayerWrapper:getName() .. "]")
  targetBoard:SetShow(true)
  targetPlayerID:SetShow(true)
  targetPin_1:SetShow(true)
  targetPin_2:SetShow(true)
  targetPin_3:SetShow(true)
  targetPin_4:SetShow(true)
  targetEditComment:SetShow(true)
  targetPin_1:AddEffect("fUI_Repair01", false, 0, 0)
  targetPin_2:AddEffect("fUI_Repair01", false, 0, 0)
  targetPin_3:AddEffect("fUI_Repair01", false, 0, 0)
  targetPin_4:AddEffect("fUI_Repair01", false, 0, 0)
  targetRoll_L:SetShow(false)
  targetRoll_R:SetShow(false)
  targetEditComment:SetIgnore(true)
  targetPaper:SetIgnore(false)
  updateWaitComment(targetEditComment:GetEditText())
  targetEditComment:SetEditText(chatting_filteredText(targetEditComment:GetEditText()), true)
  local sizeY = targetEditComment:GetSizeY()
  local scaleBuffer = targetEditComment:GetScale()
  targetEditComment:SetScale(1, 1)
  targetPaper:SetScale(1, 1)
  targetBoard:SetScale(1, 1)
  targetPlayerID:SetScale(1, 1)
  if 256 < targetEditComment:GetTextSizeX() then
    targetBoard:SetSize(targetEditComment:GetSizeX() + 50, sizeY + 65)
    targetPaper:SetSize(targetEditComment:GetSizeX() + 25, sizeY + 10)
  else
    targetEditComment:SetSize(targetEditComment:GetTextSizeX(), targetEditComment:GetSizeY())
    targetPaper:SetSize(targetEditComment:GetTextSizeX() + 25, targetPaper:GetSizeY())
    targetBoard:SetSize(targetEditComment:GetTextSizeX() + 60, targetBoard:GetSizeY())
  end
  targetPlayerID:SetSize(targetPaper:GetSizeX(), targetPlayerID:GetSizeY())
  targetBoard:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetPaper:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetEditComment:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetPlayerID:SetScale(scaleBuffer.x, scaleBuffer.y)
  targetBoard:ComputePos()
  targetPaper:ComputePos()
  targetEditComment:ComputePos()
  targetPlayerID:ComputePos()
  targetPin_1:SetSpanSize(targetPaper:GetPosX() + 5, targetPin_1:GetSpanSize().y)
  targetPin_2:SetSpanSize(targetPaper:GetPosX() + targetPaper:GetSizeX() - 15, targetPin_2:GetSpanSize().y)
  targetPin_3:SetSpanSize(targetPaper:GetPosX() + 5, targetPin_3:GetSpanSize().y)
  targetPin_4:SetSpanSize(targetPaper:GetPosX() + targetPaper:GetSizeX() - 15, targetPin_4:GetSpanSize().y)
end
function WaitComment_CheckCurrentUiEdit(targetUI)
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return false
  end
  local selfPlayer = selfPlayerWrapper:get()
  local panel = selfPlayer:getWaitCommentPanel()
  if nil == panel then
    return false
  end
  local targetEditComment = UI.getChildControl(panel, "Edit_Txt")
  return nil ~= targetUI and targetUI:GetKey() == targetEditComment:GetKey()
end
local settingWaitComment = function(actorKeyRaw, panel, actorProxyWrapper, isShow, isforce)
  local selfPlayer = getSelfPlayer()
  local selfActorKeyRaw = selfPlayer:getActorKey()
  if actorKeyRaw == selfActorKeyRaw and true ~= isforce then
    return
  end
  local targetPanel = panel
  if actorProxyWrapper:get():isSelfPlayer() then
    targetPanel = getSelfPlayer():get():getWaitCommentPanel()
  end
  local playerActorProxy = getPlayerActor(actorKeyRaw)
  if nil == playerActorProxy then
    return
  end
  local message = playerActorProxy:get():getWaitComment()
  local targetBoard = UI.getChildControl(targetPanel, "Static_Board")
  local targetPaper = UI.getChildControl(targetPanel, "Static_Paper")
  local targetEditComment = UI.getChildControl(targetPanel, "Edit_Txt")
  local targetPin_1 = UI.getChildControl(targetPanel, "Static_Pin_1")
  local targetPin_2 = UI.getChildControl(targetPanel, "Static_Pin_2")
  local targetPin_3 = UI.getChildControl(targetPanel, "Static_Pin_3")
  local targetPin_4 = UI.getChildControl(targetPanel, "Static_Pin_4")
  local targetPlayerID = UI.getChildControl(targetPanel, "StaticText_ID")
  if isShow and nil ~= message and "" ~= message then
    targetBoard:SetShow(true)
    targetPaper:SetShow(true)
    targetEditComment:SetShow(true)
    targetPin_1:SetShow(true)
    targetPin_2:SetShow(true)
    targetPin_3:SetShow(true)
    targetPin_4:SetShow(true)
    targetPlayerID:SetShow(true)
    local scaleBuffer = targetEditComment:GetScale()
    targetEditComment:SetScale(1, 1)
    targetBoard:SetScale(1, 1)
    targetPaper:SetScale(1, 1)
    targetPlayerID:SetScale(1, 1)
    targetEditComment:SetSize(256, 56)
    targetPlayerID:SetText("[" .. playerActorProxy:getName() .. "]")
    targetEditComment:SetText(message)
    local sizeY = targetEditComment:GetSizeY()
    targetEditComment:SetSize(targetEditComment:GetTextSizeX(), targetEditComment:GetSizeY())
    targetBoard:SetSize(targetEditComment:GetTextSizeX() + 60, targetBoard:GetSizeY())
    targetPaper:SetSize(targetEditComment:GetTextSizeX() + 25, targetPaper:GetSizeY())
    targetPlayerID:SetSize(targetPaper:GetSizeX(), targetPlayerID:GetSizeY())
    targetEditComment:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetBoard:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetPaper:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetPlayerID:SetScale(scaleBuffer.x, scaleBuffer.y)
    targetBoard:ComputePos()
    targetPaper:ComputePos()
    targetEditComment:ComputePos()
    targetPlayerID:ComputePos()
    targetPin_1:SetSpanSize(-targetEditComment:GetTextSizeX() / 2, 40)
    targetPin_2:SetSpanSize(targetEditComment:GetTextSizeX() / 2, 40)
    targetPin_3:SetSpanSize(targetEditComment:GetTextSizeX() / 2, 5)
    targetPin_4:SetSpanSize(-targetEditComment:GetTextSizeX() / 2, 5)
  else
    targetBoard:SetShow(false)
    targetPaper:SetShow(false)
    targetEditComment:SetShow(false)
    targetPin_1:SetShow(false)
    targetPin_2:SetShow(false)
    targetPin_3:SetShow(false)
    targetPin_4:SetShow(false)
    targetPlayerID:SetShow(false)
  end
end
local settingSelfPlayerNameHelpText = function(actorKeyRaw, panel, actorProxyWrapper)
end
local furnitureActorKeyRaw
function Furniture_Check(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  local actorProxy = actorProxyWrapper:get()
  local characterStaticStatus = actorProxy:getCharacterStaticStatus()
  furnitureActorKeyRaw = actorKeyRaw
  if nil == actorProxy or nil == characterStaticStatus or nil == actorKeyRaw then
    return
  end
  if actorProxy:isInstallationActor() then
    local installationActorWrapper = getInstallationActor(furnitureActorKeyRaw)
    if Panel_Housing:IsShow() then
      return
    end
    local installationType = installationActorWrapper:getStaticStatusWrapper():getObjectStaticStatus():getInstallationType()
    if false == isShowInstallationEnduranceType(installationType) then
      return
    end
    if toInt64(0, 0) == installationActorWrapper:getOwnerHouseholdNo_s64() or installationActorWrapper:isHavestInstallation() then
    else
      furnitureCheck = true
    end
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
end
function Funiture_Endurance_Hide()
  if true == furnitureCheck and nil ~= furnitureActorKeyRaw then
    local actorProxyWrapper = getActor(furnitureActorKeyRaw)
    if nil ~= actorProxyWrapper then
      local actorProxy = actorProxyWrapper:get()
      if actorProxy ~= nil then
        local panel = actorProxy:getUIPanel()
        if nil == panel then
          return
        end
        furnitureCheck = false
        settingHpBar(furnitureActorKeyRaw, panel, actorProxyWrapper)
      else
        _PA_LOG("LUA", "called function Funiture_Endurance_Hide() / actorProxyWrapper:get()\236\151\144\236\132\156 nullpointer\234\176\128 \236\152\168\235\139\164!!!!")
        return
      end
    else
      _PA_LOG("LUA", "called function Funiture_Endurance_Hide() / getActor( furnitureActorKeyRaw )\236\151\144\236\132\156 nullpointer\234\176\128 \236\152\168\235\139\164!!!!")
      return
    end
  end
  furnitureActorKeyRaw = nil
end
local TypeByLoadData = {
  [ActorProxyType.isActorProxy] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isCharacter] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isPlayer] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    local insertedArray = Array.new()
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPlayerName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLifeRankIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStun(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildTextForAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLocalWarCombatPoint(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMurderer(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStatTierIcon(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isSelfPlayer] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    local insertedArray = Array.new()
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPlayerName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLifeRankIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStun(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingSelfPlayerNameHelpText(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingWaitCommentConfirmReload()
    settingGuildTextForAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLocalWarCombatPoint(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMurderer(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStatTierIcon(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isOtherPlayer] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    local insertedArray = Array.new()
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPlayerName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildInfo(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLifeRankIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStun(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingWaitComment(actorKeyRaw, targetPanel, actorProxyWrapper, true)
    settingGuildTextForAlias(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingLocalWarCombatPoint(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMurderer(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStatTierIcon(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingGuildMarkAndPreemptiveStrike(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isAlterego] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isMonster] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMonsterName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingQuestMark(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingStun(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isNpc] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingTitle(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingQuestMark(actorKeyRaw, targetPanel, actorProxyWrapper)
    local insertedArray = Array.new()
    settingQuestUI(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingFirstTalk(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingImportantTalk(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    settingOtherHeadIcon(actorKeyRaw, targetPanel, actorProxyWrapper, insertedArray)
    sortCenterX(insertedArray)
  end,
  [ActorProxyType.isDeadBody] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isVehicle] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingQuestMark(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isGate] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isHouseHold] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingBillBoardMode(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isInstallationActor] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isCollect] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
  end,
  [ActorProxyType.isInstanceObject] = function(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingName(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBarInitState(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingHpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
    settingMpBar(actorKeyRaw, targetPanel, actorProxyWrapper)
  end
}
function EventActorCreated_NameTag(actorKeyRaw, targetPanel, actorProxyType, actorProxyWrapper)
  if nil ~= TypeByLoadData[actorProxyType] then
    TypeByLoadData[actorProxyType](actorKeyRaw, targetPanel, actorProxyWrapper)
  end
end
function FromClient_ChangeTopRankUser(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingGuildTextForAlias(actorKeyRaw, panel, actorProxyWrapper)
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
  settingPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
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
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingGuildTextForAlias(actorKeyRaw, panel, actorProxyWrapper)
  settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_EventActorUpdateTitleKey(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingAlias(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingGuildTextForAlias(actorKeyRaw, panel, actorProxyWrapper)
  settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
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
function EventActorPvpModeChange(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  if actorProxyWrapper:get():isPlayer() then
    settingPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  end
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
function EventActorHpChanged(actorKeyRaw, hp, maxHp)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
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
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  if actorProxyWrapper:get():isPlayer() then
    settingPlayerName(actorKeyRaw, panel, actorProxyWrapper)
    settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
    settingStatTierIcon(actorKeyRaw, panel, actorProxyWrapper)
  end
end
function FGlobal_ReSet_SiegeBuildingName(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingName(actorKeyRaw, panel, actorProxyWrapper)
end
function insertPartyMemberGage(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
  if getSelfPlayer():getActorKey() ~= actorKeyRaw then
    local textName = actorProxyWrapper:getName()
    if 0 == ToClient_GetPartyType() then
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_PARTY_ACK", "textName", textName))
    else
      Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERNAMETAG_LARGEPARTY_ACK", "textName", textName))
    end
  end
end
function removePartyMemberGage(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
end
function EventActorAddDamage(actorKeyRaw, variedPoint, attackResult_IntValue, additionalDamageType, position)
  if 0 == attackResult_IntValue or 1 == attackResult_IntValue or 2 == attackResult_IntValue or 3 == attackResult_IntValue or 4 == attackResult_IntValue or 5 == attackResult_IntValue then
    ActorInsertShowTime(actorKeyRaw, hideTimeType.overHeadUI, 0)
  end
end
function EventShowProgressBar(actorKeyRaw, aHideTimeType)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  if hideTimeType.preemptiveStrike == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  elseif hideTimeType.overHeadUI == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
  elseif hideTimeType.bubbleBox == aHideTimeType then
    local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
    if nil == panel then
      return
    end
    settingBubbleBoxShow(actorKeyRaw, panel, actorProxyWrapper, true)
  elseif hideTimeType.murdererEnd == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingMurderer(actorKeyRaw, panel, actorProxyWrapper, true)
  end
end
function EventHideProgressBar(actorKeyRaw, aHideTimeType)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  if hideTimeType.preemptiveStrike == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  elseif hideTimeType.overHeadUI == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
  elseif hideTimeType.bubbleBox == aHideTimeType then
    local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
    if nil == panel then
      return
    end
    settingBubbleBoxShow(actorKeyRaw, panel, actorProxyWrapper, false)
  elseif hideTimeType.murdererEnd == aHideTimeType then
    local panel = actorProxyWrapper:get():getUIPanel()
    if nil == panel then
      return
    end
    settingMurderer(actorKeyRaw, panel, actorProxyWrapper, true)
  end
end
function update_Changed_StunGage(actorKeyRaw, curStun, maxStun)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local actorProxy = actorProxyWrapper:get()
  if false == (actorProxy:isMonster() or actorProxy:isPlayer()) then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingStun(actorKeyRaw, panel, actorProxyWrapper)
end
function EventActor_QuestUpdateInserted(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingQuestMarkForce(true, panel, actorProxyWrapper)
end
function EventActor_QuestUpdateDeleted(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingQuestMarkForce(false, panel, actorProxyWrapper)
end
function FromClient_preemptiveStrikeTimeChanged(targetActorKeyRaw)
  ActorInsertShowTime(attackerActorKey, hideTimeType.preemptiveStrike, 0)
end
function EventActor_QuestUI_UpdateData(actorKeyRaw, currentType, iconPath)
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
function EventActor_EnduranceUpdate(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingName(actorKeyRaw, panel, actorProxyWrapper)
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
end
function EventActor_HouseHoldNearestDoorChanged(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingName(actorKeyRaw, panel, actorProxyWrapper)
end
function EventActor_OnChatMessageUpdate()
  local msg
  local totalSize = getNewChatMessageCount()
  for index = 0, totalSize - 1 do
    msg = getNewChatMessage(index)
    if nil ~= msg and CppEnums.ChatType.System ~= msg.chatType and (msg.isSameChannel or CppEnums.ChatType.Client == msg.chatType) then
      local actorProxyWrapper = getActor(msg._actorKeyRaw)
      if nil ~= actorProxyWrapper then
        local panel = actorProxyWrapper:get():getBubbleBoxUIPanel()
        local message = msg:getContent()
        if nil ~= panel and "" ~= message then
          settingBubbleBox(msg._actorKeyRaw, panel, actorProxyWrapper, msg:getContent())
        end
      end
    end
  end
end
function EventSelfPlayerWaitCommentLaunch()
  if nil == getSelfPlayer():get():getWaitCommentPanel() then
    return
  end
  settingWaitCommentLaunch(true)
  getSelfPlayer():get():showWaitComment()
end
function EventSelfPlayerWaitCommentClose()
  if nil == getSelfPlayer():get():getWaitCommentPanel() then
    return
  end
  ClearFocusEdit()
  settingWaitCommentLaunch(false)
  getSelfPlayer():get():hideWaitComment()
end
function EventOtherPlayerWaitCommentUpdate(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingWaitComment(actorKeyRaw, panel, actorProxyWrapper, true)
end
function EventOtherPlayerWaitCommentClose(actorKeyRaw)
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingWaitComment(actorKeyRaw, panel, actorProxyWrapper, false)
end
function FromClient_OverHeadUIShowChanged(actorKeyRaw, panel, actorProxyWrapper, isShow)
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
function FromClient_ActorInformationChanged(actorKeyRaw, panel, actorProxyWrapper)
  if nil == panel then
    return
  end
  if nil == actorProxyWrapper then
    return
  end
  settingName(actorKeyRaw, panel, actorProxyWrapper)
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
function FromClient_ChangeArenaAreaAndZoneState(actorProxyWrapper, panel, isStateOn)
  if nil == actorProxyWrapper or nil == isStateOn or nil == panel then
    return
  end
  local actorKeyRaw = actorProxyWrapper:get():getActorKeyRaw()
  settingHpBar(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_InstallationInfoWarningNameTag(warningType, tentPosition, characterSSW, progressingInfo, actorWrapper, addtionalValue1)
  if nil == actorWrapper then
    return
  end
  local actorKeyRaw = actorWrapper:get():getActorKeyRaw()
  local panel = actorWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorWrapper)
end
function FromClient_InstallationInfo(actorWrapper)
  if nil == actorWrapper then
    return
  end
  local actorKeyRaw = actorWrapper:get():getActorKeyRaw()
  local panel = actorWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingHpBar(actorKeyRaw, panel, actorWrapper)
end
function FromClient_LocalWarCombatPoint(actorkeyRaw)
  if nil == actorkeyRaw then
    return
  end
  local playerActorWrapper = getPlayerActor(actorkeyRaw)
  if nil == playerActorWrapper then
    return
  end
  local panel = playerActorWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingLocalWarCombatPoint(actorkeyRaw, panel, playerActorWrapper)
end
function FromClient_EntryTeamChanged(actorkeyRaw)
  if nil == actorkeyRaw then
    return
  end
  local playerActorWrapper = getPlayerActor(actorkeyRaw)
  if nil == playerActorWrapper then
    return
  end
  local panel = playerActorWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingLocalWarCombatPoint(actorkeyRaw, panel, playerActorWrapper)
end
function FromClient_ObjectInstanceMpChanged(actorKeyRaw, panel)
  if nil == actorKeyRaw then
    return
  end
  local actorWrapper = getActor(actorKeyRaw)
  if nil == actorWrapper then
    return
  end
  if nil == panel then
    return
  end
  settingMpBar(actorKeyRaw, panel, actorWrapper)
end
function FromClient_FlashBangStateChanged(actorKeyRaw, isFlashBangOn)
  if nil == actorKeyRaw then
    return
  end
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
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
  settingGuildMarkAndPreemptiveStrike(actorKeyRaw, panel, actorProxyWrapper)
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  if actorProxyWrapper:get():isPlayer() then
    settingPlayerName(actorKeyRaw, panel, actorProxyWrapper)
    settingLocalWarCombatPoint(actorKeyRaw, panel, actorProxyWrapper)
  end
  settingTitle(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_ChangeMilitiaNameTag(actorKeyRaw)
  if nil == actorKeyRaw then
    return
  end
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
  settingTitle(actorKeyRaw, panel, actorProxyWrapper)
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_ChangeNationSiegeNameTag(actorKeyRaw)
  if nil == actorKeyRaw then
    return
  end
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingGuildInfo(actorKeyRaw, panel, actorProxyWrapper)
end
function FromClient_ShowOverheadRank(actorKeyRaw)
  if nil == actorKeyRaw then
    return
  end
  local actorProxyWrapper = getActor(actorKeyRaw)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  local insertedArray = Array.new()
  settingLifeRankIcon(actorKeyRaw, panel, actorProxyWrapper, insertedArray)
  isOptionChange = true
end
function FromClient_ShowTotalStatTierChanged(playerActorKey)
  local actorProxyWrapper = getActor(playerActorKey)
  if nil == actorProxyWrapper then
    return
  end
  local panel = actorProxyWrapper:get():getUIPanel()
  if nil == panel then
    return
  end
  settingStatTierIcon(playerActorKey, panel, actorProxyWrapper)
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
registerEvent("EventImportantTalk", "EventActorImportantTalk")
registerEvent("EventChangeGuildInfo", "EventActorChangeGuildInfo")
registerEvent("EventMonsterLevelColorChanged", "EventActorChangeLevel")
registerEvent("EventPlayerPvPAbleChanged", "EventActorChangeLevel")
registerEvent("hpChanged", "EventActorHpChanged")
registerEvent("EventChangeCharacterName", "EventChangeCharacterName")
registerEvent("ResponseParty_insert", "insertPartyMemberGage")
registerEvent("ResponseParty_RemovePatyNameTag", "removePartyMemberGage")
registerEvent("addDamage", "EventActorAddDamage")
registerEvent("EventShowProgressBar", "EventShowProgressBar")
registerEvent("EventHideProgressBar", "EventHideProgressBar")
registerEvent("stunChanged", "update_Changed_StunGage")
registerEvent("EventQuestTargetActorInserted", "EventActor_QuestUpdateInserted")
registerEvent("EventQuestTargetActorDeleted", "EventActor_QuestUpdateDeleted")
registerEvent("FromClient_preemptiveStrikeTimeChanged", "FromClient_preemptiveStrikeTimeChanged")
registerEvent("EventQuestUpdate", "EventActor_QuestUI_UpdateData")
registerEvent("EventHousingUpdateInstallationEndurance", "EventActor_EnduranceUpdate")
registerEvent("EventHouseHoldNearestDoorChanged", "EventActor_HouseHoldNearestDoorChanged")
registerEvent("EventChattingMessageUpdate", "EventActor_OnChatMessageUpdate")
registerEvent("EventSelfPlayerWaitCommentUpdate", "EventSelfPlayerWaitCommentLaunch")
registerEvent("EventSelfPlayerWaitCommentClose", "EventSelfPlayerWaitCommentClose")
registerEvent("EventOtherPlayerWaitCommentUpdate", "EventOtherPlayerWaitCommentUpdate")
registerEvent("EventOtherPlayerWaitCommentClose", "EventOtherPlayerWaitCommentClose")
registerEvent("FromClient_GuildMemberGradeChanged", "FromClient_GuildMemberGradeChanged")
registerEvent("EventPlayerNicknameUpdate", "EventPlayerNicknameUpdate")
registerEvent("EventSelfPlayerLevelUp", "FromClient_NameTag_SelfPlayerLevelUp")
registerEvent("FromClient_ActorInformationChanged", "FromClient_ActorInformationChanged")
registerEvent("FromClient_NotifyChangeGuildTendency", "FromClient_NotifyChangeGuildTendency")
registerEvent("FromClient_ChangeOccupyTerritoryState", "FromClient_EventActorChangeGuildInfo_HaveLand")
registerEvent("FromClient_ChangeArenaAreaRegion", "FromClient_ChangeArenaAreaAndZoneState")
registerEvent("FromClient_ChangeArenaZoneRegion", "FromClient_ChangeArenaAreaAndZoneState")
registerEvent("FromClient_InstallationInfoWarning", "FromClient_InstallationInfoWarningNameTag")
registerEvent("FromClient_InstallationInfo", "FromClient_InstallationInfo")
registerEvent("FromClient_ChangeTopRankUser", "FromClient_ChangeTopRankUser")
registerEvent("FromClient_ChangeNationSiegeNameTag", "FromClient_ChangeNationSiegeNameTag")
registerEvent("FromClient_EventActorUpdateTitleKey", "FromClient_EventActorUpdateTitleKey")
registerEvent("FromClient_LocalWarCombatPoint", "FromClient_LocalWarCombatPoint")
registerEvent("FromClient_EntryTeamChanged", "FromClient_EntryTeamChanged")
registerEvent("FromClient_FlashBangStateChanged", "FromClient_FlashBangStateChanged")
registerEvent("EventPvPModeChanged", "EventActorPvpModeChange")
registerEvent("FromClient_ObjectInstanceMpChanged", "FromClient_ObjectInstanceMpChanged")
registerEvent("FromClient_ChangeVolunteerNameTag", "FromClient_ChangeMilitiaNameTag")
registerEvent("FromClient_ShowOverheadRank", "FromClient_ShowOverheadRank")
registerEvent("FromClient_PlayerTotalStat_Changed", "FromClient_PlayerTotalStat_Changed_Handler")
registerEvent("FromClient_ShowTotalStatTierChanged", "FromClient_ShowTotalStatTierChanged")
registerEvent("FromClient_GuildTeamBattle_UpdateAttendOverHeadUI", "FromClient_ShowPlayerInfo_GuildTeamBattle")
