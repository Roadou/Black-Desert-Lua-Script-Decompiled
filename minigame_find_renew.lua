PaGlobal_MiniGame_Find = {
  _ui = {
    _baseOpenSlot = UI.getChildControl(Panel_MiniGame_Find, "Static_OpenSlot"),
    _baseCloseSlot = UI.getChildControl(Panel_MiniGame_Find, "Static_CloseSlot"),
    _closeButton = UI.getChildControl(Panel_MiniGame_Find, "Button_Win_Close"),
    _rightBG = UI.getChildControl(Panel_MiniGame_Find, "Static_RightBg"),
    _startMsg = UI.getChildControl(Panel_MiniGame_Find, "Static_Msg"),
    _timerMsg = UI.getChildControl(Panel_MiniGame_MiniGameResult, "StaticText_Msg"),
    _staticObjBg = UI.getChildControl(Panel_MiniGame_Find, "Static_Body"),
    _descBg = UI.getChildControl(Panel_MiniGame_Find, "Static_BottomBg"),
    _facePicture = UI.getChildControl(Panel_MiniGame_Find, "Static_Obsidian"),
    _bubbleBg = UI.getChildControl(Panel_MiniGame_Find, "Static_Obsidian_B"),
    _maskBg = UI.getChildControl(Panel_MiniGame_Find, "Static_MaskBg"),
    _tutorialStep_1 = UI.getChildControl(Panel_MiniGame_Find, "Static_TutorialStep_1"),
    _tutorialStep_2 = UI.getChildControl(Panel_MiniGame_Find, "Static_TutorialStep_2"),
    _tutorialStep_3 = UI.getChildControl(Panel_MiniGame_Find, "Static_TutorialStep_3")
  },
  _config = {
    _slotCols = 16,
    _slotRows = 16,
    _totalSlotSize = 576,
    _slotStartPosX = 13,
    _slotStartPosY = 45,
    _rewardMaxCount = 6,
    _nextGameSec = 3,
    _endGameSec = 5,
    _slotTypeDefault = 0,
    _slotTypeEmpty = 1,
    _slotTypeMain = 2,
    _slotTypeSub = 3,
    _slotTypeTrap = 5
  },
  _clickType = {LClcik = 1, RClcik = 2},
  _state = {
    None = 0,
    Play = 1,
    Wait = 2,
    Reward = 3
  },
  _rewardSlotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _slots = Array.new(),
  _rewardSlot = Array.new(),
  _damageSlot = Array.new(),
  _gameState = nil,
  _readyToEndGame = false,
  _readyToNextGame = false,
  _curSec = 0,
  _gameCurDepth = 0,
  _gameLastDepth = 0,
  _curRClickCount = 0,
  _addSize = 16,
  _curSlotSize = 0,
  _stateMsgKey = 0,
  _tutorialOpen = 0,
  _tutorialTime = 0,
  _tutorialIndex = -1,
  _tutorialEffectShow = false,
  _isFirstTouch = {
    _ground = true,
    _root = true,
    _stone = true
  }
}
function PaGlobal_MiniGame_Find:initialize()
  self._ui._rightTopBG = UI.getChildControl(self._ui._rightBG, "Static_TopBg")
  self._ui._endurance = UI.getChildControl(self._ui._rightTopBG, "StaticText_DDPercent")
  self._ui._RClickCnt = UI.getChildControl(self._ui._rightTopBG, "StaticText_RClickCount")
  self._ui._LeftValueBg = UI.getChildControl(self._ui._rightBG, "Static_LeftValueBg")
  self._ui._damageGauge = UI.getChildControl(self._ui._rightBG, "Progress2_DamageDegree")
  self._ui._slotBackground = UI.getChildControl(self._ui._rightBG, "Static_RewardSlotBg")
  self._ui._focusSlot = UI.getChildControl(self._ui._rightBG, "Static_CurrentSlotFocus")
  self._ui._gameDepth = UI.getChildControl(self._ui._rightBG, "StaticText_GradeTitle")
  self._ui._curRewardSlot = UI.getChildControl(self._ui._rightBG, "Static_CurrentSlotFocus")
  self._ui._commercialValue = UI.getChildControl(self._ui._rightBG, "StaticText_CommercialValue")
  self._ui._emptyCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_LandCountValue")
  self._ui._subObjCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_RootCountValue")
  self._ui._trapCnt = UI.getChildControl(self._ui._LeftValueBg, "StaticText_StoneCountValue")
  self._ui._bubbleText = UI.getChildControl(self._ui._bubbleBg, "StaticText_BubbleText")
  self._ui._tutorialMaskBg_1 = UI.getChildControl(self._ui._tutorialStep_1, "Static_MaskingBg")
  self._ui._tutorialFocus_1 = UI.getChildControl(self._ui._tutorialStep_1, "Static_Focus")
  self._ui._tutorialMaskBg_2 = UI.getChildControl(self._ui._tutorialStep_2, "Static_MaskingBg")
  self._ui._tutorialFocus_2 = UI.getChildControl(self._ui._tutorialStep_2, "Static_Focus")
  self._ui._tutorialMaskBg_3 = UI.getChildControl(self._ui._tutorialStep_3, "Static_MaskingBg")
  self._ui._tutorialFocus_3 = UI.getChildControl(self._ui._tutorialStep_3, "Static_Focus")
  self._ui._msgDesc = UI.getChildControl(self._ui._startMsg, "StaticText_Desc")
  self._ui._left = UI.getChildControl(self._ui._startMsg, "StaticText_MouseL_Desc")
  self._ui._right = UI.getChildControl(self._ui._startMsg, "StaticText_MouseR_Desc")
  self:createSlot()
  self:createRewardSlot()
  self:registEventHandler()
  self._messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_NOREWARDALERT"),
    functionYes = FGlobal_MiniGameFind_Close,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  self._ui._desc = UI.getChildControl(self._ui._descBg, "StaticText_BottomDesc")
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._desc:SetText(self._ui._desc:GetText())
  local textSizeY = self._ui._desc:GetTextSizeY() + 7
  local bgSizeY = self._ui._descBg:GetSizeY()
  local sumSizeY = textSizeY - bgSizeY
  self._ui._descBg:SetSize(self._ui._descBg:GetSizeX(), textSizeY)
  if sumSizeY > 0 then
    Panel_MiniGame_Find:SetSize(Panel_MiniGame_Find:GetSizeX(), Panel_MiniGame_Find:GetSizeY() + sumSizeY)
    self._ui._rightBG:SetSize(self._ui._rightBG:GetSizeX(), self._ui._rightBG:GetSizeY() + sumSizeY)
    self._ui._desc:ComputePos()
  end
  Panel_MiniGame_Find:SetShow(false)
  self._tutorialOpen = ToClient_getGameUIManagerWrapper():getLuaCacheDataListNumber(__eRakiaroTutorial)
  self._ui._maskBg:SetShow(false)
  self._ui._startMsg:SetShow(false)
end
function PaGlobal_MiniGame_Find:TutorialNextStep()
  local self = PaGlobal_MiniGame_Find
  self._ui._tutorialStep_1:SetShow(false)
  self._ui._tutorialStep_2:SetShow(false)
  self._ui._tutorialStep_3:SetShow(false)
  self._tutorialIndex = self._tutorialIndex + 1
  self._tutorialEffectShow = false
  PaGlobal_MiniGame_Find:bubbleShow()
end
function PaGlobal_MiniGame_Find:close()
  self._gameState = self._state.None
  self._readyToNextGame = false
  self._readyToEndGame = false
  self._stateMsgKey = 0
  for _, slot in pairs(self._damageSlot) do
    slot:SetShow(false)
  end
  self._damageSlot = {}
  Panel_MiniGame_MiniGameResult:SetShow(false)
  Panel_MiniGame_Find:SetShow(false)
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eRakiaroTutorial, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
  self._tutorialOpen = 1
  self._ui._maskBg:SetShow(false)
  self._ui._bubbleBg:SetShow(false)
  self._ui._tutorialStep_1:SetShow(false)
  self._ui._tutorialStep_2:SetShow(false)
  self._ui._tutorialStep_3:SetShow(false)
  ToClient_MiniGameFindHide()
end
function PaGlobal_MiniGame_Find:createSlot()
  for col = 0, self._config._slotCols - 1 do
    self._slots[col] = Array.new()
    for row = 0, self._config._slotRows - 1 do
      local slot = {
        close = nil,
        open = nil,
        damage = nil,
        isOpen = false
      }
      slot.close = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "Slot_Close_" .. col .. "_" .. row)
      slot.open = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "Slot_Open_" .. col .. "_" .. row)
      slot.damage = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "Slot_Damage_" .. col .. "_" .. row)
      CopyBaseProperty(self._ui._baseCloseSlot, slot.close)
      CopyBaseProperty(self._ui._baseOpenSlot, slot.open)
      CopyBaseProperty(self._ui._baseCloseSlot, slot.damage)
      slot.close:SetShow(false)
      slot.close:SetEnable(true)
      slot.open:SetShow(false)
      slot.open:SetEnable(false)
      slot.damage:SetShow(false)
      slot.damage:SetEnable(false)
      slot.isOpen = false
      slot.close:addInputEvent("Mouse_On", "PaGlobal_MiniGame_Find:OnCloseSlot(" .. col .. "," .. row .. ", true)")
      slot.close:addInputEvent("Mouse_Out", "PaGlobal_MiniGame_Find:OnCloseSlot(" .. col .. "," .. row .. ", false)")
      slot.close:addInputEvent("Mouse_LUp", "PaGlobal_MiniGame_Find:ClickCloseSlot(" .. col .. "," .. row .. "," .. self._clickType.LClcik .. ")")
      slot.close:addInputEvent("Mouse_RUp", "PaGlobal_MiniGame_Find:ClickCloseSlot(" .. col .. "," .. row .. "," .. self._clickType.RClcik .. ")")
      self._slots[col][row] = slot
    end
  end
  self._ui._mainObjBG = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_MiniGame_Find, "MainObjBG")
  CopyBaseProperty(self._ui._staticObjBg, self._ui._mainObjBG)
  self._ui._mainObjBG:SetShow(false)
  Panel_MiniGame_Find:SetChildIndex(self._ui._maskBg, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._tutorialStep_1, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._tutorialStep_2, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._tutorialStep_3, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._bubbleBg, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._facePicture, 9999)
  Panel_MiniGame_Find:SetChildIndex(self._ui._startMsg, 9999)
end
function PaGlobal_MiniGame_Find:registEventHandler()
  Panel_MiniGame_Find:RegisterUpdateFunc("FGlobal_MiniGameFind_Update")
  self._ui._closeButton:addInputEvent("Mouse_LUp", "PaGlobal_MiniGame_Find:askGameClose()")
  self._ui._maskBg:addInputEvent("Mouse_LUp", "PaGlobal_MiniGame_Find:TutorialNextStep()")
  registerEvent("FromClient_MiniGameFindSlotShowEmpty", "FromClient_MiniGameFindSlotShowEmpty")
  registerEvent("FromClient_MiniGameFindSlotShowMain", "FromClient_MiniGameFindSlotShowMain")
  registerEvent("FromClient_MiniGameFindSlotShowMainTexture", "FromClient_MiniGameFindSlotShowMainTexture")
  registerEvent("FromClient_MiniGameFindSlotShowSub", "FromClient_MiniGameFindSlotShowSub")
  registerEvent("FromClient_MiniGameFindSlotShowTrap", "FromClient_MiniGameFindSlotShowTrap")
  registerEvent("FromClient_MiniGameFindSetShow", "FromClient_MiniGameFindSetShow")
  registerEvent("FromClient_MiniGameFindSetReward", "FromClient_MiniGameFindSetReward")
  registerEvent("FromClient_MiniGameFindSetState", "FromClient_MiniGameFindSetState")
  registerEvent("FromClient_MiniGameFindDefaultImage", "FromClient_MiniGameFindDefaultImage")
  registerEvent("FromClient_MiniGameFindDynamicInfo", "FromClient_MiniGameFindDynamicInfo")
  registerEvent("FromClient_MiniGameFindStaticInfo", "FromClient_MiniGameFindStaticInfo")
end
function PaGlobal_MiniGame_Find:OnCloseSlot(col, row, isOn)
  local slot = self._slots[col][row]
  if true == slot.isOpen then
    return
  end
  if true == isOn then
    slot.close:SetSize(self._curSlotSize + 4, self._curSlotSize + 4)
    slot.close:SetPosX(self._config._slotStartPosX + self._curSlotSize * col - 2)
    slot.close:SetPosY(self._config._slotStartPosY + self._curSlotSize * row - 2)
  else
    slot.close:SetSize(self._curSlotSize, self._curSlotSize)
    slot.close:SetPosX(self._config._slotStartPosX + self._curSlotSize * col)
    slot.close:SetPosY(self._config._slotStartPosY + self._curSlotSize * row)
  end
end
function PaGlobal_MiniGame_Find:ClickCloseSlot(col, row, clickType)
  local slot = self._slots[col][row]
  if true == slot.isOpen then
    return
  end
  if self._clickType.LClcik == clickType then
    audioPostEvent_SystemUi(11, 31)
  else
    audioPostEvent_SystemUi(11, 32)
    self._ui._RClickCnt:AddEffect("fUI_Light", false, 5, 0)
    if 0 >= self._tmpRClickCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MINIGAME_FINDROOT_RCLICKCOUNTTITLE_1"))
      return
    end
  end
  ToClient_MiniGameFindClick(col, row, clickType)
end
function PaGlobal_MiniGame_Find:endGame()
  for row = 0, self._config._slotRows - 1 do
    for col = 0, self._config._slotCols - 1 do
      local slot = self._slots[col][row]
      slot.close:SetEnable(false)
    end
  end
  audioPostEvent_SystemUi(11, 33)
end
function PaGlobal_MiniGame_Find:refresh(slotMaxCol, slotMaxRow)
  local slotSize = self._config._totalSlotSize / slotMaxCol
  for row = 0, self._config._slotRows - 1 do
    for col = 0, self._config._slotCols - 1 do
      local slot = self._slots[col][row]
      slot.isOpen = false
      if slotMaxCol <= col or slotMaxRow <= row then
        slot.close:SetShow(false)
        slot.close:SetEnable(false)
        slot.open:SetShow(false)
        slot.damage:SetShow(false)
      else
        slot.close:SetSize(slotSize, slotSize)
        slot.close:SetPosX(self._config._slotStartPosX + slotSize * col)
        slot.close:SetPosY(self._config._slotStartPosY + slotSize * row)
        slot.close:SetShow(true)
        slot.close:SetEnable(true)
        slot.close:setOnMouseCursorType(__eMouseCursorType_Dig)
        slot.close:setClickMouseCursorType(__eMouseCursorType_Dig)
        slot.open:SetSize(slotSize, slotSize)
        slot.open:SetPosX(self._config._slotStartPosX + slotSize * col)
        slot.open:SetPosY(self._config._slotStartPosY + slotSize * row)
        slot.open:SetShow(false)
        slot.damage:SetSize(slotSize, slotSize)
        slot.damage:SetPosX(self._config._slotStartPosX + slotSize * col)
        slot.damage:SetPosY(self._config._slotStartPosY + slotSize * row)
        slot.damage:SetShow(false)
      end
    end
  end
  self._curSlotSize = slotSize
  self._ui._mainObjBG:SetSize(self._mainColCnt * slotSize + self._addSize, self._mainRowCnt * slotSize + self._addSize)
end
function PaGlobal_MiniGame_Find:askGameClose()
  if self._state.None == self._gameState then
    self:close()
  else
    MessageBox.showMessageBox(self._messageBoxData)
  end
end
function PaGlobal_MiniGame_Find:createRewardSlot()
  self._ui._slotBackground:SetShow(false)
  for ii = 0, self._config._rewardMaxCount - 1 do
    local slot = {}
    slot.background = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._rightBG, "RewardItemBG_" .. ii)
    CopyBaseProperty(self._ui._slotBackground, slot.background)
    slot.background:SetPosY(185 + ii * 65)
    slot.background:SetShow(true)
    SlotItem.new(slot, "RewardItemIcon_" .. ii, ii, slot.background, self._rewardSlotConfig)
    slot:createChild()
    slot.icon:SetPosX(4)
    slot.icon:SetPosY(4)
    slot.icon:SetShow(true)
    slot.icon:addInputEvent("Mouse_On", "PaGlobal_MiniGame_Find:itemTooltip_Show(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobal_MiniGame_Find:itemTooltip_Hide()")
    self._rewardSlot[ii] = slot
  end
end
function PaGlobal_MiniGame_Find:itemTooltip_Show(index)
  local itemSSW = getItemEnchantStaticStatus(self._rewardSlot[index].itemNo)
  if nil ~= itemSSW then
    Panel_Tooltip_Item_SetPosition(index, self._rewardSlot[index], "minigameFindReward")
    Panel_Tooltip_Item_Show(itemSSW, Panel_MiniGame_Find, true)
  end
end
function PaGlobal_MiniGame_Find:itemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_MiniGame_Find:getRewardIndex(pct)
  if 100 == pct then
    return 0
  else
    for ii = 1, self._config._rewardMaxCount - 1 do
      if pct <= ii * 20 then
        return self._config._rewardMaxCount - ii
      end
    end
    return self._config._rewardMaxCount - 1
  end
end
function PaGlobal_MiniGame_Find:nextGameStart()
  Panel_MiniGame_MiniGameResult:SetShow(false)
  self._readyToNextGame = false
  if self._gameCurDepth + 1 <= self._gameLastDepth then
    ToClient_MiniGameFindNext()
  end
end
function FGlobal_MiniGameFind_RefreshText(isMsgShow)
  local self = PaGlobal_MiniGame_Find
  local itemWrapper = ToClient_getEquipmentItem(CppEnums.EquipSlotNoClient.eEquipSlotNoSubTool)
  if itemWrapper ~= nil then
    local grade = itemWrapper:getStaticStatus():getGradeType()
    local lv = 0
    if 0 ~= itemWrapper:get():getEndurance() then
      lv = itemWrapper:get():getKey():getEnchantLevel()
    end
    local RClickCount = ToClient_MiniGameFindMaxRClickCount(grade, lv) - self._curRClickCount
    if RClickCount < 0 then
      RClickCount = 0
    end
    if RClickCount ~= self._tmpRClickCount then
      self._ui._RClickCnt:AddEffect("fUI_Light", false, 5, 0)
      self._tmpRClickCount = RClickCount
      if true == isMsgShow then
        if RClickCount > 0 then
          local strMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_RCLICK", "rclick", RClickCount)
          Proc_ShowMessage_Ack(strMsg)
        else
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MINIGAME_FINDROOT_RCLICKCOUNTTITLE_1"))
        end
      end
    end
    self._ui._RClickCnt:SetText(tostring(RClickCount))
    self._ui._endurance:SetText(tostring(itemWrapper:get():getEndurance()))
  end
end
function FGlobal_MiniGameFind_Close()
  PaGlobal_MiniGame_Find:close()
end
local __Tutorial_Update = function(deltaTime)
  local self = PaGlobal_MiniGame_Find
  if -1 == self._tutorialIndex then
    self._tutorialTime = self._tutorialTime + deltaTime
    if self._tutorialTime > 0.5 then
      self._tutorialIndex = 0
      self:bubbleShow()
      self._tutorialTime = 0
    end
  end
end
function PaGlobal_MiniGame_Find:bubbleShow()
  local self = PaGlobal_MiniGame_Find
  if 0 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_1"))
    local textSizeX = self._ui._bubbleText:GetTextSizeX()
    self._ui._bubbleBg:SetSize(textSizeX + 25, self._ui._bubbleBg:GetSizeY())
  elseif 1 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_2"))
    if not self._tutorialEffectShow then
      self:StartTutorial(0)
      self._tutorialEffectShow = true
    end
  elseif 2 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_3"))
    if not self._tutorialEffectShow then
      self:StartTutorial(2)
      self._tutorialEffectShow = true
    end
  elseif 3 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_4"))
    local textSizeX = self._ui._bubbleText:GetTextSizeX()
    self._ui._bubbleBg:SetSize(textSizeX + 25, self._ui._bubbleBg:GetSizeY())
    if not self._tutorialEffectShow then
      self:StartTutorial(2)
      self._tutorialEffectShow = true
    end
  elseif 4 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_5"))
    if not self._tutorialEffectShow then
      self:StartTutorial(1)
      self._tutorialEffectShow = true
    end
  elseif 5 == self._tutorialIndex then
    self._ui._maskBg:SetShow(true)
    self._ui._facePicture:SetShow(true)
    self._ui._facePicture:EraseAllEffect()
    self._ui._facePicture:AddEffect("fUI_DarkSpirit_Tutorial", true, 0, 0)
    self._ui._bubbleBg:SetShow(true)
    self._ui._bubbleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMEFIND_TUTORIALDESC_6"))
    local textSizeX = self._ui._bubbleText:GetTextSizeX()
    self._ui._bubbleBg:SetSize(textSizeX + 25, self._ui._bubbleBg:GetSizeY())
    self._tutorialEffectShow = false
  else
    self._ui._maskBg:SetShow(false)
    self._ui._facePicture:SetShow(false)
    self._ui._facePicture:EraseAllEffect()
    self._ui._bubbleBg:SetShow(false)
    ToClient_getGameUIManagerWrapper():setLuaCacheDataListNumber(__eRakiaroTutorial, 1, CppEnums.VariableStorageType.eVariableStorageType_User)
    self._tutorialOpen = 1
    self:StartMsg(self._ui._startMsg)
    self:HideMsg(4, 5)
  end
end
local __NoneState_Update = function(deltaTime)
  local self = PaGlobal_MiniGame_Find
  if self._gameState ~= self._state.None then
    return
  end
  if false == self._readyToEndGame then
    return
  end
  self._curSec = self._curSec + deltaTime
  local strMsg = ""
  if 1 == self._stateMsgKey then
    strMsg = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_FINISH")
  elseif 2 == self._stateMsgKey then
    strMsg = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_FINISH_01")
  elseif 3 == self._stateMsgKey then
    strMsg = PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_FINISH_02")
  elseif 4 == self._stateMsgKey then
  end
  self._ui._timerMsg:SetText(strMsg)
  if self._config._endGameSec <= self._curSec then
    self:close()
  end
end
local __WaitState_Update = function(deltaTime)
  local self = PaGlobal_MiniGame_Find
  if self._gameState ~= self._state.Wait then
    return
  end
  if false == self._readyToNextGame then
    return
  end
  self._curSec = self._curSec + deltaTime
  local strMsg = ""
  if 1 == self._stateMsgKey then
    strMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_LEFTTIME", "second", math.floor(self._config._nextGameSec - self._curSec + 1))
  elseif 2 == self._stateMsgKey then
    strMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_LEFTTIME_01", "second", math.floor(self._config._nextGameSec - self._curSec + 1))
  elseif 3 == self._stateMsgKey then
    strMsg = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_LEFTTIME_02", "second", math.floor(self._config._nextGameSec - self._curSec + 1))
  elseif 4 == self._stateMsgKey then
  end
  self._ui._timerMsg:SetText(strMsg)
  if self._config._nextGameSec <= self._curSec then
    self:nextGameStart()
  end
end
function PaGlobal_MiniGame_Find:StartTutorial(index)
  if 0 == index then
    self._ui._tutorialStep_1:SetShow(true)
    self._ui._tutorialMaskBg_1:SetShow(false)
    self._ui._tutorialFocus_1:SetShow(true)
    self._ui._tutorialFocus_1:ResetVertexAni()
    self._ui._tutorialFocus_1:SetVertexAniRun("Ani_Scale_New1", true)
    self._ui._tutorialFocus_1:SetVertexAniRun("Ani_Move_Pos_New1", true)
  elseif 1 == index then
    self._ui._tutorialStep_2:SetShow(true)
    self._ui._tutorialMaskBg_2:SetShow(false)
    self._ui._tutorialFocus_2:SetShow(true)
    self._ui._tutorialFocus_2:ResetVertexAni()
    self._ui._tutorialFocus_2:SetVertexAniRun("Ani_Scale_New2", true)
    self._ui._tutorialFocus_2:SetVertexAniRun("Ani_Move_Pos_New2", true)
  elseif 2 == index then
    self._ui._tutorialStep_3:SetShow(true)
    self._ui._tutorialMaskBg_3:SetShow(false)
    self._ui._tutorialFocus_3:SetShow(true)
    self._ui._tutorialFocus_3:ResetVertexAni()
    self._ui._tutorialFocus_3:SetVertexAniRun("Ani_Scale_New3", true)
    self._ui._tutorialFocus_3:SetVertexAniRun("Ani_Move_Pos_New3", true)
  end
  local textSizeX = self._ui._bubbleText:GetTextSizeX()
  self._ui._bubbleBg:SetSize(textSizeX + 25, self._ui._bubbleBg:GetSizeY())
end
local alphaDirChange = false
local alphaValue = 0
local function __DamageSlot_Update(deltaTime)
  local self = PaGlobal_MiniGame_Find
  if self._gameState ~= self._state.Play then
    return
  end
  if false == alphaDirChange then
    alphaValue = alphaValue + deltaTime / 2
    if alphaValue > 0.8 then
      alphaValue = 0.8
      alphaDirChange = true
    end
  else
    alphaValue = alphaValue - deltaTime / 2
    if alphaValue < 0 then
      alphaValue = 0
      alphaDirChange = false
    end
  end
  for _, slot in pairs(self._damageSlot) do
    slot:SetAlpha(alphaValue)
  end
end
function FGlobal_MiniGameFind_Update(deltaTime)
  if PaGlobal_MiniGame_Find._tutorialOpen <= 0 then
    __Tutorial_Update(deltaTime)
    return
  end
  __NoneState_Update(deltaTime)
  __WaitState_Update(deltaTime)
  __DamageSlot_Update(deltaTime)
end
function PaGlobal_MiniGame_Find:BubbleHideAni()
  local closeAni = self._ui._bubbleBg:addColorAnimation(4.8, 5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function PaGlobal_MiniGame_Find:StartMsg(control)
  local showAni = control:addMoveAnimation(0, 0.2, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartPosition(control:GetPosX(), control:GetPosY() - control:GetSizeY())
  showAni:SetEndPosition(control:GetPosX(), control:GetPosY())
  control:CalcUIAniPos(showAni)
  showAni:SetDisableWhileAni(true)
  control:SetShow(true)
end
function PaGlobal_MiniGame_Find:HideMsg(startTime, endTime)
  local closeAni = self._ui._startMsg:addColorAnimation(startTime, endTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function FromClient_MiniGameFindSlotShowEmpty(col, row, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
  self._slots[col][row].isOpen = true
  slot:setOnMouseCursorType(__eMouseCursorType_Default)
  slot:setClickMouseCursorType(__eMouseCursorType_Default)
  slot:SetSize(self._curSlotSize, self._curSlotSize)
  slot:SetPosX(self._config._slotStartPosX + self._curSlotSize * col)
  slot:SetPosY(self._config._slotStartPosY + self._curSlotSize * row)
  slot:AddEffect("fUI_Minigame_Lbutton", false, 0, 0)
end
function FromClient_MiniGameFindSlotShowMain(col, row)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  if false == self._isMainLoad then
    self._ui._mainObjBG:SetPosX(slot:GetPosX() - self._addSize / 2)
    self._ui._mainObjBG:SetPosY(slot:GetPosY() - self._addSize / 2)
    self._ui._mainObjBG:SetShow(true)
    self._isMainLoad = true
  end
  slot:SetEnable(false)
end
function FromClient_MiniGameFindSlotShowMainTexture(mainColCnt, mainRowCnt, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  self._mainColCnt = mainColCnt
  self._mainRowCnt = mainRowCnt
  self._ui._mainObjBG:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(self._ui._mainObjBG, uv0, uv1, uv2, uv3)
  self._ui._mainObjBG:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  self._ui._mainObjBG:setRenderTexture(self._ui._mainObjBG:getBaseTexture())
end
local __InsertDamageSlot = function(col, row, uv0, uv1, uv2, uv3)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].damage
  slot:ChangeTextureInfoName("New_UI_Common_forLua/Window/MiniGame/MiniGameFind_05.dds")
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
  slot:SetShow(true)
  table.insert(self._damageSlot, slot)
end
function FromClient_MiniGameFindSlotShowSub(col, row, uv0, uv1, uv2, uv3, imagePath, isSuccess)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].open
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
  slot:SetShow(true)
  slot:AddEffect("fUI_Minigame_Lbutton", false, 0, 0)
  if false == isSuccess then
    __InsertDamageSlot(col, row, uv0, uv1, uv2, uv3)
  end
end
function FromClient_MiniGameFindSlotShowTrap(col, row, stoneType)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].open
  slot:ChangeTextureInfoName("New_UI_Common_forLua/Window/MiniGame/MiniGameFind_01.dds")
  if 0 == stoneType then
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, 1, 295, 54, 348)
    slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  else
    local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, 1, 349, 54, 402)
    slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  end
  slot:setRenderTexture(slot:getBaseTexture())
  self._slots[col][row].open:SetShow(true)
  slot:AddEffect("fUI_Minigame_Rbutton", false, 0, 0)
  audioPostEvent_SystemUi(11, 34)
end
function FromClient_MiniGameFindDynamicInfo(damageRate, RClickCount, emptyCount, subObjCount, trapCount)
  local self = PaGlobal_MiniGame_Find
  local curPercent = damageRate / 10000
  if curPercent <= 0 then
    curPercent = 0
  end
  self._curRClickCount = RClickCount
  FGlobal_MiniGameFind_RefreshText(true)
  self._ui._commercialValue:SetText(string.format("%s : %.1f", PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MINIGAME_FINDROOT_WORTHTITLE"), curPercent) .. "%")
  self._ui._damageGauge:SetProgressRate(curPercent)
  self._ui._damageGauge:SetCurrentProgressRate(curPercent)
  self._ui._emptyCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", emptyCount))
  self._ui._subObjCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", subObjCount))
  self._ui._trapCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", trapCount))
  if emptyCount ~= self._maxEmptyCount then
    self._ui._emptyCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxEmptyCount = emptyCount
  end
  if subObjCount ~= self._maxSubObjCount then
    self._ui._subObjCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxSubObjCount = subObjCount
  end
  if trapCount ~= self._maxTrapCount then
    self._ui._trapCnt:AddEffect("UI_LevelUP_Skill", false, 5, 0)
    self._maxTrapCount = trapCount
  end
  if curPercent ~= self._curPecent then
    self._ui._commercialValue:AddEffect("fUI_Skill_Cooltime01", false, 5, 0)
    self._curPecent = curPercent
  end
  local idx = self:getRewardIndex(curPercent)
  if idx ~= self._rewardIndex then
    self._ui._curRewardSlot:SetPosX(self._rewardSlot[idx].background:GetPosX() - 5)
    self._ui._curRewardSlot:SetPosY(self._rewardSlot[idx].background:GetPosY() - 5)
    for ii = 0, self._config._rewardMaxCount - 1 do
      if idx == ii then
        self._rewardSlot[ii].icon:SetMonoTone(false)
      else
        self._rewardSlot[ii].icon:SetMonoTone(true)
      end
    end
    self._rewardIndex = idx
  end
end
function FromClient_MiniGameFindStaticInfo(damageRate, RClickCount, emptyCount, subObjCount, trapCount, gameCurDepth, gameLastDepth)
  local self = PaGlobal_MiniGame_Find
  local curPercent = damageRate / 10000
  if curPercent <= 0 then
    curPercent = 0
  end
  self._curRClickCount = 0
  self._curPecent = 100
  self._maxEmptyCount = emptyCount
  self._maxSubObjCount = subObjCount
  self._maxTrapCount = trapCount
  self._gameCurDepth = gameCurDepth
  self._gameLastDepth = gameLastDepth
  FGlobal_MiniGameFind_RefreshText(false)
  self._ui._commercialValue:SetText(string.format("%s : %.1f", PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MINIGAME_FINDROOT_WORTHTITLE"), curPercent) .. "%")
  self._ui._damageGauge:SetProgressRate(curPercent)
  self._ui._damageGauge:SetCurrentProgressRate(curPercent)
  self._ui._emptyCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxEmptyCount))
  self._ui._subObjCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxSubObjCount))
  self._ui._trapCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_COUNT", "count", self._maxTrapCount))
  self._ui._gameDepth:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_MINIGAME_FIND_CURRENTGRADE", "currentGrade", self._gameCurDepth, "maxGrade", self._gameLastDepth))
  local idx = self:getRewardIndex(curPercent)
  for ii = 0, self._config._rewardMaxCount - 1 do
    if idx == ii then
      self._rewardSlot[ii].icon:SetMonoTone(false)
    else
      self._rewardSlot[ii].icon:SetMonoTone(true)
    end
  end
  self._ui._curRewardSlot:SetPosX(self._rewardSlot[idx].background:GetPosX() - 5)
  self._ui._curRewardSlot:SetPosY(self._rewardSlot[idx].background:GetPosY() - 5)
  self._rewardIndex = idx
end
function FromClient_MiniGameFindDefaultImage(col, row, uv0, uv1, uv2, uv3, imagePath)
  local self = PaGlobal_MiniGame_Find
  local slot = self._slots[col][row].close
  slot:ChangeTextureInfoName(imagePath)
  local xx1, yy1, xx2, yy2 = setTextureUV_Func(slot, uv0, uv1, uv2, uv3)
  slot:getBaseTexture():setUV(xx1, yy1, xx2, yy2)
  slot:setRenderTexture(slot:getBaseTexture())
end
function FromClient_MiniGameFindSetShow(col, row)
  local self = PaGlobal_MiniGame_Find
  self._tmpRClickCount = 0
  self._gameState = self._state.Play
  for _, slot in pairs(self._damageSlot) do
    slot:SetShow(false)
  end
  self._damageSlot = {}
  self:refresh(col, row)
  self._isMainLoad = false
  self._tutorialTime = 0
  self._tutorialIndex = -1
  Panel_MiniGame_Find:SetShow(true)
  if true == Panel_Manufacture:GetShow() then
    Manufacture_Close()
  end
end
function FromClient_MiniGameFindSetReward(rewardList)
  if nil == rewardList then
    return
  end
  local self = PaGlobal_MiniGame_Find
  for ii = 0, #rewardList do
    local itemSSW = getItemEnchantStaticStatus(rewardList[ii])
    self._rewardSlot[ii]:setItemByStaticStatus(itemSSW)
    self._rewardSlot[ii].icon:SetShow(true)
    self._rewardSlot[ii].itemNo = rewardList[ii]
  end
end
function FromClient_MiniGameFindSetState(serverState, msgKey)
  local self = PaGlobal_MiniGame_Find
  self._gameState = serverState
  self._stateMsgKey = msgKey
  if serverState == self._state.None then
    self:endGame()
    self._readyToEndGame = true
  elseif serverState == self._state.Wait then
    self._readyToNextGame = true
  end
  self._curSec = 0
  Panel_MiniGame_MiniGameResult:SetShow(true)
end
PaGlobal_MiniGame_Find:initialize()
