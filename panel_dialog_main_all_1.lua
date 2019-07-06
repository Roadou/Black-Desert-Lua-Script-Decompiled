function PaGlobal_DialogMain_All:initialize()
  if true == PaGlobal_DialogMain_All._initialize then
    return
  end
  Panel_Npc_Dialog_All:SetSize(getScreenSizeX(), Panel_Npc_Dialog_All:GetSizeY())
  self:controlAll_Init()
  self:controlPc_Init()
  self:controlConsole_Init()
  self:controlSetShow()
  self:initValue()
  PaGlobal_DialogMain_All:registEventHandler()
  PaGlobal_DialogMain_All:validate()
  PaGlobal_DialogMain_All._initialize = true
end
function PaGlobal_DialogMain_All:initValue()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._mainDialog = {}
  self._showCheck_Once = false
  for index = 0, self._maxFuncBtnIndex do
    local btn_slot = {}
    btn_slot = UI.createAndCopyBasePropertyControl(Panel_Npc_Dialog_All, "RadioButton_Function_Template", Panel_Npc_Dialog_All, "Buntton_Func_" .. index)
    self._funcBtnList[index] = btn_slot
  end
end
function PaGlobal_DialogMain_All:controlAll_Init()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._ui.radio_func = UI.getChildControl(Panel_Npc_Dialog_All, "RadioButton_Function_Template")
  self._ui.radio_back = UI.getChildControl(Panel_Npc_Dialog_All, "RadioButton_Back")
  self._ui.radio_exit = UI.getChildControl(Panel_Npc_Dialog_All, "RadioButton_Exit")
  self._ui.stc_tutorialArrow = UI.getChildControl(Panel_Npc_Dialog_All, "Static_TutorialArrow")
  self._ui.stc_selectBar = UI.getChildControl(Panel_Npc_Dialog_All, "Static_SelectBar")
end
function PaGlobal_DialogMain_All:controlPc_Init()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._ui_pc.stc_spaceBar = UI.getChildControl(Panel_Npc_Dialog_All, "Static_SpaceBarIcon")
  self._ui_pc.btn_blackSpiritSkillSelect = UI.getChildControl(Panel_Npc_Dialog_All, "Button_BlackSpirt_SkillSelect")
end
function PaGlobal_DialogMain_All:controlConsole_Init()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._ui_console.stc_iconLB = UI.getChildControl(Panel_Npc_Dialog_All, "Button_LB_ConsoleUI")
  self._ui_console.stc_iconRB = UI.getChildControl(Panel_Npc_Dialog_All, "Button_RB_ConsoleUI")
  self._ui_console.stc_iconA = UI.getChildControl(self._ui.stc_selectBar, "Button_A_ConsoleUI")
end
function PaGlobal_DialogMain_All:controlSetShow()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._ui_pc.stc_spaceBar:SetShow(false)
  if false == ToClient_isConsole() then
    self._ui_console.stc_iconLB:SetShow(false)
    self._ui_console.stc_iconRB:SetShow(false)
    self._ui_console.stc_iconA:SetShow(false)
    self._ui.stc_selectBar:SetShow(false)
  else
  end
end
function PaGlobal_DialogMain_All:resize()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  Panel_Npc_Dialog_All:SetSize(getScreenSizeX(), Panel_Npc_Dialog_All:GetSizeY())
  Panel_Npc_Dialog_All:ComputePos()
  self._ui.radio_func:ComputePos()
  self._ui.stc_tutorialArrow:ComputePos()
  self._ui_pc.stc_spaceBar:ComputePos()
  self._ui_console.stc_iconLB:ComputePos()
  self._ui_console.stc_iconRB:ComputePos()
  self._ui_console.stc_iconA:ComputePos()
end
function PaGlobal_DialogMain_All:prepareOpen()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if true == PaGlobal_QAServantSupportOn then
    return
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    return
  end
  PaGlobal_TutorialManager:handleBeforeShowDialog()
  FGlobal_RemoteControl_Hide()
  FGlobal_WebHelper_ForceClose()
  if CheckTutorialEnd() then
    ToClient_SaveUiInfo(false)
  end
  PaGloalFunc_DialogMain_All_PreClosePanel()
  if GetUIMode() ~= Defines.UIMode.eUIMode_Default and GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog and GetUIMode() ~= Defines.UIMode.eUIMode_NpcDialog_Dummy and GetUIMode() ~= Defines.UIMode.eUIMode_ItemMarket then
    ToClient_PopDialogueFlush()
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    ToClient_PopDialogueFlush()
    return
  end
  local mainDialog = dialogData:getMainDialog()
  if mainDialog == "" then
    ToClient_PopDialogueFlush()
    return
  end
  if not isFullSizeModeAble(FullSizeMode.fullSizeModeEnum.Dialog) then
    ToClient_PopDialogueFlush()
    return
  else
    setFullSizeMode(true, FullSizeMode.fullSizeModeEnum.Dialog)
  end
  FromClient_WarehouseUpdate()
  warehouse_requestInfo(getCurrentWaypointKey())
  setShowLine(false)
  setShowNpcDialog(true)
  PaGlobalFunc_DialogQuest_All_SetRewardList()
  PaGlobal_TutorialManager:handleShowDialog(dialogData)
  PaGlobal_DialogMain_All:resize()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  self._renderMode:set()
  self:update(dialogData)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_OPEN_DIALOG")
  PaGlobal_DialogMain_All:open()
end
function PaGlobal_DialogMain_All:open()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  Panel_Npc_Dialog_All:SetShow(true)
end
function PaGlobal_DialogMain_All:prepareClose(isSetWait)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if false == Panel_Npc_Dialog_All:IsShow() then
    return
  end
  if nil ~= Panel_Win_System and true == Panel_Win_System:GetShow() then
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return
  end
  local selfPlayer = selfPlayerWrapper:get()
  if nil == selfPlayer then
    return
  end
  if selfPlayer:getLevel() < 5 and false == _ContentsGroup_RenewUI_Chatting and nil ~= Panel_Chat0 then
    Panel_Chat0:SetShow(false)
  end
  local currentRegionKeyRaw = selfPlayerWrapper:getRegionKeyRaw()
  if 1 == selfPlayer:getLevel() and 10 == currentRegionKeyRaw and nil == dialog_getTalker() and false == questList_isClearQuest(21117, 1) and false == questList_hasProgressQuest(21117, 1) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_TUTIRIAL_DIALOGCLOSEALERT"))
    return
  end
  Auto_NotifyChangeDialog()
  ToClient_PopDialogueFlush()
  inventory_FlushRestoreFunc()
  FGlobal_NewLocalWar_Show()
  QuickSlot_UpdateData()
  FGlobal_QuestWidget_CalcScrollButtonSize()
  FGlobal_QuestWidget_UpdateList()
  Inventory_PosLoadMemory()
  self._showCheck_Once = false
  self._handleClickedQuestComplete = false
  self._isAuctionDialog = false
  self._selectDialogFuncIndex = nil
  PaGlobal_TutorialManager:handleAfterAndPopFlush()
  PaGlobal_TutorialManager:handleClickedExitButton(dialog_getTalker())
  FGlobal_RemoteControl_Hide()
  FGlobal_RemoteControl_Show(1)
  RemoteControl_Interaction_ShowToggloe(true)
  ToClient_SetFilterType(0, false)
  PaGlobal_LocalQuestAlert_AlertOpen()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    FGlobal_Inventory_WeightCheck()
    UIMain_QuestUpdate()
  end
  hide_DialogSceneUIPanel()
  PaGlobalFunc_DialogMain_All_CloseWithDialog()
  PaGlobalFunc_DialogMain_All_RestoreUI(isSetWait)
  Panel_Npc_Dialog_All:ResetVertexAni()
  searchView_Close()
  PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(false)
  setShowLine(true)
  setShowNpcDialog(false)
  setFullSizeMode(false, FullSizeMode.fullSizeModeEnum.Dialog)
  FGlobal_NpcNavi_ShowRequestOuter()
  if ToClient_IsSavedUi() then
    ToClient_SaveUiInfo(false)
    ToClient_SetSavedUi(false)
  end
  self._currentIdx = nil
  self._ui.stc_selectBar:SetShow(false)
  ToClient_AudioPostEvent_UIAudioStateEvent("UISTATE_CLOSE_DEFAULT")
  PaGlobal_DialogMain_All:close()
end
function PaGlobal_DialogMain_All:close()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  Panel_Npc_Dialog_All:SetShow(false)
end
function PaGlobal_DialogMain_All:update(dialogData)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if nil == dialogData then
    return
  end
  self:executeAfterDialogLoad(dialogData)
  self:funcBottomBtnUpdate(dialogData)
  if true == PaGlobalFunc_DialogQuest_All_DialogShowCheck() then
    PaGlobalFunc_DialogQuest_All_Open()
    PaGlobalFunc_DialogMain_All_SubPanelSetShow(false)
  else
    PaGlobalFunc_DialogQuest_All_Close()
    PaGlobalFunc_DialogList_All_Open()
    local talker = dialog_getTalker()
    if nil ~= talker then
      self._ui_pc.btn_blackSpiritSkillSelect:SetShow(false)
    else
      self._ui_pc.btn_blackSpiritSkillSelect:SetShow(ToClient_isAvailableSelectBlackSpirit())
    end
    PaGlobalFunc_DialogIntimacy_All_Open()
    PaGlobalFunc_InterestKnowledge_All_Open()
  end
end
function PaGlobal_DialogMain_All:validate()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  self._ui.radio_func:isValidate()
  self._ui.radio_back:isValidate()
  self._ui.radio_exit:isValidate()
  self._ui.stc_tutorialArrow:isValidate()
  self._ui.stc_selectBar:isValidate()
  self._ui_pc.stc_spaceBar:isValidate()
  self._ui_pc.btn_blackSpiritSkillSelect:isValidate()
  self._ui_console.stc_iconLB:isValidate()
  self._ui_console.stc_iconRB:isValidate()
  self._ui_console.stc_iconA:isValidate()
end
function PaGlobal_DialogMain_All:registEventHandler()
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    return
  end
  registerEvent("FromClient_ShowDialog", "FromClient_DialogMain_All_ShowDialog")
  registerEvent("FromClient_HideDialog", "FromClient_DialogMain_All_HideDialog")
  registerEvent("FromClient_CloseNpcTalkForDead", "PaGlobalFunc_DialogMain_All_Close")
  registerEvent("FromClient_CloseNpcTradeMarketTalkForDead", "FromClient_DialogMain_All_CloseNpcTradeMarketTalkForDead")
  registerEvent("FromClient_CloseAllPanelWhenNpcGoHome", "FromClient_DialogMain_All_CloseAllPanelWhenNpcGoHome")
  registerEvent("FromClient_VaryIntimacy_Dialog", "FromClient_DialogIntimacy_All_VaryIntimacy")
  registerEvent("onScreenResize", "FromClient_DialogMain_All_onScreenResize")
  registerEvent("progressEventCancelByAttacked", "FromClient_DialogMain_All_CloseDialogByAttacked")
  self._ui.radio_back:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogMain_All_BackClick()")
  self._ui.radio_exit:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogMain_All_ExitClick()")
  if false == ToClient_isConsole() then
    self._ui_pc.btn_blackSpiritSkillSelect:addInputEvent("Mouse_LUp", "PaGloabl_BlackSpiritSkillSelect_Open()")
    self._ui_pc.btn_blackSpiritSkillSelect:addInputEvent("Mouse_On", "PaGlobalFunc_DialogMain_All_BlackSpiritSkillSelectTooltip()")
    self._ui_pc.btn_blackSpiritSkillSelect:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  end
  self._renderMode:setPrefunctor(nil, PaGlobalFunc_DialogMain_All_renderSetPrefunctor)
  self._renderMode:setClosefunctor(nil, PaGlobalFunc_DialogMain_All_renderSetClosefunctor)
end
function PaGlobal_DialogMain_All:funcBottomBtnUpdate(dialogData)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if nil == dialogData then
    return
  end
  self._isDialogNewQuest = false
  self._ui_pc.stc_spaceBar:SetShow(false)
  self._tradeIndex = -1
  for index = 0, self._maxFuncBtnIndex do
    self._funcBtnList[index]:SetShow(false)
    self._funcBtnList[index]:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogMain_All_FuncButton(" .. index .. ")")
  end
  local totalBtnCount = 2
  local funcBtnCount = dialogData:getFuncButtonCount()
  totalBtnCount = totalBtnCount + dialogData:getFuncButtonCount()
  if 2 == totalBtnCount then
    self._ui.radio_back:SetSpanSize(-90, 15)
    self._ui.radio_exit:SetSpanSize(90, 15)
    return
  end
  local buttonSize = 150
  local buttonGap = 30
  local startPosX = (getScreenSizeX() - (buttonSize * funcBtnCount + buttonGap * (funcBtnCount - 1))) / 2 + 60
  local posX = 0
  for index = 0, funcBtnCount - 1 do
    local functionBtn = dialogData:getFuncButtonAt(index)
    posX = startPosX + (buttonSize + buttonGap) * index
    self._funcBtnList[index]:SetPosX(posX)
    self._funcBtnList[index]:SetShow(true)
    self:funcBtnAtUpdate(index, functionBtn)
  end
  self._ui.radio_back:SetPosX(startPosX - 180)
  self._ui.radio_exit:SetPosX(posX + 180)
  self._ui.radio_back:SetCheck(false)
  self._ui.radio_exit:SetCheck(false)
  if true == self._isDialogNewQuest then
    self._ui_pc.stc_spaceBar:SetShow(true)
    self._ui_pc.stc_spaceBar:SetPosX(self._funcBtnList[0]:GetPosX())
  end
  self:buttonColorSetting(self._selectDialogFuncIndex)
end
function PaGlobal_DialogMain_All:funcBtnAtUpdate(index, functionBtn)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if nil == functionBtn then
    return
  end
  local playerWp = 0
  local playerLevel = 0
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    playerWp = selfPlayer:getWp()
    playerLevel = selfPlayer:get():getLevel()
  end
  local funcButtonType = tonumber(functionBtn._param)
  self._funcBtnList[index]:SetText(functionBtn:getText())
  for i, v in ipairs(self._iconUpdateType) do
    if funcButtonType == self._iconUpdateType[i] then
      self:funcBtnIconUpdate(index, funcButtonType)
    end
  end
  if funcButtonType == CppEnums.ContentsType.Contents_IntimacyGame then
    self._funcBtnList[index]:SetText(functionBtn:getText() .. " (" .. functionBtn:getNeedWp() .. "/" .. playerWp .. ")")
  elseif funcButtonType == CppEnums.ContentsType.Contents_Stable then
    if true == isGuildStable() then
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        self:funcBtnIconUpdate(index, funcButtonType)
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        self:funcBtnIconUpdate(index, 9.1)
      end
    elseif CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
      self:funcBtnIconUpdate(index, funcButtonType)
    elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
      self:funcBtnIconUpdate(index, 9.1)
    end
  elseif funcButtonType == CppEnums.ContentsType.Contents_NewQuest then
    self._isDialogNewQuest = true
  elseif funcButtonType == CppEnums.ContentsType.Contents_Auction then
    self._isAuctionDialog = true
  elseif funcButtonType == CppEnums.ContentsType.Contents_Shop and true == PaGlobalFunc_DialogMain_All_IsNormalTradeMerchant() then
    FGlobal_RemoteControl_Show(5)
    self._tradeIndex = index
  end
end
function PaGlobal_DialogMain_All:funcBtnIconUpdate(index, funcBtnType)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if nil == index or nil == funcBtnType then
    return
  end
  self._funcBtnList[index]:ChangeTextureInfoName(self._funcBtnTexturePath)
  self._funcBtnList[index]:ChangeOnTextureInfoName(self._funcBtnTexturePath)
  self._funcBtnList[index]:ChangeClickTextureInfoName(self._funcBtnTexturePath)
  local x1, y1, x2, y2 = setTextureUV_Func(self._funcBtnList[index], self._funcBtnTextureUV[funcBtnType].base.x1, self._funcBtnTextureUV[funcBtnType].base.y1, self._funcBtnTextureUV[funcBtnType].base.x2, self._funcBtnTextureUV[funcBtnType].base.y2)
  self._funcBtnList[index]:getBaseTexture():setUV(x1, y1, x2, y2)
  x1, y1, x2, y2 = setTextureUV_Func(self._funcBtnList[index], self._funcBtnTextureUV[funcBtnType].on.x1, self._funcBtnTextureUV[funcBtnType].on.y1, self._funcBtnTextureUV[funcBtnType].on.x2, self._funcBtnTextureUV[funcBtnType].on.y2)
  self._funcBtnList[index]:getOnTexture():setUV(x1, y1, x2, y2)
  x1, y1, x2, y2 = setTextureUV_Func(self._funcBtnList[index], self._funcBtnTextureUV[funcBtnType].click.x1, self._funcBtnTextureUV[funcBtnType].click.y1, self._funcBtnTextureUV[funcBtnType].click.x2, self._funcBtnTextureUV[funcBtnType].click.y2)
  self._funcBtnList[index]:getClickTexture():setUV(x1, y1, x2, y2)
  self._funcBtnList[index]:setRenderTexture(self._funcBtnList[index]:getBaseTexture())
end
function PaGlobal_DialogMain_All:funcBottomBtnClick(index)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local dialogFuncCnt = dialogData:getFuncButtonCount()
  if dialogFuncCnt <= 0 then
    return
  end
  local funcButton = dialogData:getFuncButtonAt(index)
  if nil == funcButton then
    return
  end
  local funcButtonType = tonumber(funcButton._param)
  Dialog_clickFuncButtonReq(index)
  self._selectDialogFuncIndex = index
  self:buttonColorSetting(index)
  self:buttonFuncBranch(funcButtonType)
end
function PaGlobal_DialogMain_All:buttonColorSetting(clickIndex)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local funcBtnCount = dialogData:getFuncButtonCount()
  for index = 0, funcBtnCount - 1 do
    self._funcBtnList[index]:SetCheck(false)
    self._funcBtnList[index]:setRenderTexture(self._funcBtnList[index]:getBaseTexture())
    self._funcBtnList[index]:SetFontColor(Defines.Color.C_FF988D83)
  end
  if nil == clickIndex then
    return
  end
  self._funcBtnList[clickIndex]:SetCheck(true)
  self._funcBtnList[clickIndex]:setRenderTexture(self._funcBtnList[clickIndex]:getClickTexture())
  self._funcBtnList[clickIndex]:SetFontColor(Defines.Color.C_FFFFEDD4)
end
function PaGlobal_DialogMain_All:buttonFuncBranch(funcButtonType)
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local count = 0
  if CppEnums.ContentsType.Contents_Quest == funcButtonType or CppEnums.ContentsType.Contents_NewQuest == funcButtonType then
    local talker = dialog_getTalker()
    if nil == talker then
      dialogData:setEmptyMainDialog()
      PaGlobalFunc_DialogList_All_SetFilterButtonCount()
      PaGlobalFunc_DialogList_All_SetFilterOption(1)
    end
  end
  if CppEnums.ContentsType.Contents_Quest ~= funcButtonType and CppEnums.ContentsType.Contents_NewQuest ~= funcButtonType and CppEnums.ContentsType.Contents_HelpDesk ~= funcButtonType then
    PaGlobalFunc_DialogMain_All_SubPanelSetShow(false)
  else
    PaGlobalFunc_InterestKnowledge_All_Close()
    PaGlobalFunc_DialogIntimacy_All_Close()
  end
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    local shopType = dialogData:getShopType()
    local isMessageBox = self:shopTypeMessage(shopType)
    if true == isMessageBox then
      return
    end
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
    count = 2
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      count = 1
      targetWindowList = {Panel_Window_Skill}
    end
  elseif CppEnums.ContentsType.Contents_Auction == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Inn == funcButtonType then
  elseif CppEnums.ContentsType.Contents_IntimacyGame == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    count = 1
    targetWindowList = {Panel_Window_DeliveryForPerson}
  elseif CppEnums.ContentsType.Contents_Guild == funcButtonType then
    if false == _ContentsGroup_NewUI_CreateClan_All then
      FGlobal_GuildCreateManagerPopup()
    else
      PaGlobal_CreateClan_All_Open()
    end
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Enchant == funcButtonType then
    PaGlobal_Enchant:enchant_Show()
  elseif CppEnums.ContentsType.Contents_Socket == funcButtonType then
    Socket_Window_Show()
  elseif CppEnums.ContentsType.Contents_LordMenu == funcButtonType then
    LordMenu_Show()
  elseif CppEnums.ContentsType.Contents_Extract == funcButtonType then
    if nil ~= Panel_Window_Extraction then
      if false == Panel_Window_Extraction:GetShow() then
        PaGlobal_Extraction:openPanel(true)
      else
        PaGlobal_Extraction:openPanel(false)
      end
    end
  elseif CppEnums.ContentsType.Contents_TerritoryTrade == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_TerritorySupply == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    count = 2
    if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= Panel_Dialog_NPCShop_All then
      targetWindowList = {Panel_Dialog_NPCShop_All, Panel_Window_Inventory}
    else
      targetWindowList = {Panel_Window_NpcShop, Panel_Window_Inventory}
    end
  elseif CppEnums.ContentsType.Contents_SupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_FishSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_GuildSupplyShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_MinorLordMenu == funcButtonType then
    FGlobal_NodeWarMenuOpen()
  elseif CppEnums.ContentsType.Contents_Improve == funcButtonType then
    Panel_Improvement_Show()
  end
  self:innerPanelShow(count, targetWindowList)
  if CppEnums.ContentsType.Contents_Shop == funcButtonType then
    npcShop_requestList(funcButtonType)
    FGlobal_NodeWarMenuClose()
  elseif CppEnums.ContentsType.Contents_Skill == funcButtonType then
    if false == _ContentsGroup_RenewUI_Skill then
      HandleMLUp_SkillWindow_OpenForLearn()
    else
      PaGlobalFunc_Skill_Open()
    end
  elseif CppEnums.ContentsType.Contents_Repair == funcButtonType then
    if true == _ContentsGroup_RenewUI_Repair then
      PaGlobalFunc_RepairInfo_Open()
    else
      PaGlobal_Repair:repair_OpenPanel(true)
    end
  elseif CppEnums.ContentsType.Contents_Warehouse == funcButtonType then
    Warehouse_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Stable == funcButtonType then
    if isGuildStable() then
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        GuildStableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        GuildWharfFunction_Open()
      end
    else
      warehouse_requestInfoFromNpc()
      if CppEnums.ServantType.Type_Vehicle == stable_getServantType() then
        StableFunction_Open()
      elseif CppEnums.ServantType.Type_Ship == stable_getServantType() then
        WharfFunction_Open()
      else
        PetFunction_Open()
        PetList_Open()
      end
    end
    show_DialogPanel()
  elseif CppEnums.ContentsType.Contents_Transfer == funcButtonType then
    DeliveryInformation_OpenPanelFromDialog()
  elseif CppEnums.ContentsType.Contents_Explore == funcButtonType then
  elseif CppEnums.ContentsType.Contents_DeliveryPerson == funcButtonType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_ReMake"))
  elseif CppEnums.ContentsType.Contents_GuildShop == funcButtonType then
    npcShop_requestList(funcButtonType)
  elseif CppEnums.ContentsType.Contents_ItemMarket == funcButtonType then
    if PaGlobalFunc_ItemMarket_IsUISubApp() then
      Panel_Window_ItemMarket:CloseUISubApp()
      Panel_Window_ItemMarket:SetShow(false)
    end
    if not PaGlobalFunc_ItemMarket_GetShow() then
      FGolbal_ItemMarket_Function_Open()
    else
      FGolbal_ItemMarket_Function_Close()
    end
  elseif CppEnums.ContentsType.Contents_NewItemMarket == funcButtonType then
    if not PaGlobalFunc_MarketPlace_GetShow() then
      PaGlobalFunc_MarketPlace_OpenFromDialog()
    else
      PaGlobalFunc_MarketPlace_CloseToDialog()
    end
  elseif CppEnums.ContentsType.Contents_Knowledge == funcButtonType then
    FGlobal_KnowledgeManagementShow()
  elseif CppEnums.ContentsType.Contents_Join == funcButtonType then
    Panel_Join_Show()
  elseif CppEnums.ContentsType.Contents_NpcGift == funcButtonType then
    FGlobal_NpcGift_Open()
    PaGlobalFunc_DialogIntimacy_All_Open()
  elseif CppEnums.ContentsType.Contents_WeakenEnchant == funcButtonType then
    if true == _ContentsGroup_NewUI_Purification_All and nil ~= Panel_Purification_All then
      PaGlobalFunc_Purification_All_Open()
    elseif nil ~= Panel_Purification then
      PuriManager:Open()
    end
  elseif CppEnums.ContentsType.Contents_DiceGame == funcButtonType then
  elseif CppEnums.ContentsType.Contents_Barter == funcButtonType then
    if true == _ContentsGroup_OceanCurrent then
      local talker = dialog_getTalker()
      if nil ~= talker then
        local charSSW = getCharacterStaticStatusWarpper(talker:getCharacterKey())
        if nil ~= charSSW then
          PaGlobal_Barter:setWhereType(CppEnums.ItemWhereType.eInventory)
          PaGlobal_Barter_Open(talker:getActorKey(), charSSW:getBarterRegionKey())
        end
      end
    end
  elseif CppEnums.ContentsType.Contents_EmploySailor == funcButtonType then
    local talker = dialog_getTalker()
    if nil ~= talker then
      local charSSW = getCharacterStaticStatusWarpper(talker:getCharacterKey())
      if nil ~= charSSW then
        local actorKeyRaw = talker:getActorKey()
        local sailorKey = charSSW:getSailorKey()
        local sailorSSW = ToClient_GetSailorWrapper(sailorKey)
        local needItemKey = sailorSSW:getNeedItemKey()
        local slotNo = ToClient_InventoryGetSlotNo(needItemKey)
        ToClient_BuySailor(actorKeyRaw, sailorKey, slotNo)
      end
    end
  end
end
function PaGlobal_DialogMain_All:shopTypeMessage(shopType)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myWp = selfPlayer:getWp()
  local myinventory = selfPlayer:get():getInventory()
  local myinvenSize = myinventory:getFreeCount()
  local s64_allWeight = Int64toInt32(selfPlayer:get():getCurrentWeight_s64())
  local s64_maxWeight = Int64toInt32(selfPlayer:get():getPossessableWeight_s64())
  if self._shopType.eShopType_Worker == shopType then
    self._indexWorkerShopClicked = index
    local selfPosition = selfPlayer:get():getPosition()
    local regionInfo = getRegionInfoByPosition(selfPosition)
    local region = regionInfo:get()
    local regionPlantKey = regionInfo:getPlantKeyByWaypointKey()
    local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(regionPlantKey, 0)
    local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(regionPlantKey)
    if s64_allWeight >= s64_maxWeight then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTTITLE"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_WEIGHTOVER_ALERTDESC"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    if 0 ~= selfPlayer:get():checkWorkerWorkingServerNo() then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ_NotSameServerNo"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    if waitWorkerCount == maxWorkerCount then
      local buyCash = function()
        PaGlobal_EasyBuy:Open(16, getCurrentWaypointKey())
      end
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_ReSelect"),
        content = PAGetString(Defines.StringSheet_GAME, "Lua_WorkerShop_Cant_Employ") .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_WORKERHOUSE_EASYBUY"),
        functionYes = buyCash,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    if myWp >= 5 then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_WORKER", "MyWp", myWp),
        functionYes = PaGlobalFunc_DialogMain_All_RandomWorkerSelectUseMyWpConfirm,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
  end
  if self._shopType.eShopType_RandomShop == shopType then
    if myinvenSize <= 0 then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    if s64_allWeight >= s64_maxWeight then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    local IsRamdomShopkeepItem = ToClient_IsRandomShopKeepItem()
    if IsRamdomShopkeepItem == false then
      local randomShopConsumeWp = ToClient_getRandomShopConsumWp()
      if myWp < randomShopConsumeWp then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_LACK_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", myWp),
          functionApply = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return true
      elseif myWp >= randomShopConsumeWp then
        local messageboxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_CONFIRM_RANDOMITEM_WP", "randomShopConsumeWp", randomShopConsumeWp, "MyWp", myWp),
          functionYes = PaGlobalFunc_DialogMain_All_RandomWorkerSelectUseMyWpConfirm,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return true
      end
    end
  end
  if self._shopType.eShopType_DayRandomShop == shopType then
    if myinvenSize <= 0 then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_FREESLOT"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
    if s64_allWeight >= s64_maxWeight then
      local messageboxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_MAIN_SECRETSHOP_WEIGHTOVER"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
      return true
    end
  end
  return false
end
function PaGlobal_DialogMain_All:innerPanelShow(count, targetWindowList)
  if nil == Panel_Npc_Dialog_All then
    return
  end
  if count <= 0 then
    return
  end
  dialog_setPositionSelectList(count)
  local index = 0
  for _, v in pairs(targetWindowList) do
    dialog_setPositionSelectSizeSet(index, v:GetSizeX(), v:GetSizeY())
    index = index + 1
  end
  dialog_calcPositionSelectList()
  index = 0
  for _, v in pairs(targetWindowList) do
    if false == v:GetShow() then
      local pos = dialog_PositionSelect(index)
      if 0 ~= pos.x or 0 ~= pos.y then
        v:ComputePos()
        v:SetPosX(pos.x)
        v:SetPosY(pos.y)
        index = index + 1
      else
        break
      end
    end
  end
end
function PaGlobal_DialogMain_All:executeAfterDialogLoad(dialogData)
  if nil == dialogData then
    return
  end
  if false == dialogData:isHaveQuest() then
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Enchant = 0
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Socket = 1
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Improve = 2
  else
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Enchant = 1
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Socket = 2
    self._blackSpiritButtonPos.eBlackSpiritButtonType_Improve = 3
  end
  local blackSpiritUiType = getBlackSpiritUiType()
  if CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_None ~= blackSpiritUiType and true == ToClient_IsGrowStepOpen(__eGrowStep_enchant) then
    if CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_ItemEnchant == blackSpiritUiType then
      HandleEventLUp_DialogMain_All_FuncButton(self._blackSpiritButtonPos.eBlackSpiritButtonType_Enchant)
    elseif CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Socket == blackSpiritUiType then
      HandleEventLUp_DialogMain_All_FuncButton(self._blackSpiritButtonPos.eBlackSpiritButtonType_Socket)
    elseif CppEnums.EFlush_BlackSpirit_Ui_Type.eFlush_BlackSpirit_Ui_Improve == blackSpiritUiType then
      HandleEventLUp_DialogMain_All_FuncButton(self._blackSpiritButtonPos.eBlackSpiritButtonType_Improve)
    end
  end
end
