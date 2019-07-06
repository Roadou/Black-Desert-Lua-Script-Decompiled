PaGlobal_Anchor = {
  _eSelectButtonType = {sailor = 0, barter = 1},
  _ui = {_btn_anchor = nil, _btn_barter = nil},
  _actorKey = nil,
  _regionKey = RegionKey(0),
  _initialize = false
}
runLua("UI_Data/Script/Window/Anchor/Panel_Window_Anchor_1.lua")
runLua("UI_Data/Script/Window/Anchor/Panel_Window_Anchor_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_AnchorInit")
function FromClient_AnchorInit()
  PaGlobal_Anchor:initialize()
end
