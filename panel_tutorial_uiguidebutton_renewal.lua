PaGlobal_TutorialUiGuideButton = {
  _ui = {
    _staticText_ClickButton = UI.getChildControl(Panel_Tutorial_Renew, "StaticText_ClickButton"),
    _static_CtrlGuide = UI.getChildControl(Panel_Tutorial_Renew, "Static_CtrlGuide"),
    _static_ArrowBg = UI.getChildControl(Panel_Tutorial_Renew, "Static_ArrowBg")
  }
}
function PaGlobal_TutorialUiGuideButton:initialize()
  self._ui._staticText_ClickButton:SetShow(false)
  self._ui._staticText_ClickButton:addInputEvent("Mouse_LUp", "PaGlobal_TutorialUiGuideButton:doGuideButtonEvnetFunctor()")
  self._ui._static_CtrlGuide:SetShow(false)
  self._ui._static_ArrowBg:SetShow(false)
end
function PaGlobal_TutorialUiGuideButton:showRotateArrow(isShow)
  if true == isShow then
    self._ui._static_ArrowBg:SetPosX(getScreenSizeX() * 0.5 - self._ui._static_ArrowBg:GetSizeX() * 0.5)
    self._ui._static_ArrowBg:SetPosY(getScreenSizeY() * 0.75 - self._ui._static_ArrowBg:GetSizeX() * 0.5)
  end
  self._ui._static_ArrowBg:SetShow(isShow)
end
function PaGlobal_TutorialUiGuideButton:showCtrlGuide(isShow)
  if true == isShow then
    self._ui._static_CtrlGuide:SetAlpha(0)
    UIAni.AlphaAnimation(1, self._ui._static_CtrlGuide, 0, 0.75)
    self._ui._static_CtrlGuide:SetPosX(getScreenSizeX() * 0.85 - self._ui._static_CtrlGuide:GetSizeX() * 0.5)
    self._ui._static_CtrlGuide:SetPosY(getScreenSizeY() * 0.6 - self._ui._static_CtrlGuide:GetSizeY() * 0.5)
  end
  self._ui._static_CtrlGuide:SetShow(isShow)
end
function PaGlobal_TutorialUiGuideButton:showClickableButton(isShow, text)
  if true == isShow then
    self._ui._staticText_ClickButton:SetAlpha(0)
    UIAni.AlphaAnimation(1, self._ui._staticText_ClickButton, 0, 1.5)
    self._ui._staticText_ClickButton:SetText(text)
  end
  self._ui._staticText_ClickButton:SetShow(isShow)
end
function PaGlobal_TutorialUiGuideButton:setPosClickableButton(xPos, yPos)
  self._ui._staticText_ClickButton:SetPosX(xPos)
  self._ui._staticText_ClickButton:SetPosY(yPos)
end
function PaGlobal_TutorialUiGuideButton:setGuideButtonEventFunctor(functor)
  PaGlobal_TutorialUiGuideButton._buttonEventFunctor = functor
end
function PaGlobal_TutorialUiGuideButton:doGuideButtonEvnetFunctor()
  if nil == PaGlobal_TutorialUiGuideButton._buttonEventFunctor then
    return
  end
  PaGlobal_TutorialUiGuideButton._buttonEventFunctor()
end
function FromClient_luaLoadComplete_TutorialUiGuideButton()
  PaGlobal_TutorialUiGuideButton:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialUiGuideButton")
