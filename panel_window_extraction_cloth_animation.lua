function PaGlobal_ExtractionCloth:showAni()
  Panel_Window_Extraction_Cloth:SetShow(true)
  UIAni.fadeInSCR_Right(Panel_Window_Extraction_Cloth)
  UIAni.AlphaAnimation(1, self._effectCircleEff, 0, 0.2)
  self._effectCircleEff:SetVertexAniRun("Ani_Rotate_New", true)
  self._effectCircleEff:SetVertexAniRun("Ani_Color_Off", true)
  self._effectCircleEff:SetShow(true)
end
function PaGlobal_ExtractionCloth:hideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_Extraction_Cloth, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
  local aniInfo1 = UIAni.AlphaAnimation(0, self._effectCircleEff, 0, 0.2)
  aniInfo1:SetHideAtEnd(true)
end
local extractionEffect = {
  extracting_Effect_Step1 = nil,
  equipItem_Effect = nil,
  cloth_Effect = nil
}
function ExtractionCloth_CheckTime(DeltaTime)
  local self = PaGlobal_ExtractionCloth
  if true == self._isAniSkip then
    self:successXXX()
    return
  end
  if self._doExtracting then
    self._currentTime = self._currentTime + DeltaTime
  end
  if self._currentTime > 0 and self._currentTime < 1 and true == self._doExtracting then
    self._extracting_Effect_Step1:SetShow(true)
    if nil == extractionEffect.extracting_Effect_Step1 then
      extractionEffect.extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("fUI_Dress_Extraction01", false, -0.7, -4.7)
      extractionEffect.extracting_Effect_Step1 = self._extracting_Effect_Step1:AddEffect("fUI_StoneExtract_SpinSmoke01", false, 0, 0)
    end
  elseif self._currentTime >= 1 and self._currentTime < 1.8 and true == self._doExtracting then
    self._extracting_Effect_Step1:SetShow(true)
  elseif self._currentTime >= 1.8 and self._currentTime < 2.3 and true == self._doExtracting then
    if nil ~= extractionEffect.equipItem_Effect then
      self._equipItem.icon:EraseEffect(extractionEffect.equipItem_Effect)
    end
    self._equipItem:clearItem()
    self._equipItem.slot_On:SetShow(false)
    self._equipItem.slot_Nil:SetShow(true)
    self._extracting_Effect_Step1:SetShow(true)
  elseif self._currentTime >= 2.3 and self._currentTime < 3 and true == self._doExtracting then
    self._extracting_Effect_Step1:SetShow(true)
    if nil == extractionEffect.cloth_Effect then
      extractionEffect.cloth_Effect = self._balks:AddEffect("fUI_Dress_Extraction02", false, 0, 4.2)
    end
  elseif self._currentTime >= 3 and self._currentTime < 3.8 and true == self._doExtracting then
    self._balks:SetMonoTone(false)
  elseif self._currentTime >= 3.8 and self._currentTime < 4 and true == self._doExtracting then
    if nil ~= extractionEffect.extracting_Effect_Step1 then
      self._extracting_Effect_Step1:EraseEffect(extractionEffect.extracting_Effect_Step1)
      extractionEffect.extracting_Effect_Step1 = nil
    end
    if nil ~= extractionEffect.cloth_Effect then
      self._balks:EraseEffect(extractionEffect.cloth_Effect)
      extractionEffect.cloth_Effect = nil
    end
    self:successXXX()
  end
end
local ExtractionCloth_ResultShowTime = 0
function ExtractionClothResult_TimerReset()
  ExtractionCloth_ResultShowTime = 0
end
function ExtractionCloth_CheckResultMsgShowTime(DeltaTime)
  ExtractionCloth_ResultShowTime = ExtractionCloth_ResultShowTime + DeltaTime
  if ExtractionCloth_ResultShowTime > 3 and true == Panel_Window_Extraction_Result:GetShow() then
    Panel_Window_Extraction_Result:SetShow(false)
  end
  if ExtractionCloth_ResultShowTime > 5 then
    ExtractionClothResult_TimerReset()
  end
end
function PaGlobal_ExtractionCloth:resultShow()
  PaGlobal_ExtractionResult:resetChildControl()
  PaGlobal_ExtractionResult:resetAnimation()
  if false == PaGlobal_ExtractionResult:getShow() then
    if true == self._isValksExtracted then
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(17643))
      if nil ~= itemSSW then
        PaGlobal_ExtractionResult:showResultMessage(itemSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"), itemSSW)
      else
        PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"))
      end
    else
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(16080))
      if nil ~= itemSSW then
        PaGlobal_ExtractionResult:showResultMessage(itemSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"), itemSSW)
      else
        PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CLOTH_2"))
      end
    end
  end
  ExtractionClothResult_TimerReset()
  Panel_Window_Extraction_Result:RegisterUpdateFunc("ExtractionCloth_CheckResultMsgShowTime")
end
function FGlobal_ExtractionEffect_Init()
  local self = PaGlobal_ExtractionCloth
  self._currentTime = 0
  self._doExtracting = true
  extractionEffect.extracting_Effect_Step1 = nil
  extractionEffect.equipItem_Effect = nil
  extractionEffect.cloth_Effect = nil
end
