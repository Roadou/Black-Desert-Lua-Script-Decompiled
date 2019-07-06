local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_CCC = CppEnums.CashProductCategory
local UI_CIT = CppEnums.InstallationType
local IM = CppEnums.EProcessorInputMode
local renderMode = RenderModeWrapper.new(99, {
  Defines.RenderMode.eRenderMode_HouseInstallation
}, false)
PaGlobal_HouseInstallation = {
  _ui = {
    _panelTitle = UI.getChildControl(Panel_House_InstallationMode, "Static_Title"),
    _installedObjectCount = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InstalledObject"),
    _menu_TopBg = UI.getChildControl(Panel_House_InstallationMode, "Static_Menu_TopBG"),
    _menu_CategoryBg = UI.getChildControl(Panel_House_InstallationMode, "Static_Menu_CategoryBG"),
    _menu_BottomBg = UI.getChildControl(Panel_House_InstallationMode, "Static_Menu_BottomBG"),
    _itemListBg = UI.getChildControl(Panel_House_InstallationMode, "Static_ItemListBG"),
    _interiorPointBg = UI.getChildControl(Panel_House_InstallationMode, "Static_InteriorPointBG"),
    _staticBackFloorBg = UI.getChildControl(Panel_House_InstallationMode, "Static_BackFloorBG"),
    _menu_Top = {},
    _menu_Category = {},
    _menu_Bottom = {},
    _itemList = {},
    _interiorPoint = {},
    _staticBackFloor = {},
    _staticInteriorSensePoint = UI.getChildControl(Panel_House_InstallationMode, "StaticText_InteriorSensePoint"),
    _btn_ExitInstallMode = UI.getChildControl(Panel_House_InstallationMode, "Button_ExitInstallMode"),
    _edit_ItemName = UI.getChildControl(Panel_House_InstallationMode, "Edit_ItemName"),
    _searchBtn = UI.getChildControl(Panel_House_InstallationMode, "Button_Search")
  },
  _template = {
    _normalIconBG = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_HaveFurnitureIconBG"),
    _cashIconBG = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_CashIconBG"),
    _installedIcon = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_IsInstalled"),
    _slot = UI.getChildControl(Panel_House_InstallationMode, "Template_Static_Slot")
  },
  _menu_Top_Enum = {
    AllHarvest = 0,
    Harvest = 1,
    Others = 2,
    All = 3,
    Goods = 4,
    Furniture = 5,
    BaseMaterial = 6,
    Tools = 7,
    Count = 8
  },
  _menu_Category_Enum = {
    All = 0,
    AllFurniture = 1,
    Dresser = 2,
    Wardrobe = 3,
    Table = 4,
    Chair = 5,
    Bookcase = 6,
    Bed = 7,
    AllGoods = 8,
    OntheTable = 9,
    Floor = 10,
    Wall = 11,
    Ceiling = 12,
    AllBaseMaterial = 13,
    WallPaper = 14,
    FloorMaterial = 15,
    AllTools = 16,
    Cooking = 17,
    Alchemy = 18,
    Count = 19
  },
  _menu_Bottom_Enum = {
    Rotate_Left = 0,
    Rotate_Right = 1,
    RotateAngle_45 = 2,
    Reset = 3,
    Count = 4
  },
  _static_BackFloor_Enum = {
    First = 0,
    Second = 1,
    Third = 2,
    Four = 3,
    Count = 4
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true,
    createCash = true
  },
  _categoryIndex = {},
  _maxSlotCount = 36,
  _slotUIPool = {},
  _maxInterval = 0,
  _nowInterval = 0,
  _dataCount = 0,
  _isModeShow = false,
  _isInstallMode = false,
  _houseInstallationMode = false,
  _deleteItemIdx = nil,
  _isMyHouse = false
}
function PaGlobal_HouseInstallation:initialize()
  local function do_Initialize()
    self._ui._menu_Top = {
      [self._menu_Top_Enum.AllHarvest] = UI.getChildControl(self._ui._menu_TopBg, "RadioButton_AttributeAllHarvest"),
      [self._menu_Top_Enum.Harvest] = UI.getChildControl(self._ui._menu_TopBg, "RadioButton_AttributeHarvest"),
      [self._menu_Top_Enum.Others] = UI.getChildControl(self._ui._menu_TopBg, "RadioButton_AttributeOthers"),
      [self._menu_Top_Enum.All] = UI.getChildControl(self._ui._menu_TopBg, "Button_All"),
      [self._menu_Top_Enum.Goods] = UI.getChildControl(self._ui._menu_TopBg, "Button_Goods"),
      [self._menu_Top_Enum.Furniture] = UI.getChildControl(self._ui._menu_TopBg, "Button_Furniture"),
      [self._menu_Top_Enum.BaseMaterial] = UI.getChildControl(self._ui._menu_TopBg, "Button_BaseMaterial"),
      [self._menu_Top_Enum.Tools] = UI.getChildControl(self._ui._menu_TopBg, "Button_Tools")
    }
    self._ui._menu_Category = {
      [self._menu_Category_Enum.All] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_All"),
      [self._menu_Category_Enum.AllFurniture] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_AllFurniture"),
      [self._menu_Category_Enum.Dresser] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Dresser"),
      [self._menu_Category_Enum.Wardrobe] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Wardrobe"),
      [self._menu_Category_Enum.Table] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Table"),
      [self._menu_Category_Enum.Chair] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Chair"),
      [self._menu_Category_Enum.Bookcase] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Bookcase"),
      [self._menu_Category_Enum.Bed] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Bed"),
      [self._menu_Category_Enum.AllGoods] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_AllGoods"),
      [self._menu_Category_Enum.OntheTable] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_OntheTable"),
      [self._menu_Category_Enum.Floor] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Floor"),
      [self._menu_Category_Enum.Wall] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Wall"),
      [self._menu_Category_Enum.Ceiling] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Ceiling"),
      [self._menu_Category_Enum.AllBaseMaterial] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_AllBaseMaterial"),
      [self._menu_Category_Enum.WallPaper] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_WallPaper"),
      [self._menu_Category_Enum.FloorMaterial] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_FloorMaterial"),
      [self._menu_Category_Enum.AllTools] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_AllTools"),
      [self._menu_Category_Enum.Cooking] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Cooking"),
      [self._menu_Category_Enum.Alchemy] = UI.getChildControl(self._ui._menu_CategoryBg, "Button_Category_Alchemy")
    }
    self._ui._menu_Bottom = {
      [self._menu_Bottom_Enum.Rotate_Left] = UI.getChildControl(self._ui._menu_BottomBg, "Button_CameraRotation_Left"),
      [self._menu_Bottom_Enum.Rotate_Right] = UI.getChildControl(self._ui._menu_BottomBg, "Button_CameraRotation_Right"),
      [self._menu_Bottom_Enum.RotateAngle_45] = UI.getChildControl(self._ui._menu_BottomBg, "CheckButton_ObjectRotateAngle45"),
      [self._menu_Bottom_Enum.Reset] = UI.getChildControl(self._ui._menu_BottomBg, "Button_ResetFurniture"),
      ["_btn_Exit"] = UI.getChildControl(self._ui._menu_BottomBg, "Button_Exit")
    }
    self._ui._itemList = {
      _scroll = UI.getChildControl(self._ui._itemListBg, "Scroll_List"),
      _scrollCTRLBTN = nil
    }
    self._ui._itemList._scrollCTRLBTN = UI.getChildControl(self._ui._itemList._scroll, "Scroll_CtrlButton")
    self._ui._interiorPoint = {
      _baseText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointBase"),
      _optionText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointOption"),
      _bonusText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointBonus"),
      _totalText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointTotal"),
      _baseValueText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointBaseValue"),
      _optionValueText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointOptionValue"),
      _bonusValueText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointBonusValue"),
      _totalValueText = UI.getChildControl(self._ui._interiorPointBg, "StaticText_InteriorPointTotalValue")
    }
    self._ui._staticBackFloor = {
      [self._static_BackFloor_Enum.First] = UI.getChildControl(self._ui._staticBackFloorBg, "RadioButton_FirstFloor"),
      [self._static_BackFloor_Enum.Second] = UI.getChildControl(self._ui._staticBackFloorBg, "RadioButton_SecondFloor"),
      [self._static_BackFloor_Enum.Third] = UI.getChildControl(self._ui._staticBackFloorBg, "RadioButton_ThirdFloor"),
      [self._static_BackFloor_Enum.Four] = UI.getChildControl(self._ui._staticBackFloorBg, "RadioButton_FourFloor"),
      ["_staticTextFloor"] = UI.getChildControl(self._ui._staticBackFloorBg, "StaticText_Floor")
    }
    PaGlobal_HouseInstallation._ui._itemListBg:setGlassBackground(true)
    self._categoryIndex = {
      [self._menu_Category_Enum.Dresser] = CppEnums.InstallationType.eType_Carpenter,
      [self._menu_Category_Enum.Wardrobe] = CppEnums.InstallationType.eType_Founding,
      [self._menu_Category_Enum.Table] = CppEnums.InstallationType.eType_Treasure,
      [self._menu_Category_Enum.Chair] = CppEnums.InstallationType.eType_Smithing,
      [self._menu_Category_Enum.Bookcase] = CppEnums.InstallationType.eType_Bookcase,
      [self._menu_Category_Enum.Bed] = CppEnums.InstallationType.eType_Bed,
      [self._menu_Category_Enum.Ceiling] = CppEnums.InstallationType.eType_Chandelier,
      [self._menu_Category_Enum.WallPaper] = CppEnums.InstallationType.eType_WallPaper,
      [self._menu_Category_Enum.FloorMaterial] = CppEnums.InstallationType.eType_FloorMaterial,
      [self._menu_Category_Enum.Cooking] = CppEnums.InstallationType.eType_Cooking,
      [self._menu_Category_Enum.Alchemy] = CppEnums.InstallationType.eType_Alchemy
    }
    PaGlobal_HouseInstallation._ui._menu_TopBg:setGlassBackground(true)
    PaGlobal_HouseInstallation._ui._menu_BottomBg:setGlassBackground(true)
    PaGlobal_HouseInstallation._ui._staticInteriorSensePoint:SetFontColor(4293914607)
    PaGlobal_HouseInstallation._ui._staticInteriorSensePoint:useGlowFont(true, "BaseFont_10_Glow", 4292411606)
    PaGlobal_HouseInstallation._ui._staticInteriorSensePoint:SetShow(false)
    Panel_House_InstallationMode:RegisterUpdateFunc("House_InstallationMode_UpdatePerFrame")
  end
  do_Initialize()
  local slotStartX = 12
  local slotStartY = 7
  local slotGapX = 55
  local slotGapY = 55
  local slotCols = 18
  local function do_MakeSlot()
    for slot_Idx = 0, self._maxSlotCount - 1 do
      local tempArray = {}
      local col = slot_Idx % slotCols
      local row = math.floor(slot_Idx / slotCols)
      local posX = slotStartX + slotGapX * col
      local posY = slotStartY + slotGapY * row
      local created_normalSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self._ui._itemListBg, "Panel_House_Installation_normalSlot_" .. slot_Idx)
      CopyBaseProperty(self._template._normalIconBG, created_normalSlot)
      created_normalSlot:SetShow(true)
      created_normalSlot:SetPosX(posX)
      created_normalSlot:SetPosY(posY)
      tempArray.normalBG = created_normalSlot
      local created_cashSlot = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, self._ui._itemListBg, "Panel_House_Installation_cashSlot_" .. slot_Idx)
      CopyBaseProperty(self._template._cashIconBG, created_cashSlot)
      created_cashSlot:SetShow(false)
      created_cashSlot:SetPosX(posX)
      created_cashSlot:SetPosY(posY)
      tempArray.cashBG = created_cashSlot
      local slot = {}
      SlotItem.new(slot, "Panel_House_Installation_SlotItem_" .. slot_Idx, slot_Idx, self._ui._itemListBg, self._slotConfig)
      slot:createChild()
      slot.icon:SetPosX(posX + 2)
      slot.icon:SetPosY(posY + 2)
      slot.icon:SetShow(false)
      tempArray.slotItem = slot
      local created_InstalledMark = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATICTEXT, self._ui._itemListBg, "Panel_House_Installation_InstalledMark_" .. slot_Idx)
      CopyBaseProperty(self._template._installedIcon, created_InstalledMark)
      created_InstalledMark:SetShow(false)
      created_InstalledMark:SetIgnore(true)
      created_InstalledMark:SetPosX(slot.icon:GetPosX() + slot.icon:GetSizeX() - created_InstalledMark:GetSizeX() + 5)
      created_InstalledMark:SetPosY(slot.icon:GetPosY() + slot.icon:GetSizeY() - created_InstalledMark:GetSizeY() + 5)
      tempArray.installedMark = created_InstalledMark
      self._slotUIPool[slot_Idx] = tempArray
    end
  end
  do_MakeSlot()
  self._ui._itemList._scroll:SetControlTop()
  self._ui._edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
end
function PaGlobal_HouseInstallation:setPosition()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeY = Panel_House_InstallationMode:GetSizeY()
  Panel_House_InstallationMode:SetSize(scrSizeX, scrSizeY)
  self._ui._itemListBg:ComputePos()
  self._ui._itemList._scroll:ComputePos()
  self._ui._interiorPointBg:ComputePos()
  self._ui._btn_ExitInstallMode:ComputePos()
  self._ui._staticBackFloorBg:SetPosX(self._ui._installedObjectCount:GetPosX() + 35)
  self._ui._staticBackFloorBg:SetPosY(self._ui._installedObjectCount:GetPosY() + self._ui._installedObjectCount:GetSizeY())
  self._ui._menu_TopBg:SetPosX(self._ui._itemListBg:GetPosX())
  self._ui._menu_TopBg:SetPosY(self._ui._itemListBg:GetPosY() - 80)
  self._ui._menu_CategoryBg:SetPosX(self._ui._itemListBg:GetPosX())
  self._ui._menu_CategoryBg:SetPosY(self._ui._itemListBg:GetPosY() - 40)
  self._ui._menu_BottomBg:SetPosX(self._ui._itemListBg:GetPosX() + self._ui._itemListBg:GetSizeX() + 10)
  self._ui._menu_BottomBg:SetVerticalBottom()
  self._ui._edit_ItemName:SetPosX(self._ui._itemListBg:GetPosX() + 800)
  self._ui._edit_ItemName:SetPosY(self._ui._itemListBg:GetPosY() - 35)
  self._ui._searchBtn:SetPosX(self._ui._itemListBg:GetPosX() + 950)
  self._ui._searchBtn:SetPosY(self._ui._itemListBg:GetPosY() - 35)
end
function PaGlobal_HouseInstallation:floorCheck(floor)
  for index = 0, self._static_BackFloor_Enum.Count - 1 do
    if floor == index then
      self._ui._staticBackFloor[index]:SetCheck(true)
    else
      self._ui._staticBackFloor[index]:SetCheck(false)
    end
  end
end
function PaGlobal_HouseInstallation:setData(initflag)
  ToClient_Furniture_Setdata(initflag)
  self._dataCount = ToClient_GetFurnitureListSize()
  FGlobal_House_InstallationModeCart_InteriorPointUpdate()
end
function PaGlobal_HouseInstallation:setScroll()
  local dataCount = self._dataCount
  local hideCount = dataCount - self._maxSlotCount
  local countByline = self._maxSlotCount / 2
  local totalLine = math.ceil(dataCount / countByline)
  local interval = totalLine
  if interval < 0 then
    interval = 0
  end
  self._maxInterval = totalLine - self._maxSlotCount / countByline
  self._nowInterval = 0
  local viewLine = self._maxSlotCount / countByline
  local pagePercent = viewLine / totalLine * 100
  local scrollSizeY = self._ui._itemList._scroll:GetSizeY()
  local btn_scrollSizeY = scrollSizeY / 100 * pagePercent * 0.85
  if btn_scrollSizeY < 20 then
    btn_scrollSizeY = 20
  end
  if btn_scrollSizeY > scrollSizeY - 5 then
    btn_scrollSizeY = scrollSizeY - 5
  end
  self._ui._itemList._scrollCTRLBTN:SetSize(self._ui._itemList._scrollCTRLBTN:GetSizeX(), btn_scrollSizeY)
  self._ui._itemList._scroll:SetInterval(self._maxInterval)
end
function PaGlobal_HouseInstallation:update(nowInterval)
  for slot_Idx = 0, self._maxSlotCount - 1 do
    local Uislot = self._slotUIPool[slot_Idx]
    Uislot.slotItem.icon:addInputEvent("Mouse_On", "")
    Uislot.slotItem.icon:addInputEvent("Mouse_Out", "")
    Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "")
    Uislot.slotItem:clearItem()
    Uislot.normalBG:SetShow(true)
    Uislot.cashBG:SetShow(false)
    Uislot.installedMark:SetShow(false)
  end
  self._ui._staticInteriorSensePoint:SetShow(false)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if true == self._houseInstallationMode then
  else
    if nil == houseWrapper then
      _PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()\234\176\128 nullptr \236\157\180\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.")
      return
    end
    local css = houseWrapper:getStaticStatusWrapper():get()
    self._ui._installedObjectCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_INSTALLOBJECTCOUNT", "sum", houseWrapper:getInstallationCountSum(), "maxCount", css:getInstallationMaxCount()))
  end
  if self._maxSlotCount < self._dataCount then
    self._ui._itemList._scroll:SetShow(true)
  else
    self._ui._itemList._scroll:SetShow(false)
  end
  for slot_Idx = 0, self._maxSlotCount - 1 do
    local dataIdx = nowInterval * (self._maxSlotCount / 2) + slot_Idx
    local Uislot = self._slotUIPool[slot_Idx]
    local Data = ToClient_GetFurniture(dataIdx)
    if nil == Data then
      return
    end
    if true == Data._isInstalled then
      Uislot.slotItem.icon:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:showInstalledItemToolTip( " .. Data._invenSlotNo .. ", " .. slot_Idx .. " )")
      Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:delete_InstalledObject( " .. Data._invenSlotNo .. " )")
      Uislot.normalBG:SetShow(true)
      Uislot.cashBG:SetShow(false)
      Uislot.installedMark:SetShow(true)
    elseif not Data._isCashProduct then
      Uislot.slotItem.icon:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:showToolTip( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", " .. slot_Idx .. " )")
      Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", false, " .. 0 .. ")")
      Uislot.normalBG:SetShow(true)
      Uislot.cashBG:SetShow(false)
      Uislot.installedMark:SetShow(false)
    else
      Uislot.slotItem.icon:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:cashItemShowToolTip( " .. Data._productNoRaw .. ", " .. slot_Idx .. " )")
      Uislot.slotItem.icon:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", true, " .. Data._productNoRaw .. ")")
      Uislot.normalBG:SetShow(false)
      Uislot.cashBG:SetShow(true)
      Uislot.installedMark:SetShow(false)
    end
    Uislot.slotItem:setItemByStaticStatus(Data:getItemStaticStatusWrapper(), 0)
    Uislot.slotItem.icon:SetAlpha(1)
    Uislot.slotItem.icon:SetShow(true)
    Uislot.slotItem.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    Uislot.slotItem.icon:addInputEvent("Mouse_DownScroll", "PaGlobal_HouseInstallation:updateScroll( true )")
    Uislot.slotItem.icon:addInputEvent("Mouse_UpScroll", "PaGlobal_HouseInstallation:updateScroll( false )")
    if self._dataCount == dataIdx + 1 then
      return
    end
  end
end
function PaGlobal_HouseInstallation:open()
  _PA_LOG("\236\167\128\235\175\188\237\152\129", "PaGlobal_HouseInstallation:Open()")
  ToClient_SaveUiInfo(false)
  if not IsSelfPlayerWaitAction() and not IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE"))
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  self:eventHousingPointUpdateClear()
  ToClient_Housing_List_ClearFilter()
  if housing_isBuildMode() then
    self._isInstallMode = false
  else
    local rv = housing_changeHousingMode(true, PaGlobal_HouseInstallation._isMyHouse)
    if 0 ~= rv then
      _PA_LOG("\236\167\128\235\175\188\237\152\129", "housing_changeHousingMode Failed...")
      return
    end
    self._isInstallMode = true
  end
  audioPostEvent_SystemUi(1, 32)
  SetUIMode(Defines.UIMode.eUIMode_Housing)
  renderMode:set()
  crossHair_SetShow(false)
  setShowLine(false)
  self:setPosition()
  if true == self._isInstallMode then
    self:open_ObjectInstallMode(isShow)
  else
    self:open_ItemInstallMode(isShow)
  end
  Panel_House_InstallationMode:SetShow(true)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_BUILDMODE")
end
function PaGlobal_HouseInstallation:open_ObjectInstallMode(isShow)
  if not IsSelfPlayerWaitAction() and not IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_ONLYWAITSTENCE"))
    return
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
    return
  end
  self._houseInstallationMode = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  self._ui._menu_TopBg:SetShow(true)
  self._ui._menu_BottomBg:SetShow(true)
  self._ui._itemListBg:SetShow(true)
  self._ui._btn_ExitInstallMode:SetShow(false)
  if true == self._houseInstallationMode then
    self._ui._menu_Top[self._menu_Top_Enum.AllHarvest]:SetCheck(false)
    self._ui._menu_Top[self._menu_Top_Enum.All]:SetCheck(true)
    self._ui._menu_CategoryBg:SetShow(true)
    self._ui._menu_TopBg:SetPosY(self._ui._itemListBg:GetPosY() - 80)
  else
    self._ui._menu_Top[self._menu_Top_Enum.AllHarvest]:SetCheck(true)
    self._ui._menu_Top[self._menu_Top_Enum.All]:SetCheck(false)
    self._ui._menu_CategoryBg:SetShow(false)
    self._ui._menu_TopBg:SetPosY(self._ui._itemListBg:GetPosY() - 40)
  end
  self._ui._menu_Top[self._menu_Top_Enum.Harvest]:SetCheck(false)
  self._ui._menu_Top[self._menu_Top_Enum.Others]:SetCheck(false)
  self._ui._menu_Top[self._menu_Top_Enum.Furniture]:SetCheck(false)
  self._ui._menu_Top[self._menu_Top_Enum.Goods]:SetCheck(false)
  self._ui._menu_Top[self._menu_Top_Enum.BaseMaterial]:SetCheck(false)
  self._ui._menu_Top[self._menu_Top_Enum.Tools]:SetCheck(false)
  PaGlobal_HouseInstallation:setData(true)
  PaGlobal_HouseInstallation:setScroll()
  PaGlobal_HouseInstallation:update(PaGlobal_HouseInstallation._nowInterval)
  if true == self._houseInstallationMode then
    if PaGlobal_HouseInstallation._isMyHouse then
      self._ui._panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1"))
    else
      self._ui._panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1") .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_HAPPYYOU"))
    end
    self._ui._installedObjectCount:SetShow(false)
    FGlobal_House_InstallationModeCart_Open()
    self:showFloorStatic(true)
    FromClient_EventHousingPointUpdate()
  else
    self._ui._panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE2"))
    self._ui._installedObjectCount:SetShow(true)
    self:showFloorStatic(false)
  end
  for index = 0, self._menu_Top_Enum.Count - 1 do
    if index == self._menu_Top_Enum.AllHarvest or index == self._menu_Top_Enum.Harvest or index == self._menu_Top_Enum.Others then
      self._ui._menu_Top[index]:SetShow(false == self._houseInstallationMode)
    else
      self._ui._menu_Top[index]:SetShow(true == self._houseInstallationMode)
    end
  end
  for index = 0, self._menu_Category_Enum.Count - 1 do
    self._ui._menu_Category[index]:SetShow(false)
  end
  self._ui._menu_Category[self._menu_Category_Enum.All]:SetCheck(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.All]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Table]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Table]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Bed]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Floor]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Wall]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:GetPosX() + 34)
  self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetShow(true == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetCheck(false == self._houseInstallationMode)
  self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Cooking]:GetPosX() + 34)
  self._ui._edit_ItemName:SetShow(true)
  self._ui._searchBtn:SetShow(true)
end
function PaGlobal_HouseInstallation:open_ItemInstallMode(isShow)
  self._ui._panelTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_SETUP"))
  self._ui._btn_ExitInstallMode:SetShow(true)
  self._ui._installedObjectCount:SetShow(false)
  self._ui._menu_TopBg:SetShow(false)
  self._ui._menu_CategoryBg:SetShow(false)
  self._ui._menu_BottomBg:SetShow(false)
  self._ui._itemListBg:SetShow(false)
  self._ui._edit_ItemName:SetShow(false)
  self._ui._searchBtn:SetShow(false)
  self:showFloorStatic(false)
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  if nil ~= characterStaticWrapper then
    local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
    local isCheck = objectStaticWrapper:isHouseInstallationMinorWarCheck()
    if isCheck then
      FGlobal_HouseInstallation_MinorWar_Open()
    else
      FGlobal_HouseInstallation_MinorWar_Close()
    end
  end
end
function PaGlobal_HouseInstallation:showFloorStatic(isShow)
  local numFloor = housing_getHouseFloorCount()
  if false == isShow or numFloor <= 1 then
    self._ui._staticBackFloorBg:SetShow(false)
    return
  end
  self._ui._staticBackFloorBg:SetShow(true)
  local sizeY = 0
  if numFloor == 2 then
    sizeY = 125
  elseif numFloor == 3 then
    sizeY = 160
  elseif numFloor == 4 then
    sizeY = 195
  end
  for index = 0, self._static_BackFloor_Enum.Count - 1 do
    if index < numFloor then
      self._ui._staticBackFloor[index]:SetShow(true)
    else
      self._ui._staticBackFloor[index]:SetShow(false)
    end
  end
  self._ui._staticBackFloorBg:SetSize(self._ui._staticBackFloorBg:GetSizeX(), sizeY)
  for _, _value in pairs(self._ui._staticBackFloor) do
    _value:ComputePos()
  end
  local curFloor = housing_getHouseFloorSelfPlayerBeing()
  self:floorCheck(curFloor)
end
function PaGlobal_HouseInstallation:close()
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
function PaGlobal_HouseInstallation:eventHousingPointUpdateClear()
  self._ui._interiorPointBg:SetShow(false)
  for _, _value in pairs(self._ui._interiorPoint) do
    _value:SetShow(false)
  end
end
function PaGlobal_HouseInstallation:houseInstall_Reset()
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
    local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(installed_Idx)
    if nil ~= itemSSW then
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
  local localtitle = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_1")
  local localcontent = ""
  local localfunctionYes, localfunctionApply, localfunctionCancle
  if 0 == installedCount then
    localcontent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_2")
    localfunctionApply = MessageBox_Empty_function
  elseif 0 == freeNormalInventorySlot or 0 == freeCashInventorySlot then
    localcontent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_3")
    localfunctionApply = MessageBox_Empty_function
  elseif freeNormalInventorySlot < installedNoramlItemCount or freeCashInventorySlot < installedCashItemCount then
    localcontent = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_4", "InstalledCount", installedCount, "FreeInventorySlot", freeNormalInventorySlot)
    localfunctionYes = installed_Delete_All
    localfunctionCancle = MessageBox_Empty_function
  else
    if true == self._houseInstallationMode then
      localcontent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_5", "count", installedCount) .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALLMODE_WITHDRAW_6")
    else
      localcontent = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_RESET_DESC")
    end
    localfunctionYes = installed_Delete_All
    localfunctionCancle = MessageBox_Empty_function
  end
  local messageboxData = {
    title = localtitle,
    content = localcontent,
    functionYes = localfunctionYes,
    functionApply = localfunctionApply,
    functionNo = localfunctionCancle,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
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
  PaGlobal_HouseInstallation:setData(true)
  PaGlobal_HouseInstallation:setScroll()
  PaGlobal_HouseInstallation._ui._itemList._scroll:SetControlTop()
  PaGlobal_HouseInstallation:update(PaGlobal_HouseInstallation._nowInterval)
  FGlobal_House_InstallationModeCart_Update()
end
function FromClient_UpdateInstallationActor(isAdd)
  PaGlobal_HouseInstallation:setData(true)
  PaGlobal_HouseInstallation:setScroll()
  PaGlobal_HouseInstallation:update(PaGlobal_HouseInstallation._nowInterval)
end
function FromClient_ShowHousingModeUI(isShow)
  PaGlobal_HouseInstallation:open(isShow)
end
function FromClient_CancelInstallModeMessageBox()
  audioPostEvent_SystemUi(1, 33)
  local messageBox_HouseInstallation_Exit_DO = function()
    PaGlobal_HouseInstallation:close()
  end
  local messageBox_HouseInstallaion_Default_Cancel_function = function()
    if housing_isInstallMode() then
      if housing_isTemporaryObject() then
        housing_moveObject()
      end
    else
      housing_moveObject()
    end
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_MEMO")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_MODE_EXIT_MESSAGEBOX_TITLE"),
    content = messageBoxMemo,
    functionYes = messageBox_HouseInstallation_Exit_DO,
    functionCancel = messageBox_HouseInstallaion_Default_Cancel_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  local isExist = MessageBox.doHaveMessageBoxData(messageboxData.title)
  if false == isExist then
    MessageBox.showMessageBox(messageboxData)
  end
end
function FromClient_EventHousingPointUpdate()
  PaGlobal_HouseInstallation._ui._interiorPoint._baseValueText:SetText(toClient_GetVisitingBaseInteriorPoint())
  PaGlobal_HouseInstallation._ui._interiorPoint._optionValueText:SetText(toClient_GetVisitingSetOptionInteriorPoint())
  PaGlobal_HouseInstallation._ui._interiorPoint._bonusValueText:SetText(toClient_GetVisitingBonusInteriorPoint())
  PaGlobal_HouseInstallation._ui._interiorPoint._totalValueText:SetText(toClient_GetVisitingTotalInteriorPoint())
  if true == PaGlobal_HouseInstallation._ui._staticBackFloorBg:GetShow() then
    iptBGPosY = PaGlobal_HouseInstallation._ui._staticBackFloorBg:GetPosY() + PaGlobal_HouseInstallation._ui._staticBackFloorBg:GetSizeY() + 10
  else
    iptBGPosY = 100
  end
  PaGlobal_HouseInstallation._ui._interiorPointBg:SetPosY(iptBGPosY)
  PaGlobal_HouseInstallation._ui._interiorPoint._baseValueText:SetPosY(PaGlobal_HouseInstallation._ui._interiorPoint._baseText:GetPosY())
  PaGlobal_HouseInstallation._ui._interiorPoint._optionValueText:SetPosY(PaGlobal_HouseInstallation._ui._interiorPoint._optionText:GetPosY())
  PaGlobal_HouseInstallation._ui._interiorPoint._bonusValueText:SetPosY(PaGlobal_HouseInstallation._ui._interiorPoint._bonusText:GetPosY())
  PaGlobal_HouseInstallation._ui._interiorPoint._totalValueText:SetPosY(PaGlobal_HouseInstallation._ui._interiorPoint._totalText:GetPosY())
  PaGlobal_HouseInstallation._ui._interiorPointBg:SetShow(true)
  for _, _value in pairs(PaGlobal_HouseInstallation._ui._interiorPoint) do
    _value:SetShow(true)
  end
end
function FGlobal_House_InstallationMode_Update()
  PaGlobal_HouseInstallation:setData(true)
  PaGlobal_HouseInstallation:setScroll()
  PaGlobal_HouseInstallation:update(PaGlobal_HouseInstallation.nowInterval)
end
function FGlobal_House_InstallationMode_Open()
  PaGlobal_HouseInstallation._ui._edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
    return
  end
  local isHouse = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  if isHouse then
    PaGlobal_HouseInstallation._isMyHouse = getSelfPlayer():get():isMyHouseVisiting()
  else
    PaGlobal_HouseInstallation._isMyHouse = false
  end
  PaGlobal_HouseInstallation:open()
end
function FGlobal_House_InstallationMode_Close()
  PaGlobal_HouseInstallation:close()
end
function House_InstallationMode_UpdatePerFrame(deltaTime)
  local self = PaGlobal_HouseInstallation
  if false == self._isInstallMode or false == self._houseInstallationMode then
    return
  end
  if 0 == PaGlobal_GetHouseNamePoint() then
    iptBaseValue = 0
    iptOptionValue = 0
    iptBonusValue = 0
    iptTotalValue = 0
  end
  if nil == housing_getCreatedCharacterStaticWrapper() then
    self._ui._staticInteriorSensePoint:SetShow(false)
    return
  end
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  self._ui._staticInteriorSensePoint:SetShow(false)
  if nil ~= characterStaticWrapper then
    local interiorSensePoint = housing_getAdditionalInteriorSensePoint()
    if interiorSensePoint > 0 and false == Panel_House_InstallationMode_ObjectControl:GetShow() then
      self._ui._staticInteriorSensePoint:SetShow(true)
      self._ui._staticInteriorSensePoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INTERIORSENSEPOINT", "point", tostring(interiorSensePoint)))
      self._ui._staticInteriorSensePoint:SetPosX(getMousePosX() - self._ui._staticInteriorSensePoint:GetSizeX() / 2)
      self._ui._staticInteriorSensePoint:SetPosY(getMousePosY() - (self._ui._staticInteriorSensePoint:GetSizeY() + 15))
    end
  end
end
function PaGlobal_HouseInstallation:updateScroll(isDown)
  local max = self._maxInterval
  local now = self._nowInterval
  if true == isDown then
    if max > now then
      now = now + 1
      self._ui._itemList._scroll:ControlButtonDown()
      self:update(now)
    else
      return
    end
  elseif now > 0 then
    now = now - 1
    self._ui._itemList._scroll:ControlButtonUp()
    self:update(now)
  else
    return
  end
  self._nowInterval = now
end
function PaGlobal_HouseInstallation:itemTopFilter(itemType)
  for index = 0, self._menu_Category_Enum.Count - 1 do
    self._ui._menu_Category[index]:SetShow(false)
  end
  ToClient_Housing_List_ClearFilter()
  if self._menu_Top_Enum.AllHarvest == itemType then
  elseif self._menu_Top_Enum.Harvest == itemType then
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Havest)
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_LivestockHarvest)
  elseif self._menu_Top_Enum.Others == itemType then
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Scarecrow)
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Waterway)
  elseif self._menu_Top_Enum.All == itemType then
    self._ui._menu_Category[self._menu_Category_Enum.All]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.All]:SetCheck(true)
    self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Table]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Table]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Bed]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Floor]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Wall]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Cooking]:GetPosX() + 34)
  elseif self._menu_Top_Enum.Furniture == itemType then
    self._ui._menu_Category[self._menu_Category_Enum.AllFurniture]:SetCheck(true)
    self._ui._menu_Category[self._menu_Category_Enum.AllFurniture]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Dresser]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Wardrobe]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Table]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Table]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Chair]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Bookcase]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Bed]:SetCheck(false)
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Dresser])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Wardrobe])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Table])
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Forging)
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Chair])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bookcase])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bed])
  elseif self._menu_Top_Enum.Goods == itemType then
    self._ui._menu_Category[self._menu_Category_Enum.AllGoods]:SetCheck(true)
    self._ui._menu_Category[self._menu_Category_Enum.AllGoods]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.AllGoods]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Floor]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.OntheTable]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Wall]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Floor]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Ceiling]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Wall]:GetPosX() + 34)
    ToClient_Housing_List_Filter_Table()
    ToClient_Housing_List_Filter_Floor()
    ToClient_Housing_List_Filter_Wall()
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Ceiling])
  elseif self._menu_Top_Enum.BaseMaterial == itemType then
    self._ui._menu_Category[self._menu_Category_Enum.AllBaseMaterial]:SetCheck(true)
    self._ui._menu_Category[self._menu_Category_Enum.AllBaseMaterial]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.AllBaseMaterial]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.FloorMaterial]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.WallPaper]:GetPosX() + 34)
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.WallPaper])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.FloorMaterial])
  elseif self._menu_Top_Enum.Tools == itemType then
    self._ui._menu_Category[self._menu_Category_Enum.AllTools]:SetCheck(true)
    self._ui._menu_Category[self._menu_Category_Enum.AllTools]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetShow(true)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetCheck(false)
    self._ui._menu_Category[self._menu_Category_Enum.Cooking]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.AllTools]:GetPosX() + 34)
    self._ui._menu_Category[self._menu_Category_Enum.Alchemy]:SetPosX(self._ui._menu_Category[self._menu_Category_Enum.Cooking]:GetPosX() + 34)
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Cooking])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Alchemy])
  end
  self._ui._edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  self:setData(false)
  self._ui._itemList._scrollCTRLBTN:SetPosY(0)
  self:setScroll()
  self:update(self._nowInterval)
end
function PaGlobal_HouseInstallation:itemCategoryFilter(itemType)
  ToClient_Housing_List_ClearFilter()
  if self._menu_Category_Enum.All == itemType then
    PaGlobal_HouseInstallation:itemTopFilter(self._menu_Top_Enum.All)
    return
  elseif self._menu_Category_Enum.AllFurniture == itemType then
    PaGlobal_HouseInstallation:itemTopFilter(self._menu_Top_Enum.Furniture)
    return
  elseif self._menu_Category_Enum.AllGoods == itemType then
    PaGlobal_HouseInstallation:itemTopFilter(self._menu_Top_Enum.Goods)
    return
  elseif self._menu_Category_Enum.AllBaseMaterial == itemType then
    PaGlobal_HouseInstallation:itemTopFilter(self._menu_Top_Enum.BaseMaterial)
    return
  elseif self._menu_Category_Enum.AllTools == itemType then
    PaGlobal_HouseInstallation:itemTopFilter(self._menu_Top_Enum.Tools)
    return
  elseif self._menu_Category_Enum.OntheTable == itemType then
    ToClient_Housing_List_Filter_Table()
  elseif self._menu_Category_Enum.Floor == itemType then
    ToClient_Housing_List_Filter_Floor()
  elseif self._menu_Category_Enum.Wall == itemType then
    ToClient_Housing_List_Filter_Wall()
  elseif itemType < self._menu_Category_Enum.Count then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[itemType])
    if itemType == self._menu_Category_Enum.Table then
      ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Forging)
    end
  else
    _PA_LOG("\235\172\180\236\160\149", "\236\151\172\234\184\176 \235\147\164\236\150\180\236\152\164\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.")
  end
  self._ui._edit_ItemName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME"), false)
  self:setData(false)
  self._ui._itemList._scrollCTRLBTN:SetPosY(0)
  self:setScroll()
  self:update(self._nowInterval)
end
function PaGlobal_HouseInstallation:controllBottomMenu(valuetype)
  if PaGlobal_HouseInstallation._menu_Bottom_Enum.Rotate_Left == valuetype then
    local xDegree = 0.5
    local yDegree = 0
    housing_rotateCamera(xDegree, yDegree)
  elseif PaGlobal_HouseInstallation._menu_Bottom_Enum.Rotate_Right == valuetype then
    local xDegree = -0.5
    local yDegree = 0
    housing_rotateCamera(xDegree, yDegree)
  elseif PaGlobal_HouseInstallation._menu_Bottom_Enum.RotateAngle_45 == valuetype then
    local isCheck = PaGlobal_HouseInstallation._ui._menu_Bottom[PaGlobal_HouseInstallation._menu_Bottom_Enum.RotateAngle_45]:IsCheck()
    housing_setRestrictedRatateObject(isCheck)
  elseif PaGlobal_HouseInstallation._menu_Bottom_Enum.Reset == valuetype then
    PaGlobal_HouseInstallation:houseInstall_Reset()
  end
end
function PaGlobal_HouseInstallation:menuTopIconTooltip(iconType)
  local control
  local name = ""
  local desc = ""
  if self._menu_Top_Enum.AllHarvest == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTALLHARVEST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTALLHARVEST_DESC")
  elseif self._menu_Top_Enum.Harvest == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTHARVEST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTHARVEST_DESC")
  elseif self._menu_Top_Enum.Others == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTOTHERS_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ATTOTHERS_DESC")
  end
  if "" ~= name then
    control = self._ui._menu_Top[iconType]
    TooltipSimple_Show(control, name, desc)
  end
end
function PaGlobal_HouseInstallation:menuCategoryIconTooltip(iconType)
  local control
  local name = ""
  local desc = ""
  if self._menu_Category_Enum.All == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_ALL")
  elseif self._menu_Category_Enum.Dresser == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_DRESSER")
  elseif self._menu_Category_Enum.Wardrobe == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WARDRODE")
  elseif self._menu_Category_Enum.Table == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_TABLE")
  elseif self._menu_Category_Enum.Chair == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_CHAIR")
  elseif self._menu_Category_Enum.Bookcase == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_BOOKCASE")
  elseif self._menu_Category_Enum.Bed == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_BED")
  elseif self._menu_Category_Enum.OntheTable == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_ONTHETABLE")
  elseif self._menu_Category_Enum.Floor == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_FLOOR")
  elseif self._menu_Category_Enum.Wall == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WALL")
  elseif self._menu_Category_Enum.Ceiling == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_CEILING")
  elseif self._menu_Category_Enum.WallPaper == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WALLPAPER")
  elseif self._menu_Category_Enum.FloorMaterial == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_FLOORMATERIAL")
  elseif self._menu_Category_Enum.Cooking == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_COOKING")
  elseif self._menu_Category_Enum.Alchemy == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_ALCHEMY")
  end
  if "" ~= name then
    control = self._ui._menu_Category[iconType]
    TooltipSimple_Show(control, name, desc)
  end
end
function PaGlobal_HouseInstallation:menuBottomIconTooltip(iconType)
  local control
  local name = ""
  local desc = ""
  if self._menu_Bottom_Enum.Rotate_Right == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATERIGHT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATERIGHT_DESC")
  elseif self._menu_Bottom_Enum.Rotate_Left == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATELEFT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATELEFT_DESC")
  elseif self._menu_Bottom_Enum.RotateAngle_45 == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATEANGLE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_ROTATEANGLE_DESC")
  elseif self._menu_Bottom_Enum.Reset == iconType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_RESET_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_RESET_DESC")
  end
  if "" ~= name then
    control = self._ui._menu_Bottom[iconType]
    TooltipSimple_Show(control, name, desc)
  end
end
function PaGlobal_HouseInstallation:floor_MouseLUp(floor)
  housing_selectHouseFloor(floor)
  PaGlobal_HouseInstallation:floorCheck(floor)
end
function PaGlobal_HouseInstallation:scrollBtn()
  local posPer = self._ui._itemList._scroll:GetControlPos()
  local viewRow = 2
  local totalRow = math.ceil(self._dataCount / (self._maxSlotCount / 2))
  local targetRow = math.floor((totalRow - viewRow) * posPer)
  self._nowInterval = targetRow
  self:update(self._nowInterval)
end
function PaGlobal_HouseInstallation:editItemNameClear()
  self._ui._edit_ItemName:SetEditText("", true)
  SetFocusEdit(self._ui._edit_ItemName)
end
function PaGlobal_HouseInstallation:findItemName()
  local inputKeyword = self._ui._edit_ItemName:GetEditText()
  ClearFocusEdit()
  ToClient_Housing_List_ClearFilter()
  ToClient_Housing_List_Filter_Search(inputKeyword)
  if nil ~= inputKeyword and "" ~= inputKeyword and PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_EDIT_ITEMNAME") ~= inputKeyword then
    self:setData(false)
    self:setScroll()
    self:update(self._nowInterval)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_ACK_SEARCH"))
    return
  end
end
function PaGlobal_HouseInstallation:exit()
  FGlobal_AlertHouseLightingReset()
  FromClient_CancelInstallModeMessageBox()
end
function PaGlobal_HouseInstallation:delete_InstalledObject(idx)
  if Panel_Win_System:GetShow() then
    return
  end
  if housing_isTemporaryObject() or Is_Show_HouseInstallationControl() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_DELETEOBJECT_ACK"))
    return
  end
  local itemName = ""
  self._deleteItemIdx = idx
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_GOTO_NEAR_HOUSEHOLD"))
    return
  end
  local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(idx)
  local installationType
  if nil ~= itemSSW then
    installationType = itemSSW:getCharacterStaticStatus():getObjectStaticStatus():getInstallationType()
    itemName = itemSSW:getName()
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageContent = ""
  if UI_CIT.eType_WallPaper == installationType or UI_CIT.eType_FloorMaterial == installationType or UI_CIT.eType_Havest == installationType then
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CONFIRM_ITEMDELETE", "itemName", itemName)
  else
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_MSGBOX_CONTENT", "itemName", itemName)
  end
  local messageBox_HouseInstallation_Delete_InstalledObjectDo = function()
    PAHousing_FarmInfo_Close()
    FGlobal_HouseInstallationControl_CloseOuter()
    housing_deleteObject_InstalledObjectList(PaGlobal_HouseInstallation._deleteItemIdx)
  end
  local messageBoxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = messageBox_HouseInstallation_Delete_InstalledObjectDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_HouseInstallation:cashItemShowToolTip(productNoRaw, uiIdx)
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local itemSSW = cPSSW:getItemByIndex(0)
  local Uislot = PaGlobal_HouseInstallation._slotUIPool[uiIdx]
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false)
end
function PaGlobal_HouseInstallation:showInstalledItemToolTip(invenSlotNo, slot_Idx)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    return
  end
  local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(invenSlotNo)
  if nil == itemSSW then
    return
  end
  local Uislot = PaGlobal_HouseInstallation._slotUIPool[slot_Idx]
  Panel_Tooltip_Item_Show(itemSSW, Uislot.slotItem.icon, true, false, nil)
end
function PaGlobal_HouseInstallation:showToolTip(invenType, invenSlotNo, slot_Idx)
  local itemWrapper = getInventoryItemByType(invenType, invenSlotNo)
  local Uislot = PaGlobal_HouseInstallation._slotUIPool[slot_Idx]
  Panel_Tooltip_Item_Show(itemWrapper, Uislot.slotItem.icon, false, false, nil)
end
function PaGlobal_HouseInstallation:installFurniture(invenType, invenSlotNo, iscash, productNo)
  PAHousing_FarmInfo_Close()
  FGlobal_HouseInstallationControl_CloseOuter()
  if Panel_Win_System:GetShow() then
    return
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_INSTALL_NEAR_HOUSEHOLD"))
    return
  end
  if false == iscash then
    housing_selectInstallationItem(invenType, invenSlotNo)
  else
    housing_selectInstallationItemForCashShop(productNo)
  end
end
function HandleClicked_HouseInstallation_Exit_ByAttacked()
  if housing_isBuildMode() or housing_isInstallMode() then
    PaGlobal_HouseInstallation:close()
  end
end
function HouseInstallation_Hide()
  PaGlobal_HouseInstallation:close()
end
function PaGlobal_HouseInstallation:registEventHandler()
  self._ui._itemListBg:addInputEvent("Mouse_DownScroll", "PaGlobal_HouseInstallation:updateScroll( true )")
  self._ui._itemListBg:addInputEvent("Mouse_UpScroll", "PaGlobal_HouseInstallation:updateScroll( false )")
  for index = 0, self._menu_Top_Enum.Count - 1 do
    self._ui._menu_Top[index]:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:itemTopFilter( " .. index .. " )")
    self._ui._menu_Top[index]:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:menuTopIconTooltip( " .. index .. " )")
    self._ui._menu_Top[index]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
  for index = 0, self._menu_Category_Enum.Count - 1 do
    self._ui._menu_Category[index]:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:itemCategoryFilter( " .. index .. " )")
    self._ui._menu_Category[index]:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:menuCategoryIconTooltip( " .. index .. " )")
    self._ui._menu_Category[index]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
  for index = 0, self._menu_Bottom_Enum.Count - 1 do
    self._ui._menu_Bottom[index]:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:controllBottomMenu( " .. index .. " )")
    self._ui._menu_Bottom[index]:addInputEvent("Mouse_On", "PaGlobal_HouseInstallation:menuBottomIconTooltip( " .. index .. " )")
    self._ui._menu_Bottom[index]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
  for index = 0, self._static_BackFloor_Enum.Count - 1 do
    self._ui._staticBackFloor[index]:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:floor_MouseLUp(" .. index .. ")")
  end
  self._ui._itemList._scrollCTRLBTN:addInputEvent("Mouse_LPress", "PaGlobal_HouseInstallation:scrollBtn()")
  self._ui._itemList._scroll:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:scrollBtn()")
  self._ui._edit_ItemName:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:editItemNameClear()")
  self._ui._edit_ItemName:RegistReturnKeyEvent("PaGlobal_HouseInstallation:findItemName()")
  self._ui._searchBtn:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:findItemName()")
  self._ui._menu_Bottom._btn_Exit:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:exit()")
  self._ui._btn_ExitInstallMode:addInputEvent("Mouse_LUp", "PaGlobal_HouseInstallation:exit()")
end
function PaGlobal_HouseInstallation:registMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu")
  registerEvent("EventHousingCancelInstallObjectMessageBox", "FromClient_CancelInstallObject")
  registerEvent("EventHousingCancelInstallModeMessageBox", "FromClient_CancelInstallMode")
  registerEvent("EventHousingUpdateInstallationInven", "FromClient_UpdateInventory")
  registerEvent("EventUpdateInstallationActor", "FromClient_UpdateInstallationActor")
  registerEvent("EventHousingCancelInstallModeMessageBox", "FromClient_CancelInstallModeMessageBox")
  registerEvent("EventHousingShowHousingModeUI", "FromClient_ShowHousingModeUI")
  registerEvent("EventHousingShowVisitHouse", "FromClient_EventHousingPointUpdate")
end
PaGlobal_HouseInstallation:initialize()
PaGlobal_HouseInstallation:registEventHandler()
PaGlobal_HouseInstallation:registMessageHandler()
renderMode:setClosefunctor(renderMode, HouseInstallation_Hide)
