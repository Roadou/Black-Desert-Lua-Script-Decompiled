local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local blackBg = UI.getChildControl(Panel_Monster_Bar, "Static_blackBG")
local lua_TargetInfo_Name = UI.getChildControl(Panel_Monster_Bar, "Static_Name_TargetName")
local lua_TargetInfo_NormalEnemyGauge = UI.getChildControl(Panel_Monster_Bar, "EnemyGauge_Back")
local lua_TargetInfo_NormalHpRate = UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetHP_Rate")
local lua_TargetInfo_NormalHpRate_Later = UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetHP_Rate_Later")
local lua_TargetInfo_BossEnemyGauge = UI.getChildControl(Panel_Monster_Bar, "BossEnemyGauge_Back")
local lua_TargetInfo_BossHpRate = UI.getChildControl(Panel_Monster_Bar, "BossProgress2_TargetHP_Rate")
local lua_TargetInfo_BossHpRate_Later = UI.getChildControl(Panel_Monster_Bar, "BossProgress2_TargetHP_Rate_Later")
local lua_TargetInfo_PlayerEnemyGauge = UI.getChildControl(Panel_Monster_Bar, "PlayerEnemyGauge_Back")
local lua_TargetInfo_PlayerHpRate = UI.getChildControl(Panel_Monster_Bar, "PlayerProgress2_TargetHP_Rate")
local lua_TargetInfo_PlayerHpRate_Later = UI.getChildControl(Panel_Monster_Bar, "PlayerProgress2_TargetHP_Rate_Later")
local lua_TargetInfo_StunRate_Back = UI.getChildControl(Panel_Monster_Bar, "EnemyGaugeStun_Back")
local lua_TargetInfo_StunRate = UI.getChildControl(Panel_Monster_Bar, "Progress2_TargetStun_Rate")
local _stunEffect = UI.getChildControl(Panel_Monster_Bar, "Static_StunMaxEffect")
local lua_EnemyTypeIcon = UI.getChildControl(Panel_Monster_Bar, "Static_Enemy_TypeIcon")
local lua_EnemyTypeText = UI.getChildControl(Panel_Monster_Bar, "StaticText_Type")
local monsterBuffIcon_Base = UI.getChildControl(Panel_Monster_Bar, "Static_EnemyBuffIcon")
local EnemyBuffListBoarder = UI.getChildControl(Panel_Monster_Bar, "Static_EnemyBuffListBoarder")
local _darkSpirit = UI.getChildControl(Panel_Monster_Bar, "Static_Darkspirit")
local _helpBubble = UI.getChildControl(Panel_Monster_Bar, "Static_HelpBubble")
local _helpMsg = UI.getChildControl(Panel_Monster_Bar, "StaticText_HelpMsg")
local _RunawayBG = UI.getChildControl(Panel_Monster_Bar, "Static_Runaway")
local _txt_Runaway = UI.getChildControl(Panel_Monster_Bar, "StaticText_Runaway")
local _checkBtnAlert = UI.getChildControl(Panel_Monster_Bar, "CheckButton_Alert")
local lua_EnemyNightIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, EnemyBuffListBoarder, "monsterNightIcon")
CopyBaseProperty(monsterBuffIcon_Base, lua_EnemyNightIcon)
local elapsedTime = 0
local monsterList = {}
local appliedBuff_UIPool = {}
local appliedBuff_UIPool_Last = 0
local appliedBuff_DATAPool = {}
local targetActorKey = 0
isMonsterBarShow = false
local isXbox = ToClient_isConsole()
lua_TargetInfo_NormalEnemyGauge:SetShow(false)
lua_TargetInfo_NormalHpRate:SetShow(false)
lua_TargetInfo_NormalHpRate_Later:SetShow(false)
lua_TargetInfo_BossEnemyGauge:SetShow(false)
lua_TargetInfo_BossHpRate:SetShow(false)
lua_TargetInfo_BossHpRate_Later:SetShow(false)
lua_TargetInfo_PlayerEnemyGauge:SetShow(false)
lua_TargetInfo_PlayerHpRate:SetShow(false)
lua_TargetInfo_PlayerHpRate_Later:SetShow(false)
_checkBtnAlert:addInputEvent("Mouse_LUp", "GameOption_NearMonsterAlertOff()")
local function getMaxLevel()
  local level = 0
  for actorKey, monsterLevel in pairs(monsterList) do
    if monsterLevel > level then
      level = monsterLevel
    end
  end
  return level
end
local function updateStunGauge(targetActor, stun, maxStun)
  local percents = stun / maxStun * 100
  if targetActor:hasStun() and stun > 0 then
    EnemyBuffListBoarder:SetSpanSize(-15, 0)
    lua_TargetInfo_StunRate:SetShow(true)
    lua_TargetInfo_StunRate_Back:SetShow(true)
    lua_TargetInfo_StunRate:SetProgressRate(percents)
    lua_TargetInfo_StunRate:SetCurrentProgressRate(percents)
    return true
  else
    _stunEffect:SetShow(true)
    EnemyBuffListBoarder:SetSpanSize(-15, 15)
    lua_TargetInfo_StunRate:SetShow(false)
    lua_TargetInfo_StunRate_Back:SetShow(false)
    return false
  end
end
local nowTarget = {}
local _dangerAlert_Show = FGlobal_DangerAlert_Show
if true == _ContentsGroup_RenewUI_Main then
  _dangerAlert_Show = PaGlobalFunc_MainStatusInfo_DangerAlertShow
end
function Panel_MonsterInfo_UpdateStun(actorKey, stun, maxStun)
  if targetActorKey == actorKey then
    local targetActor = getCharacterActor(actorKey)
    updateStunGauge(targetActor:get(), stun, maxStun)
  end
end
function targetHpInfo_Update_Monster(actorKey, nowHP)
  local targetActor = getCharacterActor(actorKey)
  if nil == targetActor then
    FGlobal_DangerAlert_Show(false)
    return
  end
  local monsterLevel = targetActor:get():getCharacterStaticStatus().level
  local playerLevel = getSelfPlayer():get():getLevel()
  local levelDiff = monsterLevel - playerLevel + 6
  levelDiff = math.max(levelDiff, 1)
  levelDiff = math.min(levelDiff, 11)
  _darkSpirit:EraseAllEffect()
  _darkSpirit:SetShow(false)
  _RunawayBG:SetShow(false)
  _txt_Runaway:SetShow(false)
  _checkBtnAlert:SetShow(false)
  if 4 ~= targetActor:getCharacterGradeType() then
    if checkActiveCondition(targetActor:getCharacterKey()) == true then
      _darkSpirit:SetShow(false)
      _helpBubble:SetShow(false)
      _helpMsg:SetShow(false)
      lua_TargetInfo_NormalHpRate:ResetVertexAni()
      lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
      lua_TargetInfo_NormalHpRate:SetProgressRate(nowHP)
      lua_TargetInfo_NormalHpRate_Later:ResetVertexAni()
      lua_TargetInfo_NormalHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
      lua_TargetInfo_NormalHpRate_Later:SetProgressRate(nowHP)
      lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 72, 233, 78)
      lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
      lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
    else
      if _darkSpirit:GetShow() then
        _darkSpirit:SetShow(false)
        _helpBubble:SetShow(false)
        _helpMsg:SetShow(false)
      end
      if not isXbox and playerLevel <= 20 then
        _darkSpirit:SetShow(true)
        _helpBubble:SetShow(true)
        _helpMsg:SetShow(true)
        _darkSpirit:EraseAllEffect()
        _darkSpirit:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
        _helpMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
        _helpMsg:SetAutoResize(true)
        _helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT"))
        _helpBubble:SetSize(_helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37)
        _helpMsg:SetPosY(_helpBubble:GetPosY() + 27)
      end
      lua_TargetInfo_NormalHpRate:ResetVertexAni()
      lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
      lua_TargetInfo_NormalHpRate:SetProgressRate(100)
      lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
      local x1, y1, x2, y2
      if nowHP > 75 then
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 72, 233, 78)
      elseif nowHP > 50 then
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 79, 233, 85)
      elseif nowHP > 25 then
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 86, 233, 92)
      elseif nowHP > 10 then
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 93, 233, 99)
      elseif nowHP > 5 then
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 100, 233, 106)
      else
        x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 100, 233, 106)
      end
      lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
      lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
    end
  elseif checkActiveCondition(targetActor:getCharacterKey()) == true then
    _darkSpirit:SetShow(false)
    _helpBubble:SetShow(false)
    _helpMsg:SetShow(false)
    lua_TargetInfo_BossHpRate:ResetVertexAni()
    lua_TargetInfo_BossHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
    lua_TargetInfo_BossHpRate:SetProgressRate(nowHP)
    lua_TargetInfo_BossHpRate_Later:ResetVertexAni()
    lua_TargetInfo_BossHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
    lua_TargetInfo_BossHpRate_Later:SetProgressRate(nowHP)
    lua_TargetInfo_BossHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/EnemyGauge_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 20, 212, 32)
    lua_TargetInfo_BossHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
    lua_TargetInfo_BossHpRate:setRenderTexture(lua_TargetInfo_BossHpRate:getBaseTexture())
  else
    if _darkSpirit:GetShow() then
      _darkSpirit:SetShow(false)
      _helpBubble:SetShow(false)
      _helpMsg:SetShow(false)
    end
    if not isXbox and playerLevel <= 20 then
      _darkSpirit:SetShow(true)
      _helpBubble:SetShow(true)
      _helpMsg:SetShow(true)
      _darkSpirit:EraseAllEffect()
      _darkSpirit:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
      _helpMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
      _helpMsg:SetAutoResize(true)
      _helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT"))
      _helpBubble:SetSize(_helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37)
      _helpMsg:SetPosY(_helpBubble:GetPosY() + 27)
    end
    lua_TargetInfo_BossHpRate:ResetVertexAni()
    lua_TargetInfo_BossHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
    lua_TargetInfo_BossHpRate:SetProgressRate(100)
    lua_TargetInfo_BossHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Widget/EnemyGauge/EnemyGauge_01.dds")
    local x1, y1, x2, y2
    if nowHP > 75 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 20, 212, 32)
    elseif nowHP > 50 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 33, 212, 45)
    elseif nowHP > 25 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 46, 212, 58)
    elseif nowHP > 10 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 59, 212, 71)
    elseif nowHP > 5 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 72, 212, 83)
    else
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_BossHpRate, 1, 72, 212, 83)
    end
    lua_TargetInfo_BossHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
    lua_TargetInfo_BossHpRate:setRenderTexture(lua_TargetInfo_BossHpRate:getBaseTexture())
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if not isXbox then
    if not ToClient_GetMessageFilter(10) and FromClient_ContactOfStrongMonster() and not regionInfo:get():isSafeZone() then
      _darkSpirit:SetShow(true)
      _RunawayBG:SetShow(true)
      _txt_Runaway:SetShow(true)
      if false == _ContentsGroup_RenewUI then
        _checkBtnAlert:SetShow(true)
        _checkBtnAlert:SetCheck(false)
      else
        _checkBtnAlert:SetShow(false)
      end
      _helpBubble:SetShow(false)
      _helpMsg:SetShow(false)
      _darkSpirit:EraseAllEffect()
      _darkSpirit:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
      _txt_Runaway:SetAutoResize(true)
      _txt_Runaway:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT_RUNAWAY"))
      _RunawayBG:SetSize(_txt_Runaway:GetTextSizeX() + 25, _txt_Runaway:GetSizeY() + 37)
      _RunawayBG:SetPosX(_darkSpirit:GetPosX() - _RunawayBG:GetSizeX())
      _txt_Runaway:SetPosX(_RunawayBG:GetPosX() + 10)
      _txt_Runaway:SetPosY(_RunawayBG:GetPosY() + 27)
      _checkBtnAlert:SetPosX(_RunawayBG:GetPosX() + 10)
      _checkBtnAlert:SetPosY(_RunawayBG:GetPosY())
      if Panel_Monster_Bar:GetShow() then
        FGlobal_DangerAlert_Show(true)
        FGlobal_ChattingAlert_Call()
      end
    else
      FGlobal_DangerAlert_Show(false)
    end
  end
end
function targetHpInfo_Update_Player(actorKey, nowHP)
  local targetActor = getCharacterActor(actorKey)
  if nil == targetActor then
    return
  end
  _darkSpirit:SetShow(false)
  _helpBubble:SetShow(false)
  _helpMsg:SetShow(false)
  local playerLevel = getSelfPlayer():get():getLevel()
  lua_TargetInfo_PlayerHpRate:ResetVertexAni()
  lua_TargetInfo_PlayerHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
  lua_TargetInfo_PlayerHpRate:SetProgressRate(nowHP)
  lua_TargetInfo_PlayerHpRate_Later:ResetVertexAni()
  lua_TargetInfo_PlayerHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
  lua_TargetInfo_PlayerHpRate_Later:SetProgressRate(nowHP)
end
function targetHpInfo_Update_Other(actorKey, nowHP)
  local targetActor = getCharacterActor(actorKey)
  if nil == targetActor then
    return
  end
  local playerLevel = getSelfPlayer():get():getLevel()
  if checkActiveCondition(targetActor:getCharacterKey()) == true then
    _darkSpirit:SetShow(false)
    _helpBubble:SetShow(false)
    _helpMsg:SetShow(false)
    lua_TargetInfo_NormalHpRate:ResetVertexAni()
    lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
    lua_TargetInfo_NormalHpRate:SetProgressRate(nowHP)
    lua_TargetInfo_NormalHpRate_Later:ResetVertexAni()
    lua_TargetInfo_NormalHpRate_Later:SetVertexAniRun("Ani_Color_Damage_White", true)
    lua_TargetInfo_NormalHpRate_Later:SetProgressRate(nowHP)
    lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 72, 233, 78)
    lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
    lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
  else
    if not isXbox then
      if playerLevel <= 20 then
        _darkSpirit:SetShow(true)
        _helpBubble:SetShow(true)
        _helpMsg:SetShow(true)
        _darkSpirit:EraseAllEffect()
        _darkSpirit:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
        _helpMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
        _helpMsg:SetAutoResize(true)
        _helpMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENEMYGAUGE_DARKSPIRIT"))
        _helpBubble:SetSize(_helpBubble:GetSizeX(), _helpMsg:GetSizeY() + 37)
        _helpMsg:SetPosY(_helpBubble:GetPosY() + 27)
      else
        _darkSpirit:SetShow(false)
        _helpBubble:SetShow(false)
        _helpMsg:SetShow(false)
      end
    end
    lua_TargetInfo_NormalHpRate:ResetVertexAni()
    lua_TargetInfo_NormalHpRate:SetVertexAniRun("Ani_Color_Damage_0", true)
    lua_TargetInfo_NormalHpRate:SetProgressRate(100)
    lua_TargetInfo_NormalHpRate:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Gauges_01.dds")
    local x1, y1, x2, y2
    if nowHP > 75 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 72, 233, 78)
    elseif nowHP > 50 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 79, 233, 85)
    elseif nowHP > 25 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 86, 233, 92)
    elseif nowHP > 10 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 93, 233, 99)
    elseif nowHP > 5 then
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 100, 233, 106)
    else
      x1, y1, x2, y2 = setTextureUV_Func(lua_TargetInfo_NormalHpRate, 1, 100, 233, 106)
    end
    lua_TargetInfo_NormalHpRate:getBaseTexture():setUV(x1, y1, x2, y2)
    lua_TargetInfo_NormalHpRate:setRenderTexture(lua_TargetInfo_NormalHpRate:getBaseTexture())
  end
end
function panel_Update_Monster_Info(actorKey)
  blackBg:SetShow(false)
  lua_TargetInfo_NormalEnemyGauge:SetShow(false)
  lua_TargetInfo_NormalHpRate:SetShow(false)
  lua_TargetInfo_NormalHpRate_Later:SetShow(false)
  lua_TargetInfo_BossEnemyGauge:SetShow(false)
  lua_TargetInfo_BossHpRate:SetShow(false)
  lua_TargetInfo_BossHpRate_Later:SetShow(false)
  lua_TargetInfo_PlayerEnemyGauge:SetShow(false)
  lua_TargetInfo_PlayerHpRate:SetShow(false)
  lua_TargetInfo_PlayerHpRate_Later:SetShow(false)
  lua_TargetInfo_Name:SetShow(false)
  local targetActor = getCharacterActor(actorKey)
  if nil == targetActor then
    for buffIcon_idx = 0, appliedBuff_UIPool_Last do
      if appliedBuff_UIPool[buffIcon_idx] then
        appliedBuff_UIPool[buffIcon_idx]:SetShow(false)
      end
    end
    return
  end
  targetActorKey = actorKey
  local monsterLevel = targetActor:get():getCharacterStaticStatus().level
  local playerLevel = getSelfPlayer():get():getLevel()
  monsterList[targetActorKey] = monsterLevel
  local maxLevel = getMaxLevel()
  elapsedTime = 0
  local modecheck = GetUIMode()
  if Defines.UIMode.eUIMode_NpcDialog ~= modecheck then
    Panel_Monster_Bar:SetShow(true, false)
    FGlobal_Panel_Monster_Bar_RePos()
  else
    isMonsterBarShow = true
  end
  if targetActor:get():isHiddenName() then
    lua_TargetInfo_Name:SetShow(false)
  else
    lua_TargetInfo_Name:SetShow(true)
  end
  updateStunGauge(targetActor:get(), targetActor:get():getStun(), targetActor:get():getMaxStun())
  EnemyBuffListBoarder:SetShow(true)
  for buffIcon_idx = 0, appliedBuff_UIPool_Last do
    if appliedBuff_UIPool[buffIcon_idx] then
      appliedBuff_UIPool[buffIcon_idx]:SetShow(false)
    end
  end
  local appliedBuff = targetActor:getAppliedBuffBeginNotSort()
  local appliedBuff_Idx = 0
  appliedBuff_DATAPool = {}
  while nil ~= appliedBuff do
    local appliedBuffType
    if nil == appliedBuff_UIPool[appliedBuff_Idx] then
      local buffIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, EnemyBuffListBoarder, "monsterBuffIcon_" .. appliedBuff_Idx)
      CopyBaseProperty(monsterBuffIcon_Base, buffIcon)
      appliedBuff_UIPool[appliedBuff_Idx] = buffIcon
      if appliedBuff_Idx > appliedBuff_UIPool_Last then
        appliedBuff_UIPool_Last = appliedBuff_Idx
      end
    end
    appliedBuff_UIPool[appliedBuff_Idx]:ChangeTextureInfoNameAsync("icon/" .. appliedBuff:getIconName())
    local x1, y1, x2, y2 = setTextureUV_Func(appliedBuff_UIPool[appliedBuff_Idx], 0, 0, 32, 32)
    appliedBuff_UIPool[appliedBuff_Idx]:getBaseTexture():setUV(x1, y1, x2, y2)
    appliedBuff_UIPool[appliedBuff_Idx]:setRenderTexture(appliedBuff_UIPool[appliedBuff_Idx]:getBaseTexture())
    appliedBuff_UIPool[appliedBuff_Idx]:SetShow(true)
    appliedBuff_UIPool[appliedBuff_Idx]:SetSpanSize(appliedBuff_UIPool[appliedBuff_Idx]:GetSizeX() * appliedBuff_Idx, appliedBuff_UIPool[appliedBuff_Idx]:GetSpanSize().y)
    EnemyBuffListBoarder:SetSize(monsterBuffIcon_Base:GetSizeX() * appliedBuff_Idx, EnemyBuffListBoarder:GetSizeY())
    EnemyBuffListBoarder:ComputePos()
    appliedBuff_DATAPool[appliedBuff_Idx] = appliedBuff
    appliedBuff_Idx = appliedBuff_Idx + 1
    appliedBuff = targetActor:getAppliedBuffNextNotSort()
  end
  appliedBuff_Idx = 0
  if targetActor:get():isPlayer() then
    local playerActorProxyWrapper = getPlayerActor(actorKey)
    if playerActorProxyWrapper:get():isVolunteer() then
      lua_TargetInfo_Name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_MILITIA"))
    else
      lua_TargetInfo_Name:SetText(targetActor:getName())
    end
  else
    lua_TargetInfo_Name:SetText(targetActor:getName())
  end
  local curHP = targetActor:get():getHp()
  local maxHP = targetActor:get():getMaxHp()
  local nowHP = curHP * 100 / maxHP
  if curHP < 1 then
    Panel_Monster_Bar:SetShow(false, false)
    monsterList = {}
    FGlobal_DangerAlert_Show(false)
  end
  if targetActor:get():isMonster() then
    targetHpInfo_Update_Monster(actorKey, nowHP)
    _recentTargetInfo_TendencyOnDead_MSG(targetActor, actorKey)
  elseif targetActor:get():isPlayer() then
    targetHpInfo_Update_Player(actorKey, nowHP)
  else
    targetHpInfo_Update_Other(actorKey, nowHP)
    _recentTargetInfo_TendencyOnDead_MSG(targetActor, actorKey)
  end
  if targetActor:get():getCharacterStaticStatus()._isHiddenHp then
    lua_TargetInfo_NormalEnemyGauge:SetShow(false)
    lua_TargetInfo_NormalHpRate:SetShow(false)
    lua_TargetInfo_NormalHpRate_Later:SetShow(false)
    lua_TargetInfo_StunRate_Back:SetShow(false)
    lua_TargetInfo_StunRate:SetShow(false)
    _darkSpirit:SetShow(false)
    _helpBubble:SetShow(false)
    _helpMsg:SetShow(false)
  elseif targetActor:get():isMonster() then
    if 4 == targetActor:getCharacterGradeType() then
      lua_TargetInfo_BossEnemyGauge:SetShow(true)
      lua_TargetInfo_BossHpRate:SetShow(true)
      lua_TargetInfo_BossHpRate_Later:SetShow(true)
    else
      lua_TargetInfo_NormalEnemyGauge:SetShow(true)
      lua_TargetInfo_NormalHpRate:SetShow(true)
      lua_TargetInfo_NormalHpRate_Later:SetShow(true)
    end
  elseif targetActor:get():isPlayer() then
    lua_TargetInfo_PlayerEnemyGauge:SetShow(true)
    lua_TargetInfo_PlayerHpRate:SetShow(true)
    lua_TargetInfo_PlayerHpRate_Later:SetShow(true)
  else
    lua_TargetInfo_NormalEnemyGauge:SetShow(true)
    lua_TargetInfo_NormalHpRate:SetShow(true)
    lua_TargetInfo_NormalHpRate_Later:SetShow(true)
  end
  lua_EnemyTypeIcon:SetShow(false)
  lua_EnemyTypeText:SetShow(false)
  if targetActor:get():isMonster() then
    lua_EnemyTypeText:SetShow(true)
    lua_EnemyTypeText:SetPosX(lua_EnemyTypeIcon:GetPosX() / 2 + 27)
    lua_EnemyTypeText:SetPosY(lua_EnemyTypeIcon:GetPosY() + 11)
    local monsterType = ""
    local checkMonsterType = targetActor:getCharacterStaticStatusWrapper():getTribeType()
    if CppEnums.TribeType.eTribe_Human == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/human.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_HUMAN"))
    elseif CppEnums.TribeType.eTribe_Ain == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/ain.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_AIN"))
    elseif CppEnums.TribeType.eTribe_ETC == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/animal.dds")
      lua_EnemyTypeText:SetText("")
    elseif CppEnums.TribeType.eTribe_Boss == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/KamasylviaMonster.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_UNDEAD"))
    elseif CppEnums.TribeType.eTribe_Reptile == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/Violent.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_ETRIBEREPTILE"))
    elseif CppEnums.TribeType.eTribe_Untribe == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/etc.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_UNTRIBE"))
    elseif CppEnums.TribeType.eTribe_Hunting == checkMonsterType then
      lua_EnemyTypeIcon:ChangeTextureInfoNameAsync("New_UI_Common_forLua/Widget/EnemyGauge/hunt.dds")
      lua_EnemyTypeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_HUNT"))
    end
    lua_EnemyTypeText:SetText("")
    local x1, y1, x2, y2 = setTextureUV_Func(lua_EnemyTypeIcon, 0, 0, 32, 32)
    lua_EnemyTypeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    lua_EnemyTypeIcon:setRenderTexture(lua_EnemyTypeIcon:getBaseTexture())
    lua_EnemyTypeIcon:SetShow(true)
    local hour = math.floor(getIngameTime_minute() / 60)
    local darkNightPowerUp = targetActor:get():getCharacterStaticStatus()._isPowerUpInNight
    if (22 == hour or 0 == hour or 1 == hour) and darkNightPowerUp then
      lua_EnemyTypeIcon:EraseAllEffect()
      lua_EnemyTypeIcon:AddEffect("UI_Monster_Emergency", true, 0, 0)
    else
      lua_EnemyTypeIcon:EraseAllEffect()
    end
  end
end
function _recentTargetInfo_TendencyOnDead_MSG(targetActor, actorKey)
  if targetActor:get():hasVehicleOwner() then
    return
  end
  local targetName = targetActor:getCharacterStaticStatusWrapper():getName()
  local characterTOD = targetActor:getCharacterStaticStatusWrapper():getTendencyOnDead()
  if nil ~= characterTOD and characterTOD < 0 then
    if nil ~= nowTarget[actorKey] then
      if nowTarget[actorKey] < 10 then
        nowTarget[actorKey] = nowTarget[actorKey] + 1
      else
        nowTarget[actorKey] = 0
        if not ToClient_isDontPvPDecreaseTendency() then
          Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_CHARACTERTOD", "getName", targetName))
        end
      end
    else
      nowTarget[actorKey] = 0
      if not ToClient_isDontPvPDecreaseTendency() then
        Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_RECENTTARGETINFO_CHARACTERTOD", "getName", targetName))
      end
    end
  end
end
function updateTargetInfoCheckTime(fDeltatime)
  elapsedTime = elapsedTime + fDeltatime
  if elapsedTime > 20 then
    elapsedTime = 0
    monsterList = {}
    Panel_Monster_Bar:SetShow(false, false)
    clearTargetActor()
    FGlobal_DangerAlert_Show(false)
  end
end
function FGlobal_Panel_Monster_Bar_RePos()
  if Panel_LocalWar:GetShow() then
    Panel_Monster_Bar:SetPosY(Panel_LocalWar:GetPosY() + Panel_LocalWar:GetSizeY() - 5)
    blackBg:SetShow(false)
  else
    Panel_Monster_Bar:SetPosY(5)
    blackBg:SetShow(true)
  end
end
function hideRecentTargetInfo()
  monsterList = {}
  Panel_Monster_Bar:SetShow(false, false)
  FGlobal_DangerAlert_Show(false)
end
function GameOption_NearMonsterAlertOff()
  ToClient_SetMessageFilter(10, true)
end
registerEvent("EvnetLeaveInstanceDungeon", "hideRecentTargetInfo")
registerEvent("update_Monster_Info_Req", "panel_Update_Monster_Info")
registerEvent("stunChanged", "Panel_MonsterInfo_UpdateStun")
Panel_Monster_Bar:RegisterUpdateFunc("updateTargetInfoCheckTime")
