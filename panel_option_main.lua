Panel_Window_cOption:SetShow(false)
local _panel_toolTipSimpleText = PaGlobal_GetPanelTooltipSimpleText()
function FGlobal_Option_GetShow()
  return Panel_Window_cOption:GetShow()
end
function PaGlobal_Option:isOpen()
  return Panel_Window_cOption:GetShow()
end
function PaGlobal_Option:InitUi()
  self._ui._staticMainTopBg = UI.getChildControl(Panel_Window_cOption, "Static_MainTopBg")
  self._ui._staticMainBottomBg = UI.getChildControl(Panel_Window_cOption, "Static_MainBottomBg")
  self._ui._staticMainBg = UI.getChildControl(Panel_Window_cOption, "Static_MainBg")
  self._ui._staticSubTopBg = UI.getChildControl(Panel_Window_cOption, "Static_SubTopBg")
  self._ui._staticSubBottomBg = UI.getChildControl(Panel_Window_cOption, "Static_SubBottomBg")
  self._ui._staticSpecBG = UI.getChildControl(self._ui._staticMainBg, "Static_SpecBg")
  self._ui._staticCategoryBG = UI.getChildControl(self._ui._staticMainBg, "Static_CategoryBg")
  self._ui._list2 = UI.getChildControl(Panel_Window_cOption, "List2_LeftMenu")
  self._ui._buttonTopHome = UI.getChildControl(self._ui._staticSubTopBg, "Button_Home")
  self._ui._staticCategoryTitle = UI.getChildControl(self._ui._staticSubTopBg, "StaticText_SubTitle")
  self._ui._staticCategoryDesc = UI.getChildControl(self._ui._staticSubTopBg, "StaticText_SubDesc")
  self._ui._buttonQuestion = UI.getChildControl(Panel_Window_cOption, "Button_Question")
  self._ui._buttonResetFrame = UI.getChildControl(self._ui._staticSubTopBg, "Button_ResetFrame")
  self._ui._specDescTable = {}
  self._ui._curUIMode = self.UIMODE.Main
  self._ui._gameGrade = UI.getChildControl(self._ui._staticMainBottomBg, "Static_GameGradeIcon")
  self._ui._gameGrade:SetShow(true == isGameTypeKorea())
  self._ui._staticCategoryDesc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  UI.getChildControl(Panel_Window_cOption, "Button_Win_Close"):addInputEvent("Mouse_LUp", "PaGlobal_Option:Close()")
  self._ui._buttonTopHome:addInputEvent("Mouse_LUp", "PaGlobal_Option:MoveUi(1)")
  self._ui._buttonTopHome:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "Home" .. "\"" .. ")")
  self._ui._buttonTopHome:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "Home" .. "\"" .. ")")
  local topSaveSetting = UI.getChildControl(self._ui._staticMainTopBg, "Button_SaveSetting")
  topSaveSetting:addInputEvent("Mouse_LUp", "PaGlobal_Panel_SaveSetting_Show(false)")
  topSaveSetting:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "TopSaveSetting" .. "\"" .. ")")
  topSaveSetting:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "TopSaveSetting" .. "\"" .. ")")
  local bottomSaveSetting = UI.getChildControl(self._ui._staticSubTopBg, "Button_SaveSetting")
  bottomSaveSetting:addInputEvent("Mouse_LUp", "PaGlobal_Panel_SaveSetting_Show(false)")
  bottomSaveSetting:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "BottomSaveSetting" .. "\"" .. ")")
  bottomSaveSetting:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "BottomSaveSetting" .. "\"" .. ")")
  local topResetAll = UI.getChildControl(self._ui._staticMainTopBg, "Button_ResetAll")
  topResetAll:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedResetAllOption()")
  topResetAll:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "TopResetAll" .. "\"" .. ")")
  topResetAll:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "TopResetAll" .. "\"" .. ")")
  local bottomResetAll = UI.getChildControl(self._ui._staticSubTopBg, "Button_ResetAll")
  bottomResetAll:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedResetAllOption()")
  bottomResetAll:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "BottomResetAll" .. "\"" .. ")")
  bottomResetAll:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "BottomResetAll" .. "\"" .. ")")
  local topCacheDelete = UI.getChildControl(self._ui._staticMainTopBg, "Button_CacheReset")
  topCacheDelete:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedCacheDeleteOption()")
  topCacheDelete:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "CacheDelete" .. "\"" .. ")")
  topCacheDelete:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "CacheDelete" .. "\"" .. ")")
  self._ui._atFieldString = UI.getChildControl(self._ui._staticMainTopBg, "StaticText_AtFieldString")
  self._ui._applyButton = UI.getChildControl(self._ui._staticSubBottomBg, "Button_Apply")
  self._ui._applyButton:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedApplyOption()")
  self._ui._applyButton:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "Apply" .. "\"" .. ")")
  self._ui._applyButton:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "Apply" .. "\"" .. ")")
  local buttonCanel = UI.getChildControl(self._ui._staticSubBottomBg, "Button_Cancel")
  buttonCanel:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedCancelOption()")
  buttonCanel:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "Cancel" .. "\"" .. ")")
  buttonCanel:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "Cancel" .. "\"" .. ")")
  local buttonAdmin = UI.getChildControl(self._ui._staticSubBottomBg, "Button_Admin")
  buttonAdmin:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedConfirmOption()")
  buttonAdmin:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "Confirm" .. "\"" .. ")")
  buttonAdmin:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "Confirm" .. "\"" .. ")")
  UI.getChildControl(self._ui._staticMainBottomBg, "Button_License"):addInputEvent("Mouse_LUp", "PaGlobal_Copyright_ShowWindow()")
  if not isGameTypeGT() then
    UI.getChildControl(self._ui._staticMainBottomBg, "Button_License"):SetShow(true)
  else
    UI.getChildControl(self._ui._staticMainBottomBg, "Button_License"):SetShow(false)
  end
  self._ui._buttonResetFrame:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedResetFrame()")
  self._ui._buttonResetFrame:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "ResetFrame" .. "\"" .. ")")
  self._ui._buttonResetFrame:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "ResetFrame" .. "\"" .. ")")
  local specCount = 8
  local categoryCount = 5
  for specindex = 1, specCount do
    local spec = UI.getChildControl(self._ui._staticSpecBG, "Button_Spec" .. specindex)
    spec:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSpecSetting(" .. specindex .. ")")
    local specName = UI.getChildControl(spec, "StaticText_Name")
    specName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    specName:SetText(specName:GetText())
    self._ui._specDescTable[specindex] = UI.getChildControl(spec, "StaticText_Desc")
    self._ui._specDescTable[specindex]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._specDescTable[specindex]:SetText(self._ui._specDescTable[specindex]:GetText())
    self._ui._specDescTable[specindex]:SetPosY(self._ui._specDescTable[specindex]:GetPosY() + specName:GetTextSizeY() - specName:GetSizeY())
    spec:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnSpec(" .. specindex .. ")")
    spec:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutSpec(" .. specindex .. ")")
  end
  local category = UI.getChildControl(self._ui._staticCategoryBG, "Button_Optimize")
  category:addInputEvent("Mouse_LUp", "PaGlobal_Option:GoCategory( " .. "\"" .. "Performance" .. "\"" .. ")")
  category:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCategory(" .. "\"" .. "Performance" .. "\"" .. ")")
  category:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCategory(" .. "\"" .. "Performance" .. "\"" .. ")")
  self._ui._categoryTitleTable.Performance = UI.getChildControl(category, "StaticText_Name")
  self._ui._categoryDescTable.Performance = UI.getChildControl(category, "StaticText_Desc")
  self._ui._categoryTitleTable.Performance:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._categoryTitleTable.Performance:SetText(self._ui._categoryTitleTable.Performance:GetText())
  self._ui._categoryDescTable.Performance:SetPosY(self._ui._categoryDescTable.Performance:GetPosY() + self._ui._categoryTitleTable.Performance:GetTextSizeY() - self._ui._categoryTitleTable.Performance:GetSizeY())
  category = UI.getChildControl(self._ui._staticCategoryBG, "Button_Graphic")
  category:addInputEvent("Mouse_LUp", "PaGlobal_Option:GoCategory( " .. "\"" .. "Graphic" .. "\"" .. ")")
  category:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCategory(" .. "\"" .. "Graphic" .. "\"" .. ")")
  category:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCategory(" .. "\"" .. "Graphic" .. "\"" .. ")")
  self._ui._categoryTitleTable.Graphic = UI.getChildControl(category, "StaticText_Name")
  self._ui._categoryDescTable.Graphic = UI.getChildControl(category, "StaticText_Desc")
  self._ui._categoryTitleTable.Graphic:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._categoryTitleTable.Graphic:SetText(self._ui._categoryTitleTable.Graphic:GetText())
  self._ui._categoryDescTable.Graphic:SetPosY(self._ui._categoryDescTable.Graphic:GetPosY() + self._ui._categoryTitleTable.Graphic:GetTextSizeY() - self._ui._categoryTitleTable.Graphic:GetSizeY())
  category = UI.getChildControl(self._ui._staticCategoryBG, "Button_Sound")
  category:addInputEvent("Mouse_LUp", "PaGlobal_Option:GoCategory( " .. "\"" .. "Sound" .. "\"" .. ")")
  category:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCategory(" .. "\"" .. "Sound" .. "\"" .. ")")
  category:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCategory(" .. "\"" .. "Sound" .. "\"" .. ")")
  self._ui._categoryTitleTable.Sound = UI.getChildControl(category, "StaticText_Name")
  self._ui._categoryDescTable.Sound = UI.getChildControl(category, "StaticText_Desc")
  self._ui._categoryTitleTable.Sound:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._categoryTitleTable.Sound:SetText(self._ui._categoryTitleTable.Sound:GetText())
  self._ui._categoryDescTable.Sound:SetPosY(self._ui._categoryDescTable.Sound:GetPosY() + self._ui._categoryTitleTable.Sound:GetTextSizeY() - self._ui._categoryTitleTable.Sound:GetSizeY())
  category = UI.getChildControl(self._ui._staticCategoryBG, "Button_Function")
  category:addInputEvent("Mouse_LUp", "PaGlobal_Option:GoCategory( " .. "\"" .. "Function" .. "\"" .. ")")
  category:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCategory(" .. "\"" .. "Function" .. "\"" .. ")")
  category:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCategory(" .. "\"" .. "Function" .. "\"" .. ")")
  self._ui._categoryTitleTable.Function = UI.getChildControl(category, "StaticText_Name")
  self._ui._categoryDescTable.Function = UI.getChildControl(category, "StaticText_Desc")
  self._ui._categoryTitleTable.Function:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._categoryTitleTable.Function:SetText(self._ui._categoryTitleTable.Function:GetText())
  self._ui._categoryDescTable.Function:SetPosY(self._ui._categoryDescTable.Function:GetPosY() + self._ui._categoryTitleTable.Function:GetTextSizeY() - self._ui._categoryTitleTable.Function:GetSizeY())
  category = UI.getChildControl(self._ui._staticCategoryBG, "Button_Interface")
  category:addInputEvent("Mouse_LUp", "PaGlobal_Option:GoCategory( " .. "\"" .. "Interface" .. "\"" .. ")")
  category:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCategory(" .. "\"" .. "Interface" .. "\"" .. ")")
  category:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCategory(" .. "\"" .. "Interface" .. "\"" .. ")")
  self._ui._categoryTitleTable.Interface = UI.getChildControl(category, "StaticText_Name")
  self._ui._categoryDescTable.Interface = UI.getChildControl(category, "StaticText_Desc")
  self._ui._categoryTitleTable.Interface:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._categoryTitleTable.Interface:SetText(self._ui._categoryTitleTable.Interface:GetText())
  self._ui._categoryDescTable.Interface:SetPosY(self._ui._categoryDescTable.Interface:GetPosY() + self._ui._categoryTitleTable.Interface:GetTextSizeY() - self._ui._categoryTitleTable.Interface:GetSizeY())
  category = nil
  for index, control in pairs(self._ui._categoryDescTable) do
    control:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    control:SetText(control:GetText())
  end
  self._ui._editSearch = UI.getChildControl(self._ui._staticMainTopBg, "Edit_SearchOption")
  self._ui._editSearchSub = UI.getChildControl(self._ui._staticSubTopBg, "Edit_SearchOption")
  self._ui._editSearchMain = UI.getChildControl(self._ui._staticMainTopBg, "Edit_SearchOption")
  self._ui._editSearchSub:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSeachEditControl()")
  self._ui._editSearchMain:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSeachEditControl()")
  self._ui._staticSearchNoResult = UI.getChildControl(Panel_Window_cOption, "StaticText_SearchNoResult")
  self._ui._staticSearchNoResult:SetShow(false)
  local topsearchIcon = UI.getChildControl(self._ui._staticMainTopBg, "Button_SearchIcon")
  topsearchIcon:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSeachOption()")
  local subtopsearchIcon = UI.getChildControl(self._ui._staticSubTopBg, "Button_SearchIcon")
  subtopsearchIcon:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSeachOption()")
  self._ui._listSearchBg:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_Option_List2SearchElementCreate")
  self._ui._listSearchBg:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._customDescTable = {}
  self._ui._customLoadConfirmIcon = {}
  for customIndex = 0, 1 do
    self._ui["_buttonSaveCustom" .. customIndex] = UI.getChildControl(self._ui._staticSubBottomBg, "Button_CustomSave_" .. tostring(customIndex + 1))
    self._ui["_buttonSaveCustom" .. customIndex]:addInputEvent("Mouse_LUp", "PaGlobal_Option:SaveCutsomOption(" .. customIndex .. ")")
    self._ui["_buttonSaveCustom" .. customIndex]:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true , " .. "\"" .. "CustomSave" .. customIndex .. "\"" .. ")")
    self._ui["_buttonSaveCustom" .. customIndex]:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false , " .. "\"" .. "CustomSave" .. customIndex .. "\"" .. ")")
    self._ui["_buttonLoadCustom" .. customIndex] = UI.getChildControl(self._ui._staticSpecBG, "Button_Custom" .. tostring(customIndex + 1))
    self._ui["_buttonLoadCustom" .. customIndex]:addInputEvent("Mouse_LUp", "PaGlobal_Option:LoadCutsomOption(" .. customIndex .. ")")
    self._ui["_buttonLoadCustom" .. customIndex]:addInputEvent("Mouse_On", "PaGlobal_Option:MouseOnCustom(" .. customIndex .. ")")
    self._ui["_buttonLoadCustom" .. customIndex]:addInputEvent("Mouse_Out", "PaGlobal_Option:MouseOutCustom(" .. customIndex .. ")")
    self._ui._customDescTable[customIndex] = UI.getChildControl(self._ui["_buttonLoadCustom" .. customIndex], "StaticText_Desc")
    self._ui._customDescTable[customIndex]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui._customDescTable[customIndex]:SetText(self._ui._customDescTable[customIndex]:GetText())
    self._ui._customLoadConfirmIcon[customIndex] = UI.getChildControl(self._ui["_buttonLoadCustom" .. customIndex], "Static_AdjustIcon")
    local customName = UI.getChildControl(self._ui["_buttonLoadCustom" .. customIndex], "StaticText_Name")
    customName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    customName:SetText(customName:GetText())
    self._ui._customDescTable[customIndex]:SetPosY(self._ui._customDescTable[customIndex]:GetPosY() + customName:GetTextSizeY() - customName:GetSizeY())
    if _ContentsGroup_isConsolePadControl then
      self._ui["_buttonSaveCustom" .. customIndex]:SetShow(false)
      self._ui["_buttonLoadCustom" .. customIndex]:SetShow(false)
    end
  end
  self._ui._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"UIGameOption\" )")
  self._ui._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"UIGameOption\", \"true\")")
  self._ui._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"UIGameOption\", \"false\")")
  self._tooltip.TopResetAll = {
    control = topResetAll,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_RESETALL")
  }
  self._tooltip.BottomResetAll = {
    control = bottomResetAll,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_RESETALL")
  }
  self._tooltip.CacheDelete = {
    control = topCacheDelete,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_CACHEDELETE")
  }
  self._tooltip.TopSaveSetting = {
    control = topSaveSetting,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_SAVEFILE")
  }
  self._tooltip.BottomSaveSetting = {
    control = bottomSaveSetting,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_SAVEFILE")
  }
  self._tooltip.Apply = {
    control = self._ui._applyButton,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_ADJUST")
  }
  self._tooltip.Cancel = {
    control = buttonCanel,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_ADJUSTBACK")
  }
  self._tooltip.Confirm = {
    control = buttonAdmin,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_ADMIN")
  }
  self._tooltip.Home = {
    control = self._ui._buttonTopHome,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_HOME")
  }
  self._tooltip.CustomSave0 = {
    control = self._ui._buttonSaveCustom0,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_CUSTOMSAVE")
  }
  self._tooltip.CustomSave1 = {
    control = self._ui._buttonSaveCustom1,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_CUSTOMSAVE")
  }
  self._tooltip.ResetFrame = {
    control = self._ui._buttonResetFrame,
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_TOOLTIPDESC_RESETBUTTON")
  }
  if _ContentsGroup_isConsolePadControl then
    self._ui._editSearch:SetShow(false)
    self._ui._editSearchSub:SetShow(false)
    self._ui._editSearchMain:SetShow(false)
    self._ui._buttonTopHome:SetShow(false)
    topResetAll:SetShow(false)
    bottomResetAll:SetShow(false)
    topCacheDelete:SetShow(false)
    topsearchIcon:SetShow(false)
    topSaveSetting:SetShow(false)
    bottomSaveSetting:SetShow(false)
    subtopsearchIcon:SetShow(false)
  end
  if isGameTypeGT() then
    topSaveSetting:SetShow(false)
    bottomSaveSetting:SetShow(false)
  end
  if false == isNeedGameOptionFromServer() then
    self._ui._buttonQuestion:SetShow(false)
  end
  self:MoveUi(self.UIMODE.Main)
  self:SetContentsOption()
end
function PaGlobal_Option:Simpletooltips(isShow, tooltipName)
  if nil == self._tooltip[tooltipName] then
    return
  end
  if true == isShow then
    registTooltipControl(self._tooltip[tooltipName].control, _panel_toolTipSimpleText)
    TooltipSimple_Show(self._tooltip[tooltipName].control, "", self._tooltip[tooltipName].desc)
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_Option:MoveUi(value)
  self._ui._curUIMode = value
  if self.UIMODE.Category == value then
    self._ui._staticCategoryBG:SetShow(false)
    self._ui._staticSpecBG:SetShow(false)
    self._ui._list2:SetShow(true)
    self._ui._staticSubBottomBg:SetShow(true)
    self._ui._staticMainBottomBg:SetShow(false)
    self._ui._listSearchBg:SetShow(false)
    self._ui._staticMainTopBg:SetShow(false)
    self._ui._buttonTopHome:SetShow(true)
    self._ui._staticMainBg:SetShow(false)
    self._ui._staticSubTopBg:SetShow(true)
    self._ui._staticSearchNoResult:SetShow(false)
    self._ui._buttonResetFrame:SetEnable(true)
    self._ui._buttonResetFrame:SetMonoTone(false)
    if nil ~= self._list2._curCategory and nil ~= self._list2._curDetail then
      self._frames[self._list2._curCategory][self._list2._curDetail]._uiFrame:SetShow(true)
    end
    self._ui._editSearch = self._ui._editSearchSub
  elseif self.UIMODE.Main == value then
    self._ui._staticMainBg:SetShow(true)
    self._ui._staticCategoryBG:SetShow(true)
    self._ui._staticSpecBG:SetShow(true)
    self._ui._list2:SetShow(false)
    self._ui._staticSubBottomBg:SetShow(false)
    self._ui._staticMainBottomBg:SetShow(true)
    self._ui._listSearchBg:SetShow(false)
    self._ui._buttonTopHome:SetShow(false)
    self._ui._staticMainTopBg:SetShow(true)
    self._ui._staticMainBg:SetShow(true)
    self._ui._staticSubTopBg:SetShow(false)
    self._ui._staticSearchNoResult:SetShow(false)
    self._ui._buttonResetFrame:SetEnable(false)
    self._ui._buttonResetFrame:SetMonoTone(true)
    for index, value in pairs(self._ui._categoryTitleTable) do
      local categoryIcon = value:getParent()
      categoryIcon:setRenderTexture(categoryIcon:getBaseTexture())
    end
    if nil ~= self._list2._curCategory and nil ~= self._list2._curDetail then
      self._frames[self._list2._curCategory][self._list2._curDetail]._uiFrame:SetShow(false)
    end
    self._ui._editSearch = self._ui._editSearchMain
  elseif self.UIMODE.Search == value then
    self._ui._staticCategoryBG:SetShow(false)
    self._ui._staticSpecBG:SetShow(false)
    self._ui._list2:SetShow(true)
    self._ui._staticSubBottomBg:SetShow(true)
    self._ui._staticMainBottomBg:SetShow(false)
    self._ui._listSearchBg:SetShow(true)
    self._ui._buttonTopHome:SetShow(true)
    self._ui._staticMainTopBg:SetShow(false)
    self._ui._staticMainBg:SetShow(false)
    self._ui._staticSubTopBg:SetShow(true)
    self._ui._staticSearchNoResult:SetShow(self._ui._staticSearchNoResult:GetShow())
    self._ui._buttonResetFrame:SetEnable(false)
    self._ui._buttonResetFrame:SetMonoTone(true)
    if nil ~= self._list2._curCategory and nil ~= self._list2._curDetail then
      self._frames[self._list2._curCategory][self._list2._curDetail]._uiFrame:SetShow(false)
    end
    self._ui._editSearch = self._ui._editSearchSub
  end
  self._ui._editSearch:SetEditText("")
  ClearFocusEdit()
  if _ContentsGroup_isConsolePadControl then
    self._ui._buttonTopHome:SetShow(false)
  end
end
function PaGlobal_Option:ApplyButtonEnable(enable)
  self._ui._applyButton:SetEnable(enable)
  self._ui._applyButton:SetMonoTone(not enable)
end
function PaGlobal_Option:Open()
  ClearFocusEdit()
  if isNeedGameOptionFromServer() == true then
    keyCustom_StartEdit()
  end
  local tree2 = self._ui._list2
  for key, value in pairs(self._list2._tree2IndexMap) do
    if value._isMain then
      local keyElement = tree2:getElementManager():getByKey(toInt64(0, key), false)
      keyElement:setIsOpen(false)
    end
  end
  tree2:getElementManager():refillKeyList()
  tree2:moveTopIndex()
  if true == ToClient_isConsole() then
    local idx = self._list2._selectedKey
    local indexMap = self._list2._tree2IndexMap[idx]
    if nil ~= idx then
      self:ClickedMainCategory(idx, indexMap._category)
    end
  end
  self:CheckEnableSimpleUI()
  if isNeedGameOptionFromServer() == true then
    self:MoveUi(self.UIMODE.Main)
  else
    self:MoveUi(self.UIMODE.Category)
    self._ui._staticSubTopBg:SetMonoTone(true)
    self._ui._staticSubTopBg:SetEnable(false)
    self:SelectOptionFrame("Function", "Nation")
  end
  if _ContentsGroup_isConsolePadControl then
    self:MoveUi(self.UIMODE.Category)
    if nil == self._list2._curCategory then
      self:SelectOptionFrame("Function", "Alert")
    end
  end
  self._ui._atFieldString:SetText(ToClient_GetAtFieldString())
  Panel_Window_cOption:SetShow(true, true)
  Panel_Window_cOption:SetIgnore(false)
  self:ApplyButtonEnable(false)
  audioPostEvent_SystemUi(1, 0)
end
function PaGlobal_Option:Close()
  self:MoveUi(self.UIMODE.Main)
  for elemeneName, option in pairs(self._elements) do
    if true == option._settingRightNow and nil == option._applyValue and nil ~= option._curValue then
      self:SetXXX(elemeneName, option._initValue)
    end
    option._curValue = nil
  end
  keyCustom_RollBack()
  setKeyCustomizing(false)
  SetUIMode(Defines.UIMode.eUIMode_Default)
  Panel_Window_cOption:SetShow(false, true)
  if _panel_toolTipSimpleText:GetShow() then
    TooltipSimple_Hide()
  end
  audioPostEvent_SystemUi(1, 0)
end
function PaGlobal_Option:ClickedCancelOption()
  for elementName, option in pairs(self._elements) do
    local check = false
    if nil ~= option._curValue then
      if true == option._settingRightNow then
        check = true
      else
        self:ResetControlSetting(elementName)
        self:SetControlSetting(elementName, option._initValue)
      end
    end
    if nil ~= option._applyValue then
      check = true
    end
    if true == check then
      self:ResetControlSetting(elementName)
      self:SetXXX(elementName, option._initValue)
    end
  end
  audioPostEvent_SystemUi(1, 0)
  setAudioOptionByConfig()
  keyCustom_RollBack()
  self:CompleteKeyCustomMode()
  self:ApplyButtonEnable(false)
  ClearFocusEdit()
end
function PaGlobal_Option:ClickedApplyOption()
  local displayChange = false
  for elementName, option in pairs(self._elements) do
    if nil ~= option.uiInputType or nil ~= option.actionInputType then
      option._curValue = nil
    elseif nil ~= option._curValue then
      self:SetXXX(elementName, option._curValue)
      if true == option._isChangeDisplay then
        displayChange = true
      end
    end
  end
  if nil ~= Panel_MainStatus_Remaster and Panel_MainStatus_Remaster:GetShow() then
    PaGlobalFunc_MainStatus_SetMPBarTexture()
  elseif nil ~= Panel_MainStatus_User_Bar and Panel_MainStatus_User_Bar:GetShow() then
    PaGlobalFunc_UserBar_CharacterInfoWindowUpdate(true)
  end
  if true == displayChange then
    self:DisplayChanged()
    self:Close()
    return
  end
  keyCustom_applyChange()
  keyCustom_StartEdit()
  saveGameOption(false)
  local selfPlayer = getSelfPlayer()
  if selfPlayer then
    selfPlayer:saveCurrentDataForGameExit()
  end
  self:ApplyButtonEnable(false)
  ClearFocusEdit()
  for _, icon in pairs(self._ui._customLoadConfirmIcon) do
    icon:SetShow(false)
  end
end
function PaGlobal_Option:ClickedConfirmOption()
  if isNeedGameOptionFromServer() == true then
    FGlobal_QuestWindowRateSetting()
    Panel_UIControl_SetShow(false)
  end
  audioPostEvent_SystemUi(1, 0)
  self:ClickedApplyOption()
  self:Close()
end
function PaGlobal_Option:ClickedResetAllOption()
  ClearFocusEdit()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_ALLRESETCONFIRMMESSAGE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_ResetAllOption,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_Option_ResetAllOption()
  PaGlobal_Option._resetCheck = true
  PaGlobal_Option:ResetAlert()
  PaGlobal_Option:SetXXX("UseNewQuickSlot", PaGlobal_Option._elements.UseNewQuickSlot._defaultValue)
  resetAllOption()
  keyCustom_SetDefaultAction()
  keyCustom_SetDefaultUI()
  if true == ToClient_isConsole() then
    setConsoleKeyType(2)
  end
  PaGlobal_Option:ResetKeyCustomString()
  saveGameOption(false)
end
function PaGlobal_Option:ClickedCacheDeleteOption()
  ClearFocusEdit()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_CACHEDELETECONFIRMMESSAGE")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_CacheDeleteOption,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_Option_CacheDeleteOption()
  ToClient_removeCacheFolder()
  if true == ToClient_removeCacheFolder() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_CACHEDELETE_ACK"))
  end
end
function PaGlobal_Option:ClickedResetFrame()
  if nil == self._list2._curCategory or nil == self._list2._curDetail then
    _PA_LOG("\237\155\132\236\167\132", "[GameOption][ClickedResetFrame] \237\152\132\236\158\172 \236\132\160\237\131\157\235\144\156 \237\148\132\235\160\136\236\158\132\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164. \236\150\180\235\148\148\236\132\156 \237\149\168\236\136\152\235\165\188 \235\182\136\235\160\128\235\138\148\236\167\128 \237\153\149\236\157\184\237\149\180\236\163\188\236\132\184\236\154\148.")
    return
  end
  ClearFocusEdit()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_CAUTION_RESET")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_ResetFrame,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function FGlobal_Option_ResetFrame()
  local self = PaGlobal_Option
  local resetElements = self._frames[self._list2._curCategory][self._list2._curDetail]._containElement
  local isKeyCustomReset = false
  local rv
  for index, elementName in ipairs(resetElements) do
    local option = self._elements[elementName]
    if nil ~= option then
      if nil ~= option.actionInputType or nil ~= option.uiInputType then
        self:KeyCustomResetFrame(option)
        isKeyCustomReset = true
      elseif nil ~= option._defaultValue then
        local beforeOption = self:Get(elementName)
        self:ResetControlSetting(elementName)
        rv = self:SetXXX(elementName, option._defaultValue)
        if false == rv then
          self:SetControlSetting(elementName, beforeOption)
          option._initValue = beforeOption
        else
          option._initValue = option._defaultValue
        end
        option._applyValue = nil
        option._curValue = nil
      end
    end
  end
  if true == isKeyCustomReset then
    PaGlobal_Option:ResetKeyCustomString()
  end
  self:ApplyButtonEnable(false)
end
function PaGlobal_Option:KeyCustomResetFrame(option)
  if nil == option then
    return
  end
  if nil ~= option.actionInputType then
    if "PadFunction1" == option.actionInputType then
      keyCustom_SetDefaultPadFunc1()
    elseif "PadFunction2" == option.actionInputType then
      keyCustom_SetDefaultPadFunc2()
    else
      keyCustom_SetDefaultActionData(option.actionInputType)
    end
    return
  elseif nil ~= option.uiInputType then
    keyCustom_SetDefaultUIData(option.uiInputType)
    return
  end
end
function PaGlobal_Option:ResetAlert()
  for _, index in pairs(self.ALERT) do
    ToClient_SetMessageFilter(index, false)
  end
end
function PaGlobal_Option:ClickedSpecSetting(value)
  local messageBoxMemo = self._ui._specDescTable[value]:GetText()
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_SPECTITLE"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_SetSpec,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  self._curSpecValue = value
  ClearFocusEdit()
end
function FGlobal_Option_SetSpec()
  PaGlobal_Option:SetSpecSetting(PaGlobal_Option._curSpecValue)
end
function PaGlobal_Option:ClickedSeachEditControl()
  if self._ui._curUIMode == self.UIMODE.Main then
    self._ui._editSearch = self._ui._editSearchMain
    self._ui._editSearch:SetEditText(self._ui._editSearchMain:GetEditText())
  else
    self._ui._editSearch = self._ui._editSearchSub
    self._ui._editSearch:SetEditText(self._ui._editSearchSub:GetEditText())
  end
end
function PaGlobal_Option:ClickedSeachOption()
  local edit = GetFocusEdit()
  local list = self._ui._listSearchBg
  local findString
  if nil == edit then
    findString = self._ui._editSearch:GetEditText()
  else
    findString = edit:GetEditText()
    edit:SetText(findString)
  end
  self._ui._editSearch:SetEditText("")
  self._ui._editSearch:SetText("")
  self._ui._staticCategoryTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_SEARCHTEXT"))
  self._ui._staticCategoryDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_SEARCHTEXT_DESC") .. " [ <PAColor0xffddcd82>" .. findString .. "<PAOldColor> ]")
  self._findStrings = self:SearchOption(findString)
  local sortFindStringFunc = function(lhs, rhs)
    local lhsMergeString = lhs._category._string .. " " .. lhs._detail._string .. " " .. lhs._elementString
    local rhsMergeString = rhs._category._string .. " " .. rhs._detail._string .. " " .. rhs._elementString
    return stringCompare(lhsMergeString, rhsMergeString) < 0
  end
  table.sort(self._findStrings, sortFindStringFunc)
  if nil == self._findStrings then
    list:getElementManager():clearKey()
    return
  end
  local count = #self._findStrings
  if 0 == count then
    list:getElementManager():clearKey()
  end
  self:MoveUi(self.UIMODE.Search)
  self._ui._staticSearchNoResult:SetShow(0 == count)
  list:getElementManager():clearKey()
  for index = 1, count do
    list:getElementManager():pushKey(toInt64(0, index))
    list:requestUpdateByKey(toInt64(0, index))
  end
  self:ResetListToggleState()
end
function FGlobal_Option_List2SearchElementCreate(list_content, key)
  local id = Int64toInt32(key)
  local content = UI.getChildControl(list_content, "StaticText_SearchElement")
  local findString = PaGlobal_Option._findStrings[id]
  content:SetShow(true)
  content:SetText(findString._category._string .. " > " .. findString._detail._string .. " > " .. findString._elementString)
  content:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedFindElement(" .. "\"" .. findString._category._find .. "\"" .. ", " .. "\"" .. findString._detail._find .. "\"" .. " , " .. tostring(findString._isScrollEnd) .. ")")
end
function PaGlobal_Option:ClickedFindElement(category, detail, isScrollEnd)
  self:MoveUi(self.UIMODE.Category)
  if nil == category or nil == detail then
    _PA_LOG("\237\155\132\236\167\132", "[GameOption][ClickedFindElement] \236\152\181\236\133\152 \236\132\184\237\140\133\236\157\180 \236\158\152\235\170\187\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. CreateEventControl\236\157\132 \235\179\180\236\132\184\236\154\148.  category : " .. category .. " detail : " .. detail)
  end
  self:GoCategory(category, detail)
  if true == isScrollEnd then
    self._frames[category][detail]._uiFrame:UpdateContentScroll()
    self._frames[category][detail]._uiScroll:SetControlBottom()
    self._frames[category][detail]._uiFrame:UpdateContentPos()
  end
end
function PaGlobal_Option:DisplayChanged()
  local messageboxData = {
    title = "changeDisplay",
    content = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_DISPLAYCOMMIT_COMMENT"),
    functionApply = FGlobal_Option_ChangeDisplayApply,
    functionCancel = FGlobal_Option_ChangeDisplayCancel,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW,
    isTimeCount = true,
    countTime = 10,
    timeString = PAGetString(Defines.StringSheet_GAME, "LUA_OPTION_DISPLAYCOMMIT_TIMELEFT"),
    isStartTimer = true,
    afterFunction = FGlobal_Option_ChangeDisplayTimeOut
  }
  allClearMessageData()
  MessageBox.showMessageBox(messageboxData)
end
function FGlobal_Option_ChangeDisplayTimeOut()
  if true == MessageBox.isPopUp() then
    messageBox_CancelButtonUp()
  end
end
function FGlobal_Option_ChangeDisplayApply()
  if isNeedGameOptionFromServer() == true then
    FGlobal_QuestWindowRateSetting()
  end
  keyCustom_applyChange()
  keyCustom_StartEdit()
  PaGlobal_Option:ApplyButtonEnable(false)
  saveGameOption(true)
  reloadGameUI()
end
function FGlobal_Option_ChangeDisplayCancel()
  PaGlobal_Option:SetXXX("ScreenResolution", PaGlobal_Option._elements.ScreenResolution._initValue)
  PaGlobal_Option:SetXXX("UIScale", PaGlobal_Option._elements.UIScale._initValue)
  PaGlobal_Option:SetXXX("ScreenMode", PaGlobal_Option._elements.ScreenMode._initValue)
end
function PaGlobal_Option:ResetCategoryAndSpecTooltip()
  for index, control in ipairs(self._ui._specDescTable) do
    control:SetShow(false)
  end
  for index, control in pairs(self._ui._categoryDescTable) do
    control:SetShow(false)
  end
end
function PaGlobal_Option:MouseOnSpec(category)
  self._ui._specDescTable[category]:SetShow(true)
end
function PaGlobal_Option:MouseOutSpec(category)
  self._ui._specDescTable[category]:SetShow(false)
end
function PaGlobal_Option:MouseOnCategory(category)
  self._ui._categoryDescTable[category]:SetShow(true)
end
function PaGlobal_Option:MouseOutCategory(category)
  self._ui._categoryDescTable[category]:SetShow(false)
end
function PaGlobal_Option:MouseOnCustom(index)
  self._ui._customDescTable[index]:SetShow(true)
end
function PaGlobal_Option:MouseOutCustom(index)
  self._ui._customDescTable[index]:SetShow(false)
end
function FGlobal_Option_CheckUiEdit(targetUI)
  if nil == PaGlobal_Option._ui._editSearch then
    return false
  end
  if false == PaGlobal_Option:isOpen() then
    return false
  end
  if targetUI:GetKey() == PaGlobal_Option._ui._editSearch:GetKey() and targetUI:GetID() == PaGlobal_Option._ui._editSearch:GetID() then
    return true
  end
  return false
end
function PaGlobal_Option:SelectOptionFrame(category, detail)
  local data = self._frames[category][detail]
  if nil ~= self._list2._curCategory and nil ~= self._list2._curDetail then
    local beforedata = self._frames[self._list2._curCategory][self._list2._curDetail]
    beforedata._uiFrame:SetShow(false)
  end
  data._uiFrame:SetShow(true)
  data._uiFrame:UpdateContentScroll()
  data._uiScroll:SetControlTop()
  data._uiFrame:UpdateContentPos()
  self._list2._curCategory = category
  self._list2._curDetail = detail
  self._ui._listSearchBg:SetShow(false)
  self._ui._staticCategoryDesc:SetText(self._ui._categoryDescTable[category]:GetText())
  self._ui._staticCategoryTitle:SetText(self._ui._categoryTitleTable[category]:GetText())
  self._ui._staticSearchNoResult:SetShow(false)
end
function PaGlobal_Option:ListInit()
  local tree2 = self._ui._list2
  tree2:changeAnimationSpeed(11)
  tree2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_Option_CategoryUpdate")
  tree2:createChildContent(CppEnums.PAUIList2ElementManagerType.tree)
  tree2:getElementManager():clearKey()
  local mainElement = tree2:getElementManager():getMainElement()
  local keyIndex = 1
  local _frameOrder = {}
  local _detailOrder = {}
  if true == isNeedGameOptionFromServer() then
    if _ContentsGroup_isConsoleTest then
      _frameOrder = {
        "Graphic",
        "Function",
        "Interface",
        "Sound"
      }
      _detailOrder = {
        [1] = {"HDR"},
        [2] = {"Alert", "Etc"},
        [3] = {"Pad"},
        [4] = {"OnOff", "Volume"}
      }
    else
      _frameOrder = {
        "Performance",
        "Graphic",
        "Sound",
        "Function",
        "Interface"
      }
      _detailOrder = {
        [1] = {
          "GraphicQuality",
          "Optimize",
          "Camera",
          "Npc"
        },
        [2] = {
          "Window",
          "Quality",
          "Effect",
          "Camera",
          "ScreenShot"
        },
        [3] = {"OnOff", "Volume"},
        [4] = {
          "Convenience",
          "View",
          "Alert",
          "Worldmap",
          "Nation",
          "Etc"
        },
        [5] = {
          "Action",
          "UI",
          "QuickSlot",
          "Function",
          "Mouse",
          "Pad"
        }
      }
    end
  elseif _ContentsGroup_isConsoleTest then
    _frameOrder = {"Sound", "Graphic"}
    _detailOrder = {
      [1] = {"OnOff", "Volume"},
      [2] = {"HDR"}
    }
  else
    _frameOrder = {
      "Performance",
      "Graphic",
      "Sound",
      "Function"
    }
    _detailOrder = {
      [1] = {
        "GraphicQuality",
        "Optimize",
        "Camera",
        "Npc"
      },
      [2] = {
        "Window",
        "Quality",
        "Effect",
        "Camera",
        "ScreenShot"
      },
      [3] = {"OnOff", "Volume"},
      [4] = {"Nation"}
    }
  end
  for index, category in ipairs(_frameOrder) do
    local category = _frameOrder[index]
    self._list2._tree2IndexMap[keyIndex] = {
      _isMain = true,
      _category = category,
      _string = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_" .. category)
    }
    local treeElement = mainElement:createChild(toInt64(0, keyIndex))
    treeElement:setIsOpen(false)
    keyIndex = keyIndex + 1
    local count = 0
    for i, table in pairs(self._frames[category]) do
      count = count + 1
    end
    if count > 1 then
      for index2, frame in pairs(_detailOrder[index]) do
        local table = self._frames[category][_detailOrder[index][index2]]
        self._list2._tree2IndexMap[keyIndex] = {
          _isMain = false,
          _category = category,
          _detail = table._detail,
          _string = PAGetString(Defines.StringSheet_GAME, "LUA_NEWGAMEOPTION_" .. category .. "_" .. table._detail)
        }
        local subTreeElement = treeElement:createChild(toInt64(0, keyIndex))
        keyIndex = keyIndex + 1
      end
    end
  end
end
function PaGlobal_Option:GoCategory(clickCategory, clickDetail)
  for key, table in pairs(self._list2._tree2IndexMap) do
    if clickCategory == table._category then
      self:ClickedMainCategory(key, table._category)
      break
    end
  end
  for key, table in pairs(self._list2._tree2IndexMap) do
    if nil == clickDetail then
      if clickCategory == table._category and nil ~= table._detail then
        self:ClickedSubCategory(key, table._category, table._detail)
        break
      end
    elseif clickCategory == table._category and clickDetail == table._detail then
      self:ClickedSubCategory(key, table._category, table._detail)
      break
    end
  end
  self:ResetCategoryAndSpecTooltip()
  self:MoveUi(self.UIMODE.Category)
end
function PaGlobal_Option:ClickedMainCategory(key, category)
  local tree2 = self._ui._list2
  for k, value in pairs(self._list2._tree2IndexMap) do
    if true == value._isMain then
      local keyElement = tree2:getElementManager():getByKey(toInt64(0, k), false)
      keyElement:setIsOpen(false)
    end
  end
  local isOnlyOneSubCategory = 0
  local onlyOnDetail
  for k, value in pairs(self._list2._tree2IndexMap) do
    if false == value._isMain and category == value._category then
      isOnlyOneSubCategory = isOnlyOneSubCategory + 1
      onlyOnDetail = value._detail
    end
  end
  if 1 == isOnlyOneSubCategory then
    PaGlobal_Option:SelectOptionFrame(category, onlyOnDetail)
  else
    tree2:getElementManager():toggle(toInt64(0, key))
  end
  self._list2._selectedKey = key
  tree2:getElementManager():refillKeyList()
  local heightIndex = tree2:getIndexByKey(toInt64(0, key))
  tree2:moveIndex(heightIndex)
end
function PaGlobal_Option:ResetListToggleState()
  local tree2 = self._ui._list2
  for k, value in pairs(self._list2._tree2IndexMap) do
    if true == value._isMain then
      local keyint64 = toInt64(0, k)
      local keyElement = tree2:getElementManager():getByKey(keyint64, false)
      if true == keyElement:getIsOpen() then
        tree2:getElementManager():toggle(keyint64)
        self._list2._selectedKey = -1
        tree2:requestUpdateByKey(keyint64)
      end
      keyElement:setIsOpen(false)
    end
  end
end
function PaGlobal_Option:ClickedSubCategory(key, category, detail)
  self._list2._selectedSubKey = key
  self:SelectOptionFrame(category, detail)
  self._ui._list2:getElementManager():refillKeyList()
end
function FGlobal_Option_CategoryUpdate(contents, key)
  local idx = Int64toInt32(key)
  local indexMap = PaGlobal_Option._list2._tree2IndexMap[idx]
  local categoryBar = UI.getChildControl(contents, "RadioButton_MenuName")
  local categoryFocus = UI.getChildControl(contents, "Static_Focus")
  local categorySubBar = UI.getChildControl(contents, "RadioButton_SubMenuName")
  local categorySubFocus = UI.getChildControl(categorySubBar, "Static_SubFocus")
  categoryBar:SetShow(true)
  categoryBar:setNotImpactScrollEvent(true)
  categoryFocus:SetShow(false)
  categorySubFocus:SetShow(false)
  categorySubBar:SetShow(false)
  if indexMap._isMain then
    categoryBar:SetText(indexMap._string)
    categoryBar:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedMainCategory(" .. idx .. ", " .. " \"" .. indexMap._category .. "\"" .. ")")
    categoryBar:SetCheck(PaGlobal_Option._list2._selectedKey == idx)
  else
    categoryBar:SetShow(false)
    categorySubBar:SetShow(true)
    categorySubBar:SetText(indexMap._string)
    categorySubBar:addInputEvent("Mouse_LUp", "PaGlobal_Option:ClickedSubCategory(" .. idx .. ", " .. "\"" .. indexMap._category .. "\"" .. ", " .. "\"" .. indexMap._detail .. "\"" .. ")")
    local focusControl = UI.getChildControl(categorySubBar, "Static_SubFocus")
    focusControl:SetShow(PaGlobal_Option._list2._selectedSubKey == idx)
  end
end
function FGlobal_Option_TogglePanel()
  if CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode == UI.Get_ProcessorInputMode() then
    return
  end
  if GetUIMode() == Defines.UIMode.eUIMode_Gacha_Roulette then
    return
  end
  if false == PaGlobal_Option:isOpen() then
    PaGlobal_Option:Open()
  else
    PaGlobal_Option:Close()
  end
end
function PaGlobal_Option:SetMonoTone(elementName, monoTone)
  if nil == self._elements[elementName] or nil == self._elements[elementName]._eventControl then
    return
  end
  if nil == monoTone then
    return
  end
  for index, eventcontrol in pairs(self._elements[elementName]._eventControl) do
    eventcontrol:SetMonoTone(monoTone)
  end
end
function PaGlobal_Option:SetEnable(elementName, enable)
  if nil == self._elements[elementName] or nil == self._elements[elementName]._eventControl then
    return
  end
  if nil == enable then
    return
  end
  for index, eventcontrol in pairs(self._elements[elementName]._eventControl) do
    eventcontrol:SetEnable(enable)
  end
end
function PaGlobal_Option:SetHideOption(elementName, isHide)
  if nil == self._elements[elementName] or nil == self._elements[elementName]._eventControl then
    return
  end
  if nil == isHide then
    return
  end
  for index, eventcontrol in pairs(self._elements[elementName]._eventControl) do
    eventcontrol:SetShow(not isHide)
  end
end
function FGlobal_Option_OnScreenResize()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_Window_cOption:SetPosX((screenSizeX - Panel_Window_cOption:GetSizeX()) / 2)
  Panel_Window_cOption:SetPosY((screenSizeY - Panel_Window_cOption:GetSizeY()) / 2)
  local uiScale = PaGlobal_Option:Get("UIScale")
  if nil == uiScale then
    return
  end
  uiScale = uiScale + 0.002
  PaGlobal_Option:SetControlSetting("UIScale", uiScale)
end
function FGlobal_PerFrameFPSTextUpdate()
  local value = math.floor(ToClient_getFPS())
  for index, control in ipairs(PaGlobal_Option._fpsTextControl) do
    if value < 20 then
      control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_FPS") .. ": " .. "<PAColor0xfff25221>" .. tostring(value) .. "<PAOldColor>")
    else
      control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_FPS") .. ": " .. "<PAColor0xff00f281>" .. tostring(value) .. "<PAOldColor>")
    end
  end
end
function PaGlobal_Option:SaveCutsomOption(index)
  self._curCustomOption = index
  local messageBoxMemo = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_MESSAGEBOX_CUSTOM_SAVE_DESC" .. tostring(index))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_MESSAGEBOX_CUSTOM_TITLE"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_SaveCustomOption,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  ClearFocusEdit()
end
function FGlobal_Option_SaveCustomOption()
  local result = ToClient_saveCustimizeOption(PaGlobal_Option._curCustomOption)
end
function PaGlobal_Option:LoadCutsomOption(index)
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UI_SETTING_NOTCURRENTACTION_ACK"))
    return
  end
  self._curCustomOption = index
  local messageBoxMemo = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_MESSAGEBOX_CUSTOM_LOAD_DESC" .. tostring(index))
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_MESSAGEBOX_CUSTOM_TITLE"),
    content = messageBoxMemo,
    functionYes = FGlobal_Option_LoadCustomOption,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
  ClearFocusEdit()
end
function FGlobal_Option_LoadCustomOption()
  local fontsize = PaGlobal_Option:Get("UIFontSizeType")
  local index = PaGlobal_Option._curCustomOption
  local result = ToClient_loadCustimizeOption(index)
  if true == result then
    for _, icon in pairs(PaGlobal_Option._ui._customLoadConfirmIcon) do
      icon:SetShow(false)
    end
    PaGlobal_Option._ui._customLoadConfirmIcon[index]:SetShow(true)
    if nil ~= PaGlobal_Option._elements.UIFontSizeType and fontsize ~= PaGlobal_Option._elements.UIFontSizeType._initValue then
      PaGlobal_Option:SetXXX("UIFontSizeType", PaGlobal_Option._elements.UIFontSizeType._initValue)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_MESSAGEBOX_CUSTOM_NOLOAD"))
  end
end
function FromClient_ChangeScreenMode()
  reloadGameUI()
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GAMEOPTION_CHANGESCREENMODE_FULL")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY"),
    content = messageBoxMemo,
    functionYes = ToClient_ChangePreScreenMode,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
Panel_Window_cOption:RegisterUpdateFunc("FGlobal_PerFrameFPSTextUpdate")
registerEvent("EventGameOptionToggle", "FGlobal_Option_TogglePanel")
registerEvent("onScreenResize", "FGlobal_Option_OnScreenResize")
registerEvent("FromClient_ChangeScreenMode", "FromClient_ChangeScreenMode")
function PaGlobal_Option:SetContentsOption()
  if true == ToClient_isAvailableChangeServiceType() then
    if nil ~= self._frames.Function.Nation then
      UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder2_Import"):SetShow(true)
      UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder3_Import"):SetShow(true)
    end
    local bg = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder2_Import")
    local checkbuttonUseChattingFilter = UI.getChildControl(bg, "CheckButton_UseChattingFilter")
    local staticUseChattingFilter = UI.getChildControl(bg, "StaticText_UseChattingFilterDesc")
    if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_NA) or true == isGameTypeSA() or true == isGameTypeTH() or true == isGameTypeID() or CppEnums.GameServiceType.eGameServiceType_DEV == getGameServiceType() then
      checkbuttonUseChattingFilter:SetShow(true)
      staticUseChattingFilter:SetShow(true)
    else
      checkbuttonUseChattingFilter:SetShow(false)
      staticUseChattingFilter:SetShow(false)
      setUseChattingFilter(true)
      self._elements.UseChattingFilter = nil
    end
  elseif nil ~= self._frames.Function.Nation then
    local nationBgOrder2 = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder2_Import")
    local nationBgOrder3 = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder3_Import")
    nationBgOrder2:SetShow(false)
    nationBgOrder3:SetShow(false)
    if true == isGameTypeTH() then
      nationBgOrder2:SetShow(true)
      nationBgOrder2:SetSize(nationBgOrder2:GetSizeX(), nationBgOrder2:GetSizeY() - 40)
      for ii = 0, 10 do
        local addStr = ""
        if ii > 0 then
          addStr = tostring(ii)
        end
        local control = UI.getChildControlNoneAssert(nationBgOrder2, "RadioButton_ServiceResourceType" .. addStr)
        if nil ~= control then
          control:SetShow(false)
        else
          break
        end
      end
    end
  end
  if false == _ContentsGroup_isFairy then
    local fairyVoiceBG = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder3_Import")
    fairyVoiceBG:SetShow(false)
    self._elements.EnableAudioFairy = nil
    local fairyVolumeBG = UI.getChildControl(self._frames.Sound.Volume._uiFrameContent, "StaticText_BgOrder8_Import")
    fairyVolumeBG:SetShow(false)
    self._elements.VolumeFairy = nil
  end
  if true == isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_NA) or true == isGameTypeSA() or true == isGameTypeRussia() then
    local npcvoicebg = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder0_Import")
    local npcvoicebgSize = npcvoicebg:GetSizeY()
    local _bg = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder1_Import")
    _bg:SetPosY(_bg:GetPosY() - npcvoicebg:GetSizeY() - 10)
    local _bg1 = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder2_Import")
    _bg1:SetPosY(_bg1:GetPosY() - npcvoicebg:GetSizeY() - 10)
    local _bg2 = UI.getChildControl(self._frames.Function.Nation._uiFrameContent, "StaticText_BgOrder3_Import")
    _bg2:SetPosY(_bg2:GetPosY() - npcvoicebg:GetSizeY() - 10)
    npcvoicebg:SetShow(false)
    npcvoicebg = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder2_Import")
    npcvoicebg:SetShow(false)
    local fairyVoiceBG = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder3_Import")
    fairyVoiceBG:SetPosY(npcvoicebg:GetPosY())
    self._elements.AudioResourceType = nil
  end
  if false == ToClinet_isGraphicUltraAvailable() then
    local bg = UI.getChildControl(self._frames.Graphic.Quality._uiFrameContent, "StaticText_BgOrder1_Import")
    local bg1 = UI.getChildControl(self._frames.Performance.GraphicQuality._uiFrameContent, "StaticText_BgOrder1_Import")
    UI.getChildControl(bg, "RadioButton_GraphicOption7"):SetShow(false)
    UI.getChildControl(bg1, "RadioButton_GraphicOption7"):SetShow(false)
    UI.getChildControl(bg, "RadioButton_GraphicOption8"):SetShow(false)
    UI.getChildControl(bg1, "RadioButton_GraphicOption8"):SetShow(false)
  else
    local bg = UI.getChildControl(self._frames.Graphic.Quality._uiFrameContent, "StaticText_BgOrder1_Import")
    local bg1 = UI.getChildControl(self._frames.Performance.GraphicQuality._uiFrameContent, "StaticText_BgOrder1_Import")
    local ultra1 = UI.getChildControl(bg, "RadioButton_GraphicOption8")
    local ultra2 = UI.getChildControl(bg1, "RadioButton_GraphicOption8")
    self._tooltip.GraphicUltra1 = {
      control = ultra1,
      desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_GRAPHIC_QUALITY_GraphicUltraHigh_Tooltip")
    }
    self._tooltip.GraphicUltra2 = {
      control = ultra2,
      desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEWGAMEOPTION_GRAPHIC_QUALITY_GraphicUltraHigh_Tooltip")
    }
    ultra1:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true, \"GraphicUltra1\" )")
    ultra2:addInputEvent("Mouse_On", "PaGlobal_Option:Simpletooltips( true, \"GraphicUltra2\" )")
    ultra1:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false, \"GraphicUltra1\" )")
    ultra2:addInputEvent("Mouse_Out", "PaGlobal_Option:Simpletooltips( false, \"GraphicUltra2\" )")
  end
  if false == isNeedGameOptionFromServer() then
    return
  end
  if false == _ContentsGroup_StackingHpBar and nil ~= self._frames.Function.View then
    local bg = UI.getChildControl(self._frames.Function.View._uiFrameContent, "StaticText_BgOrder0_Import")
    local checkbuttonHpbar = UI.getChildControl(bg, "CheckButton_ShowStackHp")
    local staticHpbar = UI.getChildControl(bg, "StaticText_ShowStackHp_Desc")
    checkbuttonHpbar:SetShow(false)
    staticHpbar:SetShow(false)
    bg:SetSize(self._frames.Function.View._uiFrame:GetSizeX(), bg:GetSizeY() - checkbuttonHpbar:GetSizeY())
    self._elements.ShowStackHp = nil
  end
  local availableExchangeRefuse = true == isDev or true == isUsePcExchangeInLocalizingValue()
  if false == availableExchangeRefuse and nil ~= self._frames.Function.Etc then
    local bg = UI.getChildControl(self._frames.Function.Etc._uiFrameContent, "StaticText_BgOrder1_Import")
    local checkbuttonExchangeRefuse = UI.getChildControl(bg, "CheckButton_IsExchangeRefuse")
    local staticExchangeRefuse = UI.getChildControl(bg, "StaticText_IsExchangeRefuse_Desc")
    checkbuttonExchangeRefuse:SetShow(false)
    staticExchangeRefuse:SetShow(false)
    bg:SetSize(self._frames.Function.Etc._uiFrame:GetSizeX(), bg:GetSizeY() - checkbuttonExchangeRefuse:GetSizeY())
    self._elements.IsExchangeRefuse = nil
  end
  local availablefontSize = isGameServiceTypeDev() or isGameTypeTaiwan() or isGameTypeKorea() or isGameTypeJapan()
  if false == availablefontSize and self._frames.Function.Convenience then
    local bg = UI.getChildControl(self._frames.Function.Convenience._uiFrameContent, "StaticText_BgOrder1_Import")
    bg:SetShow(false)
    self._elements.UIFontSizeType = nil
  end
  if false == _ContentsGroup_isFairy then
    local fairyRenderBG = UI.getChildControl(self._frames.Function.View._uiFrameContent, "StaticText_BgOrder4_Import")
    fairyRenderBG:SetShow(false)
    self._elements.FairyRender = nil
  end
  if false == _ContentsGroup_StatTierIcon then
    local statTierBg = UI.getChildControl(self._frames.Function.View._uiFrameContent, "StaticText_BgOrder5_Import")
    statTierBg:SetShow(false)
    self._elements.ShowReputation = nil
    local damageMeterRenderBG = UI.getChildControl(self._frames.Function.View._uiFrameContent, "StaticText_BgOrder3_Import")
    damageMeterRenderBG:SetPosY(damageMeterRenderBG:GetPosY() - statTierBg:GetSizeY() - 10)
    self._frames.Function.View._uiFrameContent:SetSize(self._frames.Function.View._uiFrameContent:GetSizeX(), self._frames.Function.View._uiFrameContent:GetSizeY() - statTierBg:GetSizeY() - 10)
  end
  if false == _ContentsGroup_DamageMeter then
    local damageMeterRenderBG = UI.getChildControl(self._frames.Function.View._uiFrameContent, "StaticText_BgOrder3_Import")
    local damageMeterButton = UI.getChildControl(damageMeterRenderBG, "CheckButton_DamageMeter")
    local damageMeterDesc = UI.getChildControl(damageMeterRenderBG, "StaticText_DamageMeter_Desc")
    damageMeterButton:SetShow(false)
    damageMeterDesc:SetShow(false)
    self._elements.DamageMeter = nil
  end
  if _ContentsGroup_isConsoleTest then
    local bg0 = UI.getChildControl(self._frames.Function.Alert._uiFrameContent, "StaticText_BgOrder0_Import")
    local bg1 = UI.getChildControl(self._frames.Function.Alert._uiFrameContent, "StaticText_BgOrder1_Import")
    local bg2 = UI.getChildControl(self._frames.Function.Alert._uiFrameContent, "StaticText_BgOrder2_Import")
    local bg3 = UI.getChildControl(self._frames.Function.Alert._uiFrameContent, "StaticText_BgOrder3_Import")
    UI.getChildControl(bg0, "CheckButton_AlertOtherMarket"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_AlertOtherMarket_Desc"):SetShow(false)
    UI.getChildControl(bg0, "CheckButton_AlertNormalTrade"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_AlertNormalTrade_Desc"):SetShow(false)
    UI.getChildControl(bg0, "CheckButton_AlertRoyalTrade"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_AlertRoyalTrade_Desc"):SetShow(false)
    UI.getChildControl(bg0, "CheckButton_AlertItemMarket"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_AlertItemMarket_Desc"):SetShow(false)
    bg0:SetShow(false)
    UI.getChildControl(bg3, "CheckButton_AlertNearMonster"):SetShow(false)
    UI.getChildControl(bg3, "StaticText_AlertNearMonster_Desc"):SetShow(false)
    UI.getChildControl(bg3, "CheckButton_AlertGuildQuestMessage"):SetShow(false)
    UI.getChildControl(bg3, "StaticText_AlertGuildQuestMessage_Desc"):SetShow(false)
    local xx = UI.getChildControl(bg3, "CheckButton_ShowCashAlert")
    local xxx = UI.getChildControl(bg3, "StaticText_ShowCashAlert_Desc")
    xx:SetShow(false)
    xxx:SetShow(false)
    local xx1 = UI.getChildControl(bg3, "CheckButton_ShowGuildLoginMessage")
    local xxx1 = UI.getChildControl(bg3, "StaticText_ShowGuildLoginMessage_Desc")
    xx1:SetPosY(xx:GetPosY())
    xxx1:SetPosY(xxx:GetPosY())
    bg1:SetShow(false)
    bg2:SetShow(false)
    bg3:SetPosY(bg0:GetPosY())
    local bg00 = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder0_Import")
    UI.getChildControl(bg00, "CheckButton_EnableWhisperMusic"):SetShow(false)
    UI.getChildControl(bg00, "StaticText_EnableWhisperMusic_Desc"):SetShow(false)
    UI.getChildControl(bg00, "CheckButton_EnableTraySoundOnOff"):SetShow(false)
    UI.getChildControl(bg00, "StaticText_EnableTraySoundOnOff_Desc"):SetShow(false)
    local bg11 = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder1_Import")
    if nil ~= bg11 then
      local x = UI.getChildControl(bg11, "RadioButton_BattleSoundType2")
      if nil ~= x then
        x:SetShow(false)
      end
    end
    local bg22 = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder2_Import")
    local bg33 = UI.getChildControl(self._frames.Sound.OnOff._uiFrameContent, "StaticText_BgOrder3_Import")
    local bg77 = UI.getChildControl(self._frames.Sound.Volume._uiFrameContent, "StaticText_BgOrder7_Import")
    local bg88 = UI.getChildControl(self._frames.Sound.Volume._uiFrameContent, "StaticText_BgOrder8_Import")
    bg22:SetShow(false)
    bg33:SetShow(false)
    bg77:SetShow(false)
    bg88:SetShow(false)
    local bg0 = UI.getChildControl(self._frames.Interface.Action._uiFrameContent, "StaticText_BgOrder0_Import")
    local bg1 = UI.getChildControl(self._frames.Interface.Action._uiFrameContent, "StaticText_BgOrder1_Import")
    local bg2 = UI.getChildControl(self._frames.Interface.Action._uiFrameContent, "StaticText_BgOrder2_Import")
    bg0:SetShow(false)
    bg1:SetShow(false)
    bg2:SetPosY(bg0:GetPosY())
    local bg0 = UI.getChildControl(self._frames.Interface.Pad._uiFrameContent, "StaticText_BgOrder0_Import")
    UI.getChildControl(bg0, "CheckButton_GamePadEnable"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_UsePadDesc"):SetShow(false)
    UI.getChildControl(bg0, "CheckButton_ShowKeyGuide"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_ShowKeyGuideDesc"):SetShow(false)
    bg0:SetSize(bg0:GetSizeX(), bg0:GetSizeY() - 30)
    local bg1 = UI.getChildControl(self._frames.Function.Etc._uiFrameContent, "StaticText_BgOrder1_Import")
    UI.getChildControl(bg1, "CheckButton_IsPvpRefuse"):SetShow(false)
    UI.getChildControl(bg1, "StaticText_IsPvpRefuse_Desc"):SetShow(false)
    UI.getChildControl(bg1, "CheckButton_IsExchangeRefuse"):SetShow(false)
    UI.getChildControl(bg1, "StaticText_IsExchangeRefuse_Desc"):SetShow(false)
    bg1:SetSize(bg1:GetSizeX(), bg1:GetSizeY() - 60)
    local bg2 = UI.getChildControl(self._frames.Function.Etc._uiFrameContent, "StaticText_BgOrder2_Import")
    if true == _ContentsGroup_RenewUI then
      bg1:SetShow(false)
      bg2:SetPosY(bg2:GetPosY() - 60 - bg1:GetSizeY())
    else
      bg2:SetPosY(bg2:GetPosY() - 60)
    end
    local bgHdr = UI.getChildControl(self._frames.Graphic.HDR._uiFrameContent, "Static_HDR_ImageBgs_Import")
    local hdrImage = UI.getChildControl(bgHdr, "Static_HDR_Image")
    local hdrLeftBlackImage = UI.getChildControl(bgHdr, "Static_HDR_Black")
    local hdrRightWhiteImage = UI.getChildControl(bgHdr, "Static_HDR_White")
    hdrImage:SetColorExtra(Defines.Color.C_FFFFFFFF, 1000000)
    hdrLeftBlackImage:SetColorExtra(Defines.Color.C_FFFFFFFF, 1.45)
    hdrRightWhiteImage:SetColorExtra(Defines.Color.C_FFFFFFFF, 1)
    if false == getHdrDiplayEnable() then
      local bg0 = UI.getChildControl(self._frames.Graphic.HDR._uiFrameContent, "StaticText_BgOrder0_Import")
      local title0 = UI.getChildControl(bg0, "StaticText_Title")
      local slider0 = UI.getChildControl(bg0, "Slider_HDRDisplayGamma")
      bg0:SetMonoTone(true)
      bg0:SetIgnore(true)
      slider0:SetIgnore(true)
      title0:SetText(title0:GetText() .. " (Please check HDR setting)")
      local bg1 = UI.getChildControl(self._frames.Graphic.HDR._uiFrameContent, "StaticText_BgOrder1_Import")
      local title1 = UI.getChildControl(bg1, "StaticText_Title")
      local slider1 = UI.getChildControl(bg1, "Slider_HDRDisplayMaxNits")
      bg1:SetMonoTone(true)
      bg1:SetIgnore(true)
      slider1:SetIgnore(true)
      title1:SetText(title1:GetText() .. " (Please check HDR setting)")
    end
    if false == isXBoxDevice_X() then
      local bg = UI.getChildControl(self._frames.Graphic.HDR._uiFrameContent, "StaticText_BgOrder2_Import")
      local title = UI.getChildControl(bg, "StaticText_Title")
      local checkbutton = UI.getChildControl(bg, "CheckButton_UltraHighDefinition")
      bg:SetMonoTone(true)
      bg:SetIgnore(true)
      checkbutton:SetIgnore(true)
      title:SetText(title:GetText() .. " (Xbox One X Only)")
    end
  else
    local bg0 = UI.getChildControl(self._frames.Interface.Pad._uiFrameContent, "StaticText_BgOrder0_Import")
    UI.getChildControl(bg0, "CheckButton_ShowKeyGuide"):SetShow(false)
    UI.getChildControl(bg0, "StaticText_ShowKeyGuideDesc"):SetShow(false)
    bg0:SetSize(bg0:GetSizeX(), bg0:GetSizeY() - 30)
    self._elements.HDRDisplayGamma = nil
    self._elements.HDRDisplayMaxNits = nil
    self._elements.UltraHighDefinition = nil
  end
  if true == UI.checkResolution4KForXBox() then
    for i, v in pairs(self._elements.UIScale._eventControl) do
      v:SetIgnore(true)
      v:SetMonoTone(true)
      UI.getChildControl(v, "Slider_Button"):SetIgnore(true)
    end
  end
  if true == isGameTypeKR2() then
    local bg1 = UI.getChildControl(self._frames.Graphic.Quality._uiFrameContent, "StaticText_BgOrder1_Import")
    PaGlobal_Option:SetHideOption("BloodEffect", true)
    PaGlobal_Option._functions.BloodEffect(0)
    UI.getChildControl(bg1, "StaticText_BloodEffect_Desc"):SetShow(false)
    PaGlobal_Option:SetHideOption("LensBlood", true)
    PaGlobal_Option._functions.LensBlood(false)
    UI.getChildControl(bg1, "StaticText_LensBlood_Desc"):SetShow(false)
  end
end
function FGlobal_Temp_ActionKeySetting(actionInputType)
  if false == ToClient_IsDevelopment() then
    return
  end
  PaGlobal_Option._keyCustomInputType = {nil, actionInputType}
  SetUIMode(Defines.UIMode.eUIMode_KeyCustom_ActionPad)
  setKeyCustomizing(true)
end
PaGlobal_Console_TopviewMode = false
function FGlobal_ToggleTopViewMode()
  if true == _ContentsGroup_isConsoleTest then
    PaGlobal_Console_TopviewMode = not PaGlobal_Console_TopviewMode
    setTopViewMode(PaGlobal_Console_TopviewMode)
  end
end
function PaGlobal_Option:CheckEnableSimpleUI()
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    if 5 < selfPlayer:get():getLevel() then
      PaGlobal_Option:SetMonoTone("EnableSimpleUI", false)
      PaGlobal_Option:SetEnable("EnableSimpleUI", true)
    else
      PaGlobal_Option:SetMonoTone("EnableSimpleUI", true)
      PaGlobal_Option:SetEnable("EnableSimpleUI", false)
    end
  else
    PaGlobal_Option:SetMonoTone("EnableSimpleUI", true)
    PaGlobal_Option:SetEnable("EnableSimpleUI", false)
  end
end
function FGlobal_GameOption_OpenByMenu(index)
  showGameOption()
  if 0 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Graphic", "Quality")
  elseif 1 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Sound", "OnOff")
  elseif 2 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Function", "Convenience")
  elseif 3 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Interface", "Action")
  elseif 4 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Interface", "UI")
  elseif 5 == index then
    PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
    PaGlobal_Option:GoCategory("Performance", "Optimize")
  end
end
function FGlobal_GameOptionOpen()
  if false == PaGlobal_Option:isOpen() then
    showGameOption()
  end
  PaGlobal_Option:MoveUi(PaGlobal_Option.UIMODE.Category)
  PaGlobal_Option:GoCategory("Function", "Nation")
end
function FGlobal_GetCurrentLUT()
  return PaGlobal_Option:Get("LUT")
end
function FGlobal_IsChecked_SkillCommand()
  return isChecked_SkillCommand
end
function GameOption_GetHideWindow()
  return PaGlobal_Option:Get("HideWindowByAttacked")
end
function GameOption_ShowGuildLoginMessage()
  return PaGlobal_Option:Get("ShowGuildLoginMessage")
end
function GameOption_GetShowStackHp()
  return PaGlobal_Option:Get("ShowStackHp")
end
function GameOption_UpdateOptionChanged()
end
function GameOption_Cancel()
  PaGlobal_Option:Close()
end
function FGlobal_SpiritGuide_IsShow()
  return PaGlobal_Option:Get("ShowComboGuide")
end
function FGlobal_getUIScale()
  local uiScale = {}
  uiScale.min = 50
  uiScale.max = 200
  return uiScale
end
function FGlobal_returnUIScale()
  local interval = PaGlobal_Option._elements.UIScale._sliderValueMax - PaGlobal_Option._elements.UIScale._sliderValueMin
  local convertedValue = (PaGlobal_Option._elements.UIScale._sliderValueMin + interval * PaGlobal_Option:Get("UIScale")) * 0.01
  convertedValue = math.floor((convertedValue + 0.002) * 100) / 100
  return convertedValue
end
function FGlobal_saveUIScale(scale)
  local sliderValue = PaGlobal_Option:FromRealValueToSliderValue(scale, 0.5, 2)
  if sliderValue >= 1 then
    return
  end
  PaGlobal_Option:SetControlSetting("UIScale", PaGlobal_Option:FromRealValueToSliderValue(scale, 0.5, 2))
end
function getUiFontSize()
  return PaGlobal_Option:Get("UIFontSizeType")
end
function SimpleUI_Check(simpleUI_Check)
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer and 6 == selfPlayer:get():getLevel() then
    PaGlobal_Option:SetXXX("EnableSimpleUI", simpleUI_Check)
  end
end
function GameOption_SetUIMode(uiScale)
  local uiScaleOption = PaGlobal_Option._elements.UIScale
  uiScaleOption._initValue = PaGlobal_Option:FromRealValueToSliderValue(uiScale, 0.5, 2)
end
function ResetKeyCustombyAttacked()
  if Panel_Window_cOption:GetShow() then
    setKeyCustomizing(false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
end
function GameOption_ComboGuideValueChange(isShow)
end
