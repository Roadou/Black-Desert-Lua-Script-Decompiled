PaGlobal_AutoChess_Main = {
  _ui = {
    _btn_myCardList = {},
    _btn_targetDeckList = {},
    _btn_CardTemplete = nil,
    _btn_SummonComplete = nil,
    _btn_CardSetComplete = nil,
    _btn_End = nil,
    _staticText_PhaseTimer = nil
  },
  _config = {_maxCardSize = 30},
  _phaseTime = 0,
  _deckList = {},
  _battleCardList = {},
  _deckIndex = 0,
  _myCardIndex = 0,
  _targetDeckIndex = 0,
  _initialize = false
}
runLua("UI_Data/Script/Window/AutoChess/Panel_Window_AutoChess_Main_1.lua")
runLua("UI_Data/Script/Window/AutoChess/Panel_Window_AutoChess_Main_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_AutoChess_Main_Init")
function FromClient_AutoChess_Main_Init()
  PaGlobal_AutoChess_Main:initialize()
end
