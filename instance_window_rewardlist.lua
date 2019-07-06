local _panel = Instance_Window_RewardList
local REWARD_STATE = {
  ENABLE = 1,
  RECIEVED = 2,
  DISABLE = 3,
  NEED_BUF = 4,
  NO_THERE = 5
}
local battleRoyaleRewardList = {
  _ui = {
    stc_topGroup = UI.getChildControl(_panel, "Static_TopGroup"),
    stc_tabGroup = UI.getChildControl(_panel, "Static_TabGroup"),
    stc_centerGroup = UI.getChildControl(_panel, "Static_CenterGroup"),
    stc_tableTitleGroup = UI.getChildControl(_panel, "Static_TableTitle_Group"),
    list_Reward = UI.getChildControl(_panel, "List2_Reward"),
    frame_tierReward = UI.getChildControl(_panel, "Frame_TierReward")
  },
  _string = {
    state = {
      [REWARD_STATE.ENABLE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_BTN_RECEIVE"),
      [REWARD_STATE.DISABLE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_DISABLE"),
      [REWARD_STATE.RECIEVED] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_RECEIVED"),
      [REWARD_STATE.NEED_BUF] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_DISABLE_NEEDBUFF"),
      [REWARD_STATE.NO_THERE] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_ENABLE_NOTHERE")
    },
    reward_title = {},
    reward_desc = {},
    reward_complete_desc = {}
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _listInfo = {},
  _radioTabGroup = {},
  _tierRewardContentGroup = {},
  _tierRewardContent = {},
  _tierRewardSlots = {},
  _rewardCount = 0,
  _rewardDataTable = {},
  _isKamasilveCharge = true,
  _selectedIndex = 1,
  _initialize = false
}
function battleRoyaleRewardList:rewardData_Create(basicItemKey, boostItemKey)
  local data = {}
  data._rankTable = {}
  data._iconSlot = {}
  data._basicItemKey = basicItemKey
  data._boostItemKey = boostItemKey
  return data
end
function battleRoyaleRewardList:rewardData_Add(data, rank)
  for i = 1, table.getn(data._rankTable) do
    if data._rankTable[i] == rank then
      return false
    end
  end
  table.insert(data._rankTable, rank)
  table.sort(data._rankTable)
  return true
end
function battleRoyaleRewardList:rewardData_rankString(rewardData, isTitle, isDesc)
  local rankCount = table.getn(rewardData._rankTable)
  local upRank = rewardData._rankTable[1]
  local downRank = rewardData._rankTable[rankCount]
  local rewardTitle, rewardDesc = "", ""
  if true == isTitle then
    if 1 == rankCount then
      rewardTitle = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDTITLE_1", "rank", upRank)
    else
      rewardTitle = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDTITLE_2", "uprank", upRank, "downrank", downRank)
    end
  end
  if true == isDesc then
    if 1 == rankCount then
      rewardDesc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDDESC_1", "rank", upRank)
    else
      rewardDesc = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDDESC_2", "uprank", upRank, "downrank", downRank)
    end
  end
  return rewardTitle, rewardDesc
end
function battleRoyaleRewardList:init()
  _panel:ComputePos()
  self._ui.txt_MainDesc = UI.getChildControl(self._ui.stc_centerGroup, "StaticText_RewardDesc")
  self._ui.txt_MainDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_MainDesc:SetText(self._ui.txt_MainDesc:GetText())
  self._ui.radiobtn_tab_tierReward = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_TierReward")
  self._ui.radiobtn_tab_normalReward = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_NormalReward")
  self._radioTabGroup[1] = self._ui.radiobtn_tab_tierReward
  self._radioTabGroup[2] = self._ui.radiobtn_tab_normalReward
  self._ui.stc_centerIconBg = UI.getChildControl(self._ui.stc_centerGroup, "StaticText_Icon_Bg")
  self._ui.stc_centerIcon = UI.getChildControl(self._ui.stc_centerIconBg, "StaticText_Icon")
  self._ui.stc_centerIcon:SetMonoTone(true)
  self._ui.frame_tierReward_content = UI.getChildControl(self._ui.frame_tierReward, "Frame_1_Content")
  self._ui.stc_tierContent_group = UI.getChildControl(self._ui.frame_tierReward_content, "Static_TierContent_Group")
  self._ui.stc_tierContent = UI.getChildControl(self._ui.stc_tierContent_group, "Static_TierContent")
  self._ui.stc_tierItemSlotBg = UI.getChildControl(self._ui.stc_tierContent, "Static_ItemSlotBg")
  self._ui.stc_tierItemSlot = UI.getChildControl(self._ui.stc_tierItemSlotBg, "Static_ItemSlot")
  self._ui.list_Content = UI.getChildControl(self._ui.list_Reward, "List2_1_Content")
  self._ui.stc_BasicBG_On = UI.getChildControl(self._ui.list_Content, "Static_BasicRewardBg_On")
  self._ui.stc_BasicBG_Off = UI.getChildControl(self._ui.list_Content, "Static_BasicRewardBg_Off")
  self._ui.stc_SelcBG_On = UI.getChildControl(self._ui.list_Content, "Static_SelectRewardBg_On")
  self._ui.stc_SelcBG_Off = UI.getChildControl(self._ui.list_Content, "Static_SelectRewardBg_Off")
  self._ui.stc_BasicIconBG = UI.getChildControl(self._ui.list_Content, "Static_IconBg")
  self._ui.stc_SelcIconBG = UI.getChildControl(self._ui.list_Content, "Static_SelectIconBg")
  self._ui.btn_close = UI.getChildControl(self._ui.stc_topGroup, "Button_Close")
  self._ui.txt_DestTitle = UI.getChildControl(self._ui.list_Content, "StaticText_RankTitle")
  self._ui.txt_Desc = UI.getChildControl(self._ui.list_Content, "StaticText_RankDesc")
  for i = 1, 5 do
    self._string.reward_title[i] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDTITLE_" .. i)
    self._string.reward_desc[i] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_REWARDDESC_" .. i)
    self._string.reward_complete_desc[i] = PAGetString(Defines.StringSheet_GAME, "LUA_BATTLEROYAL_REWARDLIST_COMPLETE_REWARDDESC_" .. i)
  end
  local applyStarter = getSelfPlayer():get():isApplyChargeSkill(CppEnums.UserChargeType.eUserChargeType_StarterPackage)
  local russiaKamasilv = getSelfPlayer():get():getUserChargeTime(CppEnums.UserChargeType.eUserChargeType_Kamasilve)
  if true == applyStarter or true == russiaKamasilv then
    self._isKamasilveCharge = true
  end
  if true == self:isInstanceLobbyMode() then
    self._ui.txt_MainDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_BOOSTDESC") .. [[


]] .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_DESC_NOTHERE"))
  end
  self:setTierRewardInfo()
  self:setupRewardData()
  self:registEventHandler()
  local listManager = self._ui.list_Reward:getElementManager()
  if nil ~= listManager then
    listManager:clearKey()
    for i = 1, table.getn(self._rewardDataTable) do
      listManager:pushKey(toInt64(0, i))
    end
  end
  self._initialize = true
  self:update()
end
function battleRoyaleRewardList:setTierRewardInfo()
  if true == self._initialize then
    return
  end
  local tierCnt = ToClient_BattleRoyaleTierCount()
  if nil == tierCnt or 0 == tierCnt then
    return
  end
  local tierContentGroupNextPosY = 10
  local tierContentNextPosX = 170
  for ii = 1, tierCnt do
    local groupKey = math.ceil(ii / 5)
    if nil == self._tierRewardContentGroup[groupKey] then
      local tierGroupWrapper = ToClient_GetBattleRoyaleTierByIndex(5 * (groupKey - 1))
      local tierContentGroup = UI.createAndCopyBasePropertyControl(self._ui.frame_tierReward_content, "Static_TierContent_Group", self._ui.frame_tierReward_content, "Static_TierContent_Group_" .. groupKey)
      local tierContentTitle = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent_group, "StaticText_TierGroupTitle", tierContentGroup, "StaticText_TierGroupTitle_" .. groupKey)
      local tierContentTitleBg = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent_group, "StaticText_TierGroupTitle_Bg", tierContentGroup, "StaticText_TierGroupTitleBg_" .. groupKey)
      local tierTierGroupIcon = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent_group, "Static_TierGroupIcon", tierContentGroup, "Static_TierGroupIcon_" .. groupKey)
      local iconPath = tierGroupWrapper:getIconPath()
      tierTierGroupIcon:ChangeTextureInfoName(iconPath)
      tierTierGroupIcon:setRenderTexture(tierTierGroupIcon:getBaseTexture())
      tierContentTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTANCE_REWARDLIST_TIERREWARD_GROUPTITLE_" .. groupKey))
      tierContentGroup:SetPosY(tierContentGroupNextPosY)
      tierContentGroupNextPosY = tierContentGroupNextPosY + tierContentGroup:GetSizeY() + 10
      self._tierRewardContentGroup[groupKey] = {}
      self._tierRewardContentGroup[groupKey].tierContentGroup = tierContentGroup
      self._tierRewardContentGroup[groupKey].tierContentTitle = tierContentTitle
      self._tierRewardContentGroup[groupKey].tierTierGroupIcon = tierTierGroupIcon
      self._tierRewardContentGroup[groupKey].tierContent = tierContent
      tierContentNextPosX = 170
    end
    local tierWrapper = ToClient_GetBattleRoyaleTierByIndex(5 * groupKey - (ii - 5 * (groupKey - 1)))
    if nil ~= tierWrapper then
      local tierContentGroup = self._tierRewardContentGroup[groupKey].tierContentGroup
      local tierContent = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent_group, "Static_TierContent", tierContentGroup, "Static_TierContent_" .. ii)
      local tierItemSlotBg = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent, "Static_ItemSlotBg", tierContent, "Static_ItemSlotBg_" .. ii)
      local tierName = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent, "StaticText_TierName", tierContent, "StaticText_TierName_" .. ii)
      local tierScore = UI.createAndCopyBasePropertyControl(self._ui.stc_tierContent, "StaticText_TierScore", tierContent, "StaticText_TierScore_" .. ii)
      self._tierRewardContent[ii] = {}
      self._tierRewardContent[ii].tierContent = tierContent
      self._tierRewardContent[ii].tierItemSlotBg = tierItemSlotBg
      self._tierRewardContent[ii].tierName = tierName
      self._tierRewardContent[ii].tierScore = tierScore
      tierName:SetText(tierWrapper:getTitle())
      tierScore:SetText(makeDotMoney(tierWrapper:getRankScore()))
      tierScore:SetPosX((tierContent:GetSizeX() - (tierScore:GetSizeX() + tierScore:GetTextSizeX())) / 2 - 8)
      local rewardCnt = tierWrapper:getRewardCount()
      tierContent:SetShow(false)
      if nil ~= rewardCnt and rewardCnt > 0 then
        local rewardInfo = tierWrapper:getRewardAt(0)
        if nil ~= rewardInfo then
          tierContent:SetShow(true)
          local slotIcon = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlotBg, "Static_ItemSlot", tierItemSlotBg, "Static_ItemSlot")
          local slotBorder = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlot, "Static_ItemSlot_Border", slotIcon, "Static_ItemSlot_Border")
          local slotEnchant = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlot, "StaticText_ItemSlot_Enchant", slotIcon, "StaticText_ItemSlot_Enchant")
          local slotCount = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlot, "StaticText_ItemSlot_Count", slotIcon, "StaticText_ItemSlot_Count")
          local slotCash = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlot, "Static_ItemSlot_isCash", slotIcon, "Static_ItemSlot_isCash")
          local slotEndurance = UI.createAndCopyBasePropertyControl(self._ui.stc_tierItemSlot, "Static_ItemSlot_enduranceIcon", slotIcon, "Static_ItemSlot_enduranceIcon")
          local slot = {}
          SlotItem.reInclude(slot, "ItemSlot", ii, tierItemSlotBg, self._slotConfig)
          slot.empty = tierItemSlotBg
          local slotOption = {}
          slotOption._type = rewardInfo:getType()
          if __eRewardExp == rewardInfo:getType() then
            slotOption._exp = rewardInfo:getExperience()
          elseif __eRewardSkillExp == rewardInfo:getType() then
            slotOption._exp = rewardInfo:getSkillExperience()
          elseif __eRewardLifeExp == rewardInfo:getType() then
            slotOption._exp = rewardInfo:getProductExperience()
          elseif __eRewardItem == rewardInfo:getType() then
            slotOption._item = rewardInfo:getItemEnchantKey()
            slotOption._count = rewardInfo:getItemCount()
          elseif __eRewardIntimacy == rewardInfo:getType() then
            slotOption._character = rewardInfo:getIntimacyCharacter()
            slotOption._value = rewardInfo:getIntimacyValue()
          end
          if __eRewardExp == slotOption._type then
            slot.count:SetText("")
            slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
          elseif __eRewardSkillExp == slotOption._type then
            slot.count:SetText("")
            slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
          elseif __eRewardLifeExp == slotOption._type then
            slot.count:SetText("")
            slot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
          elseif __eRewardItem == slotOption._type then
            local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(slotOption._item))
            if nil ~= itemStatic then
              slot:setItemByStaticStatus(itemStatic, slotOption._count)
              slot._item = slotOption._item
            end
            slot.icon:addInputEvent("Mouse_On", "HandleEventOn_TierReward_Slot(" .. ii .. ", true)")
            slot.icon:addInputEvent("Mouse_Out", "HandleEventOn_TierReward_Slot(" .. ii .. ", false)")
          elseif __eRewardIntimacy == slotOption._type then
            slot.count:SetText(tostring(slotOption._value))
            slot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
          else
            slot.icon:addInputEvent("Mouse_On", "")
            slot.icon:addInputEvent("Mouse_Out", "")
          end
          self._tierRewardSlots[ii] = {}
          self._tierRewardSlots[ii] = slot
          Panel_Tooltip_Item_SetPosition(ii, slot, "tierReward")
          tierContent:SetPosX(tierContentNextPosX)
          tierContentNextPosX = tierContentNextPosX + tierContent:GetSizeX() + 7
        end
      end
    end
  end
  self._ui.frame_tierReward:GetVScroll():SetControlTop()
  self._ui.frame_tierReward:UpdateContentScroll()
  self._ui.frame_tierReward:UpdateContentPos()
end
function HandleEventOn_TierReward_Slot(slotIndex, isOn)
  if nil == slotIndex or nil == isOn then
    return
  end
  local self = battleRoyaleRewardList
  if nil == self._tierRewardSlots[slotIndex] or nil == self._tierRewardContent[slotIndex] then
    return
  end
  Panel_Tooltip_Item_Show_GeneralStatic(slotIndex, "tierReward", isOn, false)
end
function battleRoyaleRewardList:update()
  if nil == self._selectedIndex then
    self._selectedIndex = 1
  end
  for ii = 1, #self._radioTabGroup do
    self._radioTabGroup[ii]:SetCheck(false)
    self._radioTabGroup[ii]:SetFontColor(Defines.Color.C_FF9397A7)
  end
  self._radioTabGroup[self._selectedIndex]:SetCheck(true)
  self._radioTabGroup[self._selectedIndex]:SetFontColor(Defines.Color.C_FFFFFFFF)
  if 1 == self._selectedIndex then
    self._ui.txt_MainDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INSTANCE_REWARDLIST_TIERREWARD_DESC"))
    self._ui.stc_tableTitleGroup:SetShow(false)
    self._ui.list_Reward:SetShow(false)
    self._ui.frame_tierReward:SetShow(true)
  else
    if true == self:isInstanceLobbyMode() then
      self._ui.txt_MainDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_BOOSTDESC") .. [[


]] .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_DESC_NOTHERE"))
    else
      self._ui.txt_MainDesc:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_BOOSTDESC"))
    end
    self._ui.stc_tableTitleGroup:SetShow(true)
    self._ui.list_Reward:SetShow(true)
    self._ui.frame_tierReward:SetShow(false)
    local moneyRewardInfoIndex = self:getRewardInfoIndex(2, __eTItemMoneyKey)
    local moneyCount = 0
    if moneyRewardInfoIndex >= 0 then
      moneyCount = ToClient_GetInstanceContentRewardItemCountByIndex(moneyRewardInfoIndex)
    end
    for index = 1, table.getn(self._rewardDataTable) do
      self._ui.list_Reward:requestUpdateByKey(toInt64(0, index))
    end
  end
end
function battleRoyaleRewardList:setupRewardData()
  local count = Int64toInt32(ToClient_GetBattleRoyaleRewardCount())
  for i = 0, count - 1 do
    local rank = ToClient_GetBattleRoyaleRewardRankByIndex(i)
    local basicItemKey = ToClient_GetBattleRoyaleRewardBasicItemKey(i)
    local boostItemKey = ToClient_GetBattleRoyaleRewardBoostItemKey(i)
    local data = self:getRewardData(basicItemKey, boostItemKey)
    if nil == data then
      data = self:rewardData_Create(basicItemKey, boostItemKey)
      table.insert(self._rewardDataTable, data)
    end
    self:rewardData_Add(data, rank)
  end
  local sortFunc = function(a, b)
    return a._rankTable[1] < b._rankTable[1]
  end
  table.sort(self._rewardDataTable, sortFunc)
end
function battleRoyaleRewardList:getRewardData(basicItemKey, boostItemKey)
  for i = 1, table.getn(self._rewardDataTable) do
    local data = self._rewardDataTable[i]
    if data._basicItemKey == basicItemKey and data._boostItemKey == boostItemKey then
      return data
    end
  end
end
function PaGlobal_RewardList_SelectTab(index)
  if nil == index then
    index = 1
  end
  local self = battleRoyaleRewardList
  self._selectedIndex = index
  self:update()
end
function battleRoyaleRewardList:registEventHandler()
  self._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobal_RewardList_Close()")
  self._radioTabGroup[1] = self._ui.radiobtn_tab_tierReward
  self._radioTabGroup[2] = self._ui.radiobtn_tab_normalReward
  for ii = 1, #self._radioTabGroup do
    self._radioTabGroup[ii]:addInputEvent("Mouse_LUp", "PaGlobal_RewardList_SelectTab(" .. ii .. ")")
  end
  self._ui.list_Reward:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_RewardList_CreateListContent")
  self._ui.list_Reward:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  registerEvent("FromClient_InstanceContentRewardUpdated", "FromClient_RewardList_InstanceContentRewardUpdated")
end
function battleRoyaleRewardList:getRewardInfoIndex(type, itemKey)
  for i = 0, Int64toInt32(ToClient_GetInstanceContentRewardCount()) - 1 do
    if type == ToClient_GetInstanceContentRewardTypeByIndex(i) and itemKey == ToClient_GetInstanceContentRewardItemKeyByIndex(i) and Defines.s64_const.s64_0 < ToClient_GetInstanceContentRewardItemCountByIndex(i) then
      return i
    end
  end
  return -1
end
function battleRoyaleRewardList:receive(type, itemKey)
  local rewardInfoIndex = self:getRewardInfoIndex(type, itemKey)
  if rewardInfoIndex < 0 then
    return
  end
  if itemKey == __eTItemMoneyKey then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_CHECKBOX_TITLE"),
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_CHECKBOX_DESC"),
      functionApply = PaGlobal_RewardList_MoneyRecieve,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  else
    ToClient_ReceiveInstanceContentReward(rewardInfoIndex, false)
  end
  self:update()
end
function battleRoyaleRewardList:receiveMoney()
  local receiveType = MessageBoxCheck.isCheck()
  local rewardInfoIndex = self:getRewardInfoIndex(2, __eTItemMoneyKey)
  if CppEnums.ItemWhereType.eInventory == receiveType then
    ToClient_ReceiveInstanceContentReward(rewardInfoIndex, false)
  elseif CppEnums.ItemWhereType.eWarehouse == receiveType then
    ToClient_ReceiveInstanceContentReward(rewardInfoIndex, true)
  end
end
function battleRoyaleRewardList:receiveAll()
  if 0 ~= ToClient_GetInstanceContentRewardItemCountByIndex(0) then
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_CHECKBOX_TITLE"),
      content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTANCE_REWARDLIST_CHECKBOX_DESC"),
      functionApply = PaGlobal_RewardList_AllRecieve,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBoxCheck.showMessageBox(messageBoxData)
  else
    ToClient_ReceiveInstanceContentRewardAll(false)
  end
  self:update()
end
function battleRoyaleRewardList:open()
  self:init()
  self:update()
  _panel:SetShow(true)
end
function battleRoyaleRewardList:close()
  for index, uiSlot in pairs(self._tierRewardSlots) do
    if nil ~= uiSlot then
      Panel_Tooltip_Item_Show_GeneralStatic(index, "tierReward", false, false)
    end
  end
  _panel:SetShow(false)
end
function battleRoyaleRewardList:createListContent(content, index)
  local index = Int64toInt32(index)
  local slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createCash = false,
    createEnchant = true
  }
  local stc_BasicBG_On = UI.getChildControl(content, "Static_BasicRewardBg_On")
  local stc_BasicBG_Off = UI.getChildControl(content, "Static_BasicRewardBg_Off")
  local stc_SelcBG_On = UI.getChildControl(content, "Static_SelectRewardBg_On")
  local stc_SelcBG_Off = UI.getChildControl(content, "Static_SelectRewardBg_Off")
  local stc_BasicIconBG = UI.getChildControl(content, "Static_IconBg")
  local stc_SelcIconBG = UI.getChildControl(content, "Static_SelectIconBg")
  local txt_RankTitle = UI.getChildControl(content, "StaticText_RankTitle")
  local txt_RankDesc = UI.getChildControl(content, "StaticText_RankDesc")
  local rewardData = self._rewardDataTable[index]
  local rewardString = self._string
  local basicSlot = {}
  local SelcSlot = {}
  local rewardTitle, rewardDesc = self:rewardData_rankString(rewardData, true, true)
  txt_RankTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_RankDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  txt_RankTitle:SetText(rewardTitle)
  txt_RankDesc:SetText(rewardDesc)
  SlotItem.reInclude(basicSlot, "ItemSlot", 0, stc_BasicIconBG, slotConfig)
  SlotItem.reInclude(SelcSlot, "ItemSlot", 1, stc_SelcIconBG, slotConfig)
  basicSlot.icon:SetShow(true)
  SelcSlot.icon:SetShow(true)
  rewardData._iconSlot[1] = basicSlot
  rewardData._iconSlot[2] = SelcSlot
  local basicRewardInfoIndex = self:getRewardInfoIndex(__eInstanceContentsType_BattleRoyale, rewardData._basicItemKey)
  local boostRewardInfoIndex = self:getRewardInfoIndex(__eInstanceContentsType_BattleRoyale, rewardData._boostItemKey)
  local basicRewardInfo = 0
  local boostRewardInfo = 0
  if basicRewardInfoIndex >= 0 then
    basicRewardInfo = ToClient_GetInstanceContentRewardItemCountByIndex(basicRewardInfoIndex)
    stc_BasicBG_On:SetShow(true)
    stc_BasicBG_Off:SetShow(false)
    basicSlot.icon:SetMonoTone(false)
  else
    basicRewardInfo = 0
    stc_BasicBG_On:SetShow(false)
    stc_BasicBG_Off:SetShow(true)
    basicSlot.icon:SetMonoTone(true)
  end
  if boostRewardInfoIndex >= 0 then
    boostRewardInfo = ToClient_GetInstanceContentRewardItemCountByIndex(boostRewardInfoIndex)
    stc_SelcBG_On:SetShow(true)
    stc_SelcBG_Off:SetShow(false)
    SelcSlot.icon:SetMonoTone(false)
  else
    boostRewardInfo = 0
    stc_SelcBG_On:SetShow(false)
    stc_SelcBG_Off:SetShow(true)
    SelcSlot.icon:SetMonoTone(true)
  end
  local basicItemStatic = getItemEnchantStaticStatus(ItemEnchantKey(rewardData._basicItemKey))
  rewardData._iconSlot[1].icon:addInputEvent("Mouse_On", "PaGlobal_RewardList_ToolTip( true ," .. index .. ", 1)")
  rewardData._iconSlot[1].icon:addInputEvent("Mouse_Out", "PaGlobal_RewardList_ToolTip( false )")
  rewardData._iconSlot[1]:setItemByStaticStatus(basicItemStatic, basicRewardInfo)
  local boostItemStatic = getItemEnchantStaticStatus(ItemEnchantKey(rewardData._boostItemKey))
  rewardData._iconSlot[2].icon:addInputEvent("Mouse_On", "PaGlobal_RewardList_ToolTip( true," .. index .. ", 2)")
  rewardData._iconSlot[2].icon:addInputEvent("Mouse_Out", "PaGlobal_RewardList_ToolTip( false )")
  rewardData._iconSlot[2]:setItemByStaticStatus(boostItemStatic, boostRewardInfo)
  if 0 ~= basicRewardInfo or 0 ~= boostRewardInfo then
    txt_RankDesc:SetText(rewardString.reward_complete_desc[index])
  end
end
function battleRoyaleRewardList:isInstanceLobbyMode()
  if _panel == Instance_Window_RewardList then
    return true
  else
    return false
  end
end
function PaGlobal_RewardList_ButtonDisable(control)
  control:SetIgnore(true)
  control:SetMonoTone(true)
  control:SetColor(Defines.Color.C_FF9397A7)
  control:SetFontColor(Defines.Color.C_FF6B6B6B)
end
function PaGlobal_RewardList_ButtonEnable(control)
  control:SetIgnore(false)
  control:SetMonoTone(false)
  control:SetColor(Defines.Color.C_FFFFFFFF)
  control:SetText(control:GetText())
  control:SetFontColor(Defines.Color.C_FFFFFFFF)
end
function PaGlobal_RewardList_ToolTip(isShow, index, subindex)
  if true == isShow then
    local self = battleRoyaleRewardList
    local rewardData = self._rewardDataTable[index]
    local itemSSW
    if 1 == subindex then
      itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(rewardData._basicItemKey))
    else
      itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(rewardData._boostItemKey))
    end
    Panel_Tooltip_Item_Show(itemSSW, rewardData._iconSlot[subindex].icon, true)
  elseif false == isShow then
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_RewardList_BoostButtonTooltip()
  local self = battleRoyaleRewardList
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDLIST_KAMASILVETOOLTIP_TITLE")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_REWARDLIST_KAMASILVETOOLTIP_DESC")
  local control = self._ui.btn_close
  TooltipSimple_Show(control, name, desc)
end
function PaGlobal_RewardList_CreateListContent(content, key)
  return battleRoyaleRewardList:createListContent(content, key)
end
function FromClient_RewardList_InstanceContentRewardUpdated()
  return battleRoyaleRewardList:update()
end
function PaGlobal_RewardList_Receive(type, itemKey)
  return battleRoyaleRewardList:receive(type, itemKey)
end
function PaGlobal_RewardList_ReceiveAll()
  return battleRoyaleRewardList:receiveAll()
end
function PaGlobal_RewardList_Open()
  if true == _panel:GetShow() then
    return battleRoyaleRewardList:close()
  else
    return battleRoyaleRewardList:open()
  end
end
function PaGlobal_RewardList_Close()
  return battleRoyaleRewardList:close()
end
function PaGlobal_RewardList_Init()
  return battleRoyaleRewardList:init()
end
function PaGlobal_RewardList_MoneyRecieve()
  battleRoyaleRewardList:receiveMoney()
end
function PaGlobal_RewardList_AllRecieve()
  local receiveType = MessageBoxCheck.isCheck()
  if CppEnums.ItemWhereType.eInventory == receiveType then
    ToClient_ReceiveInstanceContentRewardAll(false)
  elseif CppEnums.ItemWhereType.eWarehouse == receiveType then
    ToClient_ReceiveInstanceContentRewardAll(true)
  end
end
function PaGlobal_RewardList_IsRewardBeing()
  for i = 0, Int64toInt32(ToClient_GetInstanceContentRewardCount()) - 1 do
    if 0 ~= ToClient_GetInstanceContentRewardItemCountByIndex(i) then
      return true
    end
  end
  return false
end
function PaGlobal_RewardList_GetRecieveItemCount()
  local count = 0
  for i = 0, Int64toInt32(ToClient_GetInstanceContentRewardCount()) - 1 do
    if __eTItemMoneyKey ~= ToClient_GetInstanceContentRewardItemKeyByIndex(i) then
      count = count + Int64toInt32(ToClient_GetInstanceContentRewardItemCountByIndex(i))
    end
  end
  return count
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_RewardList_Init")
