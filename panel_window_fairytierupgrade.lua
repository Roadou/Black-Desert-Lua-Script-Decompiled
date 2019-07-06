local PaGlobal_FairyTierUpgrade = {
  _ui = {
    _close = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Button_Win_Close"),
    _mainBG = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_MainBG"),
    _bottomDescBG = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_BottomBG"),
    _btn_TierUpgrade = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Button_Upgrade"),
    _tierUpgradeEffect = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_Block_TierUpgrade"),
    _resultSuccessEffect = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_Block_Success"),
    _resultFailEffect = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_Block_Fail"),
    _subjectItemBG = UI.getChildControl(Panel_Window_FairyTierUpgrade, "Static_SubjectIconBG")
  },
  _rim = {},
  _rimCount = 4,
  _rimSpeed = 2,
  _currentItemKey = nil,
  _currentItemSlotNo = nil,
  _currentItemStackCount = 0,
  _currentItemWhereType = nil,
  _currentItemCountInInventory = 0,
  _maxSuccessRate = 0,
  _maxSubjectCount = 0,
  _currentSuccessRate = 0,
  _isResultAnimating = false,
  _resultAniElapsed = 0,
  _resultAniLength = 3,
  _resultMessagePosX = 0,
  _resultMessagePosY = 232,
  _result = 0,
  _RIM_ANI_STATE = {
    IDLE = 1,
    ROTATING = 2,
    INDICATING = 3,
    WAITING_FOR_RESULT = 4
  },
  _RESULT_TYPE = {
    UNDEFINED = 0,
    SUCCESS = 1,
    FAIL = 2
  },
  _slotConfig = {
    createBorder = false,
    createCount = true,
    createCooltime = false,
    createCooltimeText = false,
    createCash = true,
    createEnchant = true,
    createQuickslotBagIcon = false
  }
}
local UI_TM = CppEnums.TextMode
function PaGlobal_FairyTierUpgrade:initialize()
  self._ui._close:addInputEvent("Mouse_LUp", "PaGlobal_FairyTierUpgrade_Close()")
  self._ui._btn_TierUpgrade:addInputEvent("Mouse_LUp", "FGlobal_OnClick_Button_TierUpgrade()")
  self._ui._text_SuccessChance = UI.getChildControl(self._ui._mainBG, "StaticText_SuccessChance")
  self._ui._percentageText = UI.getChildControl(self._ui._mainBG, "StaticText_Percentage")
  self._ui._percentMark = UI.getChildControl(self._ui._mainBG, "StaticText_PercentMark")
  self._ui._fairyBG = UI.getChildControl(self._ui._mainBG, "Static_FairyBG")
  self._ui._subjectItemBase = UI.getChildControl(self._ui._subjectItemBG, "Static_SubjectIcon")
  self._ui._subjectItem = {}
  SlotItem.new(self._ui._subjectItem, "subjectItem", nil, self._ui._subjectItemBase, self._slotConfig)
  self._ui._subjectItem:createChild()
  self._ui._subjectItem.icon:addInputEvent("Mouse_On", "PaGlobal_FairyTierUpgrade_ShowToolTip(true)")
  self._ui._subjectItem.icon:addInputEvent("Mouse_Out", "PaGlobal_FairyTierUpgrade_ShowToolTip(false)")
  self._ui._subjectItem.icon:addInputEvent("Mouse_RUp", "PaGlobal_FairyTierUpgrade_ClearFeedItem()")
  self._ui._subjectItem:clearItem()
  self._ui._buttonPlus = UI.getChildControl(self._ui._subjectItemBG, "Button_Plus")
  self._ui._buttonPlus:addInputEvent("Mouse_LUp", "PaGlobal_FairyTierUpgrade_OnClickPlusButton()")
  self._ui._buttonMinus = UI.getChildControl(self._ui._subjectItemBG, "Button_Minus")
  self._ui._buttonMinus:addInputEvent("Mouse_LUp", "PaGlobal_FairyTierUpgrade_OnClickMinusButton()")
  self._ui._buttonNumPad = UI.getChildControl(self._ui._subjectItemBG, "Button_NumPad")
  self._ui._buttonNumPad:addInputEvent("Mouse_LUp", "PaGlobal_FairyTierUpgrade_OnClickNumPadButton()")
  self._ui._bottomDescText = UI.getChildControl(self._ui._bottomDescBG, "StaticText_BottomDesc")
  self._ui._bottomDescText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._bottomDescText:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_TIERUPGRADE_DEC"))
  self._ui._bottomDescText:SetTextVerticalTop()
  local textYSize = self._ui._bottomDescText:GetTextSizeY()
  local stretchAmount = textYSize - self._ui._bottomDescBG:GetSizeY() + 40
  self._ui._bottomDescBG:SetSize(self._ui._bottomDescBG:GetSizeX(), textYSize + 30)
  Panel_Window_FairyTierUpgrade:SetSize(Panel_Window_FairyTierUpgrade:GetSizeX(), Panel_Window_FairyTierUpgrade:GetSizeY() + stretchAmount)
  self._ui._btn_TierUpgrade:ComputePos()
  self._ui._plusButtonEffect = UI.getChildControl(self._ui._subjectItemBG, "Static_Block_Plus")
  self._ui._minusButtonEffect = UI.getChildControl(self._ui._subjectItemBG, "Static_Block_Minus")
  for i = 1, self._rimCount do
    self._rim[i] = {}
    self._rim[i]._uiControl = UI.getChildControl(self._ui._fairyBG, "Static_Seq" .. tostring(i))
    self._rim[i]._currentDegree = 0
    self._rim[i]._rotateTarget = 0
    self._rim[i]._accel = 0
    self._rim[i]._aniValue = {}
    self._rim[i]._state = self._RIM_ANI_STATE.IDLE
  end
  Panel_Window_FairyTierUpgrade:RegisterUpdateFunc("UpdateFunc_FairyTierUpdateFunc")
end
function PaGlobal_FairyTierUpgrade_Open(PositionReset)
  local self = PaGlobal_FairyTierUpgrade
  ClothInventory_Close()
  if Panel_Window_FairySetting:GetShow() then
    PaGlobal_FairySetting_Close()
  end
  if Panel_Window_FairyUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_Close()
  end
  if Panel_Window_FairyTierUpgrade:GetShow() then
    self:close()
    return
  end
  if 0 == PaGlobal_FairyInfo_getUpgradeStack() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_ONTRY_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_NOTE_STACK"),
      functionApply = function()
      end,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if 0 < ToClient_getFairyUnsealedList() then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_ONTRY_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_NOTE_UNSEALED"),
      functionApply = function()
      end,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    return
  end
  if PaGlobal_FairyInfo_isMaxTier() then
    return
  end
  if true == PositionReset then
    self:setPosition()
  end
  HandleClicked_Inventory_FairyFeed_Open()
  Panel_Window_Inventory:SetShow(true)
  Inventory_SetFunctor(PaGlobal_Fairy_FilterForTierUpgrade, PaGlobal_FairyTierUpgrade_rClickCallback, PaGlobal_FairyTierUpgrade_Close, nil)
  self._ui._text_SuccessChance:SetShow(true)
  self._ui._percentMark:SetShow(true)
  self._ui._percentageText:SetShow(true)
  self._ui._percentageText:SetText("0")
  self:clearFeedItem()
  self._ui._subjectItem.icon:SetEnable(true)
  for i = 1, self._rimCount do
    self._rim[i]._currentDegree = math.random(-180, 180)
    self._rim[i]._rotateTarget = self._rim[i]._currentDegree
    self._rim[i]._uiControl:SetRotate(math.rad(self._rim[i]._currentDegree))
    self._rim[i]._accel = 0
    self._rim[i]._state = self._RIM_ANI_STATE.IDLE
    self:initIdleAnimation(self._rim[i])
  end
  Panel_Window_FairyTierUpgrade:SetPosY(Panel_Window_FairyTierUpgrade:GetPosY() - 60)
  Panel_Window_FairyTierUpgrade:SetShow(true)
  self._maxSuccessRate = ToClient_getFairyTierUpgradeMaxRate(PaGlobal_FairyInfo_FairyTier())
  self._ui._btn_TierUpgrade:SetMonoTone(false)
  registerEvent("FromClient_FairyTierUpgrade_Success", "FromClient_TierUpSuccess")
  registerEvent("FromClient_FairyTierUpgrade_Failed", "FromClient_TierUpFailed")
end
function PaGlobal_FairyTierUpgrade:clearFeedItem()
  self._ui._subjectItemBase:SetShow(false)
  self._currentItemKey = nil
  self._currentItemWrapper = nil
  self._currentItemSSW = nil
  self._currentItemStackCount = 0
  self._currentItemWhereType = nil
  self._currentItemSlotNo = nil
  self._ui._result = 0
  self._ui._buttonPlus:SetEnable(false)
  self._ui._buttonMinus:SetEnable(false)
  self._ui._buttonNumPad:SetEnable(false)
  self:setRimRotation(0, 0)
  self._isResultAnimating = false
  self._ui._percentageText:SetText("0")
  self._ui._subjectItem:clearItem()
  PaGlobal_FairyTierUpgrade_ShowToolTip(false)
end
function PaGlobal_Fairy_FilterForTierUpgrade(slotNo, notUse_itemWrappers, whereType)
  self._ui._currentItemWhereType = whereType
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  if itemWrapper:isFairyTierUpgradeItem(PaGlobal_FairyInfo_FairyTier()) then
    return false
  else
    return true
  end
end
function PaGlobal_FairyTierUpgrade_rClickCallback(slotNo, itemWrapper, count, invenType)
  if 0 == PaGlobal_FairyInfo_getUpgradeStack() then
    return
  end
  local self = PaGlobal_FairyTierUpgrade
  self:clearFeedItem()
  self._currentItemWrapper = itemWrapper
  self._currentItemSlotNo = slotNo
  self._currentItemKey = self._currentItemWrapper:get():getKey()
  if nil == self._currentItemKey then
    return
  end
  self._currentItemSSW = itemWrapper:getStaticStatus()
  self._currentItemCountInInventory = Int64toInt32(count)
  self._currentItemWhereType = invenType
  self._currentSuccessRate = ToClient_getFairyTierUpgradeRate(PaGlobal_FairyInfo_FairyTier(), self._currentItemKey)
  self._maxSubjectCount = math.floor(self._maxSuccessRate / self._currentSuccessRate)
  self._ui._subjectItemBase:SetShow(true)
  self._ui._subjectItem:setItemByStaticStatus(self._currentItemSSW, Defines.s64_const.s64_1)
  self:setSubjectItemCount(1)
  self._ui._buttonPlus:SetEnable(true)
  self._ui._buttonMinus:SetEnable(true)
  self._ui._buttonNumPad:SetEnable(true)
end
function PaGlobal_FairyTierUpgrade_OnClickNumPadButton()
  local self = PaGlobal_FairyTierUpgrade
  local availableSubjectCount = math.min(self._currentItemCountInInventory, self._maxSubjectCount)
  Panel_NumberPad_Show(true, toInt64(0, availableSubjectCount), nil, PaGlobal_FairyTierUpgrade_GetStackItemCountCallBack)
end
function PaGlobal_FairyTierUpgrade_GetStackItemCountCallBack(count)
  PaGlobal_FairyTierUpgrade:setSubjectItemCount(tonumber(tostring(count)))
end
function PaGlobal_FairyTierUpgrade_OnClickPlusButton()
  local self = PaGlobal_FairyTierUpgrade
  PaGlobal_FairyTierUpgrade:setSubjectItemCount(PaGlobal_FairyTierUpgrade._currentItemStackCount + 1)
  self._ui._plusButtonEffect:AddEffect("fUI_Fairy_TierUpgrade_02A", false, 0, 4)
end
function PaGlobal_FairyTierUpgrade_OnClickMinusButton()
  local self = PaGlobal_FairyTierUpgrade
  PaGlobal_FairyTierUpgrade:setSubjectItemCount(PaGlobal_FairyTierUpgrade._currentItemStackCount - 1)
  self._ui._minusButtonEffect:AddEffect("fUI_Fairy_TierUpgrade_02A", false, 0, 4)
end
function PaGlobal_FairyTierUpgrade:setSubjectItemCount(count)
  self._maxSubjectCount = math.floor(self._maxSuccessRate / self._currentSuccessRate)
  local availableSubjectCount = math.min(self._currentItemCountInInventory, self._maxSubjectCount)
  if count > availableSubjectCount then
    count = availableSubjectCount
  elseif count < 1 then
    count = 1
  end
  self._currentItemSSW = getItemEnchantStaticStatus(self._currentItemKey)
  self._currentItemStackCount = count
  self._ui._subjectItem:clearItem()
  self._ui._subjectItem:setItemByStaticStatus(self._currentItemSSW, toInt64(0, count))
  self._ui._percentageText:SetText(tostring(self:decimalRoundForPercentValue(self._currentSuccessRate / 10000 * self._currentItemStackCount)))
  if self._maxSubjectCount == self._currentItemStackCount then
    self._ui._percentageText:SetText("100")
  end
  local percentMarkPosX = self._ui._percentageText:GetPosX() + self._ui._percentageText:GetSizeX() / 2 + self._ui._percentageText:GetTextSizeX() / 2 + 5
  self._ui._percentMark:SetPosX(percentMarkPosX)
  self._ui._percentageText:ResetVertexAni()
  self._ui._percentageText:SetVertexAniRun("Percentage_Ani_Scale", true)
  self._ui._percentageText:SetVertexAniRun("Percentage_Ani_Move", true)
  local rimProgress = self._currentItemStackCount / self._maxSubjectCount
  local rimInPosition = math.floor(rimProgress * self._rimCount)
  local rimRemainder = rimProgress * self._rimCount - rimInPosition
  PaGlobal_FairyTierUpgrade:setRimRotation(rimInPosition, rimRemainder)
end
function PaGlobal_FairyTierUpgrade:setRimRotation(rimInPosition, rimRemainder)
  for i = 1, self._rimCount do
    if i <= rimInPosition then
      if 0 < self._rim[i]._currentDegree then
        if self._rim[i]._currentDegree < 90 then
          self._rim[i]._rotateTarget = 0
        else
          self._rim[i]._rotateTarget = 180
        end
      elseif self._rim[i]._currentDegree > -90 then
        self._rim[i]._rotateTarget = 0
      else
        self._rim[i]._rotateTarget = -180
      end
      self._rim[i]._state = self._RIM_ANI_STATE.ROTATING
    elseif rimRemainder > 0.01 then
      if 0 < self._rim[i]._currentDegree then
        if self._rim[i]._currentDegree < 90 then
          self._rim[i]._rotateTarget = 90 - rimRemainder * 90
        else
          self._rim[i]._rotateTarget = 90 + rimRemainder * 90
        end
      elseif self._rim[i]._currentDegree > -90 then
        self._rim[i]._rotateTarget = -90 + rimRemainder * 90
      else
        self._rim[i]._rotateTarget = -90 - rimRemainder * 90
      end
      rimRemainder = 0
      self._rim[i]._state = self._RIM_ANI_STATE.ROTATING
    else
      if self._RIM_ANI_STATE.IDLE ~= self._rim[i]._state then
        self._rim[i]._rotateTarget = math.random(-180, 180)
        self:initIdleAnimation(self._rim[i])
      end
      self._rim[i]._state = self._RIM_ANI_STATE.IDLE
    end
  end
end
function PaGlobal_FairyTierUpgrade_ClearFeedItem()
  PaGlobal_FairyTierUpgrade:clearFeedItem()
end
function FGlobal_OnClick_Button_TierUpgrade()
  if 0 == PaGlobal_FairyInfo_getUpgradeStack() then
    return
  end
  local self = PaGlobal_FairyTierUpgrade
  self._maxSubjectCount = math.floor(self._maxSuccessRate / self._currentSuccessRate)
  if self._currentItemStackCount >= self._maxSubjectCount then
    FGlobal_OnClick_Button_UpgradeConfirm()
  else
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_ONTRY_TITLE"),
      content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_FAIRYTIERUPGRADE_ONTRY_DESC", "percentage", tostring(self:decimalRoundForPercentValue(self._currentSuccessRate / 10000 * self._currentItemStackCount))),
      functionYes = FGlobal_OnClick_Button_UpgradeConfirm,
      functionNo = function()
      end,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function FGlobal_OnClick_Button_UpgradeConfirm()
  local self = PaGlobal_FairyTierUpgrade
  if nil == self._currentItemWrapper then
    return
  end
  if 0 == PaGlobal_FairyInfo_getUpgradeStack() then
    return
  end
  if 0 < ToClient_getFairyUnsealedList() then
    return
  end
  if PaGlobal_FairyInfo_isMaxTier() then
    return
  end
  self._ui._tierUpgradeEffect:AddEffect("fUI_Fairy_TierUpgrade_01A", false, 0, 4)
  ToClient_FairyTierUpgradeRequest(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemWhereType, self._currentItemSlotNo, self._currentItemStackCount)
  self._ui._buttonPlus:SetEnable(false)
  self._ui._buttonMinus:SetEnable(false)
  self._ui._buttonNumPad:SetEnable(false)
  self._ui._subjectItem.icon:SetEnable(false)
  for i = 1, self._rimCount do
    if i % 2 == 1 then
      self._rim[i]._accel = math.random(-1260, -900) / self._resultAniLength
    else
      self._rim[i]._accel = math.random(900, 1260) / self._resultAniLength
    end
    self._rim[i]._state = self._RIM_ANI_STATE.WAITING_FOR_RESULT
  end
  self._isResultAnimating = true
  self._ui._btn_TierUpgrade:SetMonoTone(true)
  audioPostEvent_SystemUi(21, 1)
  _AudioPostEvent_SystemUiForXBOX(21, 1)
end
function UpdateFunc_FairyTierUpdateFunc(deltaTime)
  local self = PaGlobal_FairyTierUpgrade
  for i = 1, self._rimCount do
    if self._RIM_ANI_STATE.IDLE == self._rim[i]._state then
      self:idleAnimation(self._rim[i], i, deltaTime)
    elseif self._RIM_ANI_STATE.ROTATING == self._rim[i]._state then
      self:rotating(self._rim[i], deltaTime)
    elseif self._RIM_ANI_STATE.INDICATING == self._rim[i]._state then
      self:indicating(self._rim[i], deltaTime)
    elseif self._RIM_ANI_STATE.WAITING_FOR_RESULT == self._rim[i]._state then
      self:waitingForResult(self._rim[i], deltaTime)
    end
  end
  if self._isResultAnimating then
    self:resultAniUpdate(deltaTime)
  end
end
function PaGlobal_FairyTierUpgrade:initIdleAnimation(rim)
  rim._aniValue[1] = math.random(0, 2 * math.pi)
  rim._aniValue[2] = math.random(2, 4)
  rim._aniValue[3] = math.random(3, 7)
end
function PaGlobal_FairyTierUpgrade:idleAnimation(rim, index, deltaTime)
  local acc = rim._rotateTarget - rim._currentDegree
  if 0.1 < math.abs(acc) then
    rim._accel = self:limitAcceleration(acc, 40) * self._rimSpeed
    rim._currentDegree = self:negate360Turn(rim._currentDegree + rim._accel * deltaTime)
    rim._uiControl:SetRotate(math.rad(rim._currentDegree))
  else
    rim._rotateTarget = rim._currentDegree
    if 2 * math.pi < rim._aniValue[1] then
      rim._aniValue[1] = 0
      self:initIdleAnimation(rim)
    end
    rim._aniValue[1] = rim._aniValue[1] + rim._aniValue[2] * deltaTime
    rim._accel = math.sin(rim._aniValue[1]) * rim._aniValue[3]
    rim._currentDegree = self:negate360Turn(rim._currentDegree + rim._accel * deltaTime)
    rim._uiControl:SetRotate(math.rad(rim._currentDegree))
  end
end
function PaGlobal_FairyTierUpgrade:rotating(rim, deltaTime)
  local acc = rim._rotateTarget - rim._currentDegree
  rim._accel = self:limitAcceleration(acc, 40) * self._rimSpeed
  rim._currentDegree = self:negate360Turn(rim._currentDegree + rim._accel * deltaTime)
  rim._uiControl:SetRotate(math.rad(rim._currentDegree))
  if 0.1 >= math.abs(acc) then
    rim._currentDegree = self:negate360Turn(rim._rotateTarget)
    rim._uiControl:SetRotate(math.rad(rim._currentDegree))
    rim._state = self._RIM_ANI_STATE.INDICATING
  end
end
function PaGlobal_FairyTierUpgrade:indicating(rim, deltaTime)
  rim._accel = 0
  rim._rotateTarget = 0
end
function PaGlobal_FairyTierUpgrade:waitingForResult(rim, deltaTime)
  rim._currentDegree = self:negate360Turn(rim._currentDegree + rim._accel * deltaTime)
  rim._uiControl:SetRotate(math.rad(rim._currentDegree))
  if not self._isResultAnimating then
    rim._accel = rim._accel * 0.9
  end
end
function PaGlobal_FairyTierUpgrade:resultAniUpdate(deltaTime)
  self._resultAniElapsed = self._resultAniElapsed + deltaTime
  if self._resultAniLength < self._resultAniElapsed then
    self._isResultAnimating = false
    self._resultAniElapsed = 0
    self:onResultAnimationFinish()
  end
end
function FromClient_TierUpSuccess()
  PaGlobal_FairyTierUpgrade._result = PaGlobal_FairyTierUpgrade._RESULT_TYPE.SUCCESS
end
function FromClient_TierUpFailed()
  PaGlobal_FairyTierUpgrade._result = PaGlobal_FairyTierUpgrade._RESULT_TYPE.FAIL
end
function PaGlobal_FairyTierUpgrade:onResultAnimationFinish()
  if self._result == self._RESULT_TYPE.UNDEFINED then
    self._isResultAnimating = true
    self._resultAniElapsed = 0
  else
    self:setSubjectItemCount(0)
    self:clearFeedItem()
    self._ui._subjectItem:clearItem()
    self._ui._text_SuccessChance:SetShow(false)
    self._ui._percentageText:SetShow(false)
    self._ui._percentMark:SetShow(false)
    if self._result == self._RESULT_TYPE.SUCCESS then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoSuccessFairyUpgrade"), 1.6, Panel_Window_FairyTierUpgrade:GetPosX() + self._resultMessagePosX, Panel_Window_FairyTierUpgrade:GetPosY() + self._resultMessagePosY)
      self._ui._resultSuccessEffect:AddEffect("fUI_Fairy_TierUpgrade_Success_01A", false, 0, 4)
      audioPostEvent_SystemUi(21, 2)
      _AudioPostEvent_SystemUiForXBOX(21, 2)
    elseif self._result == self._RESULT_TYPE.FAIL then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoFailFairyUpgrade"), 1.6, Panel_Window_FairyTierUpgrade:GetPosX() + self._resultMessagePosX, Panel_Window_FairyTierUpgrade:GetPosY() + self._resultMessagePosY)
      self._ui._resultFailEffect:AddEffect("fUI_Fairy_TierUpgrade_Fail_01A", false, 0, 4)
    end
  end
end
function PaGlobal_FairyTierUpgrade:limitAcceleration(val, limit)
  if limit < val then
    return limit
  elseif val < -limit then
    return -limit
  else
    return val
  end
end
function PaGlobal_FairyTierUpgrade:negate360Turn(degree)
  if degree > 360 then
    return degree - 360
  elseif degree < -360 then
    return degree + 360
  else
    return degree
  end
end
function PaGlobal_FairyTierUpgrade:decimalRoundForPercentValue(value)
  if value >= 100 then
    return 100
  elseif value > 99 and value < 100 then
    return 99
  elseif value > 0 and value < 1 then
    return 1
  else
    return math.floor(value)
  end
end
function PaGlobal_FairyTierUpgrade:setPosition()
  Panel_Window_FairyTierUpgrade:SetPosX(Panel_FairyInfo:GetPosX() + Panel_FairyInfo:GetSizeX() / 2 - Panel_Window_FairyTierUpgrade:GetSizeX() / 2)
  Panel_Window_FairyTierUpgrade:SetPosY(Panel_FairyInfo:GetPosY() + 20)
end
function PaGlobal_FairyTierUpgrade_ShowToolTip(isShow)
  local self = PaGlobal_FairyTierUpgrade
  if nil ~= self._currentItemKey then
    local itemSSW = getItemEnchantStaticStatus(self._currentItemKey)
  end
  if nil == itemSSW then
    return
  end
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._ui._subjectItemBase, "fairyTierUpgrade")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_FairyTierUpgrade, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_FairyTierUpgrade_Close()
  PaGlobal_FairyTierUpgrade:close()
end
function PaGlobal_FairyTierUpgrade:close()
  self:clearFeedItem()
  Panel_Window_FairyTierUpgrade:SetShow(false)
  HandleClicked_InventoryWindow_Close()
  self._ui._subjectItem:clearItem()
end
function FromClient_luaLoadComplete_Panel_Window_FairyTierUpgrade()
  PaGlobal_FairyTierUpgrade:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Window_FairyTierUpgrade")
