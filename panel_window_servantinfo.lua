Panel_Window_ServantInfo:SetShow(false, false)
Panel_Window_ServantInfo:ActiveMouseEventEffect(true)
Panel_Window_ServantInfo:SetDragEnable(true)
Panel_Window_ServantInfo:setGlassBackground(true)
Panel_Window_ServantInfo:RegisterShowEventFunc(true, "ServantInfoShowAni()")
Panel_Window_ServantInfo:RegisterShowEventFunc(false, "ServantInfoHideAni()")
Panel_Window_ServantInfo:RegisterUpdateFunc("ServantInfoUpdate")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local UI_VT = CppEnums.VehicleType
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
function ServantInfoShowAni()
  UIAni.fadeInSCR_Right(Panel_Window_ServantInfo)
  audioPostEvent_SystemUi(1, 0)
end
function ServantInfoHideAni()
  Panel_Window_ServantInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_ServantInfo:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  audioPostEvent_SystemUi(1, 1)
end
local servantInfo = {
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
      12,
      14,
      15,
      16,
      17
    },
    _slotID = {
      [3] = "equipIcon_helm",
      [4] = "equipIcon_upperArmor",
      [5] = "equipIcon_upperArmor2",
      [6] = "equipIcon_stirrups",
      [12] = "equipIcon_foot",
      [14] = "equipIcon_AvatarHelm",
      [15] = "equipIcon_AvatarUpperArmor",
      [16] = "equipIcon_AvatarUpperArmor2",
      [17] = "equipIcon_AvatarStirrups"
    },
    _slotEmptyBG = {
      [3] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_helm"),
      [4] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_upperArmor"),
      [5] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_upperArmor2"),
      [6] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_stirrups"),
      [12] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_foot"),
      [14] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_AvatarHelm"),
      [15] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_AvatarUpperArmor"),
      [16] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_AvatarUpperArmor2"),
      [17] = UI.getChildControl(Panel_Window_ServantInfo, "equipIconEmpty_AvatarStirrups")
    },
    _checkButtonID = {
      [3] = "CheckButton_EquipSlot_Helm",
      [4] = "CheckButton_EquipSlot_upperAmor",
      [5] = "CheckButton_EquipSlot_upperAmor2",
      [6] = "CheckButton_EquipSlot_stirrups",
      [12] = "CheckButton_EquipSlot_foot",
      [14] = "CheckButton_EquipSlot_AvatarHelm",
      [15] = "CheckButton_EquipSlot_AvatarUpperAmor",
      [16] = "CheckButton_EquipSlot_AvatarUpperAmor2",
      [17] = "CheckButton_EquipSlot_AvatarStirrups"
    },
    _checkFlag = {
      [3] = 1,
      [4] = 2,
      [5] = 4,
      [6] = 8,
      [12] = 0,
      [14] = 16,
      [15] = 32,
      [16] = 64,
      [17] = 128
    },
    _slotText = {
      [3] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_3"),
      [4] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_4"),
      [5] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_5"),
      [6] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_6"),
      [12] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_12"),
      [14] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_14"),
      [15] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_15"),
      [16] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_16"),
      [17] = PAGetString(Defines.StringSheet_GAME, "Lua_ServantInfo_Horse_Armor_17")
    },
    _skill = {
      startX = 5,
      startY = 10,
      startIconX = 10,
      startIconY = 5,
      startNameX = 65,
      startNameY = 3,
      startDecX = 65,
      startDecY = 27,
      startPreDecX = 64,
      startPreDecY = 45,
      startExpBGX = 4,
      startExpBGY = -1,
      startExpX = 6,
      startExpY = 1,
      startExpStrX = 18,
      startExpStrY = 35,
      gapY = 58,
      count = 3
    }
  },
  _buttonClose = UI.getChildControl(Panel_Window_ServantInfo, "close_button"),
  _buttonQuestion = UI.getChildControl(Panel_Window_ServantInfo, "Button_Question"),
  _staticIconMale = UI.getChildControl(Panel_Window_ServantInfo, "Static_MaleIcon"),
  _staticIconFemale = UI.getChildControl(Panel_Window_ServantInfo, "Static_FemaleIcon"),
  _staticNameTitle = UI.getChildControl(Panel_Window_ServantInfo, "horse_name"),
  _staticName = UI.getChildControl(Panel_Window_ServantInfo, "horse_name_value"),
  _staticGrade = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Grade"),
  _lv = UI.getChildControl(Panel_Window_ServantInfo, "Lv"),
  _staticLevel = UI.getChildControl(Panel_Window_ServantInfo, "Level_value"),
  _staticGaugeBar_Hp = UI.getChildControl(Panel_Window_ServantInfo, "HP_GaugeBar"),
  _staticTextValue_Hp = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_HP_Value"),
  _mp = UI.getChildControl(Panel_Window_ServantInfo, "MP"),
  _staticGaugeBar_Mp = UI.getChildControl(Panel_Window_ServantInfo, "MP_GaugeBar"),
  _staticTextValue_Mp = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_MP_Value"),
  _exp = UI.getChildControl(Panel_Window_ServantInfo, "EXP"),
  _staticGaugeBar_ExpBG = UI.getChildControl(Panel_Window_ServantInfo, "EXP_Gauge_Back"),
  _staticGaugeBar_Exp = UI.getChildControl(Panel_Window_ServantInfo, "EXP_GaugeBar"),
  _staticTextValue_Exp = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_EXP_Value"),
  _weight = UI.getChildControl(Panel_Window_ServantInfo, "Weight"),
  _staticGaugeBar_WeightBG = UI.getChildControl(Panel_Window_ServantInfo, "Static_Texture_Weight_Background"),
  _staticGaugeBar_Weight = UI.getChildControl(Panel_Window_ServantInfo, "Weight_Gauge"),
  _staticTextValue_Weight = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Weight_Value"),
  _staticText_MaxMoveSpeedValue = UI.getChildControl(Panel_Window_ServantInfo, "MaxMoveSpeedValue"),
  _staticText_AccelerationValue = UI.getChildControl(Panel_Window_ServantInfo, "AccelerationValue"),
  _staticText_CorneringSpeedValue = UI.getChildControl(Panel_Window_ServantInfo, "CorneringSpeedValue"),
  _staticText_BrakeSpeedValue = UI.getChildControl(Panel_Window_ServantInfo, "BrakeSpeedValue"),
  _staticText_Life = UI.getChildControl(Panel_Window_ServantInfo, "category_Life"),
  _staticText_LifeValue = UI.getChildControl(Panel_Window_ServantInfo, "category_LifeValue"),
  _staticText_Title_Def = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_Defence"),
  _staticText_Value_Def = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_DefenceValue"),
  _staticSkilltitle = UI.getChildControl(Panel_Window_ServantInfo, "category_skillList"),
  _staticSkillBG = UI.getChildControl(Panel_Window_ServantInfo, "panel_skillInfo"),
  _skillScroll = UI.getChildControl(Panel_Window_ServantInfo, "skill_scroll"),
  deadCountTitle = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_DeadCount"),
  deadCountValue = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_DeadCountValue"),
  _staticMatingCount = UI.getChildControl(Panel_Window_ServantInfo, "Static_MatingCount"),
  _staticMatingCountValue = UI.getChildControl(Panel_Window_ServantInfo, "Static_MatingCountValue"),
  _iconStallion = UI.getChildControl(Panel_Window_ServantInfo, "Static_iconStallion"),
  _rentEndTime = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_RentEndTime"),
  _skillStart = 0,
  _skillCount = 0,
  _actorKeyRaw = nil,
  _armorName = Array.new(),
  _itemSlots = Array.new(),
  _skillSlots = Array.new(),
  _checkButton = Array.new(),
  _prevCheckButton = Array.new(),
  _functionGet = nil,
  babyElephant_Warning = UI.getChildControl(Panel_Window_ServantInfo, "Static_BabyElephantTooltip"),
  _extendedSlotInfoArray = {}
}
servantInfo._iconStallion:addInputEvent("Mouse_On", "ServantInfo_StallionToolTip( true )")
servantInfo._iconStallion:addInputEvent("Mouse_Out", "ServantInfo_StallionToolTip( false )")
function servantInfo:init()
  self._skillScroll:SetControlPos(0)
  self._iconStallion:SetShow(false)
  for index, value in pairs(self._config._slotNo) do
    local slot = {}
    slot.icon = UI.getChildControl(Panel_Window_ServantInfo, self._config._slotID[value])
    SlotItem.new(slot, "ServantInfoEquipment_" .. value, value, Panel_Window_ServantInfo, self._config._itemSlot)
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "ServantInfo_RClick(" .. value .. ")")
    slot.icon:addInputEvent("Mouse_LUp", "ServantInfo_LClick(" .. value .. ")")
    slot.icon:addInputEvent("Mouse_On", "ServantInfo_EquipItem_MouseOn(" .. value .. ", true)")
    slot.icon:addInputEvent("Mouse_Out", "ServantInfo_EquipItem_MouseOn(" .. value .. ", false)")
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._itemSlots[value] = slot
    self._armorName[value] = UI.getChildControl(Panel_Window_ServantInfo, "StaticText_ArmorName" .. index)
    self._checkButton[value] = UI.getChildControl(Panel_Window_ServantInfo, self._config._checkButtonID[value])
    self._checkButton[value]:addInputEvent("Mouse_LUp", "ServantInfo_VehicleEquipSlot_LClick(" .. value .. ")")
  end
  self._checkButton[12]:SetShow(false)
  for ii = 0, self._config._skill.count - 1 do
    local slot = {}
    slot.button = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "skill_static", self._staticSkillBG, "ServantInfo_Skill_" .. ii)
    slot.expBG = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "Static_Texture_Learn_Background", slot.button, "ServantInfo_Skill_ExpBG_" .. ii)
    slot.exp = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "SkillLearn_Gauge", slot.button, "ServantInfo_Skill_Exp_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "skill_icon", slot.button, "ServantInfo_Skill_Icon_" .. ii)
    slot.expText = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "SkillLearn_PercentString", slot.button, "ServantInfo_Skill_ExpStr_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "skill_name", slot.button, "ServantInfo_Skill_Name_" .. ii)
    slot.dec = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "skill_condition", slot.button, "ServantInfo_Skill_Dec_" .. ii)
    slot.predec = UI.createAndCopyBasePropertyControl(Panel_Window_ServantInfo, "skill_precondition", slot.button, "ServantInfo_Skill_PreDec_" .. ii)
    slot.name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    slot.dec:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    slot.dec:setLineCountByLimitAutoWrap(2)
    local skillConfig = self._config._skill
    slot.button:SetPosX(skillConfig.startX)
    slot.button:SetPosY(skillConfig.startY + skillConfig.gapY * ii)
    slot.expBG:SetPosX(skillConfig.startExpBGX)
    slot.expBG:SetPosY(skillConfig.startExpBGY)
    slot.exp:SetPosX(skillConfig.startExpX)
    slot.exp:SetPosY(skillConfig.startExpY)
    slot.icon:SetPosX(skillConfig.startIconX)
    slot.icon:SetPosY(skillConfig.startIconY)
    slot.expText:SetPosX(skillConfig.startExpStrX)
    slot.expText:SetPosY(skillConfig.startExpStrY)
    slot.name:SetPosX(skillConfig.startNameX)
    slot.name:SetPosY(skillConfig.startNameY)
    slot.dec:SetPosX(skillConfig.startDecX)
    slot.dec:SetPosY(skillConfig.startDecY)
    slot.predec:SetPosX(skillConfig.startPreDecX)
    slot.predec:SetPosY(skillConfig.startPreDecY)
    slot.name:addInputEvent("Mouse_UpScroll", "ServantInfo_ScrollEvent( true )")
    slot.name:addInputEvent("Mouse_DownScroll", "ServantInfo_ScrollEvent( false )")
    slot.icon:addInputEvent("Mouse_UpScroll", "ServantInfo_ScrollEvent( true )")
    slot.icon:addInputEvent("Mouse_DownScroll", "ServantInfo_ScrollEvent( false )")
    slot.predec:addInputEvent("Mouse_UpScroll", "ServantInfo_ScrollEvent( true )")
    slot.predec:addInputEvent("Mouse_DownScroll", "ServantInfo_ScrollEvent( false )")
    UIScroll.InputEventByControl(slot.button, "ServantInfo_ScrollEvent")
    self._skillSlots[ii] = slot
  end
  if self._exp:GetPosX() + self._exp:GetTextSizeX() > self._staticGaugeBar_ExpBG:GetPosX() then
    self._exp:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self._exp:SetText(self._exp:GetText())
    self._exp:addInputEvent("Mouse_On", "ServantInfoLimitTextTooltip(true, 0)")
    self._exp:addInputEvent("Mouse_Out", "ServantInfoLimitTextTooltip()")
  end
  if self.deadCountTitle:GetPosX() + self.deadCountTitle:GetTextSizeX() > self.deadCountValue:GetPosX() then
    self.deadCountTitle:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self.deadCountTitle:SetText(self.deadCountTitle:GetText())
    self.deadCountTitle:addInputEvent("Mouse_On", "ServantInfoLimitTextTooltip(true, 2)")
    self.deadCountTitle:addInputEvent("Mouse_Out", "ServantInfoLimitTextTooltip()")
  end
  self._staticTextValue_Hp:SetPosY(self._staticGaugeBar_Hp:GetPosY() + (self._staticGaugeBar_Hp:GetSizeY() - self._staticTextValue_Hp:GetTextSizeY()) * 0.5)
  self._staticTextValue_Mp:SetPosY(self._staticGaugeBar_Mp:GetPosY() + (self._staticGaugeBar_Mp:GetSizeY() - self._staticTextValue_Mp:GetTextSizeY()) * 0.5)
  self._staticTextValue_Exp:SetPosY(self._staticGaugeBar_Exp:GetPosY() + (self._staticGaugeBar_Exp:GetSizeY() - self._staticTextValue_Exp:GetTextSizeY()) * 0.5)
  self._staticTextValue_Weight:SetPosY(self._staticGaugeBar_Weight:GetPosY() + (self._staticGaugeBar_Weight:GetSizeY() - self._staticTextValue_Weight:GetTextSizeY()) * 0.5)
end
function servantInfo:clear()
  self._skillStart = 0
  self._skillCount = 0
end
function ServantInfo_UpdateHp()
  if false == Panel_Window_ServantInfo:GetShow() then
    return
  end
  local self = servantInfo
  self:updateHp()
end
function ServantInfo_UpdateMp()
  if false == Panel_Window_ServantInfo:GetShow() then
    return
  end
  local self = servantInfo
  self:updateMp()
end
function servantInfo:updateHp()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  self._staticGaugeBar_Hp:SetSize(1.63 * (servantWrapper:getHp() / servantWrapper:getMaxHp() * 100), 6)
  self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
end
function servantInfo:updateMp()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  self._staticGaugeBar_Mp:SetSize(1.63 * (servantWrapper:getMp() / servantWrapper:getMaxMp() * 100), 6)
  self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))
end
function servantInfo:getExtendedSlotCountUpdateInfo(itemWrapper, SlotNo)
  local itemSSW = itemWrapper:getStaticStatus()
  local slotNoMax = itemSSW:getExtendedSlotCount()
  local _extendedCount = 0
  for index = 1, slotNoMax do
    local extendSlotNo = itemSSW:getExtendedSlotIndex(index - 1)
    if slotNoMax ~= extendSlotNo then
      servantInfo._extendedSlotInfoArray[extendSlotNo] = SlotNo
      _extendedCount = _extendedCount + 1
    end
  end
  return _extendedCount
end
function servantInfo:update()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local isVehicleType = servantWrapper:getVehicleType()
  for index, value in pairs(self._config._slotNo) do
    if CppEnums.VehicleType.Type_Elephant == isVehicleType then
      self._checkButton[value]:SetShow(false)
    else
      self._checkButton[value]:SetShow(true)
    end
  end
  self._checkButton[12]:SetShow(false)
  self._staticGaugeBar_Exp:SetShow(false)
  self._staticTextValue_Exp:SetShow(false)
  self._staticGaugeBar_Weight:SetShow(false)
  self._staticTextValue_Weight:SetShow(false)
  self._staticText_Life:SetShow(false)
  self._staticText_LifeValue:SetShow(false)
  self._staticMatingCount:SetShow(false)
  self._staticMatingCountValue:SetShow(false)
  self._staticGaugeBar_ExpBG:SetShow(false)
  self._staticGaugeBar_WeightBG:SetShow(false)
  self._exp:SetShow(false)
  self._weight:SetShow(false)
  self._lv:SetShow(false)
  self._staticLevel:SetShow(false)
  self._iconStallion:SetShow(false)
  self._rentEndTime:SetShow(false)
  if CppEnums.VehicleType.Type_Elephant ~= servantWrapper:getVehicleType() then
    self._staticGaugeBar_Exp:SetShow(true)
    self._staticTextValue_Exp:SetShow(true)
    self._staticGaugeBar_Weight:SetShow(true)
    self._staticTextValue_Weight:SetShow(true)
    self._staticText_Life:SetShow(true)
    self._staticText_LifeValue:SetShow(true)
    if 9 ~= servantWrapper:getTier() then
      self._staticMatingCount:SetShow(true)
      self._staticMatingCountValue:SetShow(true)
    else
      self._staticMatingCount:SetShow(false)
      self._staticMatingCountValue:SetShow(false)
    end
    self._staticGaugeBar_ExpBG:SetShow(true)
    self._staticGaugeBar_WeightBG:SetShow(true)
    self._exp:SetShow(true)
    self._weight:SetShow(true)
    self._lv:SetShow(true)
    self._staticLevel:SetShow(true)
  end
  self._staticName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._staticName:SetText(servantWrapper:getName())
  if true == self._staticName:IsLimitText() then
    self._staticName:addInputEvent("Mouse_On", "ServantInfoLimitTextTooltip(true, 3)")
    self._staticName:addInputEvent("Mouse_Out", "ServantInfoLimitTextTooltip()")
  end
  self._staticLevel:SetPosX(self._lv:GetPosX() + self._lv:GetTextSizeX() + 5)
  self._staticLevel:SetText(tostring(servantWrapper:getLevel()))
  if CppEnums.VehicleType.Type_Horse == servantWrapper:getVehicleType() then
    if 9 == servantWrapper:getTier() then
      self._staticGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9"))
      self._iconStallion:SetShow(false)
    else
      self._staticGrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANT_TIER", "tier", servantWrapper:getTier()) .. "(<PAColor0xFF0FBFFF>?<PAOldColor>)")
      if false == servantWrapper:isPcroomOnly() and isContentsStallionEnable then
        local isStallion = servantWrapper:isStallion()
        self._iconStallion:SetShow(true)
        if true == isStallion then
          self._iconStallion:SetMonoTone(false)
        else
          self._iconStallion:SetMonoTone(true)
        end
        self._staticGrade:SetPosX(self._iconStallion:GetPosX() + self._iconStallion:GetSizeX())
      else
        self._iconStallion:SetShow(false)
      end
    end
    self._staticGrade:SetShow(true)
  else
    self._staticGrade:SetShow(false)
  end
  if CppEnums.VehicleType.Type_Elephant == servantWrapper:getVehicleType() then
    self._mp:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANTINFO_ELEPHANT_MP"))
  else
    self._mp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEMP_NAME"))
  end
  self._staticGaugeBar_Hp:SetSize(1.63 * (servantWrapper:getHp() / servantWrapper:getMaxHp() * 100), 6)
  self._staticTextValue_Hp:SetText(makeDotMoney(servantWrapper:getHp()) .. " / " .. makeDotMoney(servantWrapper:getMaxHp()))
  self._staticGaugeBar_Mp:SetSize(1.63 * (servantWrapper:getMp() / servantWrapper:getMaxMp() * 100), 6)
  self._staticTextValue_Mp:SetText(makeDotMoney(servantWrapper:getMp()) .. " / " .. makeDotMoney(servantWrapper:getMaxMp()))
  self._staticGaugeBar_Exp:SetSize(163 * Int64toInt32(servantWrapper:getExp_s64()) / Int64toInt32(servantWrapper:getNeedExp_s64()), 6)
  self._staticTextValue_Exp:SetText(makeDotMoney(servantWrapper:getExp_s64()) .. " / " .. makeDotMoney(servantWrapper:getNeedExp_s64()))
  local max_weight = Int64toInt32(servantWrapper:getMaxWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32((servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64()) / Defines.s64_const.s64_10000)
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
  self._staticTextValue_Weight:SetPosY(self._staticGaugeBar_Weight:GetPosY() + self._staticGaugeBar_Weight:GetSizeY() / 2 - self._staticTextValue_Weight:GetTextSizeY() / 2)
  local deadCount = servantWrapper:getDeadCount()
  local deadCountText = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANTINFO_DEADCOUNT")
  if CppEnums.VehicleType.Type_Elephant == servantWrapper:getVehicleType() then
    deadCountText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDSERVANTINFO_INJURY")
    deadCount = deadCount * 10 .. "%"
  end
  self.deadCountTitle:SetText(deadCountText)
  self.deadCountValue:SetText(deadCount)
  local matingCount = servantWrapper:getMatingCount()
  self._staticMatingCountValue:SetText(matingCount)
  local matingCountPosX = self._staticMatingCount:GetPosX()
  local matingCountTextX = self._staticMatingCount:GetTextSizeX()
  local matingCountValuePosX = self._staticMatingCountValue:GetPosX()
  if matingCountValuePosX < matingCountPosX + matingCountTextX then
  end
  self._staticText_MaxMoveSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._staticText_AccelerationValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._staticText_CorneringSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._staticText_BrakeSpeedValue:SetText(string.format("%.1f", servantWrapper:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  local vehicleInfo = getVehicleActor(self._actorKeyRaw)
  if nil ~= vehicleInfo then
    self._staticText_Value_Def:SetText(vehicleInfo:get():getEquipment():getDefense())
    self._staticText_Title_Def:SetSpanSize(self._staticText_Value_Def:GetTextSizeX() + 25, 58)
  end
  if self._staticText_Life:GetPosX() + self._staticText_Life:GetTextSizeX() > self._staticText_LifeValue:GetPosX() then
    self._staticText_Life:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self._staticText_Life:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFE"))
    self._staticText_Life:addInputEvent("Mouse_On", "ServantInfoLimitTextTooltip(true,1)")
    self._staticText_Life:addInputEvent("Mouse_Out", "ServantInfoLimitTextTooltip()")
  end
  if servantWrapper:isPeriodLimit() then
    self._staticText_LifeValue:SetText(convertStringFromDatetime(servantWrapper:getExpiredTime()))
    self._staticText_LifeValue:SetShow(true)
  elseif CppEnums.VehicleType.Type_Elephant ~= servantWrapper:getVehicleType() then
    self._staticText_LifeValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
    self._staticText_LifeValue:SetShow(true)
  end
  self._staticIconMale:SetShow(false)
  self._staticIconFemale:SetShow(false)
  if servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Horse then
    if servantWrapper:isMale() then
      self._staticIconMale:SetPosX(self._staticNameTitle:GetPosX() + self._staticNameTitle:GetTextSizeX() + 10)
      self._staticIconMale:SetShow(true)
      self._staticName:SetPosX(self._staticIconMale:GetPosX() + self._staticIconMale:GetSizeX() + 3)
    else
      self._staticIconFemale:SetPosX(self._staticNameTitle:GetPosX() + self._staticNameTitle:GetTextSizeX() + 5)
      self._staticIconFemale:SetShow(true)
      self._staticName:SetPosX(self._staticIconFemale:GetPosX() + self._staticIconFemale:GetSizeX() + 3)
    end
  end
  servantInfo._extendedSlotInfoArray = {}
  local _extendedCount = 0
  for index, value in pairs(servantInfo._config._slotNo) do
    local slot = servantInfo._itemSlots[value]
    local slotText = servantInfo._armorName[value]
    local itemWrapper = servantWrapper:getEquipItem(value)
    if nil ~= itemWrapper then
      _extendedCount = _extendedCount + servantInfo:getExtendedSlotCountUpdateInfo(itemWrapper, value)
      servantInfo:setItemInfoUseWrapper(slot, itemWrapper, false, false, value)
      servantInfo._config._slotEmptyBG[value]:SetShow(false)
    else
      slot:clearItem()
      servantInfo._config._slotEmptyBG[value]:SetShow(true)
    end
  end
  if _extendedCount > 0 then
    for extendSlotNo, parentSlotNo in pairs(servantInfo._extendedSlotInfoArray) do
      local itemWrapper = servantWrapper:getEquipItem(parentSlotNo)
      local setSlotBG = servantInfo._config._slotEmptyBG[extendSlotNo]
      slot = servantInfo._itemSlots[extendSlotNo]
      setSlotBG:SetShow(false)
      servantInfo:setItemInfoUseWrapper(slot, itemWrapper, true, true)
    end
  end
  self._skillCount = 0
  for ii = 0, self._config._skill.count - 1 do
    local slot = self._skillSlots[ii]
    slot.button:SetShow(false)
  end
  local slotNo = 0
  local skillCount = servantWrapper:getSkillCount()
  for ii = 1, skillCount - 1 do
    local skillWrapper = servantWrapper:getSkill(ii)
    if nil ~= skillWrapper and false == skillWrapper:isTrainingSkill() then
      if self._skillStart <= self._skillCount and slotNo < self._config._skill.count then
        local expTxt = math.floor(servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp / 100))
        if expTxt >= 100 then
          expTxt = 100
        end
        local slot = self._skillSlots[slotNo]
        slot.icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
        slot.icon:addInputEvent("Mouse_On", "PaGlobal_ServantInfo_SkillTooltip(" .. self._actorKeyRaw .. ", " .. ii .. ", " .. slotNo .. ")")
        slot.icon:addInputEvent("Mouse_Out", "PaGlobal_Tooltip_Servant_Close()")
        slot.name:SetText(skillWrapper:getName())
        if true == slot.name:IsLimitText() then
          slot.name:addInputEvent("Mouse_On", "ServantInfo_SkillNameLimitTooltip(true , " .. ii .. ", " .. slotNo .. ")")
          slot.name:addInputEvent("Mouse_Out", "ServantInfo_SkillNameLimitTooltip(false)")
        end
        slot.dec:SetText(skillWrapper:getDescription())
        slot.dec:SetIgnore(true)
        if true == slot.dec:IsLimitText() then
          slot.dec:SetIgnore(false)
          slot.dec:addInputEvent("Mouse_On", "HandleEventMOn_ServantInfo_SkillDescTooltip(true, " .. ii .. ", " .. slotNo .. ")")
          slot.dec:addInputEvent("Mouse_Out", "HandleEventMOn_ServantInfo_SkillDescTooltip(false)")
        end
        slot.predec:SetShow(false)
        if "" ~= skillWrapper:getConditionDescription() then
          slot.predec:SetShow(true)
          slot.predec:SetPosX(slot.name:GetPosX() + slot.name:GetTextSizeX() + 5)
          slot.predec:SetPosY(slot.name:GetPosY() + 2)
          slot.predec:addInputEvent("Mouse_On", "ServantInfo_Simpletooltips(true, " .. ii .. ", " .. slotNo .. ")")
          slot.predec:addInputEvent("Mouse_Out", "ServantInfo_Simpletooltips(false)")
        end
        slot.exp:SetProgressRate(servantWrapper:getSkillExp(ii) / (skillWrapper:get()._maxExp / 100))
        slot.exp:SetAniSpeed(0)
        slot.expText:SetText(expTxt .. "%")
        slot.button:SetShow(true)
        slotNo = slotNo + 1
      end
      self._skillCount = self._skillCount + 1
    end
  end
  self._staticSkilltitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SERVANTINFO_SKILLCOUNT", "servantSkillListCnt", self._skillCount))
  if CppEnums.VehicleType.Type_Horse == servantWrapper:getVehicleType() or CppEnums.VehicleType.Type_Donkey == servantWrapper:getVehicleType() then
    local myservantinfo = stable_getServantByServantNo(servantWrapper:getServantNo())
    local hasRentOwnerFlag = false
    local rentEndTime
    if nil ~= myservantinfo then
      hasRentOwnerFlag = Defines.s64_const.s64_0 < myservantinfo:getRentOwnerNo()
      rentEndTime = getTimeYearMonthDayHourMinSecByTTime64(myservantinfo:getRentEndDate())
    end
    if true == hasRentOwnerFlag then
      self._staticName:SetShow(false)
      self._staticNameTitle:SetShow(false)
      self._staticIconMale:SetShow(false)
      self._staticIconFemale:SetShow(false)
      self._rentEndTime:SetShow(true)
      self._rentEndTime:SetText(tostring(rentEndTime))
      self._rentEndTime:addInputEvent("Mouse_On", "ServantInfo_RentEndTimeTooltip(true,\"" .. tostring(rentEndTime) .. "\")")
      self._rentEndTime:addInputEvent("Mouse_Out", "ServantInfo_RentEndTimeTooltip(false)")
    end
  end
  UIScroll.SetButtonSize(self._skillScroll, self._config._skill.count, self._skillCount)
end
function servantInfo:setItemInfoUseWrapper(slot, itemWrapper, isMono, isExtended, slotNo)
  slot:setItem(itemWrapper, slotNo, true)
  slot.icon:SetEnable(false == isExtended)
  slot.icon:SetMonoTone(isMono)
end
function ServantInfo_RentEndTimeTooltip(isShow, rentEndTime)
  local self = servantInfo
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_SERVANTINFO_RENTENDTIME")
  desc = rentEndTime
  control = self._rentEndTime
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_ServantInfo_SkillTooltip(actorkeyRaw, ii, slotNo)
  local self = servantInfo
  PaGlobal_Tooltip_Servant_Open(actorkeyRaw, self._skillSlots[slotNo], ii)
end
function ServantInfoGradeTooltip(isShow)
  local self = servantInfo
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_GRADEINFO_TOOLTIP_TITLE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_GENERATIONDESC")
  control = self._staticGrade
  if isShow == true then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function ServantInfoLimitTextTooltip(isShow, index)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = servantInfo
  local name, desc, control
  if 0 == index then
    name = self._exp:GetText()
    desc = ""
    control = self._exp
  elseif 1 == index then
    name = self._staticText_Life:GetText()
    desc = ""
    control = self._staticText_Life
  elseif 2 == index then
    name = self.deadCountTitle:GetText()
    desc = ""
    control = self.deadCountTitle
  elseif 3 == index then
    name = self._staticName:GetText()
    desc = ""
    control = self._staticName
  end
  TooltipSimple_Show(control, name, desc)
end
function servantInfo:registEventHandler()
  self._buttonClose:addInputEvent("Mouse_LUp", "ServantInfo_Close()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelServantinfo\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelServantinfo\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelServantinfo\", \"false\")")
  self._staticGrade:addInputEvent("Mouse_On", "ServantInfoGradeTooltip( true )")
  self._staticGrade:addInputEvent("Mouse_Out", "ServantInfoGradeTooltip( false )")
  self._staticSkillBG:addInputEvent("Mouse_UpScroll", "ServantInfo_ScrollEvent( true )")
  self._staticSkillBG:addInputEvent("Mouse_DownScroll", "ServantInfo_ScrollEvent( false )")
  UIScroll.InputEvent(self._skillScroll, "ServantInfo_ScrollEvent")
end
function servantInfo:registMessageHandler()
  registerEvent("FromClient_OpenServantInformation", "ServantInfo_BeforOpenByActorKeyRaw")
  registerEvent("EventSelfServantUpdate", "ServantInfo_Update")
  registerEvent("EventSelfServantUpdateOnlyHp", "ServantInfo_UpdateHp")
  registerEvent("EventSelfServantUpdateOnlyMp", "ServantInfo_UpdateMp")
  registerEvent("EventServantEquipmentUpdate", "ServantInfo_Update")
  registerEvent("EventServantEquipItem", "ServantInfo_ChangeEquipItem")
  registerEvent("FromClient_SelfVehicleLevelUp", "FromClient_SelfVehicleLevelUp")
end
function FromClient_SelfVehicleLevelUp(variedHp, variedMp, variedWeight_s64, variedAcceleration, variedSpeed, variedCornering, variedBrake)
end
function ServantInfo_ChangeEquipItem(slotNo)
  local self = servantInfo
  local slot = self._itemSlots[slotNo]
  if nil == self._actorKeyRaw then
    return
  end
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  slot.icon:AddEffect("UI_ItemInstall", false, 0, 0)
  slot.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
  local itemWrapper = servantWrapper:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local defence = itemWrapper:getStaticStatus():getDefence(0)
  if defence > 0 then
    self._staticText_Value_Def:AddEffect("fUI_SkillButton01", false, -6, 2)
    self._staticText_Value_Def:AddEffect("UI_SkillButton01", false, -6, 2)
  end
end
local isNowEquip = false
function IsNowEquipCheck()
  return isNowEquip
end
function IsNowEquipReset()
  isNowEquip = false
end
function ServantInfo_RClick(slotNo)
  local self = servantInfo
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local itemWrapper = servantWrapper:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  isNowEquip = true
  servant_doUnequip(servantWrapper:getActorKeyRaw(), slotNo)
end
function ServantInfo_LClick(slotNo)
  if DragManager.dragStartPanel == Panel_Window_Inventory then
    Inventory_SlotRClick(DragManager.dragSlotInfo)
    DragManager.clearInfo()
  end
end
function ServantInfo_EquipItem_MouseOn(slotNo, isOn)
  local self = servantInfo
  local slot = self._itemSlots[slotNo]
  Panel_Tooltip_Item_SetPosition(slotNo, slot, "ServantEquipment")
  Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "ServantEquipment", isOn)
end
function ServantInfo_CheckSlot(slotNo)
  local self = servantInfo
  local checkButton = self._checkButton[slotNo]
end
function ServantInfo_ScrollEvent(isScrollUp)
  local self = servantInfo
  self._skillStart = UIScroll.ScrollEvent(self._skillScroll, isScrollUp, self._config._skill.count, self._skillCount, self._skillStart, 1)
  TooltipSimple_Hide()
  self:update()
end
function ServantInfo_BeforOpenByActorKeyRaw(actorKeyRaw)
  local self = servantInfo
  local servantWrapper = getServantInfoFromActorKey(actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local isSelfVehicle = servantWrapper:isSelfVehicle()
  local vehicleType = servantWrapper:getVehicleType()
  if servantWrapper:isGuildServant() then
    if false == servantWrapper:isMyGuildServant() then
      return
    end
  elseif false == isSelfVehicle then
    return
  end
  if UI_VT.Type_Horse == vehicleType or UI_VT.Type_Camel == vehicleType or UI_VT.Type_Donkey == vehicleType or UI_VT.Type_Elephant == vehicleType or UI_VT.Type_RidableBabyElephant == vehicleType then
    self._functionGet = ServantInfo_GetActorKey
    ServantInfo_OpenByActorKeyRaw(actorKeyRaw)
  elseif UI_VT.Type_Carriage == vehicleType or UI_VT.Type_CowCarriage == vehicleType or UI_VT.Type_Train == vehicleType or UI_VT.Type_RepairableCarriage == vehicleType then
    self._functionGet = CarriageInfo_GetActorKey
    CarriageInfo_OpenByActorKeyRaw(actorKeyRaw)
  elseif UI_VT.Type_Boat == vehicleType or UI_VT.Type_Raft == vehicleType or UI_VT.Type_FishingBoat == vehicleType then
    self._functionGet = ShipInfo_GetActorKey
    ShipInfo_OpenByActorKeyRaw(actorKeyRaw)
  elseif UI_VT.Type_SailingBoat == vehicleType or UI_VT.Type_PersonalBattleShip == vehicleType or UI_VT.Type_PersonTradeShip == vehicleType or UI_VT.Type_PersonalBoat == vehicleType or UI_VT.Type_CashPersonalTradeShip == vehicleType or UI_VT.Type_CashPersonalBattleShip == vehicleType or UI_VT.Type_Carrack == vehicleType then
    self._functionGet = WorkerShipInfo_GetActorKey
    WorkerShipInfo_OpenByActorKeyRaw(actorKeyRaw)
  end
end
function ServantInfo_OpenByActorKeyRaw(actorKeyRaw, vehicleType)
  local self = servantInfo
  self._actorKeyRaw = actorKeyRaw
  ServantInfo_Open()
end
function ServantInfo_Update()
  if not Panel_Window_ServantInfo:GetShow() then
    return
  end
  local self = servantInfo
  self:update()
end
function ServantInfo_Open()
  local self = servantInfo
  self:clear()
  self:update()
  self._skillScroll:SetControlPos(0)
  if Panel_Window_ServantInfo:GetShow() then
    return
  end
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  for index, value in pairs(self._config._slotNo) do
    local isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), value)
    self._checkButton[value]:SetCheck(isCheck)
    self._prevCheckButton[value] = isCheck
  end
  Panel_Window_ServantInfo:SetShow(true, true)
  servantInfo.babyElephant_Warning:SetShow(false)
  local temporaryWrapper = getTemporaryInformationWrapper()
  local landVehicleWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if nil ~= landVehicleWrapper then
    if UI_VT.Type_RidableBabyElephant == landVehicleWrapper:getVehicleType() then
      servantInfo.babyElephant_Warning:SetShow(true)
      servantInfo.babyElephant_Warning:addInputEvent("Mouse_On", "ServantInfo_BabyElephantWarning( true, 0 )")
      servantInfo.babyElephant_Warning:addInputEvent("Mouse_Out", "ServantInfo_BabyElephantWarning( false )")
    elseif UI_VT.Type_Donkey == landVehicleWrapper:getVehicleType() then
      servantInfo.babyElephant_Warning:SetShow(true)
      servantInfo.babyElephant_Warning:addInputEvent("Mouse_On", "ServantInfo_BabyElephantWarning( true, 1 )")
      servantInfo.babyElephant_Warning:addInputEvent("Mouse_Out", "ServantInfo_BabyElephantWarning( false )")
    end
  end
end
function ServantInfo_Close()
  if not Panel_Window_ServantInfo:GetShow() then
    return
  end
  Panel_Window_ServantInfo:SetShow(false, false)
  Panel_Tooltip_Item_hideTooltip()
end
function ServantInfo_VehicleEquipSlot_LClick(slotNo)
  local self = servantInfo
  local isChecked = self._checkButton[slotNo]:IsCheck()
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  if true == isChecked then
    ToClient_SetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), slotNo)
  else
    ToClient_ResetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), slotNo)
  end
  ToClient_setShowVehicleEquip()
end
function ServantInfo_GetActorKey()
  local self = servantInfo
  return self._actorKeyRaw
end
function Servant_GetActorKeyFromItemToolTip()
  local self = servantInfo
  return (self._functionGet())
end
local elapseTime = 0
function ServantInfoUpdate(deltaTime)
  if not Panel_Window_ServantInfo:GetShow() then
    return
  end
  elapseTime = elapseTime + deltaTime
  local isDiff = false
  if elapseTime > 0.2 then
    elapseTime = 0
    local self = servantInfo
    local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
    if nil == servantWrapper then
      return
    end
    for index, value in pairs(self._config._slotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantWrapper:getVehicleType(), value)
      if self._prevCheckButton[value] ~= isCheck then
        isDiff = true
        self._prevCheckButton[value] = isCheck
      end
    end
    if isDiff then
    end
  end
end
function ServantInfo_BabyElephantWarning(isShow, isType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc
  local control = servantInfo.babyElephant_Warning
  if 0 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_NAME_WARRING")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_DESC_WARRING")
  elseif 1 == isType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_NAME_WARRING")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TOOLTIP_DONKEY_WARNING_DESC")
  end
  TooltipSimple_Show(control, name, desc)
end
function ServantInfo_StallionToolTip(isOn)
  local self = servantInfo
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  if false == isOn then
    TooltipSimple_Hide()
    return
  end
  local uiControl, name, desc
  if 9 ~= servantWrapper:getTier() and isContentsStallionEnable then
    local isStallion = servantWrapper:isStallion()
    self._iconStallion:SetShow(true)
    if true == isStallion then
      self._iconStallion:SetMonoTone(false)
      uiControl = servantInfo._iconStallion
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_STALLIONICONNAME")
      if isContentsNineTierEnable then
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_STALLIONICONDESC")
        desc2 = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_STALLIONICONDESC2")
        desc = string.format("%s %s", desc, desc2)
      else
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_STALLIONICONDESC")
      end
    else
      self._iconStallion:SetMonoTone(true)
      uiControl = servantInfo._iconStallion
      name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_NOTSTALLIONICONNAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_TEXT_NOTSTALLIONICONDESC")
    end
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    self._iconStallion:SetShow(false)
  end
end
function ServantInfo_SkillNameLimitTooltip(isShow, idx, slotNo)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = servantInfo
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local name, desc, control
  local skillWrapper = servantWrapper:getSkill(idx)
  local slot = self._skillSlots[slotNo]
  if nil ~= skillWrapper then
    name = skillWrapper:getName()
    desc = ""
    control = slot.name
    TooltipSimple_Show(control, name, desc)
  end
end
function HandleEventMOn_ServantInfo_SkillDescTooltip(isShow, index, slotNo)
  if false == isShow then
    TooltipSimple_Hide()
  end
  local servantWrapper = getServantInfoFromActorKey(servantInfo._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local skillWrapper = servantWrapper:getSkill(index)
  local slot = servantInfo._skillSlots[slotNo]
  if nil ~= skillWrapper then
    name = skillWrapper:getDescription()
    desc = ""
    control = slot.dec
    TooltipSimple_Show(control, name, desc)
  end
end
function ServantInfo_Simpletooltips(isShow, idx, slotNo)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = servantInfo
  local servantWrapper = getServantInfoFromActorKey(self._actorKeyRaw)
  if nil == servantWrapper then
    return
  end
  local name, desc, control
  local skillWrapper = servantWrapper:getSkill(idx)
  local slot = self._skillSlots[slotNo]
  if nil ~= skillWrapper then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANTINFO_NEEDSKILLTITLE")
    desc = skillWrapper:getConditionDescription()
    control = slot.predec
    TooltipSimple_Show(control, name, desc)
  end
end
servantInfo:init()
servantInfo:registEventHandler()
servantInfo:registMessageHandler()
FGlobal_PanelMove(Panel_Window_ServantInfo, false)
