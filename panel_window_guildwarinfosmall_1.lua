function PaGlobal_GuildWarInfoSmall:initialize()
  if true == PaGlobal_GuildWarInfoSmall._initialize then
    return
  end
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._btn_close = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Button_Close")
  PaGlobal_GuildWarInfoSmall._ui._btn_refresh = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Button_Refresh")
  PaGlobal_GuildWarInfoSmall._ui._btn_bigWin = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Button_Big")
  PaGlobal_GuildWarInfoSmall._ui._stc_blackBG = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Static_Bg")
  PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Static_DefenceBG")
  PaGlobal_GuildWarInfoSmall._ui._stc_defenceProgressBG = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG, "Static_ProgressBG")
  PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo = {
    stc_guildIcon = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG, "Static_GuildIcon"),
    txt_guildName = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG, "StaticText_GuildName"),
    stc_progress = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_defenceProgressBG, "Progress2_1"),
    txt_percent = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG, "StaticText_Percent")
  }
  PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyBG = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Static_NoOccupyBG")
  PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyInfo = {
    stc_noOccupyIcon = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyBG, "StaticText_NoOccupyInfo")
  }
  PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyInfo.stc_noOccupyIcon:SetColor(Defines.Color.C_FF888888)
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "List2_AttackGuildList")
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:changeAnimationSpeed(10)
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_GuildWarInfoSmall_updateListContent")
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_GuildWarInfoSmall._ui._list_scroll = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._list_attackGuild, "List2_1_VerticalScroll")
  PaGlobal_GuildWarInfoSmall._ui._list_scroll.btn_ctrl = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._list_scroll, "List2_1_VerticalScroll_CtrlButton")
  PaGlobal_GuildWarInfoSmall._ui._list_scroll:SetControlPos(0)
  PaGlobal_GuildWarInfoSmall._ui._stc_noWarBG = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Static_NoWarBG")
  PaGlobal_GuildWarInfoSmall._ui._stc_nowarTitle = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_noWarBG, "StaticText_FinishTitle")
  PaGlobal_GuildWarInfoSmall._ui._stc_nowarResult = UI.getChildControl(PaGlobal_GuildWarInfoSmall._ui._stc_noWarBG, "StaticText_FinishResult")
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox = UI.getChildControl(Panel_Window_GuildWarInfoSmall, "Combobox_Region")
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:setListTextHorizonLeft()
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:SetSelectItemIndex(0)
  PaGlobal_GuildWarInfoSmall:registEventHandler()
  PaGlobal_GuildWarInfoSmall:validate()
  PaGlobal_GuildWarInfoSmall._initialize = true
end
function PaGlobal_GuildWarInfoSmall:registEventHandler()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfoSmall_Close()")
  PaGlobal_GuildWarInfoSmall._ui._btn_refresh:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfoSmall_Refresh()")
  PaGlobal_GuildWarInfoSmall._ui._btn_bigWin:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfoSmall_BigWinChange()")
  PaGlobal_GuildWarInfoSmall._ui._btn_bigWin:addInputEvent("Mouse_On", "HandleEventOn_GuildWarInfoSmall_BigWinToolTipShow()")
  PaGlobal_GuildWarInfoSmall._ui._btn_bigWin:addInputEvent("Mouse_Out", "HandleEventOn_GuildWarInfoSmall_BigWinToolTipHide()")
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfoSmall_ComboShow()")
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:GetListControl():addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfoSmall_ComboSet()")
  registerEvent("Event_SiegeScoreUpdateData", "FromClient_GuildWarInfoSmall_SiegeScoreUpdateData")
  registerEvent("FromClient_NotifyStartSiege", "FromClient_GuildWarInfoSmall_NotifyStartSiege")
end
function PaGlobal_GuildWarInfoSmall:prepareOpen(territoryKey)
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:DeleteAllItem(0)
  for index = -1, 3 do
    local siegeWrapper = ToClient_GetSiegeWrapper(index + 1)
    PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:AddItem(siegeWrapper:getTerritoryName())
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:setListTextHorizonCenter()
  PaGlobal_GuildWarInfoSmall._ui._list_scroll:SetControlPos(0)
  PaGlobal_GuildWarInfoSmall:update(territoryKey)
end
function PaGlobal_GuildWarInfoSmall:open()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  Panel_Window_GuildWarInfoSmall:SetShow(true)
end
function PaGlobal_GuildWarInfoSmall:prepareClose()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
end
function PaGlobal_GuildWarInfoSmall:close()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  Panel_Window_GuildWarInfoSmall:SetShow(false)
end
function PaGlobal_GuildWarInfoSmall:update(territoryKey)
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if nil == territoryKey then
    territoryKey = PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:GetSelectIndex()
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:SetSelectItemIndex(territoryKey)
  PaGlobal_GuildWarInfoSmall._siegeRegion = territoryKey
  PaGlobal_GuildWarInfoSmall._isSeigeBeing = isSiegeBeing(PaGlobal_GuildWarInfoSmall._siegeRegion)
  if nil == PaGlobal_GuildWarInfoSmall._siegeRegion then
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapper(PaGlobal_GuildWarInfoSmall._siegeRegion)
  if nil == siegeWrapper then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_noWarBG:SetShow(false)
  PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG:SetShow(false)
  PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyBG:SetShow(false)
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:SetShow(false)
  if true == PaGlobal_GuildWarInfoSmall._isSeigeBeing then
    local guildCount = ToClient_SiegeGuildCount(PaGlobal_GuildWarInfoSmall._siegeRegion)
    PaGlobal_GuildWarInfoSmall:updateGuildWarMain(siegeWrapper, guildCount)
    PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:SetSelectItemIndex(PaGlobal_GuildWarInfoSmall._siegeRegion)
    if true == siegeWrapper:doOccupantExist() then
      PaGlobal_GuildWarInfoSmall._ui._stc_defenceBG:SetShow(true)
      PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:SetShow(true)
    else
      PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyBG:SetShow(true)
      PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:SetShow(true)
      if false == isGameTypeKorea() then
        PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyInfo.stc_noOccupyIcon:SetHorizonLeft()
        PaGlobal_GuildWarInfoSmall._ui._stc_noOccupyInfo.stc_noOccupyIcon:SetSpanSize(15, 10)
      end
    end
  else
    PaGlobal_GuildWarInfoSmall._ui._stc_nowarTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    PaGlobal_GuildWarInfoSmall._ui._stc_nowarResult:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    if true == siegeWrapper:doOccupantExist() then
      PaGlobal_GuildWarInfoSmall._ui._stc_nowarTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", siegeWrapper:getTerritoryName()))
      local guildWrapper = ToClient_GetGuildWrapperByGuildNo(siegeWrapper:getGuildNo())
      local allianceName = ""
      if nil ~= guildWrapper then
        allianceName = guildWrapper:getAllianceName()
      end
      if "" == allianceName then
        PaGlobal_GuildWarInfoSmall._ui._stc_nowarResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", siegeWrapper:getGuildName()))
      else
        PaGlobal_GuildWarInfoSmall._ui._stc_nowarResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_ALLIANCE_WARINFOCONTENTS_SETFREEDESC_END", "getName", siegeWrapper:getGuildName()))
      end
    else
      PaGlobal_GuildWarInfoSmall._ui._stc_nowarTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE", "selectTerritoy", siegeWrapper:getTerritoryName()))
      PaGlobal_GuildWarInfoSmall._ui._stc_nowarResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC"))
    end
    PaGlobal_GuildWarInfoSmall._ui._stc_noWarBG:SetShow(true)
    Panel_Window_GuildWarInfoSmall:SetSize(Panel_Window_GuildWarInfoSmall:GetSizeX(), 195)
    PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:SetSize(PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:GetSizeX(), 145)
    PaGlobal_GuildWarInfoSmall._ui._list_scroll:SetShow(false)
  end
end
function PaGlobal_GuildWarInfoSmall:updateGuildWarMain(siegeWrapper, guildCount)
  if nil == siegeWrapper or nil == guildCount then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:getElementManager():clearKey()
  local addAttackGuildCount = guildCount - 1
  if true == siegeWrapper:doOccupantExist() then
    addAttackGuildCount = addAttackGuildCount - 1
  end
  if addAttackGuildCount >= 1 and addAttackGuildCount < 5 then
    Panel_Window_GuildWarInfoSmall:SetSize(Panel_Window_GuildWarInfoSmall:GetSizeX(), 195 + addAttackGuildCount * 45)
    PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:SetSize(PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:GetSizeX(), 145 + addAttackGuildCount * 45)
  elseif addAttackGuildCount >= 5 then
    Panel_Window_GuildWarInfoSmall:SetSize(Panel_Window_GuildWarInfoSmall:GetSizeX(), 375)
    PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:SetSize(PaGlobal_GuildWarInfoSmall._ui._stc_blackBG:GetSizeX(), 325)
  end
  for ii = 0, guildCount - 1 do
    local guildWrapper = ToClient_SiegeGuildAt(PaGlobal_GuildWarInfoSmall._siegeRegion, ii)
    local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(PaGlobal_GuildWarInfoSmall._siegeRegion, ii)
    if nil == guildWrapper or nil == siegeBuildingInfo then
      return
    end
    if guildWrapper:getGuildNo_s64() == siegeWrapper:getGuildNo() then
      PaGlobal_GuildWarInfoSmall._defenceGuildNo = guildWrapper:getGuildNo_s64()
      local allianceName = guildWrapper:getAllianceName()
      if "" == allianceName then
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.txt_guildName:SetText(guildWrapper:getName())
      else
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.txt_guildName:SetText(allianceName)
      end
      local isSet = false
      if true == guildWrapper:isAllianceGuild() then
        isSet = setGuildTextureByAllianceNo(guildWrapper:guildAllianceNo_s64(), PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon)
      else
        isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon)
      end
      if false == isSet then
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon, 183, 1, 188, 6)
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:setRenderTexture(PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:getBaseTexture())
      else
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
        PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:setRenderTexture(PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_guildIcon:getBaseTexture())
      end
      local hpPercent = siegeBuildingInfo:getRemainHp() / 10000
      local roundingoffPercent = math.floor(hpPercent / 100 * 100)
      PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.txt_percent:SetText(tostring(roundingoffPercent) .. "%")
      PaGlobal_GuildWarInfoSmall._ui._defenceGuildInfo.stc_progress:SetProgressRate(roundingoffPercent)
    else
      PaGlobal_GuildWarInfoSmall._ui._list_attackGuild:getElementManager():pushKey(toInt64(0, ii))
    end
  end
end
function PaGlobal_GuildWarInfoSmall_updateListContent(contents, index)
  local attackGuildProgressBG = UI.getChildControl(contents, "Static_ProgressBG")
  local attackGuildInfo = {
    stc_guildIcon = UI.getChildControl(contents, "Static_GuildIcon"),
    txt_guildName = UI.getChildControl(contents, "StaticText_GuildName"),
    stc_progress = UI.getChildControl(attackGuildProgressBG, "Progress2_1"),
    txt_percent = UI.getChildControl(contents, "StaticText_Percent")
  }
  contents:SetShow(true)
  local index32 = Int64toInt32(index)
  local guildWrapper = ToClient_SiegeGuildAt(PaGlobal_GuildWarInfoSmall._siegeRegion, index32)
  local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(PaGlobal_GuildWarInfoSmall._siegeRegion, index32)
  if nil == guildWrapper or nil == siegeBuildingInfo then
    return
  end
  local allianceName = guildWrapper:getAllianceName()
  if "" == allianceName then
    attackGuildInfo.txt_guildName:SetText(guildWrapper:getName())
  else
    attackGuildInfo.txt_guildName:SetText(allianceName)
  end
  local isSet = false
  if true == guildWrapper:isAllianceGuild() then
    isSet = setGuildTextureByAllianceNo(guildWrapper:guildAllianceNo_s64(), attackGuildInfo.stc_guildIcon)
  else
    isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), attackGuildInfo.stc_guildIcon)
  end
  if false == isSet then
    attackGuildInfo.stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(attackGuildInfo.stc_guildIcon, 183, 1, 188, 6)
    attackGuildInfo.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    attackGuildInfo.stc_guildIcon:setRenderTexture(attackGuildInfo.stc_guildIcon:getBaseTexture())
  else
    attackGuildInfo.stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    attackGuildInfo.stc_guildIcon:setRenderTexture(attackGuildInfo.stc_guildIcon:getBaseTexture())
  end
  local hpPercent = siegeBuildingInfo:getRemainHp() / 10000
  local roundingoffPercent = math.floor(hpPercent / 100 * 100)
  attackGuildInfo.txt_percent:SetText(tostring(roundingoffPercent) .. "%")
  attackGuildInfo.stc_progress:SetProgressRate(roundingoffPercent)
end
function PaGlobal_GuildWarInfoSmall:validate()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
end
