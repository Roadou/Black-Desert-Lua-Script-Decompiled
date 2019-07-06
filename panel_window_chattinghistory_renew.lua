local _panel = Panel_Window_ChattingHistory_Renew
local CHAT_TYPE = CppEnums.ChatType
local TAB_TYPE = {
  CUSTOM = 1,
  GENERAL = 2,
  WORLD = 3,
  GUILD = 4,
  SYSTEM = 5
}
local _openByParty = false
local ChattingHistory = {
  _ui = {
    stc_BG = UI.getChildControl(_panel, "Static_BG"),
    stc_BottomBG = UI.getChildControl(_panel, "Static_BottomBG"),
    stc_tabBG = nil,
    frame_tabs = nil,
    rdo_chatTypeList = {},
    stc_sampleBG = UI.getChildControl(_panel, "Static_SampleBG"),
    scroll_list = {},
    stc_poolBase = UI.getChildControl(_panel, "Static_Empty"),
    stc_selectedLine = UI.getChildControl(_panel, "Static_SelectionBox"),
    stc_keyGuideGroup = UI.getChildControl(_panel, "Static_KeyGuideGroup"),
    txt_keyGuideA = nil
  },
  _uiPool = {},
  _listPanel = {},
  _rdoButtonsXGap = 125,
  _tabCount = nil,
  _cloneCount = 100,
  _maxHistoryCount = ToClient_getChattingMaxContentsCount() - 50,
  _scrollPosition = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  },
  _linkedItemTooltipIsClicked = false,
  _defaultTab = TAB_TYPE.CUSTOM,
  _transparency = {
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 1,
    [5] = 1
  },
  _lowestY = 0,
  _cacheSimpleUI = false,
  _currentTab = 0,
  _currentSelectedMessage = {},
  _scroll_BTNPos = {
    [0] = 1,
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 1,
    [5] = 1
  },
  _tabName = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_HISTORY_CUSTOM"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_NORMAL"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_WORLD"),
    [4] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHATTING_OPTION_FILTER_GUILD"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_HISTORY_SYSTEM")
  }
}
local _snappedOnThisPanel = false
local _chatPanelCount = 5
local _chatFilterCount = 18
local _tabButtonBaseUV = {
  [TAB_TYPE.CUSTOM] = {
    252,
    452,
    300,
    500
  },
  [TAB_TYPE.GENERAL] = {
    302,
    452,
    350,
    500
  },
  [TAB_TYPE.WORLD] = {
    402,
    452,
    450,
    500
  },
  [TAB_TYPE.GUILD] = {
    452,
    452,
    500,
    500
  },
  [TAB_TYPE.SYSTEM] = {
    352,
    452,
    400,
    500
  }
}
local _tabButtonOnUV = {
  [TAB_TYPE.CUSTOM] = {
    252,
    402,
    300,
    450
  },
  [TAB_TYPE.GENERAL] = {
    302,
    402,
    350,
    450
  },
  [TAB_TYPE.WORLD] = {
    402,
    402,
    450,
    450
  },
  [TAB_TYPE.GUILD] = {
    452,
    402,
    500,
    450
  },
  [TAB_TYPE.SYSTEM] = {
    352,
    402,
    400,
    450
  }
}
_chatTypeUV = {
  [CHAT_TYPE.Undefine] = nil,
  [CHAT_TYPE.Notice] = {
    2,
    218,
    80,
    244
  },
  [CHAT_TYPE.World] = {
    81,
    107,
    139,
    127
  },
  [CHAT_TYPE.Public] = {
    81,
    65,
    139,
    85
  },
  [CHAT_TYPE.Private] = {
    81,
    23,
    139,
    43
  },
  [CHAT_TYPE.System] = {
    81,
    149,
    139,
    169
  },
  [CHAT_TYPE.Party] = {
    81,
    128,
    139,
    148
  },
  [CHAT_TYPE.Guild] = {
    81,
    86,
    139,
    106
  },
  [CHAT_TYPE.Client] = nil,
  [CHAT_TYPE.Alliance] = nil,
  [CHAT_TYPE.Friend] = nil,
  [CHAT_TYPE.GameInfo3] = nil,
  [CHAT_TYPE.WorldWithItem] = {
    81,
    2,
    139,
    22
  },
  [CHAT_TYPE.Battle] = {
    81,
    149,
    139,
    169
  },
  [CHAT_TYPE.LocalWar] = nil,
  [CHAT_TYPE.RolePlay] = {
    81,
    212,
    139,
    232
  },
  [CHAT_TYPE.NoticeOnlyTop] = nil,
  [CHAT_TYPE.Arsha] = {
    81,
    233,
    139,
    253
  },
  [CHAT_TYPE.Team] = {
    81,
    44,
    139,
    64
  },
  [CHAT_TYPE.Count] = nil
}
local _scroll_Interval_AddPos = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0,
  [5] = 0
}
local chattingUpTime = 0
local premsgCount = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0,
  [5] = 0
}
local prepopmsgCount = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0,
  [5] = 0
}
local issmoothupMessage = false
local smoothScrollTime = 0
local deltascrollPosy = {
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0,
  [5] = 0
}
local preScrollControlPos = {
  [0] = 0,
  [1] = 0,
  [2] = 0,
  [3] = 0,
  [4] = 0,
  [5] = 0
}
local smoothWheelScrollTime = 0
local _isScrollingUp = false
local scrollresetSpeed = 0
local smoothResetScrollTime = 0
local preDownPosY = 0
local ismsgin = false
function FromClient_luaLoadComplete_ChattingHistory_Init()
  ChattingHistory:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ChattingHistory_Init")
local _isInitialized = false
function ChattingHistory:initialize()
  _panel:setMaskingChild(true)
  _panel:setGlassBackground(true)
  self._tabCount = ToClient_getChattingPanelCount()
  self._ui.stc_tabBG = UI.getChildControl(self._ui.stc_BG, "Static_TabBG")
  self._ui.frame_tabs = UI.getChildControl(self._ui.stc_tabBG, "Frame_Tabs")
  self._ui.txt_tabName = UI.getChildControl(self._ui.stc_BottomBG, "StaticText_TabName")
  local frameContent = self._ui.frame_tabs:GetFrameContent()
  for ii = 1, self._tabCount do
    self._ui.scroll_list[ii] = UI.getChildControl(_panel, "Scroll_History_" .. ii)
    self._ui.rdo_chatTypeList[ii] = UI.createAndCopyBasePropertyControl(frameContent, "RadioButton_Template", frameContent, "RadioButton_ChatType_" .. ii)
    self._ui.rdo_chatTypeList[ii]:SetPosX((ii - 1) * self._rdoButtonsXGap + 30)
    local radioButton = self._ui.rdo_chatTypeList[ii]
    local x1, y1, x2, y2 = setTextureUV_Func(radioButton, _tabButtonBaseUV[ii][1], _tabButtonBaseUV[ii][2], _tabButtonBaseUV[ii][3], _tabButtonBaseUV[ii][4])
    radioButton:getBaseTexture():setUV(x1, y1, x2, y2)
    radioButton:setRenderTexture(radioButton:getBaseTexture())
    self._listPanel[ii] = UI.createAndCopyBasePropertyControl(_panel, "Static_SampleBG", self._ui.stc_poolBase, "Static_ListBG" .. ii)
    self._uiPool[ii] = self:createPool(ii)
  end
  self._ui.frame_tabs:UpdateContentPos()
  for ii = 1, _chatPanelCount do
    local chattingPannel = ToClient_getChattingPanel(ii - 1)
    chattingPannel:setOpenValue(true)
    chattingPannel:setPanelSize(self._ui.stc_sampleBG:GetSizeX(), self._ui.stc_sampleBG:GetSizeY())
  end
  local currentFontSize = ToClient_getFontWrapper("BaseFont_10_Chat"):getFontSize()
  for panelIdx = 1, self._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIdx - 1)
    chatPanel:setChatFontSizeType(self:getFontType(currentFontSize))
    self._currentSelectedMessage[panelIdx] = 0
  end
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_keyGuideGroup, "StaticText_KeyGuideA")
  self:registEventHandler()
  self:registMessageHandler()
  _isInitialized = true
  self._scrollPosition = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  }
  self._scroll_BTNPos = {
    [1] = 1,
    [2] = 1,
    [3] = 1,
    [4] = 1,
    [5] = 1
  }
  premsgCount = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  }
  prepopmsgCount = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  }
  deltascrollPosy = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  }
  preScrollControlPos = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  }
end
function ChattingHistory:registEventHandler()
  _panel:addInputEvent("Mouse_UpScroll", "Input_ChattingHistory_Scroll(true)")
  _panel:addInputEvent("Mouse_DownScroll", "Input_ChattingHistory_Scroll(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_ChattingInfo_ChangeHistoryTab(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_ChattingInfo_ChangeHistoryTab(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "Input_ChatHistory_SelectInList_InParty(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "Input_ChatHistory_SelectInList_InParty(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_ChattingInfo_InviteParty_InParty()")
end
function ChattingHistory:registMessageHandler()
  _panel:RegisterUpdateFunc("FromClient_ChattingHistory_UpdatePerFrame")
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_ChattingHistory_PadSnapChangePanel")
  registerEvent("EventChattingMessageUpdate", "FromClient_ChatHistory_Update")
  registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ChattingHistory_ResetAllScroll")
end
function ChattingHistory:getFontType(chattingFontSize)
  local ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Normal
  if chattingFontSize == 10 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Small
  elseif chattingFontSize == 12 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Medium
  elseif chattingFontSize == 14 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Normal
  elseif chattingFontSize == 18 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Biggish
  elseif chattingFontSize == 20 then
    ChatFontType = CppEnums.ChatFontSizeType.eChatFontSizeType_Big
  end
  return ChatFontType
end
function ChattingHistory:createPool(poolIndex)
  local ChatUIPool = {
    _list_PanelBG = {},
    _list_ChattingIcon = {},
    _list_ChattingSender = {},
    _list_ChattingContents = {},
    _list_ChattingGuildMark = {},
    _list_ChattingLinkedItem = {},
    _list_ChattingLinkedGuild = {},
    _list_ChattingLinkedWebSite = {},
    _list_Emoticon = {},
    _list_At = {},
    _count_ChattingIcon = 0,
    _count_ChattingSender = 0,
    _count_ChattingContents = 0,
    _count_ChattingLinkedItem = 0,
    _count_ChattingLinkedGuild = 0,
    _count_ChattingGuildMark = 0,
    _count_ChattingLinkedWebSite = 0,
    _count_Emoticon = 0,
    _count_At = 0,
    _maxcount_ChattingIcon = ChattingHistory._cloneCount,
    _maxcount_ChattingSender = ChattingHistory._cloneCount,
    _maxcount_ChattingContents = ChattingHistory._cloneCount,
    _maxcount_ChattingLinkedItem = ChattingHistory._cloneCount,
    _maxcount_ChattingLinkedGuild = ChattingHistory._cloneCount,
    _maxcount_ChattingGuildMark = ChattingHistory._cloneCount,
    _maxcount_ChattingLinkedWebSite = ChattingHistory._cloneCount,
    _maxcount_Emoticon = ChattingHistory._cloneCount,
    _maxcount_At = ChattingHistory._cloneCount,
    _list_SenderMessageIndex = {},
    _list_ContentMessageIndex = {},
    _list_LinkedItemMessageIndex = {},
    _list_LinkedGuildMessageIndex = {},
    _list_LinkedWebSiteMessageIndex = {},
    _list_LinkedAtMessageIndex = {},
    _list_LinkedAtIndex = {}
  }
  function ChatUIPool:initialize(poolIndex)
    local ch = ChattingHistory
    self._list_PanelBG[0] = ch._ui.stc_sampleBG
    for ii = 1, ch._cloneCount do
      ChatUIPool._list_ChattingIcon[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "Static_ChatIcon", ch._listPanel[poolIndex], "Static_ChatIcon" .. ii)
      ChatUIPool._list_ChattingSender[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "StaticText_ChatSender", ch._listPanel[poolIndex], "StaticText_ChatSender" .. ii)
      ChatUIPool._list_ChattingContents[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "StaticText_ChatContent", ch._listPanel[poolIndex], "StaticText_ChatContent" .. ii)
      ChatUIPool._list_ChattingGuildMark[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "Static_GuildMark", ch._listPanel[poolIndex], "Static_GuildMark" .. ii)
      ChatUIPool._list_ChattingLinkedItem[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "StaticText_ChatLinkedItem", ch._listPanel[poolIndex], "StaticText_ChatLinkedItem" .. ii)
      ChatUIPool._list_ChattingLinkedGuild[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "StaticText_ChatLinkedGuild", ch._listPanel[poolIndex], "StaticText_ChatLinkedGuild" .. ii)
      ChatUIPool._list_ChattingLinkedWebSite[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "StaticText_ChatLinkedWebSite", ch._listPanel[poolIndex], "StaticText_ChatLinkedWebSite" .. ii)
      ChatUIPool._list_Emoticon[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "Static_Emoticon", ch._listPanel[poolIndex], "Static_Emoticon" .. ii)
      ChatUIPool._list_At[ii] = UI.createAndCopyBasePropertyControl(ch._ui.stc_sampleBG, "Static_At", ch._listPanel[poolIndex], "Static_At" .. ii)
    end
  end
  function ChatUIPool:newChattingIcon()
    self._count_ChattingIcon = self._count_ChattingIcon + 1
    return self._list_ChattingIcon[self._count_ChattingIcon - 1]
  end
  function ChatUIPool:getCurrentChattingIconIndex()
    return self._count_ChattingIcon - 1
  end
  function ChatUIPool:getChattingIconByIndex(index)
    return self._list_ChattingIcon[index]
  end
  function ChatUIPool:newChattingSender(messageIndex)
    self._count_ChattingSender = self._count_ChattingSender + 1
    self._list_SenderMessageIndex[self._count_ChattingSender - 1] = messageIndex
    return self._list_ChattingSender[self._count_ChattingSender - 1]
  end
  function ChatUIPool:getChattingContentByIndex(index)
    return self._list_ChattingContents[index]
  end
  function ChatUIPool:newChattingContents(messageIndex)
    self._count_ChattingContents = self._count_ChattingContents + 1
    if nil == self._list_ContentMessageIndex[messageIndex] then
      self._list_ContentMessageIndex[messageIndex] = self._list_ChattingContents[self._count_ChattingContents - 1]
    end
    return self._list_ChattingContents[self._count_ChattingContents - 1]
  end
  function ChatUIPool:newChattingLinkedItem(messageIndex)
    self._count_ChattingLinkedItem = self._count_ChattingLinkedItem + 1
    self._list_LinkedItemMessageIndex[self._count_ChattingLinkedItem - 1] = messageIndex
    return self._list_ChattingLinkedItem[self._count_ChattingLinkedItem - 1]
  end
  function ChatUIPool:newChattingLinkedGuild(messageIndex)
    self._count_ChattingLinkedGuild = self._count_ChattingLinkedGuild + 1
    self._list_LinkedGuildMessageIndex[self._count_ChattingLinkedGuild - 1] = messageIndex
    return self._list_ChattingLinkedGuild[self._count_ChattingLinkedGuild - 1]
  end
  function ChatUIPool:newChattingGuildMark()
    self._count_ChattingGuildMark = self._count_ChattingGuildMark + 1
    return self._list_ChattingGuildMark[self._count_ChattingGuildMark - 1]
  end
  function ChatUIPool:getCurrentChattingGuildMarkIndex()
    return self._count_ChattingGuildMark - 1
  end
  function PaGlobal_getChattingGuildMarkByIndex(index)
    return ChatUIPool:getChattingGuildMarkByIndex(index)
  end
  function ChatUIPool:getChattingGuildMarkByIndex(index)
    return self._list_ChattingGuildMark[index]
  end
  function ChatUIPool:newChattingEmoticon()
    self._count_Emoticon = self._count_Emoticon + 1
    return self._list_Emoticon[self._count_Emoticon - 1]
  end
  function ChatUIPool:newChattingLinkedWebSite(messageIndex)
    self._count_ChattingLinkedWebSite = self._count_ChattingLinkedWebSite + 1
    self._list_LinkedWebSiteMessageIndex[self._count_ChattingLinkedWebSite - 1] = messageIndex
    return self._list_ChattingLinkedWebSite[self._count_ChattingLinkedWebSite - 1]
  end
  function ChatUIPool:newChattingAt(messageIndex)
    self._count_At = self._count_At + 1
    self._list_LinkedAtMessageIndex[self._count_At - 1] = messageIndex
    return self._list_At[self._count_At - 1]
  end
  function ChatUIPool:clearChattingIcon()
    self._count_ChattingIcon = 1
  end
  function ChatUIPool:clearChattingSender(messageIndex)
    self._count_ChattingSender = 1
  end
  function ChatUIPool:clearChattingContents()
    self._count_ChattingContents = 1
  end
  function ChatUIPool:clearChattingLinkedItem(messageIndex)
    self._count_ChattingLinkedItem = 1
  end
  function ChatUIPool:clearChattingLinkedGuild(messageIndex)
    self._count_ChattingLinkedGuild = 1
  end
  function ChatUIPool:clearChattingGuildMark()
    self._count_ChattingGuildMark = 1
  end
  function ChatUIPool:clearChattingLinkedwebsite(messageIndex)
    self._count_ChattingLinkedWebSite = 1
  end
  function ChatUIPool:clearEmoticon()
    self._count_Emoticon = 1
  end
  function ChatUIPool:clearAt()
    self._count_At = 1
  end
  function ChatUIPool:clear()
    self._count_ChattingIcon = 1
    self._count_ChattingSender = 1
    self._count_ChattingContents = 1
    self._count_ChattingLinkedItem = 1
    self._count_ChattingLinkedGuild = 1
    self._count_ChattingGuildMark = 1
    self._count_ChattingLinkedWebSite = 1
    self._count_Emoticon = 1
    self._count_At = 1
    self._list_SenderMessageIndex = {}
    self._list_ContentMessageIndex = {}
    self._list_LinkedItemMessageIndex = {}
    self._list_LinkedGuildMessageIndex = {}
    self._list_LinkedWebSiteMessageIndex = {}
    self._list_LinkedAtMessageIndex = {}
    self._list_LinkedAtIndex = {}
    ChatUIPool:hideNotUse()
  end
  function ChatUIPool:drawclear()
    self.clearChattingIcon()
    self.clearChattingContents()
    self.clearChattingSender()
    self.clearChattingLinkedItem()
    self.clearChattingLinkedGuild()
    self.clearChattingGuildMark()
    self.clearChattingLinkedwebsite()
    self.clearEmoticon()
    self.clearAt()
  end
  function ChatUIPool:hideNotUse()
    for index = self._count_ChattingIcon, self._maxcount_ChattingIcon do
      self._list_ChattingIcon[index]:SetShow(false)
    end
    for index = self._count_ChattingSender, self._maxcount_ChattingSender do
      self._list_ChattingSender[index]:SetShow(false)
    end
    for index = self._count_ChattingContents, self._maxcount_ChattingContents do
      self._list_ChattingContents[index]:SetShow(false)
    end
    for index = self._count_ChattingLinkedItem, self._maxcount_ChattingLinkedItem do
      self._list_ChattingLinkedItem[index]:SetShow(false)
    end
    for index = self._count_ChattingLinkedGuild, self._maxcount_ChattingLinkedGuild do
      self._list_ChattingLinkedGuild[index]:SetShow(false)
    end
    for index = self._count_ChattingGuildMark, self._maxcount_ChattingGuildMark do
      self._list_ChattingGuildMark[index]:SetShow(false)
    end
    for index = self._count_ChattingLinkedWebSite, self._maxcount_ChattingLinkedWebSite do
      self._list_ChattingLinkedWebSite[index]:SetShow(false)
    end
    for index = self._count_Emoticon, self._maxcount_Emoticon do
      self._list_Emoticon[index]:SetShow(false)
    end
    for index = self._count_At, self._maxcount_At do
      self._list_At[index]:SetShow(false)
    end
  end
  ChatUIPool:initialize(poolIndex)
  return ChatUIPool
end
function ChattingHistory:getPool(poolIndex)
  return self._uiPool[poolIndex]
end
function ChattingHistory:getPanel(poolIndex)
  return self._listPanel[poolIndex]
end
function PaGlobalFunc_ChattingHistory_GetSizeX()
  return _panel:GetSizeX()
end
function PaGlobalFunc_ChattingHistory_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_ChattingHistory_Open(chatType, byParty)
  if nil == byParty or false == byParty then
    _openByParty = false
    _panel:SetHorizonLeft()
  else
    _openByParty = true
    _panel:SetHorizonRight()
  end
  ChattingHistory:open(chatType)
  if false == _openByParty and true == PaGlobalFunc_ChattingInfo_GetShow() then
    ToClient_padSnapSetTargetPanel(Panel_Widget_Chatting_Renew)
  end
end
function ChattingHistory:open(chatType)
  _panel:SetShow(true)
  local bottomBGSizeY = 875
  local listPanelSizeY = 835
  local scrollSizeY = 820
  if true == _openByParty then
    bottomBGSizeY = 943
    listPanelSizeY = 913
    scrollSizeY = 890
  end
  self._ui.stc_BottomBG:SetSize(self._ui.stc_BottomBG:GetSizeX(), bottomBGSizeY)
  for ii = 1, self._tabCount do
    self._ui.scroll_list[ii]:SetSize(self._ui.scroll_list[ii]:GetSizeX(), scrollSizeY)
    self._listPanel[ii]:SetSize(self._listPanel[ii]:GetSizeX(), listPanelSizeY)
  end
  if 0 == self._currentTab then
    self:setTabTo(self._defaultTab)
  else
    self:setTabTo(self._currentTab)
  end
  self:selectMessage(self._currentSelectedMessage[self._currentTab])
end
function PaGlobalFunc_ChattingHistory_Close()
  ChattingHistory:close()
  if true == _openByParty then
    PaGlobalFunc_PartySetting_Close()
  end
end
function ChattingHistory:close()
  _panel:SetShow(false)
end
function FromClient_ChatHistory_Update()
  for panelIndex = 1, ChattingHistory._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
    if chatPanel:isUpdated() then
      ChattingHistory:getPool(panelIndex):clear()
      ChattingHistory:update(chatPanel, panelIndex)
    end
  end
  setisChangeFontSize(false)
end
local isResetSmoothScroll = false
function ChattingHistory:update(chatPanel, panelIndex, isShow)
  if nil == getSelfPlayer() or nil == getSelfPlayer():get() or not _panel:GetShow() then
    return
  end
  local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
  local currentPanel = ChattingHistory:getPanel(panelIndex)
  local poolCurrentUI = ChattingHistory:getPool(panelIndex)
  if nil == isShow then
    isShow = false
  end
  local isActivePanel = panelIndex == self._currentTab
  if isChangeFontSize() == true then
    local fontType = chatPanel:getChatFontSizeType()
    ToClient_getFontWrapper("BaseFont_10_Chat"):changeFontSize(ChattingOption_convertChatFontTypeToFontSize(fontType))
    ChatPanel_Update()
  end
  self._ui.scroll_list[panelIndex]:SetInterval(self._maxHistoryCount)
  self._ui.scroll_list[panelIndex]:SetCtrlWeight(0.1)
  self._ui.scroll_list[panelIndex]:SetControlPos(self._scroll_BTNPos[panelIndex])
  if true == isResetSmoothScroll or true == isSmoothWheelScroll or true == issmoothscroll then
    return
  end
  local addMessageCount = 0
  if false == ismsgin and true == isUsedSmoothChattingUp then
    if chatPanel:getPushchattingMsg() and false == issmoothupMessage then
      if 0 < chatPanel:getMessageCount() - premsgCount[panelIndex] and chatPanel:getMessageCount() - premsgCount[panelIndex] < 5 then
        if 0 == chatPanel:getPopMessageCount() then
          issmoothupMessage = true
          chattingUpTime = 0
          ismsgin = true
        else
          if chatPanel:getPopMessageCount() < prepopmsgCount[panelIndex] then
            prepopmsgCount[panelIndex] = 0
          end
          if 5 > chatPanel:getPopMessageCount() - prepopmsgCount[panelIndex] then
            issmoothupMessage = true
            chattingUpTime = 0
            ismsgin = true
          end
        end
      end
      if false == issmoothupMessage then
        if 0 == chatPanel:getPopMessageCount() then
          addMessageCount = chatPanel:getMessageCount() - premsgCount[panelIndex]
          premsgCount[panelIndex] = chatPanel:getMessageCount()
        else
          if chatPanel:getPopMessageCount() < prepopmsgCount[panelIndex] then
            prepopmsgCount[panelIndex] = 0
          end
          if ToClient_getChattingMaxContentsCount() == premsgCount[panelIndex] then
            addMessageCount = chatPanel:getPopMessageCount() - prepopmsgCount[panelIndex]
          else
            addMessageCount = chatPanel:getPopMessageCount() - prepopmsgCount[panelIndex] + ToClient_getChattingMaxContentsCount() - premsgCount[panelIndex]
            premsgCount[panelIndex] = ToClient_getChattingMaxContentsCount()
          end
          prepopmsgCount[panelIndex] = chatPanel:getPopMessageCount()
        end
      end
    end
  elseif false == isUsedSmoothChattingUp then
    if 0 == chatPanel:getPopMessageCount() then
      addMessageCount = chatPanel:getMessageCount() - premsgCount[panelIndex]
      premsgCount[panelIndex] = chatPanel:getMessageCount()
    else
      if chatPanel:getPopMessageCount() < prepopmsgCount[panelIndex] then
        prepopmsgCount[panelIndex] = 0
      end
      if ToClient_getChattingMaxContentsCount() == premsgCount[panelIndex] then
        addMessageCount = chatPanel:getPopMessageCount() - prepopmsgCount[panelIndex]
      else
        addMessageCount = chatPanel:getPopMessageCount() - prepopmsgCount[panelIndex] + ToClient_getChattingMaxContentsCount() - premsgCount[panelIndex]
        premsgCount[panelIndex] = ToClient_getChattingMaxContentsCount()
      end
      prepopmsgCount[panelIndex] = chatPanel:getPopMessageCount()
    end
  end
  if true == issmoothupMessage then
    for combinepanelIndex = 1, self._tabCount do
      local checkchatPanel = ToClient_getChattingPanel(combinepanelIndex - 1)
      local checkCombined = checkchatPanel:isCombinedToMainPanel()
      if checkCombined then
        if 0 == checkchatPanel:getPopMessageCount() then
          addMessageCount = checkchatPanel:getMessageCount() - premsgCount[combinepanelIndex]
          premsgCount[combinepanelIndex] = checkchatPanel:getMessageCount()
        else
          if checkchatPanel:getPopMessageCount() < prepopmsgCount[combinepanelIndex] then
            prepopmsgCount[combinepanelIndex] = 0
          end
          if ToClient_getChattingMaxContentsCount() == premsgCount[combinepanelIndex] then
            addMessageCount = checkchatPanel:getPopMessageCount() - prepopmsgCount[combinepanelIndex]
          else
            addMessageCount = checkchatPanel:getPopMessageCount() - prepopmsgCount[combinepanelIndex] + ToClient_getChattingMaxContentsCount() - premsgCount[combinepanelIndex]
            premsgCount[combinepanelIndex] = ToClient_getChattingMaxContentsCount()
          end
          prepopmsgCount[combinepanelIndex] = checkchatPanel:getPopMessageCount()
        end
        if checkchatPanel:isChattingPanelFreeze() and checkchatPanel:isFreezingMsgUpdatedValue() then
          self._scrollPosition[combinepanelIndex] = _scroll_Interval_AddPos[combinepanelIndex] + addMessageCount
          _scroll_Interval_AddPos[combinepanelIndex] = self._scrollPosition[combinepanelIndex]
        end
        checkchatPanel:setFreezingMsgUpdated(false)
      end
    end
    return
  end
  local messageIndex = self._scrollPosition[panelIndex]
  local chattingMessage = chatPanel:beginMessage(messageIndex)
  local chatting_content_PosY = currentPanel:GetSizeY() - 10
  poolCurrentUI:drawclear()
  while nil ~= chattingMessage do
    chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
    if chatting_content_PosY < 45 then
      break
    else
      chattingMessage = chatPanel:nextMessage()
      messageIndex = messageIndex + 1
    end
  end
  if chatPanel:isChattingPanelFreeze() and chatPanel:isFreezingMsgUpdatedValue() then
    self._scrollPosition[panelIndex] = _scroll_Interval_AddPos[panelIndex] + addMessageCount
    _scroll_Interval_AddPos[panelIndex] = self._scrollPosition[panelIndex]
  end
  self._currentSelectedMessage[panelIndex] = self._currentSelectedMessage[panelIndex] + addMessageCount
  self:updateSelectionBox()
  chatPanel:setFreezingMsgUpdated(false)
end
function FromClient_ChattingHistory_UpdatePerFrame(deltaTime)
  if isResetSmoothScroll then
    smoothResetScorllTime = smoothResetScorllTime + deltaTime / 2
    ChattingHistory:UpdateSmoothResetScrollContent(smoothResetScorllTime)
    return
  end
  if isSmoothWheelScroll then
    FromClient_ChatHistory_Update(true)
    smoothWheelScrollTime = smoothWheelScrollTime + deltaTime
    if smoothWheelScrollTime > 0.1 then
      isSmoothWheelScroll = false
      smoothWheelScrollTime = 0
      ChattingHistory:UpdateSmoothWheelScrollContent(deltaTime)
      ChattingHistory:updateSelectionBox()
      return
    end
    ChattingHistory:UpdateSmoothWheelScrollContent(deltaTime)
    ChattingHistory:updateSelectionBox()
    return
  end
  if issmoothscroll then
    smoothScorllTime = smoothScorllTime + deltaTime
    if smoothScorllTime > 0.01 then
      issmoothscroll = false
      smoothScorllTime = 0
      ChattingHistory:UpdateSmoothScrollContent()
      return
    end
    ChattingHistory:UpdateSmoothScrollContent()
  elseif issmoothupMessage then
    chattingUpTime = chattingUpTime + deltaTime
    if chattingUpTime > 0.2 then
      issmoothupMessage = false
    end
    ChattingHistory:UpdateSmoothChattingContent(chattingUpTime)
  end
end
function ChattingHistory:UpdateSmoothChattingContent(chattingUpTime)
  FromClient_ChatHistory_Update(true)
  local checkchattingupTime = 0
  for panelIndex = 1, self._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
    if chatPanel:isOpen() then
      local addMessageCount = 0
      if false == chatPanel:getPushchattingMsg() or true == chatPanel:isChattingPanelFreeze() then
        checkchattingupTime = 0
      else
        checkchattingupTime = chattingUpTime
      end
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local poolCurrentUI = ChattingHistory:getPool(panelIndex)
      local currentPanel = ChattingHistory:getPanel(panelIndex)
      local isActivePanel = panelIndex == self._currentTab
      local messageIndex = self._scrollPosition[panelIndex]
      local chattingMessage = chatPanel:beginMessage(messageIndex)
      local chatting_content_PosY = currentPanel:GetSizeY() - 10
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          ChattingHistory:getPanel(panelIndex):SetShow(false)
          ChattingHistory:getPanel(panelIndex):SetIgnore(true)
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if ChattingHistory:getPanel(0):GetShow() then
          ChattingHistory:getPanel(panelIndex):SetShow(true)
          ChattingHistory:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        ChattingHistory:getPanel(panelIndex):SetShow(false)
        ChattingHistory:getPanel(panelIndex):SetIgnore(true)
      end
      if false == isCombinedMainPanel then
        if false == issmoothupMessage then
          poolCurrentUI:drawclear()
          while true do
            if nil ~= chattingMessage then
              chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
              if chatting_content_PosY < 45 then
                break
              end
              chattingMessage = chatPanel:nextMessage()
              messageIndex = messageIndex + 1
              else
                if 0 ~= messageIndex then
                  poolCurrentUI:drawclear()
                  while true do
                    if nil ~= chattingMessage then
                      chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
                      if chatting_content_PosY < 45 then
                        break
                      end
                      chattingMessage = chatPanel:nextMessage()
                      messageIndex = messageIndex + 1
                      else
                        poolCurrentUI:drawclear()
                        deltascrollPosy[panelIndex] = 0
                        while true do
                          if nil ~= chattingMessage then
                            chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, checkchattingupTime)
                            if chatting_content_PosY < 45 then
                              break
                            end
                            chattingMessage = chatPanel:nextMessage()
                            messageIndex = messageIndex + 1
                            elseif isActivePanel then
                              if false == issmoothupMessage then
                                poolCurrentUI:drawclear()
                                while true do
                                  if nil ~= chattingMessage then
                                    chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
                                    if chatting_content_PosY < 45 then
                                      break
                                    end
                                    chattingMessage = chatPanel:nextMessage()
                                    messageIndex = messageIndex + 1
                                    else
                                      if 0 ~= messageIndex then
                                        poolCurrentUI:drawclear()
                                        while true do
                                          if nil ~= chattingMessage then
                                            chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
                                            if chatting_content_PosY < 45 then
                                              break
                                            end
                                            chattingMessage = chatPanel:nextMessage()
                                            messageIndex = messageIndex + 1
                                            else
                                              poolCurrentUI:drawclear()
                                              deltascrollPosy[panelIndex] = 0
                                              while nil ~= chattingMessage do
                                                chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, checkchattingupTime)
                                                if chatting_content_PosY < 45 then
                                                  break
                                                else
                                                  chattingMessage = chatPanel:nextMessage()
                                                  messageIndex = messageIndex + 1
                                                end
                                              end
                                            end
                                          end
                                        end
                                    end
                                  end
                                end
                            end
                          end
                        end
                      end
                    end
                  end
              end
            end
          end
    end
  end
  if chattingUpTime > 0.2 and false == issmoothupMessage then
    ismsgin = false
    for panelIndex = 1, count do
      local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
      chatPanel:setPushchattingMsg(false)
    end
  end
end
function ChattingHistory:UpdateSmoothScrollContent()
  for panelIndex = 1, self._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
    if chatPanel:isOpen() then
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local poolCurrentUI = ChattingHistory:getPool(panelIndex)
      local currentPanel = ChattingHistory:getPanel(panelIndex)
      local IsMouseOver = UI.checkIsInMouseAndEventPanel(currentPanel)
      if nil == isShow then
        isShow = false
      end
      if isMouseOnChattingViewIndex ~= nil and isMouseOnChattingViewIndex == panelIndex then
        isShow = isMouseOn
        if isShow then
          bgAlpah = 1
        end
      else
        isShow = IsMouseOver
      end
      local isActivePanel = panelIndex == self._currentTab
      local messageIndex = self._scrollPosition[panelIndex]
      local chattingMessage = chatPanel:beginMessage(messageIndex)
      local chatting_content_PosY = currentPanel:GetSizeY() - 10
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          ChattingHistory:getPanel(panelIndex):SetShow(false)
          ChattingHistory:getPanel(panelIndex):SetIgnore(true)
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if ChattingHistory:getPanel(0):GetShow() then
          ChattingHistory:getPanel(panelIndex):SetShow(true)
          ChattingHistory:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        ChattingHistory:getPanel(panelIndex):SetShow(false)
        ChattingHistory:getPanel(panelIndex):SetIgnore(true)
      end
      if false == isCombinedMainPanel then
        local messageIndex = self._scrollPosition[panelIndex]
        local chattingMessage = chatPanel:beginMessage(messageIndex)
        local chatting_content_PosY = currentPanel:GetSizeY() - 10
        poolCurrentUI:drawclear()
        while true do
          if nil ~= chattingMessage then
            chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
            if chatting_content_PosY < 45 then
              break
            end
            chattingMessage = chatPanel:nextMessage()
            messageIndex = messageIndex + 1
            elseif isActivePanel then
              local messageIndex = self._scrollPosition[panelIndex]
              local chattingMessage = chatPanel:beginMessage(messageIndex)
              local chatting_content_PosY = currentPanel:GetSizeY() - 10
              poolCurrentUI:drawclear()
              while nil ~= chattingMessage do
                chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
                if chatting_content_PosY < 45 then
                  break
                else
                  chattingMessage = chatPanel:nextMessage()
                  messageIndex = messageIndex + 1
                end
              end
            end
          end
        end
    end
  end
end
function ChattingHistory:UpdateSmoothResetScrollContent(chattingScrollingTime)
  FromClient_ChatHistory_Update(true)
  for panelIndex = 1, self._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
    if chatPanel:isOpen() then
      local isDraw = true
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local currentPanel = ChattingHistory:getPanel(panelIndex)
      local poolCurrentUI = ChattingHistory:getPool(panelIndex)
      local IsMouseOver = UI.checkIsInMouseAndEventPanel(currentPanel)
      if nil == isShow then
        isShow = false
      end
      if isMouseOnChattingViewIndex ~= nil and isMouseOnChattingViewIndex == panelIndex then
        isShow = isMouseOn
        if isShow then
          bgAlpah = 1
        end
      else
        isShow = IsMouseOver
      end
      local isActivePanel = panelIndex == self._currentTab
      if false == isCombinedMainPanel then
        local messageIndex = self._scrollPosition[panelIndex]
        local downIndex = 0
        local currdownPosY = 0
        local downPosY = 0
        if scrollresetSpeed < 5 then
          scrollresetSpeed = scrollresetSpeed + 2
        end
        currdownPosY = PaGlobal_AnimationEasingFun_easeOutQuadFragments(chattingScrollingTime, scrollresetSpeed * 0.9)
        downPosY = math.abs(currdownPosY - preDownPosY)
        if downPosY > 1 then
          preDownPosY = currdownPosY
        end
        downIndex = math.floor(downPosY)
        deltascrollPosy[panelIndex] = -(downPosY - downIndex)
        if false == isResetSmoothScroll then
          smoothResetScorllTime = 0
          preDownPosY = 0
          deltascrollPosy[panelIndex] = 0
          self._scrollPosition[panelIndex] = 0
          ChattingHistory._scroll_BTNPos[panelIndex] = 1
          ChattingHistory:addPosCalc(panelIndex)
          FromClient_ChatHistory_Update(true)
          break
        end
        self._scrollPosition[panelIndex] = self._scrollPosition[panelIndex] - downIndex
        if self._scrollPosition[panelIndex] <= 0 then
          smoothResetScorllTime = 0
          preDownPosY = 0
          deltascrollPosy[panelIndex] = 0
          self._scrollPosition[panelIndex] = 0
          ChattingHistory._scroll_BTNPos[panelIndex] = 1
          ChattingHistory:addPosCalc(panelIndex)
          isResetSmoothScroll = false
          FromClient_ChatHistory_Update(true)
          break
        end
        self._ui.scroll_list[panelIndex]:SetControlPos(1 - self._scrollPosition[panelIndex] / (self._maxHistoryCount - 1))
        ChattingHistory:addPosCalc(panelIndex)
        messageIndex = self._scrollPosition[panelIndex]
        local chattingMessage = chatPanel:beginMessage(messageIndex)
        local chatting_content_PosY = currentPanel:GetSizeY() - 10
        if isDraw then
          poolCurrentUI:drawclear()
          while true do
            if nil ~= chattingMessage then
              chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
              if chatting_content_PosY < 38 then
                break
              end
              chattingMessage = chatPanel:nextMessage()
              messageIndex = messageIndex + 1
              elseif isActivePanel then
                local messageIndex = self._scrollPosition[panelIndex]
                local downIndex = 0
                local currdownPosY = 0
                local downPosY = 0
                if scrollresetSpeed < 5 then
                  scrollresetSpeed = scrollresetSpeed + 2
                end
                currdownPosY = PaGlobal_AnimationEasingFun_easeOutQuadFragments(chattingScrollingTime, scrollresetSpeed * 0.9)
                downPosY = math.abs(currdownPosY - preDownPosY)
                if downPosY > 1 then
                  preDownPosY = currdownPosY
                end
                downIndex = math.floor(downPosY)
                deltascrollPosy[panelIndex] = -(downPosY - downIndex)
                if false == isResetSmoothScroll then
                  smoothResetScorllTime = 0
                  preDownPosY = 0
                  deltascrollPosy[panelIndex] = 0
                  self._scrollPosition[panelIndex] = 0
                  self._scroll_BTNPos[panelIndex] = 1
                  self:addPosCalc(panelIndex)
                  FromClient_ChatHistory_Update(true)
                  break
                end
                self._scrollPosition[panelIndex] = self._scrollPosition[panelIndex] - downIndex
                if self._scrollPosition[panelIndex] <= 0 then
                  smoothResetScorllTime = 0
                  preDownPosY = 0
                  deltascrollPosy[panelIndex] = 0
                  self._scrollPosition[panelIndex] = 0
                  self._scroll_BTNPos[panelIndex] = 1
                  self:addPosCalc(panelIndex)
                  isResetSmoothScroll = false
                  FromClient_ChatHistory_Update(true)
                  break
                end
                self._ui.scroll_list[panelIndex]:SetControlPos(1 - self._scrollPosition[panelIndex] / (self._maxHistoryCount - 1))
                self:addPosCalc(panelIndex)
                messageIndex = self._scrollPosition[panelIndex]
                local chattingMessage = chatPanel:beginMessage(messageIndex)
                local chatting_content_PosY = currentPanel:GetSizeY() - 10
                if isDraw then
                  poolCurrentUI:drawclear()
                  while nil ~= chattingMessage do
                    chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
                    if chatting_content_PosY < 38 then
                      break
                    else
                      chattingMessage = chatPanel:nextMessage()
                      messageIndex = messageIndex + 1
                    end
                  end
                end
              end
            end
          end
        end
    end
  end
  if false == isResetSmoothScroll then
    _tabButton_PosX = 0
    for panelIndex = 1, count do
      local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
      if chatPanel:isOpen() then
        ChattingHistory:getPool(panelIndex):clear()
        ChattingHistory:update(chatPanel, panelIndex)
      end
    end
  end
end
function ChattingHistory:UpdateSmoothWheelScrollContent(deltaTime)
  local panelIndex = self._currentTab
  local scroll = self._ui.scroll_list[panelIndex]
  local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
  local currentPanel = self:getPanel(panelIndex)
  local poolCurrentUI = self:getPool(panelIndex)
  local isActivePanel = panelIndex == self._currentTab
  if _isScrollingUp then
    scroll:SetControlPos(self._scroll_BTNPos[panelIndex] - 1 / (self._maxHistoryCount - 1) * deltaTime * 50)
  else
    scroll:SetControlPos(self._scroll_BTNPos[panelIndex] + 1 / (self._maxHistoryCount - 1) * deltaTime * 50)
  end
  if 1 < scroll:GetControlPos() then
    scroll:SetControlPos(1)
  end
  if scroll:GetControlPos() < 0 then
    scroll:SetControlPos(0)
  end
  local index = math.floor((1 - scroll:GetControlPos()) * (self._maxHistoryCount - 1))
  if 0 == index then
    deltascrollPosy[panelIndex] = (1 - scroll:GetControlPos()) * (self._maxHistoryCount - 1) % 1
  else
    deltascrollPosy[panelIndex] = ((1 - scroll:GetControlPos()) * (self._maxHistoryCount - 1) - index) % 1
  end
  preScrollControlPos[panelIndex] = scroll:GetControlPos()
  self._scrollPosition[panelIndex] = index
  self._scroll_BTNPos[panelIndex] = scroll:GetControlPos()
  self:addPosCalc(panelIndex)
  local messageIndex = self._scrollPosition[panelIndex]
  local chattingMessage = chatPanel:beginMessage(messageIndex)
  local chatting_content_PosY = currentPanel:GetSizeY() - 10
  poolCurrentUI:drawclear()
  while nil ~= chattingMessage do
    chatting_content_PosY = Chatnew_CreateChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, deltascrollPosy[panelIndex], self._cacheSimpleUI, 0)
    if chatting_content_PosY < 45 then
      break
    else
      chattingMessage = chatPanel:nextMessage()
      messageIndex = messageIndex + 1
    end
  end
end
function Input_ChatHistory_SelectInList(isUp)
  local self = ChattingHistory
  if isUp then
    self:selectMessage(self._currentSelectedMessage[self._currentTab] + 1, true)
  elseif not isUp then
    self:selectMessage(self._currentSelectedMessage[self._currentTab] - 1, true)
  end
end
function Input_ChattingInfo_ChangeHistoryTab(isNext)
  if not _panel:GetShow() then
    return
  end
  Input_ChatHistory_ChangeToNextTab(isNext)
end
function Input_ChatHistory_SelectInList_InParty(isUp)
  if false == PaGlobalFunc_PartySetting_GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  Input_ChatHistory_SelectInList(isUp)
end
function PaGlobalFunc_ChattingInfo_InviteParty_InParty()
  if false == ToClient_isCommunicationAllowed() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    ToClient_showPrivilegeError()
    return
  end
  if false == PaGlobalFunc_PartySetting_GetShow() then
    return
  end
  local name = PaGlobalFunc_ChattingHistory_GetSelectedSenderForPartyInvite()
  if nil == name then
    return
  end
  RequestParty_inviteCharacter(name)
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERACTION_ACK_INVITE", "targetName", name))
end
function PaGlobalFunc_ChattingInfo_Close_InParty()
  if false == PaGlobalFunc_PartySetting_GetShow() then
    return
  end
  local self = ChattingHistory
  self:close()
  PaGlobalFunc_PartySetting_Close()
end
function ChattingHistory:setTabTo(index)
  if false == _panel:GetShow() then
    return
  end
  self._currentTab = index
  for ii = 1, #self._ui.rdo_chatTypeList do
    self._ui.rdo_chatTypeList[ii]:ChangeTextureInfoNameAsync("Renewal/Button/Console_TapBtn_01.dds")
    if ii == self._currentTab then
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.rdo_chatTypeList[ii], _tabButtonOnUV[ii][1], _tabButtonOnUV[ii][2], _tabButtonOnUV[ii][3], _tabButtonOnUV[ii][4])
      self._ui.rdo_chatTypeList[ii]:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.rdo_chatTypeList[ii]:setRenderTexture(self._ui.rdo_chatTypeList[ii]:getBaseTexture())
      self._listPanel[ii]:SetShow(true)
      self._ui.scroll_list[ii]:SetShow(true)
      self._ui.txt_tabName:SetText(self._tabName[self._currentTab])
    else
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.rdo_chatTypeList[ii], _tabButtonBaseUV[ii][1], _tabButtonBaseUV[ii][2], _tabButtonBaseUV[ii][3], _tabButtonBaseUV[ii][4])
      self._ui.rdo_chatTypeList[ii]:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.rdo_chatTypeList[ii]:setRenderTexture(self._ui.rdo_chatTypeList[ii]:getBaseTexture())
      self._listPanel[ii]:SetShow(false)
      self._ui.scroll_list[ii]:SetShow(false)
    end
  end
  FromClient_ChatHistory_Update()
  self:selectMessage(self._currentSelectedMessage[self._currentTab], false)
end
function ChattingHistory:selectMessage(num, withScroll)
  local chatPanel = ToClient_getChattingPanel(self._currentTab - 1)
  local chatCount = chatPanel:getMessageCount()
  if num > chatCount then
    self._currentSelectedMessage[self._currentTab] = chatCount
  elseif num < 1 then
    self._currentSelectedMessage[self._currentTab] = 1
  else
    self._currentSelectedMessage[self._currentTab] = num
  end
  self:updateSelectionBox()
  local selectYPos = self._ui.stc_selectedLine:GetPosY()
  if not withScroll then
    return
  end
  self._lowestY = self._listPanel[self._currentTab]:GetPosY() + self._listPanel[self._currentTab]:GetSizeY()
  if selectYPos < 300 then
    Input_ChattingHistory_Scroll(true)
  elseif selectYPos > self._lowestY - 300 then
    Input_ChattingHistory_Scroll(false)
  end
end
function ChattingHistory:updateSelectionBox()
  if not _isInitialized or false == _panel:GetShow() or 0 == self._currentTab then
    return
  end
  self._ui.stc_selectedLine:SetMonoTone(false == _snappedOnThisPanel and PaGlobalFunc_PartySetting_GetShow())
  local chatPanel = ToClient_getChattingPanel(self._currentTab - 1)
  local chatCount = chatPanel:getMessageCount()
  if chatCount < 1 then
    self._ui.stc_selectedLine:SetShow(false)
    return
  else
    self._ui.stc_selectedLine:SetShow(true)
  end
  local pool = self:getPool(self._currentTab)
  local contentControl = pool._list_ContentMessageIndex[self._currentSelectedMessage[self._currentTab] - 1]
  if nil == contentControl or not contentControl:GetShow() then
    return
  end
  local belowContentControl, selectionYSize
  local selectYPos = contentControl:GetPosY() + self._ui.stc_sampleBG:GetPosY() - 4
  self._lowestY = self._listPanel[self._currentTab]:GetPosY() + self._listPanel[self._currentTab]:GetSizeY()
  if 1 < self._currentSelectedMessage[self._currentTab] then
    belowContentControl = pool._list_ContentMessageIndex[self._currentSelectedMessage[self._currentTab] - 2]
    selectionYSize = belowContentControl:GetPosY() - contentControl:GetPosY()
  else
    selectionYSize = self._lowestY - selectYPos
  end
  self._ui.stc_selectedLine:SetPosY(selectYPos)
  self._ui.stc_selectedLine:SetSize(self._ui.stc_selectedLine:GetSizeX(), selectionYSize + 2)
  local sender
  sender = PaGlobalFunc_ChattingHistory_GetSelectedSenderForPartyInvite()
  if true == PaGlobalFunc_PartySetting_GetShow() then
    self._ui.txt_keyGuideA:SetShow(nil ~= sender and "" ~= sender)
  else
    self._ui.txt_keyGuideA:SetShow(false)
    sender = PaGlobalFunc_ChattingHistory_GetSelectedSender()
    PaGlobalFunc_ChattingInfo_SetShowFunctionKeyGuide(nil ~= sender and "" ~= sender)
  end
end
function Input_ChatHistory_ChangeToNextTab(isNext)
  local self = ChattingHistory
  local index = self._currentTab
  if true == isNext then
    index = index + 1
  else
    index = index - 1
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if index < TAB_TYPE.CUSTOM then
    index = TAB_TYPE.SYSTEM
  elseif index > #self._ui.rdo_chatTypeList then
    index = TAB_TYPE.CUSTOM
  end
  self:setTabTo(index)
end
function Input_ChattingHistory_Scroll(isUp)
  if isSmoothWheelScroll then
    return
  end
  isSmoothWheelScroll = true
  _isScrollingUp = isUp
end
function PaGlobalFunc_ChattingHistory_ResetAllScroll()
  local self = ChattingHistory
  for panelIndex = 1, self._tabCount do
    self._scrollPosition[panelIndex] = 0
    self._scroll_BTNPos[panelIndex] = 1
    local pool = self:getPool(panelIndex)
    self._ui.scroll_list:SetControlBottom()
  end
end
function PaGlobalFunc_ChattingHistory_GetSelectedSender(nameType)
  local self = ChattingHistory
  local chatPanel = ToClient_getChattingPanel(self._currentTab - 1)
  local chattingMessage = chatPanel:getChattingMessageByIndex(self._currentSelectedMessage[self._currentTab] - 1)
  if nil == nameType then
    nameType = ToClient_getChatNameType()
  end
  if nil ~= chattingMessage and nil ~= chattingMessage:getSender(nameType) and CHAT_TYPE.System ~= chattingMessage.chatType and CHAT_TYPE.Notice ~= chattingMessage.chatType and false == chattingMessage.isMe then
    return chattingMessage:getSender(nameType)
  else
    return nil
  end
end
function PaGlobalFunc_ChattingHistory_GetSelectedSenderXuid()
  local self = ChattingHistory
  local chatPanel = ToClient_getChattingPanel(self._currentTab - 1)
  local chattingMessage = chatPanel:getChattingMessageByIndex(self._currentSelectedMessage[self._currentTab] - 1)
  if nil ~= chattingMessage and CHAT_TYPE.System ~= chattingMessage.chatType and CHAT_TYPE.Notice ~= chattingMessage.chatType and false == chattingMessage.isMe and nil ~= chattingMessage:getXuid() then
    return chattingMessage:getXuid()
  else
    return nil
  end
end
function PaGlobalFunc_ChattingHistory_GetSelectedSenderForPartyInvite(nameType)
  local self = ChattingHistory
  local chatPanel = ToClient_getChattingPanel(self._currentTab - 1)
  local chattingMessage = chatPanel:getChattingMessageByIndex(self._currentSelectedMessage[self._currentTab] - 1)
  if nil == nameType then
    nameType = ToClient_getChatNameType()
  end
  if nil ~= chattingMessage and nil ~= chattingMessage:getSender(nameType) and CHAT_TYPE.System ~= chattingMessage.chatType and CHAT_TYPE.Notice ~= chattingMessage.chatType and true == chattingMessage.isSameChannel and false == chattingMessage.isMe then
    return chattingMessage:getSender(nameType)
  else
    return nil
  end
end
function PaGlobalFunc_ChattingHistory_GetCurrentTabIndex()
  return ChattingHistory._currentTab
end
local saveWhisperTime = getTime()
local checkWhistperTime = toUint64(0, 60000)
local sendPossibleTime = toUint64(0, 0)
function FromClient_ChattingHistory_PrivateChat()
  if sendPossibleTime <= getTime() then
    _AudioPostEvent_SystemUiForXBOX(99, 0)
    sendPossibleTime = getTime() + checkWhistperTime
  end
end
function FromClient_ChattingHistory_PadSnapChangePanel(fromPanel, toPanel)
  if nil ~= toPanel and _panel:GetKey() == toPanel:GetKey() then
    if false == _snappedOnThisPanel then
      _AudioPostEvent_SystemUiForXBOX(51, 7)
    end
    if true == PaGlobalFunc_ChattingInfo_GetShow() then
      ToClient_padSnapSetTargetPanel(Panel_Widget_Chatting_Renew)
    else
      _snappedOnThisPanel = true
      ChattingHistory._ui.stc_keyGuideGroup:SetShow(true)
    end
  else
    _snappedOnThisPanel = false
    ChattingHistory._ui.stc_keyGuideGroup:SetShow(false)
  end
  ChattingHistory:updateSelectionBox()
end
function ChatPanel_Update()
  for panelIndex = 1, ChattingHistory._tabCount do
    local chatPanel = ToClient_getChattingPanel(panelIndex - 1)
    local chatUIPool = ChattingHistory:getPool(panelIndex)
    for chattingContents_idx = 1, ChattingHistory._cloneCount do
      chatUIPool._list_ChattingSender[chattingContents_idx]:SetText("")
      chatUIPool._list_ChattingSender[chattingContents_idx]:SetSize(chatUIPool._list_ChattingSender[chattingContents_idx]:GetSizeX(), chatUIPool._list_ChattingSender[chattingContents_idx]:GetSizeY())
    end
    chatUIPool:clear()
  end
end
function PaGlobalFunc_ChattingHistory_SetChatIcon(chatType, chatting_Icon)
  if nil == _chatTypeUV[chatType] then
    chatting_Icon:SetShow(false)
    return
  else
    chatting_Icon:SetShow(true)
    chatting_Icon:SetSize(58, 20)
    local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, _chatTypeUV[chatType][1], _chatTypeUV[chatType][2], _chatTypeUV[chatType][3], _chatTypeUV[chatType][4])
    chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
  end
end
function ChattingHistory:chatTypeToTabType(chatType)
  for ii = 1, _chatPanelCount do
    if true == _tabData[ii][chatType] then
      return ii
    end
  end
  UI.ASSERT(false, "Tab Not Found For chatType .." .. chatType)
  return nil
end
function ChattingHistory:addPosCalc(panelIndex)
  local panel = ToClient_getChattingPanel(panelIndex - 1)
  if panel:setChattingPanelFreeze(true, self._scrollPosition[panelIndex]) == false then
    _scroll_Interval_AddPos[panelIndex] = 0
  end
  _scroll_Interval_AddPos[panelIndex] = self._scrollPosition[panelIndex]
end
function PaGlobalFunc_isItemEmticon(EmoticonKey)
  return true
end
