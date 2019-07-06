function HandleEventLUp_BloodAltarGauge_Exit()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  local MessageBox_Exit = function()
    ToClient_InstanceSavageDefenceUnJoin()
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_EXIT_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_BLOODALTAR_EXIT_DESC")
  local messageBoxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = MessageBox_Exit,
    functionNo = MessageBox_Empty_function,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleEventMouseOver_BloodAltarGauge_Exit(isOn)
  PaGlobal_BloodAltarGauge_All._isExitOn = isOn
end
function FromClient_BloodAltarGauge_UpdateTowerHpForInstanceSavageDefence(rate)
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:SetShow(true)
  PaGlobal_BloodAltarGauge_All:SetGaugeInfo(rate)
end
function FromClient_BloodAltarGauge_NotiSetScriptInstanceFieldAck(stageTitle)
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._currentStageTitle = stageTitle
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetShow(true)
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetText(PaGlobal_BloodAltarGauge_All._currentStageTitle)
end
function FromClient_BloodAltar_OnScreenResize()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  if nil ~= Panel_WorldMiniMap then
    Panel_WorldMiniMap:SetShow(false, false)
  end
  if nil ~= Panel_TimeBar then
    Panel_TimeBar:SetShow(false, false)
  end
  if nil ~= Panel_Radar then
    Panel_Radar:SetShow(false, false)
  end
  if nil ~= Panel_MainQuest then
    Panel_MainQuest:SetShow(false, false)
  end
  if nil ~= Panel_CheckedQuest then
    Panel_CheckedQuest:SetShow(false, false)
  end
end
function UpdateFunc_BloodAltarGauge_ExitAnimation(deltaTime)
  if nil == Panel_Widget_BloodAltarGauge_All or nil == PaGlobal_BloodAltarGauge_All._ui.btn_Exit then
    return
  end
  if 0 <= PaGlobal_BloodAltarGauge_All._exitPosX and PaGlobal_BloodAltarGauge_All._exitPosX <= 90 then
    if true == PaGlobal_BloodAltarGauge_All._isExitOn then
      PaGlobal_BloodAltarGauge_All._exitPosX = PaGlobal_BloodAltarGauge_All._exitPosX - 10
    elseif false == PaGlobal_BloodAltarGauge_All._isExitOn then
      PaGlobal_BloodAltarGauge_All._exitPosX = PaGlobal_BloodAltarGauge_All._exitPosX + 10
    end
  end
  if 0 > PaGlobal_BloodAltarGauge_All._exitPosX then
    PaGlobal_BloodAltarGauge_All._exitPosX = 0
  elseif PaGlobal_BloodAltarGauge_All._exitPosX > 90 then
    PaGlobal_BloodAltarGauge_All._exitPosX = 90
  end
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:SetSpanSize(PaGlobal_BloodAltarGauge_All._exitPosX * -1, PaGlobal_BloodAltarGauge_All._exitFixPosY)
end
