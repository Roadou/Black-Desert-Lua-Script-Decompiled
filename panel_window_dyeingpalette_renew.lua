local _panel = Panel_Window_DyeingPalette_Renew
local PALETTE_TYPE = {
  ALL = 1,
  MINE = 2,
  MERV = 3
}
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
local DyeingPalette = {
  _ui = {
    stc_tabMenuBG = UI.getChildControl(_panel, "Static_TabMenuBG"),
    stc_keyGuideLB = nil,
    stc_keyGuideRB = nil,
    rdo_paletteTypes = nil,
    txt_title = UI.getChildControl(_panel, "StaticText_Title_Top"),
    stc_body = UI.getChildControl(_panel, "Static_SubFrameBg"),
    stc_subTabBG = nil,
    stc_keyGuideLT = nil,
    stc_keyGuideRT = nil,
    rdo_categoryTypes = nil,
    stc_partSelectBG = nil,
    rdo_color = {},
    stc_partColor = {},
    stc_ampuleListBG = nil,
    stc_ampuleSlotBG = {},
    stc_garment = {},
    txt_ampuleCount = {},
    scroll_ampuleList = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuideB = nil,
    txt_keyGuideA = nil,
    txt_keyGuideX = nil,
    stc_leftBottomBG = UI.getChildControl(_panel, "Static_LeftBottomBg"),
    txt_keyGuideLTPlusY = nil,
    txt_keyGuideRS = nil
  },
  _defaultXGap = 75,
  _defaultYGap = 75,
  _ampuleListColCount = 7,
  _ampuleListRowCount = 7,
  _ampuleListStartX = 30,
  _ampuleListStartY = 40,
  _nowPaletteIndex = PALETTE_TYPE.ALL,
  _nowPaletteCategoryIndex = PALETTE_CATEGORY.NORMAL,
  _nowPaletteAmpuleIndex = -1,
  _nowClickPartId = 0,
  _nowClickPartSlotId = 0,
  _currentScrollAmount = 0,
  _partDyeInfo = {},
  _selectedDyePart = {},
  _slotNo = nil,
  _isPearlPalette = false,
  _paletteShowAll = true,
  _currentDyePartIndex = nil,
  _currentFocusedIndex = 1,
  _isOnPalette = false
}
function FromClient_luaLoadComplete_DyeingPalette_Init()
  DyeingPalette:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_DyeingPalette_Init")
function DyeingPalette:initialize()
  self._ui.stc_keyGuideLB = UI.getChildControl(self._ui.stc_tabMenuBG, "Static_LB")
  self._ui.stc_keyGuideRB = UI.getChildControl(self._ui.stc_tabMenuBG, "Static_RB")
  self._ui.rdo_paletteTypes = {
    [PALETTE_TYPE.ALL] = UI.getChildControl(self._ui.stc_tabMenuBG, "RadioButton_AllPalette"),
    [PALETTE_TYPE.MINE] = UI.getChildControl(self._ui.stc_tabMenuBG, "RadioButton_MyPallete"),
    [PALETTE_TYPE.MERV] = UI.getChildControl(self._ui.stc_tabMenuBG, "RadioButton_MervPallete")
  }
  self._ui.stc_subTabBG = UI.getChildControl(self._ui.stc_body, "Static_SubTabMenuBG")
  self._ui.stc_keyGuideLT = UI.getChildControl(self._ui.stc_subTabBG, "Static_LT")
  self._ui.stc_keyGuideRT = UI.getChildControl(self._ui.stc_subTabBG, "Static_RT")
  self._ui.txt_categoryName = UI.getChildControl(self._ui.stc_body, "StaticText_CategoryName")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_B_ConsoleUI")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_A_ConsoleUI")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_X_ConsoleUI")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_Y_ConsoleUI")
  self._ui.txt_keyGuideLTPlusY = UI.getChildControl(self._ui.stc_leftBottomBG, "StaticText_LTPlusY_ConsoleUI")
  self._ui.txt_keyGuideRS = UI.getChildControl(self._ui.stc_leftBottomBG, "StaticText_RS_ConsoleUI")
  self._ui.txt_keyGuideLTPlusY:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUNICON"))
  self._ui.rdo_categoryTypes = {
    [PALETTE_CATEGORY.NORMAL] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Normal"),
    [PALETTE_CATEGORY.OLVIA] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Olvia"),
    [PALETTE_CATEGORY.VELIA] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Velia"),
    [PALETTE_CATEGORY.HEIDEL] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Heidel"),
    [PALETTE_CATEGORY.KEPLAN] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Keplan"),
    [PALETTE_CATEGORY.CALPHEON] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Calpheon"),
    [PALETTE_CATEGORY.MEDIAH] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_Mediah"),
    [PALETTE_CATEGORY.VALENCIA] = UI.getChildControl(self._ui.stc_subTabBG, "RadioButton_ValenCia")
  }
  if not ToClient_IsContentsGroupOpen("3") then
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.MEDIAH]:SetShow(false)
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.MEDIAH] = nil
  end
  if not ToClient_IsContentsGroupOpen("4") then
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.VALENCIA]:SetShow(false)
    self._ui.rdo_categoryTypes[PALETTE_CATEGORY.VALENCIA] = nil
  end
  local centerX = self._ui.stc_subTabBG:GetSizeX() / 2
  local iconGap = self._ui.rdo_categoryTypes[1]:GetSizeX() + 12
  local tabCount = #self._ui.rdo_categoryTypes
  local startX = centerX - tabCount * iconGap / 2
  for ii = 1, tabCount do
    self._ui.rdo_categoryTypes[ii]:SetPosX(startX + iconGap * (ii - 1))
  end
  self._ui.stc_partSelectBG = UI.getChildControl(self._ui.stc_body, "Static_PartSelect")
  self._ui.txt_partSelectTitle = UI.getChildControl(self._ui.stc_partSelectBG, "StaticText_PartSelectTitle")
  for ii = 1, 18 do
    self._ui.rdo_color[ii] = UI.getChildControl(self._ui.stc_partSelectBG, "Radiobutton_ColorBg_" .. ii)
    self._ui.stc_partColor[ii] = UI.getChildControl(self._ui.rdo_color[ii], "Static_Color_" .. ii)
  end
  self._ui.stc_ampuleListBG = UI.getChildControl(self._ui.stc_body, "Static_PaletteListBG")
  self._ui.scroll_ampuleList = UI.getChildControl(self._ui.stc_ampuleListBG, "Scroll_PaletteItemList")
  UIScroll.InputEvent(self._ui.scroll_ampuleList, "InputScroll_DyeingPalette_Scroll")
  UIScroll.InputEventByControl(self._ui.stc_ampuleListBG, "InputScroll_DyeingPalette_Scroll")
  self._ui.txt_keyGuideX:SetShow(false)
  local keyGuideList = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideY,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  local leftKeyGuideList = {
    self._ui.txt_keyGuideLTPlusY,
    self._ui.txt_keyGuideRS
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(leftKeyGuideList, self._ui.stc_leftBottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:initAmpuleList()
  self:registEventHandler()
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_DyeingPalette_PadSnapChangePanel")
end
function DyeingPalette:initAmpuleList()
  local ampuleSlotCount = self._ampuleListColCount * self._ampuleListRowCount
  self._ui.stc_ampuleSlotBG = {}
  local template = UI.getChildControl(self._ui.stc_ampuleListBG, "Static_PaletteItem_Template")
  for ii = 1, ampuleSlotCount do
    self._ui.stc_ampuleSlotBG[ii] = UI.cloneControl(template, self._ui.stc_ampuleListBG, "Static_PaletteItem_" .. ii)
    self._ui.stc_garment[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "Static_Garment")
    self._ui.txt_ampuleCount[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "StaticText_Count")
    self._ui.stc_ampuleSlotBG[ii]:SetPosX(self._ampuleListStartX + (ii - 1) % self._ampuleListColCount * self._defaultXGap)
    self._ui.stc_ampuleSlotBG[ii]:SetPosY(self._ampuleListStartY + math.floor((ii - 1) / self._ampuleListColCount) * self._defaultYGap)
    self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
    if ii <= self._ampuleListColCount then
      self._ui.stc_ampuleSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "InputScroll_DyeingPalette_Scroll(true)")
    elseif ii > ampuleSlotCount - self._ampuleListColCount then
      self._ui.stc_ampuleSlotBG[ii]:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "InputScroll_DyeingPalette_Scroll(false)")
    end
    self._ui.stc_ampuleSlotBG[ii]:addInputEvent("Mouse_On", "HandleEventMouseOn_DyeingPalette_ShowTooltip(" .. ii .. ")")
    self._ui.stc_ampuleSlotBG[ii]:addInputEvent("Mouse_Out", "HandleEventMouseOut_DyeingPalette_HideTooltip()")
  end
  template:SetShow(false)
end
function DyeingPalette:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_DyeingPalette_NextPalette(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_DyeingPalette_NextPalette(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_DyeingPalette_NextCategory(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RT, "Input_DyeingPalette_NextCategory(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "Input_DyeingPalette_ApplyDye()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_Dyeing_ChangeWeather()")
end
function PaGlobalFunc_DyeingPalette_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_DyeingPalette_Open(targetType, slotNo)
  DyeingPalette:open(targetType, slotNo)
end
function DyeingPalette:open(targetType, slotNo)
  if false == _panel:GetShow() then
    _panel:SetShow(true)
  end
  PaGlobalFunc_DyeingMain_ShowKeyGuideB(false)
  PaGlobalFunc_DyeingMain_ShowKeyGuideRS(false)
  PaGlobalFunc_DyeingMain_ShowKeyGuideLT(false)
  ToClient_RequestSelectedEquipItem(slotNo)
  if 29 == slotNo or 30 == slotNo then
    ToClient_SetAwakenWeaponShow(true)
  else
    ToClient_SetAwakenWeaponShow(false)
  end
  self._selected_CharacterTarget = targetType
  self._slotNo = slotNo
  for ii = 1, #self._ui.rdo_color do
    self._ui.rdo_color[ii]:SetCheck(false)
  end
  if self:isPlayerHaveActivedMerv() then
    self._nowPaletteIndex = PALETTE_TYPE.MERV
  end
  self:setPalette(self._nowPaletteIndex)
  self:setCategory(self._nowPaletteCategoryIndex)
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updateDyeParts()
  if true == self._ui.rdo_color[1]:GetShow() then
    self._nowClickPartId = 1
    self._nowClickPartSlotId = 1
  end
  self:updatePalette()
end
function PaGlobalFunc_DyeingPalette_Close()
  DyeingPalette:close()
end
function DyeingPalette:close()
  PaGlobalFunc_DyeingMain_ShowKeyGuideLT(true)
  PaGlobalFunc_DyeingMain_ShowKeyGuideRS(true)
  PaGlobalFunc_DyeingMain_ShowKeyGuideB(true)
  self._nowClickPartId = -1
  self._nowClickPartSlotId = -1
  _panel:SetShow(false)
  PaGlobalFunc_FloatingTooltip_Close()
end
function DyeingPalette:updateDyeParts()
  if false == _panel:GetShow() then
    return
  end
  ToClient_SetDyeingTargetInformationByEquipNo(self._slotNo)
  local colorSlotCount = ToClient_getDyeingTargetInformationCount()
  for ii = 1, colorSlotCount do
    self._ui.rdo_color[ii]:SetShow(true)
    local partIdx = ToClient_getDyeingTargetPartIdxByIndex(ii - 1)
    local slotIdx = ToClient_getDyeingTartSlotIndexByIndex(ii - 1)
    local DyeSlotIdx = ToClient_getDyeingTargetDyeSlotIndexByIndex(ii - 1)
    local PartSlot = self._ui.rdo_color[ii]
    PartSlot:addInputEvent("Mouse_LUp", "Input_DyeingPalette_DyePart( " .. partIdx .. ", " .. slotIdx .. "," .. ii .. ")")
    PartSlot:SetShow(true)
    local getColorInfo = ToClient_RequestGetUsedPartColor(self._slotNo, partIdx, slotIdx)
    self._ui.stc_partColor[ii]:SetAlphaIgnore(true)
    self._ui.stc_partColor[ii]:SetColor(getColorInfo)
    self._ui.stc_partColor[ii]:SetShow(true)
    self._partDyeInfo[ii] = {
      partIdx,
      slotIdx,
      DyeSlotIdx
    }
  end
  for ii = colorSlotCount + 1, #self._ui.rdo_color do
    self._ui.rdo_color[ii]:SetShow(false)
  end
end
function Input_DyeingPalette_DyePart(partID, slotID, uiIdx)
  local self = DyeingPalette
  ToClient_RequestSelectedDyeingPartSlot(self._slotNo, partID, slotID)
  for ii = 1, #self._ui.stc_partColor do
    self._ui.stc_partColor[ii]:SetShow(true)
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self._currentDyePartIndex = uiIdx
  self._ui.stc_partColor[uiIdx]:SetShow(false)
  self._nowClickPartId = partID
  self._nowClickPartSlotId = slotID
  self._ui.stc_ampuleListBG:SetShow(true)
  self:updatePalette()
end
function DyeingPalette:updatePalette()
  if false == _panel:GetShow() then
    return
  end
  self._isPearlPalette = PALETTE_TYPE.MERV == self._nowPaletteIndex
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(self._nowPaletteCategoryIndex - 1, self._paletteShowAll)
  local arrCount = 1
  for ii = 1, #self._ui.stc_ampuleSlotBG do
    self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
  end
  if nil ~= DyeingPaletteCategoryInfo then
    arrCount = DyeingPaletteCategoryInfo:getListSize()
    self._paletteCount = arrCount
    for ii = 1, #self._ui.stc_ampuleSlotBG do
      self._ui.stc_ampuleSlotBG[ii]:SetShow(true)
      local index = self._currentScrollAmount + ii
      if arrCount >= index then
        self._ui.stc_ampuleSlotBG[ii]:SetShow(true)
        self._ui.txt_ampuleCount[ii] = UI.getChildControl(self._ui.stc_ampuleSlotBG[ii], "StaticText_Count")
        if false == self._isPearlPalette then
          self._ui.txt_ampuleCount[ii]:SetShow(true)
          self._ui.txt_ampuleCount[ii]:SetText(tostring(DyeingPaletteCategoryInfo:getCount(index - 1, true)))
        else
          self._ui.txt_ampuleCount[ii]:SetShow(false)
        end
        local itemEnchantKey = DyeingPaletteCategoryInfo:getItemEnchantKey(index - 1)
        local garment = self._ui.stc_garment[ii]
        garment:SetAlphaIgnore(true)
        garment:SetColor(DyeingPaletteCategoryInfo:getColor(index - 1))
        self._ui.stc_ampuleSlotBG[ii]:addInputEvent("Mouse_LUp", "Input_DyeingPalette_Ampule(" .. index .. ")")
      else
        self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
      end
    end
  else
    for ii = 1, #self._ui.stc_ampuleSlotBG do
      self._ui.stc_ampuleSlotBG[ii]:SetShow(false)
    end
  end
  UIScroll.SetButtonSize(self._ui.scroll_ampuleList, #self._ui.stc_ampuleSlotBG, arrCount)
  if true == self._isOnPalette then
    HandleEventMouseOn_DyeingPalette_ShowTooltip(self._currentFocusedIndex)
  end
end
function Input_DyeingPalette_Ampule(index)
  local self = DyeingPalette
  self._nowPaletteAmpuleIndex = index
  if -1 == self._selected_EquipSlotNo or -1 == self._nowClickPartId then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(self._nowPaletteCategoryIndex - 1, self._paletteShowAll)
  local ampuleCount = DyeingPaletteCategoryInfo:getCount(self._nowPaletteAmpuleIndex - 1, true)
  local convertCount = tostring(ampuleCount)
  convertCount = tonumber(convertCount)
  if convertCount >= 1 then
    self._ampuleIsShort = false
  else
    self._ampuleIsShort = true
    if true == self._isPearlPalette then
      self._ampuleIsShort = false
    end
  end
  ToClient_RequestSelectedDyeingPalette(self._slotNo, self._nowClickPartId, self._nowClickPartSlotId, self._nowPaletteCategoryIndex - 1, index - 1, self._paletteShowAll)
  if 0 < ToClient_RequestGetPartDyeingSlotCount(self._slotNo, 0) then
    table.insert(self._selectedDyePart, self._slotNo)
  end
  self:updateDyeParts()
  self:updatePalette()
end
function HandleEventMouseOn_DyeingPalette_ShowTooltip(index)
  local self = DyeingPalette
  DyeingPalette._isOnPalette = true
  local dataIndex = DyeingPalette._currentScrollAmount + index
  local DyeingPaletteCategoryInfo = ToClient_requestGetPaletteCategoryInfo(self._nowPaletteCategoryIndex - 1, self._paletteShowAll)
  local itemEnchantKey = DyeingPaletteCategoryInfo:getItemEnchantKey(dataIndex - 1)
  if nil ~= itemEnchantKey then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
    if nil ~= itemSSW then
      self._currentFocusedIndex = index
      PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemNameOnly)
      return
    end
  end
end
function HandleEventMouseOut_DyeingPalette_HideTooltip()
  DyeingPalette._isOnPalette = false
  PaGlobalFunc_FloatingTooltip_Close()
end
function PaGlobalFunc_DyeingPalette_CleanData()
  DyeingPalette._selectedDyePart = {}
end
function InputScroll_DyeingPalette_Scroll(isUp)
  local self = DyeingPalette
  local oldAmount = self._currentScrollAmount
  if nil ~= self._paletteCount then
    self._currentScrollAmount = UIScroll.ScrollEvent(self._ui.scroll_ampuleList, isUp, self._ampuleListRowCount, self._paletteCount, self._currentScrollAmount, self._ampuleListColCount)
    _AudioPostEvent_SystemUiForXBOX(51, 4)
  end
  if oldAmount ~= self._currentScrollAmount and (ToClient_isConsole() or ToClient_IsDevelopment()) then
    ToClient_padSnapIgnoreGroupMove()
  end
  self:updatePalette()
end
function Input_DyeingPalette_NextPalette(val)
  local self = DyeingPalette
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  local targetPalette = self._nowPaletteIndex + val
  if targetPalette < 1 then
    targetPalette = #self._ui.rdo_paletteTypes
  elseif targetPalette > #self._ui.rdo_paletteTypes then
    targetPalette = 1
  end
  if PALETTE_TYPE.MERV == targetPalette then
    if not self:isPlayerHaveActivedMerv() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_MUST_ACTIVE_PEARLCOLOR"))
      targetPalette = self._nowPaletteIndex
    else
      ToClient_RequestClearDyeingSlot(self._slotNo)
      Input_DyeingPalette_EquipPartReset()
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_PALETTE_PREVIEW_ACK"))
    end
  end
  self:setPalette(targetPalette)
end
local _paletteStringTable = {
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_ALL"),
  PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MY"),
  PAGetString(Defines.StringSheet_GAME, "LUA_SELFPLAYEREXPGAUGE_DYEINGPACKEAGE_TITLE")
}
function DyeingPalette:setPalette(val)
  self._nowPaletteIndex = val
  self._isPearlPalette = PALETTE_TYPE.MERV == self._nowPaletteIndex
  self._paletteShowAll = PALETTE_TYPE.ALL == self._nowPaletteIndex or PALETTE_TYPE.MERV == self._nowPaletteIndex
  self._ui.txt_title:SetText(_paletteStringTable[self._nowPaletteIndex])
  for ii = 1, #self._ui.rdo_paletteTypes do
    self._ui.rdo_paletteTypes[ii]:SetCheck(false)
  end
  self._ui.rdo_paletteTypes[self._nowPaletteIndex]:SetCheck(true)
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updatePalette()
end
function DyeingPalette:isPlayerHaveActivedMerv()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return false
  end
  return selfPlayer:get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_DyeingPackage)
end
function Input_DyeingPalette_NextCategory(nextCategoryIndex)
  local self = DyeingPalette
  _AudioPostEvent_SystemUiForXBOX(51, 7)
  self:setCategory(nextCategoryIndex)
  self._currentScrollAmount = 0
  self._ui.scroll_ampuleList:SetControlPos(0)
  self:updatePalette()
end
local _categoryStringTable = {
  [PALETTE_CATEGORY.NORMAL] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_0"),
  [PALETTE_CATEGORY.OLVIA] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_1"),
  [PALETTE_CATEGORY.VELIA] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_2"),
  [PALETTE_CATEGORY.HEIDEL] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_3"),
  [PALETTE_CATEGORY.KEPLAN] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_4"),
  [PALETTE_CATEGORY.CALPHEON] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_5"),
  [PALETTE_CATEGORY.MEDIAH] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_6"),
  [PALETTE_CATEGORY.VALENCIA] = PAGetString(Defines.StringSheet_GAME, "LUA_PALETTE_TAB_MATERIAL_7")
}
function DyeingPalette:setCategory(nextCategoryIndex)
  for ii = 1, #self._ui.rdo_categoryTypes do
    self._ui.rdo_categoryTypes[ii]:SetCheck(false)
  end
  local targetCategory = self._nowPaletteCategoryIndex + nextCategoryIndex
  if targetCategory < 1 then
    targetCategory = #self._ui.rdo_categoryTypes
  elseif targetCategory > #self._ui.rdo_categoryTypes then
    targetCategory = 1
  end
  self._nowPaletteCategoryIndex = targetCategory
  self._ui.rdo_categoryTypes[self._nowPaletteCategoryIndex]:SetCheck(true)
  self._ui.txt_categoryName:SetText(_categoryStringTable[self._nowPaletteCategoryIndex])
end
function Input_DyeingPalette_ResetKeyGuide(isShow, equipSlotNo, partId, slotId)
end
function Input_DyeingPalette_EquipPartReset(equipSlotNo, partId, slotId)
  local self = DyeingPalette
  ToClient_RequestClearUsedDyeingPalette(equipSlotNo, partId, slotId)
  table.remove(self._selectedDyePart, self._selectedDyePart[equipSlotNo])
  self:updateDyeParts()
end
local _dyePartString = {
  [0] = {
    [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_MAINHAND"),
    [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_SUBHAND"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ARMOR"),
    [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_GLOVES"),
    [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_BOOTS"),
    [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_HELM"),
    [18] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_MAINHAND"),
    [19] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIP_AVATAR_SUBHAND"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BODY"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HANDS"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BOOTS"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HELM"),
    [20] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_UNDERWEAR"),
    [21] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_0"),
    [22] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_1"),
    [23] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CHARACTER_ACC_2"),
    [29] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_awakenWeapon"),
    [30] = PAGetString(Defines.StringSheet_GAME, "Lua_EquipSlotNo_String_avatarAwakenWeapon")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_BODY"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_TIRE"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_FLAG"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_INSIGNIA"),
    [13] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_LAMP"),
    [25] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_CORVER"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_BODY"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_TIRE"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_FLAG"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_INSIGNIA"),
    [26] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_CARRIAGE_AVATAR_CORVER")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [12] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_FOOT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_ARMOR"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_STIRRUP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_SADDLE"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_DYEPART_HORSE_AVATAR_FACE")
  },
  {
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_WAREHOUSE"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_REPAIRSHOP"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_SHOP"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_TENT"),
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_WAREHOUSE"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_REPAIRSHOP"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_SHOP"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_DYERENEW_DYEPART_CAMPTENT_TENT")
  }
}
function Input_DyeingPalette_ApplyDye()
  local self = DyeingPalette
  if 1 > #self._selectedDyePart then
    return
  end
  local dyePart = ""
  local equipSlotNo = self._slotNo
  if -1 == self._nowPaletteAmpuleIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYE_NEW_FIRSTSELECTDYENOGETITEM"))
    return
  end
  if true == self._ampuleIsShort then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYE_AMPULEALERT"))
    return
  end
  local noAction = function()
    return
  end
  local function doDye()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    ToClient_RequestDye(self._isPearlPalette)
    PaGlobalFunc_Dyeing_CloseAll()
  end
  local function askDoDye()
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_DYENEW_SURE_DYE_THIS_PART", "partString", dyePart)
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = doDye,
      functionNo = noAction,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  local function alreadyPearlDye()
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_ALREADY_PEARLCOLOR")
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = askDoDye,
      functionNo = noAction,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  table.sort(self._selectedDyePart)
  for index, value in pairs(self._selectedDyePart) do
    if "" == dyePart then
      dyePart = "<" .. _dyePartString[self._selected_CharacterTarget][self._selectedDyePart[index]] .. ">"
    elseif self._selectedDyePart[index] ~= self._selectedDyePart[index - 1] then
      dyePart = dyePart .. ", <" .. _dyePartString[self._selected_CharacterTarget][self._selectedDyePart[index]] .. ">"
    end
  end
  if self._isPearlPalette then
    local isAlreadyDye = ToClient_isAllreadyDyeing(equipSlotNo)
    if true == isAlreadyDye then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DYENEW_ALREADY_NORMALCOLOR"))
      return
    elseif "" == dyePart then
      doDye()
    else
      askDoDye()
    end
  else
    local isAlreadyPearlDye = ToClient_isExpirationDyeing(equipSlotNo)
    if true == isAlreadyPearlDye then
      alreadyPearlDye()
    elseif "" == dyePart then
      doDye()
    else
      askDoDye()
    end
  end
end
function FromClient_DyeingPalette_PadSnapChangePanel(fromPanel, toPanel)
end
