Panel_Window_FairyUpgrade:SetShow(false)
local UI_TM = CppEnums.TextMode
local FairyUpgrade = {
  _UI = {
    _close = UI.getChildControl(Panel_Window_FairyUpgrade, "Button_Win_Close"),
    _mainBG = UI.getChildControl(Panel_Window_FairyUpgrade, "Static_MainBG"),
    _upgrade = UI.getChildControl(Panel_Window_FairyUpgrade, "Button_Upgrade"),
    _bottomDescBG = UI.getChildControl(Panel_Window_FairyUpgrade, "Static_BottomBG")
  },
  _isAnimating = false,
  _currentItemEnchantKey = nil,
  _currentItemSlotNo = 0,
  _currentItemStackCount = 0,
  _const_aniTime = 2.3,
  _ani_TimeStamp = 0,
  _previewExpRate = 0,
  _previewLevel = 0,
  _diffExp = 0,
  _animeLv = 0,
  _animeExp = 0
}
FairyUpgrade._UI._iconFairy = UI.getChildControl(FairyUpgrade._UI._mainBG, "Static_FairyBG")
FairyUpgrade._UI._bottomDesc = UI.getChildControl(FairyUpgrade._UI._bottomDescBG, "StaticText_BottomDesc")
function PaGlobal_FairyUpgrade_Open(PositionReset)
  PaGlobalFunc_fairySkill_Close()
  ClothInventory_Close()
  if Panel_Window_FairySetting:GetShow() then
    PaGlobal_FairySetting_Close()
  end
  if Panel_Window_FairyUpgrade:GetShow() then
    PaGlobal_FairyUpgrade_Close()
    return
  end
  if _ContentsGroup_FairyTierUpgradeAndRebirth and Panel_Window_FairyTierUpgrade:GetShow() then
    PaGlobal_FairyTierUpgrade_Close()
  end
  if true == PaGlobal_FairyInfo_isMaxLevel() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoCantFairyFusionLevel"))
    return
  end
  if ToClient_getFairyUnsealedList() < 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoNeedUnsealFairy"))
    return
  end
  if true == PositionReset then
    FairyUpgrade:SetPosition()
  end
  HandleClicked_Inventory_FairyFeed_Open()
  Panel_Window_Inventory:SetShow(true)
  Inventory_SetFunctor(PaGlobal_Fairy_FileterForFeeding, nil, PaGlobal_FairyUpgrade_Close, nil)
  FairyUpgrade:Clear()
  FairyUpgrade:Open()
  Panel_Window_FairyUpgrade:SetShow(true)
end
function PaGlobal_FairyUpgrade_RClickItemByNumberPad(count, slotNo, itemKey)
  local self = FairyUpgrade
  if nil == itemKey then
    return
  end
  if true == self._isAnimating then
    return
  end
  self._currentItemEnchantKey = itemKey
  local itemSSW = getItemEnchantStaticStatus(self._currentItemEnchantKey)
  self._currentItemSlotNo = slotNo
  self._currentItemStackCount = Int64toInt32(count)
  if nil == itemSSW then
    return
  end
  self._UI._feedIcon:ChangeTextureInfoName("Icon/" .. itemSSW:getIconPath())
  self._UI._feedIcon:SetShow(true)
  self._UI._checkBtn:SetShow(false)
  ToClient_CalculateUpgradeExp(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemEnchantKey, self._currentItemSlotNo, self._currentItemStackCount, self._UI._checkBtn:IsCheck())
  self._previewExpRate = ToClient_GetFutureFairyExp()
  self._previewLevel = ToClient_GetFutureFairyLevel()
  self._currentItemStackCount = Int64toInt32(ToClient_GetFeedCount())
  self:Open()
end
function PaGlobal_FairyUpgrade_RClickItem(value, slotNo, count)
  local self = FairyUpgrade
  if nil == value then
    return
  end
  if true == self._isAnimating then
    return
  end
  self._currentItemEnchantKey = value
  local itemSSW = getItemEnchantStaticStatus(self._currentItemEnchantKey)
  self._currentItemSlotNo = slotNo
  self._currentItemStackCount = Int64toInt32(count)
  if nil == itemSSW then
    return
  end
  self._UI._feedIcon:ChangeTextureInfoName("Icon/" .. itemSSW:getIconPath())
  self._UI._feedIcon:SetShow(true)
  self._UI._checkBtn:SetShow(true)
  ToClient_CalculateUpgradeExp(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemEnchantKey, self._currentItemSlotNo, self._currentItemStackCount, self._UI._checkBtn:IsCheck())
  self._previewExpRate = ToClient_GetFutureFairyExp()
  self._previewLevel = ToClient_GetFutureFairyLevel()
  self:Open()
end
function PaGlobal_FairyUpgrade_Close()
  Panel_Window_FairyUpgrade:SetShow(false)
  HandleClicked_InventoryWindow_Close()
end
function FairyUpgrade:Clear()
  self._currentItemEnchantKey = nil
  self._UI._checkBtn:SetCheck(false)
  self._UI._feedIcon:SetShow(false)
  self._currentItemSlotNo = 0
  self._currentItemStackCount = 0
  self._isAnimating = false
  self._ani_TimeStamp = 0
  self._UI._checkBtn:SetIgnore(false)
  self._UI._checkBtn:SetMonoTone(false)
  self._previewExpRate = 0
  self._previewLevel = 0
  self._UI._upgrade:SetIgnore(false)
  self._UI._upgrade:SetMonoTone(false)
  self._animeExp = 0
  self._animeLv = 0
  self._diffExp = 0
end
function FairyUpgrade:Open()
  if nil ~= PaGlobal_FairyInfo_GetIconPath() then
    self._UI._fairyIcon:ChangeTextureInfoName(PaGlobal_FairyInfo_GetIconPath())
  end
  if nil ~= PaGlobal_FairyInfo_GetFairyName() then
    self._UI._fairyName:SetText(PaGlobal_FairyInfo_GetFairyName())
  else
    self._UI._fairyName:SetText("-")
  end
  if true == PaGlobal_FairyInfo_isMaxLevel() then
    PaGlobal_FairyUpgrade_Close()
    return
  end
  if self._currentItemStackCount <= 1 then
    self._UI._feedCount:SetShow(false)
  else
    self._UI._feedCount:SetText(self._currentItemStackCount)
    self._UI._feedCount:SetShow(true)
  end
  local ExpRate = PaGlobal_FairyInfo_CurrentExpRate()
  local currentLevel = PaGlobal_FairyInfo_GetLevel()
  self._UI._progressCurrent:SetProgressRate(ExpRate)
  self._UI._progressCurrent:SetCurrentProgressRate(ExpRate)
  self._UI._progressPreview:SetProgressRate(0)
  self._UI._progressPreview:SetCurrentProgressRate(0)
  self._UI._previewLevelText:SetText("Lv." .. tostring(currentLevel))
  self._UI._previewExpRateText:SetText(string.format("%.2f", ExpRate) .. "%")
  if currentLevel < self._previewLevel then
    self._UI._progressCurrent:SetProgressRate(0)
    self._UI._progressCurrent:SetCurrentProgressRate(0)
    self._UI._progressPreview:SetProgressRate(self._previewExpRate * 100)
    self._UI._progressPreview:SetCurrentProgressRate(self._previewExpRate * 100)
    self._UI._previewLevelText:SetText("Lv." .. tostring(self._previewLevel))
    self._UI._previewExpRateText:SetText(string.format("%.2f", self._previewExpRate * 100) .. "%")
  elseif currentLevel == self._previewLevel and 0 ~= self._previewLevel then
    self._UI._progressPreview:SetProgressRate(self._previewExpRate * 100)
    self._UI._progressPreview:SetCurrentProgressRate(self._previewExpRate * 100)
    self._UI._previewExpRateText:SetText(string.format("%.2f", self._previewExpRate * 100) .. "%")
  elseif (PaGlobal_FairyInfo_FairyTier() + 1) * 10 == self._previewLevel then
    self._UI._previewLevelText:SetText("Lv." .. tostring(self._previewLevel))
    self._UI._progressPreview:SetProgressRate(100)
    self._UI._progressPreview:SetCurrentProgressRate(100)
    self._UI._previewExpRateText:SetText(string.format("%.2f", 100) .. "%")
  end
end
function PaGlobal_FairyUpgrade_Request()
  local self = FairyUpgrade
  if nil == self._currentItemEnchantKey then
    return
  end
  local function FunctionYesOverExp()
    audioPostEvent_SystemUi(21, 0)
    _AudioPostEvent_SystemUiForXBOX(21, 0)
    self._isAnimating = true
    self._UI._checkBtn:SetIgnore(true)
    self._UI._checkBtn:SetMonoTone(true)
    self._UI._checkBtn:SetCheck(false)
    self._UI._upgrade:SetIgnore(true)
    self._UI._upgrade:SetMonoTone(true)
    FairyUpgrade._UI._iconFairy:AddEffect("CO_UI_Fairy_01A", false, -53, -78)
    FairyUpgrade._UI._iconFairy:AddEffect("CO_UI_Fairy_01B", false, 53, -78)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_01A", false, 0, -50)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_02B", false, 0, -89)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_03A", false, 0, -88)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_04A", false, 1, 103)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_02A", false, 1, 103)
    FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_05A", false, 1, 103)
  end
  local function FunctionYes()
    if nil == self._currentItemEnchantKey then
      return
    end
    local isOverExp = ToClient_isOverExpFairyFeeding(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemEnchantKey, self._currentItemStackCount)
    if false == isOverExp then
      audioPostEvent_SystemUi(21, 0)
      _AudioPostEvent_SystemUiForXBOX(21, 0)
      self._isAnimating = true
      self._UI._checkBtn:SetIgnore(true)
      self._UI._checkBtn:SetMonoTone(true)
      self._UI._upgrade:SetIgnore(true)
      self._UI._upgrade:SetMonoTone(true)
      FairyUpgrade._UI._iconFairy:AddEffect("CO_UI_Fairy_01A", false, -53, -78)
      FairyUpgrade._UI._iconFairy:AddEffect("CO_UI_Fairy_01B", false, 53, -78)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_01A", false, 0, -50)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_02B", false, 0, -89)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_03A", false, 0, -88)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_04A", false, 1, 103)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_02A", false, 1, 103)
      FairyUpgrade._UI._iconFairy:AddEffect("fUI_Fairy_05A", false, 1, 103)
    else
      local __title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
      local __contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_UPGRADE_OVEREXP_ALERT")
      local __messageBoxData = {
        title = __title,
        content = __contenet,
        functionYes = FunctionYesOverExp,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(__messageBoxData)
    end
  end
  _futureLevel = self._previewLevel
  _futureExp = self._previewExpRate
  local ExpRate = PaGlobal_FairyInfo_CurrentExpRate() / 100
  local currentLevel = PaGlobal_FairyInfo_GetLevel()
  local diffLevel = _futureLevel - currentLevel
  if diffLevel > 0 then
    self._diffExp = (_futureExp + diffLevel + (1 - ExpRate)) / self._const_aniTime - 0.3
  else
    self._diffExp = (_futureExp - ExpRate) / (self._const_aniTime - 0.3)
  end
  self._animeLv = currentLevel
  self._animeExp = ExpRate
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING")
  local _contenet = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_UPGRADE_ALERT")
  local messageBoxData = {
    title = _title,
    content = _contenet,
    functionYes = FunctionYes,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function UpdateFunc_FairyUpgradeAni(deltaTime)
  local self = FairyUpgrade
  if true == self._isAnimating then
    self._ani_TimeStamp = self._ani_TimeStamp + deltaTime
    self._animeExp = self._animeExp + self._diffExp * deltaTime
    if self._animeExp > 1 then
      self._animeLv = self._animeLv + 1
      self._animeExp = self._animeExp - 1
    end
    if self._previewLevel <= self._animeLv then
      self._animeLv = self._previewLevel
      if self._previewExpRate <= self._animeExp then
        self._animeExp = self._previewExpRate
      end
    end
    self._UI._progressPreview:SetProgressRate(self._animeExp * 100)
    self._UI._progressPreview:SetCurrentProgressRate(self._animeExp * 100)
    self._UI._previewLevelText:SetText("Lv." .. tostring(self._animeLv))
    self._UI._previewExpRateText:SetText(string.format("%.2f", self._animeExp * 100) .. "%")
    if self._const_aniTime <= self._ani_TimeStamp then
      self._isAnimating = false
      ToClient_FairyFeedingRequest(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemEnchantKey, self._currentItemSlotNo, self._currentItemStackCount, self._UI._checkBtn:IsCheck())
      self._ani_TimeStamp = 0
      self._UI._upgrade:SetIgnore(false)
      self._UI._upgrade:SetMonoTone(false)
    end
  end
end
function FairyUpgrade:SetPosition()
  Panel_Window_FairyUpgrade:SetPosX(Panel_FairyInfo:GetPosX() + Panel_FairyInfo:GetSizeX() / 2 - Panel_Window_FairyUpgrade:GetSizeX() / 2)
  Panel_Window_FairyUpgrade:SetPosY(Panel_FairyInfo:GetPosY() + 20)
end
function PaGlobal_FairyUpgrade_UpdateExp()
  local self = FairyUpgrade
  if nil == self._currentItemEnchantKey then
    return
  end
  ToClient_CalculateUpgradeExp(PaGlobal_FairyInfo_GetFairyNo(), self._currentItemEnchantKey, self._currentItemSlotNo, self._currentItemStackCount, self._UI._checkBtn:IsCheck())
  self._previewExpRate = ToClient_GetFutureFairyExp()
  self._previewLevel = ToClient_GetFutureFairyLevel()
  self:Open()
end
function FairyUpgrade:Initialize()
  Panel_Window_FairyUpgrade:RegisterUpdateFunc("UpdateFunc_FairyUpgradeAni")
  self._UI._close:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_Close()")
  self._UI._fairyName = UI.getChildControl(self._UI._mainBG, "StaticText_MainBGTitle")
  self._UI._fairyIcon = UI.getChildControl(self._UI._mainBG, "Static_FairyIcon")
  self._UI._feedIcon = UI.getChildControl(self._UI._mainBG, "Static_StoneIcon")
  self._UI._checkBtn = UI.getChildControl(self._UI._mainBG, "CheckButton_Stream")
  self._UI._checkBtn:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_UpdateExp()")
  self._UI._checkBtn:addInputEvent("Mouse_On", "FairyUpgrade_SimpleTooltips(true, 0)")
  self._UI._checkBtn:addInputEvent("Mouse_Out", "FairyUpgrade_SimpleTooltips(false)")
  self._UI._progressCurrent = UI.getChildControl(self._UI._mainBG, "Progress2_Exp")
  self._UI._progressPreview = UI.getChildControl(self._UI._mainBG, "Progress2_PreviewExp")
  self._UI._previewLevelText = UI.getChildControl(self._UI._mainBG, "Static_PreviewLevel")
  self._UI._previewExpRateText = UI.getChildControl(self._UI._mainBG, "Static_PreviewExpRate")
  self._UI._upgrade:addInputEvent("Mouse_LUp", "PaGlobal_FairyUpgrade_Request()")
  self._UI._feedCount = UI.getChildControl(self._UI._feedIcon, "StaticText_StoneCount")
  self._UI._feedIcon:addInputEvent("Mouse_On", "PaGlobal_FairyUpgrade_ShowToolTip(true)")
  self._UI._feedIcon:addInputEvent("Mouse_Out", "PaGlobal_FairyUpgrade_ShowToolTip(false)")
  self._UI._feedIcon:addInputEvent("Mouse_RUp", "PaGlobal_FairyUpgrade_ClearFeedItem()")
  self._UI._bottomDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._UI._bottomDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_FAIRY_UPGRADE_DEC"))
  self._UI._bottomDesc:SetSize(self._UI._bottomDesc:GetSizeX(), self._UI._bottomDesc:GetTextSizeY())
  self._UI._bottomDescBG:SetSize(self._UI._bottomDescBG:GetSizeX(), self._UI._bottomDesc:GetTextSizeY() + 20)
  self._UI._bottomDesc:SetSpanSize(0, 0)
  Panel_Window_FairyUpgrade:SetSize(Panel_Window_FairyUpgrade:GetSizeX(), 470 + self._UI._bottomDescBG:GetSizeY())
  self._UI._checkBtn:SetEnableArea(0, 0, self._UI._checkBtn:GetTextSizeX() + self._UI._checkBtn:GetSizeX() + 10, self._UI._checkBtn:GetSizeY())
  self._UI._checkBtn:SetPosX(self._UI._mainBG:GetSizeX() / 2 - (self._UI._checkBtn:GetTextSizeX() + self._UI._checkBtn:GetSizeX()) / 2)
  self._UI._upgrade:ComputePos()
end
function PaGlobal_FairyUpgrade_OnlyUpdate()
  local self = FairyUpgrade
  self:Open()
end
function PaGlobal_Fairy_FileterForFeeding(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  if true == itemWrapper:isFairyFeedItem() then
    return false
  end
  return true
end
function PaGlobal_FairyUpgrade_ShowToolTip(isShow)
  local self = FairyUpgrade
  local itemSSW
  itemSSW = getItemEnchantStaticStatus(self._currentItemEnchantKey)
  if nil == itemSSW then
    return
  end
  if true == isShow then
    Panel_Tooltip_Item_SetPosition(0, self._UI._feedIcon, "fairyUpgrade")
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_FairyUpgrade, true)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function FairyUpgrade_SimpleTooltips(isShow, idx)
  local self = FairyUpgrade
  local name, desc, uiControl
  if 0 == idx then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_CONTINUITY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_FAIRY_INFO_CONTINUITY_DESC")
    uiControl = self._UI._checkBtn
  end
  if isShow == true then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_FairyUpgrade_ClearFeedItem()
  local self = FairyUpgrade
  if true == self._isAnimating then
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  self:Clear()
  self:Open()
end
function FromClient_PetInfoChanged(petNo)
  if true == Panel_Window_FairyUpgrade:GetShow() and petNo == PaGlobal_FairyInfo_GetFairyNo() then
    FairyUpgrade:Clear()
    FairyUpgrade:Open()
  end
end
FairyUpgrade:Initialize()
registerEvent("FromClient_PetInfoChanged", "FromClient_PetInfoChanged")
