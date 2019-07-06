function HandleEventLUp_WorkerRandomSelectOption_All_Close()
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetShow(false)
  Panel_NumberPad_Close()
  PaGlobal_WorkerRandomSelectOption_All:prepareClose()
end
function HandleEventLUp_WorkerRandomSelectOption_All_Open()
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All:prepareOpen()
end
function FromClient_WorkerRandomSelectOption_OnScreenResize()
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  PaGlobal_WorkerRandomSelectOption_All:onScreenResize()
end
function HandleEventLUp_WorkerRandomSelectOption_All_ContinueSelectStart()
  if nil == Panel_Window_WorkerRandomSelect_All or true == PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:GetShow() or true == Panel_NumberPad_IsPopUp() then
    return
  end
  if nil ~= PaGlobal_WorkerRandomSelectOption_All._config and nil ~= PaGlobalFunc_WorkerRandomSelect_All_SetConfig then
    local config = PaGlobal_WorkerRandomSelectOption_All._config
    PaGlobalFunc_WorkerRandomSelect_All_SetConfig(config._workerGrade, config._repetitionCount)
    PaGlobal_WorkerRandomSelectOption_All:prepareClose()
  end
end
function HandleEventLUp_WorkerRandomSelectOption_All_SelectCountOpen()
  if nil == getSelfPlayer() or true == Panel_NumberPad_IsPopUp() then
    return
  end
  local selfPlayer = getSelfPlayer()
  local myWp = selfPlayer:getWp()
  local maxCountForSelection = toInt64(myWp) / toInt64(5)
  Panel_NumberPad_Show_MaxCount(true, maxCountForSelection, nil, HandleEventLUp_WorkerRandomSelectOption_All_SelectCountConfirm)
end
function HandleEventLUp_WorkerRandomSelectOption_All_SelectCountConfirm(inputNumber64)
  if nil == inputNumber64 or nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  local count32 = Int64toInt32(inputNumber64)
  PaGlobal_WorkerRandomSelectOption_All._config._repetitionCount = count32
  PaGlobal_WorkerRandomSelectOption_All:update()
end
function HandleEventLUp_WorkerRandomSelectOption_All_SelectGradeConfirm(idx)
  if nil == Panel_Window_WorkerRandomSelectOption_All then
    return
  end
  if nil == idx then
    PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetShow(false)
  end
  PaGlobal_WorkerRandomSelectOption_All._config._workerGrade = idx
  PaGlobal_WorkerRandomSelectOption_All:update()
  PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetShow(false)
end
function HandleEventLUp_WorkerRandomSelectOption_All_OptionOpen(idx)
  if nil == Panel_Window_WorkerRandomSelectOption_All or false == Panel_Window_WorkerRandomSelectOption_All:GetShow() then
    return
  end
  if 0 == idx then
    if true == PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:GetShow() then
      return
    end
    PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetShow(true)
    Panel_NumberPad_Close()
  else
    if true == Panel_NumberPad_IsPopUp() then
      return
    end
    HandleEventLUp_WorkerRandomSelectOption_All_SelectCountOpen()
    PaGlobal_WorkerRandomSelectOption_All._ui._stc_GradeSelectBg:SetShow(false)
  end
  PaGlobal_WorkerRandomSelectOption_All:update()
end
