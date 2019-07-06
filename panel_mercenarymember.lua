local CT_STRING = CppEnums.ClassType2String
Panel_Window_MercenaryList:SetShow(false)
local enTerritoryString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_4")
}
local mercenaryList = {
  _ui = {
    _list2_Member,
    _text_MilitiaName,
    _text_Count,
    _text_TopGuide,
    _btn_exit,
    _btn_Attack,
    _btn_TerritoryBG
  },
  _isStart = false,
  _listCount = 0,
  _isAttackTeam = false,
  _currnetTerritory = 0,
  _territoryName,
  _realMemberCount = 0,
  _memberLimit = 50,
  _myName,
  _lastTick = 0
}
function mercenaryList:Initialize()
  self._ui._list2_Member = UI.getChildControl(Panel_Window_MercenaryList, "List2_MilitiaList")
  self._ui._list2_Member:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2_Member:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_MercenaryMember_UpdateList")
  self._ui._text_MilitiaName = UI.getChildControl(Panel_Window_MercenaryList, "StaticText_MilitiaName")
  self._ui._text_Count = UI.getChildControl(Panel_Window_MercenaryList, "StaticText_Count")
  self._ui._text_TopGuide = UI.getChildControl(Panel_Window_MercenaryList, "StaticText_TopGuide")
  self._ui._btn_exit = UI.getChildControl(Panel_Window_MercenaryList, "Button_Close")
  self._ui._btn_exit:addInputEvent("Mouse_LUp", "PaGlobal_MercenaryList_Window_Close()")
  self._ui._btn_Attack = UI.getChildControl(Panel_Window_MercenaryList, "Button_Attack")
  self._ui._btn_TerritoryBG = UI.getChildControl(Panel_Window_MercenaryList, "Static_TerritoryBG")
end
function PaGlobal_MercenaryList_Window_Open()
  if false == getSelfPlayer():get():isVolunteer() then
    return
  end
  local self = mercenaryList
  local volunteerInfo
  self._listCount = 0
  local memberCount = ToClient_GetOnlineVolunteerListCount()
  self._isAttackTeam = getSelfPlayer():get():isVolunteerAttackTeam()
  self._currentTerritory = getSelfPlayer():get():getVolunteerTerritorKeyForLua()
  self._realMemberCount = memberCount
  self._ui._list2_Member:getElementManager():clearKey()
  for index = 0, memberCount - 1 do
    volunteerInfo = nil
    volunteerInfo = ToClient_GetOnlineVolunteerInfoIndex(index)
    if nil ~= volunteerInfo then
      self._ui._list2_Member:getElementManager():pushKey(index)
    end
  end
  self._ui._text_MilitiaName:SetText(enTerritoryString[self._currentTerritory] .. " " .. self:getAttackName() .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MERCENARY_TITLE"))
  self._ui._text_Count:SetText("\236\176\184\236\151\172\236\157\184\236\155\144 : " .. tostring(memberCount) .. " \235\170\133")
  self._ui._text_TopGuide:SetText("")
  self:ChangeMillitiaTeam()
  Panel_Window_MercenaryList:SetShow(true)
end
function mercenaryList:ChangeMillitiaTeam()
  local x1, y1, x2, y2, x3, y3, x4, y4
  if true == self._isAttackTeam then
    x1, y1, x2, y2 = setTextureUV_Func(self._ui._btn_Attack, 2, 2, 76, 96)
  else
    x1, y1, x2, y2 = setTextureUV_Func(self._ui._btn_Attack, 2, 98, 76, 194)
  end
  if 0 == self._currentTerritory then
    x3, y3, x4, y4 = setTextureUV_Func(self._ui._btn_TerritoryBG, 1, 320, 478, 400)
  elseif 1 == self._currentTerritory then
    x3, y3, x4, y4 = setTextureUV_Func(self._ui._btn_TerritoryBG, 1, 2, 478, 80)
  elseif 2 == self._currentTerritory then
    x3, y3, x4, y4 = setTextureUV_Func(self._ui._btn_TerritoryBG, 1, 2, 478, 80)
  elseif 3 == self._currentTerritory then
    x3, y3, x4, y4 = setTextureUV_Func(self._ui._btn_TerritoryBG, 1, 160, 478, 240)
  elseif 4 == self._currentTerritory then
    x3, y3, x4, y4 = setTextureUV_Func(self._ui._btn_TerritoryBG, 1, 2, 478, 80)
  end
  self._ui._btn_TerritoryBG:getBaseTexture():setUV(x3, y3, x4, y4)
  self._ui._btn_TerritoryBG:setRenderTexture(self._ui._btn_TerritoryBG:getBaseTexture())
  self._ui._btn_Attack:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._btn_Attack:setRenderTexture(self._ui._btn_Attack:getBaseTexture())
  self._ui._btn_Attack:SetText(self:getAttackName())
end
function PaGlobal_MercenaryList_Window_Close()
  Panel_Window_MercenaryList:SetShow(false)
end
function mercenaryList:getAttackName()
  if true == self._isAttackTeam then
    return PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MERCENARY_ATTACKTITLE")
  else
    return PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MERCENARY_DEFFENCETITLE")
  end
end
function PaGlobal_MercenaryMember_UpdateList(content, key)
  local self = mercenaryList
  local index = Int64toInt32(key)
  local Text_level = UI.getChildControl(content, "StaticText_Level")
  local Text_classType = UI.getChildControl(content, "StaticText_Class")
  local Text_name = UI.getChildControl(content, "StaticText_CharacterName")
  local volunteerInfo = ToClient_GetOnlineVolunteerInfoIndex(index)
  Text_name:SetText(volunteerInfo:getCharacterName())
  Text_classType:SetText(CT_STRING[volunteerInfo:getClassType()])
  Text_level:SetText(volunteerInfo:getLevel())
end
function FromClient_StartMercenaryMemberList()
end
function FromClient_EndMercenaryMemberList()
  local self = mercenaryList
  self._isStart = false
end
function mercenaryList:registerEvent()
  registerEvent("FromClient_StartMercenaryMemberList", "FromClient_StartMercenaryMemberList")
  registerEvent("FromClient_EndMercenaryMemberList", "FromClient_EndMercenaryMemberList")
  registerEvent("FromClient_CompleteRefresh", "PaGlobal_MercenaryList_Window_Open")
end
mercenaryList:Initialize()
mercenaryList:registerEvent()
function PaGlobal_MercenaryList_Refresh()
  ToClient_RequestOnlineVolunteerList()
end
function mercenaryList:Start()
  self:Initialize()
  PaGlobal_MercenaryMember_UpdateList()
  PaGlobal_MercenaryList_Window_Open()
end
function mercenaryList:End()
  PaGlobal_MercenaryList_Window_Close()
end
function Test_mcupdate()
  mercenaryList:Start()
end
function Test_RequestMember()
  local selfPlayer = getSelfPlayer():get()
  local myTerritoryKey = selfPlayer:getVolunteerTerritorKeyForLua()
  mercenaryList._isAttackTeam = selfPlayer:isVolunteerAttackTeam()
  mercenaryList._currentTerritory = myTerritoryKey
  mercenaryList._territoryName = ToClient_GetRegionNameByRegionKey(myTerritoryKey)
  ToClient_RequestOnlineVolunteerList()
end
function Test_Open(isbool)
  Panel_Window_MercenaryList:SetShow(isbool)
end
function testShow(bool)
  local self = mercenaryList
  self._isAttackTeam = bool
  self:ChangeMillitiaTeam()
  Panel_Window_MercenaryList:SetShow(true)
end
