function PaGlobal_GuildWarInfoSmall_Open(territoryKey)
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if false == PaGlobal_GuildWarInfoSmall._initialize then
    return
  end
  if nil == territoryKey then
    return
  end
  PaGlobal_GuildWarInfoSmall:prepareOpen(territoryKey)
  PaGlobal_GuildWarInfoSmall:open()
end
function PaGlobal_GuildWarInfoSmall_Close()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall:prepareClose()
  PaGlobal_GuildWarInfoSmall:close()
end
function PaGlobal_GuildWarInfoSmall_GetShow()
  if nil == Panel_Window_GuildWarInfoSmall then
    return false
  end
  return Panel_Window_GuildWarInfoSmall:GetShow()
end
function HandleEventLUp_GuildWarInfoSmall_Close()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall_Close()
end
function PaGlobal_GuildWarInfoSmall_UpdatePerFrame(deltaTime)
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._refreshTimer = PaGlobal_GuildWarInfoSmall._refreshTimer + deltaTime
  if PaGlobal_GuildWarInfoSmall._refreshTimer > 30 then
    ToClient_RequestSiegeScore(PaGlobal_GuildWarInfoSmall._siegeRegion)
    PaGlobal_GuildWarInfoSmall._refreshTimer = 0
  end
end
function HandleEventLUp_GuildWarInfoSmall_Refresh()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if 5 < PaGlobal_GuildWarInfoSmall._refreshTimer then
    ToClient_RequestSiegeScore(PaGlobal_GuildWarInfoSmall._siegeRegion)
    PaGlobal_GuildWarInfoSmall._refreshTimer = 0
  end
end
function HandleEventLUp_GuildWarInfoSmall_BigWinChange()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if nil ~= FGlobal_GuildWarInfo_renew_ChangeOpen then
    FGlobal_GuildWarInfo_renew_ChangeOpen(PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:GetSelectIndex())
  elseif nil ~= FGlobal_GuildWarInfo_renew_Open then
    FGlobal_GuildWarInfo_renew_Open()
  end
  PaGlobal_GuildWarInfoSmall_Close()
end
function PaGlobal_GuildWarInfoSmall:comboSet()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:SetSelectItemIndex(PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:GetSelectIndex())
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:ToggleListbox()
  PaGlobal_GuildWarInfoSmall:update(PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:GetSelectIndex())
  audioPostEvent_SystemUi(0, 0)
end
function PaGlobal_GuildWarInfoSmall:comboShow()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall._ui._stc_comboBox:ToggleListbox()
end
function PaGlobal_GuildWarInfoSmall:bigWindowTooltipShow()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SMALL_TO_BIG_TOOLTIP_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_SMALL_TO_BIG_TOOLTIP_DESC")
  local uiControl = PaGlobal_GuildWarInfoSmall._ui._btn_bigWin
  TooltipSimple_Show(uiControl, name, desc)
end
function PaGlobal_GuildWarInfoSmall:bigWindowTooltipHide()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  TooltipSimple_Hide()
end
function HandleEventLUp_GuildWarInfoSmall_ComboShow()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall:comboShow()
end
function HandleEventLUp_GuildWarInfoSmall_ComboSet()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall:comboSet()
end
function HandleEventOn_GuildWarInfoSmall_BigWinToolTipShow()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall:bigWindowTooltipShow()
end
function HandleEventOn_GuildWarInfoSmall_BigWinToolTipHide()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  PaGlobal_GuildWarInfoSmall:bigWindowTooltipHide()
end
function FromClient_GuildWarInfoSmall_SiegeScoreUpdateData()
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if false == PaGlobal_GuildWarInfoSmall._initialize then
    return
  end
  if false == PaGlobal_GuildWarInfoSmall_GetShow() then
    return
  end
  PaGlobal_GuildWarInfoSmall:update(PaGlobal_GuildWarInfoSmall._siegeRegion)
end
function FromClient_GuildWarInfoSmall_NotifyStartSiege(msgtype, regionKeyRaw)
  if nil == Panel_Window_GuildWarInfoSmall then
    return
  end
  if false == PaGlobal_GuildWarInfoSmall._initialize then
    return
  end
  if false == PaGlobal_GuildWarInfoSmall_GetShow() then
    return
  end
  if 0 == msgtype or 1 == msgtype then
    PaGlobal_GuildWarInfoSmall:update(PaGlobal_GuildWarInfoSmall._siegeRegion)
  end
end
