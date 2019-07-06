local _panel = Panel_Window_Guild_QuestInfo
_panel:ignorePadSnapMoveToOtherPanel()
local GuildQuestInfo = {
  _ui = {
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _rewardSlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createClassEquipBG = true,
    createCash = true
  },
  _keyguide = {},
  _rewardSlotCtrl = {},
  _rewardSlotData = {},
  _defaultSlotCount = 12,
  _slotStartXPos = 30,
  _slotXGap = 50,
  _descStartYPos = 0,
  _isProgressingQuest = false
}
function GuildQuestInfo:init()
  self._ui.txt_QuestTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_QuestTitle")
  self._ui.txt_Condition = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Condition")
  self._ui.txt_Desc = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Desc")
  self._ui.txt_Time = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Time")
  self._ui.txt_NeedMoney = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_NeedMoney")
  self._ui.stc_SlotTemplate = UI.getChildControl(self._ui.stc_CenterBg, "Static_SlotBg_Template")
  self._ui.txt_BConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B_ConsoleUI")
  self._ui.txt_AConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_YConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Y_ConsoleUI")
  self._ui.txt_AcceptConsoleUI = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_AcceptConsoleUI")
  self._ui.txt_AConsoleUI:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_QUESTACQUIRE_COMPLETE"))
  self._keyguide = {
    self._ui.txt_BConsoleUI,
    self._ui.txt_AConsoleUI,
    self._ui.txt_YConsoleUI,
    self._ui.txt_AcceptConsoleUI
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  self._descStartYPos = self._ui.txt_Desc:GetPosY()
  self:initRewardSlot()
  self:registEvent()
end
function GuildQuestInfo:initRewardSlot()
  for slotIdx = 0, self._defaultSlotCount - 1 do
    local slotBg = UI.createAndCopyBasePropertyControl(self._ui.stc_CenterBg, "Static_SlotBg_Template", self._ui.stc_CenterBg, "ReardSlotBg_" .. slotIdx)
    self._rewardSlotCtrl[slotIdx] = slotBg
    self._rewardSlotCtrl[slotIdx]:SetPosX(self._slotStartXPos + self._slotXGap * slotIdx)
    local slot = {}
    SlotItem.new(slot, "BaseReward_" .. slotIdx, slotIdx, slotBg, self._rewardSlotConfig)
    slot:createChild()
    self._rewardSlotData[slotIdx] = slot
  end
end
function GuildQuestInfo:open()
  if true == self._isProgressingQuest then
    self:updateProgressingQuest()
  else
    self:update()
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 30)
  _panel:SetShow(true)
end
function GuildQuestInfo:close()
  _panel:SetShow(false)
end
function GuildQuestInfo:update()
  local currentQuestIdx = PaGlobalFunc_GuildQuestList_GetCurrentQuestIndex()
  local questInfo = ToClient_RequestGuildQuestAt(currentQuestIdx)
  if nil == questInfo then
    return
  end
  local requireGuildRank = questInfo:getGuildQuestGrade()
  local requireGuildRankStr = ""
  if 1 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_SMALL")
  elseif 2 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_MIDDLE")
  elseif 3 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIG")
  elseif 4 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIGGEST")
  end
  self._ui.txt_QuestTitle:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_LIMIT", "currentGuildQuestName", questInfo:getTitle(), "requireGuildRankStr", requireGuildRankStr))
  self._ui.txt_Condition:SetShow(false)
  self._ui.txt_Desc:SetPosY(self._descStartYPos - 30)
  self._ui.txt_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_Desc:SetText(questInfo:getDesc())
  local isShowPreOcc = PaGlobalFunc_GuildQuestList_GetIsShowingPreOccInfo()
  if false == isShowPreOcc then
    local questTime = PaGlobalFunc_GuildQuestList_QuestTime(questInfo:getLimitMinute())
    self._ui.txt_Time:SetText(questTime)
    self._ui.txt_Time:SetShow(true)
    local needMoney = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PREGOLD", "pre_gold", Uint64toUint32(questInfo:getPreGoldCount()))
    self._ui.txt_NeedMoney:SetText(needMoney)
    self._ui.txt_NeedMoney:SetShow(true)
  else
    self._ui.txt_Time:SetShow(false)
    self._ui.txt_NeedMoney:SetShow(false)
  end
  local baseRewardTable = {}
  for baseIndex = 0, self._defaultSlotCount - 1 do
    local baseReward = questInfo:getGuildQuestBaseRewardAt(baseIndex)
    if nil ~= baseReward then
      self:setReward(baseReward, baseIndex)
      self._rewardSlotCtrl[baseIndex]:SetShow(true)
    else
      self._rewardSlotCtrl[baseIndex]:SetShow(false)
    end
  end
  local isProgressing = ToClient_isProgressingGuildQuest()
  if true == isProgressing or true == isShowPreOcc then
    self._ui.txt_AcceptConsoleUI:SetShow(false)
    self._ui.txt_AcceptConsoleUI:addInputEvent("Mouse_LUp", "")
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  else
    self._ui.txt_AcceptConsoleUI:SetShow(true)
    self._ui.txt_AcceptConsoleUI:addInputEvent("Mouse_LUp", "InputMLUp_GuildQuestList_AcceptQuest()")
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_GuildQuestList_AcceptQuest()")
  end
  self._ui.txt_AConsoleUI:SetShow(false)
  self._ui.txt_YConsoleUI:SetShow(false)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
end
function PaGlobalFunc_GuildQuestInfo_updateProgressingQuest()
  if false == Panel_Window_Guild_QuestInfo:GetShow() then
    return
  end
  GuildQuestInfo:updateProgressingQuest()
end
function GuildQuestInfo:updateProgressingQuest()
  if false == ToClient_isProgressingGuildQuest() then
    self:close()
    return
  end
  local requireGuildRank = ToClient_getCurrentGuildQuestGrade()
  local requireGuildRankStr = ""
  if 1 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_SMALL")
  elseif 2 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_MIDDLE")
  elseif 3 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIG")
  elseif 4 == requireGuildRank then
    requireGuildRankStr = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_BIGGEST")
  end
  self._ui.txt_QuestTitle:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_LIMIT", "currentGuildQuestName", ToClient_getCurrentGuildQuestName(), "requireGuildRankStr", requireGuildRankStr))
  local conditionStr = ""
  local questConditionCount = ToClient_getCurrentGuildQuestConditionCount()
  for idx = 0, questConditionCount - 1 do
    local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(idx)
    conditionStr = conditionStr .. currentGuildQuestInfo._desc .. " ( " .. currentGuildQuestInfo._currentCount .. " / " .. currentGuildQuestInfo._destCount .. " ) " .. "\n"
  end
  self._ui.txt_Condition:SetText(conditionStr)
  self._ui.txt_Condition:SetShow(true)
  self._ui.txt_Desc:SetPosY(self._descStartYPos + (questConditionCount - 1) * 25)
  self._ui.txt_Desc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_Desc:SetText(ToClient_getCurrentGuildQuestDesc())
  self._ui.txt_Time:SetShow(false)
  self._ui.txt_NeedMoney:SetShow(false)
  local baseRewardTable = {}
  for baseIndex = 0, self._defaultSlotCount - 1 do
    local baseReward = ToClient_getCurrentGuildQuestBaseRewardAt(baseIndex)
    if nil ~= baseReward then
      self:setReward(baseReward, baseIndex)
      self._rewardSlotCtrl[baseIndex]:SetShow(true)
    else
      self._rewardSlotCtrl[baseIndex]:SetShow(false)
    end
  end
  self._ui.txt_AConsoleUI:SetShow(false)
  self._ui.txt_AcceptConsoleUI:SetShow(false)
  self._ui.txt_AConsoleUI:addInputEvent("Mouse_LUp", "")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
  if true == ToClient_isSatisfyCurrentGuildQuest() and (getSelfPlayer():get():isGuildMaster() or getSelfPlayer():get():isGuildSubMaster()) then
    self._ui.txt_AConsoleUI:SetShow(true)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_GuildQuestList_ClearQuest()")
  end
  self._ui.txt_YConsoleUI:SetShow(true)
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputMLUp_GuildQuestList_GiveupQuest()")
end
function GuildQuestInfo:setReward(reward, idx)
  local uiSlot = self._rewardSlotData[idx]
  local rewardType = reward:getType()
  uiSlot._type = reward:getType()
  if __eRewardExp == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
  elseif __eRewardSkillExp == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExp.dds")
  elseif __eRewardExpGrade == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/ExpGrade.dds")
  elseif __eRewardSkillExpGrade == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/SkillExpGrade.dds")
  elseif __eRewardLifeExp == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/EXP.dds")
  elseif __eRewardItem == rewardType then
    local itemStatic = getItemEnchantStaticStatus(ItemEnchantKey(reward:getItemEnchantKey()))
    uiSlot:setItemByStaticStatus(itemStatic, reward:getItemCount())
    uiSlot._item = reward:getItemEnchantKey()
  elseif __eRewardIntimacy == rewardType then
    uiSlot.count:SetText(tostring(reward:getIntimacyValue()))
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/00000000_Special_Contributiveness.dds")
  elseif __eRewardKnowledge == rewardType then
    uiSlot.count:SetText("")
    uiSlot.icon:ChangeTextureInfoName("Icon/New_Icon/03_ETC/12_DoApplyDirectlyItem/00000000_know_icon.dds")
  else
    uiSlot.icon:addInputEvent("Mouse_On", "")
    uiSlot.icon:addInputEvent("Mouse_Out", "")
  end
end
function GuildQuestInfo:registEvent()
  PaGlobal_registerPanelOnBlackBackground(_panel)
  self._ui.txt_BConsoleUI:addInputEvent("Mouse_LUp", "PaGlobalFunc_GuildQuestInfo_Close()")
  self._ui.txt_BConsoleUI:SetIgnore(false)
  self._ui.txt_AConsoleUI:addInputEvent("Mouse_LUp", "InputMLUp_GuildQuestList_AcceptQuest()")
  self._ui.txt_AConsoleUI:SetIgnore(false)
  registerEvent("ResponseUpdateGuildQuest", "PaGlobalFunc_GuildQuestInfo_updateProgressingQuest")
end
function PaGlobalFunc_GuildQuestInfo_Open()
  local self = GuildQuestInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestInfo")
    return
  end
  self._isProgressingQuest = false
  self:open()
end
function PaGlobalFunc_GuildQuestInfo_Close()
  local self = GuildQuestInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestInfo")
    return
  end
  self:close()
end
function PaGlobalFunc_GuildQuestInfo_OpenCurrentProgressingQuest()
  local self = GuildQuestInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestInfo")
    return
  end
  self._isProgressingQuest = true
  self:open()
end
function PaGlobalFunc_GuildQuestInfo_GetShow()
  local self = GuildQuestInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestInfo")
    return
  end
  return _panel:GetShow()
end
function InputMLUp_GuildQuestList_ClearQuest()
  local doHaveCashGuildQuestItem = doHaveContentsItem(CppEnums.ContentsEventType.ContentsType_AddGuildQuestReward, 0, false)
  if true == doHaveCashGuildQuestItem then
    local messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_QUEST_CLEAR_USEITEM"),
      functionYes = PaGlobalFunc_GuildQuestInfo_ClearUseItem,
      functionNo = PaGlobalFunc_GuildQuestInfo_ClearDontUseItem,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  else
    PaGlobalFunc_GuildQuestInfo_ClearDontUseItem()
  end
end
function PaGlobalFunc_GuildQuestInfo_ClearUseItem()
  ToClient_RequestGuildQuestComplete(true)
  PaGlobalFunc_GuildQuestInfo_Close()
end
function PaGlobalFunc_GuildQuestInfo_ClearDontUseItem()
  ToClient_RequestGuildQuestComplete(false)
  PaGlobalFunc_GuildQuestInfo_Close()
end
function PaGlobalFunc_GuildQuestInfo_Init()
  local self = GuildQuestInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestInfo")
    return
  end
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildQuestInfo_Init")
