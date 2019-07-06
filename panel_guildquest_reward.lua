local _panel = Panel_GuildQuest_Reward
local GuildQuestReward = {
  _ui = {
    btn_close = UI.getChildControl(_panel, "Button_Win_Close"),
    btn_question = UI.getChildControl(_panel, "Button_Question"),
    txt_money = UI.getChildControl(_panel, "StaticText_Reward_Money"),
    stc_money = UI.getChildControl(_panel, "Static_Menu_Money"),
    stc_basic = UI.getChildControl(_panel, "Static_Menu_Reward"),
    bg_black = UI.getChildControl(_panel, "BlackPanel")
  },
  _rewardSlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  },
  _maxBaseSlotCount = 12,
  expTooltip = nil,
  _rewardSlotBase = {},
  _rewardSlots = {},
  _rewardSlotBg = {},
  _moneySlotBase = nil,
  _moneySlot = nil,
  _posY_stc_basic = 0,
  _posYs_rewards = {},
  _size_bg_black = {},
  _size_panel = {}
}
function GuildQuestReward:initialize()
  self._ui.btn_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildQuest_Reward_ShowToggle()")
  self._ui.btn_question:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelQuestReward\" )")
  self._ui.btn_question:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"true\")")
  self._ui.btn_question:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelQuestReward\", \"false\")")
  self.expTooltip = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, _panel, "expTooltip")
  self.expTooltip:SetColor(Defines.Color.C_FFFFFFFF)
  self.expTooltip:SetAlpha(1)
  self.expTooltip:SetFontColor(Defines.Color.C_FFFFFFFF)
  self.expTooltip:SetAutoResize(true)
  self.expTooltip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self.expTooltip:SetTextHorizonLeft()
  self.expTooltip:SetShow(false)
  moneySlotBase = UI.getChildControl(_panel, "Static_Reward_Money")
  moneySlotBase:SetIgnore(true)
  self._moneySlotBase = moneySlotBase
  local mslot = {}
  SlotItem.new(mslot, "moneySlot", 0, moneySlotBase, self._rewardSlotConfig)
  mslot:createChild()
  mslot.icon:SetPosX(-2)
  mslot.icon:SetPosY(-2)
  self._moneySlot = mslot
  Panel_Tooltip_Item_SetPosition(0, mslot, "Dialog_GuildQuestReward_Money")
  for index = 0, self._maxBaseSlotCount - 1 do
    local slotBase = UI.getChildControl(_panel, "Static_Slot_" .. index)
    slotBase:SetIgnore(true)
    self._rewardSlotBg[index] = UI.getChildControl(_panel, "Static_Reward_Slot_" .. index)
    self._rewardSlotBase[index] = slotBase
    local slot = {}
    SlotItem.new(slot, "slotBase_" .. index, index, slotBase, self._rewardSlotConfig)
    slot:createChild()
    slot.icon:SetPosX(-2)
    slot.icon:SetPosY(-2)
    self._rewardSlots[index] = slot
    Panel_Tooltip_Item_SetPosition(index, slot, "Dialog_GuildQuestReward_Base")
    self._posYs_rewards[index] = self._rewardSlotBase[index]:GetPosY()
  end
  self._posY_stc_basic = self._ui.stc_basic:GetPosY()
  self._size_bg_black.X = self._ui.bg_black:GetSizeX()
  self._size_bg_black.Y = self._ui.bg_black:GetSizeY()
  self._size_panel.X = _panel:GetSizeX()
  self._size_panel.Y = _panel:GetSizeY()
end
function GuildQuestReward:open()
  _panel:SetShow(true)
end
function GuildQuestReward:close()
  _panel:SetShow(false)
end
function GuildQuestReward:rewardTooltip(type, show, questType, index, mentalCardKey)
  if true == show then
    if "Exp" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP"))
    elseif "SkillExp" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP"))
    elseif "ExpGrade" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_EXP_GRADE"))
    elseif "SkillExpGrade" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_SKILLEXP_GRADE"))
    elseif "ProductExp" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_PRODUCTEXP"))
    elseif "Intimacy" == type then
      self.expTooltip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTREWARD_SIMPLE_TOOLTIP_INTIMACY"))
    elseif "Knowledge" == type then
      local mentalCardSSW = ToClinet_getMentalCardStaticStatus(mentalCardKey)
      local mentalCardName = mentalCardSSW:getName()
      local mentalCardDesc = mentalCardSSW:getDesc()
      self.expTooltip:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_REWARD_TOOLTIP_KNOWLEDGE", "mentalCardName", mentalCardName, "mentalCardName2", mentalCardName))
    end
    self.expTooltip:SetPosX(self._rewardSlotBase[index]:GetPosX() - self.expTooltip:GetSizeX() / 2)
    self.expTooltip:SetPosY(self._rewardSlotBase[index]:GetPosY() - self.expTooltip:GetSizeY() - 10)
    self.expTooltip:SetShow(true)
  else
    self.expTooltip:SetShow(false)
  end
end
function GuildQuestReward:setReward(uiSlot, reward, index, questType)
  self:rewardTooltip(nil, false)
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
    uiSlot._item = reward._item
    uiSlot:setItemByStaticStatus(itemStatic, reward._count)
    uiSlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_GuildQuestReward_Base\",true)")
    uiSlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. index .. ",\"Dialog_GuildQuestReward_Base\",false)")
    return reward._isEquipable
  elseif __eRewardIntimacy == reward._type then
    uiSlot.count:SetText(tostring(reward._value))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"Intimacy\", true, \"" .. questType .. "\", " .. index .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"Intimacy\", false, \"" .. questType .. "\", " .. index .. " )")
  elseif __eRewardKnowledge == reward._type then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
    uiSlot.icon:addInputEvent("Mouse_On", "rewardTooltip( \"Knowledge\", true, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
    uiSlot.icon:addInputEvent("Mouse_Out", "rewardTooltip( \"Knowledge\", false, \"" .. questType .. "\", " .. index .. "," .. reward._mentalCard .. " )")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
  return false
end
function GuildQuestReward:setMoneySlot(moneyReward, itemStatic)
  self._moneySlot._item = moneyReward._item
  self._moneySlot:setItemByStaticStatus(itemStatic, moneyReward._count)
  self._moneySlot.count:SetShow(false)
  self._ui.txt_money:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDQUEST_REWARD_MONEY_TXT", "count", makeDotMoney(moneyReward._count)))
  self._moneySlot.icon:addInputEvent("Mouse_On", "Panel_Tooltip_Item_Show_GeneralStatic(" .. 0 .. ",\"Dialog_GuildQuestReward_Money\",true)")
  self._moneySlot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_Show_GeneralStatic(" .. 0 .. ",\"Dialog_GuildQuestReward_Money\",false)")
end
function GuildQuestReward:moneySlotHide(show)
  if false == show then
    self._moneySlotBase:SetShow(false)
    self._ui.txt_money:SetShow(false)
    self._ui.stc_money:SetShow(false)
    self._ui.stc_basic:SetPosY(self._posY_stc_basic - 60)
    for index = 0, self._maxBaseSlotCount - 1 do
      self._rewardSlotBase[index]:SetPosY(self._posYs_rewards[index] - 65)
      self._rewardSlotBg[index]:SetPosY(self._posYs_rewards[index] - 65)
    end
    self._ui.bg_black:SetSize(self._size_bg_black.X, self._size_bg_black.Y - 65)
    _panel:SetSize(self._size_panel.X, self._size_panel.Y - 65)
  elseif true == show then
    self._moneySlotBase:SetShow(true)
    self._ui.txt_money:SetShow(true)
    self._ui.stc_money:SetShow(true)
    self._ui.stc_basic:SetPosY(self._posY_stc_basic)
    for index = 0, self._maxBaseSlotCount - 1 do
      self._rewardSlotBase[index]:SetPosY(self._posYs_rewards[index])
      self._rewardSlotBg[index]:SetPosY(self._posYs_rewards[index])
    end
    self._ui.bg_black:SetSize(self._size_bg_black.X, self._size_bg_black.Y)
    _panel:SetSize(self._size_panel.X, self._size_panel.Y)
  end
end
function PaGlobalFunc_GuildQuest_Reward_Init()
  local self = GuildQuestReward
  self:initialize()
end
function PaGlobalFunc_GuildQuest_Reward_ShowToggle()
  local self = GuildQuestReward
  if false == _panel:GetShow() then
    self:open()
  else
    self:close()
  end
end
function PaGlobalFunc_GuildQuest_Reward_Close()
  local self = GuildQuestReward
  if true == _panel:GetShow() then
    self:close()
  end
end
function PaGlobalFunc_GuildQuest_Reward_ListSet(baseReward)
  local self = GuildQuestReward
  local _allRewardCount = #baseReward
  local slotIndex = 0
  local isMoney = false
  for index = 0, self._maxBaseSlotCount - 1 do
    self._rewardSlotBase[slotIndex]:EraseAllEffect()
    if index < _allRewardCount then
      if __eRewardItem == baseReward[index + 1]._type then
        local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(baseReward[index + 1]._item))
        if 1 == itemStatic:get()._key:getItemKey() then
          self:setMoneySlot(baseReward[index + 1], itemStatic, "guild")
          isMoney = true
        else
          self:setReward(self._rewardSlots[slotIndex], baseReward[index + 1], slotIndex, "guild")
          self._rewardSlotBase[slotIndex]:SetShow(true)
          slotIndex = slotIndex + 1
        end
      else
        self:setReward(self._rewardSlots[slotIndex], baseReward[index + 1], slotIndex, "guild")
        self._rewardSlotBase[slotIndex]:SetShow(true)
        slotIndex = slotIndex + 1
      end
    else
      self._rewardSlotBase[slotIndex]:SetShow(false)
      slotIndex = slotIndex + 1
    end
  end
  self:moneySlotHide(isMoney)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildQuest_Reward_Init()")
