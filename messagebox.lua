local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Win_System:RegisterShowEventFunc(true, "MessageBox_ShowAni()")
Panel_Win_System:RegisterShowEventFunc(false, "MessageBox_HideAni()")
Panel_Win_System:SetShow(false, false)
Panel_Win_System:setMaskingChild(true)
Panel_Win_System:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local textTitle = UI.getChildControl(Panel_Win_System, "Static_Text_Title")
local textBG = UI.getChildControl(Panel_Win_System, "Static_Text")
local textContent = UI.getChildControl(Panel_Win_System, "StaticText_Content")
local buttonYes = UI.getChildControl(Panel_Win_System, "Button_Yes")
local buttonApply = UI.getChildControl(Panel_Win_System, "Button_Apply")
local buttonNo = UI.getChildControl(Panel_Win_System, "Button_No")
local buttonIgnore = UI.getChildControl(Panel_Win_System, "Button_Ignore")
local buttonCancel = UI.getChildControl(Panel_Win_System, "Button_Cancel")
local buttonClose = UI.getChildControl(Panel_Win_System, "Button_Close")
local refuseInvite = UI.getChildControl(Panel_Win_System, "CheckButton_RefuseGo")
local blockBG = UI.getChildControl(Panel_Win_System, "Static_BlockBG")
local static_Beginner_BG = UI.getChildControl(Panel_Win_System, "Static_Beginner_BG")
local static_BeginnerTitleBG = UI.getChildControl(Panel_Win_System, "Static_BeginnerTitleBG")
local staticText_BeginnerTxt1 = UI.getChildControl(Panel_Win_System, "StaticText_BeginnerTxt1")
local staticText_BeginnerTxt2 = UI.getChildControl(Panel_Win_System, "StaticText_BeginnerTxt2")
local globalButtonShowCount = 0
local buttonTextSizeX = buttonYes:GetTextSizeX()
buttonTextSizeX = math.max(buttonTextSizeX, buttonApply:GetTextSizeX())
buttonTextSizeX = math.max(buttonTextSizeX, buttonNo:GetTextSizeX())
buttonTextSizeX = math.max(buttonTextSizeX, buttonIgnore:GetTextSizeX())
buttonTextSizeX = math.max(buttonTextSizeX, buttonCancel:GetTextSizeX())
buttonTextSizeX = math.min(buttonTextSizeX, 150)
if buttonYes:GetSizeX() < buttonTextSizeX + 20 then
  buttonYes:SetSize(buttonTextSizeX + 20, buttonYes:GetSizeY())
  buttonApply:SetSize(buttonTextSizeX + 20, buttonApply:GetSizeY())
  buttonNo:SetSize(buttonTextSizeX + 20, buttonNo:GetSizeY())
  buttonIgnore:SetSize(buttonTextSizeX + 20, buttonIgnore:GetSizeY())
  buttonCancel:SetSize(buttonTextSizeX + 20, buttonCancel:GetSizeY())
end
MessageBox = {}
local MessageData = {
  title = nil,
  content = nil,
  functionYes = nil,
  functionApply = nil,
  functionNo = nil,
  functionIgnore = nil,
  functionCancel = nil,
  priority = UI_PP.PAUIMB_PRIORITY_LOW,
  clientMessage = nil,
  exitButton = true,
  isTimeCount = false,
  countTime = 10,
  timeString = nil,
  isStartTimer = nil,
  afterFunction = nil,
  isCancelClose = false
}
local functionKeyUse = true
local functionYes, list
local elapsedTime = 0
local _currentMessageBoxData
local function messageBox_Resize(refuseType)
  local textSizeY = textContent:GetTextSizeY()
  textContent:SetSize(textContent:GetSizeX(), textSizeY)
  local refuseGap = 0
  if nil ~= refuseType then
    refuseGap = 30
  end
  textBG:SetSize(textBG:GetSizeX(), textSizeY + refuseGap + 40)
  Panel_Win_System:SetSize(Panel_Win_System:GetSizeX(), textBG:GetSizeY() + 97)
end
function setCurrentMessageData(currentData, position, refuseType)
  if currentData ~= nil then
    buttonYes:SetShow(false)
    buttonApply:SetShow(false)
    buttonNo:SetShow(false)
    buttonIgnore:SetShow(false)
    buttonCancel:SetShow(false)
    buttonClose:SetShow(false)
    refuseInvite:SetShow(false)
    Panel_Win_System:SetShow(true, false)
    Panel_Win_System:SetScaleChild(1, 1)
    if currentData.title ~= nil then
      textTitle:SetText(currentData.title)
    end
    if currentData.content ~= nil then
      textContent:SetTextMode(UI_TM.eTextMode_AutoWrap)
      textContent:SetText(currentData.content)
      messageBox_Resize(refuseType)
    end
    local buttonShowCount = 0
    if currentData.functionYes ~= nil then
      buttonYes:SetShow(true)
      buttonShowCount = buttonShowCount + 1
    elseif currentData.functionApply ~= nil then
      buttonApply:SetShow(true)
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.functionNo ~= nil then
      buttonNo:SetShow(true)
      buttonShowCount = buttonShowCount + 1
    elseif currentData.functionIgnore ~= nil then
      buttonIgnore:SetShow(true)
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.functionCancel ~= nil then
      buttonCancel:SetShow(true)
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.exitButton == true then
      buttonClose:SetShow(true)
    end
    globalButtonShowCount = buttonShowCount
    if 1 == buttonShowCount then
      buttonYes:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonYes:GetSizeX() / 2)
      buttonApply:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonApply:GetSizeX() / 2)
      buttonNo:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonNo:GetSizeX() / 2)
      buttonIgnore:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonIgnore:GetSizeX() / 2)
      buttonCancel:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonCancel:GetSizeX() / 2)
    elseif 2 == buttonShowCount then
      buttonYes:SetPosX(Panel_Win_System:GetSizeX() / 2 - (buttonYes:GetSizeX() / 2 + 5))
      buttonNo:SetPosX(Panel_Win_System:GetSizeX() / 2 + (buttonNo:GetSizeX() / 2 + 5))
      buttonApply:SetPosX(Panel_Win_System:GetSizeX() / 2 - (buttonApply:GetSizeX() / 2 + 5))
      buttonIgnore:SetPosX(Panel_Win_System:GetSizeX() / 2 + (buttonIgnore:GetSizeX() / 2 + 5))
      buttonCancel:SetPosX(Panel_Win_System:GetSizeX() / 2 + (buttonCancel:GetSizeX() / 2 + 5))
    elseif 3 == buttonShowCount then
      local buttonSize = buttonYes:GetSizeX()
      buttonYes:SetPosX(5)
      buttonNo:SetPosX(buttonSize + 10)
      buttonApply:SetPosX(5)
      buttonIgnore:SetPosX(buttonSize + 10)
      buttonCancel:SetPosX(buttonSize * 2 + 15)
    end
    _currentMessageBoxData = currentData
  end
end
function MessageBox.showMessageBox(MessageData, position, isGameExit, keyUse, refuseType)
  if Panel_Win_System:GetShow() and nil == MessageData.enablePriority then
    return
  end
  local Front = list
  local preList
  functionKeyUse = keyUse
  if nil ~= functionKeyUse and false == functionKeyUse then
    buttonYes:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES_WITHOUT_KEY"))
    buttonNo:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO_WITHOUT_KEY"))
    buttonApply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_APPLY_WITHOUT_KEY"))
    buttonCancel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_CANCEL_WITHOUT_KEY"))
  else
    buttonYes:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES"))
    buttonNo:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO"))
    buttonApply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_APPLY"))
    buttonCancel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_CANCEL"))
  end
  while true do
    if list == nil or list.data.priority > MessageData.priority then
      list = {
        next = list,
        pre = preList,
        data = MessageData
      }
      if list.pre == nil then
        setCurrentMessageData(list.data, position, refuseType)
        break
      end
      list.pre.next = list
      list = Front
      break
    else
      preList = list
      list = list.next
    end
  end
  if nil ~= MessageData.countTime then
    elapsedTime = 0
  end
  refuseInvite:SetShow(false)
  local optionWrapper = ToClient_getGameOptionControllerWrapper()
  if 0 == refuseType then
    local isRefuseRequests = optionWrapper:getRefuseRequests()
    refuseInvite:SetCheck(isRefuseRequests)
    refuseInvite:SetShow(true)
    refuseInvite:addInputEvent("Mouse_LUp", "PaGlobal_MessageBox_RefuseOption(0)")
  elseif 1 == refuseType then
    local isRefusePvP = optionWrapper:getPvpRefuse()
    refuseInvite:SetCheck(isRefusePvP)
    refuseInvite:SetShow(true)
    refuseInvite:addInputEvent("Mouse_LUp", "PaGlobal_MessageBox_RefuseOption(1)")
  elseif 2 == refuseType then
    local isRefusePersonTrade = optionWrapper:getIsExchangeRefuse()
    refuseInvite:SetCheck(isRefusePersonTrade)
    refuseInvite:SetShow(true)
    refuseInvite:addInputEvent("Mouse_LUp", "PaGlobal_MessageBox_RefuseOption(2)")
  else
    refuseInvite:SetShow(false)
  end
  refuseInvite:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE"))
  refuseInvite:SetEnableArea(0, 0, refuseInvite:GetTextSizeX() + 20, 25)
  refuseInvite:addInputEvent("Mouse_On", "PaGlobal_MessageBox_RefuseTip(true)")
  refuseInvite:addInputEvent("Mouse_Out", "PaGlobal_MessageBox_RefuseTip(false)")
  if true == isGameExit and ToClient_GetUserPlayMinute() < 1440 then
    Panel_Win_System:SetSize(441, 317)
    textBG:SetSize(420, 120)
    static_Beginner_BG:SetShow(true)
    static_BeginnerTitleBG:SetShow(true)
    staticText_BeginnerTxt1:SetShow(true)
    staticText_BeginnerTxt2:SetShow(true)
    static_Beginner_BG:ComputePos()
    static_BeginnerTitleBG:ComputePos()
    staticText_BeginnerTxt1:ComputePos()
    staticText_BeginnerTxt2:ComputePos()
  else
    static_Beginner_BG:SetShow(false)
    static_BeginnerTitleBG:SetShow(false)
    staticText_BeginnerTxt1:SetShow(false)
    staticText_BeginnerTxt2:SetShow(false)
  end
  local textSizeY = textContent:GetTextSizeY()
  local textBGSizeY = textContent:GetSizeY()
  local panelSizeY = textBG:GetSizeY()
  local resizePanelY = textSizeY + 90
  textBG:ComputePos()
  textContent:ComputePos()
  refuseInvite:ComputePos()
  refuseInvite:SetPosX(Panel_Win_System:GetSizeX() / 2 - (refuseInvite:GetSizeX() + refuseInvite:GetTextSizeX() / 2))
  blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  blockBG:ComputePos()
  messageBoxComputePos()
end
function PaGlobal_MessageBox_RefuseOption(refuseType)
  if 0 == refuseType then
    setRefuseRequests(refuseInvite:IsCheck())
  elseif 1 == refuseType then
    setIsPvpRefuse(refuseInvite:IsCheck())
  elseif 2 == refuseType then
    setIsExchangeRefuse(refuseInvite:IsCheck())
  end
end
function PaGlobal_MessageBox_RefuseTip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE")
  desc = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE_TIP_DESC")
  control = refuseInvite
  TooltipSimple_Show(control, name, desc)
end
function messageBoxComputePos()
  blockBG:SetSize(getScreenSizeX() + 500, getScreenSizeY() + 500)
  Panel_Win_System:ComputePos()
  textTitle:ComputePos()
  textContent:ComputePos()
  textBG:ComputePos()
  buttonYes:ComputePos()
  buttonApply:ComputePos()
  buttonNo:ComputePos()
  buttonIgnore:ComputePos()
  buttonCancel:ComputePos()
  buttonClose:ComputePos()
  blockBG:ComputePos()
  if 1 == globalButtonShowCount then
    buttonYes:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonYes:GetSizeX() / 2)
    buttonApply:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonApply:GetSizeX() / 2)
    buttonNo:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonNo:GetSizeX() / 2)
    buttonIgnore:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonIgnore:GetSizeX() / 2)
    buttonCancel:SetPosX(Panel_Win_System:GetSizeX() / 2 - buttonCancel:GetSizeX() / 2)
  elseif 2 == globalButtonShowCount then
    buttonYes:SetPosX(Panel_Win_System:GetSizeX() / 2 - (buttonYes:GetSizeX() + 1))
    buttonNo:SetPosX(Panel_Win_System:GetSizeX() / 2 + 1)
    buttonApply:SetPosX(Panel_Win_System:GetSizeX() / 2 - (buttonApply:GetSizeX() + 1))
    buttonIgnore:SetPosX(Panel_Win_System:GetSizeX() / 2 + 1)
    buttonCancel:SetPosX(Panel_Win_System:GetSizeX() / 2 + 1)
  elseif 3 == globalButtonShowCount then
    local buttonSize = buttonYes:GetSizeX()
    buttonYes:SetPosX(5)
    buttonNo:SetPosX(buttonSize + 10)
    buttonApply:SetPosX(5)
    buttonIgnore:SetPosX(buttonSize + 10)
    buttonCancel:SetPosX(buttonSize * 2 + 15)
  end
end
function postProcessMessageData()
  Panel_Win_System:SetShow(false, false)
  _currentMessageBoxData = nil
  if list ~= nil and list.data ~= nil then
    list.data = nil
    list = list.next
    if list ~= nil then
      setCurrentMessageData(list.data)
    end
  end
end
function allClearMessageData()
  Panel_Win_System:SetShow(false, false)
  if list == nil then
    return
  end
  while list ~= nil and list.data ~= nil do
    list.data = nil
    list = list.next
  end
end
function MessageBox.doHaveMessageBoxData(title)
  while list ~= nil and list.data ~= nil do
    if list.data.title == title then
      return true
    end
    list = list.next
  end
  if MessageBox.isCurrentOpen(title) then
    return true
  end
  return false
end
function MessageBox.isPopUp()
  return Panel_Win_System:IsShow()
end
function MessageBox.isCurrentOpen(title)
  if nil ~= _currentMessageBoxData and _currentMessageBoxData.title == title then
    return true
  end
  return false
end
function MessageBox.keyProcessEnter()
  local enterkeyExecute
  if not functionKeyUse and nil ~= functionKeyUse then
    return
  end
  if list ~= nil and list.data.functionYes ~= nil then
    list.data.isStartTimer = true
    enterkeyExecute = list.data.functionYes
  end
  if list ~= nil and list.data.functionApply ~= nil then
    enterkeyExecute = list.data.functionApply
  end
  if list ~= nil and nil == list.data.functionYes and nil == list.data.functionApply then
    enterkeyExecute = nil
    return
  end
  if list ~= nil and list.data.clientMessage ~= nil then
    sendGameMessageParam0(list.data.clientMessage)
  end
  postProcessMessageData()
  if enterkeyExecute ~= nil then
    enterkeyExecute()
  end
end
function MessageBox.keyProcessEscape()
  if not functionKeyUse and nil ~= functionKeyUse then
    return
  end
  if list ~= nil and (list.data.exitButton or list.data.functionCancel or list.data.functionNo) then
    messageBox_CloseButtonUp()
  end
end
function MessageBox_ShowAni()
  local aniInfo8 = Panel_Win_System:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(5)
  aniInfo8:SetEndIntensity(1)
  local aniInfo1 = Panel_Win_System:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.1)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Win_System:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Win_System:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Win_System:addScaleAnimation(0.08, 0.14, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Win_System:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Win_System:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function MessageBox_HideAni()
  Panel_Win_System:SetShow(false, false)
end
function messageBox_YesButtonUp()
  local functionYes
  if list ~= nil and list.data.functionYes ~= nil then
    list.data.isStartTimer = true
    functionYes = list.data.functionYes
  end
  if list ~= nil and list.data.clientMessage ~= nil then
    sendGameMessageParam0(list.data.clientMessage)
  end
  postProcessMessageData()
  if functionYes ~= nil then
    functionYes()
  end
end
function messageBox_ApplyButtonUp()
  local functionApply
  if list ~= nil and list.data.functionApply ~= nil then
    elapsedTime = 0
    functionApply = list.data.functionApply
  end
  if list ~= nil and list.data.clientMessage ~= nil then
    sendGameMessageParam0(list.data.clientMessage)
  end
  postProcessMessageData()
  if functionApply ~= nil then
    functionApply()
  end
end
function messageBox_NoButtonUp()
  local functionNo
  if list ~= nil and list.data.functionNo ~= nil then
    functionNo = list.data.functionNo
  end
  postProcessMessageData()
  if functionNo ~= nil then
    functionNo()
  end
end
function messageBox_IgnoreButtonUp()
  local functionIgnore
  if list ~= nil and list.data.functionIgnore ~= nil then
    functionIgnore = list.data.functionIgnore
  end
  postProcessMessageData()
  if functionIgnore ~= nil then
    functionIgnore()
  end
end
function messageBox_CancelButtonUp()
  local functionCancel
  if list ~= nil and list.data.functionCancel ~= nil then
    elapsedTime = 0
    functionCancel = list.data.functionCancel
  end
  postProcessMessageData()
  if functionCancel ~= nil then
    functionCancel()
  end
end
function messageBox_CloseButtonUp()
  local functionNo
  if list ~= nil and list.data.functionNo ~= nil then
    functionNo = list.data.functionNo
  end
  local functionCancel
  if list ~= nil and list.data.functionCancel ~= nil then
    functionCancel = list.data.functionCancel
  elseif true == isCancelClose then
    MessageBox_Empty_function()
  end
  postProcessMessageData()
  if functionNo ~= nil then
    functionNo()
  end
  if functionCancel ~= nil then
    functionCancel()
  end
end
function Event_MessageBox_NotifyMessage_CashAlert(message)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW,
    exitButton = false
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function Event_MessageBox_NotifyMessage(message)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW,
    exitButton = false
  }
  MessageBox.showMessageBox(messageboxData)
end
function Event_MessageBox_NotifyMessage_FreeButton(message)
  if true == ToClient_isConsole() then
    local messageboxData = {
      title = "",
      content = message,
      priority = UI_PP.PAUIMB_PRIORITY_LOW,
      exitButton = false
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local messageboxData = {
      title = "",
      content = message,
      priority = UI_PP.PAUIMB_PRIORITY_1,
      exitButton = false
    }
    MessageBox.showMessageBox(messageboxData)
  end
end
function Event_MessageBox_NotifyMessage_With_ClientMessage(message, gameMessageType)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_1,
    clientMessage = gameMessageType,
    exitButton = false
  }
  MessageBox.showMessageBox(messageboxData)
end
function MessageBox_Empty_function()
end
function messageBox_UpdatePerFrame(deltaTime)
  if nil == list or nil == list.data or nil == list.data.isTimeCount or false == list.data.isStartTimer then
    return
  end
  elapsedTime = elapsedTime + deltaTime
  if elapsedTime < list.data.countTime then
    if nil ~= list.data.timeString then
      local remainTime = math.floor(list.data.countTime - elapsedTime)
      textTitle:SetText(remainTime .. list.data.timeString)
    end
  elseif nil ~= list.data.afterFunction then
    list.data.isTimeCount = false
    list.data.afterFunction()
  end
end
local function postRestoreEvent()
  if nil == _currentMessageBoxData then
    return
  end
  setCurrentMessageData(_currentMessageBoxData)
end
buttonYes:addInputEvent("Mouse_LUp", "messageBox_YesButtonUp()")
buttonApply:addInputEvent("Mouse_LUp", "messageBox_ApplyButtonUp()")
buttonNo:addInputEvent("Mouse_LUp", "messageBox_NoButtonUp()")
buttonIgnore:addInputEvent("Mouse_LUp", "messageBox_IgnoreButtonUp()")
buttonCancel:addInputEvent("Mouse_LUp", "messageBox_CancelButtonUp()")
buttonClose:addInputEvent("Mouse_LUp", "messageBox_CloseButtonUp()")
registerEvent("EventNotifyMessage", "Event_MessageBox_NotifyMessage")
registerEvent("EventNotifyMessageFreeButton", "Event_MessageBox_NotifyMessage_FreeButton")
registerEvent("EventNotifyFreeButtonMessageProcess", "postProcessMessageData")
registerEvent("EventNotifyAllClearMessageData", "allClearMessageData")
registerEvent("EventNotifyMessageWithClientMessage", "Event_MessageBox_NotifyMessage_With_ClientMessage")
registerEvent("EventNotifyMessageCashAlert", "Event_MessageBox_NotifyMessage_CashAlert")
Panel_Win_System:RegisterUpdateFunc("messageBox_UpdatePerFrame")
