function PaGlobalFunc_DialogList_All_Open()
  PaGlobal_DialogList_All:prepareOpen()
end
function PaGlobalFunc_DialogList_All_Close()
  PaGlobal_DialogList_All:prepareClose()
end
function HandleEventLUp_DialogList_All_PagePrevClick()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All._curPage = PaGlobal_DialogList_All._curPage - 1
  if PaGlobal_DialogList_All._curPage == 0 then
    PaGlobal_DialogList_All._curPage = 1
  end
  PaGlobal_DialogList_All:updateDialogPage()
end
function HandleEventLUp_DialogList_All_PageNextClick()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All._curPage = PaGlobal_DialogList_All._curPage + 1
  if PaGlobal_DialogList_All._curPage == PaGlobal_DialogList_All._dialogMaxPage + 1 then
    PaGlobal_DialogList_All._curPage = PaGlobal_DialogList_All._dialogMaxPage
  end
  PaGlobal_DialogList_All:updateDialogPage()
end
function HandleEventLUp_DialogList_All_ButtonClick(index)
  if nil == Panel_Dialog_List_All then
    return
  end
  if Panel_Win_System:GetShow() then
    return
  end
  if nil == index then
    _PA_ASSERT_NAME(false, "HandleEventLUp_DialogList_All_ButtonClick\236\157\152 index\234\176\128 nil\236\158\133\235\139\136\235\139\164", "\236\160\149\236\167\128\237\152\156")
    return
  end
  PaGlobal_DialogList_All._selectIndex = index
  local _doConfirmYes = function()
    PaGlobalFunc_DialogQuest_All_ClearSelectRewardItemName()
    PaGlobal_DialogList_All:clickList(PaGlobal_DialogList_All._selectIndex)
  end
  local _selectRewardItemName = PaGlobalFunc_DialogQuest_All_GetSelectedRewardItemName()
  if false ~= _selectRewardItemName and true == PaGlobal_DialogList_All._isQuestComplete then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NOTIFICATIONS_SELECTREWARD", "_selectRewardItemName", _selectRewardItemName)
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = _doConfirmYes,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
    return
  else
    PaGlobal_DialogList_All:clickList(PaGlobal_DialogList_All._selectIndex)
  end
end
function HandleEventOnOut_DialogList_All_NeedItemTooltip(isShow, needItemKey, index)
  if false == isShow then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  if nil == Panel_Dialog_List_All then
    return
  end
  if nil == needItemKey or nil == index then
    return
  end
  local itemStaticWrapper = getItemEnchantStaticStatus(ItemEnchantKey(needItemKey))
  Panel_Tooltip_Item_Show(itemStaticWrapper, PaGlobal_DialogList_All._ui.stc_dialogList[index], true, false, nil)
end
function HandleEventLUp_DialogList_All_SelectTab(index)
  PaGlobalFunc_DialogList_All_SetFilterOption(index)
end
function PaGlobalFunc_DialogList_All_IsQuestComplete()
  return PaGlobal_DialogList_All._isQuestComplete
end
function PaGlobalFunc_DialogList_All_IsReContactDialog()
  if nil == Panel_Dialog_List_All then
    return false
  end
  return PaGlobal_DialogList_All._isReContactDialog
end
function PaGlobalFunc_DialogList_All_IsAbleQuest()
  if nil == Panel_Dialog_List_All then
    return false
  end
  return PaGlobal_DialogList_All._isAbleDisplayQuest
end
function PaGlobalFunc_DialogList_All_Update()
  if nil == Panel_Dialog_List_All then
    return
  end
  PaGlobal_DialogList_All:updateDialog()
end
function PaGlobalFunc_DialogList_All_SetFilterButtonCount()
  if nil == Panel_Dialog_List_All then
    return
  end
  for ii = 1, 3 do
    ToClient_SetFilterType(ii, true)
    local dialogData = ToClient_GetCurrentDialogData()
    if nil == dialogData then
      return
    end
    local dialogButtonCount = dialogData:getDialogButtonCount()
    PaGlobal_DialogList_All._ui.btn_splitRadiolist[ii]:SetText(PaGlobal_DialogList_All._btnSplitString[ii] .. "(" .. dialogButtonCount .. ")")
  end
end
function PaGlobalFunc_DialogList_All_SetFilterOption(index)
  if nil == Panel_Dialog_List_All then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  if nil == index then
    return
  end
  ToClient_SetFilterType(index, true)
  PaGlobal_DialogList_All._curPage = 1
  PaGlobal_DialogList_All:updateDialogList(dialogData)
  PaGlobal_DialogList_All:changeFilterRadio(true)
  for ii = 0, 3 do
    PaGlobal_DialogList_All._ui.btn_splitRadiolist[ii]:SetCheck(false)
  end
  PaGlobal_DialogList_All._ui.btn_splitRadiolist[index]:SetCheck(true)
  local selectBarPosX = PaGlobal_DialogList_All._ui.btn_splitRadiolist[index]:GetPosX() + PaGlobal_DialogList_All._ui.btn_splitRadiolist[index]:GetSizeX() / 2 - PaGlobal_DialogList_All._ui.stc_selectBar:GetSizeX() / 2
  PaGlobal_DialogList_All._ui.stc_selectBar:SetPosX(selectBarPosX)
end
function PaGlobalFunc_DialogList_All_SetProposeToNpc()
  PaGlobalFunc_DialogList_All_Open()
  PaGlobal_DialogList_All:updateDialog(true)
end
function PaGlobalFunc_DialogList_All_IsVisibleButton(buttonValue)
  local dialogData = ToClient_GetCurrentDialogData()
  if dialogData ~= nil then
    local dialogButtonCount = dialogData:getDialogButtonCount()
    for i = 0, dialogButtonCount - 1 do
      local dialogButton = dialogData:getDialogButtonAt(i)
      if dialogButton ~= nil and buttonValue == tostring(dialogButton._linkType) then
        return true
      end
    end
  end
  return false
end
