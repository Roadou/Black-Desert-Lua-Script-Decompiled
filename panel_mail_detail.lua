Panel_Mail_Detail:ActiveMouseEventEffect(true)
Panel_Mail_Detail:setGlassBackground(true)
Panel_Mail_Detail:RegisterShowEventFunc(true, "Mail_Detail_ShowAni()")
Panel_Mail_Detail:RegisterShowEventFunc(false, "Mail_Detail_HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
function Mail_Detail_ShowAni()
  audioPostEvent_SystemUi(1, 0)
  UIAni.fadeInSCR_Left(Panel_Mail_Detail)
end
function Mail_Detail_HideAni()
  audioPostEvent_SystemUi(1, 1)
  Panel_Mail_Detail:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local mailHideAni = Panel_Mail_Detail:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  mailHideAni:SetStartColor(UI_color.C_FFFFFFFF)
  mailHideAni:SetEndColor(UI_color.C_00FFFFFF)
  mailHideAni:SetStartIntensity(3)
  mailHideAni:SetEndIntensity(1)
  mailHideAni.IsChangeChild = true
  mailHideAni:SetHideAtEnd(true)
  mailHideAni:SetDisableWhileAni(true)
end
local _frame = UI.getChildControl(Panel_Mail_Detail, "Frame_MailText")
local _frameContents = UI.getChildControl(_frame, "Frame_Contents")
local _frameScroll = UI.getChildControl(_frame, "Frame_Scroll")
local _frameScroll_Btn = UI.getChildControl(_frameScroll, "Scroll_Bar_CtrlButton")
local panel_SizeY = Panel_Mail_Detail:GetSizeY()
local mailDetail = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createMailCount = false,
    createEnchant = true,
    createCash = true
  },
  config = {slotX = 4, slotY = 4},
  _sender = UI.getChildControl(Panel_Mail_Detail, "StaticText_Sender"),
  _title = UI.getChildControl(Panel_Mail_Detail, "StaticText_Subtitle"),
  _contents = UI.getChildControl(_frameContents, "StaticText_Content"),
  _itemText = UI.getChildControl(Panel_Mail_Detail, "StaticText_Item_Message"),
  _iconBase = UI.getChildControl(Panel_Mail_Detail, "Static_Itemicon"),
  _buttonDelete = UI.getChildControl(Panel_Mail_Detail, "Button_Delete"),
  _buttonReceive = UI.getChildControl(Panel_Mail_Detail, "Button_Receive"),
  _buttonClose = UI.getChildControl(Panel_Mail_Detail, "Button_Win_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Mail_Detail, "Button_Question"),
  _checkboxToWarehouse = UI.getChildControl(Panel_Mail_Detail, "CheckButton_Warehouse"),
  _itemCount = UI.getChildControl(Panel_Mail_Detail, "StaticText_ItemCount"),
  _bottomBG = UI.getChildControl(Panel_Mail_Detail, "Static_Content"),
  _itemSlot = {},
  openMailNo = nil
}
function mailDetail:init()
  UI.ASSERT(nil ~= self._sender and "number" ~= type(self._sender), "StaticText_Sender")
  UI.ASSERT(nil ~= self._title and "number" ~= type(self._title), "StaticText_Subtitle")
  UI.ASSERT(nil ~= self._contents and "number" ~= type(self._contents), "StaticText_Content")
  UI.ASSERT(nil ~= self._itemText and "number" ~= type(self._itemText), "StaticText_Item_Message")
  UI.ASSERT(nil ~= self._iconBase and "number" ~= type(self._iconBase), "Static_Itemicon")
  UI.ASSERT(nil ~= self._buttonDelete and "number" ~= type(self._buttonDelete), "Button_Delete")
  UI.ASSERT(nil ~= self._buttonClose and "number" ~= type(self._buttonClose), "Button_Win_Close")
  SlotItem.new(self._itemSlot, "ItemIconSlot_", 0, self._iconBase, self.slotConfig)
  self._itemSlot:createChild()
  self._itemSlot.icon:SetPosX(self.config.slotX)
  self._itemSlot.icon:SetPosY(self.config.slotY)
  self._itemSlot.icon:addInputEvent("Mouse_On", "Mail_ShowItemToolTip()")
  self._itemSlot.icon:addInputEvent("Mouse_Out", "Mail_HideItemToolTip()")
  self._iconBase:SetShow(false)
  self._checkboxToWarehouse:SetCheck(false)
  self._checkboxToWarehouse:SetShow(false)
  self._bottomBG:SetShow(true)
  self._checkboxToWarehouse:SetText(self._checkboxToWarehouse:GetText())
  self._checkboxToWarehouse:SetEnableArea(0, 0, self._checkboxToWarehouse:GetTextSizeX() + 30, 25)
end
function Mail_ShowItemToolTip()
  local self = mailDetail
  if 1 == RequestMail_getMailType() then
    local productKeyRaw = RequestMail_getMailCashProductNoRaw()
    FGlobal_CashShop_GoodsTooltipInfo_Open(productKeyRaw, self._itemSlot.icon)
  elseif 2 == RequestMail_getMailType() then
    local mailIESS = RequestMail_getMailItemWrapper()
    Panel_Tooltip_Item_Show(mailIESS, self._itemSlot.icon, false, true, nil)
  else
    local mailIESS = mail_getMailItemStatic()
    Panel_Tooltip_Item_Show(mailIESS, self._itemSlot.icon, true, false, nil)
  end
end
function Mail_HideItemToolTip()
  if 1 == RequestMail_getMailType() then
    FGlobal_CashShop_GoodsTooltipInfo_Close()
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FromClient_ResponseMailGetItem(itemKey, itemCount_s64, immediateItem, isRelay)
  local self = mailDetail
  if 1 ~= itemKey and not immediateItem then
    return
  end
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local itemName = itemESSW:getName()
  local isWarehouse = self._checkboxToWarehouse:IsCheck()
  if immediateItem then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ALERT_IMMEDIATEITEM", "itemName", itemName))
  elseif 1 == itemKey and (isWarehouse or isRelay) then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ALERT_GET_WAREHOUSE", "itemName", itemName, "itemCount", makeDotMoney(itemCount_s64)))
  end
end
function mailDetail:registMessageHandler()
  registerEvent("ResponseMail_showDetail", "Mail_Detail_Open")
  registerEvent("FromClient_ResponseMailGetItem", "FromClient_ResponseMailGetItem")
end
function mailDetail:registEventHandler()
  self._buttonClose:addInputEvent("Mouse_LUp", "Mail_Detail_Close()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelMailDetail\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelMailDetail\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelMailDetail\", \"false\")")
  self._buttonDelete:addInputEvent("Mouse_LUp", "Mail_Detail_Delete()")
  self._itemSlot.icon:addInputEvent("Mouse_RUp", "Mail_Detail_GetItem()")
  self._buttonReceive:addInputEvent("Mouse_LUp", "Mail_Detail_GetItem()")
end
function Mail_Detail_Open(mailNo)
  if not Panel_Mail_Detail:IsShow() then
    Panel_Mail_Detail:SetShow(true, true)
  end
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_Tooltip_Item_hideTooltip()
  local self = mailDetail
  self.openMailNo = mailNo
  self._sender:SetText(RequestMail_getMailSenderName())
  self._title:SetText(RequestMail_getMailTitle())
  self._contents:SetAutoResize(true)
  self._contents:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._contents:SetText(RequestMail_getMailContents())
  local textSizeY = self._contents:GetSizeY()
  local frameSizeY = _frame:GetSizeY()
  _frameContents:SetSize(_frameContents:GetSizeX(), textSizeY)
  UIScroll.SetButtonSize(_frameScroll, frameSizeY, textSizeY)
  _frameScroll:SetControlPos(0)
  self._bottomBG:SetShow(true)
  self._buttonDelete:SetSpanSize(10, 14)
  if 1 == RequestMail_getMailType() then
    local mailCashProductNoRaw = RequestMail_getMailCashProductNoRaw()
    local cPSSW
    if 0 ~= mailCashProductNoRaw then
      cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(mailCashProductNoRaw)
    end
    local itemCount_s64 = RequestMail_getMailItemCount()
    local itemCount = Int64toInt32(itemCount_s64)
    self._itemText:SetShow(itemCount > 1)
    self._itemCount:SetShow(itemCount > 1)
    local itemCountString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ITEM_COUNT_TITLE", "count", makeDotMoney(itemCount))
    self._itemCount:SetText(itemCountString)
    if nil ~= cPSSW then
      self._itemSlot:clearItem()
      self._itemSlot:setItemByCashProductStaticStatus(cPSSW, RequestMail_getMailItemCount())
      self._iconBase:SetShow(true)
      self._itemSlot.icon:SetShow(true)
      self._itemText:SetShow(true)
      self._itemText:SetSpanSize(80, 520)
      self._buttonReceive:SetShow(true)
      self._checkboxToWarehouse:SetCheck(false)
      self._checkboxToWarehouse:SetShow(false)
      Panel_Mail_Detail:SetSize(Panel_Mail_Detail:GetSizeX(), panel_SizeY)
    else
      self._itemSlot:clearItem()
      self._iconBase:SetShow(false)
      self._itemSlot.icon:SetShow(false)
      self._itemText:SetShow(false)
      self._buttonReceive:SetShow(false)
      self._checkboxToWarehouse:SetCheck(false)
      self._checkboxToWarehouse:SetShow(false)
      Panel_Mail_Detail:SetSize(Panel_Mail_Detail:GetSizeX(), panel_SizeY)
    end
  else
    local mailItem = mail_getMailItemStatic()
    if nil ~= mailItem then
      self._itemSlot:clearItem()
      self._itemSlot:setItemByStaticStatus(mailItem, RequestMail_getMailItemCount())
      self._iconBase:SetShow(true)
      self._itemSlot.icon:SetShow(true)
      self._itemText:SetShow(true)
      self._buttonReceive:SetShow(true)
      self._checkboxToWarehouse:SetCheck(false)
      local itemKey = mailItem:get()._key:getItemKey()
      local itemCount_s64 = RequestMail_getMailItemCount()
      local itemCount = itemCount_s64
      local silverString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_SILVER_COUNT_TITLE", "value", makeDotMoney(itemCount_s64))
      local itemCountString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ITEM_COUNT_TITLE", "count", makeDotMoney(itemCount_s64))
      self._itemCount:SetShow(itemCount > toInt64(0, 1))
      if 1 == itemKey then
        self._itemCount:SetText(silverString)
      else
        self._itemCount:SetText(itemCountString)
      end
      local isMoney = mailItem:isMoney()
      if true == isMoney then
        self._checkboxToWarehouse:SetShow(true)
      else
        self._checkboxToWarehouse:SetShow(false)
      end
      self._bottomBG:SetShow(true)
      Panel_Mail_Detail:SetSize(Panel_Mail_Detail:GetSizeX(), panel_SizeY)
    else
      self._bottomBG:SetShow(false)
      self._itemSlot:clearItem()
      self._iconBase:SetShow(false)
      self._itemSlot.icon:SetShow(false)
      self._itemText:SetShow(false)
      self._buttonReceive:SetShow(false)
      self._itemCount:SetShow(false)
      self._checkboxToWarehouse:SetCheck(false)
      self._checkboxToWarehouse:SetShow(false)
      Panel_Mail_Detail:SetSize(Panel_Mail_Detail:GetSizeX(), panel_SizeY)
    end
  end
  mailDetail._buttonDelete:ComputePos()
end
function Mail_Detail_Close()
  if Panel_Mail_Detail:IsShow() then
    Panel_Mail_Detail:SetShow(false, true)
  end
  mailDetail.openMailNo = nil
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_Tooltip_Item_hideTooltip()
end
function Mail_Detail_Delete()
  if nil ~= mailDetail.openMailNo then
    RequestMail_removeMail(mailDetail.openMailNo, true)
    mailDetail.openMailNo = nil
  end
  Mail_Detail_Close()
end
function Mail_Detail_GetItem()
  local self = mailDetail
  warehouse_requestInfoByCurrentRegionMainTown()
  local itemWhereType = CppEnums.ItemWhereType.eInventory
  local giftCount_s64 = RequestMail_getMailItemCount()
  if giftCount_s64 > toInt64(0, 1) then
    local function getMygift(count_s64)
      local isWarehouseCheck = self._checkboxToWarehouse:IsCheck()
      if true == isWarehouseCheck then
        itemWhereType = CppEnums.ItemWhereType.eWarehouse
      elseif false == isWarehouseCheck then
        itemWhereType = CppEnums.ItemWhereType.eInventory
      end
      RequestMail_receiveMailItem(count_s64, itemWhereType)
      return
    end
    Panel_NumberPad_Show(true, giftCount_s64, nil, getMygift, false, nil)
  else
    local isWarehouseCheck = self._checkboxToWarehouse:IsCheck()
    if true == isWarehouseCheck then
      itemWhereType = CppEnums.ItemWhereType.eWarehouse
    elseif false == isWarehouseCheck then
      itemWhereType = CppEnums.ItemWhereType.eInventory
    end
    RequestMail_receiveMailItem(toInt64(0, 1), itemWhereType)
    return
  end
  PaGlobalFunc_Widget_Alert_Check_Mail()
end
mailDetail:init()
mailDetail:registEventHandler()
mailDetail:registMessageHandler()
