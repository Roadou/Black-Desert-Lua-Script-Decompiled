local isMaidContentsEnable = ToClient_IsContentsGroupOpen("355")
local Panel_Widget_HousingName_info = {
  _ui = {
    static_Arrow_Left = nil,
    static_Arrow_Right = nil,
    staticText_Host_Title = nil,
    staticText_Adress = nil,
    staticText_HousingPoint = nil,
    static_InstallMode = nil,
    static_Dpad_Up = nil,
    staticText_UnderWear = nil,
    static_Dpad_Left = nil,
    static_Inventory = nil,
    static_DpadDown = nil,
    staticText_PetAndMade = nil,
    static_DpadRight = nil
  },
  _value = {
    togglePetAndMadeShow = false,
    isMyHouse = false,
    updateCheckWidget = 0,
    updateTextTime = 0,
    isAlertHouseLighting = false,
    prevPoint = 0
  },
  _pos = {arrowGap = 10},
  _config = {},
  _enum = {eTOGGLE_UNDERWEAR = 0, eTOGGLE_PETANDMADE = 1}
}
function Panel_Widget_HousingName_info:registEventHandler()
end
function Panel_Widget_HousingName_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_HousingName_Resize")
  registerEvent("FromClient_RenderModeChangeState", "PaGlobalFunc_HousingName_CheckHouseRender")
  registerEvent("EventHousingShowVisitHouse", "PaGlobalFunc_HousingName_EventHousingShowVisitHouse")
  registerEvent("FromClient_ChangeUnderwearModeInHouse", "FromClient_HousingName_ChangeUnderwearModeInHouse")
  registerEvent("EventProcessorInputModeChange", "PaGlobalFunc_HousingName_InputModeChange")
  Panel_HouseName:RegisterUpdateFunc("PaGlobalFunc_HousingName_UpdatePerFrame")
end
function Panel_Widget_HousingName_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Widget_HousingName_info:initPetAndMadeToggle()
  self._value.togglePetAndMadeShow = false
end
function Panel_Widget_HousingName_info:initValue()
  self:initPetAndMadeToggle()
  self._value.isMyHouse = false
  self._value.updateCheckWidget = 0
  self._value.updateTextTime = 0
  self._value.isAlertHouseLighting = false
end
function Panel_Widget_HousingName_info:resize()
  Panel_HouseName:ComputePos()
end
function Panel_Widget_HousingName_info:childControl()
  self._ui.static_Arrow_Left = UI.getChildControl(Panel_HouseName, "Static_Arrow_Left")
  self._ui.static_Arrow_Right = UI.getChildControl(Panel_HouseName, "Static_Arrow_Right")
  self._ui.staticText_Host_Title = UI.getChildControl(Panel_HouseName, "StaticText_Host_Title")
  self._ui.staticText_Adress = UI.getChildControl(Panel_HouseName, "StaticText_Adress")
  self._ui.staticText_HousingPoint = UI.getChildControl(Panel_HouseName, "StaticText_HousingPoint")
  self._ui.static_InstallMode = UI.getChildControl(Panel_HouseName, "Static_InstallMode")
  self._ui.static_Dpad_Up = UI.getChildControl(Panel_HouseName, "Static_Dpad_Up")
  self._ui.staticText_UnderWear = UI.getChildControl(Panel_HouseName, "StaticText_UnderWear")
  self._ui.static_Dpad_Left = UI.getChildControl(Panel_HouseName, "Static_Dpad_Left")
  self._ui.static_Inventory = UI.getChildControl(Panel_HouseName, "Static_Inventory")
  self._ui.static_DpadDown = UI.getChildControl(Panel_HouseName, "Static_DpadDown")
  self._ui.staticText_PetAndMade = UI.getChildControl(Panel_HouseName, "StaticText_PetAndMade")
  self._ui.static_DpadRight = UI.getChildControl(Panel_HouseName, "Static_DpadRight")
end
function Panel_Widget_HousingName_info:setContent()
end
function Panel_Widget_HousingName_info:open()
  Panel_HouseName:SetShow(true)
  PaGlobal_ConsoleQuickMenu:widgetClose()
end
function Panel_Widget_HousingName_info:close()
  Panel_HouseName:SetShow(false)
  PaGlobal_ConsoleQuickMenu:widgetOpen()
end
function Panel_Widget_HousingName_info:setUnderWear(isUnderWear)
  if true == isUnderWear then
    self._ui.staticText_UnderWear:SetText("OFF")
  else
    self._ui.staticText_UnderWear:SetText("ON")
  end
end
function Panel_Widget_HousingName_info:setPetAndMade(isShow)
  if true == isShow then
    self._ui.staticText_PetAndMade:SetText("OFF")
  else
    self._ui.staticText_PetAndMade:SetText("ON")
  end
end
function Panel_Widget_HousingName_info:setArrowPos()
  local textSize = self._ui.staticText_Host_Title:GetTextSizeX()
  local startPos = Panel_HouseName:GetSizeX() / 2 - textSize / 2 - self._pos.arrowGap - self._ui.static_Arrow_Left:GetSizeX()
  local endPos = Panel_HouseName:GetSizeX() / 2 + textSize / 2 + self._pos.arrowGap
  self._ui.static_Arrow_Left:SetPosX(startPos)
  self._ui.static_Arrow_Right:SetPosX(endPos)
end
function PaGlobalFunc_HousingName_GetShow()
  return Panel_HouseName:GetShow()
end
function PaGlobalFunc_HousingName_Open()
  local self = Panel_Widget_HousingName_info
  self:open()
end
function PaGlobalFunc_HousingName_Close()
  local self = Panel_Widget_HousingName_info
  self:close()
end
function PaGlobalFunc_HousingName_Exit()
  local self = Panel_Widget_HousingName_info
  PaGlobalFunc_HousingName_InitializeModeClose_PetMaidInit()
  self:close()
end
function PaGlobalFunc_HousingName_InitializeModeClose_PetMaidInit()
  local self = Panel_Widget_HousingName_info
  self:initPetAndMadeToggle()
  if true == isMaidContentsEnable then
    housing_setHideMaidInHouse(self._value.togglePetAndMadeShow)
  end
  housing_setHidePetInHouse(self._value.togglePetAndMadeShow)
  self:setPetAndMade(self._value.togglePetAndMadeShow)
end
function PaGlobalFunc_HousingName_InstallationMode()
  if getInputMode() == CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOT_ENTER_HOUSINGMODE_CHATMODE"))
    return
  end
  PaGlobalFunc_InstallationMode_Manager_Show()
  local isShow = housing_getIsHideMaidActors()
end
function PaGlobalFunc_HousingName_ToggleHideWear()
  local self = Panel_Widget_HousingName_info
  if not IsSelfPlayerWaitAction() or IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_UNDERWEAR"))
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local underWear = selfPlayer:get():getUnderwearModeInhouse()
  self:setUnderWear(not underWear)
  if underWear then
    selfPlayer:get():setUnderwearModeInhouse(false)
    Toclient_setShowAvatarEquip()
  else
    selfPlayer:get():setUnderwearModeInhouse(true)
  end
end
function PaGlobalFunc_HousingName_ToggleHideMadeAndPet()
  local self = Panel_Widget_HousingName_info
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  self._value.togglePetAndMadeShow = not self._value.togglePetAndMadeShow
  self:setPetAndMade(self._value.togglePetAndMadeShow)
  if true == isMaidContentsEnable then
    housing_setHideMaidInHouse(self._value.togglePetAndMadeShow)
  end
  housing_setHidePetInHouse(self._value.togglePetAndMadeShow)
end
function PaGlobalFunc_HousingName_ShowInven()
  InventoryWindow_Show()
end
function PaGlobalFunc_HousingName_CheckHouseRender(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if true == PaGlobalFunc_HousingName_GetShow() then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    if nil == houseWrapper then
      PaGlobalFunc_HousingName_Close()
    end
  end
end
function PaGlobalFunc_HousingName_EventHousingShowVisitHouse(isShow, houseName, userNickname, point, isMine)
  local self = Panel_Widget_HousingName_info
  self:initValue()
  local isShowUnderwear = getSelfPlayer():get():getUnderwearModeInhouse()
  self:setUnderWear(isShowUnderwear)
  if false == ToClient_isAdultUser() then
    self._ui.staticText_UnderWear:SetMonoTone(true)
    self._ui.static_Dpad_Left:SetMonoTone(true)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "")
  else
    self._ui.staticText_UnderWear:SetMonoTone(true)
    self._ui.static_Dpad_Left:SetMonoTone(false)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "PaGlobalFunc_HousingName_ToggleHideWear()")
  end
  if true == isMaidContentsEnable then
    housing_setHideMaidInHouse(self._value.togglePetAndMadeShow)
  end
  housing_setHidePetInHouse(self._value.togglePetAndMadeShow)
  self:setPetAndMade(self._value.togglePetAndMadeShow)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    self:close()
    PaGlobalFunc_HousingName_LightingReset()
    return
  end
  self._value.isMyHouse = isMine
  local isInnRoom = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  local isFixedHouse = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse()
  if isFixedHouse then
    self._ui.static_InstallMode:SetMonoTone(true)
    self._ui.static_Dpad_Up:SetMonoTone(true)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadUp, "")
    return
  elseif isInnRoom then
    if isMine then
      self._ui.static_InstallMode:SetMonoTone(false)
      self._ui.static_Dpad_Up:SetMonoTone(false)
      Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadUp, "")
    elseif FGlobal_IsCommercialService() then
      self._ui.static_InstallMode:SetMonoTone(false)
      self._ui.static_Dpad_Up:SetMonoTone(false)
      Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadUp, "")
    else
      self._ui.static_InstallMode:SetMonoTone(true)
      self._ui.static_Dpad_Up:SetMonoTone(true)
      Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadUp, "")
    end
  else
    self._ui.static_InstallMode:SetMonoTone(true)
    self._ui.static_Dpad_Up:SetMonoTone(true)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadUp, "")
  end
  self._ui.staticText_Host_Title:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSING_HOUSENAME_LIVING", "user_nickname", userNickname))
  self:setArrowPos()
  self._ui.staticText_Adress:SetText(houseName)
  self._ui.staticText_HousingPoint:SetText(tostring(point))
  if Panel_Housing:IsShow() then
    return
  end
  if Panel_House_InstallationMode:GetShow() then
    return
  end
  if Panel_Interaction_HouseRank:GetShow() then
    Panel_Interaction_HouseRanke_Close()
  end
  if isGameTypeKR2() then
    self._ui.staticText_UnderWear:SetMonoTone(true)
    self._ui.static_Dpad_Left:SetMonoTone(true)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "")
  else
    self._ui.staticText_UnderWear:SetMonoTone(false)
    self._ui.static_Dpad_Left:SetMonoTone(false)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "PaGlobalFunc_HousingName_ToggleHideWear()")
  end
  if true == isShow then
    self:open()
  else
    self:close()
  end
end
function PaGlobal_GetHouseNamePoint()
  local self = Panel_Widget_HousingName_info
  return self._value.prevPoint
end
function PaGlobalFunc_HousingName_UpdatePerFrame(deltaTime)
  PaGlobalFunc_HousingName_LightingCheck(deltaTime)
  PaGlobalFunc_HousingName_CheckWidget(deltaTime)
end
function PaGlobalFunc_HousingName_CheckWidget(deltaTime)
  if false == PaGlobalFunc_HousingName_GetShow() then
    return
  end
  local self = Panel_Widget_HousingName_info
  self._value.updateCheckWidget = self._value.updateCheckWidget + deltaTime
  if 1 == math.ceil(self._value.updateTextTime) then
    PaGlobal_ConsoleQuickMenu:widgetClose(false)
    self._value.updateTextTime = 0
  end
end
function PaGlobalFunc_HousingName_LightingCheck(deltaTime)
  local self = Panel_Widget_HousingName_info
  self._value.updateTextTime = self._value.updateTextTime + deltaTime
  if false == self._value.isAlertHouseLighting and 5 == math.ceil(self._value.updateTextTime) then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    local isHaveLightInstallation = houseWrapper:isHaveLightInstallation()
    if true == isHaveLightInstallation then
    else
    end
    self._value.isAlertHouseLighting = true
  end
end
function PaGlobalFunc_HousingName_LightingReset()
  local self = Panel_Widget_HousingName_info
  self._value.updateTextTime = 0
  self._value.isAlertHouseLighting = false
end
function FGlobal_AlertHouseLightingReset()
  PaGlobalFunc_HousingName_LightingReset()
end
function FromClient_HousingName_Init()
  local self = Panel_Widget_HousingName_info
  self:initialize()
end
function FromClient_HousingName_Resize()
  local self = Panel_Widget_HousingName_info
  self:resize()
end
function FromClient_HousingName_ChangeUnderwearModeInHouse(isUnderwearModeInHouse)
  local self = Panel_Widget_HousingName_info
  self:setUnderWear(isUnderwearModeInHouse)
  if false == ToClient_isAdultUser() then
    self._ui.staticText_UnderWear:SetMonoTone(true)
    self._ui.static_Dpad_Left:SetMonoTone(true)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "")
  else
    self._ui.staticText_UnderWear:SetMonoTone(false)
    self._ui.static_Dpad_Left:SetMonoTone(false)
    Panel_HouseName:registerPadEvent(__eConsoleUIPadEvent_Up_DpadLeft, "PaGlobalFunc_HousingName_ToggleHideWear()")
  end
end
function PaGlobalFunc_HousingName_InputModeChange(prevMode, currentMode)
  local self = Panel_Widget_HousingName_info
  if false == Panel_HouseName:GetShow() then
    return
  end
  local isShow
  if currentMode == CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode then
    isShow = true
  else
    isShow = false
  end
  self._ui.static_Dpad_Up:SetShow(isShow)
  self._ui.static_Dpad_Left:SetShow(isShow)
  self._ui.static_DpadDown:SetShow(isShow)
  self._ui.static_DpadRight:SetShow(isShow)
  self._ui.static_InstallMode:SetShow(isShow)
  self._ui.staticText_UnderWear:SetShow(isShow)
  self._ui.static_Inventory:SetShow(isShow)
  self._ui.staticText_PetAndMade:SetShow(isShow)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_HousingName_Init")
