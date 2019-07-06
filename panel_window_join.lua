local UIMode = Defines.UIMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
Panel_Join:SetShow(false, false)
Panel_Join:setMaskingChild(true)
Panel_Join:ActiveMouseEventEffect(true)
Panel_Join:setGlassBackground(true)
Panel_Join:RegisterShowEventFunc(true, "Panel_Join_ShowAni()")
Panel_Join:RegisterShowEventFunc(false, "Panel_Join_HideAni()")
function Panel_Join_ShowAni()
end
function Panel_Join_HideAni()
end
local join = {
  radioBtn = {
    [0] = UI.getChildControl(Panel_Join, "RadioButton_LocalWar"),
    [1] = UI.getChildControl(Panel_Join, "RadioButton_Colosseum")
  },
  _index = 0,
  _conditionCheck = true,
  _mainBg = UI.getChildControl(Panel_Join, "Static_BG"),
  _title = UI.getChildControl(Panel_Join, "StaticText_ContentTitle"),
  _titleBg = UI.getChildControl(Panel_Join, "Static_BG_1"),
  _headIcon = UI.getChildControl(Panel_Join, "Static_HeadIcon"),
  _myRank = UI.getChildControl(Panel_Join, "StaticText_MyRank"),
  _myPoint = UI.getChildControl(Panel_Join, "StaticText_MyPoint"),
  _condition = UI.getChildControl(Panel_Join, "StaticText_Condition"),
  _ruleTitle = UI.getChildControl(Panel_Join, "StaticText_RuleTitle"),
  _ruleBg = UI.getChildControl(Panel_Join, "Static_BG_2"),
  _ruleContent = UI.getChildControl(Panel_Join, "StaticText_RuleContent"),
  _rewardTitle = UI.getChildControl(Panel_Join, "StaticText_RewardTitle"),
  _rewardBg = UI.getChildControl(Panel_Join, "Static_BG_3"),
  _rewardContent = UI.getChildControl(Panel_Join, "StaticText_RewardContent"),
  btn_Join = UI.getChildControl(Panel_Join, "Button_Join"),
  btn_Rank = UI.getChildControl(Panel_Join, "Button_Rank"),
  btn_Close = UI.getChildControl(Panel_Join, "Button_Close")
}
join._ruleContent:SetTextMode(UI_TM.eTextMode_AutoWrap)
join._rewardContent:SetTextMode(UI_TM.eTextMode_AutoWrap)
local localWar = {
  _title = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE"),
  _condition = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CONDITION"),
  _iconTextureUrl = "New_UI_Common_ForLua/Window/Join/localwar.dds",
  _rule = {
    [0] = "\236\178\180\237\129\172\236\154\169 \235\141\148\235\175\184",
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE3"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE4"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE5"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE6"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE7"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE8"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_RULE10")
  },
  _reward = {
    [0] = "\236\178\180\237\129\172\236\154\169 \235\141\148\235\175\184",
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_REWARD1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_REWARD_3")
  }
}
local colosseum = {
  _title = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_TITLE"),
  _condition = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_CONDITION"),
  _iconTextureUrl = "New_UI_Common_ForLua/Window/Join/colosseum.dds",
  _rule = {
    [0] = "\236\178\180\237\129\172\236\154\169 \235\141\148\235\175\184",
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_1"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_2"),
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_RULE_3")
  },
  _reward = {
    [0] = "\236\178\180\237\129\172\236\154\169 \235\141\148\235\175\184",
    PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_COLOSSEUM_REWARD_1")
  }
}
function Panel_Join_Init()
  for index, value in pairs(join.radioBtn) do
    value:SetCheck(false)
  end
  join._index = 0
  join.radioBtn[join._index]:SetCheck(true)
end
function Panel_Join_Update(index)
  if nil == index then
    index = join._index
  else
    join._index = index
  end
  local self
  if 0 == index then
    self = localWar
  elseif 1 == index then
    self = colosseum
  else
    self = localWar
  end
  join._title:SetText(self._title)
  join._condition:SetText(self._condition)
  join._headIcon:ChangeTextureInfoName(self._iconTextureUrl)
  MyRankRangeAndPoint(index)
  if 0 == index and 0 < ToClient_GetMyTeamNoLocalWar() then
    local teamName
    if 1 == ToClient_GetMyTeamNoLocalWar() then
      teamName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE_1", "title", self._title)
    else
      teamName = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_TITLE_2", "title", self._title)
    end
    join._title:SetText(teamName)
  end
  local ruleCount = #self._rule
  local rewardCount = #self._reward
  local posY = join._titleBg:GetPosY() + join._titleBg:GetSizeY()
  local gapY = 5
  local textSizeY = 20
  if ruleCount > 0 then
    join._ruleTitle:SetShow(true)
    join._ruleBg:SetShow(true)
    join._ruleContent:SetShow(true)
    local content = ""
    for i = 1, ruleCount do
      if 1 == i then
        content = self._rule[i]
      else
        content = content .. "\n" .. self._rule[i]
      end
    end
    join._ruleContent:SetText(content)
    join._ruleBg:SetSize(join._ruleBg:GetSizeX(), join._ruleContent:GetTextSizeY() + gapY * 2)
    posY = join._ruleBg:GetPosY() + join._ruleBg:GetSizeY() + gapY * 2
  else
    join._ruleTitle:SetShow(false)
    join._ruleBg:SetShow(false)
    join._ruleContent:SetShow(false)
    posY = posY + gapY * 2
  end
  if rewardCount > 0 then
    join._rewardTitle:SetShow(true)
    join._rewardBg:SetShow(true)
    join._rewardContent:SetShow(true)
    join._rewardTitle:SetPosY(posY)
    posY = posY + join._rewardTitle:GetTextSizeY() + gapY
    join._rewardBg:SetPosY(posY)
    posY = posY + gapY
    join._rewardContent:SetPosY(posY)
    local content = ""
    for i = 1, rewardCount do
      if 1 == i then
        content = self._reward[i]
      else
        content = content .. "\n" .. self._reward[i]
      end
    end
    join._rewardContent:SetText(content)
    join._rewardBg:SetSize(join._rewardBg:GetSizeX(), join._rewardContent:GetTextSizeY() + gapY * 2)
    posY = join._rewardBg:GetPosY() + join._rewardBg:GetSizeY() + gapY
  else
    join._rewardTitle:SetShow(false)
    join._rewardBg:SetShow(false)
    join._rewardContent:SetShow(false)
  end
  if 0 == index then
    if 0 == ToClient_GetMyTeamNoLocalWar() then
      join.btn_Join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_ADMIN_1"))
    else
      join.btn_Join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CANCEL_1"))
    end
  elseif 1 == index then
    if ToClient_IsRequestedPvP() then
      join.btn_Join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_ADMIN_2"))
    else
      join.btn_Join:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_CANCEL_2"))
    end
  end
  join._mainBg:SetSize(join._mainBg:GetSizeX(), posY - join._mainBg:GetPosY())
  Panel_Join:SetSize(Panel_Join:GetSizeX(), join._mainBg:GetSizeY() + 125)
  join.btn_Join:ComputePos()
  join.btn_Rank:ComputePos()
end
function MyRankRangeAndPoint(index)
  local self
  if 0 == index then
    self = localWar
  elseif 1 == index then
    self = colosseum
  else
    self = localWar
  end
  local myRank, myPoint, myRankRate, rankGrade
  if 1 == index then
    myRank = ToClient_GetMyMatchRank(0)
    local servnerUserCnt = ToClient_GetMatchRankerUserCount(0)
    myRankRate = tonumber(myRank / servnerUserCnt * 100)
    myPoint = ToClient_GetMyMatchPoint(0)
  elseif 0 == index then
    myRank = ToClient_GetContentsMyRank(2)
    local servnerUserCnt = ToClient_GetContentsRankUserCount(2)
    myRankRate = tonumber(myRank / servnerUserCnt * 100)
    myPoint = ToClient_GetMyAccumulatedKillCount()
  end
  join._myPoint:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_MYPOINT", "point", myPoint))
  if 0 == myPoint then
    join._myRank:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_RANK_NONE"))
  elseif myRank <= 30 then
    join._myRank:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_MYRANK", "rank", myRank))
  else
    if myRankRate >= 0 and myRankRate <= 20 then
      rankGrade = "A"
    elseif myRankRate > 20 and myRankRate <= 40 then
      rankGrade = "B"
    elseif myRankRate > 40 and myRankRate <= 60 then
      rankGrade = "C"
    elseif myRankRate > 60 and myRankRate <= 80 then
      rankGrade = "D"
    elseif myRankRate > 80 and myRankRate <= 100 then
      rankGrade = "E"
    end
    join._myRank:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_GRADE", "grade", rankGrade))
  end
end
function Join_SelectTap(index)
  join._index = index
  Panel_Join_Update(index)
end
function RankWindow_Show()
  for idx, value in pairs(join.radioBtn) do
    if join.radioBtn[idx]:IsCheck() then
      Panel_Join_Close()
      FGlobal_LifeRanking_Show(idx)
      break
    end
  end
end
function Content_Join()
  for idx, value in pairs(join.radioBtn) do
    if join.radioBtn[idx]:IsCheck() then
      if 0 == idx then
        do
          local partyMemberCount = RequestParty_getPartyMemberCount()
          if partyMemberCount > 0 then
            join._conditionCheck = Panel_Join_PartyMasterCheck(partyMemberCount)
            if join._conditionCheck then
              for index = 0, partyMemberCount - 1 do
                local memberData = RequestParty_getPartyMemberAt(index)
                local memberLv = memberData._level
                if memberLv < 50 then
                  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_1"))
                  return
                end
              end
            end
          else
            join._conditionCheck = true
          end
          if join._conditionCheck then
            if 0 == ToClient_GetMyTeamNoLocalWar() then
              ToClient_JoinLocalWar()
              break
            end
            do
              local pcPosition = getSelfPlayer():get():getPosition()
              local regionInfo = getRegionInfoByPosition(pcPosition)
              ToClient_UnJoinLocalWar()
            end
            break
          end
          if 0 == ToClient_GetMyTeamNoLocalWar() then
            Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_3"))
            break
          end
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_4"))
        end
        break
      end
      if 1 == idx then
        if 0 == ToClient_GetMyTeamNoLocalWar() then
          if ToClient_IsRequestedPvP() then
            ToClient_UnRequestMatchInfo()
            break
          end
          HandleClicked_RegisterMatch()
          break
        end
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_MESSAGE_5"))
      end
      break
    end
  end
end
function Panel_Join_PartyMasterCheck(count)
  local isSelfMaster = false
  for index = 0, count - 1 do
    local memberData = RequestParty_getPartyMemberAt(index)
    local isMaster = memberData._isMaster
    if RequestParty_isSelfPlayer(index) and isMaster then
      isSelfMaster = true
      break
    end
  end
  return isSelfMaster
end
function FromClient_JoinLocalWar(teamNo)
  local teamName
  if 1 == teamNo then
    teamName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")
  else
    teamName = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")
  end
  local msg, showRate, msgType = {
    main,
    sub,
    addMsg = ""
  }, 3, 34
  msg.main = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_WELCOME_1")
  msg.sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_WELCOME_2", "team", teamName)
  Proc_ShowMessage_Ack_For_RewardSelect(msg, showRate, msgType)
  if true == _ContentsGroup_RenewUI_Dailog then
    if PaGlobalFunc_MainDialog_GetShow() then
      Panel_Join_Close()
    else
      FGlobal_NewLocalWar_Show()
    end
  else
    local dialogShow = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      dialogShow = Panel_Npc_Dialog:GetShow()
    else
      dialogShow = Panel_Npc_Dialog_All:GetShow()
    end
    if dialogShow then
      Panel_Join_Close()
    else
      FGlobal_NewLocalWar_Show()
    end
  end
end
function FromClient_UnJoinLocalWar(unJoinType)
  local msg, showRate, msgType = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_1"),
    sub = "",
    addMsg = ""
  }, 3, 35
  if 1 == unJoinType then
    main.sub = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_2")
  elseif 2 == unJoinType then
    main.sub = PAGetString(Defines.StringSheet_GAME, "LUA_JOIN_LOCALWAR_LEAVEMSG_3")
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, showRate, msgType)
  if true == _ContentsGroup_RenewUI_Dailog then
    if PaGlobalFunc_MainDialog_GetShow() then
      Panel_Join_Close()
    else
      NewLocalWar_Hide()
    end
  else
    local dialogShow = false
    if false == _ContentsGroup_NewUI_Dialog_All then
      dialogShow = Panel_Npc_Dialog:GetShow()
    else
      dialogShow = Panel_Npc_Dialog_All:GetShow()
    end
    if dialogShow then
      Panel_Join_Close()
    else
      NewLocalWar_Hide()
    end
  end
end
function Panel_Join_Show()
  local self = join
  if Panel_Window_Enchant:GetShow() then
    PaGlobal_Enchant:enchantClose()
  elseif Panel_Window_Socket:GetShow() then
    Socket_WindowClose()
    ToClient_BlackspiritEnchantClose()
  end
  local isSiegeChannel = ToClient_isSiegeChannel()
  if false == _ContentsGroup_NewUI_LifeRanking_All then
    FGlobal_LifeRanking_Close()
  else
    PaGlobal_LifeRanking_Close_All()
  end
  SkillAwaken_Close()
  if not Panel_Join:GetShow() then
    Panel_Join:SetShow(true)
    Panel_Join_Repos()
  end
  if isSiegeChannel then
    self.btn_Join:SetIgnore(true)
    self.btn_Join:SetMonoTone(true)
  else
    self.btn_Join:SetIgnore(false)
    self.btn_Join:SetMonoTone(false)
  end
  Panel_Join_Init()
  Panel_Join_Update()
end
function Panel_Join_Close()
  if Panel_Join:GetShow() then
    Panel_Join:SetShow(false)
  end
end
function Panel_Join_Repos()
  Panel_Join:SetPosX(getScreenSizeX() / 2 + Panel_Join:GetSizeX())
  Panel_Join:SetPosY(getScreenSizeY() / 2 - Panel_Join:GetSizeY() * 2 / 3 - 50)
end
function Panel_Join_RegisterEvent()
  join.btn_Close:addInputEvent("Mouse_LUp", "Panel_Join_Close()")
  join.btn_Join:addInputEvent("Mouse_LUp", "Content_Join()")
  join.btn_Rank:addInputEvent("Mouse_LUp", "RankWindow_Show()")
  for idx, value in pairs(join.radioBtn) do
    join.radioBtn[idx]:addInputEvent("Mouse_LUp", "Join_SelectTap( " .. idx .. " )")
  end
  registerEvent("FromClient_JoinLocalWar", "FromClient_JoinLocalWar")
  registerEvent("FromClient_UnJoinLocalWar", "FromClient_UnJoinLocalWar")
end
function Join_Simpletooltips(isShow, index)
  local name, desc, uiControl
  if isShow then
    if 0 == index then
      name = "\235\182\137\236\157\128 \236\160\132\236\158\165"
      desc = ""
      uiControl = join.radioBtn[index]
    elseif 1 == index then
      name = "\234\178\176\237\136\172\236\158\165"
      desc = ""
      uiControl = join.radioBtn[index]
    end
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
Panel_Join_RegisterEvent()
