local _panel = Panel_Widget_Tooltip_Renew
local TooltipInfo = {
  _ui = {
    stc_BG = {
      [1] = UI.getChildControl(_panel, "Static_BG_1")
    },
    stc_components = {},
    slot_itemIcon = {},
    stc_socketBG = {},
    stc_socketIcon = {},
    txt_mainAttr = {}
  },
  _poolCount = 2,
  _compareItemWrapper = nil
}
local _currentPool = 1
local _currentYPos = 50
local _defaultYPos = 50
local _defaultGapBetweenComponent = 5
local _defaultSizeX = 400
local _leftAlignDefaultX = 60
local _rightAlignDefaultX = 130
local _currentComponentIsInFrame = false
local _currentComponentIsLeftAlign = false
local _baseRightCompareLeft = true
local _equippedItemTooltip = false
local _clipAreaYSize = 650
local _componentOption = {}
local COMPONENT_TYPE = {
  TYPE = 1,
  HEADER = 2,
  CRYSTAL = 3,
  MAIN_ATTR = 4,
  SUB_ATTR = 5,
  ENCHANT_TYPE = 6,
  DESCRIPTION = 7,
  DYEING_INFO = 8,
  USE_LIMIT = 9,
  ITEM_MARKET_INFO = 10,
  CAPACITY = 11,
  EXPERIENCE = 12,
  ENDURANCE = 13,
  WEIGHT_PRICE = 14,
  TIME_LIMIT = 15,
  PRODUCTION_REGION = 16,
  LINE_SPLIT = 17,
  TRADE_PRICE = 18,
  VESTED = 19,
  EXCHANGE_INFO = 20,
  EXTRACTION_INFO = 21,
  CLIP_AREA = 22
}
local SPLIT = -1
local _slotBGUV = {
  {
    143,
    195,
    187,
    239
  },
  {
    278,
    195,
    322,
    239
  }
}
local _targetData = {
  [Defines.TooltipTargetType.Item] = {
    COMPONENT_TYPE.TYPE,
    COMPONENT_TYPE.HEADER,
    COMPONENT_TYPE.CRYSTAL,
    COMPONENT_TYPE.MAIN_ATTR,
    SPLIT,
    COMPONENT_TYPE.LINE_SPLIT,
    SPLIT,
    COMPONENT_TYPE.SUB_ATTR,
    SPLIT,
    COMPONENT_TYPE.VESTED,
    COMPONENT_TYPE.ENCHANT_TYPE,
    COMPONENT_TYPE.TIME_LIMIT,
    COMPONENT_TYPE.PRODUCTION_REGION,
    COMPONENT_TYPE.EXTRACTION_INFO,
    COMPONENT_TYPE.DESCRIPTION,
    COMPONENT_TYPE.EXCHANGE_INFO,
    COMPONENT_TYPE.DYEING_INFO,
    COMPONENT_TYPE.USE_LIMIT,
    COMPONENT_TYPE.ITEM_MARKET_INFO,
    COMPONENT_TYPE.CAPACITY,
    COMPONENT_TYPE.TRADE_PRICE,
    COMPONENT_TYPE.EXPERIENCE,
    COMPONENT_TYPE.ENDURANCE,
    COMPONENT_TYPE.WEIGHT_PRICE
  },
  [Defines.TooltipTargetType.ItemWithoutCompare] = {
    COMPONENT_TYPE.TYPE,
    COMPONENT_TYPE.HEADER,
    COMPONENT_TYPE.CRYSTAL,
    COMPONENT_TYPE.MAIN_ATTR,
    SPLIT,
    COMPONENT_TYPE.LINE_SPLIT,
    SPLIT,
    COMPONENT_TYPE.SUB_ATTR,
    SPLIT,
    COMPONENT_TYPE.VESTED,
    COMPONENT_TYPE.ENCHANT_TYPE,
    COMPONENT_TYPE.TIME_LIMIT,
    COMPONENT_TYPE.PRODUCTION_REGION,
    COMPONENT_TYPE.EXTRACTION_INFO,
    COMPONENT_TYPE.DESCRIPTION,
    COMPONENT_TYPE.EXCHANGE_INFO,
    COMPONENT_TYPE.DYEING_INFO,
    COMPONENT_TYPE.USE_LIMIT,
    COMPONENT_TYPE.ITEM_MARKET_INFO,
    COMPONENT_TYPE.CAPACITY,
    COMPONENT_TYPE.TRADE_PRICE,
    COMPONENT_TYPE.EXPERIENCE,
    COMPONENT_TYPE.ENDURANCE,
    COMPONENT_TYPE.WEIGHT_PRICE
  }
}
local _config = {
  createIcon = true,
  createBorder = true,
  createCount = false,
  createCash = true,
  createEnchant = true,
  createEnduranceIcon = true
}
local socketMaxCount = 0
function FromClient_luaLoadComplete_TooltipInfo_Init()
  TooltipInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TooltipInfo_Init")
function TooltipInfo:initialize()
  _componentOption = {
    [COMPONENT_TYPE.TYPE] = {fillDataFunc = TooltipInfo_updateTYPE},
    [COMPONENT_TYPE.HEADER] = {fillDataFunc = TooltipInfo_updateHEADER},
    [COMPONENT_TYPE.CRYSTAL] = {fillDataFunc = TooltipInfo_updateCRYSTAL},
    [COMPONENT_TYPE.MAIN_ATTR] = {fillDataFunc = TooltipInfo_updateMAIN_ATTR},
    [COMPONENT_TYPE.EXPERIENCE] = {fillDataFunc = TooltipInfo_updateEXPERIENCE, bottomAlign = true},
    [COMPONENT_TYPE.ENDURANCE] = {fillDataFunc = TooltipInfo_updateENDURANCE, bottomAlign = true},
    [COMPONENT_TYPE.WEIGHT_PRICE] = {fillDataFunc = TooltipInfo_updateWEIGHT_PRICE, bottomAlign = true},
    [COMPONENT_TYPE.LINE_SPLIT] = {fillDataFunc = TooltipInfo_updateLINE_SPLIT},
    [COMPONENT_TYPE.SUB_ATTR] = {fillDataFunc = TooltipInfo_updateSUB_ATTR, isInsideClippingArea = true},
    [COMPONENT_TYPE.ENCHANT_TYPE] = {fillDataFunc = TooltipInfo_updateENCHANT_TYPE, isInsideClippingArea = true},
    [COMPONENT_TYPE.DESCRIPTION] = {fillDataFunc = TooltipInfo_updateDESCRIPTION, isInsideClippingArea = true},
    [COMPONENT_TYPE.DYEING_INFO] = {fillDataFunc = TooltipInfo_updateDYEING_INFO, isInsideClippingArea = true},
    [COMPONENT_TYPE.USE_LIMIT] = {fillDataFunc = TooltipInfo_updateUSE_LIMIT, isInsideClippingArea = true},
    [COMPONENT_TYPE.TIME_LIMIT] = {fillDataFunc = TooltipInfo_updateTIME_LIMIT, isInsideClippingArea = true},
    [COMPONENT_TYPE.ITEM_MARKET_INFO] = {fillDataFunc = TooltipInfo_updateITEM_MARKET_INFO, isInsideClippingArea = true},
    [COMPONENT_TYPE.PRODUCTION_REGION] = {fillDataFunc = TooltipInfo_updatePRODUCTION_REGION, isInsideClippingArea = true},
    [COMPONENT_TYPE.TRADE_PRICE] = {fillDataFunc = TooltipInfo_updateTRADE_PRICE, isInsideClippingArea = true},
    [COMPONENT_TYPE.VESTED] = {fillDataFunc = TooltipInfo_updateVESTED, isInsideClippingArea = true},
    [COMPONENT_TYPE.CAPACITY] = {fillDataFunc = TooltipInfo_updateCAPACITY, isInsideClippingArea = true},
    [COMPONENT_TYPE.EXCHANGE_INFO] = {fillDataFunc = TooltipInfo_updateEXCHANGE_INFO, isInsideClippingArea = true},
    [COMPONENT_TYPE.EXTRACTION_INFO] = {fillDataFunc = TooltipInfo_updateEXTRACTION_INFO, isInsideClippingArea = true}
  }
  local stc_clipTemplate = UI.getChildControl(self._ui.stc_BG[1], "Static_ClipArea")
  _clipAreaYSize = stc_clipTemplate:GetSizeY()
  self._ui.stc_scrollContent = {}
  self._ui.stc_scrollContent[1] = UI.getChildControl(stc_clipTemplate, "Static_ScrollContent")
  self._ui.stc_components = {
    [1] = {
      [COMPONENT_TYPE.TYPE] = UI.getChildControl(self._ui.stc_BG[1], "TYPE"),
      [COMPONENT_TYPE.HEADER] = UI.getChildControl(self._ui.stc_BG[1], "HEADER"),
      [COMPONENT_TYPE.CRYSTAL] = UI.getChildControl(self._ui.stc_BG[1], "CRYSTAL"),
      [COMPONENT_TYPE.MAIN_ATTR] = UI.getChildControl(self._ui.stc_BG[1], "MAIN_ATTR"),
      [COMPONENT_TYPE.EXPERIENCE] = UI.getChildControl(self._ui.stc_BG[1], "EXPERIENCE"),
      [COMPONENT_TYPE.ENDURANCE] = UI.getChildControl(self._ui.stc_BG[1], "ENDURANCE"),
      [COMPONENT_TYPE.WEIGHT_PRICE] = UI.getChildControl(self._ui.stc_BG[1], "WEIGHT_PRICE"),
      [COMPONENT_TYPE.LINE_SPLIT] = UI.getChildControl(self._ui.stc_BG[1], "LINE_SPLIT"),
      [COMPONENT_TYPE.SUB_ATTR] = UI.getChildControl(self._ui.stc_scrollContent[1], "SUB_ATTR"),
      [COMPONENT_TYPE.ENCHANT_TYPE] = UI.getChildControl(self._ui.stc_scrollContent[1], "ENCHANT_TYPE"),
      [COMPONENT_TYPE.DESCRIPTION] = UI.getChildControl(self._ui.stc_scrollContent[1], "DESCRIPTION"),
      [COMPONENT_TYPE.DYEING_INFO] = UI.getChildControl(self._ui.stc_scrollContent[1], "DYEING_INFO"),
      [COMPONENT_TYPE.USE_LIMIT] = UI.getChildControl(self._ui.stc_scrollContent[1], "USE_LIMIT"),
      [COMPONENT_TYPE.ITEM_MARKET_INFO] = UI.getChildControl(self._ui.stc_scrollContent[1], "ITEM_MARKET_INFO"),
      [COMPONENT_TYPE.TIME_LIMIT] = UI.getChildControl(self._ui.stc_scrollContent[1], "TIME_LIMIT"),
      [COMPONENT_TYPE.PRODUCTION_REGION] = UI.getChildControl(self._ui.stc_scrollContent[1], "PRODUCTION_REGION"),
      [COMPONENT_TYPE.TRADE_PRICE] = UI.getChildControl(self._ui.stc_scrollContent[1], "TRADE_PRICE"),
      [COMPONENT_TYPE.VESTED] = UI.getChildControl(self._ui.stc_scrollContent[1], "VESTED"),
      [COMPONENT_TYPE.CAPACITY] = UI.getChildControl(self._ui.stc_scrollContent[1], "CAPACITY"),
      [COMPONENT_TYPE.EXCHANGE_INFO] = UI.getChildControl(self._ui.stc_scrollContent[1], "EXCHANGE_INFO"),
      [COMPONENT_TYPE.EXTRACTION_INFO] = UI.getChildControl(self._ui.stc_scrollContent[1], "EXTRACTION_INFO"),
      [COMPONENT_TYPE.CLIP_AREA] = stc_clipTemplate
    }
  }
  socketMaxCount = ToClient_GetMaxItemSocketCount()
  for ii = 2, self._poolCount do
    self._ui.stc_BG[ii] = UI.cloneControl(self._ui.stc_BG[1], _panel, "Static_BG_" .. ii)
    self._ui.stc_components[ii] = {}
    self._ui.stc_components[ii][COMPONENT_TYPE.TYPE] = UI.getChildControl(self._ui.stc_BG[ii], "TYPE")
    self._ui.stc_components[ii][COMPONENT_TYPE.HEADER] = UI.getChildControl(self._ui.stc_BG[ii], "HEADER")
    self._ui.stc_components[ii][COMPONENT_TYPE.CRYSTAL] = UI.getChildControl(self._ui.stc_BG[ii], "CRYSTAL")
    self._ui.stc_components[ii][COMPONENT_TYPE.MAIN_ATTR] = UI.getChildControl(self._ui.stc_BG[ii], "MAIN_ATTR")
    self._ui.stc_components[ii][COMPONENT_TYPE.EXPERIENCE] = UI.getChildControl(self._ui.stc_BG[ii], "EXPERIENCE")
    self._ui.stc_components[ii][COMPONENT_TYPE.ENDURANCE] = UI.getChildControl(self._ui.stc_BG[ii], "ENDURANCE")
    self._ui.stc_components[ii][COMPONENT_TYPE.WEIGHT_PRICE] = UI.getChildControl(self._ui.stc_BG[ii], "WEIGHT_PRICE")
    self._ui.stc_components[ii][COMPONENT_TYPE.LINE_SPLIT] = UI.getChildControl(self._ui.stc_BG[ii], "LINE_SPLIT")
    self._ui.stc_components[ii][COMPONENT_TYPE.CLIP_AREA] = UI.getChildControl(self._ui.stc_BG[ii], "Static_ClipArea")
    self._ui.stc_scrollContent[ii] = UI.getChildControl(self._ui.stc_components[ii][COMPONENT_TYPE.CLIP_AREA], "Static_ScrollContent")
    self._ui.stc_components[ii][COMPONENT_TYPE.SUB_ATTR] = UI.getChildControl(self._ui.stc_scrollContent[ii], "SUB_ATTR")
    self._ui.stc_components[ii][COMPONENT_TYPE.ENCHANT_TYPE] = UI.getChildControl(self._ui.stc_scrollContent[ii], "ENCHANT_TYPE")
    self._ui.stc_components[ii][COMPONENT_TYPE.DESCRIPTION] = UI.getChildControl(self._ui.stc_scrollContent[ii], "DESCRIPTION")
    self._ui.stc_components[ii][COMPONENT_TYPE.DYEING_INFO] = UI.getChildControl(self._ui.stc_scrollContent[ii], "DYEING_INFO")
    self._ui.stc_components[ii][COMPONENT_TYPE.USE_LIMIT] = UI.getChildControl(self._ui.stc_scrollContent[ii], "USE_LIMIT")
    self._ui.stc_components[ii][COMPONENT_TYPE.ITEM_MARKET_INFO] = UI.getChildControl(self._ui.stc_scrollContent[ii], "ITEM_MARKET_INFO")
    self._ui.stc_components[ii][COMPONENT_TYPE.TIME_LIMIT] = UI.getChildControl(self._ui.stc_scrollContent[ii], "TIME_LIMIT")
    self._ui.stc_components[ii][COMPONENT_TYPE.PRODUCTION_REGION] = UI.getChildControl(self._ui.stc_scrollContent[ii], "PRODUCTION_REGION")
    self._ui.stc_components[ii][COMPONENT_TYPE.TRADE_PRICE] = UI.getChildControl(self._ui.stc_scrollContent[ii], "TRADE_PRICE")
    self._ui.stc_components[ii][COMPONENT_TYPE.VESTED] = UI.getChildControl(self._ui.stc_scrollContent[ii], "VESTED")
    self._ui.stc_components[ii][COMPONENT_TYPE.CAPACITY] = UI.getChildControl(self._ui.stc_scrollContent[ii], "CAPACITY")
    self._ui.stc_components[ii][COMPONENT_TYPE.EXCHANGE_INFO] = UI.getChildControl(self._ui.stc_scrollContent[ii], "EXCHANGE_INFO")
    self._ui.stc_components[ii][COMPONENT_TYPE.EXTRACTION_INFO] = UI.getChildControl(self._ui.stc_scrollContent[ii], "EXTRACTION_INFO")
  end
  self._ui.stc_BG[2]:ChangeTextureInfoName("renewal/frame/console_comboguidebg_02.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_BG[2], 256, 0, 0, 429)
  self._ui.stc_BG[2]:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_BG[2]:setRenderTexture(self._ui.stc_BG[2]:getBaseTexture())
  self._ui.stc_scrollBG = {}
  self._ui.stc_scrollBtn = {}
  for ii = 1, self._poolCount do
    local stc_clipArea = self._ui.stc_components[ii][COMPONENT_TYPE.CLIP_AREA]
    stc_clipArea:SetRectClipOnArea(float2(0, 0), float2(stc_clipArea:GetSizeX(), stc_clipArea:GetSizeY()))
    self._ui.stc_BG[ii]:SetShow(false)
    self._ui.stc_scrollBG[ii] = UI.getChildControl(stc_clipArea, "Static_ScrollBG")
    self._ui.stc_scrollBtn[ii] = UI.getChildControl(self._ui.stc_scrollBG[ii], "Scroll_CtrlButton")
    self:initPool(ii)
  end
  self:registEventHandler()
end
function TooltipInfo:initPool(poolIndex)
  local slotBG = UI.getChildControl(self._ui.stc_components[poolIndex][COMPONENT_TYPE.HEADER], "Static_Icon")
  self._ui.slot_itemIcon[poolIndex] = {}
  local slot = self._ui.slot_itemIcon[poolIndex]
  SlotItem.new(slot, "Slot_ItemIcon", 1, slotBG, _config)
  slot:createChild()
  slot.icon:SetPosX(1)
  slot.icon:SetPosY(1)
  self._ui.stc_socketBG[poolIndex] = {}
  self._ui.stc_socketIcon[poolIndex] = {}
  for ii = 1, socketMaxCount do
    self._ui.stc_socketBG[poolIndex][ii] = UI.getChildControl(self._ui.stc_components[poolIndex][COMPONENT_TYPE.CRYSTAL], "Static_CrystalSlotBg_" .. ii)
    if nil ~= self._ui.stc_socketBG[poolIndex][ii] then
      self._ui.stc_socketIcon[poolIndex][ii] = UI.getChildControl(self._ui.stc_socketBG[poolIndex][ii], "Static_SocketIcon")
    end
  end
  self._ui.txt_mainAttr[poolIndex] = {
    [1] = UI.getChildControl(self._ui.stc_components[poolIndex][COMPONENT_TYPE.MAIN_ATTR], "StaticText_AttackPoint"),
    [2] = UI.getChildControl(self._ui.stc_components[poolIndex][COMPONENT_TYPE.MAIN_ATTR], "StaticText_DefencePoint")
  }
end
function TooltipInfo:registEventHandler()
  _panel:RegisterUpdateFunc("FromClient_TooltipInfo_UpdatePerFrame")
  registerEvent("FromClient_responseTradePrice", "FromClient_responseTradePrice_ItemToolTip")
  registerEvent("FromClient_PadSnapChangeTarget", "FromClient_TooltipInfo_PadSnapChangeTarget")
end
function PaGlobalFunc_TooltipInfo_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_TooltipInfo_Open(tooltipDataType, data, tooltipTargetType, targetX, compareX)
  TooltipInfo:open(tooltipDataType, data, tooltipTargetType, targetX, compareX)
end
function PaGlobalFunc_TooltipInfo_OpenByMyWallet(tooltipDataType, data, tooltipTargetType, targetX, compareX, isMyWallet, enchantKey)
  TooltipInfo:open(tooltipDataType, data, tooltipTargetType, targetX, compareX, isMyWallet, enchantKey)
end
function TooltipInfo:open(tooltipDataType, data, tooltipTargetType, targetX, compareX, isMyWallet, enchantKey)
  if nil == tooltipDataType or nil == data or nil == tooltipTargetType then
    self:close()
    return
  end
  _currentYPos = 50
  _panel:SetShow(true)
  local itemWrapper
  local itemSSW = data
  if Defines.TooltipDataType.ItemWrapper == tooltipDataType then
    itemWrapper = data
    itemSSW = itemWrapper:getStaticStatus()
  end
  local itemType = itemSSW:getItemType()
  self._compareItemWrapper = nil
  for ii = 1, #self._ui.stc_BG do
    self._ui.stc_BG[ii]:SetShow(false)
  end
  _baseRightCompareLeft = true
  if nil == targetX or 0 == targetX then
    _baseRightCompareLeft = false
    targetX = 0
  end
  if CppEnums.ItemType.Equip ~= itemType or Defines.TooltipTargetType.ItemWithoutCompare == tooltipTargetType or true == itemSSW:isVehicleItem() then
  else
    local equipSlotNo = itemSSW:getEquipSlotNo()
    local equipItemWrapper = ToClient_getEquipmentItem(equipSlotNo)
    if nil ~= equipItemWrapper then
      local equipItemSSW = equipItemWrapper:getStaticStatus()
      self._compareItemWrapper = equipItemWrapper
      _currentComponentIsLeftAlign = true == _baseRightCompareLeft
      _equippedItemTooltip = true
      local xPos = 0
      if nil ~= compareX then
        xPos = compareX
      end
      self:compose(equipItemWrapper, equipItemSSW, tooltipTargetType, xPos, isMyWallet, enchantKey)
      PaGlobalFunc_MainStatusInfo_Close()
      PaGlobalFunc_ChattingViewer_Off()
    end
  end
  _currentYPos = _defaultYPos
  _currentComponentIsLeftAlign = false == _baseRightCompareLeft
  _equippedItemTooltip = false
  self:compose(itemWrapper, itemSSW, tooltipTargetType, targetX, isMyWallet, enchantKey)
end
function TooltipInfo:compose(itemWrapper, itemSSW, tooltipTargetType, targetX, isMyWallet, enchantKey)
  if true == _currentComponentIsLeftAlign then
    _currentPool = 1
    self._ui.stc_BG[_currentPool]:SetPosX(targetX)
    self._ui.stc_scrollBG[_currentPool]:SetHorizonLeft()
  else
    _currentPool = 2
    self._ui.stc_BG[_currentPool]:SetPosX(targetX - self._ui.stc_BG[_currentPool]:GetSizeX())
    self._ui.stc_scrollBG[_currentPool]:SetHorizonRight()
  end
  self._ui.stc_BG[_currentPool]:SetShow(true)
  for ii = 1, #self._ui.stc_components[_currentPool] do
    self._ui.stc_components[_currentPool][ii]:SetShow(false)
  end
  self._ui.stc_components[_currentPool][COMPONENT_TYPE.CLIP_AREA]:SetShow(true)
  local yPosInClippingArea = 0
  for ii = 1, #_targetData[tooltipTargetType] do
    if nil ~= _targetData[tooltipTargetType][ii] then
      local componentIndex = _targetData[tooltipTargetType][ii]
      if SPLIT == componentIndex then
        _currentYPos = _currentYPos + 10
      else
        local updateFunc = _componentOption[componentIndex].fillDataFunc
        if nil ~= updateFunc and "function" == type(updateFunc) then
          local componentHaveValidData = updateFunc(itemWrapper, itemSSW, tooltipTargetType, isMyWallet, enchantKey)
          if true == componentHaveValidData then
            local component = self._ui.stc_components[_currentPool][componentIndex]
            component:SetShow(true)
            if not _componentOption[componentIndex].bottomAlign then
              if not _componentOption[componentIndex].isInsideClippingArea then
                component:SetPosY(_currentYPos)
                _currentYPos = _currentYPos + component:GetSizeY() + _defaultGapBetweenComponent
              else
                component:SetPosY(yPosInClippingArea)
                yPosInClippingArea = yPosInClippingArea + component:GetSizeY() + _defaultGapBetweenComponent
              end
            end
            if _componentOption[componentIndex].cornerAlign then
              if _currentComponentIsLeftAlign then
                component:SetHorizonLeft()
              else
                component:SetHorizonRight()
              end
              component:ComputePos()
            else
              local xPos = _rightAlignDefaultX
              if _currentComponentIsLeftAlign then
                xPos = _leftAlignDefaultX
              end
              component:SetPosX(xPos)
            end
            if componentIndex == COMPONENT_TYPE.HEADER then
              local txt_name = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.HEADER], "StaticText_ItemName")
              local tempSizeY = (txt_name:GetTextSizeY() - txt_name:GetSizeY()) / 2
              if tempSizeY > 0 then
                self._ui.stc_components[_currentPool][COMPONENT_TYPE.TYPE]:SetPosY(self._ui.stc_components[_currentPool][COMPONENT_TYPE.TYPE]:GetPosY() - tempSizeY)
                _currentYPos = _currentYPos + tempSizeY
              end
            end
          end
        end
      end
    end
  end
  if yPosInClippingArea > _clipAreaYSize then
    self._ui.stc_scrollContent[_currentPool]:SetSize(_defaultSizeX, yPosInClippingArea)
    self._ui.stc_scrollContent[_currentPool]:SetPosY(0)
    self._ui.stc_scrollBtn[_currentPool]:SetPosY(-(self._ui.stc_scrollBtn[_currentPool]:GetSizeY() * 0.5))
    self._ui.stc_scrollBG[_currentPool]:SetShow(true)
  else
    self._ui.stc_scrollBG[_currentPool]:SetShow(false)
  end
end
function PaGlobalFunc_TooltipInfo_Close()
  TooltipInfo:close()
end
function TooltipInfo:close()
  _panel:SetShow(false)
  PaGlobalFunc_MainStatusInfo_Open()
  if false == PaGlobal_TutorialManager:isDoingTutorial() then
    PaGlobalFunc_ChattingViewer_On()
  end
  self._compareItemWrapper = nil
end
local colorTable = {
  [0] = Defines.Color.C_FFEEEEEE,
  [1] = Defines.Color.C_FF8DB245,
  [2] = Defines.Color.C_FF309BF5,
  [3] = Defines.Color.C_FFF0D147,
  [4] = Defines.Color.C_FFFF6244
}
local self = TooltipInfo
function TooltipInfo_updateTYPE(itemWrapper, itemSSW, tooltipTargetType)
  local txtType = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.TYPE], "StaticText_Equipped")
  local item_type = itemSSW:getItemType()
  local isTradeItem = itemSSW:isTradeAble()
  if item_type == 1 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_EQUIPMENT"))
  elseif item_type == 2 then
    if isTradeItem == true then
      txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
    else
      txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_CONSUME"))
    end
  elseif item_type == 3 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TENT_TOOL"))
  elseif item_type == 4 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_INSTALL_TOOL"))
  elseif item_type == 5 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_SOCKET_ITEM"))
  elseif item_type == 6 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_CANNONBALL"))
  elseif item_type == 7 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_LICENCE"))
  elseif item_type == 8 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCTION"))
  elseif item_type == 9 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ENTER_AIR"))
  elseif item_type == 10 then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_SPECIAL_PRODUCTION"))
  elseif true == itemSSW:get():isForJustTrade() then
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL") .. "/" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
  else
    txtType:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOMAL"))
  end
  if item_type == 8 and true == itemSSW:get():isForJustTrade() then
    txtType:SetText(txtType:GetText() .. "/" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_ITEM"))
  end
  if nil == txtType:GetText() or "" == txtType:GetText() then
    return false
  else
    return true
  end
end
function TooltipInfo_updateHEADER(itemWrapper, itemSSW, tooltipTargetType)
  local slotBG = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.HEADER], "Static_Icon")
  local txt_name = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.HEADER], "StaticText_ItemName")
  local uv = _slotBGUV[2]
  if _equippedItemTooltip then
    uv = _slotBGUV[1]
  end
  slotBG:ChangeTextureInfoName("renewal/frame/console_frame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(slotBG, uv[1], uv[2], uv[3], uv[4])
  slotBG:getBaseTexture():setUV(x1, y1, x2, y2)
  slotBG:setRenderTexture(slotBG:getBaseTexture())
  txt_name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local nameColorGrade = itemSSW:getGradeType()
  local fontColor = colorTable[0]
  if nil ~= colorTable[nameColorGrade] then
    fontColor = colorTable[nameColorGrade]
  end
  txt_name:SetFontColor(fontColor)
  txt_name:SetText(itemSSW:getName())
  self._ui.slot_itemIcon[_currentPool]:setItemByStaticStatus(itemSSW)
  return true
end
function TooltipInfo_updateCRYSTAL(itemWrapper, itemSSW, tooltipTargetType)
  local socketMaxCount = ToClient_GetMaxItemSocketCount()
  local slotCount = 0
  if false == itemSSW:get():getEnchant():empty() then
    slotCount = itemSSW:get():getEnchant()._socketCount
  end
  for ii = 1, socketMaxCount do
    if ii <= slotCount then
      self._ui.stc_socketBG[_currentPool][ii]:SetShow(true)
      if nil ~= itemWrapper then
        local crystalESSW = itemWrapper:getPushedItem(ii - 1)
        if nil ~= crystalESSW then
          self._ui.stc_socketIcon[_currentPool][ii]:SetShow(true)
          self._ui.stc_socketIcon[_currentPool][ii]:ChangeTextureInfoName("icon/" .. crystalESSW:getIconPath())
          local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_socketIcon[_currentPool][ii], 0, 0, 42, 42)
          self._ui.stc_socketIcon[_currentPool][ii]:getBaseTexture():setUV(x1, y1, x2, y2)
          self._ui.stc_socketIcon[_currentPool][ii]:setRenderTexture(self._ui.stc_socketIcon[_currentPool][ii]:getBaseTexture())
        else
          self._ui.stc_socketIcon[_currentPool][ii]:SetShow(false)
        end
      end
    else
      self._ui.stc_socketBG[_currentPool][ii]:SetShow(false)
    end
  end
  return true
end
function TooltipInfo_updateMAIN_ATTR(itemWrapper, itemSSW, tooltipTargetType)
  self._ui.txt_mainAttr[_currentPool][1]:SetShow(false)
  self._ui.txt_mainAttr[_currentPool][2]:SetShow(false)
  local itemaddedDD = 0
  local itemaddedDV = 0
  local itemaddedPV = 0
  if nil ~= itemWrapper then
    itemaddedDD = itemWrapper:getAddedDD()
    itemaddedDV = itemWrapper:getAddedDV()
    itemaddedPV = itemWrapper:getAddedPV()
  end
  local lowestAttackVal = 0
  local highestAttackVal = 0
  for ii = 0, 2 do
    local currentMin = itemSSW:getMinDamage(ii)
    lowestAttackVal = math.max(lowestAttackVal, currentMin)
    local currentMax = itemSSW:getMaxDamage(ii)
    highestAttackVal = math.max(highestAttackVal, currentMax)
  end
  if 1 == itemSSW:getItemType() and 36 == itemSSW:getEquipType() then
    lowestAttackVal = itemSSW:getMinDamage(0)
    highestAttackVal = itemSSW:getMaxDamage(0)
  end
  lowestAttackVal = lowestAttackVal + itemaddedDD
  highestAttackVal = highestAttackVal + itemaddedDD
  local componentHaveValidData = false
  if 0 ~= lowestAttackVal or 0 ~= highestAttackVal then
    componentHaveValidData = true
    self._ui.txt_mainAttr[_currentPool][1]:SetShow(true)
    local attackString = tostring(lowestAttackVal) .. " ~ " .. tostring(highestAttackVal)
    self._ui.txt_mainAttr[_currentPool][1]:SetText(attackString)
  end
  local defValue = 0
  for idx = 0, 2 do
    local currentdef_value = itemSSW:getDefence(idx) + itemaddedDV + itemaddedPV
    defValue = math.max(defValue, currentdef_value)
  end
  if 0 ~= defValue then
    componentHaveValidData = true
    self._ui.txt_mainAttr[_currentPool][2]:SetShow(true)
    self._ui.txt_mainAttr[_currentPool][2]:SetText(tostring(defValue))
    if self._ui.txt_mainAttr[_currentPool][1]:GetShow() then
      self._ui.txt_mainAttr[_currentPool][2]:SetPosX(180)
    else
      self._ui.txt_mainAttr[_currentPool][2]:SetPosX(0)
    end
  end
  return componentHaveValidData
end
function TooltipInfo_updateSUB_ATTR(itemWrapper, itemSSW, tooltipTargetType)
  local contentString = ""
  local hit = 0
  local hitShow = false
  for idx = 0, 2 do
    local currentHit = itemSSW:ToClient_getHit(idx)
    hit = math.max(hit, currentHit)
  end
  if nil ~= itemWrapper then
    hit = hit + itemWrapper:getAddedHIT()
  end
  if 1 == itemSSW:getItemType() and 36 == itemSSW:getEquipType() then
    hit = itemSSW:ToClient_getHit(0)
  end
  if 0 ~= hit then
    contentString = PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_ITEM_TXT_HIT") .. " " .. tostring(hit)
  end
  local dv = 0
  local hdv = 0
  local dvShow = false
  for idx = 0, 2 do
    local currnetDv = itemSSW:ToClient_getDV(idx)
    dv = math.max(dv, currnetDv)
    local currentHDV = itemSSW:ToClient_getHDV(idx)
    hdv = math.max(hdv, currentHDV)
  end
  local itemaddedHDV = 0
  if nil ~= itemWrapper then
    dv = dv + itemWrapper:getAddedDV()
    itemaddedHDV = itemWrapper:getCronHDV()
  end
  if dv + hdv + itemaddedHDV > 0 then
    if contentString ~= "" then
      contentString = contentString .. "\n"
    end
    contentString = contentString .. PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_ITEMEQUIP_TXT_DV") .. " " .. tostring(dv) .. " (+" .. tostring(hdv + itemaddedHDV) .. ")"
  end
  local pv = 0
  local hpv = 0
  for idx = 0, 2 do
    local currentPv = itemSSW:ToClient_getPV(idx)
    if pv < currentPv then
      pv = currentPv
    end
    local currentHPv = itemSSW:ToClient_getHPV(idx)
    if hpv < currentHPv then
      hpv = currentHPv
    end
  end
  local itemaddedHPV = 0
  if nil ~= itemWrapper then
    local itemaddedPV = itemWrapper:getAddedPV()
    pv = pv + itemaddedPV
    itemaddedHPV = itemWrapper:getCronHPV()
  end
  if pv + hpv + itemaddedHPV > 0 then
    if contentString ~= "" then
      contentString = contentString .. "\n"
    end
    contentString = contentString .. PAGetString(Defines.StringSheet_RESOURCE, "TOOLTIP_ITEM_TXT_PV") .. " " .. tostring(pv) .. " (+" .. tostring(hpv + itemaddedHPV) .. ")"
  end
  local txt = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.SUB_ATTR], "StaticText_Content")
  local componentIsShow = false
  if "" ~= contentString then
    txt:SetShow(true)
    txt:SetText(contentString)
    componentIsShow = true
    self._ui.stc_components[_currentPool][COMPONENT_TYPE.SUB_ATTR]:SetSize(_defaultSizeX, txt:GetTextSizeY())
  else
    txt:SetShow(false)
  end
  return componentIsShow
end
function TooltipInfo_updateENCHANT_TYPE(itemWrapper, itemSSW, tooltipTargetType)
  local componentIsShow = false
  local isPossibleToEnchant = itemSSW:get():isEnchantable()
  local content = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.ENCHANT_TYPE], "StaticText_Content")
  if true == isPossibleToEnchant then
    local enchantDifficulty = itemSSW:get():getEnchantDifficulty()
    if enchantDifficulty > __eEnchantDifficulty_None then
      if __eEnchantDifficulty_Easy == enchantDifficulty then
        componentIsShow = true
        content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_EASY"))
      elseif __eEnchantDifficulty_Normal == enchantDifficulty then
        componentIsShow = true
        content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_NORMAL"))
      elseif __eEnchantDifficulty_Hard == enchantDifficulty or __eEnchantDifficulty_NotExtractHard == enchantDifficulty then
        componentIsShow = true
        content:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ENCHANTDIFFICULTY_HARD"))
      end
    end
  elseif itemSSW:isEquipable() then
    componentIsShow = true
    content:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_ENCHANT"))
  end
  return componentIsShow
end
function TooltipInfo_updateDESCRIPTION(itemWrapper, itemSSW, tooltipTargetType)
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TITLE") .. " " .. itemSSW:getDescription()
  local item_type = itemSSW:getItemType()
  local isNodeFreeTrade = itemSSW:get():isNodeFreeTrade()
  if isNodeFreeTrade then
    desc = desc .. " " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_TOOLTIP_ITEM_NODEFREETRADE_DESC")
  end
  if item_type == 2 and true == itemSSW:get():isForJustTrade() then
    desc = desc .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_DESC_TRADEITEM")
  end
  local isAllClass = true
  local classNameList
  for idx = 0, getCharacterClassCount() - 1 do
    local itemClassType = getCharacterClassTypeByIndex(idx)
    local className = getCharacterClassName(itemClassType)
    if nil ~= className and "" ~= className and " " ~= className then
      if itemSSW:get()._usableClassType:isOn(itemClassType) then
        if nil == classNameList then
          classNameList = className
        else
          classNameList = classNameList .. ", " .. className
        end
      else
        isAllClass = false
      end
    end
  end
  if false == isAllClass and nil ~= classNameList then
    local characterClassType = getSelfPlayer():getClassType()
    local isUsableClass = itemSSW:get()._usableClassType:isOn(characterClassType)
    if nil ~= classNameList then
      if isUsableClass == false then
        desc = desc .. [[


<PAColor0xFFF26A6A>- ]] .. classNameList .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CLASSONLY") .. "<PAOldColor>"
      else
        desc = desc .. [[


- ]] .. classNameList .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CLASSONLY")
      end
    end
  end
  if "" ~= itemSSW:getEnchantDescription() then
    desc = desc .. [[


- ]] .. itemSSW:getEnchantDescription()
  end
  local content = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.DESCRIPTION], "StaticText_Content")
  content:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  content:SetText(desc)
  self._ui.stc_components[_currentPool][COMPONENT_TYPE.DESCRIPTION]:SetSize(_defaultSizeX, content:GetTextSizeY())
  return "" ~= desc
end
function TooltipInfo_updateDYEING_INFO(itemWrapper, itemSSW, tooltipTargetType)
end
function TooltipInfo_updateUSE_LIMIT(itemWrapper, itemSSW, tooltipTargetType)
  local content = self._ui.stc_components[_currentPool][COMPONENT_TYPE.USE_LIMIT]
  local txt = UI.getChildControl(content, "StaticText_Content")
  local minLevel = itemSSW:get()._minLevel
  local isExistMaxLevel = itemSSW:get():isMaxLevelRestricted()
  local myInfo = getSelfPlayer()
  local myLevel = myInfo:get():getLevel()
  local minLevelString = tostring(minLevel)
  local jewelLevel = 0
  local maxLevel = itemSSW:get()._maxLevel
  local maxLevelString = tostring(maxLevel)
  local item
  txt:SetText("")
  txt:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  if nil ~= itemWrapper then
    item = itemWrapper:get()
  end
  if not isSSW then
    if nil ~= item then
      jewelLevel = item:getJewelValidLevel()
    end
    if 0 ~= jewelLevel then
      minLevelString = minLevelString .. "(" .. tostring(minLevel + jewelLevel) .. ")"
    end
  end
  if isExistMaxLevel == true then
    if not isSSW and 0 ~= jewelLevel then
      maxLevelString = maxLevelString .. "(" .. tostring(maxLevel + jewelLevel) .. ")"
    end
    txt:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_LIMIT", "minLevel", minLevelString, "maxLevel", maxLevelString))
    if myLevel < maxLevel then
      txt:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
  elseif minLevel > 1 then
    if minLevel > myLevel then
      txt:SetFontColor(Defines.Color.C_FFF26A6A)
    else
      txt:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
    txt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USEITEM_FROM", "limitLevel", minLevelString))
  end
  local craftType
  local gather = 0
  fishing = 1
  hunting = 2
  cooking = 3
  alchemy = 4
  manufacture = 5
  training = 6
  trade = 7
  local lifeminLevel = 0
  local lifeType = {
    [0] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GATHERING"),
    [1] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_FISHING"),
    [2] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HUNTING"),
    [3] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_COOKING"),
    [4] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_ALCHEMY"),
    [5] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PROCESSING"),
    [6] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_OBEDIENCE"),
    [7] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE"),
    [8] = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_GROWTH")
  }
  local craftType = itemSSW:get():getLifeExperienceType()
  local lifeminLevel = itemSSW:get():getLifeMinLevel(craftType)
  if lifeminLevel > 0 then
    local myLifeLevel = myInfo:get():getLifeExperienceLevel(craftType)
    txt:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "PANEL_TOOLTIP_USELIMIT_LEVEL_VALUE", "craftType", lifeType[craftType], "lifeminLevel", PaGlobalFunc_CharacterLifeInfo_CraftLevel_Replace(lifeminLevel, craftType)))
    if lifeminLevel > myLifeLevel then
      txt:SetFontColor(Defines.Color.C_FFF26A6A)
    else
      txt:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
  end
  content:SetSize(_defaultSizeX, txt:GetTextSizeY())
  return "" ~= txt:GetText()
end
function TooltipInfo_updateTIME_LIMIT(itemWrapper, itemSSW, tooltipTargetType)
  if nil == itemWrapper then
    return false
  end
  local item = itemWrapper:get()
  if nil == item or item:getExpirationDate():isIndefinite() then
    return false
  end
  local txt = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.TIME_LIMIT], "StaticText_Content")
  local s64_remainingTime = getLeftSecond_s64(item:getExpirationDate())
  local fontColor = Defines.Color.C_FFEEEEEE
  local itemExpiration = item:getExpirationDate()
  local leftPeriod = FromClient_getTradeItemExpirationDate(itemExpiration, itemWrapper:getStaticStatus():get()._expirationPeriod)
  local frontStr = ""
  if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
    frontStr = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_PRICEREMAIN")
  else
    frontStr = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_REMAINTIME_REMAINTIME")
  end
  local backStr = ""
  if Defines.s64_const.s64_0 == s64_remainingTime then
    if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
      backStr = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME") .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)"
    else
      backStr = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME")
    end
    fontColor = Defines.Color.C_FFBA2737
  elseif not itemSSW:get():isCash() and itemSSW:isTradeAble() then
    backStr = convertStringFromDatetime(s64_remainingTime) .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)"
  else
    backStr = convertStringFromDatetime(s64_remainingTime)
  end
  txt:SetText(frontStr .. "\n" .. backStr)
  self._ui.stc_components[_currentPool][COMPONENT_TYPE.TIME_LIMIT]:SetSize(_defaultSizeX, txt:GetTextSizeY())
  txt:SetFontColor(fontColor)
  txt:SetShow(true)
  return true
end
function TooltipInfo_updateCAPACITY(itemWrapper, itemSSW, tooltipTargetType, isMyWallet, enchantKey)
  if nil == isMyWallet or false == isMyWallet or nil == enchantKey then
    if nil == itemWrapper then
      return false
    end
    local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
    if false == isAble then
      return false
    end
  else
    local isAble = requestIsRegisterItemForItemMarket(enchantKey)
    if false == isAble then
      return false
    end
  end
  local component = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.CAPACITY], "Static_CapacityIcon")
  local title = UI.getChildControl(self._ui.stc_components[_currentPool][COMPONENT_TYPE.CAPACITY], "StaticText_CapacityTitle")
  title:SetText("- " .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_CARRYING_CAPACITY"))
  local str_itemWeight = string.format("%.2f", Int64toInt32(itemSSW:getWorldMarketVolume()) / 10)
  component:SetText(str_itemWeight)
  return true
end
local _tradeInfoDataSlot = {}
function TooltipInfo_updateITEM_MARKET_INFO(itemWrapper, itemSSW, tooltipTargetType, isMyWallet, enchantKey)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.ITEM_MARKET_INFO]
  if nil == isMyWallet or false == isMyWallet or nil == enchantKey then
    if nil == itemWrapper then
      return false
    end
    local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
    if false == isAble then
      return false
    end
  else
    local isAble = requestIsRegisterItemForItemMarket(enchantKey)
    if false == isAble then
      return false
    end
  end
  local stc_construction = UI.getChildControl(component, "Static_Construction")
  local txt_valuePrice = UI.getChildControl(component, "StaticText_Content_Value")
  local stc_coinImage = UI.getChildControl(txt_valuePrice, "Static_SilverIcon")
  local itemKey = itemSSW:get()._key:getItemKey()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local enchantKey = ItemEnchantKey(itemKey, enchantLevel)
  local enchantKeyRaw = enchantKey:get()
  _tradeInfoDataSlot[_currentPool] = {}
  _tradeInfoDataSlot[_currentPool].txt_valuePrice = txt_valuePrice
  _tradeInfoDataSlot[_currentPool].pendingAnimation = stc_construction
  _tradeInfoDataSlot[_currentPool].coin = stc_coinImage
  _tradeInfoDataSlot[_currentPool].enchantKeyRaw = enchantKeyRaw
  stc_construction:SetShow(true)
  txt_valuePrice:SetShow(false)
  ToClient_getWorldMarketTradePrice(enchantKeyRaw)
  self._ui.stc_components[_currentPool][COMPONENT_TYPE.ITEM_MARKET_INFO]:SetSize(_defaultSizeX, stc_construction:GetPosY() + stc_construction:GetSizeY())
  return true
end
function FromClient_responseTradePrice_ItemToolTip(price, key, enchantLevel)
  if nil == key or nil == enchantLevel then
    return
  end
  local enchantKey = ItemEnchantKey(key, enchantLevel)
  local enchantKeyRaw = enchantKey:get()
  for ii = 1, 2 do
    if nil ~= _tradeInfoDataSlot[ii] and enchantKeyRaw == _tradeInfoDataSlot[ii].enchantKeyRaw then
      local txt = _tradeInfoDataSlot[ii].txt_valuePrice
      txt:SetShow(true)
      _tradeInfoDataSlot[ii].pendingAnimation:SetShow(false)
      if price <= Defines.s64_const.s64_0 then
        txt:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKET_PLACE_NO_PRICE_INFO"))
      else
        txt:SetText(makeDotMoney(price))
      end
      _tradeInfoDataSlot[ii].coin:SetPosX(txt:GetSizeX() - txt:GetTextSizeX() - 25)
    end
  end
end
function TooltipInfo_updateEXTRACTION_INFO(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.EXTRACTION_INFO]
  local content = UI.getChildControl(component, "StaticText_Content")
  local balksCount = itemSSW:getExtractionCount_s64()
  local cronsCount = itemSSW:getCronCount_s64()
  local isExtractable = false
  if nil ~= balksCount and balksCount > toInt64(0, 0) then
    content:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_BALKS_EXTRACTION", "balksCount", Int64toInt32(balksCount)))
    isExtractable = true
  end
  if nil ~= cronsCount and cronsCount > toInt64(0, 0) then
    local cronText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMTOOLTIP_CRONS_EXTRACTION", "cronsCount", Int64toInt32(cronsCount))
    if true == isExtractable then
      cronText = content:GetText() .. "\n" .. cronText
    end
    content:SetText(cronText)
    isExtractable = true
  end
  if true == isExtractable then
    component:SetSize(_defaultSizeX, content:GetTextSizeY())
  end
  return isExtractable
end
function TooltipInfo_updateEXPERIENCE(itemWrapper, itemSSW, tooltipTargetType)
  if nil == itemWrapper then
    return false
  end
  local itemContentsType = itemWrapper:getStaticStatus():get():getContentsEventType()
  if 32 ~= itemContentsType and 37 ~= itemContentsType then
    return false
  end
  local alchemyStoneType = itemWrapper:getStaticStatus():get()._contentsEventParam1
  if alchemyStoneType > 2 then
    return false
  end
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.EXPERIENCE]
  local stc_bg = UI.getChildControl(component, "Static_ExperienceProgressBg")
  local progress_experience = UI.getChildControl(stc_bg, "Progress2_Experience")
  local progress_dynamicExperience = UI.getChildControl(stc_bg, "Progress2_Dynamic")
  local txt_experience = UI.getChildControl(stc_bg, "StaticText_ExperienceValue")
  local maxExperience = 10000
  local dynamicMaxExperience = itemWrapper:getExperience()
  local alchemystoneExp = dynamicMaxExperience / maxExperience
  progress_experience:SetCurrentProgressRate(alchemystoneExp * 100)
  progress_experience:SetProgressRate(alchemystoneExp * 100)
  progress_experience:SetAniSpeed(0)
  progress_dynamicExperience:SetCurrentProgressRate(alchemystoneExp * 100)
  progress_dynamicExperience:SetProgressRate(alchemystoneExp * 100)
  progress_dynamicExperience:SetAniSpeed(0)
  txt_experience:SetText(string.format("%.2f", alchemystoneExp) .. "%")
  return true
end
function TooltipInfo_updateENDURANCE(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.ENDURANCE]
  local stc_bg = UI.getChildControl(component, "Static_EnduranceProgressBg")
  local progress_endurance = UI.getChildControl(stc_bg, "Progress2_Endurance")
  local progress_dynamicEndurance = UI.getChildControl(stc_bg, "Progress2_Dynamic")
  local txt_enduranceValue = UI.getChildControl(stc_bg, "StaticText_EnduranceValue")
  local maxEndurance = 32767
  local dynamicMaxEndurance = 32767
  if false == itemSSW:get():isUnbreakable() then
    maxEndurance = itemSSW:get():getMaxEndurance()
  end
  local currentEndurance = maxEndurance
  if nil ~= itemWrapper then
    dynamicMaxEndurance = itemWrapper:get():getMaxEndurance()
    currentEndurance = itemWrapper:get():getEndurance()
  end
  local calcEndurance = currentEndurance / maxEndurance
  local calcDynamicEndurance = dynamicMaxEndurance / maxEndurance
  progress_endurance:SetCurrentProgressRate(calcEndurance * 100)
  progress_endurance:SetProgressRate(calcEndurance * 100)
  progress_endurance:SetAniSpeed(0)
  progress_dynamicEndurance:SetCurrentProgressRate(calcDynamicEndurance * 100)
  progress_dynamicEndurance:SetProgressRate(calcDynamicEndurance * 100)
  progress_dynamicEndurance:SetAniSpeed(0)
  if 32767 ~= dynamicMaxEndurance then
    txt_enduranceValue:SetText(currentEndurance .. " / " .. dynamicMaxEndurance .. "  [" .. maxEndurance .. "]")
  elseif 32767 ~= maxEndurance then
    txt_enduranceValue:SetText(currentEndurance .. " / " .. maxEndurance)
  else
    return false
  end
  local check_fishingRod = function(itemKey)
    if 17591 == itemKey or 17592 == itemKey or 17596 == itemKey or 17612 == itemKey or 17613 == itemKey or 17669 == itemKey then
      return true
    else
      return false
    end
  end
  local isCash = itemSSW:get():isCash()
  if true == isCash and false == check_fishingRod(itemSSW:get()._key:getItemKey()) then
    return false
  end
  return true
end
function TooltipInfo_updateWEIGHT_PRICE(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.WEIGHT_PRICE]
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local isTradeItem = itemSSW:isTradeAble()
  local s64_originalPrice = itemSSW:get()._originalPrice_s64
  local s64_sellPrice = itemSSW:get()._sellPriceToNpc_s64
  local txt_price = UI.getChildControl(component, "StaticText_Price")
  if isTradeItem then
    if s64_originalPrice > Defines.s64_const.s64_0 and 0 == enchantLevel then
      local text = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_OriginalPrice", "OriginalPrice", makeDotMoney(s64_originalPrice))
      txt_price:SetText(text)
      txt_price:SetFontColor(4292726146)
    else
      txt_price:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM"))
      txt_price:SetFontColor(4290733156)
    end
  elseif s64_sellPrice > Defines.s64_const.s64_0 and 0 == enchantLevel then
    txt_price:SetText(PAGetString(Defines.StringSheet_RESOURCE, "UI_TOOLTIP_ITEM_SELLPRICE") .. " " .. makeDotMoney(s64_sellPrice))
    txt_price:SetFontColor(4292726146)
  else
    txt_price:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOT_SELLING_ITEM"))
    txt_price:SetFontColor(4290733156)
  end
  txt_price:SetPosX(_defaultSizeX - txt_price:GetTextSizeX() - txt_price:GetTextSpan().x)
  local weightVal = itemSSW:get()._weight
  local txt_weight = UI.getChildControl(component, "StaticText_Weight")
  txt_weight:SetShow(true)
  local calcWeight = weightVal / 10000
  txt_weight:SetText(string.format("%.2f", calcWeight) .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
  txt_weight:SetPosX(txt_price:GetPosX() - txt_weight:GetTextSizeX() - txt_weight:GetTextSpan().x - 15)
  if itemSSW:get():isCash() then
    txt_weight:SetShow(false)
  end
  return true
end
function TooltipInfo_updatePRODUCTION_REGION(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.PRODUCTION_REGION]
  local txt = UI.getChildControl(component, "StaticText_Content")
  txt:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local isNodeFreeTrade = itemSSW:get():isNodeFreeTrade()
  if true == itemSSW:get():isForJustTrade() and nil ~= itemWrapper then
    local nodeLevel = ToClient_GetNodeLevel(itemWrapper:getProductionRegionKey())
    if isNodeFreeTrade then
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion())
    elseif nodeLevel >= 1 then
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion() .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_LINK") .. ")")
    else
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_PRODUCT_PLACE") .. " : " .. itemWrapper:getProductionRegion() .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOLINK") .. ")")
    end
  else
    return false
  end
  component:SetSize(_defaultSizeX, txt:GetTextSizeY())
  return true
end
function TooltipInfo_updateTRADE_PRICE(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.TRADE_PRICE]
  local txt = UI.getChildControl(component, "StaticText_Content")
  local isTradeItem = itemSSW:isTradeAble()
  if true == isTradeItem and nil ~= itemWrapper then
    local item = itemWrapper:get()
    local text = PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_TRADE_BUY_PRICE")
    if nil ~= item then
      if item:getBuyingPrice_s64() > Defines.s64_const.s64_0 then
        text = text .. " : <PAColor0xFFEEEEEE>" .. PAGetString(Defines.StringSheet_GAME, "LUA_AUCTION_GOLDTEXT") .. " " .. makeDotMoney(item:getBuyingPrice_s64()) .. "<PAOldColor>"
      else
        text = text .. " : <PAColor0xFFBA2737>" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_NOTHING") .. "<PAOldColor>"
      end
      txt:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      txt:SetText(text)
    end
  else
    return false
  end
  component:SetSize(_defaultSizeX, txt:GetTextSizeY())
  return true
end
function TooltipInfo_updateVESTED(itemWrapper, itemSSW, tooltipTargetType)
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.VESTED]
  local txt = UI.getChildControl(component, "StaticText_Content")
  txt:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local itemBindType = itemSSW:get()._vestedType:getItemKey()
  if nil ~= itemWrapper then
    local item = itemWrapper:get()
    if item:isVested() then
      if itemSSW:isUserVested() then
        txt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED_FAMILYACOUNT"))
      else
        txt:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_HOLDED"))
      end
      txt:SetShow(true)
      component:SetSize(_defaultSizeX, txt:GetTextSizeY())
      return true
    end
  elseif itemBindType == 1 then
    if isSSW and itemSSW:isUserVested() then
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_FAMILY"))
      txt:SetShow(true)
    else
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_GETBIND_CHARACTER"))
      txt:SetShow(true)
    end
    component:SetSize(_defaultSizeX, txt:GetTextSizeY())
  elseif itemBindType == 2 then
    if isSSW and itemSSW:isUserVested() then
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_FAMILY"))
      txt:SetShow(true)
    else
      txt:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_ITEM_EQUIPBIND_CHARACTER"))
      txt:SetShow(true)
    end
    component:SetSize(_defaultSizeX, txt:GetTextSizeY())
  else
    return false
  end
  return false
end
function TooltipInfo_updateLINE_SPLIT()
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.LINE_SPLIT]
  local stc_left = UI.getChildControl(component, "Static_Left")
  local stc_right = UI.getChildControl(component, "Static_Right")
  if _currentComponentIsLeftAlign then
    stc_left:SetShow(true)
    stc_right:SetShow(false)
    stc_left:SetPosX(-component:GetPosX())
  else
    stc_left:SetShow(false)
    stc_right:SetShow(true)
    stc_right:SetPosX(component:GetSizeX() - stc_right:GetSizeX() + 33)
  end
  return true
end
function TooltipInfo_updateEXCHANGE_INFO(itemWrapper, itemSSW)
  if false == itemSSW:isExchangeItem() then
    return false
  end
  local component = self._ui.stc_components[_currentPool][COMPONENT_TYPE.EXCHANGE_INFO]
  local desc = UI.getChildControl(component, "StaticText_Content")
  desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  desc:SetText(itemSSW:getExchangeDescription())
  component:SetSize(_defaultSizeX, desc:GetTextSizeY())
  return true
end
function FromClient_TooltipInfo_PadSnapChangeTarget(fromControl, toControl)
  TooltipInfo:close()
end
local scrollSpeed = 2
function FromClient_TooltipInfo_UpdatePerFrame(deltaTime)
  local self = TooltipInfo
  if true == isPadPressed(__eJoyPadInputType_X) then
    if true == isPadPressed(__eJoyPadInputType_DPad_Down) then
      for ii = 1, self._poolCount do
        if self._ui.stc_scrollBG[ii]:GetShow() then
          local currentY = self._ui.stc_scrollContent[ii]:GetPosY()
          local currentYSize = self._ui.stc_scrollContent[ii]:GetSizeY()
          self._ui.stc_scrollContent[ii]:SetPosY(math.max(_clipAreaYSize - currentYSize, currentY - scrollSpeed))
          self._ui.stc_scrollBtn[ii]:SetPosY(currentY / (_clipAreaYSize - currentYSize) * 610 - 22)
        end
      end
    elseif true == isPadPressed(__eJoyPadInputType_DPad_Up) then
      for ii = 1, self._poolCount do
        if self._ui.stc_scrollBG[ii]:GetShow() then
          local currentY = self._ui.stc_scrollContent[ii]:GetPosY()
          local currentYSize = self._ui.stc_scrollContent[ii]:GetSizeY()
          self._ui.stc_scrollContent[ii]:SetPosY(math.min(0, currentY + scrollSpeed))
          self._ui.stc_scrollBtn[ii]:SetPosY(currentY / (_clipAreaYSize - currentYSize) * 610 - 22)
        end
      end
    end
  end
end
