local _panel = Panel_Widget_ChallengeAlert
local challengeAlert = {
  _ui = {
    bg = UI.getChildControl(_panel, "Static_AlertMessageBg"),
    title = UI.getChildControl(_panel, "StaticText_Message"),
    desc = UI.getChildControl(_panel, "StaticText_Desc"),
    progressBg = UI.getChildControl(_panel, "Static_ProgressBg"),
    progress = UI.getChildControl(_panel, "Progress2_Challenge"),
    state = UI.getChildControl(_panel, "StaticText_ProgressState"),
    _stc_icon = UI.getChildControl(_panel, "Static_Icon")
  },
  _currentCount = 0,
  _maxCount = 0,
  _time = 0,
  _currentQuestGroupNo = nil,
  _progressQuestInfo = {}
}
function challengeAlert:update(titleStr, descStr, questGroupNo, questNo, isComplete)
  self._ui.title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.title:SetText(titleStr)
  self._ui.desc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.desc:SetText(descStr)
  if nil == questGroupNo then
    self._ui.state:SetShow(false)
    self._ui.progressBg:SetShow(false)
    self._ui.progress:SetShow(false)
  elseif nil ~= self._progressQuestInfo[questGroupNo] then
    self._ui.bg:addInputEvent("Mouse_LUp", "PaGlobalFunc_Achievement_OpenBookShelfQuest(" .. questGroupNo .. ", " .. questNo .. ")")
    if true == isComplete then
      self._ui.state:SetShow(true)
      self._ui.progressBg:SetShow(true)
      self._ui.progress:SetShow(true)
      self._ui.state:SetText(self._currentCount .. " / " .. self._maxCount)
      self._ui.progress:SetSmoothMode(false)
      self._ui.progress:SetProgressRate(self._currentCount / self._maxCount * 100)
      self._ui.progress:SetSmoothMode(true)
    else
      self._ui.state:SetShow(false)
      self._ui.progressBg:SetShow(false)
      self._ui.progress:SetShow(false)
    end
  end
end
function challengeAlert:SetProgress()
  if nil == self._currentQuestGroupNo or nil == self._progressQuestInfo[self._currentQuestGroupNo] then
    return
  end
  self._currentCount = math.min(self._currentCount, self._maxCount)
  if self._maxCount == self._currentCount then
    self._ui.state:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_COMPLETE"))
  else
    self._ui.state:SetText(self._currentCount .. " / " .. self._maxCount)
  end
  self._ui.progress:SetProgressRate(self._currentCount / self._maxCount * 100)
  self._progressQuestInfo[self._currentQuestGroupNo] = self._currentCount
end
function challengeAlert:showAni()
  local MoveAni = _panel:addMoveAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  MoveAni:SetStartPosition(_panel:GetSizeX() * -1, _panel:GetPosY())
  MoveAni:SetEndPosition(10, _panel:GetPosY())
  MoveAni:SetDisableWhileAni(true)
  _panel:SetShow(true)
  _panel:RegisterUpdateFunc("FromClient_ChallengeAlert_UpdatePerFrame")
end
local progressOpen = false
function challengeAlert:hideAni()
  local MoveAni = _panel:addMoveAnimation(0, 0.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MoveAni:SetStartPosition(_panel:GetPosX(), _panel:GetPosY())
  MoveAni:SetEndPosition(_panel:GetSizeX() * -1, _panel:GetPosY())
  MoveAni:SetHideAtEnd(true)
  MoveAni:SetDisableWhileAni(true)
  TooltipSimple_Hide()
  progressOpen = false
  _panel:ClearUpdateLuaFunc()
end
function challengeAlert:open(titleStr, descStr, questGroupNo, questNo, isComplete)
  if false == _ContentsGroup_AchievementQuest then
    return
  end
  self._time = 0
  self:update(titleStr, descStr, questGroupNo, questNo, isComplete)
  self:SetProgress()
  if not _panel:GetShow() then
    self:showAni()
  end
end
function challengeAlert:close()
  self:hideAni()
end
function FromClient_ChallengeAlert_UpdatePerFrame(deltaTime)
  local self = challengeAlert
  self._time = self._time + deltaTime
  if self._time > 7 then
    self:hideAni()
    self._time = 0
  elseif self._time > 2 then
    self:SetProgress()
  end
end
function challengeAlert:setProgressCount()
  local questListInfo = ToClient_GetQuestList()
  if nil == questListInfo then
    return
  end
  self._progressQuestInfo = {}
  local specialQuestCount = questListInfo:getSpecialQuestCount()
  for ii = 1, specialQuestCount do
    local specialQuestNo = questListInfo:getSpecialQuestAt(ii - 1)
    if nil == specialQuestNo then
      return
    end
    local questInfoWrapper = questList_getQuestStatic(specialQuestNo._group, specialQuestNo._quest)
    local questNo = questInfoWrapper:getQuestNo()
    local questInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
    if nil ~= questInfo and ToClient_isProgressingQuest(questNo._group, questNo._quest) then
      local questCondition = questInfo:getDemandAt(0)
      self._progressQuestInfo[questNo._group] = questCondition._currentCount
    end
  end
end
function FromClient_NewQuestAlert(isAccept, questNoRaw)
  if not isAccept then
    return
  end
  local self = challengeAlert
  local questInfoWrapper = questList_getQuestInfo(questNoRaw)
  if nil ~= questInfoWrapper then
    local questNo = questInfoWrapper:getQuestNo()
    local _questType = questInfoWrapper:getQuestType()
    local questInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
    if nil ~= questInfo and 10 == _questType then
      challengeAlert:setProgressCount()
      local questCondition = questInfo:getDemandAt(0)
      local titleStr = questInfoWrapper:getTitle()
      local descStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGEALERT_NEW_ALERT")
      self:open(titleStr, descStr, questNo._group, questNo._quest, false)
    end
  end
end
function challengeAlert:init()
  self:registEventHandler()
  self:setProgressCount()
end
function challengeAlert:registEventHandler()
  registerEvent("FromClient_notifyUpdateSpecialQuest", "FromClient_notifyUpdateSpecialQuest_challengeAlert")
  registerEvent("EventQuestUpdateNotify", "FromClient_NewQuestAlert")
end
function FromClient_notifyUpdateSpecialQuest_challengeAlert(questNoRaw)
  if false == _ContentsGroup_AchievementQuest then
    return
  end
  local self = challengeAlert
  local questInfoWrapper = questList_getQuestInfo(questNoRaw)
  if nil ~= questInfoWrapper then
    local questNo = questInfoWrapper:getQuestNo()
    local questInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
    if nil ~= questInfo then
      local questCondition = questInfo:getDemandAt(0)
      local titleStr = questInfoWrapper:getTitle()
      local descStr = questInfoWrapper:getDesc()
      self._maxCount = questCondition._destCount
      self._currentCount = questCondition._currentCount
      self:open(titleStr, descStr, questNo._group, questNo._quest, true)
      self._currentQuestGroupNo = questNo._group
    end
  end
end
function FromClient_ChallengeAlert_Init()
  local self = challengeAlert
  self:init()
end
function testChallenge(questNoRaw)
  local self = challengeAlert
  self:open("test", "desc")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ChallengeAlert_Init")
