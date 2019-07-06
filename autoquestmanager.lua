enMouseMoveValue = {UpdateMoveSize = 8}
stateTypeValue = {
  idle = 0,
  startQuestToNpc = 1,
  endQuestToNpc = 2,
  doingQuest = 3,
  autoNaviButton = 4,
  needToDialog = 5,
  stuckescpae = 6,
  needToMeetRelationNPC = 7
}
QuestProgress = {
  clear = 0,
  progressing = 1,
  start = 2
}
pressButton = {
  default = 0,
  mouseL = 1,
  keyboarR = 2,
  mouseMoving = 4,
  selectreward = 5,
  showMouse = 6,
  escape = 7,
  navigationT = 8
}
PaGlobal_AutoQuestManager = {
  _doAutoQuest = false,
  _stateType = stateTypeValue.idle,
  _questProgress = QuestProgress.clear,
  _mouseAutoMove = false,
  _doDialog = false,
  _doAutoHunt = false,
  _autoMove = false,
  _currentQuestGroup = 0,
  _currentQuestId = 0,
  _delay = 0,
  _isjustmeetNPC = false,
  _isSummonBoss = false,
  _pressButton = pressButton.default,
  _pressDelay = 0
}
function PaGlobal_AutoQuestManager:init()
  self._doAutoQuest = false
  self._stateType = stateTypeValue.idle
  self._questProgress = QuestProgress.clear
  self._mouseAutoMove = false
  self._doDialog = false
  self._doAutoHunt = false
  self._autoMove = false
  self._currentQuestGroup = 0
  self._currentQuestId = 0
  self._delay = 0
  self._pressButton = pressButton.default
  self._pressDelay = 0
end
function PaGlobal_AutoQuestManager:UpdatePerFrame(deltaTime)
  if not self._doAutoQuest then
    return
  end
  if self._mouseAutoMove then
    self:mouseProgress()
  end
  if self._doDialog then
    self:dialogProgress()
  end
  if self._pressButton ~= pressButton.default and self._pressButton ~= pressButton.mouseMoving then
    self:waitForPressButton()
  end
  self._pressDelay = self._pressDelay + deltaTime
  self._delay = self._delay + deltaTime
  if self._delay < 1 then
    return
  end
  self._delay = 0
  self:updateAutoQuest(deltaTime)
  self:usePotion()
end
local svvv
function PaGlobal_AutoQuestManager:updateAutoQuest(deltaTime)
  nnntest = 0
  if nnntest == 0 then
    nnntest = 1
    svvv = TTTTTTT
    svvv:Update()
    svvv = DDDDDDD
    svvv:Update()
  end
  local questList = ToClient_GetQuestList()
  if true == questList:isMainQuestClearAll() then
    return
  end
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo then
    local questNo = uiQuestInfo:getQuestNo()
    self._currentQuestGroup = questNo._group
    self._currentQuestId = questNo._quest
    local isAccepted = 1
    if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
      isAccepted = 0
    end
    if true == uiQuestInfo:isSatisfied() then
      self._questProgress = QuestProgress.clear
    elseif 0 == isAccepted then
      self._questProgress = QuestProgress.start
    else
      self._questProgress = QuestProgress.progressing
    end
    self._isjustmeetNPC = uiQuestInfo:isjustMeetNpc()
    if self._questProgress ~= QuestProgress.clear then
      self._isSummonBoss = uiQuestInfo:isSummonBoss()
    end
    if self._doAutoHunt then
      if self._questProgress == QuestProgress.clear then
        self._doAutoHunt = false
        ToClient_changeAutoMode(0)
        self._stateType = stateTypeValue.endQuestToNpc
        self:showmouseorT()
      end
    elseif not self._autoMove and not self._mouseAutoMove and self._stateType ~= stateTypeValue.needToDialog and not ToClient_isCheckRenderModeDialog() then
      self:showmouseorT()
    end
    local speed = ToClient_getPhysicalSpeedforFIndway()
    if speed < 35 and self._autoMove then
      self._stateType = stateTypeValue.stuckescpae
      if ToClient_pushStuckPostion() then
        ToClient_changeAutoMode(2)
        _PA_LOG("\234\185\128\234\183\156\235\179\180", "do pushStuckPostion")
      end
    end
  end
end
function PaGlobal_AutoQuestManager:talkingToNpc()
  if self._questProgress == QuestProgress.clear then
    self._stateType = stateTypeValue.endQuestToNpc
  elseif self._questProgress == QuestProgress.progressing then
    self._stateType = stateTypeValue.startQuestToNpc
  else
    self._stateType = stateTypeValue.startQuestToNpc
  end
  self._doDialog = true
  self._mouseAutoMove = true
  _PA_LOG("\234\185\128\234\183\156\235\179\180", "PaGlobal_AutoQuestManager:talkingToNpc()")
end
function PaGlobal_AutoQuestManager:mouseProgress()
  if self._stateType == stateTypeValue.autoNaviButton then
    local questWidget = PaGlobal_MainQuest._uiAutoNaviBtn
    local posX = Panel_MainQuest:GetPosX() + questWidget:GetPosX() + questWidget:GetSizeX() / 2
    local posY = Panel_MainQuest:GetPosY() + questWidget:GetPosY() + questWidget:GetSizeY() / 2
    if false == self:moveMouse(posX, posY) then
      if self._pressButton ~= pressButton.mouseL then
        self._pressButton = pressButton.mouseL
      end
      if self._questProgress == QuestProgress.clear then
        if self:waitForPressButton() then
          self._stateType = stateTypeValue.endQuestToNpc
          self._autoMove = true
        end
        local QuestStatic = questList_getQuestStatic(self._currentQuestGroup, self._currentQuestId)
        if nil ~= QuestStatic and QuestStatic:isCompleteBlackSpirit() then
          self._stateType = stateTypeValue.needToDialog
          self._autoMove = false
          self._pressButton = pressButton.mouseL
        end
      elseif self._questProgress == QuestProgress.progressing then
        if self:waitForPressButton() then
          self._stateType = stateTypeValue.startQuestToNpc
          self._mouseAutoMove = false
          self._stateType = stateTypeValue.doingQuest
          self._autoMove = true
        end
      else
        if self:waitForPressButton() then
          self._stateType = stateTypeValue.startQuestToNpc
          self._autoMove = true
        end
        local QuestStatic = questList_getQuestStatic(self._currentQuestGroup, self._currentQuestId)
        if nil ~= QuestStatic and QuestStatic:isCompleteBlackSpirit() then
          self._stateType = stateTypeValue.needToDialog
          self._autoMove = false
          self._pressButton = pressButton.mouseL
        end
      end
    end
  elseif self._stateType == stateTypeValue.startQuestToNpc then
    if true == _ContentsGroup_RenewUI_Dailog then
      local buttonPosition = PaGlobalFunc_MainDialog_Bottom_GetFuncPositionNewQuestButton()
      if false == buttonPosition._Return then
        return
      end
      self._pressButton = pressButton.mouseMoving
      local sizeX, sizeY = PaGlobalFunc_MainDialog_Bottom_GetFuncButtonSizeXY()
      if false == self:moveMouse(buttonPosition._PosX + sizeX / 2, PaGlobalFunc_MainDialog_Bottom_GetSizeY() + buttonPosition._PosY + sizeY / 2) then
        self._stateType = stateTypeValue.doingQuest
        if self._pressButton ~= pressButton.keyboarR then
          self._pressButton = pressButton.keyboarR
          self._mouseAutoMove = false
        end
      end
    else
      local buttonPosition
      if false == _ContentsGroup_NewUI_Dialog_All then
        buttonPosition = FGlobal_Dialog_GetFuncPositionNewQuestButton()
      else
        buttonPosition = PaGlobalFunc_DialogMain_All_GetFuncPositionNewQuestButton()
      end
      if false == buttonPosition._Return then
        return
      end
      self._pressButton = pressButton.mouseMoving
      local dialogPosY
      if false == _ContentsGroup_NewUI_Dialog_All then
        dialogPosY = Panel_Npc_Dialog:GetPosY()
      else
        dialogPosY = Panel_Npc_Dialog_All:GetPosY()
      end
      if false == self:moveMouse(buttonPosition._PosX + 65, dialogPosY + buttonPosition._PosY + 18) then
        self._stateType = stateTypeValue.doingQuest
        if self._pressButton ~= pressButton.keyboarR then
          self._pressButton = pressButton.keyboarR
          self._mouseAutoMove = false
        end
      end
    end
  elseif self._stateType == stateTypeValue.endQuestToNpc then
    if self._autoMove then
      return
    end
    local npcData = ToClient_GetCurrentDialogData()
    if npcData == nil then
      return
    end
    local selCount = 0
    local QuestStatic = questList_getQuestStatic(self._currentQuestGroup, self._currentQuestId)
    if nil ~= QuestStatic then
      selCount = QuestStatic:getQuestSelectRewardCount()
    end
    if selCount ~= 0 then
      local buttonPosition = FGlobal_getSelectRewardPosition()
      if false == self:moveMouse(buttonPosition._PosX, buttonPosition._PosY) then
        self._stateType = stateTypeValue.idle
        self._pressButton = pressButton.selectreward
        self._mouseAutoMove = false
      end
    else
      if self._pressButton ~= pressButton.keyboarR then
        self._pressButton = pressButton.keyboarR
      end
      self._mouseAutoMove = false
    end
  end
end
function PaGlobal_AutoQuestManager:dialogProgress()
  if self._mouseAutoMove then
    return
  end
  local npcData = ToClient_GetCurrentDialogData()
  if npcData ~= nil then
    local reward = npcData:getBaseRewardCount()
    local bcount = npcData:getFuncButtonCount()
    local newquest = npcData:isHaveAcceptMainQuest()
    if reward == 0 and bcount ~= 0 and not newquest then
      self._pressButton = pressButton.escape
    end
  end
  if not ToClient_isCheckRenderModeDialog() then
    self._doDialog = false
    self._mouseAutoMove = true
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "PaGlobal_AutoQuestManager:dialogProgress()")
    self:showmouseorT()
  end
end
function PaGlobal_AutoQuestManager:stuckEscape()
  ToClient_changeAutoMode(0)
  self._autoMove = true
  self._pressButton = pressButton.default
  local questList = ToClient_GetQuestList()
  if true == questList:isMainQuestClearAll() then
    return
  end
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo then
    local questNo = uiQuestInfo:getQuestNo()
    self._currentQuestGroup = questNo._group
    self._currentQuestId = questNo._quest
    local isAccepted = 1
    if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
      isAccepted = 0
    end
    self._stateType = stateTypeValue.doingQuest
    if true == uiQuestInfo:isSatisfied() then
      self._questProgress = QuestProgress.clear
      self._stateType = stateTypeValue.endQuestToNpc
    elseif 0 == isAccepted then
      self._questProgress = QuestProgress.start
      self._stateType = stateTypeValue.startQuestToNpc
    else
      self._questProgress = QuestProgress.progressing
      self._stateType = stateTypeValue.doingQuest
    end
  end
end
local VCK = CppEnums.VirtualKeyCode
local UIT = CppEnums.UiInputType
local function GlobalKeyBinder_CheckCustomKeyPressed(uiInputType)
  return keyCustom_IsDownOnce_Ui(uiInputType) and not GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_MENU) and not isPhotoMode()
end
local GlobalKeyBinder_CheckKeyPressed = function(keyCode)
  return isKeyDown_Once(keyCode)
end
function PaGlobal_AutoQuestManager:waitForPressButton()
  if self._pressButton == pressButton.default then
    return true
  end
  if self._pressButton == pressButton.mouseMoving then
    return false
  end
  if self._stateType == stateTypeValue.needToDialog then
    if ToClient_isCheckRenderModeDialog() then
      self:talkingToNpc()
      self._pressButton = pressButton.default
      return true
    end
    if 3 < self._pressDelay then
      if self._pressButton == pressButton.mouseL then
        Proc_ShowMessage_Ack("\236\158\144\235\143\153\236\157\180\235\143\153 \237\129\180\235\166\173")
      elseif self._pressButton == pressButton.keyboarR then
        Proc_ShowMessage_Ack("R\237\130\164\235\165\188 \235\136\140\235\159\172 \236\157\184\237\132\176\235\160\137\236\133\152 \237\149\152\236\132\184\236\154\148")
      elseif self._pressButton == pressButton.selectreward then
        Proc_ShowMessage_Ack("\236\132\160\237\131\157 \235\179\180\236\131\129")
      elseif self._pressButton == pressButton.showMouse then
        Proc_ShowMessage_Ack("\236\187\168\237\138\184\235\161\164 \237\130\164")
      elseif self._pressButton == pressButton.escape then
        Proc_ShowMessage_Ack("ESC\235\136\140")
      elseif self._pressButton == pressButton.navigationT then
        Proc_ShowMessage_Ack("T\235\178\132\237\138\188\236\157\132 \235\136\140\235\165\180\236\132\184\236\154\169")
      end
      self._pressDelay = 0
    end
    return false
  end
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_CONTROL) and self._pressButton == pressButton.showMouse then
    self._mouseAutoMove = true
    self._pressButton = pressButton.mouseMoving
    return true
  end
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_LBUTTON) and self._pressButton == pressButton.mouseL then
    self._pressButton = pressButton.default
    return true
  end
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_LBUTTON) and self._pressButton == pressButton.selectreward then
    self._pressButton = pressButton.keyboarR
    return true
  end
  if GlobalKeyBinder_CheckKeyPressed(VCK.KeyCode_T) and self._pressButton == pressButton.navigationT then
    self._pressButton = pressButton.default
    return true
  end
  if 3 < self._pressDelay then
    if self._pressButton == pressButton.mouseL then
      Proc_ShowMessage_Ack("\236\158\144\235\143\153\236\157\180\235\143\153 \237\129\180\235\166\173")
    elseif self._pressButton == pressButton.keyboarR then
      Proc_ShowMessage_Ack("R \235\136\140\235\159\172\236\132\156 \236\157\152\235\165\188 \235\176\155\234\177\176\235\130\152 \236\153\132\235\163\140")
      PaGlobal_AutoQuestManager:stopreasonFullinventory()
    elseif self._pressButton == pressButton.selectreward then
      Proc_ShowMessage_Ack("\236\132\160\237\131\157 \235\179\180\236\131\129\236\157\132 \234\179\160\235\165\180\236\132\184\236\154\148")
    elseif self._pressButton == pressButton.showMouse then
      Proc_ShowMessage_Ack("\236\187\168\237\138\184\235\161\164 \237\130\164 \235\136\132\235\165\180\236\132\184\236\154\148")
    elseif self._pressButton == pressButton.escape then
      Proc_ShowMessage_Ack("ESC\235\136\140")
    elseif self._pressButton == pressButton.navigationT then
      Proc_ShowMessage_Ack("T\235\178\132\237\138\188\236\157\132 \235\136\140\235\165\180\236\132\184\236\154\169")
    end
    self._pressDelay = 0
  end
  return false
end
function PaGlobal_AutoQuestManager:moveMouse(PosX, PosY)
  if PosX < 0 or PosY < 0 then
    return true
  end
  local nowX = getMousePosX()
  local nowY = getMousePosY()
  if math.abs(nowX - PosX) > enMouseMoveValue.UpdateMoveSize then
    if PosX > nowX then
      nowX = nowX + enMouseMoveValue.UpdateMoveSize
    elseif PosX < nowX then
      nowX = nowX - enMouseMoveValue.UpdateMoveSize
    end
  end
  if math.abs(nowY - PosY) > enMouseMoveValue.UpdateMoveSize then
    if PosY > nowY then
      nowY = nowY + enMouseMoveValue.UpdateMoveSize
    elseif PosY < nowY then
      nowY = nowY - enMouseMoveValue.UpdateMoveSize
    end
  end
  ToClient_setMousePosition(nowX, nowY)
  if math.abs(nowX - PosX) <= enMouseMoveValue.UpdateMoveSize and math.abs(nowY - PosY) <= enMouseMoveValue.UpdateMoveSize then
    return false
  end
  return true
end
function PaGlobal_AutoQuestManager:QuestAcceptorClear(isAccept, questNoRaw)
  if self._doAutoQuest then
    self:updateAutoQuest(0)
  end
end
function PaGlobal_AutoQuestManager:summonBoss()
  if self._doAutoQuest then
    ToClient_changeAutoMode(1)
    self._doAutoHunt = true
    self._isSummonBoss = false
  end
end
function PaGlobal_AutoQuestManager:showmouseorT()
  local navi = ToClient_currentNaviisMainQuest()
  if navi then
    self._pressButton = pressButton.navigationT
  else
    self._pressButton = pressButton.showMouse
    self._stateType = stateTypeValue.autoNaviButton
    _PA_LOG("\234\185\128\234\183\156\235\179\180", "showmouseorT  " .. debug.traceback())
  end
end
function PaGlobal_AutoQuestManager:getQuestIdByQuestNoRaw(questNoRaw)
  return math.floor(questNoRaw / 65536)
end
function PaGlobal_AutoQuestManager:getQuestGroupNoByQuestNoRaw(questNoRaw)
  return questNoRaw % 65536
end
function PaGlobal_AutoQuestManager:stopreasonFullinventory()
  local cnt = getSelfPlayer():get():getInventory():getFreeCount()
  if 0 == cnt then
    self._doAutoQuest = false
    ToClient_changeAutoMode(0)
    Proc_ShowMessage_Ack("\236\157\184\235\178\164\237\134\160\235\166\172\234\176\128 \234\176\128\235\147\157 \236\176\168\236\132\156 \236\152\164\237\134\160 \237\128\152\236\138\164\237\138\184\235\165\188 \236\160\149\236\167\128 \237\149\169\235\139\136\235\139\164.")
  end
end
function PaGlobal_AutoQuestManager:usePotion()
  local selfPlayer = getSelfPlayer():get()
  local hp = selfPlayer:getHp()
  local maxhp = selfPlayer:getMaxHp()
  local mp = selfPlayer:getMp()
  local maxmp = selfPlayer:getMaxMp()
  local usehp = false
  local usemp = false
  if hp / maxhp < 0.5 then
    usehp = true
  end
  if mp / maxmp < 0.5 then
    usemp = true
  end
  local inventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  if usehp then
    tempItemEnchantKey = ItemEnchantKey(502, 0)
    slotValue = inventory:getSlot(tempItemEnchantKey)
    if 255 == slotValue then
      if false == isMoving then
        local position = float3(quest.progressX, quest.progressY, quest.progressZ)
        ToClient_WorldMapNaviStart(position, NavigationGuideParam(), true, true)
        isMoving = true
      end
      return
    end
    local remainTime = getItemCooltime(CppEnums.ItemWhereType.eInventory, slotValue)
    if remainTime == 0 then
      inventoryUseItem(CppEnums.ItemWhereType.eInventory, slotValue, 0, true)
    end
  end
  if usemp then
    tempItemEnchantKey = ItemEnchantKey(591, 0)
    slotValue = inventory:getSlot(tempItemEnchantKey)
    if 255 == slotValue then
      if false == isMoving then
        local position = float3(quest.progressX, quest.progressY, quest.progressZ)
        ToClient_WorldMapNaviStart(position, NavigationGuideParam(), true, true)
        isMoving = true
      end
      return
    end
    local remainTime = getItemCooltime(CppEnums.ItemWhereType.eInventory, slotValue)
    if remainTime == 0 then
      inventoryUseItem(CppEnums.ItemWhereType.eInventory, slotValue, 0, true)
    end
  end
end
function PaGlobal_AutoQuestManager:stopAuotoByUserControl()
  if self._stateType ~= stateTypeValue.stuckescpae and self._doAutoQuest and self._autoMove then
    Proc_ShowMessage_Ack("\236\156\160\236\160\128 \236\187\168\237\138\184\235\161\164 \235\149\140\235\172\184\236\151\144 \236\152\164\237\134\160 \236\160\149\236\167\128.")
    self:stopAuoto()
  end
end
function PaGlobal_AutoQuestManager:stopAuoto()
  self:init()
  ToClient_changeAutoMode(0)
end
function autoQuest_StartAuto()
  _PA_LOG("\234\185\128\234\183\156\235\179\180", "autoQuest_StartAuto")
  PaGlobal_AutoQuestManager:init()
  ToClient_changeAutoMode(0)
  PaGlobal_AutoQuestManager._doAutoQuest = true
  PaGlobal_AutoQuestManager._autoMove = false
  PaGlobal_AutoQuestManager:updateAutoQuest(0)
end
function autoQuest_StopAuto()
  PaGlobal_AutoQuestManager._doAutoQuest = false
  ToClient_changeAutoMode(0)
end
function testway()
  ToClient_changeAutoMode(2)
end
function testres()
  ToClient_NaviReStart()
end
