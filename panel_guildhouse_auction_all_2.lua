function PaGlobal_GuildHouse_Auction_All_Open()
  PaGlobal_GuildHouse_Auction_All:prepareOpen()
end
function PaGlobal_GuildHouse_Auction_All_Close()
  if nil ~= Panel_GuildHouse_Auction_Detail_All and true == Panel_GuildHouse_Auction_Detail_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Detail_All_Close()
  end
  if nil ~= Panel_GuildHouse_Auction_Bid_All and true == Panel_GuildHouse_Auction_Bid_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Bid_All_Close()
  end
  PaGlobal_GuildHouse_Auction_All:prepareClose()
end
function HandleEventLUp_GuildHouse_Auction_All_clickedTypeButton()
  local movePosX = 0
  if true == PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:IsChecked() then
    movePosX = PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:GetPosX() + PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:GetSizeX() / 3
    PaGlobal_GuildHouse_Auction_All._ui.stc_selectBar:SetPosX(movePosX)
    for key, value in pairs(PaGlobal_GuildHouse_Auction_All._houseAuctionList) do
      value:SetShow(false)
    end
    for key, value in pairs(PaGlobal_GuildHouse_Auction_All._houseMyBidList) do
      value:SetShow(false)
    end
    for index = 0, PaGlobal_GuildHouse_Auction_All._houseAuctionCnt - 1 do
      PaGlobal_GuildHouse_Auction_All._houseAuctionList[index]:SetShow(true)
    end
  else
    RequestBiddingPage()
    movePosX = PaGlobal_GuildHouse_Auction_All._ui.btn_myBid:GetPosX() + PaGlobal_GuildHouse_Auction_All._ui.btn_myBid:GetSizeX() / 3
    PaGlobal_GuildHouse_Auction_All._ui.stc_selectBar:SetPosX(movePosX)
    for key, value in pairs(PaGlobal_GuildHouse_Auction_All._houseAuctionList) do
      value:SetShow(false)
    end
    for key, value in pairs(PaGlobal_GuildHouse_Auction_All._houseMyBidList) do
      value:SetShow(false)
    end
    for index = 0, PaGlobal_GuildHouse_Auction_All._houseBidCnt - 1 do
      PaGlobal_GuildHouse_Auction_All._houseMyBidList[index]:SetShow(true)
    end
  end
end
function HandleEventLUp_GuildHouse_Auction_All_clickedListButton(idx, tabType)
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All_Open(idx, tabType)
end
function HandleEventLUp_GuildHouse_Auction_All_clickedCancelButton(index)
  RequestAuction_CancelGoods(index)
end
function HandleEventLUp_GuildHouse_Auction_All_clickedBidButton(index)
  PaGlobal_GuildHouse_Auction_Bid_All_Open(index)
end
function HandleEventLUp_GuildHouse_Auction_All_clickedPrevButton()
  ClearFocusEdit()
  RequestAuctionPrevPage()
end
function HandleEventLUp_GuildHouse_Auction_All_clickedNextButton()
  local myAuctionInfo = RequestGetAuctionInfo()
  local houseCount = myAuctionInfo:getHouseAuctionListCount()
  if houseCount >= 4 then
    ClearFocusEdit()
    RequestAuctionNextPage()
    return true
  else
    return false
  end
end
function Input_GuildHouse_Auction_All_ChangeType()
  if true == PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:IsChecked() then
    PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:SetCheck(true)
    PaGlobal_GuildHouse_Auction_All._ui.btn_myBid:SetCheck(false)
    RequestAuctionListPage()
    PaGlobal_GuildHouse_Auction_All:updateHouseAuctionList()
  else
    PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:SetCheck(false)
    PaGlobal_GuildHouse_Auction_All._ui.btn_myBid:SetCheck(true)
    RequestBiddingPage()
    PaGlobal_GuildHouse_Auction_All:updateHouseBidList()
  end
  HandleEventLUp_GuildHouse_Auction_All_clickedTypeButton()
end
function FromClient_GuildHouse_Auction_All_ReSizePanel()
  if false == PaGlobal_GuildHouse_Auction_All._isConsole then
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_close:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_question:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listLeft:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listRight:ComputePos()
  else
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_LT:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_RT:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_listLeft:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_listRight:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.stc_bottomBg:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_viewInfo:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_close:ComputePos()
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_bid:ComputePos()
  end
  PaGlobal_GuildHouse_Auction_All._ui.stc_title:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.stc_tapBg:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.btn_myBid:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.stc_selectBar:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.stc_subPage:ComputePos()
  PaGlobal_GuildHouse_Auction_All._ui.stc_subPageTitle:ComputePos()
end
function FromClient_GuildHouse_Auction_All_UpdateGuildHouseAuctionList()
  local myAuctionInfo = RequestGetAuctionInfo()
  local auctionType = myAuctionInfo:getAuctionType()
  local houseListCount = myAuctionInfo:getHouseAuctionListCount()
  local bidListCount = myAuctionInfo:getMyBidListCount()
  local houseMaxCount = houseListCount / 4 + 1
  if tonumber(string.sub(houseMaxCount, 1, 1)) == myAuctionInfo:getCurrentPage() + 1 then
    if false == PaGlobal_GuildHouse_Auction_All._isConsole then
      PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listRight:SetIgnore(true)
    else
      PaGlobal_GuildHouse_Auction_All._ui_console.btn_listRight:SetIgnore(true)
    end
  elseif false == PaGlobal_GuildHouse_Auction_All._isConsole then
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listRight:SetIgnore(false)
  else
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_listRight:SetIgnore(false)
  end
  if myAuctionInfo:getCurrentPage() + 1 == 1 then
    if false == PaGlobal_GuildHouse_Auction_All._isConsole then
      PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listLeft:SetIgnore(true)
    else
      PaGlobal_GuildHouse_Auction_All._ui_console.btn_listLeft:SetIgnore(true)
    end
  elseif false == PaGlobal_GuildHouse_Auction_All._isConsole then
    PaGlobal_GuildHouse_Auction_All._ui_pc.btn_listLeft:SetIgnore(false)
  else
    PaGlobal_GuildHouse_Auction_All._ui_console.btn_listLeft:SetIgnore(false)
  end
  local subPageTitle = myAuctionInfo:getCurrentPage() + 1 .. " / " .. PaGlobal_GuildHouse_Auction_All._maxPage
  if true == PaGlobal_GuildHouse_Auction_All._isCheckMaxPage then
    PaGlobal_GuildHouse_Auction_All:getMaxPage()
  end
  if true == PaGlobal_GuildHouse_Auction_All._ui.btn_allBid:IsChecked() then
    PaGlobal_GuildHouse_Auction_All._ui.stc_subPageTitle:SetText(subPageTitle)
  else
    PaGlobal_GuildHouse_Auction_All._ui.stc_subPageTitle:SetText("1 / 1")
  end
  if auctionType == 1 then
    if false == Panel_GuildHouse_Auction_All:GetShow() then
      PaGlobal_GuildHouse_Auction_All_Open()
    end
    PaGlobal_GuildHouse_Auction_All:updateHouseAuctionList()
    PaGlobal_GuildHouse_Auction_All:updateHouseBidList()
  elseif auctionType == 14 then
    Panel_Villa_Auction:SetShow(true, true)
    FGlobal_VillaAuctionUpdate()
  elseif auctionType == 5 then
    PaGlobal_GuildHouse_Auction_All:updateHouseBidList()
  end
end
function PaGloabl_GuildHouse_Auction_All_ShowAni()
  if nil == Panel_GuildHouse_Auction_All then
    return
  end
end
function PaGloabl_GuildHouse_Auction_All_HideAni()
  if nil == Panel_GuildHouse_Auction_All then
    return
  end
end
