IsChecked_WeaponOut = false
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local _panel = Panel_Global_Manual
local _ui = {
  txt_Purpose = UI.getChildControl(_panel, "StaticText_Purpose"),
  txt_Command_Info = UI.getChildControl(_panel, "Static_Command_Info"),
  stc_PC_Control_BG = UI.getChildControl(_panel, "Static_PC_Control_BG"),
  stc_Taming_Info = UI.getChildControl(_panel, "Static_Taming_Info"),
  _bulletCount = UI.getChildControl(_panel, "StaticText_BulletCount")
}
local ui_Value = {
  isFirstTime_Manual_Timing_0 = true,
  isFirstTime_Manual_Timing_1 = true,
  isFirstTime_Manual_Timing_2 = true,
  isFirstTime_Manual_Cart_0 = true,
  isFirstTime_Manual_Horse_Rope_0 = true,
  isFirstTime_Manual_HorseDrop_0 = true,
  isFirstTime_Manual_Flute_0 = true,
  isFirstTime_Manual_Flute_1 = true,
  isFirstTime_Manual_HerbMachine_0 = true,
  isFirstTime_Manual_HerbMachine_1 = true,
  isFirstTime_Manual_HerbMachine_2 = true,
  isFirstTime_Manual_HerbMachine_3 = true,
  isFirstTime_Manual_HerbMachine_4 = true,
  isFirstTime_Manual_HerbMachine_5 = true,
  isFirstTime_Manual_Milky_0 = true,
  isFirstTime_Manual_Milky_1 = true,
  isFirstTime_Manual_Milky_2 = true,
  isFirstTime_Manual_Milky_3 = true,
  isFirstTime_Manual_Drum_0 = true,
  isFirstTime_Manual_Drum_1 = true,
  isFirstTime_Manual_Bullet_0 = true,
  isFirstTime_Manual_Bullet_1 = true,
  isFirstTime_Manual_Bullet_2 = true
}
MiniGame_Manual_Value_FishingStart = false
GlobalValue_MiniGame_Value_HorseDrop = false
local IsHideMiniGameManual = function()
  local uiMode = GetUIMode()
  return getCustomizingManager():isShow() or uiMode == Defines.UIMode.eUIMode_NpcDialog or uiMode == Defines.UIMode.eUIMode_InGameCashShop or uiMode == Defines.UIMode.eUIMode_Mental or uiMode == Defines.UIMode.eUIMode_DyeNew
end
local isCartRace = false
local isBulletShow = false
local function ControlResetPosition()
  for _, v in pairs(_ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  _ui.txt_Purpose:SetSize(680, 58)
end
local function Global_Manual_Initialize()
  _ui._bulletConditon = UI.getChildControl(_ui._bulletCount, "StaticText_BulletCondition")
  _ui.stc_SpaceBar = UI.getChildControl(_ui.stc_PC_Control_BG, "StaticText_Btn_Space")
  _ui.txt_HorseInfo = UI.getChildControl(_ui.stc_Taming_Info, "StaticText_Horse_Info")
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  _panel:SetSize(scrX, scrY)
  _panel:SetPosX(0)
  ControlResetPosition()
end
function Panel_GlobalManual_ScreenResize()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  _panel:SetSize(scrX, scrY)
  _panel:SetPosY(0)
  for _, v in pairs(_ui) do
    v:SetShow(false)
    v:ComputePos()
  end
end
local function MiniGame_Manual_Timing_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_0 == true then
    for _, v in pairs(_ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_ConsoleKeyGuide:SetShow(false)
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    _ui.txt_Purpose:SetSize(680, 98)
    _ui.txt_Purpose:SetTextMode(UI_TM.eTextMode_AutoWrap)
    _ui.txt_Purpose:SetShow(true)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TIMING_0"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_0"))
    end
    ui_Value.isFirstTime_Manual_Timing_0 = false
  end
end
local function MiniGame_Manual_Timing_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_1 == true then
    for _, v in pairs(_ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_ConsoleKeyGuide:SetShow(false)
    _ui.txt_Purpose:SetShow(false)
    _ui.stc_Taming_Info:SetShow(true)
    _ui.txt_HorseInfo:SetShow(true)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Command_Info:SetShow(false)
      _panel:SetShow(true)
      _ui.txt_HorseInfo:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      _ui.txt_HorseInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TIMING_1"))
    else
      _ui.txt_HorseInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_1"))
    end
    ui_Value.isFirstTime_Manual_Timing_1 = false
  end
end
local function MiniGame_Manual_Timing_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_2 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    _ui.stc_Taming_Info:SetShow(true)
    _ui.txt_HorseInfo:SetShow(true)
    _ui.txt_HorseInfo:SetTextMode(UI_TM.eTextMode_AutoWrap)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Command_Info:SetShow(false)
      _ui.txt_HorseInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TIMING_2"))
    else
      _ui.txt_HorseInfo:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_2"))
    end
    ui_Value.isFirstTime_Manual_Timing_2 = false
  end
end
local function MiniGame_Manual_Timing_3(actorKeyRaw, isSelf)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Command_Info:SetShow(true)
    _ui.txt_Command_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_PRESS_B"))
    _ui.stc_Taming_Info:SetShow(false)
  else
  end
end
local function MiniGame_Manual_Horse_Rope_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Horse_Rope_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    _ui.stc_Taming_Info:SetShow(false)
    _ui.txt_Purpose:SetShow(true)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HORSEROPE_0"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HORSEROPE_0"))
    end
    PaGlobalFunc_ConsoleKeyGuide_On()
    ui_Value.isFirstTime_Manual_Horse_Rope_0 = false
  end
end
local function MiniGame_Manual_Cart_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Cart_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    _ui.txt_Purpose:SetSize(680, 120)
    if _ContentsGroup_isConsolePadControl then
      Panel_ConsoleKeyGuide:SetShow(false)
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_CART_TITLE"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_CART_TITLE"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Cart_0 = false
  end
end
local function MiniGame_Manual_Cart_Race(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Cart_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_CART_TITLE"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_CART_TITLE"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Cart_0 = false
    isCartRace = true
  end
end
function FGlobal_isPlaying_CartRace()
  return isCartRace
end
local function MiniGame_Manual_HorseDrop_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HorseDrop_0 == true then
    ui_Value.isFirstTime_Manual_HorseDrop_0 = false
    GlobalValue_MiniGame_Value_HorseDrop = true
  end
end
local function MiniGame_Manual_Flute_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Flute_0 == true and not IsHideMiniGameManual() then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_RHYTHM_0"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_0"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Flute_0 = false
  end
end
local function MiniGame_Manual_Flute_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Flute_1 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_RHYTHM_1"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1"))
    end
    _ui.txt_Purpose:SetShow(false)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Flute_0 = true
    ui_Value.isFirstTime_Manual_Flute_1 = false
  end
end
local function MiniGame_Manual_Drum_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Drum_0 == true and not IsHideMiniGameManual() then
    ControlResetPosition()
    Panel_ConsoleKeyGuide:SetShow(false)
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DRUM_0"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DRUM_0"))
    end
    Panel_ConsoleKeyGuide:SetShow(false)
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Drum_0 = false
    ui_Value.isFirstTime_Manual_Drum_1 = true
  end
end
local function MiniGame_Manual_Drum_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Drum_1 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DRUM_1"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1"))
    end
    _ui.txt_Purpose:SetShow(false)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Drum_0 = true
    ui_Value.isFirstTime_Manual_Drum_1 = false
  end
end
local function MiniGame_Manual_Instrument_0(actorKeyRaw, isSelf)
  if _panel:GetShow() then
    return
  end
  if not IsHideMiniGameManual() then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_RHYTHM_2"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_2"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
  end
end
local function HerbMachine_ControlSelect()
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Command_Info:SetShow(true)
    _ui.txt_Command_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_PRESS_B"))
  else
    _ui.stc_PC_Control_BG:SetShow(true)
    _ui.stc_SpaceBar:SetShow(true)
  end
end
local function MiniGame_Manual_HerbMachine_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(0/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(0/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_0 = false
  end
end
local function MiniGame_Manual_HerbMachine_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_1 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(1/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(1/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_HerbMachine_1 = false
  end
end
local function MiniGame_Manual_HerbMachine_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_2 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(2/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(2/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_HerbMachine_2 = true
  end
end
local function MiniGame_Manual_HerbMachine_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_3 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(3/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(3/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_HerbMachine_3 = true
  end
end
local function MiniGame_Manual_HerbMachine_4(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_4 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(4/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(4/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_HerbMachine_4 = true
  end
end
local function MiniGame_Manual_HerbMachine_5(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_5 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(5/5)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(5/5)")
    end
    HerbMachine_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_HerbMachine_5 = true
  end
end
local MiniGame_Manual_HerbMachine = function()
  Panel_Minigame_HerbMachine_ResetCount()
end
local function Buoy_ControlSelect()
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Command_Info:SetShow(true)
    _ui.txt_Command_Info:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_PRESS_B"))
  else
    _ui.stc_PC_Control_BG:SetShow(true)
    _ui.stc_SpaceBar:SetShow(true)
  end
end
local function MiniGame_Manual_Buoy_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    Buoy_ControlSelect()
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_BUOY_0") .. " " .. "(0/3)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(0/3)")
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Buoy_0 = false
  end
end
local function MiniGame_Manual_Buoy_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_1 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Command_Info:SetShow(true)
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_BUOY_0") .. " " .. "(1/3)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(1/3)")
    end
    Buoy_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Buoy_1 = false
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local function MiniGame_Manual_Buoy_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_2 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Command_Info:SetShow(true)
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_BUOY_0") .. " " .. "(2/3)")
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(2/3)")
    end
    Buoy_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Buoy_2 = false
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local function MiniGame_Manual_Buoy_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_3 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_BUOY_1"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_1"))
    end
    Buoy_ControlSelect()
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Buoy_3 = true
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local MiniGame_Manual_Reset_Buoy = function()
  Panel_Minigame_Buoy_ResetCount()
end
local function MiniGame_Manual_Milky_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_0 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_MILKCOW_READY1"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY1"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Milky_0 = false
  end
end
local function MiniGame_Manual_Milky_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_1 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_MILKCOW_READY2"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY2"))
    end
    _ui.txt_Purpose:SetShow(false)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Milky_0 = true
    ui_Value.isFirstTime_Manual_Milky_1 = false
  end
end
local function MiniGame_Manual_Milky_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_2 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_MILKCOW_FAIL"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_FAIL"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Milky_0 = true
    ui_Value.isFirstTime_Manual_Milky_1 = false
    ui_Value.isFirstTime_Manual_Milky_2 = false
  end
end
local function MiniGame_Manual_Milky_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_3 == true then
    ControlResetPosition()
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if _ContentsGroup_isConsolePadControl then
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_MINIGAME_MILKCOW_SUCCESS"))
    else
      _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_SUCCESS"))
    end
    _ui.txt_Purpose:SetShow(true)
    _ui.txt_Purpose:AddEffect("UI_QustComplete01", false, 0, 0)
    ui_Value.isFirstTime_Manual_Milky_0 = true
    ui_Value.isFirstTime_Manual_Milky_1 = false
    ui_Value.isFirstTime_Manual_Milky_2 = false
    ui_Value.isFirstTime_Manual_Milky_3 = false
  end
end
function Parking_PLZ_Update(variableName, value)
  if variableName == "IsParking" and value == 0 then
    if true == isNearMonsterCheck() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_ISNEARMONSTERCHECK"), 4)
      FGlobal_ServantIcon_IsNearMonster_Effect(true)
      _AudioPostEvent_SystemUiForXBOX(8, 14)
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VEHICLE_PARKING_PLZ"))
    end
  end
end
function isNearMonsterCheck()
  local distance = 3000
  local isNearMonsterCount = getNearMonsterCharacterKeyList(distance)
  if isNearMonsterCount > 0 then
    return true
  else
    return false
  end
end
registerEvent("EventChangedSelfPlayerActionVariable", "Parking_PLZ_Update")
function playerUseBed(variableName, value)
  if variableName == "IsSleepingChk" and value == 1 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_USE_BED"))
  elseif variableName == "IsSleepingChk" and value == 0 then
  else
    return
  end
end
registerEvent("EventChangedSelfPlayerActionVariable", "playerUseBed")
function FromAction_CheckedBasic()
  IsChecked_WeaponOut = true
  ShowUseTab_Func()
end
local function MiniGame_BulletCount_0()
  if ui_Value.isFirstTime_Manual_Bullet_0 then
    ControlResetPosition()
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    _panel:SetShow(true)
    _panel:SetAlpha(0)
    UIAni.AlphaAnimation(1, _panel, 0, 0.22)
    if nil ~= _ui._bulletCount and nil ~= _ui._bulletConditon and nil ~= FGlobal_BulletCheck() then
      if false == _ui._bulletCount:GetShow() or false == _ui._bulletConditon:GetShow() then
        _ui._bulletCount:SetShow(true)
        _ui._bulletConditon:SetShow(true)
      end
      _ui._bulletCount:SetPosY(750)
      _ui._bulletCount:SetPosX(1450)
      local count = selfPlayer:get():getSubResourcePoint(1)
      _ui._bulletCount:SetText(count)
      ui_Value.isFirstTime_Manual_Bullet_0 = false
      local bulletString = FGlobal_BulletCheck()
      _ui._bulletConditon:SetText(bulletString)
    end
  end
end
local function MiniGame_BulletCount_1(actorKeyRaw, isSelf)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if nil ~= _ui._bulletCount and nil ~= _ui._bulletConditon and nil ~= FGlobal_BulletCheck() then
    local count = selfPlayer:get():getSubResourcePoint(1)
    _ui._bulletCount:SetText(count)
    local bulletString = FGlobal_BulletCheck()
    _ui._bulletConditon:SetText(bulletString)
    _ui._bulletConditon:SetShow(true)
  end
end
local function MiniGame_BulletCount_2(actorKeyRaw, isSelf)
  isBulletShow = false
  Panel_Global_Manual_End(actorKeyRaw, isSelf)
  if nil ~= _ui._bulletCount and nil ~= _ui._bulletConditon and nil ~= FGlobal_BulletCheck() then
    local bulletString = FGlobal_BulletCheck()
    _ui._bulletConditon:SetText(bulletString)
    _ui._bulletConditon:SetShow(true)
  end
end
local MiniGame_BulletCount_3 = function()
  local msg = PAGetString(Defines.StringSheet_GAME, "LUA_RELOADALERT")
  Proc_ShowMessage_Ack_WithOut_ChattingMessage(msg)
end
function FGlobal_BulletShow()
  MiniGame_BulletCount_0()
end
function FGlobal_BulletCount_UiShowCheck()
  return not ui_Value.isFirstTime_Manual_Bullet_0
end
function FGlobal_BulletCheck()
  local itemWrapper = ToClient_getEquipmentItem(1)
  if nil == itemWrapper then
    return PAGetString(Defines.StringSheet_GAME, "LUA_BULLETALERT_0")
  else
    local itemSSW = itemWrapper:getStaticStatus()
    local equipType = itemSSW:getEquipType()
    if 68 == equipType then
      local endurance = itemWrapper:get():getEndurance()
      if 0 == endurance then
        return PAGetString(Defines.StringSheet_GAME, "LUA_BULLETALERT_1")
      else
        return ""
      end
    else
      return PAGetString(Defines.StringSheet_GAME, "LUA_BULLETALERT_2")
    end
  end
end
local function MiniGame_Diving_0()
  ControlResetPosition()
  _panel:SetShow(true)
  _ui.txt_Purpose:SetSize(680, 120)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DIVING_DESC_0"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_0"))
  end
  _ui.txt_Purpose:SetShow(true)
end
local function MiniGame_Diving_1()
  ControlResetPosition()
  _panel:SetShow(true)
  _ui.txt_Purpose:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DIVING_DESC_1"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_1"))
  end
end
local function MiniGame_Diving_2()
  ControlResetPosition()
  _panel:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DIVING_DESC_0"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_2"))
  end
  _ui.txt_Purpose:SetShow(true)
end
local function Tutorial_Ilezra_0()
  ControlResetPosition()
  _panel:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TUTORIAL_ILEZRA_0"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TUTORIAL_ILEZRA_0"))
  end
  _ui.txt_Purpose:SetShow(true)
end
local function Tutorial_Ilezra_1()
  ControlResetPosition()
  _panel:SetShow(true)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_TUTORIAL_ILEZRA_1"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TUTORIAL_ILEZRA_1"))
  end
  _ui.txt_Purpose:SetShow(true)
end
local function MiniGame_SummerEventCannon_1()
  ControlResetPosition()
  _panel:SetShow(true)
  _ui.txt_Purpose:SetSize(680, 120)
  if _ContentsGroup_isConsolePadControl then
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_EVENTCANNON_DESC"))
  else
    _ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_EVENTCANNON_DESC"))
  end
  _ui.txt_Purpose:SetShow(true)
end
local KeyGuide_Squat = function()
  if nil == getSelfPlayer() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    HideUseTab_Func()
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local useTab = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC")
  local x = getScreenSizeX() * 0.5 - useTab:GetSizeX()
  local y = getScreenSizeY() * 0.5 + useTab:GetSizeY() * 7
  useTab:SetPosX(x)
  useTab:SetPosY(y)
  useTab:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_SQUAT"))
  useTab:SetShow(true)
  if true == ToClient_isConsole() then
    useTab:SetShow(false)
  end
end
local KeyGuide_Down = function()
  if nil == getSelfPlayer() then
    return
  end
  if not IsSelfPlayerWaitAction() then
    HideUseTab_Func()
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local useTab = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC")
  local x = getScreenSizeX() * 0.5 - useTab:GetSizeX()
  local y = getScreenSizeY() * 0.5 + useTab:GetSizeY() * 7
  useTab:SetPosX(x)
  useTab:SetPosY(y)
  useTab:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_DOWN"))
  useTab:SetShow(true)
  if true == ToClient_isConsole() then
    useTab:SetShow(false)
  end
end
local KeyGuide_InWater = function()
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local useTab = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC")
  local x = getScreenSizeX() * 0.5 - useTab:GetSizeX()
  local y = getScreenSizeY() * 0.5 + useTab:GetSizeY() * 7
  useTab:SetPosX(x)
  useTab:SetPosY(y)
  useTab:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_INWATER"))
  useTab:SetShow(true)
end
local KeyGuide_InWaterUnset = function()
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local useTab = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC")
  local x = getScreenSizeX() * 0.5 - useTab:GetSizeX()
  local y = getScreenSizeY() * 0.5 + useTab:GetSizeY() * 7
  useTab:SetPosX(x)
  useTab:SetPosY(y)
  useTab:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_INWATER_UNSET"))
  useTab:SetShow(true)
end
local KeyGuide_Walk = function()
  if nil == getSelfPlayer() then
    return
  end
  if keyCustom_IsPressed_Action(CppEnums.ActionInputType.ActionInputType_WalkMode) then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  local useTab = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC")
  local x = getScreenSizeX() * 0.5 - useTab:GetSizeX()
  local y = getScreenSizeY() * 0.5 + useTab:GetSizeY() * 7
  useTab:SetPosX(x)
  useTab:SetPosY(y)
  useTab:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_WALK"))
  useTab:SetShow(true)
end
local ui_UseTab = {
  [0] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTabC"),
  [1] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseLantern"),
  [2] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseLanternC")
}
function PaGlobalFunc_UseTab_Show(index, isShow, text)
  if nil == ui_UseTab[index] then
    return
  end
  local x = getScreenSizeX() * 0.5 - ui_UseTab[0]:GetSizeX()
  local y = getScreenSizeY() * 0.5 + ui_UseTab[0]:GetSizeY() * 7
  ui_UseTab[index]:SetShow(isShow)
  if nil ~= text then
    ui_UseTab[index]:SetText(text)
  end
  for ii = 0, #ui_UseTab do
    if true == ui_UseTab[ii]:GetShow() then
      ui_UseTab[ii]:SetPosX(x)
      ui_UseTab[ii]:SetPosY(y)
      y = y + ui_UseTab[ii]:GetSizeY() + 5
    end
  end
end
local ConsoleKeyGuide_Packing = function()
  PaGlobalFunc_ConsoleKeyGuide_SetActionKeyGuide(Defines.ConsoleKeyGuideType.packing)
end
local ConsoleKeyGuide_Matchlock = function()
  PaGlobalFunc_ConsoleKeyGuide_SetActionKeyGuide(Defines.ConsoleKeyGuideType.matchlock)
end
local ConsoleKeyGuide_Crouch = function()
  PaGlobalFunc_ConsoleKeyGuide_SetActionKeyGuide(Defines.ConsoleKeyGuideType.crouch)
end
local ConsoleKeyGuide_Creep = function()
  PaGlobalFunc_ConsoleKeyGuide_SetActionKeyGuide(Defines.ConsoleKeyGuideType.creep)
end
local ConsoleKeyGuide_End = function()
  PaGlobalFunc_ConsoleKeyGuide_SetActionKeyGuide(nil)
end
local function Panel_Global_Manual_End(actorKeyRaw, isSelf)
  if false == isSelf then
    return
  end
  Panel_Fishing_End()
  HideUseTab_Func()
  _panel:SetShow(false)
  ui_Value.isFirstTime_Manual_Timing_0 = true
  ui_Value.isFirstTime_Manual_Timing_1 = true
  ui_Value.isFirstTime_Manual_Timing_2 = true
  ui_Value.isFirstTime_Manual_Cart_0 = true
  ui_Value.isFirstTime_Manual_Horse_Rope_0 = true
  ui_Value.isFirstTime_Manual_HorseDrop_0 = true
  ui_Value.isFirstTime_Manual_Flute_0 = true
  ui_Value.isFirstTime_Manual_Flute_1 = true
  ui_Value.isFirstTime_Manual_HerbMachine_0 = true
  ui_Value.isFirstTime_Manual_HerbMachine_1 = true
  ui_Value.isFirstTime_Manual_HerbMachine_2 = true
  ui_Value.isFirstTime_Manual_HerbMachine_3 = true
  ui_Value.isFirstTime_Manual_HerbMachine_4 = true
  ui_Value.isFirstTime_Manual_HerbMachine_5 = true
  ui_Value.isFirstTime_Manual_Buoy_0 = true
  ui_Value.isFirstTime_Manual_Buoy_1 = true
  ui_Value.isFirstTime_Manual_Buoy_2 = true
  ui_Value.isFirstTime_Manual_Buoy_3 = true
  ui_Value.isFirstTime_Manual_Milky_0 = true
  ui_Value.isFirstTime_Manual_Milky_1 = true
  ui_Value.isFirstTime_Manual_Milky_2 = true
  ui_Value.isFirstTime_Manual_Milky_3 = true
  MiniGame_Manual_Value_FishingStart = false
  GlobalValue_MiniGame_Value_HorseDrop = false
  ui_Value.isFirstTime_Manual_Drum_0 = true
  ui_Value.isFirstTime_Manual_Drum_1 = true
  ui_Value.isFirstTime_Manual_Bullet_0 = true
  IsChecked_WeaponOut = false
  ShowUseTab_Func()
  if false == ui_Value.isFirstTime_Manual_Buoy_0 or false == ui_Value.isFirstTime_Manual_Buoy_1 or false == ui_Value.isFirstTime_Manual_Buoy_2 or false == ui_Value.isFirstTime_Manual_Buoy_3 then
    _ui.txt_Command_Info:SetShow(false)
  end
  if Panel_PowerGauge:GetShow() then
    FGlobal_PowerGauge_Close()
  end
  if Panel_CannonGauge:GetShow() then
    FGlobal_CannonGauge_Close()
  end
  isCartRace = false
end
local function MiniGame_Manual_Instrument_1(actorKeyRaw, isSelf)
  Panel_Global_Manual_End(actorKeyRaw, isSelf)
end
ActionChartEventBindFunction(201, MiniGame_Manual_Timing_0)
ActionChartEventBindFunction(202, MiniGame_Manual_Timing_1)
ActionChartEventBindFunction(203, MiniGame_Manual_Timing_2)
ActionChartEventBindFunction(204, MiniGame_Manual_Timing_3)
ActionChartEventBindFunction(221, MiniGame_Manual_Cart_0)
ActionChartEventBindFunction(222, MiniGame_Manual_Cart_Race)
ActionChartEventBindFunction(231, MiniGame_Manual_HorseDrop_0)
ActionChartEventBindFunction(232, MiniGame_Manual_Horse_Rope_0)
ActionChartEventBindFunction(241, MiniGame_Manual_Flute_0)
ActionChartEventBindFunction(242, MiniGame_Manual_Flute_1)
ActionChartEventBindFunction(251, MiniGame_Manual_HerbMachine)
ActionChartEventBindFunction(252, MiniGame_Manual_HerbMachine_0)
ActionChartEventBindFunction(253, MiniGame_Manual_HerbMachine_1)
ActionChartEventBindFunction(254, MiniGame_Manual_HerbMachine_2)
ActionChartEventBindFunction(255, MiniGame_Manual_HerbMachine_3)
ActionChartEventBindFunction(256, MiniGame_Manual_HerbMachine_4)
ActionChartEventBindFunction(257, MiniGame_Manual_HerbMachine_5)
ActionChartEventBindFunction(261, MiniGame_Manual_Reset_Buoy)
ActionChartEventBindFunction(262, MiniGame_Manual_Buoy_0)
ActionChartEventBindFunction(263, MiniGame_Manual_Buoy_1)
ActionChartEventBindFunction(264, MiniGame_Manual_Buoy_2)
ActionChartEventBindFunction(265, MiniGame_Manual_Buoy_3)
ActionChartEventBindFunction(271, MiniGame_Manual_Milky_0)
ActionChartEventBindFunction(272, MiniGame_Manual_Milky_1)
ActionChartEventBindFunction(273, MiniGame_Manual_Milky_2)
ActionChartEventBindFunction(274, MiniGame_Manual_Milky_3)
ActionChartEventBindFunction(291, MiniGame_Manual_Drum_0)
ActionChartEventBindFunction(292, MiniGame_Manual_Drum_1)
ActionChartEventBindFunction(293, MiniGame_Manual_Instrument_0)
ActionChartEventBindFunction(294, MiniGame_Manual_Instrument_1)
ActionChartEventBindFunction(350, MiniGame_BulletCount_0)
ActionChartEventBindFunction(351, MiniGame_BulletCount_1)
ActionChartEventBindFunction(352, MiniGame_BulletCount_2)
ActionChartEventBindFunction(353, MiniGame_BulletCount_3)
ActionChartEventBindFunction(370, MiniGame_Diving_0)
ActionChartEventBindFunction(371, MiniGame_Diving_1)
ActionChartEventBindFunction(372, MiniGame_Diving_2)
ActionChartEventBindFunction(400, MiniGame_SummerEventCannon_1)
ActionChartEventBindFunction(410, KeyGuide_Squat)
ActionChartEventBindFunction(411, KeyGuide_Down)
ActionChartEventBindFunction(412, KeyGuide_InWater)
ActionChartEventBindFunction(413, KeyGuide_Walk)
ActionChartEventBindFunction(414, KeyGuide_InWaterUnset)
ActionChartEventBindFunction(501, Tutorial_Ilezra_0)
ActionChartEventBindFunction(502, Tutorial_Ilezra_1)
ActionChartEventBindFunction(701, ConsoleKeyGuide_Packing)
ActionChartEventBindFunction(705, ConsoleKeyGuide_Matchlock)
ActionChartEventBindFunction(708, ConsoleKeyGuide_Crouch)
ActionChartEventBindFunction(709, ConsoleKeyGuide_Creep)
ActionChartEventBindFunction(799, ConsoleKeyGuide_End)
ActionChartEventBindFunction(9998, FromAction_CheckedBasic)
ActionChartEventBindFunction(9999, Panel_Global_Manual_End)
Global_Manual_Initialize()
