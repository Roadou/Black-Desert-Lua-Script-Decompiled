local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
PaGlobal_FairyRegister = {
  _ui = {
    fairyRegister = UI.getChildControl(Panel_Window_FairyRegister, "Button_Yes"),
    fairyRegisterCancel = UI.getChildControl(Panel_Window_FairyRegister, "Button_No"),
    fairyQuestion = UI.getChildControl(Panel_Window_FairyRegister, "Button_Question"),
    petNaming = UI.getChildControl(Panel_Window_FairyRegister, "Edit_WriteName"),
    fairyNamingBG = UI.getChildControl(Panel_Window_FairyRegister, "Static_NamingPolicyBG"),
    fairyNamingPolicyTitle = UI.getChildControl(Panel_Window_FairyRegister, "StaticText_NamingPolicyTitle"),
    fairyNamingPolicyDesc = UI.getChildControl(Panel_Window_FairyRegister, "StaticText_NamingPolicy"),
    fairyRegisterBG = UI.getChildControl(Panel_Window_FairyRegister, "Static_FairyRegisterBG"),
    fairyRegisterDesc = UI.getChildControl(Panel_Window_FairyRegister, "StaticText_Description")
  },
  tempFromWhereType = nil,
  tempFromSlotNo = nil
}
function PaGlobal_FairyRegister:init()
  self._ui.fairyIconBG = UI.getChildControl(self._ui.fairyRegisterBG, "Static_IconBack")
  self._ui.fairyIcon = UI.getChildControl(self._ui.fairyIconBG, "Static_Icon")
  self._ui.petNaming:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  self._ui.fairyNamingPolicyDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  if isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    self._ui.fairyNamingPolicyDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._ui.fairyNamingPolicyDesc:SetShow(true)
    self._ui.fairyNamingBG:SetShow(true)
    self._ui.fairyNamingPolicyTitle:SetShow(true)
  else
    self._ui.fairyNamingPolicyDesc:SetShow(false)
    self._ui.fairyNamingBG:SetShow(false)
    self._ui.fairyNamingPolicyTitle:SetShow(false)
  end
  if isGameTypeEnglish() or isGameTypeTaiwan() then
    self._ui.fairyNamingPolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  elseif isGameTypeTR() then
    self._ui.fairyNamingPolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TR"))
  elseif isGameTypeTH() then
    self._ui.fairyNamingPolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TH"))
  elseif isGameTypeID() then
    self._ui.fairyNamingPolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_ID"))
  end
  self._ui.fairyRegisterDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui.fairyRegisterDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRYREGISTER_DESC"))
  self._ui.fairyQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle(\"Fairy\")")
  self._ui.fairyQuestion:SetShow(false)
end
function PaGlobal_FairyRegister:Close()
  if not Panel_Window_FairyRegister:GetShow() then
    return
  end
  ClearFocusEdit(self._ui.petNaming)
  Panel_Window_FairyRegister:SetShow(false)
end
function FromClient_InputFairyName(fromWhereType, fromSlotNo)
  local self = PaGlobal_FairyRegister
  self.tempFromWhereType = fromWhereType
  self.tempFromSlotNo = fromSlotNo
  local petName = self._ui.petNaming:GetEditText()
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  if nil == itemWrapper then
    return
  end
  local characterKey = itemWrapper:getStaticStatus():get()._contentsEventParam1
  local petRegisterPSS = ToClient_getPetStaticStatus(characterKey)
  local petIconPath = petRegisterPSS:getIconPath()
  self._ui.fairyIcon:ChangeTextureInfoName(petIconPath)
  self._ui.petNaming:SetEditText("", true)
  self._ui.petNaming:SetMaxInput(getGameServiceTypePetNameLength())
  self._ui.fairyRegister:ComputePos()
  self._ui.fairyRegisterCancel:ComputePos()
  PaGlobal_FairyRegister:MClick_ClearEdit()
  Panel_Window_FairyRegister:SetShow(true)
end
function PaGlobal_FairyRegister:MClick_Register()
  local fromWhereType = self.tempFromWhereType
  local fromSlotNo = self.tempFromSlotNo
  local petName = self._ui.petNaming:GetEditText()
  ToClient_requestPetRegister(petName, fromWhereType, fromSlotNo)
  PaGlobal_FairyRegister:Close()
end
function PaGlobal_FairyRegister:MClick_ClearEdit()
  self._ui.petNaming:SetEditText("", false)
  SetFocusEdit(self._ui.petNaming)
end
function PaGlobal_FairyRegister:RegistEventHandler()
  self._ui.fairyRegister:addInputEvent("Mouse_LUp", "PaGlobal_FairyRegister:MClick_Register()")
  self._ui.fairyRegisterCancel:addInputEvent("Mouse_LUp", "PaGlobal_FairyRegister:Close()")
  self._ui.petNaming:addInputEvent("Mouse_LUp", "PaGlobal_FairyRegister:MClick_ClearEdit()")
  self._ui.petNaming:RegistReturnKeyEvent("PaGlobal_FairyRegister:MClick_Register()")
end
function PaGlobal_FairyRegister:RegistMessageHandler()
  registerEvent("FromClient_PetAddSealedList", "FromClient_PetAddSealedList")
end
PaGlobal_FairyRegister:init()
PaGlobal_FairyRegister:RegistEventHandler()
PaGlobal_FairyRegister:RegistMessageHandler()
