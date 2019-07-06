function PaGlobal_GuildHouse_Auction_Detail_All_Open(idx, tabType)
  UI.ASSERT_NAME(nil ~= idx, "PaGlobal_GuildHouse_Auction_Detail_All_Open\236\157\152 idx nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  UI.ASSERT_NAME(nil ~= tabType, "PaGlobal_GuildHouse_Auction_Detail_All_Open\236\157\152 tabType nil\236\157\180\235\169\180 \236\149\136\235\144\156\235\139\164.", "\234\185\128\236\156\164\236\167\128")
  PaGlobal_GuildHouse_Auction_Detail_All._houseIndex = idx
  PaGlobal_GuildHouse_Auction_Detail_All._houseTabType = tabType
  PaGlobal_GuildHouse_Auction_Detail_All:prepareOpen()
end
function PaGlobal_GuildHouse_Auction_Detail_All_Close()
  PaGlobal_GuildHouse_Auction_Detail_All:prepareClose()
end
function HandleEventLUp_GuildHouse_Auction_Detail_All_clickedCloseButton()
  PaGlobal_GuildHouse_Auction_Detail_All_Close()
end
function HandleEventLUp_GuildHouse_Auction_Detail_All_clickedBidButton()
  if true == PaGlobal_GuildHouse_Auction_Detail_All._isConsole and false == PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:GetShow() then
    return
  end
  HandleEventLUp_GuildHouse_Auction_All_clickedBidButton(PaGlobal_GuildHouse_Auction_Detail_All._houseIndex)
end
function FromClient_GuildHouse_Auction_Detail_All_ReSizePanel()
  if false == PaGlobal_GuildHouse_Auction_All._isConsole then
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close:ComputePos()
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:ComputePos()
  else
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom:ComputePos()
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel:ComputePos()
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:ComputePos()
  end
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:ComputePos()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:ComputePos()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:ComputePos()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_image:ComputePos()
end
function PaGlobal_GuildHouse_Auction_Detail_All_ShowAni()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
end
function PaGlobal_GuildHouse_Auction_Detail_All_HideAni()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
end
