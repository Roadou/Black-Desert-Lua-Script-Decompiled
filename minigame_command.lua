local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
Panel_Command:SetShow(false, false)
local CommandText = {
  UI.getChildControl(Panel_Command, "StaticText_Command_0"),
  UI.getChildControl(Panel_Command, "StaticText_Command_1"),
  UI.getChildControl(Panel_Command, "StaticText_Command_2"),
  UI.getChildControl(Panel_Command, "StaticText_Command_3"),
  UI.getChildControl(Panel_Command, "StaticText_Command_4"),
  UI.getChildControl(Panel_Command, "StaticText_Command_5"),
  UI.getChildControl(Panel_Command, "StaticText_Command_6"),
  UI.getChildControl(Panel_Command, "StaticText_Command_7"),
  UI.getChildControl(Panel_Command, "StaticText_Command_8"),
  UI.getChildControl(Panel_Command, "StaticText_Command_9")
}
local CommandColor = {
  [0] = UIColor.C_FFFF0000,
  UIColor.C_FFD20000,
  UIColor.C_FFF26A6A,
  UIColor.C_FF775555,
  UIColor.C_FFFFD46D,
  UIColor.C_FFFFF3AF,
  UIColor.C_FFEDE699,
  UIColor.C_FFEF9C7F,
  UIColor.C_FFEE7001,
  UIColor.C_FFFF4729,
  UIColor.C_FFFFFFFF,
  UIColor.C_FF858585,
  UIColor.C_FFDFDFDF,
  UIColor.C_FFB5FF6D,
  UIColor.C_FFC8FFC8,
  UIColor.C_FF6DC6FF,
  UIColor.C_FF96D4FC,
  UIColor.C_FF00C0D7,
  UIColor.C_FFC4BEBE,
  UIColor.C_FFFFAB6D,
  UIColor.C_FFB75EDD,
  UIColor.C_FFFFCE22,
  UIColor.C_FFFFEEA0,
  UIColor.C_FFFAE696,
  UIColor.C_FFF0EF9D,
  UIColor.C_FFD8CABA,
  UIColor.C_FFEEBA3E,
  UIColor.C_FFC1FFC2,
  UIColor.C_FFBBFF84,
  UIColor.C_FF8484FF,
  UIColor.C_FFFF8484,
  UIColor.C_FFFFFB84,
  UIColor.C_FFFF973A,
  UIColor.C_FF84D2FF,
  UIColor.C_FF008AFF,
  UIColor.C_FF0054FF,
  UIColor.C_FF67FFA4,
  UIColor.C_FFFF7C67,
  UIColor.C_FF76CAFF,
  UIColor.C_FFFF5F5F,
  UIColor.C_FFFF3BF8,
  UIColor.C_FFFFBC3A,
  UIColor.C_FFB10000,
  UIColor.C_FF7F7F7F,
  UIColor.C_FF2478FF,
  UIColor.C_FFEFEFEF,
  UIColor.C_FFF03838,
  UIColor.C_FFEF5378,
  UIColor.C_FFFF8957,
  UIColor.C_FF3BD3FF,
  UIColor.C_FFC4A68A,
  UIColor.C_FF748CAB,
  UIColor.C_FFA8FC00,
  UIColor.C_FFFBFF8A,
  UIColor.C_FFFF8A8A,
  UIColor.C_FFFF3636,
  UIColor.C_FF7800D5,
  UIColor.C_FFFFAE00,
  UIColor.C_FFD98F00,
  UIColor.C_FFD96100,
  UIColor.C_FFCE3A00,
  UIColor.C_FFC00000,
  UIColor.C_FFF4D35D,
  UIColor.C_FF5578B4,
  UIColor.C_FF00C2EA,
  UIColor.C_FF844BE3,
  UIColor.C_FFE37F4B,
  UIColor.C_FFDA0000,
  UIColor.C_FFBCF44B,
  UIColor.C_FF4BF4B5,
  UIColor.C_FFFF4C4C,
  UIColor.C_FFFF874C,
  UIColor.C_FFAEFF9B,
  UIColor.C_FF9B9BFF,
  UIColor.C_FF8737FF,
  UIColor.C_FFE7E7E7,
  UIColor.C_FFD2B4FF,
  UIColor.C_FFFF9BFE,
  UIColor.C_FF6B6B6B,
  UIColor.C_FF999999,
  UIColor.C_FFFFEF82,
  UIColor.C_FFFF4B4B,
  UIColor.C_FF84FFF5,
  UIColor.C_FFAAAAAA,
  UIColor.C_FF926CFF,
  UIColor.C_FFF601FF,
  UIColor.C_FF8EBD00,
  UIColor.C_FFFFCF4C,
  UIColor.C_FF804040,
  UIColor.C_FF40D7FD,
  UIColor.C_FFDCD489,
  UIColor.C_FFFFDD81,
  UIColor.C_FFFFCE57,
  UIColor.C_FFF4A72D,
  UIColor.C_FFE26A13,
  UIColor.C_FFE03A0D,
  UIColor.C_FFF68383,
  UIColor.C_FFECADAD,
  UIColor.C_FFE5C6C6,
  UIColor.C_FFCECECE,
  UIColor.C_ffff8181,
  UIColor.C_ffdeff6d,
  UIColor.C_FF387f14,
  UIColor.C_FFf570a1,
  UIColor.C_FF25c28b,
  UIColor.C_FF3E5CFF,
  UIColor.C_FFBE4A00,
  UIColor.C_FF00A1FF,
  UIColor.C_FFA3EF00
}
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
local _commandEffectBG = UI.getChildControl(Panel_Command, "Static_CommandEffect")
local _sinGauge_Result_Perfect = UI.getChildControl(Panel_Command, "Static_Result_Perfect")
local _sinGauge_Result_Bad = UI.getChildControl(Panel_Command, "Static_Result_Bad")
local _Command_CurrentKey_Eff0 = UI.getChildControl(Panel_Command, "Static_Eff_Currect_Eff0")
local _CommandTimeBG = UI.getChildControl(Panel_Command, "Static_TimerGaugeBG")
local _CommandTimerBar = UI.getChildControl(Panel_Command, "Progress2_Timer")
local _Result_Success = UI.getChildControl(Panel_Command, "Static_Result_Success")
local _Result_Failed = UI.getChildControl(Panel_Command, "Static_Result_Failed")
local _fishGrade = UI.getChildControl(Panel_Command, "StaticText_FishGrade")
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
  screenX = getScreenSizeX()
  Panel_Command:SetPosX(screenX / 2 - Panel_Command:GetSizeX() / 2 + pullRandomPos())
  Panel_Command:SetPosY(350 + pullRandomPos())
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
      textControl:ChangeTextureInfoName("New_UI_Common_forLua/widget/instance/MiniGame_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(textControl, 400, 1, 426, 27)
      textControl:getBaseTexture():setUV(x1, y1, x2, y2)
      textControl:setRenderTexture(textControl:getBaseTexture())
    elseif 1 == cmd then
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Back)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Back)
      end
      textControl:ChangeTextureInfoName("New_UI_Common_forLua/widget/instance/MiniGame_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(textControl, 400, 28, 426, 54)
      textControl:getBaseTexture():setUV(x1, y1, x2, y2)
      textControl:setRenderTexture(textControl:getBaseTexture())
    elseif 2 == cmd then
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Left)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Left)
      end
      textControl:ChangeTextureInfoName("New_UI_Common_forLua/widget/instance/MiniGame_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(textControl, 373, 1, 399, 27)
      textControl:getBaseTexture():setUV(x1, y1, x2, y2)
      textControl:setRenderTexture(textControl:getBaseTexture())
    else
      if getGamePadEnable() then
        cmdText = keyCustom_GetString_ActionPad(gameOptionActionKey.Right)
      else
        cmdText = keyCustom_GetString_ActionKey(gameOptionActionKey.Right)
      end
      textControl:ChangeTextureInfoName("New_UI_Common_forLua/widget/instance/MiniGame_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(textControl, 373, 28, 399, 54)
      textControl:getBaseTexture():setUV(x1, y1, x2, y2)
      textControl:setRenderTexture(textControl:getBaseTexture())
      cmd = 3
    end
    textControl:SetText(cmdText)
    textControl:SetColor(UIColor.C_FFEFEFEF)
    textControl:SetFontColor(UIColor.C_FFEFEFEF)
    textControl:SetPosX(index * 35 - 17)
    textControl:SetPosY(31)
    textControl:SetShow(true)
    commands[index] = cmd
  end
end
function Panel_Minigame_Command_Start()
  Panel_Command:SetShow(true, false)
  Command_RePosition()
  FGlobal_MiniGame_FishingCheck()
  getFishCountCalc()
  isCommandFinished = false
  _commandEffectBG:AddEffect("UI_Fishing_Aura02", false, 0, 0)
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
  _math_randomSeed(os.time())
  Command_CreateRandomText()
  currentCommandIndex = 1
  Panel_Command:RegisterUpdateFunc("Panel_Minigame_UpdateFunc")
  passedTimePerNext = 0
  _sinGauge_Result_Bad:SetShow(false)
  _sinGauge_Result_Perfect:SetShow(false)
  local colorNo = math.random(0, 108)
  local randomAlpha = string.format("%.2f", math.random(75, 100) / 100)
  for index = 1, 10 do
    local color = CommandColor[colorNo]
    CommandText[index]:SetShow(index <= fishCount)
    CommandText[index]:SetFontColor(color)
    CommandText[index]:SetColor(color)
    CommandText[index]:SetFontAlpha(randomAlpha)
  end
end
function Panel_Minigame_Command_End()
  _commandEffectBG:EraseAllEffect()
  Panel_Command:SetShow(false, false)
  isCommandFinished = true
end
local function MiniGame_Command_OnSuccess()
  audioPostEvent_SystemUi(11, 13)
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
  Panel_Minigame_Command_End()
end
local function MiniGame_Command_OnFailed()
  audioPostEvent_SystemUi(11, 7)
  local textControl = CommandText[currentCommandIndex]
  getSelfPlayer():get():SetMiniGameResult(0)
  isCommandFinished = true
  textControl:SetColor(UIColor.C_FFFF0000)
  textControl:SetFontColor(UIColor.C_FFFF0000)
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
function MiniGame_Command_ddukdition(keyType)
  if isCommandFinished then
    return
  end
  local textControl = CommandText[currentCommandIndex]
  if keyType < MGKT.MiniGameKeyType_W or keyType > MGKT.MiniGameKeyType_D then
    return
  end
  if commands[currentCommandIndex] == keyType then
    audioPostEvent_SystemUi(11, 0)
    textControl:SetColor(UIColor.C_FF88DF00)
    textControl:SetFontColor(UIColor.C_FF88DF00)
    currentCommandIndex = currentCommandIndex + 1
    _Command_CurrentKey_Eff0:SetShow(true)
    _Command_CurrentKey_Eff0:EraseAllEffect()
    _Command_CurrentKey_Eff0:AddEffect("UI_LevelUP_Skill", false, 0, -8)
    _Command_CurrentKey_Eff0:AddEffect("fUI_LevelUP_Skill02", false, 0, -8)
    _Command_CurrentKey_Eff0:SetPosX(textControl:GetPosX() - 23)
    _Command_CurrentKey_Eff0:SetPosY(textControl:GetPosY() / 2 - 12)
    if fishCount < currentCommandIndex then
      MiniGame_Command_OnSuccess()
    end
  else
    MiniGame_Command_OnFailed()
  end
end
function Command_UpdateText(deltaTime)
  passedTimePerNext = passedTimePerNext + deltaTime
  local rate = passedTimePerNext / 6
  if rate > 1 then
    rate = 1
  end
  local progressValue = (1 - rate) * 100
  _CommandTimerBar:SetProgressRate(progressValue)
  if isCommandFinished then
    return
  end
  if rate >= 1 then
    MiniGame_Command_OnFailed()
  end
end
registerEvent("onScreenResize", "Command_RePosition")
Command_RePosition()
