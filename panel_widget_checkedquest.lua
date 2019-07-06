local UI_color = Defines.Color
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode = Defines.UIMode
local QuestType = CppEnums.QuestType
local _static_active = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local checkedQuestWidget = {
  _ui = {
    _static_GroupBG = UI.getChildControl(_static_active, "Static_GroupBG"),
    _static_TitleBG = UI.getChildControl(_static_active, "Static_TitleBG"),
    _staticText_Quest_Title = UI.getChildControl(_static_active, "StaticText_Quest_Title"),
    _static_Eff_Complete_Eff1 = UI.getChildControl(_static_active, "Static_Eff_Complete_Eff1"),
    _static_Quest_Type = UI.getChildControl(_static_active, "Static_Quest_Type"),
    _staticText_WidgetGroupTitle = UI.getChildControl(_static_active, "StaticText_WidgetGroupTitle"),
    _staticText_Quest_ClearNpc = UI.getChildControl(_static_active, "StaticText_Quest_ClearNpc"),
    _staticText_Quest_Demand = UI.getChildControl(_static_active, "StaticText_Quest_Demand"),
    _button_Hide = UI.getChildControl(_static_active, "Checkbox_Quest_Hide"),
    _button_Quest_Giveup = UI.getChildControl(_static_active, "Button_Quest_Giveup"),
    _checkbox_Quest_Navi = UI.getChildControl(_static_active, "Checkbox_Quest_Navi"),
    _checkButton_AutoNavi = UI.getChildControl(_static_active, "CheckButton_AutoNavi"),
    _button_Reward = UI.getChildControl(_static_active, "Button_Reward"),
    _button_WantGuild = UI.getChildControl(_static_active, "Button_WantGuild"),
    _button_Size = UI.getChildControl(_static_active, "Button_Size"),
    _button_Option = UI.getChildControl(_static_active, "Button_Option"),
    _staticText_Number = UI.getChildControl(_static_active, "StaticText_Number"),
    _staticText_IconHelp_BG = UI.getChildControl(_static_active, "StaticText_IconHelp_BG"),
    _frame_NormalQuest = UI.getChildControl(_static_active, "Frame_Template"),
    _static_Help_MouseL = nil,
    _static_Help_MouseR = nil
  },
  _config = {
    _giveupLimitLv = 10,
    _maxQuestListCnt = 30,
    _maxConditionCnt = 5,
    _defaultButtonSize = 18,
    _extendButtonSize = 25,
    _questType = {
      _guild = 1,
      _latest = 2,
      _normal = 3
    },
    _questState = {
      _acceptable = 0,
      _progressing = 1,
      _complete = 2,
      _fail = 3
    },
    _questBG = {
      [1] = {
        182,
        1,
        211,
        30
      },
      [2] = {
        182,
        31,
        211,
        60
      },
      [3] = {
        152,
        31,
        181,
        60
      }
    }
  },
  _refUiQuestAutoNaviButton = nil,
  _refUiQuestNaviButton = nil,
  _refUiQuestTitle = nil,
  _uiQuestList = {},
  _startPosition = 0,
  _setLastQuestOfList = 0,
  _questGroupCount = 0,
  _nextPosY = 0,
  _list_Space = 10,
  _shownListCount = 0,
  _questGroupId = 0,
  _questId = 0,
  _naviInfoAgain = false,
  _guideQuestChechk = false,
  _hasGuildQuest = false,
  _positionList = {},
  _isAutoRun = false,
  _elapsedTime = 10,
  _updateTime = -1,
  _welcomeToTheWorld = true,
  questNoSaveForTutorial = {_questGroupIndex, _questGroupIdx},
  _widgetMouseOn = false,
  _isInitialized = false,
  _latestQuestShowCount = 0,
  _guildData,
  _latestDataList = {},
  _normalDataList = {},
  _isGuildQuestProgressing = false,
  _questCount = 0,
  _questIndex = 0,
  _prevPos = 0,
  _isExistUpdateData = false,
  _timeAttackQuestList = {},
  _updatePastTime = 0,
  _updateCurrentTime = 0
}
function checkedQuestWidget:initialize()
  self:initControl()
  self:addInputEvent()
  self._isInitialized = true
end
function checkedQuestWidget:initControl()
  Panel_CheckedQuest:ActiveMouseEventEffect(true)
  Panel_CheckedQuest:setGlassBackground(true)
  Panel_CheckedQuest:SetDragEnable(false)
  self._ui._static_Help_MouseL = UI.getChildControl(self._ui._staticText_IconHelp_BG, "Static_Help_MouseL")
  self._ui._static_Help_MouseR = UI.getChildControl(self._ui._staticText_IconHelp_BG, "Static_Help_MouseR")
  self._ui._static_Eff_Complete_Eff1:SetShow(false)
  self._ui._frame_Content = UI.getChildControl(self._ui._frame_NormalQuest, "Frame_Content")
  self._ui._frame_VerticalScroll = UI.getChildControl(self._ui._frame_NormalQuest, "Frame_VerticalScroll")
  local startPosY = 0
  for index = 0, self._config._maxQuestListCnt - 1 do
    local elements = {}
    local parentPanel
    if index < 4 then
      parentPanel = _static_active
    else
      parentPanel = self._ui._frame_Content
    end
    elements._uiGroupBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_GroupBG", parentPanel, "uiGroupBG_" .. index)
    elements._uiTitleBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_TitleBG", elements._uiGroupBG, "uiTitleBG_" .. index)
    elements._uiQuestTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Title", elements._uiGroupBG, "uiQuestTitle_" .. index)
    elements._uiGroupTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_WidgetGroupTitle", elements._uiGroupBG, "uiGroupTitle_" .. index)
    elements._uiQuestIcon = UI.createAndCopyBasePropertyControl(_static_active, "Static_Quest_Type", elements._uiGroupBG, "uiQuestIcon_" .. index)
    elements._uiCompleteNpc = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_ClearNpc", elements._uiGroupBG, "uiCompleteNpc_" .. index)
    elements._uiCompleteEff = UI.createAndCopyBasePropertyControl(_static_active, "Static_Eff_Complete_Eff1", elements._uiGroupBG, "uiCompleteEff_" .. index)
    elements._uiHideBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Hide", elements._uiGroupBG, "uiCompleteBtn_" .. index)
    elements._uiAutoNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "CheckButton_AutoNavi", elements._uiGroupBG, "uiAutoNaviBtn_" .. index)
    elements._uiNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Navi", elements._uiGroupBG, "uiNaviBtn_" .. index)
    elements._uiGiveupBtn = UI.createAndCopyBasePropertyControl(_static_active, "Button_Quest_Giveup", elements._uiGroupBG, "uiGiveupBtn_" .. index)
    elements._uiRewardBtn = UI.createAndCopyBasePropertyControl(_static_active, "Button_Reward", elements._uiGroupBG, "uiRewardBtn_" .. index)
    elements._questNo = {_groupId = 0, _questId = 0}
    elements._uiConditions = Array.new()
    for jj = 0, self._config._maxConditionCnt - 1 do
      elements._uiConditions[jj] = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Demand", elements._uiGroupBG, "uiConditions_" .. index .. "_" .. jj)
      elements._uiConditions[jj]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    end
    elements._uiEndTime = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Demand", elements._uiGroupBG, "uiEndTime_" .. index)
    elements._uiGroupBG:SetPosY(startPosY)
    startPosY = startPosY + elements._uiGroupBG:GetSizeY()
    self._uiQuestList[index] = elements
  end
  self._ui._staticText_IconHelp_BG:SetColor(Defines.Color.C_FFFFFFFF)
  self._ui._staticText_IconHelp_BG:SetAlpha(1)
  self._ui._staticText_IconHelp_BG:SetNotAbleMasking(true)
  for ii = 0, self._config._maxQuestListCnt - 1 do
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiTitleBG, 9)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiQuestTitle, 10)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiQuestIcon, 10)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiCompleteEff, 9999)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiRewardBtn, 9999)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiHideBtn, 9999)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiAutoNaviBtn, 9999)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiNaviBtn, 9999)
    self._uiQuestList[ii]._uiGroupBG:SetChildIndex(self._uiQuestList[ii]._uiGiveupBtn, 9999)
    self._uiQuestList[ii]._uiCompleteEff:SetShow(false)
  end
  self._ui._frame_VerticalScroll:SetEnable(false)
end
function checkedQuestWidget:addInputEvent()
  Panel_CheckedQuest:RegisterShowEventFunc(true, "QuestListShowAni()")
  Panel_CheckedQuest:RegisterShowEventFunc(false, "QuestListHideAni()")
  Panel_CheckedQuest:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  Panel_CheckedQuest:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._ui._frame_NormalQuest:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  self._ui._frame_NormalQuest:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._ui._frame_Content:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  self._ui._frame_Content:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._ui._frame_Content:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_CheckedQuestWidget_ScrollEvent( true )")
  self._ui._frame_Content:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_CheckedQuestWidget_ScrollEvent( false )")
  self._ui._button_Size:addInputEvent("Mouse_LPress", "HandleClicked_QuestWidgetPanelResize()")
  self._ui._button_Size:addInputEvent("Mouse_LDown", "HandleClicked_QuestWidgetPanelSize()")
  self._ui._button_Size:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidgetSaveResize()")
  self._ui._button_Size:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver( true )")
  self._ui._button_Size:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false )")
  self._ui._button_WantGuild:addInputEvent("Mouse_On", "HandleOn_CheckedQuest_WantJoinGuild( true )")
  self._ui._button_WantGuild:addInputEvent("Mouse_Out", "HandleOn_CheckedQuest_WantJoinGuild( false )")
  self._ui._button_WantGuild:addInputEvent("Mouse_LUp", "HandleClieked_CheckedQuest_WantJoinGuild()")
  self._ui._button_Option:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_OptionButton()")
  self._ui._button_Option:addInputEvent("Mouse_On", "ShowTooltip_QuestWidget_OptionButton()")
  self._ui._button_Option:addInputEvent("Mouse_Out", "HideTooltip_QuestWidget_OptionButton()")
  self._ui._staticText_IconHelp_BG:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver(false)")
  self._ui._frame_VerticalScroll:addInputEvent("Mouse_UpScroll", "PaGlobalFunc_CheckedQuestWidget_ScrollEvent( true )")
  self._ui._frame_VerticalScroll:addInputEvent("Mouse_DownScroll", "PaGlobalFunc_CheckedQuestWidget_ScrollEvent( false )")
  for ii = 0, self._config._maxQuestListCnt - 1 do
    self._uiQuestList[ii]._uiGroupBG:addInputEvent("Mouse_On", "FGlobal_QuestWidget_MouseOver(  true)")
    self._uiQuestList[ii]._uiGroupBG:addInputEvent("Mouse_Out", "FGlobal_QuestWidget_MouseOver( false)")
    self._uiQuestList[ii]._uiTitleBG:addInputEvent("Mouse_On", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG( true, " .. ii .. " )")
    self._uiQuestList[ii]._uiTitleBG:addInputEvent("Mouse_Out", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG( false, " .. ii .. " )")
    self._uiQuestList[ii]._uiQuestTitle:addInputEvent("Mouse_On", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG(  true, " .. ii .. ")")
    self._uiQuestList[ii]._uiQuestTitle:addInputEvent("Mouse_Out", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG( false, " .. ii .. ")")
    self._uiQuestList[ii]._uiNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_QuestWidget_HelpPop( true, \"navi\", " .. ii .. ")")
    self._uiQuestList[ii]._uiNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_QuestWidget_HelpPop( false, \"navi\", " .. ii .. ")")
    self._uiQuestList[ii]._uiAutoNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_QuestWidget_HelpPop( true,  \"Autonavi\"," .. ii .. ")")
    self._uiQuestList[ii]._uiAutoNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_QuestWidget_HelpPop( false,  \"Autonavi\"," .. ii .. ")")
    self._uiQuestList[ii]._uiGiveupBtn:addInputEvent("Mouse_On", "HandleMouseOver_QuestWidget_HelpPop( true,  \"giveup\"," .. ii .. ")")
    self._uiQuestList[ii]._uiGiveupBtn:addInputEvent("Mouse_Out", "HandleMouseOver_QuestWidget_HelpPop( false, \"giveup\", " .. ii .. ")")
    self._uiQuestList[ii]._uiHideBtn:addInputEvent("Mouse_On", "HandleMouseOver_QuestWidget_HelpPop( true,  \"hide\"," .. ii .. ")")
    self._uiQuestList[ii]._uiHideBtn:addInputEvent("Mouse_Out", "HandleMouseOver_QuestWidget_HelpPop( false, \"hide\", " .. ii .. ")")
    self._uiQuestList[ii]._uiRewardBtn:addInputEvent("Mouse_On", "HandleMouseOver_QuestWidget_HelpPop( true,  \"reward\"," .. ii .. ")")
    self._uiQuestList[ii]._uiRewardBtn:addInputEvent("Mouse_Out", "HandleMouseOver_QuestWidget_HelpPop( false, \"reward\", " .. ii .. ")")
    for jj = 0, self._config._maxConditionCnt - 1 do
      self._uiQuestList[ii]._uiConditions[jj]:addInputEvent("Mouse_On", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG( true , " .. ii .. ")")
      self._uiQuestList[ii]._uiConditions[jj]:addInputEvent("Mouse_Out", "PaGlobalFunc_CheckedQuestWidget_ShowTitleBG( false , " .. ii .. ")")
    end
  end
end
function PaGlobalFunc_CheckedQuestWidget_ScrollEvent(isUp)
  checkedQuestWidget:scrollEventHandler(isUp)
end
function checkedQuestWidget:scrollEventHandler(isUp)
  self:setShowConditionText()
end
function PaGlobalFunc_CheckedQuestWidget_ShowTitleBG(isShow, index)
  checkedQuestWidget:questWidget_MouseOver(isShow)
  checkedQuestWidget:showTitleBG(isShow, index)
end
function checkedQuestWidget:showTitleBG(isShow, index)
  if false == isShow then
    local posY = self._uiQuestList[index]._uiGroupBG:GetPosY()
    if index > 3 then
      posY = posY + self._ui._frame_NormalQuest:GetPosY() + self._ui._frame_Content:GetPosY()
      if true == self:isHitTestQuestGroup(self._uiQuestList[index]._uiTitleBG, posY) then
        return
      end
    elseif true == self:isHitTestQuestGroup(self._uiQuestList[index]._uiTitleBG, self._uiQuestList[index]._uiGroupBG:GetPosY()) then
      return
    end
  end
  TooltipSimple_Hide()
  self:setVisibleConvenienceButtonByIndex(index, isShow)
end
function PaGlobalFunc_CheckedQuestWidget_Open()
  checkedQuestWidget:open()
end
function checkedQuestWidget:open()
  Panel_CheckedQuest:SetShow(true)
end
function PaGlobalFunc_CheckedQuestWidget_Close()
  checkedQuestWidget:close()
end
function checkedQuestWidget:close()
  Panel_CheckedQuest:SetShow(false)
end
function FromClient_QuestWidget_Update()
  checkedQuestWidget:update()
end
function checkedQuestWidget:update()
  if false == self._isInitialized then
    return
  end
  FGlobal_MainQuest_Update()
  FGlobal_ChangeWidgetType()
  self:updateQuestList(self._startPosition)
  PaGlobal_SummonBossTutorial_Manager:checkQuestCondition()
  if Panel_LifeTutorial:GetShow() then
    FGlobal_LifeTutorial_Check()
  end
end
function checkedQuestWidget:clear()
  if false == self._isInitialized then
    return
  end
  for index = 0, self._config._maxQuestListCnt - 1 do
    local uiElem = self._uiQuestList[index]
    uiElem._uiGroupBG:SetShow(false)
    uiElem._uiGroupBG:SetPosX(0)
    uiElem._uiGroupBG:SetPosY(0)
    uiElem._questNo._groupId = 0
    uiElem._questNo._questId = 0
    uiElem._questType = nil
    uiElem._uiNaviBtn:SetShow(false)
    uiElem._uiAutoNaviBtn:SetShow(false)
    uiElem._uiHideBtn:SetShow(false)
    uiElem._uiGiveupBtn:SetShow(false)
    uiElem._uiRewardBtn:SetShow(false)
    for jj = 0, self._config._maxConditionCnt - 1 do
      uiElem._uiConditions[jj]:SetShow(false)
    end
    uiElem._uiEndTime:SetShow(false)
  end
  self._ui._staticText_IconHelp_BG:SetShow(false)
  self._ui._button_Size:SetShow(false)
  self._ui._button_Option:SetShow(false)
  self._ui._button_WantGuild:SetShow(false)
  self._shownListCount = 0
  self._guildData = nil
  self._latestDataList = {}
  self._normalDataList = {}
  self._isGuildQuestProgressing = false
  self._nextPosY = 0
  self._questCount = 0
end
local UIRect = {
  left,
  top,
  right,
  bottom
}
function PaGlobalFunc_Quest_UpdatePosition()
  checkedQuestWidget:checkPosition()
end
function checkedQuestWidget:checkPosition()
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
function checkedQuestWidget:findShownQuestUiInCheckedQuest(questGroupNo, questId)
  local shownIndex = -1
  shownIndex = checkedQuestWidget:findShownIndexInCheckedQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return {
      checkedQuestWidget,
      checkedQuestWidget._uiQuestList[shownIndex]
    }
  end
  return nil
end
function checkedQuestWidget:findShownQuestUiInCheckedQuestIndex(questGroupNo, questId)
  local shownIndex = -1
  shownIndex = self:findShownIndexInCheckedQuest(questGroupNo, questId)
  if -1 ~= shownIndex then
    return shownIndex
  end
  return nil
end
function checkedQuestWidget:findShownIndexInCheckedQuest(questGroupNo, questId)
  local checkedQuestIndex = self:findQuestUiIndexInCheckedQuest(questGroupNo, questId)
  if -1 == checkedQuestIndex then
    return -1
  end
  local startIndex = self._startPosition
  local endIndex = self:getLastShownGroupIndex()
  local isShown = checkedQuestIndex >= startIndex and checkedQuestIndex <= endIndex and -1 ~= endIndex
  if true == isShown then
    return checkedQuestIndex
  end
  return -1
end
function checkedQuestWidget:addEffectQuestFindNaviButtonForTutorial(questUiInfoInPanelCheckedQuest)
  if nil ~= questUiInfoInPanelCheckedQuest[2] then
    self._refUiQuestNaviButton = questUiInfoInPanelCheckedQuest[2]._uiNaviBtn
    self._refUiQuestTitle = questUiInfoInPanelCheckedQuest[2]._uiQuestTitle
    local groupBG = questUiInfoInPanelCheckedQuest[2]._uiGroupBG
    if nil ~= self._refUiQuestNaviButton then
      self._refUiQuestNaviButton:AddEffect("fUI_Alarm01", true, 0, 0)
      self._refUiQuestTitle:AddEffect("UI_QustAccept01", true, 0, 0)
    end
    if nil == groupBG or nil == self._refUiQuestNaviButton then
      _PA_ASSERT(false, "\237\128\152\236\138\164\237\138\184 \236\156\132\236\160\175 \235\167\136\236\138\164\237\130\185 \236\160\129\236\154\169 \236\139\164\237\140\168. nil\234\176\146\236\157\180 \236\158\136\236\138\181\235\139\136\235\139\164.")
      return
    end
    local posX = groupBG:GetPosX() + self._refUiQuestNaviButton:GetPosX()
    local posY = groupBG:GetPosY() + self._refUiQuestNaviButton:GetPosY()
    PaGlobal_TutorialUiManager:getUiMasking():showQuestMasking(posX, posY)
  else
    PaGlobal_TutorialUiManager:getUiMasking():showPanelMasking(Panel_CheckedQuest)
  end
end
function checkedQuestWidget:eraseEffectQuestNaviButtonForTutorial()
  if nil ~= self._refUiQuestNaviButton then
    self._refUiQuestNaviButton:EraseAllEffect()
    self._refUiQuestTitle:EraseAllEffect()
    self._refUiQuestNaviButton = nil
    self._refUiQuestTitle = nil
  end
  PaGlobal_TutorialUiManager:getUiMasking():hideQuestMasking()
end
function checkedQuestWidget:findQuestUiIndexInCheckedQuest(questGruopNo, questId)
  for index = 0, self._config._maxQuestListCnt - 1 do
    local questNo = self._uiQuestList[index]._questNo
    if questNo._groupId == questGruopNo and questNo._questId == questId then
      return index
    end
  end
  return -1
end
function PaGlobalFunc_CheckedQuestGetQuestUiButtonPosition(questGroupNo, questId)
  local index = self:findShownQuestUiInCheckedQuestIndex(questGroupNo, questId)
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
  TooltipSimple_Show(checkedQuestWidget._ui._button_Option, name, desc)
end
function HideTooltip_QuestWidget_OptionButton()
  TooltipSimple_Hide()
  FGlobal_QuestWidget_MouseOver(false)
end
function QuestWidget_NationalCheck()
  if isGameTypeThisCountry(CppEnums.ContryCode.eContryCode_RUS) then
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
function PaGlobalFunc_QuestWidgetGetStartPosition()
  return checkedQuestWidget._startPosition
end
function PaGlobalFunc_QuestWidget_UpdateList()
  checkedQuestWidget:updateQuestList(checkedQuestWidget._startPosition)
end
function checkedQuestPanel_Init()
  local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
  if not haveServerPosotion then
    checkedQuestWidget:setPanelSize(Panel_CheckedQuest:GetSizeX(), 350)
    local newEquipGap = 0
    local posY = 0
    if true == Panel_NewEquip:GetShow() then
      newEquipGap = Panel_NewEquip:GetSizeY() + 15
    end
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10 + newEquipGap)
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 20)
    local buttonSizeY = checkedQuestWidget._ui._button_Size:GetSizeY()
    checkedQuestWidget._ui._button_Size:SetPosY(Panel_CheckedQuest:GetSizeY() - buttonSizeY)
    checkedQuestWidget._ui._button_Option:SetPosY(Panel_CheckedQuest:GetSizeY() - buttonSizeY)
    checkedQuestWidget._ui._button_WantGuild:SetPosY(Panel_CheckedQuest:GetSizeY() - buttonSizeY)
  end
end
local CheckedQuest_SizeY = Panel_CheckedQuest:GetSizeY()
function checkedQuestWidget:getLastShownGroupIndex()
  local index = -1
  for ii = 0, self._config._maxQuestListCnt - 1 do
    local uiElem = self._uiQuestList[ii]
    if true == uiElem._uiGroupBG:GetShow() then
      index = ii
    end
  end
  return index
end
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
function checkedQuestWidget:isAlreadyShown(questNo)
  if true == PaGlobalFunc_MainQuestWidget_IsShownQuest(questNo) then
    return true
  end
  for _, data in pairs(self._latestDataList) do
    if questNo._quest == data.quest and questNo._group == data.group then
      return true
    end
  end
  for _, data in pairs(self._normalDataList) do
    if questNo._quest == data.quest and questNo._group == data.group then
      return true
    end
  end
  return false
end
function checkedQuestWidget:getTotalListCount()
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
function HandleClicked_QuestShowCheck(groupId, questId)
  ToClient_ToggleCheckShow(groupId, questId)
  if true == Panel_CheckedQuestInfo:GetShow() then
    if Panel_CheckedQuestInfo:IsUISubApp() then
      Panel_CheckedQuestInfo:CloseUISubApp()
    end
    Panel_CheckedQuestInfo:SetShow(false)
  end
end
function FGlobal_CheckedQuest_SetWelcomeToTheWorld(isFirst)
  checkedQuestWidget._welcomeToTheWorld = isFirst
end
function checkedQuestWidget:updateQuestList(startPosition)
  if false == self._isInitialized then
    return
  end
  if true == ToClient_IsInstanceFieldPlayerbyContentsType(__eInstanceContentsType_SavageDefence) then
    Panel_CheckedQuest:SetShow(false)
    return
  end
  self:clear()
  self:doReleaseCheckForTutorial()
  self._shownListCount = 0
  self:setQuestDataList()
  self:setQuestUIlist()
  local sizeY = self._ui._button_Size:GetSizeY()
end
function checkedQuestWidget:setQuestUIlist()
  local uiIndex = 0
  self._timeAttackQuestList = {}
  self._updatePastTime = 0
  self._updateCurrentTime = 0
  if true == self._isGuildQuestProgressing then
    uiIndex = self:setGuildQuestUi(uiIndex)
  end
  local viewLimitCount = ToClient_GetLatestQuestShowCount()
  if viewLimitCount > 0 then
    uiIndex = self:setLatestQuestUi(uiIndex)
  end
  local posY = 0
  for ii = 0, 3 do
    if false == self._uiQuestList[ii]._uiGroupBG:GetShow() then
      break
    end
    if Panel_CheckedQuest:GetSizeY() < posY + self._uiQuestList[ii]._uiGroupBG:GetSizeY() + self._ui._button_Size:GetSizeY() then
      checkedQuestWidget:setPanelSize(Panel_CheckedQuest:GetSizeX(), posY + self._uiQuestList[ii]._uiGroupBG:GetSizeY() + self._ui._button_Size:GetSizeY())
    end
    self._uiQuestList[ii]._uiGroupBG:SetPosY(posY)
    posY = posY + self._uiQuestList[ii]._uiGroupBG:GetSizeY() + 10
  end
  if 0 < table.getn(self._normalDataList) then
    uiIndex = self:setNormalQuestUi(4)
  end
  self._questCount = uiIndex
  local sizeY = Panel_CheckedQuest:GetSizeY() - posY - self._ui._button_Size:GetSizeY()
  self._ui._frame_NormalQuest:SetSize(self._ui._frame_NormalQuest:GetSizeX(), sizeY)
  self._ui._frame_NormalQuest:SetPosX(0)
  self._ui._frame_NormalQuest:SetPosY(posY)
  posY = 0
  for ii = 4, uiIndex - 1 do
    if false == self._uiQuestList[ii]._uiGroupBG:GetShow() then
      break
    end
    self._uiQuestList[ii]._uiGroupBG:SetPosY(posY)
    posY = posY + self._uiQuestList[ii]._uiGroupBG:GetSizeY() + 10
    self._ui._frame_Content:SetSize(self._ui._frame_Content:GetSizeX(), posY)
    self._ui._frame_VerticalScroll:SetSize(self._ui._frame_VerticalScroll:GetSizeX(), posY)
    self._ui._frame_VerticalScroll:SetPosY(posY)
    self._ui._frame_VerticalScroll:SetEnableArea(0, 0, self._ui._frame_VerticalScroll:GetSizeX(), posY)
  end
  self:setShowConditionText()
  local widgetType = FGlobal_GetSelectedWidgetType()
  if CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType or self._ui._frame_NormalQuest:GetSizeY() < 50 then
    self._ui._frame_NormalQuest:SetShow(false)
  else
    self._ui._frame_NormalQuest:SetShow(true)
  end
  CheckedQuest_SizeY = Panel_CheckedQuest:GetSizeY()
  self._ui._button_Size:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  self._ui._button_WantGuild:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  self._ui._button_Option:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  if 0 < #self._timeAttackQuestList then
    Panel_CheckedQuest:RegisterUpdateFunc("Update_TimeAttackQuest")
  else
    Panel_CheckedQuest:ClearUpdateLuaFunc("Update_TimeAttackQuest")
  end
end
function Update_TimeAttackQuest(deltaTime)
  local self = checkedQuestWidget
  self._updateCurrentTime = self._updateCurrentTime + deltaTime
  if self._updateCurrentTime - self._updatePastTime < 1 then
    return
  end
  self._updatePastTime = self._updateCurrentTime
  for ii = #self._timeAttackQuestList, 1, -1 do
    local data = self._timeAttackQuestList[ii]
    local isDone = self._config._questState._complete == data.state
    local questUI = self._uiQuestList[data._index]
    if nil ~= questUI then
      local remainTime = Int64toInt32(data._endTime_s64 - getServerUtc64())
      local remainTime_s64 = data._endTime_s64 - getServerUtc64()
      if remainTime > 0 then
        questUI._uiEndTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REMAINTIME", "time", convertSecondsToClockTime(remainTime)))
      else
        questUI._uiEndTime:SetText("<PAColor0xFFF26A6A>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REAL_TIMEOVER") .. "<PAOldColor>")
        table.remove(self._timeAttackQuestList, ii)
      end
    end
  end
  if 0 == #self._timeAttackQuestList then
    Panel_CheckedQuest:ClearUpdateLuaFunc("Update_TimeAttackQuest")
  end
  if self._updateCurrentTime > 10 then
    self._updateCurrentTime = 0
    self._updatePastTime = 0
  end
end
function checkedQuestWidget:setShowConditionText()
  for index = 4, self._config._maxQuestListCnt - 1 do
    for jj = 0, self._config._maxConditionCnt - 1 do
      if 0 > self._ui._frame_Content:GetPosY() + self._uiQuestList[index]._uiGroupBG:GetPosY() + self._uiQuestList[index]._uiConditions[jj]:GetPosY() + self._uiQuestList[index]._uiConditions[jj]:GetSizeY() or self._ui._frame_NormalQuest:GetSizeY() < self._ui._frame_Content:GetPosY() + self._uiQuestList[index]._uiGroupBG:GetPosY() + self._uiQuestList[index]._uiConditions[jj]:GetPosY() then
        self._uiQuestList[index]._uiConditions[jj]:SetShow(false)
      elseif self._questCount ~= nil and index < self._questCount then
        self._uiQuestList[index]._uiConditions[jj]:SetShow(true)
      end
    end
  end
end
function checkedQuestWidget:setNormalQuestUi(uiIndex)
  for _, data in pairs(self._normalDataList) do
    local questUi = self._uiQuestList[uiIndex]
    if nil == questUi then
      return uiIndex
    end
    local isDone = data.state == self._config._questState._complete
    questUi._uiGroupBG:SetShow(true)
    self:setQuestBG(questUi._uiTitleBG, self._config._questType._normal)
    self:setQuestTitle(questUi._uiQuestTitle, data.QuestName, data.state)
    self:setQuestTypeIcon(questUi._uiQuestIcon, data.questType, isDone)
    questUi._uiTitleBG:SetShow(false)
    local startPosition = questUi._uiTitleBG:GetSizeY()
    if false == data.isSingle and nil ~= data.QuestGroupName then
      questUi._uiGroupTitle:SetFontColor(UI_color.C_FFEDE699)
      questUi._uiGroupTitle:SetText(data.QuestGroupName)
      questUi._uiGroupTitle:SetShow(true)
      questUi._uiGroupTitle:SetPosY(startPosition)
      startPosition = startPosition + questUi._uiGroupTitle:GetSizeY()
    else
      questUi._uiGroupTitle:SetShow(false)
      questUi._uiGroupTitle:SetText("")
    end
    questUi._uiCompleteNpc:SetText("")
    questUi._questNo._groupId = data.group
    questUi._questNo._questId = data.quest
    self._nextPosY = questUi._uiGroupBG:GetPosY() + questUi._uiGroupBG:GetSizeY()
    local textSize = startPosition + 5
    local index = 0
    for ii = 0, self._config._maxConditionCnt - 1 do
      questUi._uiConditions[ii]:SetText("")
    end
    for _, demandString in pairs(data.demand) do
      questUi._uiConditions[index]:SetText(demandString)
      questUi._uiConditions[index]:SetShow(true)
      questUi._uiConditions[index]:SetPosY(textSize)
      textSize = textSize + questUi._uiConditions[index]:GetTextSizeY() + 2
      if true == isDone then
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        questUi._uiConditions[index]:SetLineCount(1)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FFF26A6A)
      elseif nil ~= data.demandState and data.demandState[index + 1] == self._config._questState._complete then
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FF626262)
      else
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FFC4BEBE)
      end
      questUi._uiConditions[index]:SetLineRender(isDone)
      index = index + 1
    end
    if 0 ~= Int64toInt32(data.endTime_s64) then
      if self._config._questState._progressing == data.state then
        local updateData = {}
        updateData._index = uiIndex
        updateData._endTime_s64 = data.endTime_s64
        table.insert(self._timeAttackQuestList, updateData)
        local remainTime = Int64toInt32(data.endTime_s64 - getServerUtc64())
        questUi._uiEndTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REMAINTIME", "time", convertSecondsToClockTime(remainTime)))
      elseif isDone and 0 >= Int64toInt32(data.endTime_s64 - getServerUtc64()) then
        questUi._uiEndTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REAL_TIMEOVER"))
      else
        questUi._uiEndTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_TIMEOVER"))
      end
      questUi._uiEndTime:SetShow(true)
      questUi._uiEndTime:SetPosY(textSize)
      textSize = textSize + questUi._uiEndTime:GetTextSizeY() + 2
    else
      questUi._uiEndTime:SetShow(false)
    end
    local GroupSizeY = textSize
    questUi._uiGroupBG:SetSize(questUi._uiTitleBG:GetSizeX(), GroupSizeY)
    questUi._questType = self._config._questType._normal
    self:setNaviButtonInfo(questUi, isDone, data.isCompleteBlackSpirit)
    uiIndex = uiIndex + 1
  end
  return uiIndex
end
function checkedQuestWidget:setLatestQuestUi(uiIndex)
  for _, data in pairs(self._latestDataList) do
    local questUi = self._uiQuestList[uiIndex]
    if nil == questUi then
      return uiIndex
    end
    local isDone = data.state == self._config._questState._complete
    questUi._uiGroupBG:SetShow(true)
    self:setQuestBG(questUi._uiTitleBG, self._config._questType._latest)
    self:setQuestTitle(questUi._uiQuestTitle, data.QuestName, data.state)
    self:setQuestTypeIcon(questUi._uiQuestIcon, data.questType, isDone)
    questUi._uiTitleBG:SetShow(false)
    local startPosition = questUi._uiTitleBG:GetSizeY()
    if false == data.isSingle and nil ~= data.QuestGroupName then
      questUi._uiGroupTitle:SetFontColor(UI_color.C_FFEDE699)
      questUi._uiGroupTitle:SetText(data.QuestGroupName)
      questUi._uiGroupTitle:SetShow(true)
      questUi._uiGroupTitle:SetPosY(startPosition)
      startPosition = startPosition + questUi._uiGroupTitle:GetSizeY()
    else
      questUi._uiGroupTitle:SetShow(false)
      questUi._uiGroupTitle:SetText("")
    end
    questUi._uiCompleteNpc:SetText("")
    questUi._questNo._groupId = data.group
    questUi._questNo._questId = data.quest
    local textSize = startPosition + 5
    local index = 0
    for _, demandString in pairs(data.demand) do
      questUi._uiConditions[index]:SetText(demandString)
      questUi._uiConditions[index]:SetShow(true)
      questUi._uiConditions[index]:SetPosY(textSize)
      textSize = textSize + questUi._uiConditions[index]:GetTextSizeY() + 2
      if true == isDone then
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FFF26A6A)
        questUi._uiConditions[index]:SetLineCount(1)
      elseif nil ~= data.demandState and data.demandState[index + 1] == self._config._questState._complete then
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FF626262)
      else
        questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        questUi._uiConditions[index]:SetFontColor(UI_color.C_FFC4BEBE)
      end
      questUi._uiConditions[index]:SetLineRender(isDone)
      index = index + 1
    end
    questUi._questType = self._config._questType._latest
    if 0 ~= Int64toInt32(data.endTime_s64) then
      if self._config._questState._progressing == data.state then
        local updateData = {}
        updateData._index = uiIndex
        updateData._endTime_s64 = data.endTime_s64
        table.insert(self._timeAttackQuestList, updateData)
        local remainTime = Int64toInt32(data.endTime_s64 - getServerUtc64())
        questUi._uiEndTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REMAINTIME", "time", convertSecondsToClockTime(remainTime)))
      elseif isDone and 0 >= Int64toInt32(data.endTime_s64 - getServerUtc64()) then
        questUi._uiEndTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_REAL_TIMEOVER"))
      else
        questUi._uiEndTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_TIMEOVER"))
      end
      questUi._uiEndTime:SetShow(true)
      questUi._uiEndTime:SetPosY(textSize)
      textSize = textSize + questUi._uiEndTime:GetTextSizeY() + 2
    else
      questUi._uiEndTime:SetShow(false)
    end
    local GroupSizeY = textSize
    questUi._uiGroupBG:SetSize(questUi._uiTitleBG:GetSizeX(), GroupSizeY)
    self:setNaviButtonInfo(questUi, isDone, data.isCompleteBlackSpirit)
    self._nextPosY = questUi._uiGroupBG:GetPosY() + questUi._uiGroupBG:GetSizeY()
    uiIndex = uiIndex + 1
    if uiIndex >= ToClient_GetLatestQuestShowCount() then
      break
    end
  end
  return uiIndex
end
function checkedQuestWidget:setGuildQuestUi(uiIndex)
  local questUi = self._uiQuestList[uiIndex]
  if nil == questUi then
    return uiIndex
  end
  local isDone = self._guildData.state == self._config._questState._complete
  self:setQuestBG(questUi._uiTitleBG, self._config._questType._guild)
  questUi._uiGroupBG:SetShow(true)
  questUi._uiTitleBG:SetShow(false)
  self:setQuestTitle(questUi._uiQuestTitle, self._guildData.QuestName, self._guildData.state)
  questUi._uiGroupTitle:EraseAllEffect()
  questUi._uiGroupTitle:SetShow(true)
  questUi._uiGroupTitle:SetText(self._guildData.leftTime)
  local startPosition = questUi._uiTitleBG:GetSizeY()
  questUi._uiGroupTitle:SetPosY(startPosition)
  local textSize = startPosition + questUi._uiGroupTitle:GetPosY()
  local index = 0
  for _, demandString in pairs(self._guildData.demand) do
    questUi._uiConditions[index]:SetText(demandString)
    questUi._uiConditions[index]:SetShow(true)
    questUi._uiConditions[index]:SetPosY(textSize)
    textSize = textSize + questUi._uiConditions[index]:GetTextSizeY() + 2
    if true == isDone then
      questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      questUi._uiConditions[index]:SetLineCount(1)
      questUi._uiConditions[index]:SetFontColor(UI_color.C_FFF26A6A)
    elseif nil ~= self._guildData.demandState and self._guildData.demandState[index + 1] == self._config._questState._complete then
      questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      questUi._uiConditions[index]:SetFontColor(UI_color.C_FF626262)
    else
      questUi._uiConditions[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      questUi._uiConditions[index]:SetFontColor(UI_color.C_FFC4BEBE)
    end
    questUi._uiConditions[index]:SetLineRender(isDone)
    index = index + 1
  end
  local GroupSizeY = textSize
  questUi._uiGroupBG:SetSize(questUi._uiTitleBG:GetSizeX(), GroupSizeY)
  questUi._uiHideBtn:SetShow(false)
  self:setQuestTypeIcon(questUi._uiQuestIcon, 7, isDone)
  questUi._uiCompleteNpc:SetText("")
  questUi._questType = self._config._questType._guild
  self:setNaviButtonInfo(questUi, isDone, nil)
  self._nextPosY = questUi._uiGroupBG:GetPosY() + questUi._uiGroupBG:GetSizeY()
  return uiIndex + 1
end
function checkedQuestWidget:setQuestDataList()
  self:setGuildQuest()
  self:setLatestQuest()
  self:setNormalQuest()
end
function checkedQuestWidget:setGuildQuest()
  local isWantGuildJoin = ToClient_GetJoinedMode()
  if 0 == isWantGuildJoin then
    self._ui._button_WantGuild:SetCheck(true)
  elseif 1 == isWantGuildJoin then
    self._ui._button_WantGuild:SetCheck(false)
  end
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    return
  end
  if PaGlobal_TutorialManager:isDoingTutorial() then
    return
  end
  local questData = {}
  questData.questType = self._config._questType._guild
  questData.isProgressing = ToClient_isProgressingGuildQuest()
  self._isGuildQuestProgressing = questData.isProgressing
  if true == questData.isProgressing then
    questData.QuestName = ToClient_getCurrentGuildQuestName()
    questData.remainTime = ToClient_getCurrentGuildQuestRemainedTime()
    local strMinute = math.floor(questData.remainTime / 60)
    questData.state = self._config._questState._acceptable
    questData.demand = {}
    questData.demandState = {}
    local conditionStr
    local conditionState = self._config._questState._progressing
    local questConditionCount = ToClient_getCurrentGuildQuestConditionCount()
    local completeCount = 0
    if 0 >= questData.remainTime then
      questData.state = self._config._questState._fail
      questData.leftTime = " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT")
      questData.demand = {}
      questData.demand[1] = " " .. PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_TIMEOVER")
    else
      questData.state = self._config._questState._progressing
      questData.leftTime = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute)
      for idx = 0, questConditionCount - 1 do
        local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(idx)
        conditionStr = " - " .. currentGuildQuestInfo._desc .. " ( " .. currentGuildQuestInfo._currentCount .. " / " .. currentGuildQuestInfo._destCount .. " ) "
        conditionStr = ToClient_getReplaceDialog(conditionStr)
        if currentGuildQuestInfo._destCount <= currentGuildQuestInfo._currentCount then
          completeCount = completeCount + 1
          conditionState = self._config._questState._complete
        else
          conditionState = self._config._questState._progressing
        end
        table.insert(questData.demand, conditionStr)
        table.insert(questData.demandState, conditionState)
      end
      if questConditionCount <= completeCount then
        questData.demand = {}
        questData.demand[1] = " " .. PAGetString(Defines.StringSheet_GAME, "GUILDQUEST_COMPLETE")
        questData.state = self._config._questState._complete
        questData.demandState[1] = conditionState
      end
    end
    self._guildData = questData
  elseif true == ToClient_isGuildQuestOtherServer() then
    questData.QuestName = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROGRESSNOQUEST_ANOTHER")
    self._guildData = questData
  end
end
function checkedQuestWidget:setLatestQuest()
  local questListInfo = ToClient_GetQuestList()
  local questCount = questListInfo:getLatestQuestCount()
  local mainQuestInfo = questListInfo:getMainQuestInfo()
  local viewLimitCount = ToClient_GetLatestQuestShowCount()
  self._latestQuestShowCount = viewLimitCount
  if 0 == viewLimitCount or 0 == questCount then
    self._latestQuestShowCount = 0
    return
  else
    local viewCount = 0
    for ii = 0, questCount - 1 do
      if viewLimitCount <= table.getn(self._latestDataList) then
        return
      end
      local questNo = questListInfo:getLatestQuestAt(ii)
      local uiQuestInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
      local questGroupInfo = questListInfo:getQuestGroup(questNo)
      if nil ~= questGroupInfo and true == questGroupInfo:isGroupQuest() then
        self:groupQuestInfo(questGroupInfo, questIndex, self._config._questType._latest)
      else
        self:questInfo(uiQuestInfo, true, questIndex, 0, nil, 0, self._config._questType._latest)
      end
    end
  end
end
function checkedQuestWidget:setNormalQuest()
  local questListInfo = ToClient_GetQuestList()
  self._questGroupCount = questListInfo:getQuestCheckedGroupCount()
  for questIndex = 0, self._questGroupCount - 1 do
    local questGroupInfo = questListInfo:getQuestCheckedGroupAt(questIndex)
    if nil == questGroupInfo then
      return
    end
    if true == questGroupInfo:isGroupQuest() then
      self:groupQuestInfo(questGroupInfo, questIndex, self._config._questType._normal)
    else
      local uiQuestInfo = questGroupInfo:getQuestAt(0)
      self:questInfo(uiQuestInfo, true, questIndex, 0, nil, 0, self._config._questType._normal)
    end
  end
end
function checkedQuestWidget:getGroupCount()
  local groupCount = 0
  for ii = 0, self._config._maxQuestListCnt - 1 do
    if 0 ~= self._uiQuestList[ii]._questNo._groupId and 0 ~= self._uiQuestList[ii]._questNo._questId then
      groupCount = groupCount + 1
    end
  end
  return groupCount
end
function isEmptyNormalQuestGroup()
  local count = checkedQuestWidget:getGroupCount()
  if 0 == count then
    return true
  end
  return false
end
function checkedQuestWidget:doReleaseCheckForTutorial()
  local questListInfo = ToClient_GetQuestList()
  local temp_questGroupCount = questListInfo:getQuestCheckedGroupCount()
  local temp_progressCount = 0
  if true == self._welcomeToTheWorld then
    for questGroupIndex = 0, temp_questGroupCount - 1 do
      self.questNoSaveForTutorial[temp_progressCount] = {_questGroupIndex, _questGroupIdx}
      local temp_questGroupInfo = questListInfo:getQuestCheckedGroupAt(questGroupIndex)
      if nil ~= temp_questGroupInfo then
        if true == temp_questGroupInfo:isGroupQuest() then
          local tempGroupCount = temp_questGroupInfo:getQuestCount()
          for questGroupIdx = 0, tempGroupCount - 1 do
            local tempQuestInfo = temp_questGroupInfo:getQuestAt(questGroupIdx)
            local recommandLevel = tempQuestInfo:getRecommendLevel()
            local selfLevel = getSelfPlayer():get():getLevel() + 10
            if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
              if self._welcomeToTheWorld and not TutorialQuestCompleteCheck() and (3 == tempQuestInfo:getQuestType() or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or recommandLevel > selfLevel) then
                self.questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
                self.questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
              end
              temp_progressCount = temp_progressCount + 1
            end
          end
        else
          local tempQuestInfo = temp_questGroupInfo:getQuestAt(0)
          local recommandLevel = tempQuestInfo:getRecommendLevel()
          local selfLevel = getSelfPlayer():get():getLevel() + 10
          if tempQuestInfo._isProgressing and not tempQuestInfo._isCleared then
            if self._welcomeToTheWorld and not TutorialQuestCompleteCheck() and (3 == tempQuestInfo:getQuestType() or 4 == tempQuestInfo:getQuestType() or 5 == tempQuestInfo:getQuestType() or 6 == tempQuestInfo:getQuestType() or recommandLevel > selfLevel) then
              self.questNoSaveForTutorial[temp_progressCount]._questGroupIndex = tempQuestInfo:getQuestNo()._group
              self.questNoSaveForTutorial[temp_progressCount]._questGroupIdx = tempQuestInfo:getQuestNo()._quest
            end
            temp_progressCount = temp_progressCount + 1
          end
        end
      end
    end
    if self._welcomeToTheWorld and not TutorialQuestCompleteCheck() and temp_progressCount > 0 then
      self._welcomeToTheWorld = false
      for index = 0, temp_progressCount - 1 do
        ToClient_ToggleCheckShow(self.questNoSaveForTutorial[index]._questGroupIndex, self.questNoSaveForTutorial[index]._questGroupIdx)
      end
    end
  end
  self._welcomeToTheWorld = false
end
function QuestWidget_ProgressingGuildQuest_UpdateRemainTime(deltaTime)
  checkedQuestWidget:updatePerFrame(deltaTime)
end
function checkedQuestWidget:updateQuestData()
  if 0 < self._updateTime then
    self._updateTime = -1
  end
  if true == self._isExistUpdateData then
    FromClient_UpdateQuestSetPos()
    self._isExistUpdateData = false
  end
  self:setShowConditionText()
  checkedQuestWidget:questWidget_MouseOver(false)
  PaGlobalFunc_MainQuestWidget_MouseOutEvent()
end
function checkedQuestWidget:updatePerFrame(deltaTime)
  self:updateQuestData()
  if not ToClient_isProgressingGuildQuest() then
    return
  end
  if self._config._questType._guild ~= self._uiQuestList[0]._questType then
    return
  end
  self:setGuildQuest()
  self:setGuildQuestUi(0)
end
function checkedQuestWidget:groupQuestInfo(questGroupInfo, questGroupIndex, questType)
  local questGroupTitle = questGroupInfo:getTitle()
  local questGroupCount = questGroupInfo:getTotalQuestCount()
  for questIndex = 0, questGroupInfo:getQuestCount() - 1 do
    local uiQuestInfo = questGroupInfo:getQuestAt(questIndex)
    self:questInfo(uiQuestInfo, false, questGroupIndex, questIndex, questGroupTitle, questGroupCount, questType)
  end
end
function checkedQuestWidget:questInfo(uiQuestInfo, isSingle, questGroupIndex, questIndex, groupTitle, questGroupCount, questType)
  if false == uiQuestInfo._isCleared and true == uiQuestInfo._isProgressing then
    self:ProgressQuest(uiQuestInfo, isSingle, groupTitle, questGroupCount, questGroupIndex, questType)
  end
end
function FGlobal_UpdateQuestFavorType()
  if false == _ContentsGroup_RenewUI then
    FGlobal_QuestWindow_favorTypeUpdate()
  else
    FGlobal_CheckedQuestFaverTypeUpdate()
  end
  if false == _ContentsGroup_RemasterUI_Main_Alert then
    UIMain_QuestUpdate()
  end
end
function checkedQuestWidget:ProgressQuest(uiQuestInfo, isSingle, groupTitle, questGroupCount, questGroupIndex, questType)
  local questData = {}
  local questNo = uiQuestInfo:getQuestNo()
  local questGroupId = questNo._group
  local questId = questNo._quest
  local groupIdx = questGroupIndex
  local groupStartPos = tmp_nextPosY
  questData.quest = questId
  questData.group = questGroupId
  local isAlreadyShow = self:isAlreadyShown(questNo)
  if true == isAlreadyShow then
    return
  end
  local questTitle = self:getQuestTitle(questNo._group, questNo._quest)
  questData.QuestName = questTitle
  if false == isSingle then
    questData.QuestGroupName = self:getQuestGroupTitle(groupTitle, questId, questGroupCount)
  end
  questData.demand = {}
  questData.demand = self:setDemandConditions(uiQuestInfo)
  questData.demandState = {}
  questData.demandState = self:setDemandStateConditions(uiQuestInfo)
  questData.isCompleteBlackSpirit = uiQuestInfo:isCompleteBlackSpirit()
  questData.isSingle = isSingle
  questData.questType = uiQuestInfo:getQuestType()
  questData.groupIdx = questGroupIndex
  questData.endTime_s64 = uiQuestInfo:getEndTime()
  if toInt64(0, 0) ~= questData.endTime_s64 then
    if true == uiQuestInfo:isTimeOver() then
      questData.state = self._config._questState._fail
    elseif not uiQuestInfo:isSatisfied() or uiQuestInfo:isSatisfied() and toInt64(0, 0) <= questData.endTime_s64 then
      questData.state = self._config._questState._progressing
    else
      questData.state = self._config._questState._complete
    end
  elseif not uiQuestInfo:isSatisfied() then
    questData.state = self._config._questState._progressing
  else
    questData.state = self._config._questState._complete
  end
  if false == uiQuestInfo:isSpecialType() and false == uiQuestInfo:isRegionMonsterKillType() then
    if self._config._questType._latest == questType and table.getn(self._latestDataList) < ToClient_GetLatestQuestShowCount() then
      table.insert(self._latestDataList, questData)
    else
      table.insert(self._normalDataList, questData)
    end
  end
end
function checkedQuestWidget:setDemandStateConditions(uiQuestInfo)
  local demandList = {}
  if false == uiQuestInfo:isSatisfied() then
    for index = 0, uiQuestInfo:getDemandCount() - 1 do
      local conditionInfo = uiQuestInfo:getDemandAt(index)
      local conditionState = self._config._questState._progressing
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        conditionState = self._config._questState._complete
      end
      table.insert(demandList, conditionState)
    end
  end
  return demandList
end
function checkedQuestWidget:setDemandConditions(uiQuestInfo)
  local demandList = {}
  if false == uiQuestInfo:isSatisfied() then
    for index = 0, uiQuestInfo:getDemandCount() - 1 do
      local conditionInfo = uiQuestInfo:getDemandAt(index)
      local conditionText
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        conditionText = " - " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
      elseif 1 == conditionInfo._destCount then
        conditionText = " - " .. conditionInfo._desc
      else
        conditionText = " - " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
      end
      conditionText = ToClient_getReplaceDialog(conditionText)
      table.insert(demandList, conditionText)
    end
  elseif not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    demandList[1] = " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_ACCEPT_NOTICE")
  elseif true == uiQuestInfo:isCompleteBlackSpirit() then
    demandList[1] = " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTCOMPLETE_BLACKSPIRIT")
  else
    demandList[1] = " " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC")
  end
  return demandList
end
function checkedQuestWidget:setQuestBG(control, BGtype)
  control:ChangeTextureInfoName("renewal/frame/console_frame_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, self._config._questBG[BGtype][1], self._config._questBG[BGtype][2], self._config._questBG[BGtype][3], self._config._questBG[BGtype][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
function checkedQuestWidget:setQuestTypeIcon(control, questType, isDone)
  control:EraseAllEffect()
  control:SetShow(true)
  control:SetIgnore(true)
  if not isDone then
    FGlobal_ChangeOnTextureForDialogQuestIcon(control, questType)
  else
    FGlobal_ChangeOnTextureForDialogQuestIcon(control, 8)
  end
end
function checkedQuestWidget:setQuestTitle(control, string, state)
  if nil == control then
    return
  end
  control:SetAutoResize(true)
  control:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  control:SetText(string)
  control:SetLineRender(false)
  control:SetShow(true)
  control:SetIgnore(true)
  control:SetFontColor(UI_color.C_FFEFEFEF)
  control:useGlowFont(true, "BaseFont_8_Glow", 4287655978)
  control:EraseAllEffect()
  if state == self._config._questState._complete then
    control:AddEffect("UI_Quest_Complete_GoldAura", true, -10, 0)
  elseif state == self._config._questState._acceptable then
    control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_NOTACCEPTTITLE", "title", string))
  else
    if state == self._config._questState._fail then
      control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WIDGET_CHECKEDQUEST_FAIL_TITLE", "string", string))
    else
    end
  end
end
function checkedQuestWidget:getQuestGroupTitle(groupTitle, questId, questGroupCount)
  if nil == groupTitle then
    return nil
  end
  local groupQuestTitleInfo = groupTitle .. " (" .. questId .. "/" .. questGroupCount .. ")"
  groupQuestTitleInfo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo)
  return groupQuestTitleInfo
end
function PaGlobalFunc_SetVisibleConvenienceButtonByIndex(index, show)
  checkedQuestWidget:setVisibleConvenienceButtonByIndex(index, show)
end
function checkedQuestWidget:setVisibleConvenienceButtonByIndex(index, show)
  if index >= self._config._maxQuestListCnt then
    return
  end
  local selfLevel = getSelfPlayer():get():getLevel()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local uiElem = self._uiQuestList[index]
  if true == show then
    if uiElem._uiAutoNaviBtn:IsEnable() then
      uiElem._uiAutoNaviBtn:SetShow(true)
      uiElem._uiNaviBtn:SetShow(true)
    end
    if self._config._questType._guild == uiElem._questType then
      uiElem._uiHideBtn:SetShow(false)
      uiElem._uiAutoNaviBtn:SetShow(false)
      uiElem._uiNaviBtn:SetShow(false)
      uiElem._uiRewardBtn:SetShow(true)
      uiElem._uiRewardBtn:addInputEvent("Mouse_LUp", "HandleCliekedGuildQuestReward()")
      if isGuildMaster or isGuildSubMaster then
        uiElem._uiGiveupBtn:SetShow(true)
        uiElem._uiGiveupBtn:addInputEvent("Mouse_LUp", "HandleClieked_GuildQuestWidget_Giveup()")
      end
    else
      uiElem._uiRewardBtn:SetShow(false)
      uiElem._uiRewardBtn:addInputEvent("Mouse_LUp", "")
      if selfLevel > self._config._giveupLimitLv then
        if self._config._questType._normal == uiElem._questType then
          uiElem._uiHideBtn:SetShow(true)
        end
        uiElem._uiGiveupBtn:SetShow(true)
        uiElem._uiHideBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestShowCheck(" .. uiElem._questNo._groupId .. "," .. uiElem._questNo._questId .. ")")
        uiElem._uiGiveupBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp(" .. uiElem._questNo._groupId .. "," .. uiElem._questNo._questId .. ")")
      end
      local questStaticStatus = questList_getQuestStatic(uiElem._questNo._groupId, uiElem._questNo._questId)
      if nil ~= questStaticStatus then
        local posCount = questStaticStatus:getQuestPositionCount()
        local enable = true
        if 0 == posCount then
          enable = false
        end
        if false == enable then
          uiElem._uiAutoNaviBtn:SetShow(false)
          uiElem._uiNaviBtn:SetShow(false)
        end
      end
    end
  else
    uiElem._uiRewardBtn:SetShow(false)
    uiElem._uiAutoNaviBtn:SetShow(false)
    uiElem._uiNaviBtn:SetShow(false)
    uiElem._uiGiveupBtn:SetShow(false)
    uiElem._uiHideBtn:SetShow(false)
  end
end
function checkedQuestWidget:resizingConvenienceButtons(idx, isMouseOn)
  if idx < 0 or idx >= self._config._maxQuestListCnt then
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "==================error====================")
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "resizingConvenienceButtons : idx == " .. tostring(idx))
    _PA_LOG("\234\185\128\235\179\145\237\152\184", "==================error====================")
    return
  end
  local uiElem = self._uiQuestList[idx]
  local sizeX = self._config._defaultButtonSize
  local sizeY = self._config._defaultButtonSize
  if true == isMouseOn then
    sizeX = self._extendButtonSize
    sizeY = self._extendButtonSize
    uiElem._uiAutoNaviBtn:SetPosX(260)
    uiElem._uiNaviBtn:SetPosX(235)
    uiElem._uiGiveupBtn:SetPosX(210)
  else
    uiElem._uiAutoNaviBtn:SetPosX(265)
    uiElem._uiNaviBtn:SetPosX(245)
    uiElem._uiGiveupBtn:SetPosX(225)
  end
  uiElem._uiAutoNaviBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiNaviBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiGiveupBtn:SetPosY(uiElem._uiQuestIcon:GetPosY())
  uiElem._uiAutoNaviBtn:SetSize(sizeX, sizeY)
  uiElem._uiNaviBtn:SetSize(sizeX, sizeY)
  uiElem._uiGiveupBtn:SetSize(sizeX, sizeY)
end
function checkedQuestWidget:setNaviButtonInfo(questUi, isSatisfied, isCompleteBlackSpirit)
  if nil == questUi then
    return
  end
  local questGroupId = questUi._questNo._groupId
  local questId = questUi._questNo._questId
  local uiGroupBG = questUi._uiGroupBG
  local uiSelectBG = questUi._uiHideBtn
  local uiAutoNaviBtn = questUi._uiAutoNaviBtn
  local uiNaviBtn = questUi._uiNaviBtn
  local uiGiveupBtn = questUi._uiGiveupBtn
  local uiTitleBG = questUi._uiTitleBG
  local uiTitle = questUi._uiQuestTitle
  local uiAutoNaviBtnPosY = uiGroupBG:GetPosY() + uiAutoNaviBtn:GetPosY()
  local uiNaviBtnPosY = uiGroupBG:GetPosY() + uiNaviBtn:GetPosY()
  local conditionCheck
  if true == isSatisfied then
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Complete
  else
    conditionCheck = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", true )")
  uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  uiGroupBG:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ")")
  uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  uiTitleBG:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. " )")
  uiTitleBG:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  uiTitle:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. " )")
  uiTitle:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  for index = 0, self._config._maxConditionCnt - 1 do
    questUi._uiConditions[index]:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ")")
    questUi._uiConditions[index]:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questGroupId .. ", " .. questId .. ", " .. conditionCheck .. ", false )")
  end
  if self._questGroupId == questGroupId and self._questId == questId then
    if true == self._naviInfoAgain then
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
  if questUi._questType ~= self._config._questType._normal then
    uiSelectBG:SetShow(false)
  end
  local questStaticStatus = questList_getQuestStatic(questGroupId, questId)
  if questStaticStatus ~= nil then
    local posCount = questStaticStatus:getQuestPositionCount()
    local enable = true
    if false == isSatisfied and 0 == posCount then
      enable = false
    end
    uiAutoNaviBtn:SetEnable(enable)
    uiNaviBtn:SetEnable(enable)
  end
  if true == isSatisfied and true == isCompleteBlackSpirit then
    uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
    uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
    for index = 0, self._config._maxConditionCnt - 1 do
      questUi._uiConditions[index]:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
      questUi._uiConditions[index]:addInputEvent("Mouse_RUp", "HandleClicked_CallBlackSpirit()")
    end
  end
end
function checkedQuestWidget:isHitTestQuestGroup(groupControl, optionalY)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panel = Panel_CheckedQuest
  local panelPosX = panel:GetPosX() + groupControl:GetPosX()
  local panelPosY = panel:GetPosY() + groupControl:GetPosY()
  local bgPosX = panelPosX
  local bgPosY = panelPosY
  local bgSizeX = groupControl:GetSizeX()
  local bgSizeY = groupControl:GetSizeY()
  if nil ~= optionalY then
    bgPosY = bgPosY + optionalY
  end
  if mousePosX > bgPosX and mousePosX < bgPosX + bgSizeX and mousePosY > bgPosY and mousePosY < bgPosY + bgSizeY then
    return true
  end
  return false
end
function checkedQuestWidget:isHitTestQuestGroup(groupControl, optionalY)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panel = Panel_CheckedQuest
  local panelPosX = panel:GetPosX() + groupControl:GetPosX()
  local panelPosY = panel:GetPosY() + groupControl:GetPosY()
  local bgPosX = panelPosX
  local bgPosY = panelPosY
  local bgSizeX = groupControl:GetSizeX()
  local bgSizeY = groupControl:GetSizeY()
  if nil ~= optionalY then
    bgPosY = bgPosY + optionalY
  end
  if mousePosX > bgPosX and mousePosX < bgPosX + bgSizeX and mousePosY > bgPosY and mousePosY < bgPosY + bgSizeY then
    return true
  end
  return false
end
function checkedQuestWidget:getQuestTitle(groupId, questId)
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
function HandleMouseOver_QuestWidget_HelpPop(show, target, index)
  checkedQuestWidget:handleMouseOver_HelpPop(show, target, index)
end
function checkedQuestWidget:handleMouseOver_HelpPop(show, target, index)
  local QusetUi = self._uiQuestList[index]
  if nil == QusetUi then
    return
  end
  local control, msg = nil, ""
  local posY = 0
  if true == show then
    if "navi" == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP")
      control = QusetUi._uiNaviBtn
    elseif "Autonavi" == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP")
      control = QusetUi._uiAutoNaviBtn
    elseif "hide" == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_HIDETOOLTIP")
      control = QusetUi._uiHideBtn
    elseif "giveup" == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GIVEUPTOOLTIP")
      control = QusetUi._uiGiveupBtn
    elseif "reward" == target then
      msg = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_QUEST_TOOLTIP_REWARDCONFIRM_DESC")
      control = QusetUi._uiGiveupBtn
    end
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, "", msg)
  else
    TooltipSimple_Hide()
  end
end
function checkedQuestWidget:_questWidgetBubblePos(posY)
  local screenY = getScreenSizeY()
  local panelPosY = Panel_CheckedQuest:GetPosY()
  local _uiHelpWidgetSizeY = checkedQuestWidget._uiHelpWidget:GetSizeY()
  local buttonSizeY = checkedQuestWidget._uiQuestList[0]._button_Size:GetSizeY()
  if screenY < panelPosY + posY + _uiHelpWidgetSizeY then
    self._ui._staticText_IconHelp_BG:SetPosY(posY - _uiHelpWidgetSizeY - 5)
  else
    self._ui._staticText_IconHelp_BG:SetPosY(posY + buttonSizeY + 5)
  end
  self._ui._staticText_IconHelp_BG:SetPosX(Panel_CheckedQuest:GetSizeX() - self._ui._staticText_IconHelp_BG:GetSizeX() + 5)
end
function checkedQuestWidget:Common_WidgetMouseOut()
  if CppEnums.EProcessorInputMode.eProcessorInputMode_GameMode ~= UI.Get_ProcessorInputMode() then
    local panelPosX = Panel_CheckedQuest:GetPosX()
    local panelPosY = Panel_CheckedQuest:GetPosY()
    local panelSizeX = Panel_CheckedQuest:GetSizeX()
    local panelSizeY = Panel_CheckedQuest:GetSizeY()
    local mousePosX = getMousePosX()
    local mousePosY = getMousePosY()
    if panelPosX < mousePosX and mousePosX < panelPosX + panelSizeX and panelPosY < mousePosY and mousePosY < panelPosY + panelSizeY then
      return false
    end
  end
  return true
end
function FGlobal_QuestWidget_MouseOver(show)
  checkedQuestWidget:questWidget_MouseOver(show)
end
function checkedQuestWidget:questWidget_MouseOver(show)
  local widgetType = FGlobal_GetSelectedWidgetType()
  if true == show then
    self._widgetMouseOn = true
    self._ui._staticText_IconHelp_BG:SetShow(true)
    self._ui._static_Help_MouseL:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIN_WORLDMAP_HELP_MOUSEL"))
    self._ui._static_Help_MouseR:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WIN_WORLDMAP_HELP_MOUSER"))
    local txtSizeMouseL = self._ui._static_Help_MouseL:GetTextSizeX() + 45
    local txtSizeMouseR = self._ui._static_Help_MouseR:GetTextSizeX() + 45
    self._ui._staticText_IconHelp_BG:SetSize(math.max(txtSizeMouseL, txtSizeMouseR), self._ui._staticText_IconHelp_BG:GetSizeY())
    self._ui._staticText_IconHelp_BG:SetPosX(self._ui._staticText_IconHelp_BG:GetPosX() - math.max(txtSizeMouseL, txtSizeMouseR))
    self:tooltipReposition()
    self:setShowFunctionButtons(true)
    for ii = 0, self._config._maxQuestListCnt - 1 do
      self._uiQuestList[ii]._uiTitleBG:SetShow(true)
    end
    if CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType then
      self._ui._frame_NormalQuest:SetShow(true)
    end
  else
    if false == self:Common_WidgetMouseOut() then
      return
    end
    self._widgetMouseOn = false
    self._ui._staticText_IconHelp_BG:SetShow(false)
    self:setShowFunctionButtons(false)
    for ii = 0, self._config._maxQuestListCnt - 1 do
      self._uiQuestList[ii]._uiTitleBG:SetShow(false)
      self._uiQuestList[ii]._uiAutoNaviBtn:SetShow(false)
      self._uiQuestList[ii]._uiNaviBtn:SetShow(false)
      self._uiQuestList[ii]._uiGiveupBtn:SetShow(false)
      self._uiQuestList[ii]._uiHideBtn:SetShow(false)
      self._uiQuestList[ii]._uiRewardBtn:SetShow(false)
    end
    if CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType then
      self._ui._frame_NormalQuest:SetShow(false)
    end
  end
  PaGlobal_TutorialManager:handleQuestWidgetMouseOver(show)
end
function FGlobal_ChangeWidgetType()
  local widgetType = FGlobal_GetSelectedWidgetType()
  if CppEnums.QuestWidgetType.eQuestWidgetType_Simple == widgetType then
  else
  end
end
function checkedQuestWidget:tooltipReposition()
  if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
    local txtSizeMouseL = self._ui._static_Help_MouseL:GetTextSizeX()
    local txtSizeMouseR = self._ui._static_Help_MouseR:GetTextSizeX()
    self._ui._staticText_IconHelp_BG:SetSize(txtSizeMouseL + 38, 75)
  end
  local isLeft = getScreenSizeX() / 2 < Panel_CheckedQuest:GetPosX()
  if not isLeft then
    self._ui._staticText_IconHelp_BG:SetPosX(Panel_CheckedQuest:GetSizeX() + 10)
  else
    self._ui._staticText_IconHelp_BG:SetPosX(Panel_CheckedQuest:GetSizeX() - Panel_CheckedQuest:GetSizeX() - self._ui._staticText_IconHelp_BG:GetSizeX() - 10)
  end
  self._ui._staticText_IconHelp_BG:SetPosY(20)
end
function checkedQuestWidget:setShowFunctionButtons(isMouseOver)
  if true == isMouseOver then
    self._ui._button_Size:SetShow(true)
    self._ui._button_Option:SetShow(true)
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      self._ui._button_WantGuild:SetShow(true)
    end
    local posY = Panel_CheckedQuest:GetSizeY() - self._ui._button_Size:GetSizeY()
  else
    self._ui._button_Size:SetShow(false)
    self._ui._button_WantGuild:SetShow(false)
    self._ui._button_Option:SetShow(false)
  end
end
function FGlobal_QuestWidget_GetSelectedNaviInfo()
  return checkedQuestWidget._questGroupId, checkedQuestWidget._questId, checkedQuestWidget._naviInfoAgain
end
function FGlobal_QuestWidget_IsMouseOn()
  return checkedQuestWidget._widgetMouseOn
end
function FGlobal_QuestWidget_GetPositionList()
  return checkedQuestWidget._positionList
end
function FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
  local questNo = uiQuestInfo:getQuestNo()
  if nil == self._positionList then
    return
  end
  if questNo._group == self._positionList._questGroupId and questNo._quest == self._positionList._questId then
    self._positionList = {}
    if not uiQuestInfo:isCompleteBlackSpirit() then
      _questGroupId = 0
      _questId = 0
      HandleClicked_QuestWidget_FindTarget(questNo._group, questNo._quest, 0, false)
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
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:increaseLayer(true)
    WorldMapPopupManager:push(Panel_CheckedQuest, true)
  end
end
function FGlobal_QuestWidget_Close()
  Panel_CheckedQuest:SetShow(false, false)
  Panel_MainQuest:SetShow(false, false)
  questInfo_TooltipShow(false)
  TooltipSimple_Hide()
  if ToClient_WorldMapIsShow() then
    WorldMapPopupManager:pop()
  end
end
function HandleClicked_ShowQuestInfo(questGroupId, questId, questCondition_Chk)
  local uiQuestInfo = ToClient_GetQuestInfo(questGroupId, questId)
  if nil == uiQuestInfo then
    return
  end
  local questListInfo = ToClient_GetQuestList()
  local questGroupInfo = questListInfo:getQuestGroup(uiQuestInfo:getQuestNo())
  local questGroupTitle = "nil"
  local questGroupCount = 0
  if nil ~= questGroupInfo then
    questGroupTitle = questGroupInfo:getTitle()
    questGroupCount = questGroupInfo:getTotalQuestCount()
  end
  local fromQuestWidget = true
  FGlobal_QuestWindow_SetProgress()
  HandleClick_QuestWindow_Update()
  FGlobal_QuestInfoDetail(questGroupId, questId, questCondition_Chk, questGroupTitle, questGroupCount, true)
  audioPostEvent_SystemUi(0, 0)
end
function HandleClicked_QuestWidget_FindTarget(questGroupId, questId, condition, isAuto)
  checkedQuestWidget:findTarget(questGroupId, questId, condition, isAuto)
end
function checkedQuestWidget:findTarget(questGroupId, questId, condition, isAuto)
  PaGlobal_TutorialManager:handleClickedQuestWidgetFindTarget(questGroupId, questId, condition, isAuto)
  if self._questGroupId == questGroupId and self._questId == questId then
    if false == self._naviInfoAgain then
      ToClient_DeleteNaviGuideByGroup(0)
      audioPostEvent_SystemUi(0, 15)
      self._naviInfoAgain = true
    else
      self._naviInfoAgain = false
      _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
    end
  else
    self._questGroupId = questGroupId
    self._questId = questId
    self._naviInfoAgain = false
    _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
  end
  self._isAutoRun = isAuto
  FGlobal_QuestWindow_Update_FindWay(questGroupId, questId, isAuto)
end
function FGlobal_QuestWidget_UpdateList()
  checkedQuestWidget:updateQuestList(checkedQuestWidget._startPosition)
end
local navigationGuideParam = NavigationGuideParam()
function _QuestWidget_FindTarget_DrawMapPath(questGroupId, questId, condition, isAuto)
  self = checkedQuestWidget
  ToClient_DeleteNaviGuideByGroup(0)
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
    end
  else
    local questPosCount = questInfo:getQuestPositionCount()
    if 0 ~= questPosCount then
      self._positionList = {}
      self._positionList._questGroupId = questGroupId
      self._positionList._questId = questId
      local totalLength = 0
      for questPositionIndex = 0, questPosCount - 1 do
        local questPosInfo = questInfo:getQuestPositionAt(questPositionIndex)
        posX = questPosInfo._position.x
        posY = questPosInfo._position.y
        posZ = questPosInfo._position.z
        self._positionList[questPositionIndex] = {}
        self._positionList[questPositionIndex]._key = worldmapNavigatorStart(float3(posX, posY, posZ), navigationGuideParam, isAuto, false, true)
        self._positionList[questPositionIndex]._radius = questPosInfo._radius
        self._positionList[questPositionIndex]._startRate = totalLength
        totalLength = totalLength + self._positionList[questPositionIndex]._radius
      end
      if 0 < questPosCount - 1 then
        local randomRate = math.random(0, 100) / 100
        local randomIndex = 0
        for idx = 0, questPosCount - 1 do
          if randomRate > self._positionList[idx]._startRate / totalLength and randomRate < (self._positionList[idx]._startRate + self._positionList[idx]._radius) / totalLength then
            randomIndex = idx
            break
          end
        end
        local selfPlayer = getSelfPlayer():get()
        if selfPlayer:getNavigationMovePathIndex() ~= self._positionList[randomIndex]._key then
          if ToClient_GetNaviGuideGroupNo(self._positionList[randomIndex]._key) ~= 0 then
            ToClient_DeleteNaviGuideByGroup(0)
          end
          selfPlayer:setNavigationMovePath(self._positionList[randomIndex]._key)
          selfPlayer:checkNaviPathUI(self._positionList[randomIndex]._key)
        end
      end
      if TutorialQuestCompleteCheck() then
        audioPostEvent_SystemUi(0, 14)
      end
    end
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
function _QuestWidget_ReturnQuestState()
  return checkedQuestWidget._questGroupId, checkedQuestWidget._questId, checkedQuestWidget._naviInfoAgain
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
function guildQuestWidget_MouseOn(isShow)
  checkedQuestWidget:mouseOn_GuildQuset(isShow)
end
function checkedQuestWidget:mouseOn_GuildQuset(isShow)
  local control = self._guildQuest._ControlBG
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
  checkedQuestWidget:handleClicked_QuestWidgetPanelResize()
end
function checkedQuestWidget:handleClicked_QuestWidgetPanelResize()
  local panel = Panel_CheckedQuest
  local currentY = getMousePosY()
  local deltaY = currentY - orgMouseY
  local panelPosY = panel:GetPosY()
  local panelSizeX = panel:GetSizeX()
  local panelSizeY = panel:GetSizeY()
  local mousePosY = getMousePosY()
  if orgPanelSizeY + deltaY > 300 and orgPanelSizeY + deltaY < 700 then
    checkedQuestWidget:setPanelSize(panelSizeX, orgPanelSizeY + deltaY)
  end
  if getScreenSizeY() - 50 < Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY() then
    checkedQuestWidget:setPanelSize(panelSizeX, getScreenSizeY() - 50 - Panel_CheckedQuest:GetPosY())
  end
  if panel:GetSizeY() > 300 then
    CheckedQuest_SizeY = panel:GetSizeY()
  end
  self._ui._button_Size:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  self._ui._button_WantGuild:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  self._ui._button_Option:SetPosY(CheckedQuest_SizeY - self._ui._button_Size:GetSizeY())
  checkedQuestWidget:setQuestUIlist()
  ToClient_SaveUiInfo(false)
end
function HandleClicked_QuestWidgetSaveResize()
  checkedQuestWidget:updateQuestList()
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
  if Panel_Window_Quest_New:IsUISubApp() == true and false == _ContentsGroup_NewUI_Dialog_All then
    Panel_Npc_Quest_Reward:OpenUISubApp()
  end
end
function FromClient_SetQuestType(questType)
  local QuestListInfo = ToClient_GetQuestList()
  QuestListInfo:setQuestSelectType(questType, true)
end
function HandleClieked_CheckedQuest_WantJoinGuild()
  if checkedQuestWidget._ui._button_WantGuild:IsCheck() then
    ToClient_SetJoinedMode(0)
  else
    ToClient_SetJoinedMode(1)
  end
end
function HandleOn_CheckedQuest_WantJoinGuild(isShow)
  FindGuild_Button_Simpletooltips(isShow)
  FGlobal_QuestWidget_MouseOver(isShow)
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
  ToClient_DeleteNaviGuideByGroup(0)
end
registerEvent("EventRadingOnQuest", "EventRadingOnQuest")
registerEvent("EventUnradingOnQuest", "EventUnradingOnQuest")
local checkQuest_posX = 0
local checkQuest_posY = 0
function FromClient_UpdateQuestSetPos()
  if false == self._isInitialized then
    return
  end
  checkedQuestWidget:updateQuestSetPos()
end
function checkedQuestWidget:updateQuestSetPos()
  if 0 < self._updateTime then
    self._isExistUpdateData = true
    return
  end
  self:updateQuestList(self._startPosition)
  self._updateTime = 1
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
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 16)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 65 + newEquipGap)
  end
  if getScreenSizeX() < Panel_CheckedQuest:GetPosX() + Panel_CheckedQuest:GetSizeX() or getScreenSizeY() < Panel_CheckedQuest:GetPosY() + Panel_CheckedQuest:GetSizeY() then
    checkedQuestWidget:updateQuestSetPos()
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 16)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 65 + newEquipGap)
  end
end
function QuestListChecked_EnableSimpleUI()
  checkedQuestWidget:updateQuestList(checkedQuestWidget._startPosition)
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
          Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 16)
          Panel_CheckedQuest:SetPosY(Panel_Radar:GetPosY() + Panel_Radar:GetSizeY() + 130 + newEquipGap)
          break
        end
      end
    end
  end
  if Panel_CheckedQuest:GetRelativePosX() == -1 and Panel_CheckedQuest:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 16
    local initPosY = FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 130 + newEquipGap
    local haveServerPosotion = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosotion then
      Panel_CheckedQuest:SetPosX(initPosX)
      Panel_CheckedQuest:SetPosY(initPosY)
    end
    changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, false, true, false)
    FGlobal_InitPanelRelativePos(Panel_CheckedQuest, initPosX, initPosY)
  elseif Panel_CheckedQuest:GetRelativePosX() == 0 and Panel_CheckedQuest:GetRelativePosY() == 0 then
    Panel_CheckedQuest:SetPosX(getScreenSizeX() - Panel_CheckedQuest:GetSizeX() - 16)
    Panel_CheckedQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + Panel_MainQuest:GetSizeY() + 20 + newEquipGap)
  else
    Panel_CheckedQuest:SetPosX(getScreenSizeX() * Panel_CheckedQuest:GetRelativePosX() - Panel_CheckedQuest:GetSizeX() / 2)
    Panel_CheckedQuest:SetPosY(getScreenSizeY() * Panel_CheckedQuest:GetRelativePosY() - Panel_CheckedQuest:GetSizeY() / 2)
  end
  if -1 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    Panel_CheckedQuest:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  else
    Panel_CheckedQuest:SetShow(true)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_CheckedQuest)
end
function renderModeChange_FromClient_questWidget_ResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_questWidget_ResetPosition()
end
function TutorialQuestCompleteCheck()
  return questList_isClearQuest(104, 1) or 15 <= getSelfPlayer():get():getLevel()
end
function QuestWidget_DefaultTextureFunction()
end
function FGlobal_ChangeLatestQuestShowCount()
  checkedQuestWidget:changeLatestQuestShowCount()
end
function checkedQuestWidget:changeLatestQuestShowCount()
  local questListInfo = ToClient_GetQuestList()
  local questCount = questListInfo:getLatestQuestCount()
  local mainQuestInfo = questListInfo:getMainQuestInfo()
  local viewLimitCount = ToClient_GetLatestQuestShowCount()
  if 0 == questCount then
    return
  end
  self:update()
end
function FromClient_ChangeQuestWidgetType()
  PaGlobalFunc_QuestWidget_UpdateList()
end
function FromClient_luaLoadComplete_CheckedQuest()
  checkedQuestWidget:initialize()
  changePositionBySever(Panel_CheckedQuest, CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, true, true, true)
  checkedQuestPanel_Init()
  PaGlobalFunc_QuestWidget_UpdateList()
  if -1 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow) then
    Panel_CheckedQuest:SetShow(ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_CheckedQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsShow))
  else
    Panel_CheckedQuest:SetShow(true)
  end
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
  Panel_Window_QuestNew_Toggle()
end
function checkedQuestWidget:registEventHandler()
  registerEvent("FromClient_StartQuestNavigationGuide", "FromClient_StartQuestNavigationGuide")
  registerEvent("updateProgressQuestList", "FromClient_UpdateQuestSetPos")
  registerEvent("FromClient_UpdateQuestList", "FromClient_QuestWidget_Update")
  registerEvent("FromClient_UpdateProgressGuildQuestList", "FromClient_QuestWidget_Update")
  registerEvent("FromClient_ResetTimeAttackQuest", "FromClient_QuestWidget_Update")
  registerEvent("onScreenResize", "FromClient_questWidget_ResetPosition")
  registerEvent("FromClient_SetQuestNavigationByServer", "FromClient_SetQuestNavigationByServer")
  registerEvent("FromClient_SetQuestType", "FromClient_SetQuestType")
  registerEvent("FromClient_UpdateQuestSortType", "QuestWidget_DefaultTextureFunction")
  registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_CheckedQuest")
  registerEvent("FromClient_ChangeQuestWidgetType", "FromClient_ChangeQuestWidgetType")
  registerEvent("FromClient_RenderModeChangeState", "renderModeChange_FromClient_questWidget_ResetPosition")
end
function checkedQuestWidget:setPanelSize(sizeX, sizeY)
  Panel_CheckedQuest:SetSize(sizeX, sizeY)
  _static_active:SetSize(sizeX, sizeY)
end
function PaGlobal_CheckedQuest_SetShowControl(isShow)
  _static_active:SetShow(isShow)
end
checkedQuestWidget:registEventHandler()
