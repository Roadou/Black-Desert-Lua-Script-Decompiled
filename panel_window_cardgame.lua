local PaGlobal_CardGame = {
  _ui = {
    _closeButton = UI.getChildControl(Panel_Window_CardGame, "Button_Win_Close"),
    _cardSettingBg = UI.getChildControl(Panel_Window_CardGame, "Static_SelectCardBg"),
    _card = {
      [0] = {},
      [1] = {},
      [2] = {},
      [3] = {}
    },
    _cardDesc = nil,
    _saveButton = nil,
    _resetButton = nil,
    _boardBg = UI.getChildControl(Panel_Window_CardGame, "Static_GameBoardBg"),
    _myCard = {
      [0] = {},
      [1] = {},
      [2] = {},
      [3] = {},
      [4] = {}
    },
    _otherCard = {
      [0] = {},
      [1] = {},
      [2] = {},
      [3] = {},
      [4] = {}
    }
  },
  _maxValue = 53,
  _haveCount = 5,
  _totalValue = 0,
  _totalSelectedCount = 0,
  _grade = {
    [0] = {
      10,
      14,
      17,
      19,
      20
    },
    [1] = {
      4,
      7,
      11,
      15,
      18
    },
    [2] = {
      2,
      5,
      8,
      12,
      16
    },
    [3] = {
      1,
      3,
      6,
      9,
      13
    }
  },
  _myCard = {},
  _currentRount = 1,
  _lala = {
    [0] = {
      {0, 4},
      {0, 5},
      {2, 2},
      {3, 1},
      {3, 4}
    },
    [1] = {
      {1, 4},
      {2, 4},
      {3, 3},
      {3, 4},
      {3, 5}
    },
    [2] = {
      {0, 3},
      {0, 4},
      {2, 1},
      {2, 5},
      {3, 1}
    }
  },
  _lalaCard = 0,
  _lalaOrder = {},
  _roundScore = {},
  _myScore = 0,
  _lalaScore = 0,
  _lalaWinMsg = {},
  _lalaWinMessage = {
    [0] = "\237\158\136\237\158\155, \236\149\189\237\149\152\236\139\156\234\181\176\236\154\148.",
    "\236\162\128 \235\141\148 \237\158\152\235\130\180\235\179\180\236\132\184\236\154\148.",
    "\236\158\172\235\175\184\236\158\136\234\178\140 \236\162\128 \237\149\180\236\163\188\236\132\184\236\154\148.",
    "\234\179\160\235\184\148\235\166\176\236\157\180 \235\141\148 \235\168\184\235\166\172\234\176\128 \236\162\139\236\157\132 \234\177\176 \234\176\153\236\149\132\236\154\148.",
    "\235\132\136\235\172\180 \235\167\137\235\172\180\234\176\128\235\130\180 \236\149\132\235\139\140\234\176\128\236\154\148?",
    "\236\157\180\234\177\180 \235\168\184\235\166\172\235\165\188 \236\141\168\236\149\188 \237\149\152\235\138\148 \234\178\140\236\158\132\236\157\180\235\158\141\235\139\136\235\139\164.",
    "\235\178\140\236\141\168 \237\143\172\234\184\176\236\157\184\234\176\128\236\154\148?",
    "\234\176\144\236\130\172\237\149\169\235\139\136\235\139\164~",
    "\235\167\155\236\158\136\235\138\148 \236\160\144\236\136\152\235\132\164\236\154\148.",
    "\235\172\180\235\139\164\235\172\180\235\139\164\235\172\180\235\139\164\235\172\180\235\139\164\235\172\180\235\139\164!!"
  },
  _lalaLoseMsg = {},
  _lalaLoseMessage = {
    [0] = "\235\139\164\236\157\140 \235\157\188\236\154\180\235\147\156\236\151\144 \235\167\140\237\154\140\237\149\152\234\178\160\236\150\180\236\154\148.",
    "\236\160\156\235\178\149\236\157\180\236\139\156\235\132\164\236\154\148.",
    "\236\149\132\236\167\129 \235\170\184\236\157\180 \236\149\136 \237\146\128\235\160\184\236\150\180\236\154\148.",
    "\236\149\136 \235\180\144\236\163\188\236\132\184\236\154\148?",
    "\235\132\136\235\172\180 \236\162\139\236\149\132\237\149\152\236\139\156\236\167\128 \235\167\136\236\132\184\236\154\148!",
    "\235\176\164\234\184\184 \236\161\176\236\139\172\237\149\152\236\132\184\236\154\148~.",
    "\236\149\132\236\158\137~ \235\132\136\235\172\180\237\149\180\236\154\148~",
    "\236\150\180\236\132\156 \235\139\164\236\157\140 \234\178\140\236\158\132 \237\149\152\236\163\160.",
    "\236\160\156\234\176\128 \236\167\128\235\169\180 \236\149\132\236\157\180\235\147\164\236\157\180 \236\138\172\237\141\188\237\149\180\236\154\148. \227\133\156.\227\133\156",
    "\237\155\140\236\169\141, \237\155\140\236\169\141. \237\158\136\235\129\133~ \237\158\160~"
  }
}
function PaGlobal_CardGame:Init()
  for index = 1, 20 do
    local grade = math.floor((index - 1) / 5)
    local gradeString = ""
    if 0 == grade then
      gradeString = "S"
    elseif 1 == grade then
      gradeString = "A"
    elseif 2 == grade then
      gradeString = "B"
    elseif 3 == grade then
      gradeString = "C"
    end
    local value = (index - 1) % 5 + 1
    self._ui._card[grade][value] = {}
    self._ui._card[grade][value]._bg = UI.getChildControl(self._ui._cardSettingBg, "Static_CardSlot" .. gradeString .. value)
    self._ui._card[grade][value]._check = UI.getChildControl(self._ui._card[grade][value]._bg, "Checkbox_Receive")
    self._ui._card[grade][value]._check:SetCheck(false)
    self._ui._card[grade][value]._check:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_SetCard(" .. index .. "," .. grade .. "," .. value .. ")")
  end
  self._ui._cardDesc = UI.getChildControl(self._ui._cardSettingBg, "StaticText_CardDesc")
  self._ui._cardDesc:SetText("\236\132\160\237\131\157\237\149\156 \236\185\180\235\147\156 : " .. self._totalSelectedCount .. "\236\158\165\n\236\185\180\235\147\156 \236\160\144\236\136\152 : " .. self._totalValue .. "\236\160\144")
  self._ui._saveButton = UI.getChildControl(self._ui._cardSettingBg, "Button_Confirm")
  self._ui._resetButton = UI.getChildControl(self._ui._cardSettingBg, "Button_Reset")
  self._ui._saveButton:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_Save()")
  self._ui._resetButton:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_Reset()")
  self._ui._closeButton:addInputEvent("Mouse_LUp", "FGlobal_CardGame_Close()")
  for index = 0, 4 do
    self._ui._myCard[index] = {}
    self._ui._myCard[index]._bg = UI.getChildControl(self._ui._boardBg, "Static_MyCardSlot" .. index + 1)
    self._ui._myCard[index]._check = UI.getChildControl(self._ui._myCard[index]._bg, "Checkbox_Receive")
    self._ui._myCard[index]._check:SetIgnore(false)
    self._ui._myCard[index]._check:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_SelectCard(" .. index .. ")")
    self._ui._myCard[index]._grade = UI.getChildControl(self._ui._myCard[index]._bg, "StaticText_Grade")
    self._ui._myCard[index]._point = UI.getChildControl(self._ui._myCard[index]._bg, "StaticText_Point")
    self._ui._myCard[index]._value = UI.getChildControl(self._ui._myCard[index]._bg, "StaticText_Value")
    self._ui._myCard[index]._result = UI.getChildControl(self._ui._myCard[index]._bg, "StaticText_Result")
    self._ui._myCard[index]._result:SetShow(false)
  end
  for index = 0, 4 do
    self._ui._otherCard[index] = {}
    self._ui._otherCard[index]._bg = UI.getChildControl(self._ui._boardBg, "Static_OtherCardSlot" .. index + 1)
    self._ui._otherCard[index]._bg:SetShow(false)
    self._ui._otherCard[index]._grade = UI.getChildControl(self._ui._otherCard[index]._bg, "StaticText_Grade")
    self._ui._otherCard[index]._point = UI.getChildControl(self._ui._otherCard[index]._bg, "StaticText_Point")
    self._ui._otherCard[index]._value = UI.getChildControl(self._ui._otherCard[index]._bg, "StaticText_Value")
    self._ui._otherCard[index]._result = UI.getChildControl(self._ui._otherCard[index]._bg, "StaticText_Result")
    self._ui._otherCard[index]._result:SetShow(false)
  end
  self._ui._score = UI.getChildControl(self._ui._boardBg, "StaticText_Score")
  self._ui._round = UI.getChildControl(self._ui._boardBg, "StaticText_RoundDesc")
  self._ui._currentRoundScore = UI.getChildControl(self._ui._boardBg, "StaticText_CurrentRoundScore")
  self._ui._bubbleBg = UI.getChildControl(self._ui._boardBg, "Static_Obsidian_B_Left")
  self._ui._bubbleText = UI.getChildControl(self._ui._bubbleBg, "StaticText_Obsidian_B")
  self._ui._bubbleBg:SetShow(false)
  self._ui._resultMessage = UI.getChildControl(self._ui._boardBg, "StaticText_ResultMessage")
  self._ui._resultMessage:SetShow(false)
  self._ui._btnOut = UI.getChildControl(self._ui._boardBg, "Button_Out")
  self._ui._btnGiveUp = UI.getChildControl(self._ui._boardBg, "Button_Giveup")
  self._ui._btnOut:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_Go()")
  self._ui._btnGiveUp:SetText("\235\139\164\236\139\156 \237\149\152\234\184\176")
  self._ui._btnGiveUp:addInputEvent("Mouse_LUp", "PaGlobal_CardGame_GameReset()")
  self._ui._cardSettingBg:SetShow(true)
  self._ui._boardBg:SetShow(false)
end
function PaGlobal_CardGame:Open()
  self._currentRount = 1
  self._ui._cardSettingBg:SetShow(true)
  self._ui._boardBg:SetShow(false)
  PaGlobal_CardGame_Reset()
  Panel_Window_CardGame:SetShow(true)
end
function PaGlobal_CardGame:Close()
  Panel_Window_CardGame:SetShow(false)
end
function PaGlobal_CardGame_SetCard(index, grade, value)
  local self = PaGlobal_CardGame
  if self._ui._card[grade][value]._check:IsCheck() then
    if self._haveCount <= self._totalSelectedCount then
      self._ui._card[grade][value]._check:SetCheck(false)
      Proc_ShowMessage_Ack("\235\141\148 \236\157\180\236\131\129 \236\185\180\235\147\156\235\165\188 \236\132\160\237\131\157\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    if self._maxValue < self._totalValue + self._grade[grade][value] then
      self._ui._card[grade][value]._check:SetCheck(false)
      Proc_ShowMessage_Ack("53\236\160\144\236\157\132 \235\132\152\235\138\148 \236\160\144\236\136\152\235\165\188 \236\132\184\237\140\133\237\149\160 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.")
      return
    end
    self._totalSelectedCount = self._totalSelectedCount + 1
    self._totalValue = self._totalValue + self._grade[grade][value]
    self._ui._cardDesc:SetText("\236\132\160\237\131\157\237\149\156 \236\185\180\235\147\156 : " .. self._totalSelectedCount .. "\236\158\165\n\236\185\180\235\147\156 \236\160\144\236\136\152 : " .. self._totalValue .. "\236\160\144")
  else
    self._totalSelectedCount = self._totalSelectedCount - 1
    self._totalValue = self._totalValue - self._grade[grade][value]
    self._ui._cardDesc:SetText("\236\132\160\237\131\157\237\149\156 \236\185\180\235\147\156 : " .. self._totalSelectedCount .. "\236\158\165\n\236\185\180\235\147\156 \236\160\144\236\136\152 : " .. self._totalValue .. "\236\160\144")
  end
end
function PaGlobal_CardGame_Save()
  local self = PaGlobal_CardGame
  if self._haveCount ~= self._totalSelectedCount then
    Proc_ShowMessage_Ack("\236\185\180\235\147\156\235\165\188 \235\167\136\236\160\128 \236\132\160\237\131\157\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  local cIndex = 0
  for index = 1, 20 do
    local grade = math.floor((index - 1) / 5)
    local gradeString = ""
    if 0 == grade then
      gradeString = "S"
    elseif 1 == grade then
      gradeString = "A"
    elseif 2 == grade then
      gradeString = "B"
    elseif 3 == grade then
      gradeString = "C"
    end
    local value = (index - 1) % 5 + 1
    local temp = {}
    if self._ui._card[grade][value]._check:IsCheck() then
      temp._grade = grade
      temp._value = value
      temp._index = cIndex
      self._myCard[cIndex] = {}
      self._myCard[cIndex] = temp
      cIndex = cIndex + 1
    end
  end
  for index = 0, 4 do
    local gradeString = ""
    if 0 == self._myCard[index]._grade then
      gradeString = "S"
    elseif 1 == self._myCard[index]._grade then
      gradeString = "A"
    elseif 2 == self._myCard[index]._grade then
      gradeString = "B"
    elseif 3 == self._myCard[index]._grade then
      gradeString = "C"
    end
    self._ui._myCard[index]._grade:SetText(gradeString .. " \235\147\177\234\184\137")
    self._ui._myCard[index]._point:SetText(self._myCard[index]._value .. "\235\139\168\234\179\132")
    self._ui._myCard[index]._value:SetText(self._grade[self._myCard[index]._grade][self._myCard[index]._value] .. "\236\160\144")
    self._ui._myCard[index]._check:SetShow(true)
    self._ui._myCard[index]._check:SetCheck(false)
    self._ui._myCard[index]._result:SetShow(false)
  end
  self._lalaCard = math.random(0, 2)
  self._currentRount = 1
  for index = 0, 4 do
    if index > 0 then
      local isMatch = true
      local currentOrder
      while isMatch do
        currentOrder = math.random(0, 4)
        isMatch = false
        for pIndex = 0, index - 1 do
          isMatch = isMatch or self._lalaOrder[pIndex] == currentOrder
        end
      end
      self._lalaOrder[index] = currentOrder
      local isMatch = true
      local currentOrder
      while isMatch do
        currentOrder = math.random(1, 5)
        isMatch = false
        for pIndex = 0, index - 1 do
          isMatch = isMatch or self._roundScore[pIndex] == currentOrder
        end
      end
      self._roundScore[index] = currentOrder
      local isMatch = true
      local currentOrder
      while isMatch do
        currentOrder = math.random(0, 9)
        isMatch = false
        for pIndex = 0, index - 1 do
          isMatch = isMatch or self._lalaWinMsg[pIndex] == currentOrder
        end
      end
      self._lalaWinMsg[index] = currentOrder
      local isMatch = true
      local currentOrder
      while isMatch do
        currentOrder = math.random(0, 9)
        isMatch = false
        for pIndex = 0, index - 1 do
          isMatch = isMatch or self._lalaLoseMsg[pIndex] == currentOrder
        end
      end
      self._lalaLoseMsg[index] = currentOrder
    else
      self._lalaOrder[index] = math.random(0, 4)
      self._roundScore[index] = math.random(1, 5)
      self._lalaWinMsg[index] = math.random(0, 9)
      self._lalaLoseMsg[index] = math.random(0, 9)
    end
    local lalaCardTable = self._lala[self._lalaCard][self._lalaOrder[index] + 1]
    local lalaCardValue = self._grade[lalaCardTable[1]][lalaCardTable[2]]
    local gradeString = ""
    if 0 == lalaCardTable[1] then
      gradeString = "S"
    elseif 1 == lalaCardTable[1] then
      gradeString = "A"
    elseif 2 == lalaCardTable[1] then
      gradeString = "B"
    elseif 3 == lalaCardTable[1] then
      gradeString = "C"
    end
    self._ui._otherCard[index]._grade:SetText(gradeString .. " \235\147\177\234\184\137")
    self._ui._otherCard[index]._point:SetText(lalaCardTable[2] .. "\235\139\168\234\179\132")
    self._ui._otherCard[index]._value:SetText(lalaCardValue .. "\236\160\144")
    self._ui._otherCard[index]._bg:SetShow(false)
    self._ui._otherCard[index]._result:SetShow(false)
  end
  self._ui._currentRoundScore:SetText("\236\157\180\235\178\136 \235\157\188\236\154\180\235\147\156\236\151\144 \234\177\184\235\166\176 \236\160\144\236\136\152 : " .. self._roundScore[0] .. "\236\160\144")
  self._ui._round:SetText(self._currentRount .. " / 5 \235\157\188\236\154\180\235\147\156")
  self._ui._score:SetText("\235\130\180 \236\160\144\236\136\152 : 0\236\160\144\n\235\157\188\235\157\188 \236\160\144\236\136\152 : 0\236\160\144")
  self._myScore = 0
  self._lalaScore = 0
  self:bubbleAniRun("\236\149\136\235\133\149\237\149\152\236\132\184\236\154\148, \235\170\168\237\151\152\234\176\128\235\139\152. \236\160\128\235\158\145 \237\149\156 \234\178\156 \237\149\152\236\139\164\235\158\152\236\154\148?")
  self._ui._cardSettingBg:SetShow(false)
  self._ui._boardBg:SetShow(true)
end
function PaGlobal_CardGame_Reset()
  local self = PaGlobal_CardGame
  for index = 1, 20 do
    local grade = math.floor((index - 1) / 5)
    local gradeString = ""
    if 0 == grade then
      gradeString = "S"
    elseif 1 == grade then
      gradeString = "A"
    elseif 2 == grade then
      gradeString = "B"
    elseif 3 == grade then
      gradeString = "C"
    end
    local value = (index - 1) % 5 + 1
    self._ui._card[grade][value]._check:SetCheck(false)
  end
  self._totalSelectedCount = 0
  self._totalValue = 0
  self._ui._cardDesc:SetText("\236\132\160\237\131\157\237\149\156 \236\185\180\235\147\156 : " .. self._totalSelectedCount .. "\236\158\165\n\236\185\180\235\147\156 \236\160\144\236\136\152 : " .. self._totalValue .. "\236\160\144")
end
function PaGlobal_CardGame_SelectCard(index)
  local self = PaGlobal_CardGame
  for cIndex = 0, 4 do
    self._ui._myCard[cIndex]._check:SetCheck(cIndex == index)
  end
end
function PaGlobal_CardGame_Go()
  local self = PaGlobal_CardGame
  local isCheck = false
  local _index = 0
  for index = 0, 4 do
    if self._ui._myCard[index]._check:IsCheck() then
      isCheck = true
      _index = index
    end
  end
  if not isCheck then
    Proc_ShowMessage_Ack("\236\185\180\235\147\156\235\165\188 \236\132\160\237\131\157\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  PaGlobal_CardGame_EnemyCard(self._currentRount, _index)
end
function PaGlobal_CardGame_GameReset()
  local self = PaGlobal_CardGame
  if 5 < self._currentRount then
    self._currentRount = 1
    self._ui._cardSettingBg:SetShow(true)
    self._ui._boardBg:SetShow(false)
    PaGlobal_CardGame_Reset()
  else
    Proc_ShowMessage_Ack("\234\178\140\236\158\132\236\157\180 \236\149\132\236\167\129 \236\167\132\237\150\137\236\164\145\236\158\133\235\139\136\235\139\164.")
  end
end
function PaGlobal_CardGame_EnemyCard(round, myCardIndex)
  local self = PaGlobal_CardGame
  local lalaCardTable = self._lala[self._lalaCard][self._lalaOrder[round - 1] + 1]
  local lalaCardValue = self._grade[lalaCardTable[1]][lalaCardTable[2]]
  local myCardValue = self._grade[self._myCard[myCardIndex]._grade][self._myCard[myCardIndex]._value]
  if 5 == lalaCardTable[2] and 1 == self._myCard[myCardIndex]._value then
    self._ui._myCard[myCardIndex]._result:SetText("O")
    self._ui._otherCard[round - 1]._result:SetText("X")
    self._myScore = self._myScore + self._roundScore[round - 1]
  elseif 1 == lalaCardTable[2] and 5 == self._myCard[myCardIndex]._value then
    self._ui._myCard[myCardIndex]._result:SetText("X")
    self._ui._otherCard[round - 1]._result:SetText("O")
    self._lalaScore = self._lalaScore + self._roundScore[round - 1]
  elseif lalaCardValue < myCardValue then
    self._ui._myCard[myCardIndex]._result:SetText("O")
    self._ui._otherCard[round - 1]._result:SetText("X")
    self._myScore = self._myScore + self._roundScore[round - 1]
  elseif lalaCardValue > myCardValue then
    self._ui._myCard[myCardIndex]._result:SetText("X")
    self._ui._otherCard[round - 1]._result:SetText("O")
    self._lalaScore = self._lalaScore + self._roundScore[round - 1]
  else
    self._ui._myCard[myCardIndex]._result:SetText("=")
    self._ui._otherCard[round - 1]._result:SetText("=")
    self._roundScore[round] = self._roundScore[round] + self._roundScore[round - 1]
  end
  self._ui._myCard[myCardIndex]._check:SetShow(false)
  self._ui._myCard[myCardIndex]._result:SetShow(true)
  self._ui._myCard[myCardIndex]._check:SetCheck(false)
  self._ui._otherCard[round - 1]._bg:SetShow(true)
  self._ui._otherCard[round - 1]._result:SetShow(true)
  self._currentRount = self._currentRount + 1
  if 5 < self._currentRount then
    if self._myScore < self._lalaScore then
      self._ui._round:SetText("\237\140\168\235\176\176")
      self:bubbleAniRun("\235\132\136\235\172\180\235\130\152 \236\137\172\236\154\180 \234\178\140\236\158\132\236\152\128\235\132\164\236\154\148. \236\162\128 \235\141\148 \236\151\176\236\138\181\237\149\180\236\152\164\236\132\184\236\154\148.")
      self:resultMessageShow("\237\140\168\235\176\176\237\150\136\236\138\181\235\139\136\235\139\164.\n\235\130\180 \236\160\144\236\136\152 : " .. self._myScore .. " / \235\157\188\235\157\188 \236\160\144\236\136\152 : " .. self._lalaScore)
    else
      self._ui._round:SetText("\236\138\185\235\166\172")
      self:bubbleAniRun("\236\149\132\236\157\180\235\165\188 \236\131\129\235\140\128\235\161\156 \237\148\188\235\143\132 \235\136\136\235\172\188\235\143\132 \236\151\134\236\156\188\236\139\156\234\181\176\236\154\148. \227\133\156.\227\133\156")
      self:resultMessageShow("\236\138\185\235\166\172\237\150\136\236\138\181\235\139\136\235\139\164.\n\235\130\180 \236\160\144\236\136\152 : " .. self._myScore .. " / \235\157\188\235\157\188 \236\160\144\236\136\152 : " .. self._lalaScore)
    end
  else
    self._ui._currentRoundScore:SetText("\236\157\180\235\178\136 \235\157\188\236\154\180\235\147\156\236\151\144 \234\177\184\235\166\176 \236\160\144\236\136\152 : " .. self._roundScore[round] .. "\236\160\144")
    self._ui._round:SetText(self._currentRount .. " / 5 \235\157\188\236\154\180\235\147\156")
    if "X" == self._ui._myCard[myCardIndex]._result:GetText() then
      self:bubbleAniRun(self._lalaWinMessage[self._lalaWinMsg[round - 1]])
      self:resultMessageShow("\236\157\180\235\178\136 \235\157\188\236\154\180\235\147\156 \237\140\168\235\176\176! \235\157\188\235\157\188\236\151\144\234\178\140 +" .. self._roundScore[round - 1] .. "\236\160\144")
    elseif "O" == self._ui._myCard[myCardIndex]._result:GetText() then
      self:bubbleAniRun(self._lalaLoseMessage[self._lalaLoseMsg[round - 1]])
      self:resultMessageShow("\236\157\180\235\178\136 \235\157\188\236\154\180\235\147\156 \236\138\185\235\166\172! \236\158\144\236\139\160\236\151\144\234\178\140 +" .. self._roundScore[round - 1] .. "\236\160\144")
    else
      self:bubbleAniRun("\235\139\164\236\157\140 \237\140\144\236\157\128 \236\160\156\234\176\128 \234\188\173 \234\176\128\236\160\184\234\176\136 \234\177\176\236\151\144\236\154\148.")
      self:resultMessageShow("\236\157\180\235\178\136 \235\157\188\236\154\180\235\147\156 \235\172\180\236\138\185\235\182\128! \235\139\164\236\157\140 \235\157\188\236\154\180\235\147\156 \236\160\144\236\136\152\236\151\144 +" .. self._roundScore[round - 1] .. "\236\160\144")
    end
  end
  self._ui._score:SetText("\235\130\180 \236\160\144\236\136\152 : " .. self._myScore .. "\236\160\144\n\235\157\188\235\157\188 \236\160\144\236\136\152 : " .. self._lalaScore .. "\236\160\144")
end
function PaGlobal_CardGame:bubbleAniRun(text)
  self._ui._bubbleText:SetText(text)
  self._ui._bubbleText:SetSize(math.max(117, self._ui._bubbleText:GetTextSizeX()), self._ui._bubbleText:GetSizeY())
  self._ui._bubbleBg:SetSize(self._ui._bubbleText:GetSizeX() + 33, self._ui._bubbleBg:GetSizeY())
  self._ui._bubbleBg:ComputePos()
  self._ui._bubbleBg:SetShow(true)
  local openAni = self._ui._bubbleBg:addColorAnimation(0, 0.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  openAni:SetStartColor(Defines.Color.C_00FFFFFF)
  openAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  openAni:SetStartIntensity(3)
  openAni:SetEndIntensity(1)
  openAni.IsChangeChild = true
  local closeAni = self._ui._bubbleBg:addColorAnimation(3, 3.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function PaGlobal_CardGame:resultMessageShow(text)
  self._ui._resultMessage:SetText(text)
  self._ui._resultMessage:SetShow(true)
  local openAni = self._ui._resultMessage:addColorAnimation(0, 0.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  openAni:SetStartColor(Defines.Color.C_00FFFFFF)
  openAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  openAni:SetStartIntensity(3)
  openAni:SetEndIntensity(1)
  openAni.IsChangeChild = true
  local closeAni = self._ui._resultMessage:addColorAnimation(5, 5.22, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function FGlobal_CardGame_Open()
  local self = PaGlobal_CardGame
  self:Open()
end
function FGlobal_CardGame_Close()
  PaGlobal_CardGame:Close()
end
function FGlobal_CardGame_Init()
  PaGlobal_CardGame:Init()
end
registerEvent("FromClient_luaLoadComplete", "FGlobal_CardGame_Init")
