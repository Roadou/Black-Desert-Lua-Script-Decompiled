Panel_DataProgress:SetShow(false)
PaGlobal_Dataprogress = {
  _ui = {
    _static_DataProgressBG = UI.getChildControl(Panel_DataProgress, "Static_Bg"),
    _btn_Close = nil,
    _static_ProgressBG = nil,
    _progress_Download = nil
  }
}
function PaGlobal_Dataprogress:Initialize()
  self._ui._btn_Close = UI.getChildControl(Panel_DataProgress, "Button_Close")
  self._ui._static_ProgressBG = UI.getChildControl(Panel_DataProgress, "Static_ProgressBg")
  self._ui._progress_Download = UI.getChildControl(Panel_DataProgress, "Progress2_Download")
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "PaGlobal_Dataprogress:Close()")
  if ToClient_isDataDownloadStart() then
    PaGlobal_Dataprogress:Open()
  else
    PaGlobal_Dataprogress:Close()
  end
end
function PaGlobal_Dataprogress:Update()
  if ToClient_isDataDownloadStart() then
    if ToClient_isDataDownloadComplete() then
      self._ui._btn_Close:SetShow(true)
    else
      self._ui._progress_Download:SetProgressRate(ToClient_getDataDownloadProgress())
    end
  end
end
function PaGlobal_Dataprogress:Close()
  self = PaGlobal_Dataprogress
  Panel_DataProgress:SetShow(false)
  self._ui._btn_Close:SetShow(false)
  self._ui._static_ProgressBG:SetShow(false)
  self._ui._progress_Download:SetShow(false)
end
function PaGlobal_Dataprogress:Open()
  self = PaGlobal_Dataprogress
  Panel_DataProgress:SetShow(true)
  self._ui._btn_Close:SetShow(false)
  self._ui._static_ProgressBG:SetShow(true)
  self._ui._progress_Download:SetShow(true)
end
function FromClient_getDataDownloadProgress()
  self._ui._progress_Download:SetProgressRate(ToClient_getDataDownloadProgress())
end
function FromClient_completeDownloadProgress()
  self._ui._btn_Close:SetShow(true)
end
registerEvent("FromClient_getDataDownloadProgress", "FromClient_getDataDownloadProgress")
registerEvent("FromClient_completeDownloadProgress", "FromClient_completeDownloadProgress")
