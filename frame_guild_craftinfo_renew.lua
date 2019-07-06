local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local UI_classType = CppEnums.ClassType
Panel_Guild_CraftInfo:SetShow(false)
local guildCraftInfo = {
  control = {
    _frameDefaultBG = UI.getChildControl(Panel_Window_Guild, "Static_Frame_CraftInfoBG"),
    _scroll = UI.getChildControl(Panel_Guild_CraftInfo, "Scroll_CraftInfo"),
    _BG = UI.getChildControl(Panel_Guild_CraftInfo, "Static_FunctionBG"),
    workList = UI.getChildControl(Panel_Guild_CraftInfo, "StaticText_Parts_Title")
  },
  uiPool = {
    exchange = {}
  },
  config = {
    maxExchangeCount = 3,
    maxEnchantCount = 10,
    scroll_startIdx = 0,
    last_recipeArrayKey = 0,
    recipeArray = {}
  }
}
guildCraftInfo.control._scrollBTN = UI.getChildControl(guildCraftInfo.control._scroll, "Scroll_CtrlButton")
local newPanel = guildCraftInfo.control._frameDefaultBG
function guildCraftInfo:Init()
  for exchange_Idx = 0, self.config.maxExchangeCount - 1 do
    self.uiPool.exchange[exchange_Idx] = {}
    local exchangeSlot = self.uiPool.exchange[exchange_Idx]
    exchangeSlot.bg = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_FunctionBG", newPanel, "Guild_CraftInfo_Exchange_BG_" .. exchange_Idx)
    exchangeSlot.iconBG = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_LargCraftInfo_Result_Icon_BG_1", exchangeSlot.bg, "Guild_CraftInfo_Exchange_IconBG_" .. exchange_Idx)
    exchangeSlot.icon = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_LargCraftInfo_Result_Icon", exchangeSlot.iconBG, "Guild_CraftInfo_Exchange_Icon_" .. exchange_Idx)
    exchangeSlot.border = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_Parts_Icon_Border", exchangeSlot.iconBG, "Guild_CraftInfo_Exchange_IconBorder_" .. exchange_Idx)
    exchangeSlot.name = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_LargCraftInfo_Name", exchangeSlot.bg, "Guild_CraftInfo_Exchange_ItemName_" .. exchange_Idx)
    exchangeSlot.workCount = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_LargCraftInfo_TotalCount", exchangeSlot.bg, "Guild_CraftInfo_Exchange_WorkCount_" .. exchange_Idx)
    exchangeSlot.progressBG = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_LargCraftInfo_Progress_BG", exchangeSlot.bg, "Guild_CraftInfo_Exchange_ProgressBG_" .. exchange_Idx)
    exchangeSlot.progress = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Progress2_LargCraftInfo_Complete", exchangeSlot.bg, "Guild_CraftInfo_Exchange_Progress_" .. exchange_Idx)
    exchangeSlot.progressOutLine = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_LargCraftInfo_Progress_OutLine", exchangeSlot.bg, "Guild_CraftInfo_Exchange_ProgressOutLine_" .. exchange_Idx)
    exchangeSlot.workingList = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_Parts_Title", exchangeSlot.bg, "Guild_CraftInfo_Exchange_WorkingListTitle_" .. exchange_Idx)
    exchangeSlot.noData = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_NoData", exchangeSlot.bg, "Guild_CraftInfo_Exchange_NoData_" .. exchange_Idx)
    exchangeSlot.border:SetSize(exchangeSlot.iconBG:GetSizeX(), exchangeSlot.iconBG:GetSizeY())
    exchangeSlot.progressBG:SetSize(495, exchangeSlot.progressBG:GetSizeY())
    exchangeSlot.progress:SetSize(495, exchangeSlot.progress:GetSizeY())
    exchangeSlot.progressOutLine:SetSize(495, exchangeSlot.progressOutLine:GetSizeY())
    local baseGapX = 35
    exchangeSlot.bg:SetSpanSize(7, 45 + (exchangeSlot.bg:GetSizeY() + 5) * exchange_Idx)
    exchangeSlot.iconBG:SetSpanSize(baseGapX + 25, 25)
    exchangeSlot.icon:SetSpanSize(5, 5)
    exchangeSlot.border:SetSpanSize(0, 0)
    exchangeSlot.name:SetSpanSize(baseGapX + 80, 25)
    exchangeSlot.workCount:SetSpanSize(baseGapX + 80, 47)
    exchangeSlot.progressBG:SetSpanSize(baseGapX + 80, 65)
    exchangeSlot.progress:SetSpanSize(baseGapX + 80, 65)
    exchangeSlot.progressOutLine:SetSpanSize(baseGapX + 80, 65)
    exchangeSlot.workingList:SetSpanSize(baseGapX + 15, 80)
    exchangeSlot.noData:SetSpanSize(0, 0)
    exchangeSlot.bg:addInputEvent("Mouse_UpScroll", "Guild_CraftInfo_ScrollEvent( true )")
    exchangeSlot.bg:addInputEvent("Mouse_DownScroll", "Guild_CraftInfo_ScrollEvent( false )")
    exchangeSlot.enchant = {}
    for enchant_Idx = 0, self.config.maxEnchantCount - 1 do
      exchangeSlot.enchant[enchant_Idx] = {}
      local enchantSlot = exchangeSlot.enchant[enchant_Idx]
      enchantSlot.bg = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Radio_Parts_Icon_BG", exchangeSlot.workingList, "Guild_CraftInfo_Exchange_ItemBG_" .. exchange_Idx .. "_" .. enchant_Idx)
      enchantSlot.border = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_Parts_Icon_Border", enchantSlot.bg, "Guild_CraftInfo_Exchange_ItemBorder_" .. exchange_Idx .. "_" .. enchant_Idx)
      enchantSlot.icon = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_Parts_Icon", enchantSlot.bg, "Guild_CraftInfo_Exchange_ItemIcon_" .. exchange_Idx .. "_" .. enchant_Idx)
      enchantSlot.count = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "StaticText_Parts_Count", enchantSlot.bg, "Guild_CraftInfo_Exchange_ItemCount_" .. exchange_Idx .. "_" .. enchant_Idx)
      enchantSlot.ani = UI.createAndCopyBasePropertyControl(Panel_Guild_CraftInfo, "Static_Parts_OnGoingAni", enchantSlot.bg, "Guild_CraftInfo_Exchange_ItemAni_" .. exchange_Idx .. "_" .. enchant_Idx)
      local posX = 20 + (enchantSlot.bg:GetSizeX() + 10) * enchant_Idx
      local posY = 25
      enchantSlot.bg:SetSpanSize(posX, posY)
      enchantSlot.icon:SetSpanSize(5, 5)
      enchantSlot.border:SetSpanSize(0, 0)
      enchantSlot.count:SetSpanSize(5, 25)
      enchantSlot.ani:SetSpanSize(2, 2)
      enchantSlot.ani:SetShow(false)
    end
  end
  newPanel:MoveChilds(newPanel:GetID(), Panel_Guild_CraftInfo)
  UI.deletePanel(Panel_Guild_CraftInfo:GetID())
  Panel_Guild_CraftInfo = nil
end
function guildCraftInfo:exchangeSlotSet(exchange_Idx, isShow)
  local exchangeSlot = self.uiPool.exchange[exchange_Idx]
  exchangeSlot.bg:SetShow(true)
  exchangeSlot.iconBG:SetShow(isShow)
  exchangeSlot.icon:SetShow(isShow)
  exchangeSlot.border:SetShow(isShow)
  exchangeSlot.name:SetShow(isShow)
  exchangeSlot.workCount:SetShow(isShow)
  exchangeSlot.progressBG:SetShow(isShow)
  exchangeSlot.progress:SetShow(isShow)
  exchangeSlot.progressOutLine:SetShow(isShow)
  exchangeSlot.workingList:SetShow(isShow)
  exchangeSlot.noData:SetShow(not isShow)
end
function guildCraftInfo:Update()
  for exchange_Idx = 0, self.config.maxExchangeCount - 1 do
    local exchangeSlot = self.uiPool.exchange[exchange_Idx]
    guildCraftInfo:exchangeSlotSet(exchange_Idx, false)
    for enchant_Idx = 0, self.config.maxEnchantCount - 1 do
      local enchantSlot = self.uiPool.exchange[exchange_Idx].enchant[enchant_Idx]
      enchantSlot.bg:SetShow(true)
      enchantSlot.icon:SetShow(false)
      enchantSlot.border:SetShow(false)
      enchantSlot.count:SetShow(false)
      enchantSlot.ani:SetShow(false)
    end
  end
  local myGuildHouseCraftInfoManager = getSelfPlayer():getGuildHouseCraftInfoManager()
  local recipeLevelCount = myGuildHouseCraftInfoManager:getReceipeLevelCount()
  self.config.recipeArray = {}
  self.config.last_recipeArrayKey = 0
  for recipe_Idx = 0, recipeLevelCount - 1 do
    local recipeKeyRaw = myGuildHouseCraftInfoManager:getReceipeInReceipeLevelList(recipe_Idx)
    local guildHouseCraftInfo = myGuildHouseCraftInfoManager:getGuildHouseInfoByKeyRaw(recipeKeyRaw)
    if nil ~= guildHouseCraftInfo then
      local itemExchangeSSW = guildHouseCraftInfo:getItemExchangeSourceStaticStatusWrapper()
      if itemExchangeSSW:isSet() then
        self.config.recipeArray[self.config.last_recipeArrayKey] = recipeKeyRaw
        self.config.last_recipeArrayKey = self.config.last_recipeArrayKey + 1
      end
    end
  end
  local exchangeUi_Idx = 0
  for recipeArrayKey_Idx = self.config.scroll_startIdx, self.config.last_recipeArrayKey - 1 do
    if exchangeUi_Idx > self.config.maxExchangeCount - 1 then
      return
    end
    local exchangeSlot = self.uiPool.exchange[exchangeUi_Idx]
    local guildHouseCraftInfo = myGuildHouseCraftInfoManager:getGuildHouseInfoByKeyRaw(self.config.recipeArray[recipeArrayKey_Idx])
    if nil ~= guildHouseCraftInfo then
      local totalWorkCount = 0
      local completeWorkCount = 0
      local itemExchangeSSW = guildHouseCraftInfo:getItemExchangeSourceStaticStatusWrapper()
      if itemExchangeSSW:isSet() then
        guildCraftInfo:exchangeSlotSet(exchangeUi_Idx, true)
        local completeCountGetter = {}
        function completeCountGetter:get(index, fullCount, itemExchangeKeyRaw)
          if nil == self._data then
            return 0
          end
          if self._data:getItemExchangeKeyRaw() ~= itemExchangeKeyRaw then
            return 0
          end
          return fullCount - self._data:getCompletePointByIndex(index)
        end
        function completeCountGetter:getCompletePointCount(itemExchangeCount)
          if nil == self._data then
            return itemExchangeCount
          end
          local exchangeCount = self._data:getCompletePointCount()
          if itemExchangeCount < exchangeCount then
            return itemExchangeCount
          else
            return exchangeCount
          end
        end
        completeCountGetter._data = guildHouseCraftInfo
        local itemExchangeSS = itemExchangeSSW:get()
        local itemExchangeCount = getExchangeSourceNeedItemList(itemExchangeSS, true)
        local exchangeCount = completeCountGetter:getCompletePointCount(itemExchangeCount)
        local workVolume = Int64toInt32(itemExchangeSS._productTime / toInt64(0, 1000))
        for enchant_Idx = 0, exchangeCount - 1 do
          local enchantSlot = self.uiPool.exchange[exchangeUi_Idx].enchant[enchant_Idx]
          local itemStaticInfomationWrapper = getExchangeSourceNeedItemByIndex(enchant_Idx)
          local itemStaticWrapper = itemStaticInfomationWrapper:getStaticStatus()
          local itemStatic = itemStaticWrapper:get()
          local gradeType = itemStaticWrapper:getGradeType()
          GuildCraft_ChangeBorder_ByItemGrade(gradeType, enchantSlot.border)
          local enchantItemKeyRaw = itemStaticInfomationWrapper:getKey():get()
          local itemIcon = "icon/" .. getItemIconPath(itemStatic)
          local fullCount = Int64toInt32(itemStaticInfomationWrapper:getCount_s64())
          local haveCount = completeCountGetter:get(enchant_Idx, fullCount, itemExchangeSSW:getExchangeKeyRaw())
          enchantSlot.icon:SetShow(true)
          enchantSlot.count:SetShow(true)
          enchantSlot.border:SetShow(true)
          enchantSlot.icon:addInputEvent("Mouse_On", "Guild_CraftInfo_EnchantItemToolTip( true,  " .. enchantItemKeyRaw .. ", " .. exchangeUi_Idx .. ", " .. enchant_Idx .. " )")
          enchantSlot.icon:addInputEvent("Mouse_Out", "Guild_CraftInfo_EnchantItemToolTip( false, " .. enchantItemKeyRaw .. ", " .. exchangeUi_Idx .. ", " .. enchant_Idx .. " )")
          enchantSlot.icon:setTooltipEventRegistFunc("Guild_CraftInfo_EnchantItemToolTip( true,  " .. enchantItemKeyRaw .. ", " .. exchangeUi_Idx .. ", " .. enchant_Idx .. " )")
          enchantSlot.icon:ChangeTextureInfoName(itemIcon)
          enchantSlot.count:SetText(haveCount .. "/" .. fullCount)
          completeWorkCount = completeWorkCount + haveCount
          totalWorkCount = totalWorkCount + fullCount
          if fullCount <= haveCount then
            enchantSlot.count:SetFontColor(UI_color.C_FF88DF00)
          else
            enchantSlot.count:SetFontColor(UI_color.C_FFE7E7E7)
          end
        end
        local recipeName = myGuildHouseCraftInfoManager:getReceipeName(self.config.recipeArray[recipeArrayKey_Idx])
        local workIcon = "icon/" .. itemExchangeSSW:getIcon()
        local itemName = itemExchangeSSW:getDescription()
        local itemStatic
        if false == itemExchangeSSW:getUseExchangeIcon() then
          itemStatic = itemExchangeSS:getFirstDropGroup():getItemStaticStatus()
          workIcon = "icon/" .. getItemIconPath(itemStatic)
        end
        exchangeSlot.icon:ChangeTextureInfoName(workIcon)
        exchangeSlot.name:SetText(recipeName .. " > " .. itemName)
        exchangeSlot.workCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_LEFTWORKCOUNT", "now", completeWorkCount, "max", totalWorkCount))
        exchangeSlot.progress:SetProgressRate(completeWorkCount / totalWorkCount * 100)
        exchangeSlot.border:SetShow(false)
        UIScroll.SetButtonSize(guildCraftInfo.control._scroll, guildCraftInfo.config.maxExchangeCount, guildCraftInfo.config.last_recipeArrayKey)
        exchangeUi_Idx = exchangeUi_Idx + 1
      end
    end
  end
  if self.config.maxExchangeCount < self.config.last_recipeArrayKey then
    guildCraftInfo.control._scroll:SetShow(true)
  else
    guildCraftInfo.control._scroll:SetShow(false)
  end
end
function Guild_CraftInfo_EnchantItemToolTip(isShow, enchantItemKeyRaw, exchangeUi_Idx, enchant_Idx)
  local enchantSlot = guildCraftInfo.uiPool.exchange[exchangeUi_Idx].enchant[enchant_Idx]
  local control = enchantSlot.icon
  local itemStaticStatus = getItemEnchantStaticStatus(ItemEnchantKey(enchantItemKeyRaw))
  if isShow then
    registTooltipControl(control, Panel_Tooltip_Item)
    Panel_Tooltip_Item_Show(itemStaticStatus, control, true, false, nil, nil, nil)
  else
    Panel_Tooltip_Item_hideTooltip()
  end
end
function Guild_CraftInfo_ScrollEvent(isScrollUp)
  guildCraftInfo.config.scroll_startIdx = UIScroll.ScrollEvent(guildCraftInfo.control._scroll, isScrollUp, guildCraftInfo.config.maxExchangeCount, guildCraftInfo.config.last_recipeArrayKey, guildCraftInfo.config.scroll_startIdx, 1)
  guildCraftInfo:Update()
end
function HandleClicked_Guild_CraftInfo_Scroll()
  local posY = guildCraftInfo.control._scroll:GetControlPos()
  guildCraftInfo.config.scroll_startIdx = math.ceil((guildCraftInfo.config.last_recipeArrayKey - guildCraftInfo.config.maxExchangeCount) * posY)
  guildCraftInfo:Update()
end
function FGlobal_Guild_CraftInfo_Init()
  guildCraftInfo:Init()
end
function FGlobal_Guild_CraftInfo_Open(isShow)
  if true == isShow then
    newPanel:SetShow(true)
    guildCraftInfo:Update()
  else
    newPanel:SetShow(false)
  end
end
function guildCraftInfo:registEventHandler()
  guildCraftInfo.control._scroll:addInputEvent("Mouse_LUp", "HandleClicked_Guild_CraftInfo_Scroll()")
  guildCraftInfo.control._scrollBTN:addInputEvent("Mouse_LPress", "HandleClicked_Guild_CraftInfo_Scroll()")
end
guildCraftInfo:registEventHandler()
