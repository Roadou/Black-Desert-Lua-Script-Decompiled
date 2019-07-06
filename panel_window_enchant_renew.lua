local _panel = Panel_Window_Enchant_Renew
local EnchantInfo = {
  _ui = {
    stc_title = UI.getChildControl(_panel, "Static_Title"),
    txt_title = nil,
    stc_mainBG = UI.getChildControl(_panel, "Static_MainBG"),
    txt_desc = nil,
    txt_descSub = nil,
    stc_innerBG = UI.getChildControl(_panel, "Static_InnerBG"),
    stc_backImage = nil,
    txt_bonus1 = nil,
    txt_bonus2 = nil,
    txt_bonus1Val = nil,
    txt_bonus2Val = nil,
    txt_totalBonusVal = nil,
    txt_forceEnchantDesc = nil,
    txt_normalEnchantDesc = nil,
    txt_keyGuideSelect = nil,
    stc_enchantTypeArea = nil,
    stc_enchantArtwork = UI.getChildControl(_panel, "Static_EnchantArtwork"),
    stc_targetSlotBG = nil,
    stc_subjectSlotBG = nil,
    stc_buttonGroupForPad = UI.getChildControl(_panel, "Static_ButtonGroup_ConsoleUI"),
    btn_normal = nil,
    btn_forced = nil,
    txt_keyGuideForced = nil,
    txt_result = nil,
    txt_normalKeyGuide = nil,
    txt_forcedKeyGuide = nil,
    txt_animSkipKeyGuide = nil,
    chk_skipAnimation = nil,
    stc_skipAnimation = nil,
    stc_darkNess = UI.getChildControl(_panel, "Static_DarknessArea"),
    stc_topMenu = UI.getChildControl(_panel, "Static_TapGroup"),
    stc_bottomBG = UI.getChildControl(_panel, "Static_Bottom"),
    txt_keyGuideForExit = nil,
    txt_keyGuideForCronStoneTooltip = nil
  },
  _isLastEnchant = nil,
  _enchantInfo = nil,
  _isAnimating = false,
  _isSkipAnimation = false,
  _forcedEnchant = false,
  _delayTime = 0,
  _effectTime_Enchant = 6,
  _tabXGab = 80,
  _currentUpperTab = 0,
  _resultShowTime = 0,
  _strForEnchantInfo = {
    _forcedChecked = "",
    _cronChecked = "",
    _notChecked = ""
  },
  _enum_EnchantType = {
    _safe = 0,
    _unsafe = 1,
    _broken = 2,
    _gradedown = 3,
    _downAndBroken = 4
  },
  _enum_EnchantResult = {
    _success = 0,
    _broken = 1,
    _gradedown = 2,
    _fail = 3,
    _failAndPrevent = 4,
    _error = 5
  },
  _panelOriSizeY = 760,
  _innerBgOriSizeY = 559,
  _mainBgOriSizeY = 733,
  _currentMainBgSize = 0,
  _descSubOriPosY = 0,
  _txt_normalEnchantSizeY = 130,
  _materialItemSlotNo = nil,
  _materialItemWhereType = nil,
  _isSetNewPerfectItemMaterial = false,
  _isWaitingServer = false,
  _isEnableCronstone = false
}
local UPPER_TAB_TYPE = {
  UNDEFINED = 0,
  ENCHANTINFO = 1,
  DARKNESS = 2
}
local _snappedOnThisPanel = false
local _isContentsEnable = ToClient_IsContentsGroupOpen("74")
local _isCronBonusOpen = ToClient_IsContentsGroupOpen("222")
local _isCronEnchantOpen = ToClient_IsContentsGroupOpen("234")
function FromClient_luaLoadComplete_EnchantInfo_Init()
  EnchantInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_EnchantInfo_Init")
function EnchantInfo:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_title, "StaticText_Title")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_mainBG, "StaticText_DescTitle")
  self._ui.txt_descSub = UI.getChildControl(self._ui.stc_mainBG, "StaticText_DescSub")
  self._ui.txt_descSub:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BOTTOM_DESC_CONSOLE"))
  self._ui.stc_backImage = UI.getChildControl(self._ui.stc_innerBG, "Static_BackImage")
  self._ui.txt_bonus1 = UI.getChildControl(self._ui.stc_backImage, "StaticText_ExtraChance1")
  self._ui.txt_bonus2 = UI.getChildControl(self._ui.stc_backImage, "StaticText_ExtraChance2")
  self._ui.txt_bonus1Val = UI.getChildControl(self._ui.stc_backImage, "StaticText_ExtraChance1Val")
  self._ui.txt_bonus2Val = UI.getChildControl(self._ui.stc_backImage, "StaticText_ExtraChance2Val")
  self._ui.line_vertical = UI.getChildControl(self._ui.stc_backImage, "Static_LineVertical")
  self._ui.txt_totalBonusVal = UI.getChildControl(self._ui.stc_backImage, "StaticText_TotalVal")
  self._ui.stc_enchantTypeArea = UI.getChildControl(self._ui.stc_innerBG, "Static_EnchantTypeArea")
  self._ui.rdo_itemsetFirst = UI.getChildControl(self._ui.stc_enchantTypeArea, "RadioButton_ItemStat")
  self._ui.rdo_enhancementFirst = UI.getChildControl(self._ui.stc_enchantTypeArea, "RadioButton_Enhancement")
  self._ui.stc_skipAnimation = UI.getChildControl(self._ui.stc_buttonGroupForPad, "Static_AniSkipBG")
  self._ui.chk_skipAnimation = UI.getChildControl(self._ui.stc_skipAnimation, "CheckButton_EnchantSkip")
  self._ui.rdo_enchantInfo = UI.getChildControl(self._ui.stc_topMenu, "RadioButton_1")
  self._ui.rdo_darkNess = UI.getChildControl(self._ui.stc_topMenu, "RadioButton_2")
  local tempSizeX = self._ui.txt_bonus2:GetPosX() + self._ui.txt_bonus2:GetTextSizeX()
  local tempSizeX2 = self._ui.txt_bonus2Val:GetPosX() + self._ui.txt_bonus2Val:GetSizeX() - 60
  if tempSizeX > tempSizeX2 then
    local tempPos = (tempSizeX - tempSizeX2) / 2
    self._ui.txt_bonus1:SetPosX(self._ui.txt_bonus1:GetPosX() - tempPos)
    self._ui.txt_bonus2:SetPosX(self._ui.txt_bonus2:GetPosX() - tempPos)
    self._ui.txt_bonus1Val:SetPosX(self._ui.txt_bonus1Val:GetPosX() + tempPos)
    self._ui.txt_bonus2Val:SetPosX(self._ui.txt_bonus2Val:GetPosX() + tempPos)
    self._ui.line_vertical:SetPosX(self._ui.line_vertical:GetPosX() + tempPos)
    self._ui.txt_totalBonusVal:SetPosX(self._ui.txt_totalBonusVal:GetPosX() + tempPos)
  end
  self._ui.rdo_tabButtons = {}
  local radioButtonCount = 2
  for ii = 1, radioButtonCount do
    self._ui.rdo_tabButtons[ii] = UI.getChildControl(self._ui.stc_topMenu, "RadioButton_" .. ii)
  end
  local rdoBtnsStartX = _panel:GetSizeX() / 2 - self._tabXGab * radioButtonCount / 2 + self._tabXGab / 2 - self._ui.rdo_tabButtons[1]:GetSizeX() / 2
  for ii = 1, radioButtonCount do
    self._ui.rdo_tabButtons[ii]:SetPosX(rdoBtnsStartX + self._tabXGab * (ii - 1))
  end
  self._ui.txt_keyGuideSelect = UI.getChildControl(self._ui.stc_innerBG, "StaticText_KeyGuideSelect")
  self._ui.txt_keyGuideSelect:SetShow(false)
  self._ui.btn_normal = UI.getChildControl(self._ui.stc_buttonGroupForPad, "Button_NormalEnchant")
  self._ui.txt_keyGuideNormal = UI.getChildControl(self._ui.btn_normal, "StaticText_KeyGuideNormal")
  self._ui.btn_forced = UI.getChildControl(self._ui.stc_buttonGroupForPad, "Button_ForceEnchant")
  self._ui.txt_keyGuideForced = UI.getChildControl(self._ui.btn_forced, "StaticText_KeyGuideForce")
  self._ui.txt_normalEnchantDesc = UI.getChildControl(self._ui.btn_normal, "StaticText_NormalEnchant")
  self._ui.txt_normalEnchantDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_normalEnchantDesc:SetText(self._ui.txt_normalEnchantDesc:GetText())
  self._ui.txt_forceEnchantDesc = UI.getChildControl(self._ui.btn_forced, "StaticText_ForceEnchant")
  self._ui.txt_forceEnchantDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_forceEnchantDesc:SetText(self._ui.txt_forceEnchantDesc:GetText())
  self._ui.stc_enchantArtwork:SetSpanSize(0, 345)
  self:repositionDesc()
  self._ui._txt_EatStackText = UI.getChildControl(self._ui.stc_darkNess, "StaticText_StackCount")
  self._ui._txt_EatStackRate = UI.getChildControl(self._ui.stc_darkNess, "StaticText_StackRate")
  self._ui._stc_darkNessSlotImage = UI.getChildControl(self._ui.stc_darkNess, "Static_DarkNessSlotImage")
  self._ui._stc_AddCountBG = UI.getChildControl(self._ui._stc_darkNessSlotImage, "Static_Arrow")
  self._ui._stc_AniSkipBG = UI.getChildControl(self._ui.stc_darkNess, "Static_AniSkipBG")
  self._ui._chk_SkipAniDarkness = UI.getChildControl(self._ui._stc_AniSkipBG, "CheckButton_DarknessAniSkip")
  self._ui._txt_CurrentCount = UI.getChildControl(self._ui._stc_AddCountBG, "StaticText_LeftCount")
  self._ui._txt_AddCount = UI.getChildControl(self._ui._stc_AddCountBG, "StaticText_RightCount")
  self._ui._txt_EatStackText:SetShow(false)
  self._ui._txt_EatStackRate:SetShow(false)
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_TITLE_BAR"))
  if false == _ContentsGroup_EatStackEnchant then
  else
  end
  local slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  }
  self._ui.stc_targetSlotBG = UI.getChildControl(self._ui.stc_enchantArtwork, "Static_SlotResult")
  self._ui.slot_targetItem = {}
  SlotItem.new(self._ui.slot_targetItem, "Slot_Target", 0, self._ui.stc_targetSlotBG, slotConfig)
  self._ui.slot_targetItem:createChild()
  self._ui.stc_targetDarkSlotBG = UI.getChildControl(self._ui._stc_darkNessSlotImage, "Static_SlotDark")
  self._ui.slot_targetDarkItem = {}
  SlotItem.new(self._ui.slot_targetDarkItem, "Slot_DarkTarget", 0, self._ui.stc_targetDarkSlotBG, slotConfig)
  self._ui.slot_targetDarkItem:createChild()
  self._ui.stc_subjectSlotBG = UI.getChildControl(self._ui.stc_enchantArtwork, "Static_SlotBase")
  self._ui.slot_subjectItem = {}
  SlotItem.new(self._ui.slot_subjectItem, "Slot_Subject", 1, self._ui.stc_subjectSlotBG, slotConfig)
  self._ui.slot_subjectItem:createChild()
  self._ui.txt_result = UI.getChildControl(self._ui.stc_enchantArtwork, "StaticText_ResultText")
  self._ui.txt_result:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_result:SetText(self._ui.txt_result:GetText())
  self._ui.txt_keyGuideForExit = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideCancel_ConsoleUI")
  self._ui.txt_keyGuideForCronStoneTooltip = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideCronstoneToolTip_ConsoleUI")
  self._ui.keyGuides = {
    self._ui.txt_keyGuideForCronStoneTooltip,
    self._ui.txt_keyGuideForExit
  }
  self._ui.stc_cronBG = UI.getChildControl(self._ui.stc_buttonGroupForPad, "Static_CronBG")
  self._ui.chk_cronProtect = UI.getChildControl(self._ui.stc_cronBG, "CheckButton_CronProtect")
  self._ui.txt_cronCount = UI.getChildControl(self._ui.stc_cronBG, "StaticText_CronCount")
  self._ui.txt_cronDesc = UI.getChildControl(self._ui.stc_cronBG, "StaticText_CronDesc")
  if false == _isContentsEnable then
    self._ui.stc_cronBG:SetIgnore(true)
    self._ui.stc_cronBG:SetMonoTone(true)
    self._ui.chk_cronProtect:SetIgnore(true)
    self._ui.chk_cronProtect:SetMonoTone(true)
    self._ui.txt_cronCount:SetIgnore(true)
    self._ui.txt_cronCount:SetMonoTone(true)
  else
    self._ui.stc_cronBG:SetIgnore(false)
    self._ui.stc_cronBG:SetMonoTone(false)
    self._ui.chk_cronProtect:SetIgnore(false)
    self._ui.chk_cronProtect:SetMonoTone(false)
    self._ui.txt_cronCount:SetIgnore(false)
    self._ui.txt_cronCount:SetMonoTone(false)
  end
  self:registEventHandler()
  self:registMessageHandler()
  self._isWaitingServer = false
end
function EnchantInfo:setTabTo(tabIndex)
  if true == self._isAnimating then
    return
  end
  self._currentUpperTab = tabIndex
  if tabIndex == UPPER_TAB_TYPE.ENCHANTINFO then
    PaGlobalFunc_EnchantInfo_TabSet(tabIndex)
    self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_TITLE_BAR"))
    Inventory_SetFunctor(PaGlobal_EnchantInfo_FilterForEnchantTarget, PaGlobal_EnchantInfo_RClickTarget, nil, nil)
  else
    PaGlobalFunc_EnchantInfo_TabSet(tabIndex)
    self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_EATENCHANT"))
    self:clearEnchantData()
    Inventory_SetFunctor(PaGlobal_Enchant_FileterForEatTarget, PaGlobal_Enchant_RClickForTargetItem, nil, nil)
  end
  self:setKeyGuideWithTab()
  if DragManager:isDragging() then
    DragManager:clearInfo()
  end
end
function EnchantInfo:setKeyGuideWithTab()
  self:alignKeyGuides()
end
function PaGlobalFunc_EnchantInfo_SetUpperTabTo(tabIndex)
  EnchantInfo:setTabTo(tabIndex)
end
function PaGlobalFunc_EnchantInfo_TabSet(tabType)
  if true == self._isAnimating then
    return
  end
  if nil == tabType then
    return
  end
  local self = EnchantInfo
  self._ui.rdo_enchantInfo:SetCheck(1 == tabType)
  self._ui.rdo_darkNess:SetCheck(2 == tabType)
  if 1 == tabType then
    self._ui.stc_enchantArtwork:SetShow(true)
    self._ui.stc_darkNess:SetShow(false)
    self._ui.stc_buttonGroupForPad:SetShow(true)
    self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BOTTOM_DESC_CONSOLE"))
    self._ui._txt_AddCount:SetText("+0")
  else
    self._ui.stc_darkNess:SetShow(true)
    self._ui.stc_enchantArtwork:SetShow(false)
    self._ui.stc_buttonGroupForPad:SetShow(false)
    self._ui.stc_enchantTypeArea:SetShow(false)
    if true == _ContentsGroup_EatEnchant and false == _ContentsGroup_EatStackEnchant then
      self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION"))
    elseif true == _ContentsGroup_EatEnchant and true == _ContentsGroup_EatStackEnchant then
      self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION_FORSTACK"))
    else
      self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION"))
    end
  end
  self._ui.stc_enchantArtwork:EraseAllEffect()
  self:repositionDesc()
end
function EnchantInfo:registEventHandler()
  self._ui.slot_targetItem.icon:addInputEvent("Mouse_RUp", "InputRUp_EnchantInfo_TargetSlot()")
  self._ui.slot_targetDarkItem.icon:addInputEvent("Mouse_RUp", "InputRUp_EnchantInfo_TargetSlot()")
  self._ui.slot_subjectItem.icon:addInputEvent("Mouse_RUp", "InputRUp_EnchantInfo_TargetSlot()")
  self._ui.rdo_itemsetFirst:addInputEvent("Mouse_LUp", "EnchantInfo_didsetEnchantTarget(nil, true)")
  self._ui.rdo_enhancementFirst:addInputEvent("Mouse_LUp", "EnchantInfo_didsetEnchantTarget(nil, true)")
  self._ui.chk_skipAnimation:addInputEvent("Mouse_LUp", "Input_EnchantInfo_RTUp()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_EnchantInfo_TryEnchant(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "Input_EnchantInfo_TryEnchant(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LT, "Input_EnchantInfo_LTDown()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_LT, "Input_EnchantInfo_LTUp()")
  for ii = 1, #self._ui.rdo_tabButtons do
    self._ui.rdo_tabButtons[ii]:addInputEvent("Mouse_LUp", "PaGlobalFunc_EnchantInfo_SetUpperTabTo(" .. ii .. ")")
  end
end
function EnchantInfo:registMessageHandler()
  registerEvent("FromClient_PadSnapChangePanel", "FromClient_EnchantInfo_PadSnapChangePanel")
  registerEvent("EventEnchantResultShow", "FromClient_EnchantInfo_ResultShow")
  registerEvent("FromClient_UpdateEnchantFailCount", "FromClient_EnchantInfo_UpdateBonus")
  registerEvent("FromClient_ConvertEnchantFailItemToCountAck", "FromClient_EnchantInfo_UpdateBonus")
  registerEvent("FromClient_FailCountUpdate", "FromClient_FailCountUpdate")
  _panel:RegisterUpdateFunc("FromClient_EnchantInfo_PerFrame")
end
function PaGlobalFunc_EnchantInfo_Open()
  EnchantInfo:open()
end
function PaGlobalFunc_EnchantInfo_GetShow()
  return _panel:GetShow()
end
function EnchantInfo:open()
  _panel:SetShow(true)
  self._ui.txt_keyGuideForExit:SetShow(true)
  self._ui.txt_keyGuideForExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_EXIT"))
  self._ui.txt_keyGuideForCronStoneTooltip:SetShow(false)
  self:alignKeyGuides()
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  self:clearItemSlot(self._ui.slot_subjectItem)
  self:clearItemSlot(self._ui.slot_targetItem)
  self:clearItemSlot(self._ui.slot_targetDarkItem)
  self._ui.txt_keyGuideNormal:SetMonoTone(true)
  self._ui.txt_keyGuideForced:SetMonoTone(true)
  self._ui.txt_result:SetShow(false)
  self._isAnimating = false
  self:setEnchantFailCount()
  self._currentUpperTab = 1
  self._isWaitingServer = false
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_TITLE_BAR"))
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_EnchantInfo_TryEnchant(false)")
  self:setEnable_CheckboxUseCron(false)
  self:showDifficultEnchantButton(false)
  PaGlobalFunc_EnchantInfo_TabSet(1)
  PaGlobalFunc_InventoryInfo_Open()
  ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
  Inventory_SetFunctor(PaGlobal_EnchantInfo_FilterForEnchantTarget, PaGlobal_EnchantInfo_RClickTarget, nil, nil)
end
function PaGlobalFunc_EnchantInfo_Close()
  EnchantInfo:close()
end
function EnchantInfo:close()
  self:clearEnchantData()
  _panel:SetShow(false)
  if true == PaGlobalFunc_InventoryInfo_GetShow() then
    InventoryWindow_Close()
  end
  Inventory_SetFunctor(nil, nil, nil, nil)
  ToClient_BlackspiritEnchantClose()
end
function EnchantInfo:alignKeyGuides()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._ui.keyGuides, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobal_Enchant_FileterForEatTarget(slotNo, notUse_itemWrappers, whereType)
  local returnValue = true
  if true == ToClient_Inventory_AvailFeedItem(whereType, slotNo) then
    returnValue = false
  else
    returnValue = true
  end
  return returnValue
end
function PaGlobal_Enchant_RClickForTargetItem(slotNo, itemWrapper, count, inventoryType)
  local self = EnchantInfo
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  self:clearEnchantData()
  if true == self._ui.rdo_darkNess:IsCheck() then
    self:setEatTarget(slotNo, itemWrapper, inventoryType, nil, true)
    return
  end
  self:setEnchantTarget(slotNo, itemWrapper, inventoryType, nil, true)
  Inventory_SetFunctor(PaGlobal_Enchant_InvenFilerSubItem, PaGlobal_Enchant_RClickMaterialItem, nil, nil)
end
function PaGlobal_Enchant_InvenFilerSubItem(slotNo, notUse_itemWrappers, whereType)
  local self = EnchantInfo
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper or true == self._ui.rdo_darkNess:IsCheck() then
    return true
  end
  if itemWrapper:checkToValksItem() then
    return false
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  local returnValue = true
  if slotNo == getEnchantInformation():ToClient_getNeedNewPerfectItemSlotNo() then
    returnValue = false
  elseif slotNo ~= getEnchantInformation():ToClient_getNeedItemSlotNo() then
    returnValue = true
  else
    returnValue = false
    if self._ui.slot_targetItem == slotNo and CppEnums.ItemWhereType.eInventory ~= whereType then
      returnValue = true
    end
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    returnValue = true
  end
  return returnValue
end
function PaGlobal_Enchant_RClickMaterialItem(slotNo, itemWrapper, Count, inventoryType)
  local self = EnchantInfo
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  self:clearItemSlot(self._ui._slot_EnchantMaterial)
  self._materialItemSlotNo = slotNo
  self._materialItemWhereType = inventoryType
  if slotNo == self._enchantInfo:ToClient_getNeedNewPerfectItemSlotNo() and inventoryType == self._enchantInfo:ToClient_getNeedNewPerfectItemWhereType() then
    self._isSetNewPerfectItemMaterial = true
  else
    self._isSetNewPerfectItemMaterial = false
  end
  self:didsetEnchantTarget(false)
end
function EnchantInfo:setEatTarget(slotNo, itemWrapper, inventoryType, resultType, isMonotone)
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  local failCount = self._enchantInfo:ToClient_getFailCount()
  if true ~= ToClient_Inventory_AvailFeedItem(inventoryType, slotNo) then
    return false
  end
  self:setItemToSlot(self._ui.slot_targetDarkItem, slotNo, itemWrapper, inventoryType)
  self._grantItemSlotNo = slotNo
  self._grantItemWhereType = inventoryType
  if nil ~= self._ui._txt_CurrentCount then
    local failCount = self._enchantInfo:ToClient_getFailCount()
    local getEnchantValue = 0
    if true == _ContentsGroup_EatStackEnchant then
      local rate = Int64toInt32(ToClient_getEnchantFailCountRateResult(inventoryType, slotNo))
      getEnchantValue = ToClient_getEnchantFailCountStackResult(inventoryType, slotNo)
      self._ui._txt_EatStackRate:SetShow(false)
      self._ui._stc_AddCountBG:SetShow(true)
      self._ui._txt_CurrentCount:SetText("+" .. tostring(failCount))
      if rate > 0 then
        self._ui._txt_AddCount:SetText("+" .. tostring(failCount + 1))
        self._ui._txt_EatStackRate:SetText("<PAColor0xFF0FBFFF>" .. string.format("%.1f", rate / CppDefine.e1Percent) .. "%")
      else
        self._ui._txt_AddCount:SetText("+" .. tostring(getEnchantValue))
        self._ui._txt_EatStackRate:SetText("<PAColor0xFF0FBFFF>100%<PAOldColor>")
      end
      self._eatEnchantRate = rate
    else
      getEnchantValue = ToClient_Inventory_GetItemEnchantValue(inventoryType, slotNo)
      if 0 == failCount then
      else
      end
      self._ui._txt_CurrentCount:SetText("0")
      self._ui._txt_AddCount:SetText("<PAColor0xffffff00>+" .. getEnchantValue)
    end
    self._eatEnchantValue = getEnchantValue
  end
  ToClient_padSnapSetTargetPanel(_panel)
  PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
  return true
end
function PaGlobal_EnchantInfo_FilterForEnchantTarget(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if itemWrapper:checkToValksItem() then
    return false
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  return false == itemWrapper:checkToEnchantItem(false)
end
function PaGlobalFunc_EnchantInfo_FilterForSubject(slotNo, notUse_itemWrappers, whereType)
  local self = EnchantInfo
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if itemWrapper:checkToValksItem() then
    return false
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  local returnValue = true
  if slotNo == getEnchantInformation():ToClient_getNeedNewPerfectItemSlotNo() then
    returnValue = false
  elseif slotNo ~= getEnchantInformation():ToClient_getNeedItemSlotNo() then
    returnValue = true
  else
    returnValue = false
    if self._ui.slot_targetItem.slotNo == slotNo and CppEnums.ItemWhereType.eInventory ~= whereType then
      returnValue = true
    end
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    returnValue = true
  end
  return returnValue
end
function PaGlobal_EnchantInfo_RClickTarget(slotNo, itemWrapper, count, inventoryType)
  local self = EnchantInfo
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    self:setEnchantFailCount()
    return
  end
  self:setEnchantTarget(slotNo, itemWrapper, inventoryType, nil, true)
  Inventory_SetFunctor(PaGlobalFunc_EnchantInfo_FilterForSubject, PaGlobalFunc_EnchantInfo_RClickSubject, nil, nil)
  _AudioPostEvent_SystemUiForXBOX(0, 16)
end
function EnchantInfo:setEnchantTarget(slotNo, itemWrapper, inventoryType, resultType, isMonotone)
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  if 0 ~= self._enchantInfo:ToClient_setEnchantSlot(inventoryType, slotNo) then
    return false
  end
  self:setItemToSlot(self._ui.slot_targetItem, slotNo, itemWrapper, inventoryType)
  local isMaterialInit = false
  if nil ~= resultType and 0 == resultType then
    local resultItemWrapper = getInventoryItemByType(inventoryType, slotNo)
    if nil ~= resultItemWrapper then
      local itemSSW = resultItemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if 15 == enchantLevel then
        self._grantItemSlotNo = nil
        self._grantItemWhereType = nil
        self._materialItemSlotNo = nil
        self._materialItemWhereType = nil
        self:setEnchantMaterial(true)
        ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
        PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
        return false
      end
    end
  end
  local equipType = itemWrapper:getStaticStatus():getItemClassify()
  local monotone = isMonotone
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == equipType then
    monotone = true
  end
  if not monotone then
    ToClient_padSnapSetTargetPanel(_panel)
    PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
  end
  self._grantItemSlotNo = slotNo
  self._grantItemWhereType = inventoryType
  self:evaluateEnchantTarget(monotone)
  self._ui.txt_keyGuideForExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_DISCARD"))
  if false == self._ui.txt_keyGuideForExit:GetShow() then
    self._ui.txt_keyGuideForExit:SetShow(true)
    self._ui.txt_keyGuideForCronStoneTooltip:SetShow(true)
    self:alignKeyGuides()
    self._ui.txt_keyGuideForExit:SetShow(false)
    self._ui.txt_keyGuideForCronStoneTooltip:SetShow(false)
  else
    self:alignKeyGuides()
  end
  return true
end
function EnchantInfo:setEnable_CheckboxUseCron(enable)
  self._ui.chk_cronProtect:SetCheck(false)
  self._ui.chk_cronProtect:SetShow(true)
  self._ui.chk_cronProtect:SetIgnore(not enable)
  self._ui.chk_cronProtect:SetMonoTone(not enable)
  self._ui.chk_cronProtect:SetIgnore(not enable)
  self._ui.chk_cronProtect:SetMonoTone(not enable)
  self._ui.txt_cronCount:SetIgnore(not enable)
  self._ui.txt_cronCount:SetMonoTone(not enable)
  self._ui.txt_cronDesc:SetIgnore(true)
  self._ui.txt_cronDesc:SetMonoTone(not enable)
  self._ui.chk_cronProtect:SetEnable(enable)
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SAFTYENCHANTTITLE")
  if enable then
    self._isEnableCronstone = true
    self._ui.txt_cronDesc:SetText(name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_ENABLE"))
  else
    self._isEnableCronstone = false
    self._ui.txt_cronDesc:SetText(name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_DISABLE"))
  end
end
function EnchantInfo:setItemToSlot(uiSlot, slotNo, itemWrapper, inventoryType)
  uiSlot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  uiSlot.empty = false
  uiSlot.slotNo = slotNo
  uiSlot.inventoryType = inventoryType
  uiSlot.icon:SetMonoTone(false)
  uiSlot:setItem(getInventoryItemByType(inventoryType, slotNo))
  if self._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
    self:showDifficultEnchantButton(true)
  else
    self:showDifficultEnchantButton(false)
  end
end
function EnchantInfo:evaluateEnchantTarget(isMonotone)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil == itemWrapper then
    return
  end
  local enchantItemClassify = itemWrapper:getStaticStatus():getItemClassify()
  local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
  local enchantType = self._enchantInfo:ToClient_getEnchantType()
  local isStackLessBlackStone = itemWrapper:getStaticStatus():isNeedStackLessBlackStonForEnchant()
  if (enchantLevel > 16 or 4 == enchantItemClassify) and false == isStackLessBlackStone and toInt64(0, 0) < self._enchantInfo:ToClient_getNeedCountForProtect_s64() then
    self:setEnable_CheckboxUseCron(true)
    self:setText_NumOfCron(self._enchantInfo:ToClient_getCountProtecMaterial_s64(), self._enchantInfo:ToClient_getNeedCountForProtect_s64())
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
  else
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
  end
  if self._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
    self:showDifficultEnchantButton(true)
  else
    self:showDifficultEnchantButton(false)
  end
  self:setText_EnchantInfo()
  self:setEnchantMaterial(isMonotone)
end
function EnchantInfo:showDifficultEnchantButton(isShow)
  self._ui.stc_enchantArtwork:SetSpanSize(0, 345)
  self._ui.stc_enchantTypeArea:SetShow(isShow)
  self._ui.rdo_itemsetFirst:SetShow(isShow)
  self._ui.rdo_enhancementFirst:SetShow(isShow)
  if isShow == false then
    self._ui.rdo_itemsetFirst:SetCheck(true)
    self._ui.rdo_enhancementFirst:SetCheck(false)
  end
end
function EnchantInfo_didsetEnchantTarget(isMonotone, isRadioClick)
  local self = EnchantInfo
  local enchantType = self._enchantInfo:ToClient_getEnchantType()
  local needCountForPerfectEnchant_s64 = self._enchantInfo:ToClient_getNeedCountForPerfectEnchant_s64()
  self._strForEnchantInfo._notChecked = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil == itemWrapper then
    return
  end
  local enchantItemClassify = itemWrapper:getStaticStatus():getItemClassify()
  local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
  local isStackLessBlackStone = itemWrapper:getStaticStatus():isNeedStackLessBlackStonForEnchant()
  if (enchantLevel > 16 or 4 == enchantItemClassify) and false == isStackLessBlackStone and toInt64(0, 0) < self._enchantInfo:ToClient_getNeedCountForProtect_s64() then
    self:setEnable_CheckboxUseCron(true)
    self:setText_NumOfCron(self._enchantInfo:ToClient_getCountProtecMaterial_s64(), self._enchantInfo:ToClient_getNeedCountForProtect_s64())
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
    self._strForEnchantInfo._cronChecked = enduranceDesc .. self:getStr_EnchantProtectInfo(enchantType)
  else
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
  end
  if needCountForPerfectEnchant_s64 > toInt64(0, 0) then
    self:setEnable_CheckboxForcedEnchant(true)
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
    self._strForEnchantInfo._forcedChecked = enduranceDesc .. self:getStr_PerfectEnchantInfo(needCountForPerfectEnchant_s64, self._enchantInfo:ToClient_getDecMaxEnduraPerfect())
  else
    self:setEnable_CheckboxForcedEnchant(false)
  end
  if self._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
    self:showDifficultEnchantButton(true)
  else
    self:showDifficultEnchantButton(false)
  end
  if true == self._isSetNewPerfectItemMaterial then
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
    self:setEnable_CheckboxForcedEnchant(false)
    self:showDifficultEnchantButton(false)
  end
  self:setText_EnchantInfo()
  if nil == isRadioClick then
    self:setEnchantMaterial(isMonotone)
  end
end
function EnchantInfo:showNoticeEnchantApply(enchantType)
  if enchantType == self._enum_EnchantType._safe then
    local isWeapon = true
    local isCollectTool = true
    local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      isWeapon = itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon()
      isCollectTool = itemSSW:get():isCollectTool()
    end
    if isWeapon or isCollectTool then
      self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_WEAPONE"))
    else
      self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_ARMOR"))
    end
  elseif enchantType == self._enum_EnchantType._unsafe then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_FAIL"))
  elseif enchantType == self._enum_EnchantType._broken then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED"))
  elseif enchantType == self._enum_EnchantType._gradedown then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_COUNTDOWN"))
  elseif enchantType == self._enum_EnchantType._downAndBroken then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED_AND_COUNTDOWN"))
  end
  self._ui._statictext_noticeApplyButton:SetShow(true)
  self._isShowNoticeApplyButton = true
  self._ui._statictext_noticeApplyButton:SetPosY((self._ui._statictext_noticeApplyButton:GetSizeY() + 5) * -1)
end
function EnchantInfo:setEnable_CheckboxForcedEnchant(isEnable)
  self._ui.btn_forced:SetIgnore(not isEnable)
  self._ui.txt_keyGuideForced:SetIgnore(not isEnable)
  self._ui.btn_forced:SetMonoTone(not isEnable)
  self._ui.txt_keyGuideForced:SetMonoTone(not isEnable)
end
function EnchantInfo:isDifficultEnchant()
  return self._ui.rdo_enhancementFirst:IsCheck()
end
function EnchantInfo:setText_EnchantInfo()
  if true == self._isSetNewPerfectItemMaterial then
    local str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT_PENALTY", "maxEndurance", tostring(self._enchantInfo:ToClient_getDecMaxEnduraNewPerfect()), "currentEndurance", tostring(self._enchantInfo:ToClient_getCurMaxEndura()))
    self._ui.txt_normalEnchantDesc:SetText(str)
    self._ui.txt_forceEnchantDesc:SetShow(true)
    self._ui.txt_forceEnchantDesc:SetText("")
  else
    local enchantType = self._enchantInfo:ToClient_getEnchantType()
    local rate = ToClient_getEnchantSuccessRate(false, self:isDifficultEnchant())
    local enchantPercentString = ""
    local rateString = ""
    if -1 ~= rate then
      enchantPercentString = "<PAColor0xFF0FBFFF>" .. string.format("%.2f", rate / CppDefine.e100Percent * 100) .. "%<PAOldColor>"
      rateString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SUCCESSPERCENT_REAL", "percent", enchantPercentString)
    end
    self._strForEnchantInfo._notChecked = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType)
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
    self._ui.txt_normalEnchantDesc:SetText(rateString .. "\n" .. self._strForEnchantInfo._notChecked)
    if 0 == enchantType then
      self._ui.txt_normalEnchantDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_ENCHANT_SAFEENCHANTTEXT"))
    end
    local needCountForPerfectEnchant_s64 = self._enchantInfo:ToClient_getNeedCountForPerfectEnchant_s64()
    if needCountForPerfectEnchant_s64 > toInt64(0, 0) then
      self._strForEnchantInfo._forcedChecked = self:getStr_PerfectEnchantInfo(needCountForPerfectEnchant_s64, self._enchantInfo:ToClient_getDecMaxEnduraPerfect())
      self._ui.txt_forceEnchantDesc:SetText(self._strForEnchantInfo._forcedChecked)
      self._ui.txt_forceEnchantDesc:SetShow(true)
    else
      self._ui.txt_forceEnchantDesc:SetShow(true)
      self._ui.txt_forceEnchantDesc:SetText("")
    end
  end
  self:repositionDesc()
end
function PaGlobalFunc_EnchantInfo_OnPadB()
  local self = EnchantInfo
  if self._isAnimating then
    self:cancelEnchant()
    return
  end
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_EnchantInfo_TryEnchant(false)")
  if nil ~= self._ui.slot_targetItem.slotNo or nil ~= self._ui.slot_subjectItem.slotNo then
    self:clearEnchantData()
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
    Inventory_SetFunctor(PaGlobal_EnchantInfo_FilterForEnchantTarget, PaGlobal_EnchantInfo_RClickTarget, nil, nil)
    return false
  elseif nil ~= self._ui.slot_targetDarkItem.slotNo then
    self:clearEnchantData()
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
    Inventory_SetFunctor(PaGlobal_Enchant_FileterForEatTarget, PaGlobal_Enchant_RClickForTargetItem, nil, nil)
    return false
  else
    self:close()
    return true
  end
end
function EnchantInfo:cancelEnchant()
  self._isAnimating = false
  self:removeEnchantEffect()
end
function EnchantInfo:removeEnchantEffect()
  if true == self._forcedEnchant then
    self._ui.txt_keyGuideForced:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_WIN_ENCHANT_GOGOGO"))
  else
    self._ui.txt_keyGuideNormal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RADIOBTNTITLE_1"))
  end
  self._ui._stc_darkNessSlotImage:EraseAllEffect()
  self._ui.chk_skipAnimation:SetIgnore(false)
  self._ui.stc_enchantArtwork:EraseAllEffect()
  self._ui.slot_targetItem.icon:EraseAllEffect()
  self._ui.slot_subjectItem.icon:EraseAllEffect()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_EnchantInfo_TryEnchant(false)")
  self._ui.chk_cronProtect:SetIgnore(not self._isEnableCronstone)
  self._ui.chk_cronProtect:SetMonoTone(not self._isEnableCronstone)
  ToClient_BlackspiritEnchantCancel()
end
function PaGlobalFunc_EnchantInfo_RClickSubject(slotNo, itemWrapper, count, inventoryType)
  local self = EnchantInfo
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  self:clearItemSlot(self._ui.slot_subjectItem)
  self._materialItemSlotNo = slotNo
  self._materialItemWhereType = inventoryType
  _AudioPostEvent_SystemUiForXBOX(0, 16)
  if slotNo == self._enchantInfo:ToClient_getNeedNewPerfectItemSlotNo() and inventoryType == self._enchantInfo:ToClient_getNeedNewPerfectItemWhereType() then
    self._isSetNewPerfectItemMaterial = true
  else
    self._isSetNewPerfectItemMaterial = false
  end
  self:setEnchantMaterial(false)
  ToClient_padSnapSetTargetPanel(_panel)
end
function EnchantInfo:setEnchantMaterial(isMonotone)
  if true == isMonotone or 0 ~= self._enchantInfo:ToClient_setEnchantSlot(self._materialItemWhereType, self._materialItemSlotNo) then
    self:setItemToSlotMonoTone(self._ui.slot_subjectItem, self._enchantInfo:ToClient_getNeedItemStaticInformation())
    self:enableApplyButton(false)
    self._enchantInfo:materialClearData()
  else
    self:setText_EnchantInfo()
    local itemWrapper = getInventoryItemByType(self._materialItemWhereType, self._materialItemSlotNo)
    self:setItemToSlot(self._ui.slot_subjectItem, self._materialItemSlotNo, itemWrapper, self._materialItemWhereType)
    self:enableApplyButton(true)
    if self._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
      self:showDifficultEnchantButton(true)
    else
      self:showDifficultEnchantButton(false)
    end
  end
end
function EnchantInfo:enableApplyButton(isTrue)
  self._ui.btn_normal:SetIgnore(not isTrue)
  self._ui.btn_normal:SetMonoTone(not isTrue)
  self._normalEnchantEnabled = isTrue
  self._forcedEnchantEnabled = false
  if true == isTrue then
    local needCountForPerfectEnchant_s64 = self._enchantInfo:ToClient_getNeedCountForPerfectEnchant_s64()
    local slotNo = self._enchantInfo:ToClient_getNeedItemSlotNo()
    local inventoryType = self._enchantInfo:ToClient_getNeedItemWhereType()
    local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
    local itemCount = itemWrapper:get():getCount_s64()
    if needCountForPerfectEnchant_s64 > toInt64(0, 0) and true == self:forcedEnchantIsReady() and nil ~= itemWrapper and needCountForPerfectEnchant_s64 <= itemCount then
      self._ui.btn_forced:SetMonoTone(false)
      self._ui.btn_forced:SetIgnore(false)
      self._ui.txt_keyGuideForced:SetMonoTone(false)
      self._forcedEnchantEnabled = true
    else
      self._ui.btn_forced:SetMonoTone(true)
      self._ui.btn_forced:SetIgnore(true)
      self._ui.txt_keyGuideForced:SetMonoTone(true)
    end
    self._ui.txt_keyGuideNormal:SetMonoTone(false)
  else
    self._ui.btn_forced:SetMonoTone(true)
    self._ui.btn_forced:SetIgnore(true)
    self._ui.txt_keyGuideNormal:SetMonoTone(true)
    self._ui.txt_keyGuideForced:SetMonoTone(true)
  end
end
function EnchantInfo:updateApplyButton()
  local self = EnchantInfo
  self._ui.txt_keyGuideNormal:SetMonoTone(not self._normalEnchantEnabled or not _snappedOnThisPanel)
  self._ui.txt_keyGuideForced:SetMonoTone(not self._forcedEnchantEnabled or not _snappedOnThisPanel)
  if true == self._ui.chk_cronProtect:GetShow() and false == self._ui.chk_cronProtect:IsIgnore() and _snappedOnThisPanel and true == self._ui.rdo_enchantInfo:IsCheck() then
    self._ui.txt_keyGuideForCronStoneTooltip:SetShow(true)
  else
    self._ui.txt_keyGuideForCronStoneTooltip:SetShow(false)
  end
end
function InputRUp_EnchantInfo_TargetSlot()
  EnchantInfo:clearEnchantData()
  ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
  Inventory_SetFunctor(PaGlobal_EnchantInfo_FilterForEnchantTarget, PaGlobal_EnchantInfo_RClickTarget, nil, nil)
  if EnchantInfo._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
    EnchantInfo:showDifficultEnchantButton(true)
  else
    EnchantInfo:showDifficultEnchantButton(false)
  end
end
function Input_EnchantInfo_IgnoreGroupMove()
  ToClient_padSnapIgnoreGroupMove()
end
function EnchantInfo:ApplyButton_EatEvent()
  if self._isAnimating == true then
    self:cancelEat()
  else
    local failCount = self._enchantInfo:ToClient_getFailCount()
    local getEnchantValue = self._eatEnchantValue
    local rate = self._eatEnchantRate
    local msgTitle = ""
    local msgStr = ""
    local messageBoxData
    local function EatEnchant_ForMessageBox()
      if not self._ui._chk_SkipAniDarkness:IsCheck() then
        self:EatEnchantItemAnimation()
      else
        self:EatEnchantItem()
      end
    end
    if failCount == getEnchantValue then
      msgTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EATENCHANT_BUTTON_GETSTACK")
      msgStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EATENCHANT_STACK_MSGBOX", "percent", string.format("%.1f", rate / CppDefine.e1Percent))
      self._isRateStack = true
    else
      msgTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RADIOBTNTITLE_3_EATENCHANT")
      msgStr = PAGetString(Defines.StringSheet_GAME, "LUA_EATENCHANT_MSGBOXTEXT")
      self._isRateStack = false
    end
    messageBoxData = {
      title = msgTitle,
      content = msgStr,
      functionYes = EatEnchant_ForMessageBox,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function EnchantInfo:EatEnchantItemAnimation()
  self:startEatEnchantAnimation()
end
function EnchantInfo:EatEnchantItem()
  ToClient_Inventory_feedItem(self._grantItemWhereType, self._grantItemSlotNo)
  self._ui._txt_AddCount:SetText("+0")
  self._isSlotChangeAnimation = true
  _AudioPostEvent_SystemUiForXBOX(3, 25)
end
function EnchantInfo:cancelEat()
  self._isAnimating = false
  self:removeEnchantEffect()
  ToClient_BlackspiritEnchantCancel()
end
function EnchantInfo:EatEnchantResult()
  if true == self._isRateStack then
    return
  end
  self:clearEnchantData()
  self:setEnchantFailCount()
  ToClient_BlackspiritEnchantSuccess()
  if true == _ContentsGroup_EatStackEnchant then
    local failCountUpRate = Int64toInt32(self._enchantInfo:ToClient_getFailCountUpRate())
    local rateString = " " .. string.format("%.1f", failCountUpRate / CppDefine.e1Percent)
    self._ui._txt_EatStackRate:SetText("")
  end
  audioPostEvent_SystemUi(5, 1)
  self._resultTimeCheck = true
end
function FromClient_FailCountUpdate()
  local self = EnchantInfo
  self:EatEnchantResult()
end
function Input_EnchantInfo_TryEnchant(isForcedEnchant)
  local self = EnchantInfo
  if true == self._isAnimating then
    return
  end
  self._delayTime = 0
  if true == self._ui.rdo_enchantInfo:IsCheck() then
    self:tryEnchant(isForcedEnchant)
  else
    self:ApplyButton_EatEvent()
  end
end
function Input_EnchantInfo_RTUp()
  local self = EnchantInfo
  if true == self._ui.chk_skipAnimation:IsCheck() then
    self._isSkipAnimation = true
  else
    self._isSkipAnimation = false
  end
  self:alignKeyGuides()
end
function Input_EnchantInfo_LTUp()
  local self = EnchantInfo
  if false == self._ui.chk_cronProtect:GetShow() or true == self._isAnimating then
    return
  end
  if true == self._ui.stc_cronBG:GetShow() then
    PaGlobalFunc_FloatingTooltip_Close()
  end
end
function Input_EnchantInfo_LTDown()
  local self = EnchantInfo
  local enchantType = self._enchantInfo:ToClient_getEnchantType()
  if false == self._ui.rdo_enchantInfo:IsCheck() then
    return
  end
  if false == self._ui.chk_cronProtect:GetShow() or true == self._ui.chk_cronProtect:IsIgnore() or true == self._isAnimating then
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.CashBuffData, {
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SAFTYENCHANTTITLE"),
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SAFTYENCHANTDESC")
  }, Defines.TooltipTargetType.CashBuff, self._ui.stc_cronBG)
end
function EnchantInfo:forcedEnchantIsReady()
  if true == self._isSetNewPerfectItemMaterial then
    return false
  end
  local val = self._enchantInfo:ToClient_getNeedCountForPerfectEnchant_s64()
  local targetItemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  return val > toInt64(0, 0) and targetItemWrapper:get():getMaxEndurance() >= self._enchantInfo:ToClient_getDecMaxEnduraPerfect()
end
function EnchantInfo:setText_NumOfCron(cnt, needCnt)
  if cnt < needCnt then
    self._ui.txt_cronCount:SetText("<PAColor0xffff7383>" .. tostring(cnt) .. "/" .. tostring(needCnt) .. "<PAOldColor>")
  else
    self._ui.txt_cronCount:SetText("<PAColor0xFF0FBFFF>" .. tostring(cnt) .. "/" .. tostring(needCnt) .. "<PAOldColor>")
  end
end
function EnchantInfo:tryEnchant(isForcedEnchant)
  if nil == self._grantItemWhereType or nil == self._grantItemSlotNo then
    return
  end
  local targetItemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil == targetItemWrapper then
    return
  end
  if nil == self._ui.slot_subjectItem or 0 == self._ui.slot_subjectItem.slotNo then
    return
  end
  if true == isForcedEnchant and not self:forcedEnchantIsReady() then
    return
  end
  self._forcedEnchant = isForcedEnchant
  if self._isAnimating == true then
    return
  end
  if true == self._ui.chk_cronProtect:IsCheck() then
    if self._enchantInfo:ToClient_setPreventDownGradeItem() ~= 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_NOT_ENOUGH_CRONESTONE"))
      return
    end
    if true == self._forcedEnchant then
      self._ui.chk_cronProtect:SetCheck(false)
      self._enchantInfo:ToClient_clearPreventDownGradeItem()
    end
  else
    self._enchantInfo:ToClient_clearPreventDownGradeItem()
  end
  local enchantAlert = false
  local failCount = self._enchantInfo:ToClient_getFailCount()
  local valksCount = self._enchantInfo:ToClient_getValksCount()
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil == itemWrapper then
    return
  end
  local itemSSW = itemWrapper:getStaticStatus()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  if 0 == failCount + valksCount then
    if nil ~= self._grantItemWhereType and nil ~= self._grantItemSlotNo then
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        if enchantLevel > 0 then
          enchantAlert = true
        end
      elseif enchantLevel > 15 then
        enchantAlert = true
      end
    end
    if true == self._forcedEnchant then
      enchantAlert = false
    end
    if enchantAlert then
      local function goEnchant()
        if true == self._ui.chk_skipAnimation:IsCheck() then
          self:startEnchant()
        elseif false == self._ui.chk_skipAnimation:IsCheck() then
          self:startEnchantAnimation()
        end
      end
      local _title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE")
      local _content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGEDESC")
      local messageBoxData = {
        title = _title,
        content = _content,
        functionYes = goEnchant,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    elseif true == self._ui.chk_skipAnimation:IsCheck() then
      self:startEnchant()
    elseif false == self._ui.chk_skipAnimation:IsCheck() then
      self:startEnchantAnimation()
    end
  elseif enchantLevel > 17 then
    local function goEnchant()
      if true == self._ui.chk_skipAnimation:IsCheck() then
        self:startEnchant()
      elseif false == self._ui.chk_skipAnimation:IsCheck() then
        self:startEnchantAnimation()
      end
    end
    if 0 < itemWrapper:getCronEnchantFailCount() then
      local _title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE")
      local _content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CRON_ENERGY_WARNING_DESC_CAPHRAS")
      local messageBoxData = {
        title = _title,
        content = _content,
        functionApply = goEnchant,
        functionCancel = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData, nil, false, false)
    else
      local _title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE")
      local _content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGEDESC")
      local messageBoxData = {
        title = _title,
        content = _content,
        functionYes = goEnchant,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
    end
  elseif true == self._ui.chk_skipAnimation:IsCheck() then
    self:startEnchant()
  elseif false == self._ui.chk_skipAnimation:IsCheck() then
    self:startEnchantAnimation()
  end
  self._resultShowTime = 0
end
function EnchantInfo:startEnchant()
  if true == self._isWaitingServer then
    return
  end
  self._isWaitingServer = true
  self._enchantInfo:ToClient_doEnchant(self._forcedEnchant, self._ui.rdo_enhancementFirst:IsCheck())
  self._ui.txt_keyGuideForced:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_WIN_ENCHANT_GOGOGO"))
  self._ui.txt_keyGuideNormal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RADIOBTNTITLE_1"))
end
function EnchantInfo:startEnchantAnimation()
  self._ui.slot_targetItem.icon:EraseAllEffect()
  self._ui.slot_targetItem.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
  self._ui.slot_subjectItem.icon:EraseAllEffect()
  self._ui.slot_subjectItem.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
  if self._enchantInfo:ToClient_getEquipType() == 0 then
    self._ui.stc_enchantArtwork:EraseAllEffect()
    self._ui.stc_enchantArtwork:AddEffect("UI_LimitOverLine_Red", false, 0, 0)
    self._ui.stc_enchantArtwork:AddEffect("fUI_LimitOver02A", true, 0, 0)
    self._ui.stc_enchantArtwork:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
  else
    self._ui.stc_enchantArtwork:EraseAllEffect()
    self._ui.stc_enchantArtwork:AddEffect("UI_LimitOverLine", false, 0, 0)
    self._ui.stc_enchantArtwork:AddEffect("fUI_LimitOver02A", true, 0, 0)
    self._ui.stc_enchantArtwork:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
  end
  ToClient_BlackspiritEnchantStart()
  self._animationTimeStamp = 0
  self._isAnimating = true
  _AudioPostEvent_SystemUiForXBOX(5, 6)
  _AudioPostEvent_SystemUiForXBOX(5, 9)
end
function EnchantInfo:startEatEnchantAnimation()
  if self._enchantInfo:ToClient_getEquipType() == 0 then
    self:addWeaponEnchantEffect()
  else
    self:addAmorEnchantEffect()
  end
  ToClient_BlackspiritEnchantStart()
  self._animationTimeStamp = 0
  self._isAnimating = true
  _AudioPostEvent_SystemUiForXBOX(3, 24)
end
function EnchantInfo:addWeaponEnchantEffect()
  self._ui._stc_darkNessSlotImage:EraseAllEffect()
  self._ui._stc_darkNessSlotImage:AddEffect("fUI_Console_Devour_01A", true, 0, 0)
  self._ui._stc_darkNessSlotImage:AddEffect("fUI_Console_Devour_02A", true, 0, 0)
  self._ui._stc_darkNessSlotImage:AddEffect("UI_Console_Devour_01A", false, 0, 0)
end
function EnchantInfo:addAmorEnchantEffect()
  self._ui._stc_darkNessSlotImage:EraseAllEffect()
  self._ui._stc_darkNessSlotImage:AddEffect("fUI_LimitOver02A", true, 0, 0)
  self._ui._stc_darkNessSlotImage:AddEffect("UI_LimitOverLine", false, 0, 0)
  self._ui._stc_darkNessSlotImage:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
end
function FromClient_EnchantInfo_UpdateBonus()
  if _panel:GetShow() then
    EnchantInfo:setEnchantFailCount()
  end
end
function EnchantInfo:setEnchantFailCount()
  if nil == self._enchantInfo then
    self._enchantInfo = getEnchantInformation()
    self._enchantInfo:ToClient_clearData()
  end
  local failCount = self._enchantInfo:ToClient_getFailCount()
  self._ui.txt_bonus1:SetShow(true)
  self._ui.txt_bonus2:SetShow(true)
  self._ui.txt_bonus1Val:SetShow(true)
  self._ui.txt_bonus2Val:SetShow(true)
  local valksCount = self._enchantInfo:ToClient_getValksCount()
  if isGameTypeJapan() or isGameTypeRussia() or isGameTypeKorea() then
    self._ui.txt_bonus2:SetShow(true)
    self._ui.txt_bonus2Val:SetShow(true)
  elseif isGameTypeEnglish() then
    self._ui.txt_bonus2:SetShow(false)
    self._ui.txt_bonus2Val:SetShow(false)
  end
  self._ui.txt_bonus1Val:SetText(tostring(failCount))
  self._ui.txt_bonus2Val:SetText(tostring(valksCount))
  self._ui.txt_totalBonusVal:SetText(tostring(failCount + valksCount))
  self:setText_EnchantInfo()
end
function FromClient_EnchantInfo_PerFrame(deltaTime)
  local self = EnchantInfo
  if true == self._isAnimating then
    self._ui.chk_cronProtect:SetIgnore(true)
    self._ui.chk_skipAnimation:SetIgnore(true)
    self._animationTimeStamp = self._animationTimeStamp + deltaTime
    if self._effectTime_Enchant <= self._animationTimeStamp then
      self._isAnimating = false
      if true == self._ui.rdo_enchantInfo:IsCheck() then
        self:startEnchant()
      elseif true == self._ui.rdo_darkNess:IsCheck() then
        self:EatEnchantItem()
      end
      return
    end
  end
  if self._isLastEnchant then
    if not self._isResulTextAnimation then
      self:setAnimation()
    end
    return
  end
  self._isResulTextAnimation = false
  if self._resultTimeCheck then
    self._resultShowTime = self._resultShowTime + deltaTime
    if self._resultShowTime > 5 then
      self._resultShowTime = 0
      self._resultTimeCheck = false
      self._ui.txt_result:SetShow(false)
    end
  end
  self._delayTime = self._delayTime + deltaTime
  if self._delayTime > 0.7 then
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_EnchantInfo_TryEnchant(false)")
  else
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  end
end
function Toggle_EnchantInfoTab_forPadEventFunc(value)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  if 1 == value then
    Input_EnchantInfo_SetUpperTabRight()
  else
    Input_EnchantInfo_SetUpperTabLeft()
  end
end
function Input_EnchantInfo_SetUpperTabLeft()
  local self = EnchantInfo
  self._currentUpperTab = self._currentUpperTab - 1
  if 0 == self._currentUpperTab then
    self._currentUpperTab = 2
    self:setTabTo(self._currentUpperTab)
    return
  end
  if self._currentUpperTab < 1 then
    self._currentUpperTab = #self._ui.rdo_tabButtons - 1
  end
  self:setTabTo(self._currentUpperTab)
end
function Input_EnchantInfo_SetUpperTabRight()
  local self = EnchantInfo
  self._currentUpperTab = self._currentUpperTab + 1
  if self._currentUpperTab > #self._ui.rdo_tabButtons then
    self._currentUpperTab = 1
  end
  self:setTabTo(self._currentUpperTab)
end
function FromClient_EnchantInfo_PadSnapChangePanel(fromPanel, toPanel)
  if nil ~= toPanel then
    if _panel:GetKey() ~= toPanel:GetKey() then
      _snappedOnThisPanel = false
      _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "")
      _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "")
      _panel:registerPadEvent(__eConsoleUIPadEvent_LSClick, "")
    else
      _snappedOnThisPanel = true
      _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Toggle_EnchantInfoTab_forPadEventFunc(-1)")
      _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Toggle_EnchantInfoTab_forPadEventFunc(1)")
    end
  end
  if _panel:GetShow(true) then
    EnchantInfo:updateApplyButton()
  end
end
function FromClient_EnchantInfo_ResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  local self = EnchantInfo
  self._delayTime = 0
  self._isWaitingServer = false
  EnchantInfo:afterEnchant(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  PaGlobal_TutorialManager:handleEnchantResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
end
function EnchantInfo:afterEnchant(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  if resultType == self._enum_EnchantResult._error then
    ToClient_BlackspiritEnchantCancel()
    return
  end
  self:showEnchantResultEffect(resultType)
  self:showEnchantResultText(resultType, mainSlotNo, mainWhereType)
  self:clearEnchantData()
  if false == self:setEnchantTarget(mainSlotNo, getInventoryItemByType(mainWhereType, mainSlotNo), mainWhereType, resultType, false) then
    local itemWrapper = getInventoryItemByType(mainWhereType, mainSlotNo)
    self._isLastEnchant = false
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        if 5 == enchantLevel then
          self._isLastEnchant = true
        end
      elseif 20 == enchantLevel then
        self._isLastEnchant = true
      end
    end
    if self._isLastEnchant then
      self:setItemToSlot(self._ui.slot_targetItem, mainSlotNo, itemWrapper, mainWhereType)
    else
      self:clearEnchantData()
      ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
      PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
      Inventory_SetFunctor(PaGlobal_EnchantInfo_FilterForEnchantTarget, PaGlobal_EnchantInfo_RClickTarget, nil, nil)
    end
  end
end
function EnchantInfo:showEnchantResultEffect(resultType)
  if resultType == self._enum_EnchantResult._success then
    _AudioPostEvent_SystemUiForXBOX(5, 1)
    render_setChromaticBlur(40, 1)
    render_setPointBlur(0.05, 0.045)
    render_setColorBypass(0.85, 0.08)
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_SUCCESSENCHANT"))
    ToClient_BlackspiritEnchantSuccess()
  else
    _AudioPostEvent_SystemUiForXBOX(0, 7)
    if resultType == self._enum_EnchantResult._broken then
      _AudioPostEvent_SystemUiForXBOX(5, 8)
    elseif resultType == self._enum_EnchantResult._gradeDown then
      _AudioPostEvent_SystemUiForXBOX(5, 2)
    elseif resultType == self._enum_EnchantResult._fail then
      _AudioPostEvent_SystemUiForXBOX(5, 2)
    elseif resultType == self._enum_EnchantResult._failAndPrevent then
      _AudioPostEvent_SystemUiForXBOX(5, 2)
    end
    self._ui.chk_cronProtect:SetIgnore(false)
    self._ui.chk_cronProtect:SetMonoTone(false)
    ToClient_BlackspiritEnchantCancel()
  end
  self:evaluateEnchantTarget(false)
end
function EnchantInfo:showEnchantResultText(resultType, mainSlotNo, mainWhereType)
  if resultType == self._enum_EnchantResult._success then
    self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_0"))
    self._ui.txt_result:EraseAllEffect()
    self._ui.txt_result:AddEffect("UI_QustComplete01", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._fail then
    self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_1"))
    self._ui.txt_result:EraseAllEffect()
    self._ui.txt_result:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._broken then
    self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_2"))
    self._ui.txt_result:EraseAllEffect()
    self._ui.txt_result:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._gradedown then
    self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_3"))
    self._ui.txt_result:EraseAllEffect()
    self._ui.txt_result:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._failAndPrevent then
    self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_4"))
    self._ui.txt_result:EraseAllEffect()
    self._ui.txt_result:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  end
  self._ui.txt_result:SetShow(true)
  self._resultFlag = true
  self._resultTimeCheck = true
end
function EnchantInfo:setAnimation()
  self._ui.txt_result:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SUCCESSFINALENCHANT"))
  self._ui.txt_result:ResetVertexAni()
  self._ui.txt_result:SetScale(1, 1)
  self._ui.txt_result:SetSize(250, 20)
  self._ui.txt_result:ComputePos()
  self._ui.txt_result:SetVertexAniRun("Ani_Move_Pos_New", true)
  self._ui.txt_result:SetVertexAniRun("Ani_Scale_New", true)
  self._isResulTextAnimation = true
end
function EnchantInfo:showEffectByResult(resultType, mainSlotNo, mainWhereType)
  if resultType == self._enum_EnchantResult._success then
    local itemWrapper = getInventoryItemByType(mainWhereType, mainSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        self._ui.slot_targetItem.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
      else
        self._ui.slot_targetItem.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
      end
    end
  else
    self._ui.slot_targetItem.icon:AddEffect("", false, -6, -6)
  end
end
function EnchantInfo:getStr_EnchantInfo(curMaxEndura, decEndura, enchantType, isChecked)
  local str = ""
  if enchantType == self._enum_EnchantType._safe then
    str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT")
  else
    if self._ui.rdo_enhancementFirst:GetShow() and self._ui.rdo_enhancementFirst:IsCheck() then
      decEndura = decEndura * 0.8
    end
    local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory ~= itemSSW:getItemClassify() then
        str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_0", "maxEndurance", tostring(decEndura), "currentEndurance", tostring(curMaxEndura))
      end
    end
    if nil == isChecked then
      if enchantType == self._enum_EnchantType._broken or enchantType == self._enum_EnchantType._downAndBroken then
        if "" == str then
          str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_1")
        else
          str = str .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_1")
        end
      end
      if enchantType == self._enum_EnchantType._gradedown or enchantType == self._enum_EnchantType._downAndBroken then
        if "" == str then
          str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_2")
        else
          str = str .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_2")
        end
      end
    end
  end
  return str
end
function EnchantInfo:getStr_EnchantProtectInfo(enchantType)
  if enchantType == self._enum_EnchantType._broken or enchantType == self._enum_EnchantType._downAndBroken then
    return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_3") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_4")
  else
    return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_5") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_4")
  end
end
function EnchantInfo:getStr_PerfectEnchantInfo(needCount, decEndura)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    if enchantLevel > 14 then
      return PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT") .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_7", "count", tostring(needCount), "endurance", tostring(decEndura))
    end
  end
  return PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT") .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_6", "count", tostring(needCount), "endurance", tostring(decEndura))
end
function EnchantInfo:repositionDesc()
  local tempSizeY = self._ui.txt_normalEnchantDesc:GetTextSizeY() - self._ui.txt_normalEnchantDesc:GetSizeY()
  local tempSizeY2 = self._ui.txt_forceEnchantDesc:GetTextSizeY() - self._ui.txt_forceEnchantDesc:GetSizeY()
  if tempSizeY > 0 or tempSizeY2 > 0 then
    tempSizeY = math.max(tempSizeY, tempSizeY2)
  elseif 0 == tempSizeY or 0 == tempSizeY2 then
    tempSizeY = math.max(self._ui.txt_forceEnchantDesc:GetTextSizeY() - self._txt_normalEnchantSizeY, self._ui.txt_normalEnchantDesc:GetTextSizeY() - self._txt_normalEnchantSizeY)
  else
    tempSizeY = 0
  end
  local CurrentText = self._ui.txt_descSub:GetText()
  local MaxTextSize = self._ui.txt_descSub:GetTextSizeY()
  self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION_FORSTACK"))
  if MaxTextSize < self._ui.txt_descSub:GetTextSizeY() then
    MaxTextSize = self._ui.txt_descSub:GetTextSizeY()
  end
  if self._ui.txt_descSub:GetTextSizeY() < self._ui.txt_descSub:GetSizeY() then
    self._ui.txt_descSub:SetSize(self._ui.txt_descSub:GetSizeX(), self._ui.txt_descSub:GetTextSizeY() + 10)
  else
    self._ui.txt_descSub:SetSize(self._ui.txt_descSub:GetSizeX(), self._ui.txt_descSub:GetTextSizeY() + 30)
  end
  if 0 == self._descSubOriPosY then
    self._descSubOriPosY = self._ui.txt_descSub:GetPosY()
  end
  self._ui.txt_descSub:SetText(CurrentText)
  local gap = self._ui.stc_topMenu:GetSizeY() + self._ui.stc_innerBG:GetSizeY() + MaxTextSize + self._ui.stc_buttonGroupForPad:GetSizeY() + (self._ui.stc_bottomBG:GetSizeY() + 20) + tempSizeY
  self._ui.stc_mainBG:SetSize(self._ui.stc_mainBG:GetSizeX(), gap)
  _panel:SetSize(_panel:GetSizeX(), self._ui.stc_title:GetSizeY() + self._ui.stc_mainBG:GetSizeY())
  local panelCenterPosY = (getScreenSizeY() - _panel:GetSizeY()) / 2
  _panel:SetPosY(panelCenterPosY)
  if self._ui.txt_descSub:GetTextSizeY() + 10 > self._ui.txt_descSub:GetSizeY() then
    self._ui.txt_descSub:SetPosY(self._descSubOriPosY)
  else
    self._ui.txt_descSub:SetPosY(self._descSubOriPosY + 10)
  end
  self._ui.stc_bottomBG:SetPosY(self._ui.stc_mainBG:GetSizeY() + 30)
  self._ui.txt_normalEnchantDesc:SetSize(self._ui.txt_normalEnchantDesc:GetSizeX(), self._txt_normalEnchantSizeY + tempSizeY)
  self._ui.txt_forceEnchantDesc:SetSize(self._ui.txt_normalEnchantDesc:GetSizeX(), self._txt_normalEnchantSizeY + tempSizeY)
  self._ui.stc_buttonGroupForPad:ComputePos()
end
function EnchantInfo:clearEnchantData()
  self:clearItemSlot(self._ui.slot_targetItem)
  self:clearItemSlot(self._ui.slot_subjectItem)
  self:clearItemSlot(self._ui.slot_targetDarkItem)
  self._grantItemWhereType = nil
  self._grantItemSlotNo = nil
  self._enchantInfo:ToClient_clearData()
  self._ui.txt_keyGuideForExit:SetShow(true)
  self._ui.txt_keyGuideForExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_EXIT"))
  self:alignKeyGuides()
  self._ui.txt_keyGuideNormal:SetMonoTone(true)
  self._ui.txt_keyGuideForced:SetMonoTone(true)
  self._ui.txt_keyGuideForced:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_WIN_ENCHANT_GOGOGO"))
  self._ui.txt_keyGuideNormal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RADIOBTNTITLE_1"))
  self._ui.txt_cronCount:SetText("0/0")
  self._ui.chk_skipAnimation:SetIgnore(false)
  self:setText_EnchantInfo()
  self._ui.txt_normalEnchantDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_NORMAL_DESC"))
  self._ui.txt_forceEnchantDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_FORCED_DESC"))
  self._ui.txt_forceEnchantDesc:SetShow(true)
  self._ui.txt_keyGuideForCronStoneTooltip:SetShow(false)
  self:setEnable_CheckboxUseCron(false)
  self:repositionDesc()
  self._ui.stc_enchantArtwork:EraseAllEffect()
  self._ui.stc_enchantTypeArea:SetShow(false)
end
function EnchantInfo:clearItemSlot(slot)
  slot.inventoryType = nil
  slot.slotNo = nil
  slot:clearItem()
  slot.empty = true
  self._ui.stc_enchantArtwork:SetSpanSize(0, 345)
  slot.icon:EraseAllEffect()
end
function EnchantInfo:setItemToSlotMonoTone(slot, itemStaticWrapper)
  slot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  slot.empty = false
  slot.slotNo = 0
  slot.inventoryType = CppEnums.TInventorySlotNoUndefined
  slot.icon:SetMonoTone(true)
  slot:setItemByStaticStatus(itemStaticWrapper, toInt64(0, 0), 0, false, false, false, 0, 0, nil)
end
function PaGlobalFunc_EnchantInfo_SetTargetPanelToProductNote()
  if nil ~= Panel_ProductNote and true == Panel_ProductNote:GetShow() then
    ToClient_padSnapSetTargetPanel(Panel_ProductNote)
    Panel_ProductNote:ignorePadSnapUpdate(true)
  end
end
