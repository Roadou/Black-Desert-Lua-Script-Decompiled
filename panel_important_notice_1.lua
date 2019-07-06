local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function PaGlobal_ImportantNotice:initialize()
  if true == PaGlobal_ImportantNotice._initialize then
    return
  end
  PaGlobal_ImportantNotice._isConsole = ToClient_isConsole()
  local static_NoticeBG = UI.getChildControl(Panel_Important_Notice, "Static_ImportantNoticeBG")
  PaGlobal_ImportantNotice._ui._static_noticeBG = static_NoticeBG
  PaGlobal_ImportantNotice._ui._static_noticeIcon = UI.getChildControl(static_NoticeBG, "Static_NoticeIcon")
  local static_clipArea = UI.getChildControl(static_NoticeBG, "Static_ClipArea")
  PaGlobal_ImportantNotice._ui._static_clipArea = static_clipArea
  if true == PaGlobal_ImportantNotice._isConsole then
    PaGlobal_ImportantNotice._ui._staticText_message = UI.getChildControl(static_clipArea, "StaticText_Message_Console")
    PaGlobal_ImportantNotice._ui._staticText_calculate = UI.getChildControl(static_clipArea, "StaticText_Calculate_Console")
    PaGlobal_ImportantNotice._ui._static_noticeIcon:SetPosY(7)
  else
    PaGlobal_ImportantNotice._ui._staticText_message = UI.getChildControl(static_clipArea, "StaticText_Message")
    PaGlobal_ImportantNotice._ui._staticText_calculate = UI.getChildControl(static_clipArea, "StaticText_Calculate")
  end
  PaGlobal_ImportantNotice._ui._staticText_message:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_ImportantNotice._ui._staticText_calculate:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_ImportantNotice._cacheTextSizeY = PaGlobal_ImportantNotice._ui._staticText_message:GetSizeY()
  PaGlobal_ImportantNotice._cacheBGSizeY = static_NoticeBG:GetSizeY()
  if true == PaGlobal_ImportantNotice:showNoticeText(PaGlobal_ImportantNotice._currentNoticeIndex) then
    PaGlobal_ImportantNotice:prepareOpen()
  end
  PaGlobal_ImportantNotice._isShowState = true
  PaGlobal_ImportantNotice:registEventHandler()
  PaGlobal_ImportantNotice:validate()
  PaGlobal_ImportantNotice._initialize = true
  if true == PaGlobal_ImportantNotice._isResizeFailed and nil ~= Chatting_OnResize then
    PaGlobal_ImportantNotice:updateStringList()
    if false == PaGlobal_ImportantNotice._isConsole then
      Chatting_OnResize()
    end
  end
end
function PaGlobal_ImportantNotice:registEventHandler()
  if nil == Panel_Important_Notice then
    return
  end
  registerEvent("EventNotifyManagerAlertMessage", "FromClient_ImportantNotice_EventNotifyManagerAlertMessage")
  registerEvent("EventNotifyManagerAlertMessageDelete", "FromClient_ImportantNotice_EventNotifyManagerAlertMessageDelete")
end
function PaGlobal_ImportantNotice:prepareOpen()
  if nil == Panel_Important_Notice then
    return
  end
  PaGlobal_ImportantNotice:updateCheckBgSize()
  PaGlobal_ImportantNotice._isNoticeOpen = true
  Panel_Important_Notice:RegisterUpdateFunc("PaGlobal_ImportantNotice_UpdatePerFrame")
  if false == PaGlobal_ImportantNotice._isConsole then
    PaGlobal_Chat_UpdatTopClipingPanel(0, PaGlobal_ImportantNotice_GetNoticeSize())
    PaGlobal_Chat_UpdateChatPanel()
  end
  PaGlobal_ImportantNotice._ui._static_noticeBG:SetShow(PaGlobal_ImportantNotice._initialize)
  PaGlobal_ImportantNotice:open()
end
function PaGlobal_ImportantNotice:open()
  if nil == Panel_Important_Notice then
    return
  end
  Panel_Important_Notice:SetShow(true)
end
function PaGlobal_ImportantNotice:prepareClose()
  if nil == Panel_Important_Notice then
    return
  end
  PaGlobal_ImportantNotice._isNoticeOpen = false
  Panel_Important_Notice:ClearUpdateLuaFunc()
  if false == PaGlobal_ImportantNotice._isConsole then
    PaGlobal_Chat_UpdatTopClipingPanel(0, PaGlobal_ImportantNotice_GetNoticeSize())
  end
  PaGlobal_ImportantNotice:close()
end
function PaGlobal_ImportantNotice:close()
  if nil == Panel_Important_Notice then
    return
  end
  Panel_Important_Notice:SetShow(false)
end
function PaGlobal_ImportantNotice:update()
  if nil == Panel_Important_Notice then
    return
  end
end
function PaGlobal_ImportantNotice:validate()
  if nil == Panel_Important_Notice then
    return
  end
end
function PaGlobal_ImportantNotice:updateCheckEmptyNoticeMessage()
  if 0 < ToClient_getWorldNoticeCount() then
    return false
  end
  if true == PaGlobal_ImportantNotice._isConsole then
    PaGlobal_Chat_NoticEndScreenSize()
  else
    PaGlobal_Chat_UpdateChatPanel()
  end
  return true
end
function PaGlobal_ImportantNotice_UpdatePerFrame(deltaTime)
  if nil == Panel_Important_Notice then
    return
  end
  PaGlobal_ImportantNotice:updateAnimationTime(deltaTime)
  PaGlobal_ImportantNotice:updateCheckTextMoveEnd()
end
function PaGlobal_ImportantNotice:updateAnimationTime(deltaTime)
  if false == PaGlobal_ImportantNotice._isAnimationStart then
    return
  end
  PaGlobal_ImportantNotice._animationTime = PaGlobal_ImportantNotice._animationTime + deltaTime
end
function PaGlobal_ImportantNotice:addTextMoveAnimation()
  PaGlobal_ImportantNotice._animationTime = 0
  PaGlobal_ImportantNotice._isAnimationStart = true
end
function PaGlobal_ImportantNotice:updateCheckTextMoveEnd()
  if false == PaGlobal_ImportantNotice._isAnimationStart then
    return
  end
  if PaGlobal_ImportantNotice._animationEndTime <= PaGlobal_ImportantNotice._animationTime then
    PaGlobal_ImportantNotice._isAnimationStart = false
    PaGlobal_ImportantNotice:updateStringList()
    PaGlobal_ImportantNotice:updateCheckBgSize()
    if true == PaGlobal_ImportantNotice._isFinishMessage then
      PaGlobal_ImportantNotice._isFinishMessage = false
      if true == PaGlobal_ImportantNotice:updateCheckEmptyNoticeMessage() then
        PaGlobal_ImportantNotice:prepareClose()
        return
      end
    end
    PaGlobal_ImportantNotice._ui._static_noticeBG:SetShow(true)
    PaGlobal_ImportantNotice:showNoticeText(PaGlobal_ImportantNotice:getNextNoticeIndex())
  end
end
function PaGlobal_ImportantNotice:showNoticeText(noticeIndex)
  if true == PaGlobal_ImportantNotice._isAnimationStart then
    return false
  end
  local noticeCount = ToClient_getWorldNoticeCount()
  if 0 == noticeCount then
    return false
  end
  if noticeIndex >= noticeCount then
    noticeIndex = 0
  end
  local msgInfo = ToClient_getWorldNoticeInfo(noticeIndex)
  local uiTextMessage = PaGlobal_ImportantNotice._ui._staticText_message
  PaGlobal_ImportantNotice._currentNoticeFontColor = Chatting_MessageColor(CppEnums.ChatType.Notice, msgInfo:getNoticeType())
  if PaGlobal_ImportantNotice._isShowState then
    uiTextMessage:SetFontColor(PaGlobal_ImportantNotice._currentNoticeFontColor)
  else
    uiTextMessage:SetFontColor(Defines.Color.C_00FFFFFF)
  end
  local strMessage = msgInfo:getMessage()
  uiTextMessage:SetText(strMessage)
  PaGlobal_ImportantNotice:addTextMoveAnimation()
  return true
end
function PaGlobal_ImportantNotice:getNextNoticeIndex()
  local noticeCount = ToClient_getWorldNoticeCount()
  if 0 == noticeCount then
    return 0
  end
  PaGlobal_ImportantNotice._currentNoticeIndex = PaGlobal_ImportantNotice._currentNoticeIndex + 1
  if noticeCount <= PaGlobal_ImportantNotice._currentNoticeIndex then
    PaGlobal_ImportantNotice._currentNoticeIndex = 0
  end
  return PaGlobal_ImportantNotice._currentNoticeIndex
end
function PaGlobal_ImportantNotice:getCalculateMoveEndTime(sizeX)
  return PaGlobal_ImportantNotice._moveEndTime * 0.01 * sizeX
end
function PaGlobal_ImportantNotice_GetNoticeSize()
  if true == PaGlobal_ImportantNotice._isNoticeOpen then
    return PaGlobal_ImportantNotice._applyBGSizeY
  end
  return 0
end
function PaGlobal_ImportantNotice_SetShow(isShow)
  if nil == PaGlobal_ImportantNotice then
    return
  end
  if true == isShow then
    PaGlobal_ImportantNotice._ui._static_noticeBG:SetColor(Defines.Color.C_FFFFFFFF)
    PaGlobal_ImportantNotice._ui._static_noticeIcon:SetColor(Defines.Color.C_FFFFFFFF)
    PaGlobal_ImportantNotice._ui._static_clipArea:SetColor(Defines.Color.C_FFFFFFFF)
    PaGlobal_ImportantNotice._ui._staticText_message:SetFontColor(PaGlobal_ImportantNotice._currentNoticeFontColor)
  else
    PaGlobal_ImportantNotice._ui._static_noticeBG:SetColor(Defines.Color.C_00FFFFFF)
    PaGlobal_ImportantNotice._ui._static_noticeIcon:SetColor(Defines.Color.C_00FFFFFF)
    PaGlobal_ImportantNotice._ui._static_clipArea:SetColor(Defines.Color.C_00FFFFFF)
    PaGlobal_ImportantNotice._ui._staticText_message:SetFontColor(Defines.Color.C_00FFFFFF)
  end
  PaGlobal_ImportantNotice._isShowState = isShow
end
function PaGlobal_ImportantNotice:updateCheckBgSize()
  local noticeCount = ToClient_getWorldNoticeCount()
  if 0 == noticeCount then
    return
  end
  PaGlobal_ImportantNotice._applyBGSizeY = PaGlobal_ImportantNotice:getApplyBGSizeY()
  if true == PaGlobal_ImportantNotice._isConsole then
    PaGlobal_Chat_OnScreenSize()
  else
    Chatting_OnResize()
  end
end
function PaGlobal_ImportantNotice:getApplyBGSizeY(sizeX)
  if nil == PaGlobal_ImportantNotice._stringList then
    return 0
  end
  local noticeCount = PaGlobal_ImportantNotice._stringList:length()
  if 0 == noticeCount then
    return 0
  end
  if nil == sizeX then
    sizeX = PaGlobal_ImportantNotice._ui._staticText_calculate:GetSizeX()
  end
  PaGlobal_ImportantNotice._ui._staticText_calculate:SetSize(sizeX, PaGlobal_ImportantNotice._cacheTextSizeY)
  local addSizeText = 0
  for i = 1, noticeCount do
    PaGlobal_ImportantNotice._ui._staticText_calculate:SetText(PaGlobal_ImportantNotice._stringList[i])
    local size = PaGlobal_ImportantNotice._ui._staticText_calculate:GetTextSizeY()
    addSizeText = math.max(addSizeText, size)
  end
  local defaultSize = PaGlobal_ImportantNotice._cacheBGSizeY - PaGlobal_ImportantNotice._cacheTextSizeY
  return defaultSize + addSizeText
end
function PaGlobal_ImportantNotice:updateStringList()
  PaGlobal_ImportantNotice._stringList = Array.new()
  local noticeCount = ToClient_getWorldNoticeCount()
  if 0 == noticeCount then
    return 0
  end
  for i = 1, noticeCount do
    local msgInfo = ToClient_getWorldNoticeInfo(i - 1)
    PaGlobal_ImportantNotice._stringList:push_back(msgInfo:getMessage())
  end
end
