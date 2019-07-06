local IM = CppEnums.EProcessorInputMode
local UI_TM = CppEnums.TextMode
PaGlobal_CampRegister = {
  _ui = {
    _campNaming = UI.getChildControl(Panel_Window_CampRegister, "Edit_Naming"),
    _campRegister = UI.getChildControl(Panel_Window_CampRegister, "Button_Yes"),
    _campRegisterCancel = UI.getChildControl(Panel_Window_CampRegister, "Button_No"),
    _campIcon = UI.getChildControl(Panel_Window_CampRegister, "Static_Icon"),
    _staticCreateServantNameBG = UI.getChildControl(Panel_Window_CampRegister, "Static_NamingPolicyBG"),
    _staticCreateServantNameTitle = UI.getChildControl(Panel_Window_CampRegister, "StaticText_NamingPolicyTitle"),
    _staticCreateServantName = UI.getChildControl(Panel_Window_CampRegister, "StaticText_NamingPolicy"),
    _campRegisterBG = UI.getChildControl(Panel_Window_CampRegister, "Static_CampRegisterBG"),
    _campRegisterDesc = UI.getChildControl(Panel_Window_CampRegister, "StaticText_Description")
  },
  _tempFromWhereType = nil,
  _tempFromSlotNo = nil
}
function PaGlobal_CampRegister:CampRegister_init()
  self._ui._campNaming:SetEditText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_EDITBOX_COMMENT"), true)
  if isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    self._ui._staticCreateServantName:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._ui._staticCreateServantName:SetShow(true)
    self._ui._staticCreateServantNameBG:SetShow(true)
    self._ui._staticCreateServantNameTitle:SetShow(true)
  else
    self._ui._staticCreateServantName:SetShow(false)
    self._ui._staticCreateServantNameBG:SetShow(false)
    self._ui._staticCreateServantNameTitle:SetShow(false)
  end
  if isGameTypeEnglish() or isGameTypeTaiwan() then
    self._ui._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  elseif isGameTypeTR() then
    self._ui._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TR"))
  elseif isGameTypeTH() then
    self._ui._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TH"))
  elseif isGameTypeID() then
    self._ui._staticCreateServantName:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_ID"))
  end
  self._ui._campRegisterDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
end
function PaGlobal_CampRegister:CampRegister_Open()
  Panel_Window_CampRegister:SetShow(true)
end
function PaGlobal_CampRegister:CampRegister_Close()
  if not Panel_Window_CampRegister:GetShow() then
    return
  end
  ClearFocusEdit(self._ui._campNaming)
  Panel_Window_CampRegister:SetShow(false)
end
function FromClient_RegisterCampingTent(fromWhereType, fromSlotNo)
  local function messageBox_RegistCamp()
    self._tempFromWhereType = fromWhereType
    self._tempFromSlotNo = fromSlotNo
    PaGlobal_CampRegister:HandleClicked_CampRegister_Register(fromWhereType, fromSlotNo)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CAMPREGISTER_NAME"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_CAMPREGISTER_DESC"),
    functionYes = messageBox_RegistCamp,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_CampingServantListUpdate()
  if true == _ContentsGroup_RemasterUI_Main then
    if nil ~= PaGlobalFunc_ServantIcon_UpdateOtherIcon then
      PaGlobalFunc_ServantIcon_UpdateOtherIcon(PaGlobalFunc_ServantIcon_GetCampIndex())
      return
    end
    Panel_Icon_Camp:SetShow(false)
  else
    local isShow = ToClient_isCampingReigsted()
    Panel_Icon_Camp:SetShow(isShow)
    PaGlobal_Camp:setPos()
    if true == _ContentsGroup_RenewUI then
      Panel_Icon_Camp:SetShow(false)
    end
  end
end
function PaGlobal_CampRegister:CampRegister_InputCampName(fromWhereType, fromSlotNo)
  self._tempFromWhereType = fromWhereType
  self._tempFromSlotNo = fromSlotNo
  local campName = self._ui._campNaming:GetEditText()
  local itemWrapper = getInventoryItemByType(fromWhereType, fromSlotNo)
  if nil == itemWrapper then
    return
  end
  local characterKey = itemWrapper:getStaticStatus():get()._contentsEventParam1
  local campRegisterPSS = ToClient_getPetStaticStatus(characterKey)
  self._ui._campNaming:SetEditText("", true)
  self._ui._campNaming:SetMaxInput(getGameServiceTypePetNameLength())
  self._ui._campRegisterDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_PETREGISTER_DESC"))
  self._ui._campRegisterDesc:SetSize(self._ui._campRegisterDesc:GetSizeX(), self._ui._campRegisterDesc:GetTextSizeY() + 10)
  self._ui._campRegisterBG:SetSize(self._ui._campRegisterBG:GetSizeX(), self._ui._campRegisterDesc:GetTextSizeY() + self._ui._campNaming:GetSizeY() + 50)
  Panel_Window_CampRegister:SetSize(Panel_Window_CampRegister:GetSizeX(), self._ui._campRegisterDesc:GetTextSizeY() + self._ui._campNaming:GetSizeY() + self._ui._campRegister:GetSizeY() + 110)
  self._ui._campRegister:SetSpanSize(self._ui._campRegister:GetSpanSize().x, 10)
  self._ui._campRegisterCancel:SetSpanSize(self._ui._campRegisterCancel:GetSpanSize().x, 10)
  PaGlobal_CampRegister:HandleClicked_CampRegister_ClearEdit()
  Panel_Window_CampRegister:SetShow(true)
end
function PaGlobal_CampRegister:HandleClicked_CampRegister_Register(fromWhereType, fromSlotNo)
  local campName = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CAMP_TITLE")
  ToClient_requestServantRegisterCampingTent(fromWhereType, fromSlotNo, campName)
  PaGlobal_CampRegister:HandleClicked_CampRegister_Close()
end
function PaGlobal_CampRegister:HandleClicked_CampRegister_Close()
  PaGlobal_CampRegister:CampRegister_Close()
end
function PaGlobal_CampRegister:HandleClicked_CampRegister_ClearEdit()
  self._ui._campNaming:SetEditText("", false)
  SetFocusEdit(self._ui._campNaming)
end
function FGlobal_CampRegister_Close()
  Panel_Window_CampRegister:SetShow(false)
end
function PaGlobal_CampRegister:CampRegister_registEventHandler()
  self._ui._campRegisterCancel:addInputEvent("Mouse_LUp", "PaGlobal_CampRegister:CampRegister_Close()")
  self._ui._campRegister:addInputEvent("Mouse_LUp", "PaGlobal_CampRegister:HandleClicked_CampRegister_Register()")
  self._ui._campNaming:addInputEvent("Mouse_LUp", "PaGlobal_CampRegister:HandleClicked_CampRegister_ClearEdit()")
  self._ui._campNaming:RegistReturnKeyEvent("PaGlobal_CampRegister:HandleClicked_CampRegister_Register()")
end
function PaGlobal_CampRegister:CampRegister_registMessageHandler()
  registerEvent("FromClient_RegisterCampingTent", "FromClient_RegisterCampingTent")
  registerEvent("FromClient_CampingServantListUpdate", "FromClient_CampingServantListUpdate")
end
PaGlobal_CampRegister:CampRegister_init()
PaGlobal_CampRegister:CampRegister_registEventHandler()
PaGlobal_CampRegister:CampRegister_registMessageHandler()
