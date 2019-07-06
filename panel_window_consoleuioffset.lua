ConsoleUIOffset = {
  _ui = {
    stc_BottomBg = UI.getChildControl(Panel_Window_ConsoleUIOffset, "Static_BottomBg"),
    _squareTable = {},
    _currentSquareTable = {},
    stc_informationDesc = nil,
    txt_keyGuideRS = nil,
    txt_keyGuideY = nil,
    txt_keyGuideB = nil
  },
  _squareSizeTable = {},
  _MAX_SQUREOUNT = 4,
  _scrollSpeed = 0.2,
  _minOffset = 0,
  _maxOffset = 0.07,
  _currentOffset = 0
}
runLua("UI_Data/Script/Window/UI_Setting/Console/Panel_Window_ConsoleUIOffset_1.lua")
runLua("UI_Data/Script/Window/UI_Setting/Console/Panel_Window_ConsoleUIOffset_2.lua")
function PaGlobal_ConsoleUIOffset_Init()
  ConsoleUIOffset:init()
end
if nil == Panel_Login_Renew then
  registerEvent("FromClient_luaLoadComplete", "PaGlobal_ConsoleUIOffset_Init")
end
