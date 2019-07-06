PaGlobal_UnknownShop = {
  _ui = {
    stc_slotBG = nil,
    txt_itemName = nil,
    txt_moneyValue = nil,
    txt_reserveTime = nil,
    stc_showAni = nil,
    stc_keyGuideDetail = nil,
    stc_keyGuideReselect = nil,
    stc_keyGuideReserve = nil,
    stc_keyGuidePurchase = nil,
    stc_keyGuideClose = nil
  },
  _shopTypeNo = nil,
  _shopSlotNo = nil,
  _shopItemPrice = nil,
  _priceRate = nil,
  _isReserveContentOpen = ToClient_IsContentsGroupOpen("1023"),
  _keyGuideAlign = {},
  _initialize = false
}
runLua("UI_Data/Script/Window/Worldmap/UnKnowItemSelect/Console/Panel_Window_UnknownShop_1.lua")
runLua("UI_Data/Script/Window/Worldmap/UnKnowItemSelect/Console/Panel_Window_UnknownShop_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_UnknownShopInit")
function FromClient_UnknownShopInit()
  PaGlobal_UnknownShop:initialize()
end
