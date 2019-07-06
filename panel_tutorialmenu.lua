Panel_TutorialMenu:RegisterShowEventFunc(true, "TutorialMenuShowAni()")
Panel_TutorialMenu:RegisterShowEventFunc(false, "TutorialMenuHideAni()")
PaGlobal_TutorialMenu = {
  _isFold = true,
  _lastButtonPosY = 0,
  _topMarginSize = 20,
  _marginSize = 10,
  _ui = {
    _panel = Panel_TutorialMenu,
    _buttonTutorialMenu = nil,
    _staticTutorialMenuBg = nil,
    _buttonTutorialStart1 = nil,
    _buttonTutorialStart2 = nil
  },
  _refWeightOverUi = nil
}
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TutorialMenu")
registerEvent("onScreenResize", "FromClient_onScreenResize_TutorialMenu")
function TutorialMenuShowAni()
end
function TutorialMenuHideAni()
end
function FromClient_luaLoadComplete_TutorialMenu()
  PaGlobal_TutorialMenu:initialize()
end
function FromClient_onScreenResize_TutorialMenu()
  PaGlobal_TutorialMenu:onScreenResize()
end
function PaGlobal_TutorialMenu:onScreenResize()
  if true == self._ui._panel:GetShow() then
    self:alignPosByPivotUi()
  end
end
function PaGlobal_TutorialMenu:initialize()
  self._ui._buttonTutorialMenu = UI.getChildControl(Panel_TutorialMenu, "Button_TutorialMenu")
  self._ui._staticTutorialMenuBg = UI.getChildControl(self._ui._buttonTutorialMenu, "Static_TutorialMenuBg")
  self._ui._buttonTutorialStart1 = UI.getChildControl(self._ui._staticTutorialMenuBg, "Button_TutorialStart_1")
  self._ui._buttonTutorialStart2 = UI.getChildControl(self._ui._staticTutorialMenuBg, "Button_TutorialStart_2")
  self._isFold = true
  self:setShow(false, false)
  self:alignPosByPivotUi()
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    self._refWeightOverUi = PaGlobalPlayerWeightList.weight
  else
    self._refWeightOverUi = nil
  end
  self._ui._buttonTutorialMenu:addInputEvent("Mouse_LUp", "PaGlobal_TutorialMenu:handleClickedMenuButton()")
  self._ui._buttonTutorialStart1:addInputEvent("Mouse_LUp", "PaGlobal_TutorialMenu:handleClickedTutorialStartButton(1)")
  self._ui._buttonTutorialStart2:addInputEvent("Mouse_LUp", "PaGlobal_TutorialMenu:handleClickedTutorialStartButton(2)")
end
function PaGlobal_TutorialMenu:setPosX(posX)
  self._ui._panel:SetPosX(posX)
end
function PaGlobal_TutorialMenu:setPosY(posY)
  self._ui._panel:SetPosY(posY)
end
function PaGlobal_TutorialMenu:setShow(bShow, bShowAni)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if true == bShow then
    self:alignPosByPivotUi()
    if true == Panel_TutorialMenu:GetShow() and false == self._isFold then
      self:unfoldTutorialMenu()
    end
  end
  Panel_TutorialMenu:SetShow(bShow, bShowAni)
end
function PaGlobal_TutorialMenu:checkShowCondition()
  local selfPlayer = getSelfPlayer()
  local playerLevel = selfPlayer:get():getLevel()
  if true == PaGlobal_TutorialMenu:checkShowConditionWeight() then
    return true
  end
  if true == PaGlobal_TutorialMenu:checkShowConditionNewEquip() then
    return true
  end
  return false
end
function PaGlobal_TutorialMenu:checkShowConditionWeight()
  local selfPlayer = getSelfPlayer()
  local playerLevel = selfPlayer:get():getLevel()
  if nil ~= self._refWeightOverUi and true == self._refWeightOverUi:GetShow() and true == PaGlobal_TutorialPhase_ItemSell._isPhaseOpen and playerLevel >= 10 and playerLevel <= 40 then
    return true
  end
  return false
end
function PaGlobal_TutorialMenu:checkShowConditionNewEquip()
  local selfPlayer = getSelfPlayer()
  local playerLevel = selfPlayer:get():getLevel()
  if true == Panel_NewEquip:GetShow() and true == PaGlobal_TutorialPhase_NewItemEquip._isPhaseOpen and playerLevel >= 6 and playerLevel <= 49 then
    return true
  end
  return false
end
function PaGlobal_TutorialMenu:alignPosByPivotUi()
  local pivotUi
  local posX = 0
  local posY = 0
  if nil ~= self._refWeightOverUi and true == self._refWeightOverUi:GetShow() then
    pivotUi = self._refWeightOverUi
    posX = Panel_Endurance:GetPosX() + pivotUi:GetPosX() + pivotUi:GetSizeX() / 2 - self._ui._buttonTutorialMenu:GetSizeX() / 2
    posY = Panel_Endurance:GetPosY() + pivotUi:GetPosY() + pivotUi:GetSizeY() + pivotUi:GetSizeY() / 2
  end
  if nil == pivotUi then
    pivotUi = Panel_NewEquip
    posX = pivotUi:GetPosX() + pivotUi:GetSizeX() - self._ui._buttonTutorialMenu:GetSizeX()
    posY = pivotUi:GetPosY() + pivotUi:GetSizeY()
  end
  self:setPosX(posX)
  self:setPosY(posY)
end
function PaGlobal_TutorialMenu:handleClickedMenuButton()
  if true == self._isFold then
    self:unfoldTutorialMenu()
  elseif false == self._isFold then
    self:foldTutorialMenu()
  end
end
function PaGlobal_TutorialMenu:handleClickedTutorialStartButton(buttonIndex)
  if 1 == buttonIndex then
    PaGlobal_TutorialManager:startTutorial(16)
  elseif 2 == buttonIndex then
    PaGlobal_TutorialManager:startTutorial(17)
  end
  self:foldTutorialMenu()
end
function PaGlobal_TutorialMenu:foldTutorialMenu()
  self._isFold = true
  self._ui._staticTutorialMenuBg:SetShow(false, true)
  self._ui._buttonTutorialStart1:SetShow(false, true)
  self._ui._buttonTutorialStart2:SetShow(false, true)
end
function PaGlobal_TutorialMenu:unfoldTutorialMenu()
  self._isFold = false
  self._ui._staticTutorialMenuBg:SetShow(true, true)
  local orderNum = 1
  local playerLevel = getSelfPlayer():get():getLevel()
  local rv = false
  if self:checkShowConditionWeight() then
    rv = self:alignPosTutorialStartButton(self._ui._buttonTutorialStart2, orderNum)
    orderNum = orderNum + 1
  else
    self._ui._buttonTutorialStart2:SetShow(false)
  end
  if self:checkShowConditionNewEquip() then
    rv = self:alignPosTutorialStartButton(self._ui._buttonTutorialStart1, orderNum)
    orderNum = orderNum + 1
  else
    self._ui._buttonTutorialStart1:SetShow(false)
  end
  local bgSizeX = self._ui._staticTutorialMenuBg:GetSizeX()
  local bgSizeY = self._lastButtonPosY + self._topMarginSize * 2
  self._ui._staticTutorialMenuBg:SetSize(bgSizeX, bgSizeY)
  if false == rv then
    self:foldTutorialMenu()
    self:setShow(false, false)
  end
end
function PaGlobal_TutorialMenu:alignPosTutorialStartButton(tutorialStartButton, orderNum)
  if nil == tutorialStartButton then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \235\178\132\237\138\188 \236\160\149\235\160\172 : tutorialStartButton\236\157\180 nil \236\158\133\235\139\136\235\139\164.")
    return false
  end
  if orderNum < 1 then
    _PA_LOG("\234\179\189\235\175\188\236\154\176", "\237\138\156\237\134\160\235\166\172\236\150\188 \236\139\156\236\158\145 \235\178\132\237\138\188 \236\160\149\235\160\172 : orderNum\234\176\128 1 \236\157\180\236\131\129\236\157\180\236\150\180\236\149\188 \237\149\169\235\139\136\235\139\164.")
    return false
  end
  if 1 == orderNum then
    self._marginSize = 0
  else
    self._marginSize = 10
  end
  local posX = tutorialStartButton:GetPosX()
  local posY = self._topMarginSize + (orderNum - 1) * (tutorialStartButton:GetSizeY() + self._marginSize)
  self._lastButtonPosY = posY + self._topMarginSize
  tutorialStartButton:SetPosX(posX)
  tutorialStartButton:SetPosY(posY)
  tutorialStartButton:SetShow(true, true)
  return true
end
