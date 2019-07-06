function HandleEventOn_TotalReward_Slot(rewardKey, index, slotIndex, isOn)
  if nil == rewardKey or nil == index or nil == slotIndex or nil == isOn then
    return
  end
  if nil == PaGlobal_TotalReward.itemDatas[rewardKey] or nil == PaGlobal_TotalReward.itemDatas[rewardKey][index] then
    return
  end
  Panel_Tooltip_Item_Show_GeneralStatic(slotIndex, "totalReward", isOn, false)
end
function HandleEventRUp_TotalReward_Slot(rewardKey, index)
  if nil == Panel_Window_TotalReward then
    return
  end
  PaGlobal_TotalReward:receiveItem(rewardKey, index, false)
end
function HandleEventLUp_TotalReward_Silver()
  if nil == Panel_Window_TotalReward then
    return
  end
  PaGlobal_TotalReward:receiveSilver()
end
function HandleEventLUp_TotalReward_All()
  if nil == Panel_Window_TotalReward then
    return
  end
  PaGlobal_TotalReward:receiveAll()
end
function HandleEventLUp_TotalReward_LogWidget_ToggleShow()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  if true == PaGlobal_TotalReward._ui.stc_itemLog_widget:GetShow() then
    PaGlobal_TotalReward:itemWidget_ToggleShow(false)
  else
    PaGlobal_TotalReward:itemWidget_ToggleShow(true)
  end
end
function FromClient_TotalReward_PendingRewardUpdated()
  PaGlobal_TotalReward:update()
end
function FromClient_TotalReward_PendingRewardLogUpdated()
  PaGlobal_TotalReward:update()
end
