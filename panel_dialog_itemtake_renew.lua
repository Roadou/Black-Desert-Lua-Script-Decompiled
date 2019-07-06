local _panel = Panel_Dialogue_Itemtake
local Panel_Dialog_ItemTake_info = {
  _ui = {
    static_Title = nil,
    static_CenterBg = nil,
    static_SlotBg = nil,
    staticText_ItemName = nil,
    staticText_Weight = nil,
    staticText_NeedContributePointTitle = nil,
    staticText_NeedContributePointValue = nil,
    staticText_MyContributePointTitle = nil,
    staticText_MyContributePointValue = nil,
    staticText_Desc = nil,
    stc_bottom = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuideA = nil,
    txt_keyGuideB = nil
  },
  _value = {displayData = nil, selectIndex = 0},
  _config = {
    slotConfig = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createCash = true
    }
  },
  _enum = {},
  _itemSlot = {}
}
function Panel_Dialog_ItemTake_info:registEventHandler()
  Panel_Dialogue_Itemtake:ignorePadSnapMoveToOtherPanel()
end
function Panel_Dialog_ItemTake_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_Dialog_ItemTake_Resize")
end
function Panel_Dialog_ItemTake_info:initialize()
  self:childControl()
  self:createSlot()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Dialog_ItemTake_info:createSlot()
  SlotItem.new(self._itemSlot, "ItemIconSlot", 0, self._ui.static_SlotBg, self._config.slotConfig)
  self._itemSlot:createChild()
end
function Panel_Dialog_ItemTake_info:initValue()
  self._value.displayData = nil
  self._value.selectIndex = 0
end
function Panel_Dialog_ItemTake_info:resize()
  Panel_Dialogue_Itemtake:ComputePos()
end
function Panel_Dialog_ItemTake_info:childControl()
  self._ui.static_Title = UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_Title")
  self._ui.static_CenterBg = UI.getChildControl(Panel_Dialogue_Itemtake, "Static_CenterBg")
  self._ui.static_SlotBg = UI.getChildControl(self._ui.static_CenterBg, "Static_SlotBg")
  self._ui.staticText_ItemName = UI.getChildControl(self._ui.static_CenterBg, "StaticText_ItemName")
  self._ui.staticText_Weight = UI.getChildControl(self._ui.static_CenterBg, "StaticText_Weight")
  self._ui.staticText_NeedContributePointTitle = UI.getChildControl(self._ui.static_CenterBg, "StaticText_NeedContributePointTitle")
  self._ui.staticText_NeedContributePointValue = UI.getChildControl(self._ui.static_CenterBg, "StaticText_NeedContributePointValue")
  self._ui.staticText_MyContributePointTitle = UI.getChildControl(self._ui.static_CenterBg, "StaticText_MyContributePointTitle")
  self._ui.staticText_MyContributePointValue = UI.getChildControl(self._ui.static_CenterBg, "StaticText_MyContributePointValue")
  self._ui.staticText_Desc = UI.getChildControl(Panel_Dialogue_Itemtake, "StaticText_Desc")
  if self._ui.static_Title:GetTextSizeX() > self._ui.static_Title:GetSizeX() then
    local tempSizeX = self._ui.static_Title:GetTextSizeX() - self._ui.static_Title:GetSizeX()
    Panel_Dialogue_Itemtake:SetSize(Panel_Dialogue_Itemtake:GetSizeX() + tempSizeX, Panel_Dialogue_Itemtake:GetSizeY())
    self._ui.static_CenterBg:SetSize(self._ui.static_CenterBg:GetSizeX() + tempSizeX, self._ui.static_CenterBg:GetSizeY())
    self._ui.static_CenterBg:ComputePos()
    self._ui.staticText_Desc:ComputePos()
    self._ui.static_Title:ComputePos()
    self._ui.stc_bottom:ComputePos()
  end
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottom, "StaticText_A_ConsoleUI")
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottom, "StaticText_B_ConsoleUI")
  local keyGuides = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_bottom, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Dialog_ItemTake_info:setContent(displayData)
  self._itemSlot:clearItem()
  local itemStaticWrapper = getItemEnchantStaticStatus(displayData:getItemKey())
  local explorePoint = getExplorePointByTerritory(displayData._territoryKey)
  local strNeedPoint = string.format("%d", displayData._needPoint)
  local strHavePoint = string.format("%d", explorePoint:getRemainedPoint())
  self._itemSlot:setItemByStaticStatus(itemStaticWrapper, displayData._itemCounts64)
  self._itemSlot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_Dialog_ItemTake_Confirm()")
  self._itemSlot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Dialog_ItemTake_ShowToolTip()")
  self._itemSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
  local calcWeight = itemStaticWrapper:get()._weight / 10000
  self._ui.staticText_Weight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_WEIGHT", "weight", string.format("%.2f", calcWeight)))
  self._ui.staticText_ItemName:SetText(itemStaticWrapper:getName())
  self._ui.staticText_NeedContributePointValue:SetText(strNeedPoint)
  self._ui.staticText_MyContributePointValue:SetText(strHavePoint)
  self._ui.staticText_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOGUE_TXT_CONTRIHELP"))
end
function Panel_Dialog_ItemTake_info:open()
  Panel_Dialogue_Itemtake:SetShow(true)
end
function Panel_Dialog_ItemTake_info:close()
  Panel_Dialogue_Itemtake:SetShow(false)
end
function PaGlobalFunc_Dialog_ItemTake_GetShow()
  Panel_Dialogue_Itemtake:GetShow()
end
function PaGlobalFunc_Dialog_ItemTake_Open()
  local self = Panel_Dialog_ItemTake_info
  self:open()
end
function PaGlobalFunc_Dialog_ItemTake_Close()
  local self = Panel_Dialog_ItemTake_info
  self:close()
end
function PaGlobalFunc_Dialog_ItemTake_Show(displayData)
  local self = Panel_Dialog_ItemTake_info
  if nil == displayData then
    _PA_LOG("mingu", "\235\140\128\236\151\172\236\176\189\236\157\132 \236\151\180\236\150\180\236\164\132 \236\149\132\236\157\180\237\133\156 \235\141\176\236\157\180\237\132\176\234\176\128 \236\151\134\236\138\181\235\139\136\235\139\164.")
    return
  end
  self._value.displayData = displayData
  self:setContent(displayData)
  self:open()
end
function PaGlobalFunc_Dialog_ItemTake_Exit()
  local self = Panel_Dialog_ItemTake_info
  self:close()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobalFunc_Dialog_ItemTake_ShowToolTip()
  local self = Panel_Dialog_ItemTake_info
  local itemStaticWrapper = getItemEnchantStaticStatus(self._value.displayData:getItemKey())
  PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemStaticWrapper, Defines.TooltipTargetType.ItemWithoutCompare, 0)
end
function PaGlobalFunc_Dialog_ItemTake_SelectedIndex(index)
  local self = Panel_Dialog_ItemTake_info
  self._value.selectIndex = index
end
function PaGlobalFunc_Dialog_ItemTake_Confirm()
  local self = Panel_Dialog_ItemTake_info
  local explorePoint = getExplorePointByTerritory(self._value.displayData._territoryKey)
  if explorePoint:getRemainedPoint() < self._value.displayData._needPoint then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "DIALOG_ERROR_SHORTAGE_POINT"))
    return
  end
  Dialog_clickDialogButtonReq(self._value.selectIndex)
  PaGlobalFunc_Dialog_ItemTake_Exit()
end
function FromClient_Dialog_ItemTake_Init()
  local self = Panel_Dialog_ItemTake_info
  self:initialize()
end
function FromClient_Dialog_ItemTake_Resize()
  local self = Panel_Dialog_ItemTake_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Dialog_ItemTake_Init")
