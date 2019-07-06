local isVoiceOpen = ToClient_IsContentsGroupOpen("75")
Panel_VoiceChatStatus:SetShow(isVoiceOpen)
local VoiceChat = {
  ui = {
    button = UI.getChildControl(Panel_VoiceChatStatus, "Button_SetState")
  },
  config = {micVol = false, headphoneVol = false}
}
VoiceChat.ui.mic = UI.getChildControl(VoiceChat.ui.button, "Static_Mic")
VoiceChat.ui.headphone = UI.getChildControl(VoiceChat.ui.button, "Static_Headphone")
local iconType = {mic = 0, headphone = 1}
local iconTexture = {
  [iconType.mic] = {
    [0] = {
      182,
      347,
      226,
      390
    },
    [1] = {
      272,
      347,
      316,
      390
    }
  },
  [iconType.headphone] = {
    [0] = {
      137,
      347,
      181,
      390
    },
    [1] = {
      227,
      347,
      271,
      390
    }
  }
}
function VoiceChat:Init()
  if not isVoiceOpen then
    return
  end
  FGlobal_VoiceChatState()
end
function VoiceChat:IconChange(icon, isOn)
  local ui
  if iconType.mic == icon then
    ui = self.ui.mic
  else
    ui = self.ui.headphone
  end
  local textureArray = {}
  if true == isOn then
    textureArray = iconTexture[icon][0]
  else
    textureArray = iconTexture[icon][1]
  end
  local x1, y1, x2, y2 = setTextureUV_Func(ui, textureArray[1], textureArray[2], textureArray[3], textureArray[4])
  ui:getBaseTexture():setUV(x1, y1, x2, y2)
  ui:setRenderTexture(ui:getBaseTexture())
end
function VoiceChat:Update()
  local isMicOn = self.config.micVol
  local isHeadphoneOn = self.config.headphoneVol
  self:IconChange(iconType.mic, isMicOn)
  self:IconChange(iconType.headphone, isHeadphoneOn)
end
function FGlobal_VoiceChatState()
  if not isVoiceOpen then
    return
  end
  local isMicOn = ToClient_isVoiceChatMic()
  local isHeadphoneOn = ToClient_isVoiceChatListen()
  VoiceChat.config.micVol = isMicOn
  VoiceChat.config.headphoneVol = isHeadphoneOn
  VoiceChat:Update()
end
function HandleOnOut_SetVoiceChat_Tooltip(isShow)
  local uiControl = VoiceChat.ui.button
  if true == isShow then
    local changeString = function(isOn)
      local returnValue = ""
      if true == isOn then
        returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_ISON")
      else
        returnValue = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_ISOFF")
      end
      return returnValue
    end
    local isMicOn = changeString(ToClient_isVoiceChatMic())
    local isHeadphoneOn = changeString(ToClient_isVoiceChatListen())
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_TITLE")
    local desc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_VOICECHAT_TOOLTIP_DESC", "mic", isMicOn, "speaker", isHeadphoneOn)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function VoiceChat:registEventHandler()
  self.ui.button:addInputEvent("Mouse_LUp", "FGlobal_SetVoiceChat_Toggle()")
  self.ui.button:addInputEvent("Mouse_On", "HandleOnOut_SetVoiceChat_Tooltip( true )")
  self.ui.button:addInputEvent("Mouse_Out", "HandleOnOut_SetVoiceChat_Tooltip( false )")
  self.ui.button:setTooltipEventRegistFunc("HandleOnOut_SetVoiceChat_Tooltip( true )")
end
function VoiceChat:registMessageHandler()
  registerEvent("FromClient_VoiceChatState", "FGlobal_VoiceChatState")
end
VoiceChat:Init()
VoiceChat:registEventHandler()
VoiceChat:registMessageHandler()
