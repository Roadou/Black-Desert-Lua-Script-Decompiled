local IM = CppEnums.EProcessorInputMode
local UI_PD = CppEnums.Padding
local UI_TM = CppEnums.TextMode
local RouletteState = {
  eClose = 0,
  eRoll = 1,
  ePickAndSlow = 2,
  eResult = 3,
  eWaitContinue = 4
}
local gacha_Roulette = {
  coverThis = nil,
  pushSpace = nil,
  notify = nil,
  effectControl = nil,
  subFrame = nil,
  radioModeNormal = nil,
  radioModeSpeedy = nil,
  buttonStartRoll = nil,
  buttonCanclRoll = nil,
  buttonWinClose = nil,
  bottomDescBG = nil,
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
  }
}
local itemDataPool = {}
function gacha_Roulette:Initialize()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
  Panel_RandomBoxSelect:SetShow(false)
  Panel_RandomBoxSelect:SetDragEnable(true)
  Panel_Gacha_Roulette:SetShow(false)
  Panel_Gacha_Roulette:setMaskingChild(true)
  gacha_Roulette.rollMode = 0
  gacha_Roulette.useSlotCount = 0
  gacha_Roulette.slotBGPool = {}
  gacha_Roulette.slotPool = {}
  gacha_Roulette.rouletteState = RouletteState.eClose
  gacha_Roulette.rollSpeedCur = 0
  gacha_Roulette.rollSpeedAccel = 0
  gacha_Roulette.rollPos = 0.5
  gacha_Roulette.pickItemKey = nil
  gacha_Roulette.pickSlotIndex = 0
  gacha_Roulette.elapsTime = 0
  gacha_Roulette.itemDataPool = {}
  gacha_Roulette.coverThis = UI.getChildControl(Panel_Gacha_Roulette, "Static_Cover")
  gacha_Roulette.pushSpace = UI.getChildControl(Panel_Gacha_Roulette, "Static_PushSpace")
  gacha_Roulette.notify = UI.getChildControl(Panel_Gacha_Roulette, "StaticText_Notify")
  gacha_Roulette.effectControl = UI.getChildControl(Panel_Gacha_Roulette, "Static_EffectControl")
  gacha_Roulette.subFrame = UI.getChildControl(Panel_RandomBoxSelect, "Static_SubFrameBg")
  gacha_Roulette.radioModeNormal = UI.getChildControl(Panel_RandomBoxSelect, "RadioButton_NormalRandomBox")
  gacha_Roulette.radioModeSpeedy = UI.getChildControl(Panel_RandomBoxSelect, "RadioButton_SpeedRandomBox")
  gacha_Roulette.buttonStartRoll = UI.getChildControl(Panel_RandomBoxSelect, "Button_StartRandomBox")
  gacha_Roulette.buttonCanclRoll = UI.getChildControl(Panel_RandomBoxSelect, "Button_Cancel")
  gacha_Roulette.buttonWinClose = UI.getChildControl(Panel_RandomBoxSelect, "Button_Win_Close")
  gacha_Roulette.bottomDescBG = UI.getChildControl(Panel_RandomBoxSelect, "StaticText_BottomDescBG")
  gacha_Roulette_SetRollPos(0.5)
  self.rouletteState = RouletteState.eClose
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
  self.radioModeNormal:SetCheck(false)
  self.radioModeSpeedy:SetCheck(true)
  self.rollMode = 1
  self.radioModeNormal:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_UpdateMode()")
  self.radioModeSpeedy:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_UpdateMode()")
  self.buttonStartRoll:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_StartRoulette()")
  self.buttonCanclRoll:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_Cancel()")
  self.buttonWinClose:addInputEvent("Mouse_LUp", "PanelRandomBoxSelect_Cancel()")
  self.radioModeNormal:SetEnableArea(0, 0, self.radioModeNormal:GetSizeX() + self.radioModeNormal:GetTextSizeX() + 5, self.radioModeNormal:GetSizeY())
  self.radioModeSpeedy:SetEnableArea(0, 0, self.radioModeSpeedy:GetSizeX() + self.radioModeSpeedy:GetTextSizeX() + 5, self.radioModeSpeedy:GetSizeY())
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_RandomBoxSelect:SetPosX((screenSizeX - Panel_RandomBoxSelect:GetSizeX()) / 2)
  Panel_RandomBoxSelect:SetPosY((screenSizeY - Panel_RandomBoxSelect:GetSizeY()) / 2)
  self.bottomDesc = UI.getChildControl(self.bottomDescBG, "StaticText_BottomDesc")
  self.bottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.bottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RANDOMBOXSELECT_DESC"))
  self.bottomDesc:SetSize(self.bottomDesc:GetSizeX(), self.bottomDesc:GetTextSizeY())
  self.bottomDescBG:SetSize(self.bottomDescBG:GetSizeX(), self.bottomDesc:GetSizeY() + 50)
  self.subFrame:SetSize(self.subFrame:GetSizeX(), self.bottomDescBG:GetSizeY() + 92)
  Panel_RandomBoxSelect:SetSize(Panel_RandomBoxSelect:GetSizeX(), self.subFrame:GetSizeY() + 115)
  Panel_RandomBoxSelect:ComputePos()
  self.subFrame:ComputePos()
  self.bottomDescBG:ComputePos()
  self.bottomDesc:ComputePos()
  self.buttonStartRoll:ComputePos()
  self.buttonCanclRoll:ComputePos()
  Panel_Gacha_Roulette:RegisterUpdateFunc("gacha_Roulette_Ani")
  registerCloseLuaEvent(Panel_Gacha_Roulette, PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape,
    Defines.CloseType.eCloseType_Attacked
  }), "FGlobal_Gacha_Roulette_Close()")
  registerCloseLuaEvent(Panel_RandomBoxSelect, PAUIRenderModeBitSet({
    Defines.CloseType.eCloseType_Escape,
    Defines.CloseType.eCloseType_Attacked
  }), "FGlobal_Gacha_Roulette_Close()")
end
function gacha_Roulette:ResetPos()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
  local self = gacha_Roulette
  self.elapsTime = self.elapsTime + deltaTime
  if self.rouletteState == RouletteState.eRoll then
    soundPlayTime = soundPlayTime + deltaTime
    if soundPlayTime > 0.076 then
      audioPostEvent_SystemUi(11, 10)
      soundPlayTime = 0
    end
    if self.elapsTime > 1 and not self.pushSpace:GetShow() then
      self.pushSpace:SetShow(true)
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
    self.notify:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_NOTIFY", "autoLimitTime", autoLimitTime))
    if self.elapsTime > 30 then
      self.elapsTime = 0
      gacha_Roulette:Close()
    end
  end
end
function gacha_Roulette:Open()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  self.pushSpace:SetShow(false)
  self.notify:SetShow(false)
  self.pushSpace:SetVertexAniRun("Ani_Color_New", true)
  self.notify:SetVertexAniRun("Ani_Color_New", true)
  self.effectControl:EraseAllEffect()
  self.effectControl:AddEffect("fUI_Gacha_Spark01", true, 0, 50)
  if self.rouletteState == RouletteState.eRoll then
    SetUIMode(Defines.UIMode.eUIMode_Gacha_Roulette)
  end
end
function gacha_Roulette:Close()
  if PaGlobalFunc_GachaRoulette_GetShow() or PaGlobalFunc_RandomBoxSelect_GetShow() then
    PaGlobalFunc_GachaRoulette_SetShowPanel(false, false)
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
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  audioPostEvent_SystemUi(11, 12)
  if self.rollMode == 0 and self.elapsTime < 1.2 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GACHA_ROULETTE_NOTYETFUNCTION"))
    return
  end
  ToClient_StopRandomBox()
end
function PanelRandomBoxSelect_UpdateMode()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
  local self = gacha_Roulette
  if self.radioModeSpeedy:IsCheck() then
    self.rollMode = 1
    self.radioModeNormal:SetCheck(false)
    self.radioModeSpeedy:SetCheck(true)
  else
    self.rollMode = 0
    self.radioModeSpeedy:SetCheck(false)
    self.radioModeNormal:SetCheck(true)
  end
end
function PanelRandomBoxSelect_StartRoulette()
  PaGlobalFunc_GachaRoulette_SetShowPanel(true, false)
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
  Panel_RandomBoxSelect:SetShow(false)
  InventoryWindow_Close()
  gacha_Roulette:Open()
end
function PanelRandomBoxSelect_Cancel()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
  Panel_RandomBoxSelect:SetShow(false)
  gacha_Roulette:Close()
end
function FromClient_Gacha_Roulette_onScreenResize()
  if nil == Panel_Gacha_Roulette then
    return
  end
  Panel_Gacha_Roulette:SetPosX(getScreenSizeX() / 2 - Panel_Gacha_Roulette:GetSizeX() / 1.3)
  Panel_Gacha_Roulette:SetPosY(getScreenSizeY() / 2 - Panel_Gacha_Roulette:GetSizeY() * 1.1)
end
function FromClient_ShowRandomBox()
  local self = gacha_Roulette
  local isContinue = false
  PaGlobalFunc_GachaRoulette_SetShowPanel(true, false)
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
    Panel_RandomBoxSelect:SetShow(false)
  else
    Panel_RandomBoxSelect:SetShow(true)
    PanelRandomBoxSelect_UpdateMode()
  end
end
function FromClient_SelectRandomItem(itemKey)
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
  self.pushSpace:SetShow(false)
  self.notify:SetShow(false)
end
function FGlobal_Gacha_Roulette_ShowResult()
  if nil == Panel_Gacha_Roulette or nil == Panel_RandomBoxSelect then
    return
  end
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
    InventoryWindow_Show()
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
local _eGachaPanelType = {_gacha = 1, _randombox = 2}
function PaGlobalFunc_GachaRoulette_getPanel(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobalFunc_GachaRoulette_getPanel ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  if _eGachaPanelType._gacha == ePanelType then
    return Panel_Gacha_Roulette
  elseif _eGachaPanelType._randombox == ePanelType then
    return Panel_RandomBoxSelect
  end
  return nil
end
function PaGlobalFunc_GachaRoulette_setPanel(ePanelType, panel)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobalFunc_GachaRoulette_setPanel ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  UI.ASSERT_NAME(nil ~= panel, "PaGlobalFunc_GachaRoulette_setPanel panel nil", "\236\160\149\236\167\128\237\152\156")
  if PaGlobal_CharacterInfoPanel._eType._status == ePanelType then
    Panel_Gacha_Roulette = panel
  elseif PaGlobal_CharacterInfoPanel._eType._basic == ePanelType then
    Panel_RandomBoxSelect = panel
  end
end
function PaGlobalFunc_GachaRoulette_CheckLoadUIAll()
  local init_gacha = false
  local init_randombox = false
  init_gacha = PaGlobalFunc_GachaRoulette_CheckLoadUI(_eGachaPanelType._gacha)
  init_randombox = PaGlobalFunc_GachaRoulette_CheckLoadUI(_eGachaPanelType._randombox)
  if true == init_gacha or true == init_randombox then
    gacha_Roulette:Initialize()
  end
end
function PaGlobalFunc_GachaRoulette_CheckCloseUIAll(isAni)
  for k, v in pairs(_eGachaPanelType) do
    PaGlobalFunc_GachaRoulette_CheckCloseUI(v, isAni)
  end
end
function PaGlobalFunc_GachaRoulette_CheckLoadUI(ePanelType)
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobalFunc_GachaRoulette_CheckLoadUI ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  local rv
  if _eGachaPanelType._gacha == ePanelType then
    rv = reqLoadUI("UI_Data/Widget/Gacha_Roulette/Panel_Gacha_Roulette.XML", "Panel_Gacha_Roulette", Defines.UIGroup.PAGameUIGroup_Chatting, SETRENDERMODE_BITSET_DEFULAT())
  elseif _eGachaPanelType._randombox == ePanelType then
    rv = reqLoadUI("UI_Data/Window/RandomBoxSelect/Panel_RandomBoxSelect.XML", "Panel_RandomBoxSelect", Defines.UIGroup.PAGameUIGroup_WorldMap_Contents, SETRENDERMODE_BITSET_DEFULAT())
  end
  if nil ~= rv and nil ~= rv then
    PaGlobalFunc_GachaRoulette_setPanel(ePanelType, rv)
    rv = nil
    return true
  end
  return false
end
function PaGlobalFunc_GachaRoulette_CheckCloseUI(ePanelType, isAni)
  if nil == ePanelType then
    return
  end
  UI.ASSERT_NAME(nil ~= ePanelType, "PaGlobalFunc_GachaRoulette_CheckCloseUI ePanelType nil", "\236\160\149\236\167\128\237\152\156")
  local panel = PaGlobalFunc_GachaRoulette_getPanel(ePanelType)
  if nil == panel then
    return
  end
  reqCloseUI(panel, isAni)
end
function PaGlobalFunc_GachaRoulette_GetShow()
  if nil == Panel_Gacha_Roulette then
    return false
  end
  return Panel_Gacha_Roulette:GetShow()
end
function PaGlobalFunc_RandomBoxSelect_GetShow()
  if nil == Panel_RandomBoxSelect then
    return false
  end
  return Panel_RandomBoxSelect:GetShow()
end
function PaGlobalFunc_GachaRoulette_SetShowPanel(isShow, isAni)
  UI.ASSERT_NAME(nil ~= isShow, "PaGlobalFunc_GachaRoulette_SetShowPanel isShow nil", "\236\160\149\236\167\128\237\152\156")
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_RandomBoxSelect:SetShow(isShow, isAni)
    return
  end
  if true == isShow then
    PaGlobalFunc_GachaRoulette_CheckLoadUIAll()
    if nil ~= Panel_RandomBoxSelect then
      Panel_RandomBoxSelect:SetShow(isShow, isAni)
    end
  else
    PaGlobalFunc_GachaRoulette_CheckCloseUIAll(isAni)
  end
end
function gacha_Roulette:registEventHandler()
  registerEvent("onScreenResize", "FromClient_Gacha_Roulette_onScreenResize")
  registerEvent("FromClient_ShowRandomBox", "FromClient_ShowRandomBox")
  registerEvent("FromClient_SelectRandomItem", "FromClient_SelectRandomItem")
  registerEvent("FromClient_CloseRandomBox", "FromClient_CloseRandomBox")
end
function FromClient_luaLoadComplete_GachaRoulette()
  gacha_Roulette:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GachaRoulette")
