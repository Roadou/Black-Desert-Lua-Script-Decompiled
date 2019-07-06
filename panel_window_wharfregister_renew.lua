local Panel_Window_WharfRegister_info = {
  _ui = {
    staticText_Title = nil,
    static_Profile = nil,
    staticText_HP_Val = nil,
    staticText_SP_Val = nil,
    staticText_Weight_Val = nil,
    staticText_Life_Val = nil,
    staticText_Speed_Val = nil,
    staticText_Acc_Val = nil,
    staticText_Rotate_Val = nil,
    staticText_Break_Val = nil,
    staticText_HP = nil,
    staticText_SP = nil,
    staticText_Weight = nil,
    staticText_Life = nil,
    staticText_Speed = nil,
    staticText_Acc = nil,
    staticText_Rotate = nil,
    staticText_Break = nil,
    edit_Name = nil,
    static_SlotItemBg = nil,
    static_LT_ConsoleUI = nil,
    static_RT_ConsoleUI = nil,
    radioButton_SlotBgTemplate = nil,
    static_Bottombg = nil,
    staticText_Confirm_ConsoleUI = nil,
    staticText_Cancel_ConsoleUI = nil,
    staticText_ChangeName_ConsoleUI = nil,
    txt_keyGuides = {}
  },
  _enum = {
    eTYEP_OPEN_NONE = -1,
    eTYEP_OPEN_MAPAE = 0,
    eTYEP_OPEN_TAMING = 1,
    eTYEP_OPEN_MATING = 2,
    eTYEP_OPEN_RENAME = 3
  },
  _value = {
    level = 1,
    chracterkey = nil,
    lastMapaeIndex = -1,
    currentMapaeIndex = 0,
    lastMapaeSlotNo = -1,
    currentMapaeSlotNo = 0,
    startMapaeIndex = 0,
    currentOpenType = -1,
    mapaeItemCount = 0,
    slotCols = 7
  },
  _config = {
    slotRows = 1,
    maxSlotCount = 7,
    itemSlot = {
      createIcon = true,
      createBorder = false,
      createCount = false,
      createEnchant = false,
      createCash = true,
      createEnduranceIcon = false
    }
  },
  _pos = {
    startMapaePos = 0,
    sizeXMapae = 0,
    spaceXMapae = 10
  },
  _texture = {
    sexIcon = "Renewal/UI_Icon/Console_Icon_01.dds",
    male = {
      x1 = 82,
      y1 = 1,
      x2 = 101,
      y2 = 20
    },
    female = {
      x1 = 62,
      y1 = 1,
      x2 = 81,
      y2 = 20
    }
  },
  _wharfSlotList = {},
  _wharfDataList = {}
}
local randomName = {
  "Darcy",
  "Buddy",
  "Orbit",
  "Rushmore",
  "Carolina",
  "Cindy",
  "Waffles",
  "Sparky",
  "Bailey",
  "Wichita",
  "Buck"
}
function Panel_Window_WharfRegister_info:registEventHandler()
  Panel_Window_WharfRegister:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_WharfRegister_Register()")
  Panel_Window_WharfRegister:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_WharfRegister_NameSetfocus()")
  Panel_Window_WharfRegister:registerPadEvent(__eConsoleUIPadEvent_LT, "PaGlobalFunc_WharfRegister_MoveRight(false)")
  Panel_Window_WharfRegister:registerPadEvent(__eConsoleUIPadEvent_RT, "PaGlobalFunc_WharfRegister_MoveRight(true)")
  self._ui.edit_Name:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfRegister_NameSetfocus()")
  self._ui.staticText_Confirm_ConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfRegister_Register()")
  self._ui.edit_Name:setXboxVirtualKeyBoardEndEvent("PaGlobalFunc_WharfRegister_OnVirtualKeyboardEnd")
end
function Panel_Window_WharfRegister_info:registerEventHandler()
  registerEvent("FromClient_ServantChildInfo", "PaGlobalFunc_WharfRegister_OpenByMating")
  registerEvent("FromClient_ServantRegisterToAuction", "PaGlobalFunc_WharfRegister_ExitAll")
end
function Panel_Window_WharfRegister_info:registerMessageHandler()
end
function Panel_Window_WharfRegister_info:initialize()
  self:childControl()
  self:initValue()
  self:initPosValue()
  self:createControl()
  self:registerEventHandler()
  self:registEventHandler()
end
function Panel_Window_WharfRegister_info:initPosValue()
  self._ui.spaceXMapae = 10
  self._pos.sizeXMapae = self._ui.radioButton_SlotBgTemplate:GetSizeX()
  self:updatePosValue()
  self:setBottomKeyGuidesPos()
end
function Panel_Window_WharfRegister_info:setBottomKeyGuidesPos()
  local bottomSizeX = self._ui.static_Bottombg:GetSizeX()
  local totalSizeX = 0
  for _, keyGuide in pairs(self._ui.txt_keyGuides) do
    totalSizeX = totalSizeX + keyGuide:GetTextSizeX() + 44
  end
  local freeSpace = (bottomSizeX - totalSizeX) / 4
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._ui.txt_keyGuides, self._ui.static_Bottombg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_LEFT, 44, freeSpace)
end
function Panel_Window_WharfRegister_info:updatePosValue()
  local totalLength = 0
  self._value.slotCols = self._value.mapaeItemCount - self._value.startMapaeIndex
  if self._config.maxSlotCount < self._value.slotCols then
    self._value.slotCols = self._config.maxSlotCount
  end
  if 0 == self._value.slotCols then
    totalLength = 0
  else
    totalLength = self._pos.sizeXMapae * self._value.slotCols + self._pos.spaceXMapae * (self._value.slotCols - 1)
  end
  self._pos.startMapaePos = (self._ui.static_SlotItemBg:GetSizeX() - totalLength) / 2
end
function Panel_Window_WharfRegister_info:initValue(openType)
  self._value.chracterkey = nil
  self._value.lastMapaeIndex = 0
  self._value.currentMapaeIndex = 0
  self._value.lastMapaeSlotNo = 0
  self._value.currentMapaeSlotNo = 0
  self._value.currentOpenType = self._enum.eTYEP_OPEN_NONE
  if openType ~= CppEnums.ServantRegist.eEventType_Inventory then
    self._value.mapaeItemCount = 0
  end
  self._value.startMapaeIndex = 0
  self._value.slotCols = 0
end
function Panel_Window_WharfRegister_info:createControl()
  for index = 0, self._config.maxSlotCount - 1 do
    do
      local slot = {
        selected = false,
        slotNo = 0,
        itemSlotNo = -1,
        invenType = 0,
        radioButton_SlotBgTemplate = nil
      }
      function slot:setPos(cols)
        local registerInfo = Panel_Window_WharfRegister_info
        self.radioButton_SlotBgTemplate:SetPosX(registerInfo._pos.startMapaePos + (registerInfo._pos.spaceXMapae + registerInfo._pos.sizeXMapae) * cols)
      end
      function slot:setItemSlot(itemSlotNo, invenType)
        local itemWrapper
        itemWrapper = getInventoryItemByType(invenType, itemSlotNo)
        if nil == itemWrapper then
          return
        end
        self.itemSlotNo = itemSlotNo
        self.invenType = invenType
        slot:setItem(itemWrapper)
      end
      function slot:setShow(bShow)
        self.radioButton_SlotBgTemplate:SetShow(bShow)
      end
      function slot:selectSlot(bSelect)
        self.selected = true
        self.radioButton_SlotBgTemplate:SetCheck(bSelect)
      end
      function slot:clearSlot()
        self:setShow(false)
        self:selectSlot(false)
        self.itemSlotNo = -1
        self.invenType = 0
      end
      slot.radioButton_SlotBgTemplate = UI.createAndCopyBasePropertyControl(self._ui.static_SlotItemBg, "RadioButton_SlotBgTemplate", self._ui.static_SlotItemBg, "RadioButton_ItemSlot_" .. index)
      slot:setPos(index)
      slot.slotNo = index
      SlotItem.new(slot, "MapaeItem_" .. index, index, slot.radioButton_SlotBgTemplate, self._config.itemSlot)
      slot:createChild()
      slot:clearSlot()
      slot.icon:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_WharfRegister_MoveRight( false )")
      slot.icon:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_WharfRegister_MoveRight( true )")
      self._wharfSlotList[index] = slot
    end
  end
end
function Panel_Window_WharfRegister_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Title")
  self._ui.static_Profile = UI.getChildControl(Panel_Window_WharfRegister, "Static_Profile")
  self._ui.staticText_HP_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_HP_Val")
  self._ui.staticText_SP_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_SP_Val")
  self._ui.staticText_Weight_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Weight_Val")
  self._ui.staticText_Life_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Life_Val")
  self._ui.staticText_Speed_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Speed_Val")
  self._ui.staticText_Acc_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Acc_Val")
  self._ui.staticText_Rotate_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Rotate_Val")
  self._ui.staticText_Break_Val = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Break_Val")
  self._ui.staticText_HP = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_HP")
  self._ui.staticText_SP = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_SP")
  self._ui.staticText_Weight = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Weight")
  self._ui.staticText_Life = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Life")
  self._ui.staticText_Speed = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Speed")
  self._ui.staticText_Acc = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Acc")
  self._ui.staticText_Rotate = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Rotate")
  self._ui.staticText_Break = UI.getChildControl(Panel_Window_WharfRegister, "StaticText_Break")
  self._ui.edit_Name = UI.getChildControl(Panel_Window_WharfRegister, "Edit_Name")
  self._ui.edit_Name:SetMaxInput(getGameServiceTypeServantNameLength())
  self._ui.static_SlotItemBg = UI.getChildControl(Panel_Window_WharfRegister, "Static_SlotItemBg")
  self._ui.static_LT_ConsoleUI = UI.getChildControl(self._ui.static_SlotItemBg, "Static_LT_ConsoleUI")
  self._ui.static_RT_ConsoleUI = UI.getChildControl(self._ui.static_SlotItemBg, "Static_RT_ConsoleUI")
  self._ui.radioButton_SlotBgTemplate = UI.getChildControl(self._ui.static_SlotItemBg, "RadioButton_SlotBgTemplate")
  self._ui.radioButton_SlotBgTemplate:SetShow(false)
  self._ui.static_Bottombg = UI.getChildControl(Panel_Window_WharfRegister, "Static_Bottombg")
  self._ui.staticText_Confirm_ConsoleUI = UI.getChildControl(self._ui.static_Bottombg, "StaticText_Confirm_ConsoleUI")
  self._ui.staticText_Cancel_ConsoleUI = UI.getChildControl(self._ui.static_Bottombg, "StaticText_Cancel_ConsoleUI")
  self._ui.staticText_ChangeName_ConsoleUI = UI.getChildControl(self._ui.static_Bottombg, "StaticText_ChangeName_ConsoleUI")
  self._ui.txt_keyGuides = {
    self._ui.staticText_ChangeName_ConsoleUI,
    self._ui.staticText_Confirm_ConsoleUI,
    self._ui.staticText_Cancel_ConsoleUI
  }
end
function Panel_Window_WharfRegister_info:setKeyguide()
  if 0 < self._value.mapaeItemCount then
    self._ui.static_LT_ConsoleUI:SetShow(true)
    self._ui.static_RT_ConsoleUI:SetShow(true)
  else
    self._ui.static_LT_ConsoleUI:SetShow(false)
    self._ui.static_RT_ConsoleUI:SetShow(false)
  end
end
function Panel_Window_WharfRegister_info:setWharfList()
  self._value.mapaeItemCount = 0
  local mapeCount = 0
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenMaxSize = inventory:sizeXXX()
  for slotNo = 0, invenMaxSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, slotNo)
    if nil ~= itemWrapper then
      local isMapae = InvenFiler_Mapae(slotNo, itemWrapper)
      if false == isMapae then
        local data = {}
        data.itemSlotNo = slotNo
        data.invenType = CppEnums.ItemWhereType.eInventory
        self._wharfDataList[mapeCount] = data
        mapeCount = mapeCount + 1
      end
    end
  end
  local cashInventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eCashInventory)
  local cashInvenMaxSize = cashInventory:sizeXXX()
  for slotNoCash = 0, cashInvenMaxSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNoCash)
    if nil ~= itemWrapper then
      local isMapae = InvenFiler_Mapae(slotNoCash, itemWrapper)
      if false == isMapae then
        local data = {}
        data.itemSlotNo = slotNoCash
        data.invenType = CppEnums.ItemWhereType.eCashInventory
        self._wharfDataList[mapeCount] = data
        mapeCount = mapeCount + 1
      end
    end
  end
  self._value.mapaeItemCount = mapeCount
  return mapeCount
end
function Panel_Window_WharfRegister_info:updateMapaeList()
  for ii = 0, self._value.slotCols - 1 do
    local slot = self._wharfSlotList[ii]
    slot:clearSlot()
  end
  for index = 0, self._value.slotCols - 1 do
    local slot = self._wharfSlotList[index]
    slot.slotNo = self._value.startMapaeIndex + index
    if slot.slotNo < self._value.mapaeItemCount then
      if self._value.currentMapaeSlotNo == slot.slotNo then
        slot:selectSlot(true)
      end
      slot:setShow(true)
      slot:setPos(index)
      slot:setItemSlot(self._wharfDataList[slot.slotNo].itemSlotNo, self._wharfDataList[slot.slotNo].invenType)
      slot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_WharfRegister_ClickList(" .. index .. ")")
    end
  end
end
function Panel_Window_WharfRegister_info:clearWharfList()
  for index = 0, self._config.maxSlotCount - 1 do
    local slot = self._wharfSlotList[index]
    slot:clearSlot()
  end
end
function Panel_Window_WharfRegister_info:setContent()
  self:setKeyguide()
  if self._value.currentOpenType == CppEnums.ServantRegist.eEventType_Inventory then
    self:updatePosValue()
    self:updateMapaeList()
    self:setBaseInfo()
    self:setEditName()
  elseif self._value.currentOpenType == CppEnums.ServantRegist.eEventType_ChangeName or self._value.currentOpenType == CppEnums.ServantRegist.eEventType_Taming or self._value.currentOpenType == CppEnums.ServantRegist.eEventType_Mating then
    self:setBaseInfo()
    self:setEditName()
  else
    return
  end
end
function Panel_Window_WharfRegister_info:setBaseInfo()
  local servantInfo
  if CppEnums.ServantRegist.eEventType_Inventory == self._value.currentOpenType then
    local inventorySlotNo = self._wharfSlotList[self._value.currentMapaeIndex].itemSlotNo
    local invenType = self._wharfSlotList[self._value.currentMapaeIndex].invenType
    local itemWrapper
    itemWrapper = getInventoryItemByType(invenType, inventorySlotNo)
    if nil == itemWrapper then
      return
    end
    local chracterkey = itemWrapper:getStaticStatus():getObjectKey()
    servantInfo = stable_getServantByCharacterKey(chracterkey, self._value.level)
  else
    servantInfo = stable_getServantByCharacterKey(self._value.characterKey, self._value.level)
  end
  if nil == servantInfo then
    PaGlobalFunc_WharfRegister_Close()
    return
  end
  local isHavePower = false
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
    isHavePower = false
    self._ui.staticText_SP:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CARRIAGEINFO_MP"))
  else
    isHavePower = true
    self._ui.staticText_SP:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_GUILDSHIP_NAME"))
  end
  self._ui.static_Profile:SetShow(true)
  self._ui.static_Profile:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._ui.staticText_Weight_Val:SetText(makeDotMoney(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000))
  self._ui.staticText_HP_Val:SetText(makeDotMoney(servantInfo:getMaxHp()))
  self._ui.staticText_SP_Val:SetText(makeDotMoney(servantInfo:getMaxMp()))
  if servantInfo:isPeriodLimit() then
    self._ui.staticText_Life_Val:SetText(servantInfo:getStaticExpiredTime() / 60 / 60 / 24 .. PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFETIME"))
  else
    self._ui.staticText_Life_Val:SetText("-")
  end
  self._ui.staticText_Speed_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_Acc_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_Rotate_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_Break_Val:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
end
function Panel_Window_WharfRegister_info:setEditName()
  local randIndex = getRandomValue(1, #randomName)
  self._ui.edit_Name:SetEditText(randomName[randIndex])
end
function Panel_Window_WharfRegister_info:open()
  Panel_Window_WharfRegister:SetShow(true)
end
function Panel_Window_WharfRegister_info:close()
  Panel_Window_WharfRegister:SetShow(false)
end
function PaGlobalFunc_WharfRegister_OpenByWharf()
  local self = Panel_Window_WharfRegister_info
  self:initValue(CppEnums.ServantRegist.eEventType_Inventory)
  self._value.currentOpenType = CppEnums.ServantRegist.eEventType_Inventory
  self:clearWharfList()
  self:setContent(self._enum.eTYEP_OPEN_MAPAE)
  self:open()
end
function PaGlobalFunc_WharfRegister_OpenByRename()
  local self = Panel_Window_WharfRegister_info
  local servantInfo = stable_getServant(PaGlobalFunc_WharfList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  self:initValue()
  self._value.characterKey = servantInfo:getCharacterKey()
  self._value.level = servantInfo:getLevel()
  self._value.currentOpenType = CppEnums.ServantRegist.eEventType_ChangeName
  self:clearWharfList()
  self:setContent(self._enum.eTYEP_OPEN_RENAME)
  self:open()
end
function PaGlobalFunc_WharfRegister_GetShow()
  return Panel_Window_WharfRegister:GetShow()
end
function PaGlobalFunc_WharfRegister_Close()
  local self = Panel_Window_WharfRegister_info
  self:close()
end
function PaGlobalFunc_WharfRegister_ExitAndOpenList()
  local self = Panel_Window_WharfRegister_info
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  end
  self:close()
  PaGlobalFunc_WharfList_Show()
end
function PaGlobalFunc_WharfRegister_ExitAll()
  local self = Panel_Window_WharfRegister_info
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  end
  self:close()
end
function PaGlobalFunc_WharfRegister_CheckIsWharf()
  local self = Panel_Window_WharfRegister_info
  return self:setWharfList()
end
function PaGlobalFunc_WharfRegister_NameSetfocus()
  local self = Panel_Window_WharfRegister_info
  if true == self._ui.edit_Name:GetFocusEdit() then
    ClearFocusEdit()
  else
    SetFocusEdit(self._ui.edit_Name)
    self._ui.edit_Name:SetEditText("")
  end
end
function PaGlobalFunc_WharfRegister_OnVirtualKeyboardEnd(str)
  local self = Panel_Window_WharfRegister_info
  self._ui.edit_Name:SetEditText(str)
  ClearFocusEdit()
end
function PaGlobalFunc_WharfRegister_MoveRight(isRight)
  local self = Panel_Window_WharfRegister_info
  if nil == isRight then
    isRight = true
  end
  if false == isRight then
    if 0 == self._value.currentMapaeIndex then
      local beforeSlotIndex = self._value.startMapaeIndex
      self._value.startMapaeIndex = UIScroll_Horizontal_MoveRightEvent(isRight, self._config.slotRows, self._value.mapaeItemCount, self._value.startMapaeIndex, self._value.slotCols, 1)
      if beforeSlotIndex == self._value.startMapaeIndex then
        return
      else
        PaGlobalFunc_WharfRegister_ClickList(self._value.currentMapaeIndex)
        self:updateMapaeList()
      end
    else
      PaGlobalFunc_WharfRegister_ClickList(self._value.currentMapaeIndex - 1)
    end
  elseif self._value.slotCols - 1 == self._value.currentMapaeIndex then
    local beforeSlotIndex = self._value.startMapaeIndex
    self._value.startMapaeIndex = UIScroll_Horizontal_MoveRightEvent(isRight, self._config.slotRows, self._value.mapaeItemCount, self._value.startMapaeIndex, self._value.slotCols, 1)
    if beforeSlotIndex == self._value.startMapaeIndex then
      return
    else
      PaGlobalFunc_WharfRegister_ClickList(self._value.currentMapaeIndex)
      self:updateMapaeList()
    end
  else
    PaGlobalFunc_WharfRegister_ClickList(self._value.currentMapaeIndex + 1)
  end
end
function PaGlobalFunc_WharfRegister_ClickList(index)
  local self = Panel_Window_WharfRegister_info
  self._value.lastMapaeIndex = self._value.currentMapaeIndex
  self._value.currentMapaeIndex = index
  self._value.lastMapaeSlotNo = self._value.currentMapaeSlotNo
  self._value.currentMapaeSlotNo = self._value.startMapaeIndex + self._value.currentMapaeIndex
  local slot = self._wharfSlotList[index]
  slot:selectSlot(true)
  self:setContent(self._enum.eTYEP_OPEN_MAPAE)
end
function PaGlobalFunc_WharfRegister_Register()
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = Panel_Window_WharfRegister_info
  local name = self._ui.edit_Name:GetEditText()
  local function do_regist()
    local self = Panel_Window_WharfRegister_info
    if CppEnums.ServantRegist.eEventType_Taming == self._value.currentOpenType then
      stable_register(name)
    elseif CppEnums.ServantRegist.eEventType_Inventory == self._value.currentOpenType then
      local invenSlotNo = self._wharfSlotList[self._value.currentMapaeIndex].itemSlotNo
      local invenType = self._wharfSlotList[self._value.currentMapaeIndex].invenType
      if -1 ~= invenSlotNo then
        stable_registerByItem(invenType, invenSlotNo, name)
      end
    elseif CppEnums.ServantRegist.eEventType_ChangeName == self._value.currentOpenType then
      local servantCount = stable_count()
      if servantCount > 0 then
        stable_changeName(PaGlobalFunc_WharfList_SelectSlotNo(), name)
      end
    else
      UI.ASSERT(false, "\236\151\144\235\159\172!")
    end
    PaGlobalFunc_WharfRegister_ExitAndOpenList()
  end
  ClearFocusEdit()
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLEREGISTER_THISNAMEREGISTER", "name", name)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = do_regist,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FromClient_WharfRegister_Init()
  local self = Panel_Window_WharfRegister_info
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WharfRegister_Init")
