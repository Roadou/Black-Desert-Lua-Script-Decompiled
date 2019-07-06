local _panel = Panel_Window_Guild_MemberInfo
_panel:ignorePadSnapMoveToOtherPanel()
local GuildMemberInfo = {
  _ui = {
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _keyguide = {}
}
function GuildMemberInfo:open()
  self:update()
  _panel:SetShow(true)
end
function GuildMemberInfo:close()
  if _panel:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    _panel:SetShow(false)
  end
end
function GuildMemberInfo:update()
  local memberIdx = PaGlobalFunc_GuildMemberFunction_GetMemberIndex()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  local guildMemberInfo = guildInfo:getMember(memberIdx)
  self._ui.txt_FamliyNameValue:SetText(guildMemberInfo:getName())
  if true == guildMemberInfo:isOnline() then
    self._ui.txt_CharacterNameValue:SetText(guildMemberInfo:getCharacterName())
  else
    self._ui.txt_CharacterNameValue:SetText("-")
  end
  local usableActivity = guildMemberInfo:getUsableActivity()
  if usableActivity > 10000 then
    usableActivity = 10000
  end
  local activityText = tostring(guildMemberInfo:getTotalActivity()) .. " (<PAColor0xfface400>+" .. tostring(usableActivity) .. "<PAOldColor>)"
  self._ui.txt_ActionPointValue:SetText(activityText)
  local wpStr = guildMemberInfo:getMaxWp()
  if 0 == wpStr then
    wpStr = "-"
  end
  self._ui.txt_EnergyValue:SetText(wpStr .. "/" .. guildMemberInfo:getExplorationPoint())
  local isWarGradeOpen = ToClient_IsContentsGroupOpen("388")
  if true == isWarGradeOpen then
    local siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_E")
    if 1 == guildMemberInfo:getSiegeCombatantGrade() then
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_A")
    elseif 2 == guildMemberInfo:getSiegeCombatantGrade() then
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_B")
    elseif 3 == guildMemberInfo:getSiegeCombatantGrade() then
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_C")
    elseif 4 == guildMemberInfo:getSiegeCombatantGrade() then
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_D")
    elseif 5 == guildMemberInfo:getSiegeCombatantGrade() then
      siegGradeTempText = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_SIEGEGRADE_TOOLTIP_NAME_E")
    end
    self._ui.txt_OccupyChangeValue:SetText(siegGradeTempText)
  else
    self._ui.txt_OccupyChangeValue:SetText("-")
  end
  local leftTimeStr = guildMemberInfo:getContractedExpirationUtc()
  if 0 < Int64toInt32(getLeftSecond_TTime64(leftTimeStr)) then
    leftTimeStr = convertStringFromDatetime(getLeftSecond_TTime64(leftTimeStr))
  else
    leftTimeStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_REMAINPERIOD")
  end
  self._ui.txt_LeftTimeValue:SetText(leftTimeStr)
  local benefitText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(guildMemberInfo:getContractedBenefit()))
  self._ui.txt_DailySalaryValue:SetText(benefitText)
  local paneltyText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_AGREEMENT_MASTER_MONEY", "money", makeDotMoney(guildMemberInfo:getContractedPenalty()))
  self._ui.txt_ContractPaneltyValue:SetText(paneltyText)
end
function GuildMemberInfo:init()
  self._ui.txt_FamliyNameValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_FamilyNameValue")
  self._ui.txt_CharacterNameValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_CharacterNameValue")
  self._ui.txt_ActionPointValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_ACtionPointValue")
  self._ui.txt_EnergyValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_EnergyValue")
  self._ui.txt_OccupyChangeValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_OccupyChanceValue")
  self._ui.txt_LeftTimeValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_LeftTimeValue")
  self._ui.txt_DailySalaryValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_DailySalaryValue")
  self._ui.txt_ContractPaneltyValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_ContractPenaltyValue")
  self._keyguide = {
    UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function PaGlobalFunc_GuildMemberInfo_Open()
  local self = GuildMemberInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMemberInfo")
    return
  end
  self:open()
  return true
end
function PaGlobalFunc_GuildMemberInfo_Close()
  local self = GuildMemberInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMemberInfo")
    return
  end
  self:close()
end
function PaGlobalFunc_GuildMemberInfo_Init()
  local self = GuildMemberInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMemberInfo")
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildMemberInfo_Init")
