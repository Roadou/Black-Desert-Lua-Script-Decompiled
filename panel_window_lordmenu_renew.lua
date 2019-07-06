local _panel = Panel_Window_LordMenu_Renew
local TAB_TYPE = {
  TERRITORY = 1,
  COLLECTION = 2,
  ADJUST = 3
}
local LordMenu = {
  _ui = {},
  _currentTab = 1
}
function FromClient_luaLoadComplete_LordMenu()
  LordMenu:initialize()
end
function LordMenu:initialize()
  self._ui.stc_tabArea = UI.getChildControl(_panel, "Static_Tab_Group")
  self._ui.txt_tabs = {
    [TAB_TYPE.TERRITORY] = UI.getChildControl(self._ui.stc_tabArea, "StaticText_TerritoryTab"),
    [TAB_TYPE.COLLECTION] = UI.getChildControl(self._ui.stc_tabArea, "StaticText_CollectionTab"),
    [TAB_TYPE.ADJUST] = UI.getChildControl(self._ui.stc_tabArea, "StaticText_AdjustRateTab")
  }
  self._ui.stc_tabGroups = {
    [TAB_TYPE.TERRITORY] = UI.getChildControl(_panel, "Static_TerritoryGroup"),
    [TAB_TYPE.COLLECTION] = UI.getChildControl(_panel, "Static_CollectionGroup"),
    [TAB_TYPE.ADJUST] = UI.getChildControl(_panel, "Static_AdjustRateGroup")
  }
  self._ui.stc_keyGuideArea = UI.getChildControl(_panel, "Static_keyGuideArea")
  self._ui.keyGuides = {
    LB = UI.getChildControl(self._ui.stc_tabArea, "Static_LB"),
    RB = UI.getChildControl(self._ui.stc_tabArea, "Static_RB"),
    X = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_X_ConsoleUI"),
    A = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_A_ConsoleUI"),
    B = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_B_ConsoleUI")
  }
  self:initializeTabPos()
  self:initializeCOLLECTION()
  self:initializeADJUST()
  local keyGuides = {
    self._ui.keyGuides.X,
    self._ui.keyGuides.A,
    self._ui.keyGuides.B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_keyGuideArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_LordMenu")
local self = LordMenu
function LordMenu:initializeADJUST()
  local midBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.ADJUST], "Static_MiddleBG")
  local txt_tradeTex = UI.getChildControl(midBG, "StaticText_TradeTax")
  self._ui.slider_tradeTax = UI.getChildControl(txt_tradeTex, "Slider_Template")
  self._ui.progress_tradeTax = UI.getChildControl(self._ui.slider_tradeTax, "Progress2_1")
  self._ui.btn_tradeTax = UI.getChildControl(self._ui.slider_tradeTax, "Slider_DisplayButton")
  self._ui.slider_tradeTax:SetMonoTone(true)
  self._ui.progress_tradeTax:SetMonoTone(true)
  self._ui.btn_tradeTax:SetMonoTone(true)
  self._ui.slider_tradeTax:SetIgnore(true)
  self._ui.txt_min = UI.getChildControl(txt_tradeTex, "StaticText_Min")
  self._ui.txt_max = UI.getChildControl(txt_tradeTex, "StaticText_Max")
  local botBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.ADJUST], "Static_BotBG")
  local txt_localTaxTemplate = UI.getChildControl(botBG, "StaticText_LocalTaxTemplate")
  txt_localTaxTemplate:SetShow(false)
  self._ui.txt_localTaxPool = {}
  self._ui.slider_localTaxPool = {}
  self._ui.btn_sliderDisplayPool = {}
  self._ui.progress_localTaxPool = {}
  for ii = 1, 6 do
    self._ui.txt_localTaxPool[ii] = UI.cloneControl(txt_localTaxTemplate, botBG, "StaticText_LocalTax" .. ii)
    self._ui.txt_localTaxPool[ii]:SetPosY(80 + (ii - 1) * 60)
    self._ui.slider_localTaxPool[ii] = UI.getChildControl(self._ui.txt_localTaxPool[ii], "Slider_Template")
    self._ui.slider_localTaxPool[ii]:addInputEvent("Mouse_LPress", "Input_LordMenu_LocalTaxAdjust(" .. ii .. ")")
    self._ui.slider_localTaxPool[ii]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_LordMenu_LocalTaxReset()")
    self._ui.btn_sliderDisplayPool[ii] = UI.getChildControl(self._ui.slider_localTaxPool[ii], "Slider_DisplayButton")
    self._ui.progress_localTaxPool[ii] = UI.getChildControl(self._ui.slider_localTaxPool[ii], "Progress2_1")
  end
end
function LordMenu:initializeCOLLECTION()
  local midBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.COLLECTION], "Static_MiddleBG")
  local txt_midDesc = UI.getChildControl(midBG, "StaticText_Desc")
  txt_midDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_midDesc:SetText(txt_midDesc:GetText())
end
function LordMenu:initializeTabPos()
  local totalX = 0
  for _, tab in pairs(self._ui.txt_tabs) do
    totalX = totalX + tab:GetTextSizeX()
  end
  local freeSpaceX = (self._ui.stc_tabArea:GetSizeX() - totalX - 128) / 4
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._ui.txt_tabs, self._ui.stc_tabArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER, 0, freeSpaceX)
end
function LordMenu:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_LordMenu_NextTab(-1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_LordMenu_NextTab(1)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_LordMenu_Apply()")
end
function PaGlobalFunc_LordMenu_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_LordMenu_Open()
  self:open()
end
local _allTabOpen = false
function LordMenu:open()
  _panel:SetShow(true)
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local isLord = siegeWrapper:isLord()
  local doOccupantExist = siegeWrapper:doOccupantExist()
  if true == isLord and true == doOccupantExist then
    _allTabOpen = true
    siegeWrapper:updateTaxAmount(false)
    self._ui.txt_tabs[TAB_TYPE.COLLECTION]:SetShow(true)
    self._ui.txt_tabs[TAB_TYPE.ADJUST]:SetShow(true)
    self._ui.keyGuides.LB:SetShow(true)
    self._ui.keyGuides.RB:SetShow(true)
  else
    _allTabOpen = false
    self._ui.txt_tabs[TAB_TYPE.COLLECTION]:SetShow(false)
    self._ui.txt_tabs[TAB_TYPE.ADJUST]:SetShow(false)
    self._ui.keyGuides.LB:SetShow(false)
    self._ui.keyGuides.RB:SetShow(false)
  end
  self:initializeTabPos()
  self:setTabTo(self._currentTab)
end
function PaGlobalFunc_LordMenu_OnPadB()
  self:close()
end
function PaGlobalFunc_LordMenu_Close()
  self:close()
end
function PaGlobalFunc_LordMenu_ApplyTax()
  LordMenu:applyLocalTax()
end
function LordMenu:close()
  _panel:SetShow(false)
end
function Input_LordMenu_NextTab(val)
  if false == _allTabOpen then
    return
  end
  local nextTab = self._currentTab + val
  if nextTab > #self._ui.txt_tabs then
    nextTab = 1
  elseif nextTab < 1 then
    nextTab = #self._ui.txt_tabs
  end
  self:setTabTo(nextTab)
end
function LordMenu:setTabTo(tabIndex)
  for ii = 1, #self._ui.txt_tabs do
    self._ui.txt_tabs[ii]:SetFontColor(Defines.Color.C_FF9397A7)
    self._ui.stc_tabGroups[ii]:SetShow(false)
  end
  self._ui.txt_tabs[tabIndex]:SetFontColor(Defines.Color.C_FFEEEEEE)
  self._ui.stc_tabGroups[tabIndex]:SetShow(true)
  self._currentTab = tabIndex
  self._ui.keyGuides.A:SetShow(TAB_TYPE.ADJUST == self._currentTab)
  self._ui.keyGuides.X:SetShow(TAB_TYPE.ADJUST == self._currentTab)
  self:updateData(self._currentTab)
end
function LordMenu:updateData(tab)
  if tab == TAB_TYPE.TERRITORY then
    self:updateTERRITORY()
  elseif tab == TAB_TYPE.COLLECTION then
    self:updateCOLLECTION()
  elseif tab == TAB_TYPE.ADJUST then
    self:updateADJUST()
  end
end
function LordMenu:updateTERRITORY()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    self:close()
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    self:close()
    return
  end
  local doOccupantExist = siegeWrapper:doOccupantExist()
  local guildName = ""
  local lordName = ""
  if doOccupantExist then
    guildName = siegeWrapper:getGuildName()
    lordName = siegeWrapper:getGuildMasterName()
  end
  local occupyingDate = siegeWrapper:getOccupyingDate()
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(occupyingDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(occupyingDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(occupyingDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(occupyingDate:GetHour()))
  occupyingDate = year .. " " .. month .. " " .. day .. " " .. hour
  local affiliatedUserRate = siegeWrapper:getAffiliatedUserRate()
  local affiliatedUserRateStr = ""
  local affiliatedUserRateColor = ""
  if affiliatedUserRate >= 0 and affiliatedUserRate <= 20 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LACK") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = Defines.Color.C_FFFF4C4C
  elseif affiliatedUserRate > 20 and affiliatedUserRate <= 40 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LOW") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = Defines.Color.C_FFFF874C
  elseif affiliatedUserRate > 40 and affiliatedUserRate <= 60 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_NORMAL") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = Defines.Color.C_FFAEFF9B
  elseif affiliatedUserRate > 60 and affiliatedUserRate <= 80 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_HIGH") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = Defines.Color.C_FF9B9BFF
  elseif affiliatedUserRate > 80 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_EXPLOSION") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = Defines.Color.C_FF8737FF
  end
  local territoryKeyRaw = regionInfoWrapper:getTerritoryKeyRaw()
  local isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_NONE")
  local isOccupationDate = ToClient_GetAccumulatedOccupiedCountByWeek(territoryKeyRaw)
  if -1 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_NONE")
  elseif 0 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_VERY_UNSTABLE")
  elseif 1 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_UNSTABLE")
  elseif 2 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_NORMAL")
  elseif 3 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_SAFETY")
  elseif 4 == isOccupationDate then
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_VERY_SAFETY")
  else
    isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_NONE")
  end
  local description = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LORDMENU_TER_GUILDNAME") .. " " .. guildName .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LORDMENU_TER_LORDNAME") .. " " .. lordName .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LORDMENU_TER_OCCUPATION") .. " " .. occupyingDate .. "\n" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_LORDMENU_TERRITORY_SAFEAREA_TITLE") .. " " .. isWeekDate .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_POPULATIONDENSITY") .. " " .. affiliatedUserRateStr .. "\n"
  if false == doOccupantExist then
    description = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MINUSIEGETOOLTIP_NOTYETOCCUPY")
  end
  local midBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.TERRITORY], "Static_MiddleBG")
  local txt_desc = UI.getChildControl(midBG, "StaticText_Desc")
  txt_desc:SetText(description)
  local txt_help = UI.getChildControl(midBG, "StaticText_Help")
  txt_help:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TERRHELP"))
  local stc_guildmarkZone = UI.getChildControl(midBG, "Static_GuildMarkZone")
  local stc_guildmarkBG = UI.getChildControl(stc_guildmarkZone, "Static_GuildMarkBG")
  local stc_guildmark = UI.getChildControl(stc_guildmarkZone, "Static_GuildMark")
  local markData = getGuildMarkIndexByGuildNoForXBox(siegeWrapper:getGuildNo())
  if nil ~= markData then
    stc_guildmarkBG:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local bgx1, bgy1, bgx2, bgy2 = PaGlobalFunc_GuildMark_GetBackGroundUV(markData:getBackGroundIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(stc_guildmarkBG, bgx1, bgy1, bgx2, bgy2)
    stc_guildmarkBG:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_guildmarkBG:setRenderTexture(stc_guildmarkBG:getBaseTexture())
    stc_guildmark:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local iconx1, icony1, iconx2, icony2 = PaGlobalFunc_GuildMark_GetIconUV(markData:getIconIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(stc_guildmark, iconx1, icony1, iconx2, icony2)
    stc_guildmark:getBaseTexture():setUV(x1, y1, x2, y2)
    stc_guildmark:setRenderTexture(stc_guildmark:getBaseTexture())
  end
  local botBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.TERRITORY], "Static_BotBG")
  local stc_progressBG = UI.getChildControl(botBG, "Static_ProgressBG")
  local progress = UI.getChildControl(stc_progressBG, "Progress2_1")
  local txt_progressDesc = UI.getChildControl(stc_progressBG, "StaticText_1")
  local loyalty = siegeWrapper:getLoyalty()
  local loyaltyStr = ""
  if loyalty >= 0 and loyalty <= 15 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_UPRISING")
  elseif loyalty > 15 and loyalty <= 50 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_COMPLAINT")
  elseif loyalty > 50 and loyalty <= 70 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_NORMAL")
  elseif loyalty > 70 and loyalty <= 94 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_SATISFACTION")
  elseif loyalty > 94 and loyalty <= 100 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_GREATSATISFACTION")
  end
  progress:SetProgressRate(loyalty)
  txt_progressDesc:SetText(loyaltyStr)
  local txt_botHelp = UI.getChildControl(botBG, "StaticText_Desc")
  txt_botHelp:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_botHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_HAPPY_HELP"))
end
function LordMenu:updateCOLLECTION()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local doOccupantExist = siegeWrapper:doOccupantExist()
  if not doOccupantExist then
    return
  end
  local isLord = siegeWrapper:isLord()
  if not isLord then
    return
  end
  local midBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.COLLECTION], "Static_MiddleBG")
  local stc_graphBG = UI.getChildControl(midBG, "Static_GraphBG")
  local stc_leftProgressBG = UI.getChildControl(stc_graphBG, "Static_ProgressBG1")
  local progress_left = UI.getChildControl(stc_leftProgressBG, "Progress2_1")
  local stc_rightProgressBG = UI.getChildControl(stc_graphBG, "Static_ProgressBG2")
  local progress_right = UI.getChildControl(stc_rightProgressBG, "Progress2_1")
  local transferTaxProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local transferTaxAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local transferTaxAmount = transferTaxProducedAmount + transferTaxAffiliatedAmount
  local maxAmount = toInt64(0, 1)
  if transferTaxAmount > maxAmount then
    maxAmount = transferTaxAmount
  end
  progress_left:SetProgressRate(math.floor(Int64toInt32(transferTaxProducedAmount / maxAmount * toInt64(0, 100))))
  progress_right:SetProgressRate(math.floor(Int64toInt32(transferTaxAffiliatedAmount / maxAmount * toInt64(0, 100))))
  local txt_taxValue = UI.getChildControl(stc_graphBG, "StaticText_Value")
  txt_taxValue:SetText(makeDotMoney(transferTaxAmount))
  local posX = (stc_graphBG:GetSizeX() - (txt_taxValue:GetSizeX() + txt_taxValue:GetTextSizeX())) / 2
  txt_taxValue:SetPosX(posX)
  local botBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.COLLECTION], "Static_BotBG")
  local txt_balance = UI.getChildControl(botBG, "StaticText_Balance")
  local txt_balanceVal = UI.getChildControl(botBG, "StaticText_BalanceVal")
  local txt_localTax = UI.getChildControl(botBG, "StaticText_LocalTax")
  local txt_localTaxVal = UI.getChildControl(botBG, "StaticText_LocalTaxVal")
  local taxRemainedAmountForFortress = siegeWrapper:getTaxRemainedAmountForFortress()
  local taxRemainedAmountForSiege = siegeWrapper:getTaxRemainedAmountForSiege()
  txt_balanceVal:SetText(makeDotMoney(taxRemainedAmountForFortress))
  txt_balanceVal:SetPosX(botBG:GetSizeX() - txt_balanceVal:GetTextSpan().x - txt_balanceVal:GetTextSizeX() - 25)
  txt_localTaxVal:SetText(makeDotMoney(taxRemainedAmountForSiege))
  txt_localTaxVal:SetPosX(botBG:GetSizeX() - txt_localTaxVal:GetTextSpan().x - txt_localTaxVal:GetTextSizeX() - 25)
  local txt_security = UI.getChildControl(botBG, "StaticText_SecurityBudget")
  local txt_securityVal = UI.getChildControl(botBG, "StaticText_SecurityBudgetVal")
  local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
  local territoryKeyInNational = 10
  local territoryKeyValue = regionInfoWrapper:getTerritoryKeyRaw()
  local taxRate = ToClient_GetReceivableTaxRate(territoryKeyValue)
  local policingRate = 1000000 - ToClient_GetReceivableTaxRate(territoryKeyValue)
  local policingResultValue = policingRate / 10000
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if 3 == territoryKeyInNational or 4 == territoryKeyInNational then
      txt_localTax:SetShow(false)
      txt_localTaxVal:SetShow(false)
      txt_security:SetShow(false)
      txt_securityVal:SetShow(false)
    else
      txt_localTax:SetShow(true)
      txt_localTaxVal:SetShow(true)
      txt_security:SetShow(true)
      txt_securityVal:SetShow(true)
      txt_securityVal:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LORDMENU_GETMONEY_POLICINGMONEY", "value", policingResultValue))
      txt_securityVal:SetPosX(botBG:GetSizeX() - txt_securityVal:GetSizeX() - 25)
    end
  end
end
local transferTaxRate = 0
local taxForSiegeList = {}
function LordMenu:updateADJUST()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local doOccupantExist = siegeWrapper:doOccupantExist()
  local isLord = siegeWrapper:isLord()
  local minRate = 0
  local maxRate = 10
  minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  do
    local midBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.ADJUST], "Static_MiddleBG")
    transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
    self._ui.btn_tradeTax:SetText(tostring(transferTaxRate) .. "%")
    self._ui.slider_tradeTax:SetControlPos((transferTaxRate - minRate) / (maxRate - minRate) * 100)
    Input_LordMenu_TransferTaxAdjust()
    self._ui.txt_min:SetText(tostring(minRate) .. "%")
    self._ui.txt_max:SetText(tostring(maxRate) .. "%")
    self._ui.btn_tradeTax:SetMonoTone(true)
    self._ui.btn_tradeTax:SetEnable(false)
    local txt_midDesc = UI.getChildControl(midBG, "StaticText_Desc")
    txt_midDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    txt_midDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ITEMMARKETTAX"))
  end
  local isKing = siegeWrapper:isKing()
  local isKingTerritoryOnly = siegeWrapper:isKingTerritoryOnly()
  local isDutyShow = isKing and isKingTerritoryOnly
  local botBG = UI.getChildControl(self._ui.stc_tabGroups[TAB_TYPE.ADJUST], "Static_BotBG")
  for ii = 1, 6 do
    if ii <= 2 then
      self._ui.txt_localTaxPool[ii]:SetShow(isDutyShow)
    else
      self._ui.txt_localTaxPool[ii]:SetShow(false)
    end
  end
  self._ui.keyGuides.A:SetShow(isDutyShow)
  local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
  local territoryKeyInNational = 10
  local territorySiege, siegeName
  local territoryTaxRateForSiege = 10
  local indexCount = 1
  minRate = 10
  maxRate = 50
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if 3 == territoryKeyInNational or 4 == territoryKeyInNational then
      self._ui.txt_localTaxPool[1]:SetShow(false)
      self._ui.txt_localTaxPool[2]:SetShow(false)
    end
    if regionInfoWrapper:getTerritoryKeyRaw() ~= territoryKeyInNational then
      territorySiege = ToClient_GetSiegeWrapper(territoryKeyInNational)
      territorySiege:updateTaxRateForSiege()
      territoryName = territorySiege:getTerritoryName()
      territoryTaxRateForSiege = territorySiege:getTaxRateForSiege()
      if nil == taxForSiegeList[indexCount] then
        taxForSiegeList[indexCount] = {}
      end
      taxForSiegeList[indexCount].territoryKey = territoryKeyInNational
      taxForSiegeList[indexCount].taxRateForSiege = territoryTaxRateForSiege
      if nil ~= territorySiege then
        self._ui.txt_localTaxPool[indexCount]:SetText(territoryName)
        self._ui.slider_localTaxPool[indexCount]:SetControlPos(math.floor((territoryTaxRateForSiege - minRate) / (maxRate - minRate) * 100))
        Input_LordMenu_LocalTaxAdjust(indexCount)
        if territoryTaxRateForSiege == 10 then
          self._ui.slider_localTaxPool[indexCount]:SetControlPos(0)
        end
        indexCount = indexCount + 1
      end
    end
  end
  local txt_desc = UI.getChildControl(botBG, "StaticText_Desc")
  txt_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_DUTYTAX_HELP"))
  local isSiegeBeing = siegeWrapper:isSiegeBeing()
  if isSiegeBeing then
    for ii = 1, 6 do
      self._ui.slider_localTaxPool[ii]:SetIgnore(isSiegeBeing)
      self._ui.slider_localTaxPool[ii]:SetEnable(not isSiegeBeing)
    end
  end
end
function Input_LordMenu_TransferTaxAdjust()
  local self = LordMenu
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  transferTaxRate = math.floor(self._ui.slider_tradeTax:GetControlPos() * (maxRate - minRate) + minRate)
  self._ui.btn_tradeTax:SetText(tostring(transferTaxRate) .. "%")
  self._ui.btn_tradeTax:SetPosX(self._ui.slider_tradeTax:GetControlPos() * self._ui.slider_tradeTax:GetSizeX() * 0.95)
  self._ui.progress_tradeTax:SetProgressRate(self._ui.slider_tradeTax:GetControlPos() * 100)
end
function Input_LordMenu_LocalTaxAdjust(index)
  local taxForSiege = math.floor(10 + (self._ui.slider_localTaxPool[index]:GetControlPos() + 0.01) * 40)
  self._ui.btn_sliderDisplayPool[index]:SetText(tostring(taxForSiege) .. "%")
  self._ui.btn_sliderDisplayPool[index]:SetPosX(self._ui.slider_localTaxPool[index]:GetControlPos() * self._ui.slider_localTaxPool[index]:GetSizeX() * 0.95)
  self._ui.progress_localTaxPool[index]:SetProgressRate(self._ui.slider_localTaxPool[index]:GetControlPos() * 100)
  taxForSiegeList[index].taxRateForSiege = taxForSiege
end
function Input_LordMenu_TransferTaxReset()
  LordMenu:resetTransferTax()
end
function LordMenu:resetTransferTax()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local isLord = siegeWrapper:isLord()
  if not isLord then
    return
  end
  local minRate = 0
  local maxRate = 10
  minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  self._ui.slider_tradeTax:SetControlPos((transferTaxRate - minRate) / (maxRate - minRate) * 100)
  self._ui.btn_sliderDisplay = UI.getChildControl(self._ui.slider_tradeTax, "Slider_DisplayButton")
  self._ui.btn_sliderDisplay:SetText(tostring(transferTaxRate) .. "%")
  Input_LordMenu_TransferTaxAdjust()
  self._ui.txt_min:SetText(tostring(minRate) .. "%")
  self._ui.txt_max:SetText(tostring(maxRate) .. "%")
end
function LordMenu:applyTransferTax()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local isLord = siegeWrapper:isLord()
  if not isLord then
    return
  end
  siegeWrapper:changeTaxRateForFortress(0, 0, 0, transferTaxRate)
end
function Input_LordMenu_LocalTaxReset()
  LordMenu:resetLocalTax()
end
function LordMenu:resetLocalTax()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(selfPlayer:getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local isKing = siegeWrapper:isKing()
  if not isKing then
    return
  end
  local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
  local territoryKeyInNational = 10
  local territorySiege, siegeName
  local territoryTaxRateForSiege = 10
  local indexCount = 1
  local minRate = 10
  local maxRate = 50
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if regionInfoWrapper:getTerritoryKeyRaw() ~= territoryKeyInNational then
      territorySiege = ToClient_GetSiegeWrapper(territoryKeyInNational)
      territorySiege:updateTaxRateForSiege()
      territoryName = territorySiege:getTerritoryName()
      territoryTaxRateForSiege = territorySiege:getTaxRateForSiege()
      local index = ii + 1
      if nil == taxForSiegeList[index] then
        taxForSiegeList[index] = {}
      end
      taxForSiegeList[index].territoryKey = territoryKeyInNational
      taxForSiegeList[index].taxRateForSiege = territoryTaxRateForSiege
      if nil ~= territorySiege then
        self._ui.txt_localTaxPool[index]:SetText(territoryName)
        self._ui.btn_sliderDisplayPool[index]:SetText(tostring(territoryTaxRateForSiege) .. "%")
        self._ui.slider_localTaxPool[index]:SetControlPos(math.floor((territoryTaxRateForSiege - minRate) / (maxRate - minRate) * 100))
        self._ui.btn_sliderDisplayPool[index]:SetPosX(self._ui.slider_localTaxPool[index]:GetControlPos() * self._ui.slider_localTaxPool[index]:GetSizeX() * 0.95)
        self._ui.progress_localTaxPool[index]:SetProgressRate(self._ui.slider_localTaxPool[index]:GetControlPos() * 100)
        if territoryTaxRateForSiege == 10 then
          self._ui.slider_localTaxPool[index]:SetControlPos(0)
        end
      end
    end
  end
end
function LordMenu:applyLocalTax()
  local siegeWrapper
  for idx, val in pairs(taxForSiegeList) do
    if nil ~= val then
      siegeWrapper = ToClient_GetSiegeWrapper(val.territoryKey)
      if nil ~= siegeWrapper then
        siegeWrapper:changeTaxRateForSiege(val.taxRateForSiege)
      end
    end
  end
end
function Input_LordMenu_Apply()
  LordMenu:applyLocalTax()
end
