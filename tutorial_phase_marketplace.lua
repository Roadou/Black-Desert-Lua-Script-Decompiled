PaGlobal_TutorialPhase_MarketPlace = {
  _ui = {
    main = {stc_tutorial = nil},
    inven = {stc_tutorial = nil},
    wallet = {},
    buy = {stc_tutorial = nil},
    sell = {stc_tutorial = nil}
  },
  _isTutorial = false,
  _isSelectTutorial = false,
  _readyForTutorial = false,
  _isButtonInput = false,
  _tutorialInfo = {},
  _tutorialIndex = -1,
  _currentIndex = -1,
  _waitRequest = false,
  _currentDescControl = nil,
  _initialize = false,
  _itemInfo = nil,
  _CONTROL_TYPE = {
    MAIN = 1,
    INVEN = 2,
    WALLET = 3,
    BUY = 4,
    SELL = 5
  },
  _CLEAR_STATE = {
    NOCLEAR = 0,
    PROGRESS = 1,
    CLEAR = 2,
    REPLAY = 3
  },
  _DESCINDEX = {
    NONE = 0,
    MAIN_INTRO = 1,
    MAIN_TOINVEN = 2,
    INVEN_INTRO = 11,
    INVEN_ITEMMOVE = 12,
    INVEN_DEPOSITINTRO = 13,
    INVEN_DODEPOSIT = 14,
    WALLET_USEMARKET = 15,
    WALLET_DOBUY = 16,
    MAIN_THISWAY = 21,
    MAIN_INTRORATE = 22,
    MAIN_DOBUY = 23,
    BUY_INTROLIST = 31,
    BUY_WAITSELL1 = 32,
    BUY_WAITSELL2 = 33,
    BUY_WAITBUY = 34,
    BUY_DOBUY = 35,
    MAIN_GOSELLTAB = 41,
    MAIN_WAITSELLLOOK = 42,
    MAIN_INTROSELL = 43,
    MAIN_DOSELL = 44,
    SELL_INTRO = 51,
    SELL_WAITBUY = 52,
    SELL_WAITSELL1 = 53,
    SELL_WAITSELL2 = 54,
    MAIN_END = 61,
    ENDPOINT = 62
  }
}
registerEvent("FromClient_luaLoadComplete", "FromClient_TutorialPhase_MarketPlace_Init")
function FromClient_TutorialPhase_MarketPlace_Init()
  PaGlobal_TutorialPhase_MarketPlace:initialize()
end
function PaGlobal_TutorialPhase_MarketPlace:initialize()
  if true == PaGlobal_TutorialPhase_MarketPlace._initialize then
    return
  end
  PaGlobal_TutorialPhase_MarketPlace:setTutorialState()
  local this = PaGlobal_TutorialPhase_MarketPlace
  this._ui.main.stc_marketPlace = UI.getChildControl(Panel_Window_MarketPlace_Main, "Static_MarketPlace")
  this._ui.main.stc_leftBG = UI.getChildControl(this._ui.main.stc_marketPlace, "Static_LeftBg")
  this._ui.main.stc_walletStatBG = UI.getChildControl(this._ui.main.stc_leftBG, "Static_WalletStatBg")
  this._ui.main.btn_ChangeBagManager_Market = UI.getChildControl(this._ui.main.stc_walletStatBG, "Button_ChangeBagManager_Marketplace")
  this._ui.main.stc_leftMenuBG = UI.getChildControl(Panel_Window_MarketPlace_Main, "Static_LeftMenuBg")
  this._ui.main.btn_Wallet = UI.getChildControl(this._ui.main.stc_leftMenuBG, "RadioButton_Wallet")
  this._ui.main.stc_wallet = UI.getChildControl(Panel_Window_MarketPlace_Main, "Static_Wallet")
  this._ui.inven.stc_mainSlotBG = UI.getChildControl(Panel_Window_MarketPlace_MyInventory, "Static_MainSlotBG")
  this._ui.inven.btn_deposit = UI.getChildControl(Panel_Window_MarketPlace_MyInventory, "Button_Deposit")
  this._ui.inven.txt_money = UI.getChildControl(this._ui.inven.btn_deposit, "StaticText_MoneyValue")
  this._ui.wallet.btn_withDraw = UI.getChildControl(Panel_Window_MarketPlace_WalletInventory, "Button_Withdraw")
  this._ui.wallet.txt_money = UI.getChildControl(Panel_Window_MarketPlace_WalletInventory, "StaticText_MoneyValue")
  this._ui.wallet.btn_gotoMarket = UI.getChildControl(Panel_Window_MarketPlace_WalletInventory, "Button_GoToMarket")
  this._ui.buy.btn_buy = UI.getChildControl(Panel_Window_MarketPlace_BuyManagement, "Button_InMarketRegist")
  this._ui.buy.stc_itemList = UI.getChildControl(Panel_Window_MarketPlace_BuyManagement, "List2_ItemList")
  this._ui.sell.btn_sell = UI.getChildControl(Panel_Window_MarketPlace_SellManagement, "Button_InMarketRegist")
  this._ui.sell.stc_itemList = UI.getChildControl(Panel_Window_MarketPlace_SellManagement, "List2_ItemList")
  this._ui.main.stc_tutorial = UI.getChildControl(Panel_Window_MarketPlace_Main, "Static_Tutorial")
  this._ui.main.btn_tutorialButton = UI.getChildControl(this._ui.main.stc_tutorial, "Button_TutorialButton")
  this._ui.main.txt_tutorialDesc = UI.getChildControl(this._ui.main.stc_tutorial, "StaticText_TutorialDesc")
  this._ui.main.txt_tutorialContinue = UI.getChildControl(this._ui.main.txt_tutorialDesc, "StaticText_Continue")
  this._ui.main.stc_highlight = UI.getChildControl(this._ui.main.stc_tutorial, "Static_Highlight")
  this._ui.main.stc_blackSprit = UI.getChildControl(this._ui.main.stc_tutorial, "Static_BlackSpirit")
  this._ui.main.stc_blackSprit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  this._ui.inven.stc_tutorial = UI.getChildControl(Panel_Window_MarketPlace_MyInventory, "Static_Tutorial")
  this._ui.inven.btn_tutorialButton = UI.getChildControl(this._ui.inven.stc_tutorial, "Button_TutorialButton")
  this._ui.inven.txt_tutorialDesc = UI.getChildControl(this._ui.inven.stc_tutorial, "StaticText_TutorialDesc")
  this._ui.inven.txt_tutorialContinue = UI.getChildControl(this._ui.inven.txt_tutorialDesc, "StaticText_Continue")
  this._ui.inven.stc_highlight = UI.getChildControl(this._ui.inven.stc_tutorial, "Static_Highlight")
  this._ui.inven.stc_blackSprit = UI.getChildControl(this._ui.inven.stc_tutorial, "Static_BlackSpirit")
  this._ui.inven.stc_blackSprit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  this._ui.wallet.stc_tutorial = UI.getChildControl(Panel_Window_MarketPlace_WalletInventory, "Static_Tutorial")
  this._ui.wallet.btn_tutorialButton = UI.getChildControl(this._ui.wallet.stc_tutorial, "Button_TutorialButton")
  this._ui.wallet.txt_tutorialDesc = UI.getChildControl(this._ui.wallet.stc_tutorial, "StaticText_TutorialDesc")
  this._ui.wallet.txt_tutorialContinue = UI.getChildControl(this._ui.wallet.txt_tutorialDesc, "StaticText_Continue")
  this._ui.wallet.stc_highlight = UI.getChildControl(this._ui.wallet.stc_tutorial, "Static_Highlight")
  this._ui.wallet.stc_blackSprit = UI.getChildControl(this._ui.wallet.stc_tutorial, "Static_BlackSpirit")
  this._ui.wallet.stc_blackSprit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  this._ui.buy.stc_tutorial = UI.getChildControl(Panel_Window_MarketPlace_BuyManagement, "Static_Tutorial")
  this._ui.buy.btn_tutorialButton = UI.getChildControl(this._ui.buy.stc_tutorial, "Button_TutorialButton")
  this._ui.buy.txt_tutorialDesc = UI.getChildControl(this._ui.buy.stc_tutorial, "StaticText_TutorialDesc")
  this._ui.buy.txt_tutorialContinue = UI.getChildControl(this._ui.buy.txt_tutorialDesc, "StaticText_Continue")
  this._ui.buy.stc_highlight = UI.getChildControl(this._ui.buy.stc_tutorial, "Static_Highlight")
  this._ui.buy.stc_blackSprit = UI.getChildControl(this._ui.buy.stc_tutorial, "Static_BlackSpirit")
  this._ui.buy.stc_blackSprit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  this._ui.sell.stc_tutorial = UI.getChildControl(Panel_Window_MarketPlace_SellManagement, "Static_Tutorial")
  this._ui.sell.btn_tutorialButton = UI.getChildControl(this._ui.sell.stc_tutorial, "Button_TutorialButton")
  this._ui.sell.txt_tutorialDesc = UI.getChildControl(this._ui.sell.stc_tutorial, "StaticText_TutorialDesc")
  this._ui.sell.txt_tutorialContinue = UI.getChildControl(this._ui.sell.txt_tutorialDesc, "StaticText_Continue")
  this._ui.sell.stc_highlight = UI.getChildControl(this._ui.sell.stc_tutorial, "Static_Highlight")
  this._ui.sell.stc_blackSprit = UI.getChildControl(this._ui.sell.stc_tutorial, "Static_BlackSpirit")
  this._ui.sell.stc_blackSprit:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  this._tutorialIndex = 0
  this._isTutorial = false
  this._isButtonInput = false
  this._isSelectTutorial = false
  this._readyForTutorial = false
  this:setSceneChange(nil)
  PaGlobal_TutorialPhase_MarketPlace:setTutorialScript()
  PaGlobal_TutorialPhase_MarketPlace:registEventHandler()
  this._initialize = true
end
function PaGlobal_TutorialPhase_MarketPlace:setTutorialState()
  local walletItemCount = getWorldMarketMyWalletListCount()
  local silverInfo = getWorldMarketSilverInfo():getItemCount()
  local tutorialType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMarketTutorial)
  if toInt64(0, 0) == silverInfo and 0 == walletItemCount and PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.CLEAR ~= tutorialType or PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.REPLAY == tutorialType then
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.PROGRESS, CppEnums.VariableStorageType.eVariableStorageType_User)
    PaGlobal_TutorialPhase_MarketPlace._readyForTutorial = true
    return true
  else
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.CLEAR, CppEnums.VariableStorageType.eVariableStorageType_User)
    PaGlobal_TutorialPhase_MarketPlace._readyForTutorial = false
    return false
  end
end
function PaGlobal_TutorialPhase_MarketPlace:setInfo(index, next, desc, control, panel)
  local temp = {
    next = next,
    desc = desc,
    control = control,
    panel = panel
  }
  PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index] = temp
end
function PaGlobal_TutorialPhase_MarketPlace:setTutorialScript()
  local this = PaGlobal_TutorialPhase_MarketPlace
  local desc = PaGlobal_TutorialPhase_MarketPlace._DESCINDEX
  this:setInfo(desc.NONE, desc.MAIN_INTRO)
  this:setInfo(desc.MAIN_INTRO, desc.MAIN_TOINVEN, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_1"))
  this:setInfo(desc.MAIN_TOINVEN, desc.INVEN_INTRO, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_2"), this._ui.main.btn_ChangeBagManager_Market, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.INVEN_INTRO, desc.INVEN_ITEMMOVE, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_3"))
  this:setInfo(desc.INVEN_ITEMMOVE, desc.INVEN_DEPOSITINTRO, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_4"), this._ui.inven.stc_mainSlotBG, this._CONTROL_TYPE.INVEN)
  this:setInfo(desc.INVEN_DEPOSITINTRO, desc.INVEN_DODEPOSIT, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_5"), this._ui.inven.btn_deposit, this._CONTROL_TYPE.INVEN)
  this:setInfo(desc.INVEN_DODEPOSIT, desc.WALLET_USEMARKET, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_6"), this._ui.inven.btn_deposit, this._CONTROL_TYPE.INVEN)
  this:setInfo(desc.WALLET_USEMARKET, desc.WALLET_DOBUY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_7"), this._ui.wallet.btn_withDraw, this._CONTROL_TYPE.WALLET)
  this:setInfo(desc.WALLET_DOBUY, desc.MAIN_THISWAY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_8"), this._ui.wallet.btn_gotoMarket, this._CONTROL_TYPE.WALLET)
  this:setInfo(desc.MAIN_THISWAY, desc.MAIN_INTRORATE, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_9"), nil, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.MAIN_INTRORATE, desc.MAIN_DOBUY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_10"), nil, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.MAIN_DOBUY, desc.BUY_INTROLIST, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_11"), nil, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.BUY_INTROLIST, desc.BUY_WAITSELL1, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_12"), this._ui.buy.stc_itemList, this._CONTROL_TYPE.BUY)
  this:setInfo(desc.BUY_WAITSELL1, desc.BUY_WAITSELL2, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_13"))
  this:setInfo(desc.BUY_WAITSELL2, desc.BUY_WAITBUY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_131"))
  this:setInfo(desc.BUY_WAITBUY, desc.BUY_DOBUY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_14"))
  this:setInfo(desc.BUY_DOBUY, desc.MAIN_GOSELLTAB, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_15"), this._ui.buy.btn_buy, this._CONTROL_TYPE.BUY)
  this:setInfo(desc.MAIN_GOSELLTAB, desc.MAIN_WAITSELLLOOK, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_16"), this._ui.main.btn_Wallet, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.MAIN_WAITSELLLOOK, desc.MAIN_INTROSELL, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_17"), nil, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.MAIN_INTROSELL, desc.MAIN_DOSELL, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_18"))
  this:setInfo(desc.MAIN_DOSELL, desc.SELL_INTRO, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_19"), nil, this._CONTROL_TYPE.MAIN)
  this:setInfo(desc.SELL_INTRO, desc.SELL_WAITBUY, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_20"))
  this:setInfo(desc.SELL_WAITBUY, desc.SELL_WAITSELL1, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_21"), this._ui.sell.stc_itemList, this._CONTROL_TYPE.SELL)
  this:setInfo(desc.SELL_WAITSELL1, desc.SELL_WAITSELL2, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_22"))
  this:setInfo(desc.SELL_WAITSELL2, desc.MAIN_END, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_221"))
  this:setInfo(desc.MAIN_END, nil, PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_DESC_23"))
end
function PaGlobal_TutorialPhase_MarketPlace:doTutorialByIndex(index, param1)
  local this = PaGlobal_TutorialPhase_MarketPlace
  local desc = PaGlobal_TutorialPhase_MarketPlace._DESCINDEX
  if true == PaGlobal_TutorialPhase_SelectTutorialClose() or false == PaGlobal_TutorialPhase_MarketPlace_IsActivate() then
    return
  end
  this._currentIndex = index
  this._isButtonInput = false
  this:setTutorialButton(false)
  this._ui.main.stc_tutorial:SetAlpha(0)
  _PA_LOG("\235\172\184\236\158\165\237\153\152", "doIndex = " .. tostring(index))
  if desc.NONE == index then
    this:setSceneChange(nil)
  elseif desc.MAIN_INTRO == index then
    this:setSceneChange(this._CONTROL_TYPE.MAIN)
    this._ui.main.stc_tutorial:SetAlpha(0.8)
    PaGlobalFunc_ItemMarket_OpenbyMaid(1)
    InputMLUp_MarketPlace_OpenItemMarketTab()
  elseif desc.MAIN_TOINVEN == index then
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.INVEN_INTRO == index then
    this:setSceneChange(this._CONTROL_TYPE.INVEN)
    InputMLUp_MarketPlace_WalletOpen()
    this._ui.inven.txt_money:SetText(this._ui.inven.txt_money:GetText())
  elseif desc.INVEN_ITEMMOVE == index then
    this:setHighlight(true, index)
  elseif desc.INVEN_DEPOSITINTRO == index then
    this:setHighlight(true, index)
  elseif desc.INVEN_DODEPOSIT == index then
    this._ui.inven.txt_money:SetText("1,000")
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_InputFakeMoney()")
  elseif desc.WALLET_USEMARKET == index then
    this._ui.inven.txt_tutorialDesc:SetShow(false)
    this._ui.inven.stc_blackSprit:SetShow(false)
    this._ui.inven.txt_money:SetText(tostring(1000 - Int64toInt32(param1)))
    this._ui.wallet.txt_money:SetText(makeDotMoney(param1))
    this:setSceneChange(this._CONTROL_TYPE.WALLET)
    this:setHighlight(true, index)
  elseif desc.WALLET_DOBUY == index then
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.MAIN_THISWAY == index then
    this:setSceneChange(this._CONTROL_TYPE.MAIN)
    PaGlobalFunc_ItemMarket_OpenbyMaid(1)
    InputMLUp_MarketPlace_OpenItemMarketTab()
    InputMLUp_ItemMarket_MainCategoryList(0)
    InputMLUp_ItemMarket_SubCategoryList(1)
    this._ui.main.stc_list_main = PaGlobal_ItemMarket_GetMainListControl()
    this._ui.main.stc_mainListContent = UI.getChildControl(this._ui.main.stc_list_main, "List2_ItemMarket_Main_Content_0")
    this._tutorialInfo[index].control = UI.getChildControl(this._ui.main.stc_mainListContent, "Template_Button_ItemList")
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.MAIN_INTRORATE == index then
    this._itemInfo = getWorldMarketListByIdx(0)
    if nil ~= this._itemInfo then
      InputMLUp_ItemMarket_RequestDetailListByKey(this._itemInfo:getItemKeyRaw())
    end
  elseif desc.MAIN_DOBUY == index then
    this._ui.main.stc_list_sub = PaGlobal_ItemMarket_GetSubListControl()
    this._ui.main.stc_subListContent = UI.getChildControl(this._ui.main.stc_list_sub, "List2_ItemMarket_Sub_Content_0")
    this._tutorialInfo[index].control = UI.getChildControl(this._ui.main.stc_subListContent, "Template_Button_ItemList")
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.BUY_INTROLIST == index then
    InputMLUp_ItemMarket_RequestBiddingList(0)
    this:setSceneChange(this._CONTROL_TYPE.BUY)
    this:setHighlight(true, index)
  elseif desc.BUY_WAITSELL1 == index then
  elseif desc.BUY_WAITSELL2 == index then
  elseif desc.BUY_WAITBUY == index then
  elseif desc.BUY_DOBUY == index then
    this:setHighlight(false)
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.MAIN_GOSELLTAB == index then
    PaGlobal_MarketPlaceBuy_Cancel()
    this:setSceneChange(this._CONTROL_TYPE.MAIN)
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.MAIN_WAITSELLLOOK == index then
    InputMLUp_MarketPlace_OpenMyWalletTab()
    PaGlobalFunc_MarketPlace_Wallet_OpenMyBuyTab()
    this._ui.main.stc_walletMain = UI.getChildControl(this._ui.main.stc_wallet, "Static_Main")
    this._ui.main.list_itemMarket = UI.getChildControl(this._ui.main.stc_walletMain, "List2_ItemMarket")
    this._ui.main.stc_itemMarketContent = UI.getChildControl(this._ui.main.list_itemMarket, "List2_ItemMarket_Content_0")
    this._tutorialInfo[index].control = UI.getChildControl(this._ui.main.stc_itemMarketContent, "Template_Button_ItemList")
    this:setHighlight(true, index)
  elseif desc.MAIN_INTROSELL == index then
    this:setHighlight(false)
    PaGlobal_SellBidding_ForTutorial()
  elseif desc.MAIN_DOSELL == index then
    this._ui.main.stc_walletLeftBG = UI.getChildControl(this._ui.main.stc_wallet, "Static_LeftBg")
    this._ui.main.stc_itemListBG = UI.getChildControl(this._ui.main.stc_walletLeftBG, "Static_ItemListBg")
    this._ui.main.list_itemList = UI.getChildControl(this._ui.main.stc_itemListBG, "List2_ItemList")
    this._ui.main.list_itemListContent = UI.getChildControl(this._ui.main.list_itemList, "List2_ItemList_Content_0")
    this._tutorialInfo[index].control = UI.getChildControl(this._ui.main.list_itemListContent, "Button_ItemSlot")
    this:setTutorialButton(true, index, "HandleEventLUp_TutorialPhase_RequestNext()")
  elseif desc.SELL_INTRO == index then
    local itemSSW = PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
    PaGlobal_MarketPlaceSell_TutorialOpen(itemSSW:get()._key, 1, 0, toInt64(0, 68000), 1, false, 1)
    this:setSceneChange(this._CONTROL_TYPE.SELL)
  elseif desc.SELL_WAITBUY == index then
    this:setHighlight(true, index)
  elseif desc.SELL_WAITSELL1 == index then
  elseif desc.SELL_WAITSELL2 == index then
  elseif desc.MAIN_END == index then
    PaGlobal_MarketPlaceSell_Cancel()
    InputMLUp_MarketPlace_OpenItemMarketTab()
    this:setSceneChange(this._CONTROL_TYPE.MAIN)
  elseif desc.ENDPOINT == index then
    this:setDescText(index)
    PaGlobal_TutorialPhase_MarketPlace._isTutorial = false
  else
    this:setHighlight(false)
    this._currentDescControl.stc_tutorial:SetShow(false)
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, this._CLEAR_STATE.CLEAR, CppEnums.VariableStorageType.eVariableStorageType_User)
    PaGlobal_TutorialPhase_MarketPlace:prepareClose()
    PaGlobal_TutorialPhase_MarketPlace._isTutorial = false
  end
  this:setDescText(index)
end
function PaGlobal_TutorialPhase_MarketPlace:setTutorialButton(isShow, index, inputEvent)
  local descContorl = PaGlobal_TutorialPhase_MarketPlace._currentDescControl
  if nil == descContorl then
    _PA_LOG("\235\172\184\236\158\165\237\153\152", "descContorl is nil")
    return
  end
  if true == isShow then
    if nil == index then
      return
    end
    local control = PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index].control
    local panel = PaGlobal_TutorialPhase_MarketPlace:getTutorialPanel(PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index].panel)
    if nil == control or nil == panel then
      PA_LOG("\235\172\184\236\158\165\237\153\152", "TutorialButton is nil")
      return
    end
    descContorl.stc_highlight:SetShow(false, true)
    descContorl.btn_tutorialButton:SetShow(true, true)
    descContorl.btn_tutorialButton:SetSize(control:GetSizeX() + 6, control:GetSizeY() + 6)
    descContorl.btn_tutorialButton:SetPosX(control:GetParentPosX() - panel:GetPosX() - 4)
    descContorl.btn_tutorialButton:SetPosY(control:GetParentPosY() - panel:GetPosY() - 4)
    descContorl.btn_tutorialButton:addInputEvent("Mouse_LUp", inputEvent)
    PaGlobal_TutorialPhase_MarketPlace._isButtonInput = true
  else
    descContorl.btn_tutorialButton:SetShow(false, true)
    descContorl.btn_tutorialButton:addInputEvent("Mouse_LUp", "")
    PaGlobal_TutorialPhase_MarketPlace._isButtonInput = false
  end
end
function PaGlobal_TutorialPhase_MarketPlace:setHighlight(isShow, index)
  local descContorl = PaGlobal_TutorialPhase_MarketPlace._currentDescControl
  if nil == descContorl then
    return
  end
  if true == isShow then
    if nil == index then
      return
    end
    local control = PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index].control
    local panel = PaGlobal_TutorialPhase_MarketPlace:getTutorialPanel(PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index].panel)
    if nil == control or nil == panel then
      _PA_LOG("\235\172\184\236\158\165\237\153\152", "highlight is nil")
      return
    end
    descContorl.stc_highlight:SetSize(control:GetSizeX() + 14, control:GetSizeY() + 14)
    descContorl.stc_highlight:SetPosX(control:GetParentPosX() - panel:GetPosX() - 7)
    descContorl.stc_highlight:SetPosY(control:GetParentPosY() - panel:GetPosY() - 7)
    descContorl.btn_tutorialButton:SetShow(false, true)
    descContorl.stc_highlight:SetShow(true, true)
  else
    descContorl.stc_highlight:SetShow(false, true)
  end
end
function PaGlobal_TutorialPhase_MarketPlace:setDescText(index)
  local control = PaGlobal_TutorialPhase_MarketPlace._currentDescControl
  local tutorialInfo = PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[index]
  if nil ~= control and nil ~= tutorialInfo then
    if nil ~= control.txt_tutorialDesc and nil ~= control.txt_tutorialContinue then
      local desc = tutorialInfo.desc
      control.txt_tutorialDesc:SetTextMode(CppEnums.TextMode.eTextMode_None)
      control.txt_tutorialDesc:SetText(desc)
      if 800 < control.txt_tutorialDesc:GetTextSizeX() then
        control.txt_tutorialDesc:SetSize(800, control.txt_tutorialDesc:GetTextSizeY() + 55)
        control.txt_tutorialDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        control.txt_tutorialDesc:SetText(desc)
        control.txt_tutorialDesc:SetSize(825, control.txt_tutorialDesc:GetTextSizeY() + 55)
      else
        control.txt_tutorialDesc:SetSize(control.txt_tutorialDesc:GetTextSizeX() + 25, control.txt_tutorialDesc:GetTextSizeY() + 55)
      end
      control.txt_tutorialDesc:SetSpanSize(60, (control.txt_tutorialDesc:GetSizeY() + 20) * -1)
      control.txt_tutorialDesc:ComputePos()
      control.txt_tutorialContinue:ComputePos()
      control.txt_tutorialDesc:SetShow(true)
      control.stc_blackSprit:SetShow(true)
    end
  elseif nil ~= control then
    control.txt_tutorialDesc:SetShow(false)
    control.stc_blackSprit:SetShow(false)
  end
  if true == PaGlobal_TutorialPhase_MarketPlace._isButtonInput then
    PaGlobal_TutorialPhase_MarketPlace:setContinueText(false)
  else
    PaGlobal_TutorialPhase_MarketPlace:setContinueText(true)
  end
end
function PaGlobal_TutorialPhase_MarketPlace:setContinueText(isShow, desc)
  local control = PaGlobal_TutorialPhase_MarketPlace._currentDescControl
  if nil == control then
    return
  end
  control.txt_tutorialContinue:SetShow(isShow)
  if false == isShow then
    if nil ~= desc then
      control.txt_tutorialContinue:SetText(desc)
    else
      control.txt_tutorialDesc:SetSize(control.txt_tutorialDesc:GetTextSizeX() + 25, control.txt_tutorialDesc:GetTextSizeY() + 40)
      control.txt_tutorialDesc:SetSpanSize(60, (control.txt_tutorialDesc:GetSizeY() + 20) * -1)
      control.txt_tutorialDesc:ComputePos()
      control.txt_tutorialContinue:ComputePos()
    end
  end
end
function PaGlobal_TutorialPhase_MarketPlace:requestNext(param1)
  if true == PaGlobal_TutorialPhase_MarketPlace._isTutorial and nil ~= PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[PaGlobal_TutorialPhase_MarketPlace._tutorialIndex] then
    PaGlobal_TutorialPhase_MarketPlace._tutorialIndex = PaGlobal_TutorialPhase_MarketPlace._tutorialInfo[PaGlobal_TutorialPhase_MarketPlace._tutorialIndex].next
    PaGlobal_TutorialPhase_MarketPlace:doTutorialByIndex(PaGlobal_TutorialPhase_MarketPlace._tutorialIndex, param1)
  end
end
function PaGlobal_TutorialPhase_MarketPlace:setSceneChange(type)
  PaGlobal_TutorialPhase_MarketPlace._ui.main.stc_tutorial:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace._ui.wallet.stc_tutorial:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace._ui.inven.stc_tutorial:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace._ui.buy.stc_tutorial:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace._ui.sell.stc_tutorial:SetShow(false)
  if type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.MAIN then
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = PaGlobal_TutorialPhase_MarketPlace._ui.main
    PaGlobal_TutorialPhase_MarketPlace._ui.main.stc_tutorial:SetShow(true)
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.BUY then
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = PaGlobal_TutorialPhase_MarketPlace._ui.buy
    PaGlobal_TutorialPhase_MarketPlace._ui.buy.stc_tutorial:SetShow(true)
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.SELL then
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = PaGlobal_TutorialPhase_MarketPlace._ui.sell
    PaGlobal_TutorialPhase_MarketPlace._ui.sell.stc_tutorial:SetShow(true)
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.INVEN then
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = PaGlobal_TutorialPhase_MarketPlace._ui.inven
    PaGlobal_TutorialPhase_MarketPlace._ui.inven.stc_tutorial:SetShow(true)
    PaGlobal_TutorialPhase_MarketPlace._ui.wallet.stc_tutorial:SetShow(true)
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.WALLET then
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = PaGlobal_TutorialPhase_MarketPlace._ui.wallet
    PaGlobal_TutorialPhase_MarketPlace._ui.inven.stc_tutorial:SetShow(true)
    PaGlobal_TutorialPhase_MarketPlace._ui.wallet.stc_tutorial:SetShow(true)
  else
    PaGlobal_TutorialPhase_MarketPlace._currentDescControl = nil
  end
end
function PaGlobal_TutorialPhase_MarketPlace:getTutorialPanel(type)
  if type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.MAIN then
    return PaGlobalFunc_Marketplace_GetPanel()
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.INVEN then
    return PaGlobal_MarketPlace_MyInven_GetPanel()
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.WALLET then
    return PaGlobalFunc_MarketPlace_WalletInven_GetPanel()
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.SELL then
    return PaGlobalFunc_MarketPlaceSell_GetPanel()
  elseif type == PaGlobal_TutorialPhase_MarketPlace._CONTROL_TYPE.BUY then
    return PaGlobalFunc_MarketPlaceBuy_GetPanel()
  end
end
function PaGlobal_TutorialPhase_MarketPlace:registEventHandler()
  if nil == Panel_Window_MarketPlace_Main then
    return
  end
end
function PaGlobal_TutorialPhase_MarketPlace:prepareOpen(index)
  if nil == Panel_Window_MarketPlace_Main or false == PaGlobal_TutorialPhase_MarketPlace_IsActivate() then
    return
  end
  if true == PaGlobalFunc_MarketPlace_IsOpenFromDialog() then
    if nil == index then
      PaGlobal_TutorialPhase_MarketPlace:setTutorialState()
    end
    if true == PaGlobal_TutorialPhase_MarketPlace._readyForTutorial then
      if nil ~= index then
        PaGlobal_TutorialPhase_MarketPlace._tutorialIndex = index
        PaGlobal_TutorialPhase_MarketPlace._isSelectTutorial = true
      end
      PaGlobal_TutorialPhase_MarketPlace._isTutorial = true
      PaGlobalFunc_MarketPlace_Function_SetButtonForTutorial(true)
      PaGlobal_TutorialPhase_MarketPlace:setHighlight(false)
      PaGlobal_TutorialPhase_MarketPlace:setTutorialButton(false)
      PaGlobal_TutorialPhase_MarketPlace:open()
    end
  end
end
function PaGlobal_TutorialPhase_MarketPlace:open()
  if nil == Panel_Window_MarketPlace_Main then
    return
  end
  PaGlobal_TutorialPhase_MarketPlace:requestNext()
end
function PaGlobal_TutorialPhase_MarketPlace:prepareClose()
  if nil == Panel_Window_MarketPlace_Main then
    return
  end
  PaGlobal_TutorialPhase_MarketPlace._isTutorial = false
  PaGlobal_TutorialPhase_MarketPlace._isSelectTutorial = false
  PaGlobal_TutorialPhase_MarketPlace._readyForTutorial = false
  PaGlobal_TutorialPhase_MarketPlace._tutorialIndex = -1
  PaGlobal_TutorialPhase_MarketPlace._currentIndex = -1
  PaGlobal_TutorialPhase_MarketPlace._ui.wallet.txt_tutorialDesc:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace._ui.wallet.stc_blackSprit:SetShow(false)
  PaGlobal_TutorialPhase_MarketPlace:setTutorialState()
  PaGlobal_TutorialPhase_MarketPlace:setSceneChange(nil)
  PaGlobalFunc_MarketPlace_Function_SetButtonForTutorial(false)
end
function PaGlobal_TutorialPhase_MarketPlace:close()
  if nil == Panel_Window_MarketPlace_Main then
    return
  end
end
function HandleEventLUp_TutorialPhase_RequestNext()
  if false == PaGlobal_TutorialPhase_MarketPlace_IsActivate() then
    return
  end
  PaGlobal_TutorialPhase_MarketPlace:requestNext()
end
function HandleEventLUp_TutorialPhase_InputFakeMoney()
  Panel_NumberPad_Show(true, toInt64(0, 1000), nil, PaGlobal_TutorialPhase_MarketPlace_setFakeMoney)
end
function PaGlobal_TutorialPhase_MarketPlace_setFakeMoney(inputNumber, slotNo)
  PaGlobal_TutorialPhase_MarketPlace:requestNext(inputNumber)
end
function PaGlobal_TutorialPhase_MarketPlace_IsInputKeycode()
  if true == PaGlobal_TutorialPhase_MarketPlace._isButtonInput then
    return false
  else
    return true
  end
end
function PaGlobal_TutorialPhase_RequestNextByIndex(index)
  if true == PaGlobal_TutorialPhase_MarketPlace._isTutorial and index == PaGlobal_TutorialPhase_MarketPlace._currentIndex and true == PaGlobal_TutorialPhase_MarketPlace._waitRequest then
    PaGlobal_TutorialPhase_MarketPlace:requestNext()
    PaGlobal_TutorialPhase_MarketPlace._waitRequest = false
  end
end
function PaGlobal_Tutorial_GetItemInfo()
  return PaGlobal_TutorialPhase_MarketPlace._itemInfo
end
function PaGlobal_TutorialPhase_MarketPlace_GetItemSSW()
  if nil ~= PaGlobal_TutorialPhase_MarketPlace._itemInfo then
    return PaGlobal_TutorialPhase_MarketPlace._itemInfo:getItemEnchantStaticStatusWrapper()
  else
    return getItemEnchantStaticStatus(ItemEnchantKey(10003))
  end
end
function PaGlobal_TutorialPhase_SetCacheForReplay()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.REPLAY, CppEnums.VariableStorageType.eVariableStorageType_User)
  local tutorialType = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eMarketTutorial)
  _PA_LOG("\235\172\184\236\158\165\237\153\152", "tutorialType for replay = " .. tostring(tutorialType))
  PaGlobal_TutorialPhase_MarketPlace:setTutorialState()
end
function PaGlobal_TutorialPhase_MarketPlace_EscapeClose(executeFunc)
  local function msgYes()
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.CLEAR, CppEnums.VariableStorageType.eVariableStorageType_User)
    PaGlobal_TutorialPhase_MarketPlace:prepareClose()
    executeFunc()
  end
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_EXIT_TITLE")
  local msgDesc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TUTORIAL_EXIT_DESC")
  local messageBoxData = {
    title = msgTitle,
    content = msgDesc,
    functionYes = msgYes,
    functionNo = MessageBox_Empty_function,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_TutorialPhase_SelectTutorialClose()
  if true == PaGlobal_TutorialPhase_MarketPlace._isSelectTutorial and -1 ~= PaGlobal_TutorialPhase_MarketPlace._currentIndex and (PaGlobal_TutorialPhase_MarketPlace._tutorialIndex == PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.WALLET_DOBUY or PaGlobal_TutorialPhase_MarketPlace._tutorialIndex == PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.MAIN_INTROSELL or PaGlobal_TutorialPhase_MarketPlace._tutorialIndex == PaGlobal_TutorialPhase_MarketPlace._DESCINDEX.MAIN_END) then
    PaGlobalFunc_MarketPlace_Close()
    PaGlobalFunc_MarketPlace_MyInven_Close()
    PaGlobalFunc_MarketPlace_WalletInven_Close()
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eMarketTutorial, PaGlobal_TutorialPhase_MarketPlace._CLEAR_STATE.CLEAR, CppEnums.VariableStorageType.eVariableStorageType_User)
    PaGlobal_TutorialPhase_MarketPlace:prepareClose()
    return true
  end
  return false
end
function PaGlobal_TutorialPhase_MarketPlace_IsActivate()
  return ToClient_IsDevelopment()
end
function PaGlobal_TutorialPhase_IsTutorial()
  return PaGlobal_TutorialPhase_MarketPlace._isTutorial
end
