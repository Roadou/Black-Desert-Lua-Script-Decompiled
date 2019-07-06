local IM = CppEnums.EProcessorInputMode
local UI_PD = CppEnums.Padding
local UI_TM = CppEnums.TextMode
PaGlobal_registerPanelOnBlackBackground(Panel_RandomBoxSelect)
Panel_RandomBoxSelect:ignorePadSnapMoveToOtherPanel()
Panel_RandomBoxSelect:SetShow(false)
Panel_RandomBoxSelect:SetDragEnable(true)
Panel_Gacha_Roulette:SetShow(false)
Panel_Gacha_Roulette:setMaskingChild(true)
local RouletteState = {
  eClose = 0,
  eRoll = 1,
  ePickAndSlow = 2,
  eResult = 3,
  eWaitContinue = 4
}
local gacha_Roulette = {
  coverThis = UI.getChildControl(Panel_Gacha_Roulette, "Static_Cover"),
  PressA = UI.getChildControl(Panel_Gacha_Roulette, "Static_PressA"),
  notify = UI.getChildControl(Panel_Gacha_Roulette, "StaticText_Notify"),
  effectControl = UI.getChildControl(Panel_Gacha_Roulette, "Static_EffectControl"),
  modeNormal = UI.getChildControl(Panel_RandomBoxSelect, "Button_NormalRandomBox"),
  modeSpeedy = UI.getChildControl(Panel_RandomBoxSelect, "Button_SpeedRandomBox"),
  randomBoxInfo = UI.getChildControl(Panel_RandomBoxSelect, "StaticText_Desc"),
  lineBG = UI.getChildControl(Panel_RandomBoxSelect, "Static_Inner2"),
  rollMode = 0,
  maxSlotCount = 200,
  useSlotCount = 0,
  slotBGPool = {},
  slotPool = {},
  slot_PosYGap = 65,
  rouletteState = RouletteState.eClose,
  rollSpeedInit = 20,
  rollSpeedCur = 0,
  rollSpeedMin = 1,
  rollSpeedAccel = 0,
  rollPos = 0.5,
  pickItemKey = nil,
  pickSlotIndex = 0,
  elapsTime = 0,
  slotConfing = {
    createIcon = true,
    createBorder = true,
    createCash = true,
    createEnchant = true
  },
  keyguide_A = UI.getChildControl(Panel_RandomBoxSelect, "Button_OK_ConsoleUI"),
  keyguide_B = UI.getChildControl(Panel_RandomBoxSelect, "Button_NO_ConsoleUI")
}
local itemDataPool = {}
function gacha_Roulette:Initialize()
  gacha_Roulette_SetRollPos(0.5)
  self.rouletteState = RouletteState.eClose
  self.randomBoxInfo:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.randomBoxInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_RANDOMBOXSELECT_DESC"))
  local gapY = self.randomBoxInfo:GetTextSizeY() - self.randomBoxInfo:GetSizeY()
  if gapY > 0 then
    self.lineBG:SetSize(self.lineBG:GetSizeX(), self.lineBG:GetSizeY() + gapY)
    Panel_RandomBoxSelect:SetSize(Panel_RandomBoxSelect:GetSizeX(), Panel_RandomBoxSelect:GetSizeY() + gapY)
    Panel_RandomBoxSelect:ComputePosAllChild()
  end
  local tempBtnGroup = {
    self.keyguide_A,
    self.keyguide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, Panel_RandomBoxSelect, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  for slot_idx = 0, self.maxSlotCount - 1 do
    slotBg = UI.createAndCopyBasePropertyControl(Panel_Gacha_Roulette, "Static_ItemSlot", Panel_Gacha_Roulette, "Static_ItemSlot_" .. slot_idx)
    slotBg:SetPosX(130)
    slotBg:SetPosY(-(self.slot_PosYGap * slot_idx))
    self.slotBGPool[slot_idx] = slotBg
    local slot = {}
    SlotItem.new(slot, "Static_ItemSlot_Item_" .. slot_idx, slot_idx, slotBg, self.slotConfing)
    slot:createChild()
    slot.icon:SetPosX(9)
    slot.icon:SetPosY(9)
    self.slotPool[slot_idx] = slot
  end
  self.coverThis:SetIgnore(true)
  self.notify:SetNotAbleMasking(true)
  Panel_Gacha_Roulette:SetChildIndex(self.coverThis, 9999)
  self.rollMode = 0
  self.modeNormal:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_StartRoulette(0)")
  self.modeSpeedy:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_StartRoulette(1)")
  ToClient_CloseRandomBox()
end
function gacha_Roulette:ResetPos()
  gacha_Roulette_SetRollPos(0.5)
  for slot_idx = 0, self.maxSlotCount - 1 do
    local slotBg = self.slotBGPool[slot_idx]
    slotBg:SetPosX(23)
    slotBg:SetPosY(-(self.slot_PosYGap * slot_idx))
    local slot = self.slotPool[slot_idx]
    slot.icon:SetPosX(115)
    slot.icon:SetPosY(0)
  end
end
function gacha_Roulette_SetRollPos(rollPosition)
  local self = gacha_Roulette
  self.rollPos = rollPosition
  self.rollPos = self.rollPos % self.useSlotCount
  local slot_CenterY = self.coverThis:GetPosY() + 18
  local rollSlot = math.floor(self.rollPos)
  local rollDecimal = self.rollPos - rollSlot
  local centerSlotY = slot_CenterY + (rollDecimal - 0.5) * self.slot_PosYGap
  local bottomSlot = rollSlot - math.floor(self.useSlotCount / 2)
  if bottomSlot < 0 then
    bottomSlot = bottomSlot + self.useSlotCount
  end
  local bottomSlotY = centerSlotY + math.floor(self.useSlotCount / 2) * self.slot_PosYGap
  for slot_idx = 0, self.useSlotCount - 1 do
    local slotBg = self.slotBGPool[slot_idx]
    local slotY = 0
    if slot_idx < bottomSlot then
      slotY = bottomSlotY - self.slot_PosYGap * (slot_idx - bottomSlot + self.useSlotCount)
    else
      slotY = bottomSlotY - self.slot_PosYGap * (slot_idx - bottomSlot)
    end
    slotBg:SetPosY(slotY)
  end
end
function gacha_Roulette_MoveByDeltaTime(deltaTime)
  local self = gacha_Roulette
  if self.rouletteState == RouletteState.eRoll then
    gacha_Roulette_SetRollPos(self.rollPos + deltaTime * self.rollSpeedCur)
  elseif self.rouletteState == RouletteState.ePickAndSlow then
    if self.rollSpeedCur > self.rollSpeedMin then
      local rollSpeedPrev = self.rollSpeedCur
      self.rollSpeedCur = self.rollSpeedCur + deltaTime * self.rollSpeedAccel
      if self.rollSpeedCur < self.rollSpeedMin then
        self.rollSpeedCur = self.rollSpeedMin
      end
      local deltaPos = (self.rollSpeedCur * self.rollSpeedCur - rollSpeedPrev * rollSpeedPrev) / (2 * self.rollSpeedAccel)
      gacha_Roulette_SetRollPos(self.rollPos + deltaPos)
    else
      local speed = self.rollSpeedCur
      if self.rollPos > self.pickSlotIndex + 0.5 then
        speed = -self.rollSpeedCur
      end
      local deltaPos = deltaTime * self.rollSpeedCur
      if math.abs(self.pickSlotIndex + 0.5 - self.rollPos) > math.abs(deltaPos) then
        gacha_Roulette_SetRollPos(self.rollPos + deltaPos)
      else
        gacha_Roulette_SetRollPos(self.pickSlotIndex + 0.5)
        FGlobal_Gacha_Roulette_ShowResult()
      end
    end
  end
end
local resultShowTime = 0
local soundPlayTime = 0
local limitTime = 30
function gacha_Roulette_Ani(deltaTime)
  local self = gacha_Roulette
  self.elapsTime = self.elapsTime + deltaTime
  if self.rouletteState == RouletteState.eRoll then
    soundPlayTime = soundPlayTime + deltaTime
    if soundPlayTime > 0.076 then
      _AudioPostEvent_SystemUiForXBOX(11, 10)
      soundPlayTime = 0
    end
    if self.elapsTime > 1 and not self.PressA:GetShow() then
      self.PressA:SetShow(true)
      self.notify:SetShow(true)
    end
    local outIndex = 0
    gacha_Roulette_MoveByDeltaTime(deltaTime)
  elseif self.rouletteState == RouletteState.ePickAndSlow then
    gacha_Roulette_MoveByDeltaTime(deltaTime)
  elseif self.rouletteState == RouletteState.eResult then
    gacha_Roulette_SetRollPos(0.5 + self.pickSlotIndex)
    resultShowTime = resultShowTime + deltaTime
    if self.rollMode == 1 then
      if resultShowTime > 1 then
        resultShowTime = 0
        local isCanContinue = ToClient_IsCanContinueRandomBox()
        if self.rollMode == 1 and isCanContinue then
          self.rouletteState = RouletteState.eWaitContinue
          ToClient_ContinueRandomBox()
        else
          gacha_Roulette:Close()
        end
      end
    elseif resultShowTime > 2.5 then
      resultShowTime = 0
      gacha_Roulette:Close()
    end
  elseif self.rouletteState == RouletteState.eWaitContinue then
    gacha_Roulette_SetRollPos(0.5 + self.pickSlotIndex)
  end
  if self.rouletteState == RouletteState.eRoll then
    local autoLimitTime = string.format("%d", limitTime - self.elapsTime)
    self.notify:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_XBOX1_GACHA_ROULETTE_NOTIFY", "autoLimitTime", autoLimitTime))
    if self.elapsTime > 30 then
      self.elapsTime = 0
      gacha_Roulette:Close()
    end
  end
end
function gacha_Roulette:Open()
  local selfPlayerWrapper = getSelfPlayer()
  if nil == selfPlayerWrapper then
    return nil
  end
  local selfPlayer = selfPlayerWrapper:get()
  local inventory_normal = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local inventory_cash = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eCashInventory)
  local freeCount_normal = inventory_normal:getFreeCount()
  local freeCount_cash = inventory_cash:getFreeCount()
  if freeCount_normal < 1 or freeCount_cash < 1 then
    SetUIMode(Defines.UIMode.eUIMode_Default)
    gacha_Roulette:Close()
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_EMPTYSLOT"))
    return
  end
  FromClient_Gacha_Roulette_onScreenResize()
  gacha_Roulette:ResetPos()
  self.rollSpeedCur = self.rollSpeedInit
  self.rollSpeedMin = 1
  self.rouletteState = RouletteState.eRoll
  self.elapsTime = 0
  Panel_Gacha_Roulette:SetShow(true)
  self.PressA:SetShow(false)
  self.notify:SetShow(false)
  self.PressA:SetVertexAniRun("Ani_Color_New", true)
  self.notify:SetVertexAniRun("Ani_Color_New", true)
  self.effectControl:EraseAllEffect()
  self.effectControl:AddEffect("fUI_Gacha_Spark01", true, 0, 50)
  if self.rouletteState == RouletteState.eRoll then
    SetUIMode(Defines.UIMode.eUIMode_Gacha_Roulette)
  end
end
function gacha_Roulette:Close()
  if Panel_Gacha_Roulette:GetShow() or Panel_RandomBoxSelect:GetShow() then
    Panel_Gacha_Roulette:SetShow(false)
    Panel_RandomBoxSelect:SetShow(false)
    Panel_Tooltip_Item_hideTooltip()
    SetUIMode(Defines.UIMode.eUIMode_Default)
    self.rouletteState = RouletteState.eClose
    CheckChattingInput()
  end
  if ToClient_CloseRandomBox ~= nil then
    ToClient_CloseRandomBox()
  end
end
function gacha_Roulette_Tooltip(isShow)
  local self = gacha_Roulette
  local itemStaticStatusWrapper
  if isShow then
    itemStaticStatusWrapper = getItemEnchantStaticStatus(self.pickItemKey)
    local slotUi = gacha_Roulette.slotPool[self.pickSlotIndex]
    Panel_Tooltip_Item_Show(itemStaticStatusWrapper, slotUi.icon, true, false, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FGlobal_gacha_Roulette_Open()
  gacha_Roulette:Open()
end
function FGlobal_Gacha_Roulette_Close()
  local self = gacha_Roulette
  if self.rouletteState ~= RouletteState.ePickAndSlow then
    gacha_Roulette:Close()
  end
end
function FGlobal_gacha_Roulette_OnPressEscape()
  Panel_RandomBoxSelect:SetShow(false)
  FGlobal_Gacha_Roulette_Close()
end
function FGlobal_gacha_Roulette_OnPressSpace()
  local self = gacha_Roulette
  if self.rouletteState == RouletteState.eRoll then
    FGlobal_gacha_Roulette_Stop()
  elseif self.rollMode == 1 and self.rouletteState == RouletteState.ePickAndSlow then
    FGlobal_Gacha_Roulette_ShowResult()
  elseif self.rollMode == 1 and self.rouletteState == RouletteState.eResult then
    local isCanContinue = ToClient_IsCanContinueRandomBox()
    if self.rollMode == 1 and isCanContinue then
      self.rouletteState = RouletteState.eWaitContinue
      ToClient_ContinueRandomBox()
    else
      gacha_Roulette:Close()
    end
  end
end
function FGlobal_gacha_Roulette_Stop()
  local self = gacha_Roulette
  _AudioPostEvent_SystemUiForXBOX(11, 12)
  if self.rollMode == 0 and self.elapsTime < 1.2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_NOTYETFUNCTION"))
    return
  end
  ToClient_StopRandomBox()
end
function PanelRandomBoxSelect_StartRoulette(index)
  local self = gacha_Roulette
  self.rollMode = index
  Panel_RandomBoxSelect:SetShow(false)
  InventoryWindow_Close()
  gacha_Roulette:Open()
end
function PanelRandomBoxSelect_Cancel()
  Panel_RandomBoxSelect:SetShow(false)
  gacha_Roulette:Close()
end
function FromClient_Gacha_Roulette_onScreenResize()
  Panel_Gacha_Roulette:SetPosX(getOriginScreenSizeX() / 2 - Panel_Gacha_Roulette:GetSizeX() / 1.3)
  Panel_Gacha_Roulette:SetPosY(getOriginScreenSizeY() / 2 - Panel_Gacha_Roulette:GetSizeY() * 1.1)
end
function FromClient_ShowRandomBox()
  local self = gacha_Roulette
  local isContinue = false
  if self.rouletteState == RouletteState.eWaitContinue then
    isContinue = true
  elseif self.rouletteState == RouletteState.eClose then
    isContinue = false
  else
    return
  end
  self.rouletteState = RouletteState.eClose
  local itemCount = ToClient_GetRandomItemListCount()
  if nil == itemCount or 0 == itemCount then
    return
  end
  for slot_idx = 0, self.maxSlotCount - 1 do
    local slotBg = self.slotBGPool[slot_idx]
    slotBg:SetShow(false)
    local slot = self.slotPool[slot_idx]
    slot:clearItem()
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
  end
  self.useSlotCount = itemCount
  while self.useSlotCount < self.rollSpeedInit do
    self.useSlotCount = self.useSlotCount + itemCount
  end
  local slotIndexList = {}
  for slot_idx = 0, self.useSlotCount - 1 do
    slotIndexList[slot_idx] = slot_idx % itemCount
  end
  for slot_idx = 0, self.useSlotCount * 2 - 1 do
    local ia = math.random(self.useSlotCount - 1)
    local ib = math.random(self.useSlotCount - 1)
    slotIndexList[ia], slotIndexList[ib] = slotIndexList[ib], slotIndexList[ia]
  end
  for slot_idx = 0, self.useSlotCount - 1 do
    local slotBg = self.slotBGPool[slot_idx]
    slotBg:SetShow(true)
    local slot = self.slotPool[slot_idx]
    local randomIndex = slotIndexList[slot_idx]
    local itemWrapper = ToClient_GetRandomItemListAt(randomIndex)
    slot:setItemByStaticStatus(itemWrapper, 1, -1)
    slot.icon:addInputEvent("Mouse_Out", "gacha_Roulette_Tooltip( false )")
  end
  if isContinue then
    InventoryWindow_Close()
    gacha_Roulette:Open()
  else
    Panel_RandomBoxSelect:SetShow(true)
  end
end
function FromClient_SelectRandomItem(itemKey)
  local self = gacha_Roulette
  local itemWrapper = getItemEnchantStaticStatus(itemKey)
  self.pickItemKey = itemKey
  self.pickSlotIndex = math.floor(self.rollPos) + math.floor(self.useSlotCount / 2)
  self.pickSlotIndex = self.pickSlotIndex % self.useSlotCount
  local changeSlot = self.slotPool[self.pickSlotIndex]
  changeSlot:clearItem()
  changeSlot:setItemByStaticStatus(itemWrapper, 1, -1)
  local totalMovePos = self.useSlotCount * 0 + math.floor(self.useSlotCount / 2) - 1
  while totalMovePos < self.rollSpeedInit do
    totalMovePos = totalMovePos + self.useSlotCount
  end
  local posDecimal = self.rollPos - math.floor(self.rollPos)
  if posDecimal > 0.7 then
    local posDecimalDelta = posDecimal - 0.7
    totalMovePos = totalMovePos - posDecimalDelta
  end
  self.rollSpeedAccel = (self.rollSpeedMin * self.rollSpeedMin - self.rollSpeedInit * self.rollSpeedInit) / (2 * totalMovePos)
  self.rouletteState = RouletteState.ePickAndSlow
  self.PressA:SetShow(false)
  self.notify:SetShow(false)
end
function FGlobal_Gacha_Roulette_ShowResult()
  local self = gacha_Roulette
  if self.rouletteState ~= RouletteState.eClose then
    self.rouletteState = RouletteState.eResult
  end
  resultShowTime = 0
  self.effectControl:EraseAllEffect()
  local changeSlot = self.slotPool[self.pickSlotIndex]
  changeSlot.icon:addInputEvent("Mouse_On", "gacha_Roulette_Tooltip( true )")
  local itemWrapper = getItemEnchantStaticStatus(self.pickItemKey)
  if self.rouletteState ~= RouletteState.eClose then
    SetUIMode(Defines.UIMode.eUIMode_Gacha_Roulette)
  end
  local sendMsg = {
    main = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_GETITEM", "getName", itemWrapper:getName()),
    sub = "",
    addMsg = ""
  }
  Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(sendMsg, 3.5, 17)
  if ToClient_MessageResultRandomBox ~= nil then
    ToClient_MessageResultRandomBox()
  end
  if self.rouletteState ~= RouletteState.eClose then
    SetUIMode(Defines.UIMode.eUIMode_Gacha_Roulette)
  end
end
function FromClient_CloseRandomBox()
  local self = gacha_Roulette
  if self.rouletteState ~= RouletteState.ePickAndSlow then
    gacha_Roulette:Close()
  end
end
registerEvent("onScreenResize", "FromClient_Gacha_Roulette_onScreenResize")
registerEvent("FromClient_ShowRandomBox", "FromClient_ShowRandomBox")
registerEvent("FromClient_SelectRandomItem", "FromClient_SelectRandomItem")
registerEvent("FromClient_CloseRandomBox", "FromClient_CloseRandomBox")
Panel_Gacha_Roulette:RegisterUpdateFunc("gacha_Roulette_Ani")
gacha_Roulette:Initialize()
