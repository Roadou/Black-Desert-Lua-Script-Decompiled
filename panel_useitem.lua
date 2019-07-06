local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local const_64 = Defines.s64_const
Panel_UseItem:setGlassBackground(true)
Panel_UseItem:ActiveMouseEventEffect(true)
local _title = UI.getChildControl(Panel_UseItem, "Static_Text_Title")
local _frame = UI.getChildControl(Panel_UseItem, "Frame_UseItem")
local _frameContent = UI.getChildControl(_frame, "Frame_1_Content")
local _frameScroll = UI.getChildControl(_frame, "Frame_1_VerticalScroll")
local _backGround = UI.getChildControl(Panel_UseItem, "Static_Background")
local _descBG = UI.getChildControl(Panel_UseItem, "Static_DescBG")
local _desc = UI.getChildControl(_frameContent, "StaticText_Desc")
local _btn_Yes = UI.getChildControl(Panel_UseItem, "Button_Yes")
local _btn_No = UI.getChildControl(Panel_UseItem, "Button_No")
local _btn_Close = UI.getChildControl(Panel_UseItem, "Button_Close")
local _copyItemSlot = UI.getChildControl(Panel_UseItem, "Static_C_ItemSlot")
_copyItemSlot:SetShow(false)
local popupItem = {
  slotInfo = {},
  slotInfoBG = {},
  slotInfoForBuff = {},
  slotInfoForBuffBG = {},
  slotIndex = 0,
  selectWhereType = nil,
  selectSlotNo = nil,
  selectEquipNo = 0,
  totalRowCount = 0
}
local slotConfig = {
  createIcon = true,
  createBorder = false,
  createCount = true,
  createExpiration = false,
  createCash = true
}
local maxPopupSlotCount = 10
local baseSlotLineCount = 5
local descBG_sizeY = 0
global_PopupItemItemWrapper = nil
function getPopupIteWrapper()
  return global_PopupItemItemWrapper
end
function Panel_UseItem_Initialize()
  descBG_sizeY = 0
  for idx = 1, maxPopupSlotCount do
    popupItem.slotInfoBG[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_UseItem, "Static_EmptyItemSlotBG_" .. idx)
    CopyBaseProperty(_copyItemSlot, popupItem.slotInfoBG[idx])
    local slot = {}
    SlotItem.new(slot, "PopupUserItem_" .. idx, idx, Panel_UseItem, slotConfig)
    slot:createChild()
    popupItem.slotInfo[idx] = slot
    popupItem.slotInfoForBuffBG[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_UseItem, "Static_EmptyBuffSlotBG_" .. idx)
    CopyBaseProperty(_copyItemSlot, popupItem.slotInfoForBuffBG[idx])
    popupItem.slotInfoForBuff[idx] = UI.createControl(UI_PUCT.PA_UI_CONTROL_STATIC, Panel_UseItem, "Static_EmptyBuffSlot_" .. idx)
    CopyBaseProperty(_copyItemSlot, popupItem.slotInfoForBuff[idx])
  end
  Panel_UseItem_AddEventContol()
end
local function resetUIcontrol()
  for idx = 1, maxPopupSlotCount do
    popupItem.slotInfoBG[idx]:SetShow(false)
    popupItem.slotInfo[idx].icon:SetShow(false)
    popupItem.slotInfoForBuff[idx]:SetShow(false)
    popupItem.slotInfoForBuffBG[idx]:SetShow(false)
  end
  popupItem.totalRowCount = 0
end
local GetBottomPos = function(control)
  if nil == control then
    return
  end
  return control:GetPosY() + control:GetSizeY()
end
function Panel_UseItem_RepositionSlot(slotCount)
  local remain = slotCount % baseSlotLineCount
  local row = math.floor(slotCount / baseSlotLineCount)
  local slotIndexCount = row * baseSlotLineCount + remain
  if 0 == slotIndexCount then
    popupItem.slotIndex = 0
    return
  end
  popupItem.totalRowCount = row + 1
  local startX = _desc:GetPosX() + 5
  local startY = _desc:GetPosY() + _desc:GetSizeY() + 30
  local slotSizeX = _copyItemSlot:GetSizeX()
  local slotSizeY = _copyItemSlot:GetSizeY()
  local UIindex = 0
  local UIPosX = 0
  local UIPosY = 0
  for idy = 0, row do
    for idx = 1, baseSlotLineCount do
      UIindex = idx + idy * baseSlotLineCount
      if slotIndexCount < UIindex then
        break
      end
      UIPosX = startX + slotSizeX * (idx - 1) + 8 * (idx - 1)
      UIPosY = startY + slotSizeY * idy + 5 * idy
      if slotIndexCount == 1 then
        popupItem.slotInfoBG[UIindex]:SetPosX(Panel_UseItem:GetSizeX() / 2 - popupItem.slotInfoBG[UIindex]:GetSizeX() / 2)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(Panel_UseItem:GetSizeX() / 2 - popupItem.slotInfoBG[UIindex]:GetSizeX() / 2 + 2)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      elseif slotIndexCount <= 4 then
        popupItem.slotInfoBG[UIindex]:SetPosX(UIPosX)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(UIPosX + 3)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      elseif slotIndexCount > 4 then
        popupItem.slotInfoBG[UIindex]:SetPosX(UIPosX)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(UIPosX + 3)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      end
    end
  end
  _descBG:SetSize(_descBG:GetSizeX(), _frame:GetSizeY() + 20)
  local desc_sizeY = GetBottomPos(_descBG)
  Panel_UseItem:SetSize(Panel_UseItem:GetSize(), _descBG:GetSizeY() + 94)
  _btn_Yes:ComputePos()
  _btn_No:ComputePos()
end
function Panel_UseBuff_RepositionSlot(buffCount)
  local remain = buffCount % baseSlotLineCount
  local row = math.floor(buffCount / baseSlotLineCount)
  local slotIndexCount = row * baseSlotLineCount + remain
  local startUI
  local startX = 0
  local startY = 0
  if 0 ~= popupItem.slotIndex then
    startUI = popupItem.slotInfoBG[popupItem.slotIndex]
    startX = _desc:GetPosX() + 5
    startY = startUI:GetPosY() + startUI:GetSizeY() + 30
    popupItem.totalRowCount = popupItem.totalRowCount + row + 1
  else
    startX = _desc:GetPosX() + 5
    startY = _desc:GetPosY() + _desc:GetSizeY() + 30
    popupItem.totalRowCount = row + 1
  end
  local slotSizeX = _copyItemSlot:GetSizeX()
  local slotSizeY = _copyItemSlot:GetSizeY()
  local UIindex = 1
  for idy = 0, row do
    for idx = 1, baseSlotLineCount do
      UIindex = idx + idy * baseSlotLineCount
      if slotIndexCount < UIindex then
        break
      end
      UIPosX = startX + slotSizeX * (idx - 1) + 8 * (idx - 1)
      UIPosY = startY + slotSizeY * idy + 5 * idy
      if slotIndexCount == 1 then
        popupItem.slotInfoBG[UIindex]:SetPosX(Panel_UseItem:GetSizeX() / 2 - popupItem.slotInfoBG[UIindex]:GetSizeX() / 2)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(Panel_UseItem:GetSizeX() / 2 - popupItem.slotInfoBG[UIindex]:GetSizeX() / 2 + 2)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      elseif slotIndexCount <= 4 then
        popupItem.slotInfoBG[UIindex]:SetPosX(UIPosX)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(UIPosX + 3)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      elseif slotIndexCount > 4 then
        popupItem.slotInfoBG[UIindex]:SetPosX(UIPosX)
        popupItem.slotInfoBG[UIindex]:SetPosY(UIPosY)
        popupItem.slotInfoBG[UIindex]:SetShow(true)
        popupItem.slotInfo[UIindex].icon:SetPosX(UIPosX + 3)
        popupItem.slotInfo[UIindex].icon:SetPosY(UIPosY + 3)
        popupItem.slotInfo[UIindex].icon:SetShow(true)
        local bgBottomPos = GetBottomPos(popupItem.slotInfoBG[UIindex])
        descBG_sizeY = bgBottomPos - _descBG:GetPosY() + 7
      end
    end
  end
end
function Panel_UseItem_ShowToggle_Func()
  if Panel_UseItem:IsShow() then
    SetUIMode(Defines.UIMode.eUIMode_Default)
    Panel_UseItem:SetShow(false)
  else
    SetUIMode(Defines.UIMode.eUIMode_PopupItem)
    Panel_UseItem:SetShow(true)
    _frame:UpdateContentScroll()
    _frameScroll:SetControlTop()
    _frame:UpdateContentPos()
  end
  descBG_sizeY = 0
end
local function fillPopupUseItemData(itemEnchatWrapper)
  _desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  _desc:SetText(itemEnchatWrapper:getPopupItemDesc())
  _frameContent:SetSize(_frameContent:GetSizeX(), _desc:GetTextSizeY() + 20)
  _desc:SetPosY(10)
  _desc:SetSize(_desc:GetSizeX(), _desc:GetTextSizeY())
  local descSizeY = _desc:GetTextSizeY()
  if descSizeY > 180 then
    _frameScroll:SetShow(true)
    _frame:SetSize(_frame:GetSizeX(), 180)
    _descBG:SetSize(_descBG:GetSizeX(), 210)
    Panel_UseItem:SetSize(Panel_UseItem:GetSizeX(), _frame:GetSizeY() + 124)
  else
    _frameScroll:SetShow(false)
    _frame:SetSize(_frame:GetSizeX(), descSizeY + 40)
    _descBG:SetSize(_descBG:GetSizeX(), descSizeY + 60)
    Panel_UseItem:SetSize(Panel_UseItem:GetSizeX(), _frame:GetSizeY() + 114)
  end
  _btn_Yes:ComputePos()
  _btn_No:ComputePos()
  descBG_sizeY = descBG_sizeY + _desc:GetSizeY()
  local popupItemSize = itemEnchatWrapper:getPopupItemSize()
  Panel_UseItem_RepositionSlot(popupItemSize)
  if 0 ~= popupItemSize then
    local itemESS
    local itemStack = const_64.s64_0
    local expiration
    for idx = 1, popupItemSize do
      itemESS = itemEnchatWrapper:getPopupItemAt(idx - 1)
      if nil == itemESS then
        popupItem.slotInfo[idx].count:SetText("")
        popupItem.slotInfo[idx].icon:ChangeTextureInfoName("icon/new_icon/03_etc/item_unknown.dds")
      else
        itemStack = itemEnchatWrapper:getPopupItemAtStatckCount(idx - 1)
        popupItem.slotInfo[idx]:setItemByStaticStatus(itemESS, itemStack, -1)
        popupItem.slotInfo[idx].icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. idx .. ", \"popupItem\", true)")
        popupItem.slotInfo[idx].icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. idx .. ", \"popupItem\", false)")
        Panel_Tooltip_Item_SetPosition(idx, popupItem.slotInfo[idx], "popupItem")
      end
    end
  end
  local popupBuffSize = itemEnchatWrapper:getPopupBuffSize()
  if 0 == popupBuffSize then
    return
  end
  Panel_UseBuff_RepositionSlot(popupBuffSize)
  local buffSSW
  for idxBuff = 1, popupBuffSize do
    buffSSW = itemEnchatWrapper:getPopupBuffStaticStatusWrapperAt(idxBuff - 1)
    if nil == buffSSW then
      popupItem.slotInfoForBuff[idxBuff]:ChangeTextureInfoName("icon/new_icon/03_etc/item_unknown.dds")
    else
      popupItem.slotInfoForBuff[idxBuff]:ChangeTextureInfoName("icon/" .. buffSSW:getIconPath())
      popupItem.slotInfoForBuff[idxBuff]:addInputEvent("Mouse_On", "ShowPopupBuffTooltip(" .. idxBuff .. ")")
      popupItem.slotInfoForBuff[idxBuff]:addInputEvent("Mouse_Out", "HidePopupBuffTooltip(" .. idxBuff .. ")")
    end
  end
end
function ShowPopupBuffTooltip(idxBuff)
  local buffSSW = global_PopupItemItemWrapper:getPopupBuffStaticStatusWrapperAt(idxBuff - 1)
  if nil ~= buffSSW then
    TooltipCommon_Show(idxBuff, popupItem.slotInfoForBuff[idxBuff], buffSSW:getIconPath(), buffSSW:getDescription(), "")
  end
end
function HidePopupBuffTooltip(idxBuff)
  TooltipCommon_Hide(idxBuff)
end
function Panel_UserItem_PopupItem(itemEnchatWrapper, whereType, slotNo, equipSlotNo)
  Panel_UseItem_ShowToggle_Func()
  resetUIcontrol()
  global_PopupItemItemWrapper = itemEnchatWrapper
  popupItem.selectWhereType = whereType
  popupItem.selectSlotNo = slotNo
  popupItem.selectEquipNo = equipSlotNo
  fillPopupUseItemData(itemEnchatWrapper)
end
function Click_Panel_UserItem_Yes()
  Panel_UseItem_ShowToggle_Func()
  Inventory_UseItemTargetSelf(popupItem.selectWhereType, popupItem.selectSlotNo, popupItem.selectEquipNo)
end
function Panel_UseItem_AddEventContol()
  _btn_Close:addInputEvent("Mouse_LUp", "Panel_UseItem_ShowToggle_Func()")
  _btn_Yes:addInputEvent("Mouse_LUp", "Click_Panel_UserItem_Yes()")
  _btn_No:addInputEvent("Mouse_LUp", "Panel_UseItem_ShowToggle_Func()")
end
Panel_UseItem_Initialize()
