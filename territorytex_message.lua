Panel_TerritoryTex_Message:RegisterShowEventFunc(true, "TerritoryTex_MessageShowAni()")
Panel_TerritoryTex_Message:RegisterShowEventFunc(false, "TerritoryTex_MessageHideAni()")
function TerritoryTex_MessageShowAni()
end
function TerritoryTex_MessageHideAni()
end
local MessageData = {
  _Msg = {}
}
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local curIndex = 0
local processIndex = 0
local animationEndTime = 4
local elapsedTime = 5
local msgBG = UI.getChildControl(Panel_TerritoryTex_Message, "Static_TerritoryTex_MsgBorder")
local _text_Msg = UI.getChildControl(Panel_TerritoryTex_Message, "StaticText_TerritoryTex_Message")
function TerritoryTex_ShowMessage_Ack(message)
  TerritoryTex_ShowMessage_Ack_WithOut_ChattingMessage(message)
  chatting_sendMessage("", message, CppEnums.ChatType.System)
end
function TerritoryTex_ShowMessage_Ack_WithOut_ChattingMessage(message)
  msgBG:EraseAllEffect()
  curIndex = curIndex + 1
  MessageData._Msg[curIndex] = message
  Panel_TerritoryTex_Message:SetShow(true, true)
end
local function MessageOpen()
  local aniInfo = Panel_TerritoryTex_Message:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = Panel_TerritoryTex_Message:addScaleAnimation(0.5, 0.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1)
  aniInfo1.AxisX = Panel_TerritoryTex_Message:GetSizeX() / 2
  aniInfo1.AxisY = Panel_TerritoryTex_Message:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_TerritoryTex_Message:addScaleAnimation(0.15, 3, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(1)
  aniInfo2.IsChangeChild = true
  local aniInfo3 = Panel_TerritoryTex_Message:addColorAnimation(3, 4, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo4 = Panel_TerritoryTex_Message:addScaleAnimation(3.5, 3.65, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo4:SetStartScale(1)
  aniInfo4:SetEndScale(1)
  aniInfo4.AxisX = Panel_TerritoryTex_Message:GetSizeX() / 2
  aniInfo4.AxisY = Panel_TerritoryTex_Message:GetSizeY() / 2
  aniInfo4.ScaleType = 2
  aniInfo4.IsChangeChild = true
end
local tempMsg
function TerrirotyTex_MessageUpdate(updateTime)
  elapsedTime = elapsedTime + updateTime
  if elapsedTime >= animationEndTime then
    if processIndex < curIndex then
      audioPostEvent_SystemUi(8, 1)
      _AudioPostEvent_SystemUiForXBOX(8, 1)
      MessageOpen()
      processIndex = processIndex + 1
      Panel_TerritoryTex_Message:SetShow(false, true)
      Panel_TerritoryTex_Message:SetShow(true, true)
      tempMsg = MessageData._Msg[processIndex]
      _text_Msg:SetText(MessageData._Msg[processIndex])
      local _txtSize = _text_Msg:GetTextSizeX()
      MessageData._Msg[processIndex] = nil
      elapsedTime = 0
    else
      Panel_TerritoryTex_Message:SetShow(false, false)
      curIndex = 0
      processIndex = 0
    end
  elseif processIndex < curIndex and tempMsg == MessageData._Msg[processIndex + 1] then
    processIndex = processIndex + 1
    MessageData._Msg[processIndex] = nil
  end
end
function TerrirotyTex_MessagePanel_Resize()
  local scrX = getScreenSizeX()
  msgBG:SetPosX((scrX - msgBG:GetSizeX()) * 0.5)
end
TerrirotyTex_MessagePanel_Resize()
Panel_TerritoryTex_Message:RegisterUpdateFunc("TerrirotyTex_MessageUpdate")
registerEvent("onScreenResize", "TerrirotyTex_MessagePanel_Resize()")
