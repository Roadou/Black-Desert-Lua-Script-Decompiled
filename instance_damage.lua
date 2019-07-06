local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local RED_A0 = Defines.Color.C_00FF0000
local RED_A1 = Defines.Color.C_FFFF0000
local WHITE_A0 = Defines.Color.C_00FFFFFF
local WHITE_A1 = Defines.Color.C_FFFFFFFF
local GREEN_A0 = Defines.Color.C_00B5FF6D
local GREEN_A1 = Defines.Color.C_FFB5FF6D
local SKY_BLUE_A0 = Defines.Color.C_006DC6FF
local SKY_BLUE_A1 = Defines.Color.C_FF6DC6FF
local LIGHT_ORANGE_A0 = Defines.Color.C_00FFD46D
local LIGHT_ORANGE_A1 = Defines.Color.C_FFFFD46D
local ORANGE_A0 = Defines.Color.C_00FFAB6D
local ORANGE_A1 = Defines.Color.C_FFFFAB6D
local ORANGE_B0 = Defines.Color.C_00FF4729
local ORANGE_B1 = Defines.Color.C_FFFF4729
local PURPLE_A0 = Defines.Color.C_00B75EDD
local PURPLE_A1 = Defines.Color.C_FFB75EDD
local uiGruopValue = Defines.UIGroup.PAGameUIGroup_ScreenEffect
local OPT = CppEnums.OtherListType
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AH = CppEnums.PA_UI_ALIGNHORIZON
local DamagePanel = {}
local DamagePanel_Index = 1
local DamagePanel_Count = 20
local isShowAttackEffect = ToClient_getRenderHitEffect()
local effectControlSetting = {
  {_name = "Critical"},
  {_name = "Block"},
  {_name = "Guard"},
  {_name = "Immune"},
  {_name = "Miss"},
  {_name = "Exp"},
  {_name = "BackAttack"},
  {
    _name = "CounterAttack"
  },
  {_name = "DownAttack"},
  {
    _name = "SpeedAttack"
  },
  {_name = "SkillPoint"},
  {_name = "AirAttack"},
  {_name = "KindDamage"},
  [93] = {_name = "Static_Wp"},
  [94] = {
    _name = "Static_Plus"
  },
  [95] = {
    _name = "Static_Minus"
  },
  [96] = {
    _name = "Static_Karma"
  },
  [97] = {
    _name = "Static_Intimacy"
  },
  [99] = {_name = "Contribute"}
}
local UpdatePanel
local function createUIData()
  for key, value in pairs(effectControlSetting) do
    local control = UI.getChildControl(Instance_Damage, value._name)
    if nil ~= control then
      value._sizeX = control:GetSizeX()
      value._sizeY = control:GetSizeY()
    end
  end
end
local function createDamageControl(target)
  local numberStaticBase = UI.getChildControl(Instance_Damage, "NumberStatic")
  local damageData = UI.createControl(UCT.PA_UI_CONTROL_NUMSTATIC, target._panel, "StaticText_Damage")
  CopyBaseProperty(numberStaticBase, damageData)
  damageData:ChangeTextureInfoName("New_UI_Common_forLua/Widget/Damage/damageText.dds")
  damageData:SetShowPercent(false)
  damageData:SetNumberSizeWidth(40)
  damageData:SetNumberSizeHeight(40)
  damageData:SetNumSpanSize(-10)
  target.damage = damageData
  local effectControl, effectData
  for idx, value in pairs(effectControlSetting) do
    effectControl = UI.createControl(UCT.PA_UI_CONTROL_STATIC, target._panel, value._name)
    CopyBaseProperty(UI.getChildControl(Instance_Damage, value._name), effectControl)
    target.effectList[idx] = effectControl
  end
end
function PaGlobalFunc_GetDamagePanel(index)
  return DamagePanel[index]
end
local function createDamagePanel()
  for index = 1, DamagePanel_Count do
    local panel = UI.createPanel("damagePanel_" .. tostring(index), Defines.UIGroup.PAGameUIGroup_ScreenEffect)
    CopyBaseProperty(Instance_Damage, panel)
    if nil == panel then
      return
    end
    local target = {
      effectList = {},
      damage = nil,
      _posX = 0,
      _posY = 0,
      _posZ = 0,
      _panel = panel
    }
    createDamageControl(target)
    DamagePanel[index] = target
    panel:setFlushAble(false)
    panel:SetIgnore(true)
    panel:SetIgnoreChild(true)
    panel:SetShow(false, false)
  end
end
local function SetAnimationPanel(targetPanel, startendColor, middleColor, timeRate)
  local aniInfo0 = targetPanel:addColorAnimation(0 * timeRate, 0.1 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo0:SetStartColor(startendColor)
  aniInfo0:SetEndColor(middleColor)
  aniInfo0:SetStartIntensity(1)
  aniInfo0:SetEndIntensity(2)
  aniInfo0.IsChangeChild = true
  local aniInfo1 = targetPanel:addColorAnimation(0.3 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo1:SetStartColor(middleColor)
  aniInfo1:SetEndColor(startendColor)
  aniInfo1:SetStartIntensity(2)
  aniInfo1:SetEndIntensity(1)
  aniInfo1:SetHideAtEnd(true)
  aniInfo1.IsChangeChild = true
end
local function SetAnimationControl(targetStatic, posX, posY, timeRate)
  targetStatic:SetPosX(posX)
  targetStatic:SetPosY(posY + 500)
  targetStatic:SetShow(isShowAttackEffect)
  targetStatic:SetAlpha(0)
  local aniInfo2 = targetStatic:addMoveAnimation(0 * timeRate, 0.2 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2:SetStartPosition(posX, posY - 150)
  aniInfo2:SetEndPosition(posX, posY - 200)
  local aniInfo3 = targetStatic:addMoveAnimation(0.2 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3:SetStartPosition(posX, posY - 200)
  aniInfo3:SetEndPosition(posX, posY - 250)
end
local function SetAnimation_CounterAttack(targetStatic, posX, posY, timeRate)
  targetStatic:SetPosX(posX)
  targetStatic:SetPosY(posY + 500)
  targetStatic:SetShow(isShowAttackEffect)
  targetStatic:SetAlpha(0)
  local aniInfo2 = targetStatic:addMoveAnimation(0 * timeRate, 0.2 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2:SetStartPosition(posX, posY - 200)
  aniInfo2:SetEndPosition(posX, posY - 200)
  local aniInfo3 = targetStatic:addMoveAnimation(0.2 * timeRate, 0.5 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3:SetStartPosition(posX, posY - 200)
  aniInfo3:SetEndPosition(posX, posY - 200)
  local aniInfo4 = targetStatic:addScaleAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo4:SetStartScale(1.5)
  aniInfo4:SetEndScale(1)
  aniInfo4.AxisX = 83
  aniInfo4.AxisY = 16.5
end
local function SetAnimation_KindDamage(targetStatic, posX, posY, timeRate)
  targetStatic:SetPosX(posX - 120)
  targetStatic:SetPosY(posY + 200)
  targetStatic:SetShow(isShowAttackEffect)
  targetStatic:SetAlpha(0)
  local aniInfo2 = targetStatic:addMoveAnimation(0 * timeRate, 0.1 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo2.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo2:SetStartPosition(posX, posY - 50)
  aniInfo2:SetEndPosition(posX, posY - 150)
  local aniInfo3 = targetStatic:addMoveAnimation(0.4 * timeRate, 0.6 * timeRate, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo3.StartHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3.EndHorizonType = UI_AH.PA_UI_HORIZON_LEFT
  aniInfo3:SetStartPosition(posX, posY - 150)
  aniInfo3:SetEndPosition(posX, posY - 200)
end
function LuaDamagePostflushAndRestoreFunction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  UpdatePanel:SetShow(true, false)
end
local function initialize()
  UpdatePanel = UI.createPanel("Panel_DamageDisplay", uiGruopValue)
  UpdatePanel:SetShow(true, false)
  UpdatePanel:SetIgnore(true)
  UpdatePanel:SetPosX(0)
  UpdatePanel:SetPosY(0)
  UpdatePanel:SetAlpha(0)
  UpdatePanel:SetSize(1, 1)
  UpdatePanel:RegisterUpdateFunc("DamageOutputFunction_UpdatePosition")
  UpdatePanel:RegisterShowEventFunc(true, " ")
  UpdatePanel:RegisterShowEventFunc(false, " ")
  createUIData()
  createDamagePanel()
end
registerEvent("FromClient_RenderModeChangeState", "LuaDamagePostflushAndRestoreFunction")
Instance_CounterAttack:SetShow(false)
function CounterAttack_ResizeScreen()
  Instance_CounterAttack:SetSize(getScreenSizeX(), getScreenSizeY())
end
function CounterAttack_Show()
  Instance_CounterAttack:ResetVertexAni()
  Instance_CounterAttack:SetShow(true)
  Instance_CounterAttack:SetVertexAniRun("Ani_Color_Counter", true)
end
CounterAttack_ResizeScreen()
registerEvent("onScreenResize", "CounterAttack_ResizeScreen")
function DamageOutputFunction_UpdatePosition()
  local cameraRotation = getCameraYawPitchRoll()
  local cameraPosition = getCameraPosition()
  for index = 1, DamagePanel_Count do
    local damageData = DamagePanel[index]
    local panel = damageData._panel
    if panel:GetShow() then
      local posX = damageData._posX
      local posY = damageData._posY + 150
      local posZ = damageData._posZ
      local transformData = getTransformRevers(posX, posY, posZ)
      if transformData.x > -1 and -1 < transformData.y then
        panel:SetPosX(transformData.x)
        panel:SetPosY(transformData.y)
      else
        panel:SetPosX(-1000)
        panel:SetPosY(-1000)
      end
    end
  end
end
function FromClient_TendencyChanged(actorKeyRaw, tendencyValue)
  local selfWrapper = getSelfPlayer()
  local selfProxy = selfWrapper:get()
  local selfActorKeyRaw = selfWrapper:getActorKey()
  local selfPosition = float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
  if selfActorKeyRaw == actorKeyRaw and (tendencyValue < 0 or tendencyValue >= 100) then
    if tendencyValue < 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DAMAGE_TENDENCYCHANGED"))
    end
    DamageOutputFunction_OnDamage(getSelfPlayer():getActorKey(), tendencyValue, 96, 10, selfPosition, false, getSelfPlayer():getActorKey(), true)
  end
end
function FromClient_VaryIntimacy(actorKeyRaw, intimacyValue)
  local actorProxy = getActor(actorKeyRaw):get()
  local actorPosition = float3(actorProxy:getPositionX(), actorProxy:getPositionY(), actorProxy:getPositionZ())
  if 0 ~= intimacyValue then
    audioPostEvent_SystemUi(7, 0)
    DamageOutputFunction_OnDamage(actorKeyRaw, intimacyValue, 97, 10, actorPosition, false, getSelfPlayer():getActorKey(), true)
  end
end
function DamageOutputFunction_gainExperience(experience)
  local selfProxy = getSelfPlayer():get()
  local selfPosition = float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
  if experience > 0 then
    DamageOutputFunction_OnDamage(getSelfPlayer():getActorKey(), experience, 99, 10, selfPosition, false, getSelfPlayer():getActorKey(), false)
  end
end
function FromClient_WpChanged(prevWp, wp)
  local selfProxy = getSelfPlayer():get()
  local selfPosition = float3(selfProxy:getPositionX(), selfProxy:getPositionY(), selfProxy:getPositionZ())
  local varyWp = wp - prevWp
  if varyWp < 0 or varyWp > 1 then
    DamageOutputFunction_OnDamage(getSelfPlayer():getActorKey(), varyWp, 93, 10, selfPosition, false, getSelfPlayer():getActorKey(), false)
  end
end
function DamageOutputFunction_OnDamage(attakeeKeyRaw, effectNumber, effectType, additionalDamageType, posFloat3, isTribeAttack, attackerActorKeyRaw, isNotRandom)
  local target = DamagePanel[DamagePanel_Index]
  DamagePanel_Index = DamagePanel_Index + 1
  if DamagePanel_Count < DamagePanel_Index then
    DamagePanel_Index = 1
  end
  if true == isNotRandom then
    target._posX = posFloat3.x
    target._posY = posFloat3.y
    target._posZ = posFloat3.z
  else
    target._posX = posFloat3.x + getRandomValue(-50, 50)
    target._posY = posFloat3.y
    target._posZ = posFloat3.z + getRandomValue(-50, 50)
  end
  if effectType > 90 then
    local talker = dialog_getTalker()
    if nil ~= talker then
      local talkerRaw = talker:get()
      target._posX = talkerRaw:getPositionX()
      target._posY = talkerRaw:getPositionY()
      target._posZ = talkerRaw:getPositionZ()
    end
  end
  for _, control in pairs(target.effectList) do
    control:SetShow(false)
  end
  if (96 == effectType or 97 == effectType or 93 == effectType) and 0 == effectNumber then
    return
  end
  local selfPlayer = getSelfPlayer()
  local attackeeIsSelfPlayer = nil ~= selfPlayer and selfPlayer:getActorKey() == attakeeKeyRaw
  local baseX = 0
  local baseY = 0
  if true == isNotRandom then
    baseX = 160
    baseY = 130
  end
  local startendColor = WHITE_A0
  local middleColor = WHITE_A1
  if attackeeIsSelfPlayer then
    startendColor = RED_A0
    middleColor = RED_A1
  end
  if 8 == effectType and effectNumber <= 0 then
    return
  end
  local timeRate = 2
  local showSymbol = 0
  local isDamageShow = true
  local isShowKindDamage = effectType <= 2 and isTribeAttack
  if effectType == 0 then
  elseif effectType == 1 then
    startendColor = ORANGE_A0
    middleColor = ORANGE_A1
  elseif effectType == 2 then
    isDamageShow = false
  elseif effectType == 3 then
    isDamageShow = false
  elseif effectType == 4 then
    isDamageShow = false
  elseif effectType == 5 then
    isDamageShow = false
  elseif effectType == 6 then
    startendColor = GREEN_A0
    middleColor = GREEN_A1
    isDamageShow = false
  elseif effectType == 7 then
    startendColor = SKY_BLUE_A0
    middleColor = SKY_BLUE_A1
    isDamageShow = false
  elseif effectType == 8 then
    startendColor = LIGHT_ORANGE_A0
    middleColor = LIGHT_ORANGE_A1
    timeRate = 4
    showSymbol = 0
  elseif effectType == 93 then
    startendColor = WHITE_A0
    middleColor = WHITE_A1
    timeRate = 4
    showSymbol = 1
    isDamageShow = false
  elseif effectType == 96 then
    startendColor = WHITE_A0
    middleColor = WHITE_A1
    timeRate = 4
    showSymbol = 1
    isDamageShow = false
  elseif effectType == 97 then
    startendColor = WHITE_A0
    middleColor = WHITE_A1
    timeRate = 4
    showSymbol = 1
    isDamageShow = false
  elseif effectType == 99 then
    startendColor = WHITE_A0
    middleColor = WHITE_A1
    timeRate = 4
    showSymbol = 1
    isDamageShow = false
  else
    UI.ASSERT(false, "\236\157\180\236\131\129\237\149\156 \237\154\168\234\179\188\235\178\136\237\152\184\234\176\128 \235\147\164\236\150\180\236\152\180.")
  end
  local targetPanel = target._panel
  targetPanel:SetShow(isShowAttackEffect, false)
  targetPanel:SetWorldPosX(target._posX)
  targetPanel:SetWorldPosY(target._posY)
  targetPanel:SetWorldPosZ(target._posZ)
  SetAnimationPanel(targetPanel, startendColor, middleColor, timeRate)
  local onDmgMeter = ToClient_getGameOptionControllerWrapper():getOnDamageMeter()
  if attackerActorKeyRaw == selfPlayer:getActorKey() then
    local attakeeActor = getCharacterActor(attakeeKeyRaw)
    if nil ~= attakeeActor then
      onDmgMeter = checkActiveCondition(attakeeActor:getCharacterKey())
    end
  end
  onDmgMeter = onDmgMeter and _ContentsGroup_DamageMeter or ToClient_getDmgMeterStateForTest()
  if true == onDmgMeter then
    local nameStatic = target.damage
    local numberWidth = 0
    local numberHeight = 50
    if effectType <= 6 then
      setDamageNameStatic(nameStatic, effectNumber, showSymbol, startendColor)
      numberWidth = nameStatic:getNumberWidth()
      SetAnimationControl(nameStatic, -numberWidth / 2, baseY, timeRate)
      baseY = baseY + numberHeight
    else
      nameStatic:SetShow(false)
    end
  else
    target.damage:SetShow(false)
  end
  if 0 == effectType or 6 == effectType or 7 == effectType then
  elseif 1 == effectType or 2 == effectType or 3 == effectType or 4 == effectType then
    baseX = baseX - effectControlSetting[effectType]._sizeX / 2
    SetAnimationControl(target.effectList[effectType], baseX, baseY, timeRate)
  elseif 5 == effectType then
  elseif 8 == effectType then
    baseX = baseX - effectControlSetting[6]._sizeX
    SetAnimationControl(target.effectList[6], baseX, baseY - 60, timeRate)
  elseif 93 == effectType then
    baseX = baseX - effectControlSetting[effectType]._sizeX
    baseY = baseY + 5
    SetAnimationControl(target.effectList[effectType], baseX, baseY, timeRate)
  elseif 96 == effectType then
    baseX = baseX - effectControlSetting[96]._sizeX
    baseY = baseY + 5
    SetAnimationControl(target.effectList[96], baseX, baseY, timeRate)
  elseif 97 == effectType then
    baseX = baseX - effectControlSetting[97]._sizeX
    baseY = baseY + 5
    SetAnimationControl(target.effectList[97], baseX, baseY, timeRate)
  elseif 99 == effectType then
    baseX = baseX - effectControlSetting[99]._sizeX
    baseY = baseY + 50
    SetAnimationControl(target.effectList[99], baseX, baseY - 50, timeRate)
  else
    UI.ASSERT(false, "\236\157\180\236\131\129\237\149\156 \237\154\168\234\179\188\235\178\136\237\152\184\234\176\128 \235\147\164\236\150\180\236\152\180.")
  end
  if isDamageShow then
    if 0 == additionalDamageType and 1 == effectType then
      if attackeeIsSelfPlayer then
        target.effectList[7]:AddEffect("Ui_Damage_CriticalBackattack_Red", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[7]:AddEffect("Ui_Damage_CriticalBackattack_White", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 2, attackerActorKeyRaw)
        render_setChromaticBlur(50, 0.1)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      baseX = baseX - effectControlSetting[7]._sizeX / 2
      SetAnimationControl(target.effectList[7], baseX, baseY, 10)
    elseif 0 == additionalDamageType then
      if attackeeIsSelfPlayer then
        target.effectList[7]:AddEffect("Ui_Damage_Backattack_red", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[7]:AddEffect("Ui_Damage_Backattack", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 0, attackerActorKeyRaw)
        render_setChromaticBlur(50, 0.1)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      baseX = baseX - effectControlSetting[7]._sizeX / 2
      SetAnimationControl(target.effectList[7], baseX, baseY, 10)
    elseif 1 == additionalDamageType then
      if 1 == effectType then
        if attackeeIsSelfPlayer then
          target.effectList[8]:AddEffect("Ui_Damage_CriticalCounter_Red", false, 0, 0)
          render_setPointBlur(0.04, 0.03)
          render_setColorBypass(0.8, 0.15)
          render_setColorBalance(float3(-0.3, 0, 0), 0.12)
        else
          target.effectList[8]:AddEffect("Ui_Damage_CriticalCounter_White", false, 0, 0)
          audioPostEvent_SystemUi3D(14, 2, attackerActorKeyRaw)
          render_setChromaticBlur(65, 0.15)
          render_setPointBlur(0.025, 0.03)
          render_setColorBypass(0.3, 0.08)
        end
      elseif attackeeIsSelfPlayer then
        target.effectList[8]:AddEffect("Ui_Damage_Counter", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[8]:AddEffect("Ui_Damage_Counter", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 2, attackerActorKeyRaw)
        render_setChromaticBlur(65, 0.15)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      CounterAttack_Show()
      baseX = baseX - effectControlSetting[8]._sizeX / 2
      SetAnimation_CounterAttack(target.effectList[8], baseX, baseY, timeRate)
    elseif 2 == additionalDamageType then
      if 1 == effectType then
        if attackeeIsSelfPlayer then
          target.effectList[9]:AddEffect("Ui_Damage_CriticalDownattack_Red", false, 0, 0)
          render_setPointBlur(0.04, 0.03)
          render_setColorBypass(0.8, 0.15)
          render_setColorBalance(float3(-0.3, 0, 0), 0.12)
        else
          target.effectList[9]:AddEffect("Ui_Damage_CriticalDownattack_White", false, 0, 0)
          audioPostEvent_SystemUi3D(14, 3, attackerActorKeyRaw)
          render_setChromaticBlur(55, 0.15)
          render_setPointBlur(0.025, 0.03)
          render_setColorBypass(0.3, 0.08)
        end
      elseif attackeeIsSelfPlayer then
        target.effectList[9]:AddEffect("Ui_Damage_Downattack", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[9]:AddEffect("Ui_Damage_Downattack", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 3, attackerActorKeyRaw)
        render_setChromaticBlur(55, 0.15)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      baseX = baseX - effectControlSetting[9]._sizeX / 2
      SetAnimation_CounterAttack(target.effectList[9], baseX, baseY, timeRate)
    elseif 3 == additionalDamageType then
      if 1 == effectType then
        if attackeeIsSelfPlayer then
          target.effectList[10]:AddEffect("Ui_Damage_CriticalSpeedattack_Red", false, 0, 0)
          render_setPointBlur(0.04, 0.03)
          render_setColorBypass(0.8, 0.15)
          render_setColorBalance(float3(-0.3, 0, 0), 0.12)
        else
          target.effectList[10]:AddEffect("Ui_Damage_CriticalSpeedattack_White", false, 0, 0)
          audioPostEvent_SystemUi3D(14, 4, attackerActorKeyRaw)
          render_setChromaticBlur(55, 0.15)
          render_setPointBlur(0.025, 0.03)
          render_setColorBypass(0.3, 0.08)
        end
      elseif attackeeIsSelfPlayer then
        target.effectList[10]:AddEffect("Ui_Damage_Speedattack", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[10]:AddEffect("Ui_Damage_Speedattack", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 4, attackerActorKeyRaw)
        render_setChromaticBlur(55, 0.15)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      baseX = baseX - effectControlSetting[10]._sizeX / 2
      SetAnimation_CounterAttack(target.effectList[10], baseX, baseY, timeRate)
    elseif 4 == additionalDamageType then
      if 1 == effectType then
        if attackeeIsSelfPlayer then
          target.effectList[12]:AddEffect("Ui_Damage_CriticalAirattack_Red", false, 0, 0)
          render_setPointBlur(0.04, 0.03)
          render_setColorBypass(0.8, 0.15)
          render_setColorBalance(float3(-0.3, 0, 0), 0.12)
        else
          target.effectList[12]:AddEffect("Ui_Damage_CriticalAirattack_White", false, 0, 0)
          audioPostEvent_SystemUi3D(14, 5, attackerActorKeyRaw)
          render_setChromaticBlur(55, 0.15)
          render_setPointBlur(0.025, 0.03)
          render_setColorBypass(0.3, 0.08)
        end
      elseif attackeeIsSelfPlayer then
        target.effectList[12]:AddEffect("Ui_Damage_Airattack", false, 0, 0)
        render_setPointBlur(0.04, 0.03)
        render_setColorBypass(0.8, 0.15)
        render_setColorBalance(float3(-0.3, 0, 0), 0.12)
      else
        target.effectList[12]:AddEffect("Ui_Damage_Airattack", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 5, attackerActorKeyRaw)
        render_setChromaticBlur(55, 0.15)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.3, 0.08)
      end
      baseX = baseX - effectControlSetting[12]._sizeX / 2
      SetAnimation_CounterAttack(target.effectList[12], baseX, baseY, timeRate)
    elseif 1 == effectType then
      if attackeeIsSelfPlayer then
        target.effectList[1]:AddEffect("Ui_Damage_Critical", false, 0, 0)
        render_setPointBlur(0.045, 0.05)
        render_setColorBypass(0.8, 0.15)
      else
        target.effectList[1]:AddEffect("Ui_Damage_Critical", false, 0, 0)
        audioPostEvent_SystemUi3D(14, 2, attackerActorKeyRaw)
        render_setChromaticBlur(70, 0.09)
        render_setPointBlur(0.025, 0.03)
        render_setColorBypass(0.5, 0.08)
      end
      baseX = baseX - effectControlSetting[1]._sizeX / 2
      SetAnimation_CounterAttack(target.effectList[1], baseX, baseY, timeRate)
    elseif 99 == additionalDamageType then
    end
  end
  if 96 == effectType or 97 == effectType or 93 == effectType then
    local arrowControl = target.effectList[94]
    if effectNumber < 0 then
      arrowControl = target.effectList[95]
      target.effectList[94]:ResetVertexAni(true)
    else
      arrowControl = target.effectList[94]
      target.effectList[95]:ResetVertexAni(true)
    end
    baseX = baseX + effectControlSetting[effectType]._sizeX
    SetAnimationControl(arrowControl, baseX, baseY + 10, timeRate)
  end
end
function FGlobal_SetMamageShow()
  isShowAttackEffect = ToClient_getRenderHitEffect()
end
function FromClient_AddDamageProcess(attakeeKeyRaw, effectNumber, effectType, additionalDamageType, posFloat3, isTribeAttack, attackerActorKeyRaw)
  if false == ToClient_getGameOptionControllerWrapper():getRenderHitEffectParty() then
    local selfPlayerWrapper = getSelfPlayer()
    if nil == selfPlayerWrapper then
      return
    end
    local attakeeActor = getCharacterActor(attakeeKeyRaw)
    local attackerActor = getCharacterActor(attackerActorKeyRaw)
    local actorKeyRaw = getSelfPlayer():getActorKey()
    if actorKeyRaw ~= attakeeKeyRaw and actorKeyRaw ~= attackerActorKeyRaw and (nil == attakeeActor or false == attakeeActor:isOwnerSelfPlayer()) and (nil == attackerActor or false == attackerActor:isOwnerSelfPlayer()) then
      return
    end
  end
  DamageOutputFunction_OnDamage(attakeeKeyRaw, effectNumber, effectType, additionalDamageType, posFloat3, isTribeAttack, attackerActorKeyRaw, false)
end
registerEvent("addDamage", "FromClient_AddDamageProcess")
registerEvent("gainExplorationExperience", "DamageOutputFunction_gainExperience")
registerEvent("FromClient_VaryIntimacy", "FromClient_VaryIntimacy")
registerEvent("FromClient_TendencyChanged", "FromClient_TendencyChanged")
registerEvent("FromClient_WpChangedWithParam", "FromClient_WpChanged")
registerEvent("update_Monster_Info_Req", "panel_Update_Monster_Info")
initialize()
