local _mainPanel = Panel_Window_Extract_Renew
local _panel = Panel_Tab_ExtractCrystal_Renew
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local ExtractCrystal = {
  _ui = {
    stc_group = UI.getChildControl(_panel, "Static_CrystalGroup"),
    stc_keyGuideGroup = UI.getChildControl(_panel, "Static_KeyGuideGroup")
  },
  config = {socketSlotCount = 3, curSlotCount = 3},
  slotTarget = nil,
  slotSocket = nil,
  _currentIndex = 1,
  _selectedIndex = 1,
  _targetSlotNo = nil,
  _targetWhereType = nil,
  _stuffSlotNo = nil,
  _stuffInvenType = nil,
  _crystalKeys = {}
}
local self = ExtractCrystal
function FromClient_luaLoadComplete_ExtractCrystal_Init()
  self:initialize()
  local moveTarget = UI.getChildControl(_mainPanel, "Static_CrystalGroup")
  moveTarget:SetShow(false)
  moveTarget:MoveChilds(moveTarget:GetID(), _panel)
  deletePanel(_panel:GetID())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_ExtractCrystal_Init")
function ExtractCrystal:initialize()
  local slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  }
  local socketBG = UI.getChildControl(self._ui.stc_group, "Static_SocketBG")
  self._ui.stc_targeSlotBG = UI.getChildControl(self._ui.stc_group, "Static_SlotBase")
  self.slotTarget = {}
  SlotItem.new(self.slotTarget, "TargetSlot", 0, self._ui.stc_targeSlotBG, slotConfig)
  self.slotTarget:createChild()
  self.slotTarget:clearItem()
  self._ui.stc_socketFrame = {
    UI.getChildControl(socketBG, "Static_SocketFrame1")
  }
  for ii = 2, self.config.socketSlotCount do
    self._ui.stc_socketFrame[ii] = UI.cloneControl(self._ui.stc_socketFrame[1], socketBG, "Static_SocketFrame" .. ii)
    self._ui.stc_socketFrame[ii]:SetPosY(self._ui.stc_socketFrame[ii]:GetPosY() + (ii - 1) * 130)
  end
  self.slotSocket = {}
  self.slotSubject = {}
  for ii = 1, self.config.socketSlotCount do
    self.slotSocket[ii] = {}
    self.slotSocket[ii].bg = UI.getChildControl(self._ui.stc_socketFrame[ii], "Static_Socket_1_Background")
    self.slotSocket[ii].icon = UI.getChildControl(self.slotSocket[ii].bg, "Static_GemSlot1")
    SlotItem.new(self.slotSocket[ii], "Socket_" .. ii, ii, self.slotSocket[ii].bg, slotConfig)
    self.slotSocket[ii].frame = self._ui.stc_socketFrame[ii]
    self.slotSocket[ii].name = UI.getChildControl(self._ui.stc_socketFrame[ii], "StaticText_GemTitle1")
    self.slotSocket[ii].desc = UI.getChildControl(self._ui.stc_socketFrame[ii], "StaticText_GemInfo1")
    self.slotSocket[ii].name:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self.slotSocket[ii].desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self.slotSocket[ii].empty = true
    self._ui.stc_socketFrame[ii]:addInputEvent("Mouse_On", "InputMOn_ExtractCrystal_HoverOnSocket(" .. ii .. ")")
    self._ui.stc_socketFrame[ii]:addInputEvent("Mouse_LUp", "InputMLUp_ExtractCrystal_SelectSocket(" .. ii .. ")")
    self.slotSocket[ii].name:SetText("")
    self.slotSocket[ii].desc:SetText("")
    self.slotSubject[ii] = {}
    self.slotSubject[ii].bg = UI.getChildControl(self._ui.stc_socketFrame[ii], "Static_StuffSlot_1_Background")
    SlotItem.new(self.slotSubject[ii], "Socket_" .. ii, ii, self.slotSubject[ii].bg, slotConfig)
  end
  self._ui.stc_focusBox = UI.getChildControl(self._ui.stc_group, "Static_FocusBox")
  self:initKeyGuideGroupSize()
  self._ui.txt_keyGuideExtract = UI.getChildControl(self._ui.stc_keyGuideGroup, "StaticText_Extract_ConsoleUI")
  self._ui.txt_keyGuideRemove = UI.getChildControl(self._ui.stc_keyGuideGroup, "StaticText_Remove_ConsoleUI")
  self._keyGuidesGroup = {
    self._ui.txt_keyGuideRemove,
    self._ui.txt_keyGuideExtract
  }
  self:updateKeyGuidePos()
end
function ExtractCrystal:initKeyGuideGroupSize()
  local mainKeyGuideGroup = UI.getChildControl(_mainPanel, "Static_KeyGuideGroup")
  local mainBKeyGuide = UI.getChildControl(mainKeyGuideGroup, "StaticText_KeyGuide")
  local sizeX = mainBKeyGuide:GetPosX()
  self._ui.stc_keyGuideGroup:SetSize(sizeX, self._ui.stc_keyGuideGroup:GetSizeY())
end
function ExtractCrystal:updateKeyGuidePos()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuidesGroup, self._ui.stc_keyGuideGroup, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_ExtractCrystal_Open()
  getSocketInformation():clearData()
  self:updateHighlightPos()
  self:updateSocket()
  PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
  Inventory_SetFunctor(PaGlobalFunc_ExtractCrystal_FilterTarget, PaGlobalFunc_ExtractCrystal_rClickTarget, nil, nil)
  ToClient_padSnapSetTargetPanel(_mainPanel)
end
function ExtractCrystal:updateHighlightPos()
  self._ui.stc_focusBox:SetPosY((self._currentIndex - 1) * 133 + 52)
end
function PaGlobalFunc_ExtractCrystal_Close()
  self:removeSubject()
  self:removeTarget()
end
function InputMOn_ExtractCrystal_HoverOnSocket(index)
  self._currentIndex = index
  self:updateHighlightPos()
  PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
end
function InputMLUp_ExtractCrystal_SelectSocket(index)
end
function PaGlobalFunc_ExtractCrystal_FilterTarget(slotNo, itemWrapper, WhereType)
  if nil == itemWrapper then
    return true
  end
  local invenItemWrapper = getInventoryItemByType(WhereType, slotNo)
  local maxCount = itemWrapper:get():getUsableItemSocketCount()
  local blankSlot_Count = maxCount
  for sock_idx = 1, maxCount do
    local itemStaticWrapper = itemWrapper:getPushedItem(sock_idx - 1)
    if nil == itemStaticWrapper then
      blankSlot_Count = blankSlot_Count - 1
    end
  end
  if true == ToClient_Inventory_CheckItemLock(slotNo, Inventory_GetCurrentInventoryType()) then
    return true
  end
  return not itemWrapper:getStaticStatus():get():doHaveSocket() or 0 == blankSlot_Count
end
function PaGlobalFunc_ExtractCrystal_rClickTarget(slotNo, itemWrapper, count_s64, inventoryType)
  local socketInfo = getSocketInformation()
  local success = 0 == Socket_SetItemHaveSocket(inventoryType, slotNo)
  if not success then
    local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
    socketInfo:clearData()
    Inventory_SetFunctor(PaGlobalFunc_ExtractCrystal_FilterTarget, PaGlobalFunc_ExtractCrystal_rClickTarget, nil, nil)
    return
  end
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  if nil == itemWrapper then
    return
  end
  if socketInfo._setEquipItem then
    self.slotTarget:setItem(itemWrapper)
    self._targetWhereType = inventoryType
    self._targetSlotNo = slotNo
    self:updateSocket()
    Inventory_SetFunctor(PaGlobalFunc_ExtractCrystal_FilterSubject, PaGlobalFunc_ExtractCrystal_rClickSubject, nil, nil)
  end
end
function ExtractCrystal:updateSocket()
  if nil == self._targetWhereType or nil == self._targetSlotNo then
    return
  end
  local invenItemWrapper = getInventoryItemByType(self._targetWhereType, self._targetSlotNo)
  local maxCount = invenItemWrapper:get():getUsableItemSocketCount()
  local classType = getSelfPlayer():getClassType()
  for ii = 1, self.config.socketSlotCount do
    self.slotSocket[ii].icon:SetShow(false)
  end
  self._crystalKeys = {}
  for ii = 1, maxCount do
    self.slotSocket[ii].icon:SetShow(true)
    local socketSlot = self.slotSocket[ii]
    local itemStaticWrapper = invenItemWrapper:getPushedItem(ii - 1)
    self._ui.stc_socketFrame[ii]:EraseAllEffect()
    if nil == itemStaticWrapper then
      if ii == 1 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self._ui.stc_socketFrame[2]:SetColor(UI_color.C_FF626262)
        self._ui.stc_socketFrame[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 2 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._ui.stc_socketFrame[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self._ui.stc_socketFrame[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 3 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._ui.stc_socketFrame[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self._ui.stc_socketFrame[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
      end
      socketSlot:clearItem()
      socketSlot.empty = true
      socketSlot.name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT"))
      socketSlot.desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_SLOT_EMPTY"))
      self.slotTarget.icon:AddEffect("UI_ItemJewel", false, 0, 0)
      self.slotSubject[ii]:clearItem()
    else
      if ii == 1 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self._ui.stc_socketFrame[2]:SetColor(UI_color.C_FF626262)
        self._ui.stc_socketFrame[3]:SetColor(UI_color.C_FF626262)
        audioPostEvent_SystemUi(5, 6)
        _AudioPostEvent_SystemUiForXBOX(0, 16)
      elseif ii == 2 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._ui.stc_socketFrame[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self._ui.stc_socketFrame[3]:SetColor(UI_color.C_FF626262)
        _AudioPostEvent_SystemUiForXBOX(0, 16)
      elseif ii == 3 then
        local socketBG_1 = self._ui.stc_socketFrame[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._ui.stc_socketFrame[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self._ui.stc_socketFrame[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
        _AudioPostEvent_SystemUiForXBOX(5, 6)
      end
      self._crystalKeys[ii] = itemStaticWrapper:get()._key:get()
      socketSlot:setItemByStaticStatus(itemStaticWrapper, 0)
      socketSlot.empty = false
      local text = itemStaticWrapper:getName()
      local desc = ""
      socketSlot.name:SetText(text)
      local jewelSkillStaticWrapper = itemStaticWrapper:getSkillByIdx(classType)
      if nil ~= jewelSkillStaticWrapper then
        for buffIdx = 0, jewelSkillStaticWrapper:getBuffCount() - 1 do
          local descCurrent = jewelSkillStaticWrapper:getBuffDescription(buffIdx)
          if nil == descCurrent or "" == descCurrent then
            break
          end
          if desc == "" then
            desc = descCurrent
          else
            desc = desc .. "\n" .. descCurrent
          end
        end
      end
      socketSlot.desc:SetText(desc)
    end
  end
end
function PaGlobalFunc_ExtractCrystal_FilterSubject(slotNo, itemWrapper, whereType)
  if nil == itemWrapper then
    return true
  end
  local isAble = getSocketInformation():isExtractionSource(whereType, slotNo)
  return not isAble
end
function PaGlobalFunc_ExtractCrystal_rClickSubject(slotNo, itemWrapper, count_s64, inventoryType)
  local socketInfo = getSocketInformation()
  local invenItemWrapper = getInventoryItemByType(self._targetWhereType, self._targetSlotNo)
  local maxCount = invenItemWrapper:get():getUsableItemSocketCount()
  local _IsMaterial = socketInfo:isExtractionSource(inventoryType, slotNo)
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  UI.ASSERT(nil ~= itemWrapper, "Item Is Null?!?!?!")
  if _IsMaterial then
    self._stuffSlotNo = slotNo
    self._stuffInvenType = inventoryType
    for ii = 1, maxCount do
      if false == self.slotSocket[ii].empty then
        self.slotSubject[ii]:setItem(itemWrapper)
      else
        self.slotSubject[ii]:clearItem()
      end
    end
    self:updateSocket()
  end
  ToClient_padSnapSetTargetPanel(_mainPanel)
end
function PaGlobalFunc_ExtractCrystal_ApplyRemove()
  if true == self.slotSocket[self._currentIndex].empty then
    return
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_MESSAGE", "socketNum", string.format("%d", self._currentIndex))
  local function remove_crystal_do()
    Socket_PopJewelFromSocket(self._currentIndex - 1, CppEnums.ItemWhereType.eCount, CppEnums.TInventorySlotNoUndefined)
  end
  self._extractionType = 1
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = remove_crystal_do,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_ExtractCrystal_ApplyExtract()
  if true == self.slotSocket[self._currentIndex].empty then
    return
  end
  self._extractionType = 0
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SOCKET_EXTRACTION_MESSAGE", "socketNum", string.format("%d", self._currentIndex))
  local function ExtractionCrystal_Pop_Confirm()
    Socket_PopJewelFromSocket(self._currentIndex - 1, self._stuffInvenType, self._stuffSlotNo)
  end
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = ExtractionCrystal_Pop_Confirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_ExtractCrystal_Result()
  if 0 == self._extractionType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._crystalKeys[self._indexSocket]))
    if nil ~= itemSSW then
      PaGlobal_ExtractionResult:showResultMessage(itemSSW:getName(), PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT_DONE"), itemSSW)
    else
      PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT_DONE"))
    end
  else
    PaGlobal_ExtractionResult:showResultMessage(PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_REMOVE_DONE"))
  end
  self:updateSocket()
  PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
end
function PaGlobalFunc_ExtractCrystal_OnPadB()
  if nil ~= self._stuffSlotNo then
    self:removeSubject()
    PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
    return false
  elseif nil ~= self._targetSlotNo then
    self:removeTarget()
    PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
    return false
  end
  return true
end
function ExtractCrystal:removeSubject()
  self._stuffSlotNo = nil
  self._stuffInvenType = nil
  for ii = 1, self.config.socketSlotCount do
    self.slotSubject[ii]:clearItem()
  end
  Inventory_SetFunctor(PaGlobalFunc_ExtractCrystal_FilterSubject, PaGlobalFunc_ExtractCrystal_rClickSubject, nil, nil)
end
function ExtractCrystal:removeTarget()
  self.slotTarget:clearItem()
  self._crystalKeys = {}
  self._targetSlotNo = nil
  self._targetWhereType = nil
  for ii = 1, self.config.socketSlotCount do
    self.slotSocket[ii]:clearItem()
    self.slotSocket[ii].empty = true
    self.slotSocket[ii].name:SetText("")
    self.slotSocket[ii].desc:SetText("")
  end
  getSocketInformation():clearData()
  Inventory_SetFunctor(PaGlobalFunc_ExtractCrystal_FilterTarget, PaGlobalFunc_ExtractCrystal_rClickTarget, nil, nil)
end
function PaGlobalFunc_ExtractCrystal_UpdateKeyGuide()
  local snappedOnMainPanel = PaGlobalFunc_ExtractInfo_SnappedOnMainPanel()
  self._ui.stc_focusBox:SetMonoTone(not snappedOnMainPanel)
  local socketIsFilled = false == self.slotSocket[self._currentIndex].empty
  local stuffIsReady = nil ~= self._stuffSlotNo
  self._ui.txt_keyGuideExtract:SetShow(snappedOnMainPanel and socketIsFilled and stuffIsReady)
  self._ui.txt_keyGuideRemove:SetShow(snappedOnMainPanel and socketIsFilled)
  self:updateKeyGuidePos()
end
