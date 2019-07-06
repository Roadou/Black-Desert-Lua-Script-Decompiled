PaGlobal_TutorialUiBlackSpirit = {
  _ui = {
    _static_BottomBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_BottomBg"),
    _static_ArrowBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_ArrowBg")
  },
  _enabledEffect = false
}
function PaGlobal_TutorialUiBlackSpirit:initialize()
  self._ui._staticText_Title = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Title")
  self._ui._staticText_Desc = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Desc")
  self._ui._staticText_Key1_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key1_ConsoleUI")
  self._ui._staticText_Key2_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_Key2_ConsoleUI")
  self._ui._static_BlackSpiritEffect = UI.getChildControl(self._ui._static_BottomBg, "Static_BlackSpiritEffect")
  self._ui._static_BlackSpiritEffect:SetIgnore(true)
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
  self._ui._staticText_Title:SetShow(false)
  self._ui._staticText_Desc:SetShow(false)
  self._ui._staticText_Key1_ConsoleUI:SetShow(false)
  self._ui._staticText_Key2_ConsoleUI:SetShow(false)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial(text1, text2, isIgnore)
  self:resetSpiritUiForTutorial()
  local largerTextSizeX, largerTextSizeY
  self._ui._static_BottomBg:SetShow(true)
  if nil ~= text1 then
    self._ui._staticText_Title:SetText(text1)
    self._ui._staticText_Title:SetShow(true)
  end
  if nil ~= text2 then
    local scrX = self._ui._staticText_Key2_ConsoleUI:GetPosX() - self._ui._static_BlackSpiritEffect:GetSizeX()
    self._ui._staticText_Desc:SetSize(scrX, self._ui._staticText_Desc:GetSizeY())
    self._ui._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._staticText_Desc:SetText(text2)
    self._ui._staticText_Desc:SetShow(true)
  end
  self._ui._static_BlackSpiritEffect:SetShow(true)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial_Title(text)
  self:resetSpiritUiForTutorial()
  self._ui._static_BottomBg:SetShow(true)
  if nil ~= text then
    self._ui._staticText_Title:SetText(text)
    self._ui._staticText_Title:SetShow(true)
  end
  self._ui._static_BlackSpiritEffect:SetShow(true)
end
function PaGlobal_TutorialUiBlackSpirit:setSpiritUiForTutorial_Desc(text)
  self:resetSpiritUiForTutorial()
  self._ui._static_BottomBg:SetShow(true)
  if nil ~= text then
    local scrX = self._ui._staticText_Key2_ConsoleUI:GetPosX() - self._ui._static_BlackSpiritEffect:GetSizeX()
    self._ui._staticText_Desc:SetSize(scrX, self._ui._staticText_Desc:GetSizeY())
    self._ui._staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._staticText_Desc:SetText(text)
    self._ui._staticText_Desc:SetShow(true)
  end
  self._ui._static_BlackSpiritEffect:SetShow(true)
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
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialUiBlackSpirit")
registerEvent("onScreenResize", "Tutorial_OnResize")
