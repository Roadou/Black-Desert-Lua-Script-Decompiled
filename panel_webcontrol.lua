local PA_UI = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_WebControl:RegisterShowEventFunc(true, "Panel_WebHelper_ShowAni()")
Panel_WebControl:RegisterShowEventFunc(false, "Panel_WebHelper_HideAni()")
Panel_WebControl:setGlassBackground(true)
Panel_WebControl:ActiveMouseEventEffect(true)
local html_WebHelper_Control = UI.createControl(PA_UI.PA_UI_CONTROL_WEBCONTROL, Panel_WebControl, "WebControl_Help_CharInfo")
local ui = {
  _btn_Close = UI.getChildControl(Panel_WebControl, "Button_Close"),
  _btn_CloseWin = UI.getChildControl(Panel_WebControl, "Button_CloseWindow"),
  _edit_Question = UI.getChildControl(Panel_WebControl, "Edit_InputQuestion"),
  _btn_Search = UI.getChildControl(Panel_WebControl, "Button_Search"),
  _btn_KeyHelp = UI.getChildControl(Panel_WebControl, "Button_KeyboardHelp"),
  _btn_ProductNote = UI.getChildControl(Panel_WebControl, "Button_ProductNote")
}
ui._btn_Close:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle()")
ui._btn_CloseWin:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle()")
function Panel_WebHelper_ShowToggle(helpType)
  if true == ToClient_isConsole() then
    return
  end
  if isDeadInWatchingMode() then
    return
  end
  if ToClient_IsConferenceMode() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_MSGBOX_COMMON_READY"),
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if Panel_WebControl:IsShow() then
    Panel_WebControl:SetShow(false, true)
    html_WebHelper_Control:ResetUrl()
    return false
  else
    if (isGameTypeJapan() or isGameTypeRussia()) and getContentsServiceType() == CppEnums.ContentsServiceType.eContentsServiceType_CBT then
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_MSGBOX_COMMON_READY"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return false
    end
    if isGameTypeGT() then
      local messageBoxData = {
        title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
        content = PAGetString(Defines.StringSheet_GAME, "LUA_MSGBOX_COMMON_READY"),
        functionApply = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData)
      return false
    end
    if isGameTypeKR2() then
      return false
    end
    if nil == Panel_Login then
      if Panel_WorldMap:GetShow() then
        WorldMapPopupManager:push(Panel_WebControl, true)
      else
        Panel_WebControl:SetShow(true, true)
      end
    else
      Panel_WebControl:SetShow(true, true)
    end
    Panel_WebControl_TakeAndShow(helpType)
    return true
  end
end
function FGlobal_WebHelper_ForceClose()
  if Panel_WebControl:IsShow() then
    Panel_WebControl:SetShow(false, true)
    html_WebHelper_Control:ResetUrl()
    return
  end
end
function FGlobal_Panel_WebHelper_ShowToggle()
  if true == ToClient_SniperGame_IsPlaying() then
    return
  end
  Panel_WebHelper_ShowToggle("GUIDE")
end
function Panel_WebHelper_ShowAni()
  UIAni.fadeInSCR_Down(Panel_WebControl)
  local aniInfo1 = Panel_WebControl:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_WebControl:GetSizeX() / 2
  aniInfo1.AxisY = Panel_WebControl:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_WebControl:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_WebControl:GetSizeX() / 2
  aniInfo2.AxisY = Panel_WebControl:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WebHelper_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_WebControl:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, Panel_WebControl, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function Panel_WebControl_Initialize()
  local self = ui
  Panel_WebControl:SetShow(false, false)
  html_WebHelper_Control:SetHorizonCenter()
  html_WebHelper_Control:ResetUrl()
  html_WebHelper_Control:SetSize(956, 600)
  html_WebHelper_Control:SetSpanSize(0, 35)
  html_WebHelper_Control:SetShow(false)
  local btnHelpSizeX = self._btn_KeyHelp:GetSizeX() + 23
  local btnHelpTextPosX = btnHelpSizeX - btnHelpSizeX / 2 - self._btn_KeyHelp:GetTextSizeX() / 2
  self._btn_KeyHelp:SetTextSpan(btnHelpTextPosX, 5)
  self._btn_KeyHelp:addInputEvent("Mouse_LUp", "FGlobal_KeyboardHelpShow()")
  local btnProductSizeX = self._btn_ProductNote:GetSizeX() + 23
  local btnProductTextPosX = btnProductSizeX - btnProductSizeX / 2 - self._btn_ProductNote:GetTextSizeX() / 2
  self._btn_ProductNote:SetTextSpan(btnProductTextPosX, 5)
  self._btn_ProductNote:addInputEvent("Mouse_LUp", "Panel_ProductNote_ShowToggle()")
end
local countryType = ""
local isIME = false
if isGameTypeTaiwan() then
  countryType = "_TW"
  isIME = true
elseif isGameTypeTR() then
  countryType = "_TR"
  isIME = true
elseif isGameTypeTH() then
  countryType = "_TH"
  isIME = true
elseif isGameTypeID() then
  countryType = "_ID"
  isIME = true
elseif isGameTypeSA() then
  if CppEnums.ServiceResourceType.eServiceResourceType_SA == getGameServiceResType() then
    countryType = "_SA"
  elseif CppEnums.ServiceResourceType.eServiceResourceType_PT == getGameServiceResType() then
    countryType = "_PT"
  end
elseif isGameTypeRussia() then
  countryType = "_RU"
end
function Panel_WebControl_TakeAndShow(helpType)
  if true == ToClient_isConsole() then
    return
  end
  Panel_WebControl:SetShow(true, true)
  html_WebHelper_Control:SetHorizonCenter()
  if helpType == "GUIDE" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GUIDE" .. countryType))
  elseif helpType == "SelfCharacterInfo" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_SELFCHARACTERINFO" .. countryType))
  elseif helpType == "PanelImportantKnowledge" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_PANELIMPORTANTKNOWLEDGE" .. countryType))
  elseif helpType == "PanelWindowEquipment" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_WINDOWEQUIPMENT" .. countryType))
  elseif helpType == "PanelGameExit" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_GAMEEXIT" .. countryType))
  elseif helpType == "PanelWindowInventory" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_WINDOWINVENTORY" .. countryType))
  elseif helpType == "UIGameOption" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_GAMEOPTION" .. countryType))
  elseif helpType == "PanelQuestHistory" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_QUESTHISTORY" .. countryType))
  elseif helpType == "PanelQuestReward" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_QUESTREWARD" .. countryType))
  elseif helpType == "PanelFixEquip" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_FIXEQUIP" .. countryType))
  elseif helpType == "NodeMenu" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_NODE" .. countryType))
  elseif helpType == "NpcShop" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_NPCSHOP" .. countryType))
  elseif helpType == "PanelBuyDrink" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_BUYDRINK" .. countryType))
  elseif helpType == "Chatting" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_CHATTING" .. countryType))
  elseif helpType == "KnownIssue" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_KNOWNISSUE" .. countryType))
  elseif helpType == "PanelAlchemy" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_ALCHEMY" .. countryType))
  elseif helpType == "PanelCook" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_COOK" .. countryType))
  elseif helpType == "PanelManufacture" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_MANUFACTURE" .. countryType))
  elseif helpType == "PanelHouseControl" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSECONTROL" .. countryType))
  elseif helpType == "PanelTradeMarketGraph" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TRADEMARKETGRAPH" .. countryType))
  elseif helpType == "TerritoryTrade" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYTRADE" .. countryType))
  elseif helpType == "TerritorySupply" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYSUPPLY" .. countryType))
  elseif helpType == "TerritoryAuth" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_TERRITORYTRADE" .. countryType))
  elseif helpType == "HouseManageWork" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSEMANAGEWORK" .. countryType))
  elseif helpType == "PanelWorldMapTownWorkerManage" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WORLDMAPTOWNWORKERMANAGE" .. countryType))
  elseif helpType == "FarmManageWork" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_FARMMANAGEWORK" .. countryType))
  elseif helpType == "PanelWindowHouse" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WINDOWHOUSE" .. countryType))
  elseif helpType == "PanelWindowTent" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WINDOWTENT" .. countryType))
  elseif helpType == "Gathering" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_GATHERING" .. countryType))
  elseif helpType == "Pet" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_PET" .. countryType))
  elseif helpType == "Dye" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_DYE" .. countryType))
  elseif helpType == "HouseRank" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_HOUSERANK" .. countryType))
  elseif helpType == "Worker" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFE_WORKER" .. countryType))
  elseif helpType == "AlchemyStone" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_ALCHEMYSTONE" .. countryType))
  elseif helpType == "LifeRanking" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_LIFERANKING" .. countryType))
  elseif helpType == "DeliveryPerson" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYPERSON" .. countryType))
  elseif helpType == "PanelServantinfo" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_SERVANTINFO" .. countryType))
  elseif helpType == "PanelServantInventory" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_SERVANTINVENTORY" .. countryType))
  elseif helpType == "PanelWindowStableShop" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMARKET" .. countryType))
  elseif helpType == "PanelWindowStableMarket" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMARKET" .. countryType))
  elseif helpType == "PanelWindowStableMating" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEMATING" .. countryType))
  elseif helpType == "PanelWindowStableRegister" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WINDOWSTABLEREGISTER" .. countryType))
  elseif helpType == "HousingConsignmentSale" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_HOUSINGCONSIGNMENTSALE" .. countryType))
  elseif helpType == "HosingVendingMachine" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_HOUSINGVENDINGMACHINE" .. countryType))
  elseif helpType == "WareHouse" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_WAREHOUSE" .. countryType))
  elseif helpType == "DeliveryInformation" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYINFORMATION" .. countryType))
  elseif helpType == "DeliveryRequest" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_DELIVERYREQUEST" .. countryType))
  elseif helpType == "MyVendorList" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_MYVENDORLIST" .. countryType))
  elseif helpType == "ProductNote" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_PRODUCTNOTE" .. countryType))
  elseif helpType == "ItemMarket" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CONVENI_ITEMMARKET" .. countryType))
  elseif helpType == "ClothExchange" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_CLOTHEXCHANGE" .. countryType))
  elseif helpType == "QuickSlot" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_QUICKSLOT" .. countryType))
  elseif helpType == "SpiritEnchant" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SPIRITENCHANT" .. countryType))
  elseif helpType == "PanelWindowExtractionCrystal" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWEXTRACTIONCRYSTAL" .. countryType))
  elseif helpType == "PanelWindowExtractionEnchantStone" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWEXTRACTIONENCHANTSTONE" .. countryType))
  elseif helpType == "PanelWindowSkill" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WINDOWSKILL" .. countryType))
  elseif helpType == "PanelEnableSkill" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_ENABLESKILL" .. countryType))
  elseif helpType == "PanelSkillAwaken" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SKILLAWAKEN" .. countryType))
  elseif helpType == "Socket" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_SOCKET" .. countryType))
  elseif helpType == "WarInfo" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMBAT_WARINFO" .. countryType))
  elseif helpType == "PanelExchangeWithPC" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_EXCHANGEWITHPC" .. countryType))
  elseif helpType == "PanelFriends" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_FRIENDS" .. countryType))
  elseif helpType == "PanelClan" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_CLAN" .. countryType))
  elseif helpType == "PanelGuild" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_GUILD" .. countryType))
  elseif helpType == "PanelLordMenu" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_LORDMENU" .. countryType))
  elseif helpType == "Panelmail" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_MAIL" .. countryType))
  elseif helpType == "PartyOption" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_PARTYOPTION" .. countryType))
  elseif helpType == "HouseAuction" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_HOUSEAUCTION" .. countryType))
  elseif helpType == "PanelMailSend" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_MAILSEND" .. countryType))
  elseif helpType == "Update" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_UPDATE" .. countryType))
  elseif helpType == "Fairy" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_COMM_FAIRY" .. countryType))
  elseif helpType == "WorldBoss" then
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEINFO_WORLDBOSS" .. countryType))
  elseif helpType == "DeliveryCarriageinformation" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Delivery/WebHelper_Delivery_CarriageInformation.html")
  elseif helpType == "HouseList" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/HouseInfo/WebHelper_HouesList.html")
  elseif helpType == "PanelHouseInfo" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/HouseInfo/WebHelper_Panel_HouseInfo.html")
  elseif helpType == "PanelInn" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Inn/WebHelper_Inn.html")
  elseif helpType == "PanelMailDetail" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Mail/WebHelper_Mail_Detail.html")
  elseif helpType == "PanelPetSkill" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Servant/WebHelper_PetSkill.html")
  elseif helpType == "PanelAuction" then
    html_WebHelper_Control:SetUrl(960, 600, "coui://UI_Data/UI_Html/WebHelper/Window/Auction/WebHelper_Panel_Auction.html")
  else
    html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, "WEBHELPER_GAMEGUIDE"))
  end
  if isGameTypeTaiwan() or isGameTypeEnglish() or isGameTypeKorea() or isGameTypeTR() or isGameTypeID() or isGameTypeTH() then
    html_WebHelper_Control:SetIME(true)
  end
  html_WebHelper_Control:SetSize(956, 600)
  html_WebHelper_Control:SetPosY(65)
  html_WebHelper_Control:SetSpanSize(0, 5)
  html_WebHelper_Control:SetShow(true)
end
function Panel_WebControl_LevelUpGuide(isString)
  if true == ToClient_isConsole() then
    return
  end
  if nil == isString then
    return
  end
  html_WebHelper_Control:SetUrl(960, 600, PAGetString(Defines.StringSheet_GAME, isString))
  html_WebHelper_Control:SetSize(960, 600)
  html_WebHelper_Control:SetPosY(40)
  html_WebHelper_Control:SetSpanSize(0, 5)
  html_WebHelper_Control:SetShow(true)
  Panel_WebControl:SetShow(true, false)
end
Panel_WebControl_Initialize()
