local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Command:SetShow(false, false)
local CommandBg = UI.getChildControl(Panel_Command, "Static_CommandBg")
local CommandText = {
  UI.getChildControl(CommandBg, "StaticText_Command_0"),
  UI.getChildControl(CommandBg, "StaticText_Command_1"),
  UI.getChildControl(CommandBg, "StaticText_Command_2"),
  UI.getChildControl(CommandBg, "StaticText_Command_3"),
  UI.getChildControl(CommandBg, "StaticText_Command_4"),
  UI.getChildControl(CommandBg, "StaticText_Command_5"),
  UI.getChildControl(CommandBg, "StaticText_Command_6"),
  UI.getChildControl(CommandBg, "StaticText_Command_7"),
  UI.getChildControl(CommandBg, "StaticText_Command_8"),
  UI.getChildControl(CommandBg, "StaticText_Command_9")
}
local checkIcon = UI.getChildControl(CommandBg, "Static_Check_Icon")
local checkIconList = {}
local gameOptionActionKey = {
  Forward = 0,
  Back = 1,
  Left = 2,
  Right = 3,
  Attack = 4,
  SubAttack = 5,
  Dash = 6,
  Jump = 7
}
local CommandTextureUV = {
  [0] = {
    96,
    417,
    139,
    460
  },
  [1] = {
    140,
    417,
    183,
    460
  },
  [2] = {
    96,
    461,
    139,
    504
  },
  [3] = {
    140,
    461,
    183,
    504
  }
}
local _commandEffectBG = UI.getChildControl(CommandBg, "Static_CommandEffect")
local _sinGauge_Result_Perfect = UI.getChildControl(Panel_Command, "Static_Result_Perfect")
local _sinGauge_Result_Bad = UI.getChildControl(Panel_Command, "Static_Result_Bad")
local _Command_CurrentKey_Eff0 = UI.getChildControl(CommandBg, "Static_Eff_Currect_Eff0")
local _CommandTimeBG = UI.getChildControl(CommandBg, "Static_TimerGaugeBG")
local _CommandTimerBar = UI.getChildControl(_CommandTimeBG, "Static_TimerGauge")
local _Result_Success = UI.getChildControl(Panel_Command, "Static_Result_Success")
local _Result_Failed = UI.getChildControl(Panel_Command, "Static_Result_Failed")
local _fishGrade = UI.getChildControl(CommandBg, "StaticText_FishGrade")
_fishGrade:SetShow(false)
local panelSizeX = Panel_Command:GetSizeX()
local panelSizeY = Panel_Command:GetSizeY()
local isCommandFinished = true
local fishCommandCount = {
  [0] = {min = 2, max = 3},
  {min = 4, max = 5},
  {min = 5, max = 6},
  {min = 7, max = 9},
  {min = 10, max = 10}
}
local function CommandTextureChange(contorl, index)
  contorl:ChangeTextureInfoName("renewal/etc/minigame/console_etc_minigame_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(contorl, CommandTextureUV[index][1], CommandTextureUV[index][2], CommandTextureUV[index][3], CommandTextureUV[index][4])
  contorl:getBaseTexture():setUV(x1, y1, x2, y2)
  contorl:setRenderTexture(contorl:getBaseTexture())
end
local fishCount = -1
local FishGrade = -1
local function getFishCountCalc()
  FishGrade = getSelfPlayer():get():getFishGrade()
  local discountCommand = 0
  local fishLevel = getSelfPlayer():get():getLifeExperienceLevel(1)
  if fishLevel > 30 then
    local dice100 = math.random(0, 100)
    if fishLevel < 41 and dice100 < 10 then
      discountCommand = 1
    elseif fishLevel > 40 and fishLevel < 51 and dice100 < 15 then
      discountCommand = 2
    elseif fishLevel > 50 and fishLevel < 81 and dice100 < 20 then
      discountCommand = 3
    elseif fishLevel > 80 and dice100 < 25 then
      discountCommand = 4
    end
  end
  if FishGrade < 5 then
    local currCount = fishCommandCount[FishGrade]
    local minCount = currCount.min - discountCommand
    local maxCount = currCount.max - discountCommand
    minCount = math.max(2, minCount)
    maxCount = math.max(2, maxCount)
    fishCount = math.random(minCount, maxCount)
  else
    UI.ASSERT(false, "\234\183\184\235\160\136\236\157\180\235\147\156\234\176\128 \236\158\152\235\170\187 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164. \235\163\168\236\149\132\236\151\144\235\143\132 \235\172\188\234\179\160\234\184\176 \234\183\184\235\160\136\236\157\180\235\147\156\235\165\188 \235\176\148\234\191\148\236\163\188\236\132\184\236\154\148.")
  end
end
function Command_RePosition()
  local pullRandomPos = function()
    local randomPos = math.random(0, 12)
    local randomPosMinus = math.random(0, 1)
    local setRandomPos
    if 0 == randomPosMinus then
      setRandomPos = randomPos
    else
      setRandomPos = randomPos * -1
    end
    return setRandomPos
  end
  screenX = getOriginScreenSizeX()
  screenY = getOriginScreenSizeY()
  Panel_Command:SetPosX(screenX / 2 - Panel_Command:GetSizeX() / 2)
  Panel_Command:SetPosY(screenY / 2 - 250)
end
local _math_random = math.random
local _math_randomSeed = math.randomseed
local commands = {}
local currentCommandIndex = 1
local passedTimePerNext = 0
local function Command_CreateRandomText()
  commands = {}
  local cmd, cmdText, textControl
  for index = 1, fishCount do
    cmd = _math_random(0, 3)
    textControl = CommandText[index]
    if 0 == cmd then
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Forward)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Forward)
      end
      CommandTextureChange(textControl, 0)
    elseif 1 == cmd then
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Back)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Back)
      end
      CommandTextureChange(textControl, 1)
    elseif 2 == cmd then
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Left)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Left)
      end
      CommandTextureChange(textControl, 2)
    else
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Right)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Right)
      end
      CommandTextureChange(textControl, 3)
      cmd = 3
    end
    textControl:SetPosX(index * 50 - 100)
    textControl:SetPosY(80)
    textControl:SetShow(true)
    commands[index] = cmd
  end
end
function Panel_Minigame_Command_Start()
  Panel_Command:SetShow(true, false)
  CommandBg:SetShow(true)
  ToClient_setAvailableInputWidget(false)
  PaGlobal_ConsoleQuickMenu:widgetClose()
  _CommandTimeBG:SetShow(true)
  for ii = 1, 10 do
    if nil ~= checkIconList[ii] then
      checkIconList[ii]:SetShow(false)
    end
    if nil ~= CommandText[ii] then
      CommandText[ii]:SetShow(false)
      CommandText[ii]:SetColor(UIColor.C_FFFFFFFF)
    end
  end
  FGlobal_MiniGame_FishingCheck()
  getFishCountCalc()
  isCommandFinished = false
  _fishGrade:SetShow(true)
  if fishCount > 0 and fishCount <= 2 then
    _fishGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FishGrade1"))
  elseif fishCount >= 3 and fishCount <= 4 then
    _fishGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FishGrade2"))
  elseif fishCount >= 5 and fishCount <= 7 then
    _fishGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FishGrade3"))
  elseif fishCount >= 8 and fishCount <= 9 then
    _fishGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FishGrade4"))
  elseif fishCount == 10 then
    _fishGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_FishGrade5"))
  end
  _Result_Failed:ResetVertexAni()
  _Result_Failed:SetShow(false)
  _Result_Failed:SetAlpha(0)
  _Result_Success:ResetVertexAni()
  _Result_Success:SetShow(false)
  _Result_Success:SetAlpha(0)
  _Command_CurrentKey_Eff0:ResetVertexAni()
  _Command_CurrentKey_Eff0:SetShow(false)
  _Command_CurrentKey_Eff0:SetAlpha(0)
  _math_randomSeed(getTickCount32())
  Command_CreateRandomText()
  currentCommandIndex = 1
  Panel_Command:RegisterUpdateFunc("Command_UpdateText")
  passedTimePerNext = 0
  _sinGauge_Result_Bad:SetShow(false)
  _sinGauge_Result_Perfect:SetShow(false)
  local colorNo = math.random(0, 108)
  local randomAlpha = string.format("%.2f", math.random(75, 100) / 100)
end
function Panel_Minigame_Command_End()
  _commandEffectBG:EraseAllEffect()
  Panel_Command:SetShow(false, false)
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  isCommandFinished = true
end
local function MiniGame_Command_OnSuccess()
  _AudioPostEvent_SystemUiForXBOX(11, 13)
  for ii = 1, 10 do
    checkIconList[ii]:SetShow(false)
  end
  CommandBg:SetShow(false)
  _CommandTimeBG:SetShow(false)
  getSelfPlayer():get():SetMiniGameResult(2)
  isCommandFinished = true
  _sinGauge_Result_Perfect:ResetVertexAni()
  _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_Ani", true)
  _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_ScaleAni", true)
  _sinGauge_Result_Perfect:SetVertexAniRun("Perfect_AniEnd", true)
  _Result_Failed:ResetVertexAni()
  _Result_Failed:SetShow(false)
  _Result_Success:ResetVertexAni()
  _Result_Success:SetShow(true)
  _Result_Success:SetVertexAniRun("Ani_Scale_Result_Success_empty", true)
  _Result_Success:SetVertexAniRun("Ani_Scale_Result_Success", true)
  _Result_Success:SetVertexAniRun("Ani_Color_Result_Success_empty", true)
  _Result_Success:SetVertexAniRun("Ani_Color_Result_Success", true)
end
local function MiniGame_Command_OnFailed()
  _AudioPostEvent_SystemUiForXBOX(11, 7)
  local textControl = CommandText[currentCommandIndex]
  getSelfPlayer():get():SetMiniGameResult(0)
  isCommandFinished = true
  textControl:SetColor(UIColor.C_FFFF0000)
  textControl:SetFontColor(UIColor.C_FFFF0000)
  for ii = 1, 10 do
    checkIconList[ii]:SetShow(false)
  end
  CommandBg:SetShow(false)
  _sinGauge_Result_Bad:ResetVertexAni()
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_Ani", true)
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_ScaleAni", true)
  _sinGauge_Result_Bad:SetVertexAniRun("Bad_AniEnd", true)
  _Result_Success:ResetVertexAni()
  _Result_Success:SetShow(false)
  _Result_Failed:ResetVertexAni()
  _Result_Failed:SetShow(true)
  _Result_Failed:SetVertexAniRun("Ani_Scale_Result_Failed_empty", true)
  _Result_Failed:SetVertexAniRun("Ani_Scale_Result_Failed", true)
  _Result_Failed:SetVertexAniRun("Ani_Color_Result_Failed_empty", true)
  _Result_Failed:SetVertexAniRun("Ani_Color_Result_Failed", true)
end
function MiniGame_Command_keyPress(keyType)
  if isCommandFinished then
    return
  end
  local textControl = CommandText[currentCommandIndex]
  if keyType < MGKT.MiniGameKeyType_W or keyType > MGKT.MiniGameKeyType_D then
    return
  end
  if commands[currentCommandIndex] == keyType then
    _AudioPostEvent_SystemUiForXBOX(11, 0)
    currentCommandIndex = currentCommandIndex + 1
    _Command_CurrentKey_Eff0:SetShow(true)
    _Command_CurrentKey_Eff0:EraseAllEffect()
    _Command_CurrentKey_Eff0:AddEffect("UI_LevelUP_Skill", false, 0, -8)
    _Command_CurrentKey_Eff0:AddEffect("fUI_LevelUP_Skill02", false, 0, -8)
    _Command_CurrentKey_Eff0:SetPosX(textControl:GetPosX() + textControl:GetSizeX() / 2 - (_Command_CurrentKey_Eff0:GetSizeX() / 2 + 1))
    _Command_CurrentKey_Eff0:SetPosY(textControl:GetPosY() + textControl:GetSizeY() / 2 - (_Command_CurrentKey_Eff0:GetSizeY() / 2 - 7))
    checkIconList[currentCommandIndex]:SetPosX(textControl:GetPosX() + textControl:GetSizeX() / 2 - checkIconList[currentCommandIndex]:GetSizeX() / 2)
    checkIconList[currentCommandIndex]:SetPosY(textControl:GetPosY() + (textControl:GetSizeY() + 30) - checkIconList[currentCommandIndex]:GetSizeY() / 2)
    checkIconList[currentCommandIndex]:SetShow(true)
    if fishCount < currentCommandIndex then
      MiniGame_Command_OnSuccess()
    end
  else
    MiniGame_Command_OnFailed()
  end
end
function Command_UpdateText(deltaTime)
  passedTimePerNext = passedTimePerNext + deltaTime
  local rate = passedTimePerNext / 4.5
  local gaugeWidth = _CommandTimerBar:GetSizeX()
  if rate > 1 then
    rate = 1
  else
    local x = (1 - rate) * 570
    _CommandTimerBar:SetSize(x, _CommandTimerBar:GetSizeY())
  end
  if isCommandFinished then
    return
  end
  if rate >= 1 then
    MiniGame_Command_OnFailed()
    _CommandTimeBG:SetShow(false)
  end
end
local gameOptionActionKey = {
  Forward = 0,
  Back = 1,
  Left = 2,
  Right = 3,
  Attack = 4,
  SubAttack = 5,
  Dash = 6,
  Jump = 7
}
function MiniGame_Command_PadKeyPress(keyType)
  local changeKeyType = 0
  if __eQuickTimeEventPadType_Up == keyType or __eQuickTimeEventPadType_DpadUp == keyType then
    changeKeyType = gameOptionActionKey.Forward
  elseif __eQuickTimeEventPadType_Down == keyType or __eQuickTimeEventPadType_DpadDown == keyType then
    changeKeyType = gameOptionActionKey.Back
  elseif __eQuickTimeEventPadType_Left == keyType or __eQuickTimeEventPadType_DpadLeft == keyType then
    changeKeyType = gameOptionActionKey.Left
  elseif __eQuickTimeEventPadType_Right == keyType or __eQuickTimeEventPadType_DpadRight == keyType then
    changeKeyType = gameOptionActionKey.Right
  end
  MiniGame_Command_keyPress(changeKeyType)
end
function FromClient_luaLoadComplete_MiniGame_Command_Renew()
  for ii = 1, 10 do
    checkIconList[ii] = UI.createAndCopyBasePropertyControl(CommandBg, "Static_Check_Icon", CommandBg, "Static_CheckIcon" .. ii)
  end
end
registerEvent("onScreenResize", "Command_RePosition")
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_Command_keyPress")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_Command_PadKeyPress")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Command_Renew")
Command_RePosition()
