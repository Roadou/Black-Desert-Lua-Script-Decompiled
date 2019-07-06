local eBattleMode = CppEnums.BattleRoyaleMode
local _panel = LobbyInstance_Widget_MyInfo
local ALL_CLASS_TYPE = -1
local lobbyMyInfo = {
  eRecordType = {total = 0, best = 1},
  eFold = {on = true, off = false},
  _ui = {
    stc_Frame = UI.getChildControl(_panel, "Static_Frame"),
    btn_classIcon = {}
  },
  _classIconUV = {
    [ALL_CLASS_TYPE] = float4(400, 115, 456, 171),
    [CppEnums.ClassType.ClassType_Warrior] = float4(137, 176, 175, 214),
    [CppEnums.ClassType.ClassType_Ranger] = float4(176, 176, 214, 214),
    [CppEnums.ClassType.ClassType_Sorcerer] = float4(215, 176, 253, 214),
    [CppEnums.ClassType.ClassType_Giant] = float4(254, 176, 292, 214),
    [CppEnums.ClassType.ClassType_Tamer] = float4(293, 176, 331, 214),
    [CppEnums.ClassType.ClassType_BladeMaster] = float4(332, 176, 370, 214),
    [CppEnums.ClassType.ClassType_Valkyrie] = float4(371, 176, 409, 214),
    [CppEnums.ClassType.ClassType_BladeMasterWomen] = float4(410, 176, 448, 214),
    [CppEnums.ClassType.ClassType_Wizard] = float4(137, 215, 175, 253),
    [CppEnums.ClassType.ClassType_WizardWomen] = float4(176, 215, 214, 253),
    [CppEnums.ClassType.ClassType_NinjaWomen] = float4(215, 215, 253, 253),
    [CppEnums.ClassType.ClassType_NinjaMan] = float4(254, 215, 292, 253),
    [CppEnums.ClassType.ClassType_DarkElf] = float4(293, 215, 331, 253),
    [CppEnums.ClassType.ClassType_Combattant] = float4(332, 215, 370, 253),
    [CppEnums.ClassType.ClassType_CombattantWomen] = float4(371, 215, 409, 253),
    [CppEnums.ClassType.ClassType_Lahn] = float4(410, 215, 448, 253),
    [CppEnums.ClassType.ClassType_Orange] = float4(137, 254, 175, 292)
  },
  _max_btn_classIcon = 4,
  _baseClass = {
    [0] = ALL_CLASS_TYPE,
    CppEnums.ClassType.ClassType_Warrior,
    CppEnums.ClassType.ClassType_Ranger,
    CppEnums.ClassType.ClassType_Sorcerer,
    CppEnums.ClassType.ClassType_Lahn,
    CppEnums.ClassType.ClassType_Giant,
    CppEnums.ClassType.ClassType_Tamer,
    CppEnums.ClassType.ClassType_Combattant,
    CppEnums.ClassType.ClassType_BladeMaster,
    CppEnums.ClassType.ClassType_BladeMasterWomen,
    CppEnums.ClassType.ClassType_CombattantWomen,
    CppEnums.ClassType.ClassType_Valkyrie,
    CppEnums.ClassType.ClassType_NinjaWomen,
    CppEnums.ClassType.ClassType_NinjaMan,
    CppEnums.ClassType.ClassType_DarkElf,
    CppEnums.ClassType.ClassType_Wizard,
    CppEnums.ClassType.ClassType_Orange,
    CppEnums.ClassType.ClassType_WizardWomen,
    __eClassType_ElfRanger_Reserved1,
    __eClassType_ElfRanger_Reserved2,
    __eClassType_KunoichiOld,
    CppEnums.ClassType.ClassType_Count
  },
  _arrayClass = {
    [0] = ALL_CLASS_TYPE,
    CppEnums.ClassType.ClassType_Warrior,
    CppEnums.ClassType.ClassType_Sorcerer,
    CppEnums.ClassType.ClassType_Giant,
    CppEnums.ClassType.ClassType_Tamer,
    CppEnums.ClassType.ClassType_BladeMaster,
    CppEnums.ClassType.ClassType_BladeMasterWomen,
    CppEnums.ClassType.ClassType_CombattantWomen,
    CppEnums.ClassType.ClassType_Valkyrie,
    CppEnums.ClassType.ClassType_NinjaWomen,
    CppEnums.ClassType.ClassType_DarkElf,
    CppEnums.ClassType.ClassType_Wizard,
    CppEnums.ClassType.ClassType_WizardWomen,
    CppEnums.ClassType.ClassType_NinjaMan,
    __eClassType_ElfRanger_Reserved1,
    __eClassType_ElfRanger_Reserved2,
    __eClassType_KunoichiOld,
    CppEnums.ClassType.ClassType_Combattant
  },
  _selectClassIndex = 0,
  _minStartIndex = 0,
  _maxStartIndex = 0,
  _totalClassCount = 0,
  _selectBattleType = 0,
  _recordType = 0,
  _strWinGame = "",
  _strGetCount = "",
  _foldSizeOn = 0,
  _foldSizeOff = 0,
  _isAnimation = false,
  _preState = false,
  _spreadSpeed = 20,
  _frameOrigSizeX = 0
}
local recordWrapper = {
  rank = 0,
  lootCount = 0,
  totalHit = 0,
  totalTakenDamage = 0,
  playerKill = 0,
  monsterKill = 0,
  winGame = 0,
  totalGame = 0,
  battlePoint = 0,
  damageDone = 0,
  damageTaken = 0,
  servivalTime = 0,
  scoreValue = 0,
  bestPlayerKills = 0,
  bestMonsterKills = 0,
  bestRanking = 0,
  bestBattlePoint = 0,
  bestLootCount = 0,
  bestDamageDone = 0,
  bestDamageTaken = 0,
  bestServivalTime = 0,
  bestScore = 0
}
recordWrapper.__index = recordWrapper
function recordWrapper:set(battleType, classType)
  self:initialize()
  local nowSeason = ToClient_BattleRoyaleSeason()
  if nil == nowSeason then
    return
  end
  local wrapper = ToClient_UserBattleRoyaleRecordWrapper(battleType, classType, nowSeason)
  if nil == wrapper then
    return
  end
  self.totalGame = wrapper:getTotalGames()
  if self.totalGame <= 0 then
    return
  end
  self.rank = wrapper:getRanking()
  self.lootCount = wrapper:getLootCount()
  self.totalHit = wrapper:getDamageDone()
  self.totalTakenDamage = wrapper:getDamageTaken()
  self.playerKill = wrapper:getPlayerKills()
  self.monsterKill = wrapper:getMonsterKills()
  self.winGame = wrapper:getWinGames()
  self.battlePoint = wrapper:getBattlePoint()
  self.damageDone = wrapper:getDamageDone()
  self.damageTaken = wrapper:getDamageTaken()
  self.servivalTime = wrapper:getServivalTime()
  self.scoreValue = wrapper:getScore()
  self.bestPlayerKills = wrapper:getBestPlayerKills()
  self.bestMonsterKills = wrapper:getBestMonsterKills()
  self.bestRanking = wrapper:getBestRanking()
  self.bestBattlePoint = wrapper:getBestBattlePoint()
  self.bestLootCount = wrapper:getBestLootCount()
  self.bestDamageDone = wrapper:getBestDamageDone()
  self.bestDamageTaken = wrapper:getBestDamageTaken()
  self.bestServivalTime = wrapper:getBestServivalTime()
  self.bestScore = wrapper:getBestScore()
end
function recordWrapper:setTotalRank(battleType, arrayClass, totalClassCount)
  self:initialize()
  local recordArray = Array.new()
  for i = 1, totalClassCount do
    local record = {}
    setmetatable(record, recordWrapper)
    record:set(battleType, arrayClass[i])
    recordArray:push_back(record)
  end
  while 0 < recordArray:length() do
    self:add(recordArray:pop_back())
  end
end
function recordWrapper:add(record)
  self.totalGame = self.totalGame + record.totalGame
  self.rank = self.rank + record.rank
  self.lootCount = self.lootCount + record.lootCount
  self.totalHit = self.totalHit + record.totalHit
  self.totalTakenDamage = self.totalTakenDamage + record.totalTakenDamage
  self.playerKill = self.playerKill + record.playerKill
  self.monsterKill = self.monsterKill + record.monsterKill
  self.winGame = self.winGame + record.winGame
  self.battlePoint = self.battlePoint + record.battlePoint
  self.damageDone = self.damageDone + record.damageDone
  self.damageTaken = self.damageTaken + record.damageTaken
  self.servivalTime = self.servivalTime + record.servivalTime
  self.scoreValue = self.scoreValue + record.scoreValue
  self.bestPlayerKills = math.max(self.bestPlayerKills, record.bestPlayerKills)
  self.bestMonsterKills = math.max(self.bestMonsterKills, record.bestMonsterKills)
  if 0 ~= self.bestRanking and 0 ~= record.bestRanking then
    self.bestRanking = math.min(self.bestRanking, record.bestRanking)
  else
    self.bestRanking = math.max(self.bestRanking, record.bestRanking)
  end
  self.bestBattlePoint = math.max(self.bestBattlePoint, record.bestBattlePoint)
  if self.bestLootCount < record.bestLootCount then
    self.bestLootCount = record.bestLootCount
  end
  if self.bestDamageDone < record.bestDamageDone then
    self.bestDamageDone = record.bestDamageDone
  end
  if self.bestDamageTaken < record.bestDamageTaken then
    self.bestDamageTaken = record.bestDamageTaken
  end
  if self.bestServivalTime < record.bestServivalTime then
    self.bestServivalTime = record.bestServivalTime
  end
  if self.bestScore < record.bestScore then
    self.bestScore = record.bestScore
  end
end
function recordWrapper:initialize()
  self.rank = 0
  self.lootCount = toInt64(0, 0)
  self.totalHit = toInt64(0, 0)
  self.totalTakenDamage = toInt64(0, 0)
  self.playerKill = 0
  self.monsterKill = 0
  self.winGame = 0
  self.totalGame = 0
  self.battlePoint = 0
  self.damageDone = toInt64(0, 0)
  self.damageTaken = toInt64(0, 0)
  self.servivalTime = toInt64(0, 0)
  self.scoreValue = toInt64(0, 0)
  self.bestPlayerKills = 0
  self.bestMonsterKills = 0
  self.bestRanking = 0
  self.bestBattlePoint = 0
  self.bestLootCount = toInt64(0, 0)
  self.bestDamageDone = toInt64(0, 0)
  self.bestDamageTaken = toInt64(0, 0)
  self.bestServivalTime = toInt64(0, 0)
  self.bestScore = toInt64(0, 0)
end
function lobbyMyInfo:initialize()
  if false == ToClient_isInstanceFieldMainServer() then
    self:close()
    return
  end
  self:open()
  local _ui = self._ui
  local stc_title = UI.getChildControl(_panel, "Static_Title")
  _ui.chk_fold = UI.getChildControl(stc_title, "CheckButton_Toggle")
  _ui.stc_selectClass = UI.getChildControl(_ui.stc_Frame, "Static_SelectClass")
  _ui.stc_tapFrame = UI.getChildControl(_ui.stc_Frame, "Static_TapFrame")
  _ui.stc_classInfo = UI.getChildControl(_ui.stc_Frame, "Static_ClassInfo")
  _ui.stc_buttonGroup = UI.getChildControl(_ui.stc_Frame, "Static_ButtonGroup")
  _ui.stc_info = UI.getChildControl(_ui.stc_Frame, "Static_Info")
  local stc_selectClass = _ui.stc_selectClass
  _ui.combo_selectClass = UI.getChildControl(stc_selectClass, "Combobox_SelectClass")
  _ui.rdo_totalScore = UI.getChildControl(stc_selectClass, "RadioButton_TotalScore")
  _ui.rdo_bestScore = UI.getChildControl(stc_selectClass, "RadioButton_PersonalScore")
  local comboBoxList = UI.getChildControl(_ui.combo_selectClass, "Combobox_1_List")
  _ui.combo_selectClassItem = UI.getChildControl(comboBoxList, "Combobox_1_List_BackStatic")
  local stc_classInfo = _ui.stc_classInfo
  local stc_classIconFrame = UI.getChildControl(stc_classInfo, "Static_ClassIconFrame")
  _ui.stc_classIcon = UI.getChildControl(stc_classIconFrame, "Static_ClassIcon")
  _ui.stcText_playerName = UI.getChildControl(stc_classInfo, "StaticText_PlayerName")
  _ui.stcText_season = UI.getChildControl(stc_classInfo, "StaticText_Season")
  _ui.txt_playerClassType = UI.getChildControl(stc_classInfo, "StaticText_ClassType")
  local stc_buttonGroup = _ui.stc_buttonGroup
  _ui.rdo_soloPlay = UI.getChildControl(stc_buttonGroup, "RadioButton_SoloPlay")
  _ui.rdo_partyPlay = UI.getChildControl(stc_buttonGroup, "RadioButton_PartyPlay")
  local stc_info = _ui.stc_info
  _ui.txt_totalGame = UI.getChildControl(stc_info, "StaticText_TotalGameValue")
  _ui.txt_totalRank = UI.getChildControl(stc_info, "StaticText_TotalRankValue")
  _ui.txt_playerKill = UI.getChildControl(stc_info, "StaticText_PlayerKillValue")
  _ui.txt_monsterKill = UI.getChildControl(stc_info, "StaticText_MonsterKillValue")
  _ui.txt_battlePoint = UI.getChildControl(stc_info, "StaticText_BattlePointValue")
  _ui.txt_damageDone = UI.getChildControl(stc_info, "StaticText_DamageDoneValue")
  _ui.txt_damageTaken = UI.getChildControl(stc_info, "StaticText_DamageTakenValue")
  _ui.txt_servivalTime = UI.getChildControl(stc_info, "StaticText_ServivalTimeValue")
  _ui.txt_scoreValue = UI.getChildControl(stc_info, "StaticText_ScoreValue")
  _ui.txt_winGame = UI.getChildControl(stc_info, "StaticText_WinGameValue")
  _ui.txt_lootCount = UI.getChildControl(stc_info, "StaticText_ItemValue")
  _ui.txt_totalGameTitle = UI.getChildControl(stc_info, "StaticText_TotalGameTitle")
  _ui.txt_totalRankTitle = UI.getChildControl(stc_info, "StaticText_TotalRankTitle")
  _ui.txt_playerKillTitle = UI.getChildControl(stc_info, "StaticText_PlayerKillTitle")
  _ui.txt_monsterKillTitle = UI.getChildControl(stc_info, "StaticText_MonsterKillTitle")
  _ui.txt_battlePointTitle = UI.getChildControl(stc_info, "StaticText_BattlePointTitle")
  _ui.txt_damageDoneTitle = UI.getChildControl(stc_info, "StaticText_DamageDoneTitle")
  _ui.txt_damageTakenTitle = UI.getChildControl(stc_info, "StaticText_DamageTakenTitle")
  _ui.txt_servivalTimeTitle = UI.getChildControl(stc_info, "StaticText_ServivalTimeTitle")
  _ui.txt_scoreTitle = UI.getChildControl(stc_info, "StaticText_ScoreTitle")
  _ui.txt_winGameTitle = UI.getChildControl(stc_info, "StaticText_WinGameTitle")
  _ui.txt_lootCountTitle = UI.getChildControl(stc_info, "StaticText_ItemTitle")
  UI.setLimitTextAndAddTooltip(_ui.rdo_totalScore)
  UI.setLimitTextAndAddTooltip(_ui.rdo_bestScore)
  self._foldSizeOff = _panel:GetSizeY()
  self._foldSizeOn = stc_title:GetSizeY() + 7
  self._selectBattleType = 0
  _ui.rdo_soloPlay:SetCheck(true)
  self._recordType = self.eRecordType.total
  _ui.rdo_totalScore:SetCheck(true)
  _ui.chk_fold:SetCheck(self.eFold.off)
  _ui.chk_fold:SetEnableArea(-320, 0, 20, _ui.chk_fold:GetSizeY())
  self._totalClassCount = #self._arrayClass + 1
  self._minStartIndex = 0
  self._maxStartIndex = self._totalClassCount - self._max_btn_classIcon - 1
  self:updatePlayerInfo()
  _ui.combo_selectClass:SetSelectItemIndex(self._selectClassIndex)
  self:select(self._selectClassIndex)
  self._frameOrigSizeX = _ui.stc_Frame:GetSizeX()
  _ui.stc_Frame:SetRectClipOnArea(float2(0, 0), float2(self._frameOrigSizeX, 600))
  _ui.chk_fold:SetCheck(true)
  self:registEventHandler()
end
function lobbyMyInfo:updateTitleInfoLimit()
  UI.setLimitTextAndAddTooltip(self._ui.txt_totalGameTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_winGameTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_totalRankTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_playerKillTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_monsterKillTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_battlePointTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_damageDoneTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_damageTakenTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_servivalTimeTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_scoreTitle)
  UI.setLimitTextAndAddTooltip(self._ui.txt_lootCountTitle)
end
function lobbyMyInfo:registEventHandler()
  registerEvent("onScreenResize", "FromClient_lobbyMyInfo_ScreenResize")
  registerEvent("FromClient_BattleRoyaleUserRecords", "PaGlobalFunc_lobbyMyInfo_RefreshInfo")
  self._ui.rdo_soloPlay:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_SelectTeamInfo(" .. __eBattleRoyaleMode_Solo .. ")")
  self._ui.rdo_partyPlay:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_SelectTeamInfo(" .. __eBattleRoyaleMode_Team .. ")")
  self._ui.chk_fold:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_CheckFold()")
  self._ui.combo_selectClass:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_ComboBoxSelectClass()")
  self._ui.combo_selectClass:GetListControl():addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_SelectClass()")
  self._ui.combo_selectClass:setListTextHorizonCenter()
  self._ui.rdo_totalScore:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_SelectRecordType(" .. self.eRecordType.total .. ")")
  self._ui.rdo_bestScore:addInputEvent("Mouse_LUp", "InputMLUp_lobbyMyInfo_SelectRecordType(" .. self.eRecordType.best .. ")")
end
function lobbyMyInfo:open()
  _panel:SetShow(true)
end
function lobbyMyInfo:close()
  _panel:SetShow(false)
end
function lobbyMyInfo:update()
end
function lobbyMyInfo:resize()
  if self._isAnimation ~= self._preState then
    return
  end
  _panel:RegisterUpdateFunc("PaGlobal_lobbyMyInfo_Update")
  self._isAnimation = not self._isAnimation
end
function lobbyMyInfo:refresh()
  self:select(self._selectClassIndex)
  self:updateInfo(self._selectBattleType)
end
function lobbyMyInfo:select(selectIndex)
  if selectIndex < self._minStartIndex then
    selectIndex = self._minStartIndex
  elseif selectIndex > self._totalClassCount then
    selectIndex = self._totalClassCount
  end
  self._selectClassIndex = selectIndex
  if ALL_CLASS_TYPE == self._arrayClass[self._selectClassIndex] then
    recordWrapper:setTotalRank(self._selectBattleType, self._arrayClass, self._totalClassCount - 1)
  else
    recordWrapper:set(self._selectBattleType, self._arrayClass[self._selectClassIndex])
  end
  self:updateClassIcon(self._ui.stc_classIcon, self._arrayClass[self._selectClassIndex], false)
  self:updateInfo(self._selectBattleType)
end
function lobbyMyInfo:updatePlayerInfo()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self._ui.stcText_playerName:SetText(selfPlayer:getName())
end
function lobbyMyInfo:updateInfo()
  self:updateClassInfo()
  if self.eRecordType.total == self._recordType then
    self:updateTotalTitleText()
    self:updateTotalInfo()
  elseif self.eRecordType.best == self._recordType then
    self:updateBestTitleText()
    self:updateBestInfo()
  end
  self:updateTitleInfoLimit()
end
function lobbyMyInfo:updateClassIcon(contorl, classType, isButton)
  local iconTexture = self._classIconUV[classType]
  if nil == iconTexture then
    return
  end
  local textureString
  if ALL_CLASS_TYPE == classType then
    textureString = "renewal/ui_icon/console_classsymbol.dds"
  else
    textureString = "renewal/pcremaster/remaster_battleloyal_00.dds"
  end
  contorl:ChangeTextureInfoName(textureString)
  contorl:ChangeOnTextureInfoName(textureString)
  contorl:ChangeClickTextureInfoName(textureString)
  local x1, y1, x2, y2 = setTextureUV_Func(contorl, iconTexture.x, iconTexture.y, iconTexture.z, iconTexture.w)
  contorl:getBaseTexture():setUV(x1, y1, x2, y2)
  if true == isButton then
    contorl:getOnTexture():setUV(x1, y1, x2, y2)
    contorl:getClickTexture():setUV(x1, y1, x2, y2)
  end
  contorl:setRenderTexture(contorl:getBaseTexture())
  contorl:ComputePos()
end
function lobbyMyInfo:updateClassInfo()
  local strClassName = self:getClassComboxText(self._selectClassIndex)
  self._ui.combo_selectClass:SetText(strClassName)
  self._ui.txt_playerClassType:SetText(strClassName)
end
function lobbyMyInfo:updateTotalInfo()
  local totalGame = recordWrapper.totalGame
  self._ui.txt_totalGame:SetText(makeDotMoney(totalGame))
  if 0 >= recordWrapper.rank then
    self._ui.txt_totalRank:SetText("-")
  else
    local ranking = recordWrapper.rank
    if 0 ~= totalGame then
      ranking = (ranking + totalGame * 0.5) / totalGame
    else
      ranking = 0
    end
    self._ui.txt_totalRank:SetText(makeDotMoney(ranking))
  end
  self._ui.txt_playerKill:SetText(makeDotMoney(recordWrapper.playerKill))
  self._ui.txt_monsterKill:SetText(makeDotMoney(recordWrapper.monsterKill))
  self._ui.txt_battlePoint:SetText(makeDotMoney(recordWrapper.battlePoint))
  self._ui.txt_lootCount:SetText(makeDotMoney(recordWrapper.lootCount))
  self._ui.txt_damageDone:SetText(makeDotMoney(recordWrapper.damageDone))
  self._ui.txt_damageTaken:SetText(makeDotMoney(recordWrapper.damageTaken))
  local servivalTime = Int64toInt32(recordWrapper.servivalTime)
  local minute = 0
  local second = 0
  if 0 ~= totalGame then
    servivalTime = servivalTime / totalGame
    minute = math.floor(servivalTime / 60)
    second = math.floor(servivalTime % 60)
  else
    servivalTime = 0
  end
  local surviveTimeString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_TIME", "minute", minute, "second", second)
  self._ui.txt_servivalTime:SetText(surviveTimeString)
  self._ui.txt_scoreValue:SetText(makeDotMoney(recordWrapper.scoreValue))
  self._ui.txt_winGame:SetText(makeDotMoney(recordWrapper.winGame))
end
function lobbyMyInfo:updateTotalTitleText()
  self._ui.txt_totalGameTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_PLAYCOUNT"))
  self._ui.txt_winGameTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_WINGAME"))
  self._ui.txt_totalRankTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_RANK"))
  self._ui.txt_playerKillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_PLAYERKILL"))
  self._ui.txt_monsterKillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_MONSTERKILL"))
  self._ui.txt_battlePointTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BATTLEPOINT"))
  self._ui.txt_damageDoneTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_DAMAGE_DONE"))
  self._ui.txt_damageTakenTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_DAMAGE_TAKEN"))
  self._ui.txt_servivalTimeTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_SURVIVALTIME"))
  self._ui.txt_scoreTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_SCORE"))
  self._ui.txt_lootCountTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_LOOTCOUNT"))
end
function lobbyMyInfo:updateBestInfo()
  self._ui.txt_totalGame:SetText(makeDotMoney(recordWrapper.totalGame))
  if 0 >= recordWrapper.bestRanking then
    self._ui.txt_totalRank:SetText("-")
  else
    self._ui.txt_totalRank:SetText(makeDotMoney(recordWrapper.bestRanking))
  end
  self._ui.txt_playerKill:SetText(makeDotMoney(recordWrapper.bestPlayerKills))
  self._ui.txt_monsterKill:SetText(makeDotMoney(recordWrapper.bestMonsterKills))
  self._ui.txt_battlePoint:SetText(makeDotMoney(recordWrapper.bestBattlePoint))
  self._ui.txt_lootCount:SetText(makeDotMoney(recordWrapper.bestLootCount))
  self._ui.txt_damageDone:SetText(makeDotMoney(recordWrapper.bestDamageDone))
  self._ui.txt_damageTaken:SetText(makeDotMoney(recordWrapper.bestDamageTaken))
  local time = Int64toInt32(recordWrapper.bestServivalTime)
  local minute = math.floor(time / 60)
  local second = math.floor(time % 60)
  local surviveTimeString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_RESULT_TIME", "minute", minute, "second", second)
  self._ui.txt_servivalTime:SetText(surviveTimeString)
  self._ui.txt_scoreValue:SetText(makeDotMoney(recordWrapper.bestScore))
  self._ui.txt_winGame:SetText(makeDotMoney(recordWrapper.winGame))
end
function lobbyMyInfo:updateBestTitleText()
  self._ui.txt_totalGameTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_PLAYCOUNT"))
  self._ui.txt_winGameTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_WINGAME"))
  self._ui.txt_totalRankTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_RANK"))
  self._ui.txt_playerKillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_PLAYERKILL"))
  self._ui.txt_monsterKillTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_MONSTERKILL"))
  self._ui.txt_battlePointTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_BATTLEPOINT"))
  self._ui.txt_damageDoneTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_DAMAGE_DONE"))
  self._ui.txt_damageTakenTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_DAMAGE_TAKEN"))
  self._ui.txt_servivalTimeTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_SURVIVALTITME"))
  self._ui.txt_scoreTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_SCORE"))
  self._ui.txt_lootCountTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_BEST_ITEMCOUNT"))
end
function lobbyMyInfo:InputMLUp_ComboBoxSelectClass()
  local comboBox = self._ui.combo_selectClass
  comboBox:DeleteAllItem()
  local count = 0
  local loopCount = self._totalClassCount - 1
  for i = 0, loopCount do
    comboBox:AddItem(self:getClassComboxText(i), i)
    count = count + 1
  end
  comboBox:ToggleListbox()
end
function lobbyMyInfo:InputMLUp_SelectClass()
  local comboBox = self._ui.combo_selectClass
  local selectIndex = comboBox:GetSelectIndex()
  comboBox:SetText(self:getClassComboxText(selectIndex))
  self:select(selectIndex)
  comboBox:ToggleListbox()
end
function lobbyMyInfo:getClassComboxText(selectIndex)
  local strClassName
  if 0 == selectIndex then
    strClassName = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MYINFO_ALLCLASS")
  else
    strClassName = CppEnums.ClassType2String[self._arrayClass[selectIndex]]
  end
  return strClassName
end
function lobbyMyInfo:blockInputEvent(isIgnore)
  self._ui.stc_buttonGroup:SetIgnore(isIgnore)
  self._ui.stc_selectClass:SetIgnore(isIgnore)
  self._ui.stc_tapFrame:SetIgnore(isIgnore)
  self._ui.stc_classInfo:SetIgnore(isIgnore)
  self._ui.combo_selectClass:SetIgnore(isIgnore)
  self._ui.rdo_totalScore:SetIgnore(isIgnore)
  self._ui.rdo_bestScore:SetIgnore(isIgnore)
  self._ui.combo_selectClassItem:SetIgnore(isIgnore)
  self._ui.rdo_soloPlay:SetIgnore(isIgnore)
  self._ui.rdo_partyPlay:SetIgnore(isIgnore)
end
function FromClient_lobbyMyInfo_Init()
  local self = lobbyMyInfo
  self:initialize()
end
function FromClient_lobbyMyInfo_ScreenResize()
  local self = lobbyMyInfo
  self:resize()
end
function PaGlobalFunc_lobbyMyInfo_RefreshInfo()
  local self = lobbyMyInfo
  self:refresh()
end
function PaGlobal_lobbyMyInfo_Update(deltaTime)
  local self = lobbyMyInfo
  if self._isAnimation ~= self._preState then
    if self._ui.chk_fold:IsCheck() then
      if _panel:GetSizeY() < self._foldSizeOff then
        _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() + self._spreadSpeed)
        self._ui.stc_Frame:SetRectClipOnArea(float2(0, 0), float2(self._frameOrigSizeX, _panel:GetSizeY() - 10))
        PaGlobal_Widget_Party_PosUpdate()
        lobbyMyInfo:blockInputEvent(false)
      else
        self._preState = self._isAnimation
        self._preIndex = self._currentIndex
        _panel:ClearUpdateLuaFunc()
      end
    elseif self._foldSizeOn < _panel:GetSizeY() then
      _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() - self._spreadSpeed)
      self._ui.stc_Frame:SetRectClipOnArea(float2(0, 0), float2(self._frameOrigSizeX, _panel:GetSizeY() - 10))
      PaGlobal_Widget_Party_PosUpdate()
      lobbyMyInfo:blockInputEvent(true)
    else
      self._preState = self._isAnimation
      self._preIndex = self._currentIndex
      _panel:ClearUpdateLuaFunc()
    end
  end
end
function InputMLUp_lobbyMyInfo_SelectTeamInfo(index)
  local self = lobbyMyInfo
  self._selectBattleType = index
  self:refresh()
end
function InputMLUp_lobbyMyInfo_SelectRecordType(index)
  local self = lobbyMyInfo
  self._recordType = index
  self:updateInfo()
end
function InputMLUp_lobbyMyInfo_ComboBoxSelectClass()
  local self = lobbyMyInfo
  self:InputMLUp_ComboBoxSelectClass()
end
function InputMLUp_lobbyMyInfo_SelectClass()
  local self = lobbyMyInfo
  self:InputMLUp_SelectClass()
end
function InputMLUp_lobbyMyInfo_CheckFold()
  local self = lobbyMyInfo
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_lobbyMyInfo_Init")
