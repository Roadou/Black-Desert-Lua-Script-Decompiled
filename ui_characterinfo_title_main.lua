local UI_TM = CppEnums.TextMode
PaGlobal_CharacterInfoTitle = {
  _filterText = "",
  _currentCategoryIdx = 0,
  _currentCategoryCount = 0,
  _category = {
    _world = 0,
    _battle = 1,
    _life = 2,
    _fish = 3
  },
  _categoryStirng = {
    [0] = "PANEL_CHARACTERINFO_TITLE_RDOBTN_ALLROUND",
    [1] = "PANEL_CHARACTERINFO_TITLE_RDOBTN_COMBAT",
    [2] = "PANEL_CHARACTERINFO_TITLE_RDOBTN_PRODUCT",
    [3] = "PANEL_CHARACTERINFO_TITLE_RDOBTN_FISH"
  },
  _comboBoxList = {
    _all = 0,
    _have = 1,
    _absence = 2
  },
  _comboBoxString = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_FILTER_ALL"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_FILTER_GET"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_FILTER_NOGET")
  },
  _ui = {
    _radioButtonCategory = {},
    _radioButtonSubCategory = {},
    _Progress2Total_Progress = nil,
    _staticTextTotal_Value = nil,
    _staticText_TotalCount = nil,
    _txt_totalProgress = nil,
    _staticTextTitle_Value = {},
    _staticTextTitle_Percent = {},
    _circularProgressTitle = {},
    _staticText_TotalReward = nil,
    _staticText_TotalReward_Value = nil,
    _staticText_PartName = nil,
    _staticText_PartDesc = nil,
    _staticText_SubTitleBar = nil,
    _staticText_LastUpdateTime = nil,
    _list2Title = nil,
    _comboBoxSort = nil,
    _editSearch = nil,
    _buttonSearch = nil,
    _staticText_Nothing = nil
  },
  _titleInfo = {
    _isCache = false,
    _name = nil,
    _desc = nil
  }
}
function PaGlobal_CharacterInfoTitle:initialize()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  PaGlobal_CharacterInfoTitle:createControl()
  self._ui._list2Title:setMinScrollBtnSize(float2(10, 50))
  self._ui._list2Title:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._staticText_PartName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._comboBoxSort:DeleteAllItem(0)
  self._ui._comboBoxSort:setListTextHorizonCenter()
  for index = 0, #self._comboBoxString do
    self._ui._comboBoxSort:AddItem(self._comboBoxString[index])
  end
  self._ui._comboBoxSort:GetListControl():SetSize(self._ui._comboBoxSort:GetSizeX(), (#self._comboBoxString + 1) * 22)
  self._ui._staticText_TotalReward_Value:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._staticText_PartDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._staticText_PartDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_PARTDESC"))
  if isGameTypeKorea() then
    self._ui._editSearch:SetMaxInput(20)
  else
    self._ui._editSearch:SetMaxInput(40)
  end
  self._ui._staticText_Nothing:SetShow(false)
  PaGlobal_CharacterInfoTitle:initializeTitleInfo()
  self:registEventHandler()
end
function PaGlobal_CharacterInfoTitle:createControl()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  PaGlobal_CharacterInfoTitle._ui._radioButtonCategory[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_AllRound")
  PaGlobal_CharacterInfoTitle._ui._radioButtonCategory[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Combat")
  PaGlobal_CharacterInfoTitle._ui._radioButtonCategory[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Product")
  PaGlobal_CharacterInfoTitle._ui._radioButtonCategory[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Taste_Fishing")
  PaGlobal_CharacterInfoTitle._ui._radioButtonSubCategory[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_AllRound")
  PaGlobal_CharacterInfoTitle._ui._radioButtonSubCategory[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Combat")
  PaGlobal_CharacterInfoTitle._ui._radioButtonSubCategory[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Product")
  PaGlobal_CharacterInfoTitle._ui._radioButtonSubCategory[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "RadioButton_Top_Fish")
  PaGlobal_CharacterInfoTitle._ui._Progress2Total_Progress = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Static_TotalProgress_Progress")
  PaGlobal_CharacterInfoTitle._ui._staticTextTotal_Value = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgress_Percent")
  PaGlobal_CharacterInfoTitle._ui._staticText_TotalCount = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalCount")
  PaGlobal_CharacterInfoTitle._ui._txt_totalProgress = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgress")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Value[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_CountValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Value[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_CountValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Value[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_CountValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Value[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_CountValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Percent[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AllRound_PercentValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Percent[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Combat_PercentValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Percent[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Product_PercentValue")
  PaGlobal_CharacterInfoTitle._ui._staticTextTitle_Percent[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Fishing_PercentValue")
  PaGlobal_CharacterInfoTitle._ui._circularProgressTitle[0] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Progress_AllRound")
  PaGlobal_CharacterInfoTitle._ui._circularProgressTitle[1] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Progress_Combat")
  PaGlobal_CharacterInfoTitle._ui._circularProgressTitle[2] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Progress_Product")
  PaGlobal_CharacterInfoTitle._ui._circularProgressTitle[3] = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Progress_Fishing")
  PaGlobal_CharacterInfoTitle._ui._staticText_TotalReward = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward")
  PaGlobal_CharacterInfoTitle._ui._staticText_TotalReward_Value = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_TotalProgressReward_Value")
  PaGlobal_CharacterInfoTitle._ui._staticText_PartName = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_SelectedTitle")
  PaGlobal_CharacterInfoTitle._ui._staticText_PartDesc = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_SelectedType")
  PaGlobal_CharacterInfoTitle._ui._staticText_SubTitleBar = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_LeftSubTitle")
  PaGlobal_CharacterInfoTitle._ui._staticText_LastUpdateTime = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_AcceptCooltime")
  PaGlobal_CharacterInfoTitle._ui._list2Title = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "List2_CharacterInfo_TitleList")
  PaGlobal_CharacterInfoTitle._ui._comboBoxSort = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "Combobox_List_Sort")
  PaGlobal_CharacterInfoTitle._ui._editSearch = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "EditSearchText")
  PaGlobal_CharacterInfoTitle._ui._buttonSearch = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "BtnSearch")
  PaGlobal_CharacterInfoTitle._ui._staticText_Nothing = UI.getChildControl(Panel_Window_CharInfo_TitleInfo, "StaticText_Nothing")
end
function PaGlobal_CharacterInfoTitle:update()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  self._ui._staticText_SubTitleBar:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_SUBTITLEBAR_COUNT", "count", ToClient_GetTotalAcquiredTitleCount()))
  self._ui._staticText_TotalReward_Value:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_TOTALREWARD_VALUE"))
  if "" == self._ui._staticText_PartDesc:GetText() or nil == self._ui._staticText_PartDesc:GetText() then
    self._ui._staticText_PartDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_PARTDESC"))
  end
  local coolTime = ToClient_GetUpdateTitleDelay()
  self._ui._staticText_LastUpdateTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_LASTUPDATETIME", "coolTime", coolTime))
  local titleCountByAll = ToClient_GetTotalTitleCount()
  local acquiredTitleCountByAll = ToClient_GetTotalAcquiredTitleCount()
  local titleTotalCount = ToClient_GetTotalTitleBuffCount()
  if nil ~= titleCountByAll and nil ~= acquiredTitleCountByAll and nil ~= titleTotalCount then
    local totalPercent = acquiredTitleCountByAll / titleCountByAll * 100
    self._ui._Progress2Total_Progress:SetProgressRate(totalPercent)
    self._ui._staticTextTotal_Value:SetText(string.format("%.1f", totalPercent) .. "%")
    self._ui._staticText_TotalCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHARACTERINFO_TITLE_SUBTITLEBAR_COUNT", "count", acquiredTitleCountByAll))
    self._ui._staticTextTotal_Value:SetPosX(self._ui._txt_totalProgress:GetPosX() + self._ui._txt_totalProgress:GetTextSizeX() + 10)
    for index = 0, titleTotalCount - 1 do
      local titleBuffWrapper = ToClient_GetTitleBuffWrapper(index)
      if nil ~= titleBuffWrapper then
        local buffDescription = titleBuffWrapper:getBuffDescription()
        self._ui._staticText_TotalReward_Value:SetText(buffDescription)
      end
    end
  end
  for key, index in pairs(self._category) do
    local titleCurrentCount = ToClient_GetCategoryTitleCount(index)
    local titleCurrentGetCount = ToClient_GetAcquiredTitleCount(index)
    if nil == titleCurrentCount or nil == titleCurrentGetCount then
      break
    end
    local titleCurrentPercent = titleCurrentGetCount / titleCurrentCount * 100
    self._ui._staticTextTitle_Value[index]:SetText(string.format("%.1f", titleCurrentPercent) .. "%")
    self._ui._circularProgressTitle[index]:SetProgressRate(titleCurrentPercent)
    self._ui._staticTextTitle_Percent[index]:SetText(PAGetString(Defines.StringSheet_RESOURCE, self._categoryStirng[index]))
    UI.setLimitTextAndAddTooltip(self._ui._staticTextTitle_Percent[index], PAGetString(Defines.StringSheet_RESOURCE, self._categoryStirng[index]))
  end
  self:updateList()
end
function PaGlobal_CharacterInfoTitle:registEventHandler()
  if nil == Panel_Window_CharInfo_TitleInfo then
    return
  end
  for key, idx in pairs(self._category) do
    self._ui._radioButtonCategory[idx]:addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_Category(" .. idx .. ")")
    self._ui._radioButtonCategory[idx]:addInputEvent("Mouse_On", "PaGlobal_CharacterInfoTitle:handleMouseOver_Category(true, " .. idx .. ")")
    self._ui._radioButtonCategory[idx]:addInputEvent("Mouse_Out", "PaGlobal_CharacterInfoTitle:handleMouseOver_Category(false)")
    self._ui._radioButtonSubCategory[idx]:addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_Category(" .. idx .. ")")
  end
  self._ui._comboBoxSort:addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_ComboBox()")
  self._ui._comboBoxSort:GetListControl():addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_ComboBoxText()")
  self._ui._buttonSearch:addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_SearchButton()")
  self._ui._editSearch:addInputEvent("Mouse_LUp", "PaGlobal_CharacterInfoTitle:handleClicked_SearchText()")
  self._ui._editSearch:RegistReturnKeyEvent("PaGlobal_CharacterInfoTitle:handleClicked_SearchButton()")
  self._ui._list2Title:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FromClient_UI_CharacterInfo_Title_CreateList")
end
function PaGlobal_CharacterInfoTitle:registMessageHandler()
  registerEvent("FromClient_TitleInfo_UpdateText", "FromClient_UI_CharacterInfo_Title_Update")
end
function FromClient_CharacterInfoTitle_Init()
  PaGlobal_CharacterInfoTitle_Init()
  PaGlobal_CharacterInfoTitle:registMessageHandler()
end
function PaGlobal_CharacterInfoTitle_Init()
  PaGlobal_CharacterInfoTitle:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_CharacterInfoTitle_Init")
