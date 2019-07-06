PaGlobal_TutorialUiSmallBlackSpirit = {
  _ui = {
    _obsidian = UI.getChildControl(Panel_Tutorial_Renew, "Static_Obsidian"),
    _obsidian_B = UI.getChildControl(Panel_Tutorial_Renew, "Static_Obsidian_B"),
    _obsidian_B_Left = UI.getChildControl(Panel_Tutorial_Renew, "Static_Obsidian_B_Left"),
    _obsidian_Text = UI.getChildControl(Panel_Tutorial_Renew, "StaticText_Obsidian_B"),
    _obsidian_Text_2 = UI.getChildControl(Panel_Tutorial_Renew, "StaticText_Obsidian_B_2")
  }
}
function PaGlobal_TutorialUiSmallBlackSpirit:initialize()
  self._ui._obsidian_B:SetIgnore(true)
  self._ui._obsidian_B_Left:SetIgnore(true)
  self._ui._obsidian_B:SetColor(Defines.Color.C_FF000000)
  self._ui._obsidian_B_Left:SetColor(Defines.Color.C_FF000000)
  self._ui._obsidian_B:addInputEvent("Mouse_LUp", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLUpBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_LDown", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLDownBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_On", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOnBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_Out", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOutBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_LUp", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLUpBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_LDown", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLDownBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_On", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOnBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_Out", "PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOutBubble()")
end
function PaGlobal_TutorialUiSmallBlackSpirit:addEffectBlackSpirit(effectName, isLoop, posX, posY)
  if false == self._enabledEffect then
    self._enabledEffect = true
    self:addEffect("_obsidian", effectName, isLoop, posX, posY)
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:eraseEffectBlackSpirit()
  self._enabledEffect = false
  self:eraseEffect("_obsidian")
end
function PaGlobal_TutorialUiSmallBlackSpirit:resetPosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  self._ui._obsidian:SetPosX(scrX * 0.5 - 20)
  self._ui._obsidian:SetPosY(scrY * 0.5 - 300)
  self._ui._obsidian_B:SetPosX(scrX * 0.5 + 50)
  self._ui._obsidian_B:SetPosY(scrY * 0.5 - 250)
  self._ui._obsidian_Text:SetPosX(scrX * 0.5 + 53)
  self._ui._obsidian_Text:SetPosY(scrY * 0.5 - 225)
  self._ui._obsidian_Text_2:SetPosX(scrX * 0.5 + 53)
end
function PaGlobal_TutorialUiSmallBlackSpirit:resetSpiritUiForTutorial()
  self:resetPosition()
  PaGlobal_TutorialUiManager:getUiBlackSpirit():addEffectBlackSpirit("fUI_DarkSpirit_Tutorial", true, 0, 0)
end
function PaGlobal_TutorialUiSmallBlackSpirit:setShowBlackSpirit(isShow)
  self:setShow("_obsidian", isShow)
end
function PaGlobal_TutorialUiSmallBlackSpirit:setSpiritUiForTutorial(text1, text2, isLeftSideBubble, spiritPosX, spiritPosY, isIgnore)
  self:resetSpiritUiForTutorial()
  self._ui._obsidian:SetShow(true)
  self._ui._obsidian_B:ResetVertexAni()
  self._ui._obsidian_B:SetVertexAniRun("Ani_Color_Out", true)
  self._ui._obsidian_B_Left:ResetVertexAni()
  self._ui._obsidian_B_Left:SetVertexAniRun("Ani_Color_Out", true)
  if nil == text1 and nil == text2 then
    self._ui._obsidian_B:SetShow(false)
    self._ui._obsidian_B_Left:SetShow(false)
  else
    self._ui._obsidian_B:SetShow(not isLeftSideBubble)
    self._ui._obsidian_B_Left:SetShow(isLeftSideBubble)
  end
  local multiplyOneOrZero = 0
  local obsidian_B
  if true == isLeftSideBubble then
    obsidian_B = self._ui._obsidian_B_Left
    multiplyOneOrZero = 0
  elseif false == isLeftSideBubble then
    obsidian_B = self._ui._obsidian_B
    multiplyOneOrZero = 1
  end
  self._ui._obsidian_Text:SetShow(nil ~= text1)
  self._ui._obsidian_Text_2:SetShow(nil ~= text2)
  if nil == text1 then
    self._ui._obsidian_Text:SetText("")
  else
    self._ui._obsidian_Text:SetText(text1)
  end
  if nil == text2 then
    self._ui._obsidian_Text_2:SetText("")
  else
    self._ui._obsidian_Text_2:SetText(text2)
  end
  local text1SizeX = self._ui._obsidian_Text:GetTextSizeX()
  local text1SizeY = self._ui._obsidian_Text:GetTextSizeY()
  local text2SizeX = self._ui._obsidian_Text_2:GetTextSizeX()
  local text2SizeY = self._ui._obsidian_Text_2:GetTextSizeY()
  local largerTextSizeX, largerTextSizeY
  if text1SizeX <= text2SizeX then
    largerTextSizeX = text2SizeX
  else
    largerTextSizeX = text1SizeX
  end
  if text1SizeY <= text2SizeY then
    largerTextSizeY = text2SizeY
  else
    largerTextSizeY = text1SizeY
  end
  local obsidianB_widthMargin = 30
  local obsidianB_heightMargin = 50
  obsidian_B:SetSize(largerTextSizeX + obsidianB_widthMargin, text1SizeY + text2SizeY + obsidianB_heightMargin)
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  local obsidianB_PosXMargin = 40
  local obsidianB_PosYMargin = 40
  local screenCorner_PosXMargin = 20
  local screenCorner_PosYMargin = 20
  local isLeftCulledWhenLeftSideBubble = 0 > spiritPosX - obsidian_B:GetSizeX() - obsidianB_PosXMargin - screenCorner_PosXMargin
  local isRightCulledWhenLeftSideBubble = scrX < spiritPosX + self._ui._obsidian:GetSizeX() + screenCorner_PosXMargin
  local isLeftCulledWhenRightSideBubble = spiritPosX - screenCorner_PosXMargin < 0
  local isRightCulledWhenRightSideBubble = scrX < spiritPosX + self._ui._obsidian:GetSizeX() + obsidianB_PosXMargin + obsidian_B:GetSizeX() + screenCorner_PosXMargin
  local fixedSpiritPosX = 0
  if true == isLeftSideBubble then
    if isLeftCulledWhenLeftSideBubble then
      fixedSpiritPosX = obsidian_B:GetSizeX() + obsidianB_PosXMargin + screenCorner_PosXMargin
    elseif isRightCulledWhenLeftSideBubble then
      fixedSpiritPosX = scrX - self._ui._obsidian:GetSizeX() - screenCorner_PosXMargin
    else
      fixedSpiritPosX = spiritPosX
    end
  elseif false == isLeftSideBubble then
    if isLeftCulledWhenRightSideBubble then
      fixedSpiritPosX = screenCorner_PosXMargin
    elseif isRightCulledWhenRightSideBubble then
      fixedSpiritPosX = scrX - screenCorner_PosXMargin - obsidian_B:GetSizeX() - obsidianB_PosXMargin - self._ui._obsidian:GetSizeX()
    else
      fixedSpiritPosX = spiritPosX
    end
  end
  self._ui._obsidian:SetPosX(fixedSpiritPosX)
  self._ui._obsidian:SetPosY(spiritPosY)
  local obsidianPosX = self._ui._obsidian:GetPosX()
  local obsidianPosY = self._ui._obsidian:GetPosY()
  local obsidianSizeX = self._ui._obsidian:GetSizeX()
  local obsidianSizeY = self._ui._obsidian:GetSizeX()
  if true == isLeftSideBubble then
    obsidian_B:SetPosX(obsidianPosX - obsidian_B:GetSizeX() - obsidianB_PosXMargin)
    obsidian_B:SetPosY(obsidianPosY - obsidianSizeY - obsidianB_PosYMargin)
  elseif false == isLeftSideBubble then
    obsidian_B:SetPosX(obsidianPosX + obsidianSizeX + obsidianB_PosXMargin)
    obsidian_B:SetPosY(obsidianPosY + obsidianB_PosYMargin)
  end
  local obsidianB_PosX = obsidian_B:GetPosX()
  local obsidianB_PosY = obsidian_B:GetPosY()
  local obsidianText1_PosXLeftMargin = obsidianB_widthMargin / 3
  local obsidianText1_PosYTopMargin = obsidianB_heightMargin / 6
  self._ui._obsidian_Text:SetPosX(obsidianB_PosX + obsidianText1_PosXLeftMargin)
  self._ui._obsidian_Text:SetPosY(obsidianText1_PosYTopMargin * 2.75 * multiplyOneOrZero + obsidianB_PosY + obsidianText1_PosYTopMargin)
  local text1PosY = self._ui._obsidian_Text:GetPosY()
  local obsidianText2_PosXLeftMargin = obsidianText1_PosXLeftMargin
  local obsidianText2_PosYTopMargin = obsidianText1_PosYTopMargin
  self._ui._obsidian_Text_2:SetPosX(obsidianB_PosX + obsidianText2_PosXLeftMargin)
  self._ui._obsidian_Text_2:SetPosY(text1PosY + text1SizeY + obsidianText2_PosYTopMargin)
  if nil == isIgnore then
    self:setIgnoreBubble(true)
  else
    self:setIgnoreBubble(isIgnore)
  end
  if false == isIgnore then
    local currentBubble = obsidian_B
    local uiMouseBody_L = self._ui._mouseBody_L
    local mouseBodyPosX = currentBubble:GetPosX() + currentBubble:GetSizeX() - uiMouseBody_L:GetSizeX() * 1
    local mouseBodyPosY = currentBubble:GetPosY() + currentBubble:GetSizeY() - uiMouseBody_L:GetSizeY() * 0.35
    self:setPosMouseL(mouseBodyPosX, mouseBodyPosY)
    self:setShowMouseL(true)
  else
    self:setShowMouseL(false)
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:getCurrentObsidianBubble()
  if true == self._ui._obsidian_B:GetShow() then
    return self._ui._obsidian_B
  elseif true == self._ui._obsidian_B_Left:GetShow() then
    return self._ui._obsidian_B_Left
  else
    return nil
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:setIgnoreBubble(bIgnore)
  local currentBubble = self:getCurrentObsidianBubble()
  currentBubble:SetIgnore(bIgnore)
end
function PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOnBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_On", true)
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:handleMouseOutBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_Out", true)
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLDownBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_LDown", true)
  end
end
function PaGlobal_TutorialUiSmallBlackSpirit:handleMouseLUpBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_LUp", true)
    PaGlobal_TutorialManager:handleMouseLUpBubble()
  end
end
