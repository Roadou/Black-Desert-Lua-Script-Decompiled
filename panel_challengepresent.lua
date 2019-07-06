local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
Panel_ChallengePresent:SetShow(false)
Panel_ChallengePresent:setGlassBackground(true)
Panel_ChallengePresent:ActiveMouseEventEffect(true)
Panel_ChallengePresent:RegisterShowEventFunc(true, "Panel_ChallengePresent_ShowAni()")
Panel_ChallengePresent:RegisterShowEventFunc(false, "Panel_ChallengePresent_HideAni()")
local _questrewardSlotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true,
  createClassEquipBG = true,
  createCash = true
}
local _remainRewardCount = 0
local _baseRewardCount = 0
local _maxBaseSlotCount = 6
local _uiBackBaseReward = {}
local _listBaseRewardSlots = {}
local _selectRewardCount = 0
local _maxSelectSlotCount = 6
local _uiButtonSelectRewardSlots = {}
local _listSelectRewardSlots = {}
local isHaveSelectReward = false
local specialRewardCount = 0
local questDescPosY = 0
local questDescSizeY = 0
local questDescgap = 0
local currentReward = 0
local selectedRewardSlotIndex = 0
local acceptButton_isShow = true
local specialRewardWrapper = {}
local normalRewardWrapper = {}
local isInit = true
local beforBenefitReward = 0
local challengeTitleText = UI.getChildControl(Panel_ChallengePresent, "StaticText_EventTitle")
local remainRewardCount = UI.getChildControl(Panel_ChallengePresent, "StaticText_RemainRewardCountText")
local reward_CloseButton = UI.getChildControl(Panel_ChallengePresent, "Button_Close")
local reward_AcceptButton = UI.getChildControl(Panel_ChallengePresent, "Button_GiveMe")
local reward_CancelButton = UI.getChildControl(Panel_ChallengePresent, "Button_Cancel")
local specialRewardIcon = UI.getChildControl(Panel_SpecialReward_Alert, "Static_Icon")
specialRewardIcon:addInputEvent("Mouse_LUp", "FGlobal_ChallengePresent_Open()")
local _buttonQuestion = UI.getChildControl(Panel_ChallengePresent, "Button_Question")
_buttonQuestion:SetShow(false)
function Panel_ChallengePresent_ShowAni()
  local aniInfo1 = Panel_ChallengePresent:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.12)
  aniInfo1.AxisX = Panel_ChallengePresent:GetSizeX() / 2
  aniInfo1.AxisY = Panel_ChallengePresent:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_ChallengePresent:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.12)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_ChallengePresent:GetSizeX() / 2
  aniInfo2.AxisY = Panel_ChallengePresent:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_ChallengePresent_HideAni()
  local aniInfo1 = Panel_ChallengePresent:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local SpecialSelectReward = {
  _uiRewardSlot_0 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_0"),
  _uiRewardSlot_1 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_1"),
  _uiRewardSlot_2 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_2"),
  _uiRewardSlot_3 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_3"),
  _uiRewardSlot_4 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_4"),
  _uiRewardSlot_5 = UI.getChildControl(Panel_ChallengePresent, "Static_ItemBG_5"),
  _uiCheckButton_0 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_0"),
  _uiCheckButton_1 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_1"),
  _uiCheckButton_2 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_2"),
  _uiCheckButton_3 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_3"),
  _uiCheckButton_4 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_4"),
  _uiCheckButton_5 = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_5")
}
local eventDesc = UI.getChildControl(Panel_ChallengePresent, "StaticText_EventDesc")
local checkButtonOnTexture = SpecialSelectReward._uiCheckButton_0:getOnTexture()
local checkButtonClickTexture = SpecialSelectReward._uiCheckButton_0:getClickTexture()
reward_CloseButton:addInputEvent("Mouse_LUp", "ShowSpecialRewardList(false)")
reward_AcceptButton:addInputEvent("Mouse_LUp", "Panel_ChallengePresent_AcceptReward_Clicked()")
reward_CancelButton:addInputEvent("Mouse_LUp", "ShowSpecialRewardList(false)")
for index = 0, _maxBaseSlotCount - 1 do
  local backBaseReward = UI.getChildControl(Panel_ChallengePresent, "Static_Slot_" .. index)
  backBaseReward:SetIgnore(true)
  _uiBackBaseReward[index] = backBaseReward
  local slot = {}
  SlotItem.new(slot, "BaseReward_" .. index, index, backBaseReward, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(0)
  slot.icon:SetPosY(0)
  _listBaseRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_ChallengePcroomReward_Base")
end
for index = 0, _maxSelectSlotCount - 1 do
  local buttonSelectRewardSlot = UI.getChildControl(Panel_ChallengePresent, "Checkbox_SelectedBG_" .. index)
  buttonSelectRewardSlot:addInputEvent("Mouse_LUp", "HandleClicked_SelectedReward(" .. index .. ")")
  _uiButtonSelectRewardSlots[index] = buttonSelectRewardSlot
  local slot = {}
  SlotItem.new(slot, "SelectReward_" .. index, index, buttonSelectRewardSlot, _questrewardSlotConfig)
  slot:createChild()
  slot.icon:SetPosX(4)
  slot.icon:SetPosY(4)
  slot.icon:SetIgnore(false)
  _listSelectRewardSlots[index] = slot
  Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_ChallengeReward_Select")
end
function HandleClicked_SelectedReward(selectIndex)
  selectedRewardSlotIndex = selectIndex
  for index = 0, 5 do
    _uiButtonSelectRewardSlots[index]:SetCheck(false)
    _uiButtonSelectRewardSlots[index]:EraseAllEffect()
  end
  _uiButtonSelectRewardSlots[selectIndex]:AddEffect("UI_Quest_Compensate_Loop", true, 0, 0)
  _uiButtonSelectRewardSlots[selectIndex]:SetCheck(true)
end
function ShowTooltip_SpecialReward(index)
  Panel_Tooltip_Item_Show_GeneralStatic(index, "Dialog_ChallengeReward_Select", true)
  _uiButtonSelectRewardSlots[index]:setRenderTexture(checkButtonOnTexture)
end
function Set_Special_Reward(uiSlot, reward, index, questType)
  uiSlot._type = reward._type
  if __eRewardExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "SpecialRewardTooltip( \"Exp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "SpecialRewardTooltip( \"Exp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardSkillExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "SpecialRewardTooltip( \"SkillExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "SpecialRewardTooltip( \"SkillExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardLifeExp == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "SpecialRewardTooltip( \"ProductExp\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "SpecialRewardTooltip( \"ProductExp\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardItem == reward._type then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot._item = reward._item
    if "main" == questType then
      uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_ChallengePcroomReward_Base\",true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_ChallengePcroomReward_Base\",false)")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "")
      uiSlot.icon:addInputEvent("Mouse_Out", "")
      _uiButtonSelectRewardSlots[index]:addInputEvent("Mouse_On", "ShowTooltip_SpecialReward(" .. index .. ")")
      _uiButtonSelectRewardSlots[index]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_ChallengePcroomReward_Select\",false)")
    end
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "SpecialRewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "SpecialRewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  return false
end
function SpecialRewardTooltip(type, show, questtype, index)
  if true == show then
    if "Exp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP"))
    elseif "SkillExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP"))
    elseif "ProductExp" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP"))
    elseif "Intimacy" == type then
      expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY"))
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
function FromClient_SpecialReward_UpdateText()
  specialRewardCount = 0
  local rewardCount = ToClient_GetBenefitRewardInfoCount()
  if rewardCount <= 0 then
    Panel_SpecialReward_Alert:SetShow(false)
  else
    Panel_SpecialReward_Alert:SetShow(true)
  end
  currentReward = rewardCount - 1
  local rewardWrapper = ToClient_GetBenefitRewardInfoWrapper(currentReward)
  if nil ~= rewardWrapper then
    local baseCount = rewardWrapper:getBaseRewardCount()
    challengeTitleText:SetText(rewardWrapper:getName())
    eventDesc:SetText(rewardWrapper:getDesc())
    local _baseReward = {}
    for idx = 1, baseCount do
      local baseReward = rewardWrapper:getBaseRewardAt(idx - 1)
      _baseReward[idx] = {}
      _baseReward[idx]._type = baseReward._type
      if __eRewardExp == baseReward._type then
        _baseReward[idx]._exp = baseReward._experience
      elseif __eRewardSkillExp == baseReward._type then
        _baseReward[idx]._exp = baseReward._skillExperience
      elseif __eRewardLifeExp == baseReward._type then
        _baseReward[idx]._exp = baseReward._productExperience
      elseif __eRewardItem == baseReward._type then
        _baseReward[idx]._item = baseReward:getItemEnchantKey()
        _baseReward[idx]._count = baseReward._itemCount
      elseif __eRewardIntimacy == baseReward._type then
        _baseReward[idx]._character = baseReward:getIntimacyCharacter()
        _baseReward[idx]._value = baseReward._intimacyValue
      end
    end
    local selectCount = rewardWrapper:getSelectRewardCount()
    local _selectReward = {}
    if selectCount > 0 then
      isHaveSelectReward = true
      for idx = 1, selectCount do
        local selectReward = rewardWrapper:getSelectRewardAt(idx - 1)
        _selectReward[idx] = {}
        _selectReward[idx]._type = selectReward._type
        if __eRewardExp == selectReward._type then
          _selectReward[idx]._exp = selectReward._experience
        elseif __eRewardSkillExp == selectReward._type then
          _selectReward[idx]._exp = selectReward._skillExperience
        elseif __eRewardLifeExp == selectReward._type then
          _selectReward[idx]._exp = selectReward._productExperience
        elseif __eRewardItem == selectReward._type then
          _selectReward[idx]._item = selectReward:getItemEnchantKey()
          _selectReward[idx]._count = selectReward._itemCount
          local selfPlayer = getSelfPlayer()
          if nil ~= selfPlayer then
            local classType = selfPlayer:getClassType()
            _selectReward[idx]._isEquipable = selectReward:isEquipable(classType)
          end
        elseif __eRewardIntimacy == selectReward._type then
          _selectReward[idx]._character = selectReward:getIntimacyCharacter()
          _selectReward[idx]._value = selectReward._intimacyValue
        end
      end
    else
      isHaveSelectReward = false
      _selectReward = nil
    end
    SetSpecialRewardList(_baseReward, _selectReward)
    specialRewardCount = specialRewardCount + 1
  end
  remainRewardCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CHALLENGEPRESENT_REMAINREWARDCOUNT", "specialRewardCount", specialRewardCount))
end
function Panel_ChallengePresent_AcceptReward_Clicked()
  local rewardWrapper = ToClient_GetBenefitRewardInfoWrapper(currentReward)
  local specialRewardKey = rewardWrapper:getKey()
  local selectCount = rewardWrapper:getSelectRewardCount()
  if 0 ~= selectCount then
    local isCheck = false
    for i = 0, selectCount - 1 do
      if _uiButtonSelectRewardSlots[i]:IsCheck() then
        isCheck = true
      end
    end
    if false == isCheck then
      local msg = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGEPRESENT_SELECTREWARDITEM"),
        sub = PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGEPRESENT_SELECTGETITEM")
      }
      Proc_ShowMessage_Ack_WithOut_ChattingMessage_For_RewardSelect(msg, 6, 4)
      return
    end
  else
    selectedRewardSlotIndex = 0
  end
  ToClient_AcceptReward_ButtonClicked(specialRewardKey, selectedRewardSlotIndex)
  FGlobal_ChallengePresent_Close()
end
function FGlobal_ChallengePresent_AcceptReward()
  Panel_ChallengePresent_AcceptReward_Clicked()
end
function SetSpecialRewardList(baseReward, selectReward)
  _baseRewardCount = #baseReward
  for index = 0, _maxBaseSlotCount - 1 do
    _uiBackBaseReward[index]:EraseAllEffect()
    if index < _baseRewardCount then
      Set_Special_Reward(_listBaseRewardSlots[index], baseReward[index + 1], index, "main")
    end
  end
  for index = 0, 5 do
    _uiButtonSelectRewardSlots[index]:SetCheck(false)
  end
  local _equipRewardCount = 0
  local _equipEnableSlot, _selectRewardCount
  if nil ~= selectReward then
    _selectRewardCount = #selectReward
  else
    _selectRewardCount = 0
  end
  for index = 0, _maxSelectSlotCount - 1 do
    _uiButtonSelectRewardSlots[index]:EraseAllEffect()
    if index < _selectRewardCount then
      local isEquipable = Set_Special_Reward(_listSelectRewardSlots[index], selectReward[index + 1], index, "sub")
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
  end
  if _equipRewardCount == 1 and nil ~= _equipEnableSlot then
    HandleClicked_SelectedReward(_equipEnableSlot)
  end
end
function ShowSpecialRewardList(isVisible)
  if isVisible then
    Panel_ChallengePresent:SetShow(true, true)
  else
    Panel_ChallengePresent:SetShow(false, true)
  end
end
function FGlobal_ChallengePresent_Open()
  local rewardCount = ToClient_GetBenefitRewardInfoCount()
  if nil == rewardCount or 0 == rewardCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHALLENGEPRESENT_DONTGETITEM"))
    return
  end
  FromClient_SpecialReward_UpdateText()
  Panel_ChallengePresent:SetShow(true, true)
end
function FGlobal_ChallengePresent_Close()
  CheckChattingInput()
  Panel_ChallengePresent:SetShow(false, true)
end
registerEvent("FromClient_BenefitReward_UpdateText", "FromClient_SpecialReward_UpdateText")
