local MessageData = {
  _Msg = {}
}
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local curIndex = 0
local processIndex = 0
local animationEndTime = 2.3
local elapsedTime = 2.3
local positionAdjust = {_originX = 0, _originY = 180}
local _targetPosX, _targetPosY
local _defaultXSize = Panel_NakMessage:GetSizeX()
local _defaultYSize = Panel_NakMessage:GetSizeY()
local _text_Msg = UI.getChildControl(Panel_NakMessage, "MsgText")
_text_Msg:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
Panel_NakMessage:setFlushAble(false)
function Proc_ShowMessage_Ack(message, showRate, posX, posY, isSoundOff)
  Proc_ShowMessage_Ack_WithOut_ChattingMessage(message, showRate, isSoundOff)
  chatting_sendMessage("", message, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
  if nil == posX or nil == posY then
    _targetPosX = nil
    _targetPosY = nil
  else
    _targetPosX = posX
    _targetPosY = posY
  end
end
function Proc_ShowMessage_Ack_With_ChatType(message, showRate, chatType, chatSystemType)
  Proc_ShowMessage_Ack_WithOut_ChattingMessage(message, showRate)
  chatting_sendMessage("", message, chatType, chatSystemType)
end
function Proc_ShowBigMessage_Ack_WithOut_ChattingMessage(message)
  local messages = message
  if "table" ~= type(message) then
    messages = {
      main = message,
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_NAKMESSAGE_SELECTREWARD_MSG_SUB"),
      addMsg = ""
    }
  end
  Proc_ShowMessage_Ack_For_RewardSelect(messages, 3, 4)
end
function Proc_ShowMessage_Ack_WithOut_ChattingMessage(message, showRate, isSoundOff)
  if nil == isSoundOff or false == isSoundOff then
    _AudioPostEvent_SystemUiForXBOX(8, 1)
    audioPostEvent_SystemUi(8, 1)
  end
  if nil == showRate then
    animationEndTime = 2.3
    elapsedTime = 2.3
  else
    animationEndTime = showRate
    elapsedTime = showRate
  end
  curIndex = curIndex + 1
  MessageData._Msg[curIndex] = message
  Panel_NakMessage:SetShow(true, false)
end
local frameEventMessageIds = {
  [0] = "LUA_FRAMEEVENT_TOO_LESS_HP",
  "LUA_FRAMEEVENT_TOO_MANY_DETERMINATION",
  "LUA_FRAMEEVENT_TOO_MANY_HP",
  "LUA_FRAMEEVENT_TOO_LESS_MP",
  "LUA_FRAMEEVENT_NOT_EXIST_COMBINE_WAVE_TARGET",
  "LUA_FRAMEEVENT_NOT_EXIST_EQUIPITEM",
  "LUA_FRAMEEVENT_NOT_TAMING_1",
  "LUA_FRAMEEVENT_NOT_PHANTOMCOUNT",
  "LUA_FRAMEEVENT_NOT_CANNON_SHOT",
  "LUA_FRAMEEVENT_NOT_CANNON_BALL_SHOT",
  "LUA_FRAMEEVENT_NOT_HORES_HP_UP",
  "LUA_FRAMEEVENT_NOT_HORES_MP_UP",
  "LUA_FRAMEEVENT_NOT_HORES_SPEED_UP",
  "LUA_FRAMEEVENT_NOT_SORCERESS_GROGGY",
  "LUA_FRAMEEVENT_NOT_MANY_HOLY",
  "LUA_RENTALSHIP_CANNON_FAIL"
}
function Proc_ShowMessage_FrameEvent(messageNum)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, frameEventMessageIds[messageNum]))
end
function MessageOpen()
  local axisY = 0
  Panel_NakMessage:ResetAndClearVertexAni()
  if true == ToClient_isConsole() then
    Panel_NakMessage:SetSize(math.max(_text_Msg:GetTextSizeX() + 40, _defaultXSize), _text_Msg:GetTextSizeY() + 20)
  end
  local aniInfo = Panel_NakMessage:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  if false == ToClient_isConsole() then
    local aniInfo1 = Panel_NakMessage:addScaleAnimation(0, 3.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    aniInfo1:SetStartScale(0.85)
    aniInfo1:SetEndScale(1)
    aniInfo1.AxisY = axisY
    aniInfo1.ScaleType = 2
    aniInfo1.IsChangeChild = true
    local aniInfo2 = Panel_NakMessage:addScaleAnimation(0.15, animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
    aniInfo2:SetStartScale(1)
    aniInfo2:SetEndScale(1)
    aniInfo2.AxisY = axisY
    aniInfo2.ScaleType = 2
    aniInfo2.IsChangeChild = true
  end
  local aniInfo3 = Panel_NakMessage:addColorAnimation(animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  if false == ToClient_isConsole() then
    local aniInfo4 = Panel_NakMessage:addScaleAnimation(animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo4:SetStartScale(1)
    aniInfo4:SetEndScale(0.7)
    aniInfo4.AxisY = axisY
    aniInfo4.ScaleType = 2
    aniInfo4.IsChangeChild = true
  end
end
local tempMsg
function NakMessageUpdate(updateTime)
  elapsedTime = elapsedTime + updateTime
  if elapsedTime >= animationEndTime then
    if processIndex < curIndex then
      processIndex = processIndex + 1
      tempMsg = MessageData._Msg[processIndex]
      _text_Msg:SetText(MessageData._Msg[processIndex])
      MessageOpen()
      Panel_NakMessage:SetShow(true, false)
      if nil ~= _targetPosX and nil ~= _targetPosY then
        Panel_NakMessage:SetPosX(_targetPosX)
        Panel_NakMessage:SetPosY(_targetPosY)
        _targetPosX = nil
        _targetPosY = nil
      else
        Panel_NakMessage:SetPosX((getOriginScreenSizeX() - Panel_NakMessage:GetSizeX()) * 0.5)
        Panel_NakMessage:SetPosY(positionAdjust._originY)
      end
      _text_Msg:ComputePos()
      MessageData._Msg[processIndex] = nil
      elapsedTime = 0
    else
      Panel_NakMessage:SetShow(false, false)
      curIndex = 0
      processIndex = 0
    end
  elseif processIndex < curIndex and tempMsg == MessageData._Msg[processIndex + 1] then
    processIndex = processIndex + 1
    MessageData._Msg[processIndex] = nil
    if true == ToClient_isConsole() then
      Panel_NakMessage:SetSize(_defaultXSize, _defaultYSize)
    end
    MessageOpen()
  end
end
function NakMessagePanel_Reset()
  curIndex = 0
  processIndex = 0
  MessageData._Msg = {}
end
function NakMessagePanel_Resize()
  local val = (getOriginScreenSizeX() - Panel_NakMessage:GetSizeX()) * 0.5
  Panel_NakMessage:SetPosX(val)
  positionAdjust._originX = val
end
function renderModeChange_NakMessagePostRestoreFunction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 0 ~= processIndex then
    Panel_NakMessage:SetShow(true, false)
  end
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_NakMessagePostRestoreFunction")
NakMessagePanel_Resize()
Panel_NakMessage:RegisterUpdateFunc("NakMessageUpdate")
registerEvent("showMessage_ack", "Proc_ShowMessage_Ack_WithOut_ChattingMessage")
registerEvent("showBigMessage_ack", "Proc_ShowBigMessage_Ack_WithOut_ChattingMessage")
registerEvent("showMessage_FrameEvent", "Proc_ShowMessage_FrameEvent")
registerEvent("onScreenResize", "NakMessagePanel_Resize")
