local UI_VT = CppEnums.VehicleType
Instance_Acquire:SetShow(false, false)
Instance_Acquire:setGlassBackground(true)
Instance_Acquire:RegisterShowEventFunc(true, "Acquire_ShowAni()")
local TitleTable = {
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_1"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_2"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_3"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_5"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_6"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_7"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_8"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_9"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_10"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_11"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_12"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_13"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_14"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_15"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_16"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_17"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_18"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_19"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_20"),
  "",
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_22"),
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_30")
}
local objectMessage = {
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_1"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_2"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_3"),
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_12"),
  "",
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_16"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_17"),
  "",
  "",
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_20"),
  "",
  "",
  "",
  "",
  "",
  ""
}
local productLevelUpObejctMessage = {
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_0"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_1"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_2"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_3"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_4"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_5"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_6"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_7"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_8"),
  PAGetString(Defines.StringSheet_GAME, "ACQUIRE_OBJECTMESSAGE_PRODUCTLEVELUP_9")
}
local Acquire_UI = {
  mainPanel = Instance_Acquire,
  ArcText = UI.getChildControl(Instance_Acquire, "ArchiveText"),
  titleText = UI.getChildControl(Instance_Acquire, "TitleText"),
  iconBack = UI.getChildControl(Instance_Acquire, "IconBack"),
  iconImage = UI.getChildControl(Instance_Acquire, "IconSlot"),
  iconEtc = UI.getChildControl(Instance_Acquire, "IconEtc"),
  iconGrade = UI.getChildControl(Instance_Acquire, "IconGrade"),
  servantSkillIcon = UI.getChildControl(Instance_Acquire, "Static_SkillIcon"),
  servantSkillName = UI.getChildControl(Instance_Acquire, "StaticText_SkillName"),
  servantSkillgetHigh = UI.getChildControl(Instance_Acquire, "StaticText_SkillGetHigh")
}
local knowledge_Level = {
  UI.getChildControl(Instance_Acquire, "Static_Knowledge_Level1"),
  UI.getChildControl(Instance_Acquire, "Static_Knowledge_Level2"),
  UI.getChildControl(Instance_Acquire, "Static_Knowledge_Level3"),
  UI.getChildControl(Instance_Acquire, "Static_Knowledge_Level4"),
  UI.getChildControl(Instance_Acquire, "Static_Knowledge_Level5")
}
local Acquire_ConstValue = {animationEndTime = 3.5}
local itemGradeBorderData = {
  [0] = {
    texture = "new_ui_common_forlua/default/default_etc_00.dds",
    x1 = 103,
    y1 = 176,
    x2 = 153,
    y2 = 226
  },
  [1] = {
    texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
    x1 = 172,
    y1 = 44,
    x2 = 214,
    y2 = 86
  },
  [2] = {
    texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
    x1 = 172,
    y1 = 1,
    x2 = 214,
    y2 = 43
  },
  [3] = {
    texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
    x1 = 129,
    y1 = 1,
    x2 = 171,
    y2 = 43
  },
  [4] = {
    texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
    x1 = 129,
    y1 = 44,
    x2 = 171,
    y2 = 86
  }
}
local Acquire_Enum = {
  LevelUp = 0,
  GainProductSkillPoint = 1,
  GainCombatSkillPoint = 2,
  GainGuildSkillPoint = 3,
  LearnSkill = 4,
  SkillLearnable = 5,
  SkillAwakened = 6,
  QuestAccept = 7,
  QuestFailed = 8,
  QuestComplete = 9,
  GetRareItem = 10,
  DiscoveryExplorationNode = 11,
  UpgradeExplorationNode = 12,
  LearnMentalCard = 13,
  ServantLevelUp = 14,
  GainExplorePoint = 15,
  Detected = 16,
  AddNpcWorker = 17,
  GetAlchemy = 18,
  GetManufacture = 19,
  LearnGuildSkill = 20,
  MentalThemeComplete = 21,
  ProductLevelUp = 22,
  GetFishEncyclopedia = 23,
  UpdateFishLength = 24,
  GetFish = 25,
  AcquiredTitle = 26,
  ServantLearnSkill = 27,
  ServantSkillMaster = 28,
  PetLearnSkill = 29,
  ClearGuildSkill = 30,
  AlertInvidualShutDown = 31,
  AlertWorldShutDown = 32,
  FairyLearnSkill = 33,
  Normal = 0,
  Viliage = 1,
  City = 2,
  Gate = 3,
  Farm = 4,
  Filtration = 5,
  Collect = 6,
  Quarry = 7,
  Logging = 8,
  Deco_Tree = 9
}
local Acquire_Value = {
  elapsedTime = Acquire_ConstValue.animationEndTime
}
local isView = false
local preDefaultMsg, preArcObjectMsg, saveEventItem
local function Acquire_Initialize()
  UI.ASSERT(nil ~= Acquire_UI.mainPanel, "mainPanel\tnil")
  UI.ASSERT(nil ~= Acquire_UI.ArcText, "ArcText\t\tnil")
  UI.ASSERT(nil ~= Acquire_UI.titleText, "titleText\tnil")
  UI.ASSERT(nil ~= Acquire_UI.iconBack, "iconBack\t\tnil")
  UI.ASSERT(nil ~= Acquire_UI.iconImage, "iconImage\tnil")
  UI.ASSERT(nil ~= Acquire_UI.iconEtc, "iconEtc\t\tnil")
  UI.ASSERT(nil ~= Acquire_UI.iconGrade, "iconGrade\tnil")
  Acquire_UI.iconImage:SetSize(44, 44)
  Acquire_UI.mainPanel:SetPosX(0)
  Acquire_UI.mainPanel:SetAlpha(1)
  while nil ~= Acquire_getNextData() do
    getAcquirePopFront()
  end
  Acquire_OnResize()
end
local function Acquire_Animation()
  local alphaValue = 0
  local updateTime = Acquire_Value.elapsedTime
  local hideToShowTime = 0.7
  local showTime = 3
  local showToHideTime = Acquire_ConstValue.animationEndTime
  local ret = true
  if updateTime < hideToShowTime then
    alphaValue = updateTime / hideToShowTime
  elseif updateTime >= showToHideTime then
    alphaValue = 0
    Acquire_UI.mainPanel:SetShow(false, false)
    ret = false
  elseif updateTime > showTime then
    alphaValue = 1 - (updateTime - showTime) / (showToHideTime - showTime)
  else
    alphaValue = 1
  end
  Acquire_UI.mainPanel:SetAlphaChild(alphaValue)
  Acquire_UI.ArcText:SetFontAlpha(alphaValue)
  Acquire_UI.titleText:SetFontAlpha(alphaValue)
  Acquire_UI.servantSkillgetHigh:SetFontAlpha(alphaValue)
  return ret
end
function Acquire_getNextData()
  local notifyMsg = getAcquireFront()
  while true do
    if nil ~= notifyMsg then
      if Acquire_Enum.LevelUp == notifyMsg._msgType or Acquire_Enum.QuestAccept == notifyMsg._msgType or Acquire_Enum.QuestFailed == notifyMsg._msgType or Acquire_Enum.QuestComplete == notifyMsg._msgType then
        getAcquirePopFront()
        notifyMsg = getAcquireFront()
      elseif Acquire_Enum.LearnSkill == notifyMsg._msgType or Acquire_Enum.SkillLearnable == notifyMsg._msgType then
        do
          local skillSSW = notifyMsg:getSkillStaticstatusWrapper()
          if nil ~= skillSSW then
            local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
            local isEnable = skillTypeSSW:isValidLocalizing()
          end
          if not isEnable then
            getAcquirePopFront()
            notifyMsg = getAcquireFront()
            else
              break
            end
            do break end
            break
          end
        end
      end
  end
  return notifyMsg
end
local wpChangedPoint = 0
local function Acquire_SetData(notifyMsg)
  FGlobal_StealMSG(notifyMsg)
  local arcType = notifyMsg._msgType
  local defaultMsg = TitleTable[arcType]
  local arcIconPath = ""
  local arcObjectMsg = ""
  local arcItemGrade = 100
  local isShowChatMsg = true
  Acquire_UI.servantSkillIcon:SetShow(false)
  Acquire_UI.servantSkillName:SetShow(false)
  Acquire_UI.servantSkillgetHigh:SetShow(false)
  knowledge_Level[1]:SetShow(false)
  knowledge_Level[2]:SetShow(false)
  knowledge_Level[3]:SetShow(false)
  knowledge_Level[4]:SetShow(false)
  knowledge_Level[5]:SetShow(false)
  AcquireMessageTutorial(notifyMsg)
  if Acquire_Enum.GainProductSkillPoint == arcType or Acquire_Enum.GainCombatSkillPoint == arcType or Acquire_Enum.GainGuildSkillPoint == arcType or Acquire_Enum.LearnGuildSkill == arcType then
    arcObjectMsg = objectMessage[arcType]
  elseif Acquire_Enum.LearnSkill == arcType or Acquire_Enum.SkillLearnable == arcType then
    local skillSSW = notifyMsg:getSkillStaticstatusWrapper()
    if nil ~= skillSSW then
      local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeSSW then
        arcIconPath = skillTypeSSW:getIconPath()
        arcObjectMsg = skillTypeSSW:getName()
      end
    end
  elseif Acquire_Enum.SkillAwakened == arcType then
    local skillTypeSSW = notifyMsg:getSkillTypeStaticStatusWrapper()
    if nil ~= skillTypeSSW then
      arcIconPath = skillTypeSSW:getIconPath()
      arcObjectMsg = skillTypeSSW:getName()
    end
  elseif Acquire_Enum.QuestAccept == arcType or Acquire_Enum.QuestFailed == arcType or Acquire_Enum.QuestComplete == arcType then
    local questSSW = notifyMsg:getQuestStaticStatusWrapper()
    if nil ~= questSSW then
      arcObjectMsg = questSSW:getTitle()
    end
  elseif Acquire_Enum.GetRareItem == arcType then
    isShowChatMsg = false
    local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
    local arcItemKey = itemEnchantSSW:get()._key:getItemKey()
    saveEventItem = arcItemKey
    if nil ~= itemEnchantSSW then
      arcIconPath = itemEnchantSSW:getIconPath()
      arcObjectMsg = itemEnchantSSW:getName()
      arcItemGrade = itemEnchantSSW:getGradeType()
      local item_type = itemEnchantSSW:getItemType()
      local isTradeItem = itemEnchantSSW:isTradeAble()
      if 2 == item_type and isTradeItem then
        arcObjectMsg = string.gsub(arcObjectMsg, "\226\152\133 ", "")
      end
      if 16024 == arcItemKey then
        AcquireUpdate(Acquire_ConstValue.animationEndTime)
        return false
      end
    end
  elseif Acquire_Enum.DiscoveryExplorationNode == arcType then
    local explorationSSW = notifyMsg:getExplorationStaticStatusWrapper()
    if nil ~= explorationSSW then
      if explorationSSW:get():getRegion():isMainTown() and (Acquire_Enum.Viliage == explorationSSW:get()._nodeType or Acquire_Enum.City == explorationSSW:get()._nodeType) then
        AcquireUpdate(Acquire_ConstValue.animationEndTime)
        return false
      else
        arcObjectMsg = explorationSSW:getName()
      end
    end
  elseif Acquire_Enum.UpgradeExplorationNode == arcType then
    local explorationSSW = notifyMsg:getExplorationStaticStatusWrapper()
    if nil ~= explorationSSW then
      if Acquire_Enum.Viliage == explorationSSW:get()._nodeType or Acquire_Enum.City == explorationSSW:get()._nodeType then
        defaultMsg = objectMessage[arcType]
        arcObjectMsg = explorationSSW:getName()
      else
        arcObjectMsg = explorationSSW:getName()
      end
    end
  elseif Acquire_Enum.LearnMentalCard == arcType then
    local mentalCardSSW = notifyMsg:getMentalCardStaticStatusWrapper()
    if nil ~= mentalCardSSW then
      arcObjectMsg = mentalCardSSW:getName()
      local isMonsterKnowledge = 10000 <= mentalCardSSW:getMainThemeKeyRaw() and mentalCardSSW:getMainThemeKeyRaw() <= 10399
      local isLevelUp = notifyMsg:checkMentalCardLevelUp()
      if isMonsterKnowledge then
        if isLevelUp then
          defaultMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_MONSTER_KNOWLEDGE_LEVELUP")
        else
          defaultMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_MONSTER_KNOWLEDGE")
        end
      else
        if isLevelUp then
          defaultMsg = PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_13_LEVELUP")
        else
        end
      end
      arcIconPath = mentalCardSSW:getImagePath()
      local mentalLevel = notifyMsg:getMentalCardLevel()
      if mentalLevel > 0 then
        knowledge_Level[mentalLevel]:SetShow(true)
      end
      UIMain_KnowledgeUpdate()
    end
  elseif Acquire_Enum.ServantLevelUp == arcType then
    local servantNo = notifyMsg._Param2
    local servantWrapper = stable_getServantByServantNo(servantNo)
    if nil == servantWrapper then
      return
    end
    local vehicleType = servantWrapper:getVehicleType()
    if UI_VT.Type_Horse == vehicleType then
      Acquire_UI.servantSkillgetHigh:SetShow(true)
      Acquire_UI.servantSkillgetHigh:SetText(PAGetString(Defines.StringSheet_GAME, "ACQUIRE_SERVANTSKILLGETHIGH"))
    else
      Acquire_UI.servantSkillgetHigh:SetShow(false)
    end
    arcObjectMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_SERVANT_LVUP", "name", servantWrapper:getName(), "lv", servantWrapper:getLevel())
  elseif Acquire_Enum.GainExplorePoint == arcType then
    arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_CONTRIBUTIVENESS")
  elseif Acquire_Enum.Detected == arcType then
    arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "ACQUIRE_GETLETTER")
    local npcCharacterKey = notifyMsg:getCharacterKey()
  elseif Acquire_Enum.AddNpcWorker == arcType then
    local characterSSW = notifyMsg:getCharacterStaticStatus()
    if characterSSW ~= nil then
      arcObjectMsg = characterSSW:getName()
    end
    local regionInfo = notifyMsg:getRegionInfo()
    if regionInfo ~= nil then
      arcObjectMsg = arcObjectMsg .. "(" .. regionInfo:getAreaName() .. ")"
    end
  elseif Acquire_Enum.GetAlchemy == arcType then
    local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
    local alchemyItemKey = itemEnchantSSW:get()._key:get()
    if nil ~= itemEnchantSSW then
      arcIconPath = itemEnchantSSW:getIconPath()
      arcObjectMsg = itemEnchantSSW:getName()
      arcItemGrade = itemEnchantSSW:getGradeType()
    end
  elseif Acquire_Enum.GetManufacture == arcType then
    local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
    if nil ~= itemEnchantSSW then
      arcIconPath = itemEnchantSSW:getIconPath()
      arcObjectMsg = itemEnchantSSW:getName()
      arcItemGrade = itemEnchantSSW:getGradeType()
    end
  elseif Acquire_Enum.MentalThemeComplete == arcType then
    local mentalThemeSSW = notifyMsg:getMentalThemeStaticStatus()
    local currentMaxWp = getSelfPlayer():getMaxWp()
    if nil ~= mentalThemeSSW then
      arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_BODY", "wp", notifyMsg:getVariedWp())
      defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_MENTALTHEMECOMPLETE_HEAD", "theme", mentalThemeSSW:getName())
    end
  elseif Acquire_Enum.ProductLevelUp == arcType then
    local arcParam = Int64toInt32(notifyMsg._Param) + 1
    arcObjectMsg = productLevelUpObejctMessage[arcParam]
  elseif Acquire_Enum.GetFishEncyclopedia == arcType then
    local fishEncyclopedia = notifyMsg:getEncyclopedia()
    if nil ~= fishEncyclopedia then
      local fishName = fishEncyclopedia:getName()
      local fishLength = fishEncyclopedia:getValue()
      arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_1") .. " : " .. fishName .. "(" .. fishLength .. ")"
      defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_2", "fishName", fishName)
      arcIconPath = ""
    end
  elseif Acquire_Enum.UpdateFishLength == arcType then
    local fishEncyclopedia = notifyMsg:getEncyclopedia()
    if nil ~= fishEncyclopedia then
      local fishName = fishEncyclopedia:getName()
      local fishLength = fishEncyclopedia:getValue()
      arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_3") .. " : " .. fishName .. "(" .. fishLength .. ")"
      defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_4", "fishName", fishName)
      arcIconPath = ""
    end
  elseif Acquire_Enum.GetFish == arcType then
    local fishEncyclopedia = notifyMsg:getEncyclopedia()
    if nil ~= fishEncyclopedia then
      local fishName = fishEncyclopedia:getName()
      local fishLength = fishEncyclopedia:getValue()
      arcObjectMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_5")
      defaultMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_FISHENCYCLOPEDIA_6", "fishName", fishName, "fishLen", fishLength)
      arcIconPath = ""
    end
  elseif Acquire_Enum.AcquiredTitle == arcType then
    arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_TITLE_1", "titleName", notifyMsg:getAcquiredTitle():getName())
    defaultMsg = PAGetString(Defines.StringSheet_GAME, "LUA_ACQUIRE_MESSAGE_GET_TITLE_2")
    arcIconPath = ""
  elseif Acquire_Enum.ServantLearnSkill == arcType then
    local skillKey = Int64toInt32(notifyMsg._Param)
    local skillName = vehicleSkillStaticStatus_getName(skillKey)
    if nil ~= skillKey then
      Acquire_UI.servantSkillIcon:SetShow(true)
      Acquire_UI.servantSkillName:SetShow(true)
      Acquire_UI.servantSkillIcon:ChangeTextureInfoNameAsync("Icon/" .. vehicleSkillStaticStatus_getIconPath(skillKey))
      Acquire_UI.servantSkillName:SetText(skillName)
      Acquire_UI.servantSkillIcon:SetText(PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4"))
    end
    arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_26", "skillName", skillName)
    defaultMsg = PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4")
  elseif Acquire_Enum.ServantSkillMaster == arcType then
    local skillKey = Int64toInt32(notifyMsg._Param)
    local skillName = vehicleSkillStaticStatus_getName(skillKey)
    if nil ~= skillWrapper then
      Acquire_UI.servantSkillIcon:SetShow(true)
      Acquire_UI.servantSkillName:SetShow(true)
      Acquire_UI.servantSkillIcon:ChangeTextureInfoNameAsync("Icon/" .. vehicleSkillStaticStatus_getIconPath(skillKey))
      Acquire_UI.servantSkillName:SetText(skillName)
      Acquire_UI.servantSkillIcon:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName))
    end
    arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName)
    defaultMsg = PAGetStringParam1(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_24", "skillName", skillName)
  elseif Acquire_Enum.PetLearnSkill == arcType then
    local skillSSW = notifyMsg:getSkillStaticstatusWrapper()
    local petNo = Uint64toInt64(notifyMsg._Param2)
    local skillName, petName
    if nil ~= skillSSW then
      local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeSSW then
        arcIconPath = skillTypeSSW:getIconPath()
        skillName = skillTypeSSW:getName()
      end
    end
    local petCountUnseal = ToClient_getPetUnsealedList()
    for index = 0, petCountUnseal - 1 do
      local PcPetData = ToClient_getPetUnsealedDataByIndex(index)
      if nil == PcPetData then
        return
      end
      if petNo == PcPetData:getPcPetNo() then
        petName = PcPetData:getName()
      end
    end
    local petCountSeal = ToClient_getPetSealedList()
    for index = 0, petCountSeal - 1 do
      local PcPetData = ToClient_getPetSealedDataByIndex(index)
      if nil == PcPetData then
        return
      end
      if petNo == PcPetData._petNo then
        petName = PcPetData:getName()
      end
    end
    if nil ~= skillTypeSSW then
      Acquire_UI.servantSkillIcon:SetShow(true)
      Acquire_UI.servantSkillName:SetShow(true)
      Acquire_UI.servantSkillIcon:ChangeTextureInfoNameAsync("Icon/" .. arcIconPath)
      Acquire_UI.servantSkillName:SetText(skillName)
      Acquire_UI.servantSkillIcon:SetText(PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4"))
    end
    arcObjectMsg = PAGetStringParam2(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_27", "name", petName, "skillname", skillName)
    defaultMsg = PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4")
  elseif Acquire_Enum.AlertInvidualShutDown == arcType then
    arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INVIDUAL_SHUTDOWN_COUNTDOWN_MSG", "time", Int64toInt32(notifyMsg._Param))
    defaultMsg = ""
    arcIconPath = ""
  elseif Acquire_Enum.AlertWorldShutDown == arcType then
    arcObjectMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_SHUTDOWN_COUNTDOWN_MSG", "time", Int64toInt32(notifyMsg._Param))
    defaultMsg = ""
    arcIconPath = ""
  elseif Acquire_Enum.FairyLearnSkill == arcType then
    local skillSSW = notifyMsg:getSkillStaticstatusWrapper()
    local petNo = Uint64toInt64(notifyMsg._Param2)
    local skillName, petName
    if nil ~= skillSSW then
      local skillTypeSSW = skillSSW:getSkillTypeStaticStatusWrapper()
      if nil ~= skillTypeSSW then
        arcIconPath = skillTypeSSW:getIconPath()
        skillName = skillTypeSSW:getName()
      end
    else
      _PA_LOG("\236\167\128\235\175\188\237\152\129", "skillSSW = nullptr \236\158\133\235\139\136\235\139\164.")
    end
    local petCountUnseal = ToClient_getFairyUnsealedList()
    for index = 0, petCountUnseal - 1 do
      local PcPetData = ToClient_getFairyUnsealedDataByIndex(index)
      if nil == PcPetData then
        return
      end
      if petNo == PcPetData:getPcPetNo() then
        petName = PcPetData:getName()
      end
    end
    local petCountSeal = ToClient_getFairySealedList()
    for index = 0, petCountSeal - 1 do
      local PcPetData = ToClient_getFairySealedDataByIndex(index)
      if nil == PcPetData then
        return
      end
      if petNo == PcPetData._petNo then
        petName = PcPetData:getName()
      end
    end
    if nil ~= skillTypeSSW then
      Acquire_UI.servantSkillIcon:SetShow(true)
      Acquire_UI.servantSkillName:SetShow(true)
      Acquire_UI.servantSkillIcon:ChangeTextureInfoNameAsync("Icon/" .. arcIconPath)
      Acquire_UI.servantSkillName:SetText(skillName)
      Acquire_UI.servantSkillIcon:SetText(PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4"))
    end
    arcObjectMsg = PAGetStringParam2(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_27", "name", petName, "skillname", skillName)
    defaultMsg = PAGetString(Defines.StringSheet_GAME, "ACQUIRE_TITLEMESSAGE_4")
  end
  Acquire_UI.titleText:SetText(defaultMsg)
  Acquire_UI.ArcText:SetText(tostring(arcObjectMsg))
  if Acquire_Enum.LearnMentalCard == arcType then
    local mentalCardSSW = notifyMsg:getMentalCardStaticStatusWrapper()
    if nil ~= mentalCardSSW then
      local mentalLevel = notifyMsg:getMentalCardLevel()
      if mentalLevel > 0 then
        local spanSizeX = Acquire_UI.ArcText:GetTextSizeX() / 2 + knowledge_Level[mentalLevel]:GetSizeX()
        local spanSizeY = Acquire_UI.ArcText:GetSpanSize().y
        knowledge_Level[mentalLevel]:SetSpanSize(spanSizeX, spanSizeY)
      end
    end
  end
  if "" ~= arcIconPath and Acquire_Enum.LearnMentalCard == arcType then
    Acquire_UI.iconEtc:SetShow(false)
    Acquire_UI.iconBack:SetShow(false)
    Acquire_UI.iconImage:SetShow(true)
    Acquire_UI.iconImage:SetSize(100, 100)
    Acquire_UI.iconImage:SetVerticalTop()
    Acquire_UI.iconImage:SetHorizonCenter()
    Acquire_UI.iconImage:SetSpanSize(0, -65)
    Acquire_UI.iconGrade:SetShow(false)
    Acquire_UI.iconImage:ChangeTextureInfoNameAsync(arcIconPath)
  elseif "" ~= arcIconPath then
    Acquire_UI.iconEtc:SetShow(false)
    Acquire_UI.iconBack:SetShow(true)
    Acquire_UI.iconImage:SetShow(true)
    Acquire_UI.iconGrade:SetShow(true)
    Acquire_UI.iconImage:SetSize(42, 42)
    Acquire_UI.iconImage:SetVerticalTop()
    Acquire_UI.iconImage:SetHorizonCenter()
    Acquire_UI.iconImage:SetSpanSize(0, -17)
    Acquire_UI.iconImage:ChangeTextureInfoNameAsync("icon/" .. arcIconPath)
    if arcItemGrade >= 0 and arcItemGrade <= 4 then
      Acquire_UI.iconGrade:ChangeTextureInfoNameAsync(itemGradeBorderData[arcItemGrade].texture)
      local x1, y1, x2, y2 = setTextureUV_Func(Acquire_UI.iconGrade, itemGradeBorderData[arcItemGrade].x1, itemGradeBorderData[arcItemGrade].y1, itemGradeBorderData[arcItemGrade].x2, itemGradeBorderData[arcItemGrade].y2)
      Acquire_UI.iconGrade:getBaseTexture():setUV(x1, y1, x2, y2)
      Acquire_UI.iconGrade:setRenderTexture(Acquire_UI.iconGrade:getBaseTexture())
    else
      Acquire_UI.iconGrade:ReleaseTexture()
      Acquire_UI.iconGrade:ChangeTextureInfoNameAsync("")
    end
  else
    Acquire_UI.mainPanel:SetShow(false, false)
    Acquire_UI.iconEtc:SetShow(true)
    Acquire_UI.iconBack:SetShow(false)
    Acquire_UI.iconImage:SetShow(false)
    Acquire_UI.iconGrade:SetShow(false)
  end
  local aniIsPlaying = Acquire_Animation()
  if not aniIsPlaying then
    Acquire_UI.mainPanel:SetShow(true, true)
    Acquire_Value.elapsedTime = 0
  end
  if isShowChatMsg and (preDefaultMsg ~= defaultMsg or preArcObjectMsg ~= arcObjectMsg) then
    chatting_sendMessage("", defaultMsg, CppEnums.ChatType.System)
    if nil ~= arcObjectMsg and "" ~= arcObjectMsg and Acquire_Enum.LearnMentalCard ~= arcType then
      chatting_sendMessage("", "[ " .. tostring(arcObjectMsg) .. " ]", CppEnums.ChatType.System)
    end
  end
  preDefaultMsg = defaultMsg
  preArcObjectMsg = arcObjectMsg
  return true
end
function Acquire_ShowAni()
end
function Acquire_ProcessMessage()
  if not Instance_Acquire:GetShow() then
    local notifyMsg = Acquire_getNextData()
    if nil ~= notifyMsg then
      if Acquire_Enum.LearnSkill ~= notifyMsg._msgType then
        return
      end
      if Instance_RewardSelect_NakMessage:GetShow() then
        Instance_RewardSelect_NakMessage:SetShow(false)
      end
      Acquire_SetData(notifyMsg)
      local arcType = notifyMsg._msgType
      if arcType == Acquire_Enum.GainExplorePoint then
        audioPostEvent_SystemUi(3, 17)
        _AudioPostEvent_SystemUiForXBOX(3, 17)
      else
        local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
        if nil ~= itemEnchantSSW then
          local arcItemKey = itemEnchantSSW:get()._key:getItemKey()
          if 16024 ~= arcItemKey then
            notifyMsg:playingAudio()
          end
        else
          notifyMsg:playingAudio()
        end
      end
      getAcquirePopFront()
    end
    if nil == notifyMsg and 0 ~= FGlobal_NakMessagePanel_CheckLeftMessageCount() then
      Instance_RewardSelect_NakMessage:SetShow(true, false)
    end
  end
end
_tutorialQuestNo = 0
function getTutorialQuestNo()
  return _tutorialQuestNo
end
function setTutorialQuestNo(questNo)
  _tutorialQuestNo = questNo
end
function AcquireMessageTutorial(notifyMsg)
  if notifyMsg._msgType == Acquire_Enum.QuestAccept then
    local questSSW = notifyMsg:getQuestStaticStatusWrapper()
    local questNum
    if questSSW:getQuestGroup() == 9005 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 90051
    elseif questSSW:getQuestGroup() == 101 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1011
    elseif questSSW:getQuestGroup() == 102 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1021
    elseif questSSW:getQuestGroup() == 103 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1031
    elseif questSSW:getQuestGroup() == 103 and questSSW:getQuestGroupInNo() == 2 then
      questNum = 1032
    elseif questSSW:getQuestGroup() == 103 and questSSW:getQuestGroupInNo() == 3 then
      questNum = 1033
    elseif questSSW:getQuestGroup() == 103 and questSSW:getQuestGroupInNo() == 4 then
      questNum = 1034
    elseif questSSW:getQuestGroup() == 104 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1041
    elseif questSSW:getQuestGroup() == 105 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1051
    elseif questSSW:getQuestGroup() == 114 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1141
    elseif questSSW:getQuestGroup() == 115 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1151
    elseif questSSW:getQuestGroup() == 116 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1161
    elseif questSSW:getQuestGroup() == 117 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1171
    elseif questSSW:getQuestGroup() == 9006 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 90061
    elseif questSSW:getQuestGroup() == 152 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1521
    end
    if nil ~= questNum then
      if -1 == _tutorialQuestNo then
        Tutorial_Quest(questNum)
        setTutorialQuestNo(0)
      else
        setTutorialQuestNo(questNum)
      end
    end
  end
  if notifyMsg._msgType == Acquire_Enum.QuestComplete then
    local questSSW = notifyMsg:getQuestStaticStatusWrapper()
    local questNum
    if questSSW:getQuestGroup() == 152 and questSSW:getQuestGroupInNo() == 1 then
      questNum = 1521
    end
    if nil ~= questNum then
      if -1 == _tutorialQuestNo then
        Tutorial_Quest(questNum)
        setTutorialQuestNo(0)
      else
        setTutorialQuestNo(questNum)
      end
    end
  end
end
function AcquireUpdate(updateTime)
  Acquire_Value.elapsedTime = Acquire_Value.elapsedTime + updateTime
  local aniIsPlaying = Acquire_Animation()
  if not aniIsPlaying then
    local notifyMsg = Acquire_getNextData()
    getAcquirePopFront()
    if nil ~= notifyMsg then
      if Acquire_Enum.LearnSkill ~= notifyMsg._msgType then
        return
      end
      Acquire_SetData(notifyMsg)
      local itemEnchantSSW = notifyMsg:getItemEnchantStaticStatusWrapper()
      if nil ~= itemEnchantSSW then
        local arcItemKey = itemEnchantSSW:get()._key:getItemKey()
        if 16024 ~= arcItemKey then
          notifyMsg:playingAudio()
        end
      else
        notifyMsg:playingAudio()
      end
    end
    if nil == notifyMsg and 0 ~= FGlobal_NakMessagePanel_CheckLeftMessageCount() then
      Instance_RewardSelect_NakMessage:SetShow(true, false)
    end
  end
end
function Acquire_OnResize()
  Acquire_UI.mainPanel:SetSize(getScreenSizeX(), 100)
  for _, control in pairs(Acquire_UI) do
    control:ComputePos()
  end
  for _, control in pairs(knowledge_Level) do
    control:ComputePos()
  end
end
Acquire_Initialize()
Instance_Acquire:RegisterUpdateFunc("AcquireUpdate")
registerEvent("SelfPlayer_AcquireMessage", "Acquire_ProcessMessage")
registerEvent("onScreenResize", "Acquire_OnResize")
