local _panel = Panel_TradeMarket_BiddingGame
local FIXED_DEGREE = 30
local enTradeGameSwitchType = {enTradeGameSwitchType_Small = 0, enTradeGameSwitchType_Large = 1}
local enTradeGameState = {enTradeGameState_Play = 1, enTradeGameState_Finish = 2}
local enTradeGameResult = {
  enTradeGameResult_Less = 0,
  enTradeGameResult_More = 1,
  enTradeGameResult_Correct = 2,
  enTradeGameResult_NoTryCount = 3,
  enTradeGameResult_None
}
local BiddingGame = {
  _ui = {
    stc_MainBg = UI.getChildControl(_panel, "Static_MainBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBG")
  },
  _isLowDiceClicked = false,
  _isTradeGameEnd = false,
  _tradeGameSuccess = false,
  _tradeGameState = enTradeGameState.enTradeGameState_Finish,
  _currentDiceValue = 0,
  _minGoalValue = 0,
  _maxGoalValue = 0,
  _tryCount = 0,
  _prevDiceResult = 0,
  _updownValue = -1,
  _isRotateSwitch = false,
  _halfSizeX = 0,
  _leftStartPosX = 0,
  _leftStartPosY = 0,
  _rightStartPosX = 0,
  _rightStartPosY = 0,
  _centerPosX = 0,
  _centerPosY = 0,
  _startRadian = 0,
  _elapsedAngle = 0,
  _deltaTimeElapsed = 0,
  _applyRotateValue = 0
}
function BiddingGame:init()
  self._ui.stc_PlatePoll = UI.getChildControl(self._ui.stc_MainBg, "Static_ScaleBalance_Poll")
  self._ui.stc_PlateArm = UI.getChildControl(self._ui.stc_MainBg, "Static_ScaleBalance_Arm")
  self._ui.stc_PlateLeft = UI.getChildControl(self._ui.stc_MainBg, "Static_ScaleBalance_Plate_Left")
  self._ui.stc_PlateRight = UI.getChildControl(self._ui.stc_MainBg, "Static_ScaleBalance_Plate_Right")
  self._ui.txt_ProcessMsg = UI.getChildControl(self._ui.stc_MainBg, "StaticText_ProcessMsg")
  self._ui.txt_RemainCount = UI.getChildControl(self._ui.stc_MainBg, "StaticText_RemainCount")
  self._ui.btn_LowDice = UI.getChildControl(self._ui.stc_MainBg, "Button_TradeGame_LowDice")
  self._ui.btn_HighDice = UI.getChildControl(self._ui.stc_MainBg, "Button_TradeGame_HighDice")
  self._ui.txt_LowDiceDesc = UI.getChildControl(self._ui.btn_LowDice, "StaticText_Desc")
  self._ui.txt_HighDiceDesc = UI.getChildControl(self._ui.btn_HighDice, "StaticText_Desc")
  self._ui.txt_AConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_BConsole = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  local keyGuides = {
    self._ui.txt_AConsole,
    self._ui.txt_BConsole
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.txt_LowDiceDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_LowDiceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_WARNNING_BARGAIN"))
  self._ui.txt_HighDiceDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_HighDiceDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_STRONG_BARGAIN"))
  self._halfSizeX = self._ui.stc_PlateRight:GetSizeX() / 2
  self._leftStartPosX = self._ui.stc_PlateLeft:GetPosX() + self._halfSizeX
  self._leftStartPosY = self._ui.stc_PlateLeft:GetPosY()
  self._rightStartPosX = self._ui.stc_PlateRight:GetPosX() + self._halfSizeX
  self._rightStartPosY = self._ui.stc_PlateRight:GetPosY()
  self._centerPosX = self._ui.stc_PlateArm:GetPosX() + self._ui.stc_PlateArm:GetSizeX() / 2
  self._centerPosY = self._ui.stc_PlateArm:GetPosY() + self._ui.stc_PlateArm:GetSizeY() / 2
  self:registEvent()
  PaGlobal_BiddingGame_OnScreenResize()
end
function BiddingGame:registEvent()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_BiddingGame_PressHighDice()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_BiddingGame_PressLowDice()")
  _panel:ignorePadSnapMoveToOtherPanel()
  registerEvent("FromClient_TradeGameStart", "PaGlobal_BiddingGame_StartGame")
  registerEvent("FromClient_TradeGameResult", "PaGlobal_BiddingGame_GameResult")
  registerEvent("FromClient_TradeGameReciveDice", "PaGlobal_BiddingGame_RecieveDice")
  registerEvent("onScreenResize", "PaGlobal_BiddingGame_OnScreenResize")
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function BiddingGame:resetTradeGameInfo()
  self._currentDiceValue = 0
  self._minGoalValue = 0
  self._maxGoalValue = 0
  self._updownValue = 1
  self._deltaTimeElapsed = 0
  self._ui.stc_PlateArm:SetRotate(0)
  self._isRotateSwitch = false
  self._tradeGameState = enTradeGameState.enTradeGameState_Finish
  self._prevDiceResult = enTradeGameResult.enTradeGameResult_Less
end
function BiddingGame:open()
  _panel:SetShow(true)
end
function BiddingGame:close()
  SetUIMode(Defines.UIMode.eUIMode_Trade)
  _panel:SetShow(false)
end
function BiddingGame:moveControl(rateDeltaTime)
  self._ui.stc_PlateArm:SetRotate(rateDeltaTime)
  self:rotatePlate(self._ui.stc_PlateRight, self._rightStartPosX, self._rightStartPosY, self._centerPosX, self._centerPosY, rateDeltaTime)
  self:rotatePlate(self._ui.stc_PlateLeft, self._leftStartPosX, self._leftStartPosY, self._centerPosX, self._centerPosY, rateDeltaTime)
end
function BiddingGame:rotatePlate(scaleControl, startPosX, startPosY, rotCenterPosX, rotCenterPosY, elpasedDeltaTime)
  local rotPosX = startPosX - rotCenterPosX
  local rotPosY = startPosY - rotCenterPosY
  local controlPosX = rotPosX * math.cos(elpasedDeltaTime) - rotPosY * math.sin(elpasedDeltaTime)
  local controlPosY = rotPosX * math.sin(elpasedDeltaTime) + rotPosY * math.cos(elpasedDeltaTime)
  scaleControl:SetPosX(controlPosX + rotCenterPosX - self._halfSizeX)
  scaleControl:SetPosY(controlPosY + rotCenterPosY)
end
function PaGlobal_BiddingGame_Close()
  local self = BiddingGame
  self:close()
end
function PaGlobal_BiddingGame_Init()
  local self = BiddingGame
  self:init()
end
function PaGlobal_BiddingGame_ResetSuccess()
  local self = BiddingGame
  self._tradeGameSuccess = false
end
function PaGlobal_BiddingGame_GetSuccess()
  local self = BiddingGame
  return self._tradeGameSuccess
end
function global_Update_TradeGame(deltaTime)
  local self = BiddingGame
  if true == self._isRotateSwitch then
    self._deltaTimeElapsed = self._deltaTimeElapsed + deltaTime * self._updownValue
    local tempApplyAngle = self._startRadian + self._deltaTimeElapsed
    if 1 == self._updownValue then
      if tempApplyAngle > self._applyRotateValue then
        self._isRotateSwitch = false
      end
    elseif tempApplyAngle < self._applyRotateValue then
      self._isRotateSwitch = false
    end
    self:moveControl(tempApplyAngle)
  end
end
function PaGlobal_BiddingGame_StartGame(minGoal, maxGoal, tryCount, startDice)
  local self = BiddingGame
  SetUIMode(Defines.UIMode.eUIMode_TradeGame)
  self:resetTradeGameInfo()
  self._tradeGameSuccess = false
  self._isTradeGameEnd = false
  self._isLowDiceClicked = nil
  self._currentDiceValue = startDice
  self._minGoalValue = minGoal
  self._maxGoalValue = maxGoal
  self._tryCount = tryCount
  self._tradeGameState = enTradeGameState.enTradeGameState_Play
  self._ui.stc_PlatePoll:EraseAllEffect()
  self._ui.stc_PlateArm:EraseAllEffect()
  self._ui.txt_ProcessMsg:EraseAllEffect()
  self._ui.txt_ProcessMsg:SetShow(true)
  self._ui.txt_ProcessMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_PROCESSMSG"))
  self._ui.txt_RemainCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEGAME_REMAINCOUNT", "tryCount", self._tryCount))
  self._ui.txt_AConsole:SetShow(false)
  if startDice > 0 then
    self._prevDiceResult = enTradeGameResult.enTradeGameResult_More
  else
    self._prevDiceResult = enTradeGameResult.enTradeGameResult_Less
  end
  local startDegree = -30
  startDegree = FIXED_DEGREE * startDice / 100
  self._startRadian = startDegree * math.pi / 180
  self._elapsedAngle = startDegree
  self:moveControl(self._startRadian)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  self:open()
end
function PaGlobal_BiddingGame_RecieveDice(diceValue, gameResult)
  local self = BiddingGame
  if enTradeGameResult.enTradeGameResult_NoTryCount == gameResult or enTradeGameResult.enTradeGameResult_None == gameResult then
    self._tradeGameState = enTradeGameState.enTradeGameState_Finish
    return
  end
  if enTradeGameState.enTradeGameState_Play ~= self._tradeGameState then
    return
  end
  self._tryCount = self._tryCount - 1
  self._ui.txt_RemainCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEGAME_REMAINCOUNT", "tryCount", self._tryCount))
  if enTradeGameResult.enTradeGameResult_Less == self._prevDiceResult then
    self._updownValue = 1
    self._isRotateSwitch = true
  end
  if enTradeGameResult.enTradeGameResult_More == self._prevDiceResult then
    self._updownValue = -1
    self._isRotateSwitch = true
  end
  self._prevDiceResult = gameResult
  self._elapsedAngle = self._elapsedAngle + diceValue / 100 * FIXED_DEGREE * self._updownValue
  self._applyRotateValue = self._elapsedAngle * math.pi / 180
  self._currentDiceValue = self._currentDiceValue + diceValue * self._updownValue
  local processText = ""
  if true == self._isLowDiceClicked then
    if self._currentDiceValue > -10 and self._currentDiceValue < 10 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_1")
    elseif self._currentDiceValue > -20 and self._currentDiceValue < 20 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_2")
    elseif self._currentDiceValue > -30 and self._currentDiceValue < 30 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_3")
    elseif self._currentDiceValue > -40 and self._currentDiceValue < 40 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_4")
    elseif self._currentDiceValue > -50 and self._currentDiceValue < 50 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_5")
    elseif self._currentDiceValue > -60 and self._currentDiceValue < 60 then
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICELOWVALUE_6")
    else
      processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST")
    end
  elseif self._currentDiceValue > -10 and self._currentDiceValue < 10 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_1")
  elseif self._currentDiceValue > -20 and self._currentDiceValue < 20 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_2")
  elseif self._currentDiceValue > -30 and self._currentDiceValue < 30 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_3")
  elseif self._currentDiceValue > -40 and self._currentDiceValue < 40 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_4")
  elseif self._currentDiceValue > -50 and self._currentDiceValue < 50 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_5")
  elseif self._currentDiceValue > -60 and self._currentDiceValue < 60 then
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_DICEHIGHVALUE_6")
  else
    processText = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_NOINTEREST")
  end
  self._ui.txt_ProcessMsg:SetText(processText)
end
function PaGlobal_BiddingGame_GameResult(isSuccess)
  local self = BiddingGame
  self._tradeGameState = enTradeGameState.enTradeGameState_Finish
  self._ui.txt_AConsole:SetShow(true)
  if true == isSuccess then
    _AudioPostEvent_SystemUiForXBOX(11, 8)
    self._ui.txt_ProcessMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_RESULT_MSG_SUCCESS"))
    self._tradeGameSuccess = true
    self._ui.txt_AConsole:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEGAME_ALLSELL"))
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_BiddingGame_SellAllButton()")
    PaGlobal_TradeMarketGoods_Update()
    self._ui.stc_PlatePoll:AddEffect("fUI_TradeGame_BackgroundLight", true, 0, 0)
    self._ui.stc_PlateArm:AddEffect("fUI_TradeGame_EmeraldLight", true, 0, 0)
  else
    _AudioPostEvent_SystemUiForXBOX(11, 9)
    self._ui.txt_ProcessMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEGAME_RESULT_MSG_FAIL"))
    self._tradeGameSuccess = false
    self._ui.txt_AConsole:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TRADEGAME_RETRY"))
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_BiddingGame_RestartButton()")
    self._ui.stc_PlateArm:AddEffect("fUI_TradeGame_EmeraldLight_Failed", false, 0, 0)
  end
  self._isTradeGameEnd = true
end
function PaGlobal_BiddingGame_SellAllButton()
  PaGlobal_TradeMarketGoods_SellAllItem()
end
function PaGlobal_BiddingGame_RestartButton()
  local talker = dialog_getTalker()
  if nil == talker then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:get():getInventorySlotCount(true)
  local inventory = selfPlayer:get():getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenMaxSize = inventory:sizeXXX()
  local freeCount = inventory:getFreeCount()
  if invenUseSize - useStartSlot <= invenUseSize - freeCount - useStartSlot then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_SELLLIST_DONTPLAYGAME"))
    return
  end
  local wp = selfPlayer:getWp()
  if 0 >= PaGlobal_TradeMarketGoods_GetSellCount() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_2")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if wp < 5 then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_3")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local function tradeGameRestartGo()
    ToClient_TradeGameStart(talker:getActorKey())
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_4") .. " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_NOWWP", "getWp", wp)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_TRADEGAME_MSG_1"),
    content = messageBoxMemo,
    functionYes = tradeGameRestartGo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function rotateBalances(scaleControl, startPosX, startPosY, rotCenterPosX, rotCenterPosY, elpasedDeltaTime)
  local rotPosX = startPosX - rotCenterPosX
  local rotPosY = startPosY - rotCenterPosY
  local controlPosX = rotPosX * math.cos(elpasedDeltaTime) - rotPosY * math.sin(elpasedDeltaTime)
  local controlPosY = rotPosX * math.sin(elpasedDeltaTime) + rotPosY * math.cos(elpasedDeltaTime)
  scaleControl:SetPosX(controlPosX + rotCenterPosX - halfSizeX)
  scaleControl:SetPosY(controlPosY + rotCenterPosY)
end
function move_TradeGameControl(rateDeltaTime)
  balanceArm:SetRotate(rateDeltaTime)
  rotateBalances(balancePlateRight, rightStartPosX, rightStartPosY, centerPosX, centerPosY, rateDeltaTime)
  rotateBalances(balancePlateLeft, leftStartPosX, leftStartPosY, centerPosX, centerPosY, rateDeltaTime)
end
function PaGlobal_BiddingGame_PressLowDice()
  local self = BiddingGame
  if enTradeGameState.enTradeGameState_Play ~= self._tradeGameState then
    return
  end
  self._isLowDiceClicked = true
  ToClient_TradeGameDice(enTradeGameSwitchType.enTradeGameSwitchType_Small)
end
function PaGlobal_BiddingGame_PressHighDice()
  local self = BiddingGame
  if enTradeGameState.enTradeGameState_Play ~= self._tradeGameState then
    return
  end
  self._isLowDiceClicked = false
  ToClient_TradeGameDice(enTradeGameSwitchType.enTradeGameSwitchType_Large)
end
function PaGlobal_BiddingGame_OnScreenResize()
  local self = BiddingGame
  _panel:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_BiddingGame_Init")
