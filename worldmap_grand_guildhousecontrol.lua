Worldmap_Grand_GuildHouseControl:SetShow(false)
Worldmap_Grand_GuildHouseControl:ActiveMouseEventEffect(true)
Worldmap_Grand_GuildHouseControl:setGlassBackground(true)
local isContentsEnable = ToClient_IsContentsGroupOpen("36")
local VCK = CppEnums.VirtualKeyCode
local Panel_Control = {
  _win_Close = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Button_Win_Close"),
  _buttonQuestion = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Button_Question"),
  _txt_House_Title = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_Title")
}
local HouseInfo_Control = {
  _BG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_HouseInfo_BG"),
  _Name = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_Name"),
  _Desc = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_Desc"),
  _UseType_Icon = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_HouseInfo_UseType_Icon"),
  _UseType_Name = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_UseType_Name"),
  _UseType_Desc = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_HouseInfo_UseType_Desc"),
  _houseKeyRaw = nil
}
local HouseUseType_Control = {
  _txt_UseType_Title = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_UseType_Title"),
  _controlBG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_HouseControl_BG"),
  _scrollBar = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Scroll_ScrollBar"),
  listCount = 8,
  gradeCount = 5,
  uiList = {}
}
local HouseUseTypeState_Control = {
  _BG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_CostBG"),
  _WorkName = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkName"),
  _Icon_BG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_Working_IconBG"),
  _Icon_Working = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_Working_Icon"),
  _OnGoingText = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_OnGoing_Text"),
  _OnGoingText_Vlaue = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_OnGoing_Value"),
  _Btn_LargCraft = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Button_LargeCraft")
}
local contributePlus = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_ContributePlus")
local contributeMinus = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_ContributeMinus")
local WorkList_Control = {
  _Title = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Title"),
  _controlBG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_BG"),
  _scrollButton = nil,
  _iconBG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Button_WorkList"),
  _iconBorder = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Border"),
  _iconOver = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Over"),
  _level = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level"),
  _level_nonCraft = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level_nonCraft"),
  _guide = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Guide"),
  _guide_MyHouse = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_MyHouse_Guide"),
  _icon = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Icon"),
  _scroll = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "WorkList_ScrollBar"),
  _startSlotIndex = 0,
  _maxRow = 4,
  _totalRow = 4,
  _selecthouseKeyRaw = nil,
  _selectRecipeKeyRaw = nil,
  maxPoolNo = 4,
  maxIconRow = 6,
  titlePool = {},
  iconPool = {}
}
local HouseImage_Control = {
  _Title = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "StaticText_HouseImage_Title"),
  _BG = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_HouseImage_BG"),
  _Image = UI.getChildControl(Worldmap_Grand_GuildHouseControl, "Static_HouseImage_Image")
}
local guildHouse_Img = {
  [2110] = "icon/new_icon/03_etc/06_housing/2110.dds",
  [2140] = "icon/new_icon/03_etc/06_housing/2140.dds",
  [2183] = "icon/new_icon/03_etc/06_housing/2183.dds",
  [2188] = "icon/new_icon/03_etc/06_housing/2188.dds",
  [2228] = "icon/new_icon/03_etc/06_housing/2228.dds",
  [2427] = "icon/new_icon/03_etc/06_housing/2427.dds",
  [2503] = "icon/new_icon/03_etc/06_housing/2503.dds",
  [2569] = "icon/new_icon/03_etc/06_housing/2569.dds",
  [2608] = "icon/new_icon/03_etc/06_housing/2608.dds",
  [2647] = "icon/new_icon/03_etc/06_housing/2647.dds",
  [2691] = "icon/new_icon/03_etc/06_housing/2691.dds",
  [2704] = "icon/new_icon/03_etc/06_housing/2704.dds",
  [2858] = "icon/new_icon/03_etc/06_housing/2858.dds",
  [2880] = "icon/new_icon/03_etc/06_housing/2880.dds",
  [2905] = "icon/new_icon/03_etc/06_housing/2905.dds",
  [3351] = "icon/new_icon/03_etc/06_housing/3351.dds",
  [3352] = "icon/new_icon/03_etc/06_housing/3352.dds",
  [3353] = "icon/new_icon/03_etc/06_housing/3353.dds",
  [3354] = "icon/new_icon/03_etc/06_housing/3354.dds",
  [3355] = "icon/new_icon/03_etc/06_housing/3355.dds",
  [3356] = "icon/new_icon/03_etc/06_housing/3356.dds",
  [3357] = "icon/new_icon/03_etc/06_housing/3357.dds",
  [3358] = "icon/new_icon/03_etc/06_housing/3358.dds"
}
local guildHouseButton, ownerGuildNoRaw
local recipeData = {}
local WorkDataRow = {}
local isMyGuildHouse = false
function Panel_Control:Init()
  self._win_Close:addInputEvent("Mouse_LUp", "FGlobal_WorldMapWindowEscape()")
  HouseInfo_Control._UseType_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  HouseInfo_Control._UseType_Name:SetAutoResize(true)
  HouseInfo_Control._UseType_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  HouseInfo_Control._UseType_Desc:SetAutoResize(true)
  HouseInfo_Control._UseType_Name:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_GUILDHOUSE_TITLE"))
  HouseInfo_Control._UseType_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_GUILDHOUSE_DESC"))
end
Panel_Control:Init()
function HouseUseType_Control:Init()
  for typeIdx = 0, self.listCount - 1 do
    self.uiList[typeIdx] = {}
    local typeList = self.uiList[typeIdx]
    typeList.btn = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Button_Smithy", self._controlBG, "Grand_GuildHouseTypeList_Btn_" .. typeIdx)
    typeList.onUpgrade = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Static_A_Construction", typeList.btn, "Grand_GuildHouseTypeList_onUpgrade_" .. typeIdx)
    typeList.grade = {}
    for gradeIdx = 0, self.gradeCount - 1 do
      typeList.grade[gradeIdx] = {}
      local upgradeBtn = typeList.grade[gradeIdx]
      upgradeBtn.BG = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Button_Smithy_1", typeList.btn, "Grand_GuildHouseTypeList_gradeBG_" .. typeIdx .. "_" .. gradeIdx)
      upgradeBtn.Mask = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Static_Smithy_Mask", typeList.btn, "Grand_GuildHouseTypeList_gradeMask_" .. typeIdx .. "_" .. gradeIdx)
      upgradeBtn.BG:SetSpanSize(195 + upgradeBtn.BG:GetSizeX() * gradeIdx, 2)
      upgradeBtn.Mask:SetSpanSize(195 + upgradeBtn.BG:GetSizeX() * gradeIdx, 2)
      upgradeBtn.BG:SetShow(false)
      upgradeBtn.Mask:SetShow(false)
    end
    typeList.btn:SetSpanSize(0, typeList.btn:GetSizeY() * typeIdx + 3)
    typeList.onUpgrade:SetSpanSize(0, 3)
    typeList.btn:SetShow(false)
    typeList.onUpgrade:SetShow(false)
  end
  self._scrollBar:SetControlPos(0)
end
HouseUseType_Control:Init()
function HouseUseTypeState_Control:Init()
  self._Btn_LargCraft:SetShow(false)
  self._WorkName:SetShow(true)
  self._Icon_BG:SetShow(true)
  self._Icon_Working:SetShow(true)
  self._OnGoingText:SetShow(true)
  self._OnGoingText_Vlaue:SetShow(true)
  self._Btn_LargCraft:addInputEvent("Mouse_LUp", "Worldmap_Grand_GuildCraft_Open()")
end
HouseUseTypeState_Control:Init()
function WorkList_Control:Init()
  for titleIdx = 0, self.maxPoolNo - 1 do
    self.titlePool[titleIdx] = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "StaticText_WorkList_Level", self._controlBG, "Grand_GuildHouseWorkList_LevTitle_" .. titleIdx)
    self.titlePool[titleIdx]:SetSpanSize(0, (self.titlePool[titleIdx]:GetSizeY() + 24) * titleIdx + 20)
    self.titlePool[titleIdx]:SetShow(false)
  end
  for iconRowIdx = 0, self.maxPoolNo - 1 do
    self.iconPool[iconRowIdx] = {}
    for iconColIdx = 0, self.maxIconRow - 1 do
      self.iconPool[iconRowIdx][iconColIdx] = {}
      local slotPool = self.iconPool[iconRowIdx][iconColIdx]
      slotPool.bg = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Button_WorkList", self._controlBG, "Grand_GuildHouseWorkList_IconBG_" .. iconRowIdx .. "_" .. iconColIdx)
      slotPool.icon = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Button_WorkList", slotPool.bg, "Grand_GuildHouseWorkList_Icon_" .. iconRowIdx .. "_" .. iconColIdx)
      slotPool.border = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Border", slotPool.bg, "Grand_GuildHouseWorkList_IconBorder_" .. iconRowIdx .. "_" .. iconColIdx)
      slotPool.over = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Over", slotPool.bg, "Grand_GuildHouseWorkList_IconOver_" .. iconRowIdx .. "_" .. iconColIdx)
      slotPool.count = UI.createAndCopyBasePropertyControl(Worldmap_Grand_GuildHouseControl, "Static_WorkList_Count", slotPool.bg, "Grand_GuildHouseWorkList_Count_" .. iconRowIdx .. "_" .. iconColIdx)
      local spanSizeX = (slotPool.bg:GetSizeX() + 5) * iconColIdx + 14
      local spanSizeY = slotPool.bg:GetSizeY() * iconRowIdx
      slotPool.bg:SetSpanSize(spanSizeX, spanSizeY)
      slotPool.icon:SetSpanSize(0, 0)
      slotPool.border:SetSpanSize(0, 0)
      slotPool.over:SetSpanSize(0, 0)
      slotPool.count:SetSpanSize(5, 5)
      slotPool.bg:SetShow(false)
      slotPool.icon:SetShow(false)
      slotPool.border:SetShow(false)
      slotPool.over:SetShow(false)
      slotPool.count:SetShow(false)
      slotPool.icon:SetIgnore(false)
    end
  end
  self._scroll:SetControlPos(0)
  self._controlBG:SetIgnore(false)
  self._controlBG:addInputEvent("Mouse_UpScroll", "GuildHouse_WorkList_ScrollEvent( true )")
  self._controlBG:addInputEvent("Mouse_DownScroll", "GuildHouse_WorkList_ScrollEvent( false )")
  local nameSizeY = HouseInfo_Control._UseType_Name:GetTextSizeY()
  local descSizeY = HouseInfo_Control._UseType_Desc:GetTextSizeY()
  local bgSizeY = HouseInfo_Control._BG:GetSizeY()
  if bgSizeY < nameSizeY + descSizeY then
    HouseInfo_Control._UseType_Name:SetPosY(HouseInfo_Control._UseType_Name:GetPosY() - (nameSizeY + descSizeY - bgSizeY))
    HouseInfo_Control._UseType_Desc:SetPosY(HouseInfo_Control._UseType_Desc:GetPosY() - (nameSizeY + descSizeY - bgSizeY))
  end
end
WorkList_Control:Init()
function GuildHouse_WorkList_ScrollEvent(isScrollUp)
  WorkList_Control._startSlotIndex = UIScroll.ScrollEvent(WorkList_Control._scroll, isScrollUp, WorkList_Control._maxRow, WorkList_Control._totalRow, WorkList_Control._startSlotIndex, 1)
  GuildHouse_WorkList_Update(WorkList_Control._selecthouseKeyRaw, WorkList_Control._selectRecipeKeyRaw)
end
function HouseImage_Control:Init()
end
HouseImage_Control:Init()
function GuildHouse_WorkList_SetData()
  WorkDataRow = {}
  WorkList_Control._totalRow = 0
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(WorkList_Control._selecthouseKeyRaw)
  local recipeCount = guildHouseInfoSSW:getReceipeCount()
  for recipeIdx = 0, recipeCount - 1 do
    local houseCraftWrapper = guildHouseInfoSSW:getHouseCraftWrapperByIndex(recipeIdx)
    local recipeKeyRaw = houseCraftWrapper:getReceipeKeyRaw()
    if recipeKeyRaw == WorkList_Control._selectRecipeKeyRaw then
      local maxLevel = guildHouseInfoSSW:getMaxLevel(recipeKeyRaw)
      WorkDataRow[WorkList_Control._totalRow] = {}
      for level = 1, maxLevel do
        WorkDataRow[WorkList_Control._totalRow] = {
          isTitle = true,
          level = level,
          value1 = nil,
          value2 = nil,
          receipeKey = recipeKeyRaw
        }
        WorkList_Control._totalRow = WorkList_Control._totalRow + 1
        local exchangeCount = guildHouseInfoSSW:getItemExchangeListCount(recipeKeyRaw, level)
        local exchangeCol = math.ceil(exchangeCount / WorkList_Control.maxIconRow + 0.5)
        for exchangeColIdx = 0, exchangeCol - 1 do
          local startIdx = exchangeColIdx * WorkList_Control.maxIconRow
          local endIdx = exchangeColIdx * (WorkList_Control.maxIconRow - 1) + WorkList_Control.maxIconRow
          if exchangeCount < endIdx then
            endIdx = exchangeCount
          end
          WorkDataRow[WorkList_Control._totalRow] = {
            isTitle = false,
            level = level,
            value1 = startIdx,
            value2 = endIdx,
            receipeKey = recipeKeyRaw
          }
          WorkList_Control._totalRow = WorkList_Control._totalRow + 1
        end
      end
    end
  end
end
function GuildHouse_WorkList_Update(houseKeyRaw, _recipeKeyRaw)
  WorkList_Control._selecthouseKeyRaw = houseKeyRaw
  WorkList_Control._selectRecipeKeyRaw = _recipeKeyRaw
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(WorkList_Control._selecthouseKeyRaw)
  GuildHouse_WorkList_SetData()
  for titleIdx = 0, WorkList_Control.maxPoolNo - 1 do
    WorkList_Control.titlePool[titleIdx]:SetShow(false)
  end
  for iconRowIdx = 0, WorkList_Control.maxPoolNo - 1 do
    for iconColIdx = 0, WorkList_Control.maxIconRow - 1 do
      local slotPool = WorkList_Control.iconPool[iconRowIdx][iconColIdx]
      slotPool.bg:SetShow(false)
      slotPool.icon:SetShow(false)
      slotPool.border:SetShow(false)
      slotPool.over:SetShow(false)
      slotPool.count:SetShow(false)
      slotPool.icon:addInputEvent("Mouse_On", "")
      slotPool.icon:addInputEvent("Mouse_Out", "")
    end
  end
  local uiSlotNo = 0
  for rowNo = WorkList_Control._startSlotIndex, WorkList_Control._totalRow - 1 do
    if uiSlotNo > 3 then
      break
    end
    local dataArray = WorkDataRow[rowNo]
    if true == dataArray.isTitle then
      WorkList_Control.titlePool[uiSlotNo]:SetShow(true)
      WorkList_Control.titlePool[uiSlotNo]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_RECIPEGRADE_TITLE", "grade", dataArray.level))
    else
      local startIdx = dataArray.value1
      local endIdx = dataArray.value2
      local exchangeCount = guildHouseInfoSSW:getItemExchangeListCount(WorkList_Control._selectRecipeKeyRaw, dataArray.level)
      for Idx = 0, WorkList_Control.maxIconRow - 1 do
        if endIdx <= startIdx + Idx then
          break
        end
        local dataIdx = startIdx + Idx
        local slotPool = WorkList_Control.iconPool[uiSlotNo][Idx]
        local itemExchangeSSW = guildHouseInfoSSW:getItemExchangeByIndex(dataIdx)
        if itemExchangeSSW:isSet() then
          slotPool.bg:SetShow(true)
          slotPool.icon:SetShow(true)
          slotPool.border:SetShow(false)
          slotPool.over:SetShow(false)
          local exchangeKeyRaw = itemExchangeSSW:getExchangeKeyRaw()
          local itemExchangeSS = itemExchangeSSW:get()
          local workIcon = "icon/" .. itemExchangeSSW:getIcon()
          local itemStatic
          if false == itemExchangeSSW:getUseExchangeIcon() then
            itemStatic = itemExchangeSS:getFirstDropGroup():getItemStaticStatus()
            workIcon = "icon/" .. getItemIconPath(itemStatic)
          end
          slotPool.icon:ChangeTextureInfoName(workIcon)
          slotPool.icon:addInputEvent("Mouse_On", "GuildHouse_WorkList_ItemToolTip( true, " .. rowNo .. ", " .. dataIdx .. ", " .. uiSlotNo .. ", " .. Idx .. " )")
          slotPool.icon:addInputEvent("Mouse_Out", "GuildHouse_WorkList_ItemToolTip( false," .. rowNo .. ", " .. dataIdx .. ", " .. uiSlotNo .. ", " .. Idx .. " )")
          slotPool.icon:addInputEvent("Mouse_LUp", "GuildHouse_HandleClickedWorkListIcon( " .. rowNo .. ", " .. dataIdx .. ", " .. uiSlotNo .. ", " .. Idx .. " )")
          if isMyGuildHouse then
            local MyGuildHouseCraftInfoManager = getSelfPlayer():getGuildHouseCraftInfoManager()
            local maxDailyWorkingCount = itemExchangeSSW:getMaxDailyWorkingCount()
            local DailyWorkingCount = MyGuildHouseCraftInfoManager:getDailyWorkingCount(exchangeKeyRaw)
            slotPool.count:SetShow(true)
            slotPool.count:SetText(tostring(DailyWorkingCount) .. "/" .. tostring(maxDailyWorkingCount))
          end
        end
      end
    end
    uiSlotNo = uiSlotNo + 1
  end
  local isScrollShow = false
  if WorkList_Control._totalRow > 4 then
    isScrollShow = true
  end
  WorkList_Control._scroll:SetShow(isScrollShow)
  UIScroll.SetButtonSize(WorkList_Control._scroll, WorkList_Control._maxRow, WorkList_Control._totalRow)
end
function GuildHouse_WorkList_ItemToolTip(isShow, rowNo, dataIdx, uiSlotNo, Idx)
  if true == isShow then
    local dataArray = WorkDataRow[rowNo]
    local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(WorkList_Control._selecthouseKeyRaw)
    local exchangeCount = guildHouseInfoSSW:getItemExchangeListCount(dataArray.receipeKey, dataArray.level)
    local itemExchangeSSW = guildHouseInfoSSW:getItemExchangeByIndex(dataIdx)
    local control = WorkList_Control.iconPool[uiSlotNo][Idx].icon
    if itemExchangeSSW:isSet() then
      FGlobal_Show_Tooltip_Work(itemExchangeSSW, control)
    end
  else
    local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(WorkList_Control._selecthouseKeyRaw)
    local itemExchangeSSW = guildHouseInfoSSW:getItemExchangeByIndex(dataIdx)
    if itemExchangeSSW:isSet() then
      FGlobal_Hide_Tooltip_Work(itemExchangeSSW, true)
    end
  end
end
function GuildHouse_HandleClickedWorkListIcon(rowNo, dataIdx, uiSlotNo, Idx)
  if isKeyPressed(VCK.KeyCode_CONTROL) then
    local dataArray = WorkDataRow[rowNo]
    local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(WorkList_Control._selecthouseKeyRaw)
    local exchangeCount = guildHouseInfoSSW:getItemExchangeListCount(dataArray.receipeKey, dataArray.level)
    local itemExchangeSSW = guildHouseInfoSSW:getItemExchangeByIndex(dataIdx)
    if itemExchangeSSW:isSet() then
      FGlobal_Show_Tooltip_Work_Copy(itemExchangeSSW)
    end
  end
end
function HouseUseType_Control:Update()
  recipeData = {}
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(HouseInfo_Control._houseKeyRaw)
  local houseKeyRaw = HouseInfo_Control._houseKeyRaw
  if nil ~= guildHouseInfoSSW then
    Worldmap_Grand_GuildHouseControl:SetShow(true)
    for typeIdx = 0, HouseUseType_Control.listCount - 1 do
      local typeList = HouseUseType_Control.uiList[typeIdx]
      for gradeIdx = 0, HouseUseType_Control.gradeCount - 1 do
        local upgradeBtn = typeList.grade[gradeIdx]
        upgradeBtn.BG:SetShow(false)
        upgradeBtn.Mask:SetShow(false)
      end
      typeList.btn:SetShow(false)
      typeList.onUpgrade:SetShow(false)
    end
    local MyGuildHouseCraftInfoManager = getSelfPlayer():getGuildHouseCraftInfoManager()
    local recipeLevelCount = MyGuildHouseCraftInfoManager:getReceipeLevelCount()
    local recipeCount = guildHouseInfoSSW:getReceipeCount()
    local uiCount = 0
    for recipeIdx = 0, recipeCount - 1 do
      local houseInfoCraftWrapper = guildHouseInfoSSW:getHouseCraftWrapperByIndex(recipeIdx)
      local maxLevel = houseInfoCraftWrapper:getLevel()
      local recipeName = houseInfoCraftWrapper:getReciepeName()
      local recipeKeyRaw = houseInfoCraftWrapper:getReceipeKeyRaw()
      local currentLevel = MyGuildHouseCraftInfoManager:getLevel(recipeKeyRaw)
      local groupType = houseInfoCraftWrapper:getGroupType()
      if CppEnums.eHouseUseType.Depot ~= groupType then
        local typeList = HouseUseType_Control.uiList[uiCount]
        typeList.btn:SetText(recipeName)
        typeList.btn:addInputEvent("Mouse_LUp", "GuildHouse_WorkList_Update( " .. houseKeyRaw .. ", " .. recipeKeyRaw .. " )")
        for gradeIdx = 0, maxLevel - 1 do
          local upgradeBtn = typeList.grade[gradeIdx]
          upgradeBtn.BG:SetShow(true)
          upgradeBtn.Mask:SetShow(false)
          upgradeBtn.BG:ChangeTextureInfoName("new_ui_common_forlua/window/houseinfo/housecontrol_00.dds")
          local x1, y1, x2, y2
          if currentLevel >= gradeIdx + 1 then
            x1, y1, x2, y2 = setTextureUV_Func(upgradeBtn.BG, 1, 52, 19, 70)
          else
            x1, y1, x2, y2 = setTextureUV_Func(upgradeBtn.BG, 1, 33, 19, 51)
          end
          upgradeBtn.BG:getBaseTexture():setUV(x1, y1, x2, y2)
          upgradeBtn.BG:setRenderTexture(upgradeBtn.BG:getBaseTexture())
        end
        typeList.btn:SetShow(true)
        typeList.onUpgrade:SetShow(false)
        uiCount = uiCount + 1
      end
    end
    if uiCount > HouseUseType_Control.listCount then
      HouseUseType_Control._scrollBar:SetShow(true)
    else
      HouseUseType_Control._scrollBar:SetShow(false)
    end
  end
end
function HouseUseTypeState_Control:Update()
  local guildHouseInfoSSW = ToClient_getHouseholdInfoInClientWrapper(HouseInfo_Control._houseKeyRaw)
  ownerGuildNoRaw = guildHouseInfoSSW:getOwnerGuildNo()
  local myGuildWrapper = ToClient_GetMyGuildInfoWrapper()
  local myGuildNoRaw = getSelfPlayer():getGuildNo_s64()
  local guildName = ToClient_guild_getGuildName(ownerGuildNoRaw)
  local guildMasterName = ToClient_guild_getGuildMasterName(ownerGuildNoRaw)
  self._WorkName:SetText(guildName)
  self._OnGoingText_Vlaue:SetText(guildMasterName)
  self._Icon_Working:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
  local isSet = setGuildTextureByGuildNo(ownerGuildNoRaw, self._Icon_Working)
  if false == isSet then
    local x1, y1, x2, y2 = setTextureUV_Func(self._Icon_Working, 183, 1, 188, 6)
    self._Icon_Working:getBaseTexture():setUV(x1, y1, x2, y2)
    self._Icon_Working:setRenderTexture(self._Icon_Working:getBaseTexture())
  else
    self._Icon_Working:getBaseTexture():setUV(0, 0, 1, 1)
    self._Icon_Working:setRenderTexture(self._Icon_Working:getBaseTexture())
  end
  if myGuildNoRaw == ownerGuildNoRaw and nil ~= myGuildWrapper then
    isMyGuildHouse = true
  else
    isMyGuildHouse = false
  end
  if false == _ContentsGroup_GuildManufacture then
    HouseUseTypeState_Control._Btn_LargCraft:SetShow(isMyGuildHouse)
  end
end
function FGlobal_HouseUseTypeState_Update(guildNoRaw)
  if Worldmap_Grand_GuildHouseControl:GetShow() and guildNoRaw == ownerGuildNoRaw then
    local guildName = ToClient_guild_getGuildName(guildNoRaw)
    local guildMasterName = ToClient_guild_getGuildMasterName(guildNoRaw)
    HouseUseTypeState_Control._WorkName:SetText(guildName)
    HouseUseTypeState_Control._OnGoingText_Vlaue:SetText(guildMasterName)
    HouseUseTypeState_Control._Icon_Working:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local isSet = setGuildTextureByGuildNo(guildNoRaw, HouseUseTypeState_Control._Icon_Working)
    if false == isSet then
      local x1, y1, x2, y2 = setTextureUV_Func(HouseUseTypeState_Control._Icon_Working, 183, 1, 188, 6)
      HouseUseTypeState_Control._Icon_Working:getBaseTexture():setUV(x1, y1, x2, y2)
      HouseUseTypeState_Control._Icon_Working:setRenderTexture(HouseUseTypeState_Control._Icon_Working:getBaseTexture())
    else
      HouseUseTypeState_Control._Icon_Working:getBaseTexture():setUV(0, 0, 1, 1)
      HouseUseTypeState_Control._Icon_Working:setRenderTexture(HouseUseTypeState_Control._Icon_Working:getBaseTexture())
    end
    ownerGuildNoRaw = nil
  else
  end
end
function HouseImage_Control:Update()
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(HouseInfo_Control._houseKeyRaw)
  local getKeyRaw = HouseInfo_Control._houseKeyRaw
  if nil ~= guildHouse_Img[getKeyRaw] then
    self._Image:ChangeTextureInfoName(guildHouse_Img[getKeyRaw])
  else
    self._Image:ChangeTextureInfoName("icon/new_icon/03_etc/06_housing/1201.dds")
  end
end
function Worldmap_Grand_GuildHouseControl_Close()
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(HouseInfo_Control._houseKeyRaw)
  local wayPointKey = guildHouseInfoSSW:getParentNodeKey()
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(wayPointKey)
  if nil ~= regionInfoWrapper and regionInfoWrapper:hasWarehouseManager() then
    warehouse_requestInfo(wayPointKey)
  end
  guildHouseButton = nil
end
function Worldmap_Grand_GuildCraft_Open()
  if nil == WorkList_Control._selecthouseKeyRaw or nil == WorkList_Control._selectRecipeKeyRaw then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_PLZ_SELECT_USETYPE"))
    return
  end
  WorldMapPopupManager:increaseLayer(false)
  WorldMapPopupManager:push(Worldmap_Grand_GuildCraft, true, nil, Worldmap_Grand_GuildCraftControl_Update)
  FGlobal_GuildCraft_Open(WorkList_Control._selecthouseKeyRaw, WorkList_Control._selectRecipeKeyRaw)
end
function Worldmap_Grand_GuildCraftControl_Update()
  if Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  end
  HouseUseType_Control:Update()
  HouseUseTypeState_Control:Update()
  HouseImage_Control:Update()
  local guildHouseInfoSSW = ToClient_GetGuildHouseInfoStaticStatusWrapper(HouseInfo_Control._houseKeyRaw)
  local houseKeyRaw = HouseInfo_Control._houseKeyRaw
  local houseName = guildHouseInfoSSW:getHouseName()
  Panel_Control._txt_House_Title:SetText(houseName)
  local recipeCount = guildHouseInfoSSW:getReceipeCount()
  for index = 0, recipeCount - 1 do
    local houseCraftWrapper = guildHouseInfoSSW:getHouseCraftWrapperByIndex(index)
    local recipeKeyRaw = houseCraftWrapper:getReceipeKeyRaw()
    local groupType = houseCraftWrapper:getGroupType()
    if CppEnums.eHouseUseType.Depot ~= groupType then
      GuildHouse_WorkList_Update(houseKeyRaw, recipeKeyRaw)
      for typeIdx = 0, HouseUseType_Control.listCount - 1 do
        local typeList = HouseUseType_Control.uiList[typeIdx]
        if 0 == typeIdx then
          typeList.btn:SetCheck(true)
        else
          typeList.btn:SetCheck(false)
        end
      end
      break
    end
  end
  local guildHouseWrapper = ToClient_getHouseholdInfoInClientWrapper(HouseInfo_Control._houseKeyRaw)
  if guildHouseWrapper:getOwnerGuildNo() == getSelfPlayer():getGuildNo_s64() then
    warehouse_requestGuildWarehouseInfo()
  end
end
function FromClient_WorldMapGuildHouseLClick(guildUIButton)
  if true == _ContentsGroup_GrowStep and false == ToClient_IsGrowStepOpen(__eGrowStep_node) then
    return
  end
  if not isContentsEnable then
    return
  end
  local guildHouseInfoSSW = guildUIButton:getGuildHouseInfoStaticStatusWrapper()
  HouseInfo_Control._houseKeyRaw = guildHouseInfoSSW:getKeyRaw()
  Worldmap_Grand_GuildCraftControl_Update()
  WorldMapPopupManager:increaseLayer(true)
  WorldMapPopupManager:push(Worldmap_Grand_GuildHouseControl, true, nil, nil)
end
function GuildCraftControl_onScreenResize()
  Worldmap_Grand_GuildHouseControl:ComputePos()
end
registerEvent("FromClient_WorldMapGuildHouseLClick", "FromClient_WorldMapGuildHouseLClick")
registerEvent("onScreenResize", "GuildCraftControl_onScreenResize")
