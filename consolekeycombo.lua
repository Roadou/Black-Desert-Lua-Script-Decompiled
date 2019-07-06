Panel_ConsoleCombo:SetShow(false)
PaGlobal_ConsoleKeyCombo = {
  _ui = {
    _static_RotateBG = UI.getChildControl(Panel_ConsoleCombo, "Static_Bg"),
    _static_X = UI.getChildControl(Panel_ConsoleCombo, "Static_ButtonX"),
    _static_Y = UI.getChildControl(Panel_ConsoleCombo, "Static_ButtonY"),
    _static_A = UI.getChildControl(Panel_ConsoleCombo, "Static_ButtonA"),
    _static_B = UI.getChildControl(Panel_ConsoleCombo, "Static_ButtonB"),
    _static_clearX = UI.getChildControl(Panel_ConsoleCombo, "Static_clearButtonX"),
    _static_clearY = UI.getChildControl(Panel_ConsoleCombo, "Static_clearButtonY"),
    _static_clearA = UI.getChildControl(Panel_ConsoleCombo, "Static_clearButtonA"),
    _static_clearB = UI.getChildControl(Panel_ConsoleCombo, "Static_clearButtonB"),
    _static_SkillIcon_Up = UI.getChildControl(Panel_ConsoleCombo, "Static_SkillIcon_Up"),
    _static_SkillIcon_Right = UI.getChildControl(Panel_ConsoleCombo, "Static_SkillIcon_Right"),
    _static_SkillIcon_Down = UI.getChildControl(Panel_ConsoleCombo, "Static_SkillIcon_Down"),
    _static_SkillIcon_Left = UI.getChildControl(Panel_ConsoleCombo, "Static_SkillIcon_Left"),
    _comboDelay = UI.getChildControl(Panel_ConsoleCombo, "CircularProgress_LimitTime")
  },
  _button = {
    [0] = "X",
    [1] = "Y",
    [2] = "A",
    [3] = "B"
  },
  _comboData = {
    [0] = {},
    [1] = {},
    [2] = {}
  },
  slotConfig = {
    createIcon = true,
    createEffect = false,
    createFG = false,
    createFGDisabled = false,
    createLevel = false,
    createLearnButton = false,
    createCooltime = true,
    createCooltimeText = true
  },
  _buttonMaxCount = 4,
  _isButtonClick = false,
  _isFirstSkillShow = false,
  _firstSKillButtonIndex = 0,
  _firstSkillButton = nil,
  _isFirstSkillShow,
  _isSkillIng = false,
  _isClickPossible = false,
  _currentTime = 0,
  _delayTime = 0,
  _skillCoolTimeKey = nil,
  _skillCoolTimeSlots = {},
  _coolTimeSkillNo = {},
  _coolTimeSkillIndex = {},
  _analogPad = "",
  _weaponType = 0
}
function PaGlobal_ConsoleKeyCombo:initialize()
  for index = 0, self._buttonMaxCount - 1 do
    local slot = {}
    SlotSkill.new(slot, index, Panel_ConsoleCombo, self.slotConfig)
    slot.icon:SetIgnore(true)
    if 0 == index then
      slot.icon:SetPosX(self._ui._static_SkillIcon_Left:GetPosX())
      slot.icon:SetPosY(self._ui._static_SkillIcon_Left:GetPosY())
      slot.cooltime:SetPosX(self._ui._static_SkillIcon_Left:GetPosX())
      slot.cooltime:SetPosY(self._ui._static_SkillIcon_Left:GetPosY())
      slot.cooltimeText:SetPosX(self._ui._static_SkillIcon_Left:GetPosX())
      slot.cooltimeText:SetPosY(self._ui._static_SkillIcon_Left:GetPosY())
    elseif 1 == index then
      slot.icon:SetPosX(self._ui._static_SkillIcon_Up:GetPosX())
      slot.icon:SetPosY(self._ui._static_SkillIcon_Up:GetPosY())
      slot.cooltime:SetPosX(self._ui._static_SkillIcon_Up:GetPosX())
      slot.cooltime:SetPosY(self._ui._static_SkillIcon_Up:GetPosY())
      slot.cooltimeText:SetPosX(self._ui._static_SkillIcon_Up:GetPosX())
      slot.cooltimeText:SetPosY(self._ui._static_SkillIcon_Up:GetPosY())
    elseif 2 == index then
      slot.icon:SetPosX(self._ui._static_SkillIcon_Down:GetPosX())
      slot.icon:SetPosY(self._ui._static_SkillIcon_Down:GetPosY())
      slot.cooltime:SetPosX(self._ui._static_SkillIcon_Down:GetPosX())
      slot.cooltime:SetPosY(self._ui._static_SkillIcon_Down:GetPosY())
      slot.cooltimeText:SetPosX(self._ui._static_SkillIcon_Down:GetPosX())
      slot.cooltimeText:SetPosY(self._ui._static_SkillIcon_Down:GetPosY())
    elseif 3 == index then
      slot.icon:SetPosX(self._ui._static_SkillIcon_Right:GetPosX())
      slot.icon:SetPosY(self._ui._static_SkillIcon_Right:GetPosY())
      slot.cooltime:SetPosX(self._ui._static_SkillIcon_Right:GetPosX())
      slot.cooltime:SetPosY(self._ui._static_SkillIcon_Right:GetPosY())
      slot.cooltimeText:SetPosX(self._ui._static_SkillIcon_Right:GetPosX())
      slot.cooltimeText:SetPosY(self._ui._static_SkillIcon_Right:GetPosY())
    end
    self._skillCoolTimeSlots[index] = slot
  end
end
function PaGlobal_ConsoleKeyCombo:open()
end
function PaGlobal_ConsoleKeyCombo:close()
end
function PaGlobal_ConsoleKeyCombo:nextSkillUpdate(isFirstSkill, weaponType)
  local skillCount = selfPlayerNextSkillConsoleKeySize()
  if true == isFirstSkill then
    PaGlobal_ConsoleKeyFirstCombo:findSkill(weaponType, true)
    return
  end
  if 0 ~= skillCount then
    Panel_ConsoleCombo:SetShow(true)
    self._ui._static_RotateBG:SetShow(true)
  end
  for index = 0, skillCount - 1 do
    local skillNo = selfPlayerNextSkillConsoleSkillNo(index)
    if 0 ~= skillNo then
      local skillWrapper = getSkillTypeStaticStatus(skillNo)
      if nil ~= skillWrapper then
        local buttonKey = selfPlayerNextSkillConsoleKeyList(index)
        PaGlobal_ConsoleKeyCombo:findCommand(index, buttonKey, skillWrapper, skillNo)
      end
    end
  end
end
function PaGlobal_ConsoleKeyCombo:findCommand(index, buttonKey, skillWrapper, skillNo)
  for buttonCount = 0, self._buttonMaxCount - 1 do
    local startIndex, endIndex = string.find(buttonKey, self._button[buttonCount])
    if nil ~= startIndex and nil ~= endIndex then
      local command = string.sub(buttonKey, startIndex, endIndex)
      PaGlobal_ConsoleKeyCombo:showCommand(index, command, skillWrapper, skillNo)
    end
  end
end
function PaGlobal_ConsoleKeyCombo:showCommand(index, command, skillWrapper, skillNo)
  if "X" == command then
    PaGlobal_ConsoleKeyCombo:setPosCommand(index, 0, skillWrapper, skillNo)
  elseif "Y" == command then
    PaGlobal_ConsoleKeyCombo:setPosCommand(index, 1, skillWrapper, skillNo)
  elseif "A" == command then
    PaGlobal_ConsoleKeyCombo:setPosCommand(index, 2, skillWrapper, skillNo)
  elseif "B" == command then
    PaGlobal_ConsoleKeyCombo:setPosCommand(index, 3, skillWrapper, skillNo)
  end
end
function PaGlobal_ConsoleKeyCombo:setPosCommand(index, posIndex, skillWrapper, skillNo)
  self._coolTimeSkillNo[posIndex] = skillNo
  self._coolTimeSkillIndex[posIndex] = index
  self._skillCoolTimeSlots[posIndex]:setSkillTypeStatic(skillWrapper)
  self._skillCoolTimeSlots[posIndex].icon:SetShow(true)
  self._ui._static_X:SetShow(true)
  self._ui._static_Y:SetShow(true)
  self._ui._static_A:SetShow(true)
  self._ui._static_B:SetShow(true)
end
function PaGlobal_ConsoleKeyCombo:setSKillIconAni(control)
  local aniInfo = control:addMoveAnimation(0, 0.25, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_LINEAR)
  aniInfo:SetStartPosition(control:GetPosX(), control:GetPosY())
  aniInfo:SetEndPosition(control:GetPosX(), control:GetPosY())
  control:CalcUIAniPos(aniInfo)
end
function PaGlobal_ConsoleKeyCombo:findFirstCombo(command, skillWrapper, skillNo, index, weaponType)
  local startIndex, endIndex
  if self._weaponType ~= weaponType then
    return
  end
  if 5 == self._firstSkillButton then
    startIndex, endIndex = string.find(command, "LT")
  elseif nil == startIndex or nil == endIndex then
    startIndex, endIndex = string.find(command, "LB")
  end
  if nil ~= startIndex and nil ~= endIndex then
    local commandLen = string.len(command)
    if nil ~= commandLen and "" == self._analogPad then
      local frontStart, frontEnd = string.find(command, "FRONT")
      local rightStart, rightEnd = string.find(command, "RIGHT")
      local backStart, backEnd = string.find(command, "BACK")
      local leftStart, leftEnd = string.find(command, "LEFT")
      if nil ~= frontStart or nil ~= frontEnd or nil ~= rightStart or nil ~= rightEnd or nil ~= backStart or nil ~= backEnd or nil ~= leftStart or nil ~= leftEnd then
        return
      end
      local isFind = false
      local buttonCommand = string.sub(command, commandLen, commandLen)
      if "X" == buttonCommand then
        PaGlobal_ConsoleKeyCombo:setPosCommand(index, 0, skillWrapper, skillNo)
        isFind = true
      end
      if "Y" == buttonCommand then
        PaGlobal_ConsoleKeyCombo:setPosCommand(index, 1, skillWrapper, skillNo)
        isFind = true
      end
      if "A" == buttonCommand then
        PaGlobal_ConsoleKeyCombo:setPosCommand(index, 2, skillWrapper, skillNo)
        isFind = true
      end
      if "B" == buttonCommand then
        PaGlobal_ConsoleKeyCombo:setPosCommand(index, 3, skillWrapper, skillNo)
        isFind = true
      end
      if true == isFind then
        Panel_ConsoleCombo:SetShow(true)
        self._ui._static_RotateBG:SetShow(true)
      end
    end
  end
end
function FromClient_consoleNextSkillList()
  local self = PaGlobal_ConsoleKeyCombo
  for index = 0, self._buttonMaxCount - 1 do
    self._skillCoolTimeSlots[index].icon:SetShow(false)
    self._skillCoolTimeSlots[index].cooltime:SetShow(false)
    self._skillCoolTimeSlots[index].cooltimeText:SetShow(false)
  end
  self._ui._static_RotateBG:SetShow(true)
  self._ui._comboDelay:SetShow(true)
  local delayTime = selfPlayerNextSkillConsoleDelayTime()
  self._ui._comboDelay:SetCurrentControlPos(0)
  self._ui._comboDelay:SetAniSpeed(0.1)
  self._currentTime = 0
  self._delayTime = Int64toInt32(delayTime) / 1000
  self._isButtonClick = true
  self._isFirstSkillShow = false
  PaGlobal_ConsoleKeyCombo:setSKillIconAni(self._ui._static_SkillIcon_Right)
  PaGlobal_ConsoleKeyCombo:setSKillIconAni(self._ui._static_SkillIcon_Left)
  PaGlobal_ConsoleKeyCombo:setSKillIconAni(self._ui._static_SkillIcon_Up)
  PaGlobal_ConsoleKeyCombo:setSKillIconAni(self._ui._static_SkillIcon_Down)
  PaGlobal_ConsoleKeyCombo:nextSkillUpdate()
end
function FromClient_consoleEffectButton(buttonType)
  local self = PaGlobal_ConsoleKeyCombo
  if false == self._isButtonClick then
    return
  end
  if 4 == buttonType then
    self._ui._static_clearX:SetShow(true)
    self._ui._static_clearX:EraseAllEffect()
    self._ui._static_clearX:AddEffect("fUI_Button_01A", false, 0, 0)
  elseif 13 == buttonType then
    self._ui._static_clearY:SetShow(true)
    self._ui._static_clearY:EraseAllEffect()
    self._ui._static_clearY:AddEffect("fUI_Button_01A", false, 0, 0)
  elseif 14 == buttonType then
    self._ui._static_clearB:SetShow(true)
    self._ui._static_clearB:EraseAllEffect()
    self._ui._static_clearB:AddEffect("fUI_Button_01A", false, 0, 0)
  elseif 7 == buttonType then
    self._ui._static_clearA:SetShow(true)
    self._ui._static_clearA:EraseAllEffect()
    self._ui._static_clearA:AddEffect("fUI_Button_01A", false, 0, 0)
  end
  self._isButtonClick = false
end
function FromClient_consoleFirstSkill(isShow, weaponType, buttonKeyIndex, analogX, analogY)
  local self = PaGlobal_ConsoleKeyCombo
  self._weaponType = weaponType
  if 1 ~= weaponType and 2 ~= weaponType then
    return
  end
  if true == isShow then
    self._firstSKillButtonIndex = buttonKeyIndex
    self._firstSkillButton = buttonKeyIndex
  end
  if false == isShow then
    if self._firstSKillButtonIndex == buttonKeyIndex then
      Panel_ConsoleCombo:SetShow(false)
      self._firstSKillButtonIndex = -1
    end
    return
  end
  for index = 0, self._buttonMaxCount - 1 do
    self._skillCoolTimeSlots[index].icon:SetShow(false)
    self._skillCoolTimeSlots[index].cooltime:SetShow(false)
    self._skillCoolTimeSlots[index].cooltimeText:SetShow(false)
  end
  local analogPad = ""
  PaGlobal_ConsoleKeyCombo:nextSkillUpdate(true, weaponType)
  self._isFirstSkillShow = true
end
function EventSkillCooltime(skillKey, skillNo)
  local self = PaGlobal_ConsoleKeyCombo
  self._skillCoolTimeKey = skillKey
end
function ConsoleKeyComboUpdateTime(updateTime)
  local isCombo = selfPlayerNextSkillConsoleSkillIsCombo()
  local self = PaGlobal_ConsoleKeyCombo
  if false == isCombo and false == self._isFirstSkillShow then
    self._ui._static_RotateBG:SetShow(false)
    self._ui._static_X:SetShow(false)
    self._ui._static_Y:SetShow(false)
    self._ui._static_A:SetShow(false)
    self._ui._static_B:SetShow(false)
    self._ui._static_clearX:SetShow(false)
    self._ui._static_clearY:SetShow(false)
    self._ui._static_clearA:SetShow(false)
    self._ui._static_clearB:SetShow(false)
    self._ui._comboDelay:SetShow(false)
    for index = 0, self._buttonMaxCount - 1 do
      self._skillCoolTimeSlots[index].icon:SetShow(false)
      self._skillCoolTimeSlots[index].cooltime:SetShow(false)
      self._skillCoolTimeSlots[index].cooltimeText:SetShow(false)
    end
    Panel_ConsoleCombo:SetShow(true)
    self._ui._comboDelay:SetProgressRate(0)
    self._currentTime = 0
    return
  end
  ConsoleSkillCoolTimeUpdateTime(updateTime)
  self._currentTime = self._currentTime + updateTime
  if self._isFirstSkillShow then
    self._ui._comboDelay:SetProgressRate(0)
  else
    self._ui._comboDelay:SetProgressRate(self._currentTime * 100 / self._delayTime)
  end
end
function ConsoleSkillCoolTimeUpdateTime(updateTime)
  local self = PaGlobal_ConsoleKeyCombo
  for index = 0, self._buttonMaxCount - 1 do
    if nil == self._coolTimeSkillNo[index] then
      return
    end
    if nil == self._coolTimeSkillIndex[index] then
      return
    end
    local skillNo = self._coolTimeSkillNo[index]
    local skillKey = selfPlayerNextSkillConsoleSkillKey(skillNo)
    local remainTime = getSkillCooltime(skillKey)
    local skillReuseTime = 0
    local realRemainTime = 0
    local intRemainTime = 0
    if remainTime > 0 and nil ~= self._skillCoolTimeSlots[index] then
      local skillStaticWrapper = getSkillStaticStatus(skillNo, 1)
      if nil ~= skillStaticWrapper then
        skillReuseTime = skillStaticWrapper:get()._reuseCycle / 1000
      end
      realRemainTime = remainTime * skillReuseTime
      intRemainTime = realRemainTime - realRemainTime % 1 + 1
      self._skillCoolTimeSlots[index].cooltime:UpdateCoolTime(remainTime)
      self._skillCoolTimeSlots[index].cooltimeText:SetText(Time_Formatting_ShowTop(intRemainTime))
      self._skillCoolTimeSlots[index].icon:SetShow(true)
      self._skillCoolTimeSlots[index].cooltime:SetShow(true)
      self._skillCoolTimeSlots[index].cooltimeText:SetShow(true)
    else
      self._skillCoolTimeSlots[index].cooltime:SetShow(false)
      self._skillCoolTimeSlots[index].cooltimeText:SetShow(false)
    end
  end
end
PaGlobal_ConsoleKeyCombo:initialize()
registerEvent("FromClient_consoleNextSkillList", "FromClient_consoleNextSkillList")
registerEvent("FromClient_consoleEffectButton", "FromClient_consoleEffectButton")
registerEvent("FromClient_consoleFirstSkill", "FromClient_consoleFirstSkill")
registerEvent("EventSkillCooltime", "EventSkillCooltime")
Panel_ConsoleCombo:RegisterUpdateFunc("ConsoleKeyComboUpdateTime")
