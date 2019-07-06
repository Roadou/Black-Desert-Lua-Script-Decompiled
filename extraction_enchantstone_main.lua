local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_PD = CppEnums.Padding
PaGlobal_ExtractionEnchantStone = {
  _currentTime = 0,
  _slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  _uiButtonApply = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Button_Extraction_Socket_1"),
  _subbg = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_SubFrame"),
  _uiEffectCircle = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_ExtractionSpinEffect"),
  _uiGuideBG = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_ExtractionGuideBG"),
  _uiEquipItem = {},
  _uiEffectStep1 = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step1"),
  _uiEffectStep2 = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step2"),
  _uiEffectStep3 = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_ExtractionEffect_Step3"),
  _uiIconBlackStoneWeapon = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_BlackStone_Weapon"),
  _uiIconBlackStoneArmor = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_BlackStone_Armor"),
  _uiTextBlackStoneCount = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "StaticText_BlackStone_Count"),
  _uiButtonQuestion = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Button_Question"),
  _doExtracting = false,
  _targetWhereType = nil,
  _targetSlotNo = nil,
  _thisIsWeapone = nil
}
registerEvent("FromClient_luaLoadComplete", "LoadComplete_ExtractionEnchantStone_Initialize")
function LoadComplete_ExtractionEnchantStone_Initialize()
  PaGlobal_ExtractionEnchantStone:initialize()
  PaGlobal_ExtractionEnchantStone:clear()
  PaGlobal_ExtractionEnchantStone:registMessageHandler()
end
function PaGlobal_ExtractionEnchantStone:initialize()
  Panel_Window_Extraction_EnchantStone:SetShow(false, false)
  Panel_Window_Extraction_EnchantStone:setMaskingChild(true)
  Panel_Window_Extraction_EnchantStone:setGlassBackground(true)
  Panel_Window_Extraction_EnchantStone:RegisterShowEventFunc(true, "PaGlobal_ExtractionEnchantStone:showAni()")
  Panel_Window_Extraction_EnchantStone:RegisterShowEventFunc(false, "PaGlobal_ExtractionEnchantStone:hideAni()")
  self._uiButtonApply:addInputEvent("Mouse_LUp", "PaGlobal_ExtractionEnchantStone:applyReady()")
  self._uiButtonApply:SetShow(true)
  self._uiButtonApply:ComputePos()
  self._uiEquipItem.icon = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket")
  self._uiEquipItem.slot_On = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket_EffectOn")
  self._uiEquipItem.slot_Nil = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "Static_Equip_Socket_EffectOff")
  self._uiGuideBG:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._uiGuideBG:setPadding(UI_PD.ePadding_Left, 10)
  self._uiGuideBG:setPadding(UI_PD.ePadding_Right, 10)
  self._uiGuideBG:setPadding(UI_PD.ePadding_Top, 5)
  self._uiGuideBG:setPadding(UI_PD.ePadding_Bottom, 5)
  self._uiGuideBG:SetPosY(self._uiButtonApply:GetPosY() + self._uiButtonApply:GetSizeY() + 20)
  self._uiGuideBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_EXTRACTIONGUIDE"))
  self._uiGuideBG:SetSize(self._uiGuideBG:GetSizeX(), self._uiGuideBG:GetTextSizeY() + 20)
  Panel_Window_Extraction_EnchantStone:SetSize(Panel_Window_Extraction_EnchantStone:GetSizeX(), 51 + self._subbg:GetSizeY() + self._uiGuideBG:GetTextSizeY() + 30)
  SlotItem.new(self._uiEquipItem, "Slot_0", 0, Panel_Window_Extraction_EnchantStone, self._slotConfig)
  self._uiEquipItem:createChild()
  self._uiEquipItem.empty = true
  self._uiEquipItem.icon:addInputEvent("Mouse_RUp", "PaGlobal_ExtractionEnchantStone:handleMRUpEquipSlot( )")
  self._uiIconBlackStoneWeapon:SetShow(false)
  self._uiIconBlackStoneArmor:SetShow(false)
  self._uiTextBlackStoneCount:SetShow(false)
  self._enchantNumber = UI.getChildControl(Panel_Window_Extraction_EnchantStone, "StaticText_Enchant_value")
  self._enchantNumber:SetShow(false)
  CopyBaseProperty(self._enchantNumber, self._uiEquipItem.enchantText)
  self._uiEquipItem.enchantText:SetSize(self._uiEquipItem.icon:GetSizeX(), self._uiEquipItem.icon:GetSizeY())
  self._uiEquipItem.enchantText:SetPosX(0)
  self._uiEquipItem.enchantText:SetPosY(0)
  self._uiEquipItem.enchantText:SetTextHorizonCenter()
  self._uiEquipItem.enchantText:SetTextVerticalCenter()
  self._uiEquipItem.enchantText:SetShow(true)
  self._uiButtonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionEnchantStone\" )")
  self._uiButtonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"true\")")
  self._uiButtonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"false\")")
end
function PaGlobal_ExtractionEnchantStone:clear()
  self._uiEquipItem:clearItem()
  self._uiEquipItem.empty = true
  self._uiButtonApply:EraseAllEffect()
  self._uiButtonApply:SetIgnore(true)
  self._uiButtonApply:SetMonoTone(true)
  self._uiButtonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_BUTTONAPPLY"))
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
function ExtractionEnchantStone_WindowOpen()
  Panel_Window_Extraction_EnchantStone:SetShow(true, true)
  Panel_Window_Extraction_EnchantStone:SetPosY(getScreenSizeY() - getScreenSizeY() / 2 - Panel_Window_Extraction_EnchantStone:GetSizeY() / 2 - 20)
  Panel_Window_Extraction_EnchantStone:SetPosX(getScreenSizeX() - getScreenSizeX() / 2 - Panel_Window_Extraction_EnchantStone:GetSizeX() / 2)
  Inventory_SetFunctor(ExtractionEnchantStone_InvenFiler_MainItem, ExtractionEnchantStone_InteractortionFromInventory, ExtractionEnchantStone_WindowClose, nil)
  InventoryWindow_Show()
  PaGlobal_ExtractionEnchantStone._currentTime = 0
  PaGlobal_ExtractionEnchantStone._doExtracting = false
end
function ExtractionEnchantStone_WindowClose()
  ExtractionEnchant_EffectReset()
  Inventory_SetFunctor(nil)
  Panel_Window_Extraction_EnchantStone:SetShow(false, false)
  PaGlobal_ExtractionEnchantStone:clear()
end
function PaGlobal_ExtractionEnchantStone:getShow()
  return Panel_Window_Extraction_EnchantStone:GetShow()
end
function PaGlobal_ExtractionEnchantStone:getButtonExtractionApply()
  return self._uiButtonApply
end
