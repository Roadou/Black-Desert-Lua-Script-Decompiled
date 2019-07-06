local IM = CppEnums.EProcessorInputMode
local VCK = CppEnums.VirtualKeyCode
local UIMode = Defines.UIMode
function Process_UIMode_CommonWindow_MentalKnowledge()
  if GlobalValue_MiniGame_Value_HorseDrop == true then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMING_DO_NOT_USE"))
    return
  end
  if false == _ContentsGroup_RenewUI_Knowledge then
    Panel_Knowledge_Show()
  elseif PaGlobalFunc_Window_Knowledge_GetShow() then
    PaGlobalFunc_Window_Knowledge_Exit()
  else
    PaGlobalFunc_Window_Knowledge_Show()
  end
end
function Process_UIMode_CommonWindow_PositionNotify(fastPinDelta)
  local targetPosition = crossHair_GetTargetPosition()
  if true == ToClient_IsViewSelfPlayer(targetPosition) then
    if fastPinDelta < 0.5 then
      ToClient_RequestSendPositionGuide(false, true, false, targetPosition)
      fastPinDelta = 10
    else
      ToClient_RequestSendPositionGuide(false, false, false, targetPosition)
      fastPinDelta = 0
    end
  end
end
function Process_UIMode_CommonWindow_CashShop()
  if getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_Commercial or isGameTypeTaiwan() then
    if PaGlobal_TutorialManager:isDoingTutorial() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
      return
    end
    InGameShop_Open()
  end
end
function Process_UIMode_CommonWindow_BlackSpirit()
  if true == Panel_Window_Exchange:GetShow() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() and false == PaGlobal_TutorialManager:isAllowCallBlackSpirit() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  FGlobal_TentTooltipHide()
  ToClient_AddBlackSpiritFlush()
end
function Process_UIMode_CommonWindow_Chatting()
  if true == _ContentsGroup_RenewUI_Chatting then
    PaGlobalFunc_ChattingInfo_Open()
  else
    ChatInput_Show()
  end
end
function Process_UIMode_CommonWindow_ProductionNote()
  if nil ~= Panel_ProductNote and not Panel_ProductNote:IsUISubApp() then
    Panel_ProductNote_ShowToggle()
  end
end
function Process_UIMode_CommonWindow_PlayerInfo()
  if true == _ContentsGroup_RenewUI then
    if Panel_Window_CharacterInfo_Renew ~= nil then
      if Panel_Window_CharacterInfo_Renew:GetShow() and not Panel_Window_CharacterInfo_Renew:IsUISubApp() then
        audioPostEvent_SystemUi(1, 31)
        _AudioPostEvent_SystemUiForXBOX(1, 31)
        PaGlobalFunc_Window_CharacterInfo_Close()
      else
        if false == _ContentsGroup_RenewUI_StableInfo then
          if Panel_Window_ServantInfo:GetShow() or Panel_CarriageInfo:GetShow() or Panel_ShipInfo:GetShow() then
            ServantInfo_Close()
            CarriageInfo_Close()
            ShipInfo_Close()
            Panel_Tooltip_Item_hideTooltip()
            TooltipSimple_Hide()
            return
          end
        elseif true == PaGlobalFunc_ServantInfo_GetShow() then
          PaGlobalFunc_ServantInfo_Exit()
          TooltipSimple_Hide()
          return
        end
        PaGlobalFunc_Window_CharacterInfo_Open()
      end
    end
  elseif Panel_Window_CharInfo_Status ~= nil then
    if Panel_Window_CharInfo_Status:GetShow() and not Panel_Window_CharInfo_Status:IsUISubApp() then
      audioPostEvent_SystemUi(1, 31)
      _AudioPostEvent_SystemUiForXBOX(1, 31)
      if _ContentsGroup_isUsedNewCharacterInfo == false then
        CharacterInfoWindow_Hide()
      else
        PaGlobal_CharacterInfo:hideWindow()
      end
    else
      if Panel_Window_ServantInfo:GetShow() or Panel_CarriageInfo:GetShow() or Panel_ShipInfo:GetShow() then
        ServantInfo_Close()
        CarriageInfo_Close()
        ShipInfo_Close()
        Panel_Tooltip_Item_hideTooltip()
        TooltipSimple_Hide()
        return
      end
      if _ContentsGroup_isUsedNewCharacterInfo == false then
        CharacterInfoWindow_Show()
      else
        PaGlobal_CharacterInfo:showWindow(0)
      end
    end
  end
  local selfPlayer = getSelfPlayer()
  local selfProxy = selfPlayer:get()
  if nil ~= selfProxy then
    local actorKeyRaw = selfProxy:getRideVehicleActorKeyRaw()
    local temporaryWrapper = getTemporaryInformationWrapper()
    local unsealCacheData = getServantInfoFromActorKey(actorKeyRaw)
    if nil ~= unsealCacheData then
      local inventory = unsealCacheData:getInventory()
      local invenSize = inventory:size()
      if 0 ~= actorKeyRaw then
        if true == ToClient_isConsole() then
          return
        end
        if Panel_Window_ServantInfo:GetShow() or Panel_CarriageInfo:GetShow() or Panel_ShipInfo:GetShow() then
          ServantInfo_Close()
          CarriageInfo_Close()
          ShipInfo_Close()
          Panel_Tooltip_Item_hideTooltip()
          TooltipSimple_Hide()
        else
          requestInformationFromServant()
          ServantInfo_BeforOpenByActorKeyRaw(actorKeyRaw)
        end
      end
    end
  end
end
function Process_UIMode_CommonWindow_Skill()
  if false == _ContentsGroup_RenewUI then
    if nil ~= Instance_Window_Skill then
      if true == Instance_Window_Skill:IsShow() then
        audioPostEvent_SystemUi(1, 17)
        _AudioPostEvent_SystemUiForXBOX(1, 17)
        HandleMLUp_SkillWindow_Close()
      else
        audioPostEvent_SystemUi(1, 18)
        PaGlobal_Skill:SkillWindow_Show()
      end
    end
  elseif true == PaGlobalFunc_Skill_GetShow() then
    audioPostEvent_SystemUi(1, 17)
    _AudioPostEvent_SystemUiForXBOX(1, 17)
    PaGlobalFunc_Skill_Close()
  else
    audioPostEvent_SystemUi(1, 18)
    _AudioPostEvent_SystemUiForXBOX(1, 18)
    PaGlobalFunc_Skill_Open()
  end
end
function Process_UIMode_CommonWindow_PossessionByBlackSpirit()
  if PaGlobal_AutoManager._ActiveState then
    FGlobal_MouseclickTest()
  end
end
function Process_UIMode_CommonWindow_Inventory()
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and CppEnums.ClassType.ClassType_Temp1 == selfPlayer:getClassType() then
    return
  end
  if true == _ContentsGroup_RenewUI_Inventory then
    if false == PaGlobalFunc_InventoryInfo_GetShow() then
      PaGlobalFunc_InventoryInfo_Open(1)
    else
      PaGlobalFunc_InventoryInfo_Close()
    end
  else
    local isInvenOpen = Instance_Window_Inventory:IsShow()
    local isEquipOpen = Instance_Window_Equipment:IsShow()
    local temporaryWrapper = getTemporaryInformationWrapper()
    local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
    local servantShipInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Ship)
    if isInvenOpen == false and isEquipOpen == false then
      if isEquipOpen == false then
        Equipment_SetShow(true)
      end
      audioPostEvent_SystemUi(1, 16)
      _AudioPostEvent_SystemUiForXBOX(1, 16)
      InventoryWindow_Show(true)
    else
      if Instance_Window_Inventory:IsUISubApp() and isEquipOpen == false then
        Equipment_SetShow(true)
      else
        Equipment_SetShow(false)
      end
      audioPostEvent_SystemUi(1, 15)
      _AudioPostEvent_SystemUiForXBOX(1, 15)
      InventoryWindow_Close()
      TooltipSimple_Hide()
    end
  end
end
function Process_UIMode_CommonWindow_Dyeing()
  if PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  if MiniGame_Manual_Value_FishingStart == true then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_FISHING_ACK"))
    return
  elseif true == _ContentsGroup_RenewUI_Dyeing then
    audioPostEvent_SystemUi(1, 24)
    _AudioPostEvent_SystemUiForXBOX(1, 24)
    PaGlobalFunc_Dyeing_Open()
  elseif not Panel_Dye_ReNew:GetShow() then
    audioPostEvent_SystemUi(1, 24)
    _AudioPostEvent_SystemUiForXBOX(1, 24)
    FGlobal_Panel_Dye_ReNew_Open()
  end
end
function Process_UIMode_CommonWindow_Present()
  if nil == Panel_Window_CharInfo_Status then
    return
  end
  if not Panel_Window_CharInfo_Status:GetShow() then
    audioPostEvent_SystemUi(1, 34)
    _AudioPostEvent_SystemUiForXBOX(1, 34)
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      FGlobal_Challenge_Show()
    else
      PaGlobal_CharacterInfo:showWindow(3)
      FGlobal_TapButton_Complete()
    end
  else
    audioPostEvent_SystemUi(1, 31)
    _AudioPostEvent_SystemUiForXBOX(1, 31)
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      FGlobal_Challenge_Hide()
    else
      PaGlobal_CharacterInfo:hideWindow()
    end
  end
end
function Process_UIMode_CommonWindow_Manufacture()
  if MiniGame_Manual_Value_FishingStart == true then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_FISHING_ACK"))
    return
  elseif 0 ~= ToClient_GetMyTeamNoLocalWar() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_LOCALWAR_ALERT"))
    return
  elseif true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  else
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_MANUFACTURE"))
      return
    end
    if _ContentsGroup_RenewUI_Manufacture then
      if not PaGlobalFunc_ManufactureCheckShow() then
        audioPostEvent_SystemUi(1, 26)
        _AudioPostEvent_SystemUiForXBOX(1, 26)
        PaGlobalFunc_ManufactureOpen(true)
      else
        audioPostEvent_SystemUi(1, 25)
        _AudioPostEvent_SystemUiForXBOX(1, 25)
        PaGlobalFunc_ManufactureClose()
      end
    elseif Panel_Manufacture ~= nil and Instance_Window_Inventory ~= nil then
      local isInvenOpen = Instance_Window_Inventory:GetShow()
      local isManufactureOpen = Panel_Manufacture:GetShow()
      if isManufactureOpen == false or isInvenOpen == false then
        audioPostEvent_SystemUi(1, 26)
        _AudioPostEvent_SystemUiForXBOX(1, 26)
        Manufacture_Show(nil, CppEnums.ItemWhereType.eInventory, true)
      else
        audioPostEvent_SystemUi(1, 25)
        _AudioPostEvent_SystemUiForXBOX(1, 25)
        if not _ContentsGroup_RenewUI_Manufacture then
          Manufacture_Close()
        end
      end
    end
  end
end
function Process_UIMode_CommonWindow_Guild()
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if false == _ContentsGroup_RenewUI_Guild then
    if nil ~= guildWrapper then
      local guildGrade = guildWrapper:getGuildGrade()
      if 0 == guildGrade then
        if false == Panel_ClanList:IsShow() then
          audioPostEvent_SystemUi(1, 36)
          _AudioPostEvent_SystemUiForXBOX(1, 36)
          FGlobal_ClanList_Open()
        else
          audioPostEvent_SystemUi(1, 31)
          _AudioPostEvent_SystemUiForXBOX(1, 31)
          FGlobal_ClanList_Close()
        end
      else
        local isPanelGuildShow = false
        if nil == PaGlobal_GuildPanelLoad_GetShowPanelGuildMain then
          isPanelGuildShow = Panel_Window_Guild:IsShow()
        else
          isPanelGuildShow = PaGlobal_GuildPanelLoad_GetShowPanelGuildMain()
        end
        if false == isPanelGuildShow then
          audioPostEvent_SystemUi(1, 36)
          _AudioPostEvent_SystemUiForXBOX(1, 36)
          GuildManager:Show()
        else
          audioPostEvent_SystemUi(1, 31)
          _AudioPostEvent_SystemUiForXBOX(1, 31)
          GuildManager:Hide()
        end
      end
    elseif false == _ContentsGroup_RenewUI then
      PaGlobal_GuildNonJoinMember_SetShow(true)
    end
  elseif nil ~= guildWrapper then
    local guildGrade = guildWrapper:getGuildGrade()
    if 0 == guildGrade then
      if false == Panel_ClanList:IsShow() then
        audioPostEvent_SystemUi(1, 36)
        _AudioPostEvent_SystemUiForXBOX(1, 36)
        FGlobal_ClanList_Open()
      else
        audioPostEvent_SystemUi(1, 31)
        _AudioPostEvent_SystemUiForXBOX(1, 31)
        FGlobal_ClanList_Close()
      end
    elseif false == PaGlobalFunc_GuildMain_GetShow() then
      audioPostEvent_SystemUi(1, 36)
      _AudioPostEvent_SystemUiForXBOX(1, 36)
      PaGlobalFunc_GuildMain_Open()
    else
      audioPostEvent_SystemUi(1, 31)
      _AudioPostEvent_SystemUiForXBOX(1, 31)
      PaGlobalFunc_GuildMain_Close()
    end
  else
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NO_GUILD"),
      functionYes = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function Process_UIMode_CommonWindow_Mail()
  if Panel_Mail_Main ~= nil and Panel_Mail_Detail ~= nil then
    local isMailMain = Panel_Mail_Main:IsShow()
    if isMailMain == false then
      audioPostEvent_SystemUi(1, 22)
      _AudioPostEvent_SystemUiForXBOX(1, 22)
      Mail_Open()
    else
      audioPostEvent_SystemUi(1, 21)
      _AudioPostEvent_SystemUiForXBOX(1, 22)
      Mail_Close()
    end
  elseif Panel_Window_Mail_Renew ~= nil and Panel_Window_MailDetail_Renew ~= nil then
    local isMailMain = Panel_Window_Mail_Renew:IsShow()
    if isMailMain == false then
      audioPostEvent_SystemUi(1, 22)
      _AudioPostEvent_SystemUiForXBOX(1, 22)
      Mail_Open()
    else
      audioPostEvent_SystemUi(1, 21)
      _AudioPostEvent_SystemUiForXBOX(1, 21)
      Mail_Close()
    end
  end
end
function Process_UIMode_CommonWindow_FriendList()
  if Panel_FriendList ~= nil then
    local isFriendList = Panel_FriendList:IsShow()
    if isFriendList == false then
      FriendList_show()
      audioPostEvent_SystemUi(1, 28)
      _AudioPostEvent_SystemUiForXBOX(1, 28)
    else
      FriendList_hide()
      audioPostEvent_SystemUi(1, 27)
      _AudioPostEvent_SystemUiForXBOX(1, 27)
    end
  end
  if true == _ContentsGroup_NewUI_Friend_All and Panel_FriendList_All ~= nil then
    local isFriendList = Panel_FriendList_All:IsShow()
    if isFriendList == false then
      PaGlobal_FriendList_Show_All()
      audioPostEvent_SystemUi(1, 28)
      _AudioPostEvent_SystemUiForXBOX(1, 28)
    else
      PaGlobal_FriendList_Hide_All()
      audioPostEvent_SystemUi(1, 27)
      _AudioPostEvent_SystemUiForXBOX(1, 27)
    end
  end
end
function Process_UIMode_CommonWindow_QuestHistory()
  if false == _ContentsGroup_RenewUI then
    if Panel_Window_Quest_New:GetShow() then
      audioPostEvent_SystemUi(1, 27)
      _AudioPostEvent_SystemUiForXBOX(1, 27)
      Panel_Window_QuestNew_Show(false)
    else
      audioPostEvent_SystemUi(1, 29)
      _AudioPostEvent_SystemUiForXBOX(1, 29)
      Panel_Window_QuestNew_Show(true)
    end
  elseif true == PaGlobalFunc_Quest_GetShow() then
    audioPostEvent_SystemUi(1, 27)
    _AudioPostEvent_SystemUiForXBOX(1, 27)
    PaGlobalFunc_Quest_SetShow(false)
  else
    audioPostEvent_SystemUi(1, 27)
    _AudioPostEvent_SystemUiForXBOX(1, 27)
    PaGlobalFunc_Quest_SetShow(true)
  end
  TooltipSimple_Hide()
end
function Process_UIMode_CommonWindow_BeautyShop()
  if false == _ContentsGroup_RenewUI_Customization then
    if not isKeyPressed(VCK.KeyCode_MENU) then
      if PaGlobal_TutorialManager:isDoingTutorial() then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
        return
      end
      if not getCustomizingManager():isShow() then
        IngameCustomize_Show()
        return
      end
    end
  elseif not isKeyPressed(VCK.KeyCode_MENU) then
    if PaGlobal_TutorialManager:isDoingTutorial() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
      return
    end
    if false == PaGlobalFunc_Customization_GetShow() then
      IngameCustomize_Show()
    end
  end
end
function Process_UIMode_CommonWindow_WorldMap()
  if not Panel_Global_Manual:GetShow() or FGlobal_BulletCount_UiShowCheck() then
    if true == _ContentsGroup_RenewUI_WorldMap then
      PaGlobalFunc_WorldMap_Open()
    else
      FGlobal_PushOpenWorldMap()
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_MINIGAMING_NOT_WORLDMAP"))
    return
  end
end
function Process_UIMode_CommonWindow_House()
  if Panel_HousingList:GetShow() then
    HousingList_Close()
  else
    FGlobal_HousingList_Open()
  end
end
function Process_UIMode_CommonWindow_Maid()
  if Panel_Window_MaidList:GetShow() then
    MaidList_Close()
  else
    MaidList_Open()
  end
end
function Process_UIMode_CommonWindow_DeleteNavigation()
  if getSelfPlayer():get():getLevel() < 11 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK"))
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  Panel_NaviButton:SetShow(false)
  audioPostEvent_SystemUi(0, 15)
  _AudioPostEvent_SystemUiForXBOX(0, 15)
end
function Process_UIMode_CommonWindow_PartySetting()
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  audioPostEvent_SystemUi(0, 16)
  _AudioPostEvent_SystemUiForXBOX(0, 16)
  PaGlobalFunc_PartySetting_Show()
end
