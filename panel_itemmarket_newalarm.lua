Panel_ItemMarket_NewAlarm:SetShow(false)
local PaGlobal_ItemMarket_NewAlarm = {
  _ui = {
    _bg = UI.getChildControl(Panel_ItemMarket_NewAlarm, "Static_Bg"),
    _date = UI.getChildControl(Panel_ItemMarket_NewAlarm, "StaticText_Date"),
    _desc = UI.getChildControl(Panel_ItemMarket_NewAlarm, "StaticText_Desc"),
    _itemSlotBg = UI.getChildControl(Panel_ItemMarket_NewAlarm, "Static_Slot_IconBG"),
    _itemSlot = UI.getChildControl(Panel_ItemMarket_NewAlarm, "Static_Slot_Icon"),
    _closeIcon = UI.getChildControl(Panel_ItemMarket_NewAlarm, "Button_Win_Close")
  },
  _config = {
    createBorder = true,
    createEnchant = true,
    createCash = true
  },
  _enchantItemKey = nil,
  _aniTime = 0,
  _maxTime = 5,
  _itemSlot = {}
}
function PaGlobal_ItemMarket_NewAlarm:Init()
  self._ui._desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._bg:addInputEvent("Mouse_LUp", "FGlobal_ItemMarketAlarmList_New_Open()")
  self._ui._closeIcon:addInputEvent("Mouse_LUp", "FGlobal_ItemMarket_NewAlarmClose()")
  Panel_ItemMarket_NewAlarm:RegisterUpdateFunc("UpdateFunc_checkAlramAnimation")
  SlotItem.new(self._itemSlot, "ItemMarketItemIconSlot", 0, self._ui._itemSlotBg, self._config)
  self._itemSlot:createChild()
end
function PaGlobal_ItemMarket_NewAlarm:ShowAni()
  local posY = 120
  if false == FGlobal_AlertMsgBg_ShowCheck() then
    posY = 45
  end
  local alarmMoveAni1 = Panel_ItemMarket_NewAlarm:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni1:SetStartPosition(getScreenSizeX() + 10, getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - posY)
  alarmMoveAni1:SetEndPosition(getScreenSizeX() - Panel_ItemMarket_NewAlarm:GetSizeX() - 5, getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - posY)
  alarmMoveAni1.IsChangeChild = true
  Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni1)
  alarmMoveAni1:SetDisableWhileAni(true)
  if FGlobal_ItemMarket_AlarmList_SoundCheck() then
    audioPostEvent_SystemUi(10, 1)
    _AudioPostEvent_SystemUiForXBOX(10, 1)
  end
  FGlobal_BossAlertMsg_ResetPos(FGlobal_AlertMsgBg_ShowCheck(), true, 1)
end
function PaGlobal_ItemMarket_NewAlarm:HideAni()
  if not Panel_ItemMarket_NewAlarm:GetShow() then
    return
  end
  local alarmMoveAni2 = Panel_ItemMarket_NewAlarm:addMoveAnimation(0, 0.3, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni2:SetStartPosition(Panel_ItemMarket_NewAlarm:GetPosX(), Panel_ItemMarket_NewAlarm:GetPosY())
  alarmMoveAni2:SetEndPosition(getScreenSizeX() + 10, Panel_ItemMarket_NewAlarm:GetPosY())
  alarmMoveAni2.IsChangeChild = true
  Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni2)
  alarmMoveAni2:SetDisableWhileAni(true)
  alarmMoveAni2:SetHideAtEnd(true)
  alarmMoveAni2:SetDisableWhileAni(true)
  Panel_Tooltip_Item_hideTooltip()
  FGlobal_BossAlertMsg_ResetPos(FGlobal_AlertMsgBg_ShowCheck(), false, 1)
end
function FGlobal_MarketAlertMsg_ResetPos(isShow)
  if not Panel_ItemMarket_NewAlarm:GetShow() then
    FGlobal_BossAlertMsg_ResetPos(isShow, false, 0)
    return
  end
  if isShow then
    local alarmMoveAni3 = Panel_ItemMarket_NewAlarm:addMoveAnimation(0, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    alarmMoveAni3:SetStartPosition(Panel_ItemMarket_NewAlarm:GetPosX(), Panel_ItemMarket_NewAlarm:GetPosY())
    alarmMoveAni3:SetEndPosition(Panel_ItemMarket_NewAlarm:GetPosX(), getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 120)
    alarmMoveAni3.IsChangeChild = true
    Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni3)
  else
    local alarmMoveAni4 = Panel_ItemMarket_NewAlarm:addMoveAnimation(0.3, 0.4, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    alarmMoveAni4:SetStartPosition(Panel_ItemMarket_NewAlarm:GetPosX(), Panel_ItemMarket_NewAlarm:GetPosY())
    alarmMoveAni4:SetEndPosition(Panel_ItemMarket_NewAlarm:GetPosX(), getScreenSizeY() - Panel_ItemMarket_NewAlarm:GetSizeY() - 45)
    alarmMoveAni4.IsChangeChild = true
    Panel_ItemMarket_NewAlarm:CalcUIAniPos(alarmMoveAni4)
  end
  FGlobal_BossAlertMsg_ResetPos(isShow, true, 0)
end
function FGlobal_ItemMarket_NewAlarmShow(enchantItemKey, playerName, registTime)
  local self = PaGlobal_ItemMarket_NewAlarm
  local itemSSW = getItemEnchantStaticStatus(enchantItemKey)
  if nil == itemSSW then
    return
  end
  self._enchantItemKey = enchantItemKey
  self._itemSlot:setItemByStaticStatus(itemSSW)
  self._itemSlot.icon:addInputEvent("Mouse_On", "PaGlobal_ItemMarket_NewAlarm_TooltipShow()")
  self._itemSlot.icon:addInputEvent("Mouse_Out", "PaGlobal_ItemMarket_NewAlarm_TooltipHide()")
  local itemName = FGlobal_ChangeItemNameColorByGrade(enchantItemKey)
  if registTime then
    if true == playerName then
      self._ui._desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLBYPREBID_ALARMMSG2", "itemName", itemName))
    else
      self._ui._desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGIST_ALARMMSG", "itemName", itemName))
    end
    self._ui._date:SetText(registTime)
  else
    if nil ~= playerName then
      self._ui._desc:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_ITEMMARKET_SELLBYPREBID_ALARMMSG", "itemName", itemName, "playerName", playerName))
    else
      self._ui._desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_REGIST_ALARMMSG", "itemName", itemName))
    end
    self._ui._date:SetText(getTimeYearMonthDayHourMinSecByTTime64(getUtc64()))
  end
  Panel_ItemMarket_NewAlarm:SetShow(true)
  self._aniTime = 0
  self:ShowAni()
  if nil == registTime then
    FGlobal_ItemMarket_AlarmIcon_Show()
  end
end
function PaGlobal_ItemMarket_NewAlarm_TooltipShow()
  local self = PaGlobal_ItemMarket_NewAlarm
  if nil == self._enchantItemKey then
    return
  end
  local itemSSW = getItemEnchantStaticStatus(self._enchantItemKey)
  if nil == itemSSW then
    return
  end
  Panel_Tooltip_Item_SetPosition(0, self._ui._itemSlotBg, "itemMarketAlarm")
  Panel_Tooltip_Item_Show(itemSSW, Panel_ItemMarket_NewAlarm, true)
end
function PaGlobal_ItemMarket_NewAlarm_TooltipHide()
  Panel_Tooltip_Item_hideTooltip()
end
function FGlobal_ItemMarket_NewAlarmClose()
  PaGlobal_ItemMarket_NewAlarm:HideAni()
end
function UpdateFunc_checkAlramAnimation(deltaTime)
  local self = PaGlobal_ItemMarket_NewAlarm
  if FGlobal_ItemMarketAlarm_CheckState() then
    self._aniTime = 0
    return
  end
  self._aniTime = self._aniTime + deltaTime
  if self._maxTime < self._aniTime then
    self:HideAni()
    self._aniTime = 0
  end
end
PaGlobal_ItemMarket_NewAlarm:Init()
