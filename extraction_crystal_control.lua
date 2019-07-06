local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local tempTable
function PaGlobal_ExtractionCrystal:createControl()
  self:createControl_uiEquipMain()
  self:createControl_uiSlotSocket()
  self:createControl_uiSlotExtractionMaterial()
end
function PaGlobal_ExtractionCrystal:createControl_uiEquipMain()
  local extractionEquipMain = {}
  extractionEquipMain.icon = self._uiControl.staticEquipSocket
  SlotItem.new(extractionEquipMain, "ExtractionEquip_Socket", 0, Panel_Window_Extraction_Crystal, self._slotConfig)
  extractionEquipMain:createChild()
  extractionEquipMain.icon:addInputEvent("Mouse_RUp", "PaGlobal_ExtractionCrystal:handleMRUpEquipSocket()")
  Panel_Tooltip_Item_SetPosition(0, extractionEquipMain, "Socket")
  CopyBaseProperty(self._enchantNumber, extractionEquipMain.enchantText)
  extractionEquipMain.enchantText:SetSize(extractionEquipMain.icon:GetSizeX(), extractionEquipMain.icon:GetSizeY())
  extractionEquipMain.enchantText:SetPosX(0)
  extractionEquipMain.enchantText:SetPosY(0)
  extractionEquipMain.enchantText:SetTextHorizonCenter()
  extractionEquipMain.enchantText:SetTextVerticalCenter()
  extractionEquipMain.enchantText:SetShow(true)
  extractionEquipMain.empty = true
  self._uiEquipMain = extractionEquipMain
  self._uiEquipMain.slotNo = -1
end
function PaGlobal_ExtractionCrystal:createControl_uiSlotSocket()
  local slotSocket = {}
  for ii = 1, self._config.socketSlotCount do
    slotSocket = {
      icon = self._uiControl.staticSocket[ii],
      iconBg = self._uiControl.staticSocketBackground[ii],
      name = self._uiControl.staticSocketName[ii],
      desc = self._uiControl.staticSocketDesc[ii],
      extractionButton = self._uiControl.staticSocketExtractionButton[ii],
      staticStuffSlotBG = self._uiControl.staticStuffSlotBG[ii]
    }
    function slotSocket:setShow(bShow)
      self.icon:SetShow(bShow)
      self.iconBg:SetShow(bShow)
      self.name:SetShow(bShow)
      self.desc:SetShow(bShow)
      self.extractionButton:SetShow(bShow)
      self.staticStuffSlotBG:SetShow(bShow)
    end
    slotSocket.name:SetText("")
    slotSocket.desc:SetText("")
    self._onlySocketListBG[ii]:SetShow(true)
    local indexSocket = ii - 1
    SlotItem.new(slotSocket, "Socket_" .. ii, ii, Panel_Window_Extraction_Crystal, self._slotConfig)
    slotSocket:createChild()
    slotSocket.icon:addInputEvent("Mouse_RUp", "PaGlobal_ExtractionCrystal:removeCrystal( " .. indexSocket .. " )")
    slotSocket.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_InsertExtraction\", true)")
    slotSocket.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_InsertExtraction\", false)")
    Panel_Tooltip_Item_SetPosition(ii, slotSocket, "Socket_InsertExtraction")
    slotSocket.extractionButton:addInputEvent("Mouse_LUp", "PaGlobal_ExtractionCrystal:handleMLUpExtractionButton(" .. indexSocket .. ")")
    slotSocket.empty = true
    self._uiSlotSocket:push_back(slotSocket)
  end
  self._onlySocketBg:SetShow(true)
end
function PaGlobal_ExtractionCrystal:createControl_uiSlotExtractionMaterial()
  local slot_ExtractionMaterial = {}
  for ii = 1, self._config.socketSlotCount do
    slot_ExtractionMaterial = {
      staticStuffSlot = self._uiControl.staticStuffSlot[ii]
    }
    SlotItem.new(slot_ExtractionMaterial, "CreateStuffSlot_" .. ii, ii, Panel_Window_Extraction_Crystal, self._slotConfig)
    slot_ExtractionMaterial:createChild()
    slot_ExtractionMaterial.empty = true
    self._uiSlotExtractionMaterial:push_back(slot_ExtractionMaterial)
  end
end
function Socket_Extraction_InvenFiler_EquipItem(slotNo, itemWrapper, WhereType)
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
function Socket_Extraction_InvenFiler_Stuff(slotNo, itemWrapper, whereType)
  if nil == itemWrapper then
    return true
  end
  local isAble = getSocketInformation():isExtractionSource(whereType, slotNo)
  return not isAble
end
function Panel_Socket_ExtractionCrystal_InteractortionFromInventory(slotNo, itemWrapper, count_s64, inventoryType)
  local self = PaGlobal_ExtractionCrystal
  local socketInfo = getSocketInformation()
  local success = 0 == Socket_SetItemHaveSocket(inventoryType, slotNo)
  if not success then
    self:clearData()
    Inventory_SetFunctor(Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil)
    return
  end
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  UI.ASSERT(nil ~= itemWrapper, "Item Is Null?!?!?!")
  if socketInfo._setEquipItem then
    self._uiEquipMain.empty = false
    self._uiEquipMain.slotNo = slotNo
    self._uiEquipMain.invenType = inventoryType
    self._uiEquipMain:setItem(itemWrapper)
    self._uiEquipMain.icon:SetShow(true)
    self._uiEquipMain.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', true)")
    self._uiEquipMain.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', false)")
    Panel_Tooltip_Item_SetPosition(slotNo, self._uiEquipMain, "SocketItem")
    self:updateSocket()
    audioPostEvent_SystemUi(0, 16)
    Inventory_SetFunctor(Socket_Extraction_InvenFiler_Stuff, Click_ExtractionCrystal_Stuff, Socket_ExtractionCrystal_WindowClose, nil)
  else
    local rv = socketInfo:checkPushJewelToEmptySoket(slotNo)
    if 0 == rv then
      local index = socketInfo._indexPush
      local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_TITLE")
      local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_MESSAGE", "socketNum", string.format("%d", index + 1), "itemName", itemWrapper:getStaticStatus():getName())
      local messageboxData = {
        title = titleString,
        content = contentString,
        functionYes = Socket_Push_Confirm,
        functionCancel = Socket_Deny,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageboxData)
    end
  end
end
function Click_ExtractionCrystal_Stuff(slotNo, itemWrapper, count_s64, inventoryType)
  local self = PaGlobal_ExtractionCrystal
  local socketInfo = getSocketInformation()
  local invenItemWrapper = getInventoryItemByType(self._uiEquipMain.invenType, self._uiEquipMain.slotNo)
  local maxCount = invenItemWrapper:get():getUsableItemSocketCount()
  local _IsMaterial = socketInfo:isExtractionSource(inventoryType, slotNo)
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  UI.ASSERT(nil ~= itemWrapper, "Item Is Null?!?!?!")
  local slotExtractionMaterial_Pos = {
    [1] = {X = 524, Y = 113},
    [2] = {X = 524, Y = 216},
    [3] = {X = 524, Y = 318}
  }
  if _IsMaterial then
    self._stuffSlotNo = slotNo
    self._stuffInvenType = inventoryType
    for ii = 1, maxCount do
      if true == self._useSlot[ii] then
        self._uiSlotExtractionMaterial[ii]:setItem(itemWrapper)
        self._uiControl.staticStuffSlot[ii]:SetShow(false)
        self._uiSlotExtractionMaterial[ii].icon:SetPosX(slotExtractionMaterial_Pos[ii].X)
        self._uiSlotExtractionMaterial[ii].icon:SetPosY(slotExtractionMaterial_Pos[ii].Y)
        self._uiControl.staticSocketExtractionButton[ii]:SetShow(true)
        self._uiControl.staticSocketExtractionButton[ii]:SetIgnore(false)
        self._uiControl.staticSocketExtractionButton[ii]:SetMonoTone(false)
      else
        self._uiControl.staticStuffSlot[ii]:SetShow(false)
        self._uiControl.staticSocketExtractionButton[ii]:SetShow(false)
        self._uiControl.staticSocketExtractionButton[ii]:SetIgnore(true)
        self._uiControl.staticSocketExtractionButton[ii]:SetMonoTone(true)
      end
    end
    audioPostEvent_SystemUi(0, 16)
    self:updateSocket()
  end
end
function PaGlobal_ExtractionCrystal:removeCrystal(indexSocket)
  if true == self._uiSlotSocket[indexSocket + 1].empty then
    return
  end
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_MESSAGE", "socketNum", string.format("%d", indexSocket + 1))
  local function remove_crystal_do()
    audioPostEvent_SystemUi(5, 7)
    Socket_PopJewelFromSocket(indexSocket, CppEnums.ItemWhereType.eCount, CppEnums.TInventorySlotNoUndefined)
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
function PaGlobal_ExtractionCrystal:updateSocket()
  if self._uiEquipMain.empty then
    UI.ASSERT(false, "Must not be EMPTY!!!!")
    return
  end
  local invenItemWrapper = getInventoryItemByType(self._uiEquipMain.invenType, self._uiEquipMain.slotNo)
  local maxCount = invenItemWrapper:get():getUsableItemSocketCount()
  if 0 ~= self._save_ExtractionMateria_Slot_status then
    for ii = 1, maxCount do
      self._uiSlotExtractionMaterial[ii]:clearItem()
      self._uiControl.staticStuffSlot[ii]:SetShow(false)
      self._uiControl.staticSocketExtractionButton[ii]:SetShow(false)
      self._uiControl.staticSocketExtractionButton[ii]:SetIgnore(true)
      self._uiControl.staticSocketExtractionButton[ii]:SetMonoTone(true)
    end
  end
  self._save_ExtractionMateria_Slot_status = 0
  self._crystalKeys = {}
  tempTable = {}
  local classType = getSelfPlayer():getClassType()
  for ii = 1, maxCount do
    local socketSlot = self._uiSlotSocket[ii]
    local itemStaticWrapper = invenItemWrapper:getPushedItem(ii - 1)
    socketSlot:setShow(true)
    self._onlySocketListBG[ii]:EraseAllEffect()
    if nil == itemStaticWrapper then
      local socketBG_0 = self._onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
      socketBG_0:SetStartColor(UI_color.C_FF626262)
      socketBG_0:SetEndColor(UI_color.C_FFFFFFFF)
      if ii == 1 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self._onlySocketListBG[2]:SetColor(UI_color.C_FF626262)
        self._onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 2 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self._onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 3 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self._onlySocketListBG[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
      end
      socketSlot:clearItem()
      socketSlot.empty = true
      socketSlot.name:SetText(self._text[1])
      socketSlot.desc:SetText(self._desc[1])
      self._uiEquipMain.icon:AddEffect("UI_ItemJewel", false, 0, 0)
      self._useSlot[ii] = false
    else
      local socketBG_0 = self._onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
      socketBG_0:SetStartColor(UI_color.C_FF626262)
      socketBG_0:SetEndColor(UI_color.C_FFFFFFFF)
      if ii == 1 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self._onlySocketListBG[2]:SetColor(UI_color.C_FF626262)
        self._onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
        self._onlySocketListBG[1]:AddEffect("UI_LimitExtract_TopLoop", true, -217, 40)
      elseif ii == 2 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self._onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
        self._onlySocketListBG[2]:AddEffect("UI_LimitExtract_MidLoop", true, -210, -21)
      elseif ii == 3 then
        local socketBG_1 = self._onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self._onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self._onlySocketListBG[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
        self._onlySocketListBG[3]:AddEffect("UI_LimitExtract_BotLoop", true, -214, -77.5)
      end
      self._crystalKeys[ii - 1] = itemStaticWrapper:get()._key:get()
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
        self._useSlot[ii] = true
      end
      socketSlot.desc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      socketSlot.desc:SetLineCount(4)
      socketSlot.desc:SetText(desc)
      if socketSlot.desc:IsLimitText() then
        socketSlot.desc:SetIgnore(false)
        tempTable[ii] = {}
        tempTable[ii].control = socketSlot.desc
        tempTable[ii].desc = socketSlot.desc:GetText()
        socketSlot.desc:addInputEvent("Mouse_On", "PaGlobalFunc_Crystal_Control_TooltipLimitedText(" .. ii .. ",true)")
        socketSlot.desc:addInputEvent("Mouse_Out", "PaGlobalFunc_Crystal_Control_TooltipLimitedText(" .. ii .. ",false)")
      else
        socketSlot.desc:SetIgnore(true)
      end
    end
  end
  for ii = maxCount + 1, self._config.socketSlotCount do
    local socketSlot = self._uiSlotSocket[ii]
    socketSlot:setShow(false)
  end
end
function PaGlobalFunc_Crystal_Control_TooltipLimitedText(index, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if nil == tempTable then
    return
  end
  TooltipSimple_Show(tempTable[index].control, "", tempTable[index].desc)
end
function PaGlobal_ExtractionCrystal:result()
  PaGlobal_ExtractionCrystal:resultShow()
  PaGlobal_ExtractionCrystal:updateSocket()
end
function PaGlobal_ExtractionCrystal:clearData(uiOnly)
  self._uiEquipMain:clearItem()
  self._uiEquipMain.empty = true
  self._uiEquipMain.slotNo = -1
  self._uiEquipMain.icon:SetShow(false)
  self._crystalKeys = {}
  local socketBG_0 = self._onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  socketBG_0:SetStartColor(UI_color.C_FFFFFFFF)
  socketBG_0:SetEndColor(UI_color.C_FF626262)
  for ii = 1, self._config.socketSlotCount do
    local socketBG_1 = self._onlySocketListBG[ii]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    socketBG_1:SetStartColor(UI_color.C_FFFFFFFF)
    socketBG_1:SetEndColor(UI_color.C_FF626262)
    self._onlySocketListBG[ii]:EraseAllEffect()
    self._uiSlotSocket[ii]:setShow(false)
    self._uiSlotSocket[ii].empty = true
    self._uiSlotExtractionMaterial[ii]:clearItem()
    self._uiControl.staticStuffSlot[ii]:SetShow(false)
    self._uiControl.staticStuffSlot[ii].empty = true
    self._uiControl.staticSocketExtractionButton[ii]:SetShow(false)
    self._uiControl.staticSocketExtractionButton[ii]:SetIgnore(true)
    self._uiControl.staticSocketExtractionButton[ii]:SetMonoTone(true)
  end
  if not uiOnly then
    getSocketInformation():clearData()
  end
  self._stuffInvenType = -1
  self._stuffSlotNo = -1
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobal_ExtractionCrystal:handleMRUpEquipSocket()
  getSocketInformation():popEquip()
  self:clearData()
  audioPostEvent_SystemUi(0, 16)
  Inventory_SetFunctor(Socket_Extraction_InvenFiler_EquipItem, Panel_Socket_ExtractionCrystal_InteractortionFromInventory, Socket_ExtractionCrystal_WindowClose, nil)
end
function PaGlobal_ExtractionCrystal:handleMLUpExtractionButton(indexSocket)
  if true == self._uiSlotSocket[indexSocket + 1].empty then
    return
  end
  self._indexSocket = indexSocket
  self._extractionType = 0
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_EXTRACTION_CRYSTAL_EXTRACT")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SOCKET_EXTRACTION_MESSAGE", "socketNum", string.format("%d", indexSocket + 1))
  local function ExtractionCrystal_Pop_Confirm()
    self._save_ExtractionMateria_Slot_status = 1
    local self = PaGlobal_ExtractionCrystal
    audioPostEvent_SystemUi(5, 7)
    Socket_PopJewelFromSocket(PaGlobal_ExtractionCrystal._indexSocket, self._stuffInvenType, self._stuffSlotNo)
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
function Socket_GetExtractionSlotNo()
  return PaGlobal_ExtractionCrystal._uiEquipMain.slotNo
end
