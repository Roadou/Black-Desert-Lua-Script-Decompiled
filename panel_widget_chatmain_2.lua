local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
function HandleOn_ChattingAddTabToolTip(isShow, poolIndex, tipType)
  UI.ASSERT_NAME(nil ~= isShow, "HandleOn_ChattingAddTabToolTip isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleOn_ChattingAddTabToolTip poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= tipType, "HandleOn_ChattingAddTabToolTip tipType nil", "\236\178\156\235\167\140\234\184\176")
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == poolIndex then
    return
  end
  local name, desc, control
  local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
  local addTabControl = poolCurrentUI._list_AddTab[0]
  local divisionControl = poolCurrentUI._list_PanelDivision[poolIndex]
  local settingControl = poolCurrentUI._list_TitleTabConfigButton[poolIndex]
  local sizeControl = poolCurrentUI._list_ResizeButton[poolIndex]
  local combineControl = poolCurrentUI._list_PanelDelete[poolIndex]
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_ADDTAB_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_ADDTAB_DESC")
    control = addTabControl
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_DIVISION_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_DIVISION_DESC")
    control = divisionControl
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_CONFIG_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_CONFIG_DESC")
    control = settingControl
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_RESIZE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_RESIZE_DESC")
    control = sizeControl
  elseif 4 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_MERGE_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHATNEW_TOOLTIP_MERGE_DESC")
    control = combineControl
  end
  if nil ~= control then
    TooltipSimple_Show(control, name, desc)
  end
end
function HandleClicked_Chatting_ResizeStartPos(drawPanelIndex)
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "HandleClicked_Chatting_ResizeStartPos drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
  PaGlobal_ChatMain._orgMouseX = getMousePosX()
  PaGlobal_ChatMain._orgMouseY = getMousePosY()
  PaGlobal_ChatMain._orgPanelPosY = panel:GetPosY()
  PaGlobal_ChatMain._orgPanelSizeX = panel:GetSizeX()
  PaGlobal_ChatMain._orgPanelSizeY = panel:GetSizeY()
  FromClient_ChatUpdate(true, drawPanelIndex)
end
function HandleClicked_Chatting_Resize(drawPanelIndex, panelIdx)
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "HandleClicked_Chatting_Resize drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIdx, "HandleClicked_Chatting_Resize panelIdx nil", "\236\178\156\235\167\140\234\184\176")
  local panel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
  local chatUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
  local currentX = getMousePosX()
  local currentY = getMousePosY()
  local deltaX = currentX - PaGlobal_ChatMain._orgMouseX
  local deltaY = PaGlobal_ChatMain._orgMouseY - currentY
  local sizeX = PaGlobal_ChatMain._orgPanelSizeX + deltaX
  local sizeY = PaGlobal_ChatMain._orgPanelSizeY + deltaY
  if sizeX >= PaGlobal_ChatMain._CHATTING_WINDOW_MAXWIDTH then
    sizeX = PaGlobal_ChatMain._CHATTING_WINDOW_MAXWIDTH
  elseif sizeX <= 400 then
    sizeX = 400
  end
  if sizeY <= 200 then
    sizeY = 200
  end
  local deltaPosY = PaGlobal_ChatMain._orgPanelSizeY - sizeY
  panel:SetSize(sizeX, sizeY)
  chatUI._list_PanelBG[0]:SetSize(sizeX, sizeY)
  chatUI._list_Scroll[0]:SetSize(chatUI._list_Scroll[0]:GetSizeX(), sizeY - 67)
  for chattingContents_idx = 0, chatUI._MAXCOUNT_CHATTINGCONTENTS - 1 do
    chatUI._list_ChattingContents[chattingContents_idx]:SetSize(sizeX - 25, chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY())
  end
  panel:SetPosY(PaGlobal_ChatMain._orgPanelPosY + deltaPosY)
  chatUI._list_ResizeButton[0]:SetPosX(sizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5))
  chatUI._list_Scroll[0]:SetPosX(sizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5))
  chatUI._list_Scroll[0]:SetControlBottom()
  PAGlobal_setPanelChattingPoolRelativeSize(drawPanelIndex)
  if nil ~= PaGlobal_ImportantNotice_Reposition then
    PaGlobal_ImportantNotice_Reposition(panel, chatUI._list_PanelBG[0], drawPanelIndex, true)
  end
  FromClient_ChatUpdate(true, drawPanelIndex)
  ToClient_SaveUiInfo(false)
end
function Chatting_PanelTransparency(panelIndex, transparency, isHideTooltip)
  UI.ASSERT_NAME(nil ~= panelIndex, "Chatting_PanelTransparency panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= transparency, "Chatting_PanelTransparency transparency nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isHideTooltip, "Chatting_PanelTransparency isHideTooltip nil", "\236\178\156\235\167\140\234\184\176")
  local count = ToClient_getChattingPanelCount()
  if panelIndex > count then
    return
  end
  local currentPanel = PaGlobal_ChatMain:getPanel(panelIndex)
  local IsMouseOver = UI.checkIsInMouseAndEventPanel(currentPanel)
  if true == isHideTooltip and Panel_Tooltip_Item_chattingLinkedItem:GetShow() then
    Panel_Tooltip_Item_hideTooltip()
    TooltipSimple_Hide()
  end
  if true == transparency and true == IsMouseOver then
    if false == PaGlobal_ChatMain._isMouseOn then
      PaGlobal_ChatMain._cacheSimpleUI = true
      PaGlobal_ChatMain._isMouseOnChattingViewIndex = panelIndex
      PaGlobal_ChatMain._isMouseOn = true
      FromClient_ChatUpdate(IsMouseOver, panelIndex)
    end
    TooltipSimple_Hide()
  elseif false == transparency and false == IsMouseOver then
    PaGlobal_ChatMain._cacheSimpleUI = false
    PaGlobal_ChatMain._isMouseOn = false
    PaGlobal_ChatMain._isMouseOnChattingViewIndex = nil
    TooltipSimple_Hide()
    FromClient_ChatUpdate(IsMouseOver, panelIndex)
  end
end
function HandleClicked_Chatting_ResizeStartPosEND(drawPanelIndex)
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "HandleClicked_Chatting_ResizeStartPosEND drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  ToClient_SaveUiInfo(false)
  Chatting_PanelTransparency(drawPanelIndex, false, false)
end
function HandleClicked_ScrollBtnPosY(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_ScrollBtnPosY panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_ChatMain._issmoothscroll then
    return
  end
  local selectindex = 0
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
  if isCombinedMainPanel then
    local count = ToClient_getChattingPanelCount()
    for checkpanelIndex = 0, count - 1 do
      local isActivePanel = checkpanelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      if isActivePanel then
        PaGlobal_ChatMain._issmoothscroll = true
        selectindex = 0
      end
    end
  else
    PaGlobal_ChatMain._issmoothscroll = true
    selectindex = panelIndex
  end
  local poolCurrentUI = PaGlobal_ChatMain:getPool(selectindex)
  if PaGlobal_ChatMain._preScrollControlPos[panelIndex] == poolCurrentUI._list_Scroll[0]:GetControlPos() then
    FromClient_ChatUpdate(true)
    return
  end
  local index = math.floor((1 - poolCurrentUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1))
  if 0 == index then
    PaGlobal_ChatMain._deltascrollPosy[panelIndex] = (1 - poolCurrentUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) % 1
  else
    PaGlobal_ChatMain._deltascrollPosy[panelIndex] = ((1 - poolCurrentUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) - index) % 1
  end
  PaGlobal_ChatMain._preScrollControlPos[panelIndex] = poolCurrentUI._list_Scroll[0]:GetControlPos()
  PaGlobal_ChatMain._srollPosition[panelIndex] = index
  PaGlobal_ChatMain._scroll_BTNPos[panelIndex] = poolCurrentUI._list_Scroll[0]:GetControlPos()
  FromClient_ChatUpdate(true)
end
function Chatting_Transparency(index)
  UI.ASSERT_NAME(nil ~= index, "Chatting_Transparency index nil", "\236\178\156\235\167\140\234\184\176")
  if index < 0 then
    return
  end
  Chatting_PanelTransparency(index, false, false)
end
function HandleClicked_Chatting_Division(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_Division panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  local divisionPanel = ToClient_getChattingPanel(panelIndex)
  local panel = PaGlobal_ChatMain:getPanel(panelIndex)
  local chatUI = PaGlobal_ChatMain:getPool(panelIndex)
  divisionPanel:setPosition(getScreenSizeX() / 2 - panel:GetSizeX() / 2, getScreenSizeY() / 2 - panel:GetSizeY() / 2, panel:GetSizeX(), panel:GetSizeY())
  panel:SetSize(400, 200)
  panel:SetPosX(getScreenSizeX() / 2 - panel:GetSizeX() / 2)
  panel:SetPosY(getScreenSizeY() / 2 - panel:GetSizeY() / 2)
  panel:SetShow(true)
  panel:SetIgnore(false)
  panel:SetRelativePosX(0.5)
  panel:SetRelativePosY(0.5)
  local sizeX = panel:GetSizeX()
  local sizeY = panel:GetSizeY()
  chatUI._list_PanelBG[0]:SetSize(sizeX, sizeY)
  chatUI._list_Scroll[0]:SetSize(chatUI._list_Scroll[0]:GetSizeX(), sizeY - 67)
  chatUI._list_ResizeButton[0]:SetPosX(sizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5))
  chatUI._list_Scroll[0]:SetControlBottom()
  PaGlobal_ChatMain._mainPanelSelectPanelIndex = 0
  PaGlobal_ChatMain._transparency[panelIndex] = 0.5
  TooltipSimple_Hide()
  FromClient_ChatUpdate(true)
  ToClient_SaveUiInfo(false)
end
function HandleClicked_Chatting_Close(panelIndex, drawPanelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_Close panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  ToClient_closeChattingPanel(panelIndex)
  PaGlobal_ChatMain._mainPanelSelectPanelIndex = 0
  if 0 ~= drawPanelIndex then
    PaGlobal_ChatMain._isMouseOn = false
  end
  FromClient_ChatUpdate()
  Chatting_PanelTransparency(panelIndex, false, true)
  TooltipSimple_Hide()
  ToClient_SaveUiInfo(false)
end
function HandleClicked_Chatting_ScrollReset(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_ScrollReset panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._isResetsmoothscroll = true
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
  if isCombinedMainPanel then
    local count = ToClient_getChattingPanelCount()
    for checkpanelIndex = 0, count - 1 do
      local isActivePanel = checkpanelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      if isActivePanel then
        PaGlobal_ChatMain._issmoothscroll = true
        PaGlobal_ChatMain._scrollIndex = panelIndex
        panelIndex = 0
      end
    end
  else
    PaGlobal_ChatMain._issmoothscroll = true
    PaGlobal_ChatMain._scrollIndex = panelIndex
  end
  local poolCurrentUI = PaGlobal_ChatMain:getPool(panelIndex)
  PaGlobal_ChatMain._scrollresetSpeed = PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex]
end
function HandleClicked_Chatting_ChangeTab(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_ChangeTab panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._mainPanelSelectPanelIndex = panelIndex
  TooltipSimple_Hide()
  FromClient_ChatUpdate(true)
end
function HandleClicked_Chatting_AddTab()
  PaGlobal_ChatMain._addChattingPreset = false
  PaGlobal_ChatMain._addChattingIdx = ToClient_openChattingPanel()
  local mainPaenl = ToClient_getChattingPanel(0)
  local mainPanelTransparency = mainPaenl:getTransparency()
  FGlobal_Chatting_PanelTransparency(PaGlobal_ChatMain._addChattingIdx, mainPanelTransparency, false)
  TooltipSimple_Hide()
  FromClient_ChatUpdate(true)
  ToClient_SaveUiInfo(false)
end
function HandleClicked_Chatting_CombineTab(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_CombineTab panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  local panel = ToClient_getChattingPanel(panelIndex)
  local mainPaenl = ToClient_getChattingPanel(0)
  local mainPanelTransparency = mainPaenl:getTransparency()
  panel:combineToMainPanel()
  panel:setTransparency(mainPanelTransparency)
  FGlobal_Chatting_PanelTransparency(panelIndex, mainPanelTransparency, false)
  TooltipSimple_Hide()
  FromClient_ChatUpdate(true)
  ToClient_SaveUiInfo(false)
end
function Chatting_OnResize()
  PaGlobal_ChatMain._CHATTING_WINDOW_MAXWIDTH = getScreenSizeX() * 0.67
  local divisionPanel, panel, chatUI
  for poolIndex = 0, PaGlobal_ChatMain._POOLCOUNT - 1 do
    divisionPanel = ToClient_getChattingPanel(poolIndex)
    panel = PaGlobal_ChatMain:getPanel(poolIndex)
    chatUI = PaGlobal_ChatMain:getPool(poolIndex)
    if poolIndex ~= 0 and (false == divisionPanel:isOpen() or divisionPanel:isCombinedToMainPanel()) then
      panel:SetShow(false)
    end
    local panelSizeX = divisionPanel:getPanelSizeX()
    local panelSizeY = divisionPanel:getPanelSizeY()
    local panelPosX = divisionPanel:getPositionX()
    local panelPosY = divisionPanel:getPositionY()
    if panel:GetRelativePosX() == -1 and panel:GetRelativePosY() == -1 then
      local initPosX = 0
      local initPosY
      if false == _ContentsGroup_RenewUI then
        initPosY = getScreenSizeY() - panelSizeY - Panel_GameTips:GetSizeY()
      else
        initPosY = getScreenSizeY() - panelSizeY
      end
      panelPosX = initPosX
      panelPosY = initPosY
      panel:SetPosX(panelPosX)
      panel:SetPosY(panelPosY)
      FGlobal_InitPanelRelativePos(panel, initPosX, initPosY)
    end
    if panel:GetRelativePosX() == 0 and panel:GetRelativePosY() == 0 then
      panelPosX = 0
      if false == _ContentsGroup_RenewUI then
        panelPosY = getScreenSizeY() - panelSizeY - Panel_GameTips:GetSizeY()
      else
        panelPosY = getScreenSizeY() - panelSizeY
      end
    elseif 0 < panel:GetRelativePosX() or 0 < panel:GetRelativePosY() then
      panelPosX = panel:GetRelativePosX() * getScreenSizeX() - panel:GetSizeX() / 2
      panelPosY = panel:GetRelativePosY() * getScreenSizeY() - panel:GetSizeY() / 2
    end
    if panelSizeX > 25 and panelSizeY > 50 then
      panel:SetSize(panelSizeX, panelSizeY)
      chatUI._list_PanelBG[0]:SetSize(panelSizeX, panelSizeY)
      chatUI._list_Scroll[0]:SetSize(chatUI._list_Scroll[0]:GetSizeX(), panelSizeY - 67)
      for chattingContents_idx = 0, chatUI._MAXCOUNT_CHATTINGCONTENTS - 1 do
        chatUI._list_ChattingContents[chattingContents_idx]:SetSize(panelSizeX - 25, chatUI._list_ChattingContents[chattingContents_idx]:GetSizeY())
      end
      chatUI._list_ResizeButton[0]:SetPosX(panelSizeX - (chatUI._list_ResizeButton[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetPosX(panelSizeX - (chatUI._list_Scroll[0]:GetSizeX() + 5))
      chatUI._list_Scroll[0]:SetPosY(50)
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
      chatUI._list_Scroll[0]:SetPosY(50)
      chatUI._list_Scroll[0]:SetControlBottom()
    end
    local defaultPosY
    if false == _ContentsGroup_RenewUI then
      defaultPosY = getScreenSizeY() - panel:GetSizeY() - Panel_GameTips:GetSizeY()
    else
      defaultPosY = getScreenSizeY() - panel:GetSizeY()
    end
    if -1 == panelPosX and -1 == panelPosY then
      panelPosX = 0
      panelPosY = defaultPosY
    else
      if panelPosX < 0 then
        panelPosX = 0
      elseif panelPosX > getScreenSizeX() - panel:GetSizeX() then
        if false == _ContentsGroup_RenewUI then
          panelPosX = getScreenSizeX() - panel:GetSizeX() - Panel_GameTips:GetSizeY()
        else
          panelPosX = getScreenSizeX() - panel:GetSizeX()
        end
      end
      if panelPosY < 0 then
        panelPosY = 0
      elseif panelPosY == 0 then
        panelPosY = defaultPosY
      elseif panelPosY > getScreenSizeY() - panel:GetSizeY() then
        panelPosY = defaultPosY
      end
    end
    if PaGlobal_ChatMain._POOLCOUNT - 1 == poolIndex and panelPosY == defaultPosY then
      panelPosY = panelPosY - PaGlobal_ChatMain._DEFAULT_PANELSIZE_Y
    end
    panel:SetPosX(panelPosX)
    panel:SetPosY(panelPosY)
    local isCombinePanel = divisionPanel:isCombinedToMainPanel()
    divisionPanel:setPosition(panelPosX, panelPosY, panelSizeX, panelSizeY)
    if isCombinePanel then
      divisionPanel:combineToMainPanel()
    end
    if nil ~= PaGlobal_ImportantNotice_Reposition then
      PaGlobal_ImportantNotice_Reposition(panel, chatUI._list_PanelBG[0], poolIndex, false)
    end
  end
  FromClient_ChatUpdate()
end
function FromClient_ChatUpdate(isShow, currentPanelIndex)
  if true == _ContentsGroup_RenewUI then
    PaGlobal_ChatMain:chatting_ShowOff()
    return
  end
  if isChangeFontSize() == true then
    local panelCount = ToClient_getChattingPanelCount()
    for panelIndex = 0, panelCount - 1 do
      local chatPanel = ToClient_getChattingPanel(panelIndex)
      local fontType = chatPanel:getChatFontSizeType()
      local fontSize = ChattingOption_convertChatFontTypeToFontSize(fontType)
      ToClient_getFontWrapper("BaseFont_10_Chat"):changeFontSize(fontSize)
      local panelsPool = PaGlobal_ChatMain:getPool(panelIndex)
      local chatSender
      for senderIdx = 0, panelsPool._MAXCOUNT_CHATTINGSENDER do
        chatSender = panelsPool._list_ChattingSender[senderIdx]
        chatSender:SetText(" ")
        chatSender:SetSize(chatSender:GetSizeX(), fontSize + 4)
      end
    end
  end
  PaGlobal_ChatMain._tabButton_PosX = 0
  local openedChattingPanelCount = 0
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      openedChattingPanelCount = openedChattingPanelCount + 1
      if chatPanel:isUpdated() then
        PaGlobal_ChatMain:getPool(panelIndex):clear()
        local isCombinedPanel = chatPanel:isCombinedToMainPanel()
        if currentPanelIndex == panelIndex then
          PaGlobal_ChatMain:update(chatPanel, panelIndex, isShow)
        elseif 0 == currentPanelIndex and isCombinedPanel then
          PaGlobal_ChatMain:update(chatPanel, panelIndex, isShow)
        else
          PaGlobal_ChatMain:update(chatPanel, panelIndex)
        end
      end
    else
      local panel = PaGlobal_ChatMain:getPanel(panelIndex)
      panel:SetShow(false)
      local poolCurrentUI = PaGlobal_ChatMain:getPool(panelIndex)
      poolCurrentUI:clear()
    end
  end
  setisChangeFontSize(false)
  if openedChattingPanelCount < 5 then
    local poolCurrentUI = PaGlobal_ChatMain:getPool(0)
    local panel_addTab = poolCurrentUI:newAddTab()
    local panel_division = poolCurrentUI:newPanelDivision()
    local mainPanel = PaGlobal_ChatMain:getPanel(0)
    panel_addTab:SetNotAbleMasking(true)
    if 0 == currentPanelIndex or nil == currentPanelIndex then
      panel_addTab:SetShow(PaGlobal_ChatMain._isMouseOn)
    elseif nil ~= currentPanelIndex and 0 ~= currentPanelIndex then
      panel_addTab:SetShow(false)
    end
    panel_addTab:SetPosX(PaGlobal_ChatMain._tabButton_PosX)
    panel_addTab:SetPosY(1)
    if getEnableSimpleUI() then
      if PaGlobal_ChatMain._cacheSimpleUI then
        panel_addTab:SetAlpha(1)
      else
        panel_addTab:SetAlpha(0.8)
      end
    end
    panel_addTab:SetIgnore(false)
    panel_addTab:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_AddTab()")
    if nil ~= currentPanelIndex then
      panel_addTab:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. currentPanelIndex .. ", 0)")
      panel_division:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. currentPanelIndex .. ", 1)")
      panel_addTab:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. currentPanelIndex .. ", false )")
      panel_addTab:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. currentPanelIndex .. ")")
      panel_addTab:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. currentPanelIndex .. ")")
    end
  end
  if nil ~= PaGlobal_ChatMain._addChattingIdx then
    if PaGlobal_ChatMain._addChattingPreset == false then
      ChattingOption_Open(PaGlobal_ChatMain._addChattingIdx, 0, true)
    end
    PaGlobal_ChatMain._addChattingIdx = nil
  end
end
local sendPossibleTime = toUint64(0, 0)
function FromClient_ChatMain_PrivateChatMessageUpdate()
  if sendPossibleTime <= getTime() then
    audioPostEvent_SystemUi(99, 0)
    sendPossibleTime = getTime() + toUint64(0, 60000)
  end
end
function FromClient_ChatMain_EventProcessorInputModeChange()
  if false == ToClient_isLoadingProcessor() and IM.eProcessorInputMode_GameMode == getInputMode() then
    PaGlobal_ChatMain._isMouseOn = false
    FromClient_ChatUpdate(false, PaGlobal_ChatMain._mainPanelSelectPanelIndex)
  end
end
function HandleEventOn_ChatMainPanelTransparency(panelIndex, isHideTooltip)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleEventOn_ChatMainPanelTransparency panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isHideTooltip, "HandleEventOn_ChatMainPanelTransparency isHideTooltip nil", "\236\178\156\235\167\140\234\184\176")
  Chatting_PanelTransparency(panelIndex, true, isHideTooltip)
end
function HandleEventOut_ChatMainPanelTransparency(panelIndex, isHideTooltip)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleEventOut_ChatMainPanelTransparency panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isHideTooltip, "HandleEventOut_ChatMainPanelTransparency isHideTooltip nil", "\236\178\156\235\167\140\234\184\176")
  Chatting_PanelTransparency(panelIndex, false, isHideTooltip)
end
function HandleOn_ChattingEmoticon(poolIndex, emoticonIndex, EmoticonKey, isShow, isReset)
  UI.ASSERT_NAME(nil ~= poolIndex, "HandleOn_ChattingEmoticon poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= emoticonIndex, "HandleOn_ChattingEmoticon emoticonIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= EmoticonKey, "HandleOn_ChattingEmoticon EmoticonKey nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "HandleOn_ChattingEmoticon isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isReset, "HandleOn_ChattingEmoticon isReset nil", "\236\178\156\235\167\140\234\184\176")
  if true == isReset then
    PaGlobal_ChatMain._shownEmoticonIndex = nil
  end
  local EmoticonSS = ToClient_getEmoticonInfoByKey(EmoticonKey)
  if nil ~= EmoticonSS then
    local ImagePath = EmoticonSS:getSequenceImagePath()
    if nil == ImagePath then
      return
    end
    local panel = PaGlobal_ChatMain:getPanel(poolIndex)
    if false == panel:GetShow() then
      poolIndex = 0
      panel = PaGlobal_ChatMain:getPanel(poolIndex)
    end
    local poolCurrentUI = PaGlobal_ChatMain:getPool(poolIndex)
    local emoticonUI = poolCurrentUI._list_ChatEmoticon[emoticonIndex]
    local emoticonAniUi = poolCurrentUI._list_EmoticonAni[0]
    if nil ~= emoticonAniUi then
      if true == isShow and (PaGlobal_ChatMain._shownEmoticonIndex ~= emoticonIndex or true == isReset) then
        emoticonAniUi:ChangeTextureInfoNameAsync(ImagePath)
        local orgPanelPosX = panel:GetPosX()
        local orgPanelPosY = panel:GetPosY()
        if nil == emoticonUI then
          emoticonAniUi:SetPosX(getMousePosX() - emoticonAniUi:GetSizeX() - orgPanelPosX)
          emoticonAniUi:SetPosY(getMousePosY() - emoticonAniUi:GetSizeY() * 0.65 - orgPanelPosY)
        else
          if poolCurrentUI._list_PanelBG[0]:GetSizeX() < emoticonUI:GetPosX() + math.floor(emoticonAniUi:GetSizeX() * 0.85) then
            emoticonAniUi:SetPosX(poolCurrentUI._list_PanelBG[0]:GetPosX() + poolCurrentUI._list_PanelBG[0]:GetSizeX() - emoticonAniUi:GetSizeX() * 1.1)
          else
            emoticonAniUi:SetPosX(emoticonUI:GetPosX() - emoticonAniUi:GetSizeX() * 0.15)
          end
          if 0 > emoticonUI:GetPosY() - emoticonAniUi:GetSizeY() then
            emoticonAniUi:SetPosY(emoticonAniUi:GetSizeY() * 0.2)
          else
            emoticonAniUi:SetPosY(emoticonUI:GetPosY() - emoticonAniUi:GetSizeY() * 0.7)
          end
        end
        PaGlobal_ChatMain._shownEmoticonIndex = emoticonIndex
        emoticonAniUi:setUpdateTextureAni(true)
        emoticonAniUi:SetShow(true)
      elseif false == isShow and emoticonIndex == PaGlobal_ChatMain._shownEmoticonIndex then
        PaGlobal_ChatMain._shownEmoticonIndex = nil
        emoticonAniUi:SetShow(false)
      else
        PaGlobal_ChatMain._shownEmoticonIndex = nil
      end
    end
  end
end
function HandleClicked_Chatting_AddTabByIndex(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "HandleClicked_Chatting_AddTabByIndex panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._addChattingIdx = ToClient_openChattingPanelbyIndex(panelIndex)
  PaGlobal_ChatMain._addChattingPreset = true
  if PaGlobal_ChatMain._addChattingIdx == -1 then
    PaGlobal_ChatMain._addChattingIdx = nil
  else
    FromClient_ChatUpdate(true)
    ToClient_SaveUiInfo(false)
  end
  FromClient_ChatUpdate(true)
  ToClient_SaveUiInfo(false)
end
function HandleOn_Chatting_RecommandTooltip(recommandCount)
  PaGlobal_SpeechBubble_Show(recommandCount, nil)
  PaGlobal_SpeechBubble_Pos(getMousePosX() + 5, getMousePosY() - 50)
end
function PaGlobal_ChatMain:initScrollCount()
  PaGlobal_ChatMain._scrollCount = 1
end
function PaGlobal_ChatMain:addScrollCount()
  PaGlobal_ChatMain._scrollCount = math.min(PaGlobal_ChatMain._scrollCount + PaGlobal_ChatMain._SCROLL_COUNT_ADD, PaGlobal_ChatMain._SCROLL_COUNT_MAX)
end
function PaGlobal_ChatMain:getScrollSpeed(wheelScrollingTime)
  UI.ASSERT_NAME(nil ~= wheelScrollingTime, "PaGlobal_ChatMain:getScrollSpeed wheelScrollingTime nil", "\236\178\156\235\167\140\234\184\176")
  return wheelScrollingTime * PaGlobal_ChatMain._SCROLL_INTERVALSIZE * PaGlobal_ChatMain._scrollCount
end
function PaGlobal_ChatMain:getAddMessageCountLine(panelIndex, addMessageCount)
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getAddMessageCountLine panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= addMessageCount, "PaGlobal_ChatMain:getAddMessageCountLine addMessageCount nil", "\236\178\156\235\167\140\234\184\176")
  if addMessageCount <= 0 then
    return 0
  end
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  local drawPanelIndex = panelIndex
  if true == chatPanel:isCombinedToMainPanel() then
    drawPanelIndex = 0
  end
  local poolCurrentUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
  local chattingMessage = chatPanel:beginMessage(0)
  local lineCount = 0
  for i = 0, addMessageCount - 1 do
    lineCount = lineCount + PaGlobal_ChatMain:getLineSizeCheck(chattingMessage, poolCurrentUI, 0, i, panelIndex)
    chattingMessage = chatPanel:nextMessage()
  end
  return lineCount
end
function PaGlobal_ChatMain:addMessageScrollCount(panelIndex, addMessageCount)
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:addMessageScrollCount panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= addMessageCount, "PaGlobal_ChatMain:addMessageScrollCount addMessageCount nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_ChatMain._srollPosition[panelIndex] <= 0 then
    return
  end
  local countLine = PaGlobal_ChatMain:getAddMessageCountLine(panelIndex, addMessageCount)
  PaGlobal_ChatMain._srollPosition[panelIndex] = PaGlobal_ChatMain._srollPosition[panelIndex] + countLine
end
function PaGlobal_ChatMain:getCheckAddMessageCount(chatPanel, panelIndex)
  UI.ASSERT_NAME(nil ~= chatPanel, "PaGlobal_ChatMain:getCheckAddMessageCount chatPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getCheckAddMessageCount panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  local addMessageCount = 0
  if 0 == chatPanel:getPopMessageCount() then
    addMessageCount = chatPanel:getMessageCount() - PaGlobal_ChatMain._premsgCount[panelIndex]
    PaGlobal_ChatMain._premsgCount[panelIndex] = chatPanel:getMessageCount()
  else
    if chatPanel:getPopMessageCount() < PaGlobal_ChatMain._prepopmsgCount[panelIndex] then
      PaGlobal_ChatMain._prepopmsgCount[panelIndex] = 0
    end
    if ToClient_getChattingMaxContentsCount() == PaGlobal_ChatMain._premsgCount[panelIndex] then
      addMessageCount = chatPanel:getPopMessageCount() - PaGlobal_ChatMain._prepopmsgCount[panelIndex]
    else
      addMessageCount = chatPanel:getPopMessageCount() - PaGlobal_ChatMain._prepopmsgCount[panelIndex] + ToClient_getChattingMaxContentsCount() - PaGlobal_ChatMain._premsgCount[panelIndex]
      PaGlobal_ChatMain._premsgCount[panelIndex] = ToClient_getChattingMaxContentsCount()
    end
    PaGlobal_ChatMain._prepopmsgCount[panelIndex] = chatPanel:getPopMessageCount()
  end
  return addMessageCount
end
function HandleClicked_Chatting_Recommand(senderUserNo)
  UI.ASSERT_NAME(nil ~= senderUserNo, "HandleClicked_Chatting_Recommand senderUserNo nil", "\236\158\132\236\136\152\237\152\132")
  local selfUserNo = getSelfPlayer():get():getUserNo()
  if selfUserNo == senderUserNo then
    return
  end
  ToClient_GiveThumbsUp(toInt64(0, senderUserNo))
end
function FromClient_ChatMain_RecieveThumbsUpFromUser(charname)
  Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECOMMAND_ALERT_MESSAGE", "actorName", charname))
end
