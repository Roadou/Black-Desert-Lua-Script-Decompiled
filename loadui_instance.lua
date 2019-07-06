local renewalUiOpen = false
local UIGroup = Defines.UIGroup
local RenderMode = Defines.RenderMode
isRecordMode = false
isLuaLoadingComplete = false
local UIFontType = ToClient_getGameOptionControllerWrapper():getUIFontSizeType()
preloadUI_cahngeUIFontSize(UIFontType)
function loadLoadingUI_Instance()
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
function preLoadGameUI_Instance()
  loadUI("UI_Data/Instance/Instance_Cursor.XML", "Instance_Cursor", UIGroup.PAGameUIGroup_Window_Progress, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_OnlyPerframeUsed.XML", "Instance_OnlyPerframeUsed", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_CounterAttack.XML", "Instance_CounterAttack", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_Looting.XML", "Instance_Looting", UIGroup.PAGameUIGroup_Windows)
  loadUI("UI_Data/Instance/Instance_Window_Inventory.xml", "Instance_Window_Inventory", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dye,
    RenderMode.eRenderMode_InGameCashShop,
    RenderMode.eRenderMode_Dialog
  }))
  basicLoadUI("UI_Data/Instance/Instance_Inventory_CoolTime_Effect_Item_Slot.XML", "Instance_Inventory_CoolTime_Effect_Item_Slot", UIGroup.PAGameUIGroup_Windows)
  loadUI("UI_Data/Instance/Instance_Window_Equipment.XML", "Instance_Window_Equipment", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_Equipment_SetEffectTooltip.XML", "Instance_Equipment_SetEffectTooltip", UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_Tooltip_BattlePoint.XML", "Instance_Tooltip_BattlePoint", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  basicLoadUI("UI_Data/Instance/Instance_Scroll.xml", "Instance_Scroll", UIGroup.PAGameUIGroup_GameSystemMenu)
  basicLoadUI("UI_Data/Instance/Instance_SkillCooltime.XML", "Instance_SkillCooltime", UIGroup.PAGameUIGroup_MainUI)
  loadUI("UI_Data/Instance/Instance_Window_Skill.xml", "Instance_Window_Skill", UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
  loadUI("UI_Data/Instance/Instance_FieldViewMode.xml", "Instance_FieldViewMode", UIGroup.PAGameUIGroup_InstanceMission, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_UISetting
  }))
  loadUI("UI_Data/Instance/Instance_MessageBox.XML", "Instance_MessageBox", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_Damage.XML", "Instance_Damage", UIGroup.PAGameUIGroup_Dialog)
  basicLoadUI("UI_Data/Instance/Instance_Widget_MainStatus_User_Bar.XML", "Instance_Widget_MainStatus_User_Bar", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_ClassResource.XML", "Instance_ClassResource", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_Widget_Adrenallin.XML", "Instance_Widget_Adrenallin", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_GuardGauge.XML", "Instance_GuardGauge", UIGroup.PAGameUIGroup_MainUI)
  loadUI("UI_Data/Instance/Instance_NakMessage.XML", "Instance_NakMessage", UIGroup.PAGameUIGroup_ModalDialog, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_RewardSelect_NakMessage.XML", "Instance_RewardSelect_NakMessage", UIGroup.PAGameUIGroup_Chatting, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog
  }))
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
  basicLoadUI("UI_Data/Instance/Instance_NoticeAlert.XML", "Instance_NoticeAlert", UIGroup.PAGameUIGroup_GameSystemMenu)
  basicLoadUI("UI_Data/Instance/Instance_QuickSlot.XML", "Instance_QuickSlot", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_Stamina.XML", "Instance_Stamina", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Instance_Casting_Bar.XML", "Instance_Casting_Bar", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_Collect_Bar.XML", "Instance_Collect_Bar", UIGroup.PAGameUIGroup_Window_Progress)
  basicLoadUI("UI_Data/Instance/Instance_Product_Bar.XML", "Instance_Product_Bar", UIGroup.PAGameUIGroup_Window_Progress)
  basicLoadUI("UI_Data/Instance/Instance_Enchant_Bar.XML", "Instance_Enchant_Bar", UIGroup.PAGameUIGroup_Window_Progress)
  basicLoadUI("UI_Data/Instance/Instance_Acquire.XML", "Instance_Acquire", UIGroup.PAGameUIGroup_Chatting, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Default,
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_SkillWindow
  }))
  basicLoadUI("UI_Data/Instance/Instance_Widget_Monster_Bar.XML", "Instance_Widget_Monster_Bar", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Region.XML", "Instance_Region", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Instance_AppliedBuffList.xml", "Instance_AppliedBuffList", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_WatchingMode.XML", "Instance_WatchingMode", UIGroup.PAGameUIGroup_Interaction)
  basicLoadUI("UI_Data/Instance/Instance_Interaction.XML", "Instance_Interaction", UIGroup.PAGameUIGroup_Interaction)
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
  basicLoadUI("UI_Data/Instance/Instance_CoolTime_Effect.XML", "Instance_CoolTime_Effect", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_CoolTime_Effect_Slot.XML", "Instance_CoolTime_Effect_Slot", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_CoolTime_Effect_Item.XML", "Instance_CoolTime_Effect_Item", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_CoolTime_Effect_Item_Slot.XML", "Instance_CoolTime_Effect_Item_Slot", UIGroup.PAGameUIGroup_MainUI)
  loadUI("UI_Data/Instance/Instance_DeadMessage.XML", "Instance_DeadMessage", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Dialog,
    RenderMode.eRenderMode_Default
  }))
  loadUI("UI_Data/Instance/Instance_ScreenShot_For_Desktop.XML", "Instance_ScreenShot_For_Desktop", UIGroup.PAGameUIGroup_ModalDialog, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_Loading
  }))
  basicLoadUI("UI_Data/Instance/Instance_DeadNodeSelect.XML", "Instance_DeadNodeSelect", UIGroup.PAGameUIGroup_FadeScreen)
  basicLoadUI("UI_Data/Instance/Instance_DangerAlert.XML", "Instance_DangerAlert", UIGroup.PAGameUIGroup_ScreenEffect)
  basicLoadUI("UI_Data/Instance/Instance_ActionMessage.xml", "Instance_ActionMessage", UIGroup.PAGameUIGroup_Interaction)
  basicLoadUI("UI_Data/Instance/Instance_Message_Under18.xml", "Instance_Message_Under18", UIGroup.PAGameUIGroup_FadeScreen)
  basicLoadUI("UI_Data/Instance/Instance_Widget_RemainTime.xml", "Instance_Widget_RemainTime", UIGroup.PAGameUIGroup_FadeScreen)
  basicLoadUI("UI_Data/Instance/Instance_MessageHistory.XML", "Instance_MessageHistory", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_MessageHistory_BTN.XML", "Instance_MessageHistory_BTN", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Widget_Leave.XML", "Instance_Widget_Leave", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Widget_Timer.XML", "Instance_Widget_Timer", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Widget_NormalTimer.XML", "Instance_Widget_NormalTimer", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Fade_Screen.XML", "Instance_Fade_Screen", UIGroup.PAGameUIGroup_FadeScreen)
  loadUI("UI_Data/Instance/Instance_FullScreenFade.XML", "Instance_FullScreenFade", UIGroup.PAGameUIGroup_FadeScreen, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_WorldMap_Main.XML", "Instance_WorldMap_Main", UIGroup.PAGameUIGroup_Interaction, PAUIRenderModeBitSet({
    RenderMode.eRenderMode_WorldMap,
    RenderMode.eRenderMode_Loading
  }))
  loadUI("UI_Data/Instance/Instance_Widget_ItemSlot.XML", "Instance_Widget_ItemSlot", UIGroup.PAGameUIGroup_Interaction, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Window_Map.XML", "Instance_Window_Map", UIGroup.PAGameUIGroup_Interaction, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_Widget_BetterEquipment.XML", "Instance_Widget_BetterEquipment", UIGroup.PAGameUIGroup_MainUI)
  basicLoadUI("UI_Data/Instance/Instance_Widget_GameTips.XML", "Instance_Widget_GameTips", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Instance_Widget_GameTipMask.XML", "Instance_Widget_GameTipMask", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Lobby/LobbyInstance_Window_ModeBranch.xml", "LobbyInstance_Window_ModeBranch", UIGroup.PAGameUIGroup_Windows)
  basicLoadUI("UI_Data/Instance/Instance_Window_Result.XML", "Instance_Window_Result", UIGroup.PAGameUIGroup_SimpleTooltip)
  basicLoadUI("UI_Data/Instance/Instance_Radar.XML", "Instance_Radar", UIGroup.PAGameUIGroup_Widget)
  loadUI("UI_Data/Instance/Instance_Widget_KillLog.XML", "Instance_Widget_KillLog", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_Widget_BattleRoyaleVoiceChat.XML", "Instance_Widget_BattleRoyaleVoiceChat", UIGroup.PAGameUIGroup_Widget)
  loadUI("UI_Data/Instance/Instance_Chatting_Filter.XML", "Instance_Chatting_Filter", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Window_NumberPad.XML", "Instance_Window_NumberPad", UIGroup.PAGameUIGroup_ModalDialog, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Actor_NameTag_OtherPlayer.XML", "Instance_Actor_NameTag_OtherPlayer", UIGroup.PAGameUIGroup_MainUI, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Instance/Instance_Widget_Party.XML", "Instance_Widget_Party", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Instance_Widget_ItemLog.XML", "Instance_Widget_ItemLog", UIGroup.PAGameUIGroup_Widget)
  basicLoadUI("UI_Data/Instance/Instance_Widget_KillMessage.XML", "Instance_Widget_KillMessage", UIGroup.PAGameUIGroup_Widget)
  loadUI("UI_Data/Instance/Instance_Window_WatchingMode.XML", "Instance_Window_WatchingMode", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_RoomMemberList.XML", "Instance_RoomMemberList", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Widget_EquipmentList.XML", "Instance_Widget_EquipmentList", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Mission.XML", "Instance_Mission", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/Instance_Widget_WatchTimer.XML", "Instance_Widget_WatchTimer", UIGroup.PAGameUIGroup_MapRegion, SETRENDERMODE_BITSET_ALLRENDER())
  loadUI("UI_Data/Instance/GuideMessage/Instance_Widget_GuideMessage.XML", "Instance_Widget_GuideMessage", UIGroup.PAGameUIGroup_Widget, SETRENDERMODE_BITSET_ALLRENDER())
  basicLoadUI("UI_Data/Window/FadeScreen/Common_FadeOut.XML", "Common_FadeOut", UIGroup.PAGameUIGroup_FadeScreen)
  loadUI("UI_Data/Instance/TrayConfirm/Instance_TrayConfirm.XML", "Instance_TrayConfirm", UIGroup.PAGameUIGroup_Windows, SETRENDERMODE_BITSET_ALLRENDER())
end
function loadGameUI_Instance()
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
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Skill.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Item.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_Common.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_SimpleText.lua")
  runLua("UI_Data/Script/Instance/Instance_NakMessage.lua")
  runLua("UI_Data/Script/Instance/Instance_RewardSelect_NakMessage.lua")
  runLua("UI_Data/Script/Instance/Instance_Stamina.lua")
  runLua("UI_Data/Script/Instance/Instance_Acquire.lua")
  runLua("UI_Data/Script/Instance/Instance_MessageHistory.lua")
  runLua("UI_Data/Script/Instance/Instance_Region.lua")
  runLua("UI_Data/Script/Instance/Instance_DeadMessage.lua")
  runLua("UI_Data/Script/Instance/Instance_Looting.lua")
  runLua("UI_Data/Script/Instance/Instance_Scroll.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Equipment.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Inventory.lua")
  runLua("UI_Data/Script/Instance/Instance_Equipment_SetEffectTooltip.lua")
  runLua("UI_Data/Script/Instance/Instance_Tooltip_BattlePoint.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Skill_Awaken.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Skill_Global.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Skill_Event.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Skill_Animation.lua")
  runLua("UI_Data/Script/Instance/Instance_QuickSlot.lua")
  runLua("UI_Data/Script/Instance/Instance_SkillCooltime.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_MainStatus_User_Bar.lua")
  runLua("UI_Data/Script/Instance/Instance_ClassResource.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_Adrenallin.lua")
  runLua("UI_Data/Script/Instance/Instance_SelfPlayer_HpCheck.lua")
  runLua("UI_Data/Script/Instance/Instance_GuardGauge.lua")
  runLua("UI_Data/Script/Instance/Instance_NoticeAlert.lua")
  runLua("UI_Data/Script/Instance/Instance_Damage.lua")
  runLua("UI_Data/Script/Instance/Instance_AppliedBuff_Main.lua")
  runLua("UI_Data/Script/Instance/Instance_AppliedBuff_Control.lua")
  runLua("UI_Data/Script/Instance/Instance_Interaction.lua")
  runLua("UI_Data/Script/Instance/Instance_WatchingMode.lua")
  runLua("UI_Data/Script/Instance/Instance_ProgressBar.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_Monster_Bar.lua")
  runLua("UI_Data/Script/Instance/Instance_MessageBox.lua")
  ToClient_initializeWorldMap("UI_Data/Instance/Instance_Worldmap_Grand_Base.XML")
  runLua("UI_Data/Script/Instance/Instance_WorldMap_PopupManager.lua")
  runLua("UI_Data/Script/Instance/Instance_WorldMap.lua")
  runLua("UI_Data/Script/Instance/Instance_Grand_WorldMap_MainPanel.lua")
  runLua("UI_Data/Script/Instance/Instance_OnlyPerframeUsed.lua")
  runLua("UI_Data/Script/Instance/Instance_Common_MainStatus.lua")
  runLua("UI_Data/Script/QASupport/QASupportMain.lua")
  runLua("UI_Data/Script/QASupport/QADontSpawn.lua")
  runLua("UI_Data/Script/QASupport/QASupportDamageWriter.lua")
  runLua("UI_Data/Script/Instance/Instance_globalCloseManager_ExceptionList.lua")
  runLua("UI_Data/Script/Instance/Instance_globalCloseManager_Renew.lua")
  runLua("UI_Data/Script/Instance/Instance_globalKeyBinderUiInputType.lua")
  runLua("UI_Data/Script/Instance/Instance_globalKeyBinderManager.lua")
  runLua("UI_Data/Script/Instance/Instance_globalKeyBinder.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_RemainTime.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_Leave.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_Timer.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_NormalTimer.lua")
  runLua("UI_Data/Script/Instance/Instance_FullScreenFade.lua")
  runLua("UI_Data/Script/Instance/Instance_Fade_Screen.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_ItemSlot.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Map.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_BetterEquipment.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_GameTips.lua")
  runLua("UI_Data/Script/Instance/Lobby/LobbyInstance_Window_ModeBranch.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_Result.lua")
  runLua("UI_Data/Script/Instance/Instance_Radar_GlobalValue.lua")
  runLua("UI_Data/Script/Instance/Instance_Radar_Background.lua")
  runLua("UI_Data/Script/Instance/Instance_Radar_Pin.lua")
  runLua("UI_Data/Script/Instance/Instance_Radar.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_KillLog.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_KillMessage.lua")
  runLua("UI_Data/Script/Instance/Instance_Chatting_Filter.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_NumberPad.lua")
  runLua("UI_Data/Script/Instance/Instance_CharacterNameTag.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_Party.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_ItemLog.lua")
  runLua("UI_Data/Script/Instance/Instance_Window_WatchingMode.lua")
  runLua("UI_Data/Script/Instance/Instance_ScreenShot_For_Desktop.lua")
  runLua("UI_Data/Script/Instance/Instance_RoomMemberList.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_EquipmentList.lua")
  runLua("UI_Data/Script/Instance/Instance_Mission.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_WatchTimer.lua")
  runLua("UI_Data/Script/Instance/Instance_Widget_BattleRoyaleVoiceChat.lua")
  runLua("UI_Data/Script/Instance/GuideMessage/Instance_Widget_GuideMessage.lua")
  runLua("UI_Data/Script/Widget/FadeScreen/Common_FadeOut.lua")
  runLua("UI_Data/Script/Instance/TrayConfirm/Instance_TrayConfirm.lua")
  isLuaLoadingComplete = true
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
PaGlobal_SetLoadUIFunc(loadLoadingUI_Instance, LOADUI_TYPE.loadingUI)
PaGlobal_SetLoadUIFunc(preLoadGameUI_Instance, LOADUI_TYPE.preLoadGameUI)
PaGlobal_SetLoadUIFunc(loadGameUI_Instance, LOADUI_TYPE.GameUI)
