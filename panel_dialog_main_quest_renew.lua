local Panel_Dialog_Main_Quest_Info = {
  _initialize = false,
  _ui = {
    static_QuestBg = UI.getChildControl(Panel_Dialog_Main, "Static_QuestBg"),
    staticText_QuestTitle = nil,
    list2_Quest_List = nil,
    static_Divider1 = nil,
    frame_Dialog_Quest = nil,
    frame_1_Content = nil,
    staticText_Quest_Npc_Words = nil,
    static_Divider2 = nil,
    staticText_Quest_Detail = nil,
    staticText_Quest_Condition = nil,
    staticText_Quest_Reward_Basic = nil,
    static_Divider3 = nil,
    static_Quest_Reward_Basic = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    baseRewardSlot = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    static_Quest_Reward_Select = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    selectRewardSlot = {
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil,
      nil
    },
    staticText_Quest_Reward_Select = nil,
    static_Divider4 = nil,
    expToolTip = nil,
    frame_1_VerticalScroll = nil,
    btn_Confirm = nil,
    btn_Cancel = nil,
    btn_Quest_Y = nil
  },
  _config = {
    maxQuestRewardCount = 8,
    questRewardSlotConfig = {
      _createIcon = true,
      _createBorder = true,
      _createCount = true,
      _createClassEquipBG = true,
      _createCash = true
    }
  },
  _enum = {eDefaulIndex = -1},
  _value = {
    isFirstOpen = false,
    currentQuestIndex = 0,
    leastSelectReward = nil,
    selectReawardCount = 0
  },
  _text = {
    requestText = PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST"),
    progressingText = PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_PROGRESS")
  },
  _pos = {
    rewardTextPos = {X = nil, Y = nil}
  },
  _space = {QuestframeSpcae = 8},
  _questId = {},
  _rewardIconPath = {
    [__eRewardExp] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds",
    [__eRewardSkillExp] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds",
    [__eRewardLifeExp] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds",
    [__eRewardIntimacy] = "Icon/New_Icon/00000000_Special_Contributiveness.dds",
    [__eRewardKnowledge] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds",
    [__eRewardExpGrade] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds",
    [__eRewardSkillExpGrade] = "Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds"
  }
}
function Panel_Dialog_Main_Quest_Info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_onScreenResize_MainDialog_Quest")
end
function Panel_Dialog_Main_Quest_Info:initialize()
  self:close()
  self:initValue()
  self:initControl()
  self:registerMessageHandler()
end
function Panel_Dialog_Main_Quest_Info:initControl()
  self._ui.staticText_QuestTitle = UI.getChildControl(self._ui.static_QuestBg, "StaticText_QuestTitle")
  self._ui.list2_Quest_List = UI.getChildControl(self._ui.static_QuestBg, "List2_Quest_List")
  self._ui.list2_Quest_List:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_MainDialog_Quest_List2EventControlCreate")
  self._ui.list2_Quest_List:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.static_Divider1 = UI.getChildControl(self._ui.static_QuestBg, "Static_Divider1")
  self._ui.frame_Dialog_Quest = UI.getChildControl(self._ui.static_QuestBg, "Frame_Dialog_Quest")
  self._ui.frame_1_Content = UI.getChildControl(self._ui.frame_Dialog_Quest, "Frame_1_Content")
  self._ui.staticText_Quest_Npc_Words = UI.getChildControl(self._ui.frame_1_Content, "StaticText_Quest_Npc_Words")
  self._ui.static_Divider2 = UI.getChildControl(self._ui.frame_1_Content, "Static_Divider2")
  self._ui.staticText_Quest_Detail = UI.getChildControl(self._ui.frame_1_Content, "StaticText_Quest_Detail")
  self._ui.staticText_Quest_Condition = UI.getChildControl(self._ui.frame_1_Content, "StaticText_Quest_Condition")
  self._ui.staticText_Quest_Reward_Basic = UI.getChildControl(self._ui.frame_1_Content, "StaticText_Quest_Reward_Basic")
  self._ui.static_Divider3 = UI.getChildControl(self._ui.frame_1_Content, "Static_Divider3")
  for index = 0, self._config.maxQuestRewardCount - 1 do
    self._ui.static_Quest_Reward_Basic[index] = UI.getChildControl(self._ui.frame_1_Content, "Static_Quest_Reward_Basic" .. index + 1)
  end
  self._ui.staticText_Quest_Reward_Select = UI.getChildControl(self._ui.frame_1_Content, "StaticText_Quest_Reward_Select")
  self._ui.static_Divider4 = UI.getChildControl(self._ui.frame_1_Content, "Static_Divider4")
  for index = 0, self._config.maxQuestRewardCount - 1 do
    self._ui.static_Quest_Reward_Select[index] = UI.getChildControl(self._ui.frame_1_Content, "Static_Quest_Reward_Select" .. index + 1)
  end
  for index = 0, self._config.maxQuestRewardCount - 1 do
    local control = UI.getChildControl(self._ui.frame_1_Content, "Static_Quest_Reward_Basic" .. index + 1)
    local slot = {}
    SlotItem.new(slot, "Static_BaseReward_" .. index, index, control, self._config.questRewardSlotConfig)
    slot:createChild()
    self._ui.baseRewardSlot[index] = slot
  end
  for index = 0, self._config.maxQuestRewardCount - 1 do
    local control = UI.getChildControl(self._ui.frame_1_Content, "Static_Quest_Reward_Select" .. index + 1)
    local slot = {}
    SlotItem.new(slot, "Static_SelectReward_" .. index, index, control, self._config.questRewardSlotConfig)
    slot:createChild()
    self._ui.selectRewardSlot[index] = slot
  end
  self._ui.frame_1_VerticalScroll = UI.getChildControl(self._ui.frame_Dialog_Quest, "Frame_1_VerticalScroll")
  self._ui.btn_Confirm = UI.getChildControl(self._ui.static_QuestBg, "Button_Confirm")
  self._ui.btn_Cancel = UI.getChildControl(self._ui.static_QuestBg, "Button_Cancel")
  self._ui.btn_Quest_Y = UI.getChildControl(self._ui.static_QuestBg, "Button_Quest_Y")
  self:CreateRewardToolTipControl()
end
function Panel_Dialog_Main_Quest_Info:open()
  self._ui.static_QuestBg:SetShow(true)
end
function Panel_Dialog_Main_Quest_Info:close()
  if self._ui.static_QuestBg:GetShow() then
    _AudioPostEvent_SystemUiForXBOX(1, 20)
  end
  self._ui.static_QuestBg:SetShow(false)
end
function Panel_Dialog_Main_Quest_Info:update()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local isCompleteQuest = dialogData:getIscompleteQuest()
  if true == isCompleteQuest then
    self:openAndSetData(dialogData)
    PaGlobalFunc_MainDialog_Quest_IsFirstReset()
    return
  end
  local questCount = dialogData:getAcceptableQuestCount()
  if 0 == questCount then
    return
  end
  local openCheck = PaGlobalFunc_Dialog_Main_GetShowCheckOnce()
  if true == openCheck and false == PaGlobalFunc_MainDialog_Quest_GetFirstSet() then
    self:openAndSetData(dialogData)
  elseif true == PaGlobalFunc_MainDialog_Bottom_IsLeastFunButtonDefault() then
  else
    local leasFunButtomIndex = PaGlobalFunc_MainDialog_Bottom_GetLeastFunButtonIndex()
    local funcButton = dialogData:getFuncButtonAt(leasFunButtomIndex)
    if funcButton == nil then
      return
    end
    local funcButtonType = tonumber(funcButton._param)
    if funcButtonType == CppEnums.ContentsType.Contents_NewQuest or funcButtonType == CppEnums.ContentsType.Contents_Quest then
      self:openAndSetData(dialogData)
    end
  end
end
function Panel_Dialog_Main_Quest_Info:openAndSetData(dialogData)
  self:open()
  PaGlobalFunc_MainDialog_Quest_IsFirstSet()
  local questIndex = PaGlobalFunc_MainDialog_Bottom_FindQuestControlIndex()
  if -1 ~= questIndex then
    Toggle_DialogMainTab_SetIndexHiligt(questIndex)
    PaGlobalFunc_MainDialog_Bottom_SetLeastFunButtonIndex(questIndex)
  end
  local topTitle = self._text.requestText
  local questCount = dialogData:getHaveQuestCount()
  local accpetable = dialogData:getAcceptableQuestCount()
  topTitle = topTitle .. "(" .. accpetable .. "/" .. questCount .. ")"
  self._ui.staticText_QuestTitle:SetText(topTitle)
  self:updateQuestList(dialogData)
  self:update_Quest_Infomation()
end
function Panel_Dialog_Main_Quest_Info:initValue()
  self._initialize = true
  self._value.isFirstOpen = false
  self._value.leastSelectReward = nil
end
function Panel_Dialog_Main_Quest_Info:updateQuestList(dialogData)
  self._ui.list2_Quest_List:getElementManager():clearKey()
  for k in pairs(self._questId) do
    self._questId[k] = nil
  end
  local questCount = dialogData:getHaveQuestCount()
  if 0 == questCount then
    return
  end
  for index = 0, questCount - 1 do
    self._questId[index] = index
    self._ui.list2_Quest_List:getElementManager():pushKey(toInt64(0, self._questId[index]))
    self._ui.list2_Quest_List:requestUpdateByKey(toInt64(0, self._questId[index]))
  end
end
function Panel_Dialog_Main_Quest_Info:update_Quest_Infomation()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local questInfo = questList_getQuestInfo(dialogData:getQuestRaw())
  if nil == questInfo then
    return
  end
  self:Quest_InfomationSetData(dialogData)
  self:QuestInfomationSetPosAll()
end
function Panel_Dialog_Main_Quest_Info:Quest_InfomationSetData(dialogData)
  local selectedIndex = dialogData:getSelectedQuestIndex()
  local simplequestData = dialogData:getHaveQuestAt(selectedIndex)
  if nil == simplequestData then
    return
  end
  local npcWord = simplequestData:getQuestDialog()
  local ignoreWord = PaGlobalFunc_MainDialog_Right_CheckSceneChange(npcWord)
  local realWord = ToClient_getReplaceDialog(ignoreWord)
  if realWord ~= nil and realWord ~= "" then
    local newNpcWord = ""
    newNpcWord = string.gsub(realWord, "?\n", "?\t")
    newNpcWord = string.gsub(newNpcWord, "!\n", "!\t")
    newNpcWord = string.gsub(newNpcWord, "%.\n", "%.\t")
    newNpcWord = string.gsub(newNpcWord, "\n", " ")
    newNpcWord = string.gsub(newNpcWord, "?\t", "?\n")
    newNpcWord = string.gsub(newNpcWord, "!\t", "!\n")
    newNpcWord = string.gsub(newNpcWord, "%.\t", "%.\n")
    local questString = ""
    local stringList = string.split(newNpcWord, "\n")
    for idx = 1, #stringList do
      if idx % 2 == 1 and idx > 1 then
        questString = questString .. "\n" .. "\n"
      end
      questString = questString .. " " .. stringList[idx]
    end
    questString = string.gsub(questString, "\226\128\187", "\n\226\128\187")
    self._ui.staticText_Quest_Npc_Words:SetAutoResize(true)
    self._ui.staticText_Quest_Npc_Words:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Quest_Npc_Words:SetText(questString)
  end
  local preDesc = simplequestData:getQuestDesc()
  local questDesc = ToClient_getReplaceDialog(preDesc)
  if questDesc ~= nil and questDesc ~= "" then
    self._ui.staticText_Quest_Detail:SetAutoResize(true)
    self._ui.staticText_Quest_Detail:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._ui.staticText_Quest_Detail:SetText(questDesc)
  end
  local completeDesc = PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", simplequestData:getCompleteDisplay())
  local demandCount = simplequestData:getDemandCount()
  for demandIndex = 0, demandCount - 1 do
    local desc = simplequestData:getDemandAtDesc(demandIndex)
    if nil ~= desc then
      completeDesc = completeDesc .. [[

 -]] .. desc
    end
  end
  local newCompleteDesc = ToClient_getReplaceDialog(completeDesc)
  self._ui.staticText_Quest_Condition:SetAutoResize(true)
  self._ui.staticText_Quest_Condition:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Quest_Condition:SetText(newCompleteDesc)
  self:SetQuestReward(simplequestData)
  if _ContentsGroup_RenewUI_Dailog then
    self:QuestButtonUpdateXBox(dialogData)
  else
    self:QuestButtonUpdate(dialogData)
  end
end
function Panel_Dialog_Main_Quest_Info:QuestInfomationSetPosAll()
  local StartPosY = self._ui.staticText_Quest_Npc_Words:GetPosY()
  local currentPosY = self._ui.staticText_Quest_Npc_Words:GetPosY()
  local PanY = self._space.QuestframeSpcae
  currentPosY = currentPosY + self._ui.staticText_Quest_Npc_Words:GetSizeY() + PanY
  self._ui.static_Divider2:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.static_Divider2:GetSizeY() + PanY
  self._ui.staticText_Quest_Detail:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.staticText_Quest_Detail:GetSizeY() + PanY
  self._ui.staticText_Quest_Condition:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.staticText_Quest_Condition:GetSizeY() + PanY
  self._ui.staticText_Quest_Reward_Basic:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.staticText_Quest_Reward_Basic:GetSizeY() + PanY
  self._ui.static_Divider3:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.static_Divider3:GetSizeY() + PanY
  for key, value in pairs(self._ui.static_Quest_Reward_Basic) do
    value:SetPosY(currentPosY)
  end
  currentPosY = currentPosY + self._ui.static_Quest_Reward_Basic[1]:GetSizeY() + PanY
  self._ui.staticText_Quest_Reward_Select:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.staticText_Quest_Reward_Select:GetSizeY() + PanY
  self._ui.static_Divider4:SetPosY(currentPosY)
  currentPosY = currentPosY + self._ui.static_Divider4:GetSizeY() + PanY
  for key, value in pairs(self._ui.static_Quest_Reward_Select) do
    value:SetPosY(currentPosY)
  end
  currentPosY = currentPosY + self._ui.static_Quest_Reward_Select[0]:GetSizeY() + PanY
  self._ui.frame_1_Content:SetSize(currentPosY)
  self._ui.frame_1_VerticalScroll:SetControlPos(0)
  self._ui.frame_Dialog_Quest:UpdateContentPos()
  self._ui.frame_Dialog_Quest:UpdateContentScroll()
end
function Panel_Dialog_Main_Quest_Info:QuestButtonUpdateXBox(dialogData)
  self._ui.btn_Confirm:SetShow(false)
  self._ui.btn_Cancel:SetShow(false)
  self._ui.btn_Quest_Y:SetShow(false)
  self._ui.btn_Quest_Y:ComputePos()
  local QuestButtonCount = dialogData:getQuestButtonCount()
  if QuestButtonCount == 1 then
    local QuestButton = dialogData:getQuestButtonAt(0)
    if CppEnums.DialogState.eDialogState_QuestComplete == tostring(QuestButton._linkType) or CppEnums.DialogState.eDialogState_AcceptQuest == tostring(QuestButton._linkType) then
      self._ui.btn_Quest_Y:SetShow(true)
      self._ui.btn_Quest_Y:SetText(QuestButton:getText())
      self._ui.btn_Quest_Y:addInputEvent("Mouse_LUp", "ToClient_ClickQuestButton(0)")
    end
  end
end
function Panel_Dialog_Main_Quest_Info:QuestButtonUpdate(dialogData)
  self._ui.btn_Quest_Y:SetShow(false)
  local questButton = {}
  questButton[0] = self._ui.btn_Confirm
  questButton[1] = self._ui.btn_Cancel
  for key, value in pairs(questButton) do
    value:SetShow(false)
    value:ComputePos()
  end
  local QuestButtonCount = dialogData:getQuestButtonCount()
  for index = 0, QuestButtonCount - 1 do
    local QuestButton = dialogData:getQuestButtonAt(index)
    if nil ~= QuestButton then
      questButton[index]:SetText(QuestButton:getText())
      questButton[index]:SetShow(true)
      questButton[index]:addInputEvent("Mouse_LUp", "ToClient_ClickQuestButton(" .. index .. ")")
      if _ContentsGroup_isConsolePadControl then
        questButton[index]:addInputEvent("Mouse_On", "ToClient_ClickQuestButton(" .. index .. ")")
      end
    end
  end
end
function Panel_Dialog_Main_Quest_Info:SetQuestReward(simplequestData)
  self:ClearQuestReward()
  local questInfo = simplequestData:getQuestStaticStatusWrapper()
  if nil == questInfo then
    return
  end
  local baseRewardCount = questInfo:getQuestBaseRewardCount()
  local selectRewardCount = questInfo:getQuestSelectRewardCount()
  self._value.selectReawardCount = selectRewardCount
  for baseIndex = 0, baseRewardCount - 1 do
    local baseReward = questInfo:getQuestBaseRewardAt(baseIndex)
    if nil == baseReward then
      break
    end
    self:SetRewardIcon(self._ui.baseRewardSlot[baseIndex], baseReward, baseIndex, "base")
  end
  for selectIndex = 0, selectRewardCount - 1 do
    local selectReward = questInfo:getQuestSelectRewardAt(selectIndex)
    if nil == selectReward then
      break
    end
    self:SetRewardIcon(self._ui.selectRewardSlot[selectIndex], selectReward, selectIndex, "select")
  end
  for key, value in pairs(self._ui.static_Quest_Reward_Select) do
    value:EraseAllEffect()
  end
end
function Panel_Dialog_Main_Quest_Info:SetRewardIcon(slot, reward, index, rewardStr)
  local rewardType = reward:getType()
  if nil == rewardType then
    return
  end
  slot._type = rewardType
  if __eRewardExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Exp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Exp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"SkillExp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"SkillExp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"ExpGrade\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"ExpGrade\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"SkillExpGrade\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"SkillExpGrade\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardLifeExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"ProductExp\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"ProductExp\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  elseif __eRewardItem == rewardType then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward:getItemEnchantKey()))
    if nil == itemStatic then
      return
    end
    slot.icon:SetShow(true)
    if 0 ~= reward:getItemCount() and nil == slot.count then
      slot.count = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, slot.icon, "StaticText_" .. slot.id .. "_Count")
    end
    slot:setItemByStaticStatus(itemStatic, reward:getItemCount())
    slot._item = reward:getItemEnchantKey()
    if "base" == rewardStr then
      slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",true)")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",false)")
      Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_QuestReward_Base")
    end
    if "select" == rewardStr then
      slot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Select\",true)")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Select\",false)")
      Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_QuestReward_Select")
    end
    slot.count:SetSize(42, 21)
    slot.count:SetPosY(slot.count:GetPosY() + slot.count:GetSizeY())
    slot.count:SetTextHorizonRight()
    slot.count:SetVerticalBottom()
  elseif __eRewardIntimacy == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Intimacy\", true,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Intimacy\", false,\"" .. rewardStr .. "\"," .. index .. " )")
    slot.icon:SetShow(true)
  else
    if __eRewardKnowledge == rewardType then
      slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
      slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Knowledge\", true,\"" .. rewardStr .. "\"," .. index .. "," .. reward:getMentalCardKey() .. " )")
      slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_MainDialog_Quest_RewardToolTip( \"Knowledge\", false,\"" .. rewardStr .. "\"," .. index .. "," .. reward:getMentalCardKey() .. " )")
      slot.icon:SetShow(true)
    else
    end
  end
end
function Panel_Dialog_Main_Quest_Info:CreateRewardToolTipControl()
  self._ui.expToolTip = UI.getChildControl(self._ui.frame_1_Content, "StaticText_ToolTipTemplete")
  self._ui.expToolTip:SetColor(Defines.Color.C_FFFFFFFF)
  self._ui.expToolTip:SetAlpha(1)
  self._ui.expToolTip:SetFontColor(Defines.Color.C_FFFFFFFF)
  self._ui.expToolTip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.expToolTip:SetAutoResize(true)
  self._ui.expToolTip:SetTextHorizonCenter()
  self._ui.expToolTip:SetShow(false)
  self._ui.expToolTip:SetIgnore(true)
end
function Panel_Dialog_Main_Quest_Info:ClearQuestReward()
  for index = 0, self._config.maxQuestRewardCount - 1 do
    self._ui.baseRewardSlot[index].icon:SetShow(false)
    self._ui.selectRewardSlot[index].icon:SetShow(false)
    if nil ~= self._ui.baseRewardSlot[index].count then
      self._ui.baseRewardSlot[index].count:SetShow(false)
      self._ui.baseRewardSlot[index]._item = 0
    end
    if nil ~= self._ui.selectRewardSlot[index].count then
      self._ui.selectRewardSlot[index].count:SetShow(false)
      self._ui.selectRewardSlot[index]._item = 0
    end
  end
end
function Panel_Dialog_Main_Quest_Info:Resize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  local titleSpanY = math.abs(self._ui.staticText_QuestTitle:GetSpanSize().y)
  local spanY = self._ui.static_QuestBg:GetSpanSize().y
  local diffY = sizeY - (titleSpanY + spanY + self._ui.static_QuestBg:GetSizeY())
  if diffY < 0 then
    self._ui.static_QuestBg:SetSize(self._ui.static_QuestBg:GetSizeX(), self._ui.static_QuestBg:GetSizeY() + diffY)
    self._ui.frame_Dialog_Quest:SetSize(self._ui.frame_Dialog_Quest:GetSizeX(), self._ui.frame_Dialog_Quest:GetSizeY() + diffY)
  else
    local newSizeY = sizeY - titleSpanY - spanY
    local newDiff = newSizeY - self._ui.static_QuestBg:GetSizeY()
    self._ui.static_QuestBg:SetSize(self._ui.static_QuestBg:GetSizeX(), self._ui.static_QuestBg:GetSizeY() + newDiff)
    self._ui.frame_Dialog_Quest:SetSize(self._ui.frame_Dialog_Quest:GetSizeX(), self._ui.frame_Dialog_Quest:GetSizeY() + newDiff)
  end
  self._ui.static_QuestBg:ComputePos()
end
function PaGlobalFunc_MainDialog_Quest_IsFirstReset()
  local self = Panel_Dialog_Main_Quest_Info
  self._value.isFirstOpen = false
end
function PaGlobalFunc_MainDialog_Quest_IsFirstSet()
  local self = Panel_Dialog_Main_Quest_Info
  self._value.isFirstOpen = true
end
function PaGlobalFunc_MainDialog_Quest_GetFirstSet()
  local self = Panel_Dialog_Main_Quest_Info
  return self._value.isFirstOpen
end
function PaGlobalFunc_MainDialog_Quest_Open()
  local self = Panel_Dialog_Main_Quest_Info
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local isCompleteQuest = dialogData:getIscompleteQuest()
  if true == isCompleteQuest then
    self:openAndSetData(dialogData)
    return
  end
  local questCount = dialogData:getAcceptableQuestCount()
  questCount = questCount + dialogData:getIsProgressingQuestCount()
  if 0 == questCount then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(4, 4)
  self:openAndSetData(dialogData)
end
function PaGlobalFunc_MainDialog_Quest_Close()
  local self = Panel_Dialog_Main_Quest_Info
  self:close()
end
function PaGlobalFunc_MainDialog_Quest_Update()
  local self = Panel_Dialog_Main_Quest_Info
  self:update()
end
function PaGlobalFunc_MainDialog_Quest_GetShow()
  local self = Panel_Dialog_Main_Quest_Info
  return self._ui.static_QuestBg:GetShow()
end
function PaGlobalFunc_MainDialog_Quest_List2EventControlCreate(list_content, key)
  local id = Int64toInt32(key)
  local dialogData = ToClient_GetCurrentDialogData()
  local simplequestData = dialogData:getHaveQuestAt(id)
  local questInfo = simplequestData:getQuestStaticStatusWrapper()
  local questTitle = questInfo:getTitle()
  local questTypeIcon = questInfo:getQuestType()
  local radioButton_Quest = UI.getChildControl(list_content, "RadioButton_Quest")
  local questName = UI.getChildControl(list_content, "StaticText_Quest_Name")
  local questTypeIcon = UI.getChildControl(list_content, "Static_QuestTypeIcon")
  local realTiTile
  if simplequestData._isProgressing then
    realTiTile = questTitle .. PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_QUEST_PROGRESS")
  elseif simplequestData._isComplete then
    realTiTile = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_QUEST_WINDOW_COMPLETEQUEST", "questTitle", questTitle)
  else
    realTiTile = questTitle
  end
  local selecIndex = dialogData:getSelectedQuestIndex()
  radioButton_Quest:SetCheck(id == selecIndex)
  local questType = questInfo:getQuestType()
  FGlobal_ChangeOnTextureForConsoleDialogQuestIcon(questTypeIcon, questType)
  radioButton_Quest:addInputEvent("Mouse_On", "PaGlobal_MainDialog_Quest_ClickQuestList(" .. id .. ")")
  radioButton_Quest:addInputEvent("Mouse_LUp", "PaGlobal_MainDialog_Quest_ClickConfirmQuestList()")
  questName:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  questName:SetText(realTiTile)
end
function PaGlobal_MainDialog_Quest_ClickQuestList(index)
  local self = Panel_Dialog_Main_Quest_Info
  local dialogData = ToClient_GetCurrentDialogData()
  local selecIndex = dialogData:getSelectedQuestIndex()
  local lastIndex = selecIndex
  ToClient_ClickQuestList(index)
  self._ui.list2_Quest_List:requestUpdateByKey(toInt64(0, index))
  self._ui.list2_Quest_List:requestUpdateByKey(toInt64(0, lastIndex))
  self:update_Quest_Infomation()
  self._value.leastSelectReward = nil
end
function PaGlobal_MainDialog_Quest_ClickConfirmQuestList()
  local self = Panel_Dialog_Main_Quest_Info
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local questButtonCount = dialogData:getQuestButtonCount()
  if 0 == questButtonCount then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local QuestButtonCount = dialogData:getQuestButtonCount()
  if QuestButtonCount == 1 then
    local QuestButton = dialogData:getQuestButtonAt(0)
    if CppEnums.DialogState.eDialogState_QuestComplete == tostring(QuestButton._linkType) then
      if self._value.selectReawardCount ~= 0 then
        PaGlobalFunc_Reward_Select_Show()
      else
        ToClient_ClickQuestButton(0)
      end
    else
      ToClient_ClickQuestButton(0)
    end
  end
end
function PaGlobalFunc_MainDialog_Quest_RewardToolTip(rewardType, show, rewardStr, index, mentalCardKey)
  local self = Panel_Dialog_Main_Quest_Info
  if nil == self._ui.expToolTip then
    return
  end
  if true == show then
    if __eRewardExp == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP"))
    elseif __eRewardSkillExp == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP"))
    elseif __eRewardLifeExp == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP"))
    elseif __eRewardIntimacy == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY"))
    elseif __eRewardExpGrade == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP_GRADE"))
    elseif __eRewardSkillExpGrade == rewardType then
      self._ui.expToolTip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP_GRADE"))
    elseif __eRewardKnowledge == rewardType then
      local mentalCardSSW = ToClinet_getMentalCardStaticStatus(mentalCardKey)
      if nil == mentalCardSSW then
        return
      end
      local mentalCardName = mentalCardSSW:getName()
      local mentalCardDesc = mentalCardSSW:getDesc()
      self._ui.expToolTip:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_REWARD_TOOLTIP_KNOWLEDGE", "mentalCardName", mentalCardName, "mentalCardName2", mentalCardName))
    end
    if "base" == rewardStr then
      self._ui.expToolTip:SetPosX(self._ui.static_Quest_Reward_Basic[index]:GetPosX())
      self._ui.expToolTip:SetPosY(self._ui.static_Quest_Reward_Basic[index]:GetPosY() - self._ui.expToolTip:GetSizeY() * 2)
    else
      if "select" == rewardStr then
        self._ui.expToolTip:SetPosX(self._ui.static_Quest_Reward_Select[index].icon:GetPosX())
        self._ui.expToolTip:SetPosY(self._ui.static_Quest_Reward_Select[index].icon:GetPosY() - self._ui.expToolTip:GetSizeY() * 2)
      else
      end
    end
    self._ui.expToolTip:SetShow(true)
  else
    self._ui.expToolTip:SetShow(false)
  end
end
function PaGlobalFunc_MainDialog_Quest_HandleClickedSelectedReward(selectIndex)
  local self = Panel_Dialog_Main_Quest_Info
  local leastIndex = self._value.leastSelectReward
  if nil ~= leastIndex then
    self._ui.static_Quest_Reward_Select[leastIndex]:EraseAllEffect()
  end
  if nil ~= selectIndex then
    self._ui.static_Quest_Reward_Select[selectIndex]:AddEffect("UI_Quest_Compensate", true, 0, 0)
    self._ui.static_Quest_Reward_Select[selectIndex]:AddEffect("fUI_Light", false, 0, 0)
    self._value.leastSelectReward = selectIndex
    ReqeustDialog_selectReward(selectIndex)
  end
end
function PaGlobalFunc_MainDialog_Quest_InteractionCheck()
  local self = Panel_Dialog_Main_Quest_Info
  local isShow = self._ui.static_QuestBg:GetShow()
  if false == isShow then
    return
  end
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local questButtonCount = dialogData:getQuestButtonCount()
  if 0 == questButtonCount then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local QuestButtonCount = dialogData:getQuestButtonCount()
  if QuestButtonCount == 1 then
    local QuestButton = dialogData:getQuestButtonAt(0)
    if CppEnums.DialogState.eDialogState_QuestComplete == tostring(QuestButton._linkType) then
      if self._value.selectReawardCount ~= 0 then
        PaGlobalFunc_Reward_Select_Show()
      else
        ToClient_ClickQuestButton(0)
      end
    else
      ToClient_ClickQuestButton(0)
    end
  end
end
function FromClient_InitMainDialog_Quest()
  local self = Panel_Dialog_Main_Quest_Info
  self:initialize()
  self:Resize()
end
function FromClient_onScreenResize_MainDialog_Quest()
  local self = Panel_Dialog_Main_Quest_Info
  self:Resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InitMainDialog_Quest")
