local MGKT = CppEnums.MiniGameKeyType
local UIColor = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local MiniGame_Rhythm_Drum = {
  _ui = {
    stc_RhythmBG = UI.getChildControl(Panel_RhythmGame_Drum, "Static_rhythmBG"),
    stc_RhythmDrumNote = UI.getChildControl(Panel_RhythmGame_Drum, "Static_rhythmNote"),
    stc_RhythmCursor = UI.getChildControl(Panel_RhythmGame_Drum, "Static_rhythmCursor"),
    stc_Result_Good = UI.getChildControl(Panel_RhythmGame_Drum, "Static_Result_Good"),
    stc_Result_Bad = UI.getChildControl(Panel_RhythmGame_Drum, "Static_Result_Bad"),
    txt_Purpose = UI.getChildControl(Panel_RhythmGame_Drum, "StaticText_Purpose")
  }
}
local isRhythmGamePlay = false
_drum_nowCursorPosX = 0
_drum_justCursorPosX = 0
local scrX = getScreenSizeX()
local scrY = getScreenSizeY()
local cursorFixedValue = 5
local cursorIndexValue = 42
local cursorIndex = 0
local culledSize = 10
local hideSize = 20
local noteSpeed = 75
local noteBuffer = {}
local notePosBuffer = {}
local bufferMax = 50
local bufferIndex = 1
local createTime = 0.5
local currentSumTime = 0
local panelSetPosY = -180
function MiniGame_Rhythm_Drum:init()
  Panel_RhythmGame_Drum:SetShow(false, false)
  self._ui.stc_Console_Control_BG = UI.getChildControl(self._ui.stc_RhythmBG, "Static_Console_Control_BG")
  self._ui.stc_PC_Control_BG = UI.getChildControl(self._ui.stc_RhythmBG, "Static_PC_Control_BG")
  if _ContentsGroup_isConsolePadControl then
    self._ui.stc_LBButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_LB")
    self._ui.stc_RBButton = UI.getChildControl(self._ui.stc_Console_Control_BG, "Static_RB")
    self._ui.stc_Console_Control_BG:SetShow(true)
    self._ui.stc_PC_Control_BG:SetShow(false)
  else
    self._ui.stc_PC_Control_BG:SetShow(true)
    self._ui.stc_Console_Control_BG:SetShow(false)
    self._ui.stc_MouseBody_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_L")
    self._ui.stc_MouseBody_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_MouseBody_R")
    self._ui.stc_M0_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_L")
    self._ui.stc_M0_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_L_Btn_R")
    self._ui.stc_M1_L = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_L")
    self._ui.stc_M1_R = UI.getChildControl(self._ui.stc_PC_Control_BG, "Static_R_Btn_R")
  end
  self._ui.txt_Purpose:SetPosX(scrX / 2 - self._ui.txt_Purpose:GetSizeX() / 2)
  self._ui.txt_Purpose:SetPosY(scrY / 2 + 240)
  if _ContentsGroup_isConsolePadControl then
    self._ui.txt_Purpose:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_XBOX1_GLOBALMANUAL_DRUM_1"))
  else
  end
  self._ui.stc_RhythmDrumNote:SetShow(false)
  for idx = 1, bufferMax do
    local control = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_RhythmGame_Drum, "Static_rhythmNote_" .. idx)
    CopyBaseProperty(self._ui.stc_RhythmDrumNote, control)
    control:SetShow(false)
    noteBuffer[idx] = control
  end
end
function MiniGame_Rhythm_Drum:drumNote_posSetting(control, index)
  CopyBaseProperty(self._ui.stc_RhythmDrumNote, control)
  if index == 1 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + 5)
  elseif index == 2 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmDrumNote:GetSizeX() * (index - 1) + 5)
  elseif index == 3 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmDrumNote:GetSizeX() * (index - 1) + 8)
  elseif index == 4 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmDrumNote:GetSizeX() * (index - 1) + 10)
  elseif index == 5 then
    control:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2 + self._ui.stc_RhythmDrumNote:GetSizeX() * (index - 1) + 12)
  end
end
function MiniGame_Rhythm_Drum:getRhythm()
  local prevIndex = bufferIndex
  bufferIndex = bufferIndex + 1
  if bufferMax < bufferIndex then
    bufferIndex = 1
  end
  local rv = noteBuffer[prevIndex]
  notePosBuffer[prevIndex] = math.random(1, 5)
  self:drumNote_posSetting(rv, notePosBuffer[prevIndex])
  return rv
end
function Rhythm_Drum_RePosition()
  scrX = getScreenSizeX()
  scrY = getScreenSizeY()
  Panel_RhythmGame_Drum:SetSize(scrX, scrY)
  Panel_RhythmGame_Drum:SetPosY(panelSetPosY)
end
local isFailed = false
function RhythmGame_Drum_UpdateFunc(fDeltaTime)
  local self = MiniGame_Rhythm_Drum
  currentSumTime = currentSumTime + fDeltaTime
  local posOver = self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() - hideSize - self._ui.stc_RhythmDrumNote:GetSizeY() + 5
  local culledPos = self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() - hideSize - culledSize - self._ui.stc_RhythmDrumNote:GetSizeY()
  for key, control in pairs(noteBuffer) do
    control:SetPosY(control:GetPosY() + fDeltaTime * noteSpeed)
    if posOver < control:GetPosY() then
      local value = control:GetPosY() - posOver
      control:SetAlpha((hideSize - value) / hideSize)
      if value > hideSize then
        control:SetShow(false)
      end
    elseif culledPos < control:GetPosY() and nil ~= notePosBuffer[key] and notePosBuffer[key] == cursorIndex + 1 and control:GetShow() then
      getSelfPlayer():get():SetMiniGameResult(1)
      control:SetShow(false)
      if isFailed == false then
        _AudioPostEvent_SystemUiForXBOX(11, 2)
        self._ui.txt_Purpose:SetShow(false)
        self._ui.stc_Result_Bad:SetShow(true)
        self._ui.stc_Result_Bad:ResetVertexAni()
        self._ui.stc_Result_Bad:SetVertexAniRun("Bad_Ani_Start", true)
        self._ui.stc_Result_Bad:SetVertexAniRun("Bad_Ani", true)
        isFailed = true
      end
    end
  end
  local count = 0
  if createTime < currentSumTime then
    currentSumTime = currentSumTime - createTime
    while (0 == count or 1 < math.random(0, 5)) and count < 2 do
      local targetControl = self:getRhythm()
      targetControl:SetShow(true)
      count = count + 1
    end
  end
end
function Panel_Minigame_Rhythm_Drum_Start()
  local self = MiniGame_Rhythm_Drum
  Interaction_Close()
  PaGlobal_ConsoleQuickMenu:widgetClose()
  Panel_ConsoleKeyGuide:SetShow(false)
  self._ui.stc_Result_Bad:SetShow(false)
  if _ContentsGroup_isConsolePadControl then
    cursorIndex = 2
  else
    cursorIndex = 3
  end
  isFailed = false
  bufferIndex = 1
  for k, v in pairs(noteBuffer) do
    self:drumNote_posSetting(v, 1)
  end
  Panel_RhythmGame_Drum:SetShow(true, false)
  self:drumNote_posSetting(self._ui.stc_RhythmDrumNote, 4)
  self._ui.stc_RhythmBG:SetPosX(scrX / 2 - self._ui.stc_RhythmBG:GetSizeX() / 2)
  self._ui.stc_RhythmCursor:SetPosX(scrX / 2 - self._ui.stc_RhythmCursor:GetSizeX() / 2)
  self._ui.stc_RhythmCursor:SetPosY(self._ui.stc_RhythmBG:GetPosY() + self._ui.stc_RhythmBG:GetSizeY() / 2 + 124)
  _drum_nowCursorPosX = self._ui.stc_RhythmCursor:GetPosX()
  _drum_justCursorPosX = self._ui.stc_RhythmCursor:GetPosX()
  self._ui.stc_Result_Bad:SetPosX(scrX / 2 - self._ui.stc_Result_Bad:GetSizeX() / 2)
  self._ui.stc_Result_Bad:SetPosY(scrY / 2 - panelSetPosY)
end
function Panel_Minigame_Rhythm_Drum_End()
  PaGlobal_ConsoleQuickMenu:widgetOpen()
  Panel_ConsoleKeyGuide:SetShow(true)
  Panel_RhythmGame_Drum:SetShow(false, false)
end
function MiniGame_Rhythm_Drum:rhythmCursorAlign()
  self._ui.stc_RhythmCursor:SetPosX(self._ui.stc_RhythmBG:GetPosX() + cursorFixedValue + cursorIndexValue * cursorIndex)
end
function MiniGame_Rhythm_Drum:Panel_Minigame_Rhythm_Drum_GaugeMove_Left()
  if false == _ContentsGroup_isConsolePadControl then
    self._ui.stc_M0_R:ResetVertexAni()
    self._ui.stc_M0_R:SetVertexAniRun("Ani_Color_Right", true)
  end
  cursorIndex = cursorIndex - 1
  if cursorIndex < 0 then
    cursorIndex = 0
  end
  self:rhythmCursorAlign()
end
function MiniGame_Rhythm_Drum:Panel_Minigame_Rhythm_Drum_GaugeMove_Right()
  if false == _ContentsGroup_isConsolePadControl then
    self._ui.stc_M1_R:ResetVertexAni()
    self._ui.stc_M1_R:SetVertexAniRun("Ani_Color_Right", true)
  end
  cursorIndex = cursorIndex + 1
  if cursorIndex > 4 then
    cursorIndex = 4
  end
  self:rhythmCursorAlign()
end
function MiniGame_Rhythm_Drum_KeyPress(keyType)
  local self = MiniGame_Rhythm_Drum
  if isFailed == true then
    return
  end
  if MGKT.MiniGameKeyType_M0 == keyType then
    self:Panel_Minigame_Rhythm_Drum_GaugeMove_Left()
  elseif MGKT.MiniGameKeyType_M1 == keyType then
    self:Panel_Minigame_Rhythm_Drum_GaugeMove_Right()
  end
end
function MiniGame_Rhythm_Drum_PadKeyPress(keyType)
  local self = MiniGame_Rhythm_Drum
  if isFailed == true or false == Panel_RhythmGame_Drum:GetShow() then
    return
  end
  if __eQuickTimeEventPadType_LB == keyType then
    self:Panel_Minigame_Rhythm_Drum_GaugeMove_Left()
  elseif __eQuickTimeEventPadType_RB == keyType then
    self:Panel_Minigame_Rhythm_Drum_GaugeMove_Right()
  end
end
function FromClient_luaLoadComplete_MiniGame_Rhythm_Drum_Init()
  local self = MiniGame_Rhythm_Drum
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_MiniGame_Rhythm_Drum_Init")
registerEvent("EventActionMiniGamePadDownOnce", "MiniGame_Rhythm_Drum_PadKeyPress")
registerEvent("EventActionMiniGameKeyDownOnce", "MiniGame_Rhythm_Drum_KeyPress")
registerEvent("onScreenResize", "Rhythm_Drum_RePosition")
Panel_RhythmGame_Drum:RegisterUpdateFunc("RhythmGame_Drum_UpdateFunc")
Rhythm_Drum_RePosition()
