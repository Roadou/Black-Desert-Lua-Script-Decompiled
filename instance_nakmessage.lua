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
local _defaultXSize = Instance_NakMessage:GetSizeX()
local _text_Msg = UI.getChildControl(Instance_NakMessage, "MsgText")
Instance_NakMessage:setFlushAble(false)
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
  Instance_NakMessage:SetShow(true, false)
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
local function MessageOpen()
  Instance_NakMessage:ResetVertexAni()
  local axisY = Instance_NakMessage:GetSizeY() / 2
  local aniInfo = Instance_NakMessage:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Instance_NakMessage:addScaleAnimation(0, 3.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartScale(0.85)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisY = axisY
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Instance_NakMessage:addScaleAnimation(0.15, animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisY = axisY
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
  local aniInfo3 = Instance_NakMessage:addColorAnimation(animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo4 = Instance_NakMessage:addScaleAnimation(animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo4:SetStartScale(1)
  aniInfo4:SetEndScale(0.7)
  aniInfo4.AxisY = axisY
  aniInfo4.ScaleType = 2
  aniInfo4.IsChangeChild = true
end
local tempMsg
local _posSet = false
function NakMessageUpdate(updateTime)
  elapsedTime = elapsedTime + updateTime
  if elapsedTime >= animationEndTime then
    if processIndex < curIndex then
      MessageOpen()
      processIndex = processIndex + 1
      Instance_NakMessage:SetShow(true, false)
      tempMsg = MessageData._Msg[processIndex]
      _text_Msg:SetText(MessageData._Msg[processIndex])
      if false == _posSet then
        if _defaultXSize < _text_Msg:GetTextSizeX() then
          local resizeX = _text_Msg:GetTextSizeX() - _defaultXSize + 40
          Instance_NakMessage:SetSize(_defaultXSize + resizeX, Instance_NakMessage:GetSizeY())
          _PA_LOG("\235\176\149\235\178\148\236\164\128", "Panel_NakMessage___2 : " .. Instance_NakMessage:GetKey())
        else
          Instance_NakMessage:SetSize(_defaultXSize, Instance_NakMessage:GetSizeY())
        end
        if nil ~= _targetPosX and nil ~= _targetPosY then
          Instance_NakMessage:SetPosX(_targetPosX)
          Instance_NakMessage:SetPosY(_targetPosY)
          _targetPosX = nil
          _targetPosY = nil
        else
          Instance_NakMessage:SetPosX((getScreenSizeX() - Instance_NakMessage:GetSizeX()) * 0.5)
          Instance_NakMessage:SetPosY(positionAdjust._originY)
        end
        _text_Msg:ComputePos()
      end
      MessageData._Msg[processIndex] = nil
      elapsedTime = 0
      _posSet = true
    else
      _posSet = false
      Instance_NakMessage:SetShow(false, false)
      curIndex = 0
      processIndex = 0
    end
  elseif processIndex < curIndex and tempMsg == MessageData._Msg[processIndex + 1] then
    processIndex = processIndex + 1
    MessageData._Msg[processIndex] = nil
  end
end
function NakMessagePanel_Reset()
  curIndex = 0
  processIndex = 0
  MessageData._Msg = {}
end
function NakMessagePanel_Resize()
  local val = (getScreenSizeX() - Instance_NakMessage:GetSizeX()) * 0.5
  Instance_NakMessage:SetPosX(val)
  positionAdjust._originX = val
end
function renderModeChange_NakMessagePostRestoreFunction(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if 0 ~= processIndex then
    Instance_NakMessage:SetShow(true, false)
  end
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_NakMessagePostRestoreFunction")
NakMessagePanel_Resize()
Instance_NakMessage:RegisterUpdateFunc("NakMessageUpdate")
registerEvent("showMessage_ack", "Proc_ShowMessage_Ack_WithOut_ChattingMessage")
registerEvent("showBigMessage_ack", "Proc_ShowBigMessage_Ack_WithOut_ChattingMessage")
registerEvent("showMessage_FrameEvent", "Proc_ShowMessage_FrameEvent")
registerEvent("onScreenResize", "NakMessagePanel_Resize")
