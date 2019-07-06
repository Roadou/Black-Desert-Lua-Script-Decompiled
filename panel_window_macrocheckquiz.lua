local PaGlobal_MacroCheckQuiz = {
  _ui = {
    titleName = UI.getChildControl(Panel_Window_MacroCheckQuiz, "StaticText_Title"),
    questionTitle = UI.getChildControl(Panel_Window_MacroCheckQuiz, "StaticText_QuestionTitle"),
    timeCount = UI.getChildControl(Panel_Window_MacroCheckQuiz, "StaticText_TimeCount"),
    limitTimeGauge = UI.getChildControl(Panel_Window_MacroCheckQuiz, "Progress2_limitTime"),
    questionBG = UI.getChildControl(Panel_Window_MacroCheckQuiz, "Static_QuestionBG"),
    warningBG = UI.getChildControl(Panel_Window_MacroCheckQuiz, "Static_WarningBG"),
    button_Apply = UI.getChildControl(Panel_Window_MacroCheckQuiz, "Button_Apply")
  },
  _keyPadUi = {
    currentTypeName = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "StaticText_CurrentTypeName"),
    inputDisplay = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Static_DisplayNumber"),
    button_Keypad_Back = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_Back"),
    button_Keypad_Clear = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_Clear"),
    button_Keypad_Confirm = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_Confirm"),
    button_Keypad_Close = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_Close"),
    button_Keypad_Cancel = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_Cancel")
  },
  _config = {
    indexMax = 10,
    startX = 4,
    startY = 56,
    gapX = 64,
    gapY = 34,
    row = 4,
    column = 3
  },
  _isadmin = false,
  _maxQuestionCount = __eSecureCodeQuestion_TotalCount,
  _questionTypeName = {},
  _agreed = {},
  _questionNo = 0,
  _beforQuestionNo = 0,
  _questionTypeNo = {},
  _currentAnswer = "",
  _correctCount = 0,
  _quizAnswer = {},
  _numberButton = {},
  _keyCount = 0,
  _state = 0,
  _currentAnsewerNo = "",
  _isChangeTexture = false,
  _confirmCount = 0,
  _messageNo = 0,
  _logMessage = {},
  _limitTime = 180,
  _currentTime = 0,
  _playerName = nil
}
function OpenMacroCheckQuiz()
  PaGlobal_MacroCheckQuiz:reset()
  audioPostEvent_SystemUi(8, 16)
  _AudioPostEvent_SystemUiForXBOX(8, 16)
  PaGlobal_MacroCheckQuiz:questionSetting()
  PaGlobal_MacroCheckQuiz:keyShuffle()
  Panel_Window_MacroCheckQuiz:SetShow(true, true)
end
function Close_MacroCheckQuiz()
  Panel_Window_MacroCheckQuiz:SetShow(false, false)
end
function PaGlobal_MacroCheckQuiz:reset()
  self._questionNo = 0
  self._currentTime = 0
  for ii = 0, self._maxQuestionCount - 1 do
    self._ui.answerTemplete[ii]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_INPUT_TEXT"))
  end
  self._ui.warningBG:SetShow(true, true)
  self._ui.button_Apply:SetShow(false, true)
  self._ui.button_Apply:addInputEvent("Mouse_LUp", "MacroCheckQuiz_applyConfirm()")
  self._quizAnswer = {
    [0] = "",
    [1] = "",
    [2] = ""
  }
  self._logMessage = {
    [1] = "",
    [2] = "",
    [3] = ""
  }
end
function PaGlobal_MacroCheckQuiz:initialize()
  self._ui.qPadBg0 = UI.getChildControl(self._ui.questionBG, "Static_QPadBG0")
  self._ui.qPadBg1 = UI.getChildControl(self._ui.questionBG, "Static_QPadBG1")
  self._ui.qPadBg2 = UI.getChildControl(self._ui.questionBG, "Static_QPadBG2")
  self._ui.questionNameUi = {}
  self._ui.questionNameUi[0] = UI.getChildControl(self._ui.qPadBg0, "StaticText_Question0")
  self._ui.questionNameUi[1] = UI.getChildControl(self._ui.qPadBg1, "StaticText_Question1")
  self._ui.questionNameUi[2] = UI.getChildControl(self._ui.qPadBg2, "StaticText_Question2")
  self._ui.answerTemplete = {}
  self._ui.answerTemplete[0] = UI.getChildControl(self._ui.qPadBg0, "Radiobutton_Answer0")
  self._ui.answerTemplete[1] = UI.getChildControl(self._ui.qPadBg1, "Radiobutton_Answer1")
  self._ui.answerTemplete[2] = UI.getChildControl(self._ui.qPadBg2, "Radiobutton_Answer2")
  self._ui.answerTemplete[0]:addInputEvent("Mouse_LUp", "FGlobal_MacroCheckQuiz_KeyPadOpen(0)")
  self._ui.answerTemplete[1]:addInputEvent("Mouse_LUp", "FGlobal_MacroCheckQuiz_KeyPadOpen(1)")
  self._ui.answerTemplete[2]:addInputEvent("Mouse_LUp", "FGlobal_MacroCheckQuiz_KeyPadOpen(2)")
  self._ui.answerBG = {}
  self._ui.answerBG[0] = UI.getChildControl(self._ui.qPadBg0, "Static_AnswerBG0")
  self._ui.answerBG[1] = UI.getChildControl(self._ui.qPadBg1, "Static_AnswerBG1")
  self._ui.answerBG[2] = UI.getChildControl(self._ui.qPadBg2, "Static_AnswerBG2")
  self._questionTypeName[__eSecureCodeQuestionType_MaxHp] = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_TYPEMAXHP_TEXT")
  self._questionTypeName[__eSecureCodeQuestionType_MaxMp] = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_TYPEMAXMP_TEXT")
  self._questionTypeName[__eSecureCodeQuestionType_MaxWp] = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_QTYPEMAXWP_TEXT")
  self._questionTypeName[__eSecureCodeQuestionType_MaxExplorePoint] = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_QTYPECONTRIBUTION_TEXT")
  self._questionTypeName[__eeSecureCodeQuestionType_Level] = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_QTYPELEVEL_TEXT")
  Panel_Window_MacroCheckQuiz:RegisterUpdateFunc("FGlobal_MacroCheckQuiz_limitTime")
end
function PaGlobal_MacroCheckQuiz:questionSetting()
  for ii = 0, self._maxQuestionCount - 1 do
    self._questionTypeNo[ii] = ToClient_getSecureCodeQuestionType(ii)
    if __eSecureCodeQuestionType_MaxHp == self._questionTypeNo[ii] then
      self._questionTypeName[self._questionTypeNo[ii]] = self._questionTypeName[__eSecureCodeQuestionType_MaxHp]
    elseif __eSecureCodeQuestionType_MaxMp == self._questionTypeNo[ii] then
      self._questionTypeName[self._questionTypeNo[ii]] = self._questionTypeName[__eSecureCodeQuestionType_MaxMp]
    elseif __eSecureCodeQuestionType_MaxWp == self._questionTypeNo[ii] then
      self._questionTypeName[self._questionTypeNo[ii]] = self._questionTypeName[__eSecureCodeQuestionType_MaxWp]
    elseif __eSecureCodeQuestionType_MaxExplorePoint == self._questionTypeNo[ii] then
      self._questionTypeName[self._questionTypeNo[ii]] = self._questionTypeName[__eSecureCodeQuestionType_MaxExplorePoint]
    elseif __eeSecureCodeQuestionType_Level == self._questionTypeNo[ii] then
      self._questionTypeName[self._questionTypeNo[ii]] = self._questionTypeName[__eeSecureCodeQuestionType_Level]
    end
    self._ui.questionNameUi[ii]:SetText(self._questionTypeName[self._questionTypeNo[ii]])
  end
end
function FGlobal_MacroCheckQuiz_KeyPadOpen(index)
  local self = PaGlobal_MacroCheckQuiz
  for ii = 0, self._maxQuestionCount - 1 do
    if true ~= self._agreed[ii] then
      self._ui.answerTemplete[ii]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_INPUT_TEXT"))
      self._ui.answerBG[self._questionNo]:ResetAndClearVertexAni(true)
    end
  end
  self._agreed[index] = false
  self._quizAnswer[index] = ""
  self._ui.answerTemplete[index]:SetText("")
  PaGlobal_MacroCheckQuiz:confirmCheck()
  self._ui.answerBG[index]:SetVertexAniRun("Ani_Color", true)
  self._questionNo = index
  self._keyPadUi.currentTypeName:SetText(self._questionTypeName[self._questionTypeNo[index]])
  PaGlobal_MacroCheckQuiz:keyPadInit()
  Panel_Window_MacroCheckQuizKeyPad:SetShow(true, true)
end
function PaGlobal_MacroCheckQuiz:keyShuffle()
  for i = 0, self._config.indexMax - 1 do
    local index = {}
    index.buttonControl = UI.getChildControl(Panel_Window_MacroCheckQuizKeyPad, "Button_" .. i .. "_Import")
    index.buttonControl:addInputEvent("Mouse_Out", "MacroCheckQuiz_buttonMouseOut(" .. i .. ")")
    index.buttonControl:addInputEvent("Mouse_LDown", "MacroCheckQuiz_buttonBlind(" .. i .. ")")
    index.buttonControl:addInputEvent("Mouse_LUp", "MacroCheckQuiz_numberInput(" .. i .. ")")
    index.baseText = ""
    index.num = i
    self._numberButton[i] = index
  end
  local shuffleIndex = 0
  local tempNum = 0
  local posX = 0
  local posY = 0
  for i = 0, self._config.indexMax - 1 do
    shuffleIndex = getRandomValue(0, 9)
    tempNum = self._numberButton[i].num
    self._numberButton[i].num = self._numberButton[shuffleIndex].num
    self._numberButton[shuffleIndex].num = tempNum
  end
  for j = 0, self._config.indexMax - 1 do
    posX = self._config.startX + self._config.gapX * (j % self._config.column)
    posY = self._config.startY + self._config.gapY * math.floor(j / self._config.column)
    self._numberButton[self._numberButton[j].num].buttonControl:SetPosX(posX)
    self._numberButton[self._numberButton[j].num].buttonControl:SetPosY(posY)
    self._numberButton[j].baseText = tostring(self._numberButton[j].num)
  end
  self._keyPadUi.button_Keypad_Back:SetPosX(self._config.startX + self._config.gapX * (self._config.column - 2))
  self._keyPadUi.button_Keypad_Back:SetPosY(self._config.startY + self._config.gapY * (self._config.row - 1))
  self._keyPadUi.button_Keypad_Clear:SetPosX(self._config.startX + self._config.gapX * (self._config.column - 1))
  self._keyPadUi.button_Keypad_Clear:SetPosY(self._config.startY + self._config.gapY * (self._config.row - 1))
  self._keyPadUi.button_Keypad_Back:addInputEvent("Mouse_LUp", "MacroCheckQuiz_input_Back()")
  self._keyPadUi.button_Keypad_Clear:addInputEvent("Mouse_LUp", "MacroCheckQuiz_input_Clear()")
  self._keyPadUi.button_Keypad_Confirm:addInputEvent("Mouse_LUp", "MacroCheckQuiz_answerConfirm()")
  self._keyPadUi.button_Keypad_Cancel:addInputEvent("Mouse_LUp", "PaGlobal_MacroCheckQuizkeyPadClose()")
  self._keyPadUi.button_Keypad_Close:addInputEvent("Mouse_LUp", "PaGlobal_MacroCheckQuizkeyPadClose()")
  PaGlobal_MacroCheckQuiz:buttonInit()
end
function PaGlobal_MacroCheckQuiz:buttonInit()
  for ii = 0, self._config.indexMax - 1 do
    self._numberButton[ii].buttonControl:SetText(self._numberButton[ii].baseText)
  end
  self._isChangeTexture = false
end
function MacroCheckQuiz_buttonMouseOut(index)
  PaGlobal_MacroCheckQuiz:buttonInit()
end
function MacroCheckQuiz_buttonBlind(index)
  local self = PaGlobal_MacroCheckQuiz
  self._isChangeTexture = true
end
function MacroCheckQuiz_numberInput(index)
  local self = PaGlobal_MacroCheckQuiz
  if string.len(self._currentAnswer) < 5 or self._keyCount < 0 then
    self._keyCount = self._keyCount + 1
    local _shuffleIndex = self._numberButton[index].num
    if self._currentAnswer == "0" then
      self._currentAnswer = ""
    end
    self._currentAnswer = tostring(self._currentAnswer .. _shuffleIndex)
    PaGlobal_MacroCheckQuiz:currentAnswer(self._questionNo, self._currentAnswer)
  end
end
function PaGlobal_MacroCheckQuiz:currentAnswer(index, currentAnswer)
  self._ui.answerTemplete[index]:SetText(currentAnswer)
  self._keyPadUi.inputDisplay:SetText(currentAnswer)
end
function PaGlobal_MacroCheckQuiz:keyPadInit()
  self._currentAnswer = ""
  self._keyCount = 0
  self._keyPadUi.inputDisplay:SetText(currentAnswer)
end
function MacroCheckQuiz_input_Clear()
  local self = PaGlobal_MacroCheckQuiz
  self._currentAnswer = ""
  self._keyCount = 0
  PaGlobal_MacroCheckQuiz:currentAnswer(self._questionNo, self._currentAnswer)
end
function MacroCheckQuiz_input_Back()
  local self = PaGlobal_MacroCheckQuiz
  if 1 > self._keyCount then
    MacroCheckQuiz_input_Clear()
  else
    self._keyCount = self._keyCount - 1
    self._currentAnswer = string.sub(self._currentAnswer, 1, self._keyCount)
    PaGlobal_MacroCheckQuiz:currentAnswer(self._questionNo, self._currentAnswer)
  end
end
function PaGlobal_MacroCheckQuiz:confirmCheck()
  local _confirmCount = 0
  for ii = 0, self._maxQuestionCount - 1 do
    if true == self._agreed[ii] then
      _confirmCount = _confirmCount + 1
    end
  end
  if self._maxQuestionCount == _confirmCount then
    self._ui.warningBG:SetShow(false, true)
    self._ui.button_Apply:SetShow(true, true)
  else
    self._ui.warningBG:SetShow(true, true)
    self._ui.button_Apply:SetShow(false, true)
  end
end
function MacroCheckQuiz_answerConfirm()
  local self = PaGlobal_MacroCheckQuiz
  if "" ~= self._currentAnswer then
    self._quizAnswer[self._questionNo] = self._currentAnswer
    self._agreed[self._questionNo] = true
    PaGlobal_MacroCheckQuiz:keyPadInit()
    Panel_Window_MacroCheckQuizKeyPad:SetShow(false, true)
    PaGlobal_MacroCheckQuiz:confirmCheck()
  else
    self._quizAnswer[self._questionNo] = ""
    self._ui.answerTemplete[self._questionNo]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_INPUT_TEXT"))
  end
  self._ui.answerBG[self._questionNo]:ResetAndClearVertexAni(true)
  Panel_Window_MacroCheckQuizKeyPad:SetShow(false, true)
end
function MacroCheckQuiz_applyConfirm()
  local self = PaGlobal_MacroCheckQuiz
  for ii = 0, self._maxQuestionCount - 1 do
    self._quizAnswer[ii] = tonumber(self._quizAnswer[ii])
    if nil == self._quizAnswer[ii] then
      self._quizAnswer[ii] = 0
    end
    ToClient_setSecureCodeAnswer(ii, self._quizAnswer[ii])
  end
  ToClient_sendSecureCodeAnswer()
  local _sendToPlayermessage = PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_FEEDBACK_TEXT")
  PaGlobal_MacroCheckQuiz:close()
  Panel_Window_MacroCheckQuiz:SetShow(false, true)
  Panel_Window_MacroCheckQuizKeyPad:SetShow(false, true)
  Proc_ShowMessage_Ack(_sendToPlayermessage)
end
function PaGlobal_MacroCheckQuizkeyPadClose()
  local self = PaGlobal_MacroCheckQuiz
  MacroCheckQuiz_input_Clear()
  self._ui.answerTemplete[self._questionNo]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MACROCHECKQUIZ_QUIZ_INPUT_TEXT"))
  self._ui.answerBG[self._questionNo]:ResetAndClearVertexAni(true)
  Panel_Window_MacroCheckQuizKeyPad:SetShow(false, true)
end
function PaGlobal_MacroCheckQuiz:close()
  self._currentTime = 0
  self._confirmCount = 0
  for ii = 0, self._maxQuestionCount - 1 do
    self._quizAnswer[ii] = ""
    self._agreed[ii] = false
    self._ui.answerTemplete[ii]:SetText("")
  end
  Panel_Window_MacroCheckQuiz:SetShow(false, true)
  Panel_Window_MacroCheckQuizKeyPad:SetShow(false, true)
end
function FGlobal_MacroCheckQuiz_limitTime(deltaTime)
  local self = PaGlobal_MacroCheckQuiz
  self._currentTime = self._currentTime + deltaTime
  local clockMinutes = tonumber(math.floor((self._limitTime - self._currentTime) / 60))
  local clockSeconds = tonumber(math.floor((self._limitTime - self._currentTime) % 60))
  if clockSeconds > 9 then
    self._ui.timeCount:SetText("0" .. clockMinutes .. " : " .. clockSeconds)
  else
    self._ui.timeCount:SetText("0" .. clockMinutes .. " : 0" .. clockSeconds)
  end
  local _last = (self._limitTime - self._currentTime) / 180 * 100
  self._ui.limitTimeGauge:SetProgressRate(_last)
  if _last <= 0 then
    PaGlobal_MacroCheckQuiz:close()
  end
end
function FromClient_receiveSecureCodeQuestion(name, isAdmin, type)
  self = PaGlobal_MacroCheckQuiz
  self._playerName = tostring(name)
  if true ~= isAdmin then
    OpenMacroCheckQuiz()
  else
    local _sendToGMMessage = " GM Send the MacroCheckQuiz to ' " .. tostring(name) .. " '"
    Proc_ShowMessage_Ack(_sendToGMMessage)
  end
end
function FromClient_receiveSecureCodeTimeOver(name)
  local _sendToGMMessage = "PlayerName = " .. tostring(name) .. ",   Time Out"
  Proc_ShowMessage_Ack(_sendToGMMessage)
end
function FromClient_receiveSecureCodeAnswer_Detail(isCorrect, type, value, correctAnswer)
  self = PaGlobal_MacroCheckQuiz
  self._messageNo = self._messageNo + 1
  local _typName = self._questionTypeName[type]
  self._logMessage[self._messageNo] = "Player Name = " .. tostring(self._playerName) .. " IsCorrect = " .. tostring(isCorrect) .. " QuestionType = " .. tostring(_typName) .. " UserAnswer = " .. tostring(value) .. " CorrectAnswer = " .. tostring(correctAnswer)
  if __eSecureCodeQuestion_TotalCount == self._messageNo then
    PaGlobal_MacroCheckQuiz:Send_To_GMMessage()
  end
end
function PaGlobal_MacroCheckQuiz:Send_To_GMMessage()
  self._messageNo = 0
  local _sendToGMMessage = ""
  for ii = 1, self._maxQuestionCount do
    _sendToGMMessage = tostring(_sendToGMMessage .. self._logMessage[ii] .. "\n")
  end
  Proc_ShowMessage_Ack(_sendToGMMessage)
end
function FromClient_receiveSecureCodeAnswer(correctCount, name)
  self = PaGlobal_MacroCheckQuiz
  self._playerName = tostring(name)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_MacroCheckQuiz")
registerEvent("FromClient_receiveSecureCodeQuestion", "FromClient_receiveSecureCodeQuestion")
registerEvent("FromClient_receiveSecureCodeAnswer_Detail", "FromClient_receiveSecureCodeAnswer_Detail")
registerEvent("FromClient_receiveSecureCodeAnswer", "FromClient_receiveSecureCodeAnswer")
registerEvent("FromClient_receiveSecureCodeTimeOver", "FromClient_receiveSecureCodeTimeOver")
function FromClient_luaLoadComplete_Panel_Window_MacroCheckQuiz()
  PaGlobal_MacroCheckQuiz:initialize()
end
