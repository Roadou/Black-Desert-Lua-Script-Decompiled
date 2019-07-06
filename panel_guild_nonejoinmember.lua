local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
PaGlobal_Guild_NoneJoinMember = {
  btn_Close = nil,
  btn_GuildNPCNavi = nil,
  btn_GuidlRank = nil,
  _frame = nil
}
function PaGlobal_Guild_NoneJoinMember:Initialize()
  if nil == Panel_Guild_NoneJoinMember then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_NoneJoinMember:SetShow(false)
  end
  PaGlobal_Guild_NoneJoinMember.btn_Close = UI.getChildControl(Panel_Guild_NoneJoinMember, "Button_Close")
  PaGlobal_Guild_NoneJoinMember.btn_GuildNPCNavi = UI.getChildControl(Panel_Guild_NoneJoinMember, "Button_GuildNPCNavi")
  PaGlobal_Guild_NoneJoinMember.btn_GuidlRank = UI.getChildControl(Panel_Guild_NoneJoinMember, "Button_GuildRank")
  PaGlobal_Guild_NoneJoinMember._frame = UI.getChildControl(Panel_Guild_NoneJoinMember, "Frame_GuildDesc")
  PaGlobal_Guild_NoneJoinMember._frame_GuildContents = UI.getChildControl(PaGlobal_Guild_NoneJoinMember._frame, "Frame_1_Content")
  local guildDesc = UI.getChildControl(PaGlobal_Guild_NoneJoinMember._frame_GuildContents, "StaticText_Desc")
  guildDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  guildDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_NONEJOINMEMBER_DESC"))
  guildDesc:SetSize(guildDesc:GetSizeX(), guildDesc:GetTextSizeY())
  self._frame_GuildContents:SetSize(self._frame_GuildContents:GetSizeX(), guildDesc:GetTextSizeY())
  self._frame:UpdateContentPos()
  self._frame:UpdateContentScroll()
  if isGameTypeGT() then
    self.btn_GuidlRank:SetShow(false)
    self.btn_GuildNPCNavi:SetPosX(Panel_Guild_NoneJoinMember:GetSizeX() / 2 - self.btn_GuildNPCNavi:GetSizeX() / 2)
  end
  PaGlobal_SeasonTexture_SetPanel(Panel_Guild_NoneJoinMember)
end
function PaGlobal_Guild_NoneJoinMember:Open()
  PaGlobal_GuildNonJoinMember_CheckLoadUI()
  audioPostEvent_SystemUi(1, 30)
  _AudioPostEvent_SystemUiForXBOX(1, 30)
end
function PaGlobal_Guild_NoneJoinMember:Close()
  PaGlobal_GuildNonJoinMember_CheckCloseUI()
  audioPostEvent_SystemUi(1, 31)
  _AudioPostEvent_SystemUiForXBOX(1, 31)
end
function PaGlobal_Guild_NoneJoinMember:GuildNpcNavi()
  HandleClicked_TownNpcIcon_NaviStart(11)
end
function PaGlobal_Guild_NoneJoinMember:GuildRankOpen()
  GuildRank_Web_Show()
end
function PaGlobal_Guild_NoneJoinMember_OnScreenSizeRefresh()
  if nil == Panel_Guild_NoneJoinMember then
    return
  end
  Panel_Guild_NoneJoinMember:ComputePos()
end
function PaGlobal_Guild_NoneJoinMember:SimpleTooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == Panel_Guild_NoneJoinMember then
    return
  end
  local name, desc, control
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_NONEJOINMEMBER_GUILDNAVI")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NONEJOINMEMBER_CREATEGUILD_DESC")
    control = self.btn_GuildNPCNavi
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILD_RANK_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_NONEJOINMEMBER_GUILDRANK_DESC")
    control = self.btn_GuidlRank
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_Guild_NoneJoinMember:EventHandler()
  if nil == Panel_Guild_NoneJoinMember then
    return
  end
  Panel_Guild_NoneJoinMember:RegisterCloseLuaFunc(PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape
  }), "PaGlobal_Guild_NoneJoinMember:Close()")
  self.btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Guild_NoneJoinMember:Close()")
  self.btn_GuildNPCNavi:addInputEvent("Mouse_LUp", "PaGlobal_Guild_NoneJoinMember:GuildNpcNavi()")
  self.btn_GuidlRank:addInputEvent("Mouse_LUp", "PaGlobal_Guild_NoneJoinMember:GuildRankOpen()")
  self.btn_GuildNPCNavi:addInputEvent("Mouse_On", "PaGlobal_Guild_NoneJoinMember:SimpleTooltips(true, 0)")
  self.btn_GuildNPCNavi:addInputEvent("Mouse_Out", "PaGlobal_Guild_NoneJoinMember:SimpleTooltips(false)")
  self.btn_GuidlRank:addInputEvent("Mouse_On", "PaGlobal_Guild_NoneJoinMember:SimpleTooltips(true, 1)")
  self.btn_GuidlRank:addInputEvent("Mouse_Out", "PaGlobal_Guild_NoneJoinMember:SimpleTooltips(false)")
end
function PaGlobal_Guild_NoneJoinMember:registMessageHandler()
  registerEvent("onScreenResize", "PaGlobal_Guild_NoneJoinMember_OnScreenSizeRefresh")
end
function PaGlobal_GuildNonJoinMember_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_NoneJoinMember:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_NoneJoinMember.XML", "Panel_Guild_NoneJoinMember", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_Guild_NoneJoinMember = rv
    rv = nil
    PaGlobal_GuildNoneJoinMember_Init()
  end
  Panel_Guild_NoneJoinMember:SetShow(true)
end
function PaGlobal_GuildNonJoinMember_CheckCloseUI()
  if nil == Panel_Guild_NoneJoinMember then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_Guild_NoneJoinMember:SetShow(false)
  else
    reqCloseUI(Panel_Guild_NoneJoinMember)
  end
end
function PaGlobal_GuildNonJoinMember_GetShow()
  if nil == Panel_Guild_NoneJoinMember then
    return false
  end
  return Panel_Guild_NoneJoinMember:GetShow()
end
function FromClient_GuildNonJoinMember_Init()
  PaGlobal_GuildNoneJoinMember_Init()
  PaGlobal_Guild_NoneJoinMember:registMessageHandler()
end
function PaGlobal_GuildNoneJoinMember_Init()
  PaGlobal_Guild_NoneJoinMember:Initialize()
  PaGlobal_Guild_NoneJoinMember:EventHandler()
end
function PaGlobal_GuildNonJoinMember_SetShow(isShow)
  if true == isShow then
    PaGlobal_GuildNonJoinMember_CheckLoadUI()
  else
    PaGlobal_GuildNonJoinMember_CheckCloseUI()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildNonJoinMember_Init")
