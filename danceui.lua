local renderMode = RenderModeWrapper.new(100, {
  Defines.RenderMode.eRenderMode_IngameCustomize
}, false)
function Dance_Open()
  if isDeadInWatchingMode() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BEAUTYOPENALERT_INDEAD"))
    return
  end
  ToClient_SaveUiInfo(false)
  if isFlushedUI() then
    return
  end
  local terraintype = selfPlayerNaviMaterial()
  if 8 == terraintype or 9 == terraintype then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DONTOPEN_INWATER"))
    return
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return
  end
  if nil == getGameDanceEditor() or true == getGameDanceEditor():isShow() or getGameDanceEditor():show() == false then
    return
  end
  if Panel_Win_System:GetShow() then
    allClearMessageData()
  end
  SetUIMode(Defines.UIMode.eUIMode_InGameDance)
  renderMode:set()
end
function Dance_Show(show)
  Panel_DanceEdit:SetShow(show, false)
  Panel_DanceAction:SetShow(show, false)
  if show == true then
  else
  end
end
function Dance_ShowUpUI()
  Dance_Show(true)
end
function Dance_Close()
  Dance_Show(false)
  getGameDanceEditor():hide()
  renderMode:reset()
  SetUIMode(Defines.UIMode.eUIMode_Default)
end
registerEvent("OpenDanceInfoUI", "Dance_Open")
registerEvent("Dance_ShowUpUI", "Dance_ShowUpUI")
