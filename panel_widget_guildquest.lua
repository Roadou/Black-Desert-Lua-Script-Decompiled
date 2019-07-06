local _panel = Panel_Widget_GuildQuest
local UI_color = Defines.Color
local GuildQuestWidget = {
  _ui = {
    txt_QuestTitle = UI.getChildControl(_panel, "StaticText_Quest_Title"),
    stc_QuestType = UI.getChildControl(_panel, "Static_Quest_Type"),
    txt_QuestDemand = UI.getChildControl(_panel, "StaticText_Quest_Demand"),
    txt_LeftTime = UI.getChildControl(_panel, "StaticText_LeftTime")
  },
  _defaultPosY = 0,
  _defaultPosX = 0
}
function GuildQuestWidget:open()
  if true == _panel:GetShow() then
    return
  end
  _panel:SetShow(true)
end
function GuildQuestWidget:close()
  _panel:SetShow(false)
end
function GuildQuestWidget:init()
  self._ui.txt_QuestTitle:SetAutoResize(true)
  self._ui.txt_QuestTitle:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui.txt_QuestTitle:SetIgnore(true)
  self._ui.txt_QuestTitle:SetFontColor(UI_color.C_FFEFEFEF)
  self._ui.txt_QuestTitle:useGlowFont(true, "SubTitleFont_14_Glow", 4287655978)
  self._ui.txt_QuestDemand:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self:registEvent()
  PaGlobalFunc_GuildQuestWidget_OnResize()
end
function GuildQuestWidget:registEvent()
  registerEvent("onScreenResize", "PaGlobalFunc_GuildQuestWidget_OnResize")
  registerEvent("FromClient_UpdateProgressGuildQuestList", "PaGlobalFunc_GuildQuestWidget_Update")
  registerEvent("FromClient_UpdateQuestList", "PaGlobalFunc_GuildQuestWidget_Update")
  _panel:RegisterUpdateFunc("PaGlobalFunc_GuildQuestWidget_PerframeUpdate")
end
function GuildQuestWidget:update()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == guildInfo then
    self:close()
    return
  end
  local isProgressing = ToClient_isProgressingGuildQuest()
  if true == isProgressing then
    local currentGuildQuestName = ToClient_getCurrentGuildQuestName()
    self._ui.txt_QuestTitle:SetText(currentGuildQuestName)
    local remainTime = ToClient_getCurrentGuildQuestRemainedTime()
    local strMinute = math.floor(remainTime / 60)
    if remainTime <= 0 then
      self._ui.txt_LeftTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_TIMEOUT"))
    else
      self._ui.txt_LeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_REMAINTIME", "time_minute", strMinute))
    end
    local conditionStr = ""
    local questConditionCount = ToClient_getCurrentGuildQuestConditionCount()
    for idx = 0, questConditionCount - 1 do
      local currentGuildQuestInfo = ToClient_getCurrentGuildQuestConditionAt(idx)
      conditionStr = conditionStr .. " - " .. currentGuildQuestInfo._desc .. " ( " .. currentGuildQuestInfo._currentCount .. " / " .. currentGuildQuestInfo._destCount .. " ) " .. "\n"
    end
    self._ui.txt_QuestDemand:SetText(conditionStr)
    self._ui.txt_LeftTime:SetShow(true)
    self._ui.txt_QuestDemand:SetShow(true)
  elseif true == ToClient_isGuildQuestOtherServer() then
    self._ui.txt_QuestTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_PROGRESSNOQUEST_ANOTHER"))
    self._ui.txt_LeftTime:SetShow(false)
    self._ui.txt_QuestDemand:SetShow(false)
  else
    self:close()
    return
  end
  self:open()
end
function PaGlobalFunc_GuildQuestWidget_Update()
  local self = GuildQuestWidget
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestWidget")
    return
  end
  self:update()
  PaGlobalFunc_GuildQuestWidget_OnResize()
  PaGlobal_LatestQuest_Update()
end
function PaGlobalFunc_GuildQuestWidget_Close()
  local self = GuildQuestWidget
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestWidget")
    return
  end
  self:close()
end
function PaGlobalFunc_GuildQuestWidget_Init()
  local self = GuildQuestWidget
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestWidget")
    return
  end
  self:init()
  self:update()
end
function PaGlobalFunc_GuildQuestWidget_OnResize()
  local self = GuildQuestWidget
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestWidget")
    return
  end
  local posX = Panel_MainQuest:GetPosX()
  local posY = PaGlobal_MainQuest_GetPosY() + PaGlobal_MainQuest_GetSizeY()
  _panel:SetPosXY(posX, posY)
end
function PaGlobalFunc_GuildQuestWidget_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_GuildQuestWidget_GetPosY()
  return _panel:GetPosY()
end
function PaGlobalFunc_GuildQuestWidget_GetSizeY()
  local self = GuildQuestWidget
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildQuestWidget")
    return
  end
  return _panel:GetSizeY() + self._ui.txt_QuestDemand:GetTextSizeY()
end
local guildQuestWidgetTimeAcc = 0
function PaGlobalFunc_GuildQuestWidget_PerframeUpdate(deltaTime)
  guildQuestWidgetTimeAcc = guildQuestWidgetTimeAcc + deltaTime
  if guildQuestWidgetTimeAcc > 60 then
    guildQuestWidgetTimeAcc = 0
    PaGlobalFunc_GuildQuestWidget_Update()
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildQuestWidget_Init")
