local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_Message_Under18:SetShow(false, false)
local UnderMessage = {
  MsgText = nil,
  isShowTime = false,
  timer = 0,
  animationEndTime = 5,
  elapsedTime = 5
}
local aleartMessage = PAGetString(Defines.StringSheet_GAME, "SYSTEM_MESSAGE_TIME_ALERT_UNDER")
function FromClient_AdultMessage(playingTime)
  local timeMessage = PAGetStringParam1(Defines.StringSheet_GAME, "SYSTEM_MESSAGE_OVER_TIME_ALERT", "time", tostring(playingTime))
  local adultMessage = timeMessage .. "\n" .. aleartMessage
  chatting_sendMessage("", timeMessage, CppEnums.ChatType.System)
  chatting_sendMessage("", aleartMessage, CppEnums.ChatType.System)
  UnderMessage.MsgText:SetText(adultMessage)
  UnderMessage:AnimationAdd()
  AdultMessage_OnResize()
  Panel_Message_Under18:SetShow(true, false)
end
function UnderMessage:AnimationAdd()
  local aniInfo = Panel_Message_Under18:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Panel_Message_Under18:addScaleAnimation(0, 3.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartScale(0.85)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = axisX
  aniInfo1.AxisY = axisY
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Message_Under18:addScaleAnimation(0.15, UnderMessage.animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = axisX
  aniInfo2.AxisY = axisY
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
  local aniInfo3 = Panel_Message_Under18:addColorAnimation(UnderMessage.animationEndTime - 0.15, UnderMessage.animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo4 = Panel_Message_Under18:addScaleAnimation(UnderMessage.animationEndTime - 0.15, UnderMessage.animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo4:SetStartScale(1)
  aniInfo4:SetEndScale(0.7)
  aniInfo4.AxisX = axisX
  aniInfo4.AxisY = axisY
  aniInfo4.ScaleType = 2
  aniInfo4.IsChangeChild = true
end
function PAGlobal_UnderMessage_Initialize()
  UnderMessage.MsgText = UI.getChildControl(Panel_Message_Under18, "MsgText")
  UnderMessage.MsgText:SetText(" ")
end
function AdultMessage_OnResize()
  local ScrX = getScreenSizeX()
  local ScrY = getScreenSizeY()
  Panel_Message_Under18:SetSize(ScrX, 32)
  Panel_Message_Under18:SetPosX(ScrX - 800)
  Panel_Message_Under18:SetPosY(ScrY * 3 / 4)
  if nil == UnderMessage.MsgText then
    return
  end
  UnderMessage.MsgText:ComputePos()
end
registerEvent("FromClient_luaLoadComplete", "PAGlobal_UnderMessage_Initialize")
registerEvent("FromClient_AdultMessage", "FromClient_AdultMessage")
registerEvent("onScreenResize", "AdultMessage_OnResize")
