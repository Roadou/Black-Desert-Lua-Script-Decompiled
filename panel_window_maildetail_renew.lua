local _panel = Panel_Window_MailDetail_Renew
_panel:ActiveMouseEventEffect(true)
_panel:setGlassBackground(true)
_panel:RegisterShowEventFunc(true, "Mail_Detail_ShowAni()")
_panel:RegisterShowEventFunc(false, "Mail_Detail_HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
function Mail_Detail_ShowAni()
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  UIAni.fadeInSCR_Left(_panel)
end
function Mail_Detail_HideAni()
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  _panel:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local mailHideAni = _panel:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  mailHideAni:SetStartColor(UI_color.C_FFFFFFFF)
  mailHideAni:SetEndColor(UI_color.C_00FFFFFF)
  mailHideAni:SetStartIntensity(3)
  mailHideAni:SetEndIntensity(1)
  mailHideAni.IsChangeChild = true
  mailHideAni:SetHideAtEnd(true)
  mailHideAni:SetDisableWhileAni(true)
end
local panel_SizeY = _panel:GetSizeY()
local mailDetail = {
  _ui = {
    stc_topBG = UI.getChildControl(_panel, "Static_TopBg"),
    stc_centerBG = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    _frame = nil,
    _frameContents = nil,
    _frameScroll = nil,
    _sender = nil,
    _title = nil,
    _contents = nil,
    txt_itemEnclosed = nil,
    stc_slotBG = nil,
    _buttonDelete = nil,
    _buttonReceive = nil,
    _buttonClose = nil,
    _buttonQuestion = nil,
    slot_item = {},
    stc_line = {},
    txt_keyGuideA = nil,
    txt_keyGuideX = nil,
    txt_keyGuideY = nil
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createEnchant = true,
    createCash = true
  },
  config = {slotX = 5, slotY = 5},
  openMailNo = nil
}
function FromClient_luaLoadComplete_MailDetail_Init()
  mailDetail:init()
  mailDetail:registEventHandler()
  mailDetail:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MailDetail_Init")
function mailDetail:init()
  self._ui._frame = UI.getChildControl(self._ui.stc_centerBG, "Frame_MailText")
  self._ui._frameContents = self._ui._frame:GetFrameContent()
  self._ui._frameScroll = self._ui._frame:GetVScroll()
  self._ui._sender = UI.getChildControl(self._ui.stc_centerBG, "StaticText_Sender")
  self._ui._sender:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._title = UI.getChildControl(self._ui.stc_centerBG, "StaticText_Title")
  self._ui._title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._contents = UI.getChildControl(self._ui._frameContents, "StaticText_MailContent")
  self._ui.txt_itemEnclosed = UI.getChildControl(self._ui.stc_centerBG, "StaticText_ItemEnclosed")
  self._ui.stc_slotBG = UI.getChildControl(self._ui.stc_centerBG, "Static_ItemSlotBg")
  for ii = 1, 4 do
    self._ui.stc_line[ii] = UI.getChildControl(self._ui.stc_centerBG, "Static_Line" .. ii)
  end
  self._ui._buttonDelete = UI.getChildControl(self._ui.stc_bottomBG, "Button_Delete")
  SlotItem.new(self._ui.slot_item, "ItemIconSlot_", 0, self._ui.stc_slotBG, self.slotConfig)
  self._ui.slot_item:createChild()
  self._ui.slot_item.icon:SetPosX(self.config.slotX)
  self._ui.slot_item.icon:SetPosY(self.config.slotY)
  self._ui.txt_itemName = UI.getChildControl(self._ui.stc_centerBG, "StaticText_ItemName")
  self._ui.txt_itemName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_itemCount = UI.getChildControl(self._ui.stc_centerBG, "StaticText_ItemCount")
  self._ui.txt_itemCount:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_ReceiveItem")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_ReceiveToWarehouse")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_MailDelete")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_Close")
  self._ui.stc_slotBG:SetShow(false)
end
function mailDetail:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_MailDetail_Delete()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Mail_Detail_GetItem(false)")
end
function PaGlobal_MailDetail_GetOpenMailNumber()
  if nil == Panel_Window_MailDetail_Renew or nil == mailDetail.openMailNo then
    return false
  end
  return mailDetail.openMailNo
end
function mailDetail:registMessageHandler()
  registerEvent("ResponseMail_showDetail", "Mail_Detail_Open")
  registerEvent("FromClient_ResponseMailGetItem", "FromClient_ResponseMailGetItem")
end
function Mail_Detail_Open(mailNo)
  if not _panel:IsShow() then
    _panel:SetShow(true, true)
  elseif Panel_Window_Mail_Renew:GetShow() then
    ToClient_padSnapSetTargetPanel(_panel)
  end
  if Panel_Window_Mail_Renew:GetShow() then
    _panel:SetPosX(Panel_Window_Mail_Renew:GetPosX() - _panel:GetSizeX())
    _panel:SetPosY(Panel_Window_Mail_Renew:GetPosY())
  end
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_Tooltip_Item_hideTooltip()
  local self = mailDetail
  self.openMailNo = mailNo
  self._ui._sender:SetText(RequestMail_getMailSenderName())
  self._ui._title:SetText(RequestMail_getMailTitle())
  self._ui._contents:SetAutoResize(true)
  self._ui._contents:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._contents:SetText(RequestMail_getMailContents())
  local textSizeY = self._ui._contents:GetSizeY()
  local frameSizeY = self._ui._frame:GetSizeY()
  self._ui._frameContents:SetSize(self._ui._frameContents:GetSizeX(), textSizeY)
  UIScroll.SetButtonSize(self._ui._frameScroll, frameSizeY, textSizeY)
  self._ui._frameScroll:SetControlPos(0)
  if 1 == RequestMail_getMailType() then
    local mailCashProductNoRaw = RequestMail_getMailCashProductNoRaw()
    local cPSSW
    if 0 ~= mailCashProductNoRaw then
      cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(mailCashProductNoRaw)
    end
    self._ui.txt_keyGuideX:SetShow(false)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    if nil ~= cPSSW then
      self._ui.slot_item:clearItem()
      self._ui.slot_item:setItemByCashProductStaticStatus(cPSSW, RequestMail_getMailItemCount())
      self._ui.stc_slotBG:SetShow(true)
      self._ui.slot_item.icon:SetShow(true)
      self._ui.txt_itemEnclosed:SetShow(true)
      self._ui.txt_keyGuideA:SetShow(true)
      self._ui.txt_itemName:SetText(cPSSW:getName())
      self._ui.txt_itemCount:SetText(self:getCountString(RequestMail_getMailItemCount()))
      self._ui.txt_itemName:SetShow(true)
      self._ui.txt_itemCount:SetShow(true)
      _panel:SetSize(_panel:GetSizeX(), panel_SizeY)
      self._ui.stc_bottomBG:ComputePos()
    else
      self._ui.slot_item:clearItem()
      self._ui.stc_slotBG:SetShow(false)
      self._ui.slot_item.icon:SetShow(false)
      self._ui.txt_itemEnclosed:SetShow(false)
      self._ui.txt_keyGuideA:SetShow(false)
      self._ui.txt_itemName:SetShow(false)
      self._ui.txt_itemCount:SetShow(false)
      _panel:SetSize(_panel:GetSizeX(), panel_SizeY - 45)
      self._ui.stc_bottomBG:ComputePos()
    end
  else
    local mailItem = mail_getMailItemStatic()
    if nil ~= mailItem then
      self._ui.slot_item:clearItem()
      self._ui.slot_item:setItemByStaticStatus(mailItem, RequestMail_getMailItemCount())
      self._ui.stc_slotBG:SetShow(true)
      self._ui.slot_item.icon:SetShow(true)
      self._ui.txt_itemEnclosed:SetShow(true)
      self._ui.txt_keyGuideA:SetShow(true)
      self._ui.txt_itemName:SetText(mailItem:getName())
      self._ui.txt_itemCount:SetText(self:getCountString(RequestMail_getMailItemCount()))
      self._ui.txt_itemName:SetShow(true)
      self._ui.txt_itemCount:SetShow(true)
      _panel:SetSize(_panel:GetSizeX(), panel_SizeY)
      self._ui.stc_bottomBG:ComputePos()
      local isMoney = mailItem:isMoney()
      self._ui.txt_keyGuideX:SetShow(isMoney)
      if true == isMoney then
        _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Mail_Detail_GetItem(true)")
      else
        _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
      end
    else
      self._ui.slot_item:clearItem()
      self._ui.stc_slotBG:SetShow(false)
      self._ui.slot_item.icon:SetShow(false)
      self._ui.txt_itemEnclosed:SetShow(false)
      self._ui.txt_keyGuideA:SetShow(false)
      self._ui.txt_keyGuideX:SetShow(false)
      self._ui.txt_itemName:SetShow(false)
      self._ui.txt_itemCount:SetShow(false)
      _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
      _panel:SetSize(_panel:GetSizeX(), panel_SizeY - 45)
      self._ui.stc_bottomBG:ComputePos()
    end
  end
end
function mailDetail:getCountString(s64_stackCount)
  return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_MAKEPAYMENTSFROMCART_COUNT", "getCount", makeDotMoney(s64_stackCount))
end
function PaGlobal_MailDetail_GetShow()
  return _panel:GetShow()
end
function PaGlobal_MailDetail_Close()
  if true == _panel:IsShow() then
    _panel:SetShow(false, true)
  end
  mailDetail.openMailNo = nil
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_MailDetail_Delete()
  if nil ~= mailDetail.openMailNo then
    RequestMail_removeMail(mailDetail.openMailNo, true)
    mailDetail.openMailNo = nil
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobal_MailDetail_Close()
end
function Mail_Detail_GetItem(toWarehouse)
  local self = mailDetail
  if false == self._ui.txt_keyGuideA:GetShow() and false == self._ui.txt_keyGuideX:GetShow() then
    return
  end
  warehouse_requestInfoByCurrentRegionMainTown()
  local itemWhereType = CppEnums.ItemWhereType.eInventory
  if true == toWarehouse then
    itemWhereType = CppEnums.ItemWhereType.eWarehouse
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  else
    _AudioPostEvent_SystemUiForXBOX(50, 1)
  end
  local giftCount_s64 = RequestMail_getMailItemCount()
  if giftCount_s64 > toInt64(0, 1) then
    local function getMygift(count_s64)
      RequestMail_receiveMailItem(count_s64, itemWhereType)
      return
    end
    Panel_NumberPad_Show(true, giftCount_s64, nil, getMygift, false, nil)
  else
    RequestMail_receiveMailItem(giftCount_s64, itemWhereType)
  end
end
function FromClient_ResponseMailGetItem(itemKey, itemCount_s64, immediateItem, isRelay)
  local self = mailDetail
  if 1 ~= itemKey and not immediateItem then
    return
  end
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local itemName = itemESSW:getName()
  if immediateItem then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ALERT_IMMEDIATEITEM", "itemName", itemName))
  elseif 1 == itemKey and (isWarehouse or isRelay) then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MAIL_DETAIL_ALERT_GET_WAREHOUSE", "itemName", itemName, "itemCount", makeDotMoney(itemCount_s64)))
  end
end
