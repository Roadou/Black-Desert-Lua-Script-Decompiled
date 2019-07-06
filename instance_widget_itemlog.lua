local _panel = Instance_Widget_ItemLog
local _MaxSlot = 4
local widgetItemLog = {}
local itemLogStruct = {
  _index = 0,
  _colorValue = 0,
  stc_itemLogControl = nil,
  stc_itemIcon = nil,
  stct_itemName = nil
}
itemLogStruct.__index = itemLogStruct
local itemLog = {
  logPool = {},
  posYList = {},
  _currentIndex = 0,
  _firstSlotPosY = 0
}
function widgetItemLog:init()
  self._bgControl = UI.getChildControl(_panel, "Static_ItemLog_BG")
  self._iconControl = UI.getChildControl(self._bgControl, "Static_ItemLog_Icon")
  self._nameControl = UI.getChildControl(self._bgControl, "StaticText_Name")
  _panel:SetPosX((getScreenSizeX() - _panel:GetSizeX()) / 2 + _panel:GetSizeX())
  _panel:SetPosY(getScreenSizeY() - _panel:GetSizeY() - 180)
  _panel:SetShow(true)
  for i = 0, _MaxSlot do
    itemLog.logPool[i] = {}
    setmetatable(itemLog.logPool[i], itemLogStruct)
    itemLog.logPool[i]:cloneControl(self._bgControl, self._iconControl, self._nameControl, i)
    itemLog.logPool[i]:init()
  end
  itemLog:init()
  registerEvent("EventAddItemToInventory", "Inventory_AddItem")
end
function itemLog:init()
  self._firstSlotPosY = itemLog.logPool[0].stc_itemLogControl:GetPosY()
end
function itemLog:listUp()
  local setPosYValue
  for i = 0, _MaxSlot do
    setPosYValue = self.logPool[i].stc_itemLogControl:GetPosY() - 55
    self.logPool[i].stc_itemLogControl:SetPosY(setPosYValue)
  end
  self.logPool[self._currentIndex].stc_itemLogControl:SetPosY(self._firstSlotPosY)
  self.logPool[self._currentIndex]:fadeOut(3.5, 2.5)
end
function itemLogStruct:init()
  self.stct_itemName:SetText(" ")
  self.stc_itemLogControl:SetPosY(self.stc_itemLogControl:GetPosY() - self._index * 55)
end
function itemLogStruct:cloneControl(logControl, itemIcon, itemName, index)
  self._index = index
  self.stc_itemLogControl = UI.cloneControl(logControl, _panel, "Static_ItemLog_BG" .. index)
  self.stc_itemIcon = UI.cloneControl(itemIcon, self.stc_itemLogControl, "Static_ItemLog_Icon" .. index)
  self.stct_itemName = UI.cloneControl(itemName, self.stc_itemLogControl, "StaticText_Name" .. index)
end
function itemLogStruct:fadeOut(duration, startTime)
  local aniInfo = self.stc_itemLogControl:addColorAnimation(startTime, duration, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(Defines.Color.C_FFFFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetHideAtEnd(false)
  aniInfo.IsChangeChild = true
  return true
end
function itemLogStruct:fadeIn(duration, startTime)
  local aniInfo = self.stc_itemLogControl:addColorAnimation(startTime, duration, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartColor(Defines.Color.C_00FFFFFF)
  aniInfo:SetEndColor(Defines.Color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  return true
end
function itemLogStruct:nameColorbyGrade(item)
  local grade = item:getGradeType()
  local colorValue = 0
  if 0 == grade then
    colorValue = 4293388263
  elseif 1 == grade then
    colorValue = 4288921664
  elseif 2 == grade then
    colorValue = 4283938018
  elseif 3 == grade then
    colorValue = 4293904710
  elseif 4 == grade then
    colorValue = 4294929482
  else
    colorValue = UI_color.C_FFFFFFFF
  end
  self._colorValue = colorValue
  self.stct_itemName:SetFontColor(self._colorValue)
end
function Inventory_AddItem(itemKey, slotNo, itemCount)
  local self = itemLog
  local item = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local currentLog = self.logPool[self._currentIndex]
  if itemCount > toInt64(0, 1) then
    currentLog.stct_itemName:SetText(item:getName() .. " \239\188\184 " .. tostring(itemCount))
  else
    currentLog.stct_itemName:SetText(item:getName())
  end
  currentLog.stc_itemIcon:ChangeTextureInfoName("Icon/" .. item:getIconPath())
  currentLog.stc_itemLogControl:SetShow(true)
  currentLog:nameColorbyGrade(item)
  self.logPool[self._currentIndex]:fadeIn(0.2, 0)
  self:listUp()
  self._currentIndex = self._currentIndex - 1
  if self._currentIndex < 0 then
    self._currentIndex = _MaxSlot - 1
  end
end
function PaGlobal_WidgetItemLog_Init()
  local self = widgetItemLog
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_WidgetItemLog_Init()")
