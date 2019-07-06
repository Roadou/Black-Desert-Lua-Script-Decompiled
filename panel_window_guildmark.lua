local _panel = Panel_Window_GuildMark
_panel:ignorePadSnapMoveToOtherPanel()
local GuildMark = {
  _ui = {
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _keyguide = {},
  _markBgTable = {},
  _markIconTable = {},
  _maxMarkBg = 9,
  _maxMarkIcon = 9,
  _currentBgIdx = 0,
  _currentIconIdx = 0,
  _prevBgIdx = -1,
  _prevIconIdx = -1
}
local _markBgUV = {
  [0] = {
    x1 = 0,
    y1 = 0,
    x2 = 1,
    y2 = 1
  },
  {
    x1 = 1,
    y1 = 1,
    x2 = 98,
    y2 = 98
  },
  {
    x1 = 99,
    y1 = 1,
    x2 = 196,
    y2 = 98
  },
  {
    x1 = 197,
    y1 = 1,
    x2 = 294,
    y2 = 98
  },
  {
    x1 = 295,
    y1 = 1,
    x2 = 392,
    y2 = 98
  },
  {
    x1 = 393,
    y1 = 1,
    x2 = 490,
    y2 = 98
  },
  {
    x1 = 1,
    y1 = 99,
    x2 = 98,
    y2 = 196
  },
  {
    x1 = 99,
    y1 = 99,
    x2 = 196,
    y2 = 196
  },
  {
    x1 = 197,
    y1 = 99,
    x2 = 294,
    y2 = 196
  },
  {
    x1 = 295,
    y1 = 99,
    x2 = 392,
    y2 = 196
  }
}
local _markIconUV = {
  [0] = {
    x1 = 0,
    y1 = 0,
    x2 = 1,
    y2 = 1
  },
  {
    x1 = 1,
    y1 = 197,
    x2 = 98,
    y2 = 294
  },
  {
    x1 = 99,
    y1 = 197,
    x2 = 196,
    y2 = 294
  },
  {
    x1 = 197,
    y1 = 197,
    x2 = 294,
    y2 = 294
  },
  {
    x1 = 295,
    y1 = 197,
    x2 = 392,
    y2 = 294
  },
  {
    x1 = 393,
    y1 = 197,
    x2 = 490,
    y2 = 294
  },
  {
    x1 = 1,
    y1 = 295,
    x2 = 98,
    y2 = 392
  },
  {
    x1 = 99,
    y1 = 295,
    x2 = 196,
    y2 = 392
  },
  {
    x1 = 197,
    y1 = 295,
    x2 = 294,
    y2 = 392
  },
  {
    x1 = 295,
    y1 = 295,
    x2 = 392,
    y2 = 392
  }
}
function GuildMark:init()
  self._ui.stc_CurrentBg = UI.getChildControl(self._ui.stc_CenterBg, "Static_CurrentBg")
  self._ui.stc_CurrentIcon = UI.getChildControl(self._ui.stc_CenterBg, "Static_CurrentIcon")
  self._ui.txt_GuildName = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_GuildName")
  self._ui.stc_BackGround = UI.getChildControl(self._ui.stc_CenterBg, "Static_BackgroundBg")
  self._ui.stc_BgFocus = UI.getChildControl(self._ui.stc_BackGround, "Static_FocusBg")
  for bgIdx = 1, self._maxMarkBg do
    self._markBgTable[bgIdx] = UI.getChildControl(self._ui.stc_BackGround, "Static_Bg" .. tostring(bgIdx))
    self._markBgTable[bgIdx]:addInputEvent("Mouse_LUp", "InputMLUp_GuildMark_SelectMarkBackground(" .. bgIdx .. ")")
  end
  self._ui.stc_Icon = UI.getChildControl(self._ui.stc_CenterBg, "Static_IconBg")
  self._ui.stc_IconFocus = UI.getChildControl(self._ui.stc_Icon, "Static_FocusBg")
  for iconIdx = 1, self._maxMarkIcon do
    self._markIconTable[iconIdx] = UI.getChildControl(self._ui.stc_Icon, "Static_Bg" .. tostring(iconIdx))
    self._markIconTable[iconIdx]:addInputEvent("Mouse_LUp", "InputMLUp_GuildMark_SelectMarkIcon(" .. iconIdx .. ")")
  end
  self._ui.txt_BConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  self._ui.txt_YConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Y_ConsoleUI")
  self._keyguide = {
    self._ui.txt_BConsoleUI,
    self._ui.txt_YConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  self:registEvent()
end
function GuildMark:registEvent()
  PaGlobal_registerPanelOnBlackBackground(_panel)
end
function GuildMark:open()
  self:update()
  _panel:SetShow(true)
end
function GuildMark:update()
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    self:close()
    return
  end
  local data = getGuildMarkIndexByGuildNoForXBox(guildWrapper:getGuildNo_s64())
  self._currentIconIdx = data:getIconIdx()
  self._currentBgIdx = data:getBackGroundIdx()
  self._prevIconIdx = data:getIconIdx()
  self._prevBgIdx = data:getBackGroundIdx()
  InputMLUp_GuildMark_SelectMarkBackground(self._currentBgIdx)
  InputMLUp_GuildMark_SelectMarkIcon(self._currentIconIdx)
  self._ui.txt_GuildName:SetText(guildWrapper:getName())
end
function GuildMark:close()
  _panel:SetShow(false)
end
function GuildMark:isCanRegistMark()
  if self._prevBgIdx == self._currentBgIdx and self._prevIconIdx == self._currentIconIdx then
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
    self._ui.txt_YConsoleUI:SetShow(false)
  else
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputMLUp_GuildMark_Confirm()")
    self._ui.txt_YConsoleUI:SetShow(true)
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
end
function PaGlobalFunc_GuildMark_Open()
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  self:open()
end
function PaGlobalFunc_GuildMark_Init()
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  self:init()
end
function PaGlobalFunc_GuildMark_GetBackGroundUV(idx)
  return _markBgUV[idx].x1, _markBgUV[idx].y1, _markBgUV[idx].x2, _markBgUV[idx].y2
end
function PaGlobalFunc_GuildMark_GetIconUV(idx)
  return _markIconUV[idx].x1, _markIconUV[idx].y1, _markIconUV[idx].x2, _markIconUV[idx].y2
end
function PaGlobalFunc_GuildMark_SetGuildMarkControl(bgControl, iconControl, actorKey)
  if nil == actorKey then
    return
  end
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  local iconIdx = 0
  local bgIdx = 0
  local idxData = getGuildMarkIndexByActorKeyForXBox(actorKey)
  if nil == idxData then
    return
  end
  iconIdx = idxData:getIconIdx()
  bgIdx = idxData:getBackGroundIdx()
  if nil ~= bgControl and bgIdx >= 0 and bgIdx <= self._maxMarkBg then
    bgControl:ChangeTextureInfoNameAsync("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(bgControl, _markBgUV[bgIdx].x1, _markBgUV[bgIdx].y1, _markBgUV[bgIdx].x2, _markBgUV[bgIdx].y2)
    bgControl:getBaseTexture():setUV(x1, y1, x2, y2)
    bgControl:setRenderTexture(bgControl:getBaseTexture())
  end
  if nil ~= iconControl and iconIdx >= 0 and iconIdx <= self._maxMarkIcon then
    iconControl:ChangeTextureInfoNameAsync("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(iconControl, _markIconUV[iconIdx].x1, _markIconUV[iconIdx].y1, _markIconUV[iconIdx].x2, _markIconUV[iconIdx].y2)
    iconControl:getBaseTexture():setUV(x1, y1, x2, y2)
    iconControl:setRenderTexture(iconControl:getBaseTexture())
  end
end
function InputMLUp_GuildMark_Close()
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function InputMLUp_GuildMark_Confirm()
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  if self._currentBgIdx < 1 or 1 > self._currentIconIdx then
    local text = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDMARK_SELECTCORRECTMARK")
    Proc_ShowMessage_Ack(text)
    return
  end
  if self._prevBgIdx == self._currentBgIdx and self._prevIconIdx == self._currentIconIdx then
    return
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_ADDMARK_MESSAGEBOX_TEXT2"),
    functionYes = PaGlobalFunc_GuildMark_ChangeMarkContinue,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PA_UI_CONTROL_TYPE.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_GuildMark_ChangeMarkContinue()
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  guildMarkUpdateForXBox(self._currentBgIdx, self._currentIconIdx, false)
  self:close()
end
function InputMLUp_GuildMark_SelectMarkBackground(idx)
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  if idx == 0 then
    self._ui.stc_BgFocus:SetShow(false)
  else
    local Xpos = self._markBgTable[idx]:GetPosX() - 5
    local Ypos = self._markBgTable[idx]:GetPosY() - 5
    self._ui.stc_BgFocus:SetPosXY(Xpos, Ypos)
    self._ui.stc_BgFocus:SetShow(true)
  end
  self._ui.stc_CurrentBg:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_CurrentBg, _markBgUV[idx].x1, _markBgUV[idx].y1, _markBgUV[idx].x2, _markBgUV[idx].y2)
  self._ui.stc_CurrentBg:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_CurrentBg:setRenderTexture(self._ui.stc_CurrentBg:getBaseTexture())
  self._currentBgIdx = idx
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:isCanRegistMark()
end
function InputMLUp_GuildMark_SelectMarkIcon(idx)
  local self = GuildMark
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildMark")
    return
  end
  if idx == 0 then
    self._ui.stc_IconFocus:SetShow(false)
  else
    local Xpos = self._markIconTable[idx]:GetPosX() - 5
    local Ypos = self._markIconTable[idx]:GetPosY() - 5
    self._ui.stc_IconFocus:SetPosXY(Xpos, Ypos)
    self._ui.stc_IconFocus:SetShow(true)
  end
  self._ui.stc_CurrentIcon:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_CurrentIcon, _markIconUV[idx].x1, _markIconUV[idx].y1, _markIconUV[idx].x2, _markIconUV[idx].y2)
  self._ui.stc_CurrentIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.stc_CurrentIcon:setRenderTexture(self._ui.stc_CurrentIcon:getBaseTexture())
  self._currentIconIdx = idx
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:isCanRegistMark()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildMark_Init")
