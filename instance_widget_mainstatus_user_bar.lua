Instance_Widget_MainStatus_User_Bar:RegisterShowEventFunc(true, "mainStatus_AniOpen()")
Instance_Widget_MainStatus_User_Bar:RegisterShowEventFunc(false, "mainStatus_AniClose()")
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local UI_color = Defines.Color
local UI_classType = CppEnums.ClassType
local _damageByOtherPlayer_Time = 0
local now_HpBarBurn = false
local HpBarBurnTimer = 0
local prevHp = 0
local prevHpAlertTime = 0
local _alertDanger = UI.getChildControl(Instance_DangerAlert, "Static_Alert")
local _alertGauge = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_GaugeAlert")
local _gauge100per = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_100per")
local mainBarText = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "StaticText_MainBarText")
local SimpleUIFadeRate = 1
local selfPlayerStatusBar = {
  _staticHP_BG = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_HP_MainBG"),
  _staticMP_BG = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_MP_MainBG"),
  _staticText_HP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "StaticText_HP"),
  _staticText_MP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "StaticText_MP"),
  _staticTexture_MP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_MP"),
  _staticTexture_FP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_FP"),
  _staticTexture_CP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_CP"),
  _staticTexture_EP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_EP"),
  _staticTexture_BP = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_BP"),
  _staticTexture_Dark = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Texture_Dark"),
  _staticGage_CombatResource = nil,
  _staticGageLater_CombatResource = nil,
  _staticGageLater_CombatResourceHead = nil,
  define = {
    MP = 0,
    FP = 1,
    EP = 2,
    BP = 3,
    DK = 4,
    COLOR_BLIND = 5
  },
  _combatResources = {},
  _combatResources_Later = {},
  config = {hpGageMaxSize = 0, mpGageMaxSize = 0},
  posX = Instance_Widget_MainStatus_User_Bar:GetPosX(),
  posY = Instance_Widget_MainStatus_User_Bar:GetPosY(),
  initPosX = Instance_Widget_MainStatus_User_Bar:GetPosX(),
  initPosY = Instance_Widget_MainStatus_User_Bar:GetPosY()
}
Instance_DangerAlert:SetIgnore(true)
_alertDanger:SetIgnore(true)
_gauge100per:SetIgnore(true)
selfPlayerStatusBar._staticHP_BG:SetIgnore(false)
selfPlayerStatusBar._staticMP_BG:SetIgnore(false)
local eIconBack = {on = 0, off = 1}
local iconBackUV = {
  [eIconBack.on] = float4(1, 176, 68, 243),
  [eIconBack.off] = float4(69, 176, 136, 243)
}
local classIconUV = {
  [CppEnums.ClassType.ClassType_Warrior] = float4(137, 176, 175, 214),
  [CppEnums.ClassType.ClassType_Ranger] = float4(176, 176, 214, 214),
  [CppEnums.ClassType.ClassType_Sorcerer] = float4(215, 176, 253, 214),
  [CppEnums.ClassType.ClassType_Giant] = float4(254, 176, 292, 214),
  [CppEnums.ClassType.ClassType_Tamer] = float4(293, 176, 331, 214),
  [CppEnums.ClassType.ClassType_BladeMaster] = float4(332, 176, 370, 214),
  [CppEnums.ClassType.ClassType_Valkyrie] = float4(371, 176, 409, 214),
  [CppEnums.ClassType.ClassType_BladeMasterWomen] = float4(410, 176, 448, 214),
  [CppEnums.ClassType.ClassType_Wizard] = float4(137, 215, 175, 253),
  [CppEnums.ClassType.ClassType_WizardWomen] = float4(176, 215, 214, 253),
  [CppEnums.ClassType.ClassType_NinjaWomen] = float4(215, 215, 253, 253),
  [CppEnums.ClassType.ClassType_NinjaMan] = float4(254, 215, 292, 253),
  [CppEnums.ClassType.ClassType_DarkElf] = float4(293, 215, 331, 253),
  [CppEnums.ClassType.ClassType_Combattant] = float4(332, 215, 370, 253),
  [CppEnums.ClassType.ClassType_CombattantWomen] = float4(371, 215, 409, 253),
  [CppEnums.ClassType.ClassType_Lahn] = float4(410, 215, 448, 253),
  [CppEnums.ClassType.ClassType_Orange] = float4(137, 254, 175, 292)
}
local _hpGaugeHead, _mpGaugeHead, _fpGaugeHead, _epGaugeHead, _bpGaugeHead, _darkGaugeHead, _colorBlindGaugeHead
local _hpGauge_Back = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_HPGage_Back")
local _mpGauge_Back = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_MPGage_Back")
function selfPlayerStatusBar:loadResource()
  local _gauge = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Gauge")
  self._staticGage_HP = UI.getChildControl(_gauge, "Progress_HPGauge")
  self._combatResources[self.define.MP] = UI.getChildControl(_gauge, "Progress_MPGauge")
  self._combatResources[self.define.FP] = UI.getChildControl(_gauge, "Progress_FPGauge")
  self._combatResources[self.define.EP] = UI.getChildControl(_gauge, "Progress_EPGauge")
  self._combatResources[self.define.BP] = UI.getChildControl(_gauge, "Progress_BPGauge")
  self._combatResources[self.define.DK] = UI.getChildControl(_gauge, "Progress_DKGauge")
  self._combatResources[self.define.COLOR_BLIND] = UI.getChildControl(_gauge, "Progress_ColorBlindGauge")
  local _gaugeLater = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_GaugeLater")
  self._staticGage_HP_Later = UI.getChildControl(_gaugeLater, "Progress2_HpGaugeLater")
  self._combatResources_Later[self.define.MP] = UI.getChildControl(_gaugeLater, "Progress2_MpGaugeLater")
  self._combatResources_Later[self.define.FP] = UI.getChildControl(_gaugeLater, "Progress2_FpGaugeLater")
  self._combatResources_Later[self.define.EP] = UI.getChildControl(_gaugeLater, "Progress2_EpGaugeLater")
  self._combatResources_Later[self.define.BP] = UI.getChildControl(_gaugeLater, "Progress2_BpGaugeLater")
  self._combatResources_Later[self.define.DK] = UI.getChildControl(_gaugeLater, "Progress2_DKGaugeLater")
  self._combatResources_Later[self.define.COLOR_BLIND] = self._combatResources_Later[self.define.DK]
  local _textValue = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_text_value")
  self._staticShowHp = UI.getChildControl(_textValue, "StaticText_HPText")
  self._staticShowMp = UI.getChildControl(_textValue, "StaticText_MPText")
  self._stc_classIconBack = UI.getChildControl(Instance_Widget_MainStatus_User_Bar, "Static_Class_IconBack")
  self._stc_classIcon = UI.getChildControl(self._stc_classIconBack, "Static_ClassIcon")
  _hpGaugeHead = UI.getChildControl(self._staticGage_HP, "Progress_HPHead")
  _mpGaugeHead = UI.getChildControl(self._combatResources[self.define.MP], "Progress_MPHead")
  _fpGaugeHead = UI.getChildControl(self._combatResources[self.define.FP], "Progress_FPHead")
  _epGaugeHead = UI.getChildControl(self._combatResources[self.define.EP], "Progress_EPHead")
  _bpGaugeHead = UI.getChildControl(self._combatResources[self.define.BP], "Progress_BPHead")
  _darkGaugeHead = UI.getChildControl(self._combatResources[self.define.DK], "Progress_DarkHead")
  _colorBlindGaugeHead = UI.getChildControl(self._combatResources[self.define.COLOR_BLIND], "Progress_ColorBlindHead")
end
function selfPlayerStatusBar:init()
  self:loadResource()
  self._staticGage_CombatResource = self._combatResources[self.define.MP]
  self._staticGageLater_CombatResource = self._combatResources_Later[self.define.MP]
  self._staticGageLater_CombatResourceHead = _mpGaugeHead
  self.config.hpGageMaxSize = self._staticGage_HP:GetSizeX()
  self.config.mpGageMaxSize = self._staticGage_CombatResource:GetSizeX()
  Instance_Widget_MainStatus_User_Bar:addInputEvent("Mouse_PressMove", "SelfPlayerStatusBar_RefleshPosition()")
  Instance_Widget_MainStatus_User_Bar:addInputEvent("Mouse_LUp", "SelfPlayerStatusBar_RefleshPosition()")
  self._staticShowHp:SetShow(true)
  self._staticShowMp:SetShow(true)
  self:setClassType()
end
function selfPlayerStatusBar:checkLoad()
  UI.ASSERT(nil ~= self._staticText_HP and self._staticText_HP.__name == "PAUIStatic", "Fail to load control")
  UI.ASSERT(nil ~= self._staticText_MP and self._staticText_MP.__name == "PAUIStatic", "Fail to load control")
end
function selfPlayerStatusBar:resourceTypeCheck(selfPlayerWrapper)
  local resourceType = selfPlayerWrapper:getCombatResourceType()
  local classType = selfPlayerWrapper:getClassType()
  if classType == CppEnums.ClassType.ClassType_DarkElf then
    resourceType = 4
  end
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  for _, control in pairs(self._combatResources) do
    control:SetShow(false)
  end
  if 0 == isColorBlindMode then
    if resourceType >= self.define.MP then
      self._staticGage_CombatResource = self._combatResources[resourceType]
      self._staticGageLater_CombatResource = self._combatResources_Later[resourceType]
    end
  elseif 1 == isColorBlindMode then
    self._staticGage_CombatResource = self._combatResources[self.define.COLOR_BLIND]
    self._staticGageLater_CombatResource = self._combatResources_Later[self.define.COLOR_BLIND]
  elseif 2 == isColorBlindMode then
    self._staticGage_CombatResource = self._combatResources[self.define.COLOR_BLIND]
    self._staticGageLater_CombatResource = self._combatResources_Later[self.define.COLOR_BLIND]
  end
  self._staticGage_CombatResource:SetShow(true)
  self._staticGageLater_CombatResource:SetShow(true)
end
function selfPlayerStatusBar:setClassType()
  local playerWrapper = getSelfPlayer()
  local classType = playerWrapper:getClassType()
  local strTextureName
  local classUV = classIconUV[classType]
  local x1, y1, x2, y2
  if nil == classUV then
    self._stc_classIcon:SetShow(false)
  else
    self._stc_classIcon:SetShow(true)
    local classX1, classY1, classX2, classY2 = setTextureUV_Func(self._stc_classIcon, classUV.x, classUV.y, classUV.z, classUV.w)
    self._stc_classIcon:getBaseTexture():setUV(classX1, classY1, classX2, classY2)
    self._stc_classIcon:setRenderTexture(self._stc_classIcon:getBaseTexture())
    self._stc_classIcon:ComputePos()
  end
end
local prevHP = -1
local prevMaxHP = -1
local prevMP = -1
local prevMaxMP = -1
local screenSizeX = getScreenSizeX()
local screenSizeY = getScreenSizeY()
local strongMonsterAlert = false
local function checkHpAlert(hp, maxHp, isLevelUp)
  local isUpdate = Defines.UIMode.eUIMode_Default == GetUIMode()
  if false == isUpdate then
    _alertDanger:SetShow(false)
    return
  end
  if false == global_danger_MessageShow and false == isLevelUp then
    return
  end
  local totalHp = hp / maxHp * 100
  if totalHp <= 99.99 and false == strongMonsterAlert then
    _hpGaugeHead:SetShow(true)
  end
  if totalHp == 100 and false == strongMonsterAlert then
    _hpGaugeHead:SetShow(false)
  end
  if totalHp >= 40 and false == strongMonsterAlert then
    selfPlayerStatusBar._staticText_HP:SetFontColor(UI_color.C_FFF0EF9D)
    Instance_DangerAlert:SetShow(false, false)
    _alertDanger:SetAlpha(0)
  end
  if totalHp <= 39 and totalHp >= 20 then
    selfPlayerStatusBar._staticText_HP:SetFontColor(UI_color.C_FFF26A6A)
    if false == Instance_DangerAlert:GetShow() then
      Instance_DangerAlert:SetShow(true, false)
      _alertDanger:SetAlpha(1)
    end
    if false == _alertDanger:GetShow() then
      _alertDanger:SetShow(true)
    end
    _alertDanger:SetVertexAniRun("Ani_Color_Danger0", true)
  end
  if totalHp <= 19 and totalHp >= 0 then
    if false == Instance_DangerAlert:GetShow() then
      Instance_DangerAlert:SetShow(true, false)
      _alertDanger:SetAlpha(1)
    end
    if false == _alertDanger:GetShow() then
      _alertDanger:SetShow(true)
    end
    _alertDanger:SetVertexAniRun("Ani_Color_Danger1", true)
  end
end
function PaGlobalFunc_DangerAlert_Show(isShow)
  if false == isShow then
    Instance_DangerAlert:SetShow(false, false)
    strongMonsterAlert = false
    return
  end
  strongMonsterAlert = true
  if true ~= Instance_DangerAlert:GetShow() then
    Instance_DangerAlert:SetShow(true, false)
    _alertDanger:SetAlpha(1)
  end
  if false == _alertDanger:GetShow() then
    _alertDanger:SetShow(true)
  end
  _alertDanger:SetVertexAniRun("Ani_Color_Danger1", true)
end
function PaGlobalFunc_CheckHpAlertPostEvent()
  checkHpAlert(1, 1, false)
end
function renderModeChange_checkHpAlertPostEvent(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderModebyGameMode(nextRenderModeList) or CheckRenderMode(prevRenderModeList, currentRenderMode) then
    PaGlobalFunc_CheckHpAlertPostEvent()
  end
  PaGlobalFunc_UserBar_Onresize()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_checkHpAlertPostEvent")
local function checkMpAlert(mp, maxMp)
  local totalMp = mp / maxMp * 100
  if totalMp <= 99.99 then
    _fpGaugeHead:SetShow(true)
    _mpGaugeHead:SetShow(true)
    _epGaugeHead:SetShow(true)
    _bpGaugeHead:SetShow(true)
    _darkGaugeHead:SetShow(true)
    _colorBlindGaugeHead:SetShow(true)
  end
  if totalMp == 100 then
    _fpGaugeHead:SetShow(false)
    _mpGaugeHead:SetShow(false)
    _epGaugeHead:SetShow(false)
    _bpGaugeHead:SetShow(false)
    _darkGaugeHead:SetShow(false)
    _colorBlindGaugeHead:SetShow(false)
  end
end
function DamageByOtherPlayer()
  if now_HpBarBurn == false then
    now_HpBarBurn = selfPlayerStatusBar._staticHP_BG:EraseAllEffect()
    now_HpBarBurn = selfPlayerStatusBar._staticHP_BG:AddEffect("fUI_Gauge_PvP", false, 0, 0)
    HpBarBurnTimer = 0
  end
end
function DamageByOtherPlayer_chkOnEffectTime(DeltaTime)
  HpBarBurnTimer = HpBarBurnTimer + DeltaTime
  if HpBarBurnTimer > 10 and now_HpBarBurn ~= false then
    selfPlayerStatusBar._staticHP_BG:EraseEffect(now_HpBarBurn)
    now_HpBarBurn = false
    HpBarBurnTimer = 0
  end
  if HpBarBurnTimer > 12 then
    HpBarBurnTimer = 0
  end
end
function Panel_MainStatus_EnableSimpleUI()
  SimpleUIFadeRate = 1
  Panel_MainStatus_SetAlphaAllChild(1)
end
function Panel_MainStatus_DisableSimpleUI()
  SimpleUIFadeRate = 1
  Panel_MainStatus_SetAlphaAllChild(1)
end
function Panel_MainStatus_UpdateSimpleUI(DeltaTime)
  SimpleUIFadeRate = SimpleUIFadeRate - DeltaTime
  if SimpleUIFadeRate < 0 then
    SimpleUIFadeRate = 0
  end
  if getPvPMode() then
    SimpleUIFadeRate = 1
  end
  local alphaRate = SimpleUIFadeRate
  if alphaRate > 1 then
    alphaRate = 1
  end
  Panel_MainStatus_SetAlphaAllChild(alphaRate)
end
registerEvent("SimpleUI_UpdatePerFrame", "Panel_MainStatus_UpdateSimpleUI")
registerEvent("EventSimpleUIEnable", "Panel_MainStatus_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "Panel_MainStatus_DisableSimpleUI")
function Panel_MainStatus_SetAlphaAllChild(alphaRate)
  local self = selfPlayerStatusBar
  Instance_Widget_MainStatus_User_Bar:SetAlpha(alphaRate)
  self._staticHP_BG:SetAlpha(alphaRate)
  self._staticMP_BG:SetAlpha(alphaRate)
  self._staticText_HP:SetAlpha(alphaRate)
  self._staticText_MP:SetAlpha(alphaRate)
  self._staticTexture_MP:SetAlpha(alphaRate)
  self._staticTexture_FP:SetAlpha(alphaRate)
  self._staticTexture_CP:SetAlpha(alphaRate)
  self._staticTexture_EP:SetAlpha(alphaRate)
  self._staticTexture_BP:SetAlpha(alphaRate)
  self._staticTexture_Dark:SetAlpha(alphaRate)
  self._staticGage_HP:SetAlpha(alphaRate)
  self._staticGage_HP_Later:SetAlpha(alphaRate)
  self._staticGage_CombatResource:SetAlpha(alphaRate)
  self._staticGageLater_CombatResource:SetAlpha(alphaRate)
  self._staticGageLater_CombatResourceHead:SetAlpha(alphaRate)
  _hpGaugeHead:SetAlpha(alphaRate)
  _mpGaugeHead:SetAlpha(alphaRate)
  _fpGaugeHead:SetAlpha(alphaRate)
  _epGaugeHead:SetAlpha(alphaRate)
  _bpGaugeHead:SetAlpha(alphaRate)
  _darkGaugeHead:SetAlpha(alphaRate)
  _colorBlindGaugeHead:SetAlpha(alphaRate)
  _hpGauge_Back:SetAlpha(alphaRate)
  _mpGauge_Back:SetAlpha(alphaRate)
  self._staticShowHp:SetFontAlpha(alphaRate)
  self._staticShowMp:SetFontAlpha(alphaRate)
end
function FGlobal_MainStatus_FadeIn(viewTime)
  SimpleUIFadeRate = viewTime
end
Instance_Widget_MainStatus_User_Bar:RegisterUpdateFunc("DamageByOtherPlayer_chkOnEffectTime")
function FGlobal_UserBar_ImmediatelyResurrection(resurrFunc)
  prevHp = resurrFunc
end
function PaGlobalFunc_UserBar_CharacterInfoWindowUpdate()
  local self = selfPlayerStatusBar
  local playerWrapper = getSelfPlayer()
  local classType = playerWrapper:getClassType()
  local player = playerWrapper:get()
  local regionKeyRaw = playerWrapper:getRegionKeyRaw()
  local regionWrapper = getRegionInfoWrapper(regionKeyRaw)
  local isArenaZone = regionWrapper:get():isArenaZone()
  self:resourceTypeCheck(playerWrapper)
  local hp = math.floor(player:getHp())
  local maxHp = math.floor(player:getMaxHp())
  local percentHp = math.floor(hp / maxHp * 100)
  if percentHp < 20 and hp < prevHp and prevHpAlertTime + 20 <= FGlobal_getLuaLoadTime() and not isArenaZone then
    local sendMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTER_HP_WARNING_SUB"),
      addMsg = ""
    }
    prevHpAlertTime = FGlobal_getLuaLoadTime()
  end
  prevHp = hp
  if 0 ~= maxHp and (hp ~= prevHP or maxHp ~= prevMaxHP) then
    self._staticShowHp:SetText(tostring(hp) .. " / " .. tostring(maxHp))
    self._staticGage_HP_Later:SetProgressRate(hp / maxHp * 100)
    self._staticGage_HP:SetProgressRate(hp / maxHp * 100)
    if hp - prevHP > 5 then
      local HP_BG_PosX = self._staticHP_BG:GetPosX()
      local HP_BG_PosY = self._staticHP_BG:GetPosY()
      self._staticGage_HP:AddEffect("fUI_Gauge_Red", false, 0, 0)
    end
    FGlobal_MainStatus_FadeIn(5)
    prevHP = hp
    prevMaxHP = maxHp
    checkHpAlert(hp, maxHp, false)
  end
  local effectName = ""
  local isEP_Character = UI_classType.ClassType_Ranger == playerWrapper:getClassType() or UI_classType.ClassType_Orange == playerWrapper:getClassType()
  local isFP_Character = UI_classType.ClassType_Warrior == playerWrapper:getClassType() or UI_classType.ClassType_Giant == playerWrapper:getClassType() or UI_classType.ClassType_BladeMaster == playerWrapper:getClassType() or UI_classType.ClassType_BladeMasterWomen == playerWrapper:getClassType() or UI_classType.ClassType_NinjaWomen == playerWrapper:getClassType() or UI_classType.ClassType_Combattant == playerWrapper:getClassType() or UI_classType.ClassType_Lahn == playerWrapper:getClassType()
  local isBP_Character = UI_classType.ClassType_Valkyrie == playerWrapper:getClassType()
  local isMP_Character = not isEP_Character and not isFP_Character and not isBP_Character
  local isColorBlindMode = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eColorBlindMode)
  if isEP_Character then
    if classType == CppEnums.ClassType.ClassType_DarkElf then
      effectName = "fUI_Gauge_Green"
    else
      effectName = "fUI_Gauge_Green"
    end
  elseif isFP_Character then
    effectName = "fUI_Gauge_Mental"
  elseif isBP_Character then
    effectName = "fUI_Gauge_Blue"
  elseif isMP_Character then
    effectName = "fUI_Gauge_Blue"
  end
  local mp = player:getMp()
  _prevMPSize = mp
  local maxMp = player:getMaxMp()
  if 0 ~= maxMp then
    self._staticGage_CombatResource:SetProgressRate(mp / maxMp * 100)
    self._staticGage_CombatResource:SetShow(true)
    if mp ~= prevMP or maxMp ~= prevMaxMP then
      self._staticShowMp:SetText(tostring(mp) .. " / " .. tostring(maxMp))
      self._staticGageLater_CombatResource:SetProgressRate(mp / maxMp * 100)
      self._staticGageLater_CombatResource:SetShow(true)
      if mp - prevMP > 10 then
        local MP_BG_PosX = self._staticMP_BG:GetPosX()
        local MP_BG_PosY = self._staticMP_BG:GetPosY()
        self._staticGage_CombatResource:AddEffect(effectName, false, 0, 0)
      end
      FGlobal_MainStatus_FadeIn(5)
      prevMP = mp
      checkMpAlert(mp, maxMp)
      prevMaxMP = maxMp
    end
  end
end
local beforeMaxHp = 0
local createRulerCount = 0
local rulerControl = {}
function Panel_MainStatus_UserBar_SetRuler(maxHp)
  if beforeMaxHp ~= maxHp then
    if 1000 < math.floor(maxHp / 100) then
      if createRulerCount > 0 then
        for index = 0, createRulerCount - 1 do
          rulerControl[index]:SetShow(false)
        end
      end
      beforeMaxHp = maxHp
      return
    end
    if createRulerCount < math.floor(maxHp / 100) then
      for index = 0, math.floor(maxHp / 100) - 1 do
        if index >= createRulerCount then
          if 9 == index % 10 then
            rulerControl[index] = UI.createAndCopyBasePropertyControl(Instance_Widget_MainStatus_User_Bar, "Static_HP_1000Stick", Instance_Widget_MainStatus_User_Bar, "RulerControl_" .. index)
          else
            rulerControl[index] = UI.createAndCopyBasePropertyControl(Instance_Widget_MainStatus_User_Bar, "Static_HP_100Stick", Instance_Widget_MainStatus_User_Bar, "RulerControl_" .. index)
          end
        end
      end
      createRulerCount = math.floor(maxHp / 100)
    end
    for index = 0, createRulerCount - 1 do
      rulerControl[index]:SetShow(false)
    end
    for index = 0, createRulerCount - 1 do
      if createRulerCount > 1000 then
        break
      elseif createRulerCount > 100 then
        if 9 == index % 10 then
          rulerControl[index]:SetShow(true)
        end
      elseif createRulerCount > 40 then
        if 1 == index % 2 then
          rulerControl[index]:SetShow(true)
        end
      else
        rulerControl[index]:SetShow(true)
      end
    end
    for index = 0, createRulerCount - 1 do
      rulerControl[index]:SetPosX(5 + selfPlayerStatusBar._staticHP_BG:GetPosX() + (selfPlayerStatusBar._staticHP_BG:GetSizeX() - 12) / (createRulerCount + 1) * (index + 1))
      rulerControl[index]:SetPosY(1)
    end
    beforeMaxHp = maxHp
  end
end
function PaGlobalFunc_UserBar_Onresize()
  Instance_DangerAlert:SetPosX(0)
  _alertDanger:SetSize(getScreenSizeX(), getScreenSizeY())
  Instance_Widget_MainStatus_User_Bar:ComputePos()
  FGlobal_User_Bar_Show(true, false)
end
function refreshHpAlertForLevelup()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = math.floor(player:getHp())
  local maxHp = math.floor(player:getMaxHp())
  checkHpAlert(hp, maxHp, true)
end
function selfPlayerStatusBar:registMessageHandler()
  registerEvent("EventCharacterInfoUpdate", "PaGlobalFunc_UserBar_CharacterInfoWindowUpdate")
  registerEvent("FromClient_SelfPlayerHpChanged", "PaGlobalFunc_UserBar_CharacterInfoWindowUpdate")
  registerEvent("FromClient_SelfPlayerMpChanged", "PaGlobalFunc_UserBar_CharacterInfoWindowUpdate")
  registerEvent("onScreenResize", "PaGlobalFunc_UserBar_Onresize")
  registerEvent("EventSelfPlayerLevelUp", "refreshHpAlertForLevelup")
  registerEvent("FromClient_DamageByOtherPlayer", "DamageByOtherPlayer")
  registerEvent("FromClient_ClassChangeBattleRoyale", "FaGlobal_FromClient_ClassChangeBattleRoyale")
end
selfPlayerStatusBar:checkLoad()
selfPlayerStatusBar:init()
selfPlayerStatusBar:registMessageHandler()
function SelfPlayerStatusBar_RefleshPosition()
  selfPlayerStatusBar.posX = Instance_Widget_MainStatus_User_Bar:GetPosX()
  selfPlayerStatusBar.posY = Instance_Widget_MainStatus_User_Bar:GetPosY()
end
function SelfPlayerStatusBar_Vibrate_ByDamage(damagePercent, isbackAttack, isCritical)
  local periodTime = 0.015
  local moveCount = 6
  local randomizeValue = 7
  for idx = 0, moveCount do
    local aniInfo0 = Instance_Widget_MainStatus_User_Bar:addMoveAnimation(periodTime * idx, periodTime * (idx + 1), UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
    aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
    aniInfo0:SetStartPosition(selfPlayerStatusBar.posX + getRandomValue(-randomizeValue, randomizeValue), selfPlayerStatusBar.posY + getRandomValue(-randomizeValue, randomizeValue))
    aniInfo0:SetEndPosition(selfPlayerStatusBar.posX + getRandomValue(-randomizeValue, randomizeValue), selfPlayerStatusBar.posY + getRandomValue(-randomizeValue, randomizeValue))
  end
  local endTime = periodTime * (moveCount + 1)
  local periodTime_vertical = 0.012
  local moveCount_vertical = 4
  local randomizeValue_vertical = 8
  for idx = 0, moveCount_vertical do
    local aniInfo0 = Instance_Widget_MainStatus_User_Bar:addMoveAnimation(endTime + periodTime_vertical * idx, endTime + periodTime_vertical * (idx + 1), UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
    aniInfo0.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
    aniInfo0.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
    aniInfo0:SetStartPosition(selfPlayerStatusBar.posX, selfPlayerStatusBar.posY + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
    aniInfo0:SetEndPosition(selfPlayerStatusBar.posX, selfPlayerStatusBar.posY + getRandomValue(-randomizeValue_vertical, randomizeValue_vertical))
  end
  endTime = endTime + periodTime_vertical * (moveCount_vertical + 1)
  local aniInfo1 = Instance_Widget_MainStatus_User_Bar:addMoveAnimation(endTime, endTime + periodTime_vertical, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo1.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo1.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo1:SetStartPosition(selfPlayerStatusBar.posX, selfPlayerStatusBar.posY)
  aniInfo1:SetEndPosition(selfPlayerStatusBar.posX, selfPlayerStatusBar.posY)
end
Instance_Widget_MainStatus_User_Bar:addInputEvent("Mouse_On", "MainStatus_ChangeTexture_On()")
Instance_Widget_MainStatus_User_Bar:addInputEvent("Mouse_Out", "MainStatus_ChangeTexture_Off()")
Instance_Widget_MainStatus_User_Bar:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
function MainStatus_ChangeTexture_On()
  Instance_Widget_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_drag.dds")
  mainBarText:SetText(PAGetString(Defines.StringSheet_GAME, "MAINSTATUS_DRAG_BATTLERESOURCE"))
end
function MainStatus_ChangeTexture_Off()
  if Panel_UIControl:IsShow() then
    Instance_Widget_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_isWidget.dds")
    mainBarText:SetText(PAGetString(Defines.StringSheet_GAME, "MAINSTATUS_BATTLERESOURCE"))
  else
    Instance_Widget_MainStatus_User_Bar:ChangeTextureInfoName("new_ui_common_forlua/default/window_sample_empty.dds")
  end
end
function Instance_Widget_MainStatus_User_Bar.MainStatusShowToggle()
  local isShow = Instance_Widget_MainStatus_User_Bar:GetShow()
  if isShow == true then
    Instance_Widget_MainStatus_User_Bar:SetShow(false, true)
  else
    FGlobal_User_Bar_Show(true, true)
  end
end
function FGlobal_Panel_MainStatus_User_Bar_Show()
  if true == PaGlobalFunc_IsRemasterUIOption() then
    return
  end
  Instance_Widget_MainStatus_User_Bar:SetShow(true, true)
  Instance_Widget_MainStatus_User_Bar:AddEffect("UI_Tuto_Hp_1", false, 0, -4)
  Instance_Widget_MainStatus_User_Bar:AddEffect("fUI_Tuto_Hp_01A", false, 0, -4)
  local self = selfPlayerStatusBar
  self._staticGage_HP:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
  self._staticGage_HP:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
  self._staticGage_CombatResource:AddEffect("fUI_Tuto_Hp_01A", false, 0, -5)
  self._staticGage_CombatResource:AddEffect("UI_Tuto_Hp_1", false, 0, -5)
end
function mainStatus_AniOpen()
  Instance_Widget_MainStatus_User_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local MainStatusOpen_Alpha = Instance_Widget_MainStatus_User_Bar:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  MainStatusOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  MainStatusOpen_Alpha.IsChangeChild = true
end
function mainStatus_AniClose()
  Instance_Widget_MainStatus_User_Bar:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local MainStatusClose_Alpha = Instance_Widget_MainStatus_User_Bar:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  MainStatusClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  MainStatusClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  MainStatusClose_Alpha.IsChangeChild = true
  MainStatusClose_Alpha:SetHideAtEnd(true)
  MainStatusClose_Alpha:SetDisableWhileAni(true)
end
function HP_TextOn()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = math.floor(player:getHp())
  local maxHp = math.floor(player:getMaxHp())
  local self = selfPlayerStatusBar
  self._staticShowHp:SetShow(true)
end
function MP_TextOn()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local mp = player:getMp()
  local maxMp = player:getMaxMp()
  local self = selfPlayerStatusBar
  self._staticShowMp:SetShow(true)
end
function HP_TextOff()
end
function MP_TextOff()
end
function FGlobal_User_Bar_Show(isShow, isAni)
  if true == PaGlobalFunc_IsRemasterUIOption() then
    isShow = false
  end
  Instance_Widget_MainStatus_User_Bar:SetShow(true, true)
end
function FaGlobal_FromClient_ClassChangeBattleRoyale()
  local self = selfPlayerStatusBar
  self:setClassType()
end
FGlobal_User_Bar_Show(true, false)
