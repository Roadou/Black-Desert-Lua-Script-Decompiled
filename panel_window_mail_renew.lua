local _panel = Panel_Window_Mail_Renew
_panel:ActiveMouseEventEffect(true)
_panel:setGlassBackground(true)
_panel:RegisterShowEventFunc(true, "Mail_ShowAni()")
_panel:RegisterShowEventFunc(false, "Mail_HideAni()")
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
function Mail_ShowAni()
  UIAni.fadeInSCR_Left(_panel)
  local aniInfo1 = _panel:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = _panel:GetSizeX() / 2
  aniInfo1.AxisY = _panel:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = _panel:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = _panel:GetSizeX() / 2
  aniInfo2.AxisY = _panel:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Mail_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, _panel, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
local MailInfo = {
  _ui = {
    stc_topBG = UI.getChildControl(_panel, "Static_TopBg"),
    stc_centerBG = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    _page_Count = nil,
    _List_BG = {},
    _Sender_Name = {},
    _Mail_Title = {},
    _mailNo = {},
    _mail_GetItem = {},
    _mail_GetDate = {},
    isSelectAll = false,
    stc_haveItemEnclosed = {},
    txt_keyGuideA = nil,
    txt_keyGuideX = nil,
    txt_keyGuideB = nil
  },
  _rowMax = 8,
  _currentSelect = nil
}
function FromClient_luaLoadComplete_MailInfo_Init()
  MailInfo:Init_Control()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MailInfo_Init")
function MailInfo:Init_Control()
  self:init_newMailAlarm()
  self._ui._page_Count = UI.getChildControl(self._ui.stc_topBG, "StaticText_PageNumber")
  self._ui.mailTemplate = UI.getChildControl(self._ui.stc_centerBG, "RadioButton_MailTemplate")
  for ii = 1, self._rowMax do
    self._ui._List_BG[ii] = UI.cloneControl(self._ui.mailTemplate, self._ui.stc_centerBG, "Btn_Mail_" .. ii)
    self._ui._List_BG[ii]:SetPosY((ii - 1) * 68 + 12)
    self._ui._Sender_Name[ii] = UI.getChildControl(self._ui._List_BG[ii], "StaticText_Sender")
    self._ui._Sender_Name[ii]:SetTextMode(UI_TM.eTextMode_LimitText)
    self._ui._Mail_Title[ii] = UI.getChildControl(self._ui._List_BG[ii], "StaticText_Title")
    self._ui._Mail_Title[ii]:SetTextMode(UI_TM.eTextMode_LimitText)
    self._ui.stc_haveItemEnclosed[ii] = UI.getChildControl(self._ui._List_BG[ii], "Static_GiftIcon")
    self._ui.stc_haveItemEnclosed[ii]:SetShow(false)
  end
  self._ui.mailTemplate:SetShow(false)
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideA")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideX")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideB")
  local keyGuides = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideX,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:registEventHandler()
  self:registMessageHandler()
end
function MailInfo:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "MailList_Change_Page(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "MailList_Change_Page(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_Mail_GetDetail()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "MailList_ReceiveAll()")
  for key, value in pairs(self._ui._List_BG) do
    value:addInputEvent("Mouse_On", "MailList_SelectMailWithIndex(" .. tostring(key) .. ")")
    value:addInputEvent("Mouse_LUp", "PaGlobalFunc_Mail_GetDetail()")
  end
end
function MailInfo:registMessageHandler()
  registerEvent("ResponseMail_showList", "Mail_UpdateList")
  registerEvent("onScreenResize", "Mail_onScreenResize")
end
local _mail_Data = {
  _Page_Total = 0,
  _Page_Current = 0,
  _Selected = {},
  _Data = {}
}
function _mail_Data:setData()
  local mailCount = RequestMail_mailCount()
  local SlotMax = MailInfo._rowMax
  self._Data = {}
  local pageNo = 0
  for index = 1, mailCount do
    if (index - 1) % SlotMax == 0 then
      pageNo = pageNo + 1
    end
    if self._Data[pageNo] == nil then
      self._Data[pageNo] = {}
    end
    local mail_Info = RequestMail_getMailAt(index - 1)
    MailInfo._ui._mailNo[index] = mail_Info:getMailNo()
    local sender_Name = mail_Info:getSender()
    local mail_Title = mail_Info:getTitle()
    local mail_No = mail_Info:getMailNo()
    local mail_isExistItem = mail_Info:isExistItem()
    local mail_getMailReceiveDate = mail_Info:getMailReceiveDate()
    local idx = (index - 1) % SlotMax + 1
    self._Data[pageNo][idx] = {
      _indx = index - 1,
      _sender_Name = sender_Name,
      _mail_Title = mail_Title,
      _mail_GetItem = mail_isExistItem,
      _mail_GetDate = mail_getMailReceiveDate
    }
  end
  self._Page_Total = pageNo
end
function _mail_Data:clear()
  local SlotMax = MailInfo._rowMax
  for index = 1, SlotMax do
    MailInfo._ui._List_BG[index]:SetShow(false)
    MailInfo._ui._Sender_Name[index]:SetShow(false)
    MailInfo._ui._Mail_Title[index]:SetShow(false)
    MailInfo._ui.stc_haveItemEnclosed[index]:SetShow(false)
  end
  MailInfo._ui._page_Count:SetText("-- / --")
end
function _mail_Data:Update_MailPage()
  local pageNo = self._Page_Current
  local pageNo_Total = self._Page_Total
  if pageNo > pageNo_Total then
    self._Page_Current = self._Page_Total
    pageNo = self._Page_Current
  end
  local SlotMax = MailInfo._rowMax
  local mailCount = RequestMail_mailCount()
  _mail_Data:clear()
  for index = 1, SlotMax do
    if nil ~= self._Data[pageNo] then
      if nil ~= self._Data[pageNo][index] then
        local _sender_Name = self._Data[pageNo][index]._sender_Name
        local _mail_Title = self._Data[pageNo][index]._mail_Title
        local _indx = self._Data[pageNo][index]._indx
        local _getItem = self._Data[pageNo][index]._mail_GetItem
        local _getDate = self._Data[pageNo][index]._mail_GetDate
        local _mail_num = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_NO") .. "." .. tostring(_indx + 1)
        MailInfo._ui._Sender_Name[index]:SetText(_sender_Name .. "(" .. _getDate .. ")")
        MailInfo._ui._Mail_Title[index]:SetText(_mail_Title)
        if self._Selected._indx == _indx and self._Selected._sender_Name == _sender_Name and self._Selected._mail_Title == _mail_Title then
          MailInfo._ui._List_BG[index]:SetCheck(true)
        else
          MailInfo._ui._List_BG[index]:SetCheck(false)
        end
        MailInfo._ui._List_BG[index]:SetShow(true)
        MailInfo._ui._Sender_Name[index]:SetShow(true)
        MailInfo._ui._Mail_Title[index]:SetShow(true)
        MailInfo._ui.stc_haveItemEnclosed[index]:SetShow(true == _getItem)
      end
    else
      MailInfo._ui._List_BG[index]:SetShow(false)
      MailInfo._ui._Sender_Name[index]:SetShow(false)
      MailInfo._ui._Mail_Title[index]:SetShow(false)
      MailInfo._ui.stc_haveItemEnclosed[index]:SetShow(false)
    end
  end
  if pageNo_Total > 0 then
    local pageCount = tostring(pageNo) .. "/" .. tostring(pageNo_Total)
    MailInfo._ui._page_Count:SetText(pageCount)
  end
end
function PaGlobalFunc_Mail_GetDetail()
  if nil == MailInfo._currentSelect then
    return
  end
  local pageNo = _mail_Data._Page_Current
  local SlotMax = MailInfo._rowMax
  local index = MailInfo._currentSelect
  if pageNo < 1 then
    return
  end
  local realIndex = _mail_Data._Data[pageNo][index]._indx
  _mail_Data._Selected = {
    _indx = _mail_Data._Data[pageNo][index]._indx,
    _sender_Name = _mail_Data._Data[pageNo][index]._sender_Name,
    _mail_Title = _mail_Data._Data[pageNo][index]._mail_Title
  }
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  RequestMail_getMailDetail(realIndex)
end
function MailList_Change_Page(isNext)
  local pageNo_Current = _mail_Data._Page_Current
  local pageNo_Total = _mail_Data._Page_Total
  if true == isNext then
    if pageNo_Total < pageNo_Current + 1 then
      return
    else
      _mail_Data._Page_Current = pageNo_Current + 1
    end
  elseif false == isNext then
    if pageNo_Current - 1 < 1 then
      if nil ~= Panel_Window_MailDetail_Renew and true == Panel_Window_MailDetail_Renew:GetShow() then
        if false ~= PaGlobal_MailDetail_GetOpenMailNumber() then
          Mail_Detail_Open(PaGlobal_MailDetail_GetOpenMailNumber())
        end
        return
      end
    else
      _mail_Data._Page_Current = pageNo_Current - 1
    end
  end
  ToClient_padSnapResetControl()
  MailInfo._ui.isSelectAll = false
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  _mail_Data:Update_MailPage()
end
function MailList_SelectMailWithIndex(index)
  MailInfo._currentSelect = index
  for ii = 1, MailInfo._rowMax do
    MailInfo._ui._List_BG[ii]:SetCheck(false)
  end
  MailInfo._ui._List_BG[MailInfo._currentSelect]:SetCheck(true)
end
function MailList_SelectAll()
  local self = _mail_Data
  local SlotMax = MailInfo._rowMax
  local stat_checkBtn = MailInfo._ui.isSelectAll
  MailInfo._ui.isSelectAll = not stat_checkBtn
end
function MailList_SelectDelete()
  local self = _mail_Data
  local pageNo = self._Page_Current
  local SlotMax = MailInfo._rowMax
  local lastMailIndex = 0
  MailInfo._ui.isSelectAll = false
end
function MailList_ReceiveAll()
  local recievemail = function()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    RequestMail_receiveAllMailItem()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MAIL_GETALL_MESSAGEBOX_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MAIL_GETALL_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = recievemail,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Mail_Open()
  if not _panel:IsShow() then
    _panel:SetShow(true, true)
  end
  _mail_Data._Page_Current = 1
  _mail_Data._Page_Total = 0
  _mail_Data._Selected = {}
  _mail_Data:clear()
  RequestMail_requestMailList()
  RequestMail_setNewMailFlag(false)
end
function PaGlobalFunc_MailInfo_OnPadB()
  if PaGlobal_MailDetail_GetShow() then
    PaGlobal_MailDetail_Close()
    return
  end
  Mail_Close()
end
function Mail_Close()
  _AudioPostEvent_SystemUiForXBOX(1, 21)
  if _panel:IsShow() then
    _panel:SetShow(false, true)
    PaGlobal_MailDetail_Close()
  end
  HelpMessageQuestion_Out()
end
function MailInfo:init_newMailAlarm()
  local bNewFlag = RequestMail_getNewMailFlag()
  if bNewFlag then
    FromClient_NewMailAlarm()
  end
end
function Mail_UpdateList(isCheck)
  _mail_Data:setData()
  _mail_Data:Update_MailPage()
end
function FromClient_NewMail()
end
function Mail_onScreenResize()
  local gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  local gapY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
  _panel:SetPosX(getScreenSizeX() - _panel:GetSizeX() + gapX)
  _panel:SetPosY(getScreenSizeY() / 2 - _panel:GetSizeY() / 2 + gapY)
end
