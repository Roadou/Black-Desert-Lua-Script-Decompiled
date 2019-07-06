Panel_TerritoryAuth_Auction:SetShow(false, false)
Panel_TerritoryAuth_Auction:setMaskingChild(true)
Panel_TerritoryAuth_Auction:ActiveMouseEventEffect(true)
Panel_TerritoryAuth_Auction:RegisterShowEventFunc(true, "TerritoryAuth_AuctionShowAni()")
Panel_TerritoryAuth_Auction:RegisterShowEventFunc(false, "TerritoryAuth_AuctionHideAni()")
Panel_TerritoryAuth_Auction:setGlassBackground(true)
function TerritoryAuth_AuctionShowAni()
  UIAni.fadeInSCR_Down(Panel_TerritoryAuth_Auction)
end
function TerritoryAuth_AuctionHideAni()
  UIAni.closeAni(Panel_TerritoryAuth_Auction)
end
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local screenX, screenY
local maxCount = 5
local minBid = 10000
local isEnableSupplyTrade = ToClient_IsContentsGroupOpen("22")
local closeBtn = UI.getChildControl(Panel_TerritoryAuth_Auction, "Button_Win_Close")
local bidBtn = UI.getChildControl(Panel_TerritoryAuth_Auction, "Button_Biding")
local withdrawBidprice = UI.getChildControl(Panel_TerritoryAuth_Auction, "Button_MoneyBack")
local txtExplain = UI.getChildControl(Panel_TerritoryAuth_Auction, "StaticText_Explain")
local txtBidinFinish = UI.getChildControl(Panel_TerritoryAuth_Auction, "StaticText_BiddingFinish")
local txtRemainTime = UI.getChildControl(Panel_TerritoryAuth_Auction, "StaticText_Remain_Time")
local editBidPrice = UI.getChildControl(Panel_TerritoryAuth_Auction, "Edit_BidPrice")
local slotBG = UI.getChildControl(Panel_TerritoryAuth_Auction, "Static_SlotBG")
closeBtn:addInputEvent("Mouse_LUp", "Button_TerritoryAuthAuctionClose_Click()")
bidBtn:addInputEvent("Mouse_LUp", "Button_TerritoryAuthAuctionBid_Click()")
txtExplain:SetTextMode(UI_TM.eTextMode_AutoWrap)
editBidPrice:SetNumberMode(true)
local slotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createCooltime = true,
  createCash = true
}
local slots = {}
local slot_BG = {}
function TerritoryAuth_Resize()
end
function EventNotifyResponseAuctionInfo(goodsType, sendType, tempStr, tempStr2, bidRv, param1)
  local strGoodsType = ""
  local msg = ""
  if goodsType == CppEnums.AuctionType.AuctionGoods_House then
    if not ToClient_IsContentsGroupOpen("36") then
      return
    end
    strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_STRGOODSTYPE")
    if sendType == 0 then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE0_MSG", "tempStr", tempStr) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")
    elseif sendType == 1 then
      if 0 == bidRv then
        msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE1_MSG1", "tempStr", tempStr, "tempStr2", tempStr2)
      else
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_SENDTYPE1_MSG2", "tempStr", tempStr)
      end
    else
      _PA_ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\163\188\236\132\184\236\154\148")
    end
  elseif goodsType == CppEnums.AuctionType.AuctionGoods_TerritoryTradeAuthority then
    strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_9")
    if sendType == 0 then
      msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")
    elseif sendType == 1 then
      msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_8")
    else
      _PA_ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\163\188\236\132\184\236\154\148")
    end
  elseif goodsType == CppEnums.AuctionType.AuctionGoods_Villa then
    strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_15")
    if sendType == 0 then
      msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_7")
    elseif sendType == 1 then
      msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION", "tempStr", tempStr, "strGoodsType", strGoodsType) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_8")
    else
      _PA_ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\163\188\236\132\184\236\154\148")
    end
  elseif goodsType == CppEnums.AuctionType.AuctionGoods_Item then
    strGoodsType = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_16")
    if sendType == 0 then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_MASTERPIECEAUCTION_STARTMSG")
    elseif sendType == 1 then
      local itemKey = param1
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
      if nil == itemSSW then
        return
      end
      local itemName = itemSSW:getName()
      if 0 == bidRv then
        msg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MASTERPIECE_AUCTION_SUCCESS", "itemName", itemName, "familyName", tempStr)
      else
        msg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MASTERPIECE_AUCTION_FAIL", "itemName", itemName)
      end
    else
      _PA_ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\163\188\236\132\184\236\154\148")
    end
    local message = {
      main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION_MSG_MAIN", "strGoodsType", strGoodsType),
      sub = msg,
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3, 68)
    return
  else
    _PA_ASSERT(false, "\236\158\145\236\151\133\237\149\180\236\163\188\236\132\184\236\154\148")
  end
  if nil ~= Panel_Widget_ServantIcon then
    Panel_MyHouseNavi_Update(true)
  end
  local message = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_AUCTION_MSG_MAIN", "strGoodsType", strGoodsType),
    sub = msg,
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(message, 3, 7)
end
function EventNotifyBidAuctionGoods(goodsType, param1, param2)
  if goodsType == 2 then
    local text = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_NOTIFYBIDAUCTIONGOODS")
    Proc_ShowMessage_Ack(text)
  end
end
local bidButtonCheck = false
local function _buttonInit()
  withdrawBidprice:SetShow(false)
  editBidPrice:SetShow(false)
  editBidPrice:SetEditText("")
  bidBtn:SetShow(false)
  if true == bidButtonCheck then
    txtBidinFinish:SetShow(true)
  else
    txtBidinFinish:SetShow(false)
  end
end
local territoryAuth_AuctionProgress = false
function EventNotifyTerritoryTradeAuthority(msgType, territoryKey, bidPrice)
  _buttonInit()
  txtBidinFinish:SetShow(false)
  territoryAuth_AuctionProgress = false
  local territoryName = {
    [0] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_0")),
    [1] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_1")),
    [2] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_2")),
    [3] = tostring(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_3"))
  }
  if msgType == 0 then
    if nil ~= Panel_Widget_ServantIcon then
      Panel_MyHouseNavi_Update(true)
    end
  elseif msgType == 1 then
    local strDesc = territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_1")
    Proc_ShowMessage_Ack(strDesc)
  elseif msgType == 2 then
    TerritoryAuth_Auction_ShowToggle()
    local myAuctionInfo = RequestGetAuctionInfo()
    local tempPrice = myAuctionInfo:getTerritoryTradeBidPrice()
    if tempPrice > Defines.s64_const.s64_0 then
      local strbid = "<PAColor0xFF96D4FC>" .. makeDotMoney(bidPrice) .. "<PAOldColor> " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_2")
      txtBidinFinish:SetShow(true)
      txtBidinFinish:SetText(strbid)
    else
      editBidPrice:SetEditText("")
      editBidPrice:SetShow(true)
      bidBtn:SetShow(true)
    end
    TerritoryAuth_UpdateData()
  elseif msgType == 3 then
    local strDesc = territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_3")
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_BID"),
      sub = strDesc,
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3, 7)
  elseif msgType == 4 then
    local strDesc = territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_4")
    local message = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_RETURN"),
      sub = strDesc,
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(message, 3, 7)
  elseif msgType == 5 then
    TerritoryAuth_Auction_ShowToggle()
    withdrawBidprice:SetShow(true)
    withdrawBidprice:addInputEvent("Mouse_LUp", "Button_TerritoryTradeAuctionWithdrawMoney_Click(" .. bidPrice .. ")")
    TerritoryAuth_UpdateData()
  elseif msgType == 6 then
    Panel_TerritoryAuth_Auction:SetShow(true, true)
    territoryAuth_AuctionProgress = true
    TerritoryAuth_UpdateData()
  end
  if nil ~= Panel_Widget_ServantIcon then
    Panel_MyHouseNavi_Update(true)
  end
  txtExplain:SetText(territoryName[territoryKey] .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_5"))
end
function FromClientNotifySupplyTradeStart()
  if false == ToClient_IsContentsGroupOpen("26") then
    return
  end
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_IMPERIAL_START"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_10"),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 3, 8)
end
function FromClientNotifySupplyShopReset()
  if false == isEnableSupplyTrade then
    return
  end
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_MSG_MAIN"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_MSG_SUB"),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 3, 8)
end
function TerritoryAuth_UpdateData()
  local myAuctionInfo = RequestGetAuctionInfo()
  local itemCount = myAuctionInfo:getTerritoryTradeItemCount()
  local sizeX = slotBG:GetSizeX()
  local gap = sizeX * 0.6
  local startPosX = (Panel_TerritoryAuth_Auction:GetSizeX() - (sizeX * itemCount + gap * (itemCount - 1))) / 2
  if itemCount > 0 then
    local tradeCount = 0
    for i = 0, itemCount - 1 do
      local itemStaticWrapper = myAuctionInfo:getTerritoryTradeitem(i)
      if nil ~= itemStaticWrapper then
        slots[i]:setItemByStaticStatus(itemStaticWrapper)
        tradeCount = tradeCount + 1
        slots[i].icon:addInputEvent("Mouse_On", "TerritoryAuth_Tooltip_Show(" .. i .. ")")
        slots[i].icon:addInputEvent("Mouse_Out", "TerritoryAuth_Tooltip_Hide(" .. i .. ")")
        Panel_Tooltip_Item_SetPosition(i, slots[i], "TerritoryAuth_Auction")
        local posX = startPosX + (sizeX + gap) * i
        slots[i].icon:SetPosX(posX)
        slots[i].icon:SetPosY(sizeX * 1.2)
        slot_BG[i]:SetPosX(-4)
        slot_BG[i]:SetPosY(-4)
        slot_BG[i]:SetShow(true)
      else
        slots[i]:clearItem()
        slot_BG[i]:SetShow(false)
      end
    end
  end
  local s64_remainTime = myAuctionInfo:getTerritoryTradeAuctionRemainTime()
  local tempStr = ""
  if true == territoryAuth_AuctionProgress then
    tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_11") .. " : " .. TerritoryAuth_TimeFormatting(math.floor(Int64toInt32(s64_remainTime) / 1000))
  else
    tempStr = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_12") .. " : " .. TerritoryAuth_TimeFormatting(math.floor(Int64toInt32(s64_remainTime) / 1000))
  end
  txtRemainTime:SetText(tempStr)
  txtRemainTime:SetShow(false)
end
function TerritoryAuth_TimeFormatting(second)
  local formatter = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_HOUR"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_DAY")
  }
  local timeVal = {}
  timeVal[0] = math.floor(second / 60)
  timeVal[1] = math.floor(timeVal[0] / 60)
  timeVal[2] = math.floor(timeVal[1] / 24)
  local resultString = ""
  if 0 < timeVal[2] then
    resultString = timeVal[2] .. formatter[2]
  end
  if 0 < timeVal[1] then
    resultString = resultString .. " " .. timeVal[1] % 24 .. formatter[1]
  end
  if 0 < timeVal[0] then
    resultString = resultString .. " " .. timeVal[0] % 60 .. formatter[0]
  end
  if second < 60 then
    resultString = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_UNDER_ONEMINUTE")
  end
  return resultString
end
function Button_TerritoryAuthAuctionClose_Click()
  TerritoryAuth_Auction_ShowToggle()
end
function Button_TerritoryAuthAuctionBid_Click()
  if "" == editBidPrice:GetEditText() then
    return
  end
  local messageBoxMemo = makeDotMoney(tonumber(editBidPrice:GetEditText())) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_13")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_MESSAGE_14"),
    content = messageBoxMemo,
    functionYes = TerritoryAuth_BidAccept,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function TerritoryAuth_BidAccept()
  requestBidTerritoryTradeAuth(editBidPrice:GetEditText())
  bidButtonCheck = true
  local selfMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
  local _bidMoney = tonumber(editBidPrice:GetEditText())
  if _bidMoney >= minBid and selfMoney >= _bidMoney then
    txtBidinFinish:SetShow(false)
    editBidPrice:SetShow(false)
    bidBtn:SetShow(false)
    TerritoryAuth_Auction_ShowToggle()
  else
    txtBidinFinish:SetShow(false)
  end
end
function Button_TerritoryTradeAuctionWithdrawMoney_Click(bidPrice)
  requestWithdrawFailbidPriceForTerritoryTrade()
  TerritoryAuth_Auction_ShowToggle()
  local message = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_AUCTION_RETURN_MONEY", "bidPrice", makeDotMoney(bidPrice))
  Proc_ShowMessage_Ack_WithOut_ChattingMessage(message)
end
function TerritoryAuth_Auction_ShowToggle()
  if Panel_TerritoryAuth_Auction:GetShow() then
    Panel_TerritoryAuth_Auction:SetShow(false, false)
    bidButtonCheck = false
  else
    Panel_TerritoryAuth_Auction:SetShow(true, true)
  end
end
function TerritoryAuth_Auction_Close()
  Panel_TerritoryAuth_Auction:SetShow(false, false)
end
function TerritoryAuth_CreateSlot()
  for i = 0, maxCount - 1 do
    local slot = {}
    SlotItem.new(slot, "Territory_" .. i, i, Panel_TerritoryAuth_Auction, slotConfig)
    slot:createChild()
    slots[i] = slot
    local tempItemSlotBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.icon, "Static_Slot_" .. i)
    CopyBaseProperty(slotBG, tempItemSlotBG)
    slot_BG[i] = tempItemSlotBG
    slot_BG[i]:SetShow(false)
  end
end
function TerritoryAuth_Tooltip_Show(slotNo)
  Panel_Tooltip_Item_Show_GeneralStatic(slotNo, "TerritoryAuth_Auction", true)
end
function TerritoryAuth_Tooltip_Hide(slotNo)
  Panel_Tooltip_Item_Show_GeneralStatic(slotNo, "TerritoryAuth_Auction", false)
end
_buttonQuestion = UI.getChildControl(Panel_TerritoryAuth_Auction, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryAuth\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"TerritoryAuth\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"TerritoryAuth\", \"false\")")
TerritoryAuth_CreateSlot()
registerEvent("onScreenResize", "TerritoryAuth_Resize")
registerEvent("EventNotifyTerritoryTradeAuthority", "EventNotifyTerritoryTradeAuthority")
registerEvent("FromClientNotifySupplyTradeStart", "FromClientNotifySupplyTradeStart")
registerEvent("FromClient_ResponseAuctionInfo", "EventNotifyResponseAuctionInfo")
registerEvent("FromClient_BidAuctionGoods", "EventNotifyBidAuctionGoods")
registerEvent("FromClientNotifySupplyShopReset", "FromClientNotifySupplyShopReset")
