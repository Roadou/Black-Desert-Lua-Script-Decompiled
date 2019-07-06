local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_LifeString = CppEnums.LifeExperienceString
local UI_VT = CppEnums.VehicleType
local MessageData = {
  _Msg = {}
}
local curIndex = 0
local processIndex = 0
local animationEndTime = 2.3
local elapsedTime = 2.3
local _text_Msg = UI.getChildControl(Instance_RewardSelect_NakMessage, "MsgText")
local _text_MsgSub = UI.getChildControl(Instance_RewardSelect_NakMessage, "MsgSubText")
local _text_AddMsg = UI.getChildControl(Instance_RewardSelect_NakMessage, "TradeSubText")
local bigNakMsg = UI.getChildControl(Instance_RewardSelect_NakMessage, "Static_BigNakMsg")
local nakItemIconBG = UI.getChildControl(Instance_RewardSelect_NakMessage, "Static_IconBG")
local nakItemIcon = UI.getChildControl(Instance_RewardSelect_NakMessage, "Static_Icon")
local localwarMsg = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Localwar")
local localwarMsgSmallBG = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_LocalwarSmall")
local localwarMsgBG = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_LocalwarBG")
local _text_localwarMsg = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_LocalwarText")
local competitionBg = UI.getChildControl(Instance_RewardSelect_NakMessage, "Static_CompetitionGameBg")
local competitionMsg = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_CompetitionGameMsg")
local competitionCount = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_CompetitonGameCount")
local stallionIcon = UI.getChildControl(Instance_RewardSelect_NakMessage, "Static_iconStallion")
local bgBaseSizeX = bigNakMsg:GetSizeX()
local bgBaseSizeY = bigNakMsg:GetSizeY()
local increesePointSizeX = 500
local isServantStallion = false
local huntingRanker = {
  [1] = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Hunting_1"),
  [2] = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Hunting_2"),
  [3] = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Hunting_3"),
  [4] = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Hunting_4"),
  [5] = UI.getChildControl(Instance_RewardSelect_NakMessage, "StaticText_Hunting_5")
}
bigNakMsg:SetShow(false)
localwarMsg:SetShow(false)
localwarMsgSmallBG:SetShow(false)
localwarMsgBG:SetShow(false)
_text_localwarMsg:SetShow(false)
competitionBg:SetShow(false)
competitionMsg:SetShow(false)
competitionCount:SetShow(false)
nakItemIconBG:SetShow(false)
nakItemIcon:SetShow(false)
stallionIcon:SetShow(false)
local messageType = {
  safetyArea = 0,
  combatArea = 1,
  challengeComplete = 2,
  normal = 3,
  kill = 4
}
local messageTexture = {
  [messageType.normal] = "New_UI_Common_forLua/Widget/NakMessage/Alert_01.dds",
  [messageType.combatArea] = "New_UI_Common_forLua/Widget/NakMessage/NakBG_Combat_01.dds",
  [messageType.safetyArea] = "New_UI_Common_forLua/Widget/NakMessage/NakBG_Safety_01.dds",
  [messageType.challengeComplete] = "New_UI_Common_forLua/Widget/NakMessage/NakBG_RewardAlert_01.dds",
  [messageType.kill] = "New_UI_Common_forLua/Widget/NakMessage/NakBG_Combat_01.dds"
}
_text_Msg:SetText("")
_text_MsgSub:SetText("")
local _msgType
local passFlush = false
function Proc_ShowMessage_Ack_For_RewardSelect(message, showRate, msgType, exposure, isSelfPlayer)
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(message, showRate, msgType, exposure, isSelfPlayer)
  if "" == message.sub then
    chatting_sendMessage("", message.main, CppEnums.ChatType.System)
  else
    chatting_sendMessage("", message.sub, CppEnums.ChatType.System)
  end
end
function Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(message, showRate, msgType, exposure, isSelfPlayer)
  if nil == showRate then
    animationEndTime = 2.3
    elapsedTime = 2.3
  else
    animationEndTime = showRate
    elapsedTime = showRate
  end
  curIndex = curIndex + 1
  MessageData._Msg[curIndex] = {}
  MessageData._Msg[curIndex].msg = message
  MessageData._Msg[curIndex].type = msgType
  Instance_RewardSelect_NakMessage:SetShow(true, false)
  NakMessagePanel_Resize_For_RewardSelect()
end
local function MessageOpen()
  local axisX = Instance_RewardSelect_NakMessage:GetSizeX() / 2
  local axisY = Instance_RewardSelect_NakMessage:GetSizeY() / 2
  local aniInfo = Instance_RewardSelect_NakMessage:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo2 = Instance_RewardSelect_NakMessage:addScaleAnimation(0.15, animationEndTime - 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = axisX
  aniInfo2.AxisY = axisY
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
  local aniInfo3 = Instance_RewardSelect_NakMessage:addColorAnimation(animationEndTime - 0.15, animationEndTime, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
end
local tempMsg
function NakMessageUpdate_For_RewardSelect(updateTime)
  if isLuaLoadingComplete and Instance_Acquire:GetShow() then
    return
  end
  if Defines.UIMode.eUIMode_InGameCustomize == GetUIMode() or Defines.UIMode.eUIMode_ScreenShotMode == GetUIMode() then
    return
  end
  elapsedTime = elapsedTime + updateTime
  if animationEndTime <= elapsedTime then
    if processIndex < curIndex then
      if messageType.defeatBoss == MessageData._Msg[processIndex + 1].type then
        Boss_MessageOpen()
      else
        MessageOpen()
      end
      processIndex = processIndex + 1
      NakMessagePanel_Resize_For_RewardSelect()
      _text_Msg:SetFontColor(UI_color.C_FFFFEF82)
      _text_MsgSub:SetFontColor(UI_color.C_FFFFEF82)
      _text_Msg:SetSpanSize(0, 15)
      _text_MsgSub:SetSpanSize(0, 38)
      bigNakMsg:EraseAllEffect()
      localwarMsg:EraseAllEffect()
      localwarMsgSmallBG:EraseAllEffect()
      localwarMsg:SetShow(false)
      localwarMsgSmallBG:SetShow(false)
      localwarMsgBG:SetShow(false)
      _text_localwarMsg:SetShow(false)
      competitionBg:SetShow(false)
      competitionMsg:SetShow(false)
      competitionCount:SetShow(false)
      stallionIcon:SetShow(false)
      bigNakMsg:SetShow(true)
      _text_Msg:SetShow(true)
      _text_MsgSub:SetShow(true)
      competitionBg:SetShow(false)
      competitionMsg:SetShow(false)
      competitionCount:SetShow(false)
      bigNakMsg:ChangeTextureInfoNameAsync(messageTexture[MessageData._Msg[processIndex].type])
      _text_AddMsg:SetShow(false)
      nakItemIconBG:SetShow(false)
      nakItemIcon:SetShow(false)
      if messageType.safetyArea == MessageData._Msg[processIndex].type then
        _text_Msg:SetFontColor(UI_color.C_ffdeff6d)
        _text_MsgSub:SetFontColor(UI_color.C_ffdeff6d)
      elseif messageType.combatArea == MessageData._Msg[processIndex].type then
        _text_Msg:SetFontColor(UI_color.C_ffff8181)
        _text_MsgSub:SetFontColor(UI_color.C_ffff8181)
      elseif messageType.challengeComplete == MessageData._Msg[processIndex].type then
        _text_Msg:SetFontColor(UI_color.C_FFFFEF82)
        _text_MsgSub:SetFontColor(UI_color.C_FFFFEF82)
      elseif messageType.normal == MessageData._Msg[processIndex].type then
        _text_Msg:SetFontColor(UI_color.C_FFFFEF82)
        _text_MsgSub:SetFontColor(UI_color.C_FFFFEF82)
      else
        _text_Msg:SetFontColor(UI_color.C_FFFFEF82)
        _text_MsgSub:SetFontColor(UI_color.C_FFFFEF82)
      end
      tempMsg = MessageData._Msg[processIndex].msg
      _text_Msg:SetText(MessageData._Msg[processIndex].msg.main)
      _text_MsgSub:SetText(MessageData._Msg[processIndex].msg.sub)
      if "" == MessageData._Msg[processIndex].msg.sub then
        _text_Msg:SetSpanSize(_text_Msg:GetSpanSize().x, 25)
        _text_MsgSub:SetSpanSize(_text_MsgSub:GetSpanSize().x, 38)
      else
        _text_Msg:SetSpanSize(_text_Msg:GetSpanSize().x, 15)
        _text_MsgSub:SetSpanSize(_text_MsgSub:GetSpanSize().x, 38)
      end
      _text_Msg:ComputePos()
      _text_MsgSub:ComputePos()
      bigNakMsg:SetSize(bgBaseSizeX, bgBaseSizeY)
      bigNakMsg:ComputePos()
      bigNakMsg:SetPosY(0)
      MessageData._Msg[processIndex].msg = nil
      MessageData._Msg[processIndex].type = nil
      elapsedTime = 0
    else
      Instance_RewardSelect_NakMessage:SetShow(false, false)
      _text_AddMsg:SetShow(false)
      nakItemIconBG:SetShow(false)
      nakItemIcon:SetShow(false)
      curIndex = 0
      processIndex = 0
    end
  else
    NakMessagePanel_Resize_For_RewardSelect()
    if processIndex < curIndex and tempMsg == MessageData._Msg[processIndex + 1].msg then
      processIndex = processIndex + 1
      MessageData._Msg[processIndex].msg = nil
      MessageData._Msg[processIndex].type = nil
    end
  end
end
function NakMessagePanel_Resize_For_RewardSelect()
  Instance_RewardSelect_NakMessage:SetPosY(30)
  Instance_RewardSelect_NakMessage:SetPosX((getScreenSizeX() - Instance_RewardSelect_NakMessage:GetSizeX()) * 0.5)
end
function FGlobal_NakMessagePanel_CheckLeftMessageCount()
  return curIndex
end
function check_LeftNakMessage()
  if processIndex < curIndex then
    Instance_RewardSelect_NakMessage:SetShow(true, false)
    NakMessagePanel_Resize_For_RewardSelect()
  end
end
function renderModeChange_check_LeftNakMessage(prevRenderModeList, nextRenderModeList)
  local currentRenderMode = {
    Defines.RenderMode.eRenderMode_Default,
    Defines.RenderMode.eRenderMode_Dialog,
    Defines.RenderMode.eRenderMode_WorldMap
  }
  if CheckRenderMode(prevRenderModeList, currentRenderMode) or CheckRenderModebyGameMode(nextRenderModeList) then
    check_LeftNakMessage()
  end
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_check_LeftNakMessage")
Instance_RewardSelect_NakMessage:RegisterUpdateFunc("NakMessageUpdate_For_RewardSelect")
registerEvent("onScreenResize", "NakMessagePanel_Resize_For_RewardSelect")
