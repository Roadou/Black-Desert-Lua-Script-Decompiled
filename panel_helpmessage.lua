local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local _staticDescBG = UI.getChildControl(Panel_HelpMessage, "Static_DescBG")
local _staticTextDesc = UI.getChildControl(Panel_HelpMessage, "StaticText_Desc")
_staticTextDesc:SetShow(true)
_staticTextDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
_staticDescBG:SetShow(true)
function HelpMessageQuestion_Show(where, isTrue)
  if isGameTypeKR2() then
    return
  end
  if where == "PanelImportantKnowledge" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Knowledge"))
  elseif where == "PanelAlchemy" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Alchemy"))
  elseif where == "PanelCook" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Cook"))
  elseif where == "PanelManufacture" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Product"))
  elseif where == "HouseAuction" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseAuction"))
  elseif where == "PanelAuction" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Auction"))
  elseif where == "PanelHouseAuction" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseAuction"))
  elseif where == "PanelBuyDrink" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Alcohol"))
  elseif where == "DeliveryCarriageinformation" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Goods"))
  elseif where == "DeliveryInformation" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Trans"))
  elseif where == "DeliveryPerson" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Char_Trans"))
  elseif where == "DeliveryRequest" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Sent_Receipt"))
  elseif where == "SpiritEnchant" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PotenBreak"))
  elseif where == "PanelWindowEquipment" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Equip"))
  elseif where == "PanelExchangeWithPC" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Person_Deal"))
  elseif where == "PanelWindowExtractionCrystal" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Extraction"))
  elseif where == "PanelWindowExtractionEnchantStone" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Stone_Extraction"))
  elseif where == "PanelGameExit" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Game_Exit"))
  elseif where == "PanelGuild" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Guild"))
  elseif where == "PanelClan" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Clan"))
  elseif where == "HouseList" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Get_House"))
  elseif where == "PanelHouseControl" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_House"))
  elseif where == "PanelHouseInfo" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseInfo"))
  elseif where == "PanelInn" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Hotel_Rent"))
  elseif where == "PanelWindowInventory" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Bag"))
  elseif where == "PanelServantInventory" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_BoardingBag"))
  elseif where == "PanelLordMenu" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Seignior"))
  elseif where == "Panelmail" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailRead"))
  elseif where == "PanelMailDetail" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailSend"))
  elseif where == "PanelMailSend" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MailSend"))
  elseif where == "UIGameOption" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GameOption"))
  elseif where == "PanelQuestHistory" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Request"))
  elseif where == "PanelQuestReward" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Request_Reward"))
  elseif where == "PanelFixEquip" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Repair"))
  elseif where == "PanelPetSkill" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Obedience"))
  elseif where == "PanelServantinfo" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_BoardingInfo"))
  elseif where == "PanelEnableSkill" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GetSkill"))
  elseif where == "PanelWindowSkill" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Skill"))
  elseif where == "PanelSkillAwaken" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_SkillAwaken"))
  elseif where == "Socket" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PotenTransition"))
  elseif where == "PanelWindowStableMating" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Mating"))
  elseif where == "PanelWindowStableMarket" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HorseMarket"))
  elseif where == "PanelWindowStableRegister" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Regist"))
  elseif where == "PanelWindowStableShop" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Shop"))
  elseif where == "PanelTradeMarketGraph" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_QuoteStatus"))
  elseif where == "HouseManageWork" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage"))
  elseif where == "FarmManageWork" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage2"))
  elseif where == "PanelWorldMapTownWorkerManage" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WorkerMange"))
  elseif where == "SelfCharacterInfo" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_MyInfo"))
  elseif where == "PanelFriends" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_FriendsList"))
  elseif where == "MyVendorList" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_GetShop"))
  elseif where == "HousingConsignmentSale" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Consignment"))
  elseif where == "HosingVendingMachine" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_AutoSales"))
  elseif where == "PartyOption" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_PartySetting"))
  elseif where == "NodeMenu" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_NodeName"))
  elseif where == "WareHouse" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WareHouse"))
  elseif where == "Panel_Farm_ManageWork" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_TaskManage"))
  elseif where == "NpcShop" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_NpcShop"))
  elseif where == "HouseRank" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_HouseRank"))
  elseif where == "TerritoryAuth" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ImperialTrade"))
  elseif where == "Chatting" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Chatting"))
  elseif where == "Worker" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Worker"))
  elseif where == "WarInfo" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_WarInfo"))
  elseif where == "ItemMarket" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ItemMarket"))
  elseif where == "Pet" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Pet"))
  elseif where == "ProductNote" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Productnote"))
  elseif where == "Dye" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_Dye"))
  elseif where == "AlchemyStone" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_AlchemyStone"))
  elseif where == "LifeRanking" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_LifeRanking"))
  elseif where == "ClothExchange" then
    _staticTextDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HELPMESSAGE_ClothExchange"))
  end
  if isTrue == "true" then
    HelpMessageQuestion_On()
  else
    HelpMessageQuestion_Out()
  end
end
function HelpMessageQuestion_On()
  if getMousePosX() <= getScreenSizeX() / 2 and getMousePosY() <= getScreenSizeY() / 2 then
    Panel_HelpMessage:SetPosX(getMousePosX() + 15)
    Panel_HelpMessage:SetPosY(getMousePosY() + 15)
  elseif getMousePosX() > getScreenSizeX() / 2 and getMousePosY() <= getScreenSizeY() / 2 then
    Panel_HelpMessage:SetPosX(getMousePosX() - 200)
    Panel_HelpMessage:SetPosY(getMousePosY() + 15)
  elseif getMousePosX() <= getScreenSizeX() / 2 and getMousePosY() > getScreenSizeY() / 2 then
    Panel_HelpMessage:SetPosX(getMousePosX() + 15)
    Panel_HelpMessage:SetPosY(getMousePosY() - 90)
  else
    Panel_HelpMessage:SetPosX(getMousePosX() - 200)
    Panel_HelpMessage:SetPosY(getMousePosY() - 90)
  end
  Panel_HelpMessage:SetShow(true)
end
function HelpMessageQuestion_Out()
  Panel_HelpMessage:SetShow(false)
end
