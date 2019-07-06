IsChecked_WeaponOut = false
local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local ui = {
  _obsidian = UI.getChildControl(Panel_Global_Manual, "Static_Obsidian"),
  _obsidian_B = UI.getChildControl(Panel_Global_Manual, "Static_Obsidian_B"),
  _obsidian_Text = UI.getChildControl(Panel_Global_Manual, "StaticText_Obsidian_B"),
  _purposeText = UI.getChildControl(Panel_Global_Manual, "StaticText_Purpose"),
  _purposeText2 = UI.getChildControl(Panel_Global_Manual, "MultilineText_Purpose"),
  _button_Q = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Q"),
  _button_W = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_W"),
  _button_A = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_A"),
  _button_S = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_S"),
  _button_D = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_D"),
  _button_E = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_E"),
  _button_F = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_F"),
  _button_Tab = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Tab"),
  _button_Shift = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Shift"),
  _button_Space = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Space"),
  _m0 = UI.getChildControl(Panel_Global_Manual, "StaticText_M0"),
  _m1 = UI.getChildControl(Panel_Global_Manual, "StaticText_M1"),
  _mBody = UI.getChildControl(Panel_Global_Manual, "StaticText_Mouse_Body"),
  _horse_Icon = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Horse_0"),
  _horse_Icon_Title = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Horse_Title"),
  _cart_Icon_Title = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Cart_Title"),
  _flute_Icon_Title = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Flute_Title"),
  _steal_Icon_Title = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Steal_Title"),
  _milky_Icon_Title = UI.getChildControl(Panel_Global_Manual, "Static_Minigame_Milky_Title"),
  _horseCancel = UI.getChildControl(Panel_Global_Manual, "StaticText_Cancel"),
  _bulletCount = UI.getChildControl(Panel_Global_Manual, "StaticText_BulletCount")
}
ui._bulletConditon = UI.getChildControl(ui._bulletCount, "StaticText_BulletCondition")
local uiPress = {
  _button_Q = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Q_2"),
  _button_W = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_W_2"),
  _button_A = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_A_2"),
  _button_S = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_S_2"),
  _button_D = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_D_2"),
  _button_E = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_E_2"),
  _button_F = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_F_2"),
  _button_Tab = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Tab_2"),
  _button_Shift = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Shift_2"),
  _button_Space = UI.getChildControl(Panel_Global_Manual, "StaticText_Btn_Space_2"),
  _m0 = UI.getChildControl(Panel_Global_Manual, "StaticText_M0_2"),
  _m1 = UI.getChildControl(Panel_Global_Manual, "StaticText_M1_2")
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
local ui_UseTab = {
  [0] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseTab"),
  [1] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseLantern"),
  [2] = UI.getChildControl(Panel_OnlyPerframeUsed, "StaticText_UseLanternC")
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
local function reposition()
  PaGlobal_GlobalManual_RepositionBulletCount()
  local x = getScreenSizeX() * 0.5 - ui_UseTab[0]:GetSizeX()
  local y = getScreenSizeY() * 0.5 + ui_UseTab[0]:GetSizeY() * 7
  for ii = 0, #ui_UseTab do
    if true == ui_UseTab[ii]:GetShow() then
      ui_UseTab[ii]:SetPosX(x)
      ui_UseTab[ii]:SetPosY(y)
      y = y + ui_UseTab[ii]:GetSizeY() + 5
    end
  end
end
function PaGlobal_GlobalManual_RepositionBulletCount()
  if nil == ui._bulletCount then
    return
  end
  if false == ui._bulletCount:GetShow() then
    return
  end
  ui._bulletCount:SetPosX(Panel_PvpMode:GetPosX() - ui._bulletCount:GetSizeX())
  ui._bulletCount:SetPosY(Panel_PvpMode:GetPosY() - Panel_PvpMode:GetSizeY() + 10)
end
local function Global_Manual_Initialize()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_Global_Manual:SetSize(scrX, scrY)
  Panel_Global_Manual:SetPosX(0)
  Panel_Global_Manual:SetPosY(50)
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  for _, v in pairs(uiPress) do
    v:SetShow(false)
    v:ComputePos()
  end
end
function Panel_GlobalManual_ScreenResize()
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_Global_Manual:SetSize(scrX, scrY)
  Panel_Global_Manual:SetPosX(0)
  Panel_Global_Manual:SetPosY(50)
  for _, v in pairs(ui) do
    v:ComputePos()
  end
  for _, v in pairs(uiPress) do
    v:ComputePos()
  end
  reposition()
end
local function MiniGame_Manual_Timing_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_0"))
    ui._horse_Icon_Title:SetShow(true)
    ui._horseCancel:SetShow(true)
    uiPress._m0:SetShow(true)
    ui._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Timing_0 = false
  end
end
local function MiniGame_Manual_Timing_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_1"))
    ui._horse_Icon_Title:SetShow(true)
    ui._horse_Icon:SetShow(false)
    ui_Value.isFirstTime_Manual_Timing_1 = false
  end
end
local function MiniGame_Manual_Timing_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Timing_2 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TIMING_2"))
    ui._horse_Icon_Title:SetShow(true)
    uiPress._button_W:SetShow(true)
    ui._button_A:SetShow(true)
    ui._button_S:SetShow(true)
    ui._button_D:SetShow(true)
    ui_Value.isFirstTime_Manual_Timing_2 = false
  end
end
local function MiniGame_Manual_Timing_3(actorKeyRaw, isSelf)
  uiPress._button_Space:SetShow(true)
  uiPress._button_Space:SetAlpha(0)
  uiPress._button_Space:SetFontAlpha(0)
  uiPress._button_Space:AddEffect("fUI_Horse_Space_01A", false, 0, 0)
  UIAni.AlphaAnimation(1, uiPress._button_Space, 0.5, 0.75)
end
local function MiniGame_Manual_Cart_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Cart_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText2:SetShow(true)
    ui._purposeText2:SetSize(800, 95)
    ui._purposeText2:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_CART_TITLE"))
    ui._cart_Icon_Title:SetShow(true)
    uiPress._button_W:SetShow(true)
    uiPress._button_A:SetShow(true)
    ui._button_S:SetShow(true)
    uiPress._button_D:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Cart_0 = false
  end
end
local isCartRace = false
local function MiniGame_Manual_Cart_Race(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Cart_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText2:SetShow(true)
    ui._purposeText2:SetSize(800, 95)
    ui._purposeText2:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_CART_TITLE"))
    ui._cart_Icon_Title:SetShow(true)
    uiPress._button_W:SetShow(true)
    uiPress._button_A:SetShow(true)
    ui._button_S:SetShow(true)
    uiPress._button_D:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Cart_0 = false
    isCartRace = true
  end
end
function FGlobal_isPlaying_CartRace()
  return isCartRace
end
local function MiniGame_Manual_Horse_Rope_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Horse_Rope_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HORSEROPE_0"))
    ui._horse_Icon_Title:SetShow(true)
    ui_Value.isFirstTime_Manual_Horse_Rope_0 = false
  end
end
local function MiniGame_Manual_HorseDrop_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HorseDrop_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HORSEDROP_0"))
    ui._horse_Icon_Title:SetShow(true)
    uiPress._button_W:SetShow(true)
    ui._button_A:SetShow(true)
    uiPress._button_S:SetShow(true)
    ui._button_D:SetShow(true)
    ui_Value.isFirstTime_Manual_HorseDrop_0 = false
    GlobalValue_MiniGame_Value_HorseDrop = true
  end
end
local function MiniGame_Manual_Flute_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Flute_0 == true and not IsHideMiniGameManual() then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_0"))
    ui._flute_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    ui._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Flute_0 = false
  end
end
local function MiniGame_Manual_Flute_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Flute_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1"))
    ui._flute_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Flute_0 = true
    ui_Value.isFirstTime_Manual_Flute_1 = false
  end
end
local function MiniGame_Manual_Drum_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Drum_0 == true and not IsHideMiniGameManual() then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DRUM_0"))
    ui._flute_Icon_Title:SetShow(true)
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_Drum_0 = false
    ui_Value.isFirstTime_Manual_Drum_1 = true
  end
end
local function MiniGame_Manual_Drum_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Drum_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_1"))
    ui._flute_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Drum_0 = true
    ui_Value.isFirstTime_Manual_Drum_1 = false
  end
end
local function MiniGame_Manual_Instrument_0(actorKeyRaw, isSelf)
  if Panel_Global_Manual:GetShow() then
    return
  end
  if not IsHideMiniGameManual() then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_RHYTHM_2"))
    ui._flute_Icon_Title:SetShow(true)
    uiPress._button_Space:SetShow(true)
  end
end
local function MiniGame_Manual_HerbMachine_0(actorKeyRaw, isSelf)
  ui_Value.isFirstTime_Manual_HerbMachine_0 = true
  herbMachine_SetGameEndCount(5)
  if ui_Value.isFirstTime_Manual_HerbMachine_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(0/5)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_0 = false
  end
end
local function MiniGame_Manual_HerbMachine_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(1/5)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_1 = false
  end
end
local function MiniGame_Manual_HerbMachine_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_2 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(2/5)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_2 = true
  end
end
local function MiniGame_Manual_HerbMachine_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_3 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(3/5)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_3 = true
  end
end
local function MiniGame_Manual_HerbMachine_4(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_4 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_0") .. " " .. "(4/5)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_4 = true
  end
end
local function MiniGame_Manual_HerbMachine_5(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_5 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    FGlobal_MiniGame_HerbMachine()
    ToClient_MinigameResult(2, true)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_HERBMACHINE_1"))
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_5 = true
  end
end
local MiniGame_Manual_HerbMachine = function()
  Panel_Minigame_HerbMachine_ResetCount()
end
local function MiniGame_Manual_Hammer_0(actorKeyRaw, isSelf)
  ui_Value.isFirstTime_Manual_HerbMachine_0 = true
  herbMachine_SetGameEndCount(1)
  if ui_Value.isFirstTime_Manual_HerbMachine_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_SUMMERHAMMER_0") .. " " .. "(0/1)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_0 = false
  end
end
local function MiniGame_Manual_Hammer_End(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_HerbMachine_5 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    FGlobal_MiniGame_SummerHammerGame()
    ToClient_MinigameResult(2, true)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_SUMMERHAMMER_1"))
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_HerbMachine_5 = true
  end
end
local function MiniGame_Manual_Buoy_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(0/3)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_Buoy_0 = false
  end
end
local function MiniGame_Manual_Buoy_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(1/3)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_Buoy_1 = false
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local function MiniGame_Manual_Buoy_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_2 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_0") .. " " .. "(2/3)")
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_Buoy_2 = false
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local function MiniGame_Manual_Buoy_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Buoy_3 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_BUOY_1"))
    uiPress._button_Space:SetShow(true)
    ui_Value.isFirstTime_Manual_Buoy_3 = true
    Panel_MiniGame_Buoy_WaitInitMode()
  end
end
local MiniGame_Manual_Reset_Buoy = function()
  Panel_Minigame_Buoy_ResetCount()
end
local function MiniGame_Manual_Milky_0(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_0 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY1"))
    ui._milky_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    ui._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Milky_0 = false
  end
end
local function MiniGame_Manual_Milky_1(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_1 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_READY2"))
    ui._milky_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Milky_0 = true
    ui_Value.isFirstTime_Manual_Milky_1 = false
  end
end
local function MiniGame_Manual_Milky_2(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_2 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME_MILKCOW_FAIL"))
    ui._milky_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
    ui_Value.isFirstTime_Manual_Milky_0 = true
    ui_Value.isFirstTime_Manual_Milky_1 = false
    ui_Value.isFirstTime_Manual_Milky_2 = false
  end
end
local function MiniGame_Manual_Milky_3(actorKeyRaw, isSelf)
  if ui_Value.isFirstTime_Manual_Milky_3 == true then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._purposeText:SetShow(true)
    ui._purposeText:AddEffect("UI_QustComplete01", false, 0, 0)
    ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MINIGAME__MILKCOW_SUCCESS"))
    ui._milky_Icon_Title:SetShow(true)
    uiPress._m0:SetShow(true)
    uiPress._m1:SetShow(true)
    ui._mBody:SetShow(true)
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
      audioPostEvent_SystemUi(8, 14)
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
local isBulletShow = false
local function MiniGame_BulletCount_0()
  if ui_Value.isFirstTime_Manual_Bullet_0 then
    for _, v in pairs(ui) do
      v:SetShow(false)
      v:ComputePos()
    end
    for _, v in pairs(uiPress) do
      v:SetShow(false)
      v:ComputePos()
    end
    local selfPlayer = getSelfPlayer()
    if nil == selfPlayer then
      return
    end
    Panel_Global_Manual:SetShow(true)
    Panel_Global_Manual:SetAlpha(0)
    UIAni.AlphaAnimation(1, Panel_Global_Manual, 0, 0.22)
    ui._bulletCount:SetShow(true)
    ui._bulletCount:SetPosX(Panel_PvpMode:GetPosX() - ui._bulletCount:GetSizeX())
    ui._bulletCount:SetPosY(Panel_PvpMode:GetPosY() - Panel_PvpMode:GetSizeY() + 10)
    local count = selfPlayer:get():getSubResourcePoint(1)
    ui._bulletCount:SetText(count)
    ui_Value.isFirstTime_Manual_Bullet_0 = false
    local bulletString = EquipMent_BulletCheck()
    ui._bulletConditon:SetText(bulletString)
    ui._bulletConditon:SetShow(true)
  end
end
local function MiniGame_BulletCount_1(actorKeyRaw, isSelf)
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  local count = selfPlayer:get():getSubResourcePoint(1)
  ui._bulletCount:SetText(count)
  local bulletString = EquipMent_BulletCheck()
  ui._bulletConditon:SetText(bulletString)
  ui._bulletConditon:SetShow(true)
end
local function MiniGame_BulletCount_2(actorKeyRaw, isSelf)
  isBulletShow = false
  Panel_Global_Manual_End(actorKeyRaw, isSelf)
  local bulletString = EquipMent_BulletCheck()
  ui._bulletConditon:SetText(bulletString)
  ui._bulletConditon:SetShow(true)
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
local function MiniGame_Diving_0()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText2:SetShow(true)
  ui._purposeText2:SetSize(800, 70)
  ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_0"))
end
local function MiniGame_Diving_1()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText:SetShow(true)
  ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_1"))
end
local function MiniGame_Diving_2()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText:SetShow(true)
  ui._purposeText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_DIVING_DESC_2"))
end
local function Tutorial_Ilezra_0()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText2:SetShow(true)
  ui._purposeText2:SetSize(800, 70)
  ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TUTORIAL_ILEZRA_0"))
end
local function Tutorial_Ilezra_1()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText2:SetShow(true)
  ui._purposeText2:SetSize(800, 70)
  ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_TUTORIAL_ILEZRA_1"))
end
local function MiniGame_SummerEventCannon_1()
  for _, v in pairs(ui) do
    v:SetShow(false)
    v:ComputePos()
  end
  Panel_Global_Manual:SetShow(true)
  ui._purposeText2:SetShow(true)
  ui._purposeText2:SetSize(800, 70)
  ui._purposeText2:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBALMANUAL_EVENTCANNON_DESC"))
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
  PaGlobalFunc_UseTab_Show(0, true, PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_SQUAT"))
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
  PaGlobalFunc_UseTab_Show(0, true, PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_DOWN"))
end
local KeyGuide_InWater = function()
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobal_SkillCommand_CheckRegion(false)
  PaGlobal_CommandGuide_Show(true, 1)
end
local KeyGuide_InWaterUnset = function()
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobal_SkillCommand_CheckRegion(false)
  PaGlobal_CommandGuide_Show(true, 2)
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
  PaGlobalFunc_UseTab_Show(0, true, PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_MANUAL_KEYGUIDE_WALK"))
end
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
local KeyGuide_CattleGate = function(actorKeyRaw, isSelf)
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobal_SkillCommand_CheckRegion(false)
  PaGlobal_CommandGuide_Show(true, 3)
end
local KeyGuide_Ladder = function(actorKeyRaw, isSelf)
  if nil == getSelfPlayer() then
    return
  end
  local targetPanel = getSelfPlayer():get():getUIPanel()
  if nil == targetPanel then
    return
  end
  PaGlobal_SkillCommand_CheckRegion(false)
  PaGlobal_CommandGuide_Show(true, 4)
end
local function Panel_Global_Manual_End(actorKeyRaw, isSelf)
  if false == isSelf then
    return
  end
  Panel_Fishing_End()
  HideUseTab_Func()
  PaGlobalFunc_SniperGame_EndSniperGame()
  PaGlobalFunc_SniperReload_Close()
  uiPress._button_Space:ComputePos()
  Panel_Global_Manual:SetShow(false)
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
  if Panel_PowerGauge:GetShow() then
    FGlobal_PowerGauge_Close()
  end
  if Panel_CannonGauge:GetShow() then
    FGlobal_CannonGauge_Close()
  end
  if Panel_CommandGuide:GetShow() then
    PaGlobal_CommandGuide_Show(false, 0)
  end
  PaGlobal_SkillCommand_CheckRegion(true)
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
ActionChartEventBindFunction(258, MiniGame_Manual_Hammer_0)
ActionChartEventBindFunction(259, MiniGame_Manual_Hammer_End)
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
ActionChartEventBindFunction(413, KeyGuide_Walk)
ActionChartEventBindFunction(412, KeyGuide_InWater)
ActionChartEventBindFunction(414, KeyGuide_InWaterUnset)
ActionChartEventBindFunction(415, KeyGuide_CattleGate)
ActionChartEventBindFunction(416, KeyGuide_Ladder)
ActionChartEventBindFunction(501, Tutorial_Ilezra_0)
ActionChartEventBindFunction(502, Tutorial_Ilezra_1)
ActionChartEventBindFunction(9998, FromAction_CheckedBasic)
ActionChartEventBindFunction(9999, Panel_Global_Manual_End)
Global_Manual_Initialize()
registerEvent("onScreenResize", "Panel_GlobalManual_ScreenResize")
