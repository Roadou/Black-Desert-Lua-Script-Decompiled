local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local isEnableCron = ToClient_IsContentsGroupOpen("74")
PaGlobal_ExtractionCloth = {
  _currentTime = 0,
  _slotConfig = {
    createIcon = false,
    createBorder = false,
    createCount = true,
    createEnchant = true,
    createCash = false
  },
  _buttonApply = UI.getChildControl(Panel_Window_Extraction_Cloth, "Button_ExtractionCloth"),
  _effectCircleEff = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_ExtractionSpinEffect"),
  _textExtractionGuide = UI.getChildControl(Panel_Window_Extraction_Cloth, "StaticText_ExtractionGuide"),
  _equipItem = {},
  _extracting_Effect_Step1 = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_ExtractionEffect_Step1"),
  _balks = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_Balks"),
  _textBalksCount = UI.getChildControl(Panel_Window_Extraction_Cloth, "StaticText_Balks_Count"),
  _radioBtnValks = UI.getChildControl(Panel_Window_Extraction_Cloth, "RadioButton_Valks"),
  _radioBtnCronStone = UI.getChildControl(Panel_Window_Extraction_Cloth, "RadioButton_CronStrone"),
  _buttonQuestion = UI.getChildControl(Panel_Window_Extraction_Cloth, "Button_Question"),
  _chk_AniSkip = UI.getChildControl(Panel_Window_Extraction_Cloth, "CheckButton_AniSkip"),
  _doExtracting = false,
  _extraction_TargetWhereType = nil,
  _extraction_TargetSlotNo = nil,
  _isValksExtracted = nil,
  count = {
    [0] = 0,
    [1] = 0
  },
  _isAniSkip = false
}
registerEvent("FromClient_luaLoadComplete", "LoadComplete_ExtractionCloth_Initialize")
function LoadComplete_ExtractionCloth_Initialize()
  PaGlobal_ExtractionCloth:initialize()
  PaGlobal_ExtractionCloth:clear()
  PaGlobal_ExtractionCloth:registMessageHandler()
end
function PaGlobal_ExtractionCloth:initialize()
  Panel_Window_Extraction_Cloth:SetShow(false, false)
  Panel_Window_Extraction_Cloth:setMaskingChild(true)
  Panel_Window_Extraction_Cloth:setGlassBackground(true)
  Panel_Window_Extraction_Cloth:RegisterShowEventFunc(true, "PaGlobal_ExtractionCloth:showAni()")
  Panel_Window_Extraction_Cloth:RegisterShowEventFunc(false, "PaGlobal_ExtractionCloth:hideAni()")
  self._buttonApply:addInputEvent("Mouse_LUp", "PaGlobal_ExtractionCloth:applyReady()")
  self._buttonApply:SetShow(true)
  self._equipItem.icon = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_Equip_Socket")
  self._equipItem.slot_On = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_Equip_Socket_EffectOn")
  self._equipItem.slot_Nil = UI.getChildControl(Panel_Window_Extraction_Cloth, "Static_Equip_Socket_EffectOff")
  self._textExtractionGuide:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._textExtractionGuide:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_1"))
  SlotItem.new(self._equipItem, "Slot_0", 0, Panel_Window_Extraction_Cloth, self._slotConfig)
  self._equipItem:createChild()
  self._equipItem.empty = true
  self._equipItem.icon:addInputEvent("Mouse_RUp", "PaGlobal_ExtractionCloth:handleMRUpEquipSlot()")
  self._balks:SetShow(false)
  self._textBalksCount:SetShow(false)
  self._enchantNumber = UI.getChildControl(Panel_Window_Extraction_Cloth, "StaticText_Enchant_value")
  self._enchantNumber:SetShow(false)
  self._radioBtnValks:addInputEvent("Mouse_LUp", "PaGlobal_ExtractionCloth:setExtractionType(" .. 0 .. ")")
  self._radioBtnCronStone:addInputEvent("Mouse_LUp", "PaGlobal_ExtractionCloth:setExtractionType(" .. 1 .. ")")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelWindowExtractionEnchantStone\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelWindowExtractionEnchantStone\", \"false\")")
  self._chk_AniSkip:SetShow(true)
  self._chk_AniSkip:SetCheck(false)
  self._chk_AniSkip:SetEnableArea(0, 0, self._chk_AniSkip:GetTextSizeX() + 20, 20)
  self._chk_AniSkip:addInputEvent("Mouse_On", "HandleEventOnOut_ExtractionCloth_CheckButton(true)")
  self._chk_AniSkip:addInputEvent("Mouse_Out", "HandleEventOnOut_ExtractionCloth_CheckButton(false)")
  self._isAniSkip = false
end
function PaGlobal_ExtractionCloth:clear()
  self._equipItem:clearItem()
  self._equipItem.empty = true
  self._buttonApply:EraseAllEffect()
  self._buttonApply:SetIgnore(true)
  self._buttonApply:SetMonoTone(true)
  self._buttonApply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_BUTTONAPPLY"))
  self._balks:SetShow(false)
  self._balks:SetMonoTone(true)
  self._textBalksCount:SetShow(false)
  self._textBalksCount:SetText(0)
  self._equipItem.slot_On:SetShow(false)
  self._equipItem.slot_Nil:SetShow(true)
  getEnchantInformation():ToClient_clearData()
end
function ExtractionCloth_WindowOpen()
  local self = PaGlobal_ExtractionCloth
  Panel_Window_Extraction_Cloth:SetShow(true, true)
  Panel_Window_Extraction_Cloth:SetPosY(getScreenSizeY() - getScreenSizeY() / 2 - Panel_Window_Extraction_Cloth:GetSizeY() / 2 - 20)
  Panel_Window_Extraction_Cloth:SetPosX(getScreenSizeX() - getScreenSizeX() / 2 - Panel_Window_Extraction_Cloth:GetSizeX() / 2)
  Inventory_SetFunctor(ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil)
  InventoryWindow_Show()
  self:clear()
  self._currentTime = 0
  self._doExtracting = false
  self:setExtractionType(0)
  self.count[0] = 0
  self.count[1] = 0
  if not isEnableCron then
    self._radioBtnCronStone:SetShow(false)
  end
  self._radioBtnValks:SetIgnore(self._doExtracting)
  self._radioBtnCronStone:SetIgnore(self._doExtracting)
end
function ExtractionCloth_WindowClose()
  local self = PaGlobal_ExtractionCloth
  self._doExtracting = false
  self:clear()
  self._currentTime = 0
  self.count[0] = 0
  self.count[1] = 0
  Inventory_SetFunctor(nil)
  Panel_Window_Extraction_Cloth:SetShow(false, false)
end
function PaGlobal_ExtractionCloth:getShow()
  return Panel_Window_Extraction_Cloth:GetShow()
end
