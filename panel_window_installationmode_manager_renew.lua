local renderMode = RenderModeWrapper.new(99, {
  Defines.RenderMode.eRenderMode_HouseInstallation
}, false)
local Panel_Window_InstallationMode_Manager_info = {
  _value = {
    isInstallMode = false,
    isBuildMode = false,
    houseInstallationMode = false,
    plantInstallationMode = false,
    isMyHouse = false,
    currentMode = 0,
    isCanControl = false,
    isConfirm = false,
    isCanMove = false,
    isCanDelete = false,
    isCanCancel = false
  },
  _mode_Type_Enum = {
    InstallMode_None = 0,
    InstallMode_Translation = 1,
    InstallMode_Detail = 2,
    InstallMode_WatingConfirm = 3,
    InstallMode_Count = 4
  }
}
function Panel_Window_InstallationMode_Manager_info:registEventHandler()
end
function Panel_Window_InstallationMode_Manager_info:registerMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu_Manager_Renew")
  registerEvent("EventHousingCancelInstallObjectMessageBox", "FromClient_CancelInstallObject_Manager_Renew")
  registerEvent("EventHousingCancelInstallModeMessageBox", "FromClient_CancelInstallModeMessageBox_Manager_Renew")
  registerEvent("EventHousingShowHousingModeUI", "FromClient_ShowHousingModeUI_Manager_Renew")
  registerEvent("FromClient_ChangeHousingInstallMode", "FromClient_ChangeHousingInstallMode_Manager_Renew")
  renderMode:setClosefunctor(renderMode, PaGlobalFunc_InstallationMode_Manager_Exit)
end
function Panel_Window_InstallationMode_Manager_info:initialize()
  self:initValue()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_Manager_info:initValue()
  self._value.isInstallMode = false
  self._value.houseInstallationMode = false
  self._value.plantInstallationMode = false
  self._value.isMyHouse = false
  self._value.currentMode = 0
  self._value.isCanControl = false
  self._value.isConfirm = false
  self._value.isCanMove = false
  self._value.isCanDelete = false
end
function Panel_Window_InstallationMode_Manager_info:readyToShow()
  ToClient_SaveUiInfo(false)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if not IsSelfPlayerWaitAction() and not IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE"))
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  if housing_isBuildMode() then
    self._value.isInstallMode = false
    self._value.isBuildMode = true
  else
    self._value.isInstallMode = true
    self._value.isBuildMode = false
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    if nil == houseWrapper then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
      return
    end
    self._value.houseInstallationMode = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
    self._value.plantInstallationMode = not self._value.houseInstallationMode
    if self._value.houseInstallationMode then
      self._value.isMyHouse = getSelfPlayer():get():isMyHouseVisiting()
    else
      self._value.isMyHouse = false
    end
    local rv = housing_changeHousingMode(true, self._value.isMyHouse)
    if 0 ~= rv then
      _PA_LOG("\236\167\128\235\175\188\237\152\129", "housing_changeHousingMode Failed...")
      return
    end
  end
  audioPostEvent_SystemUi(1, 32)
  _AudioPostEvent_SystemUiForXBOX(1, 32)
  SetUIMode(Defines.UIMode.eUIMode_Housing)
  renderMode:set()
  crossHair_SetShow(false)
  setShowLine(false)
end
function Panel_Window_InstallationMode_Manager_info:show()
  if true == self._value.isInstallMode then
    if true == self._value.houseInstallationMode then
      PaGlobalFunc_InstallationMode_House_Show()
    end
    if true == self._value.plantInstallationMode then
      PaGlobalFunc_InstallationMode_Farm_Show()
    end
  end
  if true == self._value.isBuildMode then
    PaGlobalFunc_InstallationMode_Item_Show()
    do
      local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
      if nil ~= characterStaticWrapper then
        local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
        local isCheck = objectStaticWrapper:isHouseInstallationMinorWarCheck()
        if isCheck then
        end
      end
    end
  else
  end
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_BUILDMODE")
end
function Panel_Window_InstallationMode_Manager_info:open_ItemInstallMode(isShow)
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  if nil ~= characterStaticWrapper then
    local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
    local isCheck = objectStaticWrapper:isHouseInstallationMinorWarCheck()
    if isCheck then
    end
  else
  end
end
function Panel_Window_InstallationMode_Manager_info:readyToExit()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  crossHair_SetShow(true)
  setShowLine(true)
  housing_changeHousingMode(false, false)
  ClearFocusEdit()
  InventoryWindow_Close()
  PaGlobalFunc_InstallationMode_Manager_InitInput()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function Panel_Window_InstallationMode_Manager_info:exit()
  PaGlobalFunc_InstallationMode_House_Exit()
  PaGlobalFunc_InstallationMode_Farm_Exit()
  PaGlobalFunc_InstallationMode_PlantInfo_Exit()
  PaGlobalFunc_InstallationMode_Item_Exit()
end
function PaGlobalFunc_InstallationMode_Manager_Show()
  local self = Panel_Window_InstallationMode_Manager_info
  self:initValue()
  self:readyToShow()
  self:show()
end
function PaGlobalFunc_InstallationMode_Manager_Exit()
  local self = Panel_Window_InstallationMode_Manager_info
  self:readyToExit()
  self:exit()
end
function PaGlobalFunc_InstallationMode_Manager_InitInput()
  self._value.isCanControl = false
  self._value.isConfirm = false
  self._value.isCanMove = false
  self._value.isCanDelete = false
end
function PaGlobalFunc_InstallationMode_Manager_CanGetInput()
  local self = Panel_Window_InstallationMode_Manager_info
  if Panel_Win_System:GetShow() then
    return false
  end
  return self._value.currentMode ~= self._mode_Type_Enum.InstallMode_None
end
function PaGlobalFunc_InstallationMode_Manager_CanGetConfirm()
  local self = Panel_Window_InstallationMode_Manager_info
  return self._value.isConfirm
end
function PaGlobalFunc_InstallationMode_Manager_CanGetMove()
  local self = Panel_Window_InstallationMode_Manager_info
  return self._value.isCanMove
end
function PaGlobalFunc_InstallationMode_Manager_CanGetDelete()
  local self = Panel_Window_InstallationMode_Manager_info
  return self._value.isCanDelete
end
function PaGlobalFunc_InstallationMode_Manager_GetMyHouse()
  local self = Panel_Window_InstallationMode_Manager_info
  return self._value.isMyHouse
end
function PaGlobalFunc_InstallationMode_Manager_GetInstallMode()
  local self = Panel_Window_InstallationMode_Manager_info
  return self._value.isInstallMode
end
function HandleClicked_HouseInstallation_Exit_ByAttacked()
  if housing_isBuildMode() or housing_isInstallMode() then
    PaGlobalFunc_InstallationMode_Manager_Exit()
  end
end
function FromClient_InstallationMode_Manager_Init()
  local self = Panel_Window_InstallationMode_Manager_info
  self:initialize()
end
function FromClient_ShowInstallationMenu_Manager_Renew(installMode, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  local posX = housing_getInstallationMenuPosX()
  local posY = housing_getInstallationMenuPosY()
  local self = Panel_Window_InstallationMode_Manager_info
  self._value.isCanMove = isShowMove
  self._value.isCanDelete = isShowDelete
  self._value.isCanCancel = isShowCancel
end
function FromClient_CancelInstallObject_Manager_Renew()
end
function FromClient_CancelInstallMode_Manager_Renew()
end
function FromClient_ShowHousingModeUI_Manager_Renew(isShow)
  PaGlobalFunc_InstallationMode_Manager_Show()
end
function FromClient_CancelInstallModeMessageBox_Manager_Renew()
  local messageBox_HouseInstallation_Exit_DO = function()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    PaGlobalFunc_InstallationMode_Manager_Exit()
  end
  local messageBox_HouseInstallaion_Default_Cancel_function = function()
    if housing_isInstallMode() then
      if housing_isTemporaryObject() then
        housing_moveObject()
      end
    else
      housing_moveObject()
    end
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_MEMO")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = messageBox_HouseInstallation_Exit_DO,
    functionCancel = messageBox_HouseInstallaion_Default_Cancel_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  local isExist = MessageBox.doHaveMessageBoxData(messageboxData.title)
  if false == isExist then
    MessageBox.showMessageBox(messageboxData)
  end
end
function FromClient_ChangeHousingInstallMode_Manager_Renew(preMode, nowMode)
  local self = Panel_Window_InstallationMode_Manager_info
  self._value.currentMode = nowMode
  if true == self._value.isBuildMode then
    if self._mode_Type_Enum.InstallMode_Detail == self._value.currentMode then
      self._value.isConfirm = true
    else
      self._value.isConfirm = false
    end
  end
  if true == self._value.isInstallMode then
    if self._mode_Type_Enum.InstallMode_WatingConfirm == self._value.currentMode then
      self._value.isConfirm = true
    else
      self._value.isConfirm = false
      self._value.isCanDelete = false
    end
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_Manager_Init")
