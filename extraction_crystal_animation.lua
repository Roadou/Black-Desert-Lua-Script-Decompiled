function PaGlobal_ExtractionCrystal:resultShow()
  PaGlobal_ExtractionResult:resetChildControl()
  PaGlobal_ExtractionResult:resetAnimation()
  if false == PaGlobal_ExtractionResult:getShow() then
    if 0 == self._extractionType then
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._crystalKeys[self._indexSocket]))
      if nil ~= itemSSW then
        PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT_DONE"), itemSSW:getName(), itemSSW)
      else
        PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT_DONE"))
      end
    else
      PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_REMOVE_DONE"))
    end
  end
  ExtractionCrystalResult_TimerReset()
  Panel_Window_Extraction_Result:RegisterUpdateFunc("ExtractionCrystal_CheckResultMsgShowTime")
end
local ExtractionCrystal_ResultShowTime = 0
function ExtractionCrystalResult_TimerReset()
  ExtractionCrystal_ResultShowTime = 0
end
function ExtractionCrystal_CheckResultMsgShowTime(DeltaTime)
  ExtractionCrystal_ResultShowTime = ExtractionCrystal_ResultShowTime + DeltaTime
  if ExtractionCrystal_ResultShowTime > 3 and true == Panel_Window_Extraction_Result:GetShow() then
    Panel_Window_Extraction_Result:SetShow(false)
  end
  if ExtractionCrystal_ResultShowTime > 5 then
    ExtractionCrystal_ResultShowTime = 0
  end
end
