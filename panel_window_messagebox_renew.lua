local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
PaGlobal_registerPanelOnBlackBackground(Panel_Win_System)
Panel_Win_System:ignorePadSnapMoveToOtherPanel()
Panel_Win_System:RegisterShowEventFunc(true, "MessageBox_ShowAni()")
Panel_Win_System:RegisterShowEventFunc(false, "MessageBox_HideAni()")
Panel_Win_System:registerPadEvent(__eConsoleUIPadEvent_Up_A, "MessageBox.keyProcessEnter()")
PaGlobal_registerPanelOnBlackBackground(Panel_MessageBox_Loading)
Panel_MessageBox_Loading:ignorePadSnapMoveToOtherPanel()
Panel_MessageBox_Loading:registerPadEvent(__eConsoleUIPadEvent_Up_A, "MessageBox.keyProcessEnter()")
Panel_Win_System:SetShow(false, false)
Panel_Win_System:setMaskingChild(true)
Panel_Win_System:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local static_Inner = UI.getChildControl(Panel_Win_System, "Static_Inner2")
local static_InnerLine1 = UI.getChildControl(static_Inner, "Static_Line1")
local static_InnerLine3 = UI.getChildControl(static_Inner, "Static_Line3")
local defaultPanelSize = Panel_Win_System:GetSizeY()
local defaultContentSize = static_Inner:GetSizeY()
local staticText_Title = UI.getChildControl(Panel_Win_System, "StaticText_Title")
local staticText_Desc = UI.getChildControl(Panel_Win_System, "StaticText_Desc")
local staticText_OK_ConsoleUI = UI.getChildControl(Panel_Win_System, "StaticText_OK_ConsoleUI")
local staticText_NO_ConsoleUI = UI.getChildControl(Panel_Win_System, "StaticText_NO_ConsoleUI")
local button_Ok = UI.getChildControl(Panel_Win_System, "Button_Ok")
local button_No = UI.getChildControl(Panel_Win_System, "Button_No")
local messageBoxWidth = Panel_Win_System:GetSizeX()
local messageBoxAddWidth = 40
local globalButtonShowCount = 0
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
  isCancelClose = false,
  isShowLoadingEffect = false
}
local functionKeyUse = true
local functionYes, list
local elapsedTime = 0
local _currentMessageBoxData
local Panel_Window_MessageBox_Info = {}
function Panel_Window_MessageBox_Info:open(showAni)
  if nil == showAni then
    Panel_Win_System:SetShow(true, false)
  else
    Panel_Win_System:SetShow(true, showAni)
  end
  _AudioPostEvent_SystemUiForXBOX(8, 14)
end
function Panel_Window_MessageBox_Info:close(showAni)
  if nil == showAni then
    Panel_Win_System:SetShow(false, false)
  else
    Panel_Win_System:SetShow(false, showAni)
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_MessageBox_Loading:SetShow(false)
end
function setCurrentMessageData(currentData, position)
  local self = Panel_Window_MessageBox_Info
  if currentData ~= nil then
    staticText_OK_ConsoleUI:SetShow(false)
    staticText_NO_ConsoleUI:SetShow(false)
    button_Ok:SetShow(false)
    button_No:SetShow(false)
    Panel_Win_System:SetScaleChild(1, 1)
    if currentData.title ~= nil then
      staticText_Title:SetText(currentData.title)
    end
    if currentData.content ~= nil then
      staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      staticText_Desc:SetText(currentData.content)
      staticText_Desc:ComputePos()
      if staticText_Desc:GetTextSizeY() <= defaultContentSize then
        Panel_Win_System:SetSize(Panel_Win_System:GetSizeX(), defaultPanelSize)
        static_Inner:SetSize(static_Inner:GetSizeX(), defaultContentSize)
      else
        local gap = staticText_Desc:GetTextSizeY() - defaultContentSize + 40
        Panel_Win_System:SetSize(Panel_Win_System:GetSizeX(), defaultPanelSize + gap)
        static_Inner:SetSize(static_Inner:GetSizeX(), defaultContentSize + gap)
      end
    end
    if nil == currentData.functionYes and nil == currentData.functionApply and nil == currentData.functionNo and true ~= currentData.isShowLoadingEffect then
      Panel_MessageBox_Loading_Show(currentData.content)
      return
    else
      self:open(false)
    end
    local buttonShowCount = 0
    if currentData.functionYes ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        staticText_OK_ConsoleUI:SetShow(true)
      else
        button_Ok:SetShow(true)
      end
      staticText_OK_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES_WITHOUT_KEY"))
      button_Ok:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES"))
      staticText_OK_ConsoleUI:addInputEvent("Mouse_LUp", "messageBox_YesButtonUp()")
      button_Ok:addInputEvent("Mouse_LUp", "messageBox_YesButtonUp()")
      buttonShowCount = buttonShowCount + 1
    elseif currentData.functionApply ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        staticText_OK_ConsoleUI:SetShow(true)
      else
        button_Ok:SetShow(true)
      end
      staticText_OK_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_APPLY_WITHOUT_KEY"))
      button_Ok:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_APPLY"))
      staticText_OK_ConsoleUI:addInputEvent("Mouse_LUp", "messageBox_ApplyButtonUp()")
      button_Ok:addInputEvent("Mouse_LUp", "messageBox_ApplyButtonUp()")
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.functionNo ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        staticText_NO_ConsoleUI:SetShow(true)
      else
        button_No:SetShow(true)
      end
      staticText_NO_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO_WITHOUT_KEY"))
      button_No:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO"))
      staticText_NO_ConsoleUI:addInputEvent("Mouse_LUp", "messageBox_NoButtonUp()")
      button_No:addInputEvent("Mouse_LUp", "messageBox_NoButtonUp()")
      buttonShowCount = buttonShowCount + 1
    elseif currentData.functionCancel ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        staticText_NO_ConsoleUI:SetShow(true)
      else
        button_No:SetShow(true)
      end
      staticText_NO_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_CANCEL_WITHOUT_KEY"))
      button_No:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_CANCEL"))
      staticText_NO_ConsoleUI:addInputEvent("Mouse_LUp", "messageBox_CancelButtonUp()")
      button_No:addInputEvent("Mouse_LUp", "messageBox_CancelButtonUp()")
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.functionIgnore ~= nil then
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.exitButton == true then
    end
    globalButtonShowCount = buttonShowCount
    messageBoxComputePos()
    _currentMessageBoxData = currentData
  end
end
function Panel_MessageBox_Loading_Show(msg)
  Panel_MessageBox_Loading:SetShow(true)
  local message = UI.getChildControl(Panel_MessageBox_Loading, "StaticText_Message")
  message:SetText(msg)
  if nil ~= ToClient_isLobbyProcessor and true == ToClient_isLobbyProcessor() or nil ~= ToClient_isGamePlayProcessor and true == ToClient_isGamePlayProcessor() then
    local effect = UI.getChildControl(Panel_MessageBox_Loading, "Static_Effect")
    effect:EraseAllEffect()
    effect:AddEffect("UI_Loading_01A", true, 0, 0)
    message:SetPosY(getScreenSizeY() * 0.5 + 100)
  else
    message:SetPosY((getScreenSizeY() - message:GetTextSizeY()) * 0.5)
  end
end
function messageBoxComputePos()
  Panel_Win_System:ComputePos()
  static_Inner:ComputePos()
  static_InnerLine1:ComputePos()
  static_InnerLine3:ComputePos()
  staticText_Title:ComputePos()
  staticText_Desc:ComputePos()
  staticText_OK_ConsoleUI:ComputePos()
  staticText_NO_ConsoleUI:ComputePos()
  button_Ok:ComputePos()
  button_No:ComputePos()
  local consoleSizeOk = staticText_OK_ConsoleUI:GetSizeX() + staticText_OK_ConsoleUI:GetTextSizeX()
  local consoleSizeNO = staticText_NO_ConsoleUI:GetSizeX() + staticText_NO_ConsoleUI:GetTextSizeX()
  if 1 == globalButtonShowCount then
    staticText_OK_ConsoleUI:SetPosX(Panel_Win_System:GetSizeX() / 2 - consoleSizeOk / 2)
    staticText_NO_ConsoleUI:SetPosX(Panel_Win_System:GetSizeX() / 2 - consoleSizeNO / 2)
    button_Ok:SetPosX(Panel_Win_System:GetSizeX() / 2 - button_Ok:GetSizeX() / 2)
    button_No:SetPosX(Panel_Win_System:GetSizeX() / 2 - button_No:GetSizeX() / 2)
  elseif 2 == globalButtonShowCount then
    local space = (Panel_Win_System:GetSizeX() - consoleSizeOk - consoleSizeNO) / 4
    staticText_OK_ConsoleUI:SetPosX(Panel_Win_System:GetSizeX() / 2 - consoleSizeOk / 2 - space)
    staticText_NO_ConsoleUI:SetPosX(Panel_Win_System:GetSizeX() / 2 - consoleSizeNO / 2 + space)
    button_Ok:SetPosX(Panel_Win_System:GetSizeX() / 2 - button_Ok:GetSizeX() - 10)
    button_No:SetPosX(Panel_Win_System:GetSizeX() / 2 + 10)
  elseif 3 == globalButtonShowCount then
    _PA_ASSERT(true, "messageBox\236\151\144\236\132\156 \237\145\156\236\139\156\237\149\180\236\149\188\237\149\160 \234\176\175\236\136\152\234\176\128  " .. tostring(buttonShowCount) .. "\234\176\156\236\157\184 \234\178\189\236\154\176\234\176\128 \235\176\156\236\131\157\237\150\136\236\138\181\235\139\136\235\139\164.")
    local buttonSize
    if true == _ContentsGroup_RenewUI_MessageBox then
      buttonSize = staticText_OK_ConsoleUI:GetSizeX() + staticText_OK_ConsoleUI:GetTextSpan().x
    else
      buttonSize = button_Ok:GetSizeX()
    end
    staticText_OK_ConsoleUI:SetPosX(5)
    staticText_NO_ConsoleUI:SetPosX(buttonSize + 10)
    button_Ok:SetPosX(5)
    button_No:SetPosX(buttonSize + 10)
  end
end
function postProcessMessageData()
  local self = Panel_Window_MessageBox_Info
  self:close(false)
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
  local self = Panel_Window_MessageBox_Info
  self:close(false)
  if list == nil then
    return
  end
  while list ~= nil and list.data ~= nil do
    list.data = nil
    list = list.next
  end
end
function MessageBox.showMessageBox(MessageData, position, isGameExit, keyUse)
  if Panel_Win_System:GetShow() and nil == MessageData.enablePriority then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  local Front = list
  local preList
  functionKeyUse = keyUse
  if nil ~= functionKeyUse and false == functionKeyUse then
    button_Ok:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES_WITHOUT_KEY"))
    button_No:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO_WITHOUT_KEY"))
    staticText_OK_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES_WITHOUT_KEY"))
    staticText_NO_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO_WITHOUT_KEY"))
  else
    button_Ok:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES"))
    button_No:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO"))
    staticText_OK_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_YES_WITHOUT_KEY"))
    staticText_NO_ConsoleUI:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_NO_WITHOUT_KEY"))
  end
  while true do
    if list == nil or list.data.priority > MessageData.priority then
      list = {
        next = list,
        pre = preList,
        data = MessageData
      }
      if list.pre == nil then
        setCurrentMessageData(list.data, position)
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
  MessageBox_ContentResize()
  messageBoxComputePos()
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
  return Panel_Win_System:IsShow() or Panel_MessageBox_Loading:IsShow()
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
  _AudioPostEvent_SystemUiForXBOX(50, 3)
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
  _AudioPostEvent_SystemUiForXBOX(50, 1)
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
  _AudioPostEvent_SystemUiForXBOX(50, 1)
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
  if nil ~= Panel_CharacterSelect_Renew and true == Panel_CharacterSelect_Renew:GetShow() then
    PaGlobal_CharacterSelect_SetBlockSelectFalse()
  end
  if nil ~= Panel_Window_Improvement_Renew and true == Panel_Window_Improvement_Renew:GetShow() then
    local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
    local messageboxData = {
      title = titleText,
      content = message,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW,
      exitButton = false,
      isShowLoadingEffect = true
    }
    MessageBox.showMessageBox(messageboxData)
    return
  end
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
function Event_MessageBox_NotifyMessage_EnablePriority(message)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_2,
    exitButton = false,
    enablePriority = true
  }
  MessageBox.showMessageBox(messageboxData)
end
function Event_MessageBox_NotifyMessage_FreeButton(message)
  local messageboxData = {
    title = "",
    content = message,
    priority = UI_PP.PAUIMB_PRIORITY_1,
    exitButton = false
  }
  MessageBox.showMessageBox(messageboxData)
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
function Event_MessageBox_ConsoleDisconnect(message, gameMessageType)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = disConnectToGame,
    priority = UI_PP.PAUIMB_PRIORITY_1,
    clientMessage = gameMessageType,
    exitButton = false
  }
  MessageBox.showMessageBox(messageboxData)
end
function Event_MessageBox_Update_NotifyMessage(message)
  if false == Panel_Win_System:GetShow() then
    return
  end
  if nil ~= message then
    staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    staticText_Desc:SetText(message)
    MessageBox_ContentResize()
    messageBoxComputePos()
  end
end
function MessageBox_ContentResize()
  local titleTextLength = staticText_Title:GetTextSizeX()
  local gap = staticText_Desc:GetTextSizeY() - defaultContentSize + 40
  local panelX = math.max(messageBoxWidth, titleTextLength)
  if gap > 0 then
    Panel_Win_System:SetSize(panelX + messageBoxAddWidth, defaultPanelSize + gap)
    static_Inner:SetSize(panelX + messageBoxAddWidth - 10, defaultContentSize + gap)
  else
    Panel_Win_System:SetSize(panelX + messageBoxAddWidth, defaultPanelSize)
    static_Inner:SetSize(panelX + messageBoxAddWidth - 10, defaultContentSize)
  end
end
function MessageBox_Empty_function()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
end
function messageBox_UpdatePerFrame(deltaTime)
  if nil == list or nil == list.data or nil == list.data.isTimeCount or false == list.data.isStartTimer then
    return
  end
  elapsedTime = elapsedTime + deltaTime
  if elapsedTime < list.data.countTime then
    if nil ~= list.data.timeString then
      local remainTime = math.floor(list.data.countTime - elapsedTime)
      staticText_Title:SetText(remainTime .. list.data.timeString)
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
registerEvent("EventNotifyMessage", "Event_MessageBox_NotifyMessage")
registerEvent("EventNotifyMessageEnablePriority", "Event_MessageBox_NotifyMessage_EnablePriority")
registerEvent("EventNotifyMessageFreeButton", "Event_MessageBox_NotifyMessage_FreeButton")
registerEvent("EventNotifyFreeButtonMessageProcess", "postProcessMessageData")
registerEvent("EventNotifyAllClearMessageData", "allClearMessageData")
registerEvent("EventNotifyMessageWithClientMessage", "Event_MessageBox_NotifyMessage_With_ClientMessage")
registerEvent("EventUpdateNotifyMessage", "Event_MessageBox_Update_NotifyMessage")
registerEvent("FromClient_DisconnectMessageBoxForConsole", "Event_MessageBox_ConsoleDisconnect")
registerEvent("EventNotifyMessageCashAlert", "Event_MessageBox_NotifyMessage_CashAlert")
Panel_Win_System:RegisterUpdateFunc("messageBox_UpdatePerFrame")
