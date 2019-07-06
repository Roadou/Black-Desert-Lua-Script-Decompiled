PaGlobal_Barter = {
  _ui = {
    normal = {},
    special = {}
  },
  _eSelectType = {normal = 0, special = 1},
  _eTooltipType = {
    myNormal = 0,
    npcNormal = 1,
    mySpecial = 2,
    npcSpecial = 3
  },
  _slot = {},
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true
  },
  _selectType = 0,
  _cacheEnchantKey = {},
  _actorKey = nil,
  _regionKey = RegionKey(0),
  _itemWhereType = nil,
  _myItemCount = -1,
  _REPOS_SPANSIZE = 40,
  _isConsole = false,
  _initialize = false
}
runLua("UI_Data/Script/Window/Exchange/Panel_Window_Barter_1.lua")
runLua("UI_Data/Script/Window/Exchange/Panel_Window_Barter_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_BarterInit")
function FromClient_BarterInit()
  PaGlobal_Barter:initialize()
end
