local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
PaGlobal_ExtractionResult = {
  _uiResultMsgBG = UI.getChildControl(Panel_Window_Extraction_Result, "Static_Finish"),
  _uiSlot = {},
  _uiSlotBG = {}
}
function PaGlobal_ExtractionResult:initialize()
  self._uiSlotBG[1] = UI.getChildControl(self._uiResultMsgBG, "Static_ItemSlot1")
  self._uiSlotBG[2] = UI.getChildControl(self._uiResultMsgBG, "Static_ItemSlot2")
  self._uiSlotBG[3] = UI.getChildControl(self._uiResultMsgBG, "Static_ItemSlot3")
  self._uiSubText = UI.getChildControl(self._uiResultMsgBG, "StaticText_Upper")
  self._uiMainText = UI.getChildControl(self._uiResultMsgBG, "StaticText_Lower")
  local slotConfig = {createBorder = true, createEnchant = true}
  for i = 1, 3 do
    if nil == self._uiSlot[i] then
      self._uiSlot[i] = {}
      SlotItem.new(self._uiSlot[i], "SlotItem", 0, self._uiSlotBG[i], slotConfig)
      self._uiSlot[i]:createChild()
      self._uiSlot[i]:clearItem()
    end
  end
  self:resetPanel()
  self:resetChildControl()
  self:resetAnimation()
end
function PaGlobal_ExtractionResult:resetPanel()
  Panel_Window_Extraction_Result:SetSize(getScreenSizeX(), getScreenSizeY())
  Panel_Window_Extraction_Result:SetPosX(0)
  Panel_Window_Extraction_Result:SetPosY(0)
  Panel_Window_Extraction_Result:SetColor(UI_color.C_FFFFFFFF)
  Panel_Window_Extraction_Result:SetIgnore(true)
  Panel_Window_Extraction_Result:SetShow(false)
end
function PaGlobal_ExtractionResult:resetChildControl()
  self._uiResultMsgBG:SetSize(getScreenSizeX(), 150)
  self._uiResultMsgBG:ComputePos()
  self._uiSlotBG[1]:ComputePos()
  self._uiSlotBG[2]:ComputePos()
  self._uiSlotBG[3]:ComputePos()
  self._uiSubText:ComputePos()
  self._uiMainText:ComputePos()
end
function PaGlobal_ExtractionResult:resetAnimation()
  self._uiResultMsgBG:ResetVertexAni()
  Panel_Window_Extraction_Result:ResetVertexAni()
  Panel_Window_Extraction_Result:SetAlphaExtraChild(1)
end
function PaGlobal_ExtractionResult:getShow()
  return Panel_Window_Extraction_Result:GetShow()
end
function PaGlobal_ExtractionResult:showResultMessage(mainText, subText, itemSSW_1, itemSSW_2, itemSSW_3, isEnchantKey)
  if nil == mainText or "string" ~= type(mainText) then
    return
  end
  if nil == subText then
    self._uiResultMsgBG:SetSize(getScreenSizeX(), 110)
    self._uiSlotBG[1]:SetShow(false)
    self._uiSlotBG[2]:SetShow(false)
    self._uiSlotBG[3]:SetShow(false)
    self._uiSubText:SetShow(false)
    self._uiMainText:SetShow(true)
    self._uiMainText:SetText(mainText)
    self._uiMainText:SetPosY(self._uiResultMsgBG:GetSizeY() * 0.5 - self._uiMainText:GetTextSizeY() * 0.5)
  elseif nil == itemSSW_1 then
    self._uiResultMsgBG:SetSize(getScreenSizeX(), 130)
    self._uiSlotBG[1]:SetShow(false)
    self._uiSlotBG[2]:SetShow(false)
    self._uiSlotBG[3]:SetShow(false)
    self._uiSubText:SetShow(true)
    self._uiSubText:SetText(subText)
    self._uiSubText:SetPosY(self._uiResultMsgBG:GetSizeY() * 0.36 - self._uiSubText:GetTextSizeY() * 0.5)
    self._uiMainText:SetShow(true)
    self._uiMainText:SetText(mainText)
    self._uiMainText:SetPosY(self._uiResultMsgBG:GetSizeY() * 0.6 - self._uiMainText:GetTextSizeY() * 0.5)
  else
    self._uiResultMsgBG:SetSize(getScreenSizeX(), 190)
    self._uiSlotBG[1]:SetShow(true)
    self._uiSlotBG[2]:SetShow(false)
    self._uiSlotBG[3]:SetShow(false)
    if true == isEnchantKey then
      ssw = getItemEnchantStaticStatus(itemSSW_1)
      self._uiSlot[1]:setItemByStaticStatus(ssw)
      if nil ~= itemSSW_2 then
        ssw = getItemEnchantStaticStatus(itemSSW_2)
        self._uiSlot[2]:setItemByStaticStatus(ssw)
      end
      if nil ~= itemSSW_3 then
        ssw = getItemEnchantStaticStatus(itemSSW_3)
        self._uiSlot[3]:setItemByStaticStatus(ssw)
      end
    else
      self._uiSlot[1]:setItemByStaticStatus(itemSSW_1)
      if nil ~= itemSSW_2 then
        self._uiSlot[2]:setItemByStaticStatus(itemSSW_2)
      end
      if nil ~= itemSSW_3 then
        self._uiSlot[3]:setItemByStaticStatus(itemSSW_3)
      end
    end
    if nil == itemSSW_2 then
      self._uiSlotBG[1]:SetSpanSize(0, -40)
    elseif nil == itemSSW_3 then
      self._uiSlotBG[1]:SetSpanSize(-25, -40)
      self._uiSlotBG[2]:SetSpanSize(25, -40)
      self._uiSlotBG[2]:SetShow(true)
    else
      self._uiSlotBG[1]:SetSpanSize(-50, -40)
      self._uiSlotBG[2]:SetSpanSize(0, -40)
      self._uiSlotBG[2]:SetSpanSize(50, -40)
      self._uiSlotBG[2]:SetShow(true)
      self._uiSlotBG[3]:SetShow(true)
    end
    self._uiSlotBG[1]:ComputePos()
    self._uiSlotBG[2]:ComputePos()
    self._uiSlotBG[3]:ComputePos()
    self._uiSubText:SetShow(true)
    self._uiSubText:SetText(subText)
    self._uiSubText:ComputePos()
    self._uiMainText:SetShow(true)
    self._uiMainText:SetText(mainText)
    self._uiMainText:ComputePos()
  end
  Panel_Window_Extraction_Result:SetShow(true)
  Panel_Window_Extraction_Result:ResetVertexAni()
  Panel_Window_Extraction_Result:SetAlphaExtraChild(1)
  local ImageAni = Panel_Window_Extraction_Result:addColorAnimation(1.5, 3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  ImageAni:SetStartColor(UI_color.C_FFFFFFFF)
  ImageAni:SetEndColor(UI_color.C_00FFFFFF)
  ImageAni:SetHideAtEnd(true)
  ImageAni.IsChangeChild = true
end
function PaGlobal_ExtractionResult:setHide()
  Panel_Window_Extraction_Result:SetShow(false)
end
function PaGlobal_ExtractionResult_Resize()
  PaGlobal_ExtractionResult:initialize()
end
function PaGlobal_ExtractionResult:registMessageHandler()
  registerEvent("onScreenResize", "PaGlobal_ExtractionResult_Resize")
end
PaGlobal_ExtractionResult:initialize()
PaGlobal_ExtractionResult:registMessageHandler()
