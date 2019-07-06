local _panel = Panel_Window_ChangeItem_Renew
_panel:SetShow(false)
_panel:RegisterShowEventFunc(true, "panel_ChangeItem_ShowAni()")
_panel:RegisterShowEventFunc(false, "panel_ChangeItem_HideAni()")
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local equipSlot = {}
local avatarSlot = {}
local selectedItemSlotNo, selectedItemWhere
local elapsTime = 0
local doChange = false
local resultItemKey = 0
local isChangeDoing = false
local slotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createCash = false
}
local ChangeItem = {
  _ui = {
    stc_runEffect = UI.getChildControl(_panel, "Static_BackEffect"),
    equipIcon = UI.getChildControl(_panel, "Static_equitIcon1"),
    avatarIcon = UI.getChildControl(_panel, "Static_equitIcon2"),
    txt_slot1 = UI.getChildControl(_panel, "StaticText_Slot1"),
    txt_slot2 = UI.getChildControl(_panel, "StaticText_Slot2"),
    stc_keyGuideArea = UI.getChildControl(_panel, "Static_BottomArea"),
    txt_keyGuideA = nil,
    txt_keyGuideB = nil
  }
}
local self = ChangeItem
function PaGlobalFunc_ItemChange_Initialize()
  self:init()
  self:registEventHandler()
end
function ChangeItem:init()
  SlotItem.new(equipSlot, "ChangeItem_Renew_equipSlot", 0, self._ui.equipIcon, slotConfig)
  equipSlot:createChild()
  equipSlot.icon:SetPosX(0)
  equipSlot.icon:SetPosY(0)
  SlotItem.new(avatarSlot, "ChangeItem_Renew_avatarSlot", 0, self._ui.avatarIcon, slotConfig)
  avatarSlot:createChild()
  avatarSlot.icon:SetPosX(0)
  avatarSlot.icon:SetPosY(0)
  self._ui.txt_slot1:SetPosY(self._ui.equipIcon:GetPosY() + equipSlot.icon:GetSizeY() + 5)
  self._ui.txt_slot2:SetPosY(self._ui.avatarIcon:GetPosY() + avatarSlot.icon:GetSizeY() + 5)
  ChangeItem:setKeyGuide()
  self._ui.stc_runEffect:SetShow(false)
  self._ui.txt_keyGuideA:SetShow(false)
end
function ChangeItem:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_ChangeItem_Apply()")
  _panel:RegisterUpdateFunc("PaGlobalFunc_ChangeItem_UpdatePerFrame")
  registerEvent("FromClient_ShowItemChange", "FromClient_ShowItemChange_ChangeItem")
  registerEvent("FromClient_ItemChange", "FromClient_ChangeItem_Result")
end
function panel_ChangeItem_ShowAni()
  UIAni.fadeInSCR_Down(_panel)
  local aniInfo1 = _panel:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = _panel:GetSizeX() / 2
  aniInfo1.AxisY = _panel:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = _panel:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = _panel:GetSizeX() / 2
  aniInfo2.AxisY = _panel:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function panel_ChangeItem_HideAni()
  _panel:SetAlpha(1)
  local aniInfo = UIAni.AlphaAnimation(0, _panel, 0, 0.1)
  aniInfo:SetHideAtEnd(true)
end
function FromClient_ShowItemChange_ChangeItem()
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = 0
  self._ui.stc_runEffect:SetShow(false)
  equipSlot:clearItem()
  avatarSlot:clearItem()
  avatarSlot.icon:EraseAllEffect()
  self._ui.txt_keyGuideA:SetShow(false)
  if false == isChangeDoing then
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "Input_ChangeItem_Apply()")
  end
  _panel:SetShow(true)
  Inventory_SetFunctor(PaGlobalFunc_ChangeItem_SetFilter, PaGlobalFunc_ChangeItem_Rclick, nil, nil)
  PaGlobalFunc_InventoryInfo_Open(1)
  ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  ToClient_padSnapResetControl()
end
function ChangeItem:setKeyGuide()
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_A")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_keyGuideArea, "StaticText_B")
  local keyGuideList = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideList, self._ui.stc_keyGuideArea, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_ChangeItem_SetFilter(slotNo, itemWrapper, currentWhereType)
  local itemKey = itemWrapper:get():getKey()
  local isUseableItem = getItemChange(itemKey)
  if nil == isUseableItem then
    return true
  else
    return false
  end
end
function PaGlobalFunc_ChangeItem_Rclick(slotNo, itemWrapper, count_s64, inventoryType)
  selectedItemSlotNo = slotNo
  selectedItemWhere = inventoryType
  elapsTime = 0
  equipSlot:clearItem()
  equipSlot:setItem(itemWrapper)
  if nil ~= equipSlot then
    self._ui.txt_keyGuideA:SetShow(true)
    ChangeItem:setKeyGuide()
  end
  local itemKey = itemWrapper:get():getKey()
  local itemSSW = getItemChange(itemKey)
  resultItemKey = itemSSW:get()._key
  avatarSlot:clearItem()
  avatarSlot:setItemByStaticStatus(itemSSW, 1, nil, nil, true)
  avatarSlot.icon:SetMonoTone(true)
  ToClient_padSnapSetTargetPanel(_panel)
end
function Input_ChangeItem_Apply()
  if nil == selectedItemWhere or nil == selectedItemSlotNo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEWEAPON_SELECTITEM"))
    return
  end
  elapsTime = 0
  doChange = true
  isChangeDoing = true
  audioPostEvent_SystemUi(13, 15)
  self._ui.stc_runEffect:SetShow(true)
  self._ui.txt_keyGuideA:SetShow(false)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
end
function FromClient_ChangeItem_Result(itemSSW)
  equipSlot:clearItem()
  avatarSlot:clearItem()
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = itemSSW:get()._key
  avatarSlot:setItemByStaticStatus(itemSSW, 1, nil, nil, true)
  avatarSlot.icon:SetMonoTone(false)
end
function PaGlobalFunc_ChangeItem_Cancel()
  if nil ~= equipSlot or nil ~= avatarSlot then
    equipSlot:clearItem()
    avatarSlot:clearItem()
  end
end
function PaGlobalFunc_ChangeItem_Close()
  if true == isChangeDoing then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGEITEM_DONOT_CLOSE"))
    return
  end
  equipSlot:clearItem()
  avatarSlot:clearItem()
  selectedItemSlotNo = nil
  selectedItemWhere = nil
  elapsTime = 0
  doChange = false
  resultItemKey = 0
  isChangeDoing = false
  self._ui.stc_runEffect:SetShow(false)
  Inventory_SetFunctor(nil, nil, nil, nil)
  _panel:SetShow(false, false)
end
function PaGlobalFunc_ChangeItem_UpdatePerFrame(deltaTime)
  elapsTime = elapsTime + deltaTime
  if elapsTime > 3 then
    if nil == selectedItemSlotNo or nil == selectedItemWhere or false == doChange then
      return
    end
    self._ui.stc_runEffect:SetShow(false)
    avatarSlot.icon:AddEffect("UI_ItemEnchant01", false, -5, -5)
    useItemChange(selectedItemWhere, selectedItemSlotNo)
    doChange = false
    isChangeDoing = false
  end
  if elapsTime > 4 then
    elapsTime = 0
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_ItemChange_Initialize()")
