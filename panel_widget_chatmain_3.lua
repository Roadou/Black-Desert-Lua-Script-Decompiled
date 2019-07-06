local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_CT = CppEnums.ChatType
local UI_Group = Defines.UIGroup
function PaGlobal_ChatMain:initialize_Pool()
  if true == PaGlobal_ChatMain._initialize then
    return
  end
  PaGlobal_ChatMain._chatRenderMode = PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  })
  local divisionPanel, panel, panelSizeX, panelSizeY, chatUI
  for poolIndex = 0, PaGlobal_ChatMain._POOLCOUNT - 1 do
    PaGlobal_ChatMain._listPanel[poolIndex] = PaGlobal_ChatMain:createPanel(poolIndex, Panel_Chat)
    PaGlobal_ChatMain._listChatUIPool[poolIndex] = PaGlobal_ChatMain:createPool(poolIndex, Panel_Chat, PaGlobal_ChatMain._listPanel[poolIndex])
    divisionPanel = ToClient_getChattingPanel(poolIndex)
    panel = PaGlobal_ChatMain._listPanel[poolIndex]
    chatUI = PaGlobal_ChatMain._listChatUIPool[poolIndex]
    if 0 < divisionPanel:getPanelSizeX() then
      panelSizeX = divisionPanel:getPanelSizeX()
      panelSizeY = divisionPanel:getPanelSizeY()
      panel:SetSize(panelSizeX, panelSizeY)
      chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
      chatUI._list_Scroll[0]:SetSize(chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 67)
      for chattingContents_idx = 0, chatUI._MAXCOUNT_CHATTINGCONTENTS - 1 do
        chatUI._list_ChattingContents[chattingContents_idx]:SetSize(panelSizeX - 25, chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY())
      end
      chatUI._list_ResizeButton[0]:SetPosX(panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetPosX(panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetControlBottom()
    else
      panelSizeX = PaGlobal_ChatMain._DEFAULT_PANELSIZE_X
      panelSizeY = PaGlobal_ChatMain._DEFAULT_PANELSIZE_Y
      panel:SetSize(panelSizeX, panelSizeY)
      chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
      chatUI._list_Scroll[0]:SetSize(chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 67)
      for chattingContents_idx = 0, chatUI._MAXCOUNT_CHATTINGCONTENTS - 1 do
        chatUI._list_ChattingContents[chattingContents_idx]:SetSize(panelSizeX - 25, chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY())
      end
      chatUI._list_ResizeButton[0]:SetPosX(panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetPosX(panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetControlBottom()
    end
    if 0 > divisionPanel:getPositionX() and 0 > divisionPanel:getPositionY() then
      panel:SetPosX(0)
      panel:SetPosY(getScreenSizeY() - panel:GetSizeY() - 35)
    else
      panel:SetPosX(divisionPanel:getPositionX())
      panel:SetPosY(divisionPanel:getPositionY())
    end
    PaGlobal_ChatMain._transparency[poolIndex] = divisionPanel:getTransparency()
    FGlobal_PanelMove(panel, true)
  end
end
function PaGlobal_ChatMain:createPanel(poolIndex, stylePanel)
  UI.ASSERT_NAME(nil ~= poolIndex, "chatUIPool:createPanel poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= stylePanel, "chatUIPool:createPanel stylePanel nil", "\236\178\156\235\167\140\234\184\176")
  local panel
  if 0 == poolIndex then
    panel = UI.createPanelAndSetPanelRenderMode("Panel_Chat" .. poolIndex, UI_Group.PAGameUIGroup_Dialog, PaGlobal_ChatMain._chatRenderMode)
  else
    panel = UI.createPanelAndSetPanelRenderMode("Panel_Chat" .. poolIndex, UI_Group.PAGameUIGroup_Chatting, PaGlobal_ChatMain._chatRenderMode)
  end
  CopyBaseProperty(stylePanel, panel)
  panel:ChangeSpecialTextureInfoName("new_ui_common_forlua/Window/Chatting/Chatting_Win_transparency.dds")
  panel:setMaskingChild(true)
  panel:setGlassBackground(true)
  panel:SetSize(PaGlobal_ChatMain._DEFAULT_PANELSIZE_X, PaGlobal_ChatMain._DEFAULT_PANELSIZE_Y)
  panel:SetPosX(0)
  panel:SetPosY(getScreenSizeY() - panel:GetSizeY() - 35)
  panel:SetColor(UI_color.C_FFFFFFFF)
  panel:SetIgnore(false)
  panel:SetDragAll(false)
  panel:addInputEvent("Mouse_UpScroll", "Chatting_ScrollEvent( " .. poolIndex .. ", true )")
  panel:addInputEvent("Mouse_DownScroll", "Chatting_ScrollEvent( " .. poolIndex .. ", false )")
  panel:addInputEvent("Mouse_On", "HandleEventOn_ChatMainPanelTransparency( " .. poolIndex .. ", false )")
  panel:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency( " .. poolIndex .. "," .. 9999 .. " )")
  local show = ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_ChattingWindow, poolIndex, CppEnums.PanelSaveType.PanelSaveType_IsShow)
  panel:SetShow(show)
  return panel
end
function PaGlobal_ChatMain:createPool(poolIndex, poolStylePanel, poolParentPanel)
  UI.ASSERT_NAME(nil ~= poolIndex, "chatUIPool:createPool poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolStylePanel, "chatUIPool:createPool poolStylePanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolParentPanel, "chatUIPool:createPool poolParentPanel nil", "\236\178\156\235\167\140\234\184\176")
  local chatUIPool = {
    _list_PanelBG = {},
    _list_TitleTab = {},
    _list_TitleTabText = {},
    _list_TitleTabConfigButton = {},
    _list_OtherTab = {},
    _list_AddTab = {},
    _list_ResizeButton = {},
    _list_PanelDivision = {},
    _list_PanelDelete = {},
    _list_ChattingIcon = {},
    _list_RecommandIcon = {},
    _list_ChattingSender = {},
    _list_ChattingContents = {},
    _list_ChattingLinkedItem = {},
    _list_ChattingLinkedGuild = {},
    _list_ChattingGuildMark = {},
    _list_ChattingLinkedWebSite = {},
    _list_Scroll = {},
    _list_CloseButton = {},
    _list_ScrollReset = {},
    _list_MoreList = {},
    _list_Emoticon = {},
    _list_At = {},
    _list_ChatEmoticon = {},
    _list_EmoticonAni = {},
    _list_SenderMessageIndex = {},
    _list_LinkedItemMessageIndex = {},
    _list_LinkedGuildMessageIndex = {},
    _list_LinkedWebSiteMessageIndex = {},
    _list_LinkedAtMessageIndex = {},
    _count_PanelBG = 0,
    _MAXCOUNT_PANELBG = 5,
    _count_TitleTab = 0,
    _MAXCOUNT_TITLETAB = 5,
    _count_TitleTabText = 0,
    _MAXCOUNT_TITLETABTEXT = 5,
    _count_TitleTabConfigButton = 0,
    _MAXCOUNT_TITLETABCONFIGBUTTON = 5,
    _count_OtherTab = 0,
    _MAXCOUNT_OTHERTAB = 4,
    _count_AddTab = 0,
    _MAXCOUNT_ADDTAB = 1,
    _count_PanelDivision = 0,
    _MAXCOUNT_PANELDIVISION = 5,
    _count_PanelDelete = 0,
    _MAXCOUNT_PANELDELETE = 5,
    _count_ResizeButton = 0,
    _MAXCOUNT_RESIZEBUTTON = 5,
    _count_ChattingIcon = 0,
    _MAXCOUNT_CHATTINGICON = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_RecommandIcon = 0,
    _MAXCOUNT_RECOMMANDICON = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingSender = 0,
    _MAXCOUNT_CHATTINGSENDER = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingContents = 0,
    _MAXCOUNT_CHATTINGCONTENTS = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingLinkedItem = 0,
    _MAXCOUNT_CHATTINGLINKEDITEM = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingLinkedGuild = 0,
    _MAXCOUNT_CHATTINGLINKEDGUILD = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingGuildMark = 0,
    _MAXCOUNT_CHATTINGGUILDMARK = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_ChattingLinkedWebSite = 0,
    _MAXCOUNT_CHATTINGLINKEDWEBSITE = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_Scroll = 0,
    _MAXCOUNT_SCROLL = 1,
    _count_CloseButton = 0,
    _MAXCOUNT_CLOSEBUTTON = 4,
    _count_ScrollReset = 0,
    _MAXCOUNT_SCROLLRESET = 4,
    _count_MoreList = 0,
    _MAXCOUNT_MORELIST = 4,
    _count_Emoticon = 0,
    _MAXCOUNT_EMOTICON = PaGlobal_ChatMain._MAX_LISTCOUNT * 4,
    _count_ChatEmoticon = 0,
    _MAXCOUNT_CHATEMOTICON = PaGlobal_ChatMain._MAX_LISTCOUNT * 15,
    _count_At = 0,
    _MAXCOUNT_AT = PaGlobal_ChatMain._MAX_LISTCOUNT,
    _count_EmoticonAni = 0,
    _MAXCOUNT_EMOTICONANI = 1
  }
  function chatUIPool:prepareControl(Panel, parentControl, createdCotrolList, controlType, controlName, createCount)
    UI.ASSERT_NAME(nil ~= Panel, "chatUIPool:prepareControl Panel nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= parentControl, "chatUIPool:prepareControl parentControl nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= createdCotrolList, "chatUIPool:prepareControl createdCotrolList nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= controlType, "chatUIPool:prepareControl controlType nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= controlName, "chatUIPool:prepareControl controlName nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= createCount, "chatUIPool:prepareControl createCount nil", "\236\178\156\235\167\140\234\184\176")
    local styleUI = UI.getChildControl(Panel, controlName)
    for index = 0, createCount do
      createdCotrolList[index] = UI.createControl(controlType, parentControl, controlName .. index)
      CopyBaseProperty(styleUI, createdCotrolList[index])
      createdCotrolList[index]:SetShow(true)
    end
  end
  function chatUIPool:initialize(stylePanel, parentControl, poolIndex)
    UI.ASSERT_NAME(nil ~= stylePanel, "chatUIPool:initialize stylePanel nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= parentControl, "chatUIPool:initialize parentControl nil", "\236\178\156\235\167\140\234\184\176")
    UI.ASSERT_NAME(nil ~= poolIndex, "chatUIPool:initialize poolIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_PanelBG, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_ChattingBG", chatUIPool._MAXCOUNT_PANELBG)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_TitleTab, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_TitleButton", chatUIPool._MAXCOUNT_TITLETAB)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_TitleTabText, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_chattingText", chatUIPool._MAXCOUNT_TITLETABTEXT)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_TitleTabConfigButton, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_Setting", chatUIPool._MAXCOUNT_TITLETABCONFIGBUTTON)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_OtherTab, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_OtherChat", chatUIPool._MAXCOUNT_OTHERTAB)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_AddTab, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_AddChat", chatUIPool._MAXCOUNT_ADDTAB)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_PanelDivision, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_PanelDivision", chatUIPool._MAXCOUNT_PANELDIVISION)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_PanelDelete, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_PanelCombine", chatUIPool._MAXCOUNT_PANELDELETE)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_ResizeButton, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_Size", chatUIPool._MAXCOUNT_RESIZEBUTTON)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingIcon, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "Static_ChatIcon", chatUIPool._MAXCOUNT_CHATTINGICON)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_RecommandIcon, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_Recommand", chatUIPool._MAXCOUNT_RECOMMANDICON)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingSender, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_ChatSender", chatUIPool._MAXCOUNT_CHATTINGSENDER)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingContents, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_ChatContent", chatUIPool._MAXCOUNT_CHATTINGCONTENTS)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingLinkedItem, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_ChatLinkedItem", chatUIPool._MAXCOUNT_CHATTINGLINKEDITEM)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingLinkedGuild, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_ChatLinkedGuild", chatUIPool._MAXCOUNT_CHATTINGLINKEDGUILD)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingGuildMark, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_GuildMark", chatUIPool._MAXCOUNT_CHATTINGGUILDMARK)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChattingLinkedWebSite, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "StaticText_ChatLinkedWebSite", chatUIPool._MAXCOUNT_CHATTINGLINKEDWEBSITE)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_Scroll, UI_PUCT.PA_UI_CONTROL_SCROLL, "Scroll_Chatting", chatUIPool._MAXCOUNT_SCROLL)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_CloseButton, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_Close", chatUIPool._MAXCOUNT_CLOSEBUTTON)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_ScrollReset, UI_PUCT.PA_UI_CONTROL_BUTTON, "Button_ScrollReset", chatUIPool._MAXCOUNT_SCROLLRESET)
    chatUIPool:prepareControl(stylePanel, parentControl, chatUIPool._list_MoreList, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_MoreList", chatUIPool._MAXCOUNT_MORELIST)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_Emoticon, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_Emoticon", chatUIPool._MAXCOUNT_EMOTICON)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_ChatEmoticon, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_ChatEmoticon", chatUIPool._MAXCOUNT_CHATEMOTICON)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_At, UI_PUCT.PA_UI_CONTROL_STATICTEXT, "Static_At", chatUIPool._MAXCOUNT_AT)
    chatUIPool:prepareControl(stylePanel, chatUIPool._list_PanelBG[0], chatUIPool._list_EmoticonAni, UI_PUCT.PA_UI_CONTROL_STATIC, "Static_ChatEmoticon_SequenceAni", chatUIPool._MAXCOUNT_EMOTICONANI)
    for index = 0, chatUIPool._MAXCOUNT_CHATTINGLINKEDITEM do
      chatUIPool._list_ChattingLinkedItem[index]:addInputEvent("Mouse_On", "HandleOn_ChattingLinkedItem(" .. poolIndex .. ", " .. index .. ", false)")
      chatUIPool._list_ChattingLinkedItem[index]:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. poolIndex .. ", true )")
      chatUIPool._list_ChattingLinkedItem[index]:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. poolIndex .. ")")
      chatUIPool._list_ChattingLinkedItem[index]:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. poolIndex .. ")")
      chatUIPool._list_ChattingLinkedItem[index]:addInputEvent("Mouse_LUp", "HandleOn_ChattingLinkedItem(" .. poolIndex .. ", " .. index .. ", true)")
    end
    for index = 0, chatUIPool._MAXCOUNT_CHATTINGLINKEDGUILD do
      chatUIPool._list_ChattingLinkedGuild[index]:addInputEvent("Mouse_LUp", "HandleOn_ChattingLinkedGuild(" .. poolIndex .. ", " .. index .. ", 2)")
    end
    for index = 0, chatUIPool._MAXCOUNT_CHATTINGLINKEDWEBSITE do
      chatUIPool._list_ChattingLinkedWebSite[index]:addInputEvent("Mouse_LUp", "HandleOn_ChattingLinkedWebSite(" .. poolIndex .. ", " .. index .. ", 2)")
    end
    for index = 0, chatUIPool._MAXCOUNT_CHATTINGSENDER do
      chatUIPool._list_ChattingSender[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_ChattingSender(" .. poolIndex .. ", " .. index .. ")")
      chatUIPool._list_ChattingSender[index]:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. poolIndex .. ", false )")
      chatUIPool._list_ChattingSender[index]:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. poolIndex .. ")")
      chatUIPool._list_ChattingSender[index]:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. poolIndex .. ")")
    end
    for index = 0, chatUIPool._MAXCOUNT_CHATTINGICON do
      chatUIPool._list_ChattingIcon[index]:SetIgnore(false)
    end
    for index = 0, chatUIPool._MAXCOUNT_RECOMMANDICON do
      chatUIPool._list_RecommandIcon[index]:SetIgnore(false)
    end
    chatUIPool:clear()
  end
  function chatUIPool:newPanelBG()
    chatUIPool._count_PanelBG = chatUIPool._count_PanelBG + 1
    return chatUIPool._list_PanelBG[chatUIPool._count_PanelBG - 1]
  end
  function chatUIPool:newTitleTab()
    chatUIPool._count_TitleTab = chatUIPool._count_TitleTab + 1
    return chatUIPool._list_TitleTab[chatUIPool._count_TitleTab - 1]
  end
  function chatUIPool:newTitleTabText()
    chatUIPool._count_TitleTabText = chatUIPool._count_TitleTabText + 1
    return chatUIPool._list_TitleTabText[chatUIPool._count_TitleTabText - 1]
  end
  function chatUIPool:newTitleTabConfigButton()
    chatUIPool._count_TitleTabConfigButton = chatUIPool._count_TitleTabConfigButton + 1
    return chatUIPool._list_TitleTabConfigButton[chatUIPool._count_TitleTabConfigButton - 1]
  end
  function chatUIPool:newOtherTab()
    chatUIPool._count_OtherTab = chatUIPool._count_OtherTab + 1
    return chatUIPool._list_OtherTab[chatUIPool._count_OtherTab - 1]
  end
  function chatUIPool:newAddTab()
    chatUIPool._count_AddTab = chatUIPool._count_AddTab + 1
    return chatUIPool._list_AddTab[chatUIPool._count_AddTab - 1]
  end
  function chatUIPool:newPanelDivision()
    chatUIPool._count_PanelDivision = chatUIPool._count_PanelDivision + 1
    return chatUIPool._list_PanelDivision[chatUIPool._count_PanelDivision - 1]
  end
  function chatUIPool:newPanelCombine()
    chatUIPool._count_PanelDelete = chatUIPool._count_PanelDelete + 1
    return chatUIPool._list_PanelDelete[chatUIPool._count_PanelDelete - 1]
  end
  function chatUIPool:newResizeButton()
    chatUIPool._count_ResizeButton = chatUIPool._count_ResizeButton + 1
    return chatUIPool._list_ResizeButton[chatUIPool._count_ResizeButton - 1]
  end
  function chatUIPool:newChattingIcon()
    chatUIPool._count_ChattingIcon = chatUIPool._count_ChattingIcon + 1
    return chatUIPool._list_ChattingIcon[chatUIPool._count_ChattingIcon - 1]
  end
  function chatUIPool:newRecommandIcon()
    chatUIPool._count_RecommandIcon = chatUIPool._count_RecommandIcon + 1
    return chatUIPool._list_RecommandIcon[chatUIPool._count_RecommandIcon - 1]
  end
  function chatUIPool:getCurrentChattingIconIndex()
    return chatUIPool._count_ChattingIcon - 1
  end
  function chatUIPool:getCurrentRecommandIconIndex()
    return chatUIPool._count_RecommandIcon - 1
  end
  function chatUIPool:getCurrentRecommandTierIconIndex()
    return chatUIPool._count_RecommandTierIcon - 1
  end
  function chatUIPool:getCurrentEmoticonIndex()
    return chatUIPool._count_ChatEmoticon - 1
  end
  function PaGlobal_getChattingIconByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "PaGlobal_getChattingIconByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool:getChattingIconByIndex(index)
  end
  function chatUIPool:getChattingIconByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "chatUIPool:getChattingIconByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool._list_ChattingIcon[index]
  end
  function chatUIPool:getRecommandIconByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "chatUIPool:getRecommandIconByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool._list_RecommandIcon[index]
  end
  function chatUIPool:newChattingSender(messageIndex)
    UI.ASSERT_NAME(nil ~= messageIndex, "chatUIPool:newChattingSender messageIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool._count_ChattingSender = chatUIPool._count_ChattingSender + 1
    chatUIPool._list_SenderMessageIndex[chatUIPool._count_ChattingSender - 1] = messageIndex
    return chatUIPool._list_ChattingSender[chatUIPool._count_ChattingSender - 1]
  end
  function chatUIPool:newChattingContents()
    chatUIPool._count_ChattingContents = chatUIPool._count_ChattingContents + 1
    return chatUIPool._list_ChattingContents[chatUIPool._count_ChattingContents - 1]
  end
  function PaGlobal_getChattingContentsByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "PaGlobal_getChattingContentsByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool._list_ChattingContents[index]
  end
  function chatUIPool:newChattingLinkedItem(messageIndex)
    UI.ASSERT_NAME(nil ~= messageIndex, "chatUIPool:newChattingLinkedItem messageIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool._count_ChattingLinkedItem = chatUIPool._count_ChattingLinkedItem + 1
    chatUIPool._list_LinkedItemMessageIndex[chatUIPool._count_ChattingLinkedItem - 1] = messageIndex
    return chatUIPool._list_ChattingLinkedItem[chatUIPool._count_ChattingLinkedItem - 1]
  end
  function chatUIPool:newChattingLinkedGuild(messageIndex)
    UI.ASSERT_NAME(nil ~= messageIndex, "chatUIPool:newChattingLinkedGuild messageIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool._count_ChattingLinkedGuild = chatUIPool._count_ChattingLinkedGuild + 1
    chatUIPool._list_LinkedGuildMessageIndex[chatUIPool._count_ChattingLinkedGuild - 1] = messageIndex
    return chatUIPool._list_ChattingLinkedGuild[chatUIPool._count_ChattingLinkedGuild - 1]
  end
  function chatUIPool:newChattingGuildMark()
    chatUIPool._count_ChattingGuildMark = chatUIPool._count_ChattingGuildMark + 1
    return chatUIPool._list_ChattingGuildMark[chatUIPool._count_ChattingGuildMark - 1]
  end
  function chatUIPool:getCurrentChattingGuildMarkIndex()
    return chatUIPool._count_ChattingGuildMark - 1
  end
  function PaGlobal_getChattingGuildMarkByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "PaGlobal_getChattingGuildMarkByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool:getChattingGuildMarkByIndex(index)
  end
  function chatUIPool:getChattingGuildMarkByIndex(index)
    UI.ASSERT_NAME(nil ~= index, "chatUIPool:getChattingGuildMarkByIndex index nil", "\236\178\156\235\167\140\234\184\176")
    return chatUIPool._list_ChattingGuildMark[index]
  end
  function chatUIPool:newChattingEmoticon()
    chatUIPool._count_Emoticon = chatUIPool._count_Emoticon + 1
    if chatUIPool._MAXCOUNT_EMOTICON < chatUIPool._count_Emoticon then
      chatUIPool._count_Emoticon = chatUIPool._MAXCOUNT_EMOTICON
    end
    return chatUIPool._list_Emoticon[chatUIPool._count_Emoticon - 1]
  end
  function chatUIPool:newChattingNewEmoticon()
    chatUIPool._count_ChatEmoticon = chatUIPool._count_ChatEmoticon + 1
    if chatUIPool._MAXCOUNT_CHATEMOTICON < chatUIPool._count_ChatEmoticon then
      chatUIPool._count_ChatEmoticon = chatUIPool._MAXCOUNT_CHATEMOTICON
    end
    return chatUIPool._list_ChatEmoticon[chatUIPool._count_ChatEmoticon - 1]
  end
  function chatUIPool:newChattingLinkedWebSite(messageIndex)
    UI.ASSERT_NAME(nil ~= messageIndex, "chatUIPool:newChattingLinkedWebSite messageIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool._count_ChattingLinkedWebSite = chatUIPool._count_ChattingLinkedWebSite + 1
    chatUIPool._list_LinkedWebSiteMessageIndex[chatUIPool._count_ChattingLinkedWebSite - 1] = messageIndex
    return chatUIPool._list_ChattingLinkedWebSite[chatUIPool._count_ChattingLinkedWebSite - 1]
  end
  function chatUIPool:newChattingAt(messageIndex)
    UI.ASSERT_NAME(nil ~= messageIndex, "chatUIPool:newChattingAt messageIndex nil", "\236\178\156\235\167\140\234\184\176")
    chatUIPool._count_At = chatUIPool._count_At + 1
    chatUIPool._list_LinkedAtMessageIndex[chatUIPool._count_At - 1] = messageIndex
    return chatUIPool._list_At[chatUIPool._count_At - 1]
  end
  function chatUIPool:newScroll()
    chatUIPool._count_Scroll = chatUIPool._count_Scroll + 1
    return chatUIPool._list_Scroll[chatUIPool._count_Scroll - 1]
  end
  function chatUIPool:newCloseButton()
    chatUIPool._count_CloseButton = chatUIPool._count_CloseButton + 1
    return chatUIPool._list_CloseButton[chatUIPool._count_CloseButton - 1]
  end
  function chatUIPool:newScrollReset()
    chatUIPool._count_ScrollReset = chatUIPool._count_ScrollReset + 1
    return chatUIPool._list_ScrollReset[chatUIPool._count_ScrollReset - 1]
  end
  function chatUIPool:newMorelist()
    chatUIPool._count_MoreList = chatUIPool._count_MoreList + 1
    return chatUIPool._list_MoreList[chatUIPool._count_MoreList - 1]
  end
  function chatUIPool:clearChattingIcon()
    chatUIPool._count_ChattingIcon = 0
  end
  function chatUIPool:clearRecommandIcon()
    chatUIPool._count_RecommandIcon = 0
  end
  function chatUIPool:clearRecommandTierIcon()
    chatUIPool._count_RecommandTierIcon = 0
  end
  function chatUIPool:clearChattingSender()
    chatUIPool._count_ChattingSender = 0
  end
  function chatUIPool:clearChattingContents()
    chatUIPool._count_ChattingContents = 0
  end
  function chatUIPool:clearChattingLinkedItem()
    chatUIPool._count_ChattingLinkedItem = 0
  end
  function chatUIPool:clearChattingLinkedGuild()
    chatUIPool._count_ChattingLinkedGuild = 0
  end
  function chatUIPool:clearChattingGuildMark()
    chatUIPool._count_ChattingGuildMark = 0
  end
  function chatUIPool:clearChattingLinkedwebsite()
    chatUIPool._count_ChattingLinkedWebSite = 0
  end
  function chatUIPool:clearEmoticon()
    chatUIPool._count_Emoticon = 0
  end
  function chatUIPool:clearAt()
    chatUIPool._count_At = 0
  end
  function chatUIPool:clear()
    chatUIPool._count_PanelBG = 0
    chatUIPool._count_TitleTab = 0
    chatUIPool._count_TitleTabText = 0
    chatUIPool._count_TitleTabConfigButton = 0
    chatUIPool._count_OtherTab = 0
    chatUIPool._count_AddTab = 0
    chatUIPool._count_PanelDivision = 0
    chatUIPool._count_PanelDelete = 0
    chatUIPool._count_ResizeButton = 0
    chatUIPool._count_ChattingIcon = 0
    chatUIPool._count_RecommandIcon = 0
    chatUIPool._count_RecommandTierIcon = 0
    chatUIPool._count_ChattingSender = 0
    chatUIPool._count_ChattingContents = 0
    chatUIPool._count_ChattingLinkedItem = 0
    chatUIPool._count_ChattingLinkedGuild = 0
    chatUIPool._count_ChattingGuildMark = 0
    chatUIPool._count_ChattingLinkedWebSite = 0
    chatUIPool._count_Scroll = 0
    chatUIPool._count_CloseButton = 0
    chatUIPool._count_ScrollReset = 0
    chatUIPool._count_MoreList = 0
    chatUIPool._count_Emoticon = 0
    chatUIPool._count_At = 0
    chatUIPool._count_ChatEmoticon = 0
    chatUIPool._count_ChatEmoticonAni = 0
    chatUIPool._list_SenderMessageIndex = {}
    chatUIPool._list_LinkedItemMessageIndex = {}
    chatUIPool._list_LinkedGuildMessageIndex = {}
    chatUIPool._list_LinkedWebSiteMessageIndex = {}
    chatUIPool._list_LinkedAtMessageIndex = {}
    chatUIPool._list_LinkedAtIndex = {}
    chatUIPool:hideNotUse()
  end
  function chatUIPool:drawclear()
    chatUIPool.clearChattingIcon()
    chatUIPool.clearRecommandIcon()
    chatUIPool.clearRecommandTierIcon()
    chatUIPool.clearChattingContents()
    chatUIPool.clearChattingSender()
    chatUIPool.clearChattingLinkedItem()
    chatUIPool.clearChattingLinkedGuild()
    chatUIPool.clearChattingGuildMark()
    chatUIPool.clearChattingLinkedwebsite()
    chatUIPool.clearEmoticon()
    chatUIPool.clearAt()
  end
  function chatUIPool:hideNotUse()
    for index = chatUIPool._count_PanelBG, chatUIPool._MAXCOUNT_PANELBG do
      chatUIPool._list_PanelBG[index]:SetShow(false)
    end
    for index = chatUIPool._count_TitleTab, chatUIPool._MAXCOUNT_TITLETAB do
      chatUIPool._list_TitleTab[index]:SetShow(false)
    end
    for index = chatUIPool._count_TitleTabText, chatUIPool._MAXCOUNT_TITLETABTEXT do
      chatUIPool._list_TitleTabText[index]:SetShow(false)
    end
    for index = chatUIPool._count_TitleTabConfigButton, chatUIPool._MAXCOUNT_TITLETABCONFIGBUTTON do
      chatUIPool._list_TitleTabConfigButton[index]:SetShow(false)
    end
    for index = chatUIPool._count_OtherTab, chatUIPool._MAXCOUNT_OTHERTAB do
      chatUIPool._list_OtherTab[index]:SetShow(false)
    end
    for index = chatUIPool._count_AddTab, chatUIPool._MAXCOUNT_ADDTAB do
      chatUIPool._list_AddTab[index]:SetShow(false)
    end
    for index = chatUIPool._count_PanelDivision, chatUIPool._MAXCOUNT_PANELDIVISION do
      chatUIPool._list_PanelDivision[index]:SetShow(false)
    end
    for index = chatUIPool._count_PanelDelete, chatUIPool._MAXCOUNT_PANELDELETE do
      chatUIPool._list_PanelDelete[index]:SetShow(false)
    end
    for index = chatUIPool._count_ResizeButton + 1, chatUIPool._MAXCOUNT_RESIZEBUTTON do
      chatUIPool._list_ResizeButton[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingIcon, chatUIPool._MAXCOUNT_CHATTINGICON do
      chatUIPool._list_ChattingIcon[index]:SetShow(false)
    end
    for index = chatUIPool._count_RecommandIcon, chatUIPool._MAXCOUNT_RECOMMANDICON do
      chatUIPool._list_RecommandIcon[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingSender, chatUIPool._MAXCOUNT_CHATTINGSENDER do
      chatUIPool._list_ChattingSender[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingContents, chatUIPool._MAXCOUNT_CHATTINGCONTENTS do
      chatUIPool._list_ChattingContents[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingLinkedItem, chatUIPool._MAXCOUNT_CHATTINGLINKEDITEM do
      chatUIPool._list_ChattingLinkedItem[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingLinkedGuild, chatUIPool._MAXCOUNT_CHATTINGLINKEDGUILD do
      chatUIPool._list_ChattingLinkedGuild[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingGuildMark, chatUIPool._MAXCOUNT_CHATTINGGUILDMARK do
      chatUIPool._list_ChattingGuildMark[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChattingLinkedWebSite, chatUIPool._MAXCOUNT_CHATTINGLINKEDWEBSITE do
      chatUIPool._list_ChattingLinkedWebSite[index]:SetShow(false)
    end
    for index = chatUIPool._count_Scroll, chatUIPool._MAXCOUNT_SCROLL do
      chatUIPool._list_Scroll[index]:SetShow(false)
    end
    for index = chatUIPool._count_CloseButton, chatUIPool._MAXCOUNT_CLOSEBUTTON do
      chatUIPool._list_CloseButton[index]:SetShow(false)
    end
    for index = chatUIPool._count_ScrollReset, chatUIPool._MAXCOUNT_SCROLLRESET do
      chatUIPool._list_ScrollReset[index]:SetShow(false)
    end
    for index = chatUIPool._count_MoreList, chatUIPool._MAXCOUNT_MORELIST do
      chatUIPool._list_MoreList[index]:SetShow(false)
    end
    for index = chatUIPool._count_Emoticon, chatUIPool._MAXCOUNT_EMOTICON do
      chatUIPool._list_Emoticon[index]:SetShow(false)
    end
    for index = chatUIPool._count_At, chatUIPool._MAXCOUNT_AT do
      chatUIPool._list_At[index]:SetShow(false)
    end
    for index = chatUIPool._count_ChatEmoticon, chatUIPool._MAXCOUNT_CHATEMOTICON do
      chatUIPool._list_ChatEmoticon[index]:SetShow(false)
    end
  end
  chatUIPool:initialize(poolStylePanel, poolParentPanel, poolIndex)
  return chatUIPool
end
function Chatting_ScrollEvent(poolIndex, updown)
  UI.ASSERT_NAME(nil ~= poolIndex, "Chatting_ScrollEvent poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= updown, "Chatting_ScrollEvent updown nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_ChatMain._issmoothWheelscroll and updown == PaGlobal_ChatMain._isUpDown then
    PaGlobal_ChatMain:addScrollCount()
    return
  end
  local chatPanel = ToClient_getChattingPanel(poolIndex)
  local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
  if isCombinedMainPanel then
    local count = ToClient_getChattingPanelCount()
    for panelIndex = 0, count - 1 do
      local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      if isActivePanel then
        PaGlobal_ChatMain._issmoothWheelscroll = true
        PaGlobal_ChatMain._isUpDown = updown
        PaGlobal_ChatMain._scrollIndex = panelIndex
        break
      end
    end
  else
    PaGlobal_ChatMain._issmoothWheelscroll = true
    PaGlobal_ChatMain._isUpDown = updown
    PaGlobal_ChatMain._scrollIndex = poolIndex
  end
  PaGlobal_ChatMain:initScrollCount()
end
function HandleEventLUp_ChattingSender(poolIndex, senderStaticIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleEventLUp_ChattingSender poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= senderStaticIndex, "HandleEventLUp_ChattingSender senderStaticIndex nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate()
  local paramIndex = poolIndex
  if 0 == poolIndex then
    paramIndex = PaGlobal_ChatMain._mainPanelSelectPanelIndex
  end
  local posX = getMousePosX()
  local posY = getMousePosY()
  local chatPanel = ToClient_getChattingPanel(paramIndex)
  local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
  local messageIndex = poolCurrentUI._list_SenderMessageIndex[senderStaticIndex]
  local chattingMessage = chatPanel:getChattingMessageByIndex(messageIndex)
  local isBlockedUser = ToClient_isChatMsgFromBlockedUser(chattingMessage)
  if false == isBlockedUser then
    if nil ~= chattingMessage then
      local clickedName = chattingMessage:getSender(0)
      local clickedUserNickName = chattingMessage:getSender(1)
      local clickedMsg = chattingMessage:getContent()
      chatType = chattingMessage.chatType
      isSameChannel = chattingMessage.isSameChannel
      local currentPoolIndex = paramIndex
      local clickedMessageIndex = messageIndex
      if nil ~= clickedName and nil ~= clickedUserNickName then
        setClipBoardText(clickedName)
        if Panel_Chat_SubMenu:IsShow() then
          PaGlobal_ChatSubMenu:SetShow(false)
        end
        PaGlobal_ChatSubMenuSetClickedInfo(currentPoolIndex, clickedMessageIndex, clickedName, clickedUserNickName, clickedMsg)
        local isInviteParty = PaGlobal_ChatMain:isInviteParty(chatType, isSameChannel)
        local isInviteGuild = PaGlobal_ChatMain:isInviteGuild(chatType, isSameChannel)
        local isInviteCompetition = PaGlobal_ChatMain:isInviteCompetition(isSameChannel)
        PaGlobal_ChatSubMenu:SetShow(true, isInviteParty, isInviteGuild, isInviteCompetition, chattingMessage.isGameManager, clickedName, clickedUserNickName)
        PaGlobal_ChatSubMenu:SetPos(posX, posY)
      end
    else
      PaGlobal_ChatSubMenuSetClickedInfoInit()
    end
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DONOTHAVE_PRIVILEGE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobal_ChatMain:isInviteParty(chatType, isSameChannel)
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:isInviteParty chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSameChannel, "PaGlobal_ChatMain:isInviteParty isSameChannel nil", "\236\178\156\235\167\140\234\184\176")
  local selfPlayer = getSelfPlayer()
  local selfActorKeyRaw = selfPlayer:getActorKey()
  local isInvite = selfPlayer:isPartyLeader(selfActorKeyRaw) or false == selfPlayer:isPartyMemberActorKey(selfActorKeyRaw)
  return isSameChannel and UI_CT.Party ~= chatType and isInvite
end
function PaGlobal_ChatMain:isInviteGuild(chatType, isSameChannel)
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:isInviteGuild chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSameChannel, "PaGlobal_ChatMain:isInviteGuild isSameChannel nil", "\236\178\156\235\167\140\234\184\176")
  local selfPlayer = getSelfPlayer()
  local selfActorKeyRaw = selfPlayer:getActorKey()
  return isSameChannel and UI_CT.Guild ~= chatType and selfPlayer:isSpecialGuildMember(selfActorKeyRaw)
end
function PaGlobal_ChatMain:isInviteCompetition(isSameChannel)
  UI.ASSERT_NAME(nil ~= isSameChannel, "PaGlobal_ChatMain:isInviteCompetition isSameChannel nil", "\236\178\156\235\167\140\234\184\176")
  local selfPlayer = getSelfPlayer()
  local selfActorKeyRaw = selfPlayer:getActorKey()
  return isSameChannel and ToClient_IsCompetitionHost()
end
function HandleOn_ChattingLinkedWebSite(poolIndex, LinkedWebsiteIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleOn_ChattingLinkedWebSite poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= LinkedWebsiteIndex, "HandleOn_ChattingLinkedWebSite LinkedWebsiteIndex nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate()
  PaGlobal_ChatMain._linkedItemTooltipIsClicked = isClicked
  local paramIndex = poolIndex
  if 0 == poolIndex then
    paramIndex = PaGlobal_ChatMain._mainPanelSelectPanelIndex
  end
  local chatPanel = ToClient_getChattingPanel(paramIndex)
  local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
  local messageIndex = poolCurrentUI._list_LinkedWebSiteMessageIndex[LinkedWebsiteIndex]
  local chattingMessage = chatPanel:getChattingMessageByIndex(messageIndex)
  if chattingMessage:isLinkedWebsite() then
    ToClient_OpenChargeWebPage(chattingMessage:getLinkedWebsite(), false)
  end
end
function HandleOn_ChattingLinkedGuild(poolIndex, LinkedGuildIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleOn_ChattingLinkedGuild poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= LinkedGuildIndex, "HandleOn_ChattingLinkedGuild LinkedGuildIndex nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate()
  PaGlobal_ChatMain._linkedItemTooltipIsClicked = isClicked
  local paramIndex = poolIndex
  if 0 == poolIndex then
    paramIndex = PaGlobal_ChatMain._mainPanelSelectPanelIndex
  end
  local chatPanel = ToClient_getChattingPanel(paramIndex)
  local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
  local messageIndex = poolCurrentUI._list_LinkedGuildMessageIndex[LinkedGuildIndex]
  local chattingMessage = chatPanel:getChattingMessageByIndex(messageIndex)
  if chattingMessage:isLinkedGuild() then
    local linkedGuildInfo = chattingMessage:getLinkedGuildInfo()
    local guildNo = linkedGuildInfo:getGuildNo()
    FGlobal_GuildWebInfoForGuildRank_Open(tostring(guildNo))
  end
end
function HandleOn_ChattingLinkedItem(poolIndex, LinkedItemStaticIndex, isClicked)
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleOn_ChattingLinkedItem poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= LinkedItemStaticIndex, "HandleOn_ChattingLinkedItem LinkedItemStaticIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isClicked, "HandleOn_ChattingLinkedItem isClicked nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate()
  PaGlobal_ChatMain._linkedItemTooltipIsClicked = isClicked
  local paramIndex = poolIndex
  if 0 == poolIndex then
    paramIndex = PaGlobal_ChatMain._mainPanelSelectPanelIndex
  end
  local chatPanel = ToClient_getChattingPanel(paramIndex)
  local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
  local panelCurrentUI = PaGlobal_ChatMain:getPanel(poolIndex)
  local messageIndex = poolCurrentUI._list_LinkedItemMessageIndex[LinkedItemStaticIndex]
  if nil == messageIndex then
    return
  end
  local chattingMessage = chatPanel:getChattingMessageByIndex(messageIndex)
  if nil == chattingMessage then
    return
  end
  if chattingMessage:isLinkedItem() then
    local chattingLinkedItem = chattingMessage:getLinkedItemInfo()
    local itemSSW = chattingLinkedItem:getLinkedItemStaticStatus()
    if nil ~= itemSSW then
      Panel_Tooltip_Item_Show_ForChattingLinkedItem(itemSSW, panelCurrentUI, true, false, chattingLinkedItem, isClicked)
    end
  end
end
function PaGlobal_ChatMain:getPool(poolIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "PaGlobal_ChatMain:getPool poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain._listChatUIPool[poolIndex]
end
function PaGlobal_ChatMain:getPanel(poolIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "PaGlobal_ChatMain:getPanel poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain._listPanel[poolIndex]
end
function PaGlobal_ChatMain:getPopupNameMenu(poolIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "PaGlobal_ChatMain:getPopupNameMenu poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain._listPopupNameMenu[poolIndex]
end
function PaGlobal_ChatMain:getMainTab(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getMainTab poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getMainTab panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getMainTab drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getMainTab isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getMainTab isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getMainTab isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local mainTab = poolCurrentUI:newTitleTab()
  mainTab:SetTextHorizonLeft(true)
  mainTab:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHATTING_MAINTAB_TITLE", "panel_Index", panelIndex + 1))
  mainTab:SetNotAbleMasking(true)
  mainTab:SetShow(isShow)
  if isEnableSimpleUI then
    if isSimpleUI then
      mainTab:SetFontAlpha(1)
      mainTab:SetAlpha(1)
    else
      mainTab:SetFontAlpha(0.8)
      mainTab:SetAlpha(0.7)
    end
  end
  return mainTab
end
function PaGlobal_ChatMain:getSettingButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getSettingButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getSettingButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getSettingButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getSettingButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getSettingButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getSettingButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local settingButton = poolCurrentUI:newTitleTabConfigButton()
  settingButton:SetShow(isShow)
  settingButton:SetNotAbleMasking(true)
  if isEnableSimpleUI then
    if isSimpleUI then
      settingButton:SetAlpha(1)
    else
      settingButton:SetAlpha(0.7)
    end
  end
  return settingButton
end
function PaGlobal_ChatMain:getDivisionButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getDivisionButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getDivisionButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getDivisionButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getDivisionButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getDivisionButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getDivisionButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local divisionButton = poolCurrentUI:newPanelDivision()
  divisionButton:SetShow(isShow)
  divisionButton:SetNotAbleMasking(true)
  if isEnableSimpleUI then
    if isSimpleUI then
      divisionButton:SetAlpha(1)
    else
      divisionButton:SetAlpha(0.7)
    end
  end
  return divisionButton
end
function PaGlobal_ChatMain:getDeleteButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getDeleteButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getDeleteButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getDeleteButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getDeleteButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getDeleteButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getDeleteButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local deleteButton = poolCurrentUI:newCloseButton()
  deleteButton:SetShow(isShow)
  deleteButton:SetNotAbleMasking(true)
  deleteButton:SetIgnore(false)
  if isEnableSimpleUI then
    if isSimpleUI then
      deleteButton:SetAlpha(1)
    else
      deleteButton:SetAlpha(0.7)
    end
  end
  return deleteButton
end
function PaGlobal_ChatMain:getCombineButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getCombineButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getCombineButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getCombineButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getCombineButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getCombineButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getCombineButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local combineButton = poolCurrentUI:newPanelCombine()
  combineButton:SetShow(isShow)
  combineButton:SetNotAbleMasking(true)
  if isEnableSimpleUI then
    if isSimpleUI then
      combineButton:SetAlpha(1)
    else
      combineButton:SetAlpha(0.7)
    end
  end
  return combineButton
end
function PaGlobal_ChatMain:getScrollResetButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getScrollResetButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getScrollResetButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getScrollResetButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getScrollResetButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getScrollResetButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getScrollResetButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local scrollResetBtn = poolCurrentUI:newScrollReset()
  scrollResetBtn:SetShow(isShow)
  return scrollResetBtn
end
function PaGlobal_ChatMain:getMoreList(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getMoreList poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getMoreList panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getMoreList drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getMoreList isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getMoreList isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getMoreList isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local moreList = poolCurrentUI:newMorelist()
  moreList:SetShow(isShow)
  return moreList
end
function PaGlobal_ChatMain:getSubTab(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getSubTab poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getSubTab panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getSubTab drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getSubTab isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getSubTab isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getSubTab isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local subTab = poolCurrentUI:newOtherTab()
  subTab:SetTextHorizonCenter(true)
  subTab:SetText(panelIndex + 1)
  subTab:SetNotAbleMasking(true)
  subTab:SetShow(isShow)
  if isEnableSimpleUI then
    if isSimpleUI then
      subTab:SetFontAlpha(1)
      subTab:SetAlpha(1)
    else
      subTab:SetFontAlpha(0.8)
      subTab:SetAlpha(0.7)
    end
  end
  return subTab
end
function PaGlobal_ChatMain:getPanelResizeButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getPanelResizeButton poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getPanelResizeButton panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getPanelResizeButton drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getPanelResizeButton isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getPanelResizeButton isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getPanelResizeButton isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local panel_resizeButton = poolCurrentUI:newResizeButton()
  panel_resizeButton:SetNotAbleMasking(true)
  panel_resizeButton:SetShow(isShow)
  return panel_resizeButton
end
function PaGlobal_ChatMain:getPanelBg(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getPanelBg poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getPanelBg panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getPanelBg drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getPanelBg isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getPanelBg isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getPanelBg isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local panel_Bg = poolCurrentUI:newPanelBG()
  panel_Bg:SetNotAbleMasking(true)
  panel_Bg:SetShow(true)
  panel_Bg:SetIgnore(true)
  return panel_Bg
end
function PaGlobal_ChatMain:getPanelScroll(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getPanelScroll poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getPanelScroll panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:getPanelScroll drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:getPanelScroll isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isEnableSimpleUI, "PaGlobal_ChatMain:getPanelScroll isEnableSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isSimpleUI, "PaGlobal_ChatMain:getPanelScroll isSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  local panel_Scroll = poolCurrentUI:newScroll()
  panel_Scroll:SetShow(isShow)
  if isEnableSimpleUI then
    panel_Scroll:SetShow(isSimpleUI)
  end
  return panel_Scroll
end
PaGlobal_ChatMain:initialize_Pool()
