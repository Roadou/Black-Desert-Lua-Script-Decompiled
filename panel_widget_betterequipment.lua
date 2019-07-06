local _panel = Panel_Widget_BetterEquipment
local UI_color = Defines.Color
local BetterEquipment = {
  _ui = {
    stc_slotBG = UI.getChildControl(_panel, "Static_SlotBG"),
    stc_desc = UI.getChildControl(_panel, "StaticText_Desc"),
    stc_title = UI.getChildControl(_panel, "Static_Title"),
    stc_bgList = nil,
    stc_baseList = nil,
    txt_nameList = nil,
    stc_iconList = nil
  },
  _slot_effect = {},
  _whereType = CppEnums.ItemWhereType.eInventory,
  _maxEquipCount = 3,
  _equipSlotList = {},
  _equipItemList = {},
  _equipItemName = "",
  _isInitialized = false
}
function BetterEquipment:open()
  _panel:SetShow(true)
end
function BetterEquipment:close()
  self._equipSlotList = {}
  self._equipItemList = {}
  _panel:SetShow(false)
end
function BetterEquipment:initialize()
  local self = BetterEquipment
  local _slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createEnchant = true,
    createClassEquipBG = true,
    createCash = true
  }
  self._ui.stc_bgList = {}
  self._ui.stc_baseList = {}
  self._ui.txt_nameList = {}
  self._ui.stc_iconList = {}
  self._ui.stc_titleDesc = UI.getChildControl(self._ui.stc_title, "StaticText_TitleDesc")
  for index = 1, self._maxEquipCount do
    self._ui.stc_bgList[index] = UI.cloneControl(self._ui.stc_slotBG, _panel, "Static_SlotBG_" .. index)
    self._ui.stc_baseList[index] = UI.getChildControl(self._ui.stc_bgList[index], "Static_Base")
    self._ui.txt_nameList[index] = UI.getChildControl(self._ui.stc_bgList[index], "StaticText_ItemName")
    self._ui.txt_nameList[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.stc_bgList[index]:SetPosY(index * 51)
    self._ui.stc_bgList[index]:SetShow(true)
    local slot = {}
    SlotItem.new(slot, "slotIcon_" .. index, index, self._ui.stc_bgList[index], _slotConfig)
    slot:createChild()
    self._ui.stc_iconList[index] = slot
    Panel_Tooltip_Item_SetPosition(index, slot, "betterItemList")
  end
  local text = keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Dash)
  local tempControl
  local posX = 0
  local addPosX = 5
  tempControl = UI.getChildControl(self._ui.stc_title, "StaticText_Title")
  tempControl:SetSize(tempControl:GetTextSizeX() + 10, tempControl:GetSizeY())
  tempControl:SetPosX(posX)
  posX = tempControl:GetPosX() + tempControl:GetSizeX() + addPosX
  tempControl:SetText(keyCustom_GetString_ActionKey(CppEnums.ActionInputType.ActionInputType_Interaction))
  tempControl:SetShow(true)
  self._ui.stc_titleDesc:SetPosX(posX)
  self._ui.stc_desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.stc_desc:SetText(self._ui.stc_desc:GetText())
  self._isInitialized = true
  self:registerEventHandler()
  self:resetPosition()
end
function FromClient_BetterEquipment_InventoryUpdate()
  local self = BetterEquipment
  self:update_betterEquipment()
end
function BetterEquipment:reArrangement_equipment()
  local tempArray = {}
  local tempArray2 = {}
  for ii = 1, #self._equipSlotList do
    local itemWrapper = getInventoryItemByType(self._whereType, self._equipSlotList[ii])
    if nil ~= itemWrapper and #tempArray < self._maxEquipCount and true == self:checkBetterItem(itemWrapper, self._equipSlotList[ii]) and itemWrapper:get():getKey():getItemKey() == self._equipItemList[ii] then
      table.insert(tempArray, self._equipSlotList[ii])
      table.insert(tempArray2, self._equipItemList[ii])
    end
  end
  self._equipSlotList = tempArray
  self._equipItemList = tempArray2
end
function BetterEquipment:registerEventHandler()
  registerEvent("FromClient_GetEquipableItem", "FromClient_BetterEquipment_GetEquipableItem")
  registerEvent("EventEquipmentUpdate", "FromClient_BetterEquipment_EventEquipmentUpdate")
  registerEvent("FromClient_InventoryUpdate", "FromClient_BetterEquipment_InventoryUpdate")
  registerEvent("FromClient_EquipEnduranceChanged", "FromClient_BetterEquipment_EquipEnduranceChanged")
  registerEvent("EventServantEquipItem", "FromClient_BetterEquipment_EventServantEquipItem")
  registerEvent("EventServantEquipmentUpdate", "FromClient_BetterEquipment_EventServantEquipmentUpdate")
  registerEvent("FromClient_WeightPenaltyChanged", "FromClient_BetterEquipment_WeightPenaltyChanged")
  registerEvent("onScreenResize", "PaGlobalFunc_BetterEquipment_OnScreenResize")
end
function BetterEquipment:checkLifeItemType(itemWrapper)
  if nil == itemWrapper then
    return false
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return false
  end
  local lifeStatMainType = itemSSW:getLifeStatMainType()
  local lifeStat = itemSSW:getLifeStat()
  if nil == lifeStatMainType or nil == lifeStat then
    return false
  end
  if __ePlayerLifeStatType_Count ~= lifeStatMainType or lifeStat > 0 then
    return true
  end
  return false
end
function BetterEquipment:getAccesoryWorseEquipmentKey(itemWrapper, lifeCheck)
  local equipType = itemWrapper:getStaticStatus():getEquipType()
  local firstEquipOffence = 0
  local firstEquipDeffence = 0
  local secondEquipOffence = 0
  local secondEquipDeffence = 0
  local acc, equipItemWrapper, equipItemWrapper2
  if 16 == equipType then
    equipItemWrapper = ToClient_getEquipmentItem(8)
    local isLifeType1 = self:checkLifeItemType(equipItemWrapper)
    if nil ~= equipItemWrapper then
      firstEquipOffence = (equipItemWrapper:getStaticStatus():getMinDamage(0) + equipItemWrapper:getStaticStatus():getMaxDamage(0)) / 2
      firstEquipDeffence = equipItemWrapper:getStaticStatus():getDefence()
    end
    equipItemWrapper2 = ToClient_getEquipmentItem(9)
    local isLifeType2 = self:checkLifeItemType(equipItemWrapper2)
    if nil ~= equipItemWrapper2 then
      secondEquipOffence = (equipItemWrapper2:getStaticStatus():getMinDamage(0) + equipItemWrapper2:getStaticStatus():getMaxDamage(0)) / 2
      secondEquipDeffence = equipItemWrapper2:getStaticStatus():getDefence()
    end
    local firstEquipStat = firstEquipOffence + firstEquipDeffence
    local secondEquipStat = secondEquipOffence + secondEquipDeffence
    local isLifeEquip = false
    if true == lifeCheck and (true == isLifeType1 or true == isLifeType2) then
      if isLifeType1 == true then
        acc = 9
      else
        acc = 8
      end
      isLifeEquip = true
    end
    if false == isLifeEquip then
      if nil ~= equipItemWrapper and nil ~= equipItemWrapper2 then
        if firstEquipStat > secondEquipStat then
          acc = 9
        else
          acc = 8
        end
      elseif nil == equipItemWrapper and nil ~= equipItemWrapper2 then
        acc = 8
      elseif nil ~= equipItemWrapper and nil == equipItemWrapper2 then
        acc = 9
      else
        acc = 8
      end
    end
  elseif 17 == equipType then
    equipItemWrapper = ToClient_getEquipmentItem(10)
    local isLifeType1 = self:checkLifeItemType(equipItemWrapper)
    if nil ~= equipItemWrapper then
      firstEquipOffence = (equipItemWrapper:getStaticStatus():getMinDamage(0) + equipItemWrapper:getStaticStatus():getMaxDamage(0)) / 2
      firstEquipDeffence = equipItemWrapper:getStaticStatus():getDefence()
    end
    equipItemWrapper2 = ToClient_getEquipmentItem(11)
    local isLifeType2 = self:checkLifeItemType(equipItemWrapper2)
    if nil ~= equipItemWrapper2 then
      secondEquipOffence = (equipItemWrapper2:getStaticStatus():getMinDamage(0) + equipItemWrapper2:getStaticStatus():getMaxDamage(0)) / 2
      secondEquipDeffence = equipItemWrapper2:getStaticStatus():getDefence()
    end
    local firstEquipStat = firstEquipOffence + firstEquipDeffence
    local secondEquipStat = secondEquipOffence + secondEquipDeffence
    local isLifeEquip = false
    if true == lifeCheck and (true == isLifeType1 or true == isLifeType2) then
      if isLifeType1 == true then
        acc = 11
      else
        acc = 10
      end
      isLifeEquip = true
    end
    if false == isLifeEquip then
      if nil ~= equipItemWrapper and nil ~= equipItemWrapper2 then
        if firstEquipStat > secondEquipStat then
          acc = 11
        else
          acc = 10
        end
      elseif nil == equipItemWrapper and nil ~= equipItemWrapper2 then
        acc = 10
      elseif nil ~= equipItemWrapper and nil == equipItemWrapper2 then
        acc = 11
      else
        acc = 10
      end
    end
  end
  return acc
end
function BetterEquipment:checkBetterItem(itemWrapper, slotNo)
  local ret = false
  if nil == itemWrapper or nil == slotNo then
    return ret
  end
  if false == itemWrapper:checkConditions() then
    return false
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if nil == itemSSW then
    return ret
  end
  local isServantEquip = itemSSW:isUsableServant()
  local isEquip = itemSSW:isEquipable()
  if not isServantEquip and true == isEquip then
    local classType = getSelfPlayer():getClassType()
    local isUsableClass = true
    if (itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon()) and false == itemSSW:get()._usableClassType:isOn(classType) then
      return ret
    end
    local equipSlotNo = itemSSW:getEquipSlotNo()
    local equipType = itemSSW:getEquipType()
    if 64 == equipType or 69 == equipType then
      return ret
    end
    if equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoRightHand and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoLeftHand and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoAlchemyStone and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoChest and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoGlove and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoBoots and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoHelm and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoNecklace and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoRing1 and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoRing2 and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoEaring1 and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoEaring2 and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoBelt and equipSlotNo ~= CppEnums.EquipSlotNoClient.eEquipSlotNoAwakenWeapon then
      return ret
    end
    if 16 == equipType or 17 == equipType then
      local acc = self:getAccesoryWorseEquipmentKey(itemWrapper, true)
      local equipItemWrapper = ToClient_getEquipmentItem(acc)
      if true == self:checkLifeItemType(equipItemWrapper) then
        return ret
      end
    else
      local equipItemWrapper = ToClient_getEquipmentItem(equipSlotNo)
      if true == self:checkLifeItemType(equipItemWrapper) then
        return ret
      elseif 4 == equipSlotNo or 5 == equipSlotNo or 6 == equipSlotNo then
        local equipItemWrapper = ToClient_getEquipmentItem(3)
        if true == self:checkLifeItemType(equipItemWrapper) then
          return ret
        end
      end
    end
    local myLevel = getSelfPlayer():get():getLevel()
    local minLevel = itemSSW:get()._minLevel
    local maxLevel = itemSSW:get()._maxLevel
    if myLevel < minLevel or myLevel > maxLevel then
      return ret
    end
    local isAwakenWeapon = itemSSW:get():isAwakenWeapon()
    if true == isAwakenWeapon and false == PaGlobal_BetterEquipment_IsAwakenQuestClear() then
      return ret
    end
    local currentEndurance = itemWrapper:get():getEndurance()
    local offencePoint = 0
    local defencePoint = 0
    local equipOffencePoint = 0
    local equipDefencePoint = 0
    local matchEquip = false
    local isAccessory = false
    _PA_LOG("\236\158\132\236\136\152\237\152\132", "=======================================")
    _PA_LOG("\236\158\132\236\136\152\237\152\132", "=======================================")
    offencePoint, defencePoint, equipOffencePoint, equipDefencePoint, matchEquip, isAccessory = _inventory_updateSlot_compareSpec(self._whereType, slotNo, isAccessory)
    if nil ~= defencePoint and nil ~= offencePoint and currentEndurance > 0 and true == matchEquip then
      _PA_LOG("\236\158\132\236\136\152\237\152\132", "offencePoint : " .. offencePoint)
      _PA_LOG("\236\158\132\236\136\152\237\152\132", "defencePoint : " .. defencePoint)
      _PA_LOG("\236\158\132\236\136\152\237\152\132", "equipOffencePoint : " .. equipOffencePoint)
      _PA_LOG("\236\158\132\236\136\152\237\152\132", "equipDefencePoint : " .. equipDefencePoint)
      if defencePoint + offencePoint > equipDefencePoint + equipOffencePoint then
        ret = true
      end
    end
    if false == ret then
      if 16 == equipType or 17 == equipType then
        local acc = self:getAccesoryWorseEquipmentKey(itemWrapper, true)
        local equipItemWrapper = ToClient_getEquipmentItem(acc)
        if nil == equipItemWrapper then
          ret = true
        end
      else
        local equipItemWrapper = ToClient_getEquipmentItem(itemSSW:getEquipSlotNo())
        if nil == equipItemWrapper then
          ret = true
        end
      end
    end
  end
  return ret
end
function Input_BetterEquipment_ShowToolTip(index, isOn)
  Panel_Tooltip_Item_Show_GeneralNormal(index, "betterItemList", isOn, false)
end
function Input_BetterEquipment_EquipClick(slotNo, index)
  local self = BetterEquipment
  if false == IsSelfPlayerWaitAction() and false == IsSelfPlayerBattleWaitAction() then
    return
  end
  local itemWrapper = getInventoryItemByType(self._whereType, slotNo)
  if nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    if nil ~= itemSSW then
      self._equipItemName = itemSSW:getName()
    end
    local equipType = itemWrapper:getStaticStatus():getEquipType()
    if 16 == equipType or 17 == equipType then
      local accSlotNo = self:getAccesoryWorseEquipmentKey(itemWrapper, true)
      inventoryUseItem(self._whereType, slotNo, accSlotNo, false)
    else
      inventoryUseItem(self._whereType, slotNo, nil, true)
    end
  end
  for ii = 1, #self._ui.stc_iconList do
    Panel_Tooltip_Item_Show_GeneralNormal(ii, "betterItemList", false, false)
  end
  self:update_betterEquipment()
end
function Input_BetterEquipment_EquipKeyUp()
  local self = BetterEquipment
  if Panel_Interaction:IsShow() or Panel_Interaction_House:IsShow() then
    return
  end
  if nil ~= self._equipSlotList[#self._equipSlotList] then
    Input_BetterEquipment_EquipClick(self._equipSlotList[#self._equipSlotList], #self._equipSlotList)
  end
end
function BetterEquipment:convert_itemGradeColor(grade)
  if 0 == grade then
    return UI_color.C_FFFFFFFF
  elseif 1 == grade then
    return UI_color.C_FF5DFF70
  elseif 2 == grade then
    return UI_color.C_FF4B97FF
  elseif 3 == grade then
    return UI_color.C_FFFFC832
  elseif 4 == grade then
    return UI_color.C_FFFF6C00
  else
    return UI_color.C_FFFFFFFF
  end
end
function BetterEquipment:resetPosition()
  local radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  _panel:SetPosX(getScreenSizeX() - radarSizeX - _panel:GetSizeX() - 15)
  local tempPanel
  if true == PaGlobalFunc_AccesoryQuest_ReturnPanelShow() then
    tempPanel = Panel_Widget_AccesoryQuest
    if nil ~= tempPanel then
      _panel:SetPosY(tempPanel:GetPosY() + tempPanel:GetSizeY() + 20)
    end
  elseif true == PcEnduranceToggle() then
    tempPanel = PaGlobalPlayerWeightList.weight
    if nil ~= tempPanel then
      _panel:SetPosY(tempPanel:GetPosY() + tempPanel:GetSizeY() + 80)
    end
  else
    if true == PaGlobalHorseEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalHorseEnduranceList.panel
    elseif true == PaGlobalCarriageEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalCarriageEnduranceList.panel
    elseif true == PaGlobalShipEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalShipEnduranceList.panel
    elseif true == PaGlobalPlayerEnduranceList.enduranceInfo[0].control:GetShow() then
      tempPanel = PaGlobalPlayerEnduranceList.panel
    end
    if nil ~= tempPanel then
      _panel:SetPosY(tempPanel:GetPosY() + tempPanel:GetSizeY() + 30)
    else
      _panel:SetPosY(50)
    end
  end
end
function PaGlobalFunc_BetterEquipment_OnScreenResize()
  local self = BetterEquipment
  if true == self._isInitialized then
    self:resetPosition()
  end
end
function FromClient_BetterEquipment_EquipEnduranceChanged()
  local self = BetterEquipment
  self:resetPosition()
end
function FromClient_BetterEquipment_EventServantEquipItem()
  local self = BetterEquipment
  self:resetPosition()
end
function FromClient_BetterEquipment_EventServantEquipmentUpdate()
  local self = BetterEquipment
  self:resetPosition()
end
function FromClient_BetterEquipment_WeightPenaltyChanged()
  local self = BetterEquipment
  self:resetPosition()
end
function FromClient_BetterEquipment_EventEquipmentUpdate()
  local self = BetterEquipment
  if "" ~= self._equipItemName then
    Proc_ShowMessage_Ack(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BETTEREQUIP_MESSAGE", "item", self._equipItemName))
    self._equipItemName = ""
  end
  self:update_betterEquipment()
end
function BetterEquipment:update_betterEquipment()
  self:reArrangement_equipment()
  self:resetPosition()
  if 0 < #self._equipSlotList then
    self:open()
    local descIndex = math.min(#self._equipSlotList, self._maxEquipCount)
    self._ui.stc_desc:SetPosY(self._ui.stc_bgList[descIndex]:GetPosY() + self._ui.stc_bgList[descIndex]:GetSizeY() + 2)
    for ii = 1, self._maxEquipCount do
      if ii <= #self._equipSlotList then
        local tempIndex = ii
        local itemWrapper = getInventoryItemByType(self._whereType, self._equipSlotList[tempIndex])
        local itemSSW = itemWrapper:getStaticStatus()
        self._ui.stc_iconList[ii]._name = itemSSW:getName()
        self._ui.stc_iconList[ii]._item = itemSSW:get()._key:get()
        self._ui.stc_iconList[ii]:setItemByStaticStatus(itemSSW, itemWrapper:getCount())
        local itemGrade = itemSSW:getGradeType()
        local itemGradeColor = self:convert_itemGradeColor(itemGrade)
        self._ui.txt_nameList[ii]:SetText(tostring(itemSSW:getName()))
        self._ui.txt_nameList[ii]:SetFontColor(itemGradeColor)
        self._ui.stc_iconList[ii].icon:SetPosX(self._ui.stc_baseList[ii]:GetPosX())
        self._ui.stc_iconList[ii].icon:SetPosY(self._ui.stc_baseList[ii]:GetPosY())
        self._ui.stc_iconList[ii].icon:SetSize(self._ui.stc_baseList[ii]:GetSizeX(), self._ui.stc_baseList[ii]:GetSizeY())
        self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_On", "Input_BetterEquipment_ShowToolTip(" .. tempIndex .. ", true)")
        self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_Out", "Input_BetterEquipment_ShowToolTip(" .. tempIndex .. ", false)")
        self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_LUp", "Input_BetterEquipment_EquipClick(" .. self._equipSlotList[tempIndex] .. "," .. tempIndex .. ")")
        self._ui.stc_iconList[ii].icon:addInputEvent("Mouse_RUp", "Input_BetterEquipment_EquipClick(" .. self._equipSlotList[tempIndex] .. "," .. tempIndex .. ")")
        self._ui.stc_bgList[ii]:addInputEvent("Mouse_LUp", "Input_BetterEquipment_EquipClick(" .. self._equipSlotList[tempIndex] .. "," .. tempIndex .. ")")
        self._ui.stc_bgList[ii]:addInputEvent("Mouse_RUp", "Input_BetterEquipment_EquipClick(" .. self._equipSlotList[tempIndex] .. "," .. tempIndex .. ")")
        self._ui.stc_bgList[ii]:SetShow(true)
        self._ui.stc_iconList[ii].icon:EraseAllEffect()
        self._ui.stc_iconList[ii].icon:AddEffect("fUI_BetterItemAura01", true, 0, 0)
      else
        self._ui.txt_nameList[ii]:SetText(" ")
        self._ui.stc_iconList[ii]:clearItem()
        self._ui.stc_iconList[ii].icon:EraseAllEffect()
        self._ui.stc_bgList[ii]:SetShow(false)
      end
    end
  else
    self:close()
  end
  if nil ~= PaGlobal_BossCamera_Repos then
    PaGlobal_BossCamera_Repos()
  end
end
function PaGlobal_BetterEquipment_GetNextPosY()
  local self = BetterEquipment
  local nextPosY = _panel:GetPosY() + self._ui.stc_desc:GetPosY() + self._ui.stc_desc:GetTextSizeY()
  return nextPosY
end
function PaGlobal_BetterEquipment_GetItemWrapper(slotNo)
  local self = BetterEquipment
  local itemWrapper = getInventoryItemByType(self._whereType, self._equipSlotList[slotNo])
  if nil ~= itemWrapper then
    return itemWrapper
  end
end
function FromClient_BetterEquipment_GetEquipableItem(itemEnchantKey, slotNo)
  local self = BetterEquipment
  local itemWrapper = getInventoryItemByType(self._whereType, slotNo)
  if nil ~= itemWrapper and itemWrapper:get():getKey():get() == itemEnchantKey and true == self:checkBetterItem(itemWrapper, slotNo) then
    table.insert(self._equipSlotList, 1, slotNo)
    table.insert(self._equipItemList, 1, itemWrapper:get():getKey():getItemKey())
  end
  self:update_betterEquipment()
end
function PaGlobalFunc_BetterEquipment_Close()
  local self = BetterEquipment
  self:close()
end
function PaGlobalFunc_GetAccesoryWorseEquipment_Key(itemWrapper)
  if nil == itemWrapper then
    return
  end
  local self = BetterEquipment
  return self:getAccesoryWorseEquipmentKey(itemWrapper, true)
end
function PaGlobal_BetterEquipment_IsAwakenQuestClear()
  local classType = getSelfPlayer():getClassType()
  if CppEnums.ClassType.ClassType_Orange == classType then
    return true
  end
  local questGroupNo, questNo = PaGlobal_BetterEquipment_GetClassAwakenQuestNo()
  if true == questList_isClearQuest(questGroupNo, questNo) then
    return true
  end
  return false
end
function PaGlobal_BetterEquipment_GetClassAwakenQuestNo()
  local classType = getSelfPlayer():getClassType()
  local questNo = {_group = 0, _quest = 0}
  if CppEnums.ClassType.ClassType_Warrior == classType then
    questNo._group = 285
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_Ranger == classType then
    questNo._group = 293
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_Sorcerer == classType then
    questNo._group = 287
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_Lahn == classType then
    questNo._group = 345
    questNo._quest = 5
  elseif CppEnums.ClassType.ClassType_Giant == classType then
    questNo._group = 290
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_Tamer == classType then
    questNo._group = 296
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_Combattant == classType then
    questNo._group = 342
    questNo._quest = 7
  elseif CppEnums.ClassType.ClassType_BladeMaster == classType then
    questNo._group = 319
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_BladeMasterWomen == classType then
    questNo._group = 321
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_CombattantWomen == classType then
    questNo._group = 343
    questNo._quest = 5
  elseif CppEnums.ClassType.ClassType_Valkyrie == classType then
    questNo._group = 298
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_NinjaWomen == classType then
    questNo._group = 327
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_NinjaMan == classType then
    questNo._group = 325
    questNo._quest = 4
  elseif CppEnums.ClassType.ClassType_DarkElf == classType then
    questNo._group = 338
    questNo._quest = 5
  elseif CppEnums.ClassType.ClassType_Wizard == classType then
    questNo._group = 336
    questNo._quest = 5
  elseif CppEnums.ClassType.ClassType_WizardWomen == classType then
    questNo._group = 334
    questNo._quest = 5
  end
  return questNo._group, questNo._quest
end
function PaGlobalFunc_BetterEquipment_LuaLoadComplete()
  local self = BetterEquipment
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_BetterEquipment_LuaLoadComplete")
