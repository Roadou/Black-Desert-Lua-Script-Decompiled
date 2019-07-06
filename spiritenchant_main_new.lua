Panel_Window_Enchant:setMaskingChild(true)
Panel_Window_Enchant:setGlassBackground(true)
Panel_Window_Enchant:SetDragEnable(true)
Panel_Window_Enchant:SetDragAll(true)
Panel_Window_Enchant:RegisterShowEventFunc(true, "Enchant_ShowAni()")
Panel_Window_Enchant:RegisterShowEventFunc(false, "Enchant_HideAni()")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Enchant")
PaGlobal_Enchant = {
  _ui = {
    _button_Question = UI.getChildControl(Panel_Window_Enchant, "Button_Question"),
    _radiobutton_EnchantTab = UI.getChildControl(Panel_Window_Enchant, "Radiobutton_EnchantTab"),
    _radiobutton_CronEnchantTab = UI.getChildControl(Panel_Window_Enchant, "Radiobutton_CronEnchantTab"),
    _radiobutton_EatTab = UI.getChildControl(Panel_Window_Enchant, "RadioButton_EatEquip"),
    _effect_Enchant = UI.getChildControl(Panel_Window_Enchant, "Static_EnchantEffect"),
    _button_Apply = UI.getChildControl(Panel_Window_Enchant, "Button_EnchantApply"),
    _button_SecretExtract = UI.getChildControl(Panel_Window_Enchant, "Button_SecretExtraction"),
    _statictext_noticeApplyButton = UI.getChildControl(Panel_Window_Enchant, "StaticText_NoticeApplyButton"),
    _checkbox_skipEffect = UI.getChildControl(Panel_Window_Enchant, "CheckBox_SkipEffect"),
    _tooltip_TargetItem = UI.getChildControl(Panel_Window_Enchant, "StaticText_Notice_Slot_0"),
    _tooltip_EnchantMaterial = UI.getChildControl(Panel_Window_Enchant, "StaticText_Notice_Slot_1"),
    _statictext_EnchantResult = UI.getChildControl(Panel_Window_Enchant, "StaticText_Result"),
    _difficultyBg = UI.getChildControl(Panel_Window_Enchant, "Static_DifficultyBg"),
    _difficultyValue = {},
    _blablaBg = UI.getChildControl(Panel_Window_Enchant, "Static_BlackSpiritEffect"),
    _blablaText = nil,
    _frame_DescEnchant = UI.getChildControl(Panel_Window_Enchant, "Static_DescEnchantFrame"),
    _statictext_EnchantFailCount = nil,
    _statictext_ValksCount = nil,
    _statictext_TotalEnchantCount = nil,
    _statictext_EnchantInfo = nil,
    _radiobutton_EasyEnchant = nil,
    _radiobutton_DifficultEnchant = nil,
    _checkbox_ForcedEnchant = nil,
    _checkbox_UseCron = nil,
    _tooltip_ForcedEnchant = nil,
    _tooltip_UseCron = nil,
    _slot_Cron = nil,
    _statictext_NumOfCron = nil,
    _static_descBG = nil,
    _frame_DescCronEnchant = UI.getChildControl(Panel_Window_Enchant, "Static_DescUpgradeFrame"),
    _progress_Cron = nil,
    _bg_ProgressCron = nil,
    _addStatBg = {},
    _statictext_AddStat = {},
    _staticText_CronEnchantCount = {},
    _statictext_BounsStats = nil,
    _statictext_CurCronState = nil,
    _statictext_StackForNext = nil,
    _frame_DescEatEquip = UI.getChildControl(Panel_Window_Enchant, "Static_EatingEquipFrame"),
    _slot_TargetItem = {},
    _slot_EnchantMaterial = {}
  },
  _const = {
    _gapX_PanelEquip = 10,
    _gapX_ToolTip = 7,
    _gapY_ToolTip = 30,
    _posX_CronCount = 25,
    _posY_CronCount = 40,
    _gapY_CronCount = 20,
    _effectTime_Enchant = 6,
    _poxX_PanelOriginPos = Panel_Window_Enchant:GetPosY()
  },
  _enum_EnchantType = {
    _safe = 0,
    _unsafe = 1,
    _broken = 2,
    _gradedown = 3,
    _downAndBroken = 4
  },
  _enum_EnchantResult = {
    _success = 0,
    _broken = 1,
    _gradedown = 2,
    _fail = 3,
    _failAndPrevent = 4,
    _error = 5
  },
  _strForEnchantInfo = {
    _forcedChecked = "",
    _cronChecked = "",
    _notChecked = ""
  },
  _enchantInfo = nil,
  _screctExtractIvenType = nil,
  _numOfCronLevelText = 4,
  _animationTimeStamp = 0,
  _isAnimating = false,
  _resultFlag = false,
  _resultShowTime = 0,
  _resultTimeCheck = false,
  _grantItemSlotNo = nil,
  _grantItemWhereType = nil,
  _materialItemSlotNo = nil,
  _materialItemWhereType = nil,
  _isSetNewPerfectItemMaterial = false,
  _isLastEnchant = false,
  _isResulTextAnimation = false,
  _isPossiblePromotion = false,
  _isSlotChangeAnimation = false,
  _isSlotChangeMouseOver = false,
  _slotChangeFlag = true,
  _slotChangeMoveTime = 0.5,
  _slotChangeWaitTime = 7,
  _slotChangeDelayTime = 0,
  _isContentsEnable = ToClient_IsContentsGroupOpen("74"),
  _isCronBonusOpen = ToClient_IsContentsGroupOpen("222"),
  _isCronEnchantOpen = ToClient_IsContentsGroupOpen("234"),
  _isEatEnchantOpen = ToClient_IsContentsGroupOpen("498"),
  _enchantData = {},
  _isShowNoticeApplyButton = false,
  _eatEnchantValue = 0,
  _isCommonLastEnchant = false,
  _currentTab = 0,
  _isWaitingServer = false,
  _blablaDesc = {
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_5"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_6"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_7"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_8"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_9"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_10"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_11"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_12"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_13"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_14"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_15"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_16"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_17"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_18"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_19"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_20"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_21"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_22"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_23"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_24"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_25"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_26"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_27"),
    PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_BLABLADESC_28")
  }
}
function Enchant_ShowAni()
  local self = PaGlobal_Enchant
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  local aniInfo1 = Panel_Window_Enchant:addScaleAnimation(0, 0.08, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.13)
  aniInfo1.AxisX = Panel_Window_Enchant:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Enchant:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_Enchant:addScaleAnimation(0.08, 0.1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.13)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Enchant:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Enchant:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Enchant_HideAni()
  local enchantHide = UIAni.AlphaAnimation(0, Panel_Window_Enchant, 0, 0.2)
  enchantHide:SetHideAtEnd(true)
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
function PaGlobal_Enchant:initialize()
  self._ui._statictext_EnchantFailCount = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_EnchantFailCount")
  self._ui._statictext_ValksCount = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_ValksCount")
  self._ui._statictext_EnchantFailCountValue = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_EnchantFailCountValue")
  self._ui._statictext_ValksCountValue = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_ValksCountValue")
  self._ui._statictext_TotalEnchantCount = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_TotalEnchantFailCount")
  self._ui._statictext_EnchantInfo = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_EnchantInfo")
  self._ui._statictext_SafeEnchant = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_SafeEnchant")
  self._ui._statictext_Line = UI.getChildControl(self._ui._frame_DescEnchant, "Static_Line")
  self._ui._statictext_EnchantInfoTopLine = UI.getChildControl(self._ui._statictext_EnchantInfo, "Static_Top")
  self._ui._statictext_EnchantInfoBottom = UI.getChildControl(self._ui._statictext_EnchantInfo, "Static_Bottom")
  self._ui._statictext_EnchantInfoDesc = UI.getChildControl(self._ui._statictext_EnchantInfo, "StaticText_Desc")
  self._ui._checkbox_ForcedEnchant = UI.getChildControl(self._ui._frame_DescEnchant, "Checkbox_ForcedEnchant")
  self._ui._radiobutton_EasyEnchant = UI.getChildControl(self._ui._frame_DescEnchant, "Radiobutton_EasyEnchant")
  self._ui._radiobutton_DifficultEnchant = UI.getChildControl(self._ui._frame_DescEnchant, "Radiobutton_DifficultEnchant")
  self._ui._checkbox_UseCron = UI.getChildControl(self._ui._frame_DescEnchant, "Checkbox_UseCron")
  self._ui._tooltip_ForcedEnchant = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_ForcedEnchant_Tooltip")
  self._ui._tooltip_UseCron = UI.getChildControl(self._ui._frame_DescEnchant, "StaticText_UseCrone_Tooltip")
  self._ui._slot_Cron = UI.getChildControl(self._ui._frame_DescEnchant, "Static_Slot_Cron")
  self._ui._forceEnchantIcon = UI.getChildControl(self._ui._frame_DescEnchant, "CheckButton_FocedEnchant")
  self._ui._useCronIcon = UI.getChildControl(self._ui._frame_DescEnchant, "CheckButton_Cron")
  self._ui._froceEnchantTooltip = UI.getChildControl(self._ui._frame_DescEnchant, "Static_ForcedEnchant")
  self._ui._useCronTooltip = UI.getChildControl(self._ui._frame_DescEnchant, "Static_Cron")
  self._ui._statictext_NumOfCron = UI.getChildControl(self._ui._slot_Cron, "StaticText_NumOfCron")
  self._ui._topDesc = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_TopDesc")
  self._ui._topDesc2 = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_TopDesc2")
  self._ui._statictext_CurCronState = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_CurCronState")
  self._ui._progress_CronBg = UI.getChildControl(self._ui._frame_DescCronEnchant, "Static_ItemEnergy_BG")
  self._ui._progress_Cron = UI.getChildControl(self._ui._frame_DescCronEnchant, "Progress2_CronStack")
  self._ui._bg_ProgressCron = UI.getChildControl(self._ui._frame_DescCronEnchant, "Static_BGProgressCronStack")
  self._ui._addStatBg[0] = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_AddStat_0")
  self._ui._statictext_AddStat[0] = UI.getChildControl(self._ui._addStatBg[0], "StaticText_Stat")
  self._ui._addStatBg[1] = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_AddStat_1")
  self._ui._statictext_AddStat[1] = UI.getChildControl(self._ui._addStatBg[1], "StaticText_Stat")
  self._ui._addStatBg[2] = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_AddStat_2")
  self._ui._statictext_AddStat[2] = UI.getChildControl(self._ui._addStatBg[2], "StaticText_Stat")
  self._ui._addStatBg[3] = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_AddStat_3")
  self._ui._statictext_AddStat[3] = UI.getChildControl(self._ui._addStatBg[3], "StaticText_Stat")
  self._ui._txt_EatEnchantFailCount = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_EnchantFailCount")
  self._ui._txt_EatValksCount = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_ValksCount")
  self._ui._txt_EatEnchantFailCountValue = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_EnchantFailCountValue")
  self._ui._txt_EatValksCountValue = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_ValksCountValue")
  self._ui._txt_EatTotalEnchantCount = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_TotalEnchantFailCount")
  self._ui._txt_EatStackText = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_StackCount")
  self._ui._txt_EatStackRate = UI.getChildControl(self._ui._frame_DescEatEquip, "StaticText_StackRate")
  self._ui._stc_DescBG = UI.getChildControl(self._ui._frame_DescEatEquip, "Static_DescBG")
  self._ui._txt_EatDesc = UI.getChildControl(self._ui._stc_DescBG, "StaticText_Desc")
  self._ui._stc_AddCountBG = UI.getChildControl(self._ui._frame_DescEatEquip, "Static_AddCountBG")
  self._ui._stc_Arrow = UI.getChildControl(self._ui._stc_AddCountBG, "Static_Arrow")
  self._ui._txt_CurrentCount = UI.getChildControl(self._ui._stc_AddCountBG, "StaticText_CurrentCount")
  self._ui._txt_AddCount = UI.getChildControl(self._ui._stc_AddCountBG, "StaticText_AddCount")
  local eat_desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION")
  if false == _ContentsGroup_EatStackEnchant then
    self._ui._stc_AddCountBG:SetShow(false)
    self._ui._txt_EatStackRate:SetShow(false)
  else
    eat_desc = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_EATENCHANT_DESCRIPTION_FORSTACK")
  end
  self._ui._txt_EatDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_EatDesc:SetText(eat_desc)
  self._ui._stackTitle = UI.getChildControl(self._ui._bg_ProgressCron, "StaticText_StackTitle")
  self._ui._currentGrade = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_CurrentGrade")
  self._ui._maxGrade = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_MaxGrade")
  self._ui._currentStat = UI.getChildControl(self._ui._frame_DescCronEnchant, "StaticText_CurrentStack")
  self._ui._progress = UI.getChildControl(self._ui._frame_DescCronEnchant, "Progress2_EnergyEXP")
  self._ui._static_descBG = UI.getChildControl(self._ui._frame_DescCronEnchant, "Static_DescBg")
  self._ui._statictext_StackForNext = UI.getChildControl(self._ui._static_descBG, "StaticText_StackForNext")
  self._ui._statictext_BounsStats = UI.getChildControl(self._ui._static_descBG, "StaticText_BounsStats")
  self._ui._PartLine_Top = UI.getChildControl(self._ui._static_descBG, "Static_Top")
  self._ui._PartLine_Bottom = UI.getChildControl(self._ui._static_descBG, "Static_Bottom")
  self._ui._statictext_EnchantInfoDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  for dIndex = 0, 10 do
    self._ui._difficultyValue[dIndex] = UI.getChildControl(self._ui._difficultyBg, "Static_Difficulty_" .. dIndex)
    self._ui._difficultyValue[dIndex]:SetShow(false)
  end
  self._ui._blablaBg:AddEffect("fN_DarkSpirit_Gage_01A", true, 0, 0)
  self._ui._blablaText = UI.getChildControl(self._ui._blablaBg, "StaticText_BubbleDesc")
  self._ui._blablaText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  }
  self._ui._slot_TargetItem.icon = UI.getChildControl(Panel_Window_Enchant, "Static_Slot_0")
  SlotItem.new(self._ui._slot_TargetItem, "Slot_0", 0, Panel_Window_Enchant, slotConfig)
  self._ui._slot_TargetItem:createChild()
  self._ui._slot_TargetItem.empty = true
  self._ui._slot_TargetItem:clearItem()
  self._ui._slot_TargetItem.border:SetSize(42, 42)
  self._ui._slot_TargetItem.border:SetPosX(0)
  self._ui._slot_TargetItem.border:SetPosY(0)
  Panel_Tooltip_Item_SetPosition(0, self._ui._slot_TargetItem, "Enchant")
  self._ui._slot_EnchantMaterial.icon = UI.getChildControl(Panel_Window_Enchant, "Static_Slot_1")
  SlotItem.new(self._ui._slot_EnchantMaterial, "Slot_1", 1, Panel_Window_Enchant, slotConfig)
  self._ui._slot_EnchantMaterial:createChild()
  self._ui._slot_EnchantMaterial.empty = true
  self._ui._slot_EnchantMaterial:clearItem()
  self._ui._slot_EnchantMaterial.border:SetSize(42, 42)
  self._ui._slot_EnchantMaterial.border:SetPosX(1)
  self._ui._slot_EnchantMaterial.border:SetPosY(1)
  Panel_Tooltip_Item_SetPosition(1, self._ui._slot_EnchantMaterial, "Enchant")
  self._ui._statictext_BounsStats:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._statictext_StackForNext:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._checkbox_skipEffect:SetEnableArea(0, 0, self._ui._checkbox_skipEffect:GetTextSizeX() + 60, self._ui._checkbox_skipEffect:GetSizeY())
  local itemSSW = FromClient_getPreventDownGradeItem()
  self._ui._slot_Cron:ChangeTextureInfoName("")
  self._ui._PartLine_Top:ComputePos()
  self._ui._PartLine_Bottom:ComputePos()
  self._ui._statictext_noticeApplyButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._statictext_noticeApplyButton:SetAutoResize(true)
  self._ui._statictext_EnchantResult:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._button_SecretExtract:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._button_SecretExtract:SetText(self._ui._button_SecretExtract:GetText())
  self._ui._statictext_SafeEnchant:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._statictext_SafeEnchant:SetText(self._ui._statictext_SafeEnchant:GetText())
  self._ui._radiobutton_EnchantTab:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpEnchantTab()")
  self._ui._radiobutton_CronEnchantTab:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpCronTab()")
  self._ui._radiobutton_EatTab:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpEatTab()")
  self._ui._slot_EnchantMaterial.icon:addInputEvent("Mouse_RUp", "PaGlobal_Enchant:handleRUpEnchantSlot")
  self._ui._slot_TargetItem.icon:addInputEvent("Mouse_RUp", "PaGlobal_Enchant:handleRUpEnchantSlot")
  self._ui._button_Apply:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpEnchantApplyButton()")
  self._ui._button_SecretExtract:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUPSecretExtractButton()")
  self._ui._slot_TargetItem.icon:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnEnchantTargetTooltip()")
  self._ui._slot_TargetItem.icon:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutEnchantTargetTooltip()")
  self._ui._slot_TargetItem.icon:addInputEvent("Mouse_RUp", "PaGlobal_Enchant:handleRUpEnchantSlot()")
  self._ui._slot_EnchantMaterial.icon:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnEnchantMaterialTooltip()")
  self._ui._slot_EnchantMaterial.icon:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutEnchantMaterialTooltip()")
  self._ui._slot_EnchantMaterial.icon:addInputEvent("Mouse_RUp", "PaGlobal_Enchant:handleRUpEnchantSlot()")
  self._ui._froceEnchantTooltip:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnForceEnchantTooltip()")
  self._ui._froceEnchantTooltip:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutForceEnchantTooltip()")
  self._ui._useCronTooltip:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnCronIconTooltip()")
  self._ui._useCronTooltip:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutCronIconTooltip()")
  self._ui._checkbox_UseCron:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpUseChronBox()")
  self._ui._checkbox_ForcedEnchant:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:handleLUpForcedEnchantCheckBox()")
  self._ui._checkbox_skipEffect:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMUpSkipEffect()")
  self._ui._checkbox_skipEffect:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutSkipEffect()")
  self._ui._button_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"SpiritEnchant\" )")
  self._ui._button_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"SpiritEnchant\", \"true\")")
  self._ui._button_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"SpiritEnchant\", \"false\")")
  self._ui._radiobutton_EasyEnchant:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:didsetEnchantTarget(nil,true)")
  self._ui._radiobutton_EasyEnchant:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnEasyEnchant()")
  self._ui._radiobutton_EasyEnchant:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutEasyEnchant()")
  self._ui._radiobutton_DifficultEnchant:addInputEvent("Mouse_LUp", "PaGlobal_Enchant:didsetEnchantTarget(nil,true)")
  self._ui._radiobutton_DifficultEnchant:addInputEvent("Mouse_On", "PaGlobal_Enchant:handlemOnDifficultEnchant()")
  self._ui._radiobutton_DifficultEnchant:addInputEvent("Mouse_Out", "PaGlobal_Enchant:handleMOutDifficultEnchant()")
  self._ui._addStatBg[0]:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnAddStat(" .. 0 .. ")")
  self._ui._addStatBg[0]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._addStatBg[1]:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnAddStat(" .. 1 .. ")")
  self._ui._addStatBg[1]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._addStatBg[2]:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnAddStat(" .. 2 .. ")")
  self._ui._addStatBg[2]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._addStatBg[3]:addInputEvent("Mouse_On", "PaGlobal_Enchant:handleMOnAddStat(" .. 3 .. ")")
  self._ui._addStatBg[3]:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._statictext_AddStat[0]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._statictext_AddStat[1]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._statictext_AddStat[2]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui._statictext_AddStat[3]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  registerEvent("EventEnchantResultShow", "FromClient_EnchantResultShow")
  registerEvent("FromClient_EnchantFailCountUpResult", "PaGlobalFunc_SpiritEnchant_EnchantFailCountUpResult")
  registerEvent("FromClient_UpgradeItem", "FromClient_UpgradeItem")
  registerEvent("FromClient_UpdateEnchantFailCount", "FromClient_UpdateEnchantFailCount")
  registerEvent("FromClient_PromotionItem", "FromClient_PromotionItem")
  registerEvent("onScreenResize", "OnScreenEvent")
  registerEvent("FromClient_FailCountUpdate", "FromClient_FailCountUpdate")
  Panel_Window_Enchant:RegisterUpdateFunc("UpdateFunc_checkAnimation")
  self._ui._radiobutton_CronEnchantTab:SetShow(self._isCronEnchantOpen)
  self._ui._radiobutton_EatTab:SetShow(self._isEatEnchantOpen)
  self._currentTab = 0
  self._isWaitingServer = false
end
function PaGlobal_Enchant:init_EnchantFrame()
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, true)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, false)
  self:setEnable_CheckboxForcedEnchant(false)
  self:setEnable_CheckboxUseCron(false)
  self._ui._frame_DescEnchant:SetShow(true)
  self._ui._frame_DescCronEnchant:SetShow(false)
  self._ui._frame_DescEatEquip:SetShow(false)
  self._ui._checkbox_UseCron:SetCheck(false)
  self._ui._checkbox_ForcedEnchant:SetCheck(false)
  self._ui._checkbox_UseCron:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._checkbox_UseCron:SetText(self._ui._checkbox_UseCron:GetText())
  self._ui._tooltip_UseCron:SetShow(false)
  self._ui._tooltip_ForcedEnchant:SetShow(false)
  self._ui._statictext_EnchantInfoDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SETEQUIPMENT"))
  self._ui._statictext_EnchantInfoTopLine:ComputePos()
  self._ui._statictext_EnchantInfoBottom:ComputePos()
  self._ui._statictext_noticeApplyButton:SetShow(false)
  self._isShowNoticeApplyButton = false
  self:setText_NumOfCron(0, 0)
  self:setAsEnchantButton()
  self:showDifficultEnchantButton(false)
  self._isSlotChangeAnimation = false
  self._isSlotChangeMouseOver = false
  if not self._isContentsEnable then
    self._ui._useCronIcon:SetShow(false)
  end
  local _button_ApplySizeX = self._ui._button_Apply:GetSizeX()
  if _button_ApplySizeX <= self._ui._button_Apply:GetTextSizeX() then
    self._ui._button_Apply:SetSize(self._ui._button_Apply:GetTextSizeX() + 20, self._ui._button_Apply:GetSizeY())
    self._ui._button_Apply:ComputePos()
  end
  self._ui._blablaBg:SetShow(false)
  self:IsSkipAnimationForTab(1)
  self._currentTab = 0
  self._isWaitingServer = false
end
function PaGlobal_Enchant:init_CronFrame()
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, true)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, false)
  self._ui._frame_DescCronEnchant:SetShow(true)
  self._ui._frame_DescEnchant:SetShow(false)
  self._ui._frame_DescEatEquip:SetShow(false)
  self._ui._statictext_noticeApplyButton:SetShow(false)
  self._isShowNoticeApplyButton = false
  self:setTextCronEnchantState(0, 0)
  self:setCronStackProgress(0, 0)
  self:setAsCronEnchantButton()
  self:hideAllCronCountText()
  self._ui._static_descBG:ComputePos()
  self._ui._statictext_BounsStats:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SETEQUIPMENT"))
  self._ui._statictext_BounsStats:ComputePos()
  self._ui._statictext_StackForNext:SetText("")
  self._ui._statictext_EnchantResult:ResetVertexAni()
  self._ui._statictext_EnchantResult:SetScale(1, 1)
  self._ui._statictext_EnchantResult:SetSize(250, 20)
  self._ui._statictext_EnchantResult:ComputePos()
  self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_NOEQUIP"))
  self._ui._currentGrade:SetShow(false)
  self._ui._maxGrade:SetShow(false)
  self._ui._currentStat:SetShow(false)
  self._ui._progress:SetShow(false)
  self._ui._blablaBg:SetShow(false)
  self._isSlotChangeAnimation = false
  self._isSlotChangeMouseOver = false
  self:IsSkipAnimationForTab(2)
  self._currentTab = 1
  self._isWaitingServer = false
end
function PaGlobal_Enchant:init_EatFrame()
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, true)
  self:setEnable_CheckboxForcedEnchant(false)
  self:setEnable_CheckboxUseCron(false)
  self._ui._frame_DescEnchant:SetShow(false)
  self._ui._frame_DescCronEnchant:SetShow(false)
  self._ui._frame_DescEatEquip:SetShow(true)
  self._ui._txt_EatStackText:SetText("")
  self._ui._statictext_noticeApplyButton:SetShow(false)
  self._ui._blablaBg:SetShow(false)
  self:IsSkipAnimationForTab(3)
  self:setEnable_button_Apply(true)
  self._isSlotChangeAnimation = false
  self._isSlotChangeMouseOver = false
  if true == _ContentsGroup_EatStackEnchant then
    self._ui._txt_EatStackRate:SetText("")
  end
  self._currentTab = 2
  self._isWaitingServer = false
end
function PaGlobal_Enchant:showDifficultEnchantButton(isShow)
  self._ui._radiobutton_EasyEnchant:SetShow(isShow)
  self._ui._radiobutton_DifficultEnchant:SetShow(isShow)
  if isShow == false then
    self._ui._radiobutton_EasyEnchant:SetCheck(true)
    self._ui._radiobutton_DifficultEnchant:SetCheck(false)
  end
end
function PaGlobal_Enchant:showScretExtractButton(isShow)
  if _ContentsGroup_isSecretExtract and false == self:isCronEnchantTab() then
    self._ui._button_SecretExtract:SetShow(isShow)
    if true == isShow then
      PaGlobal_Enchant._ui._button_Apply:SetSpanSize(-70, 20)
      if nil ~= self._enchantInfo then
        local failCount = self._enchantInfo:ToClient_getFailCount()
        if failCount > 0 then
          self._ui._button_SecretExtract:SetIgnore(false)
          self._ui._button_SecretExtract:SetMonoTone(false)
          self._ui._button_SecretExtract:SetFontColor(Defines.Color.C_FFEFEFEF)
        else
          self._ui._button_SecretExtract:SetIgnore(true)
          self._ui._button_SecretExtract:SetMonoTone(true)
          self._ui._button_SecretExtract:SetFontColor(Defines.Color.C_FF626262)
        end
      else
        self._ui._button_SecretExtract:SetIgnore(true)
        self._ui._button_SecretExtract:SetMonoTone(true)
        self._ui._button_SecretExtract:SetFontColor(Defines.Color.C_FF626262)
      end
    else
      self._ui._button_Apply:SetSpanSize(0, 20)
    end
  else
    self._ui._button_Apply:SetSpanSize(0, 20)
    self._ui._button_SecretExtract:SetShow(false)
  end
end
function PaGlobal_Enchant:clearItemSlot(itemSlot)
  itemSlot.inventoryType = nil
  itemSlot.slotNo = nil
  itemSlot:clearItem()
  itemSlot.empty = true
  itemSlot.icon:EraseAllEffect()
end
function PaGlobal_Enchant:setItemToSlot(uiSlot, slotNo, itemWrapper, inventoryType)
  uiSlot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  uiSlot.empty = false
  uiSlot.slotNo = slotNo
  uiSlot.inventoryType = inventoryType
  uiSlot.icon:SetMonoTone(false)
  local getItem = getInventoryItemByType(inventoryType, slotNo)
  if nil ~= getItem then
    uiSlot:setItem(getItem)
  end
  if self._ui._slot_TargetItem == uiSlot and false == self:isEatTab() then
    self:showDifficulty(inventoryType, slotNo)
  end
end
function PaGlobal_Enchant:setItemToSlotMonoTone(uiSlot, itemStaticWrapper)
  uiSlot.icon:AddEffect("UI_Button_Hide", false, 0, 0)
  uiSlot.empty = false
  uiSlot.slotNo = 0
  uiSlot.inventoryType = CppEnums.TInventorySlotNoUndefined
  uiSlot.icon:SetMonoTone(true)
  if nil ~= itemStaticWrapper and nil ~= itemStaticWrapper:get() then
    uiSlot:setItemByStaticStatus(itemStaticWrapper, toInt64(0, 0), 0, false, false, false, 0, 0, nil)
  end
end
function PaGlobal_Enchant:setEnable_button_Apply(isTrue)
  local targetControl = self._ui._button_Apply
  if true == self._isWaitingServer then
    isTrue = false
  end
  targetControl:SetIgnore(not isTrue)
  targetControl:SetMonoTone(not isTrue)
  if isTrue then
    targetControl:SetFontColor(Defines.Color.C_FF96D4FC)
  else
    targetControl:SetFontColor(Defines.Color.C_FF626262)
    targetControl:EraseAllEffect()
  end
end
function PaGlobal_Enchant:SetCheck_RadioButton(radioBtn, isTrue)
  radioBtn:SetCheck(isTrue)
end
function PaGlobal_Enchant:setAsCancelButton()
  self._ui._button_Apply:EraseAllEffect()
  self._ui._button_Apply:EraseAllEffect()
  self._ui._button_Apply:SetAlpha(1)
  self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_CANCEL"))
  self._ui._button_Apply:SetFontColor(Defines.Color.C_FFC4BEBE)
end
function PaGlobal_Enchant:setAsEnchantButton()
  self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "ENCHANT_TEXT_TITLE"))
end
function PaGlobal_Enchant:setAsCronEnchantButton()
  self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_APPLY_BUTTON_NORM_CAPHRAS"))
end
function PaGlobal_Enchant:setAsPromotionEnchantButton()
  self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_APPLY_BUTTON_MAX_CAPHRAS"))
end
function PaGlobal_Enchant:setAsEatButton()
  self._ui._button_Apply:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_EATENCHANT"))
end
function PaGlobal_Enchant:setEnable_CheckboxForcedEnchant(isEnable)
  self._ui._checkbox_ForcedEnchant:SetIgnore(not isEnable)
  self._ui._checkbox_ForcedEnchant:SetMonoTone(not isEnable)
  self._ui._checkbox_ForcedEnchant:SetShow(isEnable)
  if isEnable == false then
    self._ui._checkbox_ForcedEnchant:SetCheck(false)
  end
  self._ui._forceEnchantIcon:SetCheck(not isEnable)
end
function PaGlobal_Enchant:setEnable_CheckboxUseCron(isEnable)
  if not self._isContentsEnable then
    isEnable = false
  end
  self._ui._checkbox_UseCron:SetIgnore(not isEnable)
  self._ui._checkbox_UseCron:SetMonoTone(not isEnable)
  self._ui._checkbox_UseCron:SetShow(isEnable)
  self._ui._statictext_NumOfCron:SetShow(isEnable)
  if isEnable == false then
    self._ui._checkbox_UseCron:SetCheck(false)
  end
  self._ui._useCronIcon:SetCheck(isEnable)
end
function PaGlobal_Enchant:isCronChecked()
  if false == self._ui._checkbox_UseCron:GetShow() then
    return false
  end
  if false == self._ui._checkbox_UseCron:IsCheck() then
    return false
  end
  if nil == self._strForEnchantInfo._cronChecked or "" == self._strForEnchantInfo._cronChecked then
    return false
  end
  return true
end
function PaGlobal_Enchant:setText_NumOfCron(cnt, needCnt)
  if cnt < needCnt then
    self._ui._statictext_NumOfCron:SetText("<PAColor0xffff7383>" .. tostring(cnt) .. "/" .. tostring(needCnt) .. "<PAOldColor>")
  else
    self._ui._statictext_NumOfCron:SetText("<PAColor0xFF0FBFFF>" .. tostring(cnt) .. "/" .. tostring(needCnt) .. "<PAOldColor>")
  end
end
function PaGlobal_Enchant:setText_PerfectCount(isShow, count, needCount)
  if false == isShow or nil == isShow then
    return
  end
  if count < needCount then
    self._ui._slot_EnchantMaterial.count:SetText("<PAColor0xffff7383>" .. tostring(count) .. "/" .. tostring(needCount) .. "<PAOldColor>")
  else
    self._ui._slot_EnchantMaterial.count:SetText("<PAColor0xFF0FBFFF>" .. tostring(count) .. "/" .. tostring(needCount) .. "<PAOldColor>")
  end
end
function PaGlobal_Enchant:setText_EnchantInfo(isChecked)
  if isChecked then
    self._ui._statictext_EnchantInfoDesc:SetText(self._strForEnchantInfo._forcedChecked)
    self._ui._checkbox_UseCron:SetCheck(false)
  elseif true == self:isCronChecked() then
    self._ui._statictext_EnchantInfoDesc:SetText(self._strForEnchantInfo._cronChecked)
    self._ui._checkbox_ForcedEnchant:SetCheck(false)
  else
    self._ui._statictext_EnchantInfoDesc:SetText(self._strForEnchantInfo._notChecked)
  end
  self._ui._statictext_EnchantInfoDesc:SetSize(self._ui._statictext_EnchantInfoDesc:GetSizeX(), self._ui._statictext_EnchantInfoDesc:GetTextSizeY())
  self._ui._statictext_EnchantInfoDesc:ComputePos()
  self._ui._statictext_EnchantInfoTopLine:ComputePos()
  self._ui._statictext_EnchantInfoBottom:ComputePos()
end
function PaGlobal_Enchant:setText_EnchantProtectInfo(isChecked)
  if isChecked then
    self._ui._statictext_EnchantInfoDesc:SetText(self._strForEnchantInfo._cronChecked)
    self._ui._checkbox_ForcedEnchant:SetCheck(false)
    self:showDifficulty(self._grantItemWhereType, self._grantItemSlotNo)
  else
    self._ui._statictext_EnchantInfoDesc:SetText(self._strForEnchantInfo._notChecked)
  end
  self._ui._statictext_EnchantInfoDesc:SetSize(self._ui._statictext_EnchantInfoDesc:GetSizeX(), self._ui._statictext_EnchantInfoDesc:GetTextSizeY())
  self._ui._statictext_EnchantInfoDesc:ComputePos()
  self._ui._statictext_EnchantInfoTopLine:ComputePos()
  self._ui._statictext_EnchantInfoBottom:ComputePos()
end
function PaGlobal_Enchant:addEnchantEffectToItemSlot(icon)
  icon:EraseAllEffect()
  icon:AddEffect("fUI_LimitOver01A", false, 0, 0)
end
function PaGlobal_Enchant:addEnchantSuccessEffectToItemSlot(icon)
  icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
end
function PaGlobal_Enchant:addWeaponEnchantEffect()
  self._ui._effect_Enchant:EraseAllEffect()
  self._ui._effect_Enchant:AddEffect("fUI_LimitOver02A", true, 0, 0)
  self._ui._effect_Enchant:AddEffect("UI_LimitOverLine_Red", false, 0, 0)
  self._ui._effect_Enchant:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
end
function PaGlobal_Enchant:addAmorEnchantEffect()
  self._ui._effect_Enchant:EraseAllEffect()
  self._ui._effect_Enchant:AddEffect("fUI_LimitOver02A", true, 0, 0)
  self._ui._effect_Enchant:AddEffect("UI_LimitOverLine", false, 0, 0)
  self._ui._effect_Enchant:AddEffect("fUI_LimitOver_Spark", false, 0, 0)
end
function PaGlobal_Enchant:removeEnchantEffect()
  self._ui._effect_Enchant:EraseAllEffect()
  self._ui._slot_EnchantMaterial.icon:EraseAllEffect()
  self._ui._slot_TargetItem.icon:EraseAllEffect()
end
function PaGlobal_Enchant:addFailCountEffectForTutorial()
  self._ui._statictext_EnchantFailCount:AddEffect("UI_QustComplete01", false, 0, 0)
end
function PaGlobal_Enchant:removeFailCountEffect()
  self._ui._statictext_EnchantFailCount:EraseAllEffect()
end
function PaGlobal_Enchant:addValksCountEffectForTutorial()
  self._ui._statictext_ValksCount:AddEffect("UI_QustComplete02", true, 0, 0)
  self._ui._statictext_ValksCount:AddEffect("UI_ArrowMark06", true, self._ui._statictext_ValksCount:GetSizeX() * -0.9, 0)
end
function PaGlobal_Enchant:removeValksCountEffect()
  self._ui._statictext_ValksCount:EraseAllEffect()
end
function PaGlobal_Enchant:addTargetSlotEffectForTutorial()
  self._ui._slot_TargetItem.icon:AddEffect("UI_ArrowMark02", true, 0, -50)
  self._ui._slot_TargetItem.icon:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end
function PaGlobal_Enchant:removeTargetSlotEffect()
  self._ui._slot_TargetItem.icon:EraseAllEffect()
end
function PaGlobal_Enchant:addMaterialSlotEffectForTutorial()
  self._ui._slot_EnchantMaterial.icon:AddEffect("UI_ArrowMark02", true, 0, -50)
  self._ui._slot_EnchantMaterial.icon:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end
function PaGlobal_Enchant:removeMaterialSlotEffect()
  self._ui._slot_EnchantMaterial.icon:EraseAllEffect()
end
function PaGlobal_Enchant:addApplyButtonEffectForTutorial()
  self._ui._button_Apply:AddEffect("UI_ArrowMark02", true, 0, -50)
  self._ui._button_Apply:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end
function PaGlobal_Enchant:removeApplyButtonEffect()
  self._ui._button_Apply:EraseAllEffect()
end
function PaGlobal_Enchant:showPanel()
  self._isWaitingServer = false
  if true == _ContentsGroup_RenewUI_Inventory then
    PaGlobalFunc_InventoryInfo_Open()
    Panel_Window_Enchant:SetShow(true, true)
    self:clearEnchantSlot()
    OnScreenEvent()
    return
  end
  InventoryWindow_Show()
  self:clearEnchantSlot()
  if false == _ContentsGroup_RenewUI then
    Equipment_PosSaveMemory()
    Panel_Equipment:SetShow(true, true)
    Panel_Equipment:SetPosX(self._const._gapX_PanelEquip)
    Panel_Equipment:SetPosY(Panel_Window_Inventory:GetPosY())
  end
  self._ui._statictext_EnchantInfoDesc:SetShow(true)
  Panel_Window_Enchant:SetShow(true, true)
  OnScreenEvent()
end
function PaGlobal_Enchant:setTextEnchantFailCntWithCnt(cnt)
  self._ui._statictext_EnchantFailCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS1"))
  self._ui._statictext_EnchantFailCountValue:SetText(cnt)
end
function PaGlobal_Enchant:setTextValksCntWithCnt(cnt)
  self._ui._statictext_ValksCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS2"))
  self._ui._statictext_ValksCountValue:SetText(cnt)
end
function PaGlobal_Enchant:setTextTotalEnchantCntWithCnt(cnt)
  self._ui._statictext_TotalEnchantCount:SetText("<PAColor0xffffbc1a>+ " .. cnt)
end
function PaGlobal_Enchant:setTextCronEnchantState(curLevel, curStack)
  self._ui._statictext_CurCronState:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CURRENTSTATE", "level", tostring(curLevel), "stack", tostring(curStack)))
  self._ui._statictext_EnchantResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CURRENTGRADE_CAPHRAS", "level", curLevel))
end
function PaGlobal_Enchant:setTextCronEnchantResultState()
  local curLevel = self._enchantInfo:ToClient_getCurLevel()
  local maxLevel = self._enchantInfo:ToClient_getMaxLevel()
  if maxLevel == curLevel then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FINALGRADE_CAPHRAS"))
  else
    self._ui._statictext_EnchantResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CURRENTGRADE_CAPHRAS", "level", curLevel))
  end
end
function PaGlobal_Enchant:setTextStackForNext(needStack)
  local curLevel = self._enchantInfo:ToClient_getCurLevel()
  local maxLevel = self._enchantInfo:ToClient_getMaxLevel()
  if maxLevel == curLevel then
    self._ui._statictext_StackForNext:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FINALENERGY"))
  elseif curLevel < maxLevel then
    local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local cronKey = itemSSW:getCronKey()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local cronEnchantSSW = ToClient_GetCronEnchantWrapper(cronKey, enchantLevel, curLevel)
      local addText = self:setTextBonusStats(cronEnchantSSW:getAddedDD(), cronEnchantSSW:getAddedHIT(), cronEnchantSSW:getAddedDV(), cronEnchantSSW:getAddedHDV(), cronEnchantSSW:getAddedPV(), cronEnchantSSW:getAddedHPV(), cronEnchantSSW:getAddedMaxHP(), cronEnchantSSW:getAddedMaxMP(), true)
      self._ui._statictext_StackForNext:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_NEXT_BONUS", "bonus", addText))
    end
  end
  self._ui._statictext_StackForNext:ComputePos()
end
function PaGlobal_Enchant:setNeedCountToMatrialSlot(slot, needCnt)
  slot.count:SetText("<PAColor0xFF0FBFFF>" .. tostring(needCnt) .. "<PAOldColor>")
  PaGlobal_Enchant:setEnable_button_Apply(not isAble)
end
function PaGlobal_Enchant:setCronStackProgress(curStack, maxStack, nextStack)
  local rate = 0
  if maxStack ~= 0 then
    rate = curStack / maxStack * 100
  end
  self._ui._progress:SetProgressRate(rate)
  self._ui._currentStat:SetText(string.format("%.3f", rate) .. " %")
  if nil ~= nextStack then
    self._ui._maxGrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_NEXT_STEP_CAPHRAS", "val", nextStack))
  else
    local maxLevel = self._enchantInfo:ToClient_getMaxLevel()
    self._ui._maxGrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MAX_CRONELV", "level", tostring(maxLevel)))
  end
  if nil == self._grantItemWhereType or nil == self._grantItemSlotNo then
    return
  end
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil ~= itemWrapper then
    local curCount = itemWrapper:getCronEnchantFailCount()
    for idx = 0, 3 do
      local itemSSW = itemWrapper:getStaticStatus()
      local itemClassifyType = itemSSW:getItemClassify()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local cronEnchantSSW = ToClient_GetCronEnchantWrapper(itemClassifyType, enchantLevel, idx)
      local enchantableCount = cronEnchantSSW:getCount()
      if curCount < enchantableCount then
        self._ui._statictext_AddStat[idx]:SetFontColor(Defines.Color.C_FFC4BEBE)
      else
        self._ui._statictext_AddStat[idx]:SetFontColor(Defines.Color.C_FF69BB4C)
      end
    end
  end
end
function PaGlobal_Enchant:setTextBonusStats(DD, HIT, DV, HDV, PV, HPV, HP, MP, isReturn)
  local str = ""
  if DD > 0 then
    str = PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_ATTACK") .. tostring(DD)
  end
  if HIT > 0 then
    if str ~= "" then
      str = str .. " / "
    end
    str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HIT") .. tostring(HIT)
  end
  if DV > 0 then
    if str ~= "" then
      str = str .. " / "
    end
    str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGE") .. tostring(DV)
  end
  if HDV > 0 then
    if 0 == DV then
      if str ~= "" then
        str = str .. " / "
      end
      str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_DODGE") .. "0" .. "(+" .. tostring(HDV) .. ")"
    else
      str = str .. "(+" .. tostring(HDV) .. ")"
    end
  end
  if PV > 0 then
    if str ~= "" then
      str = str .. " / "
    end
    str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCE") .. tostring(PV)
  end
  if HPV > 0 then
    if 0 == PV then
      if str ~= "" then
        str = str .. " / "
      end
      str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_REDUCE") .. "0" .. "(+" .. tostring(HPV) .. ")"
    else
      str = str .. "(+" .. tostring(HPV) .. ")"
    end
  end
  if HP > 0 then
    if str ~= "" then
      str = str .. " / "
    end
    str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_HP") .. tostring(HP)
  end
  if MP > 0 then
    if str ~= "" then
      str = str .. " / "
    end
    str = str .. PAGetString(Defines.StringSheet_GAME, "LUA_TOOLTIP_CRONENCHANT_MP") .. tostring(MP)
  end
  if "" == str then
    str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_NOEFFECT")
  end
  if isReturn then
    return str
  end
  self._ui._statictext_BounsStats:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_ADDEFFECT", "add", str))
  self._ui._statictext_BounsStats:ComputePos()
end
function PaGlobal_Enchant:initCronLevelAndCountText(maxLevel)
  local curCount
  local maxCountInv = 1 / self._enchantInfo:ToClient_getStackForLevel(maxLevel - 1) * self._ui._progress:GetSizeX()
  local maxIdx = math.max(maxLevel, self._numOfCronLevelText) - 1
  for idx = 0, maxIdx do
    if idx < maxLevel then
      local maxCount = self._enchantInfo:ToClient_getStackForLevel(maxIdx)
      curCount = self._enchantInfo:ToClient_getStackForLevel(idx)
      self._ui._stackTitle:SetPosY(self._const._posY_CronCount + 2)
      if nil ~= self._ui._addStatBg[idx] then
        local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
        if nil ~= itemWrapper then
          local itemSSW = itemWrapper:getStaticStatus()
          local itemClassifyType = itemSSW:getItemClassify()
          local enchantLevel = itemSSW:get()._key:getEnchantLevel()
          local cronEnchantSSW = ToClient_GetCronEnchantWrapper(itemClassifyType, enchantLevel, idx)
          local addText = self:setTextBonusStats(cronEnchantSSW:getAddedDD(), cronEnchantSSW:getAddedHIT(), cronEnchantSSW:getAddedDV(), cronEnchantSSW:getAddedHDV(), cronEnchantSSW:getAddedPV(), cronEnchantSSW:getAddedHPV(), cronEnchantSSW:getAddedMaxHP(), cronEnchantSSW:getAddedMaxMP(), true)
        end
      end
    else
      self._ui._stackTitle:SetShow(false)
    end
  end
  self._ui._topDesc:SetShow(false)
  self._ui._topDesc2:SetShow(true)
  self._ui._topDesc2:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._topDesc2:SetText(self._ui._topDesc2:GetText())
  self._ui._statictext_CurCronState:SetShow(false)
  self._ui._bg_ProgressCron:SetShow(false)
  self._ui._progress_Cron:SetShow(false)
  self._ui._progress_CronBg:SetShow(false)
  self._ui._stackTitle:SetShow(false)
  self._numOfCronLevelText = maxIdx + 1
  self._ui._currentGrade:SetShow(true)
  self._ui._maxGrade:SetShow(true)
  self._ui._currentStat:SetShow(true)
  self._ui._progress:SetShow(true)
  local maxLevel = self._enchantInfo:ToClient_getMaxLevel()
  local curLevel = self._enchantInfo:ToClient_getCurLevel()
  self._ui._currentGrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CURRENT_CRONELV", "level", tostring(curLevel)))
end
function PaGlobal_Enchant:hideAllCronCountText()
  for idx = 0, self._numOfCronLevelText - 1 do
  end
  self._ui._topDesc:SetShow(true)
  self._ui._topDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._topDesc:SetText(self._ui._topDesc:GetText())
  self._ui._topDesc2:SetShow(false)
  self._ui._statictext_CurCronState:SetShow(false)
  self._ui._progress_CronBg:SetShow(false)
  self._ui._progress_Cron:SetShow(false)
  self._ui._bg_ProgressCron:SetShow(false)
  self._ui._stackTitle:SetShow(false)
end
function PaGlobal_Enchant:setEnchantFailCount()
  if nil == self._enchantInfo then
    self._enchantInfo = getEnchantInformation()
    self._enchantInfo:ToClient_clearData()
  end
  local failCount = self._enchantInfo:ToClient_getFailCount()
  local valksCount = self._enchantInfo:ToClient_getValksCount()
  local bonusStackCount = self._enchantInfo:ToClient_getBonusStackCount()
  local failCountUpRate = Int64toInt32(self._enchantInfo:ToClient_getFailCountUpRate())
  local enchantType = self._enchantInfo:ToClient_getEnchantType()
  if enchantType == self._enum_EnchantType._safe and nil ~= self._ui._slot_TargetItem.slotNo and true ~= self._isCommonLastEnchant then
    self._ui._statictext_EnchantFailCount:SetShow(false)
    self._ui._statictext_ValksCount:SetShow(false)
    self._ui._statictext_EnchantFailCountValue:SetShow(false)
    self._ui._statictext_ValksCountValue:SetShow(false)
    self._ui._statictext_TotalEnchantCount:SetShow(false)
    self._ui._statictext_Line:SetShow(false)
    self._ui._statictext_SafeEnchant:SetShow(true)
  else
    self._ui._statictext_EnchantFailCount:SetShow(true)
    self._ui._statictext_ValksCount:SetShow(true)
    self._ui._statictext_EnchantFailCountValue:SetShow(true)
    self._ui._statictext_ValksCountValue:SetShow(true)
    self._ui._statictext_TotalEnchantCount:SetShow(true)
    self._ui._statictext_Line:SetShow(true)
    self._ui._statictext_SafeEnchant:SetShow(false)
    self._isCommonLastEnchant = false
  end
  self._ui._statictext_EnchantFailCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS1"))
  self._ui._statictext_EnchantFailCountValue:SetText("+" .. failCount)
  self._screctExtractIvenType = self._enchantInfo:ToClient_getVaildSecretExtractionIvenType()
  self._ui._statictext_ValksCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS2"))
  self._ui._statictext_ValksCountValue:SetText("+" .. valksCount)
  self._ui._statictext_TotalEnchantCount:SetText("<PAColor0xffffbc1a>+" .. failCount + valksCount + bonusStackCount)
  self:showDifficulty(self._grantItemWhereType, self._grantItemSlotNo)
  self._ui._txt_EatEnchantFailCount:SetShow(true)
  self._ui._txt_EatEnchantFailCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS1"))
  self._ui._txt_EatEnchantFailCountValue:SetText("+" .. failCount)
  self._ui._txt_EatValksCount:SetShow(true)
  self._screctExtractIvenType = self._enchantInfo:ToClient_getVaildSecretExtractionIvenType()
  if true == self:isEatTab() then
    self:showScretExtractButton(false)
    if true == _ContentsGroup_EatStackEnchant then
    end
    self._ui._txt_EatValksCount:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RENEW_BONUS2"))
    self._ui._txt_EatValksCountValue:SetText("+" .. valksCount)
    self._ui._txt_EatTotalEnchantCount:SetText("<PAColor0xffffbc1a>+" .. failCount + valksCount + bonusStackCount)
  else
    self:showScretExtractButton(self._screctExtractIvenType ~= CppEnums.ItemWhereType.eCount)
  end
  self:showEnchantProbability(failCount + valksCount + bonusStackCount)
end
function PaGlobal_Enchant:showDifficulty(inventoryType, slotNo)
  for index = 0, 10 do
    self._ui._difficultyValue[index]:SetShow(false)
  end
  local failCount = self._enchantInfo:ToClient_getFailCount()
  local valksCount = self._enchantInfo:ToClient_getValksCount()
  local itemWrapper
  if nil ~= inventoryType and nil ~= slotNo then
    itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  end
  if nil == itemWrapper then
    self._ui._difficultyBg:SetShow(false)
    self._ui._statictext_EnchantResult:SetShow(false)
    return
  end
  local rate = ToClient_getEnchantSuccessRate(self._ui._checkbox_ForcedEnchant:IsCheck(), self:isDifficultEnchant())
  if -1 ~= rate and (true == self:isCronEnchantTab() or true == self:isEnchantTab()) then
    local enchantPercentString = "<PAColor0xFF0FBFFF>" .. string.format("%.2f", rate / CppDefine.e100Percent * 100) .. "%<PAOldColor>"
    self._ui._statictext_EnchantResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SUCCESSPERCENT_REAL", "percent", enchantPercentString))
    local isAutoWrap = self._ui._statictext_EnchantResult:IsAutoWrapText()
    if true == isAutoWrap then
      self._ui._statictext_EnchantResult:SetSpanSize(self._ui._statictext_EnchantResult:GetSpanSize().x, 200)
      self._ui._difficultyBg:SetSpanSize(self._ui._difficultyBg:GetSpanSize().x, 160)
    else
      self._ui._statictext_EnchantResult:SetSpanSize(self._ui._statictext_EnchantResult:GetSpanSize().x, 190)
      self._ui._difficultyBg:SetSpanSize(self._ui._difficultyBg:GetSpanSize().x, 170)
    end
    self._ui._statictext_EnchantResult:SetShow(true)
    local value = math.floor(rate / 100000)
    self._ui._difficultyValue[value]:SetShow(true)
    self._ui._difficultyBg:SetShow(true)
  else
    self._ui._difficultyBg:SetShow(false)
  end
end
function PaGlobal_Enchant:showSlotToolTip(toolTip, text)
  toolTip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  toolTip:SetAutoResize(true)
  toolTip:SetText(text)
  toolTip:SetSize(toolTip:GetSizeX() + self._const._gapX_ToolTip, toolTip:GetTextSizeY() + self._const._gapY_ToolTip)
  toolTip:SetShow(true)
end
function PaGlobal_Enchant:showNoticeEnchantApply(enchantType)
  if enchantType == self._enum_EnchantType._safe then
    local isWeapon = true
    local isCollectTool = true
    local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    local enchantLevel
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      enchantLevel = itemSSW:get()._key:getEnchantLevel()
      isWeapon = itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon()
      isCollectTool = itemSSW:get():isCollectTool()
    end
    if (true == isWeapon or true == isCollectTool) and enchantLevel >= 8 or enchantLevel >= 6 then
      return
    end
    if isWeapon or isCollectTool then
      self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_WEAPONE"))
    else
      self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_ARMOR"))
    end
  elseif enchantType == self._enum_EnchantType._unsafe then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_FAIL"))
  elseif enchantType == self._enum_EnchantType._broken then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED"))
  elseif enchantType == self._enum_EnchantType._gradedown then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_COUNTDOWN"))
  elseif enchantType == self._enum_EnchantType._downAndBroken then
    self._ui._statictext_noticeApplyButton:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SAFEENCHANT_DESTORYED_AND_COUNTDOWN"))
  end
  self._ui._statictext_noticeApplyButton:SetShow(true)
  self._isShowNoticeApplyButton = true
  self._ui._statictext_noticeApplyButton:SetPosY((self._ui._statictext_noticeApplyButton:GetSizeY() + 5) * -1)
end
function PaGlobal_Enchant:showEnchantResultText(resultType, mainSlotNo, mainWhereType)
  self._ui._difficultyBg:SetShow(false)
  if resultType == self._enum_EnchantResult._success then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_0"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("UI_QustComplete01", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._fail then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_1"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._broken then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_2"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._gradedown then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_3"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  elseif resultType == self._enum_EnchantResult._failAndPrevent then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_4"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("fUI_Enchant_Fail", false, 0, 0)
  end
  self._ui._statictext_EnchantResult:SetShow(true)
  self._resultFlag = true
  self._resultTimeCheck = true
  self:showEffectByResult(resultType, mainSlotNo, mainWhereType)
end
function PaGlobal_Enchant:showEffectByResult(resultType, mainSlotNo, mainWhereType)
  if resultType == self._enum_EnchantResult._success then
    local itemWrapper = getInventoryItemByType(mainWhereType, mainSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        self._ui._slot_TargetItem.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
      else
        self._ui._slot_TargetItem.icon:AddEffect("UI_ItemEnchant01", false, -6, -6)
      end
    end
  else
    self._ui._slot_TargetItem.icon:AddEffect("", false, -6, -6)
  end
end
function PaGlobal_Enchant:showCronEnchantResult(variedCount)
  self._ui._statictext_EnchantResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_5_CAPHRAS", "count", tostring(variedCount)))
  self._ui._statictext_EnchantResult:SetShow(true)
  self._ui._statictext_EnchantResult:EraseAllEffect()
  self._ui._statictext_EnchantResult:AddEffect("UI_QustComplete01", false, 0, 0)
  self._resultTimeCheck = true
end
function PaGlobal_Enchant:showPromotionResult()
  self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_PROMOTION_CAPHRAS"))
  self._ui._statictext_EnchantResult:SetShow(true)
  self._ui._statictext_EnchantResult:EraseAllEffect()
  self._ui._statictext_EnchantResult:AddEffect("UI_QustComplete01", false, 0, 0)
  self._resultTimeCheck = true
end
function PaGlobal_Enchant:showEnchantProbability(count)
  if self._resultFlag then
    self._resultFlag = false
    return
  end
  self._ui._statictext_EnchantResult:ResetVertexAni()
  self._ui._statictext_EnchantResult:SetScale(1, 1)
  self._ui._statictext_EnchantResult:SetSize(250, 20)
  self._ui._statictext_EnchantResult:ComputePos()
  self._resultTimeCheck = false
end
function PaGlobal_Enchant:handleMOnAddStat(index)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    local itemClassifyType = itemSSW:getItemClassify()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    local cronEnchantSSW = ToClient_GetCronEnchantWrapper(itemClassifyType, enchantLevel, index)
    local addText = self:setTextBonusStats(cronEnchantSSW:getAddedDD(), cronEnchantSSW:getAddedHIT(), cronEnchantSSW:getAddedDV(), cronEnchantSSW:getAddedHDV(), cronEnchantSSW:getAddedPV(), cronEnchantSSW:getAddedHPV(), cronEnchantSSW:getAddedMaxHP(), cronEnchantSSW:getAddedMaxMP(), true)
    TooltipSimple_Show(self._ui._addStatBg[index], addText)
  end
end
function FromClient_luaLoadComplete_Enchant()
  PaGlobal_Enchant:initialize()
end
function PaGlobal_Enchant:willShow()
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  if Panel_Window_Socket:GetShow() then
    Panel_Window_Socket:SetShow(false, false)
  end
  SkillAwaken_Close()
  Panel_Join_Close()
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    FGlobal_LifeRanking_Close()
  else
    PaGlobal_LifeRanking_Close_All()
  end
  Panel_EnchantExtraction_Close()
  Equipment_PosSaveMemory()
end
function PaGlobal_Enchant:enchant_Show()
  self:willShow()
  self:showPanel()
  self:showEnchantTab()
end
function PaGlobal_Enchant:showTab()
  if true == self:isEnchantTab() then
    self:showEnchantTab()
  elseif true == self:isCronEnchantTab() then
    self:showCronEnchantTab()
  elseif true == self:isEatTab() then
    self:showEatTab()
  end
end
function PaGlobal_Enchant:enchantClose()
  if nil == Panel_WebControl then
    UI.ASSERT_NAME(false, "Panel_WebControl\236\157\180 \236\151\134\236\138\181\235\139\136\235\139\164.", "\234\185\128\236\157\152\236\167\132")
    return
  elseif true == Panel_WebControl:GetShow() then
    Panel_WebHelper_ShowToggle()
    return
  end
  if self._isAnimating == true then
    self:handleLUpEnchantApplyButton()
    return
  end
  self:clearEnchantSlot()
  Equipment_PosLoadMemory()
  InventoryWindow_Close()
  if false == _ContentsGroup_RenewUI then
    Panel_Equipment:SetShow(false, false)
  end
  ClothInventory_Close()
  ToClient_BlackspiritEnchantClose()
  PaGlobal_TutorialManager:handleCloseEnchantWindow()
  Panel_EnchantExtraction_Close()
  Inventory_SetFunctor(nil, nil, nil, nil)
  Panel_Window_Enchant:SetShow(false, false)
end
function PaGlobal_Enchant:forceClose()
  self._isAnimating = false
  self:removeEnchantEffect()
  self:setAsEnchantButton()
  self:enchantClose()
end
function PaGlobal_Enchant:showEnchantTab()
  self:init_EnchantFrame()
  self:didShowEnchantTab(true)
end
function PaGlobal_Enchant:didShowEnchantTab(setButtonApply)
  if nil == self._enchantInfo then
    return
  end
  self._screctExtractIvenType = self._enchantInfo:ToClient_getVaildSecretExtractionIvenType()
  self:setEnchantFailCount()
  if true == setButtonApply then
    self:setEnable_button_Apply(false)
  end
  self:showScretExtractButton(self._screctExtractIvenType ~= CppEnums.ItemWhereType.eCount)
  Inventory_SetFunctor(FGlobal_Enchant_FileterForEnchantTarget, FGlobal_Enchant_RClickForTargetItem, closeForEnchant, nil)
end
function PaGlobal_Enchant:setEnchantTarget(slotNo, itemWrapper, inventoryType, resultType, isMonotone)
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  if 0 ~= self._enchantInfo:ToClient_setEnchantSlot(inventoryType, slotNo) then
    _PA_LOG("\236\160\149\237\155\136", "PaGlobal_Enchant:setEnchantTarget Error!")
    return false
  end
  self:setItemToSlot(self._ui._slot_TargetItem, slotNo, itemWrapper, inventoryType)
  local equipType = itemWrapper:getStaticStatus():getItemClassify()
  local currentItemSSW = itemWrapper:getStaticStatus()
  local currentEnchantLevel = currentItemSSW:get()._key:getEnchantLevel()
  local blablaShow = false
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == equipType then
    if currentEnchantLevel >= 3 then
      blablaShow = true
    end
  elseif currentEnchantLevel >= 18 then
    blablaShow = true
  end
  self:BlablaShow(blablaShow)
  local isMaterialInit = false
  if nil ~= resultType and 0 == resultType then
    local resultItemWrapper = getInventoryItemByType(inventoryType, slotNo)
    if nil ~= resultItemWrapper then
      local itemSSW = resultItemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if 15 == enchantLevel then
        self._grantItemSlotNo = slotNo
        self._grantItemWhereType = inventoryType
        self._materialItemSlotNo = nil
        self._materialItemWhereType = nil
        self._isSetNewPerfectItemMaterial = false
        self:didsetEnchantTarget(true)
        return true
      end
    end
  end
  local materialItemWrapper
  if nil ~= self._materialItemWhereType and nil ~= self._materialItemSlotNo then
    materialItemWrapper = getInventoryItemByType(self._materialItemWhereType, self._materialItemSlotNo)
  end
  local isStackMaterial = false
  if nil ~= materialItemWrapper then
    isStackMaterial = materialItemWrapper:getStaticStatus():isStackable()
  end
  local equipType = itemWrapper:getStaticStatus():getItemClassify()
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == equipType and false == isStackMaterial then
    isMonotone = true
  end
  if true == isMonotone then
    self._materialItemSlotNo = nil
    self._materialItemWhereType = nil
    self._isSetNewPerfectItemMaterial = false
  end
  self._ui._statictext_EnchantInfoDesc:SetShow(true)
  self._grantItemSlotNo = slotNo
  self._grantItemWhereType = inventoryType
  self:didsetEnchantTarget(isMonotone)
  return true
end
function PaGlobal_Enchant:BlablaShow(blablaShow)
  self._ui._blablaText:SetShow(false)
  self._ui._blablaText:SetSize(self._ui._blablaText:GetSizeX(), self._ui._blablaText:GetTextSizeY() + 40)
  self._ui._blablaText:ComputePos()
  self._ui._blablaBg:SetShow(blablaShow)
  self._ui._blablaBg:addInputEvent("Mouse_LUp", "PaGlobal_Enchant_RandomBlabla()")
  self._ui._blablaText:addInputEvent("Mouse_LUp", "PaGlobal_Enchant_RandomBlabla()")
end
function PaGlobal_Enchant_RandomBlabla()
  local self = PaGlobal_Enchant
  local index = math.random(#self._blablaDesc)
  self._ui._blablaText:SetText(self._blablaDesc[index])
  self._ui._blablaText:SetSize(self._ui._blablaText:GetSizeX(), self._ui._blablaText:GetTextSizeY() + 40)
  self._ui._blablaText:ComputePos()
  self._ui._blablaText:SetShow(true)
  self._ui._statictext_noticeApplyButton:SetShow(false)
end
function PaGlobal_Enchant:didsetEnchantTarget(isMonotone, isRadioClick)
  local enchantType = self._enchantInfo:ToClient_getEnchantType()
  local needCountForPerfectEnchant_s64 = self._enchantInfo:ToClient_getNeedCountForPerfectEnchant_s64()
  self._strForEnchantInfo._notChecked = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil == itemWrapper then
    return
  end
  local enchantItemClassify = itemWrapper:getStaticStatus():getItemClassify()
  local enchantLevel = itemWrapper:get():getKey():getEnchantLevel()
  local isStackLessBlackStone = itemWrapper:getStaticStatus():isNeedStackLessBlackStonForEnchant()
  if (enchantLevel > 16 or 4 == enchantItemClassify) and false == isStackLessBlackStone and toInt64(0, 0) < self._enchantInfo:ToClient_getNeedCountForProtect_s64() then
    self:setEnable_CheckboxUseCron(true)
    self:setText_NumOfCron(self._enchantInfo:ToClient_getCountProtecMaterial_s64(), self._enchantInfo:ToClient_getNeedCountForProtect_s64())
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
    self._strForEnchantInfo._cronChecked = enduranceDesc .. self:getStr_EnchantProtectInfo(enchantType)
  else
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
  end
  if needCountForPerfectEnchant_s64 > toInt64(0, 0) then
    self:setEnable_CheckboxForcedEnchant(true)
    local enduranceDesc = self:getStr_EnchantInfo(self._enchantInfo:ToClient_getCurMaxEndura(), self._enchantInfo:ToClient_getDecMaxEndura(), enchantType, true)
    self._strForEnchantInfo._forcedChecked = enduranceDesc .. self:getStr_PerfectEnchantInfo(needCountForPerfectEnchant_s64, self._enchantInfo:ToClient_getDecMaxEnduraPerfect())
  else
    self:setEnable_CheckboxForcedEnchant(false)
  end
  if self._enchantInfo:ToClient_checkIsValidDifficultEnchant() == 0 then
    self:showDifficultEnchantButton(true)
  else
    self:showDifficultEnchantButton(false)
  end
  if true == self._isSetNewPerfectItemMaterial then
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
    self:setEnable_CheckboxForcedEnchant(false)
    self:showDifficultEnchantButton(false)
  end
  self:setText_EnchantInfo(self._ui._checkbox_ForcedEnchant:IsCheck() and self._ui._checkbox_ForcedEnchant:GetShow())
  if false == itemWrapper:getStaticStatus():get():isCash() then
    self:showNoticeEnchantApply(enchantType)
  end
  if nil == isRadioClick then
    self:setEnchantMaterial(isMonotone)
  end
  self._screctExtractIvenType = self._enchantInfo:ToClient_getVaildSecretExtractionIvenType()
  self:showScretExtractButton(self._screctExtractIvenType ~= CppEnums.ItemWhereType.eCount)
  self:showDifficulty(self._grantItemWhereType, self._grantItemSlotNo)
end
function PaGlobal_Enchant:setEnchantMaterial(isMonotone)
  if true == self:isEatTab() then
    return
  end
  if true == isMonotone or 0 ~= self._enchantInfo:ToClient_setEnchantSlot(self._materialItemWhereType, self._materialItemSlotNo) then
    self:setItemToSlotMonoTone(self._ui._slot_EnchantMaterial, self._enchantInfo:ToClient_getNeedItemStaticInformation())
    self:setEnable_button_Apply(false)
    self._enchantInfo:materialClearData()
    local newPerfectNeedItem = self._enchantInfo:ToClient_getNeedNewPerfectItemStaticInformation()
    if true == newPerfectNeedItem:isSet() then
      self._isSlotChangeAnimation = true
    else
      self._isSlotChangeAnimation = false
    end
    return
  elseif true == self._isSetNewPerfectItemMaterial then
    if 0 < self._enchantInfo:ToClient_getDecMaxEnduraNewPerfect() then
      local str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT_PENALTY", "maxEndurance", tostring(self._enchantInfo:ToClient_getDecMaxEnduraNewPerfect()), "currentEndurance", tostring(self._enchantInfo:ToClient_getCurMaxEndura()))
      self._ui._statictext_EnchantInfoDesc:SetText(str)
    else
      self._ui._statictext_EnchantInfoDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT"))
    end
  else
    self:setText_EnchantInfo(self._ui._checkbox_ForcedEnchant:IsCheck() and self._ui._checkbox_ForcedEnchant:GetShow())
  end
  self._isSlotChangeAnimation = false
  local itemWrapper = getInventoryItemByType(self._materialItemWhereType, self._materialItemSlotNo)
  self:setItemToSlot(self._ui._slot_EnchantMaterial, self._materialItemSlotNo, itemWrapper, self._materialItemWhereType)
  self:didsetEnchantMaterial()
end
function PaGlobal_Enchant:didsetEnchantMaterial()
  self:setEnable_button_Apply(true)
  if true == self._isSetNewPerfectItemMaterial then
    local needPerfectItemSSW = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    local needPerfectItemSS
    local needPerfectCount = 0
    if nil ~= needPerfectItemSSW then
      needPerfectItemSS = needPerfectItemSSW:getStaticStatus()
      needPerfectCount = needPerfectItemSS:getNeedNewPerfectEnchantItemCount()
    end
    local currentNeedPerfectItemSSW = getInventoryItemByType(self._enchantInfo:ToClient_getNeedNewPerfectItemWhereType(), self._enchantInfo:ToClient_getNeedNewPerfectItemSlotNo())
    local currentPerfectCount = 0
    if nil ~= currentNeedPerfectItemSSW then
      currentPerfectCount = currentNeedPerfectItemSSW:getCount()
    end
    self:setText_PerfectCount(true, currentPerfectCount, needPerfectCount)
  end
end
function PaGlobal_Enchant:willStartEnchant()
  if self._ui._checkbox_UseCron:IsCheck() then
    if self._enchantInfo:ToClient_setPreventDownGradeItem() ~= 0 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_NOT_ENOUGH_CRONESTONE"))
      return
    end
  else
    self._enchantInfo:ToClient_clearPreventDownGradeItem()
  end
  if not self._ui._checkbox_skipEffect:IsCheck() then
    self:startEnchantAnimation()
  else
    self:startEnchant()
  end
end
function PaGlobal_Enchant:startEnchantAnimation()
  self:addEnchantEffectToItemSlot(self._ui._slot_TargetItem.icon)
  self:addEnchantEffectToItemSlot(self._ui._slot_EnchantMaterial.icon)
  if self._enchantInfo:ToClient_getEquipType() == 0 then
    self:addWeaponEnchantEffect()
  else
    self:addAmorEnchantEffect()
  end
  self:setAsCancelButton()
  ToClient_BlackspiritEnchantStart()
  self._animationTimeStamp = 0
  self._isAnimating = true
  audioPostEvent_SystemUi(5, 6)
  audioPostEvent_SystemUi(5, 9)
  ToClient_StartLedDeviceAnimation(7)
end
function PaGlobal_Enchant:startEnchant()
  self:setAsEnchantButton()
  if Panel_Window_Enchant:IsShow() == true then
    self._enchantInfo:ToClient_doEnchant(self._ui._checkbox_ForcedEnchant:IsCheck(), self:isDifficultEnchant())
    self._isWaitingServer = true
  end
  if self._isAnimating == true then
    audioPostEvent_SystemUi(5, 6)
    audioPostEvent_SystemUi(5, 9)
  end
end
function PaGlobal_Enchant:didEnchant(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  if resultType == self._enum_EnchantResult._error then
    ToClient_BlackspiritEnchantCancel()
    self:didsetEnchantMaterial()
    return
  end
  self:showEnchantResultEffect(resultType)
  self:clearEnchantSlot()
  if false == self:setEnchantTarget(mainSlotNo, getInventoryItemByType(mainWhereType, mainSlotNo), mainWhereType, resultType, false) then
    local itemWrapper = getInventoryItemByType(mainWhereType, mainSlotNo)
    self._isLastEnchant = false
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
        if 5 == enchantLevel then
          self._ui._statictext_EnchantInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FINALENCHANT"))
          self._isLastEnchant = true
        end
      elseif 20 == enchantLevel then
        self._ui._statictext_EnchantInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FINALENCHANT"))
        self._isLastEnchant = true
      end
    end
    if true == self._isLastEnchant then
      self:setItemToSlot(self._ui._slot_TargetItem, mainSlotNo, itemWrapper, mainWhereType)
    else
      self:clearEnchantSlot()
      self:showTab()
    end
    self._ui._statictext_EnchantInfoDesc:SetShow(false)
    self:setEnable_CheckboxUseCron(false)
    self:setText_NumOfCron(0, 0)
    self._isCommonLastEnchant = true
  end
  self:showEnchantResultText(resultType, mainSlotNo, mainWhereType)
end
function PaGlobal_Enchant:showEnchantResultEffect(resultType)
  if resultType == self._enum_EnchantResult._success then
    audioPostEvent_SystemUi(5, 1)
    render_setChromaticBlur(40, 1)
    render_setPointBlur(0.05, 0.045)
    render_setColorBypass(0.85, 0.08)
    self:addEnchantSuccessEffectToItemSlot(self._ui._slot_TargetItem.icon)
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_SPIRITENCHANT_SUCCESSENCHANT"))
    ToClient_BlackspiritEnchantSuccess()
  else
    audioPostEvent_SystemUi(0, 7)
    if resultType == self._enum_EnchantResult._broken then
      audioPostEvent_SystemUi(5, 8)
    elseif resultType == self._enum_EnchantResult._gradeDown then
      audioPostEvent_SystemUi(5, 2)
    elseif resultType == self._enum_EnchantResult._fail then
      audioPostEvent_SystemUi(5, 2)
    elseif resultType == self._enum_EnchantResult._failAndPrevent then
      audioPostEvent_SystemUi(5, 2)
    end
    ToClient_BlackspiritEnchantCancel()
  end
  self:didsetEnchantTarget(false)
end
function PaGlobal_Enchant:cancelEnchant()
  self._isAnimating = false
  self:removeEnchantEffect()
  self:setAsEnchantButton()
  ToClient_BlackspiritEnchantCancel()
end
function PaGlobal_Enchant:showCronEnchantTab()
  self:init_CronFrame()
  self:didShowCronEnchantTab()
end
function PaGlobal_Enchant:didShowCronEnchantTab()
  self:setEnable_button_Apply(false)
  Inventory_SetFunctor(FGlobal_Enchant_FilterForCronEnchantTarget, FGlobal_Enchant_RClickForCronEnchantItem, closeForEnchant, nil)
  self:setEnchantFailCount()
end
function PaGlobal_Enchant:setCronEnchanTarget(slotNo, itemWrapper, inventoryType, isMonotone, isPromotion)
  if nil == inventoryType or nil == slotNo then
    return
  end
  if 0 ~= self._enchantInfo:ToClient_setCronEnchantSlot(inventoryType, slotNo) then
    _PA_LOG("\236\160\149\237\155\136", "PaGlobal_Enchant:setCronEnchantTarget Error!")
    return
  end
  self:setItemToSlot(self._ui._slot_TargetItem, slotNo, itemWrapper, inventoryType)
  self._grantItemSlotNo = slotNo
  self._grantItemWhereType = inventoryType
  self:didSetCronEnchantTarget(itemWrapper, isMonotone, isPromotion)
end
function PaGlobal_Enchant:didSetCronEnchantTarget(itemWrapper, isMonotone, isPromotion)
  local curStack = self._enchantInfo:ToClient_getCurStack()
  local maxLevel = self._enchantInfo:ToClient_getMaxLevel()
  local curLevel = self._enchantInfo:ToClient_getCurLevel()
  self._ui._topDesc2:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_ENERGYDESC_CAPHRAS"))
  self:setTextCronEnchantState(curLevel, curStack)
  self:setTextStackForNext(self._enchantInfo:ToClient_getNeedStack())
  self:setTextBonusStats(self._enchantInfo:ToClient_getAddedDD(), self._enchantInfo:ToClient_getAddedHIT(), self._enchantInfo:ToClient_getAddedDV(), self._enchantInfo:ToClient_getAddedHDV(), self._enchantInfo:ToClient_getAddedPV(), self._enchantInfo:ToClient_getAddedHPV(), self._enchantInfo:ToClient_getAddedHP(), self._enchantInfo:ToClient_getAddedMP())
  local nextOptionsSizeY = self._ui._statictext_StackForNext:GetTextSizeY()
  local currentOptionsSizeY = self._ui._statictext_BounsStats:GetTextSizeY()
  local previousLevelStack = self._enchantInfo:ToClient_getStackForLevel(curLevel - 1)
  if 0 == curLevel then
    previousLevelStack = 0
  end
  if maxLevel == curLevel then
    self:setCronStackProgress(1, 1)
  else
    local nextLevelStack = self._enchantInfo:ToClient_getStackForLevel(curLevel)
    self:setCronStackProgress(curStack - previousLevelStack, self._enchantInfo:ToClient_getStackForLevel(curLevel) - previousLevelStack, nextLevelStack - curStack)
  end
  self:initCronLevelAndCountText(maxLevel)
  self:setCronEnchantMaterial(isMonotone, 0)
  if isPromotion then
    self._isPossiblePromotion = false
    PaGlobal_Enchant:setAsCronEnchantButton()
    self:setEnable_button_Apply(true)
    Inventory_SetFunctor(FGlobal_Enchant_InvenFilerCronItem, FGlobal_Enchant_RClickCronItem, closeForEnchant, nil)
  elseif maxLevel == curLevel then
    if itemWrapper:isPossibleCronPromotion() then
      self._isPossiblePromotion = true
      PaGlobal_Enchant:setAsPromotionEnchantButton()
      self:setEnable_button_Apply(true)
    else
      self:setEnable_button_Apply(false)
    end
  end
end
function PaGlobal_Enchant:setCronEnchantMaterial(isMonotone, count)
  local slotNo = self._enchantInfo:ToClient_getCaphRasSlotNo()
  local inventoryType = self._enchantInfo:ToClient_getCaphRasItemWhereType()
  self._enchantInfo:materialClearData()
  if true == isMonotone or 0 ~= self._enchantInfo:ToClient_setCronEnchantSlot(inventoryType, slotNo, count) then
    self:setItemToSlotMonoTone(self._ui._slot_EnchantMaterial, ToClient_getPromotionEnchantItem())
    self._enchantInfo:materialClearData()
    return
  end
  local itemWrapper = getInventoryItemByType(inventoryType, slotNo)
  self:setItemToSlot(self._ui._slot_EnchantMaterial, slotNo, itemWrapper, inventoryType)
  self:setNeedCountToMatrialSlot(self._ui._slot_EnchantMaterial, count)
  self:didSetCronEnchantMaterial()
end
function PaGlobal_Enchant:didSetCronEnchantMaterial()
  self:setEnable_button_Apply(true)
end
function PaGlobal_Enchant:willStartCronEnchant()
  if not self._ui._checkbox_skipEffect:IsCheck() then
    self:startCronEnchantAnimation()
  else
    self:startCronEnchant()
  end
end
function PaGlobal_Enchant:willStartPromotionEnchant()
  if not self._ui._checkbox_skipEffect:IsCheck() then
    self:startCronEnchantAnimation()
  else
    self:startPromotionEnchant()
  end
end
function PaGlobal_Enchant:startCronEnchantAnimation()
  self:addEnchantEffectToItemSlot(self._ui._slot_TargetItem.icon)
  self:addEnchantEffectToItemSlot(self._ui._slot_EnchantMaterial.icon)
  self:addAmorEnchantEffect()
  self:setAsCancelButton()
  ToClient_BlackspiritEnchantStart()
  self._animationTimeStamp = 0
  self._isAnimating = true
  audioPostEvent_SystemUi(5, 6)
  audioPostEvent_SystemUi(5, 9)
end
function PaGlobal_Enchant:startCronEnchant()
  self:setAsCronEnchantButton()
  if Panel_Window_Enchant:IsShow() == true then
    self._enchantInfo:ToClient_doCronEnchant()
  end
end
function PaGlobal_Enchant:startPromotionEnchant()
  self:setAsPromotionEnchantButton()
  if Panel_Window_Enchant:IsShow() == true then
    self._enchantInfo:ToClient_doCronPromotion()
  end
end
function PaGlobal_Enchant:didCronEnchant(mainWhereType, mainSlotNo, variedCount)
  self:clearEnchantSlot()
  self:setCronEnchanTarget(mainSlotNo, getInventoryItemByType(mainWhereType, mainSlotNo), mainWhereType, true, false)
  self:showCronEnchantEndEffect(variedCount)
end
function PaGlobal_Enchant:didCronPromotion(mainWhereType, mainSlotNo)
  Inventory_updateSlotData()
  self:clearEnchantSlot()
  self:setCronEnchanTarget(mainSlotNo, getInventoryItemByType(mainWhereType, mainSlotNo), mainWhereType, true, true)
  self:showCronPromotionEndEffect()
end
function PaGlobal_Enchant:showCronEnchantEndEffect(variedCount)
  audioPostEvent_SystemUi(5, 1)
  render_setChromaticBlur(40, 1)
  render_setPointBlur(0.05, 0.045)
  render_setColorBypass(0.85, 0.08)
  self:addEnchantSuccessEffectToItemSlot(self._ui._slot_TargetItem.icon)
  self:showCronEnchantResult(variedCount)
  ToClient_BlackspiritEnchantSuccess()
end
function PaGlobal_Enchant:showCronPromotionEndEffect(variedCount)
  audioPostEvent_SystemUi(5, 1)
  render_setChromaticBlur(40, 1)
  render_setPointBlur(0.05, 0.045)
  render_setColorBypass(0.85, 0.08)
  self:addEnchantSuccessEffectToItemSlot(self._ui._slot_TargetItem.icon)
  self:showPromotionResult()
  ToClient_BlackspiritEnchantSuccess()
end
function PaGlobal_Enchant:cancelCronEnchant()
  self._isAnimating = false
  self:removeEnchantEffect()
  self:setAsCronEnchantButton()
  ToClient_BlackspiritEnchantCancel()
end
function PaGlobal_Enchant:cancelPromotionEnchant()
  self._isAnimating = false
  self:removeEnchantEffect()
  self:setAsPromotionEnchantButton()
  ToClient_BlackspiritEnchantCancel()
end
function PaGlobal_Enchant:cancelEat()
  self._isAnimating = false
  self:removeEnchantEffect()
  self:setAsEatButton()
  ToClient_BlackspiritEnchantCancel()
end
function PaGlobal_Enchant:clearEnchantSlot()
  self:clearItemSlot(self._ui._slot_TargetItem)
  self:clearItemSlot(self._ui._slot_EnchantMaterial)
  self._ui._statictext_EnchantInfoDesc:SetShow(true)
  self._ui._statictext_EnchantInfo:SetText("")
  self._grantItemWhereType = nil
  self._grantItemSlotNo = nil
  self._enchantInfo:ToClient_clearData()
  self._ui._difficultyBg:SetShow(false)
  self._ui._statictext_EnchantResult:SetShow(false)
end
function PaGlobal_Enchant:showEatTab()
  self:init_EatFrame()
  self:setEnable_button_Apply(false)
  self:EatEnchantInfoClear()
  self:setAsEatButton()
  self:setEnchantFailCount()
  Inventory_SetFunctor(FGlobal_Enchant_FileterForEatTarget, FGlobal_Enchant_RClickForTargetItem, closeForEnchant, nil)
end
function PaGlobal_Enchant:setEatTarget(slotNo, itemWrapper, inventoryType, resultType, isMonotone)
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  local failCount = self._enchantInfo:ToClient_getFailCount()
  if true ~= ToClient_Inventory_AvailFeedItem(inventoryType, slotNo) then
    return false
  end
  self:setItemToSlot(self._ui._slot_TargetItem, slotNo, itemWrapper, inventoryType)
  self._grantItemSlotNo = slotNo
  self._grantItemWhereType = inventoryType
  if nil ~= self._ui._txt_EatStackText then
    local failCount = self._enchantInfo:ToClient_getFailCount()
    local getEnchantValue = 0
    if true == _ContentsGroup_EatStackEnchant then
      self:setEnable_button_Apply(false)
      local rate = Int64toInt32(ToClient_getEnchantFailCountRateResult(inventoryType, slotNo))
      getEnchantValue = ToClient_getEnchantFailCountStackResult(inventoryType, slotNo)
      self._ui._txt_EatStackRate:SetShow(true)
      self._ui._stc_AddCountBG:SetShow(true)
      self._ui._txt_CurrentCount:SetText("+" .. tostring(failCount))
      if rate > 0 then
        self._ui._txt_AddCount:SetText("+" .. tostring(failCount + 1))
        self._ui._txt_EatStackRate:SetText("<PAColor0xFF0FBFFF>" .. string.format("%.1f", rate / CppDefine.e1Percent) .. "%")
      else
        self._ui._txt_AddCount:SetText("+" .. tostring(getEnchantValue))
        self._ui._txt_EatStackRate:SetText("<PAColor0xFF0FBFFF>100%<PAOldColor>")
      end
      self:setEnable_button_Apply(true)
      self._ui._statictext_EnchantResult:SetShow(false)
      self._eatEnchantRate = rate
    else
      self._ui._txt_EatStackText:SetShow(true)
      getEnchantValue = ToClient_Inventory_GetItemEnchantValue(inventoryType, slotNo)
      if 0 == failCount then
        self:setEnable_button_Apply(true)
        self._ui._statictext_EnchantResult:SetShow(false)
      else
        self:setEnable_button_Apply(false)
        self._ui._statictext_EnchantResult:SetShow(true)
        self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_ALERT_ZEROENCHANT"))
      end
      self._ui._txt_EatStackText:SetText("<PAColor0xffffff00>+" .. getEnchantValue)
    end
    self._eatEnchantValue = getEnchantValue
  end
  self._ui._statictext_EnchantResult:SetShow(false)
  return true
end
function PaGlobal_Enchant:ApplyButton_EatEvent()
  if self._isAnimating == true then
    self:cancelEat()
  else
    local failCount = self._enchantInfo:ToClient_getFailCount()
    local getEnchantValue = self._eatEnchantValue
    local rate = self._eatEnchantRate
    local msgTitle = ""
    local msgStr = ""
    local messageBoxData
    local function EatEnchant_ForMessageBox()
      if not self._ui._checkbox_skipEffect:IsCheck() then
        self:EatEnchantItemAnimation()
      else
        self:EatEnchantItem()
      end
    end
    if failCount == getEnchantValue then
      msgTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_EATENCHANT_BUTTON_GETSTACK")
      msgStr = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_EATENCHANT_STACK_MSGBOX", "percent", string.format("%.1f", rate / CppDefine.e1Percent))
      self._isRateStack = true
    else
      msgTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_RADIOBTNTITLE_3_EATENCHANT")
      msgStr = PAGetString(Defines.StringSheet_GAME, "LUA_EATENCHANT_MSGBOXTEXT")
      self._isRateStack = false
    end
    messageBoxData = {
      title = msgTitle,
      content = msgStr,
      functionYes = EatEnchant_ForMessageBox,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  end
end
function PaGlobal_Enchant:EatEnchantItemAnimation()
  self:startEnchantAnimation()
end
function PaGlobal_Enchant:EatEnchantItem()
  ToClient_Inventory_feedItem(self._grantItemWhereType, self._grantItemSlotNo)
  self._ui._txt_EatStackText:SetText("")
  self:setEnable_button_Apply(false)
  self._isSlotChangeAnimation = true
  if self._isAnimating == true then
    audioPostEvent_SystemUi(5, 6)
    audioPostEvent_SystemUi(5, 9)
  end
end
function PaGlobal_Enchant:EatEnchantResult()
  if true == self._isRateStack then
    return
  end
  self:clearEnchantSlot()
  self:setEnchantFailCount()
  ToClient_BlackspiritEnchantSuccess()
  if true == _ContentsGroup_EatStackEnchant then
    local failCountUpRate = Int64toInt32(self._enchantInfo:ToClient_getFailCountUpRate())
    local rateString = " " .. string.format("%.1f", failCountUpRate / CppDefine.e1Percent)
    self._ui._txt_EatStackRate:SetText("")
    if failCountUpRate > 0 then
      self:setEnable_button_Apply(true, true)
    else
      self:setEnable_button_Apply(false, true)
    end
  end
  self._ui._statictext_EnchantResult:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_NEWENCHANT_RESULT_SUCCESSEATTING", "value", self._eatEnchantValue))
  audioPostEvent_SystemUi(5, 1)
  self._ui._statictext_EnchantResult:EraseAllEffect()
  self._ui._statictext_EnchantResult:AddEffect("UI_QustComplete01", false, 0, 0)
  self._ui._statictext_EnchantResult:SetShow(true)
  self._resultTimeCheck = true
  self:setAsEatButton()
  self:setEnable_button_Apply(false)
  self:EatEnchantInfoClear()
end
function PaGlobal_Enchant:EatEnchantResultClear()
  self._ui._statictext_EnchantResult:SetShow(false)
end
function PaGlobal_Enchant:EatEnchantInfoClear()
  self._ui._stc_AddCountBG:SetShow(false)
end
function PaGlobal_Enchant:IsSkipAnimationForTab(tabNumber)
  if nil == tabNumber then
    return
  end
  if 1 == tabNumber then
    self._ui._checkbox_skipEffect:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_SKIPANIMATION"))
  elseif 2 == tabNumber then
    self._ui._checkbox_skipEffect:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_SKIPANIMATION_CAPHRAS"))
  elseif 3 == tabNumber then
    self._ui._checkbox_skipEffect:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_ENCHANT_SKIPANIMATION_EAT"))
  end
end
function PaGlobal_Enchant:getStr_EnchantInfo(curMaxEndura, decEndura, enchantType, isChecked)
  local str = ""
  if enchantType == self._enum_EnchantType._safe then
    self._ui._statictext_EnchantFailCount:SetShow(false)
    self._ui._statictext_ValksCount:SetShow(false)
    self._ui._statictext_EnchantFailCountValue:SetShow(false)
    self._ui._statictext_ValksCountValue:SetShow(false)
    self._ui._statictext_TotalEnchantCount:SetShow(false)
    self._ui._statictext_Line:SetShow(false)
    self._ui._statictext_SafeEnchant:SetShow(true)
    str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT")
  else
    self._ui._statictext_EnchantFailCount:SetShow(true)
    self._ui._statictext_ValksCount:SetShow(true)
    self._ui._statictext_EnchantFailCountValue:SetShow(true)
    self._ui._statictext_ValksCountValue:SetShow(true)
    self._ui._statictext_TotalEnchantCount:SetShow(true)
    self._ui._statictext_Line:SetShow(true)
    self._ui._statictext_SafeEnchant:SetShow(false)
    if self._ui._radiobutton_DifficultEnchant:GetShow() and self._ui._radiobutton_DifficultEnchant:IsCheck() then
      decEndura = decEndura * 0.8
    end
    local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      if CppEnums.ItemClassifyType.eItemClassify_Accessory ~= itemSSW:getItemClassify() and 20 ~= enchantLevel then
        str = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_0", "maxEndurance", tostring(decEndura), "currentEndurance", tostring(curMaxEndura))
      end
      if nil == isChecked then
        if enchantType == self._enum_EnchantType._broken or enchantType == self._enum_EnchantType._downAndBroken then
          if "" == str then
            str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_1")
          else
            str = str .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_1")
          end
        end
        if enchantType == self._enum_EnchantType._gradedown or enchantType == self._enum_EnchantType._downAndBroken then
          if "" == str then
            str = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_2")
          else
            str = str .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_2")
          end
        end
      end
      if 20 == enchantLevel then
        str = ""
      end
    end
  end
  return str
end
function PaGlobal_Enchant:getStr_EnchantProtectInfo(enchantType)
  if enchantType == self._enum_EnchantType._broken or enchantType == self._enum_EnchantType._downAndBroken then
    return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_3") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_4")
  else
    return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_5") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_4")
  end
end
function PaGlobal_Enchant:getStr_PerfectEnchantInfo(needCount, decEndura)
  local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
  if nil ~= itemWrapper then
    local itemSSW = itemWrapper:getStaticStatus()
    local enchantLevel = itemSSW:get()._key:getEnchantLevel()
    if enchantLevel > 14 then
      return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT") .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_7", "count", tostring(needCount), "endurance", tostring(decEndura))
    end
  end
  return "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_100PERCENT") .. "\n" .. PAGetStringParam2(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PENALTY_6", "count", tostring(needCount), "endurance", tostring(decEndura))
end
function PaGlobal_Enchant:getMaterialSlot()
  return self._ui._slot_EnchantMaterial
end
function PaGlobal_Enchant:getTargetItemSlot()
  return self._ui._slot_TargetItem
end
function PaGlobal_Enchant:get()
  return self
end
function PaGlobal_Enchant:enchantItem_ToItemNo()
  if nil == self._ui._slot_TargetItem.slotNo then
    return nil
  end
  return (getTItemNoBySlotNo(self._ui._slot_TargetItem.slotNo, false))
end
function PaGlobal_Enchant:enchantItem_FromItemWrapper()
  if nil == self._ui._slot_EnchantMaterial.slotNo then
    return nil
  end
  return (getInventoryItemByType(self._ui._slot_EnchantMaterial.inventoryType, self._ui._slot_EnchantMaterial.slotNo))
end
function PaGlobal_Enchant:enchantItem_ToItemWrapper()
  if nil == self._ui._slot_TargetItem.slotNo then
    return nil
  end
  return (getInventoryItemByType(self._ui._slot_TargetItem.inventoryType, self._ui._slot_TargetItem.slotNo))
end
function PaGlobal_Enchant:isEnchantTab()
  return self._ui._radiobutton_EnchantTab:IsCheck()
end
function PaGlobal_Enchant:isCronEnchantTab()
  return self._ui._radiobutton_CronEnchantTab:IsCheck()
end
function PaGlobal_Enchant:isEatTab()
  return self._ui._radiobutton_EatTab:IsCheck()
end
function PaGlobal_Enchant:isDifficultEnchant()
  if self._ui._checkbox_ForcedEnchant:IsCheck() == true then
    return false
  end
  return self._ui._radiobutton_DifficultEnchant:IsCheck()
end
function closeForEnchant()
  PaGlobal_Enchant:forceClose()
end
function FGlobal_Enchant_RClickForTargetItem(slotNo, itemWrapper, count, inventoryType)
  local self = PaGlobal_Enchant
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  self:clearEnchantSlot()
  self:showTab()
  if true == self:isEatTab() then
    self:setEatTarget(slotNo, itemWrapper, inventoryType, nil, true)
    return
  end
  self:setEnchantTarget(slotNo, itemWrapper, inventoryType, nil, true)
  Inventory_SetFunctor(FGlobal_Enchant_InvenFilerSubItem, FGlobal_Enchant_RClickMaterialItem, closeForEnchant, nil)
end
function FGlobal_Enchant_RClickForCronEnchantItem(slotNo, itemWrapper, Count, inventoryType)
  local self = PaGlobal_Enchant
  if self._isAnimating then
    return
  end
  self._isLastEnchant = false
  self:clearEnchantSlot()
  self:showTab()
  self:setCronEnchanTarget(slotNo, itemWrapper, inventoryType, true, false)
  if true == itemWrapper:isPossibleCronPromotion() then
    self._isPossiblePromotion = true
    PaGlobal_Enchant:setAsPromotionEnchantButton()
    self:setEnable_button_Apply(true)
  else
    self._isPossiblePromotion = false
    Inventory_SetFunctor(FGlobal_Enchant_InvenFilerCronItem, FGlobal_Enchant_RClickCronItem, closeForEnchant, nil)
  end
end
function FGlobal_Enchant_RClickMaterialItem(slotNo, itemWrapper, Count, inventoryType)
  local self = PaGlobal_Enchant
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  self:clearItemSlot(self._ui._slot_EnchantMaterial)
  self._materialItemSlotNo = slotNo
  self._materialItemWhereType = inventoryType
  if slotNo == self._enchantInfo:ToClient_getNeedNewPerfectItemSlotNo() and inventoryType == self._enchantInfo:ToClient_getNeedNewPerfectItemWhereType() then
    self._isSetNewPerfectItemMaterial = true
  else
    self._isSetNewPerfectItemMaterial = false
  end
  self:didsetEnchantTarget(false)
end
function FGlobal_Enchant_RClickCronItem(slotNo, itemWrapper, Count, inventoryType)
  local self = PaGlobal_Enchant
  if self._isAnimating then
    return
  end
  if itemWrapper:checkToValksItem() then
    Inventory_UseItemTargetSelf(inventoryType, slotNo, 0)
    return
  end
  self._isLastEnchant = false
  Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), 0, FGlobal_CronEnchant_SetCount)
end
function FGlobal_CronEnchant_SetCount(inputNumber)
  local self = PaGlobal_Enchant
  self:clearItemSlot(self._ui._slot_EnchantMaterial)
  self:setCronEnchantMaterial(false, inputNumber)
end
function FGlobal_Enchant_FileterForEnchantTarget(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if itemWrapper:checkToValksItem() then
    return false
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  return false == itemWrapper:checkToEnchantItem(false)
end
function FGlobal_Enchant_FilterForCronEnchantTarget(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    return true
  end
  return false == itemWrapper:checkToUpgradeItem() and false == itemWrapper:isPossibleCronPromotion()
end
function FGlobal_Enchant_FileterForEatTarget(slotNo, notUse_itemWrappers, whereType)
  local returnValue = true
  if true == ToClient_Inventory_AvailFeedItem(whereType, slotNo) then
    returnValue = false
  else
    returnValue = true
  end
  return returnValue
end
function FGlobal_Enchant_InvenFilerSubItem(slotNo, notUse_itemWrappers, whereType)
  local self = PaGlobal_Enchant
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper or true == self:isEatTab() then
    return true
  end
  if itemWrapper:checkToValksItem() then
    return false
  end
  if CppEnums.ItemWhereType.eCashInventory == whereType then
    return true
  end
  local returnValue = true
  if slotNo == getEnchantInformation():ToClient_getNeedNewPerfectItemSlotNo() then
    returnValue = false
  elseif slotNo ~= getEnchantInformation():ToClient_getNeedItemSlotNo() then
    returnValue = true
  else
    returnValue = false
    if self._ui._slot_TargetItem == slotNo and CppEnums.ItemWhereType.eInventory ~= whereType then
      returnValue = true
    end
  end
  if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
    returnValue = true
  end
  return returnValue
end
function FGlobal_Enchant_InvenFilerCronItem(slotNo, notUse_itemWrappers, whereType)
  local cronItemWrapper = getInventoryItemByType(whereType, slotNo)
  local protectItemSSW = ToClient_getPromotionEnchantItem()
  if nil ~= cronItemWrapper then
    local itemSSW = cronItemWrapper:getStaticStatus()
    local itemName = itemSSW:getName()
    if protectItemSSW:getName() == itemName then
      return false
    end
  end
  return true
end
function PaGlobal_Enchant:handleRUpEnchantSlot()
  if self._isAnimating then
    return
  end
  self:clearEnchantSlot()
  self:showTab()
end
function PaGlobal_Enchant:handleLUpEnchantTab()
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, true)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, false)
  self:clearEnchantSlot()
  self:showTab()
end
function PaGlobal_Enchant:handleLUpCronTab()
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  self:showScretExtractButton(false)
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, true)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, false)
  self:clearEnchantSlot()
  self:showTab()
end
function PaGlobal_Enchant:handleLUpEatTab()
  self._enchantInfo = getEnchantInformation()
  self._enchantInfo:ToClient_clearData()
  self:SetCheck_RadioButton(self._ui._radiobutton_EnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_CronEnchantTab, false)
  self:SetCheck_RadioButton(self._ui._radiobutton_EatTab, true)
  self:clearEnchantSlot()
  self:showTab()
end
function PaGlobal_Enchant:handleLUPSecretExtractButton()
  if self._screctExtractIvenType == CppEnums.ItemWhereType.eCashInventoryBag then
    FGlobal_CashInventoryOpen_ByEnchant()
  end
  Panel_EnchantExtraction_Show()
end
function PaGlobal_Enchant:handleLUpForcedEnchantCheckBox()
  self:setText_EnchantInfo(self._ui._checkbox_ForcedEnchant:IsCheck())
  self:showDifficulty(self._grantItemWhereType, self._grantItemSlotNo)
  if true == self._ui._checkbox_ForcedEnchant:IsCheck() then
    self._ui._statictext_noticeApplyButton:SetShow(false)
  else
    self._ui._statictext_noticeApplyButton:SetShow(self._isShowNoticeApplyButton)
  end
end
function PaGlobal_Enchant:handleLUpUseChronBox()
  self:setText_EnchantProtectInfo(self._ui._checkbox_UseCron:IsCheck())
end
function PaGlobal_Enchant:handleLUpEnchantApplyButton()
  if true == self:isEnchantTab() then
    if self._isAnimating == true then
      self:cancelEnchant()
      ToClient_StopLedDeviceAnimation(3)
    else
      local enchantAlert = false
      local failCount = self._enchantInfo:ToClient_getFailCount()
      local valksCount = self._enchantInfo:ToClient_getValksCount()
      local itemWrapper = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
      if nil == itemWrapper then
        return
      end
      local itemSSW = itemWrapper:getStaticStatus()
      local isCronKey = itemSSW:getCronKey()
      local enchantLevel = itemSSW:get()._key:getEnchantLevel()
      local isStackLessBlackStone = itemSSW:isNeedStackLessBlackStonForEnchant()
      local enchantType = self._enchantInfo:ToClient_getEnchantType()
      if 0 == failCount + valksCount and false == isStackLessBlackStone then
        if nil ~= self._grantItemWhereType and nil ~= self._grantItemSlotNo then
          if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
            if enchantLevel > 0 then
              enchantAlert = true
            end
          elseif enchantLevel > 15 and enchantType ~= self._enum_EnchantType._safe then
            enchantAlert = true
          end
        end
        if true == self._ui._checkbox_ForcedEnchant:IsCheck() or true == self._isSetNewPerfectItemMaterial then
          enchantAlert = false
        end
        if enchantAlert then
          local function goEnchant()
            self:willStartEnchant()
          end
          local _title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE")
          local _content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGEDESC")
          local messageBoxData = {
            title = _title,
            content = _content,
            functionYes = goEnchant,
            functionNo = MessageBox_Empty_function,
            priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
          }
          MessageBox.showMessageBox(messageBoxData)
        else
          self:willStartEnchant()
        end
      elseif 0 < itemWrapper:getCronEnchantFailCount() and enchantLevel > 17 and false == self._isSetNewPerfectItemMaterial and 0 ~= isCronKey then
        local function goEnchant()
          self:willStartEnchant()
        end
        local _title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE")
        local _content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_CRON_ENERGY_WARNING_DESC_CAPHRAS")
        local messageBoxData = {
          title = _title,
          content = _content,
          functionApply = goEnchant,
          functionCancel = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData, nil, false, false)
      else
        self:willStartEnchant()
      end
    end
  elseif true == self:isCronEnchantTab() then
    if self._isPossiblePromotion then
      if self._isAnimating == true then
        self:cancelPromotionEnchant()
      else
        local function promotionConfirm()
          self:willStartPromotionEnchant()
        end
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_MESSAGETITLE"),
          content = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_PROMOTE_WARNING_CAPHRAS"),
          functionYes = promotionConfirm,
          functionNo = MessageBox_Empty_function
        }
        MessageBox.showMessageBox(messageBoxData)
      end
    elseif self._isAnimating == true then
      self:cancelCronEnchant()
    else
      self:willStartCronEnchant()
    end
  elseif true == self:isEatTab() then
    self:ApplyButton_EatEvent()
  end
  FGlobal_EnchantExtraction_JustClose()
  self._resultShowTime = 0
  self._ui._radiobutton_EnchantTab:SetIgnore(false)
  self._ui._radiobutton_CronEnchantTab:SetIgnore(false)
  self._ui._radiobutton_EatTab:SetIgnore(false)
  self:setEnable_button_Apply(true)
end
function PaGlobal_Enchant:handleMOnForceEnchantTooltip()
  local control = self._ui._forceEnchantIcon
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FORCEDENCHANTTITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_FORCEDENCHANTDESC")
  if not self._ui._forceEnchantIcon:IsCheck() then
    name = name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_ENABLE")
  else
    name = name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_DISABLE")
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_Enchant:handleMOutForceEnchantTooltip()
  TooltipSimple_Hide()
end
function PaGlobal_Enchant:handleMOnCronIconTooltip()
  local control = self._ui._useCronIcon
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SAFTYENCHANTTITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SAFTYENCHANTDESC")
  if self._ui._useCronIcon:IsCheck() then
    name = name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_ENABLE")
  else
    name = name .. PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_DISABLE")
  end
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_Enchant:handleMOutCronIconTooltip()
  TooltipSimple_Hide()
end
function PaGlobal_Enchant:handleMOnEnchantMaterialTooltip()
  self._isSlotChangeMouseOver = true
  if true == self._ui._slot_EnchantMaterial.empty then
  elseif CppEnums.TInventorySlotNoUndefined == self._ui._slot_EnchantMaterial.inventoryType then
    local needSSW
    if self:isEnchantTab() == true then
      needSSW = self._enchantInfo:ToClient_getNeedNewPerfectItemStaticInformation()
      if true == self._slotChangeFlag or false == needSSW:isSet() then
        needSSW = self._enchantInfo:ToClient_getNeedItemStaticInformation()
      end
    else
      needSSW = ToClient_getPromotionEnchantItem()
    end
    Panel_Tooltip_Item_Show(needSSW, self._ui._slot_EnchantMaterial.icon, true, false)
  else
    Panel_Tooltip_Item_Show_GeneralNormal(1, "Enchant", true)
  end
end
function PaGlobal_Enchant:handleMOutEnchantMaterialTooltip()
  self._isSlotChangeMouseOver = false
  if true == self._ui._slot_EnchantMaterial.empty then
  elseif CppEnums.TInventorySlotNoUndefined == self._ui._slot_EnchantMaterial.inventoryType then
    Panel_Tooltip_Item_hideTooltip()
  else
    Panel_Tooltip_Item_Show_GeneralNormal(1, "Enchant", false)
  end
end
function PaGlobal_Enchant:handleMOnEnchantTargetTooltip()
  if true == self._ui._slot_TargetItem.empty then
  elseif true == self:isEnchantTab() or true == self:isCronEnchantTab() then
    Panel_Tooltip_Item_Show_GeneralNormal(0, "Enchant", true)
  elseif true == self:isEatTab() then
    local getItemSSW = getInventoryItemByType(self._grantItemWhereType, self._grantItemSlotNo)
    Panel_Tooltip_Item_Show(getItemSSW, self._ui._slot_TargetItem.icon, false, true)
  end
end
function PaGlobal_Enchant:handleMOutEnchantTargetTooltip()
  if true == self._ui._slot_TargetItem.empty then
  else
    Panel_Tooltip_Item_hideTooltip()
    Panel_Tooltip_Item_Show_GeneralNormal(0, "Enchant", false)
  end
end
function PaGlobal_Enchant:handleMOnEasyEnchant()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_DRASTICENCHANT_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_DRASTICENCHANT_DESC")
  TooltipSimple_Show(self._ui._radiobutton_EasyEnchant, name, desc)
end
function PaGlobal_Enchant:handleMOutEasyEnchant()
  TooltipSimple_Hide()
end
function PaGlobal_Enchant:handlemOnDifficultEnchant()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_METICULOUSENCHANT_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_ENCHANT_METICULOUSENCHANT_DESC")
  TooltipSimple_Show(self._ui._radiobutton_EasyEnchant, name, desc)
end
function PaGlobal_Enchant:handleMOutDifficultEnchant()
  TooltipSimple_Hide()
end
function PaGlobal_Enchant:handleMUpSkipEffect()
  local name = ""
  if 1 == self._currentTab then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPCRON_TOOLTIP_NAME")
  elseif 2 == self._currentTab then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPEATTING_TOOLTIP_NAME")
  else
    name = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_NAME")
  end
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_SPRITENCHANT_SKIPENCHANT_TOOLTIP_DESC_CAPHRAS")
  TooltipSimple_Show(self._ui._checkbox_skipEffect, name, desc)
end
function PaGlobal_Enchant:handleMOutSkipEffect()
  TooltipSimple_Hide()
end
function FromClient_EnchantResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  local self = PaGlobal_Enchant
  self._isWaitingServer = false
  self:didEnchant(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
  PaGlobal_TutorialManager:handleEnchantResultShow(resultType, mainWhereType, mainSlotNo, subWhereType, subSlotNo)
end
function PaGlobalFunc_SpiritEnchant_EnchantFailCountUpResult(enchantFailCount, enchantFailCountUpRate, isSuccess)
  local self = PaGlobal_Enchant
  self:setEnable_button_Apply(false, true)
  PaGlobal_Enchant:setEnchantFailCount()
  self:EatEnchantInfoClear()
  self:clearEnchantSlot()
  self._ui._txt_EatStackRate:SetShow(false)
  self._resultShowTime = 0
  if true == isSuccess then
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EATENCHANT_STACK_SUCCESS"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("UI_QustComplete01", false, 0, 0)
    audioPostEvent_SystemUi(5, 1)
    ToClient_BlackspiritEnchantSuccess()
  else
    self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_EATENCHANT_STACK_FAIL"))
    self._ui._statictext_EnchantResult:EraseAllEffect()
    self._ui._statictext_EnchantResult:AddEffect("fUI_Enchant_Fail", false, 0, 0)
    audioPostEvent_SystemUi(0, 7)
    audioPostEvent_SystemUi(5, 8)
    ToClient_BlackspiritEnchantCancel()
  end
  self._ui._statictext_EnchantResult:SetShow(true)
  self._resultTimeCheck = true
end
function FromClient_UpgradeItem(mainWhereType, mainSlotNo, variedCount)
  local self = PaGlobal_Enchant
  self:didCronEnchant(mainWhereType, mainSlotNo, variedCount)
  if 0 ~= self._enchantInfo:ToClient_getNeedStack() then
    PaGlobal_Enchant:setEnable_button_Apply(false)
  end
end
function FromClient_PromotionItem(mainWhereType, mainSlotNo)
  local self = PaGlobal_Enchant
  self:didCronPromotion(mainWhereType, mainSlotNo)
  PaGlobal_Enchant:setEnable_button_Apply(false)
end
function FromClient_UpdateEnchantFailCount()
  if Panel_Window_Enchant:GetShow() then
    PaGlobal_Enchant:setEnchantFailCount()
  end
end
function OnScreenEvent()
  local self = PaGlobal_Enchant
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_Window_Enchant:SetPosX(sizeX / 2 - Panel_Window_Enchant:GetSizeX() / 2)
  Panel_Window_Enchant:SetPosY(Panel_Window_Inventory:GetPosY())
end
function FromClient_FailCountUpdate()
  local self = PaGlobal_Enchant
  self:EatEnchantResult()
end
function PaGlobal_Enchant:SetAnimation()
  self._ui._statictext_EnchantResult:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_NEWENCHANT_SUCCESSFINALENCHANT"))
  self._ui._statictext_EnchantResult:ResetVertexAni()
  self._ui._statictext_EnchantResult:SetScale(1, 1)
  self._ui._statictext_EnchantResult:SetSize(250, 20)
  self._ui._statictext_EnchantResult:ComputePos()
  self._ui._statictext_EnchantResult:SetVertexAniRun("Ani_Move_Pos_New", true)
  self._ui._statictext_EnchantResult:SetVertexAniRun("Ani_Scale_New", true)
  self._isResulTextAnimation = true
end
function PaGlobal_Enchant:enchatSlotAnimation(flag)
  if true == self:isEatTab() then
    return
  end
  local control = self._ui._slot_EnchantMaterial.icon
  self:changeSlotIconTexture(self._ui._slot_EnchantMaterial, flag)
  if true == flag then
    local ImageMoveAni = control:addMoveAnimation(0, self._slotChangeMoveTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    ImageMoveAni:SetStartPosition(self._ui._slot_EnchantMaterial.icon:GetPosX(), self._ui._slot_EnchantMaterial.icon:GetPosY())
    ImageMoveAni:SetEndPosition(self._ui._slot_EnchantMaterial.icon:GetPosX(), self._ui._slot_EnchantMaterial.icon:GetPosY())
    control:CalcUIAniPos(ImageMoveAni)
    ImageMoveAni:SetDisableWhileAni(true)
  else
    local ImageMoveAni = control:addMoveAnimation(0, self._slotChangeMoveTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
    ImageMoveAni:SetStartPosition(self._ui._slot_EnchantMaterial.icon:GetPosX(), self._ui._slot_EnchantMaterial.icon:GetPosY())
    ImageMoveAni:SetEndPosition(self._ui._slot_EnchantMaterial.icon:GetPosX(), self._ui._slot_EnchantMaterial.icon:GetPosY())
    control:CalcUIAniPos(ImageMoveAni)
    ImageMoveAni:SetDisableWhileAni(true)
  end
end
function PaGlobal_Enchant:changeSlotIconTexture(control, flag)
  if false == flag then
    self:setItemToSlotMonoTone(control, self._enchantInfo:ToClient_getNeedItemStaticInformation())
  else
    local newPerfectNeedItem = self._enchantInfo:ToClient_getNeedNewPerfectItemStaticInformation()
    if nil ~= newPerfectNeedItem and true == newPerfectNeedItem:isSet() then
      self:setItemToSlotMonoTone(control, newPerfectNeedItem)
    end
  end
end
function FGlobal_Enchant_SetTargetItem()
  local self = PaGlobal_Enchant
  if true == self._ui._slot_TargetItem.empty then
    return false
  else
    return true
  end
end
function FromClient_ProtmotionItem(mainWhereType, mainSlotNo, variedCount)
  local self = PaGlobal_Enchant
  self:didCronEnchant(mainWhereType, mainSlotNo, variedCount)
end
function UpdateFunc_checkAnimation(deltaTime)
  local self = PaGlobal_Enchant
  if false == self._isSlotChangeAnimation or true == self._isSlotChangeMouseOver then
    self._slotChangeDelayTime = 0
  else
    self._slotChangeDelayTime = self._slotChangeDelayTime + deltaTime
    if self._slotChangeWaitTime < self._slotChangeDelayTime then
      self:enchatSlotAnimation(self._slotChangeFlag)
      self._slotChangeDelayTime = 0
      self._slotChangeFlag = not self._slotChangeFlag
    end
  end
  if true == self._isAnimating then
    self._animationTimeStamp = self._animationTimeStamp + deltaTime
    if self._const._effectTime_Enchant <= self._animationTimeStamp then
      self._isAnimating = false
      self._ui._radiobutton_EnchantTab:SetIgnore(false)
      self._ui._radiobutton_CronEnchantTab:SetIgnore(false)
      self._ui._radiobutton_EatTab:SetIgnore(false)
      if true == self:isEnchantTab() then
        self:startEnchant()
      elseif true == self:isEatTab() then
        self:EatEnchantItem()
      elseif self._isPossiblePromotion then
        self:startPromotionEnchant()
      else
        self:startCronEnchant()
      end
      return
    end
    self._ui._radiobutton_EnchantTab:SetIgnore(true)
    self._ui._radiobutton_CronEnchantTab:SetIgnore(true)
    self._ui._radiobutton_EatTab:SetIgnore(true)
  end
  if self._isLastEnchant then
    if not self._isResulTextAnimation then
      self:SetAnimation()
    end
    return
  end
  self._isResulTextAnimation = false
  if self._resultTimeCheck then
    self._resultShowTime = self._resultShowTime + deltaTime
    if self._resultShowTime > 2 then
      self._resultShowTime = 0
      self._resultTimeCheck = false
      if true == self:isEnchantTab() then
        self:setEnchantFailCount()
      elseif true == self:isEatTab() then
        self:EatEnchantResultClear()
      else
        self:setTextCronEnchantResultState()
      end
    end
  end
end
