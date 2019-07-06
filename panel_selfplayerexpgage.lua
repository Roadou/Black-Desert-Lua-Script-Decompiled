Panel_SelfPlayerExpGage:RegisterShowEventFunc(true, "mainStatus_AniOpen()")
Panel_SelfPlayerExpGage:RegisterShowEventFunc(false, "mainStatus_AniClose()")
local UI_classType = CppEnums.ClassType
Panel_SelfPlayerExpGage:SetShow(true)
PaGlobal_SelfPlayerExpGage = {
  _combatResource_EP_RG = 0,
  _combatResource_EP_DE = 1,
  _combatResource_FP = 2,
  _combatResource_BP = 3,
  _combatResource_MP = 4,
  _ui = {
    _StaticText_LVTXT = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_LVTXT"),
    _StaticText_Level = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_Level"),
    _StaticText_Level_Sub = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_Level_Sub"),
    _Static_BaseLine = UI.getChildControl(Panel_SelfPlayerExpGage, "Static_BaseLine"),
    _StaticText_Sp = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_Sp"),
    _StaticText_WP = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_WP"),
    _StaticText_ContributeP = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_ContributeP"),
    _gaugePanel = Panel_SelfPlayerExpGage,
    _staticGauge_HP = UI.getChildControl(Panel_SelfPlayerExpGage, "Progress2_Hp"),
    _staticGauge_CombatResource = UI.getChildControl(Panel_SelfPlayerExpGage, "Progress2_Mp"),
    _textHp = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_Hp"),
    _textMp = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_Mp"),
    _dangerPanel = Panel_Danger,
    _alertDanger = UI.getChildControl(Panel_Danger, "Static_Alert"),
    _blackSpirit = UI.getChildControl(Panel_SelfPlayerExpGage, "Progress2_BlackSpirit"),
    _blackSpiritText = UI.getChildControl(Panel_SelfPlayerExpGage, "StaticText_BlackSpiritPercent")
  },
  _prevHP = 0,
  _prevMaxHP = 0,
  _prevMP = 0,
  _prevMaxMP = 0,
  _percentHP = 0,
  _prevHpAlertTime = 0,
  _prevAdrenallin = 0,
  _hpEffectName = "",
  _combatResourceEffectName = "",
  _hpEffectValue = 5,
  _mpEffectValue = 10,
  _alertHpValue = 40,
  _hpMsgValue = 20,
  _msgSendSec = 20,
  _simpleUIFadeRate = 1,
  _burnEffectStartTime = 0,
  _burnEffectDuringTime = 10,
  _burnEffectKey = 0,
  _isLoad = false,
  _burnEffectOn = false
}
function PaGlobal_SelfPlayerExpGage:Initialize()
  if true == self._isLoad then
    return
  end
  self._combatResourceTypeList = {
    [UI_classType.ClassType_Ranger] = self._combatResource_EP_RG,
    [UI_classType.ClassType_DarkElf] = self._combatResource_EP_DE,
    [UI_classType.ClassType_Warrior] = self._combatResource_FP,
    [UI_classType.ClassType_Giant] = self._combatResource_FP,
    [UI_classType.ClassType_BladeMaster] = self._combatResource_FP,
    [UI_classType.ClassType_BladeMasterWomen] = self._combatResource_FP,
    [UI_classType.ClassType_NinjaWomen] = self._combatResource_FP,
    [UI_classType.ClassType_Combattant] = self._combatResource_FP,
    [UI_classType.ClassType_CombattantWomen] = self._combatResource_FP,
    [UI_classType.ClassType_Valkyrie] = self._combatResource_BP
  }
  self._uvDataList = {
    [self._combatResource_EP_RG] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 1, 151, 281, 171)
    },
    [self._combatResource_EP_DE] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 1, 172, 281, 192)
    },
    [self._combatResource_FP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 1, 214, 281, 234)
    },
    [self._combatResource_BP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 1, 235, 281, 255)
    },
    [self._combatResource_MP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 1, 193, 281, 213)
    }
  }
  self._warningMsg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING_SUB"),
    addMsg = ""
  }
  self._blackSpritTooltipTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_TITLE")
  self._blackSpritTooltipDesc = PAGetString(Defines.StringSheet_GAME, "LUA_ADRENALLIN_TOOLTIP_DESC")
  self._playerWrapper = getSelfPlayer()
  self._player = self._playerWrapper:get()
  self:LoadHpBar()
  self:LoadMpBar()
  self._ui._gaugePanel:SetShow(true)
  self._isLoad = true
  self._ui._gaugePanel:SetIgnore(true)
  self._ui._blackSpirit:SetIgnore(false)
  self._ui._blackSpirit:SetShow(true)
  self._ui._blackSpiritText:SetShow(true)
  self.panelPosX = self._ui._gaugePanel:GetPosX()
  self.panelPosY = self._ui._gaugePanel:GetPosY()
  self._ui._gaugePanel:SetPosX(self.panelPosX + 10)
  self._ui._gaugePanel:SetPosY(self.panelPosY + 10)
end
function PaGlobal_SelfPlayerExpGage:Update()
  self:UpdateHp()
  self:UpdateMp()
  FGlobal_SettingMpBarTemp()
end
function PaGlobal_SelfPlayerExpGage:LoadHpBar()
  self._ui.hpGaugeMaxSize = self._ui._staticGauge_HP:GetSizeX()
  self._ui._staticGauge_HP:SetShow(true)
  self._hpEffectName = "fUI_Console_Gauge_Red"
  self._ui._staticGauge_HP:AddEffect(self._hpEffectName, false, 0, 0)
  self._ui._staticGauge_HP:SetProgressRate(100)
  self._ui._staticGauge_HP:SetAlpha(1)
end
function PaGlobal_SelfPlayerExpGage:LoadMpBar()
  self._ui._staticGauge_CombatResource:SetShow(true)
  local resourceIndex = self:GetCombatResourceType(self._playerWrapper:getClassType())
  self:ChangeCombatResource(resourceIndex)
  self._combatResourceEffectName = self:GetEffectName(resourceIndex)
  self._ui._staticGauge_CombatResource:AddEffect(self._combatResourceEffectName, false, 0, 0)
  self._ui._staticGauge_CombatResource:SetProgressRate(100)
  self._ui._staticGauge_CombatResource:SetAlpha(1)
end
function PaGlobal_SelfPlayerExpGage:SetPostion(posX, posY)
  self._ui._gaugePanel:SetPosX(posX)
  self._ui._gaugePanel:SetPosY(posY)
end
function PaGlobal_SelfPlayerExpGage:GetCombatResourceType(classType)
  local resourceType = self._combatResourceTypeList[classType]
  if nil ~= resourceType then
    return resourceType
  else
    return self._combatResource_MP
  end
end
function PaGlobal_SelfPlayerExpGage:ChangeCombatResource(index)
  self._ui._staticGauge_CombatResource:ChangeTextureInfoName("new_ui_common_forlua/default/console_progressbar_01.dds")
  local data = self._uvDataList[index]
  if nil == data then
    data = self._uvDataList[self._combatResource_MP]
  end
  self._ui._staticGauge_CombatResource:getBaseTexture():setUV(data[1], data[2], data[3], data[4])
  self._ui._staticGauge_CombatResource:setRenderTexture(self._ui._staticGauge_CombatResource:getBaseTexture())
end
function PaGlobal_SelfPlayerExpGage:GetEffectName(index)
  if self._combatResource_EP_RG == index then
    return "fUI_Console_Gauge_Green"
  elseif self._combatResource_EP_DE == index then
    return "fUI_Console_Gauge_Purple"
  elseif self._combatResource_FP == index then
    return "fUI_Console_Gauge_Yellow"
  elseif self._combatResource_BP == index then
    return "fUI_Console_Gauge_White"
  elseif self._combatResource_MP == index then
    return "fUI_Console_Gauge_Blue"
  else
    return "fUI_Console_Gauge_Blue"
  end
end
function PaGlobal_SelfPlayerExpGage:SendWarningMessage()
  local regionKeyRaw = self._playerWrapper:getRegionKeyRaw()
  local regionWrapper = getRegionInfoWrapper(regionKeyRaw)
  local isArenaZone = regionWrapper:get():isArenaZone()
  if true == isArenaZone then
    return
  end
  local luaTime = FGlobal_getLuaLoadTime()
  if self._hpMsgValue > self._percentHP and luaTime > self._prevHpAlertTime + self._msgSendSec then
    Proc_ShowMessage_Ack_For_RewardSelect(self._warningMsg, 3, 24)
    self._prevHpAlertTime = luaTime
  end
end
function PaGlobal_SelfPlayerExpGage:UpdateHp()
  local hp = math.floor(self._player:getHp())
  local maxHp = math.floor(self._player:getMaxHp())
  self._percentHP = hp / maxHp * 100
  self._ui._textHp:SetText(hp .. "/" .. maxHp)
  if 0 ~= maxHp and (hp ~= self._prevHP or maxHp ~= self._prevMaxHP) then
    self._ui._staticGauge_HP:SetProgressRate(self._percentHP)
    if self._hpEffectValue < hp - self._prevHP then
      self._ui._staticGauge_HP:AddEffect(self._hpEffectName, false, 0, 0)
    end
    self:SetFadeRate(5)
    self._prevHP = hp
    self._prevMaxHP = maxHp
    self:CheckHpAlert(hp, maxHp, false)
  end
  self:SendWarningMessage()
end
function PaGlobal_SelfPlayerExpGage:UpdateMp()
  local mp = math.floor(self._player:getMp())
  local maxMp = math.floor(self._player:getMaxMp())
  self._ui._textMp:SetText(mp .. "/" .. maxMp)
  if 0 ~= maxMp and (mp ~= self._prevMP or maxMp ~= self._prevMaxMP) then
    self._ui._staticGauge_CombatResource:SetProgressRate(mp / maxMp * 100)
    if self._mpEffectValue < mp - self._prevMP then
      self._ui._staticGauge_CombatResource:AddEffect(self._combatResourceEffectName, false, 0, 0)
    end
    self:SetFadeRate(5)
    self._prevMP = mp
    self._prevMaxMP = maxMp
  end
end
function PaGlobal_SelfPlayerExpGage:CheckHpAlert(hp, maxHp, isLevelUp)
  if Defines.UIMode.eUIMode_Default ~= GetUIMode() then
    return
  end
  if self._alertHpValue < self._percentHP then
    self:DangerPanelSetShow(false)
  else
    self:DangerPanelSetShow(true)
  end
end
function PaGlobal_SelfPlayerExpGage:DangerPanelSetShow(isShow)
  self._ui._alertDanger:SetShow(isShow)
  self._ui._dangerPanel:SetShow(isShow)
end
function PaGlobal_SelfPlayerExpGage:RegistMessageHandler()
  registerEvent("EventCharacterInfoUpdate", "Panel_SelfPlayerExpGage_Update")
  registerEvent("FromClient_SelfPlayerHpChanged", "Panel_SelfPlayerExpGage_Update")
  registerEvent("FromClient_SelfPlayerMpChanged", "Panel_SelfPlayerExpGage_Update")
  registerEvent("onScreenResize", "Panel_SelfPlayerExpGage_Onresize")
  registerEvent("EventSelfPlayerLevelUp", "Panel_SelfPlayerExpGage_RefreshHpBar")
  registerEvent("FromClient_DamageByOtherPlayer", "Panel_SelfPlayerExpGage_DamageByOtherPlayer")
  self._ui._blackSpirit:addInputEvent("Mouse_On", "PaGlobal_SelfPlayerExpGage:ShowAdrenallinTooltip( true )")
  self._ui._blackSpirit:addInputEvent("Mouse_Out", "PaGlobal_SelfPlayerExpGage:ShowAdrenallinTooltip( false )")
  self._ui._blackSpirit:setTooltipEventRegistFunc("PaGlobal_SelfPlayerExpGage:ShowAdrenallinTooltip( true )")
  registerEvent("FromClient_SelfPlayerCombatSkillPointChanged", "UserSkillPoint_Update")
  registerEvent("FromClient_SelfPlayerExpChanged", "Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate")
  registerEvent("EventSelfPlayerLevelUp", "UserLevel_Update")
  registerEvent("FromClient_WpChanged", "wpPoint_UpdateFunc")
  registerEvent("FromClient_UpdateExplorePoint", "contributePoint_UpdateFunc")
end
function PaGlobal_SelfPlayerExpGage:SetAlphaAll(alphaReate)
  self._ui._gaugePanel:SetAlpha(alphaReate)
  self._ui._staticGauge_HP:SetAlpha(alphaReate)
  self._ui._staticGauge_CombatResource:SetAlpha(alphaReate)
  self._ui._blackSpirit:SetAlpha(alphaReate)
  self._ui._blackSpiritText:SetAlpha(alphaReate)
end
function Panel_SelfPlayerExpGage_Update()
  PaGlobal_SelfPlayerExpGage:Update()
end
function Panel_SelfPlayerExpGage_Onresize()
  Panel_SelfPlayerExpGage:SetPosX(10)
  Panel_SelfPlayerExpGage:SetPosY(10)
end
function Panel_SelfPlayerExpGage_RefreshHpBar()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = math.floor(player:getHp())
  local maxHp = math.floor(player:getMaxHp())
  PaGlobal_SelfPlayerExpGage:CheckHpAlert(hp, maxHp, true)
end
function PaGlobal_SelfPlayerExpGage:LoadBurnEffect()
  if true == self._burnEffectOn then
    return
  end
  self._ui._staticGauge_HP:EraseAllEffect()
  self._burnEffectKey = self._ui._staticGauge_HP:AddEffect("fUI_Gauge_PvP", false, 0, 0)
  self._burnEffectOn = true
  self._burnEffectStartTime = FGlobal_getLuaLoadTime()
end
function PaGlobal_SelfPlayerExpGage:CheckHpAlertPostEvent()
  self:CheckHpAlert(1, 1, false)
end
function Panel_SelfPlayerExpGage_DamageByOtherPlayer()
  PaGlobal_SelfPlayerExpGage:LoadBurnEffect()
end
function EnableBurnEffect(DeltaTime)
  local self = PaGlobal_SelfPlayerExpGage
  if false == self._burnEffectOn then
    return
  end
  local startTime = self._burnEffectStartTime
  if startTime + self._burnEffectDuringTime < FGlobal_getLuaLoadTime() then
    self._ui._staticGauge_HP:EraseEffect(self._burnEffectKey)
    self._burnEffectOn = false
  end
end
function Panel_SelfPlayerExpGage_AlertPostEvent(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderModebyGameMode(nextRenderModeList) or CheckRenderMode(prevRenderModeList, currentRenderMode) then
    PaGlobal_SelfPlayerExpGage:CheckHpAlertPostEvent()
  end
  Panel_SelfPlayerExpGage_Onresize()
end
function Panel_SelfPlayerExpGage_UpdateSimpleUI(DeltaTime)
  local self = PaGlobal_SelfPlayerExpGage
  if nil == self._simpleUIFadeRate then
    return
  end
  self._simpleUIFadeRate = self._simpleUIFadeRate - DeltaTime
  if self._simpleUIFadeRate < 0 then
    self._simpleUIFadeRate = 0
  end
  if true == getPvPMode() then
    self._simpleUIFadeRate = 1
  end
  local alphaRate = self._simpleUIFadeRate
  if alphaRate > 1 then
    alphaRate = 1
  end
  PaGlobal_SelfPlayerExpGage:SetAlphaAll(alphaRate)
end
function Panel_SelfPlayerExpGage_EnableSimpleUI()
  PaGlobal_SelfPlayerExpGage._simpleUIFadeRate = 1
  PaGlobal_SelfPlayerExpGage:SetAlphaAll(1)
end
function Panel_SelfPlayerExpGage_DisableSimpleUI()
  PaGlobal_SelfPlayerExpGage._simpleUIFadeRate = 1
  PaGlobal_SelfPlayerExpGage:SetAlphaAll(1)
end
function PaGlobal_SelfPlayerExpGage:SetShowAll()
  self._ui._gaugePanel:SetShow(true, true)
  self._ui._staticGauge_HP:AddEffect("fUI_Console_TutoR_HP_01", false, 0, 0)
  self._ui._staticGauge_CombatResource:AddEffect("fUI_Console_TutoR_MP_01", false, 0, 0)
end
function PaGlobal_SelfPlayerExpGage:SetPrevHP(value)
  self._prevHP = value
end
function PaGlobal_SelfPlayerExpGage:SetFadeRate(value)
  self._simpleUIFadeRate = value
end
function mainStatus_AniOpen()
  local self = PaGlobal_SelfPlayerExpGage
  self._ui._gaugePanel:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local MainStatusOpen_Alpha = self._ui._gaugePanel:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  MainStatusOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  MainStatusOpen_Alpha.IsChangeChild = true
end
function mainStatus_AniClose()
  local self = PaGlobal_SelfPlayerExpGage
  self._ui._gaugePanel:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local MainStatusClose_Alpha = self._ui._gaugePanel:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  MainStatusClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  MainStatusClose_Alpha.IsChangeChild = true
  MainStatusClose_Alpha:SetHideAtEnd(true)
  MainStatusClose_Alpha:SetDisableWhileAni(true)
end
PaGlobal_SelfPlayerExpGage:Initialize()
PaGlobal_SelfPlayerExpGage:RegistMessageHandler()
Panel_SelfPlayerExpGage:RegisterUpdateFunc("EnableBurnEffect")
registerEvent("SimpleUI_UpdatePerFrame", "Panel_SelfPlayerExpGage_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_SelfPlayerExpGage_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_SelfPlayerExpGage_DisableSimpleUI")
registerEvent("FromClient_RenderModeChangeState", "Panel_SelfPlayerExpGage_AlertPostEvent")
function PaGlobal_SelfPlayerExpGage:UpdateAdreanllin()
  if nil == self._playerWrapper then
    return
  end
  local adrenallinValue = self._playerWrapper:getAdrenalin()
  self._ui._blackSpirit:SetProgressRate(adrenallinValue)
  self._ui._blackSpiritText:SetText(tostring(adrenallinValue) .. "%")
  if adrenallinValue ~= self._prevAdrenallin then
    self:SetFadeRate(5)
  end
  self._prevAdrenallin = adrenallinValue
end
function PaGlobal_SelfPlayerExpGage_Update_Adrenalin()
  PaGlobal_SelfPlayerExpGage:UpdateAdreanllin()
end
function PaGlobal_SelfPlayerExpGage_Change_Adrenalin_Mode()
  PaGlobal_SelfPlayerExpGage:UpdateAdreanllin()
end
function PaGlobal_SelfPlayerExpGage:ShowAdrenallinTooltip(isShow)
  registTooltipControl(self._ui._blackSpirit, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(self._ui._blackSpirit, self._blackSpritTooltipTitle, self._blackSpritTooltipDesc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_SelfPlayerExpGage_Check_Adrenalin_PostEvent(prevRenderModeList, nextRenderModeList)
  if false == CheckRenderModebyGameMode(nextRenderModeList) then
    return
  end
  PaGlobal_SelfPlayerExpGage_Change_Adrenalin_Mode()
end
registerEvent("FromClient_UpdateAdrenalin", "PaGlobal_SelfPlayerExpGage_Update_Adrenalin")
registerEvent("FromClient_ChangeAdrenalinMode", "PaGlobal_SelfPlayerExpGage_Change_Adrenalin_Mode")
registerEvent("FromClient_RenderModeChangeState", "PaGlobal_SelfPlayerExpGage_Check_Adrenalin_PostEvent")
PaGlobal_SelfPlayerExpGage:UpdateAdreanllin()
local _lastLevel = 0
function PaGlobal_SelfPlayerExpGage:UserLevel_Update()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  self._ui._StaticText_Level:SetText(tostring(player:get():getLevel()))
  if _lastLevel < player:get():getLevel() and 0 ~= _lastLevel then
    self._ui._StaticText_Level:EraseAllEffect()
    self._ui._StaticText_Level:AddEffect("fUI_NewSkill01", false, -10, 0)
    self._ui._StaticText_Level:AddEffect("UI_NewSkill01", false, -10, 0)
    self._ui._StaticText_Level:AddEffect("fUI_ConSole_LevelUp01", false, -10, 0)
  end
  self:CharacterLevelCheckForWeather()
  _lastLevel = player:get():getLevel()
end
function PaGlobal_SelfPlayerExpGage:CharacterLevelCheckForWeather()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local inMyLevel = player:get():getLevel()
  if 16 == inMyLevel and not isSixteen then
    isSixteen = true
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "PANEL_SELFPLAYEREXPGAGE_LEVEL_WEATHERCHECK"))
  end
end
function PaGlobal_SelfPlayerExpGage:updateExp()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local player = selfPlayer:get()
  local s64_needExp = player:getNeedExp_s64()
  local s64_exp = player:getExp_s64()
  local _const = Defines.s64_const
  local rate = 0
  local rateDisplay = 0
  if s64_needExp > _const.s64_10000 then
    rate = Int64toInt32(s64_exp * Defines.s64_const.s64_1000 * Defines.s64_const.s64_100 / s64_needExp)
  elseif _const.s64_0 ~= s64_needExp then
    rate = Int64toInt32(s64_exp * Defines.s64_const.s64_1000 * Defines.s64_const.s64_100 / s64_needExp)
  end
  local real_rate = rate / 1000
  if 100 == real_rate then
    rateDisplay = "100.000%"
  elseif 0 == real_rate then
    rateDisplay = "0.000%"
  elseif real_rate == real_rate - real_rate % 1 then
    rateDisplay = real_rate .. ".000%"
  elseif real_rate == real_rate - real_rate % 0.1 then
    rateDisplay = real_rate .. "00%"
  elseif real_rate == real_rate - real_rate % 0.01 then
    rateDisplay = real_rate .. "0%"
  else
    rateDisplay = real_rate .. "%"
  end
  _lastEXP = Int64toInt32(s64_exp)
  self._ui._StaticText_Level_Sub:ComputePos()
  self._ui._StaticText_Level_Sub:SetText(string.format("%.3f", real_rate) .. "%")
end
function Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate()
  PaGlobal_SelfPlayerExpGage:updateExp()
end
local _lastSkillPoint = -1
local _lastWP = -1
local _lastEXP = -1
function PaGlobal_SelfPlayerExpGage:UserSkillPoint_Update()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local player = selfPlayer:get()
  local skillExpRate, skillPointNeedExp
  skillPointNeedExp = player:getSkillPointNeedExperience()
  if 0 ~= skillPointNeedExp then
    skillExpRate = player:getSkillPointExperience() / skillPointNeedExp
  else
    skillExpRate = 0
  end
  if _lastSkillPoint < player:getRemainSkillPoint() and -1 ~= _lastSkillPoint then
    audioPostEvent_SystemUi(3, 7)
    _AudioPostEvent_SystemUiForXBOX(3, 7)
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eSkillIconCheck, true, CppEnums.VariableStorageType.eVariableStorageType_User)
    self._ui._StaticText_Sp:EraseAllEffect()
    self._ui._StaticText_Sp:AddEffect("UI_LevelUP_Skill", false, 0, 0)
    self._ui._StaticText_Sp:AddEffect("fUI_LevelUP_Skill02", false, 0, 0)
  end
  self._ui._StaticText_Sp:SetText(tostring(player:getRemainSkillPoint()))
  if CppEnums.CountryType.DEV == getGameServiceType() then
    local skillPointInfo = ToClient_getSkillPointInfo(0)
    local skillPointLev = tostring(skillPointInfo._pointLevel)
    self._ui._StaticText_Sp:SetText("(" .. skillPointLev .. ")" .. tostring(player:getRemainSkillPoint()))
  end
  local _tempSkillPoint = skillExpRate * 100
  if _tempSkillPoint < 10 then
    self._ui._StaticText_Sp:SetText(self._ui._StaticText_Sp:GetText() .. ".0" .. string.format("%.0f", _tempSkillPoint))
  else
    self._ui._StaticText_Sp:SetText(self._ui._StaticText_Sp:GetText() .. "." .. string.format("%.0f", _tempSkillPoint))
  end
  _lastSkillPoint = player:getRemainSkillPoint()
  _lastSkillExp = skillExpRate
  if selfPlayer:get():getReservedLearningSkillKey():isDefined() then
    if false == _reservedLearningSkillSlot.iconBG:GetShow() then
      ExpGauge_SetReservedLearningSkill()
    end
    ExpGauge_UpdateReservedSkillCircularProgress()
  end
  enableSkill_UpdateData()
end
function UserSkillPoint_Update()
  PaGlobal_SelfPlayerExpGage:UserSkillPoint_Update()
end
function wpPoint_UpdateFunc()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local Wp = selfPlayer:getWp()
  local maxWp = selfPlayer:getMaxWp()
  local wpSetProgress = Wp / maxWp * 100
  if Wp > _lastWP and -1 ~= _lastWP then
    audioPostEvent_SystemUi(3, 13)
    _AudioPostEvent_SystemUiForXBOX(3, 13)
    PaGlobal_SelfPlayerExpGage._ui._StaticText_WP:EraseAllEffect()
    PaGlobal_SelfPlayerExpGage._ui._StaticText_WP:AddEffect("UI_LevelUP_Skill", false, 0, 0)
    PaGlobal_SelfPlayerExpGage._ui._StaticText_WP:AddEffect("fUI_LevelUP_Skill02", false, 0, 0)
  end
  PaGlobal_SelfPlayerExpGage._ui._StaticText_WP:SetText(tostring(Wp) .. " / " .. maxWp)
  _lastWP = Wp
end
local lastContRate = 0
local lastRemainExplorePoint = 0
local lastExplorePoint = 0
local isFirstExplore = false
Panel_Expgauge_MyContributeValue = 0
function contributePoint_UpdateFunc()
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  if nil == explorePoint then
    PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:SetText("")
    return
  end
  local s64_exploreRequireExp = getRequireExperienceToExplorePointByTerritory_s64(territoryKeyRaw)
  local cont_expRate = Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64())
  local nowRemainExpPoint = tostring(explorePoint:getRemainedPoint())
  local nowExpPoint = tostring(explorePoint:getAquiredPoint())
  PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:SetText(tostring(explorePoint:getRemainedPoint()) .. " / " .. tostring(explorePoint:getAquiredPoint()))
  Panel_Expgauge_MyContributeValue = tostring(explorePoint:getRemainedPoint())
  if isFirstExplore == false then
    lastRemainExplorePoint = 0
    lastExplorePoint = 0
    nowRemainExpPoint = 0
    nowExpPoint = 0
    isFirstExplore = true
  end
  if lastRemainExplorePoint ~= nowRemainExpPoint and isFirstExplore == true then
    audioPostEvent_SystemUi(3, 7)
    _AudioPostEvent_SystemUiForXBOX(3, 7)
    PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:EraseAllEffect()
    PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:AddEffect("UI_LevelUP_Skill", false, 0, 0)
  end
  if lastExplorePoint ~= nowExpPoint and isFirstExplore == true then
    audioPostEvent_SystemUi(3, 7)
    _AudioPostEvent_SystemUiForXBOX(3, 7)
    PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:EraseAllEffect()
    PaGlobal_SelfPlayerExpGage._ui._StaticText_ContributeP:AddEffect("UI_LevelUP_Skill", false, 0, 0)
  end
  lastContRate = cont_expRate
  lastRemainExplorePoint = tostring(explorePoint:getRemainedPoint())
  lastExplorePoint = tostring(explorePoint:getAquiredPoint())
end
function UserLevel_Update()
  PaGlobal_SelfPlayerExpGage:UserLevel_Update()
end
function PaGlobalFunc_SelfPlayerExpGage_SetShow(isShow, isAni)
  Panel_SelfPlayerExpGage:SetShow(isShow, isAni)
end
Panel_SelfPlayerExpGage_CharacterInfoWindowUpdate()
PaGlobal_SelfPlayerExpGage:UserLevel_Update()
UserSkillPoint_Update()
wpPoint_UpdateFunc()
contributePoint_UpdateFunc()
