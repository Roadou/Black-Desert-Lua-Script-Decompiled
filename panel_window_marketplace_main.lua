local _panel = Panel_Window_MarketPlace_Main
local UI_color = Defines.Color
local MarketPlace = {
  _ui = {
    stc_LeftMenuBg = UI.getChildControl(_panel, "Static_LeftMenuBg"),
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    btn_Close = UI.getChildControl(_panel, "Button_Win_Close"),
    stc_MarketPlace = UI.getChildControl(_panel, "Static_MarketPlace"),
    stc_Wallet = UI.getChildControl(_panel, "Static_Wallet"),
    stc_NoMoneyBG = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _slotConfigWallet = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _tabIdx = {itemMarket = 1, wallet = 2},
  _biddingTabIdx = {sell = 1, buy = 2},
  _itemListType = {
    categoryList = 1,
    detailListByCategory = 2,
    detailListByKey = 3
  },
  _categoryIdxMap = {},
  _currentTerritoryKeyRaw = nil,
  _currentTabIdx = nil,
  _selectedMainKey = -1,
  _selectedSubKey = -1,
  _currentListType = nil,
  _prevListCount = 0,
  _selectedBiddingTabIndex = 0,
  _isEsc = false,
  _isOpenFromDialog = false,
  _isOpenByMaid = false,
  _isWorldMapOpen = false,
  _tooltipIdx = {
    valuePack = 0,
    marketWeight_Marketplace = 1,
    marketWeight_Wallet = 2
  }
}
function PaGlobalFunc_MarketPlace_Get()
  return MarketPlace
end
function MarketPlace:init()
  self._ui.btn_MarketPlace = UI.getChildControl(self._ui.stc_LeftMenuBg, "RadioButton_MarketPlace")
  self._ui.btn_Wallet = UI.getChildControl(self._ui.stc_LeftMenuBg, "RadioButton_Wallet")
  self._ui.txt_BuyTip = UI.getChildControl(self._ui.stc_LeftMenuBg, "StaticText_BuyTip")
  self._ui.txt_SellTip = UI.getChildControl(self._ui.stc_LeftMenuBg, "StaticText_SellTip")
  self._ui.stc_LeftBg_Wallet = UI.getChildControl(self._ui.stc_Wallet, "Static_LeftBg")
  self._ui.stc_WalletStatBg_Wallet = UI.getChildControl(self._ui.stc_LeftBg_Wallet, "Static_WalletStatBg")
  self._ui.stc_LeftBg_MarketPlace = UI.getChildControl(self._ui.stc_MarketPlace, "Static_LeftBg")
  self._ui.stc_WalletStatBg_MarketPlace = UI.getChildControl(self._ui.stc_LeftBg_MarketPlace, "Static_WalletStatBg")
  self._ui.stc_ValuePack_Icon = UI.getChildControl(self._ui.stc_LeftMenuBg, "Static_ValuePack_Icon")
  self._ui.stc_NoMoneyBG = UI.getChildControl(_panel, "Static_NoMoneyBG")
  self._ui.stc_noMoneyDesc = UI.getChildControl(self._ui.stc_NoMoneyBG, "StaticText_NoMoney")
  self._ui.stc_noMoneyDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_noMoneyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETWALLET_MONEY"))
  self._ui.stc_NoMoneyBG:SetShow(false)
  self._ui.btn_changeBagManagerMarketplace = UI.getChildControl(self._ui.stc_WalletStatBg_MarketPlace, "Button_ChangeBagManager_Marketplace")
  self._ui.txt_marketWeightTitleMarketplace = UI.getChildControl(self._ui.stc_WalletStatBg_MarketPlace, "StaticText_MarketWeightTitle")
  self._ui.txt_marketWeightTitleMarketplace:SetSize(self._ui.txt_marketWeightTitleMarketplace:GetTextSizeX(), self._ui.txt_marketWeightTitleMarketplace:GetTextSizeY())
  self._ui.stc_helpMarketplace = UI.getChildControl(self._ui.txt_marketWeightTitleMarketplace, "Static_Help_Marketplace")
  self._ui.stc_helpMarketplace:SetPosX(self._ui.txt_marketWeightTitleMarketplace:GetTextSizeX() + self._ui.stc_helpMarketplace:GetSizeX() + 5)
  self._ui.btn_changeBagManagerWallet = UI.getChildControl(self._ui.stc_WalletStatBg_Wallet, "Button_ChangeBagManager_Wallet")
  self._ui.txt_marketWeightTitleWallet = UI.getChildControl(self._ui.stc_WalletStatBg_Wallet, "StaticText_MarketWeightTitle")
  self._ui.txt_marketWeightTitleWallet:SetSize(self._ui.txt_marketWeightTitleWallet:GetTextSizeX(), self._ui.txt_marketWeightTitleWallet:GetTextSizeY())
  self._ui.stc_helpWallet = UI.getChildControl(self._ui.txt_marketWeightTitleWallet, "Static_Help_Wallet")
  self._ui.stc_helpWallet:SetPosX(self._ui.txt_marketWeightTitleWallet:GetTextSizeX() + self._ui.stc_helpWallet:GetSizeX() + 5)
  self._ui.stc_SearchBg = UI.getChildControl(self._ui.stc_MarketPlace, "Static_SearchBg")
  self._ui.stc_SearchType = UI.getChildControl(self._ui.stc_SearchBg, "CheckButton_SearchType")
  self._ui.btn_MarketPlace:SetText(PAGetString(Defines.StringSheet_RESOURCE, "NPCSHOP_BUY"))
  self._ui.btn_Wallet:SetText(PAGetString(Defines.StringSheet_RESOURCE, "NPCSHOP_SELL"))
  if self._ui.btn_MarketPlace:GetTextSizeX() > 45 then
    self._ui.txt_BuyTip:SetShow(true)
  else
    self._ui.txt_BuyTip:SetShow(false)
  end
  if self._ui.btn_Wallet:GetTextSizeX() > 45 then
    self._ui.txt_SellTip:SetShow(true)
  else
    self._ui.txt_SellTip:SetShow(false)
  end
  self._ui.txt_BuyTip:SetSize(self._ui.txt_BuyTip:GetTextSizeX() + 20, 50)
  self._ui.txt_SellTip:SetSize(self._ui.txt_SellTip:GetTextSizeX() + 20, 50)
  self._ui.txt_BuyTip:ComputePos()
  self._ui.txt_SellTip:ComputePos()
  if self._ui.btn_changeBagManagerMarketplace:GetSizeX() < self._ui.btn_changeBagManagerMarketplace:GetTextSizeX() then
    local marketPlaceSizeX = self._ui.btn_changeBagManagerMarketplace:GetTextSizeX() + 10
    local marketplaceBgSize = self._ui.stc_WalletStatBg_MarketPlace:GetSizeX() - self._ui.btn_changeBagManagerMarketplace:GetPosX() - 10
    if marketPlaceSizeX > marketplaceBgSize then
      self._ui.btn_changeBagManagerMarketplace:SetSize(marketplaceBgSize, self._ui.btn_changeBagManagerMarketplace:GetSizeY())
      UI.setLimitTextAndAddTooltip(self._ui.btn_changeBagManagerMarketplace)
    else
      self._ui.btn_changeBagManagerMarketplace:SetSize(marketPlaceSizeX, self._ui.btn_changeBagManagerMarketplace:GetSizeY())
    end
  end
  if self._ui.btn_changeBagManagerWallet:GetSizeX() < self._ui.btn_changeBagManagerWallet:GetTextSizeX() then
    local walletSizeX = self._ui.btn_changeBagManagerWallet:GetTextSizeX() + 10
    local walletBgSize = self._ui.stc_WalletStatBg_Wallet:GetSizeX() - self._ui.btn_changeBagManagerWallet:GetPosX() - 10
    if walletSizeX > walletBgSize then
      self._ui.btn_changeBagManagerWallet:SetSize(walletBgSize, self._ui.btn_changeBagManagerWallet:GetSizeY())
      UI.setLimitTextAndAddTooltip(self._ui.btn_changeBagManagerWallet)
    else
      self._ui.btn_changeBagManagerWallet:SetSize(walletSizeX, self._ui.btn_changeBagManagerWallet:GetSizeY())
    end
  end
  self:registEvent()
end
function MarketPlace:updateWallet()
  PaGlobalFunc_Wallet_Update()
end
function MarketPlace:registEvent()
  self._ui.btn_MarketPlace:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_OpenItemMarketTab()")
  self._ui.btn_Wallet:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_OpenMyWalletTab()")
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_Close()")
  self._ui.stc_ValuePack_Icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MarketPlace_SimpleToolTip(false)")
  self._ui.btn_changeBagManagerMarketplace:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_WalletOpen()")
  self._ui.btn_changeBagManagerWallet:addInputEvent("Mouse_LUp", "InputMLUp_MarketPlace_WalletOpen()")
  self._ui.stc_helpMarketplace:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 1)")
  self._ui.stc_helpMarketplace:addInputEvent("Mouse_Out", "PaGlobalFunc_MarketPlace_SimpleToolTip(false)")
  self._ui.txt_marketWeightTitleMarketplace:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 3)")
  self._ui.txt_marketWeightTitleMarketplace:addInputEvent("Mouse_Out", "PaGlobalFunc_MarketPlace_SimpleToolTip(false)")
  self._ui.stc_helpWallet:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 2)")
  self._ui.stc_helpWallet:addInputEvent("Mouse_Out", "PaGlobalFunc_MarketPlace_SimpleToolTip(false)")
  self._ui.txt_marketWeightTitleWallet:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 4)")
  self._ui.txt_marketWeightTitleWallet:addInputEvent("Mouse_Out", "PaGlobalFunc_MarketPlace_SimpleToolTip(false)")
  self._ui.btn_MarketPlace:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_TabTip(true, " .. self._tabIdx.itemMarket .. ")")
  self._ui.btn_MarketPlace:addInputEvent("Mouse_Out", "InputMO_PersonalIcon_ShowTooltip(false)")
  self._ui.btn_Wallet:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_TabTip(true, " .. self._tabIdx.wallet .. ")")
  self._ui.btn_Wallet:addInputEvent("Mouse_Out", "InputMO_PersonalIcon_ShowTooltip(false)")
end
function MarketPlace:open(tabIdx, isMaidOpen)
  self._currentTabIdx = tabIdx
  self._selectedMainKey = -1
  self._selectedSubKey = -1
  self._prevListCount = 0
  self._currentListType = nil
  requestOpenItemMarket()
  ToClient_requestMyWalletList()
  PaGlobal_MarketPlaceSell_Cancel()
  PaGlobal_MarketPlaceBuy_Cancel()
  _panel:SetShow(true)
  self._ui.btn_MarketPlace:SetCheck(false)
  self._ui.btn_Wallet:SetCheck(false)
  self._ui.txt_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ITEMMARKET_FUNCTION_MARKET"))
  if self._currentTabIdx == self._tabIdx.itemMarket then
    self._ui.btn_MarketPlace:SetCheck(true)
    self:update()
    PaGlobalFunc_Wallet_Close()
    PaGlobalFunc_ItemMarket_Open()
  elseif self._currentTabIdx == self._tabIdx.wallet then
    self._ui.btn_Wallet:SetCheck(true)
    ToClient_requestMyBiddingListByWorldMarket()
    PaGlobalFunc_ItemMarket_Close()
    PaGlobalFunc_Wallet_Open()
  end
  if true == self._isOpenFromDialog and false == self._isWorldMapOpen or true == self._isOpenByMaid then
    self._ui.btn_changeBagManagerMarketplace:SetShow(true)
    self._ui.btn_changeBagManagerWallet:SetShow(true)
  else
    self._ui.btn_changeBagManagerMarketplace:SetShow(false)
    self._ui.btn_changeBagManagerWallet:SetShow(false)
  end
  FromClient_ValuePackageIcon()
end
function PaGlobalFunc_ItemMarket_OpenbyMaid(isTabType)
  local self = MarketPlace
  self:open(isTabType, true)
  TooltipSimple_Hide()
  Panel_Window_MarketPlace_MyInventory:SetShow(false)
  Panel_Window_MarketPlace_WalletInventory:SetShow(false)
end
function MarketPlace:close()
  _panel:SetShow(false)
  _panel:CloseUISubApp()
end
function MarketPlace:biddingOpen(tabIdx)
  self._selectedBiddingTabIndex = tabIdx
  self:updateWallet()
end
function MarketPlace:update()
  PaGlobalFunc_ItemMarket_Update()
end
function MarketPlace:updateItemList()
  PaGlobalFunc_ItemMarket_UpdateItemList()
end
function MarketPlace:updateMyInfo()
  PaGlobalFunc_ItemMarket_UpdateMyInfo()
  PaGlobalFunc_Wallet_UpdateMyInfo()
end
function PaGlobalFunc_MarketPlace_WalletInventoryMoney(silverInfo)
  local self = MarketPlace
  if "0" == makeDotMoney(silverInfo:getItemCount()) then
    if true == PaGlobal_TutorialPhase_MarketPlace_IsActivate() then
      self._ui.stc_NoMoneyBG:SetShow(false)
    else
      self._ui.stc_NoMoneyBG:SetShow(true)
    end
  else
    self._ui.stc_NoMoneyBG:SetShow(false)
  end
end
function PaGlobalFunc_MarketPlace_UpdateMyInfo()
  MarketPlace:updateMyInfo()
  MarketPlace:updateWallet()
end
function PaGlobalFunc_MarketPlace_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_MarketPlace_IsOpenFromDialog()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  return self._isOpenFromDialog
end
function PaGlobalFunc_MarketPlace_CloseAllCheck()
  if true == PaGlobalFunc_MarketPlace_IsOpenFromDialog() then
    PaGlobalFunc_MarketPlace_CloseToDialog()
  elseif true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    if true == PaGlobalFunc_SubWallet_IsShow() then
      PaGlobalFunc_SubWallet_Close()
      return
    end
    PaGlobalFunc_MarketPlace_CloseFromMaid()
  elseif true == PaGlobalFunc_SubWallet_IsShow() then
    PaGlobalFunc_SubWallet_Close()
  else
    PaGlobalFunc_MarketPlace_Close()
  end
end
function PaGlobalFunc_MarketPlace_Close()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  if true == Panel_Window_MarketPlace_TutorialSelect:GetShow() then
    PaGlobal_MarketPlaceTutorialSelect:prepareClose()
    return
  end
  if true == self._isOpenByMaid then
    ToClient_CallHandlerMaid("_maidLogOut")
    self._isOpenByMaid = false
  end
  self._isEsc = false
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
    self._isWorldMapOpen = false
  end
  PaGlobalFunc_SubWallet_Close()
  PaGlobalFunc_MarketWallet_ForceClose()
  PaGlobal_MarketPlaceSell_Cancel()
  PaGlobal_MarketPlaceBuy_Cancel()
  toClient_requestCloseItemMarket()
  Panel_Tooltip_Item_hideTooltip()
  TooltipSimple_Hide()
  self:close()
  ToClient_CalculateAllMyBiddingCancel()
  if true == Panel_Window_ItemMarket_Favorite:GetShow() then
    FGlobal_ItemMarket_FavoriteItem_Close()
  end
  ToClient_WorldMarketClose()
end
function PaGlobalFunc_MarketPlace_OpenFromDialog()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  if true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    PaGlobalFunc_MarketPlace_CloseFromMaid()
  end
  if false == ToClient_GetIsCreateMyWallet() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_CREATEMYWALLET_FAIL"))
    ToClient_requestCreateMyWallet()
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_ItemMarket)
  warehouse_requestInfoFromNpc()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Close()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(false)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(false)
  end
  self._isOpenFromDialog = true
  PaGlobalFunc_MarketPlace_Open()
  PaGlobalFunc_MarketPlace_Function_Open()
  PaGlobalFunc_Wallet_UpdatePearlItemLimitCount()
end
function PaGlobalFunc_MarketPlace_CloseToDialog()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_ReOpen()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(true)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(true)
  end
  self._isOpenFromDialog = false
  PaGlobalFunc_MarketPlace_Close()
end
function PaGlobalFunc_MarketPlace_Open()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  if false == ToClient_GetIsCreateMyWallet() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_CREATEMYWALLET_FAIL"))
    ToClient_requestCreateMyWallet()
    return
  end
  if true == _panel:GetShow() then
    return
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  _panel:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WRONG_USER_POSITION_MSG"))
    return
  end
  self._currentTerritoryKeyRaw = regionInfoWrapper:getTerritoryKeyRaw()
  self:open(self._tabIdx.itemMarket)
  PaGlobalFunc_MarketWallet_ForceClose()
  _PA_LOG("\235\176\149\234\183\156\235\130\152", "PaGlobalFunc_MarketPlace_Open")
  ToClient_WorldMarketOpen()
  PaGlobal_TutorialPhase_MarketPlace:prepareOpen()
end
function PaGlobalFunc_MarketPlace_OpenForWorldMap(territoryKeyRaw, isEscMenu)
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  if false == ToClient_GetIsCreateMyWallet() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_CREATEMYWALLET_FAIL"))
    ToClient_requestCreateMyWallet()
    return
  end
  if true == _panel:GetShow() then
    return
  end
  if true == ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(_panel, true)
  end
  self._currentTerritoryKeyRaw = territoryKeyRaw
  local rv = requestItemMarketSummaryInfo(self._currentTerritoryKeyRaw, true, false)
  if 0 ~= rv then
    return
  end
  self._isEsc = isEscMenu
  self._isWorldMapOpen = true
  PaGlobalFunc_MarketWallet_ForceClose()
  self:open(self._tabIdx.itemMarket)
  _PA_LOG("\235\176\149\234\183\156\235\130\152", "FGlobal_ItemMarket_Open_ForWorldMap")
end
function PaGlobalFunc_MarketPlace_IsOpenFromWorldMap()
  local self = MarketPlace
  return self._isWorldMapOpen
end
function PaGlobalFunc_MarketPlace_CloseFromMaid()
  local self = MarketPlace
  ToClient_CallHandlerMaid("_maidLogOut")
  self._isOpenByMaid = false
  PaGlobalFunc_MarketPlace_Close()
end
function PaGlobalFunc_MarketPlace_OpenByMaid()
  local self = MarketPlace
  if false == ToClient_GetIsCreateMyWallet() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_CREATEMYWALLET_FAIL"))
    ToClient_requestCreateMyWallet()
    return
  end
  self._isOpenByMaid = true
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if nil == regionInfo then
    return
  end
  local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
  local regionInfoWrapper = getRegionInfoWrapper(myAffiliatedTownRegionKey)
  local wayPointKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()
  local wayKey = getCurrentWaypointKey()
  if ToClient_IsAccessibleRegionKey(myAffiliatedTownRegionKey) == false then
    local plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
    local newRegionInfo = ToClient_getRegionInfoWrapperByWaypoint(plantWayKey)
    if nil == newRegionInfo then
      return
    end
    wayKey = newRegionInfo:get()._waypointKey
    if 0 == wayKey then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_CURRENT_REGION_NO_WAREHOUSE"))
      return
    end
    wayPointKey = wayKey
  end
  warehouse_requestInfo(wayPointKey)
  PaGlobalFunc_MarketWallet_Open()
  _PA_LOG("\235\176\149\234\183\156\235\130\152", "PaGlobalFunc_MarketPlace_OpenByMaid")
end
function PaGlobalFunc_MarketPlace_IsOpenByMaid()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return false
  end
  return self._isOpenByMaid
end
function PaGlobalFunc_MarketPlace_UpdateWalletInfo()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:updateMyInfo()
end
function PaGlobalFunc_MarketPlace_UpdateWalletList()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:updateMyInfo()
  self:updateWallet()
end
function PaGlobalFunc_MarketPlace_Init()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:init()
  PaGlobalFunc_Wallet_Init()
  PaGlobalFunc_ItemMarket_Init()
  PaGlobalFunc_MarketWallet_Init()
  PaGlobalFunc_MarketPlace_Function_Init()
  PaGlobalFunc_MarketPlace_WalletInven_Init()
  PaGlobalFunc_MarketPlace_MyInven_Init()
  PaGlobalFunc_SubWallet_Init()
end
function InputMLUp_MarketPlace_OpenItemMarketTab()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:open(self._tabIdx.itemMarket)
  FromClient_ValuePackageIcon()
  _PA_LOG("\235\176\149\234\183\156\235\130\152", "InputMLUp_MarketPlace_OpenItemMarketTab")
end
function InputMLUp_MarketPlace_OpenMyWalletTab()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  PaGlobalFunc_SubWallet_Close()
  PaGlobalFunc_MarketWallet_ForceClose()
  self:open(self._tabIdx.wallet)
  FromClient_ValuePackageIcon()
  _PA_LOG("\235\176\149\234\183\156\235\130\152", "InputMLUp_MarketPlace_OpenMyWalletTab")
  ClearFocusEdit()
end
function InputMLUp_MarketPlace_WalletOpen()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  if false == self._isOpenFromDialog and false == self._isOpenByMaid then
    return
  end
  TooltipSimple_Hide()
  PaGlobal_MarketPlaceSell_Cancel()
  PaGlobal_MarketPlaceBuy_Cancel()
  PaGlobalFunc_MarketWallet_Open()
  _panel:SetShow(false)
end
function InputMLUp_MarketPlace_RequestDetailListByKey(itemKey)
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  ToClient_requestDetailListByWorldMarketByItemKey(itemKey)
end
function InputMLUp_MarketPlace_RequestBiddingList(idx)
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  local itemInfo = getWorldMarketDetailListByIdx(idx)
  if nil == itemInfo then
    _PA_ASSERT(false, "\236\160\149\235\179\180\234\176\128 \236\152\172\235\176\148\235\165\180\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : getWorldMarketDetailListByIdx( idx )")
    return
  end
  local itemEnchantKey = itemInfo:getEnchantKey()
  ToClient_requestGetBiddingList(itemEnchantKey, true, PaGlobalFunc_ItemMarket_isHotCategory())
end
function FromClient_MarketPlace_ResponseList()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._currentListType = 1
  self:updateItemList()
end
function FromClient_MarketPlace_ResponseDetailListByCategory()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._currentListType = 2
  self:updateItemList()
end
function FromClient_MarketPlace_ResponseDetailListByKey()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self._currentListType = 3
  self:updateItemList()
end
function FromClient_MarketPlace_responseGetMyBiddingList()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:biddingOpen(self._biddingTabIdx.sell)
end
function FromClient_MarketPlace_responseCalculateBuyBidding()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateMyInfo()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_MAIN_CALC_BUY_BID"))
end
function FromClient_MarketPlace_responseWithdrawBuyBidding()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:biddingOpen(self._biddingTabIdx.buy)
  self:updateWallet()
  self:updateMyInfo()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_MAIN_WITHDRAW_BUY_BID"))
end
function FromClient_MarketPlace_responseCalculateSellBidding()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateMyInfo()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_MAIN_CALC_SELL_BID"))
end
function FromClient_MarketPlace_responseWithdrawSellBidding()
  local self = MarketPlace
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketPlace")
    return
  end
  self:biddingOpen(self._biddingTabIdx.sell)
  self:updateWallet()
  self:updateMyInfo()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_MAIN_WITHDRAW_SELL_BID"))
end
function FromClient_ValuePackageIcon()
  if false == _panel:GetShow() then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local player = selfPlayer:get()
  local premium = player:getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local applyPremium = player:isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_PremiumPackage)
  local self = MarketPlace
  local valuepack_x1, valuepack_y1, valuepack_x2, valuepack_y2 = 0, 0, 0, 0
  if true == applyPremium then
    if premium > 0 then
      if nil ~= PaGlobalFunc_PersonalIcon_GetIconType then
        self._ui.stc_ValuePack_Icon:addInputEvent("Mouse_On", "InputMO_PersonalIcon_ShowTooltip(true, " .. PaGlobalFunc_PersonalIcon_GetIconType().ValuePack .. ")")
      end
      valuepack_x1, valuepack_y1, valuepack_x2, valuepack_y2 = 103, 384, 133, 414
    else
      self._ui.stc_ValuePack_Icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 5)")
      valuepack_x1, valuepack_y1, valuepack_x2, valuepack_y2 = 103, 353, 133, 383
    end
  else
    self._ui.stc_ValuePack_Icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_SimpleToolTip(true, 5)")
    valuepack_x1, valuepack_y1, valuepack_x2, valuepack_y2 = 103, 353, 133, 383
  end
  self._ui.stc_ValuePack_Icon:ChangeTextureInfoName("renewal/pcremaster/remaster_market_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_ValuePack_Icon, valuepack_x1, valuepack_y1, valuepack_x2, valuepack_y2)
  self._ui.stc_ValuePack_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_ValuePack_Icon:setRenderTexture(self._ui.stc_ValuePack_Icon:getBaseTexture())
end
function PaGlobalFunc_MarketPlace_ShowToolTip(itemSSW, control, isItemMarket)
  Panel_Tooltip_Item_Show(itemSSW, control, true, false, nil, nil, isItemMarket)
end
function PaGlobalFunc_MarketPlace_TabTip(isShow, index)
  if MarketPlace._tabIdx.itemMarket == index then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TAB_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_TAB_DESC")
    uiControl = MarketPlace._ui.btn_MarketPlace
  elseif MarketPlace._tabIdx.wallet == index then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WALLET_TAB_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WALLET_TAB_DESC")
    uiControl = MarketPlace._ui.btn_Wallet
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_MarketPlace_SimpleToolTip(isShow, index)
  local self = MarketPlace
  name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETWEIGHT_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETWEIGHT_DESC")
  if 1 == index then
    uiControl = self._ui.stc_helpMarketplace
  elseif 2 == index then
    uiControl = self._ui.stc_helpWallet
  elseif 3 == index then
    uiControl = self._ui.txt_marketWeightTitleMarketplace
  elseif 4 == index then
    uiControl = self._ui.txt_marketWeightTitleWallet
  elseif 5 == index then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_UNAPPLIED_VALUE_PACKAGE")
    desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_UNAPPLIED_VALUE_PACKAGE_TOOLTIP_DESC", "forPremium", requestGetRefundPercentForPremiumPackage())
    uiControl = self._ui.stc_ValuePack_Icon
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobalFunc_Marketplace_GetPanel()
  return _panel
end
registerEvent("FromClient_UpdateCharge", "FromClient_ValuePackageIcon")
registerEvent("FromClient_LoadCompleteMsg", "FromClient_ValuePackageIcon")
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketPlace_Init")
function FGlobal_ItemMarketRegistItem_RegistDO()
end
function FGlobal_ItemMarketItemSet_Close()
end
function Panel_ItemMarket_BidDesc_Hide()
end
function FGlobal_ItemMarketRegistItem_Close()
end
function FGlobal_isOpenItemMarketBackPage()
  return false
end
function FGlobal_isItemMarketBuyConfirm()
  return false
end
function ItemMarket_getIsMarketItem()
  return false
end
