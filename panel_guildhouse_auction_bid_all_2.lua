function PaGlobal_GuildHouse_Auction_Bid_All_Open(idx)
  UI.ASSERT_NAME(nil ~= idx, "PaGlobal_GuildHouse_Auction_Bid_All_Open\236\157\152 idx nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  PaGlobal_GuildHouse_Auction_Bid_All._bidIndex = idx
  PaGlobal_GuildHouse_Auction_Bid_All:prepareOpen()
end
function PaGlobal_GuildHouse_Auction_Bid_All_Close()
  PaGlobal_GuildHouse_Auction_Bid_All:prepareClose()
end
function HandleEventLUp_GuildHouse_Auction_All_clickedConfirm()
  if nil == PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDHOUSE_AUCTION_WRONGPRICE"))
    return
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseAuctionNowPrice = myAuctionInfo:getHouseAuctionListAt(PaGlobal_GuildHouse_Auction_Bid_All._bidIndex)
  if houseAuctionNowPrice:getPrice_s64() <= PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice then
    ClearFocusEdit()
    RequestBidAuction(PaGlobal_GuildHouse_Auction_Bid_All._bidIndex, PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice)
    PaGlobal_GuildHouse_Auction_Bid_All_Close()
  else
    ClearFocusEdit()
    RequestBidAuction(PaGlobal_GuildHouse_Auction_Bid_All._bidIndex, PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice)
    RequestAuctionListPage()
    PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_aucPrice:SetEditText("")
    PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice = nil
  end
end
function HandleEventLUp_GuildHouse_Auction_All_clickedCancel()
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_aucPrice:SetEditText("", true)
  PaGlobal_GuildHouse_Auction_Bid_All_Close()
end
function HandleEventLUp_GuildHouse_Auction_All_clickedEdit()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  local myGuildMoney = myGuildListInfo:getGuildBusinessFunds_s64()
  Panel_NumberPad_Show(true, myGuildMoney, nil, PaGlobal_GuildHouse_Auction_Bid_All_AuctionConfirmFunction, false, nil, false)
end
function PaGlobal_GuildHouse_Auction_Bid_All_AuctionConfirmFunction(param0)
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_aucPrice:SetEditText(makeDotMoney(param0))
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_aucPrice:ComputePos()
  PaGlobal_GuildHouse_Auction_Bid_All._auctionPrice = param0
end
function FromClient_GuildHouse_Auction_Bid_All_ReSizePanel()
  if false == PaGlobal_GuildHouse_Auction_Bid_All._isConsole then
    PaGlobal_GuildHouse_Auction_Bid_All._ui_pc.btn_cancel:ComputePos()
    PaGlobal_GuildHouse_Auction_Bid_All._ui_pc.btn_confirm:ComputePos()
    PaGlobal_GuildHouse_Auction_Bid_All._ui_pc.btn_close:ComputePos()
  else
    PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_bottomBg:ComputePos()
    PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_selectA:ComputePos()
    PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_cancelB:ComputePos()
    PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_keyGuideX:ComputePos()
  end
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_bidBg:ComputePos()
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_aucPrice:ComputePos()
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_icon:ComputePos()
  PaGlobal_GuildHouse_Auction_Bid_All._ui.stc_warehouseMoney:ComputePos()
end
function PaGlobal_GuildHouse_Auction_Bid_All_ShowAni()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
end
function PaGlobal_GuildHouse_Auction_Bid_All_HideAni()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
end
