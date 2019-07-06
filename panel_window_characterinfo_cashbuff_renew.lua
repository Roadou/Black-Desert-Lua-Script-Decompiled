local _mainPanel = Panel_Window_CharacterInfo_Renew
local _panel = Panel_Window_CharacterInfo_CashBuff_Renew
local BUFF_TYPE = {
  PCRoom = 1,
  RussiaMonthly = 2,
  Kamasylvia = 3,
  ValuePack = 4,
  GoldValuePack = 5,
  GuildWar = 6,
  Pearl = 7,
  EXP = 8,
  Drop = 9,
  Exchange = 10,
  Merv = 11,
  GoldenBell = 12,
  SkillChange = 13,
  AwakenChange = 14,
  BlackSpiritSkill = 15,
  MemoryofArtisan = 16,
  KamasylviaForRussia = 17,
  PremiumPackForRussia = 18,
  ArshaServerBuff = 19,
  BlackSpiritEXP = 20
}
local CashBuff = {
  _ui = {
    list2 = UI.getChildControl(_panel, "List2_CashBuff"),
    txt_keyGuideX = UI.getChildControl(_panel, "StaticText_KeyGuideX"),
    txt_noBuff = UI.getChildControl(_panel, "StaticText_NoBuff")
  },
  _defaultEventExp = 1000000,
  _columnCount = 2,
  _buffTypeCount = 20,
  _saveWayPoint = nil
}
local _iconUV = {
  {
    1,
    1,
    41,
    41
  },
  {
    165,
    1,
    205,
    41
  },
  {
    83,
    1,
    123,
    41
  },
  {
    124,
    1,
    164,
    41
  },
  {
    124,
    1,
    164,
    41
  },
  {
    1,
    42,
    41,
    82
  },
  {
    42,
    42,
    82,
    82
  },
  {
    83,
    42,
    123,
    82
  },
  {
    124,
    42,
    164,
    82
  },
  {
    1,
    83,
    41,
    123
  },
  {
    42,
    83,
    82,
    123
  },
  {
    83,
    83,
    123,
    123
  },
  {
    124,
    83,
    164,
    123
  },
  {
    1,
    124,
    41,
    164
  },
  {
    42,
    124,
    82,
    164
  },
  {
    83,
    124,
    123,
    164
  },
  {
    83,
    1,
    123,
    41
  },
  {
    165,
    42,
    205,
    82
  },
  {
    1,
    165,
    41,
    205
  },
  {
    42,
    165,
    82,
    205
  }
}
local self = CashBuff
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CashBuff")
function CashBuff:init()
  self._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_CashBuff_ListContent")
  self._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self:registerEventHandler()
  self._ui.txt_keyGuideB = PaGlobalFunc_CharacterInfo_GetKeyGuideB()
  self._ui.keyGuideBtnGroup = {
    self._ui.txt_keyGuideX,
    self._ui.txt_keyGuideB
  }
end
function FromClient_luaLoadComplete_CashBuff()
  local self = CashBuff
  self:init()
  self._ui.stc_cashBuffBG = UI.getChildControl(_mainPanel, "Static_CashBuff")
  self._ui.stc_cashBuffBG:SetShow(false)
  self._ui.stc_cashBuffBG:MoveChilds(self._ui.stc_cashBuffBG:GetID(), _panel)
  deletePanel(_panel:GetID())
end
function CashBuff:registerEventHandler()
  registerEvent("FromClient_UpdateCharge", "FromClient_PackageIconUpdate")
  registerEvent("FromClient_LoadCompleteMsg", "FromClient_PackageIconUpdate")
  registerEvent("FromClient_ResponseGoldenbellItemInfo", "PaGlobalFunc_CashBuff_Update")
  registerEvent("FromClient_ResponseChangeExpAndDropPercent", "PaGlobalFunc_CashBuff_Update")
  registerEvent("FromClint_EventChangedExplorationNode", "FromClient_CashBuff_EventChangedExplorationNode")
  registerEvent("FromClint_EventUpdateExplorationNode", "FromClient_CashBuff_EventUpdateExplorationNode")
end
function PaGlobalFunc_CashBuff_Open()
  CashBuff:update()
end
function PaGlobalFunc_CashBuff_Update()
  if false == PaGlobalFunc_Window_CharacterInfo_GetShow then
    return
  end
  CashBuff:update()
end
function CashBuff:update()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local isPremiumPcRoom = temporaryWrapper:isPremiumPcRoom()
  local flags = {}
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local player = selfPlayer:get()
  local starter = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_StarterPackage)
  local premium = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local pearl = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PearlPackage)
  local customize = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_CustomizationPackage)
  local dyeingPackage = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_DyeingPackage)
  local russiaKamasilv = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_Kamasilve)
  local russiaPack3Time = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_RussiaPack3)
  local applyStarter = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_StarterPackage)
  local applyPremium = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local applyPearl = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PearlPackage)
  local applyCustomize = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_CustomizationPackage)
  local applyDyeingPackage = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_DyeingPackage)
  local applyRussiaKamasilv = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_Kamasilve)
  local applySkillReset = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillChange)
  local applyAwakenSkillReset = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
  local applyRussiaPack3 = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_RussiaPack3)
  local blackSpiritTraining = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_BlackSpritTraining)
  local pcRoomUserHomeBuff = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PcRoomUserHomeBuff)
  local premiumValueBuff = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PremiumValuePackageBuff)
  local blackSpiritSkillTraining = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_BlackSpritSkillTraining)
  local memoryOfMaestro = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_GetItemDaily)
  local applyArshaBuff = ToClient_isAbleArshaItemDropBuffRate()
  local goldenBellTime_s64 = player:getGoldenbellExpirationTime_s64()
  local curChannelData = getCurrentChannelServerData()
  local expEventShow = IsWorldServerEventTypeByWorldNo(curChannelData._worldNo, curChannelData._serverNo, 0)
  local dropEventShow = IsWorldServerEventTypeByWorldNo(curChannelData._worldNo, curChannelData._serverNo, 1)
  local nodeLv = ToClient_GetNodeLevel(self._saveWayPoint)
  local nodeExp = ToClient_GetNodeExperience_s64(self._saveWayPoint)
  flags[BUFF_TYPE.GuildWar] = self._localNodeInvestment
  flags[BUFF_TYPE.RussiaMonthly] = false
  if applyStarter then
    if starter > 0 then
      flags[BUFF_TYPE.Kamasylvia] = true
    else
      flags[BUFF_TYPE.Kamasylvia] = false
    end
  else
    flags[BUFF_TYPE.Kamasylvia] = false
  end
  if applyPremium then
    if premium > 0 then
      flags[BUFF_TYPE.ValuePack] = true
    else
      flags[BUFF_TYPE.ValuePack] = false
    end
  else
    flags[BUFF_TYPE.ValuePack] = false
  end
  flags[BUFF_TYPE.Pearl] = applyPearl
  flags[BUFF_TYPE.Exchange] = applyCustomize
  flags[BUFF_TYPE.Merv] = applyDyeingPackage
  flags[BUFF_TYPE.KamasylviaForRussia] = applyRussiaKamasilv
  flags[BUFF_TYPE.SkillChange] = applySkillReset
  flags[BUFF_TYPE.AwakenChange] = applyAwakenSkillReset
  flags[BUFF_TYPE.PremiumPackForRussia] = applyRussiaPack3
  flags[BUFF_TYPE.BlackSpiritEXP] = blackSpiritTraining
  flags[BUFF_TYPE.BlackSpiritSkill] = blackSpiritSkillTraining
  flags[BUFF_TYPE.MemoryofArtisan] = memoryOfMaestro
  flags[BUFF_TYPE.GoldenBell] = goldenBellTime_s64 >= toInt64(0, 0)
  flags[BUFF_TYPE.EXP] = expEventShow
  flags[BUFF_TYPE.Drop] = dropEventShow
  if true == isPremiumPcRoom then
    if not isGameTypeRussia() and not isGameTypeEnglish() and not isGameTypeSA() and not isGameTypeKR2() and not isGameTypeTR() then
      flags[BUFF_TYPE.PCRoom] = true
    else
      flags[BUFF_TYPE.PCRoom] = false
    end
  else
    flags[BUFF_TYPE.PCRoom] = false
  end
  flags[BUFF_TYPE.GoldValuePack] = premiumValueBuff
  flags[BUFF_TYPE.ArshaServerBuff] = applyArshaBuff
  self._buffData = {}
  self:updateBuffData()
  self._listShowBuff = {}
  local uiIndex = 1
  for k, v in pairs(flags) do
    if true == v then
      self._listShowBuff[#self._listShowBuff + 1] = k
    end
  end
  self._ui.list2:getElementManager():clearKey()
  if 1 <= #self._listShowBuff then
    for ii = 1, #self._listShowBuff do
      if 1 == ii % self._columnCount then
        self._ui.list2:getElementManager():pushKey(toInt64(0, ii))
      end
    end
    self._ui.txt_noBuff:SetShow(false)
    self._ui.txt_keyGuideX:SetShow(true)
  else
    self._ui.txt_noBuff:SetShow(true)
    self._ui.txt_keyGuideX:SetShow(false)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._ui.keyGuideBtnGroup, _panel, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function CashBuff:updateBuffData()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local player = selfPlayer:get()
  local curChannelData = getCurrentChannelServerData()
  local goldenBellTime_s64 = player:getGoldenbellExpirationTime_s64()
  local goldenBellTime = convertStringFromDatetime(goldenBellTime_s64)
  local goldenBellPercent = player:getGoldenbellPercent()
  local goldenBellPercentString = tostring(math.floor(goldenBellPercent / 10000))
  local goldenBellCharacterName = player:getGoldenbellItemOwnerCharacterName()
  local goldenBellGuildName = player:getGoldenbellItemOwnerGuildName()
  local starter = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_StarterPackage)
  local premium = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local pearl = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PearlPackage)
  local customize = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_CustomizationPackage)
  local dyeingPackage = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_DyeingPackage)
  local russiaKamasilv = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_Kamasilve)
  local skillResetTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillChange)
  local awakenSkillResetTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_UnlimitedSkillAwakening)
  local russiaPack3Time = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_RussiaPack3)
  local trainingTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_BlackSpritTraining)
  local skilltrainingTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_BlackSpritSkillTraining)
  local pcRoomHomeTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PcRoomUserHomeBuff)
  local premiumValueTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PremiumValuePackageBuff)
  local memoryOfMaestroTime = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_GetItemDaily)
  local expEventPercent = getEventExpPercentByWorldNo(curChannelData._worldNo, curChannelData._serverNo)
  local expEventPercentShow = 0
  if expEventPercent > self._defaultEventExp then
    expEventPercentShow = math.floor(expEventPercent / 10000 - 100)
  end
  local expVehiclePercent = lobby_getEventVehicleExpPercentByWorldNo(curChannelData._worldNo, curChannelData._serverNo)
  local expEventVehiclePercentShow = 0
  if expVehiclePercent > self._defaultEventExp then
    expEventVehiclePercentShow = math.floor(expVehiclePercent / 10000 - 100)
  end
  local expNodePercent = self._currentNodeLv * ToClient_getNodeIncreaseItemDropPercent() / 10000
  local name, desc, uv
  for buffType = 1, self._buffTypeCount do
    if buffType == BUFF_TYPE.PCRoom then
      if isGameTypeEnglish() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE_NA")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC_NA")
      elseif isBlackSpiritEnable then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC")
      else
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_TITLE")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PCROOM_DESC_NONEBLACKSPIRIT")
      end
      uv = _iconUV[BUFF_TYPE.PCRoom]
    elseif buffType == BUFF_TYPE.Kamasylvia then
      leftTime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TIME", "getStarterPackageTime", convertStringFromDatetime(toInt64(0, starter)))
      if isGameTypeRussia() then
        local s64_dayCycle = toInt64(0, 86400)
        local s64_day = toInt64(0, starter) / s64_dayCycle
        if s64_day < toInt64(0, 3650) then
          name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE_RUS")
          desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC_RUS")
        else
          name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE_RUS")
          desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC_RUS_FOR_INFINITY")
        end
      else
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC")
      end
      uv = _iconUV[BUFF_TYPE.Kamasylvia]
    elseif buffType == BUFF_TYPE.ValuePack then
      leftTime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_AILINBUFF_TIME", "getPremiumPackageTime", convertStringFromDatetime(toInt64(0, premium)))
      if isGameTypeJapan() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_JP")
      elseif isGameTypeRussia() then
        local s64_dayCycle = toInt64(0, 86400)
        local s64_day = toInt64(0, premium) / s64_dayCycle
        if s64_day < toInt64(0, 3650) then
          name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_RUS")
          desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_RUS")
        else
          name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_RUS")
          desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_RUS_FOR_INFINITY")
        end
      elseif isGameTypeTaiwan() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_TW")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_TW")
      elseif isGameTypeSA() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_SA")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_SA")
      elseif isGameTypeKR2() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_KR2")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_KR2")
      elseif isGameTypeTR() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_TR")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_TR")
      elseif isGameTypeTH() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_TH")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_TH")
      elseif isGameTypeID() then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE_ID")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC_ID")
      else
        name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_TITLE")
        desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EILEENBUFF_DESC")
      end
      uv = _iconUV[BUFF_TYPE.ValuePack]
    elseif buffType == BUFF_TYPE.Pearl then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PEARLBUFF_TITLE")
      leftTime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_LIGHTPEARLBUFF_TIME", "getPearlPackageTime", convertStringFromDatetime(toInt64(0, pearl)))
      desc = leftTime .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PEARLBUFF_DESC")
      uv = _iconUV[BUFF_TYPE.Pearl]
    elseif buffType == BUFF_TYPE.GuildWar and true == self._localNodeInvestment then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_TITLE")
      if expNodePercent > 0 then
        desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_DESC_WITH_BUFF", "nodeName", self._localNodeName, "percent", tostring(expNodePercent))
      else
        desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_NODELVBUFF_DESC", "nodeName", self._localNodeName)
      end
      uv = _iconUV[BUFF_TYPE.GuildWar]
    elseif buffType == BUFF_TYPE.EXP then
      local expDesc = getBattleExpTooltipText(curChannelData)
      if "" == expDesc then
        local battleExp = curChannelData:getBattleExp()
        if battleExp > CppDefine.e100Percent then
          if "" ~= expDesc then
            expDesc = expDesc .. "\n"
          end
          expDesc = expDesc .. PAGetStringParam1(Defines.StringSheet_GAME, "EVENT_SYSTEM_ADD_EXP", "percent", tostring((battleExp - CppDefine.e100Percent) / CppDefine.e1Percent))
        end
        local skillExp = curChannelData:getSkillExp()
        if skillExp > CppDefine.e100Percent then
          if "" ~= expDesc then
            expDesc = expDesc .. "\n"
          end
          expDesc = expDesc .. PAGetStringParam1(Defines.StringSheet_GAME, "EVENT_SYSTEM_ADD_SKILL_EXP", "percent", tostring((skillExp - CppDefine.e100Percent) / CppDefine.e1Percent))
        end
        local vehicleExp = curChannelData:getVehicleExp()
        if vehicleExp > CppDefine.e100Percent then
          if "" ~= expDesc then
            expDesc = expDesc .. "\n"
          end
          expDesc = expDesc .. PAGetStringParam1(Defines.StringSheet_GAME, "EVENT_SYSTEM_ADD_VEHICLE_EXP", "percent", tostring((vehicleExp - CppDefine.e100Percent) / CppDefine.e1Percent))
        end
        for lifeIndex = 0, CppEnums.LifeExperienceType.Type_Count - 1 do
          local lifeExp = curChannelData:getLifeExp(lifeIndex)
          if lifeExp > CppDefine.e100Percent then
            if "" ~= expDesc then
              expDesc = expDesc .. "\n"
            end
            expDesc = expDesc .. PAGetStringParam2(Defines.StringSheet_GAME, "EVENT_SYSTEM_ADD_LIFE_EXP", "type", CppEnums.LifeExperienceString[lifeIndex], "percent", tostring((lifeExp - CppDefine.e100Percent) / CppDefine.e1Percent))
          end
        end
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_EXPBUFF")
      if "" ~= expDesc then
        desc = "<PAColor0xFF66CC33>" .. expDesc .. "<PAOldColor>"
      else
        desc = ""
      end
      uv = _iconUV[BUFF_TYPE.EXP]
    elseif buffType == BUFF_TYPE.Drop then
      local expDesc = getBattleExpTooltipText(curChannelData)
      if "" == expDesc then
        local addRate = curChannelData:getItemDrop()
        if addRate > CppDefine.e100Percent then
          expDesc = PAGetStringParam1(Defines.StringSheet_GAME, "EVENT_SYSTEM_ADD_DROP_ITEM_RATE", "percent", tostring((addRate - CppDefine.e100Percent) / CppDefine.e1Percent))
        end
      end
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_DROPBUFF")
      if "" ~= expDesc then
        desc = "<PAColor0xFF66CC33>" .. expDesc .. "<PAOldColor>"
      else
        desc = ""
      end
      uv = _iconUV[BUFF_TYPE.Drop]
    elseif buffType == BUFF_TYPE.Exchange then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFCHARACTER_BUFF_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASH_CUSTOMIZATION_BUFFTOOLTIP_DESC", "customizationPackageTime", convertStringFromDatetime(toInt64(0, customize)))
      uv = _iconUV[BUFF_TYPE.Exchange]
    elseif buffType == BUFF_TYPE.Merv then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_DESC") .. convertStringFromDatetime(toInt64(0, dyeingPackage))
      uv = _iconUV[BUFF_TYPE.Merv]
    elseif buffType == BUFF_TYPE.KamasylviaForRussia then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_TITLE")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_YAZBUFF_DESC") .. "\n" .. convertStringFromDatetime(toInt64(0, russiaKamasilv))
      uv = _iconUV[BUFF_TYPE.KamasylviaForRussia]
    elseif buffType == BUFF_TYPE.RussiaMonthly then
    elseif buffType == BUFF_TYPE.GoldenBell then
      local curChannelData = getCurrentChannelServerData()
      local channelName = getChannelName(curChannelData._worldNo, curChannelData._serverNo)
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_GOLDENBELL_TOOLTIP_NAME")
      if nil == goldenBellGuildName or "" == goldenBellGuildName or " " == goldenBellGuildName then
        desc = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_GOLDENBELL_TOOLTIP_DESC_NOGUILD", "channelName", channelName, "name", goldenBellCharacterName, "percent", goldenBellPercentString) .. " <PAColor0xFFF26A6A>" .. goldenBellTime .. "<PAOldColor>"
      else
        desc = PAGetStringParam4(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_GOLDENBELL_TOOLTIP_DESC_GUILD", "channelName", channelName, "guildName", goldenBellGuildName, "name", goldenBellCharacterName, "percent", goldenBellPercentString) .. " <PAColor0xFFF26A6A>" .. goldenBellTime .. "<PAOldColor>"
      end
      uv = _iconUV[BUFF_TYPE.GoldenBell]
    elseif buffType == BUFF_TYPE.SkillChange then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_SKILLRESET_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_SKILLRESET_TOOLTIP_DESC", "skillResetTime", convertStringFromDatetime(toInt64(0, skillResetTime)))
      uv = _iconUV[BUFF_TYPE.SkillChange]
    elseif buffType == BUFF_TYPE.AwakenChange then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_AWAKENSKILL_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_AWAKENSKILL_TOOLTIP_DESC", "awakenSkillResetTime", convertStringFromDatetime(toInt64(0, awakenSkillResetTime)))
      uv = _iconUV[BUFF_TYPE.AwakenChange]
    elseif buffType == BUFF_TYPE.PremiumPackForRussia then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_RUSSIAPACK3_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_RUSSIAPACK3_TOOLTIP_DESC", "russiaPack3Time", convertStringFromDatetime(toInt64(0, russiaPack3Time)))
      uv = _iconUV[BUFF_TYPE.PremiumPackForRussia]
    elseif buffType == BUFF_TYPE.BlackSpiritEXP then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BLACKSPIRITTRAINING_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BLACKSPIRITTRAINING_TOOLTIP_DESC", "trainingTime", convertStringFromDatetime(toInt64(0, trainingTime)))
      uv = _iconUV[BUFF_TYPE.BlackSpiritEXP]
    elseif buffType == BUFF_TYPE.GoldValuePack then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PREMIUMVALUE_TITLE")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_PREMIUMVALUE_DESC", "time", convertStringFromDatetime(toInt64(0, premiumValueTime)))
      uv = _iconUV[BUFF_TYPE.GoldValuePack]
    elseif buffType == BUFF_TYPE.BlackSpiritSkill then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BLACKSPIRITSKILLTRAINING_TOOLTIP_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAGE_BLACKSPIRITSKILLTRAINING_TOOLTIP_DESC", "skilltrainingTime", convertStringFromDatetime(toInt64(0, skilltrainingTime)))
      uv = _iconUV[BUFF_TYPE.BlackSpiritSkill]
    elseif buffType == BUFF_TYPE.MemoryofArtisan then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_MAESTROTITLE")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_MAESTRODESC", "time", convertStringFromDatetime(toInt64(0, memoryOfMaestroTime)))
      uv = _iconUV[BUFF_TYPE.MemoryofArtisan]
    elseif buffType == BUFF_TYPE.ArshaServerBuff then
      local arshaItemDropBuffRate = ToClient_getArshaItemDropBuffRate() / 10000
      name = PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_ITEMDROPBUFF_NAME")
      desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ARSHA_ITEMDROPBUFF_DESC", "dropRate", arshaItemDropBuffRate)
      uv = _iconUV[BUFF_TYPE.ArshaServerBuff]
    end
    self._buffData[buffType] = {}
    self._buffData[buffType].name = name
    self._buffData[buffType].desc = desc
    self._buffData[buffType].uv = uv
  end
end
function PaGlobalFunc_CashBuff_ListContent(content, key)
  local self = CashBuff
  local key32 = Int64toInt32(key)
  local name = ""
  local desc = ""
  local uv
  local leftTime = 0
  for ii = 1, self._columnCount do
    local btn = UI.getChildControl(content, "Button_ListObject" .. ii)
    local dataIndex = key32 + (ii - 1)
    if dataIndex <= #self._listShowBuff then
      btn:SetShow(true)
      local buffType = self._listShowBuff[dataIndex]
      local name, desc, uv = self:getBuffNameAndDesc(buffType)
      self:setContent(btn, name, desc, uv, true)
      btn:registerPadEvent(__eConsoleUIPadEvent_Up_X, "InputPadX_CashBuff_ShowTooltip(" .. buffType .. ")")
    else
      btn:SetShow(false)
    end
  end
end
function CashBuff:getBuffNameAndDesc(buffType)
  if nil == self._buffData[buffType] then
    return
  end
  return self._buffData[buffType].name, self._buffData[buffType].desc, self._buffData[buffType].uv
end
function CashBuff:setContent(btn, buffName, buffDesc, uv, isActive)
  local stc_buffIcon = UI.getChildControl(btn, "Static_BuffIcon")
  local txt_name = UI.getChildControl(btn, "StaticText_Name")
  local txt_desc = UI.getChildControl(btn, "StaticText_Desc")
  stc_buffIcon:ChangeTextureInfoName("Combine/Icon/Combine_Icon_Buff_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(stc_buffIcon, uv[1], uv[2], uv[3], uv[4])
  stc_buffIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  stc_buffIcon:setRenderTexture(stc_buffIcon:getBaseTexture())
  txt_name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  txt_name:setLineCountByLimitAutoWrap(2)
  txt_name:SetText(buffName)
  txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  txt_desc:setLineCountByLimitAutoWrap(3)
  txt_desc:SetText(buffDesc)
  if isActive then
    txt_name:SetFontColor(Defines.Color.C_FFEEEEEE)
    txt_desc:SetFontColor(Defines.Color.C_FFEEEEEE)
  else
    txt_name:SetFontColor(Defines.Color.C_FF525B6D)
    txt_desc:SetFontColor(Defines.Color.C_FF525B6D)
  end
end
function InputPadX_CashBuff_ShowTooltip(buffType)
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.CashBuffData, self._buffData[buffType], Defines.TooltipTargetType.CashBuff)
end
function FromClient_CashBuff_EventChangedExplorationNode(wayPointKey)
  PaGlobalFunc_CashBuff_UpdateExplorationNode(wayPointKey)
end
function FromClient_CashBuff_EventUpdateExplorationNode(wayPointKey)
  if self._saveWayPoint == wayPointKey then
    PaGlobalFunc_CashBuff_UpdateExplorationNode(wayPointKey)
  end
end
function PaGlobalFunc_CashBuff_UpdateExplorationNode(wayPointKey)
  local nodeLv = ToClient_GetNodeLevel(wayPointKey)
  local nodeName = ToClient_GetNodeNameByWaypointKey(wayPointKey)
  local nodeExp = ToClient_GetNodeExperience_s64(wayPointKey)
  self._localNodeName = nodeName
  self._saveWayPoint = wayPointKey
  if nodeLv > 0 and nodeExp >= toInt64(0, 0) then
    self._localNodeInvestment = true
    self._currentNodeLv = nodeLv
  else
    self._localNodeInvestment = false
    self._currentNodeLv = 0
  end
  if true == PaGlobalFunc_Window_CharacterInfo_GetShow then
    self:update()
  end
end
