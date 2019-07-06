local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_ItemMarket_Alarm:RegisterShowEventFunc(true, "ItemMarketAlarm_ShowAni()")
Panel_ItemMarket_Alarm:RegisterShowEventFunc(false, "ItemMarketAlarm_HideAni()")
Panel_ItemMarket_Alarm:SetShow(false, false)
Panel_ItemMarket_Alarm:ActiveMouseEventEffect(true)
Panel_ItemMarket_Alarm:setGlassBackground(true)
local ItemMarketAlarm = {
  ui = {
    btn_Close = UI.getChildControl(Panel_ItemMarket_Alarm, "Button_Confirm"),
    btn_AlarmCancel = UI.getChildControl(Panel_ItemMarket_Alarm, "Button_AlarmCancel"),
    bg = UI.getChildControl(Panel_ItemMarket_Alarm, "Static_BG"),
    itemIcon = UI.getChildControl(Panel_ItemMarket_Alarm, "Static_Slot_Icon"),
    itemName = UI.getChildControl(Panel_ItemMarket_Alarm, "StaticText_Slot_ItemName"),
    enchantLevel = UI.getChildControl(Panel_ItemMarket_Alarm, "StaticText_EnchantLevel"),
    alarmTime = UI.getChildControl(Panel_ItemMarket_Alarm, "StaticText_AlarmTime")
  },
  config = {alarmItemEnchantKey = nil, isOpen = false}
}
function ItemMarketAlarm:Init()
  self.ui.itemName:SetTextMode(UI_TM.eTextMode_AutoWrap)
end
ItemMarketAlarm:Init()
function ItemMarketAlarm:Update()
  local itemEnchantKeyRaw = self.config.alarmItemEnchantKey
  local itemSSW = getItemEnchantStaticStatus(itemEnchantKeyRaw)
  if itemSSW == nil then
    return
  end
  self.ui.enchantLevel:SetShow(false)
  local itemName = itemSSW:getName()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local iconPath = itemSSW:getIconPath()
  local isCash = itemSSW:get():isCash()
  local nameColorGrade = itemSSW:getGradeType()
  if 0 == nameColorGrade then
    self.ui.itemName:SetFontColor(UI_color.C_FFFFFFFF)
  elseif 1 == nameColorGrade then
    self.ui.itemName:SetFontColor(4284350320)
  elseif 2 == nameColorGrade then
    self.ui.itemName:SetFontColor(4283144191)
  elseif 3 == nameColorGrade then
    self.ui.itemName:SetFontColor(4294953010)
  elseif 4 == nameColorGrade then
    self.ui.itemName:SetFontColor(4294929408)
  else
    self.ui.itemName:SetFontColor(UI_color.C_FFFFFFFF)
  end
  if enchantLevel > 0 and enchantLevel < 16 then
    if true == isCash then
      self.ui.enchantLevel:SetShow(false)
    else
      self.ui.enchantLevel:SetText("+" .. tostring(enchantLevel))
      self.ui.enchantLevel:SetShow(true)
    end
  elseif 16 == enchantLevel then
    self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
    self.ui.enchantLevel:SetShow(true)
  elseif 17 == enchantLevel then
    self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
    self.ui.enchantLevel:SetShow(true)
  elseif 18 == enchantLevel then
    self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
    self.ui.enchantLevel:SetShow(true)
  elseif 19 == enchantLevel then
    self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
    self.ui.enchantLevel:SetShow(true)
  elseif 20 == enchantLevel then
    self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
    self.ui.enchantLevel:SetShow(true)
  end
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
    if 1 == enchantLevel then
      self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
      self.ui.enchantLevel:SetShow(true)
    elseif 2 == enchantLevel then
      self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
      self.ui.enchantLevel:SetShow(true)
    elseif 3 == enchantLevel then
      self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
      self.ui.enchantLevel:SetShow(true)
    elseif 4 == enchantLevel then
      self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
      self.ui.enchantLevel:SetShow(true)
    elseif 5 == enchantLevel then
      self.ui.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
      self.ui.enchantLevel:SetShow(true)
    end
  end
  self.ui.itemIcon:ChangeTextureInfoName("Icon/" .. iconPath)
  self.ui.itemName:SetText(itemName)
  self.ui.alarmTime:SetText(getTimeYearMonthDayHourMinSecByTTime64(getUtc64()))
end
function ItemMarketAlarm:Open(enchantItemKey)
  Panel_ItemMarket_Alarm:SetShow(true, true)
  self.config.alarmItemEnchantKey = enchantItemKey
  self.config.isOpen = true
  self:Update()
end
function ItemMarketAlarm:Close()
  Panel_ItemMarket_Alarm:SetShow(false, false)
  self.config.isOpen = false
end
function ItemMarketAlarm_ShowAni()
  local aniInfo1 = Panel_ItemMarket_Alarm:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_ItemMarket_Alarm:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ItemMarket_Alarm:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ItemMarket_Alarm:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ItemMarket_Alarm:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ItemMarket_Alarm:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function ItemMarketAlarm_HideAni()
  local aniInfo1 = Panel_ItemMarket_Alarm:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function HandleClicked_ItemMarketAlarm_Close()
  ItemMarketAlarm:Close()
end
function HandleClicked_ItemMarketAlarm_Cancel()
  if nil ~= ItemMarketAlarm.config.alarmItemEnchantKey:get() then
    toClient_EraseItemMarketFavoriteItem(ItemMarketAlarm.config.alarmItemEnchantKey:get())
  end
  ItemMarketAlarm:Close()
end
function FGlobal_ItemMarketAlarm_Close()
  ItemMarketAlarm:Close()
end
function ItemMarketAlarm_CheckRestoreFlush(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if ItemMarketAlarm.config.isOpen then
    Panel_ItemMarket_Alarm:SetShow(true, true)
  end
end
registerEvent("FromClient_RenderModeChangeState", "ItemMarketAlarm_CheckRestoreFlush")
function ItemMarketAlarm:registEventHandler()
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketAlarm_Close()")
  self.ui.btn_AlarmCancel:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketAlarm_Cancel()")
end
ItemMarketAlarm:registEventHandler()
