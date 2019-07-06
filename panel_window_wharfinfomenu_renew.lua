local Panel_Window_WharfInfo_Menu_info = {
  _ui = {
    radioButton_Template = nil,
    static_A_ConsoleUI = nil,
    buttonList = {}
  },
  _value = {
    currentButtonCount = 0,
    lastSelectButtonIndex = 0,
    currentSelectButtonIndex = 0,
    selectedServantSlotNo = nil
  },
  _pos = {
    startPosX = 0,
    startPosY = 10,
    buttonSizeY = 0,
    buttonSpaceY = 0,
    buttonSpaceX = 5
  },
  _config = {maxButtonCount = 16},
  _enum = {eTYPE_SEALED = 0, eTYPE_UNSEALED = 1},
  _string = {
    unseal = nil,
    repair = nil,
    changeName = nil,
    destroyCountReset = nil,
    move = nil,
    lookChange = nil,
    sell = nil,
    seal = nil,
    remote = nil
  },
  _enumButtonType = {
    eNONE = 0,
    eUNSEAL = 1,
    eREPAIR = 2,
    eCHANGE_NAME = 3,
    eDEAD_RESET = 4,
    eSELL = 5,
    eMOVE = 6,
    eLOOK_CHANGE = 7,
    eSEAL = 31,
    eREMOTE = 32
  },
  _buttonFunc = {
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [31] = nil,
    [32] = nil,
    [33] = nil
  }
}
local servantInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
function Panel_Window_WharfInfo_Menu_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_WharfInfo_Menu_Resize")
end
function Panel_Window_WharfInfo_Menu_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:createControl()
  self:setPosControl()
  self:getStringTable()
  self:linkButtonFunction()
end
function Panel_Window_WharfInfo_Menu_info:initValue()
  self._value.selectedServantSlotNo = nil
  self._value.currentButtonCount = 0
  self._value.lastSelectButtonIndex = 0
  self._value.currentSelectButtonIndex = 0
end
function Panel_Window_WharfInfo_Menu_info:setServantNo(selectServantNo)
  self._value.selectedServantSlotNo = selectServantNo
end
function Panel_Window_WharfInfo_Menu_info:resize()
end
function Panel_Window_WharfInfo_Menu_info:childControl()
  self._ui.radioButton_Template = UI.getChildControl(Panel_Window_WharfInfo_Menu, "RadioButton_Template")
  self._ui.static_A_ConsoleUI = UI.getChildControl(self._ui.radioButton_Template, "Static_A_ConsoleUI")
  self._ui.radioButton_Template:SetShow(false)
  self._pos.buttonSizeY = self._ui.radioButton_Template:GetSizeY() + 5
end
function Panel_Window_WharfInfo_Menu_info:getStringTable()
  self._string.unseal = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_UNSEAL")
  self._string.repair = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REPAIR")
  self._string.changeName = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_CHANGENAME")
  self._string.destroyCountReset = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_DESTROYCOUNTRESET")
  self._string.lookChange = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_STABLEFUNCTION_LOOKCHANGE")
  self._string.sell = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_SELL")
  self._string.move = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLELIST_BUTTONMOVE")
  self._string.seal = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_FUNCTION_BTN_SEAL")
  self._string.remote = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_LIST_BTN_REMOTE")
end
function Panel_Window_WharfInfo_Menu_info:linkButtonFunction()
  self._buttonFunc[self._enumButtonType.eUNSEAL] = PaGlobalFunc_WharfInfo_Menu_Unseal
  self._buttonFunc[self._enumButtonType.eREPAIR] = PaGlobalFunc_WharfInfo_Menu_Recovery
  self._buttonFunc[self._enumButtonType.eCHANGE_NAME] = PaGlobalFunc_WharfInfo_Menu_ChangeName
  self._buttonFunc[self._enumButtonType.eDEAD_RESET] = PaGlobalFunc_WharfInfo_Menu_ClearDeadCount
  self._buttonFunc[self._enumButtonType.eSELL] = PaGlobalFunc_WharfInfo_Menu_SellToNpc
  self._buttonFunc[self._enumButtonType.eMOVE] = PaGlobalFunc_WharfInfo_Menu_Move
  self._buttonFunc[self._enumButtonType.eLOOK_CHANGE] = PaGlobalFunc_WharfInfo_Menu_LookChange
  self._buttonFunc[self._enumButtonType.eSEAL] = PaGlobalFunc_WharfInfo_Menu_Seal
  self._buttonFunc[self._enumButtonType.eREMOTE] = PaGlobalFunc_WharfInfo_Menu_RemoteSeal
end
function Panel_Window_WharfInfo_Menu_info:createControl()
  for index = 0, self._config.maxButtonCount - 1 do
    local slot = {}
    slot.buttonType = self._enumButtonType.eNONE
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_WharfInfo_Menu, "RadioButton_Template", Panel_Window_WharfInfo_Menu, "radioButton_Template_" .. index)
    slot.static_A = UI.createAndCopyBasePropertyControl(self._ui.radioButton_Template, "Static_A_ConsoleUI", slot.button, "static_A_ConsoleUI_" .. index)
    self._ui.buttonList[index] = slot
  end
end
function Panel_Window_WharfInfo_Menu_info:setPosControl()
  for index = 0, self._config.maxButtonCount - 1 do
    self._ui.buttonList[index].button:SetPosY(self._pos.startPosY + index * (self._pos.buttonSizeY + self._pos.buttonSpaceY))
  end
end
function Panel_Window_WharfInfo_Menu_info:clearButton()
  self._value.currentButtonCount = 0
  for index = 0, self._config.maxButtonCount - 1 do
    self._ui.buttonList[index].button:SetShow(false)
    self._ui.buttonList[index].button:SetCheck(false)
    self._ui.buttonList[index].static_A:SetShow(false)
    self._ui.buttonList[index].buttonType = self._enumButtonType.eNONE
  end
end
function Panel_Window_WharfInfo_Menu_info:readyToOpen(baseCotrol, eType, selectServantNo)
  if nil ~= baseCotrol then
    Panel_Window_WharfInfo_Menu:SetPosXY(baseCotrol:GetPosX() + baseCotrol:GetSizeX() + self._pos.buttonSpaceX, baseCotrol:GetPosY())
  end
  self:clearButton()
  if eType == self._enum.eTYPE_SEALED then
    self:setSealedButton(selectServantNo)
  elseif eType == self._enum.eTYPE_UNSEALED then
    self:setUnSealedButton()
  end
  self:setBgSize()
end
function Panel_Window_WharfInfo_Menu_info:setButton(buttonType, string, param)
  self._ui.buttonList[self._value.currentButtonCount].button:SetShow(true)
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_On", "PaGlobalFunc_WharfInfo_Menu_SelectButton(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_Out", "PaGlobalFunc_WharfInfo_Menu_OutFocus(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfInfo_Menu_ClickButton(" .. self._value.currentButtonCount .. ")")
  self._ui.buttonList[self._value.currentButtonCount].button:SetText(string)
  self._ui.buttonList[self._value.currentButtonCount].buttonType = buttonType
  self._value.currentButtonCount = self._value.currentButtonCount + 1
end
function Panel_Window_WharfInfo_Menu_info:setSealedButton(selectServantNo)
  local servantInfo = stable_getServant(selectServantNo)
  if nil == servantInfo then
    return
  elseif servantInfo:isChangingRegion() then
    PaGlobalFunc_WharfInfo_Menu_Close()
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local servantRegionName = servantInfo:getRegionName(selectServantNo)
  local getState = servantInfo:getStateType()
  local nowHp = servantInfo:getHp()
  local maxHp = servantInfo:getMaxHp()
  local nowMp = servantInfo:getMp()
  local maxMp = servantInfo:getMaxMp()
  local vehicleType = servantInfo:getVehicleType()
  local showChangeRegionButtonFlag = false
  if regionName == servantRegionName then
    self:setButton(self._enumButtonType.eUNSEAL, self._string.unseal)
    showChangeRegionButtonFlag = not servantInfo:isChangingRegion()
    if nowHp < maxHp then
      self:setButton(self._enumButtonType.eREPAIR, self._string.repair)
    end
    if nowHp == maxHp and nowMp < maxMp and (CppEnums.VehicleType.Type_PersonTradeShip == vehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == vehicleType) then
      self:setButton(self._enumButtonType.eREPAIR, self._string.repair)
    end
    if FGlobal_IsCommercialService() then
      self:setButton(self._enumButtonType.eCHANGE_NAME, self._string.changeName)
    end
    if (servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat) and FGlobal_IsCommercialService() then
      self:setButton(self._enumButtonType.eDEAD_RESET, self._string.destroyCountReset)
    end
    self:setButton(self._enumButtonType.eSELL, self._string.sell)
  elseif 0 == nowHp then
    self:setButton(self._enumButtonType.eREPAIR, self._string.repair)
  end
  if showChangeRegionButtonFlag and false then
    self:setButton(self._enumButtonType.eMOVE, self._string.move)
  end
  if true == _ContentsGroup_SailBoatCash and CppEnums.VehicleType.Type_PersonTradeShip == servantInfo:getVehicleType() then
    self:setButton(self._enumButtonType.eLOOK_CHANGE, self._string.lookChange)
  end
end
function Panel_Window_WharfInfo_Menu_info:setUnSealedButton()
  if false == isSiegeStable() then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    local unSealServantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    if nil == unSealServantInfo then
      return
    end
    self:setButton(self._enumButtonType.eSEAL, self._string.seal)
    self:setButton(self._enumButtonType.eREMOTE, self._string.remote)
  end
end
function Panel_Window_WharfInfo_Menu_info:tamingButton()
  self:setButton(self._enumButtonType.eTAMING, self._string.taming)
end
function Panel_Window_WharfInfo_Menu_info:readyToClose()
end
function Panel_Window_WharfInfo_Menu_info:setBgSize()
  local newSizeY = self._value.currentButtonCount * (self._pos.buttonSizeY + self._pos.buttonSpaceY) + self._pos.startPosY * 2 - 5
  Panel_Window_WharfInfo_Menu:SetSize(Panel_Window_WharfInfo_Menu:GetSizeX(), newSizeY)
end
function Panel_Window_WharfInfo_Menu_info:open()
  Panel_Window_WharfInfo_Menu:SetShow(true)
end
function Panel_Window_WharfInfo_Menu_info:close()
  Panel_Window_WharfInfo_Menu:SetShow(false)
end
function PaGlobalFunc_WharfInfo_Menu_GetShow()
  return Panel_Window_WharfInfo_Menu:GetShow()
end
function PaGlobalFunc_WharfInfo_Menu_Open()
  local self = Panel_Window_WharfInfo_Menu_info
  self:open()
end
function PaGlobalFunc_WharfInfo_Menu_Show(baseCotrol, eType, selectServantNo)
  local self = Panel_Window_WharfInfo_Menu_info
  self:initValue()
  self:setServantNo(selectServantNo)
  self:readyToOpen(baseCotrol, eType, selectServantNo)
  PaGlobalFunc_WharfInfo_Menu_SelectButton(self._value.currentSelectButtonIndex)
  if 0 == self._value.currentButtonCount then
    self:close()
  else
    self:open()
  end
end
function PaGlobalFunc_WharfInfo_Menu_Close()
  local self = Panel_Window_WharfInfo_Menu_info
  self:close()
end
function PaGlobalFunc_WharfInfo_Menu_OutFocus(index)
  local self = Panel_Window_WharfInfo_Menu_info
  self._ui.buttonList[index].static_A:SetShow(false)
  self._ui.buttonList[index].button:SetCheck(false)
end
function PaGlobalFunc_WharfInfo_Menu_SelectButton(index)
  local self = Panel_Window_WharfInfo_Menu_info
  self._value.lastSelectButtonIndex = self._value.currentSelectButtonIndex
  self._value.currentSelectButtonIndex = index
  self._ui.buttonList[self._value.lastSelectButtonIndex].static_A:SetShow(false)
  self._ui.buttonList[self._value.currentSelectButtonIndex].static_A:SetShow(true)
  self._ui.buttonList[self._value.lastSelectButtonIndex].button:SetCheck(false)
  self._ui.buttonList[self._value.currentSelectButtonIndex].button:SetCheck(true)
end
function PaGlobalFunc_WharfInfo_Menu_ClickButton(index)
  local self = Panel_Window_WharfInfo_Menu_info
  PaGlobalFunc_WharfInfo_Menu_SelectButton(index)
  local buttonType = self._ui.buttonList[index].buttonType
  local excuteFunction
  local buttonType = self._ui.buttonList[index].buttonType
  excuteFunction = self._buttonFunc[buttonType]
  if nil ~= excuteFunction then
    excuteFunction()
  else
  end
end
function PaGlobalFunc_WharfInfo_Menu_Seal()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  stable_seal(false)
  PaGlobalFunc_WharfInfo_Exit()
end
function PaGlobalFunc_WharfInfo_Menu_RemoteSeal()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local seal_Go = function()
    stable_seal(true)
    PaGlobalFunc_WharfInfo_Exit()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_ISCOMPULSION_MESSAGEBOX")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = seal_Go,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_WharfInfo_Menu_Unseal()
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local currentButtonServantNo = servantInfo:getServantNo()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  stable_unsealByServantNo(currentButtonServantNo)
  PaGlobalFunc_WharfInfo_Exit()
end
function PaGlobalFunc_WharfInfo_Menu_RecoveryXXX()
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(5, 7)
  stable_recovery(self._value.selectedServantSlotNo, MessageBoxCheck.isCheck())
  PaGlobalFunc_WharfInfo_Exit()
end
function PaGlobalFunc_WharfInfo_Menu_ReviveXXX()
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(5, 7)
  stable_revive(self._value.selectedServantSlotNo, MessageBoxCheck.isCheck())
  PaGlobalFunc_WharfInfo_Exit()
end
function PaGlobalFunc_WharfInfo_Menu_Recovery()
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local needMoney_64 = 0
  local needMoney = 0
  local strPrice, confirmFunction
  local isVehicleType = servantInfo:getVehicleType()
  if 0 == servantInfo:getHp() then
    needMoney_s64 = servantInfo:getReviveCost_s64()
    needMoney = Int64toInt32(needMoney_s64)
    confirmFunction = PaGlobalFunc_WharfInfo_Menu_ReviveXXX
  else
    needMoney_s64 = servantInfo:getRecoveryCost_s64()
    needMoney = Int64toInt32(needMoney_s64)
    confirmFunction = PaGlobalFunc_WharfInfo_Menu_RecoveryXXX
  end
  strPrice = string.format("%d", needMoney)
  if CppEnums.VehicleType.Type_SailingBoat == isVehicleType or CppEnums.VehicleType.Type_PersonalBattleShip == isVehicleType or CppEnums.VehicleType.Type_PersonTradeShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == isVehicleType or CppEnums.VehicleType.Type_CashPersonalBattleShip == isVehicleType then
    local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SHIP_RECOVERY_NOTIFY_MSG", "needMoney", makeDotMoney(strPrice))
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE"),
      content = messageboxMemo,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageboxData)
  else
    local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_CARRIAGE_RECOVERY_NOTIFY_MSG", "needMoney", makeDotMoney(strPrice))
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_RECOVERY_NOTIFY_TITLE"),
      content = messageboxMemo,
      functionApply = confirmFunction,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageboxData)
  end
end
function PaGlobalFunc_WharfInfo_Menu_ChangeName()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local executeChangeName = function()
    PaGlobalFunc_WharfRegister_OpenByRename()
    PaGlobalFunc_WharfInfo_CloseWith()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_POPMSGBOX_CHANGENAME_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = executeChangeName,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_WharfInfo_Menu_ClearDeadCount()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local function clearDeadCountDo()
    stable_clearDeadCount(self._value.selectedServantSlotNo)
    PaGlobalFunc_WharfInfo_Exit()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_KILLCOUNTRESET_ALLRECOVERY")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = clearDeadCountDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_WharfInfo_Menu_Stamping(isImprint)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  isImprint = true
  local function imprint()
    stable_imprint(self._value.selectedServantSlotNo, isImprint)
    PaGlobalFunc_WharfInfo_Exit()
  end
  if false == isImprint then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_SERVANT_ISIMPRINT_RECOVERY")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_STAMPING_IS_DISCOUNT")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = imprint,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
local lookIndex = 0
local currentPage = 0
function PaGlobalFunc_WharfInfo_Menu_LookChange()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  currentPage = 0
end
function PaGlobalFunc_WharfInfo_Menu_SellToNpcXXX()
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  stable_changeToReward(self._value.selectedServantSlotNo, CppEnums.ServantToRewardType.Type_Experience)
  PaGlobalFunc_WharfInfo_Exit()
end
function PaGlobalFunc_WharfInfo_Menu_SellToNpc()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
  local servantInfo = stable_getServant(self._value.selectedServantSlotNo)
  if nil == servantInfo then
    return
  end
  local wharfInvenAlert = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_SELL_WITHITEM_MSG")
  local resultMoney = makeDotMoney(servantInfo:getSellCost_s64())
  Servant_Confirm(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_TITLE"), PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_STABEL_SELL_NOTIFY_MSG", "resultMoney", resultMoney) .. wharfInvenAlert, PaGlobalFunc_WharfInfo_Menu_SellToNpcXXX, MessageBox_Empty_function)
end
function PaGlobalFunc_WharfInfo_Menu_Move()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfInfo_Menu_info
  if nil == self._value.selectedServantSlotNo then
    return
  end
end
function FromClient_WharfInfo_Menu_Init()
  local self = Panel_Window_WharfInfo_Menu_info
  self:initialize()
end
function FromClient_WharfInfo_Menu_Resize()
  local self = Panel_Window_WharfInfo_Menu_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WharfInfo_Menu_Init")
