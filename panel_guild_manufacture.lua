PaGlobal_Guild_Manufacture = {
  _ui = {
    _guildBG = nil,
    _baseNoneStateBG = nil,
    _baseProceedingStateBG = nil,
    _baseReadyStateBG = nil,
    _baseCompleteStateBG = nil,
    _baseProductSlot = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true
  },
  _slot = Array.new()
}
function PaGlobal_Guild_Manufacture:initialize()
  self:createControl()
end
function PaGlobal_Guild_Manufacture:registMessageHandler()
  registerEvent("FromClient_Guild_Manufacture_Refresh", "FromClient_Guild_Manufacture_Refresh")
  registerEvent("FromClient_Guild_Manufacture_CompletePrice", "FromClient_Guild_Manufacture_CompletePrice")
end
function PaGlobal_Guild_Manufacture:createControl()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._guildBG = UI.getChildControl(Panel_Window_Guild, "Static_Frame_GuildManufactureBG")
  self._ui._baseNoneStateBG = UI.getChildControl(Panel_Guild_Manufacture, "Static_NoneState")
  self._ui._baseProceedingStateBG = UI.getChildControl(Panel_Guild_Manufacture, "Static_ProceedingState")
  self._ui._baseReadyStateBG = UI.getChildControl(Panel_Guild_Manufacture, "Static_ReadyState")
  self._ui._baseCompleteStateBG = UI.getChildControl(Panel_Guild_Manufacture, "Static_CompleteState")
  self._ui._baseProductSlot = UI.getChildControl(Panel_Guild_Manufacture, "Static_Result_IconBG")
  self._messageNowCompleteAck = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_NOW_TITLE"),
    content = "",
    functionYes = FGlobal_Guild_Manufacture_Now_Complete_Yes,
    functionNo = FGlobal_Guild_Manufacture_Now_Complete_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
    itemEnchantKey = nil,
    index = nil,
    price_s64 = nil
  }
  self._messageDelete = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_DELETE_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_DELETE_CONTENT"),
    functionYes = FGlobal_Guild_Manufacture_Delete_Yes,
    functionNo = FGlobal_Guild_Manufacture_Delete_No,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
    index = nil
  }
  for ii = 0, __eGuildManufactureProductItemCount - 1 do
    do
      local slot = {
        ["_productItemEnchantKey"] = nil,
        ["_productItemCount_s64"] = nil,
        [__eGuildManufactureStateNone] = {
          _backGround = nil,
          _productSlot = nil,
          _productItemName = nil,
          _productItemCount = nil,
          _selectButton = nil,
          _setButton = nil
        },
        [__eGuildManufactureStateProceeding] = {
          _backGround = nil,
          _productSlot = nil,
          _productItemName = nil,
          _productItemCount = nil,
          _startButton = nil,
          _deleteButton = nil,
          _requiredSlot = Array.new(),
          _requiredItem = Array.new()
        },
        [__eGuildManufactureStateCreating] = {
          _backGround = nil,
          _productSlot = nil,
          _productItemName = nil,
          _productItemCount = nil,
          _completeDate = nil,
          _completeButton = nil
        },
        [__eGuildManufactureStateComplete] = {
          _backGround = nil,
          _productSlot = nil,
          _productItemName = nil,
          _productItemCount = nil,
          _receiveButton = nil
        }
      }
      slot[__eGuildManufactureStateNone]._backGround = UI.cloneControl(self._ui._baseNoneStateBG, Panel_Guild_Manufacture, "NoneBG_" .. ii)
      slot[__eGuildManufactureStateProceeding]._backGround = UI.cloneControl(self._ui._baseProceedingStateBG, Panel_Guild_Manufacture, "ProceedingBG_" .. ii)
      slot[__eGuildManufactureStateCreating]._backGround = UI.cloneControl(self._ui._baseReadyStateBG, Panel_Guild_Manufacture, "ReadyBG_" .. ii)
      slot[__eGuildManufactureStateComplete]._backGround = UI.cloneControl(self._ui._baseCompleteStateBG, Panel_Guild_Manufacture, "CompleteBG_" .. ii)
      function slot:SetShow(isShow)
        slot[__eGuildManufactureStateNone]._backGround:SetShow(isShow)
        slot[__eGuildManufactureStateProceeding]._backGround:SetShow(isShow)
        slot[__eGuildManufactureStateCreating]._backGround:SetShow(isShow)
        slot[__eGuildManufactureStateComplete]._backGround:SetShow(isShow)
      end
      function slot:SetPosY(posY)
        slot[__eGuildManufactureStateNone]._backGround:SetHorizonCenter()
        slot[__eGuildManufactureStateNone]._backGround:SetPosY(posY)
        slot[__eGuildManufactureStateProceeding]._backGround:SetHorizonCenter()
        slot[__eGuildManufactureStateProceeding]._backGround:SetPosY(posY)
        slot[__eGuildManufactureStateCreating]._backGround:SetHorizonCenter()
        slot[__eGuildManufactureStateCreating]._backGround:SetPosY(posY)
        slot[__eGuildManufactureStateComplete]._backGround:SetHorizonCenter()
        slot[__eGuildManufactureStateComplete]._backGround:SetPosY(posY)
      end
      local noneSlot = slot[__eGuildManufactureStateNone]
      local tempProductSlot_0 = {}
      tempProductSlot_0.bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, noneSlot._backGround, "ProductItemBG_0_" .. ii)
      CopyBaseProperty(self._ui._baseProductSlot, tempProductSlot_0.bg)
      tempProductSlot_0.bg:SetPosX(noneSlot._backGround:GetSizeX() / 2 - tempProductSlot_0.bg:GetSizeX() / 2)
      tempProductSlot_0.bg:SetShow(false)
      SlotItem.new(tempProductSlot_0, "ProductItemIcon_" .. ii, ii, tempProductSlot_0.bg, self._slotConfig)
      tempProductSlot_0:createChild()
      tempProductSlot_0.icon:SetPosX(13)
      tempProductSlot_0.icon:SetPosY(13)
      tempProductSlot_0.icon:SetShow(true)
      tempProductSlot_0.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_Manufacture:productItemTooltip_Show(" .. ii .. ", __eGuildManufactureStateNone)")
      tempProductSlot_0.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_Manufacture:itemTooltip_Hide()")
      tempProductSlot_0.icon:addInputEvent("Mouse_RUp", "PaGlobal_Guild_Manufacture:itemUnSet(" .. ii .. ")")
      noneSlot._productSlot = tempProductSlot_0
      noneSlot._stateDesc = UI.getChildControl(noneSlot._backGround, "StaticText_Desc")
      noneSlot._productItemName = UI.getChildControl(noneSlot._backGround, "Static_Result_Name")
      noneSlot._selectButton = UI.getChildControl(noneSlot._backGround, "Button_Select")
      noneSlot._setButton = UI.getChildControl(noneSlot._backGround, "Button_Set")
      noneSlot._setButton:SetShow(false)
      noneSlot._selectButton:SetSpanSize(-95, 30)
      noneSlot._setButton:SetSpanSize(95, 30)
      noneSlot._selectButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:select(" .. ii .. ")")
      noneSlot._setButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:set(" .. ii .. ")")
      noneSlot._productItemName:SetShow(false)
      local proceedingSlot = slot[__eGuildManufactureStateProceeding]
      local tempProductSlot_1 = {}
      tempProductSlot_1.bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, proceedingSlot._backGround, "ProductItemBG_1_" .. ii)
      CopyBaseProperty(self._ui._baseProductSlot, tempProductSlot_1.bg)
      tempProductSlot_1.bg:SetShow(true)
      SlotItem.new(tempProductSlot_1, "ProductItemIcon_" .. ii, ii, tempProductSlot_1.bg, self._slotConfig)
      tempProductSlot_1:createChild()
      tempProductSlot_1.icon:SetPosX(13)
      tempProductSlot_1.icon:SetPosY(13)
      tempProductSlot_1.icon:SetShow(true)
      tempProductSlot_1.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_Manufacture:productItemTooltip_Show(" .. ii .. ", __eGuildManufactureStateProceeding)")
      tempProductSlot_1.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_Manufacture:itemTooltip_Hide()")
      proceedingSlot._productSlot = tempProductSlot_1
      proceedingSlot._productItemName = UI.getChildControl(proceedingSlot._backGround, "Static_Result_Name")
      proceedingSlot._productItemCount = UI.getChildControl(proceedingSlot._backGround, "StaticText_Count")
      proceedingSlot._startButton = UI.getChildControl(proceedingSlot._backGround, "Button_Start")
      proceedingSlot._deleteButton = UI.getChildControl(proceedingSlot._backGround, "Button_Delete")
      proceedingSlot._startButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:start(" .. ii .. ")")
      proceedingSlot._deleteButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:delete(" .. ii .. ")")
      for jj = 0, __eGuildManufactureRequiredItemCount - 1 do
        local tempSlot = {}
        tempSlot.bg = UI.getChildControl(proceedingSlot._backGround, "Static_StuffItemBG" .. tostring(jj + 1))
        tempSlot.bg:SetShow(true)
        SlotItem.new(tempSlot, "RequiredItemIcon_" .. ii .. "_" .. jj, jj, tempSlot.bg, self._slotConfig)
        tempSlot:createChild()
        tempSlot.icon:SetPosX(4)
        tempSlot.icon:SetPosY(4)
        tempSlot.icon:SetShow(true)
        tempSlot.icon:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:updateItem(" .. ii .. "," .. jj .. ")")
        tempSlot.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_Manufacture:requiredItemTooltip_Show(" .. ii .. ", " .. jj .. ")")
        tempSlot.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_Manufacture:itemTooltip_Hide()")
        proceedingSlot._requiredSlot[jj] = tempSlot
        local tempItemInfo = {
          enchantKey = nil,
          countText = nil,
          countValue_s64 = nil
        }
        tempItemInfo.countText = UI.getChildControl(proceedingSlot._backGround, "StaticText_ItemCount" .. tostring(jj + 1))
        tempItemInfo.countText:SetShow(true)
        proceedingSlot._requiredItem[jj] = tempItemInfo
      end
      local readySlot = slot[__eGuildManufactureStateCreating]
      local tempProductSlot_2 = {}
      tempProductSlot_2.bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, readySlot._backGround, "ProductItemBG_2_" .. ii)
      CopyBaseProperty(self._ui._baseProductSlot, tempProductSlot_2.bg)
      tempProductSlot_2.bg:SetPosX(noneSlot._backGround:GetSizeX() / 2 - tempProductSlot_2.bg:GetSizeX() / 2)
      tempProductSlot_2.bg:SetShow(true)
      SlotItem.new(tempProductSlot_2, "ProductItemIcon_" .. ii, ii, tempProductSlot_2.bg, self._slotConfig)
      tempProductSlot_2:createChild()
      tempProductSlot_2.icon:SetPosX(13)
      tempProductSlot_2.icon:SetPosY(13)
      tempProductSlot_2.icon:SetShow(true)
      tempProductSlot_2.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_Manufacture:productItemTooltip_Show(" .. ii .. ", __eGuildManufactureStateCreating)")
      tempProductSlot_2.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_Manufacture:itemTooltip_Hide()")
      readySlot._productSlot = tempProductSlot_2
      readySlot._productItemName = UI.getChildControl(readySlot._backGround, "Static_Result_Name")
      readySlot._productItemCount = UI.getChildControl(readySlot._backGround, "StaticText_Count")
      readySlot._completeDate = UI.getChildControl(readySlot._backGround, "StaticText_CompleteTime")
      readySlot._completeButton = UI.getChildControl(readySlot._backGround, "Button_Complete")
      readySlot._completeButton:SetShow(false)
      readySlot._completeButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:complete(" .. ii .. ")")
      local completeSlot = slot[__eGuildManufactureStateComplete]
      local tempProductSlot_3 = {}
      tempProductSlot_3.bg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, completeSlot._backGround, "ProductItemBG_3_" .. ii)
      CopyBaseProperty(self._ui._baseProductSlot, tempProductSlot_3.bg)
      tempProductSlot_3.bg:SetPosX(noneSlot._backGround:GetSizeX() / 2 - tempProductSlot_3.bg:GetSizeX() / 2)
      tempProductSlot_3.bg:SetShow(true)
      SlotItem.new(tempProductSlot_3, "ProductItemIcon_" .. ii, ii, tempProductSlot_3.bg, self._slotConfig)
      tempProductSlot_3:createChild()
      tempProductSlot_3.icon:SetPosX(13)
      tempProductSlot_3.icon:SetPosY(13)
      tempProductSlot_3.icon:SetShow(true)
      tempProductSlot_3.icon:addInputEvent("Mouse_On", "PaGlobal_Guild_Manufacture:productItemTooltip_Show(" .. ii .. ", __eGuildManufactureStateComplete)")
      tempProductSlot_3.icon:addInputEvent("Mouse_Out", "PaGlobal_Guild_Manufacture:itemTooltip_Hide()")
      completeSlot._productSlot = tempProductSlot_3
      completeSlot._productItemName = UI.getChildControl(completeSlot._backGround, "Static_Result_Name")
      completeSlot._productItemCount = UI.getChildControl(completeSlot._backGround, "StaticText_Count")
      completeSlot._receiveButton = UI.getChildControl(completeSlot._backGround, "Button_Receive")
      completeSlot._receiveButton:addInputEvent("Mouse_LUp", "PaGlobal_Guild_Manufacture:receive(" .. ii .. ")")
      slot:SetPosY(ii * 195 + 45)
      slot:SetShow(false)
      self._slot[ii] = slot
    end
  end
  Panel_Guild_Manufacture:SetShow(true)
  deleteControl(self._ui._baseNoneStateBG)
  self._ui._baseNoneStateBG = nil
  deleteControl(self._ui._baseProceedingStateBG)
  self._ui._baseProceedingStateBG = nil
  deleteControl(self._ui._baseReadyStateBG)
  self._ui._baseReadyStateBG = nil
  deleteControl(self._ui._baseCompleteStateBG)
  self._ui._baseCompleteStateBG = nil
  deleteControl(self._ui._baseProductSlot)
  self._ui._baseProductSlot = nil
  self._ui._guildBG:MoveChilds(self._ui._guildBG:GetID(), Panel_Guild_Manufacture)
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
  if true == selfProxy:get():isGuildMember() then
    for ii = 0, __eGuildManufactureProductItemCount - 1 do
      PaGlobal_Guild_Manufacture:refreshState(ii)
    end
  end
end
function PaGlobal_Guild_Manufacture:itemUnSet(index)
  if nil == Panel_Window_Guild then
    return
  end
  local slot = self._slot[index][__eGuildManufactureStateNone]
  slot._productSlot.bg:SetShow(false)
  slot._productItemName:SetShow(false)
  slot._setButton:SetShow(false)
  slot._stateDesc:SetShow(true)
  slot._selectButton:SetSpanSize(0, 30)
  slot._setButton:SetSpanSize(95, 30)
  slot._productSlot:clearItem()
  self:itemTooltip_Hide()
end
function PaGlobal_Guild_Manufacture:__updateNoneState(index, infoWrapper)
  if nil == Panel_Window_Guild then
    return
  end
  self._slot[index]._productItemEnchantKey = nil
  self._slot[index]._productItemCount_s64 = nil
  local slot = self._slot[index][__eGuildManufactureStateNone]
  slot._backGround:SetShow(true)
  slot._productSlot.bg:SetShow(false)
  slot._productItemName:SetShow(false)
  slot._setButton:SetShow(false)
  slot._stateDesc:SetShow(true)
  slot._selectButton:SetSpanSize(0, 30)
  slot._setButton:SetSpanSize(95, 30)
  slot._productSlot:clearItem()
end
function PaGlobal_Guild_Manufacture:__updateProceedingState(index, infoWrapper, isReady)
  if nil == Panel_Window_Guild then
    return
  end
  local itemEnchantKey = infoWrapper:getProductItemEnchantKey()
  local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
  if nil == itemStatic then
    return
  end
  local guildManufactureStaticWrapper = ToClient_GetGuildManufactureStaticStatusWrapper(itemEnchantKey)
  if nil == guildManufactureStaticWrapper then
    return
  end
  self._slot[index]._productItemEnchantKey = itemEnchantKey
  self._slot[index]._productItemCount_s64 = infoWrapper:getProductItemCount()
  local slot = self._slot[index][__eGuildManufactureStateProceeding]
  slot._productSlot:setItemByStaticStatus(itemStatic)
  slot._productItemName:SetText(itemStatic:getName())
  slot._productItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_COUNT") .. tostring(infoWrapper:getProductItemCount()))
  for ii = 0, __eGuildManufactureRequiredItemCount - 1 do
    local requiredItemEnchantKey = infoWrapper:getRequiredItemEnchantKey(ii)
    local requiredItemStatic = getItemEnchantStaticStatus(requiredItemEnchantKey)
    local itemCount_s64 = infoWrapper:getRequiredItemCount(ii)
    local itemMaxCount_s64 = guildManufactureStaticWrapper:getRequiredItemCount(ii) * self._slot[index]._productItemCount_s64
    if nil ~= requiredItemStatic then
      slot._requiredSlot[ii]:setItemByStaticStatus(requiredItemStatic)
      slot._requiredItem[ii].countText:SetText(tostring(itemMaxCount_s64 - itemCount_s64) .. "/" .. tostring(itemMaxCount_s64))
    else
      slot._requiredSlot[ii]:clearItem()
      slot._requiredItem[ii].countText:SetText("")
    end
    slot._requiredItem[ii].enchantKey = requiredItemEnchantKey
    slot._requiredItem[ii].countValue_s64 = itemCount_s64
    if 0 >= Int64toInt32(itemCount_s64) then
      slot._requiredSlot[ii].bg:SetEnable(false)
      slot._requiredSlot[ii].icon:SetMonoTone(true)
    else
      slot._requiredSlot[ii].bg:SetEnable(true)
      slot._requiredSlot[ii].icon:SetMonoTone(false)
    end
  end
  if true == isReady then
    slot._startButton:SetEnable(true)
    slot._startButton:SetMonoTone(false)
  else
    slot._startButton:SetEnable(false)
    slot._startButton:SetMonoTone(true)
  end
  slot._backGround:SetShow(true)
end
function PaGlobal_Guild_Manufacture:__updateCreatingState(index, infoWrapper)
  if nil == Panel_Window_Guild then
    return
  end
  local itemEnchantKey = infoWrapper:getProductItemEnchantKey()
  local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
  if nil == itemStatic then
    return
  end
  self._slot[index]._productItemEnchantKey = itemEnchantKey
  self._slot[index]._productItemCount_s64 = infoWrapper:getProductItemCount()
  local slot = self._slot[index][__eGuildManufactureStateCreating]
  slot._productSlot:setItemByStaticStatus(itemStatic)
  slot._productItemName:SetText(itemStatic:getName())
  slot._productItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_COUNT") .. tostring(infoWrapper:getProductItemCount()))
  local time_s64 = PATime(infoWrapper:getCompleteDate())
  local completeDate = string.format(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_TIME_FORMAT_STR"), time_s64:GetYear(), time_s64:GetMonth(), time_s64:GetDay(), time_s64:GetHour(), time_s64:GetMinute())
  slot._completeDate:SetText(completeDate)
  slot._backGround:SetShow(true)
end
function PaGlobal_Guild_Manufacture:__updateCompleteState(index, infoWrapper)
  if nil == Panel_Window_Guild then
    return
  end
  local itemEnchantKey = infoWrapper:getProductItemEnchantKey()
  local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
  if nil == itemStatic then
    return
  end
  self._slot[index]._productItemEnchantKey = itemEnchantKey
  self._slot[index]._productItemCount_s64 = infoWrapper:getProductItemCount()
  local slot = self._slot[index][__eGuildManufactureStateComplete]
  slot._productSlot:setItemByStaticStatus(itemStatic)
  slot._productItemName:SetText(itemStatic:getName())
  slot._productItemCount:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_COUNT") .. tostring(infoWrapper:getProductItemCount()))
  slot._backGround:SetShow(true)
end
function PaGlobal_Guild_Manufacture:refresh()
  if nil == Panel_Window_Guild then
    return
  end
  for ii = 0, __eGuildManufactureProductItemCount - 1 do
    self._slot[ii]:SetShow(false)
  end
  local listWrapper = ToClient_GetGuildManufactureListWrapper()
  if nil ~= listWrapper then
    for ii = 0, __eGuildManufactureProductItemCount - 1 do
      local infoWrapper = listWrapper:getInfo(ii)
      if nil ~= infoWrapper then
        local state = infoWrapper:getState()
        if __eGuildManufactureStateNone == state then
          self:__updateNoneState(ii, infoWrapper)
        elseif __eGuildManufactureStateProceeding == state then
          self:__updateProceedingState(ii, infoWrapper, false)
        elseif __eGuildManufactureStateReady == state then
          self:__updateProceedingState(ii, infoWrapper, true)
        elseif __eGuildManufactureStateCreating == state then
          self:__updateCreatingState(ii, infoWrapper)
        elseif __eGuildManufactureStateComplete == state then
          self:__updateCompleteState(ii, infoWrapper)
        else
          _PA_ASSERT(false, "PaGlobal_Guild_Manufacture:refresh() \236\151\134\235\138\148 state \234\176\146 \236\158\133\235\139\136\235\139\164. %s", state)
        end
      else
        self._slot[ii][__eGuildManufactureStateNone]._backGround:SetShow(true)
      end
    end
  else
    for ii = 0, __eGuildManufactureProductItemCount - 1 do
      self._slot[ii][__eGuildManufactureStateNone]._backGround:SetShow(true)
    end
  end
end
function PaGlobal_Guild_Manufacture:refreshState(index)
  if nil == Panel_Window_Guild then
    return
  end
  self._slot[index]:SetShow(false)
  local infoWrapper = ToClient_GetGuildManufactureInfoWrapper(index)
  if nil ~= infoWrapper then
    local state = infoWrapper:getState()
    if __eGuildManufactureStateNone == state then
      self:__updateNoneState(index, infoWrapper)
    elseif __eGuildManufactureStateProceeding == state then
      self:__updateProceedingState(index, infoWrapper, false)
    elseif __eGuildManufactureStateReady == state then
      self:__updateProceedingState(index, infoWrapper, true)
    elseif __eGuildManufactureStateCreating == state then
      self:__updateCreatingState(index, infoWrapper)
    elseif __eGuildManufactureStateComplete == state then
      self:__updateCompleteState(index, infoWrapper)
    else
      _PA_ASSERT(false, "PaGlobal_Guild_Manufacture:refresh() \236\151\134\235\138\148 state \234\176\146 \236\158\133\235\139\136\235\139\164. %s", state)
    end
  else
    self._slot[index][__eGuildManufactureStateNone]._backGround:SetShow(true)
  end
end
function PaGlobal_Guild_Manufacture:SetShow(isShow)
  if nil == Panel_Window_Guild then
    return
  end
  if true == isShow then
    self:refresh()
  else
    PaGlobal_Guild_ManufactureSelect:close()
  end
  self._ui._guildBG:SetShow(isShow)
end
function PaGlobal_Guild_Manufacture:start(index)
  if nil == Panel_Window_Guild then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    ToClient_Guild_Manufacture_Start(index, self._slot[index]._productItemEnchantKey)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:delete(index)
  if nil == Panel_Window_Guild then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    self._messageDelete.index = index
    MessageBox.showMessageBox(self._messageDelete, "center")
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:complete(index)
  if nil == Panel_Window_Guild then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    ToClient_Guild_Manufacture_NowComplete(index, self._slot[index]._productItemEnchantKey, toInt64(0, 0), 0)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:receive(index)
  if nil == Panel_Window_Guild then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    ToClient_Guild_Manufacture_Receive(index, self._slot[index]._productItemEnchantKey)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:updateItem(mainIndex, subIndex)
  if nil == Panel_Window_Guild then
    return
  end
  local function ConfirmAlert()
    local slot = self._slot[mainIndex][__eGuildManufactureStateProceeding]
    local itemEnchantKey = slot._requiredItem[subIndex].enchantKey
    local slotNo = ToClient_InventoryGetSlotNo(itemEnchantKey)
    if __eTInventorySlotNoUndefined == slotNo then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_INVENTORY"))
      return
    end
    local itemWrapper = getInventoryItem(slotNo)
    if nil ~= itemWrapper and false == itemWrapper:empty() then
      local stackCount_s64 = itemWrapper:getCount()
      local requiredCount_s64 = slot._requiredItem[subIndex].countValue_s64
      if stackCount_s64 > requiredCount_s64 then
        Panel_NumberPad_Show(true, requiredCount_s64, slotNo, FGlobal_Guild_Manufacture_Update_RequiredItemCount, nil, mainIndex, nil, subIndex)
      else
        Panel_NumberPad_Show(true, stackCount_s64, slotNo, FGlobal_Guild_Manufacture_Update_RequiredItemCount, nil, mainIndex, nil, subIndex)
      end
    end
  end
  local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_NOTICE_TITLE")
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_DELETE_CONTENT_ITEM")
  local messageboxData = {
    title = messageBoxTitle,
    content = messageBoxMemo,
    functionYes = ConfirmAlert,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobal_Guild_Manufacture:select(index)
  if nil == Panel_Window_Guild then
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    PaGlobal_Guild_ManufactureSelect:open(index)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:setProductItemCount(index)
  if nil == Panel_Window_Guild then
    return
  end
  local itemEnchantKey = self._slot[index]._productItemEnchantKey
  if nil == itemEnchantKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_ITEM"))
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
    local limitCount = __eGuildManufactureProductItemCountRateMax
    local manufactureStatic = ToClient_GetGuildManufactureStaticStatusWrapper(itemEnchantKey)
    if nil ~= manufactureStatic then
      limitCount = manufactureStatic:getDailyLimitCount()
    end
    if true == itemStatic:get():isStackableXXX() then
      Panel_NumberPad_Show(true, toInt64(0, tostring(limitCount)), index, FGlobal_Guild_Manufacture_Set_ProductItemCount)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_ITEM2"))
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
end
function PaGlobal_Guild_Manufacture:set(index)
  if nil == Panel_Window_Guild then
    return
  end
  if nil == self._slot[index]._productItemEnchantKey then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_ITEM"))
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and true == selfPlayer:get():isGuildMaster() then
    ToClient_Guild_Manufacture_Set(index, self._slot[index]._productItemEnchantKey, self._slot[index]._productItemCount_s64)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_PERMISSION"))
  end
  if true == PaGlobal_GuildManufactureSelect_GetShow() then
    PaGlobal_Guild_ManufactureSelect:close()
  end
end
function PaGlobal_Guild_Manufacture:setProductItem(index, itemEnchantKey)
  if nil == Panel_Window_Guild then
    return
  end
  local itemEnchantKey = itemEnchantKey
  local itemStatic = getItemEnchantStaticStatus(itemEnchantKey)
  if nil == itemStatic then
    return
  end
  self._slot[index]._productItemEnchantKey = itemEnchantKey
  self._slot[index]._productItemCount_s64 = toInt64(0, 1)
  local slot = self._slot[index][__eGuildManufactureStateNone]
  slot._productSlot:setItemByStaticStatus(itemStatic)
  slot._productSlot.bg:SetShow(true)
  slot._backGround:SetShow(true)
  slot._productItemName:SetText(itemStatic:getName())
  slot._productItemName:SetShow(true)
  slot._stateDesc:SetShow(false)
  slot._setButton:SetShow(true)
  slot._selectButton:SetSpanSize(-95, 30)
  slot._setButton:SetSpanSize(95, 30)
end
function PaGlobal_Guild_Manufacture:productItemTooltip_Show(index, state)
  if nil == Panel_Window_Guild then
    return
  end
  local slot = self._slot[index]
  if nil == slot._productItemEnchantKey then
    return
  end
  local itemStatic = getItemEnchantStaticStatus(slot._productItemEnchantKey)
  if nil ~= itemStatic then
    Panel_Tooltip_Item_SetPosition(index, slot[state], "guildManufactureProductItem")
    Panel_Tooltip_Item_Show(itemStatic, self._ui._guildBG, true)
  end
end
function PaGlobal_Guild_Manufacture:requiredItemTooltip_Show(mainIndex, subIndex)
  if nil == Panel_Window_Guild then
    return
  end
  local slot = self._slot[mainIndex][__eGuildManufactureStateProceeding]
  local itemStatic = getItemEnchantStaticStatus(slot._requiredItem[subIndex].enchantKey)
  if nil ~= itemStatic then
    Panel_Tooltip_Item_SetPosition(subIndex, self._slot[mainIndex], "guildManufactureRequiredItem")
    Panel_Tooltip_Item_Show(itemStatic, self._ui._guildBG, true)
  end
end
function PaGlobal_Guild_Manufacture:itemTooltip_Hide()
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_Guild_Manufacture_Refresh(index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  if false == self._ui._guildBG:GetShow() then
    return
  end
  self:refreshState(index)
end
function FromClient_Guild_Manufacture_CompletePrice(index, itemEnchantKey, price_s64)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  local msg = self._messageNowCompleteAck
  msg.content = string.format(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_MANUFACTURE_MESSAGE_NOW"), makeDotMoney(price_s64))
  msg.itemEnchantKey = itemEnchantKey
  msg.index = index
  msg.price_s64 = price_s64
  MessageBox.showMessageBox(msg, "center")
end
function FromClient_Init_Guild_Manufacture()
  PaGlobal_GuildManufacture_Init()
  PaGlobal_Guild_Manufacture:registMessageHandler()
end
function PaGlobal_GuildManufacture_Init()
  PaGlobal_Guild_Manufacture:initialize()
end
function FGlobal_Guild_Manufacture_Now_Complete_Yes()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  local msg = self._messageNowCompleteAck
  ToClient_Guild_Manufacture_NowComplete(msg.index, msg.itemEnchantKey, msg.price_s64, 1)
  msg.itemEnchantKey = nil
  msg.index = nil
  msg.price_s64 = nil
end
function FGlobal_Guild_Manufacture_Now_Complete_No()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  local msg = self._messageNowCompleteAck
  msg.itemEnchantKey = nil
  msg.index = nil
  msg.price_s64 = nil
end
function FGlobal_Guild_Manufacture_Delete_Yes()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  local index = self._messageDelete.index
  ToClient_Guild_Manufacture_Delete(index, self._slot[index]._productItemEnchantKey)
  self._messageDelete.index = nil
end
function FGlobal_Guild_Manufacture_Delete_No()
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  self._messageDelete.index = nil
end
function FGlobal_Guild_Manufacture_Set_ProductItemCount(inputNumber, index)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  self._slot[index]._productItemCount_s64 = inputNumber
end
function FGlobal_Guild_Manufacture_Update_RequiredItemCount(inputNumber, slotNo, mainIndex, subIndex)
  if nil == Panel_Window_Guild then
    return
  end
  local self = PaGlobal_Guild_Manufacture
  local slot = self._slot[mainIndex][__eGuildManufactureStateProceeding]
  local itemEnchantKey = slot._requiredItem[subIndex].enchantKey
  ToClient_Guild_Manufacture_Update(mainIndex, subIndex, itemEnchantKey, CppEnums.ItemWhereType.eInventory, slotNo, inputNumber)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Init_Guild_Manufacture")
