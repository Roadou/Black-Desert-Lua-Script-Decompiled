Panel_Window_Inventory:SetShow(false, false)
Panel_Window_Inventory:ActiveMouseEventEffect(true)
Panel_Window_Inventory:setMaskingChild(true)
Panel_Window_Inventory:setGlassBackground(true)
Panel_Window_Inventory:RegisterShowEventFunc(true, "InventoryShowAni()")
Panel_Window_Inventory:RegisterShowEventFunc(false, "InventoryHideAni()")
Panel_Invertory_Manufacture_BG:SetShow(false)
Panel_Invertory_ExchangeButton:SetShow(false)
Panel_Window_Inventory:RegisterUpdateFunc("Inventory_UpdatePerFrame")
Panel_Inventory_CoolTime_Effect_Item_Slot:RegisterShowEventFunc(true, "Inventory_ItemCoolTimeEffect_ShowAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TISNU = CppEnums.TInventorySlotNoUndefined
local UI_TM = CppEnums.TextMode
local UCT_STATICTEXT = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT
local isFirstTab = true
local openUiType
local openWhereIs = false
local over_SlotEffect
local INVEN_MAX_COUNT = 192
local INVEN_CURRENTSLOT_COUNT = 64
Panel_Inventory_isBlackStone_16001 = false
Panel_Inventory_isBlackStone_16002 = false
Panel_Inventory_isSocketItem = false
local radioButtonManu = UI.getChildControl(Panel_Invertory_Manufacture_BG, "Button_Manufacture")
local radioButtonNote = UI.getChildControl(Panel_Invertory_Manufacture_BG, "Button_Note")
local _btn_WayPoint = UI.getChildControl(Panel_Invertory_ExchangeButton, "Button_WayPoint")
local _btn_Widget = UI.getChildControl(Panel_Invertory_ExchangeButton, "Button_Widget")
local icon_TrashOn = UI.getChildControl(Panel_Window_Inventory, "Button_TrashOn")
local icon_TrashSequence = UI.getChildControl(Panel_Window_Inventory, "Button_TrashAlert")
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
local isAlchemyStoneEnble = ToClient_IsContentsGroupOpen("35")
local isAlchemyFigureHeadEnble = ToClient_IsContentsGroupOpen("44")
local isItemLock = ToClient_IsContentsGroupOpen("219")
local burnItemTime = -1
local effectScene = {
  newItem = {}
}
local inven = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCooltime = true,
    createExpiration = true,
    createExpirationBG = true,
    createExpiration2h = true,
    createClassEquipBG = true,
    createEnduranceIcon = true,
    createCooltimeText = true,
    createCash = true,
    createItemLock = true,
    createBagIcon = true,
    createSoulComplete = true
  },
  config = {
    slotCount = 64,
    slotCols = 8,
    slotRows = 0,
    slotStartX = 21,
    slotStartY = 140,
    slotGapX = 54,
    slotGapY = 54,
    slotEnchantX = 13,
    slotEnchantY = 76
  },
  startSlotIndex = 0,
  _slotsBackground = Array.new(),
  slots = Array.new(),
  slotEtcData = {},
  staticTitle = UI.getChildControl(Panel_Window_Inventory, "StaticText_Title"),
  buttonClose = nil,
  _buttonQuestion = nil,
  checkPopUp = nil,
  moneyTypeBG = UI.getChildControl(Panel_Window_Inventory, "Static_MoneyTypeBG"),
  buttonTypeBG = UI.getChildControl(Panel_Window_Inventory, "Static_ButtonTypeBG"),
  topItemSortBG = UI.getChildControl(Panel_Window_Inventory, "Static_TopItemSortBG"),
  weightGaugeBG = UI.getChildControl(Panel_Window_Inventory, "Static_Texture_Weight_Background"),
  enchantNumber = UI.getChildControl(Panel_Window_Inventory, "Static_Text_Slot_Enchant_value"),
  slotBackground = UI.getChildControl(Panel_Window_Inventory, "Static_Slot_BG"),
  button_Puzzle = UI.getChildControl(Panel_Window_Inventory, "Button_Puzzle"),
  radioButtonNormaiInven = UI.getChildControl(Panel_Window_Inventory, "RadioButton_NormalInventory"),
  radioButtonCashInven = UI.getChildControl(Panel_Window_Inventory, "RadioButton_CashInventory"),
  radioButtonInstanceInven = UI.getChildControl(Panel_Window_Inventory, "RadioButton_InstanceInventory"),
  radioButtonStd = UI.getChildControl(Panel_Window_Inventory, "RadioButton_Std"),
  radioButtonTransport = UI.getChildControl(Panel_Window_Inventory, "RadioButton_Transport"),
  radioButtonHousing = UI.getChildControl(Panel_Window_Inventory, "RadioButton_Housing"),
  _baseSlot = UI.getChildControl(Panel_Window_Inventory, "Static_Slot"),
  _baseLockSlot = UI.getChildControl(Panel_Window_Inventory, "Static_LockedSlot"),
  _basePlusSlot = UI.getChildControl(Panel_Window_Inventory, "Static_PlusSlot"),
  _baseOnlyPlus = UI.getChildControl(Panel_Window_Inventory, "Static_OnlyPlus"),
  _expire2h = UI.getChildControl(Panel_Window_Inventory, "Static_Expire_2h"),
  _scroll = UI.getChildControl(Panel_Window_Inventory, "Scroll_CashInven"),
  cashScrollArea = UI.getChildControl(Panel_Window_Inventory, "Scroll_Area"),
  trashArea = UI.getChildControl(Panel_Window_Inventory, "Button_Trash"),
  filterFunc = nil,
  rClickFunc = nil,
  otherWindowOpenFunc = nil,
  isHiding = false,
  effect = nil,
  _tooltipWhereType = nil,
  _tooltipSlotNo = nil,
  orgPosX = Panel_Window_Inventory:GetPosX(),
  orgPosY = Panel_Window_Inventory:GetPosY()
}
function FGlobal_Inventory_GetInven()
  return inven
end
local whereUseItemSlotNo, whereUseItemSSW
local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local helpWidgetBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_1")
local FilterRadioTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Window_Inventory, "HelpWindow_For_InvenFilterRadio")
CopyBaseProperty(helpWidgetBase, FilterRadioTooltip)
FilterRadioTooltip:SetColor(UI_color.C_FFFFFFFF)
FilterRadioTooltip:SetAlpha(1)
FilterRadioTooltip:SetFontColor(UI_color.C_FFC4BEBE)
FilterRadioTooltip:SetAutoResize(true)
FilterRadioTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
FilterRadioTooltip:SetShow(false)
PaGlobal_Inventory = {_itemKeyForTutorial = nil, _isItemSlotRClickedForTutorial = false}
function PaGlobal_Inventory:addSlotEffectForTutorial(slot, effectString, isLoop, posX, posY)
  slot.icon:AddEffect(effectString, isLoop, posX, posY)
  PaGlobal_TutorialUiManager:getUiMasking():showInventoryMasking(slot.icon:GetPosX(), slot.icon:GetPosY())
end
function PaGlobal_Inventory:setItemKeyForTutorial(itemKey)
  self._itemKeyForTutorial = itemKey
end
function PaGlobal_Inventory:clearItemKeyForTutorial(itemKey)
  self._itemKeyForTutorial = nil
end
function PaGlobal_Inventory:isItemSlotRClickedForTutorial()
  return self._isItemSlotRClickedForTutorial
end
function PaGlobal_Inventory:setIsitemSlotRClickedForTutorial(bool)
  PaGlobal_Inventory._isItemSlotRClickedForTutorial = bool
end
function PaGlobal_Inventory:findItemCountByEventType(targetContentsEventType, typeParam1, typeParam2)
  local inventory = getSelfPlayer():get():getInventory(CppEnums.ItemWhereType.eCashInventory)
  local itemCount = 0
  if nil ~= inventory then
    local invenMaxSize = inventory:sizeXXX()
    for ii = 0, invenMaxSize - 1 do
      local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, ii)
      if nil ~= itemWrapper then
        local itemSSW = itemWrapper:getStaticStatus()
        local ContentsEventType = itemSSW:get():getContentsEventType()
        local ContentsEventParam1 = itemSSW:get()._contentsEventParam1
        local ContentsEventParam2 = itemSSW:get()._contentsEventParam2
        local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
        if ContentsEventType == targetContentsEventType then
          if nil == typeParam1 and nil == typeParam2 then
            itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
          elseif nil ~= typeParam1 and ContentsEventParam1 == typeParam1 then
            if nil ~= typeParam2 and ContentsEventParam2 == typeParam2 then
              itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
            elseif nil == typeParam2 then
              itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
            end
          end
        end
      end
    end
  end
  inventory = getSelfPlayer():get():getInventory(CppEnums.ItemWhereType.eInventory)
  if nil ~= inventory then
    local invenMaxSize = inventory:sizeXXX()
    for ii = 0, invenMaxSize - 1 do
      local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, ii)
      if nil ~= itemWrapper then
        local itemSSW = itemWrapper:getStaticStatus()
        local ContentsEventType = itemSSW:get():getContentsEventType()
        local ContentsEventParam1 = itemSSW:get()._contentsEventParam1
        local ContentsEventParam2 = itemSSW:get()._contentsEventParam2
        local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
        if ContentsEventType == targetContentsEventType then
          if nil == typeParam1 and nil == typeParam2 then
            itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
          elseif nil ~= typeParam1 and ContentsEventParam1 == typeParam1 then
            if nil ~= typeParam2 and ContentsEventParam2 == typeParam2 then
              itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
            elseif nil == typeParam2 then
              itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
            end
          end
        end
      end
    end
  end
  if true == ToClient_IsDevelopment() then
    inventory = getSelfPlayer():get():getInventory(CppEnums.ItemWhereType.eInstanceInventory)
    if nil ~= inventory then
      local invenMaxSize = inventory:sizeXXX()
      for ii = 0, invenMaxSize - 1 do
        local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInstanceInventory, ii)
        if nil ~= itemWrapper then
          local itemSSW = itemWrapper:getStaticStatus()
          local ContentsEventType = itemSSW:get():getContentsEventType()
          local ContentsEventParam1 = itemSSW:get()._contentsEventParam1
          local ContentsEventParam2 = itemSSW:get()._contentsEventParam2
          local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
          if ContentsEventType == targetContentsEventType then
            if nil == typeParam1 and nil == typeParam2 then
              itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
            elseif nil ~= typeParam1 and ContentsEventParam1 == typeParam1 then
              if nil ~= typeParam2 and ContentsEventParam2 == typeParam2 then
                itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
              elseif nil == typeParam2 then
                itemCount = itemCount + Int64toInt32(itemWrapper:get():getCount_s64())
              end
            end
          end
        end
      end
    end
  end
  return itemCount
end
function PaGlobal_Inventory:findItemWrapper(itemWhereType, targetItemKey, targetEnchantLevel)
  local inventory = getSelfPlayer():get():getInventoryByType(itemWhereType)
  if nil == inventory then
    return false
  end
  local invenMaxSize = inventory:sizeXXX()
  for ii = 0, invenMaxSize - 1 do
    local itemWrapper = getInventoryItemByType(itemWhereType, ii)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
      if itemKey == targetItemKey then
        if nil == targetEnchantLevel then
          return itemWrapper
        elseif nil ~= targetEnchantLevel and enchantLevel == targetEnchantLevel then
          return itemWrapper
        end
      end
    end
  end
  return nil
end
local weightHelp = {
  _weightHelp_BG = UI.getChildControl(Panel_Window_Inventory, "Static_WeightHelp_BG"),
  _weightHelp = UI.getChildControl(Panel_Window_Inventory, "StaticText_Weight_Help"),
  _equipHelp = UI.getChildControl(Panel_Window_Inventory, "StaticText_Equip_Help"),
  _moneyHelp = UI.getChildControl(Panel_Window_Inventory, "StaticText_MoneyHelp")
}
local sizeY = weightHelp._weightHelp_BG:GetSizeY()
function Panel_Inventory_SlotText_SimpleTooltip(isShow)
  if not isShow then
    return TooltipSimple_Hide()
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BUYSLOT_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BUYSLOT_TOOLTIP_DESC")
  control = inven.staticCapacity
  TooltipSimple_Show(control, name, desc)
end
function Panel_Inventory_WeightHelpFunc(isOn)
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local s64_moneyWeight = selfPlayer:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local moneyWeight = Int64toInt32(s64_moneyWeight) / 10000
  local equipmentWeight = Int64toInt32(s64_equipmentWeight) / 10000
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local invenWeight = allWeight - equipmentWeight - moneyWeight
  if isOn == true then
    weightHelp._weightHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_1") .. string.format("%.1f", invenWeight) .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT") .. "(" .. string.format("%.1f", invenWeight / maxWeight * 100) .. "%)")
    weightHelp._equipHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_EQUIPHELP_1") .. string.format("%.1f", equipmentWeight) .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT") .. "(" .. string.format("%.1f", equipmentWeight / maxWeight * 100) .. "%)")
    weightHelp._moneyHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_MONEYHELP_1") .. string.format("%.1f", moneyWeight) .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT") .. "(" .. string.format("%.1f", moneyWeight / maxWeight * 100) .. "%)")
    Panel_Window_Inventory:SetChildIndex(weightHelp._weightHelp_BG, 9000)
    Panel_Window_Inventory:SetChildIndex(weightHelp._weightHelp, 9999)
    Panel_Window_Inventory:SetChildIndex(weightHelp._equipHelp, 9999)
    Panel_Window_Inventory:SetChildIndex(weightHelp._moneyHelp, 9999)
    for _, value in pairs(weightHelp) do
      value:SetShow(true)
      if true == _ContentsGroup_RenewUI_ItemMarketPlace then
        weightHelp._moneyHelp:SetShow(false)
        weightHelp._weightHelp_BG:SetSize(weightHelp._weightHelp_BG:GetSizeX(), sizeY - 10)
        weightHelp._weightHelp_BG:SetPosY(weightHelp._weightHelp:GetPosY() - 12)
      end
    end
  else
    for _, value in pairs(weightHelp) do
      value:SetShow(false)
    end
  end
end
function Panel_Inventory_WeightHelp(bool)
  local _const = Defines.s64_const
  local selfPlayer = getSelfPlayer():get()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local weightPercent = Int64toInt32(s64_allWeight / s64_maxWeight_div)
  weightHelp._weightHelp:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_WEIGHTHELP", "weightPercent", weightPercent))
  weightHelp._equipHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_3"))
  weightHelp._moneyHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_WEIGHTHELP_4"))
  if true == bool then
    for _, value in pairs(weightHelp) do
      value:SetShow(true)
    end
  else
    for _, value in pairs(weightHelp) do
      value:SetShow(false)
    end
  end
end
local _puzzleMessage
local _puzzleNotice = UI.getChildControl(Panel_Window_Inventory, "Static_Notice")
local _puzzleNoticeStyle = UI.getChildControl(Panel_Window_Inventory, "StaticText_Notice")
local _puzzleNoticeText = UI.createControl(UCT_STATICTEXT, _puzzleNotice, "puzzleNoticeText")
CopyBaseProperty(_puzzleNoticeStyle, _puzzleNoticeText)
UI.deleteControl(_puzzleNoticeStyle)
_puzzleNoticeStyle = nil
_puzzleNoticeText:SetSpanSize(20, 0)
function InventoryShowAni()
  local self = inven
  UIAni.fadeInSCR_Left(Panel_Window_Inventory)
  isFirstTab = false
  local aniInfo1 = Panel_Window_Inventory:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.05)
  aniInfo1.AxisX = Panel_Window_Inventory:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Inventory:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_Inventory:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.05)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Inventory:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Inventory:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function InventoryHideAni()
  Panel_Window_Inventory:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_Inventory:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  _puzzleNotice:SetShow(false)
end
function Inventory_ItemCoolTimeEffect_ShowAni()
  local coolTime_Hide = UIAni.AlphaAnimation(0, Panel_Inventory_CoolTime_Effect_Item_Slot, 0, 0.7)
  coolTime_Hide:SetHideAtEnd(true)
end
function inven:init()
  self.config.slotRows = self.config.slotCount / self.config.slotCols
  self.enchantNumber:SetShow(false)
  self.buttonClose = UI.getChildControl(self.staticTitle, "Button_Win_Close")
  self._buttonQuestion = UI.getChildControl(self.staticTitle, "Button_Question")
  self.checkPopUp = UI.getChildControl(self.staticTitle, "CheckButton_PopUp")
  self.radioButtonInstanceInven:addInputEvent("Mouse_LUp", "Inventory_Tab()")
  self.weightItem = UI.getChildControl(self.weightGaugeBG, "Progress2_Weight")
  self.weightEquipment = UI.getChildControl(self.weightGaugeBG, "Progress2_Equipment")
  self.weightMoney = UI.getChildControl(self.weightGaugeBG, "Progress2_Money")
  self.weightIcon = UI.getChildControl(self.weightGaugeBG, "Static_WeightIcon")
  self.staticWeight = UI.getChildControl(self.weightGaugeBG, "StaticText_Weight")
  self.btn_BuyWeight = UI.getChildControl(self.weightGaugeBG, "Button_BuyWeight")
  self.btn_BuyWeight:SetShow(true)
  self.staticCapacity = UI.getChildControl(Panel_Window_Inventory, "Static_Text_Capacity")
  self.staticMoney = UI.getChildControl(self.moneyTypeBG, "Static_Text_Money")
  self.buttonMoney = UI.getChildControl(self.moneyTypeBG, "Button_Money")
  self.buttonPearl = UI.getChildControl(self.moneyTypeBG, "Static_PearlIcon")
  self.valuePearl = UI.getChildControl(self.moneyTypeBG, "StaticText_PearlValue")
  self.buttonMileage = UI.getChildControl(self.moneyTypeBG, "Static_MileageIcon")
  self.valueMileage = UI.getChildControl(self.moneyTypeBG, "StaticText_MileageValue")
  self.btn_Manufacture = UI.getChildControl(self.buttonTypeBG, "Button_Manufacture")
  self.btn_AlchemyStone = UI.getChildControl(self.buttonTypeBG, "Button_AlchemyStone")
  self.btn_AlchemyFigureHead = UI.getChildControl(self.buttonTypeBG, "Button_AlchemyFigureHead")
  self.btn_DyePalette = UI.getChildControl(self.buttonTypeBG, "Button_Palette")
  self.staticWeight:addInputEvent("Mouse_On", "Panel_Inventory_WeightHelpFunc( true )")
  self.staticWeight:addInputEvent("Mouse_Out", "Panel_Inventory_WeightHelpFunc( false )")
  self.weightGaugeBG:addInputEvent("Mouse_On", "Panel_Inventory_WeightHelpFunc( true )")
  self.weightGaugeBG:addInputEvent("Mouse_Out", "Panel_Inventory_WeightHelpFunc( false )")
  self.weightIcon:addInputEvent("Mouse_On", "Panel_Inventory_WeightHelp( true )")
  self.weightIcon:addInputEvent("Mouse_Out", "Panel_Inventory_WeightHelp( false )")
  self.btn_BuyWeight:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 4 )")
  self.btn_BuyWeight:addInputEvent("Mouse_On", "Panel_Inventory_SimpleTooltip(true, 0)")
  self.btn_BuyWeight:addInputEvent("Mouse_Out", "Panel_Inventory_SimpleTooltip(false)")
  self.checkPopUp:addInputEvent("Mouse_LUp", "InventoryWindow_CheckPopUpUI()")
  self.checkPopUp:addInputEvent("Mouse_On", "Inventory_PopUp_ShowIconToolTip(true)")
  self.checkPopUp:addInputEvent("Mouse_Out", "Inventory_PopUp_ShowIconToolTip(false)")
  self.checkPopUp:SetShow(isPopUpContentsEnable)
  self.staticCapacity:addInputEvent("Mouse_LUp", "PaGlobal_EasyBuy:Open( 5 )")
  self.staticCapacity:addInputEvent("Mouse_On", "Panel_Inventory_SlotText_SimpleTooltip( true )")
  self.staticCapacity:addInputEvent("Mouse_Out", "Panel_Inventory_SlotText_SimpleTooltip( false )")
  self.radioButtonNormaiInven:addInputEvent("Mouse_LUp", "Inventory_Tab()")
  self.radioButtonCashInven:addInputEvent("Mouse_LUp", "Inventory_Tab()")
  self.radioButtonStd:addInputEvent("Mouse_LUp", "Inventory_TabSound()")
  self.radioButtonTransport:addInputEvent("Mouse_LUp", "Inventory_TabSound()")
  self.radioButtonHousing:addInputEvent("Mouse_LUp", "Inventory_TabSound()")
  self.radioButtonStd:addInputEvent("Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 0 .. ")")
  self.radioButtonTransport:addInputEvent("Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 1 .. ")")
  self.radioButtonHousing:addInputEvent("Mouse_On", "Inventory_FilterRadioTooltip_Show( true, " .. 2 .. ")")
  self.radioButtonStd:addInputEvent("Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )")
  self.radioButtonTransport:addInputEvent("Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )")
  self.radioButtonHousing:addInputEvent("Mouse_Out", "Inventory_FilterRadioTooltip_Show( false )")
  self.radioButtonStd:SetShow(false)
  self.radioButtonTransport:SetShow(false)
  self.radioButtonHousing:SetShow(false)
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowInventory\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowInventory\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindiowInventory\", \"false\")")
  self.btn_AlchemyStone:addInputEvent("Mouse_LUp", "HandleClicked_Inventory_Function( " .. 0 .. " )")
  self.btn_AlchemyStone:addInputEvent("Mouse_On", "Inventory_Btn_SimpleTooltip( true, " .. 0 .. " )")
  self.btn_AlchemyStone:addInputEvent("Mouse_Out", "Inventory_Btn_SimpleTooltip( false, " .. 0 .. " )")
  self.btn_AlchemyFigureHead:addInputEvent("Mouse_LUp", "HandleClicked_Inventory_Function( " .. 1 .. " )")
  self.btn_AlchemyFigureHead:addInputEvent("Mouse_On", "Inventory_Btn_SimpleTooltip( true, " .. 1 .. " )")
  self.btn_AlchemyFigureHead:addInputEvent("Mouse_Out", "Inventory_Btn_SimpleTooltip( false, " .. 1 .. " )")
  self.btn_DyePalette:addInputEvent("Mouse_LUp", "HandleClicked_Inventory_Function( " .. 2 .. " )")
  self.btn_DyePalette:addInputEvent("Mouse_On", "Inventory_Btn_SimpleTooltip( true, " .. 2 .. " )")
  self.btn_DyePalette:addInputEvent("Mouse_Out", "Inventory_Btn_SimpleTooltip( false,  " .. 2 .. " )")
  self.btn_Manufacture:addInputEvent("Mouse_LUp", "HandleClicked_Inventory_Function( " .. 3 .. " )")
  self.btn_Manufacture:addInputEvent("Mouse_On", "Inventory_Btn_SimpleTooltip( true, " .. 3 .. " )")
  self.btn_Manufacture:addInputEvent("Mouse_Out", "Inventory_Btn_SimpleTooltip( false, " .. 3 .. " )")
  if isAlchemyStoneEnble then
    self.btn_AlchemyStone:setButtonShortcuts("PANEL_SIMPLESHORTCUT_ALCHEMY_RECHARGE")
  end
  if isAlchemyStoneEnble then
    self.btn_AlchemyStone:SetShow(true)
  else
    self.btn_AlchemyStone:SetShow(false)
  end
  if isAlchemyFigureHeadEnble then
    self.btn_AlchemyFigureHead:SetShow(true)
  else
    self.btn_AlchemyFigureHead:SetShow(false)
  end
  self.trashArea:addInputEvent("Mouse_LUp", "HandleClicked_Inventory_ItemDelete()")
  self.trashArea:addInputEvent("Mouse_On", "Inventory_TrashToolTip( true )")
  self.trashArea:addInputEvent("Mouse_Out", "Inventory_TrashToolTip( false )")
  UIScroll.InputEvent(self._scroll, "Inventory_CashTabScroll")
  UIScroll.InputEventByControl(self.cashScrollArea, "Inventory_CashTabScroll")
  if isGameTypeJapan() or isGameTypeRussia() then
    self.radioButtonCashInven:SetTextSpan(40, 7)
    self.radioButtonNormaiInven:SetTextSpan(50, 7)
  elseif 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then
    self.radioButtonCashInven:SetTextSpan(50, 7)
    self.radioButtonNormaiInven:SetTextSpan(60, 7)
  end
  self.radioButtonInstanceInven:SetShow(ToClient_IsDevelopment())
  self.checkButton_Sort = UI.getChildControl(self.topItemSortBG, "CheckButton_ItemSort")
  local sortBtn_sizeX = self.checkButton_Sort:GetSizeX()
  local sortBtn_TextSizeX = self.checkButton_Sort:GetTextSizeX()
  self.checkButton_Sort:SetEnableArea(0, 0, 100, self.checkButton_Sort:GetSizeY())
  local btnNormalSizeX = self.radioButtonNormaiInven:GetSizeX() + 23
  local btnNormalTextPosX = btnNormalSizeX - btnNormalSizeX / 2 - self.radioButtonNormaiInven:GetTextSizeX() / 2
  local btnCashSizeX = self.radioButtonCashInven:GetSizeX() + 23
  local btnCashTextPosX = btnCashSizeX - btnCashSizeX / 2 - self.radioButtonCashInven:GetTextSizeX() / 2
  local btnManufactureSizeX = self.btn_Manufacture:GetSizeX() + 23
  local btnManufactureTextPosX = btnManufactureSizeX - btnManufactureSizeX / 2 - self.btn_Manufacture:GetTextSizeX() / 2
  local btnAlchemyStoneSizeX = self.btn_AlchemyStone:GetSizeX() + 23
  local btnAlchemyStoneTextPosX = btnAlchemyStoneSizeX - btnAlchemyStoneSizeX / 2 - self.btn_AlchemyStone:GetTextSizeX() / 2
  local btnAlchemyFigureSizeX = self.btn_AlchemyFigureHead:GetSizeX() + 23
  local btnAlchemyFigureTextPosX = btnAlchemyFigureSizeX - btnAlchemyFigureSizeX / 2 - self.btn_AlchemyFigureHead:GetTextSizeX() / 2
  local btnDyePaletteSizeX = self.btn_DyePalette:GetSizeX() + 23
  local btnDyePaletteTextPosX = btnDyePaletteSizeX - btnDyePaletteSizeX / 2 - self.btn_DyePalette:GetTextSizeX() / 2
  self.radioButtonNormaiInven:SetTextSpan(btnNormalTextPosX, 5)
  self.radioButtonCashInven:SetTextSpan(btnCashTextPosX, 5)
  self.btn_Manufacture:SetTextSpan(btnManufactureTextPosX, 5)
  self.btn_AlchemyStone:SetTextSpan(btnAlchemyStoneTextPosX, 5)
  self.btn_AlchemyFigureHead:SetTextSpan(btnAlchemyFigureTextPosX, 5)
  self.btn_DyePalette:SetTextSpan(btnDyePaletteTextPosX, 5)
  PaGlobal_Inventory_ChangeMileage()
  if isGameTypeSA() then
    local gap = 15
    self.weightGaugeBG:SetSize(self.weightGaugeBG:GetSizeX() - gap, self.weightGaugeBG:GetSizeY())
    self.weightItem:SetSize(self.weightItem:GetSizeX() - gap, self.weightItem:GetSizeY())
    self.weightEquipment:SetSize(self.weightEquipment:GetSizeX() - gap, self.weightEquipment:GetSizeY())
    self.weightMoney:SetSize(self.weightMoney:GetSizeX() - gap, self.weightMoney:GetSizeY())
    self.weightGaugeBG:SetPosX(self.weightGaugeBG:GetPosX() + gap)
    self.btn_BuyWeight:ComputePos()
  end
end
function Inventory_Btn_SimpleTooltip(isShow, tipType)
  if not isShow then
    return TooltipSimple_Hide()
  end
  local self = inven
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ALCHEMYSTONE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ALCHEMYSTONE_TOOLTIP_DESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    control = self.btn_AlchemyStone
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ALCHEMYFIGUREHEAD_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ALCHEMYFIGUREHEAD_TOOLTIP_DESC")
    control = self.btn_AlchemyFigureHead
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_DYEPALETTE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_DYEPALETTE_TOOLTIP_DESC")
    control = self.btn_DyePalette
  elseif 3 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_MANUFACTURE_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_MANUFACTURE_TOOLTIP_DESC")
    control = self.btn_Manufacture
  end
  TooltipSimple_Show(control, name, desc)
end
function Inventory_Tab()
  PaGlobal_FixEquip:StreamRecoveryStop()
  local self = inven
  self.startSlotIndex = 0
  if DragManager:isDragging() then
    DragManager:clearInfo()
  end
  Inventory_TabSound()
  Inventory_DropEscape()
  if Panel_Window_ClothInventory:GetShow() then
    ClothInventory_Close()
  end
end
function HandleClicked_Inventory_Function(functionType)
  if DragManager:isDragging() then
    DragManager:clearInfo()
  end
  if 0 == functionType then
    FGlobal_AlchemyStone_Open()
  elseif 1 == functionType then
    FGlobal_AlchemyFigureHead_Open()
  elseif 2 == functionType then
    HandleClicked_Inventory_Palette_Open()
  elseif 3 == functionType then
    Inventory_ManufactureBTN()
  end
end
function Toggle_InventoryTab_forPadEventFunc()
  local self = inven
  local normInvenCheck = self.radioButtonNormaiInven:IsCheck()
  local cashInvenCheck = self.radioButtonCashInven:IsCheck()
  if true == normInvenCheck then
    self.radioButtonNormaiInven:SetCheck(false)
    self.radioButtonCashInven:SetCheck(true)
    self.radioButtonInstanceInven:SetCheck(false)
  elseif true == cashInvenCheck then
    self.radioButtonNormaiInven:SetCheck(true)
    self.radioButtonCashInven:SetCheck(false)
    self.radioButtonInstanceInven:SetCheck(false)
  else
    self.radioButtonNormaiInven:SetCheck(false)
    self.radioButtonCashInven:SetCheck(false)
    self.radioButtonInstanceInven:SetCheck(true)
  end
  Inventory_TabSound()
end
function Inventory_TabSound()
  if DragManager:isDragging() then
    DragManager:clearInfo()
  end
  if isFirstTab == true then
    isFirstTab = false
  else
    audioPostEvent_SystemUi(0, 0)
  end
  Inventory_updateSlotData()
  Inventory_CashTabScroll(true)
end
function Inventory_ScrollUpEvent()
  Inventory_CashTabScroll(true)
end
function Inventory_ScrollDownEvent()
  Inventory_CashTabScroll(false)
end
function inven:createSlot()
  for ii = 0, self.config.slotCount - 1 do
    local slot = {}
    slot.empty = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, "Inventory_Slot_Base_" .. ii)
    slot.lock = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, "Inventory_Slot_Lock_" .. ii)
    slot.plus = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, "Inventory_Slot_Plus_" .. ii)
    slot.onlyPlus = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, "Inventory_Slot_OnlyPlus_" .. ii)
    CopyBaseProperty(self._baseSlot, slot.empty)
    CopyBaseProperty(self._baseLockSlot, slot.lock)
    CopyBaseProperty(self._basePlusSlot, slot.plus)
    CopyBaseProperty(self._baseOnlyPlus, slot.onlyPlus)
    UIScroll.InputEventByControl(slot.empty, "Inventory_CashTabScroll")
    local row = math.floor(ii / self.config.slotCols)
    local col = ii % self.config.slotCols
    slot.empty:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    slot.empty:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.lock:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    slot.lock:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.plus:SetPosX(self.config.slotStartX + self.config.slotGapX * col - 4)
    slot.plus:SetPosY(self.config.slotStartY + self.config.slotGapY * row - 4)
    slot.onlyPlus:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    slot.onlyPlus:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.empty:SetShow(false)
    slot.lock:SetShow(false)
    slot.plus:SetShow(false)
    slot.onlyPlus:SetShow(false)
    self._slotsBackground[ii] = slot
  end
  local useStartSlot = inventorySlotNoUserStart()
  for ii = 0, self.config.slotCount - 1 do
    local slotNo = ii + useStartSlot
    local slot = {}
    SlotItem.new(slot, "ItemIcon_" .. ii, ii, Panel_Window_Inventory, self.slotConfig)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "Inventory_SlotRClick(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_LDown", "Inventory_SlotLClick(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_LUp", "Inventory_DropHandler(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_PressMove", "Inventory_SlotDrag(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_On", "Inventory_IconOver(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Inventory_IconOut(" .. ii .. ")")
    UIScroll.InputEventByControl(slot.icon, "Inventory_CashTabScroll")
    slot.icon:SetAutoDisableTime(0.5)
    local row = math.floor(ii / self.config.slotCols)
    local col = ii % self.config.slotCols
    slot.icon:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    slot.icon:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.icon:SetEnableDragAndDrop(true)
    slot.isEmpty = true
    Panel_Tooltip_Item_SetPosition(ii, slot, "inventory")
    slot.background = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_Window_Inventory, "Inventory_Slot_BG_" .. ii)
    CopyBaseProperty(self.slotBackground, slot.background)
    slot.background:SetSize(slot.icon:GetSizeX(), slot.icon:GetSizeY())
    slot.background:SetPosX(slot.icon:GetPosX())
    slot.background:SetPosY(slot.icon:GetPosY())
    slot.background:SetShow(false)
    slot.icon:SetSize(44, 44)
    slot.border:SetSize(44, 44)
    slot.border:SetPosX(0.5)
    slot.border:SetPosY(0.5)
    slot.expiration2h:SetSize(44, 44)
    slot.expiration2h:SetPosX(5)
    slot.expiration2h:SetPosY(5)
    slot.expirationBG:SetSize(44, 44)
    slot.cooltime:SetSize(44, 44)
    slot.cooltime:SetPosX(0)
    slot.cooltime:SetPosY(0)
    self.slots[ii] = slot
    local effectSlot = {}
    local puzzle = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, slot.icon, "Puzzle_Control_" .. ii)
    CopyBaseProperty(inven.button_Puzzle, puzzle)
    puzzle:SetShow(false)
    puzzle:addInputEvent("Mouse_LUp", "MakePuzzle(" .. ii .. ")")
    puzzle:addInputEvent("Mouse_On", "PuzzleButton_Over(" .. ii .. ")")
    puzzle:addInputEvent("Mouse_Out", "PuzzleButton_Out(" .. ii .. ")")
    Panel_Window_Inventory:SetChildIndex(_puzzleNotice, 9999)
    Panel_Window_Inventory:SetChildIndex(self.slots[ii].icon, 9998)
    effectSlot.isFirstItem = false
    effectSlot.puzzleControl = puzzle
    self.slotEtcData[ii] = effectSlot
  end
  if FGlobal_IsCommercialService() then
    if isGameTypeGT() then
      inven.buttonPearl:SetShow(false)
      inven.valuePearl:SetShow(false)
    else
      inven.buttonPearl:SetShow(true)
      inven.valuePearl:SetShow(true)
      inven.buttonMileage:SetShow(true)
      inven.valueMileage:SetShow(true)
    end
  elseif isGameTypeEnglish() then
    inven.buttonPearl:SetShow(true)
    inven.valuePearl:SetShow(true)
    inven.buttonMileage:SetShow(true)
    inven.valueMileage:SetShow(true)
  else
    inven.buttonPearl:SetShow(false)
    inven.valuePearl:SetShow(false)
    inven.buttonMileage:SetShow(false)
    inven.valueMileage:SetShow(false)
  end
  if isGameTypeGT() then
    inven.buttonPearl:SetShow(false)
    inven.valuePearl:SetShow(false)
    inven.buttonMileage:SetShow(false)
    inven.valueMileage:SetShow(false)
  end
end
function InventoryWindow_CheckPopUpUI()
  if inven.checkPopUp:IsCheck() then
    Panel_Window_Inventory:OpenUISubApp()
  else
    Panel_Window_Inventory:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function HandleClicked_InventoryWindow_Close()
  audioPostEvent_SystemUi(1, 1)
  Panel_Window_Inventory:CloseUISubApp()
  inven.checkPopUp:SetCheck(false)
  InventoryWindow_Close()
end
function inven:setClosingFlag(flag)
  self._isClosing = flag
end
function FGlobal_InventoryIsClosing()
  local self = inven
  return self._isClosing
end
function InventoryWindow_Close()
  if true == PaGlobalFunc_ExchangePC_GetShow() then
    return
  end
  local self = inven
  self:setClosingFlag(true)
  if nil ~= PaGlobalFunc_ServantIcon_MaidCoolUpdate then
    PaGlobalFunc_ServantIcon_MaidCoolUpdate()
  end
  if Panel_Window_Inventory:IsUISubApp() then
    Inventory_SetFunctor(nil, nil, nil, nil)
    return
  end
  if Panel_Equipment:IsUISubApp() then
    HandleClicked_EquipmentWindow_Close()
  end
  local self = inven
  if nil ~= self.otherWindowOpenFunc then
    local callFunc = self.otherWindowOpenFunc
    self.otherWindowOpenFunc = nil
    callFunc()
  end
  self.filterFunc = nil
  self.rClickFunc = nil
  self.effect = nil
  if ToClient_IsSavedUi() then
    ToClient_SaveUiInfo(false)
    ToClient_SetSavedUi(false)
  end
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  Panel_Window_Inventory:SetShow(false, false)
  PaGlobal_TutorialManager:handleClosedInventory()
  Panel_Tooltip_Item_hideTooltip()
  UIMain_ItemUpdateRemove()
  if Panel_AlchemyStone:GetShow() then
    FGlobal_AlchemyStone_Close()
  end
  if Panel_AlchemyFigureHead:GetShow() then
    FGlobal_AlchemyFigureHead_Close()
  end
  if Panel_DyePalette:GetShow() then
    FGlobal_DyePalette_Close()
  end
  icon_TrashOn:SetShow(false)
  icon_TrashSequence:SetShow(false)
  for _, value in pairs(self.slotEtcData) do
    value.isFirstItem = false
  end
  for _, slot in pairs(self.slots) do
    slot.icon:EraseAllEffect()
    slot.icon:SetEnable(true)
    slot.icon:SetMonoTone(false)
    slot.icon:SetIgnore(false)
  end
  if Panel_Window_ClothInventory:GetShow() then
    ClothInventory_Close()
  end
  if true == PaGlobalFunc_ServantInventory_GetShow() then
    ServantInventory_Close()
  end
  if true == openUiType then
    FGlobal_Equipment_SetHide(false)
  elseif false == openUiType then
    FGlobal_Equipment_SetHide(true)
  end
  HelpMessageQuestion_Out()
  Panel_Invertory_Manufacture_BG:SetShow(false)
  Panel_Invertory_ExchangeButton:SetShow(false)
  Panel_Window_Inventory:SetPosX(inven.orgPosX)
  Panel_Window_Inventory:SetPosY(inven.orgPosY)
  self:setClosingFlag(false)
end
function InventoryWindow_Show(uiType, isCashInven, isMarket)
  local self = inven
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  self.effect = nil
  self.startSlotIndex = 0
  openUiType = uiType
  openWhereIs = isMarket
  local isSorted = ToClient_IsSortedInventory()
  self.checkButton_Sort:SetCheck(isSorted)
  icon_TrashOn:SetShow(false)
  icon_TrashSequence:SetShow(false)
  if nil == isCashInven then
    if Panel_ColorBalance:GetShow() or Panel_Window_Extraction_Cloth:GetShow() then
      self.radioButtonNormaiInven:SetCheck(false)
      self.radioButtonCashInven:SetCheck(true)
    else
      self.radioButtonNormaiInven:SetCheck(true)
      self.radioButtonCashInven:SetCheck(false)
    end
    if Panel_Manufacture:GetShow() then
      self.radioButtonCashInven:SetEnable(false)
      self.radioButtonCashInven:SetIgnore(true)
      self.radioButtonCashInven:SetMonoTone(true)
    else
      self.radioButtonCashInven:SetEnable(true)
      self.radioButtonCashInven:SetIgnore(false)
      self.radioButtonCashInven:SetMonoTone(false)
    end
  elseif isCashInven then
    self.radioButtonNormaiInven:SetCheck(false)
    self.radioButtonCashInven:SetCheck(true)
    self.radioButtonInstanceInven:SetCheck(false)
  else
    self.radioButtonNormaiInven:SetCheck(true)
    self.radioButtonCashInven:SetCheck(false)
    self.radioButtonInstanceInven:SetCheck(false)
  end
  if ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_BattleRoyale) and _ContentsGroup_RedDesert then
    self.radioButtonCashInven:SetShow(false)
    self.radioButtonNormaiInven:SetShow(false)
    self.radioButtonCashInven:SetCheck(false)
    self.radioButtonNormaiInven:SetCheck(false)
    self.radioButtonInstanceInven:SetCheck(true)
  else
    self.radioButtonCashInven:SetShow(true)
    self.radioButtonNormaiInven:SetShow(true)
    self.radioButtonInstanceInven:SetCheck(false)
  end
  self.radioButtonStd:SetCheck(true)
  self.radioButtonTransport:SetCheck(false)
  self.radioButtonHousing:SetCheck(false)
  Inventory_updateSlotData(true)
  self._scroll:SetControlTop()
  Panel_Window_Inventory:SetShow(true, true)
  PaGlobal_TutorialManager:handleOpenedInventory()
  if not Panel_Window_Warehouse:GetShow() and not PaGlobalFunc_ServantInventory_GetShow() then
    inven.buttonMoney:SetEnable(false)
  else
    inven.buttonMoney:SetEnable(true)
  end
  if isGameTypeRussia() and (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT or getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT) then
    self.btn_DyePalette:SetMonoTone(true)
    self.btn_DyePalette:SetIgnore(true)
    self.btn_DyePalette:SetEnable(false)
  else
    self.btn_DyePalette:SetMonoTone(false)
    self.btn_DyePalette:SetIgnore(false)
    self.btn_DyePalette:SetEnable(true)
  end
  if isFlushedUI() then
    self.btn_Manufacture:SetEnable(false)
    self.btn_Manufacture:SetMonoTone(true)
    self.btn_AlchemyStone:SetEnable(false)
    self.btn_AlchemyStone:SetMonoTone(true)
    self.btn_AlchemyFigureHead:SetEnable(false)
    self.btn_AlchemyFigureHead:SetMonoTone(true)
    self.btn_DyePalette:SetEnable(false)
    self.btn_DyePalette:SetMonoTone(true)
  else
    self.btn_Manufacture:SetEnable(true)
    self.btn_Manufacture:SetMonoTone(false)
    self.btn_AlchemyStone:SetEnable(true)
    self.btn_AlchemyStone:SetMonoTone(false)
    self.btn_AlchemyFigureHead:SetEnable(true)
    self.btn_AlchemyFigureHead:SetMonoTone(false)
    if isGameTypeRussia() and (getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT or getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_OBT) then
      self.btn_DyePalette:SetEnable(false)
      self.btn_DyePalette:SetMonoTone(true)
    else
      self.btn_DyePalette:SetEnable(true)
      self.btn_DyePalette:SetMonoTone(false)
    end
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    if true == Panel_Npc_Dialog:GetShow() and nil == dialog_getTalker() then
      Inventory_RePosition()
    end
  elseif true == Panel_Npc_Dialog_All:GetShow() and nil == dialog_getTalker() then
    Inventory_RePosition()
  end
  PaGlobalFunc_BetterEquipment_Close()
end
function Inventory_SlotLClick(index)
  local self = inven
  local slotNo = self.slots[index]._slotNo
  local inventoryType = Inventory_GetCurrentInventoryType()
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local inventory = selfProxy:getInventory()
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfProxy:getInventorySlotCount(not self.radioButtonNormaiInven:IsChecked())
  if Panel_Chatting_Input:IsShow() and isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
    local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
    if nil == itemWrapper then
      return
    end
    local focusEdit = GetFocusEdit()
    if ChatInput_CheckCurrentUiEdit(focusEdit) then
      FGlobal_ChattingInput_LinkedItemByInventory(slotNo, inventoryType)
    end
  elseif isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
    if (isGameTypeJapan() or isGameTypeRussia()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
      return
    end
    if getSelfPlayer():isInstancePlayer() then
      local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
      if not itemWrapper then
        return
      end
      if itemWrapper:getStaticStatus():isStackable() then
        Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, Inventory_ProcessThrowItem)
      else
        Inventory_ProcessThrowItem(1, slotNo)
      end
      return
    end
    local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
    if nil ~= itemWrapper then
      Note_On(itemWrapper:get():getKey():getItemKey())
    end
  elseif invenUseSize - useStartSlot - self.startSlotIndex == index then
    audioPostEvent_SystemUi(0, 0)
    PaGlobal_EasyBuy:Open(5)
  end
end
function Inventory_ProcessThrowItem(count, slotNo)
  ToClient_Inventory_ThrowItem(slotNo, count)
end
function getInventory_RealSlotNo(index)
  local self = inven
  if nil == self.slots[index] then
    return index
  end
  local realSlotNo = self.slots[index]._slotNo
  return realSlotNo
end
function Inventory_SlotRClick(index, equipSlotNo)
  if Panel_Win_System:GetShow() then
    return
  end
  if true == openWhereIs then
    return
  end
  local self = inven
  local slotNo = self.slots[index]._slotNo
  local whereType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemName = itemWrapper:getStaticStatus():getName()
  local isCash = itemWrapper:isCash()
  if isKeyPressed(CppEnums.VirtualKeyCode.KeyCode_SHIFT) then
    if isCash then
      return
    end
    if not isItemLock then
      return
    end
    if true == _ContentsGroup_RenewUI_Dailog then
      if PaGlobalFunc_MainDialog_IsShow() then
        return
      end
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      if Panel_Npc_Dialog:IsShow() then
        return
      end
    elseif Panel_Npc_Dialog_All:IsShow() then
      return
    end
    if Panel_Window_ItemMarket_Function:GetShow() or Panel_Window_ItemMarket_RegistItem:GetShow() or Panel_Window_Repair:GetShow() then
      return
    end
    if false == itemWrapper:getStaticStatus():isStackable() and false == itemWrapper:isSoulCollector() then
      if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
        ToClient_Inventory_RemoveItemLock(slotNo)
        Proc_ShowMessage_Ack("[" .. itemName .. "] " .. PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ITEMUNLOCK"))
      else
        ToClient_Inventory_InsertItemLock(slotNo)
        Proc_ShowMessage_Ack("[" .. itemName .. "] " .. PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ITEMLOCK"))
      end
    elseif ToClient_Inventory_CheckItemLock(slotNo, whereType) then
      ToClient_Inventory_RemoveItemLock(slotNo)
      Proc_ShowMessage_Ack("[" .. itemName .. "] " .. PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ITEMUNLOCK"))
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_CANNOT_ITEMLOCK"))
    end
    Inventory_updateSlotData()
  else
    Inventory_SlotRClickXXX(slotNo, equipSlotNo, index)
  end
end
function Inventory_SlotRClickXXX(slotNo, equipSlotNo, index)
  local self = inven
  local selfProxy = getSelfPlayer():get()
  local inventoryType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if nil ~= itemWrapper then
    local itemEnchantWrapper = itemWrapper:getStaticStatus()
    local itemStatic = itemWrapper:getStaticStatus():get()
    Inventory_DropEscape()
    if selfProxy:doRideMyVehicle() and itemStatic:isUseToVehicle() then
      inventoryUseItem(inventoryType, slotNo, equipSlotNo, false)
      return
    end
    if Panel_Window_StableStallion:GetShow() then
      local itemMaxCount = FGlobal_MaxItemCount(slotNo)
      if nil ~= itemMaxCount then
        if itemMaxCount < Int64toInt32(itemWrapper:get():getCount_s64()) then
          Panel_NumberPad_Show(true, tonumber64(itemMaxCount), slotNo, Set_StallionItemSlot, nil, itemWrapper)
        else
          Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, Set_StallionItemSlot, nil, itemWrapper)
        end
      end
      return
    end
    if nil ~= self.rClickFunc then
      self.rClickFunc(slotNo, itemWrapper, itemWrapper:get():getCount_s64(), inventoryType)
      return
    end
    PaGlobal_TutorialManager:handleInventorySlotRClick(itemWrapper:get():getKey():getItemKey())
    PaGlobal_TutorialManager:handleInventorySlotRClickgetSlotNo(slotNo)
    if DragManager:isDragging() then
      DragManager:clearInfo()
    end
    if nil ~= Panel_Auction_Regist_Popup and Panel_Auction_Regist_Popup:GetShow() then
      if itemWrapper:getStaticStatus():isStackable() then
        Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, Auction_RegisterItemFromInventory)
      else
        Auction_RegisterItemFromInventory(1, slotNo)
      end
      return
    elseif nil ~= Panel_Housing_SettingVendingMachine and Panel_Housing_SettingVendingMachine:GetShow() then
      VendingMachine_RegisterItemFromInventory(slotNo, 1)
      return
    elseif nil ~= Panel_Housing_VendingMachineList and Panel_Housing_VendingMachineList:GetShow() then
      FGlobal_VendingMachineRegisterItemFromInventory(slotNo)
    elseif nil ~= Panel_Housing_ConsignmentSale and Panel_Housing_ConsignmentSale:GetShow() then
      FGlobal_ConsignmentRegisterItemFromInventory(itemWrapper:get():getCount_s64(), slotNo)
    elseif nil ~= Panel_Window_FairySetting and Panel_Window_FairySetting:GetShow() then
      PaGlobal_FairySetting_SetPortion(itemWrapper:get():getKey())
    elseif nil ~= Panel_FairyInfo and Panel_Window_FairyUpgrade:GetShow() then
      if true == itemWrapper:getStaticStatus():isStackable() then
        Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, PaGlobal_FairyUpgrade_RClickItemByNumberPad, false, itemWrapper:get():getKey())
      else
        PaGlobal_FairyUpgrade_RClickItem(itemWrapper:get():getKey(), slotNo, 1)
      end
    elseif false == _ContentsGroup_NewUI_Dialog_All and true == getAuctionState() then
      return
    elseif true == _ContentsGroup_NewUI_Dialog_All and true == PaGlobalFunc_DialogMain_All_GetAuctionState() then
      return
    elseif 2 == itemEnchantWrapper:get()._vestedType:getItemKey() and false == itemWrapper:get():isVested() then
      local function bindingItemUse()
        Inventory_UseItemTargetSelf(inventoryType, slotNo, equipSlotNo)
      end
      local messageContent
      if itemEnchantWrapper:isUserVested() then
        messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT_USERVESTED")
      else
        messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_CONTENT")
      end
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BINDING_ALERT_TITLE"),
        content = messageContent,
        functionYes = bindingItemUse,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    elseif eConnectUiType.eConnectUi_Undefined ~= itemWrapper:getStaticStatus():getConnectUi() then
      ConnectUI(itemWrapper:getStaticStatus():getConnectUi())
    elseif itemWrapper:getStaticStatus():getItemType() == 8 then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      audioPostEvent_SystemUi(0, 14)
      Panel_Invertory_Manufacture_BG:SetShow(true)
      Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "inventory", false, false)
      local row = math.floor((slotNo - 1) / inven.config.slotCols)
      local col = (slotNo - 1) % inven.config.slotCols
      Panel_Invertory_Manufacture_BG:SetPosX(self.slots[index].icon:GetParentPosX() - 42)
      Panel_Invertory_Manufacture_BG:SetPosY(self.slots[index].icon:GetParentPosY() + 42)
      local _btn_MenuSizeX = radioButtonManu:GetSizeX() + 23
      local _btn_MenuTextSizeX = _btn_MenuSizeX - _btn_MenuSizeX / 2 - radioButtonManu:GetTextSizeX() / 2
      local _btn_NoteSizeX = radioButtonNote:GetSizeX() + 23
      local _btn_NoteTextSizeX = _btn_NoteSizeX - _btn_NoteSizeX / 2 - radioButtonNote:GetTextSizeX() / 2
      radioButtonManu:SetTextSpan(_btn_MenuTextSizeX, 5)
      radioButtonNote:SetTextSpan(_btn_NoteTextSizeX, 5)
      radioButtonManu:SetPosX(4)
      radioButtonManu:SetPosY(4)
      radioButtonNote:SetPosX(4)
      radioButtonNote:SetPosY(38)
      if MiniGame_Manual_Value_FishingStart == true then
        radioButtonManu:SetEnable(false)
        radioButtonManu:SetMonoTone(true)
        radioButtonManu:SetAlpha(0.8)
      else
        radioButtonManu:SetEnable(true)
        radioButtonManu:SetMonoTone(false)
        radioButtonManu:SetAlpha(1)
      end
      radioButtonManu:addInputEvent("Mouse_LUp", "Manufacture_On(" .. slotNo .. ")")
      radioButtonNote:addInputEvent("Mouse_LUp", "Note_On(" .. itemWrapper:get():getKey():getItemKey() .. ")")
      radioButtonManu:addInputEvent("Mouse_RUp", "Manufacture_Off()")
      radioButtonNote:addInputEvent("Mouse_RUp", "Manufacture_Off()")
      radioButtonNote:addInputEvent("Mouse_Out", "Manufacture_Off()")
      radioButtonManu:addInputEvent("Mouse_Out", "Manufacture_Off()")
      Panel_Invertory_Manufacture_BG:addInputEvent("Mouse_Out", "Manufacture_Off()")
      return
    elseif itemEnchantWrapper:isPopupItem() then
      Panel_UserItem_PopupItem(itemEnchantWrapper, inventoryType, slotNo, equipSlotNo)
    elseif itemEnchantWrapper:isExchangeItemNPC() or itemWrapper:isSoulCollector() or 17 == itemWrapper:getStaticStatus():getItemType() then
      if nil == Panel_Invertory_ExchangeButton then
        UI.ASSERT_NAME(nil ~= Panel_Invertory_ExchangeButton, "Panel_Invertory_ExchangeButton \237\140\168\235\132\144\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
        return
      end
      Panel_Invertory_ExchangeButton:SetShow(true)
      Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "inventory", false, false)
      local row = math.floor((slotNo - 1) / inven.config.slotCols)
      local col = (slotNo - 1) % inven.config.slotCols
      Panel_Invertory_ExchangeButton:SetPosX(self.slots[index].icon:GetParentPosX() - 42)
      Panel_Invertory_ExchangeButton:SetPosY(self.slots[index].icon:GetParentPosY() + 42)
      local _btn_WayPointSizeX = _btn_WayPoint:GetSizeX() + 23
      local _btn_WayPointTextSizeX = _btn_WayPointSizeX - _btn_WayPointSizeX / 2 - _btn_WayPoint:GetTextSizeX() / 2
      local _btn_WidgetSizeX = _btn_Widget:GetSizeX() + 23
      local _btn_WidgetTextSizeX = _btn_WidgetSizeX - _btn_WidgetSizeX / 2 - _btn_Widget:GetTextSizeX() / 2
      _btn_WayPoint:SetTextSpan(_btn_WayPointTextSizeX, 5)
      _btn_Widget:SetTextSpan(_btn_WidgetTextSizeX, 5)
      _btn_WayPoint:SetPosX(4)
      _btn_WayPoint:SetPosY(4)
      _btn_Widget:SetPosX(4)
      _btn_Widget:SetPosY(38)
      if itemWrapper:isSoulCollector() then
        Panel_Invertory_ExchangeButton:SetSize(162, 40)
        _btn_WayPoint:SetShow(false)
        _btn_Widget:SetPosY(4)
      else
        Panel_Invertory_ExchangeButton:SetSize(162, 74)
        _btn_WayPoint:SetShow(true)
        _btn_Widget:SetPosY(38)
      end
      local waypointX = Panel_Invertory_ExchangeButton:GetPosX() + _btn_WayPoint:GetSizeX()
      local waypointY = Panel_Invertory_ExchangeButton:GetPosY() + _btn_WayPoint:GetSizeY() + _btn_Widget:GetSizeY()
      local screenSizeX = getScreenSizeX()
      local screenSizeY = getScreenSizeY()
      if waypointX > screenSizeX then
        Panel_Invertory_ExchangeButton:SetPosX(self.slots[index].icon:GetParentPosX() - 140)
      end
      if waypointY > screenSizeY then
        Panel_Invertory_ExchangeButton:SetPosY(self.slots[index].icon:GetParentPosY() - 70)
      end
      if 17 == itemWrapper:getStaticStatus():getItemType() then
        _btn_WayPoint:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INVENTORY_USELESSITEM_WAYPOINT_BTN"))
        _btn_WayPoint:addInputEvent("Mouse_LUp", "HandleClicked_TownNpcIcon_NaviStart(16,false)")
      else
        _btn_WayPoint:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INVENTORY_EXCHANGE_WAYPOINT_BTN"))
        _btn_WayPoint:addInputEvent("Mouse_LUp", "HandleClickedWayPoint( " .. slotNo .. " )")
      end
      _btn_WayPoint:addInputEvent("Mouse_Out", "ExchangeButton_Off()")
      _btn_Widget:addInputEvent("Mouse_Out", "ExchangeButton_Off()")
      _btn_Widget:addInputEvent("Mouse_LUp", "HandleClickedWidget( " .. slotNo .. " )")
      Panel_Invertory_ExchangeButton:addInputEvent("Mouse_Out", "ExchangeButton_Off()")
    elseif not itemStatic:isUseToVehicle() then
      local function useTradeItem()
        Inventory_UseItemTargetSelf(inventoryType, slotNo, equipSlotNo)
      end
      local itemSSW = itemWrapper:getStaticStatus()
      local item_type = itemSSW:getItemType()
      if 2 == item_type and true == itemSSW:get():isForJustTrade() then
        local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TRADEITEMUSE_CONTENT")
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TRADEITEMUSE_TITLE"),
          content = messageContent,
          functionYes = useTradeItem,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
      else
        local equipType = itemWrapper:getStaticStatus():getEquipType()
        if 16 == equipType or 17 == equipType then
          local accSlotNo = FGlobal_AccSlotNo(itemWrapper, true)
          Inventory_UseItemTargetSelf(inventoryType, slotNo, accSlotNo)
        else
          Inventory_UseItemTargetSelf(inventoryType, slotNo, equipSlotNo)
        end
      end
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_CANT_USEITEM"))
    end
  end
end
function FGlobal_WhereUseItemExecute()
  WhereUseItemDirectionUpdate(whereUseItemSSW, whereUseItemSlotNo)
end
function FindExchangeItemNPC(itemSSW)
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local selfPosition = float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
  local itemKey = itemSSW:get()._key:get()
  local npcPosition = {}
  local minIndex = 0
  local minDistance = 0
  ToClient_DeleteNaviGuideByGroup(0)
  local count = itemSSW:getExchangeItemNPCInfoListCount()
  for index = 0, count - 1 do
    local spawnData = npcByCharacterKey_getNpcInfo(itemSSW:getCharacterKeyByIdx(index), itemSSW:getDialogIndexByIdx(index))
    if nil ~= spawnData then
      local npcPos = spawnData:getPosition()
      npcPosition[index] = npcPos
      local distance = Util.Math.calculateDistance(selfPosition, npcPos)
      if 0 == index then
        minDistance = distance
      elseif distance < minDistance then
        minIndex = index
        minDistance = distance
      end
    end
  end
  for ii = 0, count - 1 do
    if ii ~= minIndex and nil ~= npcPosition[ii] then
      worldmapNavigatorStart(float3(npcPosition[ii].x, npcPosition[ii].y, npcPosition[ii].z), NavigationGuideParam(), false, false, true)
    end
  end
  if nil ~= npcPosition[minIndex] then
    worldmapNavigatorStart(float3(npcPosition[minIndex].x, npcPosition[minIndex].y, npcPosition[minIndex].z), NavigationGuideParam(), false, false, true)
  end
  audioPostEvent_SystemUi(0, 14)
  selfProxy:setCurrentFindExchangeItemEnchantKey(itemKey)
end
function Inventory_FindExchangeItemNPC(slotNo)
  local selfProxy = getSelfPlayer():get()
  if nil == selfProxy then
    return
  end
  local inventory = selfProxy:getInventory()
  if not inventory:empty(slotNo) then
    local itemWrapper = getInventoryItem(slotNo)
    if nil == itemWrapper then
      return
    end
    local itemSSW = itemWrapper:getStaticStatus()
    if nil == itemSSW then
      return
    end
    FindExchangeItemNPC(itemSSW)
  end
end
function FromClient_FindExchangeItemNPC()
  local itemEnchantKey = getSelfPlayer():get():getCurrentFindExchangeItemEnchantKey()
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  if nil == itemSSW then
    return
  end
  FindExchangeItemNPC(itemSSW)
end
function Manufacture_On(slotNo)
  if Panel_Manufacture:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
    return
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_LOCALWAR_ALERT"))
    return
  end
  Panel_Invertory_Manufacture_BG:SetShow(false)
  Manufacture_Show(nil, CppEnums.ItemWhereType.eInventory, true)
  Manufacture_Off()
end
function Note_On(itemKey)
  ProductNote_Item_ShowToggle(itemKey)
  Panel_Invertory_Manufacture_BG:SetShow(false)
  Manufacture_Off()
end
function Manufacture_Off()
  local panelPosX = Panel_Invertory_Manufacture_BG:GetPosX()
  local panelPosY = Panel_Invertory_Manufacture_BG:GetPosY()
  local panelSizeX = Panel_Invertory_Manufacture_BG:GetSizeX()
  local panelSizeY = Panel_Invertory_Manufacture_BG:GetSizeY()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  if panelPosX <= mousePosX and mousePosX <= panelPosX + panelSizeX and panelPosY <= mousePosY and mousePosY <= panelPosY + panelSizeY then
    return
  end
  Panel_Invertory_Manufacture_BG:SetShow(false)
end
function HandleClickedWayPoint(slotNo)
  Inventory_FindExchangeItemNPC(slotNo)
  Panel_Invertory_ExchangeButton:SetShow(false)
end
function HandleClickedWidget(slotNo)
  local inventoryType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  local itemSSW = itemWrapper:getStaticStatus()
  whereUseItemSlotNo = slotNo
  whereUseItemSSW = itemSSW
  FGlobal_WhereUseITemDirectionOpen(itemSSW, slotNo)
  Panel_Invertory_ExchangeButton:SetShow(false)
end
function HandleClicked_Inventory_FairyFeed_Open()
  if not inven.radioButtonNormaiInven:IsCheck() then
    inven.radioButtonNormaiInven:SetCheck(true)
    inven.radioButtonCashInven:SetCheck(false)
    inven.radioButtonInstanceInven:SetCheck(false)
    Inventory_Tab()
  end
end
function HandleClicked_Inventory_WeakenEnchant_Open()
  if not inven.radioButtonNormaiInven:IsCheck() then
    inven.radioButtonNormaiInven:SetCheck(true)
    inven.radioButtonCashInven:SetCheck(false)
    inven.radioButtonInstanceInven:SetCheck(false)
    Inventory_Tab()
  end
end
function HandleClicked_Inventory_FairySetting_Open()
  if not inven.radioButtonNormaiInven:IsCheck() then
    inven.radioButtonNormaiInven:SetCheck(true)
    inven.radioButtonCashInven:SetCheck(false)
    inven.radioButtonInstanceInven:SetCheck(false)
    Inventory_Tab()
  end
end
function HandleClicked_Inventory_Palette_Open()
  if not inven.radioButtonCashInven:IsCheck() then
    inven.radioButtonNormaiInven:SetCheck(false)
    inven.radioButtonCashInven:SetCheck(true)
    inven.radioButtonInstanceInven:SetCheck(false)
    Inventory_Tab()
  end
  FGlobal_DyePalette_Open()
end
function PaGlobalFunc_InventoryInfo_GetShow()
  return Panel_Window_Inventory:GetShow()
end
function FGlobal_CashInventoryOpen_ByEnchant()
  if not inven.radioButtonCashInven:IsCheck() then
    inven.radioButtonNormaiInven:SetCheck(false)
    inven.radioButtonCashInven:SetCheck(true)
    inven.radioButtonInstanceInven:SetCheck(false)
    Inventory_Tab()
  end
end
function HandleClicked_Inventory_ItemDelete()
  if DragManager:isDragging() and Panel_Window_Inventory == DragManager.dragStartPanel then
    local slotNo = DragManager.dragSlotInfo
    local whereType = Inventory_GetCurrentInventoryType()
    local itemWrapper = getInventoryItemByType(whereType, slotNo)
    if nil == itemWrapper then
      return
    end
    local itemCount = itemWrapper:get():getCount_s64()
    if Defines.s64_const.s64_1 == itemCount then
      Inventory_ItemDelete_Check(Defines.s64_const.s64_1, slotNo, whereType)
    else
      Panel_NumberPad_Show(true, itemCount, slotNo, Inventory_ItemDelete_Check, nil, whereType)
    end
  end
end
function ExchangeButton_Off()
  local panelPosX = Panel_Invertory_ExchangeButton:GetPosX()
  local panelPosY = Panel_Invertory_ExchangeButton:GetPosY()
  local panelSizeX = Panel_Invertory_ExchangeButton:GetSizeX()
  local panelSizeY = Panel_Invertory_ExchangeButton:GetSizeY()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  if panelPosX <= mousePosX and mousePosX <= panelPosX + panelSizeX and panelPosY <= mousePosY and mousePosY <= panelPosY + panelSizeY then
    return
  end
  Panel_Invertory_ExchangeButton:SetShow(false)
end
local deleteWhereType, deleteSlotNo, itemCount, itemName
function Inventory_GroundClick(whereType, slotNo)
  if false == Panel_Window_Inventory:GetShow() or Panel_Win_System:GetShow() then
    return
  end
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return
  end
  itemCount = itemWrapper:get():getCount_s64()
  itemName = itemWrapper:getStaticStatus():getName()
  if Defines.s64_const.s64_1 == itemCount then
    Inventory_GroundClick_Message(Defines.s64_const.s64_1, slotNo, whereType)
  elseif isUseNewQuickSlot() then
    Inventory_GroundClick_Message(Defines.s64_const.s64_1, slotNo, whereType)
  else
    Panel_NumberPad_Show(true, itemCount, slotNo, Inventory_GroundClick_Message, nil, whereType)
  end
end
function Inventory_GetToopTipItem()
  local self = inven
  if nil == self._tooltipWhereType then
    return nil
  end
  if nil == self._tooltipSlotNo then
    return nil
  end
  return (getInventoryItemByType(self._tooltipWhereType, self._tooltipSlotNo))
end
function Inventory_GetToolTipItemSlotNo()
  local self = inven
  if nil == self._tooltipWhereType then
    return nil
  end
  if nil == self._tooltipSlotNo then
    return nil
  end
  return self._tooltipSlotNo
end
function Inventory_IconOver(index)
  local self = inven
  local slotNo = self.slots[index]._slotNo
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if slotNo < self.config.slotCount then
    self.slotEtcData[slotNo].isFirstItem = false
    if nil ~= effectScene.newItem[slotNo] then
      self.slots[index].icon:EraseEffect(effectScene.newItem[slotNo])
    end
  end
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:get():getInventorySlotCount(not self.radioButtonNormaiInven:IsChecked())
  if invenUseSize - useStartSlot - self.startSlotIndex == index and not isGameTypeGT() then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ADDINVENTORY_TOOLTIP_NAME")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ADDINVENTORY_TOOLTIP_DESC")
    local control = self.slots[index].icon
    TooltipSimple_Show(control, name, desc)
    return
  end
  if nil ~= over_SlotEffect then
    self.slots[index].icon:EraseEffect(over_SlotEffect)
  end
  over_SlotEffect = self.slots[index].icon:AddEffect("UI_Inventory_EmptySlot", false, 0, 0)
  self._tooltipWhereType = Inventory_GetCurrentInventoryType()
  self._tooltipSlotNo = slotNo
  Panel_Tooltip_Item_Show_GeneralNormal(index, "inventory", true, false)
end
function Inventory_IconOut(index)
  local self = inven
  if nil ~= over_SlotEffect then
    inven.slots[index].icon:EraseEffect(over_SlotEffect)
  end
  self._tooltipWhereType = nil
  self._tooltipSlotNo = nil
  Panel_Tooltip_Item_Show_GeneralNormal(index, "inventory", false, false)
  TooltipSimple_Hide()
end
function Inventory_GetFirstItemCount()
  local aCount = 0
  local returnValue = 0
  for _, value in pairs(inven.slotEtcData) do
    if value.isFirstItem then
      aCount = aCount + 1
    end
  end
  return aCount
end
function Inventory_GroundClick_Message(s64_itemCount, slotNo, whereType)
  if restrictedActionForUseItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REMOVEITEM"))
    return false
  end
  deleteWhereType = whereType
  deleteSlotNo = slotNo
  itemCount = s64_itemCount
  if true == isNearFusionCore() then
    local luaPushItemToCampfireMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_PUSHITEMTOCAMPFIRE_MSG", "itemName", itemName, "itemCount", tostring(itemCount))
    local luaBurn = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_BURN")
    local messageContent = luaPushItemToCampfireMsg
    local messageboxData = {
      title = luaBurn,
      content = messageContent,
      functionYes = Inventory_BurnItemToActor_Yes,
      functionNo = Inventory_Delete_No,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif isUseNewQuickSlot() then
    FGlobal_SetNewQuickSlot_ByGroundClick(s64_itemCount, slotNo, whereType)
  else
    local luaDeleteItemMsg = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_ONLYTRASH_INVENTORY")
    local luaDelete = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
    local messageContent = luaDeleteItemMsg
    local messageboxData = {
      title = luaDelete,
      content = messageContent,
      functionYes = Inventory_Delete_No,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function Inventory_ItemDelete_Check(count, slotNo, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  local itemName = itemWrapper:getStaticStatus():getName()
  deleteWhereType = whereType
  deleteSlotNo = slotNo
  itemCount = count
  DragManager:clearInfo()
  if Panel_Manufacture:IsShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_MANUFACTURE_REMOVE"))
    return
  end
  local luaDeleteItemMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_MSG", "itemName", itemName, "itemCount", tostring(count))
  local luaDelete = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETE")
  local itemExpiration = itemWrapper:getExpirationDate()
  if nil ~= itemExpiration and false == itemExpiration:isIndefinite() then
    local s64_remainTime = getLeftSecond_s64(itemExpiration)
    if Defines.s64_const.s64_0 ~= s64_remainTime then
      luaDeleteItemMsg = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DELETEITEM_PERIOD_MSG", "itemName", itemName, "itemCount", tostring(count))
    end
  end
  local messageContent = luaDeleteItemMsg
  local messageboxData = {
    title = luaDelete,
    content = messageContent,
    functionYes = Inventory_Delete_Yes,
    functionNo = Inventory_Delete_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Inventory_Delete_Yes()
  if deleteSlotNo == nil then
    return
  end
  local itemWrapper = getInventoryItemByType(deleteWhereType, deleteSlotNo)
  if nil == itemWrapper then
    return
  end
  if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemWrapper:getStaticStatus():get():getContentsEventType() then
    local bagType = itemWrapper:getStaticStatus():getContentsEventParam1()
    local bagSize = itemWrapper:getStaticStatus():getContentsEventParam2()
    local isEmptyBag = false
    for index = 0, bagSize - 1 do
      local bagItemWrapper = getInventoryBagItemByType(deleteWhereType, deleteSlotNo, index)
      if nil ~= bagItemWrapper then
        if CppEnums.InventoryBagType.eInventoryBagType_Cash == bagType then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_DELETEITEM_ALERT"))
        elseif CppEnums.InventoryBagType.eInventoryBagType_Equipment == bagType then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_DELETEITEM_ALERT2"))
        else
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_DELETEITEM_ALERT3"))
        end
        DragManager:clearInfo()
        Inventory_DropEscape()
        return
      end
    end
  end
  if itemWrapper:isCash() then
    PaymentPassword(Inventory_Delete_YesXXX)
    return
  end
  Inventory_Delete_YesXXX()
  PaGlobal_TutorialManager:handleInventoryDelete(itemWrapper, deleteWhereType, deleteSlotNo)
end
function Inventory_Delete_YesXXX()
  if deleteSlotNo == nil then
    return
  end
  deleteItem(getSelfPlayer():getActorKey(), deleteWhereType, deleteSlotNo, itemCount)
  Inventory_DropEscape()
  DragManager:clearInfo()
end
function Inventory_BurnItemToActor_Yes()
  if deleteSlotNo ~= nil then
    burnItemToActor(deleteWhereType, deleteSlotNo, itemCount)
  end
end
function Inventory_Delete_No()
  deleteWhereType = nil
  deleteSlotNo = nil
  Inventory_DropEscapeAlert()
  DragManager:clearInfo()
end
local inventoryDragNoUseList
function FGlobal_SetInventoryDragNoUse(pPanel)
  inventoryDragNoUseList = pPanel
end
function Inventory_SlotDrag(index)
  local self = inven
  local slotNo = self.slots[index]._slotNo
  if nil ~= inventoryDragNoUseList and inventoryDragNoUseList:IsShow() then
    return
  end
  if true == openWhereIs then
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  if false == _ContentsGroup_NewUI_BlackSmith_All then
    if true == Panel_Window_Extraction_Caphras:GetShow() then
      return
    end
  elseif true == Panel_Window_Extraction_Caphras_All:GetShow() then
    return
  end
  local whereType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    icon_TrashOn:SetShow(false)
    icon_TrashSequence:SetShow(false)
    return
  end
  if nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    local itemType = itemSSW:getItemType()
    local isTradeItem = itemSSW:isTradeAble()
    local isEquip = itemSSW:get():isEquipable()
    DragManager:setDragInfo(Panel_Window_Inventory, whereType, slotNo, "Icon/" .. itemWrapper:getStaticStatus():getIconPath(), Inventory_GroundClick, getSelfPlayer():getActorKey())
    if itemWrapper:getStaticStatus():get():isItemSkill() or itemWrapper:getStaticStatus():get():isUseToVehicle() or true == isEquip then
      QuickSlot_ShowBackGround()
    end
    Item_Move_Sound(itemWrapper)
  end
end
function Inventory_ShowToggle()
  Inventory_SetShow(not Panel_Window_Inventory:GetShow())
end
function inven:registEventHandler()
  self.buttonClose:addInputEvent("Mouse_LUp", "HandleClicked_InventoryWindow_Close()")
  self.buttonMoney:addInputEvent("Mouse_LUp", "InventoryWindow_PopMoney()")
  self.checkButton_Sort:addInputEvent("Mouse_LUp", "Inventory_SetSorted()")
end
function Inventory_SetCheckRadioButtonNormalInventory(bCheck)
  local self = inven
  self.radioButtonNormaiInven:SetCheck(bCheck)
  local selfPlayer = getSelfPlayer()
  if selfPlayer:isInstancePlayer() then
    self.radioButtonInstanceInven:SetCheck(true)
  else
    self.radioButtonInstanceInven:SetCheck(false)
  end
end
function Inventory_SetSorted()
  local self = inven
  local bSorted = self.checkButton_Sort:IsCheck()
  ToClient_SetSortedInventory(bSorted)
  Inventory_updateSlotData()
end
function InventoryWindow_PopMoney()
  if not Panel_Window_Warehouse:GetShow() and not PaGlobalFunc_ServantInventory_GetShow() then
    inven.buttonMoney:SetEnable(false)
    return
  end
  local self = inven
  local whereType = CppEnums.ItemWhereType.eInventory
  local slotNo = getMoneySlotNo()
  FGlobal_PopupMoveItem_Init(whereType, slotNo, CppEnums.MoveItemToType.Type_Player, getSelfPlayer():getActorKey(), true)
end
function Inventory_UpdatePerFrame(fDeltaTime)
  if fDeltaTime <= 0 then
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local self = inven
  local useStartSlot = inventorySlotNoUserStart()
  local currentWhereType = Inventory_GetCurrentInventoryType()
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    local slotNo = slot._slotNo
    local remainTime = 0
    local itemReuseTime = 0
    local realRemainTime = 0
    local intRemainTime = 0
    if UI_TISNU ~= slotNo then
      remainTime = getItemCooltime(currentWhereType, slotNo)
      itemReuseTime = getItemReuseCycle(currentWhereType, slotNo) / 1000
      realRemainTime = remainTime * itemReuseTime
      intRemainTime = realRemainTime - realRemainTime % 1 + 1
    end
    if remainTime > 0 then
      slot.cooltime:UpdateCoolTime(remainTime)
      slot.cooltime:SetShow(true)
      slot.cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      if itemReuseTime >= intRemainTime then
        slot.cooltimeText:SetShow(true)
      else
        slot.cooltimeText:SetShow(false)
      end
    elseif slot.cooltime:GetShow() then
      slot.cooltime:SetShow(false)
      slot.cooltimeText:SetShow(false)
      local skillSlotItemPosX = slot.cooltime:GetParentPosX()
      local skillSlotItemPosY = slot.cooltime:GetParentPosY()
      audioPostEvent_SystemUi(2, 1)
      Panel_Inventory_CoolTime_Effect_Item_Slot:SetShow(true, true)
      Panel_Inventory_CoolTime_Effect_Item_Slot:AddEffect("UI_Button_Hide", false, 2.5, 7)
      Panel_Inventory_CoolTime_Effect_Item_Slot:AddEffect("fUI_Button_Hide", false, 2.5, 7)
      Panel_Inventory_CoolTime_Effect_Item_Slot:SetPosX(skillSlotItemPosX - 7)
      Panel_Inventory_CoolTime_Effect_Item_Slot:SetPosY(skillSlotItemPosY - 10)
    end
  end
end
function Inventory_ItemComparer(ii, jj)
  return Global_ItemComparer(ii, jj, getInventoryItemByType, Inventory_GetCurrentInventoryType())
end
local _filter_for_NormalTab = function(slotNo, itemWrapper)
  return false
end
local _filter_for_TradeTab = function(slotNo, itemWrapper)
  if nil ~= itemWrapper then
    return not itemWrapper:getStaticStatus():get():isForJustTrade()
  else
    return true
  end
end
local _filter_for_HousingTab = function(slotNo, itemWrapper)
  if nil ~= itemWrapper then
    return not itemWrapper:getStaticStatus():get():isItemInstallation()
  else
    return true
  end
end
local _filter_for_HousingConsignmentSaleManager = function(slotNo, itemWrapper)
  if nil ~= itemWrapper then
    return not isRegistrableItem(slotNo, itemWrapper)
  else
    return true
  end
end
function isRegistrableItem(slotNo, itemWrapper)
  if itemWrapper:get():isVested() or false == itemWrapper:getExpirationDate():isIndefinite() then
    return false
  end
  return ToClient_IsRegistrableItem(slotNo)
end
function FGlobal_UpdateInventorySlotData()
  Inventory_updateSlotData()
end
local _lookAtMe = UI.getChildControl(Panel_fieldQuest, "Static_LookAtMe")
local _exchangeSlotNo = {}
local _exchangeIndex = -1
function Inventory_AddEffect_While_Exchange(invenSlotNo)
  if tradePC_GetMyLock() then
    return
  end
  if _exchangeIndex < 0 then
    _exchangeIndex = _exchangeIndex + 1
  end
  for i = 0, _exchangeIndex do
    if nil == _exchangeSlotNo[i] then
      _exchangeSlotNo[i] = invenSlotNo
      Inventory_updateSlotData()
      return
    end
  end
  _exchangeIndex = _exchangeIndex + 1
  _exchangeSlotNo[_exchangeIndex] = invenSlotNo
  Inventory_updateSlotData()
end
function Inventory_EraseEffect_While_Exchange(exchangeIndex)
  if tradePC_GetMyLock() then
    return
  end
  _exchangeSlotNo[exchangeIndex] = nil
  Inventory_updateSlotData()
end
function Inventory_Filter_Init()
  for i = _exchangeIndex, -1, -1 do
    _exchangeSlotNo[i] = nil
  end
  _exchangeIndex = -1
end
function Inventory_IsCurrentNormalInventoryType()
  local self = inven
  return (self.radioButtonNormaiInven:IsChecked())
end
function Inventory_IsCurrentCashInventoryType()
  local self = inven
  return (self.radioButtonCashInven:IsChecked())
end
function Inventory_GetCurrentInventoryType()
  local self = inven
  if Inventory_IsCurrentNormalInventoryType() then
    return CppEnums.ItemWhereType.eInventory
  elseif Inventory_IsCurrentCashInventoryType() then
    return CppEnums.ItemWhereType.eCashInventory
  else
    return CppEnums.ItemWhereType.eInstanceInventory
  end
  return CppEnums.ItemWhereType.eInventory
end
function Inventory_GetCurrentInventory()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return nil
  end
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventoryByType(Inventory_GetCurrentInventoryType())
  return inventory
end
local isFirstSummonItemUse = false
local isNormalInven = true
local isValuePackageItemUse = false
function Inventory_updateSlotData(isLoad)
  if true == _ContentsGroup_InvenUpdateCheck and nil == isLoad and false == Panel_Window_Inventory:GetShow() then
    return
  end
  local self = inven
  local selfPlayerWrapper = getSelfPlayer()
  local classType = selfPlayerWrapper:getClassType()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayer = selfPlayerWrapper:get()
  isFirstSummonItemUse = false
  isValuePackageItemUse = false
  local money = Defines.s64_const.s64_0
  local pearl = Defines.s64_const.s64_0
  local mileage = Defines.s64_const.s64_0
  local moneyItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, getMoneySlotNo())
  if nil ~= moneyItemWrapper then
    money = moneyItemWrapper:get():getCount_s64()
  end
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    pearl = pearlItemWrapper:get():getCount_s64()
  end
  local mileagelItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo())
  if nil ~= mileagelItemWrapper then
    mileage = mileagelItemWrapper:get():getCount_s64()
  end
  self.staticMoney:SetText(makeDotMoney(money))
  self.valuePearl:SetText(makeDotMoney(pearl))
  self.valueMileage:SetText(makeDotMoney(mileage))
  local isMoneyTextPosX = self.staticMoney:GetPosX()
  local isMoneyTextSize = self.staticMoney:GetTextSizeX()
  local isPearlIconPosX = self.buttonPearl:GetPosX()
  if isPearlIconPosX <= isMoneyTextPosX + isMoneyTextSize then
    self.buttonPearl:SetPosX(isMoneyTextPosX + isMoneyTextSize)
    self.valuePearl:SetPosXY(self.buttonPearl:GetPosX() + self.buttonPearl:GetSizeX(), 6)
  else
    self.buttonPearl:SetPosX(130)
    self.valuePearl:SetPosXY(160, 6)
  end
  _Inventory_updateSlotData_ChangeSilverIcon(money)
  local _const = Defines.s64_const
  FGlobal_UpdateInventoryWeight()
  local playerLevel = getSelfPlayer():get():getLevel()
  local isNormalInventory = self.radioButtonNormaiInven:IsChecked()
  isNormalInven = isNormalInventory
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:getInventorySlotCount(not isNormalInventory)
  local inventory = Inventory_GetCurrentInventory()
  local invenMaxSize = inventory:sizeXXX()
  local currentWhereType = Inventory_GetCurrentInventoryType()
  UIScroll.SetButtonSize(self._scroll, self.config.slotCount, invenMaxSize - useStartSlot)
  self._scroll:SetShow(true)
  local freeCount = inventory:getFreeCount()
  local fontColor
  local leftCountPercent = (invenUseSize - freeCount - useStartSlot) / (invenUseSize - useStartSlot) * 100
  if leftCountPercent >= 100 then
    fontColor = "<PAColor0xFFF03838>"
  elseif leftCountPercent > 90 then
    fontColor = "<PAColor0xFFFF8957>"
  else
    fontColor = "<PAColor0xFFFFF3AF>"
  end
  self.staticCapacity:SetText(fontColor .. tostring(invenUseSize - freeCount - useStartSlot) .. "/" .. tostring(invenUseSize - useStartSlot) .. "<PAOldColor>")
  local slotNoList = Array.new()
  slotNoList:fill(useStartSlot, invenMaxSize - 1)
  if self.checkButton_Sort:IsCheck() then
    local sortList = Array.new()
    sortList:fill(useStartSlot, invenUseSize - 1)
    sortList:quicksort(Inventory_ItemComparer)
    for ii = 1, invenUseSize - 2 do
      slotNoList[ii] = sortList[ii]
    end
  end
  for ii = 0, self.config.slotCount - 1 do
    local slot = self._slotsBackground[ii]
    slot.empty:SetShow(false)
    slot.lock:SetShow(false)
    slot.plus:SetShow(false)
    slot.onlyPlus:SetShow(false)
    if ii < invenUseSize - useStartSlot - self.startSlotIndex then
      slot.empty:SetShow(true)
    elseif ii == invenUseSize - useStartSlot - self.startSlotIndex then
      if not isGameTypeGT() then
        slot.lock:SetShow(true)
        if self.slots[ii].icon:GetShow() then
          slot.onlyPlus:SetShow(true)
          slot.lock:SetShow(false)
        else
          slot.plus:SetShow(true)
        end
        Panel_Window_Inventory:SetChildIndex(slot.plus, 15099)
        Panel_Window_Inventory:SetChildIndex(slot.onlyPlus, 15100)
      else
        slot.lock:SetShow(true)
      end
    else
      slot.lock:SetShow(true)
    end
  end
  local isFiltered = false
  local _mapaeBling = {}
  Panel_Inventory_isBlackStone_16001 = false
  Panel_Inventory_isBlackStone_16002 = false
  Panel_Inventory_isSocketItem = false
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectClear()
  end
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    slot:clearItem()
    slot.icon:SetEnable(true)
    slot.icon:SetMonoTone(true)
    slot.isEmpty = true
  end
  local fixEquipCheck = false
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    local slotNo = slotNoList[ii + 1 + self.startSlotIndex]
    slot._slotNo = slotNo
    slot.icon:EraseAllEffect()
    local row = math.floor(ii / self.config.slotCols)
    local col = ii % self.config.slotCols
    slot.icon:SetPosX(self.config.slotStartX + self.config.slotGapX * col)
    slot.icon:SetPosY(self.config.slotStartY + self.config.slotGapY * row)
    slot.bagIcon:SetShow(false)
    local itemExist = false
    local itemWrapper = getInventoryItemByType(currentWhereType, slotNo)
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper, slotNo)
      slot.isEmpty = false
      if nil ~= self.filterFunc then
        isFiltered = self.filterFunc(slotNo, itemWrapper, currentWhereType)
      end
      slot.icon:SetEnable(not isFiltered)
      slot.icon:SetMonoTone(isFiltered)
      slot.icon:SetIgnore(isFiltered)
      if isFiltered then
        slot.icon:SetAlpha(0.5)
        slot.icon:EraseAllEffect()
      else
        if nil ~= self.filterFunc then
          slot.icon:AddEffect("UI_Inventory_Filtering_NoOutline", true, 0, 0)
        end
        _Inventory_updateSlotData_AddEffectMapea(ii, slotNo)
      end
      itemExist = true
      Panel_Inventory_isBlackStone_16002 = _Inventory_updateSlotData_AddEffectBlackStone(ii, isFiltered, slotNo)
      local itemKey = itemWrapper:get():getKey():getItemKey()
      _Inventory_updateSlotData_AutoSetPotion(playerLevel, itemKey, currentWhereType, slotNo)
      PaGlobal_TutorialManager:handleUpdateInventorySlotData(slot, itemKey)
      if (42000 == itemKey or 42001 == itemKey or 41607 == itemKey or 42002 == itemKey or 42010 == itemKey or 42003 == itemKey or 42004 == itemKey or 42034 == itemKey or 42035 == itemKey or 42037 == itemKey or 42036 == itemKey or 42006 == itemKey or 42008 == itemKey or 42039 == itemKey or 42038 == itemKey or 42007 == itemKey or 42053 == itemKey or 41610 == itemKey or 42009 == itemKey or 42054 == itemKey or 42057 == itemKey or 42061 == itemKey or 42066 == itemKey or 42055 == itemKey or 42056 == itemKey or 42269 == itemKey or 42270 == itemKey or 42002 == itemKey or 42271 == itemKey or 42276 == itemKey or 42277 == itemKey or 42034 == itemKey or 42277 == itemKey or 42003 == itemKey or 42035 == itemKey or 42009 == itemKey or 41675 == itemKey or 42511 == itemKey or 42038 == itemKey or 42054 == itemKey or 41610 == itemKey or 42037 == itemKey or 42036 == itemKey or 42008 == itemKey or 42271 == itemKey or 42039 == itemKey or 42007 == itemKey) and true == PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() and not FGlobal_FirstSummonItemUse() then
        slot.icon:AddEffect("fUI_Tuto_ItemHp_01A", true, 0, 0)
      end
      if 42405 == itemKey and questList_hasProgressQuest(4015, 6) then
        slot.icon:AddEffect("fUI_Tuto_ItemHp_01A", true, 0, 0)
      end
      if (290033 == itemKey or 290034 == itemKey or 290035 == itemKey or 290036 == itemKey or 290037 == itemKey or 290038 == itemKey or 290039 == itemKey or 290040 == itemKey or 290041 == itemKey) and true == PaGlobal_ValuePackageTutorial_Manager:isDoingValuePackageTutorial() and not FGlobal_ValuePackagerItemUse() then
        slot.icon:AddEffect("fUI_Tuto_ItemHp_01A", true, 0, 0)
      end
      local itemSSW = itemWrapper:getStaticStatus()
      local item_type = itemSSW:getItemType()
      if item_type == 5 then
        Panel_Inventory_isSocketItem = true
      end
      local isSoulCollector = itemWrapper:isSoulCollector()
      local isCurrentSoulCount = itemWrapper:getSoulCollectorCount()
      local isMaxSoulCount = itemWrapper:getSoulCollectorMaxCount()
      local itemIconPath = itemWrapper:getStaticStatus():getIconPath()
      if isSoulCollector then
        slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
        if 0 == isCurrentSoulCount then
          slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
        end
        if isCurrentSoulCount > 0 then
          slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_1.dds")
        end
        if isCurrentSoulCount == isMaxSoulCount then
          slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_2.dds")
        end
        local x1, y1, x2, y2 = setTextureUV_Func(slot.icon, 0, 0, 42, 42)
        slot.icon:getBaseTexture():setUV(x1, y1, x2, y2)
        slot.icon:setRenderTexture(slot.icon:getBaseTexture())
      end
      local offencePoint = 0
      local defencePoint = 0
      local equipOffencePoint = 0
      local equipDefencePoint = 0
      local isEquip = itemWrapper:getStaticStatus():get():isEquipable()
      local matchEquip = false
      local isAccessory = false
      offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, isAccessory = _inventory_updateSlot_compareSpec(currentWhereType, slotNo, isAccessory)
      local currentEndurance = itemWrapper:get():getEndurance()
      local isUsableServant = itemWrapper:getStaticStatus():isUsableServant()
      if not isUsableServant and not Panel_Window_Exchange:GetShow() then
        if isEquip and nil ~= defencePoint and nil ~= offencePoint and currentEndurance > 0 and true == matchEquip and false == isAccessory and defencePoint + offencePoint > equipDefencePoint + equipOffencePoint then
          slot.icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
          local equipPos = itemWrapper:getStaticStatus():getEquipSlotNo()
          if false == _ContentsGroup_RemasterUI_Main_Alert then
            Panel_NewEquip_Update(equipPos)
          end
          PaGlobal_TutorialManager:handleNewEquipInInventory(slot)
        end
        if currentEndurance > 0 and true == matchEquip and true == isAccessory and offencePoint + defencePoint > equipOffencePoint + equipDefencePoint then
          slot.icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
          local equipPos = itemWrapper:getStaticStatus():getEquipSlotNo()
          if false == _ContentsGroup_RemasterUI_Main_Alert then
            Panel_NewEquip_Update(equipPos)
          end
        end
        if slotNo < self.config.slotCount and true == inven.slotEtcData[slotNo].isFirstItem and inven.slotEtcData[slotNo].itemKey == itemWrapper:get():getKey():getItemKey() then
          local newItemEffectSceneId = slot.icon:AddEffect("fUI_NewItem02", true, 0, 0)
          effectScene.newItem[slotNo] = newItemEffectSceneId
          UIMain_ItemUpdate()
        end
      end
      local isUsableClass
      if nil ~= itemSSW then
        if itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon() then
          isUsableClass = itemSSW:get()._usableClassType:isOn(classType)
        else
          isUsableClass = true
        end
      else
        isUsableClass = false
      end
      if false == isEquip then
        slot.icon:SetColor(UI_color.C_FFFFFFFF)
      elseif true == isUsableClass then
        slot.icon:SetColor(UI_color.C_FFFFFFFF)
      else
        slot.icon:SetColor(UI_color.C_FFD20000)
      end
      for iii = 0, _exchangeIndex do
        if Panel_Window_Exchange:GetShow() and slotNo == _exchangeSlotNo[iii] then
          slot.icon:SetColor(UI_color.C_FFD20000)
        elseif slotNo == _exchangeSlotNo[iii] and nil == _exchangeSlotNo[iii] then
          slot.icon:SetColor(UI_color.C_FFFFFFFF)
        end
      end
      local itemBindType = itemSSW:get()._vestedType:getItemKey()
      if Panel_Window_Exchange:GetShow() and itemBindType > 0 then
        slot.icon:SetColor(UI_color.C_FFD20000)
      end
    end
    equipDefencePoint = 0
    equipOffencePoint = 0
    defencePoint = 0
    offencePoint = 0
    if not itemExist then
      slot:clearItem()
      slot.icon:SetEnable(true)
      slot.icon:SetMonoTone(true)
      slot.icon:SetIgnore(false)
      slot.isEmpty = true
    end
  end
  for i = 0, invenUseSize - 1 do
    local slotNo = i + useStartSlot
    local itemWrapper = getInventoryItemByType(currentWhereType, slotNo)
    if nil ~= itemWrapper then
      local itemKey = itemWrapper:get():getKey():getItemKey()
      if Panel_FixEquip:GetShow() then
        PaGlobal_FixEquip:useCashBtnEffectDelete()
        if PaGlobal_FixEquip:isRepeatRepair() and false == itemWrapper:hasItemJewel() and not FixEquip_InvenFiler_SubItem(slotNo, itemWrapper, currentWhereType) and PaGlobal_FixEquip:isFixEquip_SubSlotItemKey() == itemKey and not fixEquipCheck then
          fixEquipCheck = true
          PaGlobal_FixEquip:fixEquipContinue(slotNo)
        end
      end
    end
  end
  PaGlobal_FixEquip:fGlobal_closeFix()
  if "QuickSlot" == Panel_Tooltip_Item_GetCurrentSlotType() then
    Panel_Tooltip_Item_Refresh()
  end
  Inven_FindPuzzle()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectLastUpdate()
    FGlobal_Inventory_WeightCheck()
  end
  if true == Panel_Window_Inventory:GetShow() then
    Panel_Tooltip_Item_Refresh()
  end
  if Panel_Window_Servant_GetShow() then
    Panel_Window_Servant_Update()
  end
  if Panel_IngameCashShop_EasyPayment:IsShow() then
    PaGlobal_EasyBuy:MyPearlUpdate()
    PaGlobal_EasyBuy:Update()
  end
  FGlobal_WhereUseItemExecute()
  PaGlobal_FixEquip:fixEquipMoneyUpdate()
  PaGlobal_Repair:repairMoneyUpdate()
  if false == _ContentsGroup_NewUI_RandomShop_All then
    FGlobal_ItemRandom_Money_Update()
  else
    FromClient_RandomShop_All_MoneyUpdate()
  end
  if nil ~= PaGlobalFunc_ServantIcon_UpdateMaidIcon then
    PaGlobalFunc_ServantIcon_UpdateMaidIcon()
  end
end
function _inventory_updateSlot_compareSpec(whereType, slotNo, isAccessory)
  local selfPlayerWrapper = getSelfPlayer()
  local classType = selfPlayerWrapper:getClassType()
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  local equipItemWrapper = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
  local offencePoint = (itemWrapper:getStaticStatus():getMinDamage(0) + itemWrapper:getStaticStatus():getMaxDamage(0)) / 2
  local defencePoint = itemWrapper:getStaticStatus():getDefence(0)
  local equipOffencePoint = 0
  local equipDefencePoint = 0
  local matchEquip = false
  local isEquip = itemWrapper:getStaticStatus():get()._usableClassType:isOn(classType)
  if isEquip and not Panel_Window_Exchange:GetShow() then
    local equipType = itemWrapper:getStaticStatus():getEquipType()
    local enum_class = CppEnums.ClassType
    local firstRingOffence = 0
    local firstRingDeffence = 0
    local secondRingOffence = 0
    local secondRingDeffence = 0
    local matchEquip = true
    if 16 == equipType or 17 == equipType then
      local accSlotNo = PaGlobalFunc_GetAccesoryWorseEquipment_Key(itemWrapper)
      local equipItemWrapper = ToClient_getEquipmentItem(accSlotNo)
      if nil ~= equipItemWrapper then
        equipOffencePoint = (equipItemWrapper:getStaticStatus():getMinDamage(0) + equipItemWrapper:getStaticStatus():getMaxDamage(0)) / 2
        equipDefencePoint = equipItemWrapper:getStaticStatus():getDefence()
        return offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, true
      else
        return offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, true
      end
    elseif 15 == equipType or 18 == equipType then
      equipItemWrapper = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
      if nil ~= equipItemWrapper then
        equipOffencePoint = (ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(0) + ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(0)) / 2
        equipDefencePoint = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getDefence()
        matchEquip = true
      else
        equipOffencePoint = 0
        equipDefencePoint = 0
        matchEquip = true
      end
      return offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, true
    end
    equipItemWrapper = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo())
    if nil ~= equipItemWrapper then
      equipDefencePoint = ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getDefence(0)
      if PaGlobal_Inventory_GetClassTypeCheckEquipType(classType, equipType) == classType then
        local attackType = PaGlobal_Inventory_GetClassAttackType(classType)
        offencePoint = (itemWrapper:getStaticStatus():getMinDamage(attackType) + itemWrapper:getStaticStatus():getMaxDamage(attackType)) / 2
        equipOffencePoint = (ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMinDamage(attackType) + ToClient_getEquipmentItem(itemWrapper:getStaticStatus():getEquipSlotNo()):getStaticStatus():getMaxDamage(attackType)) / 2
        if __eClassType_Warrior == classType or __eClassType_Valkyrie == classType then
          defencePoint = itemWrapper:getStaticStatus():getDefence(0)
        end
        matchEquip = true
      end
    elseif PaGlobal_Inventory_GetClassTypeCheckEquipType(classType, equipType) == classType then
      local attackType = PaGlobal_Inventory_GetClassAttackType(classType)
      offencePoint = (itemWrapper:getStaticStatus():getMinDamage(attackType) + itemWrapper:getStaticStatus():getMaxDamage(attackType)) / 2
      defencePoint = itemWrapper:getStaticStatus():getDefence(0)
      matchEquip = true
    end
    isAccessory = false
    return offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, isAccessory
  end
end
function PaGlobal_Inventory_GetClassAttackType(classType)
  if __eClassType_Warrior == classType or __eClassType_Valkyrie == classType or __eClassType_Giant == classType or __eClassType_Kunoichi == classType or __eClassType_NinjaMan == classType or __eClassType_BladeMaster == classType or __eClassType_BladeMasterWoman == classType or __eClassType_Combattant == classType or __eClassType_Mystic == classType or __eClassType_Lhan == classType or __eClassType_ShyWaman == classType then
    return 0
  elseif __eClassType_ElfRanger == classType or __eClassType_RangerMan == classType then
    return 1
  elseif __eClassType_Sorcerer == classType or __eClassType_Tamer == classType or __eClassType_WizardMan == classType or __eClassType_WizardWoman == classType or __eClassType_DarkElf == classType then
    return 2
  end
end
function PaGlobal_Inventory_GetClassTypeCheckEquipType(classType, equipType)
  local isAwakenWeaponContentsOpen = PaGlobal_AwakenSkill.awakenWeapon[classType]
  if 13 == equipType or 9 == equipType or 11 == equipType or 12 == equipType or isAwakenWeaponContentsOpen and 57 == equipType then
    return classType
  end
  if __eClassType_Warrior == classType or __eClassType_Valkyrie == classType then
    if 1 == equipType or 8 == equipType then
      return classType
    end
  elseif __eClassType_Giant == classType then
    if 29 == equipType or 34 == equipType then
      return classType
    end
  elseif __eClassType_ElfRanger == classType or __eClassType_RangerMan == classType then
    if 31 == equipType or 32 == equipType or 73 == equipType or 74 == equipType then
      return classType
    end
  elseif __eClassType_Sorcerer == classType then
    if 28 == equipType or 33 == equipType then
      return classType
    end
  elseif __eClassType_Tamer == classType then
    if 2 == equipType or 37 == equipType then
      return classType
    end
  elseif __eClassType_Kunoichi == classType or __eClassType_NinjaMan == classType then
    if 2 == equipType or 56 == equipType or 55 == equipType then
      return classType
    end
  elseif __eClassType_BladeMaster == classType or __eClassType_BladeMasterWoman == classType then
    if 3 == equipType or 36 == equipType then
      return classType
    end
  elseif __eClassType_WizardMan == classType or __eClassType_WizardWoman == classType then
    if 6 == equipType or 32 == equipType then
      return classType
    end
  elseif __eClassType_DarkElf == classType then
    if 63 == equipType or 34 == equipType then
      return classType
    end
  elseif __eClassType_Combattant == classType or __eClassType_Mystic == classType then
    if 65 == equipType or 66 == equipType then
      return classType
    end
  elseif __eClassType_Lhan == classType then
    if 67 == equipType or 70 == equipType then
      return classType
    end
  elseif __eClassType_ShyWaman == classType and (78 == equipType or 79 == equipType) then
    return classType
  end
  return __eClassType_Count
end
function isNormalInvenCheck()
  return isNormalInven
end
function PaGlobal_Inventory_ChangeMileage()
  local self = inven
  self.buttonMileage:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Cashshop_00.dds")
  if isGameTypeEnglish() or isGameTypeID() then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMileage, 32, 1, 62, 31)
    self.buttonMileage:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif isGameTypeTR() then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMileage, 63, 1, 93, 31)
    self.buttonMileage:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif isGameTypeKR2() then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMileage, 94, 1, 124, 31)
    self.buttonMileage:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMileage, 1, 1, 31, 31)
    self.buttonMileage:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  self.buttonMileage:setRenderTexture(self.buttonMileage:getBaseTexture())
end
function _Inventory_updateSlotData_ChangeSilverIcon(money)
  local self = inven
  self.buttonMoney:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Icon_00.dds")
  self.buttonMoney:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Icon_00.dds")
  self.buttonMoney:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Icon_00.dds")
  if money >= toInt64(0, 100000) then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMoney, 258, 124, 288, 154)
    self.buttonMoney:getBaseTexture():setUV(x1, y1, x2, y2)
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self.buttonMoney, 261, 155, 291, 185)
    self.buttonMoney:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self.buttonMoney, 261, 155, 291, 185)
    self.buttonMoney:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
  elseif money >= toInt64(0, 20000) then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMoney, 227, 124, 257, 154)
    self.buttonMoney:getBaseTexture():setUV(x1, y1, x2, y2)
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self.buttonMoney, 230, 155, 260, 185)
    self.buttonMoney:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self.buttonMoney, 230, 155, 260, 185)
    self.buttonMoney:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
  elseif money >= toInt64(0, 5000) then
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMoney, 196, 124, 226, 154)
    self.buttonMoney:getBaseTexture():setUV(x1, y1, x2, y2)
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self.buttonMoney, 199, 155, 229, 185)
    self.buttonMoney:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self.buttonMoney, 199, 155, 229, 185)
    self.buttonMoney:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
  else
    local x1, y1, x2, y2 = setTextureUV_Func(self.buttonMoney, 165, 124, 195, 154)
    self.buttonMoney:getBaseTexture():setUV(x1, y1, x2, y2)
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(self.buttonMoney, 168, 155, 198, 185)
    self.buttonMoney:getOnTexture():setUV(xx1, yy1, xx2, yy2)
    local xxx1, yyy1, xxx2, yyy2 = setTextureUV_Func(self.buttonMoney, 168, 155, 198, 185)
    self.buttonMoney:getClickTexture():setUV(xxx1, yyy1, xxx2, yyy2)
  end
  self.buttonMoney:setRenderTexture(self.buttonMoney:getBaseTexture())
  self.buttonMoney:setRenderTexture(self.buttonMoney:getOnTexture())
  self.buttonMoney:setRenderTexture(self.buttonMoney:getClickTexture())
end
function _Inventory_updateSlotData_ChangeWeightIcon(s64_allWeight, s64_maxWeight_div)
  local self = inven
  if 80 <= Int64toInt32(s64_allWeight / s64_maxWeight_div) then
    self.weightIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Icon_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.weightIcon, 135, 1, 153, 20)
    self.weightIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self.weightIcon:setRenderTexture(self.weightIcon:getBaseTexture())
  else
    self.weightIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Icon_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.weightIcon, 97, 1, 115, 20)
    self.weightIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self.weightIcon:setRenderTexture(self.weightIcon:getBaseTexture())
  end
end
function _Inventory_updateSlotData_AutoSetPotion(playerLevel, itemKey, currentWhereType, slotNo)
  if playerLevel <= 10 then
    if 502 == itemKey or 513 == itemKey or 514 == itemKey or 517 == itemKey or 518 == itemKey or 519 == itemKey or 524 == itemKey or 525 == itemKey or 528 == itemKey or 529 == itemKey or 530 == itemKey or 538 == itemKey or 551 == itemKey or 552 == itemKey or 553 == itemKey or 554 == itemKey or 555 == itemKey or 17568 == itemKey or 17569 == itemKey or 19932 == itemKey or 19933 == itemKey or 19934 == itemKey or 19935 == itemKey then
      FGlobal_Potion_InvenToQuickSlot(currentWhereType, slotNo, 0)
    elseif 503 == itemKey or 515 == itemKey or 516 == itemKey or 520 == itemKey or 521 == itemKey or 522 == itemKey or 526 == itemKey or 527 == itemKey or 531 == itemKey or 532 == itemKey or 533 == itemKey or 540 == itemKey or 561 == itemKey or 562 == itemKey or 563 == itemKey or 564 == itemKey or 565 == itemKey or 17570 == itemKey or 17571 == itemKey or 19936 == itemKey or 19937 == itemKey or 19938 == itemKey then
      FGlobal_Potion_InvenToQuickSlot(currentWhereType, slotNo, 1)
    end
  end
end
function _Inventory_updateSlotData_AddEffectBlackStone(ii, isFiltered, slotNo)
  local self = inven
  local slot = self.slots[ii]
  local itemWrapper = getInventoryItemByType(Inventory_GetCurrentInventoryType(), slotNo)
  local Panel_Inventory_isBlackStone_16002 = false
  local itemKey = itemWrapper:get():getKey():getItemKey()
  if 16001 == itemKey then
    if not isFiltered then
      slot.icon:AddEffect("fUI_DarkstoneAura01", true, 0, 0)
    end
    Panel_Inventory_isBlackStone_16001 = true
  elseif 16002 == itemKey then
    if not isFiltered then
      slot.icon:AddEffect("fUI_DarkstoneAura02", true, 0, 0)
    end
    Panel_Inventory_isBlackStone_16002 = true
  end
  return Panel_Inventory_isBlackStone_16002
end
function _Inventory_updateSlotData_AddEffectMapea(ii, slotNo)
  local self = inven
  local slot = self.slots[ii]
  local itemWrapper = getInventoryItemByType(Inventory_GetCurrentInventoryType(), slotNo)
  if GetUIMode() == Defines.UIMode.eUIMode_Stable and not EffectFilter_Mapae(slotNo, itemWrapper) then
    slot.icon:AddEffect("fUI_HorseNameCard01", true, 0, 0)
  end
end
function Inventory_AddItem(itemKey, slotNo, itemCount)
  local self = inven
  for ii = 0, self.config.slotCount - 1 do
    if ii == slotNo then
      inven.slotEtcData[ii].isFirstItem = true
      inven.slotEtcData[ii].itemKey = itemKey
    end
  end
  if itemKey == 1 then
    audioPostEvent_SystemUi(3, 12)
  elseif itemKey == 2 then
    audioPostEvent_SystemUi(3, 12)
  end
end
function Inventory_SetShowWithFilter(actorType)
  Inventory_SetShow(true)
  if CppEnums.ActorType.ActorType_Player == actorType or CppEnums.ActorType.ActorType_Deadbody == actorType then
    Inventory_SetFunctor(InvenFiler_InterActionDead, Inventory_UseItemTarget, InventoryWindow_Close, nil)
  elseif CppEnums.ActorType.ActorType_Vehicle == actorType then
    Inventory_SetFunctor(InvenFiler_InterActionFodder, Inventory_UseItemTarget, InventoryWindow_Close, nil)
  elseif CppEnums.ActorType.ActorType_Npc == actorType then
    Inventory_SetFunctor(InvenFiler_InterActionFuel, Inventory_UseFuelItem, InventoryWindow_Close, nil)
  end
end
function Inventory_UseItemTargetSelf(whereType, slotNo, equipSlotNo)
  if restrictedActionForUseItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_USEITEM"))
    return
  end
  local isTargetSelfPlayer = true
  local currentWhereType = Inventory_GetCurrentInventoryType()
  local itemWrapper = getInventoryItemByType(currentWhereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemKey = itemWrapper:get():getKey():getItemKey()
  if itemKey >= 41548 and itemKey <= 41570 or itemKey >= 42000 and itemKey <= 42010 or itemKey >= 42034 and itemKey <= 42040 or 42053 == itemKey or 42054 == itemKey then
    audioPostEvent_SystemUi(0, 14)
  end
  if nil == equipSlotNo then
    equipSlotNo = CppEnums.EquipSlotNoClient.eEquipSlotNoCount
  end
  inventoryUseItem(whereType, slotNo, equipSlotNo, isTargetSelfPlayer)
  if (42000 == itemKey or 42001 == itemKey or 42002 == itemKey or 42010 == itemKey or 42003 == itemKey or 42004 == itemKey or 42034 == itemKey or 42035 == itemKey or 42037 == itemKey or 42036 == itemKey or 42006 == itemKey or 42008 == itemKey or 42039 == itemKey or 42038 == itemKey or 42007 == itemKey or 42053 == itemKey or 41610 == itemKey or 42009 == itemKey or 42054 == itemKey or 42057 == itemKey or 42061 == itemKey or 42066 == itemKey or 42055 == itemKey or 42056 == itemKey or 42269 == itemKey or 42270 == itemKey or 42002 == itemKey or 42271 == itemKey or 42276 == itemKey or 42277 == itemKey or 42034 == itemKey or 42277 == itemKey or 42003 == itemKey or 42035 == itemKey or 42009 == itemKey or 41675 == itemKey or 42511 == itemKey or 42038 == itemKey or 42054 == itemKey or 41610 == itemKey or 42037 == itemKey or 42036 == itemKey or 42008 == itemKey or 42271 == itemKey or 42039 == itemKey or 42007 == itemKey) and PaGlobal_SummonBossTutorial_Manager:isDoingSummonBossTutorial() then
    isFirstSummonItemUse = true
  end
  if (290033 == itemKey or 290034 == itemKey or 290035 == itemKey or 290036 == itemKey or 290037 == itemKey or 290038 == itemKey or 290039 == itemKey or 290040 == itemKey or 290041 == itemKey) and PaGlobal_ValuePackageTutorial_Manager:isDoingValuePackageTutorial() then
    isValuePackageItemUse = true
  end
end
function FGlobal_FirstSummonItemUse()
  return isFirstSummonItemUse
end
function FGlobal_ValuePackagerItemUse()
  return isValuePackageItemUse
end
function Inventory_UseItemTarget(slotNo, itemWrapper, count_s64, inventoryType)
  if restrictedActionForUseItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_USEITEM"))
    return
  end
  local isTargetSelfPlayer = false
  inventoryUseItem(inventoryType, slotNo, isTargetSelfPlayer)
end
function InvenFiler_InterActionDead(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  if itemWrapper:getStaticStatus():get()._key:getItemKey() == 54002 then
    if true == ToClient_IsAnySiegeBeingOfMyChannel() and true == _ContentsGroup_SeigeSeason5 then
      return true
    else
      return false
    end
  end
  return itemWrapper:getStaticStatus():get():isItemTargetAlive() or not itemWrapper:checkConditions()
end
function InvenFiler_InterActionSkill(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  return not itemWrapper:getStaticStatus():get():isItemSkill() or not itemWrapper:checkConditions()
end
function InvenFiler_InterActionFodder(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  return not itemWrapper:getStaticStatus():get():isUseToVehicle() or not itemWrapper:checkConditions()
end
function InvenFiler_InterActionFuel(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  return not isFusionItem(Inventory_GetCurrentInventoryType(), slotNo)
end
function Inventory_UseFuelItem(slotNo, itemWrapper, count_s64, inventoryType)
  burnItemToActor(inventoryType, slotNo, 1, false)
end
function restrictedActionForUseItem()
  local isRestricted = checkManufactureAction() or checkAlchemyAction()
  return isRestricted
end
function Inventory_SetShow(isInvenShow)
  local self = inven
  isFirstTab = true
  if not isInvenShow then
    InventoryWindow_Close()
    Panel_Tooltip_Item_hideTooltip()
    PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
  else
    if Panel_Manufacture:GetShow() then
      self.radioButtonCashInven:SetIgnore(true)
      self.radioButtonCashInven:SetMonoTone(true)
    else
      self.radioButtonCashInven:SetIgnore(false)
      self.radioButtonCashInven:SetMonoTone(false)
    end
    InventoryWindow_Show()
  end
end
function Inventory_updateSlotDatabyAddItem()
  if true == Panel_Window_Inventory:GetShow() then
    Inventory_updateSlotData()
  end
end
function inven:registMessageHandler()
  registerEvent("FromClient_WeightChanged", "Inventory_updateSlotData")
  registerEvent("FromClient_InventoryUpdate", "Inventory_updateSlotData")
  registerEvent("EventInventorySetShow", "Inventory_SetShow")
  registerEvent("EventInventorySetShowWithFilter", "Inventory_SetShowWithFilter")
  registerEvent("EventAddItemToInventory", "Inventory_AddItem")
  registerEvent("EventUnEquipItemToInventory", "Inventory_UnequipItem")
  registerEvent("FromClient_UseItemAskFromOtherPlayer", "UseItemAskFromOtherPlayer")
  registerEvent("onScreenResize", "Inventory_RePosition")
  registerEvent("FromClient_FindExchangeItemNPC", "FromClient_FindExchangeItemNPC")
  registerEvent("FromClient_InventoryUpdatebyAddItem", "Inventory_updateSlotDatabyAddItem")
  registerEvent("FromClient_UpdateInventoryBag", "Inventory_updateSlotDatabyAddItem")
  registerEvent("FromClient_ShowRecommendProductByComplete", "Inventory_updateSlotData")
end
function Inventory_RePosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local invenSizeX = Panel_Window_Inventory:GetSizeX()
  local invenSizeY = Panel_Window_Inventory:GetSizeY()
  local dialogSizeY = 0
  local dialogShow = false
  if false == _ContentsGroup_NewUI_Dialog_All then
    dialogSizeY = Panel_Npc_Dialog:GetSizeY()
    dialogShow = Panel_Npc_Dialog:GetShow()
  else
    dialogSizeY = Panel_Npc_Dialog_All:GetSizeY()
    dialogShow = Panel_Npc_Dialog_All:GetShow()
  end
  Panel_Window_Inventory:SetPosX(scrSizeX - invenSizeX)
  Panel_Window_Inventory:SetPosY(math.max(0, (scrSizeY - invenSizeY) / 2))
  inven.orgPosX = Panel_Window_Inventory:GetPosX()
  inven.orgPosY = Panel_Window_Inventory:GetPosY()
  if true == dialogShow and nil == dialog_getTalker() then
    if scrSizeY < invenSizeY + dialogSizeY then
      Panel_Window_Inventory:SetPosY(0)
    else
      Panel_Window_Inventory:SetPosY(scrSizeY - invenSizeY - dialogSizeY)
    end
  end
end
function FGlobal_InventorySetPos_WithWarehouse()
  Panel_Window_Inventory:SetPosX(getScreenSizeX() - Panel_Window_Inventory:GetSizeX())
  Panel_Window_Inventory:SetPosY(Panel_Window_Warehouse:GetPosY())
end
function Inventory_GetStartIndex()
  local self = inven
  return self.startSlotIndex
end
function Inventory_CashTabScroll(isUp)
  local self = inven
  local useStartSlot = inventorySlotNoUserStart()
  local inventory = Inventory_GetCurrentInventory()
  local maxSize = inventory:sizeXXX() - useStartSlot
  local prevSlotIndex = self.startSlotIndex
  self.startSlotIndex = UIScroll.ScrollEvent(self._scroll, isUp, self.config.slotRows, maxSize, self.startSlotIndex, self.config.slotCols)
  local intervalSlotIndex = INVEN_MAX_COUNT - INVEN_CURRENTSLOT_COUNT
  if prevSlotIndex == 0 and self.startSlotIndex == 0 or prevSlotIndex == intervalSlotIndex and self.startSlotIndex == intervalSlotIndex then
    return
  end
  Inventory_updateSlotData()
end
function Inventory_SetFunctor(filterFunction, rClickFunction, otherWindowOpenFunction, effect)
  local self = inven
  if nil ~= self.otherWindowOpenFunc and nil ~= otherWindowOpenFunction then
    local otherWindowOpenFuncDiff = otherWindowOpenFunction ~= self.otherWindowOpenFunc
    if otherWindowOpenFuncDiff and (nil ~= filterFunction or nil ~= rClickFunction or nil ~= otherWindowOpenFunction) then
      self.otherWindowOpenFunc()
    end
  end
  if nil ~= filterFunction and "function" ~= type(filterFunction) then
    filterFunction = nil
    UI.ASSERT(false, "Param 1 must be Function type")
  end
  if nil ~= rClickFunction and "function" ~= type(rClickFunction) then
    rClickFunction = nil
    UI.ASSERT(false, "Param 1 must be Function type")
  end
  if nil ~= effect and "function" ~= type(effect) then
    effect = nil
    UI.ASSERT(false, "Param 1 must be Function type")
  end
  self.otherWindowOpenFunc = otherWindowOpenFunction
  self.rClickFunc = rClickFunction
  self.filterFunc = filterFunction
  self.effect = effect
  if Panel_Window_Inventory:GetShow() then
    Inventory_updateSlotData()
  end
end
function Inventory_DropHandler(index)
  local self = inven
  local slotNo = self.slots[index]._slotNo
  if nil == DragManager.dragStartPanel then
    return false
  end
  if restrictedActionForUseItem() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REPOSITIONITEM"))
    return false
  end
  if Panel_Window_Exchange:IsShow() or Panel_Manufacture:IsShow() or Panel_Alchemy:IsShow() or Panel_Win_System:IsShow() or FGlobal_Enchant_SetTargetItem() or Panel_Window_DetectUser:IsShow() or PaGlobalFunc_PetRegister_GetShow() then
    DragManager:clearInfo()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_CANT_REPOSITIONITEM_WHILE_UI"))
    return false
  end
  local fromSlotNo = DragManager.dragSlotInfo
  if Panel_Window_Inventory == DragManager.dragStartPanel then
    if DragManager.dragWhereTypeInfo == Inventory_GetCurrentInventoryType() then
      inventory_swapItem(Inventory_GetCurrentInventoryType(), DragManager.dragSlotInfo, slotNo)
    end
    Inventory_DropEscape()
    DragManager:clearInfo()
  else
    return (DragManager:itemDragMove(CppEnums.MoveItemToType.Type_Player, getSelfPlayer():getActorKey()))
  end
  return true
end
function Inventory_DropEscape()
  icon_TrashOn:SetShow(false)
  icon_TrashSequence:SetShow(false)
end
function Inventory_DropEscapeAlert()
  icon_TrashOn:SetShow(false)
end
function Inventory_DropOnTrashButton(isShow)
  if not isShow then
    icon_TrashOn:SetShow(true)
    icon_TrashSequence:SetShow(false)
  end
  icon_TrashOn:SetShow(false)
end
function Inventory_UnequipItem(whereType, slotNo)
  local self = inven
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemStatic = itemWrapper:getStaticStatus():get()
  if nil == itemStatic then
    return
  end
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    if slotNo == slot._slotNo then
      slot.background:AddEffect("fUI_Item_Clear", false, 0, 0)
    end
  end
  audioPostEvent_SystemUi(2, 0)
end
inven:init()
inven:createSlot()
inven:registEventHandler()
inven:registMessageHandler()
function Inven_FindPuzzle()
  local self = inven
  for _, value in pairs(inven.slotEtcData) do
    value.puzzleControl:SetShow(false)
  end
  if self.checkButton_Sort:IsCheck() then
    return
  end
  local whereType = Inventory_GetCurrentInventoryType()
  local isFind = findPuzzleAndReadyMake(whereType)
  local useSlotNo = inventorySlotNoUserStart()
  if not isFind then
    return
  end
  local count = getPuzzleSlotCount()
  for ii = 0, count - 1 do
    local slotNo = getPuzzleSlotAt(ii)
    for jj = 0, self.config.slotCount - 1 do
      local slot = self.slots[jj]
      if slotNo == slot._slotNo then
        slot.icon:AddEffect("UI_Item_MineCraft", true, 0, 0)
      end
    end
  end
  local slotNumber = getPuzzleSlotAt(0)
  for ii = 0, self.config.slotCount - 1 do
    local slot = self.slots[ii]
    if slotNumber == slot._slotNo then
      self.slotEtcData[ii].puzzleControl:SetShow(true)
    end
  end
end
function PuzzleButton_Over(slotIndex)
  local self = inven
  local slot = self.slots[slotIndex]
  Panel_Tooltip_Item_hideTooltip()
  _puzzleNoticeText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _puzzleNoticeText:SetAutoResize(true)
  _puzzleMessage = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_DOPUZZLE")
  _puzzleNoticeText:SetText(_puzzleMessage)
  _puzzleNotice:SetPosX(slot.icon:GetPosX() - _puzzleNotice:GetSizeX())
  _puzzleNotice:SetPosY(slot.icon:GetPosY() - 20)
  _puzzleNotice:SetSize(_puzzleNotice:GetSizeX(), _puzzleNoticeText:GetSizeY() + 10)
  _puzzleNotice:SetColor(Defines.Color.C_FF000000)
  _puzzleNotice:ComputePos()
  _puzzleNotice:SetShow(true)
end
function PuzzleButton_Out(slotIndex)
  _puzzleNotice:SetShow(false)
end
function MakePuzzle(index)
  local self = inven
  self.slotEtcData[index].puzzleControl:SetShow(false)
  _puzzleNotice:SetShow(false)
  requestMakePuzzle()
end
function UseItemAskFromOtherPlayer(fromName)
  local messageboxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_USEITEM_MESSAGEBOX_REQUEST", "for_name", fromName)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_USEITEM_MESSAGEBOX_TITLE"),
    content = messageboxMemo,
    functionYes = UseItemFromOtherPlayer_Yes,
    functionCancel = UseItemFromOtherPlayer_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function UseItemFromOtherPlayer_Yes()
  useItemFromOtherPlayer(true)
end
function UseItemFromOtherPlayer_No()
  useItemFromOtherPlayer(false)
end
function Inventory_FilterRadioTooltip_Show(isShow, target)
  local self = inven
  if true == isShow then
    if FilterRadioTooltip:GetShow() then
      FilterRadioTooltip:SetShow(false)
    end
    local control
    if 0 == target then
      control = self.radioButtonStd
      FilterRadioTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_ALL"))
    elseif 1 == target then
      control = self.radioButtonTransport
      FilterRadioTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_TRADE"))
    elseif 2 == target then
      control = self.radioButtonHousing
      FilterRadioTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TEXT_FILTERTOOLTIP_HOUSING"))
    end
    FilterRadioTooltip:SetPosX(control:GetPosX() - FilterRadioTooltip:GetSizeX())
    FilterRadioTooltip:SetPosY(control:GetPosY() - FilterRadioTooltip:GetTextSizeY())
    FilterRadioTooltip:SetShow(true)
  else
    FilterRadioTooltip:SetShow(false)
  end
end
function Panel_Inventory_SimpleTooltip(isShow, tipType)
  if not isShow then
    return TooltipSimple_Hide()
  end
  local name, desc, control
  local self = inven
  name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BUYWEIGHT_TOOLTIP_NAME")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_BUYWEIGHT_TOOLTIP_DESC")
  control = self.btn_BuyWeight
  TooltipSimple_Show(control, name, desc)
end
function Inventory_TrashToolTip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    if DragManager:isDragging() then
    else
      icon_TrashOn:SetShow(false)
    end
    icon_TrashSequence:SetShow(false)
    return
  end
  local name, desc, control
  local self = inven
  name = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TRASH_TOOLTIP_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_TRASH_TOOLTIP_DESC")
  if DragManager:isDragging() then
    icon_TrashOn:SetShow(false)
  end
  control = self.trashArea
  TooltipSimple_Show(control, name, desc)
end
local panel_tmpPosX = 0
local panel_tmpPosY = 0
function Inventory_PosSaveMemory()
  panel_tmpPosX = Panel_Window_Inventory:GetPosX()
  panel_tmpPosY = Panel_Window_Inventory:GetPosY()
end
function Inventory_PosLoadMemory()
  Panel_Window_Inventory:SetPosX(panel_tmpPosX)
  Panel_Window_Inventory:SetPosY(panel_tmpPosY)
end
function Inventory_SetIgnoreMoneyButton(setIgnore)
  local self = inven
  if setIgnore == true and not Panel_Window_Warehouse:GetShow() then
    self.buttonMoney:SetIgnore(true)
  else
    self.buttonMoney:SetIgnore(false)
  end
end
function Inventory_ManufactureBTN()
  if MiniGame_Manual_Value_FishingStart == true then
    return
  else
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
      return
    end
    if Panel_Manufacture ~= nil and Panel_Window_Inventory ~= nil and Panel_Equipment ~= nil then
      local isInvenOpen = Panel_Window_Inventory:GetShow()
      local isManufactureOpen = Panel_Manufacture:GetShow()
      if isManufactureOpen == false or isInvenOpen == false then
        audioPostEvent_SystemUi(1, 26)
        Manufacture_Show(nil, CppEnums.ItemWhereType.eInventory, true, true)
        if Panel_Manufacture:GetShow() then
          Panel_Equipment:SetShow(false)
          ClothInventory_Close()
        end
      end
    end
    return
  end
end
function FGlobal_RecentCookItemCheck(itemKey, itemCount)
  local self = inven
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local saveInfo = {}
  local useStartSlot = inventorySlotNoUserStart()
  local returnSlotNo
  local selfPlayer = selfPlayerWrapper:get()
  local invenUseSize = selfPlayer:getInventorySlotCount(not isNormalInven)
  for i = 0, invenUseSize - 1 do
    local slotNo = i + useStartSlot
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, slotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local invenItemKey = itemSSW:get()._key:getItemKey()
      if itemKey == invenItemKey then
        saveInfo.slotNo = slotNo
        returnSlotNo = slotNo
      end
    end
  end
  return returnSlotNo
end
function inventory_FlushRestoreFunc()
  if true == Panel_Window_Inventory:isPlayAnimation() then
    Panel_Window_Inventory:SetScaleDefault()
  end
  local self = inven
  self.btn_Manufacture:SetEnable(true)
  self.btn_Manufacture:SetMonoTone(false)
  self.btn_AlchemyStone:SetEnable(true)
  self.btn_AlchemyStone:SetMonoTone(false)
  self.btn_AlchemyFigureHead:SetEnable(true)
  self.btn_AlchemyFigureHead:SetMonoTone(false)
  self.btn_DyePalette:SetEnable(true)
  self.btn_DyePalette:SetMonoTone(false)
  Panel_Window_Inventory:SetSize(Panel_Window_Inventory:GetSizeX(), 702)
  self.buttonTypeBG:SetShow(true)
  self.buttonTypeBG:ComputePos()
  self.trashArea:ComputePos()
  self.moneyTypeBG:ComputePos()
  self.weightGaugeBG:ComputePos()
  self.staticCapacity:ComputePos()
end
function renderModeChange_inventory_FlushRestoreFunc(prevRenderModeList, nextRenderModeList)
  local self = inven
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    if isFlushedUI() then
      if true == Panel_Window_Inventory:isPlayAnimation() then
        Panel_Window_Inventory:SetScaleDefault()
      end
      self.btn_Manufacture:SetEnable(false)
      self.btn_Manufacture:SetMonoTone(true)
      self.btn_AlchemyStone:SetEnable(false)
      self.btn_AlchemyStone:SetMonoTone(true)
      self.btn_AlchemyFigureHead:SetEnable(false)
      self.btn_AlchemyFigureHead:SetMonoTone(true)
      self.btn_DyePalette:SetEnable(false)
      self.btn_DyePalette:SetMonoTone(true)
      Panel_Window_Inventory:SetSize(Panel_Window_Inventory:GetSizeX(), 652)
      self.buttonTypeBG:SetShow(false)
      self.trashArea:ComputePos()
      self.moneyTypeBG:ComputePos()
      self.weightGaugeBG:ComputePos()
      self.staticCapacity:ComputePos()
    end
    return
  end
  inventory_FlushRestoreFunc()
end
function Global_GetInventorySlotNoByNotSorted(fromSlotNo)
  if nil == fromSlotNo then
    return
  end
  local self = inven
  local toSlotNo = self.slots[fromSlotNo]._slotNo
  return toSlotNo
end
function FGlobal_UpdateInventoryWeight()
  local self = inven
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local _const = Defines.s64_const
  local normalInventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local s64_moneyWeight = normalInventory:getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local s64_allWeight_div = s64_allWeight / _const.s64_100
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100)
  if Int64toInt32(s64_allWeight) <= Int64toInt32(s64_maxWeight) then
    self.weightMoney:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_maxWeight_div))
    self.weightEquipment:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_maxWeight_div))
    self.weightItem:SetProgressRate(Int64toInt32(s64_allWeight / s64_maxWeight_div))
  else
    self.weightMoney:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_allWeight_div))
    self.weightEquipment:SetProgressRate(Int64toInt32((s64_moneyWeight + s64_equipmentWeight) / s64_allWeight_div))
    self.weightItem:SetProgressRate(Int64toInt32(s64_allWeight / s64_allWeight_div))
  end
  self.staticWeight:SetText(str_AllWeight .. " / " .. str_MaxWeight .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
  _Inventory_updateSlotData_ChangeWeightIcon(s64_allWeight, s64_maxWeight_div)
end
function Inventory_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if inven.checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(inven.checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromClient_cursorOnOffSignal()
  if Panel_Win_System:GetShow() then
    return
  end
  icon_TrashOn:SetShow(false)
  icon_TrashSequence:SetShow(false)
  TooltipSimple_Hide()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_inventory_FlushRestoreFunc")
registerEvent("FromClient_cursorOnOffSignal", "FromClient_cursorOnOffSignal")
