local _panel = Panel_Window_DyeingTake_Renew
local PALETTE_TYPE = {ALL = 1, MINE = 2}
local PALETTE_CATEGORY = {
  NORMAL = 1,
  OLVIA = 2,
  VELIA = 3,
  HEIDEL = 4,
  KEPLAN = 5,
  CALPHEON = 6,
  MEDIAH = 7,
  VALENCIA = 8
}
local DyeingTake = {
  _ui = {
    stc_titleBG = UI.getChildControl(_panel, "Static_TitleBg"),
    txt_title = nil,
    stc_tabMenuBG = UI.getChildControl(_panel, "Static_TabMenuBG"),
    stc_keyGuideLB = nil,
    stc_keyGuideRB = nil,
    rdo_paletteTypes = {},
    stc_bodyBG = UI.getChildControl(_panel, "Static_SubFrameBG"),
    stc_paletteCategoryBG = nil,
    stc_keyGuideLT = nil,
    stc_keyGuideRT = nil,
    rdo_categoryTypes = {},
    stc_ampuleListBG = nil,
    stc_ampuleSlotBG = {},
    stc_garment = {},
    txt_ampuleCount = {},
    stc_itemFocus = nil,
    scroll_ampuleList = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuideB = nil,
    txt_keyGuideA = nil,
    txt_keyGuideY = nil
  },
  _defaultXGap = 75,
  _defaultYGap = 75,
  _ampuleListColCount = 7,
  _ampuleListRowCount = 10,
  _ampuleListStartX = 0,
  _ampuleListStartY = 0,
  _nowPaletteIndex = PALETTE_TYPE.MINE,
  _nowPaletteCategoryIndex = PALETTE_CATEGORY.NORMAL,
  _nowPaletteDataIndex = -1,
  _currentScrollAmount = 0,
  _currentFocusedIndex = 0,
  _paletteShowAll = true
}
function FromClient_luaLoadComplete_DyeingTake_Init()
  DyeingTake:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingTake_Init")
function DyeingTake:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_titleBG, "StaticText_Title_Top")
  self._ui.stc_keyGuideLB = UI.getChildControl(self._ui.stc_tabMenuBG, "Static_LB")
  self._ui.stc_keyGuideRB = UI.getChildControl(self._ui.stc_tabMenuBG, "Static_RB")
  self._ui.rdo_paletteTypes = {
    [PALETTE_TYPE.ALL] = UI.getChildControl(self._ui.stc_tabMenuBG, "RadioButton_AllPalette"),
    [PALETTE_TYPE.MINE] = UI.getChildControl(self._ui.stc_tabMenuBG, "RadioButton_MyPallete")
  }
  self._ui.stc_paletteCategoryBG = UI.getChildControl(self._ui.stc_bodyBG, "Static_SubTabMenuBG")
  self._ui.stc_keyGuideLT = UI.getChildControl(self._ui.stc_paletteCategoryBG, "Static_LT")
  self._ui.stc_keyGuideRT = UI.getChildControl(self._ui.stc_paletteCategoryBG, "Static_RT")
  self._ui.rdo_categoryTypes = {
    [PALETTE_CATEGORY.NORMAL] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Normal"),
    [PALETTE_CATEGORY.OLVIA] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Olvia"),
    [PALETTE_CATEGORY.VELIA] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Velia"),
    [PALETTE_CATEGORY.HEIDEL] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Heidel"),
    [PALETTE_CATEGORY.KEPLAN] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Keplan"),
    [PALETTE_CATEGORY.CALPHEON] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Calpheon"),
    [PALETTE_CATEGORY.MEDIAH] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_Mediah"),
    [PALETTE_CATEGORY.VALENCIA] = UI.getChildControl(self._ui.stc_paletteCategoryBG, "RadioButton_ValenCia")
  }
  self._ui.txt_categoryName = UI.getChildControl(self._ui.stc_bodyBG, "StaticText_CategoryName")
  if not ToClient_IsContentsGroupOpen("3") then
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.MEDIAH]:SetShow(false)
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.MEDIAH] = nil
  end
  if not ToClient_IsContentsGroupOpen("4") then
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.VALENCIA]:SetShow(false)
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.VALENCIA] = nil
  end
  local centerX = self._ui.stc_paletteCategoryBG:GetSizeX() / 2
  local iconGap = self._ui.rdo_categoryTypes[1]:GetSizeX() + 12
  local tabCount = #self._ui.rdo_categoryTypes
  local startX = centerX - tabCount * iconGap / 2
  for ii = 1, tabCount do
    self._ui.rdo_categoryTypes[ii]:SetPosX(startX + iconGap * (ii - 1))
  end
  self._ui.stc_ampuleListBG = UI.getChildControl(self._ui.stc_bodyBG, "Static_PaletteListBG")
  self._ui.scroll_ampuleList = UI.getChildControl(self._ui.stc_ampuleListBG, "Scroll_PaletteItemList")
  self._ui.stc_itemFocus = UI.getChildControl(self._ui.stc_ampuleListBG, "Static_Item_Focus")
  self._ui.stc_itemFocus:SetShow(false)
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_B_ConsoleUI")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_A_ConsoleUI")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_Y_ConsoleUI")
  self._ui.txt_keyGuideY:SetShow(false)
  local keyGuideList = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:initAmpuleList()
  self:registEventHandler()
  self:registMessageHandler()
end
function DyeingTake:initAmpuleList()
  local ampuleSlotCount = self._ampuleListColCount * self._ampuleListRowCount
  self._ui.stc_ampuleSlotBG = {}
  local template = UI.getChildControl(self._ui.stc_ampuleListBG, "Static_PaletteItem_Template")
  for ii = 1, ampuleSlotCount do
    self._ui.stc_ampuleSlotBG[ii] = UI.cloneControl(template, self._ui.stc_ampuleListBG, "Static_PaletteItem_" .. ii)
    self._ui.stc_garment[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "Static_Garment")
    self._ui.stc_garment[ii]:SetIgnore(true)
    self._ui.txt_ampuleCount[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "StaticText_Count")
    self._ui.stc_ampuleSlotBG[ii]:SetPosX(self._ampuleListStartX + (ii - 1) % self._ampuleListColCount * self._defaultXGap)
    self._ui.stc_ampuleSlotBG[ii]:SetPosY(self._ampuleListStartY + math.floor((ii - 1) / self._ampuleListColCount) * self._defaultYGap)
    self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
    if ii <= self._ampuleListColCount then
      self._ui.stc_ampuleSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "InputScroll_DyeingTake_Scroll(true)")
    elseif ii > ampuleSlotCount - self._ampuleListColCount then
      self._ui.stc_ampuleSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "InputScroll_DyeingTake_Scroll(false)")
    end
    self._ui.stc_ampuleSlotBG[ii]:addInputEvent("Mouse_On", "HandleEventMouseOn_showAmpuleTooltip(" .. ii .. ")")
  end
  template:SetShow(false)
end
function DyeingTake:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_DyeingTake_NextPalette(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_DyeingTake_NextPalette(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_DyeingTake_NextCategory(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_DyeingTake_NextCategory(1)")
end
function DyeingTake:registMessageHandler()
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_DyeingTake_PadSnapChangePanel")
  registerEvent("FromClient_UpdateDyeingPalette", "FromClient_DyeingTake_Update")
end
function PaGlobalFunc_DyeingTake_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_DyeingTake_Open()
  DyeingTake:open()
end
function DyeingTake:open()
  _panel:SetShow(true)
  self._nowPaletteIndex = PALETTE_TYPE.MINE
  self._paletteShowAll = PALETTE_TYPE.ALL == self._nowPaletteIndex
  self:setPalette(self._nowPaletteIndex)
  self:setCategory(self._nowPaletteCategoryIndex)
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updatePalette()
  PaGlobalFunc_DyeingMain_ShowKeyGuideRSClick(false)
  PaGlobalFunc_DyeingMain_ShowKeyGuideB(false)
  PaGlobalFunc_DyeingMain_ShowKeyGuideLT(false)
end
function PaGlobalFunc_DyeingTake_Close()
  DyeingTake:close()
end
function DyeingTake:close()
  PaGlobalFunc_DyeingMain_ShowKeyGuideRSClick(true)
  PaGlobalFunc_DyeingMain_ShowKeyGuideB(true)
  PaGlobalFunc_DyeingMain_ShowKeyGuideLT(true)
  PaGlobalFunc_FloatingTooltip_Close()
  _panel:SetShow(false)
end
function DyeingTake:updatePalette()
  if false == _panel:GetShow() then
    return
  end
  self._paletteShowAll = PALETTE_TYPE.ALL == self._nowPaletteIndex
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(self._nowPaletteCategoryIndex - 1, self._paletteShowAll)
  local arrCount = 1
  if nil ~= DyeingPaletteCategoryInfo then
    arrCount = DyeingPaletteCategoryInfo:getListSize()
    self._paletteCount = arrCount
    for ii = 1, #self._ui.stc_ampuleSlotBG do
      local dataIdx = self._currentScrollAmount + ii
      if arrCount >= dataIdx then
        self._ui.stc_ampuleSlotBG[ii]:SetShow(true)
        self._ui.txt_ampuleCount[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "StaticText_Count")
        self._ui.txt_ampuleCount[ii]:SetText(tostring(DyeingPaletteCategoryInfo:getCount(dataIdx - 1, true)))
        local itemEnchantKey = DyeingPaletteCategoryInfo:getItemEnchantKey(dataIdx - 1)
        local garment = self._ui.stc_garment[ii]
        garment:SetAlphaIgnore(true)
        garment:SetColor(DyeingPaletteCategoryInfo:getColor(dataIdx - 1))
        self._ui.stc_ampuleSlotBG[ii]:addInputEvent("Mouse_LUp", "Input_DyeingTake_Ampule(" .. ii .. ")")
      else
        self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
      end
    end
  else
    for ii = 1, #self._ui.stc_ampuleSlotBG do
      self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
    end
  end
  UIScroll.SetButtonSize(self._ui.scroll_ampuleList, self._ampuleListColCount * self._ampuleListRowCount, arrCount)
  HandleEventMouseOn_showAmpuleTooltip(self._currentFocusedIndex)
end
function Input_DyeingTake_NextPalette(nextPaletteIndex)
  local self = DyeingTake
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  self:setPalette(nextPaletteIndex)
  self._isPearlPalette = PALETTE_TYPE.MERV == self._nowPaletteIndex
  self._paletteShowAll = PALETTE_TYPE.ALL == self._nowPaletteIndex
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updatePalette()
end
local _paletteStringTable = {
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_ALL"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MY")
}
function DyeingTake:setPalette(nextPaletteIndex)
  for ii = 1, #self._ui.rdo_paletteTypes do
    self._ui.rdo_paletteTypes[ii]:SetCheck(false)
  end
  local targetPalette = self._nowPaletteIndex + nextPaletteIndex
  if targetPalette < 1 then
    targetPalette = #self._ui.rdo_paletteTypes
  elseif targetPalette > #self._ui.rdo_paletteTypes then
    targetPalette = 1
  end
  if PALETTE_TYPE.MERV == targetPalette and not self:isPlayerHaveActivedMerv() then
    targetPalette = self._nowPaletteIndex
  end
  self._nowPaletteIndex = targetPalette
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DYE_EJECT_TITLE") .. " - " .. _paletteStringTable[self._nowPaletteIndex])
  self._ui.rdo_paletteTypes[self._nowPaletteIndex]:SetCheck(true)
end
function DyeingTake:isPlayerHaveActivedMerv()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  return selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_DyeingPackage)
end
local _categoryStringTable = {
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_0"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_1"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_2"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_3"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_4"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_5"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_6"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_7")
}
function Input_DyeingTake_NextCategory(nextCategoryIndex)
  local self = DyeingTake
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  local targetCategory = self._nowPaletteCategoryIndex + nextCategoryIndex
  if targetCategory < 1 then
    targetCategory = #self._ui.rdo_categoryTypes
  elseif targetCategory > #self._ui.rdo_categoryTypes then
    targetCategory = 1
  end
  self._nowPaletteCategoryIndex = targetCategory
  self:setCategory(self._nowPaletteCategoryIndex)
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updatePalette()
end
function DyeingTake:setCategory(index)
  for ii = 1, #self._ui.rdo_categoryTypes do
    self._ui.rdo_categoryTypes[ii]:SetCheck(false)
  end
  local rdo = self._ui.rdo_categoryTypes[self._nowPaletteCategoryIndex]
  self._ui.txt_categoryName:SetText(_categoryStringTable[self._nowPaletteCategoryIndex])
  rdo:SetCheck(true)
end
function Input_DyeingTake_Ampule(ii)
  local self = DyeingTake
  local isShowAll = self._paletteShowAll
  local categoryIndex = self._nowPaletteCategoryIndex
  local dataIndex = self._currentScrollAmount + ii
  local itemCount = tonumber(self._ui.txt_ampuleCount[ii]:GetText())
  if "number" ~= type(itemCount) or nil == dataIndex or nil == isShowAll or nil == categoryIndex then
    return
  end
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(categoryIndex - 1, isShowAll)
  if nil == DyeingPaletteCategoryInfo then
    return
  end
  local itemEnchantKey = DyeingPaletteCategoryInfo:getItemEnchantKey(dataIndex - 1)
  local itemEnchantSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  local itemEnchantSS = itemEnchantSSW:get()
  local itemName = getItemName(itemEnchantSS)
  local function doExportPalette()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    ToClient_requestChangeDyeingPaletteToItem(categoryIndex - 1, dataIndex - 1, itemCount, isShowAll)
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local messageBoxMemo = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_PALETTE_SURE_GET_THIS_AMPLUE", "itemName", itemName, "itemCount", tostring(itemCount))
  local messageBoxData = {
    title = messageTitle,
    content = messageBoxMemo,
    functionYes = doExportPalette,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  PaGlobalFunc_DyeingMain_ShowKeyGuideB(false)
end
function HandleEventMouseOn_showAmpuleTooltip(ii)
  local dataIndex = DyeingTake._currentScrollAmount + ii
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(DyeingTake._nowPaletteCategoryIndex - 1, DyeingTake._paletteShowAll)
  if nil == DyeingPaletteCategoryInfo then
    return
  end
  DyeingTake._currentFocusedIndex = ii
  local itemEnchantKey = DyeingPaletteCategoryInfo:getItemEnchantKey(dataIndex - 1)
  local itemEnchantSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemEnchantSSW, Defines.TooltipTargetType.ItemNameOnly)
end
function InputScroll_DyeingTake_Scroll(isUp)
  local self = DyeingTake
  if nil ~= self._paletteCount then
    self._currentScrollAmount = UIScroll.ScrollEvent(self._ui.scroll_ampuleList, isUp, self._ampuleListRowCount, self._paletteCount, self._currentScrollAmount, self._ampuleListColCount)
    _AudioPostEvent_SystemUiForXBOX(51, 4)
  end
  if ToClient_isConsole() or ToClient_IsDevelopment() then
    ToClient_padSnapIgnoreGroupMove()
  end
  self:updatePalette()
end
function FromClient_DyeingTake_Update()
  DyeingTake:updatePalette()
end
function FromClient_DyeingTake_PadSnapChangePanel(fromPanel, toPanel)
  local self = DyeingTake
  if nil ~= toPanel and _panel:GetKey() == toPanel:GetKey() then
    self._ui.stc_keyGuideLB:SetShow(true)
    self._ui.stc_keyGuideRB:SetShow(true)
    self._ui.stc_keyGuideLT:SetShow(true)
    self._ui.stc_keyGuideRT:SetShow(true)
    self._ui.txt_keyGuideB:SetShow(true)
    self._ui.txt_keyGuideA:SetShow(true)
  else
    self._ui.stc_keyGuideLB:SetShow(false)
    self._ui.stc_keyGuideRB:SetShow(false)
    self._ui.stc_keyGuideLT:SetShow(false)
    self._ui.stc_keyGuideRT:SetShow(false)
    self._ui.txt_keyGuideB:SetShow(false)
    self._ui.txt_keyGuideA:SetShow(false)
  end
end
