local _panel = Panel_Window_DyeingRegister_Renew
_panel:ignorePadSnapMoveToOtherPanel()
local DyeingRegister = {
  _ui = {
    stc_titleBG = UI.getChildControl(_panel, "Static_TitleBg"),
    txt_titleTop = nil,
    stc_paletteBG = UI.getChildControl(_panel, "Static_PaletteBg"),
    stc_paletteGroup = nil,
    stc_slotBG = nil,
    stc_itemFocus = nil,
    scroll_itemList = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuideB = nil,
    txt_keyGuideA = nil
  },
  _defaultGab = 55,
  _startX = 15,
  _startY = 15,
  _scrollAmount = 0,
  _colMax = 8,
  _rowMax = 8,
  _waitForMessage = false,
  _currentSlotNo = 0,
  _currentIndex = 0,
  _dyeSlotNo = {}
}
local self = DyeingRegister
function FromClient_luaLoadComplete_DyeingRegister_Init()
  DyeingRegister:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingRegister_Init")
function DyeingRegister:initialize()
  self._ui.txt_titleTop = UI.getChildControl(self._ui.stc_titleBG, "StaticText_Title_Top")
  self._ui.stc_paletteGroup = UI.getChildControl(self._ui.stc_paletteBG, "Static_PaletteList")
  self._ui.scroll_itemList = UI.getChildControl(self._ui.stc_paletteGroup, "Scroll_PaletteItemList")
  self._ui.stc_slotBG = {}
  self._ui.slot_dyes = {}
  local slotConfig = {
    createIcon = true,
    createCount = false,
    createEnchant = true,
    createItemLock = true
  }
  local slotCount = self._colMax * self._rowMax
  for ii = 1, slotCount do
    self._ui.stc_slotBG[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_paletteGroup, "Static_SlotBGTemplate", self._ui.stc_paletteGroup, "Static_SlotBG_" .. ii)
    self._ui.stc_slotBG[ii]:SetPosX((ii - 1) % self._colMax * self._defaultGab + self._startX)
    self._ui.stc_slotBG[ii]:SetPosY(math.floor((ii - 1) / self._colMax) * self._defaultGab + self._startY)
    self._ui.slot_dyes[ii] = {}
    local slot = self._ui.slot_dyes[ii]
    SlotItem.new(slot, "CampEquip_" .. ii, ii, self._ui.stc_slotBG[ii], slotConfig)
    slot:createChild()
    slot.icon:SetIgnore(true)
    if ii <= self._colMax then
      self._ui.stc_slotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "InputScroll_DyeingRegister_Inventory(true)")
    elseif ii > self._colMax * (self._rowMax - 1) then
      self._ui.stc_slotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "InputScroll_DyeingRegister_Inventory(false)")
    end
  end
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_B_ConsoleUI")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_A_ConsoleUI")
  local tempBtnGroup = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:registMessageHandler()
end
function DyeingRegister:registMessageHandler()
  registerEvent("FromClient_UpdateDyeingPalette", "FromClient_DyeingRegister_Update")
end
function PaGlobalFunc_DyeingRegister_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_DyeingRegister_Open()
  DyeingRegister:open()
end
function PaGlobalFunc_DyeingRegister_Close()
  DyeingRegister:close()
end
function DyeingRegister:open()
  _panel:SetShow(true)
  self._scrollAmount = 0
  self._currentSlotNo = 0
  self._ui.scroll_itemList:SetControlPos(0)
  self:updateList()
end
function DyeingRegister:close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  _panel:SetShow(false)
  PaGlobalFunc_FloatingTooltip_Close()
end
function FromClient_DyeingRegister_Update()
  if true == _panel:GetShow() then
    self:updateList()
    InputMOn_DyeingRegister_MouseOverAmpule(self._currentIndex)
  end
  self._waitForMessage = false
  self._ui.txt_keyGuideA:SetMonoTone(false)
end
function DyeingRegister:updateList()
  local selfPlayer = getSelfPlayer()
  local playerLevel = selfPlayer:get():getLevel()
  local pearlInvenUseSize = selfPlayer:get():getInventorySlotCount(true)
  for ii = 1, #self._ui.slot_dyes do
    self._ui.slot_dyes[ii]:clearItem()
  end
  self._dyeSlotNo = {}
  for ii = __eTInventorySlotNoUseStart, pearlInvenUseSize do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, ii)
    if nil ~= itemWrapper then
      local isDyeAble = itemWrapper:getStaticStatus():get():isDyeingStaticStatus()
      if isDyeAble then
        self._dyeSlotNo[#self._dyeSlotNo + 1] = ii
      end
    end
  end
  for ii = 1, #self._ui.slot_dyes do
    if nil ~= self._dyeSlotNo[ii + self._scrollAmount] then
      local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, self._dyeSlotNo[ii + self._scrollAmount])
      if nil ~= itemWrapper then
        self._ui.slot_dyes[ii]:setItem(itemWrapper, self._dyeSlotNo[ii + self._scrollAmount])
      end
      self._ui.stc_slotBG[ii]:SetShow(true)
      self._ui.stc_slotBG[ii]:addInputEvent("Mouse_LUp", "PaGlobalFunc_DyeingRegister_Regist(" .. ii + self._scrollAmount .. ")")
      self._ui.stc_slotBG[ii]:addInputEvent("Mouse_On", "InputMOn_DyeingRegister_MouseOverAmpule(" .. ii + self._scrollAmount .. ")")
    else
      self._ui.stc_slotBG[ii]:addInputEvent("Mouse_LUp", "PaGlobalFunc_DyeingRegister_Regist()")
      self._ui.stc_slotBG[ii]:addInputEvent("Mouse_On", "InputMOn_DyeingRegister_MouseOverAmpule()")
    end
  end
  if #self._dyeSlotNo > #self._ui.slot_dyes then
    self._ui.scroll_itemList:SetShow(true)
    UIScroll.SetButtonSize(self._ui.scroll_itemList, #self._ui.slot_dyes, #self._dyeSlotNo)
  else
    self._ui.scroll_itemList:SetShow(false)
  end
end
function PaGlobalFunc_DyeingRegister_Regist(index)
  local slotNo = self._dyeSlotNo[index]
  if self._waitForMessage or nil == slotNo then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNo)
  if nil == itemWrapper then
    UI.ASSERT(nil ~= itemWrapper, "dye itemWrapper \235\138\148 nil\236\157\180\236\150\180\236\132\160 \236\149\136\235\144\169\235\139\136\235\141\148")
    return
  end
  local count_s64 = itemWrapper:get():getCount_s64()
  local function doInsertPalette()
    ToClient_requestCreateDyeingPaletteFromItem(CppEnums.ItemWhereType.eCashInventory, slotNo, count_s64)
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    self._waitForMessage = true
    self._ui.txt_keyGuideA:SetMonoTone(true)
  end
  local ampuleName = itemWrapper:getStaticStatus():getName()
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_PALETTE_SURE_THIS_AMPLUE", "itemName", ampuleName)
  local messageBoxData = {
    title = messageTitle,
    content = messageBoxMemo,
    functionYes = doInsertPalette,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function InputMOn_DyeingRegister_MouseOverAmpule(index)
  local slotNo = self._dyeSlotNo[index]
  if nil ~= slotNo then
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, slotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      self._currentSlotNo = slotNo
      self._currentIndex = index
      self._ui.txt_keyGuideA:SetShow(nil ~= itemWrapper)
      PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemNameOnly)
      return
    end
  end
  self._currentSlotNo = nil
  self._ui.txt_keyGuideA:SetShow(false)
  PaGlobalFunc_FloatingTooltip_Close()
end
function InputScroll_DyeingRegister_Inventory(isUp)
  local oldAmount = self._scrollAmount
  self._scrollAmount = UIScroll.ScrollEvent(self._ui.scroll_itemList, isUp, self._rowMax, 192, self._scrollAmount, self._colMax)
  if oldAmount ~= self._scrollAmount then
    self:updateList()
    if nil ~= self._currentSlotNo then
      self._currentSlotNo = self._currentSlotNo + self._scrollAmount - oldAmount
      InputMOn_DyeingRegister_MouseOverAmpule(self._currentSlotNo)
    end
  end
end
