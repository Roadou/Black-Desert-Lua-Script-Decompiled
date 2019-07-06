local _panel = Panel_Window_PetLookChange_Renew
_panel:SetShow(false)
local PetLookChange = {
  _ui = {
    _list2Pet = UI.getChildControl(_panel, "List2_PetLookChange"),
    stc_Left = UI.getChildControl(_panel, "Static_Left"),
    txt_lookIndex = nil,
    stc_icon = nil,
    stc_LeftPet = nil,
    txt_alert = nil
  },
  _currentIconIdx = 0,
  _currentPetIdx = 0,
  _whereType = nil,
  _slotNo = nil
}
function PaGlobalFunc_PetLookList_ListControlCreate(control, key)
  local btn = UI.getChildControl(control, "Button_ListObject")
  local stc_Value = UI.getChildControl(btn, "Static_PetValue")
  local txt_name = UI.getChildControl(stc_Value, "StaticText_PetName")
  local txt_level = UI.getChildControl(stc_Value, "StaticText_PetLevel")
  local stc_rightIcon = UI.getChildControl(btn, "Static_PetIcon")
  local key32 = Int64toInt32(key)
  local petIndex = key32
  btn:addInputEvent("Mouse_On", "PaGlobalFunc_PetLookchange_SelectSlot(" .. petIndex .. ")")
  btn:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_PetLookchange_AskChange(" .. petIndex .. ")")
  btn:registerPadEvent(__eConsoleUIPadEvent_Up_LB, "PaGlobalFunc_PetLookchange_SelectPetIcon(" .. petIndex .. ",-1)")
  btn:registerPadEvent(__eConsoleUIPadEvent_Up_RB, "PaGlobalFunc_PetLookchange_SelectPetIcon(" .. petIndex .. ",1)")
  local petData = ToClient_getPetSealedDataByIndex(petIndex)
  local iconPath = petData:getIconPath()
  local petLevel = petData._level
  local petName = petData:getName()
  txt_name:SetText(petName)
  txt_level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. petLevel)
  stc_rightIcon:ChangeTextureInfoName(iconPath)
end
function PaGlobalFunc_PetLookChange_Initialize()
  local self = PetLookChange
  self:init()
end
function PetLookChange:pushDataToList()
  self._ui._list2Pet:getElementManager():clearKey()
  local petCount = ToClient_getPetSealedList()
  for ii = 0, petCount - 1 do
    local petData = ToClient_getPetSealedDataByIndex(ii)
    if nil ~= petData then
      local petStaticStatus = petData:getPetStaticStatus()
      local lookcount = ToClient_getPetChangeLookCount(petStaticStatus)
      if lookcount > 1 then
        self._ui._list2Pet:getElementManager():pushKey(toInt64(0, ii))
      end
    end
  end
end
function PetLookChange:init()
  self._ui.txt_lookIndex = UI.getChildControl(self._ui.stc_Left, "StaticText_LookIndex")
  self._ui.stc_LeftPet = UI.getChildControl(self._ui.stc_Left, "Static_LeftPet")
  self._ui.stc_icon = UI.getChildControl(self._ui.stc_LeftPet, "Static_IconPet")
  self._ui.txt_alert = UI.getChildControl(self._ui.stc_LeftPet, "StaticText_Alert")
  self._ui._list2Pet:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_PetLookList_ListControlCreate")
  self._ui._list2Pet:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.txt_alert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_alert:SetShow(false)
  self:registerEvent()
end
function PaGlobalFunc_PetLookchange_SelectPetIcon(petIndex, iconIndex)
  local self = PetLookChange
  self._currentPetIdx = petIndex
  local petData = ToClient_getPetSealedDataByIndex(self._currentPetIdx)
  local petStaticStatus = petData:getPetStaticStatus()
  local count = ToClient_getPetChangeLookCount(petStaticStatus)
  local currentIconIndex = self._currentIconIdx + iconIndex
  if currentIconIndex < 0 or count <= currentIconIndex then
    return
  end
  local actionIndex = ToClient_getPetChangeLook_ActionIndex(petStaticStatus, currentIconIndex)
  local currentActionIndex = petData._actionIndex
  if currentActionIndex == actionIndex then
    self._ui.txt_alert:SetShow(true)
  else
    self._ui.txt_alert:SetShow(false)
  end
  self._currentIconIdx = currentIconIndex
  self._ui.txt_lookIndex:SetText(self._currentIconIdx + 1 .. " / " .. count)
  local iconPath = ToClient_getPetChangeLook_IconPath(petStaticStatus, self._currentIconIdx)
  self._ui.stc_icon:ChangeTextureInfoName(iconPath)
end
function PaGlobalFunc_PetLookchange_SelectSlot(idx)
  local petData = ToClient_getPetSealedDataByIndex(idx)
  if nil == petData then
    return
  end
  local self = PetLookChange
  self._currentPetIdx = idx
  self._currentIconIdx = 0
  PaGlobalFunc_PetLookchange_SelectPetIcon(self._currentPetIdx, self._currentIconIdx)
end
function PaGlobalFunc_PetLookchange_AskChange(petIndex)
  local petData = ToClient_getPetSealedDataByIndex(petIndex)
  if nil == petData then
    return
  end
  local self = PetLookChange
  local petStaticStatus = petData:getPetStaticStatus()
  local actionIndex = ToClient_getPetChangeLook_ActionIndex(petStaticStatus, self._currentIconIdx)
  local currentActionIndex = petData._actionIndex
  if currentActionIndex == actionIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_SAMETHING"))
    return
  end
  local petNo = petData._petNo
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOCKCHANGE_CHANGECONFIRM_MEMO")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_LOOKCHANGETOOLTIP_TITLE"),
    content = messageBoxMemo,
    functionYes = PaGlobalFunc_PetLookchange_Request,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_PetLookchange_Request()
  local self = PetLookChange
  local petData = ToClient_getPetSealedDataByIndex(self._currentPetIdx)
  local petStaticStatus = petData:getPetStaticStatus()
  local actionIndex = ToClient_getPetChangeLook_ActionIndex(petStaticStatus, self._currentIconIdx)
  local petNo = petData._petNo
  ToClient_requestPetChangeLook(petNo, actionIndex, self._whereType, self._slotNo)
end
function PetLookChange:registerEvent()
  registerEvent("FromClient_PetChangeLook", "FromClient_PetLookChange_ProceedPetLookChange")
  registerEvent("FromClient_PetLookChanged", "FromClient_PetLookChange_PetLookChangedComplete")
end
function PetLookChange:open()
  local inventoryPanel = Panel_Window_Inventory
  if inventoryPanel:GetShow() then
    PaGlobalFunc_InventoryInfo_Close()
  end
  _panel:SetShow(true)
end
function PaGlobalFunc_PetLookChange_Open()
  local self = PetLookChange
  self:open()
end
function PetLookChange:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_PetLookChange_Close()
  local self = PetLookChange
  self.close()
end
function FromClient_PetLookChange_ProceedPetLookChange(whereType, slotNo)
  local self = PetLookChange
  if false == _panel:GetShow() then
    _panel:SetShow(false)
  end
  local changeableCount = petLookChangeableCount()
  if 0 == changeableCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_NOPET"))
    return
  end
  self._currentIconIdx = 0
  self._currentPetIdx = 0
  self._whereType = whereType
  self._slotNo = slotNo
  self:pushDataToList()
  PaGlobalFunc_PetLookChange_Open()
end
function petLookChangeableCount()
  local lookChangablePetCount = 0
  for index = 0, ToClient_getPetSealedList() - 1 do
    local petData = ToClient_getPetSealedDataByIndex(index)
    if nil ~= petData then
      local petStaticStatus = petData:getPetStaticStatus()
      local lookcount = ToClient_getPetChangeLookCount(petStaticStatus)
      if lookcount > 1 then
        lookChangablePetCount = lookChangablePetCount + 1
      end
    end
  end
  return lookChangablePetCount
end
function FromClient_PetLookChange_PetLookChangedComplete()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PETLOOKCHANGE_CHANGEPET"))
  PaGlobalFunc_PetLookChange_Close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_PetLookChange_Initialize")
