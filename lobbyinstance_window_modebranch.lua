PaGlobal_ModeBranch = {
  _ui = {
    _stc_BranchMiddleGroup = UI.getChildControl(LobbyInstance_Window_ModeBranch, "Static_ModeBranchMiddleGroup"),
    _txt_branchDesc = UI.getChildControl(LobbyInstance_Window_ModeBranch, "MultilineText_BranchDesc"),
    _btn_close = UI.getChildControl(LobbyInstance_Window_ModeBranch, "Button_Close"),
    _stcModeBg = {},
    _radiobtn = {},
    _stcLockbtn = {},
    _txtLockdesc = {}
  },
  _initialize = false,
  _selectedModeBranch = nil,
  _selectedModeType = 0,
  _originalPanelSizeY = 700,
  _originalPanelPosY = 150,
  _currentBranchCount = 3,
  _selectedMode = nil,
  _selectedBettingKey = nil,
  _modeDesc = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_MODEBRANCH_BETTINGKEY0_DESC"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_MODEBRANCH_BETTINGKEY1_DESC"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_MODEBRANCH_BETTINGKEY2_DESC")
  },
  _limitTier = {
    [1] = 25,
    [2] = 20,
    [3] = 15
  }
}
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_ModeBranch_1.lua")
runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_ModeBranch_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ModeBranch_Init")
function FromClient_ModeBranch_Init()
  PaGlobal_ModeBranch:initialize()
end
