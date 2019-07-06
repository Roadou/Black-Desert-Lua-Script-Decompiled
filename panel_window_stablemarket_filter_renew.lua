local Panel_Window_StableMarket_Filter_info = {
  _ui = {
    static_Filter = nil,
    button_SexFilter = nil,
    button_TierFilter = nil,
    button_SkillFilter = nil,
    list2_1_SelectFilter = nil,
    list2_1_SelectFilter_Content = nil,
    radioButton_Templete = nil,
    buttonList = {},
    static_Bottombg = nil
  },
  _value = {
    step1LastIndex = -1,
    step1CurrentIndex = -1,
    step2LastIndex = -1,
    step2CurrentIndex = -1,
    step3LastIndex = -1,
    step3CurrentIndex = -1,
    currentFilter = -1,
    filterSkillCount = 0
  },
  _enum = {
    eFILTER_TYPE_NONE = -1,
    eFILTER_TYPE_SEX = 0,
    eFILTER_TYPE_TIER = 1,
    eFILTER_TYPE_SKILL = 2
  },
  _config = {stepCount = 3},
  _defaultNum = {
    [0] = 2,
    [1] = 0,
    [2] = 0
  },
  _pos = {
    ["startPosY"] = 0,
    ["buttonPosSizeY"] = 0,
    ["buttonPosSpaceY"] = 2,
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0
  },
  _skillData = {
    [0] = nil
  }
}
local isContentsStallionEnable = ToClient_IsContentsGroupOpen("243")
local isContentsNineTierEnable = ToClient_IsContentsGroupOpen("80")
local isContentsEightTierEnable = ToClient_IsContentsGroupOpen("29")
local filterText = {
  [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_FILTER_SEX"),
  [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_FILTER_TIER"),
  [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_STABLE_FILTER_SKILL")
}
local tierFilterString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_7"),
  [8] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_GENERATION_FILTER_8"),
  [9] = PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_TEXT_TIER9")
}
local sexFilterString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_SEXFILTER_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_SEXFILTER_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_SEXFILTER_2")
}
local skillFilterString = {
  [-1] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL"),
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEMARKET_FILTER_ALL")
}
function Panel_Window_StableMarket_Filter_info:registEventHandler()
  PaGlobal_registerPanelOnBlackBackground(Panel_Window_StableMarket_Filter)
  Panel_Window_StableMarket_Filter:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_StableMarket_Filter_Confirm()")
end
function Panel_Window_StableMarket_Filter_info:registerMessageHandler()
end
function Panel_Window_StableMarket_Filter_info:setSkillData()
  local filterSkillCount = 1
  local skillCount = vehicleSkillStaticStatus_skillCount()
  for index = 1, skillCount do
    local skillWrapper = getVehicleSkillStaticStatus(index)
    if nil ~= skillWrapper and true == skillWrapper:isMarketFilter() then
      skillFilterString[filterSkillCount] = skillWrapper:getName()
      self._skillData[filterSkillCount] = index
      filterSkillCount = filterSkillCount + 1
    end
  end
  self._value.filterSkillCount = filterSkillCount
end
function Panel_Window_StableMarket_Filter_info:initialize()
  self:childControl()
  self:initValue()
  self:initPos()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_StableMarket_Filter_info:initValue()
  self._value.step1LastIndex = -1
  self._value.step1CurrentIndex = -1
  self._value.step2LastIndex = -1
  self._value.step2CurrentIndex = -1
  self._value.step3LastIndex = -1
  self._value.step3CurrentIndex = -1
  self._value.currentFilter = self._enum.eFILTER_TYPE_NONE
end
function Panel_Window_StableMarket_Filter_info:initPos()
  self._pos.buttonPosSizeY = self._ui.radioButton_Templete:GetSizeY()
  for index = 0, 5 do
    self._pos[index] = self._pos.startPosY + (self._pos.buttonPosSizeY + self._pos.buttonPosSpaceY) * index
  end
end
function Panel_Window_StableMarket_Filter_info:resize()
end
function Panel_Window_StableMarket_Filter_info:childControl()
  self._ui.static_Filter = UI.getChildControl(Panel_Window_StableMarket_Filter, "Static_Filter")
  self._ui.button_SexFilter = UI.getChildControl(self._ui.static_Filter, "Button_SexFilter")
  self._ui.buttonList[self._enum.eFILTER_TYPE_SEX] = self._ui.button_SexFilter
  self._ui.button_SexFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickFilter(" .. self._enum.eFILTER_TYPE_SEX .. ")")
  self._ui.button_TierFilter = UI.getChildControl(self._ui.static_Filter, "Button_TierFilter")
  self._ui.buttonList[self._enum.eFILTER_TYPE_TIER] = self._ui.button_TierFilter
  self._ui.button_TierFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickFilter(" .. self._enum.eFILTER_TYPE_TIER .. ")")
  self._ui.button_SkillFilter = UI.getChildControl(self._ui.static_Filter, "Button_SkillFilter")
  self._ui.buttonList[self._enum.eFILTER_TYPE_SKILL] = self._ui.button_SkillFilter
  self._ui.button_SkillFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickFilter(" .. self._enum.eFILTER_TYPE_SKILL .. ")")
  self._ui.list2_1_SelectFilter = UI.getChildControl(self._ui.static_Filter, "List2_1_SelectFilter")
  self._ui.list2_1_SelectFilter_Content = UI.getChildControl(self._ui.list2_1_SelectFilter, "List2_1_SelectFilter_Content")
  self._ui.radioButton_Templete = UI.getChildControl(self._ui.list2_1_SelectFilter_Content, "RadioButton_Templete")
  self._ui.list2_1_SelectFilter:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_StableMarket_Filter_Create")
  self._ui.list2_1_SelectFilter:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.static_Bottombg = UI.getChildControl(Panel_Window_StableMarket_Filter, "Static_BottomBg")
  self._ui.staticText_keyguide_Y = UI.getChildControl(self._ui.static_Bottombg, "StaticText_Select_ConsoleUI")
  self._ui.staticText_keyguide_B = UI.getChildControl(self._ui.static_Bottombg, "StaticText_NO_ConsoleUI")
  local tempBtnGroup = {
    self._ui.staticText_keyguide_Y,
    self._ui.staticText_keyguide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_Bottombg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Panel_Window_StableMarket_Filter_info:setContent()
  self:setContentPos()
  self:setFilterButtonText()
  if self._value.currentFilter == self._enum.eFILTER_TYPE_NONE then
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SEX then
    self:setFilterListSex()
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_TIER then
    self:setFilterListTier()
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SKILL then
    self:setFilterListSkill()
  end
  ToClient_padSnapResetControl()
end
function Panel_Window_StableMarket_Filter_info:setFilterButtonText()
  for index = 0, self._enum.eFILTER_TYPE_SKILL do
    local newText = filterText[index]
    if index == self._enum.eFILTER_TYPE_SEX then
      if -1 == self._value.step1CurrentIndex then
        newText = newText .. " : " .. sexFilterString[self._defaultNum[index]]
      else
        newText = newText .. " : " .. sexFilterString[self._value.step1CurrentIndex]
      end
    end
    if index == self._enum.eFILTER_TYPE_TIER then
      if -1 == self._value.step2CurrentIndex then
        newText = newText .. " : " .. tierFilterString[self._defaultNum[index]]
      else
        newText = newText .. " : " .. tierFilterString[self._value.step2CurrentIndex]
      end
    end
    if index == self._enum.eFILTER_TYPE_SKILL then
      if -1 == self._value.step3CurrentIndex then
        newText = newText .. " : " .. skillFilterString[self._defaultNum[index]]
      elseif nil ~= skillFilterString[self._value.step3CurrentIndex] then
        newText = newText .. " : " .. skillFilterString[self._value.step3CurrentIndex]
      end
    end
    self._ui.buttonList[index]:SetText(newText)
  end
end
function Panel_Window_StableMarket_Filter_info:setFilterListSex()
  self._ui.list2_1_SelectFilter:getElementManager():clearKey()
  self._ui.list2_1_SelectFilter:SetShow(false)
  for index = 0, 2 do
    self._ui.list2_1_SelectFilter:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_1_SelectFilter:requestUpdateByKey(toInt64(0, index))
  end
  self._ui.list2_1_SelectFilter:SetShow(true)
end
function Panel_Window_StableMarket_Filter_info:setFilterListTier()
  self._ui.list2_1_SelectFilter:getElementManager():clearKey()
  self._ui.list2_1_SelectFilter:SetShow(false)
  local tierCount = 9
  if not isContentsNineTierEnable then
    tierCount = 8
  end
  if not isContentsEightTierEnable then
    tierCount = 7
  end
  if tierCount > 0 then
    self._ui.list2_1_SelectFilter:SetShow(true)
  end
  for index = 0, tierCount do
    self._ui.list2_1_SelectFilter:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_1_SelectFilter:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_StableMarket_Filter_info:setFilterListSkill()
  self._ui.list2_1_SelectFilter:getElementManager():clearKey()
  self._ui.list2_1_SelectFilter:SetShow(false)
  if 0 < self._value.filterSkillCount then
    self._ui.list2_1_SelectFilter:SetShow(true)
  end
  for index = 0, self._value.filterSkillCount - 1 do
    self._ui.list2_1_SelectFilter:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_1_SelectFilter:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_StableMarket_Filter_info:setContentPos()
  if self._value.currentFilter == self._enum.eFILTER_TYPE_NONE then
    self._ui.list2_1_SelectFilter:SetShow(false)
    self._ui.button_SexFilter:SetPosY(self._pos[0])
    self._ui.button_TierFilter:SetPosY(self._pos[1])
    self._ui.button_SkillFilter:SetPosY(self._pos[2])
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SEX then
    self._ui.list2_1_SelectFilter:SetShow(true)
    self._ui.button_SexFilter:SetPosY(self._pos[0])
    self._ui.list2_1_SelectFilter:SetPosY(self._pos[1])
    self._ui.button_TierFilter:SetPosY(self._pos[4])
    self._ui.button_SkillFilter:SetPosY(self._pos[5])
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_TIER then
    self._ui.list2_1_SelectFilter:SetShow(true)
    self._ui.button_SexFilter:SetPosY(self._pos[0])
    self._ui.button_TierFilter:SetPosY(self._pos[1])
    self._ui.list2_1_SelectFilter:SetPosY(self._pos[2])
    self._ui.button_SkillFilter:SetPosY(self._pos[5])
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SKILL then
    self._ui.list2_1_SelectFilter:SetShow(true)
    self._ui.button_SexFilter:SetPosY(self._pos[0])
    self._ui.button_TierFilter:SetPosY(self._pos[1])
    self._ui.button_SkillFilter:SetPosY(self._pos[2])
    self._ui.list2_1_SelectFilter:SetPosY(self._pos[3])
  end
end
function Panel_Window_StableMarket_Filter_info:open()
  if false == Panel_Window_StableMarket_Filter:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(8, 14)
  end
  Panel_Window_StableMarket_Filter:SetShow(true)
end
function Panel_Window_StableMarket_Filter_info:close()
  if Panel_Window_StableMarket_Filter:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(50, 3)
  end
  Panel_Window_StableMarket_Filter:SetShow(false)
end
function PaGlobalFunc_StableMarket_Filter_GetShow()
  return Panel_Window_StableMarket_Filter:GetShow()
end
function PaGlobalFunc_StableMarket_Filter_Open()
  local self = Panel_Window_StableMarket_Filter_info
  self:close()
end
function PaGlobalFunc_StableMarket_Filter_Close()
  local self = Panel_Window_StableMarket_Filter_info
  self:close()
end
function PaGlobalFunc_StableMarket_Filter_Show()
  local self = Panel_Window_StableMarket_Filter_info
  self:initValue()
  self:setContent()
  self:setSkillData()
  self:open()
end
function PaGlobalFunc_StableMarket_Filter_Create(list_content, key)
  local self = Panel_Window_StableMarket_Filter_info
  local id = Int64toInt32(key)
  local radioButton_Templete = UI.getChildControl(list_content, "RadioButton_Templete")
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SEX then
    radioButton_Templete:SetCheck(id == self._value.step1CurrentIndex)
    radioButton_Templete:SetText(sexFilterString[id])
    radioButton_Templete:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickSex(" .. id .. ")")
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_TIER then
    radioButton_Templete:SetCheck(id == self._value.step2CurrentIndex)
    radioButton_Templete:SetText(tierFilterString[id])
    radioButton_Templete:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickTier(" .. id .. ")")
  end
  if self._value.currentFilter == self._enum.eFILTER_TYPE_SKILL then
    radioButton_Templete:SetCheck(id == self._value.step3CurrentIndex)
    radioButton_Templete:SetText(skillFilterString[id])
    radioButton_Templete:addInputEvent("Mouse_LUp", "PaGlobalFunc_StableMarket_Filter_ClickSkill(" .. id .. ")")
  end
end
function PaGlobalFunc_StableMarket_Filter_ClickFilter(index)
  local self = Panel_Window_StableMarket_Filter_info
  self._value.currentFilter = index
  self:setContent()
end
function PaGlobalFunc_StableMarket_Filter_ClickSex(index)
  local self = Panel_Window_StableMarket_Filter_info
  self._value.step1CurrentIndex = index
  self:setFilterButtonText()
end
function PaGlobalFunc_StableMarket_Filter_ClickTier(index)
  local self = Panel_Window_StableMarket_Filter_info
  self._value.step2CurrentIndex = index
  self:setFilterButtonText()
end
function PaGlobalFunc_StableMarket_Filter_ClickSkill(index)
  local self = Panel_Window_StableMarket_Filter_info
  self._value.step3CurrentIndex = index
  self:setFilterButtonText()
end
function PaGlobalFunc_StableMarket_Filter_Confirm()
  local self = Panel_Window_StableMarket_Filter_info
  local filterSex = self._defaultNum[self._enum.eFILTER_TYPE_SEX]
  if -1 ~= self._value.step1CurrentIndex then
    filterSex = self._value.step1CurrentIndex
  end
  local filterTier = self._defaultNum[self._enum.eFILTER_TYPE_TIER]
  if -1 ~= self._value.step2CurrentIndex then
    filterTier = self._value.step2CurrentIndex
  end
  local filterSkill = self._defaultNum[self._enum.eFILTER_TYPE_SKILL]
  if -1 == self._value.step3CurrentIndex or 0 == self._value.step3CurrentIndex then
    filterSkill = self._defaultNum[self._enum.eFILTER_TYPE_SKILL]
  else
    filterSkill = self._skillData[self._value.step3CurrentIndex]
  end
  local openByNpc = not ToClient_WorldMapIsShow()
  setAuctionServantAllFilter(filterSex, filterTier, filterSkill, self._value.openByNpc)
  local string = "" .. sexFilterString[filterSex] .. "/"
  string = string .. tierFilterString[filterTier] .. "/"
  string = string .. skillFilterString[self._value.step3CurrentIndex]
  PaGlobalFunc_StableMarket_SetFilterText(string)
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  self:close()
end
function PaGlobalFunc_StableMarket_Filter_Exit()
  local self = Panel_Window_StableMarket_Filter_info
  self:close()
end
function PaGlobalFunc_StableMarket_Filter_GetDefaultFilterText()
  local self = Panel_Window_StableMarket_Filter_info
  return sexFilterString[self._defaultNum[self._enum.eFILTER_TYPE_SEX]] .. "/" .. tierFilterString[self._defaultNum[self._enum.eFILTER_TYPE_TIER]] .. "/" .. skillFilterString[self._defaultNum[self._enum.eFILTER_TYPE_SKILL]]
end
function FromClient_StableMarket_Filter_Init()
  local self = Panel_Window_StableMarket_Filter_info
  self:initialize()
end
function FromClient_StableMarket_Filter_Resize()
  local self = Panel_Window_StableMarket_Filter_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_StableMarket_Filter_Init")
