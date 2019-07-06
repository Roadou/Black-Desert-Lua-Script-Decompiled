local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UIMode = Defines.UIMode
local IM = CppEnums.EProcessorInputMode
local _static_active = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
PaGlobal_LatestQuest = {
  _uiLatestGroup = UI.getChildControl(_static_active, "Static_QuestRecentUpdateGroupBg"),
  _uiTooltip = nil,
  _uiList = Array.new(),
  _maxVisibleCnt = 3,
  _maxConditionCnt = 5
}
function PaGlobal_LatestQuest:initialize()
  for ii = 0, self._maxVisibleCnt - 1 do
    local element = {}
    element._uiGroupBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_GroupBG", self._uiLatestGroup, "uiGroupBG_" .. ii)
    element._uiSelectBG = UI.createAndCopyBasePropertyControl(_static_active, "Static_SelectedQuestBG", element._uiGroupBG, "uiGroupSelectBG_" .. ii)
    element._uiQuestTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Title", element._uiGroupBG, "uiQuestTitle_" .. ii)
    element._uiGroupTitle = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_WidgetGroupTitle", element._uiGroupBG, "uiGroupTitle_" .. ii)
    element._uiQuestIcon = UI.createAndCopyBasePropertyControl(_static_active, "Static_Quest_Type", element._uiGroupBG, "uiQuestIcon_" .. ii)
    element._uiAutoNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "CheckButton_AutoNavi", element._uiGroupBG, "uiAutoNaviBtn_" .. ii)
    element._uiNaviBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Navi", element._uiGroupBG, "uiNaviBtn_" .. ii)
    element._uiGiveupBtn = UI.createAndCopyBasePropertyControl(_static_active, "Checkbox_Quest_Giveup", element._uiGroupBG, "uiGiveupBtn_" .. ii)
    element._uiCompleteNpc = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_ClearNpc", element._uiGroupBG, "uiCompleteNpc_" .. ii)
    element._questNo = {_groupId = 0, _questId = 0}
    element._uiQuestTitle:SetIgnore(true)
    element._uiGroupTitle:SetIgnore(true)
    element._uiQuestIcon:SetIgnore(true)
    element._uiConditions = Array.new()
    for jj = 0, self._maxConditionCnt - 1 do
      element._uiConditions[jj] = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Quest_Demand", element._uiGroupBG, "uiConditions_" .. ii .. "_" .. jj)
    end
    self._uiList[ii] = element
  end
  self._uiLatestGroup:SetShow(true)
  self._uiLatestGroup:SetIgnore(true)
  self._uiLatestGroup:SetPosX(2)
  self._uiLatestGroup:SetPosY(28)
  self._uiLatestGroup:SetNotAbleMasking(false)
  self._uiTooltip = UI.createAndCopyBasePropertyControl(_static_active, "StaticText_Notice_1", self._uiLatestGroup, "uiTooltipForLatestQuest")
  self._uiTooltip:SetColor(UI_color.C_FFFFFFFF)
  self._uiTooltip:SetAlpha(1)
  self._uiTooltip:SetFontColor(UI_color.C_FFC4BEBE)
  self._uiTooltip:SetAutoResize(true)
  self._uiTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._uiTooltip:SetShow(false)
  self._uiTooltip:SetNotAbleMasking(true)
  for ii = 0, self._maxVisibleCnt - 1 do
    self._uiList[ii]._uiGroupBG:SetSize(Panel_CheckedQuest:GetSizeX() - 18, 30)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiAutoNaviBtn, 9999)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiNaviBtn, 9999)
    self._uiList[ii]._uiGroupBG:SetChildIndex(self._uiList[ii]._uiGiveupBtn, 9999)
  end
end
PaGlobal_LatestQuest:initialize()
function PaGlobal_LatestQuest:update()
  self:clearAll()
  local groupStartY = 5
  local offsetY = 10
  local questListInfo = ToClient_GetQuestList()
  local questCount = questListInfo:getLatestQuestCount()
  local mainQuestInfo = questListInfo:getMainQuestInfo()
  local viewLimitCount = ToClient_GetLatestQuestShowCount()
  if 0 == viewLimitCount or 0 == questCount then
    self._uiLatestGroup:SetShow(false)
  else
    local viewCount = 0
    for ii = 0, questCount - 1 do
      if viewLimitCount > viewCount then
        local questEntry = self._uiList[viewCount]
        local questNo = questListInfo:getLatestQuestAt(ii)
        local uiQuestInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
        local isAlreadyShown = PaGlobal_MainQuest:isShownQuest(questNo)
        if nil ~= uiQuestInfo and false == isAlreadyShown then
          self:setGroupBG(viewCount, groupStartY, uiQuestInfo)
          self:setIcon(viewCount, uiQuestInfo:getQuestType())
          self:setTitle(viewCount, questNo._group, questNo._quest)
          self:setButtons(viewCount, uiQuestInfo)
          local nextPosY = questEntry._uiQuestTitle:GetPosY() + questEntry._uiQuestTitle:GetSizeY() + 2
          nextPosY = self:setGroupTitle(viewCount, nextPosY, questNo)
          nextPosY = self:setConditions(viewCount, nextPosY, uiQuestInfo)
          questEntry._uiGroupBG:SetSize(questEntry._uiGroupBG:GetSizeX(), nextPosY)
          questEntry._uiSelectBG:SetSize(questEntry._uiGroupBG:GetSizeX(), nextPosY)
          questEntry._questNo._groupId = questNo._group
          questEntry._questNo._questId = questNo._quest
          groupStartY = groupStartY + nextPosY + 5
          viewCount = viewCount + 1
        end
      end
    end
    self._uiLatestGroup:SetSize(Panel_CheckedQuest:GetSizeX() - 5, groupStartY + 5)
    if 0 == viewCount then
      self._uiLatestGroup:SetShow(false)
    else
      self._uiLatestGroup:SetShow(true)
    end
  end
end
function PaGlobal_LatestQuest:isShownQuest(questNo)
  local visibleCount = ToClient_GetLatestQuestShowCount()
  for ii = 0, visibleCount - 1 do
    local questEntry = self._uiList[ii]
    if questEntry._questNo._groupId == questNo._group and questEntry._questNo._questId == questNo._quest then
      return true
    end
  end
  return false
end
function PaGlobal_LatestQuest:setGroupBG(index, posY, uiQuestInfo)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    local questNo = uiQuestInfo:getQuestNo()
    local checkCondition
    if true == uiQuestInfo:isSatisfied() then
      checkCondition = 0
    else
      checkCondition = 1
    end
    local groupTitle = "nil"
    local questGroupCnt = 0
    local questListInfo = ToClient_GetQuestList()
    local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
    if nil ~= uiQuestGroupInfo then
      groupTitle = uiQuestGroupInfo:getTitle()
      questGroupCnt = uiQuestGroupInfo:getTotalQuestCount()
    end
    questEntry._uiGroupBG:SetAlpha(0)
    questEntry._uiGroupBG:SetShow(true)
    questEntry._uiGroupBG:SetPosX(5)
    questEntry._uiGroupBG:SetPosY(posY)
    questEntry._uiSelectBG:SetPosX(0)
    questEntry._uiSelectBG:SetPosY(0)
    if false == _ContentsGroup_RenewUI then
      questEntry._uiGroupBG:addInputEvent("Mouse_LUp", "HandleClicked_ShowQuestInfo( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", \"" .. groupTitle .. "\", " .. questGroupCnt .. " )")
      questEntry._uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_QuestWidget_FindTarget( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false )")
      questEntry._uiGroupBG:addInputEvent("Mouse_DownScroll", "QuestWidget_ScrollEvent( true )")
      questEntry._uiGroupBG:addInputEvent("Mouse_UpScroll", "QuestWidget_ScrollEvent( false )")
      questEntry._uiGroupBG:addInputEvent("Mouse_On", "HandleMouseOver_QuestGroup( true, " .. index .. ", " .. questNo._group .. ", " .. questNo._quest .. " )")
      questEntry._uiGroupBG:addInputEvent("Mouse_Out", "HandleMouseOver_QuestGroup( false, " .. index .. ", " .. questNo._group .. " )")
    end
  end
end
function PaGlobal_LatestQuest:setIcon(index, questType)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    questEntry._uiQuestIcon:EraseAllEffect()
    questEntry._uiQuestIcon:SetShow(true)
    questEntry._uiQuestIcon:SetPosX(2)
    questEntry._uiQuestIcon:SetPosY(2)
    FGlobal_ChangeOnTextureForDialogQuestIcon(questEntry._uiQuestIcon, questType)
  end
end
function PaGlobal_LatestQuest:setTitle(index, groupId, questId)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    local questTitle = self:getTitle(groupId, questId)
    questEntry._uiQuestTitle:SetAutoResize(true)
    questEntry._uiQuestTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    questEntry._uiQuestTitle:SetShow(true)
    questEntry._uiQuestTitle:SetIgnore(true)
    questEntry._uiQuestTitle:SetLineRender(false)
    questEntry._uiQuestTitle:SetPosX(questEntry._uiQuestIcon:GetPosX() + questEntry._uiQuestIcon:GetSizeX() + 2)
    questEntry._uiQuestTitle:SetPosY(2)
    questEntry._uiQuestTitle:SetSize(200, questEntry._uiQuestTitle:GetSizeY())
    questEntry._uiQuestTitle:SetText(questTitle)
    questEntry._uiQuestTitle:SetFontColor(UI_color.C_FFEFEFEF)
    questEntry._uiQuestTitle:useGlowFont(true, "BaseFont_8_Glow", 4287655978)
  end
end
function PaGlobal_LatestQuest:setGroupTitle(index, posY, questNo)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    local questListInfo = ToClient_GetQuestList()
    local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
    if nil ~= uiQuestGroupInfo then
      if true == uiQuestGroupInfo:isGroupQuest() then
        local groupTitle = uiQuestGroupInfo:getTitle()
        local groupQuestTitleInfo = groupTitle .. " (" .. questNo._quest .. "/" .. uiQuestGroupInfo:getTotalQuestCount() .. ")"
        questEntry._uiGroupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo))
        questEntry._uiGroupTitle:SetSize(230, questEntry._uiQuestTitle:GetSizeY())
        questEntry._uiGroupTitle:SetAutoResize(true)
        questEntry._uiGroupTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
        questEntry._uiGroupTitle:SetPosX(25)
        questEntry._uiGroupTitle:SetPosY(posY)
        questEntry._uiGroupTitle:SetFontColor(UI_color.C_FFEDE699)
        questEntry._uiGroupTitle:SetShow(true)
        questEntry._uiGroupTitle:SetIgnore(true)
        posY = posY + questEntry._uiGroupTitle:GetSizeY()
      else
        questEntry._uiGroupTiltle:SetShow(false)
      end
    end
  end
  posY = posY + 5
  return posY
end
function PaGlobal_LatestQuest:setConditions(index, PosY, uiQuestInfo)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    if false == uiQuestInfo:isSatisfied() then
      for index = 0, uiQuestInfo:getDemandCount() - 1 do
        local uiCondition = questEntry._uiConditions[index]
        local conditionInfo = uiQuestInfo:getDemandAt(index)
        uiCondition:SetAutoResize(true)
        uiCondition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        uiCondition:SetFontColor(UI_color.C_FFC4BEBE)
        if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
          uiCondition:SetPosX(10)
        else
          uiCondition:SetPosX(25)
        end
        uiCondition:SetPosY(PosY)
        uiCondition:SetSize(questEntry._uiGroupBG:GetSizeX() - uiCondition:GetPosX(), uiCondition:GetTextSizeY())
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
        PosY = PosY + uiCondition:GetSizeY() + 2
      end
    else
      questEntry._uiCompleteNpc:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      if 0 == uiQuestInfo:getQuestType() then
        questEntry._uiQuestIcon:AddEffect("UI_Quest_Complete_GoldAura", true, 130, 0)
        questEntry._uiCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC"))
        questEntry._uiCompleteNpc:SetFontColor(Defines.Color.C_FFF26A6A)
      elseif 0 < uiQuestInfo:getQuestType() then
        questEntry._uiQuestIcon:AddEffect("UI_Quest_Complete_GreenAura", true, 130, 0)
        questEntry._uiCompleteNpc:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_CHECKEDQUEST_QUESTCOMPLETENPC"))
        questEntry._uiCompleteNpc:SetFontColor(Defines.Color.C_FFF26A6A)
      end
      if questEntry._uiCompleteNpc:GetSizeX() < questEntry._uiCompleteNpc:GetTextSizeX() + 5 then
        questEntry._uiCompleteNpc:addInputEvent("Mouse_On", "PaGlobal_LatestQuest:textModeLimitTooltip(" .. index .. ", true)")
        questEntry._uiCompleteNpc:addInputEvent("Mouse_Out", "PaGlobal_LatestQuest:textModeLimitTooltip(" .. index .. ", false)")
        questEntry._uiCompleteNpc:SetIgnore(false)
      else
        questEntry._uiCompleteNpc:SetIgnore(true)
      end
      questEntry._uiCompleteNpc:SetLineRender(true)
      questEntry._uiCompleteNpc:SetShow(true)
      if 0 < ToClient_getGameOptionControllerWrapper():getUIFontSizeType() then
        questEntry._uiCompleteNpc:SetPosX(10)
      else
        questEntry._uiCompleteNpc:SetPosX(25)
      end
      questEntry._uiCompleteNpc:SetPosY(PosY)
      FGlobal_ChangeOnTextureForDialogQuestIcon(questEntry._uiQuestIcon, 8)
      PosY = PosY + questEntry._uiCompleteNpc:GetSizeY() + 3
      FGlobal_QuestWidget_AutoReleaseNavi(uiQuestInfo)
    end
  end
  return PosY
end
function PaGlobal_LatestQuest:textModeLimitTooltip(index, isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name = self._uiList[index]._uiCompleteNpc:GetText()
  local control = self._uiList[index]._uiCompleteNpc
  local desc = ""
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_LatestQuest:setButtons(index, uiQuestInfo)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    local questNo = uiQuestInfo:getQuestNo()
    local isMouseOnGroup = self:isHitTestInLatestQuestGroup(questEntry._uiGroupBG)
    self:setSizeConvenienceButtons(index, isMouseOnGroup)
    self:refreshNaviButtonCheckState(index, questNo)
    local autoNaviTooltipPos = questEntry._uiGroupBG:GetPosY() + questEntry._uiAutoNaviBtn:GetPosY()
    local naviTooltipPos = questEntry._uiGroupBG:GetPosY() + questEntry._uiNaviBtn:GetPosY()
    local giveupTooltipPos = questEntry._uiGroupBG:GetPosY() + questEntry._uiGiveupBtn:GetPosY()
    local checkCondition
    if true == uiQuestInfo:isSatisfied() then
      checkCondition = 0
    else
      checkCondition = 1
    end
    local questStaticStatus = questList_getQuestStatic(uiQuestInfo:getQuestNo()._group, uiQuestInfo:getQuestNo()._quest)
    local posCount = questStaticStatus:getQuestPositionCount()
    local isCleared = uiQuestInfo._isCleared
    local enableNavi = true
    if false == uiQuestInfo:isSatisfied() and 0 == posCount then
      enableNavi = false
    end
    local isMouseOn = FGlobal_QuestWidget_IsMouseOn()
    if true == enableNavi then
      questEntry._uiAutoNaviBtn:SetShow(isMouseOn)
      questEntry._uiNaviBtn:SetShow(isMouseOn)
    end
    questEntry._uiAutoNaviBtn:SetEnable(enableNavi)
    questEntry._uiNaviBtn:SetEnable(enableNavi)
    local selfLevel = getSelfPlayer():get():getLevel()
    local enableGiveup = selfLevel > 10 and not isCleared
    questEntry._uiGiveupBtn:SetEnable(enableGiveup)
    if true == enableGiveup then
      questEntry._uiGiveupBtn:SetShow(isMouseOn)
    end
    questEntry._uiAutoNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_LatestQuestGroupButtons( true," .. autoNaviTooltipPos .. ", \"autoNavi\", " .. index .. "  )")
    questEntry._uiAutoNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_LatestQuestGroupButtons( false," .. autoNaviTooltipPos .. ", \"autoNavi\", " .. index .. "  )")
    questEntry._uiNaviBtn:addInputEvent("Mouse_On", "HandleMouseOver_LatestQuestGroupButtons( true," .. naviTooltipPos .. ", \"navi\", " .. index .. "  )")
    questEntry._uiNaviBtn:addInputEvent("Mouse_Out", "HandleMouseOver_LatestQuestGroupButtons( false," .. naviTooltipPos .. ", \"navi\", " .. index .. "  )")
    questEntry._uiGiveupBtn:addInputEvent("Mouse_On", "HandleMouseOver_LatestQuestGroupButtons( true," .. giveupTooltipPos .. ", \"giveup\", " .. index .. "  )")
    questEntry._uiGiveupBtn:addInputEvent("Mouse_Out", "HandleMouseOver_LatestQuestGroupButtons( false," .. giveupTooltipPos .. ", \"giveup\", " .. index .. "  )")
    questEntry._uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", false )")
    questEntry._uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. questNo._group .. ", " .. questNo._quest .. ", " .. checkCondition .. ", true )")
    questEntry._uiGiveupBtn:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp( " .. questNo._group .. ", " .. questNo._quest .. ") ")
    if true == uiQuestInfo:isSatisfied() and uiQuestInfo:isCompleteBlackSpirit() then
      questEntry._uiGroupBG:addInputEvent("Mouse_RUp", "HandleClicked_CallBlackSpirit()")
      questEntry._uiAutoNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
      questEntry._uiNaviBtn:addInputEvent("Mouse_LUp", "HandleClicked_CallBlackSpirit()")
    end
  end
end
function PaGlobal_LatestQuest:refreshNaviButtonCheckState(index, questNo)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    local questGroup, questId, naviInfoAgain = FGlobal_QuestWidget_GetSelectedNaviInfo()
    if questGroup == questNo._group and questId == questNo._quest then
      if true == naviInfoAgain then
        questEntry._uiSelectBG:SetShow(false)
        questEntry._uiAutoNaviBtn:SetCheck(false)
        questEntry._uiNaviBtn:SetCheck(false)
      else
        questEntry._uiSelectBG:SetShow(true)
        if true == questEntry._uiAutoNaviBtn:IsCheck() then
          questEntry._uiAutoNaviBtn:SetCheck(true)
          questEntry._uiNaviBtn:SetCheck(true)
        else
          questEntry._uiAutoNaviBtn:SetCheck(false)
          questEntry._uiNaviBtn:SetCheck(true)
        end
      end
    else
      questEntry._uiSelectBG:SetShow(false)
      questEntry._uiAutoNaviBtn:SetCheck(false)
      questEntry._uiNaviBtn:SetCheck(false)
    end
  end
end
function PaGlobal_LatestQuest:isHitTestInLatestQuestGroup(control)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local panelPosX = Panel_CheckedQuest:GetPosX()
  local panelPosY = Panel_CheckedQuest:GetPosY()
  local bgPosX = panelPosX + self._uiLatestGroup:GetPosX() + control:GetPosX()
  local bgPosY = panelPosY + self._uiLatestGroup:GetPosY() + control:GetPosY()
  local bgSizeX = control:GetSizeX() - 3
  local bgSizeY = control:GetSizeY() - 3
  if mousePosX >= bgPosX and mousePosX <= bgPosX + bgSizeX and mousePosY >= bgPosY and mousePosY <= bgPosY + bgSizeY then
    return true
  end
  return false
end
function PaGlobal_LatestQuest:setSizeConvenienceButtons(index, isMouseOver)
  if index < self._maxVisibleCnt then
    local questEntry = self._uiList[index]
    questEntry._uiAutoNaviBtn:SetPosY(5)
    questEntry._uiNaviBtn:SetPosY(5)
    questEntry._uiGiveupBtn:SetPosY(5)
    if true == isMouseOver then
      questEntry._uiAutoNaviBtn:SetPosX(262)
      questEntry._uiNaviBtn:SetPosX(237)
      questEntry._uiGiveupBtn:SetPosX(212)
      questEntry._uiAutoNaviBtn:SetSize(25, 25)
      questEntry._uiNaviBtn:SetSize(25, 25)
      questEntry._uiGiveupBtn:SetSize(25, 25)
    else
      questEntry._uiAutoNaviBtn:SetPosX(265)
      questEntry._uiNaviBtn:SetPosX(245)
      questEntry._uiGiveupBtn:SetPosX(225)
      questEntry._uiAutoNaviBtn:SetSize(18, 18)
      questEntry._uiNaviBtn:SetSize(18, 18)
      questEntry._uiGiveupBtn:SetSize(18, 18)
    end
  end
end
function PaGlobal_LatestQuest:getTitle(groupId, questId)
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
function PaGlobal_LatestQuest:clearAll()
  for ii = 0, self._maxVisibleCnt - 1 do
    self._uiList[ii]._uiGroupBG:SetShow(false)
    self._uiList[ii]._uiSelectBG:SetShow(false)
    self._uiList[ii]._uiQuestTitle:SetShow(false)
    self._uiList[ii]._uiGroupTitle:SetShow(false)
    self._uiList[ii]._uiQuestIcon:SetShow(false)
    self._uiList[ii]._uiCompleteNpc:SetShow(false)
    self._uiList[ii]._uiAutoNaviBtn:SetShow(false)
    self._uiList[ii]._uiNaviBtn:SetShow(false)
    self._uiList[ii]._uiGiveupBtn:SetShow(false)
    for jj = 0, self._maxConditionCnt - 1 do
      self._uiList[ii]._uiConditions[jj]:SetShow(false)
    end
  end
end
function PaGlobal_LatestQuest:setTooltipPos(posY, idx)
  local questEntry = self._uiList[idx]
  local uiTooltip = self._uiTooltip
  local screenY = getScreenSizeY()
  local panelPosY = Panel_CheckedQuest:GetPosY()
  local tooltipSizeY = uiTooltip:GetSizeY()
  local buttonSizeY = questEntry._uiAutoNaviBtn:GetSizeY()
  if screenY < panelPosY + posY + tooltipSizeY then
    uiTooltip:SetPosY(posY - tooltipSizeY - 5)
  else
    uiTooltip:SetPosY(posY + buttonSizeY + 5)
  end
  uiTooltip:SetPosX(Panel_CheckedQuest:GetSizeX() - uiTooltip:GetSizeX() + 5)
end
function PaGlobal_LatestQuest:setVisibleConvenienceButtonGroup(show)
  for ii = 0, self._maxVisibleCnt - 1 do
    self:setVisibleConvenienceButtons(ii, show)
  end
end
function PaGlobal_LatestQuest:setVisibleConvenienceButtons(idx, show)
  if idx < self._maxVisibleCnt then
    if true == show then
      local isMouseOn = FGlobal_QuestWidget_IsMouseOn()
      if self._uiList[idx]._uiAutoNaviBtn:IsEnable() then
        self._uiList[idx]._uiAutoNaviBtn:SetShow(isMouseOn)
        self._uiList[idx]._uiNaviBtn:SetShow(isMouseOn)
      end
      local selfLevel = getSelfPlayer():get():getLevel()
      if selfLevel > 10 then
        self._uiList[idx]._uiGiveupBtn:SetShow(isMouseOn)
      end
    else
      self._uiList[idx]._uiAutoNaviBtn:SetShow(false)
      self._uiList[idx]._uiNaviBtn:SetShow(false)
      self._uiList[idx]._uiGiveupBtn:SetShow(false)
    end
  end
end
function PaGlobal_LatestQuest:setWidgetMouseOver(isMouseOver)
  FGlobal_QuestWidget_MouseOver(isMouseOver)
end
function PaGlobal_LatestQuest:getLatestGroupPosX()
  return self._uiLatestGroup:GetPosX()
end
function PaGlobal_LatestQuest:getLatestGroupPosY()
  return self._uiLatestGroup:GetPosY()
end
function PaGlobal_LatestQuest:getLatestGroupSizeX()
  return self._uiLatestGroup:GetSizeX()
end
function PaGlobal_LatestQuest:getLatestGroupSizeY()
  if false == self._uiLatestGroup:GetShow() then
    return 5
  end
  return self._uiLatestGroup:GetSizeY()
end
function PaGlobal_LatestQuest:findShownIndexInLatestQuest(questGroupNo, questId)
  local uiIndex = -1
  local latestQuestShowCount = FGlobal_CheckedQuestOptionPanel_GetLatestQuestShowCount()
  if 0 == latestQuestShowCount then
    return -1
  end
  for ii = 0, self._maxVisibleCnt - 1 do
    local questNo = self._uiList[ii]._questNo
    if questNo._groupId == questGroupNo and questNo._questId == questId then
      uiIndex = ii
      break
    end
  end
  if latestQuestShowCount >= uiIndex then
    return uiIndex
  end
  return -1
end
function HandleMouseOver_QuestGroup(isMouseOver, index, groupId, questId)
  if true == _ContentsGroup_RenewUI then
    return
  end
  if index < PaGlobal_LatestQuest._maxVisibleCnt then
    local questEntry = PaGlobal_LatestQuest._uiList[index]
    if true == isMouseOver then
      questEntry._uiSelectBG:SetShow(true)
      PaGlobal_LatestQuest:setSizeConvenienceButtons(index, true)
      FGlobal_QuestWidget_MouseOver(true)
    else
      local isCheckedNaviBtn = questEntry._uiAutoNaviBtn:IsCheck() or questEntry._uiNaviBtn:IsCheck()
      if false == isCheckedNaviBtn then
        questEntry._uiSelectBG:SetShow(false)
      end
      if true == PaGlobal_LatestQuest:isHitTestInLatestQuestGroup(questEntry._uiGroupBG) then
        return
      end
      PaGlobal_LatestQuest:setSizeConvenienceButtons(index, false)
      FGlobal_QuestWidget_MouseOver(false)
    end
  end
end
function HandleMouseOver_LatestQuestGroupButtons(isMouseOver, posY, target, index)
  local uiTooltip = PaGlobal_LatestQuest._uiTooltip
  if true == isMouseOver then
    if "navi" == target then
      uiTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_NAVITOOLTIP"))
    elseif "autoNavi" == target then
      uiTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_AUTONAVITOOLTIP"))
    elseif "giveup" == target then
      uiTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GIVEUPTOOLTIP"))
    end
    PaGlobal_LatestQuest:setTooltipPos(posY, index)
    uiTooltip:SetShow(true)
  else
    uiTooltip:SetShow(false)
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_LatestQuest")
registerEvent("FromClient_ChangeLatestQuestShowCount", "FromClient_ChangeLatestQuestShowCount")
function FGlobal_LatestQuest_UpdateList()
  PaGlobal_LatestQuest:update()
end
function FGlobal_ChangeLatestQuestShowCount()
  PaGlobal_LatestQuest:update()
  FromClient_QuestWidget_Update(false)
end
function FGlobal_LatestQuestWidget_MouseOver(isMouseOver)
  PaGlobal_LatestQuest:setVisibleConvenienceButtonGroup(isMouseOver)
end
function FromClient_ChangeLatestQuestShowCount()
  FGlobal_ChangeLatestQuestShowCount()
end
function FromClient_luaLoadComplete_LatestQuest()
end
local viewCount = PaGlobal_LatestQuest._maxVisibleCnt
