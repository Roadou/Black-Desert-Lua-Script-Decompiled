function PaGlobal_TotalReward:initialize()
  if nil == Panel_Window_TotalReward then
    return
  end
  if true == PaGlobal_TotalReward._initialize then
    return
  end
  PaGlobal_TotalReward._ui.stctxt_mouseR = UI.getChildControl(PaGlobal_TotalReward._ui.stc_contentGroup, "StaticText_MouseR")
  PaGlobal_TotalReward._ui.stctxt_itemLog = UI.getChildControl(PaGlobal_TotalReward._ui.stc_contentGroup, "StaticText_ItemLog")
  PaGlobal_TotalReward._ui.btn_close = UI.getChildControl(PaGlobal_TotalReward._ui.stc_topGroup, "Button_Close")
  PaGlobal_TotalReward._ui.btn_receive = UI.getChildControl(PaGlobal_TotalReward._ui.stc_bottomGroup, "Button_Receive")
  PaGlobal_TotalReward._ui.btn_receiveAll = UI.getChildControl(PaGlobal_TotalReward._ui.stc_bottomGroup, "Button_ReceiveAll")
  PaGlobal_TotalReward._ui.stc_moneyArea = UI.getChildControl(PaGlobal_TotalReward._ui.stc_bottomGroup, "Static_MoneyArea")
  PaGlobal_TotalReward._ui.stctxt_moneyIcon = UI.getChildControl(PaGlobal_TotalReward._ui.stc_moneyArea, "StaticText_MoneyIcon")
  PaGlobal_TotalReward._ui.stc_rewardCntArea = UI.getChildControl(PaGlobal_TotalReward._ui.stc_bottomGroup, "Static_RewardCntArea")
  PaGlobal_TotalReward._ui.stctxt_rewardCnt = UI.getChildControl(PaGlobal_TotalReward._ui.stc_rewardCntArea, "StaticText_RewardCnt")
  PaGlobal_TotalReward._ui.frame_totalReward = UI.getChildControl(PaGlobal_TotalReward._ui.stc_contentGroup, "Frame_TotalReward")
  PaGlobal_TotalReward._ui.frame_totalReward_vscroll = UI.getChildControl(PaGlobal_TotalReward._ui.frame_totalReward, "Frame_1_VerticalScroll")
  PaGlobal_TotalReward._ui.frame_totalReward_vscroll_ctrl = UI.getChildControl(PaGlobal_TotalReward._ui.frame_totalReward_vscroll, "Frame_1_VerticalScroll_CtrlButton")
  PaGlobal_TotalReward._ui.frame_content = UI.getChildControl(PaGlobal_TotalReward._ui.frame_totalReward, "Frame_1_Content")
  PaGlobal_TotalReward._ui.stc_group = UI.getChildControl(PaGlobal_TotalReward._ui.frame_content, "Static_Group")
  PaGlobal_TotalReward._ui.stctxt_no_itemLog = UI.getChildControl(PaGlobal_TotalReward._ui.frame_content, "StaticText_No_Itemlog")
  PaGlobal_TotalReward._ui.stctxt_itemLog_widget_Log = UI.getChildControl(PaGlobal_TotalReward._ui.stc_itemLog_widget, "StaticText_ItemLog_Widget_NoLog")
  PaGlobal_TotalReward._ui.frame_itemLog = UI.getChildControl(PaGlobal_TotalReward._ui.stc_itemLog_widget, "Frame_ItemLog")
  PaGlobal_TotalReward._ui.frame_itemLog_vscroll = UI.getChildControl(PaGlobal_TotalReward._ui.frame_itemLog, "Frame_1_VerticalScroll")
  PaGlobal_TotalReward._ui.frame_itemLog_vscroll_ctrl = UI.getChildControl(PaGlobal_TotalReward._ui.frame_itemLog_vscroll, "Frame_1_VerticalScroll_CtrlButton")
  PaGlobal_TotalReward._ui.frame_itemLog_Content = UI.getChildControl(PaGlobal_TotalReward._ui.frame_itemLog, "Frame_1_Content")
  PaGlobal_TotalReward:registEventHandler()
  PaGlobal_TotalReward._ui.stctxt_no_itemLog:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_TotalReward._ui.stctxt_no_itemLog:SetText(PaGlobal_TotalReward._ui.stctxt_no_itemLog:GetText())
  PaGlobal_TotalReward:validate()
  PaGlobal_TotalReward._ui.stctxt_mouseR:SetPosX(Panel_Window_TotalReward:GetSizeX() - PaGlobal_TotalReward._ui.stctxt_mouseR:GetSizeX() - PaGlobal_TotalReward._ui.stctxt_mouseR:GetTextSizeX() - 40)
  PaGlobal_TotalReward._initialize = true
end
function PaGlobal_TotalReward:registEventHandler()
  if nil == Panel_Window_TotalReward then
    return
  end
  registerEvent("FromClient_PendingRewardUpdated", "FromClient_TotalReward_PendingRewardUpdated")
  registerEvent("FromClient_PendingRewardLogUpdated", "FromClient_TotalReward_PendingRewardLogUpdated")
  PaGlobal_TotalReward._ui.btn_receive:addInputEvent("Mouse_LUp", "HandleEventLUp_TotalReward_Silver()")
  PaGlobal_TotalReward._ui.btn_receiveAll:addInputEvent("Mouse_LUp", "HandleEventLUp_TotalReward_All()")
  PaGlobal_TotalReward._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_TotalReward_Close()")
  PaGlobal_TotalReward._ui.stctxt_itemLog:addInputEvent("Mouse_LUp", "HandleEventLUp_TotalReward_LogWidget_ToggleShow()")
end
function PaGlobal_TotalReward:itemWidget_ToggleShow(isOn)
  if true == isOn then
    PaGlobal_TotalReward._ui.stc_itemLog_widget:SetShow(true)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.stctxt_itemLog, 132, 220, 108, 244)
    PaGlobal_TotalReward._ui.stctxt_itemLog:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.stctxt_itemLog:setRenderTexture(PaGlobal_TotalReward._ui.stctxt_itemLog:getBaseTexture())
    local onX1, onY1, onX2, onY2 = setTextureUV_Func(PaGlobal_TotalReward._ui.stctxt_itemLog, 132, 195, 108, 219)
    PaGlobal_TotalReward._ui.stctxt_itemLog:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    PaGlobal_TotalReward._ui.stctxt_itemLog:setRenderTexture(PaGlobal_TotalReward._ui.stctxt_itemLog:getOnTexture())
  else
    PaGlobal_TotalReward._ui.stc_itemLog_widget:SetShow(false)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.stctxt_itemLog, 108, 220, 132, 244)
    PaGlobal_TotalReward._ui.stctxt_itemLog:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.stctxt_itemLog:setRenderTexture(PaGlobal_TotalReward._ui.stctxt_itemLog:getBaseTexture())
    local onX1, onY1, onX2, onY2 = setTextureUV_Func(PaGlobal_TotalReward._ui.stctxt_itemLog, 108, 195, 132, 219)
    PaGlobal_TotalReward._ui.stctxt_itemLog:getOnTexture():setUV(onX1, onY1, onX2, onY2)
    PaGlobal_TotalReward._ui.stctxt_itemLog:setRenderTexture(PaGlobal_TotalReward._ui.stctxt_itemLog:getOnTexture())
  end
end
function PaGlobal_TotalReward_Refresh_FromWeb()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  ToClient_LoadPendingRewardXXX()
end
function PaGlobal_TotalReward_Open()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  if Panel_Window_TotalReward:GetShow() then
    PaGlobal_TotalReward_Close()
  else
    PaGlobal_TotalReward:prepareOpen()
  end
end
function PaGlobal_TotalReward_Close()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  PaGlobal_TotalReward:resetSlot()
  PaGlobal_TotalReward:itemWidget_ToggleShow(true)
  PaGlobal_TotalReward:close()
end
function PaGlobal_TotalReward:prepareOpen()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  PaGlobal_TotalReward._ui.frame_totalReward:GetVScroll():SetControlTop()
  PaGlobal_TotalReward._ui.frame_itemLog:GetVScroll():SetControlTop()
  PaGlobal_TotalReward:update()
  warehouse_requestInfoByCurrentRegionMainTown()
  if Panel_Window_TotalReward:GetShow() then
    PaGlobal_TotalReward_Close()
  else
    PaGlobal_TotalReward:open()
  end
end
function PaGlobal_TotalReward:open()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  Panel_Window_TotalReward:SetShow(true)
end
function PaGlobal_TotalReward:prepareClose()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
end
function PaGlobal_TotalReward:close()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  Panel_Window_TotalReward:SetShow(false)
end
function PaGlobal_TotalReward:receiveItem(rewardKey, index, toWarehouse)
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  if nil == rewardKey or nil == index or nil == toWarehouse then
    return
  end
  if nil == PaGlobal_TotalReward.uiSlot[rewardKey] then
    return
  end
  local uiSlot = PaGlobal_TotalReward.uiSlot[rewardKey][index]
  if nil == uiSlot then
    return
  end
  if nil == PaGlobal_TotalReward.itemDatas[rewardKey] then
    return
  end
  local itemDatas = PaGlobal_TotalReward.itemDatas[rewardKey][index]
  if nil == itemDatas then
    return
  end
  local itemIdx = itemDatas.itemIndex
  if nil == itemIdx then
    return
  end
  local itemKey = ToClient_GetPendingRewardItemKeyByIndex(itemIdx)
  if nil == itemKey then
    return
  end
  ToClient_ReceivePendingReward(itemIdx, toWarehouse)
end
function PaGlobal_TotalReward:receiveSilver()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  if nil == PaGlobal_TotalReward.rewardSilver or toInt64(0, 0) == PaGlobal_TotalReward.rewardSilver then
    return
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CHECKBOX_SILVER_TITLE"),
    content = PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CHECKBOX_SILVER_DESC"),
    functionApply = PaGlobal_TotalReward_ConfirmReceiveSilver,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBoxCheck.showMessageBoxForRegion(messageBoxData)
end
function PaGlobal_TotalReward:receiveAll()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  if nil == PaGlobal_TotalReward.rewardSilver or toInt64(0, 0) == PaGlobal_TotalReward.rewardSilver then
    PaGlobal_TotalReward_ConfirmReceiveAll()
  else
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CHECKBOX_SILVER_TITLE"),
      content = PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CHECKBOX_SILVER_DESC"),
      functionApply = PaGlobal_TotalReward_ConfirmReceiveAll,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBoxForRegion(messageBoxData)
  end
end
function PaGlobal_TotalReward_ConfirmReceiveAll()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  local receiveTarget
  local receiveType = MessageBoxCheck.isCheck()
  if CppEnums.ItemWhereType.eInventory == receiveType then
    receiveTarget = false
  elseif CppEnums.ItemWhereType.eWarehouse == receiveType then
    receiveTarget = true
  end
  if nil == receiveType then
    return
  end
  ToClient_ReceivePendingRewardAll(receiveTarget)
  if nil ~= PaGlobal_TotalReward.rewardSilver and toInt64(0, 0) ~= PaGlobal_TotalReward.rewardSilver then
    audioPostEvent_SystemUi(3, 12)
  end
end
function PaGlobal_TotalReward_ConfirmReceiveSilver()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  local receiveTarget
  local receiveType = MessageBoxCheck.isCheck()
  if CppEnums.ItemWhereType.eInventory == receiveType then
    receiveTarget = false
  elseif CppEnums.ItemWhereType.eWarehouse == receiveType then
    receiveTarget = true
  end
  if nil == receiveType then
    return
  end
  if 0 < #PaGlobal_TotalReward.rewardSilverIndex then
    for ii = 1, #PaGlobal_TotalReward.rewardSilverIndex do
      local itemIdx = PaGlobal_TotalReward.rewardSilverIndex[ii]
      if nil ~= itemIdx then
        local itemKey = ToClient_GetPendingRewardItemKeyByIndex(itemIdx)
        if nil ~= itemKey and 1 == itemKey then
          ToClient_ReceivePendingReward(itemIdx, receiveType)
        end
      end
    end
    audioPostEvent_SystemUi(3, 12)
  end
end
function PaGlobal_TotalReward:resetSlot()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  local slotIndex = 1
  for rewardKey, slotDatas in pairs(PaGlobal_TotalReward.uiSlot) do
    if nil ~= slotDatas then
      for index, uiSlot in pairs(slotDatas) do
        if nil ~= uiSlot then
          Panel_Tooltip_Item_Show_GeneralStatic(slotIndex, "totalReward", false, false)
          uiSlot:clearItem()
          uiSlot.iconBg:SetShow(false)
          uiSlot.icon:addInputEvent("Mouse_RUp", "")
          uiSlot.icon:addInputEvent("Mouse_On", "")
          uiSlot.icon:addInputEvent("Mouse_Out", "")
          slotIndex = slotIndex + 1
        end
      end
    end
  end
end
function PaGlobal_TotalReward:dataSet()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  PaGlobal_TotalReward.itemDatas = {}
  PaGlobal_TotalReward.rewardSilver = toInt64(0, 0)
  PaGlobal_TotalReward.rewardSilverIndex = {}
  PaGlobal_TotalReward:resetSlot()
  local rewardCnt = ToClient_GetPendingRewardCount()
  PaGlobal_TotalReward._ui.stctxt_no_itemLog:SetShow(true)
  rewardCnt = Int64toInt32(rewardCnt)
  local itemCount = 0
  local silverFlag = false
  if rewardCnt > 0 then
    for ii = 1, rewardCnt do
      local rewardKey = ToClient_GetPendingRewardTypeByIndex(ii - 1)
      local itemKey = ToClient_GetPendingRewardItemKeyByIndex(ii - 1)
      local itemCnt = ToClient_GetPendingRewardItemCountByIndex(ii - 1)
      if nil ~= rewardKey and nil ~= itemKey and nil ~= itemCnt then
        if 1 ~= itemKey then
          itemCnt = Int64toInt32(itemCnt)
          if nil == PaGlobal_TotalReward.itemDatas[rewardKey] then
            PaGlobal_TotalReward.itemDatas[rewardKey] = {}
            if nil == PaGlobal_TotalReward.categoryGroups[rewardKey] then
              PaGlobal_TotalReward.categoryGroups[rewardKey] = {}
              local tempContent = UI.createAndCopyBasePropertyControl(PaGlobal_TotalReward._ui.frame_content, "Static_Group", PaGlobal_TotalReward._ui.frame_content, "TotalRewardGroup_" .. rewardKey)
              if nil ~= tempContent then
                local tempTitle = UI.createAndCopyBasePropertyControl(PaGlobal_TotalReward._ui.stc_group, "StaticText_GroupTitle", tempContent, "TotalRewardGroup_Title_" .. rewardKey)
                if nil ~= tempTitle then
                  PaGlobal_TotalReward.categoryGroups[rewardKey].content = tempContent
                  tempTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CATEGORY_" .. rewardKey))
                  PaGlobal_TotalReward.categoryGroups[rewardKey].title = tempTitle
                else
                  return
                end
              else
                return
              end
            end
          end
          PaGlobal_TotalReward.itemDatas[rewardKey][#PaGlobal_TotalReward.itemDatas[rewardKey] + 1] = {}
          PaGlobal_TotalReward.itemDatas[rewardKey][#PaGlobal_TotalReward.itemDatas[rewardKey]].itemIndex = ii - 1
          PaGlobal_TotalReward.itemDatas[rewardKey][#PaGlobal_TotalReward.itemDatas[rewardKey]].rewardKey = rewardKey
          PaGlobal_TotalReward.itemDatas[rewardKey][#PaGlobal_TotalReward.itemDatas[rewardKey]].itemKey = itemKey
          PaGlobal_TotalReward.itemDatas[rewardKey][#PaGlobal_TotalReward.itemDatas[rewardKey]].itemCnt = itemCnt
          itemCount = itemCount + 1
          PaGlobal_TotalReward._ui.stctxt_no_itemLog:SetShow(false)
        else
          PaGlobal_TotalReward.rewardSilver = PaGlobal_TotalReward.rewardSilver + itemCnt
          PaGlobal_TotalReward.rewardSilverIndex[#PaGlobal_TotalReward.rewardSilverIndex + 1] = ii - 1
          if false == silverFlag then
            itemCount = itemCount + 1
            silverFlag = true
          end
        end
      end
    end
    PaGlobal_TotalReward._ui.btn_receiveAll:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Common_00.dds")
    PaGlobal_TotalReward._ui.btn_receiveAll:SetFontColor(Defines.Color.C_FFFFFFFF)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.btn_receiveAll, 1, 22, 41, 62)
    PaGlobal_TotalReward._ui.btn_receiveAll:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.btn_receiveAll:setRenderTexture(PaGlobal_TotalReward._ui.btn_receiveAll:getBaseTexture())
    PaGlobal_TotalReward._ui.btn_receiveAll:SetIgnore(false)
  else
    PaGlobal_TotalReward._ui.btn_receiveAll:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Common_00.dds")
    PaGlobal_TotalReward._ui.btn_receiveAll:SetFontColor(Defines.Color.C_FF76747D)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.btn_receiveAll, 288, 63, 328, 103)
    PaGlobal_TotalReward._ui.btn_receiveAll:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.btn_receiveAll:setRenderTexture(PaGlobal_TotalReward._ui.btn_receiveAll:getBaseTexture())
    PaGlobal_TotalReward._ui.btn_receiveAll:SetIgnore(true)
    PaGlobal_TotalReward._ui.stctxt_no_itemLog:SetShow(true)
  end
  PaGlobal_TotalReward._ui.stctxt_rewardCnt:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TOTALREWARD_REWARDCOUNT", "count", itemCount))
  if 0 == PaGlobal_TotalReward.rewardSilver then
    PaGlobal_TotalReward._ui.btn_receive:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Common_00.dds")
    PaGlobal_TotalReward._ui.btn_receive:SetFontColor(Defines.Color.C_FF76747D)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.btn_receive, 288, 63, 328, 103)
    PaGlobal_TotalReward._ui.btn_receive:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.btn_receive:setRenderTexture(PaGlobal_TotalReward._ui.btn_receive:getBaseTexture())
    PaGlobal_TotalReward._ui.btn_receive:SetIgnore(true)
  else
    PaGlobal_TotalReward._ui.btn_receive:ChangeTextureInfoName("renewal/PcRemaster/Remaster_Common_00.dds")
    PaGlobal_TotalReward._ui.btn_receive:SetFontColor(Defines.Color.C_FFFFFFFF)
    local x1, y1, x2, y2 = setTextureUV_Func(PaGlobal_TotalReward._ui.btn_receive, 1, 22, 41, 62)
    PaGlobal_TotalReward._ui.btn_receive:getBaseTexture():setUV(x1, y1, x2, y2)
    PaGlobal_TotalReward._ui.btn_receive:setRenderTexture(PaGlobal_TotalReward._ui.btn_receive:getBaseTexture())
    PaGlobal_TotalReward._ui.btn_receive:SetIgnore(false)
  end
end
function PaGlobal_TotalReward:itemLogSet()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  for index, control in pairs(PaGlobal_TotalReward.itemLogControl) do
    if nil ~= control then
      control:SetShow(false)
    end
  end
  local logCount = ToClient_GetPendingRewardLogCount()
  if nil == logCount then
    return
  end
  local logTable = {}
  local beforeMonth = 0
  local beforeDay = 0
  logCount = Int64toInt32(logCount)
  if logCount > 0 then
    PaGlobal_TotalReward._ui.stctxt_itemLog_widget_Log:SetShow(false)
    for ii = 1, logCount do
      local logDate = ToClient_GetPendingRewardLogDateByIndex(ii - 1)
      local rewardKey = ToClient_GetPendingRewardLogTypeByIndex(ii - 1)
      local itemKey = ToClient_GetPendingRewardLogItemKeyByIndex(ii - 1)
      local itemCount = ToClient_GetPendingRewardLogItemCountByIndex(ii - 1)
      if nil == logDate or nil == rewardKey or nil == itemKey or nil == itemCount then
        return
      end
      local timeValue = PATime(logDate)
      if beforeMonth ~= tostring(timeValue:GetMonth()) or beforeDay ~= tostring(timeValue:GetDay()) then
        local timeStr = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TOTALREWARD_ITEMLOG_DATE", "month", tostring(timeValue:GetMonth()), "day", tostring(timeValue:GetDay()))
        logTable[#logTable + 1] = {}
        logTable[#logTable].text = timeStr
        logTable[#logTable].color = Defines.Color.C_FFFFFFFF
      end
      beforeMonth = tostring(timeValue:GetMonth())
      beforeDay = tostring(timeValue:GetDay())
      local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
      if nil == itemStatic then
        return
      end
      local itemNameColor = ""
      local nameColorGrade = itemStatic:getGradeType()
      if 0 == nameColorGrade then
        itemNameColor = "FFFFFFFF"
      elseif 1 == nameColorGrade then
        itemNameColor = "FF5DFF70"
      elseif 2 == nameColorGrade then
        itemNameColor = "FF4B97FF"
      elseif 3 == nameColorGrade then
        itemNameColor = "FFFFC832"
      elseif 4 == nameColorGrade then
        itemNameColor = "FFFF6C00"
      else
        itemNameColor = "FFFFFFFF"
      end
      local itemName = "<PAColor0x" .. itemNameColor .. ">[" .. itemStatic:getName() .. "]<PAOldColor>"
      local category = PAGetString(Defines.StringSheet_GAME, "LUA_TOTALREWARD_CATEGORY_" .. rewardKey)
      local logText = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_TOTALREWARD_ITEMLOG_TEXT", "itemName", itemName, "itemCount", makeDotMoney(itemCount), "category", category)
      logTable[#logTable + 1] = {}
      logTable[#logTable].text = logText
    end
    local nextPosY = 0
    for ii = 1, #logTable do
      if nil == logTable[ii] then
        return
      end
      local control = PaGlobal_TotalReward.itemLogControl[ii]
      if nil == control then
        control = UI.createAndCopyBasePropertyControl(PaGlobal_TotalReward._ui.frame_itemLog_Content, "StaticText_Base_ItemLog", PaGlobal_TotalReward._ui.frame_itemLog_Content, "TotalReward_ItemLog_" .. ii)
        if nil ~= control then
          control:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
          PaGlobal_TotalReward.itemLogControl[ii] = control
        end
      end
      if nil == control then
        return
      end
      control:SetShow(true)
      control:SetText(logTable[ii].text)
      control:SetPosY(nextPosY)
      control:SetSize(control:GetSizeX(), control:GetTextSizeY() + 2)
      if logTable[ii].color ~= nil then
        control:SetFontColor(logTable[ii].color)
        control:ChangeTextureInfoName("renewal/pcremaster/remaster_common_00.dds")
        control:setRenderTexture(control:getBaseTexture())
        nextPosY = nextPosY + 10
        control:SetPosY(nextPosY)
        nextPosY = nextPosY + 5
      else
        control:ChangeTextureInfoName("")
        control:setRenderTexture(control:getBaseTexture())
      end
      nextPosY = nextPosY + control:GetTextSizeY() + 5
      PaGlobal_TotalReward._ui.frame_itemLog_Content:SetSize(PaGlobal_TotalReward._ui.frame_itemLog:GetSizeX(), nextPosY)
    end
  else
    PaGlobal_TotalReward._ui.stctxt_itemLog_widget_Log:SetShow(true)
  end
  PaGlobal_TotalReward._ui.frame_itemLog:UpdateContentScroll()
  PaGlobal_TotalReward._ui.frame_itemLog:UpdateContentPos()
end
function PaGlobal_TotalReward:update()
  if nil == Panel_Window_TotalReward or false == PaGlobal_TotalReward._initialize then
    return
  end
  PaGlobal_TotalReward:dataSet()
  PaGlobal_TotalReward:itemLogSet()
  PaGlobal_TotalReward._ui.stctxt_moneyIcon:SetText(0)
  if toInt64(0, 0) < PaGlobal_TotalReward.rewardSilver then
    PaGlobal_TotalReward._ui.stctxt_moneyIcon:SetText(makeDotMoney(PaGlobal_TotalReward.rewardSilver))
  end
  local slotIndex = 1
  for index, value in pairs(PaGlobal_TotalReward.categoryGroups) do
    if nil == value or nil == value.content or nil == value.title then
      return
    end
    value.content:SetShow(false)
  end
  local nextPosY = 0
  for rewardKey, rewardDatas in pairs(PaGlobal_TotalReward.itemDatas) do
    PaGlobal_TotalReward.categoryGroups[rewardKey].content:SetShow(true)
    for index, itemDatas in pairs(rewardDatas) do
      if nil ~= itemDatas then
        if nil == PaGlobal_TotalReward.uiSlot[rewardKey] then
          PaGlobal_TotalReward.uiSlot[rewardKey] = {}
        end
        local uiSlot = PaGlobal_TotalReward.uiSlot[rewardKey][index]
        local row = math.floor((index - 1) / PaGlobal_TotalReward._COL_SLOT_COUNT)
        local col = (index - 1) % PaGlobal_TotalReward._COL_SLOT_COUNT
        PaGlobal_TotalReward.categoryGroups[rewardKey].content:SetSize(PaGlobal_TotalReward.categoryGroups[rewardKey].content:GetSizeX(), 100 + 56 * row)
        if nil == uiSlot then
          PaGlobal_TotalReward.uiSlot[rewardKey][index] = {}
          if nil == PaGlobal_TotalReward.categoryGroups[rewardKey].content then
            return
          end
          local itemSlotBg = UI.createAndCopyBasePropertyControl(PaGlobal_TotalReward._ui.stc_group, "Static_ItemSlotBg", PaGlobal_TotalReward.categoryGroups[rewardKey].content, "TotalReward_SlotBG_" .. rewardKey .. "_" .. index)
          local slot = {}
          SlotItem.new(slot, "TotalReward_Slot_" .. rewardKey .. "_" .. index, index, itemSlotBg, PaGlobal_TotalReward._slotConfig)
          slot:createChild()
          slot.iconBg = itemSlotBg
          itemSlotBg:SetPosX(15 + 56 * col)
          itemSlotBg:SetPosY(45 + 56 * row)
          itemSlotBg:SetShow(true)
          itemSlotBg:SetIgnore(true)
          PaGlobal_TotalReward.uiSlot[rewardKey][index] = slot
          uiSlot = slot
          slot.icon:SetAutoDisableTime(0.5)
        end
        local rewardKey = itemDatas.rewardKey
        local itemKey = itemDatas.itemKey
        local itemCnt = itemDatas.itemCnt
        if nil ~= rewardKey and nil ~= itemKey and nil ~= itemCnt then
          local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
          if nil ~= itemStatic and 1 ~= itemKey then
            uiSlot.iconBg:SetShow(true)
            uiSlot:setItemByStaticStatus(itemStatic, itemCnt)
            uiSlot.count:SetText(tostring(itemCnt))
            uiSlot.count:SetShow(true)
            uiSlot._item = itemKey
            Panel_Tooltip_Item_SetPosition(slotIndex, uiSlot, "totalReward")
            uiSlot.icon:addInputEvent("Mouse_RUp", "HandleEventRUp_TotalReward_Slot(" .. rewardKey .. "," .. index .. ")")
            uiSlot.icon:addInputEvent("Mouse_On", "HandleEventOn_TotalReward_Slot(" .. rewardKey .. "," .. index .. "," .. slotIndex .. ", true)")
            uiSlot.icon:addInputEvent("Mouse_Out", "HandleEventOn_TotalReward_Slot(" .. rewardKey .. "," .. index .. "," .. slotIndex .. ", false)")
            slotIndex = slotIndex + 1
          end
        end
      end
    end
    PaGlobal_TotalReward.categoryGroups[rewardKey].content:SetPosY(nextPosY)
    nextPosY = nextPosY + PaGlobal_TotalReward.categoryGroups[rewardKey].content:GetSizeY()
    PaGlobal_TotalReward._ui.frame_content:SetSize(PaGlobal_TotalReward._ui.frame_content:GetSizeX(), nextPosY)
  end
  local tempSizeY = PaGlobal_TotalReward._ui.frame_totalReward_vscroll:GetSizeY() * (PaGlobal_TotalReward._CONTENT_FRAME_SIZE_Y / nextPosY)
  PaGlobal_TotalReward._ui.frame_totalReward_vscroll_ctrl:SetSize(PaGlobal_TotalReward._ui.frame_totalReward_vscroll_ctrl:GetSizeX(), tempSizeY)
  PaGlobal_TotalReward._ui.frame_totalReward:UpdateContentScroll()
  PaGlobal_TotalReward._ui.frame_totalReward:UpdateContentPos()
end
function PaGlobal_TotalReward:validate()
  if nil == Panel_Window_TotalReward then
    return
  end
  PaGlobal_TotalReward._ui.stctxt_mouseR:isValidate()
  PaGlobal_TotalReward._ui.stctxt_itemLog:isValidate()
  PaGlobal_TotalReward._ui.btn_close:isValidate()
  PaGlobal_TotalReward._ui.btn_receive:isValidate()
  PaGlobal_TotalReward._ui.btn_receiveAll:isValidate()
  PaGlobal_TotalReward._ui.stc_moneyArea:isValidate()
  PaGlobal_TotalReward._ui.stctxt_moneyIcon:isValidate()
  PaGlobal_TotalReward._ui.stc_rewardCntArea:isValidate()
  PaGlobal_TotalReward._ui.stctxt_rewardCnt:isValidate()
  PaGlobal_TotalReward._ui.frame_totalReward:isValidate()
  PaGlobal_TotalReward._ui.frame_totalReward_vscroll:isValidate()
  PaGlobal_TotalReward._ui.frame_totalReward_vscroll_ctrl:isValidate()
  PaGlobal_TotalReward._ui.frame_content:isValidate()
  PaGlobal_TotalReward._ui.stc_group:isValidate()
  PaGlobal_TotalReward._ui.stctxt_no_itemLog:isValidate()
  PaGlobal_TotalReward._ui.stctxt_itemLog_widget_Log:isValidate()
  PaGlobal_TotalReward._ui.frame_itemLog:isValidate()
  PaGlobal_TotalReward._ui.frame_itemLog_vscroll:isValidate()
  PaGlobal_TotalReward._ui.frame_itemLog_vscroll_ctrl:isValidate()
  PaGlobal_TotalReward._ui.frame_itemLog_Content:isValidate()
end
