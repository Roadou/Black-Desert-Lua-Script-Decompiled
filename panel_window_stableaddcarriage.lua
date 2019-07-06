Panel_AddToCarriage:SetShow(false, false)
Panel_AddToCarriage:setMaskingChild(true)
Panel_AddToCarriage:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local stableCarriage = {
  _staticIcon1 = UI.getChildControl(Panel_AddToCarriage, "Static_ServantIcon_1"),
  _staticIcon2 = UI.getChildControl(Panel_AddToCarriage, "Static_ServantIcon_2"),
  _staticInfo1 = UI.getChildControl(Panel_AddToCarriage, "StaticText_Info1"),
  _staticInfo2 = UI.getChildControl(Panel_AddToCarriage, "StaticText_Info2"),
  _staticNotify = UI.getChildControl(Panel_AddToCarriage, "StaticText_Notify"),
  _buttonAdd = UI.getChildControl(Panel_AddToCarriage, "Button_Add"),
  _buttonCancel = UI.getChildControl(Panel_AddToCarriage, "Button_Cancel"),
  _buttonClose = UI.getChildControl(Panel_AddToCarriage, "Button_Close"),
  _staticPrice = UI.getChildControl(Panel_AddToCarriage, "StaticText_Price"),
  _slotNo1 = nil,
  _slotNo2 = nil
}
function stableCarriage:init()
  self._slotNo1 = nil
  self._slotNo2 = nil
  self._staticInfo1:SetText("")
  self._staticInfo2:SetText("")
  self._staticIcon1:SetShow(false)
  self._staticIcon2:SetShow(false)
  self._staticNotify:SetShow(true)
  self._staticNotify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LINK_DESC_1"))
  Panel_AddToCarriage:SetPosX((getScreenSizeX() - Panel_AddToCarriage:GetSizeX()) / 2)
  Panel_AddToCarriage:SetPosY((getScreenSizeY() - Panel_AddToCarriage:GetSizeY()) / 3)
end
function stableCarriage:update()
  self._staticIcon1:SetShow(false)
  self._staticIcon2:SetShow(false)
  self._staticInfo1:SetShow(false)
  self._staticInfo2:SetShow(false)
  if nil ~= self._slotNo1 then
    local servantInfo1 = stable_getServant(self._slotNo1)
    if nil ~= servantInfo1 then
      self._staticIcon1:ChangeTextureInfoName(servantInfo1:getIconPath1())
      self._staticInfo1:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. servantInfo1:getLevel() .. " " .. servantInfo1:getName())
      self._staticInfo1:SetShow(true)
      self._staticIcon1:SetShow(true)
    end
  end
  if nil ~= self._slotNo2 then
    local servantInfo2 = stable_getServant(self._slotNo2)
    if nil ~= servantInfo2 then
      self._staticIcon2:ChangeTextureInfoName(servantInfo2:getIconPath1())
      self._staticInfo2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. servantInfo2:getLevel() .. " " .. servantInfo2:getName())
      self._staticInfo2:SetShow(true)
      self._staticIcon2:SetShow(true)
    end
  end
  if nil ~= self._slotNo1 or nil ~= self._slotNo2 then
    self._staticNotify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LINK_DESC_1"))
  end
  if nil ~= self._slotNo1 and nil ~= self._slotNo2 then
    self._staticNotify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLELIST_LINK_DESC_2"))
  end
end
function stableCarriage:registEventHandler()
  self._buttonAdd:addInputEvent("Mouse_LUp", "stableCarriage_Add()")
  self._buttonCancel:addInputEvent("Mouse_LUp", "stableCarriage_Close()")
  self._buttonClose:addInputEvent("Mouse_LUp", "stableCarriage_Close()")
  self._staticIcon1:addInputEvent("Mouse_RUp", "stableCarriage_ClearSlot( 1 )")
  self._staticIcon2:addInputEvent("Mouse_RUp", "stableCarriage_ClearSlot( 2 )")
end
function stableCarriage:registMessageHandler()
  registerEvent("onScreenResize", "stableCarriage_Resize")
end
function stableCarriage_Add()
  local self = stableCarriage
  if nil == self._slotNo1 or nil == self._slotNo2 then
    return
  end
  stable_link(self._slotNo2, self._slotNo1, true)
  stableCarriage_Close()
  FGlobal_StableList_Update()
  StableInfo_Close()
end
function stableCarriage_ClearSlot(slotType)
  local self = stableCarriage
  if 1 == slotType then
    self._slotNo1 = nil
    self._staticNotify:SetShow(true)
  else
    self._slotNo2 = nil
    self._staticNotify:SetShow(true)
  end
  self:update()
end
function stableCarriage_Set(slotNo, slotIndex)
  local self = stableCarriage
  local servantInfo
  if nil == slotIndex then
    servantInfo = stable_getServant(slotNo)
  else
    servantInfo = stable_getServant(slotNo)
  end
  if nil == servantInfo then
    return
  end
  local vehicleType = servantInfo:getVehicleType()
  if CppEnums.VehicleType.Type_Carriage == vehicleType or CppEnums.VehicleType.Type_RepairableCarriage == vehicleType then
    self._slotNo1 = slotNo
  elseif CppEnums.VehicleType.Type_Horse == vehicleType then
    self._slotNo2 = slotNo
  end
  self:update()
end
function stableCarriage_Open()
  if Panel_AddToCarriage:GetShow() then
    return
  end
  if Panel_Window_StableMarket:GetShow() then
    StableMarket_Close()
  end
  if Panel_Window_StableMating:GetShow() then
    StableMating_Close()
  end
  if Panel_Window_StableMix:GetShow() then
    StableMix_Close()
  end
  PaGlobalFunc_ServantRentPromoteMarketClose()
  local self = stableCarriage
  self:init()
  self:update()
  Panel_AddToCarriage:SetShow(true)
end
function stableCarriage_Close()
  local self = stableCarriage
  if not Panel_AddToCarriage:GetShow() then
    return
  end
  Panel_AddToCarriage:SetShow(false)
end
function stableCarriage_Resize()
  local self = stableCarriage
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_AddToCarriage:ComputePos()
  self._staticIcon1:ComputePos()
  self._staticIcon2:ComputePos()
end
stableCarriage:init()
stableCarriage:registEventHandler()
stableCarriage:registMessageHandler()
stableCarriage_Resize()
