PaGlobal_ChatSubMenu = {
  _ui = {
    _staticBg = nil,
    _buttonWhisper = nil,
    _buttonAddFriend = nil,
    _buttonInviteParty = nil,
    _buttonInviteLargeParty = nil,
    _buttonInviteGuild = nil,
    _buttonInviteCompetition = nil,
    _buttonInviteVolunteer = nil,
    _buttonBlock = nil,
    _buttonReportGoldSeller = nil,
    _buttonBlockVote = nil,
    _buttonIntroduce = nil,
    _buttonWinClose = nil
  },
  _currentPoolIndex = nil,
  _clickedMessageIndex = nil,
  _clickedName = nil,
  _clickedUserNickName = nil,
  _clickedMsg = nil,
  _isReportGoldSellerOpen = nil,
  _initialize = false,
  isLargePartyOpen = ToClient_IsContentsGroupOpen("286")
}
runLua("UI_Data/Script/Widget/Chatting/ChatSubMenu/Panel_Widget_ChatSubMenu_1.lua")
runLua("UI_Data/Script/Widget/Chatting/ChatSubMenu/Panel_Widget_ChatSubMenu_2.lua")
registerEvent("FromClient_luaLoadComplete", "FromClient_ChatSubMenuInit")
function FromClient_ChatSubMenuInit()
  PaGlobal_ChatSubMenu:initialize()
end
