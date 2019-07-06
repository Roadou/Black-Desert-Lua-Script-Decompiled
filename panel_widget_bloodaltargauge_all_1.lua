function PaGlobal_BloodAltarGauge_All:initialize()
  if true == PaGlobal_BloodAltarGauge_All._initialize then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG = UI.getChildControl(Panel_Widget_BloodAltarGauge_All, "Static_GaugeBg")
  PaGlobal_BloodAltarGauge_All._ui.circleProgress_BloodAltar = UI.getChildControl(PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG, "CircularProgress_BloodAltar")
  PaGlobal_BloodAltarGauge_All._ui.txt_Title = UI.getChildControl(PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG, "StaticText_Title")
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent = UI.getChildControl(PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG, "StaticText_Percent")
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit = UI.getChildControl(Panel_Widget_BloodAltarGauge_All, "Button_Exit")
  PaGlobal_BloodAltarGauge_All._currentGaugeRate = 0
  PaGlobal_BloodAltarGauge_All:SetGaugeInfo(100)
  Panel_Widget_BloodAltarGauge_All:SetShow(true)
  PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG:SetShow(true)
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetShow(false)
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:SetShow(false)
  PaGlobal_BloodAltarGauge_All._exitPosX = 90
  PaGlobal_BloodAltarGauge_All._exitFixPosY = PaGlobal_BloodAltarGauge_All._ui.btn_Exit:GetSpanSize().y
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:SetSpanSize(PaGlobal_BloodAltarGauge_All._exitPosX * -1, PaGlobal_BloodAltarGauge_All._exitFixPosY)
  local stageTitle = ToClient_getSetSubScriptInstanceFieldName()
  if nil ~= stageTitle then
    PaGlobal_BloodAltarGauge_All._currentStageTitle = stageTitle
    PaGlobal_BloodAltarGauge_All:prepareOpen()
  end
  PaGlobal_BloodAltarGauge_All:registEventHandler()
  PaGlobal_BloodAltarGauge_All:validate()
  PaGlobal_BloodAltarGauge_All._initialize = true
end
function PaGlobal_BloodAltarGauge_All:registEventHandler()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:addInputEvent("Mouse_LUp", "HandleEventLUp_BloodAltarGauge_Exit()")
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:addInputEvent("Mouse_On", "HandleEventMouseOver_BloodAltarGauge_Exit(true)")
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:addInputEvent("Mouse_Out", "HandleEventMouseOver_BloodAltarGauge_Exit(false)")
  registerEvent("FromClient_UpdateTowerHpForInstanceSavageDefence", "FromClient_BloodAltarGauge_UpdateTowerHpForInstanceSavageDefence")
  registerEvent("FromClient_NotiSetScriptInstanceFieldAck", "FromClient_BloodAltarGauge_NotiSetScriptInstanceFieldAck")
  registerEvent("onScreenResize", "FromClient_BloodAltar_OnScreenResize")
  Panel_Widget_BloodAltarGauge_All:RegisterUpdateFunc("UpdateFunc_BloodAltarGauge_ExitAnimation")
end
function PaGlobal_BloodAltarGauge_All:prepareOpen()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetText(PaGlobal_BloodAltarGauge_All._currentStageTitle)
  PaGlobal_BloodAltarGauge_All:open()
end
function PaGlobal_BloodAltarGauge_All:open()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetShow(true)
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:SetShow(true)
end
function PaGlobal_BloodAltarGauge_All:prepareClose()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All:close()
end
function PaGlobal_BloodAltarGauge_All:close()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:SetShow(false)
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:SetShow(false)
end
function PaGlobal_BloodAltarGauge_All:validate()
  if nil == Panel_Widget_BloodAltarGauge_All then
    return
  end
  PaGlobal_BloodAltarGauge_All._ui.stc_GaugeBG:isValidate()
  PaGlobal_BloodAltarGauge_All._ui.circleProgress_BloodAltar:isValidate()
  PaGlobal_BloodAltarGauge_All._ui.txt_Title:isValidate()
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:isValidate()
  PaGlobal_BloodAltarGauge_All._ui.btn_Exit:isValidate()
end
function PaGlobal_BloodAltarGauge_All:SetGaugeInfo(rate)
  PaGlobal_BloodAltarGauge_All._currentGaugeRate = math.min(100, math.max(0, rate))
  PaGlobal_BloodAltarGauge_All._ui.circleProgress_BloodAltar:SetProgressRate(PaGlobal_BloodAltarGauge_All._currentGaugeRate)
  PaGlobal_BloodAltarGauge_All._ui.txt_Percent:SetText(math.floor(PaGlobal_BloodAltarGauge_All._currentGaugeRate + 0.5) .. "%")
end
