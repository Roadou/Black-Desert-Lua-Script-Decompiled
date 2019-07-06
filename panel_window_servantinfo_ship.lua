Panel_ShipInfo:SetShow(false, false)
Panel_ShipInfo:ActiveMouseEventEffect(true)
Panel_ShipInfo:SetDragEnable(true)
Panel_ShipInfo:setGlassBackground(true)
Panel_ShipInfo:RegisterShowEventFunc(true, "ShipInfoShowAni()")
Panel_ShipInfo:RegisterShowEventFunc(false, "ShipInfoHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local UI_VT = CppEnums.VehicleType
function ShipInfoShowAni()
  UIAni.fadeInSCR_Right(Panel_ShipInfo)
  audioPostEvent_SystemUi(1, 0)
end
function ShipInfoHideAni()
  Panel_ShipInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_ShipInfo:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  audioPostEvent_SystemUi(1, 1)
end
local shipInfo = {
  _config = {
    _itemSlot = {
      createIcon = false,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    },
    _slotNo = {
      3,
      4,
      5,
      6,
      25,
      14,
      15,
      16,
      26
    },
    _totemSlotNo = 6,
    _slotID = {
      [3] = "equipIcon_hull",
      [4] = "equipIcon_gear",
      [5] = "equipIcon_wheel",
      [6] = "equipIcon_totem",
      [25] = "equipIcon_body",
      [14] = "equipIcon_AvatarSaddle",
      [15] = "equipIcon_AvatarHull",
      [16] = "equipIcon_AvatarWheel",
      [26] = "equipIcon_AvatarBody"
    },
    _checkFlag = {
      [3] = 1,
      [4] = 2,
      [5] = 4,
      [6] = 8,
      [14] = 16,
      [15] = 32,
      [16] = 64,
      [25] = 128,
      [26] = 256
    },
    _slotEmptyBG = {
      [3] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Hull"),
      [4] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Gear"),
      [5] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Wheel"),
      [6] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Totem"),
      [25] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_Body"),
      [14] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarSaddle"),
      [15] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarHull"),
      [16] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarWheel"),
      [26] = UI.getChildControl(Panel_ShipInfo, "equipIconEmpty_AvatarBody")
    },
    _slotText = {
      [3] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_25"),
      [4] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_4"),
      [5] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_5"),
      [6] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_6"),
      [25] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_3"),
      [14] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_13"),
      [15] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_15"),
      [16] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_16"),
      [26] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Ship_Armor_14")
    },
    _skill = {
      startX = 0,
      startY = 0,
      startIconX = 10,
      startIconY = 5,
      startNameX = 64,
      startNameY = 5,
      startDecX = 64,
      startDecY = 27,
      startExpBGX = 7,
      startExpBGY = 47,
      startExpX = 12,
      startExpY = 50,
      gapY = 51,
      count = 4
    }
  },
  _buttonClose = UI.getChildControl(Panel_ShipInfo, "close_button"),
  _buttonQuestion = UI.getChildControl(Panel_ShipInfo, "Button_Question"),
  _staticName = UI.getChildControl(Panel_ShipInfo, "name_value"),
  _staticLevel = UI.getChildControl(Panel_ShipInfo, "Level_value"),
  _staticGaugeBar_Hp = UI.getChildControl(Panel_ShipInfo, "HP_GaugeBar"),
  _staticTextValue_Hp = UI.getChildControl(Panel_ShipInfo, "StaticText_HP_Value"),
  _mp = UI.getChildControl(Panel_ShipInfo, "MP"),
  _staticGaugeBar_Mp = UI.getChildControl(Panel_ShipInfo, "MP_GaugeBar"),
  _staticTextValue_Mp = UI.getChildControl(Panel_ShipInfo, "StaticText_MP_Value"),
  _staticTextValue_Sus = UI.getChildControl(Panel_ShipInfo, "StaticText_Sus_Value"),
  _staticGaugeBar_Weight = UI.getChildControl(Panel_ShipInfo, "Weight_Gauge"),
  _staticTextValue_Weight = UI.getChildControl(Panel_ShipInfo, "StaticText_Weight_Value"),
  _staticText_MaxMoveSpeedValue = UI.getChildControl(Panel_ShipInfo, "StaticText_MaxMoveSpeedValue"),
  _staticText_AccelerationValue = UI.getChildControl(Panel_ShipInfo, "StaticText_AccelerationValue"),
  _staticText_CorneringSpeedValue = UI.getChildControl(Panel_ShipInfo, "StaticText_CorneringSpeedValue"),
  _staticText_BrakeSpeedValue = UI.getChildControl(Panel_ShipInfo, "StaticText_BrakeSpeedValue"),
  _staticText_Value_Def = UI.getChildControl(Panel_ShipInfo, "StaticText_DefenceValue"),
  _staticSkillBG = UI.getChildControl(Panel_ShipInfo, "panel_skillInfo"),
  _skillScroll = UI.getChildControl(Panel_ShipInfo, "skill_scroll"),
  _deadCountValue = UI.getChildControl(Panel_ShipInfo, "StaticText_DeadCountValue"),
  _checkBtn_TotemShow = UI.getChildControl(Panel_ShipInfo, "CheckButton_EquipSlot_Totem"),
  _skillStart = 0,
  _skillCount = 0,
  _actorKeyRaw = nil,
  _armorName = Array.new(),
  _itemSlots = Array.new(),
  _skillSlots = Array.new()
}
local _extendedSlotNoId = {}
local function extendedSlotCheck(itemWrapper)
  local itemSSW = itemWrapper:getStaticStatus()
  local slotNoMax = itemSSW:getExtendedSlotCount()
  for i = 1, slotNoMax do
    local extendSlotNo = itemSSW:getExtendedSlotIndex(i - 1)
    if slotNoMax ~= extendSlotNo then
      table.insert(_extendedSlotNoId, extendSlotNo)
      shipInfo._itemSlots[extendSlotNo]:setItem(itemWrapper)
      shipInfo._itemSlots[extendSlotNo].icon:SetMonoTone(true)
    end
  end
end
function shipInfo:init()
  for index, value in pairs(self._config._slotNo) do
    local slot = {}
    slot.icon = UI.getChildControl(Panel_ShipInfo, self._config._slotID[value])
    SlotItem.new(slot, "ShipInfoEquipment_" .. value, value, Panel_ShipInfo, self._config._itemSlot)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "ShipInfo_RClick(" .. value .. ")")
    slot.icon:addInputEvent("Mouse_LUp", "ShipInfo_LClick(" .. value .. ")")
    slot.icon:addInputEvent("Mouse_On", "ShipInfo_EquipItem_MouseOn(" .. value .. ", true)")
    slot.icon:addInputEvent("Mouse_Out", "ShipInfo_EquipItem_MouseOn(" .. value .. ", false)")
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantShipEquipment")
    self._itemSlots[value] = slot
  end
  self._staticTextValue_Hp:SetPosY(self._staticGaugeBar_Hp:GetPosY() + (self._staticGaugeBar_Hp:GetSizeY() - self._staticTextValue_Hp:GetTextSizeY()) * 0.5)
  self._staticTextValue_Mp:SetPosY(self._staticGaugeBar_Mp:GetPosY() + (self._staticGaugeBar_Mp:GetSizeY() - self._staticTextValue_Mp:GetTextSizeY()) * 0.5)
  self._staticTextValue_Weight:SetPosY(self._staticGaugeBar_Weight:GetPosY() + (self._staticGaugeBar_Weight:GetSizeY() - self._staticTextValue_Weight:GetTextSizeY()) * 0.5)
end
function shipInfo:updateHp()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  self._staticGaugeBar_Hp:SetSize(1.63 * (servantWrapper:getHp() / servantWrapper:getMaxHp() * 100), 6)
  self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
end
function shipInfo:updateMp()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  self._staticGaugeBar_Mp:SetSize(1.63 * (servantWrapper:getMp() / servantWrapper:getMaxMp() * 100), 6)
  self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))
end
function shipInfo:update()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local servantWrapper = temporaryWrapper:getUnsealVehicleByActorKeyRaw(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local vehicleInfo = getVehicleActor(self._actorKeyRaw)
  if nil == vehicleInfo then
    return
  end
  self._staticName:SetText(servantWrapper:getName())
  self._staticLevel:SetText(tostring(servantWrapper:getLevel()))
  self._staticGaugeBar_Hp:SetSize(1.63 * (servantWrapper:getHp() / servantWrapper:getMaxHp() * 100), 6)
  self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
  self._staticGaugeBar_Mp:SetSize(1.63 * (servantWrapper:getMp() / servantWrapper:getMaxMp() * 100), 6)
  self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))
  self._staticTextValue_Sus:SetText(servantWrapper:getSuspension())
  local max_weight = Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()) / Defines.s64_const.s64_10000)
  local weightPercent = total_weight / max_weight * 100
  local weightValue = ""
  if max_weight < total_weight then
    weightPercent = 100
    weightValue = "<PAColor0xFFD20000>" .. makeDotMoney(total_weight) .. "<PAOldColor> / " .. makeDotMoney(max_weight)
  else
    weightValue = makeDotMoney(total_weight) .. " / " .. makeDotMoney(max_weight)
  end
  self._staticGaugeBar_Weight:SetSize(weightPercent * 163 / 100, 6)
  self._staticTextValue_Weight:SetText(weightValue)
  self._staticText_MaxMoveSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._staticText_AccelerationValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._staticText_CorneringSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._staticText_BrakeSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  self._staticText_Value_Def:SetText(vehicleInfo:get():getEquipment():getDefense())
  local vehicleType = servantWrapper:getVehicleType()
  if CppEnums.VehicleType.Type_PersonTradeShip == vehicleType or CppEnums.VehicleType.Type_CashPersonalTradeShip == vehicleType then
    self._mp:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_SHIPINFO_MP"))
  else
    self._mp:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_HEART"))
  end
  local deadCount = servantWrapper:getDeadCount()
  self._deadCountValue:SetText(deadCount)
  _extendedSlotNoId = {}
  for index, value in pairs(self._config._slotNo) do
    local slot = self._itemSlots[value]
    local itemWrapper = servantWrapper:getEquipItem(value)
    if nil ~= itemWrapper then
      shipInfo._config._slotEmptyBG[value]:SetShow(false)
      slot:setItem(itemWrapper)
      slot.icon:SetMonoTone(false)
      extendedSlotCheck(itemWrapper)
    else
      local isExtendedSlot = false
      for _, index in pairs(_extendedSlotNoId) do
        if value == index then
          isExtendedSlot = true
        end
      end
      if isExtendedSlot then
        shipInfo._config._slotEmptyBG[value]:SetShow(false)
      else
        slot:clearItem()
        shipInfo._config._slotEmptyBG[value]:SetShow(true)
      end
    end
  end
  UIScroll.SetButtonSize(self._skillScroll, self._config._skill.count, self._skillCount)
end
function shipInfo:registEventHandler()
  self._buttonClose:addInputEvent("Mouse_LUp", "ShipInfo_Close()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelServantinfo\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelServantinfo\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelServantinfo\", \"false\")")
  self._staticSkillBG:addInputEvent("Mouse_UpScroll", "ShipInfo_ScrollEvent( true )")
  self._staticSkillBG:addInputEvent("Mouse_DownScroll", "ShipInfo_ScrollEvent( false )")
  self._checkBtn_TotemShow:addInputEvent("Mouse_LUp", "ShipInfo_SetShowTotem()")
  UIScroll.InputEvent(self._skillScroll, "ShipInfo_ScrollEvent")
end
function shipInfo:registMessageHandler()
  registerEvent("EventSelfServantUpdate", "ShipInfo_Update()")
  registerEvent("EventSelfServantUpdateOnlyHp", "ShipInfo_UpdateHp")
  registerEvent("EventSelfServantUpdateOnlyMp", "ShipInfo_UpdateMp")
  registerEvent("EventServantEquipmentUpdate", "ShipInfo_Update()")
  registerEvent("EventServantEquipItem", "ShipInfo_ChangeEquipItem")
end
function ShipInfo_ChangeEquipItem(slotNo)
  ShipInfo_SetShowTotem()
  local self = shipInfo
  local slot = self._itemSlots[slotNo]
  if nil == self._actorKeyRaw then
    return
  end
  local temporaryWrapper = getTemporaryInformationWrapper()
  local vehicleWrapper = temporaryWrapper:getUnsealVehicleByActorKeyRaw(self._actorKeyRaw)
  if nil == vehicleWrapper then
    return
  end
  local vehicleType = vehicleWrapper:getVehicleType()
  if UI_VT.Type_Boat ~= vehicleType or UI_VT.Type_Raft ~= vehicleType or UI_VT.Type_FishingBoat ~= vehicleType or UI_VT.Type_SailingBoat ~= vehicleType or UI_VT.Type_PersonalBattleShip ~= vehicleType or UI_VT.Type_CashPersonalBattleShip ~= vehicleType then
    return
  end
  slot.icon:AddEffect("UI_ItemInstall", false, 0, 0)
  slot.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
  local itemWrapper = vehicleWrapper:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local defence = itemWrapper:getStaticStatus():getDefence(0)
  if defence > 0 then
    self._staticText_Value_Def:AddEffect("fUI_SkillButton01", false, -6, 2)
    self._staticText_Value_Def:AddEffect("UI_SkillButton01", false, -6, 2)
  end
end
function ShipInfo_RClick(slotNo)
  local self = shipInfo
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship) then
    return
  end
  local servantWrapper = temporaryWrapper:getUnsealVehicleByActorKeyRaw(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local itemWrapper = servantWrapper:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  servant_doUnequip(servantWrapper:getActorKeyRaw(), slotNo)
end
function ShipInfo_LClick(slotNo)
  if DragManager.dragStartPanel == Panel_Window_Inventory then
    Inventory_SlotRClick(DragManager.dragSlotInfo)
    DragManager.clearInfo()
  end
end
function ShipInfo_EquipItem_MouseOn(slotNo, isOn)
  local self = shipInfo
  local slot = self._itemSlots[slotNo]
  Panel_Tooltip_Item_SetPosition(slotNo, slot, "ServantShipEquipment")
  Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "ServantShipEquipment", isOn)
end
function ShipInfo_SetShowTotem()
  local self = shipInfo
  local temporaryWrapper = getTemporaryInformationWrapper()
  local seaVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
  if nil == seaVehicleWrapper then
    return
  end
  local isCheck = self._checkBtn_TotemShow:IsCheck()
  if isCheck then
    ToClient_SetVehicleEquipSlotFlag(seaVehicleWrapper:getVehicleType(), self._config._totemSlotNo)
  else
    ToClient_ResetVehicleEquipSlotFlag(seaVehicleWrapper:getVehicleType(), self._config._totemSlotNo)
  end
  ToClient_setShowVehicleEquip(CppEnums.ServantType.Type_Ship)
end
function ShipInfo_ScrollEvent(isScrollUp)
  local self = shipInfo
  self._skillStart = UIScroll.ScrollEvent(self._skillScroll, isScrollUp, self._config._skill.count, self._skillCount, self._skillStart, 1)
  self:update()
end
function ShipInfo_OpenByActorKeyRaw(actorKeyRaw)
  local self = shipInfo
  self._actorKeyRaw = actorKeyRaw
  ShipInfo_Open()
end
function ShipInfo_GetActorKey()
  local self = shipInfo
  return self._actorKeyRaw
end
function ShipInfo_Update()
  if not Panel_ShipInfo:GetShow() then
    return
  end
  local self = shipInfo
  self:update()
end
function ShipInfo_UpdateHp()
  if false == Panel_ShipInfo:GetShow() then
    return
  end
  local self = shipInfo
  self:updateHp()
end
function ShipInfo_UpdateMp()
  if false == Panel_ShipInfo:GetShow() then
    return
  end
  local self = shipInfo
  self:updateMp()
end
function ShipInfo_Open()
  local self = shipInfo
  self:update()
  if Panel_ShipInfo:GetShow() then
    return
  end
  Panel_ShipInfo:SetShow(true, true)
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil ~= servantWrapper then
    local isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), self._config._totemSlotNo)
    self._checkBtn_TotemShow:SetCheck(isCheck)
  end
end
function ShipInfo_Close()
  if not Panel_ShipInfo:GetShow() then
    return
  end
  Panel_ShipInfo:SetShow(false, false)
  Panel_Tooltip_Item_hideTooltip()
end
shipInfo:init()
shipInfo:registEventHandler()
shipInfo:registMessageHandler()
FGlobal_PanelMove(Panel_ShipInfo, false)
