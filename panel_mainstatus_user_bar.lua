Panel_MainStatus_User_Bar:RegisterShowEventFunc(true, "mainStatus_AniOpen()")
Panel_MainStatus_User_Bar:RegisterShowEventFunc(false, "mainStatus_AniClose()")
local UI_classType = CppEnums.ClassType
PaGlobal_MainStatus_User_Bar = {
  _combatResource_EP_RG = 0,
  _combatResource_EP_DE = 1,
  _combatResource_FP = 2,
  _combatResource_BP = 3,
  _combatResource_MP = 4,
  _ui = {
    _gaugePanel = Panel_MainStatus_User_Bar,
    _staticGauge_HP = UI.getChildControl(Panel_MainStatus_User_Bar, "Progress2_Hp"),
    _staticGauge_CombatResource = UI.getChildControl(Panel_MainStatus_User_Bar, "Progress2_Mp"),
    _dangerPanel = Panel_Danger,
    _alertDanger = UI.getChildControl(Panel_Danger, "Static_Alert"),
    _blackSpirit = UI.getChildControl(Panel_MainStatus_User_Bar, "Progress2_BlackSpirit"),
    _blackSpiritText = UI.getChildControl(Panel_MainStatus_User_Bar, "StaticText_BlackSpiritPercent")
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
function PaGlobal_MainStatus_User_Bar:Initialize()
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
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 2, 144, 306, 164)
    },
    [self._combatResource_EP_DE] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 2, 280, 307, 301)
    },
    [self._combatResource_FP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 2, 165, 306, 185)
    },
    [self._combatResource_BP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 2, 207, 306, 227)
    },
    [self._combatResource_MP] = {
      setTextureUV_Func(self._ui._staticGauge_CombatResource, 2, 186, 306, 206)
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
  self._ui._gaugePanel:SetShow(false)
  self._isLoad = true
  self._ui._gaugePanel:SetIgnore(true)
  self._ui._blackSpirit:SetIgnore(false)
  self._ui._blackSpirit:SetShow(true)
  self._ui._blackSpiritText:SetShow(true)
end
function PaGlobal_MainStatus_User_Bar:Update()
  self:UpdateHp()
  self:UpdateMp()
  FGlobal_SettingMpBarTemp()
end
function PaGlobal_MainStatus_User_Bar:LoadHpBar()
  self._ui._hpGaugeHead = UI.getChildControl(self._ui._staticGauge_HP, "Progress2_1_Bar_Head")
  self._ui.hpGaugeMaxSize = self._ui._staticGauge_HP:GetSizeX()
  self._ui._staticGauge_HP:SetShow(true)
  self._ui._hpGaugeHead:SetShow(true)
  self._ui._staticGauge_HP:ChangeTextureInfoName("new_ui_common_forlua/default/console_progressbar_00.dds")
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._ui._staticGauge_HP, 2, 123, 328, 143)
  self._ui._staticGauge_HP:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  self._ui._staticGauge_HP:setRenderTexture(self._ui._staticGauge_HP:getBaseTexture())
  self._hpEffectName = "fUI_Gauge_Red"
  self._ui._staticGauge_HP:AddEffect(self._hpEffectName, false, 0, 0)
  self._ui._staticGauge_HP:SetProgressRate(100)
  self._ui._staticGauge_HP:SetAlpha(1)
end
function PaGlobal_MainStatus_User_Bar:LoadMpBar()
  self._ui._mpGaugeHead = UI.getChildControl(self._ui._staticGauge_CombatResource, "Progress2_2_Bar_Head")
  self._ui._staticGauge_CombatResource:SetShow(true)
  self._ui._mpGaugeHead:SetShow(true)
  local resourceIndex = self:GetCombatResourceType(self._playerWrapper:getClassType())
  self:ChangeCombatResource(resourceIndex)
  self._combatResourceEffectName = self:GetEffectName(resourceIndex)
  self._ui._staticGauge_CombatResource:AddEffect(self._combatResourceEffectName, false, 0, 0)
  self._ui._staticGauge_CombatResource:SetProgressRate(100)
  self._ui._staticGauge_CombatResource:SetAlpha(1)
end
function PaGlobal_MainStatus_User_Bar:SetPostion(posX, posY)
  self._ui._gaugePanel:SetPosX(posX)
  self._ui._gaugePanel:SetPosY(posY)
end
function PaGlobal_MainStatus_User_Bar:GetCombatResourceType(classType)
  local resourceType = self._combatResourceTypeList[classType]
  if nil ~= resourceType then
    return resourceType
  else
    return self._combatResource_MP
  end
end
function PaGlobal_MainStatus_User_Bar:ChangeCombatResource(index)
  self._ui._staticGauge_CombatResource:ChangeTextureInfoName("new_ui_common_forlua/default/console_progressbar_00.dds")
  local data = self._uvDataList[index]
  if nil == data then
    data = self._uvDataList[self._combatResource_MP]
  end
  self._ui._staticGauge_CombatResource:getBaseTexture():setUV(data[1], data[2], data[3], data[4])
  self._ui._staticGauge_CombatResource:setRenderTexture(self._ui._staticGauge_CombatResource:getBaseTexture())
end
function PaGlobal_MainStatus_User_Bar:GetEffectName(index)
  if self._combatResource_EP_RG == index then
    return "fUI_Gauge_Green"
  elseif self._combatResource_EP_DE == index then
    return "fUI_Gauge_Green"
  elseif self._combatResource_FP == index then
    return "fUI_Gauge_Mental"
  elseif self._combatResource_BP == index then
    return "fUI_Gauge_Blue"
  elseif self._combatResource_MP == index then
    return "fUI_Gauge_Blue"
  else
    return "fUI_Gauge_Blue"
  end
end
function PaGlobal_MainStatus_User_Bar:SendWarningMessage()
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
function PaGlobal_MainStatus_User_Bar:UpdateHp()
  local hp = math.floor(self._player:getHp())
  local maxHp = math.floor(self._player:getMaxHp())
  self._percentHP = hp / maxHp * 100
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
function PaGlobal_MainStatus_User_Bar:UpdateMp()
  local mp = math.floor(self._player:getMp())
  local maxMp = math.floor(self._player:getMaxMp())
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
function PaGlobal_MainStatus_User_Bar:CheckHpAlert(hp, maxHp, isLevelUp)
  if Defines.UIMode.eUIMode_Default ~= GetUIMode() then
    return
  end
  if self._alertHpValue < self._percentHP then
    self:DangerPanelSetShow(false)
  else
    self:DangerPanelSetShow(true)
  end
end
function PaGlobal_MainStatus_User_Bar:DangerPanelSetShow(isShow)
  self._ui._alertDanger:SetShow(isShow)
  self._ui._dangerPanel:SetShow(isShow)
end
function PaGlobal_MainStatus_User_Bar:RegistMessageHandler()
  registerEvent("EventCharacterInfoUpdate", "Panel_MainStatus_User_Bar_Update")
  registerEvent("FromClient_SelfPlayerHpChanged", "Panel_MainStatus_User_Bar_Update")
  registerEvent("FromClient_SelfPlayerMpChanged", "Panel_MainStatus_User_Bar_Update")
  registerEvent("onScreenResize", "Panel_MainStatus_User_Bar_Onresize")
  registerEvent("EventSelfPlayerLevelUp", "Panel_MainStatus_User_Bar_RefreshHpBar")
  registerEvent("FromClient_DamageByOtherPlayer", "Panel_MainStatus_User_Bar_DamageByOtherPlayer")
  self._ui._blackSpirit:addInputEvent("Mouse_On", "PaGlobal_MainStatus_User_Bar:ShowAdrenallinTooltip( true )")
  self._ui._blackSpirit:addInputEvent("Mouse_Out", "PaGlobal_MainStatus_User_Bar:ShowAdrenallinTooltip( false )")
  self._ui._blackSpirit:setTooltipEventRegistFunc("PaGlobal_MainStatus_User_Bar:ShowAdrenallinTooltip( true )")
end
function PaGlobal_MainStatus_User_Bar:SetAlphaAll(alphaReate)
  self._ui._gaugePanel:SetAlpha(alphaReate)
  self._ui._staticGauge_HP:SetAlpha(alphaReate)
  self._ui._staticGauge_CombatResource:SetAlpha(alphaReate)
  self._ui._blackSpirit:SetAlpha(alphaReate)
  self._ui._blackSpiritText:SetAlpha(alphaReate)
end
function Panel_MainStatus_User_Bar_Update()
  PaGlobal_MainStatus_User_Bar:Update()
end
function PaGlobalFunc_UserBar_Onresize()
  local self = PaGlobal_MainStatus_User_Bar
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  local gapX = -10
  local gapY = 10
  self._ui._dangerPanel:SetPosX(0)
  self._ui._alertDanger:SetSize(screenSizeX, screenSizeY)
  self._ui._gaugePanel:ComputePos()
  if self._ui._gaugePanel:GetRelativePosX() == -1 and self._ui._gaugePanel:GetRelativePosY() == -1 then
    local initPosX = screenSizeX / 2 - self._ui._gaugePanel:GetSizeX() / 2
    local initPosY = screenSizeY - Panel_QuickSlot:GetSizeY() - self._ui._gaugePanel:GetSizeY()
    self._ui._gaugePanel:SetPosX(initPosX + gapX)
    self._ui._gaugePanel:SetPosY(initPosY + gapY)
    changePositionBySever(self._ui._gaugePanel, CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar, true, true, false)
    FGlobal_InitPanelRelativePos(self._ui._gaugePanel, initPosX, initPosY)
  elseif self._ui._gaugePanel:GetRelativePosX() == 0 and self._ui._gaugePanel:GetRelativePosY() == 0 then
    self._ui._gaugePanel:SetPosX(screenSizeX / 2 - self._ui._gaugePanel:GetSizeX() / 2 + gapX)
    self._ui._gaugePanel:SetPosY(screenSizeY - Panel_QuickSlot:GetSizeY() - self._ui._gaugePanel:GetSizeY() + gapY)
  else
    self._ui._gaugePanel:SetPosX(screenSizeX * self._ui._gaugePanel:GetRelativePosX() - self._ui._gaugePanel:GetSizeX() / 2 + gapX)
    self._ui._gaugePanel:SetPosY(screenSizeY * self._ui._gaugePanel:GetRelativePosY() - self._ui._gaugePanel:GetSizeY() / 2 + gapY)
  end
  if 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved) then
    self._ui._gaugePanel:SetShow(false)
  end
  if screenSizeX < self._ui._gaugePanel:GetPosX() or screenSizeY < self._ui._gaugePanel:GetPosY() then
    self._ui._gaugePanel:ComputePos()
    self._ui._gaugePanel:SetPosX(screenSizeX / 2 - self._ui._gaugePanel:GetSizeX() / 2 + gapX)
    self._ui._gaugePanel:SetPosY(screenSizeY - Panel_QuickSlot:GetSizeY() - self._ui._gaugePanel:GetSizeY() + gapY)
  end
  FGlobal_PanelRepostionbyScreenOut(self._ui._gaugePanel)
end
function Panel_MainStatus_User_Bar_RefreshHpBar()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = math.floor(player:getHp())
  local maxHp = math.floor(player:getMaxHp())
  PaGlobal_MainStatus_User_Bar:CheckHpAlert(hp, maxHp, true)
end
function PaGlobal_MainStatus_User_Bar:LoadBurnEffect()
  if true == self._burnEffectOn then
    return
  end
  self._ui._staticGauge_HP:EraseAllEffect()
  self._burnEffectKey = self._ui._staticGauge_HP:AddEffect("fUI_Gauge_PvP", false, 0, 0)
  self._burnEffectOn = true
  self._burnEffectStartTime = FGlobal_getLuaLoadTime()
end
function PaGlobal_MainStatus_User_Bar:CheckHpAlertPostEvent()
  self:CheckHpAlert(1, 1, false)
end
function Panel_MainStatus_User_Bar_DamageByOtherPlayer()
  PaGlobal_MainStatus_User_Bar:LoadBurnEffect()
end
function DamageByOtherPlayer_chkOnEffectTime(DeltaTime)
  local self = PaGlobal_MainStatus_User_Bar
  if false == self._burnEffectOn then
    return
  end
  local startTime = self._burnEffectStartTime
  if startTime + self._burnEffectDuringTime < FGlobal_getLuaLoadTime() then
    self._ui._staticGauge_HP:EraseEffect(self._burnEffectKey)
    self._burnEffectOn = false
  end
end
function renderModeChange_checkHpAlertPostEvent(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderModebyGameMode(nextRenderModeList) or CheckRenderMode(prevRenderModeList, currentRenderMode) then
    PaGlobal_MainStatus_User_Bar:CheckHpAlertPostEvent()
  end
  Panel_MainStatus_User_Bar_Onresize()
end
function Panel_MainStatus_UpdateSimpleUI(DeltaTime)
  local self = PaGlobal_MainStatus_User_Bar
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
  PaGlobal_MainStatus_User_Bar:SetAlphaAll(alphaRate)
end
function Panel_MainStatus_EnableSimpleUI()
  PaGlobal_MainStatus_User_Bar._simpleUIFadeRate = 1
  PaGlobal_MainStatus_User_Bar:SetAlphaAll(1)
end
function Panel_MainStatus_DisableSimpleUI()
  PaGlobal_MainStatus_User_Bar._simpleUIFadeRate = 1
  PaGlobal_MainStatus_User_Bar:SetAlphaAll(1)
end
function PaGlobal_MainStatus_User_Bar:SetShowAll()
  self._ui._gaugePanel:SetShow(false, true)
  self._ui._gaugePanel:AddEffect("UI_Tuto_Hp_1", false, 0, -4)
  self._ui._gaugePanel:AddEffect("fUI_Tuto_Hp_01A", false, 0, -4)
  self._ui._staticGauge_HP:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
  self._ui._staticGauge_HP:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
  self._ui._staticGauge_CombatResource:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
  self._ui._staticGauge_CombatResource:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
end
function PaGlobal_MainStatus_User_Bar:SetPrevHP(value)
  self._prevHP = value
end
function PaGlobal_MainStatus_User_Bar:SetFadeRate(value)
  self._simpleUIFadeRate = value
end
function mainStatus_AniOpen()
  local self = PaGlobal_MainStatus_User_Bar
  self._ui._gaugePanel:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local MainStatusOpen_Alpha = self._ui._gaugePanel:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  MainStatusOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  MainStatusOpen_Alpha.IsChangeChild = true
end
function mainStatus_AniClose()
  local self = PaGlobal_MainStatus_User_Bar
  self._ui._gaugePanel:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local MainStatusClose_Alpha = self._ui._gaugePanel:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  MainStatusClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  MainStatusClose_Alpha.IsChangeChild = true
  MainStatusClose_Alpha:SetHideAtEnd(true)
  MainStatusClose_Alpha:SetDisableWhileAni(true)
end
PaGlobal_MainStatus_User_Bar:Initialize()
PaGlobal_MainStatus_User_Bar:RegistMessageHandler()
Panel_MainStatus_User_Bar:RegisterUpdateFunc("DamageByOtherPlayer_chkOnEffectTime")
registerEvent("SimpleUI_UpdatePerFrame", "Panel_MainStatus_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_MainStatus_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_MainStatus_DisableSimpleUI")
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_checkHpAlertPostEvent")
changePositionBySever(Panel_MainStatus_User_Bar, CppEnums.PAGameUIType.PAGameUIPanel_MainStatusBar, true, true, false)
function PaGlobal_MainStatus_User_Bar:UpdateAdreanllin()
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
function PaGlobal_MainStatus_User_Bar_Update_Adrenalin()
  PaGlobal_MainStatus_User_Bar:UpdateAdreanllin()
end
function PaGlobal_MainStatus_User_Bar_Change_Adrenalin_Mode()
  PaGlobal_MainStatus_User_Bar:UpdateAdreanllin()
end
function PaGlobal_MainStatus_User_Bar:ShowAdrenallinTooltip(isShow)
  registTooltipControl(self._ui._blackSpirit, Panel_Tooltip_SimpleText)
  if true == isShow then
    TooltipSimple_Show(self._ui._blackSpirit, self._blackSpritTooltipTitle, self._blackSpritTooltipDesc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_MainStatus_User_Bar_Check_Adrenalin_PostEvent(prevRenderModeList, nextRenderModeList)
  if false == CheckRenderModebyGameMode(nextRenderModeList) then
    return
  end
  PaGlobal_MainStatus_User_Bar_Change_Adrenalin_Mode()
end
registerEvent("FromClient_UpdateAdrenalin", "PaGlobal_MainStatus_User_Bar_Update_Adrenalin")
registerEvent("FromClient_ChangeAdrenalinMode", "PaGlobal_MainStatus_User_Bar_Change_Adrenalin_Mode")
registerEvent("FromClient_RenderModeChangeState", "PaGlobal_MainStatus_User_Bar_Check_Adrenalin_PostEvent")
PaGlobal_MainStatus_User_Bar:UpdateAdreanllin()
local super = Panel_MainStatus_User_Bar
local aniPosX = getScreenSizeX() / 2 - (super:GetSizeX() / 2 - 10)
local aniPosY = getScreenSizeY() - Panel_QuickSlot:GetSizeY() - super:GetSizeY() + 10
function status_simplify_Show()
  super:ResetVertexAni(true)
  local aniInfo1 = super:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartPosition(aniPosX, getScreenSizeY())
  aniInfo1:SetEndPosition(aniPosX, aniPosY)
  aniInfo1.IsChangeChild = true
end
function status_simplify_Hide()
  super:ResetVertexAni(true)
  local aniInfo1 = super:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartPosition(super:GetPosX(), super:GetPosY())
  aniInfo1:SetEndPosition(aniPosX, getScreenSizeY())
  aniInfo1.IsChangeChild = true
end
registerEvent("FromClient_simplify_Show", "status_simplify_Hide")
registerEvent("FromClient_simplify_Hide", "status_simplify_Show")
