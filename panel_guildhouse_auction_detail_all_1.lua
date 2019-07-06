function PaGlobal_GuildHouse_Auction_Detail_All:initialize()
  if true == PaGlobal_GuildHouse_Auction_Detail_All._initialize then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All._isConsole = ToClient_isConsole()
  PaGlobal_GuildHouse_Auction_Detail_All:controlAll_Init()
  PaGlobal_GuildHouse_Auction_Detail_All:controlPc_Init()
  PaGlobal_GuildHouse_Auction_Detail_All:controlConsole_Init()
  PaGlobal_GuildHouse_Auction_Detail_All:SetUiSetting()
  if true == PaGlobal_GuildHouse_Auction_Detail_All._isConsole then
    local tempBtnGroup = {
      PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply,
      PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  PaGlobal_GuildHouse_Auction_Detail_All:registEventHandler()
  PaGlobal_GuildHouse_Auction_Detail_All:validate()
  PaGlobal_GuildHouse_Auction_Detail_All._initialize = true
end
function PaGlobal_GuildHouse_Auction_Detail_All:controlAll_Init()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Static_SubFrameBg")
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Static_DescBg")
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc = UI.getChildControl(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg, "StaticText_Desc")
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_image = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Static_Image")
end
function PaGlobal_GuildHouse_Auction_Detail_All:controlPc_Init()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Button_Win_Close_PCUI")
  PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Button_Bid_PCUI")
end
function PaGlobal_GuildHouse_Auction_Detail_All:controlConsole_Init()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom = UI.getChildControl(Panel_GuildHouse_Auction_Detail_All, "Static_Bottom_ConsoleUI")
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel = UI.getChildControl(PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom, "StaticText_Cancel")
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply = UI.getChildControl(PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom, "StaticText_Apply")
end
function PaGlobal_GuildHouse_Auction_Detail_All:SetUiSetting()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  if false == PaGlobal_GuildHouse_Auction_Detail_All._isConsole then
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom:SetShow(false)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel:SetShow(false)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:SetShow(false)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close:SetShow(true)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:SetShow(true)
    Panel_GuildHouse_Auction_Detail_All:SetSize(Panel_GuildHouse_Auction_Detail_All:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.PC_PANEL)
    PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.PC_BG)
  else
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close:SetShow(false)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:SetShow(false)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom:SetShow(true)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel:SetShow(true)
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:SetShow(true)
    Panel_GuildHouse_Auction_Detail_All:SetSize(Panel_GuildHouse_Auction_Detail_All:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.CONSOLE_PANEL)
    PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.CONSOLE_BG)
  end
  PaGlobal_GuildHouse_Auction_Detail_All:setNoticeDesc()
end
function PaGlobal_GuildHouse_Auction_Detail_All:setBidTypeUiSetting()
  if false == PaGlobal_GuildHouse_Auction_Detail_All._isConsole then
    if 0 == PaGlobal_GuildHouse_Auction_Detail_All._houseTabType then
      PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:SetShow(true)
      Panel_GuildHouse_Auction_Detail_All:SetSize(Panel_GuildHouse_Auction_Detail_All:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.PC_PANEL)
      PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.PC_BG)
    else
      PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:SetShow(false)
      Panel_GuildHouse_Auction_Detail_All:SetSize(Panel_GuildHouse_Auction_Detail_All:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.CONSOLE_PANEL)
      PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._sizeY.CONSOLE_BG)
    end
  elseif 0 == PaGlobal_GuildHouse_Auction_Detail_All._houseTabType then
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:SetShow(true)
  else
    PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:SetShow(false)
  end
end
function PaGlobal_GuildHouse_Auction_Detail_All:registEventHandler()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  registerEvent("onScreenResize", "FromClient_GuildHouse_Auction_Detail_All_ReSizePanel()")
  if false == PaGlobal_GuildHouse_Auction_Detail_All._isConsole then
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_Detail_All_clickedCloseButton()")
  end
end
function PaGlobal_GuildHouse_Auction_Detail_All:prepareOpen()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  if false == PaGlobal_GuildHouse_Auction_Detail_All._isConsole then
    PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_Detail_All_clickedBidButton(" .. PaGlobal_GuildHouse_Auction_Detail_All._houseIndex .. ")")
  else
    Panel_GuildHouse_Auction_Detail_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_GuildHouse_Auction_Detail_All_clickedBidButton(" .. PaGlobal_GuildHouse_Auction_Detail_All._houseIndex .. ")")
  end
  PaGlobal_GuildHouse_Auction_Detail_All:setNoticeDesc()
  PaGlobal_GuildHouse_Auction_Detail_All:setBidTypeUiSetting()
  PaGlobal_GuildHouse_Auction_Detail_All:open()
end
function PaGlobal_GuildHouse_Auction_Detail_All:open()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  Panel_GuildHouse_Auction_Detail_All:SetShow(true)
end
function PaGlobal_GuildHouse_Auction_Detail_All:prepareClose()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All:close()
end
function PaGlobal_GuildHouse_Auction_Detail_All:close()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  Panel_GuildHouse_Auction_Detail_All:SetShow(false)
end
function PaGlobal_GuildHouse_Auction_Detail_All:update()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
end
function PaGlobal_GuildHouse_Auction_Detail_All:validate()
  if nil == Panel_GuildHouse_Auction_Detail_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Detail_All:allValidate()
  PaGlobal_GuildHouse_Auction_Detail_All:pcValidate()
  PaGlobal_GuildHouse_Auction_Detail_All:consoleValidate()
end
function PaGlobal_GuildHouse_Auction_Detail_All:allValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_image:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:isValidate()
end
function PaGlobal_GuildHouse_Auction_Detail_All:pcValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_close:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui_pc.btn_bid:isValidate()
end
function PaGlobal_GuildHouse_Auction_Detail_All:consoleValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_bottom:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_cancel:isValidate()
  PaGlobal_GuildHouse_Auction_Detail_All._ui_console.stc_apply:isValidate()
end
function PaGlobal_GuildHouse_Auction_Detail_All:setNoticeDesc()
  if nil == Panel_GuildHouse_Auction_Detail_All or nil == PaGlobal_GuildHouse_Auction_Detail_All._houseIndex then
    return
  end
  local myAuctionInfo = RequestGetAuctionInfo()
  local price, houseAuctionInfo
  if 0 == PaGlobal_GuildHouse_Auction_Detail_All._houseTabType then
    houseAuctionInfo = myAuctionInfo:getHouseAuctionListAt(PaGlobal_GuildHouse_Auction_Detail_All._houseIndex)
    price = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDHOUSE_AUCTION_LOWPRICE") .. makeDotMoney(houseAuctionInfo:getPrice_s64())
  else
    houseAuctionInfo = myAuctionInfo:getMyBidListAt(PaGlobal_GuildHouse_Auction_Detail_All._houseIndex)
    price = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_BIDPRICE") .. makeDotMoney(houseAuctionInfo:getMyBidPrice_s64())
  end
  if nil == myAuctionInfo or nil == houseAuctionInfo then
    return
  end
  local name = houseAuctionInfo:getGoodsName() .. "\n"
  local area = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_AREA") .. " " .. tostring(Uint64toUint32(houseAuctionInfo:getGoodsArea())) .. "\n"
  local featureText = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEAUCTION_SPECIAL") .. " " .. houseAuctionInfo:getGoodsFeature1() .. " " .. houseAuctionInfo:getGoodsFeature2() .. "\n"
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:SetText(name .. area .. featureText .. price)
  if PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:GetSizeY() < PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:GetTextSizeY() then
    local sizeY = PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_desc:GetTextSizeY() - PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:GetSizeY() + 15
    Panel_GuildHouse_Auction_Detail_All:SetSize(Panel_GuildHouse_Auction_Detail_All:GetSizeX(), Panel_GuildHouse_Auction_Detail_All:GetSizeY() + sizeY)
    PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_descBg:GetSizeY() + sizeY)
    PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:SetSize(PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeX(), PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_subFrameBg:GetSizeY() + sizeY)
  end
  PaGlobal_GuildHouse_Auction_Detail_All._ui.stc_image:ChangeTextureInfoName(houseAuctionInfo:getGoodsScreenShotPath(0))
  FromClient_GuildHouse_Auction_Detail_All_ReSizePanel()
end
