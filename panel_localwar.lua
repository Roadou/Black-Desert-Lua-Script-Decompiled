local UI_TM = CppEnums.TextMode
local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local IM = CppEnums.EProcessorInputMode
Panel_LocalWar:SetShow(false)
Panel_LocalWarTeam:SetShow(false)
Panel_LocalWar:setMaskingChild(true)
Panel_LocalWar:ActiveMouseEventEffect(true)
Panel_LocalWar:setGlassBackground(true)
Panel_LocalWar:RegisterShowEventFunc(true, "LocalWar_ShowAni()")
Panel_LocalWar:RegisterShowEventFunc(false, "LocalWar_HideAni()")
function LocalWar_ShowAni()
end
function LocalWar_HideAni()
end
local isLocalwarOpen = ToClient_IsContentsGroupOpen("43")
local myTeam = UI.getChildControl(Panel_LocalWar, "StaticText_MyTeam")
local accumulateKillCount = UI.getChildControl(Panel_LocalWar, "StaticText_AccumulateKillCountIcon")
local currentContinuityKillCount = UI.getChildControl(Panel_LocalWar, "StaticText_CurrentContinuityKillCountIcon")
local maxContinuityKillCount = UI.getChildControl(Panel_LocalWar, "StaticText_MaxContinuityKillCountIcon")
local buttonQuestion = UI.getChildControl(Panel_LocalWar, "Button_Question")
buttonQuestion:SetShow(false)
local _txt_LocalWarTime = UI.getChildControl(Panel_LocalWarTeam, "StaticText_TimeLine")
local _txt_LocalWarBlack = UI.getChildControl(Panel_LocalWarTeam, "StaticText_TeamBlackDesert")
local _txt_LocalWarRed = UI.getChildControl(Panel_LocalWarTeam, "StaticText_TeamRedDesert")
local _txt_TeamBlack = UI.getChildControl(Panel_LocalWarTeam, "StaticText_MyTeamBlack")
local _txt_TeamRed = UI.getChildControl(Panel_LocalWarTeam, "StaticText_MyTeamRed")
local _icon_TeamBlackBuff = UI.getChildControl(Panel_LocalWarTeam, "Static_BlackTeamBuff")
local _icon_TeamRedBuff = UI.getChildControl(Panel_LocalWarTeam, "Static_RedTeamBuff")
_icon_TeamBlackBuff:SetShow(false)
_icon_TeamRedBuff:SetShow(false)
function LocalWar_Icon_Tooltip_Event()
  accumulateKillCount:addInputEvent("Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 0 .. ")")
  accumulateKillCount:addInputEvent("Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()")
  currentContinuityKillCount:addInputEvent("Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 1 .. ")")
  currentContinuityKillCount:addInputEvent("Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()")
  maxContinuityKillCount:addInputEvent("Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 2 .. ")")
  maxContinuityKillCount:addInputEvent("Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()")
  buttonQuestion:addInputEvent("Mouse_On", "Panel_LocalWar_Icon_ToolTip_Show(" .. 3 .. ")")
  buttonQuestion:addInputEvent("Mouse_Out", "Panel_LocalWar_Icon_ToolTip_Show()")
end
local saveBlackScore = 0
local saveRedScore = 0
local blackTeam = 0
local redTeam = 0
local killCheck = false
local teamCheck = false
local killCount = {
  _accumulate,
  _current,
  _max
}
local displayTime = function(timeValue)
  timeValue = timeValue / 1000
  if timeValue > 3600 then
    timeValue = timeValue / 3600
    return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_HOUR")
  elseif timeValue > 120 then
    timeValue = timeValue / 60
    return tostring(timeValue) .. PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_MINUTE")
  elseif timeValue > 0 then
    return PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_DEADLINE")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_CONSIGNMENTSALE_SALECLOSE")
  end
end
function LocalWar_KillCount_Init()
  local team = ""
  _txt_TeamBlack:SetShow(false)
  _txt_TeamRed:SetShow(false)
  if 1 == ToClient_GetMyTeamNoLocalWar() then
    team = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1")
    _txt_TeamBlack:SetShow(true)
  else
    team = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2")
    _txt_TeamRed:SetShow(true)
  end
  myTeam:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_3", "team", team))
end
function Panel_LocalWar_Icon_ToolTip_Show(index)
  local isShow, name, desc, uiControl = true, nil, nil, nil
  if 0 == index then
    name = "\235\136\132\236\160\129 \236\178\152\236\185\152 \237\154\159\236\136\152"
    uiControl = accumulateKillCount
  elseif 1 == index then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ACCUMULATEKILLCOUNT")
    uiControl = currentContinuityKillCount
  elseif 2 == index then
    name = "\236\181\156\235\140\128 \236\151\176\236\134\141 \236\178\152\236\185\152 \237\154\159\236\136\152"
    uiControl = maxContinuityKillCount
  elseif 3 == index then
    name = "\234\181\173\236\167\128\236\160\132\236\157\180\235\158\128?"
    desc = "\234\181\173\236\167\128\236\160\132\236\151\144 \235\140\128\237\149\156 \236\132\164\235\170\133\236\157\180 \235\147\164\236\150\180\234\176\145\235\139\136\235\139\164.\n\234\181\173\236\167\128\236\160\132 \236\132\164\235\170\133! \234\181\173\236\167\128\236\160\132 \236\132\164\235\170\133! \234\181\173\236\167\128\236\160\132 \236\132\164\235\170\133!"
    uiControl = buttonQuestion
  else
    isShow = false
  end
  if isShow then
    registTooltipControl(uiControl, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function NewLocalWar_Show()
  if not Panel_LocalWarTeam:GetShow() then
    Panel_LocalWarTeam:SetShow(true)
  else
    return
  end
end
function NewLocalWar_Hide()
  if Panel_LocalWarTeam:GetShow() then
    Panel_LocalWarTeam:GetShow(false)
  end
end
function FGlobal_NewLocalWar_Show()
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    NewLocalWar_Hide()
    return
  end
  saveBlackScore = 0
  saveRedScore = 0
  NewLocalWar_Show()
end
function NewLocalWar_Update()
  local teamBlackPoint = ToClient_GetLocalwarTeamPoint(0)
  local teamRedPoint = ToClient_GetLocalwarTeamPoint(1)
  local isTeam = ToClient_GetMyTeamNoLocalWar()
  _txt_LocalWarBlack:EraseAllEffect()
  _txt_LocalWarRed:EraseAllEffect()
  if teamBlackPoint > saveBlackScore then
    if teamBlackPoint > 99 and teamBlackPoint < 1000 then
      _txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 5, -1.5)
    elseif teamBlackPoint > 9 and teamBlackPoint < 100 then
      _txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -1, -1.5)
    elseif teamBlackPoint < 10 then
      _txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -5, -1.5)
    else
      _txt_LocalWarBlack:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 0, 0)
    end
    saveBlackScore = teamBlackPoint
  end
  if teamRedPoint > saveRedScore then
    if teamRedPoint > 99 and teamRedPoint < 1000 then
      _txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, -4, -1.5)
    elseif teamRedPoint > 9 and teamRedPoint < 100 then
      _txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 1, -1.5)
    elseif teamRedPoint < 10 then
      _txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 5, -1.5)
    else
      _txt_LocalWarRed:AddEffect("UI_GuildWar_ArrowMark_Big01", false, 0, 0)
    end
    saveRedScore = teamRedPoint
  end
  _txt_LocalWarBlack:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_BLACKDESERTTEAM", "teamBlackPoint", teamBlackPoint))
  _txt_LocalWarRed:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_REDDESERTTEAM", "teamRedPoint", teamRedPoint))
end
local _winningTeam = 2
function LocalwarReloadUI()
  local teamBlackPoint = ToClient_GetLocalwarTeamPoint(0)
  local teamRedPoint = ToClient_GetLocalwarTeamPoint(1)
  if teamBlackPoint < teamRedPoint then
    _winningTeam = 0
  elseif teamBlackPoint > teamRedPoint then
    _winningTeam = 1
  else
    _winningTeam = 2
  end
  if 0 == ToClient_GetLocalwarState() then
  elseif 1 == ToClient_GetLocalwarState() then
    _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
  elseif 2 == ToClient_GetLocalwarState() then
    _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWARINFO_FINISH"))
    if 0 == ToClient_GetMyTeamNoLocalWar() then
      NewLocalWar_Hide()
    end
  end
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    NewLocalWar_Hide()
  end
end
LocalwarReloadUI()
function NewLocalWar_TurnAround()
  local teamBlackPoint = ToClient_GetLocalwarTeamPoint(0)
  local teamRedPoint = ToClient_GetLocalwarTeamPoint(1)
  local myTeamIndex = ToClient_GetMyTeamNoLocalWar() - 1
  local prevWinningTeam = _winningTeam
  if teamBlackPoint < teamRedPoint then
    _winningTeam = 0
  elseif teamBlackPoint > teamRedPoint then
    _winningTeam = 1
  else
    return
  end
  if prevWinningTeam == _winningTeam or 2 == prevWinningTeam then
    return
  end
  if 0 == _winningTeam then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_2"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_TURNAROUND"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 1.8, 47, false)
    teamCheck = true
  elseif 1 == _winningTeam then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_BELONG_1"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_TURNAROUND"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 1.8, 47, false)
    teamCheck = false
  end
end
local saveLocalWarTime = 0
local delayTime = 1
local localwarDeltaTime = 0
function NewLocalWar_TimeUpdate(deltaTime)
  localwarDeltaTime = localwarDeltaTime + deltaTime
  if delayTime <= localwarDeltaTime then
    local warTime = ToClient_GetLocalwarRemainedTime()
    if saveLocalWarTime > 0 and 0 == warTime then
      _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
    end
    saveLocalWarTime = warTime
    if 0 == warTime then
      if 1 == ToClient_GetLocalwarState() then
        _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_SOONFINISH"))
      end
      return
    end
    local warTimeMinute = math.floor(warTime / 60)
    local warTimeSecond = warTime % 60
    if warTimeMinute < 10 then
      warTimeMinute = "0" .. warTimeMinute
    end
    if warTimeSecond < 10 then
      warTimeSecond = "0" .. warTimeSecond
    end
    localwarDeltaTime = 0
    _txt_LocalWarTime:SetText(tostring(warTimeMinute) .. " : " .. tostring(warTimeSecond))
  end
end
function FromClient_KillLocalWar(killPlayer, deadPlayer, killPlayerTeam, getScore)
  if nil == killPlayer or nil == deadPlayer then
    return
  end
  local teamBlackPoint = ToClient_GetLocalwarTeamPoint(0)
  local teamRedPoint = ToClient_GetLocalwarTeamPoint(1)
  blackTeam = teamBlackPoint
  redTeam = teamRedPoint
  local isTeam = ToClient_GetMyTeamNoLocalWar()
  local mainMessage
  if isTeam == killPlayerTeam then
    if getScore >= 100 then
      local isMsg = {
        main = "[" .. killPlayer .. "]",
        sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_GETSCROE_ALOT", "getScore", getScore),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(isMsg, 5, 49, false)
    end
    mainMessage = "<PAColor0xFF2C7BFF>" .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_LOCALWAR_KILLPLAYER", "killPlayer", killPlayer, "deadPlayer", deadPlayer, "score", getScore) .. "<PAOldColor>"
  else
    if getScore >= 100 then
      local isMsg2 = {
        main = "[" .. killPlayer .. "]",
        sub = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_LOCALWAR_GETSCROE_ALOT", "getScore", getScore),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(isMsg2, 5, 48, false)
    end
    mainMessage = "<PAColor0xFFC02A2A>" .. PAGetStringParam3(Defines.StringSheet_GAME, "LUA_LOCALWAR_KILLPLAYER", "killPlayer", killPlayer, "deadPlayer", deadPlayer, "score", getScore) .. "<PAOldColor>"
  end
  local msg = {
    main = mainMessage,
    sub = "",
    addMsg = ""
  }
  if nil ~= msg.main then
    chatting_sendMessage("", msg.main, CppEnums.ChatType.Battle)
  end
  NewLocalWar_Update()
  NewLocalWar_TurnAround()
end
function FromClient_MultiKillLocalWar(killerName, deadPlayerName, killCount, posX, posY, posZ)
  if killCount >= 5 then
    local killPlayerPos3D = float3(posX, posY, posZ)
    LocalWar_MultiKillPlayerIcon_WorldMap(killerName, killCount, killPlayerPos3D)
  end
end
function FromClient_UpdateLocalwarState(state)
  if nil == state or "" == state then
    return
  end
  if not isLocalwarOpen then
    return
  end
  local msg = {
    main = "",
    sub = "",
    addMsg = ""
  }
  if 0 == state then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_RECRUITMENT_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_RECRUITMENT_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 34, false)
  elseif 1 == state then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_START_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_START_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 34, false)
  elseif 2 == state then
    local teamBlackPoint = ToClient_GetLocalwarTeamPoint(0)
    local teamRedPoint = ToClient_GetLocalwarTeamPoint(1)
    local winnerTeamNo = 2
    if teamBlackPoint < teamRedPoint then
      winnerTeamNo = 2
    elseif teamBlackPoint > teamRedPoint then
      winnerTeamNo = 1
    end
    if winnerTeamNo == ToClient_GetMyTeamNoLocalWar() then
      msg = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_WARWIN"),
        sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_MOVEBEFOREREGION"),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 45, false)
    else
      msg = {
        main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_WARLOSE"),
        sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_MOVEBEFOREREGION"),
        addMsg = ""
      }
      Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 46, false)
    end
    _txt_LocalWarTime:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH"))
  elseif 3 == state then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_FINISH_SUB"),
      addMsg = ""
    }
    Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 34, false)
  end
end
function FromClient_LocalWarKickOut()
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_KICKOUT"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_KICKOUT_SUB"),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 5, 34, false)
end
function FromClient_LocalWarAdvantage(teamNo)
  local advantageMsg = {
    main = "",
    sub = "",
    addMsg = ""
  }
  if nil == teamNo then
    return
  end
  if 0 == teamNo then
    advantageMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM0_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM0_SUB"),
      addMsg = ""
    }
  elseif 1 == teamNo then
    advantageMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM1_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM1_SUB"),
      addMsg = ""
    }
  elseif 2 == teamNo then
    advantageMsg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM2_MAIN"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_LOCALWAR_ADVANTAGEMSG_PARAM2_SUB"),
      addMsg = ""
    }
  end
  Proc_ShowMessage_Ack_For_RewardSelect(advantageMsg, 5, 34, false)
end
function FromClient_UpdateMyKillCountLocalWar()
end
function LocalWar_MultiKillPlayerIcon_WorldMap(name, count, pos)
  local showTime = 180
  ToClient_worldmapAddIcon("Static_RedIcon_LocalWar", pos, showTime)
end
local sizeX = Panel_LocalWar:GetSizeX()
local sizeY = Panel_LocalWar:GetSizeY()
local iconPosX = accumulateKillCount:GetPosX()
local gapX = 60
local gapY = 30
function Panel_NewLocalWar_Repos()
  Panel_LocalWarTeam:SetPosX(getScreenSizeX() / 2 - Panel_LocalWarTeam:GetSizeX() / 2)
  Panel_LocalWarTeam:SetPosY(0)
end
function NewLocalWar_Init()
  if 0 == ToClient_GetMyTeamNoLocalWar() then
    NewLocalWar_Hide()
    return
  end
end
NewLocalWar_Init()
LocalWar_Icon_Tooltip_Event()
FGlobal_NewLocalWar_Show()
NewLocalWar_Update()
LocalWar_KillCount_Init()
registerEvent("onScreenResize", "Panel_NewLocalWar_Repos")
registerEvent("FromClient_UpdateMyKillCountLocalWar", "FromClient_UpdateMyKillCountLocalWar")
registerEvent("FromClient_KillLocalWar", "FromClient_KillLocalWar")
registerEvent("FromClient_MultiKillLocalWar", "FromClient_MultiKillLocalWar")
registerEvent("FromClient_UpdateLocalwarState", "FromClient_UpdateLocalwarState")
registerEvent("FromClient_LocalWarKickOut", "FromClient_LocalWarKickOut")
Panel_LocalWarTeam:RegisterUpdateFunc("NewLocalWar_TimeUpdate")
