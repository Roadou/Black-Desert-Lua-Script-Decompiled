local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
local nextGroupPosY = 0
local isMouseOnWidget = false
local questNo = {_groupId = 0, _questId = 0}
Panel_MainQuest:SetShow(true, false)
Panel_MainQuest:setGlassBackground(true)
Panel_MainQuest:SetDragEnable(false)
PaGlobal_MainQuest = {
  _uiGroupBG = UI.getChildControl(Panel_MainQuest, "Static_GroupBG"),
  _uiQuestCompleteNpc = UI.getChildControl(Panel_MainQuest, "StaticText_Quest_ClearNpc"),
  _uiQuestGroupTitle = UI.getChildControl(Panel_MainQuest, "StaticText_WidgetGroupTitle"),
  _uiQuestTypeIcon = UI.getChildControl(Panel_MainQuest, "Static_Quest_Type"),
  _uiQuestTitle = UI.getChildControl(Panel_MainQuest, "StaticText_Quest_Title"),
  _uiAutoNaviBtn = UI.getChildControl(Panel_MainQuest, "CheckButton_AutoNavi"),
  _uiNaviBtn = UI.getChildControl(Panel_MainQuest, "Checkbox_Quest_Navi"),
  _uiQuestClearIcon = UI.getChildControl(Panel_MainQuest, "Static_Quest_Icon_ClearCheck"),
  _uiQuestTopDeco = UI.getChildControl(Panel_MainQuest, "Static_TopDeco"),
  _uiQuestBottomDeco = UI.getChildControl(Panel_MainQuest, "Static_BottomDeco"),
  _uiTooltip = UI.getChildControl(Panel_MainQuest, "StaticText_Notice_1"),
  _uiConsoleGuideLine = UI.getChildControl(Panel_MainQuest, "Static_BottomLine_ConsoleUI"),
  _uiQuestConditions = Array.new(),
  _maxConditionCnt = 5,
  _closeableLevel = 50
}
function PaGlobal_MainQuest:initialize()
  local uiCondition = UI.getChildControl(Panel_MainQuest, "StaticText_Quest_Demand")
  uiCondition:SetShow(false)
  for ii = 0, self._maxConditionCnt - 1 do
    self._uiQuestConditions[ii] = UI.createAndCopyBasePropertyControl(Panel_MainQuest, "StaticText_Quest_Demand", Panel_MainQuest, "uiConditions_" .. ii)
    self._uiQuestConditions[ii]:SetShow(false)
    self._uiQuestConditions[ii]:SetText("")
    self._uiQuestConditions[ii]:SetIgnore(true)
  end
  self._uiQuestTopDeco:SetIgnore(true)
  self._uiQuestTitle:SetIgnore(true)
  self._uiQuestBottomDeco:SetIgnore(true)
  self._uiQuestCompleteNpc:SetIgnore(true)
  self._uiQuestGroupTitle:SetIgnore(true)
  Panel_MainQuest:SetChildIndex(self._uiAutoNaviBtn, 9999)
  Panel_MainQuest:SetChildIndex(self._uiNaviBtn, 9999)
  self._uiTooltip:SetColor(UI_color.C_FFFFFFFF)
  self._uiTooltip:SetAlpha(1)
  self._uiTooltip:SetFontColor(UI_color.C_FFC4BEBE)
  self._uiTooltip:SetAutoResize(true)
  self._uiTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._uiTooltip:SetShow(false)
  self._uiTooltip:SetNotAbleMasking(true)
  self._uiQuestTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiQuestCompleteNpc:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiQuestGroupTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._uiQuestGroupTitle:SetFontColor(UI_color.C_FFEDE699)
  Panel_MainQuest:SetSize(Panel_MainQuest:GetSizeX(), 60)
  self._uiQuestTopDeco:ComputePos()
  self._uiQuestBottomDeco:ComputePos()
  self:subscribeDefaultHandler()
  self:clearAll()
  if false == _ContentsGroup_RenewUI then
    self._uiConsoleGuideLine:SetShow(false)
  end
end
function PaGlobal_MainQuest:subscribeDefaultHandler()
  self._uiAutoNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_Buttons( true, \"Autonavi\" )")
  self._uiAutoNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_Buttons( false, \"Autonavi\" )")
  self._uiNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_Buttons( true, \"navi\" )")
  self._uiNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_Buttons( false, \"navi\")")
end
function PaGlobal_MainQuest:questCompleteMarkEffect()
  if Panel_AutoQuest:IsShow() then
    Panel_MainQuest:EraseAllEffect()
    Panel_MainQuest:AddEffect("fUI_QuestComplete_01A", true, 122, -12)
  end
end
function PaGlobal_MainQuest:questCompleteMarkEffectErase()
  if Panel_AutoQuest:IsShow() then
    Panel_MainQuest:EraseAllEffect()
  end
end
function PaGlobal_MainQuest:update()
  local questList = ToClient_GetQuestList()
  if true == questList:isMainQuestClearAll() then
    self:CloseMainQuest()
    return
  end
  self:clearAll()
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo then
    self:setIconInfo(uiQuestInfo)
    self:setQuestTitleInfo(uiQuestInfo)
    local startPosY = self:setQuestGroupTitleInfo(uiQuestInfo)
    self:setConditionInfo(uiQuestInfo, startPosY)
    self:setButtonCheckState(uiQuestInfo)
  end
end
function PaGlobal_MainQuest:OpenMainQuest()
  Panel_MainQuest:SetShow(true, true)
  PaGlobal_MainQuest:update()
end
function PaGlobal_MainQuest:CloseMainQuest()
  Panel_MainQuest:SetShow(false)
  self:clearAll()
end
function PaGlobal_MainQuest:clearAll()
  self._uiQuestCompleteNpc:SetShow(false)
  self._uiQuestGroupTitle:SetShow(false)
  self._uiQuestTypeIcon:SetShow(false)
  self._uiQuestTitle:SetShow(false)
  self._uiQuestClearIcon:SetShow(false)
  self._uiAutoNaviBtn:SetShow(false)
  self._uiNaviBtn:SetShow(false)
  self._uiQuestCompleteNpc:SetText("")
  self._uiQuestGroupTitle:SetText("")
  self._uiQuestTitle:SetText("")
  self:clearConditionInfo()
end
function PaGlobal_MainQuest:setQuestGroupTitleInfo(uiQuestInfo)
  local startPosY = self._uiQuestTitle:GetPosY() + self._uiQuestTitle:GetSizeY() + 3
  if uiQuestInfo:isSatisfied() or not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    return startPosY
  end
  local questNo = uiQuestInfo:getQuestNo()
  local questListInfo = ToClient_GetQuestList()
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  if nil ~= uiQuestGroupInfo and uiQuestGroupInfo:isGroupQuest() then
    local groupTitle = uiQuestGroupInfo:getTitle()
    local questGroupCount = uiQuestGroupInfo:getTotalQuestCount()
    local groupQuestTitleInfo = groupTitle .. " (" .. questNo._quest .. "/" .. questGroupCount .. ")"
    self._uiQuestGroupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo))
    self._uiQuestGroupTitle:SetSize(310, self._uiQuestTitle:GetSizeY())
    self._uiQuestGroupTitle:SetPosX(25)
    self._uiQuestGroupTitle:SetPosY(self._uiQuestTitle:GetPosY() + self._uiQuestTitle:GetSizeY() + 5)
    self._uiQuestGroupTitle:SetAutoResize(true)
    self._uiQuestGroupTitle:SetIgnore(true)
    self._uiQuestGroupTitle:SetShow(true)
    startPosY = startPosY + self._uiQuestTitle:GetSizeY() + 3
  end
  return startPosY
end
function PaGlobal_MainQuest:setQuestTitleInfo(uiQuestInfo)
  local questTitle = self:getQuestTitle(uiQuestInfo)
  local isAccepted = 1
  if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    isAccepted = 0
  end
  self._uiQuestTitle:SetAutoResize(true)
  self._uiQuestTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  if false == ToClient_isConsole() then
    self._uiQuestTitle:SetSize(200, self._uiQuestTitle:GetSizeY())
  end
  if 0 == isAccepted then
    self._uiQuestTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_NOTACCEPTTITLE", "title", questTitle))
  else
    self._uiQuestTitle:SetText(questTitle)
  end
  self._uiQuestTitle:SetLineRender(false)
  self._uiQuestTitle:SetShow(true)
  self._uiQuestTitle:SetIgnore(true)
  self._uiQuestTitle:SetFontColor(UI_color.C_FFEFEFEF)
  if _ContentsGroup_RenewUI then
    self._uiQuestTitle:useGlowFont(true, "SubTitleFont_14_Glow", 4287655978)
  else
    self._uiQuestTitle:useGlowFont(true, "BaseFont_8_Glow", 4287655978)
  end
  local questNo = uiQuestInfo:getQuestNo()
  local questStaticStatus = questList_getQuestStatic(questNo._group, questNo._quest)
  local checkCondition
  if true == uiQuestInfo:isSatisfied() then
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_Complete
  elseif 0 == isAccepted then
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_NotAccept
  else
    checkCondition = QuestConditionCheckType.eQuestConditionCheckType_Progress
  end
  local groupTitle = "nil"
  local questGroupCnt = 0
  local questListInfo = ToClient_GetQuestList()
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  if nil ~= uiQuestGroupInfo then
    groupTitle = uiQuestGroupInfo:getTitle()
    questGroupCnt = uiQuestGroupInfo:getTotalQuestCount()
  end
  self._uiGroupBG:addInputEvent("Mouse_LUp", "HandleClicked_ShowMainQuestDetail( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", \"" .. groupTitle .. "\", " .. questGroupCnt .. " )")
  self._uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false ," .. isAccepted .. ", \"GroupBG\" )")
  self._uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false ," .. isAccepted .. ", \"Navi\" )")
  self._uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_MainQuest_FindWay( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", true ," .. isAccepted .. ", \"AutoNavi\" )")
  Panel_MainQuest:addInputEvent("Mouse_On", "HandleMouseOver_MainQuestWidget( true," .. isAccepted .. ")")
  Panel_MainQuest:addInputEvent("Mouse_Out", "HandleMouseOver_MainQuestWidget( false," .. isAccepted .. ")")
  self._uiGroupBG:addInputEvent("Mouse_On", "HandleMouseOver_MainQuestWidget( true," .. isAccepted .. ")")
  self._uiGroupBG:addInputEvent("Mouse_Out", "HandleMouseOver_MainQuestWidget( false," .. isAccepted .. ")")
  local posCount = questStaticStatus:getQuestPositionCount()
  local enable = false == uiQuestInfo:isSatisfied() and 0 ~= posCount
  enable = true
  self._uiAutoNaviBtn:SetShow(isMouseOnWidget)
  self._uiNaviBtn:SetShow(isMouseOnWidget)
  self._uiAutoNaviBtn:SetEnable(enable)
  self._uiNaviBtn:SetEnable(enable)
end
function PaGlobal_MainQuest:getQuestTitle(uiQuestInfo)
  local questTitle = uiQuestInfo:getTitle()
  local recommandLevel = uiQuestInfo:getRecommendLevel()
  if nil ~= recommandLevel and 0 ~= recommandLevel then
    questTitle = "[" .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. recommandLevel .. "] " .. questTitle
  end
  return questTitle
end
function PaGlobal_MainQuest:setIconInfo(uiQuestInfo)
  self._uiQuestTypeIcon:EraseAllEffect()
  self._uiQuestTypeIcon:SetShow(true)
  self._uiQuestTypeIcon:SetIgnore(true)
  FGlobal_ChangeOnTextureForDialogQuestIcon(self._uiQuestTypeIcon, uiQuestInfo:getQuestType())
end
function PaGlobal_MainQuest:setConditionInfo(uiQuestInfo, startPosY)
  PaGlobal_MainQuest:clearConditionInfo()
  local checkCondition
  if true == uiQuestInfo:isSatisfied() then
    checkCondition = 0
  else
    checkCondition = 1
  end
  local uiQuestCondition
  if not uiQuestInfo._isCleared and not uiQuestInfo._isProgressing then
    if true == ToClient_isConsole() then
      self._uiQuestCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "GAME_QUEST_BASIC_DIALOGUE_1"))
    else
      self._uiQuestCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_ACCEPT_NOTICE"))
    end
    self._uiQuestCompleteNpc:SetFontColor(Defines.Color.C_FFC4BEBE)
    self._uiQuestCompleteNpc:SetShow(true)
    if _ContentsGroup_RenewUI then
      startPosY = startPosY + self._uiQuestCompleteNpc:GetSizeY() + 10
    else
      startPosY = startPosY + self._uiQuestCompleteNpc:GetSizeY() + 2
    end
  elseif 1 == checkCondition then
    for conditionIndex = 0, uiQuestInfo:getDemandCount() - 1 do
      local conditionInfo = uiQuestInfo:getDemandAt(conditionIndex)
      uiQuestCondition = self._uiQuestConditions[conditionIndex]
      uiQuestCondition:SetAutoResize(true)
      uiQuestCondition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      uiQuestCondition:SetFontColor(UI_color.C_FFC4BEBE)
      uiQuestCondition:SetPosX(25)
      uiQuestCondition:SetPosY(startPosY)
      uiQuestCondition:SetSize(self._uiGroupBG:GetSizeX() - uiQuestCondition:GetPosX(), uiQuestCondition:GetTextSizeY())
      local conditionText
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        conditionText = "- " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(true)
        uiQuestCondition:SetFontColor(UI_color.C_FF626262)
      elseif 1 == conditionInfo._destCount then
        conditionText = "- " .. conditionInfo._desc
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(false)
      else
        conditionText = "- " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
        uiQuestCondition:SetText(ToClient_getReplaceDialog(conditionText))
        uiQuestCondition:SetLineRender(false)
      end
      uiQuestCondition:SetShow(true)
      uiQuestCondition:SetIgnore(true)
      if _ContentsGroup_RenewUI then
        startPosY = startPosY + uiQuestCondition:GetSizeY() + 10
      else
        startPosY = startPosY + uiQuestCondition:GetSizeY() + 2
      end
    end
  elseif 0 == checkCondition then
    if 0 == uiQuestInfo:getQuestType() then
      self._uiQuestTypeIcon:AddEffect("UI_Quest_Complete_GoldAura", true, 130, 0)
    elseif 0 < uiQuestInfo:getQuestType() then
      self._uiQuestTypeIcon:AddEffect("UI_Quest_Complete_GreenAura", true, 130, 0)
    end
    if true == ToClient_isConsole() then
      if true == uiQuestInfo:isCompleteBlackSpirit() then
        self._uiQuestCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_CONSOLE_COMPLETE_BLACKSPIRIT"))
      else
        self._uiQuestCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_CONSOLE_COMPLETE_NORMAL"))
      end
    else
      self._uiQuestCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC"))
    end
    self._uiQuestCompleteNpc:SetFontColor(Defines.Color.C_FFF26A6A)
    self._uiQuestCompleteNpc:SetShow(true)
    FGlobal_ChangeOnTextureForDialogQuestIcon(self._uiQuestTypeIcon, 8)
    if _ContentsGroup_RenewUI then
      startPosY = startPosY + self._uiQuestCompleteNpc:GetSizeY() + 10
    else
      startPosY = startPosY + self._uiQuestCompleteNpc:GetSizeY() + 2
    end
    FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
  end
  Panel_MainQuest:SetSize(Panel_MainQuest:GetSizeX(), startPosY + 10)
  self._uiGroupBG:SetSize(Panel_MainQuest:GetSizeX(), startPosY + 10)
  self._uiQuestTopDeco:ComputePos()
  self._uiQuestBottomDeco:ComputePos()
end
function PaGlobal_MainQuest:setButtonCheckState(uiQuestInfo)
  local questNo = uiQuestInfo:getQuestNo()
  local questGroup, questId, naviInfoAgain = FGlobal_QuestWidget_GetSelectedNaviInfo()
  if questGroup == questNo._group and questId == questNo._quest then
    if true == naviInfoAgain then
      self._uiGroupBG:SetShow(false)
      self._uiAutoNaviBtn:SetCheck(false)
      self._uiNaviBtn:SetCheck(false)
    else
      self._uiGroupBG:SetShow(true)
      if true == self._uiAutoNaviBtn:IsCheck() then
        self._uiAutoNaviBtn:SetCheck(true)
        self._uiNaviBtn:SetCheck(true)
      else
        self._uiAutoNaviBtn:SetCheck(false)
        self._uiNaviBtn:SetCheck(true)
      end
    end
  else
    self._uiGroupBG:SetShow(false)
    self._uiAutoNaviBtn:SetCheck(false)
    self._uiNaviBtn:SetCheck(false)
  end
end
function PaGlobal_MainQuest:setButtonState(isMouseOver)
  self._uiAutoNaviBtn:SetPosY(5)
  self._uiNaviBtn:SetPosY(5)
  if true == isMouseOver then
    self._uiAutoNaviBtn:SetPosX(263)
    self._uiNaviBtn:SetPosX(238)
    self._uiAutoNaviBtn:SetSize(25, 25)
    self._uiNaviBtn:SetSize(25, 25)
  else
    self._uiAutoNaviBtn:SetPosX(268)
    self._uiNaviBtn:SetPosX(248)
    self._uiAutoNaviBtn:SetSize(18, 18)
    self._uiNaviBtn:SetSize(18, 18)
  end
end
function HandleClicked_ShowMainQuestDetail(groupId, questId, checkCondition, groupTitle, questGroupCount)
  if false == _ContentsGroup_RenewUI then
    local fromQuestWidget = true
    FGlobal_QuestWindow_SetProgress()
    FGlobal_QuestInfoDetail(groupId, questId, checkCondition, groupTitle, questGroupCount, true)
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
  else
    audioPostEvent_SystemUi(0, 0)
    _AudioPostEvent_SystemUiForXBOX(50, 0)
    PaGlobal_MainQuest:showAcceptConditionTooltip(false)
    PaGlobalFunc_Quest_OpenDetail(groupId, questId, 1)
  end
end
function HandleClicked_MainQuest_FindWay(gruopNo, questNo, questCondition, isAuto, checkAcceptable, control)
  if 0 == checkAcceptable then
    local isAcceptable = questList_isAcceptableQuest(gruopNo, questNo)
    if false == isAcceptable then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MAINQUEST_CHECH_CONDITION_NOTICE"))
      return
    end
  end
  if false == _ContentsGroup_RenewUI then
    HandleClicked_QuestWindow_FindWay(gruopNo, questNo, questCondition, isAuto)
  else
    PaGlobalFunc_Quest_FindWay(gruopNo, questNo, isAuto)
  end
end
function PaGlobal_MainQuest:showAcceptConditionTooltip(show)
  if true == show then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWINDOW_ACCEPTCONDITION")
    local questList = ToClient_GetQuestList()
    local uiQuestInfo = questList:getMainQuestInfo()
    if nil ~= uiQuestInfo then
      local desc = uiQuestInfo:getAcceptConditionText()
      registTooltipControl(Panel_MainQuest, Panel_Tooltip_SimpleText)
      TooltipSimple_Show(Panel_MainQuest, name, desc)
    end
  else
    TooltipSimple_Hide()
  end
end
function PaGlobal_MainQuest:clearConditionInfo()
  self._uiQuestCompleteNpc:SetShow(false)
  self._uiQuestCompleteNpc:SetText("")
  for ii = 0, self._maxConditionCnt - 1 do
    self._uiQuestConditions[ii]:SetShow(false)
    self._uiQuestConditions[ii]:SetText("")
  end
end
function PaGlobal_MainQuest:ShowGroupBG(show)
  if true == show then
    self._uiGroupBG:SetShow(true)
  else
    self._uiGroupBG:SetShow(false)
  end
end
function PaGlobal_MainQuest:isHitTest(control)
  local panel = Panel_MainQuest
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panelPosX = panel:GetPosX()
  local panelPosY = panel:GetPosY()
  local bgPosX = panelPosX
  local bgPosY = panelPosY
  local bgSizeX = panel:GetSizeX()
  local bgSizeY = panel:GetSizeY()
  if mousePosX >= bgPosX and mousePosX <= bgPosX + bgSizeX and mousePosY >= bgPosY and mousePosY <= bgPosY + bgSizeY then
    return true
  end
  return false
end
function PaGlobal_MainQuest:setTooltipPos(posY)
  local uiTooltip = PaGlobal_MainQuest._uiTooltip
  local screenY = getScreenSizeY()
  local panelPosY = Panel_MainQuest:GetPosY()
  local tooltipSizeY = uiTooltip:GetSizeY()
  local buttonSizeY = PaGlobal_MainQuest._uiAutoNaviBtn:GetSizeY()
  if screenY < panelPosY + posY + tooltipSizeY then
    uiTooltip:SetPosY(posY - tooltipSizeY - 5)
  else
    uiTooltip:SetPosY(posY + buttonSizeY + 5)
  end
  uiTooltip:SetPosX(Panel_MainQuest:GetSizeX() - uiTooltip:GetSizeX() + 5)
end
function PaGlobal_MainQuest:isShownQuest(questNo)
  local questList = ToClient_GetQuestList()
  local uiQuestInfo = questList:getMainQuestInfo()
  if nil ~= uiQuestInfo then
    if uiQuestInfo:getQuestNo()._group == questNo._group and uiQuestInfo:getQuestNo()._quest == questNo._quest then
      return true
    else
      return false
    end
  end
  return false
end
function FGlobal_MainQuest_Update()
  PaGlobal_MainQuest:update()
end
function HandleMouseOver_Buttons(show, target)
  if true == _ContentsGroup_RenewUI then
    return
  end
  Panel_MainQuest:SetChildIndex(PaGlobal_MainQuest._uiTooltip, 9999)
  local uiTooltip = PaGlobal_MainQuest._uiTooltip
  local posY = 0
  if true == show then
    if "navi" == target then
      uiTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP"))
      posY = PaGlobal_MainQuest._uiAutoNaviBtn:GetPosY()
    elseif "Autonavi" == target then
      uiTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP"))
      posY = PaGlobal_MainQuest._uiNaviBtn:GetPosY()
    end
    PaGlobal_MainQuest:setTooltipPos(posY)
    uiTooltip:SetShow(true)
  else
    uiTooltip:SetShow(false)
  end
end
function HandleMouseOver_MainQuestWidget(isMouseOver, isAcceptedQuest)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if true == isMouseOver then
    PaGlobal_MainQuest:ShowGroupBG(true)
    PaGlobal_MainQuest:setButtonState(true)
    if PaGlobal_MainQuest._uiAutoNaviBtn:IsEnable() then
      PaGlobal_MainQuest._uiAutoNaviBtn:SetShow(true)
      PaGlobal_MainQuest._uiNaviBtn:SetShow(true)
    end
    isMouseOnWidget = true
  else
    if true == PaGlobal_MainQuest:isHitTest(PaGlobal_MainQuest._uiGroupBG) then
      return
    end
    local isSelectedNaviBtn = PaGlobal_MainQuest._uiAutoNaviBtn:IsCheck() or PaGlobal_MainQuest._uiNaviBtn:IsCheck()
    if false == isSelectedNaviBtn then
      PaGlobal_MainQuest:ShowGroupBG(false)
    end
    PaGlobal_MainQuest:setButtonState(false)
    PaGlobal_MainQuest._uiAutoNaviBtn:SetShow(false)
    PaGlobal_MainQuest._uiNaviBtn:SetShow(false)
    isMouseOnWidget = false
  end
  if 0 == isAcceptedQuest then
    PaGlobal_MainQuest:showAcceptConditionTooltip(isMouseOver)
  end
end
registerEvent("onScreenResize", "FromClient_MainQuestWidget_ResetPosition")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MainQuest")
registerEvent("FromClient_RenderModeChangeState", "renderModeChange_Panel_MainQuest_ResetPosition")
function FromClient_luaLoadComplete_MainQuest()
end
function FromClient_MainQuestWidget_ResetPosition()
  if true == ToClient_isConsole() then
    Panel_MainQuest:SetPosX(getOriginScreenSizeX() - Panel_MainQuest:GetSizeX() - 20)
    Panel_MainQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10)
    return
  end
  if Panel_MainQuest:GetRelativePosX() == -1 and Panel_MainQuest:GetRelativePosY() == -1 then
    local initPosX = getScreenSizeX() - Panel_MainQuest:GetSizeX() - 20
    local initPosY = FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10
    local haveServerPosition = 0 < ToClient_GetUiInfo(CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, 0, CppEnums.PanelSaveType.PanelSaveType_IsSaved)
    if not haveServerPosition then
      Panel_MainQuest:SetPosX(initPosX)
      Panel_MainQuest:SetPosY(initPosY)
    end
    changePositionBySever(Panel_MainQuest, CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, true, true, true)
    FGlobal_InitPanelRelativePos(Panel_MainQuest, initPosX, initPosY)
  elseif Panel_MainQuest:GetRelativePosX() == 0 and Panel_MainQuest:GetRelativePosY() == 0 then
    Panel_MainQuest:SetPosX(getScreenSizeX() - Panel_MainQuest:GetSizeX() - 20)
    Panel_MainQuest:SetPosY(FGlobal_Panel_Radar_GetPosY() + FGlobal_Panel_Radar_GetSizeY() + 10)
  else
    Panel_MainQuest:SetPosX(getScreenSizeX() * Panel_MainQuest:GetRelativePosX() - Panel_MainQuest:GetSizeX() / 2)
    Panel_MainQuest:SetPosY(getScreenSizeY() * Panel_MainQuest:GetRelativePosY() - Panel_MainQuest:GetSizeY() / 2)
  end
  FGlobal_PanelRepostionbyScreenOut(Panel_MainQuest)
end
function renderModeChange_Panel_MainQuest_ResetPosition(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  FromClient_MainQuestWidget_ResetPosition()
end
function PaGlobal_MainQuest_GetSizeY()
  return (Panel_MainQuest:GetSizeY())
end
function PaGlobal_MainQuest_GetPosY()
  return (Panel_MainQuest:GetPosY())
end
PaGlobal_MainQuest:initialize()
changePositionBySever(Panel_MainQuest, CppEnums.PAGameUIType.PAGameUIPanel_MainQuest, true, true, true)
