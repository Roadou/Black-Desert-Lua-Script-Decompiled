Panel_Window_PetFunction:SetShow(false, false)
Panel_Window_PetFunction:setMaskingChild(true)
Panel_Window_PetFunction:ActiveMouseEventEffect(true)
Panel_Window_PetFunction:RegisterShowEventFunc(true, "")
Panel_Window_PetFunction:RegisterShowEventFunc(false, "")
local _petBG = UI.getChildControl(Panel_Window_PetFunction, "Static_PetTitle")
_petBG:setGlassBackground(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local PetFunction = {
  _config = {},
  _buttonRegister = UI.getChildControl(Panel_Window_PetFunction, "Button_Register"),
  _buttonExit = UI.getChildControl(Panel_Window_PetFunction, "Button_Exit"),
  _buttonMating = UI.getChildControl(Panel_Window_PetFunction, "Button_ListMating"),
  _buttonMarket = UI.getChildControl(Panel_Window_PetFunction, "Button_ListMarket"),
  _buttonMix = UI.getChildControl(Panel_Window_PetFunction, "Button_HorseMix")
}
function PetFunction:init()
end
function PetFunction:registEventHandler()
  self._buttonRegister:addInputEvent("Mouse_LUp", "PetFunction_Button_RegisterReady()")
  self._buttonExit:addInputEvent("Mouse_LUp", "PetFunction_Button_Exit()")
  self._buttonMating:addInputEvent("Mouse_LUp", "PetFunction_Button_Mating()")
  self._buttonMarket:addInputEvent("Mouse_LUp", "PetFunction_Button_Market()")
end
function PetFunction:registMessageHandler()
  registerEvent("onScreenResize", "PetFunction_Resize")
  registerEvent("FromClient_ServantUpdate", "PetFunction_RegisterAck")
end
function PetFunction_Resize()
  local self = PetFunction
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_PetFunction:SetSize(screenX, Panel_Window_PetFunction:GetSizeY())
  _petBG:SetSize(screenX, Panel_Window_PetFunction:GetSizeY())
  Panel_Window_PetFunction:ComputePos()
  _petBG:ComputePos()
  self._buttonRegister:ComputePos()
  self._buttonExit:ComputePos()
  self._buttonMating:ComputePos()
  self._buttonMarket:ComputePos()
  self._buttonMix:ComputePos()
end
function PetFunction_Button_RegisterReady()
  PetList_ClosePopup()
  Inventory_SetFunctor(InvenFiler_Mapae, PetFunction_Register, PetFunction_InventoryClose, nil)
  Inventory_ShowToggle()
  audioPostEvent_SystemUi(0, 0)
end
function PetFunction_Register(slotNo, itemWrapper, count_s64, inventoryType)
  PetRegister_OpenByInventory(inventoryType, slotNo)
end
function PetFunction_InventoryClose()
  Inventory_SetFunctor(nil)
end
function PetFunction_Button_Exit()
  audioPostEvent_SystemUi(0, 0)
  if not Panel_Window_PetFunction:IsShow() then
    return
  end
  PetList_ClosePopup()
  local self = PetFunction
  self._buttonRegister:EraseAllEffect()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    setIgnoreShowDialog(false)
  else
    PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(false)
  end
  Panel_Window_PetFunction:SetShow(false)
  InventoryWindow_Close()
  PetList_Close()
  PetInfo_Close()
  PetRegister_Close()
  PetMating_Close()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Open()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(true)
  else
    PaGlobalFunc_DialogMain_All_Open()
  end
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    closeClientChangeScene(npcKey)
  end
  local mainCameraName = Dialog_getMainSceneCameraName()
  changeCameraScene(mainCameraName, 0.5)
end
function PetRegistration(isHave)
  if isHave then
    PetRegistration = true
  else
    PetRegistration = false
  end
end
function PetFunction_RegisterAck()
  if false == Panel_Window_PetFunction:GetShow() then
    return
  end
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
  PetRegister_Close()
  local self = PetFunction
  self._buttonRegister:EraseAllEffect()
end
function PetFunction_Open()
  if Panel_Window_PetFunction:GetShow() then
    return
  end
  Servant_SceneOpen(Panel_Window_PetFunction)
  PetList_Open()
  local self = PetFunction
  if stable_doHaveRegisterItem() then
    local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_PET_REGISTERITEM_MSG")
    local messageboxData = {
      title = messageboxTitle,
      content = messageboxMemo,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
    self._buttonRegister:EraseAllEffect()
    self._buttonRegister:AddEffect("UI_ArrowMark01", true, 25, -38)
  else
    self._buttonRegister:EraseAllEffect()
  end
  if stable_isMating() then
    self._buttonMating:SetShow(true)
  end
  if stable_isMarket() then
    self._buttonMarket:SetShow(true)
  end
end
function PetFunction_Close()
  if not Panel_Window_PetFunction:IsShow() then
    return
  end
  audioPostEvent_SystemUi(0, 0)
  PetFunction._buttonRegister:EraseAllEffect()
  Inventory_SetFunctor(nil)
  InventoryWindow_Close()
  PetList_Close()
  PetMating_Close()
  PetMarket_Close()
  PetFunction_Button_Exit()
end
function PetFunction_Button_Mating()
  audioPostEvent_SystemUi(0, 0)
  PetList_ButtonClose()
  PetMating_Open(CppEnums.AuctionType.AuctionGoods_ServantMating)
  audioPostEvent_SystemUi(1, 0)
end
function PetFunction_Button_Market()
  audioPostEvent_SystemUi(0, 0)
  PetList_ButtonClose()
  audioPostEvent_SystemUi(1, 0)
  PetMarket_Open()
end
function PetFunction_Button_ListMarket()
  audioPostEvent_SystemUi(0, 0)
  PetList_ClosePopup()
  StableMarket_Open()
  audioPostEvent_SystemUi(1, 0)
end
function PetFunction_HideDialog()
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    setIgnoreShowDialog(true)
  else
    PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
  end
  UIAni.fadeInSCR_Down(Panel_Window_PetFunction)
  if true == _ContentsGroup_RenewUI_Dailog then
    PaGlobalFunc_MainDialog_Close()
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(false)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(false)
  end
end
function PetFunction_ViewScene()
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    openClientChangeScene(npcKey, 1)
    local funcCameraName = Dialog_getFuncSceneCameraName()
    changeCameraScene(funcCameraName, 0.5)
  end
end
PetFunction:init()
PetFunction:registEventHandler()
PetFunction:registMessageHandler()
PetFunction_Resize()
