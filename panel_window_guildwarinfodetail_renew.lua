local _panel = Panel_Window_GuildWarInfoDetail_Renew
local GuildWarInfoDetail = {
  _ui = {
    stc_subFrame = UI.getChildControl(_panel, "Static_SubFrame"),
    stc_topFrame = nil,
    list2_members = UI.getChildControl(_panel, "List2_MemberList")
  },
  _guildNo = nil,
  _scoreDataTable = nil
}
function GuildWarInfoDetail:initialize()
  self._ui.list2_members:changeAnimationSpeed(10)
  self._ui.list2_members:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_GuildWarInfoDetail_ListCreateControl")
  self._ui.list2_members:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function GuildWarInfoDetail:update()
  local guildAlliance = ToClient_GetGuildAllianceWrapperbyNo(self._guildNo)
  local memberCount = 0
  if nil ~= guildAlliance then
    for index = 0, guildAlliance:getMemberCount() - 1 do
      local guildWrapper = guildAlliance:getMemberGuild(index)
      if nil == guildWrapper then
        return
      end
      self:SetWarScoreList(guildWrapper, memberCount)
      memberCount = memberCount + guildWrapper:getTopMemberCount()
    end
  else
    local guildWrapper = ToClient_GetGuildInfoWrapperByGuildNo(self._guildNo)
    if nil == guildWrapper then
      return
    end
    self:SetWarScoreList(guildWrapper, memberCount)
    memberCount = guildWrapper:getMemberCount()
  end
end
function GuildWarInfoDetail:SetWarScoreList(guildWrapper)
  local memberCount = guildWrapper:getTopMemberCount()
  self._scoreDataTable = {}
  self._ui.list2_members:getElementManager():clearKey()
  for ii = 1, memberCount do
    local userNo = guildWrapper:getTopMemberUserNobyIndex(index)
    if nil ~= userNo then
      local pData = guildWrapper:getMemberByUserNo(userNo)
      if nil ~= pData then
        local index = #self._scoreDataTable + 1
        self._scoreDataTable[index] = {}
        self._scoreDataTable[index]._userNo = userNo
        self._scoreDataTable[index]._name = pData:getName()
        if true == pData:isOnline() then
          self._scoreDataTable[index]._name = "<PAColor0xFFEFEFEF>" .. self._scoreDataTable[index]._name .. " (" .. pData:getCharacterName() .. ")<PAOldColor>"
        else
          self._scoreDataTable[index]._name = "<PAColor0xFFC4BEBE>" .. self._scoreDataTable[index]._name .. " ( - )<PAOldColor>"
        end
        self._scoreDataTable[index]._score1 = pData:commandPostCount() + pData:towerCount() + pData:gateCount()
        self._scoreDataTable[index]._score2 = pData:guildMasterCount() + pData:squadLeaderCount() + pData:squadMemberCount()
        self._scoreDataTable[index]._score3 = pData:deathCount()
        self._scoreDataTable[index]._score4 = pData:summonedCount()
      end
    end
  end
  for ii = 1, #self._scoreDataTable do
    self._ui.list2_members:getElementManager():pushKey(toInt64(0, ii))
  end
end
function PaGlobalFunc_GuildWarInfoDetail_Open(index)
  local self = GuildWarInfoDetail
  local guildNo64Table = PaGlobalFunc_GuildWarInfo_GetGuildNo64Table()
  self._guildNo = guildNo64Table[index]
  self:update()
  _panel:SetShow(true)
end
function PaGlobalFunc_GuildWarInfoDetail_Close()
  local self = GuildWarInfoDetail
  _panel:SetShow(false)
end
function PaGlobalFunc_GuildWarInfoDetail_ListCreateControl(content, key)
  local self = GuildWarInfoDetail
  local index = Int64toInt32(key)
  local txt_name = UI.getChildControl(content, "StaticText_Name")
  local txt_score1 = UI.getChildControl(content, "StaticText_ScoreVal1")
  local txt_score2 = UI.getChildControl(content, "StaticText_ScoreVal2")
  local txt_score3 = UI.getChildControl(content, "StaticText_ScoreVal3")
  local txt_score4 = UI.getChildControl(content, "StaticText_ScoreVal4")
  local scoreData = self._scoreDataTable[index]
  txt_name:SetText(scoreData._name)
  txt_score1:SetText(scoreData._score1)
  txt_score2:SetText(scoreData._score2)
  txt_score3:SetText(scoreData._score3)
  txt_score4:SetText(scoreData._score4)
end
function FromClient_luaLoadComplete_GuildWarInfoDetail_Init()
  local self = GuildWarInfoDetail
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildWarInfoDetail_Init")
