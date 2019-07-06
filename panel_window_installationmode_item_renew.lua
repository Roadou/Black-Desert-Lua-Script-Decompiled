local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_CCC = CppEnums.CashProductCategory
local UI_CIT = CppEnums.InstallationType
local IM = CppEnums.EProcessorInputMode
local Panel_Window_InstallationMode_Item_info = {
  _ui = {
    static_TitleBg = nil,
    staticText_Title_Top = nil,
    static_KeyGuide_ConsoleBG = nil,
    staticText_RS_Click_ConsoleUI = nil,
    staticText_RS_UpDown_ConsoleUI = nil,
    staticText_RS_LeftRight_ConsoleUI = nil,
    staticText_LS_ConsoleUI = nil,
    staticText_RS_ConsoleUI = nil,
    staticText_LB_RB_ConsoleUI = nil,
    staticText_LT_RT_ConsoleUI = nil,
    staticText_Y_ConsoleUI = nil,
    staticText_X_ConsoleUI = nil,
    staticText_A_ConsoleUI = nil,
    staticText_B_ConsoleUI = nil,
    static_Move = nil
  },
  _value = {
    currentMode = 0,
    isCanMove = false,
    isCanDelete = false
  },
  _config = {},
  _mode_Type_Enum = {
    InstallMode_None = 0,
    InstallMode_Translation = 1,
    InstallMode_Detail = 2,
    InstallMode_WatingConfirm = 3,
    InstallMode_Count = 4
  },
  _keyGuideString = {build = nil, install = nil},
  _keyGuide = {},
  _tabSlot = {},
  _screenGapSize = {x = 0, y = 0}
}
function Panel_Window_InstallationMode_Item_info:registEventHandler()
end
function Panel_Window_InstallationMode_Item_info:registerMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu_Item_Renew")
  registerEvent("onScreenResize", "FromClient_InstallationMode_item_Resize_Renew")
  registerEvent("FromClient_ChangeHousingInstallMode", "FromClient_ChangeHousingInstallMode_Item_Renew")
  registerEvent("FromClient_changePadCameraControlMode", "FromClient_ChangePadCameraControlMode_Item_Renew")
  Panel_House_InstallationMode_Item:RegisterUpdateFunc("PaGlobalFunc_InstallationMode_Item_UpdatePerFrame")
end
function Panel_Window_InstallationMode_Item_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_Item_info:initString()
  self._keyGuideString.build = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_BUILD")
  self._keyGuideString.install = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_INSTALL")
end
function Panel_Window_InstallationMode_Item_info:initValue()
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_Item_info:resize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_House_InstallationMode_Item:SetSize(sizeX, sizeY)
  Panel_House_InstallationMode_Item:SetPosXY(0, 0)
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_Item_info:childControl()
  self._ui.static_TitleBg = UI.getChildControl(Panel_House_InstallationMode_Item, "Static_TitleBg")
  self._ui.staticText_Title_Top = UI.getChildControl(self._ui.static_TitleBg, "StaticText_Title_Top")
  self._ui.static_KeyGuide_ConsoleBG = UI.getChildControl(Panel_House_InstallationMode_Item, "Static_KeyGuide_ConsoleBG")
  self._ui.staticText_RS_Click_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_Click_ConsoleUI")
  self._ui.staticText_RS_UpDown_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_UpDown_ConsoleUI")
  self._ui.staticText_RS_LeftRight_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_LeftRight_ConsoleUI")
  self._ui.staticText_LS_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LS_ConsoleUI")
  self._ui.staticText_RS_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_ConsoleUI")
  self._ui.staticText_LB_RB_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LB_RB_ConsoleUI")
  self._ui.staticText_LT_RT_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LT_RT_ConsoleUI")
  self._ui.staticText_Y_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_Y_ConsoleUI")
  self._ui.staticText_X_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_X_ConsoleUI")
  self._ui.staticText_A_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_A_ConsoleUI")
  self._ui.staticText_B_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_B_ConsoleUI")
  self._keyGuide = {
    self._ui.staticText_RS_Click_ConsoleUI,
    self._ui.staticText_RS_UpDown_ConsoleUI,
    self._ui.staticText_RS_LeftRight_ConsoleUI,
    self._ui.staticText_LS_ConsoleUI,
    self._ui.staticText_RS_ConsoleUI,
    self._ui.staticText_LB_RB_ConsoleUI,
    self._ui.staticText_LT_RT_ConsoleUI,
    self._ui.staticText_Y_ConsoleUI,
    self._ui.staticText_X_ConsoleUI,
    self._ui.staticText_A_ConsoleUI,
    self._ui.staticText_B_ConsoleUI
  }
  self._ui.static_Move = UI.getChildControl(Panel_House_InstallationMode_Item, "Static_Move")
end
function Panel_Window_InstallationMode_Item_info:setKeyGuide(modeType, isShowMove, isShowFix, isShowDelete, isShowCancel)
  for key, value in pairs(self._keyGuide) do
    value:SetShow(false)
  end
  local isRotatePossible = housing_isAvailableRotateSelectedObject()
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local isFixed, installationType, isPersonalTent
  if nil ~= houseWrapper then
    isFixed = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  end
  if nil ~= characterStaticWrapper then
    installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
    local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
    isPersonalTent = objectStaticWrapper:isPersonalTent()
  end
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    self._ui.staticText_RS_ConsoleUI:SetShow(true)
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  elseif self._mode_Type_Enum.InstallMode_Translation == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_LS_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    if true == isFixed then
      self._ui.staticText_LS_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_InstallationMode_House_ClickConfirm()")
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, 44, 10)
  elseif self._mode_Type_Enum.InstallMode_Detail == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_LS_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_InstallationMode_House_ClickConfirm()")
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  elseif self._mode_Type_Enum.InstallMode_WatingConfirm == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_Y_ConsoleUI,
      self._ui.staticText_X_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.install)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    if true == self._value.isCanDelete then
      self._ui.staticText_X_ConsoleUI:SetShow(true)
    end
    if true == self._value.isCanMove then
      self._ui.staticText_Y_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  end
end
function Panel_Window_InstallationMode_Item_info:setKeyPosX(parantControl, keyList)
  local space = 44
  local maxLength = 0
  for key, value in ipairs(keyList) do
    if true == value:GetShow() then
      local spaceFromRight = value:GetTextSizeX() + space
      maxLength = math.max(maxLength, spaceFromRight)
    end
  end
  local parantControlSizeX = parantControl:GetSizeX()
  for key, value in ipairs(keyList) do
    if true == value:GetShow() then
      value:SetPosX(parantControlSizeX - maxLength)
    end
  end
end
function Panel_Window_InstallationMode_Item_info:open()
  Panel_House_InstallationMode_Item:SetShow(true)
  if nil ~= housing_getCreatedCharacterStaticWrapper() then
    local objectStaticWrapper = housing_getCreatedCharacterStaticWrapper():getObjectStaticStatus()
    local isCheck = objectStaticWrapper:isHouseInstallationMinorWarCheck()
    if isCheck then
      PaGlobal_WarInfomation_Open()
    else
      PaGlobal_WarInfomation_Close()
    end
  end
end
function Panel_Window_InstallationMode_Item_info:close()
  Panel_House_InstallationMode_Item:SetShow(false)
end
function Panel_Window_InstallationMode_Item_info:readyToExit()
  PaGlobal_WarInfomation_Close()
end
function PaGlobalFunc_InstallationMode_Item_GetShow()
  return Panel_House_InstallationMode_Item:GetShow()
end
function PaGlobalFunc_InstallationMode_Item_Open()
  local self = Panel_Window_InstallationMode_Item_info
  self:open()
end
function PaGlobalFunc_InstallationMode_Item_Close()
  local self = Panel_Window_InstallationMode_Item_info
  self:close()
end
function PaGlobalFunc_InstallationMode_Item_Show()
  local self = Panel_Window_InstallationMode_Item_info
  InventoryWindow_Close()
  self:initValue()
  self:setKeyGuide(self._value.currentMode)
  self:open()
end
function PaGlobalFunc_InstallationMode_Item_Exit()
  local self = Panel_Window_InstallationMode_Item_info
  self:readyToExit()
  self:close()
end
function PaGlobalFunc_InstallationMode_Item_UpdatePerFrame(deltaTime)
  local self = Panel_Window_InstallationMode_Item_info
  local x = ToClient_GetVirtualMousePosX()
  local y = ToClient_GetVirtualMousePosY()
  self._ui.static_Move:SetPosX(x - self._screenGapSize.x)
  self._ui.static_Move:SetPosY(y - self._screenGapSize.y)
end
function PaGlobalFunc_InstallationMode_Item_ClickMove()
  housing_moveObject()
end
function PaGlobalFunc_InstallationMode_Item_ClickDelete()
  housing_deleteObject()
  PaGlobalFunc_InstallationMode_House_UpdateWish()
end
function PaGlobalFunc_InstallationMode_Item_ClickConfirm()
  local self = Panel_Window_InstallationMode_Item_info
  if housing_isBuildMode() then
    local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
    if nil ~= characterStaticWrapper then
      local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
      local isVillageTent = objectStaticWrapper:isVillageTent()
      if isVillageTent then
        PaGlobalFunc_VillageTentPopup_Open()
        return
      end
    end
    local regionKeyRaw = 0
    if nil ~= characterStaticWrapper then
      local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
      if objectStaticWrapper:isAdvancedBase() then
        local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
        if nil ~= myGuildInfo then
          local guildNo = myGuildInfo:getGuildNo_s64()
          if ToClient_IsInSiegeBattle(guildNo) then
            regionKeyRaw = Panel_HouseGetRegionRaw()
          end
        end
      end
    end
    housing_InstallObject(regionKeyRaw)
    PaGlobalFunc_InstallationMode_Manager_Exit()
  else
    PaGlobalFunc_InstallationMode_Manager_Exit()
  end
end
function PaGlobalFunc_InstallationMode_Item_ClickCancel()
  housing_CancelInstallObject()
  PaGlobalFunc_InstallationMode_UpdateWish()
end
function FromClient_InstallationMode_item_Init()
  local self = Panel_Window_InstallationMode_Item_info
  self:initialize()
end
function FromClient_InstallationMode_item_Resize_Renew()
  local self = Panel_Window_InstallationMode_Item_info
  self:resize()
end
function FromClient_ShowInstallationMenu_item_Renew(installMode, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  local self = Panel_Window_InstallationMode_Item_info
  if true == isShow then
    self:setKeyGuide(installMode, isShowMove, isShowFix, isShowDelete, isShowCancel)
  else
    self:setKeyGuide(installMode)
  end
end
function FromClient_ChangeHousingInstallMode_Item_Renew(preMode, nowMode)
  local self = Panel_Window_InstallationMode_Item_info
  self._value.currentMode = nowMode
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  elseif self._mode_Type_Enum.InstallMode_Translation == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  end
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    Panel_House_InstallationMode_Item:ignorePadSnapUpdate(false)
  else
    Panel_House_InstallationMode_Item:ignorePadSnapUpdate(true)
  end
end
function FromClient_ChangePadCameraControlMode_Item_Renew(canZoom)
  local self = Panel_Window_InstallationMode_Item_info
  self:setKeyGuide(self._value.currentMode)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_item_Init")
