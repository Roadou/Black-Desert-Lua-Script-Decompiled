PaGlobal_Chatting_BlockList = {
  _ui = {list2_blockedUser = nil},
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Widget/Chatting/Console/Panel_Window_Chatting_BlockList_1.lua")
runLua("UI_Data/Script/Widget/Chatting/Console/Panel_Window_Chatting_BlockList_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_Chatting_BlockListInit")
function FromClient_Chatting_BlockListInit()
  PaGlobal_Chatting_BlockList:initialize()
end
