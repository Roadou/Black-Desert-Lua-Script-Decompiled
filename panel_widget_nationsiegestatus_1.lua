local ENUM_CLASS = PaGlobal_NationSiegeStatus.ENUM_CLASS
local ENUM_TERRITORY = PaGlobal_NationSiegeStatus.ENUM_TERRITORY
function PaGlobal_NationSiegeStatus:initialize()
  if true == PaGlobal_NationSiegeStatus._initialize then
    return
  end
  local calpheonGroup = UI.getChildControl(Panel_Widget_NationSiegeStatus, "Static_CalpheonGroup")
  local valenciaGroup = UI.getChildControl(Panel_Widget_NationSiegeStatus, "Static_ValenciaGroup")
  local calpheon_general = UI.getChildControl(calpheonGroup, "Static_General")
  local calpheon_subBoss_1 = UI.getChildControl(calpheonGroup, "Static_Van")
  local calpheon_subBoss_2 = UI.getChildControl(calpheonGroup, "Static_Commander")
  local calpheon_generalBG = UI.getChildControl(calpheon_general, "Static_BG")
  local calpheon_subBoss_1BG = UI.getChildControl(calpheon_subBoss_1, "Static_BG")
  local calpheon_subBoss_2BG = UI.getChildControl(calpheon_subBoss_2, "Static_BG")
  local calpheon_death = UI.getChildControl(calpheonGroup, "Static_CalpheonDeathBG")
  local valencia_general = UI.getChildControl(valenciaGroup, "Static_General")
  local valencia_subBoss_1 = UI.getChildControl(valenciaGroup, "Static_Van")
  local valencia_subBoss_2 = UI.getChildControl(valenciaGroup, "Static_Commander")
  local valencia_generalBG = UI.getChildControl(valencia_general, "Static_BG")
  local valencia_subBoss_1BG = UI.getChildControl(valencia_subBoss_1, "Static_BG")
  local valencia_subBoss_2BG = UI.getChildControl(valencia_subBoss_2, "Static_BG")
  local valencia_death = UI.getChildControl(valenciaGroup, "Static_ValenciaDeathBG")
  local nationCalpheon = PaGlobal_NationSiegeStatus._ui._calpheon
  nationCalpheon[ENUM_CLASS.GENERAL].txt_Name = UI.getChildControl(calpheon_general, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.GENERAL].txt_HpValue = UI.getChildControl(calpheon_general, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.GENERAL].progress_hp = UI.getChildControl(calpheon_general, "Progress_HP")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_Name = UI.getChildControl(calpheon_subBoss_1, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_HpValue = UI.getChildControl(calpheon_subBoss_1, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].progress_hp = UI.getChildControl(calpheon_subBoss_1, "Progress_HP")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_Name = UI.getChildControl(calpheon_subBoss_2, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_HpValue = UI.getChildControl(calpheon_subBoss_2, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].progress_hp = UI.getChildControl(calpheon_subBoss_2, "Progress_HP")
  nationCalpheon.txt_deadCount = UI.getChildControl(calpheon_death, "StaticText_DeathCount")
  local nationValencia = PaGlobal_NationSiegeStatus._ui._valencia
  nationValencia[ENUM_CLASS.GENERAL].txt_Name = UI.getChildControl(valencia_general, "StaticText_Name")
  nationValencia[ENUM_CLASS.GENERAL].txt_HpValue = UI.getChildControl(valencia_general, "StaticText_Progress")
  nationValencia[ENUM_CLASS.GENERAL].progress_hp = UI.getChildControl(valencia_general, "Progress_HP")
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_Name = UI.getChildControl(valencia_subBoss_1, "StaticText_Name")
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_HpValue = UI.getChildControl(valencia_subBoss_1, "StaticText_Progress")
  nationValencia[ENUM_CLASS.SUBBOSS_1].progress_hp = UI.getChildControl(valencia_subBoss_1, "Progress_HP")
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_Name = UI.getChildControl(valencia_subBoss_2, "StaticText_Name")
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_HpValue = UI.getChildControl(valencia_subBoss_2, "StaticText_Progress")
  nationValencia[ENUM_CLASS.SUBBOSS_2].progress_hp = UI.getChildControl(valencia_subBoss_2, "Progress_HP")
  nationValencia.txt_deadCount = UI.getChildControl(valencia_death, "StaticText_DeathCount")
  PaGlobal_NationSiegeStatus._ui._staticText_revivePoint = UI.getChildControl(Panel_Widget_NationSiegeStatus, "StaticText_RevivePoint")
  PaGlobal_NationSiegeStatus._siege_ClassString[ENUM_CLASS.GENERAL] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_1")
  PaGlobal_NationSiegeStatus._siege_ClassString[ENUM_CLASS.SUBBOSS_1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_2")
  PaGlobal_NationSiegeStatus._siege_ClassString[ENUM_CLASS.SUBBOSS_2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_3")
  PaGlobal_NationSiegeStatus:registEventHandler()
  PaGlobal_NationSiegeStatus:validate()
  PaGlobal_NationSiegeStatus._initialize = true
  PaGlobal_NationSiegeStatus:open()
end
function PaGlobal_NationSiegeStatus:registEventHandler()
  if nil == Panel_Widget_NationSiegeStatus then
    UI_ASSERT_NAME(nil ~= Panel_Widget_NationSiegeStatus, "PaGlobal_NationSiegeStatus:registEventHandler", "\236\178\156\235\167\140\234\184\176")
    return
  end
  registerEvent("FromClient_NationSiegeStart", "FromClient_NationSiegeStatus_Start")
  registerEvent("FromClient_NationSiegeStop", "FromClient_NationSiegeStatus_Stop")
  registerEvent("FromClient_NationSiegeBossHpChanged", "FromClient_NationSiegeStatus_BossHpChanged")
  registerEvent("FromClient_NationSiegeUpdatePlayerCount", "FromClient_NationSiegeStatus_UpdatePlayerCount")
  registerEvent("FromClient_RenderModeChangeState", "FromClient_NationSiegeStatus_renderModeChangeResetPosition")
  registerEvent("onScreenResize", "FromClient_NationSiegeStatus_ResetPosition")
  registerEvent("FromClient_UpdateNationSiegeRevivePoint", "FromClient_NationSiegeStatus_UpdateNationSiegeRevivePoint")
end
function PaGlobal_NationSiegeStatus:prepareOpen()
end
function PaGlobal_NationSiegeStatus:open()
  if nil == Panel_Widget_NationSiegeStatus then
    UI_ASSERT_NAME(nil ~= Panel_Widget_NationSiegeStatus, "PaGlobal_NationSiegeStatus:open", "\236\178\156\235\167\140\234\184\176")
    return
  end
  if false == ToClient_isBeingNationSiege() then
    return
  end
  if true == Panel_Widget_NationSiegeStatus:GetShow() then
    return
  end
  Panel_Widget_NationSiegeStatus:SetShow(true)
  PaGlobal_NationSiegeStatus:updateBossHpChanged()
  PaGlobal_NationSiegeStatus:updatePlayerCount()
  PaGlobal_NationSiegeStatus:updateRevivePoint(0)
  if nil ~= PaGlobal_MainQuest_SetShowControl then
    PaGlobal_MainQuest_SetShowControl(false)
  end
  if nil ~= PaGlobal_CheckedQuest_SetShowControl then
    PaGlobal_CheckedQuest_SetShowControl(false)
  end
end
function PaGlobal_NationSiegeStatus:prepareClose()
end
function PaGlobal_NationSiegeStatus:close()
  if nil == Panel_Widget_NationSiegeStatus then
    UI_ASSERT_NAME(nil ~= Panel_Widget_NationSiegeStatus, "PaGlobal_NationSiegeStatus:close", "\236\178\156\235\167\140\234\184\176")
    return
  end
  Panel_Widget_NationSiegeStatus:SetShow(false)
  if nil ~= PaGlobal_MainQuest_SetShowControl then
    PaGlobal_MainQuest_SetShowControl(true)
  end
  if nil ~= PaGlobal_CheckedQuest_SetShowControl then
    PaGlobal_CheckedQuest_SetShowControl(true)
  end
end
function PaGlobal_NationSiegeStatus:update()
end
function PaGlobal_NationSiegeStatus:validate()
  if nil == Panel_Widget_NationSiegeStatus then
    return
  end
  local nationCalpheon = PaGlobal_NationSiegeStatus._ui._calpheon
  nationCalpheon[ENUM_CLASS.GENERAL].txt_Name:isValidate()
  nationCalpheon[ENUM_CLASS.GENERAL].txt_HpValue:isValidate()
  nationCalpheon[ENUM_CLASS.GENERAL].progress_hp:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_Name:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_HpValue:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].progress_hp:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_Name:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_HpValue:isValidate()
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].progress_hp:isValidate()
  nationCalpheon.txt_deadCount:isValidate()
  local nationValencia = PaGlobal_NationSiegeStatus._ui._valencia
  nationValencia[ENUM_CLASS.GENERAL].txt_Name:isValidate()
  nationValencia[ENUM_CLASS.GENERAL].txt_HpValue:isValidate()
  nationValencia[ENUM_CLASS.GENERAL].progress_hp:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_Name:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_HpValue:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_1].progress_hp:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_Name:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_HpValue:isValidate()
  nationValencia[ENUM_CLASS.SUBBOSS_2].progress_hp:isValidate()
  nationValencia.txt_deadCount:isValidate()
  PaGlobal_NationSiegeStatus._ui._staticText_revivePoint:isValidate()
end
function PaGlobal_NationSiegeStatus:updateBossHpChanged()
  local nationCalpheon = PaGlobal_NationSiegeStatus._ui._calpheon
  local nationValencia = PaGlobal_NationSiegeStatus._ui._valencia
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  if nil == wrapper_Calpheon then
    return
  end
  local rate = 0
  local mainBoss_Calpheon = wrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.CALPHEON))
  if nil ~= mainBoss_Calpheon then
    rate = mainBoss_Calpheon:getHpRate() * 100
    nationCalpheon[ENUM_CLASS.GENERAL].txt_HpValue:SetText(string.format("%.2f", rate) .. "%")
    nationCalpheon[ENUM_CLASS.GENERAL].progress_hp:SetProgressRate(rate)
    nationCalpheon[ENUM_CLASS.GENERAL].txt_Name:SetText(PaGlobal_NationSiegeStatus._siege_ClassString[ENUM_CLASS.GENERAL] .. mainBoss_Calpheon:getName())
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  if nil == wrapper_Valencia then
    return
  end
  local mainBoss_Valencia = wrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.VALENCIA))
  if nil ~= mainBoss_Valencia then
    rate = mainBoss_Valencia:getHpRate() * 100
    nationValencia[ENUM_CLASS.GENERAL].txt_HpValue:SetText(string.format("%.2f", rate) .. "%")
    nationValencia[ENUM_CLASS.GENERAL].progress_hp:SetProgressRate(rate)
    nationValencia[ENUM_CLASS.GENERAL].txt_Name:SetText(PaGlobal_NationSiegeStatus._siege_ClassString[ENUM_CLASS.GENERAL] .. mainBoss_Valencia:getName())
  end
  for index = 0, ToClient_getNationSiegeSubBossCount() - 1 do
    local currentClassIndex = ENUM_CLASS.SUBBOSS_1 + index
    local subBossWrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
    local subBoss_Calpheon = subBossWrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.CALPHEON, index))
    if nil ~= subBoss_Calpheon then
      rate = subBoss_Calpheon:getHpRate() * 100
      nationCalpheon[currentClassIndex].txt_HpValue:SetText(string.format("%.2f", rate) .. "%")
      nationCalpheon[currentClassIndex].progress_hp:SetProgressRate(rate)
      nationCalpheon[currentClassIndex].txt_Name:SetText(PaGlobal_NationSiegeStatus._siege_ClassString[currentClassIndex] .. subBoss_Calpheon:getName())
    end
    local subBossWrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
    local subBoss_Valencia = subBossWrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.VALENCIA, index))
    if nil ~= subBoss_Valencia then
      rate = subBoss_Valencia:getHpRate() * 100
      nationValencia[currentClassIndex].txt_HpValue:SetText(string.format("%.2f", rate) .. "%")
      nationValencia[currentClassIndex].progress_hp:SetProgressRate(rate)
      nationValencia[currentClassIndex].txt_Name:SetText(PaGlobal_NationSiegeStatus._siege_ClassString[currentClassIndex] .. subBoss_Valencia:getName())
    end
  end
end
function PaGlobal_NationSiegeStatus:updatePlayerCount()
  if nil == ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA) or nil == ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON) then
    return
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  PaGlobal_NationSiegeStatus._ui._valencia.txt_deadCount:SetText(wrapper_Valencia:getDeadCount() .. " / 1000")
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  PaGlobal_NationSiegeStatus._ui._calpheon.txt_deadCount:SetText(wrapper_Calpheon:getDeadCount() .. " / 1000")
end
function PaGlobal_NationSiegeStatus:updateRevivePoint(point)
  local myTerritory = PaGlobal_NationSiegeStatus:getAffiliatedSiegeTeam()
  if myTerritory < 0 then
    PaGlobal_NationSiegeStatus._ui._staticText_revivePoint:SetShow(false)
    return
  end
  PaGlobal_NationSiegeStatus._ui._staticText_revivePoint:SetShow(true)
  local strTerritory = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_" .. myTerritory)
  local strPoint = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NATIONSIEGE_REVIVEPOINTVALUE", "point", point)
  PaGlobal_NationSiegeStatus._ui._staticText_revivePoint:SetText(strTerritory .. " " .. strPoint)
end
function PaGlobal_NationSiegeStatus:getAffiliatedSiegeTeam()
  local myGuildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildWrapper then
    return -1
  end
  local myGuildNo = myGuildWrapper:getGuildNo_s64()
  local participantNation = ToClient_getEnteredNationSiegeKey(myGuildNo)
  if nil ~= participantNation then
    return participantNation
  end
  return -1
end
