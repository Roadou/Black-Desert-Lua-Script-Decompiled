local Panel_Window_HorseInfo_info = {
  _ui = {
    staticText_Title = nil,
    static_Bg = nil,
    static_LeftBg = nil,
    static_TopBg = nil,
    static_Image = nil,
    staticText_Tier = nil,
    static_SexIcon = nil,
    staticText_Name = nil,
    staticText_Swift = nil,
    static_InfoBg = nil,
    staticText_HPVal = nil,
    progress2_HP = nil,
    staticText_SPVal = nil,
    progress2_SP = nil,
    staticText_WeightVal = nil,
    progress2_Weight = nil,
    staticText_EXPVal = nil,
    progress2_EXP = nil,
    staticText_SpeedVal = nil,
    staticText_DeadVal = nil,
    staticText_AccVal = nil,
    staticText_LifeVal = nil,
    staticText_RotateVal = nil,
    staticText_Stamping = nil,
    staticText_StampingVal = nil,
    staticText_BreakVal = nil,
    staticText_Mating = nil,
    staticText_MatingVal = nil,
    staticText_Desc = nil,
    staticText_Desc2 = nil,
    StaticText_DescValue = nil,
    StaticText_DescValue2 = nil,
    checkbtn_AutoCarrot = nil,
    equipSlot = {},
    equipOverfitSlot = {},
    static_RightBg = nil,
    static_RightText = nil,
    list2_SkillList = nil,
    list2_1_Content = nil
  },
  _equipTotalSlot = {},
  _equipSlotNo = {
    [1] = 3,
    [2] = 4,
    [3] = 5,
    [4] = 6,
    [5] = 12
  },
  _equipOverfitSlotNo = {
    [1] = 14,
    [2] = 15,
    [3] = 16,
    [4] = 17
  },
  _config = {
    equipCheckFlag = {
      [3] = 1,
      [4] = 2,
      [5] = 4,
      [6] = 8,
      [14] = 16,
      [15] = 32,
      [16] = 64,
      [17] = 128
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
  _value = {actorKeyRaw = nil},
  _size = {
    baseSizeX = 0,
    smallSizeX = 0,
    tooltipStartPosX = 0,
    tooltipStartPosY = 0,
    contentSizeY = 0,
    contentSizeX = 0
  },
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
local _button_SkillBgIdTable = {}
function Panel_Window_HorseInfo_info:registEventHandler()
  Panel_Window_ServantInfo:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_HorseInfo_CheckToggleAutoCarrot()")
end
function Panel_Window_HorseInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_HorseInfo_Resize")
end
function Panel_Window_HorseInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_HorseInfo_info:initValue()
  self._value.actorKeyRaw = nil
  self._size.tooltipStartPosX = Panel_Window_ServantInfo:GetPosX() + Panel_Window_ServantInfo:GetSizeX()
  self._size.tooltipStartPosY = Panel_Window_ServantInfo:GetPosY() + self._ui.static_RightBg:GetPosY() + self._ui.list2_SkillList:GetPosY()
  self._size.contentSizeY = self._ui.list2_1_Content:GetSizeY()
  self._size.contentSizeX = self._ui.list2_1_Content:GetSizeX()
  self._ui.checkbtn_AutoCarrot:SetCheck(true)
end
function Panel_Window_HorseInfo_info:resize()
  Panel_Window_ServantInfo:ComputePos()
  if Panel_Window_ServantInfo:GetSizeX() == self._size.smallSizeX then
    Panel_Window_ServantInfo:SetPosX(Panel_Window_ServantInfo:GetPosX() - (self._size.baseSizeX - self._size.smallSizeX) / 2)
  end
  if 388 < self._ui.staticText_AutoCarrot:GetTextSizeX() then
    local tempText = self._ui.staticText_AutoCarrot:GetText()
    self._ui.staticText_AutoCarrot:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_AutoCarrot:SetText(tempText)
  end
end
function Panel_Window_HorseInfo_info:resizeSmall()
  Panel_Window_ServantInfo:SetSize(self._size.smallSizeX, Panel_Window_ServantInfo:GetSizeY())
  self._ui.static_Bg:SetSize(self._size.smallSizeX - 10, self._ui.static_Bg:GetSizeY())
  self._ui.staticText_Title:ComputePos()
  self._ui.static_Bg:ComputePos()
end
function Panel_Window_HorseInfo_info:resizeBig()
  Panel_Window_ServantInfo:SetSize(self._size.baseSizeX, Panel_Window_ServantInfo:GetSizeY())
  self._ui.static_Bg:SetSize(self._size.baseSizeX - 10, self._ui.static_Bg:GetSizeY())
  self._ui.staticText_Title:ComputePos()
  self._ui.static_Bg:ComputePos()
end
function Panel_Window_HorseInfo_info:childControl()
  self._ui.staticText_Title = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Title")
  self._ui.static_Bg = UI.getChildControl(Panel_Window_ServantInfo, "Static_Bg")
  self._ui.static_LeftBg = UI.getChildControl(Panel_Window_ServantInfo, "Static_LeftBg")
  self._ui.static_TopBg = UI.getChildControl(self._ui.static_LeftBg, "Static_TopBg")
  self._ui.static_Image = UI.getChildControl(self._ui.static_TopBg, "Static_Image")
  self._ui.staticText_Tier = UI.getChildControl(self._ui.static_TopBg, "StaticText_Tier")
  self._ui.static_SexIcon = UI.getChildControl(self._ui.static_TopBg, "Static_SexIcon")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_TopBg, "StaticText_Name")
  self._ui.staticText_Swift = UI.getChildControl(self._ui.static_TopBg, "StaticText_Swift")
  self._size.baseSizeX = Panel_Window_ServantInfo:GetSizeX()
  self._size.smallSizeX = self._ui.static_LeftBg:GetSizeX() + 30
  self._ui.static_InfoBg = UI.getChildControl(self._ui.static_LeftBg, "Static_InfoBg")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_HPVal")
  self._ui.progress2_HP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_HP")
  self._ui.staticText_SPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SPVal")
  self._ui.progress2_SP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_SP")
  self._ui.staticText_WeightVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_WeightVal")
  self._ui.progress2_Weight = UI.getChildControl(self._ui.static_InfoBg, "Progress2_Weight")
  self._ui.staticText_EXPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_EXPVal")
  self._ui.progress2_EXP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_EXP")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SpeedVal")
  self._ui.staticText_DeadVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DeadVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AccVal")
  self._ui.staticText_LifeVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_LifeVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_RotateVal")
  self._ui.staticText_Stamping = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Stamping")
  self._ui.staticText_StampingVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_StampingVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_BreakVal")
  self._ui.staticText_Mating = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Mating")
  self._ui.staticText_MatingVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_MatingVal")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc")
  self._ui.staticText_Desc2 = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc1")
  self._ui.staticText_DescValue = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Value")
  self._ui.staticText_DescValue1 = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Value1")
  self._ui.staticText_Defense = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Defense")
  self._ui.staticText_DefenseVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DefenseVal")
  self._ui.checkbtn_AutoCarrot = UI.getChildControl(self._ui.static_InfoBg, "CheckButton_AutoCarrot")
  self._ui.staticText_AutoCarrot = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AutoCarrot")
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
  self._ui.static_RightBg = UI.getChildControl(Panel_Window_ServantInfo, "Static_RightBg")
  self._ui.static_RightText = UI.getChildControl(self._ui.static_RightBg, "Static_RightText")
  self._ui.list2_SkillList = UI.getChildControl(self._ui.static_RightBg, "List2_SkillList")
  self._ui.list2_SkillList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_HorseInfo_SkillList")
  self._ui.list2_SkillList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_1_Content = UI.getChildControl(self._ui.list2_SkillList, "List2_1_Content")
end
function Panel_Window_HorseInfo_info:updateBaseInfo()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  if servantInfo:getVehicleType() ~= CppEnums.VehicleType.Type_Horse then
    self._ui.staticText_Swift:SetShow(false)
    self._ui.static_SexIcon:SetShow(false)
  else
    if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse and 9 ~= servantInfo:getTier() and false == servantInfo:isPcroomOnly() and isContentsStallionEnable then
      self._ui.staticText_Swift:SetShow(true)
      local isStallion = servantInfo:isStallion()
      if true == isStallion then
        self._ui.staticText_Swift:SetMonoTone(false)
      else
        self._ui.staticText_Swift:SetMonoTone(true)
      end
    else
      self._ui.staticText_Swift:SetShow(false)
    end
    self._ui.static_SexIcon:SetShow(true)
    if servantInfo:isMale() then
      self._ui.static_SexIcon:ChangeTextureInfoName(self._textureSex.sexIcon)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon, self._textureSex.male.x1, self._textureSex.male.y1, self._textureSex.male.x2, self._textureSex.male.y2)
      self._ui.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_SexIcon:setRenderTexture(self._ui.static_SexIcon:getBaseTexture())
    else
      self._ui.static_SexIcon:ChangeTextureInfoName(self._textureSex.sexIcon)
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_SexIcon, self._textureSex.female.x1, self._textureSex.female.y1, self._textureSex.female.x2, self._textureSex.female.y2)
      self._ui.static_SexIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.static_SexIcon:setRenderTexture(self._ui.static_SexIcon:getBaseTexture())
    end
  end
  self._ui.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel() .. " " .. servantInfo:getName()))
  self._ui.static_Image:SetShow(true)
  self._ui.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  expNow = Int64toInt32(servantInfo:getExp_s64())
  expMax = Int64toInt32(servantInfo:getNeedExp_s64())
  self._ui.staticText_EXPVal:SetText(makeDotMoney(servantInfo:getExp_s64()) .. " / " .. makeDotMoney(servantInfo:getNeedExp_s64()))
  self._ui.progress2_EXP:SetProgressRate(expNow * 100 / expMax)
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
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
    self._ui.staticText_Tier:SetShow(true)
    if 9 == servantInfo:getTier() then
      self._ui.staticText_Tier:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
    else
      self._ui.staticText_Tier:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantInfo:getTier()))
    end
  else
    self._ui.staticText_Tier:SetShow(false)
  end
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
  local descText2 = ""
  local descValue = ""
  local descValue2 = ""
  if servantInfo:doMating() and 9 ~= servantInfo:getTier() then
    local matingCount = servantInfo:getMatingCount()
    descText = "" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_INFO_MATINGCOUNT")
    if servantInfo:doClearCountByMating() then
      descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
    else
      descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
    end
    self._ui.staticText_Mating:SetShow(true)
    self._ui.staticText_MatingVal:SetShow(true)
    self._ui.staticText_MatingVal:SetText(matingCount)
  else
    self._ui.staticText_Mating:SetShow(false)
    self._ui.staticText_MatingVal:SetShow(false)
  end
  local deadCount = servantInfo:getDeadCount()
  self._ui.staticText_DeadVal:SetText(deadCount)
  descText2 = descText .. PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_KILLCOUNT")
  if servantInfo:doClearCountByDead() then
    descValue2 = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
  else
    descValue2 = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
  end
  if "" == descText then
    self._ui.staticText_Desc:SetShow(false)
  else
    self._ui.staticText_Desc:SetShow(true)
    self._ui.staticText_Desc:SetText(descText)
  end
  if "" == descText2 then
    self._ui.staticText_Desc2:SetShow(false)
  else
    self._ui.staticText_Desc2:SetShow(true)
    self._ui.staticText_Desc2:SetText(descText2)
  end
  if "" == descValue then
    self._ui.staticText_DescValue:SetShow(false)
  else
    self._ui.staticText_DescValue:SetShow(true)
    self._ui.staticText_DescValue:SetText(descValue)
  end
  if "" == descValue2 then
    self._ui.staticText_DescValue1:SetShow(false)
  else
    self._ui.staticText_DescValue1:SetShow(true)
    self._ui.staticText_DescValue1:SetText(descValue2)
  end
  self._ui.staticText_Stamping:SetShow(false)
  self._ui.staticText_StampingVal:SetShow(false)
  if servantInfo:isImprint() then
    self._ui.staticText_Stamping:SetShow(true)
    self._ui.staticText_StampingVal:SetShow(true)
    self._ui.staticText_StampingVal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTING"))
  else
    self._ui.staticText_Stamping:SetShow(true)
    self._ui.staticText_StampingVal:SetShow(true)
    self._ui.staticText_StampingVal:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_ISIMPRINTPOSSIBLE"))
  end
end
function Panel_Window_HorseInfo_info:updateHp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_HPVal:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.progress2_HP:SetProgressRate(servantInfo:getHp() * 100 / servantInfo:getMaxHp())
end
function Panel_Window_HorseInfo_info:updateMp()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  self._ui.staticText_SPVal:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.progress2_SP:SetProgressRate(servantInfo:getMp() * 100 / servantInfo:getMaxMp())
end
function Panel_Window_HorseInfo_info:updateEquip()
  local servantInfo
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local isVehicleType = servantInfo:getVehicleType()
  if CppEnums.VehicleType.Type_Elephant == isVehicleType then
    for key, value in pairs(self._equipSlotNo) do
      self._ui.equipSlot[value].check:SetShow(false)
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      self._ui.equipOverfitSlot[value].check:SetShow(false)
    end
  else
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
  end
  if nil ~= servantInfo then
    for key, value in pairs(self._equipSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantInfo:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipSlot[value].check:SetCheck(not isCheck)
      if CppEnums.VehicleType.Type_Horse == isVehicleType and 12 == value then
        self._ui.equipSlot[value].check:SetShow(false)
      end
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantInfo:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipOverfitSlot[value].check:SetCheck(not isCheck)
    end
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
function Panel_Window_HorseInfo_info:updateSkill()
  local toIndex = 0
  local scrollvalue = 0
  local vscroll = self._ui.list2_SkillList:GetVScroll()
  local hscroll = self._ui.list2_SkillList:GetHScroll()
  toIndex = self._ui.list2_SkillList:getCurrenttoIndex()
  if false == self._ui.list2_SkillList:IsIgnoreVerticalScroll() then
    scrollvalue = vscroll:GetControlPos()
  elseif false == self._ui.list2_SkillList:IsIgnoreHorizontalScroll() then
    scrollvalue = hscroll:GetControlPos()
  end
  self._ui.list2_SkillList:getElementManager():clearKey()
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
  self._ui.list2_SkillList:setCurrenttoIndex(toIndex)
  if false == self._ui.list2_SkillList:IsIgnoreVerticalScroll() then
    vscroll:SetControlPos(scrollvalue)
  elseif false == self._ui.list2_SkillList:IsIgnoreHorizontalScroll() then
    hscroll:SetControlPos(scrollvalue)
  end
end
function Panel_Window_HorseInfo_info:changeEquip(slotNo)
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
function Panel_Window_HorseInfo_info:updateContent()
  self:updateHp()
  self:updateMp()
  self:updateBaseInfo()
  self:updateEquip()
  self:updateSkill()
end
function Panel_Window_HorseInfo_info:open()
  Panel_Window_ServantInfo:SetShow(true)
end
function Panel_Window_HorseInfo_info:close()
  Panel_Window_ServantInfo:SetShow(false)
end
function PaGlobalFunc_HorseInfo_GetShow()
  return Panel_Window_ServantInfo:GetShow()
end
function PaGlobalFunc_HorseInfo_Open()
  local self = Panel_Window_HorseInfo_info
  local selfPlayer = getSelfPlayer()
  local selfProxy = selfPlayer:get()
  if nil == selfProxy then
    return
  end
  local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
  local vehicleProxy = getVehicleActor(actorKeyRaw)
  if nil == vehicleProxy then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HORSEINFO_HORSEINFOALERTMSG"))
    return
  end
  local vehicleType = vehicleProxy:get():getVehicleType()
  if false == ToClient_isCheckRenderModeGame() then
    return
  end
  if CppEnums.VehicleType.Type_Horse == vehicleType or CppEnums.VehicleType.Type_Camel == vehicleType or CppEnums.VehicleType.Type_Donkey == vehicleType or CppEnums.VehicleType.Type_Elephant == vehicleType or CppEnums.VehicleType.Type_RidableBabyElephant == vehicleType then
    PaGlobalFunc_HorseInfo_Show(actorKeyRaw)
  end
end
function PaGlobalFunc_HorseInfo_Close()
  local self = Panel_Window_HorseInfo_info
  self:close()
end
function PaGlobalFunc_HorseInfo_Show(actorKeyRaw)
  local self = Panel_Window_HorseInfo_info
  self._value.actorKeyRaw = actorKeyRaw
  self:updateContent()
  self:open()
end
function PaGlobalFunc_HorseInfo_Exit()
  local self = Panel_Window_HorseInfo_info
  TooltipSimple_Hide()
  self:close()
end
function PaGlobalFunc_HorseInfo_Update()
  local self = Panel_Window_HorseInfo_info
  self:updateContent()
end
function PaGlobalFunc_HorseInfo_UpdateHp()
  local self = Panel_Window_HorseInfo_info
  self:updateHp()
end
function PaGlobalFunc_HorseInfo_UpdateMp()
  local self = Panel_Window_HorseInfo_info
  self:updateMp()
end
function PaGlobalFunc_HorseInfo_UpdateEquipMent()
  local self = Panel_Window_HorseInfo_info
  self:updateEquip()
end
function PaGlobalFunc_HorseInfo_ChangequipMent(slotNo)
  local self = Panel_Window_HorseInfo_info
  self:changeEquip(slotNo)
end
function PaGlobalFunc_HorseInfo_SkillList(list_content, key)
  local self = Panel_Window_HorseInfo_info
  local id = Int64toInt32(key)
  if nil == self._value.actorKeyRaw then
    return
  end
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local button_SkillBg = UI.getChildControl(list_content, "Button_SkillBg")
  local skillWrapper = servantInfo:getSkill(id)
  if nil == skillWrapper then
    button_SkillBg:addInputEvent("Mouse_On", "")
    return
  end
  local button_SkillBg = UI.getChildControl(list_content, "Button_SkillBg")
  local static_SkillIcon = UI.getChildControl(list_content, "Static_SkillIcon")
  local circularProgress_Train = UI.getChildControl(list_content, "CircularProgress_Train")
  local staticText_Name = UI.getChildControl(list_content, "StaticText_Name")
  local staticText_Command = UI.getChildControl(list_content, "StaticText_Command")
  local static_PrecedenceIcon = UI.getChildControl(list_content, "Static_PrecedenceIcon")
  static_SkillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  staticText_Name:SetText(skillWrapper:getName())
  local expTxt = tonumber(string.format("%.0f", servantInfo:getSkillExp(id) / (skillWrapper:get()._maxExp / 100)))
  if expTxt >= 100 then
    expTxt = 100
  end
  circularProgress_Train:SetProgressRate(expTxt)
  staticText_Command:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_Command:SetText(skillWrapper:getDescription())
  local predece = skillWrapper:getConditionDescription()
  static_PrecedenceIcon:SetShow(false)
  button_SkillBg:addInputEvent("Mouse_On", "PaGlobalFunc_HorseInfo_Simpletooltips(false," .. id .. ")")
  if "" ~= predece then
    button_SkillBg:addInputEvent("Mouse_On", "PaGlobalFunc_HorseInfo_Simpletooltips(true," .. id .. ")")
    static_PrecedenceIcon:SetShow(true)
  end
  if staticText_Command:IsLimitText() then
    _button_SkillBgIdTable[id] = button_SkillBg
    button_SkillBg:addInputEvent("Mouse_On", "Input_HorseInfo_FloatingTooltip(" .. id .. ")")
  end
end
function PaGlobalFunc_HorseInfo_Simpletooltips(isShow, idx, list_content)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = Panel_Window_HorseInfo_info
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local name, desc, control
  local skillWrapper = servantInfo:getSkill(idx)
  if nil == skillWrapper then
    return
  end
  local index = self._ui.list2_SkillList:getIndexByKey(idx)
  local pos = {
    x = self._size.tooltipStartPosX,
    y = self._size.tooltipStartPosY + index * self._size.contentSizeY
  }
  if nil ~= skillWrapper then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_NEEDSKILLTITLE")
    desc = skillWrapper:getConditionDescription()
    TooltipSimple_ShowSetSetPos_Console(pos, name, desc)
  end
end
function Input_HorseInfo_FloatingTooltip(id)
  local self = Panel_Window_HorseInfo_info
  local servantInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == servantInfo then
    return
  end
  local desc, control
  local skillWrapper = servantInfo:getSkill(id)
  if nil == skillWrapper then
    return
  end
  desc = skillWrapper:getDescription()
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.PlainText, desc, Defines.TooltipTargetType.PlainText, _button_SkillBgIdTable[id])
end
function PaGlobalFunc_HorseInfo_CheckToggleAutoCarrot()
  local self = Panel_Window_HorseInfo_info
  if false == self._ui.checkbtn_AutoCarrot:IsCheck() then
    self._ui.checkbtn_AutoCarrot:SetCheck(true)
  else
    self._ui.checkbtn_AutoCarrot:SetCheck(false)
  end
  FGlobal_ToggleServantAutoCarrot_PadInput()
end
function PaGlobalFunc_HorseInfo_GetIsCheckAutoCarrot()
  local self = Panel_Window_HorseInfo_info
  if nil == self._ui.checkbtn_AutoCarrot then
    return true
  end
  return self._ui.checkbtn_AutoCarrot:IsCheck()
end
function FromClient_HorseInfo_Init()
  local self = Panel_Window_HorseInfo_info
  self:initialize()
end
function FromClient_HorseInfo_Resize()
  local self = Panel_Window_HorseInfo_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_HorseInfo_Init")
