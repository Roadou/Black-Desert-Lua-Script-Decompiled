local _panel = Panel_LatestQuest
local UI_color = Defines.Color
local LatestQuest = {
  _ui = {
    txt_QuestTitle = UI.getChildControl(_panel, "StaticText_Quest_Title"),
    stc_QuestIcon = UI.getChildControl(_panel, "Static_Quest_Type"),
    txt_QuestGroupTitle = UI.getChildControl(_panel, "StaticText_WidgetGroupTitle"),
    txt_RemainQuest = UI.getChildControl(_panel, "StaticText_RemainQuest")
  },
  _config = {questInterval = 10},
  _questUIListTable = {},
  _maxQuestCount = 3,
  _maxQuestConditionCount = 5,
  _maxSizeY = 0
}
function LatestQuest:init()
  for uiIdx = 0, self._maxQuestCount - 1 do
    local questInfo = {}
    questInfo.group = UI.createAndCopyBasePropertyControl(_panel, "Static_GroupBG", _panel, "Static_GroupBG_" .. uiIdx)
    questInfo.mainTitle = UI.createAndCopyBasePropertyControl(_panel, "StaticText_Quest_Title", questInfo.group, "StaticText_Quest_Title_" .. uiIdx)
    questInfo.mainTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    questInfo.typeIcon = UI.createAndCopyBasePropertyControl(_panel, "Static_Quest_Type", questInfo.group, "Static_Quest_Type_" .. uiIdx)
    questInfo.groupTitle = UI.createAndCopyBasePropertyControl(_panel, "StaticText_WidgetGroupTitle", questInfo.group, "StaticText_WidgetGroupTitle_" .. uiIdx)
    local conditionGroup = {}
    for conditionIdx = 0, self._maxQuestConditionCount - 1 do
      conditionGroup[conditionIdx] = UI.createAndCopyBasePropertyControl(_panel, "StaticText_Quest_Demand", questInfo.group, "StaticText_Quest_Demand_" .. uiIdx .. "_" .. conditionIdx)
      conditionGroup[conditionIdx]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    end
    questInfo.condition = conditionGroup
    questInfo.group:SetShow(false)
    self._questUIListTable[uiIdx] = questInfo
  end
  self._ui.txt_RemainQuest:SetLineRender(false)
  self._ui.txt_RemainQuest:SetIgnore(true)
  self._ui.txt_RemainQuest:SetFontColor(UI_color.C_FFFAE696)
  self._ui.txt_RemainQuest:useGlowFont(true, "SubTitleFont_14_Glow", 4287655978)
  self:registEventHandler()
  PaGlobal_LatestQuest_OnResize()
  self:update()
  _panel:SetShow(_ContentsGroup_RenewUI)
end
function LatestQuest:registEventHandler()
  registerEvent("onScreenResize", "PaGlobal_LatestQuest_OnResize")
  registerEvent("FromClient_ChangeLatestQuestShowCount", "PaGlobal_LatestQuest_Update")
  registerEvent("FromClient_UpdateQuestList", "PaGlobal_LatestQuest_Update")
  registerEvent("FromClient_ChangeQuestWidgetType", "PaGlobal_LatestQuest_Update")
end
function LatestQuest:update()
  local questListInfo = ToClient_GetQuestList()
  local questCount = questListInfo:getLatestQuestCount()
  local mainQuestNo
  local mainQuestInfo = questListInfo:getMainQuestInfo()
  if nil ~= mainQuestInfo then
    mainQuestNo = mainQuestInfo:getQuestNo()
  end
  local currentCount = questCount
  local uiIdx = 0
  local totalPosY = 0
  PaGlobal_LatestQuest_OnResize()
  for questIdx = 0, questCount - 1 do
    if uiIdx >= self._maxQuestCount then
      break
    end
    local questNo = questListInfo:getLatestQuestAt(questIdx)
    if nil == mainQuestNo or questNo._quest ~= mainQuestNo._quest or questNo._group ~= mainQuestNo._group then
      local uiQuestInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
      local currentPosY = 0
      self:setTitleInfo(uiQuestInfo, uiIdx)
      self:setIconInfo(uiQuestInfo, uiIdx)
      currentPosY = self:setConditionInfo(uiQuestInfo, uiIdx)
      if totalPosY + currentPosY + self._config.questInterval > self._maxSizeY then
        break
      end
      self._questUIListTable[uiIdx].group:SetPosY(totalPosY)
      self._questUIListTable[uiIdx].group:SetShow(true)
      totalPosY = totalPosY + currentPosY + self._config.questInterval
      uiIdx = uiIdx + 1
    else
      currentCount = currentCount - 1
    end
  end
  for idx = uiIdx, self._maxQuestCount - 1 do
    self._questUIListTable[idx].group:SetShow(false)
  end
  if uiIdx < currentCount then
    self._ui.txt_RemainQuest:SetText("+ Remained : " .. currentCount - uiIdx)
    self._ui.txt_RemainQuest:SetShow(true)
    self._ui.txt_RemainQuest:SetPosY(totalPosY)
  else
    self._ui.txt_RemainQuest:SetShow(false)
  end
  _panel:SetSize(_panel:GetSizeX(), uiIdx * 80)
end
function LatestQuest:setTitleInfo(uiQuestInfo, uiIdx)
  local txt_Title = self._questUIListTable[uiIdx].mainTitle
  local questTitle = uiQuestInfo:getTitle()
  local questLevel = uiQuestInfo:getRecommendLevel()
  if nil ~= questLevel and 0 ~= questLevel then
    questTitle = "[" .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. questLevel .. "] " .. questTitle
  end
  txt_Title:SetLineRender(false)
  txt_Title:SetIgnore(true)
  txt_Title:SetFontColor(UI_color.C_FFEFEFEF)
  txt_Title:useGlowFont(true, "SubTitleFont_14_Glow", 4287655978)
  txt_Title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  txt_Title:SetText(questTitle)
end
function LatestQuest:setGroupTitleInfo(questNo, uiIdx)
  local questListInfo = ToClient_GetQuestList()
  local uiQuestGroupInfo = questListInfo:getQuestGroup(questNo)
  local txt_groupTitle = self._questUIListTable[uiIdx].groupTitle
  txt_groupTitle:SetShow(false)
  if nil ~= uiQuestGroupInfo and true == uiQuestGroupInfo:isGroupQuest() then
    local groupTitle = uiQuestGroupInfo:getTitle()
    local groupQuestTitleInfo = groupTitle .. " (" .. questNo._quest .. "/" .. uiQuestGroupInfo:getTotalQuestCount() .. ")"
    txt_groupTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    txt_groupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_GROUPTITLEINFO", "titleinfo", groupQuestTitleInfo))
    txt_groupTitle:SetSize(310, self._questUIListTable[uiIdx].mainTitle:GetSizeY())
    txt_groupTitle:SetAutoResize(true)
    txt_groupTitle:SetPosX(25)
    txt_groupTitle:SetFontColor(UI_color.C_FFEDE699)
    txt_groupTitle:SetShow(true)
    txt_groupTitle:SetIgnore(true)
    return true
  end
  return false
end
function LatestQuest:setIconInfo(uiQuestInfo, uiIdx)
  local questIcon = self._questUIListTable[uiIdx].typeIcon
  questIcon:EraseAllEffect()
  questIcon:SetShow(true)
  questIcon:SetIgnore(true)
  FGlobal_ChangeOnTextureForDialogQuestIcon(questIcon, uiQuestInfo:getQuestType())
end
function LatestQuest:setConditionInfo(uiQuestInfo, uiIdx)
  local txt_condition = self._questUIListTable[uiIdx].condition
  local questIcon = self._questUIListTable[uiIdx].typeIcon
  local txt_title = self._questUIListTable[uiIdx].mainTitle
  local PosY = 35
  local subGap = 20
  local questNo = uiQuestInfo:getQuestNo()
  local isGroupQuest = LatestQuest:setGroupTitleInfo(questNo, uiIdx)
  if false == uiQuestInfo:isSatisfied() then
    local conditionIdx = 0
    for idx = 0, uiQuestInfo:getDemandCount() - 1 do
      local conditionInfo = uiQuestInfo:getDemandAt(conditionIdx)
      txt_condition[conditionIdx]:SetAutoResize(true)
      txt_condition[conditionIdx]:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      txt_condition[conditionIdx]:setLineCountByLimitAutoWrap(4)
      txt_condition[conditionIdx]:SetFontColor(UI_color.C_FFC4BEBE)
      local conditionText
      if conditionInfo._currentCount == conditionInfo._destCount or conditionInfo._destCount <= conditionInfo._currentCount then
        conditionText = "- " .. conditionInfo._desc .. " (" .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_COMPLETE") .. ")"
        txt_condition[conditionIdx]:SetText(ToClient_getReplaceDialog(conditionText))
        txt_condition[conditionIdx]:SetLineRender(true)
        txt_condition[conditionIdx]:SetFontColor(UI_color.C_FF626262)
      elseif 1 == conditionInfo._destCount then
        conditionText = "- " .. conditionInfo._desc
        txt_condition[conditionIdx]:SetText(ToClient_getReplaceDialog(conditionText))
        txt_condition[conditionIdx]:SetLineRender(false)
      else
        conditionText = "- " .. conditionInfo._desc .. " (" .. conditionInfo._currentCount .. "/" .. conditionInfo._destCount .. ")"
        txt_condition[conditionIdx]:SetText(ToClient_getReplaceDialog(conditionText))
        txt_condition[conditionIdx]:SetLineRender(false)
      end
      if true == isGroupQuest then
        local groupTitle = self._questUIListTable[uiIdx].groupTitle
        if 0 == idx then
          txt_condition[conditionIdx]:SetPosY(groupTitle:GetPosY() + subGap)
        elseif idx > 0 then
          local gap = txt_condition[conditionIdx - 1]:GetPosY() + txt_condition[conditionIdx - 1]:GetTextSizeY()
          txt_condition[conditionIdx]:SetPosY(gap)
        end
        PosY = PosY + txt_condition[conditionIdx]:GetSizeY() + 5
      else
        txt_condition[conditionIdx]:SetPosY(PosY)
        PosY = PosY + txt_condition[conditionIdx]:GetSizeY()
      end
      txt_condition[conditionIdx]:SetShow(true)
      txt_condition[conditionIdx]:SetIgnore(true)
      conditionIdx = conditionIdx + 1
    end
    for idx = conditionIdx, self._maxQuestConditionCount - 1 do
      txt_condition[idx]:SetShow(false)
    end
  else
    if true == isGroupQuest then
      local groupTitle = self._questUIListTable[uiIdx].groupTitle
      txt_condition[0]:SetPosY(groupTitle:GetPosY() + subGap)
      PosY = PosY + txt_condition[0]:GetSizeY() + subGap
    else
      txt_condition[0]:SetPosY(txt_title:GetPosY() + subGap)
      PosY = PosY + txt_condition[0]:GetSizeY()
    end
    if true == uiQuestInfo:isCompleteBlackSpirit() then
      txt_condition[0]:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_CONSOLE_COMPLETE_BLACKSPIRIT"))
    else
      txt_condition[0]:SetText(" " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUEST_CONSOLE_COMPLETE_NORMAL"))
    end
    txt_condition[0]:SetFontColor(Defines.Color.C_FFF26A6A)
    txt_condition[0]:SetShow(true)
    FGlobal_ChangeOnTextureForDialogQuestIcon(questIcon, 8)
    for idx = 1, self._maxQuestConditionCount - 1 do
      txt_condition[idx]:SetShow(false)
    end
  end
  return PosY
end
function PaGlobal_LatestQuest_Init()
  local self = LatestQuest
  self:init()
end
function PaGlobal_LatestQuest_Update()
  local self = LatestQuest
  self:update()
end
function PaGlobal_LatestQuest_GetSizeY()
  return _panel:GetSizeY()
end
function PaGlobal_LatestQuest_GetPosY()
  return _panel:GetPosY()
end
function PaGlobal_LatestQuest_OnResize()
  local posX = getOriginScreenSizeX() - _panel:GetSizeX() - 20
  local posY = PaGlobal_MainQuest_GetPosY() + PaGlobal_MainQuest_GetSizeY()
  if true == PaGlobalFunc_GuildQuestWidget_GetShow() then
    posY = PaGlobalFunc_GuildQuestWidget_GetPosY() + PaGlobalFunc_GuildQuestWidget_GetSizeY() - 30
  end
  _panel:SetPosXY(posX, posY)
  local upperGapSizeY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
  LatestQuest._maxSizeY = getScreenSizeY() + upperGapSizeY - posY
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_LatestQuest_Init")
