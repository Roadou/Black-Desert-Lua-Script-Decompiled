local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local IM = CppEnums.EProcessorInputMode
local GST = CppEnums.GameServiceType
Panel_Guild_Rank:SetShow(false, false)
Panel_Guild_Rank:RegisterShowEventFunc(true, "GuildRankingShowAni()")
Panel_Guild_Rank:RegisterShowEventFunc(false, "GuildRankingHideAni()")
Panel_Guild_Rank:setGlassBackground(true)
Panel_Guild_Rank:ActiveMouseEventEffect(true)
function GuildRankingShowAni()
  UIAni.fadeInSCR_Down(Panel_Guild_Rank)
  local aniInfo1 = Panel_Guild_Rank:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_Guild_Rank:GetSizeX() / 2
  aniInfo1.AxisY = Panel_Guild_Rank:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_Guild_Rank:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_Guild_Rank:GetSizeX() / 2
  aniInfo2.AxisY = Panel_Guild_Rank:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function GuildRankingHideAni()
  local aniInfo1 = Panel_Guild_Rank:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local guildRanking = {
  _btnClose = UI.getChildControl(Panel_Guild_Rank, "Button_Win_Close"),
  _btnHelp = UI.getChildControl(Panel_Guild_Rank, "Button_Question"),
  _txtTitle = UI.getChildControl(Panel_Guild_Rank, "StaticText_Title"),
  _scroll = UI.getChildControl(Panel_Guild_Rank, "Scroll_RankingList"),
  _listBg = UI.getChildControl(Panel_Guild_Rank, "Static_RankListBG"),
  guildRankNum = UI.getChildControl(Panel_Guild_Rank, "StaticText_RankNum"),
  guildRankGuildName = UI.getChildControl(Panel_Guild_Rank, "StaticText_GuildName"),
  guildRankFamilyName = UI.getChildControl(Panel_Guild_Rank, "StaticText_FamilyName"),
  iconSerendia = UI.getChildControl(Panel_Guild_Rank, "Static_Serendia"),
  iconBalenos = UI.getChildControl(Panel_Guild_Rank, "Static_Balenos"),
  iconKalpeon = UI.getChildControl(Panel_Guild_Rank, "Static_Kalpeon"),
  iconMedia = UI.getChildControl(Panel_Guild_Rank, "Static_Media"),
  iconBalencia = UI.getChildControl(Panel_Guild_Rank, "Static_Balencia"),
  guildRankNode = UI.getChildControl(Panel_Guild_Rank, "StaticText_NodeOccupation"),
  guildDuelWar = UI.getChildControl(Panel_Guild_Rank, "StaticText_GuildDuelWar"),
  guildRankPersonnel = UI.getChildControl(Panel_Guild_Rank, "StaticText_Personnel"),
  guildRankPoint = UI.getChildControl(Panel_Guild_Rank, "StaticText_GuildPoint"),
  _createListCount = 23,
  territoryCount = 4,
  _listCount = 0,
  _startIndex = 0,
  _selectPage = 0,
  _selectMaxPage = 0,
  _listPool = {},
  _posConfig = {
    _listStartPosY = 128,
    _iconStartPosY = 128,
    _listPosYGap = 19.7
  }
}
local radioBtn_GuildName = UI.getChildControl(Panel_Guild_Rank, "RadioButton_GuildName")
local editBox_Search = UI.getChildControl(Panel_Guild_Rank, "Edit_Naming")
local btn_Search = UI.getChildControl(Panel_Guild_Rank, "Button_Search")
editBox_Search:addInputEvent("Mouse_LUp", "HandleClicked_GuildSearch_EditBox()")
btn_Search:addInputEvent("Mouse_LUp", "GuildSearch_Confirm()")
function HandleClicked_GuildSearch_EditBox()
  editBox_Search:SetMaxInput(10)
  SetFocusEdit(editBox_Search)
  editBox_Search:SetEditText("", true)
end
function GuildSearch_Confirm()
  local guildName = editBox_Search:GetEditText()
  if "" == guildName or nil == guildName then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_SERACHALERT"))
    return
  end
  ToClient_RequestGuildWebInfoByName(guildName)
  ClearFocusEdit()
end
function FGlobal_CheckEditBox_GuildRank(uiEditBox)
  return nil ~= uiEditBox and nil ~= editBox_Search and uiEditBox:GetKey() == editBox_Search:GetKey() and Panel_Guild_Rank:GetShow()
end
function FGlobal_EscapeEditBox_GuildRank(bool)
  ClearFocusEdit(editBox_Search)
end
local _txt_page = UI.getChildControl(Panel_Guild_Rank, "Static_PageNo")
local _btn_Prev = UI.getChildControl(Panel_Guild_Rank, "Button_Prev")
local _btn_Next = UI.getChildControl(Panel_Guild_Rank, "Button_Next")
local _web_Desc = UI.getChildControl(Panel_Guild_Rank, "StaticText_Web_Desc")
function guildRanking_Initionalize()
  if 0 == getGameServiceType() or 1 == getGameServiceType() or 2 == getGameServiceType() or 3 == getGameServiceType() or 4 == getGameServiceType() then
    _web_Desc:SetShow(true)
  else
    _web_Desc:SetShow(false)
  end
  local self = guildRanking
  for listIdx = 0, self._createListCount - 1 do
    local rankList = {}
    rankList.rank = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_RankNum", Panel_Guild_Rank, "guildRanking_Rank_" .. listIdx)
    rankList.rank:SetPosX(47)
    rankList.rank:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.guild = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_GuildName", Panel_Guild_Rank, "guildRanking_Name_" .. listIdx)
    rankList.guild:SetPosX(80)
    rankList.guild:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.guild:SetIgnore(false)
    rankList.guild:SetEnableArea(0, 0, 190, 15)
    rankList.familyName = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_FamilyName", Panel_Guild_Rank, "guildRanking_Guild_" .. listIdx)
    rankList.familyName:SetPosX(260)
    rankList.familyName:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.icon1 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "Static_Serendia", Panel_Guild_Rank, "guildRanking_IconSerendia_" .. listIdx)
    rankList.icon1:SetPosX(430)
    rankList.icon1:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.icon2 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "Static_Balenos", Panel_Guild_Rank, "guildRanking_IconBalenos_" .. listIdx)
    rankList.icon2:SetPosX(497)
    rankList.icon2:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.icon3 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "Static_Kalpeon", Panel_Guild_Rank, "guildRanking_IconKalpeon_" .. listIdx)
    rankList.icon3:SetPosX(522)
    rankList.icon3:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.icon4 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "Static_Media", Panel_Guild_Rank, "guildRanking_IconMedia_" .. listIdx)
    rankList.icon4:SetPosX(547)
    rankList.icon4:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.icon5 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "Static_Balencia", Panel_Guild_Rank, "guildRanking_IconBalencia_" .. listIdx)
    rankList.icon5:SetPosX(572)
    rankList.icon5:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.dash1 = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_Dash1", Panel_Guild_Rank, "guildRanking_DashSerendia_" .. listIdx)
    rankList.dash1:SetPosX(469)
    rankList.dash1:SetPosY(self._posConfig._iconStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.node = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_NodeOccupation", Panel_Guild_Rank, "guildRanking_Node_" .. listIdx)
    rankList.node:SetPosX(550)
    rankList.node:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.duelWar = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_GuildDuelWar", Panel_Guild_Rank, "guildRanking_DuelWar_" .. listIdx)
    rankList.duelWar:SetPosX(630)
    rankList.duelWar:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.personnel = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_Personnel", Panel_Guild_Rank, "guildRanking_Personnel_" .. listIdx)
    rankList.personnel:SetPosX(710)
    rankList.personnel:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    rankList.point = UI.createAndCopyBasePropertyControl(Panel_Guild_Rank, "StaticText_GuildPoint", Panel_Guild_Rank, "guildRanking_GuildPoint_" .. listIdx)
    rankList.point:SetPosX(785)
    rankList.point:SetPosY(self._posConfig._listStartPosY + self._posConfig._listPosYGap * listIdx)
    self._listPool[listIdx] = rankList
  end
  _btn_Next:SetAutoDisableTime(3)
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_Guild_Rank:SetPosX((screenSizeX - Panel_Guild_Rank:GetSizeX()) / 2)
  Panel_Guild_Rank:SetPosY((screenSizeY - Panel_Guild_Rank:GetSizeY()) / 2)
end
function guildRanking:Update()
  for listIdx = 0, self._createListCount - 1 do
    local list = self._listPool[listIdx]
    list.rank:SetShow(false)
    list.guild:SetShow(false)
    list.familyName:SetShow(false)
    list.icon1:SetShow(false)
    list.icon2:SetShow(false)
    list.icon3:SetShow(false)
    list.icon4:SetShow(false)
    list.icon5:SetShow(false)
    list.dash1:SetShow(false)
    list.node:SetShow(false)
    list.duelWar:SetShow(false)
    list.personnel:SetShow(false)
    list.point:SetShow(false)
  end
  local startSlotNo = 0
  local endSlotNo = 0
  startSlotNo = 0
  endSlotNo = 23
  local maxCount = 400
  self._selectMaxPage = math.floor(maxCount / self._createListCount) - 1
  if 0 < maxCount % self._createListCount then
    self._selectMaxPage = self._selectMaxPage + 1
  end
  self._listCount = ToClient_GetGuildCount()
  local count = 0
  for listIdx = startSlotNo, self._listCount - 1 do
    local guildRanker = ToClient_GetGuildRankingInfoAt(listIdx)
    local guildRankerGuildMark_s64 = guildRanker:getGuildNo_s64()
    local guildRankerGuild = guildRanker:getGuildName()
    local guildRankerMasterName = guildRanker:getGuildMasterNickName()
    local guildRankerTerritoryCount = guildRanker:getTerritoryCount()
    local guildRankerNodeCount = guildRanker:getSiegeCount()
    local guildRankerMemberCount = guildRanker._guildMemberCount
    local guildRankerAquirePorint = guildRanker._guildAquiredPoint
    local guildIntroduce = guildRanker:getGuildIntroduction()
    local loadComplete = guildRanker:isLoadComplete()
    local guildDuelWarWin = guildRanker:getGuildDuelWinCount()
    local guildDuelWarLose = guildRanker:getGuildDuelLoseCount()
    if count >= self._createListCount then
      break
    end
    local list = self._listPool[count]
    list.rank:SetShow(true)
    list.guild:SetShow(true)
    list.familyName:SetShow(true)
    list.dash1:SetShow(true)
    list.node:SetShow(true)
    list.duelWar:SetShow(true)
    list.personnel:SetShow(true)
    list.point:SetShow(true)
    list.icon1:SetShow(false)
    list.icon2:SetShow(false)
    list.icon3:SetShow(false)
    list.icon4:SetShow(false)
    list.icon5:SetShow(false)
    list.rank:SetFontColor(UI_color.C_FFC4BEBE)
    list.guild:SetFontColor(UI_color.C_FFC4BEBE)
    list.familyName:SetFontColor(UI_color.C_FFC4BEBE)
    list.duelWar:SetFontColor(UI_color.C_FFC4BEBE)
    list.personnel:SetFontColor(UI_color.C_FFC4BEBE)
    list.point:SetFontColor(UI_color.C_FFC4BEBE)
    list.rank:SetText(listIdx + 1 + self._selectPage * endSlotNo)
    local isSet = setGuildTextureByGuildNo(guildRankerGuildMark_s64, list.guild)
    if false == isSet then
      list.guild:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(list.guild, 183, 1, 188, 6)
      list.guild:getBaseTexture():setUV(x1, y1, x2, y2)
      list.guild:setRenderTexture(list.guild:getBaseTexture())
    else
      list.guild:getBaseTexture():setUV(0, 0, 1, 1)
      list.guild:setRenderTexture(list.guild:getBaseTexture())
    end
    if loadComplete then
      list.guild:SetText(guildRankerGuild)
    else
      list.guild:SetText("Loading...")
    end
    list.familyName:SetText(guildRankerMasterName)
    list.guild:addInputEvent("Mouse_LUp", "FGlobal_GuildWebInfo_Open( " .. listIdx .. " )")
    list.guild:addInputEvent("Mouse_On", "GuildRank_Tooltip(true, " .. listIdx .. ")")
    list.guild:addInputEvent("Mouse_Out", "GuildRank_Tooltip(false, " .. listIdx .. ")")
    list.guild:setTooltipEventRegistFunc("GuildRank_Tooltip(true, " .. listIdx .. ")")
    list.icon1:SetShow(false)
    list.icon2:SetShow(false)
    list.icon3:SetShow(false)
    list.icon4:SetShow(false)
    list.icon5:SetShow(false)
    local guildRankerTerritory = -1
    local iconPosX = 430
    local occupationCount = 0
    for i = 0, self.territoryCount - 1 do
      guildRankerTerritory = guildRanker:getTerritoryKeyAt(i)
      if 0 == guildRankerTerritory then
        list.icon2:SetShow(true)
        list.dash1:SetShow(false)
        list.icon2:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 0, " .. listIdx .. ")")
        list.icon2:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
        list.icon2:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 0, " .. listIdx .. ")")
        occupationCount = occupationCount + 1
      end
      if 1 == guildRankerTerritory then
        list.icon1:SetShow(true)
        list.dash1:SetShow(false)
        list.icon1:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 1, " .. listIdx .. ")")
        list.icon1:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
        list.icon1:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 1, " .. listIdx .. ")")
        occupationCount = occupationCount + 1
      end
      if 2 == guildRankerTerritory then
        list.icon3:SetShow(true)
        list.dash1:SetShow(false)
        list.icon3:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 2, " .. listIdx .. ")")
        list.icon3:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
        list.icon3:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 2, " .. listIdx .. ")")
        occupationCount = occupationCount + 1
      end
      if 3 == guildRankerTerritory then
        list.icon4:SetShow(true)
        list.dash1:SetShow(false)
        list.icon4:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 3, " .. listIdx .. ")")
        list.icon4:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
        list.icon4:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 3, " .. listIdx .. ")")
        occupationCount = occupationCount + 1
      end
      if 4 == guildRankerTerritory then
        list.icon5:SetShow(true)
        list.dash1:SetShow(false)
        list.icon5:addInputEvent("Mouse_On", "guildRanking_SimpleTooltips( true, 4, " .. listIdx .. ")")
        list.icon5:addInputEvent("Mouse_Out", "guildRanking_SimpleTooltips( false )")
        list.icon5:setTooltipEventRegistFunc("guildRanking_SimpleTooltips( true, 4, " .. listIdx .. ")")
        occupationCount = occupationCount + 1
      end
      if 0 == occupationCount then
        iconPosX = 470
      elseif 1 == occupationCount then
        iconPosX = 467
      elseif 2 == occupationCount then
        iconPosX = 453
      elseif 3 == occupationCount then
        iconPosX = 440
      elseif 4 == occupationCount then
        iconPosX = 430
      end
      if list.icon1:GetShow() then
        list.icon1:SetPosX(iconPosX)
        iconPosX = iconPosX + 25
      end
      if list.icon2:GetShow() then
        list.icon2:SetPosX(iconPosX)
        iconPosX = iconPosX + 25
      end
      if list.icon3:GetShow() then
        list.icon3:SetPosX(iconPosX)
        iconPosX = iconPosX + 25
      end
      if list.icon4:GetShow() then
        list.icon4:SetPosX(iconPosX)
        iconPosX = iconPosX + 25
      end
      if list.icon5:GetShow() then
        list.icon5:SetPosX(iconPosX)
        iconPosX = iconPosX + 25
      end
    end
    list.node:SetText(guildRankerNodeCount)
    list.duelWar:SetText("<PAColor0xff00c0d7>" .. guildDuelWarWin .. "<PAOldColor>")
    list.personnel:SetText(guildRankerMemberCount)
    list.point:SetText(guildRankerAquirePorint)
    count = count + 1
  end
  if 16 == self._selectPage + 1 then
    _btn_Next:SetIgnore(true)
  else
    _btn_Next:SetIgnore(false)
  end
  if 1 == self._selectPage + 1 then
    _btn_Prev:SetIgnore(true)
  else
    _btn_Prev:SetIgnore(false)
  end
  _txt_page:SetText(self._selectPage + 1)
end
function GuildRank_Tooltip(isShow, index)
  local self = guildRanking
  local guildRanker = ToClient_GetGuildRankingInfoAt(index)
  local guildRankerGuildMark_s64 = guildRanker:getGuildNo_s64()
  local guildRankerGuild = guildRanker:getGuildName()
  local guildRankerMasterName = guildRanker:getGuildMasterNickName()
  local guildRankerTerritoryCount = guildRanker:getTerritoryCount()
  local guildRankerNodeCount = guildRanker:getSiegeCount()
  local guildRankerMemberCount = guildRanker._guildMemberCount
  local guildRankerAquirePorint = guildRanker._guildAquiredPoint
  local guildIntroduce = guildRanker:getGuildIntroduction()
  local list = self._listPool[index].guild
  registTooltipControl(list, Panel_Tooltip_Guild_Introduce)
  if true == isShow then
    TooltipGuild_Show(list, guildRankerGuildMark_s64, guildRankerGuild, guildRankerMasterName, guildIntroduce)
  else
    TooltipGuild_Hide()
  end
end
function FromClient_UpdateGuildRank(page)
  local guildCount = ToClient_GetGuildCount()
  local self = guildRanking
  if 0 == guildCount then
    self._selectPage = self._selectPage - 1
    return
  end
  self._selectPage = page
  audioPostEvent_SystemUi(1, 0)
  _AudioPostEvent_SystemUiForXBOX(1, 0)
  self:Update()
end
function FGlobal_guildRanking_Open()
  local self = guildRanking
  if Panel_Guild_Rank:GetShow() then
    Panel_Guild_Rank:SetShow(false, false)
    ClearFocusEdit()
  else
    Panel_Guild_Rank:SetShow(true, true)
  end
  ToClient_RequestGuildRanking(0)
  self:Update()
  editBox_Search:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_SERACHALERT"))
  radioBtn_GuildName:SetCheck(true)
end
function FGlobal_guildRanking_Close()
  Panel_Guild_Rank:SetShow(false, false)
  ClearFocusEdit()
  TooltipSimple_Hide()
  TooltipGuild_Hide()
end
function guildRanking_NextBtn()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  local self = guildRanking
  if self._selectMaxPage <= self._selectPage then
    return
  end
  self._selectPage = self._selectPage + 1
  ToClient_RequestGuildRanking(self._selectPage)
end
function guildRanking_PrevBtn()
  audioPostEvent_SystemUi(0, 0)
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  _btn_Prev:DoAutoDisableTime()
  local self = guildRanking
  if 0 < self._selectPage then
    self._selectPage = self._selectPage - 1
  end
  ToClient_RequestGuildRanking(self._selectPage)
end
function guildRanking_SimpleTooltips(isShow, terriType, listIdx)
  local self = guildRanking
  local name, desc, uiControl
  local list = self._listPool[listIdx]
  if 0 == terriType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENOS_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENOS_DESC")
    uiControl = list.icon1
  elseif 1 == terriType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_SERENDIA_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_SERENDIA_DESC")
    uiControl = list.icon2
  elseif 2 == terriType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_KALPEON_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_KALPEON_DESC")
    uiControl = list.icon3
  elseif 3 == terriType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_MEDIA_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_MEDIA_DESC")
    uiControl = list.icon4
  elseif 4 == terriType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENCIA_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDRANK_TOOLTIP_BALENCIA_DESC")
    uiControl = list.icon5
  end
  if isShow == true then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function GuildRank_Repos()
  local screenSizeX = getScreenSizeX()
  local screenSizeY = getScreenSizeY()
  Panel_Guild_Rank:SetPosX((screenSizeX - Panel_Guild_Rank:GetSizeX()) / 2)
  Panel_Guild_Rank:SetPosY((screenSizeY - Panel_Guild_Rank:GetSizeY()) / 2)
end
function guildRanking_registEventHandler()
  local self = guildRanking
  self._btnClose:addInputEvent("Mouse_LUp", "FGlobal_guildRanking_Close()")
  _btn_Next:addInputEvent("Mouse_LUp", "guildRanking_NextBtn()")
  _btn_Prev:addInputEvent("Mouse_LUp", "guildRanking_PrevBtn()")
  guildRanking._btnHelp:SetShow(false)
end
function guildRanking_registMessageHandler()
  registerEvent("onScreenResize", "GuildRank_Repos")
  registerEvent("FromClient_UpdateGuildRank", "FromClient_UpdateGuildRank")
end
guildRanking_Initionalize()
guildRanking_registEventHandler()
guildRanking_registMessageHandler()
Panel_GuildRank_Web:SetShow(false, false)
Panel_GuildRank_Web:RegisterShowEventFunc(true, "WebGuildRankingShowAni()")
Panel_GuildRank_Web:RegisterShowEventFunc(false, "WebGuildRankingHideAni()")
Panel_GuildRank_Web:setGlassBackground(true)
Panel_GuildRank_Web:ActiveMouseEventEffect(true)
function WebGuildRankingShowAni()
  UIAni.fadeInSCR_Down(Panel_GuildRank_Web)
  local aniInfo1 = Panel_GuildRank_Web:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.2)
  aniInfo1.AxisX = Panel_GuildRank_Web:GetSizeX() / 2
  aniInfo1.AxisY = Panel_GuildRank_Web:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_GuildRank_Web:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.2)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_GuildRank_Web:GetSizeX() / 2
  aniInfo2.AxisY = Panel_GuildRank_Web:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function WebGuildRankingHideAni()
  local aniInfo1 = Panel_GuildRank_Web:addColorAnimation(0, 0.1, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local titleBG = UI.getChildControl(Panel_GuildRank_Web, "Static_TitleBG")
local webClose = UI.getChildControl(titleBG, "Button_Win_Close")
local webHelp = UI.getChildControl(titleBG, "Button_Question")
local rankBg = UI.getChildControl(Panel_GuildRank_Web, "Static_RankListBG")
rankBg:SetShow(false)
webHelp:SetShow(false)
local _Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, Panel_GuildRank_Web, "WebControl_GuildRank_WebLink")
_Web:SetShow(true)
_Web:SetPosX(20)
_Web:SetPosY(67)
_Web:SetSize(890, 645)
_Web:ResetUrl()
webClose:addInputEvent("Mouse_LUp", "GuildRank_Web_Close()")
function GuildRank_Web_Show()
  if not Panel_GuildRank_Web:GetShow() then
    Panel_GuildRank_Web:SetShow(true, true)
    FGlobal_ClearCandidate()
    _Web:ResetUrl()
    FGlobal_SetCandidate()
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    local userNo = selfPlayer:get():getUserNo()
    local cryptKey = selfPlayer:get():getWebAuthenticKeyCryptString()
    local temporaryWrapper = getTemporaryInformationWrapper()
    local worldNo = temporaryWrapper:getSelectedWorldServerNo()
    local gameServiceType = getGameServiceType()
    local url = PaGlobal_URL_Check(worldNo)
    url = url .. "/GuildRank?userNo=" .. tostring(userNo) .. "&certKey=" .. tostring(cryptKey)
    _Web:SetUrl(890, 645, url, false, true)
    _Web:SetIME(true)
    audioPostEvent_SystemUi(1, 0)
    _AudioPostEvent_SystemUiForXBOX(1, 0)
  end
end
function GuildRank_Web_Close()
  Panel_GuildRank_Web:SetShow(false, true)
  FGlobal_ClearCandidate()
  _Web:ResetUrl()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
