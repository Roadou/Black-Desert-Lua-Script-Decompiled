local Panel_Dialog_Reward_Select_info = {
  _ui = {
    static_SlotItemBg = nil,
    static_Item_Focus = nil,
    static_BottomBg = nil
  },
  _value = {selectIndex = 0, rewardCount = 0},
  _config = {
    slotCount = 6,
    questRewardSlotConfig = {
      _createIcon = true,
      _createBorder = true,
      _createCount = true,
      _createClassEquipBG = true,
      _createCash = true
    }
  },
  _slotBG = {},
  _slot = {}
}
function Panel_Dialog_Reward_Select_info:registEventHandler()
end
function Panel_Dialog_Reward_Select_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_Reward_Select_Resize")
end
function Panel_Dialog_Reward_Select_info:initialize()
  self:childControl()
  self:createSlot()
  self:initValue()
  self:resize()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Dialog_Reward_Select_info:initValue()
  self._value.selectIndex = 0
  self._value.rewardCount = 0
end
function Panel_Dialog_Reward_Select_info:resize()
  Panel_Dialge_RewardSelect:ComputePos()
end
function Panel_Dialog_Reward_Select_info:childControl()
  self._ui.static_SlotItemBg = UI.getChildControl(Panel_Dialge_RewardSelect, "Static_SlotItemBg")
  self._ui.static_BottomBg = UI.getChildControl(Panel_Dialge_RewardSelect, "Static_BottomBg")
  self._ui.keyGuide_A = UI.getChildControl(self._ui.static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.keyGuide_B = UI.getChildControl(self._ui.static_BottomBg, "StaticText_B_ConsoleUI")
  for index = 0, self._config.slotCount - 1 do
    self._slotBG[index] = UI.getChildControl(self._ui.static_SlotItemBg, "RadioButton_Slot" .. index + 1)
    self._slotBG[index]:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_FocusSlot(true," .. index .. ")")
    self._slotBG[index]:addInputEvent("Mouse_Out", "PaGlobalFunc_Reward_Select_FocusSlot(false," .. index .. ")")
  end
  local tempBtnGroup = {
    self._ui.keyGuide_A,
    self._ui.keyGuide_B
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.static_Item_Focus = UI.getChildControl(self._ui.static_SlotItemBg, "Static_Item_Focus")
end
function Panel_Dialog_Reward_Select_info:createSlot()
  for index = 0, self._config.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "Static_SelectReward_" .. index, index, self._slotBG[index], self._config.questRewardSlotConfig)
    slot:createChild()
    self._slot[index] = slot
  end
end
function Panel_Dialog_Reward_Select_info:setContent()
  local dialogData = ToClient_GetCurrentDialogData()
  if nil == dialogData then
    return
  end
  local selectedIndex = dialogData:getSelectedQuestIndex()
  local simplequestData = dialogData:getHaveQuestAt(selectedIndex)
  if nil == simplequestData then
    return
  end
  self:setQuestReward(simplequestData)
end
function Panel_Dialog_Reward_Select_info:open()
  Panel_Dialge_RewardSelect:SetShow(true)
end
function Panel_Dialog_Reward_Select_info:close()
  Panel_Dialge_RewardSelect:SetShow(false)
end
function Panel_Dialog_Reward_Select_info:clearQuestReward()
  for index = 0, self._config.slotCount - 1 do
    self._slot[index]:clearItem()
    self._slot[index]._item = nil
  end
end
function Panel_Dialog_Reward_Select_info:setQuestReward(simplequestData)
  self:clearQuestReward()
  local questInfo = simplequestData:getQuestStaticStatusWrapper()
  if nil == questInfo then
    return
  end
  local selectRewardCount = questInfo:getQuestSelectRewardCount()
  self._value.rewardCount = selectRewardCount
  for selectIndex = 0, selectRewardCount - 1 do
    local selectReward = questInfo:getQuestSelectRewardAt(selectIndex)
    if nil == selectReward then
      break
    end
    self:setRewardIcon(self._slot[selectIndex], selectReward, selectIndex, "select")
  end
end
function Panel_Dialog_Reward_Select_info:setRewardIcon(slot, reward, index, rewardStr)
  local rewardType = reward:getType()
  if nil == rewardType then
    return
  end
  slot._type = rewardType
  slot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_Reward_Select_Confirm()")
  if __eRewardExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    slot.icon:SetShow(true)
  elseif __eRewardExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    slot.icon:SetShow(true)
  elseif __eRewardSkillExpGrade == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    slot.icon:SetShow(true)
  elseif __eRewardLifeExp == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
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
    if "select" == rewardStr then
      slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    end
    slot.count:SetSize(42, 21)
    slot.count:SetPosY(slot.count:GetPosY() + slot.count:GetSizeY())
    slot.count:SetTextHorizonRight()
    slot.count:SetVerticalBottom()
  elseif __eRewardIntimacy == rewardType then
    slot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
    slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    slot.icon:SetShow(true)
  else
    if __eRewardKnowledge == rewardType then
      slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
      slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Reward_Select_SelectReward(" .. index .. "," .. rewardType .. ")")
      slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
      slot.icon:SetShow(true)
    else
    end
  end
end
function Panel_Dialog_Reward_Select_info:focusPos(isOn, index)
  if nil == self._slotBG[index] then
    return
  end
  local posX = self._slotBG[index]:GetPosX()
  local posY = self._slotBG[index]:GetPosY()
  if isOn then
    self._ui.static_Item_Focus:SetShow(true)
    self._ui.static_Item_Focus:SetPosXY(posX, posY)
  else
    self._ui.static_Item_Focus:SetShow(false)
  end
end
function PaGlobalFunc_Reward_Select_GetShow()
  return Panel_Dialge_RewardSelect:GetShow()
end
function PaGlobalFunc_Reward_Select_Open()
  local self = Panel_Dialog_Reward_Select_info
  self:open()
end
function PaGlobalFunc_Reward_Select_Close()
  local self = Panel_Dialog_Reward_Select_info
  self:close()
end
function PaGlobalFunc_Reward_Select_Show()
  local self = Panel_Dialog_Reward_Select_info
  self:initValue()
  self:setContent()
  self:open()
end
function PaGlobalFunc_Reward_Select_Exit()
  local self = Panel_Dialog_Reward_Select_info
  Panel_Tooltip_Item_hideTooltip()
  self:close()
end
function PaGlobalFunc_Reward_Select_Confirm()
  local self = Panel_Dialog_Reward_Select_info
  if self._value.rewardCount <= self._value.selectIndex then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGE_YOUCANSELECTITEM"))
    return
  end
  PaGlobalFunc_MainDialog_Quest_HandleClickedSelectedReward(self._value.selectIndex)
  PaGlobalFunc_Reward_Select_Exit()
  ToClient_ClickQuestButton(0)
end
function PaGlobalFunc_Reward_Select_SelectReward(index, rewardType)
  local self = Panel_Dialog_Reward_Select_info
  self._value.selectIndex = index
  if __eRewardItem == rewardType then
    local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(self._slot[index]._item))
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, 0)
  end
end
function PaGlobalFunc_Reward_Select_FocusSlot(isOn, index)
  local self = Panel_Dialog_Reward_Select_info
  self:focusPos(isOn, index)
end
function FromClient_Reward_Select_Init()
  local self = Panel_Dialog_Reward_Select_info
  self:initialize()
end
function FromClient_Reward_Select_Resize()
  local self = Panel_Dialog_Reward_Select_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_Reward_Select_Init")
