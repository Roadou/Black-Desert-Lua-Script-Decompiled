local UI_Color = Defines.Color
local positionTarget = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
Panel_NodeOwnerInfo:SetShow(false)
local nodeOwnerInfo = {
  ui = {
    _static_GuildMarkBG = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_Static_GuildMarkBG"),
    _static_GuildMark = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_Static_GuildMark"),
    _txt_GuildName_Title = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildName"),
    _txt_GuildName_Value = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildName_Value"),
    _txt_GuildMaster_Title = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildMaster"),
    _txt_GuildMaster_Value = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_GuildMaster_Value"),
    _txt_HasDate_Title = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_HasDate"),
    _txt_HasDate_Value = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_HasDate_Value"),
    _txt_NodeBonus_Title = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_NodeBonus"),
    _txt_NodeBonus_Value = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_NodeBonus_Value"),
    _txt_NowWar = UI.getChildControl(Panel_NodeOwnerInfo, "NodeInfo_StaticText_NowWar")
  },
  config = {}
}
nodeOwnerInfo.ui._txt_NodeBonus_Title:SetFontColor(UI_Color.C_FFFFD46D)
nodeOwnerInfo.ui._txt_NodeBonus_Value:SetFontColor(UI_Color.C_FFEDE699)
function nodeOwnerInfo:SetFontColor(isSiegeBeing, hasOccupant)
  if true == isSiegeBeing then
    self.ui._txt_GuildName_Title:SetFontColor(UI_Color.C_FFD20000)
    self.ui._txt_GuildMaster_Title:SetFontColor(UI_Color.C_FFD20000)
    self.ui._txt_HasDate_Title:SetFontColor(UI_Color.C_FFD20000)
  elseif true == hasOccupant then
    self.ui._txt_GuildName_Title:SetFontColor(UI_Color.C_FF00C0D7)
    self.ui._txt_GuildMaster_Title:SetFontColor(UI_Color.C_FF00C0D7)
    self.ui._txt_HasDate_Title:SetFontColor(UI_Color.C_FF00C0D7)
  else
    self.ui._txt_GuildName_Title:SetFontColor(UI_Color.C_FFEFEFEF)
    self.ui._txt_GuildMaster_Title:SetFontColor(UI_Color.C_FFEFEFEF)
    self.ui._txt_HasDate_Title:SetFontColor(UI_Color.C_FFEFEFEF)
  end
end
function nodeOwnerInfo:SetShowText(isSiegeBeing)
  self.ui._txt_GuildMaster_Title:SetShow(not isSiegeBeing)
  self.ui._txt_GuildMaster_Value:SetShow(not isSiegeBeing)
  self.ui._txt_HasDate_Title:SetShow(not isSiegeBeing)
  self.ui._txt_HasDate_Value:SetShow(not isSiegeBeing)
  self.ui._txt_NowWar:SetShow(isSiegeBeing)
end
function nodeOwnerInfo:Update(nodeStaticStatus)
  local regionInfo = nodeStaticStatus:getMinorSiegeRegion()
  if nil ~= regionInfo then
    local regionKey = regionInfo._regionKey
    local regionWrapper = getRegionInfoWrapper(regionKey:get())
    local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
    local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
    if nil ~= siegeWrapper then
      local paDate = siegeWrapper:getOccupyingDate()
      local siegeTentCount = ToClient_GetCompleteSiegeTentCount(regionKey:get())
      local dropType = regionInfo:getDropGroupRerollCountOfSieger()
      local nodeTaxType = regionInfo:getVillageTaxLevel()
      local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
      local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
      local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
      local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
      local dropTypeValue = ""
      local isSiegeBeing = minorSiegeWrapper:isSiegeBeing()
      local hasOccupantExist = siegeWrapper:doOccupantExist()
      self:SetShowText(isSiegeBeing)
      self:SetFontColor(isSiegeBeing, hasOccupantExist)
      if true == isSiegeBeing then
        local isSiegeChannel = ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
        if true == isSiegeChannel then
          self.ui._txt_NowWar:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_COUNT", "siegeTentCount", siegeTentCount))
        else
          self.ui._txt_NowWar:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_NOT_NODEWAR") .. "<PAOldColor>")
        end
        self.ui._txt_GuildName_Value:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_WAR") .. "<PAOldColor>")
        local nodeTaxLevel = 0
        if true == _ContentsGroup_SeigeSeason5 then
          nodeTaxLevel = nodeTaxType + 1
        else
          nodeTaxLevel = nodeTaxType
        end
        if 0 == dropType and nodeTaxLevel >= 1 then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
        elseif dropType >= 1 and 0 == nodeTaxType then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
        elseif dropType >= 1 and nodeTaxType >= 1 then
          dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
        else
          dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
        end
        self.ui._txt_NodeBonus_Value:SetText(dropTypeValue)
      elseif true == hasOccupantExist then
        local isAlliance = siegeWrapper:isOccupantGuildAlliance()
        local isSet = false
        if true == isAlliance then
          isSet = setGuildTextureByAllianceNo(siegeWrapper:getGuildNo(), self.ui._static_GuildMark)
        else
          isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), self.ui._static_GuildMark)
        end
        if not isSet then
          self.ui._static_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
          local x1, y1, x2, y2 = setTextureUV_Func(self.ui._static_GuildMark, 183, 1, 188, 6)
          self.ui._static_GuildMark:getBaseTexture():setUV(x1, y1, x2, y2)
          self.ui._static_GuildMark:setRenderTexture(self.ui._static_GuildMark:getBaseTexture())
        end
        self.ui._txt_GuildName_Value:SetText("<PAColor0xff00c0d7>" .. siegeWrapper:getGuildName() .. "<PAOldColor>")
        self.ui._txt_GuildMaster_Value:SetText("<PAColor0xff96d4fc>" .. siegeWrapper:getGuildMasterName() .. "<PAOldColor>")
        self.ui._txt_HasDate_Value:SetText("<PAColor0xff96d4fc>" .. year .. " " .. month .. " " .. day .. " " .. hour .. "<PAOldColor>")
        local nodeTaxLevel = 0
        if true == _ContentsGroup_SeigeSeason5 then
          nodeTaxLevel = nodeTaxType + 1
        else
          nodeTaxLevel = nodeTaxType
        end
        if 0 == dropType and nodeTaxLevel >= 1 then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
        elseif dropType >= 1 and 0 == nodeTaxType then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
        elseif dropType >= 1 and nodeTaxType >= 1 then
          dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
        else
          dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
        end
        self.ui._txt_NodeBonus_Value:SetText(dropTypeValue)
      else
        self.ui._static_GuildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(self.ui._static_GuildMark, 0, 0, 0, 0)
        self.ui._static_GuildMark:getBaseTexture():setUV(x1, y1, x2, y2)
        self.ui._static_GuildMark:setRenderTexture(self.ui._static_GuildMark:getBaseTexture())
        self.ui._txt_GuildName_Value:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR") .. "<PAOldColor>")
        self.ui._txt_GuildMaster_Value:SetText("<PAColor0xff515151>-<PAOldColor>")
        self.ui._txt_HasDate_Value:SetText("<PAColor0xff515151>-<PAOldColor>")
        local nodeTaxLevel = 0
        if true == _ContentsGroup_SeigeSeason5 then
          nodeTaxLevel = nodeTaxType + 1
        else
          nodeTaxLevel = nodeTaxType
        end
        if 0 == dropType and nodeTaxLevel >= 1 then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
        elseif dropType >= 1 and 0 == nodeTaxType then
          dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
        elseif dropType >= 1 and nodeTaxType >= 1 then
          dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
        else
          dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
        end
        self.ui._txt_NodeBonus_Value:SetText(dropTypeValue)
      end
    else
      nodeOwnerInfo:Close()
    end
  end
end
function FGlobal_nodeOwnerInfo_SetInfo(nodeStaticStatus)
  nodeOwnerInfo:Update(nodeStaticStatus)
end
function nodeOwnerInfo:Close()
  Panel_NodeOwnerInfo:SetShow(false)
end
function FGlobal_nodeOwnerInfo_SetPosition()
  Panel_NodeOwnerInfo:SetPosX(positionTarget:GetSpanSize().x + positionTarget:GetSizeX() + 10)
  Panel_NodeOwnerInfo:SetPosY(positionTarget:GetSpanSize().y)
end
function FGlobal_nodeOwnerInfo_Close()
  nodeOwnerInfo:Close()
end
