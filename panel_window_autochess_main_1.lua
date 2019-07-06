function PaGlobal_AutoChess_Main:initialize()
  if true == self._initialize then
    return
  end
  self._ui._btn_CardTemplete = UI.getChildControl(Panel_Widnow_AutoChess_Main, "RadioButton_CardTemplete")
  self._ui._btn_SummonComplete = UI.getChildControl(Panel_Widnow_AutoChess_Main, "RadioButton_SummonComplete")
  self._ui._btn_CardSetComplete = UI.getChildControl(Panel_Widnow_AutoChess_Main, "RadioButton_CardSetComplete")
  self._ui._btn_End = UI.getChildControl(Panel_Widnow_AutoChess_Main, "RadioButton_End")
  self._ui._staticText_PhaseTimer = UI.getChildControl(Panel_Widnow_AutoChess_Main, "StaticText_PhaseTimer")
  self._ui._btn_myCardList = {}
  for index = 0, self._config._maxCardSize - 1 do
    local btn_myCard = UI.createAndCopyBasePropertyControl(Panel_Widnow_AutoChess_Main, "RadioButton_CardTemplete", Panel_Widnow_AutoChess_Main, "RadioButton_MyCard_" .. index)
    btn_myCard:SetPosX(self._ui._btn_CardTemplete:GetPosX() + (self._ui._btn_CardTemplete:GetSizeX() + 30) * index)
    btn_myCard:SetShow(false)
    btn_myCard:SetText("")
    self._ui._btn_myCardList[index] = btn_myCard
  end
  self._ui._btn_targetDeckList = {}
  for index = 0, self._config._maxCardSize - 1 do
    local btn_targetCard = UI.createAndCopyBasePropertyControl(Panel_Widnow_AutoChess_Main, "RadioButton_CardTemplete", Panel_Widnow_AutoChess_Main, "RadioButton_TargetCard_" .. index)
    btn_targetCard:SetPosX(self._ui._btn_CardTemplete:GetPosX() + (self._ui._btn_CardTemplete:GetSizeX() + 20) * index)
    btn_targetCard:SetPosY(20)
    btn_targetCard:SetShow(false)
    btn_targetCard:SetText("")
    btn_targetCard:SetIgnore(true)
    self._ui._btn_targetDeckList[index] = btn_targetCard
  end
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_AutoChess_Main:registEventHandler()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  Panel_Widnow_AutoChess_Main:RegisterUpdateFunc("PaGlobal_AutoChess_UpdatePerFrame")
  self._ui._btn_End:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_GameEnd()")
  self._ui._btn_CardSetComplete:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_CardSetComplete()")
  self._ui._btn_SummonComplete:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_SummonComplete()")
  registerEvent("FromClient_AutoChessStart", "PaGlobalFunc_FromClient_AutoChessStart")
  registerEvent("FromClient_AutoChessLoadTargetDeck", "PaGlobalFunc_FromClient_AutoChessLoadTargetDeck")
  registerEvent("FromClient_AutoChessMyCardSet", "PaGlobalFunc_FromClient_AutoChessMyCardSet")
  registerEvent("FromClient_AutoChessGameEnd", "PaGlobalFunc_FromClient_AutoChessGameEnd")
  registerEvent("FromClient_AutoChessPhaseTimeSet", "PaGlobalFunc_FromClient_AutoChessPhaseTimeSet")
  registerEvent("FromClient_AutoChessLoadMyDeck", "PaGlobalFunc_FromClient_AutoChessLoadMyDeck")
end
function PaGlobal_AutoChess_Main:prepareOpen()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  self._deckList = {}
  self._deckIndex = 0
  ToClient_AutoChess_LoadDeck()
  PaGlobal_AutoChess_Main:open()
end
function PaGlobal_AutoChess_Main:open()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  Panel_Widnow_AutoChess_Main:SetShow(true)
end
function PaGlobal_AutoChess_Main:prepareClose()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  self:myCardClear()
  self:targetDeckClear()
  PaGlobal_AutoChess_Main:close()
end
function PaGlobal_AutoChess_Main:close()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  Panel_Widnow_AutoChess_Main:SetShow(false)
end
function PaGlobal_AutoChess_Main:update()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
end
function PaGlobal_AutoChess_UpdatePerFrame(deltaTime)
  local self = PaGlobal_AutoChess_Main
  if self._phaseTime <= 0 then
    return
  end
  self._phaseTime = self._phaseTime - deltaTime
  self._ui._staticText_PhaseTimer:SetShow(self._phaseTime > 0)
  self._ui._staticText_PhaseTimer:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_TIMER_SECOND", "sec", math.floor(self._phaseTime)))
end
function PaGlobal_FromClient_AutoChessLoadMyDeck(cardKey)
  local self = PaGlobal_AutoChess_Main
  local index = self._deckIndex
  self._deckList[index] = {}
  self._deckList[index]._cardKey = cardKey
  local cardInfo = ToClient_AutoChess_getDeckCardInfo(cardKey)
  if nil == cardInfo then
    return
  end
  local characterKey = cardInfo:getCharacterKey()
  local grade = cardInfo:getGrade()
  self._ui._btn_myCardList[index]:SetShow(true)
  self._ui._btn_myCardList[index]:SetText(tostring(cardKey) .. "( " .. tostring(characterKey:get()) .. ", " .. tostring(grade) .. " )")
  self._ui._btn_myCardList[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_CardSet(" .. index .. ")")
  self._deckIndex = self._deckIndex + 1
end
function PaGlobal_AutoChess_Main:myCardClear()
  for index = 0, self._config._maxCardSize - 1 do
    if nil ~= self._ui._btn_myCardList[index] then
      self._ui._btn_myCardList[index]:SetShow(false)
      self._ui._btn_myCardList[index]:SetText("")
    end
  end
  self._battleCardList = {}
  self._myCardIndex = 0
end
function PaGlobal_AutoChess_Main:targetDeckClear()
  for index = 0, self._config._maxCardSize - 1 do
    if nil ~= self._ui._btn_targetDeckList[index] then
      self._ui._btn_targetDeckList[index]:SetShow(false)
      self._ui._btn_targetDeckList[index]:SetText("")
    end
  end
  self._targetDeckIndex = 0
end
function PaGlobal_AutoChess_Main:validate()
  if nil == Panel_Widnow_AutoChess_Main then
    return
  end
  self._ui._btn_CardTemplete:isValidate()
  self._ui._btn_SummonComplete:isValidate()
  self._ui._btn_CardSetComplete:isValidate()
  self._ui._btn_End:isValidate()
  self._ui._staticText_PhaseTimer:isValidate()
  for index = 0, self._config._maxCardSize - 1 do
    self._ui._btn_myCardList[index]:isValidate()
  end
  for index = 0, self._config._maxCardSize - 1 do
    self._ui._btn_targetDeckList[index]:isValidate()
  end
end
function PaGlobalFunc_FromClient_AutoChessStart()
  local self = PaGlobal_AutoChess_Main
  PaGlobal_AutoChess_Main:prepareOpen()
end
function PaGlobalFunc_FromClient_AutoChessLoadMyDeck(cardKey)
  local self = PaGlobal_AutoChess_Main
  local index = self._deckIndex
  self._deckList[index] = {}
  self._deckList[index]._cardKey = cardKey
  local cardInfo = ToClient_AutoChess_getDeckCardInfo(cardKey)
  if nil == cardInfo then
    return
  end
  local characterKey = cardInfo:getCharacterKey()
  local grade = cardInfo:getGrade()
  self._ui._btn_myCardList[index]:SetShow(true)
  self._ui._btn_myCardList[index]:SetText(tostring(cardKey) .. "( " .. tostring(characterKey:get()) .. ", " .. tostring(grade) .. " )")
  self._ui._btn_myCardList[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_CardSet(" .. index .. ")")
  self._deckIndex = self._deckIndex + 1
end
function PaGlobalFunc_FromClient_AutoChessPhaseTimeSet(seconds)
  local self = PaGlobal_AutoChess_Main
  self._phaseTime = Int64toInt32(seconds)
end
function PaGlobalFunc_FromClient_AutoChessLoadTargetDeck(isClear, cardKey, characterKey)
  local self = PaGlobal_AutoChess_Main
  if true == isClear then
    self:targetDeckClear()
  end
  if nil == self._ui._btn_targetDeckList[self._targetDeckIndex] then
    return
  end
  self._ui._btn_targetDeckList[self._targetDeckIndex]:SetShow(true)
  self._ui._btn_targetDeckList[self._targetDeckIndex]:SetText(tostring(cardKey) .. "( " .. tostring(characterKey) .. " )")
  self._targetDeckIndex = self._targetDeckIndex + 1
end
function PaGlobalFunc_FromClient_AutoChessMyCardSet(isClear, cardKey)
  local self = PaGlobal_AutoChess_Main
  if true == isClear then
    self:myCardClear()
  end
  if nil == self._ui._btn_myCardList[self._myCardIndex] then
    return
  end
  local cardInfo = ToClient_AutoChess_getBattleCardInfo(cardKey)
  if nil == cardInfo then
    return
  end
  local isDead = cardInfo:isDead()
  local characterKey = cardInfo:getCharacterKey()
  local grade = cardInfo:getGrade()
  self._ui._btn_myCardList[self._myCardIndex]:SetShow(true)
  if true == isDead then
    self._ui._btn_myCardList[self._myCardIndex]:SetText(tostring(cardKey) .. "( Dead )")
  else
    self._ui._btn_myCardList[self._myCardIndex]:SetText(tostring(cardKey) .. "( " .. tostring(characterKey:get()) .. ", " .. tostring(grade) .. " )")
  end
  self._ui._btn_myCardList[self._myCardIndex]:addInputEvent("Mouse_LUp", "PaGlobalFunc_AutoChess_Summon(" .. self._myCardIndex .. ")")
  self._battleCardList[self._myCardIndex] = {}
  self._battleCardList[self._myCardIndex]._cardKey = cardKey
  self._battleCardList[self._myCardIndex]._cardInfo = cardInfo
  self._myCardIndex = self._myCardIndex + 1
end
