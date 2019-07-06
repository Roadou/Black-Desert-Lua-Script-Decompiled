function PaGlobal_GuildHouse_Auction_Bid_All:initialize()
  if true == self._initialize then
    return
  end
  self._isConsole = ToClient_isConsole()
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:SetUiSetting()
  if true == PaGlobal_GuildHouse_Auction_Bid_All._isConsole then
    local tempBtnGroup = {
      PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_selectA,
      PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_cancelB
    }
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, PaGlobal_GuildHouse_Auction_Bid_All._ui_console.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
  self:registEventHandler()
  self:validate()
  self._initialize = true
end
function PaGlobal_GuildHouse_Auction_Bid_All:controlAll_Init()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui.stc_bidBg = UI.getChildControl(Panel_GuildHouse_Auction_Bid_All, "Static_BidBg")
  self._ui.stc_aucPrice = UI.getChildControl(self._ui.stc_bidBg, "Edit_Guild")
  local guildBg = UI.getChildControl(self._ui.stc_bidBg, "Static_GuildBg")
  self._ui.stc_icon = UI.getChildControl(guildBg, "Static_TextIcon")
  self._ui.stc_warehouseMoney = UI.getChildControl(guildBg, "Static_Text_Warehouse")
end
function PaGlobal_GuildHouse_Auction_Bid_All:controlPc_Init()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui_pc.btn_cancel = UI.getChildControl(Panel_GuildHouse_Auction_Bid_All, "Button_Cancel_PCUI")
  self._ui_pc.btn_confirm = UI.getChildControl(Panel_GuildHouse_Auction_Bid_All, "Button_Confirm_PCUI")
  self._ui_pc.btn_close = UI.getChildControl(Panel_GuildHouse_Auction_Bid_All, "Button_Close_PCUI")
end
function PaGlobal_GuildHouse_Auction_Bid_All:controlConsole_Init()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui_console.stc_bottomBg = UI.getChildControl(Panel_GuildHouse_Auction_Bid_All, "Static_BottomBg_ConsoleUI")
  self._ui_console.stc_selectA = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_A_ConsoleUI")
  self._ui_console.stc_cancelB = UI.getChildControl(self._ui_console.stc_bottomBg, "StaticText_B_ConsoleUI")
  self._ui_console.stc_keyGuideX = UI.getChildControl(self._ui.stc_aucPrice, "StaticText_X_ConsoleUI")
end
function PaGlobal_GuildHouse_Auction_Bid_All:SetUiSetting()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  if false == PaGlobal_GuildHouse_Auction_Bid_All._isConsole then
    self._ui_console.stc_bottomBg:SetShow(false)
    self._ui_console.stc_keyGuideX:SetShow(false)
    self._ui_pc.btn_cancel:SetShow(true)
    self._ui_pc.btn_confirm:SetShow(true)
    self._ui_pc.btn_close:SetShow(true)
    Panel_GuildHouse_Auction_Bid_All:SetSize(Panel_GuildHouse_Auction_Bid_All:GetSizeX(), self._sizeY.PC_PANEL)
    self._ui.stc_bidBg:SetSize(self._ui.stc_bidBg:GetSizeX(), self._sizeY.PC_MAINBG)
  else
    self._ui_pc.btn_cancel:SetShow(false)
    self._ui_pc.btn_confirm:SetShow(false)
    self._ui_pc.btn_close:SetShow(false)
    self._ui_console.stc_bottomBg:SetShow(true)
    self._ui_console.stc_keyGuideX:SetShow(true)
    Panel_GuildHouse_Auction_Bid_All:SetSize(Panel_GuildHouse_Auction_Bid_All:GetSizeX(), self._sizeY.CONSOLE_PANEL)
    self._ui.stc_bidBg:SetSize(self._ui.stc_bidBg:GetSizeX(), self._sizeY.CONSOLE_MAINBG)
  end
  FromClient_GuildHouse_Auction_Bid_All_ReSizePanel()
end
function PaGlobal_GuildHouse_Auction_Bid_All:registEventHandler()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  registerEvent("onScreenResize", "FromClient_GuildHouse_Auction_Bid_All_ReSizePanel()")
  if false == self._isConsole then
    self._ui_pc.btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_All_clickedCancel()")
    self._ui_pc.btn_cancel:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_All_clickedCancel()")
    self._ui_pc.btn_confirm:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_All_clickedConfirm()")
    self._ui.stc_aucPrice:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildHouse_Auction_All_clickedEdit()")
  else
    Panel_GuildHouse_Auction_Bid_All:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventLUp_GuildHouse_Auction_All_clickedConfirm()")
    Panel_GuildHouse_Auction_Bid_All:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventLUp_GuildHouse_Auction_All_clickedEdit()")
  end
end
function PaGlobal_GuildHouse_Auction_Bid_All:prepareOpen()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self:setGuildMoney()
  self._auctionPrice = nil
  self._ui.stc_aucPrice:SetEditText("", true)
  PaGlobal_GuildHouse_Auction_Bid_All:open()
end
function PaGlobal_GuildHouse_Auction_Bid_All:open()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  Panel_GuildHouse_Auction_Bid_All:SetShow(true)
end
function PaGlobal_GuildHouse_Auction_Bid_All:prepareClose()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  PaGlobal_GuildHouse_Auction_Bid_All:close()
end
function PaGlobal_GuildHouse_Auction_Bid_All:close()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  Panel_GuildHouse_Auction_Bid_All:SetShow(false)
end
function PaGlobal_GuildHouse_Auction_Bid_All:update()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
end
function PaGlobal_GuildHouse_Auction_Bid_All:validate()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self:allValidate()
  self:pcValidate()
  self:consoleValidate()
end
function PaGlobal_GuildHouse_Auction_Bid_All:allValidate()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui.stc_bidBg:isValidate()
  self._ui.stc_aucPrice:isValidate()
  self._ui.stc_icon:isValidate()
  self._ui.stc_warehouseMoney:isValidate()
end
function PaGlobal_GuildHouse_Auction_Bid_All:pcValidate()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui_pc.btn_cancel:isValidate()
  self._ui_pc.btn_confirm:isValidate()
  self._ui_pc.btn_close:isValidate()
end
function PaGlobal_GuildHouse_Auction_Bid_All:consoleValidate()
  if nil == Panel_GuildHouse_Auction_Bid_All then
    return
  end
  self._ui_console.stc_bottomBg:isValidate()
  self._ui_console.stc_selectA:isValidate()
  self._ui_console.stc_cancelB:isValidate()
  self._ui_console.stc_keyGuideX:isValidate()
end
function PaGlobal_GuildHouse_Auction_Bid_All:setGuildMoney()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local myGuildMoney = myGuildListInfo:getGuildBusinessFunds_s64()
  self._ui.stc_warehouseMoney:SetText(makeDotMoney(myGuildMoney))
  self._ui.stc_warehouseMoney:SetSize(self._ui.stc_warehouseMoney:GetTextSizeX(), self._ui.stc_warehouseMoney:GetSizeY())
  self._ui.stc_warehouseMoney:ComputePos()
  local iconPosX = self._ui.stc_warehouseMoney:GetTextSizeX() + self._ui.stc_warehouseMoney:GetSpanSize().x + 5
  self._ui.stc_icon:SetSpanSize(iconPosX, self._ui.stc_icon:GetSpanSize().y)
end
