local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local posIndex = 0
local _maxNoticeCount = 3
local noticePanelList = {}
local noticeAlertList = {}
local function createNoticeMsg()
  local _text_Msg = UI.getChildControl(Panel_NoticeAlert, "StaticText_NoticeAlert_Text")
  _text_Msg:SetShow(false)
  local _bg_Msg = UI.getChildControl(Panel_NoticeAlert, "Static_NoticeAlertBG")
  _bg_Msg:SetShow(false)
  local getScrX = getScreenSizeX()
  for index = 1, _maxNoticeCount do
    local noticePanel = UI.createPanel("Panel_NoticeAlert" .. index, Defines.UIGroup.PAGameUIGroup_GameSystemMenu)
    noticePanel:SetSize(Panel_NoticeAlert:GetSizeX(), Panel_NoticeAlert:GetSizeY())
    noticePanel:SetIgnore(true)
    noticePanel:SetShow(false, false)
    noticePanel:ChangeTextureInfoName("")
    local bgMsg = UI.createControl(UCT.PA_UI_CONTROL_STATIC, noticePanel, "NoticeAlertBG_" .. index)
    CopyBaseProperty(_bg_Msg, bgMsg)
    bgMsg:SetShow(true)
    local textMsg = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, noticePanel, "NoticeAlert_Text_" .. index)
    CopyBaseProperty(_text_Msg, textMsg)
    textMsg:SetShow(true)
    noticePanelList[index] = noticePanel
    local noticeAlert = {}
    noticeAlertList[index] = noticeAlert
    noticeAlert.textMsg = textMsg
    noticeAlert.bgMsg = bgMsg
  end
end
createNoticeMsg()
local function MessageOpen(panel)
  audioPostEvent_SystemUi(4, 4)
  _AudioPostEvent_SystemUiForXBOX(4, 4)
  panel:SetShow(true, false)
  panel:ResetVertexAni()
  panel:SetScaleChild(1, 1)
  local aniInfo = panel:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo.IsChangeChild = true
  local aniInfo1 = panel:addScaleAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartScale(0.85)
  aniInfo1:SetEndScale(1)
  aniInfo1.IsChangeChild = true
  local aniInfo2 = panel:addScaleAnimation(0.25, 7, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(1)
  aniInfo2.IsChangeChild = true
  local aniInfo3 = panel:addColorAnimation(7, 8, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo3:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo3.IsChangeChild = true
  local aniInfo4 = panel:addScaleAnimation(8, 8.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo4:SetStartScale(1)
  aniInfo4:SetEndScale(0)
  aniInfo4.IsChangeChild = true
end
local function updatePosition()
  local centerPos = getOriginScreenSizeX() / 2 - Panel_NoticeAlert:GetSizeX() / 2
  for index = 1, _maxNoticeCount do
    local realIndex = (index - posIndex + 5) % _maxNoticeCount + 1
    local panel = noticePanelList[index]
    if panel:IsShow() then
      panel:SetPosX(centerPos)
      panel:SetPosY(Panel_NoticeAlert:GetSizeY() * realIndex + 5)
    end
  end
end
function Proc_NoticeAlert_Ack(message, noticeType, noticeValue)
  if CppEnums.EChatNoticeType.HuntingStart == noticeType or CppEnums.EChatNoticeType.HuntingEnd == noticeType then
    if nil ~= message then
      WhaleHuntingEvent(message, noticeType, noticeValue)
    end
    return
  end
  if CppEnums.EChatNoticeType.Kzarka == noticeType or CppEnums.EChatNoticeType.Nuberu == noticeType then
    if nil ~= message then
      FGlobal_WorldBossShow(message, noticeType, noticeValue)
      ToClient_StartLedDeviceAnimation(12)
    end
    return
  end
  if CppEnums.EChatNoticeType.FieldBoss == noticeType then
    if nil ~= message then
      FGlobal_WorldBossShow(message, noticeType, noticeValue)
    end
    return
  end
  if CppEnums.EChatNoticeType.SavageDefenceBoss == noticeType then
    if nil ~= message then
      Proc_ShowMessage_Ack_WithOut_ChattingMessage(message)
    end
    return
  end
  posIndex = posIndex % _maxNoticeCount + 1
  noticeAlertList[posIndex].textMsg:SetFontColor(Chatting_MessageColor(CppEnums.ChatType.Notice, noticeType))
  noticeAlertList[posIndex].textMsg:SetText(message)
  MessageOpen(noticePanelList[posIndex])
  updatePosition()
end
function Proc_InstanceField_NoticeAlert_Ack(message, noticeType, noticeValue)
  if CppEnums.EChatNoticeType.HuntingStart == noticeType or CppEnums.EChatNoticeType.HuntingEnd == noticeType then
    if nil ~= message then
      WhaleHuntingEvent(message, noticeType, noticeValue)
    end
    return
  end
  if CppEnums.EChatNoticeType.Kzarka == noticeType or CppEnums.EChatNoticeType.Nuberu == noticeType then
    if nil ~= message then
      FGlobal_WorldBossShow(message, noticeType, noticeValue)
      ToClient_StartLedDeviceAnimation(12)
    end
    return
  end
  if CppEnums.EChatNoticeType.FieldBoss == noticeType then
    if nil ~= message then
      FGlobal_WorldBossShow(message, noticeType, noticeValue)
    end
    return
  end
  if CppEnums.EChatNoticeType.SavageDefenceBoss == noticeType then
    if nil ~= message then
      Proc_ShowMessage_Ack_WithOut_ChattingMessage(message)
    end
    return
  end
  posIndex = posIndex % _maxNoticeCount + 1
  noticeAlertList[posIndex].textMsg:SetFontColor(Chatting_MessageColor(CppEnums.ChatType.Notice, noticeType))
  noticeAlertList[posIndex].textMsg:SetText(message)
  MessageOpen(noticePanelList[posIndex])
  updatePosition()
end
function NoticeAlert_Resize()
  updatePosition()
end
function TestGameManagerNotice()
  if true == isRealServiceMode() then
    return
  end
  local noticeCount = ToClient_getWorldNoticeCount()
  for i = 0, noticeCount - 1 do
    local msgInfo = ToClient_getWorldNoticeInfo(i)
    if nil ~= msgInfo then
      local msg = msgInfo:getMessage()
      local remainTime = msgInfo:getRemainTime()
      local noticeType = msgInfo:getNoticeType()
      chatting_sendMessage("", msg .. "/" .. remainTime .. "/" .. noticeType, CppEnums.ChatType.System, CppEnums.ChatSystemType.Undefine)
    end
  end
end
function TestRemoveGameManagerNotice(index)
  if true == isRealServiceMode() then
    return
  end
  ToClient_eraseWorldNotice(index)
end
registerEvent("EventNotifyAlertMessage", "Proc_NoticeAlert_Ack")
registerEvent("FromClient_NotifyMessageType", "Proc_InstanceField_NoticeAlert_Ack")
registerEvent("onScreenResize", "NoticeAlert_Resize")
