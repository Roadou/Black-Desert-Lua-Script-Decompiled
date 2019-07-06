local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_CCC = CppEnums.CashProductCategory
local UI_CIT = CppEnums.InstallationType
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
Panel_House_InstallationMode:SetShow(false)
local renderMode = RenderModeWrapper.new(99, {
  Defines.RenderMode.eRenderMode_HouseInstallation
}, false)
local HouseInstallation = {
  panelTitle = UI.getChildControl(Panel_House_InstallationMode, "Static_Title"),
  installedObjectCount = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InstalledObject"),
  bg_Menu = UI.getChildControl(Panel_House_InstallationMode, "Static_MenuBG"),
  bg_Menu_Top = UI.getChildControl(Panel_House_InstallationMode, "Static_MenuTopBG"),
  radio_AttAll = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeAll"),
  radio_AttFloor = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeFloor"),
  radio_AttWall = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeWall"),
  radio_AttAllHarvest = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeAllHarvest"),
  radio_AttHarvest = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeHarvest"),
  radio_AttOthers = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeOthers"),
  radio_AttTabel = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_AttributeTabel"),
  edit_ItemName = UI.getChildControl(Panel_House_InstallationMode, "Edit_ItemName"),
  btn_Search = UI.getChildControl(Panel_House_InstallationMode, "Button_Search"),
  bg_Menu_Bottom = UI.getChildControl(Panel_House_InstallationMode, "Static_Menu_BottomBG"),
  btn_Exit = UI.getChildControl(Panel_House_InstallationMode, "Button_Exit"),
  btn_RotateLeft = UI.getChildControl(Panel_House_InstallationMode, "Button_CameraRotation_Left"),
  btn_RotateRight = UI.getChildControl(Panel_House_InstallationMode, "Button_CameraRotation_Right"),
  btn_RotateAngle = UI.getChildControl(Panel_House_InstallationMode, "CheckButton_ObjectRotateAngle45"),
  btn_ResetArrangement = UI.getChildControl(Panel_House_InstallationMode, "Button_ResetFurniture"),
  btn_ExitInstallMode = UI.getChildControl(Panel_House_InstallationMode, "Button_ExitInstallMode"),
  bg_List = UI.getChildControl(Panel_House_InstallationMode, "Static_ListBG"),
  scroll = UI.getChildControl(Panel_House_InstallationMode, "Scroll_List"),
  _staticBackFloor = UI.getChildControl(Panel_House_InstallationMode, "Static_BackFloor"),
  _staticTextFloor = UI.getChildControl(Panel_House_InstallationMode, "StaticText_Floor"),
  _radioBtnFirstFloor = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_FirstFloor"),
  _radioBtnSecondFloor = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_SecondFloor"),
  _radioBtnThirdFloor = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_ThirdFloor"),
  _radioBtnFourFloor = UI.getChildControl(Panel_House_InstallationMode, "RadioButton_FourFloor"),
  _staticInteriorSensePoint = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorSensePoint"),
  InteriorPointBG = UI.getChildControl(Panel_House_InstallationMode, "Static_InteriorPointBG"),
  InteriorPointBaseText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointBase"),
  InteriorPointOptionText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointOption"),
  InteriorPointBonusText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointBonus"),
  InteriorPointTotalText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointTotal"),
  InteriorPointBaseValueText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointBaseValue"),
  InteriorPointOptionValueText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointOptionValue"),
  InteriorPointBonusValueText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointBonusValue"),
  InteriorPointTotalValueText = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorPointTotalValue"),
  maxSlotCount = 36,
  slotUIPool = {},
  maxInterval = 0,
  nowInterval = 0,
  filter_ItemType = -1,
  filter_SearchKeyword = "",
  dataCount = 0,
  SlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createCash = true
  },
  _isModeShow = false,
  isInstallMode = false,
  houseInstallationMode = false,
  deleteItemIdx = nil,
  _isMyHouse = false
}
HouseInstallation.bg_List:setGlassBackground(true)
HouseInstallation.bg_Menu:setGlassBackground(true)
HouseInstallation._staticInteriorSensePoint:SetFontColor(4293914607)
HouseInstallation._staticInteriorSensePoint:useGlowFont(true, "BaseFont_10_Glow", 4292411606)
HouseInstallation._staticInteriorSensePoint:SetShow(false)
HouseInstallation.scrollCTRLBTN = UI.getChildControl(HouseInstallation.scroll, "Scroll_CtrlButton")
local buttonEum = {
  All = 0,
  Floor = 1,
  Wall = 2,
  Table = 3,
  AllHarvest = 4,
  Harvest = 5,
  Tool = 6,
  Rotate_Right = 7,
  Rotate_Left = 8,
  RotateAngle_45 = 9,
  Reset = 10
}
local Template = {
  nomalIconBG = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_HaveFurnitureIconBG"),
  cashIconBG = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_CashIconBG"),
  installedIcon = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_IsInstalled"),
  slot = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_Slot")
}
local furnitureData = Array.new()
function HouseInstallation:Initialize()
  local function do_Initialize()
    self.bg_Menu:AddChild(self.bg_Menu_Top)
    self.bg_Menu:AddChild(self.bg_Menu_Bottom)
    Panel_House_InstallationMode:RemoveControl(self.bg_Menu_Top)
    Panel_House_InstallationMode:RemoveControl(self.bg_Menu_Bottom)
    Panel_House_InstallationMode:RemoveControl(self._staticTextFloor)
    Panel_House_InstallationMode:RemoveControl(self._radioBtnFirstFloor)
    Panel_House_InstallationMode:RemoveControl(self._radioBtnSecondFloor)
    Panel_House_InstallationMode:RemoveControl(self._radioBtnThirdFloor)
    Panel_House_InstallationMode:RemoveControl(self._radioBtnFourFloor)
    self._staticBackFloor:AddChild(self._staticTextFloor)
    self._staticBackFloor:AddChild(self._radioBtnFirstFloor)
    self._staticBackFloor:AddChild(self._radioBtnSecondFloor)
    self._staticBackFloor:AddChild(self._radioBtnThirdFloor)
    self._staticBackFloor:AddChild(self._radioBtnFourFloor)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttAll)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttFloor)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttWall)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttTabel)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttAllHarvest)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttHarvest)
    Panel_House_InstallationMode:RemoveControl(self.radio_AttOthers)
    Panel_House_InstallationMode:RemoveControl(self.edit_ItemName)
    Panel_House_InstallationMode:RemoveControl(self.btn_Search)
    self.bg_Menu_Top:AddChild(self.radio_AttAll)
    self.bg_Menu_Top:AddChild(self.radio_AttFloor)
    self.bg_Menu_Top:AddChild(self.radio_AttWall)
    self.bg_Menu_Top:AddChild(self.radio_AttTabel)
    self.bg_Menu_Top:AddChild(self.radio_AttAllHarvest)
    self.bg_Menu_Top:AddChild(self.radio_AttHarvest)
    self.bg_Menu_Top:AddChild(self.radio_AttOthers)
    self.bg_Menu_Top:AddChild(self.edit_ItemName)
    self.bg_Menu_Top:AddChild(self.btn_Search)
    Panel_House_InstallationMode:RemoveControl(self.btn_Exit)
    Panel_House_InstallationMode:RemoveControl(self.btn_RotateLeft)
    Panel_House_InstallationMode:RemoveControl(self.btn_RotateRight)
    Panel_House_InstallationMode:RemoveControl(self.btn_RotateAngle)
    Panel_House_InstallationMode:RemoveControl(self.btn_ResetArrangement)
    self.bg_Menu_Bottom:AddChild(self.btn_Exit)
    self.bg_Menu_Bottom:AddChild(self.btn_RotateLeft)
    self.bg_Menu_Bottom:AddChild(self.btn_RotateRight)
    self.bg_Menu_Bottom:AddChild(self.btn_RotateAngle)
    self.bg_Menu_Bottom:AddChild(self.btn_ResetArrangement)
    Panel_House_InstallationMode:RemoveControl(self.scroll)
    self.bg_List:AddChild(self.scroll)
    self.bg_Menu:SetVerticalBottom()
    self.bg_Menu_Top:SetPosX(5)
    self.bg_Menu_Top:SetPosY(5)
    local _menuTopPosX = 5
    local _menuTopPosY = 5
    self.radio_AttAll:SetPosX(_menuTopPosX)
    self.radio_AttAll:SetPosY(_menuTopPosY)
    self.radio_AttAllHarvest:SetPosX(_menuTopPosX)
    self.radio_AttAllHarvest:SetPosY(_menuTopPosY)
    _menuTopPosX = _menuTopPosX + self.radio_AttAll:GetSizeX() + 3
    self.radio_AttFloor:SetPosX(_menuTopPosX)
    self.radio_AttFloor:SetPosY(_menuTopPosY)
    self.radio_AttHarvest:SetPosX(_menuTopPosX)
    self.radio_AttHarvest:SetPosY(_menuTopPosY)
    _menuTopPosX = _menuTopPosX + self.radio_AttFloor:GetSizeX() + 3
    self.radio_AttWall:SetPosX(_menuTopPosX)
    self.radio_AttWall:SetPosY(_menuTopPosY)
    self.radio_AttOthers:SetPosX(_menuTopPosX)
    self.radio_AttOthers:SetPosY(_menuTopPosY)
    _menuTopPosX = _menuTopPosX + self.radio_AttWall:GetSizeX() + 3
    self.radio_AttTabel:SetPosX(_menuTopPosX)
    self.radio_AttTabel:SetPosY(_menuTopPosY)
    _menuTopPosX = _menuTopPosX + self.radio_AttTabel:GetSizeX() + 3
    _menuTopPosX = 10
    _menuTopPosY = _menuTopPosY + self.radio_AttAll:GetSizeY() + 5
    self.edit_ItemName:SetPosX(_menuTopPosX)
    self.edit_ItemName:SetPosY(_menuTopPosY)
    _menuTopPosX = _menuTopPosX + self.edit_ItemName:GetSizeX() + 2
    self.btn_Search:SetPosX(_menuTopPosX)
    self.btn_Search:SetPosY(_menuTopPosY)
    self.bg_Menu_Bottom:SetPosX(5)
    self.bg_Menu_Bottom:SetPosY(self.bg_Menu_Top:GetPosY() + self.bg_Menu_Top:GetSizeY() + 5)
    local _menuBottomPosX = 5
    local _menuBottomPosY = 5
    self.btn_Exit:SetPosX(_menuBottomPosX)
    self.btn_Exit:SetPosY(_menuBottomPosY)
    _menuBottomPosX = _menuBottomPosX + self.btn_Exit:GetSizeX() + 7
    self.btn_RotateRight:SetPosX(_menuBottomPosX)
    self.btn_RotateRight:SetPosY(_menuBottomPosY)
    _menuBottomPosX = _menuBottomPosX + self.btn_RotateRight:GetSizeX() + 3
    self.btn_RotateLeft:SetPosX(_menuBottomPosX)
    self.btn_RotateLeft:SetPosY(_menuBottomPosY)
    _menuBottomPosX = _menuBottomPosX + self.btn_RotateLeft:GetSizeX() + 3
    self.btn_RotateAngle:SetPosX(_menuBottomPosX)
    self.btn_RotateAngle:SetPosY(_menuBottomPosY)
    _menuBottomPosX = _menuBottomPosX + self.btn_RotateAngle:GetSizeX() + 3
    self.btn_ResetArrangement:SetPosX(_menuBottomPosX)
    self.btn_ResetArrangement:SetPosY(_menuBottomPosY)
    self.bg_List:SetVerticalBottom()
  end
  do_Initialize()
  local SlotStartX = 12
  local SlotStartY = 7
  local SlotGapX = 55
  local SlotGapY = 55
  local SlotCols = 18
  local function do_MakeSlot()
    for slot_Idx = 0, self.maxSlotCount - 1 do
      local tempArray = {}
      local col = slot_Idx % SlotCols
      local row = math.floor(slot_Idx / SlotCols)
      local posX = SlotStartX + SlotGapX * col
      local posY = SlotStartY + SlotGapY * row
      local created_normalSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self.bg_List, "Panel_House_Installation_normalSlot_" .. slot_Idx)
      CopyBaseProperty(Template.nomalIconBG, created_normalSlot)
      created_normalSlot:SetShow(true)
      created_normalSlot:SetPosX(posX)
      created_normalSlot:SetPosY(posY)
      tempArray.normalBG = created_normalSlot
      local created_cashSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self.bg_List, "Panel_House_Installation_cashSlot_" .. slot_Idx)
      CopyBaseProperty(Template.cashIconBG, created_cashSlot)
      created_cashSlot:SetShow(false)
      created_cashSlot:SetPosX(posX)
      created_cashSlot:SetPosY(posY)
      tempArray.cashBG = created_cashSlot
      local slot = {}
      SlotItem.new(slot, "Panel_House_Installation_SlotItem_" .. slot_Idx, slot_Idx, self.bg_List, self.SlotConfig)
      slot:createChild()
      slot.icon:SetPosX(posX + 3)
      slot.icon:SetPosY(posY + 3)
      slot.icon:SetShow(false)
      tempArray.slotItem = slot
      local created_InstalledMark = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self.bg_List, "Panel_House_Installation_InstalledMark_" .. slot_Idx)
      CopyBaseProperty(Template.installedIcon, created_InstalledMark)
      created_InstalledMark:SetShow(false)
      created_InstalledMark:SetIgnore(true)
      created_InstalledMark:SetPosX(slot.icon:GetPosX() + slot.icon:GetSizeX() - created_InstalledMark:GetSizeX() + 5)
      created_InstalledMark:SetPosY(slot.icon:GetPosY() + slot.icon:GetSizeY() - created_InstalledMark:GetSizeY() + 5)
      tempArray.installedMark = created_InstalledMark
      self.slotUIPool[slot_Idx] = tempArray
    end
  end
  do_MakeSlot()
  self.scroll:SetControlTop()
  self.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
end
function HouseInstallation:SetPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  Panel_House_InstallationMode:SetSize(scrSizeX, scrSizeY)
  self.bg_Menu:ComputePos()
  self.bg_List:ComputePos()
  self.scroll:ComputePos()
  self.btn_ExitInstallMode:ComputePos()
  self._staticBackFloor:SetPosX(self.installedObjectCount:GetPosX() + 10)
  self._staticBackFloor:SetPosY(self.installedObjectCount:GetPosY() + self.installedObjectCount:GetSizeY())
end
function HouseInstallation:CheckFilter(objectStaticStatusWrapper, itemSS)
  local installPosition = -1
  local isFilterPass = true
  if self.houseInstallationMode then
    if objectStaticStatusWrapper:isInstallableOnFloor() then
      installPosition = 0
    elseif objectStaticStatusWrapper:isInstallableOnWall() then
      installPosition = 1
    elseif objectStaticStatusWrapper:isInstallableOnTheTable() then
      installPosition = 2
    end
  elseif CppEnums.InstallationType.eType_Havest == objectStaticStatusWrapper:getInstallationType() then
    installPosition = 0
  elseif CppEnums.InstallationType.eType_LivestockHarvest == objectStaticStatusWrapper:getInstallationType() then
    installPosition = 0
  elseif CppEnums.InstallationType.eType_Scarecrow == objectStaticStatusWrapper:getInstallationType() then
    installPosition = 1
  elseif CppEnums.InstallationType.eType_Waterway == objectStaticStatusWrapper:getInstallationType() then
    installPosition = 1
  else
    isFilterPass = false
  end
  if -1 ~= self.filter_ItemType and installPosition ~= self.filter_ItemType then
    isFilterPass = false
  elseif "" ~= self.filter_SearchKeyword and nil == string.find(itemSS:getName(), self.filter_SearchKeyword) then
    isFilterPass = false
  end
  return isFilterPass
end
function HouseInstallation:SetInstalledData(houseWrapper)
  local installedItemCount = houseWrapper:getInstallationCount()
  for installed_Idx = 0, installedItemCount do
    local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(installed_Idx)
    local installationActorWrapper = getInstallationActor(actorKeyRaw)
    if nil ~= installationActorWrapper then
      local cssWrapper = installationActorWrapper:getStaticStatusWrapper()
      local itemSSW = cssWrapper:getItemEnchantStatcStaticWrapper()
      local objectStaticStatus = cssWrapper:getObjectStaticStatus()
      if true == self:CheckFilter(objectStaticStatus, itemSSW) then
        furnitureData:push_back({
          name = itemSSW:getName(),
          iconPath = itemSSW:getIconPath(),
          installPos = installPosition,
          desc = nil,
          isCashProduct = false,
          isInstalled = true,
          productNoRaw = 0,
          invenType = 0,
          invenSlotNo = installed_Idx
        })
      end
    end
  end
end
function HouseInstallation:SetNonInstalledData(houseWrapper)
  local inven_normalNo = 0
  local inven_cashNo = 17
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local function get_inventoryInfo(invenType)
    local inventory = selfPlayer:getInventoryByType(invenType)
    local inventorySize = inventory:size()
    return inventory, inventorySize
  end
  local inven_Normal, invenSize_Normal = get_inventoryInfo(inven_normalNo)
  local inven_Cash, invenSize_Cash = get_inventoryInfo(inven_cashNo)
  for normal_Idx = 0, invenSize_Normal - 1 do
    local itemWrapper = getInventoryItemByType(inven_normalNo, normal_Idx)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local cssWrapper = itemSSW:getCharacterStaticStatus()
      if itemWrapper:getStaticStatus():get():isItemInstallation() then
        local objectStaticStatus = cssWrapper:getObjectStaticStatus()
        local isFixedHouseElement = CppEnums.InstallationType.eType_Havest ~= objectStaticStatus:getInstallationType() and CppEnums.InstallationType.eType_LivestockHarvest ~= objectStaticStatus:getInstallationType() and CppEnums.InstallationType.eType_Scarecrow ~= objectStaticStatus:getInstallationType() and CppEnums.InstallationType.eType_Waterway ~= objectStaticStatus:getInstallationType()
        if isFixedHouseElement == self.houseInstallationMode then
          local itemSS = itemWrapper:getStaticStatus()
          if true == self:CheckFilter(objectStaticStatus, itemSS) then
            furnitureData:push_back({
              name = itemSS:getName(),
              iconPath = itemSS:getIconPath(),
              installPos = installPosition,
              desc = itemSS:getDescription(),
              isCashProduct = false,
              isInstalled = false,
              productNoRaw = 0,
              invenType = inven_normalNo,
              invenSlotNo = normal_Idx
            })
          end
        end
      end
    end
  end
  for cash_Idx = 0, invenSize_Cash - 1 do
    local itemWrapper = getInventoryItemByType(inven_cashNo, cash_Idx)
    if nil ~= itemWrapper and itemWrapper:getStaticStatus():get():isItemInstallation() and not itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus():isHarvest() then
      local itemSS = itemWrapper:getStaticStatus()
      local objectStaticStatus = itemWrapper:getStaticStatus():getCharacterStaticStatus():getObjectStaticStatus()
      if true == self:CheckFilter(objectStaticStatus, itemSS) then
        furnitureData:push_back({
          name = itemSS:getName(),
          iconPath = itemSS:getIconPath(),
          installPos = installPosition,
          desc = itemSS:getDescription(),
          isCashProduct = false,
          isInstalled = false,
          productNoRaw = 0,
          invenType = inven_cashNo,
          invenSlotNo = cash_Idx
        })
      end
    end
  end
end
function HouseInstallation:SetPearlData()
  local count = getIngameCashMall():getCashProductStaticStatusListCount()
  for index = 0, count - 1 do
    do
      local cashProductStaticStatus = getIngameCashMall():getCashProductStaticStatusByIndex(index)
      if UI_CCC.eCashProductCategory_Furniture == cashProductStaticStatus:getMainCategory() and cashProductStaticStatus:getItemListCount() < 2 then
        do
          local itemSS = cashProductStaticStatus:getItemByIndex(0)
          if nil ~= itemSS and itemSS:get():isItemInstallation() then
            do
              local objectStaticStatus = itemSS:getCharacterStaticStatus():getObjectStaticStatus()
              local installationType = objectStaticStatus:getInstallationType()
              local startSaleTime = cashProductStaticStatus:getStartSellTime()
              local startSaleTime_s32 = Int64toInt32(getLeftSecond_TTime64(startSaleTime))
              local endSaleTime = cashProductStaticStatus:getEndSellTime()
              local endSaleTime_s32 = Int64toInt32(getLeftSecond_TTime64(endSaleTime))
              local isSellTimePass = not cashProductStaticStatus:isSellTimeBefore() and not cashProductStaticStatus:isSellTimeOver()
              local function setDataDo()
                if true == isSellTimePass and true == self:CheckFilter(objectStaticStatus, itemSS) then
                  furnitureData:push_back({
                    name = itemSS:getName(),
                    iconPath = itemSS:getIconPath(),
                    installPos = installPosition,
                    desc = itemSS:getDescription(),
                    isCashProduct = true,
                    isInstalled = false,
                    productNoRaw = cashProductStaticStatus:getNoRaw(),
                    invenType = 0,
                    invenSlotNo = 0
                  })
                end
              end
              if cashProductStaticStatus:isMallDisplayable() then
                if UI_CIT.eType_WallPaper == installationType or UI_CIT.eType_FloorMaterial == installationType then
                  if true == HouseInstallation._isMyHouse then
                    setDataDo()
                  end
                else
                  setDataDo()
                end
              end
            end
          end
        end
      end
    end
  end
end
function HouseInstallation:SetData()
  furnitureData = Array.new()
  local showMyInstallation = HouseInstallation._isMyHouse or not self.houseInstallationMode
  if showMyInstallation then
    self:SetNonInstalledData()
  end
  if FGlobal_IsCommercialService() then
    self:SetPearlData()
  end
  if showMyInstallation then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    if houseWrapper then
      self:SetInstalledData(houseWrapper)
    end
  end
  self.dataCount = #furnitureData
end
function HouseInstallation:SetScroll()
  local dataCount = self.dataCount
  local hideCount = dataCount - self.maxSlotCount
  local countByline = self.maxSlotCount / 2
  local totalLine = math.ceil(dataCount / countByline)
  local interval = totalLine
  if interval < 0 then
    interval = 0
  end
  self.maxInterval = interval
  self.nowInterval = 0
  self.scroll:SetInterval(self.maxInterval)
  local viewLine = self.maxSlotCount / countByline
  local pagePercent = viewLine / totalLine * 100
  local scrollSizeY = self.scroll:GetSizeY()
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent * 0.85
  if btn_scrollSizeY < 20 then
    btn_scrollSizeY = 20
  end
  if btn_scrollSizeY > scrollSizeY - 5 then
    btn_scrollSizeY = scrollSizeY - 5
  end
  self.scrollCTRLBTN:SetSize(self.scrollCTRLBTN:GetSizeX(), btn_scrollSizeY)
end
function HouseInstallation:Update(nowInterval)
  for slot_Idx = 0, self.maxSlotCount - 1 do
    local Uislot = self.slotUIPool[slot_Idx]
    Uislot.slotItem.icon:addInputEvent("Mouse_On", "")
    Uislot.slotItem.icon:addInputEvent("Mouse_Out", "")
    Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "")
    Uislot.slotItem:clearItem()
    Uislot.normalBG:SetShow(true)
    Uislot.cashBG:SetShow(false)
    Uislot.installedMark:SetShow(false)
  end
  HouseInstallation._staticInteriorSensePoint:SetShow(false)
  if true == self.houseInstallationMode then
  else
    local houseActorWrapper = housing_getHouseholdActor_CurrentPosition()
    if nil == houseActorWrapper then
      _PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()\234\176\128 nullptr \236\157\180\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.")
      return
    end
    local css = houseActorWrapper:getStaticStatusWrapper():get()
    self.installedObjectCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_INSTALLOBJECTCOUNT", "sum", houseActorWrapper:getInstallationCountSum(), "maxCount", css:getInstallationMaxCount()))
  end
  for slot_Idx = 0, self.maxSlotCount - 1 do
    if self.maxSlotCount < self.dataCount then
      self.scroll:SetShow(true)
    else
      self.scroll:SetShow(false)
    end
    local dataIdx = nowInterval * (self.maxSlotCount / 2) + slot_Idx + 1
    local Uislot = self.slotUIPool[slot_Idx]
    local Data = furnitureData[dataIdx]
    local itemWrapper, itemStaticStatus
    if nil == Data then
      return
    end
    if true == Data.isInstalled then
      local houseWrapper = housing_getHouseholdActor_CurrentPosition()
      local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(Data.invenSlotNo)
      local installationActorWrapper = getInstallationActor(actorKeyRaw)
      if nil ~= installationActorWrapper then
        local cssWrapper = installationActorWrapper:getStaticStatusWrapper()
        local itemSSW = cssWrapper:getItemEnchantStatcStaticWrapper()
        local installationCount = cssWrapper:get():getInstallationMaxCount()
        Uislot.slotItem:setItemByStaticStatus(itemSSW, 0)
        Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_Delete_InstalledObject( " .. dataIdx .. " ," .. Data.invenSlotNo .. " )")
        Uislot.slotItem.icon:addInputEvent("Mouse_On", "_houseInstallation_ShowInstalledItemToolTip( " .. Data.invenSlotNo .. ", " .. slot_Idx .. " )")
        Uislot.normalBG:SetShow(true)
        Uislot.cashBG:SetShow(false)
        Uislot.installedMark:SetShow(true)
      end
    elseif not Data.isCashProduct then
      itemWrapper = getInventoryItemByType(Data.invenType, Data.invenSlotNo)
      Uislot.slotItem:setItem(itemWrapper)
      Uislot.slotItem.icon:addInputEvent("Mouse_On", "_houseInstallation_ShowToolTip( " .. Data.invenType .. ", " .. Data.invenSlotNo .. ", " .. slot_Idx .. " )")
      Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "_houseInstallation_InstallFurniture( " .. Data.invenType .. ", " .. Data.invenSlotNo .. ", false, " .. 0 .. ")")
      Uislot.normalBG:SetShow(true)
      Uislot.cashBG:SetShow(false)
      Uislot.installedMark:SetShow(false)
    else
      local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(Data.productNoRaw)
      itemStaticStatus = cPSSW:getItemByIndex(0)
      if nil ~= itemStaticStatus then
        Uislot.slotItem:setItemByStaticStatus(itemStaticStatus, 0)
        Uislot.slotItem.icon:addInputEvent("Mouse_On", "_houseInstallation_CashItemShowToolTip( " .. Data.productNoRaw .. ", " .. slot_Idx .. " )")
        Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "_houseInstallation_InstallFurniture( " .. Data.invenType .. ", " .. Data.invenSlotNo .. ", true, " .. Data.productNoRaw .. ")")
        Uislot.normalBG:SetShow(false)
        Uislot.cashBG:SetShow(true)
        Uislot.installedMark:SetShow(false)
      end
    end
    Uislot.slotItem.icon:SetAlpha(1)
    Uislot.slotItem.icon:SetShow(true)
    Uislot.slotItem.icon:addInputEvent("Mouse_Out", "_houseInstallation_HideToolTip()")
    Uislot.slotItem.icon:addInputEvent("Mouse_DownScroll", "_houseInstallation_UpdateScroll( true )")
    Uislot.slotItem.icon:addInputEvent("Mouse_UpScroll", "_houseInstallation_UpdateScroll( false )")
    if self.dataCount == dataIdx then
      return
    end
  end
end
function HouseInstallation:Open()
  _PA_LOG("\236\167\128\235\175\188\237\152\129", "HouseInstallation:Open()")
  ToClient_SaveUiInfo(false)
  if not IsSelfPlayerWaitAction() and not IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE"))
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  EventHousingPointUpdateClear()
  if housing_isBuildMode() then
    self.isInstallMode = false
  else
    local rv = housing_changeHousingMode(true, HouseInstallation._isMyHouse)
    if 0 ~= rv then
      _PA_LOG("\236\167\128\235\175\188\237\152\129", "housing_changeHousingMode Failed...")
      return
    end
    self.isInstallMode = true
  end
  audioPostEvent_SystemUi(1, 32)
  SetUIMode(Defines.UIMode.eUIMode_Housing)
  if Panel_Chatting_Input:IsShow() then
    ChatInput_CancelAction()
    ChatInput_CancelMessage()
    ChatInput_Close()
  end
  ClearFocusEdit()
  renderMode:set()
  crossHair_SetShow(false)
  setShowLine(false)
  HouseInstallation:SetPosition()
  if true == self.isInstallMode then
    self:Open_ObjectInstallMode(isShow)
  else
    self:Open_ItemInstallMode(isShow)
  end
  Panel_House_InstallationMode:SetShow(true)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_BUILDMODE")
end
function HouseInstallation:Open_ObjectInstallMode(isShow)
  if not IsSelfPlayerWaitAction() and not IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE"))
    return
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
    return
  end
  self.houseInstallationMode = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  self.bg_Menu:SetShow(true)
  self.bg_List:SetShow(true)
  self.btn_ExitInstallMode:SetShow(false)
  self.filter_ItemType = -1
  if true == self.houseInstallationMode then
    self.radio_AttAll:SetCheck(true)
    self.radio_AttAllHarvest:SetCheck(false)
  else
    self.radio_AttAllHarvest:SetCheck(true)
    self.radio_AttAll:SetCheck(false)
  end
  self.radio_AttFloor:SetCheck(false)
  self.radio_AttWall:SetCheck(false)
  self.radio_AttTabel:SetCheck(false)
  self.radio_AttHarvest:SetCheck(false)
  self.radio_AttOthers:SetCheck(false)
  HouseInstallation:SetData()
  HouseInstallation:SetScroll()
  HouseInstallation:Update(HouseInstallation.nowInterval)
  if true == self.houseInstallationMode then
    if HouseInstallation._isMyHouse then
      self.panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1"))
    else
      self.panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1") .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_HAPPYYOU"))
    end
    self.installedObjectCount:SetShow(false)
    FGlobal_House_InstallationModeCart_Open()
    self:ShowFloorStatic(true)
    EventHousingPointUpdate()
  else
    self.panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE2"))
    self.installedObjectCount:SetShow(true)
    self:ShowFloorStatic(false)
  end
  self.radio_AttAll:SetShow(true == self.houseInstallationMode)
  self.radio_AttFloor:SetShow(true == self.houseInstallationMode)
  self.radio_AttWall:SetShow(true == self.houseInstallationMode)
  self.radio_AttTabel:SetShow(true == self.houseInstallationMode)
  self.radio_AttAllHarvest:SetShow(false == self.houseInstallationMode)
  self.radio_AttHarvest:SetShow(false == self.houseInstallationMode)
  self.radio_AttOthers:SetShow(false == self.houseInstallationMode)
end
function HouseInstallation:Open_ItemInstallMode(isShow)
  self.panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_SETUP"))
  self.btn_ExitInstallMode:SetShow(true)
  self.installedObjectCount:SetShow(false)
  self:ShowFloorStatic(false)
  self.bg_Menu:SetShow(false)
  self.bg_List:SetShow(false)
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  if nil ~= characterStaticWrapper then
    local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
    local isHealingTower = objectStaticWrapper:isHealingTower()
    local isObservatory = objectStaticWrapper:isObservatory()
    local isElephantBarn = objectStaticWrapper:isElephantBarn()
    local isCatapultFactory = objectStaticWrapper:isCatapultFactory()
    local isFlameFactory = objectStaticWrapper:isFlameFactory()
    local isBarricade = objectStaticWrapper:isBarricade()
    local isDistributor = objectStaticWrapper:isDistributor()
    local isBarricadeGate = objectStaticWrapper:isBarricadeGate()
    local isWoodenFence = objectStaticWrapper:isWoodenFenceBase()
    local isDefenceTower = objectStaticWrapper:isDefenceTower()
    local isSiegeTower = objectStaticWrapper:isSiegeTower()
    local isLargeSiegeTower = objectStaticWrapper:isLargeSiegeTower()
    local isAdvanceBaseTower = objectStaticWrapper:isAdvancedBaseTower()
    local isSavageDefenceObject = objectStaticWrapper:isSavageDefenceObject()
    local isBallistaFactory = objectStaticWrapper:isBallistaFactory()
    local isMinorWarOpen = isHealingTower or isObservatory or isElephantBarn or isCatapultFactory or isFlameFactory or isBarricade or isDistributor or isBarricadeGate or isWoodenFence or isDefenceTower or isSiegeTower or isLargeSiegeTower or isAdvanceBaseTower or isBallistaFactory or isSavageDefenceObject
    if isMinorWarOpen then
      FGlobal_HouseInstallation_MinorWar_Open()
    else
      FGlobal_HouseInstallation_MinorWar_Close()
    end
  end
end
function HouseInstallation:ShowFloorStatic(isShow)
  if false == isShow then
    self._staticBackFloor:SetShow(false)
    return
  end
  local numFloor = housing_getHouseFloorCount()
  if numFloor <= 1 then
    self._staticBackFloor:SetShow(false)
    return
  end
  self._staticBackFloor:SetShow(true)
  local sizeY = 0
  if numFloor <= 2 then
    self._radioBtnFirstFloor:SetShow(true)
    self._radioBtnSecondFloor:SetShow(true)
    self._radioBtnThirdFloor:SetShow(false)
    self._radioBtnFourFloor:SetShow(false)
    sizeY = 125
  elseif numFloor <= 3 then
    self._radioBtnFirstFloor:SetShow(true)
    self._radioBtnSecondFloor:SetShow(true)
    self._radioBtnThirdFloor:SetShow(true)
    self._radioBtnFourFloor:SetShow(false)
    sizeY = 160
  elseif numFloor <= 4 then
    self._radioBtnFirstFloor:SetShow(true)
    self._radioBtnSecondFloor:SetShow(true)
    self._radioBtnThirdFloor:SetShow(true)
    self._radioBtnFourFloor:SetShow(true)
    sizeY = 195
  end
  self._staticBackFloor:SetSize(self._staticBackFloor:GetSizeX(), sizeY)
  self._staticTextFloor:ComputePos()
  self._radioBtnFirstFloor:ComputePos()
  self._radioBtnSecondFloor:ComputePos()
  self._radioBtnThirdFloor:ComputePos()
  self._radioBtnFourFloor:ComputePos()
  local curFloor = housing_getHouseFloorSelfPlayerBeing()
  if 0 == curFloor then
    self._radioBtnFirstFloor:SetCheck(true)
    self._radioBtnSecondFloor:SetCheck(false)
    self._radioBtnThirdFloor:SetCheck(false)
    self._radioBtnFourFloor:SetCheck(false)
  elseif 1 == curFloor then
    self._radioBtnFirstFloor:SetCheck(false)
    self._radioBtnSecondFloor:SetCheck(true)
    self._radioBtnThirdFloor:SetCheck(false)
    self._radioBtnFourFloor:SetCheck(false)
  elseif 2 == curFloor then
    self._radioBtnFirstFloor:SetCheck(false)
    self._radioBtnSecondFloor:SetCheck(false)
    self._radioBtnThirdFloor:SetCheck(true)
    self._radioBtnFourFloor:SetCheck(false)
  elseif 3 == curFloor then
    self._radioBtnFirstFloor:SetCheck(false)
    self._radioBtnSecondFloor:SetCheck(false)
    self._radioBtnThirdFloor:SetCheck(false)
    self._radioBtnFourFloor:SetCheck(true)
  end
end
function HouseInstallation:Close()
  HouseInstallation_Hide()
end
function HouseInstallation_Hide()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  renderMode:reset()
  crossHair_SetShow(true)
  setShowLine(true)
  Panel_House_InstallationMode:SetShow(false)
  housing_changeHousingMode(false, false)
  ClearFocusEdit()
  FGlobal_House_InstallationModeCart_Close()
  InventoryWindow_Close()
  FGlobal_FarmGuide_Close()
  InitializeModeClose_PetMaidInit()
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
end
function _houseInstallation_UpdateScroll(isDown)
  local self = HouseInstallation
  local max = self.maxInterval
  local now = self.nowInterval
  if true == isDown then
    if now < max - 2 then
      now = now + 1
      self.scroll:ControlButtonDown()
      self:Update(now)
    else
      return
    end
  elseif now > 0 then
    now = now - 1
    self.scroll:ControlButtonUp()
    self:Update(now)
  else
    return
  end
  self.nowInterval = now
end
function _houseInstallation_SetPosition()
  local houseActorWrapper = housing_getHouseholdActor_CurrentPosition()
  local css = houseActorWrapper:getStaticStatusWrapper():get()
  local max = css:getInstallationMaxCount()
  local now = houseActorWrapper:get():getInstallationCount()
  if max > now then
    housing_selectInstallationItem(0, slot._invenSlotNo)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_NOMOREHARVEST"))
  end
end
function _houseInstallation_ShowToolTip(invenType, invenSlotNo, slot_Idx)
  local self = HouseInstallation
  local itemWrapper = getInventoryItemByType(invenType, invenSlotNo)
  local Uislot = self.slotUIPool[slot_Idx]
  Panel_Tooltip_Item_Show(itemWrapper, Uislot.slotItem.icon, false, false, nil)
end
function _houseInstallation_ShowInstalledItemToolTip(invenSlotNo, slot_Idx)
  local self = HouseInstallation
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(invenSlotNo)
  local installationActorWrapper = getInstallationActor(actorKeyRaw)
  if installationActorWrapper == nil then
    return
  end
  local cssWrapper = installationActorWrapper:getStaticStatusWrapper()
  local itemSSW = cssWrapper:getItemEnchantStatcStaticWrapper()
  local Uislot = self.slotUIPool[slot_Idx]
  Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false, nil)
end
function _houseInstallation_CashItemShowToolTip(productNoRaw, uiIdx)
  local self = HouseInstallation
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local itemSSW = cPSSW:getItemByIndex(0)
  local Uislot = self.slotUIPool[uiIdx]
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false)
end
function _houseInstallation_HideToolTip()
  Panel_Tooltip_Item_hideTooltip()
end
function _houseInstallation_InstallFurniture(invenType, invenSlotNo, iscash, productNo)
  PAHousing_FarmInfo_Close()
  FGlobal_HouseInstallationControl_CloseOuter()
  if Panel_Win_System:GetShow() then
    return
  end
  if false == iscash then
    housing_selectInstallationItem(invenType, invenSlotNo)
  else
    housing_selectInstallationItemForCashShop(productNo)
  end
end
function _houseInstallation_Delete_InstalledObjectDO()
  PAHousing_FarmInfo_Close()
  FGlobal_HouseInstallationControl_CloseOuter()
  local self = HouseInstallation
  housing_deleteObject_InstalledObjectList(self.deleteItemIdx)
end
function _houseInstallation_Default_Cancel_function()
  if housing_isInstallMode() then
    if housing_isTemporaryObject() then
      housing_moveObject()
    end
  else
    housing_moveObject()
  end
end
function _houseInstallation_IconTooltip(isShow, iconType)
  local self = HouseInstallation
  local control
  local name = ""
  local desc = ""
  if true == isShow then
    if buttonEum.All == iconType then
      control = self.radio_AttAll
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ALL_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ALL_DESC")
    elseif buttonEum.Floor == iconType then
      control = self.radio_AttFloor
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTFLOOR_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTFLOOR_DESC")
    elseif buttonEum.Wall == iconType then
      control = self.radio_AttWall
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTWALL_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTWALL_DESC")
    elseif buttonEum.Table == iconType then
      control = self.radio_AttTabel
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTTABLE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTTABLE_DESC")
    elseif buttonEum.AllHarvest == iconType then
      control = self.radio_AttAllHarvest
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTALLHARVEST_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTALLHARVEST_DESC")
    elseif buttonEum.Harvest == iconType then
      control = self.radio_AttHarvest
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTHARVEST_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTHARVEST_DESC")
    elseif buttonEum.Tool == iconType then
      control = self.radio_AttOthers
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTOTHERS_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTOTHERS_DESC")
    elseif buttonEum.Rotate_Right == iconType then
      control = self.btn_RotateRight
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATERIGHT_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATERIGHT_DESC")
    elseif buttonEum.Rotate_Left == iconType then
      control = self.btn_RotateLeft
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATELEFT_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATELEFT_DESC")
    elseif buttonEum.RotateAngle_45 == iconType then
      control = self.btn_RotateAngle
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATEANGLE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATEANGLE_DESC")
    elseif buttonEum.Reset == iconType then
      control = self.btn_ResetArrangement
      name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_RESET_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_RESET_DESC")
    end
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_HouseInstallation_ItemFilter(itemType)
  local self = HouseInstallation
  self.filter_ItemType = itemType
  self.filter_SearchKeyword = ""
  self.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  self:SetData()
  self:SetScroll()
  self:Update(self.nowInterval)
end
function HandleClicked_HouseInstallation_EditItemNameClear()
  local self = HouseInstallation
  self.edit_ItemName:SetEditText("", true)
  SetFocusEdit(self.edit_ItemName)
end
function HandleClicked_HouseInstallation_FindItemName()
  local self = HouseInstallation
  local inputKeyword = self.edit_ItemName:GetEditText()
  ClearFocusEdit()
  if nil ~= inputKeyword and "" ~= inputKeyword and PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") ~= inputKeyword then
    self.filter_SearchKeyword = self.edit_ItemName:GetEditText()
    self:SetData()
    self:SetScroll()
    self:Update(self.nowInterval)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_ACK_SEARCH"))
    return
  end
end
function HandleClicked_HouseInstallation_Rotate45()
  local isCheck = HouseInstallation.btn_RotateAngle:IsCheck()
  housing_setRestrictedRatateObject(isCheck)
end
function HandleClicked_HouseInstallation_RotateCamera(isLeft)
  if true == isLeft then
    local xDegree = -0.5
    local yDegree = 0
    housing_rotateCamera(xDegree, yDegree)
  else
    local xDegree = 0.5
    local yDegree = 0
    housing_rotateCamera(xDegree, yDegree)
  end
end
function HandleClicked_HouseInstallation_Reset()
  if Panel_Win_System:GetShow() then
    return
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    return
  end
  local installedCount = houseWrapper:getInstallationCount()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local freeNormalInventorySlot = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory):getFreeCount()
  local freeCashInventorySlot = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eCashInventory):getFreeCount()
  local installedItemCount = houseWrapper:getInstallationCount()
  local installedNoramlItemCount = 0
  local installedCashItemCount = 0
  for installed_Idx = 0, installedItemCount do
    local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(installed_Idx)
    local installationActorWrapper = getInstallationActor(actorKeyRaw)
    if nil ~= installationActorWrapper then
      local cssWrapper = installationActorWrapper:getStaticStatusWrapper()
      local itemSSW = cssWrapper:getItemEnchantStatcStaticWrapper()
      if itemSSW:get():isCash() then
        installedCashItemCount = installedCashItemCount + 1
      else
        installedNoramlItemCount = installedNoramlItemCount + 1
      end
    end
  end
  FGlobal_HouseInstallationControl_Close()
  local function installed_Delete_All()
    for idx = 0, installedItemCount - 1 do
      housing_deleteObject_InstalledObjectList(idx)
    end
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_1")
  local msgContent = ""
  if 0 == installedCount then
    msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_2")
    local messageboxData = {
      title = titleString,
      content = msgContent,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  elseif 0 == freeNormalInventorySlot or 0 == freeCashInventorySlot then
    msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_3")
    local messageboxData = {
      title = titleString,
      content = msgContent,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    return
  elseif freeNormalInventorySlot < installedNoramlItemCount or freeCashInventorySlot < installedCashItemCount then
    msgContent = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_4", "InstalledCount", installedCount, "FreeInventorySlot", freeNormalInventorySlot)
  else
    msgContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_5", "count", installedCount) .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_6")
  end
  local messageboxData = {
    title = titleString,
    content = msgContent,
    functionYes = installed_Delete_All,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClicked_HouseInstallation_Exit()
  FGlobal_AlertHouseLightingReset()
  FromClient_CancelInstallModeMessageBox()
end
function HandleClicked_HouseInstallation_Exit_DO()
  HouseInstallation:Close()
end
function HandleClicked_HouseInstallation_Exit_ByAttacked()
  if housing_isBuildMode() or housing_isInstallMode() then
    HouseInstallation:Close()
  end
end
function HandleClicked_HouseInstallation_Delete_InstalledObject(dataIdx, idx)
  if Panel_Win_System:GetShow() then
    return
  end
  if housing_isTemporaryObject() or Is_Show_HouseInstallationControl() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_DELETEOBJECT_ACK"))
    return
  end
  local self = HouseInstallation
  local itemName = furnitureData[dataIdx].name
  self.deleteItemIdx = idx
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local actorKeyRaw = houseWrapper:getInstallationActorKeyRaw(idx)
  local installationActorWrapper = getInstallationActor(actorKeyRaw)
  if installationActorWrapper == nil then
    return
  end
  local cssWrapper = installationActorWrapper:getStaticStatusWrapper()
  local itemSSW = cssWrapper:getItemEnchantStatcStaticWrapper()
  local objectStaticStatus = cssWrapper:getObjectStaticStatus()
  local installationType
  if nil ~= cssWrapper then
    installationType = objectStaticStatus:getInstallationType()
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageContent = ""
  if UI_CIT.eType_WallPaper == installationType or UI_CIT.eType_FloorMaterial == installationType or UI_CIT.eType_Havest == installationType then
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CONFIRM_ITEMDELETE", "itemName", itemName)
  else
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_MSGBOX_CONTENT", "itemName", itemName)
  end
  local messageBoxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = _houseInstallation_Delete_InstalledObjectDO,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClicked_HouseInstallation_ScrollBtn()
  local posPer = HouseInstallation.scroll:GetControlPos()
  local viewRow = 2
  local totalRow = math.ceil(HouseInstallation.dataCount / (HouseInstallation.maxSlotCount / 2))
  local targetRow = math.floor((totalRow - viewRow) * posPer)
  HouseInstallation.nowInterval = targetRow
  HouseInstallation:Update(HouseInstallation.nowInterval)
end
function HandleClicked_HouseInstallation_FirstFloor_MouseLUp()
  housing_selectHouseFloor(0)
  HouseInstallation._radioBtnFirstFloor:SetCheck(true)
  HouseInstallation._radioBtnSecondFloor:SetCheck(false)
  HouseInstallation._radioBtnThirdFloor:SetCheck(false)
  HouseInstallation._radioBtnFourFloor:SetCheck(false)
end
function HandleClicked_HouseInstallation_SecondFloor_MouseLUp()
  housing_selectHouseFloor(1)
  HouseInstallation._radioBtnFirstFloor:SetCheck(false)
  HouseInstallation._radioBtnSecondFloor:SetCheck(true)
  HouseInstallation._radioBtnThirdFloor:SetCheck(false)
  HouseInstallation._radioBtnFourFloor:SetCheck(false)
end
function HandleClicked_HouseInstallation_ThirdFloor_MouseLUp()
  housing_selectHouseFloor(2)
  HouseInstallation._radioBtnFirstFloor:SetCheck(false)
  HouseInstallation._radioBtnSecondFloor:SetCheck(false)
  HouseInstallation._radioBtnThirdFloor:SetCheck(true)
  HouseInstallation._radioBtnFourFloor:SetCheck(false)
end
function HandleClicked_HouseInstallation_FourFloor_MouseLUp()
  housing_selectHouseFloor(3)
  HouseInstallation._radioBtnFirstFloor:SetCheck(false)
  HouseInstallation._radioBtnSecondFloor:SetCheck(false)
  HouseInstallation._radioBtnThirdFloor:SetCheck(false)
  HouseInstallation._radioBtnFourFloor:SetCheck(true)
end
function FromClient_ShowInstallationMenu(installMode, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  local posX = housing_getInstallationMenuPosX()
  local posY = housing_getInstallationMenuPosY()
  if true == isShow then
    FGlobal_HouseInstallationControl_Open(installMode, posX, posY, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  else
    FGlobal_HouseInstallationControl_Close()
  end
  FGlobal_House_InstallationModeCart_Update()
end
function FromClient_CancelInstallObject()
  FGlobal_HouseInstallationControl_Close()
end
function FromClient_CancelInstallMode()
  FGlobal_HouseInstallationControl_Close()
end
function FromClient_UpdateInventory()
  HouseInstallation:SetData()
  HouseInstallation:SetScroll()
  HouseInstallation.scroll:SetControlTop()
  HouseInstallation:Update(HouseInstallation.nowInterval)
  FGlobal_House_InstallationModeCart_Update()
end
function FromClient_UpdateInstallationActor(isAdd)
  HouseInstallation:SetData()
  HouseInstallation:SetScroll()
  HouseInstallation:Update(HouseInstallation.nowInterval)
end
function FromClient_ShowHousingModeUI(isShow)
  HouseInstallation:Open(isShow)
end
function FromClient_CancelInstallModeMessageBox()
  audioPostEvent_SystemUi(1, 33)
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_MEMO")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = HandleClicked_HouseInstallation_Exit_DO,
    functionCancel = _houseInstallation_Default_Cancel_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  local isExist = MessageBox.doHaveMessageBoxData(messageboxData.title)
  if false == isExist then
    MessageBox.showMessageBox(messageboxData)
  end
end
function FGlobal_House_InstallationMode_Update()
  HouseInstallation:SetData()
  HouseInstallation:SetScroll()
  HouseInstallation:Update(HouseInstallation.nowInterval)
end
function FGlobal_House_InstallationMode_Open()
  HouseInstallation.filter_ItemType = -1
  HouseInstallation.filter_SearchKeyword = ""
  HouseInstallation.edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
    return
  end
  local isHouse = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  if isHouse then
    HouseInstallation._isMyHouse = getSelfPlayer():get():isMyHouseVisiting()
  else
    HouseInstallation._isMyHouse = false
  end
  HouseInstallation:Open()
end
function EventHousingPointUpdate()
  local self = HouseInstallation
  local iptBaseValue = toClient_GetVisitingBaseInteriorPoint()
  local iptOptionValue = toClient_GetVisitingSetOptionInteriorPoint()
  local iptBonusValue = toClient_GetVisitingBonusInteriorPoint()
  local iptTotalValue = toClient_GetVisitingTotalInteriorPoint()
  if 0 == PaGlobal_GetHouseNamePoint() then
    iptBaseValue = 0
    iptOptionValue = 0
    iptBonusValue = 0
    iptTotalValue = 0
  end
  if iptBaseValue < 0 then
    iptBaseValue = 0
  end
  self.InteriorPointBaseValueText:SetText(iptBaseValue)
  if iptOptionValue < 0 then
    iptOptionValue = 0
  end
  self.InteriorPointOptionValueText:SetText(iptOptionValue)
  if iptBonusValue < 0 then
    iptBonusValue = 0
  end
  self.InteriorPointBonusValueText:SetText(iptBonusValue)
  if iptTotalValue < 0 then
    iptTotalValue = 0
  end
  self.InteriorPointTotalValueText:SetText(iptTotalValue)
  if true == self._staticBackFloor:GetShow() then
    iptBGPosY = self._staticBackFloor:GetPosY() + self._staticBackFloor:GetSizeY() + 10
  else
    iptBGPosY = 100
  end
  self.InteriorPointBG:SetPosY(iptBGPosY)
  self.InteriorPointBaseText:SetPosY(iptBGPosY + 27)
  self.InteriorPointOptionText:SetPosY(iptBGPosY + 58)
  self.InteriorPointBonusText:SetPosY(iptBGPosY + 90)
  self.InteriorPointTotalText:SetPosY(iptBGPosY + 129)
  self.InteriorPointBaseValueText:SetPosY(iptBGPosY + 27)
  self.InteriorPointOptionValueText:SetPosY(iptBGPosY + 58)
  self.InteriorPointBonusValueText:SetPosY(iptBGPosY + 90)
  self.InteriorPointTotalValueText:SetPosY(iptBGPosY + 129)
  self.InteriorPointBG:SetShow(true)
  self.InteriorPointBaseText:SetShow(true)
  self.InteriorPointOptionText:SetShow(true)
  self.InteriorPointBonusText:SetShow(true)
  self.InteriorPointTotalText:SetShow(true)
  self.InteriorPointBaseValueText:SetShow(true)
  self.InteriorPointOptionValueText:SetShow(true)
  self.InteriorPointBonusValueText:SetShow(true)
  self.InteriorPointTotalValueText:SetShow(true)
end
function EventHousingPointUpdateClear()
  HouseInstallation.InteriorPointBaseValueText:SetShow(false)
  HouseInstallation.InteriorPointOptionValueText:SetShow(false)
  HouseInstallation.InteriorPointBonusValueText:SetShow(false)
  HouseInstallation.InteriorPointTotalValueText:SetShow(false)
  HouseInstallation.InteriorPointBG:SetShow(false)
  HouseInstallation.InteriorPointBaseText:SetShow(false)
  HouseInstallation.InteriorPointOptionText:SetShow(false)
  HouseInstallation.InteriorPointBonusText:SetShow(false)
  HouseInstallation.InteriorPointTotalText:SetShow(false)
end
function FGlobal_House_InstallationMode_Close()
  HouseInstallation:Close()
end
function House_InstallationMode_UpdatePerFrame(deltaTime)
  local self = HouseInstallation
  if false == self.isInstallMode or false == self.houseInstallationMode then
    return
  end
  if nil == housing_getCreatedCharacterStaticWrapper() then
    self._staticInteriorSensePoint:SetShow(false)
    return
  end
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  if nil ~= characterStaticWrapper then
    local interiorSensePoint = housing_getAdditionalInteriorSensePoint()
    if interiorSensePoint > 0 and false == Panel_House_InstallationMode_ObjectControl:GetShow() then
      self._staticInteriorSensePoint:SetShow(true)
      self._staticInteriorSensePoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERIORSENSEPOINT", "point", tostring(interiorSensePoint)))
      self._staticInteriorSensePoint:SetPosX(getMousePosX() - self._staticInteriorSensePoint:GetSizeX() / 2)
      self._staticInteriorSensePoint:SetPosY(getMousePosY() - (self._staticInteriorSensePoint:GetSizeY() + 15))
    else
      self._staticInteriorSensePoint:SetShow(false)
    end
  else
    self._staticInteriorSensePoint:SetShow(false)
  end
end
Panel_House_InstallationMode:RegisterUpdateFunc("House_InstallationMode_UpdatePerFrame")
function HouseInstallation:registEventHandler()
  self.bg_List:addInputEvent("Mouse_DownScroll", "_houseInstallation_UpdateScroll( true )")
  self.bg_List:addInputEvent("Mouse_UpScroll", "_houseInstallation_UpdateScroll( false )")
  self.radio_AttAll:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. -1 .. " )")
  self.radio_AttAll:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.All .. " )")
  self.radio_AttAll:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttFloor:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. 0 .. " )")
  self.radio_AttFloor:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Floor .. " )")
  self.radio_AttFloor:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttWall:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. 1 .. " )")
  self.radio_AttWall:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Wall .. " )")
  self.radio_AttWall:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttTabel:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. 2 .. " )")
  self.radio_AttTabel:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Table .. " )")
  self.radio_AttTabel:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttAllHarvest:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. -1 .. " )")
  self.radio_AttAllHarvest:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.AllHarvest .. " )")
  self.radio_AttAllHarvest:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttHarvest:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. 0 .. " )")
  self.radio_AttHarvest:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Harvest .. " )")
  self.radio_AttHarvest:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.radio_AttOthers:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ItemFilter( " .. 1 .. " )")
  self.radio_AttOthers:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Tool .. " )")
  self.radio_AttOthers:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.btn_RotateRight:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_RotateCamera( false )")
  self.btn_RotateRight:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Rotate_Right .. " )")
  self.btn_RotateRight:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.btn_RotateLeft:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_RotateCamera( true )")
  self.btn_RotateLeft:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Rotate_Left .. " )")
  self.btn_RotateLeft:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.btn_RotateAngle:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_Rotate45()")
  self.btn_RotateAngle:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.RotateAngle_45 .. " )")
  self.btn_RotateAngle:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self.btn_ResetArrangement:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_Reset()")
  self.btn_ResetArrangement:addInputEvent("Mouse_On", "_houseInstallation_IconTooltip( true, " .. buttonEum.Reset .. " )")
  self.btn_ResetArrangement:addInputEvent("Mouse_Out", "_houseInstallation_IconTooltip( false )")
  self._radioBtnFirstFloor:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_FirstFloor_MouseLUp()")
  self._radioBtnSecondFloor:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_SecondFloor_MouseLUp()")
  self._radioBtnThirdFloor:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ThirdFloor_MouseLUp()")
  self._radioBtnFourFloor:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_FourFloor_MouseLUp()")
  self.scrollCTRLBTN:addInputEvent("Mouse_LPress", "HandleClicked_HouseInstallation_ScrollBtn()")
  self.scroll:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_ScrollBtn()")
  self.edit_ItemName:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_EditItemNameClear()")
  self.edit_ItemName:RegistReturnKeyEvent("HandleClicked_HouseInstallation_FindItemName()")
  self.btn_Search:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_FindItemName()")
  self.btn_Exit:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_Exit()")
  self.btn_ExitInstallMode:addInputEvent("Mouse_LUp", "HandleClicked_HouseInstallation_Exit()")
end
function HouseInstallation:registMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu")
  registerEvent("EventHousingCancelInstallObjectMessageBox", "FromClient_CancelInstallObject")
  registerEvent("EventHousingCancelInstallModeMessageBox", "FromClient_CancelInstallMode")
  registerEvent("EventHousingUpdateInstallationInven", "FromClient_UpdateInventory")
  registerEvent("EventUpdateInstallationActor", "FromClient_UpdateInstallationActor")
  registerEvent("EventHousingCancelInstallModeMessageBox", "FromClient_CancelInstallModeMessageBox")
  registerEvent("EventHousingShowHousingModeUI", "FromClient_ShowHousingModeUI")
  registerEvent("EventHousingShowVisitHouse", "EventHousingPointUpdate")
end
HouseInstallation:Initialize()
HouseInstallation:registEventHandler()
HouseInstallation:registMessageHandler()
renderMode:setClosefunctor(renderMode, HouseInstallation_Hide)
