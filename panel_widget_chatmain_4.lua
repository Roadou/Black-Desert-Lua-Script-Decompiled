local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_CT = CppEnums.ChatType
local UI_CST = CppEnums.ChatSystemType
function PaGlobal_ChatMain:getShowEmoticonInfo(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getShowEmoticonInfo panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  return PaGlobal_ChatMain._emoticonInfo[panelIndex]
end
function PaGlobal_ChatMain:resetEmoticonInfo(panelIndex)
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:resetEmoticonInfo panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  PaGlobal_ChatMain._emoticonInfo[panelIndex] = nil
end
function PaGlobal_ChatMain:convertFromItemGradeColor(nameColorGrade)
  UI.ASSERT_NAME(nil ~= nameColorGrade, "PaGlobal_ChatMain:convertFromItemGradeColor nameColorGrade nil", "\236\178\156\235\167\140\234\184\176")
  if 0 == nameColorGrade then
    return 4293388263
  elseif 1 == nameColorGrade then
    return 4288921664
  elseif 2 == nameColorGrade then
    return 4283938018
  elseif 3 == nameColorGrade then
    return 4293904710
  elseif 4 == nameColorGrade then
    return 4294929482
  else
    return UI_color.C_FFFFFFFF
  end
end
function PaGlobal_ChatMain:createChattingContent(chattingMessage, poolCurrentUI, PosY, messageIndex, panelIndex, deltascrollPosy, cacheSimpleUI, chattingUpTime, skipCount)
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:createChattingContent chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:createChattingContent poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= PosY, "PaGlobal_ChatMain:createChattingContent PosY nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= messageIndex, "PaGlobal_ChatMain:createChattingContent messageIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:createChattingContent panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= deltascrollPosy, "PaGlobal_ChatMain:createChattingContent deltascrollPosy nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= cacheSimpleUI, "PaGlobal_ChatMain:createChattingContent cacheSimpleUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingUpTime, "PaGlobal_ChatMain:createChattingContent chattingUpTime nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= skipCount, "PaGlobal_ChatMain:createChattingContent skipCount nil", "\236\178\156\235\167\140\234\184\176")
  if nil == skipCount then
    skipCount = 0
  end
  if skipCount > 0 then
    local lineCount = PaGlobal_ChatMain:getLineSizeCheck(chattingMessage, poolCurrentUI, PosY, messageIndex, panelIndex)
    if skipCount >= lineCount then
      skipCount = skipCount - lineCount
      poolCurrentUI:drawclear()
      return PosY, skipCount
    end
  end
  local SIZEY_OFFSET = 0
  local POSY_OFFSET = -1
  local panelSizeX = poolCurrentUI._list_PanelBG[0]:GetSizeX() - 20
  local panelSizeY = poolCurrentUI._list_PanelBG[0]:GetSizeY()
  local sender = chattingMessage:getSender(ToClient_getChatNameType())
  local chatType = chattingMessage.chatType
  local noticeType = chattingMessage.noticeType
  local isGameManager = chattingMessage.isGameManager
  if true == _ContentsGroup_RenewUI_Chatting and nil ~= panelIndex then
    panelIndex = panelIndex - 1
  end
  local msgColor = Chatting_MessageColor(chatType, noticeType, panelIndex)
  local msg = PaGlobal_ChatMain:getChattingMessage(panelIndex, chattingMessage)
  local msgData
  local isLinkedItem = chattingMessage:isLinkedItem()
  local isLinkedGuild = chattingMessage:isLinkedGuild()
  local isLinkedWebSite = chattingMessage:isLinkedWebsite()
  local isLinkedMentalCard = chattingMessage:isLinkedMentalCard()
  local chatting_Icon = poolCurrentUI:newChattingIcon()
  local recommand_Icon = poolCurrentUI:newRecommandIcon()
  local chatting_GuildMark = poolCurrentUI:newChattingGuildMark()
  local chatting_sender = poolCurrentUI:newChattingSender(messageIndex)
  local isDev = ToClient_IsDevelopment()
  local chatting_contents = {}
  local emoticonCount = chattingMessage:getEmoticonCount()
  local chattingatCount = chattingMessage:getChattingAtCount()
  local reciver = getSelfPlayer():getName()
  local itemGradeType = chattingMessage:getItemGradeType()
  local itemGradeColor = PaGlobal_ChatMain:convertFromItemGradeColor(itemGradeType)
  local itemIconPath = chattingMessage:getIconPath()
  local mentalCardKey = chattingMessage:getMantalCardKey()
  local conetentsSizeY = chatting_sender:GetSizeY() + SIZEY_OFFSET
  if true == isGameManager and not isDev then
    msgColor = 4282515258
  end
  if nil == chatting_sender then
    return PosY
  end
  local deltaPosY = -chatting_sender:GetSizeY() * deltascrollPosy
  if 0 ~= chattingUpTime then
    deltaPosY = -chatting_sender:GetSizeY() + chatting_sender:GetSizeY() * chattingUpTime * 5
  end
  PaGlobal_ChatMain.guildPromoteList = Array.new()
  local contentsList = Array.new()
  function contentsList:setShowAll(isShow)
    UI.ASSERT_NAME(nil ~= isShow, "contentsList:setShowAll isShow nil", "\236\178\156\235\167\140\234\184\176")
    local count = contentsList:length()
    for i = 1, count do
      contentsList[i]:SetShow(isShow)
      contentsList[i] = nil
    end
  end
  if chatType == CppEnums.ChatType.Private and false == chattingMessage.isMe then
    if 0 == messageIndex then
      ChatInput_SetLastWhispersUserId(sender)
    end
    if 1 > Int64toInt32(getUtc64() - chattingMessage._time_s64) then
      local isSoundAlert = true
      if ChatInput_GetLastWhispersUserId() == sender then
        if getTickCount32() - ChatInput_GetLastWhispersTick() > 1000 then
          ChatInput_SetLastWhispersTick()
        else
          isSoundAlert = false
        end
      else
        ChatInput_SetLastWhispersTick()
      end
      if isSoundAlert and isPhotoMode() then
        audioPostEvent_SystemUi(8, 14)
        _AudioPostEvent_SystemUiForXBOX(8, 14)
      end
    end
  end
  chatting_Icon:SetShow(true)
  PaGlobal_ChatMain:setChattingIcon(chatType, chatting_Icon, panelIndex)
  local chat_contentAddPosX = 0
  local senderStr = PaGlobal_ChatMain:getSenderString(chattingMessage)
  chat_contentAddPosX = chat_contentAddPosX + PaGlobal_ChatMain:setchattingSender(chatType, chatting_sender, chatting_Icon, senderStr, msgColor, recommand_Icon, chattingMessage)
  chatting_sender:SetShow(true)
  PaGlobal_ChatMain._linkedGuildCache = nil
  local guildMarkAdjY = 2
  local guildMarkSize = PaGlobal_ChatMain:setChattingGuildMark(chatting_GuildMark, chattingMessage, chatting_sender, true)
  local contentindex = 1
  local textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
  local textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
  local msgstartindex = 0
  local chattingatNum = 1
  local isChattingAt = false
  if 0 ~= chattingatCount then
    isChattingAt = true
  end
  local j = 1
  local isWhile = false
  local checkitemwebat = 0
  local chatEmoticon = {}
  local itemContents = {}
  local isSkip = false
  local emoticonSize = 25
  if 0 ~= emoticonCount then
    local emoNum = 1
    while emoticonCount >= emoNum do
      local emoticonindex = chattingMessage:getEmoticonIndex(emoNum - 1)
      local emoticonKey = chattingMessage:getEmoticonKey(emoNum - 1)
      local isItemEmoticon = PaGlobalFunc_isItemEmticon(emoticonKey)
      itemContents[contentindex] = false
      if msgstartindex == emoticonindex then
        if true == isLinkedGuild and 3 == contentindex then
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(true)
          contentsList:push_back(chatting_contents[contentindex])
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          chatting_contents[contentindex]:SetSize(1, conetentsSizeY)
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText("")
          chatting_contents[contentindex]:SetPosY(PosY - chatting_contents[contentindex]:GetSizeY() - deltaPosY)
          contentindex = contentindex + 1
        end
        if true == isItemEmoticon then
          chatting_contents[contentindex] = poolCurrentUI:newChattingEmoticon()
        else
          chatEmoticon[contentindex] = true
          local emoticonControl = poolCurrentUI:newChattingNewEmoticon()
          if nil == emoticonControl then
            break
          end
          chatting_contents[contentindex] = emoticonControl
        end
        if isItemEmoticon and nil ~= itemIconPath then
          if false == isLinkedMentalCard then
            chatting_contents[contentindex]:ChangeTextureInfoNameAsync("Icon/" .. itemIconPath)
          else
            chatting_contents[contentindex]:ChangeTextureInfoNameAsync(itemIconPath)
          end
          itemContents[contentindex] = true
        elseif isItemEmoticon then
          chatting_contents[contentindex]:ChangeTextureInfoNameAsync(chattingMessage:getEmoticonPath(emoNum - 1))
          local startX = chattingMessage:getEmoticonUV(emoNum - 1).x
          local startY = chattingMessage:getEmoticonUV(emoNum - 1).y
          local sizeX = chattingMessage:getEmoticonSize(emoNum - 1).x
          local sizeY = chattingMessage:getEmoticonSize(emoNum - 1).y
          chatting_contents[contentindex]:getBaseTexture():setUV(startX, startY, startX + sizeX, startY + sizeY)
          chatting_contents[contentindex]:setRenderTexture(chatting_contents[contentindex]:getBaseTexture())
          itemContents[contentindex] = true
        else
          local emoticonIndex = poolCurrentUI:getCurrentEmoticonIndex()
          if false == chattingMessage:isShowEmoticon(panelIndex) then
            local tempInfo = {}
            tempInfo._panelIndex = panelIndex
            tempInfo._emoticonIndex = emoticonIndex
            tempInfo._key = tostring(emoticonKey)
            PaGlobal_ChatMain._emoticonInfo[panelIndex] = tempInfo
            chattingMessage:setShowEmoticon(panelIndex, true)
          end
          chatting_contents[contentindex]:ChangeTextureInfoNameAsync(chattingMessage:getEmoticonPath(emoNum - 1))
          chatting_contents[contentindex]:addInputEvent("Mouse_On", "HandleOn_ChattingEmoticon(" .. panelIndex .. "," .. emoticonIndex .. "," .. tostring(emoticonKey) .. ", true, false)")
          chatting_contents[contentindex]:addInputEvent("Mouse_Out", "HandleOn_ChattingEmoticon(" .. panelIndex .. "," .. emoticonIndex .. "," .. tostring(emoticonKey) .. ", false, false)")
          chatting_contents[contentindex]:addInputEvent("Mouse_UpScroll", "Chatting_ScrollEvent( " .. panelIndex .. ", true )")
          chatting_contents[contentindex]:addInputEvent("Mouse_DownScroll", "Chatting_ScrollEvent( " .. panelIndex .. ", false )")
        end
        contentsList:push_back(chatting_contents[contentindex])
        j = 1
        isWhile = false
        textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
        textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
          isWhile = true
          textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
          textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
          if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
            break
          end
          j = j + 1
        end
        if textStaticSizeX <= 0 or isWhile == false then
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        end
        if isItemEmoticon then
          chatting_contents[contentindex]:SetSize(conetentsSizeY, conetentsSizeY)
        else
          chatting_contents[contentindex]:SetSize(emoticonSize, emoticonSize)
        end
        chatting_contents[contentindex]:SetPosX(textStaticPosX)
        emoNum = emoNum + 1
        contentindex = contentindex + 1
      elseif false == isChattingAt and false == isLinkedItem and false == isLinkedGuild and false == isLinkedWebSite and false == isLinkedMentalCard then
        local msgData = string.sub(msg, msgstartindex + 1, emoticonindex)
        local msgDataLen = string.len(msgData)
        local checkmsg = {}
        local ispreEmoticonIndex = contentindex
        while msgDataLen > 0 do
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetFontColor(msgColor)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          contentsList:push_back(chatting_contents[contentindex])
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          j = 1
          isWhile = false
          while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
            isWhile = true
            textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
            textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
            if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
              break
            end
            j = j + 1
          end
          if 0 == textStaticSizeX or isWhile == false then
            textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
            textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          end
          chatting_contents[contentindex]:SetSize(textStaticSizeX, conetentsSizeY)
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText(checkmsg)
          chatting_contents[contentindex]:SetPosY(PosY - chatting_contents[contentindex]:GetSizeY() - deltaPosY)
          contentindex = contentindex + 1
        end
        if ispreEmoticonIndex ~= contentindex then
          chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), conetentsSizeY)
        else
          chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), conetentsSizeY)
        end
        msgstartindex = emoticonindex
      else
        checkitemwebat = 0
        local drawstart = msgstartindex
        local drawend = emoticonindex
        checkitemwebat, drawend, chattingatNum = PaGlobal_ChatMain:getCheckItemWebAt(chattingMessage, chattingatNum, drawstart, drawend)
        if emoticonindex ~= drawend then
          drawend = drawend + 1
        end
        local msgData = string.sub(msg, msgstartindex + 1, drawend)
        local msgDataLen = string.len(msgData)
        local checkmsg = {}
        local ispreEmoticonIndex = contentindex
        local msgCheckSender = string.sub(msgData, 2, msgDataLen)
        if reciver ~= msgCheckSender and 3 == checkitemwebat then
          checkitemwebat = 0
        end
        if 3 == checkitemwebat and chatType == CppEnums.ChatType.Private and false == chattingMessage.isMe then
          checkitemwebat = 0
        end
        if UI_CT.Guild == chatType and 3 == checkitemwebat and chattingMessage:getIsChattingAtSound() then
          audioPostEvent_SystemUi(99, 1)
          _AudioPostEvent_SystemUiForXBOX(99, 1)
          chattingMessage:setIsChattingAtSound(false)
        end
        while msgDataLen > 0 do
          if 0 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
            chatting_contents[contentindex]:SetFontColor(msgColor)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          elseif 1 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedItem(messageIndex)
            chatting_contents[contentindex]:SetFontColor(itemGradeColor)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(false)
          elseif 2 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedWebSite(messageIndex)
            chatting_contents[contentindex]:SetFontColor(UI_color.C_FF00C0D7)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(false)
          elseif 3 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingAt(messageIndex)
            chatting_contents[contentindex]:SetFontColor(UI_color.C_FFF601FF)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(false)
          elseif 4 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedGuild(messageIndex)
            chatting_contents[contentindex]:SetFontColor(msgColor)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(false)
            if nil ~= PaGlobal_ChatMain.guildPromoteList then
              PaGlobal_ChatMain.guildPromoteList:push_back(chatting_contents[contentindex])
            end
          elseif 5 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
            chatting_contents[contentindex]:SetFontColor(UI_color.C_FFFFFFFF)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:addInputEvent("Mouse_On", "HandleEventOnOut_MentalCard(" .. contentindex .. ",true )")
            chatting_contents[contentindex]:addInputEvent("Mouse_Out", "HandleEventOnOut_MentalCard(" .. contentindex .. ",false )")
            chatting_contents[contentindex]:addInputEvent("Mouse_LUp", "HandleEventLUp_MentalCard(" .. chattingMessage:getMantalCardKey() .. ")")
            chatting_contents[contentindex]:SetIgnore(false)
          end
          contentsList:push_back(chatting_contents[contentindex])
          local j = 1
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          j = 1
          isWhile = false
          while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
            isWhile = true
            textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
            textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
            if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
              break
            end
            j = j + 1
          end
          if 0 == textStaticSizeX or isWhile == false then
            textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
            textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          end
          chatting_contents[contentindex]:SetSize(textStaticSizeX, conetentsSizeY)
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText(checkmsg)
          contentindex = contentindex + 1
        end
        if nil ~= chatting_contents[contentindex - 1] then
          if ispreEmoticonIndex ~= contentindex then
            chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), conetentsSizeY)
          else
            chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), conetentsSizeY)
          end
        end
        msgstartindex = drawend
      end
    end
    chatting_contents, contentindex = PaGlobal_ChatMain:createContentWithMsgLength(reciver, poolCurrentUI, chatType, chattingMessage, isChattingAt, contentindex, chatting_contents, chatting_Icon, chatting_sender, msg, msgColor, msgstartindex, panelSizeX, chattingatNum, messageIndex, itemGradeColor, conetentsSizeY, recommand_Icon, chatting_GuildMark)
    local nowLineImoticon = false
    local nowLine = contentindex - 1
    local maxSizeY = 0
    for index = contentindex - 1, 1, -1 do
      if chatEmoticon[index] then
        nowLineImoticon = true
      end
      maxSizeY = 0
      if nowLineImoticon then
        local index2 = 1
        while nowLine >= index2 or index >= index2 do
          if 1 == index then
            if chatEmoticon[index2] then
              local tempSize = emoticonSize * 0.2
              chatting_contents[index2]:SetPosY(PosY - chatting_contents[index]:GetSizeY() - tempSize - deltaPosY)
            else
              chatting_contents[index2]:SetPosY(PosY - chatting_contents[index]:GetSizeY() - deltaPosY)
            end
          elseif chatEmoticon[index2] then
            chatting_contents[index2]:SetPosY(PosY - chatting_contents[index]:GetSizeY() - deltaPosY)
          else
            local tempSize = emoticonSize * 0.2
            chatting_contents[index2]:SetPosY(PosY - chatting_contents[index]:GetSizeY() + tempSize - deltaPosY)
          end
          if false == itemContents[contentindex] then
            chatting_contents[index2]:SetSize(chatting_contents[index2]:GetSizeX(), emoticonSize)
          end
          index2 = index2 + 1
        end
      else
        chatting_contents[index]:SetPosY(PosY - chatting_contents[index]:GetSizeY() - deltaPosY)
      end
      maxSizeY = math.max(chatting_contents[index]:GetSizeY(), maxSizeY)
      contentsList:push_back(chatting_contents[index])
      if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[index]:GetPosX() then
        if skipCount > 0 then
          contentsList:setShowAll(false)
          skipCount = skipCount - 1
          isSkip = true
        else
          contentsList:setShowAll(true)
          PosY = PosY - maxSizeY + POSY_OFFSET
          isSkip = false
        end
        nowLine = index - 1
        nowLineImoticon = false
        if 1 ~= index then
          chatting_contents[index]:SetPosX(chatting_sender:GetTextSizeX() + chat_contentAddPosX)
        end
      end
    end
  else
    chatting_contents, contentindex = PaGlobal_ChatMain:createContentWithMsgLength(reciver, poolCurrentUI, chatType, chattingMessage, isChattingAt, contentindex, chatting_contents, chatting_Icon, chatting_sender, msg, msgColor, msgstartindex, panelSizeX, chattingatNum, messageIndex, itemGradeColor, conetentsSizeY, recommand_Icon, chatting_GuildMark)
    for index = contentindex - 1, 1, -1 do
      chatting_contents[index]:SetPosY(PosY - chatting_contents[index]:GetSizeY() - deltaPosY)
      contentsList:push_back(chatting_contents[index])
      if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[index]:GetPosX() then
        if skipCount > 0 then
          contentsList:setShowAll(false)
          skipCount = skipCount - 1
          isSkip = true
        else
          contentsList:setShowAll(true)
          PosY = PosY - chatting_contents[index]:GetSizeY() + POSY_OFFSET
          if 1 ~= index then
            chatting_contents[index]:SetPosX(chatting_sender:GetTextSizeX() + chat_contentAddPosX)
          end
          isSkip = false
        end
      end
    end
  end
  if true == ToClient_isConsole() then
    chatting_Icon:SetPosY(PosY - deltaPosY + SIZEY_OFFSET)
  else
    chatting_Icon:SetPosY(PosY - deltaPosY + SIZEY_OFFSET - POSY_OFFSET - 2)
    if true == PaGlobal_ChatMain:checkThumbsUpOpen(chatType) then
      recommand_Icon:SetPosY(PosY - deltaPosY + SIZEY_OFFSET - POSY_OFFSET - 2)
    end
  end
  chatting_sender:SetPosY(PosY - deltaPosY + SIZEY_OFFSET - POSY_OFFSET)
  chatting_GuildMark:SetPosY(PosY - deltaPosY - guildMarkAdjY)
  if UI_CT.System == chatType or UI_CT.Notice == chatType or chattingMessage.isMe then
    chatting_sender:SetIgnore(true)
  else
    chatting_sender:SetIgnore(false)
  end
  if UI_CT.Public == chatType then
    chatting_sender:SetOverFontColor(UI_color.C_FFC4BEBE)
  else
    chatting_sender:SetOverFontColor(UI_color.C_FFFFFFFF)
  end
  if 0 == emoticonCount and getEnableSimpleUI() then
    if cacheSimpleUI then
      chatting_sender:SetFontAlpha(1)
      for _, contents in ipairs(chatting_contents) do
        contents:SetFontAlpha(1)
      end
    else
      local alphaRate = math.pow(math.max(math.min(1 - (panelSizeY - PosY) / panelSizeY, 1), 0.01), 0.2)
      chatting_sender:SetFontAlpha(alphaRate)
      for _, contents in ipairs(chatting_contents) do
        contents:SetFontAlpha(alphaRate)
      end
    end
  end
  local guildPromoteCount = PaGlobal_ChatMain.guildPromoteList:length()
  if guildPromoteCount > 0 then
    for index = 1, guildPromoteCount do
      if 1 == index then
        PaGlobal_ChatMain.guildPromoteList[index]:SetPosX(PaGlobal_ChatMain.guildPromoteList[index]:GetPosX() + guildMarkSize)
        PaGlobal_ChatMain.guildPromoteList[index]:SetFontColor(UI_color.C_FF84FFF5)
      else
        PaGlobal_ChatMain.guildPromoteList[index]:SetPosX(PaGlobal_ChatMain.guildPromoteList[index]:GetPosX())
        PaGlobal_ChatMain.guildPromoteList[index]:SetFontColor(UI_color.C_FF84FFF5)
      end
    end
    PaGlobal_ChatMain.guildPromoteList = nil
  end
  if true == isSkip then
    chatting_Icon:SetShow(false)
    chatting_GuildMark:SetShow(false)
    chatting_sender:SetShow(false)
  else
    PosY = PosY - 5
  end
  return PosY, skipCount
end
function PaGlobal_ChatMain:uiPrivateChatType(chatType, chatting_Icon)
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:uiPrivateChatType chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_Icon, "PaGlobal_ChatMain:uiPrivateChatType chatting_Icon nil", "\236\178\156\235\167\140\234\184\176")
  if true == _ContentsGroup_RenewUI_Chatting then
    PaGlobalFunc_ChattingHistory_SetChatIcon(chatType, chatting_Icon)
    return
  end
  local isChatDivision = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eChatDivision)
  if UI_CT.Private == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 0, 24, 54, 48)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.Notice == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 108, 0, 162, 24)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.System == chatType then
    local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 54, 72, 108, 96)
    chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
  elseif UI_CT.World == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 0, 72, 54, 96)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.Public == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 0, 0, 54, 24)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.Party == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 0, 48, 54, 72)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.Guild == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 108, 72, 162, 96)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.WorldWithItem == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 108, 24, 162, 48)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
      chatting_Icon:SetShow(false)
    end
  elseif UI_CT.Battle == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 0, 96, 54, 120)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  elseif UI_CT.LocalWar == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 108, 48, 162, 72)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  elseif UI_CT.RolePlay == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 54, 48, 108, 72)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  elseif UI_CT.Arsha == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 54, 0, 108, 24)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  elseif UI_CT.Team == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 54, 24, 108, 48)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  elseif UI_CT.Alliance == chatType then
    if isChatDivision then
      local x1, y1, x2, y2 = setTextureUV_Func(chatting_Icon, 54, 96, 108, 120)
      chatting_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
      chatting_Icon:setRenderTexture(chatting_Icon:getBaseTexture())
    else
      chatting_Icon:SetShow(false)
      chatting_Icon:SetSize(0, chatting_Icon:GetSizeY())
    end
  end
end
function PaGlobal_ChatMain:getMessageFontColor(msg, color)
  UI.ASSERT_NAME(nil ~= msg, "PaGlobal_ChatMain:getMessageFontColor msg nil", "\236\178\156\235\167\140\234\184\176")
  local Message = msg
  if nil == color then
    local fontColor = ""
    while 0 < string.len(Message) do
      local startIdx, endIdx = string.find(Message, "<PAColor")
      if nil ~= startIdx and nil ~= endIdx then
        local tempIdx, destIdx = string.find(Message, "<PAOldColor>")
        if nil ~= tempIdx and nil ~= destIdx then
          Message = string.sub(Message, destIdx + 1, string.len(Message))
        else
          fontColor = string.sub(Message, startIdx, endIdx + 11)
          return fontColor
        end
      else
        return nil
      end
    end
    return nil
  else
    local startIdx, endIdx = string.find(Message, "<PAOldColor>")
    if nil ~= startIdx and nil ~= endIdx then
      Message = string.sub(Message, endIdx + 1, string.len(Message))
      return PaGlobal_ChatMain:getMessageFontColor(Message, nil)
    else
      return color
    end
  end
end
function PaGlobal_ChatMain:createContentWithMsgLength(reciver, poolCurrentUI, chatType, chattingMessage, isChattingAt, contentindex, chatting_contents, chatting_Icon, chatting_sender, msg, msgColor, msgstartindex, panelSizeX, chattingatNum, messageIndex, itemGradeColor, conetentsSizeY, recommand_Icon, chatting_GuildMark)
  UI.ASSERT_NAME(nil ~= reciver, "PaGlobal_ChatMain:createContentWithMsgLength reciver nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:createContentWithMsgLength poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:createContentWithMsgLength chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:createContentWithMsgLength chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isChattingAt, "PaGlobal_ChatMain:createContentWithMsgLength isChattingAt nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= contentindex, "PaGlobal_ChatMain:createContentWithMsgLength contentindex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_contents, "PaGlobal_ChatMain:createContentWithMsgLength chatting_contents nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_Icon, "PaGlobal_ChatMain:createContentWithMsgLength chatting_Icon nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_sender, "PaGlobal_ChatMain:createContentWithMsgLength chatting_sender nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= msg, "PaGlobal_ChatMain:createContentWithMsgLength msg nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= msgColor, "PaGlobal_ChatMain:createContentWithMsgLength msgColor nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= msgstartindex, "PaGlobal_ChatMain:createContentWithMsgLength msgstartindex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelSizeX, "PaGlobal_ChatMain:createContentWithMsgLength panelSizeX nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingatNum, "PaGlobal_ChatMain:createContentWithMsgLength chattingatNum nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= messageIndex, "PaGlobal_ChatMain:createContentWithMsgLength messageIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= itemGradeColor, "PaGlobal_ChatMain:createContentWithMsgLength itemGradeColor nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= conetentsSizeY, "PaGlobal_ChatMain:createContentWithMsgLength conetentsSizeY nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= recommand_Icon, "PaGlobal_ChatMain:createContentWithMsgLength recommand_Icon nil", "\236\158\132\236\136\152\237\152\132")
  UI.ASSERT_NAME(nil ~= chatting_GuildMark, "PaGlobal_ChatMain:createContentWithMsgLength chatting_GuildMark nil", "\235\176\149\236\132\184\236\167\132")
  local isLinkedItem = chattingMessage:isLinkedItem()
  local isLinkedGuild = chattingMessage:isLinkedGuild()
  local isLinkedWebSite = chattingMessage:isLinkedWebsite()
  local isLinkedMentalCard = chattingMessage:isLinkedMentalCard()
  local j = 1
  local isWhile = false
  local textStaticSizeX = 0
  local textStaticPosX = 0
  local chat_contentAddPosX = 0
  if chatting_Icon:GetShow() then
    chat_contentAddPosX = 15 + chatting_Icon:GetSizeX()
  else
    chat_contentAddPosX = 10
  end
  chat_contentAddPosX = chat_contentAddPosX + PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon)
  if true == ToClient_getUseHarfBuzz() then
    isChattingAt = false
  end
  while msgstartindex < string.len(msg) do
    if false == isChattingAt and false == isLinkedItem and false == isLinkedGuild and false == isLinkedWebSite and false == isLinkedMentalCard then
      local msgData = string.sub(msg, msgstartindex + 1, string.len(msg))
      local msgDataLen = string.len(msgData)
      local checkmsg = {}
      local ispreEmoticonIndex = contentindex
      local fontColor
      while msgDataLen > 0 do
        chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
        chatting_contents[contentindex]:SetFontColor(msgColor)
        chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
        chatting_contents[contentindex]:SetShow(true)
        chatting_contents[contentindex]:SetIgnore(true)
        textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
        textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        j = 1
        isWhile = false
        while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
          isWhile = true
          textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
          textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
          if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
            break
          end
          j = j + 1
        end
        if 0 == textStaticSizeX or isWhile == false then
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        end
        chatting_contents[contentindex]:SetSize(textStaticSizeX, conetentsSizeY)
        chatting_contents[contentindex]:SetPosX(textStaticPosX)
        checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
        if isChangeFontSize() then
          chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
        end
        if true == ToClient_IsDevelopment() or true == isGameServiceTypeTurkey() then
          if true == ToClient_isApplyHarfBuzzByChatType(chatType) then
            chatting_contents[contentindex]:SetUseHarfBuzz(true)
          else
            chatting_contents[contentindex]:SetUseHarfBuzz(false)
          end
        else
          chatting_contents[contentindex]:SetUseHarfBuzz(false)
        end
        chatting_contents[contentindex]:SetText(checkmsg)
        if nil ~= fontColor then
          chatting_contents[contentindex]:SetText(string.format("%s%s", fontColor, checkmsg))
        else
          chatting_contents[contentindex]:SetText(checkmsg)
        end
        fontColor = PaGlobal_ChatMain:getMessageFontColor(checkmsg, fontColor)
        contentindex = contentindex + 1
      end
      if ispreEmoticonIndex ~= contentindex then
        chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), conetentsSizeY)
      else
        chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), conetentsSizeY)
      end
      msgstartindex = string.len(msg)
    else
      checkitemwebat = 0
      local drawstart = msgstartindex
      local drawend = string.len(msg)
      checkitemwebat, drawend, chattingatNum = PaGlobal_ChatMain:getCheckItemWebAt(chattingMessage, chattingatNum, drawstart, drawend)
      drawend = drawend + 1
      local msgData = string.sub(msg, msgstartindex + 1, drawend)
      local msgDataLen = string.len(msgData)
      local checkmsg = {}
      local ispreEmoticonIndex = contentindex
      local msgCheckSender = string.sub(msgData, 2, msgDataLen)
      if reciver ~= msgCheckSender and 3 == checkitemwebat then
        checkitemwebat = 0
      end
      if 3 == checkitemwebat and chatType == CppEnums.ChatType.Private and false == chattingMessage.isMe then
        checkitemwebat = 0
      end
      if UI_CT.Guild == chatType and 3 == checkitemwebat and chattingMessage:getIsChattingAtSound() then
        audioPostEvent_SystemUi(99, 1)
        _AudioPostEvent_SystemUiForXBOX(99, 1)
        chattingMessage:setIsChattingAtSound(false)
      end
      while msgDataLen > 0 do
        if 0 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetFontColor(msgColor)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetShow(true)
          chatting_contents[contentindex]:SetIgnore(true)
        elseif 1 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedItem(messageIndex)
          chatting_contents[contentindex]:SetFontColor(itemGradeColor)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(false)
        elseif 2 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedWebSite(messageIndex)
          chatting_contents[contentindex]:SetFontColor(UI_color.C_FF00C0D7)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(false)
        elseif 3 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingAt(messageIndex)
          chatting_contents[contentindex]:SetFontColor(UI_color.C_FFF601FF)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(false)
        elseif 4 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedGuild(messageIndex)
          chatting_contents[contentindex]:SetFontColor(msgColor)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(false)
          if nil ~= PaGlobal_ChatMain.guildPromoteList then
            PaGlobal_ChatMain.guildPromoteList:push_back(chatting_contents[contentindex])
          end
        elseif 5 == checkitemwebat then
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetFontColor(UI_color.C_FFFFFFFF)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:addInputEvent("Mouse_On", "HandleEventOnOut_MentalCard(" .. contentindex .. ",true )")
          chatting_contents[contentindex]:addInputEvent("Mouse_Out", "HandleEventOnOut_MentalCard(" .. contentindex .. ",false )")
          chatting_contents[contentindex]:addInputEvent("Mouse_LUp", "HandleEventLUp_MentalCard(" .. chattingMessage:getMantalCardKey() .. ")")
          chatting_contents[contentindex]:SetShow(true)
          chatting_contents[contentindex]:SetIgnore(false)
        end
        textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX() - chatting_GuildMark:GetSizeX()
        textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        j = 1
        isWhile = false
        while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
          isWhile = true
          textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
          textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
          if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
            break
          end
          j = j + 1
        end
        if 0 == textStaticSizeX or isWhile == false then
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX() - chatting_GuildMark:GetSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        end
        chatting_contents[contentindex]:SetSize(textStaticSizeX, conetentsSizeY)
        chatting_contents[contentindex]:SetPosX(textStaticPosX)
        checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
        if isChangeFontSize() then
          chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
        end
        chatting_contents[contentindex]:SetText(checkmsg)
        contentindex = contentindex + 1
      end
      if ispreEmoticonIndex ~= contentindex then
        chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), conetentsSizeY)
      else
        chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), chatting_sender:GetSizeY())
      end
      msgstartindex = drawend
    end
  end
  return chatting_contents, contentindex
end
function HandleEventOnOut_MentalCard(index, isShow)
  UI.ASSERT_NAME(nil ~= index, "HandleEventOnOut_MentalCard index nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= isShow, "HandleEventOnOut_MentalCard isShow nil", "\236\178\156\235\167\140\234\184\176")
  if false == isShow then
    TooltipSimple_Hide()
  end
  if true == Panel_WorldMap:GetShow() then
    return
  end
  local control = PaGlobal_getChattingContentsByIndex(index)
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_CHATTING_MENTALCARD_TOOLTIP_NAME")
  local desc
  TooltipSimple_Show(control, name, desc)
end
function HandleEventLUp_MentalCard(mentalCardKey)
  UI.ASSERT_NAME(nil ~= mentalCardKey, "HandleEventLUp_MentalCard mentalCardKey nil", "\236\178\156\235\167\140\234\184\176")
  if false == _ContentsGroup_RenewUI_Knowledge then
    Panel_Knowledge_Show()
    Panel_Knowledge_SelectAnotherCard(mentalCardKey)
  else
    PaGlobalFunc_Window_Knowledge_Show()
  end
end
function PaGlobal_ChatMain:getTextLimitWidth(chatting_contents, msgOrigin)
  UI.ASSERT_NAME(nil ~= chatting_contents, "PaGlobal_ChatMain:getTextLimitWidth chatting_contents nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= msgOrigin, "PaGlobal_ChatMain:getTextLimitWidth msgOrigin nil", "\236\178\156\235\167\140\234\184\176")
  if nil == chatting_contents or nil == msgOrigin then
    return
  end
  local msg = chatting_contents:GetTextLimitWidth(msgOrigin)
  if string.len(msg) < string.len(msgOrigin) then
    local msgStr = string.sub(msgOrigin, string.len(msg) + 1, string.len(msgOrigin))
    local msgLen = string.len(msgStr)
    return msg, msgStr, msgLen
  end
  return msg, msgOrigin, 0
end
function PaGlobal_ChatMain:getCheckItemWebAt(chattingMessage, chattingatNum, drawstart, drawend)
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:getCheckItemWebAt chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingatNum, "PaGlobal_ChatMain:getCheckItemWebAt chattingatNum nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawstart, "PaGlobal_ChatMain:getCheckItemWebAt drawstart nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= drawend, "PaGlobal_ChatMain:getCheckItemWebAt drawend nil", "\236\178\156\235\167\140\234\184\176")
  local isLinkedItem = chattingMessage:isLinkedItem()
  local isLinkedGuild = chattingMessage:isLinkedGuild()
  local isLinkedWebSite = chattingMessage:isLinkedWebsite()
  local isLinkedMentalCard = chattingMessage:isLinkedMentalCard()
  local chattingatCount = chattingMessage:getChattingAtCount()
  local atStart = chattingMessage:getChattingAtStartIndex(chattingatNum - 1)
  local atEnd = chattingMessage:getChattingAtEndIndex(chattingatNum - 1)
  local checkFinishItemWebSite = false
  local isChattingAt = false
  if 0 ~= chattingatCount then
    isChattingAt = true
  end
  if isLinkedItem then
    checkFinishItemWebSite = true
  end
  if isLinkedGuild then
    checkFinishItemWebSite = true
  end
  if isLinkedWebSite then
    checkFinishItemWebSite = true
  end
  local checkitemwebat = 0
  if isLinkedItem then
    local LinkeditemStart = chattingMessage:getLinkedItemStartIndex()
    local LinkeditemEnd = chattingMessage:getLinkedItemEndIndex()
    if isChattingAt and chattingatNum <= chattingatCount then
      if atStart > LinkeditemStart and checkFinishItemWebSite then
        checkitemwebat = 1
      else
        checkitemwebat = 3
      end
    else
      checkitemwebat = 1
    end
    if 1 == checkitemwebat then
      if drawstart <= LinkeditemStart and drawend >= LinkeditemEnd then
        if drawstart == LinkeditemStart then
          drawend = LinkeditemEnd - 1
          checkFinishItemWebSite = false
        else
          drawend = LinkeditemStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    elseif 3 == checkitemwebat then
      if drawstart <= atStart and atEnd <= drawend then
        if drawstart == atStart then
          drawend = atEnd - 1
          chattingatNum = chattingatNum + 1
        else
          drawend = atStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    end
  elseif isLinkedGuild then
    local LinkedguildStart = chattingMessage:getLinkedGuildStartIndex()
    local LinkedguildEnd = chattingMessage:getLinkedGuildEndIndex()
    if isChattingAt and chattingatCount >= chattingatNum then
      if atStart > LinkedguildStart and checkFinishItemWebSite then
        checkitemwebat = 4
      else
        checkitemwebat = 3
      end
    else
      checkitemwebat = 4
    end
    if 4 == checkitemwebat then
      if drawstart <= LinkedguildStart and drawend >= LinkedguildEnd then
        if drawstart == LinkedguildStart then
          drawend = LinkedguildEnd - 1
          checkFinishItemWebSite = false
        else
          drawend = LinkedguildStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    elseif 3 == checkitemwebat then
      if drawstart <= atStart and atEnd <= drawend then
        if drawstart == atStart then
          drawend = atEnd - 1
          chattingatNum = chattingatNum + 1
        else
          drawend = atStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    end
  elseif isLinkedWebSite then
    local LinkedwebStart = chattingMessage:getLinkedWebsiteStartIndex()
    local LinkedwebEnd = chattingMessage:getLinkedWebsiteEndIndex()
    if isChattingAt and chattingatCount >= chattingatNum then
      if atStart > LinkedwebStart and checkFinishItemWebSite then
        checkitemwebat = 2
      else
        checkitemwebat = 3
      end
    else
      checkitemwebat = 2
    end
    if 2 == checkitemwebat then
      if drawstart <= LinkedwebStart and drawend >= LinkedwebEnd then
        if drawstart == LinkedwebStart then
          drawend = LinkedwebEnd - 1
          checkFinishItemWebSite = false
        else
          drawend = LinkedwebStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    elseif 3 == checkitemwebat then
      if drawstart <= atStart and atEnd <= drawend then
        if drawstart == atStart then
          drawend = atEnd - 1
          chattingatNum = chattingatNum + 1
        else
          drawend = atStart - 1
          checkitemwebat = 0
        end
      else
        checkitemwebat = 0
      end
    end
  elseif isChattingAt and chattingatCount >= chattingatNum then
    if drawstart <= atStart and atEnd <= drawend then
      if drawstart == atStart then
        drawend = atEnd - 1
        checkitemwebat = 3
        chattingatNum = chattingatNum + 1
      else
        drawend = atStart - 1
        checkitemwebat = 0
      end
    else
      checkitemwebat = 0
    end
  elseif isLinkedMentalCard then
    checkitemwebat = 5
  end
  if 3 == checkitemwebat and chattingMessage.isMe then
    checkitemwebat = 0
  end
  return checkitemwebat, drawend, chattingatNum
end
function PaGlobal_ChatMain:getLineSizeCheck(chattingMessage, poolCurrentUI, PosY, messageIndex, panelIndex)
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:getLineSizeCheck chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= poolCurrentUI, "PaGlobal_ChatMain:getLineSizeCheck poolCurrentUI nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= PosY, "PaGlobal_ChatMain:getLineSizeCheck PosY nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= messageIndex, "PaGlobal_ChatMain:getLineSizeCheck messageIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getLineSizeCheck panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  local panelSizeX = poolCurrentUI._list_PanelBG[0]:GetSizeX() - 20
  local panelSizeY = poolCurrentUI._list_PanelBG[0]:GetSizeY()
  local emoticonCount = chattingMessage:getEmoticonCount()
  local chatType = chattingMessage.chatType
  local isLinkedItem = chattingMessage:isLinkedItem()
  local isLinkedGuild = chattingMessage:isLinkedGuild()
  local isLinkedWebSite = chattingMessage:isLinkedWebsite()
  local isLinkedMentalCard = chattingMessage:isLinkedMentalCard()
  local chatting_Icon = poolCurrentUI:newChattingIcon()
  local recommand_Icon = poolCurrentUI:newRecommandIcon()
  local chatting_GuildMark = poolCurrentUI:newChattingGuildMark()
  local chatting_sender = poolCurrentUI:newChattingSender(0)
  local chatting_contents = {}
  local msg = PaGlobal_ChatMain:getChattingMessage(panelIndex, chattingMessage)
  local reciver = getSelfPlayer():getName()
  PaGlobal_ChatMain:setChattingIcon(chatType, chatting_Icon, panelIndex)
  local chat_contentAddPosX = 0
  local senderStr = PaGlobal_ChatMain:getSenderString(chattingMessage)
  chat_contentAddPosX = chat_contentAddPosX + PaGlobal_ChatMain:setchattingSender(chatType, chatting_sender, chatting_Icon, senderStr, 0, recommand_Icon, chattingMessage)
  local guildMarkAdjY = 2
  local guildMarkSize = PaGlobal_ChatMain:setChattingGuildMark(chatting_GuildMark, chattingMessage, chatting_sender, false)
  local contentindex = 1
  local textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
  local textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
  local msgstartindex = 0
  local chattingatNum = 1
  local isChattingAt = false
  local j = 1
  local isWhile = false
  local checkitemwebat = 0
  local emoticonContentIndex = -1
  local chatEmoticon = {}
  local lineCount = 0
  if 0 ~= emoticonCount then
    local emoNum = 1
    while emoticonCount >= emoNum do
      local emoticonindex = chattingMessage:getEmoticonIndex(emoNum - 1)
      local emoticonKey = chattingMessage:getEmoticonKey(emoNum - 1)
      local isItemEmoticon = PaGlobalFunc_isItemEmticon(emoticonKey)
      if msgstartindex == emoticonindex then
        if true == isLinkedGuild and 3 == contentindex then
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          chatting_contents[contentindex]:SetIgnore(true)
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          chatting_contents[contentindex]:SetSize(1, chatting_sender:GetSizeY())
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText("")
          contentindex = contentindex + 1
        end
        if true == isItemEmoticon then
          chatting_contents[contentindex] = poolCurrentUI:newChattingEmoticon()
        else
          chatEmoticon[contentindex] = true
          local emoticonControl = poolCurrentUI:newChattingNewEmoticon()
          if nil == emoticonControl then
            break
          end
          chatting_contents[contentindex] = emoticonControl
        end
        j = 1
        isWhile = false
        textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
        textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
          isWhile = true
          textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
          textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
          if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
            break
          end
          j = j + 1
        end
        if textStaticSizeX <= 0 or isWhile == false then
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
        end
        if isItemEmoticon then
          chatting_contents[contentindex]:SetSize(chatting_sender:GetSizeY() + 4, chatting_sender:GetSizeY() + 4)
        else
          chatting_contents[contentindex]:SetSize(26, 26)
        end
        chatting_contents[contentindex]:SetPosX(textStaticPosX)
        emoNum = emoNum + 1
        contentindex = contentindex + 1
      elseif false == isChattingAt and false == isLinkedItem and false == isLinkedGuild and false == isLinkedWebSite and false == isLinkedMentalCard then
        local msgData = string.sub(msg, msgstartindex + 1, emoticonindex)
        local msgDataLen = string.len(msgData)
        local checkmsg = {}
        local ispreEmoticonIndex = contentindex
        while msgDataLen > 0 do
          chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
          chatting_contents[contentindex]:SetFontColor(0)
          chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          j = 1
          isWhile = false
          while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
            isWhile = true
            textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
            textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
            if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
              break
            end
            j = j + 1
          end
          if 0 == textStaticSizeX or isWhile == false then
            textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
            textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          end
          chatting_contents[contentindex]:SetSize(textStaticSizeX, chatting_sender:GetSizeY())
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText(checkmsg)
          contentindex = contentindex + 1
        end
        if ispreEmoticonIndex ~= contentindex then
          chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), chatting_sender:GetSizeY())
        else
          chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), chatting_sender:GetSizeY())
        end
        msgstartindex = emoticonindex
      else
        checkitemwebat = 0
        local drawstart = msgstartindex
        local drawend = emoticonindex
        checkitemwebat, drawend, chattingatNum = PaGlobal_ChatMain:getCheckItemWebAt(chattingMessage, chattingatNum, drawstart, drawend)
        if emoticonindex ~= drawend then
          drawend = drawend + 1
        end
        local msgData = string.sub(msg, msgstartindex + 1, drawend)
        local msgDataLen = string.len(msgData)
        local checkmsg = {}
        local ispreEmoticonIndex = contentindex
        local msgCheckSender = string.sub(msgData, 2, msgDataLen)
        if reciver ~= msgCheckSender and 3 == checkitemwebat then
          checkitemwebat = 0
        end
        if 3 == checkitemwebat and chatType == CppEnums.ChatType.Private and false == chattingMessage.isMe then
          checkitemwebat = 0
        end
        if UI_CT.Guild == chatType and 3 == checkitemwebat and chattingMessage:getIsChattingAtSound() then
          audioPostEvent_SystemUi(99, 1)
          _AudioPostEvent_SystemUiForXBOX(99, 1)
          chattingMessage:setIsChattingAtSound(false)
        end
        while msgDataLen > 0 do
          if 0 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          elseif 1 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedItem(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          elseif 2 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedWebSite(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          elseif 3 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingAt(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          elseif 4 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingLinkedGuild(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
            if nil ~= PaGlobal_ChatMain.guildPromoteList then
              PaGlobal_ChatMain.guildPromoteList:push_back(chatting_contents[contentindex])
            end
          elseif 5 == checkitemwebat then
            chatting_contents[contentindex] = poolCurrentUI:newChattingContents(messageIndex)
            chatting_contents[contentindex]:SetTextMode(UI_TM.eTextMode_ChattingText)
            chatting_contents[contentindex]:SetIgnore(true)
          end
          local j = 1
          textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
          textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          j = 1
          isWhile = false
          while contentindex > 1 and nil ~= chatting_contents[contentindex - j] and chatting_contents[contentindex - j]:GetSizeX() < panelSizeX - chatting_Icon:GetSizeX() - chatting_sender:GetTextSizeX() do
            isWhile = true
            textStaticSizeX = textStaticSizeX - chatting_contents[contentindex - j]:GetSizeX()
            textStaticPosX = textStaticPosX + chatting_contents[contentindex - j]:GetSizeX()
            if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[contentindex - j]:GetPosX() then
              break
            end
            j = j + 1
          end
          if 0 == textStaticSizeX or isWhile == false then
            textStaticSizeX = panelSizeX - chatting_Icon:GetSizeX() - PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon) - chatting_sender:GetTextSizeX()
            textStaticPosX = chatting_sender:GetTextSizeX() + chat_contentAddPosX
          end
          chatting_contents[contentindex]:SetSize(textStaticSizeX, chatting_sender:GetSizeY())
          chatting_contents[contentindex]:SetPosX(textStaticPosX)
          checkmsg, msgData, msgDataLen = PaGlobal_ChatMain:getTextLimitWidth(chatting_contents[contentindex], msgData)
          if isChangeFontSize() then
            chatting_contents[contentindex]:setChangeFontAfterTransSizeValue(true)
          end
          chatting_contents[contentindex]:SetText(checkmsg)
          contentindex = contentindex + 1
        end
        if nil ~= chatting_contents[contentindex - 1] then
          if ispreEmoticonIndex ~= contentindex then
            chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetTextSizeX(), chatting_sender:GetSizeY())
          else
            chatting_contents[contentindex - 1]:SetSize(chatting_contents[contentindex - 1]:GetSizeX(), chatting_sender:GetSizeY())
          end
        end
        msgstartindex = drawend
      end
    end
    chatting_contents, contentindex = PaGlobal_ChatMain:createContentWithMsgLength(reciver, poolCurrentUI, chatType, chattingMessage, isChattingAt, contentindex, chatting_contents, chatting_Icon, chatting_sender, msg, 0, msgstartindex, panelSizeX, chattingatNum, messageIndex, 0, 1, recommand_Icon, chatting_GuildMark)
    local nowLineImoticon = false
    local nowLineImoticonIdx = -1
    local nowLine = contentindex - 1
    for index = contentindex - 1, 1, -1 do
      if chatEmoticon[index] then
        nowLineImoticon = true
        nowLineImoticonIdx = index
      end
      if nowLineImoticon then
        local index2 = 1
        while nowLine >= index2 or index >= index2 do
          if chatEmoticon[index2] then
            local tempSize = (chatting_contents[nowLineImoticonIdx]:GetSizeY() - chatting_sender:GetSizeY()) / 2
          end
          index2 = index2 + 1
        end
      end
      if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[index]:GetPosX() then
        lineCount = lineCount + 1
        nowLine = index - 1
        nowLineImoticon = false
        if 1 ~= index then
          chatting_contents[index]:SetPosX(chatting_sender:GetTextSizeX() + chat_contentAddPosX)
        end
      end
    end
  else
    chatting_contents, contentindex = PaGlobal_ChatMain:createContentWithMsgLength(reciver, poolCurrentUI, chatType, chattingMessage, isChattingAt, contentindex, chatting_contents, chatting_Icon, chatting_sender, msg, 0, msgstartindex, panelSizeX, chattingatNum, messageIndex, 0, 1, recommand_Icon, chatting_GuildMark)
    for index = contentindex - 1, 1, -1 do
      if chatting_sender:GetTextSizeX() + chat_contentAddPosX >= chatting_contents[index]:GetPosX() then
        lineCount = lineCount + 1
        if 1 ~= index then
          chatting_contents[index]:SetPosX(chatting_sender:GetTextSizeX() + chat_contentAddPosX)
        end
      end
    end
  end
  for k, contents in ipairs(chatting_contents) do
    contents:SetShow(false)
  end
  return lineCount
end
function PaGlobal_ChatMain:getSenderString(chattingMessage)
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:getSenderString chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  local nameType = chattingMessage.chatNameType
  local sender = chattingMessage:getSender(ToClient_getChatNameType())
  local chatType = chattingMessage.chatType
  if UI_CT.System == chatType then
    sender = PAGetString(Defines.StringSheet_GAME, "CHATTING_TAB_SYSTEM")
  elseif UI_CT.Notice == chatType then
    sender = PAGetString(Defines.StringSheet_GAME, "CHATTING_NOTICE")
  elseif UI_CT.Battle == chatType then
    sender = PAGetString(Defines.StringSheet_GAME, "CHATTING_BATTLE")
  end
  local senderStr = " [" .. sender .. "] : "
  if UI_CT.Private == chatType then
    if not chattingMessage.isMe then
      senderStr = "\226\151\128 " .. senderStr
    elseif 0 == nameType then
      senderStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_0") .. senderStr
    elseif 1 == nameType then
      senderStr = PAGetString(Defines.StringSheet_GAME, "LUA_CHAT_NAMETYPE_1") .. senderStr
    end
  else
  end
  return senderStr
end
function PaGlobal_ChatMain:setChattingIcon(chatType, chatting_Icon, panelIndex)
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:setChattingIcon chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_Icon, "PaGlobal_ChatMain:setChattingIcon chatting_Icon nil", "\236\178\156\235\167\140\234\184\176")
  local chatPanel = ToClient_getChattingPanel(panelIndex)
  local fontType = chatPanel:getChatFontSizeType()
  local fontSize = ChattingOption_convertChatFontTypeToFontSize(fontType)
  local iconSizeY = fontSize + 8
  local iconSizeX = iconSizeY * 2 + 5
  chatting_Icon:SetSize(iconSizeX, iconSizeY)
  PaGlobal_ChatMain:uiPrivateChatType(chatType, chatting_Icon)
  chatting_Icon:ComputePos()
  chatting_Icon:SetPosX(10)
end
function PaGlobal_ChatMain:checkThumbsUpOpen(chatType)
  if nil == chatType then
    return false
  end
  if false == _ContentsGroup_Chat_Thumb then
    return false
  end
  if true == ToClient_isConsole() then
    return false
  end
  if false == (chatType == UI_CT.World or chatType == UI_CT.WorldWithItem or chatType == UI_CT.Public) then
    return false
  end
  return true
end
function PaGlobal_ChatMain:setchattingSender(chatType, chatting_sender, chatting_Icon, senderStr, msgColor, recommand_Icon, chattingMessage)
  UI.ASSERT_NAME(nil ~= chatType, "PaGlobal_ChatMain:setchattingSender chatType nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_sender, "PaGlobal_ChatMain:setchattingSender chatting_sender nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_Icon, "PaGlobal_ChatMain:setchattingSender chatting_Icon nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= senderStr, "PaGlobal_ChatMain:setchattingSender senderStr nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= msgColor, "PaGlobal_ChatMain:setchattingSender msgColor nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= recommand_Icon, "PaGlobal_ChatMain:setchattingSender recommand_Icon nil", "\236\158\132\236\136\152\237\152\132")
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:setchattingSender chattingMessage nil", "\236\158\132\236\136\152\237\152\132")
  local chat_contentAddPosX = 0
  if true == PaGlobal_ChatMain:checkThumbsUpOpen(chatType) then
    recommand_Icon:SetShow(true)
    recommand_Icon:ComputePos()
    local selfUserNo = getSelfPlayer():get():getUserNo()
    local senderUserNo = chattingMessage:getUserNo()
    local thumbsUpCnt = chattingMessage:getThumbsUpCount()
    if nil == thumbsUpCnt then
      thumbsUpCnt = 0
    else
      thumbsUpCnt = Int64toInt32(thumbsUpCnt)
    end
    local imgIndex = PaGlobal_ChatMain:getRecommandGradeIndex(thumbsUpCnt)
    local normalTextureInfo = PaGlobal_ChatMain._recommand_btnUV._normal[imgIndex]
    local onTextureInfo = PaGlobal_ChatMain._recommand_btnUV._on[imgIndex]
    local clickTextureInfo = PaGlobal_ChatMain._recommand_btnUV._click[imgIndex]
    local x1, y1, x2, y2 = setTextureUV_Func(recommand_Icon, normalTextureInfo.x1, normalTextureInfo.y1, normalTextureInfo.x2, normalTextureInfo.y2)
    recommand_Icon:getBaseTexture():setUV(x1, y1, x2, y2)
    x1, y1, x2, y2 = setTextureUV_Func(recommand_Icon, onTextureInfo.x1, onTextureInfo.y1, onTextureInfo.x2, onTextureInfo.y2)
    recommand_Icon:getOnTexture():setUV(x1, y1, x2, y2)
    x1, y1, x2, y2 = setTextureUV_Func(recommand_Icon, clickTextureInfo.x1, clickTextureInfo.y1, clickTextureInfo.x2, clickTextureInfo.y2)
    recommand_Icon:getClickTexture():setUV(x1, y1, x2, y2)
    recommand_Icon:setRenderTexture(recommand_Icon:getBaseTexture())
    recommand_Icon:addInputEvent("Mouse_LUp", "")
    if nil ~= senderUserNo and nil ~= selfUserNo and selfUserNo ~= senderUserNo then
      recommand_Icon:addInputEvent("Mouse_LUp", "HandleClicked_Chatting_Recommand(" .. Int64toInt32(senderUserNo) .. ")")
    end
    recommand_Icon:addInputEvent("Mouse_On", "HandleOn_Chatting_RecommandTooltip(" .. thumbsUpCnt .. ")")
    recommand_Icon:addInputEvent("Mouse_Out", "PaGlobal_SpeechBubble_Hide()")
    if true == chatting_Icon:GetShow() then
      chat_contentAddPosX = chat_contentAddPosX + 15
      recommand_Icon:SetPosX(chatting_Icon:GetSizeX() + chat_contentAddPosX)
    else
      chat_contentAddPosX = chat_contentAddPosX + 10
      recommand_Icon:SetPosX(chat_contentAddPosX)
    end
    chat_contentAddPosX = recommand_Icon:GetPosX() + PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon)
  else
    recommand_Icon:SetShow(false)
    if true == chatting_Icon:GetShow() then
      chat_contentAddPosX = chat_contentAddPosX + 15
      chat_contentAddPosX = chat_contentAddPosX + chatting_Icon:GetSizeX()
    else
      chat_contentAddPosX = chat_contentAddPosX + 10
    end
  end
  chatting_sender:SetPosX(chat_contentAddPosX)
  chatting_sender:SetTextHorizonRight()
  chatting_sender:SetAutoResize(true)
  chatting_sender:SetFontColor(msgColor)
  chatting_sender:SetText(senderStr)
  if UI_CT.System == chatType or UI_CT.Battle == chatType then
    chatting_sender:SetText(" ")
  end
  chatting_sender:SetSize(chatting_sender:GetTextSizeX(), chatting_sender:GetTextSizeY() - 4)
  return chat_contentAddPosX
end
function PaGlobal_ChatMain:setChattingGuildMark(chatting_GuildMark, chattingMessage, chatting_sender, isShow)
  UI.ASSERT_NAME(nil ~= chatting_GuildMark, "PaGlobal_ChatMain:setChattingGuildMark chatting_GuildMark nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:setChattingGuildMark chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chatting_sender, "PaGlobal_ChatMain:setChattingGuildMark chatting_sender nil", "\236\178\156\235\167\140\234\184\176")
  if false == chattingMessage:isLinkedGuild() then
    return
  end
  local guildMarkPureSize = chatting_sender:GetTextSizeY()
  local guildMarkMarginWidth = 8
  local guildMarkSize = guildMarkPureSize + guildMarkMarginWidth
  chatting_GuildMark:SetShow(isShow)
  chatting_GuildMark:SetSize(guildMarkPureSize, guildMarkPureSize)
  chatting_GuildMark:SetPosX(chatting_sender:GetPosX() + chatting_sender:GetTextSizeX() + guildMarkMarginWidth / 2)
  if true == isShow then
    local linkedGuildInfo = chattingMessage:getLinkedGuildInfo()
    local guildNo = linkedGuildInfo:getGuildNo()
    local isSet = setGuildTextureByGuildNo(guildNo, chatting_GuildMark)
    if false == isSet then
      chatting_GuildMark:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Default/BlankGuildMark.dds")
    end
    chatting_GuildMark:setRenderTexture(chatting_GuildMark:getBaseTexture())
  end
  return guildMarkSize
end
function PaGlobal_ChatMain:getChattingMessage(panelIndex, chattingMessage)
  if nil == panelIndex then
    return
  end
  UI.ASSERT_NAME(nil ~= panelIndex, "PaGlobal_ChatMain:getChattingMessage panelIndex nil", "\236\178\156\235\167\140\234\184\176")
  UI.ASSERT_NAME(nil ~= chattingMessage, "PaGlobal_ChatMain:getChattingMessage chattingMessage nil", "\236\178\156\235\167\140\234\184\176")
  local chatType = chattingMessage.chatType
  local msg = chattingMessage:getContent()
  if true == FGlobal_ChatOption_GetIsShowTimeString(panelIndex) or UI_CT.Private == chatType or UI_CT.System == chatType and UI_CST.Market == chattingMessage.chatSystemType then
    msg = chattingMessage:getContent() .. " (" .. chattingMessage:getTimeString() .. ")"
  end
  return msg
end
function PaGlobal_ChatMain:getRecommandIconSizeX(recommand_Icon)
  UI.ASSERT_NAME(nil ~= recommand_Icon, "PaGlobal_ChatMain:getChattingMessage recommand_Icon nil", "\236\178\156\235\167\140\234\184\176")
  if recommand_Icon:GetShow() then
    return recommand_Icon:GetSizeX()
  end
  return 0
end
function PaGlobal_ChatMain:getRecommandGradeIndex(recomandCount)
  UI.ASSERT_NAME(nil ~= recomandCount, "PaGlobal_ChatMain:getChattingMessage recomandCount nil", "\236\178\156\235\167\140\234\184\176")
  if recomandCount > 2700 then
    return 1
  elseif recomandCount > 2400 then
    return 2
  elseif recomandCount > 2100 then
    return 3
  elseif recomandCount > 1800 then
    return 4
  elseif recomandCount > 1500 then
    return 5
  elseif recomandCount > 1200 then
    return 6
  elseif recomandCount > 900 then
    return 7
  elseif recomandCount > 600 then
    return 8
  elseif recomandCount > 300 then
    return 9
  else
    return 10
  end
end
