function PaGlobal_BloodAltar_CreateStageList(content, key)
  if nil == Panel_Window_BloodAltar_All then
    return
  end
  PaGlobal_BloodAltar_All:createStageList(content, key)
end
function HandleEventLUp_BloodAltar_SelectStage(index)
  if nil == Panel_Window_BloodAltar_All then
    return
  end
  PaGlobal_BloodAltar_All._selectStageIndex = index
  PaGlobal_BloodAltar_All:startButtonUpdate()
end
function HandleEventLUp_BloodAltar_StartStage()
  if nil == Panel_Window_BloodAltar_All then
    return
  end
  if -1 < PaGlobal_BloodAltar_All._selectStageIndex then
    ToClient_SetSubScriptForInstanceField(PaGlobal_BloodAltar_All._selectStageIndex)
  end
end
function FromClient_BloodAltar_EndInstanceSavageDefenceWave(isMaxProcess)
  if nil == Panel_Window_BloodAltar_All then
    return
  end
  local StringMsg = {
    PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_SUCCESS_GAME"),
    PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_FAIL_END"),
    PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_MOVE_CHANNEL")
  }
  PaGlobal_BloodAltarGauge_All:prepareClose()
  if false == isMaxProcess then
    local Msg = {
      main = StringMsg[2],
      sub = StringMsg[3],
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(Msg, 5, 73, false)
  else
    local Msg = {
      main = StringMsg[1],
      sub = StringMsg[3],
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(Msg, 5, 72, false)
  end
end
function FromClient_BloodAltar_CheckSetSubScriptInstanceFieldAck(type)
  if nil == Panel_Window_BloodAltar_All or nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  if __eInstanceSetSubScriptType_CantSet == type then
  elseif __eInstanceSetSubScriptType_Setable == type then
    PaGlobal_BloodAltarGauge_All:prepareClose()
    PaGlobal_BloodAltar_All:prepareOpen()
  elseif __eInstanceSetSubScriptType_Setable_UsePearl == type then
    PaGlobal_BloodAltar_All._isRetry = true
    PaGlobalFunc_BloodAltar_RetryMessageBox()
  else
    _PA_LOG("\235\172\184\236\158\165\237\153\152", "\236\158\152\235\170\187\235\144\156 \236\160\145\234\183\188")
  end
end
function FromClient_BloodAltar_SetSubScriptForInstanceFieldResult(isSuccess, rv)
  if nil == Panel_Window_BloodAltar_All then
    return
  end
  if true == isSuccess then
    PaGlobal_BloodAltar_All._currentStageIndex = PaGlobal_BloodAltar_All._selectStageIndex
    PaGlobal_BloodAltar_All:prepareClose()
    if true == PaGlobal_BloodAltar_All._isRetry then
      messageBox_CloseButtonUp()
      PaGlobal_BloodAltarGauge_All:prepareOpen()
    end
    PaGlobal_BloodAltar_All._isRetry = false
  elseif true == PaGlobal_BloodAltar_All._isRetry then
    PaGlobalFunc_BloodAltar_RetryMessageBox()
  end
end
function PaGlobalFunc_BloodAltar_RetryMessageBox()
  local Retry = function()
    if true == ToClient_HasInstanceSavageDefenceReGameItem() then
      ToClient_SetSubScriptReGameForInstanceField(true)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoItemNotExist"))
      PaGlobalFunc_BloodAltar_RetryMessageBox()
    end
  end
  local Cancel = function()
    ToClient_SetSubScriptReGameForInstanceField(false)
  end
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_RETRYMEGBOX_TITLE")
  local msgDesc = PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_RETRYMEGBOX_DESC")
  local messageboxData = {
    title = msgTitle,
    content = msgDesc,
    functionYes = Retry,
    functionCancel = Cancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
