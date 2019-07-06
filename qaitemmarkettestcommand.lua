local TestCaseEnum = ItemMarketTestCaseEnum
function PaGlobalFunc_SetItemMarketTestList()
  PaGlobalFunc_InsertItemMarketTestCase(TestCaseEnum.eSell, true, 1, 1, true)
end
function StartItemMarketQA1()
  PrepareItemMarketQA()
  PaGlobalFunc_ResetItemMarketTestList()
  PaGlobalFunc_SetItemMarketTestList()
end
