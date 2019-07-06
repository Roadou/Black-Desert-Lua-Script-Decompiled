PaGlobal_GuildBattle = {
  _ui = {
    _guildBattleBG = nil,
    _backgroundMainBG = nil,
    _btn_Reservation = nil,
    _btn_Cancle = nil,
    _btn_Join = nil,
    _btn_UnJoin = nil,
    _btn_Start = nil,
    _txt_progress = nil,
    _txt_progressGlow = nil,
    _notJoinText = nil,
    _joinBothGuild = {},
    _joinProgressTimer = {},
    _midBattleMark = nil,
    _txt_BottomDesc = nil,
    _guildAinfo = {},
    _edit_PriceInput = nil
  },
  _battingPrice = 0,
  _CanCancel = true,
  _cancelAnotherGuild = false
}
function PaGlobal_GuildBattle:Initialize()
  if nil == Panel_Window_Guild then
    return
  end
  Panel_Window_GuildBattle:SetShow(false)
  Panel_Window_GuildBattle:setGlassBackground(true)
  Panel_Window_GuildBattle:ActiveMouseEventEffect(true)
  self._ui._guildBattleBG = UI.getChildControl(Panel_Window_Guild, "Static_Frame_GuildBattleBG")
  self._ui._backgroundMainBG = UI.getChildControl(Panel_Window_GuildBattle, "Static_TopBack")
  self._ui._btn_Reservation = UI.getChildControl(Panel_Window_GuildBattle, "Button_Reservation")
  self._ui._btn_Cancle = UI.getChildControl(Panel_Window_GuildBattle, "Button_ReservationCancel")
  self._ui._btn_Join = UI.getChildControl(Panel_Window_GuildBattle, "Button_Join")
  self._ui._btn_UnJoin = UI.getChildControl(Panel_Window_GuildBattle, "Button_UnJoin")
  self._ui._btn_Start = UI.getChildControl(Panel_Window_GuildBattle, "Button_Start")
  self._ui._txt_progress = UI.getChildControl(Panel_Window_GuildBattle, "Static_Text_Progress")
  self._ui._txt_progressGlow = UI.getChildControl(Panel_Window_GuildBattle, "StaticText_ProgressGlow")
  self._ui._notJoinText = UI.getChildControl(Panel_Window_GuildBattle, "StaticText_NoGuild")
  self._ui._midBattleMark = UI.getChildControl(Panel_Window_GuildBattle, "Static_CenterMark")
  self._ui._txt_BottomDesc = UI.getChildControl(Panel_Window_GuildBattle, "StaticText_BottomDesc")
  self._ui._edit_PriceInput = UI.getChildControl(Panel_Window_GuildBattle, "Edit_PriceInput")
  local ainfo = {}
  ainfo._bg = UI.getChildControl(Panel_Window_GuildBattle, "Static_WaitGuild")
  ainfo._master = UI.getChildControl(ainfo._bg, "StaticText_GuildMasterValue")
  ainfo._ranking = UI.getChildControl(ainfo._bg, "StaticText_GuildRankValue")
  ainfo._rating = UI.getChildControl(ainfo._bg, "StaticText_GuildPointValue")
  ainfo._name = UI.getChildControl(ainfo._bg, "StaticText_GuildName")
  self._ui._guildAinfo = ainfo
  local joinProgress = {}
  joinProgress._bg = UI.getChildControl(Panel_Window_GuildBattle, "Static_JoinWaitProgress")
  joinProgress._timeText = UI.getChildControl(joinProgress._bg, "MultilineText_JoinWaitBG")
  joinProgress._progressBar = UI.getChildControl(joinProgress._bg, "CircularProgress_JoinWait")
  joinProgress._stateText = UI.getChildControl(joinProgress._bg, "StaticText_TimeTitle")
  self._ui._joinProgressTimer = joinProgress
  local bothjoined = {}
  bothjoined._bg = UI.getChildControl(Panel_Window_GuildBattle, "Static_JoinWaitBothGuild")
  bothjoined._guildANameMark = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildNameLeft")
  bothjoined._guildAMaster = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildMasterNameValueLeft")
  bothjoined._guildAranking = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildRankValueLeft")
  bothjoined._guildArating = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildPointValueLeft")
  bothjoined._guildAScore = UI.getChildControl(bothjoined._bg, "StaticText_ScoreLeft")
  bothjoined._guildBNameMark = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildNameRight")
  bothjoined._guildBMaster = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildMasterNameValueRight")
  bothjoined._guildBranking = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildRankValueRight")
  bothjoined._guildBrating = UI.getChildControl(bothjoined._bg, "StaticText_WaitBothGuildPointValueRight")
  bothjoined._guildBScore = UI.getChildControl(bothjoined._bg, "StaticText_ScoreRight")
  bothjoined._CompleteBG = UI.getChildControl(bothjoined._bg, "Static_JoinCompleteBothGuildCenterBG")
  self._ui._joinBothGuild = bothjoined
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Left, 10)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Right, 10)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Top, 10)
  self._ui._txt_BottomDesc:setPadding(CppEnums.Padding.ePadding_Bottom, 10)
  self._ui._txt_BottomDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._txt_BottomDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BOTTOMDESC"))
  self._ui._txt_BottomDesc:SetSize(self._ui._txt_BottomDesc:GetSizeX(), self._ui._txt_BottomDesc:GetTextSizeY() + 20)
  self._ui._edit_PriceInput:SetNumberMode(true)
  self._ui._edit_PriceInput:SetPosY(200)
  self._ui._edit_PriceInput:SetShow(false)
  self._ui._guildBattleBG:MoveChilds(self._ui._guildBattleBG:GetID(), Panel_Window_GuildBattle)
  self._ui._backgroundMainBG:SetSize(710, 570 - self._ui._txt_BottomDesc:GetTextSizeY())
  self:turnOffAllControl()
end
function PaGlobal_GuildBattle:SetProgressServer(cancel)
  if nil == Panel_Window_Guild then
    return
  end
  local progressServer = ToClient_GuildBattle_GetMyGuildBattleServer()
  local channelName = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_NOTDOING")
  local isReserve = false
  if progressServer ~= 0 then
    local curChannelData = getCurrentChannelServerData()
    if nil ~= curChannelData then
      channelName = getChannelName(curChannelData._worldNo, progressServer)
      isReserve = true
      if progressServer ~= curChannelData._serverNo then
        return
      end
    end
    if true == cancel then
      return
    end
  end
  self._CanCancel = true
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE")
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE"),
    addMsg = ""
  }
  if true == isReserve then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RESERVE"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE"),
      addMsg = ""
    }
  elseif true == cancel then
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_CANCEL"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE"),
      addMsg = ""
    }
  else
    msg = {
      main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_END"),
      sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE"),
      addMsg = ""
    }
  end
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 78)
  self._ui._txt_progress:SetText(channelName)
end
function PaGlobal_GuildBattle:turnOffAllControl()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._btn_Reservation:SetShow(false)
  self._ui._btn_Cancle:SetShow(false)
  self._ui._btn_Join:SetShow(false)
  self._ui._btn_UnJoin:SetShow(false)
  self._ui._btn_Start:SetShow(false)
  self._ui._joinProgressTimer._bg:SetShow(false)
  self._ui._midBattleMark:SetShow(false)
  self._ui._txt_progress:SetShow(false)
  self._ui._txt_progressGlow:SetShow(false)
  self._ui._notJoinText:SetShow(false)
  self._ui._guildAinfo._bg:SetShow(false)
  self._ui._joinBothGuild._bg:SetShow(false)
  self._ui._txt_BottomDesc:SetShow(false)
end
function PaGlobal_GuildBattle:SetGuildMark(guildNo, mark)
  local isSet = setGuildTextureByGuildNo(guildNo, mark)
  if false == isSet then
    mark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(mark, 183, 1, 188, 6)
    mark:getBaseTexture():setUV(x1, y1, x2, y2)
    mark:setRenderTexture(mark:getBaseTexture())
  else
    mark:getBaseTexture():setUV(0, 0, 1, 1)
    mark:setRenderTexture(mark:getBaseTexture())
  end
end
function PaGlobal_GuildBattle:SetGuildInfoOneReserved(guildBattleInfo)
  if nil == Panel_Window_Guild then
    return
  end
  self:SetGuildMark(guildBattleInfo:getNo(), self._ui._guildAinfo._name)
  self._ui._guildAinfo._name:SetText(guildBattleInfo:getName())
  self._ui._guildAinfo._master:SetText(guildBattleInfo:getMaster())
  self._ui._guildAinfo._ranking:SetText(tostring(guildBattleInfo:getRanking()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RANKING"))
  self._ui._guildAinfo._rating:SetText(tostring(guildBattleInfo:getRating()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_POINT"))
end
function PaGlobal_GuildBattle:SetGuildInfoBothReserved(index, guildBattleInfo)
  if nil == Panel_Window_Guild then
    return
  end
  if 0 == index then
    self:SetGuildMark(guildBattleInfo:getNo(), self._ui._joinBothGuild._guildANameMark)
    self._ui._joinBothGuild._guildANameMark:SetText(guildBattleInfo:getName())
    self._ui._joinBothGuild._guildAMaster:SetText(guildBattleInfo:getMaster())
    self._ui._joinBothGuild._guildAranking:SetText(tostring(guildBattleInfo:getRanking()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RANKING"))
    self._ui._joinBothGuild._guildArating:SetText(tostring(guildBattleInfo:getRating()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_POINT"))
    self._ui._joinBothGuild._guildAScore:SetText(tostring(guildBattleInfo:winPoint()))
  else
    self:SetGuildMark(guildBattleInfo:getNo(), self._ui._joinBothGuild._guildBNameMark)
    self._ui._joinBothGuild._guildBNameMark:SetText(guildBattleInfo:getName())
    self._ui._joinBothGuild._guildBMaster:SetText(guildBattleInfo:getMaster())
    self._ui._joinBothGuild._guildBranking:SetText(tostring(guildBattleInfo:getRanking()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RANKING"))
    self._ui._joinBothGuild._guildBrating:SetText(tostring(guildBattleInfo:getRating()) .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_POINT"))
    self._ui._joinBothGuild._guildBScore:SetText(tostring(guildBattleInfo:winPoint()))
  end
end
function PaGlobal_GuildBattle:UpdateGuildBattleInfo()
  if nil == Panel_Window_Guild then
    return
  end
  local guildA = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(0)
  local guildB = ToClient_GuildBattle_GetCurrentServerGuildBattleInfo(1)
  local amIGuildMasterOrSubMaster = getSelfPlayer():get():isGuildMaster() or getSelfPlayer():get():isGuildSubMaster()
  local amIMaster = ToClient_GuildBattle_AmIMasterForThisBattle()
  local MyGuildServer = ToClient_GuildBattle_GetMyGuildBattleServer()
  local curChannelData = getCurrentChannelServerData()
  local isCurrentGuildServer = false
  local guildCount = 2
  local attendGuild = -1
  local didIJoinGuildBattle = ToClient_getJoinGuildBattle()
  local battleState = ToClient_GuildBattle_GetCurrentState()
  local battleMode = ToClient_GuildBattle_GetCurrentMode()
  self:turnOffAllControl()
  if 0 ~= MyGuildServer and MyGuildServer ~= curChannelData._serverNo then
    local channelName = getChannelName(curChannelData._worldNo, MyGuildServer)
    self._ui._notJoinText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ANOTHERSERVER", "server", channelName))
    self._ui._notJoinText:SetShow(true)
    self._ui._txt_BottomDesc:SetShow(true)
    return
  elseif MyGuildServer == curChannelData._serverNo then
    isCurrentGuildServer = true
  end
  if nil == guildA then
    guildCount = guildCount - 1
  end
  if nil == guildB then
    guildCount = guildCount - 1
  end
  if 0 == guildCount then
    self._ui._txt_BottomDesc:SetShow(true)
    self._ui._backgroundMainBG:SetSize(710, 550 - self._ui._txt_BottomDesc:GetTextSizeY())
    self._ui._notJoinText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_NOGUILD"))
    self._ui._notJoinText:SetShow(true)
    if true == amIGuildMasterOrSubMaster then
      self._ui._btn_Reservation:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_RESERVE_BUTTON"))
      self._ui._btn_Reservation:SetShow(true)
      self._ui._btn_Reservation:SetSpanSize(0, 250)
    end
  elseif 1 == guildCount then
    if nil ~= guildA then
      self:SetGuildInfoOneReserved(guildA)
    else
      self:SetGuildInfoOneReserved(guildB)
    end
    self._ui._guildAinfo._bg:SetShow(true)
    self._ui._backgroundMainBG:SetSize(710, 580)
    if true == isCurrentGuildServer then
      if true == amIGuildMasterOrSubMaster then
        self._ui._btn_Cancle:SetShow(true)
        self._ui._btn_Cancle:SetSpanSize(0, 85)
      end
    elseif true == amIGuildMasterOrSubMaster then
      self._ui._btn_Reservation:SetShow(true)
      self._ui._btn_Reservation:SetSpanSize(0, 85)
    end
  else
    self:SetGuildInfoBothReserved(0, guildA)
    self:SetGuildInfoBothReserved(1, guildB)
    self._ui._joinBothGuild._bg:SetShow(true)
    self._ui._joinBothGuild._CompleteBG:SetShow(true)
    self._ui._backgroundMainBG:SetSize(710, 580)
    self._ui._txt_progress:useGlowFont(true, "BaseFont_10_Glow", 4279004349)
    self._ui._txt_progress:SetShow(true)
    if __eGuildBattleState_Idle == battleState then
      self._ui._txt_progress:SetText((PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_MATCHING")))
    elseif __eGuildBattleState_Join == battleState then
      self._ui._txt_progress:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLESTATE_JOIN"))
    elseif __eGuildBattleState_End == battleState then
      self._ui._txt_progress:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLESTATE_END"))
    elseif __eGuildBattleGameMode_Normal == battleMode then
      self._ui._txt_progress:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_NORMAL") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ONGOING"))
    elseif __eGuildBattleGameMode_OneOne == battleMode then
      self._ui._txt_progress:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_ONEONE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ONGOING"))
    elseif __eGuildBattleGameMode_All == battleMode then
      self._ui._txt_progress:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_BATTLEMODE_ALL") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ONGOING"))
    end
    if true == isCurrentGuildServer and __eGuildBattleState_Join == battleState then
      self._ui._joinBothGuild._CompleteBG:SetShow(false)
      self._ui._joinProgressTimer._bg:SetShow(true)
      if true == amIGuildMasterOrSubMaster then
        if true == amIMaster then
          if true == didIJoinGuildBattle then
            self._ui._btn_Start:SetShow(true)
            self._ui._btn_UnJoin:SetShow(true)
            self._ui._btn_Start:SetSpanSize(-100, 85)
            self._ui._btn_UnJoin:SetSpanSize(100, 85)
          else
            self._ui._btn_Join:SetShow(true)
            self._ui._btn_Cancle:SetShow(true)
            self._ui._btn_Join:SetSpanSize(-100, 85)
            self._ui._btn_Cancle:SetSpanSize(100, 85)
          end
        elseif true == didIJoinGuildBattle then
          self._ui._btn_UnJoin:SetShow(true)
          self._ui._btn_UnJoin:SetSpanSize(0, 85)
        else
          self._ui._btn_Join:SetShow(true)
          self._ui._btn_Cancle:SetShow(true)
          self._ui._btn_Join:SetSpanSize(-100, 85)
          self._ui._btn_Cancle:SetSpanSize(100, 85)
        end
      elseif true == didIJoinGuildBattle then
        self._ui._btn_UnJoin:SetShow(true)
        self._ui._btn_UnJoin:SetSpanSize(0, 85)
      else
        self._ui._btn_Join:SetShow(true)
        self._ui._btn_Join:SetSpanSize(0, 85)
      end
    end
    if false == didIJoinGuildBattle and battleState ~= __eGuildBattleState_Idle and battleState ~= __eGuildBattleState_Join then
      self._ui._txt_progress:SetText(PaGlobal_GuildBattle:GetTitle() .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ONGOING"))
    end
  end
  if false == self._CanCancel then
    self._ui._btn_Cancle:SetShow(false)
  end
end
function PaGlobal_GuildBattle:isOneOneMode()
  local gamemode = ToClient_GuildBattle_GetCurrentMode()
  return __eGuildBattleGameMode_OneOne == gamemode
end
function PaGlobal_GuildBattle:notifyJoinGuildBattle()
  local msg = {
    main = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_USE_GUILDWINDOW"),
    sub = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SET_BATTLE"),
    addMsg = ""
  }
  Proc_ShowMessage_Ack_For_RewardSelect(msg, 6, 78)
  ToClient_GuildBattle_UpdateGuildBattleInfo()
end
function PaGlobal_GuildBattle:ModeChangeRequest(mode)
end
function PaGlobal_GuildBattle:Open()
  if nil == Panel_Window_Guild then
    return
  end
  ToClient_GuildBattle_UpdateGuildBattleInfo()
  self._ui._guildBattleBG:SetShow(true)
end
function FGlobal_GuildBattle_Open()
  PaGlobal_GuildBattle:Open()
end
function PaGlobal_GuildBattle:Close()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._guildBattleBG:SetShow(false)
end
function FGlobal_GuildBattle_Close()
  PaGlobal_GuildBattle:Close()
end
function PaGlobal_GuildBattle:IsShow()
  if nil == Panel_Window_Guild then
    return false
  end
  return self._ui._guildBattleBG:GetShow()
end
function FGlobal_GuildBattle_IsOpen()
  return PaGlobal_GuildBattle:IsShow()
end
function PaGlobal_GuildBattle:UpdateRemainTime()
  if nil == Panel_Window_Guild then
    return
  end
  local remainTime = ToClient_GuildBattle_GetRemainTime()
  local remainTimeOriginal = ToClient_GuildBattle_GetRemainTimeOriginal()
  if remainTime < 0 then
    remainTime = 0
  end
  local min = math.floor(remainTime / 60)
  local sec = math.floor(remainTime % 60)
  self._ui._joinProgressTimer._timeText:SetText(tostring(min) .. tostring(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_MINUTE")) .. tostring(sec) .. tostring(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND")))
  self._ui._joinProgressTimer._progressBar:SetProgressRate(remainTime * 100 / remainTimeOriginal)
end
function PaGlobal_GuildBattle:Reservation()
  ToClient_GuildBattle_ReserveGuildBattle(self._battingPrice)
end
function PaGlobal_GuildBattle:Reservation_Cancel()
  ToClient_GuildBattle_CancelGuildBattle()
end
function PaGlobal_GuildBattle:Join()
  if true == ToClient_isPersonalBattle() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_CANNOT_GUILDBATTLE_SERVER"))
    return
  end
  local rv = ToClient_CheckToJoinBattle()
  if 0 ~= rv then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoRestrictedToJoinBattle"))
    return
  end
  ToClient_GuildBattle_JoinGuildBattle()
end
function PaGlobal_GuildBattle:UnJoin()
  ToClient_GuildBattle_UnjoinGuildBattle()
end
function PaGlobal_GuildBattle:Start()
  ToClient_GuildBattle_StartGuildBattle()
  Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_WE_ARE_READY_SHORT"))
end
function PaGlobal_GuildBattle:UseFreeCam()
  ToClient_GuildBattle_SetFreeCamMode()
end
function PaGlobal_GuildBattle:SetPrice()
  if nil == Panel_Window_Guild then
    return
  end
  local function setEditText(inputNumber)
    self._ui._edit_PriceInput:SetText(makeDotMoney(inputNumber))
    self._battingPrice = Int64toInt32(inputNumber)
  end
  local myGuildInfo = ToClient_GuildBattle_GetMyGuildInfoWrapper()
  local getGuildMoney = myGuildInfo:getGuildBusinessFunds_s64()
  Panel_NumberPad_Show(true, getGuildMoney, 0, setEditText)
end
function PaGlobal_GuildBattle:GetTitle()
  if true == ToClient_isPersonalBattle() then
    return PAGetString(Defines.StringSheet_GAME, "LUA_PERSONALBATTLE")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE")
  end
end
function PaGlobal_GuildBattle:registEventHandler()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._btn_Reservation:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:Reservation()")
  self._ui._btn_Cancle:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:Reservation_Cancel()")
  self._ui._btn_Join:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:Join()")
  self._ui._btn_UnJoin:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:UnJoin()")
  self._ui._btn_Start:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:Start()")
  self._ui._edit_PriceInput:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle:SetPrice()")
end
function PaGlobal_GuildBattle:registMessageHandler()
  registerEvent("FromClient_notifyGuildBattleJoin", "FromClient_notifyGuildBattleJoin")
  registerEvent("FromClient_responseRequestGuildBattleInfo", "FromClient_responseRequestGuildBattleInfo")
  registerEvent("FromClient_ReserveGuildBattleSuccess", "FromClient_ReserveGuildBattleSuccess")
  registerEvent("FromClient_guildBattleModeChangeRequest", "FromClient_guildBattleModeChangeRequest")
  registerEvent("FromClient_cancelAnotherGuild", "FromClient_cancelAnotherGuild")
end
function FromClient_ReserveGuildBattleSuccess(cancel)
  PaGlobal_GuildBattle:SetProgressServer(cancel)
  ToClient_GuildBattle_UpdateGuildBattleInfo()
end
function FromClient_responseRequestGuildBattleInfo()
  PaGlobal_GuildBattle:UpdateGuildBattleInfo()
end
function FromClient_notifyGuildBattleJoin()
  PaGlobal_GuildBattle:notifyJoinGuildBattle()
end
function FromClient_guildBattleModeChangeRequest(mode)
  PaGlobal_GuildBattle:ModeChangeRequest(mode)
end
function FromClient_cancelAnotherGuild(cancel)
  if true == cancel then
    ToClient_GuildBattle_UpdateGuildBattleInfo()
  end
end
function FromClient_luaLoadComplete_GuildBattleWindow()
  PaGlobal_GuildBattle_Init()
  PaGlobal_GuildBattle:registMessageHandler()
  ToClient_GuildBattle_UpdateGuildBattleInfo()
end
function PaGlobal_GuildBattle_Init()
  PaGlobal_GuildBattle:Initialize()
  PaGlobal_GuildBattle:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildBattleWindow")
function guildbattleStop(isstop)
  ToClient_GuildBattle_RequestGuildBattleStop(isstop)
end
