local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local _questrewardSlotConfig = {
  createIcon = true,
  createEnchant = true,
  createBorder = true,
  createCount = true,
  createClassEquipBG = true,
  createCash = true
}
local _baseRewardCount = 0
local _maxBaseSlotCount = 12
local _uiBackBaseReward = {}
local _listBaseRewardSlots = {}
local _selectRewardCount = 0
local _maxSelectSlotCount = 6
local _uiButtonSelectRewardSlots = {}
local _listSelectRewardSlots = {}
local _isSelectReward = false
local _selectRewardItemNameArry = {}
local _selectRewardItemName
local _equipRewardItemCount = 0
local questDescPosY = 0
local questDescSizeY = 0
local questDescgap = 0
local _uiCheckButton = UI.getChildControl(Panel_Npc_Quest_Reward, "CheckButton_0")
local _uiQuestTitle = UI.getChildControl(Panel_Npc_Quest_Reward, "StaticText_Quest_Title")
local _uiQuestNpc = UI.getChildControl(Panel_Npc_Quest_Reward, "StaticText_ClearNpc")
local _uiQuestDesc = UI.getChildControl(Panel_Npc_Quest_Reward, "StaticText_Quest_Desc")
local reward_CloseButton = UI.getChildControl(Panel_Npc_Quest_Reward, "Button_Win_Close")
local defaultRewardText = UI.getChildControl(Panel_Npc_Quest_Reward, "Static_Menu_Reward")
local selectRewardText = UI.getChildControl(Panel_Npc_Quest_Reward, "Static_Menu_Reward_Select")
local _checkedQuestStaticActive = UI.getChildControl(Panel_CheckedQuest, "Static_Active")
local expTooltipBase = UI.getChildControl(_checkedQuestStaticActive, "StaticText_Notice_2")
local expTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Npc_Quest_Reward, "expTooltip")
CopyBaseProperty(expTooltipBase, expTooltip)
expTooltip:SetColor(UI_color.C_FFFFFFFF)
expTooltip:SetAlpha(1)
expTooltip:SetFontColor(UI_color.C_FFFFFFFF)
expTooltip:SetAutoResize(true)
expTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
expTooltip:SetTextHorizonLeft()
expTooltip:SetShow(false)
local checkButtonOnTexture = _uiCheckButton:getOnTexture()
local checkButtonClickTexture = _uiCheckButton:getClickTexture()
reward_CloseButton:addInputEvent("Mouse_LUp", "FGlobal_ShowRewardList(false, " .. 0 .. ")")
for index = 0, _maxBaseSlotCount - 1 do
  local backBaseReward = UI.getChildControl(Panel_Npc_Quest_Reward, "Static_Slot_" .. index)
  backBaseReward:SetIgnore(true)
  _uiBackBaseReward[index] = backBaseReward
  local slot = {}
  SlotItem.new(slot, "BaseReward_" .. index, index, backBaseReward, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(1)
  slot.icon:SetPosY(1)
  _listBaseRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_QuestReward_Base")
end
for index = 0, _maxSelectSlotCount - 1 do
  local buttonSelectRewardSlot = UI.getChildControl(Panel_Npc_Quest_Reward, "CheckButton_" .. index)
  buttonSelectRewardSlot:addInputEvent("Mouse_LUp", "HandleClickedSelectedReward(" .. index .. ")")
  _uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot
  local slot = {}
  SlotItem.new(slot, "SelectReward_" .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(1)
  slot.icon:SetPosY(1)
  slot.icon:SetIgnore(true)
  _listSelectRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_QuestReward_Select")
end
function QuestReward_Init()
  defaultRewardText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  defaultRewardText:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_REWARD"))
  defaultRewardText:SetAutoResize(true)
  selectRewardText:SetTextMode(UI_TM.eTextMode_AutoWrap)
  selectRewardText:SetText(PAGetString(Defines.StringSheet_RESOURCE, "DIALOGUE_REWARD_TXT_SREWARD"))
  selectRewardText:SetAutoResize(true)
end
function HandleClickedSelectedReward(selectIndex)
  for index = 0, 5 do
    _uiButtonSelectRewardSlots[index]:SetCheck(false)
    _uiButtonSelectRewardSlots[index]:EraseAllEffect()
  end
  _uiButtonSelectRewardSlots[selectIndex]:AddEffect("UI_Quest_Compensate_Loop", true, 0, 0)
  _uiButtonSelectRewardSlots[selectIndex]:SetCheck(true)
  _uiButtonSelectRewardSlots[selectIndex]:setRenderTexture(checkButtonClickTexture)
  _isSelectReward = true
  ReqeustDialog_selectReward(selectIndex)
  _selectRewardItemName = _selectRewardItemNameArry[selectIndex]
end
function FGlobal_SelectedRewardConfirm()
  if _selectRewardItemName ~= nil then
    return _selectRewardItemName
  else
    return false
  end
end
function FGlobal_SelectRewardItemNameClear()
  _selectRewardItemName = nil
end
function HandleOnSelectedReward(index)
  Panel_Tooltip_Item_Show_GeneralStatic(index, "Dialog_QuestReward_Select", true)
  _uiButtonSelectRewardSlots[index]:setRenderTexture(checkButtonOnTexture)
end
local function setReward(uiSlot, reward, index, questType)
  rewardTooltip(nil, false)
  uiSlot.enchantText:SetShow(false)
  uiSlot._type = reward._type
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"ExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"ExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExpGrade == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"SkillExpGrade\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"SkillExpGrade\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot._item = reward._item
    if "main" == questType then
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Base\",false)")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "")
      uiSlot.icon:addInputEvent("Mouse_Out", "")
      _uiButtonSelectRewardSlots[index]:addInputEvent("Mouse_On", "HandleOnSelectedReward(" .. index .. ")")
      _uiButtonSelectRewardSlots[index]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_QuestReward_Select\",false)")
    end
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " , " .. reward._character .. ", " .. reward._value .. ")")
  elseif __eRewardKnowledge == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"Knowledge\", true, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"Knowledge\", false, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  if __eRewardGrowStep == reward._type then
    return true
  end
  return false
end
function rewardTooltip(type, show, questtype, index, key, value)
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
function FGlobal_SetRewardList(baseReward, selectReward, questData)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local userLevel = selfPlayer:get():getLevel()
  _baseRewardCount = #baseReward
  _selectRewardCount = #selectReward
  FGlobal_SelectRewardItemNameClear()
  for index = 0, _maxBaseSlotCount - 1 do
    _uiBackBaseReward[index]:EraseAllEffect()
    if index < _baseRewardCount then
      local isGrowReward = setReward(_listBaseRewardSlots[index], baseReward[index + 1], index, "main")
      if true == isGrowReward then
        _uiBackBaseReward[index]:SetShow(false)
      else
        _uiBackBaseReward[index]:SetShow(true)
      end
    else
      _uiBackBaseReward[index]:SetShow(false)
    end
  end
  for index = 0, 5 do
    _uiButtonSelectRewardSlots[index]:SetCheck(false)
  end
  local _equipRewardCount = 0
  local _equipEnableSlot
  for index = 0, _maxSelectSlotCount - 1 do
    _uiButtonSelectRewardSlots[index]:EraseAllEffect()
    if index < _selectRewardCount then
      local isEquipable = setReward(_listSelectRewardSlots[index], selectReward[index + 1], index, "sub")
      if isEquipable then
        _equipRewardCount = _equipRewardCount + 1
        _equipEnableSlot = index
      end
      _uiButtonSelectRewardSlots[index]:SetShow(true)
      _uiButtonSelectRewardSlots[index]:SetCheck(false)
      _uiButtonSelectRewardSlots[index]:AddEffect("UI_Quest_Compensate", true, 0, 0)
      _uiButtonSelectRewardSlots[index]:AddEffect("fUI_Light", false, 0, 0)
    else
      _uiButtonSelectRewardSlots[index]:SetShow(false)
    end
    if userLevel < 50 and _selectRewardCount > 0 then
      _uiButtonSelectRewardSlots[0]:SetCheck(true)
      HandleClickedSelectedReward(0)
    end
    if index < _selectRewardCount then
      do
        local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(selectReward[index + 1]._item))
        _selectRewardItemNameArry[index] = itemStatic:getName()
      end
      do break end
      _selectRewardItemNameArry[index] = nil
    end
  end
  _equipRewardItemCount = _equipRewardCount
  if _equipRewardCount == 1 and nil ~= _equipEnableSlot then
    local classType = getSelfPlayer():getClassType()
    if 0 == classType or 24 == classType then
      classType = 4
    else
      classType = 0
    end
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(selectReward[_equipEnableSlot + 1]._item))
    if false == itemStatic:get()._usableClassType:isOn(classType) then
      HandleClickedSelectedReward(_equipEnableSlot)
    end
  end
  if nil ~= questData then
    _uiQuestTitle:SetText(questData:getTitle())
    _uiQuestTitle:ChangeTextureInfoName(questData:getIconPath())
    _uiQuestNpc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "QUESTLIST_COMPLETETARGET", "getCompleteDisplay", questData:getCompleteDisplay()))
    _uiQuestDesc:SetAutoResize(true)
    _uiQuestDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _uiQuestDesc:SetText(ToClient_getReplaceDialog(questData:getDesc()))
    _uiQuestDesc:SetPosY(-49)
    _uiQuestNpc:SetPosY(-94)
    _uiQuestTitle:SetPosY(-74)
    questDescSizeY = _uiQuestDesc:GetSizeY()
    questDescPosY = _uiQuestDesc:GetPosY()
    questDescgap = questDescSizeY + questDescPosY + 5
    if questDescSizeY + questDescPosY > 0 then
      _uiQuestDesc:SetPosY(-49 - questDescgap)
      _uiQuestNpc:SetPosY(-94 - questDescgap)
      _uiQuestTitle:SetPosY(-74 - questDescgap)
    end
    _uiQuestTitle:ComputePos()
    _uiQuestNpc:ComputePos()
    _uiQuestDesc:ComputePos()
    _uiQuestTitle:SetShow(true)
    _uiQuestNpc:SetShow(true)
    _uiQuestDesc:SetShow(true)
  else
    _uiQuestTitle:SetShow(false)
    _uiQuestNpc:SetShow(false)
    _uiQuestDesc:SetShow(false)
  end
end
function FGlobal_ShowRewardList(isVisible, isManualClick)
  if isVisible then
    if _baseRewardCount > 0 or _selectRewardCount > 0 then
      Panel_Npc_Quest_Reward:SetShow(true)
    else
      Panel_Npc_Quest_Reward:SetShow(false)
      if Panel_Npc_Quest_Reward:IsUISubApp() == true then
        Panel_Npc_Quest_Reward:CloseUISubApp()
      end
    end
  else
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer or nil == selfPlayer:get() then
      return
    end
    if isFlushedUI() and selfPlayer:get():getLevel() < 11 and nil ~= isManualClick and 0 == isManualClick then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_DIALOG_REWARD_SHOWREWARDLIST"))
      return
    end
    Panel_Npc_Quest_Reward:SetShow(false)
    if Panel_Npc_Quest_Reward:IsUISubApp() == true then
      Panel_Npc_Quest_Reward:CloseUISubApp()
    end
  end
end
function FGlobal_getSelectRewardPosition()
  local Position = {_PosX = 0, _PosY = 0}
  Position._PosX = _uiButtonSelectRewardSlots[0]:GetPosX() + Panel_Npc_Quest_Reward:GetPosX() + _uiButtonSelectRewardSlots[0]:GetSizeX() / 2
  Position._PosY = _uiButtonSelectRewardSlots[0]:GetPosY() + Panel_Npc_Quest_Reward:GetPosY() + _uiButtonSelectRewardSlots[0]:GetSizeY() / 2
  return Position
end
local _buttonQuestion = UI.getChildControl(Panel_Npc_Quest_Reward, "Button_Question")
_buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelQuestReward\" )")
_buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"true\")")
_buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"false\")")
QuestReward_Init()
