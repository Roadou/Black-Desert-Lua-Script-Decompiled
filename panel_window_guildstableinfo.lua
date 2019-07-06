Panel_Window_GuildStable_Info:SetShow(false, false)
Panel_Window_GuildStable_Info:setMaskingChild(true)
Panel_Window_GuildStable_Info:ActiveMouseEventEffect(true)
Panel_Window_GuildStable_Info:SetDragEnable(true)
Panel_Window_GuildStable_Info:RegisterShowEventFunc(true, "StableInfoShowAni()")
Panel_Window_GuildStable_Info:RegisterShowEventFunc(false, "StableInfoHideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
UI.getChildControl(Panel_Window_GuildStable_Info, "Stable_Info_Ability"):setGlassBackground(true)
UI.getChildControl(Panel_Window_GuildStable_Info, "Panel_Skill"):setGlassBackground(true)
function GuildStableInfoShowAni()
  Panel_Window_GuildStable_Info:SetShow(true, false)
  UIAni.fadeInSCR_Right(Panel_Window_GuildStable_Info)
  local aniInfo3 = Panel_Window_GuildStable_Info:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = false
end
function GuildStableInfoHideAni()
  Panel_Window_GuildStable_Info:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_GuildStable_Info:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local infoBg = UI.getChildControl(Panel_Window_GuildStable_Info, "Stable_Info_Ability")
local skillBg = UI.getChildControl(Panel_Window_GuildStable_Info, "Panel_Skill")
local guildStableInfo = {
  _config = {
    slot = {
      startX = 5,
      startY = 5,
      startBGX = 10,
      startBGY = 38,
      startScrollX = 319,
      startScrollY = 13,
      buttonSizeX = 60,
      halfButtonSizeY = 28,
      gapY = 66,
      count = 4
    },
    skill = {
      startIconX = 5,
      startIconY = 7,
      startNameX = 59,
      startNameY = 7,
      startDecX = 59,
      startDecY = 28,
      startExpBGX = 0,
      startExpBGY = 2,
      startExpX = 2,
      startExpY = 4,
      startButtonX = 251,
      startButtonY = 4
    }
  },
  _maleIcon = UI.getChildControl(infoBg, "Static_MaleIcon"),
  _femaleIcon = UI.getChildControl(infoBg, "Static_FemaleIcon"),
  _staticName = UI.getChildControl(infoBg, "StaticText_Name"),
  _staticLevel = UI.getChildControl(infoBg, "Static_Text_Level"),
  _staticHpGauge = UI.getChildControl(infoBg, "HP_GaugeBar"),
  _staticMpGauge = UI.getChildControl(infoBg, "MP_GaugeBar"),
  _staticExpGauge = UI.getChildControl(infoBg, "EXP_GaugeBar"),
  _staticWeightGauge = UI.getChildControl(infoBg, "Weight_GaugeBar"),
  _staticHPTitle = UI.getChildControl(infoBg, "HP"),
  _staticMPTitle = UI.getChildControl(infoBg, "MP"),
  _staticHP = UI.getChildControl(infoBg, "HP_CountData"),
  _staticMP = UI.getChildControl(infoBg, "MP_CountData"),
  _staticEXP = UI.getChildControl(infoBg, "EXP_CountData"),
  _staticWeight = UI.getChildControl(infoBg, "WHT_CountData"),
  _staticTitleMaxMoveSpeed = UI.getChildControl(infoBg, "MaxMoveSpeed"),
  _staticTitleAcceleration = UI.getChildControl(infoBg, "Acceleration"),
  _staticTitleCorneringSpeed = UI.getChildControl(infoBg, "CorneringSpeed"),
  _staticTitleBrakeSpeed = UI.getChildControl(infoBg, "BrakeSpeed"),
  _staticMoveSpeed = UI.getChildControl(infoBg, "MaxMoveSpeedValue"),
  _staticAcceleration = UI.getChildControl(infoBg, "AccelerationValue"),
  _staticCornering = UI.getChildControl(infoBg, "CorneringSpeedValue"),
  _staticBrakeSpeed = UI.getChildControl(infoBg, "BrakeSpeedValue"),
  _staticLife = UI.getChildControl(infoBg, "Static_LifeCount"),
  _staticLifeValue = UI.getChildControl(infoBg, "Static_LifeCountValue"),
  _deadCount = UI.getChildControl(infoBg, "StaticText_DeadCount"),
  _deadCountValue = UI.getChildControl(infoBg, "StaticText_DeadCountValue"),
  _startSlotIndex = 0,
  _temporaySlotCount = 0,
  _temporayLearnSkillCount = 0,
  _skill = Array.new(),
  _fromSkillKey = nil,
  _toSkillKey = nil
}
function guildStableInfo:clear()
  self._fromSkillKey = nil
  self._toSkillKey = nil
end
function guildStableInfo:init()
  self._staticSkillTitle = UI.createAndCopyBasePropertyControl(skillBg, "Skill_Title", skillBg, "StableInfo_SkillTitle")
  self._staticSkillBG = UI.createAndCopyBasePropertyControl(skillBg, "Static_SkillBG", skillBg, "StableInfo_SkillBG")
  self._scrollSkill = UI.createAndCopyBasePropertyControl(skillBg, "Scroll_Skill", self._staticSkillBG, "StableInfo_SkillScroll")
  local slotConfig = self._config.slot
  self._staticSkillBG:addInputEvent("Mouse_UpScroll", "StableInfo_ScrollEvent( true )")
  self._staticSkillBG:addInputEvent("Mouse_DownScroll", "StableInfo_ScrollEvent( false )")
  for ii = 0, self._config.slot.count - 1 do
    local slot = {}
    slot.base = UI.createAndCopyBasePropertyControl(skillBg, "Button_Skill", skillBg, "GuildStableInfo_Skill_" .. ii)
    slot.expBG = UI.createAndCopyBasePropertyControl(skillBg, "Static_SkillExpBG", slot.base, "GuildStableInfo_SkillExpBG_" .. ii)
    slot.exp = UI.createAndCopyBasePropertyControl(skillBg, "Gauge_SkillExp", slot.base, "GuildStableInfo_SkillExp_" .. ii)
    slot.icon = UI.createAndCopyBasePropertyControl(skillBg, "Static_SkillIcon", slot.base, "GuildStableInfo_SkillIcon" .. ii)
    slot.expStr = UI.createAndCopyBasePropertyControl(skillBg, "SkillLearn_PercentString", slot.base, "GuildStableInfo_SkillExpStr_" .. ii)
    slot.name = UI.createAndCopyBasePropertyControl(skillBg, "Static_Text_SkillName", slot.base, "GuildStableInfo_SkillName_" .. ii)
    slot.dec = UI.createAndCopyBasePropertyControl(skillBg, "Static_Text_SkillCondition", slot.base, "GuildStableInfo_SkillDec_" .. ii)
    slot.buttonLock = UI.createAndCopyBasePropertyControl(skillBg, "Button_SkillLock", slot.base, "GuildStableIngo_SkillLock_" .. ii)
    slot.base:SetPosX(slotConfig.startX + 10)
    slot.base:SetPosY(slotConfig.startY + slotConfig.gapY * ii + 47)
    local skillConfig = self._config.skill
    slot.icon:SetPosX(skillConfig.startIconX + 5)
    slot.icon:SetPosY(skillConfig.startIconY + 2)
    slot.name:SetPosX(skillConfig.startNameX)
    slot.name:SetPosY(skillConfig.startNameY)
    slot.dec:SetPosX(skillConfig.startDecX)
    slot.dec:SetPosY(skillConfig.startDecY)
    slot.expBG:SetPosX(skillConfig.startExpBGX + 5)
    slot.expBG:SetPosY(skillConfig.startExpBGY + 2)
    slot.exp:SetPosX(skillConfig.startExpX + 5)
    slot.exp:SetPosY(skillConfig.startExpY + 2)
    slot.expStr:SetPosX(skillConfig.startIconX + 10 + 5)
    slot.expStr:SetPosY(skillConfig.startIconY + 30 + 2)
    slot.buttonLock:SetPosX(skillConfig.startButtonX + 10)
    slot.buttonLock:SetPosY(skillConfig.startButtonY)
    slot.base:addInputEvent("Mouse_UpScroll", "GuildStableInfo_ScrollEvent( true )")
    slot.base:addInputEvent("Mouse_DownScroll", "GuildStableInfo_ScrollEvent( false )")
    slot.key = 0
    self._skill[ii] = slot
  end
end
function guildStableInfo:update()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    GuildStableInfo_Close()
    return
  end
  self._staticName:SetText(servantInfo:getName())
  self._staticLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel()))
  self._staticLevel:SetShow(false)
  self._staticHP:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._staticMP:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._staticWeight:SetShow(false)
  self._staticEXP:SetShow(false)
  self._staticHpGauge:SetSize(2.7 * (servantInfo:getHp() / servantInfo:getMaxHp() * 100), 6)
  self._staticMpGauge:SetSize(2.7 * (servantInfo:getMp() / servantInfo:getMaxMp() * 100), 6)
  local s64_exp = servantInfo:getExp_s64()
  local s64_needexp = servantInfo:getNeedExp_s64()
  local s64_exp_percent = Defines.s64_const.s64_0
  if s64_exp > Defines.s64_const.s64_0 then
    s64_exp_percent = 2.7 * (Int64toInt32(s64_exp) / Int64toInt32(s64_needexp) * 100)
  end
  self._staticExpGauge:SetShow(false)
  self._staticMoveSpeed:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._staticAcceleration:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._staticCornering:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._staticBrakeSpeed:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  self._staticTitleMaxMoveSpeed:SetShow(true)
  self._staticTitleAcceleration:SetShow(true)
  self._staticTitleCorneringSpeed:SetShow(true)
  self._staticTitleBrakeSpeed:SetShow(true)
  self._staticMoveSpeed:SetShow(true)
  self._staticAcceleration:SetShow(true)
  self._staticCornering:SetShow(true)
  self._staticBrakeSpeed:SetShow(true)
  self._deadCount:SetShow(false)
  self._deadCountValue:SetShow(false)
  self._deadCount:SetShow(true)
  self._deadCountValue:SetShow(true)
  local deadCount = servantInfo:getDeadCount()
  self._deadCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDSERVANTINFO_INJURY"))
  self._deadCountValue:SetText(deadCount * 10 .. "%")
  if servantInfo:isPeriodLimit() then
    self._staticLifeValue:SetText(convertStringFromDatetime(servantInfo:getExpiredTime()))
  else
    self._staticLifeValue:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
  end
  self._maleIcon:SetShow(false)
  self._femaleIcon:SetShow(false)
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Horse then
    if servantInfo:isMale() then
      self._maleIcon:SetShow(true)
      self._femaleIcon:SetShow(false)
    else
      self._maleIcon:SetShow(false)
      self._femaleIcon:SetShow(true)
    end
  else
    self._maleIcon:SetShow(false)
    self._femaleIcon:SetShow(false)
  end
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Elephant then
    self._staticHPTitle:addInputEvent("Mouse_On", "GuildStableInfo_SimpleTooltip( true, 0 )")
    self._staticHPTitle:addInputEvent("Mouse_Out", "GuildStableInfo_SimpleTooltip( false, 0 )")
    self._staticHPTitle:setTooltipEventRegistFunc("GuildStableInfo_SimpleTooltip( true, 0 )")
    self._staticMPTitle:addInputEvent("Mouse_On", "GuildStableInfo_SimpleTooltip( true, 1 )")
    self._staticMPTitle:addInputEvent("Mouse_On", "GuildStableInfo_SimpleTooltip( false, 1 )")
    self._staticMPTitle:setTooltipEventRegistFunc("GuildStableInfo_SimpleTooltip( true, 1 )")
  end
  self:updateSkill(unsealType)
end
function FGlobal_GuildStableInfoUpdate()
  local self = guildStableInfo
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil ~= servantInfo then
    return
  end
  self._staticHP:SetText(tostring(servantInfo:getHp()) .. " / " .. tostring(servantInfo:getMaxHp()))
  self._staticMP:SetText(tostring(servantInfo:getMp()) .. " / " .. tostring(servantInfo:getMaxMp()))
  self._staticHpGauge:SetSize(2.7 * (servantInfo:getHp() / servantInfo:getMaxHp() * 100), 6)
  self._staticMpGauge:SetSize(2.7 * (servantInfo:getMp() / servantInfo:getMaxMp() * 100), 6)
end
function guildStableInfo:updateSkill()
  local servantInfo = guildStable_getServant(GuildStableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  for ii = 0, self._config.slot.count - 1 do
    local slot = self._skill[ii]
    slot.base:SetShow(false)
    slot.exp:SetShow(false)
    slot.expStr:SetShow(false)
    slot.buttonLock:SetShow(false)
  end
  if nil == servantInfo then
    return
  end
  if not servantInfo:doHaveVehicleSkill() then
    skillBg:SetShow(true)
    self._scrollSkill:SetShow(false)
    return
  end
  local temporarySlotIndex = 0
  local slotNo = 0
  self._temporayLearnSkillCount = 0
  self._temporaySlotCount = servantInfo:getSkillCount()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local regionName = regionInfo:getAreaName()
  local servantRegionName = servantInfo:getRegionName()
  for ii = 1, self._temporaySlotCount - 1 do
    local skillWrapper = servantInfo:getSkill(ii)
    if nil ~= skillWrapper then
      if slotNo < self._config.slot.count then
        if temporarySlotIndex >= self._startSlotIndex then
          local slot = self._skill[slotNo]
          slot.key = ii
          slot.icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
          slot.name:SetText(skillWrapper:getName())
          slot.dec:SetText(skillWrapper:getDescription())
          slot.exp:SetProgressRate(servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100))
          slot.exp:SetAniSpeed(0)
          local expTxt = tonumber(string.format("%.0f", servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100)))
          if expTxt >= 100 then
            expTxt = 100
          end
          slot.expStr:SetText(expTxt .. "%")
          slot.exp:SetShow(true)
          slot.expStr:SetShow(true)
          if servantInfo:isSkillLock(ii) and servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
            slot.buttonLock:SetShow(true)
          end
          slot.base:SetShow(true)
          slotNo = slotNo + 1
        end
        temporarySlotIndex = temporarySlotIndex + 1
      end
      self._temporayLearnSkillCount = self._temporayLearnSkillCount + 1
    end
  end
  for ii = 1, self._temporaySlotCount - 1 do
    local skillWrapper = servantInfo:getSkillXXX(ii)
    if nil ~= skillWrapper and servantInfo:getStateType() ~= CppEnums.ServantStateType.Type_SkillTraining then
      if slotNo < self._config.slot.count then
        if temporarySlotIndex >= self._startSlotIndex then
          local slot = self._skill[slotNo]
          slot.key = ii
          slot.icon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
          slot.name:SetText(skillWrapper:getName())
          slot.dec:SetText(skillWrapper:getDescription())
          slot.base:SetShow(true)
          slotNo = slotNo + 1
        end
        temporarySlotIndex = temporarySlotIndex + 1
      end
      self._temporayLearnSkillCount = self._temporayLearnSkillCount + 1
    end
  end
  if 0 < self._temporayLearnSkillCount then
    skillBg:SetShow(true)
    UIScroll.SetButtonSize(self._scrollSkill, self._config.slot.count, self._temporayLearnSkillCount)
  end
end
function guildStableInfo:registEventHandler()
  skillBg:addInputEvent("Mouse_UpScroll", "GuildStableInfo_ScrollEvent( true )")
  skillBg:addInputEvent("Mouse_DownScroll", "GuildStableInfo_ScrollEvent( false )")
  UIScroll.InputEvent(self._scrollSkill, "GuildStableInfo_ScrollEvent")
end
function guildStableInfo:registMessageHandler()
  registerEvent("onScreenResize", "GuildStableInfo_Resize")
end
function GuildStableInfo_Resize()
  Panel_Window_GuildStable_Info:SetSpanSize(20, 30)
  Panel_Window_GuildStable_Info:ComputePos()
end
function GuildStableInfo_ScrollEvent(isScrollUp)
  local self = guildStableInfo
  self._startSlotIndex = UIScroll.ScrollEvent(self._scrollSkill, isScrollUp, self._config.slot.count, self._temporayLearnSkillCount, self._startSlotIndex, 1)
  self:update()
end
function GuildStableInfo_SimpleTooltip(isShow, tipType)
  local self = guildStableInfo
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_HORSEHP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTHP_DESC")
    control = self._staticHPTitle
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_CARRIAGEMP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HORSEHP_TOOLTIP_ELEPHANTMP_DESC")
    control = self._staticMPTitle
  end
  registTooltipControl(control, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GuildStableInfo_Open()
  if not Panel_Window_GuildStable_Info:GetShow() then
    Panel_Window_GuildStable_Info:SetShow(true)
  end
  self = guildStableInfo
  self:clear()
  self._scrollSkill:SetControlPos(0)
  self:update()
end
function GuildStableInfo_Close()
  if not Panel_Window_GuildStable_Info:GetShow() then
  end
  Panel_Window_GuildStable_Info:SetShow(false)
end
guildStableInfo:init()
guildStableInfo:registEventHandler()
guildStableInfo:registMessageHandler()
GuildStableInfo_Resize()
