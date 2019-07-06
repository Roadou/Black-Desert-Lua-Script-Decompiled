local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
Panel_BattleGauge:SetShow(false, false)
local MiniGame_BattleGauge = {
  _ui = {
    stc_BattleGauge_BG = UI.getChildControl(Panel_BattleGauge, "Static_GaugeBG"),
    stc_InfoBG = UI.getChildControl(Panel_BattleGauge, "Static_InFoTextBG"),
    txt_RemainTime = UI.getChildControl(Panel_BattleGauge, "StaticText_RemainTimeText"),
    txt_Timer = UI.getChildControl(Panel_BattleGauge, "StaticText_Timer"),
    stc_PC_Control_BG = UI.getChildControl(Panel_BattleGauge, "Static_PC_Control_BG"),
    stc_Console_Control_BG = UI.getChildControl(Panel_BattleGauge, "Static_Console_Control_BG")
  }
}
local sumDeltaTime = 0
local currentPercent = 50
local remainTime = 11
function MiniGame_BattleGauge:init()
  self._ui.txt_TitleText = UI.getChildControl(self._ui.stc_InfoBG, "StaticText_TitleText")
  self._ui.progress2_MyGauge = UI.getChildControl(self._ui.stc_BattleGauge_BG, "Progress2_MyGauge")
  self._ui.stc_ButtonB = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_B")
  self._ui.stc_SpaceBar = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_SpaceBar")
  self._ui.stc_SpaceBar_Effect = UI.getChildControl(self._ui.stc_SpaceBar, "Static_SpaceBar_Effect")
  self._ui.stc_MyGauge_Head = UI.getChildControl(self._ui.progress2_MyGauge, "Progress2_MyBar_Head")
  self._ui.stc_MiddleLine = UI.getChildControl(self._ui.stc_BattleGauge_BG, "Static_MiddleLine")
  self._ui.stc_Result_Win = UI.getChildControl(self._ui.stc_BattleGauge_BG, "Static_Result_Win")
  self._ui.stc_Result_Lose = UI.getChildControl(self._ui.stc_BattleGauge_BG, "Static_Result_Lose")
  if _ContentsGroup_isConsolePadControl then
    self._ui.stc_SpaceBar:SetShow(false)
    self._ui.stc_ButtonB:SetShow(true)
  else
    self._ui.stc_SpaceBar:SetShow(true)
    self._ui.stc_ButtonB:SetShow(false)
  end
  Panel_BattleGauge:RegisterUpdateFunc("BattleGauge_UpdatePerFrame")
  BattleGauge_RePosition()
end
function BattleGauge_RePosition()
  local self = MiniGame_BattleGauge
  local scrX = getScreenSizeX()
  local scrY = getScreenSizeY()
  Panel_BattleGauge:SetSize(scrX, scrY)
  Panel_BattleGauge:SetPosX(0)
  Panel_BattleGauge:SetPosY(0)
  for _, v in pairs(self._ui) do
    v:ComputePos()
  end
end
function MiniGame_BattleGauge:setProgress(isSetProgress)
  if currentPercent < 0 then
    currentPercent = 0
  elseif currentPercent > 100 then
    currentPercent = 100
  end
  self._ui.progress2_MyGauge:SetProgressRate(currentPercent)
  if isSetProgress then
    self._ui.progress2_MyGauge:SetCurrentProgressRate(currentPercent)
  end
end
function Panel_Minigame_BattleGauge_Start()
  local self = MiniGame_BattleGauge
  PaGlobal_ConsoleQuickMenu:widgetClose()
  self._ui.txt_TitleText:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_TitleText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_BATTLEGAUGE_REPEAT_B"))
  self._ui.stc_MiddleLine:AddEffect("fUI_Repair01B", true, 0, 0)
  remainTime = 11
  Panel_BattleGauge:SetShow(true)
  currentPercent = 50
  self:setProgress(true)
  Panel_ConsoleKeyGuide:SetShow(false)
end
function BattleGauge_UpdateGauge(deltaTime)
  local self = MiniGame_BattleGauge
  currentPercent = currentPercent + 6
  self:setProgress(false)
  if _ContentsGroup_isConsolePadControl then
  else
    self._ui.stc_SpaceBar:ResetVertexAni()
    self._ui.stc_SpaceBar_Effect:ResetVertexAni()
    self._ui._spaceBar:SetVertexAniRun("Ani_Color_Space", true)
    self._ui.stc_SpaceBar_Effect:SetVertexAniRun("Ani_Color_SpaceEff", true)
  end
end
function BattleGauge_UpdatePerFrame(deltaTime)
  local self = MiniGame_BattleGauge
  sumDeltaTime = sumDeltaTime + deltaTime * 35
  local number, underZero = math.modf(sumDeltaTime)
  sumDeltaTime = underZero
  currentPercent = currentPercent - number
  self:setProgress(false)
  BattleGauge_EndTimer(deltaTime)
  if currentPercent >= 51 then
    self._ui.stc_Result_Win:SetShow(true)
    self._ui.stc_Result_Lose:SetShow(false)
  elseif currentPercent <= 50 then
    self._ui.stc_Result_Lose:SetShow(true)
    self._ui.stc_Result_Win:SetShow(false)
  end
end
function BattleGauge_EndTimer(deltaTime)
  local self = MiniGame_BattleGauge
  remainTime = remainTime - deltaTime
  local remainSec = math.floor(remainTime)
  if remainTime > 0 then
    self._ui.txt_Timer:SetText(remainSec .. PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_TIME_SECOND"))
  elseif remainTime <= 0 then
    if currentPercent >= 50 then
      _AudioPostEvent_SystemUiForXBOX(11, 1)
      getSelfPlayer():get():SetMiniGameResult(0)
    elseif currentPercent <= 50 then
      _AudioPostEvent_SystemUiForXBOX(11, 2)
      getSelfPlayer():get():SetMiniGameResult(3)
    end
    Panel_Minigame_BattleGauge_End()
  end
end
function Panel_Minigame_SpaceBar(keyType)
  if MGKT.MiniGameKeyType_Space == keyType then
    BattleGauge_UpdateGauge(deltaTime)
  end
end
function Panel_Minigame_BattleGauge_PadPress(keyType)
  if __eQuickTimeEventPadType_B == keyType then
    BattleGauge_UpdateGauge(deltaTime)
  end
end
function BattleGauge_Result(timer)
  local remainTime = timer
end
function Panel_Minigame_BattleGauge_End()
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  PaGlobalFunc_ConsoleKeyGuide_On()
  Panel_BattleGauge:SetShow(false)
end
function FromClient_luaLoadComplete_MiniGame_BattleGauge_Init()
  local self = MiniGame_BattleGauge
  self:init()
end
registerEvent("EventActionMiniGameKeyDownOnce", "Panel_Minigame_SpaceBar")
registerEvent("EventActionMiniGamePadDownOnce", "Panel_Minigame_BattleGauge_PadPress")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_BattleGauge_Init")
registerEvent("onScreenResize", "BattleGauge_RePosition")
