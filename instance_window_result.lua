local _panel = Instance_Window_Result
local result = {
  eOverlapType = {suviveTime = 0, rewardGold = 1},
  _ui = {
    titleBg = UI.getChildControl(_panel, "Static_TitleBg"),
    winnerBg = UI.getChildControl(_panel, "Static_WinnerBg"),
    myRankBg = UI.getChildControl(_panel, "Static_MyRankBg"),
    resultBg = UI.getChildControl(_panel, "Static_ResultBg"),
    addRewardBg = UI.getChildControl(_panel, "Static_AddRewardBg"),
    missionRewardBg = UI.getChildControl(_panel, "Static_MissionRewardBG"),
    title = nil,
    winnerName = {},
    winnerClass = {},
    winnerClassIcon = {},
    rank = nil,
    myFamilyName = nil,
    myClass = nil,
    myClassIcon = nil,
    battleRecordBg = nil,
    resultPcKillValue = nil,
    resultMonKillValue = nil,
    resultDamageValue = nil,
    resultHitValue = nil,
    surviveTimeValue = nil,
    calculate = nil,
    scoreValue = nil,
    rewardBg = nil,
    itemImage = nil,
    itemName = nil,
    whiteItemCount = nil,
    whiteCountValue = nil,
    greenItemCount = nil,
    greenCountValue = nil,
    bleItemCount = nil,
    blueCountValue = nil,
    yellowItemCount = nil,
    yellowCountValue = nil,
    rewardGoldValue = nil,
    addRewardDesc = nil,
    stc_button = nil,
    btnLeave = nil,
    btnRevive = nil,
    rewardItemName = nil,
    rewardItemSlot = nil
  },
  _winBonusScore = 1000,
  _maxPartyMemberCount = 3,
  _whiteItemPrice = 10000,
  _greenItemPrice = 30000,
  _blueItemPrice = 80000,
  _yellowItemPrice = 400000,
  myData = {
    rank = 0,
    pkCount = 0,
    mkCount = 0,
    damage = 0,
    hit = 0,
    servivalTime = 0,
    score = 0
  },
  _rewardItemKey = {
    [0] = 720251,
    720252,
    720253,
    720254,
    720255
  },
  _checkClass = {
    [__eClassType_Warrior] = 1,
    [__eClassType_Sorcerer] = 1,
    [__eClassType_Giant] = 1,
    [__eClassType_Tamer] = 1,
    [__eClassType_BladeMaster] = 1,
    [__eClassType_BladeMasterWoman] = 1,
    [__eClassType_Mystic] = 1,
    [__eClassType_Valkyrie] = 1,
    [__eClassType_Kunoichi] = 1,
    [__eClassType_DarkElf] = 1,
    [__eClassType_WizardMan] = 1,
    [__eClassType_WizardWoman] = 1,
    [__eClassType_NinjaMan] = 1,
    [__eClassType_Combattant] = 1,
    [__eClassType_Warrior_Reserve0] = 1,
    [__eClassType_Warrior_Reserve2] = 1,
    [__eClassType_Sorcerer_Reserved0] = 1,
    [__eClassType_Sorcerer_Reserved1] = 1,
    [__eClassType_Giant_Reserved0] = 1,
    [__eClassType_Giant_Reserved2] = 1,
    [__eClassType_ElfRanger_Reserved1] = 1,
    [__eClassType_ElfRanger_Reserved2] = 1,
    [__eClassType_KunoichiOld] = 1
  },
  _bgTexture = "renewal/pcremaster/remaster_battleloyal_loadingsc01.dds",
  _itemTexturePath = "renewal/pcremaster/Remaster_BattleLoyal_04.dds",
  _itemTextureUV = {
    [0] = {
      x1 = 1,
      y1 = 1,
      x2 = 151,
      y2 = 151
    },
    [1] = {
      x1 = 152,
      y1 = 1,
      x2 = 302,
      y2 = 151
    },
    [2] = {
      x1 = 303,
      y1 = 1,
      x2 = 453,
      y2 = 151
    },
    [3] = {
      x1 = 1,
      y1 = 152,
      x2 = 151,
      y2 = 302
    },
    [4] = {
      x1 = 152,
      y1 = 152,
      x2 = 302,
      y2 = 302
    }
  },
  _gameStatus = false
}
function result:init()
  _panel:RegisterShowEventFunc(true, "BattleRoyal_Result_ShowAni()")
  _panel:RegisterShowEventFunc(false, "BattleRoyal_Result_HideAni()")
  local ui = self._ui
  ui.title = UI.getChildControl(ui.titleBg, "StaticText_Title")
  ui.title:SetShow(false)
  for index = 1, self._maxPartyMemberCount do
    ui.winnerName[index] = UI.getChildControl(ui.winnerBg, "StaticText_WinnerName" .. index)
    ui.winnerClass[index] = UI.getChildControl(ui.winnerBg, "StaticText_WinnerClass" .. index)
    ui.winnerClassIcon[index] = UI.getChildControl(ui.winnerBg, "Static_ClassIcon" .. index)
  end
  ui.rank = UI.getChildControl(ui.myRankBg, "StaticText_MyRank")
  ui.myFamilyName = UI.getChildControl(ui.myRankBg, "StaticText_MyName")
  ui.myClass = UI.getChildControl(ui.myRankBg, "StaticText_MyClass")
  ui.myClassIcon = UI.getChildControl(ui.myRankBg, "Static_MyClassIcon")
  ui.battleRecordBg = UI.getChildControl(ui.resultBg, "Static_BattleRecordBg")
  ui.battleRecord = UI.getChildControl(ui.battleRecordBg, "Static_BattleRecord")
  ui.battleLine = UI.getChildControl(ui.battleRecordBg, "Static_Line")
  ui.resultPcKillValue = UI.getChildControl(ui.battleRecord, "StaticText_PcKillValue")
  ui.resultMonKillValue = UI.getChildControl(ui.battleRecord, "StaticText_MonKillCountValue")
  ui.resultDamageValue = UI.getChildControl(ui.battleRecord, "StaticText_DamageValue")
  ui.resultHitValue = UI.getChildControl(ui.battleRecord, "StaticText_HitValue")
  ui.surviveTimeValue = UI.getChildControl(ui.battleRecord, "StaticText_SurviveTimeValue")
  ui.scoreValue = UI.getChildControl(ui.battleRecord, "StaticText_ScoreValue")
  ui.rewardBg = UI.getChildControl(ui.resultBg, "Static_RewardBg")
  ui.rewardRecord = UI.getChildControl(ui.rewardBg, "Static_RewardRecord")
  ui.rewardLine = UI.getChildControl(ui.rewardBg, "Static_Line")
  ui.itemImage = UI.getChildControl(ui.rewardRecord, "Static_Item")
  ui.itemName = UI.getChildControl(ui.rewardRecord, "StaticText_ItemName")
  ui.whiteItemCount = UI.getChildControl(ui.rewardRecord, "StaticText_WhiteItemTitle")
  ui.whiteCountValue = UI.getChildControl(ui.rewardRecord, "StaticText_WhiteItemPrice")
  ui.greenItemCount = UI.getChildControl(ui.rewardRecord, "StaticText_GreenItemTitle")
  ui.greenCountValue = UI.getChildControl(ui.rewardRecord, "StaticText_GreenItemPrice")
  ui.blueItemCount = UI.getChildControl(ui.rewardRecord, "StaticText_BlueItemTitle")
  ui.blueCountValue = UI.getChildControl(ui.rewardRecord, "StaticText_BlueItemPrice")
  ui.yellowItemCount = UI.getChildControl(ui.rewardRecord, "StaticText_YellowItemTitle")
  ui.yellowCountValue = UI.getChildControl(ui.rewardRecord, "StaticText_YellowItemPrice")
  ui.rewardGoldValue = UI.getChildControl(ui.rewardRecord, "StaticText_RewardGoldValue")
  ui.addRewardDesc = UI.getChildControl(ui.rewardRecord, "StaticText_AddRewardDesc")
  ui.missionItemIcon = UI.getChildControl(ui.missionRewardBg, "Static_Slot")
  ui.missionItemValue = UI.getChildControl(ui.missionRewardBg, "StaticText_Item")
  ui.stc_emptyDesc = UI.getChildControl(ui.rewardBg, "StaticText_EmptyDesc")
  ui.stc_button = UI.getChildControl(ui.resultBg, "Static_button")
  ui.btnLeave = UI.getChildControl(ui.stc_button, "Button_Leave")
  ui.btnRevive = UI.getChildControl(ui.stc_button, "Button_Revive")
  ui.btnRejoin = UI.getChildControl(ui.stc_button, "Button_Rejoin")
  ui.rewardItemName = UI.getChildControl(ui.addRewardBg, "StaticText_ItemName")
  ui.rewardItemSlot = UI.getChildControl(ui.addRewardBg, "Static_Slot")
  ui.itemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  ui.stc_emptyDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  ui.addRewardDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  ui.rewardItemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  ui.stc_emptyDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_RESULT_EMPTY_REWARD_DESC"))
  ui.addRewardDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BATTLEROYAL_RESULT_WIN_REWARD_DESC"))
  ui.surviveTimeTitle = UI.getChildControl(ui.battleRecord, "StaticText_SurviveTime")
  ui.rewardGoldTitle = UI.getChildControl(ui.rewardRecord, "StaticText_RewardGoldTitle")
  self._ui.winnerBg:SetShow(false)
  _panel:ChangeTextureInfoName("")
  self:setWinner(1, nil, nil)
  self:setWinner(2, nil, nil)
  self:setWinner(3, nil, nil)
  ui.addRewardDesc:SetShow(false)
  self._ui.itemImage:SetShow(false)
  self:resizeEmpty()
  self:initializeEmpty()
end
function result:registEventHandler()
  registerEvent("FromClient_BattleRoyaleWinner", "FromClient_BattleRoyal_PlayEnd")
  registerEvent("FromClient_BattleRoyaleRecord", "FromClient_BattleRoyaleRecord")
  self._ui.btnRevive:addInputEvent("Mouse_LUp", "PaGlobal_Result_ObserverMode()")
  self._ui.btnLeave:addInputEvent("Mouse_LUp", "PaGlobal_Direct_Leave_Out()")
  self._ui.btnRejoin:addInputEvent("Mouse_LUp", "PaGlobal_Result_Rejoin()")
end
function result:update()
end
function result:open()
  _panel:SetShow(true, true)
end
function result:close()
  _panel:SetShow(false, false)
end
function result:allUIClose()
  if nil ~= PaGlobal_deadMessage_otherPanelShow then
    PaGlobal_deadMessage_otherPanelShow(false)
  end
end
function result:resize()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  _panel:SetSize(screenSizeX, screenSizeY)
  self._ui.resultBg:SetSize(self._ui.resultBg:GetSizeX(), screenSizeY - 90)
  self._ui.winnerBg:ComputePos()
  self._ui.myRankBg:ComputePos()
  self._ui.resultBg:ComputePos()
  self._ui.addRewardBg:ComputePos()
  self._ui.missionRewardBg:ComputePos()
  self._ui.rewardBg:SetPosY(350 * (screenSizeY - 90) / 630)
  self._ui.stc_button:ComputePos()
  self._ui.winnerBg:SetPosX(self._ui.winnerBg:GetSizeX() * -1)
  self._ui.myRankBg:SetPosX(screenSizeX)
  self._ui.battleRecordBg:SetPosX(self._ui.battleRecordBg:GetSizeX())
  self._ui.rewardBg:SetPosX(self._ui.rewardBg:GetSizeX())
  self._ui.battleRecord:SetShow(true)
  self._ui.rewardRecord:SetShow(true)
  self._ui.stc_emptyDesc:SetShow(false)
end
function result:resizeEmpty()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  _panel:SetSize(screenSizeX, screenSizeY)
  self._ui.resultBg:SetSize(self._ui.resultBg:GetSizeX(), screenSizeY - 90)
  self._ui.winnerBg:ComputePos()
  self._ui.myRankBg:ComputePos()
  self._ui.resultBg:ComputePos()
  local posY = self._ui.battleRecordBg:GetPosY() + self._ui.battleLine:GetSizeY()
  self._ui.rewardBg:SetPosY(posY)
  self._ui.stc_button:ComputePos()
end
function result:initializeEmpty()
  self._ui.battleRecord:SetShow(false)
  self._ui.rewardRecord:SetShow(false)
  self._ui.stc_emptyDesc:SetShow(true)
  local rankString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_RANK", "rank", "-")
  self._ui.rank:SetText(rankString)
  self._ui.myFamilyName:SetText(getFamilyName())
  self._ui.myClass:SetText("")
  self._ui.myClassIcon:SetShow(false)
end
function result:updateMyData()
  if nil == getSelfPlayer() then
    return
  end
  self:resize()
  local data = self.myData
  local rankString = ""
  if 1 == data.rank then
    rankString = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_FIRSTRANK")
  elseif 0 == data.rank then
    rankString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_RANK", "rank", "-")
  else
    rankString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_RANK", "rank", tostring(data.rank))
  end
  self._ui.rank:SetText(rankString)
  self._ui.myFamilyName:SetText(getFamilyName())
  local myClassType = getSelfPlayer():getClassType()
  if CppEnums.ClassType.ClassType_Temp1 == myClassType then
    self._ui.myClass:SetText("")
    self._ui.myClassIcon:SetShow(false)
  else
    self._ui.myClass:SetText(CppEnums.ClassType2String[myClassType])
    local classSymbolInfo = CppEnums.ClassType_Symbol[myClassType]
    self._ui.myClassIcon:SetShow(true)
    self._ui.myClassIcon:ChangeTextureInfoName(classSymbolInfo[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.myClassIcon, classSymbolInfo[2], classSymbolInfo[3], classSymbolInfo[4], classSymbolInfo[5])
    self._ui.myClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.myClassIcon:setRenderTexture(self._ui.myClassIcon:getBaseTexture())
  end
  self._ui.resultPcKillValue:SetText(data.pkCount)
  self._ui.resultMonKillValue:SetText(data.mkCount)
  self._ui.resultDamageValue:SetText(makeDotMoney(data.damage))
  self._ui.resultHitValue:SetText(makeDotMoney(data.hit))
  local time = Int64toInt32(data.servivalTime)
  local minute = math.floor(time / 60)
  local second = math.floor(time % 60)
  local surviveTimeString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_TIME", "minute", minute, "second", second)
  self._ui.surviveTimeValue:SetText(surviveTimeString)
  if true == self:isCheckOverlapX(self._ui.surviveTimeTitle, self._ui.surviveTimeValue) then
    self:setOverlapImageTextTooltip(self._ui.surviveTimeTitle, self.eOverlapType.suviveTime)
  end
  local timeScore = 0
  if minute > 5 then
    timeScore = minute * 20
  end
  self._ui.scoreValue:SetText(makeDotMoney(data.score))
  self._ui.scoreValue:SetPosX(self._ui.battleRecord:GetSizeX() - 40 - (self._ui.scoreValue:GetTextSizeX() + self._ui.scoreValue:GetSizeX()) - 8)
  local rewardIndex
  local rewardItemKey = __eTItemEnchantKeyUndefined
  local isRewardable = ToClient_CheckToRewardBattleRoyale()
  local modeNo = ToClient_GetBattleRoyaleModeNo()
  if __eBattleRoyaleMode_PrivateSolo == modeNo or __eBattleRoyaleMode_PrivateTeam == modeNo then
    isRewardable = false
  end
  if true == isRewardable or 1 == data.rank then
    rewardItemKey = ToClient_BattleRoyaleRankReward(__eBattleRoyaleRankReward_Normal, data.rank)
  end
  local itemSS = getItemEnchantStaticStatus(ItemEnchantKey(rewardItemKey))
  if 720255 == rewardItemKey then
    rewardIndex = 4
  elseif 720254 == rewardItemKey then
    rewardIndex = 3
  elseif 720253 == rewardItemKey then
    rewardIndex = 2
  elseif 720252 == rewardItemKey then
    rewardIndex = 1
  elseif 720251 == rewardItemKey then
    rewardIndex = 0
  end
  if nil ~= itemSS then
    self._ui.itemName:SetFontColor(ConvertFromItemGradeColor(rewardIndex))
    self._ui.itemName:SetText(itemSS:getName())
  else
    self._ui.itemName:SetFontColor(ConvertFromItemGradeColor(0))
    self._ui.itemName:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_RESULT_NOITEM"))
  end
  local normalItemCount = 0
  local magicItemCount = 0
  local rareItemCount = 0
  local uniqueItemCount = 0
  if false == ToClient_GetBattleRoyaleLeaveFlag() then
    normalItemCount = ToClient_GetDropItemCountOnBattleRoyale(__eItemGradeNormal)
    magicItemCount = ToClient_GetDropItemCountOnBattleRoyale(__eItemGradeMagic)
    rareItemCount = ToClient_GetDropItemCountOnBattleRoyale(__eItemGradeRare)
    uniqueItemCount = ToClient_GetDropItemCountOnBattleRoyale(__eItemGradeUnique)
  end
  self._ui.whiteItemCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_WHITEITEM", "price", self._whiteItemPrice, "count", normalItemCount))
  self._ui.whiteCountValue:SetText(makeDotMoney(normalItemCount * self._whiteItemPrice))
  self._ui.greenItemCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_GREENITEM", "price", self._greenItemPrice, "count", magicItemCount))
  self._ui.greenCountValue:SetText(makeDotMoney(magicItemCount * self._greenItemPrice))
  self._ui.blueItemCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_BLUEITEM", "price", self._blueItemPrice, "count", rareItemCount))
  self._ui.blueCountValue:SetText(makeDotMoney(rareItemCount * self._blueItemPrice))
  self._ui.yellowItemCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_YELLOWITEM", "price", self._yellowItemPrice, "count", uniqueItemCount))
  self._ui.yellowCountValue:SetText(makeDotMoney(uniqueItemCount * self._yellowItemPrice))
  local rewardGoldValue = normalItemCount * self._whiteItemPrice + magicItemCount * self._greenItemPrice + rareItemCount * self._blueItemPrice + uniqueItemCount * self._yellowItemPrice
  local strRewardGoldValue = makeDotMoney(rewardGoldValue)
  if 1 == data.rank then
    strRewardGoldValue = strRewardGoldValue .. " + @"
    self._ui.addRewardDesc:SetShow(true)
  end
  self._ui.rewardGoldValue:SetText(strRewardGoldValue)
  if true == self:isCheckOverlapX(self._ui.rewardGoldTitle, self._ui.rewardGoldValue) then
    self:setOverlapImageTextTooltip(self._ui.rewardGoldTitle, self.eOverlapType.rewardGold)
  end
  local applyStarter = getSelfPlayer():get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_StarterPackage)
  local missionSuccessCount = ToClient_GetClearedMissionCount()
  if missionSuccessCount > 0 then
    self._ui.missionRewardBg:SetShow(true)
    local tblMissionReward = {}
    for i = 0, missionSuccessCount - 1 do
      local missionItemMax = ToClient_GetClearedMissionItemCount(i)
      for j = 0, missionItemMax - 1 do
        local missionItemKey = ToClient_GetClearedMissionItemKeyByIndex(i, j)
        local missionItemCount = ToClient_GetClearedMissionItemCountByIndex(i, j)
        if nil == tblMissionReward[missionItemKey] then
          tblMissionReward[missionItemKey] = 0
        end
        tblMissionReward[missionItemKey] = tblMissionReward[missionItemKey] + missionItemCount
      end
    end
    for key, value in pairs(tblMissionReward) do
      local missionItemSSW = getItemEnchantStaticStatus(ItemEnchantKey(key))
      if nil ~= missionItemSSW then
        local itemGrade = missionItemSSW:getGradeType()
        self._ui.missionItemIcon:ChangeTextureInfoName("Icon/" .. missionItemSSW:getIconPath())
        self._ui.missionItemIcon:addInputEvent("Mouse_On", "PaGlobal_Result_ShowMissionItemTooltip(" .. key .. ")")
        self._ui.missionItemIcon:addInputEvent("Mouse_Out", "PaGlobal_Result_ShowMissionItemTooltip()")
        local strItemValue = missionItemSSW:getName()
        if value > 1 then
          strItemValue = strItemValue .. " x" .. tostring(value)
        end
        self._ui.missionItemValue:SetFontColor(ConvertFromItemGradeColor(itemGrade))
        self._ui.missionItemValue:SetText(strItemValue)
        break
      end
    end
  else
    self._ui.missionRewardBg:SetShow(false)
  end
  if true == applyStarter and (true == isRewardable or 1 == data.rank) then
    local kamasilvItemKey = ToClient_BattleRoyaleRankReward(__eBattleRoyaleRankReward_Boost, data.rank)
    local addItemSSW = getItemEnchantStaticStatus(ItemEnchantKey(kamasilvItemKey))
    local itemGrade = addItemSSW:getGradeType()
    self._ui.rewardItemName:SetFontColor(ConvertFromItemGradeColor(itemGrade))
    self._ui.rewardItemName:SetText(addItemSSW:getName())
    self._ui.rewardItemSlot:ChangeTextureInfoName("Icon/" .. addItemSSW:getIconPath())
    self._ui.rewardItemSlot:addInputEvent("Mouse_On", "PaGlobal_Result_ShowKamasilvItemTooltip(" .. kamasilvItemKey .. ")")
    self._ui.rewardItemSlot:addInputEvent("Mouse_Out", "PaGlobal_Result_ShowKamasilvItemTooltip()")
    self._ui.addRewardBg:SetShow(true)
    if true == self._ui.missionRewardBg:GetShow() then
      local gapY = self._ui.missionRewardBg:GetSizeY() + 10
      local spanSize = self._ui.addRewardBg:GetSpanSize()
      self._ui.addRewardBg:SetSpanSize(spanSize.x, spanSize.y + gapY)
    end
  else
    self._ui.addRewardBg:SetShow(false)
  end
  if nil == rewardIndex then
    self._ui.itemImage:SetShow(false)
  else
    self._ui.itemImage:addInputEvent("Mouse_On", "PaGlobal_Result_ShowResultItemTooltip(" .. rewardItemKey .. ")")
    self._ui.itemImage:addInputEvent("Mouse_Out", "PaGlobal_Result_ShowResultItemTooltip()")
    self._ui.itemImage:ChangeTextureInfoName(self._itemTexturePath)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.itemImage, self._itemTextureUV[rewardIndex].x1, self._itemTextureUV[rewardIndex].y1, self._itemTextureUV[rewardIndex].x2, self._itemTextureUV[rewardIndex].y2)
    self._ui.itemImage:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.itemImage:setRenderTexture(self._ui.itemImage:getBaseTexture())
    self._ui.itemImage:SetShow(true)
  end
end
function result:setWinner(index, nickName, classType)
  if nil == self._ui.winnerName[index] then
    return
  end
  local winnerName = self._ui.winnerName[index]
  local winnerClass = self._ui.winnerClass[index]
  local winnerClassIcon = self._ui.winnerClassIcon[index]
  local classSymbolInfo = CppEnums.ClassType_Symbol[classType]
  if nil == nickName or nil == self._checkClass[classType] or 1 ~= self._checkClass[classType] then
    winnerName:SetShow(false)
    winnerClass:SetShow(false)
    winnerClassIcon:SetShow(false)
    return
  end
  winnerName:SetShow(true)
  winnerClass:SetShow(true)
  winnerClassIcon:SetShow(true)
  winnerName:SetText(nickName)
  winnerClass:SetText(CppEnums.ClassType2String[classType])
  winnerClassIcon:ChangeTextureInfoName(classSymbolInfo[1])
  local x1, y1, x2, y2 = setTextureUV_Func(winnerClassIcon, classSymbolInfo[2], classSymbolInfo[3], classSymbolInfo[4], classSymbolInfo[5])
  winnerClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  winnerClassIcon:setRenderTexture(winnerClassIcon:getBaseTexture())
end
function result:showAni()
  local ui = self._ui
  local ImageMoveAni1 = ui.winnerBg:addMoveAnimation(0.3, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni1:SetStartPosition(ui.winnerBg:GetSizeX() * -1, ui.winnerBg:GetPosY())
  ImageMoveAni1:SetEndPosition(0, ui.winnerBg:GetPosY())
  ImageMoveAni1.IsChangeChild = true
  ui.winnerBg:CalcUIAniPos(ImageMoveAni1)
  ImageMoveAni1:SetDisableWhileAni(true)
  ImageMoveAni1:SetIgnoreUpdateSnapping(true)
  local ImageMoveAni2 = ui.myRankBg:addMoveAnimation(0.3, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni2:SetStartPosition(getScreenSizeX(), ui.myRankBg:GetPosY())
  ImageMoveAni2:SetEndPosition(getScreenSizeX() - ui.myRankBg:GetSizeX(), ui.myRankBg:GetPosY())
  ImageMoveAni2.IsChangeChild = true
  ui.myRankBg:CalcUIAniPos(ImageMoveAni2)
  ImageMoveAni2:SetDisableWhileAni(true)
  ImageMoveAni2:SetIgnoreUpdateSnapping(true)
  local ImageMoveAni3 = ui.battleRecordBg:addMoveAnimation(0.4, 0.6, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni3:SetStartPosition(ui.battleRecordBg:GetSizeX(), ui.battleRecordBg:GetPosY())
  ImageMoveAni3:SetEndPosition(0, ui.battleRecordBg:GetPosY())
  ImageMoveAni3.IsChangeChild = true
  ui.battleRecordBg:CalcUIAniPos(ImageMoveAni3)
  ImageMoveAni3:SetDisableWhileAni(true)
  ImageMoveAni3:SetIgnoreUpdateSnapping(true)
  local ImageMoveAni4 = ui.rewardBg:addMoveAnimation(0.6, 0.8, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  ImageMoveAni4:SetStartPosition(ui.rewardBg:GetSizeX(), ui.rewardBg:GetPosY())
  ImageMoveAni4:SetEndPosition(0, ui.rewardBg:GetPosY())
  ImageMoveAni4.IsChangeChild = true
  ui.rewardBg:CalcUIAniPos(ImageMoveAni4)
  ImageMoveAni4:SetDisableWhileAni(true)
  ImageMoveAni4:SetIgnoreUpdateSnapping(true)
end
function result:isCheckOverlapX(leftControl, rightControl)
  local leftPosX = leftControl:GetPosX() + leftControl:GetTextSpan().x + leftControl:GetTextSizeX()
  local rightPosX = rightControl:GetPosX() - rightControl:GetTextSpan().x - rightControl:GetTextSizeX()
  if leftPosX > rightPosX then
    return true
  end
  return false
end
function result:setOverlapImageTextTooltip(overlapControl, eOverlapType)
  overlapControl:SetText("")
  overlapControl:SetIgnore(false)
  overlapControl:removeInputEvent("Mouse_On")
  overlapControl:removeInputEvent("Mouse_Out")
  overlapControl:addInputEvent("Mouse_On", "InputMOn_Result_OverlapTooltip(true, " .. eOverlapType .. ")")
  overlapControl:addInputEvent("Mouse_Out", "InputMOn_Result_OverlapTooltip(false, " .. eOverlapType .. ")")
end
function result:updateOverlapTooltip(isShow, eOverlapType)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  if self.eOverlapType.suviveTime == eOverlapType then
    TooltipSimple_Show(self._ui.surviveTimeTitle, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_RESULT_LIFE_TIME"))
  elseif self.eOverlapType.rewardGold == eOverlapType then
    TooltipSimple_Show(self._ui.rewardGoldTitle, PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_RESULT_GET_MONEY"))
  end
end
function InputMOn_Result_OverlapTooltip(isShow, eOverlapType)
  local self = result
  self:updateOverlapTooltip(isShow, eOverlapType)
end
function BattleRoyal_Result_ShowAni()
  local aniInfo = _panel:addColorAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  result:showAni()
end
function BattleRoyal_Result_HideAni()
end
function FromClient_BattleRoyal_PlayEnd(rankNo, nickName1, classType1, nickName2, classType2, nickName3, classType3)
  if true == ToClient_IsBattleRoyaleTrainingRoom() then
    return
  end
  local self = result
  self:setWinner(1, nickName1, classType1)
  self:setWinner(2, nickName2, classType2)
  self:setWinner(3, nickName3, classType3)
  self._ui.winnerBg:SetShow(true, true)
  _panel:ChangeTextureInfoName(self._bgTexture)
  if 1 == rankNo then
    self:resize()
  end
  self:allUIClose()
  self._ui.title:SetShow(true)
  self._gameStatus = true
  self._ui.btnRevive:SetShow(false)
  self._ui.btnLeave:SetSize(440, 50)
  self._ui.btnLeave:SetSpanSize(0, 0)
  self._ui.btnRejoin:SetSize(self._ui.btnLeave:GetSizeX(), 50)
  self._ui.btnRejoin:SetSpanSize(0, 0)
  self._ui.stc_button:ComputePos()
  self:open()
  self._ui.title:AddEffect("fP_BattleRoyal_Victory_01A", true, 0, 85)
end
function result:buttonResize()
  if self._gameStatus then
    self._ui.btnRevive:SetShow(true)
    self._ui.btnLeave:SetSize(200, 50)
    self._ui.btnLeave:SetSpanSize(100, 0)
  else
    self._ui.btnRevive:SetShow(false)
    self._ui.btnLeave:SetSize(440, 50)
    self._ui.btnLeave:SetSpanSize(0, 0)
  end
  self._ui.stc_button:ComputePos()
end
function FromClient_BattleRoyaleRecord()
  local battleWrapper = ToClient_BattleRoyaleRecordWrapper()
  if nil == battleWrapper then
    return
  end
  if true == ToClient_IsBattleRoyaleTrainingRoom() then
    return
  end
  local self = result
  local data = self.myData
  data.rank = battleWrapper:getRanking()
  data.pkCount = battleWrapper:getPlayerKills()
  data.mkCount = battleWrapper:getMonsterKills()
  data.damage = battleWrapper:getDamageTaken()
  data.hit = battleWrapper:getDamageDone()
  data.lootCount = battleWrapper:getLootCount()
  data.servivalTime = battleWrapper:getServivalTime()
  data.score = battleWrapper:getScore()
  if not self._gameStatus then
    self._ui.btnRevive:SetShow(true)
    self._ui.btnLeave:SetSize(200, 50)
    self._ui.btnLeave:SetSpanSize(100, 0)
    self._ui.stc_button:ComputePos()
  end
  self:updateMyData()
  self:allUIClose()
  self:open()
end
function PaGlobal_Result_ShowMissionItemTooltip(itemkey)
  if nil == itemkey then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemkey))
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, result._ui.missionItemIcon, true, false)
end
function PaGlobal_Result_ShowResultItemTooltip(itemkey)
  if nil == itemkey then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemkey))
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, result._ui.itemImage, true, false)
end
function PaGlobal_Result_ShowKamasilvItemTooltip(itemkey)
  if nil == itemkey then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemkey))
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, result._ui.rewardItemSlot, true, false)
end
function PaGlobal_Result_ObserverMode()
  deadMessage_buttonPushed_ObserverMode()
  _panel:SetShow(false, false)
  if nil ~= PaGlobal_deadMessage_openPanelShow then
    PaGlobal_deadMessage_openPanelShow()
  end
end
function PaGlobal_Result_Rejoin()
  if true == _ContentsGroup_Instance_Tier then
    if nil == LobbyInstance_Window_ModeBranch then
      return
    end
    local mode = ToClient_GetBattleRoyaleModeNo()
    if nil == mode then
      return
    end
    PaGlobal_ModeBranch_Open(mode)
    FaGlobal_result_off()
  else
    ToClient_RejoinBattleRoyale(ToClient_GetBettingScoreKey(0))
  end
end
function FromClient_BattleRoyal_Init()
  local self = result
  self:init()
  self:registEventHandler()
end
function FaGlobal_result_on()
  local self = result
  self:open()
end
function FaGlobal_result_off()
  local self = result
  self:close()
end
function testresult()
  FromClient_BattleRoyal_PlayEnd(1, "\236\154\176\236\138\185\236\158\144 \236\157\180\235\166\132", 0)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_BattleRoyal_Init")
