local renewalUiOpen = false
local UIGroup = Defines.UIGroup
local RenderMode = Defines.RenderMode
isRecordMode = false
isLuaLoadingComplete = false
local UIFontType = ToClient_getGameOptionControllerWrapper():getUIFontSizeType()
preloadUI_cahngeUIFontSize(UIFontType)
function loadLoadingUI_InstanceLobby()
  loadUI("UI_Data/UI_Loading/UI_Loading_Progress_BattleRoyal.xml", "Panel_Loading", UIGroup.PAGameUIGroup_GameSystemMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Loading
  }))
  runLua("UI_Data/Script/Panel_Loading_BattleRoyal.lua")
  basicLoadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeName.XML", "Panel_NodeName", UIGroup.PAGameUIGroup_Interaction)
  basicLoadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode.XML", "Panel_NodeMenu", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_InSideNode_Guild.XML", "Panel_NodeOwnerInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeSiegeTooltip.XML", "Panel_NodeSiegeTooltip", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_WarInfo.XML", "Panel_Win_Worldmap_WarInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap/UI_New_Worldmap_NodeWarInfo.XML", "Panel_Win_Worldmap_NodeWarInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_NavigationButton.XML", "Panel_NaviButton", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_ResultDetectUser.XML", "Panel_DetectUserButton", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Widget/WarInfoMessage/Panel_WarInfoMessage.XML", "Panel_WarInfoMessage", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Widget/WarInfoMessage/Panel_TerritoryWarKillingScore.XML", "Panel_TerritoryWarKillingScore", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Window/HouseInfo/Panel_WolrdHouseInfo.XML", "Panel_WolrdHouseInfo", UIGroup.PAGameUIGroup_WorldMap_Popups)
  basicLoadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
  ToClient_initializeWorldMap("UI_Data/Window/Worldmap_Grand/Worldmap_Grand_Base.XML")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PopupManager.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap.lua")
  runLua("UI_Data/Script/Window/WorldMap_Grand/Grand_WorldMap_NodeMenu.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_WarInfo.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_HouseHold.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Knowledge.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_Delivery.lua")
  runLua("UI_Data/Script/Window/Worldmap_Grand/New_WorldMap_PinGuide.lua")
  runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
end
function preLoadGameUI_InstanceLobby()
  loadUI("UI_Data/Instance/Instance_Cursor.XML", "Instance_Cursor", UIGroup.PAGameUIGroup_Window_Progress, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_OnlyPerframeUsed.XML", "Instance_OnlyPerframeUsed", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_Looting.XML", "Instance_Looting", UIGroup.PAGameUIGroup_Windows)
  loadUI("UI_Data/Instance/Instance_FieldViewMode.xml", "Instance_FieldViewMode", UIGroup.PAGameUIGroup_InstanceMission, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_UISetting
  }))
  loadUI("UI_Data/Instance/Instance_MessageBox.XML", "Instance_MessageBox", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_NakMessage.XML", "Instance_NakMessage", UIGroup.PAGameUIGroup_ModalDialog, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Chat.XML", "Instance_Chat", UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_Chatting_Input.XML", "Instance_Chatting_Input", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_SniperGame
  }))
  loadUI("UI_Data/Instance/Instance_Chatting_Macro.XML", "Instance_Chatting_Macro", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_Chat_SocialMenu.XML", "Instance_Chat_SocialMenu", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_Chat_SubMenu.XML", "Instance_Chat_SubMenu", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_Chatting_Color.XML", "Instance_Chatting_Color", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_ChatOption.XML", "Instance_ChatOption", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_ChatOptionPart.XML", "Instance_ChatOptionPart", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap
  }))
  loadUI("UI_Data/Instance/Instance_Chat_Emoticon.XML", "Instance_Chat_Emoticon", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_SniperGame
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Skill.XML", "Instance_Tooltip_Skill", UIGroup.PAGameUIGroup_GameMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Skill_forLearning.XML", "Instance_Tooltip_Skill_forLearning", UIGroup.PAGameUIGroup_GameMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Skill_forBlackSpirit.XML", "Instance_Tooltip_Skill_forBlackSpirit", UIGroup.PAGameUIGroup_GameMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Item.XML", "Instance_Tooltip_Item", UIGroup.PAGameUIGroup_SimpleTooltip, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_InGameCashShop,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_HouseInstallation,
    RenderMode.eRenderMode_Dye
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Item_chattingLinkedItem.XML", "Instance_Tooltip_Item_chattingLinkedItem", UIGroup.PAGameUIGroup_SimpleTooltip, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Dye,
    RenderMode.eRenderMode_HouseInstallation,
    RenderMode.eRenderMode_InGameCashShop
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Item_chattingLinkedItemClick.XML", "Instance_Tooltip_Item_chattingLinkedItemClick", UIGroup.PAGameUIGroup_SimpleTooltip, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Dye,
    RenderMode.eRenderMode_HouseInstallation,
    RenderMode.eRenderMode_InGameCashShop
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_Item_equipped.XML", "Instance_Tooltip_Item_equipped", UIGroup.PAGameUIGroup_SimpleTooltip, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Dye,
    RenderMode.eRenderMode_HouseInstallation,
    RenderMode.eRenderMode_InGameCashShop
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_SimpleText.XML", "Instance_Tooltip_SimpleText", UIGroup.PAGameUIGroup_SimpleTooltip, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Tooltip_Common.XML", "Instance_Tooltip_Common", UIGroup.PAGameUIGroup_GameMenu, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Dye,
    RenderMode.eRenderMode_HouseInstallation,
    RenderMode.eRenderMode_InGameCashShop
  }))
  loadUI("UI_Data/Instance/Instance_Chatting_Filter.XML", "Instance_Chatting_Filter", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_DeadMessage.XML", "LobbyInstance_DeadMessage", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Default
  }))
  basicLoadUI("UI_Data/Instance/Instance_Widget_GameTips.XML", "Instance_Widget_GameTips", UIGroup.PAGameUIGroup_Widget)
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_Actor_NameTag_OtherPlayer.XML", "LobbyInstance_Actor_NameTag_OtherPlayer", UIGroup.PAGameUIGroup_MainUI, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Interaction.XML", "LobbyInstance_Interaction", UIGroup.PAGameUIGroup_Interaction)
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Party.XML", "LobbyInstance_Widget_Party", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  if true == _ContentsGroup_Instance_Tier then
    basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Leave.XML", "LobbyInstance_Widget_Leave", UIGroup.PAGameUIGroup_Interaction)
    loadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Rating.XML", "LobbyInstance_Widget_Rating", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
    loadUI("UI_Data/Instance/Lobby/LobbyInstance_Window_MyInfo.XML", "LobbyInstance_Window_MyInfo", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
    basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Window_ModeBranch.xml", "LobbyInstance_Window_ModeBranch", UIGroup.PAGameUIGroup_Windows)
    loadUI("UI_Data/Instance/Lobby/LobbyInstance_Window_Guide.XML", "LobbyInstance_Window_Guide", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
    loadUI("UI_Data/Instance/Instance_Window_RewardList.XML", "Instance_Window_RewardList", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
  else
    basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Leave_Old.XML", "LobbyInstance_Widget_Leave", UIGroup.PAGameUIGroup_Interaction)
    loadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_Guide.XML", "LobbyInstance_Widget_Guide", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
    loadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_MyInfo.XML", "LobbyInstance_Widget_MyInfo", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
    loadUI("UI_Data/Instance/Instance_Window_RewardList_Old.XML", "Instance_Window_RewardList", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
  end
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_HelpMessage.XML", "LobbyInstance_HelpMessage", UIGroup.PAGameUIGroup_GameMenu, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_WebControl.XML", "LobbyInstance_WebControl", UIGroup.PAGameUIGroup_DeadMessage, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_RoomMessageBox.XML", "LobbyInstance_RoomMessageBox", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_RoomPassword.XML", "LobbyInstance_RoomPassword", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_ScreenShot_For_Desktop.XML", "Instance_ScreenShot_For_Desktop", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Loading
  }))
  loadUI("UI_Data/Instance/Lobby/LobbyInstance_BattleRoyalRank_Web.XML", "LobbyInstance_BattleRoyalRank_Web", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_IME.XML", "LobbyInstance_IME", UIGroup.PAGameUIGroup_ModalDialog)
  if true == _ContentsGroup_isNewOption then
    basicLoadUI("UI_Data/Window/c_Option/Panel_Option_Main.XML", "Panel_Window_cOption", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Camera.XML", "Panel_Performance_Camera", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_GraphicQuality.XML", "Panel_Performance_GraphicQuality", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Npc.XML", "Panel_Performance_Npc", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Performance_Optimize.XML", "Panel_Performance_Optimize", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Alert.XML", "Panel_Function_Alert", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Convenience.XML", "Panel_Function_Convenience", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Etc.XML", "Panel_Function_Etc", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Interaction.XML", "Panel_Function_Interaction", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Nation.XML", "Panel_Function_Nation", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_View.XML", "Panel_Function_View", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Function_Worldmap.XML", "Panel_Function_Worldmap", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Camera.XML", "Panel_Graphic_Camera", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Effect.XML", "Panel_Graphic_Effect", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Quality.XML", "Panel_Graphic_Quality", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_ScreenShot.XML", "Panel_Graphic_ScreenShot", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Window.XML", "Panel_Graphic_Window", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Graphic_Hdr.XML", "Panel_Graphic_HDR", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_Action.XML", "Panel_Interface_Action", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_Function.XML", "Panel_Interface_Function", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_Mouse.XML", "Panel_Interface_Mouse", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_Pad.XML", "Panel_Interface_Pad", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_QuickSlot.XML", "Panel_Interface_QuickSlot", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Interface_UI.XML", "Panel_Interface_UI", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Sound_OnOff.XML", "Panel_Sound_OnOff", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Sound_Volume.XML", "Panel_Sound_Volume", UIGroup.PAGameUIGroup_Windows)
    basicLoadUI("UI_Data/Window/c_Option/Option_Alert_Alarm.XML", "Panel_Alert_Alarm", UIGroup.PAGameUIGroup_Windows)
  end
  basicLoadUI("UI_Data/Window/Option/Panel_SetShortCut.XML", "Panel_SetShortCut", UIGroup.PAGameUIGroup_Windows)
  loadUI("UI_Data/Window/SaveSetting/Panel_SaveSetting.XML", "Panel_SaveSetting", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Window/UI_Setting/Panel_UI_Setting.XML", "Panel_UI_Setting", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_UISetting
  }))
  loadUI("UI_Data/Window/UI_Setting/Panel_SaveFreeSet.XML", "Panel_SaveFreeSet", UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_UISetting
  }))
  basicLoadUI("UI_Data/Window/Copyright/Panel_Window_Copyright.XML", "Panel_Copyright", UIGroup.PAGameUIGroup_Windows)
  loadUI("UI_Data/Instance/Instance_Widget_SniperGame.xml", "Panel_SniperGame", UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_SniperGame
  }))
  loadUI("UI_Data/Instance/Instance_Widget_SniperGame_Result.xml", "Panel_SniperGame_Result", UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_SniperGame
  }))
  loadUI("UI_Data/Instance/Instance_Widget_SniperReload.xml", "MiniGame_SniperReload", UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_SniperGame
  }))
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_PartyList.xml", "Panel_PartyList", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_PartyRecruite.xml", "Panel_PartyRecruite", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Widget_RandomMatch.xml", "LobbyInstance_Widget_RandomMatch", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Window/FadeScreen/Common_FadeOut.XML", "Common_FadeOut", UIGroup.PAGameUIGroup_FadeScreen)
  loadUI("UI_Data/Instance/Instance_Window_NumberPad.XML", "Instance_Window_NumberPad", UIGroup.PAGameUIGroup_ModalDialog, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/TrayConfirm/Instance_TrayConfirm.XML", "Instance_TrayConfirm", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
end
function loadGameUI_InstanceLobby()
  runLua("UI_Data/Script/Instance/Instance_DragManager.lua")
  runLua("UI_Data/Script/Instance/Instance_globalPreLoadUI.lua")
  runLua("UI_Data/Script/Instance/Instance_Common_UIMode.lua")
  runLua("UI_Data/Script/Instance/Instance_FieldViewMode.lua")
  runLua("UI_Data/Script/Instance/Instance_ChatOption.lua")
  runLua("UI_Data/Script/Instance/Instance_Chat.lua")
  runLua("UI_Data/Script/Instance/Instance_Chatting_Input.lua")
  runLua("UI_Data/Script/Instance/Instance_Chatting_Macro.lua")
  runLua("UI_Data/Script/Instance/Instance_Chat_SocialMenu.lua")
  runLua("UI_Data/Script/Instance/Instance_CreateChattingContent.lua")
  runLua("UI_Data/Script/Instance/Instance_Chat_Emoticon.lua")
  runLua("UI_Data/Script/Instance/Instance_Chatting_Filter.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Skill.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Item.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Common.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_SimpleText.lua")
  runLua("UI_Data/Script/Instance/Instance_NakMessage.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_DeadMessage.lua")
  runLua("UI_Data/Script/Instance/Instance_MessageBox.lua")
  runLua("UI_Data/Script/Instance/Instance_OnlyPerframeUsed.lua")
  runLua("UI_Data/Script/QASupport/QASupportMain.lua")
  runLua("UI_Data/Script/QASupport/QADontSpawn.lua")
  runLua("UI_Data/Script/QASupport/QASupportDamageWriter.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_CharacterNameTag.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_globalCloseManager_ExceptionList.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_globalCloseManager_Renew.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_globalKeyBinderUiInputType.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_globalKeyBinderManager.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_globalKeyBinder.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Interaction.lua")
  if true == _ContentsGroup_Instance_Tier then
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Party.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_ModeBranch.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Leave.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Rating.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_MyInfo.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_Guide.lua")
    runLua("UI_Data/Script/Instance/Instance_Window_RewardList.lua")
  else
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Party_Old.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Leave_Old.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_Guide.lua")
    runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_MyInfo.lua")
    runLua("UI_Data/Script/Instance/Instance_Window_RewardList_Old.lua")
  end
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Empty.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_HelpMessage.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_WebControl.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_RoomMessageBox.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_RoomPassword.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_BattleRoyalRank_Web.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Ime.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Widget_RandomMatch.lua")
  if true == _ContentsGroup_isNewOption then
    runLua("UI_Data/Script/Window/Option/GameOptionHeader.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionMain.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionUtil.lua")
    runLua("UI_Data/Script/Window/Option/Panel_Option_Main.lua")
  elseif true == _ContentsGroup_RenewUI_RenewOPtion then
    runLua("UI_Data/Script/Window/Option/GameOptionHeader_Renew.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionMain_Renew.lua")
    runLua("UI_Data/Script/Window/Option/GameOptionUtil.lua")
    runLua("UI_Data/Script/Window/Option/Panel_Option_Main_Renew.lua")
  end
  runLua("UI_Data/Script/Window/Option/Panel_SetShortCut.lua")
  runLua("UI_Data/Script/Window/SaveSetting/Panel_SaveSetting.lua")
  runLua("UI_Data/Script/Window/Copyright/Panel_Copyright.lua")
  runLua("UI_Data/Script/Window/UI_Setting/Panel_UI_Setting.lua")
  runLua("UI_Data/Script/Instance/Instance_ScreenShot_For_Desktop.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_SniperReload.lua")
  runLua("UI_Data/Script/global_fromActionChart_LuaEvent.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_SniperGame_Control.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_SniperGame.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_SniperGame_Result.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_PartyList.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_PartyRecruite.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_NumberPad.lua")
  runLua("UI_Data/Script/Widget/FadeScreen/Common_FadeOut.lua")
  runLua("UI_Data/Script/Instance/TrayConfirm/Instance_TrayConfirm.lua")
  isLuaLoadingComplete = true
end
function loadLobbyUI_InstanceLobby()
end
function loadLoginUI_InstanceLobby()
  basicLoadUI("UI_Data/UI_Lobby/UI_TermsofGameUse.XML", "Panel_TermsofGameUse", UIGroup.PAGameUIGroup_Movie)
  if true == _ContentsGroup_RemasterUI_Lobby then
    basicLoadUI("UI_Data/UI_Lobby/Panel_Lobby_Login_Remaster.xml", "Panel_Login_Remaster", UIGroup.PAGameUIGroup_MainUI)
    basicLoadUI("UI_Data/UI_Lobby/UI_Login_Nickname.XML", "Panel_Login_Nickname", UIGroup.PAGameUIGroup_GameSystemMenu)
  else
    basicLoadUI("UI_Data/UI_Lobby/UI_Login.xml", "Panel_Login", UIGroup.PAGameUIGroup_MainUI)
    basicLoadUI("UI_Data/UI_Lobby/UI_Login_Nickname.XML", "Panel_Login_Nickname", UIGroup.PAGameUIGroup_GameSystemMenu)
  end
  basicLoadUI("UI_Data/UI_Lobby/UI_Login_Password.XML", "Panel_Login_Password", UIGroup.PAGameUIGroup_GameSystemMenu)
  basicLoadUI("UI_Data/Window/MessageBox/UI_Win_System.XML", "Panel_Win_System", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Window/MessageBox/Panel_ScreenShot_For_Desktop.XML", "Panel_ScreenShot_For_Desktop", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Window/MessageBox/Panel_KickOff.XML", "Panel_KickOff", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Widget/UIcontrol/UI_SpecialCharacter.XML", "Panel_SpecialCharacter", UIGroup.PAGameUIGroup_ModalDialog)
  basicLoadUI("UI_Data/Widget/HelpMessage/Panel_HelpMessage.xml", "Panel_HelpMessage", UIGroup.PAGameUIGroup_GameMenu)
  basicLoadUI("UI_Data/UI_Lobby/UI_GamerTag.XML", "Panel_GamerTag", UIGroup.PAGameUIGroup_GameSystemMenu, SETRENDERMODE_BITSET_ALLRENDER())
  runLua("UI_Data/Script/Panel_GamerTag.lua")
  basicLoadUI("UI_Data/Widget/NakMessage/NakMessage.XML", "Panel_NakMessage", UIGroup.PAGameUIGroup_ModalDialog)
  runLua("UI_Data/Script/Widget/NakMessage/NakMessage.lua")
  runLua("UI_Data/Script/Panel_TermsofGameUse.lua")
  if true == _ContentsGroup_RemasterUI_Lobby then
    runLua("UI_Data/Script/Panel_Login_Remaster.lua")
  else
    runLua("UI_Data/Script/Panel_Login.lua")
  end
  runLua("UI_Data/Script/Panel_Login_Nickname.lua")
  runLua("UI_Data/Script/Panel_Login_Password.lua")
  runLua("UI_Data/Script/Window/MessageBox/MessageBox.lua")
  runLua("UI_Data/Script/Window/MessageBox/Panel_ScreenShot_For_Desktop.lua")
  runLua("UI_Data/Script/Window/MessageBox/Panel_KickOff.lua")
  runLua("UI_Data/Script/globalKeyBinderNotPlay.lua")
  runLua("UI_Data/Script/Panel_SpecialCharacter.lua")
  runLua("UI_Data/Script/Widget/HelpMessage/Panel_HelpMessage.lua")
  preLoadGameOptionUI()
  loadGameOptionUI()
end
PaGlobal_SetLoadUIFunc(loadLoginUI_InstanceLobby, LOADUI_TYPE.loginUI)
PaGlobal_SetLoadUIFunc(loadLoadingUI_InstanceLobby, LOADUI_TYPE.loadingUI)
PaGlobal_SetLoadUIFunc(preLoadGameUI_InstanceLobby, LOADUI_TYPE.preLoadGameUI)
PaGlobal_SetLoadUIFunc(loadGameUI_InstanceLobby, LOADUI_TYPE.GameUI)
PaGlobal_SetLoadUIFunc(loadLobbyUI_InstanceLobby, LOADUI_TYPE.lobbyUI)
