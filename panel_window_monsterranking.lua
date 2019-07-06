Panel_Window_MonsterRanking:SetShow(false)
PaGlobal_MonsterRanking = {
  _ui = {
    _titleBg = UI.getChildControl(Panel_Window_MonsterRanking, "Static_TitleBG"),
    _titleList2 = UI.getChildControl(Panel_Window_MonsterRanking, "List2_MonsterRankingTitleList"),
    _list2 = UI.getChildControl(Panel_Window_MonsterRanking, "List2_MonsterRankingList"),
    _nameTitle = UI.getChildControl(Panel_Window_MonsterRanking, "StaticText_NameTitle")
  },
  _listIndex = 0
}
PaGlobal_MonsterRanking._ui._btn_Close = UI.getChildControl(PaGlobal_MonsterRanking._ui._titleBg, "Button_Win_Close")
function PaGlobal_MonsterRanking:MonsterRanking_Initialize()
  local minSize = float2()
  minSize.x = 100
  minSize.y = 50
  self._ui._list2:setMinScrollBtnSize(minSize)
end
function FGlobal_MonsterRanking_Open()
  local self = PaGlobal_MonsterRanking
  Panel_Window_MonsterRanking:SetShow(true)
  PaGlobal_MonsterRanking:MonsterRanking_SetPos()
  self._listIndex = 0
  local listMaxCount = ToClient_GetTimeAttackListCount()
  for listCount = 0, listMaxCount - 1 do
    self._ui._titleList2:getElementManager():pushKey(toInt64(0, listCount))
  end
  PaGlobal_MonsterRanking:MonsterRankingList_Update(self._listIndex)
end
function FGlobal_MonsterRanking_Close()
  local self = PaGlobal_MonsterRanking
  self._ui._titleList2:getElementManager():clearKey()
  self._ui._list2:getElementManager():clearKey()
  Panel_Window_MonsterRanking:SetShow(false)
end
function PaGlobal_MonsterRanking:MonsterRanking_SetPos()
  Panel_Window_MonsterRanking:SetPosX(getScreenSizeX() / 2 - Panel_Window_MonsterRanking:GetSizeX() / 2)
  Panel_Window_MonsterRanking:SetPosY(getScreenSizeY() / 2 - Panel_Window_MonsterRanking:GetSizeY() / 2)
end
function PaGlobal_MonsterRanking:MonsterRankingList_Update(listIndex)
  self._listIndex = listIndex
  self._ui._list2:getElementManager():clearKey()
  local titleInfo = ToClient_GetTimeAttackGroupInfo(self._listIndex)
  if nil == titleInfo then
    return
  end
  local isGuild = titleInfo:isGuild()
  if isGuild then
    self._ui._nameTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BOSSRANKING_GUILDNAME"))
  else
    self._ui._nameTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_BOSSRANKING_FAMILYNAME"))
  end
  ToClient_RequestTimeAttackRank(self._listIndex)
end
function FromClient_updateTimeAttackRank()
  local self = PaGlobal_MonsterRanking
  local titleInfo = ToClient_GetTimeAttackGroupInfo(self._listIndex)
  if nil == titleInfo then
    return
  end
  local rankMaxCount = titleInfo:getListCount()
  for rankCount = 0, rankMaxCount - 1 do
    self._ui._list2:getElementManager():pushKey(toInt64(0, rankCount))
  end
end
function MonsterRanking_Title_ListControlCreate(content, key)
  PaGlobal_MonsterRanking:MonsterRanking_Title_ListControlCreate(content, key)
end
function PaGlobal_MonsterRanking:MonsterRanking_Title_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local title = UI.getChildControl(content, "List2_RadioButton_Tab")
  local titleInfo = ToClient_GetTimeAttackGroupInfo(index)
  title:setNotImpactScrollEvent(true)
  if nil == titleInfo then
    return
  end
  title:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  title:SetText(titleInfo:getGroupName())
  if index == self._listIndex then
    title:SetCheck(true)
  else
    title:SetCheck(false)
  end
  title:addInputEvent("Mouse_LUp", "PaGlobal_MonsterRanking:MonsterRankingList_Update( " .. index .. " )")
end
function MonsterRanking_Rank_ListControlCreate(content, key)
  PaGlobal_MonsterRanking:MonsterRanking_Rank_ListControlCreate(content, key)
end
function PaGlobal_MonsterRanking:MonsterRanking_Rank_ListControlCreate(content, key)
  local index = Int64toInt32(key)
  local rank = UI.getChildControl(content, "StaticText_List2_Rank")
  local name = UI.getChildControl(content, "StaticText_List2_Name")
  local time = UI.getChildControl(content, "StaticText_List2_Time")
  local titleInfo = ToClient_GetTimeAttackGroupInfo(self._listIndex)
  local rankMaxCount = titleInfo:getListCount()
  local rankInfo = titleInfo:getAt(index)
  local isGuild = titleInfo:isGuild()
  name:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(name, 183, 1, 188, 6)
  name:getBaseTexture():setUV(x1, y1, x2, y2)
  name:setRenderTexture(name:getBaseTexture())
  if isGuild then
    local guildNo_s64 = rankInfo:getOwnerNo()
    local isSet = setGuildTextureByGuildNo(guildNo_s64, name)
    if isSet then
      name:getBaseTexture():setUV(0, 0, 1, 1)
      name:setRenderTexture(name:getBaseTexture())
    end
  end
  local rankTime = rankInfo:getCompleteTime()
  if 0 == index then
    rank:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_03.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(rank, 51, 81, 87, 112)
    rank:getBaseTexture():setUV(x1, y1, x2, y2)
    rank:setRenderTexture(rank:getBaseTexture())
    rank:SetText("")
    name:SetFontColor(Defines.Color.C_FFD20000)
    time:SetFontColor(Defines.Color.C_FFD20000)
  elseif 1 == index then
    rank:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_03.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(rank, 51, 113, 86, 141)
    rank:getBaseTexture():setUV(x1, y1, x2, y2)
    rank:setRenderTexture(rank:getBaseTexture())
    rank:SetText("")
    name:SetFontColor(Defines.Color.C_FFA3EF00)
    time:SetFontColor(Defines.Color.C_FFA3EF00)
  elseif 2 == index then
    rank:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Etc_03.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(rank, 87, 113, 121, 143)
    rank:getBaseTexture():setUV(x1, y1, x2, y2)
    rank:setRenderTexture(rank:getBaseTexture())
    rank:SetText("")
    name:SetFontColor(Defines.Color.C_FF00C0D7)
    time:SetFontColor(Defines.Color.C_FF00C0D7)
  else
    rank:ChangeTextureInfoName("")
    name:SetFontColor(Defines.Color.C_FFFFFFFF)
    time:SetFontColor(Defines.Color.C_FFFFFFFF)
    local highRankInfo = titleInfo:getAt(index - 1)
    local highRankTime = highRankInfo:getCompleteTime()
    if highRankTime == rankTime then
      rank:SetText(" - ")
    else
      rank:SetText(index + 1)
    end
  end
  rankTime = Int64toInt32(rankTime)
  name:SetText(rankInfo:getName())
  name:SetPosX(245 - (name:GetSizeX() + name:GetTextSizeX() + 40) / 2)
  time:SetText(Util.Time.timeFormatting(rankTime))
end
function PaGlobal_MonsterRanking:registEventHandler()
  self._ui._titleList2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "MonsterRanking_Title_ListControlCreate")
  self._ui._titleList2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "MonsterRanking_Rank_ListControlCreate")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui._btn_Close:addInputEvent("Mouse_LUp", "FGlobal_MonsterRanking_Close()")
  registerEvent("FromClient_updateTimeAttackRank", "FromClient_updateTimeAttackRank")
end
PaGlobal_MonsterRanking:registEventHandler()
PaGlobal_MonsterRanking:MonsterRanking_Initialize()
