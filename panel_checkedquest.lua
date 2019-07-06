local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
local _static_active = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
PaGlobal_CheckedQuest = {
  _uiNormalQuestGroup = UI.getChildControl(_static_active, "Static_NormalQuestGroup"),
  _uiTransBG = UI.getChildControl(_static_active, "Static_TransBG"),
  _uiResizeButton = UI.getChildControl(_static_active, "Button_Size"),
  _uiGuideButton = UI.getChildControl(_static_active, "Button_Guide"),
  _uiGuideButton_Desc = UI.getChildControl(_static_active, "StaticText_Guide_Desc"),
  _uiGuideNumber = UI.getChildControl(_static_active, "StaticText_Number"),
  _uiHistoryButton = UI.getChildControl(_static_active, "Button_History"),
  _uiHistoryButton_Desc = UI.getChildControl(_static_active, "StaticText_Detail_Desc"),
  _uiFindGuild = UI.getChildControl(_static_active, "Button_WantGuild"),
  _uiDarkSpirit = UI.getChildControl(_static_active, "Static_DarkSpirit"),
  _uiDarkSpirit_Notice = UI.getChildControl(_static_active, "StaticText_DarkSpirit_Notice"),
  _uiNotice_NpcNavi = UI.getChildControl(_static_active, "StaticText_Notice_1"),
  _uiNotice_GiveUp = UI.getChildControl(_static_active, "StaticText_Notice_2"),
  _uiNotice_Reward = UI.getChildControl(_static_active, "StaticText_Notice_3"),
  _uiMouseOn_BG = UI.getChildControl(_static_active, "StaticText_Mouse_On"),
  _uiMouseLeft = UI.getChildControl(_static_active, "StaticText_Mouse_Left"),
  _uiMouseRight = UI.getChildControl(_static_active, "StaticText_Mouse_Right"),
  _uiMouseLeftIcon = UI.getChildControl(_static_active, "Static_Mouse_Left"),
  _uiMouseRightIcon = UI.getChildControl(_static_active, "Static_Mouse_Right"),
  _uiTooltipBG = UI.getChildControl(_static_active, "StaticText_IconHelp_BG"),
  _uifavorLineBG = UI.getChildControl(_static_active, "Static_FavorLineBG"),
  _uiHelpWidget = nil,
  _uiScrollBar = nil,
  _uiOptionButton = nil,
  _uiQuestFavorType = {},
  _guildQuest = {},
  _uiList = Array.new(),
  _giveupLimitLv = 10,
  _maxQuestListCnt = 30,
  _maxConditionCnt = 5,
  _defaultButtonSize = 18,
  _extendButtonSize = 25,
  _refUiQuestAutoNaviButton = nil,
  _refUiQuestNaviButton = nil,
  _refUiQuestTitle = nil
}
PaGlobal_CheckedQuest.nodeHelpMouseL = UI.getChildControl(PaGlobal_CheckedQuest._uiTooltipBG, "Static_Help_MouseL")
PaGlobal_CheckedQuest.nodeHelpMouseR = UI.getChildControl(PaGlobal_CheckedQuest._uiTooltipBG, "Static_Help_MouseR")
local MAX_QUEST_FAVOR_TYPE = 6
function PaGlobal_CheckedQuest:initialize()
  for ii = 0, self._maxQuestListCnt - 1 do
    local elements = {}
    elements._uiGroupBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_GroupBG", self._uiNormalQuestGroup, "uiGroupBG_" .. ii)
    elements._uiSelectBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_SelectedQuestBG", elements._uiGroupBG, "uiGroupSelectBG_" .. ii)
    elements._uiQuestTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Title", elements._uiGroupBG, "uiQuestTitle_" .. ii)
    elements._uiGroupTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_WidgetGroupTitle", elements._uiGroupBG, "uiGroupTitle_" .. ii)
    elements._uiQuestIcon = UI.createAndCopyBasePropertyControl(_static_active, "Static_Quest_Type", elements._uiGroupBG, "uiQuestIcon_" .. ii)
    elements._uiCompleteNpc = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_ClearNpc", elements._uiGroupBG, "uiCompleteNpc_" .. ii)
    elements._uiAutoNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "CheckButton_AutoNavi", elements._uiGroupBG, "uiAutoNaviBtn_" .. ii)
    elements._uiNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Navi", elements._uiGroupBG, "uiNaviBtn_" .. ii)
    elements._uiGiveupBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Giveup", elements._uiGroupBG, "uiGiveupBtn_" .. ii)
    elements._uiHideBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Hide", elements._uiGroupBG, "_uiHideBtn_" .. ii)
    elements._questNo = {_groupId = 0, _questId = 0}
    elements._uiConditions = Array.new()
    for jj = 0, self._maxConditionCnt - 1 do
      elements._uiConditions[jj] = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Demand", elements._uiGroupBG, "uiConditions_" .. ii .. "_" .. jj)
    end
    self._uiList[ii] = elements
  end
  self:createGuildQuest()
  for ii = 0, MAX_QUEST_FAVOR_TYPE - 1 do
    local controlIdNumber = ii + 1
    local controlId = "CheckButton_FavorType_" .. tostring(controlIdNumber)
    local control = UI.getChildControl(self._uiTransBG, controlId)
    control:addInputEvent("Mouse_LUp", "QuestWidget_SelectQuestFavorType(" .. ii .. ")")
    control:addInputEvent("Mouse_On", "QuestWidget_FavorTypeTooltip( true, " .. ii .. ")")
    control:addInputEvent("Mouse_Out", "QuestWidget_FavorTypeTooltip( false, " .. ii .. ")")
    control:SetShow(true)
    self._uiQuestFavorType[ii] = control
  end
  for ii = 0, MAX_QUEST_FAVOR_TYPE - 1 do
    if 0 == ii then
      self._uiQuestFavorType[ii]:SetPosX(0)
    else
      self._uiQuestFavorType[ii]:SetPosX(self._uiQuestFavorType[ii - 1]:GetPosX() + self._uiQuestFavorType[ii - 1]:GetSizeX() + 3)
    end
    self._uiQuestFavorType[ii]:SetPosY(4)
  end
  self._uiScrollBar = UI.getChildControl(self._uiNormalQuestGroup, "Scroll_CheckQuestList")
  self._uiOptionButton = UI.getChildControl(self._uiTransBG, "Button_Option")
  self._uiGuideButton_Desc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CHECKEDQUEST_GUIDEDESC"))
  self:initDefaults()
  self:subscribeEvents()
end
function FGlobal_CheckedQuestFaverTypeUpdate()
  local allButtonCheck = true
  local QuestListInfo = ToClient_GetQuestList()
  if nil == questListInfo then
    return
  end
  for index = 1, MAX_QUEST_FAVOR_TYPE - 1 do
    local checked = QuestListInfo:isQuestSelectType(index)
    self._uiQuestFavorType[index]:SetCheck(checked)
    self._uiQuestFavorType[index]:SetMonoTone(checked)
    if false == checked then
      self._uiQuestFavorType[0]:SetMonoTone(true)
      allButtonCheck = false
    end
    if true == allButtonCheck then
      self._uiQuestFavorType[index]:SetMonoTone(false)
      self._uiQuestFavorType[0]:SetMonoTone(false)
    elseif true == checked then
      self._uiQuestFavorType[index]:SetMonoTone(false)
    else
      self._uiQuestFavorType[index]:SetMonoTone(true)
    end
  end
  self._uiQuestFavorType[0]:SetCheck(allButtonCheck)
end
function PaGlobal_CheckedQuest:initDefaults()
  Panel_CheckedQuest:ActiveMouseEventEffect(true)
  Panel_CheckedQuest:SetShow(true)
  Panel_CheckedQuest:setMaskingChild(true)
  Panel_CheckedQuest:setGlassBackground(true)
  Panel_CheckedQuest:SetDragEnable(false)
  self._uiNormalQuestGroup:SetPosX(2)
  self._uiNormalQuestGroup:SetIgnore(false)
  self._uiNormalQuestGroup:SetAlpha(0)
  self._uiTransBG:SetNotAbleMasking(true)
  self._uiTransBG:SetIgnore(true)
  self._uiTransBG:SetPosX(0)
  self._uiTransBG:SetPosY(0)
  self._uiScrollBar:SetShow(false)
  self._uiScrollBar:SetControlTop()
  self._uiScrollBar:SetPosX(Panel_CheckedQuest:GetSizeX() - self._uiScrollBar:GetSizeX())
  self._uiScrollBar:GetControlButton():SetNotAbleMasking(true)
  self._uiResizeButton:SetVerticalBottom()
  self._uiResizeButton:SetNotAbleMasking(true)
  self._uiResizeButton:SetShow(false)
  self._uiResizeButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  self._uiResizeButton:SetPosX(150)
  self._uiGuideButton:SetShow(false)
  self._uiGuideButton:SetNotAbleMasking(true)
  self._uiGuideButton_Desc:SetNotAbleMasking(true)
  self._uiGuideNumber:SetNotAbleMasking(true)
  self._uiGuideButton:ActiveMouseEventEffect(true)
  self._uiGuideButton:SetCheck(false)
  self._uiGuideButton_Desc:SetShow(false)
  self._uiGuideNumber:SetShow(false)
  self._uiHistoryButton:SetShow(false)
  self._uiHistoryButton:SetNotAbleMasking(true)
  self._uiHistoryButton_Desc:SetNotAbleMasking(true)
  self._uiHistoryButton_Desc:SetShow(false)
  self._uiHistoryButton:ActiveMouseEventEffect(true)
  self._uiFindGuild:SetShow(false)
  self._uiFindGuild:SetNotAbleMasking(true)
  self._uiFindGuild:SetCheck(false)
  self._uiNotice_NpcNavi:SetAlpha(0)
  self._uiNotice_NpcNavi:SetFontAlpha(0)
  self._uiNotice_GiveUp:SetAlpha(0)
  self._uiNotice_GiveUp:SetFontAlpha(0)
  self._uiNotice_Reward:SetAlpha(0)
  self._uiNotice_Reward:SetFontAlpha(0)
  self._uiMouseOn_BG:SetShow(false)
  self._uiMouseLeft:SetShow(false)
  self._uiMouseRight:SetShow(false)
  self._uiMouseLeftIcon:SetShow(false)
  self._uiMouseRightIcon:SetShow(false)
  self._uiHelpWidget = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CheckedQuest, "HelpWindow_For_QuestWidget")
  CopyBaseProperty(self._uiNotice_NpcNavi, self._uiHelpWidget)
  self._uiHelpWidget:SetColor(UI_color.C_FFFFFFFF)
  self._uiHelpWidget:SetAlpha(1)
  self._uiHelpWidget:SetFontColor(UI_color.C_FFC4BEBE)
  self._uiHelpWidget:SetAutoResize(true)
  self._uiHelpWidget:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._uiHelpWidget:SetShow(false)
  self._uiHelpWidget:SetNotAbleMasking(true)
  self._uifavorLineBG:SetShow(false)
  for ii = 0, self._maxQuestListCnt - 1 do
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiAutoNaviBtn, 9999)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiNaviBtn, 9999)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiGiveupBtn, 9999)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiHideBtn, 9999)
  end
end
function PaGlobal_CheckedQuest:subscribeEvents()
  Panel_CheckedQuest:RegisterShowEventFunc(true, "QuestListShowAni()")
  Panel_CheckedQuest:RegisterShowEventFunc(false, "QuestListHideAni()")
  Panel_CheckedQuest:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
  Panel_CheckedQuest:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
  Panel_CheckedQuest:addInputEvent("Mouse_LUp", "ResetPos_WidgetButton()")
  Panel_CheckedQuest:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  Panel_CheckedQuest:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._uiTransBG:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
  self._uiTransBG:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
  self._uiNormalQuestGroup:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
  self._uiNormalQuestGroup:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
  self._uiNormalQuestGroup:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  self._uiNormalQuestGroup:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._uiScrollBar:addInputEvent("Mouse_LPress", "QuestWidget_ScrollLPress()")
  self._uiScrollBar:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
  self._uiScrollBar:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
  self._uiScrollBar:GetControlButton():addInputEvent("Mouse_LPress", "QuestWidget_ScrollLPress()")
  self._uiResizeButton:addInputEvent("Mouse_LPress", "HandleClicked_QuestWidgetPanelResize()")
  self._uiResizeButton:addInputEvent("Mouse_LDown", "HandleClicked_QuestWidgetPanelSize()")
  self._uiResizeButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidgetSaveResize()")
  self._uiResizeButton:addInputEvent("Mouse_On", "HandleOn_QuestWidgetPanelResize( true )")
  self._uiResizeButton:addInputEvent("Mouse_Out", "HandleOn_QuestWidgetPanelResize( false )")
  self._uiGuideButton:addInputEvent("Mouse_On", "HandleClicked_QuestWidget_GuideQuest_MouseOver( true )")
  self._uiGuideButton:addInputEvent("Mouse_Out", "HandleClicked_QuestWidget_GuideQuest_MouseOver( false )")
  self._uiGuideButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_GuideQuest()")
  self._uiHistoryButton:addInputEvent("Mouse_On", "HandleClicked_QuestNew_MouseOver( true )")
  self._uiHistoryButton:addInputEvent("Mouse_Out", "HandleClicked_QuestNew_MouseOver( false )")
  self._uiHistoryButton:addInputEvent("Mouse_LUp", "FGlobal_WindowQuestToggle()")
  self._uiFindGuild:addInputEvent("Mouse_On", "HandleOn_CheckedQuest_WantJoinGuild( true )")
  self._uiFindGuild:addInputEvent("Mouse_Out", "HandleOn_CheckedQuest_WantJoinGuild( false )")
  self._uiFindGuild:addInputEvent("Mouse_LUp", "HandleClieked_CheckedQuest_WantJoinGuild()")
  self._uiOptionButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_OptionButton()")
  self._uiOptionButton:addInputEvent("Mouse_On", "ShowTooltip_QuestWidget_OptionButton()")
  self._uiOptionButton:addInputEvent("Mouse_Out", "HideTooltip_QuestWidget_OptionButton()")
end
function PaGlobal_CheckedQuest:createGuildQuest()
  self._guildQuest._ControlBG = UI.getChildControl(_static_active, "GuildQuest_Static_BG")
  self._guildQuest._Title = UI.getChildControl(_static_active, "GuildQuest_StaticText_Title")
  self._guildQuest._AutoNavi = UI.getChildControl(_static_active, "GuildQuest_CheckButton_AutoNavi")
  self._guildQuest._Navi = UI.getChildControl(_static_active, "GuildQuest_Checkbox_Quest_Navi")
  self._guildQuest._Reward = UI.getChildControl(_static_active, "GuildQuest_Checkbox_Quest_Reward")
  self._guildQuest._Giveup = UI.getChildControl(_static_active, "GuildQuest_Checkbox_Quest_Giveup")
  self._guildQuest._LimitTime = UI.getChildControl(_static_active, "GuildQuest_StaticText_LimitTime")
  self._guildQuest._Condition = {
    UI.getChildControl(_static_active, "GuildQuest_StaticText_Condition1"),
    UI.getChildControl(_static_active, "GuildQuest_StaticText_Condition2"),
    UI.getChildControl(_static_active, "GuildQuest_StaticText_Condition3"),
    UI.getChildControl(_static_active, "GuildQuest_StaticText_Condition4"),
    UI.getChildControl(_static_active, "GuildQuest_StaticText_Condition5")
  }
  self._uiNormalQuestGroup:AddChild(self._guildQuest._ControlBG)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Title)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._AutoNavi)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Navi)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Reward)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Giveup)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._LimitTime)
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Condition[1])
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Condition[2])
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Condition[3])
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Condition[4])
  self._guildQuest._ControlBG:AddChild(self._guildQuest._Condition[5])
  _static_active:RemoveControl(self._guildQuest._ControlBG)
  _static_active:RemoveControl(self._guildQuest._Title)
  _static_active:RemoveControl(self._guildQuest._AutoNavi)
  _static_active:RemoveControl(self._guildQuest._Navi)
  _static_active:RemoveControl(self._guildQuest._Reward)
  _static_active:RemoveControl(self._guildQuest._Giveup)
  _static_active:RemoveControl(self._guildQuest._LimitTime)
  _static_active:RemoveControl(self._guildQuest._Condition[1])
  _static_active:RemoveControl(self._guildQuest._Condition[2])
  _static_active:RemoveControl(self._guildQuest._Condition[3])
  _static_active:RemoveControl(self._guildQuest._Condition[4])
  _static_active:RemoveControl(self._guildQuest._Condition[5])
  self._guildQuest._ControlBG:SetShow(false)
  self._guildQuest._ControlBG:SetAlpha(0)
  for idx = 1, 5 do
    self._guildQuest._Condition[idx]:SetShow(false)
    self._guildQuest._Condition[idx]:SetAutoResize(true)
    self._guildQuest._Condition[idx]:SetTextMode(UI_TM.eTextMode_AutoWrap)
    self._guildQuest._Title:SetFontColor(4293712127)
    self._guildQuest._Title:useGlowFont(true, "BaseFont_10_Glow", 4283243897)
  end
  self._guildQuest._ControlBG:addInputEvent("Mouse_On", "guildQuestWidget_MouseOn( true )")
  self._guildQuest._ControlBG:addInputEvent("Mouse_Out", "guildQuestWidget_MouseOn( false )")
  self._guildQuest._Reward:addInputEvent("Mouse_LUp", "HandleCliekedGuildQuestReward()")
  self._guildQuest._Giveup:addInputEvent("Mouse_LUp", "HandleClieked_GuildQuestWidget_Giveup()")
  self._guildQuest._Title:ComputePos()
  self._guildQuest._AutoNavi:ComputePos()
  self._guildQuest._Navi:ComputePos()
  self._guildQuest._Reward:ComputePos()
  self._guildQuest._Giveup:ComputePos()
  self._guildQuest._LimitTime:ComputePos()
  self._guildQuest._Condition[1]:ComputePos()
  self._guildQuest._Condition[2]:ComputePos()
  self._guildQuest._Condition[3]:ComputePos()
  self._guildQuest._Condition[4]:ComputePos()
  self._guildQuest._Condition[5]:ComputePos()
end
PaGlobal_CheckedQuest:initialize()
function PaGlobal_CheckedQuest:clear()
  for ii = 0, self._maxQuestListCnt - 1 do
    local uiElem = self._uiList[ii]
    uiElem._uiGroupBG:SetShow(false)
    uiElem._uiSelectBG:SetShow(false)
    uiElem._uiQuestTitle:SetShow(false)
    uiElem._uiGroupTitle:SetShow(false)
    uiElem._uiQuestIcon:SetShow(false)
    uiElem._uiAutoNaviBtn:SetShow(false)
    uiElem._uiNaviBtn:SetShow(false)
    uiElem._uiGiveupBtn:SetShow(false)
    uiElem._uiHideBtn:SetShow(false)
    uiElem._uiCompleteNpc:SetShow(false)
    uiElem._questNo._groupId = 0
    uiElem._questNo._questId = 0
    for jj = 0, self._maxConditionCnt - 1 do
      uiElem._uiConditions[jj]:SetShow(false)
    end
  end
  self._uiHelpWidget:SetShow(false)
  _shownListCount = 0
end
local UIRect = {
  left,
  top,
  right,
  bottom
}
function PaGlobalFunc_Quest_UpdatePosition()
  PaGlobal_CheckedQuest:checkPosition()
end
function PaGlobal_CheckedQuest:checkPosition()
  local Rect1 = {}
  local Rect2 = {}
  Rect1.left = Panel_MainQuest:GetPosX()
  Rect1.top = Panel_MainQuest:GetPosY()
  Rect1.right = Rect1.left + Panel_MainQuest:GetSizeX()
  Rect1.bottom = Rect1.top + Panel_MainQuest:GetSizeY()
  Rect2.left = Panel_CheckedQuest:GetPosX()
  Rect2.top = Panel_CheckedQuest:GetPosY()
  Rect2.right = Rect2.left + Panel_CheckedQuest:GetSizeX()
  Rect2.bottom = Rect2.top + Panel_CheckedQuest:GetSizeY()
  Panel_CheckedQuest:SetPosY(Rect1.bottom + 5)
end
function PaGlobal_CheckedQuest:findShownQuestUiInCheckedQuest(questGroupNo, questId)
  local shownIndex = -1
  shownIndex = PaGlobal_LatestQuest:findShownIndexInLatestQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return {
      PaGlobal_LatestQuest,
      PaGlobal_LatestQuest._uiList[shownIndex]
    }
  end
  shownIndex = PaGlobal_CheckedQuest:findShownIndexInCheckedQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return {
      PaGlobal_CheckedQuest,
      PaGlobal_CheckedQuest._uiList[shownIndex]
    }
  end
  return nil
end
function PaGlobal_CheckedQuest:findShownQuestUiInCheckedQuestIndex(questGroupNo, questId)
  local shownIndex = -1
  shownIndex = PaGlobal_LatestQuest:findShownIndexInLatestQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return shownIndex
  end
  shownIndex = PaGlobal_CheckedQuest:findShownIndexInCheckedQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return shownIndex
  end
  return nil
end
function PaGlobal_CheckedQuest:findShownIndexInCheckedQuest(questGroupNo, questId)
  local checkedQuestIndex = self:findQuestUiIndexInCheckedQuest(questGroupNo, questId)
  if -1 == checkedQuestIndex then
    return -1
  end
  local startIndex = FGlobal_QuestWidgetGetStartPosition()
  local endIndex = PaGlobal_CheckedQuest:getLastShownGroupIndex()
  local isShown = checkedQuestIndex >= startIndex and checkedQuestIndex <= endIndex and -1 ~= endIndex
  if true == isShown then
    return checkedQuestIndex
  end
  return -1
end
function PaGlobal_CheckedQuest:isExistProgressingQuestInCheckedGroup(checkedQuestGroupInfo)
  if false == checkedQuestGroupInfo:isGroupQuest() then
    return true
  end
  local questCount = checkedQuestGroupInfo:getQuestCount()
  for index = 0, questCount - 1 do
    local questInfo = checkedQuestGroupInfo:getQuestAt(index)
    if true == questInfo._isProgressing and false == questInfo._isCleared then
      return true
    end
  end
  return false
end
function PaGlobal_CheckedQuest:addEffectQuestFindNaviButtonForTutorial(questUiInfoInPanelCheckedQuest)
  if nil ~= questUiInfoInPanelCheckedQuest[2] then
    self._refUiQuestNaviButton = questUiInfoInPanelCheckedQuest[2]._uiNaviBtn
    self._refUiQuestTitle = questUiInfoInPanelCheckedQuest[2]._uiQuestTitle
    local groupBG = questUiInfoInPanelCheckedQuest[2]._uiGroupBG
    if nil ~= self._refUiQuestNaviButton then
      self._refUiQuestNaviButton:AddEffect("fUI_Alarm01", true, 0, 0)
      self._refUiQuestTitle:AddEffect("UI_QustAccept01", true, 0, 0)
    end
    local uiQuestGroup
    if questUiInfoInPanelCheckedQuest[1] == PaGlobal_CheckedQuest then
      uiQuestGroup = PaGlobal_CheckedQuest._uiNormalQuestGroup
    elseif questUiInfoInPanelCheckedQuest[1] == PaGlobal_LatestQuest then
      uiQuestGroup = PaGlobal_LatestQuest._uiLatestGroup
    end
    if nil == uiQuestGroup or nil == groupBG or nil == self._refUiQuestNaviButton then
      _PA_ASSERT(false, "\237\128\152\236\138\164\237\138\184 \236\156\132\236\160\175 \235\167\136\236\138\164\237\130\185 \236\160\129\236\154\169 \236\139\164\237\140\168. nil\234\176\146\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
      return
    end
    local posX = uiQuestGroup:GetPosX() + groupBG:GetPosX() + self._refUiQuestNaviButton:GetPosX()
    local posY = uiQuestGroup:GetPosY() + groupBG:GetPosY() + self._refUiQuestNaviButton:GetPosY()
    PaGlobal_TutorialUiManager:getUiMasking():showQuestMasking(posX, posY)
  else
    PaGlobal_TutorialUiManager:getUiMasking():showPanelMasking(Panel_CheckedQuest)
  end
end
function PaGlobal_CheckedQuest:eraseEffectQuestNaviButtonForTutorial()
  if nil ~= self._refUiQuestNaviButton then
    self._refUiQuestNaviButton:EraseAllEffect()
    self._refUiQuestTitle:EraseAllEffect()
    self._refUiQuestNaviButton = nil
    self._refUiQuestTitle = nil
  end
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function PaGlobal_CheckedQuest:findQuestUiIndexInCheckedQuest(questGruopNo, questId)
  for ii = 0, self._maxQuestListCnt - 1 do
    local questNo = self._uiList[ii]._questNo
    if questNo._groupId == questGruopNo and questNo._questId == questId then
      return ii
    end
  end
  return -1
end
function FGlobal_CheckedQuestGetQuestUiButtonPosition(questGroupNo, questId)
  local index = PaGlobal_CheckedQuest:findShownQuestUiInCheckedQuestIndex(questGroupNo, questId)
  if -1 == index then
    return -1
  end
  return index
end
function HandleClicked_QuestWidget_OptionButton()
  FGlobal_CheckedQuestOptionOpen()
end
function ShowTooltip_QuestWidget_OptionButton()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_OPTIONBUTTON_TOOLTIPTITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_OPTIONBUTTON_TOOLTIPDESC")
  TooltipSimple_Show(PaGlobal_CheckedQuest._uiOptionButton, name, desc)
end
function HideTooltip_QuestWidget_OptionButton()
  TooltipSimple_Hide()
end
function QuestWidget_SelectQuestFavorType(selectType)
  if 20 <= getSelfPlayer():get():getLevel() then
    if 0 == selectType then
      _update_QuestWidgetSetCheckAll()
    else
      ToClient_ToggleQuestSelectType(selectType)
    end
    FGlobal_UpdateQuestFavorType()
  else
    PaGlobal_CheckedQuest._uiQuestFavorType[1]:SetCheck(true)
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_FAVORITETYPE_ALERT"))
  end
end
function LvFivty_SetQuestFavorateType()
  if 50 ~= getSelfPlayer():get():getLevel() then
    return
  end
  if PaGlobal_CheckedQuest._uiQuestFavorType[5]:IsCheck() then
    return
  end
  ToClient_ToggleQuestSelectType(5)
  FGlobal_UpdateQuestFavorType()
end
registerEvent("ToClient_SelfPlayerLevelUp", "LvFivty_SetQuestFavorateType")
function QuestWidget_FavorTypeTooltip(isShow, buttonNo)
  local control, name, desc
  if true == isShow then
    control = PaGlobal_CheckedQuest._uiQuestFavorType[buttonNo]
    if 0 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ALL_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ALL_DESC")
    elseif 1 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_COMBAT_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_COMBAT_DESC")
    elseif 2 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_LIFE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_LIFE_DESC")
    elseif 3 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_FISH_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_FISH_DESC")
    elseif 4 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_TRADE_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_TRADE_DESC")
    elseif 5 == buttonNo then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ETC_NAME")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_TOOLTIP_QUESTTYPE_ETC_DESC")
    end
    TooltipSimple_Show(control, name, desc)
  else
    FGlobal_QuestWidget_MouseOver(false)
    TooltipSimple_Hide()
  end
end
function QuestWidget_ShowSelectQuestFavorType(selectType)
  if 0 == selectType then
    local QuestListInfo = ToClient_GetQuestList()
    for ii = 0, MAX_QUEST_FAVOR_TYPE - 1 do
      QuestListInfo:setQuestSelectType(ii, true)
      PaGlobal_CheckedQuest._uiQuestFavorType[ii]:SetCheck(true)
    end
  else
    local QuestListInfo = ToClient_GetQuestList()
    for ii = 0, MAX_QUEST_FAVOR_TYPE - 1 do
      if ii == selectType then
        QuestListInfo:setQuestSelectType(ii, true)
        PaGlobal_CheckedQuest._uiQuestFavorType[ii]:SetCheck(true)
      else
        QuestListInfo:setQuestSelectType(ii, false)
        PaGlobal_CheckedQuest._uiQuestFavorType[ii]:SetCheck(false)
      end
    end
    QuestListInfo:setQuestSelectType(0, true)
  end
  FGlobal_UpdateQuestFavorType()
end
function _update_QuestWidgetSetCheckAll()
  local isCheck = PaGlobal_CheckedQuest._uiQuestFavorType[0]:IsCheck()
  for i = 1, MAX_QUEST_FAVOR_TYPE - 1 do
    if isCheck == not PaGlobal_CheckedQuest._uiQuestFavorType[i]:IsCheck() then
      ToClient_ToggleQuestSelectType(i)
      PaGlobal_CheckedQuest._uiQuestFavorType[i]:SetCheck(isCheck)
    end
  end
end
function PaGlobal_CheckedQuest:updateFavorType()
  if isLuaLoadingComplete then
    if false == _ContentsGroup_RenewUI then
      FGlobal_QuestWindow_favorTypeUpdate()
    else
      FGlobal_CheckedQuestFaverTypeUpdate()
    end
  end
  self:updateQuestWidgetFavorType()
end
function FGlobal_UpdateQuestFavorType()
  if false == _ContentsGroup_RenewUI then
    FGlobal_QuestWindow_favorTypeUpdate()
  else
    FGlobal_CheckedQuestFaverTypeUpdate()
  end
  PaGlobal_CheckedQuest:updateQuestWidgetFavorType()
  if false == _ContentsGroup_RenewUI and false == _ContentsGroup_RemasterUI_Main_Alert then
    UIMain_QuestUpdate()
  end
end
function PaGlobal_CheckedQuest:updateQuestWidgetFavorType()
  local allButtonCheck = true
  local QuestListInfo = ToClient_GetQuestList()
  for ii = 1, MAX_QUEST_FAVOR_TYPE - 1 do
    local bChecked = QuestListInfo:isQuestSelectType(ii)
    self._uiQuestFavorType[ii]:SetCheck(bChecked)
    self._uiQuestFavorType[ii]:SetMonoTone(bChecked)
    if false == bChecked then
      self._uiQuestFavorType[0]:SetMonoTone(true)
      allButtonCheck = false
    end
    if allButtonCheck == true then
      self._uiQuestFavorType[ii]:SetMonoTone(false)
      self._uiQuestFavorType[0]:SetMonoTone(false)
    elseif bChecked == true then
      self._uiQuestFavorType[ii]:SetMonoTone(false)
    else
      self._uiQuestFavorType[ii]:SetMonoTone(true)
    end
  end
  self._uiQuestFavorType[0]:SetCheck(allButtonCheck)
end
function checkedquestIcon(favorIndex)
  ToClient_ToggleQuestSelectType(favorIndex)
end
function QuestWidget_NationalCheck()
  if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_RUS) then
    _update_QuestWidgetSetCheckAll()
  end
end
local battleTutorial = {
  {groupKey = 1017, questKey = 1},
  {groupKey = 1025, questKey = 1},
  {groupKey = 1029, questKey = 1},
  {groupKey = 1021, questKey = 1},
  {groupKey = 1033, questKey = 1},
  {groupKey = 1037, questKey = 1}
}
local widgetMouseOn = false
function HandleClieked_GuildQuestWidget_Giveup()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  if not isGuildMaster and not isGuildSubMaster then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_GUILDQUEST_GIVEUP"))
    return
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_0"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_GIVERUP_MESSAGE_1"),
    functionYes = ToClient_RequestGuildQuestGiveup,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FindGuild_Button_Simpletooltips(isShow)
  local name, desc, control
  if isShow == true then
    control = UI.getChildControl(_static_active, "Button_WantGuild")
    name = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_SIMPLE_TOOLTIP_FINDGUILD_TITLE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_SIMPLE_TOOLTIP_FINDGUILD_DESC")
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function checkedQuestPanel_Init()
  local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
  if not haveServerPosotion then
    local newEquipGap = 0
    local posY = 0
    if true == Panel_NewEquip:GetShow() then
      newEquipGap = Panel_NewEquip:GetSizeY() + 15
    end
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 40 + newEquipGap)
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
    PaGlobal_CheckedQuest._uiResizeButton:SetPosY(Panel_CheckedQuest:GetSizeY())
    PaGlobal_CheckedQuest._uiGuideButton:SetPosY(Panel_CheckedQuest:GetSizeY())
    PaGlobal_CheckedQuest._uiHistoryButton:SetPosY(Panel_CheckedQuest:GetSizeY())
    PaGlobal_CheckedQuest._uiFindGuild:SetPosY(Panel_CheckedQuest:GetSizeY())
  end
end
checkedQuestPanel_Init()
changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, true, true, true)
local CheckedQuest_SizeY = Panel_CheckedQuest:GetSizeY()
local _startPosition = 0
local _setLastQuestOfList = 0
local _questGroupCount = 0
local _nextPosY = 0
local _list_Space = 10
local _isDontDownScroll = false
local _scrollBarStartPosition = 20
local _shownListCount = 0
local _questGroupId = 0
local _questId = 0
local _naviInfoAgain = false
local _guideQuestChechk = false
local _hasGuildQuest = false
local _positionList = {}
local _isAutoRun = false
local _autoNaviGuide = {groupKey = 0, questKey = 0}
function QuestListShowAni()
  Panel_CheckedQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_IN)
  local QuestListOpen_Alpha = Panel_CheckedQuest:addColorAnimation(0, 0.35, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuestListOpen_Alpha:SetStartColor(UI_color.C_00FFFFFF)
  QuestListOpen_Alpha:SetEndColor(UI_color.C_FFFFFFFF)
  QuestListOpen_Alpha.IsChangeChild = true
end
function QuestListHideAni()
  Panel_CheckedQuest:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local QuestListClose_Alpha = Panel_CheckedQuest:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  QuestListClose_Alpha:SetStartColor(UI_color.C_FFFFFFFF)
  QuestListClose_Alpha:SetEndColor(UI_color.C_00FFFFFF)
  QuestListClose_Alpha.IsChangeChild = true
  QuestListClose_Alpha:SetHideAtEnd(true)
  QuestListClose_Alpha:SetDisableWhileAni(true)
end
function QuestWidget_ScrollEvent(UpDown)
  if true == _ContentsGroup_RenewUI then
    return
  end
  local prevPos = _startPosition
  if true == UpDown then
    if true == _isDontDownScroll then
      return
    end
    _startPosition = _startPosition + 1
  else
    if _startPosition <= 0 then
      return
    end
    _startPosition = _startPosition - 1
  end
  if prevPos ~= _startPosition then
    PaGlobal_CheckedQuest:updateQuestList(_startPosition)
    PaGlobal_CheckedQuest:updateScrollPosition()
  end
  PaGlobal_TutorialManager:handleQuestWidgetScrollEvent(UpDown)
end
local _maxscrollBarPos = 0
function QuestWidget_ScrollLPress()
  if true == _ContentsGroup_RenewUI then
    return
  end
  local prevPos = _startPosition
  local totalCount = PaGlobal_CheckedQuest:getTotalListCount()
  local currentPos = math.floor(PaGlobal_CheckedQuest._uiScrollBar:GetControlPos() * (totalCount - 1) + 0.5)
  if prevPos ~= currentPos then
    if prevPos < _startPosition and _isDontDownScroll then
      return
    end
    _startPosition = currentPos
    PaGlobal_CheckedQuest:updateQuestList(_startPosition)
  end
end
function PaGlobal_CheckedQuest:updateScrollButtonSize()
  local pageSize = self._uiTransBG:GetSizeY() - self._uiNormalQuestGroup:GetPosY()
  if 0 == _startPosition and pageSize > self._uiNormalQuestGroup:GetSizeY() then
    self._uiScrollBar:SetShow(false)
  elseif true == widgetMouseOn then
    self._uiScrollBar:SetShow(true)
  end
  self._uiScrollBar:SetSize(self._uiScrollBar:GetSizeX(), pageSize)
  if true == _hasGuildQuest then
    defaultGap = 90
  else
    defaultGap = 60
  end
  local totalCount = self:getTotalListCount()
  local scrollButtonSizePercent = pageSize / defaultGap / totalCount * 100
  if scrollButtonSizePercent < 10 then
    scrollButtonSizePercent = 10
  elseif scrollButtonSizePercent > 99 then
    scrollButtonSizePercent = 99
  end
  local button_sizeY = self._uiScrollBar:GetSizeY() / 100 * scrollButtonSizePercent
  if button_sizeY < 25 then
    button_sizeY = 25
  elseif pageSize < button_sizeY then
    button_sizeY = pageSize
  end
  self._uiScrollBar:GetControlButton():SetSize(self._uiScrollBar:GetControlButton():GetSizeX(), button_sizeY)
end
function PaGlobal_CheckedQuest:isAlreadyShown(questNo)
  return PaGlobal_LatestQuest:isShownQuest(questNo) or PaGlobal_MainQuest:isShownQuest(questNo)
end
function PaGlobal_CheckedQuest:getTotalListCount()
  local totalCount = 0
  local questListInfo = ToClient_GetQuestList()
  local questGroupCount = questListInfo:getQuestCheckedGroupCount()
  for Index = 0, questGroupCount - 1 do
    local questGroupInfo = questListInfo:getQuestCheckedGroupAt(Index)
    if nil == questGroupInfo then
      return
    end
    if true == questGroupInfo:isGroupQuest() then
      for questIndex = 0, questGroupInfo:getQuestCount() - 1 do
        local uiQuestInfo = questGroupInfo:getQuestAt(questIndex)
        local isAlreadyShown = self:isAlreadyShown(uiQuestInfo:getQuestNo())
        if false == isAlreadyShown then
          totalCount = totalCount + 1
        end
      end
    else
      local uiQuestInfo = questGroupInfo:getQuestAt(0)
      local isAlreadyShown = self:isAlreadyShown(uiQuestInfo:getQuestNo())
      if false == isAlreadyShown then
        totalCount = totalCount + 1
      end
    end
  end
  return totalCount
end
function PaGlobal_CheckedQuest:updateScrollPosition()
  local totalListCount = self:getTotalListCount()
  local posY = self._uiScrollBar:GetSizeY() * (_startPosition / totalListCount)
  local maxPosY = self._uiScrollBar:GetSizeY() - self._uiScrollBar:GetControlButton():GetSizeY()
  if posY > maxPosY then
    self._uiScrollBar:GetControlButton():SetPosY(maxPosY)
  else
    self._uiScrollBar:GetControlButton():SetPosY(posY)
  end
end
function PaGlobal_CheckedQuest:checkShowScrollbar()
  local scrollSizeY = self._uiTransBG:GetSizeY() - self._uiNormalQuestGroup:GetPosY()
  if 0 == _startPosition and scrollSizeY > self._uiNormalQuestGroup:GetSizeY() then
    self._uiScrollBar:SetShow(false)
  elseif true == widgetMouseOn then
    self._uiScrollBar:SetShow(true)
  end
end
function PaGlobal_CheckedQuest:getScollPageSize()
  local pageSize = self._uiTransBG:GetSizeY() - self._uiNormalQuestGroup:GetPosY()
  return pageSize
end
function PaGlobal_CheckedQuest:getLastShownGroupIndex()
  local index = -1
  for ii = 0, self._maxQuestListCnt - 1 do
    local uiElem = self._uiList[ii]
    if true == uiElem._uiGroupBG:GetShow() then
      index = ii
    end
  end
  return index
end
function FromClient_QuestWidget_Update()
  PaGlobal_CheckedQuest:updateFavorType()
  FGlobal_MainQuest_Update()
  if false == ToClient_isConsole() then
    FGlobal_LatestQuest_UpdateList()
  end
  PaGlobal_CheckedQuest:updateQuestList(_startPosition)
  PaGlobal_CheckedQuest:updateScrollButtonSize()
  FGlobal_ChangeWidgetType()
  if false == _ContentsGroup_RenewUI_Tutorial then
    PaGlobal_SummonBossTutorial_Manager:checkQuestCondition()
    if Panel_LifeTutorial:GetShow() then
      FGlobal_LifeTutorial_Check()
    end
  end
end
function GuideButton_MouseOnOut(isOut)
  if not getEnableSimpleUI() then
    return
  end
  if isOut then
    PaGlobal_CheckedQuest._uiGuideButton:SetAlpha(0.7)
    PaGlobal_CheckedQuest._uiGuideButton:SetFontAlpha(0.8)
    PaGlobal_CheckedQuest._uiHistoryButton:SetAlpha(0.7)
    PaGlobal_CheckedQuest._uiHistoryButton:SetFontAlpha(0.8)
  else
    PaGlobal_CheckedQuest._uiGuideButton:SetAlpha(1)
    PaGlobal_CheckedQuest._uiGuideButton:SetFontAlpha(1)
    PaGlobal_CheckedQuest._uiHistoryButton:SetAlpha(1)
    PaGlobal_CheckedQuest._uiHistoryButton:SetFontAlpha(1)
  end
end
function HandleClicked_QuestShowCheck(groupId, questId)
  ToClient_ToggleCheckShow(groupId, questId)
  if true == Panel_CheckedQuestInfo:GetShow() then
    if Panel_CheckedQuestInfo:IsUISubApp() then
      Panel_CheckedQuestInfo:CloseUISubApp()
    end
    Panel_CheckedQuestInfo:SetShow(false)
  end
  HandleMouseOver_HelpPop(false, 0, "hide", 0)
end
local questNoSaveForTutorial = {_questGroupIndex, _questGroupIdx}
local welcomeToTheWorld = true
function FGlobal_CheckedQuest_SetWelcomeToTheWorld(isFirst)
  welcomeToTheWorld = isFirst
end
function PaGlobal_CheckedQuest:updateQuestList(startPosition)
  if 0 ~= _maxscrollBarPos and startPosition > _maxscrollBarPos then
    startPosition = _maxscrollBarPos
  end
  startPosition = math.max(math.min(startPosition, self._maxQuestListCnt - 1), 0)
  self:clear()
  self:doGuideQuest()
  self:doReleaseCheckForTutorial()
  _nextPosY = PaGlobal_LatestQuest:getLatestGroupPosY() + PaGlobal_LatestQuest:getLatestGroupSizeY()
  self._uiNormalQuestGroup:SetPosY(_nextPosY)
  self._uiNormalQuestGroup:SetAlpha(0)
  _nextPosY = 0
  _shownListCount = 0
  _nextPosY = self:QuestWidget_ProgressingGuildQuest(_nextPosY)
  local questListInfo = ToClient_GetQuestList()
  _questGroupCount = questListInfo:getQuestCheckedGroupCount()
  if 0 == isEmptyNormalQuestGroup() and true == ToClient_isProgressingGuildQuest() then
    self._uiTransBG:SetSize(Panel_CheckedQuest:GetSizeX(), 350)
    self._uiNormalQuestGroup:SetShow(false)
    return
  else
    _scrollBarStartPosition = _nextPosY
    for questIndex = startPosition, _questGroupCount - 1 do
      local questGroupInfo = questListInfo:getQuestCheckedGroupAt(questIndex)
      if nil == questGroupInfo then
        return
      end
      if true == questGroupInfo:isGroupQuest() then
        _nextPosY = self:groupQuestInfo(questGroupInfo, _nextPosY, questIndex)
      else
        local uiQuestInfo = questGroupInfo:getQuestAt(0)
        local isAlreadyShow = self:isAlreadyShown(uiQuestInfo:getQuestNo())
        if false == isAlreadyShow then
          _nextPosY = self:questInfo(questGroupInfo, uiQuestInfo, _nextPosY, true, questIndex, 0, nil, 0)
        end
      end
      if 0 == startPosition then
        if _nextPosY <= CheckedQuest_SizeY then
          self._uiGuideButton:SetPosY(Panel_CheckedQuest:GetSizeY())
          self._uiHistoryButton:SetPosY(Panel_CheckedQuest:GetSizeY())
          self._uiFindGuild:SetPosY(Panel_CheckedQuest:GetSizeY())
          self._uiResizeButton:SetPosY(Panel_CheckedQuest:GetSizeY())
        else
          self._uiGuideButton:SetPosY(CheckedQuest_SizeY)
          self._uiHistoryButton:SetPosY(CheckedQuest_SizeY)
          self._uiFindGuild:SetPosY(CheckedQuest_SizeY)
          self._uiResizeButton:SetPosY(CheckedQuest_SizeY)
        end
      end
      if _nextPosY > CheckedQuest_SizeY - self._uiNormalQuestGroup:GetPosY() then
        _maxscrollBarPos = 0
        _isDontDownScroll = false
        if true == widgetMouseOn then
          self._uiScrollBar:SetShow(true)
        end
        break
      else
        _maxscrollBarPos = startPosition
        _isDontDownScroll = true
      end
    end
    local normalGroupSizeY = _nextPosY
    local totalListCount = self:getTotalListCount()
    self._uiScrollBar:SetInterval(totalListCount - 2)
    self._uiScrollBar:SetPosX(Panel_CheckedQuest:GetSizeX() - self._uiScrollBar:GetSizeX() * 2)
    self._uiNormalQuestGroup:SetSize(Panel_CheckedQuest:GetSizeX(), normalGroupSizeY + 10)
    self._uiTransBG:SetSize(Panel_CheckedQuest:GetSizeX(), Panel_CheckedQuest:GetSizeY())
    if nil ~= FGlobal_GetSelectedWidgetType then
      local widgetType = FGlobal_GetSelectedWidgetType()
      if 0 == _shownListCount or false == widgetMouseOn and CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType then
        self._uiNormalQuestGroup:SetShow(false)
      else
        self._uiNormalQuestGroup:SetShow(true)
      end
    end
  end
  Panel_CheckedQuest:SetEnableArea(0, 0, Panel_CheckedQuest:GetSizeX(), Panel_CheckedQuest:GetSizeY() + PaGlobal_CheckedQuest._uiHistoryButton:GetSizeY())
end
function PaGlobal_CheckedQuest:getGroupCount()
  local groupCount = 0
  for ii = 0, self._maxQuestListCnt - 1 do
    if 0 ~= self._uiList[ii]._questNo._groupId and 0 ~= self._uiList[ii]._questNo._questId then
      groupCount = groupCount + 1
    end
  end
  return groupCount
end
function isEmptyNormalQuestGroup()
  local count = PaGlobal_CheckedQuest:getGroupCount()
  if 0 == count then
    return true
  end
  return false
end
function PaGlobal_CheckedQuest:doGuideQuest()
  local doGuideQuestCount = questList_getDoGuideQuestCount()
  if doGuideQuestCount > 0 then
    self._uiGuideButton:SetTextHorizonCenter()
    self._uiGuideNumber:SetText(doGuideQuestCount)
    self._uiGuideButton:SetPosY(Panel_CheckedQuest:GetSizeY())
    self._uiGuideNumber:SetPosX(self._uiGuideButton:GetPosX() + self._uiGuideButton:GetSizeX() - self._uiGuideNumber:GetSizeX() / 2 - 7)
    self._uiGuideNumber:SetPosY(self._uiGuideButton:GetPosY() + self._uiGuideButton:GetSizeY() - self._uiGuideNumber:GetSizeY() / 2 - 7)
    if getEnableSimpleUI() then
      self._uiGuideButton:SetAlpha(0.7)
      self._uiGuideButton:SetFontAlpha(0.8)
      self._uiGuideButton:addInputEvent("Mouse_On", "GuideButton_MouseOnOut( false )")
      self._uiGuideButton:addInputEvent("Mouse_Out", "GuideButton_MouseOnOut( true )")
    end
  else
    self._uiGuideButton:SetShow(false)
    self._uiGuideNumber:SetShow(false)
  end
  local isWantGuildJoin = ToClient_GetJoinedMode()
  if 0 == isWantGuildJoin then
    self._uiFindGuild:SetCheck(true)
  elseif 1 == isWantGuildJoin then
    self._uiFindGuild:SetCheck(false)
  end
  self._uiHistoryButton:SetPosX(Panel_CheckedQuest:GetSizeX() - self._uiHistoryButton:GetSizeX())
  self._uiHistoryButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  self._uiGuideButton:SetPosX(self._uiHistoryButton:GetPosX() - self._uiGuideButton:GetSizeX() - 5)
  self._uiGuideButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  self._uiFindGuild:SetPosX(0)
  self._uiFindGuild:SetPosY(Panel_CheckedQuest:GetSizeY())
  self._uiResizeButton:SetPosY(self._uiHistoryButton:GetPosY())
end
function PaGlobal_CheckedQuest:doReleaseCheckForTutorial()
  local questListInfo = ToClient_GetQuestList()
  local temp_questGroupCount = questListInfo:getQuestCheckedGroupCount()
  local temp_progressCount = 0
  if true == welcomeToTheWorld then
    for questGroupIndex = 0, temp_questGroupCount - 1 do
      questNoSaveForTutorial[temp_progressCount] = {_questGroupIndex, _questGroupIdx}
      local temp_questGroupInfo = questListInfo:getQuestCheckedGroupAt(questGroupIndex)
      if nil ~= temp_questGroupInfo then
        if true == temp_questGroupInfo:isGroupQuest() then
          local tempGroupCount = temp_questGroupInfo:getQuestCount()
          for questGroupIdx = 0, tempGroupCount - 1 do
            local tempQuestInfo = temp_questGroupInfo:getQuestAt(questGroupIdx)
            local recommandLevel = tempQuestInfo:getRecommendLevel()
            local selfLevel = getSelfPlayer():get():getLevel() + 10
            if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
              if welcomeToTheWorld and not TutorialQuestCompleteCheck() and (3 == tempQuestInfo:getQuestType() or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or recommandLevel > selfLevel) then
                questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
                questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
              end
              temp_progressCount = temp_progressCount + 1
            end
          end
        else
          local tempQuestInfo = temp_questGroupInfo:getQuestAt(0)
          local recommandLevel = tempQuestInfo:getRecommendLevel()
          local selfLevel = getSelfPlayer():get():getLevel() + 10
          if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
            if welcomeToTheWorld and not TutorialQuestCompleteCheck() and (3 == tempQuestInfo:getQuestType() or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or recommandLevel > selfLevel) then
              questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
              questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
            end
            temp_progressCount = temp_progressCount + 1
          end
        end
      end
    end
    if welcomeToTheWorld and not TutorialQuestCompleteCheck() and temp_progressCount > 0 then
      welcomeToTheWorld = false
      for index = 0, temp_progressCount - 1 do
        ToClient_ToggleCheckShow(questNoSaveForTutorial[index]._questGroupIndex, questNoSaveForTutorial[index]._questGroupIdx)
      end
    end
  end
  welcomeToTheWorld = false
end
function PaGlobal_CheckedQuest:QuestWidget_ProgressingGuildQuest(_nextPosY)
  if PaGlobal_TutorialManager:isDoingTutorial() then
    self._guildQuest._ControlBG:SetShow(false)
    _hasGuildQuest = false
    return _nextPosY, _hasGuildQuest
  end
  local ControlBG_sizeY = _nextPosY
  local isProgressingGuildQuest = ToClient_isProgressingGuildQuest()
  local questConditionDefaultPosY = 40
  if isProgressingGuildQuest then
    self._guildQuest._AutoNavi:ComputePos()
    self._guildQuest._Navi:ComputePos()
    self._guildQuest._Reward:ComputePos()
    self._guildQuest._Giveup:ComputePos()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
    if isGuildMaster or isGuildSubMaster then
      self._guildQuest._Giveup:SetShow(true)
    else
      self._guildQuest._Giveup:SetShow(false)
    end
    for index = 1, 5 do
      self._guildQuest._Condition[index]:SetShow(false)
      self._guildQuest._Condition[index]:SetText("")
    end
    self._guildQuest._ControlBG:SetShow(true)
    self._guildQuest._ControlBG:SetPosY(ControlBG_sizeY)
    local guildQuestName = ToClient_getCurrentGuildQuestName()
    self._guildQuest._Title:SetText(guildQuestName)
    local remainTime = ToClient_getCurrentGuildQuestRemainedTime()
    local strMinute = math.floor(remainTime / 60)
    if remainTime <= 0 then
      self._guildQuest._LimitTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT"))
    else
      self._guildQuest._LimitTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute))
    end
    local questConditionCount = ToClient_getCurrentGuildQuestConditionCount()
    local completeConditionCount = 0
    for index = 1, 5 do
      if index <= questConditionCount then
        local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(index - 1)
        self._guildQuest._Condition[index]:SetShow(true)
        self._guildQuest._Condition[index]:SetText("- " .. currentGuildQuestInfo._desc .. "(" .. currentGuildQuestInfo._currentCount .. "/" .. currentGuildQuestInfo._destCount .. ")")
        self._guildQuest._Condition[index]:SetPosY(questConditionDefaultPosY)
        if currentGuildQuestInfo._destCount <= currentGuildQuestInfo._currentCount then
          self._guildQuest._Condition[index]:SetFontColor(UI_color.C_FF626262)
          completeConditionCount = completeConditionCount + 1
        else
          self._guildQuest._Condition[index]:SetFontColor(UI_color.C_FFC4BEBE)
        end
        questConditionDefaultPosY = questConditionDefaultPosY + self._guildQuest._Condition[index]:GetTextSizeY() + 5
      end
    end
    if completeConditionCount == questConditionCount then
      for index = 1, 5 do
        if index <= questConditionCount then
          self._guildQuest._Condition[index]:SetFontColor(UI_color.C_FFF26A6A)
          self._guildQuest._Condition[index]:SetText("")
        end
      end
      self._guildQuest._Title:EraseAllEffect()
      self._guildQuest._Title:AddEffect("UI_Quest_Complete_GoldAura", true, -10, 0)
      if questConditionCount > 1 then
        for ii = questConditionCount, 2, -1 do
          questConditionDefaultPosY = questConditionDefaultPosY - self._guildQuest._Condition[ii]:GetTextSizeY() - 5
        end
      end
      self._guildQuest._Condition[1]:SetFontColor(Defines.Color.C_FFF26A6A)
      self._guildQuest._Condition[1]:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_COMPLETE"))
    end
    if remainTime <= 0 then
      if questConditionCount > 1 then
        for ii = questConditionCount, 2, -1 do
          questConditionDefaultPosY = questConditionDefaultPosY - self._guildQuest._Condition[ii]:GetTextSizeY() - 5
        end
      end
      self._guildQuest._Condition[1]:SetFontColor(Defines.Color.C_FFF26A6A)
      self._guildQuest._Condition[1]:SetText(PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_TIMEOVER"))
    end
    self._guildQuest._ControlBG:SetSize(self._guildQuest._ControlBG:GetSizeX(), questConditionDefaultPosY)
    _hasGuildQuest = true
    _shownListCount = _shownListCount + 1
    return self._guildQuest._ControlBG:GetSizeY() + 10, _hasGuildQuest
  else
    self._guildQuest._ControlBG:SetShow(false)
    _hasGuildQuest = false
    return _nextPosY, _hasGuildQuest
  end
end
local elapsedTime = 0
function QuestWidget_ProgressingGuildQuest_UpdateRemainTime(deltaTime)
  elapsedTime = elapsedTime + deltaTime
  if elapsedTime < 5 then
    return
  end
  if not ToClient_isProgressingGuildQuest() then
    return
  end
  local remainTime = ToClient_getCurrentGuildQuestRemainedTime()
  local strMinute = math.floor(remainTime / 60)
  if remainTime <= 0 then
    PaGlobal_CheckedQuest._guildQuest._LimitTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT"))
  else
    PaGlobal_CheckedQuest._guildQuest._LimitTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute))
  end
  elapsedTime = 0
end
Panel_CheckedQuest:RegisterUpdateFunc("QuestWidget_ProgressingGuildQuest_UpdateRemainTime")
function PaGlobal_CheckedQuest:groupQuestInfo(questGroupInfo, _nextPosY, questGroupIndex)
  local tmp_next_GroupPosY = _nextPosY + 2
  local questGroupTitle = questGroupInfo:getTitle()
  local questGroupCount = questGroupInfo:getTotalQuestCount()
  for questIndex = 0, questGroupInfo:getQuestCount() - 1 do
    local uiQuestInfo = questGroupInfo:getQuestAt(questIndex)
    local isAlreadyShown = PaGlobal_LatestQuest:isShownQuest(uiQuestInfo:getQuestNo()) or PaGlobal_MainQuest:isShownQuest(uiQuestInfo:getQuestNo())
    if false == isAlreadyShown then
      tmp_next_GroupPosY = self:questInfo(questGroupInfo, uiQuestInfo, tmp_next_GroupPosY, false, questGroupIndex, questIndex, questGroupTitle, questGroupCount)
    end
  end
  return tmp_next_GroupPosY
end
function PaGlobal_CheckedQuest:questInfo(questGroupInfo, uiQuestInfo, _nextPosY, isSingle, questGroupIndex, questIndex, groupTitle, questGroupCount)
  local tmp_nextPosY = _nextPosY + 2
  local questGroupId = uiQuestInfo:getQuestNo()._group
  local questId = uiQuestInfo:getQuestNo()._quest
  if false == uiQuestInfo._isCleared and true == uiQuestInfo._isProgressing then
    tmp_nextPosY = self:ProgressQuest(questGroupInfo, uiQuestInfo, tmp_nextPosY, isSingle, groupTitle, questGroupCount, questGroupIndex)
  else
    tmp_nextPosY = _nextPosY
  end
  return tmp_nextPosY
end
function PaGlobal_CheckedQuest:ProgressQuest(questGroupInfo, uiQuestInfo, tmp_nextPosY, isSingle, groupTitle, questGroupCount, questGroupIndex)
  if nil == getSelfPlayer() then
    return tmp_nextPosY
  end
  if questGroupIndex >= self._maxQuestListCnt then
    return tmp_nextPosY
  end
  local questNo = uiQuestInfo:getQuestNo()
  local questGroupId = questNo._group
  local questId = questNo._quest
  local groupIdx = questGroupIndex
  local groupStartPos = tmp_nextPosY
  local uiGroupBG = self._uiList[groupIdx]._uiGroupBG
  local uiSelectBG = self._uiList[groupIdx]._uiSelectBG
  self._uiList[groupIdx]._questNo._groupId = questGroupId
  self._uiList[groupIdx]._questNo._questId = questId
  self:setQuestGroupPos(groupIdx, uiQuestInfo, questGroupId, questId, questGroupCount, groupTitle, groupStartPos)
  self:setQuestTypeIcon(groupIdx, uiQuestInfo)
  self:setQuestTitle(groupIdx, uiQuestInfo)
  self:setHideButtonInfo(groupIdx, questNo, isSingle)
  self:setGiveupButtonInfo(groupIdx, uiQuestInfo)
  self:setNaviButtonInfo(groupIdx, uiQuestInfo)
  local nextUIPos = self:setQuestGroupTitle(groupIdx, isSingle, groupTitle, questId, questGroupCount)
  nextUIPos = self:setQuestCondition(groupIdx, uiQuestInfo, questNo, nextUIPos)
  uiGroupBG:SetSize(Panel_CheckedQuest:GetSizeX() - 18, nextUIPos + 5)
  uiSelectBG:SetSize(uiGroupBG:GetSizeX(), uiGroupBG:GetSizeY())
  local isOnMouse = self:isHitTestQuestGroup(uiGroupBG)
  self:resizingConvenienceButtons(groupIdx, isOnMouse)
  tmp_nextPosY = groupStartPos + uiGroupBG:GetSizeY()
  _shownListCount = _shownListCount + 1
  return tmp_nextPosY
end
function PaGlobal_CheckedQuest:setQuestGroupPos(idx, uiQuestInfo, questGroupId, questId, questGroupCount, groupTitle, posY)
  if idx < 0 or idx >= PaGlobal_CheckedQuest._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "===================error==================")
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "setQuestGroupPos : idx == " .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "===================error==================")
    return
  end
  local elem = self._uiList[idx]
  elem._uiGroupBG:SetShow(true)
  elem._uiGroupBG:SetAlpha(0)
  elem._uiGroupBG:SetPosX(5)
  elem._uiGroupBG:SetPosY(posY)
  elem._uiSelectBG:SetPosX(0)
  elem._uiSelectBG:SetPosY(0)
  local conditionCheck
  if true == uiQuestInfo:isSatisfied() then
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Complete
  else
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  local naviBtnShow = 0
  if false == uiQuestInfo:isSatisfied() and 0 == uiQuestInfo:getQuestPositionCount() then
    naviBtnShow = 1
  end
  if nil == groupTitle then
    groupTitle = "nil"
  end
  if false == _ContentsGroup_RenewUI then
    elem._uiGroupBG:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", \"" .. groupTitle .. "\", " .. questGroupCount .. " )")
    elem._uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
    elem._uiGroupBG:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
    elem._uiGroupBG:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
    elem._uiGroupBG:addInputEvent("Mouse_On", "HandleMouseOver_CheckedQuestGroup( true, " .. idx .. "," .. naviBtnShow .. " )")
    elem._uiGroupBG:addInputEvent("Mouse_Out", "HandleMouseOver_CheckedQuestGroup( false, " .. idx .. "," .. naviBtnShow .. " )")
  end
  if true == uiQuestInfo:isSatisfied() and uiQuestInfo:isCompleteBlackSpirit() then
    elem._uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_CallBlackSpirit()")
  end
end
function PaGlobal_CheckedQuest:setQuestTypeIcon(idx, uiQuestInfo)
  if nil == uiQuestInfo or idx >= PaGlobal_CheckedQuest._maxQuestListCnt then
    return
  end
  local uiQuestIcon = self._uiList[idx]._uiQuestIcon
  uiQuestIcon:EraseAllEffect()
  uiQuestIcon:SetShow(true)
  uiQuestIcon:SetIgnore(true)
  uiQuestIcon:SetPosX(3)
  uiQuestIcon:SetPosY(3)
  FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestIcon, uiQuestInfo:getQuestType())
end
function PaGlobal_CheckedQuest:setQuestTitle(idx, uiQuestInfo)
  if nil == uiQuestInfo or idx >= self._maxQuestListCnt then
    return
  end
  local questNo = uiQuestInfo:getQuestNo()
  local questTitle = self:getQuestTitle(questNo._group, questNo._quest)
  local uiQuestTitle = self._uiList[idx]._uiQuestTitle
  local uiQuestIcon = self._uiList[idx]._uiQuestIcon
  uiQuestTitle:SetAutoResize(true)
  uiQuestTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  uiQuestTitle:SetSize(200, uiQuestTitle:GetSizeY())
  uiQuestTitle:SetText(questTitle)
  uiQuestTitle:SetPosX(uiQuestIcon:GetPosX() + uiQuestIcon:GetSizeX() + 5)
  uiQuestTitle:SetPosY(uiQuestIcon:GetPosY())
  uiQuestTitle:SetLineRender(false)
  uiQuestTitle:SetShow(true)
  uiQuestTitle:SetIgnore(true)
  uiQuestTitle:SetFontColor(UI_color.C_FFEFEFEF)
  uiQuestTitle:useGlowFont(true, "BaseFont_8_Glow", 4287655978)
end
function PaGlobal_CheckedQuest:setQuestGroupTitle(idx, isSingle, groupTitle, questId, questGroupCount)
  if idx >= self._maxQuestListCnt then
    return
  end
  if nil == groupTitle then
    groupTitle = "nil"
  end
  local uiQuestTitle = self._uiList[idx]._uiQuestTitle
  local uiGroupTitle = self._uiList[idx]._uiGroupTitle
  local posY = uiQuestTitle:GetPosY() + uiQuestTitle:GetSizeY() + 5
  if false == isSingle then
    local groupQuestTitleInfo = groupTitle .. " (" .. questId .. "/" .. questGroupCount .. ")"
    uiGroupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo))
    uiGroupTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    uiGroupTitle:SetSize(230, uiGroupTitle:GetSizeY())
    uiGroupTitle:SetPosX(25)
    uiGroupTitle:SetPosY(uiQuestTitle:GetPosY() + uiQuestTitle:GetSizeY() + 5)
    uiGroupTitle:SetFontColor(UI_color.C_FFEDE699)
    uiGroupTitle:SetAutoResize(true)
    uiGroupTitle:SetIgnore(true)
    uiGroupTitle:SetShow(true)
    posY = posY + uiGroupTitle:GetSizeY()
  end
  return posY
end
function PaGlobal_CheckedQuest:setQuestCondition(idx, uiQuestInfo, questNo, posY)
  if idx >= self._maxQuestListCnt then
    return
  end
  local questGroupId = questNo._group
  local questId = questNo._quest
  if false == uiQuestInfo:isSatisfied() then
    for index = 0, uiQuestInfo:getDemandCount() - 1 do
      local uiCondition = self._uiList[idx]._uiConditions[index]
      local conditionInfo = uiQuestInfo:getDemandAt(index)
      uiCondition:SetAutoResize(true)
      uiCondition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      uiCondition:SetFontColor(UI_color.C_FFC4BEBE)
      if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
        uiCondition:SetPosX(10)
      else
        uiCondition:SetPosX(25)
      end
      uiCondition:SetPosY(posY)
      uiCondition:SetSize(self._uiList[idx]._uiGroupBG:GetSizeX() - uiCondition:GetPosX(), uiCondition:GetTextSizeY())
      local conditionText
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        conditionText = "- " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
        uiCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiCondition:SetLineRender(true)
        uiCondition:SetFontColor(UI_color.C_FF626262)
      elseif 1 == conditionInfo._destCount then
        conditionText = "- " .. conditionInfo._desc
        uiCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiCondition:SetLineRender(false)
      else
        conditionText = "- " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
        uiCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiCondition:SetLineRender(false)
      end
      uiCondition:SetShow(true)
      uiCondition:SetIgnore(true)
      posY = posY + uiCondition:GetTextSizeY() + 2
    end
  else
    local uiCompleteNpc = PaGlobal_CheckedQuest._uiList[idx]._uiCompleteNpc
    local uiQuestIcon = PaGlobal_CheckedQuest._uiList[idx]._uiQuestIcon
    if 0 == uiQuestInfo:getQuestType() then
      uiQuestIcon:AddEffect("UI_Quest_Complete_GoldAura", true, 130, 0)
    elseif 0 < uiQuestInfo:getQuestType() then
      uiQuestIcon:AddEffect("UI_Quest_Complete_GreenAura", true, 130, 0)
    end
    uiCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC"))
    uiCompleteNpc:SetFontColor(Defines.Color.C_FFF26A6A)
    FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
    if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
      uiCompleteNpc:SetPosX(10)
    else
      uiCompleteNpc:SetPosX(25)
    end
    uiCompleteNpc:SetPosY(posY)
    uiCompleteNpc:SetShow(true)
    uiCompleteNpc:SetLineRender(true)
    uiCompleteNpc:SetIgnore(true)
    FGlobal_ChangeOnTextureForDialogQuestIcon(uiQuestIcon, 8)
    if false == isSingle then
      uiGroupInfomation:SetFontColor(UI_color.C_FFF26A6A)
    end
    posY = posY + uiCompleteNpc:GetTextSizeY() + 2
  end
  return posY
end
function PaGlobal_CheckedQuest:setVisibleConvenienceButton(show)
  local selfLevel = getSelfPlayer():get():getLevel()
  for idx = 0, self._maxQuestListCnt - 1 do
    local uiElem = self._uiList[idx]
    if true == show then
      if uiElem._uiAutoNaviBtn:IsEnable() then
        uiElem._uiAutoNaviBtn:SetShow(widgetMouseOn)
        uiElem._uiNaviBtn:SetShow(widgetMouseOn)
      end
      if selfLevel > self._giveupLimitLv then
        uiElem._uiGiveupBtn:SetShow(widgetMouseOn)
        uiElem._uiHideBtn:SetShow(widgetMouseOn)
      end
    else
      uiElem._uiAutoNaviBtn:SetShow(false)
      uiElem._uiNaviBtn:SetShow(false)
      uiElem._uiGiveupBtn:SetShow(false)
      uiElem._uiHideBtn:SetShow(false)
    end
  end
end
function PaGlobal_CheckedQuest:resizingConvenienceButtons(idx, isMouseOn)
  if idx < 0 or idx >= self._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "==================error====================")
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "resizingConvenienceButtons : idx == " .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "==================error====================")
    return
  end
  local uiElem = self._uiList[idx]
  local sizeX = self._defaultButtonSize
  local sizeY = self._defaultButtonSize
  if true == isMouseOn then
    sizeX = self._extendButtonSize
    sizeY = self._extendButtonSize
    uiElem._uiAutoNaviBtn:SetPosX(260)
    uiElem._uiNaviBtn:SetPosX(235)
    uiElem._uiGiveupBtn:SetPosX(210)
    uiElem._uiHideBtn:SetPosX(185)
  else
    uiElem._uiAutoNaviBtn:SetPosX(265)
    uiElem._uiNaviBtn:SetPosX(245)
    uiElem._uiGiveupBtn:SetPosX(225)
    uiElem._uiHideBtn:SetPosX(205)
  end
  uiElem._uiAutoNaviBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiNaviBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiGiveupBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiHideBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiAutoNaviBtn:SetSize(sizeX, sizeY)
  uiElem._uiNaviBtn:SetSize(sizeX, sizeY)
  uiElem._uiGiveupBtn:SetSize(sizeX, sizeY)
  uiElem._uiHideBtn:SetSize(sizeX, sizeY)
end
function PaGlobal_CheckedQuest:setNaviButtonInfo(idx, uiQuestInfo)
  if idx < 0 or idx >= self._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "====================error=================" .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "setNaviButtonInfo : idx == \t\t\t\t" .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "========================================" .. tostring(idx))
    return
  end
  local questGroupId = uiQuestInfo:getQuestNo()._group
  local questId = uiQuestInfo:getQuestNo()._quest
  local uiGroupBG = self._uiList[idx]._uiGroupBG
  local uiSelectBG = self._uiList[idx]._uiSelectBG
  local uiAutoNaviBtn = self._uiList[idx]._uiAutoNaviBtn
  local uiNaviBtn = self._uiList[idx]._uiNaviBtn
  local uiAutoNaviBtnPosY = self._uiNormalQuestGroup:GetPosY() + uiGroupBG:GetPosY() + uiAutoNaviBtn:GetPosY()
  local uiNaviBtnPosY = self._uiNormalQuestGroup:GetPosY() + uiGroupBG:GetPosY() + uiNaviBtn:GetPosY()
  local conditionCheck
  if true == uiQuestInfo:isSatisfied() then
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Complete
  else
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  uiAutoNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_HelpPop( true," .. uiAutoNaviBtnPosY .. ", \"Autonavi\", " .. idx .. "  )")
  uiAutoNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_HelpPop( false," .. uiAutoNaviBtnPosY .. ", \"Autonavi\", " .. idx .. "  )")
  uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", true )")
  uiNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_HelpPop( true," .. uiNaviBtnPosY .. ", \"navi\", " .. idx .. "  )")
  uiNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_HelpPop( false," .. uiNaviBtnPosY .. ", \"navi\", " .. idx .. "  )")
  uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  if _questGroupId == questGroupId and _questId == questId then
    if true == _naviInfoAgain then
      uiSelectBG:SetShow(false)
      uiAutoNaviBtn:SetCheck(false)
      uiNaviBtn:SetCheck(false)
    else
      uiSelectBG:SetShow(true)
      if true == uiAutoNaviBtn:IsCheck() then
        uiAutoNaviBtn:SetCheck(true)
        uiNaviBtn:SetCheck(true)
      else
        uiAutoNaviBtn:SetCheck(false)
        uiNaviBtn:SetCheck(true)
      end
    end
  else
    uiSelectBG:SetShow(false)
    uiAutoNaviBtn:SetCheck(false)
    uiNaviBtn:SetCheck(false)
  end
  local questStaticStatus = questList_getQuestStatic(questGroupId, questId)
  local posCount = questStaticStatus:getQuestPositionCount()
  local enable = true
  if false == uiQuestInfo:isSatisfied() and 0 == posCount then
    enable = false
  end
  if true == enable then
    uiAutoNaviBtn:SetShow(widgetMouseOn)
    uiNaviBtn:SetShow(widgetMouseOn)
  end
  uiAutoNaviBtn:SetEnable(enable)
  uiNaviBtn:SetEnable(enable)
  if true == uiQuestInfo:isSatisfied() and uiQuestInfo:isCompleteBlackSpirit() then
    uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
    uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
  end
end
function PaGlobal_CheckedQuest:setGiveupButtonInfo(idx, uiQuestInfo)
  if idx >= self._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "=================error==================" .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "setGiveupButtonInfo : idx == " .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "======================================" .. tostring(idx))
    return
  end
  local questGroupId = uiQuestInfo:getQuestNo()._group
  local questId = uiQuestInfo:getQuestNo()._quest
  local selfLevel = getSelfPlayer():get():getLevel()
  local uiGroupBG = self._uiList[idx]._uiGroupBG
  local uiGiveupBtn = self._uiList[idx]._uiGiveupBtn
  local uiGiveupBtnPosY = self._uiNormalQuestGroup:GetPosY() + uiGroupBG:GetPosY() + uiGiveupBtn:GetPosY()
  uiGiveupBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp( " .. questGroupId .. "," .. questId .. " )")
  uiGiveupBtn:addInputEvent("Mouse_On", "HandleMouseOver_HelpPop( true," .. uiGiveupBtnPosY .. ", \"giveup\", " .. idx .. "  )")
  uiGiveupBtn:addInputEvent("Mouse_Out", "HandleMouseOver_HelpPop( false," .. uiGiveupBtnPosY .. ", \"giveup\", " .. idx .. "  )")
  local isEnable = selfLevel > self._giveupLimitLv
  uiGiveupBtn:SetEnable(isEnable)
  if selfLevel > self._giveupLimitLv then
    uiGiveupBtn:SetShow(widgetMouseOn)
  else
    uiGiveupBtn:SetShow(false)
  end
end
function PaGlobal_CheckedQuest:setHideButtonInfo(idx, questNo, isSingle)
  if idx < 0 or idx >= self._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "====================error=================" .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "setHideButtonInfo : idx == \t\t\t\t" .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "========================================" .. tostring(idx))
    return
  end
  local questGroupId = questNo._group
  local questId = questNo._quest
  local selfLevel = getSelfPlayer():get():getLevel()
  local uiHideBtn = self._uiList[idx]._uiHideBtn
  local uiGroupBG = self._uiList[idx]._uiGroupBG
  if selfLevel > self._giveupLimitLv then
    uiHideBtn:SetShow(widgetMouseOn)
  else
    uiHideBtn:SetShow(false)
  end
  if true == isSingle then
    uiHideBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestShowCheck(" .. questGroupId .. "," .. questId .. ")")
  else
    uiHideBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestShowCheck(" .. questGroupId .. "," .. 0 .. ")")
  end
  local uiHideBtnPosY = self._uiNormalQuestGroup:GetPosY() + uiGroupBG:GetPosY() + uiHideBtn:GetPosY()
  uiHideBtn:addInputEvent("Mouse_On", "HandleMouseOver_HelpPop( true," .. uiHideBtnPosY .. ", \"hide\", " .. idx .. "  )")
  uiHideBtn:addInputEvent("Mouse_Out", "HandleMouseOver_HelpPop( false," .. uiHideBtnPosY .. ", \"hide\", " .. idx .. "  )")
end
function PaGlobal_CheckedQuest:isHitTestQuestGroup(groupControl)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panel = Panel_CheckedQuest
  local panelPosX = panel:GetPosX() + self._uiNormalQuestGroup:GetPosX() + groupControl:GetPosX()
  local panelPosY = panel:GetPosY() + self._uiNormalQuestGroup:GetPosY() + groupControl:GetPosY()
  local bgPosX = panelPosX
  local bgPosY = panelPosY
  local bgSizeX = groupControl:GetSizeX() - 3
  local bgSizeY = groupControl:GetSizeY() - 5
  if mousePosX >= bgPosX and mousePosX <= bgPosX + bgSizeX and mousePosY >= bgPosY and mousePosY <= bgPosY + bgSizeY then
    return true
  end
  return false
end
function PaGlobal_CheckedQuest:getQuestTitle(groupId, questId)
  local questTitle, questLevel
  local uiQuestInfo = ToClient_GetQuestInfo(groupId, questId)
  if nil ~= uiQuestInfo then
    questTitle = uiQuestInfo:getTitle()
    questLevel = uiQuestInfo:getRecommendLevel()
    if nil ~= questLevel and 0 ~= questLevel then
      questTitle = "[" .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. questLevel .. "] " .. questTitle
    end
  end
  return questTitle
end
local blackQuestTexture = {
  {
    70,
    70,
    115,
    115
  },
  {
    197,
    197,
    250,
    250
  }
}
function _questWidget_ChangeTextureForBlackSpirit(isBlack, control)
  control:ChangeTextureInfoName("New_ui_common_forlua/default/blackpanel_series.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, blackQuestTexture[isBlack][1], blackQuestTexture[isBlack][2], blackQuestTexture[isBlack][3], blackQuestTexture[isBlack][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function haveQuestCheck(questGroupId, questId)
  local questListInfo = ToClient_GetQuestList()
  local temp_questGroupCount = questListInfo:getQuestGroupCount()
  local haveQuest = false
  for temp_progressCount = 0, temp_questGroupCount - 1 do
    if nil ~= questNoSaveForTutorial[temp_progressCount] and questNoSaveForTutorial[temp_progressCount]._questGroupIndex == questGroupId and questNoSaveForTutorial[temp_progressCount]._questGroupIdx == questId then
      haveQuest = true
    end
  end
  return haveQuest
end
function HandleMouseOver_HelpPop(show, posY, target, idx)
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiHelpWidget, 9999)
  if true == show then
    if "navi" == target then
      PaGlobal_CheckedQuest._uiHelpWidget:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP"))
    elseif "Autonavi" == target then
      PaGlobal_CheckedQuest._uiHelpWidget:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP"))
    elseif "hide" == target then
      PaGlobal_CheckedQuest._uiHelpWidget:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_HIDETOOLTIP"))
    elseif "giveup" == target then
      PaGlobal_CheckedQuest._uiHelpWidget:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GIVEUPTOOLTIP"))
    end
    _questWidgetBubblePos(posY)
    PaGlobal_CheckedQuest._uiHelpWidget:SetShow(true)
    PaGlobal_CheckedQuest:resizingConvenienceButtons(idx, true)
  else
    FGlobal_QuestWidget_MouseOver(false)
    PaGlobal_CheckedQuest._uiHelpWidget:SetShow(false)
  end
end
function _questWidgetBubblePos(posY)
  local screenY = getScreenSizeY()
  local panelPosY = Panel_CheckedQuest:GetPosY()
  local _uiHelpWidgetSizeY = PaGlobal_CheckedQuest._uiHelpWidget:GetSizeY()
  local buttonSizeY = PaGlobal_CheckedQuest._uiList[0]._uiHideBtn:GetSizeY()
  if screenY < panelPosY + posY + _uiHelpWidgetSizeY then
    PaGlobal_CheckedQuest._uiHelpWidget:SetPosY(posY - _uiHelpWidgetSizeY - 5)
  else
    PaGlobal_CheckedQuest._uiHelpWidget:SetPosY(posY + buttonSizeY + 5)
  end
  PaGlobal_CheckedQuest._uiHelpWidget:SetPosX(Panel_CheckedQuest:GetSizeX() - PaGlobal_CheckedQuest._uiHelpWidget:GetSizeX() + 5)
end
local IM = CppEnums.EProcessorInputMode
function PaGlobal_CheckedQuest:Common_WidgetMouseOut()
  if IM.eProcessorInputMode_GameMode ~= UI.Get_ProcessorInputMode() then
    local panelPosX = Panel_CheckedQuest:GetPosX()
    local panelPosY = Panel_CheckedQuest:GetPosY()
    local panelSizeX = Panel_CheckedQuest:GetSizeX()
    local panelSizeY = Panel_CheckedQuest:GetSizeY() + PaGlobal_CheckedQuest._uiHistoryButton:GetSizeY()
    local mousePosX = getMousePosX()
    local mousePosY = getMousePosY()
    if panelPosX < mousePosX and mousePosX < panelPosX + panelSizeX and panelPosY < mousePosY and mousePosY < panelPosY + panelSizeY then
      return false
    end
  end
  return true
end
function FGlobal_QuestWidget_MouseOver(show)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if true == show then
    PaGlobal_CheckedQuest._uiTransBG:SetShow(true)
    if false == isEmptyNormalQuestGroup() then
      PaGlobal_CheckedQuest._uiNormalQuestGroup:SetShow(true)
    end
    widgetMouseOn = true
    PaGlobal_CheckedQuest._uiTooltipBG:SetShow(true)
    PaGlobal_CheckedQuest.nodeHelpMouseL:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIN_WORLDMAP_HELP_MOUSEL"))
    PaGlobal_CheckedQuest.nodeHelpMouseR:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIN_WORLDMAP_HELP_MOUSER"))
    local txtSizeMouseL = PaGlobal_CheckedQuest.nodeHelpMouseL:GetTextSizeX()
    local txtSizeMouseR = PaGlobal_CheckedQuest.nodeHelpMouseR:GetTextSizeX()
    if txtSizeMouseL < txtSizeMouseR then
      PaGlobal_CheckedQuest._uiTooltipBG:SetSize(txtSizeMouseR + 38, 75)
    else
      PaGlobal_CheckedQuest._uiTooltipBG:SetSize(txtSizeMouseL + 38, 75)
    end
    PaGlobal_CheckedQuest:checkShowScrollbar()
    PaGlobal_CheckedQuest:tooltipReposition()
    PaGlobal_CheckedQuest:setShowFunctionButtons(true)
    PaGlobal_CheckedQuest:setVisibleConvenienceButton(true)
    FGlobal_LatestQuestWidget_MouseOver(true)
  else
    if false == PaGlobal_CheckedQuest:Common_WidgetMouseOut() then
      return
    end
    local widgetType = FGlobal_GetSelectedWidgetType()
    if CppEnums.QuestWidgetType.eQuestWidgetType_Extend ~= widgetType then
      PaGlobal_CheckedQuest._uiNormalQuestGroup:SetShow(false)
    end
    widgetMouseOn = false
    PaGlobal_CheckedQuest._uiTransBG:SetShow(false)
    PaGlobal_CheckedQuest._uiTooltipBG:SetShow(false)
    PaGlobal_CheckedQuest:setShowFunctionButtons(false)
    PaGlobal_CheckedQuest:setVisibleConvenienceButton(false)
    FGlobal_LatestQuestWidget_MouseOver(false)
  end
  PaGlobal_TutorialManager:handleQuestWidgetMouseOver(show)
end
function FGlobal_ChangeWidgetType()
  if nil == FGlobal_GetSelectedWidgetType then
    return
  end
  local widgetType = FGlobal_GetSelectedWidgetType()
  if CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType then
    PaGlobal_CheckedQuest._uiNormalQuestGroup:SetShow(false)
  else
    PaGlobal_CheckedQuest._uiNormalQuestGroup:SetShow(true)
  end
end
function PaGlobal_CheckedQuest:tooltipReposition()
  if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    local txtSizeMouseL = PaGlobal_CheckedQuest.nodeHelpMouseL:GetTextSizeX()
    local txtSizeMouseR = PaGlobal_CheckedQuest.nodeHelpMouseR:GetTextSizeX()
    if txtSizeMouseL < txtSizeMouseR then
      PaGlobal_CheckedQuest._uiTooltipBG:SetSize(txtSizeMouseR + 38, 75)
    else
      PaGlobal_CheckedQuest._uiTooltipBG:SetSize(txtSizeMouseL + 38, 75)
    end
  end
  local isLeft = getScreenSizeX() / 2 < Panel_CheckedQuest:GetPosX()
  if not isLeft then
    self._uiTooltipBG:SetPosX(Panel_CheckedQuest:GetSizeX() + 10)
  else
    self._uiTooltipBG:SetPosX(Panel_CheckedQuest:GetSizeX() - Panel_CheckedQuest:GetSizeX() - self._uiTooltipBG:GetSizeX() - 10)
  end
  self._uiTooltipBG:SetPosY(self._uiTransBG:GetPosY())
end
function PaGlobal_CheckedQuest:setShowFunctionButtons(isMouseOver)
  if true == isMouseOver then
    PaGlobal_CheckedQuest._uiResizeButton:SetShow(true)
    if 0 < questList_getDoGuideQuestCount() then
      PaGlobal_CheckedQuest._uiGuideButton:SetShow(true)
      PaGlobal_CheckedQuest._uiGuideNumber:SetShow(true)
    end
    PaGlobal_CheckedQuest._uiHistoryButton:SetShow(true)
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      PaGlobal_CheckedQuest._uiFindGuild:SetShow(true)
    end
  else
    PaGlobal_CheckedQuest._uiResizeButton:SetShow(false)
    PaGlobal_CheckedQuest._uiGuideButton:SetShow(false)
    PaGlobal_CheckedQuest._uiGuideNumber:SetShow(false)
    PaGlobal_CheckedQuest._uiHistoryButton:SetShow(false)
    PaGlobal_CheckedQuest._uiFindGuild:SetShow(false)
    PaGlobal_CheckedQuest._uiScrollBar:SetShow(false)
  end
end
function HandleMouseOver_CheckedQuestGroup(show, bgIndex, naviBtnShow)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if bgIndex < 0 or bgIndex >= PaGlobal_CheckedQuest._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "=================error=================")
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "HandleMouseOver_CheckedQuestGroup: bgIndex == " .. tostring(bgIndex))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "=================error=================")
    return
  end
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local uiGroupBG = PaGlobal_CheckedQuest._uiList[bgIndex]._uiGroupBG
  local uiNaviBtn = PaGlobal_CheckedQuest._uiList[bgIndex]._uiNaviBtn
  local uiSelectBG = PaGlobal_CheckedQuest._uiList[bgIndex]._uiSelectBG
  if true == show then
    FGlobal_QuestWidget_MouseOver(true)
    if false == uiNaviBtn:IsCheck() then
      uiSelectBG:SetShow(true)
    end
    PaGlobal_CheckedQuest:resizingConvenienceButtons(bgIndex, true)
  else
    if false == uiNaviBtn:IsCheck() then
      uiSelectBG:SetShow(false)
    end
    if false == _ContentsGroup_RenewUI_WorldMap then
      questInfo_TooltipShow(false)
    end
    FGlobal_QuestWidget_MouseOver(false)
    if true == PaGlobal_CheckedQuest:isHitTestQuestGroup(uiGroupBG) then
      return
    end
    PaGlobal_CheckedQuest:resizingConvenienceButtons(bgIndex, false)
  end
end
function FGlobal_QuestWidgetGetStartPosition()
  return _startPosition
end
function FGlobal_QuestWidget_UpdateList()
  PaGlobal_CheckedQuest:updateQuestList(_startPosition)
end
function FGlobal_QuestWidget_CalcScrollButtonSize()
  PaGlobal_CheckedQuest:updateScrollButtonSize()
end
function FGlobal_QuestWidget_GetSelectedNaviInfo()
  return _questGroupId, _questId, _naviInfoAgain
end
function FGlobal_QuestWidget_IsMouseOn()
  return widgetMouseOn
end
function FGlobal_QuestWidget_GetPositionList()
  return _positionList
end
function FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
  local questNo = uiQuestInfo:getQuestNo()
  if questNo._group == _positionList._questGroupId and questNo._quest == _positionList._questId then
    _positionList = {}
    if not uiQuestInfo:isCompleteBlackSpirit() then
      _questGroupId = 0
      _questId = 0
      HandleClicked_QuestWidget_FindTarget(questNo._group, questNo._quest, 0, false)
    elseif true == uiQuestInfo:isCompleteBlackSpirit() then
      FGlobal_DeleteNaviCheckFindWayPin()
      ToClient_DeleteNaviGuideByGroup(0)
    end
  end
end
function HandleClicked_QuestWidget_Show()
  if Panel_CheckedQuest:GetShow() then
    Panel_CheckedQuest:SetShow(false, false)
  else
    Panel_CheckedQuest:SetShow(true, true)
  end
end
function FGlobal_QuestWidget_Open()
  Panel_CheckedQuest:SetShow(true, true)
  Panel_MainQuest:SetShow(true, false)
  if true == _ContentsGroup_RenewUI_Chatting then
    Panel_CheckedQuest:SetShow(false)
    PaGlobalFunc_ChattingInfo_Close()
    return
  end
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_CheckedQuest, true)
  end
end
function FGlobal_QuestWidget_Close()
  Panel_CheckedQuest:SetShow(false, false)
  Panel_MainQuest:SetShow(false, false)
  if false == _ContentsGroup_RenewUI_WorldMap then
    questInfo_TooltipShow(false)
    TooltipSimple_Hide()
    if ToClient_WorldMapIsShow() then
      WorldMapPopupManager:pop()
    end
  end
end
function HandleClicked_ShowQuestInfo(questGroupId, questId, questCondition_Chk, groupTitle, questGroupCount)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if false == _ContentsGroup_RenewUI then
    local fromQuestWidget = true
    FGlobal_QuestWindow_SetProgress()
    FGlobal_QuestInfoDetail(questGroupId, questId, questCondition_Chk, groupTitle, questGroupCount, fromQuestWidget)
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  else
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    PaGlobalFunc_Quest_OpenDetail(questGroupId, questId, 0)
  end
end
function QuestNpcNavi_ClearCheckBox()
  for naviIndex = 0, PaGlobal_CheckedQuest._maxQuestListCnt - 1 do
    local elem = PaGlobal_CheckedQuest._uiList[nabiIndex]
    elem._uiAutoNaviBtn:SetCheck(false)
  end
  for naviIndex = 0, PaGlobal_CheckedQuest._maxQuestListCnt - 1 do
    local elem = PaGlobal_CheckedQuest._uiList[nabiIndex]
    elem._uiNaviBtn:SetCheck(false)
  end
  ToClient_DeleteNaviGuideByGroup(0)
end
function HandleClicked_QuestWidget_FindTarget(questGroupId, questId, condition, isAuto)
  if false == _ContentsGroup_RenewUI then
    PaGlobal_TutorialManager:handleClickedQuestWidgetFindTarget(questGroupId, questId, condition, isAuto)
  end
  if _questGroupId == questGroupId and _questId == questId then
    if false == _ContentsGroup_RenewUI then
      if false == _naviInfoAgain then
        ToClient_DeleteNaviGuideByGroup(0)
        audioPostEvent_SystemUi(0, 15)
        _AudioPostEvent_SystemUiForXBOX(0, 15)
        _naviInfoAgain = true
      else
        _naviInfoAgain = false
        _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
      end
    else
      _naviInfoAgain = false
      _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
      local questInfo = questList_getQuestStatic(questGroupId, questId)
      if nil ~= questInfo then
        local questPosCount = questInfo:getQuestPositionCount()
        if 0 == questPosCount and 0 ~= condition and 99 ~= condition then
          Proc_ShowMessage_Ack("Navigation is not available for this quest.")
        else
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_PROCMESSAGE_QUEST_ALEADY_FINDWAY"))
        end
      end
    end
  else
    _questGroupId = questGroupId
    _questId = questId
    _naviInfoAgain = false
    _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
  end
  _isAutoRun = isAuto
  FGlobal_MainQuest_Update()
  FGlobal_LatestQuest_UpdateList()
  FGlobal_QuestWidget_UpdateList()
  if false == _ContentsGroup_RenewUI then
    FGlobal_QuestWindow_Update_FindWay(questGroupId, questId, isAuto)
  end
end
function _QuestWidget_FindTarget_Auto(questGroupId, questId, condition, _isAutoRun, bgIdx)
  if true == _ContentsGroup_RenewUI then
    return
  end
  _autoNaviGuide.groupKey = questGroupId
  _autoNaviGuide.questKey = questId
  _questGroupId = questGroupId
  _questId = questId
  _naviInfoAgain = false
  local uiNaviBtn = PaGlobal_CheckedQuest._uiList[bgIdx]._uiNaviBtn
  local uiSelectBG = PaGlobal_CheckedQuest._uiList[bgIdx]._uiSelectBG
  if nil ~= uiNaviBtn then
    uiNaviBtn:SetCheck(true)
    uiSelectBG:SetShow(true)
    _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, _isAutoRun)
  end
end
local navigationGuideParam = NavigationGuideParam()
function _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
  ToClient_DeleteNaviGuideByGroup(0)
  PaGlobal_CheckedQuest._uiGuideButton:SetCheck(false)
  local questInfo = questList_getQuestStatic(questGroupId, questId)
  if nil == questInfo then
    return
  end
  local isGuideAutoErase = questInfo:isGuideAutoErase()
  navigationGuideParam._questGroupNo = questGroupId
  navigationGuideParam._questNo = questId
  navigationGuideParam._isAutoErase = isGuideAutoErase
  if 0 == condition then
    local npcData = npcByCharacterKey_getNpcInfo(questInfo:getCompleteNpc(), questInfo:getCompleteDialogIndex())
    if nil ~= npcData then
      if npcData:hasTimeSpawn() and false == npcData:isTimeSpawn(math.floor(getIngameTime_minute() / 60)) then
        local _errorMsg = PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_NPC_VACATION")
        Proc_ShowMessage_Ack(_errorMsg)
      end
      posX = npcData:getPosition().x
      posY = npcData:getPosition().y
      posZ = npcData:getPosition().z
      worldmapNavigatorStart(float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
      audioPostEvent_SystemUi(0, 14)
      _AudioPostEvent_SystemUiForXBOX(0, 14)
    end
  elseif 99 == condition then
    local npcData = npcByCharacterKey_getNpcInfo(questInfo:getAccecptNpc(), questInfo:getAccecptDialogIndex())
    if nil ~= npcData then
      if npcData:hasTimeSpawn() and false == npcData:isTimeSpawn(math.floor(getIngameTime_minute() / 60)) then
        local _errorMsg = PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_NPC_VACATION")
        Proc_ShowMessage_Ack(_errorMsg)
      end
      posX = npcData:getPosition().x
      posY = npcData:getPosition().y
      posZ = npcData:getPosition().z
      worldmapNavigatorStart(float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
      audioPostEvent_SystemUi(0, 14)
      _AudioPostEvent_SystemUiForXBOX(0, 14)
    end
  else
    local questPosCount = questInfo:getQuestPositionCount()
    if 0 ~= questPosCount then
      _positionList = {}
      _positionList._questGroupId = questGroupId
      _positionList._questId = questId
      local totalLength = 0
      for questPositionIndex = 0, questPosCount - 1 do
        local questPosInfo = questInfo:getQuestPositionAt(questPositionIndex)
        posX = questPosInfo._position.x
        posY = questPosInfo._position.y
        posZ = questPosInfo._position.z
        _positionList[questPositionIndex] = {}
        _positionList[questPositionIndex]._key = worldmapNavigatorStart(float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
        _positionList[questPositionIndex]._radius = questPosInfo._radius
        _positionList[questPositionIndex]._startRate = totalLength
        totalLength = totalLength + _positionList[questPositionIndex]._radius
      end
      if 0 < questPosCount - 1 then
        local randomRate = math.random(0, 100) / 100
        local randomIndex = 0
        for idx = 0, questPosCount - 1 do
          if randomRate > _positionList[idx]._startRate / totalLength and randomRate < (_positionList[idx]._startRate + _positionList[idx]._radius) / totalLength then
            randomIndex = idx
            break
          end
        end
        local selfPlayer = getSelfPlayer():get()
        if selfPlayer:getNavigationMovePathIndex() ~= _positionList[randomIndex]._key then
          if ToClient_GetNaviGuideGroupNo(_positionList[randomIndex]._key) ~= 0 then
            ToClient_DeleteNaviGuideByGroup(0)
          end
          selfPlayer:setNavigationMovePath(_positionList[randomIndex]._key)
          selfPlayer:checkNaviPathUI(_positionList[randomIndex]._key)
        end
      end
      if TutorialQuestCompleteCheck() then
        audioPostEvent_SystemUi(0, 14)
        _AudioPostEvent_SystemUiForXBOX(0, 14)
      end
    else
    end
  end
  if true == _ContentsGroup_RenewUI then
    PaGlobalFunc_Quest_UpdateFindingQuestInfo(questGroupId, questId, true)
  end
end
local questConditionType = {
  eQuestProgressingState_yetAccept = 0,
  eQuestProgressingState_Accept = 1,
  eQuestProgressingState_Complete = 2,
  eQuestProgressingState_AlreadyComplete = 3,
  eQuestProgressingState_Count = 4
}
local convertQuestConditionToNaviFindType = {
  [questConditionType.eQuestProgressingState_yetAccept] = 99,
  [questConditionType.eQuestProgressingState_Accept] = 1,
  [questConditionType.eQuestProgressingState_Complete] = 0,
  [questConditionType.eQuestProgressingState_AlreadyComplete] = 99
}
function FromClient_SetQuestNavigationByServer(questGroupId, questId, condition)
  local questCondition = convertQuestConditionToNaviFindType[condition]
  if nil == questCondition then
    return
  end
  _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, questCondition, false)
end
function _askAutoRun_FromNaviClick()
  local messageboxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageboxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_ASKAUTORUN_MSG")
  local messageboxData = {
    title = messageboxTitle,
    content = messageboxMemo,
    functionYes = _doAutoRun_FromNaviClick,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function _doAutoRun_FromNaviClick()
end
function _QuestWidget_ReturnQuestState()
  return _questGroupId, _questId, _naviInfoAgain
end
function HandleClicked_CallBlackSpirit()
  if false == Panel_Window_Exchange:GetShow() then
    if not IsSelfPlayerWaitAction() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
      return
    end
    ToClient_AddBlackSpiritFlush()
  end
end
function HandleClicked_QuestWidget_GuideQuest_MouseOver(isOn)
  PaGlobal_CheckedQuest._uiGuideButton_Desc:SetSize(PaGlobal_CheckedQuest._uiGuideButton_Desc:GetTextSizeX() + 50, PaGlobal_CheckedQuest._uiGuideButton_Desc:GetSizeY())
  PaGlobal_CheckedQuest._uiGuideButton_Desc:SetPosX(PaGlobal_CheckedQuest._uiGuideButton:GetPosX() - PaGlobal_CheckedQuest._uiGuideButton_Desc:GetSizeX() + 35)
  PaGlobal_CheckedQuest._uiGuideButton_Desc:SetPosY(PaGlobal_CheckedQuest._uiGuideButton:GetPosY() + 35)
  if isOn then
    PaGlobal_CheckedQuest._uiGuideButton_Desc:SetShow(true)
    PaGlobal_CheckedQuest._uiGuideButton_Desc:SetAlpha(0)
    PaGlobal_CheckedQuest._uiGuideButton_Desc:SetFontAlpha(0)
    PaGlobal_CheckedQuest._uiGuideButton_Desc:ResetVertexAni()
    UIAni.AlphaAnimation(1, PaGlobal_CheckedQuest._uiGuideButton_Desc, 0, 0.15)
  else
    PaGlobal_CheckedQuest._uiGuideButton_Desc:ResetVertexAni()
    local AniInfo = UIAni.AlphaAnimation(0, PaGlobal_CheckedQuest._uiGuideButton_Desc, 0, 0.1)
    AniInfo:SetHideAtEnd(true)
  end
  FGlobal_QuestWidget_MouseOver(isOn)
end
function HandleClicked_QuestNew_MouseOver(isOn)
  PaGlobal_CheckedQuest._uiHistoryButton_Desc:SetPosX(PaGlobal_CheckedQuest._uiHistoryButton:GetPosX() - PaGlobal_CheckedQuest._uiHistoryButton_Desc:GetSizeX() + 35)
  PaGlobal_CheckedQuest._uiHistoryButton_Desc:SetPosY(PaGlobal_CheckedQuest._uiHistoryButton:GetPosY() + 35)
  if isOn then
    PaGlobal_CheckedQuest._uiHistoryButton_Desc:SetShow(true)
    PaGlobal_CheckedQuest._uiHistoryButton_Desc:SetAlpha(0)
    PaGlobal_CheckedQuest._uiHistoryButton_Desc:SetFontAlpha(0)
    PaGlobal_CheckedQuest._uiHistoryButton_Desc:ResetVertexAni()
    UIAni.AlphaAnimation(1, PaGlobal_CheckedQuest._uiHistoryButton_Desc, 0, 0.15)
  else
    PaGlobal_CheckedQuest._uiHistoryButton_Desc:ResetVertexAni()
    local AniInfo1 = UIAni.AlphaAnimation(0, PaGlobal_CheckedQuest._uiHistoryButton_Desc, 0, 0.1)
    AniInfo1:SetHideAtEnd(true)
  end
  FGlobal_QuestWidget_MouseOver(isOn)
end
function HandleClicked_QuestWidget_GuideQuest()
  if Panel_Collect_Bar:GetShow() or Panel_Product_Bar:GetShow() or Panel_Enchant_Bar:GetShow() then
    return
  end
  if Panel_Global_Manual:GetShow() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAMING_DO_NOT_USE"))
    return
  end
  local doGuideQuestCount = questList_getDoGuideQuestCount()
  if false == _guideQuestChechk then
    ToClient_DeleteNaviGuideByGroup(0)
    for guideIndex = 1, doGuideQuestCount do
      local doGuideQuest = questList_getDoGuideQuestAt(guideIndex - 1)
      if questList_isSelectQuest(doGuideQuest:getSelectType()) then
        local spawnData = npcByCharacterKey_getNpcInfo(doGuideQuest:getAccecptNpc(), doGuideQuest:getAccecptDialogIndex())
        local guideQuestPos
        if nil ~= spawnData then
          local npcPosition = spawnData:getPosition()
          guideQuestPos = float3(npcPosition.x, npcPosition.y, npcPosition.z)
        end
        ToClient_WorldMapNaviStart(guideQuestPos, NavigationGuideParam(), false, false)
      end
    end
    _guideQuestChechk = true
    PaGlobal_CheckedQuest._uiGuideButton:SetCheck(true)
    if ToClient_WorldMapIsShow() then
      return
    end
    FGlobal_PushOpenWorldMap()
  else
    if ToClient_WorldMapIsShow() then
      return
    end
    ToClient_DeleteNaviGuideByGroup(0)
    _guideQuestChechk = false
    PaGlobal_CheckedQuest._uiGuideButton:SetCheck(false)
  end
end
function _QuestWidget_QuestToolTipShow(questGroupIndex, questIndex)
  QuestInfoData.questCheckDescShowWindow2(questGroupIndex, questIndex)
end
function _QuestWidget_QuestToolTipHide()
  QuestInfoData.questDescHideWindow()
end
function guildQuestWidget_MouseOn(isShow)
  local control = PaGlobal_CheckedQuest._guildQuest._ControlBG
  if true == isShow then
    QuestInfoData.guildQuestDescShowWindow()
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 1, 64, 63, 126)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:SetAlpha(1)
  else
    QuestInfoData.questDescHideWindow()
    control:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlackPanel_Series.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, 127, 127, 189, 189)
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
    control:SetAlpha(0)
  end
end
local orgMouseY = 0
local orgPanelSizeY = 0
local orgPanelPosY = 0
function HandleClicked_QuestWidgetPanelSize()
  local panel = Panel_CheckedQuest
  orgMouseY = getMousePosY()
  orgPanelPosY = panel:GetPosY()
  orgPanelSizeY = panel:GetSizeY()
end
function HandleClicked_QuestWidgetPanelResize()
  local panel = Panel_CheckedQuest
  local currentY = getMousePosY()
  local deltaY = currentY - orgMouseY
  local panelPosY = panel:GetPosY()
  local panelSizeX = panel:GetSizeX()
  local panelSizeY = panel:GetSizeY()
  local mousePosY = getMousePosY()
  if orgPanelSizeY + deltaY > 300 and orgPanelSizeY + deltaY < 700 then
    Panel_CheckedQuest:SetSize(panelSizeX, orgPanelSizeY + deltaY)
    PaGlobal_CheckedQuest._uiTransBG:SetSize(panelSizeX, orgPanelSizeY + deltaY)
  end
  if panel:GetSizeY() > 300 then
    CheckedQuest_SizeY = panel:GetSizeY()
  end
  PaGlobal_CheckedQuest._uiResizeButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  PaGlobal_CheckedQuest._uiGuideButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  PaGlobal_CheckedQuest._uiHistoryButton:SetPosY(Panel_CheckedQuest:GetSizeY())
  PaGlobal_CheckedQuest._uiFindGuild:SetPosY(Panel_CheckedQuest:GetSizeY())
  local guide_button = PaGlobal_CheckedQuest._uiGuideButton
  local guide_number = PaGlobal_CheckedQuest._uiGuideNumber
  guide_number:SetPosX(guide_button:GetPosX() + guide_button:GetSizeX() - guide_number:GetSizeX() / 2 - 7)
  guide_number:SetPosY(guide_button:GetPosY() + guide_button:GetSizeY() - guide_number:GetSizeY() / 2 - 7)
  PaGlobal_CheckedQuest:updateQuestList(_startPosition)
  PaGlobal_CheckedQuest:updateScrollButtonSize()
  ToClient_SaveUiInfo(false)
end
function HandleClicked_QuestWidgetSaveResize()
  ToClient_SaveUiInfo(false)
end
function HandleOn_QuestWidgetPanelResize(isShow)
  FGlobal_QuestWidget_MouseOver(isShow)
end
local _tmpGroupId, _tmpQuestId
function FGlobal_PassGroupIdQuestId(groupId, questId)
  if nil == groupId and nil == questId then
    return _tmpGroupId, _tmpQuestId
  else
    _tmpGroupId = groupId
    _tmpQuestId = questId
  end
end
function HandleClicked_QuestWidget_QuestGiveUp(groupId, questId)
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
function QuestWidget_QuestGiveUp_Confirm()
  local groupId, questId = FGlobal_PassGroupIdQuestId()
  ToClient_GiveupQuest(groupId, questId)
  if true == Panel_CheckedQuestInfo:GetShow() then
    if Panel_CheckedQuestInfo:IsUISubApp() then
      Panel_CheckedQuestInfo:CloseUISubApp()
    end
    Panel_CheckedQuestInfo:SetShow(false)
  end
end
function HandleClicked_QuestReward_Show(groupId, questId, window)
  local questReward = questList_getQuestStatic(groupId, questId)
  local baseCount = questReward:getQuestBaseRewardCount()
  local selectCount = questReward:getQuestSelectRewardCount()
  local _baseReward = {}
  for baseReward_index = 1, baseCount do
    local baseReward = questReward:getQuestBaseRewardAt(baseReward_index - 1)
    _baseReward[baseReward_index] = {}
    _baseReward[baseReward_index]._type = baseReward:getType()
    if __eRewardExp == baseReward:getType() then
      _baseReward[baseReward_index]._exp = baseReward:getExperience()
    elseif __eRewardSkillExp == baseReward:getType() then
      _baseReward[baseReward_index]._exp = baseReward:getSkillExperience()
    elseif __eRewardLifeExp == baseReward:getType() then
      _baseReward[baseReward_index]._exp = baseReward:getProductExperience()
    elseif __eRewardItem == baseReward:getType() then
      _baseReward[baseReward_index]._item = baseReward:getItemEnchantKey()
      _baseReward[baseReward_index]._count = baseReward:getItemCount()
    elseif __eRewardIntimacy == baseReward:getType() then
      _baseReward[baseReward_index]._character = baseReward:getIntimacyCharacter()
      _baseReward[baseReward_index]._value = baseReward:getIntimacyValue()
    elseif __eRewardKnowledge == baseReward:getType() then
      _baseReward[baseReward_index]._mentalCard = baseReward:getMentalCardKey()
    end
  end
  local _selectReward = {}
  for selectReward_index = 1, selectCount do
    local selectReward = questReward:getQuestSelectRewardAt(selectReward_index - 1)
    _selectReward[selectReward_index] = {}
    _selectReward[selectReward_index]._type = selectReward:getType()
    if __eRewardExp == selectReward:getType() then
      _selectReward[selectReward_index]._exp = selectReward:getExperience()
    elseif __eRewardSkillExp == selectReward:getType() then
      _selectReward[selectReward_index]._exp = selectReward:getSkillExperience()
    elseif __eRewardLifeExp == selectReward:getType() then
      _selectReward[selectReward_index]._exp = selectReward:getProductExperience()
    elseif __eRewardItem == selectReward:getType() then
      _selectReward[selectReward_index]._item = selectReward:getItemEnchantKey()
      _selectReward[selectReward_index]._count = selectReward:getItemCount()
    elseif __eRewardIntimacy == selectReward:getType() then
      _selectReward[selectReward_index]._character = selectReward:getIntimacyCharacter()
      _selectReward[selectReward_index]._value = selectReward:getIntimacyValue()
    elseif __eRewardKnowledge == selectReward:getType() then
      _selectReward[selectReward_index]._mentalCard = selectReward:getMentalCardKey()
    end
  end
  if false == _ContentsGroup_NewUI_Dialog_All then
    FGlobal_ShowRewardList(false)
    FGlobal_SetRewardList(_baseReward, _selectReward, nil)
    Panel_Npc_Quest_Reward:SetPosX(getMousePosX() - Panel_Npc_Quest_Reward:GetSizeX() - 10)
    Panel_Npc_Quest_Reward:SetPosY(getMousePosY())
    FGlobal_ShowRewardList(true)
  end
  if false == _ContentsGroup_RenewUI and false == _ContentsGroup_NewUI_Dialog_All and Panel_Window_Quest_New:IsUISubApp() == true then
    Panel_Npc_Quest_Reward:OpenUISubApp()
  end
end
local darkSpiritFirstTime = true
function FromClient_Panel_updateBlackSpirit()
  local playerLevel = getSelfPlayer():get():getLevel()
  if darkSpiritFirstTime == true and isClearedQuest == true then
    PaGlobal_CheckedQuest._uiDarkSpirit:EraseAllEffect()
    PaGlobal_CheckedQuest._uiDarkSpirit:AddEffect("fUI_uiDarkSpirit_Tutorial", true, 0, 0)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetShow(true)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_HELP"))
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosX(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosX() + 140)
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosY(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosY() + 50)
    darkSpiritFirstTime = false
  elseif playerLevel >= 5 then
    PaGlobal_CheckedQuest._uiDarkSpirit:SetShow(false)
    PaGlobal_CheckedQuest._uiDarkSpirit:EraseAllEffect()
    PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetShow(false)
  end
end
registerEvent("EventCharacterInfoUpdate", "FromClient_Panel_updateBlackSpirit")
function QuestAutoNpcNavi_Over(isNpcNaviShow)
  local playerLevel = getSelfPlayer():get():getLevel()
  if playerLevel >= 4 then
    if isNpcNaviShow == true then
      _questListMessage = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_AUTONPCNAVI_HELP")
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetText(_questListMessage)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - 150)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:ComputePos()
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetSize(PaGlobal_CheckedQuest._uiNotice_NpcNavi:GetSizeX(), PaGlobal_CheckedQuest._uiNotice_NpcNavi:GetSizeY())
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetAlpha(0)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetFontAlpha(0)
      UIAni.AlphaAnimation(1, PaGlobal_CheckedQuest._uiNotice_NpcNavi, 0, 0.2)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetShow(true)
    else
      local aniInfo = UIAni.AlphaAnimation(0, PaGlobal_CheckedQuest._uiNotice_NpcNavi, 0, 0.2)
      aniInfo:SetHideAtEnd(true)
    end
  elseif playerLevel >= 1 and isClearedQuest == true then
    if isNpcNaviShow == true then
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_NPCNAVI"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
    else
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_HELP"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosX(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosX() + 140)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosY(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosY() + 50)
      darkSpiritFirstTime = false
    end
  end
end
function QuestNpcNavi_Over(isNpcNaviShow)
  local playerLevel = getSelfPlayer():get():getLevel()
  if playerLevel >= 4 then
    if Panel_Help:GetShow() then
      if isNpcNaviShow == true then
        Button_NpcNaviOn()
      else
        Button_NpcNaviOut()
      end
    end
    if isNpcNaviShow == true then
      _questListMessage = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_NPCNAVI_HELP")
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetText(_questListMessage)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - 150)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:ComputePos()
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetSize(PaGlobal_CheckedQuest._uiNotice_NpcNavi:GetSizeX(), PaGlobal_CheckedQuest._uiNotice_NpcNavi:GetSizeY())
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetAlpha(0)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetFontAlpha(0)
      UIAni.AlphaAnimation(1, _uiNotice_NpcNavi, 0, 0.2)
      PaGlobal_CheckedQuest._uiNotice_NpcNavi:SetShow(true)
    else
      local aniInfo = UIAni.AlphaAnimation(0, _uiNotice_NpcNavi, 0, 0.2)
      aniInfo:SetHideAtEnd(true)
    end
  elseif playerLevel >= 1 and isClearedQuest == true then
    if isNpcNaviShow == true then
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_NPCNAVI"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
    else
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_HELP"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosX(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosX() + 140)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosY(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosY() + 50)
      darkSpiritFirstTime = false
    end
  end
end
function questGiveUp_Over(isGiveShow)
  local playerLevel = getSelfPlayer():get():getLevel()
  if playerLevel >= 4 then
    if isGiveShow == true then
      _questListMessage = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_GIVEUP_HELP")
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetText(_questListMessage)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetSpanSize(10, 0)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - _uiNotice_GiveUp:GetSizeX())
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:ComputePos()
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetSize(_uiNotice_GiveUp:GetSizeX(), _uiNotice_GiveUp:GetSizeY())
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetAlpha(0)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetFontAlpha(0)
      UIAni.AlphaAnimation(1, _uiNotice_GiveUp, 0, 0.2)
      PaGlobal_CheckedQuest._uiNotice_GiveUp:SetShow(true)
    else
      local aniInfo = UIAni.AlphaAnimation(0, _uiNotice_GiveUp, 0, 0.2)
      aniInfo:SetHideAtEnd(true)
    end
  elseif playerLevel >= 1 and isClearedQuest == true then
    if isGiveShow == true then
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_GIVEUP"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
    else
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_HELP"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosX(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosX() + 140)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosY(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosY() + 50)
      darkSpiritFirstTime = false
    end
  end
end
function QuestReward_Over(isRewardShow)
  local playerLevel = getSelfPlayer():get():getLevel()
  if playerLevel >= 4 then
    if isRewardShow == true then
      _questListMessage = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_REWARD_HELP")
      PaGlobal_CheckedQuest._uiNotice_Reward:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiNotice_Reward:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiNotice_Reward:SetText(_questListMessage)
      PaGlobal_CheckedQuest._uiNotice_Reward:SetPosX(getMousePosX() - Panel_CheckedQuest:GetPosX() - PaGlobal_CheckedQuest._uiNotice_Reward:GetSizeX())
      PaGlobal_CheckedQuest._uiNotice_Reward:SetPosY(getMousePosY() - Panel_CheckedQuest:GetPosY() - 60)
      PaGlobal_CheckedQuest._uiNotice_Reward:ComputePos()
      PaGlobal_CheckedQuest._uiNotice_Reward:SetSize(PaGlobal_CheckedQuest._uiNotice_Reward:GetSizeX(), PaGlobal_CheckedQuest._uiNotice_Reward:GetSizeY())
      PaGlobal_CheckedQuest._uiNotice_Reward:SetAlpha(0)
      PaGlobal_CheckedQuest._uiNotice_Reward:SetFontAlpha(0)
      UIAni.AlphaAnimation(1, _uiNotice_Reward, 0, 0.2)
      PaGlobal_CheckedQuest._uiNotice_Reward:SetShow(true)
    else
      local aniInfo = UIAni.AlphaAnimation(0, _uiNotice_Reward, 0, 0.2)
      aniInfo:SetHideAtEnd(true)
    end
  elseif playerLevel >= 1 and isClearedQuest == true then
    if isRewardShow == true then
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_REWARD"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(_uiDarkSpirit_Notice:GetSizeX() + 5, _uiDarkSpirit_Notice:GetSizeY() + 30)
    else
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetAutoResize(true)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(220, 86)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetTextMode(UI_TM.eTextMode_AutoWrap)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTLIST_uiDarkSpirit_HELP"))
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetSize(PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeX() + 5, PaGlobal_CheckedQuest._uiDarkSpirit_Notice:GetSizeY() + 30)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosX(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosX() + 140)
      PaGlobal_CheckedQuest._uiDarkSpirit_Notice:SetPosY(PaGlobal_CheckedQuest._uiDarkSpirit:GetPosY() + 50)
      darkSpiritFirstTime = false
    end
  end
end
function FromClient_SetQuestType(questType)
  local QuestListInfo = ToClient_GetQuestList()
  QuestListInfo:setQuestSelectType(questType, true)
end
function HandleClieked_CheckedQuest_WantJoinGuild()
  if PaGlobal_CheckedQuest._uiFindGuild:IsCheck() then
    ToClient_SetJoinedMode(0)
  else
    ToClient_SetJoinedMode(1)
  end
end
function HandleOn_CheckedQuest_WantJoinGuild(isShow)
  FGlobal_QuestWidget_MouseOver(isShow)
  FindGuild_Button_Simpletooltips(isShow)
end
function EventRadingOnQuest(questStaticWrapper, index)
  if nil == questStaticWrapper then
    return
  end
  local uiQuestInfo = questStaticWrapper
  local npcData = npcByCharacterKey_getNpcInfo(uiQuestInfo:getCompleteNpc(), uiQuestInfo:getCompleteDialogIndex())
  if nil ~= npcData then
    HandleClicked_QuestWidget_FindTarget(uiQuestInfo:getQuestNo()._group, uiQuestInfo:getQuestNo()._quest, 0, false)
  end
end
function EventUnradingOnQuest(questStaticWrapper, index)
  audioPostEvent_SystemUi(0, 15)
  _AudioPostEvent_SystemUiForXBOX(0, 15)
  ToClient_DeleteNaviGuideByGroup(0)
end
registerEvent("EventRadingOnQuest", "EventRadingOnQuest")
registerEvent("EventUnradingOnQuest", "EventUnradingOnQuest")
local checkQuest_posX = 0
local checkQuest_posY = 0
function FromClient_UpdateQuestSetPos()
  PaGlobal_CheckedQuest:updateQuestList(_startPosition)
  local newEquipGap = 0
  if true == Panel_NewEquip:GetShow() then
    newEquipGap = Panel_NewEquip:GetSizeY()
    local _x1 = Panel_NewEquip:GetPosX()
    local _x2 = Panel_NewEquip:GetPosX() + Panel_NewEquip:GetSizeX()
    local _y1 = Panel_NewEquip:GetPosY()
    local _y2 = Panel_NewEquip:GetPosY() + Panel_NewEquip:GetSizeY()
    local x1 = Panel_CheckedQuest:GetPosX()
    local x2 = Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX()
    local y1 = Panel_CheckedQuest:GetPosY()
    local y2 = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY()
    for xx = x1, x2, 10 do
      for yy = y1, y2, 10 do
        if xx >= _x1 and xx <= _x2 and yy >= _y1 and yy <= _y2 then
          Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 65 + newEquipGap)
        end
      end
    end
  end
  local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
  if not haveServerPosotion then
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 65 + newEquipGap)
  end
  if getScreenSizeX() < Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX() or getScreenSizeY() < Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY() then
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 65 + newEquipGap)
  end
end
function QuestListChecked_EnableSimpleUI()
  PaGlobal_CheckedQuest:updateQuestList(_startPosition)
end
registerEvent("EventSimpleUIEnable", "QuestListChecked_EnableSimpleUI")
registerEvent("EventSimpleUIDisable", "QuestListChecked_EnableSimpleUI")
local rateValue
function FGlobal_QuestWindowRateSetting()
  rateValue = {}
  local sizeWithOutPanelX = getScreenSizeX() - Panel_CheckedQuest:GetSizeX()
  local sizeWithOutPanelY = getScreenSizeY() - Panel_CheckedQuest:GetSizeY()
  rateValue.x = math.max(math.min(Panel_CheckedQuest:GetPosX() / sizeWithOutPanelX, 1), 0)
  rateValue.y = math.max(math.min(Panel_CheckedQuest:GetPosY() / sizeWithOutPanelY, 1), 0)
end
function FromClient_questWidget_ResetPosition()
  if true == ToClient_isConsole() then
    Panel_CheckedQuest:SetShow(false)
    return
  end
  local newEquipGap = 0
  if true == Panel_NewEquip:GetShow() then
    newEquipGap = Panel_NewEquip:GetSizeY()
    local _x1 = Panel_NewEquip:GetPosX()
    local _x2 = Panel_NewEquip:GetPosX() + Panel_NewEquip:GetSizeX()
    local _y1 = Panel_NewEquip:GetPosY()
    local _y2 = Panel_NewEquip:GetPosY() + Panel_NewEquip:GetSizeY()
    local x1 = Panel_CheckedQuest:GetPosX()
    local x2 = Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX()
    local y1 = Panel_CheckedQuest:GetPosY()
    local y2 = Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY()
    for xx = x1, x2, 20 do
      for yy = y1, y2, 20 do
        if xx >= _x1 and xx <= _x2 and yy >= _y1 and yy <= _y2 then
          Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
          Panel_CheckedQuest:SetPosY(Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() + 130 + newEquipGap)
          break
        end
      end
    end
  end
  if Panel_CheckedQuest:GetRelativePosX() == -1 and Panel_CheckedQuest:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20
    local initPosY = FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 130 + newEquipGap
    local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosotion then
      Panel_CheckedQuest:SetPosX(initPosX)
      Panel_CheckedQuest:SetPosY(initPosY)
    end
    changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_CheckedQuest, initPosX, initPosY)
  elseif Panel_CheckedQuest:GetRelativePosX() == 0 and Panel_CheckedQuest:GetRelativePosY() == 0 then
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + Panel_MainQuest:GetSizeY() + 20 + newEquipGap)
  else
    Panel_CheckedQuest:SetPosX(getScreenSizeX() * Panel_CheckedQuest:GetRelativePosX() - Panel_CheckedQuest:GetSizeX() / 2)
    Panel_CheckedQuest:SetPosY(getScreenSizeY() * Panel_CheckedQuest:GetRelativePosY() - Panel_CheckedQuest:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_CheckedQuest)
end
function renderModeChange_FromClient_questWidget_ResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_questWidget_ResetPosition()
end
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_FromClient_questWidget_ResetPosition")
function TutorialQuestCompleteCheck()
  return questList_isClearQuest(104, 1) or 15 <= getSelfPlayer():get():getLevel()
end
function QuestWidget_DefaultTextureFunction()
end
registerEvent("updateProgressQuestList", "FromClient_UpdateQuestSetPos")
registerEvent("FromClient_UpdateProgressGuildQuestList", "FromClient_UpdateQuestSetPos")
registerEvent("FromClient_UpdateQuestList", "FromClient_QuestWidget_Update")
registerEvent("onScreenResize", "FromClient_questWidget_ResetPosition")
registerEvent("FromClient_SetQuestNavigationByServer", "FromClient_SetQuestNavigationByServer")
registerEvent("FromClient_SetQuestType", "FromClient_SetQuestType")
registerEvent("FromClient_UpdateQuestSortType", "QuestWidget_DefaultTextureFunction")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CheckedQuest")
registerEvent("FromClient_ChangeQuestWidgetType", "FromClient_ChangeQuestWidgetType")
function FromClient_ChangeQuestWidgetType()
  FromClient_QuestWidget_Update()
end
function FromClient_luaLoadComplete_CheckedQuest()
  QuestWidget_NationalCheck()
  if false == CheckTutorialEnd() then
    local QuestListInfo = ToClient_GetQuestList()
    for ii = 0, MAX_QUEST_FAVOR_TYPE - 1 do
      QuestListInfo:setQuestSelectType(ii, false)
    end
    QuestListInfo:setQuestSelectType(1, true)
  end
  FromClient_QuestWidget_Update()
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiResizeButton, 9999)
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiGuideButton, 9999)
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiGuideNumber, 9999)
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiHistoryButton, 9999)
  Panel_CheckedQuest:SetChildIndex(PaGlobal_CheckedQuest._uiFindGuild, 9999)
  FGlobal_PanelMove(Panel_CheckedQuest, true)
end
function FromClient_StartQuestNavigationGuide(questNoRaw)
  local questInfoWrapper = questList_getQuestInfo(questNoRaw)
  if nil ~= questInfoWrapper then
    _questGroupId = 0
    _questId = 0
    HandleClicked_QuestWidget_FindTarget(questInfoWrapper:getQuestNo()._group, questInfoWrapper:getQuestNo()._quest, 1, false)
  end
end
function FGlobal_WindowQuestToggle()
  if false == _ContentsGroup_RenewUI then
    Panel_Window_QuestNew_Toggle()
  else
    PaGlobalFunc_Quest_Toggle()
  end
end
function PaGlobal_CheckedQuest_SetShowControl(isShow)
  _static_active:SetShow(isShow)
end
registerEvent("FromClient_StartQuestNavigationGuide", "FromClient_StartQuestNavigationGuide")
