function PaGlobalFunc_DialogQuest_All_Open()
  PaGlobal_DialogQuest_All:prepareOpen()
end
function PaGlobalFunc_DialogQuest_All_Close()
  PaGlobal_DialogQuest_All:prepareClose()
end
function HandleEventLUp_DialogQuest_All_QuestRefuse()
  PaGlobalFunc_DialogMain_All_Close()
end
function HandleEventLUp_DialogQuest_All_SelectReward(selectIndex)
  PaGlobal_DialogQuest_All._selectIndex = selectIndex
  for index = 0, PaGlobal_DialogQuest_All._maxSelectSlotCount - 1 do
    PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[index]:SetCheck(false)
    PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[index]:EraseAllEffect()
    PaGlobal_DialogQuest_All._ui.stc_selectRewardList[index]:setRenderTexture(PaGlobal_DialogQuest_All._selectCheckBaseTexture)
  end
  PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[selectIndex]:AddEffect("UI_Quest_Compensate_Loop", true, 0, 0)
  PaGlobal_DialogQuest_All._uiBackSelectRewardCheck[selectIndex]:SetCheck(true)
  PaGlobal_DialogQuest_All._ui.stc_selectRewardList[selectIndex]:setRenderTexture(PaGlobal_DialogQuest_All._selectCheckClickTexture)
  PaGlobal_DialogQuest_All._selectRewardItemName = PaGlobal_DialogQuest_All._selectRewardItemNameList[selectIndex]
  ReqeustDialog_selectReward(selectIndex)
end
function HandleEventEnter_DialogQuest_All_SelectConfirmReward()
  if false == PaGlobalFunc_DialogQuest_All_GetSelectedRewardItemName() and nil ~= PaGlobal_DialogQuest_All._selectIndex then
    HandleEventLUp_DialogQuest_All_SelectReward(PaGlobal_DialogQuest_All._selectIndex)
  end
  local displayData = Dialog_getButtonDisplayData(0)
  if displayData:empty() then
    Dialog_clickDialogButtonReq(0)
  end
end
function HandleEventOnOut_DialogQuest_All_RewardTooltip(type, show, questtype, index, key, value)
  local mainText, descText, control
  if "main" == questtype then
    control = PaGlobal_DialogQuest_All._listBaseRewardSlots[index].icon
  else
    control = PaGlobal_DialogQuest_All._listSelectRewardSlots[index].icon
  end
  if true == show and nil ~= control then
    if "Exp" == type then
      mainText = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP")
    elseif "SkillExp" == type then
      mainText = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP")
    elseif "ExpGrade" == type then
      mainText = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP_GRADE")
    elseif "SkillExpGrade" == type then
      mainText = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP_GRADE")
    elseif "ProductExp" == type then
      mainText = PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP")
    elseif "Intimacy" == type then
      local wrapper = ToClient_GetCharacterStaticStatusWrapper(key)
      local npcName = wrapper:getName()
      mainText = npcName .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY") .. " " .. value
    elseif "Knowledge" == type then
      local mentalCardSSW = ToClinet_getMentalCardStaticStatus(key)
      local mentalCardName = mentalCardSSW:getName()
      local mentalCardDesc = mentalCardSSW:getDesc()
      local mentalCardDescStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_REWARD_TOOLTIP_KNOWLEDGE", "mentalCardName", mentalCardName, "mentalCardName2", mentalCardName)
      TooltipSimple_Show(control, "", mentalCardDescStr)
      return
    end
    TooltipSimple_Show(control, mainText, descText)
  else
    TooltipSimple_Hide()
    return
  end
end
function PaGlobalFunc_DialogQuest_All_SetRewardList()
  PaGlobal_DialogQuest_All:questDataUpdate()
end
function PaGlobalFunc_DialogQuest_All_DialogShowCheck()
  if 0 < PaGlobal_DialogQuest_All._baseRewardCount or 0 < PaGlobal_DialogQuest_All._selectRewardCount then
    return true
  else
    return false
  end
end
function PaGlobalFunc_DialogQuest_All_GetSelectedRewardItemName()
  if nil ~= PaGlobal_DialogQuest_All._selectRewardItemName then
    return PaGlobal_DialogQuest_All._selectRewardItemName
  else
    return false
  end
end
function PaGlobalFunc_DialogQuest_All_ClearSelectRewardItemName()
  PaGlobal_DialogQuest_All._selectRewardItemNameList = {}
end
