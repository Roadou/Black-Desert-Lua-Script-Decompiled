Panel_DeadMessage_Renew:SetShow(false)
local deadMessage = {
  _ui = {
    _staticText_resurrectionTime = UI.getChildControl(Panel_DeadMessage_Renew, "ResurrectionTime"),
    _staticText_Dead = UI.getChildControl(Panel_DeadMessage_Renew, "StaticText_Dead"),
    _staticText_Who = UI.getChildControl(Panel_DeadMessage_Renew, "StaticText_Who"),
    _staticText_DropItem_Template = UI.getChildControl(Panel_DeadMessage_Renew, "StaticText_DropItem_Template"),
    _button_Template = UI.getChildControl(Panel_DeadMessage_Renew, "Button_Template"),
    _staticText_DropItem = {},
    _button_Respawn = {},
    _staticText_A_ConsoleUI = nil,
    _staticText_X_ConsoleUI = nil,
    _static_BottomBg = UI.getChildControl(Panel_DeadMessage_Renew, "Static_BottomBg"),
    _static_Bg = UI.getChildControl(Panel_DeadMessage_Renew, "Static_Bg"),
    _static_Effect = UI.getChildControl(Panel_DeadMessage_Renew, "Static_Effect")
  },
  _config = {
    _eRespawnType = {
      respawnType_None = 0,
      respawnType_Immediate = 1,
      respawnType_ByOtherPlayer = 2,
      respawnType_Exploration = 3,
      respawnType_NearTown = 4,
      respawnType_TimeOver = 5,
      respawnType_InSiegeingFortress = 6,
      respawnType_LocalWar = 7,
      respawnType_AdvancedBase = 8,
      respawnType_GuildSpawn = 9,
      respawnType_Competition = 10,
      respawnType_SavageDefence = 11,
      respawnType_Volunteer = 12,
      respawnType_GuildBatle = 13,
      respawnType_Plunder = 14,
      respawnType_GuildTeamBattle = 15,
      respawnType_OutsideGate = 16,
      respawnType_InsideGate = 17,
      respawnType_Count = 18
    },
    _paneltyStringMaxCount = 10,
    _respawnButtonMaxCount = 9,
    _eDeadType = {
      Dead_Normal = 0,
      DeadLocate_InPlunder = 1,
      DeadLocate_InBattleGround = 2,
      DeadLocate_InCompetition = 3,
      DeadLocate_InSavageDefence = 4,
      DeadLocate_InGuildBattle = 5,
      DeadLocate_InGuildTeamBattle = 6,
      DeadLocate_InPVP = 7,
      DeadLocate_InLocarWar = 8,
      DeadLocate_InPrision = 9,
      DeadLocate_InSiegeBeingChannel = 10,
      DeadLocate_InSiegeBeingInCurrentPos = 11,
      DeadLocate_InSiegeBattle = 12,
      DeadLocate_InMajorSiegeBattle = 13,
      DeadLocate_InNoAccessArea = 14,
      DeadLocate_InArena = 15,
      IsSpecialCharacter = 16
    },
    _ButtonListByDeadType = {},
    _eButtonType = {
      Immediate = 1,
      ByOtherPlayer = 2,
      NearTown = 3,
      Exploration = 4,
      TimeOver = 5,
      InSiegeingFortress = 6,
      LocalWar = 7,
      AdvancedBase = 8,
      GuildSpawn = 9,
      Competition = 10,
      SavageDefence = 11,
      Volunteer = 12,
      GuildBatle = 13,
      Plunder = 14,
      GuildTeamBattle = 15,
      OutsideGate = 16,
      InsideGate = 17,
      Observer = 18,
      GuildObServerMode = 19,
      count = 21
    },
    _ButtonString = {},
    _ButtonEvent = {},
    _buttonAbleTime = 10,
    _revivalTime = 600,
    _aniType = {_changeColor = 0, _changeScale = 1},
    _deadCheckGap = 10
  },
  _isHasResotreExp = false,
  _isAblePvPMatchRevive = false,
  _currentDeadType = nil,
  _currentPaneltyStringCount = 0,
  _buttonTypeArray = nil,
  _buttonWaitTime = 0,
  _isUseButtonAbleTime = false,
  _resurrectionTime = 0,
  _lastUpdateTime = 0,
  _tempButtonAbleTimeForGuildObserver = 0,
  _startTimeForGuildObserver = nil,
  _isObserverMode = false,
  _deadCheckTime = 0
}
function PaGlobalFunc_DeadMessage_ResetObserverMode()
  local self = deadMessage
  self._isObserverMode = false
end
function deadMessage:initialize()
  self:createControl()
  self:initControl()
end
function deadMessage:createControl()
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local startY = scrSizeY * 0.37
  for index = 0, self._config._paneltyStringMaxCount - 1 do
    local dropText = UI.cloneControl(self._ui._staticText_DropItem_Template, Panel_DeadMessage_Renew, "_staticText_DropItem_" .. index)
    dropText:SetPosY(startY + dropText:GetSizeY() * 1.5 * index)
    dropText:SetShow(false)
    self._ui._staticText_DropItem[index] = dropText
  end
  startY = scrSizeY * 0.7
  for index = 0, self._config._respawnButtonMaxCount - 1 do
    local respawnButton = UI.cloneControl(self._ui._button_Template, Panel_DeadMessage_Renew, "_respawn_Button_" .. index)
    respawnButton:SetIgnore(false)
    respawnButton:SetPosY(startY + respawnButton:GetSizeY() * 1.2 * index)
    respawnButton:SetShow(false)
    self._ui._button_Respawn[index] = respawnButton
  end
  self._ui._button_Template:SetShow(false)
  self._ui._staticText_DropItem_Template:SetShow(false)
  self._ui._staticText_A_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui._staticText_X_ConsoleUI = UI.getChildControl(self._ui._static_BottomBg, "StaticText_X_ConsoleUI")
  self._ui._staticText_A_ConsoleUI:SetShow(false)
  self._ui._staticText_X_ConsoleUI:SetShow(false)
end
function deadMessage:setButtonString()
  local button = self._config._eButtonType
  local buttonString = self._config._ButtonString
  buttonString[button.Immediate] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_IMMEDIATE")
  buttonString[button.Exploration] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_MOVEEXPLORATION")
  buttonString[button.NearTown] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_MOVETOWN")
  buttonString[button.InSiegeingFortress] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_SIEGEING")
  buttonString[button.LocalWar] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_LOCALWAR")
  buttonString[button.AdvancedBase] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_ADVANCEDBASE")
  buttonString[button.GuildSpawn] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_GUILDSPAWN")
  buttonString[button.Competition] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMPETITIONGAME_PVP_EXIT")
  buttonString[button.SavageDefence] = PAGetString(Defines.StringSheet_GAME, "LUA_MENU_WAVE_OUT")
  buttonString[button.Volunteer] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_BTN_VALUNTEER")
  buttonString[button.Plunder] = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_IMMEDIATE_RESURRECTION")
  buttonString[button.GuildTeamBattle] = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_IMMEDIATE_RESURRECTION")
  buttonString[button.OutsideGate] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_OUTSIDEGATE_BUTTON")
  buttonString[button.InsideGate] = PAGetString(Defines.StringSheet_RESOURCE, "DEADMESSAGE_INSIDEGATE_BUTTON")
  buttonString[button.Observer] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_DEADMESSAGE_WATCHINGMODE")
  buttonString[button.GuildObServerMode] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWATCH_BUTTON")
end
function deadMessage:setButtonList()
  local buttonList = self._config._ButtonListByDeadType
  local button = self._config._eButtonType
  local deadType = self._config._eDeadType
  buttonList[deadType.Dead_Normal] = {
    [0] = button.Immediate,
    [1] = button.NearTown,
    [2] = button.Exploration,
    [3] = button.GuildSpawn,
    [4] = button.AdvancedBase
  }
  buttonList[deadType.DeadLocate_InPlunder] = {
    [0] = button.NearTown,
    [1] = button.Plunder,
    [2] = button.Observer
  }
  buttonList[deadType.DeadLocate_InBattleGround] = {
    [0] = button.Immediate
  }
  buttonList[deadType.DeadLocate_InCompetition] = {
    [0] = button.Immediate,
    [1] = button.Observer
  }
  buttonList[deadType.DeadLocate_InSavageDefence] = {
    [0] = button.Observer,
    [1] = button.SavageDefence
  }
  buttonList[deadType.DeadLocate_InGuildBattle] = {
    [0] = button.Immediate,
    [1] = button.Observer
  }
  buttonList[deadType.DeadLocate_InGuildTeamBattle] = {
    [0] = button.GuildTeamBattle,
    [1] = button.Immediate
  }
  buttonList[deadType.DeadLocate_InPVP] = {
    [0] = button.Immediate
  }
  buttonList[deadType.DeadLocate_InLocarWar] = {
    [0] = button.LocalWar
  }
  buttonList[deadType.DeadLocate_InPrision] = {}
  buttonList[deadType.DeadLocate_InSiegeBeingChannel] = {
    [0] = button.NearTown,
    [1] = button.Exploration,
    [2] = button.Volunteer,
    [3] = button.Observer,
    [4] = button.GuildSpawn,
    [5] = button.AdvancedBase
  }
  buttonList[deadType.DeadLocate_InSiegeBeingInCurrentPos] = {
    [0] = button.NearTown,
    [1] = button.Volunteer,
    [2] = button.Observer,
    [3] = button.GuildSpawn,
    [4] = button.AdvancedBase
  }
  buttonList[deadType.DeadLocate_InSiegeBattle] = {
    [0] = button.NearTown,
    [1] = button.InSiegeingFortress,
    [2] = button.Volunteer,
    [3] = button.Observer,
    [4] = button.GuildSpawn,
    [5] = button.AdvancedBase
  }
  buttonList[deadType.DeadLocate_InMajorSiegeBattle] = {
    [0] = button.NearTown,
    [1] = button.OutsideGate,
    [2] = button.InsideGate,
    [3] = button.InSiegeingFortress,
    [4] = button.Volunteer,
    [5] = button.Observer,
    [6] = button.GuildSpawn,
    [7] = button.AdvancedBase
  }
  buttonList[deadType.DeadLocate_InNoAccessArea] = {
    [0] = button.NearTown,
    [1] = button.Exploration,
    [2] = button.GuildSpawn,
    [3] = button.AdvancedBase
  }
  buttonList[deadType.IsSpecialCharacter] = {
    [0] = button.Immediate
  }
end
function deadMessage:setButtonEvent()
  local buttonEvent = self._config._ButtonEvent
  local button = self._config._eButtonType
  buttonEvent[button.Immediate] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_Immediate"
  buttonEvent[button.Exploration] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_Exploration"
  buttonEvent[button.NearTown] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_NearTown"
  buttonEvent[button.InSiegeingFortress] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_InSiegeingFortress"
  buttonEvent[button.LocalWar] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_LocalWar"
  buttonEvent[button.AdvancedBase] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_AdvancedBase"
  buttonEvent[button.GuildSpawn] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildSpawn"
  buttonEvent[button.SavageDefence] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_SavageDefence"
  buttonEvent[button.Volunteer] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_Volunteer"
  buttonEvent[button.Plunder] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_Plunder"
  buttonEvent[button.GuildTeamBattle] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildTeamBattle"
  buttonEvent[button.OutsideGate] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_OutsideGate"
  buttonEvent[button.InsideGate] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_InsideGate"
  buttonEvent[button.Observer] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_Observer"
  buttonEvent[button.GuildObServerMode] = "PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildObserverMode"
end
function deadMessage:initControl()
  self:setButtonString()
  self:setButtonList()
  self:setButtonEvent()
end
function deadMessage:resetData()
  self._isHasResotreExp = false
  self._isAblePvPMatchRevive = false
  self._currentDeadType = nil
  self._currentPaneltyStringCount = 0
  self._isObserverMode = false
  self._deadCheckTime = 0
  self._buttonTypeArray = nil
  self._buttonWaitTime = 0
  self._isUseButtonAbleTime = false
  self._resurrectionTime = self._config._revivalTime
  self._lastUpdateTime = 0
  self._tempButtonAbleTimeForGuildObserver = nil
  self._startTimeForGuildObserver = nil
  if nil ~= Panel_Window_WorkerManager_Renew then
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, "")
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
    Panel_Window_WorkerManager_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  end
  self._ui._staticText_A_ConsoleUI:SetShow(false)
  self._ui._staticText_X_ConsoleUI:SetShow(false)
end
function PaGlobalFunc_DeadMessage_TemporaryOpen()
  deadMessage:temporaryOpen()
end
function PaGlobalFunc_DeadMessage_TemporaryClose()
  deadMessage:temporaryClose()
end
function deadMessage:temporaryOpen()
end
function deadMessage:temporaryClose()
  self._ui._staticText_A_ConsoleUI:SetShow(false)
  self._ui._staticText_X_ConsoleUI:SetShow(false)
end
function PaGlobalFunc_DeadMessage_Open()
  PaGlobalFunc_DeadMessage_ResetObserverMode()
  deadMessage:open()
end
function deadMessage:open()
  if true == Panel_DeadMessage_Renew:GetShow() then
    return
  end
  Panel_DeadMessage_Renew:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_IN)
end
function PaGlobalFunc_DeadMessage_Close()
  deadMessage:close()
end
function deadMessage:close()
  if false == Panel_DeadMessage_Renew:GetShow() then
    return
  end
  deadMessage:resetPaneltyStringControl()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_DeadMessage_Renew:SetShow(false, false)
end
function deadMessage:resetPaneltyStringControl()
  for index = 0, self._config._paneltyStringMaxCount - 1 do
    if nil ~= self._ui._staticText_DropItem[index] then
      self._ui._staticText_DropItem[index]:SetShow(false)
      self._ui._staticText_DropItem[index]:SetText("")
    end
  end
end
function deadMessage:setSize()
  if false == Panel_DeadMessage_Renew:GetShow() then
    return
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  Panel_DeadMessage_Renew:SetSize(scrSizeX, scrSizeY)
  Panel_DeadMessage_Renew:ComputePos()
  self._ui._static_BottomBg:SetSize(scrSizeX, self._ui._static_BottomBg:GetSizeY())
  self._ui._static_BottomBg:ComputePos()
  self._ui._staticText_Dead:ComputePos()
  self._ui._staticText_Who:ComputePos()
  self._ui._staticText_resurrectionTime:ComputePos()
  self._ui._staticText_A_ConsoleUI:ComputePos()
  self._ui._staticText_X_ConsoleUI:ComputePos()
  local sizeY = self._ui._static_Bg:GetSizeY()
  self._ui._static_Bg:SetSize(getOriginScreenSizeX(), sizeY)
  self._ui._static_Bg:ComputePosAllChild()
  self._ui._staticText_A_ConsoleUI:SetPosX(scrSizeX * 0.5 - self._ui._staticText_A_ConsoleUI:GetSizeX() - 50)
  self._ui._staticText_X_ConsoleUI:SetPosX(scrSizeX * 0.5 + self._ui._staticText_X_ConsoleUI:GetSizeX())
  if nil == self._buttonTypeArray then
    return
  end
  local startPosY = scrSizeY * 0.65
  local startPosX = scrSizeX * 0.5 - self._ui._button_Respawn[0]:GetSizeX() * 0.5
  local gabX = self._ui._button_Respawn[0]:GetSizeX() * 1.5
  local gabY = self._ui._button_Respawn[0]:GetSizeY() * 1.2
  local buttonCount = table.getn(self._buttonTypeArray)
  local buttonControl = self._ui._button_Respawn
  if buttonCount < 5 then
    for index = 0, buttonCount do
      buttonControl[index]:SetPosX(startPosX)
      buttonControl[index]:SetPosY(startPosY + index * gabY)
    end
  else
    for index = 0, math.floor(buttonCount / 2) - 1 do
      buttonControl[index]:SetPosX(startPosX - gabX)
      buttonControl[index]:SetPosY(startPosY + index * gabY)
    end
    for index = math.floor(buttonCount / 2), buttonCount - 1 do
      buttonControl[index]:SetPosX(startPosX + gabX)
      buttonControl[index]:SetPosY(startPosY + (index - math.floor(buttonCount / 2)) * gabY)
    end
  end
  self._ui._static_Effect:SetSize(getOriginScreenSizeX(), getOriginScreenSizeY())
  self._ui._static_Effect:ComputePos()
end
function deadMessage:update()
end
function PaGlobalFunc_DeadMessage_Update(deltaTime)
  local self = deadMessage
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer or nil == selfPlayer:get() then
    return
  end
  self._deadCheckTime = self._deadCheckTime + deltaTime
  if self._config._deadCheckGap < self._deadCheckTime then
    self._deadCheckTime = 0
    if true == selfPlayer:isDead() or 0 >= selfPlayer:get():getHp() then
      if false == self._isObserverMode then
        PaGlobalFunc_DeadMessage_Open()
      end
    else
      PaGlobalFunc_DeadMessage_Close()
    end
  end
  if false == Panel_DeadMessage_Renew:GetShow() then
    return
  end
  local isMyChannelSiegeBeing = deadMessage_isSiegeBeingMyChannel()
  if true == self._isUseButtonAbleTime then
    self._buttonWaitTime = self._buttonWaitTime - deltaTime
    if 0 > self._buttonWaitTime and nil ~= self._buttonTypeArray then
      local UIindex = 0
      local buttonControl = self._ui._button_Respawn
      for index = 1, #self._buttonTypeArray do
        local control = buttonControl[UIindex]
        control:SetEnable()
        UIindex = UIindex + 1
      end
      self._isUseButtonAbleTime = false
    end
  end
  if nil == self._resurrectionTime then
    self._ui._staticText_resurrectionTime:SetShow(false)
    return
  end
  if 0 < self._resurrectionTime then
    self._resurrectionTime = self._resurrectionTime - deltaTime
    local regenTime = math.floor(self._resurrectionTime)
    if self._lastUpdateTime == regenTime then
      return
    end
    self._lastUpdateTime = regenTime
    self._ui._staticText_resurrectionTime:SetShow(true)
    if true == self._isUseButtonAbleTime and false == isMyChannelSiegeBeing then
      self._ui._staticText_resurrectionTime:SetText(PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RespawnWaitting"))
    else
      self._ui._staticText_resurrectionTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TIME", "regenTime", tostring(regenTime)))
    end
    if regenTime > 0 then
      return
    end
    self._ui._staticText_resurrectionTime:SetShow(false)
    if true == goToPrison() then
      deadMessage_Revival(self._config._eRespawnType.respawnType_TimeOver, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
    elseif true == isMyChannelSiegeBeing or 0 ~= getSelfPlayer():get():getVolunteerTeamNoForLua() then
    elseif true == ToClient_IsSelfInGuildTeamBattle() then
      deadMessage_Revival(self._config._eRespawnType.respawnType_GuildTeamBattle, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
    else
      local aniInfo1 = self._ui._static_Effect:addColorAnimation(0, 1, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
      aniInfo1:SetStartColor(Defines.Color.C_FFFFFFFF)
      aniInfo1:SetEndColor(Defines.Color.C_00FFFFFF)
      aniInfo1.IsChangeChild = true
      aniInfo1:SetHideAtEnd(true)
      aniInfo1:SetDisableWhileAni(true)
      deadMessage_Revival(self._config._eRespawnType.respawnType_TimeOver, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
    end
    SetUIMode(Defines.UIMode.eUIMode_Default)
  else
    self._ui._staticText_resurrectionTime:SetShow(false)
  end
end
function deadMessage:perFrameUpdate(deltaTime)
end
function PaGlobalFunc_DeadMessage_PerFrameUpdate(deltaTime)
  deadMessage:perFrameUpdate(deltaTime)
end
function deadMessage:closeChannelMoveWindow()
  if false == _ContentsGroup_RenewUI_ExitGame then
    if Panel_GameExit:GetShow() then
      Panel_GameExit:SetShow(false)
    end
    if Panel_ChannelSelect:GetShow() then
      FGlobal_ChannelSelect_Hide()
    end
  else
    if true == PaGlobalFunc_GameExitCharMove_GetShow() then
      PaGlobalFunc_GameExitCharMove_SetShow(false, false)
    end
    if true == PaGlobalFunc_GameExit_GetShow() then
      PaGlobalFunc_GameExit_SetShow(false, false)
    end
    if true == _ContentsGroup_RenewUI_ServerSelect and true == PaGlobalFunc_ServerSelect_GetShow() then
      PaGlobalFunc_ServerSelect_Close()
    end
  end
end
function deadMessage:setDeadMessage(attackerActorKeyRaw, isSkipDeathPenalty, isHasRestoreExp, isAblePvPMatchRevive, respawnTime)
  self:resetData()
  self:closeChannelMoveWindow()
  close_attacked_WindowPanelList(true)
  SetUIMode(Defines.UIMode.eUIMode_DeadMessage)
  self._isHasResotreExp = isHasRestoreExp
  self._isAblePvPMatchRevive = isAblePvPMatchRevive
  self._currentDeadType = self:getDeadType()
  self:setResurrectionTime(respawnTime)
  self:setRespawnButton()
  self:showDeadMessage(attackerActorKeyRaw, isSkipDeathPenalty)
end
function FromClient_SelfPlayerRevive()
  PaGlobalFunc_DeadMessage_Close()
end
function FromClient_ShowDeadMessage(attackerActorKeyRaw, isSkipDeathPenalty, isHasRestoreExp, isAblePvPMatchRevive, respawnTime)
  deadMessage:setDeadMessage(attackerActorKeyRaw, isSkipDeathPenalty, isHasRestoreExp, isAblePvPMatchRevive, respawnTime)
end
function deadMessage:setResurrectionTime(respawnTime)
  local deadType = self._config._eDeadType
  local curDeadType = self._currentDeadType
  local selfProxy = getSelfPlayer()
  self._isUseButtonAbleTime = false
  if curDeadType == deadType.DeadLocate_InPlunder then
    self._resurrectionTime = self._config._revivalTime
  elseif curDeadType == deadType.DeadLocate_InBattleGround then
    self._resurrectionTime = self._config._revivalTime
  elseif curDeadType == deadType.DeadLocate_InCompetition then
    self._resurrectionTime = ToClient_CompetitionMatchTimeLimit() + ToClient_GetMaxWaitTime()
  elseif curDeadType == deadType.DeadLocate_InSavageDefence then
    self._resurrectionTime = 0
  elseif curDeadType == deadType.DeadLocate_InGuildBattle then
    self._resurrectionTime = 0
  elseif curDeadType == deadType.DeadLocate_InGuildTeamBattle then
    self._resurrectionTime = 25
  elseif curDeadType == deadType.DeadLocate_InPVP then
    self._resurrectionTime = self._config._revivalTime
  elseif curDeadType == deadType.DeadLocate_InLocarWar then
    self._resurrectionTime = nil
  elseif curDeadType == deadType.DeadLocate_InPrision then
    self._resurrectionTime = 2
  elseif curDeadType == deadType.IsSpecialCharacter then
    self._resurrectionTime = self._config._revivalTime
  elseif curDeadType == deadType.Dead_Normal or curDeadType == deadType.DeadLocate_InSiegeBeingChannel or curDeadType == deadType.DeadLocate_InSiegeBeingInCurrentPos or curDeadType == deadType.DeadLocate_InSiegeBattle or curDeadType == deadType.DeadLocate_InMajorSiegeBattle or curDeadType == deadType.DeadLocate_InNoAccessArea then
    if true == deadMessage_isSiegeBeingMyChannel() and deadMessage_isInSiegeBattle() or 0 ~= selfProxy:get():getVolunteerTeamNoForLua() then
      self._resurrectionTime = respawnTime / 1000
      if 0 ~= self._resurrectionTime then
        self._isUseButtonAbleTime = true
        self._buttonAbleTime = self._resurrectionTime
      end
    else
      self._resurrectionTime = 0
    end
  end
end
function deadMessage:getDeadType()
  local deadType = self._config._eDeadType
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return nil
  end
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local isArenaArea = regionInfo:get():isArenaArea()
  local isMyChannelSiegeBeing = deadMessage_isSiegeBeingMyChannel()
  local isSiegeBeingInCurrentPosition = deadMessage_isSiegeBeingInCurrentPosition()
  if true == ToClient_isPlunderGameBeing() then
    return deadType.DeadLocate_InPlunder
  end
  if true == selfProxy:get():isBattleGroundDefine() then
    return deadType.DeadLocate_InBattleGround
  end
  if true == selfProxy:get():isCompetitionDefined() then
    return deadType.DeadLocate_InCompetition
  end
  if true == ToClient_getPlayNowSavageDefence() then
    return deadType.DeadLocate_InSavageDefence
  end
  if true == ToClient_getJoinGuildBattle() then
    return deadType.DeadLocate_InGuildBattle
  end
  if true == ToClient_IsSelfInGuildTeamBattle() then
    return deadType.DeadLocate_InGuildTeamBattle
  end
  if true == self._isAblePvPMatchRevive then
    return deadType.DeadLocate_InPVP
  end
  if 0 ~= ToClient_GetMyTeamNoLocalWar() then
    return deadType.DeadLocate_InLocarWar
  end
  if true == regionInfo:isPrison() or true == goToPrison() then
    return deadType.DeadLocate_InPrision
  end
  if true == ToClient_isSpecialCharacter() then
    return deadType.IsSpecialCharacter
  end
  if true == deadMessage_isInMajorSiegeBattle() then
    return deadType.DeadLocate_InMajorSiegeBattle
  end
  if true == deadMessage_isInSiegeBattle() then
    return deadType.DeadLocate_InSiegeBattle
  end
  if true == isSiegeBeingInCurrentPosition then
    return deadType.DeadLocate_InSiegeBeingInCurrentPos
  end
  if true == isMyChannelSiegeBeing then
    return deadType.DeadLocate_InSiegeBeingChannel
  end
  return deadType.Dead_Normal
end
function deadMessage:setAniToControl(control, aniType, startTime, endTime, startValue, endValue, isDisable)
  if nil == control then
    return
  end
  local aniInfo
  if aniType == self._config._aniType._changeColor then
    aniInfo = control:addColorAnimation(startTime, endTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo:SetStartColor(startValue)
    aniInfo:SetEndColor(endValue)
  elseif aniType == self._config._aniType._changeScale then
    aniInfo = control:addScaleAnimation(startTime, endTime, CppEnums.PAUI_ANIM_ADVANCE_TYPE.PAUI_ANIM_ADVANCE_COS_HALF_PI)
    aniInfo:SetStartScale(startValue)
    aniInfo:SetEndScale(endValue)
  else
    return
  end
  aniInfo.IsChangeChild = true
  if true == isDisable then
    aniInfo:SetIgnoreUpdateSnapping(true)
    aniInfo:SetDisableWhileAni(true)
  end
end
function deadMessage:setDeadMessageAni()
  local buttonControl = self._ui._button_Respawn
  local button = self._config._eButtonType
  local aniType = self._config._aniType
  local buttonUIIndex = 0
  for index = 1, #self._buttonTypeArray do
    local buttonType = self._buttonTypeArray[index]
    local control = buttonControl[buttonUIIndex]
    if nil == control then
    elseif button.Immediate == buttonType then
      self:setAniToControl(control, aniType._changeColor, 0, 3, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF, true)
      self:setAniToControl(control, aniType._changeColor, 3, 4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF, true)
    elseif button.Exploration == buttonType or button.NearTown == buttonType or button.InSiegeingFortress == buttonType or button.LocalWar == buttonType or button.AdvancedBase == buttonType or button.GuildSpawn == buttonType or button.SavageDefence == buttonType or button.Volunteer == buttonType or button.Plunder == buttonType or button.GuildTeamBattle == buttonType or button.OutsideGate == buttonType or button.InsideGate == buttonType then
      self:setAniToControl(control, aniType._changeColor, 0, 3, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF, true)
      self:setAniToControl(control, aniType._changeColor, 3, 4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF, true)
      self:setAniToControl(control, aniType._changeScale, 2.5, 3.2, 0.5, 1, true)
    elseif button.Observer == buttonType or button.GuildObServerMode == buttonType then
      self:setAniToControl(control, aniType._changeColor, 0, 3, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF, true)
      self:setAniToControl(control, aniType._changeColor, 3, 4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF, true)
    end
    buttonUIIndex = buttonUIIndex + 1
  end
  local messageControl = self._ui._staticText_Dead
  self:setAniToControl(messageControl, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(messageControl, aniType._changeColor, 1.5, 2.3, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
  self:setAniToControl(messageControl, aniType._changeScale, 0.7, 2.5, 0.5, 1)
  messageControl = self._ui._staticText_Who
  self:setAniToControl(messageControl, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(messageControl, aniType._changeColor, 1.5, 2.3, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
  self:setAniToControl(messageControl, aniType._changeScale, 0.7, 2.5, 0.5, 1)
  messageControl = self._ui._static_Bg
  self:setAniToControl(messageControl, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(messageControl, aniType._changeColor, 1.5, 2.3, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
  messageControl = self._ui._staticText_resurrectionTime
  self:setAniToControl(messageControl, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(messageControl, aniType._changeColor, 2.2, 2.7, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
end
function deadMessage:showDeadMessage(attackerActorKeyRaw, isSkipDeathPenalty)
  local _eDeadType = self._config._eDeadType
  local deadType = self._currentDeadType
  local aniType = self._config._aniType
  local selfProxy = getSelfPlayer()
  local attackerActorProxyWrapper = getActor(attackerActorKeyRaw)
  local isMilitia = false
  local playerActorProxyWrapper = getPlayerActor(attackerActorKeyRaw)
  if nil ~= playerActorProxyWrapper then
    isMilitia = playerActorProxyWrapper:get():isVolunteer()
  end
  local deadMessageString = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DisplayMsg")
  local deadWhoString
  if _eDeadType.DeadLocate_InGuildTeamBattle == deadType then
    deadMessageString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDTEAMBATTLE_DEADATFIGHT")
  elseif attackerActorKeyRaw == selfProxy:getActorKey() then
  elseif nil ~= attackerActorProxyWrapper then
    if true == isMilitia then
      deadWhoString = PAGetStringParam1(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_KilledDisplayMsg", "attackerName", PAGetString(Defines.StringSheet_GAME, "LUA_WARINFOMESSAGE_MILITIA"))
    else
      deadWhoString = PAGetStringParam1(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_KilledDisplayMsg", "attackerName", attackerActorProxyWrapper:getOriginalName())
    end
  end
  self._ui._staticText_Dead:SetText(deadMessageString)
  self._ui._staticText_Dead:SetShow(true)
  if nil ~= deadWhoString then
    self._ui._staticText_Who:SetText(deadWhoString)
    self._ui._staticText_Who:SetShow(true)
  else
    self._ui._staticText_Who:SetShow(false)
  end
  if true == isSkipDeathPenalty then
    local control = self:getPaneltyStringControl()
    control:SetText(PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NoDeathPenalty"))
    control:SetShow(true)
    self:setAniToControl(control, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
    self:setAniToControl(control, aniType._changeColor, 3, 3.4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
  end
  self:open()
  self:setDeadMessageAni()
  self:setSize()
end
function deadMessage:checkButtonCondition_Immediate()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  local selfProxy = getSelfPlayer()
  if _eDeadType.DeadLocate_InBattleGround == deadType then
    if 0 ~= ToClient_GuildBattle_GetCurrentState() then
      return false
    end
  elseif _eDeadType.DeadLocate_InCompetition == deadType then
    if false == selfProxy:get():isCompetitionHost() then
      return false
    end
  elseif _eDeadType.Dead_Normal == deadType and false == FGlobal_IsCommercialService() then
    local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
    if false == regionInfo:get():isArenaArea() then
      return false
    end
  end
  return true
end
function deadMessage:checkButtonCondition_Volunteer()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  local selfProxy = getSelfPlayer()
  if (_eDeadType.DeadLocate_InSiegeBeingChannel == deadType or _eDeadType.DeadLocate_InSiegeBeingInCurrentPos == deadType or _eDeadType.DeadLocate_InSiegeBattle == deadType or _eDeadType.DeadLocate_InMajorSiegeBattle == deadType) and false == selfProxy:get():isVolunteer() then
    return false
  end
  return true
end
function deadMessage:checkButtonCondition_Observer()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  if _eDeadType.DeadLocate_InCompetition == deadType then
    if CppEnums.CompetitionMatchType.eCompetitionMatchMode_Personal == ToClient_CompetitionMatchType() then
      return false
    end
  elseif _eDeadType.DeadLocate_InGuildBattle == deadType then
    if 0 == ToClient_GuildBattle_GetCurrentState() then
      return false
    end
    if true == PaGlobal_GuildBattle:isOneOneMode() then
      return false
    end
  elseif _eDeadType.DeadLocate_InSiegeBeingChannel == deadType or _eDeadType.DeadLocate_InSiegeBeingInCurrentPos == deadType or _eDeadType.DeadLocate_InSiegeBattle == deadType or _eDeadType.DeadLocate_InMajorSiegeBattle == deadType then
    local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildInfo then
      return false
    end
    local guildNo = myGuildInfo:getGuildNo_s64()
    if false == ToClient_IsInSiegeBattle(guildNo) then
      return false
    end
  end
  return true
end
function deadMessage:checkButtonCondition_GuildObserverMode()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  return false
end
function deadMessage:checkButtonCondition_GuildSpawn()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  if _eDeadType.Dead_Normal == deadType or _eDeadType.DeadLocate_InNoAccessArea == deadType or _eDeadType.DeadLocate_InSiegeBeingChannel == deadType or _eDeadType.DeadLocate_InSiegeBeingInCurrentPos == deadType or _eDeadType.DeadLocate_InSiegeBattle == deadType or _eDeadType.DeadLocate_InMajorSiegeBattle == deadType then
    local guildUnSealCount = guildstable_getUnsealGuildServantCount()
    if 0 == guildUnSealCount then
      return false
    end
    local isGuildServant = false
    for index = 0, guildUnSealCount - 1 do
      local servantInfo = guildStable_getUnsealGuildServantAt(index)
      if nil ~= servantInfo and (CppEnums.VehicleType.Type_SailingBoat == servantInfo:getVehicleType() or CppEnums.VehicleType.Type_PersonalBattleShip == servantInfo:getVehicleType()) then
        isGuildServant = true
      end
    end
    if false == isGuildServant then
      return false
    end
  end
  return true
end
function deadMessage:checkButtonCondition_AdvancedBase()
  local deadType = self._currentDeadType
  local _eDeadType = self._config._eDeadType
  if _eDeadType.Dead_Normal == deadType or _eDeadType.DeadLocate_InNoAccessArea == deadType or _eDeadType.DeadLocate_InSiegeBeingChannel == deadType or _eDeadType.DeadLocate_InSiegeBeingInCurrentPos == deadType or _eDeadType.DeadLocate_InSiegeBattle == deadType or _eDeadType.DeadLocate_InMajorSiegeBattle == deadType then
    local selfProxy = getSelfPlayer()
    if false == selfProxy:get():isGuildMember() then
      return false
    end
    if false == selfProxy:get():isAdvancedBaseActorKey() then
      return false
    end
  end
  return true
end
function deadMessage:checkButtonCondition_MajorSiegeGate()
  return deadMessage_isInMajorSiegeBattle()
end
function deadMessage:checkButtonCondition(buttonType)
  local button = self._config._eButtonType
  if button.Immediate == buttonType then
    return self:checkButtonCondition_Immediate()
  elseif button.Observer == buttonType then
    return self:checkButtonCondition_Observer()
  elseif button.Volunteer == buttonType then
    return self:checkButtonCondition_Volunteer()
  elseif button.GuildObServerMode == buttonType then
    return self:checkButtonCondition_GuildObserverMode()
  elseif button.GuildSpawn == buttonType then
    return self:checkButtonCondition_GuildSpawn()
  elseif button.AdvancedBase == buttonType then
    return self:checkButtonCondition_AdvancedBase()
  elseif button.OutsideGate == buttonType then
    return self:checkButtonCondition_MajorSiegeGate()
  elseif button.InsideGate == buttonType then
    return self:checkButtonCondition_MajorSiegeGate()
  end
  return true
end
function deadMessage:setRespawnButton()
  local buttonString = self._config._ButtonString
  local buttonControl = self._ui._button_Respawn
  local deadType = self._currentDeadType
  self._buttonTypeArray = Array.new()
  local buttonArray = self._buttonTypeArray
  for index = 0, self._config._respawnButtonMaxCount - 1 do
    buttonControl[index]:SetShow(false)
  end
  local buttonList = self._config._ButtonListByDeadType[deadType]
  if nil == buttonList then
    return
  end
  for _, buttonType in pairs(buttonList) do
    if nil ~= buttonType and true == self:checkButtonCondition(buttonType) then
      buttonArray:push_back(buttonType)
    end
  end
  local buttonSort_do = function(a, b)
    return a < b
  end
  table.sort(buttonArray, buttonSort_do)
  local buttonUIIndex = 0
  for buttonIndex = 1, #buttonArray do
    local buttonType = buttonArray[buttonIndex]
    local buttonString = self._config._ButtonString[buttonType]
    buttonControl[buttonUIIndex]:addInputEvent("Mouse_On", "PaGlobalFunc_DeadMessage_ButtonMouseOnEvent(" .. buttonType .. ")")
    buttonControl[buttonUIIndex]:SetShow(true)
    buttonControl[buttonUIIndex]:SetText(buttonString)
    buttonUIIndex = buttonUIIndex + 1
  end
end
function deadMessage:buttonMouseOnEvent(buttonType)
  local _eDeadType = self._config._eDeadType
  local button = self._config._eButtonType
  local buttonEvent = self._config._ButtonEvent[buttonType]
  if nil == buttonEvent then
    return
  end
  local isSetXKey = true
  local selfProxy = getSelfPlayer()
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  if _eDeadType.DeadLocate_InPlunder == self._currentDeadType or _eDeadType.DeadLocate_InPlunder == self._currentDeadType or _eDeadType.DeadLocate_InBattleGround == self._currentDeadType or _eDeadType.DeadLocate_InCompetition == self._currentDeadType or _eDeadType.DeadLocate_InSavageDefence == self._currentDeadType or _eDeadType.DeadLocate_InGuildBattle == self._currentDeadType or _eDeadType.DeadLocate_InGuildTeamBattle == self._currentDeadType or _eDeadType.DeadLocate_InPVP == self._currentDeadType or _eDeadType.DeadLocate_InLocarWar == self._currentDeadType or _eDeadType.DeadLocate_InPrision == self._currentDeadType or _eDeadType.IsSpecialCharacter == self._currentDeadType then
    isSetXKey = false
  elseif true == FGlobal_IsCommercialService() then
    local freeRevivalLevel = FromClient_getFreeRevivalLevel()
    local isFreeArea = regionInfo:get():isFreeRevivalArea()
    if freeRevivalLevel >= selfProxy:get():getLevel() and true == isFreeArea then
      isSetXKey = false
    end
  else
    isSetXKey = false
  end
  if true == isSetXKey then
    if button.NearTown == buttonType or button.Exploration == buttonType or button.GuildSpawn == buttonType then
      isSetXKey = true
    else
      isSetXKey = false
    end
  end
  if true == isSetXKey then
    local prevExp = selfProxy:get():getPrevExp_s64()
    local currentExp = selfProxy:get():getExp_s64()
    local isArena = regionInfo:get():isArenaArea()
    if false == isArena and (true == self._isHasResotreExp or prevExp > currentExp) then
      isSetXKey = true
    else
      isSetXKey = false
    end
  end
  local scrSizeX = getScreenSizeX()
  self._ui._staticText_A_ConsoleUI:SetShow(true)
  self._ui._staticText_X_ConsoleUI:SetShow(isSetXKey)
  Panel_DeadMessage_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_A, buttonEvent .. "()")
  Panel_DeadMessage_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  if true == isSetXKey then
    Panel_DeadMessage_Renew:registerPadEvent(__eConsoleUIPadEvent_Up_X, buttonEvent .. "(true)")
    self._ui._staticText_A_ConsoleUI:SetPosX(scrSizeX * 0.5 - self._ui._staticText_A_ConsoleUI:GetTextSizeX() - 44)
    self._ui._staticText_X_ConsoleUI:SetPosX(scrSizeX * 0.5 + 50)
  else
    self._ui._staticText_A_ConsoleUI:SetPosX(scrSizeX * 0.5 - self._ui._staticText_A_ConsoleUI:GetTextSizeX() * 0.5 - 22)
  end
end
function PaGlobalFunc_DeadMessage_ButtonMouseOnEvent(buttonType)
  deadMessage:buttonMouseOnEvent(buttonType)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_Immediate()
  deadMessage:buttonPushedEvent_Immediate()
end
function deadMessage:buttonPushedEvent_Immediate()
  local revivalItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
  local selfProxy = getSelfPlayer()
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local isArena = regionInfo:get():isArenaArea()
  local freeRevivalLevel = FromClient_getFreeRevivalLevel()
  local isFreeArea = regionInfo:get():isFreeRevivalArea()
  if self._config._eDeadType.DeadLocate_InGuildBattle == self._currentDeadType or true == isArena or isFreeArea and freeRevivalLevel >= selfProxy:get():getLevel() then
    deadMessage_Revival(self._config._eRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  elseif self._config._eDeadType.DeadLocate_InCompetition == self._currentDeadType or true == self._isAblePvPMatchRevive then
    deadMessage_Revival(self._config._eRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), self._isAblePvPMatchRevive, toInt64(0, 0))
  elseif 1 == revivalItemCount then
    PaGlobalFunc_ResurrerectionItem_ApplyItem(self._config._eRespawnType.respawnType_Immediate)
  elseif revivalItemCount > 1 then
    PaGlobalFunc_DeadMessage_TemporaryClose()
    PaGlobalFunc_ResurrerectionItem_Open(self._config._eRespawnType.respawnType_Immediate)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_WRONG_ITEM"))
  end
  FGlobal_ImmediatelyResurrection(selfProxy:get():getMaxHp())
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_Exploration(useItem)
  deadMessage:buttonPushedEvent_Exploration(useItem)
end
function deadMessage:buttonPushedEvent_Exploration(useItem)
  local selfProxy = getSelfPlayer()
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local linkedSiegeRegionInfoWrapper = ToClient_getVillageSiegeRegionInfoWrapperByPosition(selfProxy:get():getPosition())
  local isVillageWarZone = linkedSiegeRegionInfoWrapper:get():isVillageWarZone()
  local isKingOrLordWarZone = regionInfo:get():isKingOrLordWarZone()
  local isSiegeBeing = deadMessage_isSiegeBeingInCurrentPosition()
  local prevExp = selfProxy:get():getPrevExp_s64()
  local currentExp = selfProxy:get():getExp_s64()
  local isArena = regionInfo:get():isArenaArea()
  if true == useItem and false == isArena and (true == self._isHasResotreExp or prevExp > currentExp) then
    self:respawnWithCashItem(self._config._eRespawnType.respawnType_Exploration)
    return
  end
  local contentString = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TO_EXPLORE")
  if (false == isSiegeBeing or false == isKingOrLordWarZone and false == isVillageWarZone) and (true == self._isHasResotreExp or prevExp > currentExp) then
    contentString = contentString .. "\n" .. PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN")
  end
  local function revivalExplorationConfirm()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    deadMessage_Revival(self._config._eRespawnType.respawnType_Exploration, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0), false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE"),
    content = contentString,
    functionYes = revivalExplorationConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_NearTown(useItem)
  deadMessage:buttonPushedEvent_NearTown(useItem)
end
function deadMessage:buttonPushedEvent_NearTown(useItem)
  local selfProxy = getSelfPlayer()
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local linkedSiegeRegionInfoWrapper = ToClient_getVillageSiegeRegionInfoWrapperByPosition(selfProxy:get():getPosition())
  local isVillageWarZone = linkedSiegeRegionInfoWrapper:get():isVillageWarZone()
  local isKingOrLordWarZone = regionInfo:get():isKingOrLordWarZone()
  local isSiegeBeing = deadMessage_isSiegeBeingInCurrentPosition()
  local prevExp = selfProxy:get():getPrevExp_s64()
  local currentExp = selfProxy:get():getExp_s64()
  local isArena = regionInfo:get():isArenaArea()
  if true == useItem and false == isArena and (true == self._isHasResotreExp or prevExp > currentExp) then
    self:respawnWithCashItem(self._config._eRespawnType.respawnType_NearTown)
    return
  end
  local isBadPlayer = selfProxy:get():getTendency() < 0
  local contentString = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_TO_VILLAGE")
  if false == isSiegeBeing or false == isKingOrLordWarZone and false == isVillageWarZone then
    if true == self._isHasResotreExp or prevExp > currentExp then
      contentString = contentString .. "\n" .. PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN")
    end
    if true == ToClient_IsOpendDesertPK() and true == isBadPlayer and 0 ~= regionInfo:getVillainRespawnWaypointKey() then
      contentString = contentString .. "\n" .. PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_BadPlayerMoveVillage")
    end
  end
  local function revivalVillageConfirm()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    deadMessage_Revival(self._config._eRespawnType.respawnType_NearTown, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0), false)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE"),
    content = contentString,
    functionYes = revivalVillageConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_InSiegeingFortress()
  deadMessage:buttonPushedEvent_InSiegeingFortress()
end
function deadMessage:buttonPushedEvent_InSiegeingFortress()
  local buildingRegionKey = 0
  local currentBuildInfo = ToClient_getCurrentBuildingInfo()
  if nil == currentBuildInfo then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_NOSIEGEBUILDING"))
    return
  end
  if ToClient_IsVillageSiegeBeing() then
    buildingRegionKey = currentBuildInfo:getBuildingRegionKey()
  else
    buildingRegionKey = currentBuildInfo:getAffiliatedRegionKey()
  end
  deadMessage_Revival(self._config._eRespawnType.respawnType_InSiegeingFortress, 255, 0, buildingRegionKey, false, toInt64(0, 0))
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_LocalWar()
  deadMessage:buttonPushedEvent_LocalWar()
end
function deadMessage:buttonPushedEvent_LocalWar()
  deadMessage_Revival(self._config._eRespawnType.respawnType_LocalWar, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_AdvancedBase()
  deadMessage:buttonPushedEvent_AdvancedBase()
end
function deadMessage:buttonPushedEvent_AdvancedBase()
  deadMessage_Revival(self._config._eRespawnType.respawnType_AdvancedBase, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildSpawn(useItem)
  deadMessage:buttonPushedEvent_GuildSpawn(useItem)
end
function deadMessage:buttonPushedEvent_GuildSpawn(useItem)
  local selfProxy = getSelfPlayer()
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local linkedSiegeRegionInfoWrapper = ToClient_getVillageSiegeRegionInfoWrapperByPosition(selfProxy:get():getPosition())
  local isVillageWarZone = linkedSiegeRegionInfoWrapper:get():isVillageWarZone()
  local isKingOrLordWarZone = regionInfo:get():isKingOrLordWarZone()
  local isSiegeBeing = deadMessage_isSiegeBeingInCurrentPosition()
  local prevExp = selfProxy:get():getPrevExp_s64()
  local currentExp = selfProxy:get():getExp_s64()
  local isArena = regionInfo:get():isArenaArea()
  if true == useItem and false == isArena and (true == self._isHasResotreExp or prevExp > currentExp) then
    self:respawnWithCashItem(self._config._eRespawnType.respawnType_GuildSpawn)
    return
  end
  local contentString = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_GUILDSPAWN")
  if (false == isSiegeBeing or false == isKingOrLordWarZone and false == isVillageWarZone) and (true == self._isHasResotreExp or prevExp > currentExp) then
    contentString = contentString .. "\n" .. PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_EXP_DOWN")
  end
  local function revivalGuildSpawnConfirm()
    local servantNo = 0
    local guildServantCount = guildServant_count()
    local selfPosition = getSelfPlayer():get():getPosition()
    local distance = 99999999
    for index = 0, guildServantCount do
      local servantInfo = guildStable_getServantByOrder(index)
      if nil ~= servantInfo then
        local giantActorPosition = getGiantActorPosition(servantInfo:getActorKeyRaw())
        if nil ~= giantActorPosition then
          local shipToPlayerDistance = Util.Math.calculateDistance(giantActorPosition, selfPosition)
          if distance > shipToPlayerDistance then
            distance = shipToPlayerDistance
            servantNo = servantInfo:getServantNo()
          end
        end
      end
    end
    if 0 == servantNo then
      return
    end
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    deadMessage_Revival(self._config._eRespawnType.respawnType_GuildSpawn, 255, 0, getSelfPlayer():getRegionKey(), false, servantNo)
    SetUIMode(Defines.UIMode.eUIMode_Default)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_RESPAWN_MB_TITLE"),
    content = contentString,
    functionYes = revivalGuildSpawnConfirm,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_1
  }
  MessageBox.showMessageBox(messageboxData)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_SavageDefence()
  deadMessage:buttonPushedEvent_SavageDefence()
end
function deadMessage:buttonPushedEvent_SavageDefence()
  local executeSavageDefenceOut = function()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    ToClient_SavageDefenceUnJoin()
  end
  local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_SAVAGEDEAD")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = contentString,
    functionYes = executeSavageDefenceOut,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_Volunteer()
  deadMessage:buttonPushedEvent_Volunteer()
end
function deadMessage:buttonPushedEvent_Volunteer()
  deadMessage_Revival(self._config._eRespawnType.respawnType_Volunteer, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  SetUIMode(Defines.UIMode.eUIMode_Default)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_Plunder()
  deadMessage:buttonPushedEvent_Plunder()
end
function deadMessage:buttonPushedEvent_Plunder()
  deadMessage_Revival(self._config._eRespawnType.respawnType_Plunder, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  SetUIMode(Defines.UIMode.eUIMode_Default)
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildTeamBattle()
  deadMessage:buttonPushedEvent_GuildTeamBattle()
end
function deadMessage:buttonPushedEvent_GuildTeamBattle()
  deadMessage_Revival(self._config._eRespawnType.respawnType_GuildTeamBattle, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  FGlobal_ImmediatelyResurrection(selfProxy:get():getMaxHp())
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_OutsideGate()
  deadMessage:buttonPushedEvent_OutsideGate()
end
function deadMessage:buttonPushedEvent_OutsideGate()
  deadMessage_Revival(self._config._eRespawnType.respawnType_OutsideGate, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_InsideGate()
  deadMessage:buttonPushedEvent_InsideGate()
end
function deadMessage:buttonPushedEvent_InsideGate()
  deadMessage_Revival(self._config._eRespawnType.respawnType_InsideGate, 255, 0, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_Observer()
  deadMessage:buttonPushedEvent_Observer()
end
function deadMessage:buttonPushedEvent_Observer()
  self:close()
  self._isObserverMode = true
  observerCameraModeStart()
  if false == ToClient_getJoinGuildBattle() and false == ToClient_getPlayNowSavageDefence() and false == ToClient_IsSelfInGuildTeamBattle() then
    PaGlobalFunc_ConsoleKeyGuide_SetGuide(Defines.ConsoleKeyGuideType.observeMode)
  else
    PaGlobalFunc_ConsoleKeyGuide_SetGuide(Defines.ConsoleKeyGuideType.observeMode)
  end
end
function PaGlobalFunc_DeadMessage_ButtonPushEvent_GuildObserverMode()
  deadMessage:buttonPushedEvent_GuildObserverMode()
end
function deadMessage:buttonPushedEvent_GuildObserverMode()
  self:close()
  self._isObserverMode = true
  ToClient_FirstPersonOpserverModeInSiege(true)
  self._tempButtonAbleTimeForGuildObserver = self._config._buttonAbleTime
  self._startTimeForGuildObserver = getTickCount32()
end
function deadMessage:respawnWithCashItem(respawnType)
  local revivalItemCount = ToClient_InventorySizeByProductCategory(CppEnums.ItemWhereType.eCashInventory, CppEnums.ItemProductCategory.eItemProductCategory_Revival)
  local selfProxy = getSelfPlayer()
  if nil == selfProxy then
    return
  end
  local regionInfo = getRegionInfoByPosition(selfProxy:get():getPosition())
  local isArena = regionInfo:get():isArenaArea()
  if true == isArena and respawnType == self._config._eRespawnType.respawnType_Immediate then
    deadMessage_Revival(self._config._eRespawnType.respawnType_Immediate, 0, CppEnums.ItemWhereType.eCashInventory, getSelfPlayer():getRegionKey(), false, toInt64(0, 0))
  elseif 1 == revivalItemCount then
    PaGlobalFunc_ResurrerectionItem_ApplyItem(respawnType)
  elseif revivalItemCount > 1 then
    PaGlobalFunc_DeadMessage_TemporaryClose()
    PaGlobalFunc_ResurrerectionItem_Open(respawnType)
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_GUILDCRAFT_WRONG_ITEM"))
  end
end
function deadMessage:getPaneltyStringControl()
  if self._config._paneltyStringMaxCount <= self._currentPaneltyStringCount + 1 then
    return nil
  end
  local textControl = self._ui._staticText_DropItem[self._currentPaneltyStringCount]
  self._currentPaneltyStringCount = self._currentPaneltyStringCount + 1
  textControl:SetShow(true)
  return textControl
end
function deadMessage:Event_AddDropItem(itemName, count, enchantLevel, dropType)
  local control = self:getPaneltyStringControl()
  if nil == control then
    return
  end
  local aniType = self._config._aniType
  local strDropType = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_DRIPTYPE1")
  if 1 == dropType then
    strDropType = PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_DRIPTYPE2")
  end
  if 0 ~= enchantLevel then
    control:SetText("+" .. enchantLevel .. " " .. itemName .. "[" .. count .. "]" .. " (" .. strDropType .. ")")
  else
    control:SetText(itemName .. "[" .. count .. "]" .. " (" .. strDropType .. ")")
  end
  control:SetFontColor(Defines.Color.C_FFD20000)
  control:SetShow(true)
  self:setAniToControl(control, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(control, aniType._changeColor, 3, 3.4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
end
function Event_DeadMessage_AddDropItem(itemName, count, enchantLevel, dropType)
  deadMessage:Event_AddDropItem(itemName, count, enchantLevel, dropType)
end
function deadMessage:Event_WeakEquip(slotNo)
  local control = self:getPaneltyStringControl()
  if nil == control then
    return
  end
  local aniType = self._config._aniType
  control:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "DEADMESSAGE_TEXT_DownEnchantMsg", "enchantDownSlot", CppEnums.EquipSlotNoString[slotNo]))
  control:SetFontColor(Defines.Color.C_FF96D4FC)
  control:SetShow(true)
  self:setAniToControl(control, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(control, aniType._changeColor, 3, 3.4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
end
function Event_DeadMessage_WeakEquip(slotNo)
  deadMessage:Event_WeakEquip(slotNo)
end
function deadMessage:Event_WeakEquipCantPushInventory(notify)
  local control = self:getPaneltyStringControl()
  if nil == control then
    return
  end
  local aniType = self._config._aniType
  control:SetText(notify)
  control:SetFontColor(Defines.Color.C_FF96D4FC)
  control:SetShow(true)
  self:setAniToControl(control, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(control, aniType._changeColor, 3, 3.4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
end
function Event_DeadMessage_WeakEquipCantPushInventory(notify)
  deadMessage:Event_WeakEquipCantPushInventory(notify)
end
function deadMessage:Event_DestroyJewel(destoryJewel01, destoryJewel02, destoryJewel03, destoryJewel04, destoryJewel05)
  local control = self:getPaneltyStringControl()
  if nil == control then
    return
  end
  local aniType = self._config._aniType
  local jewelKey = {
    [0] = destoryJewel01,
    [1] = destoryJewel02,
    [2] = destoryJewel03,
    [3] = destoryJewel04,
    [4] = destoryJewel05
  }
  local jewelName = ""
  for idx = 0, #jewelKey do
    if "" ~= jewelName then
      if nil ~= jewelKey[idx] and 0 ~= jewelKey[idx] then
        local itemStaticStatus = getItemEnchantStaticStatus(ItemEnchantKey(jewelKey[idx]))
        local itemName = itemStaticStatus:getName()
        jewelName = jewelName .. ", " .. itemName
      end
    elseif nil ~= jewelKey[idx] and 0 ~= jewelKey[idx] then
      jewelName = getItemEnchantStaticStatus(ItemEnchantKey(jewelKey[idx])):getName()
    end
  end
  control:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_DEADMESSAGE_JEWELDESTROYED") .. " " .. jewelName)
  control:SetFontColor(Defines.Color.C_FFD20000)
  control:SetShow(true)
  self:setAniToControl(control, aniType._changeColor, 0, 0.5, Defines.Color.C_00FFFFFF, Defines.Color.C_00FFFFFF)
  self:setAniToControl(control, aniType._changeColor, 3, 3.4, Defines.Color.C_00FFFFFF, Defines.Color.C_FFFFFFFF)
end
function Event_DeadMessage_DestroyJewel(destoryJewel01, destoryJewel02, destoryJewel03, destoryJewel04, destoryJewel05)
  deadMessage:Event_DestroyJewel(destoryJewel01, destoryJewel02, destoryJewel03, destoryJewel04, destoryJewel05)
end
function FromClient_LuaLoadComplete_DeadMessage()
  deadMessage:initialize()
end
function FromClient_DeaeMessage_Resize()
  deadMessage:setSize()
end
function deadMessage:notifySiegeShowWatchPanel(isShow)
  if true == isShow then
    ToClient_CanOpenGuildBattleCam(isShow)
    PaGlobalFunc_ConsoleKeyGuide_SetGuide(Defines.ConsoleKeyGuideType.observeMode)
  else
    local currentTime = getTickCount32()
    if nil ~= self._tempButtonAbleTimeForGuildObserver then
      self._tempButtonAbleTimeForGuildObserver = self._tempButtonAbleTimeForGuildObserver - (currentTime - self._startTimeForGuildObserver)
      self._buttonAbleTime = self._tempButtonAbleTimeForGuildObserver
      self._resurrectionTime = self._tempButtonAbleTimeForGuildObserver
      self._tempButtonAbleTimeForGuildObserver = nil
    end
    ToClient_CanOpenGuildBattleCam(isShow)
    PaGlobalFunc_ConsoleKeyGuide_PopGuide()
    Panel_DeadMessage_Renew:SetShow(true, true)
  end
end
function deadMessage_ResurrectionTimeReturn(Rtime)
  deadMessage._resurrectionTime = Rtime
  deadMessage._buttonAbleTime = Rtime
end
function FromClient_NotifySiegeShowWatchPanel(isShow)
  deadMessage:notifySiegeShowWatchPanel(isShow)
end
function deadMessage:registEventHandler()
  registerEvent("FromClient_luaLoadComplete", "FromClient_LuaLoadComplete_DeadMessage")
  registerEvent("EventSelfPlayerDead", "FromClient_ShowDeadMessage")
  registerEvent("EventSelfPlayerRevive", "FromClient_SelfPlayerRevive")
  registerEvent("Event_DeadMessage_AddDropItem", "Event_DeadMessage_AddDropItem")
  registerEvent("Event_DeadMessage_WeakEquip", "Event_DeadMessage_WeakEquip")
  registerEvent("Event_DeadMessage_WeakEquipCantPushInventory", "Event_DeadMessage_WeakEquipCantPushInventory")
  registerEvent("Event_DeadMessage_DestroyJewel", "Event_DeadMessage_DestroyJewel")
  registerEvent("FromClient_NotifySiegeShowWatchPanel", "FromClient_NotifySiegeShowWatchPanel")
  registerEvent("onScreenResize", "FromClient_DeaeMessage_Resize")
end
deadMessage:registEventHandler()
