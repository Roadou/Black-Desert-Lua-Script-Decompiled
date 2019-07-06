local VCK = CppEnums.VirtualKeyCode
local _updateGab = 0.1
local _updateTime = 0
local TutorialUI = {
  _uiTextGole = UI.getChildControl(Panel_KeyTutorial, "Text_Gole"),
  _uiButtonW = UI.getChildControl(Panel_KeyTutorial, "Button_W"),
  _uiButtonA = UI.getChildControl(Panel_KeyTutorial, "Button_A"),
  _uiButtonS = UI.getChildControl(Panel_KeyTutorial, "Button_S"),
  _uiButtonD = UI.getChildControl(Panel_KeyTutorial, "Button_D"),
  _uiButtonF = UI.getChildControl(Panel_KeyTutorial, "Button_F"),
  _uiButtonE = UI.getChildControl(Panel_KeyTutorial, "Button_E"),
  _uiButtonML = UI.getChildControl(Panel_KeyTutorial, "Mouse_Left"),
  _uiButtonMR = UI.getChildControl(Panel_KeyTutorial, "Mouse_Right"),
  _uiButtonShift = UI.getChildControl(Panel_KeyTutorial, "Button_Shift"),
  _uiButtonSpace = UI.getChildControl(Panel_KeyTutorial, "Button_Space"),
  _uiButtonTab = UI.getChildControl(Panel_KeyTutorial, "Button_Tab")
}
function TutorialUI:Show()
  Panel_KeyTutorial:SetShow(true)
  self._uiButtonW:SetColor(Defines.Color.C_FF444444)
  self._uiButtonW:SetIgnore(true)
  self._uiButtonA:SetColor(Defines.Color.C_FF444444)
  self._uiButtonA:SetIgnore(true)
  self._uiButtonS:SetColor(Defines.Color.C_FF444444)
  self._uiButtonS:SetIgnore(true)
  self._uiButtonD:SetColor(Defines.Color.C_FF444444)
  self._uiButtonD:SetIgnore(true)
  self._uiButtonF:SetColor(Defines.Color.C_FF444444)
  self._uiButtonF:SetIgnore(true)
  self._uiButtonE:SetColor(Defines.Color.C_FF444444)
  self._uiButtonE:SetIgnore(true)
  self._uiButtonML:SetColor(Defines.Color.C_FF444444)
  self._uiButtonML:SetIgnore(true)
  self._uiButtonMR:SetColor(Defines.Color.C_FF444444)
  self._uiButtonMR:SetIgnore(true)
  self._uiButtonShift:SetColor(Defines.Color.C_FF444444)
  self._uiButtonShift:SetIgnore(true)
  self._uiButtonSpace:SetColor(Defines.Color.C_FF444444)
  self._uiButtonSpace:SetIgnore(true)
  self._uiButtonTab:SetColor(Defines.Color.C_FF444444)
  self._uiButtonTab:SetIgnore(true)
end
function TutorialUI:Hide()
  Panel_KeyTutorial:SetShow(false)
end
function TutorialUI:CheckKeyPressed()
  self._uiButtonW:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_MoveFront))
  self._uiButtonA:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_MoveLeft))
  self._uiButtonS:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_MoveBack))
  self._uiButtonD:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_MoveRight))
  self._uiButtonF:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_Kick))
  self._uiButtonE:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(CppEnums.ActionInputType.ActionInputType_CrouchOrSkill))
  self._uiButtonShift:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(VCK.ActionInputType_Dash))
  self._uiButtonSpace:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(VCK.ActionInputType_Jump))
  self._uiButtonTab:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(VCK.ActionInputType_WeaponInOut))
  self._uiButtonML:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(VCK.ActionInputType_Attack1))
  self._uiButtonMR:SetCheck(GlobalKeyBinder_CheckCustomKeyPressed(VCK.ActionInputType_Attack2))
end
function TutorialUI:SetGole(textGole)
  self._uiTextGole:SetText(textGole)
end
function TutorialUI:SetForMove(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonW:SetColor(Defines.Color.C_FFFFFFFF)
  self._uiButtonA:SetColor(Defines.Color.C_FFFFFFFF)
  self._uiButtonS:SetColor(Defines.Color.C_FFFFFFFF)
  self._uiButtonD:SetColor(Defines.Color.C_FFFFFFFF)
end
function TutorialUI:SetForRun(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonW:SetColor(Defines.Color.C_FFFFFFFF)
  self._uiButtonShift:SetColor(Defines.Color.C_FFFFFFFF)
end
function TutorialUI:SetForTab(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonTab:SetColor(Defines.Color.C_FFFFFFFF)
end
function TutorialUI:SetForLeftAttack(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonML:SetColor(Defines.Color.C_FFFFFFFF)
  self._uiButtonMR:SetColor(Defines.Color.C_FFFFFFFF)
end
function TutorialUI:SetForKick(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonF:SetColor(Defines.Color.C_FFFFFFFF)
end
function TutorialUI:SetForKeyE(textGole)
  TutorialUI:Show()
  self._uiTextGole:SetText(textGole)
  self._uiButtonE:SetColor(Defines.Color.C_FFFFFFFF)
end
local Tutorial = {
  _currentStep = 0,
  _pushed_key = false,
  _pushed_time = 0,
  _currentTutorial = {}
}
function Tutorial:Clear()
  self._pushed_key = false
  self._pushed_time = 0
end
function Tutorial:StepMove()
  Tutorial:Clear()
  TutorialUI:SetForMove(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE1"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepMove")
end
function Update_StepMove(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    if TutorialUI._uiButtonW:IsCheck() or TutorialUI._uiButtonA:IsCheck() or TutorialUI._uiButtonS:IsCheck() or TutorialUI._uiButtonD:IsCheck() then
      Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    end
    _updateTime = 0
    if Tutorial._pushed_time > 5 then
      Tutorial._currentTutorial:NextStep()
    end
  end
end
function Tutorial:StepRun()
  Tutorial:Clear()
  TutorialUI:SetForRun(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE2"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepRun")
end
function Update_StepRun(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    if TutorialUI._uiButtonW:IsCheck() and TutorialUI._uiButtonShift:IsCheck() then
      Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    end
    _updateTime = 0
    if Tutorial._pushed_time > 5 then
      Tutorial._currentTutorial:NextStep()
    end
  end
end
function Tutorial:StepLeftAttack()
  Tutorial:Clear()
  TutorialUI:SetForLeftAttack(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE3"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepLeftAttack")
end
function Update_StepLeftAttack(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    if TutorialUI._uiButtonML:IsCheck() or TutorialUI._uiButtonMR:IsCheck() then
      Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    end
    _updateTime = 0
    if Tutorial._pushed_time > 5 then
      Tutorial._currentTutorial:NextStep()
    end
  end
end
function Tutorial:StepKick()
  Tutorial:Clear()
  TutorialUI:SetForKick(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE4"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepKeyF")
end
function Update_StepKeyF(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    if TutorialUI._uiButtonF:IsCheck() then
      Tutorial._pushed_key = true
    end
    if Tutorial._pushed_key then
      Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    end
    _updateTime = 0
    if Tutorial._pushed_time > 5 then
      Tutorial._currentTutorial:NextStep()
    end
  end
end
function Tutorial:StepCatch()
  Tutorial:Clear()
  TutorialUI:SetForKeyE(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE5"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepKeyE")
end
function Tutorial:StepGuard()
  Tutorial:Clear()
  TutorialUI:SetForKeyE(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE6"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepKeyE")
end
function Update_StepKeyE(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    if TutorialUI._uiButtonE:IsCheck() then
      Tutorial._pushed_key = true
    end
    if Tutorial._pushed_key then
      Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    end
    _updateTime = 0
    if Tutorial._pushed_time > 3 then
      Tutorial._currentTutorial:NextStep()
    end
  end
end
function Tutorial:StepComplete()
  Tutorial:Clear()
  TutorialUI:Show()
  TutorialUI:SetGole(PAGetString(Defines.StringSheet_GAME, "TUTORIAL_MESSAGE7"))
  Panel_KeyTutorial:RegisterUpdateFunc("Update_StepComplete")
end
function Update_StepComplete(deltaTime)
  _updateTime = _updateTime + deltaTime
  if _updateGab < _updateTime then
    TutorialUI:CheckKeyPressed()
    Tutorial._pushed_time = Tutorial._pushed_time + _updateTime
    _updateTime = 0
    if Tutorial._pushed_time > 3 then
      TutorialUI:Hide()
    end
  end
end
MoveTutorial = {}
function MoveTutorial:Start()
  Tutorial:Clear()
  Tutorial._currentStep = 0
  Tutorial._currentTutorial = MoveTutorial
  self:NextStep()
end
function MoveTutorial:NextStep()
  Tutorial._currentStep = Tutorial._currentStep + 1
  if 1 == Tutorial._currentStep then
    Tutorial:StepMove()
  elseif 2 == Tutorial._currentStep then
    Tutorial:StepRun()
  elseif 3 == Tutorial._currentStep then
    Tutorial:StepComplete()
  end
end
AttackTutorial = {}
function AttackTutorial:Start()
  Tutorial:Clear()
  Tutorial._currentStep = 0
  Tutorial._currentTutorial = AttackTutorial
  self:NextStep()
end
function AttackTutorial:NextStep()
  Tutorial._currentStep = Tutorial._currentStep + 1
  if 1 == Tutorial._currentStep then
    Tutorial:StepLeftAttack()
  elseif 2 == Tutorial._currentStep then
    Tutorial:StepKick()
  elseif 3 == Tutorial._currentStep then
    local classType = getSelfPlayer():getClassType()
    if CppEnums.ClassType.ClassType_Ranger == classType or CppEnums.ClassType.ClassType_Sorcerer == classType then
      Tutorial:StepComplete()
    elseif CppEnums.ClassType.ClassType_Warrior == classType then
      Tutorial:StepGuard()
    elseif CppEnums.ClassType.ClassType_Giant == classType then
      Tutorial:StepCatch()
    end
  elseif 4 == Tutorial._currentStep then
    Tutorial:StepComplete()
  end
end
