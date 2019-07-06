PaGlobal_Chatting_FunctionList = {
  _ui = {
    list2_ChattingFunction = nil,
    stc_selectedFunction = nil,
    stc_keyguideBG = nil,
    stc_centerBG = nil,
    stc_selectedFunction = nil,
    txt_famillyName = nil,
    txt_characterName = nil
  },
  _currentFunc = 0,
  _currentFuncCount = 0,
  _CHAT_FUNCTYPE = {
    WHISPER = 1,
    PARTY = 2,
    FRIEND = 3,
    BLOCK = 4,
    BLOCKLIST = 5
  },
  _chatFunc = {},
  _defaultPanelSize = 0,
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Chatting/Console/Panel_Window_Chatting_FunctionList_1.lua")
runLua("UI_Data/Script/Widget/Chatting/Console/Panel_Window_Chatting_FunctionList_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Chatting_FunctionListInit")
function FromClient_Chatting_FunctionListInit()
  PaGlobal_Chatting_FunctionList:initialize()
end
