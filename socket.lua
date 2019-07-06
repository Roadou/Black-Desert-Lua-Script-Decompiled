local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
Panel_Window_Socket:SetShow(false, false)
Panel_Window_Socket:setMaskingChild(true)
Panel_Window_Socket:setGlassBackground(true)
Panel_Window_Socket:SetDragEnable(true)
Panel_Window_Socket:SetDragAll(true)
Panel_Window_Socket:RegisterShowEventFunc(true, "SocketShowAni()")
Panel_Window_Socket:RegisterShowEventFunc(false, "SocketHideAni()")
local socket = {
  slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  config = {socketSlotCount = 3, curSlotCount = 3},
  control = {
    textureArea = UI.getChildControl(Panel_Window_Socket, "Static_SocketGroup")
  },
  text = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT")
  },
  desc = {
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_EMPTYSLOT_DESC")
  },
  slotMain = nil,
  slotSocket = Array.new(),
  _indexSocket = nil,
  _jewelInvenSlotNo = nil,
  _posX = 0,
  _posY = 0
}
local commentBG = UI.getChildControl(Panel_Window_Socket, "Static_CommentBG")
local isItemLock = false
local _buttonQuestion = UI.getChildControl(Panel_Window_Socket, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"Socket\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"Socket\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"Socket\", \"false\")")
socket._posX = Panel_Window_Socket:GetPosX()
socket._posY = Panel_Window_Socket:GetPosY()
local tempTable = {}
function socket:init()
  self.control.staticEnchantItem = UI.getChildControl(self.control.textureArea, "Static_Equip_Socket")
  self.control.onlySocketListBG = {
    [1] = UI.getChildControl(self.control.textureArea, "Static_SocketBG_0"),
    [2] = UI.getChildControl(self.control.textureArea, "Static_SocketBG_1"),
    [3] = UI.getChildControl(self.control.textureArea, "Static_SocketBG_2")
  }
  self.control.onlySocketBg = UI.getChildControl(self.control.textureArea, "Static_SocketListBG")
  self.control.staticSocketDescGroup = {
    UI.getChildControl(self.control.textureArea, "Static_DescGroup_1"),
    UI.getChildControl(self.control.textureArea, "Static_DescGroup_2"),
    UI.getChildControl(self.control.textureArea, "Static_DescGroup_3")
  }
  self.control.staticSocketDesc = {
    [1] = {
      UI.getChildControl(self.control.staticSocketDescGroup[1], "StaticText_Desc_1"),
      UI.getChildControl(self.control.staticSocketDescGroup[1], "StaticText_Desc_2"),
      UI.getChildControl(self.control.staticSocketDescGroup[1], "StaticText_Desc_3")
    },
    [2] = {
      UI.getChildControl(self.control.staticSocketDescGroup[2], "StaticText_Desc_1"),
      UI.getChildControl(self.control.staticSocketDescGroup[2], "StaticText_Desc_2"),
      UI.getChildControl(self.control.staticSocketDescGroup[2], "StaticText_Desc_3")
    },
    [3] = {
      UI.getChildControl(self.control.staticSocketDescGroup[3], "StaticText_Desc_1"),
      UI.getChildControl(self.control.staticSocketDescGroup[3], "StaticText_Desc_2"),
      UI.getChildControl(self.control.staticSocketDescGroup[3], "StaticText_Desc_3")
    }
  }
  self.control.staticSocketName = {
    UI.getChildControl(self.control.textureArea, "StaticText_NameTag_1"),
    UI.getChildControl(self.control.textureArea, "StaticText_NameTag_2"),
    UI.getChildControl(self.control.textureArea, "StaticText_NameTag_3")
  }
  self.control.staticSocket = {
    UI.getChildControl(self.control.textureArea, "Static_Socket_1"),
    UI.getChildControl(self.control.textureArea, "Static_Socket_2"),
    UI.getChildControl(self.control.textureArea, "Static_Socket_3")
  }
  self.control.staticSocketBackground = {
    UI.getChildControl(self.control.textureArea, "Static_Socket_1_Background"),
    UI.getChildControl(self.control.textureArea, "Static_Socket_2_Background"),
    UI.getChildControl(self.control.textureArea, "Static_Socket_3_Background")
  }
  for _, control in ipairs(self.control.staticSocketName) do
    control:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  end
  Panel_Window_Socket:SetEnableArea(0, 0, 500, 25)
  commentBG:SetSize(commentBG:GetSizeX(), commentBG:GetTextSizeY() + 5)
end
function socket:createControl()
  local slotMain = {}
  slotMain.icon = self.control.staticEnchantItem
  SlotItem.new(slotMain, "Equip_Socket", 0, Panel_Window_Socket, self.slotConfig)
  slotMain:createChild()
  slotMain.icon:addInputEvent("Mouse_RUp", "Socket_EquipSlotRClick()")
  slotMain.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(0, \"Socket\", true)")
  slotMain.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(0, \"Socket\", false)")
  Panel_Tooltip_Item_SetPosition(0, slotMain, "Socket")
  slotMain.empty = true
  self.slotMain = slotMain
  self.slotMain.whereType = nil
  self.slotMain.slotNo = nil
  for ii = 1, self.config.socketSlotCount do
    slotSocket = {
      icon = self.control.staticSocket[ii],
      iconBg = self.control.staticSocketBackground[ii],
      name = self.control.staticSocketName[ii],
      descParent = self.control.staticSocketDescGroup[ii],
      descControl = self.control.staticSocketDesc[ii]
    }
    function slotSocket:setShow(bShow)
      self.icon:SetShow(bShow)
      self.iconBg:SetShow(bShow)
      self.name:SetShow(bShow)
      self.descParent:SetShow(bShow)
    end
    self.control.onlySocketListBG[ii]:SetShow(true)
    self.control.onlySocketBg:SetShow(true)
    local indexSocket = ii - 1
    SlotItem.new(slotSocket, "Socket_" .. ii, ii, Panel_Window_Socket, self.slotConfig)
    slotSocket:createChild()
    slotSocket.icon:addInputEvent("Mouse_RUp", "Socket_SlotRClick(" .. indexSocket .. ")")
    slotSocket.icon:addInputEvent("Mouse_LUp", "Socket_SlotLClick(" .. indexSocket .. ")")
    slotSocket.icon:addInputEvent("Mouse_PressMove", "Socket_SlotDrag(" .. indexSocket .. ")")
    slotSocket.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", true)")
    slotSocket.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. ii .. ", \"Socket_Insert\", false)")
    slotSocket.slotNo = ii
    Panel_Tooltip_Item_SetPosition(ii, slotSocket, "Socket_Insert")
    slotSocket.empty = true
    self.slotSocket:push_back(slotSocket)
  end
end
function socket:clearData(uiOnly)
  self.slotMain:clearItem()
  self.slotMain.empty = true
  self.slotMain.whereType = nil
  self.slotMain.slotNo = nil
  self.slotMain.icon:SetShow(false)
  for ii = 1, self.config.socketSlotCount do
    local socketBG_1 = self.control.onlySocketListBG[ii]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    socketBG_1:SetStartColor(UI_color.C_FFFFFFFF)
    socketBG_1:SetEndColor(UI_color.C_FF626262)
    self.control.onlySocketListBG[ii]:EraseAllEffect()
    self.slotSocket[ii]:setShow(false)
    self.slotSocket[ii].empty = true
  end
  local socketBG_0 = self.control.onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  socketBG_0:SetStartColor(UI_color.C_FFFFFFFF)
  socketBG_0:SetEndColor(UI_color.C_FF626262)
  if not uiOnly then
    getSocketInformation():clearData()
  end
  Panel_Tooltip_Item_hideTooltip()
end
function socket:updateSocket()
  if self.slotMain.empty then
    UI.ASSERT(false, "Must not be EMPTY!!!!")
    return
  end
  local invenItemWrapper = getInventoryItemByType(self.slotMain.whereType, self.slotMain.slotNo)
  local maxCount = invenItemWrapper:get():getUsableItemSocketCount()
  local classType = getSelfPlayer():getClassType()
  for ii = 1, maxCount do
    local socketSlot = self.slotSocket[ii]
    local itemStaticWrapper = invenItemWrapper:getPushedItem(ii - 1)
    socketSlot:setShow(true)
    self.control.onlySocketListBG[ii]:EraseAllEffect()
    if nil == itemStaticWrapper then
      local socketBG_0 = self.control.onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
      socketBG_0:SetStartColor(UI_color.C_FF626262)
      socketBG_0:SetEndColor(UI_color.C_FFFFFFFF)
      if ii == 1 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self.control.onlySocketListBG[2]:SetColor(UI_color.C_FF626262)
        self.control.onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 2 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self.control.onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self.control.onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
      elseif ii == 3 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self.control.onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self.control.onlySocketListBG[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
      end
      socketSlot:clearItem()
      socketSlot.empty = true
      socketSlot.name:SetText(self.text[1])
      PaGlobalFunc_Socket_DescSetting(socketSlot, self.desc)
      self.slotMain.icon:AddEffect("UI_ItemJewel", false, 0, 0)
    else
      local socketBG_0 = self.control.onlySocketBg:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
      socketBG_0:SetStartColor(UI_color.C_FF626262)
      socketBG_0:SetEndColor(UI_color.C_FFFFFFFF)
      if ii == 1 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        self.control.onlySocketListBG[2]:SetColor(UI_color.C_FF626262)
        self.control.onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
        self.control.onlySocketListBG[1]:AddEffect("UI_LimitExtract_TopLoop", true, -144, 41)
      elseif ii == 2 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self.control.onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        self.control.onlySocketListBG[3]:SetColor(UI_color.C_FF626262)
        self.control.onlySocketListBG[2]:AddEffect("UI_LimitExtract_MidLoop", true, -136, -21)
      elseif ii == 3 then
        local socketBG_1 = self.control.onlySocketListBG[1]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_1:SetStartColor(UI_color.C_FF626262)
        socketBG_1:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_2 = self.control.onlySocketListBG[2]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_2:SetStartColor(UI_color.C_FF626262)
        socketBG_2:SetEndColor(UI_color.C_FFFFFFFF)
        local socketBG_3 = self.control.onlySocketListBG[3]:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
        socketBG_3:SetStartColor(UI_color.C_FF626262)
        socketBG_3:SetEndColor(UI_color.C_FFFFFFFF)
        self.control.onlySocketListBG[3]:AddEffect("UI_LimitExtract_BotLoop", true, -139, -77)
      end
      socketSlot:setItemByStaticStatus(itemStaticWrapper, 0)
      socketSlot.empty = false
      local text = itemStaticWrapper:getName()
      socketSlot.name:SetText(text)
      local jewelSkillStaticWrapper = itemStaticWrapper:getSkillByIdx(classType)
      if nil ~= jewelSkillStaticWrapper then
        local buffCount = jewelSkillStaticWrapper:getBuffCount()
        local descTable = {}
        for buffIdx = 0, buffCount - 1 do
          local descCurrent = jewelSkillStaticWrapper:getBuffDescription(buffIdx)
          if "" == descCurrent then
            break
          end
          descTable[buffIdx + 1] = descCurrent
        end
        PaGlobalFunc_Socket_DescSetting(socketSlot, descTable)
      end
    end
  end
  for ii = maxCount + 1, self.config.socketSlotCount do
    local socketSlot = self.slotSocket[ii]
    socketSlot:setShow(false)
  end
end
function PaGlobalFunc_Socket_DescSetting(socketSlot, descTable)
  local buffDescCount = #descTable
  if 0 == buffDescCount then
    return
  end
  local descControl = socketSlot.descControl
  for i = 1, 3 do
    descControl[i]:SetText("")
    descControl[i]:SetShow(false)
  end
  for i = 1, buffDescCount do
    if 1 == buffDescCount then
      descControl[1]:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      descControl[1]:SetLineCount(3)
    else
      descControl[i]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    end
    descControl[i]:SetText(descTable[i])
    descControl[i]:SetShow(true)
    descControl[i]:SetSize(descControl[i]:GetSizeX(), descControl[i]:GetTextSizeY())
    if descControl[i]:IsLimitText() then
      tempTable[i] = {}
      tempTable[i].control = descControl[i]
      tempTable[i].desc = descControl[i]:GetText()
      descControl[i]:SetIgnore(false)
      descControl[i]:addInputEvent("Mouse_On", "PaGlobalFunc_Socket_TooltipLimitedText(" .. i .. ",true)")
      descControl[i]:addInputEvent("Mouse_Out", "PaGlobalFunc_Socket_TooltipLimitedText(" .. i .. ",false)")
    else
      descControl[i]:SetIgnore(true)
    end
  end
  descControl[1]:SetSpanSize(descControl[1]:GetSpanSize().x, 0 - 9 * (buffDescCount - 1))
  descControl[2]:SetSpanSize(descControl[2]:GetSpanSize().x, 18 - 9 * (buffDescCount - 1))
  descControl[3]:SetSpanSize(descControl[2]:GetSpanSize().x, 36 - 9 * (buffDescCount - 1))
end
function PaGlobalFunc_Socket_TooltipLimitedText(index, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if 0 == #tempTable then
    return
  end
  TooltipSimple_Show(tempTable[index].control, "", tempTable[index].desc)
end
local function Socket_Pop_Confirm()
  audioPostEvent_SystemUi(5, 7)
  Socket_PopJewelFromSocket(socket._indexSocket, CppEnums.ItemWhereType.eCount, CppEnums.TInventorySlotNoUndefined)
end
local function Socket_Push_Confirm()
  local self = socket
  local socketInfo = getSocketInformation()
  local index = socketInfo._indexPush
  local socketSlot = self.slotSocket[index + 1]
  if false == isItemLock then
    socketSlot.iconBg:AddEffect("UI_ItemJewel02", false, 0, 0)
    socketSlot.descParent:AddEffect("UI_ItemJewel03", false, 0, 0)
    socketSlot.iconBg:AddEffect("fUI_ItemJewel01", false, -1, -1)
    self.slotMain.icon:AddEffect("fUI_ItemJewel02", false, -1, -1)
    self.slotMain.icon:AddEffect("UI_LimitMetastasis_Box01", false, -1, -1)
    socketSlot.icon:AddEffect("UI_LimitMetastasis_Box02", false, -1, -1)
  end
  Socket_ConfirmPushJewel(true)
  if false == isItemLock then
    if index == 0 then
      audioPostEvent_SystemUi(5, 6)
      self.slotMain.icon:AddEffect("UI_LimitTransition_TopImpact", false, 60, -22)
      self.slotMain.icon:AddEffect("fUI_Transition_Line01A", false, -1, -1)
    elseif index == 1 then
      audioPostEvent_SystemUi(5, 6)
      self.slotMain.icon:AddEffect("UI_LimitTransition_MidImpact", false, 60, -22)
      self.slotMain.icon:AddEffect("fUI_Transition_Line01B", false, -1, -1)
    elseif index == 2 then
      audioPostEvent_SystemUi(5, 6)
      self.slotMain.icon:AddEffect("UI_LimitTransition_BotImpact", false, 60, -22)
      self.slotMain.icon:AddEffect("fUI_Transition_Line01C", false, -1, -1)
    end
  end
  DragManager:clearInfo()
end
local function Socket_OverWrite_Confirm()
  local self = socket
  local rv = Socket_OverWriteToSocket(self.slotMain.whereType, self.slotMain.slot, self._indexSocket)
  if 0 ~= rv then
    self:clearData()
    Inventory_SetFunctor(Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
  end
end
local Socket_Deny = function()
  Socket_ConfirmPushJewel(false)
end
local Socket_InvenFiler_EquipItem = function(slotNo, itemWrapper)
  if nil == itemWrapper then
    return true
  end
  local itemSSW = itemWrapper:getStaticStatus()
  if true == itemSSW:get():doHaveSocket() then
    if 22 == itemSSW:getEquipType() and false == itemWrapper:get():isVested() then
      return true
    else
      return false
    end
  end
  return true
end
local Socket_InvenFiler_Jewel = function(slotNo, itemWrapper, whereType)
  if nil == itemWrapper then
    return true
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  local isAble = getSocketInformation():isFilterJewelEquipType(whereType, slotNo)
  return not isAble
end
function SocketItem_FromItemWrapper()
  local self = socket
  if nil == self.slotMain.slotNo then
    return nil
  end
  return (getInventoryItemByType(self.slotMain.whereType, self.slotMain.slotNo))
end
function Socket_SlotRClick(indexSocket)
  local self = socket
  if true == self.slotSocket[indexSocket + 1].empty then
    return
  end
  socket._indexSocket = indexSocket
  local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_TITLE")
  local contentString = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_SOCKET_REMOVE_MESSAGE", "socketNum", string.format("%d", indexSocket + 1))
  local messageboxData = {
    title = titleString,
    content = contentString,
    functionYes = Socket_Pop_Confirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function Socket_EquipSlotRClick()
  getSocketInformation():popEquip()
  socket:clearData()
  audioPostEvent_SystemUi(0, 16)
  Inventory_SetFunctor(Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
end
function Socket_SlotLClick(indexSocket)
  if DragManager.dragStartPanel ~= Panel_Window_Inventory then
    return
  end
  local self = socket
  local whereType = DragManager.dragWhereTypeInfo
  local slotNo = DragManager.dragSlotInfo
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    UI.ASSERT(false, "Item Is Null?!?!?!")
    return
  end
  local index = indexSocket + 1
  if true == self.slotSocket[index].empty then
    local success = 0 == Socket_SetItemHaveSocket(whereType, slotNo)
    if not success then
      return
    end
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_TITLE")
    local contentString = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_MESSAGE", "socketNum", string.format("%d", index), "itemName", itemWrapper:getStaticStatus():getName())
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionYes = Socket_Push_Confirm,
      functionCancel = Socket_Deny,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
    local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_SOCKET_INSERT_ALREADYCRYSTAL")
    local messageboxData = {
      title = titleString,
      content = contentString,
      functionApply = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
  DragManager:clearInfo()
end
function Panel_Socket_InteractortionFromInventory(slotNo, itemWrapper, count_s64, inventoryType)
  local self = socket
  local socketInfo = getSocketInformation()
  local success = 0 == Socket_SetItemHaveSocket(inventoryType, slotNo)
  if not success then
    self:clearData()
    Inventory_SetFunctor(Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
    return
  end
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  UI.ASSERT(nil ~= itemWrapper, "Item Is Null?!?!?!")
  if socketInfo._setEquipItem then
    self.slotMain.empty = false
    self.slotMain.whereType = inventoryType
    self.slotMain.slotNo = slotNo
    self.slotMain:setItem(itemWrapper)
    self.slotMain.icon:SetShow(true)
    self.slotMain.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', true)")
    self.slotMain.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralNormal(" .. slotNo .. ", 'SocketItem', false)")
    Panel_Tooltip_Item_SetPosition(slotNo, self.slotMain, "SocketItem")
    self:updateSocket()
    audioPostEvent_SystemUi(0, 16)
    Inventory_SetFunctor(Socket_InvenFiler_Jewel, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
  else
    local rv = socketInfo:checkPushJewelToEmptySoket(inventoryType, slotNo)
    isItemLock = ToClient_Inventory_CheckItemLock(self.slotMain.slotNo)
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
function Socket_Result()
  if Panel_Window_Socket:GetShow() then
    socket:updateSocket()
  else
    PaGlobal_ExtractionCrystal:result()
  end
end
local function Socket_fadeInSCR_Down(panel)
  local FadeMaskAni = panel:addTextureUVAnimation(0, 0.28, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  FadeMaskAni:SetTextureType(UI_TT.PAUI_TEXTURE_TYPE_MASK)
  FadeMaskAni:SetStartUV(0, 0.6, 0)
  FadeMaskAni:SetEndUV(0, 0.1, 0)
  FadeMaskAni:SetStartUV(1, 0.6, 1)
  FadeMaskAni:SetEndUV(1, 0.1, 1)
  FadeMaskAni:SetStartUV(0, 1, 2)
  FadeMaskAni:SetEndUV(0, 0.4, 2)
  FadeMaskAni:SetStartUV(1, 1, 3)
  FadeMaskAni:SetEndUV(0, 0.4, 3)
  panel:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
  local aniInfo3 = panel:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  for key, value in pairs(self.control.onlySocketListBG) do
    local socketBG_1 = value:addColorAnimation(0, 0.5, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    socketBG_1:SetStartColor(UI_color.C_00626262)
    socketBG_1:SetEndColor(UI_color.C_FF626262)
  end
  local aniInfo8 = panel:addColorAnimation(0.12, 0.23, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo8:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo8:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo8:SetStartIntensity(3)
  aniInfo8:SetEndIntensity(1)
end
function SocketShowAni()
  local aniInfo1 = Panel_Window_Socket:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.13)
  aniInfo1.AxisX = Panel_Window_Socket:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Socket:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_Socket:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.13)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Socket:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Socket:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
  audioPostEvent_SystemUi(1, 0)
end
function SocketHideAni()
  local socketHide = UIAni.AlphaAnimation(0, Panel_Window_Socket, 0, 0.2)
  socketHide:SetHideAtEnd(true)
  audioPostEvent_SystemUi(1, 1)
end
function Socket_WindowClose()
  Inventory_SetFunctor(nil, nil, nil, nil)
  Panel_Window_Socket:SetShow(false, false)
  InventoryWindow_Close()
  if not _ContentsGroup_RenewUI then
    Equipment_PosLoadMemory()
    Panel_Equipment:SetShow(false, false)
  end
  ClothInventory_Close()
  ToClient_BlackspiritEnchantClose()
end
function Socket_Window_Show()
  if Panel_Window_Enchant:GetShow() then
    Panel_Window_Enchant:SetShow(false, false)
  elseif Panel_SkillAwaken:GetShow() then
    Panel_SkillAwaken:SetShow(false, false)
  end
  Panel_Window_Socket:SetShow(true, true)
  Inventory_SetFunctor(Socket_InvenFiler_EquipItem, Panel_Socket_InteractortionFromInventory, Socket_WindowClose, nil)
  socket:clearData()
  InventoryWindow_Show()
  if not _ContentsGroup_RenewUI then
    Equipment_PosSaveMemory()
    Panel_Equipment:SetShow(true, true)
    Panel_Equipment:SetPosX(10)
    Panel_Equipment:SetPosY(Panel_Window_Inventory:GetPosY())
  end
  SkillAwaken_Close()
  Panel_Join_Close()
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    FGlobal_LifeRanking_Close()
  else
    PaGlobal_LifeRanking_Close_All()
  end
  Socket_OnScreenEvent()
end
function Socket_ShowToggle()
  if Panel_Window_Socket:GetShow() then
    Socket_WindowClose()
  else
    Socket_Window_Show()
    InventoryWindow_Show()
  end
end
function Socket_OnScreenEvent()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_Window_Socket:SetPosX(sizeX / 2 - Panel_Window_Socket:GetSizeX() / 2)
  Panel_Window_Socket:SetPosY(Panel_Window_Inventory:GetPosY())
end
function socket:registMessageHandler()
  registerEvent("EventSocketResult", "Socket_Result")
  registerEvent("onScreenResize", "Socket_OnScreenEvent")
end
function Socket_GetSlotNo()
  return socket.slotMain.slotNo
end
socket:init()
socket:createControl()
socket:registMessageHandler()
