PaGlobal_TutorialUiBlackSpirit = {
  _ui = {
    _static_BottomBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_BottomBg"),
    _static_ArrowBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_ArrowBg"),
    _fadeOutBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_BlackFadeBg")
  },
  _static_StepBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_StepBg")
}
local isInit = false
function PaGlobal_TutorialUiBlackSpirit:initialize()
  self.isInit = true
  self._ui._staticText_Key1_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key1_ConsoleUI")
  self._ui._staticText_Key2_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key2_ConsoleUI")
  self._ui._static_BlackSpiritEffect = UI.getChildControl(self._ui._static_BottomBg, "Static_BlackSpiritEffect")
  self._ui._static_KeyGuideBg = UI.getChildControl(self._ui._static_BottomBg, "Static_KeyGuideBg")
  self._static_TitleBox = UI.getChildControl(self._static_StepBg, "Static_TitleBox")
  self._staticText_Title = UI.getChildControl(self._static_TitleBox, "StaticText_Title")
  self.original_titleBoxSizeY = self._static_TitleBox:GetSizeY()
  self._ui._static_bubbleGuidePos = UI.getChildControl(self._ui._static_BottomBg, "Static_GuideBubblePos")
  self._ui._static_bubbleGuide = UI.getChildControl(self._ui._static_bubbleGuidePos, "Static_GuideBubble")
  self._ui._staticText_Desc = UI.getChildControl(self._ui._static_bubbleGuide, "StaticText_Desc")
  self._ui._static_BlackSpiritEffect:SetIgnore(true)
  self._enabledEffect = false
  self._keyGuide = {}
  self._keyGuide[0] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_W")
  self._keyGuide[1] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_A")
  self._keyGuide[2] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_S")
  self._keyGuide[3] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_D")
  self._keyGuide[4] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_T")
  self._keyGuide[5] = UI.getChildControl(self._ui._static_KeyGuideBg, "StaticText_R")
end
function PaGlobal_TutorialUiBlackSpirit:eraseEffect(key)
  self._ui[key]:EraseAllEffect()
end
function PaGlobal_TutorialUiBlackSpirit:addEffect(key, effectName, isLoop, posX, posY)
  self._ui[key]:AddEffect(effectName, isLoop, posX, posY)
end
function PaGlobal_TutorialUiBlackSpirit:addEffectBlackSpirit(effectName, isLoop, posX, posY)
  if false == self._enabledEffect then
    self._enabledEffect = true
    self:addEffect("_static_BlackSpiritEffect", effectName, isLoop, posX, posY)
  end
end
function PaGlobal_TutorialUiBlackSpirit:eraseEffectBlackSpirit()
  self._enabledEffect = false
  self:eraseEffect("_static_BlackSpiritEffect")
end
function PaGlobal_TutorialUiBlackSpirit:resetPosition()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  self._ui._static_BlackSpiritEffect:SetPosX(scrX * 0.5)
  self._ui._static_BlackSpiritEffect:SetPosY(scrY * 0.5)
  self._ui._static_BlackSpiritEffect:SetShow(true)
end
function PaGlobal_TutorialUiBlackSpirit:setShow(key, isShow)
  self._ui[key]:SetShow(isShow)
end
function PaGlobal_TutorialUiBlackSpirit:setPosX(key, posX)
  self._ui[key]:SetPosX(posX)
end
function PaGlobal_TutorialUiBlackSpirit:setPosY(key, posY)
  self._ui[key]:SetPosY(posY)
end
function PaGlobal_TutorialUiBlackSpirit:getPosX(key, posX)
  return self._ui[key]:GetPosX()
end
function PaGlobal_TutorialUiBlackSpirit:getPosY(key, posY)
  return self._ui[key]:GetPosY()
end
function PaGlobal_TutorialUiBlackSpirit:getSizeY(key, sizeY)
  return self._ui[key]:GetSizeY()
end
function PaGlobal_TutorialUiBlackSpirit:setShowBlackSpirit(isShow)
  self:setShow("_static_BlackSpiritEffect", isShow)
end
function PaGlobal_TutorialUiBlackSpirit:setShowAll(isShow)
  for key, value in pairs(self._ui) do
    value:SetShow(isShow)
  end
end
function PaGlobal_TutorialUiBlackSpirit:showRotateArrow(isShow)
  if true == isShow then
    self._ui._static_ArrowBg:SetPosX(getScreenSizeX() * 0.5 - self._ui._static_ArrowBg:GetSizeX() * 0.5)
    self._ui._static_ArrowBg:SetPosY(getScreenSizeY() * 0.75 - self._ui._static_ArrowBg:GetSizeX() * 0.5)
  end
  self._ui._static_ArrowBg:SetShow(isShow)
end
function PaGlobal_TutorialUiBlackSpirit:showSuggestCallSpiritUi()
  Panel_Tutorial_Renew:SetShow(true, true)
  PaGlobal_TutorialUiManager:hideAllTutorialUi()
  local message = PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_46")
  if ToClient_isConsole() then
    message = message .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIALXB_TEXT_14")
  else
    message = message .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TUTORIAL_OBSIDIAN_TEXT_47")
  end
  PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(function()
    PaGlobal_TutorialUiManager:getUiBlackSpirit():setSpiritUiForTutorial_Desc(message)
  end)
end
function PaGlobal_TutorialUiBlackSpirit:resetSpiritUiForTutorial()
  self:addEffectBlackSpirit("fN_DarkSpirit_Gage_01C", true, 0, 0)
  self._ui._staticText_Desc:SetShow(false)
  self._ui._staticText_Key1_ConsoleUI:SetShow(false)
  self._ui._staticText_Key2_ConsoleUI:SetShow(false)
  self:showSpiritTutorialBubble(false)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial(text1, text2, isIgnore)
  self:resetSpiritUiForTutorial()
  local largerTextSizeX, largerTextSizeY
  if nil ~= text1 then
    self:showSpiritTutorialBubble(false)
    self._staticText_Title:SetText(text1)
    self._staticText_Title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._static_TitleBox:SetShow(true)
    self._staticText_Title:SetShow(true)
  end
  if nil ~= text2 then
    self:showSpiritTutorialBubble(true)
    self._ui._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._staticText_Desc:SetText(text2)
    self._ui._staticText_Desc:SetShow(true)
    self:setSpiritTutorialBubblePos(text2)
  end
  self:setSpiritTutorialBubblePos(text1, text2)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial_Title(text)
  self:resetSpiritUiForTutorial()
  if nil ~= text then
    self:showSpiritTutorialBubble(false)
    self._staticText_Title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._staticText_Title:SetText(text)
    self._static_TitleBox:SetShow(true)
    self._staticText_Title:SetShow(true)
  end
  self:setSpiritTutorialBubblePos(text, nil)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial_Desc(text)
  self:resetSpiritUiForTutorial()
  self:showSpiritTutorialBubble(true)
  if nil ~= text then
    self._ui._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._staticText_Desc:SetText(text)
    self._ui._staticText_Desc:SetShow(true)
  end
  self:setSpiritTutorialBubblePos(nil, text)
end
function PaGlobal_TutorialUiBlackSpirit:showSpiritTutorialBubble(isShow)
  self._ui._static_BottomBg:SetShow(isShow)
  self._ui._static_bubbleGuidePos:SetShow(isShow)
  self._ui._static_bubbleGuide:SetShow(isShow)
  self._ui._static_BlackSpiritEffect:SetShow(isShow)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritTutorialBubblePos(step, desc)
  if nil ~= step then
    local stepX = self._staticText_Title:GetTextSizeX()
    local stepY = self._staticText_Title:GetTextSizeY()
    if stepY + 20 < self.original_titleBoxSizeY then
      self._static_TitleBox:SetSize(self._static_TitleBox:GetSizeX(), self.original_titleBoxSizeY)
    else
      self._static_TitleBox:SetSize(self._static_TitleBox:GetSizeX(), stepY + 20)
    end
    self._static_TitleBox:SetHorizonCenter()
    self._static_TitleBox:SetPosY(self._static_TitleBox:GetPosY() + 30)
    self._staticText_Title:ComputePos()
  end
  if nil ~= desc then
    local descX = self._ui._staticText_Desc:GetTextSizeX()
    local descY = self._ui._staticText_Desc:GetTextSizeY()
    self._ui._static_bubbleGuide:SetSize(descX + 30, descY + 30)
    self._ui._static_bubbleGuide:ComputePos()
    self._ui._staticText_Desc:ComputePos()
  end
  self._ui._static_KeyGuideBg:SetShow(false)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritKeyGuideShow(keyType)
  for index, control in pairs(self._keyGuide) do
    control:ResetVertexAni()
    if keyType == index then
      control:SetFontColor(Defines.Color.C_FFFFCE22)
      control:SetVertexAniRun("Ani_Color_New", true)
    else
      control:SetFontColor(Defines.Color.C_FFC4BEBE)
    end
  end
  local showAni = self._ui._static_KeyGuideBg:addColorAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00FFFFFF)
  showAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  showAni.IsChangeChild = true
  self._ui._static_KeyGuideBg:SetShow(true)
end
function PaGlobal_TutorialUiBlackSpirit:resizeBubblePos()
  if self.isInit == true then
    self._ui._static_bubbleGuidePos:ComputePos()
    self._ui._static_bubbleGuide:ComputePos()
    self._ui._staticText_Desc:ComputePos()
  end
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorialFunctor(functor)
  PaGlobal_TutorialUiBlackSpirit._blackSpiritRestorFunctor = functor
  self:doSpiritUiForTutorialFunctor()
end
function PaGlobal_TutorialUiBlackSpirit:doSpiritUiForTutorialFunctor()
  if nil == PaGlobal_TutorialUiBlackSpirit._blackSpiritRestorFunctor then
    return
  end
  PaGlobal_TutorialUiBlackSpirit._blackSpiritRestorFunctor()
end
function FromClient_luaLoadComplete_TutorialUiBlackSpirit()
  PaGlobal_TutorialUiBlackSpirit:initialize()
end
function Tutorial_OnResize()
  PaGlobal_TutorialUiBlackSpirit:doSpiritUiForTutorialFunctor()
  PaGlobal_TutorialUiBlackSpirit:resizeBubblePos()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialUiBlackSpirit")
registerEvent("onScreenResize", "Tutorial_OnResize")
