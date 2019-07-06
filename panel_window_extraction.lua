local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
Panel_Window_Extraction:SetShow(false, false)
Panel_Window_Extraction:setMaskingChild(true)
Panel_Window_Extraction:ActiveMouseEventEffect(true)
Panel_Window_Extraction:RegisterShowEventFunc(true, "ExtractionShowAni()")
Panel_Window_Extraction:RegisterShowEventFunc(false, "ExtractionHideAni()")
function ExtractionShowAni()
end
function ExtractionHideAni()
end
PaGlobal_Extraction = {
  _screenX = nil,
  _screenY = nil,
  _extractionBG = UI.getChildControl(Panel_Window_Extraction, "ExtractionBackGround"),
  _buttonExtraction_EnchantStone = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_EnchantStone"),
  _buttonExtraction_Caphras = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_Caphras"),
  _buttonExtraction_Crystal = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_Crystal"),
  _buttonExtraction_Cloth = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_Cloth"),
  _buttonExtractionExit = UI.getChildControl(Panel_Window_Extraction, "Button_Exit"),
  _buttonExtraction_System = UI.getChildControl(Panel_Window_Extraction, "Button_Extraction_System")
}
function PaGlobal_Extraction:getExtractionButtonEnchantStone()
  return self._buttonExtraction_EnchantStone
end
function PaGlobal_Extraction:getExtractionButtonCaphras()
  return self._buttonExtraction_Caphras
end
function PaGlobal_Extraction:getExtractionButtonCrystal()
  return self._buttonExtraction_Crystal
end
function PaGlobal_Extraction:getExtractionButtonCloth()
  return self._buttonExtraction_Cloth
end
function PaGlobal_Extraction:initialize()
  self._extractionBG:setGlassBackground(true)
  self._extractionBG:SetShow(true)
  self._buttonExtraction_EnchantStone:SetShow(true)
  self._buttonExtraction_Caphras:SetShow(true)
  self._buttonExtraction_Crystal:SetShow(true)
  self._buttonExtraction_System:SetShow(true)
  self._buttonExtractionExit:SetShow(true)
  self._buttonExtraction_System:SetTextMode(__eTextMode_AutoWrap)
  self._buttonExtraction_System:SetText(self._buttonExtraction_System:GetText())
  self._buttonExtraction_EnchantStone:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:button_ExtractionEnchantStone_Click()")
  self._buttonExtraction_Caphras:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:button_ExtractionCaphras_Click()")
  self._buttonExtraction_Crystal:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:button_ExtractionCrystal_Click()")
  self._buttonExtraction_Cloth:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:button_ExtractionCloth_Click()")
  self._buttonExtraction_System:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:button_ExtractionSystem_Click()")
  self._buttonExtractionExit:addInputEvent("Mouse_LUp", "PaGlobal_Extraction:openPanel( false )")
end
registerEvent("onScreenResize", "Extraction_Resize")
function PaGlobal_Extraction:extraction_BtnResize()
  local btnEnchantStoneSizeX = self._buttonExtraction_EnchantStone:GetSizeX() + 23
  local btnEnchantStoneTextPosX = btnEnchantStoneSizeX - btnEnchantStoneSizeX / 2 - self._buttonExtraction_EnchantStone:GetTextSizeX() / 2
  local btnCrystalSizeX = self._buttonExtraction_Crystal:GetSizeX() + 23
  local btnCrystalTextPosX = btnCrystalSizeX - btnCrystalSizeX / 2 - self._buttonExtraction_Crystal:GetTextSizeX() / 2
  local btnClothSizeX = self._buttonExtraction_Cloth:GetSizeX() + 23
  local btnClothTextPosX = btnClothSizeX - btnClothSizeX / 2 - self._buttonExtraction_Cloth:GetTextSizeX() / 2
  local btnExtractionSystemPosX = self._buttonExtraction_System:GetSizeX() + 23
  local btnExtractionSystemTextPosX = btnExtractionSystemPosX - btnExtractionSystemPosX / 2 - self._buttonExtraction_System:GetTextSizeX() / 2
  local btnExitSizeX = self._buttonExtractionExit:GetSizeX() + 23
  local btnExitTextPosX = btnExitSizeX - btnExitSizeX / 2 - self._buttonExtractionExit:GetTextSizeX() / 2
  self._buttonExtraction_EnchantStone:SetTextSpan(btnEnchantStoneTextPosX, 5)
  self._buttonExtraction_Crystal:SetTextSpan(btnCrystalTextPosX, 5)
  self._buttonExtraction_Cloth:SetTextSpan(btnClothTextPosX, 5)
  self._buttonExtraction_System:SetTextSpan(btnExtractionSystemTextPosX, 5)
  self._buttonExtractionExit:SetTextSpan(btnExitTextPosX, 5)
end
function Extraction_Resize()
  local self = PaGlobal_Extraction
  self._screenX = getScreenSizeX()
  self._screenY = getScreenSizeY()
  Panel_Window_Extraction:SetSize(self._screenX, Panel_Window_Extraction:GetSizeY())
  Panel_Window_Extraction:ComputePos()
  self._extractionBG:SetSize(self._screenX, self._extractionBG:GetSizeY())
  self._extractionBG:ComputePos()
  if ToClient_IsContentsGroupOpen("1006") or ToClient_IsContentsGroupOpen("1007") then
    self._buttonExtraction_EnchantStone:ComputePos()
    self._buttonExtraction_Caphras:ComputePos()
    self._buttonExtraction_Crystal:ComputePos()
    self._buttonExtraction_Cloth:ComputePos()
    self._buttonExtraction_System:ComputePos()
    self._buttonExtraction_Cloth:SetShow(true)
  else
    self._buttonExtraction_EnchantStone:SetPosX(getScreenSizeX() / 2 - self._buttonExtraction_EnchantStone:GetSizeX() / 2 - 10)
    self._buttonExtraction_Caphras:SetPosX(getScreenSizeX() / 2 - self._buttonExtraction_Caphras:GetSizeX() / 2 - 10)
    self._buttonExtraction_Crystal:SetPosX(getScreenSizeX() / 2 + self._buttonExtraction_Crystal:GetSizeX() / 2 + 10)
    self._buttonExtraction_System:SetPosX(getScreenSizeX() / 2 + self._buttonExtraction_System:GetSizeX() / 2 + 10)
    self._buttonExtraction_Cloth:SetShow(false)
  end
  if true == _ContentsGroup_ReformStoneExtract then
    self._buttonExtraction_System:SetShow(true)
  else
    self._buttonExtraction_System:SetShow(false)
  end
  if _ContentsGroup_Caphras then
    self._buttonExtraction_Caphras:SetShow(true)
  else
    self._buttonExtraction_Caphras:SetShow(false)
  end
  self._buttonExtractionExit:ComputePos()
  PaGlobal_Extraction:BottomButtonPosition()
  if true == Panel_Equipment:IsShow() then
    Panel_Equipment:SetPosX(10)
    Panel_Equipment:SetPosY(getScreenSizeY() - getScreenSizeY() / 2 - Panel_Equipment:GetSizeY() / 2)
  end
end
function PaGlobal_Extraction:BottomButtonPosition()
  local btnCount = 0
  local btnTable = {}
  btnTable[0] = self._buttonExtraction_EnchantStone
  btnTable[1] = self._buttonExtraction_Caphras
  btnTable[2] = self._buttonExtraction_Crystal
  btnTable[3] = self._buttonExtraction_Cloth
  btnTable[4] = self._buttonExtraction_System
  btnTable[5] = self._buttonExtractionExit
  if self._buttonExtraction_EnchantStone:GetShow() then
    btnCount = btnCount + 1
  end
  if self._buttonExtraction_Caphras:GetShow() then
    btnCount = btnCount + 1
  end
  if self._buttonExtraction_Crystal:GetShow() then
    btnCount = btnCount + 1
  end
  if self._buttonExtraction_Cloth:GetShow() then
    btnCount = btnCount + 1
  end
  if self._buttonExtraction_System:GetShow() then
    btnCount = btnCount + 1
  end
  if self._buttonExtractionExit:GetShow() then
    btnCount = btnCount + 1
  end
  local sizeX = getScreenSizeX()
  local funcButtonCount = btnCount
  local buttonSize = btnTable[0]:GetSizeX()
  local buttonGap = 10
  local startPosX = (sizeX - (buttonSize * funcButtonCount + buttonGap * (funcButtonCount - 1))) / 2
  local posX = 0
  local jindex = 0
  for index = 0, 5 do
    if btnTable[index]:GetShow() then
      posX = startPosX + (buttonSize + buttonGap) * jindex
      jindex = jindex + 1
    end
    btnTable[index]:SetPosX(posX)
  end
end
function PaGlobal_Extraction:togglePanel()
  if false == Panel_Window_Extraction:GetShow() then
    PaGlobal_Extraction:openPanel(true)
  else
    PaGlobal_Extraction:openPanel(false)
  end
end
function PaGlobal_Extraction:openPanel(isShow)
  if true == isShow then
    SetUIMode(Defines.UIMode.eUIMode_Extraction)
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_setIgnoreShowDialog(true)
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      setIgnoreShowDialog(true)
    else
      PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
    end
    UIAni.fadeInSCR_Down(Panel_Window_Extraction)
    if not _ContentsGroup_RenewUI then
      Equipment_PosSaveMemory()
      Panel_Equipment:SetPosX(10)
      Panel_Equipment:SetPosY(getScreenSizeY() - getScreenSizeY() / 2 - Panel_Equipment:GetSizeY() / 2)
    end
  else
    SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
    if true == _ContentsGroup_RenewUI_Dailog then
      PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
    elseif false == _ContentsGroup_NewUI_Dialog_All then
      setIgnoreShowDialog(false)
    else
      PaGlobalFunc_DialogMain_All_SetIgnoreShowDialog(true)
    end
    Socket_ExtractionCrystal_WindowClose()
    ExtractionCloth_WindowClose()
    if false == _ContentsGroup_NewUI_BlackSmith_All then
      PaGlobal_ExtractionCaphras_Close()
      ExtractionEnchantStone_WindowClose()
    else
      PaGlobal_Extraction_Caphras_All_Close()
      PaGlobal_Extraction_Blackstone_All_Close()
    end
    PaGlobal_ExtractionSystem_ForceClose()
    PaGlobal_ExtractionCrystal:clearData()
    InventoryWindow_Close()
    if not _ContentsGroup_RenewUI then
      Equipment_PosLoadMemory()
      Panel_Equipment:SetShow(false, false)
    end
    ClothInventory_Close()
  end
  if true == _ContentsGroup_RenewUI_Dailog then
    if true == isShow then
      PaGlobalFunc_MainDialog_Close()
    else
      PaGlobalFunc_MainDialog_ReOpen()
    end
  elseif false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Dialog:SetShow(not isShow)
  else
    PaGlobalFunc_DialogMain_All_ShowToggle(not isShow)
  end
  Panel_Window_Extraction:SetShow(isShow, false)
  PaGlobal_Extraction:extraction_BtnResize()
  PaGlobal_TutorialManager:handleOpenExtractionPanel(isShow)
  PaGlobal_Extraction:BottomButtonPosition()
end
function PaGlobal_Extraction:button_ExtractionCrystal_Click()
  if false == Panel_Window_Extraction_Crystal:GetShow() then
    ExtractionCloth_WindowClose()
    if false == _ContentsGroup_NewUI_BlackSmith_All then
      PaGlobal_ExtractionCaphras_Close()
      ExtractionEnchantStone_WindowClose()
    else
      PaGlobal_Extraction_Caphras_All_Close()
      PaGlobal_Extraction_Blackstone_All_Close()
    end
    PaGlobal_ExtractionSystem_ForceClose()
    PaGlobal_ExtractionCrystal:show(true)
    Inventory_SetFunctor(Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil)
    InventoryWindow_Show()
    if not _ContentsGroup_RenewUI then
      Panel_Equipment:SetShow(true, true)
    end
  else
    PaGlobal_ExtractionCrystal:show(false)
    InventoryWindow_Close()
    if not _ContentsGroup_RenewUI then
      EquipmentWindow_Close()
    end
  end
  PaGlobal_TutorialManager:handleClickExtractionCrystalButton(Panel_Window_Extraction_Crystal:GetShow())
end
function PaGlobal_Extraction:button_ExtractionCaphras_Click()
  if false == _ContentsGroup_NewUI_BlackSmith_All then
    if nil == Panel_Window_Extraction_Caphras then
      return
    end
    if false == Panel_Window_Extraction_Caphras:GetShow() then
      ExtractionEnchantStone_WindowClose()
      Socket_ExtractionCrystal_WindowClose()
      ExtractionCloth_WindowClose()
      PaGlobal_ExtractionSystem_ForceClose()
      PaGlobal_Extraction_Caphras_Open()
      if not _ContentsGroup_RenewUI then
        Panel_Equipment:SetShow(true, true)
      end
    else
      PaGlobal_ExtractionCaphras_Close()
      InventoryWindow_Close()
      if not _ContentsGroup_RenewUI then
        EquipmentWindow_Close()
      end
    end
    PaGlobal_TutorialManager:handleClickExtractionCaphrasButton(Panel_Window_Extraction_Caphras:GetShow())
  else
    if nil == Panel_Window_Extraction_Caphras_All then
      return
    end
    if false == Panel_Window_Extraction_Caphras_All:GetShow() then
      PaGlobal_Extraction_Blackstone_All_Close()
      Socket_ExtractionCrystal_WindowClose()
      ExtractionCloth_WindowClose()
      PaGlobal_ExtractionSystem_ForceClose()
      InventoryWindow_Close()
      if not _ContentsGroup_RenewUI then
        EquipmentWindow_Close()
      end
      PaGlobal_Extraction_Caphras_All_Open()
    else
      PaGlobal_Extraction_Caphras_All_Close()
    end
    PaGlobal_TutorialManager:handleClickExtractionCaphrasButton(Panel_Window_Extraction_Caphras_All:GetShow())
  end
end
function PaGlobal_Extraction:button_ExtractionEnchantStone_Click()
  if false == _ContentsGroup_NewUI_BlackSmith_All then
    if false == Panel_Window_Extraction_EnchantStone:GetShow() then
      Socket_ExtractionCrystal_WindowClose()
      ExtractionCloth_WindowClose()
      PaGlobal_ExtractionCaphras_Close()
      PaGlobal_ExtractionSystem_ForceClose()
      ExtractionEnchantStone_WindowOpen()
      Panel_Equipment:SetShow(true, true)
    else
      ExtractionEnchantStone_WindowClose()
      InventoryWindow_Close()
      EquipmentWindow_Close()
    end
    PaGlobal_TutorialManager:handleClickExtractionEnchantStoneButton(Panel_Window_Extraction_EnchantStone:GetShow())
  else
    if nil ~= Panel_Window_Extraction_EnchantStone_All and false == Panel_Window_Extraction_EnchantStone_All:GetShow() then
      Socket_ExtractionCrystal_WindowClose()
      ExtractionCloth_WindowClose()
      PaGlobal_Extraction_Caphras_All_Close()
      PaGlobal_ExtractionSystem_ForceClose()
      PaGlobal_Extraction_Blackstone_All_Open()
    else
      PaGlobal_Extraction_Blackstone_All_Close()
      InventoryWindow_Close()
      EquipmentWindow_Close()
    end
    PaGlobal_TutorialManager:handleClickExtractionEnchantStoneButton(Panel_Window_Extraction_EnchantStone_All:GetShow())
  end
end
function PaGlobal_Extraction:button_ExtractionCloth_Click()
  if false == PaGlobal_ExtractionCloth:getShow() then
    Socket_ExtractionCrystal_WindowClose()
    if false == _ContentsGroup_NewUI_BlackSmith_All then
      PaGlobal_ExtractionCaphras_Close()
      ExtractionEnchantStone_WindowClose()
    else
      PaGlobal_Extraction_Caphras_All_Close()
      PaGlobal_Extraction_Blackstone_All_Close()
    end
    PaGlobal_ExtractionSystem_ForceClose()
    ExtractionCloth_WindowOpen()
    Panel_Equipment:SetShow(true, true)
  else
    ExtractionCloth_WindowClose()
    InventoryWindow_Close()
    EquipmentWindow_Close()
  end
  PaGlobal_TutorialManager:handleClickExtractionClothButton(PaGlobal_ExtractionCloth:getShow())
end
function PaGlobal_Extraction:button_ExtractionSystem_Click()
  if false == Panel_Window_ExtractionSystem:GetShow() then
    Socket_ExtractionCrystal_WindowClose()
    if false == _ContentsGroup_NewUI_BlackSmith_All then
      PaGlobal_ExtractionCaphras_Close()
      ExtractionEnchantStone_WindowClose()
    else
      PaGlobal_Extraction_Caphras_All_Close()
      PaGlobal_Extraction_Blackstone_All_Close()
    end
    ExtractionCloth_WindowClose()
    PaGlobal_ExtractionSystem_ForceOpen()
    InventoryWindow_Show()
    Panel_Equipment:SetShow(true, true)
  else
    PaGlobal_ExtractionSystem_ForceClose()
    InventoryWindow_Close()
    EquipmentWindow_Close()
  end
end
PaGlobal_Extraction:initialize()
