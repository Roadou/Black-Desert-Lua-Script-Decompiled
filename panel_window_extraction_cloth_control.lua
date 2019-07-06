function PaGlobal_ExtractionCloth:setExtractionType(_type)
  if 0 == _type then
    self._radioBtnValks:SetCheck(true)
    self._radioBtnCronStone:SetCheck(false)
  else
    self._radioBtnValks:SetCheck(false)
    self._radioBtnCronStone:SetCheck(true)
  end
  if self._equipItem.icon then
    self._textBalksCount:SetText(self.count[_type])
    self:changeIconTexture(_type)
  end
end
function PaGlobal_ExtractionCloth:changeIconTexture(_type)
  local iconPath = ""
  if 0 == _type then
    iconPath = "/icon/new_icon/09_cash/00017643.dds"
  else
    iconPath = "/Icon/New_Icon/03_ETC/00016080.dds"
  end
  self._balks:ChangeTextureInfoName(iconPath)
end
function ExtractionCloth_InvenFiler_MainItem(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemCount = itemWrapper:getStaticStatus():getExtractionCount_s64()
  if nil == itemCount then
    return true
  elseif Int64toInt32(itemCount) <= 0 then
    return true
  else
    return false
  end
end
function ExtractionCloth_InteractortionFromInventory(slotNo, itemWrapper, count_s64, inventoryType)
  local self = PaGlobal_ExtractionCloth
  if 0 < self._currentTime then
    return
  end
  if self._equipItem.icon then
    audioPostEvent_SystemUi(0, 16)
    self._equipItem.icon:AddEffect("UI_Button_Hide", false, 0, 0)
    self._equipItem.slot_On:SetShow(true)
    self._equipItem.slot_Nil:SetShow(false)
    self._effectCircleEff:ResetVertexAni()
    self._effectCircleEff:SetVertexAniRun("Ani_Color_On", true)
    self._effectCircleEff:SetVertexAniRun("Ani_Rotate_New", true)
    self._buttonApply:SetIgnore(false)
    self._buttonApply:SetMonoTone(false)
  end
  self._equipItem.empty = false
  self._extraction_TargetWhereType = inventoryType
  self._extraction_TargetSlotNo = slotNo
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  self._equipItem:setItem(itemWrapper)
  self._equipItem.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"clothExtraction\", true)")
  self._equipItem.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"clothExtraction\", false)")
  Panel_Tooltip_Item_SetPosition(slotNo, self._equipItem, "clothExtraction")
  self._balks:SetShow(true)
  self._balks:SetMonoTone(true)
  self._textBalksCount:SetShow(true)
  local _count = 0
  self.count[0] = Int64toInt32(itemWrapper:getStaticStatus():getExtractionCount_s64())
  self.count[1] = Int64toInt32(itemWrapper:getStaticStatus():getCronCount_s64())
  if self._radioBtnValks:IsCheck() then
    _count = self.count[0]
    self:changeIconTexture(0)
  else
    _count = self.count[1]
    self:changeIconTexture(1)
  end
  self._textBalksCount:SetText(_count)
  Inventory_SetFunctor(ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil)
end
function PaGlobal_ExtractionCloth:handleMRUpEquipSlot()
  self._effectCircleEff:ResetVertexAni()
  self._effectCircleEff:SetVertexAniRun("Ani_Color_Off", true)
  self._effectCircleEff:SetVertexAniRun("Ani_Rotate_New", true)
  self:clear()
  self._equipItem.icon:addInputEvent("Mouse_On", "")
  self._equipItem.icon:addInputEvent("Mouse_Out", "")
  Panel_Tooltip_Item_hideTooltip()
  Inventory_SetFunctor(ExtractionCloth_InvenFiler_MainItem, ExtractionCloth_InteractortionFromInventory, ExtractionCloth_WindowClose, nil)
end
function HandleEventOnOut_ExtractionCloth_CheckButton(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  end
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_TOOLTIP_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_DESC_CAPHRAS")
  TooltipSimple_Show(PaGlobal_ExtractionCloth._chk_AniSkip, name, desc)
end
function PaGlobal_ExtractionCloth:applyReady()
  self._currentTime = 0
  self._doExtracting = false
  local resultItem = ""
  if self._radioBtnValks:IsCheck() then
    resultItem = "<" .. getItemEnchantStaticStatus(ItemEnchantKey(17643)):getName() .. ">"
  else
    resultItem = "<" .. getItemEnchantStaticStatus(ItemEnchantKey(16080)):getName() .. ">"
  end
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_3", "resultItem", resultItem)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "UI_WINDOW_EXTRACTION_CLOTH_TITLE"),
    content = messageContent,
    functionYes = function()
      ExtractionCloth_Success()
      Panel_Window_Extraction_Cloth:RegisterUpdateFunc("ExtractionCloth_CheckTime")
      self._radioBtnValks:SetIgnore(self._doExtracting)
      self._radioBtnCronStone:SetIgnore(self._doExtracting)
      self._isAniSkip = self._chk_AniSkip:IsCheck()
      audioPostEvent_SystemUi(5, 10)
    end,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_ExtractionCloth:registMessageHandler()
  registerEvent("FromClient_ExtractionCloth_Success", "ExtractionCloth_Success")
  registerEvent("FromClient_ExtractItemFromExtractionCount", "ExtractionCloth_SuccessMessage")
end
function ExtractionCloth_SuccessMessage()
  local self = PaGlobal_ExtractionCloth
  self:resultShow()
end
function ExtractionCloth_Success()
  local self = PaGlobal_ExtractionCloth
  FGlobal_ExtractionEffect_Init()
  self._radioBtnValks:SetIgnore(self._doExtracting)
  self._radioBtnCronStone:SetIgnore(self._doExtracting)
  self._extracting_Effect_Step1:EraseAllEffect()
  self._balks:EraseAllEffect()
end
function PaGlobal_ExtractionCloth:successXXX()
  local isValks = self._radioBtnValks:IsCheck()
  self._isValksExtracted = isValks
  ToClient_RequestExtracItemFromExtractionCount(self._extraction_TargetWhereType, self._extraction_TargetSlotNo, isValks)
  self._doExtracting = false
  self._currentTime = 0
  self._radioBtnValks:SetIgnore(self._doExtracting)
  self._radioBtnCronStone:SetIgnore(self._doExtracting)
  self:clear()
  Panel_Window_Extraction_Cloth:ClearUpdateLuaFunc()
end
