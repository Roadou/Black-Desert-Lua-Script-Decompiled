Instance_Widget_RemainTime:SetShow(false)
local PaGlobal_TimeCount = {
  _ui = {
    _leftTimeBg = UI.getChildControl(Instance_Widget_RemainTime, "StaticText_LeftTimeBg"),
    _leftCountBg = UI.getChildControl(Instance_Widget_RemainTime, "StaticText_LeftCountBg"),
    _desc = UI.getChildControl(Instance_Widget_RemainTime, "StaticText_Desc"),
    _bubbleBg = UI.getChildControl(Instance_Widget_RemainTime, "Static_ObsidianBubble"),
    _killIconTemplate = UI.getChildControl(Instance_Widget_RemainTime, "StaticText_ClassIcon_Template"),
    _KillClassIcon = {},
    _leftTime = nil,
    _leftCount = nil,
    _leftCountTitle = nil
  },
  _maxMemberCount = 50,
  _beforeCount = 50,
  _playTime = 0,
  _maxPlayerCount = 0,
  _isDead = false,
  _isEndGame = false,
  _isStartGame = false,
  _bubbleBlackSpirit = false,
  _bubbleGuideSkill = false,
  _bubblePlayerBaseCount = 10
}
PaGlobal_TimeCount._ui._leftTime = UI.getChildControl(PaGlobal_TimeCount._ui._leftTimeBg, "StaticText_LeftTimeValue")
PaGlobal_TimeCount._ui._leftCount = UI.getChildControl(PaGlobal_TimeCount._ui._leftCountBg, "StaticText_LeftCountValue")
PaGlobal_TimeCount._ui._currentCount = UI.getChildControl(PaGlobal_TimeCount._ui._leftCountBg, "StaticText_CurrentCountValue")
PaGlobal_TimeCount._ui._leftCountTitle = UI.getChildControl(PaGlobal_TimeCount._ui._leftCountBg, "StaticText_CountIcon")
PaGlobal_TimeCount._ui._bubbleText = UI.getChildControl(PaGlobal_TimeCount._ui._bubbleBg, "StaticText_StepMente")
local curTime = 0
local inGameTime = 0
local guideTime = 0
function PaGlobalFunc_RemainTime_UpdatePerFrame_InGame(deltaTime)
  local self = PaGlobal_TimeCount
  if true == self._isStartGame then
    return
  end
  inGameTime = inGameTime + deltaTime
  if true == self._bubbleBlackSpirit then
    inGameTime = 0
    curTime = curTime + deltaTime
    if curTime > 10 then
      curTime = 0
      self._bubbleBlackSpirit = false
      self:bubbleHideAni()
    end
  end
  if inGameTime > 100 then
    inGameTime = 0
    if false == self._bubbleBlackSpirit then
      self._bubbleGuideSkill = true
      self:bubbleShowAni()
      self._ui._bubbleBg:SetShow(true)
      self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYALE_WIDGET_REMAINTIME_GUIDE_AUTOSKILL_MENT"))
      self._ui._bubbleBg:SetSize(self._ui._bubbleText:GetTextSizeX() + 30, self._ui._bubbleText:GetTextSizeY() + 35)
      self._ui._bubbleText:ComputePos()
    end
  end
  if true == self._bubbleGuideSkill then
    inGameTime = 0
    guideTime = guideTime + deltaTime
    if guideTime > 10 then
      guideTime = 0
      self._bubbleGuideSkill = false
      self:bubbleHideAni()
    end
  end
end
function PaGlobal_TimeCount:bubbleShowAni()
  local aniInfo = self._ui._bubbleBg:addColorAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo2 = self._ui._bubbleBg:addColorAnimation(2, 3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo2:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo2.IsChangeChild = true
end
function PaGlobal_TimeCount:bubbleHideAni()
  local aniInfo = self._ui._bubbleBg:addColorAnimation(0, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo.IsChangeChild = true
  aniInfo:SetHideAtEnd(true)
end
function PaGlobal_TimeCount:playerCountBase_BlackSpirit_AddEffect(baseCount, curCount, gameStart)
  local stepEffectList = {
    [1] = "fUI_BattleRoyal_DarkSpirit_01A",
    [2] = "fUI_BattleRoyal_DarkSpirit_01B",
    [3] = "fUI_BattleRoyal_DarkSpirit_01C",
    [4] = "fUI_BattleRoyal_DarkSpirit_01D",
    [5] = "fUI_BattleRoyal_DarkSpirit_01E"
  }
  local changeEffect = {
    [1] = "UI_BattleRoyal_DarkSpirit_Helix_01A",
    [2] = "fUI_BattleRoyal_DarkSpirit_02A"
  }
  local changeMente = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PLAYER_COUNT_BLACKSPIRIT_MENTE_STEP_1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PLAYER_COUNT_BLACKSPIRIT_MENTE_STEP_2"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PLAYER_COUNT_BLACKSPIRIT_MENTE_STEP_3"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PLAYER_COUNT_BLACKSPIRIT_MENTE_STEP_4"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_PLAYER_COUNT_BLACKSPIRIT_MENTE_STEP_5")
  }
  self._ui._leftCountTitle:EraseAllEffect()
  self._ui._bubbleBg:SetShow(false)
  if false == gameStart then
    self._ui._leftCountTitle:AddEffect(stepEffectList[1], true, 0, 0)
  else
    self._ui._leftCountTitle:AddEffect(changeEffect[1], false, 0, 0)
    self._ui._leftCountTitle:AddEffect(changeEffect[2], false, 0, 0)
    if curCount <= baseCount * 1 then
      self._ui._leftCountTitle:AddEffect(stepEffectList[5], true, 0, 0)
      self._ui._bubbleText:SetText(changeMente[5])
    elseif curCount <= baseCount * 2 then
      self._ui._leftCountTitle:AddEffect(stepEffectList[4], true, 0, 0)
      self._ui._bubbleText:SetText(changeMente[4])
    elseif curCount <= baseCount * 3 then
      self._ui._leftCountTitle:AddEffect(stepEffectList[3], true, 0, 0)
      self._ui._bubbleText:SetText(changeMente[3])
    elseif curCount <= baseCount * 4 then
      self._ui._leftCountTitle:AddEffect(stepEffectList[2], true, 0, 0)
      self._ui._bubbleText:SetText(changeMente[2])
    else
      self._ui._leftCountTitle:AddEffect(stepEffectList[1], true, 0, 0)
      self._ui._bubbleText:SetText(changeMente[1])
    end
    if false == self._isDead then
      self:bubbleShowAni()
      self._ui._bubbleBg:SetShow(true)
      self._ui._bubbleBg:SetSize(self._ui._bubbleText:GetTextSizeX() + 30, self._ui._bubbleText:GetTextSizeY() + 35)
      self._ui._bubbleText:ComputePos()
      self._bubbleBlackSpirit = true
    end
  end
end
function FromClient_ChangeBattleRoyalePlayerCount()
  local self = PaGlobal_TimeCount
  local currentPlayerCount = ToClient_BattleRoyaleRemainPlayerCount()
  local isGameStart = 0 < Int64toInt32(ToClient_BattleRoyaleRemainTime()) and currentPlayerCount > 0
  if isGameStart then
    self._maxPlayerCount = math.max(self._maxPlayerCount, ToClient_BattleRoyaleTotalPlayerCount())
    self._ui._leftCountTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_SURVIVALMEMBER_TITLE"))
    if currentPlayerCount < self._beforeCount then
      self:playerCountBase_BlackSpirit_AddEffect(self._bubblePlayerBaseCount, currentPlayerCount, true)
      self._beforeCount = currentPlayerCount
    end
    self._ui._desc:SetShow(false)
    self._ui._currentCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MEMBERCOUNT", "count", currentPlayerCount))
    self._ui._leftCount:SetText("/ " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MEMBERCOUNT", "count", self._maxPlayerCount))
    self._ui._leftCount:SetPosX(self._ui._currentCount:GetPosX() + self._ui._currentCount:GetTextSizeX())
    PaGlobalFunc_NormalTimer_Close()
    PaGlobalFunc_EquipmentList_Open()
  else
    self._maxPlayerCount = ToClient_BattleRoyaleTotalPlayerCount()
    self._ui._leftCountTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_JOINMEMBER_TITLE"))
    self:playerCountBase_BlackSpirit_AddEffect(0, 0, false)
    self._ui._desc:SetShow(false)
    self._ui._currentCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MEMBERCOUNT", "count", self._maxPlayerCount))
    self._ui._leftCount:SetText("/ " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_MEMBERCOUNT", "count", self._maxMemberCount))
    self._ui._leftCount:SetPosX(self._ui._currentCount:GetPosX() + self._ui._currentCount:GetTextSizeX())
    if 40 == self._maxPlayerCount then
      PaGlobalFunc_NormalTimerStart(false)
    elseif self._maxPlayerCount > 40 then
      PaGlobalFunc_NormalTimerStart(true)
    end
    if PaGlobal_TimeCount._maxMemberCount == PaGlobal_TimeCount._maxPlayerCount then
      if nil == PaGlobalFunc_NormalTimerFullStart then
        return
      else
        PaGlobalFunc_NormalTimerFullStart()
      end
    end
  end
end
function PaGlobal_KillUpdate(count, classType)
  local self = PaGlobal_TimeCount
  if nil == self._ui._KillClassIcon[count] then
    self._ui._KillClassIcon[count] = UI.createAndCopyBasePropertyControl(Instance_Widget_RemainTime, "StaticText_ClassIcon_Template", Instance_Widget_RemainTime, "KillClassIcon_" .. count)
    local classSymbolInfo = CppEnums.ClassType_Symbol[classType]
    self._ui._KillClassIcon[count]:ChangeTextureInfoName(classSymbolInfo[1])
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._KillClassIcon[count], classSymbolInfo[2], classSymbolInfo[3], classSymbolInfo[4], classSymbolInfo[5])
    self._ui._KillClassIcon[count]:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._KillClassIcon[count]:setRenderTexture(self._ui._KillClassIcon[count]:getBaseTexture())
    self._ui._KillClassIcon[count]:SetPosXY(95 + self._ui._KillClassIcon[count]:GetSizeX() * (count - 1), 65)
    self._ui._KillClassIcon[count]:SetShow(true)
    self._ui._KillClassIcon[count]:EraseAllEffect()
    self._ui._KillClassIcon[count]:AddEffect("UI_SkillButton01", false, 0, 0)
  end
end
function FromClient_BattleRoyaleStateChanged_RemainTime(state)
  if 2 == state then
    self._isStartGame = true
    Instance_Widget_RemainTime:RegisterUpdateFunc("PaGlobalFunc_RemainTime_UpdatePerFrame_InGame")
  end
end
function FromClient_EventSelfPlayerDead_RemainTime()
  local self = PaGlobal_TimeCount
  self._isDead = true
  self._isStartGame = false
  self._isEndGame = true
  Instance_Widget_RemainTime:ClearUpdateLuaFunc()
end
function FromClient_BattleRoyaleWinner_RemainTime()
  local self = PaGlobal_TimeCount
  self._isDead = true
  self._isStartGame = false
  self._isEndGame = true
  Instance_Widget_RemainTime:ClearUpdateLuaFunc()
end
function FromClient_BattleRoyaleRecord_RemainTime()
  local self = PaGlobal_TimeCount
  self._isDead = true
  self._isStartGame = false
  self._isEndGame = true
  Instance_Widget_RemainTime:ClearUpdateLuaFunc()
end
function PaGlobalFunc_TimerOpen()
  local self = PaGlobal_TimeCount
  if true == ToClient_IsBattleRoyaleTrainingRoom() then
    return
  end
  self:Init()
  Instance_Widget_RemainTime:SetShow(true)
end
function PaGlobal_TimeCount:Init()
  FromClient_ChangeBattleRoyalePlayerCount()
  self._ui._beforeCount = 50
  self._isDead = false
  self._isStartGame = false
  self._isEndGame = false
  self._bubbleBlackSpirit = false
  self._bubbleGuideSkill = false
  self._ui._bubbleBg:ResetVertexAni()
  self:playerCountBase_BlackSpirit_AddEffect(0, 0, false)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_TimerOpen")
registerEvent("EventSelfPlayerDead", "FromClient_EventSelfPlayerDead_RemainTime")
registerEvent("FromClient_ChangeBattleRoyalePlayerCount", "FromClient_ChangeBattleRoyalePlayerCount")
registerEvent("FromClient_BattleRoyaleWinner", "FromClient_BattleRoyaleWinner_RemainTime")
registerEvent("FromClient_BattleRoyaleRecord", "FromClient_BattleRoyaleRecord_RemainTime")
registerEvent("FromClient_BattleRoyaleStateChanged", "FromClient_BattleRoyaleStateChanged_RemainTime")
