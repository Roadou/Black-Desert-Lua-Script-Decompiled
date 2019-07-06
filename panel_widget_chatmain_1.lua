local UI_color = Defines.Color
function PaGlobal_ChatMain:initialize()
  if true == PaGlobal_ChatMain._initialize then
    return
  end
  PaGlobal_ChatMain._isUsedSmoothChattingUp = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eChattingAnimation)
  PaGlobal_ChatMain:resetAllScroll()
  PaGlobal_ChatMain:registEventHandler()
  PaGlobal_ChatMain:validate()
  PaGlobal_ChatMain._initialize = true
  Chatting_OnResize()
end
function PaGlobal_ChatMain:registEventHandler()
  registerEvent("onScreenResize", "Chatting_OnResize")
  registerEvent("EventChattingMessageUpdate", "FromClient_ChatUpdate")
  registerEvent("FromClient_PrivateChatMessageUpdate", "FromClient_ChatMain_PrivateChatMessageUpdate")
  registerEvent("EventProcessorInputModeChange", "FromClient_ChatMain_EventProcessorInputModeChange")
  registerEvent("FromClient_RenderModeChangeState", "Chatting_OnResize")
  registerEvent("EventSimpleUIEnable", "FromClient_ChatUpdate")
  registerEvent("EventSimpleUIDisable", "FromClient_ChatUpdate")
  registerEvent("FromClient_RecieveThumbsUpFromUser", "FromClient_ChatMain_RecieveThumbsUpFromUser")
end
function PaGlobal_ChatMain:prepareOpen()
end
function PaGlobal_ChatMain:open()
  Panel_ChatMain:SetShow(true)
end
function PaGlobal_ChatMain:prepareClose()
end
function PaGlobal_ChatMain:close()
  Panel_ChatMain:SetShow(false)
end
function PaGlobal_ChatMain:update(chatPanel, panelIndex, isShow)
  UI.ASSERT_NAME(nil ~= chatPanel, "PaGlobal_ChatMain:update chatPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:update panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  if nil == getSelfPlayer() or nil == getSelfPlayer():get() then
    return
  end
  if false == CheckTutorialEnd() and nil ~= PaGlobal_TutorialManager and true == PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
  local drawPanelIndex = panelIndex
  local bgAlpah = PaGlobal_ChatMain._transparency[drawPanelIndex]
  if true == isCombinedMainPanel then
    drawPanelIndex = 0
  end
  local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
  local poolCurrentUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
  if nil == isShow then
    isShow = false
  end
  if PaGlobal_ChatMain._isMouseOnChattingViewIndex ~= nil and PaGlobal_ChatMain._isMouseOnChattingViewIndex == drawPanelIndex then
    isShow = PaGlobal_ChatMain._isMouseOn
    if isShow then
      bgAlpah = 1
    end
  else
    isShow = UI.checkIsInMouseAndEventPanel(currentPanel)
  end
  currentPanel:SetColor(UI_color.C_00000000)
  local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
  PaGlobal_ChatMain._tabButton_PosX = PaGlobal_ChatMain:createTab(poolCurrentUI, panelIndex, isActivePanel, drawPanelIndex, isCombinedMainPanel, PaGlobal_ChatMain._tabButton_PosX, isShow)
  if isCombinedMainPanel then
    if 0 ~= panelIndex then
      PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
      PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
    end
    if false == isActivePanel then
      return
    end
  elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
    if PaGlobal_ChatMain:getPanel(0):GetShow() then
      PaGlobal_ChatMain:getPanel(panelIndex):SetShow(true)
      PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(false)
    end
  elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
    PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
    PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
  end
  if false == CheckTutorialEnd() then
    for ii = 1, PaGlobal_ChatMain._POOLCOUNT - 1 do
      PaGlobal_ChatMain:getPanel(ii):SetShow(false)
    end
  end
  PaGlobal_ChatMain:chattingPoolUpdate(poolCurrentUI, currentPanel, panelIndex, drawPanelIndex, isShow, bgAlpah, false)
  if true == PaGlobal_ChatMain._isResetsmoothscroll or true == PaGlobal_ChatMain._issmoothWheelscroll or true == PaGlobal_ChatMain._issmoothscroll then
    return
  end
  local addMessageCount = PaGlobal_ChatMain:updateSmoothChatting(chatPanel, panelIndex)
  if true == PaGlobal_ChatMain._issmoothupMessage then
    if isCombinedMainPanel then
      local count = ToClient_getChattingPanelCount()
      for combinepanelIndex = 0, count - 1 do
        local checkchatPanel = ToClient_getChattingPanel(combinepanelIndex)
        if true == checkchatPanel:isCombinedToMainPanel() then
          addMessageCount = PaGlobal_ChatMain:getCheckAddMessageCount(checkchatPanel, combinepanelIndex)
          PaGlobal_ChatMain:addMessageScrollCount(combinepanelIndex, addMessageCount)
        end
      end
    else
      addMessageCount = PaGlobal_ChatMain:getCheckAddMessageCount(chatPanel, panelIndex)
      PaGlobal_ChatMain:addMessageScrollCount(panelIndex, addMessageCount)
    end
    return
  end
  PaGlobal_ChatMain:addMessageScrollCount(panelIndex, addMessageCount)
  PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
  local showEmoticonInfo = PaGlobal_ChatMain:getShowEmoticonInfo(panelIndex)
  if nil ~= showEmoticonInfo then
    if true == chatPanel:getUseEmoticonAutoPlay() then
      HandleOn_ChattingEmoticon(showEmoticonInfo._panelIndex, showEmoticonInfo._emoticonIndex, tonumber(showEmoticonInfo._key), true, true)
    end
    PaGlobal_ChatMain:resetEmoticonInfo(panelIndex)
  end
end
function PaGlobal_ChatMain:validate()
end
function PaGlobal_ChatMain:createTab(poolCurrentUI, panelIndex, isActivePanel, drawPanelIndex, isCombinedMainPanel, PosX, isShow)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:createTab poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:createTab panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isActivePanel, "PaGlobal_ChatMain:createTab isActivePanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:createTab drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isCombinedMainPanel, "PaGlobal_ChatMain:createTab isCombinedMainPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= PosX, "PaGlobal_ChatMain:createTab PosX nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobal_ChatMain:createTab isShow nil", "\236\178\156\235\167\140\234\184\176")
  local isEnableSimpleUI = getEnableSimpleUI()
  local isSimpleUI = PaGlobal_ChatMain._cacheSimpleUI
  if isCombinedMainPanel then
    if isActivePanel then
      local mainTab = PaGlobal_ChatMain:getMainTab(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
      mainTab:SetPosX(PosX)
      mainTab:SetTextSpan(40, 9)
      mainTab:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
      local settingButton = PaGlobal_ChatMain:getSettingButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
      settingButton:SetPosX(PosX + 3)
      settingButton:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. drawPanelIndex .. ", 2)")
      settingButton:addInputEvent("Mouse_LUp", "ChattingOption_Open( " .. panelIndex .. ", " .. drawPanelIndex .. ", " .. tostring(isCombinedMainPanel) .. " )")
      settingButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
      settingButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
      settingButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
      if 0 ~= panelIndex then
        local divisionButton = PaGlobal_ChatMain:getDivisionButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
        divisionButton:SetPosX(PosX + mainTab:GetSizeX() - divisionButton:GetSizeX() * 2 - 5)
        divisionButton:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. drawPanelIndex .. ", 1)")
        divisionButton:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_Division( " .. panelIndex .. " )")
        divisionButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
        divisionButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
        divisionButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
        local deleteButton = PaGlobal_ChatMain:getDeleteButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
        deleteButton:SetPosX(PosX + mainTab:GetSizeX() - deleteButton:GetSizeX() - 5)
        deleteButton:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_Close( " .. panelIndex .. ", " .. drawPanelIndex .. " )")
        deleteButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
        deleteButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
        deleteButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
      end
      local isBottom = 0 == PaGlobal_ChatMain._srollPosition[panelIndex]
      local scrollResetBtn = PaGlobal_ChatMain:getScrollResetButton(poolCurrentUI, panelIndex, drawPanelIndex, false == isBottom, isEnableSimpleUI, isSimpleUI)
      scrollResetBtn:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_ScrollReset( " .. panelIndex .. " )")
      scrollResetBtn:SetSize(PaGlobal_ChatMain._listPanel[drawPanelIndex]:GetSizeX(), 28)
      scrollResetBtn:ComputePos()
      local moreList = PaGlobal_ChatMain:getMoreList(poolCurrentUI, panelIndex, drawPanelIndex, scrollResetBtn:GetShow(), isEnableSimpleUI, isSimpleUI)
      moreList:ComputePos()
      PosX = PosX + mainTab:GetSizeX()
    else
      local subTab = PaGlobal_ChatMain:getSubTab(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
      subTab:SetPosX(PosX)
      local penal = ToClient_getChattingPanel(0)
      subTab:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_ChangeTab( " .. panelIndex .. " )")
      subTab:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
      PosX = PosX + subTab:GetSizeX()
    end
  else
    local mainTab = PaGlobal_ChatMain:getMainTab(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
    mainTab:SetPosX(0)
    mainTab:SetTextSpan(40, 8)
    mainTab:addInputEvent("Mouse_On", "HandleEventOn_ChatMainPanelTransparency(" .. panelIndex .. ", false )")
    mainTab:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. panelIndex .. ", false )")
    local settingButton = PaGlobal_ChatMain:getSettingButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
    settingButton:SetPosX(3)
    settingButton:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. drawPanelIndex .. ", 2)")
    settingButton:addInputEvent("Mouse_LUp", "ChattingOption_Open( " .. panelIndex .. ", " .. drawPanelIndex .. ", " .. tostring(isCombinedMainPanel) .. " )")
    settingButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
    settingButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    settingButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    local combineButton = PaGlobal_ChatMain:getCombineButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
    combineButton:SetPosX(mainTab:GetSizeX() - combineButton:GetSizeX() * 2 - 5)
    combineButton:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. drawPanelIndex .. ", 4)")
    combineButton:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_CombineTab( " .. panelIndex .. " )")
    combineButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
    combineButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    combineButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    local deleteButton = PaGlobal_ChatMain:getDeleteButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
    deleteButton:SetPosX(mainTab:GetSizeX() - deleteButton:GetSizeX() - 5)
    deleteButton:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_Close( " .. panelIndex .. ", " .. drawPanelIndex .. " )")
    deleteButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
    deleteButton:addInputEvent("Mouse_LPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    deleteButton:addInputEvent("Mouse_RPress", "Chatting_Transparency(" .. drawPanelIndex .. ")")
    local isBottom = 0 == PaGlobal_ChatMain._srollPosition[panelIndex]
    local scrollResetBtn = PaGlobal_ChatMain:getScrollResetButton(poolCurrentUI, panelIndex, drawPanelIndex, false == isBottom, isEnableSimpleUI, isSimpleUI)
    scrollResetBtn:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_ScrollReset( " .. panelIndex .. " )")
    scrollResetBtn:SetSize(PaGlobal_ChatMain._listPanel[drawPanelIndex]:GetSizeX(), 28)
    scrollResetBtn:ComputePos()
    local moreList = PaGlobal_ChatMain:getMoreList(poolCurrentUI, panelIndex, drawPanelIndex, scrollResetBtn:GetShow(), isEnableSimpleUI, isSimpleUI)
    moreList:ComputePos()
  end
  return PosX
end
function PaGlobal_ChatMain:chattingPoolUpdate(poolCurrentUI, currentPanel, panelIndex, drawPanelIndex, isShow, bgAlpha, isClear)
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "ChattingPoolUpdate poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= currentPanel, "ChattingPoolUpdate currentPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "ChattingPoolUpdate panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "ChattingPoolUpdate drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "ChattingPoolUpdate isShow nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= bgAlpha, "ChattingPoolUpdate bgAlpha nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isClear, "ChattingPoolUpdate isClear nil", "\236\178\156\235\167\140\234\184\176")
  if true == isClear then
    poolCurrentUI:clear()
  end
  local isEnableSimpleUI = getEnableSimpleUI()
  local isSimpleUI = PaGlobal_ChatMain._cacheSimpleUI
  local panel_resizeButton = PaGlobal_ChatMain:getPanelResizeButton(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  panel_resizeButton:addInputEvent("Mouse_On", "HandleOn_ChattingAddTabToolTip(true, " .. drawPanelIndex .. ", 3)")
  panel_resizeButton:addInputEvent("Mouse_LDown", "HandleClicked_Chatting_ResizeStartPos( " .. drawPanelIndex .. " )")
  panel_resizeButton:addInputEvent("Mouse_LPress", "HandleClicked_Chatting_Resize( " .. drawPanelIndex .. ", " .. panelIndex .. " )")
  panel_resizeButton:addInputEvent("Mouse_RPress", "HandleEventOut_ChatMainPanelTransparency( " .. drawPanelIndex .. ", false )")
  panel_resizeButton:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_ResizeStartPosEND(" .. drawPanelIndex .. ")")
  panel_resizeButton:addInputEvent("Mouse_RUp", "HandleEventOut_ChatMainPanelTransparency( " .. drawPanelIndex .. ", false )")
  panel_resizeButton:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. drawPanelIndex .. ", false )")
  local panel_Bg = PaGlobal_ChatMain:getPanelBg(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  panel_Bg:SetAlpha(bgAlpha)
  panel_Bg:SetSize(panel_Bg:GetSizeX(), currentPanel:GetSizeY() - 30)
  panel_Bg:SetPosY(30)
  local panel_Scroll = PaGlobal_ChatMain:getPanelScroll(poolCurrentUI, panelIndex, drawPanelIndex, isShow, isEnableSimpleUI, isSimpleUI)
  panel_Scroll:SetInterval(PaGlobal_ChatMain._MAX_HISTORYCOUNT)
  panel_Scroll:SetCtrlWeight(0.1)
  panel_Scroll:SetPosX(panel_Bg:GetSizeX() - panel_Scroll:GetSizeX() - 3)
  panel_Scroll:SetControlPos(PaGlobal_ChatMain._scroll_BTNPos[panelIndex])
  panel_Scroll:addInputEvent("Mouse_LUp", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )")
  panel_Scroll:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. panelIndex .. ", false )")
  local panel_ScrollBtn = panel_Scroll:GetControlButton()
  panel_ScrollBtn:SetShow(isShow)
  panel_ScrollBtn:addInputEvent("Mouse_LPress", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )")
  panel_ScrollBtn:addInputEvent("Mouse_RPress", "HandleClicked_ScrollBtnPosY( " .. panelIndex .. " )")
  panel_ScrollBtn:addInputEvent("Mouse_Out", "HandleEventOut_ChatMainPanelTransparency(" .. panelIndex .. ", false )")
  if isEnableSimpleUI then
    panel_ScrollBtn:SetShow(isSimpleUI)
  end
end
function PaGlobal_ChatMain:resetAllScroll()
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      local poolCurrentUI = PaGlobal_ChatMain:getPool(panelIndex)
      local panelCurrentUI = PaGlobal_ChatMain:getPanel(panelIndex)
      PaGlobal_ChatMain._srollPosition[panelIndex] = 0
      if nil ~= poolCurrentUI._list_Scroll[0] then
        poolCurrentUI._list_Scroll[0]:SetControlPos(1)
      end
    end
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobal_ChatMain:chatting_ShowOff()
  else
    FromClient_ChatUpdate(true)
  end
end
function PaGlobal_ChatMain:chatPanel_Update()
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatUI = PaGlobal_ChatMain:getPool(panelIndex)
    for chattingContents_idx = 0, chatUI._MAXCOUNT_CHATTINGCONTENTS - 1 do
      chatUI._list_ChattingSender[chattingContents_idx]:SetText(" ")
      chatUI._list_ChattingSender[chattingContents_idx]:SetSize(chatUI._list_ChattingSender[chattingContents_idx]:GetSizeX(), chatUI._list_ChattingSender[chattingContents_idx]:GetSizeY())
    end
    chatUI:clear()
  end
end
function ChattingViewManager_UpdatePerFrame(deltaTime)
  UI.ASSERT_NAME(nil ~= deltaTime, "ChattingViewManager_UpdatePerFrame deltaTime nil", "\236\178\156\235\167\140\234\184\176")
  if PaGlobal_ChatMain._isResetsmoothscroll then
    PaGlobal_ChatMain._smoothResetScorllTime = PaGlobal_ChatMain._smoothResetScorllTime + deltaTime / 2
    PaGlobal_ChatMain:UpdateSmoothResetScrollContent(PaGlobal_ChatMain._smoothResetScorllTime)
    return
  end
  if PaGlobal_ChatMain._issmoothWheelscroll then
    PaGlobal_ChatMain._smoothWheelScorllTime = PaGlobal_ChatMain._smoothWheelScorllTime + deltaTime
    if PaGlobal_ChatMain._smoothWheelScorllTime > 0.2 then
      PaGlobal_ChatMain._issmoothWheelscroll = false
      PaGlobal_ChatMain._smoothWheelScorllTime = 0
      PaGlobal_ChatMain:UpdateSmoothWheelScrollContent(deltaTime)
      return
    end
    PaGlobal_ChatMain:UpdateSmoothWheelScrollContent(deltaTime)
    return
  end
  if PaGlobal_ChatMain._issmoothscroll then
    PaGlobal_ChatMain._smoothScorllTime = PaGlobal_ChatMain._smoothScorllTime + deltaTime
    if PaGlobal_ChatMain._smoothScorllTime > 0.01 then
      PaGlobal_ChatMain._issmoothscroll = false
      PaGlobal_ChatMain._smoothScorllTime = 0
      PaGlobal_ChatMain:UpdateSmoothScrollContent()
      return
    end
    PaGlobal_ChatMain:UpdateSmoothScrollContent()
  elseif PaGlobal_ChatMain._issmoothupMessage then
    PaGlobal_ChatMain._chattingUpTime = PaGlobal_ChatMain._chattingUpTime + deltaTime
    if 0.2 < PaGlobal_ChatMain._chattingUpTime then
      PaGlobal_ChatMain._issmoothupMessage = false
    end
    PaGlobal_ChatMain:UpdateSmoothChattingContent(PaGlobal_ChatMain._chattingUpTime)
  end
end
function PaGlobal_ChatMain:chatting_ShowOff()
  for chatPoolIdx = 0, PaGlobal_ChatMain._POOLCOUNT - 1 do
    local baseChatPanel = PaGlobal_ChatMain:getPanel(chatPoolIdx)
    if nil ~= baseChatPanel then
      baseChatPanel:SetShow(false)
    end
  end
end
function moveChatTab(isMoveTo)
  UI.ASSERT_NAME(nil ~= isMoveTo, "moveChatTab isMoveTo nil", "\236\178\156\235\167\140\234\184\176")
  local isSuccess = false
  local tempValue = 0
  while false == isSuccess and tempValue < 5 do
    isSuccess = PaGlobal_ChatMain:moveChatTabExec(isMoveTo)
    tempValue = tempValue + 1
  end
end
function PaGlobal_ChatMain:moveChatTabExec(isMoveTo)
  UI.ASSERT_NAME(nil ~= isMoveTo, "PaGlobal_ChatMain:moveChatTabExec isMoveTo nil", "\236\178\156\235\167\140\234\184\176")
  local isSuccess = false
  local addIndex = 1
  if false == isMoveTo then
    addIndex = -1
  end
  local index = PaGlobal_ChatMain._mainPanelSelectPanelIndex + addIndex
  if index < 0 then
    index = PaGlobal_ChatMain._POOLCOUNT - 1
  elseif index > PaGlobal_ChatMain._POOLCOUNT - 1 then
    index = 0
  end
  local chatPanelInfo = ToClient_getChattingPanel(index)
  if nil ~= chatPanelInfo then
    isSuccess = chatPanelInfo:isCombinedToMainPanel() and chatPanelInfo:isOpen()
  end
  HandleClicked_Chatting_ChangeTab(index)
  return isSuccess
end
function FGlobal_getChattingPanel(poolIndex)
  UI.ASSERT_NAME(nil ~= poolIndex, "FGlobal_getChattingPanel poolIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain:getPanel(poolIndex)
end
function FGlobal_getChattingPanelUIPool(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "FGlobal_getChattingPanelUIPool panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain:getPool(panelIndex)
end
function Chatting_setUsedSmoothChattingUp(flag)
  UI.ASSERT_NAME(nil ~= flag, "Chatting_setUsedSmoothChattingUp flag nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._isUsedSmoothChattingUp = flag
end
function Chatting_getUsedSmoothChattingUp()
  return PaGlobal_ChatMain._isUsedSmoothChattingUp
end
function Chatting_setIsOpenValue(panelIndex, isOpen)
  UI.ASSERT_NAME(nil ~= panelIndex, "Chatting_setIsOpenValue panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isOpen, "Chatting_setIsOpenValue isOpen nil", "\236\178\156\235\167\140\234\184\176")
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  chatPanel:setOpenValue(isOpen)
  if nil ~= PaGlobal_ImportantNotice_SetShow and 0 == panelIndex then
    PaGlobal_ImportantNotice_SetShow(isOpen)
  end
end
function FGlobal_Chatting_PanelTransparency_Chk(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "FGlobal_Chatting_PanelTransparency_Chk panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain._transparency[panelIndex]
end
function FGlobal_Chatting_PanelTransparency(panelIndex, _transparency, isUpdate)
  UI.ASSERT_NAME(nil ~= panelIndex, "FGlobal_Chatting_PanelTransparency panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= _transparency, "FGlobal_Chatting_PanelTransparency _transparency nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isUpdate, "FGlobal_Chatting_PanelTransparency isUpdate nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._transparency[panelIndex] = _transparency
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  chatPanel:setTransparency(_transparency)
  if isUpdate then
    FromClient_ChatUpdate()
  end
end
function FGlobal_ChattingPanel_Reset()
  ToClient_setDefaultChattingPanel()
  setisChangeFontSize(true)
  local baseChatPanel = PaGlobal_ChatMain:getPanel(0)
  baseChatPanel:SetShow(true)
  FromClient_ChatUpdate()
end
function PaGlobalFunc_isItemEmticon(EmoticonKey)
  UI.ASSERT_NAME(nil ~= EmoticonKey, "PaGlobalFunc_isItemEmticon EmoticonKey nil", "\236\178\156\235\167\140\234\184\176")
  local EmoticonSS = ToClient_getEmoticonInfoByKey(EmoticonKey)
  if nil == EmoticonSS then
    return false
  end
  if 0 == EmoticonSS:getGroup() then
    return true
  end
  return false
end
function PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, chattingUpTime)
  UI.ASSERT_NAME(nil ~= chatPanel, "PaGlobal_ChatMain:updateChatMessage chatPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:updateChatMessage panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawPanelIndex, "PaGlobal_ChatMain:updateChatMessage drawPanelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingUpTime, "PaGlobal_ChatMain:updateChatMessage chattingUpTime nil", "\236\178\156\235\167\140\234\184\176")
  local poolCurrentUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
  local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
  local messageIndex = 0
  local skipCount = PaGlobal_ChatMain._srollPosition[panelIndex]
  local chattingMessage = chatPanel:beginMessage(messageIndex)
  local chatting_content_PosY = poolCurrentUI._list_PanelBG[0]:GetSizeY() - 5
  poolCurrentUI:drawclear()
  local breakPos = 10
  while nil ~= chattingMessage do
    chatting_content_PosY, skipCount = PaGlobal_ChatMain:createChattingContent(chattingMessage, poolCurrentUI, chatting_content_PosY, messageIndex, panelIndex, PaGlobal_ChatMain._deltascrollPosy[panelIndex], PaGlobal_ChatMain._cacheSimpleUI, chattingUpTime, skipCount)
    if chatting_content_PosY < breakPos then
      break
    else
      chattingMessage = chatPanel:nextMessage()
      messageIndex = messageIndex + 1
    end
  end
end
function PaGlobal_ChatMain:UpdateSmoothChattingContent(chattingUpTime)
  UI.ASSERT_NAME(nil ~= chattingUpTime, "PaGlobal_ChatMain:UpdateSmoothChattingContent chattingUpTime nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate(true)
  local count = ToClient_getChattingPanelCount()
  local checkchattingupTime = 0
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      if false == chatPanel:getPushchattingMsg() or true == chatPanel:isChattingPanelFreeze() then
        checkchattingupTime = 0
      else
        checkchattingupTime = chattingUpTime
      end
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local drawPanelIndex = panelIndex
      if true == isCombinedMainPanel then
        drawPanelIndex = 0
      end
      local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
      local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      currentPanel:SetColor(UI_color.C_00000000)
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if PaGlobal_ChatMain:getPanel(0):GetShow() then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(true)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
        PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
      end
      if false == CheckTutorialEnd() then
        for ii = 1, PaGlobal_ChatMain._POOLCOUNT - 1 do
          PaGlobal_ChatMain:getPanel(ii):SetShow(false)
        end
      end
      if false == isCombinedMainPanel or true == isActivePanel then
        if false == PaGlobal_ChatMain._issmoothupMessage or 0 ~= PaGlobal_ChatMain._srollPosition[panelIndex] then
          PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
        else
          PaGlobal_ChatMain._deltascrollPosy[panelIndex] = 0
          PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, checkchattingupTime)
        end
      end
    end
  end
  if chattingUpTime > 0.2 and false == PaGlobal_ChatMain._issmoothupMessage then
    PaGlobal_ChatMain._isMsgin = false
    for panelIndex = 0, count - 1 do
      local chatPanel = ToClient_getChattingPanel(panelIndex)
      chatPanel:setPushchattingMsg(false)
    end
  end
end
function PaGlobal_ChatMain:UpdateSmoothScrollContent()
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local drawPanelIndex = panelIndex
      if true == isCombinedMainPanel then
        drawPanelIndex = 0
      end
      local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
      local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      currentPanel:SetColor(UI_color.C_00000000)
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if PaGlobal_ChatMain:getPanel(0):GetShow() then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(true)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
        PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
      end
      if false == CheckTutorialEnd() then
        for ii = 1, PaGlobal_ChatMain._POOLCOUNT - 1 do
          PaGlobal_ChatMain:getPanel(ii):SetShow(false)
        end
      end
      if false == isCombinedMainPanel or true == isActivePanel then
        PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
      end
    end
  end
end
function PaGlobal_ChatMain:updateSmoothChatting(chatPanel, panelIndex)
  UI.ASSERT_NAME(nil ~= chatPanel, "PaGlobal_ChatMain:updateSmoothChatting chatPanel nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:updateSmoothChatting panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  if true == PaGlobal_ChatMain._isMsgin then
    return 0
  end
  if true == PaGlobal_ChatMain._isUsedSmoothChattingUp then
    if false == chatPanel:getPushchattingMsg() then
      return 0
    end
    if true == PaGlobal_ChatMain._issmoothupMessage then
      return 0
    end
    if 0 < chatPanel:getMessageCount() - PaGlobal_ChatMain._premsgCount[panelIndex] and chatPanel:getMessageCount() - PaGlobal_ChatMain._premsgCount[panelIndex] < 5 then
      if 0 == chatPanel:getPopMessageCount() then
        PaGlobal_ChatMain._issmoothupMessage = true
        PaGlobal_ChatMain._chattingUpTime = 0
        PaGlobal_ChatMain._isMsgin = true
      else
        if chatPanel:getPopMessageCount() < PaGlobal_ChatMain._prepopmsgCount[panelIndex] then
          PaGlobal_ChatMain._prepopmsgCount[panelIndex] = 0
        end
        if 5 > chatPanel:getPopMessageCount() - PaGlobal_ChatMain._prepopmsgCount[panelIndex] then
          PaGlobal_ChatMain._issmoothupMessage = true
          PaGlobal_ChatMain._chattingUpTime = 0
          PaGlobal_ChatMain._isMsgin = true
        end
      end
    end
  end
  return PaGlobal_ChatMain:getCheckAddMessageCount(chatPanel, panelIndex)
end
function PaGlobal_ChatMain:UpdateSmoothResetScrollContent(chattingScrollingTime)
  UI.ASSERT_NAME(nil ~= chattingScrollingTime, "PaGlobal_ChatMain:UpdateSmoothResetScrollContent chattingScrollingTime nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate(true)
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local drawPanelIndex = panelIndex
      if true == isCombinedMainPanel then
        drawPanelIndex = 0
      end
      local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
      local poolCurrentUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
      currentPanel:SetColor(UI_color.C_00000000)
      local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
        end
        if false == isActivePanel then
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if PaGlobal_ChatMain:getPanel(0):GetShow() then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(true)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
        PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
      end
      if false == CheckTutorialEnd() then
        for ii = 1, PaGlobal_ChatMain._POOLCOUNT - 1 do
          PaGlobal_ChatMain:getPanel(ii):SetShow(false)
        end
      end
      if false == isCombinedMainPanel then
        local downIndex = 0
        local currdownPosY = 0
        local downPosY = 0
        if PaGlobal_ChatMain._scrollIndex == panelIndex then
          PaGlobal_ChatMain:chattingPoolUpdate(poolCurrentUI, currentPanel, panelIndex, drawPanelIndex, true, 1, true)
          if PaGlobal_ChatMain._scrollresetSpeed < 5 then
            PaGlobal_ChatMain._scrollresetSpeed = PaGlobal_ChatMain._scrollresetSpeed + 2
          end
          currdownPosY = PaGlobal_AnimationEasingFun_easeOutQuadFragments(chattingScrollingTime, PaGlobal_ChatMain._scrollresetSpeed * 0.9)
          downPosY = math.abs(currdownPosY - PaGlobal_ChatMain._preDownPosY)
          if downPosY > 1 then
            PaGlobal_ChatMain._preDownPosY = currdownPosY
          end
          downIndex = math.floor(downPosY)
          PaGlobal_ChatMain._deltascrollPosy[panelIndex] = -(downPosY - downIndex)
          if false == PaGlobal_ChatMain._isResetsmoothscroll then
            PaGlobal_ChatMain._smoothResetScorllTime = 0
            PaGlobal_ChatMain._preDownPosY = 0
            PaGlobal_ChatMain._deltascrollPosy[PaGlobal_ChatMain._scrollIndex] = 0
            PaGlobal_ChatMain._srollPosition[panelIndex] = 0
            PaGlobal_ChatMain._scroll_BTNPos[panelIndex] = 1
            FromClient_ChatUpdate(true)
            break
          end
          PaGlobal_ChatMain._srollPosition[panelIndex] = PaGlobal_ChatMain._srollPosition[panelIndex] - downIndex
          if 0 >= PaGlobal_ChatMain._srollPosition[panelIndex] then
            PaGlobal_ChatMain._smoothResetScorllTime = 0
            PaGlobal_ChatMain._preDownPosY = 0
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = 0
            PaGlobal_ChatMain._srollPosition[panelIndex] = 0
            PaGlobal_ChatMain._scroll_BTNPos[panelIndex] = 1
            PaGlobal_ChatMain._isResetsmoothscroll = false
            FromClient_ChatUpdate(true)
            break
          end
          poolCurrentUI._list_Scroll[0]:SetControlPos(1 - PaGlobal_ChatMain._srollPosition[panelIndex] / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1))
        end
        PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
      elseif isActivePanel then
        local downIndex = 0
        local currdownPosY = 0
        local downPosY = 0
        if PaGlobal_ChatMain._scrollIndex == panelIndex then
          PaGlobal_ChatMain:chattingPoolUpdate(poolCurrentUI, currentPanel, panelIndex, drawPanelIndex, true, 1, true)
          if PaGlobal_ChatMain._scrollresetSpeed < 5 then
            PaGlobal_ChatMain._scrollresetSpeed = PaGlobal_ChatMain._scrollresetSpeed + 2
          end
          currdownPosY = PaGlobal_AnimationEasingFun_easeOutQuadFragments(chattingScrollingTime, PaGlobal_ChatMain._scrollresetSpeed * 0.9)
          downPosY = math.abs(currdownPosY - PaGlobal_ChatMain._preDownPosY)
          if downPosY > 1 then
            PaGlobal_ChatMain._preDownPosY = currdownPosY
          end
          downIndex = math.floor(downPosY)
          PaGlobal_ChatMain._deltascrollPosy[PaGlobal_ChatMain._scrollIndex] = -(downPosY - downIndex)
          if false == PaGlobal_ChatMain._isResetsmoothscroll then
            PaGlobal_ChatMain._smoothResetScorllTime = 0
            PaGlobal_ChatMain._preDownPosY = 0
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = 0
            PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex] = 0
            PaGlobal_ChatMain._scroll_BTNPos[PaGlobal_ChatMain._scrollIndex] = 1
            FromClient_ChatUpdate(true)
            break
          end
          PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex] = PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex] - downIndex
          if 0 >= PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex] then
            PaGlobal_ChatMain._smoothResetScorllTime = 0
            PaGlobal_ChatMain._preDownPosY = 0
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = 0
            PaGlobal_ChatMain._srollPosition[PaGlobal_ChatMain._scrollIndex] = 0
            PaGlobal_ChatMain._scroll_BTNPos[PaGlobal_ChatMain._scrollIndex] = 1
            PaGlobal_ChatMain._isResetsmoothscroll = false
            FromClient_ChatUpdate(true)
            break
          end
          poolCurrentUI._list_Scroll[0]:SetControlPos(1 - PaGlobal_ChatMain._srollPosition[panelIndex] / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1))
        end
        PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
      end
    end
  end
  if false == PaGlobal_ChatMain._isResetsmoothscroll then
    PaGlobal_ChatMain._tabButton_PosX = 0
    for panelIndex = 0, count - 1 do
      local chatPanel = ToClient_getChattingPanel(panelIndex)
      PaGlobal_ChatMain:getPool(panelIndex):clear()
      if chatPanel:isOpen() then
        PaGlobal_ChatMain:update(chatPanel, panelIndex)
      end
    end
  end
end
function PaGlobal_ChatMain:UpdateSmoothWheelScrollContent(wheelScrollingTime)
  UI.ASSERT_NAME(nil ~= wheelScrollingTime, "PaGlobal_ChatMain:UpdateSmoothWheelScrollContent wheelScrollingTime nil", "\236\178\156\235\167\140\234\184\176")
  FromClient_ChatUpdate(true)
  local count = ToClient_getChattingPanelCount()
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    if chatPanel:isOpen() then
      local isCombinedMainPanel = chatPanel:isCombinedToMainPanel()
      local drawPanelIndex = panelIndex
      if true == isCombinedMainPanel then
        drawPanelIndex = 0
      end
      local currentPanel = PaGlobal_ChatMain:getPanel(drawPanelIndex)
      currentPanel:SetColor(UI_color.C_00000000)
      local isActivePanel = panelIndex == PaGlobal_ChatMain._mainPanelSelectPanelIndex
      if isCombinedMainPanel then
        if 0 ~= panelIndex then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
        end
      elseif false == isCombinedMainPanel and true == chatPanel:isOpen() then
        if PaGlobal_ChatMain:getPanel(0):GetShow() then
          PaGlobal_ChatMain:getPanel(panelIndex):SetShow(true)
          PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(false)
        end
      elseif false == isCombinedMainPanel and false == chatPanel:isOpen() then
        PaGlobal_ChatMain:getPanel(panelIndex):SetShow(false)
        PaGlobal_ChatMain:getPanel(panelIndex):SetIgnore(true)
      end
      if false == CheckTutorialEnd() then
        for ii = 1, PaGlobal_ChatMain._POOLCOUNT - 1 do
          PaGlobal_ChatMain:getPanel(ii):SetShow(false)
        end
      end
      if false == isCombinedMainPanel then
        if PaGlobal_ChatMain._scrollIndex == panelIndex and PaGlobal_ChatMain._issmoothWheelscroll then
          local poolScrollUI = PaGlobal_ChatMain:getPool(PaGlobal_ChatMain._scrollIndex)
          if PaGlobal_ChatMain._isUpDown then
            poolScrollUI._list_Scroll[0]:SetControlPos(poolScrollUI._list_Scroll[0]:GetControlPos() - 1 / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) * PaGlobal_ChatMain:getScrollSpeed(wheelScrollingTime))
          else
            poolScrollUI._list_Scroll[0]:SetControlPos(poolScrollUI._list_Scroll[0]:GetControlPos() + 1 / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) * PaGlobal_ChatMain:getScrollSpeed(wheelScrollingTime))
          end
          if 1 < poolScrollUI._list_Scroll[0]:GetControlPos() then
            poolScrollUI._list_Scroll[0]:SetControlPos(1)
          end
          if 0 > poolScrollUI._list_Scroll[0]:GetControlPos() then
            poolScrollUI._list_Scroll[0]:SetControlPos(0)
          end
          local index = math.floor((1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1))
          if 0 == index then
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = (1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) % 1
          else
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = ((1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) - index) % 1
          end
          PaGlobal_ChatMain._preScrollControlPos[panelIndex] = poolScrollUI._list_Scroll[0]:GetControlPos()
          PaGlobal_ChatMain._srollPosition[panelIndex] = index
          PaGlobal_ChatMain._scroll_BTNPos[panelIndex] = poolScrollUI._list_Scroll[0]:GetControlPos()
        end
        PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
      elseif isActivePanel then
        if PaGlobal_ChatMain._scrollIndex == panelIndex and PaGlobal_ChatMain._issmoothWheelscroll then
          local poolScrollUI = PaGlobal_ChatMain:getPool(drawPanelIndex)
          if PaGlobal_ChatMain._isUpDown then
            poolScrollUI._list_Scroll[0]:SetControlPos(poolScrollUI._list_Scroll[0]:GetControlPos() - 1 / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) * PaGlobal_ChatMain:getScrollSpeed(wheelScrollingTime))
          else
            poolScrollUI._list_Scroll[0]:SetControlPos(poolScrollUI._list_Scroll[0]:GetControlPos() + 1 / (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) * PaGlobal_ChatMain:getScrollSpeed(wheelScrollingTime))
          end
          if 1 < poolScrollUI._list_Scroll[0]:GetControlPos() then
            poolScrollUI._list_Scroll[0]:SetControlPos(1)
          end
          if 0 > poolScrollUI._list_Scroll[0]:GetControlPos() then
            poolScrollUI._list_Scroll[0]:SetControlPos(0)
          end
          local index = math.floor((1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1))
          if 0 == index then
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = (1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) % 1
          else
            PaGlobal_ChatMain._deltascrollPosy[panelIndex] = ((1 - poolScrollUI._list_Scroll[0]:GetControlPos()) * (PaGlobal_ChatMain._MAX_HISTORYCOUNT - 1) - index) % 1
          end
          PaGlobal_ChatMain._preScrollControlPos[panelIndex] = poolScrollUI._list_Scroll[0]:GetControlPos()
          PaGlobal_ChatMain._srollPosition[panelIndex] = index
          PaGlobal_ChatMain._scroll_BTNPos[panelIndex] = poolScrollUI._list_Scroll[0]:GetControlPos()
        end
        PaGlobal_ChatMain:updateChatMessage(chatPanel, panelIndex, drawPanelIndex, 0)
      end
    end
  end
end
function PaGlobal_Chat_UpdateChatPanel()
  local count = ToClient_getChattingPanelCount()
  PaGlobal_ChatMain._tabButton_PosX = 0
  for panelIndex = 0, count - 1 do
    local chatPanel = ToClient_getChattingPanel(panelIndex)
    PaGlobal_ChatMain:getPool(panelIndex):clear()
    if chatPanel:isOpen() then
      PaGlobal_ChatMain:update(chatPanel, panelIndex)
    end
  end
end
function PaGlobal_Chat_UpdatTopClipingPanel(panelIndex, addClipSizeY)
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_Chat_UpdatTopClipingPanel panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= addClipSizeY, "PaGlobal_Chat_UpdatTopClipingPanel addClipSizeY nil", "\236\178\156\235\167\140\234\184\176")
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  if false == chatPanel:isOpen() then
    return
  end
  local chatUI = PaGlobal_ChatMain:getPool(panelIndex)
  chatUI._list_PanelBG[0]:SetRectClipOnArea(float2(0, addClipSizeY), float2(chatUI._list_PanelBG[0]:GetSizeX(), chatUI._list_PanelBG[0]:GetSizeY()))
  chatUI._list_PanelBG[0]:SetSize(chatUI._list_PanelBG[0]:GetSizeX(), chatUI._list_PanelBG[0]:GetSizeY() - addClipSizeY)
end
