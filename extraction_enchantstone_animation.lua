function PaGlobal_ExtractionEnchantStone:showAni()
  Panel_Window_Extraction_EnchantStone:SetShow(true)
  UIAni.fadeInSCR_Right(Panel_Window_Extraction_EnchantStone)
  UIAni.AlphaAnimation(1, PaGlobal_ExtractionEnchantStone._uiEffectCircle, 0, 0.2)
  self._uiEffectCircle:SetVertexAniRun("Ani_Color_Off", true)
  self._uiEffectCircle:SetVertexAniRun("Ani_Rotate_New", true)
  self._uiEffectCircle:SetShow(true)
end
function PaGlobal_ExtractionEnchantStone:hideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_Window_Extraction_EnchantStone, 0, 0.2)
  aniInfo:SetHideAtEnd(true)
  local aniInfo1 = UIAni.AlphaAnimation(0, self._uiEffectCircle, 0, 0.2)
  aniInfo1:SetHideAtEnd(true)
end
local extractingEffect = {
  _step1 = nil,
  _step2 = nil,
  _step3 = nil,
  _uiEquipItem = nil,
  _blackStoneWeapon = nil,
  _blackStoneArmor = nil
}
function ExtractionEnchant_EffectReset()
  local self = PaGlobal_ExtractionEnchantStone
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
function ExtractionEnchant_CheckTime(DeltaTime)
  local self = PaGlobal_ExtractionEnchantStone
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
local ExtractionEnchantStone_ResultShowTime = 0
function ExtractionEnchantStoneResult_TimerReset()
  ExtractionEnchantStone_ResultShowTime = 0
end
function ExtractionEnchantStone_CheckResultMsgShowTime(DeltaTime)
  ExtractionEnchantStone_ResultShowTime = ExtractionEnchantStone_ResultShowTime + DeltaTime
  if ExtractionEnchantStone_ResultShowTime > 3 and true == Panel_Window_Extraction_Result:GetShow() then
    Panel_Window_Extraction_Result:SetShow(false)
  end
  if ExtractionEnchantStone_ResultShowTime > 5 then
    ExtractionEnchantStone_ResultShowTime = 0
  end
end
function PaGlobal_ExtractionEnchantStone:resultShow()
  PaGlobal_ExtractionResult:resetChildControl()
  PaGlobal_ExtractionResult:resetAnimation()
  if false == PaGlobal_ExtractionResult:getShow() then
    if self._thisIsWeapone then
      local blackStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16001))
      PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_RESULTMSG"), blackStoneSSW:getName(), blackStoneSSW)
    else
      local blackStoneSSW = getItemEnchantStaticStatus(ItemEnchantKey(16002))
      PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_ENCHANTSTONE_RESULTMSG"), blackStoneSSW:getName(), blackStoneSSW)
    end
  end
  ExtractionEnchantStoneResult_TimerReset()
  Panel_Window_Extraction_Result:RegisterUpdateFunc("ExtractionEnchantStone_CheckResultMsgShowTime")
  PaGlobal_TutorialManager:handleExtractionEnchantStoneResultShow()
end
