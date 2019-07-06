PaGlobal_GuildIncentive = {
  _ui = {
    _edit_totalFundation = UI.getChildControl(Panel_Guild_Incentive_SetFund, "Edit_MoneyValue"),
    _list2_guildMember = UI.getChildControl(Panel_Guild_Incentive_MemberList, "List2_GuildList"),
    _content_memberList = {}
  },
  _totalFundation = nil,
  _totalFundation64 = nil,
  _guildMemberInfoList = {},
  _guildMemberFundLevelList = {},
  _maxFundLevelGrade = 10,
  _selectedMemberIndex = nil,
  _isIndividualSetting = false,
  _isShowBeforeTax = true,
  _defaultLevelPanelSizeY = nil,
  _defaultLevelBGSizeY = nil,
  _initialize = false
}
runLua("UI_Data/Script/Window/Guild/Console/Panel_Guild_Incentive_Renew_1.lua")
runLua("UI_Data/Script/Window/Guild/Console/Panel_Guild_Incentive_Renew_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildIncentiveInit")
function FromClient_GuildIncentiveInit()
  PaGlobal_GuildIncentive:initialize()
end
