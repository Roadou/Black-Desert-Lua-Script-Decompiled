local RAT_VIEW = 0
local isDevelopment = ToClient_IsDevelopment()
local RecommendEngine = {
  _clearTime = 0,
  _clickCashProductList = {}
}
function PaGlobal_RecommendEngine_CashVeiw(CashProductNo, bValue)
  local isFirstClick = RecommendEngine:checkCashProduct(CashProductNo)
  if true == isFirstClick then
    ToClient_sendRecommendInfoCashShop(RAT_VIEW, CashProductNo, bValue)
  end
end
function PaGlobal_RecommendEngine_ItemMarketVeiw(ItemEnchantKey)
end
function RecommendEngine:checkCashProduct(CashProductNo)
  local currentTime = os.time()
  if currentTime - self._clearTime < 300 then
    self._clickCashProductList = {}
    self._clearTime = currentTime
  end
  for key, value in pairs(self._clickCashProductList) do
    if key == CashProductNo then
      return false
    end
  end
  self._clickCashProductList[CashProductNo] = 0
  return true
end
