local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_CheckedQuestInfo:ActiveMouseEventEffect(true)
Panel_CheckedQuestInfo:setGlassBackground(true)
Panel_CheckedQuestInfo:SetShow(false, false)
Panel_CheckedQuestInfo:RegisterShowEventFunc(true, "Panel_CheckedQuestInfo_ShowAni()")
Panel_CheckedQuestInfo:RegisterShowEventFunc(false, "Panel_CheckedQuestInfo_HideAni()")
function Panel_CheckedQuestInfo_ShowAni()
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  Panel_CheckedQuestInfo:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_CheckedQuestInfo, 0, 0.15)
  local aniInfo1 = Panel_CheckedQuestInfo:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_CheckedQuestInfo:GetSizeX() / 2
  aniInfo1.AxisY = Panel_CheckedQuestInfo:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_CheckedQuestInfo:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_CheckedQuestInfo:GetSizeX() / 2
  aniInfo2.AxisY = Panel_CheckedQuestInfo:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_CheckedQuestInfo_HideAni()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
  Panel_CheckedQuestInfo:SetAlpha(1)
  local aniInfo1 = UIAni.AlphaAnimation(0, Panel_CheckedQuestInfo, 0, 0.1)
  aniInfo1:SetHideAtEnd(true)
end
local questInfoWindow_questTitle = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_QuestTitle")
local questInfoWindow_questCondition = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_QuestCondition")
local questInfoWindow_questDesc = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_QuestDesc")
local questInfoWindow_frameQuestDesc = UI.getChildControl(Panel_CheckedQuestInfo, "Frame_QuestDesc")
local questInfoWindow_frameQuestDescContent = questInfoWindow_frameQuestDesc:GetFrameContent()
local questInfoWindow_questIcon = UI.getChildControl(Panel_CheckedQuestInfo, "Static_QuestIcon")
local questInfoWindow_questIconBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_IconBackground")
local questInfoWindow_questTitleBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Quest_QuestTitle_BG")
local questInfoWindow_groupTitle = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_GroupTitle")
local questInfoWindow_completeNpc = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_QuestCompleteNpc")
local questInfoWindow_naviButton = UI.getChildControl(Panel_CheckedQuestInfo, "Checkbox_Quest_Navi")
local questInfoWindow_giveupButton = UI.getChildControl(Panel_CheckedQuestInfo, "Checkbox_Quest_Giveup")
local questInfoWindow_questButtonClose = UI.getChildControl(Panel_CheckedQuestInfo, "Button_Win_Close")
local subBg = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SubBg")
questInfoWindow_questButtonClose:addInputEvent("Mouse_LUp", "FGlobal_QuestInfoDetail_Close()")
local button_Giveup_QuestInfoWindow = UI.getChildControl(Panel_CheckedQuestInfo, "Button_Quest_GiveUp")
local button_CallSpirit_QuestInfoWindow = UI.getChildControl(Panel_CheckedQuestInfo, "Button_Quest_CallSpirit")
local button_Navi_QuestInfoWindow = UI.getChildControl(Panel_CheckedQuestInfo, "CheckBtn_Quest_Navi")
local button_AutoNavi_QuestInfoWindow = UI.getChildControl(Panel_CheckedQuestInfo, "CheckBtn_Quest_AutoNavi")
local _baseReward = {}
local _maxBaseSlotCount = 12
local _uiBackBaseReward = {}
local _listBaseRewardSlots = {}
local _selectReward = {}
local _selectRewardCount = 0
local _maxSelectSlotCount = 6
local _uiButtonSelectRewardSlots = {}
local _listSelectRewardSlots = {}
local _questrewardSlotConfig = {
  createIcon = true,
  createBorder = true,
  createEnchant = true,
  createCount = true,
  createClassEquipBG = true,
  createCash = true
}
local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local expTooltipBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_2")
local expTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_CheckedQuestInfo, "expTooltip_ForQuestWidgetInfo")
CopyBaseProperty(expTooltipBase, expTooltip)
expTooltip:SetColor(UI_color.C_FFFFFFFF)
expTooltip:SetAlpha(1)
expTooltip:SetFontColor(UI_color.C_FFFFFFFF)
expTooltip:SetAutoResize(true)
expTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
expTooltip:SetTextHorizonCenter()
expTooltip:SetShow(false)
local reward_TitleBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_RewardTitleBG")
local reward_Title = UI.getChildControl(Panel_CheckedQuestInfo, "StaticText_RewardTitle")
local baseRewardBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_BG_0")
local lineHeight = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Line_Height")
local baseRewardTitle = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Menu_Reward")
local lineWidth = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Line_0")
local selectRewardTitle = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Menu_Reward_Select")
local selectRewardBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_BG_1")
local baseSlotBG0 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_0")
local baseSlotBG1 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_1")
local baseSlotBG2 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_2")
local baseSlotBG3 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_3")
local baseSlotBG4 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_4")
local baseSlotBG5 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_5")
local baseSlotBG6 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_6")
local baseSlotBG7 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_7")
local baseSlotBG8 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_8")
local baseSlotBG9 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_9")
local baseSlotBG10 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_10")
local baseSlotBG11 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_11")
local baseSlot0 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_0")
local baseSlot1 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_1")
local baseSlot2 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_2")
local baseSlot3 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_3")
local baseSlot4 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_4")
local baseSlot5 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_5")
local baseSlot6 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_6")
local baseSlot7 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_7")
local baseSlot8 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_8")
local baseSlot9 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_9")
local baseSlot10 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_10")
local baseSlot11 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_11")
local selectSlotBG0 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_0")
local selectSlotBG1 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_1")
local selectSlotBG2 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_2")
local selectSlotBG3 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_3")
local selectSlotBG4 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_4")
local selectSlotBG5 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_5")
local selectSlot0 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_0")
local selectSlot1 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_1")
local selectSlot2 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_2")
local selectSlot3 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_3")
local selectSlot4 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_4")
local selectSlot5 = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_5")
for index = 0, _maxBaseSlotCount - 1 do
  local backBaseReward = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_" .. index)
  backBaseReward:SetIgnore(true)
  _uiBackBaseReward[index] = backBaseReward
  local slot = {}
  SlotItem.new(slot, "BaseReward_" .. index, index, backBaseReward, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(1)
  slot.icon:SetPosY(1)
  slot.icon:SetSize(40, 40)
  slot.border:SetSize(42, 42)
  slot.icon:SetIgnore(false)
  slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",true)")
  slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",false)")
  _listBaseRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "QuestReward_Base")
end
for index = 0, _maxSelectSlotCount - 1 do
  local buttonSelectRewardSlot = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_" .. index)
  _uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot
  local slot = {}
  SlotItem.new(slot, "SelectReward_" .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(3)
  slot.icon:SetPosY(1)
  slot.border:SetSize(41, 41)
  slot.border:SetPosX(1)
  slot.border:SetPosY(0)
  slot.icon:SetIgnore(false)
  _listSelectRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "QuestReward_Select")
end
function limitTextTooltip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name = questInfoWindow_groupTitle:GetText()
  local control = questInfoWindow_groupTitle
  local desc = ""
  TooltipSimple_Show(control, name, desc)
end
function FGlobal_QuestInfoDetail(groupId, questId, uiCondition, groupTitle, questGroupCount, fromQuestWidget, isRecommand, isNextQuest, isCleared)
  if Panel_CheckedQuestInfo:IsUISubApp() then
    Panel_CheckedQuestInfo:CloseUISubApp()
  end
  if false == isCleared then
    button_CallSpirit_QuestInfoWindow:SetShow(true)
    button_Giveup_QuestInfoWindow:SetShow(true)
    button_Navi_QuestInfoWindow:SetShow(true)
    button_AutoNavi_QuestInfoWindow:SetShow(true)
    questInfoWindow_giveupButton:SetShow(true)
    questInfoWindow_naviButton:SetShow(true)
    baseRewardTitle:SetShow(true)
    selectRewardTitle:SetShow(true)
    reward_Title:SetShow(true)
    for i = 0, 11 do
      local _baseSlotBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_" .. i)
      local _baseSlot = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_" .. i)
      if i <= 5 then
        local _selectSlotBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_" .. i)
        local _selectSlot = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_" .. i)
        _selectSlotBG:SetShow(true)
        _selectSlot:SetShow(true)
      end
      _baseSlotBG:SetShow(true)
      _baseSlot:SetShow(true)
    end
  end
  if _questInfoDetailGroupId == groupId and _questInfoDetailQuestId == questId then
    FGlobal_QuestInfoDetail_Close()
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local questWindowX = Panel_Window_Quest_New:GetPosX()
  local questWindowY = Panel_Window_Quest_New:GetPosY()
  if false == Panel_Window_Quest_New:GetShow() then
    Panel_Window_QuestNew_Show(true)
  end
  _questInfoDetailGroupId = groupId
  _questInfoDetailQuestId = questId
  local questInfo = questList_getQuestStatic(groupId, questId)
  local completeNpc = questInfo:getCompleteDisplay()
  local isNext = true
  if nil == isNextQuest then
    isNext = false
  else
    isNext = isNextQuest
  end
  local PosY = 70
  questInfoWindow_groupTitle:SetShow(true)
  questInfoWindow_groupTitle:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  if "nil" ~= groupTitle then
    local tempValue = groupTitle .. " (" .. questId .. "/" .. questGroupCount .. " "
    questInfoWindow_groupTitle:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_GROUP_TITLE", "value", tempValue))
  elseif true == isRecommand then
    questInfoWindow_groupTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_QUESTWINDOW_TAB_RECOMMAND"))
  else
    questInfoWindow_groupTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTWIDGET_QUESTINFO_NORMAL_TITLE"))
  end
  if questInfoWindow_groupTitle:GetSizeX() < questInfoWindow_groupTitle:GetTextSizeX() + 20 then
    questInfoWindow_groupTitle:addInputEvent("Mouse_On", "limitTextTooltip(true)")
    questInfoWindow_groupTitle:addInputEvent("Mouse_Out", "limitTextTooltip(false)")
  end
  questInfoWindow_groupTitle:SetPosY(PosY)
  questInfoWindow_groupTitle:SetFontColor(UI_color.C_FFEEBA3E)
  PosY = PosY + questInfoWindow_groupTitle:GetSizeY() + 5
  questInfoWindow_questTitleBG:SetShow(true)
  questInfoWindow_questTitleBG:SetPosY(PosY)
  questInfoWindow_questTitle:SetShow(true)
  questInfoWindow_questTitle:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  questInfoWindow_questTitle:SetText(questInfo:getTitle())
  questInfoWindow_questTitle:SetPosY(PosY)
  questInfoWindow_naviButton:SetShow(true)
  questInfoWindow_naviButton:SetPosY(PosY + 2)
  questInfoWindow_naviButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. uiCondition .. ", false )")
  local isProgressQuest = ToClient_isProgressingQuest(groupId, questId)
  questInfoWindow_giveupButton:SetShow(isProgressQuest)
  questInfoWindow_giveupButton:SetPosY(PosY + 2)
  questInfoWindow_giveupButton:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp(" .. groupId .. "," .. questId .. ")")
  button_Giveup_QuestInfoWindow:SetShow(not isNext)
  button_Giveup_QuestInfoWindow:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_QuestGiveUp(" .. groupId .. "," .. questId .. ")")
  button_CallSpirit_QuestInfoWindow:SetShow(false)
  button_CallSpirit_QuestInfoWindow:addInputEvent("Mouse_LUp", "HandleClicked_CallSpirit()")
  button_Navi_QuestInfoWindow:SetShow(true)
  button_Navi_QuestInfoWindow:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. uiCondition .. ", false )")
  button_AutoNavi_QuestInfoWindow:SetShow(true)
  button_AutoNavi_QuestInfoWindow:addInputEvent("Mouse_LUp", "HandleClicked_QuestWidget_FindTarget( " .. groupId .. ", " .. questId .. ", " .. uiCondition .. ", true )")
  local _questGroupId, _questId, _naviInfoAgain = _QuestWidget_ReturnQuestState()
  if _questGroupId == groupId and _questId == questId then
    if true == _naviInfoAgain then
      questInfoWindow_naviButton:SetCheck(false)
      button_Navi_QuestInfoWindow:SetCheck(false)
    else
      questInfoWindow_naviButton:SetCheck(true)
      button_Navi_QuestInfoWindow:SetCheck(true)
    end
  else
    questInfoWindow_naviButton:SetCheck(false)
    button_Navi_QuestInfoWindow:SetCheck(false)
  end
  if 0 == uiCondition and 0 == questInfo:getCompleteNpc():get() then
    questInfoWindow_naviButton:SetShow(false)
    button_Navi_QuestInfoWindow:SetShow(false)
    button_AutoNavi_QuestInfoWindow:SetShow(false)
    button_CallSpirit_QuestInfoWindow:SetShow(true)
  end
  local questPosCount = questInfo:getQuestPositionCount()
  if 0 ~= uiCondition and 0 == questPosCount then
    questInfoWindow_naviButton:SetShow(false)
    button_Navi_QuestInfoWindow:SetShow(false)
    button_AutoNavi_QuestInfoWindow:SetShow(false)
  end
  PosY = PosY + questInfoWindow_questTitle:GetSizeY()
  questInfoWindow_questIcon:SetShow(true)
  questInfoWindow_questIcon:SetPosY(PosY + 3)
  questInfoWindow_questIcon:ChangeTextureInfoName(questInfo:getIconPath())
  questInfoWindow_questIconBG:SetShow(true)
  questInfoWindow_questIconBG:SetPosY(PosY + 1)
  questInfoWindow_completeNpc:SetShow(true)
  questInfoWindow_completeNpc:SetPosY(PosY)
  questInfoWindow_completeNpc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", completeNpc))
  PosY = PosY + questInfoWindow_completeNpc:GetSizeY()
  local demandCount = questInfo:getDemadCount()
  local demandString = ""
  for demandIndex = 0, demandCount - 1 do
    local demand = questInfo:getDemandAt(demandIndex)
    demandString = demandString .. "- " .. demand._desc .. "\n"
  end
  questInfoWindow_questCondition:SetShow(true)
  questInfoWindow_questCondition:SetTextMode(UI_TM.eTextMode_AutoWrap)
  questInfoWindow_questCondition:SetAutoResize(true)
  questInfoWindow_questCondition:SetText(tostring(ToClient_getReplaceDialog(demandString)))
  questInfoWindow_questCondition:SetPosY(PosY)
  local imgENDPosY = questInfoWindow_questIcon:GetPosY() + questInfoWindow_questIcon:GetSizeY()
  local conditionENDPosY = questInfoWindow_questCondition:GetPosY() + questInfoWindow_questCondition:GetSizeY()
  if imgENDPosY < conditionENDPosY then
    PosY = conditionENDPosY + 5
  else
    PosY = imgENDPosY + 5
  end
  local txt_isQuestDesc = UI.getChildControl(questInfoWindow_frameQuestDescContent, "StaticText_Desc")
  questInfoWindow_frameQuestDesc:SetPosX(20)
  questInfoWindow_frameQuestDesc:SetSize(questInfoWindow_frameQuestDesc:GetSizeX(), 200)
  txt_isQuestDesc:SetShow(true)
  txt_isQuestDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  txt_isQuestDesc:SetText(ToClient_getReplaceDialog(questInfo:getDesc()))
  txt_isQuestDesc:setLocalizedStaticType(18)
  txt_isQuestDesc:setLocalizedKey(questInfo:getDescLocalizedKey())
  txt_isQuestDesc:SetIgnore(true)
  txt_isQuestDesc:SetSize(txt_isQuestDesc:GetSizeX(), txt_isQuestDesc:GetTextSizeY() + 10)
  questInfoWindow_frameQuestDescContent:SetSize(txt_isQuestDesc:GetSizeX(), txt_isQuestDesc:GetTextSizeY() + 10)
  questInfoWindow_frameQuestDesc:SetPosY(PosY)
  questInfoWindow_frameQuestDesc:GetVScroll():SetControlTop()
  questInfoWindow_frameQuestDesc:UpdateContentScroll()
  questInfoWindow_frameQuestDesc:UpdateContentPos()
  if 200 > txt_isQuestDesc:GetTextSizeY() then
    questInfoWindow_frameQuestDesc:SetIgnore(true)
    questInfoWindow_frameQuestDesc:GetVScroll():SetShow(false)
    PosY = PosY + txt_isQuestDesc:GetTextSizeY()
  else
    questInfoWindow_frameQuestDesc:SetIgnore(false)
    questInfoWindow_frameQuestDesc:GetVScroll():SetShow(true)
    questInfoWindow_frameQuestDesc:GetVScroll():SetSize(4, 200)
    PosY = PosY + questInfoWindow_frameQuestDesc:GetSizeY()
  end
  txt_isQuestDesc:ComputePos()
  if Panel_Window_Quest_New:GetShow() then
    if Panel_Window_Quest_New:IsUISubApp() then
      Panel_CheckedQuestInfo:SetPosX(Panel_Window_Quest_New:GetScreenParentPosX() + Panel_Window_Quest_New:GetSizeX())
      Panel_CheckedQuestInfo:SetPosY(Panel_Window_Quest_New:GetScreenParentPosY() + 10)
    else
      Panel_CheckedQuestInfo:SetPosX(questWindowX + Panel_Window_Quest_New:GetSizeX())
      Panel_CheckedQuestInfo:SetPosY(questWindowY + 10)
    end
  else
    Panel_CheckedQuestInfo:SetPosX(getScreenSizeX() - getScreenSizeX() / 2 - Panel_CheckedQuestInfo:GetSizeX() / 2)
    Panel_CheckedQuestInfo:SetPosY(getScreenSizeY() - getScreenSizeY() / 2 - Panel_CheckedQuestInfo:GetSizeY() / 2)
  end
  if 10 > getSelfPlayer():get():getLevel() then
    button_Giveup_QuestInfoWindow:SetShow(false)
    questInfoWindow_giveupButton:SetShow(false)
    if 0 == uiCondition and 0 == questInfo:getQuestType() then
      button_CallSpirit_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 - button_CallSpirit_QuestInfoWindow:GetSizeX() / 2)
    else
      button_Navi_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 - (button_Navi_QuestInfoWindow:GetSizeX() / 2 + 30))
      button_AutoNavi_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 + (button_Navi_QuestInfoWindow:GetSizeX() / 2 + 30))
    end
  else
    button_Giveup_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 - (button_Giveup_QuestInfoWindow:GetSizeX() * 1.5 + 10))
    if 0 == uiCondition and 0 == questInfo:getQuestType() then
      button_CallSpirit_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 + 5)
    else
      button_Navi_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 - button_Navi_QuestInfoWindow:GetSizeX() / 2)
      button_AutoNavi_QuestInfoWindow:SetPosX(Panel_CheckedQuestInfo:GetSizeX() / 2 + button_AutoNavi_QuestInfoWindow:GetSizeX() / 2 + 10)
    end
  end
  local rewardPosY = _QuestDetail_ShowReward(questInfo, PosY, isCleared)
  Panel_CheckedQuestInfo:SetSize(Panel_CheckedQuestInfo:GetSizeX(), rewardPosY + 50)
  local subBgSizeY = Panel_CheckedQuestInfo:GetSizeY() - 94
  if true == isCleared then
    subBgSizeY = subBgSizeY + 43
  end
  subBg:SetSize(subBg:GetSizeX(), subBgSizeY)
  subBg:ComputePos()
  button_Giveup_QuestInfoWindow:ComputePos()
  button_CallSpirit_QuestInfoWindow:ComputePos()
  button_Navi_QuestInfoWindow:ComputePos()
  button_AutoNavi_QuestInfoWindow:ComputePos()
  if nil == checkedQuestInfo_PosX then
    checkedQuestInfo_PosX = Panel_CheckedQuest:GetPosX() - Panel_CheckedQuestInfo:GetSizeX() - 10
    checkedQuestInfo_PosY = getMousePosY() - Panel_CheckedQuestInfo:GetSizeY()
  end
  FGlobal_SetUrl_Tooltip_SkillForLearning()
  Panel_CheckedQuestInfo:SetShow(true, true)
  if Panel_Window_Quest_New:IsUISubApp() then
    Panel_CheckedQuestInfo:OpenUISubApp()
  end
  local btnGiveupSizeX = button_Giveup_QuestInfoWindow:GetSizeX()
  local btnGiveupTextPosX = btnGiveupSizeX - btnGiveupSizeX / 2 - button_Giveup_QuestInfoWindow:GetTextSizeX() / 2
  button_Giveup_QuestInfoWindow:SetTextSpan(btnGiveupTextPosX, 5)
  local btnNaviSizeX = button_Navi_QuestInfoWindow:GetSizeX()
  local btnNaviTextPosX = btnNaviSizeX - btnNaviSizeX / 2 - button_Navi_QuestInfoWindow:GetTextSizeX() / 2
  button_Navi_QuestInfoWindow:SetTextSpan(btnNaviTextPosX, 5)
  local btnAutoNaviSizeX = button_AutoNavi_QuestInfoWindow:GetSizeX()
  local btnAutoNaviTextPosX = btnAutoNaviSizeX - btnAutoNaviSizeX / 2 - button_AutoNavi_QuestInfoWindow:GetTextSizeX() / 2
  button_AutoNavi_QuestInfoWindow:SetTextSpan(btnAutoNaviTextPosX, 5)
  local btnCallSpiritSizeX = button_CallSpirit_QuestInfoWindow:GetSizeX()
  local btnCallSpiritTextPosX = btnCallSpiritSizeX - btnCallSpiritSizeX / 2 - button_CallSpirit_QuestInfoWindow:GetTextSizeX() / 2
  button_CallSpirit_QuestInfoWindow:SetTextSpan(btnCallSpiritTextPosX, 5)
  button_Giveup_QuestInfoWindow:ComputePos()
  button_CallSpirit_QuestInfoWindow:ComputePos()
  button_Navi_QuestInfoWindow:ComputePos()
  button_AutoNavi_QuestInfoWindow:ComputePos()
  if true == isCleared then
    button_CallSpirit_QuestInfoWindow:SetShow(false)
    button_Giveup_QuestInfoWindow:SetShow(false)
    button_Navi_QuestInfoWindow:SetShow(false)
    button_AutoNavi_QuestInfoWindow:SetShow(false)
    questInfoWindow_giveupButton:SetShow(false)
    questInfoWindow_naviButton:SetShow(false)
    baseRewardTitle:SetShow(false)
    selectRewardTitle:SetShow(false)
    reward_Title:SetShow(false)
    for i = 0, 11 do
      local _baseSlotBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Reward_Slot_" .. i)
      local _baseSlot = UI.getChildControl(Panel_CheckedQuestInfo, "Static_Slot_" .. i)
      if i <= 5 then
        local _selectSlotBG = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlotBG_" .. i)
        local _selectSlot = UI.getChildControl(Panel_CheckedQuestInfo, "Static_SelectSlot_" .. i)
        _selectSlotBG:SetShow(false)
        _selectSlot:SetShow(false)
      end
      _baseSlotBG:SetShow(false)
      _baseSlot:SetShow(false)
    end
  end
end
function HandleClicked_CallSpirit()
  if not IsSelfPlayerWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_SUMMON_BLACKSPIRIT"))
    return
  end
  ToClient_AddBlackSpiritFlush()
  return
end
function FGlobal_QuestInfoDetail_Close()
  if Panel_CheckedQuestInfo:IsUISubApp() then
    Panel_CheckedQuestInfo:CloseUISubApp()
  end
  Panel_Tooltip_Item_hideTooltip()
  Panel_CheckedQuestInfo:SetShow(false, false)
  checkedQuestInfo_PosX = Panel_CheckedQuestInfo:GetPosX()
  checkedQuestInfo_PosY = Panel_CheckedQuestInfo:GetPosY()
  expTooltip:SetShow(false)
  FGlobal_QuestInfoDetail_ResetInfo()
  FGlobal_ResetUrl_Tooltip_SkillForLearning()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
function FGlobal_QuestInfoDetail_ResetInfo()
  _questInfoDetailGroupId = 0
  _questInfoDetailQuestId = 0
end
function _QuestDetail_ShowReward(questInfo, PosY, isCleared)
  if true == isCleared then
    return PosY - 17
  end
  local baseCount = questInfo:getQuestBaseRewardCount()
  local selectCount = questInfo:getQuestSelectRewardCount()
  _baseReward = {}
  for baseReward_index = 1, baseCount do
    local baseReward = questInfo:getQuestBaseRewardAt(baseReward_index - 1)
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
  _selectReward = {}
  for selectReward_index = 1, selectCount do
    local selectReward = questInfo:getQuestSelectRewardAt(selectReward_index - 1)
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
  reward_TitleBG:SetPosY(PosY + 10)
  reward_Title:SetPosY(PosY + 10)
  PosY = PosY + reward_Title:GetSizeY() + 20
  baseRewardBG:SetPosY(PosY)
  lineHeight:SetPosY(PosY)
  baseRewardTitle:SetPosY(PosY + 10)
  baseSlotBG0:SetPosY(PosY + 7)
  baseSlotBG1:SetPosY(PosY + 7)
  baseSlotBG2:SetPosY(PosY + 7)
  baseSlotBG3:SetPosY(PosY + 7)
  baseSlotBG4:SetPosY(PosY + 7)
  baseSlotBG5:SetPosY(PosY + 7)
  baseSlotBG6:SetPosY(PosY + 50)
  baseSlotBG7:SetPosY(PosY + 50)
  baseSlotBG8:SetPosY(PosY + 50)
  baseSlotBG9:SetPosY(PosY + 50)
  baseSlotBG10:SetPosY(PosY + 50)
  baseSlotBG11:SetPosY(PosY + 50)
  baseSlot0:SetPosY(PosY + 7)
  baseSlot1:SetPosY(PosY + 7)
  baseSlot2:SetPosY(PosY + 7)
  baseSlot3:SetPosY(PosY + 7)
  baseSlot4:SetPosY(PosY + 7)
  baseSlot5:SetPosY(PosY + 7)
  baseSlot6:SetPosY(PosY + 50)
  baseSlot7:SetPosY(PosY + 50)
  baseSlot8:SetPosY(PosY + 50)
  baseSlot9:SetPosY(PosY + 50)
  baseSlot10:SetPosY(PosY + 50)
  baseSlot11:SetPosY(PosY + 50)
  PosY = PosY + baseRewardBG:GetSizeY()
  lineWidth:SetPosY(PosY + 5)
  PosY = PosY + lineWidth:GetSizeY() + 10
  selectRewardTitle:SetPosY(PosY)
  selectRewardBG:SetPosY(PosY)
  selectSlotBG0:SetPosY(PosY + 4)
  selectSlotBG1:SetPosY(PosY + 4)
  selectSlotBG2:SetPosY(PosY + 4)
  selectSlotBG3:SetPosY(PosY + 4)
  selectSlotBG4:SetPosY(PosY + 4)
  selectSlotBG5:SetPosY(PosY + 4)
  selectSlot0:SetPosY(PosY + 4)
  selectSlot1:SetPosY(PosY + 4)
  selectSlot2:SetPosY(PosY + 4)
  selectSlot3:SetPosY(PosY + 4)
  selectSlot4:SetPosY(PosY + 4)
  selectSlot5:SetPosY(PosY + 4)
  PosY = PosY + selectRewardBG:GetSizeY() + 5
  _questWidget_SetRewardList(_baseReward, _selectReward)
  return PosY
end
function rewardTooltip_ForQuestWidgetInfo(type, show, questtype, index, key, value)
  if true == show then
    if "Exp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP"))
    elseif "SkillExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP"))
    elseif "ExpGrade" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP_GRADE"))
    elseif "SkillExpGrade" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP_GRADE"))
    elseif "ProductExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP"))
    elseif "Intimacy" == type then
      local wrapper = ToClient_GetCharacterStaticStatusWrapper(key)
      local npcName = wrapper:getName()
      expTooltip:SetText(npcName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY") .. " " .. value)
    elseif "Knowledge" == type then
      local mentalCardSSW = ToClinet_getMentalCardStaticStatus(key)
      local mentalCardName = mentalCardSSW:getName()
      local mentalCardDesc = mentalCardSSW:getDesc()
      expTooltip:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_REWARD_TOOLTIP_KNOWLEDGE", "mentalCardName", mentalCardName, "mentalCardName2", mentalCardName))
    elseif "CharacterStat" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_CHARACTERSTAT"))
    elseif "FamilyStat" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_FAMILYSTAT"))
    elseif "FamilyStatPoint" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_REWARD_1"))
    end
    if "main" == questtype then
      expTooltip:SetPosX(_uiBackBaseReward[index]:GetPosX() - expTooltip:GetSizeX() / 2)
      expTooltip:SetPosY(_uiBackBaseReward[index]:GetPosY() - expTooltip:GetSizeY() - 10)
    else
      expTooltip:SetPosX(_uiButtonSelectRewardSlots[index]:GetPosX() - expTooltip:GetSizeX() / 2)
      expTooltip:SetPosY(_uiButtonSelectRewardSlots[index]:GetPosY() - expTooltip:GetSizeY())
    end
    expTooltip:SetShow(true)
  else
    expTooltip:SetShow(false)
  end
end
local setReward = function(uiSlot, reward, index, questType)
  uiSlot._type = reward._type
  uiSlot.border:SetShow(false)
  uiSlot.enchantText:SetShow(false)
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"ExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"ExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"SkillExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"SkillExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot._item = reward._item
    if "main" == questType then
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Base\",false)")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Select\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"QuestReward_Select\",false)")
    end
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
  elseif __eRewardKnowledge == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"Knowledge\", true, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"Knowledge\", false, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
  elseif __eRewardCharacterStat == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/03_Quest_Item/familystat_001.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"CharacterStat\", true, \"" .. questType .. "\", " .. index .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"CharacterStat\", false, \"" .. questType .. "\", " .. index .. ")")
  elseif __eRewardFamilyStat == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/03_Quest_Item/familystat_001.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"FamilyStat\", true, \"" .. questType .. "\", " .. index .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"FamilyStat\", false, \"" .. questType .. "\", " .. index .. ")")
  elseif __eRewardFamilyStatPoint == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/03_Quest_Item/familystat_001.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip_ForQuestWidgetInfo( \"FamilyStatPoint\", true, \"" .. questType .. "\", " .. index .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip_ForQuestWidgetInfo( \"FamilyStatPoint\", false, \"" .. questType .. "\", " .. index .. ")")
  else
    uiSlot.icon:ChangeTextureInfoName("")
    uiSlot.count:SetText("")
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  return false
end
function _questWidget_SetRewardList(baseReward, selectReward)
  _baseRewardCount = #baseReward
  _selectRewardCount = #selectReward
  for index = 0, _maxBaseSlotCount - 1 do
    if index < _baseRewardCount then
      setReward(_listBaseRewardSlots[index], baseReward[index + 1], index, "main")
      _uiBackBaseReward[index]:SetShow(true)
    else
      _uiBackBaseReward[index]:SetShow(false)
    end
  end
  for index = 0, _maxSelectSlotCount - 1 do
    if index < _selectRewardCount then
      local isEquipable = setReward(_listSelectRewardSlots[index], selectReward[index + 1], index, "sub")
      if isEquipable then
        _equipRewardCount = _equipRewardCount + 1
        _equipEnableSlot = index
      end
      _uiButtonSelectRewardSlots[index]:SetShow(true)
    else
      _uiButtonSelectRewardSlots[index]:SetShow(false)
    end
  end
end
local checkedQuestInfo_PosX, checkedQuestInfo_PosY
