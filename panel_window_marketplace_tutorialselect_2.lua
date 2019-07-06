function HandleEvnetLUp_MarketPlaceTutorialSelect_SelectTutorial(type)
  local this = PaGlobal_MarketPlaceTutorialSelect
  PaGlobal_TutorialPhase_SetCacheForReplay()
  if type == this._TYPE.REGISTER then
    PaGlobal_TutorialPhase_MarketPlace:setSceneChange(PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.MAIN)
    PaGlobal_TutorialPhase_MarketPlace:prepareOpen(PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.NONE)
  elseif type == this._TYPE.BUY then
    PaGlobal_TutorialPhase_MarketPlace:setSceneChange(PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.MAIN)
    PaGlobal_TutorialPhase_MarketPlace:prepareOpen(PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.WALLET_DOBUY)
  elseif type == this._TYPE.SELL then
    PaGlobalFunc_ItemMarket_OpenbyMaid(1)
    PaGlobal_TutorialPhase_MarketPlace:setSceneChange(PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.MAIN)
    InputMLUp_MarketPlace_OpenMyWalletTab()
    PaGlobal_TutorialPhase_MarketPlace:prepareOpen(PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.MAIN_WAITSELLLOOK)
  end
  PaGlobal_MarketPlaceTutorialSelect:prepareClose()
end
