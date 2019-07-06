local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_ItemMarket_AlarmList:RegisterShowEventFunc(true, "ItemMarketAlarmList_ShowAni()")
Panel_ItemMarket_AlarmList:RegisterShowEventFunc(false, "ItemMarketAlarmList_HideAni()")
Panel_ItemMarket_AlarmList:SetShow(false, false)
Panel_ItemMarket_AlarmList:ActiveMouseEventEffect(true)
Panel_ItemMarket_AlarmList:setGlassBackground(true)
local ItemMarketAlarm = {
  ui = {
    btn_Close = UI.getChildControl(Panel_ItemMarket_AlarmList, "Button_Win_Close"),
    bg = UI.getChildControl(Panel_ItemMarket_AlarmList, "Static_BG"),
    temp_SlotBG = UI.getChildControl(Panel_ItemMarket_AlarmList, "Static_SlotBG"),
    temp_Slot_IconBG = UI.getChildControl(Panel_ItemMarket_AlarmList, "Static_Slot_IconBG"),
    temp_Slot_Icon = UI.getChildControl(Panel_ItemMarket_AlarmList, "Static_Slot_Icon"),
    temp_Slot_ItemName = UI.getChildControl(Panel_ItemMarket_AlarmList, "StaticText_Slot_ItemName"),
    temp_Button_UnSelect = UI.getChildControl(Panel_ItemMarket_AlarmList, "Button_UnSelect"),
    scroll = UI.getChildControl(Panel_ItemMarket_AlarmList, "Scroll_List")
  },
  config = {
    maxSlotCount = 6,
    totalItemCount = 0,
    startIndex = 0
  },
  uiPool = {}
}
local _buttonQuestion = UI.getChildControl(Panel_ItemMarket_AlarmList, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"ItemMarket\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"ItemMarket\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"ItemMarket\", \"false\")")
function ItemMarketAlarm:Init()
  for slotIdx = 0, self.config.maxSlotCount - 1 do
    self.uiPool[slotIdx] = {}
    local slot = self.uiPool[slotIdx]
    slot.slotBG = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "Static_SlotBG", self.ui.bg, "ItemMarket_AlarmList_SlotBG_" .. slotIdx)
    slot.iconBG = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "Static_Slot_IconBG", slot.slotBG, "ItemMarket_AlarmList_SlotIconBG_" .. slotIdx)
    slot.icon = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "Static_Slot_Icon", slot.iconBG, "ItemMarket_AlarmList_SlotIcon_" .. slotIdx)
    slot.enchantLevel = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "StaticText_EnchantLevel", slot.iconBG, "ItemMarket_AlarmList_SlotEnchantLevel_" .. slotIdx)
    slot.itemName = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "StaticText_Slot_ItemName", slot.slotBG, "ItemMarket_AlarmList_SlotItemName_" .. slotIdx)
    slot.unSetBtn = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_AlarmList, "Button_UnSelect", slot.slotBG, "ItemMarket_AlarmList_SlotUnSetBtn_" .. slotIdx)
    slot.slotBG:SetPosX(5)
    slot.slotBG:SetPosY(5 + (slot.slotBG:GetSizeY() + 5) * slotIdx)
    slot.iconBG:SetPosX(5)
    slot.iconBG:SetPosY(5)
    slot.icon:SetPosX(0)
    slot.icon:SetPosY(0)
    slot.enchantLevel:SetPosX(5)
    slot.enchantLevel:SetPosY(10)
    slot.itemName:SetPosX(55)
    slot.itemName:SetPosY(15)
    slot.unSetBtn:SetPosX(345)
    slot.unSetBtn:SetPosY(5)
    slot.slotBG:SetShow(false)
    slot.slotBG:addInputEvent("Mouse_UpScroll", "Scroll_ItemMarketAlarmList( true )")
    slot.slotBG:addInputEvent("Mouse_DownScroll", "Scroll_ItemMarketAlarmList( false )")
    slot.icon:addInputEvent("Mouse_UpScroll", "Scroll_ItemMarketAlarmList( true )")
    slot.icon:addInputEvent("Mouse_DownScroll", "Scroll_ItemMarketAlarmList( false )")
    slot.itemName:addInputEvent("Mouse_UpScroll", "Scroll_ItemMarketAlarmList( true )")
    slot.itemName:addInputEvent("Mouse_DownScroll", "Scroll_ItemMarketAlarmList( false )")
    slot.unSetBtn:addInputEvent("Mouse_UpScroll", "Scroll_ItemMarketAlarmList( true )")
    slot.unSetBtn:addInputEvent("Mouse_DownScroll", "Scroll_ItemMarketAlarmList( false )")
    self.ui.temp_SlotBG:SetShow(false)
    self.ui.temp_Slot_IconBG:SetShow(false)
    self.ui.temp_Slot_Icon:SetShow(false)
    self.ui.temp_Slot_ItemName:SetShow(false)
    self.ui.temp_Button_UnSelect:SetShow(false)
  end
  toClient_LoadItemMarketFavoriteItem()
end
ItemMarketAlarm:Init()
function ItemMarketAlarm:Update()
  for slotIdx = 0, self.config.maxSlotCount - 1 do
    local slot = self.uiPool[slotIdx]
    slot.slotBG:SetShow(false)
    slot.unSetBtn:addInputEvent("Mouse_LUp", "")
    slot.enchantLevel:SetShow(false)
  end
  self.config.totalItemCount = toClient_GetItemMarketFavoriteItemListSize()
  local uiCount = 0
  if 0 < self.config.totalItemCount then
    for slotIdx = self.config.startIndex, self.config.totalItemCount - 1 do
      if uiCount >= self.config.maxSlotCount then
        break
      end
      local slot = self.uiPool[uiCount]
      local enchantItemKey = toClient_GetItemMarketFavoriteItem(slotIdx)
      local itemSSW = getItemEnchantStaticStatus(enchantItemKey)
      local itemName = itemSSW:getName()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local enchantLevelValue = ""
      local iconPath = itemSSW:getIconPath()
      local isCash = itemSSW:get():isCash()
      local nameColorGrade = itemSSW:getGradeType()
      if 0 == nameColorGrade then
        slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
      elseif 1 == nameColorGrade then
        slot.itemName:SetFontColor(4284350320)
      elseif 2 == nameColorGrade then
        slot.itemName:SetFontColor(4283144191)
      elseif 3 == nameColorGrade then
        slot.itemName:SetFontColor(4294953010)
      elseif 4 == nameColorGrade then
        slot.itemName:SetFontColor(4294929408)
      else
        slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
      end
      if enchantLevel > 0 and enchantLevel < 16 then
        if true == isCash then
          slot.enchantLevel:SetShow(false)
        else
          slot.enchantLevel:SetText("+" .. tostring(enchantLevel))
          slot.enchantLevel:SetShow(true)
        end
      elseif 16 == enchantLevel then
        slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
        slot.enchantLevel:SetShow(true)
      elseif 17 == enchantLevel then
        slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
        slot.enchantLevel:SetShow(true)
      elseif 18 == enchantLevel then
        slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
        slot.enchantLevel:SetShow(true)
      elseif 19 == enchantLevel then
        slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
        slot.enchantLevel:SetShow(true)
      elseif 20 == enchantLevel then
        slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
        slot.enchantLevel:SetShow(true)
      end
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        if 1 == enchantLevel then
          slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
          slot.enchantLevel:SetShow(true)
        elseif 2 == enchantLevel then
          slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
          slot.enchantLevel:SetShow(true)
        elseif 3 == enchantLevel then
          slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
          slot.enchantLevel:SetShow(true)
        elseif 4 == enchantLevel then
          slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
          slot.enchantLevel:SetShow(true)
        elseif 5 == enchantLevel then
          slot.enchantLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
          slot.enchantLevel:SetShow(true)
        end
      end
      slot.slotBG:SetShow(true)
      slot.itemName:SetText(itemName)
      slot.icon:ChangeTextureInfoName("Icon/" .. iconPath)
      slot.unSetBtn:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketAlarm_UnSet( " .. enchantItemKey:get() .. " )")
      uiCount = uiCount + 1
    end
    UIScroll.SetButtonSize(self.ui.scroll, self.config.maxSlotCount, self.config.totalItemCount)
  end
  if self.config.maxSlotCount < self.config.totalItemCount then
    self.ui.scroll:SetShow(true)
  else
    self.ui.scroll:SetShow(false)
  end
end
function ItemMarketAlarm:Open()
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    FGlobal_ItemMarketItemSet_Close()
  end
  if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
    FGlobal_ItemMarket_BuyConfirm_Close()
  end
  if Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  Panel_ItemMarket_AlarmList:SetShow(true, true)
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = Panel_ItemMarket_AlarmList:GetSizeX()
  local panelSizeY = Panel_ItemMarket_AlarmList:GetSizeY()
  Panel_ItemMarket_AlarmList:SetPosX(scrSizeX / 2 - panelSizeX / 2)
  Panel_ItemMarket_AlarmList:SetPosY(scrSizeY / 2 - panelSizeY / 2 - 100)
  self.ui.scroll:SetControlPos(0)
  self.config.startIndex = 0
  self.config.totalItemCount = 0
  self:Update()
end
function ItemMarketAlarm:Close()
  Panel_ItemMarket_AlarmList:SetShow(false, false)
  self.ui.scroll:SetControlPos(0)
  self.config.startIndex = 0
  self.config.totalItemCount = 0
end
function ItemMarketAlarmList_ShowAni()
  Panel_ItemMarket_AlarmList:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_ItemMarket_AlarmList, 0, 0.3)
end
function ItemMarketAlarmList_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_ItemMarket_AlarmList, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
function Scroll_ItemMarketAlarmList(isScrollUp)
  ItemMarketAlarm.config.startIndex = UIScroll.ScrollEvent(ItemMarketAlarm.ui.scroll, isScrollUp, ItemMarketAlarm.config.maxSlotCount, ItemMarketAlarm.config.totalItemCount, ItemMarketAlarm.config.startIndex, 1)
  ItemMarketAlarm:Update()
end
function HandleClicked_ItemMarketAlarm_UnSet(enchantItemKey)
  if nil ~= enchantItemKey then
    toClient_EraseItemMarketFavoriteItem(enchantItemKey)
  end
  ItemMarketAlarm:Update()
end
function HandleClicked_ItemMarketAlarmList_Close()
  ItemMarketAlarm:Close()
end
function FGlobal_ItemMarketAlarmList_Open()
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    FGlobal_ItemMarketItemSet_Close()
  end
  if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
    FGlobal_ItemMarket_BuyConfirm_Close()
  end
  if Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  if Panel_ItemMarket_PreBid_Manager:GetShow() then
    FGlobal_ItemMarketPreBid_Manager_Close()
  end
  ItemMarketAlarm:Open()
end
function FGlobal_ItemMarketAlarmList_Close()
  ItemMarketAlarm:Close()
end
function ItemMarketAlarm:registEventHandler()
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketAlarmList_Close()")
  self.ui.bg:addInputEvent("Mouse_UpScroll", "Scroll_ItemMarketAlarmList( true )")
  self.ui.bg:addInputEvent("Mouse_DownScroll", "Scroll_ItemMarketAlarmList( false )")
  UIScroll.InputEvent(self.ui.scroll, "Scroll_ItemMarketAlarmList")
end
function ItemMarketAlarm:registMessageHandler()
end
ItemMarketAlarm:registEventHandler()
ItemMarketAlarm:registMessageHandler()
