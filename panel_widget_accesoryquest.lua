local _panel = Panel_Widget_AccesoryQuest
local AccesoryQuest = {
  _ui = {
    txt_title = UI.getChildControl(_panel, "StaticText_QuestTitle"),
    btn_apply = UI.getChildControl(_panel, "Button_Reward"),
    stc_rewardBg = UI.getChildControl(_panel, "Static_RewardGage_Bg"),
    progress_reward = UI.getChildControl(_panel, "Progress2_RewardGage"),
    txt_rewardValue = UI.getChildControl(_panel, "StaticText_RewardValue"),
    txt_questDesc = UI.getChildControl(_panel, "StaticText_QuestDesc"),
    stc_itemSlotBg = UI.getChildControl(_panel, "Static_ItemSlotBg")
  },
  _currentQuestGroup = 0,
  _nowRegionKey = 0,
  _itemSlot = nil,
  _nowQuestNo = nil,
  _nowAccesoryQuestCount = nil,
  _showFlag = false,
  _showTimeRegionKey = 0,
  _panelPosY = 0
}
function AccesoryQuest:initialize()
  if false == _ContentsGroup_AccesoryQuest then
    _panel:SetShow(_ContentsGroup_AccesoryQuest)
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil ~= selfPlayer then
    local nowRegionInfo = selfPlayer:getCurrentRegionInfo()
    if nil ~= nowRegionInfo then
      self._nowRegionKey = Int64toInt32(nowRegionInfo:getRegionKey())
    end
  end
  local slotConfig = {
    createIcon = true,
    createBorder = false,
    createCount = true,
    createEnchant = true,
    createClassEquipBG = true,
    createCash = true
  }
  local slot = {}
  SlotItem.new(slot, "slotIcon_" .. 0, 0, self._ui.stc_itemSlotBg, slotConfig)
  slot:createChild()
  self._itemSlot = slot
  Panel_Tooltip_Item_SetPosition(0, self._itemSlot, "AccesoryQuest_Base")
  self._ui.txt_title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self:registEventHandler()
  self._showTimeRegionKey = 0
  self._nowRegionKey = 0
  self:update()
end
function AccesoryQuest:registEventHandler()
  self._ui.btn_apply:addInputEvent("Mouse_LUp", "Input_AccesoryQuest_ApplyReward()")
  registerEvent("FromClient_UpdateQuestList", "FromClient_AccesoryQuest_UpdateQuestList")
  registerEvent("selfPlayer_regionChanged", "FromClient_AccesoryQuest_selfPlayer_regionChanged")
  registerEvent("FromClient_notifyUpdateRegionMonsterKillQuest", "FromClient_AccesoryQuest_notifyUpdateRegionMonsterKillQuest")
  registerEvent("EventQuestUpdateNotify", "FromClient_AccesoryQuest_EventQuestUpdateNotify")
  registerEvent("FromClient_EquipEnduranceChanged", "FromClient_AccesoryQuest_EquipEnduranceChanged")
  registerEvent("EventServantEquipItem", "FromClient_AccesoryQuest_EventServantEquipItem")
  registerEvent("EventServantEquipmentUpdate", "FromClient_AccesoryQuest_EventServantEquipmentUpdate")
  registerEvent("FromClient_WeightPenaltyChanged", "FromClient_AccesoryQuest_WeightPenaltyChanged")
  registerEvent("onScreenResize", "PaGlobalFunc_AccesoryQuest_OnScreenResize")
end
function AccesoryQuest:open()
  _panel:SetShow(true)
end
function AccesoryQuest:close()
  _panel:SetShow(false)
end
function FromClient_AccesoryQuest_EventQuestUpdateNotify(isAccept, questNoRaw)
  local self = AccesoryQuest
  if true == _panel:GetShow() then
    self:update()
  end
end
function PaGlobal_AccesoryQuest_SetCurrentRegionQuestInfo()
  local self = AccesoryQuest
  local questList = ToClient_GetQuestList()
  local nowRegionInfo = getSelfPlayer():getCurrentRegionInfo()
  if nil == questList then
    return false
  end
  if nil == nowRegionInfo then
    return false
  end
  local accesoryQuestCount = questList:getRegionMonsterKillQuestCount()
  self._nowRegionKey = Int64toInt32(nowRegionInfo:getRegionKey())
  for i = 0, accesoryQuestCount - 1 do
    local accesoryQuestNo = questList:getRegionMonsterKillQuestAt(i)
    if nil == accesoryQuestNo then
      return false
    end
    local questInfoWrapper = questList_getQuestStatic(accesoryQuestNo._group, accesoryQuestNo._quest)
    if nil == questInfoWrapper then
      return false
    end
    if self._nowRegionKey == questInfoWrapper:getRegionKey() then
      local questNo = questInfoWrapper:getQuestNo()
      if nil == questNo then
        return false
      end
      self._nowQuestNo = questNo
      return i
    end
  end
  return false
end
function AccesoryQuest:update()
  local questList = ToClient_GetQuestList()
  if nil == questList then
    return
  end
  self._showFlag = false
  local accesoryQuestCount = questList:getRegionMonsterKillQuestCount()
  for ii = 0, accesoryQuestCount - 1 do
    local accesoryQuestNo = questList:getRegionMonsterKillQuestAt(ii)
    if nil == accesoryQuestNo then
      return
    end
    self._nowAccesoryQuestCount = accesoryQuestCount
    local questInfoWrapper = questList_getQuestStatic(accesoryQuestNo._group, accesoryQuestNo._quest)
    local questCount = questList:getClearedRegionMonsterKillQuestCount()
    if nil ~= questInfoWrapper and self._nowRegionKey == questInfoWrapper:getRegionKey() then
      local questNo = questInfoWrapper:getQuestNo()
      if nil ~= questNo then
        local questInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
        local questWrapper = ToClient_getQuestWrapper(questNo)
        self._nowQuestNo = questNo
        if nil ~= questInfo and nil ~= questWrapper and ToClient_isProgressingQuest(questNo._group, questNo._quest) then
          local questBasicCnt = questWrapper:getQuestBaseRewardCount()
          if questBasicCnt > 0 then
            local baseRewardWrapper = questWrapper:getQuestBaseRewardAt(0)
            local baseReward
            if nil ~= baseRewardWrapper then
              baseReward = baseRewardWrapper:get()
            end
            if nil ~= baseReward then
              local slotOption = {}
              slotOption._type = baseReward._type
              if __eRewardItem == slotOption._type then
                slotOption._item = baseReward:getItemEnchantKey()
                slotOption._count = baseReward._itemCount
                local selfPlayer = getSelfPlayer()
                if nil ~= selfPlayer then
                  local classType = selfPlayer:getClassType()
                  slotOption._isEquipable = baseReward:isEquipable(classType)
                end
              end
              self:setAccesoryQuestRewardShow(slotOption)
            end
          end
          local questCondition = questInfo:getDemandAt(0)
          self._ui.txt_title:SetText(questInfo:getTitle())
          if nil ~= questCondition then
            self._ui.txt_rewardValue:SetText(questCondition._currentCount .. " / " .. questCondition._destCount)
            local rate = math.floor(questCondition._currentCount / questCondition._destCount * 100)
            self._ui.progress_reward:SetProgressRate(rate - 0.1)
            if false == questInfo:isSatisfied() then
              self._ui.txt_questDesc:SetShow(true)
              self._ui.btn_apply:SetShow(false)
              self._showFlag = true
              self._itemSlot.icon:SetMonoTone(true)
              break
            else
              self._ui.txt_questDesc:SetShow(false)
              self._ui.btn_apply:SetShow(true)
              self._showFlag = true
              self._itemSlot.icon:SetMonoTone(false)
              break
            end
          end
        end
      end
    end
  end
  if true == self._showFlag then
    AccesoryQuest:resizePosition()
    if self._nowRegionKey ~= self._showTimeRegionKey then
      self:ShowAni()
      self._showTimeRegionKey = self._nowRegionKey
    end
    self:open()
  elseif true == _panel:GetShow() then
    self:HideAni()
    self._showTimeRegionKey = 0
  end
  PaGlobalFunc_BetterEquipment_OnScreenResize()
end
function AccesoryQuest:resizePosition()
  local panelSizeY = AccesoryQuest._ui.txt_title:GetTextSizeY() + AccesoryQuest._ui.txt_questDesc:GetTextSizeY() + AccesoryQuest._ui.btn_apply:GetSizeY() + 35
  Panel_Widget_AccesoryQuest:SetSize(Panel_Widget_AccesoryQuest:GetSizeX(), panelSizeY)
  AccesoryQuest._ui.txt_title:ComputePos()
  AccesoryQuest._ui.stc_rewardBg:ComputePos()
  AccesoryQuest._ui.progress_reward:ComputePos()
  AccesoryQuest._ui.txt_rewardValue:ComputePos()
  AccesoryQuest._ui.stc_itemSlotBg:ComputePos()
  AccesoryQuest._ui.txt_questDesc:ComputePos()
  AccesoryQuest._ui.btn_apply:ComputePos()
end
function Input_AccesoryQuest_ApplyReward()
  local self = AccesoryQuest
  if nil == self._nowQuestNo then
    return
  end
  local index = PaGlobal_AccesoryQuest_SetCurrentRegionQuestInfo()
  local questNo = self._nowQuestNo
  if false == index then
    return
  end
  local questInfo = ToClient_GetQuestInfo(questNo._group, questNo._quest)
  local questWrapper = ToClient_getQuestWrapper(questNo)
  if nil ~= questInfo and nil ~= questWrapper and ToClient_isProgressingQuest(questNo._group, questNo._quest) and true == questInfo:isSatisfied() then
    ToClient_RequestCompleteRegionMonsterKillQuest(index)
  end
end
function AccesoryQuest:setAccesoryQuestRewardShow(reward)
  local uiSlot = self._itemSlot
  if nil ~= uiSlot then
    if __eRewardItem == reward._type then
      local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward._item))
      if nil ~= itemStatic then
        uiSlot:setItemByStaticStatus(itemStatic, reward._count)
        uiSlot._item = reward._item
        uiSlot.icon:SetSize(40, 40)
        uiSlot.icon:SetHorizonCenter()
        uiSlot.icon:SetVerticalMiddle()
      end
      uiSlot.icon:addInputEvent("Mouse_On", "Input_AccesoryQuest_ShowToolTip(true)")
      uiSlot.icon:addInputEvent("Mouse_Out", "Input_AccesoryQuest_ShowToolTip(false)")
    elseif __eRewardIntimacy == reward._type then
      uiSlot.count:SetText(tostring(reward._value))
      uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    else
      uiSlot.icon:addInputEvent("Mouse_On", "")
      uiSlot.icon:addInputEvent("Mouse_Out", "")
    end
  end
end
function Input_AccesoryQuest_ShowToolTip(isOn)
  Panel_Tooltip_Item_Show_GeneralStatic(0, "AccesoryQuest_Base", isOn)
end
function FromClient_AccesoryQuest_selfPlayer_regionChanged(regionData)
  if nil == regionData then
    return
  end
  local self = AccesoryQuest
  self:resetPosition()
  self._nowRegionKey = Int64toInt32(regionData:getRegionKey())
  self:update()
end
function FromClient_AccesoryQuest_UpdateQuestList()
  local self = AccesoryQuest
  self:resetPosition()
  self:update()
end
function AccesoryQuest:resetPosition()
  local radarSizeX = FGlobal_Panel_Radar_GetSizeX()
  if true == _panel:GetShow() then
    if true == Panel_Radar:GetShow() then
      _panel:SetPosX(Panel_Radar:GetPosX() - Panel_Widget_AccesoryQuest:GetSizeX())
    elseif true == Panel_WorldMiniMap:GetShow() then
      _panel:SetPosX(Panel_WorldMiniMap:GetPosX() - Panel_Widget_AccesoryQuest:GetSizeX())
    end
  end
  self._panelPosY = _panel:GetPosY()
  local tempPanel
  if true == PcEnduranceToggle() then
    tempPanel = PaGlobalPlayerWeightList.weight
    if nil ~= tempPanel then
      _panel:SetPosY(tempPanel:GetPosY() + tempPanel:GetSizeY() + Panel_Widget_AccesoryQuest:GetSizeY() + 80)
      self._panelPosY = _panel:GetPosY()
    end
  else
    if true == PaGlobalHorseEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalHorseEnduranceList.panel
    elseif true == PaGlobalCarriageEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalCarriageEnduranceList.panel
    elseif true == PaGlobalShipEnduranceList.panel:GetShow() then
      tempPanel = PaGlobalShipEnduranceList.panel
    elseif nil ~= PaGlobalPlayerEnduranceList.enduranceInfo[0] and true == PaGlobalPlayerEnduranceList.enduranceInfo[0].control:GetShow() then
      tempPanel = PaGlobalPlayerEnduranceList.panel
    end
    if nil ~= tempPanel then
      _panel:SetPosY(tempPanel:GetPosY() + tempPanel:GetSizeY() + 30)
      self._panelPosY = _panel:GetPosY()
    end
  end
end
function AccesoryQuest:ShowAni()
  local alarmMoveAni1 = Panel_Widget_AccesoryQuest:addMoveAnimation(0, 0.6, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni1:SetStartPosition(getScreenSizeX() + 10, self._panelPosY)
  alarmMoveAni1:SetEndPosition(Panel_Radar:GetPosX() - Panel_Widget_AccesoryQuest:GetSizeX(), self._panelPosY)
  alarmMoveAni1.IsChangeChild = true
  Panel_Widget_AccesoryQuest:CalcUIAniPos(alarmMoveAni1)
  alarmMoveAni1:SetDisableWhileAni(true)
  alarmMoveAni1:SetHideAtEnd(false)
end
function AccesoryQuest:HideAni()
  local alarmMoveAni2 = Panel_Widget_AccesoryQuest:addMoveAnimation(0, 0.6, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  alarmMoveAni2:SetStartPosition(Panel_Radar:GetPosX() - Panel_Widget_AccesoryQuest:GetSizeX(), self._panelPosY)
  alarmMoveAni2:SetEndPosition(getScreenSizeX() + 10, self._panelPosY)
  alarmMoveAni2.IsChangeChild = true
  Panel_Widget_AccesoryQuest:CalcUIAniPos(alarmMoveAni2)
  alarmMoveAni2:SetHideAtEnd(true)
end
function PaGlobalFunc_AccesoryQuest_ReturnPanelShow()
  local self = AccesoryQuest
  return self._showFlag
end
function PaGlobalFunc_AccesoryQuest_OnScreenResize()
  local self = AccesoryQuest
  self:resetPosition()
end
function FromClient_AccesoryQuest_EquipEnduranceChanged()
  local self = AccesoryQuest
  self:resetPosition()
end
function FromClient_AccesoryQuest_EventServantEquipItem()
  local self = AccesoryQuest
  self:resetPosition()
end
function FromClient_AccesoryQuest_EventServantEquipmentUpdate()
  local self = AccesoryQuest
  self:resetPosition()
end
function FromClient_AccesoryQuest_WeightPenaltyChanged()
  local self = AccesoryQuest
  self:resetPosition()
end
function FromClient_AccesoryQuest_notifyUpdateRegionMonsterKillQuest(questNoRaw)
end
function FromClient_AccesoryQuest_luaLoadComplete()
  local self = AccesoryQuest
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_AccesoryQuest_luaLoadComplete")
