local ManufactureNotifier = {
  _init = false,
  _panel = Panel_Manufacture_Notify,
  _ui = {
    progress_BG = nil,
    progress_Bar = nil,
    progress_Text = nil,
    progress_Effect = nil,
    type_Name = nil,
    result_Title = nil
  },
  _item_Resource = {},
  _icon_ResourceBG = {},
  _icon_Resource = {},
  _item_Result = {},
  _icon_ResultBG = {},
  _icon_Result = {},
  _template = {
    item_Resource = nil,
    icon_ResourceBG = nil,
    icon_Resource = nil,
    item_Result = nil,
    icon_ResultBG = nil,
    icon_Result = nil
  },
  _data_Resource = {},
  _data_Result = {},
  _gapY = 40,
  _defalutSpanY = 0,
  _failCount = 0,
  _successCount = 0,
  _warehouseWayPointKey = CppEnums.WaypointKeyUndefined
}
function ManufactureNotifier:initialize()
  if self._init then
    return
  end
  self._init = true
  self._ui.progress_BG = UI.getChildControl(self._panel, "Static_Progress_BG")
  self._ui.progress_Bar = UI.getChildControl(self._panel, "Progress2_Manufacture")
  self._ui.progress_Text = UI.getChildControl(self._panel, "StaticText_Manufacture_Progress")
  self._ui.progress_Effect = UI.getChildControl(self._panel, "Static_Progress_Effect")
  self._ui.type_Name = UI.getChildControl(self._panel, "StaticText_Manufacture_Type")
  self._ui.result_Title = UI.getChildControl(self._panel, "StaticText_Result_Title")
  self._template.item_Resource = UI.getChildControl(self._panel, "StaticText_ResourceItem")
  self._template.icon_ResourceBG = UI.getChildControl(self._panel, "Static_ResourceIcon_BG")
  self._template.icon_Resource = UI.getChildControl(self._panel, "Static_ResourceIcon")
  self._template.item_Result = UI.getChildControl(self._panel, "StaticText_ResultItem")
  self._template.icon_ResultBG = UI.getChildControl(self._panel, "Static_ResultIcon_BG")
  self._template.icon_Result = UI.getChildControl(self._panel, "Static_ResultIcon")
  for key, value in pairs(self._template) do
    value:SetShow(false)
  end
  self._defalutSpanY = self._panel:GetSpanSize().y
  self._ui.result_Title:SetText(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_RESULT"))
  self._ui.progress_Effect:AddEffect("UI_Quest_Complete_GreenAura", true, 15, 0)
  self._panel:RegisterUpdateFunc("PaGlobalFunc_ManufactureNotifierPerFrameUpdate")
  FromClient_ManufactureNotifier_RePosition()
  registerEvent("onScreenResize", "FromClient_ManufactureNotifier_RePosition")
  registerEvent("EventChangedSelfPlayerActionVariable", "PaGlobalFunc_ManufactureNotifierHandleActionChange")
end
function PaGlobalFunc_ManufactureNotifierInit()
  if ManufactureNotifier:initialize() then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:handleActionChange(variableName, value)
  local isManufactureProgress = variableName == "IsManufactureChk"
  if not isManufactureProgress then
    return
  end
  if value == 0 then
    return self:close()
  end
  return true
end
function PaGlobalFunc_ManufactureNotifierHandleActionChange(variableName, value)
  if ManufactureNotifier:handleActionChange(variableName, value) then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:clear()
  self._data_Resource = {}
  self._data_Result = {}
  self._ui.progress_Bar:SetSmoothMode(false)
  self._ui.progress_Bar:SetProgressRate(0)
  for key, value in pairs(self._item_Resource) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_ResourceBG) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_Resource) do
    value:SetShow(false)
  end
  for key, value in pairs(self._item_Result) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_ResultBG) do
    value:SetShow(false)
  end
  for key, value in pairs(self._icon_Result) do
    value:SetShow(false)
  end
  self._failCount = 0
  self._successCount = 0
end
function ManufactureNotifier:open(materialTable, warehouseWayPointKey)
  if self:checkShow() then
    return false
  end
  self:clear()
  self._warehouseWayPointKey = warehouseWayPointKey
  for i = 1, table.getn(materialTable) do
    local material = materialTable[i]
    if not material:checkEmpty() then
      local itemWrapper = material:getItem(warehouseWayPointKey)
      local itemStaticWrapper = itemWrapper:getStaticStatus()
      local itemCount = Int64toInt32(itemWrapper:get():getCount_s64())
      local resource = {}
      resource = {}
      resource._slotNo = material.slotNo
      resource._key = material.itemKey
      resource._name = itemStaticWrapper:getName()
      resource._iconPath = "Icon/" .. itemStaticWrapper:getIconPath()
      resource._originalCnt = itemCount
      resource._currentCnt = itemCount
      resource.itemWhereType = material.itemWhereType
      table.insert(self._data_Resource, resource)
      if false == itemStaticWrapper:isStackable() then
        doHaveNonStackableItem = true
      end
    end
  end
  self._panel:SetShow(true)
  return true
end
function PaGlobalFunc_ManufactureNotifierOpen(materialTable, warehouseWayPointKey)
  if ManufactureNotifier:open(materialTable, warehouseWayPointKey) then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:close()
  if not self:checkShow() then
    return false
  end
  self._panel:SetShow(false)
end
function ManufactureNotifier:checkShow()
  return self._panel:GetShow()
end
function ManufactureNotifier:back()
end
function ManufactureNotifier:update()
  local rate = 0
  for i, resource in pairs(self._data_Resource) do
    local currentRate = (resource._originalCnt - resource._currentCnt) / resource._originalCnt
    if rate < currentRate then
      rate = currentRate
    end
    self:updateResourceControl(i)
    self._item_Resource[i]:SetText(resource._name .. " (" .. resource._currentCnt .. ")")
    self._icon_Resource[i]:ChangeTextureInfoName(resource._iconPath)
    self._item_Resource[i]:SetShow(true)
    self._icon_Resource[i]:SetShow(true)
    self._icon_ResourceBG[i]:SetShow(true)
    self._icon_ResourceBG[i]:SetEnableArea(0, 0, self._icon_ResourceBG[i]:GetSizeX() + self._item_Resource[i]:GetTextSizeX(), self._icon_ResourceBG[i]:GetSizeY())
  end
  local percent = math.floor(rate * 100)
  if 0 < self._successCount then
    self._ui.progress_Bar:SetSmoothMode(true)
  end
  self._ui.progress_Bar:SetProgressRate(percent)
  self._ui.progress_Text:SetText(percent .. "%")
  for i, result in pairs(self._data_Result) do
    self:updateResultControl(i)
    self._item_Result[i]:SetText(result._name .. " (" .. result._currentCnt .. ")")
    self._icon_Result[i]:ChangeTextureInfoName(result._iconPath)
    self._item_Result[i]:SetShow(true)
    self._icon_Result[i]:SetShow(true)
    self._icon_ResultBG[i]:SetShow(true)
    self._icon_ResultBG[i]:SetEnableArea(-self._item_Result[i]:GetTextSizeX(), 0, self._icon_ResultBG[i]:GetSizeX(), self._icon_ResultBG[i]:GetSizeY())
  end
  if 0 < #self._data_Result then
    self._ui.result_Title:SetShow(true)
  else
    self._ui.result_Title:SetShow(false)
  end
end
function ManufactureNotifier:perFrameUpdate()
  if self:checkShow() and table.getn(self._data_Resource) <= 0 then
    return self:close()
  end
end
function PaGlobalFunc_ManufactureNotifierPerFrameUpdate()
  if ManufactureNotifier:perFrameUpdate() then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:responseSuccess(itemDynamicListWrapper)
  self._failCount = 0
  self._successCount = self._successCount + 1
  for index = 0, itemDynamicListWrapper:getSize() - 1 do
    local itemDynamicInformationWrapper = itemDynamicListWrapper:getElement(index)
    local ItemEnchantStaticStatusWrapper = itemDynamicInformationWrapper:getStaticStatus()
    local itemKey = ItemEnchantStaticStatusWrapper:get()._key
    local s64_stackCount = Int64toInt32(itemDynamicInformationWrapper:getCount_s64())
    local idx
    for i, result in pairs(self._data_Result) do
      if result._key:getItemKey() == itemKey:getItemKey() then
        idx = i
      end
    end
    if nil == idx then
      idx = #self._data_Result + 1
      self._data_Result[idx] = {}
      self._data_Result[idx]._key = itemKey
      self._data_Result[idx]._name = ItemEnchantStaticStatusWrapper:getName()
      self._data_Result[idx]._iconPath = "Icon/" .. ItemEnchantStaticStatusWrapper:getIconPath()
      self._data_Result[idx]._currentCnt = s64_stackCount
    else
      self._data_Result[idx]._currentCnt = self._data_Result[idx]._currentCnt + s64_stackCount
    end
  end
  for i, resource in pairs(self._data_Resource) do
    local itemWrapper
    local count = 0
    if CppEnums.ItemWhereType.eInventory == resource.itemWhereType or CppEnums.ItemWhereType.eCashInventory == resource.itemWhereType then
      local curentInventoryType = Inventory_GetCurrentInventoryType()
      itemWrapper = getInventoryItemByType(curentInventoryType, resource._slotNo)
    else
      local warehouseWrapper = warehouse_get(self._warehouseWayPointKey)
      itemWrapper = warehouseWrapper:getItem(resource._slotNo)
    end
    if nil ~= itemWrapper then
      local itemStaticWrapper = itemWrapper:getStaticStatus()
      count = Int64toInt32(itemWrapper:get():getCount_s64())
    end
    resource._currentCnt = count
  end
  return true
end
function PaGlobalFunc_ManufactureNotifierResponseSuccess(itemDynamicListWrapper)
  if ManufactureNotifier:responseSuccess(itemDynamicListWrapper) then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:responseFail(failReason)
  self._failCount = self._failCount + 1
  return true
end
function PaGlobalFunc_ManufactureNotifierResponseFail(failReason)
  if ManufactureNotifier:responseFail(failReason) then
    return ManufactureNotifier:update()
  end
end
function ManufactureNotifier:updateResultControl(index)
  if self._item_Result[index] and self._icon_ResultBG[index] and self._icon_Result[index] then
    return
  end
  self._item_Result[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Result_" .. index)
  self._icon_ResultBG[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_ResultBG_" .. index)
  self._icon_Result[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_Result_" .. index)
  CopyBaseProperty(self._template.item_Result, self._item_Result[index])
  CopyBaseProperty(self._template.icon_ResultBG, self._icon_ResultBG[index])
  CopyBaseProperty(self._template.icon_Result, self._icon_Result[index])
  self._item_Result[index]:SetSpanSize(self._item_Result[index]:GetSpanSize().x, self._item_Result[index]:GetSpanSize().y + self._gapY * (index - 1))
  self._icon_ResultBG[index]:SetSpanSize(self._icon_ResultBG[index]:GetSpanSize().x, self._icon_ResultBG[index]:GetSpanSize().y + self._gapY * (index - 1))
  self._icon_Result[index]:SetSpanSize(self._icon_Result[index]:GetSpanSize().x, self._icon_Result[index]:GetSpanSize().y + self._gapY * (index - 1))
end
function ManufactureNotifier:updateResourceControl(index)
  if self._item_Resource[index] and self._icon_ResourceBG[index] and self._icon_Resource[index] then
    return false
  end
  self._item_Resource[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Manufacture_Notify, "item_Resource_" .. index)
  self._icon_ResourceBG[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_ResourceBG_" .. index)
  self._icon_Resource[index] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Manufacture_Notify, "icon_Resource_" .. index)
  CopyBaseProperty(self._template.item_Resource, self._item_Resource[index])
  CopyBaseProperty(self._template.icon_ResourceBG, self._icon_ResourceBG[index])
  CopyBaseProperty(self._template.icon_Resource, self._icon_Resource[index])
  self._item_Resource[index]:SetSpanSize(self._template.item_Resource:GetSpanSize().x, self._template.item_Resource:GetSpanSize().y + self._gapY * (index - 1))
  self._icon_ResourceBG[index]:SetSpanSize(self._template.icon_ResourceBG:GetSpanSize().x, self._template.icon_ResourceBG:GetSpanSize().y + self._gapY * (index - 1))
  self._icon_Resource[index]:SetSpanSize(self._template.icon_Resource:GetSpanSize().x, self._template.icon_Resource:GetSpanSize().y + self._gapY * (index - 1))
  return true
end
function FromClient_ManufactureNotifier_RePosition()
  Panel_Manufacture_Notify:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ManufactureNotifierInit")
