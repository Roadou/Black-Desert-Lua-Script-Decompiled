local _mainPanel = Panel_Window_Extract_Renew
local _panel = Panel_Tab_ExtractOutfit_Renew
local isEnableValksCry = ToClient_IsContentsGroupOpen("47")
local isEnableCron = ToClient_IsContentsGroupOpen("74")
local ExtractOutfit = {
  _stc_group = UI.getChildControl(_panel, "Static_OutfitGroup"),
  _stc_output1 = nil,
  _stc_output2 = nil,
  _txt_output1 = nil,
  _txt_output2 = nil,
  _effectCircleEff = nil,
  _textExtractionGuide = nil,
  _equipItem = {},
  _extracting_Effect_Step1 = nil,
  _doExtracting = nil,
  _extraction_TargetWhereType = nil,
  _extraction_TargetSlotNo = nil,
  _currentTime = 0,
  count = {
    [0] = 0,
    [1] = 0
  },
  _isValks = true
}
local self = ExtractOutfit
function FromClient_luaLoadComplete_ExtractOutfit_Init()
  self:initialize()
  local moveTarget = UI.getChildControl(_mainPanel, "Static_OutfitGroup")
  moveTarget:SetShow(false)
  moveTarget:MoveChilds(moveTarget:GetID(), _panel)
  deletePanel(_panel:GetID())
  registerEvent("onScreenResize", "PaGlobal_ExtractOutfit_Resize")
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ExtractOutfit_Init")
function ExtractOutfit:initialize()
  self._stc_output1 = UI.getChildControl(self._stc_group, "Static_OutputSlot1")
  self._stc_output2 = UI.getChildControl(self._stc_group, "Static_OutputSlot2")
  self._txt_output1 = UI.getChildControl(self._stc_output1, "StaticText_OutputCount")
  self._txt_output2 = UI.getChildControl(self._stc_output2, "StaticText_OutputCount")
  local outputSlotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = false
  }
  self._slot_output1 = {}
  SlotItem.new(self._slot_output1, "Output1", 0, self._stc_output1, outputSlotConfig)
  self._slot_output1:createChild()
  local valksItemSSW = getItemEnchantStaticStatus(ItemEnchantKey(17643))
  if nil ~= valksItemSSW then
    self._slot_output1:setItemByStaticStatus(valksItemSSW)
    self._slot_output1.icon:SetMonoTone(true)
    self._txt_output1:SetText(valksItemSSW:getName())
  end
  self._stc_output1:SetShow(false)
  self._slot_output2 = {}
  SlotItem.new(self._slot_output2, "Output2", 0, self._stc_output2, outputSlotConfig)
  self._slot_output2:createChild()
  local croneStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16080))
  self._slot_output2:setItemByStaticStatus(croneStoneSSW)
  self._slot_output2.icon:SetMonoTone(true)
  self._txt_output2:SetText(croneStoneSSW:getName())
  self._stc_output2:SetShow(false)
  self._stc_bg = UI.getChildControl(self._stc_group, "Static_BG")
  self._effectCircleEff = UI.getChildControl(self._stc_bg, "Static_ExtractionSpinEffect")
  self._equipItem.slot_On = UI.getChildControl(self._stc_bg, "Static_Equip_Socket_EffectOn")
  self._equipItem.slot_Nil = UI.getChildControl(self._stc_bg, "Static_Equip_Socket_EffectOff")
  self._equipItem.icon = UI.getChildControl(self._stc_bg, "Static_Equip_Socket")
  self._extracting_Effect_Step1 = UI.getChildControl(self._stc_bg, "Static_ExtractionEffect_Step1")
  self._extracting_Effect_Step2 = UI.getChildControl(self._stc_bg, "Static_ExtractionEffect_Step2")
  local targetSlotConfig = {
    createIcon = false,
    createBorder = false,
    createCount = true,
    createEnchant = true,
    createCash = false
  }
  SlotItem.new(self._equipItem, "TargetSlot", 0, self._stc_bg, targetSlotConfig)
  self._equipItem:createChild()
  self._equipItem:clearItem()
  self._valks = UI.getChildControl(self._stc_bg, "Static_Equip_Result_Socket")
  self._valks:SetMonoTone(true)
  self._valks:SetAlpha(0)
  self._btn_right = UI.getChildControl(self._stc_group, "Button_Right")
  self._btn_left = UI.getChildControl(self._stc_group, "Button_Left")
  self._keyGuideLeft = UI.getChildControl(self._btn_left, "StaticText_KeyGuide")
  self._keyGuideRight = UI.getChildControl(self._btn_right, "StaticText_KeyGuide")
  self:adjustButtonSize()
end
function PaGlobal_ExtractOutfit_Resize()
  ExtractOutfit._extracting_Effect_Step1:ComputePos()
end
function ExtractOutfit:adjustButtonSize()
  local leftSizeX = self._keyGuideLeft:GetTextSizeX() + 44
  local rightSizeX = self._keyGuideRight:GetTextSizeX() + 44
  if leftSizeX < 250 and rightSizeX < 250 then
    return
  end
  local maxSizeX = leftSizeX
  if rightSizeX > maxSizeX then
    maxSizeX = rightSizeX
  end
  local buttonSizeX = maxSizeX + 60
  self._btn_left:SetSize(buttonSizeX, self._btn_left:GetSizeY())
  self._btn_right:SetSize(buttonSizeX, self._btn_right:GetSizeY())
  self._btn_left:SetSpanSize(self._btn_left:GetSpanSize().x, self._btn_left:GetSpanSize().y)
  self._btn_right:SetSpanSize(self._btn_right:GetSpanSize().x, self._btn_right:GetSpanSize().y)
  local leftPosX = (maxSizeX + 5 - leftSizeX) / 2 + 35
  local rightPosX = (maxSizeX + 5 - rightSizeX) / 2 + 20
  self._keyGuideLeft:SetPosX(leftPosX)
  self._keyGuideRight:SetPosX(rightPosX)
end
function PaGlobalFunc_ExtractOutfit_Open()
  self._currentTime = 0
  self._doExtracting = false
  PaGlobalFunc_InventoryInfo_Open(2)
  Inventory_SetFunctor(PaLocalFunc_ExtractOutfit_FilterTarget, PaLocalFunc_ExtractOutfit_rClickTarget, nil, nil)
  if not isEnableCron then
    self._btn_left:SetShow(false)
  end
  if not isEnableValksCry then
    self._btn_right:SetShow(false)
  end
  self._effectCircleEff:SetVertexAniRun("Ani_Rotate_New", true)
  self._effectCircleEff:SetVertexAniRun("Ani_Color_Off", true)
  self._effectCircleEff:SetShow(true)
  PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(true)
end
function PaGlobalFunc_ExtractOutfit_Close()
  self:clear()
end
function PaLocalFunc_ExtractOutfit_FilterTarget(slotNo, itemWrapper)
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
function PaLocalFunc_ExtractOutfit_rClickTarget(slotNo, itemWrapper, count_s64, inventoryType)
  if 0 < self._currentTime then
    return
  end
  if self._equipItem.icon then
    audioPostEvent_SystemUi(0, 16)
    _AudioPostEvent_SystemUiForXBOX(0, 16)
    self._equipItem.icon:AddEffect("UI_Button_Hide", false, 0, 0)
    self._equipItem.slot_On:SetShow(true)
    self._equipItem.slot_Nil:SetShow(false)
    self._effectCircleEff:ResetVertexAni()
    self._effectCircleEff:SetVertexAniRun("Ani_Color_On", true)
    self._effectCircleEff:SetVertexAniRun("Ani_Rotate_New", true)
  end
  self._equipItem.empty = false
  self._extraction_TargetWhereType = inventoryType
  self._extraction_TargetSlotNo = slotNo
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  self._equipItem:setItem(itemWrapper)
  self._equipItem.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"clothExtraction\", true)")
  self._equipItem.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", \"clothExtraction\", false)")
  self.count[0] = Int64toInt32(itemWrapper:getStaticStatus():getExtractionCount_s64())
  self.count[1] = Int64toInt32(itemWrapper:getStaticStatus():getCronCount_s64())
  if 0 < self.count[0] then
    local valksItemSSW = getItemEnchantStaticStatus(ItemEnchantKey(17643))
    if nil ~= valksItemSSW then
      self._stc_output1:SetShow(true)
      self._txt_output1:SetText(valksItemSSW:getName() .. " " .. self.count[0])
    end
  else
    self._stc_output1:SetShow(false)
  end
  if 0 < self.count[1] then
    local croneStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16080))
    if nil ~= croneStoneSSW then
      self._stc_output2:SetShow(true)
      self._txt_output2:SetText(croneStoneSSW:getName() .. " " .. self.count[1])
    end
  else
    self._stc_output2:SetShow(false)
  end
  Inventory_SetFunctor(PaLocalFunc_ExtractOutfit_FilterTarget, PaLocalFunc_ExtractOutfit_rClickTarget, nil, nil)
  ToClient_padSnapSetTargetPanel(_mainPanel)
end
function PaGlobalFunc_ExtractOutfit_OnPadB()
  if true == self._doExtracting then
    return false
  end
  if false == self._equipItem.empty then
    self:clear()
    PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(true)
    Inventory_SetFunctor(PaLocalFunc_ExtractOutfit_FilterTarget, PaLocalFunc_ExtractOutfit_rClickTarget, nil, nil)
    ToClient_padSnapSetTargetPanel(Panel_Window_Inventory)
    return false
  end
  return true
end
function ExtractOutfit:clear()
  self._equipItem:clearItem()
  self._equipItem.empty = true
  self._extraction_TargetWhereType = nil
  self._extraction_TargetSlotNo = nil
  self._equipItem.slot_On:SetShow(false)
  self._equipItem.slot_Nil:SetShow(true)
  self._stc_output1:SetShow(false)
  self._stc_output2:SetShow(false)
  self._valks:SetAlpha(0)
  self._extracting_Effect_Step1:EraseAllEffect()
  self._extracting_Effect_Step2:EraseAllEffect()
  self._valks:EraseAllEffect()
  PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(false)
  getEnchantInformation():ToClient_clearData()
end
function Input_ExtractOutfit_Apply(isValksExtract)
  if not isValksExtract and not isEnableCron then
    return
  end
  if isValksExtract and not isEnableValksCry then
    return
  end
  if true == self._equipItem.empty then
    return
  end
  if true == self._doExtracting then
    return
  end
  local tempFilter = function()
    return true
  end
  Inventory_SetFunctor(tempFilter, tempFilter, nil, nil, nil)
  self._currentTime = 0
  self._doExtracting = false
  self._isValks = isValksExtract
  self:changeIconTexture(isValksExtract)
  local resultItem = ""
  if isValksExtract then
    resultItem = "<" .. getItemEnchantStaticStatus(ItemEnchantKey(17643)):getName() .. ">"
  else
    resultItem = "<" .. getItemEnchantStaticStatus(ItemEnchantKey(16080)):getName() .. ">"
  end
  PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(false)
  local messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_3", "resultItem", resultItem)
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "UI_WINDOW_EXTRACTION_CLOTH_TITLE"),
    content = messageContent,
    functionYes = function()
      PaLocalFunc_ExtractOutfit_Success()
    end,
    functionNo = function()
      PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(true)
    end,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function ExtractOutfit:changeIconTexture(isValksExtract)
  local iconPath = ""
  if isValksExtract then
    iconPath = "/icon/new_icon/09_cash/00017643.dds"
  else
    iconPath = "/Icon/New_Icon/03_ETC/00016080.dds"
  end
  self._valks:ChangeTextureInfoName(iconPath)
end
local extractionEffect = {
  extracting_Effect_Step1 = nil,
  equipItem_Effect = nil,
  cloth_Effect = nil
}
function PaLocalFunc_ExtractOutfit_Success()
  audioPostEvent_SystemUi(5, 10)
  _AudioPostEvent_SystemUiForXBOX(5, 10)
  self._valks:EraseAllEffect()
  UIAni.AlphaAnimation(1, self._valks, 0, 2)
  extractionEffect.extracting_Effect_Step1 = nil
  extractionEffect.equipItem_Effect = nil
  extractionEffect.cloth_Effect = nil
  PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(false)
  self._currentTime = 0
  self._doExtracting = true
  self._extracting_Effect_Step1:EraseAllEffect()
  self._extracting_Effect_Step1:AddEffect("fUI_Dress_Extraction01", false, -0.7, -4.7)
  self._extracting_Effect_Step2:EraseAllEffect()
  extractionEffect.extracting_Effect_Step1 = self._extracting_Effect_Step2:AddEffect("fUI_StoneExtract_SpinSmoke01", false, 0, 0)
end
function PaGlobalFunc_ExtractOutfit_UpdatePerFrame(DeltaTime)
  if self._doExtracting then
    self._currentTime = self._currentTime + DeltaTime
  end
  if self._currentTime >= 1.8 and self._currentTime < 2.3 and true == self._doExtracting then
    self._equipItem:clearItem()
    self._equipItem.slot_On:SetShow(false)
    self._equipItem.slot_Nil:SetShow(true)
  elseif self._currentTime >= 2.3 and self._currentTime < 3 and true == self._doExtracting then
    if nil == extractionEffect.cloth_Effect then
      extractionEffect.cloth_Effect = self._valks:AddEffect("fUI_Dress_Extraction02", false, 0, 4.2)
    end
  elseif self._currentTime >= 3 and self._currentTime < 3.8 and true == self._doExtracting then
    self._valks:SetMonoTone(false)
  elseif self._currentTime >= 3.8 and self._currentTime < 4 and true == self._doExtracting then
    if nil ~= extractionEffect.extracting_Effect_Step1 then
      self._extracting_Effect_Step2:EraseAllEffect()
      extractionEffect.extracting_Effect_Step1 = nil
    end
    if nil ~= extractionEffect.cloth_Effect then
      self._valks:EraseAllEffect()
      extractionEffect.cloth_Effect = nil
    end
    self:successXXX()
  end
end
function ExtractOutfit:successXXX()
  ToClient_RequestExtracItemFromExtractionCount(self._extraction_TargetWhereType, self._extraction_TargetSlotNo, self._isValks)
  local itemSSW
  if true == self._isValks then
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(17643))
  else
    itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(16080))
  end
  if nil ~= itemSSW then
    PaGlobal_ExtractionResult:showResultMessage(itemSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"), itemSSW)
  else
    PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"))
  end
  self._doExtracting = false
  self._currentTime = 0
  self:clear()
  Inventory_SetFunctor(PaLocalFunc_ExtractOutfit_FilterTarget, PaLocalFunc_ExtractOutfit_rClickTarget, nil, nil)
end
function PaGlobalFunc_ExtractOutfit_UpdateKeyGuide(snappedOnMainPanel)
  self._keyGuideLeft:SetMonoTone(not snappedOnMainPanel or false ~= self._equipItem.empty)
  self._keyGuideRight:SetMonoTone(not snappedOnMainPanel or false ~= self._equipItem.empty)
end
