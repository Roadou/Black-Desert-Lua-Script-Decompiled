local _mainPanel = Panel_Window_Extract_Renew
local _panel = Panel_Tab_ExtractBlackStone_Renew
local ExtractBlackStone = {
  _ui = {
    stc_group = UI.getChildControl(_panel, "Static_BlackStoneGroup")
  },
  _targetWhereType = nil,
  _targetSlotNo = nil,
  _currentTime = 0,
  _doExtracting = false,
  _targetIsWeapon = false,
  _fending = false
}
local extractingEffect = {
  _step1 = nil,
  _step2 = nil,
  _step3 = nil,
  _uiEquipItem = nil,
  _blackStoneWeapon = nil,
  _blackStoneArmor = nil
}
local self = ExtractBlackStone
function FromClient_luaLoadComplete_ExtractBlackStone_Init()
  self:initialize()
  local moveTarget = UI.getChildControl(_mainPanel, "Static_BlackStoneGroup")
  moveTarget:SetShow(false)
  moveTarget:MoveChilds(moveTarget:GetID(), _panel)
  deletePanel(_panel:GetID())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ExtractBlackStone_Init")
function ExtractBlackStone:initialize()
  self._ui.stc_BG = UI.getChildControl(self._ui.stc_group, "Static_BG")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_group, "StaticText_Desc")
  self._ui.txt_desc:SetShow(false)
  self._uiEffectCircle = UI.getChildControl(self._ui.stc_BG, "Static_ExtractionSpinEffect")
  self.stc_targetBG = UI.getChildControl(self._ui.stc_BG, "Static_Equip_Socket")
  self._uiEffectStep1 = UI.getChildControl(self._ui.stc_BG, "Static_ExtractionEffect_Step1")
  self._uiEffectStep2 = UI.getChildControl(self._ui.stc_BG, "Static_ExtractionEffect_Step2")
  self._uiEffectStep3 = UI.getChildControl(self._ui.stc_BG, "Static_ExtractionEffect_Step3")
  self._uiIconBlackStoneArmor = UI.getChildControl(self._ui.stc_BG, "Static_BlackStone_Armor")
  self._uiIconBlackStoneWeapon = UI.getChildControl(self._ui.stc_BG, "Static_BlackStone_Weapon")
  self._uiTextBlackStoneCount = UI.getChildControl(self._ui.stc_BG, "StaticText_BlackStone_Count")
  self._uiButtonApply = UI.getChildControl(self._ui.stc_group, "Button_Center")
  self._ui.txt_keyGuide = UI.getChildControl(self._uiButtonApply, "StaticText_KeyGuide")
  self._ui.txt_keyGuide:SetPosX(self._uiButtonApply:GetSizeX() * 0.5 - (self._ui.txt_keyGuide:GetTextSpan().x + self._ui.txt_keyGuide:GetTextSizeX()) * 0.5)
  self._ui.txt_keyGuide:SetMonoTone(true)
  local slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  }
  self._uiEquipItem = {}
  self._uiEquipItem.icon = UI.getChildControl(self._ui.stc_BG, "Static_Equip_Socket_Background")
  SlotItem.new(self._uiEquipItem, "Slot_TargetItem", 0, self._ui.stc_targetBG, slotConfig)
  self._uiEquipItem.slot_On = UI.getChildControl(self._ui.stc_BG, "Static_Equip_Socket_EffectOn")
  self._uiEquipItem.slot_Nil = UI.getChildControl(self._ui.stc_BG, "Static_Equip_Socket_EffectOff")
  self._uiEquipItem:createChild()
  self._uiEquipItem:clearItem()
  self._uiEquipItem.empty = true
  self:registMessageHandler()
end
function ExtractBlackStone:registMessageHandler()
  registerEvent("FromClient_ExtractionEnchant_Success", "FromClient_ExtractBlackStone_Success")
end
function PaGlobalFunc_ExtractBlackStone_Open()
  PaGlobalFunc_InventoryInfo_Open(1)
  Inventory_SetFunctor(ExtractBlackStone_FilterTarget, ExtractBlackStone_rClickedTarget, ExtractionEnchantStone_WindowClose, nil)
  self._ui.stc_BG:SetShow(true)
  ToClient_padSnapSetTargetPanel(_mainPanel)
  self._uiEffectCircle:SetVertexAniRun("Ani_Color_Off", true)
  self._uiEffectCircle:SetVertexAniRun("Ani_Rotate_New", true)
  self._uiEffectCircle:SetShow(true)
end
function PaGlobalFunc_ExtractBlackStone_Close()
  self:clear()
  self._ui.txt_keyGuide:SetMonoTone(true)
  PaGlobalFunc_ExtractBlackStone_ResetEffect()
  Inventory_SetFunctor(nil)
end
function PaGlobalFunc_ExtractBlackStone_OnPadB()
  if true == self._doExtracting or true == self._fending then
    return
  end
  if nil ~= self._targetSlotNo or false == self._uiEquipItem.empty then
    self:clear()
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    return false
  else
    return true
  end
end
function ExtractBlackStone_FilterTarget(slotNo, itemWrapper, whereType)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus():get()
  local equipSlotNo = itemWrapper:getStaticStatus():getEquipSlotNo()
  local isNotAccessories = false
  local isNotCashItem = true
  if 7 ~= equipSlotNo and 8 ~= equipSlotNo and 9 ~= equipSlotNo and 10 ~= equipSlotNo and 11 ~= equipSlotNo and 12 ~= equipSlotNo and 13 ~= equipSlotNo then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isUsableServant() then
    isNotAccessories = true
  end
  if itemWrapper:getStaticStatus():isGuildStockable() then
    isNotAccessories = false
  end
  if itemWrapper:isCash() then
    isNotCashItem = false
  end
  if true == ToClient_Inventory_CheckItemLock(slotNo, Inventory_GetCurrentInventoryType()) then
    return true
  end
  return false == (0 < itemSSW._key:getEnchantLevel() and itemSSW._key:getEnchantLevel() < 16 and isNotAccessories and isNotCashItem)
end
function ExtractBlackStone_rClickedTarget(slotNo, itemWrapper, count_s64, inventoryType)
  if nil == slotNo or nil == itemWrapper then
    return
  end
  if true == self._doExtracting or true == self._fending then
    return
  end
  if self._uiEquipItem.icon then
    audioPostEvent_SystemUi(0, 16)
    self._uiEquipItem.icon:AddEffect("UI_Button_Hide", false, 0, 0)
    self._uiEquipItem.slot_On:SetShow(true)
    self._uiEquipItem.slot_Nil:SetShow(false)
    self._uiEffectCircle:ResetVertexAni()
    self._uiEffectCircle:SetVertexAniRun("Ani_Color_On", true)
    self._uiEffectCircle:SetVertexAniRun("Ani_Rotate_New", true)
    self._uiButtonApply:SetIgnore(false)
    self._uiButtonApply:SetMonoTone(false)
    self._uiEquipItem.empty = false
    ToClient_padSnapSetTargetPanel(_mainPanel)
  end
  self._uiEquipItem.empty = false
  self._targetWhereType = inventoryType
  self._targetSlotNo = slotNo
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  self._uiEquipItem:setItem(itemWrapper)
  self._uiEquipItem.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", true)")
  self._uiEquipItem.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"inventory\", false)")
  Panel_Tooltip_Item_SetPosition(slotNo, self._uiEquipItem, "inventory")
  local ItemEnchantStaticStatus = itemWrapper:getStaticStatus():get()
  local blackStone_Count = ItemEnchantStaticStatus._key:getEnchantLevel()
  self._targetIsWeapon = ItemEnchantStaticStatus:isWeapon() or ItemEnchantStaticStatus:isSubWeapon() or ItemEnchantStaticStatus:isAwakenWeapon()
  if self._targetIsWeapon then
    if blackStone_Count >= 8 then
      blackStone_Count = "?"
    end
  elseif blackStone_Count >= 6 then
    blackStone_Count = "?"
  end
  self._uiTextBlackStoneCount:SetText(blackStone_Count)
  self._uiIconBlackStoneWeapon:SetShow(self._targetIsWeapon)
  self._uiIconBlackStoneWeapon:SetMonoTone(true)
  self._uiIconBlackStoneArmor:SetShow(not self._targetIsWeapon)
  self._uiIconBlackStoneArmor:SetMonoTone(true)
  Inventory_SetFunctor(ExtractBlackStone_FilterTarget, ExtractBlackStone_rClickedTarget, PaGlobalFunc_ExtractBlackStone_Close, nil)
end
function PaGlobalFunc_ExtractBlackStone_ApplyExtract()
  if true == self._doExtracting or true == self._fending then
    return
  end
  if nil == self._targetSlotNo or true == self._uiEquipItem.empty then
    return
  end
  self._ui.txt_keyGuide:SetMonoTone(true)
  local messageContent = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_APPLYREADY")
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageContent,
    functionYes = function()
      self._fending = true
      ToClient_ExtractBlackStone(self._targetWhereType, self._targetSlotNo)
      audioPostEvent_SystemUi(5, 10)
      FGlobal_MiniGame_RequestExtraction()
      PaGlobal_TutorialManager:handleApplyExtractionEnchantStone()
    end,
    functionNo = function()
      self._ui.txt_keyGuide:SetMonoTone(false)
    end,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_ExtractBlackStone_Success()
  self._fending = false
  self._ui.txt_keyGuide:SetMonoTone(true)
  self._currentTime = 0
  self._doExtracting = true
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobalFunc_ExtractBlackStone_UpdatePerFrame(DeltaTime)
  self._currentTime = self._currentTime + DeltaTime
  if self._currentTime > 0 and self._currentTime < 1 and true == self._doExtracting then
    self._uiEffectStep1:SetShow(true)
    if nil == extractingEffect._step1 then
      extractingEffect._step1 = self._uiEffectStep1:AddEffect("UI_StoneExtract_01", false, 0, 0)
      extractingEffect._step1 = self._uiEffectStep1:AddEffect("UI_ItemJewel", false, 0, 0)
      extractingEffect._step1 = self._uiEffectStep1:AddEffect("fUI_StoneExtract_SpinSmoke01", false, 0, 0)
    end
    self._uiEffectStep2:SetShow(false)
    self._uiEffectStep3:SetShow(false)
  elseif self._currentTime >= 1 and self._currentTime < 1.8 and true == self._doExtracting then
    self._uiEffectStep1:SetShow(true)
    self._uiEffectStep2:SetShow(false)
    self._uiEffectStep3:SetShow(false)
  elseif self._currentTime >= 1.8 and self._currentTime < 2.3 and true == self._doExtracting then
    if nil ~= extractingEffect._uiEquipItem then
      self._uiEquipItem.icon:EraseEffect(extractingEffect._uiEquipItem)
    end
    self._uiEquipItem:clearItem()
    self._uiEquipItem.slot_On:SetShow(false)
    self._uiEquipItem.slot_Nil:SetShow(true)
    self._uiEffectStep1:SetShow(true)
    self._uiEffectStep2:SetShow(false)
    self._uiEffectStep3:SetShow(false)
  elseif self._currentTime >= 2.3 and self._currentTime < 3 and true == self._doExtracting then
    self._uiEffectStep1:SetShow(true)
    self._uiEffectStep2:SetShow(false)
    self._uiEffectStep3:SetShow(false)
    if nil == extractingEffect._blackStoneWeapon then
      extractingEffect._blackStoneWeapon = self._uiIconBlackStoneWeapon:AddEffect("UI_ItemEnchant01", false, -2.5, -2.5)
    end
    if nil == extractingEffect._blackStoneArmor then
      extractingEffect._blackStoneArmor = self._uiIconBlackStoneArmor:AddEffect("UI_ItemEnchant01", false, -2.5, -2.5)
    end
  elseif self._currentTime >= 3 and self._currentTime < 3.8 and true == self._doExtracting then
    self._uiEffectStep3:SetShow(false)
    self._uiIconBlackStoneWeapon:SetMonoTone(false)
    self._uiIconBlackStoneArmor:SetMonoTone(false)
  elseif self._currentTime >= 3.8 and self._currentTime < 4 and true == self._doExtracting then
    if nil ~= extractingEffect._step1 then
      self._uiEffectStep1:EraseEffect(extractingEffect._step1)
      extractingEffect._step1 = nil
    end
    if nil ~= extractingEffect._blackStoneWeapon then
      self._uiIconBlackStoneWeapon:EraseEffect(extractingEffect._blackStoneWeapon)
      extractingEffect._uiIconBlackStoneWeapon = nil
    end
    if nil ~= extractingEffect._blackStoneArmor then
      self._uiIconBlackStoneArmor:EraseEffect(extractingEffect._blackStoneArmor)
      extractingEffect._blackStoneArmor = nil
    end
    self:successXXX()
  end
end
function PaGlobalFunc_ExtractBlackStone_ResetEffect()
  local self = ExtractBlackStone
  self._currentTime = 0
  self._doExtracting = false
  self._uiEffectStep1:EraseAllEffect()
  self._uiIconBlackStoneWeapon:EraseAllEffect()
  self._uiIconBlackStoneArmor:EraseAllEffect()
  extractingEffect._step1 = nil
  extractingEffect._step2 = nil
  extractingEffect._step3 = nil
  extractingEffect._uiEquipItem = nil
  extractingEffect._blackStoneWeapon = nil
  extractingEffect._blackStoneArmor = nil
end
function ExtractBlackStone:successXXX()
  self._doExtracting = false
  self._currentTime = 0
  self:resultShow()
  self:clear()
end
function ExtractBlackStone:clear()
  self._fending = false
  self._targetSlotNo = nil
  self._uiEquipItem.slotNo = nil
  self._uiEquipItem:clearItem()
  self._uiEquipItem.empty = true
  self._uiIconBlackStoneWeapon:SetShow(false)
  self._uiIconBlackStoneArmor:SetShow(false)
  self._uiIconBlackStoneWeapon:SetMonoTone(true)
  self._uiIconBlackStoneArmor:SetMonoTone(true)
  self._uiTextBlackStoneCount:SetShow(false)
  self._uiTextBlackStoneCount:SetText(0)
  self._uiEquipItem.slot_On:SetShow(false)
  self._uiEquipItem.slot_Nil:SetShow(true)
  getEnchantInformation():ToClient_clearData()
end
function ExtractBlackStone:resultShow()
  if self._targetIsWeapon then
    local blackStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16001))
    PaGlobal_ExtractionResult:showResultMessage(blackStoneSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_RESULTMSG"), blackStoneSSW)
  else
    local blackStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16002))
    PaGlobal_ExtractionResult:showResultMessage(blackStoneSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_RESULTMSG"), blackStoneSSW)
  end
  PaGlobal_TutorialManager:handleExtractionEnchantStoneResultShow()
end
function PaGlobalFunc_ExtractBlackStone_UpdateKeyGuide(isSnappedOnThisPanel)
  self._ui.txt_keyGuide:SetMonoTone(false == isSnappedOnThisPanel or true == self._uiEquipItem.empty)
  _PA_LOG("\235\176\149\235\178\148\236\164\128", "txt_keyGuide:SetMonoTone(false)_____2")
end
