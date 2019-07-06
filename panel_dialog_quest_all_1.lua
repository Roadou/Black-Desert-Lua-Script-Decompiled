function PaGlobal_DialogQuest_All:initialize()
  if true == PaGlobal_DialogQuest_All._initialize then
    return
  end
  self:controlInit_All()
  self:controlInit_Pc()
  self:controlInit_Console()
  self:controlSetShow()
  PaGlobal_DialogQuest_All:registEventHandler()
  PaGlobal_DialogQuest_All:validate()
  PaGlobal_DialogQuest_All._initialize = true
end
function PaGlobal_DialogQuest_All:controlInit_All()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  self._ui.stc_title = UI.getChildControl(Panel_Dialog_Quest_All, "StaticText_QuestTitle")
  self._ui.stc_questTitle = UI.getChildControl(Panel_Dialog_Quest_All, "Static_QuestName")
  self._ui.txt_questTitleName = UI.getChildControl(self._ui.stc_questTitle, "StaticText_Quest_Name")
  self._ui.frame_questMain = UI.getChildControl(Panel_Dialog_Quest_All, "Frame_Dialog_Quest")
  self._ui.frame_content = UI.getChildControl(self._ui.frame_questMain, "Frame_1_Content")
  self._ui.frame_txtNpcWord = UI.getChildControl(self._ui.frame_content, "StaticText_Quest_Npc_Words")
  self._ui.frame_VScroll = UI.getChildControl(self._ui.frame_questMain, "Frame_1_VerticalScroll")
  self._ui.frame_VScroll_Ctrl = UI.getChildControl(self._ui.frame_VScroll, "Frame_1_VerticalScroll_CtrlButton")
  self._ui.stc_DecoBg = UI.getChildControl(self._ui.frame_questMain, "Static_BlacSpiritDecoBg")
  self._ui.stc_rewardMain = UI.getChildControl(Panel_Dialog_Quest_All, "Static_RewardBG")
  self._ui.stc_basicRewardBg = UI.getChildControl(self._ui.stc_rewardMain, "Static_BasicRewardBG")
  self._ui.txt_basicReward = UI.getChildControl(self._ui.stc_basicRewardBg, "StaticText_Quest_Reward_Basic")
  self._ui.stc_selectRewardBg = UI.getChildControl(self._ui.stc_rewardMain, "Static_SelectRewardBG")
  self._ui.txt_selectReward = UI.getChildControl(self._ui.stc_selectRewardBg, "StaticText_Quest_Reward_Select")
  self._ui.stc_basicRewardList = {}
  self._ui.stc_selectRewardList = {}
  for index = 0, 7 do
    self._ui.stc_basicRewardList[index] = UI.getChildControl(self._ui.stc_basicRewardBg, "Static_Quest_Reward_Basic" .. tostring(index + 1))
    self._ui.stc_selectRewardList[index] = UI.getChildControl(self._ui.stc_selectRewardBg, "Static_Quest_Reward_Select" .. tostring(index + 1))
  end
  for index = 0, self._maxBaseSlotCount - 1 do
    local backBaseBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui.stc_basicRewardList[index], "BaseRewardBg_" .. index)
    backBaseBg:SetIgnore(true)
    self._uiBackBaseRewardBg[index] = backBaseBg
    local baseSlot = {}
    SlotItem.new(baseSlot, "BaseReward_" .. index, index, backBaseBg, self._itemSlotConfig)
    baseSlot:createChild()
    baseSlot.icon:SetPosX(1)
    baseSlot.icon:SetPosY(1)
    baseSlot.icon:SetIgnore(false)
    self._listBaseRewardSlots[index] = baseSlot
    Panel_Tooltip_Item_SetPosition(index, baseSlot, "Dialog_QuestReward_Base")
  end
  for index = 0, self._maxSelectSlotCount - 1 do
    local backSelectBg = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, self._ui.stc_selectRewardList[index], "SelectRewardCheck_" .. index)
    backSelectBg:SetSize(44)
    backSelectBg:SetSize(44)
    backSelectBg:SetHorizonCenter()
    backSelectBg:SetVerticalMiddle()
    self._uiBackSelectRewardCheck[index] = backSelectBg
    local selectSlot = {}
    SlotItem.new(selectSlot, "SelectReward_" .. index, index, backSelectBg, self._itemSlotConfig)
    selectSlot:createChild()
    selectSlot.icon:SetHorizonCenter()
    selectSlot.icon:SetVerticalMiddle()
    selectSlot.icon:SetIgnore(false)
    self._listSelectRewardSlots[index] = selectSlot
    Panel_Tooltip_Item_SetPosition(index, selectSlot, "Dialog_QuestReward_Select")
  end
  if nil ~= self._uiBackSelectRewardCheck[0] then
    self._selectCheckBaseTexture = self._ui.stc_selectRewardList[0]:getBaseTexture()
    self._selectCheckOnTexture = self._ui.stc_selectRewardList[0]:getOnTexture()
    self._selectCheckClickTexture = self._ui.stc_selectRewardList[0]:getClickTexture()
  end
  self._ui.txt_questTitleName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.frame_txtNpcWord:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_basicReward:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_selectReward:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_basicReward:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_REWARD"))
  self._ui.txt_selectReward:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_SREWARD"))
  self._frameContentSizeY = self._ui.frame_content:GetSizeY()
  self._panelSizeY = Panel_Dialog_Quest_All:GetSizeY()
end
function PaGlobal_DialogQuest_All:controlInit_Pc()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  self._ui_pc.btn_confirm = UI.getChildControl(self._ui.stc_rewardMain, "Button_Confirm_PCUI")
  self._ui_pc.btn_cancle = UI.getChildControl(self._ui.stc_rewardMain, "Button_Cancel_PCUI")
end
function PaGlobal_DialogQuest_All:controlInit_Console()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  self._ui_console.stc_guideIconA = UI.getChildControl(self._ui.stc_rewardMain, "Button_Quest_A")
  self._ui_console.stc_guideIconB = UI.getChildControl(self._ui.stc_rewardMain, "Button_Quest_B")
end
function PaGlobal_DialogQuest_All:controlSetShow()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  if false == ToClient_isConsole() then
    self._ui_console.stc_guideIconA:SetShow(false)
    self._ui_console.stc_guideIconB:SetShow(false)
  else
    self._ui_pc.btn_confirm:SetShow(false)
    self._ui_pc.btn_cancle:SetShow(false)
  end
end
function PaGlobal_DialogQuest_All:registEventHandler()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  self._ui_pc.btn_confirm:addInputEvent("Mouse_LUp", "HandleEventEnter_DialogQuest_All_SelectConfirmReward(0)")
  self._ui_pc.btn_cancle:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogQuest_All_QuestRefuse()")
end
function PaGlobal_DialogQuest_All:prepareOpen()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  PaGlobal_DialogQuest_All:resize()
  PaGlobal_DialogQuest_All:open()
end
function PaGlobal_DialogQuest_All:open()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  Panel_Dialog_Quest_All:SetShow(true)
end
function PaGlobal_DialogQuest_All:prepareClose()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  PaGlobal_DialogQuest_All:close()
end
function PaGlobal_DialogQuest_All:close()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  Panel_Dialog_Quest_All:SetShow(false)
end
function PaGlobal_DialogQuest_All:resize()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  Panel_Dialog_Quest_All:ComputePos()
end
function PaGlobal_DialogQuest_All:validate()
  if nil == Panel_Dialog_Quest_All then
    return
  end
  self._ui.stc_title:isValidate()
  self._ui.stc_questTitle:isValidate()
  self._ui.txt_questTitleName:isValidate()
  self._ui.frame_questMain:isValidate()
  self._ui.frame_content:isValidate()
  self._ui.frame_txtNpcWord:isValidate()
  self._ui.frame_VScroll:isValidate()
  self._ui.frame_VScroll_Ctrl:isValidate()
  self._ui.stc_DecoBg:isValidate()
  self._ui.stc_rewardMain:isValidate()
  self._ui.stc_basicRewardBg:isValidate()
  self._ui.txt_basicReward:isValidate()
  self._ui.stc_selectRewardBg:isValidate()
  self._ui.txt_selectReward:isValidate()
  self._ui_pc.btn_confirm:isValidate()
  self._ui_pc.btn_cancle:isValidate()
  self._ui_console.stc_guideIconA:isValidate()
  self._ui_console.stc_guideIconB:isValidate()
end
function PaGlobal_DialogQuest_All:questDataUpdate()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  self._selectIndex = nil
  self:descDataSet(dialogData)
  self:rewardDataSet(dialogData)
end
function PaGlobal_DialogQuest_All:descDataSet(dialogData)
  if nil == Panel_Dialog_Quest_All then
    return
  end
  local questData = questList_getQuestInfo(dialogData:getQuestRaw())
  local npcWord = dialogData:getMainDialog()
  local realDialog = ToClient_getReplaceDialog(npcWord)
  local dialogQuest = ""
  local questDesc = ""
  local questNpc = ""
  self._isComplete = false
  if nil ~= questData then
    questDesc = ToClient_getReplaceDialog(questData:getDesc())
    questNpc = PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", questData:getCompleteDisplay())
    dialogQuest = realDialog .. [[


]] .. questDesc .. [[


]] .. "<PAColor0xfff5ba3a>" .. questNpc .. "<PAOldColor>"
    self._ui.txt_questTitleName:SetText(questData:getTitle())
  else
    self._isComplete = true
    dialogQuest = realDialog
  end
  self._ui.frame_txtNpcWord:SetText(dialogQuest)
  if self._ui.frame_content:GetSizeY() < self._ui.frame_txtNpcWord:GetTextSizeY() then
    self._ui.frame_VScroll:SetShow(true)
    self._ui.frame_content:SetSize(self._ui.frame_content:GetSizeX(), self._ui.frame_txtNpcWord:GetTextSizeY() + 20)
  else
    self._ui.frame_VScroll:SetShow(false)
    self._ui.frame_content:SetSize(self._ui.frame_content:GetSizeX(), self._frameContentSizeY)
  end
  if true == self._isComplete then
    self._ui.stc_questTitle:SetShow(false)
    self._ui.frame_questMain:SetSpanSize(self._ui.frame_questMain:GetSpanSize().x, 0)
    Panel_Dialog_Quest_All:SetSize(Panel_Dialog_Quest_All:GetSizeX(), self._panelSizeY - 50)
    self._ui.stc_DecoBg:ComputePos()
    self._ui.stc_rewardMain:ComputePos()
  else
    self._ui.stc_questTitle:SetShow(true)
    self._ui.frame_questMain:SetSpanSize(self._ui.frame_questMain:GetSpanSize().x, 50)
    Panel_Dialog_Quest_All:SetSize(Panel_Dialog_Quest_All:GetSizeX(), self._panelSizeY)
    self._ui.stc_DecoBg:ComputePos()
    self._ui.stc_rewardMain:ComputePos()
  end
  self._ui.frame_questMain:GetVScroll():SetControlTop()
  self._ui.frame_questMain:UpdateContentScroll()
  self._ui.frame_questMain:UpdateContentPos()
end
function PaGlobal_DialogQuest_All:rewardDataSet(dialogData)
  local questData = questList_getQuestInfo(dialogData:getQuestRaw())
  local baseCount = dialogData:getBaseRewardCount()
  local _baseRewardList = {}
  for index = 1, baseCount do
    local baseReward = dialogData:getBaseRewardAt(index - 1)
    _baseRewardList[index] = {}
    _baseRewardList[index]._type = baseReward._type
    if __eRewardExp == baseReward._type then
      _baseRewardList[index]._exp = baseReward._experience
    elseif __eRewardSkillExp == baseReward._type then
      _baseRewardList[index]._exp = baseReward._skillExperience
    elseif __eRewardLifeExp == baseReward._type then
      _baseRewardList[index]._exp = baseReward._productExperience
    elseif __eRewardItem == baseReward._type then
      _baseRewardList[index]._item = baseReward:getItemEnchantKey()
      _baseRewardList[index]._count = baseReward._itemCount
    elseif __eRewardIntimacy == baseReward._type then
      _baseRewardList[index]._character = baseReward:getIntimacyCharacter()
      _baseRewardList[index]._value = baseReward._intimacyValue
    elseif __eRewardKnowledge == baseReward._type then
      _baseRewardList[index]._mentalCard = baseReward:getMentalCardKey()
    end
  end
  local selectCount = dialogData:getSelectRewardCount()
  local _selectRewardList = {}
  for index = 1, selectCount do
    local selectReward = dialogData:getSelectRewardAt(index - 1)
    _selectRewardList[index] = {}
    _selectRewardList[index]._type = selectReward._type
    if __eRewardExp == selectReward._type then
      _selectRewardList[index]._exp = selectReward._experience
    elseif __eRewardSkillExp == selectReward._type then
      _selectRewardList[index]._exp = selectReward._skillExperience
    elseif __eRewardLifeExp == selectReward._type then
      _selectRewardList[index]._exp = selectReward._productExperience
    elseif __eRewardItem == selectReward._type then
      _selectRewardList[index]._item = selectReward:getItemEnchantKey()
      _selectRewardList[index]._count = selectReward._itemCount
      local selfPlayer = getSelfPlayer()
      if nil ~= selfPlayer then
        local classType = selfPlayer:getClassType()
        _selectRewardList[index]._isEquipable = selectReward:isEquipable(classType)
      end
    elseif __eRewardIntimacy == selectReward._type then
      _selectRewardList[index]._character = selectReward:getIntimacyCharacter()
      _selectRewardList[index]._value = selectReward._intimacyValue
    elseif __eRewardKnowledge == selectReward._type then
      _selectRewardList[index]._mentalCard = selectReward:getMentalCardKey()
    end
  end
  self:setRewardList(_baseRewardList, _selectRewardList, questData)
end
function PaGlobal_DialogQuest_All:setRewardList(baseReward, selectReward, questData)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local userLevel = selfPlayer:get():getLevel()
  self._baseRewardCount = #baseReward
  self._selectRewardCount = #selectReward
  for index = 0, PaGlobal_DialogQuest_All._maxSelectSlotCount - 1 do
    PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[index]:SetCheck(false)
    PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[index]:EraseAllEffect()
    PaGlobal_DialogQuest_All._ui.stc_selectRewardList[index]:setRenderTexture(PaGlobal_DialogQuest_All._selectCheckBaseTexture)
  end
  for index = 0, self._maxBaseSlotCount - 1 do
    self._uiBackBaseRewardBg[index]:EraseAllEffect()
    if index < self._baseRewardCount then
      local isGrowReward = self:setRewardIcon(self._listBaseRewardSlots[index], baseReward[index + 1], index, "main")
      if true == isGrowReward then
        self._uiBackBaseRewardBg[index]:SetShow(false)
      else
        self._uiBackBaseRewardBg[index]:SetShow(true)
      end
    else
      self._uiBackBaseRewardBg[index]:SetShow(false)
    end
  end
  for index = 0, 7 do
    self._uiBackSelectRewardCheck[index]:SetCheck(false)
  end
  PaGlobalFunc_DialogQuest_All_ClearSelectRewardItemName()
  local _equipRewardCount = 0
  local _equipEnableSlot
  for index = 0, self._maxSelectSlotCount - 1 do
    self._uiBackSelectRewardCheck[index]:EraseAllEffect()
    if index < self._selectRewardCount then
      local isEquipable = self:setRewardIcon(self._listSelectRewardSlots[index], selectReward[index + 1], index, "sub")
      if true == isEquipable then
        _equipRewardCount = _equipRewardCount + 1
        _equipEnableSlot = index
      end
      self._uiBackSelectRewardCheck[index]:SetShow(true)
      self._uiBackSelectRewardCheck[index]:SetCheck(false)
      if true == self._isComplete then
        self._listSelectRewardSlots[index].icon:addInputEvent("Mouse_LUp", "HandleEventLUp_DialogQuest_All_SelectReward(" .. index .. ")")
        self._uiBackSelectRewardCheck[index]:AddEffect("UI_Quest_Compensate", true, 0, 0)
        self._uiBackSelectRewardCheck[index]:AddEffect("fUI_Light", false, 0, 0)
      else
        self._listSelectRewardSlots[index].icon:addInputEvent("Mouse_LUp", "")
        self._uiBackSelectRewardCheck[index]:EraseAllEffect()
      end
    else
      self._uiBackSelectRewardCheck[index]:SetShow(false)
    end
    if index < self._selectRewardCount then
      local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(selectReward[index + 1]._item))
      self._selectRewardItemNameList[index] = itemStatic:getName()
    end
  end
  if true == self._isComplete and userLevel < 50 and self._selectRewardCount > 0 then
    HandleEventLUp_DialogQuest_All_SelectReward(0)
  end
  if 1 == _equipRewardCount and nil ~= _equipEnableSlot then
    local classType = selfPlayer:getClassType()
    if 0 == classType or 24 == classType then
      classType = 4
    else
      classType = 0
    end
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(selectReward[_equipEnableSlot + 1]._item))
    if false == itemStatic:get()._usableClassType:isOn(classType) then
      HandleEventLUp_DialogQuest_All_SelectReward(_equipEnableSlot)
    end
  end
end
function PaGlobal_DialogQuest_All:setRewardIcon(uiSlot, reward, index, questType)
  uiSlot._type = reward._type
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"ExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"ExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"SkillExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"SkillExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot._item = reward._item
    if "main" == questType then
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",false)")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Select\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Select\",false)")
    end
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
  elseif __eRewardKnowledge == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Knowledge\", true, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOnOut_DialogQuest_All_RewardTooltip( \"Knowledge\", false, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  if __eRewardGrowStep == reward._type then
    return true
  end
  return false
end
