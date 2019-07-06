local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_LordMenu:SetShow(false)
Panel_LordMenu:RegisterShowEventFunc(true, "Panel_LordMenu_ShowAni()")
Panel_LordMenu:RegisterShowEventFunc(false, "Panel_LordMenu_HideAni()")
function Panel_LordMenu_ShowAni()
  Panel_LordMenu:SetAlpha(0)
  UIAni.fadeInSCR_Down(Panel_LordMenu)
  Panel_LordMenu:SetShow(true)
end
function Panel_LordMenu_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_LordMenu, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
end
local moveChildElements = function(destControl, srcControl, uiList)
  for _, value in pairs(uiList) do
    destControl:AddChild(value)
    srcControl:RemoveControl(value)
  end
end
local showToggleElements = function(isShow, uiList)
  for _, value in pairs(uiList) do
    value:SetShow(isShow)
  end
end
local ui_Main = {
  _btn_WinClose = UI.getChildControl(Panel_LordMenu, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_LordMenu, "Button_Question"),
  _btn_TerInfo = UI.getChildControl(Panel_LordMenu, "RadioButton_TerInfo"),
  _btn_PayInfo = UI.getChildControl(Panel_LordMenu, "RadioButton_PayInfo"),
  _btn_TaxInfo = UI.getChildControl(Panel_LordMenu, "RadioButton_TaxInfo"),
  _FrameBG = UI.getChildControl(Panel_LordMenu, "Static_Background"),
  panel_desc = UI.getChildControl(Panel_LordMenu, "Static_DescBG")
}
ui_Main._txt_Title = UI.getChildControl(ui_Main.panel_desc, "StaticText_DescTitle")
ui_Main._txt_Desc = UI.getChildControl(ui_Main.panel_desc, "StaticText_TaxDesc")
local ui_Ter = {
  _title_0 = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_Terr_Title_0"),
  _M_GuildName = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_M_GuildName"),
  _M_LordName = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_M_LordName"),
  _M_Occupation = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_M_Occupation"),
  _M_Residence = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_M_Residence"),
  _M_Week = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_M_Week"),
  _R_GuildName = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_R_GuildName"),
  _R_LordName = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_R_LordName"),
  _R_Occupation = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_R_Occupation"),
  _R_Residence = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_R_Residence"),
  _R_Week = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_R_Week"),
  _guildIconBG = UI.getChildControl(Panel_LordMenu_Territory, "Static_GuildIcon_BG"),
  _guildIcon = UI.getChildControl(Panel_LordMenu_Territory, "Static_GuildIcon"),
  _txt_TerrHelp = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_TerrInfo_Help"),
  _title_1 = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_Terr_Title_1"),
  _happyBG = UI.getChildControl(Panel_LordMenu_Territory, "Static_HappyGaugeBG"),
  _happyGauge = UI.getChildControl(Panel_LordMenu_Territory, "Progress2_HappyGauge"),
  _happyComment = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_HappyComment"),
  _happy_Help = UI.getChildControl(Panel_LordMenu_Territory, "StaticText_HappyRate_Help"),
  _TerLine = UI.getChildControl(Panel_LordMenu_Territory, "Static_Line")
}
local ui_Pay = {
  _title_0 = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Pay_Title_0"),
  _transferTax_Now_BG = UI.getChildControl(Panel_LordMenu_PayInfo, "Static_TransferTax_Now_BG"),
  _transferTax_Bef_BG = UI.getChildControl(Panel_LordMenu_PayInfo, "Static_TransferTax_Bef_BG"),
  _transferTax_Now_Gauge = UI.getChildControl(Panel_LordMenu_PayInfo, "Progress2_TransferTax_Now"),
  _transferTax_Bef_Gauge = UI.getChildControl(Panel_LordMenu_PayInfo, "Progress2_TransferTax_Bef"),
  _txt_TransferTax = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_TransferTax"),
  _txt_TransferTax_Gold = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_TransferTax_Gold"),
  _txt_TaxNow_Help = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_TaxNow_Help"),
  _txt_TaxBef_Help = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_TaxBef_Help"),
  _tax_Help = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Tax_Help"),
  _title_1 = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Pay_Title_1"),
  _txt_Balance = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Balance"),
  _txt_LocalTax = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_LocalTax"),
  _txt_Balance_Gold = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Balance_Gold"),
  _txt_LocalTax_Gold = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_LocalTax_Gold"),
  _txt_PolicingCost = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_PolicingCost"),
  _txt_PolicingCost_Gold = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_PolicingCostValue"),
  _btn_GetMoney = UI.getChildControl(Panel_LordMenu_PayInfo, "Button_GetMoney"),
  _txt_Balance_Help = UI.getChildControl(Panel_LordMenu_PayInfo, "StaticText_Balance_Help"),
  _payLine = UI.getChildControl(Panel_LordMenu_PayInfo, "Static_Pay_Line")
}
local ui_Tax = {
  _title_0 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Tax_Title_0"),
  _txt_TransferTax = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Tax_TransferTax"),
  _slide_TransferTax = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_TransferTax"),
  _slideBtn_TransferTax = nil,
  _txt_TransferTax_Help = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_TransferTax_Help"),
  _txt_TransferTax_Ref_Min = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_TransferTax_Ref_Min"),
  _txt_TransferTax_Ref_Max = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_TransferTax_Ref_Max"),
  _title_1 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Tax_Title_1"),
  _txt_Territory_1 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_1"),
  _txt_Territory_2 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_2"),
  _txt_Territory_3 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_3"),
  _txt_Territory_4 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_4"),
  _txt_Territory_5 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_5"),
  _txt_Territory_6 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Territory_6"),
  _slide_Territory_1 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_1"),
  _slideBtn_Territory_1 = nil,
  _slide_Territory_2 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_2"),
  _slideBtn_Territory_2 = nil,
  _slide_Territory_3 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_3"),
  _slideBtn_Territory_3 = nil,
  _slide_Territory_4 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_4"),
  _slideBtn_Territory_4 = nil,
  _slide_Territory_5 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_5"),
  _slideBtn_Territory_5 = nil,
  _slide_Territory_6 = UI.getChildControl(Panel_LordMenu_TaxControl, "Slider_Territory_6"),
  _slideBtn_Territory_6 = nil,
  _txt_min_1 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_1"),
  _txt_min_2 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_2"),
  _txt_min_3 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_3"),
  _txt_min_4 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_4"),
  _txt_min_5 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_5"),
  _txt_min_6 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Min_6"),
  _txt_max_1 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_1"),
  _txt_max_2 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_2"),
  _txt_max_3 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_3"),
  _txt_max_4 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_4"),
  _txt_max_5 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_5"),
  _txt_max_6 = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_Max_6"),
  _txt_DutyTax_Help = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_DutyTax_Help"),
  _btn_Tax_Reset = UI.getChildControl(Panel_LordMenu_TaxControl, "Button_Title_0_Reset"),
  _btn_Tax_Accpet = UI.getChildControl(Panel_LordMenu_TaxControl, "Button_Title_0_Accept"),
  _btn_Duty_Reset = UI.getChildControl(Panel_LordMenu_TaxControl, "Button_Title_1_Reset"),
  _btn_Duty_Accpet = UI.getChildControl(Panel_LordMenu_TaxControl, "Button_Title_1_Accept"),
  _noTax = UI.getChildControl(Panel_LordMenu_TaxControl, "StaticText_NoTax"),
  _taxLine = UI.getChildControl(Panel_LordMenu_TaxControl, "Static_Tax_Line")
}
local tapIndex = 0
local function Panel_LordMenu_Initialize()
  moveChildElements(ui_Main._FrameBG, Panel_LordMenu_Territory, ui_Ter)
  moveChildElements(ui_Main._FrameBG, Panel_LordMenu_PayInfo, ui_Pay)
  moveChildElements(ui_Main._FrameBG, Panel_LordMenu_TaxControl, ui_Tax)
  ui_Pay._btn_GetMoney:addInputEvent("Mouse_LDown", "LordMenu_Withdraw_Money()")
  ui_Tax._slideBtn_TransferTax = UI.getChildControl(ui_Tax._slide_TransferTax, "Slider_TransferTax_Button")
  ui_Tax._slideBtn_TransferTax:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TransferTax()")
  ui_Tax._slideBtn_Territory_1 = UI.getChildControl(ui_Tax._slide_Territory_1, "Slider_TerritoryButton_1")
  ui_Tax._slideBtn_Territory_1:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_1()")
  ui_Tax._slideBtn_Territory_2 = UI.getChildControl(ui_Tax._slide_Territory_2, "Slider_TerritoryButton_2")
  ui_Tax._slideBtn_Territory_2:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_2()")
  ui_Tax._slideBtn_Territory_3 = UI.getChildControl(ui_Tax._slide_Territory_3, "Slider_TerritoryButton_3")
  ui_Tax._slideBtn_Territory_3:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_3()")
  ui_Tax._slideBtn_Territory_4 = UI.getChildControl(ui_Tax._slide_Territory_4, "Slider_TerritoryButton_4")
  ui_Tax._slideBtn_Territory_4:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_4()")
  ui_Tax._slideBtn_Territory_5 = UI.getChildControl(ui_Tax._slide_Territory_5, "Slider_TerritoryButton_5")
  ui_Tax._slideBtn_Territory_5:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_5()")
  ui_Tax._slideBtn_Territory_6 = UI.getChildControl(ui_Tax._slide_Territory_6, "Slider_TerritoryButton_6")
  ui_Tax._slideBtn_Territory_6:addInputEvent("Mouse_LPress", "LordMenu_SlideControl_TaxForSiegeTerritory_6()")
  ui_Main._btn_TerInfo:SetCheck(true)
  ui_Main._btn_TerInfo:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_TerInfoShow()")
  ui_Main._btn_PayInfo:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_PayInfoShow()")
  ui_Main._btn_TaxInfo:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_TaxInfoShow()")
  showToggleElements(true, ui_Ter)
  showToggleElements(false, ui_Pay)
  showToggleElements(false, ui_Tax)
  ui_Main._FrameBG:SetChildIndex(ui_Pay._transferTax_Now_Gauge, 9999)
  ui_Main._FrameBG:SetChildIndex(ui_Pay._transferTax_Bef_Gauge, 9999)
  ui_Tax._btn_Tax_Reset:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_ResetTaxForFortress()")
  ui_Tax._btn_Tax_Accpet:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_ChangeTaxForFortress()")
  ui_Tax._btn_Duty_Reset:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_ResetTaxForSiege()")
  ui_Tax._btn_Duty_Accpet:addInputEvent("Mouse_LUp", "LordMenu_MouseEvent_ChangeTaxForSiege()")
  ui_Main._btn_WinClose:addInputEvent("Mouse_LUp", "LordMenu_Hide()")
  ui_Main._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelLordMenu\" )")
  ui_Main._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelLordMenu\", \"true\")")
  ui_Main._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelLordMenu\", \"false\")")
  Panel_LordMenu:addInputEvent("Mouse_On", "LordMenu_MouseEvent_PayInfoDescShow(true)")
  Panel_LordMenu:addInputEvent("Mouse_Out", "LordMenu_MouseEvent_PayInfoDescShow(false)")
  ui_Pay._btn_GetMoney:addInputEvent("Mouse_On", "LordMenu_MouseEvent_PayInfoDescShow(true)")
  ui_Pay._btn_GetMoney:addInputEvent("Mouse_Out", "LordMenu_MouseEvent_PayInfoDescShow(false)")
  ui_Main.panel_desc:SetShow(false)
end
function Panel_LordMenu_TerInfoUpdate()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    Panel_LordMenu:SetShow(false)
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    Panel_LordMenu:SetShow(false)
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
  local loyalty = siegeWrapper:getLoyalty()
  local loyaltyStr = ""
  local loyaltyColor = ""
  ui_Ter._R_GuildName:SetText(guildName)
  ui_Ter._R_LordName:SetText(lordName)
  ui_Ter._R_Occupation:SetText(occupyingDate)
  if affiliatedUserRate >= 0 and affiliatedUserRate <= 20 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LACK") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = UI_color.C_FFFF4C4C
  elseif affiliatedUserRate > 20 and affiliatedUserRate <= 40 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_LOW") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = UI_color.C_FFFF874C
  elseif affiliatedUserRate > 40 and affiliatedUserRate <= 60 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_NORMAL") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = UI_color.C_FFAEFF9B
  elseif affiliatedUserRate > 60 and affiliatedUserRate <= 80 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_HIGH") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = UI_color.C_FF9B9BFF
  elseif affiliatedUserRate > 80 then
    affiliatedUserRateStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_POPULATIONDENSITY_EXPLOSION") .. "(" .. string.format("%d", affiliatedUserRate) .. "%)"
    affiliatedUserRateColor = UI_color.C_FF8737FF
  end
  ui_Ter._R_GuildName:SetPosX(ui_Ter._M_GuildName:GetPosX() + ui_Ter._M_GuildName:GetTextSizeX() + 10)
  ui_Ter._R_LordName:SetPosX(ui_Ter._M_LordName:GetPosX() + ui_Ter._M_LordName:GetTextSizeX() + 10)
  ui_Ter._R_Occupation:SetPosX(ui_Ter._M_Occupation:GetPosX() + ui_Ter._M_Occupation:GetTextSizeX() + 10)
  ui_Ter._R_Residence:SetText(affiliatedUserRateStr)
  ui_Ter._R_Residence:SetFontColor(affiliatedUserRateColor)
  ui_Ter._R_Residence:SetPosX(ui_Ter._M_Residence:GetPosX() + ui_Ter._M_Residence:GetTextSizeX() + 10)
  ui_Ter._R_Week:SetPosX(ui_Ter._M_Week:GetPosX() + ui_Ter._M_Week:GetTextSizeX() + 10)
  local selfActorKeyRaw = selfPlayer:getActorKey()
  local isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), ui_Ter._guildIcon)
  if not isSet then
    ui_Ter._guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(ui_Ter._guildIcon, 183, 1, 188, 6)
    ui_Ter._guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    ui_Ter._guildIcon:setRenderTexture(ui_Ter._guildIcon:getBaseTexture())
  end
  local territoryKeyRaw = regionInfoWrapper:getTerritoryKeyRaw()
  local isOccupationDate = ToClient_GetAccumulatedOccupiedCountByWeek(territoryKeyRaw)
  local isWeekDate = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ISWEEKDATE_NONE")
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
  ui_Ter._R_Week:SetText(isWeekDate)
  if loyalty >= 0 and loyalty <= 15 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_UPRISING")
    loyaltyColor = UI_color.C_FFFF4C4C
  elseif loyalty > 15 and loyalty <= 50 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_COMPLAINT")
    loyaltyColor = UI_color.C_FFFF874C
  elseif loyalty > 50 and loyalty <= 70 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_NORMAL")
    loyaltyColor = UI_color.C_FFAEFF9B
  elseif loyalty > 70 and loyalty <= 94 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_SATISFACTION")
    loyaltyColor = UI_color.C_FF9B9BFF
  elseif loyalty > 94 and loyalty <= 100 then
    loyaltyStr = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_LOYALTY_GREATSATISFACTION")
    loyaltyColor = UI_color.C_FF8737FF
  end
  ui_Ter._happyGauge:SetProgressRate(loyalty)
  ui_Ter._happyComment:SetText(loyaltyStr)
  ui_Ter._happyComment:SetFontColor(loyaltyColor)
  ui_Ter._txt_TerrHelp:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Ter._happy_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Pay._transferTax_Now_Gauge:SetProgressRate(0)
  ui_Pay._transferTax_Bef_Gauge:SetProgressRate(0)
  ui_Ter._txt_TerrHelp:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TERRHELP"))
  ui_Ter._happy_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_HAPPY_HELP"))
  local isLord = siegeWrapper:isLord()
  if not isLord then
    ui_Main._btn_PayInfo:SetShow(false)
    ui_Main._btn_TaxInfo:SetShow(false)
  else
    ui_Main._btn_PayInfo:SetShow(true)
    ui_Main._btn_TaxInfo:SetShow(true)
  end
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
  ui_Pay._txt_PolicingCost:SetShow(false)
  ui_Pay._txt_PolicingCost_Gold:SetShow(false)
end
function Panel_LordMenu_PayInfoUpdate()
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
  local maxAmount = toInt64(0, 1)
  local transferTaxProducedAmount = siegeWrapper:getTaxProducedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local transferTaxAffiliatedAmount = siegeWrapper:getTaxAffiliatedAmount(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local transferTaxAmount = transferTaxProducedAmount + transferTaxAffiliatedAmount
  if maxAmount < transferTaxAmount then
    maxAmount = transferTaxAmount
  end
  ui_Pay._transferTax_Now_Gauge:SetProgressRate(math.floor(Int64toInt32(transferTaxProducedAmount / maxAmount * toInt64(0, 100))))
  ui_Pay._transferTax_Bef_Gauge:SetProgressRate(math.floor(Int64toInt32(transferTaxAffiliatedAmount / maxAmount * toInt64(0, 100))))
  ui_Pay._txt_TransferTax_Gold:SetText(makeDotMoney(transferTaxAmount))
  local taxRemainedAmountForFortress = siegeWrapper:getTaxRemainedAmountForFortress()
  local taxRemainedAmountForSiege = siegeWrapper:getTaxRemainedAmountForSiege()
  ui_Pay._txt_Balance_Gold:SetText(makeDotMoney(taxRemainedAmountForFortress))
  ui_Pay._txt_LocalTax_Gold:SetText(makeDotMoney(taxRemainedAmountForSiege))
  local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
  local territoryKeyInNational = 10
  local securityTax = ""
  ui_Pay._txt_PolicingCost:SetShow(false)
  ui_Pay._txt_PolicingCost_Gold:SetShow(false)
  securityTax = "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_SECUERITYTEX_DESC")
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if 3 == territoryKeyInNational or 4 == territoryKeyInNational then
      ui_Pay._txt_LocalTax_Gold:SetShow(false)
      ui_Pay._txt_LocalTax:SetShow(false)
      ui_Pay._txt_Balance:SetSpanSize(20, 355)
      ui_Pay._txt_Balance_Gold:SetPosY(ui_Pay._txt_Balance:GetPosY())
      ui_Pay._txt_Balance_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
      ui_Pay._txt_Balance_Help:SetText("")
      ui_Main._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
      ui_Main._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_BALANCE_HELP2") .. securityTax)
    else
      if ui_Main._btn_PayInfo:IsCheck() then
        ui_Pay._txt_LocalTax_Gold:SetShow(true)
        ui_Pay._txt_LocalTax:SetShow(true)
        ui_Pay._txt_PolicingCost:SetShow(true)
        ui_Pay._txt_PolicingCost_Gold:SetShow(true)
      end
      ui_Pay._txt_Balance:SetSpanSize(20, 355)
      ui_Pay._txt_Balance_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
      ui_Pay._txt_Balance_Help:SetText("")
      ui_Main._txt_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
      ui_Main._txt_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_BALANCE_HELP") .. securityTax)
    end
  end
  local territoryKeyValue = regionInfoWrapper:getTerritoryKeyRaw()
  local taxRate = ToClient_GetReceivableTaxRate(territoryKeyValue)
  local taxRateValue = ToClient_CalculatePercent(taxRemainedAmountForFortress, taxRate)
  local policingRate = 1000000 - ToClient_GetReceivableTaxRate(territoryKeyValue)
  local policingRateValue = ToClient_CalculatePercent(taxRemainedAmountForFortress, policingRate)
  local policingResultValue = policingRate / 10000
  ui_Pay._txt_PolicingCost_Gold:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LORDMENU_GETMONEY_POLICINGMONEY", "value", policingResultValue))
  ui_Pay._txt_TaxNow_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Pay._txt_TaxBef_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Pay._tax_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Pay._txt_TaxNow_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TAXNOW_HELP"))
  ui_Pay._txt_TaxBef_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_TAXBEF_HELP"))
  ui_Pay._tax_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TAX_HELP"))
  local settingSizeY = ui_Pay._tax_Help:GetTextSizeY() + ui_Pay._btn_GetMoney:GetSizeY()
  Panel_LordMenu:SetSize(Panel_LordMenu:GetSizeX(), settingSizeY + 570)
  ui_Main._FrameBG:SetSize(ui_Main._FrameBG:GetSizeX(), 558)
  ui_Main.panel_desc:SetSize(ui_Main.panel_desc:GetSizeX(), ui_Main._txt_Desc:GetTextSizeY() + 80)
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
end
function LordMenu_Withdraw_Money()
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
  local taxRemainedAmountForFortress = siegeWrapper:getTaxRemainedAmountForFortress()
  Panel_NumberPad_Show(true, taxRemainedAmountForFortress, 0, LordMenu_Withdraw_Money_Message)
end
local withdrawMoney = 0
function LordMenu_Withdraw_Money_Message(inputNumber, param)
  withdrawMoney = inputNumber
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  local taxRemainedAmountForFortress = withdrawMoney
  local territoryKeyValue = regionInfoWrapper:getTerritoryKeyRaw()
  local taxRate = ToClient_GetReceivableTaxRate(territoryKeyValue)
  local taxRateValue = ToClient_CalculatePercent(taxRemainedAmountForFortress, taxRate)
  local policingRate = 1000000 - ToClient_GetReceivableTaxRate(territoryKeyValue)
  local policingRateValue = ToClient_CalculatePercent(taxRemainedAmountForFortress, policingRate)
  local policingResultValue = makeDotMoney(withdrawMoney - policingRateValue)
  local messageBoxMemo = makeDotMoney(withdrawMoney) .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_CONTENT", "price", makeDotMoney(policingRateValue), "value", policingResultValue)
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_WITHDRAW_TITLE"),
    content = messageBoxMemo,
    functionYes = LordMenu_Withdraw_Money_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function LordMenu_Withdraw_Money_Confirm()
  local selfPlayer = getSelfPlayer()
  local regionInfoWrapper = getRegionInfoWrapper(selfPlayer:getRegionKeyRaw())
  if nil == regionInfoWrapper then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(getSelfPlayer():getRegionKeyRaw())
  if nil == siegeWrapper then
    return
  end
  if 0 == inputNumber then
    return
  end
  siegeWrapper:moveTownTaxToWarehouse(withdrawMoney, false)
end
function LordMenu_PayInfo_Update()
  Panel_LordMenu_PayInfoUpdate()
end
local transferTaxRate = 0
local taxForSiegeList = {}
function Panel_LordMenu_TaxInfoUpdate()
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
  local minRate = 0
  local maxRate = 10
  minRate = siegeWrapper:getMinTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  maxRate = siegeWrapper:getMaxTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate) .. "%")
  ui_Tax._slide_TransferTax:SetControlPos((transferTaxRate - minRate) / (maxRate - minRate) * 100)
  ui_Tax._txt_TransferTax_Ref_Min:SetText(tostring(minRate) .. "%")
  ui_Tax._txt_TransferTax_Ref_Max:SetText(tostring(maxRate) .. "%")
  ui_Tax._slideBtn_TransferTax:SetMonoTone(true)
  ui_Tax._slideBtn_TransferTax:SetEnable(false)
  local isKing = siegeWrapper:isKing()
  local isKingTerritoryOnly = siegeWrapper:isKingTerritoryOnly()
  local isDutyShow = isKing and isKingTerritoryOnly
  ui_Tax._title_1:SetShow(isDutyShow)
  ui_Tax._txt_Territory_1:SetShow(isDutyShow)
  ui_Tax._txt_Territory_2:SetShow(isDutyShow)
  ui_Tax._txt_Territory_3:SetShow(false)
  ui_Tax._txt_Territory_4:SetShow(false)
  ui_Tax._txt_Territory_5:SetShow(false)
  ui_Tax._txt_Territory_6:SetShow(false)
  ui_Tax._slide_Territory_1:SetShow(isDutyShow)
  ui_Tax._slide_Territory_2:SetShow(isDutyShow)
  ui_Tax._slide_Territory_3:SetShow(false)
  ui_Tax._slide_Territory_4:SetShow(false)
  ui_Tax._slide_Territory_5:SetShow(false)
  ui_Tax._slide_Territory_6:SetShow(false)
  ui_Tax._slideBtn_Territory_1:SetShow(isDutyShow)
  ui_Tax._slideBtn_Territory_2:SetShow(isDutyShow)
  ui_Tax._slideBtn_Territory_3:SetShow(false)
  ui_Tax._slideBtn_Territory_4:SetShow(false)
  ui_Tax._slideBtn_Territory_5:SetShow(false)
  ui_Tax._slideBtn_Territory_6:SetShow(false)
  ui_Tax._txt_min_1:SetShow(isDutyShow)
  ui_Tax._txt_min_2:SetShow(isDutyShow)
  ui_Tax._txt_min_3:SetShow(false)
  ui_Tax._txt_min_4:SetShow(false)
  ui_Tax._txt_min_5:SetShow(false)
  ui_Tax._txt_min_6:SetShow(false)
  ui_Tax._txt_max_1:SetShow(isDutyShow)
  ui_Tax._txt_max_2:SetShow(isDutyShow)
  ui_Tax._txt_max_3:SetShow(false)
  ui_Tax._txt_max_4:SetShow(false)
  ui_Tax._txt_max_5:SetShow(false)
  ui_Tax._txt_max_6:SetShow(false)
  ui_Tax._txt_DutyTax_Help:SetShow(isDutyShow)
  ui_Tax._btn_Duty_Reset:SetShow(isDutyShow)
  ui_Tax._btn_Duty_Accpet:SetShow(isDutyShow)
  ui_Tax._btn_Duty_Reset:SetEnable(true)
  ui_Tax._btn_Duty_Reset:SetMonoTone(false)
  ui_Tax._noTax:SetShow(false)
  local territorysInNationalCount = siegeWrapper:getTerritorysCountInNational()
  local territoryKeyInNational = 10
  local territorySiege, siegeName
  local territoryTaxRateForSiege = 10
  local indexCount = 1
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if 3 == territoryKeyInNational or 4 == territoryKeyInNational then
      ui_Tax._txt_Territory_1:SetShow(false)
      ui_Tax._txt_Territory_2:SetShow(false)
      ui_Tax._slide_Territory_1:SetShow(false)
      ui_Tax._slide_Territory_2:SetShow(false)
      ui_Tax._slideBtn_Territory_1:SetShow(false)
      ui_Tax._slideBtn_Territory_2:SetShow(false)
      ui_Tax._txt_min_1:SetShow(false)
      ui_Tax._txt_min_2:SetShow(false)
      ui_Tax._txt_max_1:SetShow(false)
      ui_Tax._txt_max_2:SetShow(false)
      ui_Tax._btn_Duty_Reset:SetEnable(false)
      ui_Tax._btn_Duty_Reset:SetMonoTone(true)
      ui_Tax._btn_Duty_Accpet:SetEnable(false)
      ui_Tax._btn_Duty_Accpet:SetMonoTone(true)
      ui_Tax._noTax:SetShow(true)
      ui_Tax._txt_DutyTax_Help:SetShow(false)
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
        if 1 == indexCount then
          ui_Tax._txt_Territory_1:SetText(territoryName)
          ui_Tax._slideBtn_Territory_1:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_1:SetControlPos(territoryTaxRateForSiege * 2)
          if territoryTaxRateForSiege == 10 then
            ui_Tax._slide_Territory_1:SetControlPos(0)
          end
        elseif 2 == indexCount then
          ui_Tax._txt_Territory_2:SetText(territoryName)
          ui_Tax._slideBtn_Territory_2:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_2:SetControlPos(territoryTaxRateForSiege * 2)
          if territoryTaxRateForSiege == 10 then
            ui_Tax._slide_Territory_2:SetControlPos(0)
          end
        elseif 3 == indexCount then
          ui_Tax._txt_Territory_3:SetText(territoryName)
          ui_Tax._slideBtn_Territory_3:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_3:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 4 == indexCount then
          ui_Tax._txt_Territory_4:SetText(territoryName)
          ui_Tax._slideBtn_Territory_4:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_4:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 5 == indexCount then
          ui_Tax._txt_Territory_5:SetText(territoryName)
          ui_Tax._slideBtn_Territory_5:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_5:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 6 == indexCount then
          ui_Tax._txt_Territory_6:SetText(territoryName)
          ui_Tax._slideBtn_Territory_6:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_6:SetControlPos(territoryTaxRateForSiege * 2)
        end
        indexCount = indexCount + 1
      end
    end
  end
  ui_Tax._txt_TransferTax_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Tax._txt_DutyTax_Help:SetTextMode(UI_TM.eTextMode_AutoWrap)
  ui_Tax._txt_TransferTax_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_ITEMMARKETTAX"))
  ui_Tax._txt_DutyTax_Help:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LORDMENU_TXT_DUTYTAX_HELP"))
  local isSiegeBeing = siegeWrapper:isSiegeBeing()
  if isSiegeBeing then
    ui_Tax._slideBtn_TransferTax:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_1:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_2:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_3:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_4:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_5:SetIgnore(isSiegeBeing)
    ui_Tax._slideBtn_Territory_6:SetIgnore(isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetEnable(not isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetEnable(not isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
    ui_Tax._btn_Tax_Accpet:SetEnable(not isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
    ui_Tax._btn_Duty_Reset:SetEnable(not isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
    ui_Tax._btn_Duty_Accpet:SetEnable(not isSiegeBeing)
    ui_Tax._btn_Tax_Reset:SetMonoTone(isSiegeBeing)
  end
  ui_Tax._btn_Tax_Reset:SetEnable(false)
  ui_Tax._btn_Tax_Accpet:SetEnable(false)
  ui_Tax._btn_Tax_Reset:SetMonoTone(true)
  ui_Tax._btn_Tax_Accpet:SetMonoTone(true)
  ui_Main._FrameBG:SetChildIndex(ui_Tax._btn_Tax_Reset, 9999)
  ui_Main._FrameBG:SetChildIndex(ui_Tax._btn_Tax_Accpet, 9999)
  ui_Main._FrameBG:SetChildIndex(ui_Tax._btn_Duty_Reset, 9999)
  ui_Main._FrameBG:SetChildIndex(ui_Tax._btn_Duty_Accpet, 9999)
  if Panel_Window_Exchange_Number:IsShow() then
    Panel_NumberPad_Show(false, Defines.s64_const.s64_0, 0, nil)
  end
end
function LordMenu_SlideControl_TransferTax()
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
  transferTaxRate = math.floor(ui_Tax._slide_TransferTax:GetControlPos() * (maxRate - minRate) + minRate)
  ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate) .. "%")
end
function LordMenu_SlideControl_TaxForSiegeTerritory_1()
  local taxForSiege = math.floor((0.2 + ui_Tax._slide_Territory_1:GetControlPos() * 4 / 5) * 50)
  ui_Tax._slideBtn_Territory_1:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[1].taxRateForSiege = taxForSiege
end
function LordMenu_SlideControl_TaxForSiegeTerritory_2()
  local taxForSiege = math.floor((0.2 + ui_Tax._slide_Territory_2:GetControlPos() * 4 / 5) * 50)
  ui_Tax._slideBtn_Territory_2:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[2].taxRateForSiege = taxForSiege
end
function LordMenu_SlideControl_TaxForSiegeTerritory_3()
  local taxForSiege = math.floor(ui_Tax._slide_Territory_3:GetControlPos() * 50)
  ui_Tax._slideBtn_Territory_3:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[3].taxRateForSiege = taxForSiege
end
function LordMenu_SlideControl_TaxForSiegeTerritory_4()
  local taxForSiege = math.floor(ui_Tax._slide_Territory_4:GetControlPos() * 50)
  ui_Tax._slideBtn_Territory_4:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[4].taxRateForSiege = taxForSiege
end
function LordMenu_SlideControl_TaxForSiegeTerritory_5()
  local taxForSiege = math.floor(ui_Tax._slide_Territory_5:GetControlPos() * 50)
  ui_Tax._slideBtn_Territory_5:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[5].taxRateForSiege = taxForSiege
end
function LordMenu_SlideControl_TaxForSiegeTerritory_6()
  local taxForSiege = math.floor(ui_Tax._slide_Territory_6:GetControlPos() * 50)
  ui_Tax._slideBtn_Territory_6:SetText(tostring(taxForSiege) .. "%")
  taxForSiegeList[6].taxRateForSiege = taxForSiege
end
function LordMenu_MouseEvent_ResetTaxForFortress()
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
  ui_Tax._slideBtn_TransferTax:SetText(tostring(transferTaxRate) .. "%")
  ui_Tax._slide_TransferTax:SetControlPos((transferTaxRate - minRate) / (maxRate - minRate) * 100)
  ui_Tax._txt_TransferTax_Ref_Min:SetText(tostring(minRate) .. "%")
  ui_Tax._txt_TransferTax_Ref_Max:SetText(tostring(maxRate) .. "%")
end
function LordMenu_MouseEvent_ChangeTaxForFortress()
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
function LordMenu_MouseEvent_ResetTaxForSiege()
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
  for ii = 0, territorysInNationalCount - 1 do
    territoryKeyInNational = siegeWrapper:getTerritoryKeyInNationalByIndex(ii)
    if regionInfoWrapper:getTerritoryKeyRaw() ~= territoryKeyInNational then
      territorySiege = ToClient_GetSiegeWrapper(territoryKeyInNational)
      territoryName = territorySiege:getTerritoryName()
      territoryTaxRateForSiege = territorySiege:getTaxRateForSiege()
      if nil == taxForSiegeList[indexCount] then
        taxForSiegeList[indexCount] = {}
      end
      taxForSiegeList[indexCount].territoryKey = territoryKeyInNational
      taxForSiegeList[indexCount].taxRateForSiege = territoryTaxRateForSiege
      if nil ~= territorySiege then
        if 1 == indexCount then
          ui_Tax._txt_Territory_1:SetText(territoryName)
          ui_Tax._slideBtn_Territory_1:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_1:SetControlPos(territoryTaxRateForSiege * 2)
          if territoryTaxRateForSiege == 10 then
            ui_Tax._slide_Territory_1:SetControlPos(0)
          end
        elseif 2 == indexCount then
          ui_Tax._txt_Territory_2:SetText(territoryName)
          ui_Tax._slideBtn_Territory_2:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_2:SetControlPos(territoryTaxRateForSiege * 2)
          if territoryTaxRateForSiege == 10 then
            ui_Tax._slide_Territory_2:SetControlPos(0)
          end
        elseif 3 == indexCount then
          ui_Tax._txt_Territory_3:SetText(territoryName)
          ui_Tax._slideBtn_Territory_3:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_3:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 4 == indexCount then
          ui_Tax._txt_Territory_4:SetText(territoryName)
          ui_Tax._slideBtn_Territory_4:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_4:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 5 == indexCount then
          ui_Tax._txt_Territory_5:SetText(territoryName)
          ui_Tax._slideBtn_Territory_5:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_5:SetControlPos(territoryTaxRateForSiege * 2)
        elseif 6 == indexCount then
          ui_Tax._txt_Territory_6:SetText(territoryName)
          ui_Tax._slideBtn_Territory_6:SetText(tostring(territoryTaxRateForSiege) .. "%")
          ui_Tax._slide_Territory_6:SetControlPos(territoryTaxRateForSiege * 2)
        end
        indexCount = indexCount + 1
      end
    end
  end
end
function LordMenu_MouseEvent_ChangeTaxForSiege()
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
function LordMenu_MouseEvent_PayInfoDescShow(isShow)
  if nil == isShow then
    return
  end
  if not ui_Main._btn_PayInfo:IsCheck() then
    return
  end
  local panelPosX = Panel_LordMenu:GetPosX()
  local panelPosY = Panel_LordMenu:GetPosY()
  local panelSizeX = Panel_LordMenu:GetSizeX()
  local panelSizeY = Panel_LordMenu:GetSizeY()
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  if panelPosX <= mousePosX and mousePosX <= panelPosX + panelSizeX and panelPosY <= mousePosY and mousePosY <= panelPosY + panelSizeY then
    ui_Main.panel_desc:SetShow(true)
    return
  end
  ui_Main.panel_desc:SetShow(isShow)
end
function LordMenu_MouseEvent_TerInfoShow()
  tapIndex = 0
  showToggleElements(true, ui_Ter)
  showToggleElements(false, ui_Pay)
  showToggleElements(false, ui_Tax)
  Panel_LordMenu_TerInfoUpdate()
  ui_Main.panel_desc:SetShow(false)
end
function LordMenu_MouseEvent_PayInfoShow()
  tapIndex = 1
  showToggleElements(false, ui_Ter)
  showToggleElements(true, ui_Pay)
  showToggleElements(false, ui_Tax)
  ui_Pay._btn_GetMoney:SetShow(false)
  Panel_LordMenu_PayInfoUpdate()
  ui_Main.panel_desc:SetShow(false)
end
function LordMenu_MouseEvent_TaxInfoShow()
  tapIndex = 2
  showToggleElements(false, ui_Ter)
  showToggleElements(false, ui_Pay)
  showToggleElements(true, ui_Tax)
  Panel_LordMenu_TaxInfoUpdate()
  ui_Main.panel_desc:SetShow(false)
end
function LordMenu_Show()
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
  if isLord then
    siegeWrapper:updateTaxAmount(false)
  end
  Panel_LordMenu:SetShow(true)
  ui_Main._btn_TerInfo:SetCheck(true)
  LordMenu_MouseEvent_TerInfoShow()
  ui_Main._btn_TerInfo:SetCheck(true)
  ui_Main._btn_PayInfo:SetCheck(false)
  ui_Main._btn_TaxInfo:SetCheck(false)
end
function LordMenu_Hide()
  if Panel_LordMenu:IsShow() then
    Panel_LordMenu:SetShow(false)
    ui_Main._btn_TerInfo:SetCheck(true)
    ui_Main._btn_PayInfo:SetCheck(false)
    ui_Main._btn_TaxInfo:SetCheck(false)
  end
end
Panel_LordMenu_Initialize()
registerEvent("EventLordMenuPayInfoUpdate", "LordMenu_PayInfo_Update")
local texFirstNotifyCheck = true
local _transferTaxRate
function FromClient_NotifyUpdateTownTax(regionKeyRow)
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKeyRow)
  if nil == siegeWrapper then
    return
  end
  local territoryName = siegeWrapper:getTerritoryName()
  local transferTaxRate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  local _texMessage = ""
  if texFirstNotifyCheck == true then
    _transferTaxRate = transferTaxRate
    texFirstNotifyCheck = false
    _texMessage = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LORDMENU_NOTIFYUPDATETOWNTAX_APPLY", "territoryName", territoryName, "transferTaxRate", tostring(_transferTaxRate))
  elseif _transferTaxRate == transferTaxRate then
    return
  else
    _transferTaxRate = transferTaxRate
    _texMessage = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_LORDMENU_NOTIFYUPDATETOWNTAX_CHANGE", "territoryName", territoryName, "transferTaxRate", tostring(_transferTaxRate))
  end
  TerritoryTex_ShowMessage_Ack(_texMessage)
end
registerEvent("FromClient_NotifyUpdateTownTax", "FromClient_NotifyUpdateTownTax")
registerEvent("FromClient_NotifyUpdateSiegeTax", "Panel_LordMenu_TaxInfoUpdate")
