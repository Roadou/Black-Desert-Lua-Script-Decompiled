Panel_Window_StableStallion:SetShow(false)
Panel_Window_StableStallion:setMaskingChild(true)
Panel_Window_StableStallion:ActiveMouseEventEffect(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local StableStallion = {
  _config = {
    baseSlot = {
      startX = 7,
      startY = 104,
      stallionNotifyPosX = 15,
      stallionNotifyPosY = 450,
      gapX = 122
    },
    Pos = {
      gapX = 122,
      skillTextPosX = 0,
      skillTextPosY = 6,
      expGaugePosX = 29,
      expGaugePosY = 30,
      iconPosX = 35,
      iconPosY = 36,
      trainingBtnPosX = 6,
      trainingBtnPosY = 155,
      itemPosX = 35,
      itemPosY = 109,
      expCountX = 42,
      expCountY = 60,
      meterialPosX = 30,
      meterialPosY = 87,
      selectedBGPosX = -10,
      selectedBGPosY = -9
    },
    skill = {count = 3}
  },
  _closeBtn = UI.getChildControl(Panel_Window_StableStallion, "Button_Close"),
  _stallionNotifyBG = UI.getChildControl(Panel_Window_StableStallion, "Static_DescBg"),
  _stallionNotify = UI.getChildControl(Panel_Window_StableStallion, "StaticText_StallionDesc"),
  _upgradeBG = UI.getChildControl(Panel_Window_StableStallion, "Static_UpgradeBG"),
  _stackBG = UI.getChildControl(Panel_Window_StableStallion, "Static_PotenBG"),
  awaken = {
    _awakenIconBG = UI.getChildControl(Panel_Window_StableStallion, "Static_AwakenIconBG"),
    _awakenIcon = UI.getChildControl(Panel_Window_StableStallion, "Static_AwakenIcon"),
    _awakenCount = UI.getChildControl(Panel_Window_StableStallion, "StaticText_AwakenItemCount"),
    _awakenExpBG = UI.getChildControl(Panel_Window_StableStallion, "Static_AwakenExpBG"),
    _awakenExp = UI.getChildControl(Panel_Window_StableStallion, "Static_AwakenExp"),
    _awakenExpCount = UI.getChildControl(Panel_Window_StableStallion, "Static_AwakenPercentString"),
    _awakenButton = UI.getChildControl(Panel_Window_StableStallion, "Button_AwakenTraining"),
    _awakenArea = UI.getChildControl(Panel_Window_StableStallion, "Static_SelectedAwakenArea"),
    _isEnableAwaken = false,
    _awakenSlotNo = 0,
    _awakenItemCount = 0,
    _awaken = {}
  },
  protect = {
    _protectMainBG = UI.getChildControl(Panel_Window_StableStallion, "Static_ProtectBG"),
    _protectIconBG = UI.getChildControl(Panel_Window_StableStallion, "Static_ProtectIconBG"),
    _protectIcon = UI.getChildControl(Panel_Window_StableStallion, "Static_ProtectIcon"),
    _protectCount = UI.getChildControl(Panel_Window_StableStallion, "StaticText_ProtectItemCount"),
    _protectButton = UI.getChildControl(Panel_Window_StableStallion, "CheckButton_ProtectItem"),
    _protectItemDescBG = UI.getChildControl(Panel_Window_StableStallion, "Static_ProtectItemDescBg"),
    _protectItemDesc = UI.getChildControl(Panel_Window_StableStallion, "StaticText_ProtectItemDesc"),
    _isEnableProtect = false,
    _protectSlotNo = 0,
    _protectItemCount = 0,
    _protect = {}
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true
  },
  _slotCount = 3,
  _slots = Array.new(),
  _selectedItemSlotNo = {},
  _selectedItemWhereType = 0,
  _index = 0,
  _itemCount = {},
  _skillExpCount = {},
  _awakenExpCount = 0,
  _buttonClick = -1,
  _elapsedTime = 0,
  _effectType = 0,
  _awakenDoing = false,
  _selectedServantIndex = 0,
  _isExpUp = {},
  _servantNo = nil
}
StableStallion._stackValue = UI.getChildControl(StableStallion._stackBG, "StaticText_PotenText")
local inventoryItemSSW
local selectedItemWhereType = CppEnums.ItemWhereType.eInventory
function StableStallion:init()
  for ii = 0, self._slotCount - 1 do
    local slot = {}
    slot._panel = Panel_Window_StableStallion
    slot._startSlotIndex = 0
    slot._mainBG = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_MainBG", self._upgradeBG, "servantMainBG_" .. ii)
    slot._skillText = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_SkillText", slot._mainBG, "servantStallion_Slot_SkillText_" .. ii)
    slot._skillIcon = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_SkillIcon", slot._mainBG, "servantStallion_Slot_SkillIcon_" .. ii)
    slot._skillExpBG = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_SkillExpBG", slot._mainBG, "servantStallion_Slot_SkillExpBG_" .. ii)
    slot._skillExp = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_SkillExp", slot._mainBG, "servantStallion_Slot_SkillExp_" .. ii)
    slot._materialTitel = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "StaticText_MaterialTitle", slot._mainBG, "servantStallion_Slot_materialTitle_" .. ii)
    slot._itemSlotBG = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_ItemSlotBG", slot._mainBG, "servantStallion_itemSlotBG_" .. ii)
    slot._itemSlot = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_ItemSlot", slot._mainBG, "servantStallion_itemSlot_" .. ii)
    slot._skillPercent = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Skill_PercentString", slot._mainBG, "servantStallion_Slot_EXPValue_" .. ii)
    slot._buttonTraining = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Button_StallionTraining", slot._mainBG, "servantMarket_End_" .. ii)
    slot._selectedSkillBG = UI.createAndCopyBasePropertyControl(Panel_Window_StableStallion, "Static_SelectedSkillBg", slot._mainBG, "selectedSkillBG_" .. ii)
    SlotItem.new(slot, "ItemIcon_" .. ii, ii, slot._itemSlotBG, self.slotConfig)
    slot:createChild()
    local slotConfig = self._config.baseSlot
    slot._mainBG:SetPosX(slotConfig.startX + slotConfig.gapX * ii)
    slot._mainBG:SetPosY(slotConfig.startY)
    local slotConfig = self._config.Pos
    slot._skillIcon:SetPosX(slotConfig.iconPosX)
    slot._skillIcon:SetPosY(slotConfig.iconPosY)
    slot._skillExpBG:SetPosX(slotConfig.expGaugePosX)
    slot._skillExpBG:SetPosY(slotConfig.expGaugePosY)
    slot._skillExp:SetPosX(slotConfig.expGaugePosX + 2)
    slot._skillExp:SetPosY(slotConfig.expGaugePosY + 2)
    slot._skillText:SetPosX(slotConfig.skillTextPosX)
    slot._skillText:SetPosY(slotConfig.skillTextPosY)
    slot._skillPercent:SetPosX(slotConfig.expCountX)
    slot._skillPercent:SetPosY(slotConfig.expCountY)
    slot._itemSlotBG:SetPosX(slotConfig.itemPosX)
    slot._itemSlotBG:SetPosY(slotConfig.itemPosY)
    slot._itemSlot:SetPosX(slotConfig.itemPosX)
    slot._itemSlot:SetPosY(slotConfig.itemPosY)
    slot._buttonTraining:SetPosX(slotConfig.trainingBtnPosX)
    slot._buttonTraining:SetPosY(slotConfig.trainingBtnPosY)
    slot._materialTitel:SetPosX(slotConfig.meterialPosX)
    slot._materialTitel:SetPosY(slotConfig.meterialPosY)
    slot._selectedSkillBG:SetPosX(slotConfig.selectedBGPosX)
    slot._selectedSkillBG:SetPosY(slotConfig.selectedBGPosY)
    slot._buttonTraining:SetAutoDisableTime(1)
    slot._buttonTraining:addInputEvent("Mouse_LUp", "StableStallion_Training(" .. ii .. ")")
    slot._itemSlot:addInputEvent("Mouse_RUp", "Set_StallionItemSlotClick(" .. ii .. ")")
    slot._mainBG:addInputEvent("Mouse_LUp", "Set_StallionItemSlotClick(" .. ii .. ")")
    slot._buttonTraining:SetShow(true)
    slot._skillIcon:SetShow(true)
    slot._skillExpBG:SetShow(true)
    slot._skillExp:SetShow(true)
    slot._skillText:SetShow(true)
    slot._skillPercent:SetShow(true)
    slot._materialTitel:SetShow(true)
    slot._selectedSkillBG:SetShow(false)
    slot._skillIcon:SetIgnore(true)
    slot._skillExpBG:SetIgnore(true)
    slot._skillExp:SetIgnore(true)
    slot._skillText:SetIgnore(true)
    slot._skillPercent:SetIgnore(true)
    slot._selectedSkillBG:SetIgnore(true)
    slot._itemSlot:SetShow(false)
    self._itemCount[ii] = 0
    self._slots[ii] = slot
  end
  self._upgradeBG:SetShow(true)
  self._stallionNotify:SetShow(true)
  self._stallionNotify:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._stallionNotify:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_NOTIFY"))
  self.protect._protectItemDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.protect._protectItemDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_PROTECTITEMNOTIFY"))
  self.protect._protectButton:SetText("")
  self.awaken._awakenButton:addInputEvent("Mouse_LUp", "Awaken_Training()")
  self._closeBtn:addInputEvent("Mouse_LUp", "StableStallion_Close()")
  self.awaken._awakenIcon:SetIgnore(false)
  self.protect._protectIcon:SetIgnore(false)
  for i = 0, self._slotCount - 1 do
    self._selectedItemSlotNo[i] = nil
    self._isExpUp[i] = false
  end
  StableStallion_SetPos()
end
local over_SlotEffect
function StableStallion:registEventHandler()
  registerEvent("FromClient_IncreaseStallionSkillExpAck", "FromClient_IncreaseStallionSkillExpAck")
  registerEvent("FromClient_CompleteStallionTrainingAck", "FromClient_CompleteStallionTrainingAck")
end
function StableStallion_Open(servantNo)
  local self = StableStallion
  Panel_Window_StableStallion:SetShow(true)
  self._servantNo = servantNo
  self:Refresh_UIData()
  self._slots[0]._selectedSkillBG:SetShow(true)
  Set_StallionItemSlotClick(0)
  StableFunction_Buttonclose()
  local skillCount = stable_getStallionTrainingSkillCount()
  for i = 0, skillCount - 1 do
    local skillWrapper = stable_getStallionTrainingSkillListAt(i)
    if nil ~= skillWrapper then
      self._slots[i]._skillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
      self._slots[i]._skillText:SetText(skillWrapper:getName())
    end
  end
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  local skillCount = servantInfo:getSkillCount()
  for i = 0, self._slotCount - 1 do
    local satllionSkillWrapper = stable_getStallionTrainingSkillListAt(i)
    local stallionSkillWrapperKey = satllionSkillWrapper:getKey()
    for ii = 1, skillCount - 1 do
      local skillWrapper = servantInfo:getSkill(ii)
      if nil ~= skillWrapper then
        local skillKey = skillWrapper:getKey()
        if stallionSkillWrapperKey == skillKey then
          self._skillExpCount[i] = servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100)
          if 0 ~= self._skillExpCount[i] then
            self._isExpUp[i] = true
          else
            self._isExpUp[i] = false
          end
        end
      end
    end
  end
end
function StableStallion_Close()
  local self = StableStallion
  if not Panel_Window_StableStallion:GetShow() then
    return
  end
  if -1 < self._buttonClick then
    return
  end
  for index = 0, self._slotCount - 1 do
    self._slots[index]._itemSlot:ChangeTextureInfoName("")
    self._slots[index]._itemSlot:EraseAllEffect()
    self._slots[index]._selectedSkillBG:SetShow(false)
    self._slots[index]:clearItem()
    self._slots[index].icon:addInputEvent("Mouse_On", "HandleMOnoutTrainingItemToolTip()")
    self._selectedItemSlotNo[index] = nil
  end
  Panel_Window_StableStallion:SetShow(false)
  StableFunction_ButtonOpen()
  if Panel_Window_Inventory:GetShow() then
    Inventory_ShowToggle()
  end
  ItemNotify_Close()
  StableStallion_EffectErase()
  StableStallion_EffectClose()
  self._buttonClick = -1
  self._effectType = 0
  self._elapsedTime = 0
  StableStallion_HandleMOnoutProtectItemToolTip(false)
end
function StablStallion_Resize()
  screenX = getScreenSizeX()
  screenY = getScreenSizeY()
end
function StableStallion_Position()
  Panel_Window_StableStallion:SetPosX(getScreenSizeX() / 2 - Panel_Window_StableStallion:GetSizeX() / 2)
  Panel_Window_StableStallion:SetPosY(getScreenSizeY() / 2 - Panel_Window_StableStallion:GetSizeY() / 2)
end
function StableStallion_Resize()
  local self = StableStallion
  local screenX = getScreenSizeX()
  local screenY = getScreenSizeY()
  Panel_Window_StableStallion:ComputePos()
end
function StableStallion:protectItemCount()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local useStartSlot = inventorySlotNoUserStart()
  local normalInventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenUseSize = selfPlayer:getInventorySlotCount(false)
  local protectItemSSW = stable_getPreventStallionTrainingSkillExpItem()
  if nil ~= protectItemSSW then
    local protectItemName = protectItemSSW:getName()
    local protectItemSlotNo
    local protectItemCounts = 0
    for idx = useStartSlot, invenUseSize - 1 do
      local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, idx)
      if nil ~= itemWrapper then
        local itemSSW = itemWrapper:getStaticStatus()
        local itemName = itemSSW:getName()
        if protectItemName == itemName then
          protectItemSlotNo = idx
          protectItemCounts = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, idx):get():getCount_s64()
          break
        end
      end
    end
    if nil ~= protectItemSlotNo then
      return protectItemSlotNo, protectItemCounts
    else
      return protectItemSlotNo, toInt64(0, 0)
    end
  end
  StableStallion:Refresh_UIData()
end
function StableStallion:setProtectItem()
  local self = StableStallion
  local itemSSW = stable_getPreventStallionTrainingSkillExpItem()
  if nil ~= itemSSW then
    local name = itemSSW:getName()
    self.protect._protectIcon:ChangeTextureInfoName("Icon/" .. itemSSW:getIconPath())
    self.protect._protectIcon:SetMonoTone(false)
    local needCount = toInt64(0, 0)
    local haveCount = toInt64(0, 0)
    needCount = toInt64(0, stable_getPreventStallionTrainingSkillExpDownItemCount())
    self.protect._protectSlotNo, haveCount = self:protectItemCount()
    self.protect._protectButton:SetIgnore(true)
    self.protect._protectButton:SetMonoTone(true)
    if needCount > haveCount then
      haveCount = "<PAColor0xFFF26A6A>" .. tostring(haveCount) .. "<PAOldColor>"
      self.protect._protectIcon:SetMonoTone(true)
      self.protect._protectButton:SetIgnore(true)
      self.protect._protectButton:SetMonoTone(true)
      self._isEnableProtect = false
    else
      self.protect._protectIcon:SetMonoTone(false)
      self.protect._protectButton:SetIgnore(false)
      self.protect._protectButton:SetMonoTone(false)
      self._isEnableProtect = true
    end
    self.protect._protectCount:SetText(tostring(haveCount) .. "/" .. tostring(needCount))
    self.protect._protectIcon:addInputEvent("Mouse_On", "StableStallion_HandleMOnoutProtectItemToolTip( true )")
    self.protect._protectIcon:addInputEvent("Mouse_Out", "StableStallion_HandleMOnoutProtectItemToolTip( false )")
    self.protect._protectIcon:setTooltipEventRegistFunc("StableStallion_HandleMOnoutProtectItemToolTip( true )")
    local textSizeX = self.protect._protectCount:GetTextSizeX()
  end
end
function StableStallion_HandleMOnoutProtectItemToolTip(isShow)
  local self = StableStallion
  local itemSSW = FromClient_getPreventDownGradeItem()
  if isShow then
    registTooltipControl(self.protect._protectIcon, Panel_Tooltip_Item)
    Panel_Tooltip_Item_Show(itemSSW, self.protect._protectIcon, true, false, nil, nil, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function StableStallion:AwakenItemCount()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local useStartSlot = inventorySlotNoUserStart()
  local normalInventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local invenUseSize = selfPlayer:getInventorySlotCount(false)
  local awakenItemSSW = stable_getStallionTrainingCompleteRequiredItem()
  if nil ~= awakenItemSSW then
    local awakenItemName = awakenItemSSW:getName()
    local awakenItemSlotNo
    local awakenItemCounts = 0
    for idx = useStartSlot, invenUseSize - 1 do
      local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, idx)
      if nil ~= itemWrapper then
        local itemSSW = itemWrapper:getStaticStatus()
        local itemName = itemSSW:getName()
        if awakenItemName == itemName then
          awakenItemSlotNo = idx
          awakenItemCounts = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, idx):get():getCount_s64()
          break
        end
      end
    end
    if nil ~= awakenItemSlotNo then
      return awakenItemSlotNo, awakenItemCounts
    else
      return awakenItemSlotNo, toInt64(0, 0)
    end
  end
  StableStallion:Refresh_UIData()
end
function StableStallion:setAwakenitem()
  local itemSSW = stable_getStallionTrainingCompleteRequiredItem()
  if nil ~= itemSSW then
    self.awaken._awakenIcon:ChangeTextureInfoName("Icon/" .. itemSSW:getIconPath())
    self.awaken._awakenIcon:SetMonoTone(false)
    local needCount = toInt64(0, 1)
    local haveCount = toInt64(0, 0)
    self.awaken._awakenSlotNo, haveCount = self:AwakenItemCount()
    if needCount > haveCount then
      haveCount = "<PAColor0xFFF26A6A>" .. tostring(haveCount) .. "<PAOldColor>"
      self.awaken._awakenIcon:SetMonoTone(true)
      self._isEnableAwaken = false
    else
      self.awaken._awakenIcon:SetMonoTone(false)
      self._isEnableAwaken = true
    end
    self.awaken._awakenCount:SetText(tostring(haveCount) .. "/" .. tostring(needCount))
    self.awaken._awakenIcon:addInputEvent("Mouse_On", "HandleMOnoutAwakenItemToolTip( true )")
    self.awaken._awakenIcon:addInputEvent("Mouse_Out", "HandleMOnoutAwakenItemToolTip( false )")
    self.awaken._awakenIcon:setTooltipEventRegistFunc("HandleMOnoutAwakenItemToolTip( true )")
  end
end
function Set_StallionItemSlotClick(index)
  self = StableStallion
  if Panel_Window_Exchange_Number:GetShow() or -1 ~= self._buttonClick then
    return
  end
  self._index = index
  if Panel_Window_Inventory:GetShow() then
    Inventory_SetFunctor(InvenFilter_Stallion, nil, nil, nil)
  else
    Inventory_SetFunctor(InvenFilter_Stallion, nil, nil, nil)
    Inventory_ShowToggle()
  end
  for i = 0, self._slotCount - 1 do
    self._slots[i]._selectedSkillBG:SetShow(i == index)
  end
  local skillWrapper = stable_getStallionTrainingSkillListAt(index)
  local skillKey = skillWrapper:getKey()
  Stallion_ItemNotify(skillKey, index)
  audioPostEvent_SystemUi(0, 0)
end
function InvenFilter_Stallion(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local invenItemSSW = itemWrapper:getStaticStatus()
  if nil == invenItemSSW then
    return true
  end
  local self = StableStallion
  local skillWrapper = stable_getStallionTrainingSkillListAt(self._index)
  if nil ~= skillWrapper then
    local skillName = skillWrapper:getName()
    local skillKey = skillWrapper:getKey()
    local itemCount = stable_getStallionSkillItemListCount(skillKey)
    local itemSSW = {}
    for index = 0, itemCount - 1 do
      itemSSW[index] = stable_getStallionSkillItemListAt(skillKey, index)
      local itemName = itemSSW[index]:getName()
      local invenItemName = invenItemSSW:getName()
      if nil ~= itemSSW[index] and itemName == invenItemName then
        return false
      end
    end
  end
  return true
end
function Set_StallionItemSlot(count, slotNo, itemWrapper)
  local self = StableStallion
  local index = StableStallion._index
  self._selectedItemSlotNo[index] = slotNo
  selectedItemWhereType = whereType
  itemWrapper = getInventoryItemByType(selectedItemWhereType, slotNo)
  if nil == itemWrapper then
    return
  end
  if ToClient_Inventory_CheckItemLock(slotNo, selectedItemWhereType) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_ITEMLOCK"))
    return
  end
  self._itemCount[index] = Int64toInt32(count)
  self._slots[index]:setItem(itemWrapper)
  self._slots[index].count:SetText(tostring(count))
  self._slots[index].icon:AddEffect("UI_NewSkill01", false, 0, 0)
  self._slots[index].icon:addInputEvent("Mouse_On", "HandleMOnoutTrainingItemToolTip(" .. index .. "," .. slotNo .. ")")
  self._slots[index].icon:addInputEvent("Mouse_Out", "HandleMOnoutTrainingItemToolTip()")
end
function HandleMOnoutAwakenItemToolTip(isShow)
  local self = StableStallion
  local itemSSW = stable_getStallionTrainingCompleteRequiredItem()
  if isShow then
    registTooltipControl(self.awaken._awakenIcon, Panel_Tooltip_Item)
    Panel_Tooltip_Item_Show(itemSSW, self.awaken._awakenIcon, true, false, nil, nil, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function HandleMOnoutTrainingItemToolTip(index, slotNo)
  if nil == index then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local self = StableStallion
  if nil ~= self._selectedItemWhereType then
    local itemWrapper = getInventoryItemByType(self._selectedItemWhereType, slotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      registTooltipControl(self._slots[index].icon, Panel_Tooltip_Item)
      Panel_Tooltip_Item_Show(itemSSW, self._slots[index].icon, true, false, nil, nil, nil)
    end
  end
end
function StableStallion_Training(index)
  if Panel_Window_Exchange_Number:GetShow() then
    return
  end
  local self = StableStallion
  Set_StallionItemSlotClick(index)
  if 0 ~= self._effectType then
    return
  end
  if 0 == self._itemCount[index] then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_ITEMREGISTER"))
    return
  end
  local itemWrapper = getInventoryItemByType(selectedItemWhereType, self._selectedItemSlotNo[index])
  if nil == itemWrapper then
    return
  end
  local skillWrapper = stable_getStallionTrainingSkillListAt(index)
  local skillKey = skillWrapper:getKey()
  ToClient_increaseStallionSkillExpByItem(skillKey, self._servantNo, selectedItemWhereType, self._selectedItemSlotNo[index], self._itemCount[index])
  self._index = index
  if false == self._isExpUp[index] then
    self._isExpUp[index] = true
  end
end
function Awaken_Training()
  if Panel_Window_Exchange_Number:GetShow() then
    return
  end
  local self = StableStallion
  if 0 ~= self._effectType then
    return
  end
  local isAwaken = ToClient_isCompleteStallionTraining(self._servantNo)
  local needCount = toInt64(0, 1)
  local haveCount = toInt64(0, 0)
  self.awaken._awakenSlotNo, haveCount = self:AwakenItemCount()
  if needCount > haveCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_AWAKENITEM"))
    return
  end
  if false == isAwaken then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_AWAKENGAUGELACK"))
    return
  end
  local contentStr = PAGetString(Defines.StringSheet_GAME, "LUA_STABLESTALLION_TEXT_LOOKCHANGEWARNING")
  local messageboxData = {
    title = "",
    content = contentStr,
    functionYes = Awaken_Training_Yes,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
    exitButton = true
  }
  MessageBox.showMessageBox(messageboxData)
end
function Awaken_Training_Yes()
  local self = StableStallion
  self._buttonClick = 1
  self._awakenDoing = true
end
function Awaken_Training_isNineTier()
  local self = StableStallion
  local awakenItemWrapper = stable_getStallionTrainingCompleteRequiredItem()
  if nil == awakenItemWrapper then
    return
  end
  local whereType = CppEnums.ItemWhereType.eInventory
  local protectWrapper = stable_getPreventStallionTrainingSkillExpItem()
  if nil == protectWrapper then
    return
  end
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local useStartSlot = inventorySlotNoUserStart()
  local invenUseSize = selfPlayer:getInventorySlotCount(false)
  local itemSlotNo = CppEnums.TInventorySlotNoUndefined
  local protectSlotNo = CppEnums.TInventorySlotNoUndefined
  local itemKey = awakenItemWrapper:get()._key:getItemKey()
  local protectKey = protectWrapper:get()._key:getItemKey()
  for idx = useStartSlot, invenUseSize - 1 do
    local itemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, idx)
    if nil ~= itemWrapper then
      local invenItemSSW = itemWrapper:getStaticStatus()
      if itemKey == invenItemSSW:get()._key:getItemKey() then
        itemSlotNo = idx
      end
      if protectKey == invenItemSSW:get()._key:getItemKey() then
        protectSlotNo = idx
      end
      if CppEnums.TInventorySlotNoUndefined ~= itemSlotNo and CppEnums.TInventorySlotNoUndefined ~= protectSlotNo then
        break
      end
    end
  end
  if CppEnums.TInventorySlotNoUndefined ~= itemSlotNo then
    if not self.protect._protectButton:IsCheck() then
      protectSlotNo = CppEnums.TInventorySlotNoUndefined
    end
    ToClient_completeStallionTraining(self._servantNo, whereType, itemSlotNo, whereType, protectSlotNo)
  end
  StableStallion:setProtectItem()
  StableStallion:setAwakenitem()
end
function FromClient_IncreaseStallionSkillExpAck(servantNo, skillKey, skillExp)
  StableStallion:TrainSkillUpdate()
  self._buttonClick = 0
end
function StableStallion_RefreshUpdate()
  self = StableStallion
  self:Refresh_UIData()
end
function StableStallion:TrainSkillUpdate()
  for index = 0, self._slotCount - 1 do
    if nil ~= self._selectedItemSlotNo[index] then
      local itemWrapper = getInventoryItemByType(selectedItemWhereType, self._selectedItemSlotNo[index])
      if 0 == self._itemCount[index] then
        self._slots[index]:clearItem()
        self._slots[index].icon:addInputEvent("Mouse_On", "")
        self._slots[index].icon:addInputEvent("Mouse_Out", "")
      end
    end
  end
end
function StableStallion:getfloorValueString(value)
  return string.format(math.floor(value * 10) / 10)
end
function StableStallion:Refresh_UIData()
  local servantInfo = stable_getServantByServantNo(self._servantNo)
  if nil == servantInfo then
    return
  end
  local name = servantInfo:getName()
  local skillCount = servantInfo:getSkillCount()
  local awakenExp = 0
  local awakenMaxExp = stable_getStallionTrainingCompleteRequiredExperience()
  local statckCount = servantInfo:getServantAwakenStack()
  for i = 0, self._slotCount - 1 do
    local satllionSkillWrapper = stable_getStallionTrainingSkillListAt(i)
    local stallionSkillWrapperKey = satllionSkillWrapper:getKey()
    for ii = 1, skillCount - 1 do
      local skillWrapper = servantInfo:getSkill(ii)
      if nil ~= skillWrapper then
        local skillname = skillWrapper:getName()
        local skillKey = skillWrapper:getKey()
        if stallionSkillWrapperKey == skillKey then
          self._skillExpCount[i] = servantInfo:getSkillExp(ii) / (skillWrapper:getMaxExp() / 100)
          self._slots[i]._skillPercent:SetText(self:getfloorValueString(self._skillExpCount[i]) .. "%")
          self._slots[i]._skillExp:SetSmoothMode(true)
          self._slots[i]._skillExp:SetAniSpeed(3)
          self._slots[i]._skillExp:SetProgressRate(self._skillExpCount[i] / 1.8)
          awakenExp = awakenExp + servantInfo:getSkillExp(ii)
        end
      end
    end
  end
  self._awakenExpCount = awakenExp / (awakenMaxExp / 100)
  if 100 < self._awakenExpCount then
    self._awakenExpCount = 100
  end
  self._stackValue:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_STABLESTALLION_STACKCOUNT", "count", tostring(statckCount)))
  self.awaken._awakenExp:SetProgressRate(self._awakenExpCount)
  self.awaken._awakenExpCount:SetText(self:getfloorValueString(self._awakenExpCount * 2) .. "%")
  self:setProtectItem()
  self:setAwakenitem()
end
function StableStallion:UpdateCount(isAwakenBtn)
  local progressSpeed = 2
  if true == isAwakenBtn then
    for i = 0, self._slotCount - 1 do
      if 1 < self._skillExpCount[i] then
        self._skillExpCount[i] = self._skillExpCount[i] - 1 * progressSpeed
        self._slots[i]._skillPercent:SetText(self:getfloorValueString(self._skillExpCount[i]) .. "%")
        self._slots[i]._skillExp:SetProgressRate(self._skillExpCount[i] / 1.8)
      else
        self._skillExpCount[i] = 0
        self._slots[i]._skillPercent:SetText(0 .. "%")
        self._slots[i]._skillExp:SetProgressRate(0)
      end
    end
    if 0 <= self._awakenExpCount - 1 then
      self._awakenExpCount = self._awakenExpCount - 1
      self.awaken._awakenExp:SetProgressRate(self._awakenExpCount)
      self.awaken._awakenExpCount:SetText(self:getfloorValueString(self._awakenExpCount * 2) .. "%")
    end
  else
    if 180 <= self._skillExpCount[self._index] then
      self._skillExpCount[self._index] = 180
      progressSpeed = 3
      if 0 < self._itemCount[self._index] then
        if 2 >= self._itemCount[self._index] then
          progressSpeed = 1
        end
        self._itemCount[self._index] = self._itemCount[self._index] - 1 * progressSpeed
      end
    elseif 0 < self._itemCount[self._index] then
      if 1 == self._itemCount[self._index] then
        progressSpeed = 1
      end
      if self._skillExpCount[self._index] >= 100 then
        self._skillExpCount[self._index] = self._skillExpCount[self._index] + 0.5 * progressSpeed
        self._awakenExpCount = self._awakenExpCount + 0.25 * progressSpeed
      else
        self._skillExpCount[self._index] = self._skillExpCount[self._index] + 1 * progressSpeed
        self._awakenExpCount = self._awakenExpCount + 0.5 * progressSpeed
      end
      if self._awakenExpCount > 100 then
        self._awakenExpCount = 100
      end
      self._itemCount[self._index] = self._itemCount[self._index] - 1 * progressSpeed
      self.awaken._awakenExp:SetProgressRate(self._awakenExpCount)
      self.awaken._awakenExpCount:SetText(self:getfloorValueString(self._awakenExpCount * 2) .. "%")
    end
    self._slots[self._index].count:SetText(tostring(self._itemCount[self._index]))
    self._slots[self._index]._skillPercent:SetText(self:getfloorValueString(self._skillExpCount[self._index]) .. "%")
    self._slots[self._index]._skillExp:SetProgressRate(self._skillExpCount[self._index] / 1.8)
  end
end
function FromClient_CompleteStallionTrainingAck(servantNo, servantCharacterKey)
  local self = StableStallion
  local servantKey = servantCharacterKey
  if 0 == servantKey then
    StableStallion_AwakenEffect(false)
    audioPostEvent_SystemUi(13, 22)
  else
    StableStallion_AwakenEffect(true, servantKey)
    audioPostEvent_SystemUi(13, 21)
  end
  self:Refresh_UIData()
end
function FGlobal_MaxItemCount(itemSlotNo)
  local self = StableStallion
  if -1 ~= self._buttonClick then
    return nil
  end
  local index = self._index
  local satllionSkillWrapper = stable_getStallionTrainingSkillListAt(index)
  local stallionSkillWrapperKey = satllionSkillWrapper:getKey()
  local itemWhereType = self._selectedItemWhereType
  local itemCount = 0
  local itemCount = ToClient_availableStallionTrainingItemMaxCount(self._servantNo, stallionSkillWrapperKey, itemWhereType, itemSlotNo)
  return itemCount
end
local frame = 0
function StableStallion_UpdateTime(updateTime)
  local self = StableStallion
  if -1 == self._buttonClick then
    return
  end
  self._elapsedTime = self._elapsedTime + updateTime
  if 0 == self._buttonClick then
    frame = frame + updateTime
    if self._elapsedTime < 2.5 then
      if 0 == self._effectType then
        StableStallion_Effect(self._slots[self._index].icon, 0, 0, 0)
        local effectIndex = 0
        if 0 == self._index then
          effectIndex = 9
        elseif 1 == self._index then
          effectIndex = 10
        elseif 2 == self._index then
          effectIndex = 11
        end
        if 0 ~= effectIndex then
          StableStallion_Effect(self._slots[self._index]._skillPercent, effectIndex, 0, -18)
        end
        StableStallion_Effect(self._slots[self._index]._skillPercent, 3, 0, -18)
        self._slots[self._index]._selectedSkillBG:SetShow(false)
        audioPostEvent_SystemUi(13, 19)
        self._effectType = 1
      end
      self:UpdateCount(false)
      StableStallion:Refresh_UIData()
    elseif self._elapsedTime < 3 then
      if 1 == self._effectType then
        StableStallion_Effect(self.awaken._awakenExpCount, 4, -3, -30)
        StableStallion_Effect(self.awaken._awakenExpCount, 3, -3, -30)
        self._effectType = 2
      end
    elseif self._elapsedTime > 4.2 and self._elapsedTime < 4.5 then
      if 2 == self._effectType then
        StableStallion_Effect(self.awaken._awakenExpCount, 5, 0, -30)
        StableStallion:Refresh_UIData()
        self._slots[self._index]._selectedSkillBG:SetShow(true)
        for index = 0, self._slotCount - 1 do
          self._slots[index]._itemSlot:ChangeTextureInfoName("")
          self._slots[index]._itemSlot:EraseAllEffect()
          self._slots[index]._selectedSkillBG:SetShow(false)
          self._slots[index]:clearItem()
          self._slots[index].icon:addInputEvent("Mouse_On", "HandleMOnoutTrainingItemToolTip()")
          self._selectedItemSlotNo[index] = nil
        end
        self._effectType = 3
      end
    elseif self._elapsedTime > 5.5 then
      StableStallion_EffectErase()
      self._elapsedTime = 0
      self._buttonClick = -1
      self._effectType = 0
      StableStallion:Refresh_UIData()
    end
  elseif 1 == self._buttonClick then
    if false == Panel_Window_StableStallion_Effect:GetShow() then
      Panel_Window_StableStallion_Effect:SetShow(true)
    end
    self:UpdateCount(true)
    if self._elapsedTime < 2 then
      if 0 == self._effectType then
        audioPostEvent_SystemUi(13, 20)
        for i = 0, self._slotCount - 1 do
          if self._isExpUp[i] then
            StableStallion_Effect(self._slots[i]._skillPercent, i + 9, 0, -18)
          end
        end
        self._slots[self._index]._selectedSkillBG:SetShow(false)
        self._effectType = 1
        self.protect._protectButton:SetIgnore(true)
      end
    elseif self._elapsedTime < 2.5 then
      if 1 == self._effectType then
        StableStallion_Effect(self.awaken._awakenExpCount, 4, -3, -30)
        self._effectType = 2
        StableStallion_doAwakenEffect()
      end
    elseif self._elapsedTime > 3.7 and self._elapsedTime < 6.5 then
      if Panel_Window_StableStallion:GetShow() then
        Panel_Window_StableStallion:SetShow(false)
        for index = 0, self._slotCount - 1 do
          self._slots[index]._itemSlot:ChangeTextureInfoName("")
          self._slots[index]._itemSlot:EraseAllEffect()
          self._slots[index]._selectedSkillBG:SetShow(false)
          self._slots[index]:clearItem()
          self._slots[index].icon:addInputEvent("Mouse_On", "HandleMOnoutTrainingItemToolTip()")
          self._selectedItemSlotNo[index] = nil
        end
        if Panel_Window_Inventory:GetShow() then
          Inventory_ShowToggle()
        end
        ItemNotify_Close()
      end
      if 2 == self._effectType then
        frame = frame + updateTime
        if frame > 0.2 then
          frame = 0
          StableStallion_AwakenEffect(0)
          self._effectType = 3
        end
      end
    elseif self._elapsedTime > 8 and self._elapsedTime < 10.5 then
      if true == self._awakenDoing then
        Awaken_Training_isNineTier()
        self._awakenDoing = false
      end
    elseif self._elapsedTime > 11.5 and self._elapsedTime < 12 then
      if 3 == self._effectType then
        StableStallion:Refresh_UIData()
        StableList_CharacterSceneResetServantNo(self._servantNo)
        self._effectType = 4
      end
    elseif self._elapsedTime > 12 then
      StableStallion_EffectErase()
      StableStallion_EffectClose()
      StableStallion:Refresh_UIData()
      self._buttonClick = -1
      self._effectType = 0
      StableFunction_ButtonOpen()
      self._elapsedTime = 0
      self.protect._protectButton:SetIgnore(false)
      self.protect._protectButton:SetCheck(false)
    end
  end
end
function FGlobal_IsButtonClick()
  local self = StableStallion
  return self._buttonClick
end
function StableStallion_SetPos()
  local self = StableStallion
  local stallionTextSizeY = self._stallionNotify:GetTextSizeY()
  local stallionTextBGSizeY = self._stallionNotifyBG:GetSizeY()
  local protectTextSizeY = self.protect._protectItemDesc:GetTextSizeY()
  local protectTextBGSizeY = self.protect._protectItemDescBG:GetSizeY()
  local stallionSizeY = 0
  local protectSizeY = 0
  if stallionTextBGSizeY < stallionTextSizeY + 10 or protectTextSizeY > protectTextBGSizeY then
    stallionSizeY = stallionTextSizeY - stallionTextBGSizeY
    protectSizeY = protectTextSizeY - protectTextBGSizeY
    if stallionSizeY < 0 then
      stallionSizeY = 0
    end
    if protectSizeY < 0 then
      protectSizeY = 0
    end
    self._stallionNotifyBG:SetSize(self._stallionNotifyBG:GetSizeX(), self._stallionNotifyBG:GetSizeY() + stallionSizeY + 10)
    local function SetPos(control)
      if self.awaken._awakenButton == control then
        control:SetPosY(control:GetPosY() + stallionSizeY + protectSizeY + 10)
      elseif self.protect._protectCount == control or self.protect._protectIcon == control or self.protect._protectButton == control or self.protect._protectIconBG == control then
        control:SetPosY(control:GetPosY() + stallionSizeY + protectSizeY / 2 + 10)
      else
        control:SetPosY(control:GetPosY() + stallionSizeY + 10)
      end
    end
    SetPos(self.protect._protectMainBG)
    self.protect._protectItemDescBG:SetSize(self.protect._protectItemDescBG:GetSizeX(), protectTextSizeY + 8)
    self.protect._protectMainBG:SetSize(self.protect._protectMainBG:GetSizeX(), self.protect._protectItemDescBG:GetSizeY() + 20)
    self.protect._protectItemDescBG:SetPosY(self.protect._protectMainBG:GetPosY() + 10)
    self.protect._protectItemDesc:SetPosY(self.protect._protectItemDescBG:GetPosY() + 4)
    SetPos(self.awaken._awakenButton)
    SetPos(self.protect._protectIconBG)
    SetPos(self.protect._protectIcon)
    SetPos(self.protect._protectCount)
    SetPos(self.protect._protectButton)
    Panel_Window_StableStallion:SetSize(Panel_Window_StableStallion:GetSizeX(), Panel_Window_StableStallion:GetSizeY() + stallionSizeY + protectSizeY + 10)
  end
end
function PaGlobaFunc_StableStallion_Close()
  Panel_Window_StableStallion:SetShow(false)
end
StableStallion:init()
StableStallion:registEventHandler()
StableStallion_Position()
Panel_Window_StableList:RegisterUpdateFunc("StableStallion_UpdateTime")
