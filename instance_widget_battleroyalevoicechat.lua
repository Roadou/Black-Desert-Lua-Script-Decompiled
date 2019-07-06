local battleRoyaleVoiceChat = {
  _ui = {
    _button_Speak = nil,
    _instance_Widget_VoiceChat_Speak = nil,
    _button_SpeakClose = nil,
    _slider_Speak = nil,
    _sliderBtn_Speak = nil,
    _sliderVal_Speak = nil,
    _checkbox_Speak = nil,
    _button_Listen = nil,
    _instance_Widget_VoiceChat_Listen = nil,
    _button_ListenClose = nil,
    _slider_Listen = nil,
    _sliderBtn_Listen = nil,
    _sliderVal_Listen = nil,
    _checkbox_Listen = nil
  },
  _speakPanelShow = false,
  _listenPanelShow = false,
  _modeNo = __eBattleRoyaleMode_Count
}
function battleRoyaleVoiceChat:initialize()
  self._ui._button_Speak = UI.getChildControl(Instance_Widget_BattleRoyaleVoiceChat, "Button_Speak")
  self._ui._instance_Widget_VoiceChat_Speak = UI.getChildControl(Instance_Widget_BattleRoyaleVoiceChat, "Static_Speaking_VolumeBG")
  self._ui._slider_Speak = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak, "Slider_SpeakingVolume")
  self._ui._sliderBtn_Speak = UI.getChildControl(battleRoyaleVoiceChat._ui._slider_Speak, "Slider_MicVol_Button")
  self._ui._button_SpeakClose = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak, "Button_VolumeSetClose")
  self._ui._sliderVal_Speak = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak, "StaticText_MicVolumeValue")
  self._ui._checkbox_Speak = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak, "Checkbox_MicIcon")
  self._ui._button_Listen = UI.getChildControl(Instance_Widget_BattleRoyaleVoiceChat, "Button_Listen")
  self._ui._instance_Widget_VoiceChat_Listen = UI.getChildControl(Instance_Widget_BattleRoyaleVoiceChat, "Static_Listening_VolumeBG")
  self._ui._slider_Listen = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen, "Slider_ListeningVolume")
  self._ui._sliderBtn_Listen = UI.getChildControl(battleRoyaleVoiceChat._ui._slider_Listen, "Slider_SpeakerVol_Button")
  self._ui._button_ListenClose = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen, "Button_VolumeSetClose")
  self._ui._sliderVal_Listen = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen, "StaticText_SpeakerVolumeValue")
  self._ui._checkbox_Listen = UI.getChildControl(battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen, "Checkbox_SpeakerIcon")
  self:addVoiceChatEvent()
end
function battleRoyaleVoiceChat:addVoiceChatEvent()
  self._ui._button_Speak:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakPanel()")
  self._ui._button_Speak:addInputEvent("Mouse_On", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakTooltip(true)")
  self._ui._button_Speak:addInputEvent("Mouse_Out", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakTooltip(false)")
  self._ui._button_SpeakClose:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakPanel()")
  self._ui._slider_Speak:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_MicVolume()")
  self._ui._sliderBtn_Speak:addInputEvent("Mouse_LPress", "PaGlobalFunc_BattleRoyaleVoiceChat_MicVolume()")
  self._ui._checkbox_Speak:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_SpeakOnOff(true)")
  self._ui._button_Listen:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenPanel()")
  self._ui._button_Listen:addInputEvent("Mouse_On", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenTooltip(true)")
  self._ui._button_Listen:addInputEvent("Mouse_Out", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenTooltip(false)")
  self._ui._button_ListenClose:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenPanel()")
  self._ui._slider_Listen:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_SpeakerVolume()")
  self._ui._sliderBtn_Listen:addInputEvent("Mouse_LPress", "PaGlobalFunc_BattleRoyaleVoiceChat_SpeakerVolume()")
  self._ui._checkbox_Listen:addInputEvent("Mouse_LUp", "PaGlobalFunc_BattleRoyaleVoiceChat_ListenOnOff(true)")
end
function PaGlobalFunc_BattleRoyaleVoiceChat_SpeakOnOff(isClicked)
  local speakFlag = ToClient_isVoiceChatMic(__eVoiceChatType_BattleRoyale)
  if true == isClicked then
    speakFlag = not speakFlag
  end
  if false == ToClient_IsConnectedMic() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_Guild_List_NotConnectedMic"))
    speakFlag = false
  end
  if true == speakFlag and 0 == ToClient_getMicVolume() then
    speakFlag = false
  end
  if true == speakFlag then
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._button_Speak, 105, 169, 133, 197)
    battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._button_Speak:setRenderTexture(battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._checkbox_Speak, 105, 169, 133, 197)
    battleRoyaleVoiceChat._ui._checkbox_Speak:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._checkbox_Speak:setRenderTexture(battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture())
    if true == isClicked then
      local volume = ToClient_getMicVolume()
      battleRoyaleVoiceChat._ui._slider_Speak:SetControlPos(volume)
      PaGlobalFunc_BattleRoyaleVoiceChat_MicVolume()
    end
  else
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._button_Speak, 105, 198, 133, 226)
    battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._button_Speak:setRenderTexture(battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._checkbox_Speak, 105, 198, 133, 226)
    battleRoyaleVoiceChat._ui._checkbox_Speak:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._checkbox_Speak:setRenderTexture(battleRoyaleVoiceChat._ui._button_Speak:getBaseTexture())
    if true == isClicked then
      battleRoyaleVoiceChat._ui._slider_Speak:SetControlPos(0)
      battleRoyaleVoiceChat._ui._sliderVal_Speak:SetText("0%")
    end
  end
  ToClient_setMicOnOff(__eVoiceChatType_BattleRoyale, speakFlag)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_ListenOnOff(isClicked)
  local listenFlag = ToClient_isVoiceChatListen(__eVoiceChatType_BattleRoyale)
  if true == isClicked then
    listenFlag = not listenFlag
  end
  if true == listenFlag and 0 == ToClient_getSpeakerVolume() then
    listenFlag = false
  end
  if true == listenFlag then
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._button_Listen, 134, 169, 162, 197)
    battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._button_Listen:setRenderTexture(battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._checkbox_Listen, 134, 169, 162, 197)
    battleRoyaleVoiceChat._ui._checkbox_Listen:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._checkbox_Listen:setRenderTexture(battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture())
    if true == isClicked then
      local volume = ToClient_getSpeakerVolume()
      battleRoyaleVoiceChat._ui._slider_Listen:SetControlPos(volume)
      PaGlobalFunc_BattleRoyaleVoiceChat_SpeakerVolume()
    end
  else
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._button_Listen, 134, 198, 162, 226)
    battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._button_Listen:setRenderTexture(battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture())
    local x1, y1, x2, y2 = setTextureUV_Func(battleRoyaleVoiceChat._ui._checkbox_Listen, 134, 198, 162, 226)
    battleRoyaleVoiceChat._ui._checkbox_Listen:getBaseTexture():setUV(x1, y1, x2, y2)
    battleRoyaleVoiceChat._ui._checkbox_Listen:setRenderTexture(battleRoyaleVoiceChat._ui._button_Listen:getBaseTexture())
    if true == isClicked then
      battleRoyaleVoiceChat._ui._slider_Listen:SetControlPos(0)
      battleRoyaleVoiceChat._ui._sliderVal_Listen:SetText("0%")
    end
  end
  ToClient_setSpeakerOnOff(__eVoiceChatType_BattleRoyale, listenFlag)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakPanel()
  if true == battleRoyaleVoiceChat._listenPanelShow then
    battleRoyaleVoiceChat._listenPanelShow = false
    battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen:SetShow(false)
  end
  battleRoyaleVoiceChat._speakPanelShow = not battleRoyaleVoiceChat._speakPanelShow
  battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak:SetShow(battleRoyaleVoiceChat._speakPanelShow)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenPanel()
  if true == battleRoyaleVoiceChat._speakPanelShow then
    battleRoyaleVoiceChat._speakPanelShow = false
    battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak:SetShow(false)
  end
  battleRoyaleVoiceChat._listenPanelShow = not battleRoyaleVoiceChat._listenPanelShow
  battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen:SetShow(battleRoyaleVoiceChat._listenPanelShow)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_SpeakerVolume()
  if nil == battleRoyaleVoiceChat._ui._slider_Listen then
    return
  end
  local posPercent = battleRoyaleVoiceChat._ui._slider_Listen:GetControlPos() * 100
  local volume = math.ceil(posPercent)
  battleRoyaleVoiceChat._ui._sliderVal_Listen:SetText(volume .. "%")
  ToClient_setSpeakerVolume(posPercent)
  if volume > 0 then
    ToClient_setSpeakerOnOff(__eVoiceChatType_BattleRoyale, true)
  else
    ToClient_setSpeakerOnOff(__eVoiceChatType_BattleRoyale, false)
  end
  PaGlobalFunc_BattleRoyaleVoiceChat_ListenOnOff(false)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_MicVolume()
  if nil == battleRoyaleVoiceChat._ui._slider_Speak then
    return
  end
  local posPercent = battleRoyaleVoiceChat._ui._slider_Speak:GetControlPos() * 100
  local volume = math.ceil(posPercent)
  battleRoyaleVoiceChat._ui._sliderVal_Speak:SetText(volume .. "%")
  ToClient_setMicVolume(posPercent)
  if volume > 0 then
    ToClient_setMicSensitivity(30 + posPercent / 10)
    ToClient_setMicOnOff(__eVoiceChatType_BattleRoyale, true)
  else
    ToClient_setMicSensitivity(0)
    ToClient_setMicOnOff(__eVoiceChatType_BattleRoyale, false)
  end
  PaGlobalFunc_BattleRoyaleVoiceChat_SpeakOnOff(false)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_ShowSpeakTooltip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  if battleRoyaleVoiceChat._modeNo == __eBattleRoyaleMode_Solo then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_VOICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYALE_VOICECHATICON_TOOLTIP_VOICE_DESC")
  elseif battleRoyaleVoiceChat._modeNo == __eBattleRoyaleMode_Team then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_VOICE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYALE_VOICECHATICON_TOOLTIP_VOICE_DESC")
  end
  TooltipSimple_Show(battleRoyaleVoiceChat._ui._button_Speak, name, desc)
end
function PaGlobalFunc_BattleRoyaleVoiceChat_ShowListenTooltip(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  if battleRoyaleVoiceChat._modeNo == __eBattleRoyaleMode_Solo then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_SPEAKER_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYALE_VOICECHATICON_TOOLTIP_SPEAKER_DESC")
  elseif battleRoyaleVoiceChat._modeNo == __eBattleRoyaleMode_Team then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_LIST_VOICECHATICON_TOOLTIP_SPEAKER_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYALE_VOICECHATICON_TOOLTIP_SPEAKER_DESC")
  end
  TooltipSimple_Show(battleRoyaleVoiceChat._ui._button_Listen, name, desc)
end
function battleRoyaleVoiceChat:resetVoiceChatData()
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if CppEnums.ClassType.ClassType_Temp1 ~= selfPlayer:getClassType() then
    PaGlobalFunc_BattleRoyaleVoiceChat_ListenOnOff(false)
    if true == ToClient_isVoiceChatListen(__eVoiceChatType_BattleRoyale) then
      local volume = ToClient_getSpeakerVolume()
      battleRoyaleVoiceChat._ui._slider_Listen:SetControlPos(volume)
      battleRoyaleVoiceChat._ui._sliderVal_Listen:SetText(tostring(volume .. "%"))
    end
    PaGlobalFunc_BattleRoyaleVoiceChat_SpeakOnOff(false)
    if true == ToClient_isVoiceChatMic(__eVoiceChatType_BattleRoyale) then
      local volume = ToClient_getMicVolume()
      battleRoyaleVoiceChat._ui._slider_Speak:SetControlPos(volume)
      battleRoyaleVoiceChat._ui._sliderVal_Speak:SetText(tostring(volume .. "%"))
    end
    return
  end
  battleRoyaleVoiceChat._ui._slider_Speak:SetControlPos(0)
  battleRoyaleVoiceChat._ui._sliderVal_Speak:SetText("0%")
  ToClient_setMicVolume(50)
  ToClient_setMicOnOff(__eVoiceChatType_BattleRoyale, false)
  battleRoyaleVoiceChat._speakPanelShow = false
  battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Speak:SetShow(false)
  ToClient_setMicAdjustment(30)
  battleRoyaleVoiceChat._ui._slider_Listen:SetControlPos(0)
  battleRoyaleVoiceChat._ui._sliderVal_Listen:SetText("0%")
  ToClient_setSpeakerVolume(75)
  ToClient_setSpeakerOnOff(__eVoiceChatType_BattleRoyale, false)
  battleRoyaleVoiceChat._listenPanelShow = false
  battleRoyaleVoiceChat._ui._instance_Widget_VoiceChat_Listen:SetShow(false)
end
function battleRoyaleVoiceChat:open()
  if true == isGameTypeRussia() then
    self:close()
  end
  self._modeNo = ToClient_GetBattleRoyaleModeNo()
  if self._modeNo == __eBattleRoyaleMode_Training or self._modeNo == __eBattleRoyaleMode_Count then
    return
  end
  if true == Instance_Widget_BattleRoyaleVoiceChat:GetShow() then
    self:close()
    return
  end
  Instance_Widget_BattleRoyaleVoiceChat:SetShow(true)
  self:resetVoiceChatData()
end
function battleRoyaleVoiceChat:close()
  Instance_Widget_BattleRoyaleVoiceChat:SetShow(false)
end
function FromClient_VoiceChat_Init()
  local self = battleRoyaleVoiceChat
  self:initialize()
  self:open()
end
function PaGlobalFunc_BattleRoyaleVoiceChat_Open()
  local self = battleRoyaleVoiceChat
  self:open()
end
function PaGlobalFunc_BattleRoyaleVoiceChat_Close()
  local self = battleRoyaleVoiceChat
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_VoiceChat_Init")
