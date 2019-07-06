local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
local QuestType = CppEnums.QuestType
local QuestRegionType = CppEnums.QuestRegionType
local isContentsEnableMedia = ToClient_IsContentsGroupOpen("3")
local isContentsEnableValencia = ToClient_IsContentsGroupOpen("4")
local isContentsEnableKamasilvia = ToClient_IsContentsGroupOpen("5")
local isContentsEnableDragan = ToClient_IsContentsGroupOpen("6")
Panel_Window_Quest_New:SetShow(false)
Panel_Window_Quest_New:setGlassBackground(true)
Panel_Window_Quest_New:ActiveMouseEventEffect(true)
Panel_Window_Quest_New:RegisterShowEventFunc(true, "Panel_QuestListShowAni()")
Panel_Window_Quest_New:RegisterShowEventFunc(false, "Panel_QuestListHideAni()")
local QuestTabType = {
  QuestTabType_Progress = 0,
  QuestTabType_Recommendation = 1,
  QuestTabType_Repetition = 2,
  QuestTabType_Main = 3,
  QuestTabType_New = 4
}
local QuestWindow = {
  ui = {
    btn_Close = UI.getChildControl(Panel_Window_Quest_New, "Button_Win_Close"),
    btn_Question = UI.getChildControl(Panel_Window_Quest_New, "Button_Question"),
    favorTitle_BG = UI.getChildControl(Panel_Window_Quest_New, "Static_FavorLineBG"),
    contentBG = UI.getChildControl(Panel_Window_Quest_New, "Static_LineBG"),
    scroll = UI.getChildControl(Panel_Window_Quest_New, "Scroll_CheckQuestList"),
    groupTypeBG = UI.getChildControl(Panel_Window_Quest_New, "Static_GroupTypeBG"),
    ListFilterBG = UI.getChildControl(Panel_Window_Quest_New, "Static_ListFilterBG"),
    questCountBG = UI.getChildControl(Panel_Window_Quest_New, "Static_QuestCountBg"),
    tabProgress = UI.getChildControl(Panel_Window_Quest_New, "RadioButton_TabProgressing"),
    tabImportant = UI.getChildControl(Panel_Window_Quest_New, "RadioButton_TabImportant"),
    tabRepeat = UI.getChildControl(Panel_Window_Quest_New, "RadioButton_TabRepeat"),
    tabMain = UI.getChildControl(Panel_Window_Quest_New, "RadioButton_Main"),
    tabNewQuest = UI.getChildControl(Panel_Window_Quest_New, "RadioButton_TabNewQuest"),
    templateGroupBG = UI.getChildControl(Panel_Window_Quest_New, "Static_GroupTitleBG"),
    templateListBG = UI.getChildControl(Panel_Window_Quest_New, "Static_ListMainBG"),
    checkPopUp = UI.getChildControl(Panel_Window_Quest_New, "CheckButton_PopUp")
  },
  uiPool = {
    questFavorType = {},
    groupTitle = {},
    listMain = {}
  },
  config = {
    favorCount = 6,
    slotMaxCount = 13,
    listCount = 0,
    startSlotIndex = 1,
    isRegionExpanded = true,
    isTypeExpanded = true
  },
  selectWay = {
    groupID = "",
    questID = "",
    isAuto = false
  }
}
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
QuestWindow.ui.checkPopUp:SetShow(isPopUpContentsEnable)
QuestWindow.ui.favorTitle = UI.getChildControl(QuestWindow.ui.favorTitle_BG, "StaticText_FavorType")
QuestWindow.ui.scrollBtn = UI.getChildControl(QuestWindow.ui.scroll, "Scroll_CtrlButton")
QuestWindow.ui.questCount = UI.getChildControl(QuestWindow.ui.groupTypeBG, "StaticText_QuestCount")
QuestWindow.ui.radioTerritoryGroup = UI.getChildControl(QuestWindow.ui.groupTypeBG, "RadioButton_Territory")
QuestWindow.ui.radioTypeGroup = UI.getChildControl(QuestWindow.ui.groupTypeBG, "RadioButton_QuestType")
QuestWindow.ui.chkEmptyGroupHide = UI.getChildControl(QuestWindow.ui.groupTypeBG, "CheckButton_EmptyGroupHide")
QuestWindow.ui.questBranchBtn = UI.getChildControl(QuestWindow.ui.ListFilterBG, "Button_QuestBranch")
QuestWindow.ui.favorTitle_BG:SetNotAbleMasking(true)
QuestWindow.ui.hideCompBtn = UI.getChildControl(QuestWindow.ui.ListFilterBG, "CheckButton_Complete")
QuestWindow.ui.favorTitle:SetNotAbleMasking(true)
QuestWindow.ui.contentBG:SetNotAbleMasking(true)
QuestWindow.ui.contentBG:SetAlpha(0.8)
QuestWindow.ui.contentBG:SetIgnore(false)
QuestWindow.ui.chkEmptyGroupHide:SetEnableArea(0, 0, QuestWindow.ui.chkEmptyGroupHide:GetSizeX() + QuestWindow.ui.chkEmptyGroupHide:GetTextSizeX() + 10, QuestWindow.ui.chkEmptyGroupHide:GetSizeY())
local useArray = {}
local regionString = {
  [QuestRegionType.eQuestRegionType_None] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_99"),
  [QuestRegionType.eQuestRegionType_Balenos] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_1"),
  [QuestRegionType.eQuestRegionType_Serendia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_2"),
  [QuestRegionType.eQuestRegionType_NorthCalpheon] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_3"),
  [QuestRegionType.eQuestRegionType_CalpheonBigCity] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_4"),
  [QuestRegionType.eQuestRegionType_Keplan] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_5"),
  [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_6"),
  [QuestRegionType.eQuestRegionType_Media] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_7"),
  [QuestRegionType.eQuestRegionType_Valencia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_8"),
  [QuestRegionType.eQuestRegionType_Kamasylvia] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_9"),
  [QuestRegionType.eQuestRegionType_Drigan] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_REGION_10")
}
local regionOpen = {
  [QuestRegionType.eQuestRegionType_None] = true,
  [QuestRegionType.eQuestRegionType_Balenos] = true,
  [QuestRegionType.eQuestRegionType_Serendia] = true,
  [QuestRegionType.eQuestRegionType_NorthCalpheon] = true,
  [QuestRegionType.eQuestRegionType_CalpheonBigCity] = true,
  [QuestRegionType.eQuestRegionType_Keplan] = true,
  [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = true,
  [QuestRegionType.eQuestRegionType_Media] = true,
  [QuestRegionType.eQuestRegionType_Valencia] = true,
  [QuestRegionType.eQuestRegionType_Kamasylvia] = true,
  [QuestRegionType.eQuestRegionType_Drigan] = true,
  [QuestRegionType.eQuestRegionType_Count] = false
}
local questType = {
  black = 0,
  story = 1,
  town = 2,
  adv = 3,
  trade = 4,
  craft = 5,
  rep = 6,
  count = 7
}
local questSelectType = {
  story = 0,
  hunt = 1,
  life = 2,
  fish = 3,
  adv = 4,
  etc = 5
}
local typeString = {
  [QuestType.eQuestType_BlackSpirit] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_1"),
  [QuestType.eQuestType_Story] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_2"),
  [QuestType.eQuestType_Town] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_3"),
  [QuestType.eQuestType_Adventure] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_4"),
  [QuestType.eQuestType_Trade] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_5"),
  [QuestType.eQuestType_Craft] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_6"),
  [QuestType.eQuestType_Repetition] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_7"),
  [QuestType.eQuestType_Guild] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_8"),
  [QuestType.eQuestType_Special] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_10"),
  [QuestType.eQuestType_RegionMonsterKill] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_HISTORY_TXT_TYPE_11")
}
local typeOpen = {
  [QuestType.eQuestType_BlackSpirit] = true,
  [QuestType.eQuestType_Story] = true,
  [QuestType.eQuestType_Town] = true,
  [QuestType.eQuestType_Adventure] = true,
  [QuestType.eQuestType_Trade] = true,
  [QuestType.eQuestType_Craft] = true,
  [QuestType.eQuestType_Repetition] = true,
  [QuestType.eQuestType_Guild] = true,
  [QuestType.eQuestType_Special] = true,
  [QuestType.eQuestType_RegionMonsterKill] = true,
  [QuestType.eQuestType_Count] = false
}
local groupOpen = {}
local repetitiveQuestGroupOpen = {}
local questArrayGroupCount = {}
local questArrayGroupCompleteCount = {}
local questSortArrayRegion = {
  [QuestRegionType.eQuestRegionType_None] = {},
  [QuestRegionType.eQuestRegionType_Balenos] = {},
  [QuestRegionType.eQuestRegionType_Serendia] = {},
  [QuestRegionType.eQuestRegionType_NorthCalpheon] = {},
  [QuestRegionType.eQuestRegionType_CalpheonBigCity] = {},
  [QuestRegionType.eQuestRegionType_Keplan] = {},
  [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = {},
  [QuestRegionType.eQuestRegionType_Media] = {},
  [QuestRegionType.eQuestRegionType_Valencia] = {},
  [QuestRegionType.eQuestRegionType_Kamasylvia] = {},
  [QuestRegionType.eQuestRegionType_Drigan] = {}
}
local questArrayRegionCount = {
  [QuestRegionType.eQuestRegionType_None] = 0,
  [QuestRegionType.eQuestRegionType_Balenos] = 0,
  [QuestRegionType.eQuestRegionType_Serendia] = 0,
  [QuestRegionType.eQuestRegionType_NorthCalpheon] = 0,
  [QuestRegionType.eQuestRegionType_CalpheonBigCity] = 0,
  [QuestRegionType.eQuestRegionType_Keplan] = 0,
  [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = 0,
  [QuestRegionType.eQuestRegionType_Media] = 0,
  [QuestRegionType.eQuestRegionType_Valencia] = 0,
  [QuestRegionType.eQuestRegionType_Kamasylvia] = 0,
  [QuestRegionType.eQuestRegionType_Drigan] = 0
}
local questArrayRegionProgressCount = {
  [QuestRegionType.eQuestRegionType_None] = 0,
  [QuestRegionType.eQuestRegionType_Balenos] = 0,
  [QuestRegionType.eQuestRegionType_Serendia] = 0,
  [QuestRegionType.eQuestRegionType_NorthCalpheon] = 0,
  [QuestRegionType.eQuestRegionType_CalpheonBigCity] = 0,
  [QuestRegionType.eQuestRegionType_Keplan] = 0,
  [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = 0,
  [QuestRegionType.eQuestRegionType_Media] = 0,
  [QuestRegionType.eQuestRegionType_Valencia] = 0,
  [QuestRegionType.eQuestRegionType_Kamasylvia] = 0,
  [QuestRegionType.eQuestRegionType_Drigan] = 0
}
local questArrayRegionSort = {
  [0] = QuestRegionType.eQuestRegionType_Balenos,
  [1] = QuestRegionType.eQuestRegionType_Serendia,
  [2] = QuestRegionType.eQuestRegionType_NorthCalpheon,
  [3] = QuestRegionType.eQuestRegionType_CalpheonBigCity,
  [4] = QuestRegionType.eQuestRegionType_Keplan,
  [5] = QuestRegionType.eQuestRegionType_SouthWestCalpheon,
  [6] = QuestRegionType.eQuestRegionType_Media,
  [7] = QuestRegionType.eQuestRegionType_Valencia,
  [8] = QuestRegionType.eQuestRegionType_Kamasylvia,
  [9] = QuestRegionType.eQuestRegionType_Drigan,
  [10] = QuestRegionType.eQuestRegionType_None
}
local questSortArrayType = {
  [QuestType.eQuestType_BlackSpirit] = {},
  [QuestType.eQuestType_Story] = {},
  [QuestType.eQuestType_Town] = {},
  [QuestType.eQuestType_Adventure] = {},
  [QuestType.eQuestType_Trade] = {},
  [QuestType.eQuestType_Craft] = {},
  [QuestType.eQuestType_Repetition] = {},
  [QuestType.eQuestType_Guild] = {},
  [QuestType.eQuestType_Special] = {},
  [QuestType.eQuestType_RegionMonsterKill] = {}
}
local questArrayTypeCount = {
  [QuestType.eQuestType_BlackSpirit] = 0,
  [QuestType.eQuestType_Story] = 0,
  [QuestType.eQuestType_Town] = 0,
  [QuestType.eQuestType_Adventure] = 0,
  [QuestType.eQuestType_Trade] = 0,
  [QuestType.eQuestType_Craft] = 0,
  [QuestType.eQuestType_Repetition] = 0,
  [QuestType.eQuestType_Guild] = {},
  [QuestType.eQuestType_Special] = {},
  [QuestType.eQuestType_RegionMonsterKill] = {}
}
local questArrayTypeProgressCount = {
  [QuestType.eQuestType_BlackSpirit] = 0,
  [QuestType.eQuestType_Story] = 0,
  [QuestType.eQuestType_Town] = 0,
  [QuestType.eQuestType_Adventure] = 0,
  [QuestType.eQuestType_Trade] = 0,
  [QuestType.eQuestType_Craft] = 0,
  [QuestType.eQuestType_Repetition] = 0,
  [QuestType.eQuestType_Guild] = {},
  [QuestType.eQuestType_Special] = 0,
  [QuestType.eQuestType_RegionMonsterKill] = 0
}
local questSelectTypeString = {
  [questSelectType.story] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_1"),
  [questSelectType.hunt] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_2"),
  [questSelectType.life] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_3"),
  [questSelectType.fish] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_4"),
  [questSelectType.adv] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_5"),
  [questSelectType.etc] = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_QUESTSELECTTYPE_TXT_TYPE_6")
}
function Panel_QuestListShowAni()
  local aniInfo1 = Panel_Window_Quest_New:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.05)
  aniInfo1.AxisX = Panel_Window_Quest_New:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Window_Quest_New:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Window_Quest_New:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.05)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Window_Quest_New:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Window_Quest_New:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_QuestListHideAni()
  Panel_Window_Quest_New:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_Quest_New:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
function QuestWindow:init()
  local questFavorType = {}
  local favorStartPosX = 85
  for ii = 0, self.config.favorCount - 1 do
    local controlIdNumber = ii + 1
    local controlId = "CheckButton_FavorType_" .. tostring(controlIdNumber)
    local control = UI.getChildControl(QuestWindow.ui.favorTitle_BG, controlId)
    control:addInputEvent("Mouse_LUp", "QuestWindow_SelectQuestFavorType(" .. ii .. ")")
    control:SetNotAbleMasking(true)
    if 5 == controlIdNumber then
    else
    end
    control:addInputEvent("Mouse_On", "QUestWindow_SelectQuestFavorTypeSimpleTooltip( true, " .. ii .. " )")
    control:addInputEvent("Mouse_Out", "QUestWindow_SelectQuestFavorTypeSimpleTooltip( false, " .. ii .. " )")
    self.uiPool.questFavorType[ii] = control
  end
  QuestWindow.ui.favorTitle:addInputEvent("Mouse_On", "QUestWindow_SelectQuestFavorTypeSimpleTooltip( true, 99 )")
  QuestWindow.ui.favorTitle:addInputEvent("Mouse_Out", "QUestWindow_SelectQuestFavorTypeSimpleTooltip( false, 99 )")
  for slotIdx = 0, self.config.slotMaxCount - 1 do
    local groupSlot = {}
    local baseGroupControl = QuestWindow.ui.templateGroupBG
    groupSlot.bg = UI.createAndCopyBasePropertyControl(Panel_Window_Quest_New, "Static_GroupTitleBG", self.ui.contentBG, "QuestWindow_GroupTitleBG_" .. slotIdx)
    groupSlot.typeIcon = UI.createAndCopyBasePropertyControl(baseGroupControl, "Static_QuestTypeIcon", groupSlot.bg, "QuestWindow_GroupTypeIcon_" .. slotIdx)
    groupSlot.name = UI.createAndCopyBasePropertyControl(baseGroupControl, "StaticText_QuestName", groupSlot.bg, "QuestWindow_GroupName_" .. slotIdx)
    groupSlot.expandIcon = UI.createAndCopyBasePropertyControl(baseGroupControl, "Static_QuestExpanded", groupSlot.bg, "QuestWindow_GroupQuestExpanded_" .. slotIdx)
    groupSlot.completePercent = UI.createAndCopyBasePropertyControl(baseGroupControl, "StaticText_CompletePercent", groupSlot.bg, "QuestWindow_GroupCompletePercent_" .. slotIdx)
    groupSlot.bg:SetPosX(10)
    groupSlot.bg:SetPosY(slotIdx * (groupSlot.bg:GetSizeY() + 5) + 45)
    groupSlot.bg:SetShow(false)
    groupSlot.bg:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    groupSlot.bg:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    groupSlot.typeIcon:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    groupSlot.typeIcon:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    groupSlot.name:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    groupSlot.name:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    groupSlot.expandIcon:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    groupSlot.expandIcon:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    groupSlot.completePercent:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    groupSlot.completePercent:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    groupSlot.name:SetTextMode(UI_TM.eTextMode_LimitText)
    self.uiPool.groupTitle[slotIdx] = groupSlot
    local listSlot = {}
    local baseListControl = QuestWindow.ui.templateListBG
    listSlot.bg = UI.createAndCopyBasePropertyControl(Panel_Window_Quest_New, "Static_ListMainBG", self.ui.contentBG, "QuestWindow_ListMainBG_" .. slotIdx)
    listSlot.showBtn = UI.createAndCopyBasePropertyControl(baseListControl, "CheckButton_ShowWidget", listSlot.bg, "QuestWindow_ListShowWidgetBtn_" .. slotIdx)
    listSlot.typeIcon = UI.createAndCopyBasePropertyControl(baseListControl, "Static_ListMain_QuestTypeIcon", listSlot.bg, "QuestWindow_ListTypeIcon_" .. slotIdx)
    listSlot.name = UI.createAndCopyBasePropertyControl(baseListControl, "StaticText_ListMain_QuestName", listSlot.bg, "QuestWindow_ListQuestName_" .. slotIdx)
    listSlot.remainTime = UI.createAndCopyBasePropertyControl(baseListControl, "StaticText_ListMain_Quest_RemainTime", listSlot.bg, "QuestWindow_ListQuestRemainTime_" .. slotIdx)
    listSlot.btnAuto = UI.createAndCopyBasePropertyControl(baseListControl, "CheckButton_ListMain_AutoNavi", listSlot.bg, "QuestWindow_ListAutoNavi_" .. slotIdx)
    listSlot.btnNavi = UI.createAndCopyBasePropertyControl(baseListControl, "Checkbox_ListMain_QuestNavi", listSlot.bg, "QuestWindow_ListNavi_" .. slotIdx)
    listSlot.btnGiveup = UI.createAndCopyBasePropertyControl(baseListControl, "Checkbox_ListMain_QuestGiveup", listSlot.bg, "QuestWindow_ListGiveup_" .. slotIdx)
    listSlot.btnReward = UI.createAndCopyBasePropertyControl(baseListControl, "Checkbox_ListMain_QuestReward", listSlot.bg, "QuestWindow_ListReward_" .. slotIdx)
    listSlot.completeCount = UI.createAndCopyBasePropertyControl(baseListControl, "StaticText_ListMain_GroupCompleteCount", listSlot.bg, "QuestWindow_ListCompleteCount_" .. slotIdx)
    listSlot.bg:SetPosX(10)
    listSlot.bg:SetPosY(slotIdx * (listSlot.bg:GetSizeY() + 5) + 45)
    listSlot.bg:SetShow(false)
    listSlot.name:SetTextMode(UI_TM.eTextMode_LimitText)
    listSlot.bg:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.bg:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.showBtn:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.showBtn:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.typeIcon:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.typeIcon:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.name:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.name:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.remainTime:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.remainTime:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.btnAuto:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.btnAuto:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.btnNavi:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.btnNavi:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.btnGiveup:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.btnGiveup:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.btnReward:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.btnReward:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.completeCount:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
    listSlot.completeCount:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
    listSlot.btnAuto:addInputEvent("Mouse_On", "")
    listSlot.btnAuto:addInputEvent("Mouse_Out", "")
    listSlot.btnNavi:addInputEvent("Mouse_On", "")
    listSlot.btnNavi:addInputEvent("Mouse_Out", "")
    listSlot.btnGiveup:addInputEvent("Mouse_On", "")
    listSlot.btnGiveup:addInputEvent("Mouse_Out", "")
    listSlot.btnReward:addInputEvent("Mouse_On", "")
    listSlot.btnReward:addInputEvent("Mouse_Out", "")
    self.uiPool.listMain[slotIdx] = listSlot
  end
  QuestWindow.ui.questBranchBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_QuestBranch(" .. 0 .. ")")
  local questListInfo = ToClient_GetQuestList()
  local repeatitionQuestGroupCount = questListInfo:getRepetitionQuestGroupCount()
  local questGroupCount = questListInfo:getRecommendationQuestGroupCount()
  local mainQuestGroupCount = questListInfo:getMainQuestGroupCount()
  local newQuestGroupCount = questListInfo:getNewQuestGroupCount()
  recommendationGroupOpen = {}
  repetitiveQuestGroupOpen = {}
  mainQuestGroupOpen = {}
  newQuestGroupOpen = {}
  questArrayGroupCount = {}
  questArrayGroupCompleteCount = {}
  for groupIdx = 0, questGroupCount - 1 do
    recommendationGroupOpen[groupIdx] = false
  end
  for groupIdx = 0, repeatitionQuestGroupCount - 1 do
    repetitiveQuestGroupOpen[groupIdx] = false
  end
  for groupIdx = 0, mainQuestGroupCount - 1 do
    mainQuestGroupOpen[groupIdx] = false
  end
  for groupIdx = 0, newQuestGroupCount - 1 do
    newQuestGroupOpen[groupIdx] = false
  end
  local btnTabProgressSizeX = self.ui.tabProgress:GetSizeX() + 23
  local btnTabProgressTextPosX = btnTabProgressSizeX - btnTabProgressSizeX / 2 - self.ui.tabProgress:GetTextSizeX() / 2
  self.ui.tabProgress:SetTextSpan(btnTabProgressTextPosX, 5)
  local btnTabImportantSizeX = self.ui.tabImportant:GetSizeX() + 10
  local btnTabImportantTextPosX = btnTabImportantSizeX - btnTabImportantSizeX / 2 - self.ui.tabImportant:GetTextSizeX() / 2
  self.ui.tabImportant:SetTextSpan(btnTabImportantTextPosX, 5)
  local btnTabRepeatSizeX = self.ui.tabRepeat:GetSizeX() + 23
  local btnTabRepeatTextPosX = btnTabRepeatSizeX - btnTabRepeatSizeX / 2 - self.ui.tabRepeat:GetTextSizeX() / 2
  self.ui.tabRepeat:SetTextSpan(btnTabRepeatTextPosX, 5)
  local btnTabMainSizeX = self.ui.tabMain:GetSizeX() + 23
  local btnTabMainTextPosX = btnTabMainSizeX - btnTabMainSizeX / 2 - self.ui.tabMain:GetTextSizeX() / 2
  self.ui.tabMain:SetTextSpan(btnTabMainTextPosX, 5)
  if true == _ContentsGroup_NewQuest then
    local btnTabNewQuestSizeX = self.ui.tabNewQuest:GetSizeX() + 23
    local btnTabNewQuestTextPosX = btnTabNewQuestSizeX - btnTabNewQuestSizeX / 2 - self.ui.tabNewQuest:GetTextSizeX() / 2
    self.ui.tabNewQuest:SetTextSpan(btnTabNewQuestTextPosX, 5)
  end
  self.ui.templateGroupBG:SetShow(false)
  self.ui.templateGroupBG:SetIgnore(true)
  self.ui.templateListBG:SetShow(false)
  self.ui.tabProgress:SetCheck(true)
  self.ui.tabImportant:SetCheck(false)
  self.ui.tabRepeat:SetCheck(false)
  self.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    self.ui.tabNewQuest:SetCheck(false)
  end
  self.ui.groupTypeBG:SetShow(true)
  self.ui.ListFilterBG:SetShow(false)
  self.ui.radioTerritoryGroup:SetCheck(true)
  self.ui.radioTypeGroup:SetCheck(false)
  self.ui.chkEmptyGroupHide:SetCheck(true)
  self.ui.hideCompBtn:SetCheck(true)
  QuestWindow.ui.chkEmptyGroupHide:SetSpanSize(QuestWindow.ui.chkEmptyGroupHide:GetTextSizeX() + 5, 0)
  if QuestWindow.ui.radioTerritoryGroup:GetSpanSize().x < QuestWindow.ui.chkEmptyGroupHide:GetSpanSize().x + QuestWindow.ui.radioTerritoryGroup:GetSizeX() then
    local radioButtonPosX = QuestWindow.ui.chkEmptyGroupHide:GetSpanSize().x - QuestWindow.ui.radioTerritoryGroup:GetSpanSize().x + QuestWindow.ui.radioTerritoryGroup:GetSizeX()
    QuestWindow.ui.radioTerritoryGroup:SetSpanSize(QuestWindow.ui.radioTerritoryGroup:GetSpanSize().x + radioButtonPosX, 0)
    QuestWindow.ui.radioTypeGroup:SetSpanSize(QuestWindow.ui.radioTypeGroup:GetSpanSize().x + radioButtonPosX, 0)
  end
  QuestWindow.ui.questCountAll = UI.getChildControl(QuestWindow.ui.questCountBG, "StaticText_TotalQuestTitle")
end
function QuestWindow_SelectQuestFavorType(selectType)
  if 20 <= getSelfPlayer():get():getLevel() then
    if 0 == selectType then
      QuestWindow:favorCheckAll()
    else
      ToClient_ToggleQuestSelectType(selectType)
    end
    FGlobal_UpdateQuestFavorType()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_FAVORITETYPE_ALERT"))
  end
end
function QUestWindow_SelectQuestFavorTypeSimpleTooltip(isShow, index)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local controlId = "CheckButton_FavorType_" .. tostring(index + 1)
  local controlQuestType = UI.getChildControl(QuestWindow.ui.favorTitle_BG, controlId)
  if 0 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE1")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_ALL")
    control = controlQuestType
  elseif 1 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE2")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_COMBAT")
    control = controlQuestType
  elseif 2 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE3")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_LIFE")
    control = controlQuestType
  elseif 3 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE4")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_FISHING")
    control = controlQuestType
  elseif 4 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE5")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_TRADE")
    control = controlQuestType
  elseif 5 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE6")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_ETC")
    control = controlQuestType
  elseif 99 == index then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FAVORTYPE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_FAVORTYPE_TOOLTIP_DESC_FAVORTYPE")
    control = QuestWindow.ui.favorTitle
  end
  TooltipSimple_Show(control, name, desc)
end
function QuestWindow:favorCheckAll()
  local isCheck = self.uiPool.questFavorType[0]:IsCheck()
  for i = 1, self.config.favorCount - 1 do
    if isCheck == not self.uiPool.questFavorType[i]:IsCheck() then
      ToClient_ToggleQuestSelectType(i)
      self.uiPool.questFavorType[i]:SetCheck(isCheck)
    end
  end
end
function QuestWindow:favorTypeUpdate()
  local allButtonCheck = true
  local QuestListInfo = ToClient_GetQuestList()
  for ii = 1, self.config.favorCount - 1 do
    local bChecked = QuestListInfo:isQuestSelectType(ii)
    self.uiPool.questFavorType[ii]:SetCheck(bChecked)
    self.uiPool.questFavorType[ii]:SetMonoTone(bChecked)
    if false == bChecked then
      self.uiPool.questFavorType[0]:SetMonoTone(true)
      allButtonCheck = false
    end
    if allButtonCheck == true then
      self.uiPool.questFavorType[ii]:SetMonoTone(false)
      self.uiPool.questFavorType[0]:SetMonoTone(false)
    elseif bChecked == true then
      self.uiPool.questFavorType[ii]:SetMonoTone(false)
    else
      self.uiPool.questFavorType[ii]:SetMonoTone(true)
    end
  end
  self.uiPool.questFavorType[0]:SetCheck(allButtonCheck)
end
function QuestWindow:nationalCheck()
  if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_RUS) then
    QuestWindow:favorCheckAll()
  end
end
function QuestWindow:ResetDataArray()
  questSortArrayRegion = {
    [QuestRegionType.eQuestRegionType_None] = {},
    [QuestRegionType.eQuestRegionType_Balenos] = {},
    [QuestRegionType.eQuestRegionType_Serendia] = {},
    [QuestRegionType.eQuestRegionType_NorthCalpheon] = {},
    [QuestRegionType.eQuestRegionType_CalpheonBigCity] = {},
    [QuestRegionType.eQuestRegionType_Keplan] = {},
    [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = {},
    [QuestRegionType.eQuestRegionType_Media] = {},
    [QuestRegionType.eQuestRegionType_Valencia] = {},
    [QuestRegionType.eQuestRegionType_Kamasylvia] = {},
    [QuestRegionType.eQuestRegionType_Drigan] = {}
  }
  questArrayRegionCount = {
    [QuestRegionType.eQuestRegionType_None] = 0,
    [QuestRegionType.eQuestRegionType_Balenos] = 0,
    [QuestRegionType.eQuestRegionType_Serendia] = 0,
    [QuestRegionType.eQuestRegionType_NorthCalpheon] = 0,
    [QuestRegionType.eQuestRegionType_CalpheonBigCity] = 0,
    [QuestRegionType.eQuestRegionType_Keplan] = 0,
    [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = 0,
    [QuestRegionType.eQuestRegionType_Media] = 0,
    [QuestRegionType.eQuestRegionType_Valencia] = 0,
    [QuestRegionType.eQuestRegionType_Kamasylvia] = 0,
    [QuestRegionType.eQuestRegionType_Drigan] = 0
  }
  questArrayRegionProgressCount = {
    [QuestRegionType.eQuestRegionType_None] = 0,
    [QuestRegionType.eQuestRegionType_Balenos] = 0,
    [QuestRegionType.eQuestRegionType_Serendia] = 0,
    [QuestRegionType.eQuestRegionType_NorthCalpheon] = 0,
    [QuestRegionType.eQuestRegionType_CalpheonBigCity] = 0,
    [QuestRegionType.eQuestRegionType_Keplan] = 0,
    [QuestRegionType.eQuestRegionType_SouthWestCalpheon] = 0,
    [QuestRegionType.eQuestRegionType_Media] = 0,
    [QuestRegionType.eQuestRegionType_Valencia] = 0,
    [QuestRegionType.eQuestRegionType_Kamasylvia] = 0,
    [QuestRegionType.eQuestRegionType_Drigan] = 0
  }
  questArrayRegionSort = {
    [0] = QuestRegionType.eQuestRegionType_Balenos,
    [1] = QuestRegionType.eQuestRegionType_Serendia,
    [2] = QuestRegionType.eQuestRegionType_NorthCalpheon,
    [3] = QuestRegionType.eQuestRegionType_CalpheonBigCity,
    [4] = QuestRegionType.eQuestRegionType_Keplan,
    [5] = QuestRegionType.eQuestRegionType_SouthWestCalpheon,
    [6] = QuestRegionType.eQuestRegionType_Media,
    [7] = QuestRegionType.eQuestRegionType_Valencia,
    [8] = QuestRegionType.eQuestRegionType_Kamasylvia,
    [9] = QuestRegionType.eQuestRegionType_Drigan,
    [10] = QuestRegionType.eQuestRegionType_None
  }
  questSortArrayType = {
    [QuestType.eQuestType_BlackSpirit] = {},
    [QuestType.eQuestType_Story] = {},
    [QuestType.eQuestType_Town] = {},
    [QuestType.eQuestType_Adventure] = {},
    [QuestType.eQuestType_Trade] = {},
    [QuestType.eQuestType_Craft] = {},
    [QuestType.eQuestType_Repetition] = {},
    [QuestType.eQuestType_Guild] = {},
    [QuestType.eQuestType_Special] = {},
    [QuestType.eQuestType_RegionMonsterKill] = {}
  }
  questArrayTypeCount = {
    [QuestType.eQuestType_BlackSpirit] = 0,
    [QuestType.eQuestType_Story] = 0,
    [QuestType.eQuestType_Town] = 0,
    [QuestType.eQuestType_Adventure] = 0,
    [QuestType.eQuestType_Trade] = 0,
    [QuestType.eQuestType_Craft] = 0,
    [QuestType.eQuestType_Repetition] = 0,
    [QuestType.eQuestType_Guild] = 0,
    [QuestType.eQuestType_Special] = 0,
    [QuestType.eQuestType_RegionMonsterKill] = 0
  }
  questArrayTypeProgressCount = {
    [QuestType.eQuestType_BlackSpirit] = 0,
    [QuestType.eQuestType_Story] = 0,
    [QuestType.eQuestType_Town] = 0,
    [QuestType.eQuestType_Adventure] = 0,
    [QuestType.eQuestType_Trade] = 0,
    [QuestType.eQuestType_Craft] = 0,
    [QuestType.eQuestType_Repetition] = 0,
    [QuestType.eQuestType_Guild] = 0,
    [QuestType.eQuestType_Special] = 0,
    [QuestType.eQuestType_RegionMonsterKill] = 0
  }
end
function QuestWindow:GetProgressingActiveTab()
  local progressingActiveTab
  if self.ui.tabProgress:IsCheck() then
    progressingActiveTab = QuestTabType.QuestTabType_Progress
  elseif self.ui.tabImportant:IsCheck() then
    progressingActiveTab = QuestTabType.QuestTabType_Recommendation
  elseif self.ui.tabRepeat:IsCheck() then
    progressingActiveTab = QuestTabType.QuestTabType_Repetition
  elseif true == _ContentsGroup_NewQuest and self.ui.tabNewQuest:IsCheck() then
    progressingActiveTab = QuestTabType.QuestTabType_New
  else
    progressingActiveTab = QuestTabType.QuestTabType_Main
  end
  return progressingActiveTab
end
function QuestWindow:MakeDataArray()
  local progressingActiveTab = QuestWindow:GetProgressingActiveTab()
  local questListInfo = ToClient_GetQuestList()
  local questGroupCount
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    questGroupCount = questListInfo:getQuestGroupCount()
  elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
    questGroupCount = questListInfo:getRecommendationQuestGroupCount()
  elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
    questGroupCount = questListInfo:getRepetitionQuestGroupCount()
  elseif QuestTabType.QuestTabType_New == progressingActiveTab then
    questGroupCount = questListInfo:getNewQuestGroupCount()
  else
    questGroupCount = questListInfo:getMainQuestGroupCount()
  end
  local progressQuestCount = 0
  for questGroupIndex = 0, questGroupCount - 1 do
    local questGroupInfo
    if QuestTabType.QuestTabType_Progress == progressingActiveTab then
      questGroupInfo = questListInfo:getQuestGroupAt(questGroupIndex)
    elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
      questGroupInfo = questListInfo:getRecommendationQuestGroupAt(questGroupIndex)
    elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
      questGroupInfo = questListInfo:getRepetitionQuestGroupAt(questGroupIndex)
    elseif QuestTabType.QuestTabType_New == progressingActiveTab then
      questGroupInfo = questListInfo:getNewQuestGroupAt(questGroupIndex)
    else
      questGroupInfo = questListInfo:getMainQuestGroupAt(questGroupIndex)
    end
    if QuestTabType.QuestTabType_Progress == progressingActiveTab then
      if true == questGroupInfo:isGroupQuest() then
        local questCount = questGroupInfo:getQuestCount()
        local startIdx = 0
        if 1 == questCount then
          local uiQuestInfo = questGroupInfo:getQuestAt(startIdx)
          local dataRegionIdx = uiQuestInfo:getQuestRegion()
          local regionIdx = questArrayRegionCount[dataRegionIdx]
          if false == uiQuestInfo:isSpecialType() and false == uiQuestInfo:isRegionMonsterKillType() then
            questSortArrayRegion[dataRegionIdx][regionIdx] = {
              questRegion = dataRegionIdx,
              questType = uiQuestInfo:getQuestType(),
              questTitle = uiQuestInfo:getTitle(),
              gruopNo = uiQuestInfo:getQuestNo()._group,
              questNo = uiQuestInfo:getQuestNo()._quest,
              posCount = uiQuestInfo:getQuestPositionCount(),
              conditionComp = uiQuestInfo:isSatisfied(),
              completeCount = 0,
              isShowWidget = questGroupInfo:isCheckShow(),
              isCleared = true,
              isNext = false,
              isGroupQuest = true,
              groupIdx = questGroupIndex,
              groupCount = questCount,
              resetTime = uiQuestInfo:getResetTime(),
              repeatTime = uiQuestInfo:getRepeatTime()
            }
            questArrayRegionCount[dataRegionIdx] = questArrayRegionCount[dataRegionIdx] + 1
            local typeIdx = questArrayTypeCount[uiQuestInfo:getQuestType()]
            questSortArrayType[uiQuestInfo:getQuestType()][typeIdx] = {
              questRegion = dataRegionIdx,
              questType = uiQuestInfo:getQuestType(),
              questTitle = uiQuestInfo:getTitle(),
              gruopNo = uiQuestInfo:getQuestNo()._group,
              questNo = uiQuestInfo:getQuestNo()._quest,
              posCount = uiQuestInfo:getQuestPositionCount(),
              conditionComp = uiQuestInfo:isSatisfied(),
              completeCount = 0,
              isShowWidget = questGroupInfo:isCheckShow(),
              isCleared = true,
              isNext = false,
              isGroupQuest = true,
              groupIdx = questGroupIndex,
              groupCount = questCount,
              resetTime = uiQuestInfo:getResetTime(),
              repeatTime = uiQuestInfo:getRepeatTime()
            }
            questArrayTypeCount[uiQuestInfo:getQuestType()] = questArrayTypeCount[uiQuestInfo:getQuestType()] + 1
          end
        elseif questCount >= 2 then
          startIdx = questCount - 2
        end
        for questIdx = startIdx, questCount - 1 do
          local uiQuestInfo = questGroupInfo:getQuestAt(questIdx)
          local dataRegionIdx = uiQuestInfo:getQuestRegion()
          if dataRegionIdx > QuestRegionType.eQuestRegionType_Drigan or dataRegionIdx < QuestRegionType.eQuestRegionType_None then
            dataRegionIdx = QuestRegionType.eQuestRegionType_None
          end
          if false == uiQuestInfo:isSpecialType() and false == uiQuestInfo:isRegionMonsterKillType() then
            local regionIdx = questArrayRegionCount[dataRegionIdx]
            questSortArrayRegion[dataRegionIdx][regionIdx] = {
              questRegion = dataRegionIdx,
              questType = uiQuestInfo:getQuestType(),
              questTitle = uiQuestInfo:getTitle(),
              gruopNo = uiQuestInfo:getQuestNo()._group,
              questNo = uiQuestInfo:getQuestNo()._quest,
              posCount = uiQuestInfo:getQuestPositionCount(),
              conditionComp = uiQuestInfo:isSatisfied(),
              completeCount = questIdx + 1,
              isShowWidget = questGroupInfo:isCheckShow(),
              isCleared = uiQuestInfo._isCleared,
              isNext = not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing,
              isGroupQuest = true,
              groupIdx = questGroupIndex,
              groupCount = questCount,
              resetTime = uiQuestInfo:getResetTime(),
              repeatTime = uiQuestInfo:getRepeatTime()
            }
            questArrayRegionCount[dataRegionIdx] = questArrayRegionCount[dataRegionIdx] + 1
            local typeIdx = questArrayTypeCount[uiQuestInfo:getQuestType()]
            questSortArrayType[uiQuestInfo:getQuestType()][typeIdx] = {
              questRegion = dataRegionIdx,
              questType = uiQuestInfo:getQuestType(),
              questTitle = uiQuestInfo:getTitle(),
              gruopNo = uiQuestInfo:getQuestNo()._group,
              questNo = uiQuestInfo:getQuestNo()._quest,
              posCount = uiQuestInfo:getQuestPositionCount(),
              conditionComp = uiQuestInfo:isSatisfied(),
              completeCount = questIdx + 1,
              isShowWidget = questGroupInfo:isCheckShow(),
              isCleared = uiQuestInfo._isCleared,
              isNext = not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing,
              isGroupQuest = true,
              groupIdx = questGroupIndex,
              groupCount = questCount,
              resetTime = uiQuestInfo:getResetTime(),
              repeatTime = uiQuestInfo:getRepeatTime()
            }
            questArrayTypeCount[uiQuestInfo:getQuestType()] = questArrayTypeCount[uiQuestInfo:getQuestType()] + 1
            if uiQuestInfo._isProgressing then
              progressQuestCount = progressQuestCount + 1
              questArrayRegionProgressCount[dataRegionIdx] = questArrayRegionProgressCount[dataRegionIdx] + 1
              questArrayTypeProgressCount[uiQuestInfo:getQuestType()] = questArrayTypeProgressCount[uiQuestInfo:getQuestType()] + 1
            end
          end
        end
      else
        local uiQuestInfo = questGroupInfo:getQuestAt(0)
        local dataRegionIdx = uiQuestInfo:getQuestRegion()
        if dataRegionIdx > QuestRegionType.eQuestRegionType_Drigan or dataRegionIdx < QuestRegionType.eQuestRegionType_None then
          dataRegionIdx = QuestRegionType.eQuestRegionType_None
        end
        if false == uiQuestInfo:isSpecialType() and false == uiQuestInfo:isRegionMonsterKillType() then
          local regionIdx = questArrayRegionCount[dataRegionIdx]
          questSortArrayRegion[dataRegionIdx][regionIdx] = {
            questRegion = dataRegionIdx,
            questType = uiQuestInfo:getQuestType(),
            questTitle = uiQuestInfo:getTitle(),
            gruopNo = uiQuestInfo:getQuestNo()._group,
            questNo = uiQuestInfo:getQuestNo()._quest,
            conditionComp = uiQuestInfo:isSatisfied(),
            completeCount = 0,
            isShowWidget = questGroupInfo:isCheckShow(),
            isCleared = uiQuestInfo._isCleared,
            isNext = false,
            isGroupQuest = false,
            groupIdx = questGroupIndex,
            groupCount = 1,
            resetTime = uiQuestInfo:getResetTime(),
            repeatTime = uiQuestInfo:getRepeatTime(),
            isSubQuest = false
          }
          questArrayRegionCount[dataRegionIdx] = questArrayRegionCount[dataRegionIdx] + 1
          local typeIdx = questArrayTypeCount[uiQuestInfo:getQuestType()]
          questSortArrayType[uiQuestInfo:getQuestType()][typeIdx] = {
            questRegion = dataRegionIdx,
            questType = uiQuestInfo:getQuestType(),
            questTitle = uiQuestInfo:getTitle(),
            gruopNo = uiQuestInfo:getQuestNo()._group,
            questNo = uiQuestInfo:getQuestNo()._quest,
            conditionComp = uiQuestInfo:isSatisfied(),
            completeCount = 0,
            isShowWidget = questGroupInfo:isCheckShow(),
            isCleared = uiQuestInfo._isCleared,
            isNext = false,
            isGroupQuest = false,
            groupIdx = questGroupIndex,
            groupCount = 1,
            resetTime = uiQuestInfo:getResetTime(),
            repeatTime = uiQuestInfo:getRepeatTime(),
            isSubQuest = false
          }
          questArrayTypeCount[uiQuestInfo:getQuestType()] = questArrayTypeCount[uiQuestInfo:getQuestType()] + 1
          if uiQuestInfo._isProgressing then
            progressQuestCount = progressQuestCount + 1
            questArrayRegionProgressCount[dataRegionIdx] = questArrayRegionProgressCount[dataRegionIdx] + 1
            questArrayTypeProgressCount[uiQuestInfo:getQuestType()] = questArrayTypeProgressCount[uiQuestInfo:getQuestType()] + 1
          end
        end
      end
    else
    end
  end
  self.ui.questCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_COUNTQUEST", "count", progressQuestCount))
  useArray = {}
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    do
      local emptyHide = self.ui.chkEmptyGroupHide:IsCheck()
      local arrayIdx = 1
      if self.ui.radioTerritoryGroup:IsCheck() then
        local regionCount = QuestRegionType.eQuestRegionType_Count - 1
        for index = 0, regionCount do
          do
            local regionIdx = questArrayRegionSort[index]
            local count = questArrayRegionCount[regionIdx]
            local function doInsertData()
              if not isContentsEnableMedia and QuestRegionType.eQuestRegionType_Media - 1 == index then
                return
              end
              if not isContentsEnableValencia and QuestRegionType.eQuestRegionType_Valencia - 1 == index then
                return
              end
              if not isContentsEnableKamasilvia and QuestRegionType.eQuestRegionType_Kamasylvia - 1 == index then
                return
              end
              if not isContentsEnableDragan and QuestRegionType.eQuestRegionType_Drigan - 1 == index then
                return
              end
              useArray[arrayIdx] = {
                isQuest = false,
                isNext = false,
                isCleared = false,
                questRegion = regionIdx,
                questType = nil,
                title = regionString[regionIdx],
                gruopNo = nil,
                questNo = nil,
                conditionComp = nil,
                isShowWidget = nil,
                groupIdx = nil,
                isGroupQuest = nil,
                groupCount = nil,
                resetTime = nil,
                repeatTime = nil,
                isSubQuest = nil
              }
              arrayIdx = arrayIdx + 1
              if regionOpen[regionIdx] and count > 0 then
                for questIdx = 0, count - 1 do
                  useArray[arrayIdx] = {
                    isQuest = true,
                    isNext = questSortArrayRegion[regionIdx][questIdx].isNext,
                    isCleared = questSortArrayRegion[regionIdx][questIdx].isCleared,
                    questRegion = questSortArrayRegion[regionIdx][questIdx].questRegion,
                    questType = questSortArrayRegion[regionIdx][questIdx].questType,
                    title = questSortArrayRegion[regionIdx][questIdx].questTitle,
                    gruopNo = questSortArrayRegion[regionIdx][questIdx].gruopNo,
                    questNo = questSortArrayRegion[regionIdx][questIdx].questNo,
                    posCount = questSortArrayRegion[regionIdx][questIdx].posCount,
                    conditionComp = questSortArrayRegion[regionIdx][questIdx].conditionComp,
                    completeCount = questSortArrayRegion[regionIdx][questIdx].completeCount,
                    isShowWidget = questSortArrayRegion[regionIdx][questIdx].isShowWidget,
                    groupIdx = questSortArrayRegion[regionIdx][questIdx].groupIdx,
                    isGroupQuest = questSortArrayRegion[regionIdx][questIdx].isGroupQuest,
                    groupCount = questSortArrayRegion[regionIdx][questIdx].groupCount,
                    resetTime = questSortArrayRegion[regionIdx][questIdx].resetTime,
                    repeatTime = questSortArrayRegion[regionIdx][questIdx].repeatTime,
                    isSubQuest = questSortArrayRegion[regionIdx][questIdx].isSubQuest
                  }
                  arrayIdx = arrayIdx + 1
                end
              end
            end
            if emptyHide then
              if count > 0 then
                doInsertData()
              end
            else
              doInsertData()
            end
          end
        end
      else
        local typeCount = questType.count - 1
        for typeIdx = 0, typeCount do
          do
            local count = questArrayTypeCount[typeIdx]
            local function doInsertData()
              useArray[arrayIdx] = {
                isQuest = false,
                isNext = false,
                isCleared = false,
                questRegion = nil,
                questType = typeIdx,
                title = typeString[typeIdx],
                gruopNo = nil,
                questNo = nil,
                conditionComp = nil,
                isShowWidget = nil,
                groupIdx = nil,
                isGroupQuest = nil,
                groupCount = nil,
                resetTime = nil,
                repeatTime = nil,
                isSubQuest = nil
              }
              arrayIdx = arrayIdx + 1
              if typeOpen[typeIdx] and count > 0 then
                for questIdx = 0, count - 1 do
                  useArray[arrayIdx] = {
                    isQuest = true,
                    isNext = questSortArrayType[typeIdx][questIdx].isNext,
                    isCleared = questSortArrayType[typeIdx][questIdx].isCleared,
                    questRegion = questSortArrayType[typeIdx][questIdx].questRegion,
                    questType = questSortArrayType[typeIdx][questIdx].questType,
                    title = questSortArrayType[typeIdx][questIdx].questTitle,
                    gruopNo = questSortArrayType[typeIdx][questIdx].gruopNo,
                    questNo = questSortArrayType[typeIdx][questIdx].questNo,
                    posCount = questSortArrayType[typeIdx][questIdx].posCount,
                    conditionComp = questSortArrayType[typeIdx][questIdx].conditionComp,
                    completeCount = questSortArrayType[typeIdx][questIdx].completeCount,
                    isShowWidget = questSortArrayType[typeIdx][questIdx].isShowWidget,
                    groupIdx = questSortArrayType[typeIdx][questIdx].groupIdx,
                    isGroupQuest = questSortArrayType[typeIdx][questIdx].isGroupQuest,
                    groupCount = questSortArrayType[typeIdx][questIdx].groupCount,
                    resetTime = questSortArrayType[typeIdx][questIdx].resetTime,
                    repeatTime = questSortArrayType[typeIdx][questIdx].repeatTime,
                    isSubQuest = questSortArrayType[typeIdx][questIdx].isSubQuest
                  }
                  arrayIdx = arrayIdx + 1
                end
              end
            end
            if emptyHide then
              if count > 0 then
                doInsertData()
              end
            else
              doInsertData()
            end
          end
        end
      end
    end
  elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
    do
      local arrayIdx = 1
      for groupIdx = 0, questGroupCount - 1 do
        do
          local questGroupInfo = questListInfo:getRecommendationQuestGroupAt(groupIdx)
          local groupTitle = questGroupInfo:getTitle()
          local questCount = questGroupInfo:getQuestCount()
          local completeHide = self.ui.hideCompBtn:IsCheck()
          local completeChkCount = 0
          local hideCount = 0
          local sumHideCount = 0
          for chkIdx = 0, questCount - 1 do
            local uiQuestInfo = questGroupInfo:getQuestAt(chkIdx)
            if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
              local isCleared = uiQuestInfo._isCleared
              if true == isCleared then
                completeChkCount = completeChkCount + 1
              end
            else
              hideCount = hideCount + 1
            end
          end
          sumHideCount = questCount - hideCount
          local function makeRecommandArray()
            questArrayGroupCount[groupIdx] = 0
            questArrayGroupCompleteCount[groupIdx] = 0
            useArray[arrayIdx] = {
              isQuest = false,
              isNext = false,
              isCleared = false,
              questRegion = arrayIdx,
              questType = 8,
              title = groupTitle,
              gruopNo = nil,
              questNo = nil,
              posCount = 0,
              conditionComp = nil,
              completeCount = 0,
              isShowWidget = nil,
              isGroupQuest = nil,
              groupIdx = groupIdx,
              groupCount = questCount,
              resetTime = nil,
              repeatTime = nil,
              isSubQuest = nil
            }
            arrayIdx = arrayIdx + 1
            local recommandCount = 0
            for questIdx = 0, questCount - 1 do
              do
                local uiQuestInfo = questGroupInfo:getQuestAt(questIdx)
                if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
                  local function setQuestData()
                    local dataRegionIdx = uiQuestInfo:getQuestRegion()
                    if dataRegionIdx > 8 or dataRegionIdx < 0 then
                      dataRegionIdx = 0
                    end
                    if recommendationGroupOpen[groupIdx] then
                      useArray[arrayIdx] = {
                        isQuest = true,
                        isNext = not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing,
                        isCleared = uiQuestInfo._isCleared,
                        questRegion = dataRegionIdx,
                        questType = uiQuestInfo:getQuestType(),
                        title = uiQuestInfo:getTitle(),
                        gruopNo = uiQuestInfo:getQuestNo()._group,
                        questNo = uiQuestInfo:getQuestNo()._quest,
                        posCount = uiQuestInfo:getQuestPositionCount(),
                        conditionComp = uiQuestInfo:isSatisfied(),
                        completeCount = 0,
                        isShowWidget = uiQuestInfo:getAcceptConditionText(),
                        isGroupQuest = true,
                        groupIdx = groupIdx,
                        groupCount = questGroupCount,
                        resetTime = uiQuestInfo:getResetTime(),
                        repeatTime = uiQuestInfo:getRepeatTime(),
                        isSubQuest = uiQuestInfo._isSubQuest
                      }
                      arrayIdx = arrayIdx + 1
                    end
                    if uiQuestInfo._isCleared then
                      questArrayGroupCompleteCount[groupIdx] = questArrayGroupCompleteCount[groupIdx] + 1
                    end
                  end
                  if true == completeHide then
                    if not uiQuestInfo._isCleared then
                      setQuestData()
                      recommandCount = recommandCount + 1
                    end
                  else
                    setQuestData()
                    recommandCount = recommandCount + 1
                  end
                end
              end
            end
            questArrayGroupCount[groupIdx] = recommandCount
          end
          if completeChkCount < sumHideCount then
            makeRecommandArray()
          elseif not completeHide and 0 ~= sumHideCount then
            makeRecommandArray()
          end
        end
      end
    end
  elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
    do
      local arrayIdx = 1
      for groupIdx = 0, questGroupCount - 1 do
        do
          local questGroupInfo = questListInfo:getRepetitionQuestGroupAt(groupIdx)
          local groupTitle = questGroupInfo:getTitle()
          local questCount = questGroupInfo:getQuestCount()
          local completeChkCount = 0
          local hideCount = 0
          local sumHideCount = 0
          for chkIdx = 0, questCount - 1 do
            local uiQuestInfo = questGroupInfo:getQuestAt(chkIdx)
            if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
              local isCleared = uiQuestInfo._isCleared
              if true == isCleared then
                completeChkCount = completeChkCount + 1
              end
            else
              hideCount = hideCount + 1
            end
          end
          sumHideCount = questCount - hideCount
          local function makeRepetitiveArray()
            questArrayGroupCount[groupIdx] = 0
            questArrayGroupCompleteCount[groupIdx] = 0
            useArray[arrayIdx] = {
              isQuest = false,
              isNext = false,
              isCleared = false,
              questRegion = arrayIdx,
              questType = 8,
              title = groupTitle,
              gruopNo = nil,
              questNo = nil,
              posCount = 0,
              conditionComp = nil,
              completeCount = 0,
              isShowWidget = nil,
              isGroupQuest = nil,
              groupIdx = groupIdx,
              groupCount = questCount,
              resetTime = nil,
              repeatTime = nil,
              isSubQuest = nil
            }
            arrayIdx = arrayIdx + 1
            local recommandCount = 0
            local completeHide = self.ui.hideCompBtn:IsCheck()
            for questIdx = 0, questCount - 1 do
              do
                local uiQuestInfo = questGroupInfo:getQuestAt(questIdx)
                if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
                  local function setQuestData()
                    local dataRegionIdx = uiQuestInfo:getQuestRegion()
                    if dataRegionIdx > 8 or dataRegionIdx < 0 then
                      dataRegionIdx = 0
                    end
                    if repetitiveQuestGroupOpen[groupIdx] then
                      local questInfoResetTime = uiQuestInfo:getResetTime()
                      local questInfoRepeatTime = uiQuestInfo:getRepeatTime()
                      local questInfoIsNext = not uiQuestInfo._isProgressing and not uiQuestInfo._isCleared
                      local questInfoTitle = uiQuestInfo:getTitle()
                      local questInfoIsCleared = uiQuestInfo._isCleared
                      if uiQuestInfo._isCleared and questInfoRepeatTime > 0 then
                        if 0 < Int64toInt32(getLeftSecond_TTime64(questInfoResetTime)) then
                          questInfoIsNext = false
                        else
                          questInfoIsCleared = false
                          questInfoIsNext = true
                        end
                      end
                      if not completeHide or questInfoRepeatTime > 0 or not questInfoIsCleared then
                        useArray[arrayIdx] = {
                          isQuest = true,
                          isNext = questInfoIsNext,
                          isCleared = questInfoIsCleared,
                          questRegion = dataRegionIdx,
                          questType = uiQuestInfo:getQuestType(),
                          title = questInfoTitle,
                          gruopNo = uiQuestInfo:getQuestNo()._group,
                          questNo = uiQuestInfo:getQuestNo()._quest,
                          posCount = uiQuestInfo:getQuestPositionCount(),
                          conditionComp = uiQuestInfo:isSatisfied(),
                          completeCount = 0,
                          isShowWidget = uiQuestInfo:getAcceptConditionText(),
                          isGroupQuest = true,
                          groupIdx = groupIdx,
                          groupCount = questGroupCount,
                          resetTime = questInfoResetTime,
                          repeatTime = questInfoRepeatTime,
                          isSubQuest = uiQuestInfo._isSubQuest
                        }
                        arrayIdx = arrayIdx + 1
                      end
                    end
                    if uiQuestInfo._isCleared then
                      questArrayGroupCompleteCount[groupIdx] = questArrayGroupCompleteCount[groupIdx] + 1
                    end
                  end
                  setQuestData()
                  recommandCount = recommandCount + 1
                end
              end
            end
            questArrayGroupCount[groupIdx] = recommandCount
          end
          if 0 ~= sumHideCount then
            makeRepetitiveArray()
          end
        end
      end
    end
  elseif QuestTabType.QuestTabType_New == progressingActiveTab then
    do
      local arrayIdx = 1
      for groupIdx = 0, questGroupCount - 1 do
        do
          local questGroupInfo = questListInfo:getNewQuestGroupAt(groupIdx)
          local groupTitle = questGroupInfo:getTitle()
          local questCount = questGroupInfo:getQuestCount()
          local completeChkCount = 0
          local hideCount = 0
          local sumHideCount = 0
          local isShowQuestFromTime = questGroupInfo:checkShowQuestFromTime()
          if true == isShowQuestFromTime then
            for chkIdx = 0, questCount - 1 do
              local uiQuestInfo = questGroupInfo:getQuestAt(chkIdx)
              if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
                local isCleared = uiQuestInfo._isCleared
                if true == isCleared then
                  completeChkCount = completeChkCount + 1
                end
              else
                hideCount = hideCount + 1
              end
            end
            sumHideCount = questCount - hideCount
            local function makeNewArray()
              questArrayGroupCount[groupIdx] = 0
              questArrayGroupCompleteCount[groupIdx] = 0
              useArray[arrayIdx] = {
                isQuest = false,
                isNext = false,
                isCleared = false,
                questRegion = arrayIdx,
                questType = 8,
                title = groupTitle,
                gruopNo = nil,
                questNo = nil,
                posCount = 0,
                conditionComp = nil,
                completeCount = 0,
                isShowWidget = nil,
                isGroupQuest = nil,
                groupIdx = groupIdx,
                groupCount = questCount,
                resetTime = nil,
                repeatTime = nil,
                isSubQuest = nil
              }
              arrayIdx = arrayIdx + 1
              local newCount = 0
              local completeHide = self.ui.hideCompBtn:IsCheck()
              for questIdx = 0, questCount - 1 do
                do
                  local uiQuestInfo = questGroupInfo:getQuestAt(questIdx)
                  if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
                    local function setQuestData()
                      local dataRegionIdx = uiQuestInfo:getQuestRegion()
                      if dataRegionIdx > 8 or dataRegionIdx < 0 then
                        dataRegionIdx = 0
                      end
                      if newQuestGroupOpen[groupIdx] then
                        local questInfoResetTime = uiQuestInfo:getResetTime()
                        local questInfoRepeatTime = uiQuestInfo:getRepeatTime()
                        local questInfoIsNext = not uiQuestInfo._isProgressing and not uiQuestInfo._isCleared
                        local questInfoTitle = uiQuestInfo:getTitle()
                        local questInfoIsCleared = uiQuestInfo._isCleared
                        if uiQuestInfo._isCleared and questInfoRepeatTime > 0 then
                          if 0 < Int64toInt32(getLeftSecond_TTime64(questInfoResetTime)) then
                            questInfoIsNext = false
                          else
                            questInfoIsCleared = false
                            questInfoIsNext = true
                          end
                        end
                        if not completeHide or questInfoRepeatTime > 0 or not questInfoIsCleared then
                          useArray[arrayIdx] = {
                            isQuest = true,
                            isNext = questInfoIsNext,
                            isCleared = questInfoIsCleared,
                            questRegion = dataRegionIdx,
                            questType = uiQuestInfo:getQuestType(),
                            title = questInfoTitle,
                            gruopNo = uiQuestInfo:getQuestNo()._group,
                            questNo = uiQuestInfo:getQuestNo()._quest,
                            posCount = uiQuestInfo:getQuestPositionCount(),
                            conditionComp = uiQuestInfo:isSatisfied(),
                            completeCount = 0,
                            isShowWidget = uiQuestInfo:getAcceptConditionText(),
                            isGroupQuest = true,
                            groupIdx = groupIdx,
                            groupCount = questGroupCount,
                            resetTime = questInfoResetTime,
                            repeatTime = questInfoRepeatTime,
                            isSubQuest = uiQuestInfo._isSubQuest
                          }
                          arrayIdx = arrayIdx + 1
                        end
                      end
                      if uiQuestInfo._isCleared then
                        questArrayGroupCompleteCount[groupIdx] = questArrayGroupCompleteCount[groupIdx] + 1
                      end
                    end
                    setQuestData()
                    newCount = newCount + 1
                  end
                end
              end
              questArrayGroupCount[groupIdx] = newCount
            end
            if 0 ~= sumHideCount then
              makeNewArray()
            end
          end
        end
      end
    end
  else
    do
      local arrayIdx = 1
      for groupIdx = 0, questGroupCount - 1 do
        do
          local questGroupInfo = questListInfo:getMainQuestGroupAt(groupIdx)
          local groupTitle = questGroupInfo:getTitle()
          local questCount = questGroupInfo:getQuestCount()
          local completeHide = self.ui.hideCompBtn:IsCheck()
          local completeChkCount = 0
          local hideCount = 0
          local sumHideCount = 0
          if true == PaGlobal_questBranch_IsLeafCleared() then
            QuestWindow.ui.questBranchBtn:SetShow(true)
          else
            QuestWindow.ui.questBranchBtn:SetShow(false)
          end
          for chkIdx = 0, questCount - 1 do
            local uiQuestInfo = questGroupInfo:getQuestAt(chkIdx)
            if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
              local isCleared = uiQuestInfo._isCleared
              if true == isCleared then
                completeChkCount = completeChkCount + 1
              end
            else
              hideCount = hideCount + 1
            end
          end
          sumHideCount = questCount - hideCount
          local function makeArray()
            questArrayGroupCount[groupIdx] = 0
            questArrayGroupCompleteCount[groupIdx] = 0
            useArray[arrayIdx] = {
              isQuest = false,
              isNext = false,
              isCleared = false,
              questRegion = arrayIdx,
              questType = 8,
              title = groupTitle,
              gruopNo = nil,
              questNo = nil,
              posCount = 0,
              conditionComp = nil,
              completeCount = 0,
              isShowWidget = nil,
              isGroupQuest = nil,
              groupIdx = groupIdx,
              groupCount = questCount,
              resetTime = nil,
              repeatTime = nil,
              isSubQuest = nil
            }
            arrayIdx = arrayIdx + 1
            local mainCount = 0
            for questIdx = 0, questCount - 1 do
              do
                local uiQuestInfo = questGroupInfo:getQuestAt(questIdx)
                if false == uiQuestInfo:checkHideCondition() and true == uiQuestInfo:checkVisibleCondition() then
                  local function setQuestData()
                    local dataRegionIdx = uiQuestInfo:getQuestRegion()
                    if dataRegionIdx > 8 or dataRegionIdx < 0 then
                      dataRegionIdx = 0
                    end
                    if mainQuestGroupOpen[groupIdx] then
                      useArray[arrayIdx] = {
                        isQuest = true,
                        isNext = not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing,
                        isCleared = uiQuestInfo._isCleared,
                        questRegion = dataRegionIdx,
                        questType = uiQuestInfo:getQuestType(),
                        title = uiQuestInfo:getTitle(),
                        gruopNo = uiQuestInfo:getQuestNo()._group,
                        questNo = uiQuestInfo:getQuestNo()._quest,
                        posCount = uiQuestInfo:getQuestPositionCount(),
                        conditionComp = uiQuestInfo:isSatisfied(),
                        completeCount = 0,
                        isShowWidget = uiQuestInfo:getAcceptConditionText(),
                        isGroupQuest = true,
                        groupIdx = groupIdx,
                        groupCount = questGroupCount,
                        resetTime = uiQuestInfo:getResetTime(),
                        repeatTime = uiQuestInfo:getRepeatTime(),
                        isSubQuest = uiQuestInfo._isSubQuest
                      }
                      arrayIdx = arrayIdx + 1
                    end
                    if uiQuestInfo._isCleared then
                      questArrayGroupCompleteCount[groupIdx] = questArrayGroupCompleteCount[groupIdx] + 1
                    end
                  end
                  if true == completeHide then
                    if not uiQuestInfo._isCleared then
                      setQuestData()
                      mainCount = mainCount + 1
                    end
                  else
                    setQuestData()
                    mainCount = mainCount + 1
                  end
                end
              end
            end
            questArrayGroupCount[groupIdx] = mainCount
          end
          if completeChkCount < sumHideCount then
            makeArray()
          elseif not completeHide and 0 ~= sumHideCount then
            makeArray()
          end
        end
      end
    end
  end
end
local beforeUiCount = 0
local spreadIndex = -1
function QuestWindow:update()
  local progressingActiveTab = QuestWindow:GetProgressingActiveTab()
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    self.ui.groupTypeBG:SetShow(true)
    self.ui.ListFilterBG:SetShow(false)
  elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
    self.ui.groupTypeBG:SetShow(false)
    self.ui.ListFilterBG:SetShow(true)
  elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
    self.ui.groupTypeBG:SetShow(false)
    self.ui.ListFilterBG:SetShow(true)
  else
    self.ui.groupTypeBG:SetShow(false)
    self.ui.ListFilterBG:SetShow(true)
  end
  QuestWindow:ResetDataArray()
  QuestWindow:MakeDataArray()
  for uiIdx = 0, self.config.slotMaxCount - 1 do
    self.uiPool.groupTitle[uiIdx].bg:SetShow(false)
    self.uiPool.listMain[uiIdx].bg:SetShow(false)
  end
  self.config.listCount = #useArray
  UIScroll.SetButtonSize(self.ui.scroll, self.config.slotMaxCount, self.config.listCount)
  local uiCount = 0
  for questIdx = QuestWindow.config.startSlotIndex, self.config.listCount do
    if uiCount > self.config.slotMaxCount - 1 then
      break
    end
    if 0 < self.config.listCount then
      local countBase = 0
      if QuestTabType.QuestTabType_Progress == progressingActiveTab then
        if not self.ui.radioTerritoryGroup:IsCheck() then
          countBase = questArrayTypeProgressCount[useArray[questIdx].questType]
        else
          countBase = questArrayRegionProgressCount[useArray[questIdx].questRegion]
        end
      else
        countBase = questArrayGroupCompleteCount[useArray[questIdx].groupIdx] .. "/" .. questArrayGroupCount[useArray[questIdx].groupIdx]
      end
      if false == useArray[questIdx].isQuest then
        self.uiPool.groupTitle[uiCount].bg:SetShow(true)
        local isOpenTypeCheck = 0
        local typeKey = 0
        local clearedQuestCnt = 0
        local totalQuestCnt = 0
        local progressRate = 0
        local iconType = 0
        self.uiPool.groupTitle[uiCount].name:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_GROUPTITLE", "title", useArray[questIdx].title, "count", countBase))
        self.uiPool.groupTitle[uiCount].bg:addInputEvent("Mouse_On", "QuestWindow_SimpleTooltip(true, " .. questIdx .. ", " .. uiCount .. ", " .. tostring(countBase) .. ")")
        self.uiPool.groupTitle[uiCount].bg:addInputEvent("Mouse_Out", "QuestWindow_SimpleTooltip()")
        local isBarExpand
        if QuestTabType.QuestTabType_Progress == progressingActiveTab then
          if self.ui.radioTerritoryGroup:IsCheck() then
            isOpenTypeCheck = 0
            typeKey = useArray[questIdx].questRegion
            clearedQuestCnt = ToClient_GetClearedQuestCountByQuestRegion(typeKey)
            totalQuestCnt = ToClient_GetTotalQuestCountByQuestRegion(typeKey)
            progressRate = clearedQuestCnt / totalQuestCnt * 100
            iconType = 8
            isBarExpand = regionOpen[typeKey]
          else
            isOpenTypeCheck = 1
            typeKey = useArray[questIdx].questType
            clearedQuestCnt = ToClient_GetClearedQuestCountByQuestType(typeKey)
            totalQuestCnt = ToClient_GetTotalQuestCountByQuestType(typeKey)
            progressRate = clearedQuestCnt / totalQuestCnt * 100
            iconType = typeKey
            isBarExpand = typeOpen[typeKey]
          end
          self.uiPool.groupTitle[uiCount].completePercent:SetShow(true)
          self.uiPool.groupTitle[uiCount].completePercent:SetText(string.format("%.2f", progressRate) .. "%")
        elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
          isOpenTypeCheck = 2
          typeKey = useArray[questIdx].groupIdx
          iconType = 8
          isBarExpand = recommendationGroupOpen[typeKey]
          self.uiPool.groupTitle[uiCount].completePercent:SetShow(false)
        elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
          isOpenTypeCheck = 3
          typeKey = useArray[questIdx].groupIdx
          iconType = 8
          isBarExpand = repetitiveQuestGroupOpen[typeKey]
          self.uiPool.groupTitle[uiCount].completePercent:SetShow(false)
        elseif QuestTabType.QuestTabType_Main == progressingActiveTab then
          isOpenTypeCheck = 4
          typeKey = useArray[questIdx].groupIdx
          iconType = 8
          isBarExpand = mainQuestGroupOpen[typeKey]
          self.uiPool.groupTitle[uiCount].completePercent:SetShow(false)
        elseif QuestTabType.QuestTabType_New == progressingActiveTab then
          isOpenTypeCheck = 5
          typeKey = useArray[questIdx].groupIdx
          iconType = 8
          isBarExpand = newQuestGroupOpen[typeKey]
          self.uiPool.groupTitle[uiCount].completePercent:SetShow(false)
        end
        FGlobal_ChangeOnTextureForDialogQuestIcon(self.uiPool.groupTitle[uiCount].typeIcon, iconType)
        local expandCheckKey = 0
        if not isBarExpand then
          expandCheckKey = 1
        end
        local textureArray = {
          [0] = {
            437,
            419,
            449,
            431
          },
          [1] = {
            437,
            406,
            449,
            418
          }
        }
        local textureArray = {
          [0] = {
            215,
            164,
            235,
            184
          },
          [1] = {
            194,
            164,
            214,
            184
          }
        }
        local expandIcon = self.uiPool.groupTitle[uiCount].expandIcon
        expandIcon:ChangeTextureInfoName("new_ui_common_forlua/default/default_buttons_03.dds")
        expandIcon:ChangeTextureInfoName("renewal/pcremaster/remaster_common_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(expandIcon, textureArray[expandCheckKey][1], textureArray[expandCheckKey][2], textureArray[expandCheckKey][3], textureArray[expandCheckKey][4])
        expandIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        expandIcon:setRenderTexture(expandIcon:getBaseTexture())
        self.uiPool.groupTitle[uiCount].bg:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_UpdateExpandBar( " .. isOpenTypeCheck .. ", " .. typeKey .. ", " .. uiCount .. " )")
      else
        self.uiPool.listMain[uiCount].bg:SetShow(true)
        self.uiPool.listMain[uiCount].showBtn:SetShow(false)
        self.uiPool.listMain[uiCount].btnAuto:SetShow(false)
        self.uiPool.listMain[uiCount].btnNavi:SetShow(false)
        self.uiPool.listMain[uiCount].btnGiveup:SetShow(false)
        self.uiPool.listMain[uiCount].btnReward:SetShow(false)
        self.uiPool.listMain[uiCount].completeCount:SetShow(false)
        self.uiPool.listMain[uiCount].name:SetIgnore(false)
        self.uiPool.listMain[uiCount].remainTime:SetIgnore(false)
        self.uiPool.listMain[uiCount].showBtn:SetCheck(false)
        self.uiPool.listMain[uiCount].showBtn:addInputEvent("Mouse_LUp", "")
        self.uiPool.listMain[uiCount].btnAuto:addInputEvent("Mouse_LUp", "")
        self.uiPool.listMain[uiCount].btnNavi:addInputEvent("Mouse_LUp", "")
        self.uiPool.listMain[uiCount].btnGiveup:addInputEvent("Mouse_LUp", "")
        self.uiPool.listMain[uiCount].btnReward:addInputEvent("Mouse_LUp", "")
        local questListInfo, questGroupInfo, isGroup, groupTotalCount
        FGlobal_ChangeOnTextureForDialogQuestIcon(self.uiPool.listMain[uiCount].typeIcon, useArray[questIdx].questType)
        if QuestTabType.QuestTabType_Progress == progressingActiveTab then
          questListInfo = ToClient_GetQuestList()
          questGroupInfo = questListInfo:getQuestGroupAt(useArray[questIdx].groupIdx)
          isGroup = questGroupInfo:isGroupQuest()
          if isGroup then
            groupTotalCount = questGroupInfo:getTotalQuestCount()
          end
        end
        self.uiPool.listMain[uiCount].remainTime:SetShow(false)
        if not useArray[questIdx].isNext then
          self.uiPool.listMain[uiCount].typeIcon:SetShow(true)
          self.uiPool.listMain[uiCount].typeIcon:SetSpanSize(40, 0)
          self.uiPool.listMain[uiCount].name:SetSpanSize(65, 0)
          if QuestTabType.QuestTabType_Progress == progressingActiveTab then
            self.uiPool.listMain[uiCount].showBtn:SetShow(true)
            self.uiPool.listMain[uiCount].showBtn:SetCheck(useArray[questIdx].isShowWidget)
            local showCheckKey = useArray[questIdx].questNo
            if isGroup then
              showCheckKey = 0
            end
            self.uiPool.listMain[uiCount].showBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_ShowCheck(" .. useArray[questIdx].gruopNo .. "," .. showCheckKey .. ")")
          end
          if useArray[questIdx].isCleared then
            local groupTitle = useArray[questIdx].title
            local stringColor = UI_color.C_FF888888
            if QuestTabType.QuestTabType_Progress == progressingActiveTab and isGroup then
              local replaceTitle = questGroupInfo:getTitle() .. "(" .. useArray[questIdx].completeCount + 1 .. "/" .. groupTotalCount .. ")"
              groupTitle = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", replaceTitle)
              stringColor = UI_color.C_FFEEBA3E
            end
            self.uiPool.listMain[uiCount].name:SetTextMode(UI_TM.eTextMode_LimitText)
            if self.uiPool.listMain[uiCount].btnReward:GetShow() then
              self.uiPool.listMain[uiCount].name:SetSize(240, 20)
            else
              self.uiPool.listMain[uiCount].name:SetSize(300, 20)
            end
            self.uiPool.listMain[uiCount].name:SetText(groupTitle)
            self.uiPool.listMain[uiCount].name:SetIgnore(false)
            self.uiPool.listMain[uiCount].name:SetFontColor(stringColor)
            if 0 < Int64toInt32(getLeftSecond_TTime64(useArray[questIdx].resetTime)) then
              self.uiPool.listMain[uiCount].remainTime:SetShow(true)
              local remainTime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTINFO_REMAINTIME", "time", convertStringFromDatetime(getLeftSecond_TTime64(useArray[questIdx].resetTime)))
              self.uiPool.listMain[uiCount].remainTime:SetText(remainTime)
            end
          else
            if questType.black == useArray[questIdx].questType then
              self.uiPool.listMain[uiCount].name:SetFontColor(4290209076)
            else
              self.uiPool.listMain[uiCount].name:SetFontColor(4287405590)
            end
            local groupTitle = useArray[questIdx].title
            if QuestTabType.QuestTabType_Progress == progressingActiveTab and isGroup then
              self.uiPool.listMain[uiCount].typeIcon:SetSpanSize(60, 0)
              self.uiPool.listMain[uiCount].name:SetSpanSize(85, 0)
              self.uiPool.listMain[uiCount].showBtn:SetShow(false)
              local beforIdx = uiCount - 1
              if beforIdx >= 0 then
                FGlobal_ChangeOnTextureForDialogQuestIcon(self.uiPool.listMain[beforIdx].typeIcon, useArray[questIdx].questType)
                self.uiPool.listMain[uiCount].typeIcon:SetShow(false)
                self.uiPool.listMain[uiCount].typeIcon:SetSpanSize(40, 0)
                self.uiPool.listMain[uiCount].name:SetSpanSize(65, 0)
              end
            end
            self.uiPool.listMain[uiCount].name:SetText(groupTitle)
            if useArray[questIdx].conditionComp then
              self.uiPool.listMain[uiCount].name:SetFontColor(UI_color.C_FFEE5555)
              self.uiPool.listMain[uiCount].name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_PROGRESS_2") .. " : " .. useArray[questIdx].title)
            end
          end
          local questInfo = questList_getQuestStatic(useArray[questIdx].gruopNo, useArray[questIdx].questNo)
          local posCount = questInfo:getQuestPositionCount()
          self.uiPool.listMain[uiCount].btnAuto:SetShow(0 ~= posCount and not useArray[questIdx].isCleared)
          self.uiPool.listMain[uiCount].btnNavi:SetShow(0 ~= posCount and not useArray[questIdx].isCleared)
          self.uiPool.listMain[uiCount].btnGiveup:SetShow(not useArray[questIdx].isCleared)
          self.uiPool.listMain[uiCount].btnReward:SetShow(not useArray[questIdx].isCleared)
          if self.uiPool.listMain[uiCount].btnReward:GetShow() then
            self.uiPool.listMain[uiCount].name:SetSize(260, 20)
          else
            self.uiPool.listMain[uiCount].name:SetSize(300, 20)
          end
        else
          self.uiPool.listMain[uiCount].showBtn:SetShow(false)
          if isGroup then
            local beforIdx = uiCount - 1
            if beforIdx >= 0 then
              self.uiPool.listMain[beforIdx].showBtn:SetShow(false)
            end
          end
          if self.uiPool.listMain[uiCount].btnReward:GetShow() then
            self.uiPool.listMain[uiCount].name:SetSize(260, 20)
          else
            self.uiPool.listMain[uiCount].name:SetSize(300, 20)
          end
          self.uiPool.listMain[uiCount].name:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_NOTACCEPTTITLE", "title", useArray[questIdx].title))
          self.uiPool.listMain[uiCount].name:SetFontColor(UI_color.C_FFEDE699)
          FGlobal_ChangeOnTextureForDialogQuestIcon(self.uiPool.listMain[uiCount].typeIcon, useArray[questIdx].questType)
          self.uiPool.listMain[uiCount].typeIcon:SetShow(true)
          if not useArray[questIdx].isSubQuest then
            self.uiPool.listMain[uiCount].typeIcon:SetSpanSize(40, 0)
            self.uiPool.listMain[uiCount].name:SetSpanSize(65, 0)
          else
            self.uiPool.listMain[uiCount].typeIcon:SetSpanSize(65, 0)
            self.uiPool.listMain[uiCount].name:SetSpanSize(90, 0)
          end
          self.uiPool.listMain[uiCount].btnAuto:SetShow(true)
          self.uiPool.listMain[uiCount].btnNavi:SetShow(true)
        end
        local questCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
        if useArray[questIdx].conditionComp then
          questCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
        elseif not useArray[questIdx].isCleared then
          if useArray[questIdx].isNext then
            questCondition = QuestConditionCheckType.eQuestConditionCheckType_NotAccept
          else
            questCondition = QuestConditionCheckType.eQuestConditionCheckType_Progress
          end
        end
        self.uiPool.listMain[uiCount].btnNavi:SetCheck(false)
        self.uiPool.listMain[uiCount].btnAuto:SetCheck(false)
        if QuestWindow.selectWay.groupID == useArray[questIdx].gruopNo and QuestWindow.selectWay.questID == useArray[questIdx].questNo then
          self.uiPool.listMain[uiCount].btnNavi:SetCheck(true)
          if QuestWindow.selectWay.isAuto then
            self.uiPool.listMain[uiCount].btnAuto:SetCheck(true)
          end
        end
        local nextCheck = 0
        if not useArray[questIdx].isNext then
          nextCheck = 1
        end
        self.uiPool.listMain[uiCount].name:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_ShowDetailInfo(  " .. useArray[questIdx].gruopNo .. ", " .. useArray[questIdx].questNo .. ", " .. questCondition .. ", " .. useArray[questIdx].groupIdx .. ", " .. nextCheck .. ", " .. tostring(useArray[questIdx].isCleared) .. " )")
        self.uiPool.listMain[uiCount].name:addInputEvent("Mouse_On", "HandleOnout_QuestWindow_ShowCondition( true, " .. questIdx .. ", " .. uiCount .. " )")
        self.uiPool.listMain[uiCount].name:addInputEvent("Mouse_Out", "HandleOnout_QuestWindow_ShowCondition( false, " .. questIdx .. ", " .. uiCount .. " )")
        if self.uiPool.listMain[uiCount].btnAuto:GetShow() then
          self.uiPool.listMain[uiCount].btnAuto:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_FindWay_Prepare( " .. useArray[questIdx].gruopNo .. ", " .. useArray[questIdx].questNo .. ", " .. questCondition .. ", true )")
          self.uiPool.listMain[uiCount].btnAuto:addInputEvent("Mouse_On", "HandleOnout_QuestWindow_ShowCondition( true, " .. questIdx .. ", " .. uiCount .. ", " .. 0 .. " )")
          self.uiPool.listMain[uiCount].btnAuto:addInputEvent("Mouse_Out", "HandleOnout_QuestWindow_ShowCondition( false, " .. questIdx .. ", " .. uiCount .. ", " .. 0 .. " )")
        end
        if self.uiPool.listMain[uiCount].btnNavi:GetShow() then
          self.uiPool.listMain[uiCount].btnNavi:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_FindWay_Prepare( " .. useArray[questIdx].gruopNo .. ", " .. useArray[questIdx].questNo .. ", " .. questCondition .. ", false )")
          self.uiPool.listMain[uiCount].btnNavi:addInputEvent("Mouse_On", "HandleOnout_QuestWindow_ShowCondition( true, " .. questIdx .. ", " .. uiCount .. ", " .. 1 .. " )")
          self.uiPool.listMain[uiCount].btnNavi:addInputEvent("Mouse_Out", "HandleOnout_QuestWindow_ShowCondition( false, " .. questIdx .. ", " .. uiCount .. ", " .. 1 .. " )")
        end
        if self.uiPool.listMain[uiCount].btnGiveup:GetShow() then
          self.uiPool.listMain[uiCount].btnGiveup:addInputEvent("Mouse_LUp", "HandleClicked_QuestWindow_QuestGiveUp(" .. useArray[questIdx].gruopNo .. "," .. useArray[questIdx].questNo .. ")")
          self.uiPool.listMain[uiCount].btnGiveup:addInputEvent("Mouse_On", "HandleOnout_QuestWindow_ShowCondition( true, " .. questIdx .. ", " .. uiCount .. ", " .. 2 .. " )")
          self.uiPool.listMain[uiCount].btnGiveup:addInputEvent("Mouse_Out", "HandleOnout_QuestWindow_ShowCondition( false, " .. questIdx .. ", " .. uiCount .. ", " .. 2 .. " )")
        end
        if self.uiPool.listMain[uiCount].btnReward:GetShow() then
          self.uiPool.listMain[uiCount].btnReward:addInputEvent("Mouse_LUp", "HandleClicked_QuestReward_Show(" .. useArray[questIdx].gruopNo .. "," .. useArray[questIdx].questNo .. ")")
          self.uiPool.listMain[uiCount].btnReward:addInputEvent("Mouse_On", "HandleOnout_QuestWindow_ShowCondition( true, " .. questIdx .. ", " .. uiCount .. ", " .. 3 .. " )")
          self.uiPool.listMain[uiCount].btnReward:addInputEvent("Mouse_Out", "HandleOnout_QuestWindow_ShowCondition( false, " .. questIdx .. ", " .. uiCount .. ", " .. 3 .. " )")
        end
      end
      uiCount = uiCount + 1
    end
  end
  QuestWindow:ResetDataArray()
  local familyQuestCount = ToClient_GetQuestClearUserBaseCount()
  local characterQuestCount = ToClient_GetQuestClearDuplicateCount()
  local totalCount = familyQuestCount + characterQuestCount
  QuestWindow.ui.questCountAll:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_NEW_FAMILYCOUNT", "totalCount", tostring(totalCount), "familyQuestCount", tostring(familyQuestCount), "characterQuestCount", tostring(characterQuestCount)))
end
function QuestWindow_UpScrollEvent()
  HandleWheel_QuestWindow(true)
end
function QuestWindow_DownScrollEvent()
  HandleWheel_QuestWindow(false)
end
function HandleClicked_QuestNew_Close()
  audioPostEvent_SystemUi(1, 1)
  Panel_Window_Quest_New:CloseUISubApp()
  QuestWindow.ui.checkPopUp:SetCheck(false)
  Panel_Window_QuestNew_Show(false)
end
function Panel_Window_QuestNew_Show(isShow)
  if Panel_Window_Quest_New:IsUISubApp() then
    return
  end
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    return
  end
  if true == isShow then
    Panel_Window_Quest_New:SetShow(true, true)
    Panel_Window_Quest_New:ComputePos()
    QuestWindow.config.startSlotIndex = 1
    QuestWindow.ui.scroll:SetControlTop()
    QuestWindow:update()
  else
    audioPostEvent_SystemUi(1, 1)
    Panel_Window_Quest_New:SetShow(false, false)
    if Panel_CheckedQuestInfo:GetShow() then
      FGlobal_QuestInfoDetail_Close()
    end
  end
  PaGlobal_TutorialManager:handleShowQuestNewWindow(isShow)
end
function Panel_Window_QuestNew_PopUp()
  if QuestWindow.ui.checkPopUp:IsCheck() then
    Panel_Window_Quest_New:OpenUISubApp()
  else
    Panel_Window_Quest_New:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function HandleClick_QuestWindow_Update()
  QuestWindow.config.startSlotIndex = 1
  QuestWindow.ui.scroll:SetControlTop()
  QuestWindow:update()
end
function HandleClicked_QuestWindow_ShowCheck(gruopNo, questNo)
  HandleClicked_QuestShowCheck(gruopNo, questNo)
end
function HandleClick_QuestWindow_UpdateExpandBar(isRegion, Idx, uiIdx)
  if 0 == isRegion then
    regionOpen[Idx] = not regionOpen[Idx]
  elseif 1 == isRegion then
    typeOpen[Idx] = not typeOpen[Idx]
  elseif 2 == isRegion then
    recommendationGroupOpen[Idx] = not recommendationGroupOpen[Idx]
  elseif 3 == isRegion then
    repetitiveQuestGroupOpen[Idx] = not repetitiveQuestGroupOpen[Idx]
  elseif 4 == isRegion then
    mainQuestGroupOpen[Idx] = not mainQuestGroupOpen[Idx]
  elseif 5 == isRegion then
    newQuestGroupOpen[Idx] = not newQuestGroupOpen[Idx]
  end
  QuestWindow:update()
end
function HandleClicked_SetQuestSelectType(gruopNo, questNo, questCondition, isAuto, selectQuestType)
  local QuestListInfo = ToClient_GetQuestList()
  QuestListInfo:setQuestSelectType(selectQuestType, true)
  FGlobal_UpdateQuestFavorType()
  HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
end
function HandleClicked_QuestWindow_SetQuestSlectType(gruopNo, questNo, questCondition, isAuto, selectQuestType)
  if selectQuestType < 0 or selectQuestType > questSelectType.etc then
    return
  end
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
  local messageboxContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_FAVORTYPE_ENABLE", "favortype", questSelectTypeString[selectQuestType])
  local function funcSetQuestSelectType()
    HandleClicked_SetQuestSelectType(gruopNo, questNo, questCondition, isAuto, selectQuestType)
  end
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxContent,
    functionYes = funcSetQuestSelectType,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClicked_QuestWindow_FindWay_Prepare(gruopNo, questNo, questCondition, isAuto)
  local QuestStatic = questList_getQuestStatic(gruopNo, questNo)
  if nil ~= QuestStatic then
    local selectQuestType = QuestStatic:getSelectType()
    if 0 ~= selectQuestType then
      local QuestListInfo = ToClient_GetQuestList()
      if false == QuestListInfo:isQuestSelectType(selectQuestType) then
        HandleClicked_QuestWindow_SetQuestSlectType(gruopNo, questNo, questCondition, isAuto, selectQuestType)
      else
        HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
      end
    else
      HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
    end
  end
end
function HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
  local QuestStatic = questList_getQuestStatic(gruopNo, questNo)
  if nil ~= QuestStatic then
    if QuestConditionCheckType.eQuestConditionCheckType_Complete == questCondition then
      if QuestStatic:isCompleteBlackSpirit() then
        QuestWindow.selectWay.groupID = ""
        QuestWindow.selectWay.questID = ""
        HandleClicked_CallBlackSpirit()
      else
        HandleClicked_QuestWidget_FindTarget(gruopNo, questNo, questCondition, isAuto)
      end
    elseif QuestConditionCheckType.eQuestConditionCheckType_NotAccept == questCondition then
      if 0 == QuestStatic:getAccecptNpc():get() then
        QuestWindow.selectWay.questID = ""
        QuestWindow.selectWay.groupID = ""
        HandleClicked_CallBlackSpirit()
      else
        HandleClicked_QuestWidget_FindTarget(gruopNo, questNo, questCondition, isAuto)
      end
    else
      HandleClicked_QuestWidget_FindTarget(gruopNo, questNo, questCondition, isAuto)
    end
  end
end
function HandleClicked_QuestWindow_ShowDetailInfo(questGroupId, questId, questCondition_Chk, groupIdx, nextChk, _isCleared)
  local progressingActiveTab = QuestWindow:GetProgressingActiveTab()
  local isProgressingActive = false
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    isProgressingActive = true
  end
  local questListInfo, questGroupInfo, isGroup, groupTitle
  local isNext = false
  local groupCount
  if 0 == nextChk then
    isNext = true
  end
  questListInfo = ToClient_GetQuestList()
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    questGroupInfo = questListInfo:getQuestGroupAt(groupIdx)
    isGroup = questGroupInfo:isGroupQuest()
    groupTitle = "nil"
    groupCount = nil
    if isGroup then
      groupCount = questGroupInfo:getTotalQuestCount()
    end
  elseif QuestTabType.QuestTabType_Recommendation == progressingActiveTab then
    questGroupInfo = questListInfo:getRecommendationQuestGroupAt(groupIdx)
    isGroup = false
    groupTitle = "nil"
    groupCount = nil
  elseif QuestTabType.QuestTabType_Repetition == progressingActiveTab then
    questGroupInfo = questListInfo:getRepetitionQuestGroupAt(groupIdx)
    isGroup = false
    groupTitle = "nil"
    groupCount = nil
  elseif QuestTabType.QuestTabType_New == progressingActiveTab then
    questGroupInfo = questListInfo:getNewQuestGroupAt(groupIdx)
    isGroup = false
    groupTitle = "nil"
    groupCount = nil
  else
    questGroupInfo = questListInfo:getMainQuestGroupAt(groupIdx)
    isGroup = false
    groupTitle = "nil"
    groupCount = nil
  end
  if isGroup then
    groupTitle = questGroupInfo:getTitle()
  end
  FGlobal_QuestInfoDetail(questGroupId, questId, questCondition_Chk, groupTitle, groupCount, false, not isProgressingActive, isNext, _isCleared)
end
function HandleClicked_QuestWindow_QuestGiveUp(groupId, questId)
  if true == PaGlobal_TutorialManager:isBeginnerTutorialQuest(groupId, questId) and true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALKEYBINDER_TUTORIALALERT"))
    return
  end
  FGlobal_PassGroupIdQuestId(groupId, questId)
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "GUILD_MESSAGEBOX_TITLE")
  local messageboxContent = PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_REAL_GIVEUP_QUESTION")
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxContent,
    functionYes = QuestWidget_QuestGiveUp_Confirm,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function HandleClicked_QuestWindow_QuestBranch(index)
  PaGlobal_questBranch_Open(index)
end
function HandleOnout_QuestWindow_ShowCondition(isShow, arrayIdx, uiIdx, buttonType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  if not QuestWindow.ui.tabProgress:IsCheck() then
    if isShow then
      local control = QuestWindow.uiPool.listMain[uiIdx].name
      local name = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_ACCEPTCONDITION")
      local desc = useArray[arrayIdx].isShowWidget
      if nil ~= buttonType then
        if 0 == buttonType then
          control = QuestWindow.uiPool.listMain[uiIdx].btnAuto
          desc = desc .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_AUTONPCNAVI_HELP")
        elseif 1 == buttonType then
          control = QuestWindow.uiPool.listMain[uiIdx].btnNavi
          desc = desc .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_NPCNAVI_HELP")
        elseif 2 == buttonType then
          control = QuestWindow.uiPool.listMain[uiIdx].btnGiveup
          desc = desc .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_GIVEUP_HELP")
        elseif 3 == buttonType then
          control = QuestWindow.uiPool.listMain[uiIdx].btnReward
          desc = desc .. [[


]] .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_REWARD_HELP")
        end
      end
      TooltipSimple_Show(control, name, desc)
    end
  elseif QuestWindow.ui.tabProgress:IsCheck() then
    local name, desc, control
    if isShow and nil ~= buttonType then
      if 0 == buttonType then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_AUTONAVI_NAME")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_AUTONAVI_DESC")
        control = QuestWindow.uiPool.listMain[uiIdx].btnNavi
      elseif 1 == buttonType then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_NAVI_NAME")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_NAVI_DESC")
        control = QuestWindow.uiPool.listMain[uiIdx].btnAuto
      elseif 2 == buttonType then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_GIVEUP_NAME")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_GIVEUP_DESC")
        control = QuestWindow.uiPool.listMain[uiIdx].btnGiveup
      elseif 3 == buttonType then
        name = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_REWARDCONFIRM_NAME")
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_REWARDCONFIRM_DESC")
        control = QuestWindow.uiPool.listMain[uiIdx].btnReward
      end
      TooltipSimple_Show(control, name, desc)
    end
  end
end
function QuestWindow_SimpleTooltip(isShow, idx, uiCount, baseCount)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = QuestWindow
  if not self.uiPool.groupTitle[uiCount].name:IsLimitText() then
    return
  end
  local progressingActiveTab = QuestWindow:GetProgressingActiveTab()
  if QuestTabType.QuestTabType_Progress == progressingActiveTab then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_GROUPTITLE", "title", useArray[idx].title, "count", questArrayGroupCompleteCount[useArray[idx].groupIdx] .. "/" .. questArrayGroupCount[useArray[idx].groupIdx])
  control = self.uiPool.groupTitle[uiCount].bg
  TooltipSimple_Show(control, name, desc)
end
function HandleWheel_QuestWindow(isScrollUp)
  QuestWindow.config.startSlotIndex = UIScroll.ScrollEvent(QuestWindow.ui.scroll, isScrollUp, QuestWindow.config.slotMaxCount, QuestWindow.config.listCount + 1, QuestWindow.config.startSlotIndex, 1)
  if QuestWindow.config.startSlotIndex < 1 then
    QuestWindow.config.startSlotIndex = 1
  end
  QuestWindow:update()
end
function FGlobal_QuestWindow_Update_FindWay(groupId, questId, isAuto)
  if QuestWindow.selectWay.groupID == groupId and QuestWindow.selectWay.questID == questId then
    QuestWindow.selectWay.groupID = ""
    QuestWindow.selectWay.questID = ""
    QuestWindow.selectWay.isAuto = false
  else
    QuestWindow.selectWay.groupID = groupId
    QuestWindow.selectWay.questID = questId
    QuestWindow.selectWay.isAuto = isAuto
  end
  if Panel_Window_Quest_New:GetShow() then
    QuestWindow:update()
  end
end
function FGlobal_QuestWindow_favorTypeUpdate()
  QuestWindow:favorTypeUpdate()
end
function FGlobal_QuestWindowGetStartPosition()
  return QuestWindow.config.startSlotIndex
end
function FGlobal_QuestWindow_Update()
  QuestWindow:update()
end
function FGlobal_QuestWindow_SetProgress()
  QuestWindow.ui.tabProgress:SetCheck(true)
  QuestWindow.ui.tabImportant:SetCheck(false)
  QuestWindow.ui.tabRepeat:SetCheck(false)
  QuestWindow.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(false)
  end
end
function FromClient_QuestWindow_Update()
  QuestWindow:update()
end
function Panel_Window_QuestNew_OnScreenResize()
  Panel_Window_Quest_New:ComputePos()
end
function Panel_Window_QuestNew_Toggle()
  Panel_Window_QuestNew_Show(not Panel_Window_Quest_New:GetShow())
end
function QuestWindow:registEventHandler()
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_QuestNew_Close()")
  self.ui.checkPopUp:addInputEvent("Mouse_LUp", "Panel_Window_QuestNew_PopUp()")
  self.ui.checkPopUp:addInputEvent("Mouse_On", "Panel_Window_QuestNew_PopUp_ShowIconToolTip(true)")
  self.ui.checkPopUp:addInputEvent("Mouse_Out", "Panel_Window_QuestNew_PopUp_ShowIconToolTip(false)")
  self.ui.btn_Question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelQuestHistory\" )")
  self.ui.btn_Question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestHistory\", \"true\")")
  self.ui.btn_Question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestHistory\", \"false\")")
  self.ui.tabProgress:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.tabImportant:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.tabRepeat:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.tabMain:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  if true == _ContentsGroup_NewQuest then
    self.ui.tabNewQuest:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  end
  self.ui.radioTerritoryGroup:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.radioTerritoryGroup:addInputEvent("Mouse_On", "PaGlobal_QuestNew_Simpletooltips(true, 0)")
  self.ui.radioTerritoryGroup:addInputEvent("Mouse_Out", "PaGlobal_QuestNew_Simpletooltips(false)")
  self.ui.radioTypeGroup:addInputEvent("Mouse_On", "PaGlobal_QuestNew_Simpletooltips(true, 1)")
  self.ui.radioTypeGroup:addInputEvent("Mouse_Out", "PaGlobal_QuestNew_Simpletooltips(false)")
  self.ui.chkEmptyGroupHide:addInputEvent("Mouse_On", "PaGlobal_QuestNew_Simpletooltips(true, 2)")
  self.ui.chkEmptyGroupHide:addInputEvent("Mouse_Out", "PaGlobal_QuestNew_Simpletooltips(false)")
  self.ui.radioTypeGroup:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.chkEmptyGroupHide:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.hideCompBtn:addInputEvent("Mouse_LUp", "HandleClick_QuestWindow_Update()")
  self.ui.contentBG:addInputEvent("Mouse_UpScroll", "HandleWheel_QuestWindow( true )")
  self.ui.contentBG:addInputEvent("Mouse_DownScroll", "HandleWheel_QuestWindow( false )")
  UIScroll.InputEvent(self.ui.scroll, "HandleWheel_QuestWindow")
end
function QuestWindow:registMessageHandler()
  registerEvent("FromClient_UpdateQuestList", "FromClient_QuestWindow_Update")
  registerEvent("onScreenResize", "Panel_Window_QuestNew_OnScreenResize")
end
function PaGlobal_QuestNew_Simpletooltips(isShow, tipType)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  local self = QuestWindow
  if 0 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FILTER_ZONE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_TERRITORY_ORDER_DESC")
    control = self.ui.radioTerritoryGroup
  elseif 1 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUEST_NEW_FILTER_QUESTTYPE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_GRUOP_ORDER_DESC")
    control = self.ui.radioTypeGroup
  elseif 2 == tipType then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_EMPTYGROUP_HIDE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_EMPTYGROUP_DESC")
    control = self.ui.chkEmptyGroupHide
  end
  TooltipSimple_Show(control, name, desc)
end
function Panel_Window_QuestNew_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local self = QuestWindow
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if self.ui.checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(self.ui.checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function Toggle_QuestInfoTabProgress_forPadEventFunc()
  QuestWindow.ui.tabProgress:SetCheck(true)
  QuestWindow.ui.tabImportant:SetCheck(false)
  QuestWindow.ui.tabRepeat:SetCheck(false)
  QuestWindow.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(false)
  end
  HandleClick_QuestWindow_Update()
end
function Toggle_QuestInfoTabMain_forPadEventFunc()
  QuestWindow.ui.tabProgress:SetCheck(false)
  QuestWindow.ui.tabImportant:SetCheck(false)
  QuestWindow.ui.tabRepeat:SetCheck(false)
  QuestWindow.ui.tabMain:SetCheck(true)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(false)
  end
  HandleClick_QuestWindow_Update()
end
function Toggle_QuestInfoTabImportant_forPadEventFunc()
  QuestWindow.ui.tabProgress:SetCheck(false)
  QuestWindow.ui.tabImportant:SetCheck(true)
  QuestWindow.ui.tabRepeat:SetCheck(false)
  QuestWindow.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(false)
  end
  HandleClick_QuestWindow_Update()
end
function Toggle_QuestInfoTabRepeat_forPadEventFunc()
  QuestWindow.ui.tabProgress:SetCheck(false)
  QuestWindow.ui.tabImportant:SetCheck(false)
  QuestWindow.ui.tabRepeat:SetCheck(true)
  QuestWindow.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(false)
  end
  HandleClick_QuestWindow_Update()
end
function Toggle_QuestInfoTabNewQuest_forPadEventFunc()
  QuestWindow.ui.tabProgress:SetCheck(false)
  QuestWindow.ui.tabImportant:SetCheck(false)
  QuestWindow.ui.tabRepeat:SetCheck(false)
  QuestWindow.ui.tabMain:SetCheck(false)
  if true == _ContentsGroup_NewQuest then
    QuestWindow.ui.tabNewQuest:SetCheck(true)
  end
  HandleClick_QuestWindow_Update()
end
QuestWindow:init()
QuestWindow:registEventHandler()
QuestWindow:registMessageHandler()
QuestWindow:nationalCheck()
QuestWindow:favorTypeUpdate()
