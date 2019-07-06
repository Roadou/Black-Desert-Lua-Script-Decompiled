local _panel = Panel_Window_NationSiege_Board
local ENUM_CLASS = {
  GENERAL = 1,
  SUBBOSS_1 = 2,
  SUBBOSS_2 = 3
}
local ENUM_TERRITORY = {CALPHEON = 2, VALENCIA = 4}
local siege_ClassString = {
  [ENUM_CLASS.GENERAL] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_1"),
  [ENUM_CLASS.SUBBOSS_1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_2"),
  [ENUM_CLASS.SUBBOSS_2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NATIONSIEGE_CLASSNAME_3")
}
local siegeBoard = {
  _ui = {
    btn_close = UI.getChildControl(_panel, "Button_Close")
  },
  _calpheon = {
    [ENUM_CLASS.GENERAL] = {},
    [ENUM_CLASS.SUBBOSS_1] = {},
    [ENUM_CLASS.SUBBOSS_2] = {},
    ["txt_deadCount"] = nil,
    ["teamWrapper"] = nil
  },
  _valencia = {
    [ENUM_CLASS.GENERAL] = {},
    [ENUM_CLASS.SUBBOSS_1] = {},
    [ENUM_CLASS.SUBBOSS_2] = {},
    ["txt_deadCount"] = nil,
    ["teamWrapper"] = nil
  },
  _isShow = false
}
function siegeBoard:init()
  local calpheonGroup = UI.getChildControl(_panel, "Static_CalpheonGroup")
  local valenciaGroup = UI.getChildControl(_panel, "Static_ValenciaGroup")
  local bottomGroup = UI.getChildControl(_panel, "Static_BottomBG")
  local calpheon_general = UI.getChildControl(calpheonGroup, "Static_General")
  local calpheon_subBoss_1 = UI.getChildControl(calpheonGroup, "Static_Van")
  local calpheon_subBoss_2 = UI.getChildControl(calpheonGroup, "Static_Commander")
  local calpheon_generalBG = UI.getChildControl(calpheon_general, "Static_BG")
  local calpheon_subBoss_1BG = UI.getChildControl(calpheon_subBoss_1, "Static_BG")
  local calpheon_subBoss_2BG = UI.getChildControl(calpheon_subBoss_2, "Static_BG")
  local valencia_general = UI.getChildControl(valenciaGroup, "Static_General")
  local valencia_subBoss_1 = UI.getChildControl(valenciaGroup, "Static_Van")
  local valencia_subBoss_2 = UI.getChildControl(valenciaGroup, "Static_Commander")
  local valencia_generalBG = UI.getChildControl(valencia_general, "Static_BG")
  local valencia_subBoss_1BG = UI.getChildControl(valencia_subBoss_1, "Static_BG")
  local valencia_subBoss_2BG = UI.getChildControl(valencia_subBoss_2, "Static_BG")
  local calpheon_death = UI.getChildControl(bottomGroup, "Static_CalpheonDeathBG")
  local valencia_death = UI.getChildControl(bottomGroup, "Static_ValenciaDeathBG")
  local nationCalpheon = self._calpheon
  nationCalpheon[ENUM_CLASS.GENERAL].txt_Name = UI.getChildControl(calpheon_general, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.GENERAL].stc_Profile = UI.getChildControl(calpheon_general, "Static_Profile")
  nationCalpheon[ENUM_CLASS.GENERAL].txt_HpValue = UI.getChildControl(calpheon_generalBG, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.GENERAL].progress_hp = UI.getChildControl(calpheon_generalBG, "Progress_HP")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_Name = UI.getChildControl(calpheon_subBoss_1, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].stc_Profile = UI.getChildControl(calpheon_subBoss_1, "Static_Profile")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].txt_HpValue = UI.getChildControl(calpheon_subBoss_1BG, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.SUBBOSS_1].progress_hp = UI.getChildControl(calpheon_subBoss_1BG, "Progress_HP")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_Name = UI.getChildControl(calpheon_subBoss_2, "StaticText_Name")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].stc_Profile = UI.getChildControl(calpheon_subBoss_2, "Static_Profile")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].txt_HpValue = UI.getChildControl(calpheon_subBoss_2BG, "StaticText_Progress")
  nationCalpheon[ENUM_CLASS.SUBBOSS_2].progress_hp = UI.getChildControl(calpheon_subBoss_2BG, "Progress_HP")
  nationCalpheon.txt_deadCount = UI.getChildControl(calpheon_death, "StaticText_DeathCount")
  local nationValencia = self._valencia
  nationValencia[ENUM_CLASS.GENERAL].txt_Name = UI.getChildControl(valencia_general, "StaticText_Name")
  nationValencia[ENUM_CLASS.GENERAL].stc_Profile = UI.getChildControl(valencia_general, "Static_Profile")
  nationValencia[ENUM_CLASS.GENERAL].txt_HpValue = UI.getChildControl(valencia_generalBG, "StaticText_Progress")
  nationValencia[ENUM_CLASS.GENERAL].progress_hp = UI.getChildControl(valencia_generalBG, "Progress_HP")
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_Name = UI.getChildControl(valencia_subBoss_1, "StaticText_Name")
  nationValencia[ENUM_CLASS.SUBBOSS_1].stc_Profile = UI.getChildControl(valencia_subBoss_1, "Static_Profile")
  nationValencia[ENUM_CLASS.SUBBOSS_1].txt_HpValue = UI.getChildControl(valencia_subBoss_1BG, "StaticText_Progress")
  nationValencia[ENUM_CLASS.SUBBOSS_1].progress_hp = UI.getChildControl(valencia_subBoss_1BG, "Progress_HP")
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_Name = UI.getChildControl(valencia_subBoss_2, "StaticText_Name")
  nationValencia[ENUM_CLASS.SUBBOSS_2].stc_Profile = UI.getChildControl(valencia_subBoss_2, "Static_Profile")
  nationValencia[ENUM_CLASS.SUBBOSS_2].txt_HpValue = UI.getChildControl(valencia_subBoss_2BG, "StaticText_Progress")
  nationValencia[ENUM_CLASS.SUBBOSS_2].progress_hp = UI.getChildControl(valencia_subBoss_2BG, "Progress_HP")
  nationValencia.txt_deadCount = UI.getChildControl(valencia_death, "StaticText_DeathCount")
  self:update()
  self:registEvnetHandler()
end
function siegeBoard:registEvnetHandler()
  self._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_NationSiegeBoard_Close()")
  registerEvent("FromClient_NationSiegeBossHpChanged", "FromClient_NationSiegeBoard_BossHpChanged")
  registerEvent("FromClient_NationSiegeUpdatePlayerCount", "FromClient_NationSiegeBoard_UpdatePlayerCount")
end
function siegeBoard:update()
  FromClient_NationSiegeBoard_BossHpChanged()
  FromClient_NationSiegeBoard_UpdatePlayerCount()
end
function siegeBoard:open()
  _panel:SetShow(true)
  self:update()
end
function siegeBoard:close()
  _panel:SetShow(false)
end
function FromClient_NationSiegeBoard_BossHpChanged()
  local self = siegeBoard
  local nationCalpheon = self._calpheon
  local nationValencia = self._valencia
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  if nil == wrapper_Calpheon then
    return
  end
  local rate = 0
  local mainBoss_Calpheon = wrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.CALPHEON))
  if nil ~= mainBoss_Calpheon then
    rate = mainBoss_Calpheon:getHpRate() * 100
    nationCalpheon[ENUM_CLASS.GENERAL].txt_HpValue:SetText(string.format("%.0f", rate) .. "%")
    nationCalpheon[ENUM_CLASS.GENERAL].progress_hp:SetProgressRate(rate)
    nationCalpheon[ENUM_CLASS.GENERAL].txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    nationCalpheon[ENUM_CLASS.GENERAL].txt_Name:SetText(siege_ClassString[ENUM_CLASS.GENERAL])
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  if nil == wrapper_Valencia then
    return
  end
  local mainBoss_Valencia = wrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeBossCharacterKey(ENUM_TERRITORY.VALENCIA))
  if nil ~= mainBoss_Valencia then
    rate = mainBoss_Valencia:getHpRate() * 100
    nationValencia[ENUM_CLASS.GENERAL].txt_HpValue:SetText(string.format("%.0f", rate) .. "%")
    nationValencia[ENUM_CLASS.GENERAL].progress_hp:SetProgressRate(rate)
    nationValencia[ENUM_CLASS.GENERAL].txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    nationValencia[ENUM_CLASS.GENERAL].txt_Name:SetText(siege_ClassString[ENUM_CLASS.GENERAL])
  end
  for index = 0, ToClient_getNationSiegeSubBossCount() - 1 do
    local currentClassIndex = ENUM_CLASS.SUBBOSS_1 + index
    local subBossWrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
    local subBoss_Calpheon = subBossWrapper_Calpheon:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.CALPHEON, index))
    if nil ~= subBoss_Calpheon then
      rate = subBoss_Calpheon:getHpRate() * 100
      nationCalpheon[currentClassIndex].txt_HpValue:SetText(string.format("%.0f", rate) .. "%")
      nationCalpheon[currentClassIndex].progress_hp:SetProgressRate(rate)
      nationCalpheon[currentClassIndex].txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      nationCalpheon[currentClassIndex].txt_Name:SetText(siege_ClassString[currentClassIndex])
    end
    local subBossWrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
    local subBoss_Valencia = subBossWrapper_Valencia:getBossByCharacterKey(ToClient_getNationSiegeSubBossCharacterKeyByIndex(ENUM_TERRITORY.VALENCIA, index))
    if nil ~= subBoss_Valencia then
      rate = subBoss_Valencia:getHpRate() * 100
      nationValencia[currentClassIndex].txt_HpValue:SetText(string.format("%.0f", rate) .. "%")
      nationValencia[currentClassIndex].progress_hp:SetProgressRate(rate)
      nationValencia[currentClassIndex].txt_Name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      nationValencia[currentClassIndex].txt_Name:SetText(siege_ClassString[currentClassIndex])
    end
  end
end
function FromClient_NationSiegeBoard_UpdatePlayerCount(count)
  local self = siegeBoard
  if nil == ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA) or nil == ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON) then
    return
  end
  local wrapper_Valencia = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.VALENCIA)
  self._valencia.txt_deadCount:SetText(wrapper_Valencia:getDeadCount() .. " / 1000")
  local wrapper_Calpheon = ToClient_getNationSiegeTeamWrapper(ENUM_TERRITORY.CALPHEON)
  self._calpheon.txt_deadCount:SetText(wrapper_Calpheon:getDeadCount() .. " / 1000")
end
function FromClient_NationSiegeBoard_luaLoadComplete()
  local self = siegeBoard
  self:init()
end
function PaGlobal_NationSiegeBoard_Close()
  local self = siegeBoard
  self:close()
end
function PaGlobal_NationSiegeBoard_Open()
  local self = siegeBoard
  if true == ToClient_isBeingNationSiege() then
    self:open()
  end
end
function FromClient_NationSiegeBoard_Start()
  local self = siegeBoard
end
function FromClientNationSiegeBoard_Stop()
  PaGlobal_NationSiegeBoard_Close()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_NationSiegeBoard_luaLoadComplete")
registerEvent("FromClient_NationSiegeStart", "FromClient_NationSiegeBoard_Start")
registerEvent("FromClient_NationSiegeStop", "FromClientNationSiegeBoard_Stop")
