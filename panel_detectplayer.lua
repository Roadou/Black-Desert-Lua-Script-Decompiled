Panel_DetectPlayer:SetShow(false, false)
Panel_DetectPlayer:ActiveMouseEventEffect(true)
Panel_DetectPlayer:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local DetectPlayer = {
  _buttonFind = UI.getChildControl(Panel_DetectPlayer, "ButtonFind"),
  _editPlayerName = UI.getChildControl(Panel_DetectPlayer, "Edit_PlayerName"),
  _static_GuideMsg = UI.getChildControl(Panel_DetectPlayer, "StaticText_GuideMsg"),
  _buttonClose = UI.getChildControl(Panel_DetectPlayer, "Button_WinClose"),
  _buttonHelp = UI.getChildControl(Panel_DetectPlayer, "Button_Question")
}
DetectPlayer._buttonHelp:SetShow(false)
local editBoxClear = true
function DetectPlayer:initialize()
  self._static_GuideMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._static_GuideMsg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_GUIDEMSG"))
  self._editPlayerName:addInputEvent("Mouse_LUp", "DetectPlayer_EditClear()")
  self._buttonFind:addInputEvent("Mouse_LUp", "HandleClicked_DetectPlayer()")
  self._buttonClose:addInputEvent("Mouse_LUp", "DetectPlayer_Close()")
  self._buttonHelp:addInputEvent("Mouse_LUp", "")
end
function DetectPlayer:show()
  Panel_DetectPlayer:SetShow(true, false)
  DetectPlayer._editPlayerName:SetMaxInput(getGameServiceTypeCharacterNameLength())
  DetectPlayer._editPlayerName:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_EDITPLAYERNAME_DEFAULTMSG"), true)
  editBoxClear = true
end
function DetectPlayer_Close()
  Panel_DetectPlayer:SetShow(false, false)
  DetectPlayer._editPlayerName:SetEditText("", true)
  editBoxClear = true
  ClearFocusEdit()
end
function DetectPlayer_reload()
  DetectPlayer_Close()
  DetectPlayer:show()
end
function DetectPlayer_EditClear()
  if editBoxClear == true then
    DetectPlayer._editPlayerName:SetEditText("", true)
    editBoxClear = false
  end
  SetFocusEdit(DetectPlayer._editPlayerName)
end
function HandleClicked_DetectPlayer()
  local msgDefault = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_EDITPLAYERNAME_DEFAULTMSG")
  if nil == DetectPlayer._editPlayerName:GetEditText() or "" == DetectPlayer._editPlayerName:GetEditText() or msgDefault == DetectPlayer._editPlayerName:GetEditText() then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_NIL")
    local messageboxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionApply = DetectPlayer_reload,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif nil ~= string.find(DetectPlayer._editPlayerName:GetEditText(), " ") then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_DETECTPLAYER_ERRORMSG_PLAYERNAME_SPACE")
    local messageboxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionApply = DetectPlayer_reload,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    ToClient_DetectPlayer(DetectPlayer._editPlayerName:GetEditText())
    Panel_DetectPlayer:SetShow(false, false)
  end
end
function FromClient_OpenDetectPlayer()
  DetectPlayer:show()
end
function FromClient_CompleteDetectPlayer(position)
  FGlobal_PushOpenWorldMap()
  FromClient_RClickWorldmapPanel(position, true, false)
end
registerEvent("FromClient_OpenDetectPlayer", "FromClient_OpenDetectPlayer")
registerEvent("FromClient_CompleteDetectPlayer", "FromClient_CompleteDetectPlayer")
DetectPlayer:initialize()
