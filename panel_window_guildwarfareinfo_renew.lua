local UI_color = Defines.Color
local _parent = Panel_Window_Guild_Renew
local _panel = Panel_Window_GuildWarfareInfo_Renew
_panel:ignorePadSnapMoveToOtherPanel()
local GuildWarfareInfo = {
  _ui = {
    stc_topBg = UI.getChildControl(_panel, "Static_TopBg"),
    stc_contentBg = UI.getChildControl(_panel, "Static_ContentBg"),
    list2_WarfareInfo = nil,
    stc_template = nil,
    txt_title = UI.getChildControl(_panel, "StaticText_Title"),
    txt_Name = nil,
    txt_CommandCenter = nil,
    txt_Tower = nil,
    txt_CastleGate = nil,
    txt_Summon = nil,
    txt_Installation = nil,
    txt_Member = nil,
    txt_Death = nil,
    txt_KilledBySiege = nil,
    _parentBg = nil
  },
  _memberData = {},
  templateList = {},
  line_gap = 5,
  rowLimit = 20
}
local self = GuildWarfareInfo
function GuildWarfareInfo:init()
  _panel:SetShow(false)
  self._ui.txt_title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDWARFAREINFO"))
  self._ui.list2_WarfareInfo = UI.getChildControl(self._ui.stc_contentBg, "List2_WarfareInfo")
  self._ui.list2_WarfareInfo:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaglobalFunc_WarfareInfo_CreateList")
  self._ui.list2_WarfareInfo:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  PaGlobal_registerPanelOnBlackBackground(_panel)
  self:registEventHandler()
end
function GuildWarfareInfo:registEventHandler()
  registerEvent("Event_SiegeScoreUpdateData", "FromClient_SiegeScoreUpdateData_GuildWarfareInfo_Update")
end
function PaglobalFunc_WarfareInfo_CreateList(control, key)
  local self = GuildWarfareInfo
  local key32 = Int64toInt32(key)
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  local memberData = self._memberData[key32]
  if nil == memberData then
    return
  end
  local btn_list = UI.getChildControl(control, "Button_Content")
  local txt_Name = UI.getChildControl(btn_list, "StaticText_Name")
  local txt_CommandCenter = UI.getChildControl(btn_list, "StaticText_CommandCenter")
  local txt_Tower = UI.getChildControl(btn_list, "StaticText_Tower")
  local txt_CastleGate = UI.getChildControl(btn_list, "StaticText_CastleGate")
  local txt_Summon = UI.getChildControl(btn_list, "StaticText_Summon")
  local txt_Installation = UI.getChildControl(btn_list, "StaticText_Installation")
  local txt_Member = UI.getChildControl(btn_list, "StaticText_Member")
  local txt_Death = UI.getChildControl(btn_list, "StaticText_Death")
  local txt_KilledBySiege = UI.getChildControl(btn_list, "StaticText_KilledBySiege")
  if memberData._isSelf then
    txt_Name:SetFontColor(UI_color.C_FFF5BA3A)
  end
  txt_Name:SetText(memberData._valueName)
  txt_CommandCenter:SetText(memberData._commandPostCount)
  txt_Tower:SetText(memberData._towerCount)
  txt_CastleGate:SetText(memberData._gateCount)
  txt_Summon:SetText(memberData._summonedCount)
  txt_Installation:SetText(memberData._obstacleCount)
  txt_Member:SetText(memberData._killCount)
  txt_Death:SetText(memberData._deathCount)
  txt_KilledBySiege:SetText(memberData._killBySiegeWeaponCount)
end
function GuildWarfareInfo:open()
  _AudioPostEvent_SystemUiForXBOX(8, 14)
  self:pushDataToList()
  _panel:SetShow(true)
end
function GuildWarfareInfo:close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  _panel:SetShow(false)
end
function GuildWarfareInfo:pushDataToList()
  self._ui.list2_WarfareInfo:getElementManager():clearKey()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  local memberCount = myGuildInfo:getMemberCount()
  for memberIdx = 0, memberCount - 1 do
    local myGuildMemberInfo = myGuildInfo:getMember(memberIdx)
    if nil ~= myGuildMemberInfo then
      local data = {
        _valueName = myGuildMemberInfo:getName(),
        _commandPostCount = myGuildMemberInfo:commandPostCount(),
        _towerCount = myGuildMemberInfo:towerCount(),
        _gateCount = myGuildMemberInfo:gateCount(),
        _summonedCount = myGuildMemberInfo:summonedCount(),
        _obstacleCount = myGuildMemberInfo:obstacleCount(),
        _deathCount = myGuildMemberInfo:deathCount(),
        _killBySiegeWeaponCount = myGuildMemberInfo:killBySiegeWeaponCount(),
        _killCount = myGuildMemberInfo:guildMasterCount() + myGuildMemberInfo:squadLeaderCount() + myGuildMemberInfo:squadMemberCount(),
        _isSelf = myGuildMemberInfo:isSelf()
      }
      self._memberData[memberIdx] = data
    end
  end
  for ii = 0, memberCount - 1 do
    self._ui.list2_WarfareInfo:getElementManager():pushKey(toInt64(0, ii))
  end
end
function FromClient_SiegeScoreUpdateData_GuildWarfareInfo_Update()
  if not _parent:GetShow() then
    return
  end
  local self = GuildWarfareInfo
  self:pushDataToList()
end
function PaGlobalFunc_GuildWarfareInfo_Init()
  local self = GuildWarfareInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildWarfareInfo")
    return
  end
  self._parentBg = UI.getChildControl(_parent, "Static_GuildWarfareInfoBg")
  self._parentBg:SetShow(false)
  self._parentBg:MoveChilds(self._parentBg:GetID(), _panel)
  UI.deletePanel(_panel:GetID())
  self:init()
end
function PaGlobalFunc_GuildWarfareInfo_Open()
  local self = GuildWarfareInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildWarfareInfo")
    return
  end
  self:open()
end
function PaGlobalFunc_GuildWarfareInfo_Close()
  local self = GuildWarfareInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : GuildWarfareInfo")
    return
  end
  self:close()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildWarfareInfo_Init")
