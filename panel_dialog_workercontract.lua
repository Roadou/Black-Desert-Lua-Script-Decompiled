Panel_Dialog_WorkerContract:SetShow(false)
Panel_Dialog_WorkerContract:ignorePadSnapMoveToOtherPanel()
local workerContract = {
  _ui = {
    _static_Worker_BG = UI.getChildControl(Panel_Dialog_WorkerContract, "Static_Contract_BG")
  },
  _config = {_needWP = 5}
}
function workerContract:initialize()
  self:initControl()
end
function workerContract:initControl()
  local ContractUI = self._ui
  ContractUI._staticText_Title = UI.getChildControl(ContractUI._static_Worker_BG, "StaticText_Title")
  ContractUI._static_CenterBg = UI.getChildControl(ContractUI._static_Worker_BG, "Static_CenterBg")
  ContractUI._staticText_NeedWP_Value = UI.getChildControl(ContractUI._static_CenterBg, "StaticText_NeedWP_Value")
  ContractUI._staticText_NeedWP_Value:SetText(self._config._needWP)
  ContractUI._staticText_CurrentWP_Value = UI.getChildControl(ContractUI._static_CenterBg, "StaticText_CurrentWP_Value")
  ContractUI._staticText_Desc = UI.getChildControl(ContractUI._static_CenterBg, "StaticText_Desc")
  ContractUI._static_BottomBg = UI.getChildControl(ContractUI._static_Worker_BG, "Static_BottomBg")
  ContractUI._button_Hire = UI.getChildControl(ContractUI._static_BottomBg, "Button_Hire")
  ContractUI._button_Cancel = UI.getChildControl(ContractUI._static_BottomBg, "Button_Cancel")
  ContractUI._staticText_Hire = UI.getChildControl(ContractUI._static_BottomBg, "StaticText_Hire")
  ContractUI._staticText_Cancel = UI.getChildControl(ContractUI._static_BottomBg, "StaticText_Cancel")
  Panel_Dialog_WorkerContract:registerPadEvent(__eConsoleUIPadEvent_Up_A, "FGlobalFunc_Hire_WorkerContract()")
  ContractUI._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  ContractUI._staticText_Desc:SetText(ContractUI._staticText_Desc:GetText())
  local tempBtnGroup = {
    ContractUI._staticText_Hire,
    ContractUI._staticText_Cancel
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, ContractUI._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
  if false == ToClient_isConsole() then
    ContractUI._button_Cancel:SetShow(true)
    ContractUI._button_Hire:SetShow(true)
    ContractUI._staticText_Cancel:SetShow(false)
    ContractUI._staticText_Hire:SetShow(false)
  else
    ContractUI._staticText_Cancel:SetShow(true)
    ContractUI._staticText_Hire:SetShow(true)
    ContractUI._button_Cancel:SetShow(false)
    ContractUI._button_Hire:SetShow(false)
  end
end
function workerContract:open()
  if nil ~= Panel_Dialog_WorkerTrade_Renew and true == Panel_Dialog_WorkerTrade_Renew:GetShow() then
    return
  end
  if nil ~= Panel_Dialog_RandomWorker and true == Panel_Dialog_RandomWorker:GetShow() then
    return
  end
  if nil ~= Panel_Dialog_WorkerContract then
    Panel_Dialog_WorkerContract:SetShow(true)
  end
end
function workerContract:close()
  if false == Panel_Dialog_WorkerContract:GetShow() then
    return
  end
  Panel_Dialog_WorkerContract:SetShow(false)
end
function workerContract:update(currentWP)
  local ContractUI = workerContract._ui
  if nil == currentWP then
    currentWP = getSelfPlayer():getWp()
  end
  ContractUI._staticText_CurrentWP_Value:SetText(currentWP)
end
function workerContract:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorkerContract")
end
function workerContract:hire()
  local currentWP = getSelfPlayer():getWp()
  if currentWP >= self._config._needWP then
    PaGlobalFunc_MainDialog_Bottom_RandomWorkerSelectUseMyWpConfirm()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERRANDOMSELECT_SHORTAGE_WP_ACK"))
    PaGlobalFunc_MainDialog_ReOpen()
  end
  self:close()
end
function workerContract:cancel()
  if false == Panel_Dialog_WorkerContract:GetShow() then
    return
  end
  ToClient_padSnapResetControl()
  PaGlobalFunc_MainDialog_ReOpen()
  self:close()
end
function FromClient_luaLoadComplete_WorkerContract()
  workerContract:initialize()
end
function FGlobalFunc_Hire_WorkerContract()
  workerContract:hire()
end
function FGlobalFunc_Cancel_WorkerContract()
  workerContract:cancel()
end
function FGlobalFunc_Open_WorkerContract(MyWp)
  workerContract:open()
  workerContract:update(MyWp)
end
workerContract:registEventHandler()
