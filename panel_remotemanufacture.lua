Panel_RemoteManufacture:SetShow(false)
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode = Defines.UIMode
local _defaultSlotNo = 255
local remoteManufacture = {
  radioBtn = {
    [1] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action1"),
    [2] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action2"),
    [3] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action3"),
    [4] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action4"),
    [5] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action5"),
    [6] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action6"),
    [7] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action7"),
    [8] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_RepairItem"),
    [9] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action9"),
    [10] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action10"),
    [11] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action11"),
    [12] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action12"),
    [13] = UI.getChildControl(Panel_RemoteManufacture, "RadioButton_Action13")
  },
  control = {
    selectIcon = UI.getChildControl(Panel_RemoteManufacture, "Static_CurrentActionIcon"),
    selectName = UI.getChildControl(Panel_RemoteManufacture, "StaticText_ManufactureName"),
    selectDesc = UI.getChildControl(Panel_RemoteManufacture, "StaticText_ManufactureDesc"),
    manufactureDesc = UI.getChildControl(Panel_RemoteManufacture, "StaticText_Desc"),
    btnStart = UI.getChildControl(Panel_RemoteManufacture, "Button_Manufacture"),
    point = {
      [1] = UI.getChildControl(Panel_RemoteManufacture, "Static_Point_1"),
      [2] = UI.getChildControl(Panel_RemoteManufacture, "Static_Point_2"),
      [3] = UI.getChildControl(Panel_RemoteManufacture, "Static_Point_3"),
      [4] = UI.getChildControl(Panel_RemoteManufacture, "Static_Point_4"),
      [5] = UI.getChildControl(Panel_RemoteManufacture, "Static_Point_5")
    }
  },
  config = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = true
  },
  _matarialSlot = {},
  _materialSlotNoList = {
    [0] = _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo,
    _defaultSlotNo
  },
  _materialSlotNoListItemIn = {
    [0] = false,
    false,
    false,
    false,
    false
  },
  _actionIndex = -1,
  _usingItemSlotCount = 0,
  _slotPos = {
    [1] = {
      [0] = {149, 73}
    },
    [2] = {
      [0] = {62, 158},
      {236, 158}
    },
    [3] = {
      [0] = {149, 73},
      {78, 211},
      {222, 211}
    },
    [4] = {
      [0] = {149, 73},
      {149, 247},
      {62, 158},
      {236, 158}
    },
    [5] = {
      [0] = {149, 73},
      {67, 132},
      {95, 228},
      {204, 228},
      {232, 132}
    }
  },
  _actionName = {
    [1] = "MANUFACTURE_SHAKE",
    [2] = "MANUFACTURE_GRIND",
    [3] = "MANUFACTURE_FIREWOOD",
    [4] = "MANUFACTURE_DRY",
    [5] = "MANUFACTURE_THINNING",
    [6] = "MANUFACTURE_HEAT",
    [7] = "MANUFACTURE_RAINWATER",
    [8] = "REPAIR_ITEM",
    [9] = "MANUFACTURE_ALCHEMY",
    [10] = "MANUFACTURE_COOK",
    [11] = "MANUFACTURE_ROYALGIFT_COOK",
    [12] = "MANUFACTURE_ROYALGIFT_ALCHEMY",
    [13] = "MANUFACTURE_GUILD"
  },
  _slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = true
  }
}
local remoteManufactureDesc = {
  [1] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_SHAKE"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_SHAKE"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_SHAKE")
  },
  [2] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_GRIND"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_GRIND"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_GRIND")
  },
  [3] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_WOODSPLITTING"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_FIREWOOD"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_FIREWOOD")
  },
  [4] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_DRY"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_DRY"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_DRY")
  },
  [5] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_THINNING"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_THINNING"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_THINNING")
  },
  [6] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_HEATING"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_HEAT"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_HEAT")
  },
  [7] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_RAINWATER"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_RAINWATER"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_RAINWATER")
  },
  [8] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_REPAIR"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_REPAIR"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC2_REPAIR")
  },
  [9] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ALCHEMY"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_ALCHEMY"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_ALCHEMY")
  },
  [10] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_COOK"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC_COOK"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_COOK")
  },
  [11] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_COOK"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_COOK"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_ROYALGIFT_COOK")
  },
  [12] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMY_MANUFACTURE_ROYALGIFT_ALCHEMY"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "GAME_MANUFACTURE_DESC_ROYALGIFT_ALCHEMY"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_GAME_MANUFACTURE_DESC2_ROYALGIFT_ALCHEMY")
  },
  [13] = {
    actionName = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANURACTURE_NAME"),
    desc1 = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_DESC"),
    desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_GUILDMANUFACTURE_SUBDESC")
  }
}
function remoteManufacture:Init()
  self.control.selectDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.control.manufactureDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  for index = 0, #remoteManufacture._materialSlotNoList do
    local createdSlot = {}
    SlotItem.new(createdSlot, "ItemIconSlot" .. index, 0, Panel_RemoteManufacture, remoteManufacture._slotConfig)
    createdSlot:createChild()
    createdSlot.icon:addInputEvent("Mouse_RUp", "RemoteManufacture_RemoveMaterial(" .. index .. ")")
    createdSlot.icon:SetSize(70, 70)
    createdSlot.count:SetPosX(30)
    createdSlot.count:SetPosY(50)
    self._matarialSlot[index] = createdSlot
  end
end
function remoteManufacture:RadioBtn_Init()
  for v, control in pairs(self.radioBtn) do
    control:SetCheck(false)
  end
  self.radioBtn[8]:SetIgnore(true)
  self.radioBtn[13]:SetIgnore(true)
end
function remoteManufacture:Update()
end
function HandleClicked_ManufactureType(_type)
  if Panel_Win_System:GetShow() then
    return
  end
  audioPostEvent_SystemUi(13, 10)
  _AudioPostEvent_SystemUiForXBOX(13, 10)
  StopManufactureAction()
  local self = remoteManufacture
  self._actionIndex = _type
  if 1 == _type or 2 == _type or 6 == _type then
    self._usingItemSlotCount = 2
  elseif 3 == _type or 4 == _type or 5 == _type then
    self._usingItemSlotCount = 1
  elseif 9 == _type or 10 == _type then
    if ToClient_IsContentsGroupOpen("228") then
      self._usingItemSlotCount = 3
    else
      self._usingItemSlotCount = 2
    end
  elseif 11 == _type or 12 == _type then
    self._usingItemSlotCount = 3
  else
    return
  end
  self:UpdateSlotPos()
  self.control.selectName:SetText(remoteManufactureDesc[_type].actionName)
  self.control.selectDesc:SetText(remoteManufactureDesc[_type].desc1)
  self.control.manufactureDesc:SetText(remoteManufactureDesc[_type].desc2)
  self._actionIndex = _type
  FGlobal_RemoteWarehouse_Update()
end
function remoteManufacture:UpdateSlotPos()
  if self._usingItemSlotCount < 0 then
    return
  end
  for index = 1, 5 do
    if index <= self._usingItemSlotCount then
      self.control.point[index]:SetPosX(self._slotPos[self._usingItemSlotCount][index - 1][1])
      self.control.point[index]:SetPosY(self._slotPos[self._usingItemSlotCount][index - 1][2])
      self.control.point[index]:SetShow(true)
      self.control.point[index]:AddEffect("fUI_Light", true, 0, 0)
    else
      self.control.point[index]:SetShow(false)
    end
    self._materialSlotNoList[index - 1] = _defaultSlotNo
    self._matarialSlot[index - 1]:clearItem()
  end
end
function RemoteManufacture_Go()
  if Panel_Win_System:GetShow() then
    return
  end
  local self = remoteManufacture
  if self._actionIndex < 0 then
    Proc_ShowMessage_Ack("\234\176\128\234\179\181 \235\176\169\235\178\149\236\157\132 \236\132\160\237\131\157\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  if self.radioBtn[4]:IsCheck() then
    local terraintype = selfPlayerNaviMaterial()
    local onBoat = selfplayerIsCurrentlyOnShip()
    if (2 == terraintype or 4 == terraintype or 6 == terraintype or 8 == terraintype or getSelfPlayer():getCurrentRegionInfo():isOcean()) and not onBoat then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_DON\226\128\153T_WARTER_ACK"))
      return
    end
  end
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper and 13 == self._actionIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MANUFACTURE_INNTER_GUILDHOUSE_USE"))
    return
  end
  local inventory = getSelfPlayer():get():getInventory()
  local freeCount = inventory:getFreeCount()
  local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
  local size = warehouseWrapper:getSize()
  if freeCount < 2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_LEAST_ONE"))
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local playerWeightPercent = allWeight / maxWeight * 100
  local s64_moneyWeight = selfPlayer:getInventory():getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local moneyWeight = Int64toInt32(s64_moneyWeight) / 10000
  local equipmentWeight = Int64toInt32(s64_equipmentWeight) / 10000
  local allWeight = Int64toInt32(s64_allWeight) / 10000
  local maxWeight = Int64toInt32(s64_maxWeight) / 10000
  local invenWeight = allWeight - equipmentWeight - moneyWeight
  local totalWeight = allWeight / maxWeight * 100
  if totalWeight >= 100 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "ALCHEMY_MANUFACTURE_INVENTORY_WEIGHTOVER"))
    return
  end
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Hide()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_HideDialog()
  else
    PaGlobalFunc_DialogMain_All_Close()
  end
  local rv = Manufacture_Do(CppEnums.InstallationType.TypeCount, self._actionName[self._actionIndex], CppEnums.ItemWhereType.eWarehouse, _materialSlotNoList[0], _materialSlotNoList[1], _materialSlotNoList[2], _materialSlotNoList[3], _materialSlotNoList[4])
  audioPostEvent_SystemUi(13, 11)
  _AudioPostEvent_SystemUiForXBOX(13, 11)
end
function FGlobal_RemoteManufactureActionIndex()
  local self = remoteManufacture
  if 0 < self._actionIndex then
    return self._actionIndex, self._actionName[self._actionIndex]
  else
    return self._actionIndex
  end
end
function FGlobal_RemoteManufacture_SetItem(slotNo)
  local self = remoteManufacture
  for index = 0, #self._materialSlotNoList do
    if _defaultSlotNo == self._materialSlotNoList[index] then
      local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
      local itemWrapper = warehouseWrapper:getItem(slotNo)
      if nil ~= itemWrapper then
        self._matarialSlot[index]:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64())
        self._matarialSlot[index].icon:SetPosX(self.control.point[index + 1]:GetPosX() - 25)
        self._matarialSlot[index].icon:SetPosY(self.control.point[index + 1]:GetPosY() - 25)
        self._materialSlotNoList[index] = slotNo
        self.control.point[index + 1]:SetShow(false)
        break
      end
    end
  end
end
function RemoteManufacture_RemoveMaterial(index)
end
function remoteManufacture:ShowToggle()
  if Panel_RemoteManufacture:GetShow() then
    Panel_RemoteManufacture:SetShow(false)
    Panel_RemoteInventory:SetShow(true)
  else
    Panel_RemoteManufacture:SetShow(true)
    Panel_RemoteInventory:SetShow(false)
    self:Update()
    Panel_RemoteManufacture:SetPosX(getScreenSizeX() - Panel_RemoteManufacture:GetSizeX() - 10)
    Panel_RemoteManufacture:SetPosY(getScreenSizeY() / 2 - Panel_RemoteManufacture:GetSizeY() / 2 - 100)
  end
end
function FGlobal_Dialog_ManufactureOpen()
  remoteManufacture:RadioBtn_Init()
  remoteManufacture:ShowToggle()
end
function remoteManufacture:registerEvnet()
  for index = 1, #self.radioBtn do
    self.radioBtn[index]:addInputEvent("Mouse_LUp", "HandleClicked_ManufactureType(" .. index .. ")")
  end
  self.control.btnStart:addInputEvent("Mouse_LUp", "RemoteManufacture_Go()")
end
remoteManufacture:Init()
remoteManufacture:registerEvnet()
