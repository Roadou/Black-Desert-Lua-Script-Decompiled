local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Win_Check:ignorePadSnapMoveToOtherPanel()
Panel_Win_Check:RegisterShowEventFunc(true, "MessageBoxCheck_ShowAni()")
Panel_Win_Check:RegisterShowEventFunc(false, "MessageBoxCheck_HideAni()")
Panel_Win_Check:registerPadEvent(__eConsoleUIPadEvent_Up_A, "MessageBoxCheck.keyProcessEnter()")
UI.getChildControl(Panel_Win_Check, "Button_OK_ConsoleUI"):addInputEvent("Mouse_LUp", "MessageBoxCheck.keyProcessEnter()")
Panel_Win_Check:SetShow(false, false)
Panel_Win_Check:setMaskingChild(true)
Panel_Win_Check:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local staticText_Title = UI.getChildControl(Panel_Win_Check, "StaticText_Title")
local static_Inner = UI.getChildControl(Panel_Win_Check, "Static_Inner2")
local static_Line2 = UI.getChildControl(static_Inner, "Static_Line2")
local static_Line3 = UI.getChildControl(static_Inner, "Static_Line3")
local staticText_Desc = UI.getChildControl(Panel_Win_Check, "StaticText_Desc")
local radioButton_Me = UI.getChildControl(Panel_Win_Check, "RadioButton_Me")
local staticText_SilverIven = UI.getChildControl(radioButton_Me, "StaticText_SilverIven")
local staticText_SilverInInven = UI.getChildControl(radioButton_Me, "StaticText_SilverInInven")
local radioButton_All = UI.getChildControl(Panel_Win_Check, "RadioButton_All")
local staticText_SilverStorage = UI.getChildControl(radioButton_All, "StaticText_SilverStorage")
local staticText_SilverInStorage = UI.getChildControl(radioButton_All, "StaticText_SilverInStorage")
local button_OK_ConsoleUI = UI.getChildControl(Panel_Win_Check, "Button_OK_ConsoleUI")
local button_NO_ConsoleUI = UI.getChildControl(Panel_Win_Check, "Button_NO_ConsoleUI")
local button_Ok = UI.getChildControl(Panel_Win_Check, "Button_Ok")
local button_No = UI.getChildControl(Panel_Win_Check, "Button_No")
local globalButtonShowCount = 0
local panelSizeY = Panel_Win_Check:GetSizeY()
local innerSizeY = static_Inner:GetSizeY()
MessageBoxCheck = {}
local MessageCheckData = {
  title = nil,
  content = nil,
  functionApply = nil,
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
local list
local elapsedTime = 0
local _currentMessageBoxCheckData
function setCurrentMessageCheckData(currentData, position)
  if currentData ~= nil then
    button_OK_ConsoleUI:SetShow(false)
    button_NO_ConsoleUI:SetShow(false)
    button_Ok:SetShow(false)
    button_No:SetShow(false)
    Panel_Win_Check:SetShow(true, false)
    Panel_Win_Check:SetScaleChild(1, 1)
    if currentData.title ~= nil then
      staticText_Title:SetText(currentData.title)
    end
    if currentData.content ~= nil then
      staticText_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
      staticText_Desc:SetText(currentData.content)
    end
    local buttonShowCount = 0
    if currentData.functionApply ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        button_OK_ConsoleUI:SetShow(true)
      else
        button_Ok:SetShow(true)
      end
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.functionCancel ~= nil then
      if true == _ContentsGroup_RenewUI_MessageBox then
        button_NO_ConsoleUI:SetShow(true)
      else
        button_No:SetShow(true)
      end
      buttonShowCount = buttonShowCount + 1
    end
    if currentData.exitButton == true then
    end
    globalButtonShowCount = buttonShowCount
    if 1 == buttonShowCount then
      button_OK_ConsoleUI:SetPosX(Panel_Win_Check:GetSizeX() / 2 - button_OK_ConsoleUI:GetSizeX() / 2 - button_OK_ConsoleUI:GetTextSpan().x / 2)
      button_NO_ConsoleUI:SetPosX(Panel_Win_Check:GetSizeX() / 2 - button_NO_ConsoleUI:GetSizeX() / 2 - button_NO_ConsoleUI:GetTextSpan().x / 2)
      button_Ok:SetHorizonCenter()
      button_No:SetHorizonCenter()
    elseif 2 == buttonShowCount then
      button_OK_ConsoleUI:ComputePos()
      button_NO_ConsoleUI:ComputePos()
      button_Ok:ComputePos()
      button_No:ComputePos()
    elseif 3 == buttonShowCount then
      _PA_LOG("mingu", "\235\169\148\236\139\156\236\167\128\236\151\144 buttonShowCount\234\176\128 3\234\176\156\236\157\184 \234\178\189\236\154\176\234\176\128 \236\161\180\236\158\172\237\149\156\235\139\164.")
      button_OK_ConsoleUI:ComputePos()
      button_NO_ConsoleUI:ComputePos()
      button_Ok:ComputePos()
      button_No:ComputePos()
    end
    _currentMessageBoxCheckData = currentData
  end
end
function MessageBoxCheck.showMessageBox(MessageCheckData, position, keyUse)
  local Front = list
  local preList
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local myInvenMoney = selfPlayer:get():getInventory():getMoney_s64()
  functionKeyUse = keyUse
  while true do
    if list == nil or list.data.priority > MessageCheckData.priority then
      list = {
        next = list,
        pre = preList,
        data = MessageCheckData
      }
      if list.pre == nil then
        setCurrentMessageCheckData(list.data, position)
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
  local useCustomButtonFlag = MessageCheckData.buttonStrings and 2 <= table.getn(MessageCheckData.buttonStrings)
  if useCustomButtonFlag then
    staticText_SilverIven:SetShow(false)
    staticText_SilverInInven:SetShow(false)
    staticText_SilverStorage:SetShow(false)
    staticText_SilverInStorage:SetShow(false)
    local firstButton = MessageBoxCheck.getButtonByIndex(1)
    firstButton:SetText(MessageCheckData.buttonStrings[1])
    firstButton:SetCheck(true)
    local secondButton = MessageBoxCheck.getButtonByIndex(2)
    secondButton:SetText(MessageCheckData.buttonStrings[2])
    secondButton:SetCheck(false)
  else
    staticText_SilverIven:SetShow(true)
    staticText_SilverInInven:SetShow(true)
    staticText_SilverStorage:SetShow(true)
    staticText_SilverInStorage:SetShow(true)
    radioButton_Me:SetText("")
    radioButton_All:SetText("")
    if ToClient_HasWareHouseFromNpc() then
      if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
        radioButton_Me:SetCheck(true)
        radioButton_All:SetCheck(false)
      else
        radioButton_Me:SetCheck(false)
        radioButton_All:SetCheck(true)
      end
      staticText_SilverInStorage:SetShow(true)
      radioButton_All:SetShow(true)
    else
      radioButton_Me:SetCheck(true)
      radioButton_All:SetCheck(false)
      staticText_SilverInStorage:SetShow(false)
      radioButton_All:SetShow(false)
    end
    staticText_SilverInInven:SetText(makeDotMoney(myInvenMoney))
    staticText_SilverInStorage:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  end
  local textSizeY = staticText_Desc:GetTextSizeY()
  local textBGSizeY = staticText_Desc:GetSizeY()
  local textSize = textSizeY - textBGSizeY
  staticText_Desc:SetTextVerticalTop()
  Panel_Win_Check:SetSize(Panel_Win_Check:GetSizeX(), panelSizeY + textSize)
  static_Inner:SetSize(static_Inner:GetSizeX(), innerSizeY + textSize)
  static_Line2:SetPosY(static_Line2:GetPosY() + textSize)
  static_Line3:SetPosY(static_Line3:GetPosY() + textSize)
  radioButton_Me:SetPosY(radioButton_Me:GetPosY() + textSize)
  radioButton_All:SetPosY(radioButton_All:GetPosY() + textSize)
  messageBoxCheckComputePos()
end
function messageBoxCheckComputePos()
  Panel_Win_Check:ComputePos()
  staticText_Title:ComputePos()
  staticText_Desc:ComputePos()
  static_Inner:ComputePos()
  static_Line3:ComputePos()
  button_OK_ConsoleUI:ComputePos()
  button_NO_ConsoleUI:ComputePos()
  button_Ok:ComputePos()
  button_No:ComputePos()
  staticText_SilverInInven:ComputePos()
  staticText_SilverInStorage:ComputePos()
  if 1 == globalButtonShowCount then
    button_OK_ConsoleUI:SetPosX(Panel_Win_Check:GetSizeX() / 2 - button_OK_ConsoleUI:GetSizeX() / 2 - button_OK_ConsoleUI:GetTextSpan().x / 2)
    button_NO_ConsoleUI:SetPosX(Panel_Win_Check:GetSizeX() / 2 - button_OK_ConsoleUI:GetSizeX() / 2 - button_NO_ConsoleUI:GetTextSpan().x / 2)
    button_Ok:SetHorizonCenter()
    button_No:SetHorizonCenter()
  elseif 2 == globalButtonShowCount then
    button_OK_ConsoleUI:ComputePos()
    button_NO_ConsoleUI:ComputePos()
    button_Ok:ComputePos()
    button_No:ComputePos()
  elseif 3 == globalButtonShowCount then
    button_OK_ConsoleUI:ComputePos()
    button_NO_ConsoleUI:ComputePos()
    button_Ok:ComputePos()
    button_No:ComputePos()
  end
end
function postProcessMessageCheckData()
  Panel_Win_Check:SetShow(false, false)
  _currentMessageBoxCheckData = nil
  if list ~= nil and list.data ~= nil then
    list.data = nil
    list = list.next
    if list ~= nil then
      setCurrentMessageCheckData(list.data)
    end
  end
end
function allClearMessageCheckData()
  Panel_Win_Check:SetShow(false, false)
  if list == nil then
    return
  end
  while list ~= nil and list.data ~= nil do
    list.data = nil
    list = list.next
  end
end
function MessageBoxCheck.doHaveMessageBoxData(title)
  while list ~= nil and list.data ~= nil do
    if list.data.title == title then
      return true
    end
    list = list.next
  end
  if MessageBoxCheck.isCurrentOpen(title) then
    return true
  end
  return false
end
function MessageBoxCheck.isPopUp()
  return Panel_Win_Check:IsShow()
end
function MessageBoxCheck.isCheck()
  local isMoneyWhereType = CppEnums.ItemWhereType.eInventory
  if radioButton_Me:IsCheck() then
    isMoneyWhereType = CppEnums.ItemWhereType.eInventory
  elseif radioButton_All:IsCheck() then
    isMoneyWhereType = CppEnums.ItemWhereType.eWarehouse
  else
    isMoneyWhereType = CppEnums.ItemWhereType.eInventory
  end
  return isMoneyWhereType
end
function MessageBoxCheck.getSelectedButtonIndex()
  if radioButton_Me:IsCheck() then
    return 1
  elseif radioButton_All:IsCheck() then
    return 2
  end
  return 0
end
function MessageBoxCheck.getButtonByIndex(i)
  if 1 == i then
    return radioButton_Me
  elseif 2 == i then
    return radioButton_All
  end
end
function MessageBoxCheck.isCurrentOpen(title)
  if nil ~= _currentMessageBoxCheckData and _currentMessageBoxCheckData.title == title then
    return true
  end
  return false
end
function MessageBoxCheck.keyProcessEnter()
  if not functionKeyUse and nil ~= functionKeyUse then
    return
  end
  if list ~= nil and list.data.functionApply ~= nil then
    list.data.functionApply(MessageBoxCheck.getSelectedButtonIndex())
  end
  if list ~= nil and nil == list.data.functionApply then
    return
  end
  if list ~= nil and list.data.clientMessage ~= nil then
    sendGameMessageParam0(list.data.clientMessage)
  end
  postProcessMessageCheckData()
end
function MessageBoxCheck.keyProcessEscape()
  if not functionKeyUse and nil ~= functionKeyUse then
    return
  end
  if list ~= nil and (list.data.exitButton or list.data.functionCancel) then
    messageBoxCheck_CloseButtonUp()
  end
end
function MessageBoxCheck_ShowAni()
  local aniInfo8 = Panel_Win_Check:addColorAnimation(0, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(5)
  aniInfo8:SetEndIntensity(1)
  local aniInfo1 = Panel_Win_Check:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.1)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_Win_Check:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Win_Check:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Win_Check:addScaleAnimation(0.08, 0.14, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Win_Check:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Win_Check:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
  _AudioPostEvent_SystemUiForXBOX(8, 14)
end
function MessageBoxCheck_HideAni()
  Panel_Win_Check:SetShow(false, false)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
end
function messageBoxCheck_ApplyButtonUp()
  local functionApply
  if list ~= nil and list.data.functionApply ~= nil then
    elapsedTime = 0
    functionApply = list.data.functionApply
  end
  if list ~= nil and list.data.clientMessage ~= nil then
    sendGameMessageParam0(list.data.clientMessage)
  end
  postProcessMessageCheckData()
  if functionApply ~= nil then
    functionApply(MessageBoxCheck.getSelectedButtonIndex())
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
end
function messageBoxCheck_CancelButtonUp()
  local functionCancel
  if list ~= nil and list.data.functionCancel ~= nil then
    elapsedTime = 0
    functionCancel = list.data.functionCancel
  end
  postProcessMessageCheckData()
  if functionCancel ~= nil then
    functionCancel(MessageBoxCheck.getSelectedButtonIndex())
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
end
function messageBoxCheck_CloseButtonUp()
  local functionCancel
  if list ~= nil and list.data.functionCancel ~= nil then
    functionCancel = list.data.functionCancel
  elseif true == isCancelClose then
    MessageBoxCheck_Empty_function()
  end
  postProcessMessageCheckData()
  if functionCancel ~= nil then
    functionCancel(MessageBoxCheck.getSelectedButtonIndex())
  end
  _AudioPostEvent_SystemUiForXBOX(50, 3)
end
function Event_MessageBoxCheck_NotifyMessage_CashAlert(message)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW,
    exitButton = false
  }
  MessageBoxCheck.showMessageBox(messageboxData, "top")
end
function Event_MessageBoxCheck_NotifyMessage(message)
  local titleText = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxData = {
    title = titleText,
    content = message,
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW,
    exitButton = false
  }
  MessageBoxCheck.showMessageBox(messageboxData)
end
function Event_MessageBox_NotifyMessage_FreeButton(message)
  local messageboxData = {
    title = "",
    content = message,
    priority = UI_PP.PAUIMB_PRIORITY_1,
    exitButton = false
  }
  MessageBoxCheck.showMessageBox(messageboxData)
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
  MessageBoxCheck.showMessageBox(messageboxData)
end
function MessageBoxCheck_Empty_function()
end
function messageBoxCheck_UpdatePerFrame(deltaTime)
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
  if nil == _currentMessageBoxCheckData then
    return
  end
  setCurrentMessageCheckData(_currentMessageBoxCheckData)
end
button_Ok:addInputEvent("Mouse_LUp", "messageBoxCheck_ApplyButtonUp()")
button_No:addInputEvent("Mouse_LUp", "messageBoxCheck_CancelButtonUp()")
button_OK_ConsoleUI:addInputEvent("Mouse_LUp", "messageBoxCheck_ApplyButtonUp()")
button_NO_ConsoleUI:addInputEvent("Mouse_LUp", "messageBoxCheck_CancelButtonUp()")
registerEvent("EventNotifyMessageCashAlert", "Event_MessageBoxCheck_NotifyMessage_CashAlert")
if true == _ContentsGroup_RenewUI_MessageBox then
  Panel_Win_Check:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_MessageCheck_Check_Up()")
  Panel_Win_Check:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_MessageCheck_Check_Down()")
end
function PaGlobalFunc_MessageCheck_Check_Up()
  radioButton_Me:SetCheck(true)
  radioButton_All:SetCheck(false)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_MessageCheck_Check_Down()
  radioButton_Me:SetCheck(false)
  radioButton_All:SetCheck(true)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
Panel_Win_Check:RegisterUpdateFunc("messageBoxCheck_UpdatePerFrame")
