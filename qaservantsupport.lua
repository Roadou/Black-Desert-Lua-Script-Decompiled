ServantTestCaseEnum = {
  eUseIngameCommand = 0,
  eUnsealServant = 1,
  eRecoverServant = 2,
  eChangeServantName = 3,
  eResetDeadCount = 4,
  eResetMatingCount = 5,
  eImprintServant = 6,
  eLinkCarriage = 7,
  eUnLinkCarriage = 8,
  eChangeForm = 9,
  ePrimiumChangeForm = 10,
  eResetServant = 11,
  eRegistMatingMarket = 12,
  eRegistForRent = 13,
  eRegistMarket = 14,
  eReleaseServant = 15,
  eMoveServant = 16,
  eReviveServant = 17,
  eRemoteSeal = 18,
  eSeal = 19,
  eRecoverUnseal = 20,
  eSellToReward = 21,
  eRegisterForReturn = 22,
  eMatingImmediatelyEnd = 23,
  eSkillExpTrainStart = 25,
  eSkillExpTrainEnd = 26,
  eSkillChange = 27,
  eForgetServantSkill = 28,
  eStartStallionTraining = 29,
  eEndStallionTraining = 30,
  eChangeServantLevel = 31,
  eChangeServantDeadCount = 32,
  eChangeServantState = 33,
  eExchangeServant = 34,
  eMating = 35,
  eMatingCancle = 36,
  eMatingPopPrice = 37,
  eMarektCancle = 38,
  eMarketPopPrice = 39,
  eMarketBuy = 40,
  eRentCancle = 41,
  eRentPopPrice = 42,
  eRentBuy = 43,
  eReturnPopPrice = 44,
  eReturnBuy = 45,
  eReceiveChild = 46,
  eForcedReturn = 47,
  eRegisterServant = 48,
  eStableExpansion = 49,
  eCount = 50
}
PaGlobal_ServantTestRentUserName = nil
PaGlobal_ServantTestName = nil
local TestCaseEnum = ServantTestCaseEnum
local servantSupport = {
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
    _failLocation,
    _detailReason,
    _servantInfo
  },
  testList = {},
  testFunc = {},
  prepareFunc = {},
  testCaseToStirng = {},
  currentIndex = 0,
  timeStamp = 0,
  intervalStamp = 0
}
PaGlobal_QAServantSupportOn = false
local TestCount = 0
local outputDir = "D:\\ServantTest\\"
function PaGlobalFunc_ResetServantTestList()
  servantSupport.intervalStamp = 0
  servantSupport.timeStamp = 0
  servantSupport.testList = {}
  _PA_LOG("ServantQA", " [" .. TestCount .. "] ------------------------------------------------------------------------------------------")
  TestCount = TestCount + 1
end
function PaGlobalFunc_InsertServantTestCase(eTestCase, expectedResult, param1, param2, param3, param4, param5)
  if eTestCase >= TestCaseEnum.eMating or TestCaseEnum.eReleaseServant == eTestCase or TestCaseEnum.eSellToReward == eTestCase then
    local testPrepare = {
      _testCase = eTestCase,
      _isPrepare = true,
      _state = 0,
      _param1 = param1,
      _param3 = param3
    }
    table.insert(servantSupport.testList, testPrepare)
  end
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
  table.insert(servantSupport.testList, testPreset)
end
function PaGlobalFunc_DoservantTest()
  servantSupport.timeStamp = 0
  local currentTest = servantSupport.testList[servantSupport.currentIndex]
  currentTest._state = 1
  if not currentTest._isPrepare then
    local testFunc = servantSupport.testFunc[currentTest._testCase]
    currentTest._servantNo, currentTest._servantInfo = PaGlobalFunc_GetServantBriefSpec(currentTest._testCase, currentTest._param1)
    local rv = testFunc(currentTest._param1, currentTest._param2, currentTest._param3, currentTest._param4, currentTest._param5)
    if 0 ~= rv then
      PaGlobalFunc_ServantTest_SetState(false, "Client", rv)
      currentTest._servantDetailPost = PaGlobalFunc_GetServantSpec(servantSupport.currentIndex, currentTest._testCase, currentTest._param1, currentTest._servantNo)
    end
  else
    local prepareFunc = servantSupport.prepareFunc[currentTest._testCase]
    if nil ~= prepareFunc then
      if TestCaseEnum.eMating == currentTest._testCase then
        prepareFunc(currentTest._param3)
      elseif nil ~= currentTest._param1 then
        prepareFunc(currentTest._param1)
      else
        prepareFunc()
      end
    end
  end
end
function PaGlobalFunc_GetServantBriefSpec(testCase, param1)
  local servantInfo
  if TestCaseEnum.eUseIngameCommand == testCase then
    return nil, ""
  end
  if TestCaseEnum.eRemoteSeal == testCase or TestCaseEnum.eSeal == testCase or TestCaseEnum.eRecoverUnseal == testCase then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil ~= temporaryWrapper then
      servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    end
  elseif testCase >= TestCaseEnum.eMatingCancle then
    local myAuctionInfo = RequestGetAuctionInfo()
    if nil ~= myAuctionInfo then
      servantInfo = myAuctionInfo:getServantAuctionListAt(param1)
    end
  else
    local slotNo = servantSupport:getRealSlotNo(param1)
    if nil == slotNo then
      _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
      return nil, ""
    end
    servantInfo = stable_getServant(slotNo)
  end
  if nil == servantInfo then
    _PA_LOG("ServantQA", "\235\167\144 \236\160\149\235\179\180\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return nil, ""
  end
  local stallion
  if true == servantInfo:isStallion() then
    stallion = "\236\164\128\235\167\136"
  else
    stallion = "\236\157\188\235\176\152\235\167\136"
  end
  return servantInfo:getServantNo(), "lv." .. servantInfo:getLevel() .. " Tier. " .. servantInfo:getTier() .. " " .. stallion
end
function PaGlobalFunc_GetServantSpec(index, testCase, param1, isPrev, servantNo)
  local servantInfo
  if TestCaseEnum.eUseIngameCommand == testCase then
    return "[\235\170\133\235\160\185\236\150\180 \236\139\164\237\150\137]\t" .. param1
  end
  if TestCaseEnum.eRemoteSeal == testCase or TestCaseEnum.eSeal == testCase or TestCaseEnum.eRecoverUnseal == testCase then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil ~= temporaryWrapper then
      servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    end
  elseif testCase >= TestCaseEnum.eMatingCancle then
    local myAuctionInfo = RequestGetAuctionInfo()
    if nil ~= myAuctionInfo then
      servantInfo = myAuctionInfo:getServantAuctionListAt(param1)
    end
  elseif TestCaseEnum.eReleaseServant ~= testCase then
    if nil ~= servantNo then
      servantInfo = stable_getServantByServantNo(servantNo)
    else
      local slotNo = servantSupport:getRealSlotNo(param1)
      if nil ~= slotNo then
        servantInfo = stable_getServant(slotNo)
      end
    end
  end
  if nil == servantInfo then
    if nil ~= servantNo then
      servantInfo = stable_getServantByServantNo(servantNo)
    end
    if nil == servantInfo then
      return "<NULL>"
    end
  end
  local string = servantInfo:getLevel() .. "\t" .. servantInfo:getTier() .. "\t" .. servantInfo:getMaxHp() .. "\t" .. servantInfo:getMaxMp() .. "\t" .. servantInfo:getHp() .. "\t" .. servantInfo:getMp() .. "\t" .. tostring(servantInfo:getExp_s64()) .. "\t" .. servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) .. "\t" .. servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) .. "\t" .. servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) .. "\t" .. servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) .. "\t" .. servantInfo:getMatingCount() .. "\t" .. servantInfo:getStateType() .. "\t" .. tostring(servantInfo:isChangingRegion()) .. "\t" .. tostring(servantInfo:isImprint()) .. "\t" .. servantInfo:getDeadCount() .. "\t" .. tostring(servantInfo:getSkillFailedCount()) .. "\t" .. tostring(servantInfo:getServantAwakenStack()) .. "\t" .. tostring(servantInfo:getSkillCount())
  for ii = 1, servantInfo:getSkillCount() - 1 do
    local skillWrapper = servantInfo:getSkill(ii)
    if nil ~= skillWrapper and false == skillWrapper:isTrainingSkill() then
      string = string .. "\t" .. ii .. "\t" .. servantInfo:getSkillExp(ii)
    end
  end
  return string
end
function PaGlobalFunc_ServantTest_SetState(isSuccess, location, reason)
  local currentTest = servantSupport.testList[servantSupport.currentIndex]
  currentTest._state = 2
  currentTest._realResult = isSuccess
  currentTest._finalResult = isSuccess == currentTest._expectedResult
  if false == isSuccess then
    currentTest._failLocation = location
    currentTest._detailReason = reason
  end
end
function PaGlobalFunc_ServantTest_CheckState()
  local currentIndex = 1
  for index, content in pairs(servantSupport.testList) do
    if 0 == content._state then
      servantSupport.currentIndex = currentIndex
      PaGlobalFunc_DoservantTest()
      return
    elseif 1 == content._state then
      return
    end
    currentIndex = currentIndex + 1
  end
  if currentIndex >= table.getn(servantSupport.testList) then
    FinishServantQA()
  end
end
function PaGlobalFunc_ServantTest_UpdatePerFrameFunc(deltaTime)
  servantSupport.intervalStamp = servantSupport.intervalStamp + deltaTime
  if servantSupport.intervalStamp < 0.001 then
    return
  end
  servantSupport.timeStamp = servantSupport.timeStamp + servantSupport.intervalStamp
  servantSupport.intervalStamp = 0
  if PaGlobal_ServantTestWaitSecond < servantSupport.timeStamp then
    local currentTest = servantSupport.testList[servantSupport.currentIndex]
    if nil ~= currentTest then
      currentTest._servantDetailPost = PaGlobalFunc_GetServantSpec(servantSupport.currentIndex, currentTest._testCase, currentTest._param1, currentTest._servantNo)
    end
    PaGlobalFunc_ServantTest_SetState(true)
  end
  PaGlobalFunc_ServantTest_CheckState()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ServantQASupport_LuaLoadComplete")
function PaGlobalFunc_GetNakMessageForQA(TrID, reason, AddNo)
  if false == PaGlobal_QAServantSupportOn then
    return
  end
  local currentTest = servantSupport.testList[servantSupport.currentIndex]
  if nil ~= currentTest then
    currentTest._servantDetailPost = PaGlobalFunc_GetServantSpec(servantSupport.currentIndex, currentTest._testCase, currentTest._param1, currentTest._servantNo)
  end
  if reason == 1529985730 then
    PaGlobalFunc_ServantTest_SetState(true)
  else
    PaGlobalFunc_ServantTest_SetState(false, "Server", reason)
  end
end
function PaGlobalFunc_ServantQASupport_LuaLoadComplete()
  servantSupport:init()
end
function servantSupport:init()
  registerEvent("FromClient_GetNakMessageForQA", "PaGlobalFunc_GetNakMessageForQA")
  if nil == PaGlobal_ServantTestWaitSecond then
    PaGlobal_ServantTestWaitSecond = 1
  end
  servantSupport.testFunc[TestCaseEnum.eUseIngameCommand] = PaGlobalFunc_UseIngameCommandForTest
  servantSupport.testFunc[TestCaseEnum.eUnsealServant] = PaGlobalFunc_UnsealTest
  servantSupport.testFunc[TestCaseEnum.eRecoverServant] = PaGlobalFunc_RecoveryTest
  servantSupport.testFunc[TestCaseEnum.eChangeServantName] = PaGlobalFunc_ChangeNameTest
  servantSupport.testFunc[TestCaseEnum.eResetDeadCount] = PaGlobalFunc_ClearDeadCountTest
  servantSupport.testFunc[TestCaseEnum.eResetMatingCount] = PaGlobalFunc_ClearMatingCountTest
  servantSupport.testFunc[TestCaseEnum.eImprintServant] = PaGlobalFunc_ImprintTest
  servantSupport.testFunc[TestCaseEnum.eLinkCarriage] = PaGlobalFunc_CarriageLinkTest
  servantSupport.testFunc[TestCaseEnum.eUnLinkCarriage] = PaGlobalFunc_CarriageUnlinkTest
  servantSupport.testFunc[TestCaseEnum.eChangeForm] = PaGlobalFunc_ChangeFormTest
  servantSupport.testFunc[TestCaseEnum.ePrimiumChangeForm] = PaGlobalFunc_PrimiumChangeFormTest
  servantSupport.testFunc[TestCaseEnum.eResetServant] = PaGlobalFunc_ResetServantTest
  servantSupport.testFunc[TestCaseEnum.eRegistMatingMarket] = PaGlobalFunc_RegistMatingTest
  servantSupport.testFunc[TestCaseEnum.eRegistForRent] = PaGlobalFunc_RentServantTest
  servantSupport.testFunc[TestCaseEnum.eRegistMarket] = PaGlobalFunc_RegistMarketTest
  servantSupport.testFunc[TestCaseEnum.eReleaseServant] = PaGlobalFunc_ReleseTest
  servantSupport.testFunc[TestCaseEnum.eMoveServant] = PaGlobalFunc_ChangeRegionTest
  servantSupport.testFunc[TestCaseEnum.eReviveServant] = PaGlobalFunc_ReviveTest
  servantSupport.testFunc[TestCaseEnum.eRemoteSeal] = PaGlobalFunc_RemoteSealTest
  servantSupport.testFunc[TestCaseEnum.eSeal] = PaGlobalFunc_SealTest
  servantSupport.testFunc[TestCaseEnum.eSellToReward] = PaGlobalFunc_SellToNpcTest
  servantSupport.testFunc[TestCaseEnum.eRecoverUnseal] = PaGlobalFunc_RecoveryUnsealTest
  servantSupport.testFunc[TestCaseEnum.eMating] = PaGlobalFunc_MatingTest
  servantSupport.testFunc[TestCaseEnum.eMatingImmediatelyEnd] = PaGlobalFunc_MatingImmediatelyEndTest
  servantSupport.testFunc[TestCaseEnum.eReceiveChild] = PaGlobalFunc_ReceiveChild
  servantSupport.testFunc[TestCaseEnum.eSkillExpTrainStart] = PaGlobalFunc_SkillExpTrainingTest
  servantSupport.testFunc[TestCaseEnum.eSkillExpTrainEnd] = PaGlobalFunc_EndSkillExpTrainingTest
  servantSupport.testFunc[TestCaseEnum.eSkillChange] = PaGlobalFunc_ChangeSkillTest
  servantSupport.testFunc[TestCaseEnum.eForgetServantSkill] = PaGlobalFunc_ForgetServantSkillTest
  servantSupport.testFunc[TestCaseEnum.eStartStallionTraining] = PaGlobalFunc_StallionSkillExpTrainingTest
  servantSupport.testFunc[TestCaseEnum.eEndStallionTraining] = PaGlobalFunc_EndStallionSkillExpTrainingTest
  servantSupport.testFunc[TestCaseEnum.eExchangeServant] = PaGlobalFunc_ServantExchangeTest
  servantSupport.testFunc[TestCaseEnum.eRegisterForReturn] = PaGlobalFunc_RegisterForReturn
  servantSupport.testFunc[TestCaseEnum.eMatingCancle] = PaGlobalFunc_MatingCancleTest
  servantSupport.testFunc[TestCaseEnum.eMatingPopPrice] = PaGlobalFunc_MatingPopPriceTest
  servantSupport.testFunc[TestCaseEnum.eMarektCancle] = PaGlobalFunc_MarketCancleTest
  servantSupport.testFunc[TestCaseEnum.eMarketPopPrice] = PaGlobalFunc_MarketPopPriceTest
  servantSupport.testFunc[TestCaseEnum.eMarketBuy] = PaGlobalFunc_MarketBuyItNowTest
  servantSupport.testFunc[TestCaseEnum.eRentCancle] = PaGlobalFunc_RentCancleTest
  servantSupport.testFunc[TestCaseEnum.eRentPopPrice] = PaGlobalFunc_RentPopPriceTest
  servantSupport.testFunc[TestCaseEnum.eRentBuy] = PaGlobalFunc_RentBuyItNowTest
  servantSupport.testFunc[TestCaseEnum.eReturnPopPrice] = PaGlobalFunc_ReturnPopPriceTest
  servantSupport.testFunc[TestCaseEnum.eReturnBuy] = PaGlobalFunc_ReturnBuyItNowTest
  servantSupport.testFunc[TestCaseEnum.eForcedReturn] = PaGlobalFunc_ForcedReturnTest
  servantSupport.testFunc[TestCaseEnum.eRegisterServant] = PaGlobalFunc_regiseterServantTest
  servantSupport.testFunc[TestCaseEnum.eStableExpansion] = PaGlobalFunc_useExpansionItemForTest
  servantSupport.testFunc[TestCaseEnum.eChangeServantLevel] = PaGlobalFunc_ChangeServantLevelTest
  servantSupport.testFunc[TestCaseEnum.eChangeServantDeadCount] = PaGlobalFunc_ChangeServantDeadCountTest
  servantSupport.testFunc[TestCaseEnum.eChangeServantState] = PaGlobalFunc_ChangeServantState
  servantSupport.prepareFunc[TestCaseEnum.eMating] = PaGlobalFunc_getServantMatingListPage
  servantSupport.prepareFunc[TestCaseEnum.eMatingCancle] = requestMyServantMatingList
  servantSupport.prepareFunc[TestCaseEnum.eMatingPopPrice] = requestMyServantMatingList
  servantSupport.prepareFunc[TestCaseEnum.eMarektCancle] = requestMyServantMarketList
  servantSupport.prepareFunc[TestCaseEnum.eMarketPopPrice] = requestMyServantMarketList
  servantSupport.prepareFunc[TestCaseEnum.eMarketBuy] = requestServantMarketListPage
  servantSupport.prepareFunc[TestCaseEnum.eRentCancle] = requestMyServantRentList
  servantSupport.prepareFunc[TestCaseEnum.eRentPopPrice] = requestMyServantRentList
  servantSupport.prepareFunc[TestCaseEnum.eRentBuy] = requestMyServantRentList
  servantSupport.prepareFunc[TestCaseEnum.eReturnPopPrice] = requestMyServantReturnList
  servantSupport.prepareFunc[TestCaseEnum.eReturnBuy] = requestServantReturnList
  servantSupport.prepareFunc[TestCaseEnum.eReceiveChild] = PaGlobalFunc_getServantMatingChildInfo
  servantSupport.prepareFunc[TestCaseEnum.eForcedReturn] = requestMyServantRentList
  servantSupport.prepareFunc[TestCaseEnum.eRegisterServant] = PaGlobalFunc_regiseterServant
  servantSupport.prepareFunc[TestCaseEnum.eStableExpansion] = PaGlobalFunc_CreateExpansionItemForTest
  servantSupport.prepareFunc[TestCaseEnum.eSellToReward] = PaGlobalFunc_WaitSecondForTest
  servantSupport.prepareFunc[TestCaseEnum.eReleaseServant] = PaGlobalFunc_WaitSecondForTest
  servantSupport.testCaseToStirng[TestCaseEnum.eUnsealServant] = "\236\176\190\234\184\176"
  servantSupport.testCaseToStirng[TestCaseEnum.eRecoverServant] = "\237\154\140\235\179\181"
  servantSupport.testCaseToStirng[TestCaseEnum.eChangeServantName] = "\236\157\180\235\166\132 \235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.eResetDeadCount] = "\236\163\189\236\157\128 \237\154\159\236\136\152 \236\180\136\234\184\176\237\153\148"
  servantSupport.testCaseToStirng[TestCaseEnum.eResetMatingCount] = "\234\181\144\235\176\176 \237\154\159\236\136\152 \236\180\136\234\184\176\237\153\148"
  servantSupport.testCaseToStirng[TestCaseEnum.eImprintServant] = "\234\176\129\236\157\184"
  servantSupport.testCaseToStirng[TestCaseEnum.eLinkCarriage] = "\235\167\136\236\176\168\236\151\176\234\178\176"
  servantSupport.testCaseToStirng[TestCaseEnum.eUnLinkCarriage] = "\235\167\136\236\176\168\236\151\176\234\178\176\237\149\180\236\160\156"
  servantSupport.testCaseToStirng[TestCaseEnum.eChangeForm] = "\236\153\184\237\152\149\235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.ePrimiumChangeForm] = "\237\148\132\235\166\172\235\175\184\236\151\132\236\153\184\237\152\149\235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.eResetServant] = "\237\131\145\236\138\185\235\172\188 \236\180\136\234\184\176\237\153\148"
  servantSupport.testCaseToStirng[TestCaseEnum.eRegistMatingMarket] = "\234\181\144\235\176\176\236\139\156\236\158\165 \235\147\177\235\161\157"
  servantSupport.testCaseToStirng[TestCaseEnum.eRegistForRent] = "\235\140\128\236\151\172"
  servantSupport.testCaseToStirng[TestCaseEnum.eRegistMarket] = "\235\167\136\236\139\156\236\158\165 \235\147\177\235\161\157"
  servantSupport.testCaseToStirng[TestCaseEnum.eReleaseServant] = "\237\131\145\236\138\185\235\172\188 \237\140\144\235\167\164"
  servantSupport.testCaseToStirng[TestCaseEnum.eMoveServant] = "\236\157\180\236\134\161"
  servantSupport.testCaseToStirng[TestCaseEnum.eReviveServant] = "\235\182\128\237\153\156"
  servantSupport.testCaseToStirng[TestCaseEnum.eRemoteSeal] = "\236\155\144\234\178\169\237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eSeal] = "\237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eSellToReward] = "\237\153\169\236\139\164\235\130\169\237\146\136"
  servantSupport.testCaseToStirng[TestCaseEnum.eRecoverUnseal] = "\236\176\190\236\157\128\235\167\144 \237\154\140\235\179\181"
  servantSupport.testCaseToStirng[TestCaseEnum.eMating] = "\234\181\144\235\176\176"
  servantSupport.testCaseToStirng[TestCaseEnum.eMatingImmediatelyEnd] = "\234\181\144\235\176\176\236\166\137\236\139\156\236\153\132\235\163\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eReceiveChild] = "\235\167\157\236\149\132\236\167\128\236\150\187\234\184\176"
  servantSupport.testCaseToStirng[TestCaseEnum.eSkillExpTrainStart] = "\236\138\164\237\130\172\237\155\136\235\160\168\236\139\156\236\158\145"
  servantSupport.testCaseToStirng[TestCaseEnum.eSkillExpTrainEnd] = "\236\138\164\237\130\172\237\155\136\235\160\168\236\162\133\235\163\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eSkillChange] = "\236\138\164\237\130\172\235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.eForgetServantSkill] = "\236\138\164\237\130\172\236\130\173\236\160\156"
  servantSupport.testCaseToStirng[TestCaseEnum.eStartStallionTraining] = "\236\164\128\235\167\136\237\155\136\235\160\168\236\139\156\236\158\145"
  servantSupport.testCaseToStirng[TestCaseEnum.eEndStallionTraining] = "\236\164\128\235\167\136\237\155\136\235\160\168\236\162\133\235\163\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eExchangeServant] = "\235\167\144 \234\181\144\237\153\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eRegisterForReturn] = "\235\140\128\236\151\172\235\167\144\235\176\152\235\130\169"
  servantSupport.testCaseToStirng[TestCaseEnum.eMatingCancle] = "\234\181\144\235\176\176\236\139\156\236\158\165 \235\147\177\235\161\157\236\183\168\236\134\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eMatingPopPrice] = "\234\181\144\235\176\176\236\139\156\236\158\165 \234\177\176\235\158\152\234\184\136\236\149\161 \237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eMarektCancle] = "\235\167\136\236\139\156\236\158\165 \235\147\177\235\161\157\236\183\168\236\134\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eMarketPopPrice] = "\235\167\136\236\139\156\236\158\165 \234\177\176\235\158\152\234\184\136\236\149\161 \237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eMarketBuy] = "\235\167\136\236\139\156\236\158\165 \235\167\144 \234\181\172\236\158\133"
  servantSupport.testCaseToStirng[TestCaseEnum.eRentCancle] = "\235\140\128\236\151\172\236\139\156\236\158\165 \235\147\177\235\161\157\236\183\168\236\134\140"
  servantSupport.testCaseToStirng[TestCaseEnum.eRentPopPrice] = "\235\140\128\236\151\172\236\139\156\236\158\165 \234\177\176\235\158\152\234\184\136\236\149\161 \237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eRentBuy] = "\235\140\128\236\151\172\236\139\156\236\158\165 \235\167\144 \236\136\152\235\160\185"
  servantSupport.testCaseToStirng[TestCaseEnum.eReturnPopPrice] = "\235\176\152\235\130\169\236\139\156\236\158\165 \234\177\176\235\158\152\234\184\136\236\149\161 \237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eReturnBuy] = "\235\176\152\235\130\169\236\139\156\236\158\165 \235\167\144 \236\136\152\235\160\185"
  servantSupport.testCaseToStirng[TestCaseEnum.eForcedReturn] = "\235\140\128\236\151\172 \235\167\144 \234\176\149\236\160\156\237\154\140\236\136\152"
  servantSupport.testCaseToStirng[TestCaseEnum.eRegisterServant] = "\235\167\136\237\140\168 \235\147\177\235\161\157"
  servantSupport.testCaseToStirng[TestCaseEnum.eStableExpansion] = "\235\167\136\234\181\172\234\176\132 \237\153\149\236\158\165"
  servantSupport.testCaseToStirng[TestCaseEnum.eChangeServantLevel] = "\235\167\144\235\160\136\235\178\168\235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.eChangeServantDeadCount] = "\236\163\189\236\157\128\237\154\159\236\136\152\235\179\128\234\178\189"
  servantSupport.testCaseToStirng[TestCaseEnum.eChangeServantState] = "\236\131\129\237\131\156\235\179\128\234\178\189"
end
function PrepareServantQA(TestListFunc)
  servantSupport:prepareTest(TestListFunc)
end
function servantSupport:prepareTest(TestListFunc)
  if false == interaction_ForQATest() then
    _PA_LOG("ServantQA", "\237\133\140\236\138\164\237\138\184 \237\153\152\234\178\189 \236\133\139\237\140\133 \236\139\164\237\140\168")
    return
  end
  stable_SortDataupdate()
  TestListFunc()
  PaGlobal_QAServantSupportOn = true
end
function FinishServantQA()
  servantSupport:endTest()
end
local convertDateStr = function()
  local paTime = PATime(getServerUtc64())
  return tostring(paTime:GetYear()) .. tostring(paTime:GetMonth()) .. tostring(paTime:GetDay())
end
function servantSupport:endTest()
  PaGlobal_QAServantSupportOn = false
  if false == _ContentsGroup_NewUI_Dialog_All then
    RenderMode_DialogListClose()
  else
    PaGlobalFunc_DialogMain_All_Close()
  end
  local currentTime = convertDateStr()
  if nil ~= ToClient_QAsupportCheckDir then
    ToClient_QAsupportCheckDir(outputDir)
  end
  ToClient_QAsupportFileOpen(outputDir .. "TestResult_" .. tostring(PaGlobal_ServantTestName) .. "_" .. currentTime .. "_" .. getVersion() .. ".txt")
  local logTitle = "<\237\133\140\236\138\164\237\138\184\235\178\136\237\152\184>\t[\235\167\144\236\160\149\235\179\180]\t[\237\133\140\236\138\164\237\138\184\237\149\173\235\170\169]\t[\236\181\156\236\162\133\234\178\176\234\179\188]\t[\234\184\176\235\140\128\234\178\176\234\179\188]\t[\236\139\164\236\160\156\234\178\176\234\179\188]\t[\236\139\164\237\140\168\236\156\132\236\185\152]\t[\236\130\172\236\156\160]"
  logTitle = logTitle .. "\t[\235\160\136\235\178\168]\t[\237\139\176\236\150\180]\t[MaxHP]\t[MaxMP]\t[HP]\t[MP]\t[EXP]\t[MaxMoveSpeed]\t[Acceleration]\t[CorneringSpeed]\t[BrakeSpeed]"
  logTitle = logTitle .. "\t[MatingCount]\t[StateType]\t[isChangingRegion]\t[isImprint]\t[DeadCount]\t[SkillFailedCount]\t[ServantAwakenStack]\t[SkillCount]\t[Skill]\n"
  ToClient_QAsupportFileWrite(logTitle)
  for index, content in pairs(servantSupport.testList) do
    if not content._isPrepare and "" ~= content._servantInfo then
      local logstr = index .. "\t" .. tostring(content._servantInfo) .. "\t" .. tostring(servantSupport.testCaseToStirng[content._testCase]) .. "\t" .. self:getResultString(content._finalResult) .. "\t" .. tostring(content._expectedResult) .. "\t" .. tostring(content._realResult)
      if false == content._realResult then
        local failstr = "\t" .. content._failLocation .. "\t" .. PAGetStringSymNo(content._detailReason)
        logstr = logstr .. failstr
      else
        logstr = logstr .. "\t<NULL>\t<NULL>"
      end
      logstr = logstr .. "\t" .. tostring(content._servantDetailPost) .. "\n"
      ToClient_QAsupportFileWrite(logstr)
    end
  end
  ToClient_QAsupportFileClose()
end
function servantSupport:getResultString(result)
  if true == result then
    return "PASS"
  end
  return "FAIL"
end
function servantSupport:getRealSlotNo(stableSlotNo)
  stable_SortDataupdate()
  return stable_SortByWayPointKey(stableSlotNo)
end
function PaGlobalFunc_UseIngameCommandForTest(command)
  return servantSupport:useIngameCommandForTest(command)
end
function servantSupport:useIngameCommandForTest(command)
  pa_sendMessage(command)
  return 0
end
function PaGlobalFunc_UnsealTest(stableSlotNo)
  return servantSupport:Unseal(stableSlotNo)
end
function servantSupport:Unseal(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    return -1
  end
  local servantInfo = stable_getServant(slotNo, false)
  if nil == servantInfo then
    return -1
  end
  local result = stable_unsealByServantNo(servantInfo:getServantNo())
  return result
end
function PaGlobalFunc_RecoveryTest(stableSlotNo, moneyWhereType)
  return servantSupport:recoveryTest(stableSlotNo, moneyWhereType)
end
function servantSupport:recoveryTest(stableSlotNo, moneyWhereType)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_recovery(slotNo, moneyWhereType)
end
function PaGlobalFunc_ChangeNameTest(stableSlotNo, inputName)
  return servantSupport:changeNameTest(stableSlotNo, inputName)
end
function servantSupport:changeNameTest(stableSlotNo, reqName)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_changeName(slotNo, reqName)
end
function PaGlobalFunc_ClearDeadCountTest(stableSlotNo)
  return servantSupport:clearDeadCount(stableSlotNo)
end
function servantSupport:clearDeadCount(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_clearDeadCount(slotNo)
end
function PaGlobalFunc_ClearMatingCountTest(stableSlotNo)
  return servantSupport:clearMatingCount(stableSlotNo)
end
function servantSupport:clearMatingCount(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_clearMatingCount(slotNo)
end
function PaGlobalFunc_ImprintTest(stableSlotNo, isImprint)
  return servantSupport:imprint(stableSlotNo, isImprint)
end
function servantSupport:imprint(stableSlotNo, isImprint)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_imprint(slotNo, isImprint)
end
function PaGlobalFunc_CarriageLinkTest(stableSlotNo, CarriageSlotNo)
  return servantSupport:carriageLink(stableSlotNo, CarriageSlotNo)
end
function servantSupport:carriageLink(stableSlotNo, CarriageSlotNo)
  local _stableSlotNo = self:getRealSlotNo(stableSlotNo)
  if nil == _stableSlotNo then
    _PA_LOG("ServantQA", "_stableSlotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  local _carriageSlotNo = self:getRealSlotNo(CarriageSlotNo)
  if nil == _carriageSlotNo then
    _PA_LOG("ServantQA", "_carriageSlotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_link(_stableSlotNo, _carriageSlotNo, true)
end
function PaGlobalFunc_CarriageUnlinkTest(stableSlotNo, CarriageSlotNo)
  return servantSupport:carriageUnlink(stableSlotNo, CarriageSlotNo)
end
function servantSupport:carriageUnlink(stableSlotNo, CarriageSlotNo)
  local _stableSlotNo = self:getRealSlotNo(stableSlotNo)
  if nil == _stableSlotNo then
    _PA_LOG("ServantQA", "_stableSlotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  local _carriageSlotNo = self:getRealSlotNo(CarriageSlotNo)
  if nil == _carriageSlotNo then
    _PA_LOG("ServantQA", "_carriageSlotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_link(_stableSlotNo, _carriageSlotNo, false)
end
function PaGlobalFunc_ChangeFormTest(stableSlotNo, formIndex)
  return servantSupport:changeForm(stableSlotNo, formIndex)
end
function servantSupport:changeForm(stableSlotNo, formIndex)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_changeForm(slotNo, formIndex, 0)
end
function PaGlobalFunc_PrimiumChangeFormTest(stableSlotNo, formIndex)
  return servantSupport:primiumChangeForm(stableSlotNo, formIndex, true)
end
function servantSupport:primiumChangeForm(stableSlotNo, formIndex, isPossibleLearnSkill)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_changeForm(slotNo, formIndex, 1, isPossibleLearnSkill)
end
function PaGlobalFunc_ResetServantTest(stableSlotNo)
  return servantSupport:resetServant(stableSlotNo)
end
function servantSupport:resetServant(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return ToClient_requestSetBeginningLevelServant(slotNo)
end
function PaGlobalFunc_RegistMatingTest(stableSlotNo, transferType)
  return servantSupport:registServantMating(stableSlotNo, transferType)
end
function servantSupport:registServantMating(stableSlotNo, transferType)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo, false)
  if nil == servantInfo then
    _PA_LOG("ServantQA", "\235\167\136\234\181\172\234\176\132\236\151\144 \235\147\177\235\161\157\235\144\156 \235\167\144\235\167\140 \234\176\128\235\138\165")
    return -1
  end
  local minPrice = servantInfo:getMinRegisterMatingPrice_s64()
  local price = minPrice
  if CppEnums.TransferType.TransferType_Self == transferType then
    price = getServantSelfMatingPrice()
  end
  return stable_registerServantToSomeWhereElse(slotNo, CppEnums.AuctionType.AuctionGoods_ServantMating, transferType, price)
end
function PaGlobalFunc_RentServantTest(stableSlotNo, rentUserNickname)
  if nil ~= PaGlobal_ServantTestRentUserName then
    rentUserNickname = PaGlobal_ServantTestRentUserName
    _PA_LOG("ServantQA", "\236\187\164\235\167\168\235\147\156\235\161\156 \236\158\133\235\160\165\235\176\155\236\157\128 \236\156\160\236\160\128 \236\160\149\235\179\180\235\165\188 \236\130\172\236\154\169\237\149\169\235\139\136\235\139\164.  : " .. rentUserNickname)
  end
  return servantSupport:rentServant(stableSlotNo, rentUserNickname)
end
function servantSupport:rentServant(stableSlotNo, rentUserNickname)
  if nil == self:getRealSlotNo(stableSlotNo) then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(self:getRealSlotNo(stableSlotNo), false)
  if nil == servantInfo then
    _PA_LOG("ServantQA", "\235\167\136\234\181\172\234\176\132\236\151\144 \235\147\177\235\161\157\235\144\156 \235\167\144\235\167\140 \234\176\128\235\138\165")
    return -1
  end
  return ToClient_RegisterServantForRent(servantInfo:getServantNo(), rentUserNickname)
end
function PaGlobalFunc_RegistMarketTest(stableSlotNo)
  return servantSupport:registServantMarket(stableSlotNo, CppEnums.ServantRegist.eEventType_RegisterMarket)
end
function servantSupport:registServantMarket(stableSlotNo, transferType)
  if nil == self:getRealSlotNo(stableSlotNo) then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = stable_getServant(self:getRealSlotNo(stableSlotNo))
  if nil == servantInfo then
    return -1
  end
  local price = servantInfo:getMinRegisterMarketPrice_s64()
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_registerServantToSomeWhereElse(slotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket, CppEnums.TransferType.TransferType_Normal, price)
end
function PaGlobalFunc_ReleseTest(stableSlotNo)
  return servantSupport:releseServant(stableSlotNo)
end
function servantSupport:releseServant(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_changeToReward(slotNo, CppEnums.ServantToRewardType.Type_Experience)
end
function PaGlobalFunc_SellToNpcTest(stableSlotNo)
  return servantSupport:releseServant(stableSlotNo)
end
function servantSupport:sellToNpcServant(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "slotNo \235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \236\138\172\235\161\175 \235\132\152\235\178\132\236\158\133\235\139\136\235\139\164")
    return -1
  end
  return stable_changeToReward(slotNo, CppEnums.ServantToRewardType.Type_Money)
end
function PaGlobalFunc_ChangeRegionTest(stableSlotNo, regionKey, moneyWhereType)
  return servantSupport:changeRegion(stableSlotNo, regionKey, moneyWhereType)
end
function servantSupport:changeRegion(stableSlotNo, regionKey, moneyWhereType)
  if nil == self:getRealSlotNo(stableSlotNo) then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(self:getRealSlotNo(stableSlotNo), false)
  if nil == servantInfo then
    _PA_LOG("ServantQA", "\235\167\136\234\181\172\234\176\132\236\151\144 \235\147\177\235\161\157\235\144\156 \235\167\144\235\167\140 \234\176\128\235\138\165")
    return -1
  end
  return ToClient_ChangeServantRegion(servantInfo:getServantNo(), regionKey, moneyWhereType)
end
function PaGlobalFunc_ReviveTest(stableSlotNo, moneyWhereType)
  return servantSupport:reviveServant(stableSlotNo, moneyWhereType)
end
function servantSupport:reviveServant(stableSlotNo, moneyWhereType)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_revive(slotNo, moneyWhereType)
end
function PaGlobalFunc_RemoteSealTest()
  return servantSupport:remoteSeal()
end
function servantSupport:remoteSeal()
  return stable_seal(true)
end
function PaGlobalFunc_SealTest()
  return servantSupport:Seal()
end
function servantSupport:Seal()
  return stable_seal(false)
end
function PaGlobalFunc_RecoveryUnsealTest()
  return servantSupport:recoveryUnseal()
end
function servantSupport:recoveryUnseal()
  return stable_recoveryUnseal()
end
function PaGlobalFunc_MatingTest(stableSlotNo, marketSlotNo, transferType, moneyWhereType)
  return servantSupport:mating(stableSlotNo, marketSlotNo, transferType, moneyWhereType)
end
function servantSupport:mating(stableSlotNo, marketSlotNo, transferType, moneyWhereType)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_startServantMating(slotNo, marketSlotNo, transferType, moneyWhereType)
end
function PaGlobalFunc_MatingImmediatelyEndTest(stableSlotNo)
  return servantSupport:matingImmediatelyEnd(stableSlotNo)
end
function servantSupport:matingImmediatelyEnd(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo)
  if nil == servantInfo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\160\149\235\179\180\235\165\188 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_requestCompleteServantMating(slotNo, servantInfo:getCompleteMatingFromPearl_s64())
end
function PaGlobalFunc_SkillExpTrainingTest(stableSlotNo, skillkey)
  return servantSupport:skillExpTrainingTest(stableSlotNo, skillkey)
end
function servantSupport:skillExpTrainingTest(stableSlotNo, skillkey)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_startServantSkillExpTraining(slotNo, skillKey)
end
function PaGlobalFunc_EndSkillExpTrainingTest(stableSlotNo)
  return servantSupport:endSkillExpTrainingTest(stableSlotNo)
end
function servantSupport:endSkillExpTrainingTest(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_endServantSkillExpTraining(slotNo)
end
function PaGlobalFunc_ReceiveChild(stableSlotNo, childName)
  return servantSupport:receiveChild(stableSlotNo, childName)
end
function servantSupport:receiveChild(stableSlotNo, childName)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_receiveServantMatingChild(slotNo, childName)
end
function PaGlobalFunc_ChangeSkillTest(stableSlotNo, fromSkillKey, toSkillKey)
  return servantSupport:changeSkill(stableSlotNo, fromSkillKey, toSkillKey)
end
function servantSupport:changeSkill(stableSlotNo, fromSkillKey, toSkillKey)
  local slotNo = self:getRealSlotNo(stableSlotNo, fromSkillKey, toSkillKey)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_changeSkill(slotNo, fromSkillKey, toSkillKey)
end
function PaGlobalFunc_StallionSkillExpTrainingTest(stableSlotNo)
  return servantSupport:stallionSkillExpTraining(stableSlotNo)
end
function servantSupport:stallionSkillExpTraining(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo)
  if nil == servantInfo then
    return -1
  end
  local servantNo = servantInfo:getServantNo()
  return ToClient_startStallionSkillExpTraining(servantNo)
end
function PaGlobalFunc_EndStallionSkillExpTrainingTest(stableSlotNo)
  return servantSupport:endStallionSkillExpTraining(stableSlotNo)
end
function servantSupport:endStallionSkillExpTraining(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_endStallionSkillExpTraining(slotNo)
end
function PaGlobalFunc_ForgetServantSkillTest(stableSlotNo, skillKey)
  return servantSupport:forgetServantSkill(stableSlotNo, skillKey)
end
function servantSupport:forgetServantSkill(stableSlotNo, skillKey)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_forgetServantSkill(slotNo, skillKey)
end
function PaGlobalFunc_RegisterForReturn(stableSlotNo)
  return servantSupport:registerForReturn(stableSlotNo)
end
function servantSupport:registerForReturn(stableSlotNo)
  local slotNo = self:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return -1
  end
  local servantNo = servantInfo:getServantNo()
  return ToClient_RegisterServantForReturn(servantNo)
end
function PaGlobalFunc_MatingCancleTest(marketSlotNo)
  return servantSupport:matingCancle(marketSlotNo)
end
function servantSupport:matingCancle(marketSlotNo)
  return stable_cancelServantFromSomeWhereElse(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating)
end
function PaGlobalFunc_MatingPopPriceTest(marketSlotNo, toWhereType)
  return servantSupport:matingPopPrice(marketSlotNo, toWhereType)
end
function servantSupport:matingPopPrice(marketSlotNo, toWhereType)
  return stable_popServantPrice(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMating, toWhereType)
end
function PaGlobalFunc_MarketCancleTest(marketSlotNo)
  return servantSupport:marketCancle(marketSlotNo)
end
function servantSupport:marketCancle(marketSlotNo)
  return stable_cancelServantFromSomeWhereElse(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket)
end
function PaGlobalFunc_MarketPopPriceTest(marketSlotNo, toWhereType)
  return servantSupport:marketPopPrice(marketSlotNo, toWhereType)
end
function servantSupport:marketPopPrice(marketSlotNo, toWhereType)
  return stable_popServantPrice(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantMarket, toWhereType)
end
function PaGlobalFunc_MarketBuyItNowTest(marketSlotNo, toWhereType)
  return servantSupport:marketBuyItNow(marketSlotNo, toWhereType)
end
function servantSupport:marketBuyItNow(marketSlotNo, toWhereType)
  return stable_requestBuyItNowServant(marketSlotNo, toWhereType)
end
function PaGlobalFunc_RentCancleTest(marketSlotNo)
  return servantSupport:rentCancle(marketSlotNo)
end
function servantSupport:rentCancle(marketSlotNo)
  return stable_cancelServantFromSomeWhereElse(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantRent)
end
function PaGlobalFunc_RentPopPriceTest(marketSlotNo, toWhereType)
  return servantSupport:rentPopPrice(marketSlotNo, toWhereType)
end
function servantSupport:rentPopPrice(marketSlotNo, toWhereType)
  return stable_popServantPrice(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantRent, toWhereType)
end
function PaGlobalFunc_RentBuyItNowTest(marketSlotNo, toWhereType)
  return servantSupport:rentBuyItNow(marketSlotNo, toWhereType)
end
function servantSupport:rentBuyItNow(marketSlotNo, toWhereType)
  return ToClient_requestBuyItNowServantForRent(marketSlotNo, toWhereType)
end
function PaGlobalFunc_ReturnPopPriceTest(marketSlotNo, toWhereType)
  return servantSupport:returnPopPrice(marketSlotNo, toWhereType)
end
function servantSupport:returnPopPrice(marketSlotNo, toWhereType)
  return stable_popServantPrice(marketSlotNo, CppEnums.AuctionType.AuctionGoods_ServantReturn, toWhereType)
end
function PaGlobalFunc_ReturnBuyItNowTest(marketSlotNo, toWhereType)
  return servantSupport:returnBuyItNow(marketSlotNo, toWhereType)
end
function servantSupport:returnBuyItNow(marketSlotNo, toWhereType)
  return ToClient_requestBuyItNowServantForReturn(marketSlotNo, toWhereType)
end
function PaGlobalFunc_ServantExchangeTest(stableSlotNo1, stableSlotNo2, fromWhereType, name)
  return servantSupport:servantExchangeTest(stableSlotNo1, stableSlotNo2, fromWhereType, name)
end
function servantSupport:servantExchangeTest(stableSlotNo1, stableSlotNo2, fromWhereType, name)
  local slotNo1 = self:getRealSlotNo(stableSlotNo1)
  if nil == slotNo1 then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo1 = stable_getServant(slotNo1)
  if nil == servantInfo1 then
    return -1
  end
  local servantNo1 = servantInfo1:getServantNo()
  local slotNo2 = self:getRealSlotNo(stableSlotNo2)
  if nil == slotNo2 then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo2 = stable_getServant(slotNo2)
  if nil == servantInfo2 then
    return -1
  end
  local servantNo2 = servantInfo2:getServantNo()
  return stable_mix(servantNo1, servantNo2, fromWhereType, name)
end
function PaGlobalFunc_getServantMatingChildInfo(stableSlotNo)
  local slotNo = servantSupport:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  return stable_getServantMatingChildInfo(slotNo)
end
function PaGlobalFunc_getServantMatingListPage(transferType)
  requestServantMatingListPage(transferType)
end
function PaGlobalFunc_ForcedReturnTest(marketSlotNo)
  local info = RequestGetAuctionInfo():getServantAuctionListAt(marketSlotNo)
  if not info then
    return
  end
  return stable_returnServantToSomeWhereElse(info:getServantNo(), CppEnums.AuctionType.AuctionGoods_ServantReturn, CppEnums.TransferType.TransferType_Self)
end
function PaGlobalFunc_regiseterServant(itemKey)
  ToClient_qaCreateItem(itemKey, 0, 1)
end
function PaGlobalFunc_regiseterServantTest(servantItemKey, name)
  local selfPlayerWrapper = getSelfPlayer():get()
  local invenUseSize = selfPlayerWrapper:getInventorySlotCount(false)
  local slotNo
  for i = 0, invenUseSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, i)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if itemKey == servantItemKey then
        slotNo = i
        break
      end
    end
  end
  if slotNo == nil then
    return -1
  end
  stable_registerByItem(CppEnums.ItemWhereType.eInventory, slotNo, name)
  return 0
end
function PaGlobalFunc_CreateExpansionItemForTest(itemKey)
  ToClient_qaCreateItem(itemKey, 0, 1)
end
function PaGlobalFunc_useExpansionItemForTest(servantItemKey, name)
  local selfPlayerWrapper = getSelfPlayer():get()
  local invenUseSize = selfPlayerWrapper:getInventorySlotCount(false)
  local slotNo
  for i = 0, invenUseSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, i)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if itemKey == servantItemKey then
        slotNo = i
        break
      end
    end
  end
  if slotNo == nil then
    return -1
  end
  inventoryUseItem(CppEnums.ItemWhereType.eCashInventory, slotNo, CppEnums.EquipSlotNoClient.eEquipSlotNoCount, true)
  return 0
end
function PaGlobalFunc_ChangeServantLevelTest(stableSlotNo, level)
  local slotNo = servantSupport:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo)
  if nil == servantInfo then
    return -1
  end
  local servantNo = servantInfo:getServantNo()
  if false == ToClient_qaLevelupServantInStable(servantNo, level) then
    return -1
  end
  return 0
end
function PaGlobalFunc_ChangeServantDeadCountTest(stableSlotNo, count)
  local slotNo = servantSupport:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo)
  if nil == servantInfo then
    return -1
  end
  local servantNo = servantInfo:getServantNo()
  if false == ToClient_qaChangeServantDeadCount(servantNo, count) then
    return -1
  end
  return 0
end
function PaGlobalFunc_ChangeServantState(stableSlotNo, state)
  local slotNo = servantSupport:getRealSlotNo(stableSlotNo)
  if nil == slotNo then
    _PA_LOG("ServantQA", "\235\147\177\235\161\157\235\144\156 \235\167\144\236\157\132 \236\176\190\236\157\132 \236\136\152 \236\151\134\236\157\140")
    return -1
  end
  local servantInfo = ToClient_getStableServantEx(slotNo)
  if nil == servantInfo then
    return -1
  end
  local servantNo = servantInfo:getServantNo()
  if false == ToClient_qaChangeServantState(servantNo, state) then
    return -1
  end
  return 0
end
function PaGlobalFunc_WaitSecondForTest(sed)
end
