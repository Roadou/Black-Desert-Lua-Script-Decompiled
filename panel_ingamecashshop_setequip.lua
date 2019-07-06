local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local UI_PreviewType = CppEnums.InGameCashShopPreviewType
local CT = CppEnums.ClassType
local UI_CCC = CppEnums.CashProductCategory
Panel_IngameCashShop_SetEquip:SetShow(false)
local awakenWeaponContentsOpen = ToClient_IsContentsGroupOpen("901")
local isCouponOpen = ToClient_IsContentsGroupOpen("224")
local isStampCouponOpen = ToClient_IsContentsGroupOpen("308")
local CashShopSetEquip = {
  BTN_BuyAll = UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_BuyAll"),
  BTN_Exit = UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_Exit"),
  BTN_QNA = UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_QNA"),
  SlotUIPool = {},
  beforProductNoRaw = -1,
  nowProductNoRaw = -1,
  beforSetClass = -1,
  nowSetClass = -1,
  serventType = {
    horse = 0,
    ship = 1,
    carriage = 2
  },
  hasServantType = -1,
  SetEquipSlotNo = {
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    13,
    25
  },
  SetCharacterEquipName = {
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BODY"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HANDS"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BOOTS"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HELM"),
    [18] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_MAINHANDS"),
    [19] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUBHANDS"),
    [20] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_UNDERWEAR"),
    [21] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EARING"),
    [22] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EYE"),
    [23] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_MOUTH"),
    [13] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LAMPLIGHT"),
    [25] = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_NAME")
  },
  SetHorseEquipName = {
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_BARD"),
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SADDLE"),
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_STIRRUP"),
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HORSEHEAD"),
    [18] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"),
    [19] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"),
    [20] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"),
    [21] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"),
    [22] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT"),
    [23] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EMPTYSLOT")
  },
  SetCarriageEquipName = {
    [14] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "14",
    [15] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "15",
    [16] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "16",
    [17] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "17",
    [18] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "18",
    [19] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "19",
    [20] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "20",
    [21] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "21",
    [22] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "22",
    [23] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CARRIAGEAVATAR") .. "23"
  }
}
local TemplateSetEquip = {
  ItemBG = UI.getChildControl(Panel_IngameCashShop_SetEquip, "Static_ItemBG"),
  ItemName = UI.getChildControl(Panel_IngameCashShop_SetEquip, "StaticText_ItemName"),
  BTN_UnSet = UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_UnSet")
}
local savedProductNo = -1
function CashShopSetEquip:Initialize()
  local startPosY = 40
  local slotYGap = 32
  local sizeY = 0
  for index, value in pairs(self.SetEquipSlotNo) do
    local tempSlot = {}
    local CreateItemBG = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_IngameCashShop_SetEquip, "CashShop_SetEquip_ItemBG_" .. value)
    CopyBaseProperty(TemplateSetEquip.ItemBG, CreateItemBG)
    CreateItemBG:SetPosX(10)
    CreateItemBG:SetPosY(startPosY)
    CreateItemBG:SetShow(false)
    tempSlot.ItemBG = CreateItemBG
    local CreateItemName = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, CreateItemBG, "CashShop_SetEquip_ItemName_" .. value)
    CopyBaseProperty(TemplateSetEquip.ItemName, CreateItemName)
    CreateItemName:SetPosX(0)
    CreateItemName:SetPosY(0)
    CreateItemName:SetText(self.SetCharacterEquipName[value])
    CreateItemName:SetShow(false)
    tempSlot.ItemName = CreateItemName
    local CreateBTN_UnSet = UI.createControl(UI_PUCT.PA_UI_CONTROL_BUTTON, CreateItemBG, "CashShop_SetEquip_UnSetBTN_" .. value)
    CopyBaseProperty(TemplateSetEquip.BTN_UnSet, CreateBTN_UnSet)
    CreateBTN_UnSet:SetPosX(CreateItemBG:GetSizeX() - CreateBTN_UnSet:GetSizeX())
    CreateBTN_UnSet:SetPosY(5)
    CreateBTN_UnSet:SetShow(false)
    CreateBTN_UnSet:addInputEvent("Mouse_LUp", "HandleClicked_CashShopSetEquip_UnSetEquip(" .. value .. ")")
    tempSlot.BTN_UnSet = CreateBTN_UnSet
    startPosY = startPosY + slotYGap
    sizeY = sizeY + CreateItemBG:GetSizeY() + 2
    self.SlotUIPool[value] = tempSlot
  end
  Panel_IngameCashShop_SetEquip:SetSize(Panel_IngameCashShop_SetEquip:GetSizeX(), sizeY + 85)
  self.BTN_BuyAll:SetPosY(Panel_IngameCashShop_SetEquip:GetSizeY() - self.BTN_BuyAll:GetSizeY() - 7)
  self.BTN_BuyAll:addInputEvent("Mouse_LUp", "HandleClicked_CashShopMoveCart()")
  cashShop_SetEquip_SetPosition()
  getIngameCashMall():clearCart()
  if isGameTypeKR2() or isGameTypeGT() then
    self.BTN_QNA:SetShow(false)
  end
end
function CashShopSetEquip:Update()
  local nowClass = self.nowSetClass
  for index, value in pairs(self.SetEquipSlotNo) do
    local UiBase = self.SlotUIPool[value]
    local previewAvatar = getIngameCashMall():getCashShopPreviewType()
    if UI_PreviewType.SelfPlayer == previewAvatar or UI_PreviewType.NormalPlayerCharacter == previewAvatar or UI_PreviewType.Others == previewAvatar then
      UiBase.ItemName:SetText(self.SetCharacterEquipName[value])
    elseif UI_PreviewType.SelflVehicleCharacter == previewAvatar or UI_PreviewType.NormalVehicleCharacter == previewAvatar then
      if CppEnums.ServantKind.Type_Horse == self.hasServantType then
        UiBase.ItemName:SetText(self.SetHorseEquipName[value])
      elseif CppEnums.ServantKind.Type_Ship == self.hasServantType then
        UiBase.ItemName:SetText(self.SetCarriageEquipName[value])
      elseif CppEnums.ServantKind.Type_FourWheeledCarriage == self.hasServantType then
        UiBase.ItemName:SetText(self.SetCarriageEquipName[value])
      end
    end
    UiBase.ItemName:SetFontColor(UI_color.C_FFFFFFFF)
  end
  local cartListCount = getIngameCashMall():getViewListCount()
  for equipItem_Idx = 0, cartListCount - 1 do
    local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
    local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
    local productNoRaw = CPSSW:getNoRaw()
    local itemCount = CPSSW:getInnerItemListCount()
    for itemIdx = 0, itemCount - 1 do
      local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
      if itemSSW:isEquipable() then
        local equipSlotNo = itemSSW:getEquipSlotNo()
        local UiBase = self.SlotUIPool[equipSlotNo]
        local itemName = itemSSW:getName()
        local itemGrade = itemSSW:getGradeType()
        CashShopSetEquip:SetEquipSlot(equipSlotNo, itemName, itemGrade)
        UiBase.ItemName:addInputEvent("Mouse_On", "cashShop_SetEquip_ShowTooltip( true, " .. equipSlotNo .. " )")
        UiBase.ItemName:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
      end
    end
  end
end
function CashShopSetEquip:SetEquipSlot(equipSlotNo, itemName, itemGrade)
  local colorCode
  if 0 == itemGrade then
    colorCode = UI_color.C_FFFFFFFF
  elseif 1 == itemGrade then
    colorCode = 4284350320
  elseif 2 == itemGrade then
    colorCode = 4283144191
  elseif 3 == itemGrade then
    colorCode = 4294953010
  elseif 4 == itemGrade then
    colorCode = 4294929408
  else
    colorCode = UI_color.C_FFFFFFFF
  end
  self.SlotUIPool[equipSlotNo].ItemName:SetText(itemName)
  self.SlotUIPool[equipSlotNo].ItemName:SetFontColor(colorCode)
end
function cashShop_SetEquip_ShowTooltip(isshow, equipSlotNo)
  local self = CashShopSetEquip
  local cartListCount = getIngameCashMall():getViewListCount()
  local UiBase = self.SlotUIPool[equipSlotNo].ItemName
  for equipItem_Idx = 0, cartListCount - 1 do
    local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
    local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
    local productNoRaw = CPSSW:getNoRaw()
    local itemCount = CPSSW:getInnerItemListCount()
    for itemIdx = 0, itemCount - 1 do
      local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
      if itemSSW:isEquipable() then
        local tempEquipSlotNo = itemSSW:getEquipSlotNo()
        if equipSlotNo == tempEquipSlotNo then
          Panel_Tooltip_Item_Show(itemSSW, UiBase, true, false)
        end
      end
    end
  end
end
function CashShopSetEquip:Return_ServantType(itemSSW, servantType)
  local returnValue
  if CppEnums.ServantKind.Type_Ship == servantType then
    returnValue = itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Ship) or itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_Raft)
  elseif CppEnums.ServantKind.Type_FourWheeledCarriage == servantType then
    returnValue = itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_TwoWheelCarriage) or itemSSW:get():isServantTypeUsable(CppEnums.ServantKind.Type_FourWheeledCarriage)
  else
    returnValue = itemSSW:get():isServantTypeUsable(servantType)
  end
  return returnValue
end
function cashShop_SetEquip_SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_IngameCashShop_SetEquip:GetSizeX()
  local panelSizeY = Panel_IngameCashShop_SetEquip:GetSizeY()
  Panel_IngameCashShop_SetEquip:SetPosX(scrSizeX - panelSizeX - 20)
  Panel_IngameCashShop_SetEquip:SetPosY(scrSizeY - panelSizeY - 25)
end
function HandleClicked_CashShopSetEquip_UnSetEquip(equipSlotNo)
  local self = CashShopSetEquip
  local productNoRaw = getIngameCashMall():getEquipCartItemByIndex(equipSlotNo)
  getIngameCashMall():popProductInEquipCart(productNoRaw)
  self:Update()
end
function HandleClicked_CashShopMoveCart()
  getIngameCashMall():insertToCartFromViewList()
  if FGlobal_IsShow_IngameCashShop_NewCart() then
    FGlobal_Update_IngameCashShop_NewCart()
  else
    FGlobal_Open_IngameCashShop_NewCart()
  end
end
function FGlobal_CashShop_SetEquip_Update(productNoRaw)
  local self = CashShopSetEquip
  local myClass = getSelfPlayer():getClassType()
  savedProductNo = productNoRaw
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  if nil == CPSSW then
    return
  end
  local itemCount = CPSSW:getInnerItemListCount()
  local checkClass = -1
  local itemType
  local listClass = {}
  for classIdx = 0, getCharacterClassCount() - 1 do
    local classType = getCharacterClassTypeByIndex(classIdx)
    listClass[classType] = true
  end
  local hasEquipment = false
  local hasUsableServant = false
  local hasUsableHorse = false
  local hasUsableCarriage = false
  local hasUsableBoat = false
  local hasFishingBoat = false
  local hasLantern = false
  local hasCamel = false
  local hasDunkey = false
  for itemIdx = 0, itemCount - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
    itemType = itemSSW:getItemType()
    if CppEnums.EquipSlotNo.lantern == itemSSW:getEquipSlotNo() then
      hasLantern = true
    elseif itemSSW:isUsableServant() then
      hasUsableServant = true
      if self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_Horse) then
        hasUsableHorse = true
        self.hasServantType = CppEnums.ServantKind.Type_Horse
      elseif self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_Ship) then
        hasUsableBoat = true
        self.hasServantType = CppEnums.ServantKind.Type_Ship
      elseif self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_FishingBoat) then
        hasFishingBoat = true
        self.hasServantType = CppEnums.ServantKind.Type_FishingBoat
      elseif self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_FourWheeledCarriage) then
        hasUsableCarriage = true
        self.hasServantType = CppEnums.ServantKind.Type_FourWheeledCarriage
      elseif self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_Camel) then
        hasCamel = true
        self.hasServantType = CppEnums.ServantKind.Type_Camel
      elseif self:Return_ServantType(itemSSW, CppEnums.ServantKind.Type_Donkey) then
        hasDunkey = true
        self.hasServantType = CppEnums.ServantKind.Type_Donkey
      end
    else
      if itemSSW:isEquipable() then
        hasEquipment = true
        for classType, _ in pairs(listClass) do
          if false == itemSSW:get()._usableClassType:isOn(classType) then
            listClass[classType] = nil
          end
        end
      else
      end
    end
  end
  if true == listClass[myClass] then
    checkClass = myClass
  else
    for key, _ in pairs(listClass) do
      checkClass = key
      break
    end
  end
  for index, value in pairs(self.SetEquipSlotNo) do
    self.SlotUIPool[value].ItemName:SetText(self.SetCharacterEquipName[value])
    self.SlotUIPool[value].ItemName:SetFontColor(UI_color.C_FFFFFFFF)
  end
  if CPSSW:isShowWindowItemKey() then
    self.nowSetClass = -1
    CashShopController_ForceOffAllButton()
    getIngameCashMall():changeViewCharacter(productNoRaw)
    return
  end
  if (true ~= hasEquipment or false ~= hasLantern) and true == hasUsableServant then
    self.beforSetClass = self.nowSetClass
    self.nowSetClass = checkClass
    local cartProductKeyList = Array.new()
    local cartListCount = getIngameCashMall():getViewListCount()
    for equipItem_Idx = 0, cartListCount - 1 do
      local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
      local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
      cartProductKeyList:push_back(CPSSW:getNoRaw())
    end
    for key, noRaw in pairs(cartProductKeyList) do
      local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
      local itemCount = CPSSW:getInnerItemListCount()
      for itemIdx = 0, itemCount - 1 do
        local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
        if false == self:Return_ServantType(itemSSW, self.hasServantType) then
          getIngameCashMall():popProductInEquipCart(noRaw)
          break
        end
      end
    end
    self.nowSetClass = -1
    local characterKeyRaw = getIngameCashMall():getDelegateServantKey(self.hasServantType)
    CashShopController_ForceOffAllButton()
    getIngameCashMall():changeViewVehicleCharacter(characterKeyRaw)
    getIngameCashMall():pushProductInEquipCart(productNoRaw)
  elseif true == hasEquipment and false == hasLantern then
    self.beforSetClass = self.nowSetClass
    self.nowSetClass = checkClass
    if self.beforSetClass == self.nowSetClass then
    else
      local cartProductKeyList = Array.new()
      local cartListCount = getIngameCashMall():getViewListCount()
      for equipItem_Idx = 0, cartListCount - 1 do
        local iGCSelectedItem = getIngameCashMall():getViewItemByIndex(equipItem_Idx)
        local CPSSW = iGCSelectedItem:getCashProductStaticStatus()
        cartProductKeyList:push_back(CPSSW:getNoRaw())
      end
      for key, noRaw in pairs(cartProductKeyList) do
        local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(noRaw)
        local itemCount = CPSSW:getInnerItemListCount()
        for itemIdx = 0, itemCount - 1 do
          local itemSSW = CPSSW:getInnerItemByIndex(itemIdx)
          if itemSSW:isEquipable() and false == itemSSW:get()._usableClassType:isOn(self.nowSetClass) then
            getIngameCashMall():popProductInEquipCart(noRaw)
            break
          end
        end
      end
      if myClass == self.nowSetClass then
        getIngameCashMall():changeViewMyCharacter()
      else
        local characterSSW = getCharacterStaticStatusWrapperByClassType(self.nowSetClass)
        local characterKeyRaw = characterSSW:getCharacterKey()
        getIngameCashMall():changeViewPlayerCharacter(characterKeyRaw)
      end
    end
    CashShop_SetEquip_AutoUnderWearShow(productNoRaw)
    CashShop_SetEquip_AutoUpHair(productNoRaw)
    getIngameCashMall():pushProductInEquipCart(productNoRaw)
  else
    self.nowSetClass = -1
    CashShopController_ForceOffAllButton()
    getIngameCashMall():changeViewCharacter(productNoRaw)
  end
  FGlobal_CashShopController_InitEndurance(100)
end
function CashSHop_IsUnderWearItem(productNoRaw)
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local count = CPSSW:getInnerItemListCount()
  for key = 0, count - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(0)
    local itemType = itemSSW:getEquipSlotNo()
    if CppEnums.EquipSlotNo.avatarUnderWear == itemType then
      return true
    end
  end
  return false
end
function CashShop_SetEquip_AutoUnderWearShow(productNoRaw)
  if CashSHop_IsUnderWearItem(productNoRaw) then
    HandleClicked_CashShopController_AutoToggleUnderWear()
  else
    HandleClicked_CashShopController_AutoToggleOffAll()
  end
end
function CashShop_SetEquip_AutoUpHair(productNoRaw)
  local CPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local count = CPSSW:getInnerItemListCount()
  local isUpHairMode = false
  for key = 0, count - 1 do
    local itemSSW = CPSSW:getInnerItemByIndex(key)
    local itemType = itemSSW:getEquipSlotNo()
    if CppEnums.EquipSlotNo.faceDecoration1 == itemType or CppEnums.EquipSlotNo.faceDecoration2 == itemType or CppEnums.EquipSlotNo.faceDecoration3 == itemType then
      isUpHairMode = true
      break
    end
  end
  CashShopController_HideHairBtnCheck(isUpHairMode)
end
function FGlobal_CashShop_SetEquip_Open()
  local self = CashShopSetEquip
  cashShop_SetEquip_SetPosition()
  self:Update()
  Panel_IngameCashShop_SetEquip:SetShow(true)
  self.nowSetClass = -1
end
function FGlobal_CashShop_SetEquip_Close()
  cashShop_SetEquip_Close()
end
function cashShop_SetEquip_Close()
  Panel_IngameCashShop_SetEquip:SetShow(false)
end
function HandleClicked_CashShop_Close()
  if Panel_Win_System:GetShow() then
    Proc_ShowMessage_Ack("\236\149\140\235\166\188\236\176\189\236\157\132 \235\168\188\236\160\128 \235\139\171\236\149\132\236\163\188\236\132\184\236\154\148.")
    return
  end
  InGameShopBuy_Close()
  Panel_IngameCashShop_HowUsePearlShop_Close()
  FGlobal_CashShop_GoodsTooltipInfo_Close()
  InGameShopDetailInfo_Close()
  PaymentPassword_Close()
  chargeDaumCash_Close()
  termsofDaumCash_Close()
  Panel_IngameCashShop_MakePaymentsFromCart:SetShow(false)
  Panel_IngameCashShop_BuyPearlBox:SetShow(false)
  IngameCashShopCoupon_Close()
  InGameShop_Close()
end
function HandleClicked_QNAWebLink_Open()
  FGlobal_QnAWebLink_Open()
end
function FromClient_CashShopSetEquip_Resize()
  cashShop_SetEquip_SetPosition()
end
function CashShopSetEquip:registEventHandler()
  self.BTN_Exit:addInputEvent("Mouse_LUp", "HandleClicked_CashShop_Close()")
  self.BTN_QNA:addInputEvent("Mouse_LUp", "HandleClicked_QNAWebLink_Open()")
  registerEvent("onScreenResize", "FromClient_CashShopSetEquip_Resize")
end
CashShopSetEquip:Initialize()
CashShopSetEquip:registEventHandler()
Panel_IngameCashShop_Controller:SetShow(false)
if false == _ContentsGroup_RenewUI_Customization then
  Panel_CustomizationMessage:SetShow(false, false)
  Panel_CustomizationMessage:SetIgnore(true)
end
local CashShopController = {
  GameTime_Slider = UI.getChildControl(Panel_IngameCashShop_Controller, "Slider_GameTime"),
  BTN_Light = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_Light"),
  BTN_EyeSee = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_EyeSee"),
  BTN_ShowUI = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_ShowUI"),
  SunIcon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Sun"),
  btn_SpecialMove = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_SpecialMove"),
  MoonIcon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Moon"),
  SunShine1 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine1"),
  SunShine2 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine2"),
  SunShine3 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine3"),
  SunShine4 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine4"),
  SunShine5 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine5"),
  SunShine6 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SunShine6"),
  btn_SpecialMove1 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SpecialMove1"),
  btn_SpecialMove2 = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SpecialMove2"),
  ChaCTR_Area = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_CharacterController"),
  RotateArrow_L = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_Left_RotateArrow"),
  RotateArrow_R = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_Right_RotateArrow"),
  static_SetOptionBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_SetOptionBG"),
  static_SetOptionEnduranceBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_SetOptionEnduranceBG"),
  txt_Endurance = UI.getChildControl(Panel_IngameCashShop_Controller, "StaticText_Endurance"),
  Slider_Endurance = UI.getChildControl(Panel_IngameCashShop_Controller, "Slider_Endurance"),
  btn_ShowUnderwear = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_ShowUnderWear"),
  btn_HideAvatar = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_HideAvatar"),
  btn_HideHair = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_HideHair"),
  btn_HideHelm = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_HideHelm"),
  btn_AwakenWeapon = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_AwakenWeapon"),
  btn_WarStance = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_WarStance"),
  btn_OpenHelm = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_OpenHelm"),
  btn_Cloak_Invisual = UI.getChildControl(Panel_IngameCashShop_Controller, "CheckButton_Cloak_Invisual"),
  cameraControlBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_CameraControlBG"),
  cameraControlTitle = UI.getChildControl(Panel_IngameCashShop_Controller, "StaticText_CameraControlTitle"),
  cameraControlMoveBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_CameraControlMoveBG"),
  cameraControlWheelBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_CameraControlWheelBG"),
  cameraControlRotateBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_CameraControlRotateBG"),
  cameraControlMove = UI.getChildControl(Panel_IngameCashShop_Controller, "StaticText_CameraControlMove"),
  cameraControlWheel = UI.getChildControl(Panel_IngameCashShop_Controller, "StaticText_CameraControlWheel"),
  cameraControlRotate = UI.getChildControl(Panel_IngameCashShop_Controller, "StaticText_CameraControlRotate"),
  petLookBG = UI.getChildControl(Panel_IngameCashShop_Controller, "Static_SetPetLookBG"),
  btn_Coupon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Coupon"),
  btn_StampCoupon = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_StampCoupon"),
  btn_FirstIgnore = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_FirstIgnore"),
  btn_SaleGoods = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_SaleGoods"),
  btn_Mileage = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_Mileage"),
  btn_AllDoff = UI.getChildControl(Panel_IngameCashShop_Controller, "Button_AllDoff"),
  isLdown = false,
  isRdown = false,
  lMovePos = 0,
  yMovePos = 0,
  isShowUI = true,
  xStartPos = 0,
  yStartPos = 0,
  savedTabType = 0
}
CashShopController.btn_petLookBefore = UI.getChildControl(CashShopController.petLookBG, "Button_Before")
CashShopController.btn_petLookNext = UI.getChildControl(CashShopController.petLookBG, "Button_Next")
CashShopController.txt_petLookNameMain = UI.getChildControl(CashShopController.petLookBG, "StaticText_PetLookNameMain")
CashShopController.txt_petLookNameSub = UI.getChildControl(CashShopController.petLookBG, "StaticText_PetLookNameSub")
CashShopController.petLookBG:SetAlpha(0.6)
CashShopController.btn_AwakenWeapon:SetShow(awakenWeaponContentsOpen)
CashShopController.GameTime_SliderCtrlBTN = UI.getChildControl(CashShopController.GameTime_Slider, "Slider_GameTime_Button")
CashShopController.Slider_EnduranceCtrlBTN = CashShopController.Slider_Endurance:GetControlButton()
local StaticText_CustomizationMessage = UI.getChildControl(Panel_CustomizationMessage, "StaticText_CustomizationMessage")
function CashShopController:Initialize()
  self.GameTime_Slider:SetInterval(23)
  self.Slider_Endurance:SetInterval(100)
  self.static_SetOptionBG:AddChild(self.static_SetOptionEnduranceBG)
  self.static_SetOptionBG:AddChild(self.txt_Endurance)
  self.static_SetOptionBG:AddChild(self.btn_ShowUnderwear)
  self.static_SetOptionBG:AddChild(self.btn_HideAvatar)
  self.static_SetOptionBG:AddChild(self.Slider_Endurance)
  self.static_SetOptionBG:AddChild(self.btn_HideHair)
  self.static_SetOptionBG:AddChild(self.btn_HideHelm)
  self.static_SetOptionBG:AddChild(self.btn_OpenHelm)
  self.static_SetOptionBG:AddChild(self.btn_Cloak_Invisual)
  self.static_SetOptionBG:AddChild(self.btn_AwakenWeapon)
  self.static_SetOptionBG:AddChild(self.btn_WarStance)
  self.static_SetOptionBG:AddChild(self.btn_AllDoff)
  Panel_IngameCashShop_Controller:RemoveControl(self.static_SetOptionEnduranceBG)
  Panel_IngameCashShop_Controller:RemoveControl(self.txt_Endurance)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_ShowUnderwear)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_HideAvatar)
  Panel_IngameCashShop_Controller:RemoveControl(self.Slider_Endurance)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_HideHair)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_HideHelm)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_OpenHelm)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_Cloak_Invisual)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_AwakenWeapon)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_WarStance)
  Panel_IngameCashShop_Controller:RemoveControl(self.btn_AllDoff)
  self.static_SetOptionEnduranceBG:SetPosX(5)
  self.static_SetOptionEnduranceBG:SetPosY(10)
  self.txt_Endurance:SetPosX(5)
  self.txt_Endurance:SetPosY(10)
  self.Slider_Endurance:SetPosX(self.txt_Endurance:GetPosX() + self.txt_Endurance:GetSizeX() + 3)
  self.Slider_Endurance:SetPosY(17)
  self.btn_AllDoff:SetPosX(self.Slider_Endurance:GetPosX() - 50)
  self.btn_AllDoff:SetPosY(45)
  if false == ToClient_isAdultUser() then
    self.btn_ShowUnderwear:SetShow(false)
    self.btn_ShowUnderwear:SetIgnore(false)
    self.btn_HideAvatar:SetPosX(self.btn_AllDoff:GetPosX() + self.btn_AllDoff:GetSizeX() - 1)
    self.btn_HideAvatar:SetPosY(45)
  else
    self.btn_ShowUnderwear:SetPosX(self.btn_AllDoff:GetPosX() + self.btn_AllDoff:GetSizeX() - 1)
    self.btn_ShowUnderwear:SetPosY(45)
    self.btn_HideAvatar:SetPosX(self.btn_ShowUnderwear:GetPosX() + self.btn_ShowUnderwear:GetSizeX() - 1)
    self.btn_HideAvatar:SetPosY(45)
  end
  self.btn_HideHair:SetPosX(self.btn_HideAvatar:GetPosX() + self.btn_HideAvatar:GetSizeX() - 1)
  self.btn_HideHair:SetPosY(45)
  self.btn_HideHelm:SetPosX(self.btn_HideHair:GetPosX() + self.btn_HideHair:GetSizeX() - 1)
  self.btn_HideHelm:SetPosY(45)
  self.btn_OpenHelm:SetPosX(self.btn_HideHelm:GetPosX() + self.btn_HideHelm:GetSizeX() - 1)
  self.btn_OpenHelm:SetPosY(45)
  self.btn_Cloak_Invisual:SetPosX(self.btn_OpenHelm:GetPosX() + self.btn_OpenHelm:GetSizeX() - 1)
  self.btn_Cloak_Invisual:SetPosY(45)
  self.btn_AwakenWeapon:SetPosX(self.btn_Cloak_Invisual:GetPosX() + self.btn_OpenHelm:GetSizeX() - 1)
  self.btn_AwakenWeapon:SetPosY(45)
  self.btn_WarStance:SetPosX(self.btn_AwakenWeapon:GetPosX() + self.btn_AwakenWeapon:GetSizeX() - 1)
  self.btn_WarStance:SetPosY(45)
  self.cameraControlBG:AddChild(self.cameraControlTitle)
  self.cameraControlBG:AddChild(self.cameraControlMoveBG)
  self.cameraControlBG:AddChild(self.cameraControlWheelBG)
  self.cameraControlBG:AddChild(self.cameraControlRotateBG)
  self.cameraControlBG:AddChild(self.cameraControlMove)
  self.cameraControlBG:AddChild(self.cameraControlWheel)
  self.cameraControlBG:AddChild(self.cameraControlRotate)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlTitle)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlMoveBG)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlWheelBG)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlRotateBG)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlMove)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlWheel)
  Panel_IngameCashShop_Controller:RemoveControl(self.cameraControlRotate)
  self.cameraControlTitle:SetPosY(35)
  self.cameraControlMoveBG:SetPosY(50)
  self.cameraControlWheelBG:SetPosY(90)
  self.cameraControlRotateBG:SetPosY(130)
  self.cameraControlMove:SetPosX(45)
  self.cameraControlMove:SetPosY(50)
  self.cameraControlWheel:SetPosX(45)
  self.cameraControlWheel:SetPosY(90)
  self.cameraControlRotate:SetPosX(45)
  self.cameraControlRotate:SetPosY(130)
  self.GameTime_Slider:SetShow(false)
  self.BTN_Light:SetShow(false)
  self.SunIcon:SetShow(true)
  self.MoonIcon:SetShow(false)
  self.btn_SpecialMove:SetShow(false)
  self.cameraControlBG:SetIgnore(false)
  self.cameraControlBG:SetAlpha(0.8)
  self.cameraControlTitle:SetAlpha(0.8)
  self.cameraControlMoveBG:SetAlpha(0.8)
  self.cameraControlWheelBG:SetAlpha(0.8)
  self.cameraControlRotateBG:SetAlpha(0.8)
  self.cameraControlMove:SetAlpha(0.8)
  self.cameraControlWheel:SetAlpha(0.8)
  self.cameraControlRotate:SetAlpha(0.8)
  self.cameraControlTitle:SetFontColor(UI_color.C_AAFFFFFF)
  self.cameraControlMove:SetFontColor(UI_color.C_AAFFFFFF)
  self.cameraControlWheel:SetFontColor(UI_color.C_AAFFFFFF)
  self.cameraControlRotate:SetFontColor(UI_color.C_AAFFFFFF)
  self.ChaCTR_Area:AddChild(self.RotateArrow_L)
  self.ChaCTR_Area:AddChild(self.RotateArrow_R)
  Panel_IngameCashShop_Controller:RemoveControl(self.RotateArrow_L)
  Panel_IngameCashShop_Controller:RemoveControl(self.RotateArrow_R)
  self.cameraControlBG:SetSpanSize(17, 60)
  FGlobal_CashShop_SetEquip_CouponEffectCheck()
  local _btn_SizeX = self.btn_Coupon:GetSizeX() + 23
  local _btn_TextSizeX = _btn_SizeX - _btn_SizeX / 2 - self.btn_Coupon:GetTextSizeX() / 2
  self.btn_Coupon:SetTextSpan(_btn_TextSizeX, 4)
  local _btn_StampCouponSizeX = self.btn_StampCoupon:GetSizeX() + 23
  local _btn_StampCouponTextSizeX = _btn_StampCouponSizeX - _btn_StampCouponSizeX / 2 - self.btn_StampCoupon:GetTextSizeX() / 2
  self.btn_StampCoupon:SetTextSpan(_btn_StampCouponTextSizeX, 4)
  local _btn_FirstIgnoreSizeX = self.btn_FirstIgnore:GetSizeX() + 23
  local _btn_FirstIgnoreTextSizeX = _btn_FirstIgnoreSizeX - _btn_FirstIgnoreSizeX / 2 - self.btn_FirstIgnore:GetTextSizeX() / 2
  self.btn_FirstIgnore:SetTextSpan(_btn_FirstIgnoreTextSizeX, 4)
  local _btn_SaleGoodsSizeX = self.btn_SaleGoods:GetSizeX() + 23
  local _btn_SaleGoodsTextSizeX = _btn_SaleGoodsSizeX - _btn_SaleGoodsSizeX / 2 - self.btn_SaleGoods:GetTextSizeX() / 2
  self.btn_SaleGoods:SetTextSpan(_btn_SaleGoodsTextSizeX, 4)
  local _btn_MileageSizeX = self.btn_Mileage:GetSizeX() + 23
  local _btn_MileageTextSizeX = _btn_MileageSizeX - _btn_MileageSizeX / 2 - self.btn_Mileage:GetTextSizeX() / 2
  self.btn_Mileage:SetTextSpan(_btn_MileageTextSizeX, 4)
  if isGameTypeKR2() then
    self.static_SetOptionEnduranceBG:SetShow(false)
    self.txt_Endurance:SetShow(false)
    self.Slider_Endurance:SetShow(false)
    self.btn_ShowUnderwear:SetShow(false)
    self.static_SetOptionBG:SetSize(self.static_SetOptionBG:GetSizeX(), 60)
    self.btn_AllDoff:SetPosY(15)
    self.btn_ShowUnderwear:SetPosY(15)
    self.btn_HideAvatar:SetPosY(15)
    self.btn_HideHair:SetPosY(15)
    self.btn_HideHelm:SetPosY(15)
    self.btn_OpenHelm:SetPosY(15)
    self.btn_Cloak_Invisual:SetPosY(15)
    self.btn_AwakenWeapon:SetPosY(15)
    self.btn_WarStance:SetPosY(15)
  end
  if _ContentsGroup_RenewUI_PearlShop then
    UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_Exit"):SetShow(false)
    UI.getChildControl(Panel_IngameCashShop_SetEquip, "Button_QNA"):SetShow(false)
  end
end
function FGlobal_CashShop_SetEquip_CouponEffectCheck()
  local self = CashShopController
  local count = ToClient_GetCouponInfoUsableCount()
  if isCouponOpen then
    self.btn_Coupon:EraseAllEffect()
    self.btn_Coupon:SetShow(true)
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      self.btn_Coupon:SetSpanSize(10, 130)
    else
      self.btn_Coupon:SetSpanSize(10, 90)
    end
    if count > 0 then
      self.btn_Coupon:AddEffect("fui_coupon_01B", true, 0, 0)
    end
  else
    self.btn_Coupon:SetShow(false)
  end
end
function CashShopController:StampCoupon_Init()
  if isStampCouponOpen then
    self.btn_StampCoupon:SetShow(true)
  else
    self.btn_StampCoupon:SetShow(false)
  end
end
function CashShopController:Open()
  local nowTime = getIngameCashMall():getWeatherTime()
  getIngameCashMall():setWeatherTime(6, nowTime)
  local controlPos = 4.166666666666667 * nowTime
  self.GameTime_Slider:SetControlPos(controlPos)
  local isLightOn = getIngameCashMall():getLight()
  self.BTN_Light:SetCheck(isLightOn)
  local isCharacterViewCamera = getIngameCashMall():getCharacterViewCamera()
  self.BTN_EyeSee:SetCheck(isCharacterViewCamera)
  local endurancePercents = getIngameCashMall():getEquipmentEndurancePercents()
  self.Slider_Endurance:SetControlPos(endurancePercents * 100)
  local isShowUnderwear = getIngameCashMall():getIsShowUnderwear()
  self.btn_ShowUnderwear:SetCheck(isShowUnderwear)
  local isShowWithoutAvatar = getIngameCashMall():getIsShowWithoutAvatar()
  self.btn_HideAvatar:SetCheck(isShowWithoutAvatar)
  local isFaceVisibleHair = getIngameCashMall():getFaceVisibleHair()
  self.btn_HideHair:SetCheck(isFaceVisibleHair)
  local isAwakenWeapon = getIngameCashMall():getAwakenWeaponView()
  self.btn_AwakenWeapon:SetCheck(isAwakenWeapon)
  local isWarStance = getIngameCashMall():getBattleView()
  self.btn_WarStance:SetCheck(isWarStance)
  local isHelmOpen = getIngameCashMall():getIsShowBattleHelmet()
  self.btn_OpenHelm:SetCheck(isHelmOpen)
  local isFirstIgnore = getIngameCashMall():isFirstIgnore()
  self.btn_FirstIgnore:SetCheck(isFirstIgnore)
  if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    self.btn_Mileage:SetShow(true)
    self.btn_Mileage:SetSpanSize(10, 90)
    self.btn_Coupon:SetSpanSize(10, 130)
    self.btn_StampCoupon:SetSpanSize(10, 170)
    self.btn_SaleGoods:SetSpanSize(10, 210)
    self.btn_FirstIgnore:SetSpanSize(10, 170)
  else
    self.btn_Mileage:SetShow(false)
    self.btn_Coupon:SetSpanSize(10, 90)
    self.btn_StampCoupon:SetSpanSize(10, 130)
    self.btn_SaleGoods:SetSpanSize(10, 170)
    self.btn_FirstIgnore:SetSpanSize(10, 130)
  end
  self.btn_Cloak_Invisual:SetCheck(false)
  getIngameCashMall():setIsShowCloak(not self.btn_Cloak_Invisual:IsCheck())
  Panel_IngameCashShop_Controller:SetShow(true)
  Panel_CustomizationMessage:SetShow(true, false)
  local message = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_CONTROLLER_MSG")
  StaticText_CustomizationMessage:SetText(message)
  StaticText_CustomizationMessage:SetSize(StaticText_CustomizationMessage:GetTextSizeX() + 10 + StaticText_CustomizationMessage:GetSpanSize().x, StaticText_CustomizationMessage:GetTextSizeY() + 5)
  StaticText_CustomizationMessage:SetSpanSize(0, 0)
  StaticText_CustomizationMessage:SetShow(true)
  StaticText_CustomizationMessage:SetIgnore(true)
  self.isShowUI = true
  self:ResetViewCharacterPosition()
  self.BTN_ShowUI:SetCheck(false)
  self:SetPosition()
end
function CashShopController:Close()
  Panel_IngameCashShop_Controller:SetShow(false)
  Panel_CustomizationMessage:SetShow(false, false)
  self.SunShine1:SetShow(false)
  self.SunShine2:SetShow(false)
  self.SunShine3:SetShow(false)
  self.SunShine4:SetShow(false)
  self.SunShine5:SetShow(false)
  self.SunShine6:SetShow(false)
  self.btn_SpecialMove1:SetShow(false)
  self.btn_SpecialMove2:SetShow(false)
  self.cameraControlBG:SetSpanSize(17, 60)
  self.btn_SpecialMove:SetCheck(false)
  self.SunIcon:SetCheck(false)
end
local tabIndexList = Array.new()
function FGlobal_CashShop_SetEquip_BGToggle(tabindex)
  local self = CashShopController
  self.cameraControlBG:SetSpanSize(17, 60)
  tabIndexList = FGlobal_CashShop_tabInfo_Return()
  local realno
  realno = tabIndexList[tabindex][5]
  self.savedTabType = realno
  if UI_CCC.eCashProductCategory_Pet == realno then
    self.cameraControlBG:SetSpanSize(17, 60)
    self.petLookBG:SetShow(false)
    self.static_SetOptionBG:SetShow(false)
  elseif UI_CCC.eCashProductCategory_Costumes == realno then
    self.static_SetOptionBG:SetShow(true)
    self.petLookBG:SetShow(false)
    self.cameraControlBG:SetSpanSize(17, 150)
  else
    self.cameraControlBG:SetSpanSize(17, 60)
    self.petLookBG:SetShow(false)
    self.static_SetOptionBG:SetShow(false)
  end
end
function FGlobal_CashShop_SetEquip_SelectedItem(productNoRaw)
  local cashProduct = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  if nil == cashProduct then
    return
  end
  local self = CashShopController
  local isMainCategory = cashProduct:getMainCategory()
  local isMiddleCategory = cashProduct:getMiddleCategory()
  if 4 ~= self.savedTabType then
    if 7 == isMainCategory and 1 == isMiddleCategory then
      self.petLookBG:SetShow(true)
      self.static_SetOptionBG:SetShow(false)
      self.cameraControlBG:SetSpanSize(17, 130)
    elseif 4 == isMainCategory then
      self.static_SetOptionBG:SetShow(true)
      self.petLookBG:SetShow(false)
      self.cameraControlBG:SetSpanSize(17, 150)
    elseif 9 == isMainCategory and isGameTypeEnglish() then
      self.static_SetOptionBG:SetShow(true)
      self.petLookBG:SetShow(false)
      self.cameraControlBG:SetSpanSize(17, 150)
    else
      self.cameraControlBG:SetSpanSize(17, 60)
      self.petLookBG:SetShow(false)
      self.static_SetOptionBG:SetShow(false)
    end
  else
    self.static_SetOptionBG:SetShow(true)
    self.petLookBG:SetShow(false)
    self.cameraControlBG:SetSpanSize(17, 150)
  end
  self.txt_petLookNameMain:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.txt_petLookNameSub:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.btn_petLookBefore:SetShow(false)
  self.btn_petLookNext:SetShow(false)
  if getIngameCashMall():IsStartOfTierPet() then
    self.btn_petLookBefore:SetShow(false)
    self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
    self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
  else
    self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
    self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_OPTION"))
    self.btn_petLookBefore:SetShow(true)
  end
  if getIngameCashMall():IsEndOfTierPet() then
    self.btn_petLookNext:SetShow(false)
  else
    self.btn_petLookNext:SetShow(true)
  end
  local specialMoveCheck = self.btn_SpecialMove:IsCheck()
  local sunShineCheck = self.SunIcon:IsCheck()
  if specialMoveCheck or sunShineCheck then
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      self.btn_Mileage:SetShow(true)
      self.btn_Mileage:SetSpanSize(10, 140)
      self.btn_Coupon:SetSpanSize(10, 180)
      self.btn_StampCoupon:SetSpanSize(10, 220)
      self.btn_FirstIgnore:SetSpanSize(10, 220)
    else
      self.btn_Mileage:SetShow(false)
      self.btn_Coupon:SetSpanSize(10, 140)
      self.btn_StampCoupon:SetSpanSize(10, 180)
      self.btn_FirstIgnore:SetSpanSize(10, 180)
    end
  elseif true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    self.btn_Mileage:SetShow(true)
    self.btn_Mileage:SetSpanSize(10, 90)
    self.btn_Coupon:SetSpanSize(10, 130)
    self.btn_StampCoupon:SetSpanSize(10, 170)
    self.btn_FirstIgnore:SetSpanSize(10, 170)
  else
    self.btn_Mileage:SetShow(false)
    self.btn_Coupon:SetSpanSize(10, 90)
    self.btn_StampCoupon:SetSpanSize(10, 130)
    self.btn_FirstIgnore:SetSpanSize(10, 130)
  end
end
function CashShopController:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_IngameCashShop_Controller:GetSizeX()
  local panelSizeY = Panel_IngameCashShop_Controller:GetSizeY()
  local ControllerSizeX, ControllerSizeY, ControllerPosX, ControllerPosY
  if self.BTN_ShowUI:IsCheck() then
    ControllerSizeX = scrSizeX
    ControllerSizeY = scrSizeY
    ControllerPosX = 0
    ControllerPosY = 0
  else
    ControllerSizeX = scrSizeX - (Panel_IngameCashShop:GetPosX() + Panel_IngameCashShop:GetSizeX() + 130)
    ControllerSizeY = scrSizeY
    ControllerPosX = Panel_IngameCashShop:GetPosX() + Panel_IngameCashShop:GetSizeX() + 130
    ControllerPosY = 0
  end
  Panel_IngameCashShop_Controller:SetSize(ControllerSizeX, ControllerSizeY)
  Panel_IngameCashShop_Controller:SetPosX(ControllerPosX)
  Panel_IngameCashShop_Controller:SetPosY(ControllerPosY)
  self.ChaCTR_Area:SetSize(ControllerSizeX - 10, ControllerSizeY - 10)
  self.ChaCTR_Area:SetPosX(10)
  self.ChaCTR_Area:SetPosY(10)
  self.SunIcon:SetSpanSize(110, 10)
  self.SunShine1:SetSpanSize(250, 78)
  self.SunShine2:SetSpanSize(200, 78)
  self.SunShine3:SetSpanSize(150, 78)
  self.SunShine4:SetSpanSize(100, 78)
  self.SunShine5:SetSpanSize(50, 78)
  self.SunShine6:SetSpanSize(0, 78)
  self.btn_SpecialMove1:SetSpanSize(190, 88)
  self.btn_SpecialMove2:SetSpanSize(140, 88)
  self.static_SetOptionBG:ComputePos()
  self.petLookBG:ComputePos()
  self.btn_SpecialMove:ComputePos()
  self.GameTime_Slider:ComputePos()
  self.BTN_Light:ComputePos()
  self.BTN_EyeSee:ComputePos()
  self.BTN_ShowUI:ComputePos()
  self.SunIcon:ComputePos()
  self.MoonIcon:ComputePos()
  self.SunShine1:ComputePos()
  self.SunShine2:ComputePos()
  self.SunShine3:ComputePos()
  self.SunShine4:ComputePos()
  self.SunShine5:ComputePos()
  self.SunShine6:ComputePos()
  self.btn_SpecialMove1:ComputePos()
  self.btn_SpecialMove2:ComputePos()
  self.btn_Mileage:ComputePos()
  self.btn_Coupon:ComputePos()
  self.btn_StampCoupon:ComputePos()
  self.btn_FirstIgnore:ComputePos()
  self.btn_SaleGoods:ComputePos()
  self.cameraControlBG:ComputePos()
  CashShopController:ResetViewCharacterPosition()
end
function CashShopController:ResetViewCharacterPosition()
  if self.isShowUI then
    local leftWindowSize = Panel_IngameCashShop:GetSizeX()
    local screenSize = getScreenSizeX()
    getIngameCashMall():setCreatePosition((screenSize + leftWindowSize) / 2 / screenSize, 0.5, 320)
  else
    getIngameCashMall():setCreatePosition(0.5, 0.5, 320)
  end
end
function HandleClicked_CashShopController_SetTime()
  local self = CashShopController
  local ttIndex = self.GameTime_Slider:GetSelectIndex()
  getIngameCashMall():setWeatherTime(6, ttIndex)
end
function HandleClicked_CashShopController_SetLight()
  local self = CashShopController
  if not self.BTN_Light:IsCheck() then
    getIngameCashMall():setLight(false)
  else
    getIngameCashMall():setLight(true)
  end
end
function HandleClicked_CashShopController_SetCharacterViewCamera()
  local self = CashShopController
  getIngameCashMall():setCharacterViewCamera(self.BTN_EyeSee:IsCheck())
end
function HandleClicked_CashShopController_SetSpecialMove()
  local self = CashShopController
  local specialMoveCheck = self.btn_SpecialMove:IsCheck()
  local sunShineCheck = self.SunIcon:IsCheck()
  local action = getIngameCashMall():getCharacterActionCount() - 1
  local characterAnimationCount = getIngameCashMall():getCharacterAnimationCount(action)
  if specialMoveCheck or sunShineCheck then
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      self.btn_Mileage:SetShow(true)
      self.btn_Mileage:SetSpanSize(10, 140)
      self.btn_Coupon:SetSpanSize(10, 180)
      self.btn_StampCoupon:SetSpanSize(10, 220)
      self.btn_FirstIgnore:SetSpanSize(10, 220)
      self.btn_SaleGoods:SetSpanSize(10, 260)
    else
      self.btn_Mileage:SetShow(false)
      self.btn_Coupon:SetSpanSize(10, 140)
      self.btn_StampCoupon:SetSpanSize(10, 180)
      self.btn_FirstIgnore:SetSpanSize(10, 180)
      self.btn_SaleGoods:SetSpanSize(10, 220)
    end
    self.SunIcon:SetCheck(false)
    HandleClicked_SunShineToggle()
  elseif true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    self.btn_Mileage:SetShow(true)
    self.btn_Mileage:SetSpanSize(10, 90)
    self.btn_Coupon:SetSpanSize(10, 130)
    self.btn_StampCoupon:SetSpanSize(10, 170)
    self.btn_FirstIgnore:SetSpanSize(10, 170)
    self.btn_SaleGoods:SetSpanSize(10, 210)
  else
    self.btn_Mileage:SetShow(false)
    self.btn_Coupon:SetSpanSize(10, 90)
    self.btn_StampCoupon:SetSpanSize(10, 130)
    self.btn_FirstIgnore:SetSpanSize(10, 130)
    self.btn_SaleGoods:SetSpanSize(10, 170)
  end
  if 1 == characterAnimationCount then
    if specialMoveCheck then
      self.btn_SpecialMove1:SetShow(true)
      self.btn_SpecialMove2:SetShow(false)
      self.btn_SpecialMove1:SetSpanSize(165, 88)
    else
      self.btn_SpecialMove1:SetShow(false)
      self.btn_SpecialMove2:SetShow(false)
    end
  elseif 2 == characterAnimationCount then
    if specialMoveCheck then
      self.btn_SpecialMove1:SetShow(true)
      self.btn_SpecialMove2:SetShow(true)
      self.btn_SpecialMove1:SetSpanSize(190, 88)
      self.btn_SpecialMove2:SetSpanSize(140, 88)
    else
      self.btn_SpecialMove1:SetShow(true)
      self.btn_SpecialMove2:SetShow(true)
    end
  end
  self.btn_SpecialMove1:ComputePos()
  self.btn_SpecialMove2:ComputePos()
end
function HandleClicked_CashShopController_SetShowUIToggle()
  local self = CashShopController
  if true == self.isShowUI then
    Panel_IngameCashShop:SetShow(false)
    Panel_IngameCashShop_SetEquip:SetShow(false)
    FGlobal_Close_IngameCashShop_NewCart()
    InGameShopBuy_Close()
    IngameCashShopCoupon_Close()
    if nil ~= PaGlobalFunc_CashMileage_GetShow and true == PaGlobalFunc_CashMileage_GetShow() then
      PaGlobal_CashMileage_Close()
    end
    if Panel_IngameCashShop_GoodsDetailInfo:GetShow() then
      InGameShopDetailInfo_Close()
    end
    Panel_Window_RecommandGoods:SetShow(false)
    self.isShowUI = false
  else
    Panel_IngameCashShop:SetShow(true)
    Panel_IngameCashShop_SetEquip:SetShow(true)
    InGameShop_ReShowByHideUI()
    FGlobal_CheckPromotionTab()
    InGameShop_Promotion_Open()
    self.isShowUI = true
  end
  self:ResetViewCharacterPosition()
  self:SetPosition()
end
function HandleClicked_CashShopController_SetCharacterRotate_Start(isLDown)
  local self = CashShopController
  if isLDown then
    self.isLdown = true
  else
    self.isRdown = true
  end
  self.lMovePos = getMousePosX()
  self.yMovePos = getMousePosY()
  self.xStartPos = getMousePosX()
  self.yStartPos = getMousePosY()
end
function HandleClicked_CashShopController_SetCharacterRotate_End(isLDown)
  local self = CashShopController
  if nil == isLDown then
    self.isLdown = false
    self.isRdown = false
  elseif isLDown then
    if math.abs(self.xStartPos - getMousePosX()) + math.abs(self.yStartPos - getMousePosY()) < 20 then
      local randValue = math.random(0, getIngameCashMall():getCharacterActionCount() - 1)
      getIngameCashMall():setCharacterActionKey(randValue, 0)
    end
    self.isLdown = false
  else
    self.isRdown = false
  end
end
function HandleClicked_CashShopController_SetCharacterScroll(isUp)
  local upValue = 25
  if true == isUp then
    upValue = -upValue
  end
  getIngameCashMall():varyCameraZoom(upValue)
end
function HandleClicked_CashShopController_UpdateEndurance()
  local self = CashShopController
  local ttIndex = self.Slider_Endurance:GetSelectIndex()
  getIngameCashMall():setEquipmentEndurancePercents(ttIndex / 100)
end
function HandleClicked_CashShopController_OffAllEquip()
  getIngameCashMall():clearEquipViewList()
end
function HandleClicked_CashShopController_FirstIgnore()
  local self = CashShopController
  local isChecked = self.btn_FirstIgnore:IsCheck()
  getIngameCashMall():setFirstIgnore(isChecked)
end
function Return_CashShopController_FirstIgnore()
  return getIngameCashMall():isFirstIgnore()
end
function HandleClicked_CashShopController_ToggleUnderWear()
  local self = CashShopController
  local isChecked = self.btn_ShowUnderwear:IsCheck()
  getIngameCashMall():setIsShowUnderwear(isChecked)
  if isChecked then
    self.btn_HideAvatar:SetCheck(false)
  end
end
function HandleClicked_CashShopController_ToggleAvatar()
  local self = CashShopController
  local isChecked = self.btn_HideAvatar:IsCheck()
  getIngameCashMall():setIsShowWithoutAvatar(isChecked)
  if isChecked then
    self.btn_ShowUnderwear:SetCheck(false)
  end
end
function HandleClicked_CashShopController_ToggleHideHair()
  local self = CashShopController
  local isChecked = self.btn_HideHair:IsCheck()
  if isChecked then
    self.btn_HideHair:EraseAllEffect()
  end
  getIngameCashMall():setFaceVisibleHair(isChecked)
end
function CashShopController_HideHairBtnCheck(isUpHairMode)
  local self = CashShopController
  if isUpHairMode then
    if not self.btn_HideHair:IsCheck() then
      if isGameServiceTypeDev() then
        self.btn_HideHair:EraseAllEffect()
        self.btn_HideHair:AddEffect("UI_CashShop_HairChange", true, 0, 0)
      end
    elseif self.btn_HideHair:IsCheck() then
      self.btn_HideHair:EraseAllEffect()
    end
  else
    self.btn_HideHair:EraseAllEffect()
  end
end
function HandleClicked_CashShopController_ToggleHideHelm()
  local self = CashShopController
  local isChecked = self.btn_HideHelm:IsCheck()
  getIngameCashMall():setIsShowWithoutHelmet(isChecked)
end
function HandleClicked_CashShopController_ToggleOpenHelm()
  local self = CashShopController
  local isChecked = self.btn_OpenHelm:IsCheck()
  getIngameCashMall():setIsShowBattleHelmet(isChecked)
end
function HandleClicked_CashShopController_ToggleCloakInvisual()
  local self = CashShopController
  local isChecked = self.btn_Cloak_Invisual:IsCheck()
  getIngameCashMall():setIsShowCloak(not self.btn_Cloak_Invisual:IsCheck())
end
function HandleClicked_CashShopController_ToggleAwakenWeapon()
  local isChecked = CashShopController.btn_AwakenWeapon:IsCheck()
  getIngameCashMall():setAwakenWeaponView(isChecked)
end
function HandleClicked_CashShopController_ToggleWarStance()
  local isChecked = CashShopController.btn_WarStance:IsCheck()
  getIngameCashMall():setBattleView(isChecked)
end
function HandleClicked_CashShopController_AutoToggleUnderWear()
  local self = CashShopController
  self.btn_ShowUnderwear:SetCheck(true)
  self.btn_HideAvatar:SetCheck(false)
  getIngameCashMall():setIsShowUnderwear(true)
end
function HandleClicked_CashShopController_AutoToggleOffAll()
  local self = CashShopController
  self.btn_ShowUnderwear:SetCheck(false)
  self.btn_HideAvatar:SetCheck(false)
  getIngameCashMall():setIsShowUnderwear(false)
  getIngameCashMall():setIsShowWithoutAvatar(false)
end
function HandleClicked_CashShopController_AutoToggleUpHair(isUpHairMode)
  local self = CashShopController
  self.btn_HideHair:SetCheck(isUpHairMode)
  getIngameCashMall():setFaceVisibleHair(isUpHairMode)
end
function CashShopController_ForceOffAllButton()
  local self = CashShopController
  if self.btn_HideHelm:IsCheck() then
    self.btn_HideHelm:SetCheck(false)
    getIngameCashMall():setIsShowWithoutHelmet(false)
  end
  if self.btn_OpenHelm:IsCheck() then
    self.btn_OpenHelm:SetCheck(false)
    getIngameCashMall():setIsShowBattleHelmet(false)
  end
  if self.btn_Cloak_Invisual:IsCheck() then
    self.btn_Cloak_Invisual:SetCheck(false)
    getIngameCashMall():setIsShowCloak(not self.btn_Cloak_Invisual:IsCheck())
  end
  if self.btn_AwakenWeapon:IsCheck() then
    self.btn_AwakenWeapon:SetCheck(false)
    getIngameCashMall():setAwakenWeaponView(false)
  end
  if self.btn_WarStance:IsCheck() then
    self.btn_WarStance:SetCheck(false)
    getIngameCashMall():setBattleView(false)
  end
  if self.btn_ShowUnderwear:IsCheck() then
    self.btn_ShowUnderwear:SetCheck(false)
    getIngameCashMall():setIsShowUnderwear(false)
  end
  if self.btn_HideAvatar:IsCheck() then
    self.btn_HideAvatar:SetCheck(false)
    getIngameCashMall():setIsShowWithoutAvatar(false)
  end
  if self.btn_HideHair:IsCheck() then
    self.btn_HideHair:SetCheck(false)
    getIngameCashMall():setFaceVisibleHair(false)
  end
end
function cashShop_Controller_UpdateCharacterRotate(deltatime)
  local self = CashShopController
  if false == self.isLdown and false == self.isRdown then
    return
  end
  local currPos = getMousePosX()
  local currPosY = getMousePosY()
  if currPos == self.lMovePos and currPosY == self.yMovePos then
    return
  end
  local radianAngle = (self.lMovePos - currPos) / (getScreenSizeX() / 10)
  local cameraPitch = (currPosY - self.yMovePos) / (getScreenSizeY() / 2)
  self.lMovePos = currPos
  self.yMovePos = currPosY
  if self.isLdown then
    getIngameCashMall():varyCameraPositionByUpAndRightVector(radianAngle * 30, cameraPitch * 90)
  end
  if self.isRdown then
    getIngameCashMall():rotateViewCharacter(radianAngle)
    getIngameCashMall():varyCameraPitch(-cameraPitch / 1.5)
  end
end
function cashShop_Controller_Open()
  CashShopController:Open()
  CashShopController.petLookBG:SetShow(false)
  CashShopController.static_SetOptionBG:SetShow(false)
end
function cashShop_Controller_Close()
  CashShopController:Close()
end
function _cashShopController_ButtonTooltip(isShow, buttonType)
  local self = CashShopController
  local uiControl, name, desc
  if buttonType == 0 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUNDERWEAR")
    uiControl = self.btn_ShowUnderwear
  elseif buttonType == 1 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEAVATAR")
    uiControl = self.btn_HideAvatar
  elseif buttonType == 2 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDHAIR")
    uiControl = self.btn_HideHair
  elseif buttonType == 3 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_ALLDOFF")
    uiControl = self.btn_AllDoff
  elseif buttonType == 4 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_EYESEE")
    uiControl = self.BTN_EyeSee
  elseif buttonType == 5 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SHOWUI")
    uiControl = self.BTN_ShowUI
  elseif buttonType == 6 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_HIDEHELM")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELM_DESC")
    uiControl = self.btn_HideHelm
  elseif buttonType == 7 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SUNICON")
    uiControl = self.SunIcon
  elseif buttonType == 8 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_AWAKENWEAPON")
    uiControl = self.btn_AwakenWeapon
  elseif buttonType == 9 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_TOOLTIP_WARSTANCE")
    uiControl = self.btn_WarStance
  elseif buttonType == 10 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SPECIALACTION_TOOLTIP")
    uiControl = self.btn_SpecialMove
  elseif buttonType == 11 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_OPENHELM")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIPS_CHECKHELMOPEN_DESC")
    uiControl = self.btn_OpenHelm
  elseif buttonType == 12 then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_EQUIPMENT_TOOLTIP_CLOAK_DESC")
    uiControl = self.btn_Cloak_Invisual
  end
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FromClient_CashShopController_Resize()
  CashShopController:SetPosition()
end
function FromClient_ChangeAwakenWeapon(isAwakenWeaponView)
  CashShopController.btn_AwakenWeapon:SetCheck(isAwakenWeaponView)
end
function FromClient_ChangeCashshopBattle(isBattle)
  CashShopController.btn_WarStance:SetCheck(isBattle)
end
function HandleClicked_SunShineToggle()
  local self = CashShopController
  local sunShineCheck = self.SunIcon:IsCheck()
  local specialMoveCheck = self.btn_SpecialMove:IsCheck()
  if sunShineCheck or specialMoveCheck then
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      self.btn_Mileage:SetShow(true)
      self.btn_Mileage:SetSpanSize(10, 140)
      self.btn_Coupon:SetSpanSize(10, 180)
      self.btn_StampCoupon:SetSpanSize(10, 220)
      self.btn_FirstIgnore:SetSpanSize(10, 220)
      self.btn_SaleGoods:SetSpanSize(10, 260)
    else
      self.btn_Mileage:SetShow(false)
      self.btn_Coupon:SetSpanSize(10, 140)
      self.btn_StampCoupon:SetSpanSize(10, 180)
      self.btn_FirstIgnore:SetSpanSize(10, 180)
      self.btn_SaleGoods:SetSpanSize(10, 220)
    end
  elseif true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    self.btn_Mileage:SetShow(true)
    self.btn_Mileage:SetSpanSize(10, 90)
    self.btn_Coupon:SetSpanSize(10, 130)
    self.btn_StampCoupon:SetSpanSize(10, 170)
    self.btn_FirstIgnore:SetSpanSize(10, 170)
    self.btn_SaleGoods:SetSpanSize(10, 210)
  else
    self.btn_Mileage:SetShow(false)
    self.btn_Coupon:SetSpanSize(10, 90)
    self.btn_StampCoupon:SetSpanSize(10, 130)
    self.btn_FirstIgnore:SetSpanSize(10, 130)
    self.btn_SaleGoods:SetSpanSize(10, 170)
  end
  if self.btn_SpecialMove1:GetShow() then
    self.btn_SpecialMove1:SetShow(false)
    self.btn_SpecialMove2:SetShow(false)
    self.btn_SpecialMove:SetCheck(false)
  end
  self.SunShine1:SetShow(sunShineCheck)
  self.SunShine2:SetShow(sunShineCheck)
  self.SunShine3:SetShow(sunShineCheck)
  self.SunShine4:SetShow(sunShineCheck)
  self.SunShine5:SetShow(sunShineCheck)
  self.SunShine6:SetShow(sunShineCheck)
end
function HandleClicked_SunShineSetting(weatherType)
  if 1 == weatherType then
    weatherIndex = 0
  elseif 2 == weatherType then
    weatherIndex = 3
  elseif 3 == weatherType then
    weatherIndex = 7
  elseif 4 == weatherType then
    weatherIndex = 11
  elseif 5 == weatherType then
    weatherIndex = 15
  elseif 6 == weatherType then
    weatherIndex = 19
  end
  getIngameCashMall():setWeatherTime(6, weatherIndex)
end
function HandleClicked_SpecialMoveSetting(moveType)
  local animationValue = 0
  if 1 == moveType then
    animationValue = 1
  elseif 2 == moveType then
    animationValue = 2
  else
    animationValue = 0
  end
  local action = getIngameCashMall():getCharacterActionCount() - 1
  local animation = getIngameCashMall():getCharacterAnimationCount(action)
  if 0 == animation then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_SPECIALACTION"))
    return
  end
  CashShopController.btn_WarStance:SetCheck(false)
  getIngameCashMall():setBattleView(false)
  getIngameCashMall():setCharacterActionKey(getIngameCashMall():getCharacterActionCount() - 1, animationValue)
end
function HandleClicked_PetLookChangeTier(isBefore)
  local self = CashShopController
  local cashMallInfo = getIngameCashMall()
  if isBefore then
    cashMallInfo:changeViewPrevTierPet()
    if cashMallInfo:IsStartOfTierPet() then
      self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
      self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
      self.btn_petLookBefore:SetShow(false)
    else
      self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
      self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_OPTION"))
      self.btn_petLookBefore:SetShow(true)
    end
    if cashMallInfo:IsEndOfTierPet() then
      self.btn_petLookNext:SetShow(false)
    else
      self.btn_petLookNext:SetShow(true)
    end
  else
    cashMallInfo:changeViewNextTierPet()
    if cashMallInfo:IsEndOfTierPet() then
      self.btn_petLookNext:SetShow(false)
    else
      self.btn_petLookNext:SetShow(true)
    end
    if cashMallInfo:IsStartOfTierPet() then
      self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
      self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_DEFAULT_OPTION"))
      self.btn_petLookBefore:SetShow(false)
    else
      self.txt_petLookNameMain:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND"))
      self.txt_petLookNameSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SETEQUIP_LOOKAROUND_OPTION"))
      self.btn_petLookBefore:SetShow(true)
    end
  end
end
function FromClient_ChangeSpecialMove()
  local self = CashShopController
  local action = getIngameCashMall():getCharacterActionCount() - 1
  local animation = getIngameCashMall():getCharacterAnimationCount(action)
  if 0 == animation then
    self.btn_SpecialMove:SetShow(false)
    return
  end
  self.btn_SpecialMove:SetShow(true)
end
function FGlobal_SpecialMoveSettingCheck()
  local self = CashShopController
  local action = getIngameCashMall():getCharacterActionCount() - 1
  local characterAnimationCount = getIngameCashMall():getCharacterAnimationCount(action)
  self.btn_SpecialMove1:SetShow(false)
  self.btn_SpecialMove2:SetShow(false)
  self.btn_SpecialMove:SetShow(false)
  self.btn_SpecialMove:SetCheck(false)
  local specialMoveCheck = self.btn_SpecialMove:IsCheck()
  local sunShineCheck = self.SunIcon:IsCheck()
  if sunShineCheck or specialMoveCheck then
    if true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
      self.btn_Mileage:SetShow(true)
      self.btn_Mileage:SetSpanSize(10, 140)
      self.btn_Coupon:SetSpanSize(10, 180)
      self.btn_FirstIgnore:SetSpanSize(10, 220)
      self.btn_StampCoupon:SetSpanSize(10, 220)
      self.btn_SaleGoods:SetSpanSize(10, 260)
    else
      self.btn_Mileage:SetShow(false)
      self.btn_Coupon:SetSpanSize(10, 140)
      self.btn_FirstIgnore:SetSpanSize(10, 180)
      self.btn_StampCoupon:SetSpanSize(10, 180)
      self.btn_SaleGoods:SetSpanSize(10, 220)
    end
  elseif true == _ContentsGroup_PearlShopMileage and true == PaGlobal_CashMileage_IsOpenCheck() then
    self.btn_Mileage:SetShow(true)
    self.btn_Mileage:SetSpanSize(10, 90)
    self.btn_Coupon:SetSpanSize(10, 130)
    self.btn_FirstIgnore:SetSpanSize(10, 170)
    self.btn_StampCoupon:SetSpanSize(10, 170)
    self.btn_SaleGoods:SetSpanSize(10, 210)
  else
    self.btn_Mileage:SetShow(false)
    self.btn_Coupon:SetSpanSize(10, 90)
    self.btn_FirstIgnore:SetSpanSize(10, 130)
    self.btn_StampCoupon:SetSpanSize(10, 130)
    self.btn_SaleGoods:SetSpanSize(10, 170)
  end
end
function FGlobal_SpecialMoveSettingNoShow()
  local self = CashShopController
  self.btn_SpecialMove1:SetShow(false)
  self.btn_SpecialMove2:SetShow(false)
end
function FGlobal_CashShopController_InitEndurance(value)
  local self = CashShopController
  self.Slider_Endurance:SetControlPos(value)
  getIngameCashMall():setEquipmentEndurancePercents(value / 100)
end
function IngameCashShop_CameraHelp(isShow)
  local self = CashShopController
  if isShow then
    self.cameraControlBG:SetAlpha(1)
    self.cameraControlMoveBG:SetAlpha(1)
    self.cameraControlWheelBG:SetAlpha(1)
    self.cameraControlRotateBG:SetAlpha(1)
    self.cameraControlTitle:SetAlpha(1)
    self.cameraControlMove:SetAlpha(1)
    self.cameraControlWheel:SetAlpha(1)
    self.cameraControlRotate:SetAlpha(1)
    self.cameraControlTitle:SetFontColor(UI_color.C_FFC4BEBE)
    self.cameraControlMove:SetFontColor(UI_color.C_FFEFEFEF)
    self.cameraControlWheel:SetFontColor(UI_color.C_FFEFEFEF)
    self.cameraControlRotate:SetFontColor(UI_color.C_FFEFEFEF)
  else
    self.cameraControlBG:SetAlpha(0.8)
    self.cameraControlMoveBG:SetAlpha(0.8)
    self.cameraControlWheelBG:SetAlpha(0.8)
    self.cameraControlRotateBG:SetAlpha(0.8)
    self.cameraControlTitle:SetAlpha(0.8)
    self.cameraControlMove:SetAlpha(0.8)
    self.cameraControlWheel:SetAlpha(0.8)
    self.cameraControlRotate:SetAlpha(0.8)
    self.cameraControlTitle:SetFontColor(UI_color.C_AAFFFFFF)
    self.cameraControlMove:SetFontColor(UI_color.C_AAFFFFFF)
    self.cameraControlWheel:SetFontColor(UI_color.C_AAFFFFFF)
    self.cameraControlRotate:SetFontColor(UI_color.C_AAFFFFFF)
  end
end
function CashShopController:registEventHandler()
  self.GameTime_Slider:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetTime()")
  self.GameTime_SliderCtrlBTN:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetTime()")
  self.GameTime_SliderCtrlBTN:addInputEvent("Mouse_LPress", "HandleClicked_CashShopController_SetTime()")
  self.BTN_Light:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetLight()")
  self.BTN_EyeSee:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetCharacterViewCamera()")
  self.BTN_ShowUI:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetShowUIToggle()")
  self.ChaCTR_Area:addInputEvent("Mouse_LDown", "HandleClicked_CashShopController_SetCharacterRotate_Start(true)")
  self.ChaCTR_Area:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetCharacterRotate_End(true)")
  self.ChaCTR_Area:addInputEvent("Mouse_Out", "HandleClicked_CashShopController_SetCharacterRotate_End()")
  self.ChaCTR_Area:addInputEvent("Mouse_RDown", "HandleClicked_CashShopController_SetCharacterRotate_Start(false)")
  self.ChaCTR_Area:addInputEvent("Mouse_RUp", "HandleClicked_CashShopController_SetCharacterRotate_End(false)")
  self.ChaCTR_Area:addInputEvent("Mouse_UpScroll", "HandleClicked_CashShopController_SetCharacterScroll(true)")
  self.ChaCTR_Area:addInputEvent("Mouse_DownScroll", "HandleClicked_CashShopController_SetCharacterScroll(false)")
  self.Slider_Endurance:addInputEvent("Mouse_LPress", "HandleClicked_CashShopController_UpdateEndurance()")
  self.Slider_EnduranceCtrlBTN:addInputEvent("Mouse_LPress", "HandleClicked_CashShopController_UpdateEndurance()")
  self.btn_AllDoff:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_OffAllEquip()")
  self.btn_ShowUnderwear:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleUnderWear()")
  self.btn_HideAvatar:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleAvatar()")
  self.btn_HideHair:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleHideHair()")
  self.btn_HideHelm:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleHideHelm()")
  self.btn_OpenHelm:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleOpenHelm()")
  self.btn_Cloak_Invisual:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleCloakInvisual()")
  self.btn_AwakenWeapon:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleAwakenWeapon()")
  self.btn_WarStance:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_ToggleWarStance()")
  self.btn_ShowUnderwear:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 0 .. ")")
  self.btn_ShowUnderwear:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_HideAvatar:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 1 .. ")")
  self.btn_HideAvatar:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_HideHair:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 2 .. ")")
  self.btn_HideHair:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_HideHelm:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 6 .. ")")
  self.btn_HideHelm:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_OpenHelm:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 11 .. ")")
  self.btn_OpenHelm:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_Cloak_Invisual:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 12 .. ")")
  self.btn_Cloak_Invisual:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_AwakenWeapon:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 8 .. ")")
  self.btn_AwakenWeapon:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_WarStance:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 9 .. ")")
  self.btn_WarStance:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_AllDoff:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 3 .. ")")
  self.btn_AllDoff:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.BTN_EyeSee:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 4 .. ")")
  self.BTN_EyeSee:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.BTN_ShowUI:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 5 .. ")")
  self.BTN_ShowUI:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.SunIcon:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 7 .. ")")
  self.SunIcon:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.btn_SpecialMove:addInputEvent("Mouse_On", "_cashShopController_ButtonTooltip( true, " .. 10 .. ")")
  self.btn_SpecialMove:addInputEvent("Mouse_Out", "_cashShopController_ButtonTooltip( false )")
  self.cameraControlBG:addInputEvent("Mouse_On", "IngameCashShop_CameraHelp( true )")
  self.cameraControlBG:addInputEvent("Mouse_Out", "IngameCashShop_CameraHelp( false )")
  self.SunIcon:addInputEvent("Mouse_LUp", "HandleClicked_SunShineToggle()")
  self.SunShine1:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 1 )")
  self.SunShine2:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 2 )")
  self.SunShine3:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 3 )")
  self.SunShine4:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 4 )")
  self.SunShine5:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 5 )")
  self.SunShine6:addInputEvent("Mouse_LUp", "HandleClicked_SunShineSetting( 6 )")
  self.btn_SpecialMove:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_SetSpecialMove()")
  self.btn_SpecialMove1:addInputEvent("Mouse_LUp", "HandleClicked_SpecialMoveSetting( 1 )")
  self.btn_SpecialMove2:addInputEvent("Mouse_LUp", "HandleClicked_SpecialMoveSetting( 2 )")
  Panel_IngameCashShop_Controller:RegisterUpdateFunc("cashShop_Controller_UpdateCharacterRotate")
  self.btn_petLookBefore:addInputEvent("Mouse_LUp", "HandleClicked_PetLookChangeTier(true)")
  self.btn_petLookNext:addInputEvent("Mouse_LUp", "HandleClicked_PetLookChangeTier(false)")
  self.btn_Coupon:addInputEvent("Mouse_LUp", "IngameCashShopCoupon_Open()")
  self.btn_StampCoupon:addInputEvent("Mouse_LUp", "FromClient_PearlStampShow()")
  self.btn_FirstIgnore:addInputEvent("Mouse_LUp", "HandleClicked_CashShopController_FirstIgnore()")
  self.btn_SaleGoods:addInputEvent("Mouse_LUp", "InGameShop_GotoSaleTab()")
  self.btn_Mileage:addInputEvent("Mouse_LUp", "PaGlobal_CashMileage_Open()")
end
function CashShopController:registMessageHandler()
  registerEvent("onScreenResize", "FromClient_CashShopController_Resize")
  registerEvent("FromClient_ChangeAwakenWeapon", "FromClient_ChangeAwakenWeapon")
  registerEvent("FromClient_ChangeSpecialMove", "FromClient_ChangeSpecialMove")
end
CashShopController:Initialize()
CashShopController:registEventHandler()
CashShopController:registMessageHandler()
CashShopController:StampCoupon_Init()
