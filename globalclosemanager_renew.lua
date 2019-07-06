local closeTypeBitSet = {
  none = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_CantClose
  }),
  attacked = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape,
    Defines.CloseType.eCloseType_Attacked
  }),
  attackedOnly = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Attacked
  }),
  default = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }),
  forceOnly = PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Force
  })
}
local _isAllClose = false
function addCloseExceptionList()
  if nil ~= PaGlobalFunc_GetDamagePanel_Count then
    for index = 1, PaGlobalFunc_GetDamagePanel_Count() do
      if nil ~= PaGlobalFunc_GetDamagePanel(index) then
        table.insert(panel_exceptionList, PaGlobalFunc_GetDamagePanel(index))
      end
    end
  end
end
function closeExceptionListInitialize()
  for index, panel in pairs(PaGlobal_panelExceptionList) do
    if nil ~= panel then
      panel:RegisterCloseLuaFunc(closeTypeBitSet.none, "")
    end
  end
  panel_exceptionList = nil
  PaGlobal_panelExceptionList = nil
end
function registerCloseLuaEvent(panel, closeFlag, closeFunc)
  if nil == panel or nil == closeFlag or nil == closeFunc then
    return
  end
  panel:RegisterCloseLuaFunc(closeFlag, closeFunc)
end
function registerClosePanelList()
  registerCloseLuaEvent(Panel_EventNotify, closeTypeBitSet.default, "PanelCloseFunc_EventNotify()")
  registerCloseLuaEvent(Panel_NewsBanner, closeTypeBitSet.default, "PaGlobalFunc_NewsBanner_Close()")
  if false == _ContentsGroup_PanelReload_Develop or true == _ContentsGroup_RenewUI then
    registerCloseLuaEvent(Panel_MiniGame_Find, closeTypeBitSet.default, "PanelCloseFunc_MiniGameFind()")
    registerCloseLuaEvent(Panel_Window_ServantInventory, closeTypeBitSet.default, "ServantInventory_Close()")
    registerCloseLuaEvent(Panel_Guild_GetGuildMemberBonus, closeTypeBitSet.default, "FGlobal_GetGuildMemberBonus_Hide()")
    registerCloseLuaEvent(Panel_Window_Guild, closeTypeBitSet.default, "PanelCloseFunc_Guild()")
    registerCloseLuaEvent(Panel_Window_Profile, closeTypeBitSet.default, "HandleClicked_ProfileWindow_Close()")
    registerCloseLuaEvent(Panel_Window_CharInfo_Status, closeTypeBitSet.default, "PanelEscapeFunc_CharacterInfo_Close()")
    registerCloseLuaEvent(Panel_Guild_NoneJoinMember, closeTypeBitSet.default, "PaGlobal_Guild_NoneJoinMember:Close()")
    registerCloseLuaEvent(Panel_Guild_ChoiseTheMoney, closeTypeBitSet.default, "PaGlobal_Guild_ChoiseTheMoney:Hide()")
    registerCloseLuaEvent(Panel_GuildIncentive, closeTypeBitSet.default, "PanelCloseFunc_GuildIncentive()")
    registerCloseLuaEvent(Panel_Gacha_Roulette, closeTypeBitSet.attacked, "FGlobal_Gacha_Roulette_Close()")
    registerCloseLuaEvent(Panel_RandomBoxSelect, closeTypeBitSet.attacked, "FGlobal_Gacha_Roulette_Close()")
    registerCloseLuaEvent(MiniGame_SniperReload, PAUIRenderModeBitSet({
      Defines.CloseType.eCloseType_Attacked
    }), "PaGlobalFunc_SniperGame_EndSniperGame()")
    registerCloseLuaEvent(Panel_SniperGame, PAUIRenderModeBitSet({
      Defines.CloseType.eCloseType_Attacked
    }), "PaGlobalFunc_SniperGame_EndSniperGame()")
    registerCloseLuaEvent(Panel_SniperGame_Result, PAUIRenderModeBitSet({
      Defines.CloseType.eCloseType_Attacked
    }), "PaGlobalFunc_SniperGame_EndSniperGame()")
  end
  registerCloseLuaEvent(Panel_Window_DailyStamp, closeTypeBitSet.default, "PanelCloseFunc_DailyStamp()")
  registerCloseLuaEvent(Panel_Window_DailyChallenge, closeTypeBitSet.default, "PaGlobalFunc_DailyChallenge_Close()")
  registerCloseLuaEvent(Panel_Window_ArshaTeamNameChange, closeTypeBitSet.default, "PanelCloseFunc_ArshaTeamNameChange()")
  registerCloseLuaEvent(Panel_Window_ArshaInviteList, closeTypeBitSet.default, "PanelCloseFunc_ArshaInviteList()")
  registerCloseLuaEvent(Panel_Window_Arsha, closeTypeBitSet.default, "PanelCloseFunc_Arsha()")
  registerCloseLuaEvent(Panel_ScreenShotAlbum_FullScreen, closeTypeBitSet.default, "PanelCloseFunc_ScreenShotAlbumFullScreen()")
  registerCloseLuaEvent(Panel_ScreenShotAlbum, closeTypeBitSet.default, "PanelCloseFunc_ScreenShotAlbum()")
  registerCloseLuaEvent(Panel_Window_BlackSpiritAdventure, closeTypeBitSet.default, "PanelCloseFunc_BlackSpiritAdventure()")
  registerCloseLuaEvent(Panel_Window_BlackSpiritAdventure_2, closeTypeBitSet.default, "PanelCloseFunc_BlackSpiritAdventure2()")
  registerCloseLuaEvent(Panel_Window_BlackSpiritAdventureVerPC, closeTypeBitSet.default, "PanelCloseFunc_BlackSpiritAdventureVerPC()")
  registerCloseLuaEvent(Panel_Window_ClothInventory, closeTypeBitSet.default, "PanelCloseFunc_ClothInventory()")
  registerCloseLuaEvent(Panel_Window_Mercenary, closeTypeBitSet.default, "PanelCloseFunc_Mercenary()")
  registerCloseLuaEvent(Panel_Window_MasterpieceAuction, closeTypeBitSet.default, "PanelCloseFunc_MasterpieceAuction()")
  registerCloseLuaEvent(Panel_MovieGuide_Web, closeTypeBitSet.default, "PanelCloseFunc_MovieGuideWeb()")
  registerCloseLuaEvent(Panel_MovieGuide_Weblist, closeTypeBitSet.default, "PanelCloseFunc_MovieGuideWebList()")
  registerCloseLuaEvent(Panel_MovieSkillGuide_Web, closeTypeBitSet.default, "PanelCloseFunc_MovieSkillGuideWeblist()")
  registerCloseLuaEvent(Panel_MovieSkillGuide_Weblist, closeTypeBitSet.default, "PanelCloseFunc_MovieSkillGuide()")
  registerCloseLuaEvent(Panel_Window_Quest_New_Option, closeTypeBitSet.default, "PanelCloseFunc_CheckedQuestQption()")
  registerCloseLuaEvent(Panel_SaveSetting, closeTypeBitSet.default, "PanelCloseFunc_SaveSetting()")
  registerCloseLuaEvent(Panel_HarvestList, closeTypeBitSet.default, "PanelCloseFunc_HarvestList()")
  registerCloseLuaEvent(Panel_PartyRecruite, closeTypeBitSet.default, "PanelCloseFunc_PartyRecruite()")
  registerCloseLuaEvent(Panel_ServantResurrection, closeTypeBitSet.default, "PanelCloseFunc_ServantResurrection()")
  registerCloseLuaEvent(Panel_Dialog_NPCShop, closeTypeBitSet.default, "PanelCloseFunc_DialogNPCShopRenew()")
  registerCloseLuaEvent(Panel_Window_NpcShop, closeTypeBitSet.default, "PanelCloseFunc_DialogNPCShop()")
  registerCloseLuaEvent(Panel_Window_Camp, closeTypeBitSet.default, "PanelCloseFunc_Camp()")
  registerCloseLuaEvent(Panel_Window_CampRegister, closeTypeBitSet.default, "PanelCloseFunc_CampRegister()")
  registerCloseLuaEvent(Panel_Window_MonsterRanking, closeTypeBitSet.default, "PanelCloseFunc_MonsterRanking()")
  registerCloseLuaEvent(Panel_ChatOption, closeTypeBitSet.default, "PanelCloseFunc_ChatOption()")
  registerCloseLuaEvent(Panel_Window_BuildingBuff, closeTypeBitSet.default, "PanelCloseFunc_BuildingBuff()")
  registerCloseLuaEvent(Panel_Window_PersonalBattle, closeTypeBitSet.default, "PanelCloseFunc_PersonalBattle()")
  registerCloseLuaEvent(Panel_Memo_List, closeTypeBitSet.default, "PanelCloseFunc_Memo()")
  registerCloseLuaEvent(Panel_Guild_OneOnOneRequest, closeTypeBitSet.default, "PanelCloseFunc_GuildOneOnOneRequest()")
  registerCloseLuaEvent(Panel_CustomizingAlbum, closeTypeBitSet.default, "PanelCloseFunc_CustomizingAlbum()")
  registerCloseLuaEvent(Panel_IntroMovie, closeTypeBitSet.default, "PanelCloseFunc_IntroMovie()")
  registerCloseLuaEvent(Panel_Chatting_Input, closeTypeBitSet.default, "PanelCloseFunc_ChattingInput()")
  registerCloseLuaEvent(Panel_ButtonShortcuts, closeTypeBitSet.default, "PanelCloseFunc_ButtonShortcuts()")
  registerCloseLuaEvent(Panel_TranslationReport, closeTypeBitSet.default, "PanelCloseFunc_TranslationReport()")
  registerCloseLuaEvent(Panel_ProductNote, closeTypeBitSet.default, "PanelCloseFunc_ProductNote()")
  registerCloseLuaEvent(Panel_KeyboardHelp, closeTypeBitSet.default, "PanelCloseFunc_KeyboardHelp()")
  registerCloseLuaEvent(Panel_WebControl, closeTypeBitSet.default, "PanelCloseFunc_WebControl()")
  registerCloseLuaEvent(Panel_Window_Warehouse, closeTypeBitSet.default, "PanelCloseFunc_Warehouse()")
  registerCloseLuaEvent(Panel_SetVoiceChat, closeTypeBitSet.default, "PanelCloseFunc_SetVoiceChat()")
  registerCloseLuaEvent(Panel_Window_VoiceChat, closeTypeBitSet.default, "PanelCloseFunc_VoiceChat()")
  registerCloseLuaEvent(Panel_WorkerChangeSkill, closeTypeBitSet.default, "PanelCloseFunc_WorkerChangeSkill()")
  registerCloseLuaEvent(Panel_FileExplorer, closeTypeBitSet.default, "PanelCloseFunc_FileExplorer()")
  registerCloseLuaEvent(Panel_WorkerManager, closeTypeBitSet.default, "PanelCloseFunc_WorkerManager()")
  registerCloseLuaEvent(Panel_WorkerRestoreAll, closeTypeBitSet.default, "PanelCloseFunc_WorkerRestoreAll()")
  registerCloseLuaEvent(Panel_Worker_Auction, closeTypeBitSet.default, "PanelCloseFunc_WorkerAuction()")
  registerCloseLuaEvent(Panel_WorkerResist_Auction, closeTypeBitSet.default, "PanelCloseFunc_WorkerResistAuction()")
  registerCloseLuaEvent(Panel_WorkerList_Auction, closeTypeBitSet.default, "PanelCloseFunc_WorkerListAuction()")
  registerCloseLuaEvent(Panel_Window_Exchange, closeTypeBitSet.default, "PanelCloseFunc_Exchange()")
  registerCloseLuaEvent(Panel_TransferLifeExperience, closeTypeBitSet.default, "PanelCloseFunc_TransferLifeExperience()")
  registerCloseLuaEvent(Panel_DyePalette, closeTypeBitSet.default, "PanelCloseFunc_DyePalette()")
  registerCloseLuaEvent(Panel_SetShortCut, closeTypeBitSet.default, "PanelCloseFunc_SetShortCut()")
  registerCloseLuaEvent(Panel_Window_Manufacture, closeTypeBitSet.default, "PanelCloseFunc_Manufacture()")
  registerCloseLuaEvent(Panel_Window_Alchemy, closeTypeBitSet.default, "PanelCloseFunc_Alchemy()")
  registerCloseLuaEvent(Panel_Window_Inventory, closeTypeBitSet.default, "PanelCloseFunc_Inventory()")
  registerCloseLuaEvent(Panel_Window_Exchange_Number, closeTypeBitSet.default, "PanelCloseFunc_ExchangeNumber()")
  registerCloseLuaEvent(Panel_Window_cOption, closeTypeBitSet.default, "PanelCloseFunc_Option()")
  registerCloseLuaEvent(Panel_CarveSeal, closeTypeBitSet.default, "PanelCloseFunc_CarveSeal()")
  registerCloseLuaEvent(Panel_GuildWebInfo, closeTypeBitSet.default, "PanelCloseFunc_GuildWebInfo()")
  registerCloseLuaEvent(Panel_GuildRank_Web, closeTypeBitSet.default, "PanelCloseFunc_GuildRankWeb()")
  registerCloseLuaEvent(Panel_Guild_Rank, closeTypeBitSet.default, "PanelCloseFunc_GuildRank()")
  registerCloseLuaEvent(Panel_ChangeWeapon, closeTypeBitSet.default, "PanelCloseFunc_ChangeWeapon()")
  registerCloseLuaEvent(Panel_SkillReinforce, closeTypeBitSet.default, "PanelCloseFunc_SkillReinforce()")
  registerCloseLuaEvent(Panel_FriendList, closeTypeBitSet.default, "PanelCloseFunc_FriendList()")
  registerCloseLuaEvent(Panel_FriendList_All, closeTypeBitSet.default, "PanelCloseFunc_FriendList()")
  registerCloseLuaEvent(Panel_CheckedQuestInfo, closeTypeBitSet.default, "PanelCloseFunc_CheckedQuest()")
  registerCloseLuaEvent(Panel_Window_Quest_New, closeTypeBitSet.default, "PanelCloseFunc_Quest()")
  registerCloseLuaEvent(Panel_Window_QuestInfo, closeTypeBitSet.default, "PanelCloseFunc_QuestRenew()")
  registerCloseLuaEvent(Panel_Window_Delivery_Request, closeTypeBitSet.default, "PanelCloseFunc_DeliveryRequest()")
  registerCloseLuaEvent(Panel_AgreementGuild_Master, closeTypeBitSet.default, "PanelCloseFunc_AgreementGuildMaster()")
  registerCloseLuaEvent(Panel_AgreementGuild, closeTypeBitSet.default, "PanelCloseFunc_AgreementGuildMaster()")
  registerCloseLuaEvent(Panel_GuildDuel, closeTypeBitSet.default, "PanelCloseFunc_GuildDuel()")
  registerCloseLuaEvent(Panel_Window_GameTips, closeTypeBitSet.default, "PanelCloseFunc_GameTips()")
  registerCloseLuaEvent(Panel_Window_PetInfoNew, closeTypeBitSet.default, "PanelCloseFunc_PetInfoNew()")
  registerCloseLuaEvent(Panel_Event_100Day, closeTypeBitSet.default, "PanelCloseFunc_Event100Day()")
  registerCloseLuaEvent(Panel_DanceFrame, closeTypeBitSet.default, "PanelCloseFunc_DanceFrame()")
  registerCloseLuaEvent(Panel_Worker_Tooltip, closeTypeBitSet.default, "PanelCloseFunc_WorkerTooltip()")
  registerCloseLuaEvent(Panel_ChangeItem, closeTypeBitSet.default, "PanelCloseFunc_ChangeItem()")
  registerCloseLuaEvent(Panel_MovieGuide, closeTypeBitSet.default, "PanelCloseFunc_MovieGuide()")
  registerCloseLuaEvent(Panel_Window_ItemMarket, closeTypeBitSet.default, "PanelCloseFunc_ItemMarket()")
  registerCloseLuaEvent(Panel_AlchemyStone, closeTypeBitSet.default, "PanelCloseFunc_AlchemyStone()")
  registerCloseLuaEvent(Panel_AlchemyFigureHead, closeTypeBitSet.default, "PanelCloseFunc_AlchemyFigureHead()")
  registerCloseLuaEvent(Panel_MovieTheater_320, closeTypeBitSet.default, "PanelCloseFunc_MovieTheater320()")
  registerCloseLuaEvent(Panel_CharacterTag, closeTypeBitSet.default, "PanelCloseFunc_CharacterTag()")
  registerCloseLuaEvent(Panel_FairyInfo, closeTypeBitSet.default, "PanelCloseFunc_FairyInfo()")
  registerCloseLuaEvent(Panel_Window_FairySetting, closeTypeBitSet.default, "PanelCloseFunc_FairySetting()")
  registerCloseLuaEvent(Panel_Window_FairyUpgrade, closeTypeBitSet.default, "PanelCloseFunc_FairyUpgrade()")
  registerCloseLuaEvent(Panel_Window_FaIryTierUpgrade, closeTypeBitSet.default, "PaGlobalFunc_fairySkill_Close()")
  registerCloseLuaEvent(Panel_Win_System, closeTypeBitSet.default, "PanelCloseFunc_MessageBox()")
  registerCloseLuaEvent(Panel_Win_Check, closeTypeBitSet.default, "PanelCloseFunc_MessageBoxCheck()")
  registerCloseLuaEvent(Panel_LifeRanking, closeTypeBitSet.default, "PanelCloseFunc_LifeRanking()")
  registerCloseLuaEvent(Panel_LifeRanking_All, closeTypeBitSet.default, "PanelCloseFunc_LifeRanking()")
  registerCloseLuaEvent(Panel_ChannelSelect, closeTypeBitSet.default, "PanelCloseFunc_ChannelSelect()")
  registerCloseLuaEvent(Panel_Window_MentalGame, closeTypeBitSet.default, "PanelCloseFunc_MentalGameClose()")
  registerCloseLuaEvent(Panel_Dialog_SkillSpecialize, closeTypeBitSet.default, "PaGlobalFunc_Dialog_SkillSpecialize_OnPadB()")
  registerCloseLuaEvent(Panel_QuickMenuCustom, closeTypeBitSet.default, "PanelCloseFunc_QuickMenuCustom()")
  registerCloseLuaEvent(Panel_Console_Window_GuildAgreement, closeTypeBitSet.default, "PanelCloseFunc_GuildAgreementClose()")
  registerCloseLuaEvent(Panel_Console_Window_SignOption, closeTypeBitSet.default, "PanelCloseFunc_GuildSignOption()")
  registerCloseLuaEvent(Panel_Window_CharacterInfo_Renew, closeTypeBitSet.default, "PaGlobalFunc_Window_CharacterInfo_Close()")
  registerCloseLuaEvent(Panel_Window_Knowledge_Renew, closeTypeBitSet.default, "PaGlobalFunc_Window_Knowledge_GOBackStep()")
  registerCloseLuaEvent(Panel_Window_Menu_Renew, closeTypeBitSet.default, "PanelCloseFunc_MenuRenew()")
  registerCloseLuaEvent(Panel_Console_Window_GuildCreate, closeTypeBitSet.default, "PanelCloseFunc_GuildCreate()")
  registerCloseLuaEvent(Panel_Console_Dialog_GuildPopup, closeTypeBitSet.default, "PanelCloseFunc_GuildPopup_Close()")
  registerCloseLuaEvent(Panel_Knowledge_Main, closeTypeBitSet.default, "Panel_Knowledge_Hide()")
  registerCloseLuaEvent(Panel_IngameCashShop_GoodsTooltip, closeTypeBitSet.default, "FGlobal_CashShop_GoodsTooltipInfo_Close()")
  registerCloseLuaEvent(Panel_Widget_Chatting_Renew, closeTypeBitSet.default, "Input_ChattingInfo_OnPadBNotEditting()")
  registerCloseLuaEvent(Panel_Chatting_BlockList, closeTypeBitSet.default, "PaGlobal_Chatting_BlockList:prepareClose()")
  registerCloseLuaEvent(Panel_Chatting_FunctionList, closeTypeBitSet.default, "PaGlobal_Chatting_FunctionList:prepareClose()")
  registerCloseLuaEvent(Panel_Dialog_NpcGift_Renew, closeTypeBitSet.default, "PanelCloseFunc_NpcGift_Close()")
  registerCloseLuaEvent(Panel_Customizing_BodyShape, closeTypeBitSet.default, "PanelCloseFunc_Customization_BodyShape_Close()")
  registerCloseLuaEvent(Panel_Customizing_BodyPose, closeTypeBitSet.default, "PanelCloseFunc_Customization_BodyPose_Close()")
  registerCloseLuaEvent(Panel_Customizing_CommonDecoration, closeTypeBitSet.default, "PanelCloseFunc_Customization_Deco_Close()")
  registerCloseLuaEvent(Panel_Customizing_FaceShape, closeTypeBitSet.default, "PanelCloseFunc_Customization_FaceShape_Close()")
  registerCloseLuaEvent(Panel_Customizing_HairShape, closeTypeBitSet.default, "PanelCloseFunc_Customization_HairShape_Close()")
  registerCloseLuaEvent(Panel_Customizing_InputName, closeTypeBitSet.default, "PanelCloseFunc_Customization_InputName_Close()")
  registerCloseLuaEvent(Panel_Customizing_Mesh, closeTypeBitSet.default, "PanelCloseFunc_Customization_Mesh_Close()")
  registerCloseLuaEvent(Panel_Customizing_ShowOutfit, closeTypeBitSet.default, "PanelCloseFunc_Customization_ShowOutfit_Close()")
  registerCloseLuaEvent(Panel_Customizing_ShowPose, closeTypeBitSet.default, "PanelCloseFunc_Customization_ShowPose_Close()")
  registerCloseLuaEvent(Panel_Customizing_Skin, closeTypeBitSet.default, "PanelCloseFunc_Customization_Skin_Close()")
  registerCloseLuaEvent(Panel_Customizing_Voice, closeTypeBitSet.default, "PanelCloseFunc_Customization_Voice_Close()")
  registerCloseLuaEvent(Panel_Window_Mail_Renew, closeTypeBitSet.default, "PanelCloseFunc_MailRenew_Close()")
  registerCloseLuaEvent(Panel_Window_PetList_Renew, closeTypeBitSet.default, "PanelCloseFunc_PetList_Close()")
  registerCloseLuaEvent(Panel_Window_PetFood_Renew, closeTypeBitSet.default, "FGlobal_PetFeedClose()")
  registerCloseLuaEvent(Panel_Window_PetCommand_Renew, closeTypeBitSet.default, "FGlobal_PetCommand_Close()")
  registerCloseLuaEvent(Panel_Window_PetInfo_Renew, closeTypeBitSet.default, "PaGlobalFunc_PetInfo_Close()")
  registerCloseLuaEvent(Panel_Window_PetExchange_Renew, closeTypeBitSet.attacked, "PanelCloseFunc_PetExchange_Close()")
  registerCloseLuaEvent(Panel_Window_PetExchange_Appearance_Renew, closeTypeBitSet.default, "PaGlobalFunc_PetExchangeAppearance_Close()")
  registerCloseLuaEvent(Panel_Window_PetLookChange_Renew, closeTypeBitSet.default, "PaGlobalFunc_PetLookChange_Close()")
  registerCloseLuaEvent(Panel_Window_PetExchange_Skill_Renew, closeTypeBitSet.default, "PaGlobalFunc_PetExchangeSkill_Close()")
  registerCloseLuaEvent(Panel_Window_PetRegister_Renew, closeTypeBitSet.default, "PaGlobalFunc_PetRegister_Cancle()")
  registerCloseLuaEvent(Panel_Window_Delivery_Renew, closeTypeBitSet.default, "PanelCloseFunc_PanelDelivery_Close()")
  registerCloseLuaEvent(Panel_Window_Expedition, closeTypeBitSet.default, "PanelCloseFunc_PanelExpedition_Close()")
  registerCloseLuaEvent(Panel_Window_PartyInvite, closeTypeBitSet.default, "PaGlobalFunc_PartyInvite_Exit()")
  registerCloseLuaEvent(Panel_Window_PartySetting, closeTypeBitSet.default, "PaGlobalFunc_PartySetting_Exit()")
  registerCloseLuaEvent(Panel_PartyList, closeTypeBitSet.default, "PanelCloseFunc_FindParty_Close()")
  registerCloseLuaEvent(Panel_Worldmap_NodeInfo, closeTypeBitSet.default, "PanelCloseFunc_WorldMap_NodeInfo_Close()")
  registerCloseLuaEvent(Panel_Worldmap_NodeManagement, closeTypeBitSet.default, "PanelCloseFunc_WorldMap_NodeManagement_Close()")
  registerCloseLuaEvent(Panel_Window_ServantInfo, closeTypeBitSet.default, "PanelCloseFunc_ServantInfo_Horse_Close()")
  registerCloseLuaEvent(Panel_CarriageInfo, closeTypeBitSet.default, "PanelCloseFunc_ServantInfo_Carriage_Close()")
  registerCloseLuaEvent(Panel_ShipInfo, closeTypeBitSet.default, "PanelCloseFunc_ServantInfo_Ship_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerManager_Renew, closeTypeBitSet.default, "PaGlobalFunc_WorkerManager_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerManager_Filter_Renew, closeTypeBitSet.default, "PaGlobalFunc_WorkerManager_Filter_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerManager_ChangeSkill_Renew, closeTypeBitSet.default, "PaGlobalFunc_WorkerManager_ChangeSkill_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerManager_Restore_Renew, closeTypeBitSet.default, "PaGlobalFunc_WorkerManager_Restore_Close()")
  registerCloseLuaEvent(Panel_Resurrection_ItemSelect, closeTypeBitSet.default, "PaGlobalFunc_ResurrerectionItem_Close()")
  registerCloseLuaEvent(Panel_ServerSelect_Renew, closeTypeBitSet.default, "PaGlobalFunc_ServerSelect_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlaceWallet, closeTypeBitSet.default, "PanelCloseFunc_MarketWallet_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_SellConfirm, closeTypeBitSet.default, "PaGlobal_MarketPlaceSell_Cancel()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_BuyConfirm, closeTypeBitSet.default, "PaGlobal_MarketPlaceBuy_Cancel()")
  registerCloseLuaEvent(Panel_Window_Option_Main, closeTypeBitSet.default, "PanelCloseFunc_RenewOption_Close()")
  registerCloseLuaEvent(Panel_Interaction_HouseList, closeTypeBitSet.default, "PanelCloseFunc_Interaction_HouseList_Close()")
  registerCloseLuaEvent(Panel_Window_PetFusion, closeTypeBitSet.default, "PanelCloseFunc_PetFusion_Close()")
  registerCloseLuaEvent(Panel_PartyOption, closeTypeBitSet.default, "PaGlobalFunc_PartyOption_Close()")
  registerCloseLuaEvent(Panel_Alchemy, closeTypeBitSet.default, "PanelCloseFunc_Alchemy()")
  registerCloseLuaEvent(Panel_Widget_Knowledge, closeTypeBitSet.default, "PaGlobalFunc_AlchemyKnowledgeClose()")
  registerCloseLuaEvent(Panel_AskKnowledge, closeTypeBitSet.default, "PaCloseFunc_AskKnowlege_Close()")
  registerCloseLuaEvent(Panel_TerritoryAuth_Auction, closeTypeBitSet.default, "TerritoryAuth_Auction_Close()")
  registerCloseLuaEvent(Panel_Window_Extraction_Caphras, closeTypeBitSet.default, "PaGlobal_ExtractionCaphras_Close()")
  registerCloseLuaEvent(Panel_Window_Extraction_Caphras_All, closeTypeBitSet.default, "PaGlobal_Extraction_Caphras_All_Close()")
  registerCloseLuaEvent(Panel_Window_ExtractionSystem, closeTypeBitSet.default, "PaGlobal_ExtractionSystem_ForceClose()")
  registerCloseLuaEvent(Panel_Window_DailyStamp_Renew, closeTypeBitSet.default, "PaGlobalFunc_DailyStamp_Close()")
  registerCloseLuaEvent(Panel_Window_ConsoleUIOffset, closeTypeBitSet.default, "PaGlobal_ConsoleUIOffset_Close()")
  if true == _ContentsGroup_RenewUI_StableInfo then
    registerCloseLuaEvent(Panel_Window_StableList, closeTypeBitSet.default, "PaGlobalFunc_StableList_Close()")
    registerCloseLuaEvent(Panel_Window_StableInfo, closeTypeBitSet.default, "PaGlobalFunc_StableInfo_Close()")
    registerCloseLuaEvent(Panel_Window_StableMating, closeTypeBitSet.default, "PaGlobalFunc_StableMating_Close()")
    registerCloseLuaEvent(Panel_Window_StableRegister, closeTypeBitSet.default, "PaGlobalFunc_StableRegister_Close()")
    registerCloseLuaEvent(Panel_Window_WharfList, closeTypeBitSet.default, "PaGlobalFunc_WharfList_Close()")
    registerCloseLuaEvent(Panel_Window_WharfInfo, closeTypeBitSet.default, "PaGlobalFunc_WharfInfo_Close()")
    registerCloseLuaEvent(Panel_Window_WharfRegister, closeTypeBitSet.default, "PaGlobalFunc_WharfRegister_Close()")
    registerCloseLuaEvent(Panel_Window_WharfFunction, closeTypeBitSet.attacked, "PaGlobalFunc_WharfFunction_Close()")
  else
    registerCloseLuaEvent(Panel_Window_StableList, closeTypeBitSet.default, "StableList_Close()")
    registerCloseLuaEvent(Panel_Window_StableInfo, closeTypeBitSet.default, "StableInfo_Close()")
    registerCloseLuaEvent(Panel_Window_StableEquipInfo, closeTypeBitSet.default, "StableEquipInfo_Close()")
    registerCloseLuaEvent(Panel_Window_StableShop, closeTypeBitSet.default, "StableShop_WindowClose()")
    registerCloseLuaEvent(Panel_Window_StableMating, closeTypeBitSet.default, "StableMating_Close()")
    registerCloseLuaEvent(Panel_Window_StableRegister, closeTypeBitSet.default, "StableRegister_Close()")
    registerCloseLuaEvent(Panel_Window_StableStallion, closeTypeBitSet.default, "PaGlobaFunc_StableStallion_Close()")
    registerCloseLuaEvent(Panel_Window_WharfList, closeTypeBitSet.default, "WharfList_Close()")
    registerCloseLuaEvent(Panel_Window_WharfInfo, closeTypeBitSet.default, "WharfInfo_Close()")
    registerCloseLuaEvent(Panel_Window_WharfRegister, closeTypeBitSet.default, "WharfRegister_Close()")
    registerCloseLuaEvent(Panel_Window_WharfFunction, closeTypeBitSet.attacked, "WharfFunction_Close()")
  end
  if true == _ContentsGroup_RenewUI_Dailog then
    registerCloseLuaEvent(Panel_Dialogue_Itemtake, closeTypeBitSet.default, "PaGlobalFunc_Dialog_ItemTake_Close()")
    registerCloseLuaEvent(Panel_NewKnowledge, closeTypeBitSet.default, "PaGlobalFunc_Widget_Alert_NewKnowledgePopup_Close()")
  else
    registerCloseLuaEvent(Panel_Dialogue_Itemtake, closeTypeBitSet.default, "click_noDialogButton()")
    registerCloseLuaEvent(Panel_NewKnowledge, closeTypeBitSet.default, "Panel_ImportantKnowledge_HideAni()")
  end
  if true == GlobalSwitch_UseOldAlchemy then
    registerCloseLuaEvent(Panel_RecentCook, closeTypeBitSet.default, "RecentCookClose()")
  else
    registerCloseLuaEvent(Panel_RecentCook, closeTypeBitSet.default, "PaGlobal_RecentCook:closePanel()")
  end
  registerCloseLuaEvent(Panel_Servant_Market_Input, closeTypeBitSet.default, "StableMarketInput_Close()")
  registerCloseLuaEvent(Panel_Window_Delivery_Information, closeTypeBitSet.default, "PanelCloseFunc_Delivery_Information_Close()")
  registerCloseLuaEvent(Panel_Window_Delivery_CarriageInformation, closeTypeBitSet.default, "DeliveryCarriageInformationWindow_Close()")
  registerCloseLuaEvent(Panel_Mail_Detail, closeTypeBitSet.default, "Mail_Detail_Close()")
  registerCloseLuaEvent(Panel_Mail_Send, closeTypeBitSet.default, "MailSend_Close()")
  registerCloseLuaEvent(Panel_CreateClan, closeTypeBitSet.default, "CreateClan_Close()")
  registerCloseLuaEvent(Panel_CreateGuild, closeTypeBitSet.default, "CreateClan_Close()")
  registerCloseLuaEvent(Panel_CreateClan_All, closeTypeBitSet.default, "PaGlobal_CreateClan_All_Close()")
  registerCloseLuaEvent(Panel_Scroll, closeTypeBitSet.default, "UIScrollButton.Close()")
  registerCloseLuaEvent(Panel_SkillAwaken, closeTypeBitSet.default, "SkillAwaken_Close()")
  registerCloseLuaEvent(Panel_Popup_MoveItem, closeTypeBitSet.default, "PopupMoveItem_Close()")
  registerCloseLuaEvent(Panel_LordMenu, closeTypeBitSet.default, "LordMenu_Hide()")
  registerCloseLuaEvent(Panel_EnableSkill, closeTypeBitSet.default, "PanelCloseFunc_Skill()")
  registerCloseLuaEvent(Panel_HelpMessage, closeTypeBitSet.default, "HelpMessageQuestion_Out()")
  registerCloseLuaEvent(Panel_Window_Quest_History, closeTypeBitSet.default, "FGlobal_QuestHistoryClose()")
  registerCloseLuaEvent(Panel_Window_PetListNew, closeTypeBitSet.default, "FGlobal_PetListNew_Close()")
  registerCloseLuaEvent(Panel_Housing_FarmInfo_New, closeTypeBitSet.default, "PAHousing_FarmInfo_Close()")
  registerCloseLuaEvent(Panel_ClanList, closeTypeBitSet.default, "_ClanList_Close()")
  registerCloseLuaEvent(Panel_ResetSeal, closeTypeBitSet.default, "HandleClicked_ResetSealCancelButton()")
  registerCloseLuaEvent(Panel_ClearVested, closeTypeBitSet.default, "FromClient_HideWindow()")
  registerCloseLuaEvent(Panel_Window_SkillGuide, closeTypeBitSet.default, "Panel_Window_SkillGuide_Close()")
  registerCloseLuaEvent(Panel_MovieTheater_640, closeTypeBitSet.default, "Panel_MovieTheater640_WindowClose()")
  registerCloseLuaEvent(Panel_MovieTheater_SkillGuide_640, closeTypeBitSet.default, "Panel_MovieTheater_SkillGuide_640_JustClose()")
  registerCloseLuaEvent(Panel_NewKnowledge, closeTypeBitSet.default, "PaGlobalFunc_Widget_Alert_NewKnowledgePopup_Close()")
  registerCloseLuaEvent(Panel_QuestInfo, closeTypeBitSet.default, "PanelCloseFunc_QuestInfo_Close()")
  registerCloseLuaEvent(Panel_Window_PetRegister, closeTypeBitSet.default, "HandleClicked_PetRegister_Close()")
  registerCloseLuaEvent(Panel_FishEncyclopedia, closeTypeBitSet.default, "FGlobal_FishEncyclopedia_Close()")
  registerCloseLuaEvent(Panel_Tooltip_Item_chattingLinkedItem, closeTypeBitSet.default, "Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()")
  registerCloseLuaEvent(Panel_HousingList, closeTypeBitSet.default, "HousingList_Close()")
  registerCloseLuaEvent(Panel_Interaction_FriendHouseList, closeTypeBitSet.default, "FriendHouseRank_Close()")
  registerCloseLuaEvent(Panel_GuildWarScore, closeTypeBitSet.default, "Panel_GuildWarScore_Close()")
  registerCloseLuaEvent(Panel_KnowledgeManagement, closeTypeBitSet.default, "KnowledgeClose()")
  registerCloseLuaEvent(Panel_Window_StableMix, closeTypeBitSet.default, "StableMix_Close()")
  registerCloseLuaEvent(Panel_Window_PetCompose, closeTypeBitSet.default, "Panel_Window_PetCompose_Close()")
  registerCloseLuaEvent(Panel_Window_MaidList, closeTypeBitSet.default, "MaidList_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerRandomSelect, closeTypeBitSet.default, "workerRandomSelectHide()")
  registerCloseLuaEvent(Panel_Window_UnknownRandomSelect, closeTypeBitSet.default, "randomSelectHide()")
  registerCloseLuaEvent(Panel_NodeWarMenu, closeTypeBitSet.default, "FGlobal_NodeWarMenuClose()")
  registerCloseLuaEvent(Panel_RallyRanking, closeTypeBitSet.default, "FGlobal_RallyRanking_Close()")
  registerCloseLuaEvent(Panel_Manufacture, closeTypeBitSet.default, "Manufacture_Close()")
  registerCloseLuaEvent(Panel_EnchantExtraction, closeTypeBitSet.default, "Panel_EnchantExtraction_Close()")
  registerCloseLuaEvent(Panel_Join, closeTypeBitSet.default, "Panel_Join_Close()")
  registerCloseLuaEvent(Panel_Window_PetMarket, closeTypeBitSet.default, "PetMarket_Close()")
  registerCloseLuaEvent(Panel_Window_PetMarketRegist, closeTypeBitSet.default, "PetMarketRegist_Close()")
  registerCloseLuaEvent(Panel_Window_GuildStable_List, closeTypeBitSet.default, "GuildStableList_Close()")
  registerCloseLuaEvent(Panel_Window_GuildStable_Info, closeTypeBitSet.default, "GuildStableInfo_Close()")
  registerCloseLuaEvent(Panel_Window_GuildStableRegister, closeTypeBitSet.default, "GuildStableRegister_Close()")
  registerCloseLuaEvent(Panel_GuildServantList, closeTypeBitSet.default, "GuildServantList_Close()")
  registerCloseLuaEvent(Panel_ExitConfirm, closeTypeBitSet.default, "Panel_GameExit_Minimize()")
  registerCloseLuaEvent(Panel_Party_ItemList, closeTypeBitSet.default, "Panel_Party_ItemList_Close()")
  registerCloseLuaEvent(Panel_Harvest_WorkManager, closeTypeBitSet.default, "FGlobal_Harvest_WorkManager_Close()")
  registerCloseLuaEvent(Panel_Window_PetLookChange, closeTypeBitSet.default, "Panel_Window_PetLookChange_Close()")
  registerCloseLuaEvent(Panel_Chatting_Color, closeTypeBitSet.default, "ChattingColor_Hide()")
  registerCloseLuaEvent(Panel_WorkerShipInfo, closeTypeBitSet.default, "WorkerShipInfo_Close()")
  registerCloseLuaEvent(Panel_ItemWarp, closeTypeBitSet.default, "Panel_ItemWarp_Close()")
  registerCloseLuaEvent(Panel_Tooltip_Item_chattingLinkedItemClick, closeTypeBitSet.default, "Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()")
  registerCloseLuaEvent(Panel_GoldenTreasureBox, closeTypeBitSet.default, "Panel_GoldenTreasureBox_Close()")
  registerCloseLuaEvent(Panel_GuildHouse_Auction, closeTypeBitSet.default, "FGlobal_GuildHouseAuctionWindow_Hide()")
  registerCloseLuaEvent(Panel_GuildHouse_Auction_All, closeTypeBitSet.default, "PaGlobal_GuildHouse_Auction_All_Close()")
  registerCloseLuaEvent(Panel_Guild_Create_All, closeTypeBitSet.default, "PaGlobal_CreateClan_All_Close()")
  registerCloseLuaEvent(Panel_Window_ReinforceSkill, closeTypeBitSet.default, "Panel_Window_ReinforceSkill_Close()")
  registerCloseLuaEvent(Panel_Guild_Incentive_Foundation, closeTypeBitSet.default, "Panel_Guild_Incentive_Foundation_Close()")
  registerCloseLuaEvent(Panel_CompetitionGame_JoinDesc, closeTypeBitSet.default, "PaGlobalFunc_CompetitionGame_JoinDesc_Close()")
  registerCloseLuaEvent(Panel_CompetitionGame_GuildReservation, closeTypeBitSet.default, "PanelCloseFunc_CompetitionGame()")
  registerCloseLuaEvent(Panel_IngameCashShop_Coupon, closeTypeBitSet.default, "IngameCashShopCoupon_Close( true )")
  registerCloseLuaEvent(Panel_PearlShop_Coupon, closeTypeBitSet.default, "PaGlobal_PearlShopCoupon_Close()")
  registerCloseLuaEvent(Panel_Window_Dance, closeTypeBitSet.default, "danceInfo_HandleClicked_Close()")
  registerCloseLuaEvent(Panel_GuildServant_RevivalList, closeTypeBitSet.default, "PaGlobal_GuildServant_RevivalList:close()")
  registerCloseLuaEvent(Panel_Copyright, closeTypeBitSet.default, "PaGlobal_Copyright_Close()")
  registerCloseLuaEvent(Panel_Window_Copyright, closeTypeBitSet.default, "PaGlobal_Copyright:close()")
  registerCloseLuaEvent(Panel_Widget_DropItem, closeTypeBitSet.default, "PaGlobal_DropItem:Close()")
  registerCloseLuaEvent(Panel_Window_DropItem, closeTypeBitSet.default, "PaGlobal_WorldDropItem:Close()")
  registerCloseLuaEvent(Panel_SkillCoolTimeSlot, closeTypeBitSet.default, "PaGlobal_Window_Skill_CoolTimeSlot:closeFunc()")
  registerCloseLuaEvent(Panel_PetRestoreAll, closeTypeBitSet.default, "PanelCloseFunc_PetRestoreAll_Close()")
  registerCloseLuaEvent(Panel_IngameCashShop_EventCart, closeTypeBitSet.default, "IngameCashShopEventCart_Close()")
  registerCloseLuaEvent(Panel_Window_Politics, closeTypeBitSet.default, "PaGlobal_Window_Politics:btn_close()")
  registerCloseLuaEvent(Panel_Window_RecommandGoods_PopUp, closeTypeBitSet.default, "PaGlobal_Recommend_PopUp:Close()")
  registerCloseLuaEvent(Panel_Npc_Quest_Reward, closeTypeBitSet.default, "PanelCloseFunc_QuestReward_Close()")
  registerCloseLuaEvent(Panel_Equipment, closeTypeBitSet.default, "PanelCloseFunc_Equip_Close()")
  registerCloseLuaEvent(Panel_Mail_Main, closeTypeBitSet.default, "Mail_Close()")
  registerCloseLuaEvent(Panel_Window_Option, closeTypeBitSet.default, "PanelCloseFunc_WindowOption()")
  registerCloseLuaEvent(Panel_Window_Socket, closeTypeBitSet.default, "Socket_WindowClose()")
  registerCloseLuaEvent(Panel_Housing_VendingMachineList, closeTypeBitSet.default, "handleClickedVendingMachineClose()")
  registerCloseLuaEvent(Panel_Housing_ConsignmentSale, closeTypeBitSet.default, "handleClickedConsignmentClose()")
  registerCloseLuaEvent(Panel_Housing_SettingVendingMachine, closeTypeBitSet.default, "PanelCloseFunc_SettingVendingMachine_Close()")
  registerCloseLuaEvent(Panel_Housing_SettingConsignmentSale, closeTypeBitSet.default, "PanelCloseFunc_SettingConsignmentSale_Close()")
  registerCloseLuaEvent(Panel_Housing_RegisterConsignmentSale, closeTypeBitSet.default, "PanelCloseFunc_RegisterConsignmentSale_Close()")
  registerCloseLuaEvent(Panel_SkillAwaken, closeTypeBitSet.default, "SkillAwaken_Close()")
  registerCloseLuaEvent(Panel_Improvement, closeTypeBitSet.default, "Panel_Improvement_Hide()")
  registerCloseLuaEvent(Panel_ItemMarket_AlarmList, closeTypeBitSet.default, "HandleClicked_ItemMarketAlarmList_Close()")
  registerCloseLuaEvent(Panel_GuildWarInfo, closeTypeBitSet.default, "Panel_GuildWarInfo_Hide()")
  registerCloseLuaEvent(Panel_TradeInfo_Renew, closeTypeBitSet.default, "PaGlobal_TradeInformation:Close()")
  registerCloseLuaEvent(Panel_TradeEventNotice_Renewal, closeTypeBitSet.default, "PaGlobal_TradeEventNotice_Renewal:Close()")
  registerCloseLuaEvent(Panel_TradeMarket_EventInfo, closeTypeBitSet.default, "TradeEventInfo_Close()")
  registerCloseLuaEvent(Panel_LevelupGuide, closeTypeBitSet.default, "HandleClicked_LevelupGuide_Close()")
  registerCloseLuaEvent(Panel_NpcNavi, closeTypeBitSet.default, "FGlobal_NpcNavi_Hide()")
  registerCloseLuaEvent(Panel_Tooltip_NpcNavigation, closeTypeBitSet.default, "FGlobal_NpcNavi_Hide()")
  registerCloseLuaEvent(Panel_Window_Policy, closeTypeBitSet.default, "PaGlobal_Policy_Close()")
  registerCloseLuaEvent(Panel_Window_MailDetail_Renew, closeTypeBitSet.default, "PaGlobal_MailDetail_Close()")
  registerCloseLuaEvent(Panel_Window_BlackDesertLab, closeTypeBitSet.default, "PaGlobal_BlackDesertLab_Close()")
  registerCloseLuaEvent(Panel_BossAlert_SettingV2, closeTypeBitSet.default, "PaGlobal_BossAlertSet_Hide()")
  registerCloseLuaEvent(Panel_Window_LinkServantInfo, closeTypeBitSet.default, "PaGlobalFunc_LinkHorseInfo_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_MemberFunction, closeTypeBitSet.default, "PaGlobalFunc_GuildMemberFunction_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_MemberInfo, closeTypeBitSet.default, "PaGlobalFunc_GuildMemberInfo_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_QuestInfo, closeTypeBitSet.default, "PaGlobalFunc_GuildQuestInfo_Close()")
  registerCloseLuaEvent(Panel_Window_GuildMark, closeTypeBitSet.default, "InputMLUp_GuildMark_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_WarDeclare, closeTypeBitSet.default, "PaGlobalFunc_WarDeclare_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_SkillInfo, closeTypeBitSet.default, "PaGlobalFunc_GuildSkillInfo_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_Introduction, closeTypeBitSet.default, "PaGlobalFunc_GuildIntro_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_VoiceSet, closeTypeBitSet.default, "PaGlobalFunc_GuildVoiceSet_Close()")
  registerCloseLuaEvent(Panel_Window_GuildWarInfo, closeTypeBitSet.default, "PanelCloseFunc_GuildWarInfo_Close()")
  registerCloseLuaEvent(Panel_House_InstallationMode_PlantInfo, closeTypeBitSet.default, "PaGlobalFunc_InstallationMode_PlantInfo_Close()")
  registerCloseLuaEvent(Panel_Window_Clan_Renew, closeTypeBitSet.default, "PaGlobalFunc_ClanRenew_Close()")
  registerCloseLuaEvent(Panel_Introduction, closeTypeBitSet.default, "FGlobal_Introcution_TooltipHide()")
  registerCloseLuaEvent(Panel_LocalWarRule, closeTypeBitSet.default, "PaGlobalFunc_LocalWarRule_Close()")
  registerCloseLuaEvent(Panel_Window_GuildWarInfo_Renew, closeTypeBitSet.default, "PaGlobalFunc_GuildWarInfo_Close()")
  registerCloseLuaEvent(Panel_Window_GuildWarInfoDetail_Renew, closeTypeBitSet.default, "PaGlobalFunc_GuildWarInfoDetail_Close()")
  registerCloseLuaEvent(Panel_Window_Enchant_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_Enchant_Close()")
  registerCloseLuaEvent(Panel_Window_Socket_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_Socket_Close()")
  registerCloseLuaEvent(Panel_Window_Improvement_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_Improvement_Close()")
  registerCloseLuaEvent(Panel_Window_MonsterRanking, closeTypeBitSet.default, "FGlobal_MonsterRanking_Close()")
  registerCloseLuaEvent(Panel_KeyboardHelp, closeTypeBitSet.default, "PaGlobalFunc_KeyboardHelpClose()")
  registerCloseLuaEvent(Panel_ChannelSelect, closeTypeBitSet.default, "FGlobal_ChannelSelect_Hide()")
  registerCloseLuaEvent(Panel_Window_Skill, closeTypeBitSet.default, "PanelCloseFunc_Skill()")
  registerCloseLuaEvent(Panel_Window_Inventory_Cannon, closeTypeBitSet.default, "PaGlobalFunc_CannonInven_Close()")
  registerCloseLuaEvent(Panel_Window_StableFunction, closeTypeBitSet.attacked, "PanelCloseFunc_StableFunction_Close()")
  registerCloseLuaEvent(Panel_Repair_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_RepairInfo_Close()")
  registerCloseLuaEvent(Panel_FixEquip, closeTypeBitSet.attacked, "PaGlobalFunc_FixEquip_Close()")
  registerCloseLuaEvent(Panel_Window_ItemMarket_RegistItem, closeTypeBitSet.default, "PanelCloseFunc_ItemMarketRegistItem()")
  registerCloseLuaEvent(Panel_Window_ItemMarket_BuyConfirm, closeTypeBitSet.default, "FGlobal_ItemMarket_BuyConfirm_Close()")
  registerCloseLuaEvent(Panel_Window_ItemMarket_ItemSet, closeTypeBitSet.default, "FGlobal_ItemMarketItemSet_Close()")
  registerCloseLuaEvent(Panel_DyeNew_CharacterController, closeTypeBitSet.attackedOnly, "FGlobal_Panel_DyeReNew_Hide()")
  registerCloseLuaEvent(Panel_Window_Repair, closeTypeBitSet.attackedOnly, "PaGlobalFunc_FixEquip_Close()")
  registerCloseLuaEvent(Panel_Window_ItemMarket_Function, closeTypeBitSet.attackedOnly, "FGolbal_ItemMarket_Function_Close()")
  registerCloseLuaEvent(Panel_CustomizationMain, closeTypeBitSet.attackedOnly, "IngameCustomize_Hide()")
  registerCloseLuaEvent(Panel_PcRoomNotify, closeTypeBitSet.attacked, "PcRoomNotify_Close()")
  registerCloseLuaEvent(Panel_Window_GuildWharfFunction, closeTypeBitSet.attacked, "GuildWharfFunction_Close()")
  registerCloseLuaEvent(Panel_Npc_Trade_Market, closeTypeBitSet.attacked, "closeNpcTrade_Basket()")
  if true == ToClient_isConsole() then
    registerCloseLuaEvent(Panel_Win_System, closeTypeBitSet.attacked, "PanelCloseFunc_MessageBox()")
  else
    registerCloseLuaEvent(Panel_Win_System, closeTypeBitSet.attacked, "MessageBox_Empty_function()")
  end
  registerCloseLuaEvent(Panel_Window_GardenList, closeTypeBitSet.attacked, "PaGlobal_GardenList:close()")
  registerCloseLuaEvent(Panel_Window_GardenInformation, closeTypeBitSet.attacked, "PaGlobal_GardenInformation:close()")
  registerCloseLuaEvent(Panel_Window_GardenWorkerManagement, closeTypeBitSet.attacked, "PaGlobal_GardenWorkerManagement:prepareClose()")
  registerCloseLuaEvent(Panel_Window_ResidenceList, closeTypeBitSet.attacked, "PaGlobal_ResidenceList:close()")
  registerCloseLuaEvent(Panel_ChatOption, closeTypeBitSet.attacked, "ChattingOption_Close()")
  registerCloseLuaEvent(Panel_RecommandName, closeTypeBitSet.attacked, "FGlobal_SendMailForHelpClose()")
  registerCloseLuaEvent(Panel_SetShortCut, closeTypeBitSet.attacked, "FGlobal_NewShortCut_Close()")
  registerCloseLuaEvent(Panel_Window_Quest_New_Option, closeTypeBitSet.attacked, "FGlobal_CheckedQuestOptionClose()")
  registerCloseLuaEvent(Panel_QuickMenuCustom, closeTypeBitSet.attacked, "PaGlobalFunc_Panel_QuickMenuCustomClose()")
  registerCloseLuaEvent(Panel_Window_VoiceChat, closeTypeBitSet.attacked, "PaGlobalFunc_VoiceChat_Close()")
  registerCloseLuaEvent(Panel_Window_Guild_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_GuildMain_Close()")
  registerCloseLuaEvent(Panel_GameExit, closeTypeBitSet.attacked, "PaGlobalFunc_GameExitClose()")
  registerCloseLuaEvent(Panel_Window_GameExit_CharMove, closeTypeBitSet.attacked, "PaGlobalFunc_GameExitCharMove_SetShow(false, false)")
  registerCloseLuaEvent(Panel_Window_GameExit, closeTypeBitSet.attacked, "PaGlobalFunc_GameExit_SetShow(false, false)")
  registerCloseLuaEvent(Panel_ServerSelect_Renew, closeTypeBitSet.attacked, "PaGlobalFunc_ServerSelect_Close()")
  registerCloseLuaEvent(Panel_AgreementGuild, closeTypeBitSet.attacked, "FGlobal_AgreementGuild_Close()")
  registerCloseLuaEvent(Panel_Window_GuildStableFunction, closeTypeBitSet.attacked, "GuildStableFunction_Close()")
  registerCloseLuaEvent(Panel_GuildAlliance_Invitation, closeTypeBitSet.attacked, "FGlobal_InvitationGuildAlliance_Close()")
  if true == _ContentsGroup_RenewUI_Party then
    registerCloseLuaEvent(Panel_LocalWarInfo, closeTypeBitSet.default, "PaGlobalFunc_LocalWarInfo_Exit()")
  else
    registerCloseLuaEvent(Panel_LocalWarInfo, closeTypeBitSet.default, "FGlobal_LocalWarInfo_Close()")
  end
  registerCloseLuaEvent(Panel_GuildList_SetAttendanceWar, closeTypeBitSet.default, "HandleClicked_SetAttendanceWar_Cancel()")
  registerCloseLuaEvent(Panel_Window_DetectUser, closeTypeBitSet.default, "PaGlobalFunc_DetectUser_Close()")
  registerCloseLuaEvent(Panel_Stable_PromoteMarket, closeTypeBitSet.default, "PaGlobalFunc_ServantRentPromoteMarketClose()")
  registerCloseLuaEvent(Panel_Chat_Emoticon, closeTypeBitSet.default, "PaGlobalFunc_ChatEmoticon_Close()")
  registerCloseLuaEvent(Panel_Window_ChattingHistory_Renew, closeTypeBitSet.default, "PaGlobalFunc_ChattingHistory_Close()")
  registerCloseLuaEvent(Panel_DetectUserButton, closeTypeBitSet.default, "PaGlobalFunc_DetectUserButton_Close()")
  registerCloseLuaEvent(Panel_Window_GuildFunding_Renew, closeTypeBitSet.default, "PaGlobalFunc_GuildFunding_Close()")
  registerCloseLuaEvent(Panel_Chatting_Filter, closeTypeBitSet.default, "FGlobal_ChattingFilterList_Close()")
  registerCloseLuaEvent(Panel_Window_ItemMarketAlarmList_New, closeTypeBitSet.default, "PaGlobalFunc_ItemMArketAlarmListClose()")
  registerCloseLuaEvent(Panel_Window_HorseRace, closeTypeBitSet.default, "PaGlobalFunc_RaceInfo_Hide()")
  registerCloseLuaEvent(Panel_Chat_SocialMenu, closeTypeBitSet.default, "FGlobal_SocialAction_ShowToggle()")
  registerCloseLuaEvent(Panel_SavageDefenceInfo, closeTypeBitSet.default, "FGlobal_SavageDefenceInfo_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_Main, closeTypeBitSet.default, "PaGlobalFunc_MarketPlace_CloseAllCheck()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_Function, closeTypeBitSet.default, "PaGlobalFunc_MarketPlace_Function_Close()")
  registerCloseLuaEvent(Panel_Window_Barter, closeTypeBitSet.default, "PaGlobal_Barter_Close()")
  registerCloseLuaEvent(Panel_Widget_BlackSpirit_SkillSelect, closeTypeBitSet.default, "PaGloabl_BlackSpiritSkillSelect_Close()")
  registerCloseLuaEvent(Panel_FriendList_Add_All, closeTypeBitSet.default, "PaGlobal_FriendListAdd_Close_All()")
  registerCloseLuaEvent(Panel_FriendList_Add, closeTypeBitSet.default, "PaGlobal_FriendListAdd_Close()")
  registerCloseLuaEvent(Panel_Friend_RequestList_All, closeTypeBitSet.default, "PaGlobal_FriendRequestList_Close_All()")
  registerCloseLuaEvent(Panel_Friend_GroupRename_All, closeTypeBitSet.default, "PaGlobal_FriendGroupRename_Close_All()")
  registerCloseLuaEvent(Panel_ColorBalance, closeTypeBitSet.default, "Panel_ColorBalance_Close()")
  registerCloseLuaEvent(Panel_Window_MaidList_Renew, closeTypeBitSet.default, "PaGlobalFunc_MaidList_OnPadB()")
  registerCloseLuaEvent(Panel_Window_ChangeName_Renew, closeTypeBitSet.default, "ChangeNickname_Close()")
  registerCloseLuaEvent(Panel_ExchangeNickname, closeTypeBitSet.default, "FGlobal_Exchange_Close()")
  registerCloseLuaEvent(Panel_RecommandName_Renew, closeTypeBitSet.default, "FGlobal_SendMailForHelpClose()")
  registerCloseLuaEvent(Panel_Window_Skill_BlackSpiritLock, closeTypeBitSet.default, "FGlobal_BlackSpiritSkillLock_Close()")
  registerCloseLuaEvent(Panel_MovieStroyIndun, closeTypeBitSet.default, "PaGlobalFunc_StroyInstanceDungeon_Exit()")
  registerCloseLuaEvent(Panel_Window_KnowledgeManage_Renew, closeTypeBitSet.default, "PaGlobalFunc_KnowledgeManage_Close()")
  registerCloseLuaEvent(Panel_GuildQuest_Reward, closeTypeBitSet.default, "PaGlobalFunc_GuildQuest_Reward_ShowToggle()")
  registerCloseLuaEvent(Panel_Window_KeyGuide, closeTypeBitSet.attacked, "PaGlobalFunc_KeyGuidWindow_Close()")
  registerCloseLuaEvent(Panel_Dialog_RandomWorker, closeTypeBitSet.default, "FGlobalFunc_Close_RandomWorker()")
  registerCloseLuaEvent(Panel_Window_AccountLinking_Renew, closeTypeBitSet.default, "PaGlobalFunc_AccountLinking_Close()")
  registerCloseLuaEvent(Panel_Window_ChangeItem_Renew, closeTypeBitSet.default, "PaGlobalFunc_ChangeItem_Close()")
  registerCloseLuaEvent(Panel_Window_UIEggTest, closeTypeBitSet.default, "PaGlobal_UIEggTest_Close()")
  registerCloseLuaEvent(Panel_Guild_DailyPay, closeTypeBitSet.default, "FGlobal_GetDailyPay_Hide()")
  registerCloseLuaEvent(Panel_Window_LordMenu_Renew, closeTypeBitSet.default, "PaGlobalFunc_LordMenu_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_MyInventory, closeTypeBitSet.default, "PaGlobalFunc_MarketWallet_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_WalletInventory, closeTypeBitSet.default, "PaGlobalFunc_MarketWallet_Close()")
  registerCloseLuaEvent(Panel_Dialge_RewardSelect, closeTypeBitSet.attackedOnly, "PaGlobalFunc_Reward_Select_Exit()")
  registerCloseLuaEvent(Panel_Ingamecashshop_BottomBanner, closeTypeBitSet.cantclose, "PaGlobal_BottomBanner_Close()")
  registerCloseLuaEvent(Panel_IngameCashShop_BuyOrGift, closeTypeBitSet.attacked, "InGameShopBuy_Close()")
  registerCloseLuaEvent(Panel_Window_NationSiege, closeTypeBitSet.default, "PaGlobal_Panel_Window_NationSiege_Close()")
  registerCloseLuaEvent(Panel_Window_NationSiege_Board, closeTypeBitSet.default, "PaGlobal_NationSiegeBoard_Close()")
  registerCloseLuaEvent(Panel_Window_Achievement, closeTypeBitSet.default, "PaGlobalFunc_Achievement_Close()")
  registerCloseLuaEvent(Panel_Window_Achievement_BookShelf, closeTypeBitSet.default, "PaGlobal_Achievement_BookShelf_Close()")
  registerCloseLuaEvent(Panel_Manufacture_GrindMortar, closeTypeBitSet.default, "FGlobal_Manufacture_GrindMortar_Close()")
  registerCloseLuaEvent(Panel_AgreementVolunteer_Master, closeTypeBitSet.default, "FGlobal_AgreementVolunteer_Master_Close()")
  registerCloseLuaEvent(Panel_AgreementVolunteer, closeTypeBitSet.default, "FGlobal_AgreementVolunteer_Close()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_SelectList, closeTypeBitSet.default, "PaGlobal_MarketPlaceSelectList_Cancel()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_SellManagement, closeTypeBitSet.default, "PaGlobal_MarketPlaceSell_Cancel()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_BuyManagement, closeTypeBitSet.default, "PaGlobal_MarketPlaceBuy_Cancel()")
  registerCloseLuaEvent(Panel_Window_PersonalMonster, closeTypeBitSet.default, "PaGlobal_PersonalMonster_Close()")
  registerCloseLuaEvent(Panel_Window_GuildRegistSoldier, closeTypeBitSet.default, "PaGlobalFunc_GuildRegistSoldier_Close()")
  registerCloseLuaEvent(Panel_BattleRoyalRank_Web, closeTypeBitSet.default, "PaGlobal_BattleRoyalRank_WebClose()")
  registerCloseLuaEvent(Panel_Window_ExpirienceWiki, closeTypeBitSet.default, "PaGlobal_ExpirienceWiki_Close()")
  registerCloseLuaEvent(Panel_Widget_ContentUnlock, closeTypeBitSet.default, "PaGlobalFunc_ContentUnlock_Close()")
  registerCloseLuaEvent(Panel_Widget_ContentOpen, closeTypeBitSet.default, "PaGlobal_contentOpen_Close()")
  registerCloseLuaEvent(Panel_Window_VolunteerRankWeb, closeTypeBitSet.default, "PaGlobal_VolunteerRankWeb_Close()")
  registerCloseLuaEvent(Panel_AltarRank_Web, closeTypeBitSet.default, "PaGlobal_AltarRankWeb_Close()")
  registerCloseLuaEvent(Panel_Window_TotalReward, closeTypeBitSet.default, "PaGlobal_TotalReward_Close()")
  registerCloseLuaEvent(Panel_Widget_Menu_Remake, closeTypeBitSet.default, "PaGlobal_Menu_Remake_Close()")
  registerCloseLuaEvent(Panel_Guild_Incentive_SetFund, closeTypeBitSet.default, "PaGlobal_GuildIncentive:prepareClose()")
  registerCloseLuaEvent(Panel_Guild_Incentive_MemberList, closeTypeBitSet.default, "PaGlobal_GuildIncentive:prepareClose()")
  registerCloseLuaEvent(Panel_Guild_Incentive_Tier, closeTypeBitSet.default, "PaGlobal_GuildIncentiveTier_Close()")
  registerCloseLuaEvent(Panel_EnchantExtraction_Renew, closeTypeBitSet.default, "Panel_EnchantExtraction_Renew_Close()")
  registerCloseLuaEvent(Panel_Purification_Renew, closeTypeBitSet.default, "PaGlobal_Purification_Close()")
  registerCloseLuaEvent(Panel_WebControl_Renew, closeTypeBitSet.default, "PaGlobalFunc_WebControl_Close()")
  registerCloseLuaEvent(Panel_UnknownShop, closeTypeBitSet.default, "PaGlobal_UnknownShop:prepareClose()")
  registerCloseLuaEvent(Panel_Window_MarketPlace_TutorialSelect, closeTypeBitSet.default, "PaGlobal_MarketPlaceTutorialSelect:prepareClose()")
  registerCloseLuaEvent(Panel_Kr_Transfer, closeTypeBitSet.default, "PaGlobal_Kr_Transfer_Close()")
  registerCloseLuaEvent(Panel_Dialog_NPCShop_All, closeTypeBitSet.default, "HandleEventLUp_NPCShop_ALL_Close()")
  registerCloseLuaEvent(Panel_Window_MaidList_All, closeTypeBitSet.default, "PaGlobalFunc_MaidList_All_Close()")
  registerCloseLuaEvent(Panel_PartyList_All, closeTypeBitSet.default, "PaGlobalFunc_PartyList_All_Close()")
  registerCloseLuaEvent(Panel_PartyRecruite_All, closeTypeBitSet.default, "PaGlobalFunc_PartyRecruite_All_Close()")
  registerCloseLuaEvent(Panel_Window_DailyStamp_All, closeTypeBitSet.default, "PaGlobalFunc_DailyStamp_All_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerManager_All, closeTypeBitSet.default, "PaGlobalFunc_WorkerManager_All_Close()")
  registerCloseLuaEvent(Panel_Purification_All, closeTypeBitSet.default, "HandleEventLUp_Purification_All_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerAuction_All, closeTypeBitSet.default, "HandleEventLUp_WorkerAuction_All_Close()")
  registerCloseLuaEvent(Panel_Window_Report, closeTypeBitSet.default, "PaGloabl_Report_Close()")
  registerCloseLuaEvent(Panel_Window_WorkerRandomSelect_All, closeTypeBitSet.default, "HandleEventLUp_WorkerRandomSelect_All_Close()")
  registerCloseLuaEvent(Panel_Window_RandomShop_All, closeTypeBitSet.default, "PaGlobalFunc_RandomShop_All_Close()")
end
function PaGlobalFunc_KeyboardHelpClose()
  Panel_KeyboardHelp:SetShow(false)
end
function PaGlobalFunc_Panel_QuickMenuCustomClose()
  if true == _ContentsGroup_RenewUI then
    FGlobal_ConsoleQuickMenuSetting_Close()
  end
end
function PaGlobalFunc_GameExitClose()
  GameExitShowToggle(true)
  FGlobal_ChannelSelect_Hide()
  Panel_GameExit_sendGameDelayExitCancel()
end
local panel_MinigameList = {
  Panel_Minigame_Gradient,
  Panel_SinGauge,
  Panel_Command,
  Panel_RhythmGame,
  Panel_BattleGauge,
  Panel_FillGauge,
  Panel_MiniGame_Gradient_Y,
  Panel_MiniGame_Timing,
  Panel_MiniGame_Drag,
  Panel_MiniGame_PowerControl,
  Panel_RhythmGame_ForAction,
  Panel_MiniGame_Steal,
  Panel_MiniGame_Jaksal,
  Panel_RhythmGame_Drum,
  MiniGame_SniperReload
}
registerEvent("FromClient_luaLoadComplete", "initCloseFunction")
function initCloseFunction()
  _PA_LOG("\236\157\180\235\139\164\237\152\156", "initCloseFunction Start")
  CloseManager_RegisterExeptionList()
  closeExceptionListInitialize()
  registerClosePanelList()
end
function checkAllPanelSetCloseFunction()
  local result = Toclient_checkCloseEventSet()
  if true ~= result then
    UI.ASSERT(false, " \237\140\168\235\132\144\236\151\144 ,close \237\149\168\236\136\152\234\176\128 \236\133\139\237\140\133\235\144\152\236\167\128 \236\149\138\236\149\152\236\138\181\235\139\136\235\139\164 !! close \234\176\128 \236\160\149\236\131\129\236\158\145\235\143\153\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164 ")
    UI.ASSERT(false, " \237\149\180\235\139\185 \237\140\168\235\132\144\236\157\132 globalCloseManager_Renew.lua \236\152\136\236\153\184 \235\166\172\236\138\164\237\138\184\236\151\144 \236\182\148\234\176\128\237\149\152\234\177\176\235\130\152 close \237\149\168\236\136\152\235\165\188 \235\147\177\235\161\157\237\149\180\236\163\188\236\132\184\236\154\148 ")
  end
  _PA_LOG("\236\157\180\235\139\164\237\152\156", "\236\156\160\237\154\168\236\132\177 \234\178\128\236\130\172 \235\129\157")
end
function FromClient_EscapeEtcClose()
  Panel_Tooltip_Item_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItem_hideTooltip()
  Panel_Tooltip_Item_chattingLinkedItemClick_hideTooltip()
  Panel_SkillTooltip_Hide()
  FGlobal_BuffTooltipOff()
  TooltipSimple_Hide()
  TooltipCommon_Hide()
  if Panel_LowLevelGuide_Value_IsCheckMoviePlay == 1 then
    FGlobal_Panel_LowLevelGuide_MovePlay_FindWay()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 2 then
    FGlobal_Panel_LowLevelGuide_MovePlay_LearnSkill()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 3 then
    FGlobal_Panel_LowLevelGuide_MovePlay_FindTarget()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 4 then
    FGlobal_Panel_LowLevelGuide_MovePlay_AcceptQuest()
  elseif Panel_LowLevelGuide_Value_IsCheckMoviePlay == 99 then
    FGlobal_Panel_LowLevelGuide_MovePlay_BlackSpirit()
  end
end
function FromClient_OpenOption()
  if nil ~= Panel_Menu_ShowToggle then
    Panel_Menu_ShowToggle()
  elseif nil ~= Panel_Window_Menu_ShowToggle then
    Panel_Window_Menu_ShowToggle()
  end
end
function FromClient_CancelByAttacked()
  close_attacked_WindowPanelList()
end
function check_ShowWindow()
  _isAllClose = false
  return ToClient_isShownClosePanel()
end
function close_WindowPanelList()
  _isAllClose = true
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Escape, false)
end
function close_force_WindowPanelList()
  _isAllClose = true
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Force, true)
end
function close_escape_WindowPanelList()
  _isAllClose = false
  if true == ToClient_isConsole() then
    local selfPlayer = getSelfPlayer()
    local isDead
    if nil ~= selfPlayer then
      isDead = selfPlayer:isDead()
    else
      return
    end
    if (true == isDead or true == Panel_DeadMessage_Renew:IsShow()) and true == Panel_Resurrection_ItemSelect:GetShow() then
      PaGlobalFunc_ResurrerectionItem_Close()
      return
    end
  end
  Toclient_processCheckEscapeKey()
  if true == isKeyDown_Once(CppEnums.VirtualKeyCode.KeyCode_ESCAPE) then
    TooltipSimple_Hide()
    TooltipCommon_Hide()
  end
end
function close_WindowMinigamePanelList()
  for _, loopPanel in ipairs(panel_MinigameList) do
    if nil ~= loopPanel then
      loopPanel:SetShow(false, false)
    end
  end
end
function close_attacked_WindowPanelList(isForced)
  if false == _ContentsGroup_RenewUI_Chatting and false == AllowChangeInputMode() then
    return
  end
  _isAllClose = true
  RenderModeAllClose()
  ToClient_PopBlackSpiritFlush()
  if isPhotoMode() then
    audioPostEvent_SystemUi(8, 14)
    _AudioPostEvent_SystemUiForXBOX(8, 14)
  end
  HandleClicked_HouseInstallation_Exit_ByAttacked()
  FriendMessanger_KillFocusEdit()
  close_WindowMinigamePanelList()
  if 0 ~= dialog_getTalkNpcKey() then
    global_setTrading(false)
  end
  Toclient_closeAllPanelByState(Defines.CloseType.eCloseType_Attacked, false)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_CloseMainDialogForDetail()
    PaGlobalFunc_MainDialog_Hide()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_CloseNpcDialogForDetail()
    FGlobal_HideDialog()
  else
    PaGlobalFunc_DialogMain_All_Close()
  end
  if GameOption_GetHideWindow() or true == isForced then
    ResetKeyCustombyAttacked()
    close_WindowPanelList()
  end
end
function getCurrentCloseType()
  return Toclient_getCurrentCloseType()
end
initCloseFunction()
registerEvent("FromClient_luaLoadCompleteLateUdpate", "checkAllPanelSetCloseFunction")
registerEvent("FromClient_EscapeEtcClose", "FromClient_EscapeEtcClose")
registerEvent("FromClient_OpenOption", "FromClient_OpenOption")
registerEvent("progressEventCancelByAttacked", "FromClient_CancelByAttacked")
function PaCloseFunc_AskKnowlege_Close()
  Panel_AskKnowledge:SetShow(false)
end
function PanelCloseFunc_PetFusion_Close()
  PaGlobalFunc_PetFusion_Close()
end
function PanelCloseFunc_Interaction_HouseList_Close()
  PaGlobalFunc_Interaction_HouseList_Close()
end
function PanelCloseFunc_LocalWarInfo_Close()
  if false == _ContentsGroup_RenewUI_LocalWar then
    FGlobal_LocalWarInfo_Close()
  else
    PaGlobalFunc_LocalWarInfo_Exit()
  end
end
function PanelCloseFunc_RenewOption_Close()
  PaGlobal_Option:ClickedCancelOption()
  PaGlobal_Option:Close()
end
function PanelCloseFunc_FindParty_Close()
  if false == _ContentsGroup_RenewUI_Party then
    FGlobal_PartyList_ShowToggle()
  else
    PaGlobalFunc_FindParty_Exit()
  end
end
function PanelCloseFunc_MarketWallet_Close()
  PaGlobalFunc_MarketWallet_Close()
end
function PanelCloseFunc_MarketPlace_Close()
  FGolbal_ItemMarketNew_Close()
end
function PanelCloseFunc_ServantInfo_Horse_Close()
  if false == _ContentsGroup_RenewUI_StableInfo then
    ServantInfo_Close()
  else
    PaGlobalFunc_HorseInfo_Exit()
  end
end
function PanelCloseFunc_ServantInfo_Carriage_Close()
  if false == _ContentsGroup_RenewUI_StableInfo then
    CarriageInfo_Close()
  else
    PaGlobalFunc_CarriageInfo_Exit()
  end
end
function PanelCloseFunc_ServantInfo_Ship_Close()
  if false == _ContentsGroup_RenewUI_StableInfo then
    ShipInfo_Close()
  else
    PaGlobalFunc_ShipInfo_Exit()
  end
end
function PanelCloseFunc_WorldMap_NodeManagement_Close()
  PaGlobalFunc_WorldMap_NodeManagement_Close()
end
function PanelCloseFunc_WorldMap_NodeManagement_Close()
  PaGlobalFunc_WorldMap_NodeManagement_Close()
end
function PanelCloseFunc_WorldMap_NodeInfo_Close()
  PaGlobalFunc_WorldMap_NodeInfo_Close()
end
function PanelCloseFunc_ImprovementInfo_Discard()
  PaGlobalFunc_ImprovementInfo_Discard()
end
function PanelCloseFunc_PanelDelivery_Close()
  DeliveryRequestWindow_Close()
end
function PanelCloseFunc_PetList_Close()
  FGlobal_PetList_Close()
end
function PanelCloseFunc_MailRenew_Close()
  Mail_Close()
end
function PanelCloseFunc_NpcGift_Close()
  PaGlobalFunc_NpcGift_Close()
end
function PanelCloseFunc_Customization_BodyShape_Close()
  PaGlobalFunc_Customization_BodyBone_Close()
end
function PanelCloseFunc_Customization_BodyPose_Close()
  PaGlobalFunc_Customization_BodyPose_Close()
end
function PanelCloseFunc_Customization_Deco_Close()
  PaGlobalFunc_Customization_Deco_Close()
end
function PanelCloseFunc_Customization_FaceShape_Close()
  PaGlobalFunc_Customization_FaceBone_Close()
end
function PanelCloseFunc_Customization_HairShape_Close()
  PaGlobalFunc_Customization_HairShape_Close()
end
function PanelCloseFunc_Customization_InputName_Close()
  PaGlobalFunc_Customization_InputName_Close()
end
function PanelCloseFunc_Customization_Mesh_Close()
  PaGlobalFunc_Customization_Mesh_Close()
end
function PanelCloseFunc_Customization_ShowOutfit_Close()
  PaGlobalFunc_Customization_ShowCloth_Close()
end
function PanelCloseFunc_Customization_ShowPose_Close()
  PaGlobalFunc_Customization_ShowPose_Close()
end
function PanelCloseFunc_Customization_Skin_Close()
  PaGlobalFunc_Customization_Skin_Close()
end
function PanelCloseFunc_Customization_Voice_Close()
  PaGlobalFunc_Customization_Voice_Close()
end
function PanelCloseFunc_GuildPopup_Close()
  PaGlobalFunc_GuildPopup_Close()
end
function PanelCloseFunc_GuildCreate()
  PaGlobalFunc_GuildCreate_Close()
end
function PanelCloseFunc_MenuRenew()
  _AudioPostEvent_SystemUiForXBOX(53, 37)
  Panel_Window_Menu_Close()
end
function PanelCloseFunc_GuildSignOption()
  if true == PaGlobalFunc_AgreementGuild_SignOption_GetShow() then
    PaGlobalFunc_AgreementGuild_SignOption_SetShow(false, false)
  end
end
function PanelCloseFunc_QuickMenuCustom()
  FGlobal_ConsoleQuickMenuSetting_Close()
end
function PanelCloseFunc_GuildAgreementClose()
  Panel_Console_Window_GuildAgreement:SetShow(false, false)
end
function PanelCloseFunc_MentalGameClose()
  if true == PaGlobalFunc_MentalGame_Open() then
    PaGlobalFunc_MentalGame_Close()
  end
end
function PanelCloseFunc_VoiceChat()
  if true == PaGlobalFunc_VoiceChat_GetShow() then
    FGlobal_SetVoiceChat_Toggle()
  end
end
function PanelCloseFunc_ChannelSelect()
  Panel_ChannelSelect:SetShow(false, true)
end
function PanelCloseFunc_MiniGameFind()
  if nil ~= PaGloablFunc_MiniGameFind_GetShow and true == PaGloablFunc_MiniGameFind_GetShow() then
    PaGlobal_MiniGame_Find:askGameClose()
  end
end
function PanelCloseFunc_EventNotify()
  FGlobal_NpcNavi_Hide()
  EventNotify_Close()
end
function PanelCloseFunc_DailyStamp()
  DailStamp_Hide()
  Panel_Tooltip_Item_hideTooltip()
  TooltipSimple_Hide()
end
function PanelCloseFunc_ArshaTeamNameChange()
  FGlobal_TeamNameChangeControl_Close()
end
function PanelCloseFunc_ArshaInviteList()
  FGlobal_ArshaPvP_InviteList_Close()
end
function PanelCloseFunc_Arsha()
  FGlobal_ArshaPvP_Close()
end
function PanelCloseFunc_ScreenShotAlbumFullScreen()
  ScreenshotAlbum_FullScreen_Close()
end
function PanelCloseFunc_ScreenShotAlbum()
  ScreenshotAlbum_Close()
end
function PanelCloseFunc_BlackSpiritAdventure()
  BlackSpiritAd_Hide()
end
function PanelCloseFunc_BlackSpiritAdventure2()
  BlackSpirit2_Hide()
end
function PanelCloseFunc_BlackSpiritAdventureVerPC()
  if Panel_Window_BlackSpiritAdventure:IsUISubApp() then
    return
  end
  Panel_Window_BlackSpiritAdventureVerPC:SetShow(false, false)
end
function PanelCloseFunc_ClothInventory()
  if nil ~= ClothInventory_Close then
    ClothInventory_Close()
  end
end
function PanelCloseFunc_Mercenary()
  FGlobal_MercenaryClose()
end
function PanelCloseFunc_MasterpieceAuction()
  if nil ~= FGlobal_MasterPieceAuction_IsOpenEscMenu and FGlobal_MasterPieceAuction_IsOpenEscMenu() then
    if nil ~= PaGlobal_MasterpieceAuction then
      PaGlobal_MasterpieceAuction:close()
    end
    return
  end
end
function PanelCloseFunc_MovieGuideWeb()
  PaGlobal_MovieGuide_Web:Close()
end
function PanelCloseFunc_MovieGuideWebList()
  PaGlobal_MovieGuide_Weblist:Close()
end
function PanelCloseFunc_MovieSkillGuideWeblist()
  PaGlobal_MovieSkillGuide_Web:Close()
end
function PanelCloseFunc_MovieSkillGuide()
  PaGlobal_MovieSkillGuide_Weblist:Close()
end
function PanelCloseFunc_CheckedQuestQption()
  FGlobal_CheckedQuestOptionClose()
end
function PanelCloseFunc_Skill()
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  else
    PaGlobalFunc_Skill_Close()
  end
  if Panel_EnableSkill:GetShow() then
    FGlobal_EnableSkillCloseFunc()
  end
end
function PanelCloseFunc_SaveSetting()
  PaGlobal_Panel_SaveSetting_Hide()
end
function PanelCloseFunc_HarvestList()
  HarvestList_Close()
end
function PanelCloseFunc_PartyRecruite()
  if true == _ContentsGroup_RenewUI_Party then
    PaGlobalFunc_FindPartyRecruite_Exit()
  else
    PartyListRecruite_Close()
  end
end
function PanelCloseFunc_ServantResurrection()
  Panel_ServantResurrection_Close()
end
function PanelCloseFunc_DialogNPCShopRenew()
  PaGlobalFunc_Dialog_NPCShop_Close()
end
function PanelCloseFunc_DialogNPCShop()
  NpcShop_WindowClose()
end
function PanelCloseFunc_Camp()
  PaGlobal_Camp:close()
end
function PanelCloseFunc_CampRegister()
  FGlobal_CampRegister_Close()
end
function PanelCloseFunc_MonsterRanking()
  FGlobal_MonsterRanking_Close()
end
function PanelCloseFunc_ChatOption()
  ChattingOption_Close()
end
function PanelCloseFunc_BuildingBuff()
  PaGlobal_BuildingBuff:close()
end
function PanelCloseFunc_PersonalBattle()
  PaGlobal_PersonalBattle:close()
end
function PanelCloseFunc_Memo()
  PaGlobal_Memo:ListClose()
end
function PanelCloseFunc_GuildOneOnOneRequest()
  FGlobal_GuildTeamBattle_CloseRequestPanel()
end
function PanelCloseFunc_CustomizingAlbum()
  CustomizingAlbum_Close(_isAllClose)
end
function PanelCloseFunc_IntroMovie()
  CloseIntroMovie()
end
function PanelCloseFunc_ChattingInput()
  ChatInput_Close()
end
function PanelCloseFunc_ButtonShortcuts()
  PaGlobal_ButtonShortcuts:Close()
end
function PanelCloseFunc_TranslationReport()
  TranslationReport_Close()
end
function PanelCloseFunc_ProductNote()
  Panel_ProductNote_ShowToggle()
end
function PanelCloseFunc_KeyboardHelp()
  FGlobal_KeyboardHelpShow()
end
function PanelCloseFunc_WebControl()
  Panel_WebHelper_ShowToggle()
end
function PanelCloseFunc_Warehouse()
  if true == ToClient_isConsole() then
    if false == PaGlobalFunc_ManufactureCheckShow() then
      Warehouse_Close()
    end
  else
    Warehouse_Close()
  end
end
function PanelCloseFunc_SetVoiceChat()
  FGlobal_SetVoiceChat_Close()
end
function PanelCloseFunc_WorkerChangeSkill()
  FGlobal_workerChangeSkill_Close()
end
function PanelCloseFunc_FileExplorer()
  closeExplorer()
end
function PanelCloseFunc_WorkerManager()
  workerManager_Close()
  FGlobal_HideWorkerTooltip()
end
function PanelCloseFunc_WorkerRestoreAll()
  workerRestoreAll_Close()
end
function PanelCloseFunc_WorkerAuction()
  WorkerAuction_Close()
end
function PanelCloseFunc_WorkerResistAuction()
  FGlobal_ResistWorkerToAuction_Close()
end
function PanelCloseFunc_WorkerListAuction()
  MyworkerList_Close()
end
function PanelCloseFunc_Exchange()
  Panel_ExchangePC_BtnClose_Mouse_Click()
end
function PanelCloseFunc_TransferLifeExperience()
  FGlobal_TransferLife_Close()
end
function PanelCloseFunc_DyePalette()
  FGlobal_DyePalette_Close()
end
function PanelCloseFunc_SetShortCut()
  FGlobal_NewShortCut_Close()
end
function PanelCloseFunc_Alchemy()
  if _ContentsGroup_RenewUI_Alchemy then
    return PaGlobalFunc_AlchemyBack()
  elseif true == GlobalSwitch_UseOldAlchemy then
    Alchemy_Close()
  else
    FGlobal_Alchemy_Close()
  end
end
function PanelCloseFunc_Manufacture()
  if _ContentsGroup_RenewUI_Manufacture then
    return PaGlobalFunc_ManufactureBack()
  end
end
function PanelCloseFunc_Inventory()
  if _ContentsGroup_RenewUI_Manufacture and PaGlobalFunc_ManufactureCheckShow() then
    return PaGlobalFunc_ManufactureBack()
  end
  if _ContentsGroup_RenewUI_Alchemy and PaGlobalFunc_AlchemyCheckShow() then
    return PaGlobalFunc_AlchemyBack()
  end
  InventoryWindow_Close()
  if nil ~= Panel_Equipment and Panel_Equipment:GetShow() then
    Equipment_SetShow(false)
  end
  if nil ~= ClothInventory_Close then
    ClothInventory_Close()
  end
end
function PanelCloseFunc_ExchangeNumber()
  Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
end
function PanelCloseFunc_Option()
  GameOption_Cancel()
  TooltipSimple_Hide()
end
function PanelCloseFunc_CarveSeal()
  FromClient_SealWindowHide()
end
function PanelCloseFunc_GuildWebInfo()
  FGlobal_GuildWebInfoClose()
end
function PanelCloseFunc_GuildRankWeb()
  GuildRank_Web_Close()
end
function PanelCloseFunc_GuildRank()
  FGlobal_guildRanking_Close()
end
function PanelCloseFunc_ChangeWeapon()
  WeaponChange_Close()
end
function PanelCloseFunc_SkillReinforce()
  Panel_SkillReinforce_Close()
end
function PanelCloseFunc_Looting()
end
function PanelCloseFunc_FriendList()
  if true == _ContentsGroup_NewUI_Friend_All then
    PaGlobal_FriendList_Hide_All()
  else
    FriendList_hide()
  end
end
function PanelCloseFunc_CheckedQuest()
  FGlobal_QuestInfoDetail_Close()
end
function PanelCloseFunc_Quest()
  Panel_Window_QuestNew_Show(false)
end
function PanelCloseFunc_QuestRenew()
  PaGlobalFunc_Quest_SetShow(false)
end
function PanelCloseFunc_DeliveryRequest()
  DeliveryRequestWindow_Close()
end
function PanelCloseFunc_Guild()
  if nil ~= Panel_Guild_ManufactureSelect and Panel_Guild_ManufactureSelect:GetShow() then
    PaGlobal_Guild_ManufactureSelect:close()
  else
    GuildManager:Hide()
    audioPostEvent_SystemUi(1, 31)
    _AudioPostEvent_SystemUiForXBOX(1, 31)
  end
end
function PanelCloseFunc_AgreementGuildMaster()
  agreementGuild_Master_Close()
end
function PanelCloseFunc_AgreementGuildMaster()
  CheckChattingInput()
  audioPostEvent_SystemUi(1, 31)
  _AudioPostEvent_SystemUiForXBOX(1, 31)
  FGlobal_AgreementGuild_Close()
end
function PanelCloseFunc_GuildIncentive()
  FGlobal_GuildIncentive_Close()
end
function PanelCloseFunc_GuildDuel()
  FGlobal_GuildDuel_Close()
end
function PanelCloseFunc_GameTips()
  if false == _ContentsGroup_RenewUI then
    FGlobal_GameTipsHide()
  end
end
function PanelCloseFunc_PetInfoNew()
  TooltipSimple_Hide()
end
function PanelCloseFunc_Event100Day()
  FGlobal_Event_100Day_Close()
end
function PanelCloseFunc_DanceFrame()
  if nil ~= FGlobal_DanceFrame_Close then
    FGlobal_DanceFrame_Close()
  end
end
function PanelCloseFunc_WorkerTooltip()
  FGlobal_HideWorkerTooltip()
end
function PanelCloseFunc_ChangeItem()
  ItemChange_Close()
end
function PanelCloseFunc_MovieGuide()
  Panel_MovieGuide_ShowToggle()
end
function PanelCloseFunc_ItemMarket()
  FGolbal_ItemMarketNew_Close()
end
function PanelCloseFunc_ItemMarketRegistItem()
  FGlobal_ItemMarketRegistItem_Close()
end
function PanelCloseFunc_AlchemyStone()
  FGlobal_AlchemyStone_Close()
end
function PanelCloseFunc_AlchemyFigureHead()
  FGlobal_AlchemyFigureHead_Close()
end
local isComboMovieClosedCount = 0
function PanelCloseFunc_MovieTheater320()
  if Panel_MovieTheater_320:IsShow() == false then
    value_Panel_MovieTheater_320_IsCheckedShow = false
  end
  if value_Panel_MovieTheater_320_IsCheckedShow == true then
    isComboMovieClosedCount = isComboMovieClosedCount + 1
    if isComboMovieClosedCount >= 3 then
      Panel_MovieTheater320_MessageBox()
      Panel_MovieTheater_MessageBox:SetShow(true)
    else
      Panel_MovieTheater320_ResetMessageBox()
      Panel_MovieTheater320_JustClose()
    end
  end
end
function PanelCloseFunc_CharacterTag()
  PaGlobal_CharacterTag_Close()
end
function PanelCloseFunc_FairyInfo()
  PaGlobal_FairyInfo_Close()
end
function PanelCloseFunc_FairySetting()
  PaGlobal_FairySetting_Close()
end
function PanelCloseFunc_FairyUpgrade()
  PaGlobal_FairyInfo_Close()
end
function PanelCloseFunc_LifeRanking()
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    FGlobal_LifeRanking_Close()
  else
    PaGlobal_LifeRanking_Close_All()
  end
end
function PanelCloseFunc_MessageBox()
  messageBox_CloseButtonUp()
end
function PanelCloseFunc_MessageBoxCheck()
  messageBoxCheck_CloseButtonUp()
end
function PanelCloseFunc_Delivery_Information_Close()
  Panel_Window_Delivery_Information:SetShow(false)
end
function PanelCloseFunc_QuestInfo_Close()
  Panel_QuestInfo:SetShow(false)
end
function PanelCloseFunc_PetRestoreAll_Close()
  Panel_PetRestoreAll:SetShow(false)
end
function PanelCloseFunc_QuestReward_Close()
  if Panel_Npc_Quest_Reward:IsUISubApp() then
    FGlobal_ShowRewardList(false, 0)
  end
end
function PanelCloseFunc_Equip_Close()
  if Panel_Window_Inventory:GetShow(true) then
    PanelCloseFunc_Inventory()
  else
    Equipment_SetShow(false)
  end
end
function PanelCloseFunc_SettingVendingMachine_Close()
  Panel_Housing_SettingVendingMachine:SetShow(false)
end
function PanelCloseFunc_SettingConsignmentSale_Close()
  Panel_Housing_SettingConsignmentSale:SetShow(false)
end
function PanelCloseFunc_RegisterConsignmentSale_Close()
  Panel_Housing_RegisterConsignmentSale:SetShow(false)
end
function PanelCloseFunc_GuildWarInfo_Close()
  Panel_Window_GuildWarInfo:SetShow(false)
end
function PanelCloseFunc_StableFunction_Close()
  if false == _ContentsGroup_RenewUI_StableInfo then
    StableFunction_Close()
  else
    StableFunction_Close()
  end
end
function PanelCloseFunc_PetExchange_Close()
  if Defines.CloseType.eCloseType_Attacked == getCurrentCloseType() then
    PaGlobalFunc_PetExchange_Close_Global()
  else
    PaGlobalFunc_PetExchange_Close()
  end
end
function PaGlobalFunc_FixEquip_Close()
  if Defines.CloseType.eCloseType_Attacked == getCurrentCloseType() then
    FixEquip_Close()
    PaGlobal_Repair:repair_OpenPanel(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  else
    FixEquip_Close()
  end
end
function PanelEscapeFunc_CharacterInfo_Close()
  PaGlobal_CharacterInfo:hideWindow()
end
function PanelCloseFunc_WindowOption()
  Panel_Window_Option:SetShow(false)
end
function PanelCloseFunc_CompetitionGame()
  if nil ~= Panel_CompetitionGame_JoinDesc and true == Panel_CompetitionGame_JoinDesc:GetShow() then
    PaGlobalFunc_CompetitionGame_JoinDesc_Close()
  end
  if true == Panel_CompetitionGame_GuildReservation:GetShow() then
    FGlobal_Panel_CompetitionGame_GuildReservation_Close()
  end
end
function PaGlobalFunc_Enchant_Close()
  Panel_Window_Enchant_Renew:SetShow(false)
end
function PaGlobalFunc_Socket_Close()
  Panel_Window_Socket_Renew:SetShow(false)
end
function PaGlobalFunc_Improvement_Close()
  Panel_Window_Improvement_Renew:SetShow(false)
end
function PaGlobalFunc_ItemMArketAlarmListClose()
  if not PaGlobalFunc_ItemMarketAlarmList_IsUISubApp() then
    ItemMarket_AlarmList_Close()
  end
end
function close_UISubAppPanelList()
end
