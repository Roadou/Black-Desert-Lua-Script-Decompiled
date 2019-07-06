PaGlobal_MarKetPlace_BuyProductInCashShop = {
  _ui = {
    _btn_close = nil,
    _txt_guide = nil,
    _list_products = {}
  },
  _itemKey = nil,
  _productCount = 0,
  _productNoList = {},
  _productUiList = {},
  _initialize = false,
  _tagTexture = {
    [0] = {
      0,
      0,
      0,
      0
    },
    {
      4,
      3,
      238,
      67
    },
    {
      4,
      70,
      238,
      134
    },
    {
      278,
      246,
      512,
      310
    },
    {
      4,
      204,
      238,
      268
    },
    {
      274,
      443,
      508,
      507
    },
    {
      4,
      137,
      238,
      201
    }
  }
}
runLua("UI_Data/Script/Window/MarketPlace/Panel_Window_MarketPlace_BuyProductInCashShop_1.lua")
runLua("UI_Data/Script/Window/MarketPlace/Panel_Window_MarketPlace_BuyProductInCashShop_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_MarketPlace_BuyProductInCashShopInit")
function FromClient_MarketPlace_BuyProductInCashShopInit()
  PaGlobal_MarKetPlace_BuyProductInCashShop:initialize()
end
