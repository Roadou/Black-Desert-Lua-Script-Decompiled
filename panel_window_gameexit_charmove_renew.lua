local Window_GameExit_CharMoveInfo = {
  _ui = {
    _static_Bottom = UI.getChildControl(Panel_Window_GameExit_CharMove, "Static_Bottom"),
    _static_main = UI.getChildControl(Panel_Window_GameExit_CharMove, "Static_Main"),
    _bottom = {},
    _main = {},
    _button_NoticeMsg = UI.getChildControl(Panel_Window_GameExit_CharMove, "Button_NoticeMsg")
  },
  _config = {_maxCharacterSlot = 5},
  _characterWheelValue = 0,
  _regionWheelvalue = 0,
  _currentCharacterIndex = -1,
  _currentRegionIndex = -1,
  _characterInfoTable = {},
  _currentCharacterInfoTable = {},
  _characterUITable = {},
  _deliveryRegionTable = {},
  _exitTime = -1
}
function Window_GameExit_CharMoveInfo:SetNoticeMsg(delayTime)
  local msg
  if nil == delayTime then
    self._ui._button_NoticeMsg:SetIgnore(true)
    msg = PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_GO_SWAPCHARACTER")
  else
    self._ui._button_NoticeMsg:SetIgnore(false)
    msg = PAGetStringParam1(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_COMMENT_TO_CHARACTER_CHANGE", "remainTime", tostring(delayTime))
  end
  self._ui._button_NoticeMsg:SetShow(true)
  self._ui._button_NoticeMsg:SetText(msg)
end
function Window_GameExit_CharMoveInfo:SetDeliveryRegion()
  local deliveryPersonInfoList = ToClient_DeliveryPersonInfo()
  local deliverySize = deliveryPersonInfoList:size()
  if deliverySize < 0 then
    return
  end
  for index = 0, deliverySize - 1 do
    local deliveryPersonInfo = deliveryPersonInfoList:atPointer(index)
    local destinationRegionInfo = deliveryPersonInfo:getRegionInfo()
    local regionInfoWrapper = getRegionInfoWrapper(destinationRegionInfo._regionKey:get())
    self._deliveryRegionTable[index] = regionInfoWrapper:getAreaName()
  end
end
function Window_GameExit_CharMoveInfo:Clear()
  self._currentCharacterInfoTable = {}
  self._characterWheelValue = 0
  self._regionWheelvalue = 0
  self._currentCharacterIndex = -1
  self._currentRegionIndex = -1
  self._exitTime = -1
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_Slot:SetCheck(false)
  end
end
function Window_GameExit_CharMoveInfo:Update()
  self._characterInfoTable = {}
  self._characterInfoTable = PaGlobalFunc_GameExit_GetCharInfoTable()
  self:SetDeliveryRegion()
end
function PaGlobalFunc_GameExitCharMove_ButtonClick_Cancel()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_GameExitCharMove_SetShow(false, false)
  PaGlobalFunc_GameExit_SetShow(true, false)
end
function PaGlobalFunc_GameExitCharMove_ButtonClick_Confirm()
  local self = Window_GameExit_CharMoveInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  if 0 == #self._deliveryRegionTable or nil == self._deliveryRegionTable[self._currentRegionIndex] then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_NotDestination"))
    return
  end
  if -1 == self._currentCharacterIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectCharacter"))
    return
  end
  local characterData = getCharacterDataByIndex(self._currentCharacterIndex)
  if nil == characterData then
    return
  end
  local classType = getCharacterClassType(characterData)
  local characterNo_64 = getSelfPlayer():getCharacterNo_64()
  if characterNo_64 == characterData._characterNo_s64 then
    return
  end
  if true == ToClient_IsCustomizeOnlyClass(classType) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_PERSON_NOTCHANGE"))
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
  local preText = ""
  local serverUtc64 = getServerUtc64()
  if 0 ~= characterData._arrivalRegionKey:get() and serverUtc64 < characterData._arrivalTime then
    preText = PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectPcDelivery2") .. "\n"
  end
  local messageContent = preText .. PAGetStringParam2(Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(self._currentCharacterIndex)))
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_Information"),
    content = messageContent,
    functionYes = PaGlobalFunc_GameExitCharMove_ChacacterMoveConfirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_GameExitCharMove_ChacacterMoveConfirm()
  local self = Window_GameExit_CharMoveInfo
  local deliveryPersonInfoList = ToClient_DeliveryPersonInfo()
  local deliveryPersonInfo = deliveryPersonInfoList:atPointer(self._currentRegionIndex)
  local destRegionInfo = deliveryPersonInfo:getRegionInfo()
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  deliveryPerson_SendReserve(destRegionInfo._regionKey:get())
end
function PaGlobalFunc_FromClient_GameExitCharMove_luaLoadComplete()
  local self = Window_GameExit_CharMoveInfo
  self:Initialize()
end
function Window_GameExit_CharMoveInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_GameExitCharMove_ButtonClick_CharacterSlot(index)
  local self = Window_GameExit_CharMoveInfo
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self._currentCharacterIndex = self._characterWheelValue + index
end
function PaGlobalFunc_GameExitCharMove_UpdateRegionList(value)
  local self = Window_GameExit_CharMoveInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self._regionWheelvalue = self._regionWheelvalue + value
  if self._regionWheelvalue < 0 then
    self._regionWheelvalue = 0
  end
  if #self._deliveryRegionTable < self._regionWheelvalue then
    self._regionWheelvalue = #self._deliveryRegionTable
  end
  self._currentRegionIndex = self._regionWheelvalue
  self._ui._main._staticText_RegionName:SetText(self._deliveryRegionTable[self._currentRegionIndex])
end
function PaGlobalFunc_GameExitCharMove_UpdateChararcterList(value)
  local self = Window_GameExit_CharMoveInfo
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  self:Clear()
  self._characterWheelValue = self._characterWheelValue + value
  if self._characterWheelValue < 0 then
    self._characterWheelValue = 0
  end
  if getCharacterDataCount() < self._characterWheelValue + self._config._maxCharacterSlot then
    self._characterWheelValue = self._characterWheelValue - 1
  end
  if getCharacterDataCount() < self._config._maxCharacterSlot then
    self._characterWheelValue = 0
  end
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_Slot:SetShow(false)
    local isSuccess = self:SetCharacterSlot(self._characterInfoTable[index + self._characterWheelValue], self._characterUITable[index])
    if false == isSuccess then
      return
    end
    self._characterUITable[index]._radioButton_Slot:SetShow(true)
    self._currentCharacterInfoTable[index] = self._characterInfoTable[index + self._characterWheelValue]
  end
end
function Window_GameExit_CharMoveInfo:SetCharacterSlot(charInfo, charSlot)
  if nil == charInfo or nil == charSlot then
    return false
  end
  charSlot._staticText_Level:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_LEVEL") .. charInfo._level)
  charSlot._staticText_Name:SetText(charInfo._name)
  local isCaptureExist = charSlot._static_Picture:ChangeTextureInfoNameNotDDS(charInfo._textureName, charInfo._classType, false)
  if true == isCaptureExist then
    charSlot._static_Picture:getBaseTexture():setUV(0, 0, 1, 1)
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
  return true
end
function Window_GameExit_CharMoveInfo:InitControl()
  local self = Window_GameExit_CharMoveInfo
  local bottom = self._ui._bottom
  local main = self._ui._main
  self._ui._button_Confirm = UI.getChildControl(self._ui._static_Bottom, "Button_Confirm")
  self._ui._button_Cancel = UI.getChildControl(self._ui._static_Bottom, "Button_Cancel")
  main._button_RB = UI.getChildControl(self._ui._static_main, "Button_RB")
  main._button_LB = UI.getChildControl(self._ui._static_main, "Button_LB")
  main._staticText_RegionName = UI.getChildControl(self._ui._static_main, "StaticText_RegionName")
  bottom._button_RT = UI.getChildControl(self._ui._static_Bottom, "Button_RT")
  bottom._button_LT = UI.getChildControl(self._ui._static_Bottom, "Button_LT")
  bottom._staticText_Desc = UI.getChildControl(self._ui._static_Bottom, "StaticText_Desc")
  bottom._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  bottom._staticText_Desc:SetTextHorizonCenter()
  bottom._button_RT:SetShow(5 < getCharacterDataCount())
  bottom._button_LT:SetShow(5 < getCharacterDataCount())
  local baseSlotBg = UI.getChildControl(self._ui._static_Bottom, "RadioButton_Slot1_G0")
  local baseSlot = {
    _radioButton_Slot = baseSlotBg,
    _static_Picture = UI.getChildControl(baseSlotBg, "Static_CharacterImage"),
    _staticText_Level = UI.getChildControl(baseSlotBg, "StaticText_Level"),
    _staticText_Name = UI.getChildControl(baseSlotBg, "StaticText_CharacterName")
  }
  local UCT = CppEnums.PA_UI_CONTROL_TYPE
  for index = 0, self._config._maxCharacterSlot - 1 do
    local uiTable = {
      _radioButton_Slot,
      _static_Picture,
      _staticText_Level,
      _staticText_Name
    }
    uiTable._radioButton_Slot = UI.createControl(UCT.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_Bottom, "radioButton_Slot_" .. index)
    CopyBaseProperty(baseSlot._radioButton_Slot, uiTable._radioButton_Slot)
    uiTable._static_Picture = UI.createControl(UCT.PA_UI_CONTROL_STATIC, uiTable._radioButton_Slot, "static_Picture_" .. index)
    CopyBaseProperty(baseSlot._static_Picture, uiTable._static_Picture)
    uiTable._staticText_Level = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_Slot, "staticText_Level_" .. index)
    CopyBaseProperty(baseSlot._staticText_Level, uiTable._staticText_Level)
    uiTable._staticText_Name = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, uiTable._radioButton_Slot, "staticText_Name_" .. index)
    CopyBaseProperty(baseSlot._staticText_Name, uiTable._staticText_Name)
    uiTable._radioButton_Slot:SetPosX(uiTable._radioButton_Slot:GetPosX() + (uiTable._radioButton_Slot:GetSizeX() + 10) * index)
    uiTable._radioButton_Slot:SetShow(false)
    self._characterUITable[index] = uiTable
  end
  for _, control in pairs(baseSlot) do
    control:SetShow(false)
    UI.deleteControl(control)
  end
end
function PaGlobalFunc_GameExitCharMove_UpdatePerFrame(deltaTime)
  local self = Window_GameExit_CharMoveInfo
  if -1 == self._exitTime then
    return
  end
  self._exitTime = self._exitTime - deltaTime
  self:SetNoticeMsg(Int64toInt32(self._exitTime))
  if self._exitTime >= 0 then
    return
  end
  self:SetNoticeMsg()
  self._exitTime = -1
end
function PaGlobalFunc_GameExitCharMove_ButtonClick_ExitCancel()
  local self = Window_GameExit_CharMoveInfo
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  if false == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  if 2 < self._exitTime then
    sendGameDelayExitCancel()
    self._exitTime = -1
  end
end
function Window_GameExit_CharMoveInfo:InitEvent()
  local bottom = self._ui._bottom
  local main = self._ui._main
  Panel_Window_GameExit_CharMove:RegisterUpdateFunc("PaGlobalFunc_GameExitCharMove_UpdatePerFrame")
  self._ui._button_NoticeMsg:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExit_ButtonClick_ExitCancel()")
  self._ui._button_Cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_ButtonClick_Cancel()")
  self._ui._button_Confirm:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_ButtonClick_Confirm()")
  main._button_RB:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_UpdateRegionList(1)")
  main._button_LB:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_UpdateRegionList(-1)")
  bottom._button_RT:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_UpdateChararcterList(1)")
  bottom._button_LT:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_UpdateChararcterList(-1)")
  for index = 0, self._config._maxCharacterSlot - 1 do
    self._characterUITable[index]._radioButton_Slot:addInputEvent("Mouse_LUp", "PaGlobalFunc_GameExitCharMove_ButtonClick_CharacterSlot(" .. index .. ")")
  end
end
function PaGlobalFunc_FromClient_GameExitCharMove_SetDelayTime(delayTime)
  local self = Window_GameExit_CharMoveInfo
  if false == PaGlobalFunc_GameExitCharMove_GetShow() then
    return
  end
  self._exitTime = delayTime
  self:SetNoticeMsg(delayTime)
end
function PaGlobalFunc_FromClient_GameExitCharMove_GameExit()
  local self = Window_GameExit_CharMoveInfo
  if false == PaGlobalFunc_GameExitCharMove_GetShow() then
    return
  end
  local rv = swapCharacter_Select(self._currentCharacterIndex, true)
  if false == rv then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\139\164\237\140\168\235\139\164")
  end
end
function PaGlobalFunc_GameExitCharMove_Resize()
end
function Window_GameExit_CharMoveInfo:InitRegister()
  registerEvent("onScreenResize", "PaGlobalFunc_GameExitCharMove_Resize")
  registerEvent("EventDeliveryForPersonChangeCharacter", "PaGlobalFunc_FromClient_GameExitCharMove_GameExit()")
  registerEvent("EventGameExitDelayTime", "PaGlobalFunc_FromClient_GameExitCharMove_SetDelayTime")
end
function PaGlobalFunc_GameExitCharMove_SetShow(isShow, isAni)
  local self = Window_GameExit_CharMoveInfo
  if true == self._ui._button_NoticeMsg:GetShow() then
    return
  end
  if true == isShow then
    sendWaitingListOfMyCharacters()
    SetUIMode(Defines.UIMode.eUIMode_GameExit)
    self:Clear()
    self:Update()
    PaGlobalFunc_GameExitCharMove_UpdateChararcterList(0)
    PaGlobalFunc_GameExitCharMove_UpdateRegionList(0)
  else
    SetUIMode(Defines.UIMode.eUIMode_Default)
    if true == self._ui._button_NoticeMsg:GetShow() then
      PaGlobalFunc_GameExitCharMove_ButtonClick_ExitCancel()
    end
  end
  Panel_Window_GameExit_CharMove:SetShow(isShow, isAni)
end
function PaGlobalFunc_GameExitCharMove_GetShow()
  return Panel_Window_GameExit_CharMove:GetShow()
end
function PaGlobalFunc_GameExitCharMove_Toggle()
  PaGlobalFunc_GameExitCharMove_SetShow(not PaGlobalFunc_GameExitCharMove_GetShow(), false)
end
Panel_Window_GameExit_CharMove:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_GameExitCharMove_UpdateRegionList(-1)")
Panel_Window_GameExit_CharMove:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_GameExitCharMove_UpdateRegionList(1)")
Panel_Window_GameExit_CharMove:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_GameExitCharMove_UpdateChararcterList(-1)")
Panel_Window_GameExit_CharMove:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_GameExitCharMove_UpdateChararcterList(1)")
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_GameExitCharMove_luaLoadComplete")
