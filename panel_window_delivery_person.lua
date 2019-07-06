local deliveryForPerson = {
  _buttonClose = UI.getChildControl(Panel_Window_DeliveryForPerson, "Button_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Window_DeliveryForPerson, "Button_Question"),
  _buttonGetOn = UI.getChildControl(Panel_Window_DeliveryForPerson, "Button_GetOn"),
  _comboBoxDest = UI.getChildControl(Panel_Window_DeliveryForPerson, "Combobox_Destination"),
  _comboBoxCarriage = UI.getChildControl(Panel_Window_DeliveryForPerson, "Combobox_Carriage"),
  _comboBoxSwapCharacter = UI.getChildControl(Panel_Window_DeliveryForPerson, "Combobox_Character"),
  _staticText_NoticeMsg = UI.getChildControl(Panel_Window_DeliveryForPerson, "StaticText_NoticeText"),
  _staticText_NoticeAlert = UI.getChildControl(Panel_Window_DeliveryForPerson, "StaticText_Alert"),
  _selectDestinationWaypointKey = -1,
  _selectDestCarriageKey = -1,
  _selectCharacterIndex = -1,
  _carriageList = {},
  _selectCharacterIndexPos = -1
}
local changeDelayTime = -1
function delivery_Person_UpdatePerFrame(deltaTime)
  if changeDelayTime > 0 then
    changeDelayTime = changeDelayTime - deltaTime
    local remainTime = math.floor(changeDelayTime)
    if prevTime ~= remainTime then
      if remainTime < 0 then
        remainTime = 0
      end
      prevTime = remainTime
      deliveryForPerson._staticText_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(remainTime)))
      if 0 >= prevTime then
        changeDelayTime = -1
        deliveryForPerson._staticText_NoticeMsg:SetText(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_GoChange"))
      end
    end
  end
end
function setPlayerDeliveryDelayTime(delayTime)
  if false == Panel_Window_DeliveryForPerson:GetShow() then
    return
  end
  deliveryForPerson._buttonGetOn:SetShow(false)
  deliveryForPerson._staticText_NoticeMsg:SetShow(true)
  deliveryForPerson._staticText_NoticeMsg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_deliveryPerson_ChangeMsg", "changeTime", tostring(delayTime)))
  changeDelayTime = delayTime
end
function deliveryForPerson.fillData()
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return false
  end
  if true == selfProxy:get():isTradingPvpable() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_TradingPvPAble"))
    return false
  end
  if toInt64(0, 0) < selfProxy:get():getInventory():getTradeItemCount() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_HaveTradeItem"))
    return false
  end
  local characterNo_64 = toInt64(0, 0)
  characterNo_64 = selfProxy:getCharacterNo_64()
  deliveryForPerson._comboBoxDest:DeleteAllItem()
  local waypointKeyList = delivery_listWaypointKey(getCurrentWaypointKey(), true)
  if nil == waypointKeyList then
    return false
  end
  local size = waypointKeyList:size()
  for count = 1, size do
    deliveryForPerson._comboBoxDest:AddItem(waypointKeyList:atPointer(count - 1):getName())
  end
  deliveryForPerson._comboBoxCarriage:DeleteAllItem()
  deliveryForPerson._comboBoxSwapCharacter:DeleteAllItem()
  local count = getCharacterDataCount()
  for idx = 0, count - 1 do
    local characterData = getCharacterDataByIndex(idx)
    if nil == characterData then
      break
    end
    if characterNo_64 ~= characterData._characterNo_s64 then
      local strLevel = string.format("%d", characterData._level)
      local characterNameLv = PAGetStringParam2(Defines.StringSheet_GAME, "CHARACTER_SELECT_LV", "character_level", strLevel, "character_name", getCharacterName(characterData))
      deliveryForPerson._comboBoxSwapCharacter:AddItem(characterNameLv)
    else
      deliveryForPerson._selectCharacterIndexPos = idx
    end
  end
  return true
end
function deliveryForPerson.resetData()
  deliveryForPerson._selectDestinationWaypointKey = -1
  deliveryForPerson._selectDestCarriageKey = -1
  deliveryForPerson._selectCharacterIndex = -1
  deliveryForPerson._comboBoxDest:DeleteAllItem()
  deliveryForPerson._comboBoxDest:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_DESTINATION"))
  deliveryForPerson._comboBoxCarriage:DeleteAllItem()
  deliveryForPerson._comboBoxCarriage:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_CARRIAGE"))
  deliveryForPerson._comboBoxSwapCharacter:DeleteAllItem()
  deliveryForPerson._comboBoxSwapCharacter:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_SELECT_CHANRACTER"))
end
function panel_DeliveryForPorson_Show(show)
  if true == show then
    local rv = deliveryForPerson.fillData()
    if false == rv then
      return
    end
  else
    deliveryForPerson.resetData()
    deliveryForPerson._staticText_NoticeMsg:SetShow(false)
  end
  Panel_Window_DeliveryForPerson:SetShow(show)
end
function click_DeliveryForPerson_Close()
  if -1 ~= changeDelayTime then
    sendGameDelayExitCancel()
  end
  changeDelayTime = -1
  panel_DeliveryForPorson_Show(false)
  deliveryForPerson._buttonGetOn:SetShow(true)
end
function click_DeliveryForPerson_GetOn()
  local talkerNpc = dialog_getTalker()
  if nil == talkerNpc then
    UI.debugMessage("nil talks")
  end
  if -1 == deliveryForPerson._selectDestinationWaypointKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_NotDestination"))
    return
  end
  if -1 == deliveryForPerson._selectDestCarriageKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectMove"))
    return
  end
  if -1 == deliveryForPerson._selectCharacterIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_SelectCharacter"))
    return
  end
  local characterData = getCharacterDataByIndex(deliveryForPerson._selectCharacterIndex)
  local classType = getCharacterClassType(characterData)
  if ToClient_IsCustomizeOnlyClass(classType) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DELIVERY_PERSON_NOTCHANGE"))
    return
  end
  if nil == characterData then
    return
  end
  if characterData._level < 5 then
    NotifyDisplay(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GAMEEXIT_DONT_CHAGECHARACTER", "iLevel", 4))
    return
  end
  local removeTime = getCharacterDataRemoveTime(deliveryForPerson._selectCharacterIndex)
  if nil ~= removeTime then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "GAMEEXIT_TEXT_CHARACTER_DELETE"))
    return
  end
  if true == ToClient_CheckDuelCharacterInPrison(deliveryForPerson._selectCharacterIndex) then
    NotifyDisplay(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERTAG_PRISON_CANT_LOGIN"))
    return
  end
  local messageContent = PAGetStringParam2(Defines.StringSheet_RESOURCE, "DELIVERY_PERSON_READY_CHK", "now_character", getSelfPlayer():getName(), "change_character", getCharacterName(getCharacterDataByIndex(deliveryForPerson._selectCharacterIndex)))
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "Lua_deliveryPerson_Information"),
    content = messageContent,
    functionYes = DeliveryForPerson_YouSure,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function DeliveryForPerson_YouSure()
  deliveryPerson_SendReserve(deliveryForPerson._selectDestinationWaypointKey, deliveryForPerson._selectDestCarriageKey, dialog_getTalker():getActorKey())
end
function click_DeliveryForPerson_Dest()
  deliveryForPerson._comboBoxDest:ToggleListbox()
  local destList = deliveryForPerson._comboBoxDest:GetListControl()
  destList:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_DestList()")
end
function click_DeliveryForPerson_DestList()
  local DestSelectIndex = deliveryForPerson._comboBoxDest:GetSelectIndex()
  if -1 == DestSelectIndex then
    return
  end
  local currentWaypointKey = getCurrentWaypointKey()
  local waypointKeyList = delivery_listWaypointKey(currentWaypointKey, true)
  local destWaypointKey = waypointKeyList:atPointer(DestSelectIndex):getWaypointKey()
  deliveryForPerson._selectDestinationWaypointKey = destWaypointKey
  deliveryForPerson._comboBoxDest:SetSelectItemIndex(DestSelectIndex)
  deliveryForPerson._comboBoxDest:ToggleListbox()
  local carriageList = delivery_listCarriage(currentWaypointKey, deliveryForPerson._selectDestinationWaypointKey, true)
  if nil == carriageList then
    return
  end
  local size = carriageList:size()
  deliveryForPerson._comboBoxCarriage:DeleteAllItem()
  deliveryForPerson._carriageList = nil
  for ii = 0, size - 1 do
    local carriageData = carriageList:atPointer(ii)
    deliveryForPerson._comboBoxCarriage:AddItem(carriageData:getName())
    deliveryForPerson._carriageList[ii] = carriageData:getCharacterKeyRaw()
  end
end
function on_DeliveryForPerson_DestList()
  local onSelectIndex = deliveryForPerson._comboBoxDest:GetSelectIndex()
  if -1 == onSelectIndex then
    return
  end
end
function click_DeliveryForPerson_Carriage()
  deliveryForPerson._comboBoxCarriage:ToggleListbox()
  local characterList = deliveryForPerson._comboBoxCarriage:GetListControl()
  characterList:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_CarriageList()")
end
function click_DeliveryForPerson_CarriageList()
  local carriageSelectIndex = deliveryForPerson._comboBoxCarriage:GetSelectIndex()
  deliveryForPerson._comboBoxCarriage:SetSelectItemIndex(carriageSelectIndex)
  deliveryForPerson._comboBoxCarriage:ToggleListbox()
  deliveryForPerson._selectDestCarriageKey = deliveryForPerson._carriageList[carriageSelectIndex]
end
function click_DeliveryForPerson_SwapCharacter()
  deliveryForPerson._comboBoxSwapCharacter:ToggleListbox()
  local swapCharacterList = deliveryForPerson._comboBoxSwapCharacter:GetListControl()
  swapCharacterList:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_SwapCharacterList()")
end
function click_DeliveryForPerson_SwapCharacterList()
  local characterSelectIndex = deliveryForPerson._comboBoxSwapCharacter:GetSelectIndex()
  deliveryForPerson._comboBoxSwapCharacter:SetSelectItemIndex(characterSelectIndex)
  deliveryForPerson._comboBoxSwapCharacter:ToggleListbox()
  if characterSelectIndex >= deliveryForPerson._selectCharacterIndexPos then
    characterSelectIndex = characterSelectIndex + 1
  end
  deliveryForPerson._selectCharacterIndex = characterSelectIndex
end
function deliveryForPersonChangeCharacter()
  if -1 == deliveryForPerson._selectCharacterIndex then
    return
  end
  local rv = swapCharacter_Select(deliveryForPerson._selectCharacterIndex, true)
  if false == rv then
    return
  end
end
local function initialize()
  deliveryForPerson._buttonClose:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_Close()")
  deliveryForPerson._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"DeliveryPerson\" )")
  deliveryForPerson._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"DeliveryPerson\", \"true\")")
  deliveryForPerson._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"DeliveryPerson\", \"false\")")
  deliveryForPerson._buttonGetOn:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_GetOn()")
  deliveryForPerson._comboBoxDest:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_Dest()")
  deliveryForPerson._comboBoxCarriage:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_Carriage()")
  deliveryForPerson._comboBoxSwapCharacter:addInputEvent("Mouse_LUp", "click_DeliveryForPerson_SwapCharacter()")
  registerEvent("EventDeliveryForPersonChangeCharacter", "deliveryForPersonChangeCharacter()")
  registerEvent("EventGameExitDelayTime", "setPlayerDeliveryDelayTime")
  Panel_Window_DeliveryForPerson:RegisterUpdateFunc("delivery_Person_UpdatePerFrame")
end
initialize()
