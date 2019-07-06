Panel_SelectRealm:SetShow(false)
PaGlobal_SelectRealm = {_selectedRealm = 0}
function PaGlobal_SelectRealm:init()
  local Base = UI.getChildControl(Panel_SelectRealm, "Static_SelectRealmBG")
  local buttonCalpheon = UI.getChildControl(Base, "Button_Calpheon")
  local buttonMediah = UI.getChildControl(Base, "Button_Mediah")
  local buttonValencia = UI.getChildControl(Base, "Button_Valencia")
  local buttonCancel = UI.getChildControl(Base, "Button_Cancel")
  buttonCalpheon:addInputEvent("Mouse_LUp", "HandleClickedButtonRealm(1)")
  buttonMediah:addInputEvent("Mouse_LUp", "HandleClickedButtonRealm(2)")
  buttonValencia:addInputEvent("Mouse_LUp", "HandleClickedButtonRealm(3)")
  buttonCancel:addInputEvent("Mouse_LUp", "HandleClickedButtonCancel()")
end
function PaGlobal_SelectRealm:RequestSelectComplete()
  _PA_LOG("\236\161\176\236\158\172\236\155\144", tostring(self._selectedRealm) .. "\236\167\132\236\152\129\236\157\180 \236\132\160\237\131\157 \235\144\152\236\151\136\236\138\181\235\139\136\235\139\164.")
  Panel_SelectRealm:SetShow(false)
end
function PaGlobal_SelectRealm:ClickedButtonRealm(realm)
  self._selectedRealm = realm
  local messageBoxData = {
    title = "\236\167\132\236\152\129 \236\132\160\237\131\157",
    content = tostring(realm) .. "\235\178\136 \236\167\132\236\152\129\236\157\132 \236\132\160\237\131\157 \237\150\136\236\138\181\235\139\136\235\139\164. \n \237\153\149\236\160\149 \237\149\152\234\178\160\236\138\181\235\139\136\234\185\140?",
    functionYes = RequestSelectComplete,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleClickedButtonRealm(realm)
  local self = PaGlobal_SelectRealm
  self:ClickedButtonRealm(realm)
end
function HandleClickedButtonCancel()
  Panel_SelectRealm:SetShow(false)
end
function FromClient_selectRealm()
  Panel_SelectRealm:SetShow(true)
end
function RequestSelectComplete()
  local self = PaGlobal_SelectRealm
  self:RequestSelectComplete()
end
registerEvent("FromClient_selectRealm", "FromClient_selectRealm")
PaGlobal_SelectRealm:init()
