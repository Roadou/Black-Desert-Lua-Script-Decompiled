local ENUM_NEW_VT = {
  HORSE = 0,
  CARRIAGE = 1,
  SHIP = 2,
  WORKSHIP = 3
}
local Panel_Window_ShipInfo_info = {
  _ui = {
    staticText_Title = nil,
    static_Bg = nil,
    static_LeftBg = nil,
    static_TopBg = nil,
    static_Image = nil,
    staticText_Name = nil,
    static_InfoBg = nil,
    staticText_HPVal = nil,
    progress2_HP = nil,
    staticText_SP = nil,
    staticText_SPVal = nil,
    progress2_SP = nil,
    staticText_WeightVal = nil,
    progress2_Weight = nil,
    staticText_SusVal = nil,
    staticText_SpeedVal = nil,
    staticText_DeadVal = nil,
    staticText_AccVal = nil,
    staticText_LifeVal = nil,
    staticText_RotateVal = nil,
    staticText_BreakVal = nil,
    staticText_Desc = nil,
    staticText_DescValue = nil,
    equipSlot = {},
    equipOverfitSlot = {},
    static_RightBg = nil,
    static_RightText = nil,
    list2_SkillList = nil,
    static_tooltipBG = nil,
    staticText_SkillName = nil,
    staticText_SkillCommand = nil
  },
  _equipTotalSlot = {},
  _equipSlotNo = {
    [1] = 4,
    [2] = 5,
    [3] = 25,
    [4] = 3,
    [5] = 6,
    [6] = 12
  },
  _equipOverfitSlotNo = {
    [1] = 15,
    [2] = 16,
    [3] = 26,
    [4] = 14
  },
  _config = {
    equipCheckFlag = {
      [6] = 8
    },
    itemSlot = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    }
  },
  _progressTexture = {
    path = "renewal/Progress/console_Progressbar_01.dds",
    blue = {
      420,
      324,
      456,
      330
    },
    yellow = {
      467,
      276,
      503,
      282
    }
  },
  _value = {actorKeyRaw = nil, shipType = nil},
  _size = {baseSizeX = 0, smallSizeX = 0},
  _string = {life = nil, mp = nil},
  _skillId = {}
}
local skillList = {}
function Panel_Window_ShipInfo_info:registEventHandler()
end
function Panel_Window_ShipInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_ShipInfo_Resize")
end
function Panel_Window_ShipInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_ShipInfo_info:initValue()
  self._value.actorKeyRaw = nil
  self._value.shipType = nil
end
function Panel_Window_ShipInfo_info:initString()
  self._string.life = PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_HEART")
  self._string.mp = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_SHIPINFO_MP")
end
function Panel_Window_ShipInfo_info:resize()
  Panel_ShipInfo:ComputePos()
  if Panel_ShipInfo:GetSizeX() == self._size.smallSizeX then
    Panel_ShipInfo:SetPosX(Panel_ShipInfo:GetPosX() - (self._size.baseSizeX - self._size.smallSizeX) / 2)
  end
end
function Panel_Window_ShipInfo_info:resizeSmall()
  Panel_ShipInfo:SetSize(self._size.smallSizeX, Panel_ShipInfo:GetSizeY())
  self._ui.static_Bg:SetSize(self._size.smallSizeX - 10, self._ui.static_Bg:GetSizeY())
  self._ui.staticText_Title:ComputePos()
  self._ui.static_Bg:ComputePos()
end
function Panel_Window_ShipInfo_info:resizeBig()
  Panel_ShipInfo:SetSize(self._size.baseSizeX, Panel_ShipInfo:GetSizeY())
  self._ui.static_Bg:SetSize(self._size.smallSizeX - 10, self._ui.static_Bg:GetSizeY())
  self._ui.staticText_Title:ComputePos()
  self._ui.static_Bg:ComputePos()
end
function Panel_Window_ShipInfo_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_ShipInfo, "StaticText_Title")
  self._ui.static_Bg = UI.getChildControl(Panel_ShipInfo, "Static_Bg")
  self._ui.static_LeftBg = UI.getChildControl(Panel_ShipInfo, "Static_LeftBg")
  self._ui.static_TopBg = UI.getChildControl(self._ui.static_LeftBg, "Static_TopBg")
  self._ui.static_Image = UI.getChildControl(self._ui.static_TopBg, "Static_Image")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_TopBg, "StaticText_Name")
  self._size.baseSizeX = Panel_ShipInfo:GetSizeX()
  self._size.smallSizeX = self._ui.static_LeftBg:GetSizeX() + 30
  self._ui.static_InfoBg = UI.getChildControl(self._ui.static_LeftBg, "Static_InfoBg")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_HPVal")
  self._ui.progress2_HP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_HP")
  self._ui.staticText_SP = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SP")
  self._ui.staticText_SPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SPVal")
  self._ui.progress2_SP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_SP")
  self._ui.staticText_WeightVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_WeightVal")
  self._ui.progress2_Weight = UI.getChildControl(self._ui.static_InfoBg, "Progress2_Weight")
  self._ui.staticText_SusVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SusVal")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SpeedVal")
  self._ui.staticText_DeadVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DeadVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AccVal")
  self._ui.staticText_Life = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Life")
  self._ui.staticText_LifeVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_LifeVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_RotateVal")
  self._ui.staticText_DefenseVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DefenseVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_BreakVal")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc")
  self._ui.staticText_DescValue = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Value")
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
  self._ui.static_RightBg = UI.getChildControl(Panel_ShipInfo, "Static_RightBg")
  self._ui.static_RightText = UI.getChildControl(self._ui.static_RightBg, "Static_RightText")
  self._ui.list2_SkillList = UI.getChildControl(self._ui.static_RightBg, "List2_SkillList")
  self._ui.list2_SkillList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_ShipInfo_SkillList")
  self._ui.list2_SkillList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.static_tooltipBG = UI.getChildControl(Panel_ShipInfo, "Static_Tooltip")
  self._ui.staticText_SkillName = UI.getChildControl(self._ui.static_tooltipBG, "StaticText_Name")
  self._ui.staticText_SkillCommand = UI.getChildControl(self._ui.static_tooltipBG, "StaticText_Command")
end
function Panel_Window_ShipInfo_info:updateBaseInfo()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel() .. " " .. servantInfo:getName()))
  self._ui.static_Image:SetShow(true)
  self._ui.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._ui.staticText_SusVal:SetText(servantInfo:getSuspension())
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
  self._ui.staticText_SpeedVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_AccVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_RotateVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_BreakVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  local vehicleInfo = getVehicleActor(self._value.actorKeyRaw)
  if nil ~= vehicleInfo then
    self._ui.staticText_DefenseVal:SetText(vehicleInfo:get():getEquipment():getDefense())
  end
  if servantInfo:isPeriodLimit() then
    self._ui.staticText_LifeVal:SetText(convertStringFromDatetime(servantInfo:getExpiredTime()))
  else
    self._ui.staticText_LifeVal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
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
function Panel_Window_ShipInfo_info:changeShip()
  if ENUM_NEW_VT.WORKSHIP == self._value.shipType then
    self._ui.staticText_SP:SetText(self._string.mp)
    self._ui.progress2_SP:ChangeTextureInfoName(self._progressTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress2_SP, self._progressTexture.blue[1], self._progressTexture.blue[2], self._progressTexture.blue[3], self._progressTexture.blue[4])
    self._ui.progress2_SP:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress2_SP:setRenderTexture(self._ui.progress2_SP:getBaseTexture())
    self._ui.staticText_Life:SetShow(true)
    self._ui.staticText_LifeVal:SetShow(true)
  else
    self._ui.staticText_SP:SetText(self._string.life)
    self._ui.progress2_SP:ChangeTextureInfoName(self._progressTexture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.progress2_SP, self._progressTexture.yellow[1], self._progressTexture.yellow[2], self._progressTexture.yellow[3], self._progressTexture.yellow[4])
    self._ui.progress2_SP:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.progress2_SP:setRenderTexture(self._ui.progress2_SP:getBaseTexture())
    self._ui.staticText_Life:SetShow(false)
    self._ui.staticText_LifeVal:SetShow(false)
  end
end
function Panel_Window_ShipInfo_info:updateHp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_HPVal:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.progress2_HP:SetProgressRate(servantInfo:getHp() * 100 / servantInfo:getMaxHp())
end
function Panel_Window_ShipInfo_info:updateMp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_SPVal:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.progress2_SP:SetProgressRate(servantInfo:getMp() * 100 / servantInfo:getMaxMp())
end
function Panel_Window_ShipInfo_info:updateEquip()
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
  if ENUM_NEW_VT.WORKSHIP == self._value.shipType then
    self._ui.equipSlot[12].control:SetShow(true)
    self._ui.equipSlot[3].control:SetShow(true)
    self._ui.equipSlot[6].control:SetShow(false)
    self._ui.equipSlot[6].check:SetShow(false)
  else
    self._ui.equipSlot[12].control:SetShow(false)
    self._ui.equipSlot[3].control:SetShow(false)
    self._ui.equipSlot[6].control:SetShow(true)
    self._ui.equipSlot[6].check:SetShow(true)
  end
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
function Panel_Window_ShipInfo_info:updateSkill()
  self._ui.list2_SkillList:getElementManager():clearKey()
  skillList = {}
  for k in pairs(self._skillId) do
    self._skillId[k] = nil
  end
  if nil == self._value.actorKeyRaw then
    return
  end
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local slotSkillCount = 0
  local skillKey = {}
  local learnSkillCount = vehicleSkillStaticStatus_skillCount()
  for jj = 1, learnSkillCount - 1 do
    local skillWrapper = servantInfo:getSkill(jj)
    if nil ~= skillWrapper then
      self._skillId[slotSkillCount] = jj
      slotSkillCount = slotSkillCount + 1
    end
  end
  if 0 == slotSkillCount then
    self._ui.static_RightBg:SetShow(false)
    self._ui.static_RightText:SetShow(true)
    self:resizeSmall()
    return
  end
  self:resizeBig()
  self._ui.static_RightBg:SetShow(true)
  self._ui.static_RightText:SetShow(false)
  for index = 0, slotSkillCount - 1 do
    self._ui.list2_SkillList:getElementManager():pushKey(toInt64(0, self._skillId[index]))
    self._ui.list2_SkillList:requestUpdateByKey(toInt64(0, self._skillId[index]))
  end
end
function Panel_Window_ShipInfo_info:changeEquip(slotNo)
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
function Panel_Window_ShipInfo_info:updateContent()
  self:updateHp()
  self:updateMp()
  self:updateBaseInfo()
  self:updateEquip()
  self:updateSkill()
end
function Panel_Window_ShipInfo_info:open()
  Panel_ShipInfo:SetShow(true)
end
function Panel_Window_ShipInfo_info:close()
  Panel_ShipInfo:SetShow(false)
end
function PaGlobalFunc_ShipInfo_GetShow()
  return Panel_ShipInfo:GetShow()
end
function PaGlobalFunc_ShipInfo_Open()
  local self = Panel_Window_ShipInfo_info
  self:open()
end
function PaGlobalFunc_ShipInfo_Close()
  local self = Panel_Window_ShipInfo_info
  self:close()
end
function PaGlobalFunc_ShipInfo_Show(actorKeyRaw, eType)
  local self = Panel_Window_ShipInfo_info
  self._value.actorKeyRaw = actorKeyRaw
  self._value.shipType = eType
  self:changeShip()
  self:updateContent()
  self:open()
end
function PaGlobalFunc_ShipInfo_Exit()
  local self = Panel_Window_ShipInfo_info
  self:close()
end
function PaGlobalFunc_ShipInfo_Update()
  local self = Panel_Window_ShipInfo_info
  self:updateContent()
end
function PaGlobalFunc_ShipInfo_UpdateHp()
  local self = Panel_Window_ShipInfo_info
  self:updateHp()
end
function PaGlobalFunc_ShipInfo_UpdateMp()
  local self = Panel_Window_ShipInfo_info
  self:updateMp()
end
function PaGlobalFunc_ShipInfo_UpdateEquipMent()
  local self = Panel_Window_ShipInfo_info
  self:updateEquip()
end
function PaGlobalFunc_ShipInfo_ChangequipMent(slotNo)
  local self = Panel_Window_ShipInfo_info
  self:changeEquip(slotNo)
end
function PaGlobalFunc_ShipInfo_SkillList(list_content, key)
  local self = Panel_Window_ShipInfo_info
  local id = Int64toInt32(key)
  if nil == self._value.actorKeyRaw then
    return
  end
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local skillWrapper = servantInfo:getSkill(id)
  if nil == skillWrapper then
    return
  end
  local button_SkillBg = UI.getChildControl(list_content, "Button_SkillBg")
  local static_SkillIcon = UI.getChildControl(list_content, "Static_SkillIcon")
  local circularProgress_Train = UI.getChildControl(list_content, "CircularProgress_Train")
  local staticText_Name = UI.getChildControl(list_content, "StaticText_Name")
  local staticText_Command = UI.getChildControl(list_content, "StaticText_Command")
  local key32 = Int64toInt32(key)
  skillList[key32] = {}
  skillList[key32]._skillName = skillWrapper:getName()
  skillList[key32]._skillCommand = skillWrapper:getDescription()
  static_SkillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_Name:SetText(skillList[key32]._skillName)
  local expTxt = tonumber(string.format("%.0f", servantInfo:getSkillExp(id) / (skillWrapper:get()._maxExp / 100)))
  if expTxt >= 100 then
    expTxt = 100
  end
  circularProgress_Train:SetProgressRate(expTxt)
  staticText_Command:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_Command:SetText(skillList[key32]._skillCommand)
  if staticText_Name:IsLimitText() or staticText_Command:IsLimitText() then
    list_content:addInputEvent("Mouse_On", "HandleOvered_ShipInfo_Skill(" .. key32 .. ")")
    list_content:addInputEvent("Mouse_Out", "HandleOvered_ShipInfo_Skill()")
  end
end
function FromClient_ShipInfo_Init()
  local self = Panel_Window_ShipInfo_info
  self:initialize()
end
function FromClient_ShipInfo_Resize()
  local self = Panel_Window_ShipInfo_info
  self:resize()
end
function HandleOvered_ShipInfo_Skill(key32)
  local self = Panel_Window_ShipInfo_info
  if nil == key32 then
    self._ui.static_tooltipBG:SetShow(false)
    return
  end
  local tooltip = self._ui.static_tooltipBG
  local key = toInt64(0, key32)
  local posY = self._ui.list2_SkillList:GetContentByKey(key):GetPosY()
  tooltip:SetShow(true)
  tooltip:SetPosY(70 + posY)
  self._ui.staticText_SkillName:SetText(skillList[key32]._skillName)
  self._ui.staticText_SkillCommand:SetText(skillList[key32]._skillCommand)
  local textSize1 = self._ui.staticText_SkillName:GetTextSizeX()
  local textSize2 = self._ui.staticText_SkillCommand:GetTextSizeX()
  if textSize1 < textSize2 then
    textSize1 = textSize2
  end
  tooltip:SetSize(40 + textSize1, tooltip:GetSizeY())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ShipInfo_Init")
