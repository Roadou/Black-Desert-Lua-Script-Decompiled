local Panel_Window_CarriageInfo_info = {
  _ui = {
    staticText_Title = nil,
    static_LeftBg = nil,
    static_TopBg = nil,
    static_Image = nil,
    staticText_Name = nil,
    static_InfoBg = nil,
    staticText_HPVal = nil,
    progress2_HP = nil,
    staticText_SPVal = nil,
    progress2_SP = nil,
    staticText_WeightVal = nil,
    progress2_Weight = nil,
    staticText_SusVal = nil,
    staticText_SpeedVal = nil,
    staticText_DeadVal = nil,
    staticText_AccVal = nil,
    staticText_RotateVal = nil,
    staticText_BreakVal = nil,
    staticText_Desc = nil,
    staticText_DescValue = nil,
    equipSlot = {},
    equipOverfitSlot = {},
    static_RightText = nil,
    static_RightBg = nil,
    staticText_Count = nil,
    staticList_LinkHorse = {},
    list2_SkillList = nil
  },
  _equipTotalSlot = {},
  _slotNo = {
    3,
    4,
    5,
    6,
    13,
    25,
    14,
    15,
    16,
    17,
    26
  },
  _equipSlotNo = {
    [1] = 3,
    [2] = 4,
    [3] = 5,
    [4] = 6,
    [5] = 13,
    [6] = 25
  },
  _equipOverfitSlotNo = {
    [1] = 14,
    [2] = 15,
    [3] = 16,
    [4] = 17,
    [5] = 26
  },
  _config = {
    equipCheckFlag = {},
    itemSlot = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    },
    linkCount = 4
  },
  _value = {actorKeyRaw = nil},
  _size = {baseSizeX = 0, smallSizeX = 0},
  _textureSex = {
    sexIcon = "Renewal/UI_Icon/Console_Icon_01.dds",
    male = {
      x1 = 82,
      y1 = 1,
      x2 = 101,
      y2 = 20
    },
    female = {
      x1 = 62,
      y1 = 1,
      x2 = 81,
      y2 = 20
    }
  },
  _skillId = {}
}
function Panel_Window_CarriageInfo_info:registEventHandler()
end
function Panel_Window_CarriageInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_CarriageInfo_Resize")
end
function Panel_Window_CarriageInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_CarriageInfo_info:initValue()
  self._value.actorKeyRaw = nil
end
function Panel_Window_CarriageInfo_info:resize()
  Panel_CarriageInfo:ComputePos()
  if Panel_CarriageInfo:GetSizeX() == self._size.smallSizeX then
    Panel_CarriageInfo:SetPosX(Panel_CarriageInfo:GetPosX() - (self._size.baseSizeX - self._size.smallSizeX) / 2)
  end
end
function Panel_Window_CarriageInfo_info:resizeSmall()
  Panel_CarriageInfo:SetSize(self._size.smallSizeX, Panel_CarriageInfo:GetSizeY())
  self._ui.staticText_Title:ComputePos()
end
function Panel_Window_CarriageInfo_info:resizeBig()
  Panel_CarriageInfo:SetSize(self._size.baseSizeX, Panel_CarriageInfo:GetSizeY())
  self._ui.staticText_Title:ComputePos()
end
function Panel_Window_CarriageInfo_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_CarriageInfo, "StaticText_Title")
  self._ui.static_LeftBg = UI.getChildControl(Panel_CarriageInfo, "Static_LeftBg")
  self._ui.static_TopBg = UI.getChildControl(self._ui.static_LeftBg, "Static_TopBg")
  self._ui.static_Image = UI.getChildControl(self._ui.static_TopBg, "Static_Image")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_TopBg, "StaticText_Name")
  self._size.baseSizeX = Panel_CarriageInfo:GetSizeX()
  self._size.smallSizeX = self._ui.static_LeftBg:GetSizeX()
  self._ui.static_InfoBg = UI.getChildControl(self._ui.static_LeftBg, "Static_InfoBg")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_HPVal")
  self._ui.progress2_HP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_HP")
  self._ui.staticText_SPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SPVal")
  self._ui.progress2_SP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_SP")
  self._ui.staticText_WeightVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_WeightVal")
  self._ui.progress2_Weight = UI.getChildControl(self._ui.static_InfoBg, "Progress2_Weight")
  self._ui.staticText_SusVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SusVal")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SpeedVal")
  self._ui.staticText_DeadVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DeadVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AccVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_RotateVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_BreakVal")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc")
  self._ui.staticText_DescValue = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Value")
  self._ui.staticText_DefenseVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DefenseVal")
  for key, value in pairs(self._equipSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Equip" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_EquipWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_Slot" .. key)
    SlotItem.new(slot, "ServantInfoEquipment_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipSlot[value] = slot
    self._equipTotalSlot[value] = slot
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Outfit" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_OutfitWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_OutfitSlot" .. key)
    SlotItem.new(slot, "ServantInfoOverfit_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipOverfitSlot[value] = slot
    self._equipTotalSlot[value] = slot
  end
  self._ui.static_RightText = UI.getChildControl(Panel_CarriageInfo, "Static_RightText")
  self._ui.static_RightBg = UI.getChildControl(Panel_CarriageInfo, "Static_RightBg")
  self._ui.staticText_Count = UI.getChildControl(self._ui.static_RightBg, "StaticText_Count")
  for index = 0, self._config.linkCount - 1 do
    local slot = {
      button = nil,
      static_Icon = nil,
      staticText_Name = nil,
      staticText_Level = nil,
      staticText_Tier = nil
    }
    slot.button = UI.getChildControl(self._ui.static_RightBg, "Button_LinkHorse_" .. index)
    slot.static_Icon = UI.getChildControl(slot.button, "Static_Icon")
    slot.staticText_Name = UI.getChildControl(slot.button, "StaticText_Name")
    slot.staticText_Level = UI.getChildControl(slot.button, "StaticText_Level")
    slot.staticText_Tier = UI.getChildControl(slot.button, "StaticText_Tier")
    slot.staticText_Y_ConsoleUI = UI.getChildControl(slot.button, "StaticText_Y_ConsoleUI")
    self._ui.staticList_LinkHorse[index] = slot
  end
end
function Panel_Window_CarriageInfo_info:updateBaseInfo()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel() .. " " .. servantInfo:getName()))
  self._ui.static_Image:SetShow(true)
  self._ui.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  local max_weight = Int64toInt32(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32((servantInfo:getInventoryWeight_s64() + servantInfo:getEquipWeight_s64()) / Defines.s64_const.s64_10000)
  local weightPercent = total_weight / max_weight * 100
  local weightValue = ""
  if max_weight < total_weight then
    weightPercent = 100
    weightValue = "<PAColor0xFFD20000>" .. makeDotMoney(total_weight) .. "<PAOldColor> / " .. makeDotMoney(max_weight)
  else
    weightValue = makeDotMoney(total_weight) .. " / " .. makeDotMoney(max_weight)
  end
  self._ui.staticText_WeightVal:SetText(weightValue)
  self._ui.progress2_Weight:SetProgressRate(weightPercent)
  self._ui.staticText_SusVal:SetText(servantInfo:getSuspension())
  self._ui.staticText_SpeedVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_AccVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_RotateVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_BreakVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  local vehicleInfo = getVehicleActor(self._value.actorKeyRaw)
  if nil ~= vehicleInfo then
    self._ui.staticText_DefenseVal:SetText(vehicleInfo:get():getEquipment():getDefense())
  end
  local descText = ""
  local descValue = ""
  local deadCount = servantInfo:getDeadCount()
  self._ui.staticText_DeadVal:SetText(deadCount)
  descText = descText .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT")
  if servantInfo:doClearCountByDead() then
    descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
  else
    descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
  end
  if "" == descText then
    self._ui.staticText_Desc:SetShow(false)
  else
    self._ui.staticText_Desc:SetShow(true)
    self._ui.staticText_Desc:SetText(descText)
  end
  if "" == descValue then
    self._ui.staticText_DescValue:SetShow(false)
  else
    self._ui.staticText_DescValue:SetShow(true)
    self._ui.staticText_DescValue:SetText(descValue)
  end
end
function Panel_Window_CarriageInfo_info:updateHp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_HPVal:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.progress2_HP:SetProgressRate(servantInfo:getHp() * 100 / servantInfo:getMaxHp())
end
function Panel_Window_CarriageInfo_info:updateMp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_SPVal:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.progress2_SP:SetProgressRate(servantInfo:getMp() * 100 / servantInfo:getMaxMp())
end
function Panel_Window_CarriageInfo_info:updateEquip()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  for key, value in pairs(self._equipSlotNo) do
    if nil == self._config.equipCheckFlag[value] then
      self._ui.equipSlot[value].check:SetShow(false)
    else
      self._ui.equipSlot[value].check:SetShow(true)
    end
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    if nil == self._config.equipCheckFlag[value] then
      self._ui.equipOverfitSlot[value].check:SetShow(false)
    else
      self._ui.equipOverfitSlot[value].check:SetShow(true)
    end
  end
  self._ui.equipSlot[3].control:SetShow(false)
  self._ui.equipSlot[13].control:SetShow(true)
  self._ui.equipSlot[25].control:SetShow(true)
  self._ui.equipOverfitSlot[26].control:SetShow(true)
  self._ui.equipOverfitSlot[16].control:SetShow(false)
  self._ui.equipOverfitSlot[17].control:SetShow(false)
  for key, value in pairs(self._equipSlotNo) do
    local slot = self._ui.equipSlot[value]
    local itemWrapper = servantInfo:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
    end
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = self._ui.equipOverfitSlot[value]
    local itemWrapper = servantInfo:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
    end
  end
end
function Panel_Window_CarriageInfo_info:clearLinkHorse()
  for index = 0, self._config.linkCount - 1 do
    self._ui.staticList_LinkHorse[index].button:SetShow(false)
    self._ui.staticList_LinkHorse[index].staticText_Y_ConsoleUI:SetShow(false)
    self._ui.staticList_LinkHorse[index].button:addInputEvent("Mouse_On", "")
    self._ui.staticList_LinkHorse[index].button:addInputEvent("Mouse_Out", "")
    self._ui.staticList_LinkHorse[index].button:registerPadEvent(__eConsoleUIPadEvent_Y, "")
  end
end
function Panel_Window_CarriageInfo_info:updateLinkHorse()
  self:clearLinkHorse()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local servantCount = servantInfo:getCurrentLinkCount()
  self._ui.staticText_Count:SetText(servantInfo:getCurrentLinkCount() .. " / " .. servantInfo:getLinkCount())
  if 0 == servantCount then
    self._ui.static_RightText:SetShow(true)
  else
    self._ui.static_RightText:SetShow(false)
  end
  for index = 0, servantCount - 1 do
    local horseInfo = stable_getServantFromOwnerServant(servantInfo:getServantNo(), index)
    if nil ~= horseInfo then
      self._ui.staticList_LinkHorse[index].button:SetShow(true)
      local linkedHorse = self._ui.staticList_LinkHorse[index]
      linkedHorse.static_Icon:ChangeTextureInfoName(horseInfo:getIconPath1())
      linkedHorse.staticText_Name:SetText(horseInfo:getName())
      linkedHorse.staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(horseInfo:getLevel()))
      linkedHorse.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", horseInfo:getTier()))
      self._ui.staticList_LinkHorse[index].button:addInputEvent("Mouse_On", "PaGlobalFunc_CarriageInfo_OnLinkedHorse(" .. index .. ")")
      self._ui.staticList_LinkHorse[index].button:addInputEvent("Mouse_Out", "PaGlobalFunc_CarriageInfo_OutLinkedHorse(" .. index .. ")")
      self._ui.staticList_LinkHorse[index].button:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_CarriageInfo_ClickLinkedHorse(" .. index .. ")")
    else
      self._ui.staticList_LinkHorse[index].button:SetShow(false)
      self._ui.staticList_LinkHorse[index].staticText_Y_ConsoleUI:SetShow(false)
    end
  end
end
function Panel_Window_CarriageInfo_info:changeEquip(slotNo)
  local slot = self._equipTotalSlot[slotNo]
  if nil == self._value.actorKeyRaw then
    return
  end
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  slot.icon:AddEffect("UI_ItemInstall", false, 0, 0)
  slot.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
  local itemWrapper = servantInfo:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local defence = itemWrapper:getStaticStatus():getDefence(0)
  if defence > 0 then
  end
end
function Panel_Window_CarriageInfo_info:updateContent()
  self:updateHp()
  self:updateMp()
  self:updateBaseInfo()
  self:updateEquip()
  self:updateLinkHorse()
end
function Panel_Window_CarriageInfo_info:open()
  Panel_CarriageInfo:SetShow(true)
end
function Panel_Window_CarriageInfo_info:close()
  Panel_CarriageInfo:SetShow(false)
end
function PaGlobalFunc_CarriageInfo_linkHorsePosXY()
  local openPosX, openPosY
  openPosX = Panel_CarriageInfo:GetPosX() + Panel_CarriageInfo:GetSizeX() + 10
  openPosY = Panel_CarriageInfo:GetPosY()
  return openPosX, openPosY
end
function PaGlobalFunc_CarriageInfo_GetShow()
  return Panel_CarriageInfo:GetShow()
end
function PaGlobalFunc_CarriageInfo_Open()
  local self = Panel_Window_CarriageInfo_info
  self:open()
end
function PaGlobalFunc_CarriageInfo_Close()
  local self = Panel_Window_CarriageInfo_info
  self:close()
end
function PaGlobalFunc_CarriageInfo_Show(actorKeyRaw)
  local self = Panel_Window_CarriageInfo_info
  self._value.actorKeyRaw = actorKeyRaw
  self:updateContent()
  self:open()
end
function PaGlobalFunc_CarriageInfo_Exit()
  local self = Panel_Window_CarriageInfo_info
  self:close()
  PaGlobalFunc_LinkHorseInfo_Exit()
end
function PaGlobalFunc_CarriageInfo_Update()
  local self = Panel_Window_CarriageInfo_info
  self:updateContent()
end
function PaGlobalFunc_CarriageInfo_UpdateHp()
  local self = Panel_Window_CarriageInfo_info
  self:updateHp()
end
function PaGlobalFunc_CarriageInfo_UpdateMp()
  local self = Panel_Window_CarriageInfo_info
  self:updateMp()
end
function PaGlobalFunc_CarriageInfo_UpdateEquipMent()
  local self = Panel_Window_CarriageInfo_info
  self:updateEquip()
end
function PaGlobalFunc_CarriageInfo_ChangequipMent(slotNo)
  local self = Panel_Window_CarriageInfo_info
  self:changeEquip(slotNo)
end
function PaGlobalFunc_CarriageInfo_OnLinkedHorse(index)
  local self = Panel_Window_CarriageInfo_info
  self._ui.staticList_LinkHorse[index].staticText_Y_ConsoleUI:SetShow(true)
end
function PaGlobalFunc_CarriageInfo_OutLinkedHorse(index)
  local self = Panel_Window_CarriageInfo_info
  self._ui.staticList_LinkHorse[index].staticText_Y_ConsoleUI:SetShow(false)
end
function PaGlobalFunc_CarriageInfo_ClickLinkedHorse(index)
  local self = Panel_Window_CarriageInfo_info
  PaGlobalFunc_LinkHorseInfo_Show(self._value.actorKeyRaw, index)
end
function FromClient_CarriageInfo_Init()
  local self = Panel_Window_CarriageInfo_info
  self:initialize()
end
function FromClient_CarriageInfo_Resize()
  local self = Panel_Window_CarriageInfo_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CarriageInfo_Init")
