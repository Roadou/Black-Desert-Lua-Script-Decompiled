local pearlShopProductInfo = {
  _init = false,
  _panel = Panel_PearlShop_ProductInfo,
  _productNoRaw = 0,
  _focusedIndex = -1,
  _ui = {
    _itemSlotControlListSize = 16,
    _itemSlotControlListCountPerLine = 8,
    _itemSlotControlList = {},
    _mainBgControl = nil,
    _titleControl = nil,
    _descControl = nil,
    _effectDescControl = nil,
    _extractDescControl = nil,
    _bottomControl = nil,
    _itemSlotBgTemplateControl = nil
  },
  _slotGapX = 7,
  _slotList = {},
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _keyGuideAlign = {}
}
function pearlShopProductInfo:initialize()
  if self._init then
    return
  end
  self._init = true
  self._ui._mainBgControl = UI.getChildControl(self._panel, "Static_MainBG")
  self._ui._titleControl = UI.getChildControl(self._ui._mainBgControl, "StaticText_ProductName")
  self._ui._titleControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._descControl = UI.getChildControl(self._ui._mainBgControl, "StaticText_ProductDesc")
  self._ui._descControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._effectDescControl = UI.getChildControl(self._ui._mainBgControl, "StaticText_EffectDesc")
  self._ui._effectDescControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._extractDescControl = UI.getChildControl(self._ui._mainBgControl, "StaticText_ExtractDesc")
  self._ui._extractDescControl:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._Static_HorizontalLine = UI.getChildControl(self._ui._mainBgControl, "Static_HorizontalLine")
  local itemSlotGroup = UI.getChildControl(self._ui._mainBgControl, "Static_ItemSlotGroup")
  self._ui._itemSlotBgTemplateControl = UI.getChildControl(itemSlotGroup, "Static_ItemSlotBg_Template")
  self._ui._itemSlotBgTemplateControl:SetShow(false)
  local slotOriginalPosY = self._ui._itemSlotBgTemplateControl:GetPosY()
  for i = 0, self._ui._itemSlotControlListSize - 1 do
    local itemSlotControl = UI.cloneControl(self._ui._itemSlotBgTemplateControl, itemSlotGroup, "Static_ItemSlot" .. i)
    self._ui._itemSlotControlList[i] = itemSlotControl
    itemSlotControl:SetPosY(slotOriginalPosY + 54 * math.floor(i / self._ui._itemSlotControlListCountPerLine))
    local slot = {}
    SlotItem.new(slot, "Slot" .. i, i, itemSlotControl, self._slotConfig)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShopProductInfoFocus(" .. i .. ")")
    self._slotList[i] = slot
  end
  self._ui._bottomControl = UI.getChildControl(self._panel, "Static_BottomSite")
  self._ui._bottomKeyGuideB = UI.getChildControl(self._ui._bottomControl, "StaticText_XboxClose_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._bottomKeyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomControl, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._panel:ignorePadSnapMoveToOtherPanel()
end
function PaGlobalFunc_PearlShopProductInfoCheckShow()
  return pearlShopProductInfo:checkShow()
end
function pearlShopProductInfo:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_PearlShopProductInfoBack()
  pearlShopProductInfo:back()
end
function pearlShopProductInfo:back()
  self:close()
end
function pearlShopProductInfo:getInfo()
  if self._productNoRaw then
    return getIngameCashMall():getCashProductStaticStatusByProductNoRaw(self._productNoRaw)
  end
end
function pearlShopProductInfo:open(productInfo)
  if not productInfo then
    return
  end
  self._productNoRaw = productInfo:getNoRaw()
  self:focus(0)
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  self._panel:SetShow(true)
end
function PaGlobalFunc_PearlShopProductInfoOpen(productInfo)
  pearlShopProductInfo:open(productInfo)
end
function pearlShopProductInfo:close()
  PaGlobalFunc_PearlShopSetBKeyGuide()
  self._panel:SetShow(false)
end
function PaGlobalFunc_PearlShopProductInfoClose()
  if pearlShopProductInfo._panel:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  pearlShopProductInfo:close()
end
function pearlShopProductInfo:focus(controlIndex)
  local info = self:getInfo()
  if not info then
    return
  end
  if controlIndex >= info:getItemListCount() + info:getSubItemListCount() then
    return
  end
  self._focusedIndex = controlIndex
  self:update()
end
function PaGlobalFunc_PearlShopProductInfoFocus(controlIndex)
  pearlShopProductInfo:focus(controlIndex)
end
function pearlShopProductInfo:addItemSlotControlList(count)
  local itemSlotGroup = UI.getChildControl(self._ui._mainBgControl, "Static_ItemSlotGroup")
  local slotOriginalPosY = self._ui._itemSlotBgTemplateControl:GetPosY()
  for i = self._ui._itemSlotControlListSize, count - 1 do
    local itemSlotControl = UI.cloneControl(self._ui._itemSlotBgTemplateControl, itemSlotGroup, "Static_ItemSlot" .. i)
    self._ui._itemSlotControlList[i] = itemSlotControl
    itemSlotControl:SetPosY(slotOriginalPosY + 54 * math.floor(i / self._ui._itemSlotControlListCountPerLine))
    local slot = {}
    SlotItem.new(slot, "Slot" .. i, i, itemSlotControl, self._slotConfig)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShopProductInfoFocus(" .. i .. ")")
    self._slotList[i] = slot
  end
  self._ui._itemSlotControlListSize = count
end
function pearlShopProductInfo:update()
  local info = self:getInfo()
  if not info then
    return
  end
  local itemListCount = info:getItemListCount()
  local additionalSubItemCount = info:getSubItemListCount()
  local itemListCountPerLine = itemListCount + additionalSubItemCount
  local itemListLineCount = 1
  local focusedItemInfo
  if itemListCount > self._ui._itemSlotControlListSize then
    self:addItemSlotControlList(itemListCount)
  end
  if itemListCount > self._ui._itemSlotControlListCountPerLine then
    itemListCountPerLine = self._ui._itemSlotControlListCountPerLine
    itemListLineCount = math.floor((itemListCount - 1) / itemListCountPerLine) + 1
  end
  local firstPosX = self._ui._itemSlotBgTemplateControl:GetPosX() - 0.5 * (self._ui._itemSlotBgTemplateControl:GetSizeX() + 5) * (itemListCountPerLine - 1)
  for i = 0, self._ui._itemSlotControlListSize - 1 do
    local control = self._ui._itemSlotControlList[i]
    control:SetPosX(firstPosX + (self._ui._itemSlotBgTemplateControl:GetSizeX() + self._slotGapX) * math.floor(i % itemListCountPerLine))
    local showFlag = i < itemListCount
    control:SetShow(showFlag)
    if showFlag then
      local itemInfo = info:getItemByIndex(i)
      self._slotList[i]:setItemByStaticStatus(itemInfo, info:getItemCountByIndex(i))
      if i == self._focusedIndex then
        focusedItemInfo = info:getItemByIndex(i)
        self._ui._titleControl:SetText(focusedItemInfo:getName())
        self._ui._descControl:SetText(focusedItemInfo:getDescription())
        self._ui._effectDescControl:SetText(focusedItemInfo:getEnchantDescription())
      end
    end
  end
  for i = 0, additionalSubItemCount - 1 do
    local control = self._ui._itemSlotControlList[i + itemListCount]
    local subItemInfo = info:getSubItemByIndex(i)
    self._slotList[i + itemListCount]:setItemByStaticStatus(subItemInfo, info:getSubItemCountByIndex(i))
    control:SetShow(true)
    if i + itemListCount == self._focusedIndex then
      focusedItemInfo = info:getSubItemByIndex(i)
      self._ui._titleControl:SetText(focusedItemInfo:getName())
      self._ui._descControl:SetText(focusedItemInfo:getDescription())
      self._ui._effectDescControl:SetText(focusedItemInfo:getEnchantDescription())
    end
  end
  local plusPosY = (itemListLineCount - 1) * 54
  self._ui._Static_HorizontalLine:SetPosY(85 + plusPosY)
  local valksCount = focusedItemInfo:getExtractionCount_s64()
  local cronsCount = focusedItemInfo:getCronCount_s64()
  local isExtractable = false
  if nil ~= valksCount and valksCount > toInt64(0, 0) then
    self._ui._extractDescControl:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_BALKS_EXTRACTION", "balksCount", Int64toInt32(valksCount)))
    isExtractable = true
  end
  if nil ~= cronsCount and cronsCount > toInt64(0, 0) then
    local cronText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CRONS_EXTRACTION", "cronsCount", Int64toInt32(cronsCount))
    if true == isExtractable then
      cronText = self._ui._extractDescControl:GetText() .. "\n" .. cronText
    end
    self._ui._extractDescControl:SetText(cronText)
    isExtractable = true
  end
  if true == isExtractable then
    self._ui._extractDescControl:SetShow(true)
    self._ui._extractDescControl:SetSize(460, self._ui._extractDescControl:GetTextSizeY() + 10)
  else
    self._ui._extractDescControl:SetShow(false)
    self._ui._extractDescControl:SetSize(460, 0)
  end
  if self._ui._titleControl:GetTextSizeY() > 10 then
    self._ui._titleControl:SetSize(460, self._ui._titleControl:GetTextSizeY() + 10)
    self._ui._titleControl:SetPosY(110 + plusPosY)
  else
    self._ui._titleControl:SetSize(460, 0)
  end
  if self._ui._descControl:GetTextSizeY() > 10 then
    self._ui._descControl:SetSize(460, self._ui._descControl:GetTextSizeY() + 10)
  else
    self._ui._descControl:SetSize(460, 0)
  end
  if self._ui._effectDescControl:GetTextSizeY() > 10 then
    self._ui._effectDescControl:SetSize(460, self._ui._effectDescControl:GetTextSizeY() + 10)
  else
    self._ui._effectDescControl:SetSize(460, 0)
  end
  self._ui._extractDescControl:SetPosY(self._ui._titleControl:GetPosY() + self._ui._titleControl:GetSizeY() + 10)
  self._ui._descControl:SetPosY(self._ui._extractDescControl:GetPosY() + self._ui._extractDescControl:GetSizeY() + 10)
  self._ui._effectDescControl:SetPosY(self._ui._descControl:GetPosY() + self._ui._descControl:GetSizeY() + 10)
  self._ui._mainBgControl:SetSize(self._ui._mainBgControl:GetSizeX(), self._ui._effectDescControl:GetPosY() + self._ui._effectDescControl:GetSizeY() + 10)
  self._panel:SetSize(self._panel:GetSizeX(), self._ui._mainBgControl:GetPosY() + self._ui._mainBgControl:GetSizeY() + self._ui._bottomControl:GetSizeY() + 10)
  self._ui._bottomControl:ComputePos()
end
function pearlShopProductInfo:changePlatformSpecKey()
end
function FromClient_PearlShopProductInfoInit()
  pearlShopProductInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_PearlShopProductInfoInit")
