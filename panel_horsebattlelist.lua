Panel_HorseBattleList:SetShow(false)
PaGlobal_HorseBattleList = {
  _ui = {
    _list2 = UI.getChildControl(Panel_HorseBattleList, "HorseBattleList"),
    _btn_Confirm = UI.getChildControl(Panel_HorseBattleList, "Button_Confirm"),
    _btn_Close = UI.getChildControl(Panel_HorseBattleList, "Button_Close")
  },
  _listIndex = 0
}
local checkList = {}
local sortByMemberLevel = {}
function PaGlobal_HorseBattleList:HorseBattleList_Initialize()
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  self._ui._list2:getElementManager():clearKey()
  self._ui._list2:setMinScrollBtnSize(minSize)
end
function HorseBattleList_ControlCreate(content, key)
  PaGlobal_HorseBattleList:HorseBattleList_ControlCreate(content, key)
end
function PaGlobal_HorseBattleList:HorseBattleList_ControlCreate(content, key)
  local checkBox = UI.getChildControl(content, "CheckButton_MebmerCheck")
  local index = Int64toInt32(key)
  local name = sortByMemberLevel[index]._name
  local level = sortByMemberLevel[index]._level
  if 0 == level then
    checkBox:SetText("<PAColor0xffc4bebe>" .. "Lv." .. level .. "    " .. name .. "<PAOldColor>")
    checkBox:SetIgnore(true)
  else
    checkBox:SetText("<PAColor0xffffffff>" .. "Lv." .. level .. "    " .. name .. "<PAOldColor>")
    checkBox:SetIgnore(false)
  end
  checkBox:SetShow(true)
  checkBox:SetCheck(checkList[index])
  checkBox:addInputEvent("Mouse_LUp", "PaGlobal_HorseBattleList:HorseBattleList_Update( " .. index .. ")")
end
function PaGlobal_HorseBattleList:HorseBattleList_Update(index)
  checkList[index] = not checkList[index]
end
function FGlobal_Panel_HorseBattleList_Sort(memberMaxCount)
  for memberCount = 0, memberMaxCount - 1 do
    local guildMember = ToClient_GetMyGuildInfoWrapper():getMember(memberCount)
    sortByMemberLevel[memberCount] = {
      _name = guildMember:getName(),
      _level = guildMember:getLevel(),
      _index = memberCount
    }
  end
  local temp
  for memberCount = 0, memberMaxCount - 2 do
    for sortCount = memberCount, memberMaxCount - 1 do
      if sortByMemberLevel[memberCount]._level < sortByMemberLevel[sortCount]._level then
        temp = sortByMemberLevel[memberCount]
        sortByMemberLevel[memberCount] = sortByMemberLevel[sortCount]
        sortByMemberLevel[sortCount] = temp
      end
    end
  end
end
function FGlobal_Panel_HorseBattleList_Open()
  local self = PaGlobal_HorseBattleList
  self._ui._list2:getElementManager():clearKey()
  Panel_HorseBattleList:SetShow(true)
  self._listIndex = 0
  local memberMaxCount = ToClient_GetMyGuildInfoWrapper():getMemberCount()
  FGlobal_Panel_HorseBattleList_Sort(memberMaxCount)
  for memberCount = 0, memberMaxCount - 1 do
    self._ui._list2:getElementManager():pushKey(toInt64(0, memberCount))
    checkList[memberCount] = false
  end
end
function FGlobal_Panel_HorseBattleList_Close()
  checkSize = 0
  firstCheckIndex = -1
  secondCheckIndex = -1
  local self = PaGlobal_HorseBattleList
  self._ui._list2:getElementManager():clearKey()
  Panel_HorseBattleList:SetShow(false)
end
function FGlobal_Panel_HorseBattleList_Confirm()
  local self = PaGlobal_HorseBattleList
  local playerUserNo = 0
  local otherPlayerNo = 0
  local checkCount = 0
  local memberMaxCount = ToClient_GetMyGuildInfoWrapper():getMemberCount()
  for listCount = 0, memberMaxCount - 1 do
    if true == checkList[listCount] then
      checkCount = checkCount + 1
      local guildMember = ToClient_GetMyGuildInfoWrapper():getMember(sortByMemberLevel[listCount]._index)
      if nil ~= guildMember then
        if 0 == playerUserNo then
          playerUserNo = guildMember:getUserNo()
        else
          otherPlayerNo = guildMember:getUserNo()
        end
      end
    end
  end
  if 2 == checkCount then
    FromClient_GuildTeamBattleRequest(playerUserNo, otherPlayerNo)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_NOTMATCH_2"))
  end
end
function FGlobal_Panel_NotifyGuildTeamBattle(msgType, guildName, targetGuildName)
  if 0 == msgType then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_START", "guildName", guildName, "targetGuildName", targetGuildName))
  elseif 1 == msgType then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_WIN", "guildName", guildName, "targetGuildName", targetGuildName))
  elseif 2 == msgType then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_DRAW", "guildName", guildName, "targetGuildName", targetGuildName))
  elseif 3 == msgType then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_NOTMATCH_3", "guildName", guildName, "targetGuildName", targetGuildName))
  end
end
function FGlobal_Panel_NotifyGuildTeamBattleJoin()
  Panel_HorseBattleList:SetShow(false)
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_JOIN"))
end
function FGlobal_Panel_NotifyGuildTeamBattleNotMatch()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILETEAMBATTLE_NOTMATCH_1"))
end
function PaGlobal_HorseBattleList:registEventHandler()
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "HorseBattleList_ControlCreate")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_Panel_HorseBattleList_Close()")
  self._ui._btn_Confirm:addInputEvent("Mouse_LUp", "FGlobal_Panel_HorseBattleList_Confirm()")
  registerEvent("FromClient_OpenGuildTeamBattleMemberList", "FGlobal_Panel_HorseBattleList_Open")
  registerEvent("FromClient_NotifyGuildTeamBattle", "FGlobal_Panel_NotifyGuildTeamBattle")
  registerEvent("FromClient_NotifyGuildTeamBattleJoin", "FGlobal_Panel_NotifyGuildTeamBattleJoin")
  registerEvent("FromClient_NotifyGuildTeamBattleNotMatch", "FGlobal_Panel_NotifyGuildTeamBattleNotMatch")
  registerEvent("FromClient_NotifyGuildTeamBattleUnqualified", "FGlobal_Panel_NotifyGuildTeamBattleUnqualified")
end
PaGlobal_HorseBattleList:registEventHandler()
PaGlobal_HorseBattleList:HorseBattleList_Initialize()
