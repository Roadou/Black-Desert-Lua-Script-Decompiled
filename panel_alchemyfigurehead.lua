Panel_AlchemyFigureHead:SetShow(false)
local AlchemyFigureHead = {
  control = {
    txt_Title = UI.getChildControl(Panel_AlchemyFigureHead, "StaticText_Title"),
    contentBG = UI.getChildControl(Panel_AlchemyFigureHead, "Static_ContentTypeBG"),
    contentEffect = UI.getChildControl(Panel_AlchemyFigureHead, "Static_ContentTypeEffect"),
    guideString = UI.getChildControl(Panel_AlchemyFigureHead, "Static_GuideText"),
    descBg = UI.getChildControl(Panel_AlchemyFigureHead, "Static_DescBg"),
    desc = UI.getChildControl(Panel_AlchemyFigureHead, "StaticText_Desc"),
    btn_Doit = UI.getChildControl(Panel_AlchemyFigureHead, "Button_Doit"),
    Slot_1 = UI.getChildControl(Panel_AlchemyFigureHead, "Static_Slot_1"),
    Slot_2 = UI.getChildControl(Panel_AlchemyFigureHead, "Static_Slot_2")
  },
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true
  },
  Stuff_slot = {},
  FigureHead_slot = {},
  selectedTabIdx = 2,
  selectedFigureHeadType = 0,
  selectedFigureHeadItemKey = nil,
  fromWhereType = -1,
  fromSlotNo = -1,
  fromCount = -1,
  toWhereType = -1,
  toSlotNo = -1,
  isPushDoit = false,
  startEffectPlay = false,
  contentEffectPlay = false,
  slotEffectPlay = false,
  effectEnd = false,
  resultMsg = {}
}
function AlchemyFigureHead:PanelResize_ByFontSize()
  local totemDesc = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYFISHPRINT_DESC")
  AlchemyFigureHead.control.guideString:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  AlchemyFigureHead.control.guideString:SetText(AlchemyFigureHead.control.guideString:GetText())
  if 30 < AlchemyFigureHead.control.guideString:GetTextSizeY() then
    AlchemyFigureHead.control.guideString:SetSize(AlchemyFigureHead.control.guideString:GetSizeX(), AlchemyFigureHead.control.guideString:GetTextSizeY() + 10)
  else
    AlchemyFigureHead.control.guideString:SetSize(AlchemyFigureHead.control.guideString:GetSizeX(), 30)
  end
  AlchemyFigureHead.control.desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  AlchemyFigureHead.control.desc:SetText(totemDesc)
end
AlchemyFigureHead:PanelResize_ByFontSize()
local panelSizeY = Panel_AlchemyFigureHead:GetSizeY()
local bgSizeY = AlchemyFigureHead.control.descBg:GetSizeY()
local textSizeY = AlchemyFigureHead.control.desc:GetTextSizeY()
if textSizeY > 70 then
  Panel_AlchemyFigureHead:SetSize(Panel_AlchemyFigureHead:GetSizeX(), panelSizeY + textSizeY - 82)
  AlchemyFigureHead.control.descBg:SetSize(AlchemyFigureHead.control.descBg:GetSizeX(), bgSizeY + textSizeY - 82)
else
  Panel_AlchemyFigureHead:SetSize(Panel_AlchemyFigureHead:GetSizeX(), panelSizeY)
  AlchemyFigureHead.control.descBg:SetSize(AlchemyFigureHead.control.descBg:GetSizeX(), bgSizeY)
end
AlchemyFigureHead.control.btn_Doit:ComputePos()
local AlchemyFigureHeadTab = {Upgrade = 2}
local AlchemyFigureHeadTabTexture = {
  [AlchemyFigureHeadTab.Upgrade] = {
    bg = "New_UI_Common_forLua/Window/AlchemyFigureHead/AlchemyFigureHead_BG.dds",
    effect = "New_UI_Common_forLua/Window/AlchemyStone/AlchemyStone_Upgrade_Effect.dds"
  }
}
function AlchemyFigureHead:Init()
  SlotItem.new(self.Stuff_slot, "AlchemyFigureHead_Stuff", 0, self.control.Slot_1, self.slotConfig)
  self.Stuff_slot:createChild()
  self.Stuff_slot.Empty = true
  self.Stuff_slot.icon:addInputEvent("Mouse_RUp", "HandleClicked_AlchemyFigureHead_UnSetSlot(" .. 1 .. ")")
  SlotItem.new(self.FigureHead_slot, "AlchemyFigureHead_FigureHead", 0, self.control.Slot_2, self.slotConfig)
  self.FigureHead_slot:createChild()
  self.FigureHead_slot.Empty = true
  self.FigureHead_slot.icon:addInputEvent("Mouse_RUp", "HandleClicked_AlchemyFigureHead_UnSetSlot(" .. 0 .. ")")
  self.control.contentBG:ChangeTextureInfoName(AlchemyFigureHeadTabTexture[2].bg)
  self.control.contentEffect:SetShow(false)
  self.control.btn_Close = UI.getChildControl(self.control.txt_Title, "Button_Win_Close")
  self.control.btn_Question = UI.getChildControl(self.control.txt_Title, "Button_Question")
  self.control.btn_Question:SetShow(false)
end
function AlchemyFigureHead:registEventHandler()
  self.control.btn_Doit:addInputEvent("Mouse_LUp", "HandleClicked_AlchemyFigureHead_Doit()")
  self.control.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_AlchemyFigureHead_Close()")
end
function AlchemyFigureHead:registMessageHandler()
  registerEvent("onScreenResize", "AlchemyFigureHead_onScreenResize")
  registerEvent("FromClient_ItemUpgrade", "FromClient_FigureHeadUpgrade")
  registerEvent("FromClient_StoneChange", "FromClient_FigureHeadChange")
  registerEvent("FromClient_StoneChangeFailedByDown", "FromClient_FigureHeadChangeFailedByDown")
  registerEvent("FromClient_AlchemyEvolve", "FromClient_FigureHeadEvolve")
  Panel_AlchemyFigureHead:RegisterUpdateFunc("Panel_AlchemyFigureHead_updateTime")
end
function AlchemyFigureHead:ClearData(isOpenStep)
  if true == isOpenStep then
    self.resultMsg = {}
  end
  self.toWhereType = -1
  self.toSlotNo = -1
  self.fromWhereType = -1
  self.fromSlotNo = -1
  self.fromCount = -1
  self.selectedFigureHeadType = -1
  self.selectedFigureHeadItemKey = nil
  self.isPushDoit = false
  self.startEffectPlay = false
  self.contentEffectPlay = false
  self.slotEffectPlay = false
  self.effectEnd = false
  self.control.btn_Doit:SetMonoTone(not self.isPushDoit)
  self.control.btn_Doit:SetEnable(self.isPushDoit)
  self.Stuff_slot:clearItem()
  self.FigureHead_slot:clearItem()
  self.Stuff_slot.Empty = true
  self.FigureHead_slot.Empty = true
  AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_On", "")
  AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_On", "")
  self.control.contentEffect:SetShow(false)
  local guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_UPGRADE")
  local guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYFISHPRINT_SELECT", "guideKeyword", guideKeyword)
  self.control.guideString:SetText(guideText)
  self.control.btn_Doit:SetText(guideKeyword)
end
function HandleClicked_AlchemyFigureHeadTab(tabIdx)
  AlchemyFigureHead.toWhereType = -1
  AlchemyFigureHead.toSlotNo = -1
  AlchemyFigureHead.fromWhereType = -1
  AlchemyFigureHead.fromSlotNo = -1
  AlchemyFigureHead.fromCount = -1
  AlchemyFigureHead.selectedFigureHeadType = -1
  AlchemyFigureHead.selectedFigureHeadItemKey = nil
  AlchemyFigureHead.FigureHead_slot:clearItem()
  AlchemyFigureHead.Stuff_slot:clearItem()
  AlchemyFigureHead.FigureHead_slot.Empty = true
  AlchemyFigureHead.Stuff_slot.Empty = true
  AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_On", "")
  AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_Out", "")
  AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_On", "")
  AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_Out", "")
  AlchemyFigureHead.control.contentBG:ChangeTextureInfoName(AlchemyFigureHeadTabTexture[tabIdx].bg)
  AlchemyFigureHead.selectedTabIdx = tabIdx
  AlchemyFigureHead.isPushDoit = false
  AlchemyFigureHead.Stuff_slot.icon:EraseAllEffect()
  AlchemyFigureHead.control.contentEffect:EraseAllEffect()
  AlchemyFigureHead.FigureHead_slot.icon:EraseAllEffect()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
  local guideKeyword = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_UPGRADE")
  local guideText = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYFISHPRINT_SELECT", "guideKeyword", guideKeyword)
  AlchemyFigureHead.control.guideString:SetText(guideText)
  AlchemyFigureHead.control.btn_Doit:SetText(guideKeyword)
end
function HandleClicked_AlchemyFigureHead_Doit()
  local function doUpgrade()
    AlchemyFigureHead.isPushDoit = true
  end
  local itemWrapper = getInventoryItemByType(AlchemyFigureHead.toWhereType, AlchemyFigureHead.toSlotNo)
  local itemSSW = itemWrapper:getStaticStatus()
  local itemGrade = itemSSW:getGradeType()
  local itemContentsParam2 = itemSSW:get()._contentsEventParam2
  local msgTitle = PAGetString(Defines.StringSheet_GAME, "LUA_ALERT_DEFAULT_TITLE")
  local msgContent = ""
  if AlchemyFigureHead.selectedTabIdx == AlchemyFigureHeadTab.Upgrade then
    if 2 == itemContentsParam2 or 3 == itemContentsParam2 then
      msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYFISHPRINT_MSGBOX_CONTENT1")
    elseif 4 == itemContentsParam2 then
      msgContent = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYFISHPRINT_MSGBOX_CONTENT2")
    else
      AlchemyFigureHead.isPushDoit = true
    end
    if "" ~= msgContent then
      local messageBoxData = {
        title = msgTitle,
        content = msgContent,
        functionYes = doUpgrade,
        functionNo = MessageBox_Empty_function,
        priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
      }
      MessageBox.showMessageBox(messageBoxData, "middle")
    end
  else
    AlchemyFigureHead.isPushDoit = true
  end
  AlchemyFigureHead.control.contentEffect:SetShow(true)
  AlchemyFigureHead.control.btn_Doit:SetMonoTone(AlchemyFigureHead.isPushDoit)
  AlchemyFigureHead.control.btn_Doit:SetEnable(not AlchemyFigureHead.isPushDoit)
  audioPostEvent_SystemUi(1, 43)
end
function HandleClicked_AlchemyFigureHead_Close()
  Panel_AlchemyFigureHead:CloseUISubApp()
  Panel_AlchemyFigureHead:SetShow(false)
  AlchemyFigureHead.toWhereType = -1
  AlchemyFigureHead.toSlotNo = -1
  AlchemyFigureHead.fromWhereType = -1
  AlchemyFigureHead.fromSlotNo = -1
  AlchemyFigureHead.fromCount = -1
  AlchemyFigureHead.selectedFigureHeadType = -1
  AlchemyFigureHead.selectedFigureHeadItemKey = nil
  AlchemyFigureHead.isPushDoit = false
  if Panel_Window_Inventory:GetShow() then
    Inventory_SetFunctor(nil, nil, nil, nil)
    Equipment_SetShow(true)
  end
end
function HandleClicked_AlchemyFigureHead_UnSetSlot(slotType)
  if 0 == slotType then
    if false == AlchemyFigureHead.FigureHead_slot.Empty then
      AlchemyFigureHead.FigureHead_slot:clearItem()
      AlchemyFigureHead.FigureHead_slot.Empty = true
      AlchemyFigureHead.Stuff_slot:clearItem()
      AlchemyFigureHead.Stuff_slot.Empty = true
      AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_On", "")
      AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_Out", "")
      AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_On", "")
      AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_Out", "")
      AlchemyFigureHead.control.btn_Doit:SetMonoTone(true)
      AlchemyFigureHead.control.btn_Doit:SetEnable(false)
      Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
    end
  elseif false == AlchemyFigureHead.Stuff_slot.Empty then
    AlchemyFigureHead.Stuff_slot:clearItem()
    AlchemyFigureHead.Stuff_slot.Empty = true
    AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_On", "")
    AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_Out", "")
    AlchemyFigureHead.control.btn_Doit:SetMonoTone(true)
    AlchemyFigureHead.control.btn_Doit:SetEnable(false)
    Inventory_SetFunctor(AlchemyFigureHead_StuffFilter, AlchemyFigureHead_StuffRfunction, nil, nil)
  end
end
function AlchemyFigureHead_ItemToolTip(isShow, slotType)
  if true == isShow then
    local control, itemWrapper
    if 0 == slotType then
      control = AlchemyFigureHead.FigureHead_slot.icon
      if -1 ~= AlchemyFigureHead.toWhereType then
        itemWrapper = getInventoryItemByType(AlchemyFigureHead.toWhereType, AlchemyFigureHead.toSlotNo)
        Panel_Tooltip_Item_Show(itemWrapper, control, false, true, nil, nil, nil)
      else
        return
      end
    else
      control = AlchemyFigureHead.Stuff_slot.icon
      if -1 ~= AlchemyFigureHead.fromWhereType then
        itemWrapper = getInventoryItemByType(AlchemyFigureHead.fromWhereType, AlchemyFigureHead.fromSlotNo)
        Panel_Tooltip_Item_Show(itemWrapper, control, false, true, nil, nil, nil)
      else
        return
      end
    end
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function AlchemyFigureHead_FigureHeadFilter(slotNo, itemWrapper, count, inventoryType)
  local returnValue = true
  if nil == itemWrapper:getStaticStatus() then
    return returnValue
  end
  if 37 == itemWrapper:getStaticStatus():get():getContentsEventType() then
    returnValue = false
  end
  return returnValue
end
function AlchemyFigureHead_FigureHeadRfunction(slotNo, itemWrapper, count, inventoryType)
  AlchemyFigureHead.toWhereType = inventoryType
  AlchemyFigureHead.toSlotNo = slotNo
  AlchemyFigureHead.selectedFigureHeadType = itemWrapper:getStaticStatus():get()._contentsEventParam1
  AlchemyFigureHead.selectedFigureHeadItemKey = itemWrapper:get():getKey()
  AlchemyFigureHead.FigureHead_slot:setItem(itemWrapper)
  AlchemyFigureHead.FigureHead_slot.Empty = false
  AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_On", "AlchemyFigureHead_ItemToolTip( true, " .. 0 .. " )")
  AlchemyFigureHead.FigureHead_slot.icon:addInputEvent("Mouse_Out", "AlchemyFigureHead_ItemToolTip( false )")
  Inventory_SetFunctor(AlchemyFigureHead_StuffFilter, AlchemyFigureHead_StuffRfunction, nil, nil)
  local guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_SELECT_UPGRADE")
  AlchemyFigureHead.control.guideString:SetText(guideText)
end
function AlchemyFigureHead_StuffFilter(slotNo, itemWrapper, count, inventoryType)
  local returnValue = true
  local staticStatus = itemWrapper:getStaticStatus()
  if nil == staticStatus or -1 == AlchemyFigureHead.selectedFigureHeadType then
    return returnValue
  end
  if AlchemyFigureHeadTab.Upgrade == AlchemyFigureHead.selectedTabIdx then
    local itemKey = itemWrapper:get():getKey()
    if staticStatus:isAlchemyUpgradeMaterial(AlchemyFigureHead.selectedFigureHeadItemKey) then
      returnValue = false
    end
  end
  return returnValue
end
function AlchemyFigureHead_StuffRfunction(slotNo, itemWrapper, count, inventoryType)
  AlchemyFigureHead.fromWhereType = inventoryType
  AlchemyFigureHead.fromSlotNo = slotNo
  AlchemyFigureHead.fromCount = count
  local function setStuffFunc(itemCount)
    AlchemyFigureHead.fromCount = itemCount
    local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
    local itemSSW = itemWrapper:getStaticStatus()
    AlchemyFigureHead.Stuff_slot:setItemByStaticStatus(itemSSW, AlchemyFigureHead.fromCount, nil, nil, nil)
    AlchemyFigureHead.Stuff_slot.Empty = false
    AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_On", "AlchemyFigureHead_ItemToolTip( true, " .. 1 .. " )")
    AlchemyFigureHead.Stuff_slot.icon:addInputEvent("Mouse_Out", "AlchemyFigureHead_ItemToolTip( false )")
    AlchemyFigureHead.control.btn_Doit:SetMonoTone(AlchemyFigureHead.isPushDoit)
    AlchemyFigureHead.control.btn_Doit:SetEnable(not AlchemyFigureHead.isPushDoit)
    guideText = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DOIT_UPGRADE")
    AlchemyFigureHead.control.guideString:SetText(guideText)
  end
  if count > toInt64(0, 1) then
    Panel_NumberPad_Show(true, count, nil, setStuffFunc, false, nil, nil)
  else
    setStuffFunc(toInt64(0, 1))
  end
end
function FGlobal_AlchemyFigureHead_Open()
  local isAlchemyFigureHeadEnble = ToClient_IsContentsGroupOpen("44")
  if not isAlchemyFigureHeadEnble then
    return
  end
  if Panel_AlchemyStone:GetShow() then
    FGlobal_AlchemyStone_Close()
  end
  if not _ContentsGroup_RenewUI_Manufacture and Panel_Manufacture:GetShow() then
    Manufacture_Close()
  end
  if Panel_DyePalette:GetShow() then
    FGlobal_DyePalette_Close()
  end
  FGlobal_SetInventoryDragNoUse(Panel_AlchemyFigureHead)
  Panel_AlchemyFigureHead:SetShow(true)
  AlchemyFigureHead:ClearData(true)
  HandleClicked_AlchemyFigureHeadTab(2)
  if Panel_Window_Inventory:IsUISubApp() then
    Panel_AlchemyFigureHead:OpenUISubApp()
  end
  if false == _ContentsGroup_RenewUI and Panel_Equipment:GetShow() then
    EquipmentWindow_Close()
  end
  ClothInventory_Close()
  InventoryWindow_Show()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
end
function FGlobal_AlchemyFigureHead_Close()
  HandleClicked_AlchemyFigureHead_Close()
  Panel_AlchemyFigureHead:CloseUISubApp()
end
local elapsTime = 0
function Panel_AlchemyFigureHead_updateTime(deltaTime)
  if AlchemyFigureHead.isPushDoit then
    elapsTime = elapsTime + deltaTime
    if elapsTime > 0 and false == AlchemyFigureHead.startEffectPlay then
      AlchemyFigureHead.Stuff_slot.icon:EraseAllEffect()
      AlchemyFigureHead.Stuff_slot.icon:AddEffect("fUI_Alchemy_UpgradeStart01", false)
      AlchemyFigureHead.startEffectPlay = true
      audioPostEvent_SystemUi(13, 17)
    end
    if elapsTime > 1 and false == AlchemyFigureHead.contentEffectPlay then
      AlchemyFigureHead.Stuff_slot:clearItem()
      AlchemyFigureHead.Stuff_slot.Empty = true
      AlchemyFigureHead.control.contentEffect:EraseAllEffect()
      AlchemyFigureHead.control.contentEffect:AddEffect("fUI_Alchemy_Stone_Upgrade01", false)
      AlchemyFigureHead.contentEffectPlay = true
    end
    if elapsTime > 2.5 and false == AlchemyFigureHead.slotEffectPlay then
      AlchemyFigureHead.FigureHead_slot.icon:EraseAllEffect()
      AlchemyFigureHead.FigureHead_slot.icon:AddEffect("fUI_Alchemy_Stone_Upgrade02", false)
      AlchemyFigureHead.slotEffectPlay = true
    end
    if elapsTime > 3 and false == AlchemyFigureHead.effectEnd then
      alchemyEvolve(AlchemyFigureHead.fromWhereType, AlchemyFigureHead.fromSlotNo, AlchemyFigureHead.toWhereType, AlchemyFigureHead.toSlotNo)
      AlchemyFigureHead.effectEnd = true
      elapsTime = 0
      AlchemyFigureHead:ClearData()
      Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
    end
  else
    elapsTime = 0
  end
end
function AlchemyFigureHead_onScreenResize()
  Panel_AlchemyFigureHead:ComputePos()
end
function FromClient_FigureHeadUpgrade(itemwhereType, slotNo, exp)
  if not Panel_AlchemyFigureHead:GetShow() then
    return
  end
  local itemWrapper = getInventoryItemByType(itemwhereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemName = itemWrapper:getStaticStatus():getName()
  local mainMsg = itemName .. PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DONE_UPGRADE")
  AlchemyFigureHead.resultMsg = {
    main = mainMsg,
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_EXP") .. string.format("%.2f", itemWrapper:getExperience() / 10000) .. "%",
    addMsg = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
  }
  Proc_ShowMessage_Ack_For_RewardSelect(AlchemyFigureHead.resultMsg, 2.5, 33)
  AlchemyFigureHead.resultMsg = {}
  AlchemyFigureHead:ClearData()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
end
function FromClient_FigureHeadChange(whereType, slotNo)
  if not Panel_AlchemyFigureHead:GetShow() then
    return
  end
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemName = itemWrapper:getStaticStatus():getName()
  msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_DONE"),
    sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_DONE2", "itemName", itemName),
    addMsg = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 2.5, 33)
  AlchemyFigureHead:ClearData()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
end
function FromClient_FigureHeadChangeFailedByDown(whereType, slotNo)
  if not Panel_AlchemyFigureHead:GetShow() then
    return
  end
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return
  end
  local itemName = itemWrapper:getStaticStatus():getName()
  msg = {
    main = itemName .. PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_DONE_UPGRADE"),
    sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_FAIL2", "itemName", itemName),
    addMsg = "Icon/" .. itemWrapper:getStaticStatus():getIconPath()
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 2.5, 33)
  AlchemyFigureHead:ClearData()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
end
function FromClient_FigureHeadEvolve(evolveType)
  if not Panel_AlchemyFigureHead:GetShow() then
    return
  end
  if 1 == evolveType then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ALCHEMYSTONE_MSG_LOST"))
  end
  AlchemyFigureHead:ClearData()
  Inventory_SetFunctor(AlchemyFigureHead_FigureHeadFilter, AlchemyFigureHead_FigureHeadRfunction, nil, nil)
end
AlchemyFigureHead:Init()
AlchemyFigureHead:registEventHandler()
AlchemyFigureHead:registMessageHandler()
