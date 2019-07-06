local UI_TM = CppEnums.TextMode
local _panel = Panel_Window_GameExit
local Window_GameExitInfo = {
  _ui = {
    _static_MainBg = UI.getChildControl(Panel_Window_GameExit, "Static_MainBg"),
    _static_titleBar = UI.getChildControl(Panel_Window_GameExit, "Static_TitleBar"),
    _static_Bottom = UI.getChildControl(Panel_Window_GameExit, "Static_Bottom"),
    _body = {},
    _bottom = {}
  },
  _config = {
    _exitType_GameExit = 0,
    _exitType_CharacterSelect = 1,
    _exitType_Tray = 2,
    _exitType_UnTray = 3,
    _exitType_CharacterSwap = 4,
    _maxQuestList = 3,
    _maxJournalList = 2,
    _maxCharacterSlot = 4
  },
  _currentExitType = -1,
  _logoutDelayTime = getLogoutWaitingTime(),
  _exitTime = -1,
  _isTakePhoto = false,
  _characterUITable = {},
  _currentCharacterInfoTable = {},
  _characterInfoTable = {},
  _currentWheelValue = 0,
  _currentCharacterIndex = -1,
  _selfPlayerIndex = -1,
  _journalList = {},
  _questList = {}
}
function PaGlobalFunc_GameExit_workTypeToStringSwap(workingType)
  local workingText
  if CppEnums.PcWorkType.ePcWorkType_Empty == workingType then
    workingText = ""
  elseif CppEnums.PcWorkType.ePcWorkType_Play == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_PLAY")
  elseif CppEnums.PcWorkType.ePcWorkType_RepairItem == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_REPAIRITEM")
  elseif CppEnums.PcWorkType.ePcWorkType_Relax == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_RELEX")
  elseif CppEnums.PcWorkType.ePcWorkType_ReadBook == workingType then
    workingText = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_READBOOK")
  else
    _PA_ASSERT(false, "\236\186\144\235\166\173\237\132\176 \236\158\145\236\151\133 \237\131\128\236\158\133\236\157\180 \236\182\148\234\176\128 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. Lobby_New.lua \235\143\132 \236\182\148\234\176\128\237\149\180 \236\163\188\236\150\180\236\149\188 \237\149\169\235\139\136\235\139\164.")
    workingText = "unKnown"
  end
  return workingText
end
function Window_GameExitInfo:SetHistory()
  local questList = self._ui._bottom._staticText_QuestList
  local selfPlayerAPW = getSelfPlayer()
  if nil == selfPlayerAPW then
    return
  end
  local qusetListStr = ""
  for index = 0, self._config._maxQuestList - 1 do
    self._questList[index]:SetShow(false)
  end
  for index = 0, self._config._maxQuestList - 1 do
    local qusetNo = selfPlayerAPW:get():getLastCompleteQuest(index)
    local questWrapper = ToClient_getQuestWrapper(qusetNo)
    if nil ~= questWrapper then
      qusetListStr = "\194\183 " .. questWrapper:getTitle()
      self._questList[index]:SetShow(true)
      self._questList[index]:SetText(qusetListStr)
    end
  end
  ToClient_RequestRecentJournalByCount(self._config._maxJournalList)
  local journalCount = ToClient_GetRecentJournalCount()
  if 0 == journalCount then
    return
  end
  for index = 0, self._config._maxJournalList - 1 do
    self._journalList[index]:SetShow(false)
  end
  local journalListStr = ""
  for index = 0, self._config._maxJournalList - 1 do
    local journalWrapper = ToClient_GetRecentJournalByIndex(index)
    if nil ~= journalWrapper then
      journalListStr = "\194\183 [" .. string.format("%.02d", journalWrapper:getJournalHour()) .. ":" .. string.format("%.02d", journalWrapper:getJournalMinute()) .. "] " .. journalWrapper:getName()
      self._journalList[index]:SetShow(true)
      self._journalList[index]:SetText(journalListStr)
    end
  end
end
function PaGlobalFunc_GameExit_SetCharacterInfoTable()
  local self = Window_GameExitInfo
  self:SetCharacterInfoTable()
end
function Window_GameExitInfo:SetCharacterInfoTable()
  local characterCount = getCharacterDataCount()
  local serverUtc64 = getServerUtc64()
  for index = 0, characterCount - 1 do
    local infoTable = {
      _classType = -1,
      _baseTexture = nil,
      _textureName = nil,
      _level = -1,
      _name = "",
      _location = "",
      _enchantFailCount = 0,
      _enchantValksCount = 0,
      _energy = -1,
      _remindTime,
      _condition = "",
      _isRemoved = false,
      _isSelfPlayer = false
    }
    local characterData = getCharacterDataByIndex(index)
    infoTable._classType = getCharacterClassType(characterData)
    infoTable._textureName = getCharacterFaceTextureByIndex(index)
    infoTable._level = characterData._level
    infoTable._name = getCharacterName(characterData)
    infoTable._enchantFailCount = characterData._enchantFailCount
    infoTable._enchantValksCount = characterData._valuePackCount
    infoTable._energy = ToClient_getWpInCharacterDataList(index)
    local pcDeliveryRegionKey = characterData._arrivalRegionKey
    local regionInfo = getRegionInfoByPosition(characterData._currentPosition)
    if 0 == characterData._currentPosition.x and 0 == characterData._currentPosition.y and 0 == characterData._currentPosition.z then
      infoTable._location = ""
    elseif 0 ~= pcDeliveryRegionKey:get() and serverUtc64 > characterData._arrivalTime then
      local retionInfoArrival = getRegionInfoByRegionKey(pcDeliveryRegionKey)
      infoTable._location = retionInfoArrival:getAreaName()
    else
      infoTable._location = regionInfo:getAreaName()
    end
    if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
      infoTable._condition = PAGetString(Defines.StringSheet_GAME, "CHARACTER_WORKING_TEXT_DELIVERY")
      infoTable._remindTime = convertStringFromDatetime(characterData._arrivalTime - serverUtc64)
    else
      infoTable._condition = PaGlobalFunc_GameExit_workTypeToStringSwap(characterData._pcWorkingType)
    end
    local removeTime = getCharacterDataRemoveTime(index)
    if nil ~= removeTime then
      infoTable._condition = PAGetString(Defines.StringSheet_GAME, "CHARACTER_DELETING")
      infoTable._isRemoved = true
    end
    local characterNo_64 = getSelfPlayer():getCharacterNo_64()
    if characterNo_64 == characterData._characterNo_s64 then
      infoTable._isSelfPlayer = true
      self._selfPlayerIndex = index
    end
    self._characterInfoTable[index] = infoTable
  end
end
function Window_GameExitInfo:SetCharacterSlot(charInfo, charSlot)
  if nil == charInfo or nil == charSlot then
    return false
  end
  for _, control in pairs(charSlot) do
    if nil == control then
      return false
    end
  end
  charSlot._staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. charInfo._level)
  charSlot._staticText_Name:SetText(charInfo._name)
  charSlot._staticText_Location:SetText(charInfo._location)
  charSlot._staticText_Location:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  charSlot._staticText_Energy:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARWP_TITLE") .. " " .. charInfo._energy)
  charSlot._staticText_EnchantFailCount:SetText(PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_ENCHANT") .. " " .. charInfo._enchantFailCount .. "+" .. charInfo._enchantValksCount)
  charSlot._staticText_RemindTime:SetText("")
  if nil ~= charInfo._remindTime then
    charSlot._staticText_RemindTime:SetText(charInfo._remindTime)
  end
  charSlot._staticText_Condtion:SetText(charInfo._condition)
  if _ContentsGroup_isConsolePadControl then
  end
  local isCaptureExist = charSlot._static_Picture:ChangeTextureInfoNameNotDDS(charInfo._textureName, charInfo._classType, self._isTakePhoto)
  if true == isCaptureExist then
    charSlot._static_Picture:ChangeTextureInfoName(charSlot._static_Picture:getBaseTexture())
    charSlot._static_Picture:getBaseTexture():setUV(0, 0, 1, 1)
    charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
  else
    if false == _ContentsGroup_isUsedNewCharacterInfo then
      if charInfo._classType == CppEnums.ClassType.ClassType_Warrior then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 1, 156, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Ranger then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 157, 1, 312, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Sorcerer then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 313, 1, 468, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Giant then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 202, 156, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Tamer then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 157, 202, 312, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_BladeMaster then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 313, 202, 468, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Valkyrie then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 1, 156, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_BladeMasterWomen then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 157, 1, 312, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Wizard then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 313, 1, 468, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_WizardWomen then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 202, 156, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_NinjaWomen then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 157, 202, 312, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_NinjaMan then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_01.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 313, 202, 468, 402)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_DarkElf then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 1, 156, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Combattant then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 157, 1, 312, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_CombattantWomen then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_02.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 313, 1, 468, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Lahn then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_03.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 1, 156, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      elseif charInfo._classType == CppEnums.ClassType.ClassType_Orange then
        charSlot._static_Picture:ChangeTextureInfoName("New_UI_Common_forLua/Window/GameExit/GameExit_CharSlot_03.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, 1, 1, 156, 201)
        charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
        charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
      end
    else
      local DefaultFace = CppEnums.ClassType_DefaultFaceTexture[charInfo._classType]
      charSlot._static_Picture:ChangeTextureInfoName(DefaultFace[1])
      local x1, y1, x2, y2 = setTextureUV_Func(charSlot._static_Picture, DefaultFace[2], DefaultFace[3], DefaultFace[4], DefaultFace[5])
      charSlot._static_Picture:getBaseTexture():setUV(x1, y1, x2, y2)
    end
    charSlot._static_Picture:setRenderTexture(charSlot._static_Picture:getBaseTexture())
  end
  self._isTakePhoto = false
  return true
end
function PaGlobalFunc_GameExit_SaveCurrentData()
  Window_GameExitInfo:SaveCurrentData()
end
function Window_GameExitInfo:SaveCurrentData()
  getSelfPlayer():updateNavigationInformation("")
  getSelfPlayer():saveCurrentDataForGameExit()
  ToClient_SaveUiInfo(false)
end
function Window_GameExitInfo:ExitToGameOff()
  self:SaveCurrentData()
  local selfPlayerActorProxy = getSelfPlayer():get()
  if nil == selfPlayerActorProxy then
    return
  end
  self._currentExitType = self._config._exitType_GameExit
  local regionInfo = getRegionInfoByPosition(selfPlayerActorProxy:getPosition())
  if true == regionInfo:get():isSafeZone() then
    self:SetNoticeMsg()
  else
    self:SetNoticeMsg(self._logoutDelayTime)
  end
  sendBeginGameDelayExit(self._config._exitType_CharacterSwap == self._currentExitType)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"),
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_0
  }
  MessageBox.showMessageBox(messageBoxData)
end
function Window_GameExitInfo:ExitToCharacterSelect()
  self._currentExitType = self._config._exitType_CharacterSelect
  self:SaveCurrentData()
  sendCharacterSelect()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if true == regionInfo:get():isSafeZone() then
    self:SetNoticeMsg()
  else
    self:SetNoticeMsg(self._logoutDelayTime)
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"),
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_0
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_GameExit_CharacterSwapConfirm()
  local self = Window_GameExitInfo
  self:SaveCurrentData()
  local rv = swapCharacter_Select(self._currentCharacterIndex, true)
  if false == rv then
    return
  end
  self._currentExitType = self._config._exitType_CharacterSwap
  self:SetNoticeMsg(self._logoutDelayTime)
  if true == PaGlobal_IsTagChange() then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CHANGING")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"),
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_0
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_GameExit_UpdatePerFrame(deltaTime)
  local self = Window_GameExitInfo
  if -1 == self._exitTime then
    return
  end
  self._exitTime = self._exitTime - deltaTime
  self:SetNoticeMsg(Int64toInt32(self._exitTime))
  if self._exitTime >= 0 then
    return
  end
  self:SetNoticeMsg()
  if self._config._exitType_GameExit == self._currentExitType then
    SetUIMode(Defines.UIMode.eUIMode_Default)
    sendGameLogOut()
  end
  self._currentExitType = -1
  self._exitTime = -1
end
function PaGlobalFunc_FromClient_GameExit_SetDelayTime(delayTime)
  local self = Window_GameExitInfo
  if false == PaGlobalFunc_GameExit_GetShow() then
    return
  end
  self._exitTime = delayTime
  self:SetNoticeMsg(delayTime)
end
function Window_GameExitInfo:SetNoticeMsg(delayTime)
  local msg
  if nil == delayTime then
    self._ui._button_NoticeMsg:SetIgnore(true)
    if self._config._exitType_GameExit == self._currentExitType then
      msg = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_PROGRESS")
    elseif self._config._exitType_CharacterSelect == self._currentExitType then
      msg = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_CHARACTERSELECT")
    elseif self._config._exitType_CharacterSwap == self._currentExitType then
      msg = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER")
    else
      _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\162\133\235\163\140 \237\131\128\236\158\133\236\157\180 \236\158\152\235\170\187\235\144\144\236\138\181\235\139\136\235\139\164.")
    end
  else
    self._ui._button_NoticeMsg:SetIgnore(false)
    if self._config._exitType_GameExit == self._currentExitType then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_EXIT", "remainTime", tostring(delayTime))
    elseif self._config._exitType_CharacterSelect == self._currentExitType then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_SELECT", "remainTime", tostring(delayTime))
    elseif self._config._exitType_CharacterSwap == self._currentExitType then
      msg = PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(delayTime))
    else
      _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\162\133\235\163\140 \237\131\128\236\158\133\236\157\180 \236\158\152\235\170\187\235\144\144\236\138\181\235\139\136\235\139\164.")
    end
  end
  self._ui._button_NoticeMsg:SetShow(true)
  self._ui._button_NoticeMsg:SetText(msg)
end
function PaGlobalFunc_GameExit_UpdateCharList()
  local self = Window_GameExitInfo
  self:Clear()
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_CharBg:SetShow(false)
    local isSuccess = self:SetCharacterSlot(self._characterInfoTable[index + self._currentWheelValue], self._characterUITable[index])
    if true == isSuccess then
      self._characterUITable[index]._radioButton_CharBg:SetShow(true)
      self._currentCharacterInfoTable[index] = self._characterInfoTable[index + self._currentWheelValue]
    end
  end
end
function PaGlobalFunc_GameExit_ButtonClick_CharacterSwap(index)
  local self = Window_GameExitInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  self._currentCharacterIndex = index + self._currentWheelValue
  local charInfo = self._currentCharacterInfoTable[index]
  if nil == charInfo then
    return
  end
  local characterData = getCharacterDataByIndex(self._currentCharacterIndex)
  local classType = charInfo._classType
  if true == charInfo._isSelfPlayer then
    return
  end
  if ToClient_IsCustomizeOnlyClass(classType) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_LOBBY_SELECTCHARACTER_NOTYET_1"))
    return
  end
  if 5 > characterData._level then
    NotifyDisplay(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4))
    return
  end
  local removeTime = getCharacterDataRemoveTime(self._currentCharacterIndex)
  if nil ~= removeTime then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE"))
    return
  end
  local usabelSlotCount = getUsableCharacterSlotCount()
  if usabelSlotCount <= self._currentCharacterIndex then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_CLOSE_CHARACTER_SLOT"))
    return
  end
  local contentString = ""
  if Defines.s64_const.s64_m1 ~= characterData._lastTicketNoByRegion then
    contentString = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_WAIT") .. "\n"
  end
  local pcDeliveryRegionKey = characterData._arrivalRegionKey
  local serverUtc64 = getServerUtc64()
  if 0 ~= pcDeliveryRegionKey:get() and serverUtc64 < characterData._arrivalTime then
    contentString = PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectPcDelivery") .. "\n"
  end
  contentString = contentString .. PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXIT_CHARACTER_CHANGE_QUESTION")
  local messageboxData = {
    title = "",
    content = contentString,
    functionYes = PaGlobalFunc_GameExit_CharacterSwapConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_GameExit_ButtonClick_ServerChange()
  local self = Window_GameExitInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  if false == _ContentsGroup_RenewUI_ServerSelect then
    FGlobal_ChannelSelect_Show()
  else
    PaGlobalFunc_ServerSelect_Open()
  end
end
function PaGlobalFunc_GameExit_ButtonClick_Exit(exitType)
  local self = Window_GameExitInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  PaGlobalFunc_GameExitConfirm_OpenByExitType(exitType)
end
function PaGlobalFunc_GameExit_ButtonClick_CharacterMove()
  local self = Window_GameExitInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  PaGlobalFunc_GameExit_SetShow(false, false)
  PaGlobalFunc_GameExitCharMove_SetShow(true, false)
end
function PaGlobalFunc_GameExit_ButtonClick_ExitCancel()
  local self = Window_GameExitInfo
  if false == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local cancelAble = true
  if self._config._exitType_CharacterSelect == self._currentExitType and true == regionInfo:get():isSafeZone() or self._exitTime < 2 then
    cancelAble = false
  end
  if true == cancelAble then
    sendGameDelayExitCancel()
  end
  self._exitTime = -1
  self._currentExitType = -1
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self._ui._button_NoticeMsg:SetShow(false)
end
function PaGlobalFunc_GameExit_ButtonClick_ChangeAccount()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING_CHANGEACCOUNT_MSGBOX")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_GameExit_ChangeAccount_MessageBoxConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "top")
end
function PaGlobalFunc_GameExit_ChangeAccount_MessageBoxConfirm()
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_ChangeAccount()
end
function PaGlobalFunc_GameExit_GetCharInfoTable()
  local self = Window_GameExitInfo
  return self._characterInfoTable
end
function Window_GameExitInfo:Clear()
  self._currentExitType = -1
  self._exitTime = -1
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_CharBg:SetCheck(false)
  end
end
function Window_GameExitInfo:Update()
  ToClient_RequestCharacterEnchantFailCount()
  self:SetHistory()
  self:SetCharacterInfoTable()
  PaGlobalFunc_GameExit_UpdateCharList()
end
function Window_GameExitInfo:Initialize()
  self:InitRegister()
  self:InitControl()
  self:InitEvent()
  self:XB_Control_Init()
  self:Clear()
  self:Update()
end
function Window_GameExitInfo:InitControl()
  local body = self._ui._body
  local bottom = self._ui._bottom
  self._ui._button_NoticeMsg = UI.getChildControl(self._ui._static_titleBar, "Button_NoticeMsg")
  body._button_GameExit = UI.getChildControl(self._ui._static_MainBg, "Button_GameExit")
  body._button_ServerChange = UI.getChildControl(self._ui._static_MainBg, "Button_ServerChange")
  body._button_SelectCharacter = UI.getChildControl(self._ui._static_MainBg, "Button_SelectCharacter")
  body._button_CharacterMove = UI.getChildControl(self._ui._static_MainBg, "Button_CharacterMove")
  body._button_ChangeAccount = UI.getChildControl(self._ui._static_MainBg, "Button_ChangeAccount_ConsoleUI")
  body._button_GameExit:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._button_ServerChange:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._button_SelectCharacter:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._button_CharacterMove:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._button_ChangeAccount:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  body._button_GameExit:SetText(body._button_GameExit:GetText())
  body._button_ServerChange:SetText(body._button_ServerChange:GetText())
  body._button_SelectCharacter:SetText(body._button_SelectCharacter:GetText())
  body._button_CharacterMove:SetText(body._button_CharacterMove:GetText())
  body._button_ChangeAccount:SetText(body._button_ChangeAccount:GetText())
  if true == ToClient_isConsole() then
    body._button_CharacterMove:SetShow(false)
  end
  if true == ToClient_isPS4() then
    body._button_ChangeAccount:SetShow(false)
  end
  body._button_Tray = UI.getChildControl(self._ui._static_MainBg, "Button_Tray")
  body._button_LB = UI.getChildControl(self._ui._static_MainBg, "Button_LB")
  body._button_RB = UI.getChildControl(self._ui._static_MainBg, "Button_RB")
  bottom._staticText_QuestListTemplate = UI.getChildControl(self._ui._static_Bottom, "StaticText_QuestList")
  bottom._staticText_QuestListTemplate:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  bottom._staticText_QuestListTemplate:SetShow(false)
  bottom._staticText_QuestListTemplate:SetTextVerticalTop()
  bottom._staticText_JournalListTemplate = UI.getChildControl(self._ui._static_Bottom, "StaticText_JournalListTemplate")
  bottom._staticText_JournalListTemplate:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  bottom._staticText_JournalListTemplate:SetShow(false)
  for index = 0, self._config._maxJournalList - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._static_Bottom, "staticText_Journal_" .. index)
    CopyBaseProperty(bottom._staticText_JournalListTemplate, control)
    control:SetPosY(control:GetPosY() + control:GetSizeY() * index)
    self._journalList[index] = control
  end
  for index = 0, self._config._maxQuestList - 1 do
    local control = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._static_Bottom, "staticText_Quest_" .. index)
    CopyBaseProperty(bottom._staticText_QuestListTemplate, control)
    control:SetPosY(control:GetPosY() + control:GetSizeY() * index)
    self._questList[index] = control
  end
  body._button_LB:SetShow(4 < getCharacterDataCount())
  body._button_RB:SetShow(4 < getCharacterDataCount())
  local _button_DisPlay = {
    [0] = body._button_GameExit,
    [1] = body._button_ServerChange,
    [2] = body._button_SelectCharacter,
    [3] = body._button_ChangeAccount,
    [4] = body._button_CharacterMove,
    ["totalCount"] = 5
  }
  local _startX = body._button_GameExit:GetPosX() - 12
  local _gapX = body._button_GameExit:GetSizeX() + 10
  if true == ToClient_isConsole() then
    _startX = body._button_GameExit:GetPosX() - 12 + _gapX * 0.5
  end
  if true == ToClient_isPS4() then
    _startX = body._button_GameExit:GetPosX() - 12 + _gapX
  end
  if _ContentsGroup_isConsolePadControl then
    body._button_Tray:SetIgnore(true)
    body._button_Tray:SetShow(false)
    for ii = 0, _button_DisPlay.totalCount - 1 do
      _button_DisPlay[ii]:SetSize(172, 62)
      _button_DisPlay[ii]:SetPosX(_startX + _gapX * ii)
    end
  end
  local radioButton_CharBg = UI.getChildControl(self._ui._static_MainBg, "RadioButton_SlotTemplate")
  local baseCharUI = {
    _radioButton_CharBg = radioButton_CharBg,
    _static_Picture = UI.getChildControl(radioButton_CharBg, "Static_Picture"),
    _staticText_Level = UI.getChildControl(radioButton_CharBg, "StaticText_Lv"),
    _staticText_Name = UI.getChildControl(radioButton_CharBg, "StaticText_Name"),
    _staticText_Location = UI.getChildControl(radioButton_CharBg, "StaticText_Location"),
    _staticText_EnchantFailCount = UI.getChildControl(radioButton_CharBg, "StaticText_EnchantFailCount"),
    _staticText_Energy = UI.getChildControl(radioButton_CharBg, "StaticText_Energy"),
    _button_ChangePicture = UI.getChildControl(radioButton_CharBg, "StaticText_ChangePicture"),
    _staticText_Condtion = UI.getChildControl(radioButton_CharBg, "StaticText_Contidion"),
    _staticText_RemindTime = UI.getChildControl(radioButton_CharBg, "StaticText_RemindTime")
  }
  local UCT = CppEnums.PA_UI_CONTROL_TYPE
  for index = 0, self._config._maxCharacterSlot - 1 do
    local uiTable = {
      _radioButton_CharBg,
      _static_Picture,
      _staticText_Level,
      _staticText_Name,
      _staticText_Location,
      _staticText_EnchantFailCount,
      _staticText_Energy,
      _button_ChangePicture,
      _staticText_Condtion,
      _staticText_RemindTime
    }
    uiTable._radioButton_CharBg = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_MainBg, "radioButton_CharBg_" .. index)
    CopyBaseProperty(baseCharUI._radioButton_CharBg, uiTable._radioButton_CharBg)
    uiTable._static_Picture = UI.createControl(UCT.PA_UI_CONTROL_STATIC, uiTable._radioButton_CharBg, "static_Picture_" .. index)
    CopyBaseProperty(baseCharUI._static_Picture, uiTable._static_Picture)
    uiTable._staticText_Level = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_Level_" .. index)
    CopyBaseProperty(baseCharUI._staticText_Level, uiTable._staticText_Level)
    uiTable._staticText_Name = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_Name_" .. index)
    CopyBaseProperty(baseCharUI._staticText_Name, uiTable._staticText_Name)
    uiTable._staticText_Location = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_Location_" .. index)
    CopyBaseProperty(baseCharUI._staticText_Location, uiTable._staticText_Location)
    uiTable._staticText_EnchantFailCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_EnchantFailCount_" .. index)
    CopyBaseProperty(baseCharUI._staticText_EnchantFailCount, uiTable._staticText_EnchantFailCount)
    uiTable._staticText_Energy = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_Energy_" .. index)
    CopyBaseProperty(baseCharUI._staticText_Energy, uiTable._staticText_Energy)
    uiTable._button_ChangePicture = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, uiTable._radioButton_CharBg, "button_ChangePicture_" .. index)
    CopyBaseProperty(baseCharUI._button_ChangePicture, uiTable._button_ChangePicture)
    uiTable._staticText_Condtion = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_Condtion_" .. index)
    CopyBaseProperty(baseCharUI._staticText_Condtion, uiTable._staticText_Condtion)
    uiTable._staticText_RemindTime = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_CharBg, "staticText_RemindTime_" .. index)
    CopyBaseProperty(baseCharUI._staticText_RemindTime, uiTable._staticText_RemindTime)
    uiTable._radioButton_CharBg:SetPosX(uiTable._radioButton_CharBg:GetPosX() + (uiTable._radioButton_CharBg:GetSizeX() + 10) * index)
    uiTable._radioButton_CharBg:SetShow(false)
    self._characterUITable[index] = uiTable
  end
  for _, control in pairs(baseCharUI) do
    control:SetShow(false)
    UI.deleteControl(control)
  end
  self._ui.stc_KeyGuideBg = UI.getChildControl(_panel, "Static_KeyGuideBg")
  self._ui.btn_AConsoleUI = UI.getChildControl(self._ui.stc_KeyGuideBg, "Radiobutton_A_ConsoleUI")
  self._ui.btn_BConsoleUI = UI.getChildControl(self._ui.stc_KeyGuideBg, "Radiobutton_B_ConsoleUI")
  self._keyGuides = {
    self._ui.btn_AConsoleUI,
    self._ui.btn_BConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui.stc_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Window_GameExitInfo:InitEvent()
  local body = self._ui._body
  local bottom = self._ui._bottom
  self._ui._button_NoticeMsg:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_ExitCancel()")
  Panel_Window_GameExit:RegisterUpdateFunc("PaGlobalFunc_GameExit_UpdatePerFrame")
  body._button_LB:addInputEvent("Mouse_LUp", "InputLBRB_GameExit_UpdateCurrentWheelValue(-1)")
  body._button_RB:addInputEvent("Mouse_LUp", "InputLBRB_GameExit_UpdateCurrentWheelValue(1)")
  body._button_GameExit:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_Exit(0)")
  body._button_Tray:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_Exit(1)")
  body._button_SelectCharacter:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_Exit(2)")
  body._button_ServerChange:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_ServerChange()")
  body._button_ChangeAccount:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_ChangeAccount()")
  body._button_GameExit:addInputEvent("Mouse_On", "InputMO_GameExit_UpdateKeyGuide(" .. 0 .. ")")
  body._button_SelectCharacter:addInputEvent("Mouse_On", "InputMO_GameExit_UpdateKeyGuide(" .. 0 .. ")")
  body._button_ServerChange:addInputEvent("Mouse_On", "InputMO_GameExit_UpdateKeyGuide(" .. 0 .. ")")
  body._button_ChangeAccount:addInputEvent("Mouse_On", "InputMO_GameExit_UpdateKeyGuide(" .. 0 .. ")")
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_CharBg:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_CharacterSwap(" .. index .. ")")
    self._characterUITable[index]._button_ChangePicture:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_ChangePhoto(" .. index .. ")")
    self._characterUITable[index]._radioButton_CharBg:addInputEvent("Mouse_On", "InputMO_GameExit_UpdateKeyGuide(" .. 1 .. "," .. index .. ")")
  end
end
function PaGlobalFunc_GameExit_Resize()
end
function PaGlobalFunc_GameExit_ButtonClick_ChangePhoto(index)
  local self = Window_GameExitInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  self._currentCharacterIndex = self._currentWheelValue + index
  PaGlobalFunc_GameExit_SetShow(false, false)
  IsGameExitPhoto(true)
  IngameCustomize_Show()
  characterSlot_Index(self._currentCharacterIndex)
  self._isTakePhoto = true
end
function PaGlobalFunc_FromClient_GameExit_WindowTry()
  PaGlobalFunc_GameExit_ButtonClick_Exit(1)
end
function Window_GameExitInfo:InitRegister()
  registerEvent("EventGameExitDelayTime", "PaGlobalFunc_FromClient_GameExit_SetDelayTime")
  registerEvent("EventGameWindowClose", "GameExitShowToggle()")
  registerEvent("FromClient_TrayIconMessageBox", "PaGlobalFunc_FromClient_GameExit_WindowTry")
  registerEvent("onScreenResize", "PaGlobalFunc_GameExit_Resize")
  registerEvent("FromClient_ResponseEnchantFailCountOfMyCharacters", "PaGlobalFunc_GameExit_SetCharacterInfoTable")
end
function PaGlobalFunc_FromClient_GameExit_luaLoadComplete()
  local self = Window_GameExitInfo
  self:Initialize()
  self:Clear()
end
function PaGlobalFunc_GameExit_SetShow(isShow, isAni, isAttacked)
  local self = Window_GameExitInfo
  ToClient_RequestCharacterEnchantFailCount()
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEEXITOPENALERT_INDEAD"))
    return
  end
  if CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() then
    return
  end
  local currentUIMode = GetUIMode()
  if currentUIMode == Defines.UIMode.eUIMode_Gacha_Roulette or currentUIMode == Defines.UIMode.eUIMode_DeadMessage then
    return
  end
  if true == ToClient_cutsceneIsPlay() then
    return
  end
  if true == isFlushedUI() then
    return
  end
  if true == isAttacked then
    return
  end
  if true == isGameTypeRussia() and true == isAttacked then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if true == regionInfo:get():isSafeZone() then
      return
    end
  end
  if true == isShow then
    SetUIMode(Defines.UIMode.eUIMode_GameExit)
    _AudioPostEvent_SystemUiForXBOX(1, 30)
    sendWaitingListOfMyCharacters()
    self:Clear()
    self:Update()
  else
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == _panel:GetShow() then
      _AudioPostEvent_SystemUiForXBOX(1, 31)
    end
    if -1 ~= self._currentExitType then
      PaGlobalFunc_GameExit_ButtonClick_ExitCancel()
    end
  end
  Panel_Window_GameExit:SetShow(isShow, isAni)
  self._currentPhotoIndex = 0
end
function PaGlobalFunc_GameExit_GetShow()
  return Panel_Window_GameExit:GetShow()
end
function GameExitShowToggle(isAttacked)
  PaGlobalFunc_GameExit_SetShow(not PaGlobalFunc_GameExit_GetShow(), false, isAttacked)
end
function PaGlobalFunc_GameExit_ExitHandler(ExitType)
  local self = Window_GameExitInfo
  if self._config._exitType_GameExit == ExitType then
    self:ExitToGameOff()
  elseif self._config._exitType_CharacterSelect == ExitType then
    self:ExitToCharacterSelect()
  elseif self._config._exitType_Tray == ExitType then
    ToClient_CheckTrayIcon()
  elseif self._config._exitType_UnTray == ExitType then
    ToClient_UnCheckTrayIcon()
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\162\133\235\163\140 \237\131\128\236\158\133\236\157\180 \236\158\152\235\170\187\235\144\144\236\138\181\235\139\136\235\139\164.")
  end
end
function InputMO_GameExit_UpdateKeyGuide(type, idx)
  local self = Window_GameExitInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Window_GameExitInfo")
    return
  end
  local originPos = self._ui.btn_BConsoleUI:GetPosX()
  if 0 == type then
    self._ui.btn_AConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_CONFIRM"))
    self._ui.btn_AConsoleUI:SetPosX(originPos - 140)
    self._ui.btn_AConsoleUI:SetShow(true)
  elseif 1 == type then
    if nil == idx then
      self._ui.btn_AConsoleUI:SetShow(false)
      return
    end
    local charInfo = self._currentCharacterInfoTable[idx]
    if true == charInfo._isSelfPlayer then
      self._ui.btn_AConsoleUI:SetShow(false)
      return
    end
    self._ui.btn_AConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_SWAP_CHARACTER_TITLE"))
    self._ui.btn_AConsoleUI:SetPosX(originPos - 220)
    self._ui.btn_AConsoleUI:SetShow(true)
  else
    self._ui.btn_AConsoleUI:SetShow(false)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui.stc_KeyGuideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function InputLBRB_GameExit_UpdateCurrentWheelValue(value)
  local self = Window_GameExitInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Window_GameExitInfo")
    return
  end
  if self._ui._body._button_RB:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(51, 6)
  end
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  self._currentWheelValue = self._currentWheelValue + value
  if self._currentWheelValue < 0 then
    self._currentWheelValue = 0
    return
  end
  if getCharacterDataCount() < self._currentWheelValue + self._config._maxCharacterSlot then
    self._currentWheelValue = self._currentWheelValue - 1
    return
  end
  if getCharacterDataCount() < self._config._maxCharacterSlot then
    self._currentWheelValue = 0
    return
  end
  PaGlobalFunc_GameExit_UpdateCharList()
end
function PaGlobalFunc_CharChangePhoto_Y()
  local self = Window_GameExitInfo
  if false == Panel_Window_GameExit:GetShow() then
    return
  end
  PaGlobalFunc_GameExit_SetShow(false, false)
  IsGameExitPhoto(true)
  IngameCustomize_Show()
  characterSlot_Index(self._selfPlayerIndex)
  self._isTakePhoto = true
end
function Window_GameExitInfo:XB_Control_Init()
  Panel_Window_GameExit:registerPadEvent(__eConsoleUIPadEvent_LB, "InputLBRB_GameExit_UpdateCurrentWheelValue(-1)")
  Panel_Window_GameExit:registerPadEvent(__eConsoleUIPadEvent_RB, "InputLBRB_GameExit_UpdateCurrentWheelValue(1)")
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_GameExit_luaLoadComplete")
