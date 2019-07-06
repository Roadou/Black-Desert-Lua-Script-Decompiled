ItemMarketTestCaseEnum = {
  eBuy = 1,
  eSell = 2,
  eSellCancel = 3
}
local itemMarketSupport = {
  testPreset = {
    _state = 0,
    _testCase,
    _trId,
    _param1,
    _param2,
    _param3,
    _param4,
    _param5,
    _expectedResult,
    _realResult,
    _finalResult,
    _detailReason
  },
  testList = {},
  testFunc = {},
  prepareFunc = {},
  testCaseToStirng = {},
  currentIndex = 0,
  timeStamp = 0,
  intervalStamp = 0,
  selectItemCount = 0,
  selectItemKey = 0,
  selectItemLevel = 0,
  isMinPrice = false
}
PaGlobal_QAItemMarketSupportOn = false
PaGlobal_QAItemMarketFunctionFlag = false
local TestCount = 0
function PaGlobalFunc_ResetItemMarketTestList()
  itemMarketSupport.intervalStamp = 0
  itemMarketSupport.testList = {}
  _PA_LOG("ItemMarketQA", " [" .. TestCount .. "] ------------------------------------------------------------------------------------------")
  TestCount = TestCount + 1
  ToClient_requestMyWalletList()
end
function PaGlobalFunc_InsertItemMarketTestCase(eTestCase, expectedResult, param1, param2, param3, param4, param5)
  local testPreset = {
    _testCase = eTestCase,
    _state = 0,
    _param1 = param1,
    _param2 = param2,
    _param3 = param3,
    _param4 = param4,
    _param5 = param5,
    _expectedResult = expectedResult
  }
  table.insert(itemMarketSupport.testList, testPreset)
end
function PaGlobalFunc_DoItemMarketTest()
  itemMarketSupport.timeStamp = 0
  local currentTest = itemMarketSupport.testList[itemMarketSupport.currentIndex]
  currentTest._state = 1
  if not currentTest._isPrepare then
    local testFunc = itemMarketSupport.testFunc[currentTest._testCase]
    if nil == testFunc then
      return
    end
    local rv = testFunc(currentTest._param1, currentTest._param2, currentTest._param3, currentTest._param4, currentTest._param5)
    if 0 ~= rv then
      PaGlobalFunc_ItemMarketTest_SetState(false, "Client", rv)
    end
  else
    local testFunc = itemMarketSupport.prepareFunc[currentTest._testCase]
    if nil ~= testFunc then
      if nil ~= currentTest._param1 then
        testFunc(currentTest._param1, currentTest._param2, currentTest._param3, currentTest._param4, currentTest._param5)
      else
        testFunc()
      end
    end
  end
end
function PaGlobalFunc_GetItemMarketBriefSpec(testCase, param1)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return ""
  end
  return ""
end
function PaGlobalFunc_GetItemMarketSpec(index, testCase, param1, isPrev)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return ""
  end
  return ""
end
function PaGlobalFunc_ItemMarketTest_SetState(isSuccess, location, reason)
  local currentTest = itemMarketSupport.testList[itemMarketSupport.currentIndex]
  currentTest._state = 2
  currentTest._realResult = isSuccess
  currentTest._finalResult = isSuccess == currentTest._expectedResult
  if false == isSuccess then
    currentTest._detailReason = reason
  end
end
function PaGlobalFunc_ItemMarketTest_CheckState()
  local currentIndex = 1
  for index, content in pairs(itemMarketSupport.testList) do
    if 0 == content._state then
      itemMarketSupport.currentIndex = currentIndex
      PaGlobalFunc_DoItemMarketTest()
      return
    elseif 1 == content._state then
      return
    end
    currentIndex = currentIndex + 1
  end
  if currentIndex >= table.getn(itemMarketSupport.testList) and false == PaGlobal_QAItemMarketFunctionFlag then
    FinishItemMarketQA()
  end
end
function PaGlobalFunc_ItemMarketTest_UpdatePerFrameFunc(deltaTime)
  itemMarketSupport.intervalStamp = itemMarketSupport.intervalStamp + deltaTime
  if itemMarketSupport.intervalStamp < 0.5 then
    return
  end
  itemMarketSupport.timeStamp = itemMarketSupport.timeStamp + itemMarketSupport.intervalStamp
  itemMarketSupport.intervalStamp = 0
  if itemMarketSupport.timeStamp > 5 then
    PaGlobalFunc_ItemMarketTest_SetState(true)
  end
  PaGlobalFunc_ItemMarketTest_CheckState()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ItemMarketQASupport_LuaLoadComplete")
function PaGlobalFunc_GetNakMessageItemMarketForQA(TrID, reason, AddNo)
  if false == PaGlobal_QAItemMarketSupportOn then
    return
  end
  _PA_LOG("itemMarketQA", "itemMarketSupport.currentIndex" .. " " .. tostring(itemMarketSupport.currentIndex))
  local currentTest = itemMarketSupport.testList[itemMarketSupport.currentIndex]
  if nil ~= currentTest then
    currentTest._itemMarketDetail = PaGlobalFunc_GetItemMarketSpec(itemMarketSupport.currentIndex, currentTest._testCase, currentTest._param1)
  end
  PaGlobalFunc_ItemMarketTest_SetState(false, "Server", reason)
end
function PaGlobalFunc_GetNakMessageItemMarketDetailForQA(message, type, isSuccess)
  if false == PaGlobal_QAItemMarketSupportOn then
    return
  end
  _PA_LOG("itemMarketQA", "itemMarketSupport.currentIndex" .. " " .. tostring(itemMarketSupport.currentIndex))
  local currentTest = itemMarketSupport.testList[itemMarketSupport.currentIndex]
  if nil ~= currentTest then
    currentTest._itemMarketMessage = message
    currentTest._itemMarketType = itemMarketSupport:getHistoryName(type)
  end
  if false == isSuccess then
    PaGlobal_QAItemMarketSupportOn = false
  end
end
function PaGlobalFunc_ItemMarketQASupport_LuaLoadComplete()
  itemMarketSupport:init()
end
function itemMarketSupport:init()
  registerEvent("FromClient_GetNakMessageForQA", "PaGlobalFunc_GetNakMessageItemMarketForQA")
  registerEvent("FromClient_GetNakMessageItemMarketForQA", "PaGlobalFunc_GetNakMessageItemMarketDetailForQA")
  registerEvent("FromClient_responseDetailListByWorldMarketByItemKey", "PaGlobalFunc_responseWorldMarketItemMarketTest")
  itemMarketSupport.testFunc[ItemMarketTestCaseEnum.eBuy] = PaGlobalFunc_ItemMarketBuyTest
  itemMarketSupport.testFunc[ItemMarketTestCaseEnum.eSell] = PaGlobalFunc_ItemMarketSellTest
  itemMarketSupport.testCaseToStirng[ItemMarketTestCaseEnum.eBuy] = "\234\181\172\235\167\164"
  itemMarketSupport.testCaseToStirng[ItemMarketTestCaseEnum.eSell] = "\237\140\144\235\167\164"
end
function PrepareItemMarketQA()
  itemMarketSupport:prepareTest()
end
function itemMarketSupport:prepareTest()
  PaGlobal_QAItemMarketSupportOn = true
end
function FinishItemMarketQA()
  itemMarketSupport:endTest()
end
function itemMarketSupport:endTest()
  PaGlobal_QAItemMarketSupportOn = false
  ToClient_QAsupportFileOpen(PaGlobal_QAoutputDir .. "itemMarketTestResult" .. "_" .. TestCount .. ".txt")
  ToClient_QAsupportFileWrite("<\237\133\140\236\138\164\237\138\184\235\178\136\237\152\184>\t[\237\133\140\236\138\164\237\138\184\237\149\173\235\170\169]\t[\236\181\156\236\162\133\234\178\176\234\179\188]\t[\234\184\176\235\140\128\234\178\176\234\179\188]\t[\236\139\164\236\160\156\234\178\176\234\179\188]\t<\237\133\140\236\138\164\237\138\184\235\178\136\237\152\184>\t[\236\131\129\237\153\169]\t[\236\131\129\236\132\184 \236\132\164\235\170\133]\n")
  for index, content in pairs(itemMarketSupport.testList) do
    if not content._isPrepare then
      local logstr = index .. "\t" .. tostring(itemMarketSupport.testCaseToStirng[content._testCase]) .. "\t" .. self:getResultString(content._finalResult) .. "\t" .. tostring(content._expectedResult) .. "\t" .. tostring(content._realResult) .. "\t" .. tostring(content._itemMarketType) .. "\t" .. tostring(content._itemMarketMessage) .. "\n"
      if false == content._realResult then
        local failstr = "\t" .. PAGetStringSymNo(content._detailReason) .. "\n"
        logstr = logstr .. failstr
      else
        logstr = logstr .. "\n"
      end
      _PA_LOG("ItemMarketQA", logstr)
      ToClient_QAsupportFileWrite(logstr)
    end
  end
  ToClient_QAsupportFileClose()
end
function itemMarketSupport:getResultString(result)
  if true == result then
    return "PASS"
  end
  return "FAIL"
end
function itemMarketSupport:getHistoryName(historyType)
  if historyType == __eWorldMarket_HistoryType_Buy then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \234\181\172\235\167\164"
  elseif historyType == __eWorldMarket_HistoryType_BuyBidding then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \234\181\172\235\167\164 \236\152\136\236\149\189"
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingFail then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \234\181\172\235\167\164 \236\152\136\236\149\189 \236\139\164\237\140\168"
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingCal then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \234\181\172\235\167\164 \236\152\136\236\149\189 \236\160\149\236\130\176"
  elseif historyType == __eWorldMarket_HistoryType_BuyBiddingWithdraw then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \234\181\172\235\167\164 \236\152\136\236\149\189 \236\183\168\236\134\140"
  elseif historyType == __eWorldMarket_HistoryType_Sell then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \237\140\144\235\167\164"
  elseif historyType == __eWorldMarket_HistoryType_SellBidding then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \237\140\144\235\167\164 \236\152\136\236\149\189"
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingFail then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \237\140\144\235\167\164 \236\152\136\236\149\189 \236\160\149\236\130\176"
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingCal then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \237\140\144\235\167\164 \236\152\136\236\149\189 \236\183\168\236\134\140"
  elseif historyType == __eWorldMarket_HistoryType_SellBiddingWithdarw then
    return "\237\134\181\237\149\169 \234\177\176\235\158\152\236\134\140 \237\158\136\236\138\164\237\134\160\235\166\172"
  elseif historyType == __eWorldMarket_HistoryType_Count then
    return "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \234\176\146\236\158\133\235\139\136\235\139\164."
  else
    return "\235\147\177\235\161\157\235\144\152\236\167\128 \236\149\138\236\157\128 \234\176\146\236\158\133\235\139\136\235\139\164."
  end
end
function PaGlobalFunc_ItemMarketTestEnd()
  PaGlobal_QAItemMarketFunctionFlag = false
  PaGlobalFunc_ItemMarketTest_SetState(true)
end
function PaGlobalFunc_ItemMarketBuyTest(itemKey, itemLevel, count, isMin)
  ToClient_requestDetailListByWorldMarketByItemKey(itemKey)
  PaGlobal_QAItemMarketFunctionFlag = true
  itemMarketSupport.selectItemKey = itemKey
  itemMarketSupport.selectItemLevel = itemLevel
  itemMarketSupport.selectItemCount = count
  itemMarketSupport.isMinPrice = isMin
end
function PaGlobalFunc_responseWorldMarketItemMarketTest()
  if false == PaGlobal_QAItemMarketSupportOn then
    return
  end
  local selectLevel = itemMarketSupport.selectItemLevel
  for ii = 0, 20 do
    local itemInfo = getWorldMarketDetailListByIdx(ii)
    if nil ~= itemInfo then
      local maxEnchantLevel = itemInfo:getEnchantMaxLevel()
      local minEnchantLevel = itemInfo:getEnchantMinLevel()
      if minEnchantLevel <= itemMarketSupport.selectItemLevel and maxEnchantLevel <= itemMarketSupport.selectItemLevel then
        selectLevel = minEnchantLevel
        break
      end
    end
  end
  local enchantItemKey = ItemEnchantKey(itemMarketSupport.selectItemKey, selectLevel)
  ToClient_requestGetBiddingList(enchantItemKey, true, PaGlobalFunc_ItemMarket_isHotCategory())
end
function PaGlobalFunc_ItemMarketBuyTestDetail(itemKey, minEnchantLevel, maxEnchantLevel, standardPrice_s64, itemCount_s64, biddingBuyListCount)
  if false == PaGlobal_QAItemMarketSupportOn or 0 == itemMarketSupport.selectItemCount then
    return
  end
  local priceIndex = 0
  local sellCount = 0
  if true == itemMarketSupport.isMinPrice then
    priceIndex = 0
    for ii = priceIndex, biddingBuyListCount - 1 do
      local biddingInfo = ToClient_GetBiddingInfoByIndex(ii)
      sellCount = Int64toInt32(biddingInfo:getSellCount())
      if sellCount > 0 then
        priceIndex = ii
        break
      end
    end
  else
    priceIndex = biddingBuyListCount - 1
    for ii = biddingBuyListCount - 1, 0, -1 do
      local biddingInfo = ToClient_GetBiddingInfoByIndex(ii)
      sellCount = Int64toInt32(biddingInfo:getSellCount())
      if sellCount > 0 then
        priceIndex = ii
        break
      end
    end
  end
  local price_s64 = ToClient_getWorldMarketBuyBiddingLstPrice(priceIndex)
  ToClient_requestBuyItemToWorldMarket(itemKey, minEnchantLevel, itemMarketSupport.selectItemCount, price_s64, itemMarketSupport.selectItemLevel)
  itemMarketSupport.selectItemCount = 0
end
function PaGlobalFunc_ItemMarketSellTest(slotIndex, count, isMin)
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotIndex)
  if nil ~= itemMyWalletInfo then
    ToClient_requestDetailOneItemByWorldMarket(itemMyWalletInfo:getEnchantKey(), itemMyWalletInfo:isSealed())
    PaGlobal_QAItemMarketFunctionFlag = true
    itemMarketSupport.selectItemKey = itemMyWalletInfo:getItemKeyRaw()
    itemMarketSupport.selectItemLevel = itemMyWalletInfo:getEnchantLevel()
    itemMarketSupport.selectItemCount = count
    itemMarketSupport.isMinPrice = isMin
    PaGlobal_QAItemMarketFunctionFlag = true
    local selectLevel = itemMarketSupport.selectItemLevel
    for ii = 0, 20 do
      local itemInfo = getWorldMarketDetailListByIdx(ii)
      if nil ~= itemInfo then
        local maxEnchantLevel = itemInfo:getEnchantMaxLevel()
        local minEnchantLevel = itemInfo:getEnchantMinLevel()
        if minEnchantLevel <= itemMarketSupport.selectItemLevel and maxEnchantLevel <= itemMarketSupport.selectItemLevel then
          selectLevel = minEnchantLevel
          break
        end
      end
    end
    local enchantItemKey = ItemEnchantKey(itemMarketSupport.selectItemKey, selectLevel)
    ToClient_requestGetBiddingList(enchantItemKey, false, PaGlobalFunc_ItemMarket_isHotCategory())
  end
end
function PaGlobalFunc_ItemMarketSellTestDetail(itemKey, enchantLevel, enchantMinLevel, standardPrice_s64, itemCount_s64, isSealed, biddingSellListCount)
  if false == PaGlobal_QAItemMarketSupportOn or 0 == itemMarketSupport.selectItemCount then
    return
  end
  local priceIndex = 0
  local productPrice = 0
  if true == itemMarketSupport.isMinPrice then
    local index = biddingSellListCount - 1
    local biddingInfo = ToClient_GetBiddingInfoByIndex(index)
    productPrice = biddingInfo:getPricePerOne()
  else
    local biddingInfo = ToClient_GetBiddingInfoByIndex(0)
    productPrice = biddingInfo:getPricePerOne()
  end
  ToClient_requestSellItemToWorldMarket(itemKey, itemMarketSupport.selectItemLevel, itemMarketSupport.selectItemCount, productPrice, itemMarketSupport.selectItemLevel, isSealed)
  itemMarketSupport.selectItemCount = 0
end
