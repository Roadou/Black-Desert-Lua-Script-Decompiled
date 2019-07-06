PaGlobal_GuildBattlePoint = {
  _guildAName = nil,
  _guildBName = nil,
  _oneonePointBg = nil,
  _txt_TeamBlack = nil,
  _txt_TeamRed = nil,
  _txt_RingoutCheck = nil,
  _guildAPoint = nil,
  _guildBPoint = nil,
  _round = {},
  _perFrmaeTimer = 0,
  _nextStateTime = 0,
  _maxTime = 0,
  _timerPause = false
}
function PaGlobal_GuildBattlePoint:initilize()
  if nil == Panel_GuidlBattle_Point then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuidlBattle_Point:SetShow(false)
  end
  self._guildAName = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_Left")
  self._guildBName = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_Right")
  self._oneonePointBg = UI.getChildControl(Panel_GuidlBattle_Point, "Static_OneOneScore")
  self._txt_TeamBlack = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_MyTeamBlack")
  self._txt_TeamRed = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_MyTeamRed")
  self._txt_RingoutCheck = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_RingoutTimeCheck")
  local round = {}
  round._bg = UI.getChildControl(Panel_GuidlBattle_Point, "StaticText_Center")
  round._timer = UI.getChildControl(round._bg, "StaticText_Time")
  round._staticText_BattleMode = UI.getChildControl(round._bg, "StaticText_BattleMode")
  round._staticText_BattleStateDetail = UI.getChildControl(round._bg, "StaticText_BattleStateDetail")
  self._round = round
  self._guildAPoint = UI.getChildControl(self._guildAName, "StaticText_LeftPoint")
  self._guildBPoint = UI.getChildControl(self._guildBName, "StaticText_RightPoint")
  self._guildASurvivorCount = UI.getChildControl(self._guildAName, "StaticText_LeftNumSurvivor")
  self._guildBSurvivorCount = UI.getChildControl(self._guildBName, "StaticText_RightNumSurvivor")
  self._guildA_AttendClass = UI.getChildControl(self._guildAName, "Static_LeftClassIcon")
  self._guildB_AttendClass = UI.getChildControl(self._guildBName, "Static_RightClassIcon")
  self._guildA_AttendName = UI.getChildControl(self._guildAName, "StaticText_LeftCharacterName")
  self._guildB_AttendName = UI.getChildControl(self._guildBName, "StaticText_RightCharacterName")
  self._guildAOneOnePoint = UI.getChildControl(self._oneonePointBg, "StaticText_LeftOneOneScore")
  self._guildBOneOnePoint = UI.getChildControl(self._oneonePointBg, "StaticText_RightOneOneScore")
  self._guildA_AttendClass:SetPosX(self._guildAName:GetPosX() + 60)
  self._guildA_AttendName:SetPosX(self._guildA_AttendClass:GetPosX() + 30)
  self._guildB_AttendClass:SetPosX(self._guildBPoint:GetPosX() + 60)
  self._guildB_AttendName:SetPosX(self._guildB_AttendClass:GetPosX() + 30)
  self._guildASurvivorCount:SetShow(false)
  self._guildBSurvivorCount:SetShow(false)
  self._oneonePointBg:SetShow(false)
  self._txt_RingoutCheck:SetShow(false)
  self:setAttendName(0)
  self:setAttendName(1)
end
function PaGlobal_GuildBattlePoint:registMessageHandler()
  registerEvent("FromClient_GuildBattle_AttendPlayerInfo", "FromClient_GuildBattle_AttendPlayerInfo")
end
function PaGlobal_GuildBattlePoint:ShowSurvivorCount(isShow)
  if nil == Panel_GuidlBattle_Point then
    return
  end
  self._guildASurvivorCount:SetShow(isShow)
  self._guildBSurvivorCount:SetShow(isShow)
end
function PaGlobal_GuildBattlePoint:ShowOneOnePoint(isShow)
  if nil == Panel_GuidlBattle_Point then
    return
  end
  self._oneonePointBg:SetShow(isShow)
end
function PaGlobal_GuildBattlePoint:UpdateRemainTime()
  if nil == Panel_GuidlBattle_Point then
    return
  end
  local time = ToClient_GuildBattle_GetRemainTime()
  if time < 0 then
    time = 0
  end
  local min = math.floor(time / 60)
  local sec = math.floor(time % 60)
  local zero = "0"
  if sec < 10 then
    self._round._timer:SetText(tostring(min) .. tostring(" : ") .. zero .. tostring(sec))
  else
    self._round._timer:SetText(tostring(min) .. tostring(" : ") .. tostring(sec))
  end
  if true == self:IsShow() then
    self:UpdateRoundAndScore()
  end
end
function PaGlobal_GuildBattlePoint:UpdateRoundAndScore()
  if nil == Panel_GuidlBattle_Point then
    return
  end
  local battleState = ToClient_GuildBattle_GetCurrentState()
  local battleMode = ToClient_GuildBattle_GetCurrentMode()
  local round = ToClient_GuildBattle_GetBattleCurrentRound()
  local guildA = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(0)
  local guildB = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(1)
  local team = ""
  self._txt_TeamBlack:SetShow(false)
  self._txt_TeamRed:SetShow(false)
  self._round._staticText_BattleStateDetail:SetShow(false)
  if battleState == __eGuildBattleState_Idle then
    self._round._bg:SetText("")
  elseif battleState == __eGuildBattleState_Join then
    self._round._bg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLESTATE_JOIN"))
  elseif battleState == __eGuildBattleState_Ready then
    self._round._bg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND", "round", round))
    self._round._staticText_BattleStateDetail:SetShow(true)
    self._round._staticText_BattleStateDetail:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_READYSTATE_SHORT"))
  elseif battleState == __eGuildBattleState_SelectEntry then
    self._round._bg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND", "round", round))
    self._round._staticText_BattleStateDetail:SetShow(true)
    self._round._staticText_BattleStateDetail:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SELECTENTRY_SHORT"))
  elseif battleState == __eGuildBattleState_SelectAttend then
    self._round._bg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND", "round", round))
    self._round._staticText_BattleStateDetail:SetShow(true)
    self._round._staticText_BattleStateDetail:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SELECTATTEND_SHORT"))
  elseif battleState == __eGuildBattleState_Fight then
    self._round._bg:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_COMPETITION_ROUND", "round", round))
  elseif battleState == __eGuildBattleState_End then
    self._round._bg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
  elseif battleState == __eGuildBattleState_Teleport then
    self._round._bg:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLESTATE_TELEPORT"))
  else
    self._round._bg:SetText(PAGetString(Defines.StringSheet_GAME, ""))
  end
  self._round._staticText_BattleMode:SetShow(false)
  if battleState == __eGuildBattleState_Fight or battleState == __eGuildBattleState_SelectEntry or battleState == __eGuildBattleState_SelectAttend or battleState == __eGuildBattleState_Ready then
    self._round._staticText_BattleMode:SetShow(true)
    if battleMode == __eGuildBattleMode_Normal then
      self._round._staticText_BattleMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_NORMAL"))
    elseif battleMode == __eGuildBattleMode_OneOne then
      self._round._staticText_BattleMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_ONEONE"))
    elseif battleMode == __eGuildBattleMode_All then
      self._round._staticText_BattleMode:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_ALL"))
    else
      self._round._staticText_BattleMode:SetText("")
    end
  end
  if true == ToClient_isPersonalBattle() then
    local teamIndex = ToClient_getGuildBattleMyTeamIndex()
    if 0 == teamIndex then
      self._txt_TeamBlack:SetShow(true)
    elseif 1 == teamIndex then
      self._txt_TeamRed:SetShow(true)
    end
  end
  self._guildASurvivorCount:SetShow(false)
  self._guildBSurvivorCount:SetShow(false)
  self._oneonePointBg:SetShow(false)
  if guildA ~= nil and guildB ~= nil then
    if false == ToClient_isPersonalBattle() then
      self._guildAName:SetText(guildA:getName())
      self._guildBName:SetText(guildB:getName())
    else
      self._guildAName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1"))
      self._guildBName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2"))
    end
    self._guildAPoint:SetText(guildA:winPoint())
    self._guildBPoint:SetText(guildB:winPoint())
    if battleMode == __eGuildBattleMode_Normal then
      if battleState == __eGuildBattleState_Fight then
        self._guildASurvivorCount:SetShow(true)
        self._guildBSurvivorCount:SetShow(true)
        local guildASurvivorCount = guildA:getNumSurvivors()
        local guildBSurvivorCount = guildB:getNumSurvivors()
        self._guildASurvivorCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SURVIVORCOUNT", "count", tostring(guildASurvivorCount)))
        self._guildBSurvivorCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SURVIVORCOUNT", "count", tostring(guildBSurvivorCount)))
      end
    elseif battleMode == __eGuildBattleMode_OneOne then
      if battleState == __eGuildBattleState_Fight or battleState == __eGuildBattleState_Ready or battleState == __eGuildBattleState_Teleport or battleState == __eGuildBattleState_SelectAttend then
        self._oneonePointBg:SetShow(true)
        self._guildAOneOnePoint:SetText(guildA:getModeWinScore())
        self._guildBOneOnePoint:SetText(guildB:getModeWinScore())
      end
    elseif battleMode == __eGuildBattleMode_All and battleState == __eGuildBattleState_Fight then
      self._guildASurvivorCount:SetShow(true)
      self._guildBSurvivorCount:SetShow(true)
      local guildASurvivorCount = guildA:getNumSurvivors()
      local guildBSurvivorCount = guildB:getNumSurvivors()
      self._guildASurvivorCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SURVIVORCOUNT", "count", tostring(guildASurvivorCount)))
      self._guildBSurvivorCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SURVIVORCOUNT", "count", tostring(guildBSurvivorCount)))
    end
  else
  end
  local remainTime = ToClient_GetGuildBattleRingoutTime()
  if remainTime > 0 then
    self._txt_RingoutCheck:SetShow(true)
    self._txt_RingoutCheck:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_EMERGENCY_RINGOUT_TIMECHECK", "time", tostring(remainTime)))
  else
    self._txt_RingoutCheck:SetShow(false)
  end
end
function PaGlobal_GuildBattlePoint:Show(isShow)
  if true == isShow then
    PaGlobal_GuildBattlePoint_CheckLoadUI()
    self:UpdateRoundAndScore()
  else
    PaGlobal_GuildBattlePoint_CheckCloseUI()
  end
end
function PaGlobal_GuildBattlePoint:IsShow()
  if nil == Panel_GuidlBattle_Point then
    return false
  end
  return Panel_GuidlBattle_Point:GetShow()
end
function PaGlobal_GuildBattlePoint:clearAttendName()
  if nil == Panel_GuidlBattle_Point then
    return
  end
  self._guildA_AttendClass:SetShow(false)
  self._guildB_AttendClass:SetShow(false)
  self._guildA_AttendName:SetShow(false)
  self._guildB_AttendName:SetShow(false)
end
function PaGlobal_GuildBattlePoint:setAttendName(teamNo)
  if nil == Panel_GuidlBattle_Point then
    return
  end
  local memberInfo = ToClient_getGuildBattleOneOneMemberInfo(teamNo)
  if nil == memberInfo then
    return
  end
  local attendClass, attendName
  if 0 == teamNo then
    attendClass = self._guildA_AttendClass
    attendName = self._guildA_AttendName
  elseif 1 == teamNo then
    attendClass = self._guildB_AttendClass
    attendName = self._guildB_AttendName
  else
    _PA_LOG("\235\172\180\236\160\149", "\236\158\152\235\170\187\235\144\156 teamNo\234\176\128 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164. " .. tostring(teamNo))
    return
  end
  if 0 >= memberInfo:getLevel() then
    attendClass:SetShow(false)
    attendName:SetShow(false)
    return
  end
  local classSymbomInfo = CppEnums.ClassType_Symbol[memberInfo:getClassType()]
  attendClass:ChangeTextureInfoName(classSymbomInfo[1])
  local x1, y1, x2, y2 = setTextureUV_Func(attendClass, classSymbomInfo[2], classSymbomInfo[3], classSymbomInfo[4], classSymbomInfo[5])
  attendClass:getBaseTexture():setUV(x1, y1, x2, y2)
  attendClass:setRenderTexture(attendClass:getBaseTexture())
  attendName:SetText(memberInfo:getCharacterName())
  attendClass:SetShow(true)
  attendName:SetShow(true)
end
function FromClient_GuildBattle_AttendPlayerInfo()
  if nil == Panel_GuidlBattle_Point then
    return
  end
  local self = PaGlobal_GuildBattlePoint
  self:setAttendName(0)
  self:setAttendName(1)
end
function FromClient_guildBattlePointTimer(time, max)
  PaGlobal_GuildBattlePoint:SetTimer(time, max)
end
function FromClient_unjoinGuildBattle()
  PaGlobal_GuildBattlePoint:PaGlobal_GuildBattlePoint()
end
function PaGlobal_GuildBattlePoint_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuidlBattle_Point:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_GuildBattle_Point.XML", "Panel_GuidlBattle_Point", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_GuidlBattle_Point = rv
    rv = nil
    PaGlobal_GuildBattlePoint:initilize()
  end
  Panel_GuidlBattle_Point:SetShow(true)
end
function PaGlobal_GuildBattlePoint_CheckCloseUI()
  if false == PaGlobal_AgreementGuildMaster_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuidlBattle_Point:SetShow(false)
  else
    reqCloseUI(Panel_GuidlBattle_Point)
  end
end
function GuildBattlePoint_LuaLoadComplete()
  PaGlobal_GuildBattlePoint:initilize()
  PaGlobal_GuildBattlePoint:registMessageHandler()
end
registerEvent("FromClient_luaLoadComplete", "GuildBattlePoint_LuaLoadComplete")
