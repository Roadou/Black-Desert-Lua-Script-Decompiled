local _panel = Panel_Window_NationSiege
local Panel_Window_NationSiege = {
  _ui = {
    _stc_title = UI.getChildControl(_panel, "StaticText_Title"),
    _btn_close = UI.getChildControl(_panel, "Button_Close"),
    _stc_calphonBG = UI.getChildControl(_panel, "Static_CalpheonBG"),
    _stc_valenciaBG = UI.getChildControl(_panel, "Static_ValenciaBG"),
    _calPheonGuild_List = UI.getChildControl(_panel, "List2_CalpheonGuild"),
    _valenciaGuild_List = UI.getChildControl(_panel, "List2_ValenciaGuild")
  }
}
function Panel_Window_NationSiege:Init_LeftNationGuild()
  self._ui._calPheonGuild_List:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_NationSiege_LeftListUpdate")
  self._ui._calPheonGuild_List:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local wrapper = ToClient_getNationSiegeTeamWrapper(2)
  if nil == wrapper then
    self._ui._stc_NoneGuild_TextNotice_calpheon:SetShow(true)
    self._ui._stc_NoneGuild_BG_calpheon:SetShow(true)
    self._ui._stc_JoinGuildBG_calpheon:SetShow(true)
    self._ui._stc_JoinGuild_TitleText_calpheon:SetShow(true)
    return
  else
    self._ui._stc_NoneGuild_TextNotice_calpheon:SetShow(false)
    self._ui._stc_NoneGuild_BG_calpheon:SetShow(true)
    self._ui._stc_JoinGuildBG_calpheon:SetShow(true)
    self._ui._stc_JoinGuild_TitleText_calpheon:SetShow(true)
  end
  local guildCount = wrapper:getGuildCount()
  if 0 == guildCount then
  else
    for ii = 1, guildCount do
      self._ui._calPheonGuild_List:getElementManager():pushKey(toInt64(0, ii))
    end
  end
end
function PaGlobal_NationSiege_LeftListUpdate(contents, index)
  local guildInfo = {
    stc_contentBG = UI.getChildControl(contents, "Static_ContentBG"),
    stc_guildIcon = UI.getChildControl(contents, "Static_GuildIcon"),
    txt_guildName = UI.getChildControl(contents, "StaticText_GuildName"),
    stc_guildBG = UI.getChildControl(contents, "Static_GuildIconBG"),
    stc_line = UI.getChildControl(contents, "Static_Line"),
    stc_masterIcon = UI.getChildControl(contents, "Static_MasterIcon")
  }
  local index32 = Int64toInt32(index)
  local wrapper = ToClient_getNationSiegeTeamWrapper(2)
  if nil == wrapper then
    return
  end
  local siegeWarName = wrapper:getRegionNameByIndex(index32 - 1)
  local guildName = wrapper:getGuildNameByIndex(index32 - 1)
  guildInfo.stc_contentBG:addInputEvent("Mouse_On", "HandleOver_GuildList_SiegeArea_Show(\"" .. guildName .. "\",\"" .. siegeWarName .. "\"" .. ")")
  guildInfo.stc_contentBG:addInputEvent("Mouse_Out", "HandleOver_GuildList_SiegeArea_Hide()")
  guildInfo.txt_guildName:SetText(guildName)
  guildInfo.txt_guildName:SetFontColor(Defines.Color.C_FFFFFFFF)
  if true == wrapper:isKingByIndex(index32 - 1) then
    guildInfo.stc_masterIcon:SetShow(true)
  else
    guildInfo.stc_masterIcon:SetShow(false)
  end
  local isSet = setGuildTextureByGuildNo(wrapper:getGuildNoRawByIndex(index32 - 1), guildInfo.stc_guildIcon)
  if false == isSet then
    guildInfo.stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(guildInfo.stc_guildIcon, 183, 1, 188, 6)
    guildInfo.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    guildInfo.stc_guildIcon:setRenderTexture(guildInfo.stc_guildIcon:getBaseTexture())
  else
    guildInfo.stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    guildInfo.stc_guildIcon:setRenderTexture(guildInfo.stc_guildIcon:getBaseTexture())
  end
end
function Panel_Window_NationSiege:Init_RightNationGuild()
  self._ui._valenciaGuild_List:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_NationSiege_RightListUpdate")
  self._ui._valenciaGuild_List:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local wrapper = ToClient_getNationSiegeTeamWrapper(4)
  if nil == wrapper then
    self._ui._stc_NoneGuild_TextNotice_valencia:SetShow(true)
    self._ui._stc_NoneGuild_BG_valencia:SetShow(true)
    self._ui._stc_JoinGuild_TitleText_valencia:SetShow(true)
    self._ui._stc_JoinGuildBG_valencia:SetShow(true)
    return
  else
    self._ui._stc_NoneGuild_TextNotice_valencia:SetShow(false)
    self._ui._stc_NoneGuild_BG_valencia:SetShow(true)
    self._ui._stc_JoinGuild_TitleText_valencia:SetShow(true)
    self._ui._stc_JoinGuildBG_valencia:SetShow(true)
  end
  local guildCount = wrapper:getGuildCount()
  if 0 == guildCount then
  else
    for ii = 1, guildCount do
      self._ui._valenciaGuild_List:getElementManager():pushKey(toInt64(0, ii))
    end
  end
end
function PaGlobal_NationSiege_RightListUpdate(contents, index)
  local guildInfo = {
    stc_contentBG = UI.getChildControl(contents, "Static_ContentBG"),
    stc_guildIcon = UI.getChildControl(contents, "Static_GuildIcon"),
    txt_guildName = UI.getChildControl(contents, "StaticText_GuildName"),
    stc_guildBG = UI.getChildControl(contents, "Static_GuildIconBG"),
    stc_line = UI.getChildControl(contents, "Static_Line"),
    stc_masterIcon = UI.getChildControl(contents, "Static_MasterIcon")
  }
  local index32 = Int64toInt32(index)
  local wrapper = ToClient_getNationSiegeTeamWrapper(4)
  if nil == wrapper then
    return
  end
  local siegeWarName = wrapper:getRegionNameByIndex(index32 - 1)
  local guildName = wrapper:getGuildNameByIndex(index32 - 1)
  guildInfo.stc_contentBG:addInputEvent("Mouse_On", "HandleOver_GuildList_SiegeArea_Show(\"" .. guildName .. "\",\"" .. siegeWarName .. "\"" .. ")")
  guildInfo.stc_contentBG:addInputEvent("Mouse_Out", "HandleOver_GuildList_SiegeArea_Hide()")
  guildInfo.txt_guildName:SetText(guildName)
  guildInfo.txt_guildName:SetFontColor(Defines.Color.C_FFFFFFFF)
  if true == wrapper:isKingByIndex(index32 - 1) then
    guildInfo.stc_masterIcon:SetShow(true)
  else
    guildInfo.stc_masterIcon:SetShow(false)
  end
  local isSet = setGuildTextureByGuildNo(wrapper:getGuildNoRawByIndex(index32 - 1), guildInfo.stc_guildIcon)
  if false == isSet then
    guildInfo.stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(guildInfo.stc_guildIcon, 183, 1, 188, 6)
    guildInfo.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    guildInfo.stc_guildIcon:setRenderTexture(guildInfo.stc_guildIcon:getBaseTexture())
  else
    guildInfo.stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    guildInfo.stc_guildIcon:setRenderTexture(guildInfo.stc_guildIcon:getBaseTexture())
  end
end
function HandleOver_GuildList_SiegeArea_Show(guildName, siegesName)
  TooltipSimple_CommonShow(guildName, siegesName)
  TooltipSimple_Common_Pos(getMousePosX() + 15, getMousePosY() + 15)
end
function HandleOver_GuildList_SiegeArea_Hide()
  TooltipSimple_Hide()
end
function Panel_Window_NationSiege:open()
  audioPostEvent_SystemUi(1, 18)
  _panel:SetShow(true)
  self:Init_LeftNationGuild()
  self:Init_RightNationGuild()
  PaGlobal_NationSiegeGuide_Open()
end
function Panel_Window_NationSiege:close()
  _panel:SetShow(false)
end
function PaGlobal_Panel_Window_NationSiege_ShowToggle()
  local self = Panel_Window_NationSiege
  if _panel:GetShow() then
    self:close()
  else
    self:open()
  end
end
function PaGlobal_Panel_Window_NationSiege_Close()
  local self = Panel_Window_NationSiege
  self:close()
end
function Panel_Window_NationSiege:initialize()
  self._ui._btn_close:addInputEvent("Mouse_LUp", "PaGlobal_Panel_Window_NationSiege_Close()")
  self._ui._stc_JoinGuildBG_calpheon = UI.getChildControl(self._ui._stc_calphonBG, "Static_JoinGuildBG")
  self._ui._stc_JoinGuild_TitleText_calpheon = UI.getChildControl(self._ui._stc_calphonBG, "StaticText_JoinGuildTitle")
  self._ui._stc_NoneGuild_TextNotice_calpheon = UI.getChildControl(self._ui._stc_calphonBG, "StaticText_NoneGuild")
  self._ui._stc_NoneGuild_BG_calpheon = UI.getChildControl(self._ui._stc_calphonBG, "Static_NoneGuildBG")
  self._ui._stc_JoinGuildBG_valencia = UI.getChildControl(self._ui._stc_valenciaBG, "Static_JoinGuildBG")
  self._ui._stc_JoinGuild_TitleText_valencia = UI.getChildControl(self._ui._stc_valenciaBG, "StaticText_JoinGuildTitle")
  self._ui._stc_NoneGuild_TextNotice_valencia = UI.getChildControl(self._ui._stc_valenciaBG, "StaticText_NoneGuild")
  self._ui._stc_NoneGuild_BG_valencia = UI.getChildControl(self._ui._stc_valenciaBG, "Static_NoneGuildBG")
end
function PaGlobal_Panel_Window_NationSiege_Init()
  local self = Panel_Window_NationSiege
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_Panel_Window_NationSiege_Init")
