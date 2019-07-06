local _panel = Panel_Window_KnowledgeManage_Renew
local TAB_TYPE = {KNOWLEDGE = 1, BOOKSHELF = 2}
local KnowledgeManage = {
  _ui = {
    stc_tabBG = UI.getChildControl(_panel, "Static_TopMenuBg"),
    stc_listBG = UI.getChildControl(_panel, "Static_KnowledgeManageBg"),
    txt_currentAsset = UI.getChildControl(_panel, "StaticText_HoldWP"),
    txt_requiredAsset = UI.getChildControl(_panel, "StaticText_UseWP"),
    stc_currentAssetIcon = UI.getChildControl(_panel, "Static_Price_Icon_1"),
    stc_requiredAssetIcon = UI.getChildControl(_panel, "Static_Price_Icon_2"),
    txt_currentAssetVal = UI.getChildControl(_panel, "StaticText_Need_Value"),
    txt_requiredAssetVal = UI.getChildControl(_panel, "StaticText_Have_Value"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomArea")
  },
  _currentDepth = {},
  _currentTab = TAB_TYPE.KNOWLEDGE,
  _currentTabIsCardView = false,
  _selectedBookIndex = nil,
  _bookNameList = {},
  _isOpenByItem = false
}
function FromClient_luaLoadComplete_KnowledgeManage()
  KnowledgeManage:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_KnowledgeManage")
local self = KnowledgeManage
function KnowledgeManage:initialize()
  self._ui.rdo_tabs = {
    UI.getChildControl(self._ui.stc_tabBG, "RadioButton_KnowledgeManagement"),
    UI.getChildControl(self._ui.stc_tabBG, "RadioButton_BookshelfManagement")
  }
  self._ui.list2 = UI.getChildControl(self._ui.stc_listBG, "List2_CategoryItem")
  self._ui.list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_KnowledgeManage_ListControlCreate")
  self._ui.list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2:getElementManager():clearKey()
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_Confirm_ConsoleUI")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_Cancel_ConsoleUI")
  self:alignKeyGuide()
  self:registEventHandler()
end
function KnowledgeManage:alignKeyGuide()
  local keyGuideTable = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideTable, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function KnowledgeManage:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_KnowledgeManage_NextTab(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_KnowledgeManage_NextTab(1)")
  registerEvent("FromClient_UpdateKnowledgeManage", "FromClient_KnowledgeManage_Update")
  registerEvent("FromClient_RemoveKnowledgeByItem", "FromClient_KnowledgeManage_ByItem")
end
local eventInputType = false
function PaGlobalFunc_KnowledgeManage_Open()
  KnowledgeManage._isOpenByItem = false
  KnowledgeManage:open()
  eventInputType = false
end
function FromClient_KnowledgeManage_ByItem()
  KnowledgeManage._isOpenByItem = true
  KnowledgeManage:open()
  eventInputType = true
end
function KnowledgeManage:open()
  _panel:SetShow(true)
  self._currentDepth = {}
  self:setTabTo(self._currentTab)
  self:update()
end
function PaGlobalFunc_KnowledgeManage_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_KnowledgeManage_Close()
  self:close()
end
function KnowledgeManage:close()
  self._isOpenByItem = false
  _panel:SetShow(false)
end
function Input_KnowledgeManage_NextTab(val)
  local nextTab = self._currentTab + val
  if nextTab > #self._ui.rdo_tabs then
    nextTab = 1
  elseif nextTab < 1 then
    nextTab = #self._ui.rdo_tabs
  end
  self:setTabTo(nextTab)
  self:update()
end
local iconUV = {
  {
    137,
    228,
    164,
    255
  },
  {
    64,
    171,
    91,
    198
  }
}
function KnowledgeManage:setTabTo(tabIndex)
  self._currentDepth = {}
  for ii = 1, #self._ui.rdo_tabs do
    self._ui.rdo_tabs[ii]:SetCheck(false)
    self._ui.rdo_tabs[ii]:SetFontColor(Defines.Color.C_FF9397A7)
  end
  self._ui.rdo_tabs[tabIndex]:SetCheck(true)
  self._ui.rdo_tabs[tabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._currentTab = tabIndex
  self._ui.stc_currentAssetIcon:ChangeTextureInfoName("renewal/ui_icon/console_icon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_currentAssetIcon, iconUV[self._currentTab][1], iconUV[self._currentTab][2], iconUV[self._currentTab][3], iconUV[self._currentTab][4])
  self._ui.stc_currentAssetIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_currentAssetIcon:setRenderTexture(self._ui.stc_currentAssetIcon:getBaseTexture())
  self._ui.stc_requiredAssetIcon:ChangeTextureInfoName("renewal/ui_icon/console_icon_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_requiredAssetIcon, iconUV[self._currentTab][1], iconUV[self._currentTab][2], iconUV[self._currentTab][3], iconUV[self._currentTab][4])
  self._ui.stc_requiredAssetIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_requiredAssetIcon:setRenderTexture(self._ui.stc_requiredAssetIcon:getBaseTexture())
  if TAB_TYPE.KNOWLEDGE == self._currentTab then
    self._ui.txt_currentAsset:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_KNOWLEDGE_MANAGEMENT_HOLDWP"))
    self._ui.txt_requiredAsset:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_KNOWLEDGE_MANAGEMENT_USEWP"))
    self._ui.txt_currentAssetVal:SetText(getSelfPlayer():getWp())
    self._ui.txt_requiredAssetVal:SetText("10")
  else
    self._ui.txt_currentAsset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_HAVEMONEY"))
    self._ui.txt_requiredAsset:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_TEXT_NEEDMONEY"))
    local selfMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
    self._ui.txt_currentAssetVal:SetText(makeDotMoney(selfMoney))
    self._ui.txt_requiredAssetVal:SetText("0")
    self._selectedBookIndex = 1
    InputMOn_KnowledgeManage_OverBook(self._selectedBookIndex)
  end
end
function KnowledgeManage:update()
  self._ui.list2:getElementManager():clearKey()
  if TAB_TYPE.BOOKSHELF == self._currentTab then
    self:updateThemeBook()
    return
  end
  local theme = self:getThemeFromDepth()
  if nil ~= theme then
    local childCount = theme:getChildThemeCount()
    local cardCount = theme:getChildCardCount()
    if childCount > 0 then
      for ii = 1, childCount do
        local childTheme = theme:getChildThemeByIndex(ii - 1)
        if childTheme:isRemovable() then
          self._currentTabIsCardView = false
          self._ui.list2:getElementManager():pushKey(toInt64(0, ii))
        end
      end
    elseif cardCount > 0 then
      for ii = 1, cardCount do
        local card = theme:getChildCardByIndex(ii - 1)
        if card:hasCard() then
          self._currentTabIsCardView = true
          self._ui.list2:getElementManager():pushKey(toInt64(0, ii))
        end
      end
    end
  else
    UI.ASSERT(false, "current theme is nil")
  end
  if self._currentTabIsCardView then
    self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_KNOWLEDGE_MANAGEMENT_BTN_DELETE"))
  else
    self._ui.txt_keyGuideA:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SELECT"))
  end
  self:alignKeyGuide()
end
function KnowledgeManage:updateThemeBook()
  local selfMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
  local themeBook = ToClient_ThemeBookBegin()
  local index = 1
  self._bookNameList = {}
  while nil ~= themeBook do
    local name = themeBook:getName()
    if nil ~= name and "" ~= name then
      self._bookNameList[index] = name
      self._ui.list2:getElementManager():pushKey(toInt64(0, index))
      index = index + 1
      themeBook = ToClient_ThemeBookNext()
    end
  end
end
function KnowledgeManage:updateRoot()
end
function KnowledgeManage:getThemeFromDepth()
  local knowledge = getSelfPlayer():get():getMentalKnowledge()
  local returnTheme = knowledge:getMainTheme()
  for ii = 1, #self._currentDepth do
    if nil ~= returnTheme then
      local currentIndex = self._currentDepth[ii]
      if nil ~= currentIndex then
        returnTheme = returnTheme:getChildThemeByIndex(currentIndex - 1)
      end
    end
  end
  return returnTheme
end
function PaGlobalFunc_KnowledgeManage_ListControlCreate(content, key)
  local key32 = Int64toInt32(key)
  if TAB_TYPE.BOOKSHELF == self._currentTab then
    self:bookShelfListControl(content, key32)
    return
  end
  local btn = UI.getChildControl(content, "Button_CategoryItemName")
  local theme = self:getThemeFromDepth()
  if false == self._currentTabIsCardView then
    local childTheme = theme:getChildThemeByIndex(key32 - 1)
    if nil ~= childTheme then
      btn:addInputEvent("Mouse_LUp", "InputMLUp_KnowledgeManage_SelectTheme(" .. key32 .. ")")
      btn:SetText(childTheme:getName())
    end
  else
    local childCard = theme:getChildCardByIndex(key32 - 1)
    if nil ~= childCard and childCard:hasCard() then
      btn:SetText(childCard:getName())
      btn:addInputEvent("Mouse_On", "InputMOn_KnowledgeManage_OverCard(" .. key32 .. ")")
      btn:addInputEvent("Mouse_LUp", "InputMLUp_KnowledgeManage_SelectCard(" .. key32 .. ")")
    end
  end
end
function KnowledgeManage:bookShelfListControl(content, key32)
  local btn = UI.getChildControl(content, "Button_CategoryItemName")
  btn:addInputEvent("Mouse_On", "InputMOn_KnowledgeManage_OverBook(" .. key32 .. ")")
  btn:addInputEvent("Mouse_LUp", "InputMLUp_KnowledgeManage_SelectBook(" .. key32 .. ")")
  btn:SetText(self._bookNameList[key32])
end
function InputMLUp_KnowledgeManage_SelectTheme(key32)
  self._currentDepth[#self._currentDepth + 1] = key32
  self:update()
end
function InputMOn_KnowledgeManage_OverCard(key32)
end
function InputMLUp_KnowledgeManage_SelectCard(key32)
  local theme = self:getThemeFromDepth()
  if nil == theme then
    return
  end
  if getSelfPlayer():getWp() < 10 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_WP_SHORTAGE_ACK"))
    return
  end
  local childCard = theme:getChildCardByIndex(key32 - 1)
  local function CheckKnowledgeDelete()
    local childCardKey = childCard:getKey()
    if nil == childCardKey then
      return
    end
    if childCardKey > 0 then
      ToClient_RequestRemoveCard(childCardKey)
    end
    if false == self._isOpenByItem then
      PaGlobalFunc_MainDialog_ReOpen()
    end
    self:close()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_DELETEKNOWLEDGE"))
  end
  local childCardKey = childCard:getKey()
  if childCardKey < 0 then
    return
  end
  local selectItemName = childCard:getName()
  if true == eventInputType then
    messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_ITEM", "selectItemName", selectItemName)
  else
    messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_INTERACTION", "selectItemName", selectItemName)
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_DELETECONFIRM_TITLE"),
    content = messageBoxMemo,
    functionYes = CheckKnowledgeDelete,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function InputMLUp_KnowledgeManage_SelectBook(key32)
  local themeBook = ToClient_GetThemeBookAt(key32 - 1)
  if nil == themeBook then
    return
  end
  self._selectedBookIndex = key32
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_MSGBOX_MAKEBOOK_MEMO")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = InputMLUp_KnowledgeManage_BookShelfActual,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function InputMLUp_KnowledgeManage_BookShelfActual()
  local themeBook = ToClient_GetThemeBookAt(self._selectedBookIndex - 1)
  local selfMoney = Int64toInt32(getSelfPlayer():get():getInventory():getMoney_s64())
  if tonumber(Int64toInt32(selfMoney)) < tonumber(Int64toInt32(themeBook:getNeedMoney())) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_MAKEBOOK"))
    return
  end
  ToClient_RequestMakeThemeBook(self._selectedBookIndex - 1)
  self:close()
  PaGlobalFunc_MainDialog_ReOpen()
end
function InputMOn_KnowledgeManage_OverBook(key32)
  local themeBook = ToClient_GetThemeBookAt(key32 - 1)
  if TAB_TYPE.BOOKSHELF == self._currentTab and nil ~= themeBook then
    self._ui.txt_requiredAssetVal:SetText(makeDotMoney(themeBook:getNeedMoney()))
  end
end
function PaGlobalFunc_KnowledgeManage_OnPadB()
  if 0 < #self._currentDepth then
    self._currentDepth[#self._currentDepth] = nil
    self:update()
    return false
  else
    self:close()
    return true
  end
end
function FromClient_KnowledgeManage_Update()
  self:update()
end
