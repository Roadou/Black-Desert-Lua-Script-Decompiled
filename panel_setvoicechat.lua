Panel_SetVoiceChat:SetShow(false)
Panel_SetVoiceChat:ActiveMouseEventEffect(true)
Panel_SetVoiceChat:setGlassBackground(true)
local isVoiceOpen = ToClient_IsContentsGroupOpen("75")
local voiceSet = {
  ui = {
    micOnOff = UI.getChildControl(Panel_SetVoiceChat, "Checkbox_MicOnOff"),
    headphoneOnOff = UI.getChildControl(Panel_SetVoiceChat, "CheckButton_SpeakerOnOff"),
    pushToTalk = UI.getChildControl(Panel_SetVoiceChat, "CheckButton_PushToTalkOnOff"),
    slider_0 = UI.getChildControl(Panel_SetVoiceChat, "Slider_MicVolControl_0"),
    slider_1 = UI.getChildControl(Panel_SetVoiceChat, "Slider_MicVolControl_1"),
    slider_2 = UI.getChildControl(Panel_SetVoiceChat, "Slider_MicVolControl_2"),
    slider_3 = UI.getChildControl(Panel_SetVoiceChat, "Slider_MicVolControl_3"),
    confirm = UI.getChildControl(Panel_SetVoiceChat, "Button_Confirm"),
    cancel = UI.getChildControl(Panel_SetVoiceChat, "Button_Cancel"),
    winClose = UI.getChildControl(Panel_SetVoiceChat, "Button_WinClose")
  },
  uiPool = {},
  enumVoiceType = {
    enVoiceChatType_Guild = 0,
    enVoiceChatType_Party = 1,
    enVoiceChatType_World = 2
  },
  config = {
    sliderCount = 4,
    openIsMicOn = true,
    openIsHeadphoneOn = true,
    openIsPushToTalk = true,
    openMicVolume = 0,
    openHeadphoneVolume = 0,
    openMicSensitivity = 0,
    openMicAmplification = 0
  }
}
voiceSet.ui.sliderBtn = UI.getChildControl(voiceSet.ui.slider_0, "Slider_MicVol_Button")
local titleArray = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_SETVOICECHAT_TALK_VOLUME"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SETVOICECHAT_HEARING_VOLUME"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_SETVOICECHAT_MIC_SENSITIVITY"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_SETVOICECHAT_MIC_AMPLIFICATION")
}
function voiceSet:Init()
  local defaultPosY = 135
  for sliderIdx = 0, self.config.sliderCount - 1 do
    local tempSlot = {}
    tempSlot.titleBg = UI.createAndCopyBasePropertyControl(Panel_SetVoiceChat, "Static_MicBG", Panel_SetVoiceChat, "Panel_SetVoiceChat_TitleBg_" .. sliderIdx)
    tempSlot.title = UI.createAndCopyBasePropertyControl(Panel_SetVoiceChat, "StaticText_MicTitle", tempSlot.titleBg, "Panel_SetVoiceChat_Title_" .. sliderIdx)
    tempSlot.vol_0 = UI.createAndCopyBasePropertyControl(Panel_SetVoiceChat, "StaticText_MicVol_0", tempSlot.titleBg, "Panel_SetVoiceChat_Vol_0_" .. sliderIdx)
    tempSlot.vol_50 = UI.createAndCopyBasePropertyControl(Panel_SetVoiceChat, "StaticText_MicVol_50", tempSlot.titleBg, "Panel_SetVoiceChat_Vol_50_" .. sliderIdx)
    tempSlot.vol_100 = UI.createAndCopyBasePropertyControl(Panel_SetVoiceChat, "StaticText_MicVol_100", tempSlot.titleBg, "Panel_SetVoiceChat_Vol_100_" .. sliderIdx)
    local slider
    if 0 == sliderIdx then
      slider = voiceSet.ui.slider_0
    elseif 1 == sliderIdx then
      slider = voiceSet.ui.slider_1
    elseif 2 == sliderIdx then
      slider = voiceSet.ui.slider_2
    elseif 3 == sliderIdx then
      slider = voiceSet.ui.slider_3
    end
    Panel_SetVoiceChat:RemoveControl(slider)
    tempSlot.titleBg:AddChild(slider)
    tempSlot.vol_Slider = slider
    tempSlot.vol_SliderBtn = UI.getChildControl(tempSlot.vol_Slider, "Slider_MicVol_Button")
    tempSlot.vol_Slider:SetShow(true)
    tempSlot.titleBg:SetPosY(defaultPosY + 75 * sliderIdx)
    tempSlot.title:SetPosX(10)
    tempSlot.title:SetPosY(1)
    tempSlot.vol_0:SetPosX(5)
    tempSlot.vol_0:SetPosY(40)
    tempSlot.vol_50:SetPosX(tempSlot.vol_Slider:GetSizeX() / 2 - tempSlot.vol_50:GetSizeX() / 3)
    tempSlot.vol_50:SetPosY(40)
    tempSlot.vol_100:SetPosX(tempSlot.vol_Slider:GetSizeX() - tempSlot.vol_100:GetSizeX())
    tempSlot.vol_100:SetPosY(40)
    tempSlot.vol_Slider:SetPosX(5)
    tempSlot.vol_Slider:SetPosY(70)
    tempSlot.title:SetText(titleArray[sliderIdx])
    tempSlot.vol_Slider:SetControlPos(0)
    tempSlot.vol_Slider:addInputEvent("Mouse_LUp", "HandleMove_VoiceChat_Volume( " .. sliderIdx .. " )")
    tempSlot.vol_SliderBtn:addInputEvent("Mouse_LPress", "HandleMove_VoiceChat_Volume( " .. sliderIdx .. " )")
    self.uiPool[sliderIdx] = tempSlot
  end
end
function voiceSet:close()
  local selfPlayer = getSelfPlayer():get()
  local isMicOn = voiceSet.config.openIsMicOn
  local isHeadphoneOn = voiceSet.config.openIsHeadphoneOn
  local isPushToTalk = voiceSet.config.openIsPushToTalk
  local micVolume = voiceSet.config.openMicVolume
  local headphoneVolume = voiceSet.config.openHeadphoneVolume
  local micSensitivity = voiceSet.config.openMicSensitivity
  local micAmplification = voiceSet.config.openMicAmplification
  if ToClient_IsConnectedMic() then
    ToClient_setMicOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, isMicOn)
  else
    ToClient_setMicOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, false)
  end
  ToClient_setSpeakerOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, isHeadphoneOn)
  ToClient_setPushToTalkOnOff(isPushToTalk)
  ToClient_setMicVolume(micVolume)
  ToClient_setSpeakerVolume(headphoneVolume)
  ToClient_setMicSensitivity(micSensitivity)
  ToClient_setMicAdjustment(micAmplification)
  ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, selfPlayer:getUserNo(), isMicOn, isHeadphoneOn, false)
  Panel_SetVoiceChat:SetShow(false)
  FGlobal_VoiceChatState()
end
function HandleMove_VoiceChat_Volume(sliderIdx)
  local slider = voiceSet.uiPool[sliderIdx].vol_Slider
  if nil == slider then
    return
  end
  local posPercent = slider:GetControlPos() * 100
  if 0 == sliderIdx then
    ToClient_setMicVolume(posPercent)
    if posPercent > 0 then
      voiceSet.ui.micOnOff:SetCheck(true)
    else
      voiceSet.ui.micOnOff:SetCheck(false)
    end
  elseif 1 == sliderIdx then
    ToClient_setSpeakerVolume(posPercent)
    if posPercent > 0 then
      voiceSet.ui.headphoneOnOff:SetCheck(true)
    else
      voiceSet.ui.headphoneOnOff:SetCheck(false)
    end
  elseif 2 == sliderIdx then
    ToClient_setMicSensitivity(posPercent)
  elseif 3 == sliderIdx then
    ToClient_setMicAdjustment(posPercent)
  end
  FGlobal_VoiceChatState()
end
function HandleClick_VoiceChat_SetOnOff()
  local isMicOn = voiceSet.ui.micOnOff:IsCheck()
  local isHeadphoneOn = voiceSet.ui.headphoneOnOff:IsCheck()
  local isPushToTalk = voiceSet.ui.pushToTalk:IsCheck()
  if ToClient_IsConnectedMic() then
    ToClient_setMicOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, isMicOn)
  else
    if isMicOn then
      voiceSet.ui.micOnOff:SetCheck(false)
    end
    ToClient_setMicOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, false)
  end
  ToClient_setSpeakerOnOff(voiceSet.enumVoiceType.enVoiceChatType_Guild, isHeadphoneOn)
  ToClient_setPushToTalkOnOff(isPushToTalk)
  FGlobal_VoiceChatState()
end
function HandleClick_VoiceChat_Confirm()
  voiceSet.config.openIsMicOn = voiceSet.ui.micOnOff:IsCheck()
  voiceSet.config.openIsHeadphoneOn = voiceSet.ui.headphoneOnOff:IsCheck()
  voiceSet.config.openIsPushToTalk = voiceSet.ui.pushToTalk:IsCheck()
  voiceSet.config.openMicVolume = math.ceil(voiceSet.uiPool[0].vol_Slider:GetControlPos() * 100)
  voiceSet.config.openHeadphoneVolume = math.ceil(voiceSet.uiPool[1].vol_Slider:GetControlPos() * 100)
  voiceSet.config.openMicSensitivity = math.ceil(voiceSet.uiPool[2].vol_Slider:GetControlPos() * 100)
  voiceSet.config.openMicAmplification = math.ceil(voiceSet.uiPool[3].vol_Slider:GetControlPos() * 100)
  voiceSet:close()
end
function HandleClick_VoiceChat_Close()
  voiceSet:close()
end
function FGlobal_SetVoiceChat_Close()
  voiceSet:close()
end
function FGlobal_SetVoiceChat_Toggle()
  if not isVoiceOpen then
    return
  end
  if Panel_SetVoiceChat:GetShow() then
    Panel_SetVoiceChat:SetShow(false)
  else
    Panel_SetVoiceChat:SetShow(true)
    Panel_SetVoiceChat:SetPosX(Panel_Radar:GetPosX() - Panel_SetVoiceChat:GetSizeX())
    Panel_SetVoiceChat:SetPosY(Panel_VoiceChatStatus:GetPosY() + Panel_VoiceChatStatus:GetSizeY() + 5)
    voiceSet.config.openIsMicOn = ToClient_isVoiceChatMic(voiceSet.enumVoiceType.enVoiceChatType_Guild)
    voiceSet.config.openIsHeadphoneOn = ToClient_isVoiceChatListen(voiceSet.enumVoiceType.enVoiceChatType_Guild)
    voiceSet.config.openIsPushToTalk = ToClient_isVoiceChatPushToTalk()
    voiceSet.config.openMicVolume = ToClient_getMicVolume()
    voiceSet.config.openHeadphoneVolume = ToClient_getSpeakerVolume()
    voiceSet.config.openMicSensitivity = ToClient_getMicSensitivity()
    voiceSet.config.openMicAmplification = math.ceil(ToClient_getMicAdjustment() * 100) - 100
    voiceSet.uiPool[0].vol_Slider:SetControlPos(voiceSet.config.openMicVolume)
    voiceSet.uiPool[1].vol_Slider:SetControlPos(voiceSet.config.openHeadphoneVolume)
    voiceSet.uiPool[2].vol_Slider:SetControlPos(voiceSet.config.openMicSensitivity)
    voiceSet.uiPool[3].vol_Slider:SetControlPos(voiceSet.config.openMicAmplification)
    voiceSet.ui.micOnOff:SetCheck(voiceSet.config.openIsMicOn)
    voiceSet.ui.headphoneOnOff:SetCheck(voiceSet.config.openIsHeadphoneOn)
    voiceSet.ui.pushToTalk:SetCheck(voiceSet.config.openIsPushToTalk)
  end
end
function voiceSet:registEventHandler()
  self.ui.confirm:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_Confirm()")
  self.ui.cancel:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_Close()")
  self.ui.winClose:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_Close()")
  self.ui.micOnOff:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_SetOnOff()")
  self.ui.headphoneOnOff:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_SetOnOff()")
  self.ui.pushToTalk:addInputEvent("Mouse_LUp", "HandleClick_VoiceChat_SetOnOff()")
end
function voiceSet:registMessageHandler()
end
voiceSet:Init()
voiceSet:registEventHandler()
voiceSet:registMessageHandler()
