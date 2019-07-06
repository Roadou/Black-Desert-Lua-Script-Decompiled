local UI_IT = CppEnums.UiInputType
function HandleEventLUp_MenuRemake_HeadMenu(headermenuIndex)
  PaGlobal_Menu_Remake:headMenu_select(headermenuIndex)
end
function HandleEventLUp_MenuRemake_Menu(menuIndex)
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:menu_select(menuIndex)
end
function HandleEventLUp_MenuRemake_subMenu(submenuIndex)
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:submenu_select(submenuIndex)
end
function HandleEventLUp_MenuRemake_searchText()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:selected_searchText()
end
function HandleEventLUp_MenuRemake_ChangeCustomizeMode()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:menuCustomize_toggle()
end
function HandleEventLUp_MenuRemake_ChangeOpenWay()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:setMenuOpenWay()
end
function HandleEventLUp_MenuRemake_Commit()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:headmenuCustomize_confirm()
end
function HandleEventLUp_MenuRemake_Cancel()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:headmenuCustomize_cancel()
end
function HandleEventLUp_MenuRemake_SearchingMenu(searchMenuIndex)
  PaGlobal_Menu_Remake:searchMenu_select(searchMenuIndex)
end
function HandleEventOn_MenuRemake_SearchingMenu(searchMenuIndex)
  PaGlobal_Menu_Remake:searchMenu_toggle(searchMenuIndex, true)
end
function HandleEventOn_MenuRemake_ChangeUi()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:showChangeUiToolTip()
end
function HandleEventOn_MenuRemake_ChangeOpenWay()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:showOpenWayToolTip()
end
function HandleEventOn_MenuRemake_ChangeCustomizeMode()
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:showCustomizeToolTip()
end
function HandleEventOn_MenuRemake_HeadMenu(headermenuIndex)
  if nil == headermenuIndex then
    return
  end
  PaGlobal_Menu_Remake:headMenu_toggle(headermenuIndex)
end
function HandleEventOn_MenuRemake_Menu(menuIndex)
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:menu_toggle(menuIndex, true)
end
function HandleEventOn_MenuRemake_subMenu(submenuIndex)
  if nil == Panel_Widget_Menu_Remake then
    return
  end
  PaGlobal_Menu_Remake:submenu_toggle(submenuIndex, true)
end
function HandleEventOut_MenuRemake_HeadMenu(headermenuIndex)
  if nil == headermenuIndex then
    return
  end
  PaGlobal_Menu_Remake:resetHeadMenuTitle()
end
function HandleEventKeyBoard_MenuRemake_KeyPushCheck()
  if nil == Panel_Widget_Menu_Remake then
    return true
  end
  if true == PaGlobal_Menu_Remake_GetShow() and true == PaGlobal_Menu_Remake:checkPressedHotKey() then
    return false
  end
  return true
end
function HandleEventKeyBoard_MenuRemake_arrowKey(keycode)
  if nil == keycode then
    return
  end
  PaGlobal_Menu_Remake:pressedArrowKey(keycode)
end
function HandleEventKeyBoard_MenuRemake_searchingMenu()
  if nil == Panel_Widget_Menu_Remake then
    return false
  end
  PaGlobal_Menu_Remake:searchingMenu()
end
function HandleEventPadUP_MenuRemake_Move(keycode)
  if nil == keycode then
    return
  end
  PaGlobal_Menu_Remake:pressedPadKey(keycode)
end
function HandleEventLUp_MenuRemake_Escape()
  if ToClient_IsMyselfInArena() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ARSHA_COMMON_ARLERT"))
    return
  elseif true == ToClient_getJoinGuildBattle() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TAG_CANTDO_GUILDBATTLE"))
    return
  end
  HandleClicked_RescueConfirm()
end
function HandleEventLUp_MenuRemake_BlackDesertLab()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  if player:get():getLevel() < 56 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LEVEL_LIMITED_GLOBAL_LABS"))
    return
  end
  if true == ToClient_isCompleteTesterSubmit() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALREADY_TESTER_SUBMIT"))
    return
  end
  PaGlobal_BlackDesertLab_Show()
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  if player:get():getLevel() < 56 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LEVEL_LIMITED_GLOBAL_LABS"))
    return
  end
  if true == ToClient_isCompleteTesterSubmit() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALREADY_TESTER_SUBMIT"))
    return
  end
  PaGlobal_BlackDesertLab_Show()
end
function HandleEventLUp_MenuRemake_TradeEvent()
  if _ContentsGroup_isUsedNewTradeEventNotice then
    FGlobal_TradeEventNotice_Renewal_Show()
  else
    TradeEventInfo_Show()
  end
end
function HandleEventLUp_MenuRemake_Market()
  FGlobal_ItemMarket_Open_ForWorldMap(1, true)
  audioPostEvent_SystemUi(1, 30)
end
function HandleEventLUp_MenuRemake_Localwar()
  local playerWrapper = getSelfPlayer()
  local player = playerWrapper:get()
  local hp = player:getHp()
  local maxHp = player:getMaxHp()
  local isGameMaster = ToClient_SelfPlayerIsGM()
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    FGlobal_LocalWarInfo_Open()
  elseif hp == maxHp or isGameMaster then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_LOCALWAR_GETOUT_MEMO")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = FGlobal_LocalWarInfo_GetOut,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_MAXHP_CHECK"))
  end
end
function HandleEventLUp_MenuRemake_FreeFight()
  local player = getSelfPlayer():get()
  local maxHp = player:getMaxHp()
  local playerHp = player:getHp()
  if player:getLevel() < 50 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_FREEFIGHTALERT"))
    return
  end
  local curChannelData = getCurrentChannelServerData()
  if true == curChannelData._isSiegeChannel then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_BATTLEGROURND"))
    return
  end
  if ToClient_IsJoinPvpBattleGround() then
    local FunctionYesUnJoinPvpBattle = function()
      ToClient_UnJoinPvpBattleGround()
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_UNJOIN")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = FunctionYesUnJoinPvpBattle,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  elseif maxHp == playerHp then
    if false == IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_CONDITION_WAIT"))
      return
    end
    audioPostEvent_SystemUi(1, 18)
    local FunctionYesJoinPvpBattle = function()
      ToClient_JoinPvpBattleGround(0)
    end
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_PVPBATTLEGROUND_JOIN")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = messageBoxMemo,
      functionYes = FunctionYesJoinPvpBattle,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_CHECKHP"))
  end
end
function HandleEventLUp_MenuRemake_Wave()
  if ToClient_getPlayNowSavageDefence() then
    FGlobal_SavegeDefenceInfo_unjoin()
  else
    FGlobal_SavageDefenceInfo_Open()
  end
end
function HandleEventLUp_MenuRemake_Competitiongame()
  if ToClient_IsHostInArena() and ToClient_IsCompetitionHost() then
    FGlobal_ArshaPvP_Open()
  elseif ToClient_IsMyselfInArena() then
    FGlobal_ArshaPvP_Open()
  elseif ToClient_IsCompetitionHost() == false then
    PaGlobalFunc_CompetitionGame_JoinDesc_Open()
  else
    FGlobal_ArshaPvP_HostJoin()
  end
end
function HandleEventLUp_MenuRemake_Siege()
  if true == _ContentsGroup_SeigeSeason5 then
    FGlobal_GuildWarInfo_renew_Open()
  else
    FGlobal_GuildWarInfo_Show()
  end
end
function HandleEventLUp_MenuRemake_InfinityDefence()
  PaGlobal_HandleClicked_BloodAltar_Open()
end
function HandleEventLUp_MenuRemake_FeedBack()
  local isUrl = "https://account.global-lab.playblackdesert.com/Member/Login?_returnUrl=https%3A%2F%2Fwww.global-lab.playblackdesert.com/CS/SUGGEST/WRITE"
  ToClient_OpenChargeWebPage(isUrl, false)
end
function HandleEventLUp_MenuRemake_Myinfo()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_PlayerInfo)
end
function HandleEventLUp_MenuRemake_Inventory()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_Inventory)
end
function HandleEventLUp_MenuRemake_Skill()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_Skill)
end
function HandleEventLUp_MenuRemake_Fairy()
  PaGlobal_FairyInfo_Open(false)
end
function HandleEventLUp_MenuRemake_CashShop()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_CashShop)
end
function HandleEventLUp_MenuRemake_WorldMap()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_WorldMap)
end
function HandleEventLUp_MenuRemake_BlackSpirit()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_BlackSpirit)
end
function HandleEventLUp_MenuRemake_QuestHistory()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_QuestHistory)
end
function HandleEventLUp_MenuRemake_MentalKnowledge()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_MentalKnowledge)
end
function HandleEventLUp_MenuRemake_Present()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Present)
end
function HandleEventLUp_MenuRemake_Mail()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_Mail)
end
function HandleEventLUp_MenuRemake_Manufacture()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_Manufacture)
end
function HandleEventLUp_MenuRemake_Personalbattle()
  PaGlobal_PersonalBattle:open()
end
function HandleEventLUp_MenuRemake_Beauty()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_BeautyShop)
end
function HandleEventLUp_MenuRemake_Dyeing()
  GlobalKeyBinder_MouseKeyMap(UI_IT.UiInputType_Dyeing)
end
function HandleEventLUp_MenuRemake_BeautyAlbum()
  FGlobal_CustomizingAlbum_Show(false, CppEnums.ClientSceneState.eClientSceneStateType_InGame)
end
function HandleEventLUp_MenuRemake_Notice()
  EventNotify_Open(true, true)
end
function HandleEventLUp_MenuRemake_Update()
  Panel_WebHelper_ShowToggle("Update")
end
function HandleEventLUp_MenuRemake_Event()
  EventNotify_Open(true, true)
end
function HandleEventLUp_MenuRemake_KnownIssue()
  Panel_WebHelper_ShowToggle("KnownIssue")
end
function HandleEventLUp_MenuRemake_Camp()
  PaGlobal_Camp:open()
end
function HandleEventUp_MenuRemake_Mail()
  GlobalKeyBinder_MouseKeyMap(CppEnums.UiInputType.UiInputType_Mail)
end
function FromClient_Menu_Remake_OnScreenResize()
  PaGlobal_Menu_Remake:resizeMenu()
end
