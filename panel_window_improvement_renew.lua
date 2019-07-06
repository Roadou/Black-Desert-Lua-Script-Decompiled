local _panel = Panel_Window_Improvement_Renew
local ImprovementInfo = {
  _ui = {
    stc_title = UI.getChildControl(_panel, "Static_Title"),
    txt_title = nil,
    stc_mainBG = UI.getChildControl(_panel, "Static_MainBG"),
    txt_descTitle = nil,
    txt_descSub = nil,
    stc_innerBG = UI.getChildControl(_panel, "Static_InnerBG"),
    stc_artworkBG = nil,
    stc_leftSlotBG = nil,
    slot_subject = nil,
    stc_rightSlotBG = nil,
    slot_target = nil,
    btn_do = nil,
    stc_buttonGroup = UI.getChildControl(_panel, "Static_ButtonGroup_ConsoleUI"),
    stc_buttonBG = nil,
    txt_keyGuideApply = nil,
    stc_bottom = UI.getChildControl(_panel, "Static_Bottom"),
    txt_keyGuideExit = nil
  },
  _targetSlotNo = nil,
  _subjectSlotNo = nil,
  _targetWhereType = nil,
  _subjectWhereType = nil,
  _isAnimating = false,
  _animationTimeElapsed = 0,
  _improveReady = false
}
function FromClient_luaLoadComplete_ImprovementInfo_Init()
  ImprovementInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ImprovementInfo_Init")
function ImprovementInfo:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_title, "StaticText_Title")
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_IMPROVE"))
  self._ui.txt_descTitle = UI.getChildControl(self._ui.stc_mainBG, "StaticText_DescTitle")
  self._ui.txt_descTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_TITLE"))
  self._ui.txt_descSub = UI.getChildControl(self._ui.stc_mainBG, "StaticText_DescSub")
  self._ui.txt_descSub:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_descSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_DESC"))
  self._ui.stc_artworkBG = UI.getChildControl(self._ui.stc_innerBG, "Static_ImprovementFrame")
  self._ui.stc_leftSlotBG = UI.getChildControl(self._ui.stc_innerBG, "Static_SlotBase")
  self._ui.stc_rightSlotBG = UI.getChildControl(self._ui.stc_innerBG, "Static_SlotResult")
  self._ui.btn_do = UI.getChildControl(self._ui.stc_innerBG, "Button_Do")
  self._ui.stc_buttonBG = UI.getChildControl(self._ui.stc_buttonGroup, "Static_Improvement_ConsoleUI")
  self._ui.txt_keyGuideApply = UI.getChildControl(self._ui.stc_buttonGroup, "StaticText_Improvement_ConsolUI")
  self._ui.txt_keyGuideApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_TITLE"))
  self._ui.txt_keyGuideExit = UI.getChildControl(self._ui.stc_bottom, "StaticText_Cancel_ConsoleUI")
  local slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = false
  }
  self._ui.slot_subject = {}
  SlotItem.new(self._ui.slot_subject, "Slot_Subject", 0, self._ui.stc_leftSlotBG, slotConfig)
  self._ui.slot_subject:createChild()
  self._ui.slot_target = {}
  SlotItem.new(self._ui.slot_target, "Slot_Target", 0, self._ui.stc_rightSlotBG, slotConfig)
  self._ui.slot_target:createChild()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_keyGuideApply
  }, self._ui.stc_buttonGroup, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_CENTER)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign({
    self._ui.txt_keyGuideExit
  }, self._ui.stc_bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:RegistEventHandler()
  self:RegistMessageHandler()
end
function ImprovementInfo:RegistEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "Input_ImprovementInfo_ApplyImprove()")
end
function ImprovementInfo:RegistMessageHandler()
  _panel:RegisterUpdateFunc("FromClient_ImprovementInfo_UpdatePerFrame")
  registerEvent("FromClient_ResponseImporve", "FromClient_ImprovementInfo_ResponseImprove")
end
function PaGlobalFunc_ImprovementInfo_Open()
  ImprovementInfo:open()
end
function PaGlobalFunc_ImprovementInfo_GetShow()
  return _panel:GetShow()
end
function ImprovementInfo:open()
  _panel:SetShow(true)
  self._isAnimating = false
  self._animationTimeElapsed = 0
  PaGlobalFunc_InventoryInfo_Open()
  getImproveInformation():clearData()
  self:update()
end
function ImprovementInfo:update()
  if nil == self._targetSlotNo then
    self._ui.slot_target:clearItem()
    self._ui.slot_subject:clearItem()
    self._subjectSlotNo = nil
    self._ui.txt_keyGuideExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_EXIT"))
    self._ui.txt_keyGuideApply:SetMonoTone(true)
    Inventory_SetFunctor(PaGlobalFunc_ImprovementInfo_FilterTarget, PaGlobalFunc_ImprovementInfo_SelectTarget, nil, nil)
    self._improveReady = false
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  elseif nil == self._subjectSlotNo then
    self._ui.slot_target:setItem(getInventoryItemByType(self._targetWhereType, self._targetSlotNo))
    self._ui.slot_subject:clearItem()
    self._ui.txt_keyGuideExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_DISCARD"))
    self._ui.txt_keyGuideApply:SetMonoTone(true)
    Inventory_SetFunctor(PaGlobalFunc_ImprovementInfo_FilterSubject, PaGlobalFunc_ImprovementInfo_SelectSubject, nil, nil)
    self._improveReady = false
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
  else
    self._ui.slot_subject:setItem(getInventoryItemByType(self._subjectWhereType, self._subjectSlotNo))
    local doNotFilter = function()
      return true
    end
    self._ui.txt_keyGuideExit:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GENERIC_KEYGUIDE_XBOX_DISCARD"))
    self._ui.txt_keyGuideApply:SetMonoTone(false)
    Inventory_SetFunctor(doNotFilter, nil, nil, nil)
    self._improveReady = true
    ToClient_padSnapSetTargetPanel(_panel)
  end
  if false == self._ui.txt_keyGuideExit:GetShow() then
    self._ui.txt_keyGuideExit:SetShow(true)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign({
      self._ui.txt_keyGuideExit
    }, self._ui.stc_bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
    self._ui.txt_keyGuideExit:SetShow(false)
  else
    PaGlobalFunc_ConsoleKeyGuide_SetAlign({
      self._ui.txt_keyGuideExit
    }, self._ui.stc_bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  end
end
function PaGlobalFunc_ImprovementInfo_FilterTarget(slotNo, notUse_itemWrappers, whereType)
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  local ssW = itemWrapper:getStaticStatus():get()
  return not ssW:isImprovable()
end
function PaGlobalFunc_ImprovementInfo_SelectTarget(slotNo, itemWrapper, count, inventoryType)
  local self = ImprovementInfo
  local improveInfo = getImproveInformation()
  if nil == improveInfo then
    return
  end
  improveInfo:SetImproveSlot(inventoryType, slotNo)
  self._targetSlotNo = slotNo
  self._targetWhereType = inventoryType
  self:update()
  _AudioPostEvent_SystemUiForXBOX(0, 16)
end
function PaGlobalFunc_ImprovementInfo_FilterSubject(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  local returnValue = true
  if 0 ~= getImproveInformation():checkIsValidSubItem(slotNo) then
    returnValue = true
  else
    returnValue = false
    if CppEnums.ItemWhereType.eInventory ~= whereType then
      returnValue = true
    end
  end
  return returnValue
end
function PaGlobalFunc_ImprovementInfo_SelectSubject(slotNo, itemWrapper, count, inventoryType)
  local self = ImprovementInfo
  local improveInfo = getImproveInformation()
  if nil == improveInfo then
    return
  end
  improveInfo:SetImproveSlot(inventoryType, slotNo)
  self._subjectSlotNo = slotNo
  self._subjectWhereType = inventoryType
  self:update()
  _AudioPostEvent_SystemUiForXBOX(0, 16)
end
function Input_ImprovementInfo_ApplyImprove()
  ImprovementInfo:applyImprove()
end
function ImprovementInfo:applyImprove()
  if false == self._isAnimating and true == self._improveReady then
    self._isAnimating = true
    _AudioPostEvent_SystemUiForXBOX(5, 6)
    _AudioPostEvent_SystemUiForXBOX(5, 9)
    self._ui.stc_artworkBG:EraseAllEffect()
    self._ui.stc_artworkBG:AddEffect("fUI_LimitOver02A", true, 0, 0)
    self._ui.stc_artworkBG:AddEffect("UI_LimitOverLine_02", false, 0, 0)
    self._ui.stc_artworkBG:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
    self._ui.slot_target.icon:EraseAllEffect()
    self._ui.slot_target.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
    self._ui.slot_subject.icon:EraseAllEffect()
    self._ui.slot_subject.icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
  elseif true == self._isAnimating then
    self._animationTimeElapsed = self._animationTimeElapsed + 6
  end
end
function ImprovementInfo:executeImprove()
  getImproveInformation():doImprove()
  ToClient_BlackspiritEnchantClose()
  self._ui.slot_target.icon:EraseAllEffect()
  self._ui.slot_target.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
  self._ui.slot_subject.icon:EraseAllEffect()
  self._ui.stc_artworkBG:EraseAllEffect()
  self._targetSlotNo, self._subjectSlotNo = nil, nil
  self:update()
  getImproveInformation():clearData()
end
function FromClient_ImprovementInfo_ResponseImprove(itemEnchantKey, index)
  if 0 == index then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_SUCCESSMSG", "itemName", tostring(itemSSW:getName())))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_IMPROVEMENT_FAILMSG_NEW"))
  end
end
function FromClient_ImprovementInfo_UpdatePerFrame(deltaTime)
  if ImprovementInfo._isAnimating then
    local self = ImprovementInfo
    self._animationTimeElapsed = self._animationTimeElapsed + deltaTime
    if self._animationTimeElapsed > 6 then
      self:executeImprove()
      self._isAnimating = false
      self._animationTimeElapsed = 0
    end
  end
end
function PaGlobalFunc_ImprovementInfo_Discard()
  local self = ImprovementInfo
  if true == self._isAnimating then
    self._isAnimating = false
    self._animationTimeElapsed = 0
    self._ui.stc_artworkBG:EraseAllEffect()
    self._ui.slot_subject.icon:EraseAllEffect()
    self._ui.slot_target.icon:EraseAllEffect()
    ToClient_BlackspiritEnchantCancel()
    return false
  elseif nil ~= self._targetSlotNo then
    self._ui.slot_subject:clearItem()
    self._ui.slot_target:clearItem()
    self._subjectSlotNo = nil
    self._targetSlotNo = nil
    getImproveInformation():clearData()
    self:update()
    return false
  end
  if nil == self._targetSlotNo and nil == self._subjectSlotNo then
    PaGlobalFunc_ImprovementInfo_Close()
    return true
  end
end
function PaGlobalFunc_ImprovementInfo_Close()
  ImprovementInfo:close()
end
function ImprovementInfo:close()
  _panel:SetShow(false)
  getImproveInformation():clearData()
  ToClient_BlackspiritEnchantClose()
  Inventory_SetFunctor(nil, nil, nil, nil)
  PaGlobalFunc_InventoryInfo_Close()
end
