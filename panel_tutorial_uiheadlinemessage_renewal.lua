PaGlobal_TutorialUiHeadlineMessage = {
  _ui = {
    _static_BottomBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_BottomBg"),
    _static_StepBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_StepBg")
  },
  _totalCount = 4,
  _defaultSizeBG = int2(0, 0),
  _calculateTextHelfX = 0
}
function PaGlobal_TutorialUiHeadlineMessage:initialize()
  if true == ToClient_isConsole() then
    self._ui._staticText_Desc = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Desc")
  else
    self._ui._static_bubbleGuidePos = UI.getChildControl(self._ui._static_BottomBg, "Static_GuideBubblePos")
    self._ui._static_bubbleGuide = UI.getChildControl(self._ui._static_bubbleGuidePos, "Static_GuideBubble")
    self._ui._staticText_Desc = UI.getChildControl(self._ui._static_bubbleGuide, "StaticText_Desc")
  end
  self._ui._staticText_Key1_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key1_ConsoleUI")
  self._ui._staticText_Key2_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key2_ConsoleUI")
  self._ui._static_Step4_Bg = UI.getChildControl(self._ui._static_StepBg, "Static_Step4_Bg")
  self._ui._static_Step4_FillLine = UI.getChildControl(self._ui._static_Step4_Bg, "Static_FillLine")
  self._ui._static_Step4_Complete1 = UI.getChildControl(self._ui._static_Step4_Bg, "Static_Complete1")
  self._ui._static_Step4_Complete2 = UI.getChildControl(self._ui._static_Step4_Bg, "Static_Complete2")
  self._ui._static_Step4_Complete3 = UI.getChildControl(self._ui._static_Step4_Bg, "Static_Complete3")
  self._ui._static_Step4_Complete4 = UI.getChildControl(self._ui._static_Step4_Bg, "Static_Complete4")
  self._ui._static_Step2_Bg = UI.getChildControl(self._ui._static_StepBg, "Static_Step2_Bg")
  self._ui._static_Step2_Complete1 = UI.getChildControl(self._ui._static_Step2_Bg, "Static_Complete1")
  self._ui._static_Step2_Complete2 = UI.getChildControl(self._ui._static_Step2_Bg, "Static_Complete2")
  self._ui._static_Step2_FillLine = UI.getChildControl(self._ui._static_Step2_Bg, "Static_FillLine")
  self._ui._static_DescBox = UI.getChildControl(self._ui._static_StepBg, "Static_DescBox")
  self._defaultSizeBG = int2(self._ui._static_DescBox:GetSizeX(), self._ui._static_DescBox:GetSizeY())
  self._ui._staticText_Name = UI.getChildControl(self._ui._static_DescBox, "StaticText_Name")
  self._ui._staticText_Command = UI.getChildControl(self._ui._static_DescBox, "StaticText_Command")
  self._calculateTextHelfX = self._ui._staticText_Name:GetSizeX() * 0.5
end
function PaGlobal_TutorialUiHeadlineMessage:setPurposeText(string1, string2)
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(string1, string2)
  end)
end
function PaGlobal_TutorialUiHeadlineMessage:setShow(key, isShow)
  self._ui[key]:SetShow(isShow)
end
function PaGlobal_TutorialUiHeadlineMessage:setAlpha(key, value)
  self._ui[key]:SetAlpha(value)
end
function PaGlobal_TutorialUiHeadlineMessage:addEffect(key, effectName, isLoop, posX, posY)
  self._ui[key]:AddEffect(effectName, isLoop, posX, posY)
end
function PaGlobal_TutorialUiHeadlineMessage:setShowAll(isShow)
  for key, value in pairs(self._ui) do
    value:SetShow(isShow)
  end
end
function PaGlobal_TutorialUiHeadlineMessage:setAlphaAll(value)
  for key, value in pairs(self._ui) do
    value:SetAlpha(value)
  end
end
function PaGlobal_TutorialUiHeadlineMessage:setTextPurposeText(string1, string2)
  self:setPurposeText(string1, string2)
end
function PaGlobal_TutorialUiHeadlineMessage:setSkillText(stepCount, skillName, firstKey, secondKey)
  if nil == stepCount then
    self._ui._staticText_Name:SetShow(false)
    self._ui._staticText_Command:SetShow(false)
    return
  end
  self._ui._staticText_Name:SetText(skillName)
  self._ui._staticText_Name:SetShow(true)
  local controlPos = self._ui["_static_Step" .. self._totalCount .. "_Complete" .. stepCount]
  if nil == controlPos then
    return
  end
  if 4 == self._totalCount then
    self._ui._static_DescBox:SetPosX(controlPos:GetPosX() - 55)
  else
    self._ui._static_DescBox:SetPosX(controlPos:GetPosX() + 150)
  end
  if nil == firstKey then
    self._ui._staticText_Command:SetShow(false)
  end
  if nil == secondKey then
    self._ui._staticText_Command:SetText(firstKey)
  else
    self._ui._staticText_Command:SetText(firstKey .. " + " .. secondKey)
  end
  self:resizeBackground(self._ui._static_DescBox, self._ui._staticText_Name, self._ui._staticText_Command)
end
function PaGlobal_TutorialUiHeadlineMessage:computePosAll()
  for key, value in pairs(self._ui) do
    value:ComputePos()
  end
end
function PaGlobal_TutorialUiHeadlineMessage:resetShowAll()
  self:computePosAll()
  self:setShowAll(true)
  self._ui._static_Step4_Bg:SetShow(false)
  self._ui._static_Step4_FillLine:SetSize(0, self._ui._static_Step4_FillLine:GetSizeY())
  self._ui._static_Step4_Complete1:SetShow(false)
  self._ui._static_Step4_Complete2:SetShow(false)
  self._ui._static_Step4_Complete3:SetShow(false)
  self._ui._static_Step4_Complete4:SetShow(false)
  self._ui._static_Step2_Bg:SetShow(false)
  self._ui._static_Step2_Complete1:SetShow(false)
  self._ui._static_Step2_Complete2:SetShow(false)
end
function PaGlobal_TutorialUiHeadlineMessage:addClearStepEffect(clearCount)
  local nextStepCount = clearCount + 1
  local controlPos = self._ui["_static_Step" .. self._totalCount .. "_Complete" .. nextStepCount]
  if nil ~= controlPos then
    controlPos:SetShow(true)
    controlPos:AddEffect("fUI_Light", false, 0, 0)
  end
  local barLength = clearCount - 1
  if barLength > 0 then
    self._ui["_static_Step" .. self._totalCount .. "_FillLine"]:SetSize(barLength * (163 + self._ui._static_Step4_Complete1:GetSizeX()), self._ui._static_Step4_FillLine:GetSizeY())
  end
end
function PaGlobal_TutorialUiHeadlineMessage:resetClearStepEffect(is2Step)
  self:computePosAll()
  self:setShowAll(true)
  self._ui._static_Step4_Complete1:EraseAllEffect()
  self._ui._static_Step4_Complete2:EraseAllEffect()
  self._ui._static_Step4_Complete3:EraseAllEffect()
  self._ui._static_Step4_Complete4:EraseAllEffect()
  self._ui._static_Step4_Bg:SetShow(false)
  self._ui._static_Step4_Complete1:SetShow(false)
  self._ui._static_Step4_Complete2:SetShow(false)
  self._ui._static_Step4_Complete3:SetShow(false)
  self._ui._static_Step4_Complete4:SetShow(false)
  self._ui._static_Step4_FillLine:SetSize(0, self._ui._static_Step4_FillLine:GetSizeY())
  self._ui._static_Step2_Complete1:EraseAllEffect()
  self._ui._static_Step2_Complete2:EraseAllEffect()
  self._ui._static_Step2_Bg:SetShow(false)
  self._ui._static_Step2_Complete1:SetShow(false)
  self._ui._static_Step2_Complete2:SetShow(false)
  self._ui._static_Step2_FillLine:SetSize(0, self._ui._static_Step2_FillLine:GetSizeY())
  if nil == is2Step then
    self._totalCount = 4
    self._ui._static_Step4_Bg:SetShow(true)
    self._ui._static_Step4_Complete1:SetShow(true)
  else
    self._totalCount = 2
    self._ui._static_Step2_Bg:SetShow(true)
    self._ui._static_Step2_Complete1:SetShow(true)
  end
end
function PaGlobal_TutorialUiHeadlineMessage:resizeBackground(uiBackground, uiTextName, uiTextCommand)
  local sizeName = uiTextName:GetTextSizeX()
  local sizeCommand = uiTextCommand:GetTextSizeX()
  local maxSize = 0
  if sizeName < sizeCommand then
    maxSize = sizeCommand
  else
    maxSize = sizeName
  end
  maxSize = maxSize + 50
  if maxSize < self._defaultSizeBG.x then
    maxSize = self._defaultSizeBG.x
  end
  uiBackground:SetSize(maxSize, self._defaultSizeBG.y)
  local posX = maxSize * 0.5 - self._calculateTextHelfX
  uiTextName:SetPosX(posX)
  uiTextCommand:SetPosX(posX)
end
PaGlobal_TutorialUiHeadlineMessage:initialize()
