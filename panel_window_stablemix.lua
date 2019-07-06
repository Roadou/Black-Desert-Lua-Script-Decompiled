Panel_Window_StableMix:SetShow(false, false)
Panel_Window_StableMix:setMaskingChild(true)
Panel_Window_StableMix:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_WHERETYPE = CppEnums.ItemWhereType
local UI_TM = CppEnums.TextMode
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
local stableMix = {
  _staticIcon1 = UI.getChildControl(Panel_Window_StableMix, "Static_ServantIcon_1"),
  _staticIcon2 = UI.getChildControl(Panel_Window_StableMix, "Static_ServantIcon_2"),
  _staticInfo1 = UI.getChildControl(Panel_Window_StableMix, "StaticText_Info1"),
  _staticInfo2 = UI.getChildControl(Panel_Window_StableMix, "StaticText_Info2"),
  _iconStallion1 = UI.getChildControl(Panel_Window_StableMix, "Static_iconStallion1"),
  _iconStallion2 = UI.getChildControl(Panel_Window_StableMix, "Static_iconStallion2"),
  _staticNotify = UI.getChildControl(Panel_Window_StableMix, "StaticText_Notify"),
  _editName = UI.getChildControl(Panel_Window_StableMix, "Edit_Naming"),
  _buttonMix = UI.getChildControl(Panel_Window_StableMix, "Button_Mix"),
  _buttonCancel = UI.getChildControl(Panel_Window_StableMix, "Button_Cancel"),
  _buttonClose = UI.getChildControl(Panel_Window_StableMix, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_StableMix, "Button_Question"),
  _staticPrice = UI.getChildControl(Panel_Window_StableMix, "StaticText_Price"),
  _chkInven = UI.getChildControl(Panel_Window_StableMix, "RadioButton_Icon_Money"),
  _chkWare = UI.getChildControl(Panel_Window_StableMix, "RadioButton_Icon_Money2"),
  _invenMoney = UI.getChildControl(Panel_Window_StableMix, "Static_Text_Money"),
  _wareMoney = UI.getChildControl(Panel_Window_StableMix, "Static_Text_Money2"),
  _servantNo1 = nil,
  _servantNo2 = nil
}
function stableMix:init()
  self._staticInfo1:SetText("")
  self._staticInfo2:SetText("")
  self._staticIcon1:SetShow(false)
  self._staticIcon2:SetShow(false)
  self._editName:SetMaxInput(getGameServiceTypeServantNameLength())
  self._editName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  self._staticNotify:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._staticNotify:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANTMIX_NOTIFY"))
  self._staticNotify:SetShow(true)
  self._editName:SetShow(false)
  Panel_Window_StableMix:SetPosX((getScreenSizeX() - Panel_Window_StableMix:GetSizeX()) / 2)
  Panel_Window_StableMix:SetPosY((getScreenSizeY() - Panel_Window_StableMix:GetSizeY()) / 3)
end
function stableMix:update()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local invenMoney = selfPlayer:get():getInventory():getMoney_s64()
  local wareMoney = warehouse_moneyFromNpcShop_s64()
  self._staticIcon1:SetShow(false)
  self._staticIcon2:SetShow(false)
  self._staticInfo1:SetShow(false)
  self._staticInfo2:SetShow(false)
  self._iconStallion1:SetShow(false)
  self._iconStallion2:SetShow(false)
  local matingServantPrice = getServantSelfMatingPrice()
  if nil ~= self._servantNo1 then
    local servantInfo1 = stable_getServantByServantNo(self._servantNo1)
    if nil ~= servantInfo1 then
      self._staticIcon1:ChangeTextureInfoName(servantInfo1:getIconPath1())
      if isContentsStallionEnable then
        self._iconStallion1:SetShow(true)
        local isStallion = servantInfo1:isStallion()
        if true == isStallion then
          self._iconStallion1:SetMonoTone(false)
        else
          self._iconStallion1:SetMonoTone(true)
        end
      end
      self._staticInfo1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. servantInfo1:getLevel() .. " " .. servantInfo1:getName())
      self._staticInfo1:SetShow(true)
      self._staticIcon1:SetShow(true)
    end
  end
  if nil ~= self._servantNo2 then
    local servantInfo2 = stable_getServantByServantNo(self._servantNo2)
    if nil ~= servantInfo2 then
      self._staticIcon2:ChangeTextureInfoName(servantInfo2:getIconPath1())
      if isContentsStallionEnable then
        self._iconStallion2:SetShow(true)
        local isStallion = servantInfo2:isStallion()
        if true == isStallion then
          self._iconStallion2:SetMonoTone(false)
        else
          self._iconStallion2:SetMonoTone(true)
        end
      end
      self._staticInfo2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. servantInfo2:getLevel() .. " " .. servantInfo2:getName())
      self._staticInfo2:SetShow(true)
      self._staticIcon2:SetShow(true)
    end
  end
  if nil ~= self._servantNo1 or nil ~= self._servantNo2 then
    self._staticNotify:SetShow(true)
    self._editName:SetShow(false)
  end
  if nil ~= self._servantNo1 and nil ~= self._servantNo2 then
    self._staticNotify:SetShow(false)
    self._staticPrice:SetShow(true)
    self._editName:SetShow(true)
    self._staticPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEMIX_MATINGPRICE", "matingServantPrice", makeDotMoney(matingServantPrice)))
  end
  self._chkInven:SetEnableArea(0, 0, self._chkInven:GetTextSizeX() + self._invenMoney:GetTextSizeX(), self._chkInven:GetTextSizeY())
  self._chkWare:SetEnableArea(0, 0, self._chkWare:GetTextSizeX() + self._wareMoney:GetTextSizeX(), self._chkWare:GetTextSizeY())
  self._invenMoney:SetText(makeDotMoney(invenMoney))
  self._wareMoney:SetText(makeDotMoney(wareMoney))
  local warehouseMoneyEnabledFlag = wareMoney > Defines.s64_const.s64_0
  self._chkWare:SetEnable(warehouseMoneyEnabledFlag)
  if not warehouseMoneyEnabledFlag then
    self._chkInven:SetCheck(true)
    self._chkWare:SetCheck(false)
  end
end
function stableMix:registEventHandler()
  self._buttonMix:addInputEvent("Mouse_LUp", "StableMix_Mix()")
  self._buttonCancel:addInputEvent("Mouse_LUp", "StableMix_Close()")
  self._buttonClose:addInputEvent("Mouse_LUp", "StableMix_Close()")
  self._editName:addInputEvent("Mouse_LUp", "StableMix_ClearEdit()")
  self._staticIcon1:addInputEvent("Mouse_RUp", "stableMix_ClearSlot( 1 )")
  self._staticIcon2:addInputEvent("Mouse_RUp", "stableMix_ClearSlot( 2 )")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowStableShop\" )")
end
function stableMix:registMessageHandler()
  registerEvent("onScreenResize", "StableMix_Resize")
  registerEvent("FromClient_ServantMix", "FromClient_ServantMix")
end
function StableMix_Mix()
  local self = stableMix
  local name = self._editName:GetEditText()
  local isEditShow = self._editName:GetShow()
  if not isEditShow then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_SELECTMIX_PLS")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_EXCHANGE_CONFIRM"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local editNameString = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT")
  if editNameString == name then
    local messageBoxMemo = editNameString
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_EXCHANGE_CONFIRM"),
      content = messageBoxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if nil == self._servantNo1 or nil == self._servantNo2 then
    return
  end
  local whereType = UI_WHERETYPE.eInventory
  local function servantMix()
    if self._chkInven:IsCheck() then
      whereType = UI_WHERETYPE.eInventory
    else
      whereType = UI_WHERETYPE.eWarehouse
    end
    stable_mix(self._servantNo1, self._servantNo2, whereType, name)
  end
  local messageBoxMemo = ""
  if isContentsStallionEnable then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_TEXT_MIXHELPMSG")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMIX_TEXT_MIXHELPMSG2")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_EXCHANGE_CONFIRM"),
    content = messageBoxMemo,
    functionYes = servantMix,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  self._editName:SetEditText("", true)
end
function stableMix_ClearSlot(slotType)
  local self = stableMix
  if 1 == slotType then
    self._servantNo1 = nil
    self._staticPrice:SetShow(false)
    self._editName:SetShow(false)
    self._staticNotify:SetShow(true)
  else
    self._servantNo2 = nil
    self._staticPrice:SetShow(false)
    self._editName:SetShow(false)
    self._staticNotify:SetShow(true)
  end
  self:update()
end
function StableMix_Set(slotNo)
  local self = stableMix
  local servantInfo = stable_getServant(slotNo)
  if nil == servantInfo then
    return
  end
  local vehicleType = servantInfo:getVehicleType()
  if CppEnums.VehicleType.Type_Horse ~= vehicleType then
    return
  end
  if servantInfo:isMale() then
    self._servantNo1 = servantInfo:getServantNo()
  else
    self._servantNo2 = servantInfo:getServantNo()
  end
  self:update()
end
function StableMix_ClearEdit()
  local self = stableMix
  self._editName:SetEditText("", true)
  SetFocusEdit(self._editName)
end
function FromClient_ServantMix(servantNo1, servantNo2)
  local self = stableMix
  local servantInfo1 = stable_getServantByServantNo(servantNo1)
  local servantName1 = servantInfo1:getName()
  local servantInfo2 = stable_getServantByServantNo(servantNo2)
  local servantName2 = servantInfo2:getName()
  Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_STABLEMIX_MIX_ACK", "servantName1", servantName1, "servantName2", servantName2))
  StableMix_Close()
end
function StableMix_Open()
  local self = stableMix
  if Panel_Window_StableMix:GetShow() then
    return
  end
  if Panel_Window_StableMarket:GetShow() then
    StableMarket_Close()
  end
  if Panel_Window_StableMating:GetShow() then
    StableMating_Close()
  end
  if Panel_AddToCarriage:GetShow() then
    stableCarriage_Close()
  end
  PaGlobalFunc_ServantRentPromoteMarketClose()
  self:init()
  self._chkInven:SetCheck(false)
  self._chkWare:SetCheck(true)
  self:update()
  stableMix_ClearSlot(1)
  stableMix_ClearSlot(2)
  Panel_Window_StableMix:SetShow(true)
end
function StableMix_Close()
  local self = StableMix
  if not Panel_Window_StableMix:GetShow() then
    return
  end
  Panel_Window_StableMix:SetShow(false)
end
function StableMix_Resize()
  local self = stableMix
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_StableMix:ComputePos()
  self._staticIcon1:ComputePos()
  self._staticIcon2:ComputePos()
end
stableMix:init()
stableMix:registEventHandler()
stableMix:registMessageHandler()
StableMix_Resize()
