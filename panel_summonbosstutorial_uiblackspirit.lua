PaGlobal_SummonBossTutorial_UiBlackSpirit = {
  _ui = {
    _obsidian = UI.getChildControl(Panel_SummonBossTutorial, "Static_Obsidian"),
    _obsidian_B = UI.getChildControl(Panel_SummonBossTutorial, "Static_Obsidian_B"),
    _obsidian_B_Left = UI.getChildControl(Panel_SummonBossTutorial, "Static_Obsidian_B_Left"),
    _obsidian_Text = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_Obsidian_B"),
    _obsidian_Text_2 = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_Obsidian_B_2"),
    _bubbleKey_W = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_W"),
    _bubbleKey_A = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_A"),
    _bubbleKey_S = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_S"),
    _bubbleKey_D = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_D"),
    _bubbleKey_I = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_I"),
    _bubbleKey_R = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_R"),
    _bubbleKey_T = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_T"),
    _bubbleKey_Shift = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_Shift"),
    _bubbleKey_Ctrl = UI.getChildControl(Panel_SummonBossTutorial, "StaticText_BubbleKey_Ctrl"),
    _mouseBody_L = UI.getChildControl(Panel_SummonBossTutorial, "Static_MouseBody_L"),
    _mouseLButton_L = UI.getChildControl(Panel_SummonBossTutorial, "Static_L_Btn_L"),
    _mouseLButton_R = UI.getChildControl(Panel_SummonBossTutorial, "Static_L_Btn_R"),
    _mouseBody_R = UI.getChildControl(Panel_SummonBossTutorial, "Static_MouseBody_R"),
    _mouseRButton_L = UI.getChildControl(Panel_SummonBossTutorial, "Static_R_Btn_L"),
    _mouseRButton_R = UI.getChildControl(Panel_SummonBossTutorial, "Static_R_Btn_R")
  },
  _firstBubbleKeyMargin = 20,
  _bubbleKeyMargin = 5,
  _enabledEffect = false,
  _blackSpiritRestorFunctor = nil,
  _texturePath_White = "New_UI_Common_ForLua/Widget/Bubble/Bubble.dds",
  _texturePath_Black = "New_UI_Common_ForLua/Widget/Bubble/Bubble_01.dds"
}
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setShowMouseL(bShow)
  self._ui._mouseBody_L:SetShow(bShow)
  self._ui._mouseLButton_L:SetShow(bShow)
  self._ui._mouseLButton_R:SetShow(bShow)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setPosMouseL(posX, posY)
  self._ui._mouseBody_L:SetPosX(posX)
  self._ui._mouseBody_L:SetPosY(posY)
  self._ui._mouseLButton_L:SetPosX(posX)
  self._ui._mouseLButton_L:SetPosY(posY)
  self._ui._mouseLButton_R:SetPosX(posX + 12)
  self._ui._mouseLButton_R:SetPosY(posY)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:initialize()
  self._ui._obsidian_B:SetIgnore(true)
  self._ui._obsidian_B_Left:SetIgnore(true)
  self._ui._obsidian_B:SetColor(Defines.Color.C_FF000000)
  self._ui._obsidian_B_Left:SetColor(Defines.Color.C_FF000000)
  self._ui._obsidian_B:addInputEvent("Mouse_LUp", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLUpBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_LDown", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLDownBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_On", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOnBubble()")
  self._ui._obsidian_B:addInputEvent("Mouse_Out", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOutBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_LUp", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLUpBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_LDown", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLDownBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_On", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOnBubble()")
  self._ui._obsidian_B_Left:addInputEvent("Mouse_Out", "PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOutBubble()")
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:getBubbleKeyMargin()
  return self._bubbleKeyMargin
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:eraseEffect(key)
  self._ui[key]:EraseAllEffect()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:addEffect(key, effectName, isLoop, posX, posY)
  self._ui[key]:AddEffect(effectName, isLoop, posX, posY)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:addEffectBlackSpirit(effectName, isLoop, posX, posY)
  if false == self._enabledEffect then
    self._enabledEffect = true
    self:addEffect("_obsidian", effectName, isLoop, posX, posY)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:eraseEffectBlackSpirit()
  self._enabledEffect = false
  self:eraseEffect("_obsidian")
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:resetPosition()
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
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setShow(key, isShow)
  self._ui[key]:SetShow(isShow)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setPosX(key, posX)
  self._ui[key]:SetPosX(posX)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setPosY(key, posY)
  self._ui[key]:SetPosY(posY)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:getPosX(key, posX)
  return self._ui[key]:GetPosX()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:getPosY(key, posY)
  return self._ui[key]:GetPosY()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:getSizeY(key, sizeY)
  return self._ui[key]:GetSizeY()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setShowBubbleKey(key, isShow)
  self._ui[key]:SetShow(isShow)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setShowBlackSpirit(isShow)
  self:setShow("_obsidian", isShow)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setShowAll(isShow)
  for key, value in pairs(self._ui) do
    value:SetShow(isShow)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:hideBubbleKey()
  self._ui._bubbleKey_W:SetShow(false)
  self._ui._bubbleKey_A:SetShow(false)
  self._ui._bubbleKey_S:SetShow(false)
  self._ui._bubbleKey_D:SetShow(false)
  self._ui._bubbleKey_I:SetShow(false)
  self._ui._bubbleKey_R:SetShow(false)
  self._ui._bubbleKey_T:SetShow(false)
  self._ui._bubbleKey_Shift:SetShow(false)
  self._ui._bubbleKey_Ctrl:SetShow(false)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:changeBubbleKeyByKeySetting()
  self._ui._bubbleKey_W:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveFront))
  self._ui._bubbleKey_A:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveLeft))
  self._ui._bubbleKey_S:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveBack))
  self._ui._bubbleKey_D:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_MoveRight))
  self._ui._bubbleKey_I:SetText(keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_Inventory))
  self._ui._bubbleKey_R:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction))
  self._ui._bubbleKey_T:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_AutoRun))
  self._ui._bubbleKey_Shift:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Dash))
  self._ui._bubbleKey_Ctrl:SetText(keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_CursorOnOff))
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:showSuggestCallSpiritUi()
  Panel_Tutorial:SetShow(true, true)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  PaGlobal_TutorialUiManager:getUiMasking():showSpiritMasking()
  local blackSpiritKeyString = keyCustom_GetString_UiKey(CppEnums.UiInputType.UiInputType_BlackSpirit)
  PaGlobal_SummonBossTutorial_UiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial(PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_46"), PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_47"), true, getScreenSizeX() - 125, getScreenSizeY() - 125)
  end)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:resetSpiritUiForTutorial()
  self:resetPosition()
  PaGlobal_TutorialUiManager:getUiBlackSpirit():hideBubbleKey()
  PaGlobal_TutorialUiManager:getUiBlackSpirit():addEffectBlackSpirit("fUI_DarkSpirit_Tutorial", true, 0, 0)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setSpiritUiForTutorial(text1, text2, isLeftSideBubble, spiritPosX, spiritPosY, isIgnore)
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
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setSpiritUiForTutorialFunctor(functor)
  PaGlobal_SummonBossTutorial_UiBlackSpirit._blackSpiritRestorFunctor = functor
  self:doSpiritUiForTutorialFunctor()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:doSpiritUiForTutorialFunctor()
  if nil == PaGlobal_SummonBossTutorial_UiBlackSpirit._blackSpiritRestorFunctor then
    return
  end
  PaGlobal_SummonBossTutorial_UiBlackSpirit._blackSpiritRestorFunctor()
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:addBubbleKey(...)
  local bubbleKeyPosX, bubbleKeyPosY, bubbleKeySizeX, currentBubbleSizeX, previousBubbleKey
  for index, value in ipairs({
    ...
  }) do
    bubbleKeyPosY = self._ui._obsidian_Text_2:GetPosY()
    bubbleKeySizeX = self._ui[value]:GetSizeX()
    currentBubbleSizeX = self:getCurrentObsidianBubble():GetSizeX()
    if 1 == index then
      bubbleKeyPosX = self._ui._obsidian_Text_2:GetPosX() + self._ui._obsidian_Text_2:GetTextSizeX() + self._firstBubbleKeyMargin
      self:getCurrentObsidianBubble():SetSize(currentBubbleSizeX + self._firstBubbleKeyMargin + bubbleKeySizeX, self:getCurrentObsidianBubble():GetSizeY())
      previousBubbleKey = self._ui[value]
    else
      bubbleKeyPosX = previousBubbleKey:GetPosX() + previousBubbleKey:GetSizeX() + self._bubbleKeyMargin
      self:getCurrentObsidianBubble():SetSize(currentBubbleSizeX + self._bubbleKeyMargin + bubbleKeySizeX, self:getCurrentObsidianBubble():GetSizeY())
      previousBubbleKey = self._ui[value]
    end
    self._ui[value]:SetPosX(bubbleKeyPosX)
    self._ui[value]:SetPosY(bubbleKeyPosY)
    self._ui[value]:SetShow(true)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:addOverBubbleKey(destKey, targetKey)
  self:setPosX(destKey, self:getPosX(targetKey))
  self:setPosY(destKey, self:getPosY(targetKey) - self:getSizeY(targetKey) - self:getBubbleKeyMargin())
  self:setShow(destKey, true)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:getCurrentObsidianBubble()
  if true == self._ui._obsidian_B:GetShow() then
    return self._ui._obsidian_B
  elseif true == self._ui._obsidian_B_Left:GetShow() then
    return self._ui._obsidian_B_Left
  else
    return nil
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:setIgnoreBubble(bIgnore)
  local currentBubble = self:getCurrentObsidianBubble()
  currentBubble:SetIgnore(bIgnore)
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOnBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_On", true)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseOutBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_Out", true)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLDownBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_LDown", true)
  end
end
function PaGlobal_SummonBossTutorial_UiBlackSpirit:handleMouseLUpBubble()
  local currentBubble = self:getCurrentObsidianBubble()
  if nil ~= currentBubble then
    self:changeBubbleTextureForAni(true)
    currentBubble:SetVertexAniRun("Ani_Color_LUp", true)
    PaGlobal_TutorialManager:handleMouseLUpBubble()
  end
end
function FromClient_luaLoadComplete_SummonBossTutorial_UiBlackSpirit()
  PaGlobal_SummonBossTutorial_UiBlackSpirit:initialize()
end
function OnResize_SummonBossTutorial_UiBlackSpirit()
  PaGlobal_SummonBossTutorial_UiBlackSpirit:doSpiritUiForTutorialFunctor()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_SummonBossTutorial_UiBlackSpirit")
registerEvent("onScreenResize", "OnResize_SummonBossTutorial_UiBlackSpirit")
function PaGlobal_SummonBossTutorial_UiBlackSpirit:changeBubbleTextureForAni(bWhite)
  if true == Panel_Tutorial:isPlayAnimation() then
    self._ui._obsidian_B:ChangeTextureInfoName(self._texturePath_Black)
    self._ui._obsidian_B_Left:ChangeTextureInfoName(self._texturePath_Black)
    return
  end
  local destTexture = self._texturePath_Black
  if true == bWhite then
    destTexture = self._texturePath_White
  elseif false == bWhite then
    destTexture = self._texturePath_Black
  end
  self._ui._obsidian_B:ChangeTextureInfoName(destTexture)
  self._ui._obsidian_B_Left:ChangeTextureInfoName(destTexture)
end
