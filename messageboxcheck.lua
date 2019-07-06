local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Win_Check:RegisterShowEventFunc(true, "MessageBoxCheck_ShowAni()")
Panel_Win_Check:RegisterShowEventFunc(false, "MessageBoxCheck_HideAni()")
Panel_Win_Check:SetShow(false, false)
Panel_Win_Check:setMaskingChild(true)
Panel_Win_Check:setGlassBackground(true)
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local textTitle = UI.getChildControl(Panel_Win_Check, "Static_Text_Title")
local textBG = UI.getChildControl(Panel_Win_Check, "Static_Text")
local textContent = UI.getChildControl(Panel_Win_Check, "StaticText_Content")
local buttonApply = UI.getChildControl(Panel_Win_Check, "Button_Apply")
local buttonCancel = UI.getChildControl(Panel_Win_Check, "Button_Cancel")
local buttonClose = UI.getChildControl(Panel_Win_Check, "Button_Close")
local iconInven = UI.getChildControl(Panel_Win_Check, "RadioButton_Icon_Inven")
local iconWarehouse = UI.getChildControl(Panel_Win_Check, "RadioButton_Icon_Warehouse")
local checkInven = UI.getChildControl(Panel_Win_Check, "Static_Text_InvenMoney")
local checkWarehouse = UI.getChildControl(Panel_Win_Check, "Static_Text_WarehouseMoney")
local globalButtonShowCount = 0
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
local function messageBox_Resize()
  local textSizeY = textContent:GetTextSizeY()
  textContent:SetSize(textContent:GetSizeX(), textSizeY)
  textBG:SetSize(textBG:GetSizeX(), textSizeY + 95)
  Panel_Win_Check:SetSize(Panel_Win_Check:GetSizeX(), textBG:GetSizeY() + 97)
end
function setCurrentMessageCheckData(currentData, position)
  if currentData ~= nil then
    buttonApply:SetShow(false)
    buttonCancel:SetShow(false)
    buttonClose:SetShow(false)
    Panel_Win_Check:SetShow(true, false)
    Panel_Win_Check:SetScaleChild(1, 1)
    if currentData.title ~= nil then
      textTitle:SetText(currentData.title)
    end
    if currentData.content ~= nil then
      textContent:SetTextMode(UI_TM.eTextMode_AutoWrap)
      textContent:SetText(currentData.content)
      messageBox_Resize()
    end
    local buttonShowCount = 0
    if currentData.functionApply ~= nil then
      buttonApply:SetShow(true)
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
      buttonApply:SetPosX(Panel_Win_Check:GetSizeX() / 2 - buttonApply:GetSizeX() / 2)
      buttonCancel:SetPosX(Panel_Win_Check:GetSizeX() / 2 - buttonCancel:GetSizeX() / 2)
    elseif 2 == buttonShowCount then
      buttonApply:SetPosX(Panel_Win_Check:GetSizeX() / 2 - 95)
      buttonCancel:SetPosX(Panel_Win_Check:GetSizeX() / 2 + 4)
    elseif 3 == buttonShowCount then
      local buttonSize = buttonApply:GetSizeX()
      buttonApply:SetPosX(5)
      buttonCancel:SetPosX(buttonSize * 2 + 15)
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
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyFromNpcShop_s64() then
      iconInven:SetCheck(true)
      iconWarehouse:SetCheck(false)
    else
      iconInven:SetCheck(false)
      iconWarehouse:SetCheck(true)
    end
    checkWarehouse:SetShow(true)
    iconWarehouse:SetShow(true)
  else
    iconInven:SetCheck(true)
    iconWarehouse:SetCheck(false)
    checkWarehouse:SetShow(false)
    iconWarehouse:SetShow(false)
  end
  checkInven:SetText(makeDotMoney(myInvenMoney))
  checkWarehouse:SetText(makeDotMoney(warehouse_moneyFromNpcShop_s64()))
  iconInven:SetEnableArea(0, 0, iconInven:GetTextSizeX() + checkInven:GetTextSizeX() + 100, iconInven:GetSizeY() + 3)
  iconWarehouse:SetEnableArea(0, 0, iconWarehouse:GetTextSizeX() + checkWarehouse:GetTextSizeX() + 100, iconWarehouse:GetSizeY() + 3)
  local textSizeY = textContent:GetTextSizeY() + 100 + 20
  local textBGSizeY = textContent:GetSizeY()
  local panelSizeY = textBG:GetSizeY()
  local resizePanelY = textSizeY + 114
  textContent:ComputePos()
  messageBoxCheckComputePos()
end
function MessageBoxCheck.showMessageBoxForRegion(MessageCheckData, position, keyUse)
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
  if ToClient_HasWareHouseFromNpc() then
    if toInt64(0, 0) == warehouse_moneyByCurrentRegionMainTown_s64() then
      iconInven:SetCheck(true)
      iconWarehouse:SetCheck(false)
    else
      iconInven:SetCheck(false)
      iconWarehouse:SetCheck(true)
    end
    checkWarehouse:SetShow(true)
    iconWarehouse:SetShow(true)
  else
    iconInven:SetCheck(true)
    iconWarehouse:SetCheck(false)
    checkWarehouse:SetShow(false)
    iconWarehouse:SetShow(false)
  end
  checkInven:SetText(makeDotMoney(myInvenMoney))
  checkWarehouse:SetText(makeDotMoney(warehouse_moneyByCurrentRegionMainTown_s64()))
  iconInven:SetEnableArea(0, 0, iconInven:GetTextSizeX() + checkInven:GetTextSizeX() + 100, iconInven:GetSizeY() + 3)
  iconWarehouse:SetEnableArea(0, 0, iconWarehouse:GetTextSizeX() + checkWarehouse:GetTextSizeX() + 100, iconWarehouse:GetSizeY() + 3)
  local textSizeY = textContent:GetTextSizeY() + 100 + 20
  local textBGSizeY = textContent:GetSizeY()
  local panelSizeY = textBG:GetSizeY()
  local resizePanelY = textSizeY + 114
  textContent:ComputePos()
  messageBoxCheckComputePos()
end
function messageBoxCheckComputePos()
  Panel_Win_Check:ComputePos()
  textTitle:ComputePos()
  textContent:ComputePos()
  textBG:ComputePos()
  buttonApply:ComputePos()
  buttonCancel:ComputePos()
  buttonClose:ComputePos()
  iconInven:ComputePos()
  iconWarehouse:ComputePos()
  checkInven:ComputePos()
  checkWarehouse:ComputePos()
  if 1 == globalButtonShowCount then
    buttonApply:SetPosX(Panel_Win_Check:GetSizeX() / 2 - buttonApply:GetSizeX() / 2)
    buttonCancel:SetPosX(Panel_Win_Check:GetSizeX() / 2 - buttonCancel:GetSizeX() / 2)
  elseif 2 == globalButtonShowCount then
    buttonApply:SetPosX(Panel_Win_Check:GetSizeX() / 2 - 122)
    buttonCancel:SetPosX(Panel_Win_Check:GetSizeX() / 2 + 1)
  elseif 3 == globalButtonShowCount then
    local buttonSize = buttonApply:GetSizeX()
    buttonApply:SetPosX(5)
    buttonCancel:SetPosX(buttonSize * 2 + 15)
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
  if iconInven:IsCheck() then
    isMoneyWhereType = CppEnums.ItemWhereType.eInventory
  elseif iconWarehouse:IsCheck() then
    isMoneyWhereType = CppEnums.ItemWhereType.eWarehouse
  else
    isMoneyWhereType = CppEnums.ItemWhereType.eInventory
  end
  return isMoneyWhereType
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
    list.data.functionApply()
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
end
function MessageBoxCheck_HideAni()
  Panel_Win_Check:SetShow(false, false)
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
    functionApply()
  end
end
function messageBoxCheck_CancelButtonUp()
  local functionCancel
  if list ~= nil and list.data.functionCancel ~= nil then
    elapsedTime = 0
    functionCancel = list.data.functionCancel
  end
  postProcessMessageCheckData()
  if functionCancel ~= nil then
    functionCancel()
  end
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
    functionCancel()
  end
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
      textTitle:SetText(remainTime .. list.data.timeString)
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
buttonApply:addInputEvent("Mouse_LUp", "messageBoxCheck_ApplyButtonUp()")
buttonCancel:addInputEvent("Mouse_LUp", "messageBoxCheck_CancelButtonUp()")
buttonClose:addInputEvent("Mouse_LUp", "messageBoxCheck_CloseButtonUp()")
registerEvent("EventNotifyMessageCashAlert", "Event_MessageBoxCheck_NotifyMessage_CashAlert")
Panel_Win_Check:RegisterUpdateFunc("messageBoxCheck_UpdatePerFrame")
