function PaGlobalFunc_DialogMain_All_Open()
  PaGlobal_DialogMain_All:prepareOpen()
end
function PaGlobalFunc_DialogMain_All_Close(isSetWait)
  PaGlobal_DialogMain_All:prepareClose(isSetWait)
end
function PaGlobalFunc_DialogMain_All_ShowToggle(isShow)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  Panel_Npc_Dialog_All:SetShow(isShow)
  PaGlobalFunc_DialogMain_All_SubPanelSetShow(isShow)
end
function PaGlobalFunc_DialogMain_All_SubPanelSetShow(isShow)
  if false == isShow then
    PaGlobalFunc_InterestKnowledge_All_Close()
    PaGlobalFunc_DialogIntimacy_All_Close()
    PaGlobalFunc_DialogList_All_Close()
  end
end
function PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(ignoreShowDialog)
  PaGlobal_DialogMain_All._ignoreShowDialog = ignoreShowDialog
end
function HandleEventLUp_DialogMain_All_BackClick()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  if check_ShowWindow() then
    close_WindowPanelList()
  end
  if false == _ContentsGroup_RenewUI_SearchMode then
    if Panel_Dialog_Search:IsShow() then
      searchView_Close()
    end
  elseif nil ~= PaGlobalFunc_SearchMode_IsSearchMode and true == PaGlobalFunc_SearchMode_IsSearchMode() then
    searchView_Close()
  end
  ToClient_SetFilterType(0, false)
  BlackSpiritAd_Hide()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  PaGlobal_DialogMain_All._selectDialogFuncIndex = nil
  PaGlobal_DialogMain_All:funcBottomBtnUpdate(dialogData)
  ReqeustDialog_retryTalk()
end
function HandleEventLUp_DialogMain_All_ExitClick()
  PaGlobalFunc_DialogMain_All_Close()
end
function HandleEventLUp_DialogMain_All_FuncButton(index)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  PaGlobalFunc_DialogMain_All_CloseWithDialog()
  PaGlobal_DialogMain_All:funcBottomBtnClick(index)
end
function PaGlobalFunc_DialogMain_All_RandomWorkerSelectUseMyWpConfirm(index)
  if nil == index then
    index = PaGlobal_DialogMain_All._indexWorkerShopClicked
  end
  npcShop_requestList(CppEnums.ContentsType.Contents_Shop)
  Dialog_clickFuncButtonReq(index)
  PaGlobalFunc_DialogMain_All_SubPanelSetShow(false)
end
function PaGlobalFunc_DialogMain_All_BottomFuncBtnUpdate()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  PaGlobal_DialogMain_All:funcBottomBtnUpdate(dialogData)
end
function PaGlobalFunc_DialogMain_All_BlackSpiritSkillSelectTooltip()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIDGET_BLACKSPIRIT_SKINSELECT_TITLE")
  local dese = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NPC_DIALOG_BACK_BLACKSPIRIT_BUTTON_DESE")
  TooltipSimple_Show(PaGlobal_DialogMain_All._ui_pc.btn_blackSpiritSkillSelect, name, dese)
end
function FromClient_DialogMain_All_onScreenResize()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  PaGlobal_DialogMain_All:resize()
end
function FromClient_DialogMain_All_ShowDialog()
  PaGlobalFunc_DialogMain_All_Open()
end
function FromClient_DialogMain_All_HideDialog(isSetWait)
  PaGlobalFunc_DialogMain_All_Close(isSetWait)
end
function FromClient_DialogMain_All_CloseNpcTradeMarketTalkForDead()
  PaGlobalFunc_DialogMain_All_CloseWithDialog()
end
function FromClient_DialogMain_All_CloseDialogByAttacked()
  PaGlobal_DialogMain_All._renderMode:reset()
end
function PaGloalFunc_DialogMain_All_PreClosePanel()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  end
  if nil ~= Panel_QuestInfo and true == Panel_QuestInfo:GetShow() then
    questInfo_TooltipShow(false)
  end
  if nil ~= PaGlobalFunc_ItemMarketRegistItem_GetShow and true == PaGlobalFunc_ItemMarketRegistItem_GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  if nil ~= FGlobal_Option_GetShow and true == FGlobal_Option_GetShow() then
    GameOption_Cancel()
    TooltipSimple_Hide()
  end
  if false == _ContentsGroup_NewUI_BlackSmith_All then
    if nil ~= Panel_Window_Extraction_Caphras and Panel_Window_Extraction_Caphras:GetShow() then
      PaGlobal_ExtractionCaphras_Close()
    end
  elseif nil ~= Panel_Window_Extraction_Caphras_All and Panel_Window_Extraction_Caphras_All:GetShow() then
    PaGlobal_Extraction_Caphras_All_Close()
  end
  if nil ~= Panel_ColorBalance and true == Panel_ColorBalance:GetShow() then
    Panel_ColorBalance_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerManager_All then
    if nil ~= Panel_Window_WorkerManager_All and true == Panel_Window_WorkerManager_All:GetShow() then
      PaGlobalFunc_WorkerManager_All_Close()
      FGlobal_InitWorkerTooltip()
    end
  elseif nil ~= Panel_WorkerManager and true == Panel_WorkerManager:GetShow() then
    workerManager_Close()
    FGlobal_InitWorkerTooltip()
  end
  if nil ~= Panel_Menu and true == Panel_Menu:GetShow() then
    Panel_Menu_Close()
  end
  if nil ~= Panel_Window_Camp and true == Panel_Window_Camp:GetShow() then
    PaGlobal_Camp:close()
  end
  if nil ~= DetectPlayer_Close then
    DetectPlayer_Close()
  end
  if nil ~= PaGlobalFunc_ItemMarket_GetShow and true == PaGlobalFunc_ItemMarket_GetShow() then
    FGolbal_ItemMarketNew_Close()
    if nil ~= Panel_Win_System and true == Panel_Win_System:GetShow() then
      messageBox_NoButtonUp()
    end
  end
  if PaGlobal_DialogMain_All._showCheck_Once == false then
    InventoryWindow_Close()
    ClothInventory_Close()
  end
  if false == _ContentsGroup_RenewUI_SearchMode then
    if nil ~= Panel_Dialog_Search and true == Panel_Dialog_Search:IsShow() then
      searchView_Close()
    end
  elseif nil ~= PaGlobalFunc_SearchMode_IsSearchMode and true == PaGlobalFunc_SearchMode_IsSearchMode() then
    searchView_Close()
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace and (nil ~= PaGlobalFunc_MarketPlace_GetShow and true == PaGlobalFunc_MarketPlace_GetShow() or nil ~= PaGlobalFunc_MarketWallet_GetShow and true == PaGlobalFunc_MarketWallet_GetShow()) then
    PaGlobalFunc_MarketPlace_CloseAllCheck()
  end
  if nil ~= Panel_GameExit and true == Panel_GameExit:GetShow() then
    GameExit_Close()
  end
  Panel_Tooltip_Item_hideTooltip()
  Panel_SkillTooltip_Hide()
  FGlobal_BuffTooltipOff()
  PaGlobalAppliedBuffList:hide()
  Interaction_Close()
  Panel_MovieTheater_LowLevel_WindowClose()
  if nil ~= Panel_Window_Exchange and true == Panel_Window_Exchange:GetShow() then
    ExchangePC_MessageBox_ResponseCancel()
  end
end
function PaGlobalFunc_DialogMain_All_CloseWithDialog()
  if nil ~= Panel_IngameCashShop_EasyPayment and true == Panel_IngameCashShop_EasyPayment:GetShow() then
    if nil ~= Panel_IngameCashShop_BuyOrGift and true == Panel_IngameCashShop_BuyOrGift:GetShow() then
      local couponOpen = nil ~= Panel_IngameCashShop_Coupon and true == Panel_IngameCashShop_Coupon:GetShow()
      InGameShopBuy_Close(couponOpen)
    end
    PaGlobal_EasyBuy_Close()
  end
  if nil ~= Panel_Window_Extraction_Result and true == Panel_Window_Extraction_Result:GetShow() then
    PaGlobal_ExtractionResult:setHide()
  end
  if nil ~= Panel_TranslationReport and true == Panel_TranslationReport:GetShow() then
    TranslationReport_Close()
  end
  if nil ~= Panel_Window_Warehouse and true == Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  end
  if false == _ContentsGroup_NewUI_CreateClan_All then
    if Panel_CreateClan ~= nil and Panel_CreateClan:GetShow() or nil ~= Panel_CreateGuild and Panel_CreateGuild:GetShow() then
      CreateClan_Close()
    end
  elseif Panel_CreateClan_All ~= nil and Panel_CreateClan_All:GetShow() or nil ~= Panel_CreateGuild and Panel_CreateGuild:GetShow() then
    PaGlobal_CreateClan_All_Close()
  end
  if false == _ContentsGroup_RenewUI_Skill then
    HandleMLUp_SkillWindow_Close()
  end
  if true == isMonsterBarShow then
    Panel_Monster_Bar:SetShow(true, false)
    isMonsterBarShow = false
  end
  if nil ~= Panel_Window_Exchange and true == Panel_Window_Exchange:IsShow() then
    ExchangePc_MessageBox_CloseConfirm()
  end
  if nil ~= Panel_GuildHouse_Auction and true == Panel_GuildHouse_Auction:GetShow() then
    Panel_GuildHouse_Auction:SetShow(false)
  end
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= HandleEventLUp_NPCShop_ALL_Close then
    HandleEventLUp_NPCShop_ALL_Close()
  else
    NpcShop_WindowClose()
  end
  if false == _ContentsGroup_NewUI_CreateClan_All then
    CreateClan_Close()
  else
    PaGlobal_CreateClan_All_Close()
  end
  if not _ContentsGroup_RenewUI_Manufacture then
    Manufacture_Close()
  end
  if true == _ContentsGroup_NewUI_WorkerAuction_All and nil ~= Panel_Window_WorkerAuction_All then
    HandleEventLUp_WorkerAuction_All_Close()
  else
    if nil ~= Panel_Worker_Auction then
      WorkerAuction_Close()
      Panel_Window_WorkerRandomSelect:SetShow(false)
    end
    if nil ~= Panel_WorkerResist_Auction and nil ~= Panel_WorkerList_Auction then
      Panel_WorkerResist_Auction:SetShow(false)
      Panel_WorkerList_Auction:SetShow(false)
    end
  end
  if true == _ContentsGroup_NewUI_WorkerRandomSelect_All and nil ~= Panel_Window_WorkerRandomSelect_All then
    HandleEventLUp_WorkerRandomSelect_All_ForceClose()
  end
  if true == _ContentsGroup_RenewUI_Gift then
    PaGlobalFunc_NpcGift_Close()
  else
    FGlobal_NpcGift_Close()
  end
  if true == _ContentsGroup_NewUI_Purification_All and nil ~= Panel_Purification_All then
    HandleEventLUp_Purification_All_Close()
  elseif nil ~= Panel_Purification_Renew or nil ~= Panel_Purification then
    PaGlobal_Purification_Close()
  end
  if nil ~= Panel_Window_Enchant and true == Panel_Window_Enchant:GetShow() then
    PaGlobal_Enchant:enchantClose()
  end
  if nil ~= Panel_Window_Socket and true == Panel_Window_Socket:GetShow() then
    Socket_WindowClose()
  end
  if nil ~= Panel_Improvement and true == Panel_Improvement:GetShow() then
    Panel_Improvement_Hide()
  end
  if nil ~= Panel_SkillAwaken and true == Panel_SkillAwaken:GetShow() then
    SkillAwaken_Close()
  end
  if nil ~= Panel_Window_MasterpieceAuction and true == Panel_Window_MasterpieceAuction:GetShow() then
    PaGlobal_MasterpieceAuction:close()
  end
  if nil ~= Panel_GuildHouse_Auction_All and Panel_GuildHouse_Auction_All:GetShow() then
    PaGlobal_GuildHouse_Auction_All_Close()
  end
  if nil ~= Panel_GuildHouse_Auction_Detail_All and Panel_GuildHouse_Auction_Detail_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Detail_All_Close()
  end
  if nil ~= Panel_GuildHouse_Auction_Bid_All and Panel_GuildHouse_Auction_Bid_All:GetShow() then
    PaGlobal_GuildHouse_Auction_Bid_All_Close()
  end
  if nil ~= Panel_CreateClan_All and Panel_CreateClan_All:GetShow() then
    PaGlobal_CreateClan_All_Close()
  end
  if nil ~= Panel_Guild_Create_All and Panel_Guild_Create_All:GetShow() then
    PaGlobal_Guild_Create_All_Close()
  end
  if nil ~= getCustomizingManager and true == getCustomizingManager():isShow() then
    HandleClicked_CloseIngameCustomization()
  end
  if nil ~= Panel_Npc_Trade_Market and true == Panel_Npc_Trade_Market:IsShow() then
    closeNpcTrade_Basket()
  end
  if nil ~= Panel_Window_StableFunction and true == Panel_Window_StableFunction:IsShow() then
    StableFunction_Close()
  end
  if nil ~= Panel_Window_Extraction and true == Panel_Window_Extraction:IsShow() then
    PaGlobal_Extraction:openPanel(false)
  end
  if nil ~= Panel_FixEquip and true == Panel_FixEquip:GetShow() then
    handleMClickedRepairExitButton()
    PaGlobal_Repair:repair_OpenPanel(false)
    Panel_FixEquip:SetShow(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  if nil ~= Panel_Window_GuildStableFunction and true == Panel_Window_GuildStableFunction:IsShow() then
    GuildStableFunction_Close()
  end
  if nil ~= PaGlobalFunc_ItemMarketFunction_GetShow and true == PaGlobalFunc_ItemMarketFunction_GetShow() then
    FGolbal_ItemMarket_Function_Close()
    if nil ~= PaGlobalFunc_ItemMarketRegistItem_GetShow and true == PaGlobalFunc_ItemMarketRegistItem_GetShow() then
      FGlobal_ItemMarketRegistItem_Close()
    end
    if nil ~= PaGlobalFunc_ItemMarketBuyConfirm_GetShow and true == PaGlobalFunc_ItemMarketBuyConfirm_GetShow() then
      FGlobal_ItemMarket_BuyConfirm_Close()
    end
    if nil ~= PaGlobalFunc_ItemMarketItemSet_GetShow and true == PaGlobalFunc_ItemMarketItemSet_GetShow() then
      FGlobal_ItemMarketItemSet_Close()
    end
    if nil ~= PaGlobalFunc_ItemMarket_GetShow and true == PaGlobalFunc_ItemMarket_GetShow() then
      FGolbal_ItemMarketNew_Close()
    end
  end
  if true == _ContentsGroup_RenewUI_ItemMarketPlace and nil ~= PaGlobalFunc_MarketPlace_Function_GetShow and true == PaGlobalFunc_MarketPlace_Function_GetShow() then
    PaGlobalFunc_MarketPlace_Function_Close()
  end
  if nil ~= Panel_Window_WharfFunction and true == Panel_Window_WharfFunction:GetShow() then
    WharfFunction_Close()
  end
  if nil ~= Panel_Window_GuildWharfFunction and true == Panel_Window_GuildWharfFunction:GetShow() then
    GuildWharfFunction_Close()
  end
  if nil ~= Panel_FixEquip and true == Panel_FixEquip:GetShow() then
    FixEquip_Close()
  end
  if nil ~= Panel_Knowledge_Main and true == Panel_Knowledge_Main:GetShow() then
    Panel_Knowledge_Hide()
  end
  if false == _ContentsGroup_RenewUI_Dyeing and nil ~= Panel_DyeNew_CharacterController and true == Panel_DyeNew_CharacterController:GetShow() then
    FGlobal_Panel_DyeReNew_Hide()
  end
  if nil ~= Panel_CustomizationMain and true == Panel_CustomizationMain:GetShow() then
    IngameCustomize_Hide()
  end
  if true == _ContentsGroup_OceanCurrent then
    PaGlobal_Barter_Close()
    Panel_Exchange_Item_Hide()
  end
  if false == _ContentsGroup_NewUI_RandomShop_All then
    randomSelectHide()
  else
    PaGlobalFunc_RandomShop_All_Close()
  end
  PaGlobalFunc_DialogQuest_All_Close()
  InventoryWindow_Close()
  ServantInfo_Close()
  CarriageInfo_Close()
  ServantInventory_Close()
  FGlobal_RaceInfo_Hide()
  GuildServantList_Close()
  LordMenu_Hide()
  PaGlobal_MasterpieceAuction:close()
  FGlobal_ItemMarketRegistItem_Close()
  FGolbal_ItemMarketNew_Close()
  PaGlobalFunc_ItemMarketRegistItem_SetShow(false)
  Panel_Window_Delivery_Information:SetShow(false)
  Panel_Window_Delivery_Request:SetShow(false)
  Panel_Dialogue_Itemtake:SetShow(false)
  DetectPlayer_Close()
  BlackSpiritAd_Hide()
  click_DeliveryForPerson_Close()
  FGlobal_NodeWarMenuClose()
  ChatInput_Close()
  Panel_Window_ReinforceSkill_Close()
  Panel_SkillReinforce_Close()
end
function FromClient_DialogMain_All_CloseAllPanelWhenNpcGoHome()
  if GetUIMode() == Defines.UIMode.eUIMode_Stable then
    StableFunction_Close()
  end
  if Panel_Window_WharfFunction:GetShow() then
    WharfFunction_Close()
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Trade then
    closeNpcTrade_Basket()
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Repair then
    if true == _ContentsGroup_RenewUI_Repair then
      PaGlobalFunc_RepairInfo_Close()
    else
      PaGlobal_Repair:repair_OpenPanel(false)
    end
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Extraction then
    PaGlobal_Extraction:openPanel(false)
  end
  if GetUIMode() == Defines.UIMode.eUIMode_MentalGame then
    MentalGame_Hide()
  end
end
function PaGlobalFunc_DialogMain_All_GetAuctionState()
  return PaGlobal_DialogMain_All._isAuctionDialog
end
function PaGlobalFunc_DialogMain_All_RestoreUI(isSetWait)
  if nil ~= Panel_SkillCommand then
    if FGlobal_IsChecked_SkillCommand() == true then
      Panel_SkillCommand:SetShow(true)
      changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
    else
      Panel_SkillCommand:SetShow(false)
      changePositionBySever(Panel_SkillCommand, CppEnums.PAGameUIType.PAGameUIPanel_SkillCommand, true, true, false)
    end
  end
  PaGlobalAppliedBuffList:show()
  Inven_FindPuzzle()
  PaGlobalFunc_DialogMain_All_ResetRenderMode()
  local questNo = getTutorialQuestNo()
  if -1 == questNo then
    setTutorialQuestNo(-1)
  elseif 0 ~= questNo then
    Tutorial_Quest(questNo)
    setTutorialQuestNo(0)
  else
    setTutorialQuestNo(-1)
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    Panel_NewEquip_EffectLastUpdate()
  end
  if nil == isSetWait then
    isSetWait = true
  end
  Dialog_clickExitReq(isSetWait)
  checkHpAlertPostEvent()
  PaGlobal_DialogMain_All._handleClickedQuestComplete = false
end
function PaGlobalFunc_DialogMain_All_IsDialogNewQuest()
  if nil == Panel_Npc_Dialog_All then
    return false
  end
  return PaGlobal_DialogMain_All._isDialogNewQuest
end
function PaGlobalFunc_DialogMain_All_GetFuncPositionNewQuestButton()
  local Position = {
    _Return = false,
    _PosX = -1,
    _PosY = -1
  }
  local Index = PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(CppEnums.ContentsType.Contents_NewQuest)
  if -1 == Index then
    return Position
  end
  Position._Return = true
  Position._PosX = PaGlobal_DialogMain_All._funcBtnList[Index]:GetPosX()
  Position._PosY = PaGlobal_DialogMain_All._funcBtnList[Index]:GetPosY()
  return Position
end
function PaGlobalFunc_DialogMain_All_FindFuncButtonIndexByType(targetFuncButtonType)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return -1
  end
  local dialogButtonCount = dialogData:getFuncButtonCount()
  for index = 0, dialogButtonCount - 1 do
    local funcButton = dialogData:getFuncButtonAt(index)
    local funcButtonType = tonumber(funcButton._param)
    if targetFuncButtonType == funcButtonType then
      return index
    end
  end
  return -1
end
function PaGlobalFunc_DialogMain_All_GetAuctionState()
  return PaGlobal_DialogMain_All._isAuctionDialog
end
function PaGlobalFunc_DialogMain_All_FirstLearnSkill()
  PaGlobal_DialogMain_All._isSkillTutorial = true
  HandleEventLUp_DialogMain_All_FuncButton(CppEnums.ContentsType.Contents_Skill)
  PaGlobal_DialogMain_All._isSkillTutorial = false
end
function PaGlobalFunc_DialogMain_All_IsSkillLearnTutorial()
  return PaGlobal_DialogMain_All._isSkillTutorial
end
function PaGlobalFunc_DialogMain_All_IsAllowTutorialPanelShow()
  return PaGlobal_DialogMain_All._isAllowTutorialPanelShow
end
function PaGlobalFunc_DialogMain_All_SetAllowTutorialPanelShow(isShow)
  PaGlobal_DialogMain_All._isAllowTutorialPanelShow = isShow
end
function PaGloalFunc_DialogMain_All_SetRenderMode(renderModeList)
  PaGlobal_DialogMain_All._renderMode:setRenderMode(renderModeList)
end
function PaGlobalFunc_DialogMain_All_ResetRenderMode()
  SetUIMode(Defines.UIMode.eUIMode_Default)
  if nil ~= Panel_Npc_Dialog_All and true == Panel_Npc_Dialog_All:GetShow() then
    PaGlobal_DialogMain_All._renderMode:reset()
    return
  end
end
function PaGlobalFunc_DialogMain_All_renderSetPrefunctor()
  PaGlobal_DialogMain_All._showCheck_Once = true
end
function PaGlobalFunc_DialogMain_All_renderSetClosefunctor()
  PaGlobalFunc_DialogMain_All_CloseWithDialog()
  PaGlobalFunc_DialogMain_All_Close(true)
end
function PaGlobalFunc_DialogMain_All_IsNormalTradeMerchant()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local characterKey = talker:getCharacterKey()
    local npcData = getNpcInfoByCharacterKeyRaw(characterKey, talker:get():getDialogIndex())
    if nil ~= npcData then
      return npcData:hasSpawnType(CppEnums.SpawnType.eSpawnType_TradeMerchant)
    end
  end
  return false
end
function PaGlobalFunc_DialogMain_All_TradeShopOpen()
  if 0 <= PaGlobal_DialogMain_All._tradeIndex then
    HandleEventLUp_DialogMain_All_FuncButton(PaGlobal_DialogMain_All._tradeIndex)
  end
end
