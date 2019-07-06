local UI_TM = CppEnums.TextMode
PaGlobal_Guild_ManufactureSelect = {
  _ui = {
    _closeButton = nil,
    _staticBG = nil,
    _baseSlot = nil,
    _notice = nil
  },
  _config = {
    _col = 6,
    _startPosX = 10,
    _startPosY = 10,
    _gapX = 60,
    _gapY = 60,
    _titleSizeY = 30
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _categoryList = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_SELECT_CATEGORY0"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_SELECT_CATEGORY1"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_SELECT_CATEGORY2")
  },
  _category = Array.new(),
  _itemEnchantKey = Array.new(),
  _index = -1,
  _slotList = Array.new()
}
function PaGlobal_Guild_ManufactureSelect:initialize()
  if nil == Panel_Guild_ManufactureSelect then
    return
  end
  PaGlobal_Guild_ManufactureSelect._ui._closeButton = UI.getChildControl(Panel_Guild_ManufactureSelect, "Button_Close")
  PaGlobal_Guild_ManufactureSelect._ui._staticBG = UI.getChildControl(Panel_Guild_ManufactureSelect, "Static_BG")
  PaGlobal_Guild_ManufactureSelect._ui._baseSlot = UI.getChildControl(Panel_Guild_ManufactureSelect, "Static_Slot")
  PaGlobal_Guild_ManufactureSelect._ui._notice = UI.getChildControl(Panel_Guild_ManufactureSelect, "StaticText_Notice")
  self._ui._notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_NOTICE_INFORMATION"))
  for ii = 0, #self._categoryList do
    self._category[ii] = {
      _title = nil,
      _slot = Array.new(),
      _slotCount = 0
    }
    local title = UI.getChildControl(self._ui._staticBG, "StaticText_Category" .. tostring(ii + 1))
    local titleText = UI.getChildControl(title, "StaticText_Title" .. tostring(ii + 1))
    titleText:SetText(self._categoryList[ii])
    self._category[ii]._title = title
  end
  local productEnchantKeyList = ToClient_Guild_Manufacture_ProductItemEnchantKeyList()
  if nil == productEnchantKeyList then
    return
  end
  for ii = 0, #productEnchantKeyList do
    local itemEnchantKey = productEnchantKeyList[ii]
    local manufactureStatic = ToClient_GetGuildManufactureStaticStatusWrapper(itemEnchantKey)
    if nil ~= manufactureStatic then
      local slot = {}
      slot.bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticBG, "ProductItemBG_" .. ii)
      CopyBaseProperty(self._ui._baseSlot, slot.bg)
      SlotItem.new(slot, "ProductItemIcon_" .. ii, ii, slot.bg, self._slotConfig)
      slot:createChild()
      slot.icon:SetPosX(4)
      slot.icon:SetPosY(4)
      slot.icon:SetShow(true)
      local itemWrapper = getItemEnchantStaticStatus(itemEnchantKey)
      slot:setItemByStaticStatus(itemWrapper)
      self._itemEnchantKey[ii] = itemEnchantKey
      local categoryNo = manufactureStatic:getCategoryNo()
      local slotCount = self._category[categoryNo]._slotCount
      self._category[categoryNo]._slot[slotCount] = slot
      self._category[categoryNo]._slotCount = slotCount + 1
      self._slotList[ii] = slot
    end
  end
  local startPosX = self._config._startPosX
  local startPosY = self._config._startPosY
  for ii = 0, #self._categoryList do
    self._category[ii]._title:SetPosX(startPosX)
    self._category[ii]._title:SetPosY(startPosY)
    self._category[ii]._title:SetShow(true)
    startPosY = startPosY + self._config._titleSizeY + 5
    local col = 0
    local row = 0
    for jj = 0, self._category[ii]._slotCount - 1 do
      local slot = self._category[ii]._slot[jj]
      if nil ~= slot then
        row = math.floor(jj / self._config._col)
        col = jj % self._config._col
        slot.bg:SetPosX(self._config._startPosX + self._config._gapX * col)
        slot.bg:SetPosY(startPosY + self._config._gapY * row)
        slot.bg:SetShow(true)
      end
    end
    startPosY = startPosY + self._config._gapY * (row + 1)
  end
  startPosY = startPosY + self._config._gapY
  deleteControl(self._ui._baseSlot)
  self._ui._baseSlot = nil
  self._ui._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ManufactureSelect:close()")
  local width = 410
  local height = startPosY + 20
  self._ui._staticBG:SetSize(width - 10, height - 80)
  self._ui._notice:SetPosY(self._ui._staticBG:GetPosY() + self._ui._staticBG:GetSizeY() + 5)
  Panel_Guild_ManufactureSelect:SetSize(width, height + self._ui._notice:GetTextSizeY() + 5)
end
function PaGlobal_Guild_ManufactureSelect:open(index)
  if true == PaGlobal_GuildManufactureSelect_GetShow() then
    return
  end
  PaGlobal_GuildManufactureSelect_CheckLoadUI()
  self._index = index
  local productEnchantKeyList = ToClient_Guild_Manufacture_ProductItemEnchantKeyList()
  if nil == productEnchantKeyList then
    return
  end
  for ii = 0, #productEnchantKeyList do
    local itemEnchantKey = productEnchantKeyList[ii]
    local checkMakeflag = ToClient_CheckCanMakeGuildManufacture(itemEnchantKey)
    local slot = self._slotList[ii]
    if true == checkMakeflag then
      slot.icon:addInputEvent("Mouse_LUp", "PaGlobal_Guild_ManufactureSelect:select(" .. ii .. ")")
      slot.icon:SetMonoTone(false)
    else
      slot.icon:addInputEvent("Mouse_LUp", "")
      slot.icon:SetMonoTone(true)
    end
    slot.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_ManufactureSelect:itemTooltip_Show(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_ManufactureSelect:itemTooltip_Hide(" .. ii .. ")")
  end
end
function PaGlobal_Guild_ManufactureSelect:close()
  if nil == Panel_Guild_ManufactureSelect then
    return
  end
  self:itemTooltip_Hide(self._index)
  self._index = -1
  PaGlobal_GuildManufactureSelect_CheckCloseUI()
end
function PaGlobal_Guild_ManufactureSelect:select(index)
  if nil == Panel_Guild_ManufactureSelect then
    return
  end
  PaGlobal_Guild_Manufacture:setProductItem(self._index, self._itemEnchantKey[index])
  self:close()
end
function PaGlobal_Guild_ManufactureSelect:itemTooltip_Show(index)
  if nil == Panel_Guild_ManufactureSelect then
    return
  end
  local manufacture = ToClient_GetGuildManufactureStaticStatusWrapper(self._itemEnchantKey[index])
  if nil == manufacture then
    return
  end
  local itemStatic = ToClient_getItemExchangeSourceStaticStatusWrapper(manufacture:getExchangeKey())
  if nil ~= itemStatic then
    Panel_Tooltip_Item_SetPosition(index, self._ui._staticBG, "guildManufactureProductItemSelect")
    FGlobal_Show_Tooltip_Work(itemStatic, Panel_Guild_ManufactureSelect, nil, nil, true)
  end
end
function PaGlobal_Guild_ManufactureSelect:itemTooltip_Hide(index)
  if nil == Panel_Guild_ManufactureSelect then
    return
  end
  if index >= 0 then
    local itemStatic = ToClient_getItemExchangeSourceStaticStatusWrapper(self._itemEnchantKey[index])
    FGlobal_Hide_Tooltip_Work(itemStatic, true)
  end
end
function PaGlobal_GuildManufactureSelect_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_ManufactureSelect:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_ManufactureSelect.XML", "Panel_Guild_ManufactureSelect", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_ManufactureSelect = rv
    rv = nil
    PaGlobal_Guild_ManufactureSelect:initialize()
  end
  Panel_Guild_ManufactureSelect:SetShow(true)
end
function PaGlobal_GuildManufactureSelect_CheckCloseUI()
  if false == PaGlobal_GuildManufactureSelect_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_ManufactureSelect:SetShow(false)
  else
    reqCloseUI(Panel_Guild_ManufactureSelect)
  end
end
function PaGlobal_GuildManufactureSelect_GetShow()
  if nil == Panel_Guild_ManufactureSelect then
    return false
  end
  return Panel_Guild_ManufactureSelect:GetShow()
end
function FromClient_Init_Guild_ManufactureSelect()
  PaGlobal_Guild_ManufactureSelect:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Init_Guild_ManufactureSelect")
