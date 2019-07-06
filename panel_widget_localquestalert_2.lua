function FromClient_LocalQuestAlert_QuestClearAlert(isAccept, questNoRaw)
  local questInfoWrapper = questList_getQuestInfo(questNoRaw)
  if nil == Panel_Widget_LocalQuestAlert or nil == questInfoWrapper then
    return
  end
  local questGroupNo = questInfoWrapper:getQuestGroupNo()
  local questQuestId = questInfoWrapper:getQuestGroupQuestNo()
  if false == isAccept then
    for key, value in ipairs(PaGlobal_LocalQuestAlert._questInfo) do
      if questGroupNo == value[1] and questQuestId == value[2] then
        PaGlobal_LocalQuestAlert._completeInfoKey = value[3]
        return
      end
    end
  end
end
function PaGloabl_LocalQuestAlert_ShowAni()
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  Panel_Widget_LocalQuestAlert:SetShow(true)
  local showAni = Panel_Widget_LocalQuestAlert:addColorAnimation(0, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  showAni:SetStartColor(Defines.Color.C_00FFFFFF)
  showAni:SetEndColor(Defines.Color.C_FFFFFFFF)
  showAni:SetStartIntensity(3)
  showAni:SetEndIntensity(1)
  showAni.IsChangeChild = true
end
function PaGloabl_LocalQuestAlert_HideAni()
  if nil == Panel_Widget_LocalQuestAlert then
    return
  end
  local closeAni = Panel_Widget_LocalQuestAlert:addColorAnimation(6, 6.5, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  closeAni:SetStartColor(Defines.Color.C_FFFFFFFF)
  closeAni:SetEndColor(Defines.Color.C_00FFFFFF)
  closeAni:SetStartIntensity(3)
  closeAni:SetEndIntensity(1)
  closeAni.IsChangeChild = true
  closeAni:SetHideAtEnd(true)
  closeAni:SetDisableWhileAni(true)
end
function PaGlobal_LocalQuestAlert_AlertOpen()
  if -1 ~= PaGlobal_LocalQuestAlert._completeInfoKey then
    PaGlobal_LocalQuestAlert:prepareOpen()
  end
end
