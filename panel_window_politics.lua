local PaGlobal_Window_Politics = {
  _ui = {
    stt_title = UI.getChildControl(Panel_Window_Politics, "StaticText_Title"),
    btn_close = UI.getChildControl(Panel_Window_Politics, "Button_Win_Close"),
    btnTemplate_class = UI.getChildControl(Panel_Window_Politics, "RadioButton_ClassTemplate"),
    btn_class = nil,
    stc_classIcon = nil,
    stc_listBG = UI.getChildControl(Panel_Window_Politics, "Static_BG"),
    txt_dataRefreshing = nil,
    list2_visibleCandidateList = nil,
    btn_sortByDate = UI.getChildControl(Panel_Window_Politics, "Button_SortByDate"),
    btn_sortByVote = UI.getChildControl(Panel_Window_Politics, "Button_SortByVote"),
    btn_registCandidate = UI.getChildControl(Panel_Window_Politics, "Button_RegistCandidate"),
    btn_cancelCandidate = UI.getChildControl(Panel_Window_Politics, "Button_CancelCandidate"),
    txt_TimeLeft = UI.getChildControl(Panel_Window_Politics, "StaticText_TimeLeft")
  },
  _storedCandidateList = nil,
  _countOfWholeCandidate = nil,
  _currentClassTap = nil,
  _sort = nil,
  _depositMoney = 0,
  _clickedCandidate = nil,
  _SORT_BY = {
    REGIST_DATE_NEW_FIRST = 1,
    REGIST_DATE_OLD_FIRST = 2,
    VOTE_GAINED_DESCENDING = 3,
    VOTE_GAINED_ASCENDING = 4
  }
}
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_Class = CppEnums.ClassType
function PaGlobal_Window_Politics:initialize()
  self._ui.stt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_TITLE"))
  self._ui.btn_close:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_Close()")
  self._ui.txt_dataRefreshing = UI.getChildControl(self._ui.stc_listBG, "StaticText_DataRefreshing")
  self._ui.list2_visibleCandidateList = UI.getChildControl(self._ui.stc_listBG, "List2_Politics")
  self._ui.list2_visibleCandidateList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_Window_Politics_CandidateListControlCreate")
  self._ui.list2_visibleCandidateList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.btn_sortByDate:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.REGIST_DATE_NEW_FIRST .. ")")
  self._ui.btn_sortByDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_REGIST") .. " \226\150\188")
  self._ui.btn_sortByVote:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.VOTE_GAINED_DESCENDING .. ")")
  self._ui.btn_sortByVote:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_VOTE") .. " \226\150\188")
  self._ui.btn_registCandidate:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_RegistCandidateButtonPressed()")
  self._ui.btn_cancelCandidate:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_CancelCandidateButtonPressed()")
  self._depositMoney = 100000000
  registerEvent("FromClient_responseListCandidate", "FromClient_Window_Politics_ListArrived")
  registerEvent("FromClient_responseRegisterCandidate", "FromClient_Window_Politics_RegistCandidateResponse")
  registerEvent("FromClient_responseCancelCandidate", "FromClient_Window_Politics_CancelCandidateResponse")
  registerEvent("FromClient_responseVoteCandidate", "FromClient_Window_Politics_VoteResponse")
end
function FGlobal_Window_Politics_Open()
  PaGlobal_Window_Politics:open()
end
function politicsTest()
  PaGlobal_Window_Politics:open()
end
function PaGlobal_Window_Politics:open()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self._currentClassTap = selfPlayer:getClassType()
  Panel_Window_Politics:SetShow(true)
  self._sort = 0
  self:initClassButtons()
  FGlobal_Window_Politics_RequestNewList()
end
function PaGlobal_Window_Politics:initClassButtons()
  self._ui.btn_class = {}
  self._ui.stc_classIcon = {}
  local classCount = getPossibleClassCount()
  local xOffset = 15
  local yOffset = self._ui.btnTemplate_class:GetPosY()
  local rowWidth = self._ui.btnTemplate_class:GetSizeX() + 15
  local columnHeight = self._ui.btnTemplate_class:GetSizeY() + 10
  local columnMax = math.floor((Panel_Window_Politics:GetSizeX() - xOffset * 2) / rowWidth)
  for i = 0, classCount - 1 do
    if true == ToClient_checkCreatePossibleClass(i) then
      self._ui.btn_class[i] = UI.createAndCopyBasePropertyControl(Panel_Window_Politics, "RadioButton_ClassTemplate", Panel_Window_Politics, "RadioButton_Class_" .. i)
      self._ui.btn_class[i]:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_setClassTabTo(" .. i .. " )")
      self._ui.btn_class[i]:addInputEvent("Mouse_On", "FGlobal_Window_Politics_showSimpleTooltip(true, " .. i .. ")")
      self._ui.btn_class[i]:addInputEvent("Mouse_Out", "FGlobal_Window_Politics_showSimpleTooltip(false)")
      self._ui.stc_classIcon[i] = UI.createAndCopyBasePropertyControl(Panel_Window_Politics, "Static_ClassIconTemplate", self._ui.btn_class[i], "Static_ClassIcon_" .. i)
      self:changeTextureClass(self._ui.stc_classIcon[i], i)
      if i == self._currentClassTap then
        self._ui.stc_classIcon[i]:SetColor(Defines.Color.C_FF008AFF)
      else
        self._ui.stc_classIcon[i]:SetColor(Defines.Color.C_FFEFEFEF)
      end
      self._ui.stc_classIcon[i]:SetIgnore(true)
      local row = math.floor(i % columnMax)
      local xPos = xOffset + rowWidth * row
      self._ui.btn_class[i]:SetPosX(xPos)
      if 0 ~= columnMax then
        self._ui.btn_class[i]:SetPosY(yOffset + columnHeight * math.floor(i / columnMax))
      end
    end
  end
  self._ui.btn_class[self._currentClassTap]:SetCheck(true)
  local rowCount = math.ceil(classCount / columnMax)
  local classButtonsYArea = rowWidth * rowCount + yOffset
  self._ui.stc_listBG:SetPosY(classButtonsYArea + 5)
  Panel_Window_Politics:SetSize(Panel_Window_Politics:GetSizeX(), classButtonsYArea + 53 + self._ui.stc_listBG:GetSizeY())
  Panel_Window_Politics:SetPosY((getScreenSizeY() - Panel_Window_Politics:GetSizeY()) / 2)
  self._ui.btn_registCandidate:ComputePos()
  self._ui.btn_cancelCandidate:ComputePos()
  self._ui.txt_TimeLeft:ComputePos()
  self._ui.btn_sortByDate:ComputePos()
  self._ui.btn_sortByVote:ComputePos()
end
function FGlobal_Window_Politics_RequestNewList()
  local self = PaGlobal_Window_Politics
  self._ui.list2_visibleCandidateList:getElementManager():clearKey()
  self._ui.txt_dataRefreshing:SetShow(true)
  self._ui.txt_dataRefreshing:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_WAITING_FOR_LIST_DESC"))
  self._ui.btn_sortByDate:SetEnable(false)
  self._ui.btn_sortByDate:SetMonoTone(true)
  self._ui.btn_sortByVote:SetEnable(false)
  self._ui.btn_sortByVote:SetMonoTone(true)
  self._ui.btn_registCandidate:SetEnable(false)
  self._ui.btn_registCandidate:SetMonoTone(true)
  self._ui.btn_cancelCandidate:SetEnable(false)
  self._ui.btn_cancelCandidate:SetMonoTone(true)
  ToClient_requestCandidateList()
end
function FromClient_Window_Politics_ListArrived()
  local self = PaGlobal_Window_Politics
  self._ui.txt_dataRefreshing:SetShow(false)
  self:refreshData()
  self:refreshView()
  self._ui.btn_sortByDate:SetEnable(true)
  self._ui.btn_sortByVote:SetEnable(true)
  self._ui.btn_sortByDate:SetMonoTone(false)
  self._ui.btn_sortByVote:SetMonoTone(false)
  self._ui.btn_registCandidate:SetEnable(true)
  self._ui.btn_cancelCandidate:SetEnable(true)
  self._ui.btn_registCandidate:SetMonoTone(false)
  self._ui.btn_cancelCandidate:SetMonoTone(false)
end
function PaGlobal_Window_Politics:refreshData()
  self._storedCandidateList = {}
  self._countOfWholeCandidate = ToClient_getCandidateListSize()
  for i = 1, self._countOfWholeCandidate do
    local queriedCandidateInfoWrapper = ToClient_getCandidateInfo(i - 1)
    local candidateClass = queriedCandidateInfoWrapper:getClassType()
    if nil ~= candidateClass then
      if nil == self._storedCandidateList[candidateClass] then
        self._storedCandidateList[candidateClass] = {}
      end
      local candidateInfo = {
        index = i - 1,
        registerTime = queriedCandidateInfoWrapper:getRegisterTime(),
        userNo = queriedCandidateInfoWrapper:getUserNo(),
        userCharacterNo = queriedCandidateInfoWrapper:getCharacterNo(),
        classType = candidateClass,
        voteCount = queriedCandidateInfoWrapper:getVoteCount(),
        characterName = queriedCandidateInfoWrapper:getCharacterName(),
        introduceSelf = queriedCandidateInfoWrapper:getIntroduction(),
        level = queriedCandidateInfoWrapper:getLevel(),
        guildNo = queriedCandidateInfoWrapper:getGuildNo()
      }
      self._storedCandidateList[candidateClass][#self._storedCandidateList[candidateClass] + 1] = candidateInfo
    end
  end
  if ToClient_IsDevelopment() then
    for i = 1, 10000 do
      local candidateClass = getRandomValue(0, getPossibleClassCount())
      if nil ~= candidateClass then
        if nil == self._storedCandidateList[candidateClass] then
          self._storedCandidateList[candidateClass] = Array.new()
        end
        local candidateInfo = {
          registerTime = 0,
          userNo = nil,
          userCharacterNo = nil,
          classType = candidateClass,
          voteCount = getRandomValue(0, 100000000),
          characterName = "dummy " .. candidateClass .. " Candidate" .. i,
          introduceSelf = "self introduce text. length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- length test ---- ",
          level = 61,
          guildNo = nil
        }
        self._storedCandidateList[candidateClass][#self._storedCandidateList[candidateClass] + 1] = candidateInfo
      else
      end
    end
  end
end
function PaGlobal_Window_Politics:refreshView()
  self._ui.list2_visibleCandidateList:getElementManager():clearKey()
  if nil == self._storedCandidateList or nil == self._storedCandidateList[self._currentClassTap] or #self._storedCandidateList[self._currentClassTap] < 1 then
    self._ui.txt_dataRefreshing:SetShow(true)
    self._ui.txt_dataRefreshing:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_NO_CANDIDATE_FOUND"))
  else
    self._ui.txt_dataRefreshing:SetShow(false)
    local idx = 0
    for k, v in pairs(self._storedCandidateList[self._currentClassTap]) do
      self._ui.list2_visibleCandidateList:getElementManager():pushKey(k)
      idx = idx + 1
    end
  end
end
function FGlobal_Window_Politics_setClassTabTo(classNum)
  local self = PaGlobal_Window_Politics
  if classNum ~= self._currentClassTap then
    self._currentClassTap = classNum
    self:refreshView()
    for i = 0, #self._ui.btn_class do
      if i == classNum then
        self._ui.stc_classIcon[i]:SetColor(Defines.Color.C_FF008AFF)
      else
        self._ui.stc_classIcon[i]:SetColor(Defines.Color.C_FFEFEFEF)
      end
    end
  else
    return
  end
end
function FGlobal_Window_Politics_CandidateListControlCreate(control, key)
  local self = PaGlobal_Window_Politics
  local stc_bg = UI.getChildControl(control, "Static_1")
  local txt_guildName = UI.getChildControl(stc_bg, "StaticText_GuildName")
  local txt_familyName = UI.getChildControl(stc_bg, "StaticText_FamilyNameText")
  local txt_charName = UI.getChildControl(stc_bg, "StaticText_CharName")
  local stc_charImage = UI.getChildControl(stc_bg, "Static_CharacterImage")
  local txt_level = UI.getChildControl(stc_bg, "StaticText_Level")
  local txt_class = UI.getChildControl(stc_bg, "StaticText_ClassText")
  local txt_voteGained = UI.getChildControl(stc_bg, "StaticText_VoteGained")
  local btn_vote = UI.getChildControl(stc_bg, "Button_Vote")
  local txt_introduceBG = UI.getChildControl(stc_bg, "Static_IntroduceBG")
  local txt_introduce = UI.getChildControl(txt_introduceBG, "StaticText_Introduce")
  local candidateInfo = self._storedCandidateList[self._currentClassTap][Int64toInt32(key)]
  if nil == candidateInfo then
    return
  end
  if nil ~= candidateInfo.userCharacterNo then
    btn_vote:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_VoteButtonPressed(" .. candidateInfo.index .. ")")
  end
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "candidateInfo.userCharacterNo : " .. tostring(candidateInfo.userCharacterNo))
  if nil ~= candidateInfo.guildNo then
    local guildInfoWrapper = ToClient_GetGuildInfoWrapperByGuildNo(candidateInfo.guildNo)
    if nil ~= guildInfoWrapper then
      txt_guildName:SetShow(true)
      txt_guildName:SetText("<" .. guildInfoWrapper:getName() .. ">" or "")
    end
  else
    txt_guildName:SetShow(false)
  end
  txt_level:SetText(candidateInfo.level or "")
  txt_class:SetText(CppEnums.ClassType2String[self._currentClassTap])
  txt_charName:SetText(candidateInfo.characterName or "")
  txt_familyName:SetShow(false)
  txt_voteGained:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_POLITICS_VOTE_COUNT", "count", candidateInfo.voteCount or "0"))
  txt_introduce:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  txt_introduce:setLineCountByLimitAutoWrap(math.floor(txt_introduce:GetSizeY() / txt_introduce:GetTextSizeY()))
  txt_introduce:SetText(candidateInfo.introduceSelf or "")
end
function FGlobal_Window_Politics_sortCandidatesBy(sortType)
  local self = PaGlobal_Window_Politics
  if sortType == self._SORT_BY.REGIST_DATE_NEW_FIRST then
    self._sort = self._SORT_BY.REGIST_DATE_NEW_FIRST
    self._ui.btn_sortByDate:removeInputEvent("Mouse_LUp")
    self._ui.btn_sortByDate:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.REGIST_DATE_OLD_FIRST .. ")")
    self._ui.btn_sortByDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_REGIST") .. " \226\150\188")
  elseif sortType == self._SORT_BY.REGIST_DATE_OLD_FIRST then
    self._sort = self._SORT_BY.REGIST_DATE_OLD_FIRST
    self._ui.btn_sortByDate:removeInputEvent("Mouse_LUp")
    self._ui.btn_sortByDate:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.REGIST_DATE_NEW_FIRST .. ")")
    self._ui.btn_sortByDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_REGIST") .. " \226\150\178")
  elseif sortType == self._SORT_BY.VOTE_GAINED_DESCENDING then
    self._sort = self._SORT_BY.VOTE_GAINED_DESCENDING
    self._ui.btn_sortByVote:removeInputEvent("Mouse_LUp")
    self._ui.btn_sortByVote:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.VOTE_GAINED_ASCENDING .. ")")
    self._ui.btn_sortByVote:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_VOTE") .. " \226\150\188")
  elseif sortType == self._SORT_BY.VOTE_GAINED_ASCENDING then
    self._sort = self._SORT_BY.VOTE_GAINED_ASCENDING
    self._ui.btn_sortByVote:removeInputEvent("Mouse_LUp")
    self._ui.btn_sortByVote:addInputEvent("Mouse_LUp", "FGlobal_Window_Politics_sortCandidatesBy(" .. self._SORT_BY.VOTE_GAINED_DESCENDING .. ")")
    self._ui.btn_sortByVote:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_SORT_VOTE") .. " \226\150\178")
  end
  local sortF
  if self._sort == self._SORT_BY.REGIST_DATE_NEW_FIRST then
    sortF = FGlobal_Window_Politics_sortByRegisterTime
  elseif self._sort == self._SORT_BY.REGIST_DATE_OLD_FIRST then
    sortF = FGlobal_Window_Politics_sortByRegisterTimeRev
  elseif self._sort == self._SORT_BY.VOTE_GAINED_DESCENDING then
    sortF = FGlobal_Window_Politics_sortByVoteGained
  elseif self._sort == self._SORT_BY.VOTE_GAINED_ASCENDING then
    sortF = FGlobal_Window_Politics_sortByVoteGainedRev
  end
  if nil ~= sortF then
    table.sort(self._storedCandidateList[self._currentClassTap], sortF)
  end
  self:refreshView()
end
function FGlobal_Window_Politics_sortByRegisterTime(ii, jj)
  return ii.registerTime > jj.registerTime
end
function FGlobal_Window_Politics_sortByVoteGained(ii, jj)
  return ii.voteCount > jj.voteCount
end
function FGlobal_Window_Politics_sortByRegisterTimeRev(ii, jj)
  return ii.registerTime < jj.registerTime
end
function FGlobal_Window_Politics_sortByVoteGainedRev(ii, jj)
  return ii.voteCount < jj.voteCount
end
function FGlobal_Window_Politics_RegistCandidateButtonPressed()
  local MessageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_REGIST_NOTICE_TITLE"),
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_POLITICS_REGIST_NOTICE_DESC", "amount", tostring(makeDotMoney(toInt64(0, PaGlobal_Window_Politics._depositMoney)))),
    functionYes = FGlobal_Window_Politics_RegistCandidate,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(MessageBoxData)
end
function FGlobal_Window_Politics_RegistCandidate()
  ToClient_registerCandidate()
end
function FromClient_Window_Politics_RegistCandidateResponse(isSuccess)
  local Message = ""
  if isSuccess then
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_REGIST_CANDIDATE_SUCC")
  else
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_REGIST_CANDIDATE_FAIL")
  end
  local MessageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_WAITING_FOR_LIST_TITLE"),
    content = Message,
    functionApply = FGlobal_Window_Politics_RequestNewList,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(MessageBoxData)
end
function FGlobal_Window_Politics_CancelCandidateButtonPressed()
  ToClient_cancelCandidate()
end
function FromClient_Window_Politics_CancelCandidateResponse(isSuccess)
  local Message = ""
  if isSuccess then
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_CANCEL_CANDIDATE_SUCC")
  else
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_CANCEL_CANDIDATE_FAIL")
  end
  local MessageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_WAITING_FOR_LIST_TITLE"),
    content = Message,
    functionApply = FGlobal_Window_Politics_RequestNewList,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(MessageBoxData)
end
function FGlobal_Window_Politics_VoteButtonPressed(index)
  PaGlobal_Window_Politics._clickedCandidate = index
  local MessageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_VOTE_NOTE_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_VOTE_NOTE_DESC"),
    functionYes = FGlobal_Window_Politics_Vote,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(MessageBoxData)
end
function FGlobal_Window_Politics_Vote()
  clickedCandidateWrapper = ToClient_getCandidateInfo(PaGlobal_Window_Politics._clickedCandidate)
  ToClient_voteCandidate(clickedCandidateWrapper:getCharacterNo())
end
function FromClient_Window_Politics_VoteResponse(isSuccess)
  local Message = ""
  if isSuccess then
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_VOTE_SUCC")
  else
    Message = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_VOTE_FAIL")
  end
  local MessageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_POLITICS_WAITING_FOR_LIST_TITLE"),
    content = Message,
    functionApply = FGlobal_Window_Politics_RequestNewList,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(MessageBoxData)
end
function FGlobal_Window_Politics_Close()
  PaGlobal_Window_Politics:btn_close()
end
function PaGlobal_Window_Politics:btn_close()
  Panel_Window_Politics:SetShow(false)
end
function PaGlobal_Window_Politics:changeTextureClass(control, classType)
  control:ChangeTextureInfoName("Renewal/UI_Icon/PC_Icon_ClassSymbol_00.dds")
  local x1, y1, x2, y2
  if classType == UI_Class.ClassType_Warrior then
    x1, y1, x2, y2 = setTextureUV_Func(control, 2, 2, 43, 43)
  elseif classType == UI_Class.ClassType_Ranger then
    x1, y1, x2, y2 = setTextureUV_Func(control, 44, 2, 85, 43)
  elseif classType == UI_Class.ClassType_Sorcerer then
    x1, y1, x2, y2 = setTextureUV_Func(control, 86, 2, 127, 43)
  elseif classType == UI_Class.ClassType_Lahn then
    x1, y1, x2, y2 = setTextureUV_Func(control, 128, 86, 169, 127)
  elseif classType == UI_Class.ClassType_Giant then
    x1, y1, x2, y2 = setTextureUV_Func(control, 128, 2, 169, 43)
  elseif classType == UI_Class.ClassType_Tamer then
    x1, y1, x2, y2 = setTextureUV_Func(control, 170, 2, 211, 43)
  elseif classType == UI_Class.ClassType_Combattant then
    x1, y1, x2, y2 = setTextureUV_Func(control, 2, 86, 43, 127)
  elseif classType == UI_Class.ClassType_CombattantWomen then
    x1, y1, x2, y2 = setTextureUV_Func(control, 44, 86, 85, 127)
  elseif classType == UI_Class.ClassType_BladeMaster then
    x1, y1, x2, y2 = setTextureUV_Func(control, 212, 2, 253, 43)
  elseif classType == UI_Class.ClassType_BladeMasterWomen then
    x1, y1, x2, y2 = setTextureUV_Func(control, 212, 44, 253, 85)
  elseif classType == UI_Class.ClassType_Valkyrie then
    x1, y1, x2, y2 = setTextureUV_Func(control, 2, 44, 43, 85)
  elseif classType == UI_Class.ClassType_NinjaWomen then
    x1, y1, x2, y2 = setTextureUV_Func(control, 170, 44, 211, 84)
  elseif classType == UI_Class.ClassType_NinjaMan then
    x1, y1, x2, y2 = setTextureUV_Func(control, 128, 44, 169, 85)
  elseif classType == UI_Class.ClassType_DarkElf then
    x1, y1, x2, y2 = setTextureUV_Func(control, 84, 84, 127, 127)
  elseif classType == UI_Class.ClassType_Wizard then
    x1, y1, x2, y2 = setTextureUV_Func(control, 44, 44, 85, 85)
  elseif classType == UI_Class.ClassType_WizardWomen then
    x1, y1, x2, y2 = setTextureUV_Func(control, 84, 44, 127, 85)
  end
  if nil ~= classType then
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  end
end
function FGlobal_Window_Politics_showSimpleTooltip(isShow, classNum)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(PaGlobal_Window_Politics._ui.btn_class[classNum], CppEnums.ClassType2String[classNum])
end
function FromClient_luaLoadComplete_Panel_Window_Politics()
  PaGlobal_Window_Politics:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_Politics")
