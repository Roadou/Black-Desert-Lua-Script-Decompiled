function FGlobal_MiniGame_HerbMachine()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameHerbMachine, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameHerbMachine, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_Buoy()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuoy, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuoy, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_PowerControl()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGamePowerControl, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGamePowerControl, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_Tutorial()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameTutorial, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameTutorial, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_HouseControl_Empty()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Empty) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Empty)
  end
end
function FGlobal_MiniGame_HouseControl_Depot()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Depot) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Depot)
  end
end
function FGlobal_MiniGame_HouseControl_Refinery()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Refinery) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Refinery)
  end
end
function FGlobal_MiniGame_HouseControl_LocalSpecailtiesWorkshop()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.LocalSpecailtiesWorkshop) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.LocalSpecailtiesWorkshop)
  end
end
function FGlobal_MiniGame_HouseControl_Shipyard()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Shipyard) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameBuyHouse, CppEnums.eHouseUseType.Shipyard)
  end
end
function FGlobal_MiniGame_RequestPlantInvest(param)
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameInvestPlant, param) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameInvestPlant, param)
  end
end
function FGlobal_Tutorial_RequestSitDown()
  if questList_hasProgressQuest(2001, 189) then
    request_clearMiniGame(CppEnums.MiniGame.eTutorialSitDown, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_Tutorial_RequestLean()
  if questList_hasProgressQuest(2001, 190) then
    request_clearMiniGame(CppEnums.MiniGame.eTutorialLean, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_RequestPlantWorking()
end
function FGlobal_MiniGame_RequestExtraction()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameExtraction, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameExtraction, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
function FGlobal_MiniGame_RequestEditingHouse(param)
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniGameEditingHouse, param) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniGameEditingHouse, param)
  end
end
function FGlobal_MiniGame_SummerHammerGame()
  if questList_hasProgressMiniGame(CppEnums.MiniGame.eMiniSummerHammer, CppEnums.MiniGameParam.eMiniGameParamDefault) then
    request_clearMiniGame(CppEnums.MiniGame.eMiniSummerHammer, CppEnums.MiniGameParam.eMiniGameParamDefault)
  end
end
